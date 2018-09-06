<?xml version="1.0" encoding="ISO-8859-2" ?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:fox="http://xml.apache.org/fop/extensions"
    version="1.0">
  
  <xsl:import href="/usr/share/xml/docbook/stylesheet/db2latex/latex/docbook.xsl"/>
  
  <xsl:param name="latex.documentclass.article">a4paper,10pt</xsl:param>
  <xsl:param name="latex.use.babel">0</xsl:param>
  <xsl:param name="toc.section.depth">4</xsl:param>
  <xsl:param name="latex.article.preamble.pre">\usepackage{makeidx}
  </xsl:param>
  <xsl:param name="latex.article.preamble.post">\makeindex
  </xsl:param>



  <xsl:template match="biblioentry" mode="xref-to">
    <xsl:param name="referrer"/>
    <xsl:param name="xrefstyle"/>
    <xsl:text>[</xsl:text>
    <xsl:value-of select="$referrer/@linkend"/>
    <xsl:text>]</xsl:text> 
  </xsl:template>
  

  <xsl:template match="article/artheader|article/articleinfo" mode="standalone.article">
    <xsl:apply-templates select="keywordset" />
    <xsl:apply-templates select="legalnotice" />
    <xsl:apply-templates select="abstract"/>
    <xsl:call-template name="toc" />
  </xsl:template>


  <xsl:template match="indexterm">
    <xsl:text>\index{</xsl:text>
    <xsl:value-of select="./primary" />
    <xsl:if  test="./secondary">
      <xsl:text>!</xsl:text>
      <xsl:value-of select="./secondary" />
      <xsl:if  test="./tertiary">
	<xsl:text>!</xsl:text>
	<xsl:value-of select="./tertiary" />	
      </xsl:if>
    </xsl:if>

    <xsl:text>}</xsl:text>
      
  </xsl:template>

  <xsl:template match="index">
    <xsl:text>
      %\printindex
    </xsl:text>
  </xsl:template>


</xsl:stylesheet>
