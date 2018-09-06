<?xml version="1.0" encoding="iso-8859-2"?>
<xsl:stylesheet 
    version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:t="http://www.w3.org/2001/DOM-Test-Suite/Level-3">

  <xsl:import href="test2st-conditions.xsl"/>
  <xsl:import href="test2st-asserts.xsl"/>


  <xsl:template name="escape-string-helper">
    <xsl:param name="string"/>
    <xsl:value-of select="translate($string, '&quot;', $single-quote)"/>
  </xsl:template>


  <xsl:template name="line-helper">
    <xsl:param name="expression"/>
    <xsl:text>&#09;</xsl:text>
    <xsl:call-template  name="escape-string-helper">
      <xsl:with-param name="string" select="$expression"/>
    </xsl:call-template>
    <xsl:text>.&#10;</xsl:text>
  </xsl:template>

  <xsl:template name="assign-helper">
    <xsl:param name="expression"/>
    <xsl:call-template name="line-helper">
      <xsl:with-param name="expression"><xsl:value-of select="@var"/><xsl:text> := </xsl:text><xsl:value-of select="$expression"/></xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="send-and-assign-helper">
    <xsl:param name="expression"/>
    <xsl:call-template name="assign-helper">
      <xsl:with-param name="expression"><xsl:value-of select="@obj"/><xsl:text> </xsl:text><xsl:value-of select="$expression"/></xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="send-helper">
    <xsl:param name="expression"/>
    <xsl:call-template name="line-helper">
      <xsl:with-param name="expression"><xsl:value-of select="@obj"/><xsl:text> </xsl:text><xsl:value-of select="$expression"/></xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="t:metadata" mode="body" />
  <xsl:template match="t:var" mode="body" />

  <xsl:template match="t:if" mode="body">
    <xsl:text>&#9;"if"&#10;</xsl:text>
    <xsl:text>&#9;</xsl:text>
    <xsl:apply-templates select="*[1]" mode="condition"/>
    <xsl:text> ifTrue: [&#10;</xsl:text>      
    <xsl:for-each select="*[position() > 1  and local-name() != 'else']">
      <xsl:text>&#9;</xsl:text>
      <xsl:apply-templates mode="body"/>
    </xsl:for-each>
    <xsl:text>&#9;]</xsl:text>
    <xsl:if test="./else">
      <xsl:text> ifFalse: [&#10;</xsl:text>
      <xsl:apply-templates select="./else/*" mode="body"/>
      <xsl:text>&#9;]</xsl:text>
    </xsl:if>
    <xsl:text>.&#10;</xsl:text>
  </xsl:template>

  <xsl:template match="t:var[@value]" mode="body">
    <xsl:call-template name="line-helper">
      <xsl:with-param name="expression">
	<xsl:value-of select="@name"/><xsl:text> := </xsl:text><xsl:value-of select="@value"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:var[@type = 'DOMErrorMonitor']" mode="body">
    <xsl:call-template name="line-helper">
      <xsl:with-param name="expression">
	<xsl:value-of select="@name"/><xsl:text> := DOMErrorMonitor new</xsl:text>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:var[@isNull = 'true']" mode="body">
    <xsl:call-template name="line-helper">
      <xsl:with-param name="expression">
	<xsl:value-of select="@name"/><xsl:text> := nil</xsl:text>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="t:implementationAttribute" mode="body">
    <xsl:choose>
      <xsl:when test="(@name = 'validating') and (@value = 'true')">
	<xsl:text>&#9;^self. "Validation not supported"&#10;</xsl:text>
      </xsl:when>
      <xsl:when test="(@name = 'schemaValidating') and (@value = 'true')">
	<xsl:text>&#9;^self. "Schema validation not supported"&#10;</xsl:text>
      </xsl:when>
      <xsl:when test="(@name = 'expandEntityReferences') and (@value = 'true')">
	<xsl:text>&#9;^self. "Validation not supported"&#10;</xsl:text>
      </xsl:when>
      <xsl:when test="(@name = 'ignoringElementContentWhitespace') and (@value = 'true')">
	<xsl:text>&#9;^self. "ignoringElementContentWhitespace supported"&#10;</xsl:text>
      </xsl:when>
      <xsl:otherwise>
	<xsl:text>&#9;"implementationAttribute not supported: </xsl:text>
	<xsl:value-of select="@name"/>
	<xsl:text>"&#10;</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>



  <xsl:template match="t:load" mode="body">
    <xsl:call-template name="assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'</xsl:text><xsl:value-of select="@href"/><xsl:text>')</xsl:text>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:isSameNode" mode="body">
    <xsl:call-template name="assign-helper">
      <xsl:with-param name="expression">
	<xsl:value-of select="@obj"/>
	<xsl:text> isSameNode: </xsl:text>
	<xsl:value-of select="@other"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:implementation" mode="body">
    <xsl:call-template name="assign-helper">
      <xsl:with-param name="expression">DOMImplementationRegistry getDOMImplementation:'XML 3.0'</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:DOMImplementationRegistry.newInstance" mode="body">
    <xsl:call-template name="assign-helper">
      <xsl:with-param name="expression">DOMImplementationRegistry</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="t:createDocument" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text>createDocumentNS: </xsl:text>
	<xsl:value-of select="@namespaceURI"/> 
	<xsl:text> qualifiedName: </xsl:text>
	<xsl:value-of select="@qualifiedName"/> 
	<xsl:text> doctype: </xsl:text>
	<xsl:value-of select="@doctype"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:domConfig" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text>domConfig</xsl:text>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template match="t:getParameter" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text>getParameter: </xsl:text><xsl:value-of select="@name"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:setParameter" mode="body">
    <xsl:call-template name="send-helper">
      <xsl:with-param name="expression">
	<xsl:text>setParameter: </xsl:text>
	<xsl:value-of select="@name"/>
	<xsl:text> value: </xsl:text>
	<xsl:value-of select="@value"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:canSetParameter" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text>canSetParameter: </xsl:text>
	<xsl:value-of select="@name"/>
	<xsl:text> value: </xsl:text>
	<xsl:value-of select="@value"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:getElementsByTagName" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> getElementsByTagName:</xsl:text>
	<xsl:value-of select="@tagname"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:item" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> item:</xsl:text>
	<xsl:value-of select="@index"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:getAttributeNode" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> getAttributeNode:</xsl:text>
	<xsl:value-of select="@name"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:isId" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> isId</xsl:text>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:getElementsByTagName" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> getElementsByTagName: </xsl:text>
	<xsl:value-of select="@tagname"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:getAttributeNodeNS" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> getAttributeNode: </xsl:text>
	<xsl:value-of select="@localName"/>
	<xsl:text> ns: </xsl:text>
	<xsl:value-of select="@namespaceURI"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:setAttributeNodeNS" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> setAttributeNodeNS: </xsl:text>
	<xsl:value-of select="@newAttr"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:increment" mode="body">
    <xsl:call-template name="assign-helper">
      <xsl:with-param name="expression">
	<xsl:value-of select="@var"/>
	<xsl:text> + </xsl:text>
	<xsl:value-of select="@value"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="t:setAttributeNS" mode="body">
    <xsl:call-template name="send-helper">
      <xsl:with-param name="expression">
	<xsl:text> setAttribute: </xsl:text>
	<xsl:value-of select="@qualifiedName"/>
	<xsl:text> ns: </xsl:text>
	<xsl:value-of select="@namespaceURI"/>
	<xsl:text> value: </xsl:text>
	<xsl:value-of select="@value"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template match="t:setIdAttributeNS" mode="body">
    <xsl:call-template name="send-helper">
      <xsl:with-param name="expression">
	<xsl:text> setIdAttribute: </xsl:text>
	<xsl:call-template name="escape-string-helper">
	  <xsl:with-param name="string">
	    <xsl:value-of select="@localName"/>
	  </xsl:with-param>
	</xsl:call-template>	
	<xsl:text> ns: </xsl:text>
	<xsl:call-template name="escape-string-helper">
	  <xsl:with-param name="string">
	    <xsl:value-of select="@namespaceURI"/>
	  </xsl:with-param>
	</xsl:call-template>
	<xsl:text> isId:</xsl:text>
	<xsl:value-of select="@isId"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>  
  
  <xsl:template match="t:setIdAttribute" mode="body">
    <xsl:call-template name="send-helper">
      <xsl:with-param name="expression">
	<xsl:text> setIdAttribute: </xsl:text>
	<xsl:call-template name="escape-string-helper">
	  <xsl:with-param name="string">	    
	    <xsl:value-of select="@name" />
	  </xsl:with-param>
	</xsl:call-template>
	<xsl:text> isId:</xsl:text>
	<xsl:value-of select="@isId"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>  

  <xsl:template match="t:getElementsByTagNameNS" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> getElementsByTagName: </xsl:text>
	<xsl:call-template name="escape-string-helper">
	  <xsl:with-param name="string">
	    <xsl:value-of select="@localName"/>
	  </xsl:with-param>
	</xsl:call-template>
	<xsl:text> ns: </xsl:text>
	<xsl:call-template name="escape-string-helper">
	  <xsl:with-param name="string">
	    <xsl:value-of select="@namespaceURI"/>
	  </xsl:with-param>
	</xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:adoptNode" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> adoptNode: </xsl:text>
	<xsl:value-of select="@source"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:documentURI" mode="body">
    <xsl:choose>
      <xsl:when test="@var">
	<xsl:call-template name="send-and-assign-helper">
	  <xsl:with-param name="expression">
	    <xsl:text> documentURI</xsl:text>
	  </xsl:with-param>
	</xsl:call-template>
      </xsl:when>
      <xsl:when test="@value">
	<xsl:call-template name="send-helper">
	  <xsl:with-param name="expression">
	    <xsl:text>documentURI:</xsl:text>
	    <xsl:call-template name="escape-string-helper">
	      <xsl:with-param name="string">
		<xsl:value-of select="@value"/>
	      </xsl:with-param>
	    </xsl:call-template>
	  </xsl:with-param>
	</xsl:call-template>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="t:documentElement" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> documentElement</xsl:text>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:doctype" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> doctype</xsl:text>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:decrement" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:value-of select="@var"/>
	<xsl:text> - 1</xsl:text>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:data" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> data</xsl:text>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:createTextNode" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> createTextNode:</xsl:text>
	<xsl:call-template name="escape-string-helper">
	  <xsl:with-param name="string">
	    <xsl:value-of select="@data"/>
	  </xsl:with-param>
	</xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:createProcessingInstruction" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> createProcessingInstruction:</xsl:text>
	<xsl:call-template name="escape-string-helper">
	  <xsl:with-param name="string">
	    <xsl:value-of select="@target"/>
	  </xsl:with-param>
	</xsl:call-template>	
	<xsl:text> data:</xsl:text>
	<xsl:call-template name="escape-string-helper">
	  <xsl:with-param name="string">
	    <xsl:value-of select="@data"/>
	  </xsl:with-param>
	</xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:createElementNS" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> createElement:</xsl:text>
	<xsl:call-template name="escape-string-helper">
	  <xsl:with-param name="string">
	    <xsl:value-of select="@qualifiedName"/>
	  </xsl:with-param>
	</xsl:call-template>	
	<xsl:text> ns:</xsl:text>
	<xsl:call-template name="escape-string-helper">
	  <xsl:with-param name="string">
	    <xsl:value-of select="@namespaceURI"/>
	  </xsl:with-param>
	</xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:schemaTypeInfo" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> schemaTypeInfo</xsl:text>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:type" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> type</xsl:text>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  

  <xsl:template match="t:typeName" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> typeName</xsl:text>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:typeNamespace" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> typeNamespace</xsl:text>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:parentNode" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> parentNode</xsl:text>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:cloneNode" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> cloneNode:</xsl:text>
	<xsl:value-of select="@deep" />
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:appendChild" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> appendChild:</xsl:text>
	<xsl:value-of select="@newChild" />
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="t:createAttributeNS" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> createAttribute:</xsl:text>
	<xsl:call-template name="escape-string-helper">
	  <xsl:with-param name="string">
	    <xsl:value-of select="@qualifiedName"/>
	  </xsl:with-param>
	</xsl:call-template>	
	<xsl:text> ns:</xsl:text>
	<xsl:call-template name="escape-string-helper">
	  <xsl:with-param name="string">
	    <xsl:value-of select="@namespaceURI"/>
	  </xsl:with-param>
	</xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="t:normalizeDocument" mode="body">
    <xsl:call-template name="send-helper">
      <xsl:with-param name="expression">
	<xsl:text> normalizeDocument</xsl:text>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:lastChild" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> lastChild</xsl:text>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:firstChild" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> firstChild</xsl:text>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:nodeName" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> nodeName</xsl:text>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:nodeValue" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> nodeValue</xsl:text>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:nodeType" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> nodeType</xsl:text>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:previousSibling" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> previousSibling</xsl:text>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="t:nextSibling" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> nextSibling</xsl:text>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:length" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> length</xsl:text>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:specified" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> specified</xsl:text>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:createCDATASection" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> createCDATASection:</xsl:text>
	<xsl:call-template name="escape-string-helper">
	  <xsl:with-param name="string">
	    <xsl:value-of select="@data"/>
	  </xsl:with-param>
	</xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:createComment" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> createComment:</xsl:text>
	<xsl:call-template name="escape-string-helper">
	  <xsl:with-param name="string">
	    <xsl:value-of select="@data"/>
	  </xsl:with-param>
	</xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:textContent" mode="body">
    <xsl:choose>
      <xsl:when test="./@value">
	<xsl:call-template name="send-helper">
	  <xsl:with-param name="expression">
	    <xsl:text>textContent:</xsl:text>
	    <xsl:call-template name="escape-string-helper">
	      <xsl:with-param name="string">
		<xsl:value-of select="@value"/>
	      </xsl:with-param>
	    </xsl:call-template>
	  </xsl:with-param>
	</xsl:call-template>
      </xsl:when>
      <xsl:when test="./@var">
	<xsl:call-template name="send-and-assign-helper">
	  <xsl:with-param name="expression">
	    <xsl:text> textContent</xsl:text>
	  </xsl:with-param>
	</xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
	<xsl:message>unsupported textContent tag</xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="t:value" mode="body">
    <xsl:choose>
      <xsl:when test="./@value">
	<xsl:call-template name="send-helper">
	  <xsl:with-param name="expression">
	    <xsl:text>value:</xsl:text>
	    <xsl:call-template name="escape-string-helper">
	      <xsl:with-param name="string">
		<xsl:value-of select="@value"/>
	      </xsl:with-param>
	    </xsl:call-template>
	  </xsl:with-param>
	</xsl:call-template>
      </xsl:when>
      <xsl:when test="./@var">
	<xsl:call-template name="send-and-assign-helper">
	  <xsl:with-param name="expression">
	    <xsl:text>value</xsl:text>
	  </xsl:with-param>
	</xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
	<xsl:message>unsupported textContent tag</xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>



  <xsl:template match="t:getAttribute" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> getAttribute:</xsl:text>
	<xsl:call-template name="escape-string-helper">
	  <xsl:with-param name="string">
	    <xsl:value-of select="@name"/>
	  </xsl:with-param>
	</xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:ownerElement" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> ownerElement</xsl:text>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:tagName" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> tagName</xsl:text>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:namespaceURI" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> namespaceURI</xsl:text>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:prefix" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> prefix</xsl:text>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:createEntityReference" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> createEntityReference:</xsl:text>
	<xsl:call-template name="escape-string-helper">
	  <xsl:with-param name="string">
	    <xsl:value-of select="@name"/>
	  </xsl:with-param>
	</xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:hasChildNodes" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> hasChildNodes</xsl:text>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:createDocumentFragment" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> createDocumentFragment</xsl:text>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="t:setAttributeNode" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> setAttributeNode:</xsl:text>
	<xsl:value-of select="@newAttr"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="t:attributes" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> attributes</xsl:text>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:entities" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> entities</xsl:text>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:notations" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> notations</xsl:text>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="t:getNamedItem" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> getNamedItem:</xsl:text>
	<xsl:call-template name="escape-string-helper">
	  <xsl:with-param name="string">
	    <xsl:value-of select="@name"/>
	  </xsl:with-param>
	</xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>  


  <xsl:template match="t:childNodes" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> childNodes</xsl:text>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:inputEncoding" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> inputEncoding</xsl:text>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:ownerDocument" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> ownerDocument</xsl:text>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:importNode" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> importNode:</xsl:text>
	<xsl:value-of select="@importedNode"/>
	<xsl:text> deep:</xsl:text>
	<xsl:value-of select="@deep"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:strictErrorChecking" mode="body">
    <xsl:choose>
      <xsl:when test="@var">
	<xsl:call-template name="send-and-assign-helper">
	  <xsl:with-param name="expression">
	    <xsl:text>strictErrorChecking</xsl:text>
	  </xsl:with-param>
	</xsl:call-template>
      </xsl:when>
      <xsl:when test="@value">
	<xsl:call-template name="send-helper">
	  <xsl:with-param name="expression">
	    <xsl:text>strictErrorChecking:</xsl:text>
	    <xsl:value-of select="@value"/>
	  </xsl:with-param>
	</xsl:call-template>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="t:xmlStandalone" mode="body">
    <xsl:choose>
      <xsl:when test="@var">
	<xsl:call-template name="send-and-assign-helper">
	  <xsl:with-param name="expression">
	    <xsl:text> xmlStandalone</xsl:text>
	  </xsl:with-param>
	</xsl:call-template>
      </xsl:when>
      <xsl:when test="@value">
	<xsl:call-template name="send-helper">
	  <xsl:with-param name="expression">
	    <xsl:text> xmlStandalone:</xsl:text>
	    <xsl:value-of select="@value"/>
	  </xsl:with-param>
	</xsl:call-template>
      </xsl:when>
    </xsl:choose>
  </xsl:template>


  <xsl:template match="t:systemId" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> systemId</xsl:text>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="t:createDocumentType" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> createDocumentType:</xsl:text>
	<xsl:call-template name="escape-string-helper">
	  <xsl:with-param name="string">
	    <xsl:value-of select="@qualifiedName"/>
	  </xsl:with-param>
	</xsl:call-template>	
	<xsl:text> publicId:</xsl:text>
	<xsl:call-template name="escape-string-helper">
	  <xsl:with-param name="string">
	    <xsl:value-of select="@publicId"/>
	  </xsl:with-param>
	</xsl:call-template>
	<xsl:text> systemId:</xsl:text>
	<xsl:call-template name="escape-string-helper">
	  <xsl:with-param name="string">
	    <xsl:value-of select="@systemId"/>
	  </xsl:with-param>
	</xsl:call-template>

      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:setAttribute" mode="body">
    <xsl:call-template name="send-helper">
      <xsl:with-param name="expression">
	<xsl:text> setAttribute:</xsl:text>
	<xsl:call-template name="escape-string-helper">
	  <xsl:with-param name="string">
	    <xsl:value-of select="@name"/>
	  </xsl:with-param>
	</xsl:call-template>	
	<xsl:text> value:</xsl:text>
	<xsl:call-template name="escape-string-helper">
	  <xsl:with-param name="string">
	    <xsl:value-of select="@value"/>
	  </xsl:with-param>
	</xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="t:renameNode" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> renameNode:</xsl:text>
	<xsl:value-of select="@n"/>
	<xsl:text> namespaceUri:</xsl:text>
	<xsl:call-template name="escape-string-helper">
	  <xsl:with-param name="string">
	    <xsl:value-of select="@namespaceURI"/>
	  </xsl:with-param>
	</xsl:call-template>
	<xsl:text> qualifiedName:</xsl:text>
	<xsl:call-template name="escape-string-helper">
	  <xsl:with-param name="string">
	    <xsl:value-of select="@qualifiedName"/>
	  </xsl:with-param>
	</xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:getFeature" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> getFeature:</xsl:text>
	<xsl:call-template name="escape-string-helper">
	  <xsl:with-param name="string">
	    <xsl:value-of select="@feature"/>
	  </xsl:with-param>
	</xsl:call-template>
	<xsl:text> version:</xsl:text>
	<xsl:call-template name="escape-string-helper">
	  <xsl:with-param name="string">
	    <xsl:value-of select="@version"/>
	  </xsl:with-param>
	</xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:hasFeature" mode="body">
    <xsl:choose>
      <xsl:when test="@var">
	<xsl:call-template name="send-and-assign-helper">
	  <xsl:with-param name="expression">
	    <xsl:text> hasFeature:</xsl:text>
	    <xsl:call-template name="escape-string-helper">
	      <xsl:with-param name="string">
		<xsl:value-of select="@feature"/>
	      </xsl:with-param>
	    </xsl:call-template>
	    <xsl:text> version:</xsl:text>
	    <xsl:call-template name="escape-string-helper">
	      <xsl:with-param name="string">
		<xsl:value-of select="@version"/>
	      </xsl:with-param>
	    </xsl:call-template>
	  </xsl:with-param>
	</xsl:call-template>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="t:getDOMImplementation" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> getDOMImplementation:</xsl:text>
	<xsl:call-template name="escape-string-helper">
	  <xsl:with-param name="string">
	    <xsl:value-of select="@features"/>
	  </xsl:with-param>
	</xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:getDOMImplementationList" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> getDOMImplementationList:</xsl:text>
	<xsl:call-template name="escape-string-helper">
	  <xsl:with-param name="string">
	    <xsl:value-of select="@features"/>
	  </xsl:with-param>
	</xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


 <xsl:template match="t:contains" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> contains:</xsl:text>
	<xsl:call-template name="escape-string-helper">
	  <xsl:with-param name="string">
	    <xsl:value-of select="@str"/>
	  </xsl:with-param>
	</xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:parameterNames" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> parameterNames</xsl:text>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:baseURI" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> baseURI</xsl:text>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

 <xsl:template match="t:setIdAttributeNode" mode="body">
    <xsl:call-template name="send-helper">
      <xsl:with-param name="expression">
	<xsl:text> setIdAttributeNode:</xsl:text>
	<xsl:value-of select="@idAttr"/>
	<xsl:text> isId:</xsl:text>
	<xsl:value-of select="@isId"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


 <xsl:template match="t:getElementById" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> getElementById:</xsl:text>
	<xsl:call-template name="escape-string-helper">
	  <xsl:with-param name="string">
	    <xsl:value-of select="@elementId"/>
	  </xsl:with-param>
	</xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

<xsl:template match="t:isSupported" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> isSupported:</xsl:text>
	<xsl:call-template name="escape-string-helper">
	  <xsl:with-param name="string">
	    <xsl:value-of select="@feature"/>
	  </xsl:with-param>
	</xsl:call-template>
	<xsl:text> version:</xsl:text>
	<xsl:call-template name="escape-string-helper">
	  <xsl:with-param name="string">
	    <xsl:value-of select="@version"/>
	  </xsl:with-param>
	</xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:xmlVersion" mode="body">
    <!-- <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> xmlVersion</xsl:text>
      </xsl:with-param>
    </xsl:call-template>
    -->
  </xsl:template>

  <xsl:template match="t:xmlEncoding" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> xmlEncoding</xsl:text>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:target" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> target</xsl:text>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:location" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> location</xsl:text>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:severity" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> severity</xsl:text>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:relatedData" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> relatedData</xsl:text>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:relatedException" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> relatedException</xsl:text>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:relatedNode" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> relatedNode</xsl:text>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="t:lineNumber" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> lineNumber</xsl:text>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:columnNumber" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> columnNumber</xsl:text>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>







  <xsl:template match="t:replaceWholeText" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> replaceWholeText:</xsl:text>
	<xsl:call-template name="escape-string-helper">
	  <xsl:with-param name="string">
	    <xsl:value-of select="@content"/>
	  </xsl:with-param>
	</xsl:call-template>	
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:createElement" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> createElement:</xsl:text>
	<xsl:call-template name="escape-string-helper">
	  <xsl:with-param name="string">
	    <xsl:value-of select="@tagName"/>
	  </xsl:with-param>
	</xsl:call-template>	
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="t:wholeText" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> wholeText</xsl:text>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:for-each" mode="body">
    <xsl:value-of select="@collection"/>
    <xsl:text> do: [</xsl:text>
    <xsl:value-of select="@member"/>
    <xsl:text>|&#10;</xsl:text>
    <xsl:apply-templates mode="body"/>
    <xsl:text>].&#10;</xsl:text>
  </xsl:template>

  <xsl:template match="t:allErrors" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> errors</xsl:text>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:normalize" mode="body">
    <xsl:call-template name="send-helper">
      <xsl:with-param name="expression">
	<xsl:text> normalize</xsl:text>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="t:assertLowerSeverity" mode="body">
    <xsl:call-template name="send-helper">
      <xsl:with-param name="expression">
	<xsl:text> assertLowerSeverityFor: self message:</xsl:text>
	<xsl:text>'</xsl:text>
	<xsl:call-template name="escape-string-helper">
	  <xsl:with-param name="string">
	    <xsl:value-of select="@id "/>
	  </xsl:with-param>
	</xsl:call-template>
	<xsl:text>'</xsl:text>
	<xsl:text> severity: DOMError </xsl:text>
	<xsl:value-of select="@severity"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template match="*" mode="local-name">
    <xsl:value-of select="local-name()"/>
  </xsl:template>

  <xsl:template match="t:assertDOMException" mode="body">
    <xsl:text>&#9;"assertDOMException..."&#10;</xsl:text>
    <xsl:text>&#9;self should:[&#10;</xsl:text>
    <xsl:apply-templates select="./*/*" mode="body"/>
    <xsl:text>&#9;] raise: DOMException.&#10;</xsl:text>
    <xsl:text>&#9;self assert: (lastException code == DOMException </xsl:text>
    <xsl:apply-templates select="./*" mode="local-name"/>
    <xsl:text>).&#10;</xsl:text>
    <xsl:text>&#9;"end of assertDOMException..."&#10;</xsl:text>
  </xsl:template>

  <xsl:template match="t:try" mode="body">
    <xsl:text>&#9;"try"&#10;</xsl:text>
    <xsl:text>&#9;[&#10;</xsl:text>
    <xsl:apply-templates select="./*[local-name() != 'catch']" mode="body" />
    <xsl:text>&#9;] on: DOMException do: [:ex|</xsl:text>
    <xsl:for-each select="./catch/*">
      <xsl:text>ex code == DOMException </xsl:text>
      <xsl:value-of select="@code"/>
      <xsl:text>ifTrue:[&#10;</xsl:text>
      <xsl:apply-templates select="*" mode="body"/>
      <xsl:text>].&#10;</xsl:text>
    </xsl:for-each>
    <xsl:text>&#9;].&#10;</xsl:text>
    <xsl:text>&#9;"end of try"&#10;</xsl:text>
  </xsl:template>



  <xsl:template match="t:insertBefore" mode="body">
    <xsl:call-template name="send-helper">
      <xsl:with-param name="expression">
	<xsl:text> insert:</xsl:text>
	<xsl:value-of select="@newChild "/>
	<xsl:text> before: </xsl:text>
	<xsl:value-of select="@refChild"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:replaceChild" mode="body">
    <xsl:call-template name="send-helper">
      <xsl:with-param name="expression">
	<xsl:text> replaceChild:</xsl:text>
	<xsl:value-of select="@oldChild"/>
	<xsl:text> with: </xsl:text>
	<xsl:value-of select="@newChild"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="t:createElement" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> createElement:</xsl:text>
	<xsl:call-template name="escape-string-helper">
	  <xsl:with-param name="string">
	    <xsl:value-of select="@tagName"/>
	  </xsl:with-param>
	</xsl:call-template>	
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:createAttribute" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> createAttribute:</xsl:text>
	<xsl:call-template name="escape-string-helper">
	  <xsl:with-param name="string">
	    <xsl:value-of select="@name"/>
	  </xsl:with-param>
	</xsl:call-template>	
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="t:lookupNamespaceURI" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> lookupNamespaceURI:</xsl:text>
	<xsl:call-template name="escape-string-helper">
	  <xsl:with-param name="string">
	    <xsl:value-of select="@prefix"/>
	  </xsl:with-param>
	</xsl:call-template>	
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:isDerivedFrom" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> isDerivedFromNS:</xsl:text>
	<xsl:call-template name="escape-string-helper">
	  <xsl:with-param name="string">
	    <xsl:value-of select="@typeNamespaceArg"/>
	  </xsl:with-param>
	</xsl:call-template>	
	<xsl:text> name:</xsl:text>
	<xsl:call-template name="escape-string-helper">
	  <xsl:with-param name="string">
	    <xsl:value-of select="@typeNameArg"/>
	  </xsl:with-param>
	</xsl:call-template>	
	<xsl:text> method:</xsl:text>
	<xsl:value-of select="@derivationMethod"/>
      </xsl:with-param>      
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="t:compareDocumentPosition" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> compareDocumentPosition:</xsl:text>
	<xsl:value-of select="@other"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:isEqualNode" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> isEqualNode:</xsl:text>
	<xsl:value-of select="@arg"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:removeChild" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> removeChild:</xsl:text>
	<xsl:value-of select="@oldChild"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>



  <xsl:template match="t:localName" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> localName</xsl:text>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:name" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> name</xsl:text>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>



  <xsl:template match="t:isElementContentWhitespace" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> isElementContentWhitespace</xsl:text>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="t:isDefaultNamespace" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> isDefaultNamespace: </xsl:text>
         <xsl:call-template name="escape-string-helper">
            <xsl:with-param name="string" select="@namespaceURI"/>
         </xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:lookupPrefix" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> lookupPrefix</xsl:text>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="t:setUserData" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> setUserData:</xsl:text>
	<xsl:call-template name="escape-string-helper">
	  <xsl:with-param name="string">
	    <xsl:value-of select="@data"/>
	  </xsl:with-param>
	</xsl:call-template>	
	<xsl:text> handler: </xsl:text>
	<xsl:value-of select="@handler" />
	<xsl:text> forKey:</xsl:text>
	<xsl:call-template name="escape-string-helper">
	  <xsl:with-param name="string">
	    <xsl:value-of select="@key"/>
	  </xsl:with-param>
	</xsl:call-template>	
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:getUserData" mode="body">
    <xsl:call-template name="send-and-assign-helper">
      <xsl:with-param name="expression">
	<xsl:text> getUserDataForKey:</xsl:text>
	<xsl:call-template name="escape-string-helper">
	  <xsl:with-param name="string">
	    <xsl:value-of select="@key"/>
	  </xsl:with-param>
	</xsl:call-template>	
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="t:fail" mode="body">
    <xsl:text>self assert:false.</xsl:text>
  </xsl:template>

  <xsl:template match="t:return" mode="body">
    <xsl:text>^self.</xsl:text>
  </xsl:template>





             


  







  




</xsl:stylesheet>