SUBDIRS := $(wildcard */)
SUBDIRS := $(patsubst %/,%,$(SUBDIRS))

all: clean compile

compile:
	@for dir in $(SUBDIRS); do \
		echo "Compilando $$dir/main.typ..."; \
		./typst compile $$dir/main.typ; \
	done

clean:
	rm ./*/*.pdf

.PHONY: all
