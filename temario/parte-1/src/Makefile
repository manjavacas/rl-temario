TYP_FILES := $(shell find . -type f -name "*.typ")

EXEC := ./typst

all: $(TYP_FILES:.typ=.pdf)

%.pdf: %.typ
	$(EXEC) compile $< $@
	mv $@ ..

clean:
	rm -f ../*.pdf
