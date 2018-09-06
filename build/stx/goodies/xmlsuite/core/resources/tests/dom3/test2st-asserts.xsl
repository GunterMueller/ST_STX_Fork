<?xml version="1.0" encoding="iso-8859-2"?>
<xsl:stylesheet 
    version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:t="http://www.w3.org/2001/DOM-Test-Suite/Level-3">

  <xsl:import href="test2st-conditions.xsl" />

  
  <xsl:template name="assert-helper">
    <xsl:param name="assert"/><!-- true or false -->
    <xsl:param name="assertnode"/>
    <xsl:param name="expression"/>

    <xsl:text>&#09;self </xsl:text>
    <xsl:value-of select="$assert" />
    <xsl:text>: </xsl:text>
    <xsl:choose>
      <xsl:when test="$assertnode">
	<xsl:choose>
	  <xsl:when test="count($assertnode/*) = 1">
	    <xsl:apply-templates select="./*" mode="condition"/>
	  </xsl:when>
	  <xsl:when test="count($assertnode/*) = 0">
	    <xsl:value-of select="@actual"/>
	  </xsl:when>
	</xsl:choose>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="$expression"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>.&#10;</xsl:text>
  </xsl:template>

  <xsl:template match="t:assertTrue" mode="body">
    <xsl:call-template name="assert-helper">
      <xsl:with-param name="assert" select="'assert'"/>
      <xsl:with-param name="assertnode" select="."/>
    </xsl:call-template>    
  </xsl:template>

  <xsl:template match="t:assertFalse" mode="body">
    <xsl:call-template name="assert-helper">
      <xsl:with-param name="assert" select="'deny'"/>
      <xsl:with-param name="assertnode" select="."/>
    </xsl:call-template>    
  </xsl:template>

  <xsl:template match="t:assertEquals" mode="body">
    <xsl:call-template name="assert-helper">
      <xsl:with-param name="assert" select="'assert'" />
      <xsl:with-param name="expression">
	<xsl:call-template name="cond-equals"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:assertNull" mode="body">
    <xsl:call-template name="assert-helper">
      <xsl:with-param name="assert" select="'assert'" />
      <xsl:with-param name="expression">
	<xsl:value-of select="@actual"/><xsl:text> isNil</xsl:text>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:assertNotNull" mode="body">
    <xsl:call-template name="assert-helper">
      <xsl:with-param name="assert" select="'assert'" />
      <xsl:with-param name="expression">
	<xsl:value-of select="@actual"/><xsl:text> notNil</xsl:text>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:assertSize" mode="body">
    <xsl:call-template name="assert-helper">
      <xsl:with-param name="assert" select="'assert'" />
      <xsl:with-param name="expression">
	<xsl:value-of select="@collection"/>
	<xsl:text> size = </xsl:text>
	<xsl:value-of select="@size"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:assertSame" mode="body">
    <xsl:call-template name="assert-helper">
      <xsl:with-param name="assert" select="'assert'" />
      <xsl:with-param name="expression">
	<xsl:value-of select="@actual"/>
	<xsl:text> == </xsl:text>
	<xsl:value-of select="@expected"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:assertURIEquals" mode="body">
    <xsl:call-template name="assert-helper">
      <xsl:with-param name="assert" select="'assert'" />
      <xsl:with-param name="expression">
	<xsl:value-of select="@actual"/>
	<xsl:text> = </xsl:text>
	<xsl:call-template name="escape-string-helper">
	  <xsl:with-param name="string">
	    <xsl:value-of select="@name"/>
	  </xsl:with-param>
	</xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>



  <xsl:template match="t:assertNotEquals" mode="body">
    <xsl:choose>
      <xsl:when test="@bitmask">
	<xsl:call-template name="assert-helper">
	  <xsl:with-param name="assert" select="'assert'" />
	  <xsl:with-param name="expression">
	    <xsl:text>(</xsl:text>
	    <xsl:value-of select="@actual"/>
	    <xsl:text> bitAnd: </xsl:text>
	    <xsl:value-of select="@bitmask"/>
	    <xsl:text>) == (</xsl:text>
	    <xsl:value-of select="@expected"/>
	    <xsl:text> bitAnd: </xsl:text>
	    <xsl:value-of select="@bitmask"/>
	    <xsl:text>)</xsl:text>
	  </xsl:with-param>
	</xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
	<xsl:call-template name="assert-helper">
	  <xsl:with-param name="assert" select="'assert'" />
	  <xsl:with-param name="expression">
	    <xsl:value-of select="@actual"/>
	    <xsl:text> = </xsl:text>
	    <xsl:value-of select="@expected"/>
	  </xsl:with-param>
	</xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>



  <xsl:template match="*" mode="body">
    <xsl:message>Method '<xsl:value-of select="local-name()"/>' not supported (<xsl:value-of select="../@name"/>)</xsl:message>
    <xsl:text>&#09;</xsl:text>
    <xsl:text>self assert:false description:'Method "</xsl:text>
    <xsl:value-of select="local-name()"/>
    <xsl:text>" is not supported yet'.</xsl:text>
    <xsl:text>&#10;</xsl:text>
  </xsl:template>

</xsl:stylesheet>