.PHONY: all build clean

all: build

build:
	latexmk -xelatex *.tex

clean:
	latexmk -c -silent
