<?xml version="1.0" encoding="ISO-8859-2" ?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/1999/xhtml"
	version="1.0">
	<xsl:variable name="lang-attr">en</xsl:variable>
	<xsl:variable name="output.method">xml</xsl:variable>
	<xsl:variable name="html.stylesheet">mercurial.css</xsl:variable>
	<xsl:variable name="table.borders.with.css" select="1"/>
	<xsl:variable name="html.ext" select="'.html'"/>
	<xsl:variable name="html.cellpadding" select="'5'" />
	<xsl:variable name="section.autolabel" select="1" />
	<xsl:output method="xml"
		indent="yes"
		encoding="UTF-8" />

</xsl:stylesheet>
