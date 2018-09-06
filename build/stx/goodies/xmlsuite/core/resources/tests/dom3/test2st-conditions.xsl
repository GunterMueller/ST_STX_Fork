<?xml version="1.0" encoding="iso-8859-2"?>
<xsl:stylesheet 
    version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:t="http://www.w3.org/2001/DOM-Test-Suite/Level-3">


  <xsl:template match="t:greater" name="cond-greater" mode="condition">
    <xsl:text>( </xsl:text>
    <xsl:value-of select="@actual"/>
    <xsl:text> &gt; </xsl:text>
    <xsl:value-of select="@expected"/>
    <xsl:text> )</xsl:text>
  </xsl:template>

  <xsl:template match="t:equals" name="cond-equals" mode="condition">
    <xsl:text>( </xsl:text>
    <xsl:choose>
      <xsl:when test="@ignoreCase = 'true'">
	<xsl:value-of select="@actual"/><xsl:text> asLowercase</xsl:text>
	<xsl:text> = </xsl:text>
	<xsl:value-of select="translate(@expected, '&quot;', $single-quote)"/><xsl:text> asLowercase</xsl:text>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="@actual"/>
	<xsl:text> = </xsl:text>
	<xsl:value-of select="translate(@expected, '&quot;', $single-quote)"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text> )</xsl:text>
  </xsl:template>

  <xsl:template match="t:notEquals" name="cond-not-equals" mode="condition">
    <xsl:call-template name="cond-equals"/>
    <xsl:text> not</xsl:text>
  </xsl:template>


  <xsl:template match="t:isNull" mode="condition">
    <xsl:text>( </xsl:text>
    <xsl:value-of select="@obj"/>
    <xsl:text> isNil ) </xsl:text>
  </xsl:template>

  <xsl:template match="t:notNull" mode="condition">
    <xsl:text>( </xsl:text>
    <xsl:value-of select="@obj"/>
    <xsl:text> notNil ) </xsl:text>
  </xsl:template>


  <xsl:template match="t:isTrue" mode="condition">
    <xsl:text>(</xsl:text>
    <xsl:value-of select="@value"/>
    <xsl:text>)</xsl:text>
  </xsl:template>
    
  <xsl:template match="*" mode="condition">
    <xsl:message>Condition '<xsl:value-of select="local-name()"/>' not supported</xsl:message>
    <xsl:text>false "no template for element </xsl:text>
    <xsl:value-of select="local-name()"/>
    <xsl:text>" </xsl:text>
  </xsl:template>
  
  <xsl:template name="logical-expression-helper">
    <xsl:param name="expressions"/><!-- Node set -->
    <xsl:param name="logic-function"/><!-- 'and' or 'or' -->
    <xsl:choose>
      <xsl:when test="count($expressions) = 1">
	<xsl:apply-templates select="$expressions[1]" mode="condition"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:apply-templates select="$expressions[1]" mode="condition"/>
	<xsl:text> </xsl:text>
	<xsl:value-of select="$logic-function"/>
	<xsl:text>: [</xsl:text>
	<xsl:call-template name="logical-expression-helper">
	  <xsl:with-param name="logic-function" select="$logic-function"/>
	  <xsl:with-param name="expressions" select="$expressions[position() > 1]"/>
	</xsl:call-template>
	<xsl:text>]</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="t:or" mode="condition">
    <xsl:call-template name="logical-expression-helper">
      <xsl:with-param name="logic-function" select="'or'"/>
      <xsl:with-param name="expressions" select="./*"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:and" mode="condition">
    <xsl:call-template name="logical-expression-helper">
      <xsl:with-param name="logic-function" select="'and'"/>
      <xsl:with-param name="expressions" select="./*"/>
    </xsl:call-template>
  </xsl:template>


</xsl:stylesheet>