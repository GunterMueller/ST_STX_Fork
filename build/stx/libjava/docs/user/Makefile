#!/usr/bin/make

XSLTPROC	= xsltproc
LATEX		= pdfcslatex

# Defines root of DocBook-XSL style scheets
DOCBOOK_XSL =

SOURCE_DIR	= .
DOCUMENT	= stx_libjava_user

DOCUMENT_SOURCE	= $(SOURCE_DIR)/$(DOCUMENT).xml
DOCUMENT_SOURCES= $(SOURCE_DIR)/*.xml

PROFILED_DOCUMENT_SOURCE = $(SOURCE_DIR)/$(DOCUMENT).xml.profiled

PROFILE_STYLE=styles/profile.xsl

OUTPUT_DIR=output

HTML_DIR=$(OUTPUT_DIR)/html
HTML_STYLE=styles/html.unix.xsl

PDF_DIR=$(OUTPUT_DIR)/pdf
PDF_STYLE=styles/latex.xsl

# A directory where to install HTML help
HELP_DIR=../../../doc/online/english/programming

default: html

html: $(HTML_DIR)/index.html $(HTML_DIR)/stx_libjava_user.css

pdf: $(PDF_DIR)/$(DOCUMENT).pdf

$(PROFILED_DOCUMENT_SOURCE):	$(DOCUMENT_SOURCES) $(SCHEMAS) $(PROFILE_STYLE)
	$(XSLTPROC)  --xinclude -o $(PROFILED_DOCUMENT_SOURCE) \
	$(PROFILE_STYLE) $(DOCUMENT_SOURCE)



#---- HTML format --------------------------
$(HTML_DIR):
	mkdir -p $(HTML_DIR)

$(HTML_DIR)/stx_libjava_user.css: $(HTML_DIR) styles/stx_libjava_user.css
	mkdir -p $(HTML_DIR)
	cp styles/stx_libjava_user.css $(HTML_DIR)/stx_libjava_user.css

$(HTML_DIR)/index.html: $(HTML_DIR) $(PROFILED_DOCUMENT_SOURCE) $(HTML_STYLE) $(HTML_DIR)/stx_libjava_user.css $(HTML_DIR)/images
	$(XSLTPROC) -o $(HTML_DIR)/ $(HTML_STYLE) $(PROFILED_DOCUMENT_SOURCE)

$(HTML_DIR)/images: $(HTML_DIR)
	mkdir -p $(HTML_DIR)/images
	-cp -a images/* $(HTML_DIR)/images

# Special target to install HTML documentation to
html-install: html
	mkdir -p $(HELP_DIR)
	cp -ar $(HTML_DIR)/* $(HELP_DIR)

#---- PDF format ---------------------------
$(PDF_DIR):
	mkdir -p $(PDF_DIR)

$(PDF_DIR)/$(DOCUMENT).pdf: $(PDF_DIR) $(PDF_DIR)/$(DOCUMENT).tex
	mkdir $(PDF_DIR) && \
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
	rm -rf $(HTML_DIR)
	rm -rf $(PDF_DIR)
	find ./ -name '*~' -exec rm {} \;
	rm -f $(SOURCE_DIR)/*.xml.tmp
	rm -f $(PROFILED_DOCUMENT_SOURCE)

clobber: clean

archive:
	zip -r /tmp/$(DOCUMENT).zip ./*

publish: html
	scp -r $(HTML_DIR)/* fray1.fit.cvut.cz:/home/zam/vranyj1/www_users/data/tmp/libjava-doc
