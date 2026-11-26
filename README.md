[![License: CC BY-NC 4.0](https://img.shields.io/badge/License-CC%20BY--NC%204.0-lightgrey.svg)](https://creativecommons.org/licenses/by-nc/4.0/)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.22829280.svg)](https://doi.org/10.5281/zenodo.22829280)

# Aprendizaje por refuerzo

Temario sobre **aprendizaje por refuerzo** (_reinforcement learning_) en español.

Elaborado por [Antonio Manjavacas](https://www.linkedin.com/in/antonio-manjavacas/).

## 📃 Contenidos

### Parte 1. [Introducción a RL](temario/parte-1/)

0. [Introducción](temario/parte-1/0-intro.pdf)
1. [Bandits](temario/parte-1/1-bandits.pdf)
2. [Procesos de decisión de Markov](temario/parte-1/2-mdp.pdf)

### Parte 2. [Métodos tabulares](temario/parte-2/)

3. [Programación dinámica](temario/parte-2/3-prog-din.pdf)
4. Métodos basados en muestreo\
    4.1. [Monte Carlo](temario/parte-2/4-muestreo-mc.pdf)\
    4.2. [_TD-learning_](temario/parte-2/4-muestreo-td.pdf)
5. [Planificación](temario/parte-2/5-planificacion.pdf)
6. [Resumen](temario/parte-2/6-resumen.pdf)

### Parte 3. [Métodos basados en aproximación de funciones](temario/parte-3/)

7. [Aproximación de funciones de valor](temario/parte-3/7-aprox-val.pdf)
8. [Aproximación de políticas](temario/parte-3/8-aprox-poli.pdf)

### Parte 4. [Aprendizaje por refuerzo profundo](temario/parte-4/)

> **📝 _TO-DO_**

## 📁 Material

- [Diapositivas](temario/) (elaboradas con [Typslides](https://github.com/manjavacas/typslides)).
- [Ejemplos y ejercicios](ejemplos/) referenciados a lo largo del temario.

## 🛠️ Compilación

Las fuentes de cada tema están en `temario/parte-N/src/<tema>/` y cada PDF se genera en `temario/parte-N/`. Se necesita [Typst](https://typst.app/) (probado con la versión 0.15) y la fuente [Fira Sans](https://fonts.google.com/specimen/Fira+Sans):

```bash
make            # compila los PDF desactualizados (admite -j)
make parte-2    # compila solo una parte
make -B         # recompila todo
make list       # muestra cada fuente y su PDF
```

Si Fira Sans no está instalada, puedes indicar su carpeta con `make FONT_PATH=/ruta/a/fuentes`. Los PDF son reproducibles: recompilar sin cambios genera exactamente los mismos ficheros.

Al añadir imágenes nuevas, conviene ejecutar `make optimize-images` (requiere [Pillow](https://pypi.org/project/pillow/)): reduce las que superan con creces la resolución de una diapositiva sin cambiar su tamaño en la página.

## 📚 Bibliografía

Principales fuentes empleadas en la elaboración de este temario:

- Sutton, R. S., & Barto, A. G. (2018). Reinforcement learning: An introduction. MIT Press.
- Morales, M. (2020). Grokking deep reinforcement learning. Manning Publications.
- [Coursera RL Specialization](https://www.coursera.org/specializations/reinforcement-learning).
- [RL course by David Silver](https://www.youtube.com/watch?v=2pWv7GOvuf0&list=PLqYmG7hTraZDM-OYHWgPebj2MfCFzFObQ).

## 🚀 Contribuye 

Si quieres ayudar a mejorar este proyecto, envía sugerencias o colabora reportando errores a través de _issues_.

## ✍️ Uso y licencia

Este material se distribuye bajo licencia [CC BY-NC 4.0](LICENSE).

Cita: 

```bibtex
@software{manjavacas2026rltemario,
  author       = {Manjavacas, Antonio},
  title        = {manjavacas/rl-temario: v1.0.1},
  year         = {2026},
  version      = {v1.0.1},
  publisher    = {Zenodo},
  doi          = {10.5281/zenodo.22829281},
  url          = {https://doi.org/10.5281/zenodo.22829281}
}
```
