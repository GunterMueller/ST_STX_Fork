<?xml version="1.0" encoding="iso-8859-2"?>
<xsl:stylesheet version="1.0" 
		xmlns:test="http://www.w3.org/2005/02/query-test-XQTSCatalog"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:xi="http://www.w3.org/2001/XInclude"
>

<!--Usage:
1.
xsltproc phase1.xsl ../XQTSCatalog.xml >a.xml
it creates a file a.xml which contains XInclude processing instructions
in order to include individual test-queries 
2.
xmllint (minus minus)xinclude a.xml >b.xml
it creates a file b.xml with query files included in element <query>
3.
xsltproc phase2.xsl b.xml >complete.st
it creates one smalltalk file with all tests
4.
awk -f split.awk complete.st
it creates standalone .st file for each test-group.-->


<xsl:output method="xml" indent="yes"/>

<xsl:param name="xqts-root">
  <xsl:message>XQTS root not specified</xsl:message>
  <xsl:message terminate="yes">use --stringparam xqts-root &lt;path to XQTS&gt;</xsl:message>  
</xsl:param>
<xsl:param name="input-path" select="'TestSources/'"/>
<xsl:param name="query-path" select="'Queries/XQuery/'"/>
<xsl:param name="result-path" select="'ExpectedTestResults/'"/>


  <xsl:template match="/">
  <xqts>
    <xsl:apply-templates select="//test:test-group"/>
  </xqts>
  </xsl:template>

  <xsl:template match="test:test-group">
   <test-group>
    <xsl:attribute name="ancestor_path">
        <xsl:for-each select="ancestor::*[name()='test-group']">
            <xsl:value-of select="@name" />
            <xsl:text>_</xsl:text>
        </xsl:for-each>
    </xsl:attribute>

    <xsl:variable name="test-group-name" select="./@name"/>
    <xsl:attribute name="name"><xsl:value-of select="$test-group-name"/></xsl:attribute>
    <xsl:apply-templates select="./test:test-case"/>
   </test-group>
  </xsl:template>

  <xsl:template match="test:test-case">
    <xsl:variable name="test-case-name" select="./@name"/>
    <xsl:variable name="method-name" select="translate($test-case-name,'-','_')"/>
    <xsl:variable name="test-case-path" select="./@FilePath"/>
    <xsl:variable name="query-file" select="concat($xqts-root,$query-path,$test-case-path,$test-case-name,'.xq')"/>
    <test-case>
    <xsl:attribute name="name"><xsl:value-of select="$method-name"/></xsl:attribute>
    <query-file>
      <xsl:element name="xi:include" namespace="http://www.w3.org/2001/XInclude">
	<xsl:attribute name="href"><xsl:value-of select="$query-file"/></xsl:attribute>
	<xsl:attribute name="parse">text</xsl:attribute>
	<xsl:element name="xi:fallback" namespace="http://www.w3.org/2001/XInclude">
	  <xsl:text>Cannot load </xsl:text>
	  <xsl:value-of select="$query-file"/>
	</xsl:element>
      </xsl:element>
    </query-file>
    <input-file>
      <xsl:attribute name="name"><xsl:value-of select="./test:input-file/text()"/></xsl:attribute>
      <xsl:attribute name="variable"><xsl:value-of select="./test:input-file/@variable"/></xsl:attribute>
    </input-file>
    <output-file>
      <xsl:attribute name="name"><xsl:value-of select="concat($test-case-path,./test:output-file/text())"/></xsl:attribute>
    </output-file>
    </test-case>
  </xsl:template>
  

  <xsl:template match="*"/>
</xsl:stylesheet>
