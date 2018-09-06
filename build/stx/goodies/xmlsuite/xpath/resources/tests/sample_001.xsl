<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">

	<xsl:template match="/">
		<xsl:text>
</xsl:text><xsl:apply-templates select="/root//@*"/>

	</xsl:template>
	
	<xsl:template match="tag">tag<xsl:value-of select="position()"/><xsl:text> </xsl:text></xsl:template>
	<xsl:template match="subtag">subtag<xsl:value-of select="position()"/><xsl:text> </xsl:text></xsl:template>
	<xsl:template match="root">root<xsl:value-of select="position()"/><xsl:text> </xsl:text></xsl:template>
	<xsl:template match="emp">emp<xsl:value-of select="position()"/><xsl:text> </xsl:text></xsl:template>
	<xsl:template match="b">b<xsl:value-of select="position()"/><xsl:text> </xsl:text></xsl:template>
    <xsl:template match="text()"></xsl:template>
	
</xsl:stylesheet>