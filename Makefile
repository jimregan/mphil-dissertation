# Basic Makefile for LaTeX projects by Markus Kuhn

# requires GNU make
SHELL=/bin/bash

.DELETE_ON_ERROR:

# Build rules for LaTeX-related files
%.dvi: %.tex
	(xelatex $<; makeindex $*; makeglossaries $*; bibtex $*; xelatex $<)
	while grep 'Rerun to get ' $*.log ; do (makeindex $*; makeglossaries $*; bibtex $*; xelatex $<); done
	-killall -USR1 -r xdvi || true

%.ps: %.dvi
	dvips -Ppdf -G0 $*.dvi

%.pdf: %.tex
	(xelatex $<; makeindex $*; makeglossaries $*; bibtex $*; xelatex $<)
	while grep 'Rerun to get ' $*.log ; do (makeindex $*; makeglossaries $*; bibtex $*; xelatex $<); done

# Examples of rules for converting various graphics formats into EPS or PDF
# (so we can always clean intermediate EPS or PDF versions of figures)
PNMTOPS=pnmtops -rle -noturn -nosetpage
%.eps: %.png
	pngtopnm $< | $(PNMTOPS) > $@
%.eps: %.tif
	tifftopnm $< | $(PNMTOPS) > $@
%.eps: %.gif
	giftopnm $< | $(PNMTOPS) > $@
%.eps: %.jpg
	djpeg $< | $(PNMTOPS) > $@
%.eps: %.pbm
	$(PNMTOPS) $< > $@
%.eps: %.pgm
	$(PNMTOPS) $< > $@
%.eps: %.ppm
	$(PNMTOPS) $< > $@
%.pdf: %.eps
	epstopdf --outfile=$@ $<
%.ps: %.fig
	fig2dev -L ps -c -z A4 $< $@
%.eps: %.fig
	fig2dev -L eps $< $@
%.pstex %.pstex_t: %.fig
	fig2dev -L pstex_t -p $*.pstex $< $*.pstex_t
	fig2dev -L pstex $< $*.pstex
%.pdftex %.pdftex_t: %.fig
	fig2dev -L pdftex_t -p $*.pdftex $< $*.pdftex_t
	fig2dev -L pdftex $< $*.pdftex

all: dissertation.pdf   # or thesis.ps

clean:
	rm -f *~ *.dvi *.log *.bak *.aux *.toc *.ps *.eps *.blg *.bbl
	rm -f *.glg *.glo *.gls *.idx *.ild *.ind *.ist *.ilg *.iso *.out
	rm -f *.pstex *.pstex_t
	rm -f dissertation.pdf
