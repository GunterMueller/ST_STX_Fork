#
# This Makefile generates Smalltalk/X test cases from W3C 
# XML Test Suite specifications
#

XSLTPROC	= xsltproc
XMLLINT		= xmllint
XSL		= xmltests2st.xsl

TEMPDIR		= /tmp
SOURCEDIR	= ../../..

.PHONY:	all

all:	$(SOURCEDIR)/JamesClarkXMLTests.st $(SOURCEDIR)/OASISXMLTests.st

$(SOURCEDIR)/JamesClarkXMLTests.st:
	@echo -n "Generating JamesClarkXMLTests..."
	@$(XSLTPROC) --novalid \
	    --stringparam test-suite-name xmltest \
	    --stringparam test-case-class-name JamesClarkXMLTests \
	    $(XSL) xmltest/xmltest.xml > $(SOURCEDIR)/XMLv2__JamesClarkXMLTests.st
	@echo done

$(SOURCEDIR)/OASISXMLTests.st:
	@echo -n "Generating OASISXMLTests..."
	@$(XSLTPROC) --novalid \
	    --stringparam test-suite-name oasis \
	    --stringparam test-case-class-name OASISXMLTests \
	    $(XSL) oasis/oasis.xml > $(SOURCEDIR)/XMLv2__OASISXMLTests.st
	@echo done
