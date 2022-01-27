SOURCES=$(wildcard */*.md *.md)
TARGETS= pdf_outputs build


all: ${SOURCES:.md=.pdf} cookbook

%.pdf: %.tex # generate pdfs for every .md file
	mkdir -p build/$(dir $@)
	mkdir -p pdf_outputs/$(dir $@)
	texfot xelatex -output-directory build/$(dir $@) build/$(shell echo $? | sed 's/.tex/_recipe.tex/g')
	mv build/$(shell echo $@ | sed 's/.pdf/_recipe.pdf/g')  pdf_outputs/$@

%.tex: %.md _templates/template.tex _templates/template_chapter.tex
	mkdir -p build/$(dir $@)
	mkdir -p pdf_outputs/$(dir $@)
	# single recipe pdfs
	pandoc --template=_templates/template.tex -t latex -f markdown-auto_identifiers $< > $(shell echo $@ | sed 's/.tex/_recipe.tex/g')
	mv $(shell echo $@ | sed 's/.tex/_recipe.tex/g') build/$(shell echo $@ | sed 's/.tex/_recipe.tex/g')
	# other template
	pandoc --template=_templates/template_chapter.tex -t latex -f markdown-auto_identifiers $< > $@
	mv $@ build/$@

#pdf_outputs/cookbook.pdf: ${SOURCES:.md=.pdf}
cookbook:
	./script.sh # from .tex slayer files generate master tex file: c.tex
	#texfot xelatex -output-directory build/$(dir $@) build/c.tex
	texfot xelatex -output-directory build build/c.tex
	cp build/c.pdf cookbook.pdf

clean:
	-rm -rf $(TARGETS)

wipe: clean
	-rm -f */*.pdf

.PHONY: all clean wipe
# .PRECIOUS: %.tex
