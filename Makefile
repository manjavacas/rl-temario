# Compilación de las diapositivas del temario (Typst + Typslides).
#
# Cada tema vive en  temario/parte-N/src/<tema>/<nombre>.typ
# y se compila en    temario/parte-N/<nombre>.pdf
#
#   make                  compila los PDF desactualizados (admite -j)
#   make parte-2          compila solo una parte
#   make temario/parte-1/0-intro.pdf
#   make -B               fuerza la recompilación de todo
#   make list             muestra cada fuente y su PDF
#   make clean            borra los PDF generados
#   make optimize-images  reduce las imágenes nuevas (requiere Pillow)
#
# Variables:
#   TYPST=/ruta/a/typst       binario de Typst (por defecto, el del PATH)
#   FONT_PATH=/ruta/fuentes   carpeta con Fira Sans si no está instalada

TYPST     ?= typst
PYTHON    ?= python3
FONT_PATH ?=

TYPST_ARGS := $(if $(FONT_PATH),--font-path $(FONT_PATH))

SOURCES := $(sort $(wildcard temario/parte-*/src/*/*.typ))
# temario/parte-N/src/<tema>/<nombre>.typ -> temario/parte-N/<nombre>.pdf
pdf_for  = $(subst /src/$(notdir $(patsubst %/,%,$(dir $(1))))/,/,$(1:.typ=.pdf))
PDFS    := $(foreach s,$(SOURCES),$(call pdf_for,$(s)))
PARTS   := $(sort $(foreach s,$(SOURCES),$(word 2,$(subst /, ,$(s)))))

.DEFAULT_GOAL := all
.DELETE_ON_ERROR:
.PHONY: all list clean check-fonts optimize-images $(PARTS)

all: $(PDFS)

# Un PDF depende de su .typ y de las imágenes de su carpeta.
define DECK_RULE
$(call pdf_for,$(1)): $(1) $(wildcard $(dir $(1))images/*) | check-fonts
	@echo "  TYPST  $$@"
	@$$(TYPST) compile $$(TYPST_ARGS) $$< $$@
endef
$(foreach s,$(SOURCES),$(eval $(call DECK_RULE,$(s))))

define PART_RULE
$(1): $(filter temario/$(1)/%,$(PDFS))
endef
$(foreach p,$(PARTS),$(eval $(call PART_RULE,$(p))))

# Typslides usa Fira Sans; sin ella, Typst la sustituye en silencio y los PDF
# cambian de aspecto, así que mejor fallar pronto.
check-fonts:
	@$(TYPST) fonts $(TYPST_ARGS) | grep -qx 'Fira Sans' || { \
	  echo "Error: no se encuentra la fuente Fira Sans (https://fonts.google.com/specimen/Fira+Sans)."; \
	  echo "Instálala (p. ej. copiando los .ttf en ~/.local/share/fonts)"; \
	  echo "o indica su carpeta con: make FONT_PATH=/ruta/a/fuentes"; \
	  exit 1; } >&2

list:
	@$(foreach s,$(SOURCES),echo "$(s) -> $(call pdf_for,$(s))";)

clean:
	rm -f $(PDFS)

optimize-images:
	$(PYTHON) scripts/optimize_images.py temario
