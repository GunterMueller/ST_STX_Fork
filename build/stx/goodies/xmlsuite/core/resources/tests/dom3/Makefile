#
# This Makefile generates Smalltalk/X test cases from W3C 
# language independent DOM test suite
#

MODULES		= Core
XSLTPROC	= xsltproc
XMLLINT		= xmllint
XSL		= test2st.xsl

TEMPDIR		= /tmp
SOURCEDIR	= ../../..

.PHONY:	$(MODULES)

all:	$(MODULES)
	@echo All done...

*:	
	@echo -n Making $@...
	@echo \<test-case xmlns=\"http://www.w3.org/2001/DOM-Test-Suite/Level-3\" xmlns:xi=\"http://www.w3.org/2001/XInclude\"\> > $@TestCase.xml
	@for test in $@/*.xml; do echo \<xi:include href=\"$$test\"/\> >> $@TestCase.xml; done
	@echo \</test-case\> >> $@TestCase.xml
	@$(XSLTPROC) --xinclude --novalid --stringparam module $@ $(XSL) $@TestCase.xml > $(SOURCEDIR)/XMLv2__W3CDOM3$@Tests.st
	@rm $@TestCase.xml
	@echo done
