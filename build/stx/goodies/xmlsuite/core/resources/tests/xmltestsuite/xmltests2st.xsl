<?xml version="1.0" encoding="iso-8859-2"?>
<xsl:stylesheet 
    version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
  <xsl:output method="text" encoding="UTF-8"/>

  <xsl:param name="test-case-class-name"></xsl:param>
  <xsl:param name="test-suite-name"></xsl:param>


  <xsl:template match="TESTCASES">
    <xsl:call-template name="create-test-case-class">
      <xsl:with-param name="class-name" select="$test-case-class-name"/>
      <xsl:with-param name="resource" select="'W3XMLTestSuiteResource'" />
    </xsl:call-template>
    <xsl:call-template name="set-current-category">
      <xsl:with-param name="class-name" select="$test-case-class-name"/>
      <xsl:with-param name="category-name" select="'tests'"/>
    </xsl:call-template>

    <xsl:apply-templates/>
    
  </xsl:template>


  <xsl:template match="TEST">
    <xsl:value-of select="concat('test_', translate(@ID, '-', '_'))"/><xsl:text>


&#9;"Sections: </xsl:text><xsl:value-of select="@SECTIONS"/><xsl:text>"
&#9;"Description: </xsl:text><xsl:value-of select="translate(./text(), '&quot;!', '`i')"/><xsl:text>"

</xsl:text>

<xsl:choose>
  <xsl:when test="@TYPE = 'not-wf'">
    <xsl:call-template name="test-not-wf"/>
  </xsl:when>
  <xsl:when test="@TYPE = 'valid'">
    <xsl:call-template name="test-valid"/>
  </xsl:when>
  <xsl:when test="@TYPE = 'invalid'">
    <xsl:call-template name="test-invalid"/>
  </xsl:when>
  <xsl:when test="@TYPE = 'error'">
    <xsl:call-template name="test-error"/>
  </xsl:when>


  <xsl:otherwise>
    <xsl:text>&#9;self fail:'Test type </xsl:text>
    <xsl:value-of select="@TYPE"/>
    <xsl:text> not yet implemented'.</xsl:text>
  </xsl:otherwise>
</xsl:choose>

<xsl:text>
!
</xsl:text>
  </xsl:template>

  <xsl:template name="test-not-wf">
    <xsl:text>
    self should:[
       XMLReader new parseInputSource:(InputSource onFile:</xsl:text>
       <xsl:text>(W3XMLTestSuiteResource current filesDirectory construct:'</xsl:text>
       <xsl:value-of select="concat($test-suite-name, '/' , @URI)"/><xsl:text>')).
    ] raise: SAXParseError.</xsl:text>
  </xsl:template>
  
  <xsl:template name="test-valid">
    <xsl:text>
    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:</xsl:text>
       <xsl:text>(W3XMLTestSuiteResource current filesDirectory construct:'</xsl:text>
       <xsl:value-of select="concat($test-suite-name, '/' , @URI)"/><xsl:text>')).
    ] raise: Error.</xsl:text>
  </xsl:template>

  <xsl:template name="test-invalid">
    <xsl:text>
    self shouldnt:[
       "This test must pass in non-validating parser."
       XMLReader new parseInputSource:(InputSource onFile:</xsl:text>
       <xsl:text>(W3XMLTestSuiteResource current filesDirectory construct:'</xsl:text>
       <xsl:value-of select="concat($test-suite-name, '/' , @URI)"/><xsl:text>')).
    ] raise: Error.</xsl:text>
  </xsl:template>

  <xsl:template name="test-error">
    <xsl:text>
    self shouldnt:[
       "This test must pass in non-validating parser."
       XMLReader new parseInputSource:(InputSource onFile:</xsl:text>
       <xsl:text>(W3XMLTestSuiteResource current filesDirectory construct:'</xsl:text>
       <xsl:value-of select="concat($test-suite-name, '/' , @URI)"/><xsl:text>')).
    ] raise: Error.</xsl:text>
  </xsl:template>


  

  
  <xsl:template name="set-current-category">
    <xsl:param name="class-name"/>
    <xsl:param name="category-name"/>
    <xsl:text>!</xsl:text>
    <xsl:value-of select="$class-name"/>
    <xsl:text> methodsFor: '</xsl:text>
    <xsl:value-of select="$category-name"/>
    <xsl:text>'!

</xsl:text>        
  </xsl:template>
  <xsl:template name="create-test-case-class">
    <xsl:param name="superclass-name">TestCase</xsl:param>
    <xsl:param name="package">stx:goodies/xmlsuite</xsl:param>
    <xsl:param name="namespace">XMLv2</xsl:param>
    <xsl:param name="class-category">XML Suite-Tests W3C</xsl:param>
    <xsl:param name="resource">W3XMLTestSuiteResource</xsl:param>
    <xsl:param name="class-name"/>
    <xsl:text>"{ Package: '</xsl:text><xsl:value-of select="$package"/><xsl:text>' }"

"{ NameSpace: </xsl:text><xsl:value-of select="$namespace"/><xsl:text> }"

</xsl:text><xsl:value-of select="$superclass-name"/><xsl:text> subclass:#</xsl:text><xsl:value-of select="$class-name"/><xsl:text>
        instanceVariableNames:'doc'
        classVariableNames:''
        poolDictionaries:''
        category:'</xsl:text><xsl:value-of select="$class-category"/><xsl:text>'
!

!</xsl:text><xsl:value-of select="$class-name"/><xsl:text> class methodsFor:'documentation'!

version
    ^'$Header: /opt/data/cvs/stx/goodies/xmlsuite/resources/tests/xmltestsuite/xmltests2st.xsl,v 1.2 2005-11-06 16:46:15 vranyj1 Exp $'
! !

!</xsl:text><xsl:value-of select="$class-name"/><xsl:text> methodsFor:'accessing'!

resources
   ^Array with:</xsl:text><xsl:value-of select="$resource"/><xsl:text>
! !

</xsl:text>    
  </xsl:template>
</xsl:stylesheet>