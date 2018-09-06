#!/usr/bin/make

XSLTPROC	= xsltproc
LATEX		= pdfcslatex

SOURCE_DIR	= source
DOCUMENT	= using-xmlsuite

DOCUMENT_SOURCE	= $(SOURCE_DIR)/$(DOCUMENT).xml
DOCUMENT_SOURCES= \
	$(SOURCE_DIR)/using-xmlsuite.xml \
	$(SOURCE_DIR)/examples/*.xml

PROFILED_DOCUMENT_SOURCE = $(SOURCE_DIR)/$(DOCUMENT).xml.profiled

PROFILE_STYLE=styles/profile.xsl

HTML_STYLE=styles/html.xsl
HTML_DIR=html

PDF_DIR=pdf
PDF_STYLE=styles/latex.xsl

default: html

html: $(HTML_DIR)/index.html

pdf: $(PDF_DIR)/$(DOCUMENT).pdf

$(PROFILED_DOCUMENT_SOURCE):	$(DOCUMENT_SOURCES) $(SCHEMAS) $(PROFILE_STYLE)
	$(XSLTPROC)  --xinclude -o $(PROFILED_DOCUMENT_SOURCE) \
		$(PROFILE_STYLE) $(DOCUMENT_SOURCE)



#---- HTML format --------------------------
$(HTML_DIR)/index.html: $(PROFILED_DOCUMENT_SOURCE) $(HTML_STYLE)
	$(XSLTPROC) -o $(HTML_DIR)/ $(HTML_STYLE) $(PROFILED_DOCUMENT_SOURCE)

#---- PDF format ---------------------------
$(PDF_DIR)/$(DOCUMENT).pdf: $(PDF_DIR)/$(DOCUMENT).tex
	cd $(PDF_DIR) && \
	$(LATEX) $(DOCUMENT).tex && \
	makeindex using-xmlsuite.idx && \
	$(LATEX) $(DOCUMENT).tex && \
	makeindex using-xmlsuite.idx && \
	$(LATEX) $(DOCUMENT).tex

$(PDF_DIR)/$(DOCUMENT).tex:	$(PROFILED_DOCUMENT_SOURCE) $(PDF_STYLE)
	$(XSLTPROC) -o $(PDF_DIR)/$(DOCUMENT).tex $(PDF_STYLE) $(PROFILED_DOCUMENT_SOURCE)


#---- SUPPORT -----------------------------
clean:
	rm -f $(HTML_DIR)/*.html
	rm -f  $(PDF_DIR)/$(DOCUMENT).*
	find ./ -name '*~' -exec rm {} \;
	rm -f $(SOURCE_DIR)/*.xml.tmp 
	rm -f $(PROFILED_DOCUMENT_SOURCE)

archive:
	zip -r /tmp/$(DOCUMENT).zip ./*
