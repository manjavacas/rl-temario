SUBDIRS := $(wildcard */)
SUBDIRS := $(patsubst %/,%,$(SUBDIRS))

all: clean compile

compile:
	@for dir in $(SUBDIRS); do \
		for file in $$(find $$dir -name '*.typ'); do \
			base_name=$$(basename $$file .typ); \
			echo "Compilando $$file..."; \
			./typst compile $$file ../$$base_name.pdf; \
		done; \
	done

clean:
	rm -f ../*.pdf

.PHONY: all
