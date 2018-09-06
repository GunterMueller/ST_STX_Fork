<?xml version="1.0" encoding="ISO-8859-2" ?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/1999/xhtml"
	version="1.0">
	<xsl:import href="/usr/share/xml/docbook/stylesheet/nwalsh/xhtml/chunk.xsl"/>
	<!--<xsl:variable name="lang-attr">cs</xsl:variable>-->
	<xsl:variable name="default.encoding">ISO-8859-2</xsl:variable>
	<xsl:variable name="output.method">xml</xsl:variable>
	<xsl:variable name="html.stylesheet">docbook.css</xsl:variable>
	<xsl:variable name="table.borders.with.css" select="1"/>
	<xsl:variable name="html.ext" select="'.html'"/>
	<xsl:variable name="html.cellpadding" select="'5'" />
	
	<xsl:output method="xml"
		indent="yes"
		encoding="UTF-8" />
	
</xsl:stylesheet>
