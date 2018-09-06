SHELL=/bin/bash


MAIN=xquery-dateso2010
BIB=references

SOURCES= \
	*.tex 



pdf: $(MAIN).pdf

ps: $(MAIN).ps


$(BIB).bbl : $(MAIN).tex 
	pdflatex $(MAIN).tex
	bibtex $(MAIN)


$(MAIN).pdf : $(MAIN).tex $(BIB).bib  $(BIB).bbl ${SOURCES}
	pdflatex $(MAIN).tex
	pdflatex $(MAIN).tex


$(MAIN).ps : $(MAIN).tex $(BIB).bib  $(BIB).bbl ${SOURCES}
	latex $(MAIN).tex
	latex $(MAIN).tex
	dvips $(MAIN).dvi -o $(MAIN).ps


clean : 
	rm -rf *~ text/*~ *.aux *.log *.blg $(MAIN).pdf $(MAIN).ps *.toc *.bbl *.dvi *.out *.bak
