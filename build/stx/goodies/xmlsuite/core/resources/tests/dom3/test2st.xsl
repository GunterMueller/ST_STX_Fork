<?xml version="1.0" encoding="ISO-8859-1"?>
<!-- $Header: /opt/data/cvs/stx/goodies/xmlsuite/resources/tests/dom3/test2st.xsl,v 1.4 2007-01-10 20:49:34 vranyj1 Exp $ -->

<xsl:stylesheet 
    version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:t="http://www.w3.org/2001/DOM-Test-Suite/Level-3">

  <xsl:import href="test2st-code.xsl"/>
    <xsl:variable name="single-quote">'</xsl:variable>

  <xsl:output method="text" encoding="UTF-8"/>


  <xsl:template name="class-name">
    <xsl:text>W3CDOM3</xsl:text><xsl:value-of select="$module"/><xsl:text>Tests</xsl:text>
  </xsl:template>



  

  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="text()" />
  <xsl:template match="text()" mode="body"/>

  <xsl:template match="t:test-case">
<xsl:text>"{ Package: 'stx:goodies/xmlsuite' }"

"{ NameSpace: XMLv2 }"

AbstractW3CDOM3TestCase subclass:#</xsl:text><xsl:call-template name="class-name"/><xsl:text>
        instanceVariableNames:'doc'
        classVariableNames:''
        poolDictionaries:''
        category:'XML Suite-Tests W3C'
! 

!</xsl:text><xsl:call-template name="class-name"/><xsl:text> class methodsFor:'defaults'!

module
    ^'</xsl:text><xsl:value-of select="$module"/><xsl:text>'
! !

!</xsl:text><xsl:call-template name="class-name"/><xsl:text> methodsFor:'W3C tests'!

</xsl:text>
<xsl:apply-templates select="t:test"/>
<xsl:text> !</xsl:text>
  </xsl:template>


  <xsl:template match="t:metadata">
    <xsl:text>&#10;&#09;"</xsl:text>
    <xsl:value-of select="translate(t:description,'&quot;',' ')"/>
    <xsl:text>&#10;</xsl:text>
    
    <xsl:for-each select="t:creator">
      <xsl:text>&#09;&#09;Creator: </xsl:text><xsl:value-of select="."/>
      <xsl:text>&#10;</xsl:text>
    </xsl:for-each>
    
    <xsl:for-each select="t:contributor">
      <xsl:text>&#09;&#09;Autor </xsl:text>
      <xsl:value-of select="."/>
      <xsl:text>&#10;</xsl:text>
    </xsl:for-each>
    
    <xsl:for-each select="t:subject">
      <xsl:text>&#09;&#09;Subject </xsl:text>
      <xsl:value-of select="@resource"/>
      <xsl:text>&#10;</xsl:text>
    </xsl:for-each>
    
    <xsl:for-each select="t:source">
    <xsl:text>&#09;&#09; Resource</xsl:text>
    <xsl:value-of select="@resource"/>
    <xsl:text>&#10;</xsl:text>
    </xsl:for-each>
    <xsl:text>&#09;"&#10;</xsl:text>
  </xsl:template>
  
  <xsl:template match="t:test">
    
    <xsl:text>test_</xsl:text><xsl:value-of select="@name"/>
    <xsl:apply-templates select="t:metadata"/>
    <xsl:text>&#09;|&#10;</xsl:text>
    <xsl:apply-templates select="t:var" mode="var-declaration"/>
    <xsl:text>&#09;|&#10;</xsl:text>
    <xsl:apply-templates mode="body" />
    <xsl:text>&#10;!&#10;&#10;</xsl:text>    
  </xsl:template>


  <xsl:template match="t:var" mode="var-declaration">
    <xsl:text>&#09;  </xsl:text>
    <xsl:value-of select="@name"/>
    <xsl:text> "</xsl:text>
    <xsl:call-template name="idltype-to-smalltalkclass">
      <xsl:with-param name="typename" select="@type"/>
    </xsl:call-template>
    <xsl:text>"&#10;</xsl:text>
  </xsl:template>

  

  <xsl:template name="idltype-to-smalltalkclass">
    <xsl:param name="typename" />
    <xsl:choose>
      <xsl:when test="$typename = 'DOMString'"><xsl:text>String</xsl:text></xsl:when>
      <xsl:when test="$typename = 'boolean'"><xsl:text>Boolean</xsl:text></xsl:when>
      <xsl:when test="$typename = 'int'"><xsl:text>SmallInteger</xsl:text></xsl:when>

      <xsl:otherwise><xsl:value-of select="$typename"/></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
