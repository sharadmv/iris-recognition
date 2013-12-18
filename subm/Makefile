RCSFLAGS= -l
MAIN= paper
TEXPARTS= *.tex
BIBPARTS= *.bib
LPR = pspr # or change to 'qpr -q ps3'
POSTSCRIPT= dvips -f
FIGPARTS= FIG/*.eps FIG/*.pdf FIG/*.fig FIG/*.jpg FIG/*.png
STYPARTS= psfig.sty sig-alternate-sigmod06.cls
MISC= makefile README dotest
LATEX= pdflatex

$(MAIN).pdf: $(MAIN).tex $(TEXPARTS) $(BIBPARTS)
	$(LATEX) $(MAIN).tex
	bibtex $(MAIN)
	$(LATEX) $(MAIN).tex
	$(LATEX) $(MAIN).tex
	cp paper.pdf ~/Downloads/

try:
	$(LATEX) $(MAIN).tex

checkout:
	co $(RCSFLAGS) $(MAIN).tex $(TEXPARTS)

checkin:
	ci $(RCSFLAGS) -f $(MAIN).tex $(TEXPARTS)

unlock:
	rcs -u  $(TEXPARTS)

clean:
	rm -f *.dvi $(MAIN).ps *.bbl *.aux *.log *.blg *.toc all.tar* uu \
	*~ *.bak 

spotless: clean
	rm -f $(MAIN).ps $(MAIN).pdf
	rm -rf TST


all.tar:
	tar cvfh all.tar $(MAIN).tex $(TEXPARTS) $(BIBPARTS) \
	$(FIGPARTS) $(STYPARTS) $(MISC)

dt: spotless
	dotest

uu: all.tar
	gzip all.tar
	uuencode all.tar.gz all.tar.gz > uu

bundle.all: $(TEXPARTS) 
	bundle  README $(TEXPARTS) $(BIBPARTS) makefile > bundle.all
