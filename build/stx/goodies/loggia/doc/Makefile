
DOCUMENT=loggia

SOURCE=source/${DOCUMENT}.xml

#XSLTPROC=java -classpath /usr/share/java/saxon.jar com.icl.saxon.StyleSheet
XSLTPROC=xsltproc

HTML_STYLE=styles/html.xsl
HTML_DIR=html

PDF_DIR=pdf
PDF_FILE=${PDF_DIR}/${DOCUMENT}.pdf
PDF_STYLE=styles/latex.xsl

LATEX=pdflatex


default: html

html:	html/index.html
pdf:	${PDF_FILE}

html/index.html:	${SOURCE}
#	for SAXON
#	cd ${HTML_DIR} && ${XSLTPROC} ../${SOURCE} ../${HTML_STYLE} 
#	for xsltproc
	cd ${HTML_DIR} && ${XSLTPROC}  ../${HTML_STYLE} ../${SOURCE}

${PDF_FILE}:	${SOURCE}
#	for SAXON
#	${XSLTPROC} -o ${PDF_DIR}/${DOCUMENT}.tex ${SOURCE} ${PDF_STYLE}
#	for xsltproc
	${XSLTPROC} -o ${PDF_DIR}/${DOCUMENT}.tex ${PDF_STYLE} ${SOURCE}
	
	cd ${PDF_DIR} && ${LATEX} ${DOCUMENT}.tex && ${LATEX} ${DOCUMENT}.tex && ${LATEX} ${DOCUMENT}.tex

clean:
	rm -rf ${HTML_DIR}/*.html
	rm -f  ${PDF_FILE}
	rm -f  *~ source/*~

archive:
	zip -r /tmp/using-xmlsuite.zip ./*
