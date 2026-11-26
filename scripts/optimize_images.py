#!/usr/bin/env python3
"""Reduce el peso de las imágenes del temario sin pérdida visible de calidad.

Uso: python3 scripts/optimize_images.py [--dry-run] [RUTA ...]   (por defecto: temario)

Para cada PNG/JPEG:
- Si es claramente mayor que una diapositiva completa a CAP px de ancho, la
  reduce por un factor entero (promedio de área: sin halos, y los colores planos
  siguen planos, lo que comprime mucho mejor que un remuestreo no entero).
- Conserva el tamaño físico: ajusta los DPI en la misma proporción, porque
  Typst usa píxeles/DPI como tamaño de las imágenes sin anchura explícita.
- PNG: quita el canal alfa si es opaco, pasa a escala de grises si no hay color
  visible y prueba una paleta de 256 colores (solo si PSNR >= 40 dB). Se queda
  con la variante que menos ocupa sumando el fichero y su coste dentro del PDF
  (Typst expande las paletas a RGB y comprime los píxeles en bruto).
- JPEG: solo se recodifica si se reduce.

Solo reescribe un fichero si se reduce o si ahorra más de un 10 %, así que
volver a ejecutarlo sobre imágenes ya optimizadas no las toca.
Requiere Pillow (la paleta usa libimagequant si está disponible).
"""
import argparse
import io
import math
import sys
import warnings
import zlib
from concurrent.futures import ProcessPoolExecutor
from pathlib import Path

from PIL import Image, ImageChops, ImageOps, ImageStat, features

warnings.simplefilter("ignore", Image.DecompressionBombWarning)
Image.MAX_IMAGE_PIXELS = None

CAP = 2560          # ancho (px) de una diapositiva 16:9 completa
MIN_PSNR = 40.0     # calidad mínima exigida a la paleta
TYPST_DPI = 72      # DPI que asume Typst si la imagen no los indica
MIN_GAIN = 0.9      # sin reducción, solo se reescribe si ahorra >10 % (cada cambio engorda git)
QUANTIZE = Image.Quantize.LIBIMAGEQUANT if features.check("libimagequant") else None


def on_white(im):
    bg = Image.new("RGBA", im.size, (255, 255, 255, 255))
    return Image.alpha_composite(bg, im.convert("RGBA")).convert("RGB")


def psnr(a, b):
    diff = ImageChops.difference(on_white(a), on_white(b))
    mse = sum(v ** 2 for v in ImageStat.Stat(diff).rms) / 3
    return math.inf if mse == 0 else 20 * math.log10(255 / math.sqrt(mse))


def is_gray(im, tol=24, max_frac=1e-4):
    """Cierto si (casi) ningún píxel visible tiene color."""
    r, g, b = im.convert("RGB").split()
    chroma = ImageChops.lighter(ImageChops.lighter(ImageChops.difference(r, g), ImageChops.difference(g, b)),
                                ImageChops.difference(r, b))
    if im.mode == "RGBA":
        chroma = ImageChops.multiply(chroma, im.getchannel("A").point(lambda v: 255 if v > 16 else 0))
    return sum(chroma.histogram()[tol + 1:]) <= max_frac * im.width * im.height


def pdf_cost(im):
    """Bytes aproximados que ocupa la imagen dentro del PDF generado por Typst."""
    if im.mode == "P":
        im = im.convert("RGBA")
    if im.mode in ("RGBA", "LA"):
        alpha = im.getchannel("A")
        base = len(zlib.compress(im.convert(im.mode[:-1]).tobytes(), 6))
        return base if alpha.getextrema()[0] == 255 else base + len(zlib.compress(alpha.tobytes(), 6))
    return len(zlib.compress(im.tobytes(), 6))


def reduce(im):
    n = max(round(im.width / CAP), round(im.height / (CAP * 9 / 16)))
    if n < 2:
        return im
    if im.mode in ("RGBA", "LA"):  # alfa premultiplicado: evita bordes oscuros
        return im.convert(im.mode[:-1] + "a").reduce(n).convert(im.mode)
    return im.reduce(n)


def scaled_dpi(dpi, old, new):
    if new == old:
        return dpi
    base = dpi or (TYPST_DPI, TYPST_DPI)
    return tuple(max(1.0, d * n / o) for d, n, o in zip(base, new, old))


def encode(im, fmt, dpi, **kw):
    buf = io.BytesIO()
    im.save(buf, fmt, optimize=True, **({"dpi": dpi} if dpi else {}), **kw)
    return buf.getvalue()


def optimize_png(im, dpi):
    if im.mode == "P":
        im = im.convert("RGBA")
    old = im.size
    im = reduce(im)
    if im.mode in ("RGBA", "LA") and im.getchannel("A").getextrema()[0] == 255:
        im = im.convert(im.mode[:-1])
    if im.mode in ("RGB", "RGBA") and is_gray(im):
        im = im.convert("LA" if im.mode == "RGBA" else "L")
    variants = [im]
    if QUANTIZE is not None and im.mode in ("RGB", "RGBA"):
        for dither in (Image.Dither.NONE, Image.Dither.FLOYDSTEINBERG):
            q = im.quantize(256, method=QUANTIZE, dither=dither)
            if psnr(im, q) >= MIN_PSNR:
                variants.append(q)
    dpi = scaled_dpi(dpi, old, im.size)
    return im.size != old, min((len(d) + pdf_cost(v), d) for v in variants for d in [encode(v, "PNG", dpi)])


def process(path, dry_run=False):
    size = path.stat().st_size
    with Image.open(path) as src:
        fmt, dpi = src.format, src.info.get("dpi")
        im = ImageOps.exif_transpose(src) if fmt == "JPEG" else src.copy()
    if fmt == "PNG" and im.mode in ("L", "LA", "P", "RGB", "RGBA"):
        reduced, (cost, data) = optimize_png(im, dpi)
        if not reduced and cost >= MIN_GAIN * (size + pdf_cost(im)):
            return path, size, size
    elif fmt == "JPEG" and im.mode in ("L", "RGB"):
        small = reduce(im)
        if small.size == im.size:
            return path, size, size
        new_dpi = scaled_dpi(dpi, im.size, small.size)
        data = encode(small, "JPEG", tuple(round(d) for d in new_dpi) if new_dpi else None, quality=90)
    else:
        return path, size, size
    if not dry_run:
        path.write_bytes(data)
    return path, size, len(data)


def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("paths", nargs="*", type=Path, default=[Path("temario")])
    ap.add_argument("--dry-run", action="store_true", help="no modifica ningún fichero")
    args = ap.parse_args()
    files = sorted({f for p in args.paths for f in ([p] if p.is_file() else p.rglob("*"))
                    if f.suffix.lower() in (".png", ".jpg", ".jpeg")})
    before = after = 0
    with ProcessPoolExecutor() as pool:
        for path, old, new in pool.map(process, files, [args.dry_run] * len(files)):
            before, after = before + old, after + new
            if new != old:
                print(f"{old / 1e6:7.2f} MB -> {new / 1e6:6.2f} MB  {path}")
    print(f"{len(files)} imágenes: {before / 1e6:.1f} MB -> {after / 1e6:.1f} MB")


if __name__ == "__main__":
    sys.exit(main())
