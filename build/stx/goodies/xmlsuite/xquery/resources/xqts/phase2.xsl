<?xml version="1.0" encoding="iso-8859-2"?>
<xsl:stylesheet version="1.0" 
		xmlns:test="http://www.w3.org/2005/02/query-test-XQTSCatalog"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:file="java.io.File"
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


<xsl:output method="text"/>


  <xsl:template match="/">
    <xsl:apply-templates select="//test-group[not(/test-group)]" />
  </xsl:template>

  <xsl:template match="test-group">
    <xsl:variable name="test-group-name" select="./@name"/>
    <xsl:variable name="ancestor_path" select="./@ancestor_path"/>
    <xsl:value-of select="concat('##########~', $ancestor_path, $test-group-name)"/>
    <xsl:text> 

"{ Package: 'stx:goodies/xmlsuite/xquery' }"
"{ NameSpace: XQuery }"
XQTSTestCase subclass:#XQTS</xsl:text><xsl:value-of select="$test-group-name"/><xsl:text>Tests
     instanceVariableNames:''
     classVariableNames:''
     poolDictionaries:''
     category: 'XQuery-Tests-XQTS'
!


!XQTS</xsl:text><xsl:value-of select="$test-group-name"/><xsl:text>Tests methodsFor:'tests'!

</xsl:text>
    <xsl:apply-templates select="./test-case"/>
<xsl:text>!  </xsl:text>
</xsl:template>

  <xsl:template match="test-case">
    <xsl:variable name="test-case-name" select="./@name"/>
<xsl:text>test_</xsl:text><xsl:value-of select="$test-case-name"/>
    <xsl:text>

    | query result |

    query := ' </xsl:text>
    <xsl:variable name="quot">"</xsl:variable>
    <xsl:variable name="apos">'</xsl:variable>
    <xsl:value-of select="translate(./query-file/text(), $apos, $quot)"/>
    <xsl:text>
'.

    self xqtsBind: '</xsl:text><xsl:value-of select="./input-file/@variable"/><xsl:text>' toContentsOf: '</xsl:text><xsl:value-of select="./input-file/@name"/><xsl:text>'.

    </xsl:text>    
    
    <xsl:variable name="resultFile" select="./output-file/@name" />
    <xsl:choose>
        <xsl:when test="substring($resultFile, string-length($resultFile)) = '/'">
        <xsl:text>       self shouldRaiseError: [interpreter evaluate: query].
!  </xsl:text>    
        </xsl:when>
        <xsl:otherwise>
        <xsl:text>
    result  := interpreter evaluate: query.
    self
        assert: (self xqtsResultTextFromResult: result)
               = (self xqtsResultTextFromFile:
'</xsl:text><xsl:value-of select="./output-file/@name"/><xsl:text>')

!   </xsl:text>
        </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  

  <xsl:template match="*"/>

</xsl:stylesheet>
