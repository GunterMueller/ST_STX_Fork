<?xml version="1.0" encoding="ISO-8859-2" ?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:fo="http://www.w3.org/1999/XSL/Format"
	xmlns:fox="http://xml.apache.org/fop/extensions"
	version="1.0">
	<xsl:import href="/usr/share/xml/docbook/stylesheet/nwalsh/fo/docbook.xsl"/>

	<xsl:variable name="generate.toc">1</xsl:variable>
	
	<xsl:output method="xml"
		indent="yes"
		encoding="UTF-8" />
	
</xsl:stylesheet>
