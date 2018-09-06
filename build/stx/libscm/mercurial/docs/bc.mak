#!/usr/bin/make

XSLTPROC	= xsltproc
LATEX		= pdfcslatex

# Defines root of DocBook-XSL style scheets
DOCBOOK_XSL = C:\msys64\usr\share\xml\docbook\xsl-stylesheets-1.78.1


SOURCE_DIR	= .
DOCUMENT	= mercurial

DOCUMENT_SOURCE	= $(SOURCE_DIR)\$(DOCUMENT).xml
DOCUMENT_SOURCES= $(SOURCE_DIR)\*.xml

PROFILED_DOCUMENT_SOURCE = $(SOURCE_DIR)\$(DOCUMENT).xml.profiled

PROFILE_STYLE=styles\profile.xsl

OUTPUT_DIR=output

HTML_DIR=$(OUTPUT_DIR)\html
HTML_STYLE=styles\html.win32.xsl

PDF_DIR=$(OUTPUT_DIR)\pdf
PDF_STYLE=styles/latex.xsl

# A directory where to install HTML help
HELP_DIR=..\..\..\doc\online\english\help\HG

default: html

html: $(HTML_DIR)\index.html $(HTML_DIR)\mercurial.css

pdf: $(PDF_DIR)\$(DOCUMENT).pdf

$(PROFILED_DOCUMENT_SOURCE):	$(DOCUMENT_SOURCES) $(SCHEMAS) $(PROFILE_STYLE)
	$(XSLTPROC)  --xinclude -o $(PROFILED_DOCUMENT_SOURCE) \
	$(PROFILE_STYLE) $(DOCUMENT_SOURCE)


$(OUTPUT_DIR)\nul:
	md $(OUTPUT_DIR)

#---- HTML format --------------------------
$(HTML_DIR)\nul: $(OUTPUT_DIR)\nul
	md $(HTML_DIR)

$(HTML_DIR)\mercurial.css: $(HTML_DIR)\nul styles\mercurial.css
	c:\msys64\usr\bin\mkdir.exe -p $(HTML_DIR)
	copy styles\mercurial.css $(HTML_DIR)\mercurial.css

$(HTML_DIR)\index.html: $(HTML_DIR)\nul $(PROFILED_DOCUMENT_SOURCE) $(HTML_STYLE) $(HTML_DIR)\mercurial.css $(HTML_DIR)\images
	c:\msys64\usr\bin\mkdir.exe -p $(HTML_DIR)
	$(XSLTPROC) $(HTML_STYLE) $(PROFILED_DOCUMENT_SOURCE)
	move /Y *.html $(HTML_DIR)

$(HTML_DIR)\images\nul: $(HTML_DIR)\nul
	md $(HTML_DIR)\images

$(HTML_DIR)\images: $(HTML_DIR)\images\nul
	c:\msys64\usr\bin\mkdir.exe -p $(HTML_DIR)\images
	xcopy /S /Q /Y images\*.* $(HTML_DIR)\images\

# Special target to install HTML documentation to
$(HELP_DIR)\nul:	
	md $(HELP_DIR)

html-install: html $(HELP_DIR)\nul
	c:\msys64\usr\bin\mkdir.exe -p $(HELP_DIR)
	xcopy /S /Q /Y $(HTML_DIR)\*.* $(HELP_DIR)\


#---- SUPPORT -----------------------------
clean:
	-rmdir /S /Q $(OUTPUT_DIR)
	-del $(SOURCE_DIR)/*.tmp
	-del $(PROFILED_DOCUMENT_SOURCE)

archive:
	zip -r /tmp/$(DOCUMENT).zip ./*
