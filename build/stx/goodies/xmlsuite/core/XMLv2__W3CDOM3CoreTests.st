"{ Package: 'stx:goodies/xmlsuite/core' }"

"{ NameSpace: XMLv2 }"

AbstractW3CDOM3TestCase subclass:#W3CDOM3CoreTests
	instanceVariableNames:'doc'
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-Tests W3C'
!


!W3CDOM3CoreTests class methodsFor:'defaults'!

module
    ^'Core'
! !

!W3CDOM3CoreTests methodsFor:'W3C tests'!

test_attrgetschematypeinfo01
	"
Call getSchemaTypeInfo on title attribute for the first acronym element.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Attr-schemaTypeInfo
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-typeName
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-typeNamespace
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  acronymElem "Element"
	  attr "Attr"
	  elem "Element"
	  elemName "String"
	  typeInfo "TypeInfo"
	  typeNS "String"
	  typeName "String"
	|
	^self. "Validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'acronym'.
	acronymElem := elemList  item:0.
	attr := acronymElem  getAttributeNode:'title'.
	typeInfo := attr  schemaTypeInfo.
	self assert: typeInfo notNil.
	typeName := typeInfo  typeName.
	self assert: ( typeName = 'CDATA' ).
	typeNS := typeInfo  typeNamespace.
	self assert: ( typeNS = 'http://www.w3.org/TR/REC-xml' ).

!

test_attrgetschematypeinfo02
	"
Call getSchemaTypeInfo on id attribute for the third acronym element.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Attr-schemaTypeInfo
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-typeName
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-typeNamespace
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  acronymElem "Element"
	  attr "Attr"
	  elem "Element"
	  elemName "String"
	  typeInfo "TypeInfo"
	  typeNS "String"
	  typeName "String"
	|
	^self. "Validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'acronym'.
	acronymElem := elemList  item:2.
	attr := acronymElem  getAttributeNode:'id'.
	typeInfo := attr  schemaTypeInfo.
	self assert: typeInfo notNil.
	typeName := typeInfo  typeName.
	self assert: ( typeName = 'ID' ).
	typeNS := typeInfo  typeNamespace.
	self assert: ( typeNS = 'http://www.w3.org/TR/REC-xml' ).

!

test_attrgetschematypeinfo03
	"
Call getSchemaTypeInfo on title attribute for the first acronym element.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Attr-schemaTypeInfo
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-typeName
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-typeNamespace
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  acronymElem "Element"
	  attr "Attr"
	  elem "Element"
	  elemName "String"
	  typeInfo "TypeInfo"
	  typeNS "String"
	  typeName "String"
	|
	^self. "Schema validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'acronym'.
	acronymElem := elemList  item:0.
	attr := acronymElem  getAttributeNode:'title'.
	typeInfo := attr  schemaTypeInfo.
	self assert: typeInfo notNil.
	typeName := typeInfo  typeName.
	self assert: ( typeName = 'string' ).
	typeNS := typeInfo  typeNamespace.
	self assert: ( typeNS = 'http://www.w3.org/2001/XMLSchema' ).

!

test_attrgetschematypeinfo04
	"
Call getSchemaTypeInfo on id attribute for the third acronym element.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Attr-schemaTypeInfo
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-typeName
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-typeNamespace
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  acronymElem "Element"
	  attr "Attr"
	  elem "Element"
	  elemName "String"
	  typeInfo "TypeInfo"
	  typeNS "String"
	  typeName "String"
	|
	^self. "Schema validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'acronym'.
	acronymElem := elemList  item:2.
	attr := acronymElem  getAttributeNode:'id'.
	typeInfo := attr  schemaTypeInfo.
	self assert: typeInfo notNil.
	typeName := typeInfo  typeName.
	self assert: ( typeName = 'ID' ).
	typeNS := typeInfo  typeNamespace.
	self assert: ( typeNS = 'http://www.w3.org/2001/XMLSchema' ).

!

test_attrgetschematypeinfo05
	"
Call getSchemaTypeInfo on class attribute for the third acronym element.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Attr-schemaTypeInfo
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-typeName
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-typeNamespace
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  acronymElem "Element"
	  attr "Attr"
	  elem "Element"
	  elemName "String"
	  typeInfo "TypeInfo"
	  typeNS "String"
	  typeName "String"
	|
	^self. "Schema validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'acronym'.
	acronymElem := elemList  item:2.
	attr := acronymElem  getAttributeNode:'class'.
	typeInfo := attr  schemaTypeInfo.
	self assert: typeInfo notNil.
	typeName := typeInfo  typeName.
	self assert: ( typeName = 'classType' ).
	typeNS := typeInfo  typeNamespace.
	self assert: ( typeNS = 'http://www.w3.org/1999/xhtml' ).

!

test_attrgetschematypeinfo06
	"
Attr.schemaTypeInfo should return null if not validating or schema validating.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Attr-schemaTypeInfo
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-typeName
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-typeNamespace
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  acronymElem "Element"
	  elem "Element"
	  attr "Attr"
	  typeInfo "TypeInfo"
	  typeName "String"
	  typeNS "String"
	|
	"implementationAttribute not supported: validating"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_nodtdstaff').
	elemList := doc  getElementsByTagName: 'acronym'.
	acronymElem := elemList  item:0.
	attr := acronymElem  getAttributeNode:'title'.
	typeInfo := attr  schemaTypeInfo.
	self assert: typeInfo notNil.
	typeName := typeInfo  typeName.
	self assert: typeName isNil.
	typeNS := typeInfo  typeNamespace.
	self assert: typeNS isNil.

!

test_attrgetschematypeinfo07
	"
	The getSchemaTypeInfo method retrieves the type information associated with this attribute. 
     
	Load a valid document with an XML Schema.
        
	Invoke getSchemaTypeInfo method on an attribute having [type definition] property.  Expose {name} and {target namespace}
	properties of the [type definition] property.  Verity that the typeName and typeNamespace of the title attribute's
	schemaTypeInfo are correct. getSchemaTypeInfo on the 'id' attribute of the fourth 'acronym' element

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Attr-schemaTypeInfo
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  acElem "Element"
	  attr "Attr"
	  attrTypeInfo "TypeInfo"
	  typeName "String"
	  typeNamespace "String"
	|
	^self. "Schema validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'acronym'.
	acElem := elemList  item:3.
	attr := acElem  getAttributeNode:'id'.
	attrTypeInfo := attr  schemaTypeInfo.
	self assert: attrTypeInfo notNil.
	typeName := attrTypeInfo  typeName.
	typeNamespace := attrTypeInfo  typeNamespace.
	self assert: ( typeName = 'ID' ).
	self assert: ( typeNamespace = 'http://www.w3.org/2001/XMLSchema' ).

!

test_attrgetschematypeinfo08
	"
	The getSchemaTypeInfo method retrieves the type information associated with this attribute. 

	Load a valid document with an XML Schema. 
	Invoke getSchemaTypeInfo method on an attribute having [type definition] property.  Expose {name} and {target namespace}
	properties of the [type definition] property.  Verity that the typeName and typeNamespace of the 'title' attribute's (of first 'acronym' element)
	schemaTypeInfo are correct.

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Attr-schemaTypeInfo
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  acElem "Element"
	  attr "Attr"
	  attrTypeInfo "TypeInfo"
	  typeName "String"
	  typeNamespace "String"
	|
	^self. "Schema validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'acronym'.
	acElem := elemList  item:0.
	attr := acElem  getAttributeNode:'title'.
	attrTypeInfo := attr  schemaTypeInfo.
	typeName := attrTypeInfo  typeName.
	typeNamespace := attrTypeInfo  typeNamespace.
	self assert: ( typeName = 'string' ).
	self assert: ( typeNamespace = 'http://www.w3.org/2001/XMLSchema' ).

!

test_attrisid01
	"
	Retrieve the third acronyms element's class attribute, whose type is not ID.  
	Invoke isID on the class attribute, this should return false.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Attr-isId
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  acronymElem "Element"
	  attr "Attr"
	  id "Boolean"
	  elem "Element"
	  elemName "String"
	|
	id := false.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'acronym'.
	acronymElem := elemList  item:2.
	attr := acronymElem  getAttributeNode:'class'.
	id := attr  isId.
	self deny: id.

!

test_attrisid02
	"
	Invoke setIdAttribute on the third acronym element's new attribute and set 
	isID=true.  Verify by calling isID on the new attribute and check if the 
	value returned is true.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Attr-isId
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  acronymElem "Element"
	  attributesMap "NamedNodeMap"
	  attr "Attr"
	  id "Boolean"
	  elem "Element"
	  elemName "String"
	  xmlNS "String"
	|
	id := false.
	xmlNS := 'http://www.w3.org/XML/1998/namespace'.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'acronym'.
	acronymElem := elemList  item:2.
	acronymElem  setAttribute: 'xml:lang' ns: xmlNS value: 'FR-fr'.
	acronymElem  setIdAttribute: 'lang' ns: xmlNS isId:true.
	attr := acronymElem  getAttributeNode: 'lang' ns: xmlNS.
	id := attr  isId.
	self assert: id.

!

test_attrisid03
	"
	Invoke setIdAttribute(false) on a newly created attribute and then check Attr.isID.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Attr-isId
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  acronymElem "Element"
	  attributesMap "NamedNodeMap"
	  attr "Attr"
	  id "Boolean"
	  elem "Element"
	  elemName "String"
	  xmlNS "String"
	|
	id := false.
	xmlNS := 'http://www.w3.org/XML/1998/namespace'.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'acronym'.
	acronymElem := elemList  item:2.
	acronymElem  setAttribute: 'xml:lang' ns: xmlNS value: 'FR-fr'.
	acronymElem  setIdAttribute: 'lang' ns: xmlNS isId:false.
	attr := acronymElem  getAttributeNode: 'lang' ns: xmlNS.
	id := attr  isId.
	self deny: id.

!

test_attrisid04
	"
Attr.isID should return true for the id attribute on the fourth acronym node
since its type is ID.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Attr-isId
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  acronymElem "Element"
	  clonedacronymElem "Element"
	  attributesMap "NamedNodeMap"
	  attr "Attr"
	  id "Boolean"
	  elem "Element"
	  elemName "String"
	|
	^self. "Validation not supported"
	id := false.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'acronym'.
	acronymElem := elemList  item:3.
	attr := acronymElem  getAttributeNode:'id'.
	id := attr  isId.
	self assert: id.

!

test_attrisid05
	"
	Retrieve the fourth acronym element's id attribute, whose type is ID.  
	Deep clone the element node and append it as a sibling of the acronym node.
	We now have two id attributes of type ID with identical values.   
	Invoke isID on the class attribute, should this return true???

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Attr-isId
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  acronymElem "Element"
	  clonedacronymElem "Element"
	  acronymParentElem "Element"
	  appendedNode "Node"
	  attributesMap "NamedNodeMap"
	  attr "Attr"
	  id "Boolean"
	  elem "Element"
	  elemName "String"
	|
	^self. "Validation not supported"
	id := false.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'acronym'.
	acronymElem := elemList  item:3.
	acronymParentElem := acronymElem  parentNode.
	clonedacronymElem := acronymElem  cloneNode:true.
	appendedNode := acronymParentElem  appendChild:clonedacronymElem.
	attr := acronymElem  getAttributeNode:'id'.
	id := attr  isId.
	self assert: id.

!

test_attrisid06
	"
	Invoke isId on a new Attr node.  Check if the value returned is false.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Attr-isId
	"
	|
	  doc "Document"
	  attr "Attr"
	  id "Boolean"
	|
	id := false.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	attr := doc  createAttribute:'xml:lang' ns:'http://www.w3.org/XML/1998/namespace'.
	id := attr  isId.
	self deny: id.

!

test_attrisid07
	"
	The method isId returns whether this attribute is known to be of type ID or not.
	
	Add a new attribute of type ID to the third acronym element node of this document. Verify that the method
        isId returns true. The use of Element.setIdAttributeNS() makes 'isId' a user-determined ID attribute.
	Import the newly created attribute node into this document.  
        Since user data assocated to the imported node is not carried over, verify that the method isId
        returns false on the imported attribute node.        


		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Attr-isId
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  acronymElem "Element"
	  attributesMap "NamedNodeMap"
	  attr "Attr"
	  attrImported "Attr"
	  id "Boolean"
	  elem "Element"
	  elemName "String"
	|
	"implementationAttribute not supported: namespaceAware"
	id := false.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'acronym' ns: '*'.
	acronymElem := elemList  item:2.
	acronymElem  setAttribute: 'dom3:newAttr' ns: 'http://www.w3.org/DOM' value: 'null'.
	acronymElem  setIdAttribute: 'newAttr' ns: 'http://www.w3.org/DOM' isId:true.
	attr := acronymElem  getAttributeNode: 'newAttr' ns: 'http://www.w3.org/DOM'.
	id := attr  isId.
	self assert: id.
	attrImported := doc  importNode:attr deep:false.
	id := attrImported  isId.
	self deny: id.

!

test_canonicalform01
	"
Normalize document with 'canonical-form' set to true, check that
entity references are expanded and unused entity declaration are maintained.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-normalizeDocument
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-canonical-form
	"
	|
	  doc "Document"
	  pList "NodeList"
	  pElem "Element"
	  domConfig "DOMConfiguration"
	  canSet "Boolean"
	  canSetValidate "Boolean"
	  errorMonitor "DOMErrorMonitor"
	  child "Node"
	  childName "String"
	  entRef "EntityReference"
	  childValue "String"
	  entities "NamedNodeMap"
	  ent2 "Entity"
	  doctype "DocumentType"
	|
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	domConfig := doc domConfig.
	canSet := domConfig canSetParameter: 'canonical-form' value: true.
	"if"
	(canSet) ifTrue: [
																	].

!

test_canonicalform02
	"
Normalize document with normalize-characters set to false, check that
characters are not normalized.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-normalizeDocument
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-canonical-form
		Subject http://www.w3.org/TR/2003/WD-charmod-20030822/
	"
	|
	  doc "Document"
	  docElem "Element"
	  domConfig "DOMConfiguration"
	  errorMonitor "DOMErrorMonitor"
	  pList "NodeList"
	  pElem "Element"
	  text "Text"
	  textValue "String"
	  retval "Node"
	  canSet "Boolean"
	|
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	domConfig := doc domConfig.
	canSet := domConfig canSetParameter: 'canonical-form' value: true.
	"if"
	(canSet) ifTrue: [
														].

!

test_canonicalform03
	"
Normalize a document with the 'canonical-form' parameter set to true and
check that a CDATASection has been eliminated.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-normalizeDocument
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-canonical-form
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  elemName "Element"
	  cdata "CDATASection"
	  text "Text"
	  nodeName "String"
	  domConfig "DOMConfiguration"
	  errorMonitor "DOMErrorMonitor"
	  canSet "Boolean"
	|
	"implementationAttribute not supported: namespaceAware"
	"implementationAttribute not supported: coalescing"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'strong'.
	elemName := elemList  item:1.
	cdata := elemName  lastChild.
	nodeName := cdata  nodeName.
	self assert: ( nodeName = '#cdata-section' ).
	domConfig := doc domConfig.
	domConfig setParameter: 'error-handler' value: errorMonitor.
	canSet := domConfig canSetParameter: 'canonical-form' value: true.
	"if"
	(canSet) ifTrue: [
									].

!

test_canonicalform04
	"
Normalize document with canonical-form set to true, check that
namespace declaration attributes are maintained.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-normalizeDocument
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-canonical-form
	"
	|
	  doc "Document"
	  docElem "Element"
	  domConfig "DOMConfiguration"
	  errorMonitor "DOMErrorMonitor"
	  xmlnsAttr "Attr"
	  canSet "Boolean"
	|
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	domConfig := doc domConfig.
	canSet := domConfig canSetParameter: 'canonical-form' value: true.
	"if"
	(canSet) ifTrue: [
								].

!

test_canonicalform05
	"
Add a L1 element to a L2 namespace aware document and perform namespace normalization.  Should result
in an error.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-normalizeDocument
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/namespaces-algorithms#normalizeDocumentAlgo
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-canonical-form
	"
	|
	  doc "Document"
	  elem "Element"
	  domConfig "DOMConfiguration"
	  pList "NodeList"
	  newChild "Element"
	  retval "Element"
	  errorMonitor "DOMErrorMonitor"
	  errors "List"
	  error "DOMError"
	  errorCount "SmallInteger"
	  severity "SmallInteger"
	  problemNode "Node"
	  location "DOMLocator"
	  lineNumber "SmallInteger"
	  columnNumber "SmallInteger"
	  byteOffset "SmallInteger"
	  utf16Offset "SmallInteger"
	  uri "String"
	  type "String"
	  message "String"
	  relatedException "DOMObject"
	  relatedData "DOMObject"
	  length "SmallInteger"
	  canSet "Boolean"
	|
	"implementationAttribute not supported: namespaceAware"
	errorCount := 0.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	pList := doc  getElementsByTagName: 'p'.
	elem := pList  item:0.
	newChild := doc  createElement:'br'.
	retval := elem  appendChild:newChild.
	domConfig := doc domConfig.
	canSet := domConfig canSetParameter: 'canonical-form' value: true.
	"if"
	(canSet) ifTrue: [
						severity := error  severity.
	"if"
	( severity = 2 ) ifTrue: [
																	self assert:false description:'Method "greater" is not supported yet'.
					].
		].

!

test_canonicalform06
	"
Create a document with an XML 1.1 valid but XML 1.0 invalid element and
normalize document with canonical-form set to true.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-normalizeDocument
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-canonical-form
	"
	|
	  domImpl "DOMImplementation"
	  nullString "String"
	  nullDoctype "DocumentType"
	  doc "Document"
	  elem "Element"
	  retval "Node"
	  domConfig "DOMConfiguration"
	  errorMonitor "DOMErrorMonitor"
	  errors "List"
	  error "DOMError"
	  severity "SmallInteger"
	  type "String"
	  locator "DOMLocator"
	  relatedNode "Node"
	  canSet "Boolean"
	|
	nullString := nil.
	nullDoctype := nil.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	doc := domImpl createDocumentNS: nullString qualifiedName: nullString doctype: nullDoctype.
	"assertDOMException..."
	self should:[
	elem := doc  createElement:'LegalNameࢎ' ns:'http://www.example.org/domts/wellformed01'.
	] raise: DOMException.
	self assert: (lastException code == DOMException INVALID_CHARACTER_ERR).
	"end of assertDOMException..."
	"try"
	[
	] on: DOMException do: [:ex|	].
	"end of try"
	elem := doc  createElement:'LegalNameࢎ' ns:'http://www.example.org/domts/wellformed01'.
	retval := doc  appendChild:elem.
	domConfig := doc domConfig.
	canSet := domConfig canSetParameter: 'canonical-form' value: true.
	"if"
	(canSet) ifTrue: [
						severity := error  severity.
	self assert: ( severity = 2 ).
	type := error  type.
	self assert: ( type = 'wf-invalid-character-in-node-name' ).
	locator := error  location.
	relatedNode := locator  relatedNode.
	self assert: relatedNode == elem.
		].

!

test_canonicalform07
	"
Normalize document with canonical-form set to true and validation set to true, check that
whitespace in element content is preserved.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-normalizeDocument
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-canonical-form
	"
	|
	  doc "Document"
	  bodyList "NodeList"
	  body "Element"
	  domConfig "DOMConfiguration"
	  canSet "Boolean"
	  canSetValidate "Boolean"
	  errorMonitor "DOMErrorMonitor"
	  child "Node"
	  childName "String"
	  text "Text"
	|
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	domConfig := doc domConfig.
	canSet := domConfig canSetParameter: 'canonical-form' value: true.
	"if"
	(canSet) ifTrue: [
				^self. "ignoringElementContentWhitespace supported"
	bodyList := doc  getElementsByTagName: 'body'.
	body := bodyList  item:0.
	child := body  firstChild.
	text := doc  createTextNode:'    '.
	body  insert:text before: child.
													].

!

test_canonicalform08
	"
Normalize document based on section 3.1 with canonical-form set to true and check normalized document.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-normalizeDocument
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-canonical-form
	"
	|
	  doc "Document"
	  bodyList "NodeList"
	  body "Element"
	  domConfig "DOMConfiguration"
	  canSet "Boolean"
	  canSetValidate "Boolean"
	  errorMonitor "DOMErrorMonitor"
	  node "Node"
	  nodeName "String"
	  nodeValue "String"
	  nodeType "SmallInteger"
	  length "SmallInteger"
	  text "Text"
	|
	"implementationAttribute not supported: namespaceAware"
	"implementationAttribute not supported: validating"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'canonicalform01').
	domConfig := doc domConfig.
	canSet := domConfig canSetParameter: 'canonical-form' value: true.
	"if"
	(canSet) ifTrue: [
																																																			].

!

test_canonicalform09
	"
Normalize document based on section 3.1 with canonical-form set to true 
and comments to false and check normalized document.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-normalizeDocument
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-canonical-form
	"
	|
	  doc "Document"
	  bodyList "NodeList"
	  body "Element"
	  domConfig "DOMConfiguration"
	  canSet "Boolean"
	  canSetValidate "Boolean"
	  errorMonitor "DOMErrorMonitor"
	  node "Node"
	  nodeName "String"
	  nodeValue "String"
	  nodeType "SmallInteger"
	  length "SmallInteger"
	  text "Text"
	|
	"implementationAttribute not supported: namespaceAware"
	"implementationAttribute not supported: validating"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'canonicalform01').
	domConfig := doc domConfig.
	canSet := domConfig canSetParameter: 'canonical-form' value: true.
	"if"
	(canSet) ifTrue: [
																																		].

!

test_canonicalform10
	"
Check elimination of unnecessary namespace prefixes when
normalized with canonical-form = true.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-normalizeDocument
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-canonical-form
	"
	|
	  doc "Document"
	  divList "NodeList"
	  div "Element"
	  domConfig "DOMConfiguration"
	  canSet "Boolean"
	  errorMonitor "DOMErrorMonitor"
	  node "Node"
	|
	"implementationAttribute not supported: namespaceAware"
	"implementationAttribute not supported: validating"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'canonicalform03').
	domConfig := doc domConfig.
	canSet := domConfig canSetParameter: 'canonical-form' value: true.
	"if"
	(canSet) ifTrue: [
											].

!

test_canonicalform11
	"
Check that default attributes are made explicitly specified.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-normalizeDocument
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-canonical-form
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  elem "Element"
	  domConfig "DOMConfiguration"
	  canSet "Boolean"
	  errorMonitor "DOMErrorMonitor"
	  attr "Attr"
	  attrValue "String"
	  attrSpecified "Boolean"
	|
	"implementationAttribute not supported: namespaceAware"
	"implementationAttribute not supported: validating"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'canonicalform03').
	domConfig := doc domConfig.
	canSet := domConfig canSetParameter: 'canonical-form' value: true.
	"if"
	(canSet) ifTrue: [
													].

!

test_canonicalform12
	"
Normalize document with 'canonical-form' set to true, check that
DocumentType nodes are removed.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-normalizeDocument
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-canonical-form
	"
	|
	  doc "Document"
	  domConfig "DOMConfiguration"
	  canSet "Boolean"
	  errorMonitor "DOMErrorMonitor"
	  doctype "DocumentType"
	|
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	domConfig := doc domConfig.
	canSet := domConfig canSetParameter: 'canonical-form' value: true.
	"if"
	(canSet) ifTrue: [
							].

!

test_cdatasections01
	"
Normalize a document using Node.normalize and check that
the value of the 'cdata-sections' parameter is ignored.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-normalize
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-cdata-sections
	"
	|
	  doc "Document"
	  elem "Element"
	  newCdata "CDATASection"
	  cdata "CDATASection"
	  text "Node"
	  nodeName "String"
	  nodeValue "String"
	  appendedChild "Node"
	  domConfig "DOMConfiguration"
	  pList "NodeList"
	  errorMonitor "DOMErrorMonitor"
	|
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	pList := doc  getElementsByTagName: 'p'.
	elem := pList  item:0.
	newCdata := doc  createCDATASection:'CDATA'.
	appendedChild := elem  appendChild:newCdata.
	domConfig := doc domConfig.
	domConfig setParameter: 'cdata-sections' value: false.
	domConfig setParameter: 'error-handler' value: errorMonitor.
	doc  normalize.
	errorMonitor  assertLowerSeverityFor: self message:'normalizationError' severity: DOMErrorMonitor SEVERITY_ERROR.
	pList := doc  getElementsByTagName: 'p'.
	elem := pList  item:0.
	cdata := elem  lastChild.
	nodeName := cdata  nodeName.
	self assert: ( nodeName = '#cdata-section' ).

!

test_checkcharacternormalization01
	"
Normalize document with check-character-normalization set to false, check that
no errors are dispatched.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-normalizeDocument
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-check-character-normalization
		Subject http://www.w3.org/TR/2003/WD-charmod-20030822/
	"
	|
	  doc "Document"
	  docElem "Element"
	  domConfig "DOMConfiguration"
	  errorMonitor "DOMErrorMonitor"
	  pList "NodeList"
	  pElem "Element"
	  text "Text"
	  textValue "String"
	  retval "Node"
	|
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	domConfig := doc domConfig.
	domConfig setParameter: 'error-handler' value: errorMonitor.
	domConfig setParameter: 'check-character-normalization' value: false.
	pList := doc  getElementsByTagName: 'p'.
	pElem := pList  item:0.
	text := doc  createTextNode:'suçon'.
	retval := pElem  appendChild:text.
	doc  normalizeDocument.
	errorMonitor  assertLowerSeverityFor: self message:'normalizeError' severity: DOMErrorMonitor SEVERITY_ERROR.
	pList := doc  getElementsByTagName: 'p'.
	pElem := pList  item:0.
	text := pElem  firstChild.
	textValue := text  nodeValue.
	self assert: ( textValue = 'barsuçon' ).

!

test_checkcharacternormalization02
	"
Normalize document with check-character-normalization set to true, check that
non-normalized characters are signaled.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-normalizeDocument
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-check-character-normalization
		Subject http://www.w3.org/TR/2003/WD-charmod-20030822/
	"
	|
	  doc "Document"
	  docElem "Element"
	  domConfig "DOMConfiguration"
	  errorMonitor "DOMErrorMonitor"
	  pList "NodeList"
	  pElem "Element"
	  text "Text"
	  textValue "String"
	  retval "Node"
	  canSet "Boolean"
	  errors "List"
	  error "DOMError"
	  severity "SmallInteger"
	  locator "DOMLocator"
	  relatedNode "Node"
	  errorCount "SmallInteger"
	  errorType "String"
	|
	"implementationAttribute not supported: namespaceAware"
	errorCount := 0.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	domConfig := doc domConfig.
	canSet := domConfig canSetParameter: 'check-character-normalization' value: true.
	"if"
	(canSet) ifTrue: [
										severity := error  severity.
	"if"
	( severity = 2 ) ifTrue: [
							].
		].

!

test_checkcharacternormalization03
	"
Normalize document using Node.normalize checking that  check-character-normalization 
is ignored.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-normalize
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-check-character-normalization
		Subject http://www.w3.org/TR/2003/WD-charmod-20030822/
	"
	|
	  doc "Document"
	  docElem "Element"
	  domConfig "DOMConfiguration"
	  errorMonitor "DOMErrorMonitor"
	  pList "NodeList"
	  pElem "Element"
	  text "Text"
	  textValue "String"
	  retval "Node"
	  canSet "Boolean"
	|
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	domConfig := doc domConfig.
	canSet := domConfig canSetParameter: 'check-character-normalization' value: true.
	"if"
	(canSet) ifTrue: [
														].

!

test_comments01
        "
Check that Node.normalize ignores the setting of configuration parameter 'comments'.

                Creator: Curt Arnold
                Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-normalize
                Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-comments
        "
        |
          doc "Document"
          elem "Element"
          newComment "Comment"
          lastChild "Node"
          text "Text"
          nodeName "String"
          appendedChild "Node"
          domConfig "DOMConfiguration"
          errorMonitor "DOMErrorMonitor"
          pList "NodeList"
        |
        "implementationAttribute not supported: namespaceAware"
        doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
        pList := doc  getElementsByTagName: 'p'.
        elem := pList  item:0.
        newComment := doc  createComment:'COMMENT_NODE'.
        appendedChild := elem  appendChild:newComment.
        domConfig := doc domConfig.
        domConfig setParameter: 'comments' value: false.
        domConfig setParameter: 'error-handler' value: errorMonitor.
        doc  normalize.
        errorMonitor  assertLowerSeverityFor: self message:'normalizationError' severity: DOMErrorMonitor SEVERITY_ERROR.
        pList := doc  getElementsByTagName: 'p'.
        elem := pList  item:0.
        lastChild := elem  lastChild.
        nodeName := lastChild  nodeName.
        self assert: ( nodeName = '#comment' ).

!

test_datatypenormalization01
	"
Normalize document with datatype-normalization set to true.  
Check if double values were normalized.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-normalizeDocument
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-datatype-normalization
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  element "Element"
	  domConfig "DOMConfiguration"
	  str "String"
	  canSetNormalization "Boolean"
	  canSetValidate "Boolean"
	  canSetXMLSchema "Boolean"
	  xsdNS "String"
	  errorMonitor "DOMErrorMonitor"
	|
	"implementationAttribute not supported: namespaceAware"
	xsdNS := 'http://www.w3.org/2001/XMLSchema'.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'datatype_normalization').
	domConfig := doc domConfig.
	canSetNormalization := domConfig canSetParameter: 'datatype-normalization' value: true.
	canSetValidate := domConfig canSetParameter: 'validate' value: true.
	canSetXMLSchema := domConfig canSetParameter: 'schema-type' value: xsdNS.
	"if"
	(canSetNormalization) and: [(canSetValidate) and: [(canSetXMLSchema)]] ifTrue: [
																													].

!

test_datatypenormalization02
	"
Normalize document with datatype-normalization set to true.  
Check if decimal values were normalized.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-normalizeDocument
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-datatype-normalization
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  element "Element"
	  domConfig "DOMConfiguration"
	  str "String"
	  canSetNormalization "Boolean"
	  canSetValidate "Boolean"
	  canSetXMLSchema "Boolean"
	  xsdNS "String"
	  errorMonitor "DOMErrorMonitor"
	|
	"implementationAttribute not supported: namespaceAware"
	xsdNS := 'http://www.w3.org/2001/XMLSchema'.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'datatype_normalization').
	domConfig := doc domConfig.
	canSetNormalization := domConfig canSetParameter: 'datatype-normalization' value: true.
	canSetValidate := domConfig canSetParameter: 'validate' value: true.
	canSetXMLSchema := domConfig canSetParameter: 'schema-type' value: xsdNS.
	"if"
	(canSetNormalization) and: [(canSetValidate) and: [(canSetXMLSchema)]] ifTrue: [
																						].

!

test_datatypenormalization03
	"
Normalize document with datatype-normalization set to true.  
Check if boolean values were whitespace normalized.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-normalizeDocument
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-datatype-normalization
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  element "Element"
	  domConfig "DOMConfiguration"
	  str "String"
	  canSetNormalization "Boolean"
	  canSetValidate "Boolean"
	  canSetXMLSchema "Boolean"
	  xsdNS "String"
	  errorMonitor "DOMErrorMonitor"
	|
	"implementationAttribute not supported: namespaceAware"
	xsdNS := 'http://www.w3.org/2001/XMLSchema'.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'datatype_normalization').
	domConfig := doc domConfig.
	canSetNormalization := domConfig canSetParameter: 'datatype-normalization' value: true.
	canSetValidate := domConfig canSetParameter: 'validate' value: true.
	canSetXMLSchema := domConfig canSetParameter: 'schema-type' value: xsdNS.
	"if"
	(canSetNormalization) and: [(canSetValidate) and: [(canSetXMLSchema)]] ifTrue: [
																						].

!

test_datatypenormalization04
	"
Normalize document with datatype-normalization set to true.  
Check if float values were normalized.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-normalizeDocument
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-datatype-normalization
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  element "Element"
	  domConfig "DOMConfiguration"
	  str "String"
	  canSetNormalization "Boolean"
	  canSetValidate "Boolean"
	  canSetXMLSchema "Boolean"
	  xsdNS "String"
	  errorMonitor "DOMErrorMonitor"
	|
	"implementationAttribute not supported: namespaceAware"
	xsdNS := 'http://www.w3.org/2001/XMLSchema'.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'datatype_normalization').
	domConfig := doc domConfig.
	canSetNormalization := domConfig canSetParameter: 'datatype-normalization' value: true.
	canSetValidate := domConfig canSetParameter: 'validate' value: true.
	canSetXMLSchema := domConfig canSetParameter: 'schema-type' value: xsdNS.
	"if"
	(canSetNormalization) and: [(canSetValidate) and: [(canSetXMLSchema)]] ifTrue: [
																													].

!

test_datatypenormalization05
	"
Normalize document with datatype-normalization set to true.  
Check if dateTime values were correctly normalized.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-normalizeDocument
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-datatype-normalization
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  element "Element"
	  domConfig "DOMConfiguration"
	  str "String"
	  canSetNormalization "Boolean"
	  canSetValidate "Boolean"
	  canSetXMLSchema "Boolean"
	  xsdNS "String"
	  errorMonitor "DOMErrorMonitor"
	|
	"implementationAttribute not supported: namespaceAware"
	xsdNS := 'http://www.w3.org/2001/XMLSchema'.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'datatype_normalization').
	domConfig := doc domConfig.
	canSetNormalization := domConfig canSetParameter: 'datatype-normalization' value: true.
	canSetValidate := domConfig canSetParameter: 'validate' value: true.
	canSetXMLSchema := domConfig canSetParameter: 'schema-type' value: xsdNS.
	"if"
	(canSetNormalization) and: [(canSetValidate) and: [(canSetXMLSchema)]] ifTrue: [
																													].

!

test_datatypenormalization06
	"
Normalize document with datatype-normalization set to true.  
Check if time values were normalized.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-normalizeDocument
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-datatype-normalization
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  element "Element"
	  domConfig "DOMConfiguration"
	  str "String"
	  canSetNormalization "Boolean"
	  canSetValidate "Boolean"
	  canSetXMLSchema "Boolean"
	  xsdNS "String"
	  errorMonitor "DOMErrorMonitor"
	|
	"implementationAttribute not supported: namespaceAware"
	xsdNS := 'http://www.w3.org/2001/XMLSchema'.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'datatype_normalization').
	domConfig := doc domConfig.
	canSetNormalization := domConfig canSetParameter: 'datatype-normalization' value: true.
	canSetValidate := domConfig canSetParameter: 'validate' value: true.
	canSetXMLSchema := domConfig canSetParameter: 'schema-type' value: xsdNS.
	"if"
	(canSetNormalization) and: [(canSetValidate) and: [(canSetXMLSchema)]] ifTrue: [
																													].

!

test_datatypenormalization07
	"
The default value for the double element must be provided in canonical lexical form.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-normalizeDocument
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-datatype-normalization
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  element "Element"
	  domConfig "DOMConfiguration"
	  str "String"
	  canSetNormalization "Boolean"
	  canSetValidate "Boolean"
	  canSetXMLSchema "Boolean"
	  xsdNS "String"
	  errorMonitor "DOMErrorMonitor"
	|
	"implementationAttribute not supported: namespaceAware"
	xsdNS := 'http://www.w3.org/2001/XMLSchema'.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'datatype_normalization').
	domConfig := doc domConfig.
	canSetNormalization := domConfig canSetParameter: 'datatype-normalization' value: true.
	canSetValidate := domConfig canSetParameter: 'validate' value: true.
	canSetXMLSchema := domConfig canSetParameter: 'schema-type' value: xsdNS.
	"if"
	(canSetNormalization) and: [(canSetValidate) and: [(canSetXMLSchema)]] ifTrue: [
											].

!

test_datatypenormalization08
	"
The default value for the decimal element must be provided in canonical lexical form.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-normalizeDocument
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-datatype-normalization
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  element "Element"
	  domConfig "DOMConfiguration"
	  str "String"
	  canSetNormalization "Boolean"
	  canSetValidate "Boolean"
	  canSetXMLSchema "Boolean"
	  xsdNS "String"
	  errorMonitor "DOMErrorMonitor"
	|
	"implementationAttribute not supported: namespaceAware"
	xsdNS := 'http://www.w3.org/2001/XMLSchema'.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'datatype_normalization').
	domConfig := doc domConfig.
	canSetNormalization := domConfig canSetParameter: 'datatype-normalization' value: true.
	canSetValidate := domConfig canSetParameter: 'validate' value: true.
	canSetXMLSchema := domConfig canSetParameter: 'schema-type' value: xsdNS.
	"if"
	(canSetNormalization) and: [(canSetValidate) and: [(canSetXMLSchema)]] ifTrue: [
											].

!

test_datatypenormalization09
	"
The default value for the boolean element must be provided in canonical lexical form.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-normalizeDocument
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-datatype-normalization
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  element "Element"
	  domConfig "DOMConfiguration"
	  str "String"
	  canSetNormalization "Boolean"
	  canSetValidate "Boolean"
	  canSetXMLSchema "Boolean"
	  xsdNS "String"
	  errorMonitor "DOMErrorMonitor"
	|
	"implementationAttribute not supported: namespaceAware"
	xsdNS := 'http://www.w3.org/2001/XMLSchema'.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'datatype_normalization').
	domConfig := doc domConfig.
	canSetNormalization := domConfig canSetParameter: 'datatype-normalization' value: true.
	canSetValidate := domConfig canSetParameter: 'validate' value: true.
	canSetXMLSchema := domConfig canSetParameter: 'schema-type' value: xsdNS.
	"if"
	(canSetNormalization) and: [(canSetValidate) and: [(canSetXMLSchema)]] ifTrue: [
											].

!

test_datatypenormalization10
	"
The default value for the float element must be provided in canonical lexical form.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-normalizeDocument
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-datatype-normalization
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  element "Element"
	  domConfig "DOMConfiguration"
	  str "String"
	  canSetNormalization "Boolean"
	  canSetValidate "Boolean"
	  canSetXMLSchema "Boolean"
	  xsdNS "String"
	  errorMonitor "DOMErrorMonitor"
	|
	"implementationAttribute not supported: namespaceAware"
	xsdNS := 'http://www.w3.org/2001/XMLSchema'.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'datatype_normalization').
	domConfig := doc domConfig.
	canSetNormalization := domConfig canSetParameter: 'datatype-normalization' value: true.
	canSetValidate := domConfig canSetParameter: 'validate' value: true.
	canSetXMLSchema := domConfig canSetParameter: 'schema-type' value: xsdNS.
	"if"
	(canSetNormalization) and: [(canSetValidate) and: [(canSetXMLSchema)]] ifTrue: [
											].

!

test_datatypenormalization11
	"
The default value for the dateTime element must be provided in canonical lexical form.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-normalizeDocument
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-datatype-normalization
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  element "Element"
	  domConfig "DOMConfiguration"
	  str "String"
	  canSetNormalization "Boolean"
	  canSetValidate "Boolean"
	  canSetXMLSchema "Boolean"
	  xsdNS "String"
	  errorMonitor "DOMErrorMonitor"
	|
	"implementationAttribute not supported: namespaceAware"
	xsdNS := 'http://www.w3.org/2001/XMLSchema'.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'datatype_normalization').
	domConfig := doc domConfig.
	canSetNormalization := domConfig canSetParameter: 'datatype-normalization' value: true.
	canSetValidate := domConfig canSetParameter: 'validate' value: true.
	canSetXMLSchema := domConfig canSetParameter: 'schema-type' value: xsdNS.
	"if"
	(canSetNormalization) and: [(canSetValidate) and: [(canSetXMLSchema)]] ifTrue: [
											].

!

test_datatypenormalization12
	"
Default values must be provided in canonical lexical form.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-normalizeDocument
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-datatype-normalization
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  element "Element"
	  domConfig "DOMConfiguration"
	  str "String"
	  canSetNormalization "Boolean"
	  canSetValidate "Boolean"
	  canSetXMLSchema "Boolean"
	  xsdNS "String"
	  errorMonitor "DOMErrorMonitor"
	|
	"implementationAttribute not supported: namespaceAware"
	xsdNS := 'http://www.w3.org/2001/XMLSchema'.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'datatype_normalization').
	domConfig := doc domConfig.
	canSetNormalization := domConfig canSetParameter: 'datatype-normalization' value: true.
	canSetValidate := domConfig canSetParameter: 'validate' value: true.
	canSetXMLSchema := domConfig canSetParameter: 'schema-type' value: xsdNS.
	"if"
	(canSetNormalization) and: [(canSetValidate) and: [(canSetXMLSchema)]] ifTrue: [
											].

!

test_datatypenormalization13
	"
Normalize document with datatype-normalization set to true.  
Check if string values were normalized per default whitespace
facet of xsd:string.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-normalizeDocument
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-datatype-normalization
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  element "Element"
	  domConfig "DOMConfiguration"
	  str "String"
	  canSetNormalization "Boolean"
	  canSetValidate "Boolean"
	  canSetXMLSchema "Boolean"
	  xsdNS "String"
	  errorMonitor "DOMErrorMonitor"
	  childNode "Node"
	  childValue "String"
	|
	"implementationAttribute not supported: namespaceAware"
	xsdNS := 'http://www.w3.org/2001/XMLSchema'.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'datatype_normalization2').
	domConfig := doc domConfig.
	canSetNormalization := domConfig canSetParameter: 'datatype-normalization' value: true.
	canSetValidate := domConfig canSetParameter: 'validate' value: true.
	canSetXMLSchema := domConfig canSetParameter: 'schema-type' value: xsdNS.
	"if"
	(canSetNormalization) and: [(canSetValidate) and: [(canSetXMLSchema)]] ifTrue: [
													].

!

test_datatypenormalization14
	"
Normalize document with datatype-normalization set to true.  
Check if string values were normalized per explicit whitespace=preserve.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-normalizeDocument
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-datatype-normalization
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  element "Element"
	  domConfig "DOMConfiguration"
	  str "String"
	  canSetNormalization "Boolean"
	  canSetValidate "Boolean"
	  canSetXMLSchema "Boolean"
	  xsdNS "String"
	  errorMonitor "DOMErrorMonitor"
	  childNode "Node"
	  childValue "String"
	|
	"implementationAttribute not supported: namespaceAware"
	xsdNS := 'http://www.w3.org/2001/XMLSchema'.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'datatype_normalization2').
	domConfig := doc domConfig.
	canSetNormalization := domConfig canSetParameter: 'datatype-normalization' value: true.
	canSetValidate := domConfig canSetParameter: 'validate' value: true.
	canSetXMLSchema := domConfig canSetParameter: 'schema-type' value: xsdNS.
	"if"
	(canSetNormalization) and: [(canSetValidate) and: [(canSetXMLSchema)]] ifTrue: [
													].

!

test_datatypenormalization15
	"
Normalize document with datatype-normalization set to true.  
Check if string values were normalized per an explicit whitespace=collapse.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-normalizeDocument
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-datatype-normalization
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  element "Element"
	  domConfig "DOMConfiguration"
	  str "String"
	  canSetNormalization "Boolean"
	  canSetValidate "Boolean"
	  canSetXMLSchema "Boolean"
	  xsdNS "String"
	  errorMonitor "DOMErrorMonitor"
	  childNode "Node"
	  childValue "String"
	|
	"implementationAttribute not supported: namespaceAware"
	xsdNS := 'http://www.w3.org/2001/XMLSchema'.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'datatype_normalization2').
	domConfig := doc domConfig.
	canSetNormalization := domConfig canSetParameter: 'datatype-normalization' value: true.
	canSetValidate := domConfig canSetParameter: 'validate' value: true.
	canSetXMLSchema := domConfig canSetParameter: 'schema-type' value: xsdNS.
	"if"
	(canSetNormalization) and: [(canSetValidate) and: [(canSetXMLSchema)]] ifTrue: [
																				].

!

test_datatypenormalization16
	"
Normalize document with datatype-normalization set to true.  
Check if string values were normalized per explicit whitespace=replace.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-normalizeDocument
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-datatype-normalization
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  element "Element"
	  domConfig "DOMConfiguration"
	  str "String"
	  canSetNormalization "Boolean"
	  canSetValidate "Boolean"
	  canSetXMLSchema "Boolean"
	  xsdNS "String"
	  errorMonitor "DOMErrorMonitor"
	  childNode "Node"
	  childValue "String"
	|
	"implementationAttribute not supported: namespaceAware"
	xsdNS := 'http://www.w3.org/2001/XMLSchema'.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'datatype_normalization2').
	domConfig := doc domConfig.
	canSetNormalization := domConfig canSetParameter: 'datatype-normalization' value: true.
	canSetValidate := domConfig canSetParameter: 'validate' value: true.
	canSetXMLSchema := domConfig canSetParameter: 'schema-type' value: xsdNS.
	"if"
	(canSetNormalization) and: [(canSetValidate) and: [(canSetXMLSchema)]] ifTrue: [
																								].

!

test_datatypenormalization17
	"
Normalize document with datatype-normalization set to false, string values
should not be normalized.  

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-normalizeDocument
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-datatype-normalization
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  element "Element"
	  domConfig "DOMConfiguration"
	  str "String"
	  canSetValidate "Boolean"
	  canSetXMLSchema "Boolean"
	  xsdNS "String"
	  errorMonitor "DOMErrorMonitor"
	  childNode "Node"
	  childValue "String"
	|
	"implementationAttribute not supported: namespaceAware"
	xsdNS := 'http://www.w3.org/2001/XMLSchema'.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'datatype_normalization2').
	domConfig := doc domConfig.
	canSetValidate := domConfig canSetParameter: 'validate' value: true.
	canSetXMLSchema := domConfig canSetParameter: 'schema-type' value: xsdNS.
	"if"
	(canSetValidate) and: [(canSetXMLSchema)] ifTrue: [
																				].

!

test_datatypenormalization18
	"
Normalize document using Node.normalize which is not affected by DOMConfiguration unlike 
Document.normalizeDocument.  Strings should not have been normalized.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-normalize
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-datatype-normalization
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  element "Element"
	  domConfig "DOMConfiguration"
	  str "String"
	  canSetValidate "Boolean"
	  canSetXMLSchema "Boolean"
	  canSetDataNorm "Boolean"
	  xsdNS "String"
	  errorMonitor "DOMErrorMonitor"
	  childNode "Node"
	  childValue "String"
	|
	"implementationAttribute not supported: namespaceAware"
	xsdNS := 'http://www.w3.org/2001/XMLSchema'.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'datatype_normalization2').
	domConfig := doc domConfig.
	canSetValidate := domConfig canSetParameter: 'validate' value: true.
	canSetXMLSchema := domConfig canSetParameter: 'schema-type' value: xsdNS.
	canSetDataNorm := domConfig canSetParameter: 'datatype-normalization' value: true.
	"if"
	(canSetValidate) and: [(canSetXMLSchema) and: [(canSetDataNorm)]] ifTrue: [
																				].

!

test_documentadoptnode01
	"
	Adopt the class attribute node of the fourth acronym element.  Check if this attribute has been adopted successfully by verifying the
	nodeName, nodeType, nodeValue, specified and ownerElement attributes of the adopted node.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-adoptNode
	"
	|
	  doc "Document"
	  attrOwnerElem "Element"
	  element "Element"
	  attr "Attr"
	  childList "NodeList"
	  adoptedclass "Node"
	  attrsParent "Node"
	  nodeName "String"
	  nodeType "SmallInteger"
	  nodeValue "String"
	  firstChild "Text"
	  firstChildValue "String"
	  secondChild "EntityReference"
	  secondChildType "SmallInteger"
	  secondChildName "String"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	childList := doc  getElementsByTagName: 'acronym'.
	element := childList  item:3.
	attr := element  getAttributeNode:'class'.
	adoptedclass := doc  adoptNode: attr.
	"if"
	( adoptedclass notNil )  ifTrue: [
												self assert:false description:'Method "equals" is not supported yet'.
	secondChild := firstChild  nextSibling.
	self assert: secondChild notNil.
	secondChildType := secondChild  nodeType.
	self assert: ( secondChildType = 5 ).
	secondChildName := secondChild  nodeName.
	self assert: ( secondChildName = 'alpha' ).
	self assert:false description:'Method "else" is not supported yet'.
	].

!

test_documentadoptnode02
	"
	Adopt the class attribute node of the fourth acronym element.  Check if this attribute has been adopted 
	successfully by verifying the nodeName, nodeType, ownerElement, specified attributes and child nodes 
	of the adopted node.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-adoptNode
	"
	|
	  doc "Document"
	  newDoc "Document"
	  domImpl "DOMImplementation"
	  attrOwnerElem "Element"
	  element "Element"
	  attr "Attr"
	  childList "NodeList"
	  adoptedclass "Node"
	  attrsParent "Node"
	  nodeName "String"
	  nodeType "SmallInteger"
	  nodeValue "String"
	  isSpecified "Boolean"
	  nullDocType "DocumentType"
	  firstChild "Text"
	  firstChildValue "String"
	  secondChild "EntityReference"
	  secondChildType "SmallInteger"
	  secondChildName "String"
	  docElem "Element"
	  rootNS "String"
	  rootName "String"
	|
	nullDocType := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docElem := doc  documentElement.
	rootName := docElem  tagName.
	rootNS := docElem  namespaceURI.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	newDoc := domImpl createDocumentNS: rootNS qualifiedName: rootName doctype: nullDocType.
	childList := doc  getElementsByTagName: 'acronym'.
	element := childList  item:3.
	attr := element  getAttributeNode:'class'.
	adoptedclass := newDoc  adoptNode: attr.
	"if"
	( adoptedclass notNil )  ifTrue: [
														self assert:false description:'Method "equals" is not supported yet'.
	secondChild := firstChild  nextSibling.
	self assert: secondChild notNil.
	secondChildType := secondChild  nodeType.
	self assert: ( secondChildType = 5 ).
	secondChildName := secondChild  nodeName.
	self assert: ( secondChildName = 'alpha' ).
	self assert:false description:'Method "else" is not supported yet'.
	].

!

test_documentadoptnode03
	"
	Invoke adoptNode on this document to adopt the a new namespace aware attribute node.  Check 
	if this attribute has been adopted successfully by verifying the nodeName, namespaceURI, prefix, 
	specified and ownerElement attributes of the adopted node.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-adoptNode
	"
	|
	  doc "Document"
	  newAttr "Attr"
	  adoptedAttr "Attr"
	  nodeName "String"
	  nodeNamespaceURI "String"
	  nodePrefix "String"
	  attrOwnerElem "Element"
	  isSpecified "Boolean"
	  xmlNS "String"
	|
	xmlNS := 'http://www.w3.org/XML/1998/namespace'.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	newAttr := doc  createAttribute:'xml:lang' ns:xmlNS.
	adoptedAttr := doc  adoptNode: newAttr.
	"if"
	( adoptedAttr notNil )  ifTrue: [
											].

!

test_documentadoptnode04
	"
	Invoke adoptNode on a new document to adopt a new namespace aware attribute node created by 
	this document.  Check if this attribute has been adopted successfully by verifying the nodeName, 
	namespaceURI, prefix, specified and ownerElement attributes of the adopted node.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-adoptNode
	"
	|
	  doc "Document"
	  newDoc "Document"
	  domImpl "DOMImplementation"
	  newAttr "Attr"
	  adoptedAttr "Attr"
	  nodeName "String"
	  nodeNamespaceURI "String"
	  nodePrefix "String"
	  attrOwnerElem "Element"
	  isSpecified "Boolean"
	  nullDocType "DocumentType"
	  docElem "Element"
	  rootNS "String"
	  rootName "String"
	  xmlNS "String"
	|
	nullDocType := nil.
	xmlNS := 'http://www.w3.org/XML/1998/namespace'.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docElem := doc  documentElement.
	rootName := docElem  tagName.
	rootNS := docElem  namespaceURI.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	newDoc := domImpl createDocumentNS: rootNS qualifiedName: rootName doctype: nullDocType.
	newAttr := doc  createAttribute:'xml:lang' ns:xmlNS.
	adoptedAttr := newDoc  adoptNode: newAttr.
	"if"
	( adoptedAttr notNil )  ifTrue: [
											].

!

test_documentadoptnode05
	"
	Invoke adoptNode on a new document to adopt the default attribute  dir .  Check if 
	this attribute has been adopted successfully by verifying the nodeName, namespaceURI, prefix, 
	specified and ownerElement attributes of the adopted node.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-adoptNode
	"
	|
	  doc "Document"
	  newDoc "Document"
	  domImpl "DOMImplementation"
	  elementEmp "Element"
	  childList "NodeList"
	  dir "Attr"
	  adoptedAttr "Node"
	  nodeName "String"
	  nodeNamespaceURI "String"
	  nodePrefix "String"
	  attrOwnerElem "Element"
	  isSpecified "Boolean"
	  nullDocType "DocumentType"
	  docElem "Element"
	  rootNS "String"
	  rootName "String"
	|
	nullDocType := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docElem := doc  documentElement.
	rootName := docElem  tagName.
	rootNS := docElem  namespaceURI.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	newDoc := domImpl createDocumentNS: rootNS qualifiedName: rootName doctype: nullDocType.
	childList := doc  getElementsByTagName: 'p'.
	elementEmp := childList  item:3.
	dir := elementEmp  getAttributeNode:'dir'.
	adoptedAttr := newDoc  adoptNode: dir.
	"if"
	( adoptedAttr notNil )  ifTrue: [
											].

!

test_documentadoptnode06
	"
	Invoke adoptNode on a new document to adopt the a new Attribute node having a Text and an EntityReference 
	child.  Check if this attribute has been adopted successfully by verifying the nodeName, namespaceURI, prefix, 
	specified and ownerElement attributes of the adopted node.  Also verify the ownerDocument attribute
	of the adopted node and the adopted children of the attribute node.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-adoptNode
	"
	|
	  doc "Document"
	  newDoc "Document"
	  domImpl "DOMImplementation"
	  newAttr "Attr"
	  newText "Text"
	  newEntRef "EntityReference"
	  adoptedAttr "Attr"
	  adoptText "Text"
	  adoptEntRef "EntityReference"
	  nodeList "NodeList"
	  nodeName "String"
	  nodeNamespaceURI "String"
	  nodePrefix "String"
	  attrOwnerElem "Element"
	  isSpecified "Boolean"
	  adoptedTextNodeValue "String"
	  adoptedEntRefNodeValue "String"
	  nullDocType "DocumentType"
	  appendedChild "Node"
	  docElem "Element"
	  rootNS "String"
	  rootName "String"
	  xmlNS "String"
	|
	nullDocType := nil.
	xmlNS := 'http://www.w3.org/XML/1998/namespace'.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docElem := doc  documentElement.
	rootName := docElem  tagName.
	rootNS := docElem  namespaceURI.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	newDoc := domImpl createDocumentNS: rootNS qualifiedName: rootName doctype: nullDocType.
	newAttr := doc  createAttribute:'xml:lang' ns:xmlNS.
	newText := doc  createTextNode:'Text Node'.
	newEntRef := doc  createEntityReference:'alpha'.
	appendedChild := newAttr  appendChild:newText.
	appendedChild := newAttr  appendChild:newEntRef.
	adoptedAttr := newDoc  adoptNode: newAttr.
	"if"
	( adoptedAttr notNil )  ifTrue: [
																		].

!

test_documentadoptnode07
	"
	Invoke the adoptNode method on this document with the value of the source parameter as itself.  
	Verify if a NOT_SUPPORTED_ERR is thrown.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-adoptNode
	"
	|
	  doc "Document"
	  adoptedDoc "Node"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	"assertDOMException..."
	self should:[
	adoptedDoc := doc  adoptNode: doc.
	] raise: DOMException.
	self assert: (lastException code == DOMException NOT_SUPPORTED_ERR).
	"end of assertDOMException..."

!

test_documentadoptnode08
	"
	Invoke the adoptNode method on this document with a new document as the value of the 
	source parameter. 	Verify if a NOT_SUPPORTED_ERR is thrown.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-adoptNode
	"
	|
	  doc "Document"
	  newDoc "Document"
	  domImpl "DOMImplementation"
	  adoptedDoc "Node"
	  nullDocType "DocumentType"
	  docElem "Element"
	  rootNS "String"
	  rootName "String"
	|
	nullDocType := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docElem := doc  documentElement.
	rootName := docElem  tagName.
	rootNS := docElem  namespaceURI.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	newDoc := domImpl createDocumentNS: rootNS qualifiedName: rootName doctype: nullDocType.
	"assertDOMException..."
	self should:[
	adoptedDoc := doc  adoptNode: newDoc.
	] raise: DOMException.
	self assert: (lastException code == DOMException NOT_SUPPORTED_ERR).
	"end of assertDOMException..."

!

test_documentadoptnode09
	"
	Invoke the adoptNode method on a new document with this document as the value of the 
	source parameter. 	Verify if a NOT_SUPPORTED_ERR is thrown.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-adoptNode
	"
	|
	  doc "Document"
	  newDoc "Document"
	  domImpl "DOMImplementation"
	  adoptedDoc "Node"
	  nullDocType "DocumentType"
	  docElem "Element"
	  rootNS "String"
	  rootName "String"
	|
	nullDocType := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docElem := doc  documentElement.
	rootName := docElem  tagName.
	rootNS := docElem  namespaceURI.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	newDoc := domImpl createDocumentNS: rootNS qualifiedName: rootName doctype: nullDocType.
	"assertDOMException..."
	self should:[
	adoptedDoc := newDoc  adoptNode: doc.
	] raise: DOMException.
	self assert: (lastException code == DOMException NOT_SUPPORTED_ERR).
	"end of assertDOMException..."

!

test_documentadoptnode10
	"
	Invoke the adoptNode method on this document with the value of the source parameter as this 
	documents doctype node.  Verify if a NOT_SUPPORTED_ERR is thrown.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-adoptNode
	"
	|
	  doc "Document"
	  docType "DocumentType"
	  adoptedDocType "Node"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docType := doc  doctype.
	"assertDOMException..."
	self should:[
	adoptedDocType := doc  adoptNode: docType.
	] raise: DOMException.
	self assert: (lastException code == DOMException NOT_SUPPORTED_ERR).
	"end of assertDOMException..."

!

test_documentadoptnode11
	"
	Invoke the adoptNode method on this document with the value of the source parameter equal to a new 
	doctype node.  Verify if a NOT_SUPPORTED_ERR is thrown.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-adoptNode
	"
	|
	  doc "Document"
	  domImpl "DOMImplementation"
	  docType "DocumentType"
	  adoptedDocType "Node"
	  nullPubID "String"
	  nullSysID "String"
	  docElem "Element"
	  rootName "String"
	|
	nullPubID := nil.
	nullSysID := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docElem := doc  documentElement.
	rootName := docElem  tagName.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	docType := domImpl  createDocumentType:rootName publicId:nullPubID systemId:nullSysID.
	"assertDOMException..."
	self should:[
	adoptedDocType := doc  adoptNode: docType.
	] raise: DOMException.
	self assert: (lastException code == DOMException NOT_SUPPORTED_ERR).
	"end of assertDOMException..."

!

test_documentadoptnode12
	"
	Invoke the adoptNode method on a new document with the value of the source parameter equal to a new 
	doctype node.  Verify if a NOT_SUPPORTED_ERR is thrown.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-adoptNode
	"
	|
	  doc "Document"
	  newDoc "Document"
	  domImpl "DOMImplementation"
	  docType "DocumentType"
	  adoptedDocType "Node"
	  nullPubID "String"
	  nullSysID "String"
	  docElem "Element"
	  rootNS "String"
	  rootName "String"
	|
	nullPubID := nil.
	nullSysID := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docElem := doc  documentElement.
	rootName := docElem  tagName.
	rootNS := docElem  namespaceURI.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	docType := domImpl  createDocumentType:rootName publicId:nullPubID systemId:nullSysID.
	newDoc := domImpl createDocumentNS: rootNS qualifiedName: rootName doctype: docType.
	"assertDOMException..."
	self should:[
	adoptedDocType := newDoc  adoptNode: docType.
	] raise: DOMException.
	self assert: (lastException code == DOMException NOT_SUPPORTED_ERR).
	"end of assertDOMException..."

!

test_documentadoptnode13
	"
	Using the method adoptNode, adopt a newly created DocumentFragment node populated with
	with the first acronym element of this Document.  Since the decendants of a documentFragment
	are recursively adopted, check if the adopted node has children.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-adoptNode
	"
	|
	  doc "Document"
	  docFragment "DocumentFragment"
	  childList "NodeList"
	  success "Boolean"
	  acronymNode "Node"
	  appendedChild "Node"
	  adoptedDocFrag "Node"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docFragment := doc  createDocumentFragment.
	childList := doc  getElementsByTagName: 'acronym'.
	acronymNode := childList  item:0.
	appendedChild := docFragment  appendChild:acronymNode.
	adoptedDocFrag := doc  adoptNode: docFragment.
	"if"
	( adoptedDocFrag notNil )  ifTrue: [
			].

!

test_documentadoptnode14
	"
	Using the method adoptNode in a new Document, adopt a newly created DocumentFragment node populated with
	with the first acronym element of this Document as its newChild.  Since the decendants of a documentFragment
	are recursively adopted, check if the adopted node has children.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-adoptNode
	"
	|
	  doc "Document"
	  newDoc "Document"
	  docElem "Element"
	  domImpl "DOMImplementation"
	  docFragment "DocumentFragment"
	  childList "NodeList"
	  success "Boolean"
	  acronymNode "Node"
	  adoptedDocFrag "Node"
	  appendedChild "Node"
	  nullDocType "DocumentType"
	  imported "Node"
	  rootNS "String"
	  rootName "String"
	|
	nullDocType := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docElem := doc  documentElement.
	rootName := docElem  tagName.
	rootNS := docElem  namespaceURI.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	newDoc := domImpl createDocumentNS: rootNS qualifiedName: rootName doctype: nullDocType.
	docFragment := newDoc  createDocumentFragment.
	imported := newDoc  importNode:docElem deep:true.
	docElem := newDoc  documentElement.
	appendedChild := docElem  appendChild:imported.
	childList := newDoc  getElementsByTagName: 'acronym'.
	acronymNode := childList  item:0.
	appendedChild := docFragment  appendChild:acronymNode.
	adoptedDocFrag := newDoc  adoptNode: docFragment.
	"if"
	( adoptedDocFrag notNil )  ifTrue: [
			].

!

test_documentadoptnode15
	"
	Using the method adoptNode, adopt a newly created DocumentFragment node without any children.  
	Check if the adopted node has no children.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-adoptNode
	"
	|
	  doc "Document"
	  docFragment "DocumentFragment"
	  success "Boolean"
	  adoptedDocFrag "Node"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docFragment := doc  createDocumentFragment.
	adoptedDocFrag := doc  adoptNode: docFragment.
	"if"
	( adoptedDocFrag notNil )  ifTrue: [
			].

!

test_documentadoptnode16
	"
Create a document fragment with an entity reference, adopt the node and check
that the entity reference value comes from the adopting documents DTD.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-adoptNode
	"
	|
	  doc "Document"
	  docFragment "DocumentFragment"
	  childList "NodeList"
	  parent "Element"
	  child "Element"
	  childsAttr "Attr"
	  entRef "EntityReference"
	  textNode "Text"
	  adopted "Node"
	  parentImp "Element"
	  childImp "Element"
	  attributes "NamedNodeMap"
	  childAttrImp "Attr"
	  nodeValue "String"
	  appendedChild "Node"
	  attrNode "Attr"
	  firstChild "Node"
	  firstChildType "SmallInteger"
	  firstChildName "String"
	  firstChildValue "String"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docFragment := doc  createDocumentFragment.
	parent := doc  createElement:'parent'.
	child := doc  createElement:'child'.
	childsAttr := doc  createAttribute:'state'.
	entRef := doc  createEntityReference:'gamma'.
	textNode := doc  createTextNode:'Test'.
	appendedChild := childsAttr  appendChild:entRef.
	attrNode := child  setAttributeNode:childsAttr.
	appendedChild := child  appendChild:textNode.
	appendedChild := parent  appendChild:child.
	appendedChild := docFragment  appendChild:parent.
	adopted := doc  adoptNode: docFragment.
	"if"
	( adopted notNil )  ifTrue: [
											self assert:false description:'Method "equals" is not supported yet'.
	self assert: ( firstChildName = 'gamma' ).
	self assert:false description:'Method "else" is not supported yet'.
	].

!

test_documentadoptnode17
	"
	Invoke the adoptNode method on this document with the entity ent1 as the source.  Since this is 
	read-only verify if a NO_MODIFICATION_ALLOWED_ERR is thrown.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-adoptNode
	"
	|
	  doc "Document"
	  docType "DocumentType"
	  entityMap "NamedNodeMap"
	  ent "Entity"
	  adoptedEnt "Node"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docType := doc  doctype.
	entityMap := docType  entities.
	ent := entityMap  getNamedItem:'alpha'.
	"assertDOMException..."
	self should:[
	adoptedEnt := doc  adoptNode: ent.
	] raise: DOMException.
	self assert: (lastException code == DOMException NO_MODIFICATION_ALLOWED_ERR).
	"end of assertDOMException..."

!

test_documentadoptnode18
	"
	Invoke the adoptNode method on a new document with the entity ent4 as the source.  Since this is 
	read-only verify if a NO_MODIFICATION_ALLOWED_ERR is thrown.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-adoptNode
	"
	|
	  doc "Document"
	  newDoc "Document"
	  domImpl "DOMImplementation"
	  docType "DocumentType"
	  entityMap "NamedNodeMap"
	  ent "Entity"
	  adoptedEnt "Node"
	  nullDocType "DocumentType"
	  docElem "Element"
	  rootNS "String"
	  rootName "String"
	|
	nullDocType := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docElem := doc  documentElement.
	rootName := docElem  tagName.
	rootNS := docElem  namespaceURI.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	newDoc := domImpl createDocumentNS: rootNS qualifiedName: rootName doctype: nullDocType.
	docType := doc  doctype.
	entityMap := docType  entities.
	ent := entityMap  getNamedItem:'delta'.
	"assertDOMException..."
	self should:[
	adoptedEnt := newDoc  adoptNode: ent.
	] raise: DOMException.
	self assert: (lastException code == DOMException NO_MODIFICATION_ALLOWED_ERR).
	"end of assertDOMException..."

!

test_documentadoptnode19
	"
	Invoke the adoptNode method on this document with the notation notation1 as the source.  Since this is 
	read-only verify if a NO_MODIFICATION_ALLOWED_ERR is thrown.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-adoptNode
	"
	|
	  doc "Document"
	  docType "DocumentType"
	  notationMap "NamedNodeMap"
	  notation "Notation"
	  adoptedNotaion "Node"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docType := doc  doctype.
	notationMap := docType  notations.
	notation := notationMap  getNamedItem:'notation1'.
	"assertDOMException..."
	self should:[
	adoptedNotaion := doc  adoptNode: notation.
	] raise: DOMException.
	self assert: (lastException code == DOMException NO_MODIFICATION_ALLOWED_ERR).
	"end of assertDOMException..."

!

test_documentadoptnode20
	"
	Invoke the adoptNode method on a new document with the notation notation2 as the source.  Since this is 
	read-only verify if a NO_MODIFICATION_ALLOWED_ERR is thrown.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-adoptNode
	"
	|
	  doc "Document"
	  newDoc "Document"
	  domImpl "DOMImplementation"
	  docType "DocumentType"
	  notationMap "NamedNodeMap"
	  notation "Notation"
	  adoptedNotation "Node"
	  nullDocType "DocumentType"
	  docElem "Element"
	  rootNS "String"
	  rootName "String"
	|
	nullDocType := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docElem := doc  documentElement.
	rootName := docElem  tagName.
	rootNS := docElem  namespaceURI.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	newDoc := domImpl createDocumentNS: rootNS qualifiedName: rootName doctype: nullDocType.
	docType := doc  doctype.
	notationMap := docType  notations.
	notation := notationMap  getNamedItem:'notation2'.
	"assertDOMException..."
	self should:[
	adoptedNotation := newDoc  adoptNode: notation.
	] raise: DOMException.
	self assert: (lastException code == DOMException NO_MODIFICATION_ALLOWED_ERR).
	"end of assertDOMException..."

!

test_documentadoptnode21
	"
	The adoptNode method changes the ownerDocument of a node, its children, as well as the 
	attached attribute nodes if there are any. If the node has a parent it is first removed 
	from its parent child list. 
	
	Invoke the adoptNode method on this Document with the source node being an existing attribute
        that is a part of this Document.   Verify that the returned adopted node's nodeName, nodeValue
        and nodeType are as expected and that the ownerElement attribute of the returned attribute node 
        was set to null.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-adoptNode
	"
	|
	  doc "Document"
	  attrOwnerElem "Element"
	  element "Element"
	  attr "Attr"
	  childList "NodeList"
	  adoptedTitle "Node"
	  attrsParent "Node"
	  nodeName "String"
	  nodeType "SmallInteger"
	  nodeValue "String"
	|
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	childList := doc  getElementsByTagName: 'acronym'.
	element := childList  item:0.
	attr := element  getAttributeNode:'title'.
	adoptedTitle := doc  adoptNode: attr.
	nodeName := adoptedTitle  nodeName.
	nodeValue := adoptedTitle  nodeValue.
	nodeType := adoptedTitle  nodeType.
	attrOwnerElem := adoptedTitle  ownerElement.
	self assert: ( nodeName = 'title' ).
	self assert: ( nodeType = 2 ).
	self assert: ( nodeValue = 'Yes' ).
	self assert: attrOwnerElem isNil.

!

test_documentadoptnode22
	"
	Invoke the adoptNode method on this document with the documentElement as the source.  
	Verify if the node has been adopted correctly by its nodeName.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-adoptNode
	"
	|
	  doc "Document"
	  docElement "Element"
	  adoptedNode "Node"
	  success "Boolean"
	  nodeNameOrig "String"
	  nodeName "String"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docElement := doc  documentElement.
	adoptedNode := doc  adoptNode: docElement.
	"if"
	( adoptedNode notNil )  ifTrue: [
						].

!

test_documentadoptnode23
	"
	Invoke the adoptNode method on this document with the first acronym element node of this
	Document as the source.  Verify if the node has been adopted correctly by checking the 
	length of the this elements childNode list before and after.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-adoptNode
	"
	|
	  doc "Document"
	  childList "NodeList"
	  adoptedNode "Node"
	  acronymElem "Node"
	  acronymElemLen "SmallInteger"
	  adoptedLen "SmallInteger"
	  acronymElemChild "NodeList"
	  adoptedNodeChild "NodeList"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	childList := doc  getElementsByTagName: 'acronym'.
	acronymElem := childList  item:0.
	adoptedNode := doc  adoptNode: acronymElem.
	"if"
	( adoptedNode notNil )  ifTrue: [
						].

!

test_documentadoptnode24
	"
	The adoptNode method changes the ownerDocument of a node, its children, as well as the 
	attached attribute nodes if there are any. If the node has a parent it is first removed 
	from its parent child list. 
	For Element Nodes, specified attribute nodes of the source element are adopted, Default 
	attributes are discarded and descendants of the source element are recursively adopted. 

	Invoke the adoptNode method on a new document with the first code element node of this
	Document as the source.  Verify if the node has been adopted correctly by checking the 
	length of the this elements childNode list before and after.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-adoptNode
	"
	|
	  doc "Document"
	  newDoc "Document"
	  domImpl "DOMImplementation"
	  childList "NodeList"
	  adoptedNode "Node"
	  codeElem "Element"
	  codeElemChildren "NodeList"
	  adoptedChildren "NodeList"
	  codeElemLen "SmallInteger"
	  adoptedLen "SmallInteger"
	  nullDocType "DocumentType"
	|
	"implementationAttribute not supported: namespaceAware"
	nullDocType := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	newDoc := domImpl createDocumentNS: 'http://www.w3.org/DOM/Test' qualifiedName: 'dom:test' doctype: nullDocType.
	childList := doc  getElementsByTagName: 'code' ns: '*'.
	codeElem := childList  item:0.
	adoptedNode := newDoc  adoptNode: codeElem.
	codeElemChildren := codeElem  childNodes.
	adoptedChildren := adoptedNode  childNodes.
	codeElemLen := codeElemChildren  length.
	adoptedLen := adoptedChildren  length.
	self assert: ( codeElemLen = adoptedLen ).

!

test_documentadoptnode25
	"
	Invoke the adoptNode method on a new document with a new Element of this
	Document as the source.  Verify if the node has been adopted correctly by checking the 
	nodeName of the adopted Element.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-adoptNode
	"
	|
	  doc "Document"
	  newElem "Element"
	  newDoc "Document"
	  domImpl "DOMImplementation"
	  adoptedNode "Node"
	  adoptedName "String"
	  adoptedNS "String"
	  docElem "Element"
	  rootNS "String"
	  rootName "String"
	  nullDocType "DocumentType"
	|
	nullDocType := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docElem := doc  documentElement.
	rootNS := docElem  namespaceURI.
	rootName := docElem  tagName.
	newElem := doc  createElement:'th' ns:'http://www.w3.org/1999/xhtml'.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	newDoc := domImpl createDocumentNS: rootNS qualifiedName: rootName doctype: nullDocType.
	adoptedNode := newDoc  adoptNode: newElem.
	"if"
	( adoptedNode notNil )  ifTrue: [
					].

!

test_documentadoptnode26
	"
	Invoke the adoptNode method on this document using a new Element and a new attribute created in 
	a new Document as the source.  Verify if the node has been adopted correctly by checking the 
	nodeName of the adopted Element and by checking if the attribute was adopted.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-adoptNode
	"
	|
	  doc "Document"
	  docElem "Element"
	  newElem "Element"
	  newDoc "Document"
	  domImpl "DOMImplementation"
	  adoptedNode "Node"
	  adoptedName "String"
	  adoptedNS "String"
	  nullDocType "DocumentType"
	  appendedChild "Node"
	  rootNS "String"
	  rootTagname "String"
	|
	nullDocType := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docElem := doc  documentElement.
	rootNS := docElem  namespaceURI.
	rootTagname := docElem  tagName.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	newDoc := domImpl createDocumentNS: rootNS qualifiedName: rootTagname doctype: nullDocType.
	newElem := newDoc  createElement:'head' ns:'http://www.w3.org/1999/xhtml'.
	newElem  setAttribute: 'xml:lang' ns: 'http://www.w3.org/XML/1998/namespace' value: 'en-US'.
	docElem := newDoc  documentElement.
	appendedChild := docElem  appendChild:newElem.
	adoptedNode := doc  adoptNode: newElem.
	"if"
	( adoptedNode notNil )  ifTrue: [
					].

!

test_documentadoptnode27
	"
	Invoke the adoptNode method on this document using a new imported Element and a new attribute created in 
	a new Document as the source.  Verify if the node has been adopted correctly by checking the 
	nodeName of the adopted Element and by checking if the attribute was adopted.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-adoptNode
	"
	|
	  doc "Document"
	  docElem "Element"
	  newElem "Element"
	  newImpElem "Element"
	  newDoc "Document"
	  domImpl "DOMImplementation"
	  adoptedNode "Node"
	  adoptedName "String"
	  adoptedNS "String"
	  appendedChild "Node"
	  nullDocType "DocumentType"
	  rootNS "String"
	  rootTagname "String"
	|
	nullDocType := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docElem := doc  documentElement.
	rootNS := docElem  namespaceURI.
	rootTagname := docElem  tagName.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	newDoc := domImpl createDocumentNS: rootNS qualifiedName: rootTagname doctype: nullDocType.
	newElem := newDoc  createElement:'xhtml:head' ns:'http://www.w3.org/1999/xhtml'.
	newElem  setAttribute: 'xml:lang' ns: 'http://www.w3.org/XML/1998/namespace' value: 'en-US'.
	docElem := newDoc  documentElement.
	appendedChild := docElem  appendChild:newElem.
	newImpElem := doc  importNode:newElem deep:true.
	adoptedNode := doc  adoptNode: newImpElem.
	"if"
	( adoptedNode notNil )  ifTrue: [
					].

!

test_documentadoptnode28
	"
	Invoke the adoptNode method on this document using the  p  element with the default 
	Attribute  dir  as the source.  Verify if the node has been adopted correctly by 
	checking the nodeName of the adopted Element and by checking if the attribute was adopted.
	Note the default attribute should be adopted in this case.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-adoptNode
	"
	|
	  doc "Document"
	  childList "NodeList"
	  adoptedNode "Node"
	  employeeElem "Node"
	  attrImp "Attr"
	  nodeName "String"
	  nullNSURI "String"
	|
	nullNSURI := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	childList := doc  getElementsByTagName: 'p'.
	employeeElem := childList  item:3.
	adoptedNode := doc  adoptNode: employeeElem.
	"if"
	( adoptedNode notNil )  ifTrue: [
				].

!

test_documentadoptnode30
	"
	Invoke the adoptNode method on this document using a new Text node as the source.  Verify 
	if the node has been adopted correctly by checking the nodeValue of the adopted node.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-adoptNode
	"
	|
	  doc "Document"
	  newText "Text"
	  adoptedText "Text"
	  nodeValue "String"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	newText := doc  createTextNode:'Document.adoptNode test for a TEXT_NODE'.
	adoptedText := doc  adoptNode: newText.
	"if"
	( adoptedText notNil )  ifTrue: [
			].

!

test_documentadoptnode31
	"
	Invoke the adoptNode method on this document using a new Text node from a new Document as the 
	source.  Verify if the node has been adopted correctly by checking the nodeValue of the adopted 
	node.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-adoptNode
	"
	|
	  doc "Document"
	  domImpl "DOMImplementation"
	  newDoc "Document"
	  newText "Text"
	  adoptedText "Text"
	  nodeValue "String"
	  nullDocType "DocumentType"
	  docElem "Element"
	  rootNS "String"
	  rootName "String"
	|
	nullDocType := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docElem := doc  documentElement.
	rootName := docElem  tagName.
	rootNS := docElem  namespaceURI.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	newDoc := domImpl createDocumentNS: rootNS qualifiedName: rootName doctype: nullDocType.
	newText := newDoc  createTextNode:'new Document.adoptNode test for a TEXT_NODE'.
	adoptedText := doc  adoptNode: newText.
	"if"
	( adoptedText notNil )  ifTrue: [
			].

!

test_documentadoptnode32
	"
	Invoke the adoptNode method on another document using a new CDataSection node created in this
	Document as the source.  Verify if the node has been adopted correctly by checking the nodeValue 
	of the adopted node.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-adoptNode
	"
	|
	  doc "Document"
	  docAdopter "Document"
	  newCDATA "Node"
	  adoptedCDATA "Node"
	  nodeValue "String"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docAdopter :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	newCDATA := doc  createCDATASection:'Document.adoptNode test for a CDATASECTION_NODE'.
	adoptedCDATA := docAdopter  adoptNode: newCDATA.
	"if"
	( adoptedCDATA notNil )  ifTrue: [
			].

!

test_documentadoptnode33
	"
	Invoke the adoptNode method on this document using a new CDataSection node created in a new
	Document as the source.  Verify if the node has been adopted correctly by checking the nodeValue 
	of the adopted node.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-adoptNode
	"
	|
	  doc "Document"
	  domImpl "DOMImplementation"
	  newDoc "Document"
	  newCDATA "Node"
	  adoptedCDATA "Node"
	  nodeValue "String"
	  nullDocType "DocumentType"
	  docElem "Element"
	  rootNS "String"
	  rootName "String"
	|
	nullDocType := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docElem := doc  documentElement.
	rootNS := docElem  namespaceURI.
	rootName := docElem  tagName.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	newDoc := domImpl createDocumentNS: rootNS qualifiedName: rootName doctype: nullDocType.
	newCDATA := newDoc  createCDATASection:'Document.adoptNode test for a CDATASECTION_NODE'.
	adoptedCDATA := doc  adoptNode: newCDATA.
	"if"
	( adoptedCDATA notNil )  ifTrue: [
			].

!

test_documentadoptnode34
	"
	Invoke the adoptNode method on a new document using a new Comment node created in it
	as the source.  Verify if the node has been adopted correctly by checking the nodeValue 
	of the adopted node.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-adoptNode
	"
	|
	  doc "Document"
	  domImpl "DOMImplementation"
	  newDoc "Document"
	  newComment "Node"
	  adoptedComment "Node"
	  nodeValue "String"
	  nullDocType "DocumentType"
	  docElem "Element"
	  rootNS "String"
	  rootName "String"
	|
	nullDocType := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docElem := doc  documentElement.
	rootNS := docElem  namespaceURI.
	rootName := docElem  tagName.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	newDoc := domImpl createDocumentNS: rootNS qualifiedName: rootName doctype: nullDocType.
	newComment := newDoc  createComment:'Document.adoptNode test for a COMMENT_NODE'.
	adoptedComment := newDoc  adoptNode: newComment.
	"if"
	( adoptedComment notNil )  ifTrue: [
			].

!

test_documentadoptnode35
	"
	Invoke the adoptNode method on this document using a new PI node created in a new doc
	as the source.  Verify if the node has been adopted correctly by checking the nodeValue 
	of the adopted node.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-adoptNode
	"
	|
	  doc "Document"
	  domImpl "DOMImplementation"
	  newDoc "Document"
	  newPI "ProcessingInstruction"
	  adoptedPI "ProcessingInstruction"
	  piTarget "String"
	  piData "String"
	  nullDocType "DocumentType"
	  docElem "Element"
	  rootNS "String"
	  rootName "String"
	|
	nullDocType := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docElem := doc  documentElement.
	rootNS := docElem  namespaceURI.
	rootName := docElem  tagName.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	newDoc := domImpl createDocumentNS: rootNS qualifiedName: rootName doctype: nullDocType.
	newPI := newDoc  createProcessingInstruction:'PITarget' data:'PIData'.
	adoptedPI := doc  adoptNode: newPI.
	"if"
	( adoptedPI notNil )  ifTrue: [
					].

!

test_documentadoptnode36
	"
	Invoke the adoptNode method on this document using a new PI node created in a new doc
	as the source.  Verify if the node has been adopted correctly by checking the nodeValue 
	of the adopted node.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-adoptNode
	"
	|
	  doc "Document"
	  domImpl "DOMImplementation"
	  newDoc "Document"
	  newPI1 "ProcessingInstruction"
	  newPI2 "ProcessingInstruction"
	  adoptedPI1 "ProcessingInstruction"
	  adoptedPI2 "ProcessingInstruction"
	  piTarget "String"
	  piData "String"
	  nullDocType "DocumentType"
	  docElem "Element"
	  rootNS "String"
	  rootName "String"
	|
	nullDocType := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docElem := doc  documentElement.
	rootNS := docElem  namespaceURI.
	rootName := docElem  tagName.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	newDoc := domImpl createDocumentNS: rootNS qualifiedName: rootName doctype: nullDocType.
	newPI1 := newDoc  createProcessingInstruction:'PITarget' data:'PIData'.
	newPI2 := doc  createProcessingInstruction:'PITarget' data:'PIData'.
	adoptedPI1 := newDoc  adoptNode: newPI1.
	"if"
	( adoptedPI1 notNil )  ifTrue: [
			self assert:false description:'Method "notNull" is not supported yet'.
	piTarget := adoptedPI1  target.
	piData := adoptedPI1  data.
	self assert: ( piTarget = 'PITarget' ).
	self assert: ( piData = 'PIData' ).
	piTarget := adoptedPI2  target.
	piData := adoptedPI2  data.
	self assert: ( piTarget = 'PITarget' ).
	self assert: ( piData = 'PIData' ).
	].

!

test_documentgetdoctype01
	"
	Retreive the doctype node, create a new Doctype node, call replaceChild and try replacing the
	docType node with a new docType node.  Check if the docType node was correctly replaced with
	the new one.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-B63ED1A31
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-785887307
	"
	|
	  doc "Document"
	  docType "DocumentType"
	  newDocType "DocumentType"
	  replacedDocType "DocumentType"
	  domImpl "DOMImplementation"
	  newSysID "String"
	  nullPubID "String"
	  nullSysID "String"
	  replaced "Node"
	  rootName "String"
	|
	nullPubID := nil.
	nullSysID := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docType := doc  doctype.
	rootName := docType  name.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	newDocType := domImpl  createDocumentType:rootName publicId:nullPubID systemId:nullSysID.
	"try"
	[
	doc  replaceChild:docType with: newDocType.
	] on: DOMException do: [:ex|	].
	"end of try"
	replacedDocType := doc  doctype.
	newSysID := replacedDocType  systemId.
	self assert: newSysID isNil.

!

test_documentgetdocumenturi01
	"
	Retreive the documentURI of this document, and verify if it is not null.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-documentURI
	"
	|
	  doc "Document"
	  docURI "String"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docURI := doc  documentURI.
	self assert: docURI notNil.

!

test_documentgetdocumenturi02
	"
	Create a new Document, retreive its documentURI, and verify if it is null.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-documentURI
	"
	|
	  doc "Document"
	  newDoc "Document"
	  docURI "String"
	  domImpl "DOMImplementation"
	  nullDocType "DocumentType"
	  docElem "Element"
	  rootNS "String"
	  rootName "String"
	|
	nullDocType := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docElem := doc  documentElement.
	rootNS := docElem  namespaceURI.
	rootName := docElem  tagName.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	newDoc := domImpl createDocumentNS: rootNS qualifiedName: rootName doctype: nullDocType.
	docURI := newDoc  documentURI.
	self assert: docURI isNil.

!

test_documentgetdocumenturi03
	"
	Import the documentElement node of this document into a new document.  Since this node is
	now owned by the importing document, its documentURI attribute value should be null

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-documentURI
	"
	|
	  doc "Document"
	  newDoc "Document"
	  importedOwner "Document"
	  docElem "Element"
	  docElemImported "Node"
	  docURI "String"
	  domImpl "DOMImplementation"
	  nullDocType "DocumentType"
	  rootNS "String"
	  rootName "String"
	|
	nullDocType := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	docElem := doc  documentElement.
	rootNS := docElem  namespaceURI.
	rootName := docElem  tagName.
	newDoc := domImpl createDocumentNS: rootNS qualifiedName: rootName doctype: nullDocType.
	docElemImported := newDoc  importNode:docElem deep:false.
	importedOwner := docElemImported  ownerDocument.
	docURI := importedOwner  documentURI.
	self assert: docURI isNil.

!

test_documentgetinputencoding01
	"
	Call the getInputEncoding method on a UTF-8 encoded document and check if the 
	value returned is UTF-8.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-inputEncoding
	"
	|
	  doc "Document"
	  encodingName "String"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	encodingName := doc  inputEncoding.
	self assert: ( encodingName asLowercase = 'UTF-8' asLowercase ).

!

test_documentgetinputencoding02
	"
	Call the getInputEncoding method on a new document and check if the value returned
	is null.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-inputEncoding
	"
	|
	  doc "Document"
	  newDoc "Document"
	  domImpl "DOMImplementation"
	  encodingName "String"
	  nullDocType "DocumentType"
	  docElem "Element"
	  rootNS "String"
	  rootName "String"
	|
	nullDocType := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	docElem := doc  documentElement.
	rootNS := docElem  namespaceURI.
	rootName := docElem  tagName.
	newDoc := domImpl createDocumentNS: rootNS qualifiedName: rootName doctype: nullDocType.
	encodingName := newDoc  inputEncoding.
	self assert: encodingName isNil.

!

test_documentgetinputencoding03
	"
	Call the getInputEncoding method on a on a UTF-16 (BE) encoded document and check if the value returned
	is UTF-16BE.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-inputEncoding
	"
	|
	  doc "Document"
	  encodingName "String"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo_utf16').
	encodingName := doc  inputEncoding.
	self assert: ( encodingName asLowercase = 'UTF-16BE' asLowercase ).

!

test_documentgetinputencoding04
	"
	Call the getInputEncoding method on a cloned UTF-8 encoded document 
	and check if the value returned is UTF-8 or null (implementation dependent).

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-inputEncoding
	"
	|
	  doc "Document"
	  cloned "Document"
	  encodingName "String"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo_utf8').
	cloned := doc  cloneNode:true.
	encodingName := cloned  inputEncoding.
	self assert: ( encodingName asLowercase = 'UTF-8' asLowercase ) or: [( encodingName isNil ) ].

!

test_documentgetstricterrorchecking01
	"
	Verify if the (default) value of the strictErrorChecking attribute of this document object is true.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-strictErrorChecking
	"
	|
	  doc "Document"
	  strictErrorCheckingValue "Boolean"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	strictErrorCheckingValue := doc strictErrorChecking.
	self assert: strictErrorCheckingValue.

!

test_documentgetstricterrorchecking02
	"
	Verify if the (default)value of the strictErrorChecking attribute of a new Document object is true.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-strictErrorChecking
	"
	|
	  doc "Document"
	  newDoc "Document"
	  domImpl "DOMImplementation"
	  strictErrorCheckingValue "Boolean"
	  nullDocType "DocumentType"
	  docElem "Element"
	  rootNS "String"
	  rootName "String"
	|
	nullDocType := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docElem := doc  documentElement.
	rootNS := docElem  namespaceURI.
	rootName := docElem  tagName.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	newDoc := domImpl createDocumentNS: rootNS qualifiedName: rootName doctype: nullDocType.
	strictErrorCheckingValue := newDoc strictErrorChecking.
	self assert: strictErrorCheckingValue.

!

test_documentgetxmlencoding01
	"
	Call the getXmlEncoding method on a UTF-8 encoded XML document in which the encoding pseudo 
	attribute in its XMLDecl is UTF-8 and check if the value returned is UTF-8.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-encoding
	"
	|
	  doc "Document"
	  encodingName "String"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo_utf8').
	encodingName := doc  xmlEncoding.
	self assert: ( encodingName = 'uTf-8' ).

!

test_documentgetxmlencoding02
	"
	Call the getXmlEncoding method on a new document and check if the value returned
	is null.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-encoding
	"
	|
	  doc "Document"
	  newDoc "Document"
	  domImpl "DOMImplementation"
	  encodingName "String"
	  nullDocType "DocumentType"
	  docElem "Element"
	  rootNS "String"
	  rootName "String"
	|
	nullDocType := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docElem := doc  documentElement.
	rootNS := docElem  namespaceURI.
	rootName := docElem  tagName.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	newDoc := domImpl createDocumentNS: rootNS qualifiedName: rootName doctype: nullDocType.
	encodingName := newDoc  xmlEncoding.
	self assert: encodingName isNil.

!

test_documentgetxmlencoding03
	"
	Call the getXmlEncoding method on a UTF-16 encoded document and check if the value returned
	is UTF-16.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-encoding
	"
	|
	  doc "Document"
	  encodingName "String"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo_utf16').
	encodingName := doc  xmlEncoding.
	self assert: ( encodingName = 'uTf-16' ).

!

test_documentgetxmlencoding04
	"
	Call the getXmlEncoding method on a UTF-8 encoded XML document that does not contain
	the encoding pseudo attribute in its XMLDecl and check if the value returend is null.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-encoding
	"
	|
	  doc "Document"
	  encodingName "String"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	encodingName := doc  xmlEncoding.
	self assert: encodingName isNil.

!

test_documentgetxmlencoding05
	"
	Call the getXmlEncoding method on a cloned UTF-8 encoded document 
	and check if the value returned is UTF-8 or null (implementation dependent).

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-encoding
	"
	|
	  doc "Document"
	  cloned "Document"
	  encodingName "String"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo_utf8').
	cloned := doc  cloneNode:true.
	encodingName := cloned  xmlEncoding.
	self assert: ( encodingName = 'uTf-8' ) or: [( encodingName isNil ) ].

!

test_documentgetxmlstandalone01
	"
	Retreive the xmlStandalone attribute of a document for which standalone was not specified, this 
	should return false since the default for standalone is no when external markup decls 
	are present.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-standalone
	"
	|
	  doc "Document"
	  standalone "Boolean"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	standalone := doc  xmlStandalone.
	self deny: standalone.

!

test_documentgetxmlstandalone02
	"
	The value of the standalone pesudo-attribute for a new Document should be false.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-standalone
	"
	|
	  doc "Document"
	  newDoc "Document"
	  domImpl "DOMImplementation"
	  standalone "Boolean"
	  nullDocType "DocumentType"
	  docElem "Element"
	  rootNS "String"
	  rootName "String"
	|
	nullDocType := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	docElem := doc  documentElement.
	rootNS := docElem  namespaceURI.
	rootName := docElem  tagName.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	newDoc := domImpl createDocumentNS: rootNS qualifiedName: rootName doctype: nullDocType.
	standalone := newDoc  xmlStandalone.
	self deny: standalone.

!

test_documentgetxmlstandalone03
	"
	The value of the standalone attribute for an XML document with the standalone= no 
	should be false.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-standalone
	"
	|
	  doc "Document"
	  standalone "Boolean"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo_standalone_no').
	standalone := doc  xmlStandalone.
	self deny: standalone.

!

test_documentgetxmlstandalone04
	"
	Retreive the documentURI of a document for which standalone was specified as  yes , this 
	should return true.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-standalone
	"
	|
	  doc "Document"
	  standalone "Boolean"
	|
	"implementationAttribute not supported: validating"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo_standalone_yes').
	standalone := doc  xmlStandalone.
	self assert: standalone.

!

test_documentgetxmlstandalone05
	"
	Cretae a new DocumentType node whose systemId is StaffNS.DTD.  Create a new Document 
	node.  Check if the value of the standalone attribute on the new Document is false.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-standalone
	"
	|
	  doc "Document"
	  newDoc "Document"
	  newDocType "DocumentType"
	  domImpl "DOMImplementation"
	  standalone "Boolean"
	  nullPubId "String"
	  docElem "Element"
	  rootNS "String"
	  rootName "String"
	  docType "DocumentType"
	  sysId "String"
	|
	nullPubId := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docElem := doc  documentElement.
	rootNS := docElem  namespaceURI.
	rootName := docElem  tagName.
	docType := doc  doctype.
	sysId := docType  systemId.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	newDocType := domImpl  createDocumentType:rootName publicId:nullPubId systemId:sysId.
	newDoc := domImpl createDocumentNS: rootNS qualifiedName: rootName doctype: newDocType.
	standalone := newDoc  xmlStandalone.
	self deny: standalone.

!

test_documentgetxmlversion01
	"
	Check if the value of the version attribute in the XML declaration of this document 
	obtained by parsing staffNS.xml is  1.0 .

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-version
	"
	|
	  doc "Document"
	  versionValue "String"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	self assert: ( versionValue = '1.0' ).

!

test_documentgetxmlversion02
	"
	Check if the value of the version attribute in the XML declaration of a new document 
	is  1.0 .

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-version
	"
	|
	  doc "Document"
	  newDoc "Document"
	  versionValue "String"
	  domImpl "DOMImplementation"
	  nullDocType "DocumentType"
	  docElem "Element"
	  rootNS "String"
	  rootName "String"
	|
	nullDocType := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	docElem := doc  documentElement.
	rootNS := docElem  namespaceURI.
	rootName := docElem  tagName.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	newDoc := domImpl createDocumentNS: rootNS qualifiedName: rootName doctype: nullDocType.
	self assert: ( versionValue asLowercase = '1.0' asLowercase ).

!

test_documentgetxmlversion03
	"
	Check if the value of the version attribute in a XML document without a XMLDecl is
	is  1.0 .	    

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-version
	"
	|
	  doc "Document"
	  versionValue "String"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	self assert: ( versionValue asLowercase = '1.0' asLowercase ).

!

test_documentnormalizedocument01
	"
	Invoke the normalizeDocument method on this document.  Retreive the documentElement node
	and check the nodeName of this node to make sure it has not changed.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-normalizeDocument
	"
	|
	  doc "Document"
	  docElem "Element"
	  docElemNodeName "String"
	  origDocElemNodeName "String"
	  domConfig "DOMConfiguration"
	  errorMonitor "DOMErrorMonitor"
	|
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docElem := doc  documentElement.
	origDocElemNodeName := docElem  nodeName.
	domConfig := doc domConfig.
	domConfig setParameter: 'error-handler' value: errorMonitor.
	doc  normalizeDocument.
	errorMonitor  assertLowerSeverityFor: self message:'normalizeError' severity: DOMErrorMonitor SEVERITY_ERROR.
	docElem := doc  documentElement.
	docElemNodeName := docElem  nodeName.
	self assert: ( docElemNodeName = origDocElemNodeName ).

!

test_documentnormalizedocument02
	"
Normalize a document with the 'cdata-sections' parameter set to false and
check if the CDATASection has been preserved.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-normalizeDocument
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-cdata-sections
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  elemName "Element"
	  cdata "CDATASection"
	  text "Text"
	  nodeName "String"
	  domConfig "DOMConfiguration"
	  errorMonitor "DOMErrorMonitor"
	|
	"implementationAttribute not supported: namespaceAware"
	"implementationAttribute not supported: coalescing"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'strong'.
	elemName := elemList  item:1.
	cdata := elemName  lastChild.
	nodeName := cdata  nodeName.
	self assert: ( nodeName = '#cdata-section' ).
	domConfig := doc domConfig.
	domConfig setParameter: 'cdata-sections' value: true.
	domConfig setParameter: 'error-handler' value: errorMonitor.
	doc  normalizeDocument.
	errorMonitor  assertLowerSeverityFor: self message:'normalizationError' severity: DOMErrorMonitor SEVERITY_ERROR.
	elemList := doc  getElementsByTagName: 'strong'.
	elemName := elemList  item:1.
	cdata := elemName  lastChild.
	nodeName := cdata  nodeName.
	self assert: ( nodeName = '#cdata-section' ).
	domConfig setParameter: 'cdata-sections' value: false.
	doc  normalizeDocument.
	errorMonitor  assertLowerSeverityFor: self message:'normalization2Error' severity: DOMErrorMonitor SEVERITY_ERROR.
	elemList := doc  getElementsByTagName: 'strong'.
	elemName := elemList  item:1.
	text := elemName  lastChild.
	nodeName := text  nodeName.
	self assert: ( nodeName = '#text' ).

!

test_documentnormalizedocument03
	"
Normalize a document with a created CDATA section with the 
'cdata-sections' parameter set to true then to false and check if
the CDATASection has been preserved and then coalesced.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-normalizeDocument
		Subject http://www.w3.org/Bugs/Public/show_bug.cgi?id=416
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-cdata-sections
	"
	|
	  doc "Document"
	  elem "Element"
	  newCdata "CDATASection"
	  cdata "CDATASection"
	  text "Node"
	  nodeName "String"
	  nodeValue "String"
	  appendedChild "Node"
	  domConfig "DOMConfiguration"
	  pList "NodeList"
	  errorMonitor "DOMErrorMonitor"
	|
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	pList := doc  getElementsByTagName: 'p'.
	elem := pList  item:0.
	newCdata := doc  createCDATASection:'CDATA'.
	appendedChild := elem  appendChild:newCdata.
	domConfig := doc domConfig.
	domConfig setParameter: 'cdata-sections' value: true.
	domConfig setParameter: 'error-handler' value: errorMonitor.
	doc  normalizeDocument.
	errorMonitor  assertLowerSeverityFor: self message:'normalizationError' severity: DOMErrorMonitor SEVERITY_ERROR.
	pList := doc  getElementsByTagName: 'p'.
	elem := pList  item:0.
	cdata := elem  lastChild.
	nodeName := cdata  nodeName.
	self assert: ( nodeName = '#cdata-section' ).
	domConfig setParameter: 'cdata-sections' value: false.
	doc  normalizeDocument.
	errorMonitor  assertLowerSeverityFor: self message:'normalization2Error' severity: DOMErrorMonitor SEVERITY_ERROR.
	pList := doc  getElementsByTagName: 'p'.
	elem := pList  item:0.
	text := elem  lastChild.
	nodeName := text  nodeName.
	self assert: ( nodeName = '#text' ).
	nodeValue := text  nodeValue.
	self assert: ( nodeValue = 'barCDATA' ).

!

test_documentnormalizedocument04
	"
	Append a Comment node and normalize with  comments  set to false.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-normalizeDocument
		Subject http://www.w3.org/Bugs/Public/show_bug.cgi?id=416
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-comments
	"
	|
	  doc "Document"
	  elem "Element"
	  newComment "Comment"
	  lastChild "Node"
	  text "Text"
	  nodeName "String"
	  appendedChild "Node"
	  domConfig "DOMConfiguration"
	  errorMonitor "DOMErrorMonitor"
	  pList "NodeList"
	|
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	pList := doc  getElementsByTagName: 'p'.
	elem := pList  item:0.
	newComment := doc  createComment:'COMMENT_NODE'.
	appendedChild := elem  appendChild:newComment.
	domConfig := doc domConfig.
	domConfig setParameter: 'comments' value: true.
	domConfig setParameter: 'error-handler' value: errorMonitor.
	doc  normalizeDocument.
	errorMonitor  assertLowerSeverityFor: self message:'normalizationError' severity: DOMErrorMonitor SEVERITY_ERROR.
	pList := doc  getElementsByTagName: 'p'.
	elem := pList  item:0.
	lastChild := elem  lastChild.
	nodeName := lastChild  nodeName.
	self assert: ( nodeName = '#comment' ).
	domConfig setParameter: 'comments' value: false.
	doc  normalizeDocument.
	errorMonitor  assertLowerSeverityFor: self message:'normalization2Error' severity: DOMErrorMonitor SEVERITY_ERROR.
	pList := doc  getElementsByTagName: 'p'.
	elem := pList  item:0.
	lastChild := elem  lastChild.
	nodeName := lastChild  nodeName.
	self assert: ( nodeName = '#text' ).

!

test_documentnormalizedocument05
	"
Add a L1 element to a L2 namespace aware document and perform namespace normalization.  Should result
in an error.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-normalizeDocument
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/namespaces-algorithms#normalizeDocumentAlgo
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-namespaces
	"
	|
	  doc "Document"
	  elem "Element"
	  domConfig "DOMConfiguration"
	  pList "NodeList"
	  newChild "Element"
	  retval "Element"
	  errorMonitor "DOMErrorMonitor"
	  errors "List"
	  error "DOMError"
	  errorCount "SmallInteger"
	  severity "SmallInteger"
	  problemNode "Node"
	  location "DOMLocator"
	  lineNumber "SmallInteger"
	  columnNumber "SmallInteger"
	  byteOffset "SmallInteger"
	  utf16Offset "SmallInteger"
	  uri "String"
	  type "String"
	  message "String"
	  relatedException "DOMObject"
	  relatedData "DOMObject"
	  length "SmallInteger"
	|
	"implementationAttribute not supported: namespaceAware"
	errorCount := 0.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	pList := doc  getElementsByTagName: 'p'.
	elem := pList  item:0.
	newChild := doc  createElement:'br'.
	retval := elem  appendChild:newChild.
	domConfig := doc domConfig.
	domConfig setParameter: 'namespaces' value: true.
	domConfig setParameter: 'error-handler' value: errorMonitor.
	doc  normalizeDocument.
	errors := errorMonitor  errors.
errors do: [:error|
	severity := error  severity.
	"if"
	( severity = 2 ) ifTrue: [
																	self assert:false description:'Method "greater" is not supported yet'.
					].
].
	self assert: ( errorCount = 1 ).

!

test_documentnormalizedocument06
	"
Add a CDATASection containing  ]]>  perform normalization with split-cdata-sections=true.  Should result
in an warning.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-normalizeDocument
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-split-cdata-sections
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ERROR-DOMError-severity
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ERROR-DOMError-message
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ERROR-DOMError-type
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ERROR-DOMError-relatedException
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ERROR-DOMError-relatedData
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ERROR-DOMError-location
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#DOMLocator-line-number
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#DOMLocator-column-number
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#DOMLocator-byteOffset
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#DOMLocator-utf16Offset
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#DOMLocator-node
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#DOMLocator-uri
		Subject http://www.w3.org/Bugs/Public/show_bug.cgi?id=542
	"
	|
	  doc "Document"
	  elem "Element"
	  domConfig "DOMConfiguration"
	  elemList "NodeList"
	  newChild "CDATASection"
	  oldChild "Node"
	  retval "Node"
	  errorMonitor "DOMErrorMonitor"
	  errors "List"
	  error "DOMError"
	  splittedCount "SmallInteger"
	  severity "SmallInteger"
	  problemNode "Node"
	  location "DOMLocator"
	  lineNumber "SmallInteger"
	  columnNumber "SmallInteger"
	  byteOffset "SmallInteger"
	  utf16Offset "SmallInteger"
	  uri "String"
	  type "String"
	  message "String"
	  relatedException "DOMObject"
	  relatedData "DOMObject"
	  length "SmallInteger"
	  nodeType "SmallInteger"
	  nodeValue "String"
	|
	"implementationAttribute not supported: namespaceAware"
	splittedCount := 0.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	elemList := doc  getElementsByTagName: 'p'.
	elem := elemList  item:0.
	newChild := doc  createCDATASection:'this is not ]]> good'.
	oldChild := elem  firstChild.
	elem  replaceChild:oldChild with: newChild.
	domConfig := doc domConfig.
	domConfig setParameter: 'split-cdata-sections' value: true.
	domConfig setParameter: 'error-handler' value: errorMonitor.
	doc  normalizeDocument.
	newChild := elem  firstChild.
	nodeValue := newChild  nodeValue.
	nodeType := newChild  nodeType.
	self deny: ( nodeType = 4 ) and: [false "no template for element contains" ].
	errors := errorMonitor  errors.
errors do: [:error|
	type := error  type.
	severity := error  severity.
	"if"
	( type = 'cdata-sections-splitted' ) ifTrue: [
							self assert:false description:'Method "greater" is not supported yet'.
											].
].
	self assert: ( splittedCount = 1 ).

!

test_documentnormalizedocument07
	"
Add a CDATASection containing  ]]>  and perform normalization with split-cdata-sections=false.  Should result
in an error.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-normalizeDocument
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-split-cdata-sections
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ERROR-DOMError-severity
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ERROR-DOMError-message
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ERROR-DOMError-type
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ERROR-DOMError-relatedException
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ERROR-DOMError-relatedData
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ERROR-DOMError-location
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#DOMLocator-line-number
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#DOMLocator-column-number
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#DOMLocator-byteOffset
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#DOMLocator-utf16Offset
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#DOMLocator-node
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#DOMLocator-uri
		Subject http://www.w3.org/Bugs/Public/show_bug.cgi?id=542
	"
	|
	  doc "Document"
	  elem "Element"
	  domConfig "DOMConfiguration"
	  elemList "NodeList"
	  newChild "CDATASection"
	  oldChild "Node"
	  retval "Node"
	  errorMonitor "DOMErrorMonitor"
	  errors "List"
	  error "DOMError"
	  errorCount "SmallInteger"
	  severity "SmallInteger"
	  problemNode "Node"
	  location "DOMLocator"
	  lineNumber "SmallInteger"
	  columnNumber "SmallInteger"
	  byteOffset "SmallInteger"
	  utf16Offset "SmallInteger"
	  uri "String"
	  type "String"
	  message "String"
	  relatedException "DOMObject"
	  relatedData "DOMObject"
	  length "SmallInteger"
	|
	errorCount := 0.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	elemList := doc  getElementsByTagName: 'p'.
	elem := elemList  item:0.
	oldChild := elem  firstChild.
	newChild := doc  createCDATASection:'this is not ]]> good'.
	elem  replaceChild:oldChild with: newChild.
	domConfig := doc domConfig.
	domConfig setParameter: 'split-cdata-sections' value: false.
	domConfig setParameter: 'error-handler' value: errorMonitor.
	doc  normalizeDocument.
	errors := errorMonitor  errors.
errors do: [:error|
	severity := error  severity.
	"if"
	( severity = 2 ) ifTrue: [
												self assert:false description:'Method "greater" is not supported yet'.
					].
].
	self assert: ( errorCount = 1 ).

!

test_documentnormalizedocument08
	"
Add two CDATASections containing  ]]>  perform normalization with split-cdata-sections=true.
Should result in two warnings and at least 4 nodes.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-normalizeDocument
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-split-cdata-sections
	"
	|
	  doc "Document"
	  elem "Element"
	  domConfig "DOMConfiguration"
	  elemList "NodeList"
	  newChild "CDATASection"
	  oldChild "Node"
	  retval "Node"
	  errorMonitor "DOMErrorMonitor"
	  errors "List"
	  error "DOMError"
	  length "SmallInteger"
	  childNodes "NodeList"
	  type "String"
	  splittedCount "SmallInteger"
	  severity "SmallInteger"
	|
	"implementationAttribute not supported: namespaceAware"
	splittedCount := 0.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	elemList := doc  getElementsByTagName: 'p'.
	elem := elemList  item:0.
	newChild := doc  createCDATASection:'this is not ]]> good'.
	oldChild := elem  firstChild.
	elem  replaceChild:oldChild with: newChild.
	newChild := doc  createCDATASection:'this is not ]]> good'.
	retval := elem  appendChild:newChild.
	domConfig := doc domConfig.
	domConfig setParameter: 'split-cdata-sections' value: true.
	domConfig setParameter: 'error-handler' value: errorMonitor.
	doc  normalizeDocument.
	errors := errorMonitor  errors.
errors do: [:error|
	type := error  type.
	severity := error  severity.
	"if"
	( type = 'cdata-sections-splitted' ) ifTrue: [
		].
].
	self assert: ( splittedCount = 2 ).
	elemList := doc  getElementsByTagName: 'p'.
	elem := elemList  item:0.
	childNodes := elem  childNodes.
	length := childNodes  length.
	self assert: ( length > 3 ).

!

test_documentnormalizedocument09
	"
	The normalizeDocument method method acts as if the document was going through a save 
	and load cycle, putting the document in a  normal  form. 

	Set the validate-if-schema feature to true.  Invoke the normalizeDocument method on this 
	document.  Retreive the documentElement node and check the nodeName of this node 
	to make sure it has not changed.  Now set validate to false and verify the same. 
	Register an error handler on this Document and in each case make sure that it does
	not get called.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-normalizeDocument
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-validate-if-schema
	"
	|
	  doc "Document"
	  docElem "Element"
	  docElemNodeName "String"
	  canSet "Boolean"
	  errorHandler "DOMErrorHandler"
	  errHandler "DOMErrorHandler"
	  domConfig "DOMConfiguration"
	|
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	domConfig := doc domConfig.
	domConfig setParameter: 'error-handler' value: errHandler.
	canSet := domConfig canSetParameter: 'validate-if-schema' value: true.
	"if"
	(canSet) ifTrue: [
						].
	domConfig setParameter: 'validate-if-schema' value: false.
	doc  normalizeDocument.
	docElem := doc  documentElement.
	docElemNodeName := docElem  nodeName.
	self assert: ( docElemNodeName = 'html' ).

!

test_documentnormalizedocument10
	"
	The normalizeDocument method method acts as if the document was going through a save 
	and load cycle, putting the document in a  normal  form. 

	Create an Element and a text node and verify the nodeValue of this text node and append these to
	this Document.  If supported, invoke the setParameter method on this domconfiguration object to set the 
	 element-content-whitespace   feature to false.  Invoke the normalizeDocument method and verify if 
	the text node has been discarded.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-normalizeDocument
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-element-content-whitespace
	"
	|
	  doc "Document"
	  elem "Element"
	  newText "Text"
	  text "Text"
	  nodeValue "String"
	  canSet "Boolean"
	  appendedChild "Node"
	  domConfig "DOMConfiguration"
	|
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elem := doc  createElement:'newElem'.
	newText := doc  createTextNode:'Text          Node'.
	appendedChild := elem  appendChild:newText.
	appendedChild := doc  appendChild:elem.
	text := elem  firstChild.
	nodeValue := text  nodeValue.
	self assert: ( nodeValue = 'Text          Node' ).
	domConfig := doc domConfig.
	canSet := domConfig canSetParameter: 'element-content-whitespace' value: true.
	self assert: canSet.
	domConfig setParameter: 'element-content-whitespace' value: true.
	doc  normalizeDocument.
	text := elem  firstChild.
	nodeValue := text  nodeValue.
	self assert: ( nodeValue = 'Text          Node' ).
	canSet := domConfig canSetParameter: 'element-content-whitespace' value: false.
	"if"
	(canSet) ifTrue: [
						].

!

test_documentnormalizedocument11
	"
	The normalizeDocument method method acts as if the document was going through a save 
	and load cycle, putting the document in a  normal  form. 
	The feature namespace-declarations when set to false, discards all namespace declaration attributes,
        although namespace prefixes are still retained.
	
	Set the normalization feature  namespace-declarations  to false, invoke normalizeDocument and verify 
        the nodeName of element acquired by tagname.  

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-normalizeDocument
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-namespace-declarations
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  elemName "Element"
	  nodeName "String"
	  canSet "Boolean"
	  domConfig "DOMConfiguration"
	|
	"implementationAttribute not supported: namespaceAware"
	^self. "ignoringElementContentWhitespace supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	domConfig := doc domConfig.
	domConfig setParameter: 'namespace-declarations' value: true.
	doc  normalizeDocument.
	elemList := doc  getElementsByTagName: 'acronym' ns: '*'.
	elemName := elemList  item:1.
	self assert: elemName notNil.
	canSet := domConfig canSetParameter: 'namespace-declarations' value: false.
	"if"
	(canSet) ifTrue: [
							].

!

test_documentnormalizedocument12
	"
	The normalizeDocument method method acts as if the document was going through a save 
	and load cycle, putting the document in a  normal  form. 

	Set the validate feature to true.  Invoke the normalizeDocument method on this 
	document.  Retreive the documentElement node and check the nodeName of this node 
	to make sure it has not changed.  Now set validate to false and verify the same. 
	Register an error handler on this Document and in each case make sure that it does
	not get called.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-normalizeDocument
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-validate
	"
	|
	  doc "Document"
	  docElem "Element"
	  docElemNodeName "String"
	  canSet "Boolean"
	  domConfig "DOMConfiguration"
	  errorHandler "DOMErrorHandler"
	  errHandler "DOMErrorHandler"
	|
	^self. "Validation not supported"
	^self. "Schema validation not supported"
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	domConfig := doc domConfig.
	domConfig setParameter: 'error-handler' value: errHandler.
	canSet := domConfig canSetParameter: 'validate' value: true.
	"if"
	(canSet) ifTrue: [
						].
	domConfig setParameter: 'validate' value: false.
	doc  normalizeDocument.
	docElem := doc  documentElement.
	docElemNodeName := docElem  nodeName.
	self assert: ( docElemNodeName = 'html' ).

!

test_documentnormalizedocument13
	"
Add a L1 attribute to a L2 namespace aware document and perform namespace normalization.  Should result
in an error.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-normalizeDocument
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/namespaces-algorithms#normalizeDocumentAlgo
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-namespaces
	"
	|
	  doc "Document"
	  elem "Element"
	  domConfig "DOMConfiguration"
	  pList "NodeList"
	  newAttr "Attr"
	  retval "Element"
	  errorMonitor "DOMErrorMonitor"
	  errors "List"
	  error "DOMError"
	  errorCount "SmallInteger"
	  severity "SmallInteger"
	  problemNode "Node"
	  location "DOMLocator"
	  lineNumber "SmallInteger"
	  columnNumber "SmallInteger"
	  byteOffset "SmallInteger"
	  utf16Offset "SmallInteger"
	  uri "String"
	  type "String"
	  message "String"
	  relatedException "DOMObject"
	  relatedData "DOMObject"
	  length "SmallInteger"
	|
	"implementationAttribute not supported: namespaceAware"
	errorCount := 0.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	pList := doc  getElementsByTagName: 'p'.
	elem := pList  item:0.
	elem  setAttribute:'title' value:'DOM L1 Attribute'.
	newAttr := elem  getAttributeNode:'title'.
	domConfig := doc domConfig.
	domConfig setParameter: 'namespaces' value: true.
	domConfig setParameter: 'error-handler' value: errorMonitor.
	doc  normalizeDocument.
	errors := errorMonitor  errors.
errors do: [:error|
	severity := error  severity.
	"if"
	( severity = 2 ) ifTrue: [
																	self assert:false description:'Method "greater" is not supported yet'.
					].
].
	self assert: ( errorCount = 1 ).

!

test_documentrenamenode01
	"
	Invoke the renameNode method to rename the class attribute node of the 
	second element whose localName is acronym and namespaceURI http://www.nist.gov
	with the new namespaceURI as http://www.w3.org/DOM/Test and name as pre0fix:renamedNode. 
	Check if this attribute has been renamed successfully by verifying the
	nodeName, namespaceURI, nodeType attributes of the renamed node.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-renameNode
	"
	|
	  doc "Document"
	  element "Element"
	  attr "Attr"
	  childList "NodeList"
	  renamedclass "Node"
	  nodeName "String"
	  nodeType "SmallInteger"
	  namespaceURI "String"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	childList := doc  getElementsByTagName: 'acronym'.
	element := childList  item:1.
	attr := element  getAttributeNode:'class'.
	renamedclass := doc  renameNode:attr namespaceUri:'http://www.w3.org/DOM/Test' qualifiedName:'renamedNode'.
	nodeName := renamedclass  nodeName.
	namespaceURI := renamedclass  namespaceURI.
	nodeType := renamedclass  nodeType.
	self assert: ( nodeName = 'renamedNode' ).
	self assert: ( nodeType = 2 ).
	self assert: ( namespaceURI = 'http://www.w3.org/DOM/Test' ).

!

test_documentrenamenode02
	"
	Invoke the renameNode method to rename the class attribute node of the 
	second element whose localName is acronym and namespaceURI http://www.nist.gov
	with the new namespaceURI as http://www.w3.org/DOM/Test and name as prefi0x:renamedNode. 
	Check if this attribute has been renamed successfully by verifying the
	nodeName, namespaceURI, nodeType attributes of the renamed node.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-renameNode
	"
	|
	  doc "Document"
	  element "Element"
	  attr "Attr"
	  childList "NodeList"
	  renamedclass "Node"
	  nodeName "String"
	  nodeType "SmallInteger"
	  namespaceURI "String"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	childList := doc  getElementsByTagName: 'acronym'.
	element := childList  item:1.
	attr := element  getAttributeNode:'class'.
	renamedclass := doc  renameNode:attr namespaceUri:'http://www.w3.org/DOM/Test' qualifiedName:'prefi0x:renamedNode'.
	nodeName := renamedclass  nodeName.
	namespaceURI := renamedclass  namespaceURI.
	nodeType := renamedclass  nodeType.
	self assert: ( nodeName = 'prefi0x:renamedNode' ).
	self assert: ( namespaceURI = 'http://www.w3.org/DOM/Test' ).

!

test_documentrenamenode03
	"
	Invoke the renameNode method to rename a new attribute node to one whose
	namespaceURI is http://www.w3.org/DOM/Test and name is pre0:fix1. 
	Check if this attribute has been renamed successfully by verifying the
	nodeName, namespaceURI, nodeType attributes of the renamed node.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-renameNode
	"
	|
	  doc "Document"
	  attr "Attr"
	  renamedNode "Node"
	  nodeName "String"
	  namespaceURI "String"
	  nullNSURI "String"
	|
	nullNSURI := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	attr := doc  createAttribute:'test' ns:nullNSURI.
	renamedNode := doc  renameNode:attr namespaceUri:'http://www.w3.org/DOM/Test' qualifiedName:'pre0:fix1'.
	nodeName := renamedNode  nodeName.
	namespaceURI := renamedNode  namespaceURI.
	self assert: ( nodeName = 'pre0:fix1' ).
	self assert: ( namespaceURI = 'http://www.w3.org/DOM/Test' ).

!

test_documentrenamenode04
	"
	Invoke the renameNode method to rename a new attribute node to one whose
	namespaceURI is null and name is pf. 
	Check if this attribute has been renamed successfully by verifying the
	nodeName, namespaceURI, nodeType attributes of the renamed node.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-renameNode
	"
	|
	  doc "Document"
	  attr "Attr"
	  renamedNode "Node"
	  nodeName "String"
	  namespaceURI "String"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	attr := doc  createAttribute:'xml:lang' ns:'http://www.w3.org/XML/1998/namespace'.
	renamedNode := doc  renameNode:attr namespaceUri:'' qualifiedName:'title'.
	nodeName := renamedNode  nodeName.
	namespaceURI := renamedNode  namespaceURI.
	self assert: ( nodeName = 'title' ).
	self assert: namespaceURI isNil.

!

test_documentrenamenode05
	"
	Invoke the renameNode method to rename a new attribute node to one whose
	namespaceURI is null and name is rened. 
	Check if this attribute has been renamed successfully by verifying the
	nodeName, namespaceURI, nodeType attributes of the renamed node.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-renameNode
	"
	|
	  doc "Document"
	  attr "Attr"
	  renamedNode "Node"
	  nodeName "String"
	  namespaceURI "String"
	  nullNSURI "String"
	|
	nullNSURI := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	attr := doc  createAttribute:'xml:lang' ns:'http://www.w3.org/XML/1998/namespace'.
	renamedNode := doc  renameNode:attr namespaceUri:nullNSURI qualifiedName:'title'.
	nodeName := renamedNode  nodeName.
	namespaceURI := renamedNode  namespaceURI.
	self assert: namespaceURI isNil.
	self assert: ( nodeName = 'title' ).

!

test_documentrenamenode06
	"
	Invoke the renameNode method to rename the default attribute  dir  to xsi:schemaLocation. 
	Check if this attribute has been renamed successfully by verifying the
	nodeName, namespaceURI, nodeType attributes of the renamed node.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-renameNode
	"
	|
	  doc "Document"
	  element "Element"
	  attr "Attr"
	  childList "NodeList"
	  renamedclass "Node"
	  nodeName "String"
	  nodeType "SmallInteger"
	  namespaceURI "String"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	childList := doc  getElementsByTagName: 'p'.
	element := childList  item:3.
	attr := element  getAttributeNode:'dir'.
	renamedclass := doc  renameNode:attr namespaceUri:'http://www.w3.org/2001/XMLSchema-instance' qualifiedName:'xsi:schemaLocation'.
	nodeName := renamedclass  nodeName.
	namespaceURI := renamedclass  namespaceURI.
	nodeType := renamedclass  nodeType.
	self assert: ( nodeName = 'xsi:schemaLocation' ).
	self assert: ( nodeType = 2 ).
	self assert: ( namespaceURI = 'http://www.w3.org/2001/XMLSchema-instance' ).

!

test_documentrenamenode07
	"
	Invoke the renameNode method on a new document node to rename a new attribute node 
	to one whose namespaceURI is http://www.w3.org/XML/1998/namespace and name is xml:dom. 
	Check if this attribute has been renamed successfully by verifying the
	nodeName and namespaceURI attributes of the renamed node.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-renameNode
	"
	|
	  doc "Document"
	  newDoc "Document"
	  domImpl "DOMImplementation"
	  attr "Attr"
	  renamedNode "Node"
	  nodeName "String"
	  namespaceURI "String"
	  nullDocType "DocumentType"
	  docElem "Element"
	  rootNS "String"
	  rootName "String"
	|
	nullDocType := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docElem := doc  documentElement.
	rootNS := docElem  namespaceURI.
	rootName := docElem  tagName.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	newDoc := domImpl createDocumentNS: rootNS qualifiedName: rootName doctype: nullDocType.
	attr := newDoc  createAttribute:'xml:lang' ns:'http://www.w3.org/XML/1998/namespace'.
	renamedNode := newDoc  renameNode:attr namespaceUri:'http://www.w3.org/XML/1998/namespace' qualifiedName:'xml:dom'.
	nodeName := renamedNode  nodeName.
	namespaceURI := renamedNode  namespaceURI.
	self assert: ( nodeName = 'xml:dom' ).
	self assert: ( namespaceURI = 'http://www.w3.org/XML/1998/namespace' ).

!

test_documentrenamenode08
	"
	Invoke the renameNode method on a new document node and try to rename the default
	attribute  dir 
	Check if a WRONG_DOCUMENT_ERR gets thrown.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-renameNode
	"
	|
	  doc "Document"
	  newDoc "Document"
	  domImpl "DOMImplementation"
	  element "Element"
	  attr "Attr"
	  childList "NodeList"
	  renamedNode "Node"
	  nullDocType "DocumentType"
	  docElem "Element"
	  docElemNS "String"
	  docElemName "String"
	|
	nullDocType := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	childList := doc  getElementsByTagName: 'p'.
	element := childList  item:3.
	attr := element  getAttributeNode:'dir'.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	docElem := doc  documentElement.
	docElemNS := docElem  namespaceURI.
	docElemName := docElem  tagName.
	newDoc := domImpl createDocumentNS: docElemNS qualifiedName: docElemName doctype: nullDocType.
	"assertDOMException..."
	self should:[
	renamedNode := newDoc  renameNode:attr namespaceUri:'http://www.w3.org/XML/1998/namespace' qualifiedName:'xml:lang'.
	] raise: DOMException.
	self assert: (lastException code == DOMException WRONG_DOCUMENT_ERR).
	"end of assertDOMException..."

!

test_documentrenamenode09
	"
	The method renameNode renames an existing node. When the specified node was created 
	from a different document than this document, a WRONG_DOCUMENT_ERR exception is thrown.
 
	Invoke the renameNode method on a new Document node to rename a new attribute node
	created in the original Document, but later adopted by this new document node.  The 
	ownerDocument attribute of this attribute has now changed, such that the attribute node is considered to 
        be created from this new document node. Verify that no exception is thrown upon renaming and verify
        the new nodeName of this attribute node. 

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-renameNode
	"
	|
	  doc "Document"
	  newDoc "Document"
	  domImpl "DOMImplementation"
	  attr "Attr"
	  renamedNode "Node"
	  adopted "Node"
	  nullDocType "DocumentType"
	  attrNodeName "String"
	|
	"implementationAttribute not supported: namespaceAware"
	nullDocType := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	newDoc := domImpl createDocumentNS: 'http://www.w3.org/DOM/Test' qualifiedName: 'dom:newD' doctype: nullDocType.
	attr := doc  createAttribute:'test' ns:'http://www.w3.org/DOM/Test'.
	adopted := newDoc  adoptNode: attr.
	renamedNode := newDoc  renameNode:attr namespaceUri:'http://www.w3.org/2000/xmlns/' qualifiedName:'xmlns:xmlns'.
	attrNodeName := renamedNode  nodeName.
	self assert: ( attrNodeName = 'xmlns:xmlns' ).

!

test_documentrenamenode10
	"
	The method renameNode renames an existing node and raises a  NAMESPACE_ERR
	if the qualifiedName has a prefix and the namespaceURI is null but a 
	NOT_SUPPORTED_ERR should be raised since the the type of the specified node is 
	neither ELEMENT_NODE nor ATTRIBUTE_NODE.
 
	Invoke the renameNode method on a new document node to rename a node to nodes 
	with malformed qualifiedNames.
	Check if a NOT_SUPPORTED_ERR gets thrown instead of a NAMESPACE_ERR.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-renameNode
	"
	|
	  doc "Document"
	  textEntry "String"
	  textNode "Text"
	  renamedNode "Node"
	  qualifiedName "String"
	  nullDocType "DocumentType"
	  qualifiedNames "List"
	|
	"implementationAttribute not supported: namespaceAware"
	textEntry := 'hello'.
	nullDocType := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	textNode := doc  createTextNode:textEntry.
qualifiedNames do: [qualifiedName|
	"assertDOMException..."
	self should:[
	renamedNode := doc  renameNode:textNode namespaceUri:'http://www.w3.org/XML/1998/namespace' qualifiedName:qualifiedName.
	] raise: DOMException.
	self assert: (lastException code == DOMException NOT_SUPPORTED_ERR).
	"end of assertDOMException..."
].

!

test_documentrenamenode11
	"
	The method renameNode renames an existing node and raises a  NAMESPACE_ERR
	if the qualifiedName has a prefix and the namespaceURI is null but a 
	NOT_SUPPORTED_ERR should be raised since the the type of the specified node is 
	neither ELEMENT_NODE nor ATTRIBUTE_NODE.
 
	Invoke the renameNode method on this document node to rename a text node such that its
	qualifiedName has a prefix and namespaceURI is null.
	Check if a NOT_SUPPORTED_ERR gets thrown instead of a NAMESPACE_ERR.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-renameNode
	"
	|
	  doc "Document"
	  textEntry "String"
	  textNode "Text"
	  renamedNode "Node"
	  nullDocType "DocumentType"
	  nullNSURI "String"
	|
	"implementationAttribute not supported: namespaceAware"
	textEntry := 'hello'.
	nullDocType := nil.
	nullNSURI := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	textNode := doc  createTextNode:textEntry.
	"assertDOMException..."
	self should:[
	renamedNode := doc  renameNode:textNode namespaceUri:nullNSURI qualifiedName:'pre:fix'.
	] raise: DOMException.
	self assert: (lastException code == DOMException NOT_SUPPORTED_ERR).
	"end of assertDOMException..."

!

test_documentrenamenode12
	"
	The method renameNode renames an existing node and raises a  NAMESPACE_ERR
	if the qualifiedName has a prefix and the namespaceURI is null but a 
	NOT_SUPPORTED_ERR should be raised since the the type of the specified node is 
	neither ELEMENT_NODE nor ATTRIBUTE_NODE.
 
	Invoke the renameNode method on this document node to rename a text node such that its
	qualifiedName has a prefix that is  xml  and namespaceURI is  http://www.w3.org/XML/1999/namespace .
	Check if a NOT_SUPPORTED_ERR gets thrown instead of a NAMESPACE_ERR since the type of node is not valid
        for this method.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-renameNode
	"
	|
	  doc "Document"
	  renamedNode "Node"
	  textEntry "String"
	  textNode "Text"
	|
	"implementationAttribute not supported: namespaceAware"
	textEntry := 'hello'.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	textNode := doc  createTextNode:textEntry.
	"assertDOMException..."
	self should:[
	renamedNode := doc  renameNode:textNode namespaceUri:'http://www.w3.org/XML/1999/namespace' qualifiedName:'xml:prefix'.
	] raise: DOMException.
	self assert: (lastException code == DOMException NOT_SUPPORTED_ERR).
	"end of assertDOMException..."

!

test_documentrenamenode13
	"
	The method renameNode renames an existing node and raises a NAMESPACE_ERR
	if the qualifiedName has a prefix and the namespaceURI is null but a 
	NOT_SUPPORTED_ERR should be raised since the the type of the specified node is 
	neither ELEMENT_NODE nor ATTRIBUTE_NODE.
 
	Invoke the renameNode method on this document node to rename a text node such that its
	qualifiedName has a prefix that is  xmlns and namespaceURI is  http://www.w3.org/XML/1998/namespace .
	Check if a NOT_SUPPORTED_ERR gets thrown instead of a NAMESPACE_ERR since the type of node is not valid
        for this method.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-renameNode
	"
	|
	  doc "Document"
	  textEntry "String"
	  textNode "Text"
	  renamedNode "Node"
	|
	"implementationAttribute not supported: namespaceAware"
	textEntry := 'hello'.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	textNode := doc  createTextNode:textEntry.
	"assertDOMException..."
	self should:[
	renamedNode := doc  renameNode:textNode namespaceUri:'http://www.w3.org/XML/1998/namespace' qualifiedName:'xmlns:prefix'.
	] raise: DOMException.
	self assert: (lastException code == DOMException NOT_SUPPORTED_ERR).
	"end of assertDOMException..."

!

test_documentrenamenode14
	"
	The method renameNode renames an existing node and raises a NAMESPACE_ERR
	if the qualifiedName has a prefix and the namespaceURI is null but a 
	NOT_SUPPORTED_ERR should be raised since the the type of the specified node is 
	neither ELEMENT_NODE nor ATTRIBUTE_NODE.
 
	Invoke the renameNode method on this document node to rename a text node such that its
	qualifiedName is  xmlns and namespaceURI is  http://www.w3.org/2000/xmlns .
	Check if a NOT_SUPPORTED_ERR gets thrown instead of a NAMESPACE_ERR since the type of node is
        not valid for this method.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-renameNode
	"
	|
	  doc "Document"
	  renamedNode "Node"
	  nullDocType "DocumentType"
	  textEntry "String"
	  textNode "Text"
	|
	"implementationAttribute not supported: namespaceAware"
	nullDocType := nil.
	textEntry := 'hello'.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	textNode := doc  createTextNode:textEntry.
	"assertDOMException..."
	self should:[
	renamedNode := doc  renameNode:textNode namespaceUri:'http://www.w3.org/2000/xmlns' qualifiedName:'xmlns'.
	] raise: DOMException.
	self assert: (lastException code == DOMException NOT_SUPPORTED_ERR).
	"end of assertDOMException..."

!

test_documentrenamenode15
	"
	Rename the fourth acronym element to svg:rect and verify the
	nodeName, namespaceURI, nodeType attributes of the renamed node.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-renameNode
	"
	|
	  doc "Document"
	  element "Element"
	  childList "NodeList"
	  renamedclass "Node"
	  nodeName "String"
	  nodeType "SmallInteger"
	  namespaceURI "String"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	childList := doc  getElementsByTagName: 'acronym'.
	element := childList  item:3.
	renamedclass := doc  renameNode:element namespaceUri:'http://www.w3.org/DOM/Test' qualifiedName:'qnam:renamedNode'.
	nodeName := renamedclass  nodeName.
	namespaceURI := renamedclass  namespaceURI.
	nodeType := renamedclass  nodeType.
	self assert: ( nodeName = 'qnam:renamedNode' ).
	self assert: ( nodeType = 1 ).
	self assert: ( namespaceURI = 'http://www.w3.org/DOM/Test' ).

!

test_documentrenamenode16
	"
	Invoke the renameNode method to rename the fourth 
	acronym element with a new namespaceURI that is 
	null and qualifiedName that is renamedNode. 
	Check if this element has been renamed successfully by verifying the
	nodeName, attributes of the renamed node.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-renameNode
	"
	|
	  doc "Document"
	  element "Element"
	  childList "NodeList"
	  renamedclass "Node"
	  nodeName "String"
	  nodeType "SmallInteger"
	  namespaceURI "String"
	  nullNSURI "String"
	|
	nullNSURI := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	childList := doc  getElementsByTagName: 'acronym'.
	element := childList  item:3.
	renamedclass := doc  renameNode:element namespaceUri:nullNSURI qualifiedName:'renamedNode'.
	nodeName := renamedclass  nodeName.
	namespaceURI := renamedclass  namespaceURI.
	nodeType := renamedclass  nodeType.
	self assert: ( nodeName = 'renamedNode' ).
	self assert: ( nodeType = 1 ).
	self assert: namespaceURI isNil.

!

test_documentrenamenode17
	"
	Invoke the renameNode method to rename a new element node of a new document so that 
	its namespaceURI is http://www.w3.org/2000/xmlns/ and qualifiedName is xmlns:xmlns.
	Check if this element has been renamed successfully by verifying the
	nodeName, attributes of the renamed node.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-renameNode
	"
	|
	  doc "Document"
	  newDoc "Document"
	  domImpl "DOMImplementation"
	  element "Element"
	  renamedNode "Node"
	  nodeName "String"
	  nodeType "SmallInteger"
	  namespaceURI "String"
	  docElem "Element"
	  rootNS "String"
	  rootTagname "String"
	  nullDocType "DocumentType"
	|
	nullDocType := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	docElem := doc  documentElement.
	rootNS := docElem  namespaceURI.
	rootTagname := docElem  tagName.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	newDoc := domImpl createDocumentNS: rootNS qualifiedName: rootTagname doctype: nullDocType.
	element := newDoc  createElement:'body' ns:'http://www.w3.org/1999/xhtml'.
	renamedNode := newDoc  renameNode:element namespaceUri:'http://www.w3.org/1999/xhtml' qualifiedName:'xhtml:head'.
	nodeName := renamedNode  nodeName.
	namespaceURI := renamedNode  namespaceURI.
	nodeType := renamedNode  nodeType.
	self assert: ( nodeName = 'xhtml:head' ).
	self assert: ( nodeType = 1 ).
	self assert: ( namespaceURI = 'http://www.w3.org/1999/xhtml' ).

!

test_documentrenamenode18
	"
	Invoke the renameNode method on this document and try to rename a new element 
	node of a new document.
	Check if a WRONG_DOCUMENT_ERR gets thrown.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-renameNode
	"
	|
	  doc "Document"
	  newDoc "Document"
	  domImpl "DOMImplementation"
	  element "Element"
	  renamedNode "Node"
	  docElem "Element"
	  rootNS "String"
	  rootTagname "String"
	  nullDocType "DocumentType"
	|
	nullDocType := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	docElem := doc  documentElement.
	rootNS := docElem  namespaceURI.
	rootTagname := docElem  tagName.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	newDoc := domImpl createDocumentNS: rootNS qualifiedName: rootTagname doctype: nullDocType.
	element := newDoc  createElement:'body' ns:'http://www.w3.org/1999/xhtml'.
	"assertDOMException..."
	self should:[
	renamedNode := doc  renameNode:element namespaceUri:'http://www.w3.org/1999/xhtml' qualifiedName:'head'.
	] raise: DOMException.
	self assert: (lastException code == DOMException WRONG_DOCUMENT_ERR).
	"end of assertDOMException..."

!

test_documentrenamenode19
	"
	The method renameNode renames an existing node and raises a NAMESPACE_ERR
	if the qualifiedName is malformed per the Namespaces in XML specification.
	
	Invoke the renameNode method on a new document node to rename a node to nodes 
	with malformed qualifiedNames.
	Check if a NAMESPACE_ERR gets thrown.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-renameNode
	"
	|
	  doc "Document"
	  newDoc "Document"
	  domImpl "DOMImplementation"
	  element "Element"
	  renamedNode "Node"
	  qualifiedName "String"
	  nullDocType "DocumentType"
	  qualifiedNames "List"
	|
	"implementationAttribute not supported: namespaceAware"
	nullDocType := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	newDoc := domImpl createDocumentNS: 'http://www.w3.org/DOM/Test' qualifiedName: 'newD' doctype: nullDocType.
	element := doc  createElement:'test' ns:'http://www.w3.org/DOM/Test'.
qualifiedNames do: [qualifiedName|
	"assertDOMException..."
	self should:[
	renamedNode := doc  renameNode:element namespaceUri:'http://www.w3.org/2000/XMLNS' qualifiedName:qualifiedName.
	] raise: DOMException.
	self assert: (lastException code == DOMException NAMESPACE_ERR).
	"end of assertDOMException..."
].

!

test_documentrenamenode20
	"
	Invoke the renameNode method on this document node to rename a node such that its
	qualifiedName has a prefix that is  xml:html  and namespaceURI is 
	 http://www.example.com/namespace .
	Check if a NAMESPACE_ERR gets thrown.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-renameNode
	"
	|
	  doc "Document"
	  element "Element"
	  renamedNode "Node"
	  docElem "Element"
	  rootNS "String"
	  rootTagname "String"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	docElem := doc  documentElement.
	rootNS := docElem  namespaceURI.
	rootTagname := docElem  tagName.
	docElem := doc  documentElement.
	rootNS := docElem  namespaceURI.
	rootTagname := docElem  tagName.
	element := doc  createElement:rootTagname ns:rootNS.
	"assertDOMException..."
	self should:[
	renamedNode := doc  renameNode:element namespaceUri:'http://www.example.com/xml' qualifiedName:'xml:html'.
	] raise: DOMException.
	self assert: (lastException code == DOMException NAMESPACE_ERR).
	"end of assertDOMException..."

!

test_documentrenamenode21
	"
	Invoke the renameNode method on this document node to rename a node such that its
	qualifiedName has a prefix that is  xmlns:xml and namespaceURI is  http://www.w3.org/2000/XMLNS/ .
	Check if a NAMESPACE_ERR gets thrown.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-renameNode
	"
	|
	  doc "Document"
	  newDoc "Document"
	  domImpl "DOMImplementation"
	  attr "Attr"
	  renamedNode "Node"
	  nullDocType "DocumentType"
	  docElem "Element"
	  rootNS "String"
	  rootName "String"
	|
	nullDocType := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docElem := doc  documentElement.
	rootNS := docElem  namespaceURI.
	rootName := docElem  tagName.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	newDoc := domImpl createDocumentNS: rootNS qualifiedName: rootName doctype: nullDocType.
	attr := newDoc  createAttribute:'xml:lang' ns:'http://www.w3.org/XML/1998/namespace'.
	"assertDOMException..."
	self should:[
	renamedNode := newDoc  renameNode:attr namespaceUri:'http://www.w3.org/2000/XMLNS/' qualifiedName:'xmlns:xml'.
	] raise: DOMException.
	self assert: (lastException code == DOMException NAMESPACE_ERR).
	"end of assertDOMException..."

!

test_documentrenamenode22
	"
	Invoke the renameNode method on this document node to rename a node such that its
	qualifiedName is  xmlns and namespaceURI is  http://www.w3.org/1999/xmlns/ .
	Check if a NAMESPACE_ERR gets thrown.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-renameNode
	"
	|
	  doc "Document"
	  attr "Attr"
	  renamedNode "Node"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	attr := doc  createAttribute:'xml:lang' ns:'http://www.w3.org/XML/1998/namespace'.
	"assertDOMException..."
	self should:[
	renamedNode := doc  renameNode:attr namespaceUri:'http://www.w3.org/1999/xmlns/' qualifiedName:'xmlns'.
	] raise: DOMException.
	self assert: (lastException code == DOMException NAMESPACE_ERR).
	"end of assertDOMException..."

!

test_documentrenamenode23
	"
	The method renameNode renames an existing node and raises a  NOT_SUPPORTED_ERR
	if the type of the specified node is neither ELEMENT_NODE nor ATTRIBUTE_NODE.
 
	Invoke the renameNode method on this document node to attempt to rename itself.
	Check if a NOT_SUPPORTED_ERR gets thrown.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-renameNode
	"
	|
	  doc "Document"
	  renamedNode "Node"
	  docowner "Document"
	|
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	"assertDOMException..."
	self should:[
	renamedNode := doc  renameNode:doc namespaceUri:'http://www.w3.org/DOM/Test' qualifiedName:'root'.
	] raise: DOMException.
	self assert: (lastException code == DOMException NOT_SUPPORTED_ERR).
	"end of assertDOMException..."

!

test_documentrenamenode24
	"
	The method renameNode renames an existing node and raises a  NOT_SUPPORTED_ERR
	if the type of the specified node is neither ELEMENT_NODE nor ATTRIBUTE_NODE.
 
	Invoke the renameNode method on this document node to attempt to rename itself.
	The namespaceURI specified here is null and the name has a prefix.
	Check if a NOT_SUPPORTED_ERR gets thrown.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-renameNode
	"
	|
	  doc "Document"
	  renamedNode "Node"
	  nullNSURI "String"
	  docowner "Document"
	|
	"implementationAttribute not supported: namespaceAware"
	nullNSURI := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	"assertDOMException..."
	self should:[
	renamedNode := doc  renameNode:doc namespaceUri:nullNSURI qualifiedName:'doc:root'.
	] raise: DOMException.
	self assert: (lastException code == DOMException NOT_SUPPORTED_ERR).
	"end of assertDOMException..."

!

test_documentrenamenode25
	"
	Invoke the renameNode method to attempt to rename a DOcumentType node of this Document.
	Check if a NOT_SUPPORTED_ERR gets thrown.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-renameNode
	"
	|
	  doc "Document"
	  docType "DocumentType"
	  renamedNode "Node"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docType := doc  doctype.
	"assertDOMException..."
	self should:[
	renamedNode := doc  renameNode:docType namespaceUri:'http://www.w3.org/DOM/Test' qualifiedName:'root'.
	] raise: DOMException.
	self assert: (lastException code == DOMException NOT_SUPPORTED_ERR).
	"end of assertDOMException..."

!

test_documentrenamenode26
	"
	Invoke the renameNode method oto attempt to rename a new DocumentFragment node 
	of this Document.
	Check if a NOT_SUPPORTED_ERR gets thrown.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-renameNode
	"
	|
	  doc "Document"
	  docFrag "DocumentFragment"
	  renamedNode "Node"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docFrag := doc  createDocumentFragment.
	"assertDOMException..."
	self should:[
	renamedNode := doc  renameNode:docFrag namespaceUri:'http://www.w3.org/DOM/Test' qualifiedName:'root'.
	] raise: DOMException.
	self assert: (lastException code == DOMException NOT_SUPPORTED_ERR).
	"end of assertDOMException..."

!

test_documentrenamenode27
	"
	Invoke the renameNode method to attempt to rename new Text, Comment, CDataSection,
	ProcessingInstruction and EntityReference nodes of a new Document.
	Check if a NOT_SUPPORTED_ERR is thrown.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-renameNode
	"
	|
	  doc "Document"
	  newDoc "Document"
	  domImpl "DOMImplementation"
	  text "Text"
	  comment "Comment"
	  cdata "CDATASection"
	  pi "ProcessingInstruction"
	  entref "EntityReference"
	  renamedTxt "Node"
	  renamedComment "Node"
	  renamedCdata "Node"
	  renamedPi "Node"
	  renamedEntRef "Node"
	  nullDocType "DocumentType"
	  docElem "Element"
	  rootNS "String"
	  rootName "String"
	|
	nullDocType := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docElem := doc  documentElement.
	rootNS := docElem  namespaceURI.
	rootName := docElem  tagName.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	newDoc := domImpl createDocumentNS: rootNS qualifiedName: rootName doctype: nullDocType.
	text := newDoc  createTextNode:'text'.
	comment := newDoc  createComment:'comment'.
	cdata := newDoc  createCDATASection:'cdata'.
	pi := newDoc  createProcessingInstruction:'pit' data:'pid'.
	entref := newDoc  createEntityReference:'alpha'.
	"assertDOMException..."
	self should:[
	renamedTxt := newDoc  renameNode:text namespaceUri:'http://www.w3.org/DOM/Test' qualifiedName:'text'.
	] raise: DOMException.
	self assert: (lastException code == DOMException NOT_SUPPORTED_ERR).
	"end of assertDOMException..."
	"assertDOMException..."
	self should:[
	renamedComment := newDoc  renameNode:comment namespaceUri:'http://www.w3.org/DOM/Test' qualifiedName:'comment'.
	] raise: DOMException.
	self assert: (lastException code == DOMException NOT_SUPPORTED_ERR).
	"end of assertDOMException..."
	"assertDOMException..."
	self should:[
	renamedCdata := newDoc  renameNode:cdata namespaceUri:'http://www.w3.org/DOM/Test' qualifiedName:'cdata'.
	] raise: DOMException.
	self assert: (lastException code == DOMException NOT_SUPPORTED_ERR).
	"end of assertDOMException..."
	"assertDOMException..."
	self should:[
	renamedPi := newDoc  renameNode:pi namespaceUri:'http://www.w3.org/DOM/Test' qualifiedName:'pi'.
	] raise: DOMException.
	self assert: (lastException code == DOMException NOT_SUPPORTED_ERR).
	"end of assertDOMException..."
	"assertDOMException..."
	self should:[
	renamedEntRef := newDoc  renameNode:entref namespaceUri:'http://www.w3.org/DOM/Test' qualifiedName:'entref'.
	] raise: DOMException.
	self assert: (lastException code == DOMException NOT_SUPPORTED_ERR).
	"end of assertDOMException..."

!

test_documentrenamenode28
	"
	Invoke the renameNode method to attempt to rename a Entity and Notation nodes of this Document.
	Check if a NOT_SUPPORTED_ERR gets thrown.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-renameNode
	"
	|
	  doc "Document"
	  docType "DocumentType"
	  entityNodeMap "NamedNodeMap"
	  notationNodeMap "NamedNodeMap"
	  entity "Entity"
	  notation "Notation"
	  renamedEntityNode "Node"
	  renamedNotationNode "Node"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docType := doc  doctype.
	entityNodeMap := docType  entities.
	notationNodeMap := docType  notations.
	entity := entityNodeMap  getNamedItem:'alpha'.
	notation := notationNodeMap  getNamedItem:'notation1'.
	"assertDOMException..."
	self should:[
	renamedEntityNode := doc  renameNode:entity namespaceUri:'http://www.w3.org/DOM/Test' qualifiedName:'beta'.
	] raise: DOMException.
	self assert: (lastException code == DOMException NOT_SUPPORTED_ERR).
	"end of assertDOMException..."
	"assertDOMException..."
	self should:[
	renamedNotationNode := doc  renameNode:notation namespaceUri:'http://www.w3.org/DOM/Test' qualifiedName:'notation2'.
	] raise: DOMException.
	self assert: (lastException code == DOMException NOT_SUPPORTED_ERR).
	"end of assertDOMException..."

!

test_documentrenamenode29
	"
	Invoke the renameNode method to attempt to rename an Element node of a XML1.0 document 
	with a name that contains an invalid XML 1.0 character and check if a INVALID_CHARACTER_ERR 
	gets thrown.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-renameNode
	"
	|
	  doc "Document"
	  docElem "Element"
	  renamed "Node"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docElem := doc  documentElement.
	"assertDOMException..."
	self should:[
	renamed := doc  renameNode:docElem namespaceUri:'http://www.w3.org/DOM/Test' qualifiedName:'@'.
	] raise: DOMException.
	self assert: (lastException code == DOMException INVALID_CHARACTER_ERR).
	"end of assertDOMException..."

!

test_documentsetdocumenturi01
	"
	The setDocmentURI method set the location of the document.
	    
	Set the documentURI to a valid string and retreive the documentURI of this 
	document and verify if it is was correctly set.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-documentURI
	"
	|
	  doc "Document"
	  docURI "String"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	doc documentURI:'file:///test'.
	docURI := doc  documentURI.
	self assert: ( docURI = 'file:///test' ).

!

test_documentsetdocumenturi02
	"
	The setDocmentURI method set the location of the document.
	    
	Set the documentURI to null and retreive the documentURI of this document and verify 
	if it is was set to null.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-documentURI
	"
	|
	  doc "Document"
	  docURI "String"
	  nullValue "String"
	|
	nullValue := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	doc documentURI:nullValue.
	docURI := doc  documentURI.
	self assert: docURI isNil.

!

test_documentsetdocumenturi03
	"
	The setDocmentURI method set the location of the document.
	    
	Create a new document and set its documentURI to a valid string.  Retreive the documentURI 
	and verify if it is was correctly set.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-documentURI
	"
	|
	  doc "Document"
	  newDoc "Document"
	  domImpl "DOMImplementation"
	  docURI "String"
	  nullDocType "DocumentType"
	  docElem "Element"
	  rootNS "String"
	  rootName "String"
	|
	nullDocType := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	docElem := doc  documentElement.
	rootNS := docElem  namespaceURI.
	rootName := docElem  tagName.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	newDoc := domImpl createDocumentNS: rootNS qualifiedName: rootName doctype: nullDocType.
	newDoc documentURI:'somestring'.
	docURI := newDoc  documentURI.
	self assert: ( docURI = 'somestring' ).

!

test_documentsetstricterrorchecking01
	"
	Set the strictErrorChecking attribute value on this documentNode to false and then to true.
	Call the createAttributeNS method on this document with an illegal character in the qualifiedName
	and check if the INVALID_CHARACTER_ERR is thrown.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-strictErrorChecking
	"
	|
	  doc "Document"
	  newAttr "Attr"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	doc strictErrorChecking:false.
	doc strictErrorChecking:true.
	"assertDOMException..."
	self should:[
	newAttr := doc  createAttribute:'@' ns:'http://www.w3.org/DOM/Test'.
	] raise: DOMException.
	self assert: (lastException code == DOMException INVALID_CHARACTER_ERR).
	"end of assertDOMException..."

!

test_documentsetstricterrorchecking02
	"
	Set the strictErrorChecking attribute value on a new Document to true.
	Call the createAttributeNS method on this document with a a null namespaceURI and a qualified name
	with a prefix and check if the NAMESPACE_ERR is thrown.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-strictErrorChecking
	"
	|
	  doc "Document"
	  newAttr "Attr"
	  nullValue "String"
	|
	nullValue := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	doc strictErrorChecking:true.
	"assertDOMException..."
	self should:[
	newAttr := doc  createAttribute:'dom:test' ns:nullValue.
	] raise: DOMException.
	self assert: (lastException code == DOMException NAMESPACE_ERR).
	"end of assertDOMException..."

!

test_documentsetstricterrorchecking03
	"
	Set the strictErrorChecking attribute value on a new Document to false and check if it was 
	correctly set using getStrictErrorChecking.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-strictErrorChecking
	"
	|
	  doc "Document"
	  strictErrorCheckingValue "Boolean"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	doc strictErrorChecking:false.
	strictErrorCheckingValue := doc strictErrorChecking.
	self deny: strictErrorCheckingValue.

!

test_documentsetxmlstandalone01
	"
	Set the standalone attribute of this document to true and verify if the attribute was correctly
	set.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-standalone
	"
	|
	  doc "Document"
	  standalone "Boolean"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	doc  xmlStandalone:true.
	standalone := doc  xmlStandalone.
	self assert: standalone.

!

test_documentsetxmlstandalone02
	"
	Create a new document object and set standalone to false and check if it was correctly set.
	Then repeat this by setting it to true.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-standalone
	"
	|
	  doc "Document"
	  newDoc "Document"
	  domImpl "DOMImplementation"
	  standalone "Boolean"
	  nullDocType "DocumentType"
	  docElem "Element"
	  rootNS "String"
	  rootName "String"
	|
	nullDocType := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	docElem := doc  documentElement.
	rootNS := docElem  namespaceURI.
	rootName := docElem  tagName.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	newDoc := domImpl createDocumentNS: rootNS qualifiedName: rootName doctype: nullDocType.
	newDoc  xmlStandalone:false.
	standalone := newDoc  xmlStandalone.
	self deny: standalone.
	newDoc  xmlStandalone:true.
	standalone := newDoc  xmlStandalone.
	self assert: standalone.

!

test_documentsetxmlversion01
	"
	Set the value of the version attribute of the XML declaration of this document to 
	various invalid characters and  verify if a NOT_SUPPORTED_ERR is thrown.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-version
	"
	|
	  doc "Document"
	  versionValue "String"
	  illegalVersion "List"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
illegalVersion do: [versionValue|
	"assertDOMException..."
	self should:[
	] raise: DOMException.
	self assert: (lastException code == DOMException NOT_SUPPORTED_ERR).
	"end of assertDOMException..."
].

!

test_documentsetxmlversion02
	"
	Set the value of the version attribute of the XML declaration of a new document to  1.0 
	and check if it was correctly set.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-version
	"
	|
	  doc "Document"
	  versionValue "String"
	  newDoc "Document"
	  domImpl "DOMImplementation"
	  nullDocType "DocumentType"
	  docElem "Element"
	  rootNS "String"
	  rootName "String"
	|
	nullDocType := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	docElem := doc  documentElement.
	rootNS := docElem  namespaceURI.
	rootName := docElem  tagName.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	newDoc := domImpl createDocumentNS: rootNS qualifiedName: rootName doctype: nullDocType.
	self assert: ( versionValue = '1.0' ).

!

test_documentsetxmlversion03
	"
	Set the value of the version attribute of the XML declaration of a new document to  1.0 
	and check if it was correctly set.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-version
	"
	|
	  doc "Document"
	  versionValue "String"
	  newDoc "Document"
	  domImpl "DOMImplementation"
	  nullDocType "DocumentType"
	  docElem "Element"
	  rootNS "String"
	  rootName "String"
	|
	nullDocType := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	docElem := doc  documentElement.
	rootNS := docElem  namespaceURI.
	rootName := docElem  tagName.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	newDoc := domImpl createDocumentNS: rootNS qualifiedName: rootName doctype: nullDocType.
	self assert: ( versionValue = '1.1' ).

!

test_documentsetxmlversion05
	"
	Set the value of the version attribute of the XML declaration of a new document to  - 
	and check if a NOT_SUPPORTED_ERR is thrown.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-version
	"
	|
	  doc "Document"
	  newDoc "Document"
	  domImpl "DOMImplementation"
	  nullDocType "DocumentType"
	  docElem "Element"
	  rootNS "String"
	  rootName "String"
	|
	nullDocType := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	docElem := doc  documentElement.
	rootNS := docElem  namespaceURI.
	rootName := docElem  tagName.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	newDoc := domImpl createDocumentNS: rootNS qualifiedName: rootName doctype: nullDocType.
	"assertDOMException..."
	self should:[
	] raise: DOMException.
	self assert: (lastException code == DOMException NOT_SUPPORTED_ERR).
	"end of assertDOMException..."

!

test_domconfigcanonicalform1
	"Checks behavior of  canonical-form  configuration parameter.
		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-canonical-form
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#DOMConfiguration-getParameter
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#DOMConfiguration-property
	"
	|
	  domImpl "DOMImplementation"
	  doc "Document"
	  domConfig "DOMConfiguration"
	  nullDocType "DocumentType"
	  canSet "Boolean"
	  state "Boolean"
	  parameter "String"
	|
	nullDocType := nil.
	parameter := 'cAnOnical-form'.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	doc := domImpl createDocumentNS: 'http://www.w3.org/1999/xhtml' qualifiedName: 'html' doctype: nullDocType.
	domConfig := doc domConfig.
	state := domConfig getParameter: parameter.
	self deny: state.
	canSet := domConfig canSetParameter: parameter value: false.
	self assert: canSet.
	canSet := domConfig canSetParameter: parameter value: true.
	"if"
	(canSet) ifTrue: [
				].
	domConfig setParameter: parameter value: false.

!

test_domconfigcdatasections1
	"Checks behavior of  cdata-sections  configuration parameter.
		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-cdata-sections
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#DOMConfiguration-getParameter
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#DOMConfiguration-setParameter
	"
	|
	  domImpl "DOMImplementation"
	  doc "Document"
	  domConfig "DOMConfiguration"
	  nullDocType "DocumentType"
	  canSet "Boolean"
	  state "Boolean"
	  parameter "String"
	|
	nullDocType := nil.
	parameter := 'cDaTa-sections'.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	doc := domImpl createDocumentNS: 'http://www.w3.org/1999/xhtml' qualifiedName: 'html' doctype: nullDocType.
	domConfig := doc domConfig.
	state := domConfig getParameter: parameter.
	self assert: state.
	canSet := domConfig canSetParameter: parameter value: false.
	self assert: canSet.
	canSet := domConfig canSetParameter: parameter value: true.
	self assert: canSet.
	domConfig setParameter: parameter value: false.
	state := domConfig getParameter: parameter.
	self deny: state.
	domConfig setParameter: parameter value: true.
	state := domConfig getParameter: parameter.
	self assert: state.

!

test_domconfigcheckcharacternormalization1
	"Checks behavior of  check-character-normalization  configuration parameter.
		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-check-character-normalization
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#DOMConfiguration-getParameter
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#DOMConfiguration-setParameter
	"
	|
	  domImpl "DOMImplementation"
	  doc "Document"
	  domConfig "DOMConfiguration"
	  nullDocType "DocumentType"
	  canSet "Boolean"
	  state "Boolean"
	  parameter "String"
	|
	nullDocType := nil.
	parameter := 'cHeCk-character-normalization'.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	doc := domImpl createDocumentNS: 'http://www.w3.org/1999/xhtml' qualifiedName: 'html' doctype: nullDocType.
	domConfig := doc domConfig.
	state := domConfig getParameter: parameter.
	self deny: state.
	canSet := domConfig canSetParameter: parameter value: false.
	self assert: canSet.
	canSet := domConfig canSetParameter: parameter value: true.
	"if"
	(canSet) ifTrue: [
				].
	domConfig setParameter: parameter value: false.

!

test_domconfigcomments1
	"Checks behavior of  comments  configuration parameter.
		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-comments
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#DOMConfiguration
	"
	|
	  domImpl "DOMImplementation"
	  doc "Document"
	  domConfig "DOMConfiguration"
	  nullDocType "DocumentType"
	  canSet "Boolean"
	  state "Boolean"
	  parameter "String"
	|
	nullDocType := nil.
	parameter := 'cOmments'.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	doc := domImpl createDocumentNS: 'http://www.w3.org/1999/xhtml' qualifiedName: 'html' doctype: nullDocType.
	domConfig := doc domConfig.
	state := domConfig getParameter: parameter.
	self assert: state.
	canSet := domConfig canSetParameter: parameter value: false.
	self assert: canSet.
	canSet := domConfig canSetParameter: parameter value: true.
	self assert: canSet.
	domConfig setParameter: parameter value: false.
	state := domConfig getParameter: parameter.
	self deny: state.
	domConfig setParameter: parameter value: true.
	state := domConfig getParameter: parameter.
	self assert: state.

!

test_domconfigdatatypenormalization1
	"Checks behavior of  datatype-normalization  configuration parameter.
		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-datatype-normalization
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#DOMConfiguration
	"
	|
	  domImpl "DOMImplementation"
	  doc "Document"
	  domConfig "DOMConfiguration"
	  nullDocType "DocumentType"
	  canSet "Boolean"
	  state "Boolean"
	  parameter "String"
	|
	nullDocType := nil.
	parameter := 'dAtAtype-normalization'.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	doc := domImpl createDocumentNS: 'http://www.w3.org/1999/xhtml' qualifiedName: 'html' doctype: nullDocType.
	domConfig := doc domConfig.
	state := domConfig getParameter: parameter.
	self deny: state.
	canSet := domConfig canSetParameter: parameter value: false.
	self assert: canSet.
	canSet := domConfig canSetParameter: parameter value: true.
	"if"
	(canSet) ifTrue: [
				].
	domConfig setParameter: parameter value: false.

!

test_domconfigdatatypenormalization2
	"Setting  datatype-normalization  to true also forces  validate  to true.
		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-datatype-normalization
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#DOMConfiguration
	"
	|
	  domImpl "DOMImplementation"
	  doc "Document"
	  domConfig "DOMConfiguration"
	  nullDocType "DocumentType"
	  canSet "Boolean"
	  state "Boolean"
	  parameter "String"
	|
	nullDocType := nil.
	parameter := 'datatype-normalization'.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	doc := domImpl createDocumentNS: 'http://www.w3.org/1999/xhtml' qualifiedName: 'html' doctype: nullDocType.
	domConfig := doc domConfig.
	domConfig setParameter: 'validate' value: false.
	canSet := domConfig canSetParameter: parameter value: true.
	"if"
	(canSet) ifTrue: [
				].

!

test_domconfigelementcontentwhitespace1
	"Checks behavior of  element-content-whitespace  configuration parameter.
		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-element-content-whitespace
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#DOMConfiguration-getParameter
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#DOMConfiguration-setParameter
	"
	|
	  domImpl "DOMImplementation"
	  doc "Document"
	  domConfig "DOMConfiguration"
	  nullDocType "DocumentType"
	  canSet "Boolean"
	  state "Boolean"
	  parameter "String"
	|
	nullDocType := nil.
	parameter := 'eLeMent-content-whitespace'.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	doc := domImpl createDocumentNS: 'http://www.w3.org/1999/xhtml' qualifiedName: 'html' doctype: nullDocType.
	domConfig := doc domConfig.
	state := domConfig getParameter: parameter.
	self assert: state.
	canSet := domConfig canSetParameter: parameter value: true.
	self assert: canSet.
	canSet := domConfig canSetParameter: parameter value: false.
	"if"
	(canSet) ifTrue: [
				].
	domConfig setParameter: parameter value: true.

!

test_domconfigentities1
	"Checks behavior of  entities  configuration parameter.
		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-entities
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#DOMConfiguration-getParameter
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#DOMConfiguration-setParameter
	"
	|
	  domImpl "DOMImplementation"
	  doc "Document"
	  domConfig "DOMConfiguration"
	  nullDocType "DocumentType"
	  canSet "Boolean"
	  state "Boolean"
	  parameter "String"
	|
	nullDocType := nil.
	parameter := 'eNtIties'.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	doc := domImpl createDocumentNS: 'http://www.w3.org/1999/xhtml' qualifiedName: 'html' doctype: nullDocType.
	domConfig := doc domConfig.
	state := domConfig getParameter: parameter.
	self assert: state.
	canSet := domConfig canSetParameter: parameter value: false.
	self assert: canSet.
	canSet := domConfig canSetParameter: parameter value: true.
	self assert: canSet.
	domConfig setParameter: parameter value: false.
	state := domConfig getParameter: parameter.
	self deny: state.
	domConfig setParameter: parameter value: true.
	state := domConfig getParameter: parameter.
	self assert: state.

!

test_domconfigerrorhandler1
	"Checks behavior of  error-handler  configuration parameter.
		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-error-handler
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#DOMConfiguration-getParameter
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#DOMConfiguration-setParameter
		Subject http://www.w3.org/Bugs/Public/show_bug.cgi?id=544
	"
	|
	  domImpl "DOMImplementation"
	  doc "Document"
	  domConfig "DOMConfiguration"
	  nullDocType "DocumentType"
	  canSet "Boolean"
	  origHandler "DOMErrorHandler"
	  state "DOMErrorHandler"
	  parameter "String"
	  errorHandler "DOMErrorHandler"
	|
	nullDocType := nil.
	parameter := 'eRrOr-handler'.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	doc := domImpl createDocumentNS: 'http://www.w3.org/1999/xhtml' qualifiedName: 'html' doctype: nullDocType.
	domConfig := doc domConfig.
	origHandler := domConfig getParameter: parameter.
	canSet := domConfig canSetParameter: parameter value: errorHandler.
	self assert: canSet.
	canSet := domConfig canSetParameter: parameter value: origHandler.
	self assert: canSet.
	domConfig setParameter: parameter value: errorHandler.
	state := domConfig getParameter: parameter.
	self assert: state == errorHandler.
	domConfig setParameter: parameter value: origHandler.
	state := domConfig getParameter: parameter.
	self assert: state == origHandler.
	canSet := domConfig canSetParameter: parameter value: true.
	"if"
	(canSet) ifTrue: [
		].

!

test_domconfigerrorhandler2
	"Calls DOMConfiguration.setParameter( error-handler , null).  Spec
    does not explicitly address the case.
		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-error-handler
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#DOMConfiguration-getParameter
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#DOMConfiguration-setParameter
	"
	|
	  domImpl "DOMImplementation"
	  doc "Document"
	  domConfig "DOMConfiguration"
	  nullDocType "DocumentType"
	  canSet "Boolean"
	  errorHandler "DOMErrorHandler"
	  parameter "String"
	  state "DOMErrorHandler"
	|
	nullDocType := nil.
	errorHandler := nil.
	parameter := 'error-handler'.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	doc := domImpl createDocumentNS: 'http://www.w3.org/1999/xhtml' qualifiedName: 'html' doctype: nullDocType.
	domConfig := doc domConfig.
	canSet := domConfig canSetParameter: parameter value: errorHandler.
	self assert: canSet.
	domConfig setParameter: parameter value: errorHandler.
	state := domConfig getParameter: parameter.
	self assert: state isNil.

!

test_domconfiginfoset1
	"Checks behavior of  infoset  configuration parameter.
		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-infoset
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#DOMConfiguration-getParameter
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#DOMConfiguration-setParameter
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-cdata-sections
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-entities
	"
	|
	  domImpl "DOMImplementation"
	  doc "Document"
	  domConfig "DOMConfiguration"
	  nullDocType "DocumentType"
	  canSet "Boolean"
	  state "Boolean"
	  parameter "String"
	|
	nullDocType := nil.
	parameter := 'iNfOset'.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	doc := domImpl createDocumentNS: 'http://www.w3.org/1999/xhtml' qualifiedName: 'html' doctype: nullDocType.
	domConfig := doc domConfig.
	state := domConfig getParameter: parameter.
	self deny: state.
	canSet := domConfig canSetParameter: parameter value: false.
	self assert: canSet.
	canSet := domConfig canSetParameter: parameter value: true.
	self assert: canSet.
	domConfig setParameter: parameter value: true.
	state := domConfig getParameter: parameter.
	self assert: state.
	state := domConfig getParameter: 'entities'.
	self deny: state.
	state := domConfig getParameter: 'cdata-sections'.
	self deny: state.
	domConfig setParameter: parameter value: false.
	state := domConfig getParameter: parameter.
	self assert: state.
	domConfig setParameter: 'entities' value: true.
	state := domConfig getParameter: parameter.
	self deny: state.

!

test_domconfignamespacedeclarations1
	"Checks behavior of  namespace-declarations  configuration parameter.
		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-namespace-declarations
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#DOMConfiguration-getParameter
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#DOMConfiguration-setParameter
	"
	|
	  domImpl "DOMImplementation"
	  doc "Document"
	  domConfig "DOMConfiguration"
	  nullDocType "DocumentType"
	  canSet "Boolean"
	  state "Boolean"
	  parameter "String"
	|
	nullDocType := nil.
	parameter := 'nAmEspace-declarations'.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	doc := domImpl createDocumentNS: 'http://www.w3.org/1999/xhtml' qualifiedName: 'html' doctype: nullDocType.
	domConfig := doc domConfig.
	state := domConfig getParameter: parameter.
	self assert: state.
	canSet := domConfig canSetParameter: parameter value: false.
	self assert: canSet.
	canSet := domConfig canSetParameter: parameter value: true.
	self assert: canSet.
	domConfig setParameter: parameter value: false.
	state := domConfig getParameter: parameter.
	self deny: state.
	domConfig setParameter: parameter value: true.
	state := domConfig getParameter: parameter.
	self assert: state.

!

test_domconfignamespaces1
	"Checks behavior of  namespaces  configuration parameter.
		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-namespaces
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#DOMConfiguration
	"
	|
	  domImpl "DOMImplementation"
	  doc "Document"
	  domConfig "DOMConfiguration"
	  nullDocType "DocumentType"
	  canSet "Boolean"
	  state "Boolean"
	  parameter "String"
	|
	nullDocType := nil.
	parameter := 'nAmEspaces'.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	doc := domImpl createDocumentNS: 'http://www.w3.org/1999/xhtml' qualifiedName: 'html' doctype: nullDocType.
	domConfig := doc domConfig.
	state := domConfig getParameter: parameter.
	self assert: state.
	canSet := domConfig canSetParameter: parameter value: true.
	self assert: canSet.
	canSet := domConfig canSetParameter: parameter value: false.
	"if"
	(canSet) ifTrue: [
				].
	domConfig setParameter: parameter value: true.

!

test_domconfignamespaces2
	"Document.getParameter( namespaces ) should be true regardles if the
    parse that created the document was namespace aware.
		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-namespaces
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#DOMConfiguration
	"
	|
	  doc "Document"
	  domConfig "DOMConfiguration"
	  state "Boolean"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	domConfig := doc domConfig.
	state := domConfig getParameter: 'namespaces'.
	self assert: state.

!

test_domconfignormalizecharacters1
	"Checks behavior of  normalize-characters  configuration parameter.
		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-normalize-characters
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#DOMConfiguration-getParameter
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#DOMConfiguration-setParameter
	"
	|
	  domImpl "DOMImplementation"
	  doc "Document"
	  domConfig "DOMConfiguration"
	  nullDocType "DocumentType"
	  canSet "Boolean"
	  state "Boolean"
	  parameter "String"
	|
	nullDocType := nil.
	parameter := 'nOrMalize-characters'.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	doc := domImpl createDocumentNS: 'http://www.w3.org/1999/xhtml' qualifiedName: 'html' doctype: nullDocType.
	domConfig := doc domConfig.
	state := domConfig getParameter: parameter.
	self deny: state.
	canSet := domConfig canSetParameter: parameter value: false.
	self assert: canSet.
	canSet := domConfig canSetParameter: parameter value: true.
	"if"
	(canSet) ifTrue: [
				].
	domConfig setParameter: parameter value: false.

!

test_domconfigparameternames01
	"Checks getParameterNames and canSetParameter for Document.domConfig.
		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-domConfig
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#DOMConfiguration-parameterNames
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-canonical-form
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-cdata-sections
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-check-character-normalization
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-comments
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-datatype-normalization
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-entities
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-error-handler
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-infoset
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-namespaces
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-namespace-declarations
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-normalize-characters
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-split-cdata-sections
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-validate
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-validate-if-schema
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-well-formed
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-element-content-whitespace
	"
	|
	  domImpl "DOMImplementation"
	  doc "Document"
	  config "DOMConfiguration"
	  state "Boolean"
	  parameterNames "DOMStringList"
	  parameterName "String"
	  matchCount "SmallInteger"
	  paramValue "DOMUserData"
	  canSet "Boolean"
	|
	matchCount := 0.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	config := doc domConfig.
	self assert: config notNil.
	parameterNames := config  parameterNames.
	self assert: parameterNames notNil.
parameterNames do: [:parameterName|
	paramValue := config getParameter: parameterName.
	canSet := config canSetParameter: parameterName value: paramValue.
	self assert: canSet.
	config setParameter: parameterName value: paramValue.
	"if"
	( parameterName asLowercase = 'canonical-form' asLowercase ) or: [( parameterName asLowercase = 'cdata-sections' asLowercase ) or: [( parameterName asLowercase = 'check-character-normalization' asLowercase ) or: [( parameterName asLowercase = 'comments' asLowercase ) or: [( parameterName asLowercase = 'datatype-normalization' asLowercase ) or: [( parameterName asLowercase = 'entities' asLowercase ) or: [( parameterName asLowercase = 'error-handler' asLowercase ) or: [( parameterName asLowercase = 'infoset' asLowercase ) or: [( parameterName asLowercase = 'namespaces' asLowercase ) or: [( parameterName asLowercase = 'namespace-declarations' asLowercase ) or: [( parameterName asLowercase = 'normalize-characters' asLowercase ) or: [( parameterName asLowercase = 'split-cdata-sections' asLowercase ) or: [( parameterName asLowercase = 'validate' asLowercase ) or: [( parameterName asLowercase = 'validate-if-schema' asLowercase ) or: [( parameterName asLowercase = 'well-formed' asLowercase ) or: [( parameterName asLowercase = 'element-content-whitespace' asLowercase )]]]]]]]]]]]]]]] ifTrue: [
		].
].
	self assert: ( matchCount = 16 ).

!

test_domconfigschemalocation1
	"Checks behavior of  schema-location  configuration parameter.
		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-schema-location
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#DOMConfiguration-getParameter
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#DOMConfiguration-setParameter
	"
	|
	  domImpl "DOMImplementation"
	  doc "Document"
	  domConfig "DOMConfiguration"
	  nullDocType "DocumentType"
	  canSet "Boolean"
	  state "String"
	  parameter "String"
	  nullSchemaLocation "String"
	  sampleSchemaLocation "String"
	|
	nullDocType := nil.
	parameter := 'sChEma-location'.
	nullSchemaLocation := nil.
	sampleSchemaLocation := 'http://www.example.com/schemas/sampleschema.xsd'.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	doc := domImpl createDocumentNS: 'http://www.w3.org/1999/xhtml' qualifiedName: 'html' doctype: nullDocType.
	domConfig := doc domConfig.
	canSet := domConfig canSetParameter: parameter value: true.
	self deny: canSet.
	"try"
	[
	state := domConfig getParameter: parameter.
	self assert: state isNil.
	] on: DOMException do: [:ex|	].
	"end of try"
	canSet := domConfig canSetParameter: parameter value: sampleSchemaLocation.
	self assert: canSet.
	canSet := domConfig canSetParameter: parameter value: nullSchemaLocation.
	self assert: canSet.
	domConfig setParameter: parameter value: sampleSchemaLocation.
	state := domConfig getParameter: parameter.
	self assert: ( state = sampleSchemaLocation ).
	domConfig setParameter: parameter value: nullSchemaLocation.
	state := domConfig getParameter: parameter.
	self assert: state isNil.

!

test_domconfigschematype1
	"Checks behavior of  schema-type  configuration parameter.
		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-schema-type
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#DOMConfiguration-getParameter
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#DOMConfiguration-setParameter
	"
	|
	  domImpl "DOMImplementation"
	  doc "Document"
	  domConfig "DOMConfiguration"
	  nullDocType "DocumentType"
	  canSet "Boolean"
	  state "String"
	  parameter "String"
	  xmlSchemaType "String"
	  dtdType "String"
	|
	nullDocType := nil.
	parameter := 'sChEma-type'.
	xmlSchemaType := 'http://www.w3.org/2001/XMLSchema'.
	dtdType := 'http://www.w3.org/TR/REC-xml'.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	doc := domImpl createDocumentNS: 'http://www.w3.org/1999/xhtml' qualifiedName: 'html' doctype: nullDocType.
	domConfig := doc domConfig.
	canSet := domConfig canSetParameter: parameter value: true.
	self deny: canSet.
	"try"
	[
	state := domConfig getParameter: parameter.
	] on: DOMException do: [:ex|	].
	"end of try"
	canSet := domConfig canSetParameter: parameter value: dtdType.
	"if"
	(canSet) ifTrue: [
				].
	canSet := domConfig canSetParameter: parameter value: xmlSchemaType.
	"if"
	(canSet) ifTrue: [
				].

!

test_domconfigsplitcdatasections1
	"Checks behavior of  split-cdata-sections  configuration parameter.
		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-split-cdata-sections
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#DOMConfiguration-getParameter
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#DOMConfiguration-setParameter
	"
	|
	  domImpl "DOMImplementation"
	  doc "Document"
	  domConfig "DOMConfiguration"
	  nullDocType "DocumentType"
	  canSet "Boolean"
	  state "Boolean"
	  parameter "String"
	|
	nullDocType := nil.
	parameter := 'sPlIt-cdata-sections'.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	doc := domImpl createDocumentNS: 'http://www.w3.org/1999/xhtml' qualifiedName: 'html' doctype: nullDocType.
	domConfig := doc domConfig.
	state := domConfig getParameter: parameter.
	self assert: state.
	canSet := domConfig canSetParameter: parameter value: false.
	self assert: canSet.
	canSet := domConfig canSetParameter: parameter value: true.
	self assert: canSet.
	domConfig setParameter: parameter value: false.
	state := domConfig getParameter: parameter.
	self deny: state.
	domConfig setParameter: parameter value: true.
	state := domConfig getParameter: parameter.
	self assert: state.

!

test_domconfigurationcansetparameter01
	"
	The parameter commments is turned on by default.  Check to see if this feature can be set
	to false by invoking canSetParameter method.  Also check that this method does not change the
	value of parameter.

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#DOMConfiguration-canSetParameter
	"
	|
	  doc "Document"
	  domConfig "DOMConfiguration"
	  canSet "Boolean"
	  newCommentNode "Comment"
	  docElem "Element"
	  appendedChild "Node"
	  lastChild "Node"
	  commentValue "String"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	newCommentNode := doc  createComment:'This is a new Comment node'.
	docElem := doc  documentElement.
	appendedChild := docElem  appendChild:newCommentNode.
	domConfig := doc domConfig.
	canSet := domConfig canSetParameter: 'comments' value: false.
	self assert: canSet.
	doc  normalizeDocument.
	lastChild := docElem  lastChild.
	commentValue := lastChild  nodeValue.
	self assert: ( commentValue = 'This is a new Comment node' ).

!

test_domconfigurationcansetparameter02
	"
Check that canSetParameter('cdata-sections') returns true for both true and false
and that calls to the method do not actually change the parameter value.

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#DOMConfiguration-canSetParameter
	"
	|
	  doc "Document"
	  domConfig "DOMConfiguration"
	  canSet "Boolean"
	  paramVal "Boolean"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	domConfig := doc domConfig.
	canSet := domConfig canSetParameter: 'cdata-sections' value: false.
	self assert: canSet.
	paramVal := domConfig getParameter: 'cdata-sections'.
	self assert: paramVal.
	canSet := domConfig canSetParameter: 'cdata-sections' value: true.
	self assert: canSet.
	domConfig setParameter: 'cdata-sections' value: false.
	canSet := domConfig canSetParameter: 'cdata-sections' value: true.
	self assert: canSet.
	paramVal := domConfig getParameter: 'cdata-sections'.
	self deny: paramVal.
	canSet := domConfig canSetParameter: 'cdata-sections' value: false.
	self assert: canSet.

!

test_domconfigurationcansetparameter03
	"
	The canSetParameter method checks if setting a parameter to a specific value is supported.
	
	The parameter entities is turned on by default.  Check to see if this feature can be set
	to false by invoking canSetParameter method.  Also check that this method does not change the
	value of parameter by checking if entities still exist in the document.

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#DOMConfiguration-canSetParameter
	"
	|
	  doc "Document"
	  domConfig "DOMConfiguration"
	  docType "DocumentType"
	  entitiesMap "NamedNodeMap"
	  nullNS "String"
	  entity "Entity"
	  entityName "String"
	  canSet "Boolean"
	|
	"implementationAttribute not supported: namespaceAware"
	nullNS := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	domConfig := doc domConfig.
	canSet := domConfig canSetParameter: 'entities' value: false.
	self assert: canSet.
	doc  normalizeDocument.
	docType := doc  doctype.
	entitiesMap := docType  entities.
	entity := entitiesMap  getNamedItem:'epsilon'.
	self assert: entity notNil.
	entityName := entity  nodeName.
	self assert: ( entityName = 'epsilon' ).

!

test_domconfigurationcansetparameter04
	"
	The parameter entities is turned on by default.  Check to see if this feature can be set
	to false by invoking canSetParameter method.  Also check that this method does not change the
	value of parameter by checking if entity references still exist in the document.

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#DOMConfiguration-canSetParameter
	"
	|
	  doc "Document"
	  domConfig "DOMConfiguration"
	  acronymList "NodeList"
	  acronymElem "Node"
	  nodeType "SmallInteger"
	  first "Node"
	  canSet "Boolean"
	  paramVal "Boolean"
	|
	"implementationAttribute not supported: expandEntityReferences"
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	domConfig := doc domConfig.
	canSet := domConfig canSetParameter: 'entities' value: false.
	self assert: canSet.
	paramVal := domConfig getParameter: 'entities'.
	self assert: paramVal.
	doc  normalizeDocument.
	acronymList := doc  getElementsByTagName: 'acronym'.
	acronymElem := acronymList  item:1.
	first := acronymElem  firstChild.
	nodeType := first  nodeType.
	self assert: ( nodeType = 5 ).

!

test_domconfigurationcansetparameter06
	"
Check that canSetParameter('element-content-whitespace', true) returns true
and that canSetParameter('element-content-whitespace) does not change value of
parameter.

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#DOMConfiguration-canSetParameter
	"
	|
	  doc "Document"
	  domConfig "DOMConfiguration"
	  itemList "NodeList"
	  elementBody "Element"
	  textNode "Text"
	  canSet "Boolean"
	  canSetFalse "Boolean"
	  paramVal "Boolean"
	  hasWhitespace "Boolean"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	domConfig := doc domConfig.
	canSetFalse := domConfig canSetParameter: 'element-content-whitespace' value: false.
	paramVal := domConfig getParameter: 'element-content-whitespace'.
	self assert: paramVal.
	"if"
	(canSetFalse) ifTrue: [
		].
	canSet := domConfig canSetParameter: 'element-content-whitespace' value: true.
	self assert: canSet.
	"if"
	(canSetFalse) ifTrue: [
			].

!

test_domconfigurationgetparameter01
	"
	The method getParameter returns the value of a parameter if known. 
	
	Get the DOMConfiguration object of a document and verify that the default required features are set
	to true.

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#DOMConfiguration-getParameter
	"
	|
	  doc "Document"
	  domConfig "DOMConfiguration"
	  param "DOMUserData"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	domConfig := doc domConfig.
	param := domConfig getParameter: 'comments'.
	self assert: param.
	param := domConfig getParameter: 'cdata-sections'.
	self assert: param.
	param := domConfig getParameter: 'entities'.
	self assert: param.
	param := domConfig getParameter: 'namespace-declarations'.
	self assert: param.
	param := domConfig getParameter: 'infoset'.
	self deny: param.

!

test_domconfigurationgetparameter02
	"
	The method getParameter returns the value of a parameter if known. 
	
	Get the DOMConfiguration object of a document and verify that a NOT_FOUND_ERR is thrown if the parameter
	is not found.

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#DOMConfiguration-getParameter
	"
	|
	  doc "Document"
	  domConfig "DOMConfiguration"
	  param "DOMUserData"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	domConfig := doc domConfig.
	"assertDOMException..."
	self should:[
	param := domConfig getParameter: 'not-found-param'.
	] raise: DOMException.
	self assert: (lastException code == DOMException NOT_FOUND_ERR).
	"end of assertDOMException..."

!

test_domconfigvalidate1
	"Checks behavior of  validate  configuration parameter.
		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-validate
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#DOMConfiguration-getParameter
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#DOMConfiguration-setParameter
	"
	|
	  domImpl "DOMImplementation"
	  doc "Document"
	  domConfig "DOMConfiguration"
	  nullDocType "DocumentType"
	  canSet "Boolean"
	  state "Boolean"
	  parameter "String"
	|
	nullDocType := nil.
	parameter := 'vAlIdate'.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	doc := domImpl createDocumentNS: 'http://www.w3.org/1999/xhtml' qualifiedName: 'html' doctype: nullDocType.
	domConfig := doc domConfig.
	state := domConfig getParameter: parameter.
	self deny: state.
	canSet := domConfig canSetParameter: parameter value: false.
	self assert: canSet.
	canSet := domConfig canSetParameter: parameter value: true.
	"if"
	(canSet) ifTrue: [
				].
	domConfig setParameter: parameter value: false.

!

test_domconfigvalidateifschema1
	"Checks behavior of  validate-if-schema  configuration parameter.
		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-validate-if-schema
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#DOMConfiguration-getParameter
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#DOMConfiguration-setParameter
	"
	|
	  domImpl "DOMImplementation"
	  doc "Document"
	  domConfig "DOMConfiguration"
	  nullDocType "DocumentType"
	  canSet "Boolean"
	  state "Boolean"
	  parameter "String"
	|
	nullDocType := nil.
	parameter := 'vAlIdate-if-schema'.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	doc := domImpl createDocumentNS: 'http://www.w3.org/1999/xhtml' qualifiedName: 'html' doctype: nullDocType.
	domConfig := doc domConfig.
	state := domConfig getParameter: parameter.
	self deny: state.
	canSet := domConfig canSetParameter: parameter value: false.
	self assert: canSet.
	canSet := domConfig canSetParameter: parameter value: true.
	"if"
	(canSet) ifTrue: [
				].
	domConfig setParameter: parameter value: false.

!

test_domconfigwellformed1
	"Checks behavior of  well-formed  configuration parameter.
		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-well-formed
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#DOMConfiguration-getParameter
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#DOMConfiguration-setParameter
	"
	|
	  domImpl "DOMImplementation"
	  doc "Document"
	  domConfig "DOMConfiguration"
	  nullDocType "DocumentType"
	  canSet "Boolean"
	  state "Boolean"
	  parameter "String"
	|
	nullDocType := nil.
	parameter := 'wElL-formed'.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	doc := domImpl createDocumentNS: 'http://www.w3.org/1999/xhtml' qualifiedName: 'html' doctype: nullDocType.
	domConfig := doc domConfig.
	state := domConfig getParameter: parameter.
	self assert: state.
	canSet := domConfig canSetParameter: parameter value: true.
	self assert: canSet.
	canSet := domConfig canSetParameter: parameter value: false.
	"if"
	(canSet) ifTrue: [
				].
	domConfig setParameter: parameter value: true.

!

test_domimplementationgetfeature01
	"
	Invoke getFeature method on this DOMImplementation with the value of the feature parameter
	as Core and version as 2.0.  This should return a DOMImplmentation object that's not null.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#DOMImplementation3-getFeature
	"
	|
	  doc "Document"
	  domImpl "DOMImplementation"
	  domImplReturned "DOMImplementation"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	domImplReturned := domImpl  getFeature:'Core' version:'2.0'.
	self assert: domImplReturned notNil.

!

test_domimplementationgetfeature02
	"
	Invoke getFeature method on this DOMImplementation with the value of the feature parameter
	as Core and version as   .  This should return a DOMImplementation object that's not null.
	

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#DOMImplementation3-getFeature
	"
	|
	  doc "Document"
	  domImpl "DOMImplementation"
	  domImplReturned "DOMImplementation"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	domImplReturned := domImpl  getFeature:'Core' version:''.
	self assert: domImplReturned notNil.

!

test_domimplementationgetfeature03
	"
	Invoke getFeature method on this DOMImplementation with the value of the feature parameter
	as Core and version as null.  This should return a DOMImplementation object that's not null.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#DOMImplementation3-getFeature
	"
	|
	  doc "Document"
	  domImpl "DOMImplementation"
	  domImplReturned "DOMImplementation"
	  nodeName "String"
	  nullVersion "String"
	|
	nullVersion := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	domImplReturned := domImpl  getFeature:'Core' version:nullVersion.
	self assert: domImplReturned notNil.

!

test_domimplementationgetfeature05
	"
	Invoke getFeature method on this DOMImplementation with the value of the feature parameter
	as    and version equal to null.  This should return a null DOMObject.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#DOMImplementation3-getFeature
	"
	|
	  doc "Document"
	  domImpl "DOMImplementation"
	  domImplReturned "DOMImplementation"
	  nullVersion "String"
	|
	nullVersion := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	domImplReturned := domImpl  getFeature:'' version:nullVersion.
	self assert: domImplReturned isNil.

!

test_domimplementationgetfeature06
	"
	Invoke getFeature method on this DOMImplementation with the value of the feature parameter
	as  1-1  (some junk) and version equal to  * .  This should return a null DOMObject.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#DOMImplementation3-getFeature
	"
	|
	  doc "Document"
	  domImpl "DOMImplementation"
	  domImplReturned "DOMImplementation"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	domImplReturned := domImpl  getFeature:'1-1' version:'*'.
	self assert: domImplReturned isNil.

!

test_domimplementationregistry01
	"
DOMImplementationRegistry.newInstance() (Java) or DOMImplementationRegistry global variable
(ECMAScript) should not be null.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/java-binding
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/ecma-script-binding
	"
	|
	  domImplRegistry "DOMImplementationRegistry"
	|
	domImplRegistry := DOMImplementationRegistry.
	self assert: domImplRegistry notNil.

!

test_domimplementationregistry02
	"
DOMImplementationRegistry.getDOMImplementation( cOrE ) should return a DOMImplementation
where hasFeature( Core , null) returns true.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/java-binding
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/ecma-script-binding
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-getDOMImpl
	"
	|
	  domImplRegistry "DOMImplementationRegistry"
	  domImpl "DOMImplementation"
	  hasFeature "Boolean"
	  nullVersion "String"
	|
	nullVersion := nil.
	domImplRegistry := DOMImplementationRegistry.
	self assert: domImplRegistry notNil.
	domImpl := domImplRegistry  getDOMImplementation:'cOrE'.
	self assert: domImpl notNil.
	hasFeature := domImpl  hasFeature:'Core' version:nullVersion.
	self assert: hasFeature.

!

test_domimplementationregistry03
	"
DOMImplementationRegistry.getDOMImplementation( cOrE 3.0 ) should return a DOMImplementation
where hasFeature( Core ,  3.0 ) returns true.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/java-binding
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/ecma-script-binding
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-getDOMImpl
	"
	|
	  domImplRegistry "DOMImplementationRegistry"
	  domImpl "DOMImplementation"
	  hasFeature "Boolean"
	|
	domImplRegistry := DOMImplementationRegistry.
	self assert: domImplRegistry notNil.
	domImpl := domImplRegistry  getDOMImplementation:'cOrE 3.0'.
	self assert: domImpl notNil.
	hasFeature := domImpl  hasFeature:'Core' version:'3.0'.
	self assert: hasFeature.

!

test_domimplementationregistry04
	"
DOMImplementationRegistry.getDOMImplementation( +cOrE ) should return a DOMImplementation
where hasFeature( +Core , null) returns true.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/java-binding
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/ecma-script-binding
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-getDOMImpl
	"
	|
	  domImplRegistry "DOMImplementationRegistry"
	  domImpl "DOMImplementation"
	  hasFeature "Boolean"
	  nullVersion "String"
	|
	nullVersion := nil.
	domImplRegistry := DOMImplementationRegistry.
	self assert: domImplRegistry notNil.
	domImpl := domImplRegistry  getDOMImplementation:'+cOrE'.
	self assert: domImpl notNil.
	hasFeature := domImpl  hasFeature:'+Core' version:nullVersion.
	self assert: hasFeature.

!

test_domimplementationregistry05
	"
DOMImplementationRegistry.getDOMImplementation( +cOrE 3.0 ) should return a DOMImplementation
where hasFeature( +Core ,  3.0 ) returns true.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/java-binding
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/ecma-script-binding
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-getDOMImpl
	"
	|
	  domImplRegistry "DOMImplementationRegistry"
	  domImpl "DOMImplementation"
	  hasFeature "Boolean"
	|
	domImplRegistry := DOMImplementationRegistry.
	self assert: domImplRegistry notNil.
	domImpl := domImplRegistry  getDOMImplementation:'+cOrE 3.0'.
	self assert: domImpl notNil.
	hasFeature := domImpl  hasFeature:'+Core' version:'3.0'.
	self assert: hasFeature.

!

test_domimplementationregistry06
	"
If the implementation supports  XML , DOMImplementationRegistry.getDOMImplementation( xMl 3.0 cOrE ) should 
return a DOMImplementation where hasFeature( XML ,  3.0 ), and hasFeature( Core , null) returns true.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/java-binding
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/ecma-script-binding
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-getDOMImpl
	"
	|
	  domImplRegistry "DOMImplementationRegistry"
	  domImpl "DOMImplementation"
	  hasFeature "Boolean"
	  nullVersion "String"
	|
	nullVersion := nil.
	domImplRegistry := DOMImplementationRegistry.
	self assert: domImplRegistry notNil.
	domImpl := domImplRegistry  getDOMImplementation:'xMl 3.0 cOrE'.
	self assert: domImpl notNil.
	hasFeature := domImpl  hasFeature:'XML' version:'3.0'.
	self assert: hasFeature.
	hasFeature := domImpl  hasFeature:'Core' version:nullVersion.
	self assert: hasFeature.

!

test_domimplementationregistry07
	"
DOMImplementationRegistry.getDOMImplementation( http://www.example.com/bogus-feature 99.0 ) should return 
null.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/java-binding
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/ecma-script-binding
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-getDOMImpl
	"
	|
	  domImplRegistry "DOMImplementationRegistry"
	  domImpl "DOMImplementation"
	  hasFeature "Boolean"
	  nullVersion "String"
	|
	nullVersion := nil.
	domImplRegistry := DOMImplementationRegistry.
	self assert: domImplRegistry notNil.
	domImpl := domImplRegistry  getDOMImplementation:'http://www.example.com/bogus-feature 99.0'.
	self assert: domImpl isNil.

!

test_domimplementationregistry08
	"
DOMImplementationRegistry.getDOMImplementation( SVG ) should return null or a DOMImplementation
where hasFeature( SVG , null) returns true.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/java-binding
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/ecma-script-binding
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-getDOMImpl
	"
	|
	  domImplRegistry "DOMImplementationRegistry"
	  domImpl "DOMImplementation"
	  baseImpl "DOMImplementation"
	  hasFeature "Boolean"
	  nullVersion "String"
	|
	nullVersion := nil.
	domImplRegistry := DOMImplementationRegistry.
	self assert: domImplRegistry notNil.
	domImpl := domImplRegistry  getDOMImplementation:'SVG'.
	"if"
	( domImpl isNil )  ifTrue: [
				].

!

test_domimplementationregistry09
	"
DOMImplementationRegistry.getDOMImplementation( HTML ) should return null or a DOMImplementation
where hasFeature( HTML , null) returns true.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/java-binding
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/ecma-script-binding
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-getDOMImpl
	"
	|
	  domImplRegistry "DOMImplementationRegistry"
	  domImpl "DOMImplementation"
	  hasFeature "Boolean"
	  baseImpl "DOMImplementation"
	  nullVersion "String"
	|
	nullVersion := nil.
	domImplRegistry := DOMImplementationRegistry.
	self assert: domImplRegistry notNil.
	domImpl := domImplRegistry  getDOMImplementation:'HTML'.
	"if"
	( domImpl isNil )  ifTrue: [
				].

!

test_domimplementationregistry10
	"
DOMImplementationRegistry.getDOMImplementation( LS ) should return null or a DOMImplementation
where hasFeature( LS , null) returns true.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/java-binding
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/ecma-script-binding
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-getDOMImpl
	"
	|
	  domImplRegistry "DOMImplementationRegistry"
	  domImpl "DOMImplementation"
	  hasFeature "Boolean"
	  baseImpl "DOMImplementation"
	  nullVersion "String"
	|
	nullVersion := nil.
	domImplRegistry := DOMImplementationRegistry.
	self assert: domImplRegistry notNil.
	domImpl := domImplRegistry  getDOMImplementation:'LS'.
	"if"
	( domImpl isNil )  ifTrue: [
				].

!

test_domimplementationregistry11
	"
DOMImplementationRegistry.getDOMImplementation( XPath ) should return null or a DOMImplementation
where hasFeature( XPath , null) returns true.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/java-binding
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/ecma-script-binding
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-getDOMImpl
	"
	|
	  domImplRegistry "DOMImplementationRegistry"
	  domImpl "DOMImplementation"
	  hasFeature "Boolean"
	  baseImpl "DOMImplementation"
	  nullVersion "String"
	|
	nullVersion := nil.
	domImplRegistry := DOMImplementationRegistry.
	self assert: domImplRegistry notNil.
	domImpl := domImplRegistry  getDOMImplementation:'XPath'.
	"if"
	( domImpl isNil )  ifTrue: [
				].

!

test_domimplementationregistry12
	"
DOMImplementationRegistry.getDOMImplementation( cOrE 3.0 xMl 3.0 eVeNts 2.0 lS ) should return null 
or a DOMImplementation that implements the specified features.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/java-binding
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/ecma-script-binding
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-getDOMImpl
	"
	|
	  domImplRegistry "DOMImplementationRegistry"
	  domImpl "DOMImplementation"
	  hasCore "Boolean"
	  hasXML "Boolean"
	  hasEvents "Boolean"
	  hasLS "Boolean"
	  baseImpl "DOMImplementation"
	  nullVersion "String"
	|
	nullVersion := nil.
	domImplRegistry := DOMImplementationRegistry.
	self assert: domImplRegistry notNil.
	domImpl := domImplRegistry  getDOMImplementation:'cOrE 3.0 xMl 3.0 eVeNts 2.0 lS'.
	"if"
	( domImpl isNil )  ifTrue: [
							self assert:false description:'Method "and" is not supported yet'.
	].

!

test_domimplementationregistry13
	"
DOMImplementationRegistry.getDOMImplementationList( cOrE ) should return a 
list of at least one DOMImplementation
where hasFeature( Core , null) returns true.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/java-binding
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/ecma-script-binding
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-getDOMImpls
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#DOMImplementationList-item
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#DOMImplementationList-length
	"
	|
	  domImplRegistry "DOMImplementationRegistry"
	  hasFeature "Boolean"
	  domImpl "DOMImplementation"
	  domImplList "DOMImplementationList"
	  length "SmallInteger"
	  nullVersion "String"
	|
	nullVersion := nil.
	domImplRegistry := DOMImplementationRegistry.
	self assert: domImplRegistry notNil.
	domImplList := domImplRegistry  getDOMImplementationList:'cOrE'.
	length := domImplList  length.
	domImpl := domImplList  item:length.
	self assert: domImpl isNil.
	self assert: ( length > 0 ).
domImplList do: [:domImpl|
	hasFeature := domImpl  hasFeature:'Core' version:nullVersion.
	self assert: hasFeature.
].

!

test_domimplementationregistry14
	"
DOMImplementationRegistry.getDOMImplementationList( cOrE 3.0 ) should return 
a list of DOMImplementation
where hasFeature( Core ,  3.0 ) returns true.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/java-binding
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/ecma-script-binding
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-getDOMImpls
	"
	|
	  domImplRegistry "DOMImplementationRegistry"
	  domImpl "DOMImplementation"
	  hasFeature "Boolean"
	  domImplList "DOMImplementationList"
	  length "SmallInteger"
	|
	domImplRegistry := DOMImplementationRegistry.
	self assert: domImplRegistry notNil.
	domImplList := domImplRegistry  getDOMImplementationList:'cOrE 3.0'.
	length := domImplList  length.
	self assert: ( length > 0 ).
domImplList do: [:domImpl|
	hasFeature := domImpl  hasFeature:'Core' version:'3.0'.
	self assert: hasFeature.
].

!

test_domimplementationregistry15
	"
DOMImplementationRegistry.getDOMImplementationList( +cOrE ) should return 
list of DOMImplementation
where hasFeature( +Core , null) returns true.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/java-binding
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/ecma-script-binding
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-getDOMImpls
	"
	|
	  domImplRegistry "DOMImplementationRegistry"
	  domImpl "DOMImplementation"
	  hasFeature "Boolean"
	  nullVersion "String"
	  domImplList "DOMImplementationList"
	  length "SmallInteger"
	|
	nullVersion := nil.
	domImplRegistry := DOMImplementationRegistry.
	self assert: domImplRegistry notNil.
	domImplList := domImplRegistry  getDOMImplementationList:'+cOrE'.
	length := domImplList  length.
	self assert: ( length > 0 ).
domImplList do: [:domImpl|
	hasFeature := domImpl  hasFeature:'+Core' version:nullVersion.
	self assert: hasFeature.
].

!

test_domimplementationregistry16
	"
DOMImplementationRegistry.getDOMImplementationList( +cOrE 3.0 ) should return 
a list of DOMImplementation
where hasFeature( +Core ,  3.0 ) returns true.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/java-binding
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/ecma-script-binding
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-getDOMImpls
	"
	|
	  domImplRegistry "DOMImplementationRegistry"
	  domImpl "DOMImplementation"
	  hasFeature "Boolean"
	  domImplList "DOMImplementationList"
	  length "SmallInteger"
	|
	domImplRegistry := DOMImplementationRegistry.
	self assert: domImplRegistry notNil.
	domImplList := domImplRegistry  getDOMImplementationList:'+cOrE 3.0'.
	length := domImplList  length.
	self assert: ( length > 0 ).
domImplList do: [:domImpl|
	hasFeature := domImpl  hasFeature:'+Core' version:'3.0'.
	self assert: hasFeature.
].

!

test_domimplementationregistry17
	"
If the implementation supports  XML , DOMImplementationRegistry.getDOMImplementationList( xMl 3.0 cOrE ) should 
return a list of DOMImplementation where hasFeature( XML ,  3.0 ), and hasFeature( Core , null) returns true.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/java-binding
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/ecma-script-binding
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-getDOMImpls
	"
	|
	  domImplRegistry "DOMImplementationRegistry"
	  domImpl "DOMImplementation"
	  hasFeature "Boolean"
	  nullVersion "String"
	  domImplList "DOMImplementationList"
	  length "SmallInteger"
	|
	nullVersion := nil.
	domImplRegistry := DOMImplementationRegistry.
	self assert: domImplRegistry notNil.
	domImplList := domImplRegistry  getDOMImplementationList:'xMl 3.0 cOrE'.
	length := domImplList  length.
	self assert: ( length > 0 ).
domImplList do: [:domImpl|
	hasFeature := domImpl  hasFeature:'XML' version:'3.0'.
	self assert: hasFeature.
	hasFeature := domImpl  hasFeature:'Core' version:nullVersion.
	self assert: hasFeature.
].

!

test_domimplementationregistry18
	"
DOMImplementationRegistry.getDOMImplementationList( http://www.example.com/bogus-feature 99.0 ) 
should return a zero-length list.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/java-binding
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/ecma-script-binding
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-getDOMImpls
	"
	|
	  domImplRegistry "DOMImplementationRegistry"
	  domImpl "DOMImplementation"
	  domImplList "DOMImplementationList"
	  length "SmallInteger"
	|
	domImplRegistry := DOMImplementationRegistry.
	self assert: domImplRegistry notNil.
	domImplList := domImplRegistry  getDOMImplementationList:'http://www.example.com/bogus-feature 99.0'.
	length := domImplList  length.
	self assert: ( length = 0 ).

!

test_domimplementationregistry19
	"
DOMImplementationRegistry.getDOMImplementationList( SVG ) should return 
zero-length list or a list of DOMImplementation
where hasFeature( SVG , null) returns true.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/java-binding
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/ecma-script-binding
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-getDOMImpls
	"
	|
	  domImplRegistry "DOMImplementationRegistry"
	  domImpl "DOMImplementation"
	  baseImpl "DOMImplementation"
	  hasFeature "Boolean"
	  nullVersion "String"
	  domImplList "DOMImplementationList"
	  length "SmallInteger"
	|
	nullVersion := nil.
	domImplRegistry := DOMImplementationRegistry.
	self assert: domImplRegistry notNil.
	domImplList := domImplRegistry  getDOMImplementationList:'SVG'.
	length := domImplList  length.
	"if"
	( length = 0 ) ifTrue: [
				].

!

test_domimplementationregistry20
	"
DOMImplementationRegistry.getDOMImplementationList( HTML ) should return 
an empty list or a list of DOMImplementation
where hasFeature( HTML , null) returns true.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/java-binding
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/ecma-script-binding
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-getDOMImpls
	"
	|
	  domImplRegistry "DOMImplementationRegistry"
	  domImpl "DOMImplementation"
	  hasFeature "Boolean"
	  baseImpl "DOMImplementation"
	  nullVersion "String"
	  domImplList "DOMImplementationList"
	  length "SmallInteger"
	|
	nullVersion := nil.
	domImplRegistry := DOMImplementationRegistry.
	self assert: domImplRegistry notNil.
	domImplList := domImplRegistry  getDOMImplementationList:'HTML'.
	length := domImplList  length.
	"if"
	( length = 0 ) ifTrue: [
				].

!

test_domimplementationregistry21
	"
DOMImplementationRegistry.getDOMImplementationList( LS ) should return 
a empty list or a list of DOMImplementation
where hasFeature( LS , null) returns true.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/java-binding
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/ecma-script-binding
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-getDOMImpls
	"
	|
	  domImplRegistry "DOMImplementationRegistry"
	  domImpl "DOMImplementation"
	  hasFeature "Boolean"
	  baseImpl "DOMImplementation"
	  nullVersion "String"
	  domImplList "DOMImplementationList"
	  length "SmallInteger"
	|
	nullVersion := nil.
	domImplRegistry := DOMImplementationRegistry.
	self assert: domImplRegistry notNil.
	domImplList := domImplRegistry  getDOMImplementationList:'LS'.
	length := domImplList  length.
	"if"
	( length = 0 ) ifTrue: [
				].

!

test_domimplementationregistry22
	"
DOMImplementationRegistry.getDOMImplementationList( XPath ) should return 
an empty list or a list of DOMImplementation
where hasFeature( XPath , null) returns true.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/java-binding
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/ecma-script-binding
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-getDOMImpls
	"
	|
	  domImplRegistry "DOMImplementationRegistry"
	  domImpl "DOMImplementation"
	  hasFeature "Boolean"
	  baseImpl "DOMImplementation"
	  nullVersion "String"
	  domImplList "DOMImplementationList"
	  length "SmallInteger"
	|
	nullVersion := nil.
	domImplRegistry := DOMImplementationRegistry.
	self assert: domImplRegistry notNil.
	domImplList := domImplRegistry  getDOMImplementationList:'XPath'.
	length := domImplList  length.
	"if"
	( length = 0 ) ifTrue: [
				].

!

test_domimplementationregistry23
	"
DOMImplementationRegistry.getDOMImplementationList( cOrE 3.0 xMl 3.0 eVeNts 2.0 lS ) 
should return an empty list or a list of DOMImplementation that implements the specified features.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/java-binding
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/ecma-script-binding
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-getDOMImpls
	"
	|
	  domImplRegistry "DOMImplementationRegistry"
	  domImpl "DOMImplementation"
	  hasCore "Boolean"
	  hasXML "Boolean"
	  hasEvents "Boolean"
	  hasLS "Boolean"
	  baseImpl "DOMImplementation"
	  nullVersion "String"
	  domImplList "DOMImplementationList"
	  length "SmallInteger"
	|
	nullVersion := nil.
	domImplRegistry := DOMImplementationRegistry.
	self assert: domImplRegistry notNil.
	domImplList := domImplRegistry  getDOMImplementationList:'cOrE 3.0 xMl 3.0 eVeNts 2.0 lS'.
	length := domImplList  length.
	"if"
	( length = 0 ) ifTrue: [
							self assert:false description:'Method "and" is not supported yet'.
	].

!

test_domimplementationregistry24
	"
DOMImplementationRegistry.getDOMImplementation(  ) should return an implementation.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/java-binding
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/ecma-script-binding
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-getDOMImpls
		Subject http://lists.w3.org/Archives/Public/www-dom/2004JanMar/0111.html
	"
	|
	  domImplRegistry "DOMImplementationRegistry"
	  domImpl "DOMImplementation"
	|
	domImplRegistry := DOMImplementationRegistry.
	self assert: domImplRegistry notNil.
	domImpl := domImplRegistry  getDOMImplementation:''.
	self assert: domImpl notNil.

!

test_domimplementationregistry25
	"
DOMImplementationRegistry.getDOMImplementationList( cOrE 3.0 xMl 3.0 eVeNts 2.0 lS ) 
should return an empty list or a list of DOMImplementation that implements the specified features.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/java-binding
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/ecma-script-binding
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-getDOMImpls
		Subject http://lists.w3.org/Archives/Public/www-dom/2004JanMar/0111.html
	"
	|
	  domImplRegistry "DOMImplementationRegistry"
	  domImplList "DOMImplementationList"
	  length "SmallInteger"
	|
	domImplRegistry := DOMImplementationRegistry.
	self assert: domImplRegistry notNil.
	domImplList := domImplRegistry  getDOMImplementationList:''.
	length := domImplList  length.
	self assert: ( length > 0 ).

!

test_domstringlistcontains01
	"
Check implementation of DOMStringList.contains by searching DOMConfig parameter
names for  comments  and   .

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#DOMStringList-contains
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#DOMConfiguration-parameterNames
	"
	|
	  doc "Document"
	  paramList "DOMStringList"
	  domConfig "DOMConfiguration"
	  contains "Boolean"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	domConfig := doc domConfig.
	paramList := domConfig  parameterNames.
	contains := paramList  contains:'comments'.
	self assert: contains.
	contains := paramList  contains:''.
	self deny: contains.

!

test_domstringlistcontains02
	"
	The contains method of the DOMStringList tests if a string is part of this DOMStringList.  
	
	Invoke the contains method on the list searching for several of the parameters recognized by the 
        DOMConfiguration object.  
	Verify that the list contains features that are required and supported by this DOMConfiguration object.
        Verify that the contains method returns false for a string that is not contained in this DOMStringList. 

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#DOMStringList-contains
	"
	|
	  doc "Document"
	  paramList "DOMStringList"
	  domConfig "DOMConfiguration"
	  contain "Boolean"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	domConfig := doc domConfig.
	paramList := domConfig  parameterNames.
	contain := paramList  contains:'comments'.
	self assert: contain.
	contain := paramList  contains:'cdata-sections'.
	self assert: contain.
	contain := paramList  contains:'entities'.
	self assert: contain.
	contain := paramList  contains:'error-handler'.
	self assert: contain.
	contain := paramList  contains:'infoset'.
	self assert: contain.
	contain := paramList  contains:'namespace-declarations'.
	self assert: contain.
	contain := paramList  contains:'element-content-whitespace'.
	self assert: contain.
	contain := paramList  contains:'test'.
	self deny: contain.

!

test_domstringlistgetlength01
	"
	The length attribute of the DOMStringList returns the number of DOMStrings in the list. 
	The range of valid child node indices is 0 to length-1 inclusive.

	Invoke the length on the list of parameters returned by the DOMConfiguration object.  
	Verify that the list is not null and length is not 0.

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#DOMStringList-length
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#DOMConfiguration-parameterNames
	"
	|
	  doc "Document"
	  paramList "DOMStringList"
	  domConfig "DOMConfiguration"
	  listSize "SmallInteger"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	domConfig := doc domConfig.
	paramList := domConfig  parameterNames.
	self assert: paramList notNil.
	listSize := paramList  length.
	self assert: listSize = 0.

!

test_domstringlistitem01
	"
Check implementation of DOMStringList.item by accessing items 0 and length-1 and expecting
a string and accessing items out of range and expecting null.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#DOMStringList-item
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#DOMConfiguration-parameterNames
	"
	|
	  doc "Document"
	  paramList "DOMStringList"
	  domConfig "DOMConfiguration"
	  contains "Boolean"
	  length "SmallInteger"
	  index "SmallInteger"
	  parameter "String"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	domConfig := doc domConfig.
	paramList := domConfig  parameterNames.
	length := paramList  length.
	parameter := paramList  item:0.
	self assert: parameter notNil.
	parameter := paramList  item:length.
	self assert: parameter isNil.
	length :=  length - 1.
	parameter := paramList  item:length.
	self assert: parameter notNil.

!

test_domstringlistitem02
	"
	The item method of the DOMStringList Returns the indexth item in the collection. 
	If index is greater than or equal to the number of DOMStrings in the list, this returns null.
	
	Invoke the first item on the list of parameters returned by the DOMConfiguration object and
	make sure it is not null.  Then invoke the 100th item and verify that null is returned.

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#DOMStringList-item
	"
	|
	  doc "Document"
	  paramList "DOMStringList"
	  domConfig "DOMConfiguration"
	  listSize "SmallInteger"
	  retStr "String"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	domConfig := doc domConfig.
	paramList := domConfig  parameterNames.
	retStr := paramList  item:0.
	self assert: retStr notNil.
	retStr := paramList  item:100.
	self assert: retStr isNil.

!

test_elementcontentwhitespace01
	"
Normalize document with element-content-whitespace set to true, check that
whitespace in element content is preserved.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-normalizeDocument
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-element-content-whitespace
	"
	|
	  doc "Document"
	  domConfig "DOMConfiguration"
	  canSet "Boolean"
	  errorMonitor "DOMErrorMonitor"
	  bodyList "NodeList"
	  body "Node"
	  child "Node"
	  childName "String"
	  childType "SmallInteger"
	  text "Text"
	|
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	domConfig := doc domConfig.
	domConfig setParameter: 'element-content-whitespace' value: true.
	domConfig setParameter: 'error-handler' value: errorMonitor.
	bodyList := doc  getElementsByTagName: 'body'.
	body := bodyList  item:0.
	child := body  firstChild.
	childType := child  nodeType.
	"if"
	( childType = 1 ) ifTrue: [
			].
	doc  normalizeDocument.
	errorMonitor  assertLowerSeverityFor: self message:'normalizeError' severity: DOMErrorMonitor SEVERITY_ERROR.
	bodyList := doc  getElementsByTagName: 'body'.
	body := bodyList  item:0.
	child := body  firstChild.
	self assert: child notNil.
	childName := child  nodeName.
	self assert: ( childName = '#text' ).
	child := child  nextSibling.
	self assert: child notNil.
	childName := child  nodeName.
	self assert: ( childName = 'p' ).

!

test_elementcontentwhitespace02
	"
Normalize document with element-content-whitespace set to false and validation set to true, check that
whitespace in element content is eliminated.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-normalizeDocument
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-element-content-whitespace
	"
	|
	  doc "Document"
	  bodyList "NodeList"
	  body "Element"
	  domConfig "DOMConfiguration"
	  canSet "Boolean"
	  canSetValidate "Boolean"
	  errorMonitor "DOMErrorMonitor"
	  child "Node"
	  childName "String"
	|
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	domConfig := doc domConfig.
	canSet := domConfig canSetParameter: 'element-content-whitespace' value: false.
	canSetValidate := domConfig canSetParameter: 'validate' value: true.
	"if"
	(canSetValidate) and: [(canSet)] ifTrue: [
														].

!

test_elementcontentwhitespace03
	"
Normalize document using Node.normalize with element-content-whitespace set to false and validation set to true, check that
whitespace in element content is preserved.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-normalize
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-element-content-whitespace
	"
	|
	  doc "Document"
	  bodyList "NodeList"
	  body "Element"
	  domConfig "DOMConfiguration"
	  canSet "Boolean"
	  canSetValidate "Boolean"
	  errorMonitor "DOMErrorMonitor"
	  child "Node"
	  childName "String"
	  text "Text"
	|
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	domConfig := doc domConfig.
	"if"
	false "no template for element implementationAttribute"  ifTrue: [
						].
	canSet := domConfig canSetParameter: 'element-content-whitespace' value: false.
	"if"
	(canSet) ifTrue: [
															].

!

test_elementgetschematypeinfo01
	"
Call getSchemaTypeInfo on title attribute for the first  em  element from DTD validated document.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Element-schemaTypeInfo
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-typeName
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-typeNamespace
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  elem "Element"
	  typeInfo "TypeInfo"
	  typeNS "String"
	  typeName "String"
	|
	^self. "Validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'em'.
	elem := elemList  item:0.
	typeInfo := elem  schemaTypeInfo.
	self assert: typeInfo notNil.
	typeName := typeInfo  typeName.
	self assert: typeName isNil.
	typeNS := typeInfo  typeNamespace.
	self assert: typeNS isNil.

!

test_elementgetschematypeinfo02
	"
Call getSchemaTypeInfo on title attribute for the first  em  element from schema-validated document.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Element-schemaTypeInfo
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-typeName
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-typeNamespace
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  elem "Element"
	  typeInfo "TypeInfo"
	  typeNS "String"
	  typeName "String"
	|
	^self. "Schema validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'em'.
	elem := elemList  item:0.
	typeInfo := elem  schemaTypeInfo.
	self assert: typeInfo notNil.
	typeName := typeInfo  typeName.
	self assert: ( typeName = 'emType' ).
	typeNS := typeInfo  typeNamespace.
	self assert: ( typeNS = 'http://www.w3.org/1999/xhtml' ).

!

test_elementgetschematypeinfo03
	"
Element.schemaTypeInfo should return null if not validating or schema validating.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Element-schemaTypeInfo
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-typeName
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-typeNamespace
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  elem "Element"
	  typeInfo "TypeInfo"
	  typeName "String"
	  typeNS "String"
	|
	"implementationAttribute not supported: validating"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_nodtdstaff').
	elemList := doc  getElementsByTagName: 'em'.
	elem := elemList  item:0.
	typeInfo := elem  schemaTypeInfo.
	self assert: typeInfo notNil.
	typeName := typeInfo  typeName.
	self assert: typeName isNil.
	typeNS := typeInfo  typeNamespace.
	self assert: typeNS isNil.

!

test_elementgetschematypeinfo04
	"
	The getSchemaTypeInfo method retrieves the type information associated with this element. 

	Load a valid document with an XML Schema.
	Invoke getSchemaTypeInfo method on an element having [type definition] property.  Expose {name} and {target namespace}
	properties of the [type definition] property.  Verity that the typeName and typeNamespace of the code element's
	schemaTypeInfo are correct.

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Element-schemaTypeInfo
	"
	|
	  doc "Document"
	  codeElem "Element"
	  elemTypeInfo "TypeInfo"
	  typeName "String"
	  typeNamespace "String"
	  elemList "NodeList"
	  docElemNodeName "String"
	|
	^self. "Schema validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'code'.
	codeElem := elemList  item:1.
	elemTypeInfo := codeElem  schemaTypeInfo.
	typeName := elemTypeInfo  typeName.
	typeNamespace := elemTypeInfo  typeNamespace.
	self assert: ( typeName = 'code' ).
	self assert: ( typeNamespace = 'http://www.w3.org/1999/xhtml' ).

!

test_elementgetschematypeinfo05
	"
	The getSchemaTypeInfo method retrieves the type information associated with this element. 

	Load a valid document with an XML Schema.
	Invoke getSchemaTypeInfo method on an element having [type definition] property.  Expose {name} and {target namespace}
	properties of the [type definition] property.  Verity that the typeName and typeNamespace of the acronym element's
	schemaTypeInfo are correct.

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Element-schemaTypeInfo
	"
	|
	  doc "Document"
	  acElem "Element"
	  elemTypeInfo "TypeInfo"
	  typeName "String"
	  typeNamespace "String"
	  elemList "NodeList"
	  docElemNodeName "String"
	|
	^self. "Schema validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'span'.
	acElem := elemList  item:0.
	elemTypeInfo := acElem  schemaTypeInfo.
	typeName := elemTypeInfo  typeName.
	typeNamespace := elemTypeInfo  typeNamespace.
	self assert: ( typeName = 'string' ).
	self assert: ( typeNamespace = 'http://www.w3.org/2001/XMLSchema' ).

!

test_elementgetschematypeinfo06
	"
	The getSchemaTypeInfo method retrieves the type information associated with this element. 

	Load a valid document with an XML Schema.
	Invoke getSchemaTypeInfo method on an element having [type definition] property.  Expose {name} and {target namespace}
	properties of the [type definition] property.  Verity that the typeName and typeNamespace of the strong element's
	schemaTypeInfo are correct.

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Element-schemaTypeInfo
	"
	|
	  doc "Document"
	  strongElem "Element"
	  elemTypeInfo "TypeInfo"
	  typeName "String"
	  typeNamespace "String"
	  elemList "NodeList"
	  docElemNodeName "String"
	|
	^self. "Schema validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'strong'.
	strongElem := elemList  item:1.
	elemTypeInfo := strongElem  schemaTypeInfo.
	typeName := elemTypeInfo  typeName.
	typeNamespace := elemTypeInfo  typeNamespace.
	self assert: ( typeName = 'strongType' ).
	self assert: ( typeNamespace = 'http://www.w3.org/1999/xhtml' ).

!

test_elementgetschematypeinfo07
	"
	The getSchemaTypeInfo method retrieves the type information associated with this element. 

	Load a valid document with an XML Schema.
	Invoke getSchemaTypeInfo method on an element having [type definition] property.  Expose {name} and {target namespace}
	properties of the [type definition] property.  Verity that the typeName and typeNamespace of the name element's
	schemaTypeInfo are correct.

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Element-schemaTypeInfo
	"
	|
	  doc "Document"
	  supElem "Element"
	  elemTypeInfo "TypeInfo"
	  typeName "String"
	  typeNamespace "String"
	  docElemNodeName "String"
	  elemList "NodeList"
	|
	^self. "Schema validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'sup'.
	supElem := elemList  item:0.
	elemTypeInfo := supElem  schemaTypeInfo.
	typeName := elemTypeInfo  typeName.
	typeNamespace := elemTypeInfo  typeNamespace.
	self assert: ( typeName = 'sup' ).
	self assert: ( typeNamespace = 'http://www.w3.org/1999/xhtml' ).

!

test_elementsetidattribute01
	"
	Invoke setIdAttribute on the third acronym element's class attribute.  Verify by calling isID
	on the class attribute and getElementById on document. Invoke setIdAttribute again to reset.
	Calling isID should return false.

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-ElSetIdAttr
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  acronymElem "Element"
	  attributesMap "NamedNodeMap"
	  attr "Attr"
	  id "Boolean"
	  elem "Element"
	  elemName "String"
	|
	id := false.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'acronym'.
	acronymElem := elemList  item:2.
	acronymElem  setIdAttribute: 'class' isId:true.
	attributesMap := acronymElem  attributes.
	attr := attributesMap  getNamedItem:'class'.
	id := attr  isId.
	self assert: id.
	elem := doc  getElementById:'No'.
	elemName := elem  tagName.
	self assert: ( elemName = 'acronym' ).
	acronymElem  setIdAttribute: 'class' isId:false.
	id := attr  isId.
	self deny: id.

!

test_elementsetidattribute03
	"
	First use setAttribute to change the class attribute of the third acronym element.  Invoke setIdAttribute
	on the newly set attribute. Verify by calling isID on the new attribute and getElementById on document.
	Invoke setIdAttribute again to reset.  Calling isID should return false.

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-ElSetIdAttr
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  acronymElem "Element"
	  attributesMap "NamedNodeMap"
	  attr "Attr"
	  id "Boolean"
	  elem "Element"
	  elemName "String"
	|
	id := false.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'acronym'.
	acronymElem := elemList  item:2.
	acronymElem  setAttribute:'class' value:'Maybe'.
	acronymElem  setIdAttribute: 'class' isId:true.
	attributesMap := acronymElem  attributes.
	attr := attributesMap  getNamedItem:'class'.
	id := attr  isId.
	self assert: id.
	elem := doc  getElementById:'Maybe'.
	elemName := elem  tagName.
	self assert: ( elemName = 'acronym' ).
	acronymElem  setIdAttribute: 'class' isId:false.
	id := attr  isId.
	self deny: id.

!

test_elementsetidattribute04
	"
	First use setAttribute to create a new attribute on the third strong element.  Invoke setIdAttribute
	on the new  attribute. Verify by calling isID on the new attribute and getElementById on document.
	Invoke setIdAttribute again to reset. Calling isID should return false.

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-ElSetIdAttr
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  nameElem "Element"
	  attributesMap "NamedNodeMap"
	  attr "Attr"
	  id "Boolean"
	  elem "Element"
	  elemName "String"
	|
	id := false.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'strong'.
	nameElem := elemList  item:2.
	nameElem  setAttribute:'hasMiddleName' value:'Antoine'.
	nameElem  setIdAttribute: 'hasMiddleName' isId:true.
	attributesMap := nameElem  attributes.
	attr := attributesMap  getNamedItem:'hasMiddleName'.
	id := attr  isId.
	self assert: id.
	elem := doc  getElementById:'Antoine'.
	elemName := elem  tagName.
	self assert: ( elemName = 'strong' ).
	nameElem  setIdAttribute: 'hasMiddleName' isId:false.
	id := attr  isId.
	self deny: id.

!

test_elementsetidattribute05
	"
	Invoke setIdAttribute on the third strong element with a non-existing attribute name.  Verify that
	NOT_FOUND_ERR is raised.

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-ElSetIdAttr
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  nameElem "Element"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'strong'.
	nameElem := elemList  item:2.
	"assertDOMException..."
	self should:[
	nameElem  setIdAttribute: 'hasMiddleName' isId:true.
	] raise: DOMException.
	self assert: (lastException code == DOMException NOT_FOUND_ERR).
	"end of assertDOMException..."

!

test_elementsetidattribute06
	"
	Invoke setIdAttribute on the third strong element with an attribute name of the acronym element.
	Verify that NOT_FOUND_ERR is raised.

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-ElSetIdAttr
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  nameElem "Element"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'strong'.
	nameElem := elemList  item:2.
	"assertDOMException..."
	self should:[
	nameElem  setIdAttribute: 'class' isId:true.
	] raise: DOMException.
	self assert: (lastException code == DOMException NOT_FOUND_ERR).
	"end of assertDOMException..."

!

test_elementsetidattribute07
	"
	First use setAttribute to create two new attribute of the second and third strong element with different values.
	Invoke setIdAttribute on the new  attributes. Verify by calling isID on the new attributes and getElementById 
	with two different values on document.	

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-ElSetIdAttr
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  nameElem1 "Element"
	  nameElem2 "Element"
	  attributesMap "NamedNodeMap"
	  attr "Attr"
	  id "Boolean"
	  elem "Element"
	  elemName "String"
	|
	id := false.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'strong'.
	nameElem1 := elemList  item:2.
	nameElem2 := elemList  item:3.
	nameElem1  setAttribute:'hasMiddleName' value:'Antoine'.
	nameElem1  setIdAttribute: 'hasMiddleName' isId:true.
	nameElem2  setAttribute:'hasMiddleName' value:'Neeya'.
	nameElem2  setIdAttribute: 'hasMiddleName' isId:true.
	attributesMap := nameElem1  attributes.
	attr := attributesMap  getNamedItem:'hasMiddleName'.
	id := attr  isId.
	self assert: id.
	attributesMap := nameElem2  attributes.
	attr := attributesMap  getNamedItem:'hasMiddleName'.
	id := attr  isId.
	self assert: id.
	elem := doc  getElementById:'Antoine'.
	elemName := elem  tagName.
	self assert: ( elemName = 'strong' ).
	elem := doc  getElementById:'Neeya'.
	elemName := elem  tagName.
	self assert: ( elemName = 'strong' ).

!

test_elementsetidattribute08
	"
	Invoke setIdAttribute class attribute on the second, third, and the fifth acronym element. 
	Verify by calling isID on the attributes and getElementById with the unique value  No  on document.
	
		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-ElSetIdAttr
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  acronymElem1 "Element"
	  acronymElem2 "Element"
	  acronymElem3 "Element"
	  attributesMap "NamedNodeMap"
	  attr "Attr"
	  id "Boolean"
	  elem "Element"
	  elemName "String"
	|
	id := false.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'acronym'.
	acronymElem1 := elemList  item:1.
	acronymElem2 := elemList  item:2.
	acronymElem3 := elemList  item:4.
	acronymElem1  setIdAttribute: 'class' isId:true.
	acronymElem2  setIdAttribute: 'class' isId:true.
	acronymElem3  setIdAttribute: 'class' isId:true.
	attributesMap := acronymElem1  attributes.
	attr := attributesMap  getNamedItem:'class'.
	id := attr  isId.
	self assert: id.
	attributesMap := acronymElem2  attributes.
	attr := attributesMap  getNamedItem:'class'.
	id := attr  isId.
	self assert: id.
	attributesMap := acronymElem3  attributes.
	attr := attributesMap  getNamedItem:'class'.
	id := attr  isId.
	self assert: id.
	elem := doc  getElementById:'No'.
	elemName := elem  tagName.
	self assert: ( elemName = 'acronym' ).

!

test_elementsetidattribute09
	"
	First use setAttribute to create two new attributes on the second strong element and sup element.
	Invoke setIdAttribute on the new attributes. Verify by calling isID on the new attributes and getElementById 
	with two different values on document.	

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-ElSetIdAttr
	"
	|
	  doc "Document"
	  elemList1 "NodeList"
	  elemList2 "NodeList"
	  nameElem "Element"
	  salaryElem "Element"
	  attributesMap "NamedNodeMap"
	  attr "Attr"
	  id "Boolean"
	  elem "Element"
	  elemName "String"
	|
	id := false.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList1 := doc  getElementsByTagName: 'strong'.
	elemList2 := doc  getElementsByTagName: 'sup'.
	nameElem := elemList1  item:2.
	salaryElem := elemList2  item:2.
	nameElem  setAttribute:'hasMiddleName' value:'Antoine'.
	salaryElem  setAttribute:'annual' value:'2002'.
	nameElem  setIdAttribute: 'hasMiddleName' isId:true.
	salaryElem  setIdAttribute: 'annual' isId:true.
	attributesMap := nameElem  attributes.
	attr := attributesMap  getNamedItem:'hasMiddleName'.
	id := attr  isId.
	self assert: id.
	attributesMap := salaryElem  attributes.
	attr := attributesMap  getNamedItem:'annual'.
	id := attr  isId.
	self assert: id.
	elem := doc  getElementById:'Antoine'.
	elemName := elem  tagName.
	self assert: ( elemName = 'strong' ).
	elem := doc  getElementById:'2002'.
	elemName := elem  tagName.
	self assert: ( elemName = 'sup' ).

!

test_elementsetidattribute10
	"
	Invoke setIdAttribute on the third acronym element's class attribute consecutively with different
	isId values. Verify by calling isId on the attribute. 

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-ElSetIdAttr
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  acronymElem "Element"
	  attributesMap "NamedNodeMap"
	  attr "Attr"
	  id "Boolean"
	  elem "Element"
	  elemName "String"
	|
	id := false.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'acronym'.
	acronymElem := elemList  item:2.
	acronymElem  setIdAttribute: 'class' isId:true.
	attributesMap := acronymElem  attributes.
	attr := attributesMap  getNamedItem:'class'.
	id := attr  isId.
	self assert: id.
	acronymElem  setIdAttribute: 'class' isId:true.
	id := attr  isId.
	self assert: id.
	acronymElem  setIdAttribute: 'class' isId:false.
	id := attr  isId.
	self deny: id.
	elem := doc  getElementById:'No'.
	self assert: elem isNil.

!

test_elementsetidattribute11
	"
	Invoke setIdAttribute on the 4th acronym element's class attribute which contains 
	an entity reference.  Verify by calling isID on the class attribute and getElementById 
	on document. Invoke setIdAttribute again to reset.  Calling isID should return false.

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-ElSetIdAttr
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  acronymElem "Element"
	  attributesMap "NamedNodeMap"
	  attr "Attr"
	  id "Boolean"
	  elem "Element"
	  elemName "String"
	|
	id := false.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'acronym'.
	acronymElem := elemList  item:3.
	acronymElem  setIdAttribute: 'class' isId:true.
	attributesMap := acronymElem  attributes.
	attr := attributesMap  getNamedItem:'class'.
	id := attr  isId.
	self assert: id.
	elem := doc  getElementById:'Yα'.
	self assert: elem notNil.
	elemName := elem  tagName.
	self assert: ( elemName = 'acronym' ).
	acronymElem  setIdAttribute: 'class' isId:false.
	id := attr  isId.
	self deny: id.

!

test_elementsetidattributenode01
	"
     Invoke setIdAttributeNode on the 3rd p element using the title attribute as a parameter .  Verify by calling
     isID on the attribute node and getElementById on document node. Call setIdAttributeNode again with isId=false
     to reset.  Invoke isId on the attribute node should return false.
    
		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-ElSetIdAttrNode
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  employeeElem "Element"
	  attributesMap "NamedNodeMap"
	  attr "Attr"
	  id "Boolean"
	  elem "Element"
	  elemName "String"
	|
	id := false.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'p'.
	employeeElem := elemList  item:2.
	attributesMap := employeeElem  attributes.
	attr := attributesMap  getNamedItem:'xmlns:dmstc'.
	employeeElem  setIdAttributeNode:attr isId:true.
	id := attr  isId.
	self assert: id.
	elem := doc  getElementById:'http://www.netzero.com'.
	elemName := elem  tagName.
	self assert: ( elemName = 'p' ).
	elem  setIdAttributeNode:attr isId:false.
	id := attr  isId.
	self deny: id.

!

test_elementsetidattributenode02
	"
     Invoke setIdAttributeNode on the 3rd acronym element using the class attribute as a parameter .  Verify by calling
     isID on the attribute node and getElementById on document node.  Call setIdAttributeNode again with isId=false
     to reset.  Invoke isId on the attribute node should return false.
    
		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-ElSetIdAttrNode
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  acronymElem "Element"
	  attributesMap "NamedNodeMap"
	  attr "Attr"
	  id "Boolean"
	  elem "Element"
	  elemName "String"
	|
	id := false.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'acronym'.
	acronymElem := elemList  item:2.
	attributesMap := acronymElem  attributes.
	attr := attributesMap  getNamedItem:'class'.
	acronymElem  setIdAttributeNode:attr isId:true.
	id := attr  isId.
	self assert: id.
	elem := doc  getElementById:'No'.
	elemName := elem  tagName.
	self assert: ( elemName = 'acronym' ).
	elem  setIdAttributeNode:attr isId:false.
	id := attr  isId.
	self deny: id.

!

test_elementsetidattributenode03
	"
     Create a new attribute node on the second strong element.  Invoke setIdAttributeNode on a newly created 
     attribute node.  Verify by calling isID on the attribute node and getElementById on document node. 
     Call setIdAttributeNode again with isId=false to reset.  Invoke isId on the attribute node should return false.
    
		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-ElSetIdAttrNode
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  nameElem "Element"
	  attributesMap "NamedNodeMap"
	  attr "Attr"
	  newAttr "Attr"
	  id "Boolean"
	  elem "Element"
	  elemName "String"
	|
	id := false.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'strong'.
	nameElem := elemList  item:1.
	nameElem  setAttribute:'title' value:'Karen'.
	attributesMap := nameElem  attributes.
	attr := attributesMap  getNamedItem:'title'.
	nameElem  setIdAttributeNode:attr isId:true.
	id := attr  isId.
	self assert: id.
	elem := doc  getElementById:'Karen'.
	elemName := elem  tagName.
	self assert: ( elemName = 'strong' ).
	elem  setIdAttributeNode:attr isId:false.
	id := attr  isId.
	self deny: id.

!

test_elementsetidattributenode04
	"
     Create a new namespace attribute on the second strong element.  Invoke setIdAttributeNode on a newly created 
     attribute node.  Verify by calling isID on the attribute node and getElementById on document node. 
     Call setIdAttributeNode again with isId=false to reset.  Invoke isId on the attribute node should return false.
    
		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-ElSetIdAttrNode
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  nameElem "Element"
	  attributesMap "NamedNodeMap"
	  attr "Attr"
	  newAttr "Attr"
	  id "Boolean"
	  elem "Element"
	  elemName "String"
	|
	id := false.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'strong'.
	nameElem := elemList  item:1.
	nameElem  setAttribute: 'xmlns:middle' ns: 'http://www.w3.org/2000/xmlns/' value: 'http://www.example.com/middle'.
	attributesMap := nameElem  attributes.
	attr := attributesMap  getNamedItem:'xmlns:middle'.
	nameElem  setIdAttributeNode:attr isId:true.
	id := attr  isId.
	self assert: id.
	elem := doc  getElementById:'http://www.example.com/middle'.
	elemName := elem  tagName.
	self assert: ( elemName = 'strong' ).
	elem  setIdAttributeNode:attr isId:false.
	id := attr  isId.
	self deny: id.

!

test_elementsetidattributenode05
	"
     Invoke setIdAttributeNode on the third strong element but with the class attribute of the acronym
     element as a parameter.  Verify that NOT_FOUND_ERR is raised.

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-ElSetIdAttrNode
	"
	|
	  doc "Document"
	  elemList1 "NodeList"
	  elemList2 "NodeList"
	  nameElem "Element"
	  acronymElem "Element"
	  attributesMap "NamedNodeMap"
	  attr "Attr"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList1 := doc  getElementsByTagName: 'strong'.
	elemList2 := doc  getElementsByTagName: 'acronym'.
	nameElem := elemList1  item:1.
	acronymElem := elemList2  item:1.
	attributesMap := acronymElem  attributes.
	attr := attributesMap  getNamedItem:'class'.
	"assertDOMException..."
	self should:[
	nameElem  setIdAttributeNode:attr isId:true.
	] raise: DOMException.
	self assert: (lastException code == DOMException NOT_FOUND_ERR).
	"end of assertDOMException..."

!

test_elementsetidattributenode06
	"
     Invoke setIdAttributeNode on the third strong element but with the title attribute of the acronym
     element as a parameter.  Verify that NOT_FOUND_ERR is raised.

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-ElSetIdAttrNode
	"
	|
	  doc "Document"
	  elemList1 "NodeList"
	  elemList2 "NodeList"
	  nameElem "Element"
	  acronymElem "Element"
	  attributesMap "NamedNodeMap"
	  attr "Attr"
	  nameElement "Element"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList1 := doc  getElementsByTagName: 'strong'.
	elemList2 := doc  getElementsByTagName: 'acronym'.
	nameElem := elemList1  item:1.
	acronymElem := elemList2  item:1.
	attributesMap := acronymElem  attributes.
	attr := attributesMap  getNamedItem:'xsi:noNamespaceSchemaLocation'.
	"assertDOMException..."
	self should:[
	nameElem  setIdAttributeNode:attr isId:true.
	] raise: DOMException.
	self assert: (lastException code == DOMException NOT_FOUND_ERR).
	"end of assertDOMException..."

!

test_elementsetidattributenode07
	"
     Invoke setIdAttributeNode on the 2nd and 3rd acronym element using the class attribute as a parameter .  Verify by calling
     isID on the attribute node and getElementById on document node.  
    
		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-ElSetIdAttrNode
	"
	|
	  doc "Document"
	  elemList1 "NodeList"
	  elemList2 "NodeList"
	  acronymElem1 "Element"
	  acronymElem2 "Element"
	  attributesMap "NamedNodeMap"
	  attr "Attr"
	  id "Boolean"
	  elem "Element"
	  elemName "String"
	|
	id := false.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList1 := doc  getElementsByTagName: 'acronym'.
	elemList2 := doc  getElementsByTagName: 'acronym'.
	acronymElem1 := elemList1  item:1.
	acronymElem2 := elemList2  item:2.
	attributesMap := acronymElem1  attributes.
	attr := attributesMap  getNamedItem:'class'.
	acronymElem1  setIdAttributeNode:attr isId:true.
	id := attr  isId.
	self assert: id.
	attributesMap := acronymElem2  attributes.
	attr := attributesMap  getNamedItem:'class'.
	acronymElem2  setIdAttributeNode:attr isId:true.
	id := attr  isId.
	self assert: id.
	elem := doc  getElementById:'No'.
	elemName := elem  tagName.
	self assert: ( elemName = 'acronym' ).
	elem := doc  getElementById:'Yes'.
	elemName := elem  tagName.
	self assert: ( elemName = 'acronym' ).

!

test_elementsetidattributenode08
	"
     This method declares the attribute specified by node to be of type ID. If the value of the specified attribute 
     is unique then this element node can later be retrieved using getElementById on Document. Note, however, 
     that this simply affects this node and does not change any grammar that may be in use. 
     
     Invoke setIdAttributeNode on the 2nd acronym element and 3rd p element using the title and xmlns:dmstc attributes respectively
     as parameters .  Verify by calling isID on the attribute node and getElementById on document node.  
    
		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-ElSetIdAttrNode
	"
	|
	  doc "Document"
	  elemList1 "NodeList"
	  elemList2 "NodeList"
	  acronymElem "Element"
	  pElem "Element"
	  attributesMap "NamedNodeMap"
	  attr "Attr"
	  id "Boolean"
	  elem "Element"
	  elemName "String"
	|
	"implementationAttribute not supported: namespaceAware"
	id := false.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList1 := doc  getElementsByTagName: 'acronym' ns: '*'.
	elemList2 := doc  getElementsByTagName: 'p' ns: '*'.
	acronymElem := elemList1  item:1.
	pElem := elemList2  item:2.
	attributesMap := acronymElem  attributes.
	attr := attributesMap  getNamedItem:'title'.
	acronymElem  setIdAttributeNode:attr isId:true.
	id := attr  isId.
	self assert: id.
	attributesMap := pElem  attributes.
	attr := attributesMap  getNamedItem:'xmlns:dmstc'.
	pElem  setIdAttributeNode:attr isId:true.
	id := attr  isId.
	self assert: id.
	elem := doc  getElementById:'Yes'.
	elemName := elem  tagName.
	self assert: ( elemName = 'acronym' ).
	elem := doc  getElementById:'http://www.netzero.com'.
	elemName := elem  tagName.
	self assert: ( elemName = 'p' ).

!

test_elementsetidattributenode09
	"
     This method declares the attribute specified by node to be of type ID. If the value of the specified attribute 
     is unique then this element node can later be retrieved using getElementById on Document. Note, however, 
     that this simply affects this node and does not change any grammar that may be in use. 
     
     Invoke setIdAttributeNode with the xmlns attribute of ent4.  Verify that NO_MODIFICATION_ALLOWED_ERR is raised.

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-ElSetIdAttrNode
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  varElem "Element"
	  entRef "EntityReference"
	  entElement "Element"
	  attributesMap "NamedNodeMap"
	  attr "Attr"
	  domConfig "DOMConfiguration"
	|
	"implementationAttribute not supported: namespaceAware"
	"implementationAttribute not supported: expandEntityReferences"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	domConfig := doc domConfig.
	domConfig setParameter: 'entities' value: true.
	doc  normalizeDocument.
	elemList := doc  getElementsByTagName: 'var' ns: '*'.
	varElem := elemList  item:2.
	entRef := varElem  firstChild.
	entElement := entRef  firstChild.
	attributesMap := entElement  attributes.
	attr := attributesMap  getNamedItem:'xmlns'.
	"assertDOMException..."
	self should:[
	entElement  setIdAttributeNode:attr isId:true.
	] raise: DOMException.
	self assert: (lastException code == DOMException NO_MODIFICATION_ALLOWED_ERR).
	"end of assertDOMException..."

!

test_elementsetidattributenode10
	"
     This method declares the attribute specified by node to be of type ID. If the value of the specified attribute 
     is unique then this element node can later be retrieved using getElementById on Document. Note, however, 
     that this simply affects this node and does not change any grammar that may be in use. 
     
     Invoke setIdAttributeNode on the 4th acronym element using the class attribute (containing entity reference)
     as a parameter .  Verify by calling isId on the attribute node and getElementById on document node.  
     Reset by invoking setIdAttributeNode with isId=false.  
    
		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-ElSetIdAttrNode
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  acronymElem "Element"
	  attributesMap "NamedNodeMap"
	  attr "Attr"
	  id "Boolean"
	  elem "Element"
	  elemName "String"
	|
	"implementationAttribute not supported: namespaceAware"
	id := false.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'acronym' ns: '*'.
	acronymElem := elemList  item:3.
	attributesMap := acronymElem  attributes.
	attr := attributesMap  getNamedItem:'class'.
	acronymElem  setIdAttributeNode:attr isId:true.
	id := attr  isId.
	self assert: id.
	elem := doc  getElementById:'Yα'.
	elemName := elem  tagName.
	self assert: ( elemName = 'acronym' ).
	acronymElem  setIdAttributeNode:attr isId:false.
	id := attr  isId.
	self deny: id.

!

test_elementsetidattributens01
	"
     Invoke setIdAttributeNS on an existing namespace attribute with a namespace URI and a qualified name.  Verify by calling
     isId on the attribute node and getElementById on document node.  Call setIdAttributeNS with isId=false to reset. 
     isId should now return false. 
    
		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-ElSetIdAttrNS
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  employeeElem "Element"
	  attributesMap "NamedNodeMap"
	  attr "Attr"
	  id "Boolean"
	  elem "Element"
	  elemName "String"
	|
	"implementationAttribute not supported: namespaceAware"
	id := false.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'p'.
	employeeElem := elemList  item:2.
	employeeElem  setIdAttribute: 'dmstc' ns: 'http://www.w3.org/2000/xmlns/' isId:true.
	attributesMap := employeeElem  attributes.
	attr := attributesMap  getNamedItem:'xmlns:dmstc'.
	id := attr  isId.
	self assert: id.
	elem := doc  getElementById:'http://www.netzero.com'.
	elemName := elem  tagName.
	self assert: ( elemName = 'p' ).
	employeeElem  setIdAttribute: 'dmstc' ns: 'http://www.w3.org/2000/xmlns/' isId:false.
	id := attr  isId.
	self deny: id.

!

test_elementsetidattributens02
	"
     Invoke setIdAttributeNS on an existing attribute with a namespace URI and a qualified name.  Verify by calling
     isID on the attribute node and getElementById on document node. Assume the grammar has not defined any
     element of typeID. Call setIdAttributeNS with isId=false to reset. Method isId should now return false. 
    
		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-ElSetIdAttrNS
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  addressElem "Element"
	  attributesMap "NamedNodeMap"
	  attr "Attr"
	  id "Boolean"
	  elem "Element"
	  elemName "String"
	  xsiNS "String"
	|
	"implementationAttribute not supported: namespaceAware"
	id := false.
	xsiNS := 'http://www.w3.org/2001/XMLSchema-instance'.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'acronym' ns: '*'.
	addressElem := elemList  item:2.
	addressElem  setIdAttribute: 'noNamespaceSchemaLocation' ns: xsiNS isId:true.
	attributesMap := addressElem  attributes.
	attr := attributesMap  getNamedItem:'xsi:noNamespaceSchemaLocation'.
	id := attr  isId.
	self assert: id.
	elem := doc  getElementById:'Yes'.
	self assert: elem notNil.
	elemName := elem  tagName.
	self assert: ( elemName = 'acronym' ).
	addressElem  setIdAttribute: 'noNamespaceSchemaLocation' ns: xsiNS isId:false.
	id := attr  isId.
	self deny: id.

!

test_elementsetidattributens03
	"
     Invoke setIdAttributeNS on a newly added namespace attribute on the first em element.  Verify by calling
     isID on the attribute node and getElementById on document node. Call setIdAttributeNS with isId=false to reset. 
     Method isId should now return false. 
    
		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-ElSetIdAttrNS
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  employeeIdElem "Element"
	  attributesMap "NamedNodeMap"
	  attr "Attr"
	  id "Boolean"
	  elem "Element"
	  elemName "String"
	|
	id := false.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'em'.
	employeeIdElem := elemList  item:0.
	employeeIdElem  setAttribute: 'xmlns:newAttr' ns: 'http://www.w3.org/2000/xmlns/' value: 'newValue'.
	employeeIdElem  setIdAttribute: 'newAttr' ns: 'http://www.w3.org/2000/xmlns/' isId:true.
	attributesMap := employeeIdElem  attributes.
	attr := attributesMap  getNamedItem:'xmlns:newAttr'.
	id := attr  isId.
	self assert: id.
	elem := doc  getElementById:'newValue'.
	elemName := elem  tagName.
	self assert: ( elemName = 'em' ).
	employeeIdElem  setIdAttribute: 'newAttr' ns: 'http://www.w3.org/2000/xmlns/' isId:false.
	id := attr  isId.
	self deny: id.

!

test_elementsetidattributens04
	"
     The method setIdAttributeNS declares the attribute specified by local name and namespace URI to be of type ID. 
     If the value of the specified attribute is unique then this element node can later be retrieved using getElementById on Document. 
     Note, however, that this simply affects this node and does not change any grammar that may be in use. 
     
     Invoke setIdAttributeNS on newly added attribute on the third strong element.  Verify by calling
     isID on the attribute node and getElementById on document node.
     Call setIdAttributeNS with isId=false to reset. Method isId should now return false. 
    
		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-ElSetIdAttrNS
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  strongElem "Element"
	  attributesMap "NamedNodeMap"
	  attr "Attr"
	  id "Boolean"
	  elem "Element"
	  elemName "String"
	|
	"implementationAttribute not supported: namespaceAware"
	id := false.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'strong' ns: '*'.
	strongElem := elemList  item:2.
	strongElem  setAttribute: 'dmstc:newAttr' ns: 'http://www.netzero.com' value: 'newValue'.
	strongElem  setIdAttribute: 'newAttr' ns: 'http://www.netzero.com' isId:true.
	attributesMap := strongElem  attributes.
	attr := attributesMap  getNamedItem:'dmstc:newAttr'.
	id := attr  isId.
	self assert: id.
	elem := doc  getElementById:'newValue'.
	elemName := elem  tagName.
	self assert: ( elemName = 'strong' ).
	strongElem  setIdAttribute: 'newAttr' ns: 'http://www.netzero.com' isId:false.
	id := attr  isId.
	self deny: id.

!

test_elementsetidattributens05
	"
     The method setIdAttributeNS declares the attribute specified by local name and namespace URI to be of type ID. 
     If the value of the specified attribute is unique then this element node can later be retrieved using getElementById on Document. 
     Note, however, that this simply affects this node and does not change any grammar that may be in use. 
     
     Invoke setIdAttributeNS on a changed attribute of  the third acronym element.  Verify by calling
     isID on the attribute node and getElementById on document node.
     Call setIdAttributeNS with isId=false to reset. Method isId should now return false. 
    
		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-ElSetIdAttrNS
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  acronymElem "Element"
	  attributesMap "NamedNodeMap"
	  attr "Attr"
	  id "Boolean"
	  elem "Element"
	  elemName "String"
	|
	"implementationAttribute not supported: namespaceAware"
	id := false.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'acronym' ns: '*'.
	acronymElem := elemList  item:2.
	acronymElem  setAttribute: 'title' ns: '*' value: 'newValue'.
	acronymElem  setIdAttribute: 'title' ns: '*' isId:true.
	attributesMap := acronymElem  attributes.
	attr := attributesMap  getNamedItem:'title'.
	id := attr  isId.
	self assert: id.
	elem := doc  getElementById:'newValue'.
	elemName := elem  tagName.
	self assert: ( elemName = 'acronym' ).
	acronymElem  setIdAttribute: 'title' ns: '*' isId:false.
	id := attr  isId.
	self deny: id.

!

test_elementsetidattributens06
	"
     Invoke setIdAttributeNS on the third strong element with a non-existing attribute name.  Verify that
     NOT_FOUND_ERR is raised.

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-ElSetIdAttrNS
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  nameElem "Element"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'strong'.
	nameElem := elemList  item:2.
	"assertDOMException..."
	self should:[
	nameElem  setIdAttribute: 'hasMiddleName' ns: 'http://www.netzero.com' isId:true.
	] raise: DOMException.
	self assert: (lastException code == DOMException NOT_FOUND_ERR).
	"end of assertDOMException..."

!

test_elementsetidattributens07
	"
     Invoke setIdAttributeNS on the second p element with a non-existing attribute.  Verify that
     NOT_FOUND_ERR is raised.

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-ElSetIdAttrNS
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  employeeElem "Element"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'p'.
	employeeElem := elemList  item:1.
	"assertDOMException..."
	self should:[
	employeeElem  setIdAttribute: 'xsi' ns: 'http://www.netzero.com' isId:true.
	] raise: DOMException.
	self assert: (lastException code == DOMException NOT_FOUND_ERR).
	"end of assertDOMException..."

!

test_elementsetidattributens08
	"
     Invoke setIdAttributeNS on the second p element with a non-existing attribute.  Verify that
     NOT_FOUND_ERR is raised.

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-ElSetIdAttrNode
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  employeeElem "Element"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'p'.
	employeeElem := elemList  item:1.
	"assertDOMException..."
	self should:[
	employeeElem  setIdAttribute: 'usa' ns: 'http://www.usa.com' isId:true.
	] raise: DOMException.
	self assert: (lastException code == DOMException NOT_FOUND_ERR).
	"end of assertDOMException..."

!

test_elementsetidattributens09
	"
     The method setIdAttributeNS declares the attribute specified by local name and namespace URI to be of type ID. 
     If the value of the specified attribute is unique then this element node can later be retrieved using getElementById on Document. 
     Note, however, that this simply affects this node and does not change any grammar that may be in use. 
     
     Invoke setIdAttributeNS on the xmlns attribute of ent4.  Verify that NO_MODIFICATION_ALLOWED_ERR is raised.

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-ElSetIdAttrNS
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  varElem "Element"
	  entRef "EntityReference"
	  entElement "Element"
	|
	"implementationAttribute not supported: namespaceAware"
	"implementationAttribute not supported: expandEntityReferences"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'var' ns: '*'.
	varElem := elemList  item:2.
	entRef := varElem  firstChild.
	entElement := entRef  firstChild.
	"assertDOMException..."
	self should:[
	entElement  setIdAttribute: 'xmlns' ns: 'http://www.w3.org/2000/xmlns/' isId:true.
	] raise: DOMException.
	self assert: (lastException code == DOMException NO_MODIFICATION_ALLOWED_ERR).
	"end of assertDOMException..."

!

test_elementsetidattributens10
	"
     Declares the attribute specified by local name and namespace URI to be of type ID. If the value of the 
     specified attribute is unique then this element node can later be retrieved using getElementById on Document. 
     Note, however, that this simply affects this node and does not change any grammar that may be in use. 
     
     Invoke setIdAttributeNS on two existing namespace attributes with different values.  Verify by calling
     isId on the attributes and getElementById with different values on document node.  
    
		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-ElSetIdAttrNS
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  pElem1 "Element"
	  pElem2 "Element"
	  attributesMap "NamedNodeMap"
	  attr "Attr"
	  id "Boolean"
	  elem "Element"
	  elemName "String"
	|
	"implementationAttribute not supported: namespaceAware"
	id := false.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'p' ns: '*'.
	pElem1 := elemList  item:2.
	pElem2 := elemList  item:3.
	pElem1  setIdAttribute: 'dmstc' ns: 'http://www.w3.org/2000/xmlns/' isId:true.
	pElem2  setIdAttribute: 'nm' ns: 'http://www.w3.org/2000/xmlns/' isId:true.
	attributesMap := pElem1  attributes.
	attr := attributesMap  getNamedItem:'xmlns:dmstc'.
	id := attr  isId.
	self assert: id.
	attributesMap := pElem2  attributes.
	attr := attributesMap  getNamedItem:'xmlns:nm'.
	id := attr  isId.
	self assert: id.
	elem := doc  getElementById:'http://www.netzero.com'.
	elemName := elem  tagName.
	self assert: ( elemName = 'p' ).
	elem := doc  getElementById:'http://www.altavista.com'.
	elemName := elem  tagName.
	self assert: ( elemName = 'p' ).

!

test_elementsetidattributens11
	"
     Declares the attribute specified by local name and namespace URI to be of type ID. If the value of the 
     specified attribute is unique then this element node can later be retrieved using getElementById on Document. 
     Note, however, that this simply affects this node and does not change any grammar that may be in use. 
     
     Invoke setIdAttributeNS on two existing namespace attributes with same local name but different values.  Verify by calling
     isId on the attributes node and getElementById with different values on document node.  
    
		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-ElSetIdAttrNS
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  pElem1 "Element"
	  pElem2 "Element"
	  attributesMap "NamedNodeMap"
	  attr "Attr"
	  id "Boolean"
	  elem "Element"
	  elemName "String"
	|
	"implementationAttribute not supported: namespaceAware"
	id := false.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'p' ns: '*'.
	pElem1 := elemList  item:1.
	pElem2 := elemList  item:2.
	pElem1  setIdAttribute: 'dmstc' ns: 'http://www.w3.org/2000/xmlns/' isId:true.
	pElem2  setIdAttribute: 'dmstc' ns: 'http://www.w3.org/2000/xmlns/' isId:true.
	attributesMap := pElem1  attributes.
	attr := attributesMap  getNamedItem:'xmlns:dmstc'.
	id := attr  isId.
	self assert: id.
	attributesMap := pElem2  attributes.
	attr := attributesMap  getNamedItem:'xmlns:dmstc'.
	id := attr  isId.
	self assert: id.
	elem := doc  getElementById:'http://www.netzero.com'.
	elemName := elem  tagName.
	self assert: ( elemName = 'p' ).
	elem := doc  getElementById:'http://www.usa.com'.
	elemName := elem  tagName.
	self assert: ( elemName = 'p' ).

!

test_elementsetidattributens12
	"
     Declares the attribute specified by local name and namespace URI to be of type ID. If the value of the 
     specified attribute is unique then this element node can later be retrieved using getElementById on Document. 
     Note, however, that this simply affects this node and does not change any grammar that may be in use. 
     
     Set the noNamespaceSchemaLocation attribute on the first acronym element to  No .  Invoke setIdAttributeNS on the 
     noNamespaceSchemaLocation attribute of the first, second and third acronym element.  Verify by calling isId on 
     the attributes.  Calling getElementById with  No  as a value should return the acronym element.  
    
		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-ElSetIdAttrNS
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  acronymElem1 "Element"
	  acronymElem2 "Element"
	  acronymElem3 "Element"
	  attributesMap "NamedNodeMap"
	  attr "Attr"
	  id "Boolean"
	  elem "Element"
	  elemName "String"
	|
	"implementationAttribute not supported: namespaceAware"
	id := false.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'acronym' ns: '*'.
	acronymElem1 := elemList  item:0.
	acronymElem2 := elemList  item:1.
	acronymElem3 := elemList  item:2.
	acronymElem1  setAttribute: 'xsi:noNamespaceSchemaLocation' ns: 'http://www.w3.org/2001/XMLSchema-instance' value: 'No'.
	acronymElem1  setIdAttribute: 'noNamespaceSchemaLocation' ns: 'http://www.w3.org/2001/XMLSchema-instance' isId:true.
	acronymElem2  setIdAttribute: 'noNamespaceSchemaLocation' ns: 'http://www.w3.org/2001/XMLSchema-instance' isId:true.
	acronymElem3  setIdAttribute: 'noNamespaceSchemaLocation' ns: 'http://www.w3.org/2001/XMLSchema-instance' isId:true.
	attributesMap := acronymElem1  attributes.
	attr := attributesMap  getNamedItem:'xsi:noNamespaceSchemaLocation'.
	id := attr  isId.
	self assert: id.
	attributesMap := acronymElem2  attributes.
	attr := attributesMap  getNamedItem:'xsi:noNamespaceSchemaLocation'.
	id := attr  isId.
	self assert: id.
	attributesMap := acronymElem3  attributes.
	attr := attributesMap  getNamedItem:'xsi:noNamespaceSchemaLocation'.
	id := attr  isId.
	self assert: id.
	elem := doc  getElementById:'No'.
	elemName := elem  tagName.
	self assert: ( elemName = 'acronym' ).

!

test_elementsetidattributens13
	"
     Invoke setIdAttributeNS on newly added attribute on the third strong element.  Verify by calling
     isID on the attribute node and getElementById on document node.
     Call setIdAttributeNS on the same element to reset ID but with a non-existing attribute should generate
     NOT_FOUND_ERR
    
		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-ElSetIdAttrNS
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  nameElem "Element"
	  attributesMap "NamedNodeMap"
	  attr "Attr"
	  id "Boolean"
	  elem "Element"
	  elemName "String"
	|
	id := false.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'strong'.
	nameElem := elemList  item:2.
	nameElem  setAttribute: 'xmlns:newAttr' ns: 'http://www.w3.org/2000/xmlns/' value: 'newValue'.
	nameElem  setIdAttribute: 'newAttr' ns: 'http://www.w3.org/2000/xmlns/' isId:true.
	attributesMap := nameElem  attributes.
	attr := attributesMap  getNamedItem:'xmlns:newAttr'.
	id := attr  isId.
	self assert: id.
	elem := doc  getElementById:'newValue'.
	elemName := elem  tagName.
	self assert: ( elemName = 'strong' ).
	"assertDOMException..."
	self should:[
	nameElem  setIdAttribute: 'lang' ns: 'http://www.w3.org/XML/1998/namespace' isId:false.
	] raise: DOMException.
	self assert: (lastException code == DOMException NOT_FOUND_ERR).
	"end of assertDOMException..."

!

test_elementsetidattributens14
	"
     Declares the attribute specified by local name and namespace URI to be of type ID. If the value of the 
     specified attribute is unique then this element node can later be retrieved using getElementById on Document. 
     Note, however, that this simply affects this node and does not change any grammar that may be in use. 
     
     Invoke setIdAttributeNS on two existing attributes of the second p element and the third
     acronym element.  Verify by calling isId on the attributes and getElementById with different values on document node.  
    
		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-ElSetIdAttrNS
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  pElem "Element"
	  acronymElem "Element"
	  attributesMap "NamedNodeMap"
	  attr "Attr"
	  id "Boolean"
	  elem "Element"
	  elemName "String"
	|
	"implementationAttribute not supported: namespaceAware"
	id := false.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'p' ns: '*'.
	pElem := elemList  item:1.
	elemList := doc  getElementsByTagName: 'acronym' ns: '*'.
	acronymElem := elemList  item:2.
	pElem  setIdAttribute: 'dmstc' ns: 'http://www.w3.org/2000/xmlns/' isId:true.
	acronymElem  setIdAttribute: 'noNamespaceSchemaLocation' ns: 'http://www.w3.org/2001/XMLSchema-instance' isId:true.
	attributesMap := pElem  attributes.
	attr := attributesMap  getNamedItem:'xmlns:dmstc'.
	id := attr  isId.
	self assert: id.
	attributesMap := acronymElem  attributes.
	attr := attributesMap  getNamedItem:'xsi:noNamespaceSchemaLocation'.
	id := attr  isId.
	self assert: id.
	elem := doc  getElementById:'Yes'.
	elemName := elem  tagName.
	self assert: ( elemName = 'acronym' ).
	elem := doc  getElementById:'http://www.usa.com'.
	elemName := elem  tagName.
	self assert: ( elemName = 'p' ).

!

test_entities01
	"
Normalize document with entities set to true, check that
entity references and unused entity declaration are maintained.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-normalizeDocument
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-entities
	"
	|
	  doc "Document"
	  pList "NodeList"
	  pElem "Element"
	  domConfig "DOMConfiguration"
	  canSet "Boolean"
	  canSetValidate "Boolean"
	  errorMonitor "DOMErrorMonitor"
	  child "Node"
	  childName "String"
	  entRef "EntityReference"
	  entities "NamedNodeMap"
	  ent2 "Entity"
	  doctype "DocumentType"
	|
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	domConfig := doc domConfig.
	domConfig setParameter: 'entities' value: true.
	domConfig setParameter: 'error-handler' value: errorMonitor.
	pList := doc  getElementsByTagName: 'p'.
	pElem := pList  item:0.
	entRef := doc  createEntityReference:'ent1'.
	child := pElem  appendChild:entRef.
	doc  normalizeDocument.
	errorMonitor  assertLowerSeverityFor: self message:'normalizeError' severity: DOMErrorMonitor SEVERITY_ERROR.
	pList := doc  getElementsByTagName: 'p'.
	pElem := pList  item:0.
	child := pElem  lastChild.
	self assert: child notNil.
	childName := child  nodeName.
	self assert: ( childName = 'ent1' ).
	doctype := doc  doctype.
	entities := doctype  entities.
	ent2 := entities  getNamedItem:'ent2'.
	self assert: ent2 notNil.

!

test_entities02
	"
Normalize document with entities set to false, check that
entity references are expanded and unused entity declaration are maintained.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-normalizeDocument
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-entities
	"
	|
	  doc "Document"
	  pList "NodeList"
	  pElem "Element"
	  domConfig "DOMConfiguration"
	  canSet "Boolean"
	  canSetValidate "Boolean"
	  errorMonitor "DOMErrorMonitor"
	  child "Node"
	  childName "String"
	  entRef "EntityReference"
	  childValue "String"
	  entities "NamedNodeMap"
	  ent2 "Entity"
	  doctype "DocumentType"
	|
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	domConfig := doc domConfig.
	domConfig setParameter: 'entities' value: false.
	domConfig setParameter: 'error-handler' value: errorMonitor.
	pList := doc  getElementsByTagName: 'p'.
	pElem := pList  item:0.
	entRef := doc  createEntityReference:'ent1'.
	child := pElem  appendChild:entRef.
	doc  normalizeDocument.
	errorMonitor  assertLowerSeverityFor: self message:'normalizeError' severity: DOMErrorMonitor SEVERITY_ERROR.
	pList := doc  getElementsByTagName: 'p'.
	pElem := pList  item:0.
	child := pElem  lastChild.
	self assert: child notNil.
	childName := child  nodeName.
	self assert: ( childName = '#text' ).
	childValue := child  nodeValue.
	self assert: ( childValue = 'barfoo' ).
	doctype := doc  doctype.
	entities := doctype  entities.
	ent2 := entities  getNamedItem:'ent2'.
	self assert: ent2 notNil.

!

test_entities03
	"
Normalize document with entities set to false, check that
unbound entity references are preserved.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-normalizeDocument
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-entities
	"
	|
	  doc "Document"
	  pList "NodeList"
	  pElem "Element"
	  domConfig "DOMConfiguration"
	  canSet "Boolean"
	  canSetValidate "Boolean"
	  errorMonitor "DOMErrorMonitor"
	  child "Node"
	  childName "String"
	  entRef "EntityReference"
	  childType "SmallInteger"
	|
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	domConfig := doc domConfig.
	domConfig setParameter: 'entities' value: false.
	domConfig setParameter: 'error-handler' value: errorMonitor.
	pList := doc  getElementsByTagName: 'p'.
	pElem := pList  item:0.
	entRef := doc  createEntityReference:'ent3'.
	child := pElem  appendChild:entRef.
	doc  normalizeDocument.
	errorMonitor  assertLowerSeverityFor: self message:'normalizeError' severity: DOMErrorMonitor SEVERITY_ERROR.
	pList := doc  getElementsByTagName: 'p'.
	pElem := pList  item:0.
	child := pElem  lastChild.
	self assert: child notNil.
	childType := child  nodeType.
	self assert: ( childType = 5 ).
	childName := child  nodeName.
	self assert: ( childName = 'ent3' ).

!

test_entities04
	"
Normalize document using Node.normalize checking that  entities  parameter is ignored.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-normalize
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-entities
	"
	|
	  doc "Document"
	  pList "NodeList"
	  pElem "Element"
	  domConfig "DOMConfiguration"
	  canSet "Boolean"
	  canSetValidate "Boolean"
	  errorMonitor "DOMErrorMonitor"
	  child "Node"
	  childName "String"
	  entRef "EntityReference"
	  entities "NamedNodeMap"
	  ent2 "Entity"
	  doctype "DocumentType"
	|
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	domConfig := doc domConfig.
	domConfig setParameter: 'entities' value: false.
	domConfig setParameter: 'error-handler' value: errorMonitor.
	pList := doc  getElementsByTagName: 'p'.
	pElem := pList  item:0.
	entRef := doc  createEntityReference:'ent1'.
	child := pElem  appendChild:entRef.
	doc  normalize.
	errorMonitor  assertLowerSeverityFor: self message:'normalizeError' severity: DOMErrorMonitor SEVERITY_ERROR.
	pList := doc  getElementsByTagName: 'p'.
	pElem := pList  item:0.
	child := pElem  lastChild.
	self assert: child notNil.
	childName := child  nodeName.
	self assert: ( childName = 'ent1' ).
	doctype := doc  doctype.
	entities := doctype  entities.
	ent2 := entities  getNamedItem:'ent2'.
	self assert: ent2 notNil.

!

test_entitygetinputencoding01
	"
	Call the getInputEncoding method on a UTF-8 encoded document and check if the 
	value returned is null for a internal general entity.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Entity3-inputEncoding
	"
	|
	  doc "Document"
	  docType "DocumentType"
	  entitiesMap "NamedNodeMap"
	  entity "Entity"
	  encodingName "String"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docType := doc  doctype.
	entitiesMap := docType  entities.
	entity := entitiesMap  getNamedItem:'alpha'.
	encodingName := entity  inputEncoding.
	self assert: encodingName isNil.

!

test_entitygetinputencoding02
	"
	Call the getInputEncoding method on a UTF-16 encoded document that contains an external
	unparsed entity and check if the value returned is null.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Entity3-inputEncoding
	"
	|
	  doc "Document"
	  docType "DocumentType"
	  entitiesMap "NamedNodeMap"
	  entity "Entity"
	  encodingName "String"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo_utf16').
	docType := doc  doctype.
	entitiesMap := docType  entities.
	entity := entitiesMap  getNamedItem:'ent5'.
	encodingName := entity  inputEncoding.
	self assert: encodingName isNil.

!

test_entitygetinputencoding03
	"
Check the value of Entity.inputEncoding on an UTF-16 external entity 
is either UTF-16 or UTF-16LE

		Creator: IBM
		Autor Neil Delima
		Autor Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Entity3-inputEncoding
		Subject http://lists.w3.org/Archives/Public/www-dom-ts/2003Dec/0045.html
	"
	|
	  doc "Document"
	  docType "DocumentType"
	  entitiesMap "NamedNodeMap"
	  entity "Entity"
	  encodingName "String"
	|
	^self. "Validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'external_barfoo').
	docType := doc  doctype.
	entitiesMap := docType  entities.
	entity := entitiesMap  getNamedItem:'ent1'.
	encodingName := entity  inputEncoding.
	"if"
	( encodingName asLowercase = 'UTF-16LE' asLowercase ) not ifTrue: [
		].
	encodingName := doc  inputEncoding.
	self assert: ( encodingName asLowercase = 'UTF-8' asLowercase ).

!

test_entitygetinputencoding04
	"
Check the value of Entity.inputEncoding on an UTF-8 external entity 
is UTF-8.

		Creator: IBM
		Autor Neil Delima
		Autor Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Entity3-inputEncoding
		Subject http://lists.w3.org/Archives/Public/www-dom-ts/2003Dec/0045.html
	"
	|
	  doc "Document"
	  docType "DocumentType"
	  entitiesMap "NamedNodeMap"
	  entity "Entity"
	  encodingName "String"
	|
	^self. "Validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'external_barfoo').
	docType := doc  doctype.
	entitiesMap := docType  entities.
	entity := entitiesMap  getNamedItem:'ent2'.
	encodingName := entity  inputEncoding.
	self assert: ( encodingName asLowercase = 'UTF-8' asLowercase ).
	encodingName := doc  inputEncoding.
	self assert: ( encodingName asLowercase = 'UTF-8' asLowercase ).

!

test_entitygetxmlencoding01
	"
	Call the getXmlEncoding method on a UTF-8 encoded entity of a document that is not an 
	external parsed entity  and check if the value returned is null.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Entity3-encoding
	"
	|
	  doc "Document"
	  docType "DocumentType"
	  entitiesMap "NamedNodeMap"
	  entity "Entity"
	  encodingName "String"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docType := doc  doctype.
	entitiesMap := docType  entities.
	entity := entitiesMap  getNamedItem:'alpha'.
	encodingName := entity  xmlEncoding.
	self assert: encodingName isNil.

!

test_entitygetxmlencoding02
	"
	Call the getencoding method on a document that contains an external
	unparsed entity and check if the value returned is null.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Entity3-encoding
	"
	|
	  doc "Document"
	  docType "DocumentType"
	  entitiesMap "NamedNodeMap"
	  entity "Entity"
	  encodingName "String"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'external_barfoo').
	docType := doc  doctype.
	entitiesMap := docType  entities.
	entity := entitiesMap  getNamedItem:'ent5'.
	encodingName := entity  xmlEncoding.
	self assert: encodingName isNil.

!

test_entitygetxmlencoding03
	"
Check the value of Entity.xmlEncoding on an external entity with an encoding
declaration precisely matches the specified value.

		Creator: IBM
		Autor Neil Delima
		Autor Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Entity3-encoding
		Subject http://lists.w3.org/Archives/Public/www-dom-ts/2003Dec/0045.html
	"
	|
	  doc "Document"
	  docType "DocumentType"
	  entitiesMap "NamedNodeMap"
	  entity "Entity"
	  encodingName "String"
	|
	^self. "Validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'external_barfoo').
	docType := doc  doctype.
	entitiesMap := docType  entities.
	entity := entitiesMap  getNamedItem:'ent1'.
	encodingName := entity  xmlEncoding.
	self assert: ( encodingName = 'uTf-16' ).

!

test_entitygetxmlencoding04
	"
Check the value of Entity.xmlEncoding on an external entity without an encoding
declaration is null.

		Creator: IBM
		Autor Neil Delima
		Autor Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Entity3-encoding
		Subject http://lists.w3.org/Archives/Public/www-dom-ts/2003Dec/0045.html
	"
	|
	  doc "Document"
	  docType "DocumentType"
	  entitiesMap "NamedNodeMap"
	  entity "Entity"
	  encodingName "String"
	|
	^self. "Validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'external_barfoo').
	docType := doc  doctype.
	entitiesMap := docType  entities.
	entity := entitiesMap  getNamedItem:'ent2'.
	encodingName := entity  xmlEncoding.
	self assert: encodingName isNil.

!

test_entitygetxmlversion01
	"
	Call the getXmlVersion method on entity that is not an external entity and check if
	the value returned is null.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Entity3-version
	"
	|
	  doc "Document"
	  docType "DocumentType"
	  entitiesMap "NamedNodeMap"
	  entity "Entity"
	  entityVersion "String"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docType := doc  doctype.
	entitiesMap := docType  entities.
	entity := entitiesMap  getNamedItem:'epsilon'.
	self assert: entityVersion isNil.

!

test_entitygetxmlversion02
	"
	Call the getXmlVersion method on a UTF-16 encoded document that contains an external
	unparsed entity declaration and check if the value returned is null.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Entity3-version
	"
	|
	  doc "Document"
	  docType "DocumentType"
	  entitiesMap "NamedNodeMap"
	  entity "Entity"
	  entityVersion "String"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo_utf16').
	docType := doc  doctype.
	entitiesMap := docType  entities.
	entity := entitiesMap  getNamedItem:'ent5'.
	self assert: entityVersion isNil.

!

test_entitygetxmlversion03
	"
    Check that the value of Entity.xmlVersion on an external entity without
    a version declaration is null.

		Creator: IBM
		Autor Neil Delima
		Autor Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Entity3-version
		Subject http://lists.w3.org/Archives/Public/www-dom-ts/2003Dec/0045.html
	"
	|
	  doc "Document"
	  docType "DocumentType"
	  entitiesMap "NamedNodeMap"
	  entity "Entity"
	  entityVersion "String"
	|
	^self. "Validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'external_barfoo').
	docType := doc  doctype.
	entitiesMap := docType  entities.
	entity := entitiesMap  getNamedItem:'ent2'.
	self assert: entityVersion isNil.

!

test_entitygetxmlversion04
	"
    Check that the value of Entity.xmlVersion on an external entity with
    a version declaration is  1.0 .

		Creator: IBM
		Autor Neil Delima
		Autor Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Entity3-version
		Subject http://lists.w3.org/Archives/Public/www-dom-ts/2003Dec/0045.html
	"
	|
	  doc "Document"
	  docType "DocumentType"
	  entitiesMap "NamedNodeMap"
	  entity "Entity"
	  entityVersion "String"
	|
	^self. "Validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'external_barfoo').
	docType := doc  doctype.
	entitiesMap := docType  entities.
	entity := entitiesMap  getNamedItem:'ent1'.
	self assert: ( entityVersion = '1.0' ).

!

test_handleerror01
	"
Add two CDATASection containing  ]]>  and call Node.normalize
with an error handler that stops processing.  Only one of the
CDATASections should be split.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-normalize
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-split-cdata-sections
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-ERRORS-DOMErrorHandler-handleError
	"
	|
	  doc "Document"
	  elem "Element"
	  domConfig "DOMConfiguration"
	  elemList "NodeList"
	  newChild "CDATASection"
	  oldChild "Node"
	  child "Node"
	  childValue "String"
	  childType "SmallInteger"
	  retval "Node"
	  errors "List"
	  errorHandler "DOMErrorHandler"
	|
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	elemList := doc  getElementsByTagName: 'p'.
	elem := elemList  item:0.
	oldChild := elem  firstChild.
	newChild := doc  createCDATASection:'this is not ]]> good'.
	elem  replaceChild:oldChild with: newChild.
	newChild := doc  createCDATASection:'this is not ]]> bad'.
	retval := elem  appendChild:newChild.
	domConfig := doc domConfig.
	domConfig setParameter: 'split-cdata-sections' value: true.
	domConfig setParameter: 'error-handler' value: errorHandler.
	doc  normalizeDocument.
	elemList := doc  getElementsByTagName: 'p'.
	elem := elemList  item:0.
	child := elem  lastChild.
	childValue := child  nodeValue.
	"if"
	( childValue = 'this is not ]]> bad' ) ifTrue: [
						].

!

test_handleerror02
	"
Normalize document with two DOM L1 nodes.
Use an error handler to continue from errors and check that more than one
error was reported.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-normalizeDocument
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-namespaces
		Subject http://www.w3.org/TR/2003/WD-charmod-20030822/
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-ERRORS-DOMErrorHandler-handleError
	"
	|
	  doc "Document"
	  docElem "Element"
	  domConfig "DOMConfiguration"
	  pList "NodeList"
	  pElem "Element"
	  text "Text"
	  textValue "String"
	  retval "Node"
	  brElem "Element"
	  errors "List"
	  errorHandler "DOMErrorHandler"
	|
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	domConfig := doc domConfig.
	domConfig setParameter: 'error-handler' value: errorHandler.
	pList := doc  getElementsByTagName: 'p'.
	pElem := pList  item:0.
	brElem := doc  createElement:'br'.
	retval := pElem  appendChild:brElem.
	brElem := doc  createElement:'br'.
	retval := pElem  appendChild:brElem.
	doc  normalizeDocument.
	self assert: errors size = 2.

!

test_hasFeature01
	"
DOMImplementation.hasFeature( XML ,  3.0 ) should return true.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-5CED94D7
	"
	|
	  impl "DOMImplementation"
	  state "Boolean"
	|
	impl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	state := impl  hasFeature:'xMl' version:'3.0'.
	self assert: state.

!

test_hasFeature02
	"
DOMImplementation.hasFeature( XML ,  3.0 ) should return true.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-5CED94D7
	"
	|
	  impl "DOMImplementation"
	  state "Boolean"
	|
	impl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	state := impl  hasFeature:'cOrE' version:'3.0'.
	self assert: state.

!

test_hasFeature03
	"
DOMImplementation.hasFeature( XML ,  3.0 ) should return true.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-5CED94D7
	"
	|
	  impl "DOMImplementation"
	  state "Boolean"
	|
	impl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	state := impl  hasFeature:'+cOrE' version:'3.0'.
	self assert: state.

!

test_hasFeature04
	"
DOMImplementation.hasFeature( XML ,  3.0 ) should return true.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-5CED94D7
	"
	|
	  impl "DOMImplementation"
	  state "Boolean"
	|
	impl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	state := impl  hasFeature:'+xMl' version:'3.0'.
	self assert: state.

!

test_infoset01
	"
Normalize document with infoset set to true, check that
entity references are expanded and unused entity declaration are maintained.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-normalizeDocument
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-infoset
	"
	|
	  doc "Document"
	  pList "NodeList"
	  pElem "Element"
	  domConfig "DOMConfiguration"
	  canSet "Boolean"
	  canSetValidate "Boolean"
	  errorMonitor "DOMErrorMonitor"
	  child "Node"
	  childName "String"
	  entRef "EntityReference"
	  childValue "String"
	  entities "NamedNodeMap"
	  ent2 "Entity"
	  doctype "DocumentType"
	|
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	domConfig := doc domConfig.
	domConfig setParameter: 'infoset' value: true.
	domConfig setParameter: 'error-handler' value: errorMonitor.
	pList := doc  getElementsByTagName: 'p'.
	pElem := pList  item:0.
	entRef := doc  createEntityReference:'ent1'.
	child := pElem  appendChild:entRef.
	doc  normalizeDocument.
	errorMonitor  assertLowerSeverityFor: self message:'normalizeError' severity: DOMErrorMonitor SEVERITY_ERROR.
	pList := doc  getElementsByTagName: 'p'.
	pElem := pList  item:0.
	child := pElem  lastChild.
	self assert: child notNil.
	childName := child  nodeName.
	self assert: ( childName = '#text' ).
	childValue := child  nodeValue.
	self assert: ( childValue = 'barfoo' ).
	doctype := doc  doctype.
	entities := doctype  entities.
	ent2 := entities  getNamedItem:'ent2'.
	self assert: ent2 notNil.

!

test_infoset02
	"
Normalize document with infoset set to true, check that
unbound entity references are preserved.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-normalizeDocument
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-infoset
	"
	|
	  doc "Document"
	  pList "NodeList"
	  pElem "Element"
	  domConfig "DOMConfiguration"
	  canSet "Boolean"
	  canSetValidate "Boolean"
	  errorMonitor "DOMErrorMonitor"
	  child "Node"
	  childName "String"
	  entRef "EntityReference"
	  childType "SmallInteger"
	|
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	domConfig := doc domConfig.
	domConfig setParameter: 'infoset' value: true.
	domConfig setParameter: 'error-handler' value: errorMonitor.
	pList := doc  getElementsByTagName: 'p'.
	pElem := pList  item:0.
	entRef := doc  createEntityReference:'ent3'.
	child := pElem  appendChild:entRef.
	doc  normalizeDocument.
	errorMonitor  assertLowerSeverityFor: self message:'normalizeError' severity: DOMErrorMonitor SEVERITY_ERROR.
	pList := doc  getElementsByTagName: 'p'.
	pElem := pList  item:0.
	child := pElem  lastChild.
	self assert: child notNil.
	childType := child  nodeType.
	self assert: ( childType = 5 ).
	childName := child  nodeName.
	self assert: ( childName = 'ent3' ).

!

test_infoset03
	"
Normalize document with infoset set to true,  
check if string values were not normalized.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-normalizeDocument
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-infoset
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  element "Element"
	  domConfig "DOMConfiguration"
	  str "String"
	  canSetValidate "Boolean"
	  canSetXMLSchema "Boolean"
	  xsdNS "String"
	  errorMonitor "DOMErrorMonitor"
	  childNode "Node"
	  childValue "String"
	  childLength "SmallInteger"
	|
	"implementationAttribute not supported: namespaceAware"
	xsdNS := 'http://www.w3.org/2001/XMLSchema'.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'datatype_normalization2').
	domConfig := doc domConfig.
	canSetValidate := domConfig canSetParameter: 'validate' value: true.
	canSetXMLSchema := domConfig canSetParameter: 'schema-type' value: xsdNS.
	"if"
	(canSetValidate) and: [(canSetXMLSchema)] ifTrue: [
																					].

!

test_infoset04
	"
Normalize a document with a created CDATA section with the 
'infoset' to true and check if
the CDATASection has been coalesced.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-normalizeDocument
		Subject http://www.w3.org/Bugs/Public/show_bug.cgi?id=416
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-infoset
	"
	|
	  doc "Document"
	  elem "Element"
	  newCdata "CDATASection"
	  cdata "CDATASection"
	  text "Node"
	  nodeName "String"
	  nodeValue "String"
	  appendedChild "Node"
	  domConfig "DOMConfiguration"
	  pList "NodeList"
	  errorMonitor "DOMErrorMonitor"
	|
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	pList := doc  getElementsByTagName: 'p'.
	elem := pList  item:0.
	newCdata := doc  createCDATASection:'CDATA'.
	appendedChild := elem  appendChild:newCdata.
	domConfig := doc domConfig.
	domConfig setParameter: 'infoset' value: true.
	domConfig setParameter: 'error-handler' value: errorMonitor.
	doc  normalizeDocument.
	errorMonitor  assertLowerSeverityFor: self message:'normalization2Error' severity: DOMErrorMonitor SEVERITY_ERROR.
	pList := doc  getElementsByTagName: 'p'.
	elem := pList  item:0.
	text := elem  lastChild.
	nodeName := text  nodeName.
	self assert: ( nodeName = '#text' ).
	nodeValue := text  nodeValue.
	self assert: ( nodeValue = 'barCDATA' ).

!

test_infoset05
	"
Normalize document with infoset set to true, check that
namespace declaration attributes are maintained.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-normalizeDocument
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-infoset
	"
	|
	  doc "Document"
	  docElem "Element"
	  domConfig "DOMConfiguration"
	  errorMonitor "DOMErrorMonitor"
	  xmlnsAttr "Attr"
	|
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	domConfig := doc domConfig.
	domConfig setParameter: 'infoset' value: true.
	domConfig setParameter: 'error-handler' value: errorMonitor.
	doc  normalizeDocument.
	errorMonitor  assertLowerSeverityFor: self message:'normalizeError' severity: DOMErrorMonitor SEVERITY_ERROR.
	docElem := doc  documentElement.
	xmlnsAttr := docElem  getAttributeNode:'xmlns'.
	self assert: xmlnsAttr notNil.

!

test_infoset06
	"
Create a document with an XML 1.1 valid but XML 1.0 invalid element and
normalize document with infoset set to true.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-normalizeDocument
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-infoset
	"
	|
	  domImpl "DOMImplementation"
	  nullString "String"
	  nullDoctype "DocumentType"
	  doc "Document"
	  elem "Element"
	  retval "Node"
	  domConfig "DOMConfiguration"
	  errorMonitor "DOMErrorMonitor"
	  errors "List"
	  error "DOMError"
	  severity "SmallInteger"
	  type "String"
	  locator "DOMLocator"
	  relatedNode "Node"
	|
	nullString := nil.
	nullDoctype := nil.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	doc := domImpl createDocumentNS: nullString qualifiedName: nullString doctype: nullDoctype.
	"assertDOMException..."
	self should:[
	elem := doc  createElement:'LegalNameࢎ' ns:'http://www.example.org/domts/wellformed01'.
	] raise: DOMException.
	self assert: (lastException code == DOMException INVALID_CHARACTER_ERR).
	"end of assertDOMException..."
	"try"
	[
	] on: DOMException do: [:ex|	].
	"end of try"
	elem := doc  createElement:'LegalNameࢎ' ns:'http://www.example.org/domts/wellformed01'.
	retval := doc  appendChild:elem.
	domConfig := doc domConfig.
	domConfig setParameter: 'infoset' value: true.
	domConfig setParameter: 'error-handler' value: errorMonitor.
	doc  normalizeDocument.
	errors := errorMonitor  errors.
errors do: [:error|
	severity := error  severity.
	self assert: ( severity = 2 ).
	type := error  type.
	self assert: ( type = 'wf-invalid-character-in-node-name' ).
	locator := error  location.
	relatedNode := locator  relatedNode.
	self assert: relatedNode == elem.
].
	self assert: errors size = 1.

!

test_infoset07
	"
Create a document with an XML 1.1 valid but XML 1.0 invalid attribute and
normalize document with infoset set to true.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-normalizeDocument
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-infoset
	"
	|
	  domImpl "DOMImplementation"
	  nullDoctype "DocumentType"
	  doc "Document"
	  docElem "Element"
	  attr "Attr"
	  retval "Node"
	  domConfig "DOMConfiguration"
	  errorMonitor "DOMErrorMonitor"
	  errors "List"
	  error "DOMError"
	  severity "SmallInteger"
	  type "String"
	  locator "DOMLocator"
	  relatedNode "Node"
	|
	nullDoctype := nil.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	doc := domImpl createDocumentNS: 'http://www.w3.org/1999/xhtml' qualifiedName: 'html' doctype: nullDoctype.
	docElem := doc  documentElement.
	"assertDOMException..."
	self should:[
	attr := doc  createAttribute:'LegalNameࢎ'.
	] raise: DOMException.
	self assert: (lastException code == DOMException INVALID_CHARACTER_ERR).
	"end of assertDOMException..."
	"try"
	[
	] on: DOMException do: [:ex|	].
	"end of try"
	docElem  setAttribute:'LegalNameࢎ' value:'foo'.
	attr := docElem  getAttributeNode:'LegalNameࢎ'.
	domConfig := doc domConfig.
	domConfig setParameter: 'infoset' value: true.
	domConfig setParameter: 'error-handler' value: errorMonitor.
	doc  normalizeDocument.
	errors := errorMonitor  errors.
errors do: [:error|
	severity := error  severity.
	self assert: ( severity = 2 ).
	type := error  type.
	self assert: ( type = 'wf-invalid-character-in-node-name' ).
	locator := error  location.
	relatedNode := locator  relatedNode.
	self assert: relatedNode == attr.
].
	self assert: errors size = 1.

!

test_infoset08
	"
Normalize document with infoset and validation set to true, check that
whitespace in element content is preserved.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-normalizeDocument
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-infoset
	"
	|
	  doc "Document"
	  bodyList "NodeList"
	  body "Element"
	  domConfig "DOMConfiguration"
	  canSet "Boolean"
	  canSetValidate "Boolean"
	  errorMonitor "DOMErrorMonitor"
	  child "Node"
	  childName "String"
	  text "Text"
	|
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	domConfig := doc domConfig.
	domConfig setParameter: 'infoset' value: true.
	domConfig setParameter: 'error-handler' value: errorMonitor.
	"if"
	false "no template for element implementationAttribute"  ifTrue: [
						].
	doc  normalizeDocument.
	errorMonitor  assertLowerSeverityFor: self message:'normalizeError' severity: DOMErrorMonitor SEVERITY_ERROR.
	bodyList := doc  getElementsByTagName: 'body'.
	body := bodyList  item:0.
	child := body  firstChild.
	self assert: child notNil.
	childName := child  nodeName.
	self assert: ( childName = '#text' ).
	child := child  nextSibling.
	self assert: child notNil.
	childName := child  nodeName.
	self assert: ( childName = 'p' ).

!

test_infoset09
	"
	Append a Comment node and normalize with  infoset  set to true.

		Creator: Curt Arnold
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-normalizeDocument
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-infoset
	"
	|
	  doc "Document"
	  elem "Element"
	  newComment "Comment"
	  lastChild "Node"
	  text "Text"
	  nodeName "String"
	  appendedChild "Node"
	  domConfig "DOMConfiguration"
	  errorMonitor "DOMErrorMonitor"
	  pList "NodeList"
	|
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	pList := doc  getElementsByTagName: 'p'.
	elem := pList  item:0.
	newComment := doc  createComment:'COMMENT_NODE'.
	appendedChild := elem  appendChild:newComment.
	domConfig := doc domConfig.
	domConfig setParameter: 'comments' value: false.
	domConfig setParameter: 'infoset' value: true.
	domConfig setParameter: 'error-handler' value: errorMonitor.
	doc  normalizeDocument.
	errorMonitor  assertLowerSeverityFor: self message:'normalizationError' severity: DOMErrorMonitor SEVERITY_ERROR.
	pList := doc  getElementsByTagName: 'p'.
	elem := pList  item:0.
	lastChild := elem  lastChild.
	nodeName := lastChild  nodeName.
	self assert: ( nodeName = '#comment' ).

!

test_namespacedeclarations01
	"
Normalize document with namespace-declarations set to true, check that
namespace declaration attributes are maintained.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-normalizeDocument
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-namespace-declarations
	"
	|
	  doc "Document"
	  docElem "Element"
	  domConfig "DOMConfiguration"
	  errorMonitor "DOMErrorMonitor"
	  xmlnsAttr "Attr"
	|
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	domConfig := doc domConfig.
	domConfig setParameter: 'namespace-declarations' value: true.
	domConfig setParameter: 'error-handler' value: errorMonitor.
	doc  normalizeDocument.
	errorMonitor  assertLowerSeverityFor: self message:'normalizeError' severity: DOMErrorMonitor SEVERITY_ERROR.
	docElem := doc  documentElement.
	xmlnsAttr := docElem  getAttributeNode:'xmlns'.
	self assert: xmlnsAttr notNil.

!

test_namespacedeclarations02
	"
Normalize document with namespace-declarations set to true, check that
namespace declaration attributes are maintained.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-normalizeDocument
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-namespace-declarations
	"
	|
	  doc "Document"
	  docElem "Element"
	  domConfig "DOMConfiguration"
	  errorMonitor "DOMErrorMonitor"
	  xmlnsAttr "Attr"
	|
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	domConfig := doc domConfig.
	domConfig setParameter: 'namespace-declarations' value: false.
	domConfig setParameter: 'error-handler' value: errorMonitor.
	doc  normalizeDocument.
	errorMonitor  assertLowerSeverityFor: self message:'normalizeError' severity: DOMErrorMonitor SEVERITY_ERROR.
	docElem := doc  documentElement.
	xmlnsAttr := docElem  getAttributeNode:'xmlns'.
	self assert: xmlnsAttr isNil.

!

test_nodeappendchild01
	"
An attempt to add a second doctype node should result in a HIERARCHY_REQUEST_ERR
or a NOT_SUPPORTED_ERR.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-184E7107
	"
	|
	  doc "Document"
	  domImpl "DOMImplementation"
	  docType "DocumentType"
	  nullPubId "String"
	  nullSysId "String"
	  appendedChild "Node"
	  tagName "String"
	  docElem "Element"
	|
	nullPubId := nil.
	nullSysId := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	docElem := doc  documentElement.
	tagName := docElem  tagName.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	docType := domImpl  createDocumentType:tagName publicId:nullPubId systemId:nullSysId.
	"try"
	[
	appendedChild := doc  appendChild:docType.
self assert:false.	] on: DOMException do: [:ex|	].
	"end of try"

!

test_nodeappendchild02
	"
An attempt to add a second document element should result in a HIERARCHY_REQUEST_ERR
or a NOT_SUPPORTED_ERR.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-184E7107
	"
	|
	  doc "Document"
	  newElem "Element"
	  appendedChild "Node"
	  tagName "String"
	  rootNS "String"
	  docElem "Element"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	docElem := doc  documentElement.
	tagName := docElem  tagName.
	rootNS := docElem  namespaceURI.
	newElem := doc  createElement:tagName ns:rootNS.
	"try"
	[
	appendedChild := doc  appendChild:newElem.
self assert:false.	] on: DOMException do: [:ex|	].
	"end of try"

!

test_nodecomparedocumentposition01
	"


	
	Using compareDocumentPosition to check if a Document node contains and precedes its documentType and
	node and if the DocumentTypeNode is contained and follows its Document node.

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-compareDocumentPosition
	"
	|
	  doc "Document"
	  docType "DocumentType"
	  documentPositionDoc "SmallInteger"
	  documentPositionDocType "SmallInteger"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docType := doc  doctype.
	documentPositionDoc := doc  compareDocumentPosition:docType.
	self assert: ( documentPositionDoc = 20 ).
	documentPositionDocType := docType  compareDocumentPosition:doc.
	self assert: ( documentPositionDocType = 10 ).

!

test_nodecomparedocumentposition02
	"
	Using compareDocumentPosition to check if a Document node contains and precedes its new DocumentType and
	node and if the new DocumentType Node is contained and follows its Document node.

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-compareDocumentPosition
	"
	|
	  doc "Document"
	  domImpl "DOMImplementation"
	  newDocType "DocumentType"
	  docType "DocumentType"
	  documentPositionDoc "SmallInteger"
	  documentPositionDocType "SmallInteger"
	  nullPubId "String"
	  nullSysId "String"
	  replaced "Node"
	  rootName "String"
	|
	nullPubId := nil.
	nullSysId := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docType := doc  doctype.
	rootName := docType  name.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	newDocType := domImpl  createDocumentType:rootName publicId:nullPubId systemId:nullSysId.
	doc  replaceChild:docType with: newDocType.
	documentPositionDoc := doc  compareDocumentPosition:newDocType.
	self assert: ( documentPositionDoc = 20 ).
	documentPositionDocType := newDocType  compareDocumentPosition:doc.
	self assert: ( documentPositionDocType = 10 ).

!

test_nodecomparedocumentposition03
	"
	Using compareDocumentPosition check if the document position of two Document nodes obtained from the 
	same xml document is disconnected, implementation specific, and that the order of these two documents
	is reserved.

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-compareDocumentPosition
	"
	|
	  doc "Document"
	  docComp "Document"
	  documentPosition1 "SmallInteger"
	  documentPosition2 "SmallInteger"
	  documentPosition3 "SmallInteger"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docComp :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	documentPosition1 := doc  compareDocumentPosition:docComp.
	self assert: ( documentPosition1 = 33 ).
	documentPosition2 := docComp  compareDocumentPosition:doc.
	self assert: (documentPosition2 bitAnd: 2) == (documentPosition1 bitAnd: 2).
	self assert: (documentPosition2 bitAnd: 4) == (documentPosition1 bitAnd: 4).
	self assert: ( documentPosition2 = 33 ).
	documentPosition3 := doc  compareDocumentPosition:docComp.
	self assert: ( documentPosition3 = documentPosition1 ).

!

test_nodecomparedocumentposition04
	"	
	Using compareDocumentPosition to check that no flags are set in return when the document position of a 
	Document node is compared with itself

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-compareDocumentPosition
	"
	|
	  doc "Document"
	  documentPosition "SmallInteger"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	documentPosition := doc  compareDocumentPosition:doc.
	self assert: ( documentPosition = 0 ).

!

test_nodecomparedocumentposition05
	"
	Using compareDocumentPosition check if the document position of a Document and a new Document node
	are disconnected, implementation-specific and preceding/following.

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-compareDocumentPosition
	"
	|
	  doc "Document"
	  newDoc "Document"
	  domImpl "DOMImplementation"
	  documentPosition1 "SmallInteger"
	  documentPosition2 "SmallInteger"
	  documentPosition3 "SmallInteger"
	  nullDocType "DocumentType"
	  rootName "String"
	  rootNS "String"
	  docElem "Element"
	|
	nullDocType := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	docElem := doc  documentElement.
	rootName := docElem  tagName.
	rootNS := docElem  namespaceURI.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	newDoc := domImpl createDocumentNS: rootNS qualifiedName: rootName doctype: nullDocType.
	documentPosition1 := doc  compareDocumentPosition:newDoc.
	self assert: ( documentPosition1 = 33 ).
	documentPosition2 := newDoc  compareDocumentPosition:doc.
	self assert: ( documentPosition2 = 33 ).
	self assert: (documentPosition2 bitAnd: 2) == (documentPosition1 bitAnd: 2).
	self assert: (documentPosition2 bitAnd: 4) == (documentPosition1 bitAnd: 4).
	documentPosition3 := doc  compareDocumentPosition:newDoc.
	self assert: ( documentPosition3 = documentPosition1 ).

!

test_nodecomparedocumentposition06
	"


	
	Using compareDocumentPosition check if the document position of a Document node contains and precedes 
	its DocumentElement, and the DocumentElement is contained and follows the Document node.

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-compareDocumentPosition
	"
	|
	  doc "Document"
	  docElem "Element"
	  documentPositionDoc "SmallInteger"
	  documentPositionDocElem "SmallInteger"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docElem := doc  documentElement.
	documentPositionDoc := doc  compareDocumentPosition:docElem.
	self assert: ( documentPositionDoc = 20 ).
	documentPositionDocElem := docElem  compareDocumentPosition:doc.
	self assert: ( documentPositionDocElem = 10 ).

!

test_nodecomparedocumentposition07
	"
	Using compareDocumentPosition check if the document compared contains and precedes the new
	newElement, and the newElement is contained and follows the document.

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-compareDocumentPosition
	"
	|
	  doc "Document"
	  docElem "Element"
	  newElem "Element"
	  documentPosition "SmallInteger"
	  documentElementPosition "SmallInteger"
	  appendedChild "Node"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docElem := doc  documentElement.
	newElem := doc  createElement:'br' ns:'http://www.w3.org/1999/xhtml'.
	appendedChild := docElem  appendChild:newElem.
	documentPosition := doc  compareDocumentPosition:newElem.
	self assert: ( documentPosition = 20 ).
	documentElementPosition := newElem  compareDocumentPosition:doc.
	self assert: ( documentElementPosition = 10 ).

!

test_nodecomparedocumentposition08
	"
	Using compareDocumentPosition check if the Document node contains and precedes an Element,
	and the Element is contained and follows the Document node.

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-compareDocumentPosition
	"
	|
	  doc "Document"
	  elem "Element"
	  elemList "NodeList"
	  documentPosition "SmallInteger"
	  elementPosition "SmallInteger"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'p'.
	elem := elemList  item:3.
	documentPosition := doc  compareDocumentPosition:elem.
	self assert: ( documentPosition = 20 ).
	elementPosition := elem  compareDocumentPosition:doc.
	self assert: ( elementPosition = 10 ).

!

test_nodecomparedocumentposition09
	"
	Using compareDocumentPosition check if the Element node is contained and follows the appended Document node, and
	if the Document node contains and precedes the Element node.

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-compareDocumentPosition
	"
	|
	  doc "Document"
	  elem "Element"
	  newElem "Element"
	  elemList "NodeList"
	  documentPosition "SmallInteger"
	  documentElementPosition "SmallInteger"
	  appendedChild "Node"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'p'.
	elem := elemList  item:3.
	newElem := doc  createElement:'br' ns:'http://www.w3.org/1999/xhtml'.
	appendedChild := elem  appendChild:newElem.
	documentPosition := doc  compareDocumentPosition:newElem.
	self assert: ( documentPosition = 20 ).
	documentElementPosition := newElem  compareDocumentPosition:doc.
	self assert: ( documentElementPosition = 10 ).

!

test_nodecomparedocumentposition10
	"
	Using compareDocumentPosition check if the document node precedes and contains its default Attr node.

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-compareDocumentPosition
	"
	|
	  doc "Document"
	  elem "Element"
	  dir "Attr"
	  elemList "NodeList"
	  attrPosition "SmallInteger"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'p'.
	elem := elemList  item:3.
	dir := elem  getAttributeNode:'dir'.
	attrPosition := dir  compareDocumentPosition:doc.
	self assert: ( attrPosition = 10 ).

!

test_nodecomparedocumentposition11
	"
	Using compareDocumentPosition check if the Document node precedes and contains the Attr node.

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-compareDocumentPosition
	"
	|
	  doc "Document"
	  elem "Element"
	  newAttr "Attr"
	  elemList "NodeList"
	  documentPosition "SmallInteger"
	  attrPosition "SmallInteger"
	  replacedAttr "Attr"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'p'.
	elem := elemList  item:3.
	newAttr := doc  createAttribute:'xml:lang' ns:'http://www.w3.org/XML/1998/namespace'.
	replacedAttr := elem  setAttributeNodeNS: newAttr.
	attrPosition := newAttr  compareDocumentPosition:doc.
	self assert: ( attrPosition = 10 ).

!

test_nodecomparedocumentposition12
	"
	Using compareDocumentPosition to check if a new ProcessingInstruction node is contained and follows the
	Document node, and that the Document node contains and precedes the ProcessingInstruction node.

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-compareDocumentPosition
	"
	|
	  doc "Document"
	  pi "ProcessingInstruction"
	  documentPosition "SmallInteger"
	  piPosition "SmallInteger"
	  appendedChild "Node"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	pi := doc  createProcessingInstruction:'PITarget' data:'PIDATA'.
	appendedChild := doc  appendChild:pi.
	documentPosition := doc  compareDocumentPosition:pi.
	self assert: ( documentPosition = 20 ).
	piPosition := pi  compareDocumentPosition:doc.
	self assert: ( piPosition = 10 ).

!

test_nodecomparedocumentposition13
	"
	Using compareDocumentPosition check if the Document node contains and precedes the new Comment node, 
	and if the Comment node is contained and follows the Document node.

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-compareDocumentPosition
	"
	|
	  doc "Document"
	  comment "Comment"
	  elem "Element"
	  elemList "NodeList"
	  documentPosition "SmallInteger"
	  commentPosition "SmallInteger"
	  appendedChild "Node"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	comment := doc  createComment:'Another Comment'.
	elemList := doc  getElementsByTagName: 'p'.
	elem := elemList  item:3.
	appendedChild := elem  appendChild:comment.
	documentPosition := doc  compareDocumentPosition:comment.
	self assert: ( documentPosition = 20 ).
	commentPosition := comment  compareDocumentPosition:doc.
	self assert: ( commentPosition = 10 ).

!

test_nodecomparedocumentposition14
	"
	Using compareDocumentPosition check if the DocumentFragment node contains and precedes 	an Element 
	node appended to it, and that the Element node is contained and follows the DocumentFragment node.

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-compareDocumentPosition
	"
	|
	  doc "Document"
	  docFrag "DocumentFragment"
	  docElem "Element"
	  docFragChild "Node"
	  docFragPosition "SmallInteger"
	  docFragChildPosition "SmallInteger"
	  appendedChild "Node"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docElem := doc  documentElement.
	docFrag := doc  createDocumentFragment.
	appendedChild := docFrag  appendChild:docElem.
	docFragChild := docFrag  firstChild.
	docFragPosition := docFrag  compareDocumentPosition:docFragChild.
	self assert: ( docFragPosition = 20 ).
	docFragChildPosition := docFragChild  compareDocumentPosition:docFrag.
	self assert: ( docFragChildPosition = 10 ).

!

test_nodecomparedocumentposition15
	"
	Using compareDocumentPosition check if the Element node precedes and contains its Attr child, and that the Attr child
	is contained and follows the Element node.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-compareDocumentPosition
	"
	|
	  doc "Document"
	  docFrag "DocumentFragment"
	  docElem "Element"
	  attr "Attr"
	  docFragChild "Node"
	  attrPosition "SmallInteger"
	  docFragChildPosition "SmallInteger"
	  appendedChild "Node"
	  attrNode "Node"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docElem := doc  documentElement.
	docFrag := doc  createDocumentFragment.
	attr := doc  createAttribute:'xml:lang' ns:'http://www.w3.org/XML/1998/namespace'.
	attrNode := docElem  setAttributeNodeNS: attr.
	appendedChild := docFrag  appendChild:docElem.
	docFragChild := docFrag  firstChild.
	docFragChildPosition := docFragChild  compareDocumentPosition:attr.
	self assert: ( docFragChildPosition = 20 ).
	attrPosition := attr  compareDocumentPosition:docFragChild.
	self assert: ( attrPosition = 10 ).

!

test_nodecomparedocumentposition16
	"
	Using compareDocumentPosition check if the document position of a DocumentFragment node compared with
	a cloned Attr node is disconnected and implementation specific, and that the order between these two
	nodes is preserved.

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-compareDocumentPosition
	"
	|
	  doc "Document"
	  docFrag "DocumentFragment"
	  attr "Attr"
	  attrCloned "Attr"
	  docFragPosition "SmallInteger"
	  position1 "SmallInteger"
	  position2 "SmallInteger"
	  position3 "SmallInteger"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docFrag := doc  createDocumentFragment.
	attr := doc  createAttribute:'xml:lang' ns:'http://www.w3.org/XML/1998/namespace'.
	attrCloned := attr  cloneNode:true.
	position1 := docFrag  compareDocumentPosition:attrCloned.
	self assert: ( position1 = 33 ).
	position2 := attrCloned  compareDocumentPosition:docFrag.
	self assert: (position2 bitAnd: 2) == (position1 bitAnd: 2).
	self assert: (position2 bitAnd: 4) == (position1 bitAnd: 4).
	self assert: ( position2 = 33 ).
	position3 := docFrag  compareDocumentPosition:attrCloned.
	self assert: ( position3 = position1 ).

!

test_nodecomparedocumentposition17
	"
	Using compareDocumentPosition check if the document position of the first ProcessingInstruction node compared to 
	this second newly apended ProcessingInstruction node is PRECEDING, and FOLLOWING vice versa.

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-compareDocumentPosition
	"
	|
	  doc "Document"
	  pi1 "ProcessingInstruction"
	  pi2 "ProcessingInstruction"
	  pi1Position "SmallInteger"
	  pi2Position "SmallInteger"
	  appendedChild "Node"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	pi1 := doc  createProcessingInstruction:'PI1' data:''.
	pi2 := doc  createProcessingInstruction:'PI2' data:''.
	appendedChild := doc  appendChild:pi1.
	appendedChild := doc  appendChild:pi2.
	pi1Position := pi1  compareDocumentPosition:pi2.
	self assert: ( pi1Position = 4 ).
	pi2Position := pi2  compareDocumentPosition:pi1.
	self assert: ( pi2Position = 2 ).

!

test_nodecomparedocumentposition18
	"
	Using compareDocumentPosition check if the document position of the first new Text node compared to the
	second text node is PRECEDING and is FOLLOWING vice versa.

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-compareDocumentPosition
	"
	|
	  doc "Document"
	  docElem "Element"
	  txt1 "Text"
	  txt2 "Text"
	  txt1Position "SmallInteger"
	  txt2Position "SmallInteger"
	  appendedChild "Node"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docElem := doc  documentElement.
	txt1 := doc  createTextNode:'T1'.
	txt2 := doc  createTextNode:'T2'.
	appendedChild := docElem  appendChild:txt1.
	appendedChild := docElem  appendChild:txt2.
	txt1Position := txt1  compareDocumentPosition:txt2.
	self assert: ( txt1Position = 4 ).
	txt2Position := txt2  compareDocumentPosition:txt1.
	self assert: ( txt2Position = 2 ).

!

test_nodecomparedocumentposition19
	"
	The method compareDocumentPosition compares a node with this node with regard to their position in the 
	document and according to the document order.
	
	Using compareDocumentPosition check if the document position of the first CDATASection node
	of the second element whose localName is name compared with the second CDATASection node
	is PRECEDING and is FOLLOWING vice versa.

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-compareDocumentPosition
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  elemStrong "Element"
	  cdata1 "CDATASection"
	  cdata2 "CDATASection"
	  aNode "Node"
	  cdata1Position "SmallInteger"
	  cdata2Position "SmallInteger"
	|
	"implementationAttribute not supported: coalescing"
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'strong' ns: '*'.
	elemStrong := elemList  item:1.
	cdata2 := elemStrong  lastChild.
	aNode := cdata2  previousSibling.
	cdata1 := aNode  previousSibling.
	cdata1Position := cdata1  compareDocumentPosition:cdata2.
	self assert: ( cdata1Position = 4 ).
	cdata2Position := cdata2  compareDocumentPosition:cdata1.
	self assert: ( cdata2Position = 2 ).

!

test_nodecomparedocumentposition20
	"
	Using compareDocumentPosition check if the document position of the first Text node
	of the second element whose localName is name compared with the next CDATASection node
	is PRECEDING and FOLLOWING vice versa.

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-compareDocumentPosition
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  elemName "Element"
	  cdata "CDATASection"
	  txt "Text"
	  txtPosition "SmallInteger"
	  cdataPosition "SmallInteger"
	|
	"implementationAttribute not supported: coalescing"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'strong'.
	elemName := elemList  item:1.
	txt := elemName  firstChild.
	cdata := elemName  lastChild.
	txtPosition := txt  compareDocumentPosition:cdata.
	self assert: ( txtPosition = 4 ).
	cdataPosition := cdata  compareDocumentPosition:txt.
	self assert: ( cdataPosition = 2 ).

!

test_nodecomparedocumentposition21
	"
	Using compareDocumentPosition check the document position of the text node of the fist and second elements 
	whose localName is name.  The first text node should return FOLLOWING and the second text node should
	return PRECEDING when compareDocumentPosition is invoked with the other node as a parameter. 
	

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-compareDocumentPosition
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  elemName1 "Element"
	  elemName2 "Element"
	  txt1 "Text"
	  txt2 "Text"
	  txt1Position "SmallInteger"
	  txt2Position "SmallInteger"
	|
	"implementationAttribute not supported: coalescing"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'strong'.
	elemName1 := elemList  item:0.
	elemName2 := elemList  item:1.
	txt1 := elemName1  firstChild.
	txt2 := elemName2  firstChild.
	txt1Position := txt1  compareDocumentPosition:txt2.
	self assert: ( txt1Position = 4 ).
	txt2Position := txt2  compareDocumentPosition:txt1.
	self assert: ( txt2Position = 2 ).

!

test_nodecomparedocumentposition22
	"
	Using compareDocumentPosition check if the Entity node precedes the Notation node and the Notation
	node follows the Entity node.

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-compareDocumentPosition
	"
	|
	  doc "Document"
	  docType "DocumentType"
	  entitiesMap "NamedNodeMap"
	  notationsMap "NamedNodeMap"
	  entity "Entity"
	  notation "Notation"
	  entityPosition "SmallInteger"
	  notationPosition "SmallInteger"
	|
	"implementationAttribute not supported: coalescing"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docType := doc  doctype.
	entitiesMap := docType  entities.
	notationsMap := docType  notations.
	entity := entitiesMap  getNamedItem:'alpha'.
	notation := notationsMap  getNamedItem:'notation1'.
	entityPosition := entity  compareDocumentPosition:notation.
	self assert: ( entityPosition = 4 ).
	notationPosition := notation  compareDocumentPosition:entity.
	self assert: ( notationPosition = 2 ).

!

test_nodecomparedocumentposition23
	"
	Using compareDocumentPosition check if the document position of an Entity node compared to another
	Entity node following it in DocumentType is implementation specific.

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-compareDocumentPosition
	"
	|
	  doc "Document"
	  docType "DocumentType"
	  entitiesMap "NamedNodeMap"
	  entity "Entity"
	  entity2 "Entity"
	  position1 "SmallInteger"
	  position2 "SmallInteger"
	  position3 "SmallInteger"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docType := doc  doctype.
	entitiesMap := docType  entities.
	entity := entitiesMap  getNamedItem:'alpha'.
	entity2 := entitiesMap  getNamedItem:'delta'.
	position1 := entity  compareDocumentPosition:entity2.
	self assert: ( position1 = 32 ).
	position2 := entity2  compareDocumentPosition:entity.
	self assert: (position2 bitAnd: 2) == (position1 bitAnd: 2).
	self assert: (position2 bitAnd: 4) == (position1 bitAnd: 4).
	self assert: ( position2 = 32 ).
	position3 := entity  compareDocumentPosition:entity2.
	self assert: ( position3 = position1 ).

!

test_nodecomparedocumentposition24
	"
	Using compareDocumentPosition check if the return value of document position of a Notation node compared to another
	that is the same is not flagged.

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-compareDocumentPosition
	"
	|
	  doc "Document"
	  docType "DocumentType"
	  notaionsMap "NamedNodeMap"
	  notation "Notation"
	  notation2 "Notation"
	  notationPosition "SmallInteger"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docType := doc  doctype.
	notaionsMap := docType  notations.
	notation := notaionsMap  getNamedItem:'notation1'.
	notation2 := notaionsMap  getNamedItem:'notation1'.
	notationPosition := notation  compareDocumentPosition:notation2.
	self assert: ( notationPosition = 0 ).

!

test_nodecomparedocumentposition25
	"
	Using compareDocumentPosition check if the EntityReference or Text node is contained and follows its 
	parent Element node, and that the Element node contains and precedes the 
	EntityReference or Text node.

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-compareDocumentPosition
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  elemName "Element"
	  entRef "Node"
	  elementPosition "SmallInteger"
	  entRefPosition "SmallInteger"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'var'.
	elemName := elemList  item:2.
	entRef := elemName  firstChild.
	elementPosition := elemName  compareDocumentPosition:entRef.
	self assert: ( elementPosition = 20 ).
	entRefPosition := entRef  compareDocumentPosition:elemName.
	self assert: ( entRefPosition = 10 ).

!

test_nodecomparedocumentposition26
	"
	Using compareDocumentPosition check if the EntityReference node contains and precedes it's first
	childElement, and that the childElement is contained and follows the EntityReference node.

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-compareDocumentPosition
	"
	|
	  doc "Document"
	  varList "NodeList"
	  varElem "Element"
	  entRef "EntityReference"
	  entRefChild1 "Element"
	  entRefPosition "SmallInteger"
	  entRefChild1Position "SmallInteger"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	"if"
	false "no template for element implementationAttribute"  ifTrue: [
						].
	entRefChild1 := entRef  firstChild.
	self assert: entRefChild1 notNil.
	entRefPosition := entRef  compareDocumentPosition:entRefChild1.
	self assert: ( entRefPosition = 20 ).
	entRefChild1Position := entRefChild1  compareDocumentPosition:entRef.
	self assert: ( entRefChild1Position = 10 ).

!

test_nodecomparedocumentposition27
	"
	Using compareDocumentPosition to check if the EntityReference node contains and precedes it's last
	childElement, and that this childElement is contained and follows the EntityReference node.

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-compareDocumentPosition
	"
	|
	  doc "Document"
	  varList "NodeList"
	  varElem "Element"
	  entRef "EntityReference"
	  entRefChild1 "ProcessingInstruction"
	  entRefPosition "SmallInteger"
	  entRefChild1Position "SmallInteger"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	"if"
	false "no template for element implementationAttribute"  ifTrue: [
						].
	entRefChild1 := entRef  lastChild.
	self assert: entRefChild1 notNil.
	entRefPosition := entRef  compareDocumentPosition:entRefChild1.
	self assert: ( entRefPosition = 20 ).
	entRefChild1Position := entRefChild1  compareDocumentPosition:entRef.
	self assert: ( entRefChild1Position = 10 ).

!

test_nodecomparedocumentposition28
	"
	Using compareDocumentPosition check the document position of the EntityReference node ent4's
	first child and last child.  Invoke compareDocumentPositon on first child with last child as a parameter
	should return FOLLOWING, and should return PRECEDING vice versa.

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-compareDocumentPosition
	"
	|
	  doc "Document"
	  varList "NodeList"
	  varElem "Element"
	  entRef "EntityReference"
	  entRefChild1 "Element"
	  entRefChild2 "ProcessingInstruction"
	  entRefChild1Position "SmallInteger"
	  entRefChild2Position "SmallInteger"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	"if"
	false "no template for element implementationAttribute"  ifTrue: [
						].
	entRefChild1 := entRef  firstChild.
	self assert: entRefChild1 notNil.
	entRefChild2 := entRef  lastChild.
	self assert: entRefChild2 notNil.
	entRefChild1Position := entRefChild1  compareDocumentPosition:entRefChild2.
	self assert: ( entRefChild1Position = 4 ).
	entRefChild2Position := entRefChild2  compareDocumentPosition:entRefChild1.
	self assert: ( entRefChild2Position = 2 ).

!

test_nodecomparedocumentposition29
	"
	Create two entity reference nodes. Using compareDocumentPosition to check if the child of the first Entity 
	Ref node precedes the child of the second Entity Ref node, and that the child of the second Entity Ref node
	follows the child of the first Entity Ref node.  

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-compareDocumentPosition
	"
	|
	  doc "Document"
	  docElem "Element"
	  entRef1 "EntityReference"
	  entRef2 "EntityReference"
	  entRefChild1 "Element"
	  entRefChild2 "ProcessingInstruction"
	  entRefChild1Position "SmallInteger"
	  entRefChild2Position "SmallInteger"
	  appendedChild "Node"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	entRef1 := doc  createEntityReference:'ent4'.
	entRef2 := doc  createEntityReference:'ent4'.
	docElem := doc  documentElement.
	appendedChild := docElem  appendChild:entRef1.
	appendedChild := docElem  appendChild:entRef2.
	entRefChild1 := entRef1  firstChild.
	self assert: entRefChild1 notNil.
	entRefChild2 := entRef2  lastChild.
	self assert: entRefChild2 notNil.
	entRefChild1Position := entRefChild1  compareDocumentPosition:entRefChild2.
	self assert: ( entRefChild1Position = 4 ).
	entRefChild2Position := entRefChild2  compareDocumentPosition:entRefChild1.
	self assert: ( entRefChild2Position = 2 ).

!

test_nodecomparedocumentposition30
	"
	Using compareTreePosition check if comparedocumentposition invoked on the first name with 
	the first position node as a parameter returns FOLLOWING.

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-compareDocumentPosition
	"
	|
	  doc "Document"
	  nameList "NodeList"
	  positionList "NodeList"
	  strong "Element"
	  code "Element"
	  namePosition "SmallInteger"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	nameList := doc  getElementsByTagName: 'strong'.
	strong := nameList  item:0.
	positionList := doc  getElementsByTagName: 'code'.
	code := positionList  item:0.
	namePosition := code  compareDocumentPosition:strong.
	self assert: ( namePosition = 2 ).

!

test_nodecomparedocumentposition31
	"
	Using compareDocumentPosition to check if invoking the method on the first name node with
	a new node appended to the second position node as a parameter is FOLLOWING, and is PRECEDING vice versa

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-compareDocumentPosition
	"
	|
	  doc "Document"
	  nameList "NodeList"
	  positionList "NodeList"
	  strong "Element"
	  code "Element"
	  newElem "Element"
	  namePosition "SmallInteger"
	  elemPosition "SmallInteger"
	  appendedChild "Node"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	nameList := doc  getElementsByTagName: 'strong'.
	strong := nameList  item:0.
	positionList := doc  getElementsByTagName: 'code'.
	code := positionList  item:1.
	newElem := doc  createElement:'br' ns:'http://www.w3.org/1999/xhtml'.
	appendedChild := code  appendChild:newElem.
	namePosition := strong  compareDocumentPosition:newElem.
	self assert: ( namePosition = 4 ).
	elemPosition := newElem  compareDocumentPosition:strong.
	self assert: ( elemPosition = 2 ).

!

test_nodecomparedocumentposition32
	"
	Using compareDocumentPosition to check if the document position returned by comparing the first name with
	a first position node of another document reference and adopted by the first as a parameter is FOLLOWING.

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-compareDocumentPosition
	"
	|
	  doc "Document"
	  doc2 "Document"
	  nameList "NodeList"
	  positionList "NodeList"
	  strong "Element"
	  code "Element"
	  documentPosition "SmallInteger"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	self assert:false description:'Method "assign" is not supported yet'.
	nameList := doc  getElementsByTagName: 'strong'.
	strong := nameList  item:0.
	positionList := doc2  getElementsByTagName: 'code'.
	code := positionList  item:0.
	documentPosition := strong  compareDocumentPosition:code.
	self assert: ( documentPosition = 4 ).

!

test_nodecomparedocumentposition33
	"
	Create a new Element node, add a new atttribute node to it.  Compare the position 
	of the Element and the Document.  This should return disconnected, implementation specific, and that
	the order of these two nodes is preserved. 
	Also compare the position of the Element node with respect to the Attr node and this should
	be PRECEDING and contains, and the Attr node follows and is contained by the Element node

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-compareDocumentPosition
	"
	|
	  doc "Document"
	  elem "Element"
	  attr "Attr"
	  position1 "SmallInteger"
	  position2 "SmallInteger"
	  position3 "SmallInteger"
	  position4 "SmallInteger"
	  position5 "SmallInteger"
	  replacedAttr "Attr"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elem := doc  createElement:'br' ns:'http://www.w3.org/1999/xhtml'.
	attr := doc  createAttribute:'xml:lang' ns:'http://www.w3.org/XML/1998/namespace'.
	replacedAttr := elem  setAttributeNodeNS: attr.
	position4 := elem  compareDocumentPosition:attr.
	self assert: ( position4 = 20 ).
	position5 := attr  compareDocumentPosition:elem.
	self assert: ( position5 = 10 ).
	position1 := doc  compareDocumentPosition:elem.
	self assert: ( position1 = 33 ).
	position2 := elem  compareDocumentPosition:doc.
	self assert: (position2 bitAnd: 2) == (position1 bitAnd: 2).
	self assert: (position2 bitAnd: 4) == (position1 bitAnd: 4).
	self assert: ( position2 = 33 ).
	position3 := doc  compareDocumentPosition:elem.
	self assert: ( position3 = position1 ).

!

test_nodecomparedocumentposition34
	"
	Create a new Element node, add new Text, Element and Processing Instruction nodes to it.
	Using compareDocumentPosition, compare the position of the Element with respect to the Text
	and the Text with respect to the Processing Instruction.

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-compareDocumentPosition
	"
	|
	  doc "Document"
	  elemMain "Element"
	  elem "Element"
	  txt "Text"
	  pi "ProcessingInstruction"
	  elementToTxtPosition "SmallInteger"
	  txtToPiPosition "SmallInteger"
	  appendedChild "Node"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemMain := doc  createElement:'p' ns:'http://www.w3.org/1999/xhtml'.
	elem := doc  createElement:'br' ns:'http://www.w3.org/1999/xhtml'.
	txt := doc  createTextNode:'TEXT'.
	pi := doc  createProcessingInstruction:'PIT' data:'PID'.
	appendedChild := elemMain  appendChild:txt.
	appendedChild := elemMain  appendChild:elem.
	appendedChild := elemMain  appendChild:pi.
	elementToTxtPosition := txt  compareDocumentPosition:elem.
	self assert: ( elementToTxtPosition = 4 ).
	txtToPiPosition := pi  compareDocumentPosition:txt.
	self assert: ( txtToPiPosition = 2 ).

!

test_nodecomparedocumentposition35
	"
	Using compareDocumentPosition to check if the Element contains and precedes its default attribute 
	and that the attribute follows and iscontained by the Element

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-compareDocumentPosition
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  elem "Element"
	  attr "Attr"
	  elementPosition "SmallInteger"
	  attrPosition "SmallInteger"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'p'.
	elem := elemList  item:3.
	attr := elem  getAttributeNode:'dir'.
	elementPosition := elem  compareDocumentPosition:attr.
	self assert: ( elementPosition = 20 ).
	attrPosition := attr  compareDocumentPosition:elem.
	self assert: ( attrPosition = 10 ).

!

test_nodecomparedocumentposition36
	"
	Using compareDocumentPosition to check if the document position of an Attribute compared with
	the element that follows its parent as a parameter is FOLLOWING, and is PRECEDING
	vice versa.

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-compareDocumentPosition
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  elem "Element"
	  elemListFollows "NodeList"
	  elemFollows "Element"
	  attr "Attr"
	  attrPosition "SmallInteger"
	  elemFollowsPosition "SmallInteger"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'p'.
	elem := elemList  item:3.
	attr := elem  getAttributeNode:'dir'.
	elemListFollows := doc  getElementsByTagName: 'strong'.
	elemFollows := elemListFollows  item:3.
	attrPosition := attr  compareDocumentPosition:elemFollows.
	self assert: ( attrPosition = 4 ).
	elemFollowsPosition := elemFollows  compareDocumentPosition:attr.
	self assert: ( elemFollowsPosition = 2 ).

!

test_nodecomparedocumentposition37
	"
	Using compareDocumentPosition to check if the document position of the first class attribute
	of the element acronym when compared with the elements text content as a parameter is 
	is FOLLOWING, and is PRECEDING vice versa.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-compareDocumentPosition
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  elem "Element"
	  txt "Text"
	  attr "Attr"
	  attrPosition "SmallInteger"
	  txtPosition "SmallInteger"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'acronym'.
	elem := elemList  item:3.
	attr := elem  getAttributeNode:'class'.
	txt := elem  firstChild.
	attrPosition := attr  compareDocumentPosition:txt.
	self assert: ( attrPosition = 4 ).
	txtPosition := txt  compareDocumentPosition:attr.
	self assert: ( txtPosition = 2 ).

!

test_nodecomparedocumentposition38
	"
	Using compareDocumentPosition to check if the class's attribute contains and precedes it's content, 
	and the content node is contained and follows the attribute node.

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-compareDocumentPosition
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  elem "Element"
	  txt "Text"
	  attr "Attr"
	  attrPosition "SmallInteger"
	  attrChildPosition "SmallInteger"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'acronym'.
	elem := elemList  item:3.
	attr := elem  getAttributeNode:'class'.
	txt := attr  firstChild.
	attrPosition := attr  compareDocumentPosition:txt.
	self assert: ( attrPosition = 20 ).
	attrChildPosition := txt  compareDocumentPosition:attr.
	self assert: ( attrChildPosition = 10 ).

!

test_nodecomparedocumentposition39
	"
	Using compareDocumentPosition to check if the document position of the class's attribute 
	when compared with the local1 attribute node is implementation_specific.

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-compareDocumentPosition
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  elem "Element"
	  attr1 "Attr"
	  attr2 "Attr"
	  attrPosition "SmallInteger"
	  swappedPosition "SmallInteger"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'acronym'.
	elem := elemList  item:3.
	attr1 := elem  getAttributeNode:'class'.
	attr2 := elem  getAttributeNode:'xsi:noNamespaceSchemaLocation'.
	attrPosition := attr1  compareDocumentPosition:attr2.
	self assert: ( attrPosition = 32 ).
	self assert: ( attrPosition = 0 ).
	self assert: (attrPosition bitAnd: 6) == (0 bitAnd: 6).
	swappedPosition := attr2  compareDocumentPosition:attr1.
	self assert: (attrPosition bitAnd: 2) == (swappedPosition bitAnd: 2).
	self assert: (attrPosition bitAnd: 4) == (swappedPosition bitAnd: 4).

!

test_nodecomparedocumentposition40
	"
	Using compareDocumentPosition to check if the document position of the class's attribute 
	when compared with a new attribute node is implementation_specific

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-compareDocumentPosition
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  elem "Element"
	  attr1 "Attr"
	  attr2 "Attr"
	  attrPosition "SmallInteger"
	  swappedPosition "SmallInteger"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'acronym'.
	elem := elemList  item:3.
	attr1 := elem  getAttributeNode:'class'.
	elem  setAttribute: 'xml:lang' ns: 'http://www.w3.org/XML/1998/namespace' value: 'FR-fr'.
	attr2 := elem  getAttributeNode:'xml:lang'.
	attrPosition := attr1  compareDocumentPosition:attr2.
	self assert: ( attrPosition = 32 ).
	self assert: ( attrPosition = 0 ).
	self assert: (attrPosition bitAnd: 6) == (0 bitAnd: 6).
	swappedPosition := attr2  compareDocumentPosition:attr1.
	self assert: (attrPosition bitAnd: 2) == (swappedPosition bitAnd: 2).
	self assert: (attrPosition bitAnd: 4) == (swappedPosition bitAnd: 4).

!

test_nodegetbaseuri01
	"
Call Node.getBaseURI() on a test document.  Should be not-null and same as Document.getDocumentURI().

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-baseURI
		Subject http://www.w3.org/Bugs/Public/show_bug.cgi?id=419
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/infoset-mapping#Infoset2Document
	"
	|
	  doc "Document"
	  baseURI "String"
	  documentURI "String"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	baseURI := doc  baseURI.
	self assert: baseURI = 'barfoo'.
	documentURI := doc  documentURI.
	self assert: ( baseURI = documentURI ).

!

test_nodegetbaseuri02
	"
	Using getBaseURI check if the baseURI attribute of a new Document node is null
	and if affected by changes in Document.documentURI.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-baseURI
		Subject http://www.w3.org/Bugs/Public/show_bug.cgi?id=419
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/infoset-mapping#Infoset2Document
	"
	|
	  doc "Document"
	  newDoc "Document"
	  domImpl "DOMImplementation"
	  baseURI "String"
	  rootNS "String"
	  rootName "String"
	  docElem "Element"
	  nullDocType "DocumentType"
	|
	nullDocType := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	docElem := doc  documentElement.
	rootNS := docElem  namespaceURI.
	rootName := docElem  tagName.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	newDoc := domImpl createDocumentNS: rootNS qualifiedName: rootName doctype: nullDocType.
	baseURI := newDoc  baseURI.
	self assert: baseURI isNil.
	newDoc documentURI:'http://www.example.com/sample.xml'.
	baseURI := newDoc  baseURI.
	self assert: ( baseURI asLowercase = 'http://www.example.com/sample.xml' asLowercase ).

!

test_nodegetbaseuri03
	"
Check that Node.baseURI is null for a DocumentType as defined in the Infoset Mapping (Appendix C).

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-baseURI
		Subject http://www.w3.org/Bugs/Public/show_bug.cgi?id=419
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/infoset-mapping#Infoset2DocumentType
	"
	|
	  doc "Document"
	  docType "DocumentType"
	  baseURI "String"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	docType := doc  doctype.
	baseURI := docType  baseURI.
	self assert: baseURI isNil.

!

test_nodegetbaseuri04
	"
Node.baseURI for a document element without an xml:base attribute should be same as Document.documentURI.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-baseURI
		Subject http://www.w3.org/Bugs/Public/show_bug.cgi?id=419
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/infoset-mapping#Infoset2Document
	"
	|
	  doc "Document"
	  docElem "Element"
	  baseURI "String"
	  documentURI "String"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	docElem := doc  documentElement.
	baseURI := docElem  baseURI.
	self assert: baseURI = 'barfoo'.
	documentURI := doc  documentURI.
	self assert: ( baseURI = documentURI ).

!

test_nodegetbaseuri05
	"
	Using getBaseURI check if the baseURI attribute of this DocumentElement is http://www.w3.org/DOM/L3Test.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-baseURI
		Subject http://www.w3.org/Bugs/Public/show_bug.cgi?id=419
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/infoset-mapping#Infoset2Element
	"
	|
	  doc "Document"
	  docElem "Element"
	  baseURI "String"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo_base').
	docElem := doc  documentElement.
	baseURI := docElem  baseURI.
	self assert: ( baseURI = 'http://www.w3.org/DOM/L3Test' ).

!

test_nodegetbaseuri06
	"
	TODO Clarification: Create a new Element in this document.  Since its baseURI should be the baseURI of
	the Document Entity which I assume is not null, using getBaseURI check if the baseURI 
	attribute of this Element node is not null.???

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-baseURI
		Subject http://www.w3.org/Bugs/Public/show_bug.cgi?id=419
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/infoset-mapping#Infoset2Element
	"
	|
	  doc "Document"
	  newElement "Element"
	  baseURI "String"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	newElement := doc  createElement:'br' ns:'http://www.w3.org/1999/xhtml'.
	baseURI := doc  baseURI.
	self assert: baseURI notNil.

!

test_nodegetbaseuri07
	"
	Append a created element to a document and check that its baseURI
	is inherited from its parent.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-baseURI
		Subject http://www.w3.org/Bugs/Public/show_bug.cgi?id=419
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/infoset-mapping#Infoset2Element
	"
	|
	  doc "Document"
	  newElement "Element"
	  baseURI "String"
	  appended "Node"
	  bodyList "NodeList"
	  bodyElem "Element"
	  htmlNS "String"
	|
	htmlNS := 'http://www.w3.org/1999/xhtml'.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo_base').
	bodyList := doc  getElementsByTagName: 'body'.
	bodyElem := bodyList  item:0.
	newElement := doc  createElement:'meta' ns:htmlNS.
	newElement  setAttribute:'content' value:'text/xml'.
	appended := bodyElem  appendChild:newElement.
	baseURI := newElement  baseURI.
	self assert: ( baseURI = 'http://www.w3.org/DOM/EmployeeID' ).

!

test_nodegetbaseuri09
	"
Get the baseURI value on an element with an explicit xml:base attribute.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-baseURI
		Subject http://www.w3.org/Bugs/Public/show_bug.cgi?id=419
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/infoset-mapping#Infoset2Element
	"
	|
	  doc "Document"
	  bodyElem "Element"
	  bodyList "NodeList"
	  baseURI "String"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo_base').
	bodyList := doc  getElementsByTagName: 'body'.
	bodyElem := bodyList  item:0.
	baseURI := bodyElem  baseURI.
	self assert: ( baseURI = 'http://www.w3.org/DOM/EmployeeID' ).

!

test_nodegetbaseuri10
	"
	Append as a child of this documentElement a new Processing Instruction.  Using getBaseURI 
	check if the baseURI attribute of the new Processing Instruction node is  'http://www.w3.org/DOM/L3Test .

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-baseURI
		Subject http://www.w3.org/Bugs/Public/show_bug.cgi?id=419
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/infoset-mapping#Infoset2ProcessingInstruction
	"
	|
	  doc "Document"
	  docElem "Element"
	  newPI "ProcessingInstruction"
	  baseURI "String"
	  appendedChild "Node"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo_base').
	docElem := doc  documentElement.
	newPI := doc  createProcessingInstruction:'TARGET' data:'DATA'.
	appendedChild := docElem  appendChild:newPI.
	baseURI := newPI  baseURI.
	self assert: ( baseURI = 'http://www.w3.org/DOM/L3Test' ).

!

test_nodegetbaseuri11
	"
	Import a new Processing Instruction of a new Document after the document element.  Using getBaseURI 
	check if the baseURI attribute of the new Processing Instruction node is the same as Document.documentURI.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-baseURI
		Subject http://www.w3.org/Bugs/Public/show_bug.cgi?id=419
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/infoset-mapping#Infoset2ProcessingInstruction
	"
	|
	  doc "Document"
	  newDoc "Document"
	  domImpl "DOMImplementation"
	  newPI "ProcessingInstruction"
	  imported "ProcessingInstruction"
	  baseURI "String"
	  docURI "String"
	  appendedChild "Node"
	  nullDocType "DocumentType"
	|
	nullDocType := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo_base').
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	newDoc := domImpl createDocumentNS: 'http://www.w3.org/1999/xhtml' qualifiedName: 'html' doctype: nullDocType.
	newPI := newDoc  createProcessingInstruction:'TARGET' data:'DATA'.
	imported := doc  importNode:newPI deep:true.
	appendedChild := doc  appendChild:imported.
	baseURI := imported  baseURI.
	self assert: baseURI = 'barfoo_base'.
	docURI := doc  documentURI.
	self assert: ( baseURI = docURI ).

!

test_nodegetbaseuri12
	"
	Using getBaseURI verify if the entity epsilon is absolute
	and matches the URL of the document entity.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-baseURI
		Subject http://www.w3.org/Bugs/Public/show_bug.cgi?id=419
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/infoset-mapping#Infoset2Entity
	"
	|
	  doc "Document"
	  docType "DocumentType"
	  entitiesMap "NamedNodeMap"
	  entity "Entity"
	  baseURI "String"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docType := doc  doctype.
	entitiesMap := docType  entities.
	entity := entitiesMap  getNamedItem:'epsilon'.
	baseURI := entity  baseURI.
	self assert: baseURI = 'hc_staff'.

!

test_nodegetbaseuri13
	"
	Using getBaseURI verify if the notation defined in an internal subset
	is the base URI of the document.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-baseURI
		Subject http://www.w3.org/Bugs/Public/show_bug.cgi?id=419
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/infoset-mapping#Infoset2Notation
	"
	|
	  doc "Document"
	  docType "DocumentType"
	  notationsMap "NamedNodeMap"
	  notation "Notation"
	  baseURI "String"
	  docURI "String"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docType := doc  doctype.
	notationsMap := docType  notations.
	notation := notationsMap  getNamedItem:'notation1'.
	baseURI := notation  baseURI.
	docURI := doc  documentURI.
	self assert: ( baseURI = docURI ).
	self assert: baseURI = 'hc_staff'.

!

test_nodegetbaseuri14
	"
	Using getBaseURI verify if the imported notation notation2 is null.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-baseURI
		Subject http://www.w3.org/Bugs/Public/show_bug.cgi?id=419
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/infoset-mapping#Infoset2Notation
	"
	|
	  doc "Document"
	  newDoc "Document"
	  docElem "Element"
	  docElemNS "String"
	  docElemName "String"
	  domImpl "DOMImplementation"
	  docType "DocumentType"
	  notationsMap "NamedNodeMap"
	  notation "Notation"
	  notationImported "Notation"
	  baseURI "String"
	  nullDocType "DocumentType"
	|
	nullDocType := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docElem := doc  documentElement.
	docElemNS := docElem  namespaceURI.
	docElemName := docElem  localName.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	newDoc := domImpl createDocumentNS: docElemNS qualifiedName: docElemName doctype: nullDocType.
	docType := doc  doctype.
	notationsMap := docType  notations.
	notation := notationsMap  getNamedItem:'notation2'.
	notationImported := newDoc  importNode:notation deep:true.
	baseURI := notationImported  baseURI.
	self assert: baseURI isNil.

!

test_nodegetbaseuri15
	"
Node.getBaseURI for an Attr is null.

		Creator: Curt Arnold
		Autor Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-baseURI
		Subject http://www.w3.org/Bugs/Public/show_bug.cgi?id=419
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/infoset-mapping#Infoset2Attr
	"
	|
	  doc "Document"
	  baseURI "String"
	  attrNode "Attr"
	  bodyList "NodeList"
	  bodyElem "Element"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo_base').
	bodyList := doc  getElementsByTagName: 'body'.
	bodyElem := bodyList  item:0.
	attrNode := bodyElem  getAttributeNode:'id'.
	baseURI := attrNode  baseURI.
	self assert: baseURI isNil.

!

test_nodegetbaseuri16
	"
Node.getBaseURI for an EntityReference to should be the baseURI where the entity declaration occurs.

		Creator: Curt Arnold
		Autor Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-baseURI
		Subject http://www.w3.org/Bugs/Public/show_bug.cgi?id=419
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/infoset-mapping#Infoset2EntityReference
	"
	|
	  doc "Document"
	  baseURI "String"
	  entRef "EntityReference"
	  pList "NodeList"
	  pElem "Element"
	|
	"implementationAttribute not supported: expandEntityReferences"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'external_barfoo').
	pList := doc  getElementsByTagName: 'p'.
	pElem := pList  item:0.
	entRef := pElem  lastChild.
	baseURI := entRef  baseURI.
	self assert: baseURI = 'external_barfoo'.

!

test_nodegetbaseuri17
	"
Node.getBaseURI for an text node is null.

		Creator: Curt Arnold
		Autor Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-baseURI
		Subject http://www.w3.org/Bugs/Public/show_bug.cgi?id=419
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/infoset-mapping#Infoset2Text
	"
	|
	  doc "Document"
	  baseURI "String"
	  textNode "Text"
	  pList "NodeList"
	  pElem "Element"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo_base').
	pList := doc  getElementsByTagName: 'p'.
	pElem := pList  item:0.
	textNode := pElem  firstChild.
	baseURI := textNode  baseURI.
	self assert: baseURI isNil.

!

test_nodegetbaseuri18
	"
Node.getBaseURI for an comment node is null.

		Creator: Curt Arnold
		Autor Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-baseURI
		Subject http://www.w3.org/Bugs/Public/show_bug.cgi?id=419
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/infoset-mapping#Infoset2Comment
	"
	|
	  doc "Document"
	  baseURI "String"
	  comment "Comment"
	  pList "NodeList"
	  pElem "Element"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo_base').
	pList := doc  getElementsByTagName: 'p'.
	pElem := pList  item:0.
	comment := pElem  nextSibling.
	baseURI := comment  baseURI.
	self assert: baseURI isNil.

!

test_nodegetbaseuri19
	"
Checks baseURI for a text node is null.

		Creator: Curt Arnold
		Autor Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-baseURI
		Subject http://www.w3.org/Bugs/Public/show_bug.cgi?id=419
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/infoset-mapping#Infoset2DocumentType
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/infoset-mapping#Infoset2EntityReference
	"
	|
	  doc "Document"
	  baseURI "String"
	  entBaseURI "String"
	  entRef "EntityReference"
	  pList "NodeList"
	  pElem "Element"
	  textNode "Text"
	|
	^self. "Validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'external_barfoo').
	pList := doc  getElementsByTagName: 'p'.
	pElem := pList  item:0.
	self assert: pElem notNil.
	"if"
	false "no template for element implementationAttribute"  ifTrue: [
			].
	baseURI := textNode  baseURI.
	self assert: baseURI isNil.

!

test_nodegetbaseuri20
	"
baseURI for an element from an entity reference should be the URI of the
external entity if there is now xml:base attribute. 

		Creator: Curt Arnold
		Autor Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-baseURI
		Subject http://www.w3.org/Bugs/Public/show_bug.cgi?id=419
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/infoset-mapping#Infoset2EntityReference
	"
	|
	  doc "Document"
	  baseURI "String"
	  pList "NodeList"
	  pElem "Element"
	|
	^self. "Validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'external_barfoo').
	pList := doc  getElementsByTagName: 'p'.
	pElem := pList  item:2.
	self assert: pElem notNil.
	baseURI := pElem  baseURI.
	self assert: baseURI = 'external_widget'.

!

test_nodegetfeature01
	"
Check implementation of Node.getFeature on Document.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-getFeature
	"
	|
	  doc "Document"
	  node "Node"
	  nullVersion "String"
	  featureImpl "Node"
	  isSupported "Boolean"
	  domImpl "DOMImplementation"
	|
	nullVersion := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	self assert:false description:'Method "assign" is not supported yet'.
	featureImpl := node  getFeature:'Core' version:nullVersion.
	self assert: featureImpl == node.
	featureImpl := node  getFeature:'cOrE' version:nullVersion.
	self assert: featureImpl == node.
	featureImpl := node  getFeature:'+cOrE' version:nullVersion.
	self assert: featureImpl == node.
	featureImpl := node  getFeature:'org.w3c.domts.bogus.feature' version:nullVersion.
	self assert: featureImpl isNil.
	featureImpl := node  getFeature:'cOrE' version:'2.0'.
	self assert: featureImpl == node.
	featureImpl := node  getFeature:'cOrE' version:'3.0'.
	self assert: featureImpl == node.
	isSupported := node  isSupported:'XML' version:nullVersion.
	featureImpl := doc  getFeature:'XML' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'SVG' version:nullVersion.
	featureImpl := doc  getFeature:'SVG' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'HTML' version:nullVersion.
	featureImpl := doc  getFeature:'HTML' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'Events' version:nullVersion.
	featureImpl := doc  getFeature:'Events' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'LS' version:nullVersion.
	featureImpl := doc  getFeature:'LS' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'LS-Async' version:nullVersion.
	featureImpl := doc  getFeature:'LS-Async' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'XPath' version:nullVersion.
	featureImpl := doc  getFeature:'XPath' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'+HTML' version:nullVersion.
	featureImpl := doc  getFeature:'HTML' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'+SVG' version:nullVersion.
	featureImpl := doc  getFeature:'SVG' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].

!

test_nodegetfeature02
	"
Check implementation of Node.getFeature on DocumentFragment.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-getFeature
	"
	|
	  doc "Document"
	  node "Node"
	  nullVersion "String"
	  featureImpl "Node"
	  isSupported "Boolean"
	  domImpl "DOMImplementation"
	|
	nullVersion := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	node := doc  createDocumentFragment.
	featureImpl := node  getFeature:'Core' version:nullVersion.
	self assert: featureImpl == node.
	featureImpl := node  getFeature:'cOrE' version:nullVersion.
	self assert: featureImpl == node.
	featureImpl := node  getFeature:'+cOrE' version:nullVersion.
	self assert: featureImpl == node.
	featureImpl := node  getFeature:'org.w3c.domts.bogus.feature' version:nullVersion.
	self assert: featureImpl isNil.
	featureImpl := node  getFeature:'cOrE' version:'2.0'.
	self assert: featureImpl == node.
	featureImpl := node  getFeature:'cOrE' version:'3.0'.
	self assert: featureImpl == node.
	isSupported := node  isSupported:'XML' version:nullVersion.
	featureImpl := node  getFeature:'XML' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'SVG' version:nullVersion.
	featureImpl := node  getFeature:'SVG' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'HTML' version:nullVersion.
	featureImpl := node  getFeature:'HTML' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'Events' version:nullVersion.
	featureImpl := node  getFeature:'Events' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'LS' version:nullVersion.
	featureImpl := node  getFeature:'LS' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'LS-Async' version:nullVersion.
	featureImpl := node  getFeature:'LS-Async' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'XPath' version:nullVersion.
	featureImpl := node  getFeature:'XPath' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'+HTML' version:nullVersion.
	featureImpl := node  getFeature:'HTML' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'+SVG' version:nullVersion.
	featureImpl := node  getFeature:'SVG' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].

!

test_nodegetfeature03
	"
Check implementation of Node.getFeature on DocumentType.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-getFeature
	"
	|
	  doc "Document"
	  node "Node"
	  nullVersion "String"
	  featureImpl "Node"
	  isSupported "Boolean"
	  domImpl "DOMImplementation"
	|
	nullVersion := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	node := doc  doctype.
	featureImpl := node  getFeature:'Core' version:nullVersion.
	self assert: featureImpl == node.
	featureImpl := node  getFeature:'cOrE' version:nullVersion.
	self assert: featureImpl == node.
	featureImpl := node  getFeature:'+cOrE' version:nullVersion.
	self assert: featureImpl == node.
	featureImpl := node  getFeature:'org.w3c.domts.bogus.feature' version:nullVersion.
	self assert: featureImpl isNil.
	featureImpl := node  getFeature:'cOrE' version:'2.0'.
	self assert: featureImpl == node.
	featureImpl := node  getFeature:'cOrE' version:'3.0'.
	self assert: featureImpl == node.
	isSupported := node  isSupported:'XML' version:nullVersion.
	featureImpl := node  getFeature:'XML' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'SVG' version:nullVersion.
	featureImpl := node  getFeature:'SVG' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'HTML' version:nullVersion.
	featureImpl := node  getFeature:'HTML' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'Events' version:nullVersion.
	featureImpl := node  getFeature:'Events' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'LS' version:nullVersion.
	featureImpl := node  getFeature:'LS' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'LS-Async' version:nullVersion.
	featureImpl := node  getFeature:'LS-Async' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'XPath' version:nullVersion.
	featureImpl := node  getFeature:'XPath' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'+HTML' version:nullVersion.
	featureImpl := node  getFeature:'HTML' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'+SVG' version:nullVersion.
	featureImpl := node  getFeature:'SVG' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].

!

test_nodegetfeature04
	"
Check implementation of Node.getFeature on EntityReference.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-getFeature
	"
	|
	  doc "Document"
	  node "Node"
	  nullVersion "String"
	  featureImpl "Node"
	  isSupported "Boolean"
	  domImpl "DOMImplementation"
	|
	nullVersion := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	node := doc  createEntityReference:'ent1'.
	featureImpl := node  getFeature:'Core' version:nullVersion.
	self assert: featureImpl == node.
	featureImpl := node  getFeature:'cOrE' version:nullVersion.
	self assert: featureImpl == node.
	featureImpl := node  getFeature:'+cOrE' version:nullVersion.
	self assert: featureImpl == node.
	featureImpl := node  getFeature:'org.w3c.domts.bogus.feature' version:nullVersion.
	self assert: featureImpl isNil.
	featureImpl := node  getFeature:'cOrE' version:'2.0'.
	self assert: featureImpl == node.
	featureImpl := node  getFeature:'cOrE' version:'3.0'.
	self assert: featureImpl == node.
	isSupported := node  isSupported:'XML' version:nullVersion.
	featureImpl := node  getFeature:'XML' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'SVG' version:nullVersion.
	featureImpl := node  getFeature:'SVG' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'HTML' version:nullVersion.
	featureImpl := node  getFeature:'HTML' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'Events' version:nullVersion.
	featureImpl := node  getFeature:'Events' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'LS' version:nullVersion.
	featureImpl := node  getFeature:'LS' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'LS-Async' version:nullVersion.
	featureImpl := node  getFeature:'LS-Async' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'XPath' version:nullVersion.
	featureImpl := node  getFeature:'XPath' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'+HTML' version:nullVersion.
	featureImpl := node  getFeature:'HTML' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'+SVG' version:nullVersion.
	featureImpl := node  getFeature:'SVG' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].

!

test_nodegetfeature05
	"
Check implementation of Node.getFeature on Element.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-getFeature
	"
	|
	  doc "Document"
	  node "Node"
	  nullVersion "String"
	  featureImpl "Node"
	  isSupported "Boolean"
	  domImpl "DOMImplementation"
	|
	nullVersion := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	node := doc  documentElement.
	featureImpl := node  getFeature:'Core' version:nullVersion.
	self assert: featureImpl == node.
	featureImpl := node  getFeature:'cOrE' version:nullVersion.
	self assert: featureImpl == node.
	featureImpl := node  getFeature:'+cOrE' version:nullVersion.
	self assert: featureImpl == node.
	featureImpl := node  getFeature:'org.w3c.domts.bogus.feature' version:nullVersion.
	self assert: featureImpl isNil.
	featureImpl := node  getFeature:'cOrE' version:'2.0'.
	self assert: featureImpl == node.
	featureImpl := node  getFeature:'cOrE' version:'3.0'.
	self assert: featureImpl == node.
	isSupported := node  isSupported:'XML' version:nullVersion.
	featureImpl := node  getFeature:'XML' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'SVG' version:nullVersion.
	featureImpl := node  getFeature:'SVG' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'HTML' version:nullVersion.
	featureImpl := node  getFeature:'HTML' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'Events' version:nullVersion.
	featureImpl := node  getFeature:'Events' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'LS' version:nullVersion.
	featureImpl := node  getFeature:'LS' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'LS-Async' version:nullVersion.
	featureImpl := node  getFeature:'LS-Async' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'XPath' version:nullVersion.
	featureImpl := node  getFeature:'XPath' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'+HTML' version:nullVersion.
	featureImpl := node  getFeature:'HTML' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'+SVG' version:nullVersion.
	featureImpl := node  getFeature:'SVG' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].

!

test_nodegetfeature06
	"
Check implementation of Node.getFeature on non-namespace attribute.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-getFeature
	"
	|
	  doc "Document"
	  node "Node"
	  nullVersion "String"
	  featureImpl "Node"
	  isSupported "Boolean"
	  domImpl "DOMImplementation"
	|
	nullVersion := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	node := doc  createAttribute:'title'.
	featureImpl := node  getFeature:'Core' version:nullVersion.
	self assert: featureImpl == node.
	featureImpl := node  getFeature:'cOrE' version:nullVersion.
	self assert: featureImpl == node.
	featureImpl := node  getFeature:'+cOrE' version:nullVersion.
	self assert: featureImpl == node.
	featureImpl := node  getFeature:'org.w3c.domts.bogus.feature' version:nullVersion.
	self assert: featureImpl isNil.
	featureImpl := node  getFeature:'cOrE' version:'2.0'.
	self assert: featureImpl == node.
	featureImpl := node  getFeature:'cOrE' version:'3.0'.
	self assert: featureImpl == node.
	isSupported := node  isSupported:'XML' version:nullVersion.
	featureImpl := node  getFeature:'XML' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'SVG' version:nullVersion.
	featureImpl := node  getFeature:'SVG' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'HTML' version:nullVersion.
	featureImpl := node  getFeature:'HTML' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'Events' version:nullVersion.
	featureImpl := node  getFeature:'Events' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'LS' version:nullVersion.
	featureImpl := node  getFeature:'LS' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'LS-Async' version:nullVersion.
	featureImpl := node  getFeature:'LS-Async' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'XPath' version:nullVersion.
	featureImpl := node  getFeature:'XPath' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'+HTML' version:nullVersion.
	featureImpl := node  getFeature:'HTML' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'+SVG' version:nullVersion.
	featureImpl := node  getFeature:'SVG' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].

!

test_nodegetfeature07
	"
Check implementation of Node.getFeature on namespaced attribute.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-getFeature
	"
	|
	  doc "Document"
	  node "Node"
	  nullVersion "String"
	  featureImpl "Node"
	  isSupported "Boolean"
	  domImpl "DOMImplementation"
	|
	nullVersion := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	node := doc  createAttribute:'xml:lang' ns:'http://www.w3.org/XML/1998/namespace'.
	featureImpl := node  getFeature:'Core' version:nullVersion.
	self assert: featureImpl == node.
	featureImpl := node  getFeature:'cOrE' version:nullVersion.
	self assert: featureImpl == node.
	featureImpl := node  getFeature:'+cOrE' version:nullVersion.
	self assert: featureImpl == node.
	featureImpl := node  getFeature:'org.w3c.domts.bogus.feature' version:nullVersion.
	self assert: featureImpl isNil.
	featureImpl := node  getFeature:'cOrE' version:'2.0'.
	self assert: featureImpl == node.
	featureImpl := node  getFeature:'cOrE' version:'3.0'.
	self assert: featureImpl == node.
	isSupported := node  isSupported:'XML' version:nullVersion.
	featureImpl := node  getFeature:'XML' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'SVG' version:nullVersion.
	featureImpl := node  getFeature:'SVG' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'HTML' version:nullVersion.
	featureImpl := node  getFeature:'HTML' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'Events' version:nullVersion.
	featureImpl := node  getFeature:'Events' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'LS' version:nullVersion.
	featureImpl := node  getFeature:'LS' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'LS-Async' version:nullVersion.
	featureImpl := node  getFeature:'LS-Async' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'XPath' version:nullVersion.
	featureImpl := node  getFeature:'XPath' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'+HTML' version:nullVersion.
	featureImpl := node  getFeature:'HTML' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'+SVG' version:nullVersion.
	featureImpl := node  getFeature:'SVG' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].

!

test_nodegetfeature08
	"
Check implementation of Node.getFeature on ProcessingInstruction.

		Creator: Curt Arnold
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-getFeature
	"
	|
	  doc "Document"
	  node "Node"
	  nullVersion "String"
	  featureImpl "Node"
	  isSupported "Boolean"
	  domImpl "DOMImplementation"
	|
	nullVersion := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	node := doc  createProcessingInstruction:'test-pi' data:'foo'.
	featureImpl := node  getFeature:'Core' version:nullVersion.
	self assert: featureImpl == node.
	featureImpl := node  getFeature:'cOrE' version:nullVersion.
	self assert: featureImpl == node.
	featureImpl := node  getFeature:'+cOrE' version:nullVersion.
	self assert: featureImpl == node.
	featureImpl := node  getFeature:'org.w3c.domts.bogus.feature' version:nullVersion.
	self assert: featureImpl isNil.
	featureImpl := node  getFeature:'cOrE' version:'2.0'.
	self assert: featureImpl == node.
	featureImpl := node  getFeature:'cOrE' version:'3.0'.
	self assert: featureImpl == node.
	isSupported := node  isSupported:'XML' version:nullVersion.
	featureImpl := node  getFeature:'XML' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'SVG' version:nullVersion.
	featureImpl := node  getFeature:'SVG' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'HTML' version:nullVersion.
	featureImpl := node  getFeature:'HTML' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'Events' version:nullVersion.
	featureImpl := node  getFeature:'Events' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'LS' version:nullVersion.
	featureImpl := node  getFeature:'LS' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'LS-Async' version:nullVersion.
	featureImpl := node  getFeature:'LS-Async' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'XPath' version:nullVersion.
	featureImpl := node  getFeature:'XPath' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'+HTML' version:nullVersion.
	featureImpl := node  getFeature:'HTML' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'+SVG' version:nullVersion.
	featureImpl := node  getFeature:'SVG' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].

!

test_nodegetfeature09
	"
Check implementation of Node.getFeature on Comment.

		Creator: Curt Arnold
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-getFeature
	"
	|
	  doc "Document"
	  node "Node"
	  nullVersion "String"
	  featureImpl "Node"
	  isSupported "Boolean"
	  domImpl "DOMImplementation"
	|
	nullVersion := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	node := doc  createComment:'test comment'.
	featureImpl := node  getFeature:'Core' version:nullVersion.
	self assert: featureImpl == node.
	featureImpl := node  getFeature:'cOrE' version:nullVersion.
	self assert: featureImpl == node.
	featureImpl := node  getFeature:'+cOrE' version:nullVersion.
	self assert: featureImpl == node.
	featureImpl := node  getFeature:'org.w3c.domts.bogus.feature' version:nullVersion.
	self assert: featureImpl isNil.
	featureImpl := node  getFeature:'cOrE' version:'2.0'.
	self assert: featureImpl == node.
	featureImpl := node  getFeature:'cOrE' version:'3.0'.
	self assert: featureImpl == node.
	isSupported := node  isSupported:'XML' version:nullVersion.
	featureImpl := node  getFeature:'XML' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'SVG' version:nullVersion.
	featureImpl := node  getFeature:'SVG' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'HTML' version:nullVersion.
	featureImpl := node  getFeature:'HTML' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'Events' version:nullVersion.
	featureImpl := node  getFeature:'Events' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'LS' version:nullVersion.
	featureImpl := node  getFeature:'LS' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'LS-Async' version:nullVersion.
	featureImpl := node  getFeature:'LS-Async' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'XPath' version:nullVersion.
	featureImpl := node  getFeature:'XPath' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'+HTML' version:nullVersion.
	featureImpl := node  getFeature:'HTML' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'+SVG' version:nullVersion.
	featureImpl := node  getFeature:'SVG' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].

!

test_nodegetfeature10
	"
Check implementation of Node.getFeature on Text.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-getFeature
	"
	|
	  doc "Document"
	  node "Node"
	  nullVersion "String"
	  featureImpl "Node"
	  isSupported "Boolean"
	  domImpl "DOMImplementation"
	  nodeList "NodeList"
	  elem "Element"
	|
	nullVersion := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	nodeList := doc  getElementsByTagName: 'p'.
	elem := nodeList  item:0.
	node := elem  firstChild.
	featureImpl := node  getFeature:'Core' version:nullVersion.
	self assert: featureImpl == node.
	featureImpl := node  getFeature:'cOrE' version:nullVersion.
	self assert: featureImpl == node.
	featureImpl := node  getFeature:'+cOrE' version:nullVersion.
	self assert: featureImpl == node.
	featureImpl := node  getFeature:'org.w3c.domts.bogus.feature' version:nullVersion.
	self assert: featureImpl isNil.
	featureImpl := node  getFeature:'cOrE' version:'2.0'.
	self assert: featureImpl == node.
	featureImpl := node  getFeature:'cOrE' version:'3.0'.
	self assert: featureImpl == node.
	isSupported := node  isSupported:'XML' version:nullVersion.
	featureImpl := node  getFeature:'XML' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'SVG' version:nullVersion.
	featureImpl := node  getFeature:'SVG' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'HTML' version:nullVersion.
	featureImpl := node  getFeature:'HTML' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'Events' version:nullVersion.
	featureImpl := node  getFeature:'Events' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'LS' version:nullVersion.
	featureImpl := node  getFeature:'LS' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'LS-Async' version:nullVersion.
	featureImpl := node  getFeature:'LS-Async' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'XPath' version:nullVersion.
	featureImpl := node  getFeature:'XPath' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'+HTML' version:nullVersion.
	featureImpl := node  getFeature:'HTML' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'+SVG' version:nullVersion.
	featureImpl := node  getFeature:'SVG' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].

!

test_nodegetfeature11
	"
Check implementation of Node.getFeature on CDATASection.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-getFeature
	"
	|
	  doc "Document"
	  node "Node"
	  nullVersion "String"
	  featureImpl "Node"
	  isSupported "Boolean"
	  domImpl "DOMImplementation"
	|
	nullVersion := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	node := doc  createCDATASection:'some text'.
	featureImpl := node  getFeature:'Core' version:nullVersion.
	self assert: featureImpl == node.
	featureImpl := node  getFeature:'cOrE' version:nullVersion.
	self assert: featureImpl == node.
	featureImpl := node  getFeature:'+cOrE' version:nullVersion.
	self assert: featureImpl == node.
	featureImpl := node  getFeature:'org.w3c.domts.bogus.feature' version:nullVersion.
	self assert: featureImpl isNil.
	featureImpl := node  getFeature:'cOrE' version:'2.0'.
	self assert: featureImpl == node.
	featureImpl := node  getFeature:'cOrE' version:'3.0'.
	self assert: featureImpl == node.
	isSupported := node  isSupported:'XML' version:nullVersion.
	featureImpl := node  getFeature:'XML' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'SVG' version:nullVersion.
	featureImpl := node  getFeature:'SVG' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'HTML' version:nullVersion.
	featureImpl := node  getFeature:'HTML' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'Events' version:nullVersion.
	featureImpl := node  getFeature:'Events' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'LS' version:nullVersion.
	featureImpl := node  getFeature:'LS' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'LS-Async' version:nullVersion.
	featureImpl := node  getFeature:'LS-Async' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'XPath' version:nullVersion.
	featureImpl := node  getFeature:'XPath' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'+HTML' version:nullVersion.
	featureImpl := node  getFeature:'HTML' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'+SVG' version:nullVersion.
	featureImpl := node  getFeature:'SVG' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].

!

test_nodegetfeature12
	"
Check implementation of Node.getFeature on Entity.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-getFeature
	"
	|
	  doc "Document"
	  node "Node"
	  nullVersion "String"
	  featureImpl "Node"
	  isSupported "Boolean"
	  domImpl "DOMImplementation"
	  entities "NamedNodeMap"
	  doctype "DocumentType"
	|
	nullVersion := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	doctype := doc  doctype.
	entities := doctype  entities.
	node := entities  getNamedItem:'ent1'.
	featureImpl := node  getFeature:'Core' version:nullVersion.
	self assert: featureImpl == node.
	featureImpl := node  getFeature:'cOrE' version:nullVersion.
	self assert: featureImpl == node.
	featureImpl := node  getFeature:'+cOrE' version:nullVersion.
	self assert: featureImpl == node.
	featureImpl := node  getFeature:'org.w3c.domts.bogus.feature' version:nullVersion.
	self assert: featureImpl isNil.
	featureImpl := node  getFeature:'cOrE' version:'2.0'.
	self assert: featureImpl == node.
	featureImpl := node  getFeature:'cOrE' version:'3.0'.
	self assert: featureImpl == node.
	isSupported := node  isSupported:'XML' version:nullVersion.
	featureImpl := node  getFeature:'XML' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'SVG' version:nullVersion.
	featureImpl := node  getFeature:'SVG' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'HTML' version:nullVersion.
	featureImpl := node  getFeature:'HTML' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'Events' version:nullVersion.
	featureImpl := node  getFeature:'Events' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'LS' version:nullVersion.
	featureImpl := node  getFeature:'LS' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'LS-Async' version:nullVersion.
	featureImpl := node  getFeature:'LS-Async' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'XPath' version:nullVersion.
	featureImpl := node  getFeature:'XPath' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'+HTML' version:nullVersion.
	featureImpl := node  getFeature:'HTML' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'+SVG' version:nullVersion.
	featureImpl := node  getFeature:'SVG' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].

!

test_nodegetfeature13
	"
Check implementation of Node.getFeature on Notation.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-getFeature
	"
	|
	  doc "Document"
	  node "Node"
	  nullVersion "String"
	  featureImpl "Node"
	  isSupported "Boolean"
	  domImpl "DOMImplementation"
	  notations "NamedNodeMap"
	  doctype "DocumentType"
	|
	nullVersion := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	doctype := doc  doctype.
	notations := doctype  notations.
	node := notations  getNamedItem:'notation1'.
	featureImpl := node  getFeature:'Core' version:nullVersion.
	self assert: featureImpl == node.
	featureImpl := node  getFeature:'cOrE' version:nullVersion.
	self assert: featureImpl == node.
	featureImpl := node  getFeature:'+cOrE' version:nullVersion.
	self assert: featureImpl == node.
	featureImpl := node  getFeature:'org.w3c.domts.bogus.feature' version:nullVersion.
	self assert: featureImpl isNil.
	featureImpl := node  getFeature:'cOrE' version:'2.0'.
	self assert: featureImpl == node.
	featureImpl := node  getFeature:'cOrE' version:'3.0'.
	self assert: featureImpl == node.
	isSupported := node  isSupported:'XML' version:nullVersion.
	featureImpl := node  getFeature:'XML' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'SVG' version:nullVersion.
	featureImpl := node  getFeature:'SVG' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'HTML' version:nullVersion.
	featureImpl := node  getFeature:'HTML' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'Events' version:nullVersion.
	featureImpl := node  getFeature:'Events' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'LS' version:nullVersion.
	featureImpl := node  getFeature:'LS' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'LS-Async' version:nullVersion.
	featureImpl := node  getFeature:'LS-Async' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'XPath' version:nullVersion.
	featureImpl := node  getFeature:'XPath' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'+HTML' version:nullVersion.
	featureImpl := node  getFeature:'HTML' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].
	isSupported := node  isSupported:'+SVG' version:nullVersion.
	featureImpl := node  getFeature:'SVG' version:nullVersion.
	"if"
	(isSupported) ifTrue: [
		].

!

test_nodegettextcontent01
	"

	
	Using getTextContent on this Document node check if the value returned is Null .

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-textContent
	"
	|
	  doc "Document"
	  textContent "String"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	textContent := doc  textContent.
	self assert: textContent isNil.

!

test_nodegettextcontent02
	"

	
	Using getTextContent on a new Document node check if the value returned is Null .

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-textContent
	"
	|
	  doc "Document"
	  domImpl "DOMImplementation"
	  newDoc "Document"
	  textContent "String"
	  nullDocType "DocumentType"
	  docElem "Element"
	  rootName "String"
	  rootNS "String"
	|
	nullDocType := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docElem := doc  documentElement.
	rootNS := docElem  namespaceURI.
	rootName := docElem  tagName.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	newDoc := domImpl createDocumentNS: rootNS qualifiedName: rootName doctype: nullDocType.
	textContent := newDoc  textContent.
	self assert: textContent isNil.

!

test_nodegettextcontent03
	"

	
	Using getTextContent on this DocumentType node check if the value returned is Null .

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-textContent
	"
	|
	  doc "Document"
	  docType "DocumentType"
	  newDoc "Document"
	  textContent "String"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docType := doc  doctype.
	textContent := docType  textContent.
	self assert: textContent isNil.

!

test_nodegettextcontent04
	"

	
	Using getTextContent on a new DocumentType node check if the value returned is Null.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-textContent
	"
	|
	  doc "Document"
	  domImpl "DOMImplementation"
	  docType "DocumentType"
	  textContent "String"
	  nullPubId "String"
	  nullSysId "String"
	  oldDocType "DocumentType"
	  rootName "String"
	|
	nullPubId := nil.
	nullSysId := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	oldDocType := doc  doctype.
	rootName := oldDocType  name.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	docType := domImpl  createDocumentType:rootName publicId:nullPubId systemId:nullSysId.
	textContent := docType  textContent.
	self assert: textContent isNil.

!

test_nodegettextcontent05
	"

	
	Using getTextContent on this DocumentType node check if the value returned is Null .

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-textContent
	"
	|
	  doc "Document"
	  docType "DocumentType"
	  notationsMap "NamedNodeMap"
	  notation1 "Notation"
	  textContent "String"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docType := doc  doctype.
	notationsMap := docType  notations.
	notation1 := notationsMap  getNamedItem:'notation1'.
	textContent := docType  textContent.
	self assert: textContent isNil.

!

test_nodegettextcontent06
	"

	
	Invoke the method getTextContent on a default Attr node and check if the value returned 
	is the attributes Value.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-textContent
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  elem "Element"
	  attr "Attr"
	  textContent "String"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'p'.
	elem := elemList  item:3.
	attr := elem  getAttributeNode:'dir'.
	textContent := attr  textContent.
	self assert: ( textContent = 'rtl' ).

!

test_nodegettextcontent07
	"
	Invoke the method getTextContent on a new Attr node and check if the value returned 
	is the attributes Value.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-textContent
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  elem "Element"
	  attr "Attr"
	  textContent "String"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'p'.
	elem := elemList  item:3.
	elem  setAttribute: 'xml:lang' ns: 'http://www.w3.org/XML/1998/namespace' value: 'en-US'.
	attr := elem  getAttributeNode: 'lang' ns: 'http://www.w3.org/XML/1998/namespace'.
	textContent := attr  textContent.
	self assert: ( textContent = 'en-US' ).

!

test_nodegettextcontent08
	"
	Invoke the method getTextContent on a new Attr node and check if the value returned 
	is the attributes Value.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-textContent
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  elem "Element"
	  att "Attr"
	  attr "Attr"
	  replacedAttr "Attr"
	  textContent "String"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	elem := doc  createElement:'p' ns:'http://www.w3.org/1999/xhtml'.
	att := doc  createAttribute:'xml:lang' ns:'http://www.w3.org/XML/1998/namespace'.
	replacedAttr := elem  setAttributeNodeNS: att.
	attr := elem  getAttributeNode: 'lang' ns: 'http://www.w3.org/XML/1998/namespace'.
	textContent := attr  textContent.
	self assert: ( textContent = '' ).

!

test_nodegettextcontent09
	"
	Invoke the method getTextContent on a new Text node and check if the value returned 
	is the text content.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-textContent
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  elem "Element"
	  txt "Text"
	  textContent "String"
	  appendedChild "Node"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	elem := doc  createElement:'p' ns:'http://www.w3.org/1999/xhtml'.
	txt := doc  createTextNode:'Replacement Text'.
	appendedChild := elem  appendChild:txt.
	textContent := txt  textContent.
	self assert: ( textContent = 'Replacement Text' ).

!

test_nodegettextcontent10
	"

	
	Invoke the method getTextContent on an existing Text node and check if the value returned 
	is the elements Text content.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-textContent
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  elem "Element"
	  txt "Text"
	  textContent "String"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'em'.
	elem := elemList  item:0.
	txt := elem  firstChild.
	textContent := txt  textContent.
	self assert: ( textContent = 'EMP0001' ).

!

test_nodegettextcontent11
	"

	
	Invoke the method getTextContent on an existing CDATASection node and check if the value returned 
	is the CDATASections content.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-textContent
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  elem "Element"
	  cdata "CDATASection"
	  textContent "String"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'strong'.
	elem := elemList  item:1.
	cdata := elem  lastChild.
	textContent := cdata  textContent.
	self assert: ( textContent = 'This is an adjacent CDATASection with a reference to a tab &tab;' ).

!

test_nodegettextcontent12
	"
	Invoke the method getTextContent on a new Comment node and check if the value returned 
	is the Comments data.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-textContent
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  elem "Element"
	  comment "Comment"
	  textContent "String"
	  appendedChild "Node"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	elem := doc  createElement:'body' ns:'http://www.w3.org/1999/xhtml'.
	comment := doc  createComment:'Comment'.
	appendedChild := elem  appendChild:comment.
	textContent := comment  textContent.
	self assert: ( textContent = 'Comment' ).

!

test_nodegettextcontent13
	"

	
	Invoke the method getTextContent on an existing Element node with Text and CDATA
	content and check if the value returned is a single concatenated String with its content.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-textContent
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  elem "Element"
	  textContent "String"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'strong'.
	elem := elemList  item:1.
	textContent := elem  textContent.
	self assert: ( textContent = 'Martha Raynolds\nThis is a CDATASection with EntityReference number 2 &ent2;\nThis is an adjacent CDATASection with a reference to a tab &tab;' ).

!

test_nodegettextcontent14
	"
	Invoke the method getTextContent on an existing Element node with Child Element, Text 
	EntityReferences and Attributes and check if the value returned is a single 
	concatenated String with its content.  

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-textContent
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  elem "Element"
	  textContent "String"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'p'.
	elem := elemList  item:2.
	textContent := elem  textContent.
	self assert: ( textContent = '\n  EMP0003\n  Roger\n Jones\n  Department Manager\n  100,000\n  Element data\n  PO Box 27 Irving, texas 98553\n ' ).

!

test_nodegettextcontent15
	"
	The method getTextContent returns the text content of this node and its descendants.
	
	Invoke the method getTextContent on a new Element node with new Text, EntityReferences  
	CDATASection, PI and Comment nodes and check if the value returned is a single 
	concatenated String with its content.  

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-textContent
	"
	|
	  doc "Document"
	  elem "Element"
	  txt "Text"
	  comment "Comment"
	  entRef "EntityReference"
	  cdata "CDATASection"
	  pi "ProcessingInstruction"
	  textContent "String"
	  appendedChild "Node"
	|
	"implementationAttribute not supported: namespaceAware"
	^self. "Validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elem := doc  createElement:'dom3:elem' ns:'http://www.w3.org/DOM/Test'.
	txt := doc  createTextNode:'Text '.
	comment := doc  createComment:'Comment '.
	entRef := doc  createEntityReference:'beta'.
	pi := doc  createProcessingInstruction:'PIT' data:'PIData '.
	cdata := doc  createCDATASection:'CData'.
	appendedChild := elem  appendChild:txt.
	appendedChild := elem  appendChild:comment.
	appendedChild := elem  appendChild:entRef.
	appendedChild := elem  appendChild:pi.
	appendedChild := elem  appendChild:cdata.
	textContent := elem  textContent.
	doc  normalizeDocument.
	self assert: ( textContent = 'Text βCData' ).

!

test_nodegettextcontent16
	"
	The method getTextContent returns the text content of this node and its descendants.
	
	Invoke the method getTextContent on a new DocumentFragment node with new Text, EntityReferences  
	CDATASection, PI and Comment nodes and check if the value returned is a single 
	concatenated String with its content.  

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-textContent
	"
	|
	  doc "Document"
	  docFrag "DocumentFragment"
	  elem "Element"
	  elemChild "Element"
	  txt "Text"
	  comment "Comment"
	  entRef "EntityReference"
	  cdata "CDATASection"
	  pi "ProcessingInstruction"
	  textContent "String"
	  appendedChild "Node"
	|
	"implementationAttribute not supported: namespaceAware"
	^self. "Validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docFrag := doc  createDocumentFragment.
	elem := doc  createElement:'dom3:elem' ns:'http://www.w3.org/DOM/Test'.
	txt := doc  createTextNode:'Text '.
	comment := doc  createComment:'Comment '.
	entRef := doc  createEntityReference:'beta'.
	pi := doc  createProcessingInstruction:'PIT' data:'PIData '.
	cdata := doc  createCDATASection:'CData'.
	appendedChild := elem  appendChild:txt.
	appendedChild := elem  appendChild:comment.
	appendedChild := elem  appendChild:entRef.
	appendedChild := elem  appendChild:pi.
	appendedChild := elem  appendChild:cdata.
	appendedChild := docFrag  appendChild:elem.
	doc  normalizeDocument.
	textContent := docFrag  textContent.
	self assert: ( textContent = 'Text βCData' ).

!

test_nodegettextcontent17
	"
	Invoke the method getTextContent on a new EntityReference node and check if the 
	value returned is the EntityReference's content.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-textContent
	"
	|
	  doc "Document"
	  elem "Element"
	  entRef "EntityReference"
	  textContent "String"
	  appendedChild "Node"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elem := doc  documentElement.
	entRef := doc  createEntityReference:'beta'.
	appendedChild := elem  appendChild:entRef.
	textContent := entRef  textContent.
	self assert: ( textContent = 'β' ).

!

test_nodegettextcontent18
	"
	Invoke the method getTextContent on an Entity node and check if the value returned
	is its replacement text.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-textContent
	"
	|
	  doc "Document"
	  docType "DocumentType"
	  entity "Entity"
	  entitymap "NamedNodeMap"
	  textContent "String"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docType := doc  doctype.
	entitymap := docType  entities.
	entity := entitymap  getNamedItem:'delta'.
	textContent := entity  textContent.
	self assert: ( textContent = 'δ' ).

!

test_nodegettextcontent19
	"
Checks that element content whitespace is not added to textContent.  Determination
of element content whitespace is only assured if validating.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-textContent
		Subject http://www.w3.org/Bugs/Public/show_bug.cgi?id=538
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  elem "Element"
	  textContent "String"
	|
	"implementationAttribute not supported: ignoringElementContentWhitespace"
	^self. "Validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	elemList := doc  getElementsByTagName: 'body'.
	elem := elemList  item:0.
	textContent := elem  textContent.
	self assert: ( textContent = 'bar' ).

!

test_nodegetuserdata01
	"

	
	Using getUserData with a junk value for the key attempt to retreive the UserData object
	of this Document node without setting it and verify if null is returned.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-getUserData
	"
	|
	  doc "Document"
	  userData "DOMUserData"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	userData := doc  getUserDataForKey:'key1'.
	self assert: userData isNil.

!

test_nodegetuserdata02
	"

	
	Using getUserData with a junk value for the key attempt to retreive the UserData object
	of this Document node without setting it and verify if null is returned.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-getUserData
	"
	|
	  doc "Document"
	  userData "DOMUserData"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	userData := doc  getUserDataForKey:'key1'.
	self assert: userData isNil.

!

test_nodegetuserdata03
	"

	
	Invoke setUserData on this Document to set this Documents UserData to a new
	Element node and using getUserData and isEqualNode check if the returned 
	UserData object is the same as the object that was set.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-getUserData
	"
	|
	  doc "Document"
	  userData "DOMUserData"
	  retUserData "DOMUserData"
	  success "Boolean"
	  elem "Element"
	  returnedUserData "DOMUserData"
	  nullHandler "UserDataHandler"
	|
	nullHandler := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	elem := doc  createElement:'body' ns:'http://www.w3.org/1999/xhtml'.
	returnedUserData := doc  setUserData:elem handler: nullHandler forKey:'something'.
	retUserData := doc  getUserDataForKey:'something'.
	success := retUserData  isEqualNode:elem.
	self assert: success.

!

test_nodegetuserdata04
	"

	
	Invoke setUserData on this DocumentType to set this its UserData to a this
	Document node and using getUserData and isEqualNode check if the returned 
	UserData object is the same as the object that was set.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-getUserData
	"
	|
	  doc "Document"
	  docType "DocumentType"
	  userData "DOMUserData"
	  retUserData "DOMUserData"
	  success "Boolean"
	  nullHandler "UserDataHandler"
	  prevUserData "DOMUserData"
	|
	nullHandler := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docType := doc  doctype.
	prevUserData := docType  setUserData:doc handler: nullHandler forKey:'KeyDoc'.
	retUserData := docType  getUserDataForKey:'KeyDoc'.
	success := retUserData  isEqualNode:doc.
	self assert: success.

!

test_nodegetuserdata05
	"
	Invoke setUserData on this Entity node to set this its UserData to a new 
	Attr node and using getUserData with an invalid Key check if the returned 
	UserData object is Null.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-getUserData
	"
	|
	  doc "Document"
	  docType "DocumentType"
	  entities "NamedNodeMap"
	  entity "Entity"
	  attr "Attr"
	  userData "DOMUserData"
	  retUserData "DOMUserData"
	  nullHandler "UserDataHandler"
	  prevUserData "DOMUserData"
	|
	nullHandler := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docType := doc  doctype.
	entities := docType  entities.
	entity := entities  getNamedItem:'delta'.
	attr := doc  createAttribute:'lang' ns:'http://www.w3.org/XML/1998/namespace'.
	prevUserData := entity  setUserData:attr handler: nullHandler forKey:'key'.
	retUserData := entity  getUserDataForKey:'Key'.
	self assert: retUserData isNil.

!

test_nodegetuserdata06
	"

	
	Invoke getUserData on a new Text node with an ampty Key check if the returned 
	UserData object is Null.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-getUserData
	"
	|
	  doc "Document"
	  txt "Text"
	  retUserData "DOMUserData"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	txt := doc  createTextNode:'TEXT'.
	retUserData := txt  getUserDataForKey:''.
	self assert: retUserData isNil.

!

test_nodegetuserdata07
	"

	
	Invoke setUserData on a new PI node to set this its UserData to itself 
	and using getUserData with an valid Key and isEqualsNode check if the 
	returned UserData object is the same as that was set.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-getUserData
	"
	|
	  doc "Document"
	  pi "ProcessingInstruction"
	  userData "DOMUserData"
	  retUserData "DOMUserData"
	  success "Boolean"
	  nullHandler "UserDataHandler"
	  prevUserData "DOMUserData"
	|
	nullHandler := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	pi := doc  createProcessingInstruction:'PITARGET' data:'PIDATA'.
	prevUserData := pi  setUserData:pi handler: nullHandler forKey:'key'.
	retUserData := pi  getUserDataForKey:'key'.
	success := retUserData  isEqualNode:pi.
	self assert: success.

!

test_nodeinsertbefore01
	"



	Using insertBefore on this Document node attempt to insert a new Comment node before
	this DocumentElement node and verify the name of the inserted Comment node.  Now
	attempt to insert a new Processing Instruction node before the new Comment and 
	verify the target of the inserted ProcessingInstruction.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-952280727
	"
	|
	  doc "Document"
	  docElem "Element"
	  newComment "Comment"
	  insertedComment "Comment"
	  data "String"
	  newPI "ProcessingInstruction"
	  insertedPI "ProcessingInstruction"
	  target "String"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docElem := doc  documentElement.
	newComment := doc  createComment:'Comment'.
	newPI := doc  createProcessingInstruction:'PITarget' data:'PIData'.
	doc  insert:newComment before: docElem.
	data := insertedComment  data.
	self assert: ( data = 'Comment' ).
	doc  insert:newPI before: newComment.
	target := insertedPI  target.
	self assert: ( target = 'PITarget' ).

!

test_nodeinsertbefore02
	"
	Using insertBefore on a new Document node attempt to insert a new Comment node before
	this DocumentType node and verify the name of the inserted Comment node.  Now
	attempt to insert a new Processing Instruction node before the new Comment and 
	verify the target of the inserted ProcessingInstruction.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-952280727
	"
	|
	  doc "Document"
	  newDoc "Document"
	  domImpl "DOMImplementation"
	  newDocType "DocumentType"
	  newComment "Comment"
	  insertedComment "Comment"
	  data "String"
	  newPI "ProcessingInstruction"
	  insertedPI "ProcessingInstruction"
	  target "String"
	  nullPubId "String"
	  nullSysId "String"
	  rootNS "String"
	  rootName "String"
	  docElem "Element"
	|
	nullPubId := nil.
	nullSysId := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docElem := doc  documentElement.
	rootNS := docElem  namespaceURI.
	rootName := docElem  tagName.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	newDocType := domImpl  createDocumentType:rootName publicId:nullPubId systemId:nullSysId.
	newDoc := domImpl createDocumentNS: rootNS qualifiedName: rootName doctype: newDocType.
	newComment := newDoc  createComment:'Comment'.
	newPI := newDoc  createProcessingInstruction:'PITarget' data:'PIData'.
	newDoc  insert:newComment before: newDocType.
	data := insertedComment  data.
	self assert: ( data = 'Comment' ).
	newDoc  insert:newPI before: newComment.
	target := insertedPI  target.
	self assert: ( target = 'PITarget' ).

!

test_nodeinsertbefore03
	"
	Using insertBefore on this Document node attempt to insert a new Attr node before
	this DocumentType node and verify if a HIERARCHY_REQUEST_ERR is raised.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-952280727
	"
	|
	  doc "Document"
	  docType "DocumentType"
	  newAttr "Attr"
	  inserted "Node"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docType := doc  doctype.
	newAttr := doc  createAttribute:'xml:lang' ns:'http://www.w3.org/XML/1998/namespace'.
	"assertDOMException..."
	self should:[
	doc  insert:newAttr before: docType.
	] raise: DOMException.
	self assert: (lastException code == DOMException HIERARCHY_REQUEST_ERR).
	"end of assertDOMException..."

!

test_nodeinsertbefore04
	"
	Using insertBefore on this Document node attempt to insert this Document node before
	this DocumentType node and verify if a HIERARCHY_REQUEST_ERR is raised.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-952280727
	"
	|
	  doc "Document"
	  docType "DocumentType"
	  inserted "Node"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docType := doc  doctype.
	"assertDOMException..."
	self should:[
	doc  insert:doc before: docType.
	] raise: DOMException.
	self assert: (lastException code == DOMException HIERARCHY_REQUEST_ERR).
	"end of assertDOMException..."

!

test_nodeinsertbefore05
	"
    Attempt to insert a second DocumentType node in a document using Node.insertBefore,
    should raise either DOMException with either a HIERARCHY_REQUEST_ERR 
    or NOT_SUPPORTED_ERR code.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-952280727
	"
	|
	  doc "Document"
	  docType "DocumentType"
	  domImpl "DOMImplementation"
	  newDocType "DocumentType"
	  inserted "Node"
	  nullPubId "String"
	  nullSysId "String"
	  rootName "String"
	|
	nullPubId := nil.
	nullSysId := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docType := doc  doctype.
	rootName := docType  name.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	newDocType := domImpl  createDocumentType:rootName publicId:nullPubId systemId:nullSysId.
	"try"
	[
	doc  insert:newDocType before: docType.
self assert:false.	] on: DOMException do: [:ex|	].
	"end of try"

!

test_nodeinsertbefore06
	"
	Using insertBefore on this Document node attempt to insert an Element node before
	the existing element node and verify if a HIERARCHY_REQUEST_ERR or NOT_SUPPORTED_ERR is raised.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-952280727
		Subject http://www.w3.org/Bugs/Public/show_bug.cgi?id=415
	"
	|
	  doc "Document"
	  docElem "Element"
	  newElem "Element"
	  inserted "Node"
	  rootNS "String"
	  rootTagname "String"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docElem := doc  documentElement.
	rootNS := docElem  namespaceURI.
	rootTagname := docElem  tagName.
	newElem := doc  createElement:rootTagname ns:rootNS.
	"try"
	[
	doc  insert:newElem before: docElem.
self assert:false.	] on: DOMException do: [:ex|	].
	"end of try"

!

test_nodeinsertbefore07
	"



	Using insertBefore on this Document node attempt to insert a Comment node created by
	another Document before this DocumentElement node and verify if a WRONG_DOCUMENT_ERR 
	is raised.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-952280727
	"
	|
	  doc "Document"
	  docAlt "Document"
	  docElem "Element"
	  newComment "Comment"
	  inserted "Node"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docAlt :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docElem := doc  documentElement.
	newComment := docAlt  createComment:'Comment'.
	"assertDOMException..."
	self should:[
	doc  insert:newComment before: docElem.
	] raise: DOMException.
	self assert: (lastException code == DOMException WRONG_DOCUMENT_ERR).
	"end of assertDOMException..."

!

test_nodeinsertbefore08
	"



	Using insertBefore on this Document node attempt to insert a Comment node created by
	this Document before another Document's DocumentElement node and verify if a 
	NOT_FOUND_ERR is raised.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-952280727
	"
	|
	  doc "Document"
	  docAlt "Document"
	  docElem "Element"
	  newComment "Comment"
	  inserted "Node"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docAlt :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docElem := docAlt  documentElement.
	newComment := doc  createComment:'Comment'.
	"assertDOMException..."
	self should:[
	doc  insert:newComment before: docElem.
	] raise: DOMException.
	self assert: (lastException code == DOMException NOT_FOUND_ERR).
	"end of assertDOMException..."

!

test_nodeinsertbefore09
	"
	The method insertBefore inserts the node newChild before the existing child node refChild. 
	If refChild is null, insert newChild at the end of the list of children.
	If newChild is a DocumentFragment object, all of its children are inserted, in the same 
	order, before refChild.

	Using insertBefore on this Document node attempt to insert a new DocumentFragment node 
	before a Comment node and verify the contents of the Comment node that is a child 
	of the DocumentFragment.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-952280727
	"
	|
	  doc "Document"
	  docFrag "DocumentFragment"
	  newComment "Comment"
	  insertComment "Comment"
	  comment "Comment"
	  inserted "DocumentFragment"
	  data "String"
	  appendedChild "Node"
	|
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	newComment := doc  createComment:'Comment'.
	appendedChild := doc  appendChild:newComment.
	docFrag := doc  createDocumentFragment.
	insertComment := doc  createComment:'insertComment'.
	appendedChild := docFrag  appendChild:insertComment.
	doc  insert:docFrag before: newComment.
	comment := newComment  previousSibling.
	data := comment  data.
	self assert: ( data = 'insertComment' ).

!

test_nodeinsertbefore10
	"
	Using insertBefore on this Document node attempt to insert a new Element node before
	another Element node and verify a DOMException with a 
	HIERARCHY_REQUEST_ERR, NOT_FOUND_ERR or NOT_SUPPORTED_ERR is raised.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-952280727
		Subject http://www.w3.org/Bugs/Public/show_bug.cgi?id=415
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  elem "Element"
	  newElem "Element"
	  inserted "Node"
	  docElem "Element"
	  rootNS "String"
	  rootTagname "String"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docElem := doc  documentElement.
	rootNS := docElem  namespaceURI.
	rootTagname := docElem  tagName.
	elemList := doc  getElementsByTagName: 'p'.
	elem := elemList  item:1.
	newElem := doc  createElement:rootTagname ns:rootNS.
	"try"
	[
	doc  insert:newElem before: elem.
self assert:false.	] on: DOMException do: [:ex|	].
	"end of try"

!

test_nodeinsertbefore11
	"



	Using insertBefore on a DocumentFragment node attempt to insert a child nodes before
	other permissible nodes and verify the contents/name of each inserted node.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-952280727
	"
	|
	  doc "Document"
	  docFrag "DocumentFragment"
	  elem "Element"
	  pi "ProcessingInstruction"
	  comment "Comment"
	  txt "Text"
	  cdata "CDATASection"
	  eRef "EntityReference"
	  inserted "Node"
	  insertedVal "String"
	  appendedChild "Node"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docFrag := doc  createDocumentFragment.
	elem := doc  createElement:'body' ns:'http://www.w3.org/1999/xhtml'.
	pi := doc  createProcessingInstruction:'PITarget' data:'PIData'.
	comment := doc  createComment:'Comment'.
	txt := doc  createTextNode:'Text'.
	cdata := doc  createCDATASection:'CDATA'.
	eRef := doc  createEntityReference:'alpha'.
	appendedChild := docFrag  appendChild:elem.
	appendedChild := docFrag  appendChild:pi.
	appendedChild := docFrag  appendChild:comment.
	appendedChild := docFrag  appendChild:txt.
	appendedChild := docFrag  appendChild:cdata.
	appendedChild := docFrag  appendChild:eRef.
	docFrag  insert:comment before: pi.
	insertedVal := inserted  data.
	self assert: ( insertedVal = 'Comment' ).
	docFrag  insert:txt before: comment.
	insertedVal := inserted  data.
	self assert: ( insertedVal = 'Text' ).
	docFrag  insert:cdata before: txt.
	insertedVal := inserted  data.
	self assert: ( insertedVal = 'CDATA' ).
	docFrag  insert:eRef before: cdata.
	insertedVal := inserted  nodeName.
	self assert: ( insertedVal = 'alpha' ).

!

test_nodeinsertbefore12
	"
	The method insertBefore inserts the node newChild before the existing child node refChild. 
	If refChild is null, insert newChild at the end of the list of children.

	Using insertBefore on a DocumentFragment node attempt to insert a new DocumentFragment node 
	before this DocumentFragment's Element node and verify the last child is still the only child
	appended to docFrag.   

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-952280727
	"
	|
	  doc "Document"
	  docFrag "DocumentFragment"
	  docFragNew "DocumentFragment"
	  elem "Element"
	  inserted "Node"
	  appendedChild "Node"
	  last "Node"
	  name "String"
	|
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docFrag := doc  createDocumentFragment.
	docFragNew := doc  createDocumentFragment.
	elem := doc  createElement:'dom3:elem' ns:'http://www.w3.org/DOM/Test'.
	appendedChild := docFrag  appendChild:elem.
	docFrag  insert:docFragNew before: elem.
	last := docFrag  lastChild.
	name := last  nodeName.
	self assert: ( name = 'dom3:elem' ).

!

test_nodeinsertbefore13
	"



	Using insertBefore on a DocumentFragment node attempt to insert a new Element node 
	created by another Document, before this DocumentFragment's Element node and 
	verify if a WRONG_DOCUMENT_ERR is raised. 

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-952280727
	"
	|
	  doc "Document"
	  docAlt "Document"
	  docFrag "DocumentFragment"
	  elemAlt "Element"
	  elem "Element"
	  appendedChild "Node"
	  inserted "Node"
	  docElem "Element"
	  rootNS "String"
	  rootTagname "String"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docElem := doc  documentElement.
	rootNS := docElem  namespaceURI.
	rootTagname := docElem  tagName.
	docAlt :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docFrag := doc  createDocumentFragment.
	elem := doc  createElement:rootTagname ns:rootNS.
	elemAlt := docAlt  createElement:rootTagname ns:rootNS.
	appendedChild := docFrag  appendChild:elem.
	"assertDOMException..."
	self should:[
	docFrag  insert:elemAlt before: elem.
	] raise: DOMException.
	self assert: (lastException code == DOMException WRONG_DOCUMENT_ERR).
	"end of assertDOMException..."

!

test_nodeinsertbefore14
	"
	The method insertBefore inserts the node newChild before the existing child node refChild. 
	If refChild is null, insert newChild at the end of the list of children.
	A NO_MODIFICATION_ALLOWED_ERR is raised if the node is read-only.

	Using insertBefore on this Document node attempt to insert a new Attr node before
	this DocumentType node and verfiy if a NO_MODIFICATION_ALLOWED_ERR is raised.
	(This can also raise a HIERARCHY_REQUEST_ERR and NOT_FOUND_ERR)

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-952280727
	"
	|
	  doc "Document"
	  docType "DocumentType"
	  newAttr "Attr"
	  inserted "Node"
	|
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docType := doc  doctype.
	newAttr := doc  createAttribute:'dom3:attr' ns:'http://www.w3.org/DOM/Test'.
	"assertDOMException..."
	self should:[
	docType  insert:newAttr before: docType.
	] raise: DOMException.
	self assert: (lastException code == DOMException NO_MODIFICATION_ALLOWED_ERR).
	"end of assertDOMException..."

!

test_nodeinsertbefore15
	"
	A NO_MODIFICATION_ALLOWED_ERR is raised if the node is read-only.
	
	Using insertBefore on a new EntityReference node attempt to insert Element, Text,
	Comment, ProcessingInstruction and CDATASection nodes before an element child
	and verify if a NO_MODIFICATION_ALLOWED_ERR is thrown.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-952280727
	"
	|
	  doc "Document"
	  entRef "EntityReference"
	  elemChild "Node"
	  txt "Text"
	  elem "Element"
	  comment "Comment"
	  pi "ProcessingInstruction"
	  cdata "CDATASection"
	  inserted "Node"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	entRef := doc  createEntityReference:'delta'.
	elemChild := entRef  firstChild.
	cdata := doc  createCDATASection:'CDATASection'.
	"assertDOMException..."
	self should:[
	entRef  insert:cdata before: elemChild.
	] raise: DOMException.
	self assert: (lastException code == DOMException NO_MODIFICATION_ALLOWED_ERR).
	"end of assertDOMException..."
	pi := doc  createProcessingInstruction:'target' data:'data'.
	"assertDOMException..."
	self should:[
	entRef  insert:pi before: elemChild.
	] raise: DOMException.
	self assert: (lastException code == DOMException NO_MODIFICATION_ALLOWED_ERR).
	"end of assertDOMException..."
	comment := doc  createComment:'Comment'.
	"assertDOMException..."
	self should:[
	entRef  insert:comment before: elemChild.
	] raise: DOMException.
	self assert: (lastException code == DOMException NO_MODIFICATION_ALLOWED_ERR).
	"end of assertDOMException..."
	txt := doc  createTextNode:'Text'.
	"assertDOMException..."
	self should:[
	entRef  insert:txt before: elemChild.
	] raise: DOMException.
	self assert: (lastException code == DOMException NO_MODIFICATION_ALLOWED_ERR).
	"end of assertDOMException..."
	elem := doc  createElement:'body' ns:'http://www.w3.org/1999/xhtml'.
	"assertDOMException..."
	self should:[
	entRef  insert:elem before: elemChild.
	] raise: DOMException.
	self assert: (lastException code == DOMException NO_MODIFICATION_ALLOWED_ERR).
	"end of assertDOMException..."

!

test_nodeinsertbefore16
	"
	Using insertBefore on an Element node attempt to insert a new Element, node before its 
	first element child and verify the name of the new first child node.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-952280727
	"
	|
	  doc "Document"
	  element "Element"
	  newElem "Element"
	  refElem "Element"
	  firstChild "Node"
	  insertedElem "Element"
	  childList "NodeList"
	  nodeName "String"
	  inserted "Node"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	childList := doc  getElementsByTagName: 'p'.
	element := childList  item:0.
	firstChild := element  firstChild.
	refElem := firstChild  nextSibling.
	newElem := doc  createElement:'xhtml:br' ns:'http://www.w3.org/1999/xhtml'.
	element  insert:newElem before: refElem.
	childList := doc  getElementsByTagName: 'p'.
	element := childList  item:0.
	firstChild := element  firstChild.
	insertedElem := firstChild  nextSibling.
	nodeName := insertedElem  nodeName.
	self assert: ( nodeName = 'xhtml:br' ).

!

test_nodeinsertbefore17
	"
	The method insertBefore inserts the node newChild before the existing child node refChild. 
	If refChild is null, insert newChild at the end of the list of children.
	
	Using insertBefore on an Element node attempt to insert a text node before its 
	first element child and verify the name of the new first child node.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-952280727
	"
	|
	  doc "Document"
	  element "Element"
	  newText "Text"
	  refNode "Node"
	  firstChild "Node"
	  insertedText "Text"
	  childList "NodeList"
	  nodeName "String"
	  inserted "Node"
	|
	"implementationAttribute not supported: namespaceAware"
	"implementationAttribute not supported: expandEntityReferences"
	"implementationAttribute not supported: coalescing"
	^self. "ignoringElementContentWhitespace supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	childList := doc  getElementsByTagName: 'p' ns: '*'.
	element := childList  item:1.
	refNode := element  firstChild.
	newText := doc  createTextNode:'newText'.
	element  insert:newText before: refNode.
	insertedText := element  firstChild.
	nodeName := insertedText  nodeName.
	self assert: ( nodeName = '#text' ).

!

test_nodeinsertbefore18
	"
	The method insertBefore inserts the node newChild before the existing child node refChild. 
	If refChild is null, insert newChild at the end of the list of children.
	
	Using insertBefore on an Element node attempt to insert new Comment/PI and CDATA nodes
	before each other and verify the names of the newly inserted nodes.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-952280727
	"
	|
	  doc "Document"
	  element "Element"
	  newElem "Element"
	  newComment "Comment"
	  newPI "ProcessingInstruction"
	  newCDATA "CDATASection"
	  insertedNode "Comment"
	  data "String"
	  target "String"
	  appendedChild "Node"
	  inserted "Node"
	|
	"implementationAttribute not supported: namespaceAware"
	"implementationAttribute not supported: expandEntityReferences"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	element := doc  createElement:'element'.
	newElem := doc  createElement:'dom3:elem' ns:'http://www.w3.org/DOM'.
	newComment := doc  createComment:'Comment'.
	newCDATA := doc  createCDATASection:'CDATASection'.
	newPI := doc  createProcessingInstruction:'target' data:'data'.
	appendedChild := element  appendChild:newElem.
	appendedChild := element  appendChild:newComment.
	appendedChild := element  appendChild:newPI.
	appendedChild := element  appendChild:newCDATA.
	element  insert:newComment before: newElem.
	insertedNode := element  firstChild.
	data := insertedNode  data.
	self assert: ( data = 'Comment' ).

!

test_nodeinsertbefore19
	"
	Using insertBefore on an Element node attempt to insert an EntityReference node, before 
	another new EntityReference node and verify the name of the new first child node.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-952280727
	"
	|
	  doc "Document"
	  refNode "Node"
	  newNode "EntityReference"
	  inserted "EntityReference"
	  childList "NodeList"
	  nodeName "String"
	  element "Element"
	|
	"implementationAttribute not supported: expandEntityReferences"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	childList := doc  getElementsByTagName: 'var'.
	element := childList  item:2.
	refNode := element  firstChild.
	newNode := doc  createEntityReference:'alpha'.
	element  insert:newNode before: refNode.
	nodeName := inserted  nodeName.
	self assert: ( nodeName = 'alpha' ).

!

test_nodeinsertbefore20
	"
	Using insertBefore on an Element node attempt to insert a new Attr node, before 
	an EntityReference child and verify if a HIERARCHY_REQUEST_ERR is raised.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-952280727
	"
	|
	  doc "Document"
	  element "Element"
	  refNode "Node"
	  newNode "Attr"
	  childList "NodeList"
	  inserted "Node"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	childList := doc  getElementsByTagName: 'var'.
	element := childList  item:2.
	refNode := element  firstChild.
	newNode := doc  createAttribute:'xml:lang' ns:'http://www.w3.org/XML/1998/namespace'.
	"assertDOMException..."
	self should:[
	element  insert:newNode before: refNode.
	] raise: DOMException.
	self assert: (lastException code == DOMException HIERARCHY_REQUEST_ERR).
	"end of assertDOMException..."

!

test_nodeinsertbefore21
	"
	Using insertBefore on an Element node attempt to insert the parent Element node, before 
	an EntityReference or Text child and verify if a HIERARCHY_REQUEST_ERR is raised.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-952280727
	"
	|
	  doc "Document"
	  element "Element"
	  refNode "Node"
	  newNode "Element"
	  childList "NodeList"
	  inserted "Node"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	childList := doc  getElementsByTagName: 'var'.
	element := childList  item:2.
	refNode := element  firstChild.
	newNode := element  parentNode.
	"assertDOMException..."
	self should:[
	element  insert:newNode before: refNode.
	] raise: DOMException.
	self assert: (lastException code == DOMException HIERARCHY_REQUEST_ERR).
	"end of assertDOMException..."

!

test_nodeinsertbefore22
	"
	Using insertBefore on an Element node attempt to insert the ancestor of an Element node 
	before its child and verify if a HIERARCHY_REQUEST_ERR is raised.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-952280727
	"
	|
	  doc "Document"
	  element "Element"
	  refNode "Element"
	  ancestor "Element"
	  childList "NodeList"
	  appendedChild "Node"
	  inserted "Node"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	element := doc  createElement:'xhtml:body' ns:'http://www.w3.org/1999/xhtml'.
	refNode := doc  createElement:'xhtml:a' ns:'http://www.w3.org/1999/xhtml'.
	ancestor := doc  createElement:'xhtml:p' ns:'http://www.w3.org/1999/xhtml'.
	appendedChild := element  appendChild:refNode.
	appendedChild := ancestor  appendChild:element.
	"assertDOMException..."
	self should:[
	element  insert:ancestor before: refNode.
	] raise: DOMException.
	self assert: (lastException code == DOMException HIERARCHY_REQUEST_ERR).
	"end of assertDOMException..."

!

test_nodeinsertbefore23
	"
	Using insertBefore on an Element node attempt to insert a Text node created by a different
	Document before an Element child and verify if a WRONG_DOCUMENT_ERR is raised.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-952280727
	"
	|
	  doc "Document"
	  doc2 "Document"
	  element "Element"
	  refNode "Element"
	  newNode "Text"
	  childList "NodeList"
	  appendedChild "Node"
	  inserted "Node"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	doc2 :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	element := doc  createElement:'xhtml:body' ns:'http://www.w3.org/1999/xhtml'.
	refNode := doc  createElement:'xhtml:p' ns:'http://www.w3.org/1999/xhtml'.
	newNode := doc2  createTextNode:'TextNode'.
	appendedChild := element  appendChild:refNode.
	"assertDOMException..."
	self should:[
	element  insert:newNode before: refNode.
	] raise: DOMException.
	self assert: (lastException code == DOMException WRONG_DOCUMENT_ERR).
	"end of assertDOMException..."

!

test_nodeinsertbefore24
	"
	Using insertBefore on an Element node attempt to insert a Comment node before 
	a CDATASection node that is not a child and verify if a NOT_FOUND_ERR is raised.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-952280727
	"
	|
	  doc "Document"
	  element "Element"
	  refNode "CDATASection"
	  newNode "Comment"
	  childList "NodeList"
	  inserted "Node"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	element := doc  createElement:'xhtml:p' ns:'http://www.w3.org/1999/xhtml'.
	refNode := doc  createCDATASection:'CDATASection'.
	newNode := doc  createComment:'Comment'.
	"assertDOMException..."
	self should:[
	element  insert:newNode before: refNode.
	] raise: DOMException.
	self assert: (lastException code == DOMException NOT_FOUND_ERR).
	"end of assertDOMException..."

!

test_nodeinsertbefore25
	"
	Using insertBefore on a child Element of an EntityReference node attempt to insert 
	a new Element node, before a Text node child of an Entity Node's replacement 
	text and verify if a NO_MODIFICATION_ALLOWED_ERR is raised.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-952280727
	"
	|
	  doc "Document"
	  element "Element"
	  eRef "EntityReference"
	  span "Element"
	  spanText "Text"
	  newNode "Element"
	  childList "NodeList"
	  inserted "Node"
	|
	"implementationAttribute not supported: expandEntityReferences"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	childList := doc  getElementsByTagName: 'var'.
	element := childList  item:2.
	eRef := element  firstChild.
	span := eRef  firstChild.
	self assert: span notNil.
	spanText := span  firstChild.
	self assert: spanText notNil.
	newNode := doc  createElement:'span' ns:'http://www.w3.org/1999/xhtml'.
	"assertDOMException..."
	self should:[
	span  insert:newNode before: spanText.
	] raise: DOMException.
	self assert: (lastException code == DOMException NO_MODIFICATION_ALLOWED_ERR).
	"end of assertDOMException..."

!

test_nodeisdefaultnamespace01
        "
        Using isDefaultNamespace on this Document node with the
        namespace of the document element check if the value returned is true.

                Creator: IBM
                Autor Neil Delima
                Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-isDefaultNamespace
        "
        |
          doc "Document"
          isDefault "Boolean"
          docElem "Element"
          docElemNS "String"
        |
        "implementationAttribute not supported: namespaceAware"
        doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
        docElem := doc  documentElement.
        docElemNS := docElem  namespaceURI.
        isDefault := doc  isDefaultNamespace: docElemNS.
        self assert: isDefault.

!

test_nodeisdefaultnamespace02
        "
        Using isDefaultNamespace on on a new Document node with the value of the namespaceURI 
        parameter equal to the namespaceURI of the newly created Document and check if the 
        value returned is false.

                Creator: IBM
                Autor Neil Delima
                Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-isDefaultNamespace
        "
        |
          doc "Document"
          domImpl "DOMImplementation"
          newDoc "Document"
          isDefault "Boolean"
          nullDocType "DocumentType"
          nullNSURI "String"
          docElem "Element"
          rootNS "String"
          rootName "String"
        |
        "implementationAttribute not supported: namespaceAware"
        nullDocType := nil.
        nullNSURI := nil.
        doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
        docElem := doc  documentElement.
        rootNS := docElem  namespaceURI.
        rootName := docElem  localName.
        domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
        newDoc := domImpl createDocumentNS: rootNS qualifiedName: rootName doctype: nullDocType.
        isDefault := newDoc  isDefaultNamespace: rootNS.
        self assert: isDefault.
        isDefault := newDoc  isDefaultNamespace: nullNSURI.
        self deny: isDefault.

!

test_nodeisdefaultnamespace03
        "



        Using isDefaultNamespace on this DocumentType node with the value of the namespaceURI parameter
        as null check if the value returned is false.

                Creator: IBM
                Autor Neil Delima
                Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-isDefaultNamespace
        "
        |
          doc "Document"
          docType "DocumentType"
          isDefault "Boolean"
          nullNSURI "String"
        |
        "implementationAttribute not supported: namespaceAware"
        nullNSURI := nil.
        doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
        docType := doc  doctype.
        isDefault := docType  isDefaultNamespace: nullNSURI.
        self deny: isDefault.

!

test_nodeisdefaultnamespace04
	"



	Using isDefaultNamespace on a Notation and Entity node with the value of the namespaceURI parameter
	as null check if the value returned is false.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-isDefaultNamespace
	"
	|
	  doc "Document"
	  docType "DocumentType"
	  entity "Entity"
	  notation "Notation"
	  entitiesMap "NamedNodeMap"
	  notationsMap "NamedNodeMap"
	  isDefault "Boolean"
	  nullNSURI "String"
	|
	"implementationAttribute not supported: namespaceAware"
	nullNSURI := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docType := doc  doctype.
	entitiesMap := docType  entities.
	notationsMap := docType  notations.
	entity := entitiesMap  getNamedItem:'alpha'.
	notation := notationsMap  getNamedItem:'notation1'.
	isDefault := entity  isDefaultNamespace.
	self deny: isDefault.
	isDefault := notation  isDefaultNamespace.
	self deny: isDefault.

!

test_nodeisdefaultnamespace05
        "
        Using isDefaultNamespace on a DocumentElement of a new Document node with the value of the 
        namespaceURI parameter equal to the namespaceURI of the newly created Document and check if the 
        value returned is false.

                Creator: IBM
                Autor Neil Delima
                Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-isDefaultNamespace
        "
        |
          doc "Document"
          elem "Element"
          domImpl "DOMImplementation"
          newDoc "Document"
          isDefault "Boolean"
          nullDocType "DocumentType"
          nullNSURI "String"
          docElem "Element"
          rootNS "String"
          rootName "String"
        |
        "implementationAttribute not supported: namespaceAware"
        nullDocType := nil.
        nullNSURI := nil.
        doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
        docElem := doc  documentElement.
        rootNS := docElem  namespaceURI.
        rootName := docElem  localName.
        domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
        newDoc := domImpl createDocumentNS: rootNS qualifiedName: rootName doctype: nullDocType.
        elem := newDoc  documentElement.
        isDefault := elem  isDefaultNamespace: rootNS.
        self assert: isDefault.
        isDefault := elem  isDefaultNamespace: nullNSURI.
        self deny: isDefault.

!

test_nodeisdefaultnamespace06
        "
        Using isDefaultNamespace on an Element node with no prefix, which has a namespace
        attribute declaration with and without a namespace prefix and check if isDefaultNamespace 
        returns true with the namespaceURI that does not have a prefix as its parameter.

                Creator: IBM
                Autor Neil Delima
                Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-isDefaultNamespace
        "
        |
          doc "Document"
          elem "Element"
          elemList "NodeList"
          isDefault "Boolean"
        |
        "implementationAttribute not supported: namespaceAware"
        doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
        elemList := doc  getElementsByTagName: 'p'.
        elem := elemList  item:0.
        isDefault := elem  isDefaultNamespace: 'http://www.w3.org/1999/xhtml'.
        self assert: isDefault.
        isDefault := elem  isDefaultNamespace: 'http://www.usa.com'.
        self deny: isDefault.

!

test_nodeisdefaultnamespace07
        "
        Using isDefaultNamespace on the child of an Element node with no prefix, which has a 
        namespace attribute declaration with and without a namespace prefix and check if isDefaultNamespace 
        returns true with the namespaceURI that does not have a prefix as its parameter.

                Creator: IBM
                Autor Neil Delima
                Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-isDefaultNamespace
        "
        |
          doc "Document"
          elem "Element"
          elemList "NodeList"
          isDefault "Boolean"
        |
        "implementationAttribute not supported: namespaceAware"
        doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
        elemList := doc  getElementsByTagName: 'acronym'.
        elem := elemList  item:0.
        isDefault := elem  isDefaultNamespace: 'http://www.w3.org/1999/xhtml'.
        self assert: isDefault.
        isDefault := elem  isDefaultNamespace: 'http://www.usa.com'.
        self deny: isDefault.

!

test_nodeisdefaultnamespace08
        "



        Using isDefaultNamespace on an Element node with a prefix, which has a namespace 
        attribute declaration with a namespace prefix and check if isDefaultNamespace 
        returns false with this namespaceURI as its parameter.

                Creator: IBM
                Autor Neil Delima
                Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-isDefaultNamespace
        "
        |
          doc "Document"
          elem "Element"
          elemList "NodeList"
          isDefault "Boolean"
        |
        "implementationAttribute not supported: namespaceAware"
        doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
        elemList := doc  getElementsByTagName: 'strong'.
        elem := elemList  item:3.
        isDefault := elem  isDefaultNamespace: 'http://www.altavista.com'.
        self deny: isDefault.

!

test_nodeisdefaultnamespace09
        "
        Using isDefaultNamespace on a new Child of a new Element node with a namespace URI
        and prefix and using the parents namespace URI as an argument, verify if the 
        value returned is false.

                Creator: IBM
                Autor Neil Delima
                Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-isDefaultNamespace
        "
        |
          doc "Document"
          parent "Element"
          child "Element"
          isDefault "Boolean"
          appendedChild "Node"
        |
        "implementationAttribute not supported: namespaceAware"
        doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
        parent := doc  createElement:'xhtml:body' ns:'http://www.w3.org/1999/xhtml'.
        child := doc  createElement:'xhtml:p'.
        appendedChild := parent  appendChild:child.
        isDefault := parent  isDefaultNamespace: 'http://www.w3.org/1999/xhtml'.
        self deny: isDefault.
        isDefault := child  isDefaultNamespace: 'http://www.w3.org/1999/xhtml'.
        self deny: isDefault.

!

test_nodeisdefaultnamespace10
        "
        Using isDefaultNamespace on a new Child of a new Element node with a namespace URI
        and prefix and using the childs namespace URI as an argument, verify if the 
        value returned is true.

                Creator: IBM
                Autor Neil Delima
                Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-isDefaultNamespace
        "
        |
          doc "Document"
          parent "Element"
          child "Element"
          isDefault "Boolean"
          appendedChild "Node"
        |
        "implementationAttribute not supported: namespaceAware"
        doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
        parent := doc  createElement:'xhtml:body' ns:'http://www.w3.org/1999/xhtml'.
        child := doc  createElement:'p' ns:'http://www.w3.org/1999/xhtml'.
        appendedChild := parent  appendChild:child.
        isDefault := child  isDefaultNamespace: 'http://www.w3.org/1999/xhtml'.
        self assert: isDefault.
        isDefault := parent  isDefaultNamespace: 'http://www.w3.org/1999/xhtml'.
        self deny: isDefault.

!

test_nodeisdefaultnamespace11
        "
        Using isDefaultNamespace on an imported new Element node with a namespace URI and prefix 
        in a new Document and using the parent's namespace URI as an argument, verify if the 
        value returned is true.

                Creator: IBM
                Autor Neil Delima
                Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-isDefaultNamespace
        "
        |
          doc "Document"
          domImpl "DOMImplementation"
          newDoc "Document"
          elem "Element"
          importedNode "Element"
          isDefault "Boolean"
          nullDocType "DocumentType"
          docElem "Element"
          rootNS "String"
          rootName "String"
        |
        "implementationAttribute not supported: namespaceAware"
        nullDocType := nil.
        doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
        docElem := doc  documentElement.
        rootNS := docElem  namespaceURI.
        rootName := docElem  tagName.
        domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
        newDoc := domImpl createDocumentNS: rootNS qualifiedName: rootName doctype: nullDocType.
        elem := doc  createElement:'p' ns:'http://www.w3.org/1999/xhtml'.
        importedNode := newDoc  importNode:elem deep:true.
        isDefault := importedNode  isDefaultNamespace: 'http://www.w3.org/1999/xhtml'.
        self assert: isDefault.

!

test_nodeisdefaultnamespace13
        "
        Using isDefaultNamespace on a Element's new Text node, which has a namespace attribute 
        declaration without a namespace prefix in its parent Element node and  verify if the 
        value returned is true.

                Creator: IBM
                Autor Neil Delima
                Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-isDefaultNamespace
        "
        |
          doc "Document"
          bodyElem "Element"
          elem "Element"
          txt "Text"
          isDefault "Boolean"
          appendedChild "Node"
          bodyList "NodeList"
        |
        "implementationAttribute not supported: namespaceAware"
        doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
        bodyList := doc  getElementsByTagName: 'body'.
        bodyElem := bodyList  item:0.
        elem := doc  createElement:'p' ns:'http://www.w3.org/1999/xhtml'.
        txt := doc  createTextNode:'Text'.
        appendedChild := elem  appendChild:txt.
        appendedChild := bodyElem  appendChild:elem.
        isDefault := txt  isDefaultNamespace: 'http://www.w3.org/1999/xhtml'.
        self assert: isDefault.

!

test_nodeisdefaultnamespace14
        "
        Using isDefaultNamespace on a Element's new CDATASection node, which has a namespace attribute 
        declaration without a namespace prefix in its parent Element node and  verify if the 
        value returned is true.

                Creator: IBM
                Autor Neil Delima
                Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-isDefaultNamespace
        "
        |
          doc "Document"
          elem "Element"
          cdata "CDATASection"
          isDefault "Boolean"
          appendedChild "Node"
          bodyList "NodeList"
          bodyElem "Element"
        |
        doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
        bodyList := doc  getElementsByTagName: 'body'.
        bodyElem := bodyList  item:0.
        elem := doc  createElement:'p' ns:'http://www.w3.org/1999/xhtml'.
        cdata := doc  createCDATASection:'CDATASection'.
        appendedChild := elem  appendChild:cdata.
        appendedChild := bodyElem  appendChild:elem.
        isDefault := cdata  isDefaultNamespace: 'http://www.w3.org/1999/xhtml'.
        self assert: isDefault.

!

test_nodeisdefaultnamespace15
        "
        Using isDefaultNamespace on a Element's new cloned Comment node, which has a namespace attribute 
        declaration without a namespace prefix in its parent Element node and  verify if the 
        value returned is true.

                Creator: IBM
                Autor Neil Delima
                Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-isDefaultNamespace
        "
        |
          doc "Document"
          bodyElem "Element"
          elem "Element"
          comment "Comment"
          clonedComment "Comment"
          isDefault "Boolean"
          appendedChild "Node"
          bodyList "NodeList"
        |
        doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
        bodyList := doc  getElementsByTagName: 'body'.
        bodyElem := bodyList  item:0.
        elem := doc  createElement:'p' ns:'http://www.w3.org/1999/xhtml'.
        comment := doc  createComment:'Text'.
        clonedComment := comment  cloneNode:true.
        appendedChild := elem  appendChild:clonedComment.
        appendedChild := bodyElem  appendChild:elem.
        isDefault := clonedComment  isDefaultNamespace: 'http://www.w3.org/1999/xhtml'.
        self assert: isDefault.

!

test_nodeisdefaultnamespace16
        "
        Using isDefaultNamespace on a new Attribute node with with a namespace URI
        and no prefix and  verify if the value returned is false since default namespaces
        do not apply directly to attributes.

                Creator: IBM
                Autor Neil Delima
                Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-isDefaultNamespace
        "
        |
          doc "Document"
          attr "Attr"
          isDefault "Boolean"
        |
        doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
        attr := doc  createAttribute:'lang' ns:'http://www.w3.org/XML/1998/namespace'.
        isDefault := attr  isDefaultNamespace: 'http://www.w3.org/1999/xhtml'.
        self deny: isDefault.

!

test_nodeisequalnode01
	"

	
	Using isEqualNode check if 2 Document nodes created by parsing the same xml document
	are equal.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-isEqualNode
	"
	|
	  doc1 "Document"
	  doc2 "Document"
	  isEqual "Boolean"
	|
	doc1 :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	doc2 :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	isEqual := doc1  isEqualNode:doc2.
	self assert: isEqual.

!

test_nodeisequalnode02
	"
	Using isEqualNode check if 2 newly created Document nodes having the same namespaceURI
	and qualifiedName are equal.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-isEqualNode
	"
	|
	  doc "Document"
	  domImpl "DOMImplementation"
	  doc1 "Document"
	  doc2 "Document"
	  isEqual "Boolean"
	  nullDocType "DocumentType"
	  docElem "Element"
	  rootNS "String"
	  rootName "String"
	|
	nullDocType := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docElem := doc  documentElement.
	rootNS := docElem  namespaceURI.
	rootName := docElem  tagName.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	doc1 := domImpl createDocumentNS: rootNS qualifiedName: rootName doctype: nullDocType.
	doc2 := domImpl createDocumentNS: rootNS qualifiedName: rootName doctype: nullDocType.
	isEqual := doc1  isEqualNode:doc2.
	self assert: isEqual.

!

test_nodeisequalnode03
	"
	Using isEqualNode check if 2 Document nodes created by parsing
	documents only differing in declared encoding return false for isEqualNode on
	the document and true on the document element.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-isEqualNode
		Subject http://www.w3.org/Bugs/Public/show_bug.cgi?id=528
	"
	|
	  doc1 "Document"
	  doc2 "Document"
	  docElem1 "Element"
	  docElem2 "Element"
	  isEqual "Boolean"
	|
	doc1 :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo_utf8').
	doc2 :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo_utf16').
	isEqual := doc1  isEqualNode:doc2.
	self assert: isEqual.
	docElem1 := doc1  documentElement.
	docElem2 := doc2  documentElement.
	isEqual := docElem1  isEqualNode:docElem2.
	self assert: isEqual.

!

test_nodeisequalnode04
	"
	Create a new Element node in this Document.  return its ownerDocument and check if the
	the ownerDocument is equal to this Document using isEqualNode.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-isEqualNode
	"
	|
	  doc "Document"
	  ownerDoc "Document"
	  elem "Element"
	  isEqual "Boolean"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	elem := doc  createElement:'xhtml:p' ns:'http://www.w3.org/1999/xhtml'.
	ownerDoc := elem  ownerDocument.
	isEqual := doc  isEqualNode:ownerDoc.
	self assert: isEqual.

!

test_nodeisequalnode05
	"
	Using isEqualNode check if 2 Document nodes created by parsing different xml document
	are equal.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-isEqualNode
	"
	|
	  doc1 "Document"
	  doc2 "Document"
	  isEqual "Boolean"
	|
	doc1 :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo_standalone_yes').
	doc2 :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	isEqual := doc1  isEqualNode:doc2.
	self deny: isEqual.

!

test_nodeisequalnode06
	"

	
	Using isEqualNode check if 2 Element nodes having the same nodeName and namespaceURI attribute
	are equal.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-isEqualNode
	"
	|
	  doc "Document"
	  elem1 "Element"
	  elem2 "Element"
	  isEqual "Boolean"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elem1 := doc  createElement:'xhtml:html' ns:'http://www.w3.org/1999/xhtml'.
	elem2 := doc  createElement:'xhtml:html' ns:'http://www.w3.org/1999/xhtml'.
	isEqual := elem1  isEqualNode:elem2.
	self assert: isEqual.

!

test_nodeisequalnode07
	"
	Using isEqualNode check if 2 Element nodes having the same nodeName and namespaceURI attribute
	created by two different Document objects obtained by parsing the same xml document are equal.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-isEqualNode
	"
	|
	  doc1 "Document"
	  doc2 "Document"
	  elem1 "Element"
	  elem2 "Element"
	  isEqual "Boolean"
	|
	doc1 :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	doc2 :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elem1 := doc1  createElement:'xhtml:html' ns:'http://www.w3.org/1999/xhtml'.
	elem2 := doc2  createElement:'xhtml:html' ns:'http://www.w3.org/1999/xhtml'.
	isEqual := elem1  isEqualNode:elem2.
	self assert: isEqual.

!

test_nodeisequalnode08
	"

	
	Retreive an element node of this Document having nodeName as employeeId and 
	namespaceURI as http://www.nist.gov.  Create a new Element node having the same attributes
	in this Document and using isEqualNode check if 2 Element nodes are equal.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-isEqualNode
	"
	|
	  doc "Document"
	  elem1 "Element"
	  elem2 "Element"
	  employeeList "NodeList"
	  text "Text"
	  isEqual "Boolean"
	  appendedChild "Node"
	|
	"implementationAttribute not supported: namespaceAware"
	^self. "ignoringElementContentWhitespace supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	employeeList := doc  getElementsByTagName: 'em'.
	elem1 := employeeList  item:0.
	elem2 := doc  createElement:'em' ns:'http://www.w3.org/1999/xhtml'.
	text := doc  createTextNode:'EMP0001'.
	appendedChild := elem2  appendChild:text.
	isEqual := elem1  isEqualNode:elem2.
	self assert: isEqual.

!

test_nodeisequalnode09
	"
Get the first  em  node, construct an equivalent in a new document and see if isEqualNode
returns true.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-isEqualNode
	"
	|
	  doc "Document"
	  domImpl "DOMImplementation"
	  newDoc "Document"
	  elem1 "Element"
	  elem2 "Element"
	  employeeList "NodeList"
	  text "Text"
	  isEqual "Boolean"
	  nullDocType "DocumentType"
	  appendedChild "Node"
	  docElem "Element"
	  rootNS "String"
	  rootName "String"
	|
	"implementationAttribute not supported: namespaceAware"
	^self. "ignoringElementContentWhitespace supported"
	nullDocType := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docElem := doc  documentElement.
	rootNS := docElem  namespaceURI.
	rootName := docElem  localName.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	newDoc := domImpl createDocumentNS: rootNS qualifiedName: rootName doctype: nullDocType.
	employeeList := doc  getElementsByTagName: 'em'.
	elem1 := employeeList  item:0.
	elem2 := newDoc  createElement:'em' ns:'http://www.w3.org/1999/xhtml'.
	text := newDoc  createTextNode:'EMP0001'.
	appendedChild := elem2  appendChild:text.
	isEqual := elem1  isEqualNode:elem2.
	self assert: isEqual.

!

test_nodeisequalnode10
	"
	Retreive 2 different  em  nodes of this Document   Use isEqualNode 
	check if nodes are not equal.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-isEqualNode
	"
	|
	  doc "Document"
	  elem1 "Element"
	  elem2 "Element"
	  employeeList "NodeList"
	  isEqual "Boolean"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	employeeList := doc  getElementsByTagName: 'em'.
	elem1 := employeeList  item:0.
	elem2 := employeeList  item:1.
	isEqual := elem1  isEqualNode:elem2.
	self deny: isEqual.

!

test_nodeisequalnode11
	"
	Retreive the first element node whose localName is  p .  Import it into a new
	Document with deep=false.  Using isEqualNode check if the original and the imported
	Element Node are not equal the child nodes are different.
	Import with deep and the should still be unequal if
	validating since the
	new document does not provide the same default attributes.
	Import it into another instance of the source document
	and then the imported node and the source should be equal.   

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-isEqualNode
		Subject http://www.w3.org/Bugs/Public/show_bug.cgi?id=529
	"
	|
	  doc "Document"
	  domImpl "DOMImplementation"
	  employeeList "NodeList"
	  newDoc "Document"
	  dupDoc "Document"
	  elem1 "Element"
	  elem2 "Element"
	  elem3 "Element"
	  elem4 "Element"
	  isEqual "Boolean"
	  nullDocType "DocumentType"
	  docElem "Element"
	  rootNS "String"
	  rootName "String"
	|
	nullDocType := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docElem := doc  documentElement.
	rootNS := docElem  namespaceURI.
	rootName := docElem  tagName.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	newDoc := domImpl createDocumentNS: rootNS qualifiedName: rootName doctype: nullDocType.
	employeeList := doc  getElementsByTagName: 'p'.
	elem1 := employeeList  item:0.
	elem2 := newDoc  importNode:elem1 deep:false.
	isEqual := elem1  isEqualNode:elem2.
	self deny: isEqual.
	elem3 := newDoc  importNode:elem1 deep:true.
	isEqual := elem1  isEqualNode:elem3.
	"if"
	false "no template for element implementationAttribute"  ifTrue: [
		].
	dupDoc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elem4 := dupDoc  importNode:elem1 deep:true.
	isEqual := elem1  isEqualNode:elem4.
	self assert: isEqual.

!

test_nodeisequalnode12
	"

	
	Using isEqual verify if the 2 documentElement nodes of different documents created
	by parsing the same xml document are equal.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-isEqualNode
	"
	|
	  doc "Document"
	  elem1 "Element"
	  elem2 "Element"
	  isEqual "Boolean"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elem1 := doc  documentElement.
	elem2 := doc  documentElement.
	isEqual := elem1  isEqualNode:elem2.
	self assert: isEqual.

!

test_nodeisequalnode13
	"
	Retreive the first element node whose localName is  p .  Import it into a new
	Document with deep=false.  Using isEqualNode check if the original and the imported
	Element Node are not equal.  Now import it once more with deep=true and using isEqual
	verify if they are now equal.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-isEqualNode
	"
	|
	  doc "Document"
	  domImpl "DOMImplementation"
	  newDoc "Document"
	  employeeList "NodeList"
	  elem1 "Element"
	  elem2 "Element"
	  elem3 "Element"
	  isEqual "Boolean"
	  nullDocType "DocumentType"
	  docElem "Element"
	  rootNS "String"
	  rootName "String"
	|
	nullDocType := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docElem := doc  documentElement.
	rootNS := docElem  namespaceURI.
	rootName := docElem  tagName.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	newDoc := domImpl createDocumentNS: rootNS qualifiedName: rootName doctype: nullDocType.
	employeeList := doc  getElementsByTagName: 'p'.
	elem1 := employeeList  item:0.
	elem2 := elem1  cloneNode:false.
	isEqual := elem1  isEqualNode:elem2.
	self deny: isEqual.
	elem3 := elem1  cloneNode:true.
	isEqual := elem1  isEqualNode:elem3.
	self assert: isEqual.

!

test_nodeisequalnode14
	"

	
	Using isEqualNode check if 2 Attr nodes having the same nodeName and a null namespaceURI 
	attribute, one created using createAttribute and the other createAttributeNS, are not equal.
	Note the localName for an Attr created with DOM Level 1 methods is null.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-isEqualNode
	"
	|
	  doc "Document"
	  attr1 "Attr"
	  attr2 "Attr"
	  isEqual "Boolean"
	  nullNSURI "String"
	|
	nullNSURI := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	attr1 := doc  createAttribute:'root'.
	attr2 := doc  createAttribute:'root' ns:nullNSURI.
	isEqual := attr1  isEqualNode:attr2.
	self deny: isEqual.

!

test_nodeisequalnode15
	"
	Using isEqualNode check if 2 Attr nodes having the same nodeName and a null namespaceURI 
	attribute, one created using createAttributeNS and the other retreived from this document
	are equal.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-isEqualNode
	"
	|
	  doc "Document"
	  attr1 "Attr"
	  attr2 "Attr"
	  addrElement "Element"
	  elementList "NodeList"
	  isEqual "Boolean"
	  nullNS "String"
	|
	nullNS := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elementList := doc  getElementsByTagName: 'acronym'.
	addrElement := elementList  item:3.
	attr1 := addrElement  getAttributeNode: 'title' ns: nullNS.
	"if"
	false "no template for element implementationAttribute"  ifTrue: [
		].
	attr2 value:'Yes'.
	isEqual := attr1  isEqualNode:attr2.
	self assert: isEqual.

!

test_nodeisequalnode16
	"

	
	Using isEqualNode check if a default attribute node and a cloned default attribute
	node are equal.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-isEqualNode
	"
	|
	  doc "Document"
	  attr1 "Attr"
	  attr2 "Attr"
	  addrElement "Element"
	  elementList "NodeList"
	  isEqual "Boolean"
	  nullNSURI "String"
	|
	nullNSURI := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elementList := doc  getElementsByTagName: 'p'.
	addrElement := elementList  item:3.
	attr1 := addrElement  getAttributeNode: 'dir' ns: nullNSURI.
	attr2 := attr1  cloneNode:true.
	isEqual := attr1  isEqualNode:attr2.
	self assert: isEqual.

!

test_nodeisequalnode17
	"
	Using isEqualNode check if a new Attr node created in this Document is equal to 
	the imported node returned when it is imported into a new Document.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-isEqualNode
	"
	|
	  doc "Document"
	  newDoc "Document"
	  domImpl "DOMImplementation"
	  attr1 "Attr"
	  attr2 "Attr"
	  isEqual "Boolean"
	  nullDocType "DocumentType"
	  nullNSURI "String"
	  docElem "Element"
	  rootNS "String"
	  rootName "String"
	|
	nullDocType := nil.
	nullNSURI := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docElem := doc  documentElement.
	rootNS := docElem  namespaceURI.
	rootName := docElem  tagName.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	newDoc := domImpl createDocumentNS: rootNS qualifiedName: rootName doctype: nullDocType.
	attr1 := doc  createAttribute:'root' ns:nullNSURI.
	attr2 := newDoc  importNode:attr1 deep:true.
	isEqual := attr1  isEqualNode:attr2.
	self assert: isEqual.

!

test_nodeisequalnode18
	"
	Using isEqualNode check if a new Attr node created in this Document is equal to 
	the attr node adopted by a new document.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-isEqualNode
	"
	|
	  doc "Document"
	  newDoc "Document"
	  domImpl "DOMImplementation"
	  attr1 "Attr"
	  attr2 "Attr"
	  isEqual "Boolean"
	  nullDocType "DocumentType"
	  nullNSURI "String"
	  docElem "Element"
	  rootNS "String"
	  rootName "String"
	|
	nullDocType := nil.
	nullNSURI := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docElem := doc  documentElement.
	rootName := docElem  tagName.
	rootNS := docElem  namespaceURI.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	newDoc := domImpl createDocumentNS: rootNS qualifiedName: rootName doctype: nullDocType.
	attr1 := doc  createAttribute:'title' ns:nullNSURI.
	attr2 := newDoc  adoptNode: attr1.
	"if"
	( attr2 notNil )  ifTrue: [
			].

!

test_nodeisequalnode19
	"

	
	Using isEqualNode check if 2 Attr nodes having the same nodeName but different namespaceURIs 
	are not equal.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-isEqualNode
	"
	|
	  doc "Document"
	  attr1 "Attr"
	  attr2 "Attr"
	  isEqual "Boolean"
	  nullNSURI "String"
	|
	nullNSURI := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	attr1 := doc  createAttribute:'lang' ns:'http://www.w3.org/XML/1998/namespace'.
	attr2 := doc  createAttribute:'lang' ns:nullNSURI.
	isEqual := attr1  isEqualNode:attr2.
	self deny: isEqual.

!

test_nodeisequalnode20
	"
	Using isEqualNode check if an Element and an Attr nodes having the same nodeName 
	and namsepaceURI are not equal.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-isEqualNode
	"
	|
	  doc "Document"
	  attr1 "Attr"
	  elem1 "Element"
	  isEqual "Boolean"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elem1 := doc  createElement:'xhtml:html' ns:'http://www.w3.org/1999/xhtml'.
	attr1 := doc  createAttribute:'xhtml:html' ns:'http://www.w3.org/1999/xhtml'.
	isEqual := attr1  isEqualNode:elem1.
	self deny: isEqual.

!

test_nodeisequalnode21
	"

	
	Using isEqualNode check if 2 DocumentType nodes returned by parsing the same xml document
	are equal.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-isEqualNode
	"
	|
	  doc1 "Document"
	  doc2 "Document"
	  docType1 "DocumentType"
	  docType2 "DocumentType"
	  isEqual "Boolean"
	|
	doc1 :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	doc2 :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docType1 := doc1  doctype.
	docType2 := doc2  doctype.
	isEqual := docType1  isEqualNode:docType2.
	self assert: isEqual.

!

test_nodeisequalnode22
	"

	
	Using isEqualNode check if 2 new DocumentType having null public and system ids
	are equal.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-isEqualNode
	"
	|
	  doc1 "Document"
	  doc2 "Document"
	  domImpl1 "DOMImplementation"
	  domImpl2 "DOMImplementation"
	  docType1 "DocumentType"
	  docType2 "DocumentType"
	  isEqual "Boolean"
	  nullPubId "String"
	  nullSysId "String"
	  oldDocType "DocumentType"
	  rootName "String"
	|
	nullPubId := nil.
	nullSysId := nil.
	doc1 :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	oldDocType := doc1  doctype.
	rootName := oldDocType  name.
	doc2 :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	domImpl1 := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	domImpl2 := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	docType1 := domImpl1  createDocumentType:rootName publicId:nullPubId systemId:nullSysId.
	docType2 := domImpl2  createDocumentType:rootName publicId:nullPubId systemId:nullSysId.
	isEqual := docType1  isEqualNode:docType2.
	self assert: isEqual.

!

test_nodeisequalnode25
	"

	
	Using isEqualNode check if 2 EntityNode having the same name of two DocumentType nodes 
	returned by parsing the same xml document are equal.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-isEqualNode
	"
	|
	  doc1 "Document"
	  doc2 "Document"
	  docType1 "DocumentType"
	  docType2 "DocumentType"
	  entitiesMap1 "NamedNodeMap"
	  entitiesMap2 "NamedNodeMap"
	  alpha "Entity"
	  beta "Entity"
	  isEqual "Boolean"
	|
	doc1 :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	doc2 :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docType1 := doc1  doctype.
	docType2 := doc2  doctype.
	entitiesMap1 := docType1  entities.
	entitiesMap2 := docType2  entities.
	alpha := entitiesMap1  getNamedItem:'delta'.
	beta := entitiesMap2  getNamedItem:'delta'.
	isEqual := alpha  isEqualNode:beta.
	self assert: isEqual.

!

test_nodeisequalnode26
	"

	
	Using isEqualNode check if 2 NotationNode having the same name of two DocumnotationType nodes 
	returned by parsing the same xml documnotation are equal.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-isEqualNode
	"
	|
	  doc1 "Document"
	  doc2 "Document"
	  docType1 "DocumentType"
	  docType2 "DocumentType"
	  notationsMap1 "NamedNodeMap"
	  notationsMap2 "NamedNodeMap"
	  notation1 "Notation"
	  notation2 "Notation"
	  isEqual "Boolean"
	|
	doc1 :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	doc2 :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docType1 := doc1  doctype.
	docType2 := doc2  doctype.
	notationsMap1 := docType1  notations.
	notationsMap2 := docType2  notations.
	notation1 := notationsMap1  getNamedItem:'notation1'.
	notation2 := notationsMap2  getNamedItem:'notation1'.
	isEqual := notation1  isEqualNode:notation2.
	self assert: isEqual.

!

test_nodeisequalnode27
	"

	
	Using isEqualNode check if 2 EntityNode having the same name of two DocumentType nodes 
	returned by parsing the same xml document are equal.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-isEqualNode
	"
	|
	  doc "Document"
	  docType "DocumentType"
	  entitiesMap "NamedNodeMap"
	  notationsMap "NamedNodeMap"
	  alpha "Entity"
	  notation1 "Notation"
	  isEqual "Boolean"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docType := doc  doctype.
	entitiesMap := docType  entities.
	notationsMap := docType  notations.
	alpha := entitiesMap  getNamedItem:'alpha'.
	notation1 := notationsMap  getNamedItem:'notation1'.
	isEqual := notation1  isEqualNode:alpha.
	self deny: isEqual.

!

test_nodeisequalnode28
	"

	
	Using isEqualNode check if 2 new Text nodes having null text are equal and two others
	having different data are not equal.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-isEqualNode
	"
	|
	  doc "Document"
	  text1 "Text"
	  text2 "Text"
	  text3 "Text"
	  isEqual "Boolean"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	text1 := doc  createTextNode:''.
	text2 := doc  createTextNode:''.
	text3 := doc  createTextNode:'#Text'.
	isEqual := text1  isEqualNode:text2.
	self assert: isEqual.
	isEqual := text1  isEqualNode:text3.
	self deny: isEqual.

!

test_nodeisequalnode29
	"

	
	Using isEqualNode check if 2 new Comment nodes having the same data are equal and two others
	having different data are not equal.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-isEqualNode
	"
	|
	  doc "Document"
	  comment1 "Comment"
	  comment2 "Comment"
	  comment3 "Comment"
	  isEqual "Boolean"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	comment1 := doc  createComment:'comment'.
	comment2 := doc  createComment:'comment'.
	comment3 := doc  createComment:'#Comment'.
	isEqual := comment1  isEqualNode:comment2.
	self assert: isEqual.
	isEqual := comment1  isEqualNode:comment3.
	self deny: isEqual.

!

test_nodeisequalnode31
	"

	
	Using isEqualNode check if 2 new CDATASection nodes having the same data are equal and two others
	having different data are not equal.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-isEqualNode
	"
	|
	  doc "Document"
	  cdata1 "CDATASection"
	  cdata2 "CDATASection"
	  cdata3 "CDATASection"
	  isEqual "Boolean"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	cdata1 := doc  createCDATASection:'cdata'.
	cdata2 := doc  createCDATASection:'cdata'.
	cdata3 := doc  createCDATASection:'#CDATASection'.
	isEqual := cdata1  isEqualNode:cdata2.
	self assert: isEqual.
	isEqual := cdata1  isEqualNode:cdata3.
	self deny: isEqual.

!

test_nodeisequalnode32
	"

	
	Using isEqualNode check if 2 new ProcessingInstruction nodes having the same data are equal and two others
	having different data are not equal.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-isEqualNode
	"
	|
	  doc "Document"
	  pi1 "ProcessingInstruction"
	  pi2 "ProcessingInstruction"
	  pi3 "ProcessingInstruction"
	  isEqual "Boolean"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	pi1 := doc  createProcessingInstruction:'Target1' data:'pi'.
	pi2 := doc  createProcessingInstruction:'Target1' data:'pi'.
	pi3 := doc  createProcessingInstruction:'Target1' data:'#ProcessingInstruction'.
	isEqual := pi1  isEqualNode:pi2.
	self assert: isEqual.
	isEqual := pi1  isEqualNode:pi3.
	self deny: isEqual.

!

test_nodeissamenode01
	"

	
	Using isSameNode to check if 2 Document nodes that are equal but do not reference the
	same object are not the same

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-isSameNode
	"
	|
	  doc1 "Document"
	  doc2 "Document"
	  isSame "Boolean"
	|
	doc1 :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	doc2 :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	isSame := doc1 isSameNode: doc2.
	self deny: isSame.

!

test_nodeissamenode02
	"

	
	Using isSameNode check if 2 DocumentType nodes that reference the same object are 
	the same.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-isSameNode
	"
	|
	  doc "Document"
	  docType1 "DocumentType"
	  docType2 "DocumentType"
	  isSame "Boolean"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docType1 := doc  doctype.
	docType2 := doc  doctype.
	isSame := docType1 isSameNode: docType2.
	self assert: isSame.

!

test_nodeissamenode03
	"
	Using isSameNode check if 2 Element nodes that reference the same object are 
	the same.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-isSameNode
	"
	|
	  doc "Document"
	  element1 "Element"
	  element2 "Element"
	  childList "NodeList"
	  isSame "Boolean"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	childList := doc  getElementsByTagName: 'p'.
	element1 := childList  item:0.
	element2 := childList  item:0.
	isSame := element2 isSameNode: element1.
	self assert: isSame.

!

test_nodeissamenode04
	"
	Using isSameNode check if 2 Element nodes that are equal but do not reference the 
	same object are not the same.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-isSameNode
	"
	|
	  doc "Document"
	  element1 "Element"
	  element2 "Element"
	  isSame "Boolean"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	element1 := doc  createElement:'xhtml:br' ns:'http://www.w3.org/1999/xhtml'.
	element2 := doc  createElement:'xhtml:br' ns:'http://www.w3.org/1999/xhtml'.
	isSame := element2 isSameNode: element1.
	self deny: isSame.

!

test_nodeissamenode05
	"

	
	Using isSameNode check if 2 Document Element nodes that reference the same object are 
	the same.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-isSameNode
	"
	|
	  doc "Document"
	  element1 "Element"
	  element2 "Element"
	  isSame "Boolean"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	element1 := doc  documentElement.
	element2 := doc  documentElement.
	isSame := element2 isSameNode: element1.
	self assert: isSame.

!

test_nodeissamenode06
	"
	Using isSameNode check if 2 Document Element nodes that reference the same object are 
	the same.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-isSameNode
	"
	|
	  doc "Document"
	  element "Element"
	  element1 "Element"
	  attr1 "Attr"
	  attr2 "Attr"
	  childList "NodeList"
	  isSame "Boolean"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	childList := doc  getElementsByTagName: 'acronym'.
	element := childList  item:2.
	element1 := childList  item:2.
	attr1 := element  getAttributeNode:'class'.
	attr2 := element1  getAttributeNode:'class'.
	isSame := attr1 isSameNode: attr2.
	self assert: isSame.

!

test_nodeissamenode07
	"

	
	Using isSameNode check if 2 Entity nodes that reference the same object are 
	the same.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-isSameNode
	"
	|
	  doc "Document"
	  docType "DocumentType"
	  entitiesMap "NamedNodeMap"
	  entity1 "Entity"
	  entity2 "Entity"
	  isSame "Boolean"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docType := doc  doctype.
	entitiesMap := docType  entities.
	entity1 := entitiesMap  getNamedItem:'delta'.
	entity2 := entitiesMap  getNamedItem:'delta'.
	isSame := entity1 isSameNode: entity2.
	self assert: isSame.

!

test_nodeissamenode08
	"

	
	Using isSameNode check if 2 Notation nodes that reference the same object are 
	the same.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-isSameNode
	"
	|
	  doc "Document"
	  docType "DocumentType"
	  entitiesMap "NamedNodeMap"
	  notation1 "Notation"
	  notation2 "Notation"
	  isSame "Boolean"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docType := doc  doctype.
	entitiesMap := docType  notations.
	notation1 := entitiesMap  getNamedItem:'notation1'.
	notation2 := entitiesMap  getNamedItem:'notation1'.
	isSame := notation1 isSameNode: notation2.
	self assert: isSame.

!

test_nodeissamenode09
	"

	
	Using isSameNode check if an Entity and its docType nodes are not the same.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-isSameNode
	"
	|
	  doc "Document"
	  docType "DocumentType"
	  entitiesMap "NamedNodeMap"
	  entity "Entity"
	  isSame "Boolean"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docType := doc  doctype.
	entitiesMap := docType  entities.
	entity := entitiesMap  getNamedItem:'alpha'.
	isSame := docType isSameNode: entity.
	self deny: isSame.

!

test_nodeissamenode10
	"
	Using isSameNode check if an new Document and a new Element node are not the same.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-isSameNode
	"
	|
	  doc "Document"
	  newDoc "Document"
	  domImpl "DOMImplementation"
	  element "Element"
	  isSame "Boolean"
	  nullDocType "DocumentType"
	  docElem "Element"
	  rootNS "String"
	  rootName "String"
	|
	nullDocType := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docElem := doc  documentElement.
	rootNS := docElem  namespaceURI.
	rootName := docElem  tagName.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	newDoc := domImpl createDocumentNS: rootNS qualifiedName: rootName doctype: nullDocType.
	element := newDoc  createElement:rootName ns:rootNS.
	isSame := newDoc isSameNode: element.
	self deny: isSame.

!

test_nodelookupnamespaceuri01
	"
Return value from lookupNamespaceURI(null) on a Document node with no default namespace should be null.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-lookupNamespaceURI
	"
	|
	  doc "Document"
	  namespaceURI "String"
	  nullPrefix "String"
	|
	"implementationAttribute not supported: namespaceAware"
	nullPrefix := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo_nodefaultns').
	namespaceURI := doc  lookupNamespaceURI:nullPrefix.
	self assert: namespaceURI isNil.

!

test_nodelookupnamespaceuri02
	"
	Using lookupNamespaceURI on a new Document node with a namespaceURI and prefix
	and check if the value returned is the same namespaceURI.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-lookupNamespaceURI
	"
	|
	  doc "Document"
	  domImpl "DOMImplementation"
	  newDoc "Document"
	  namespaceURI "String"
	  nullDocType "DocumentType"
	  docElem "Element"
	  rootNS "String"
	  rootName "String"
	  qname "String"
	|
	"implementationAttribute not supported: namespaceAware"
	nullDocType := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docElem := doc  documentElement.
	rootNS := docElem  namespaceURI.
	rootName := docElem  tagName.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	self assert:false description:'Method "plus" is not supported yet'.
	newDoc := domImpl createDocumentNS: rootNS qualifiedName: qname doctype: nullDocType.
	namespaceURI := newDoc  lookupNamespaceURI:'dom3'.
	self assert: ( namespaceURI = rootNS ).

!

test_nodelookupnamespaceuri03
	"



	Using lookupNamespaceURI on this DocumentType node check if the value returned is Null .

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-lookupNamespaceURI
	"
	|
	  doc "Document"
	  docType "DocumentType"
	  namespaceURI "String"
	  nullPrefix "String"
	|
	"implementationAttribute not supported: namespaceAware"
	nullPrefix := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docType := doc  doctype.
	namespaceURI := docType  lookupNamespaceURI:nullPrefix.
	self assert: namespaceURI isNil.

!

test_nodelookupnamespaceuri04
	"



	Using lookupNamespaceURI on an Entity and Notation node and check if the value returned is Null .

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-lookupNamespaceURI
	"
	|
	  doc "Document"
	  docType "DocumentType"
	  entity "Entity"
	  notation "Notation"
	  entitiesMap "NamedNodeMap"
	  notationsMap "NamedNodeMap"
	  namespaceURI "String"
	|
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docType := doc  doctype.
	entitiesMap := docType  entities.
	notationsMap := docType  notations.
	entity := entitiesMap  getNamedItem:'alpha'.
	notation := notationsMap  getNamedItem:'notation1'.
	namespaceURI := entity  lookupNamespaceURI:''.
	self assert: namespaceURI isNil.

!

test_nodelookupnamespaceuri05
	"
	Using lookupNamespaceURI on the DocumentElement node of a new document with a 
	namespaceURI and prefix and check if the namespaceURI value returned is valid.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-lookupNamespaceURI
	"
	|
	  doc "Document"
	  elem "Element"
	  domImpl "DOMImplementation"
	  newDoc "Document"
	  namespaceURI "String"
	  nullDocType "DocumentType"
	  docElem "Element"
	  rootNS "String"
	  rootName "String"
	  qname "String"
	|
	"implementationAttribute not supported: namespaceAware"
	nullDocType := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docElem := doc  documentElement.
	rootNS := docElem  namespaceURI.
	rootName := docElem  tagName.
	self assert:false description:'Method "plus" is not supported yet'.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	newDoc := domImpl createDocumentNS: rootNS qualifiedName: qname doctype: nullDocType.
	elem := newDoc  documentElement.
	namespaceURI := elem  lookupNamespaceURI:'dom3'.
	self assert: ( namespaceURI = rootNS ).

!

test_nodelookupnamespaceuri06
	"
	Invoke lookupNamespaceURI on an Element node with no prefix, which has a namespace
	attribute declaration with a namespace prefix and check if the value of the namespaceURI
	returned by using its prefix as a parameter is valid.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-lookupNamespaceURI
	"
	|
	  doc "Document"
	  elem "Element"
	  elemList "NodeList"
	  namespaceURI "String"
	|
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'p'.
	elem := elemList  item:2.
	namespaceURI := elem  lookupNamespaceURI:'dmstc'.
	self assert: ( namespaceURI = 'http://www.netzero.com' ).

!

test_nodelookupnamespaceuri07
	"
	Invoke lookupNamespaceURI on an Element node with no prefix, which has a namespace
	attribute declaration with a namespace prefix in its parent Element node and check if 
	the value of the namespaceURI returned by using its prefix as a parameter is valid.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-lookupNamespaceURI
	"
	|
	  doc "Document"
	  elem "Element"
	  elemList "NodeList"
	  namespaceURI "String"
	|
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'em'.
	elem := elemList  item:2.
	namespaceURI := elem  lookupNamespaceURI:'dmstc'.
	self assert: ( namespaceURI = 'http://www.netzero.com' ).

!

test_nodelookupnamespaceuri08
	"
	Invoke lookupNamespaceURI on an Element node with no prefix, which has 2 namespace
	attribute declarations with and without namespace prefixes and check if the value of the prefix
	returned by using a valid prefix and an empty prefix as a parameter is a valid
	namespaceURI or null.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-lookupNamespaceURI
	"
	|
	  doc "Document"
	  elem "Element"
	  elemList "NodeList"
	  namespaceURI "String"
	  namespaceURIEmpty "String"
	|
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'p'.
	elem := elemList  item:0.
	namespaceURI := elem  lookupNamespaceURI:'dmstc'.
	self assert: ( namespaceURI = 'http://www.usa.com' ).
	namespaceURIEmpty := elem  lookupNamespaceURI:''.
	self assert: namespaceURIEmpty isNil.

!

test_nodelookupnamespaceuri09
	"
	Invoke lookupNamespaceURI on an Element node with no prefix, whose parent has no prefix and 
	2 namespace attribute declarations with and without namespace prefixes and check if the value of 
	the namespaceURI returned by using each prefix as a parameter is valid.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-lookupNamespaceURI
	"
	|
	  doc "Document"
	  elem "Element"
	  elemList "NodeList"
	  namespaceURI "String"
	  namespaceURIEmpty "String"
	|
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'em'.
	elem := elemList  item:0.
	namespaceURI := elem  lookupNamespaceURI:'dmstc'.
	self assert: ( namespaceURI = 'http://www.usa.com' ).
	namespaceURIEmpty := elem  lookupNamespaceURI:''.
	self assert: namespaceURIEmpty isNil.

!

test_nodelookupnamespaceuri10
	"
	Invoke lookupNamespaceURI on a new Child of a new Element node with a namespace URI
	and prefix and using the parents prefix as an argument, verify if the namespaceURI
	returned is a valid namespaceURI for the parent.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-lookupNamespaceURI
	"
	|
	  doc "Document"
	  parent "Element"
	  child "Element"
	  namespaceURI "String"
	  appendedChild "Node"
	|
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	parent := doc  createElement:'xhtml:body' ns:'http://www.w3.org/1999/xhtml'.
	child := doc  createElement:'p'.
	appendedChild := parent  appendChild:child.
	namespaceURI := child  lookupNamespaceURI:'xhtml'.
	self assert: ( namespaceURI = 'http://www.w3.org/1999/xhtml' ).

!

test_nodelookupnamespaceuri11
	"
	Invoke lookupNamespaceURI on an imported new Element node with a namespace URI and prefix 
	in a new Document and using the parents prefix as an argument, verify if the namespaceURI
	returned is a valid namespaceURI of the parent.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-lookupNamespaceURI
	"
	|
	  doc "Document"
	  domImpl "DOMImplementation"
	  newDoc "Document"
	  elem "Element"
	  importedNode "Element"
	  namespaceURI "String"
	  nullDocType "DocumentType"
	  docElem "Element"
	  rootNS "String"
	  rootName "String"
	|
	"implementationAttribute not supported: namespaceAware"
	nullDocType := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docElem := doc  documentElement.
	rootNS := docElem  namespaceURI.
	rootName := docElem  tagName.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	newDoc := domImpl createDocumentNS: rootNS qualifiedName: rootName doctype: nullDocType.
	elem := doc  createElement:'dom3:p' ns:'http://www.w3.org/1999/xhtml'.
	importedNode := newDoc  importNode:elem deep:true.
	namespaceURI := importedNode  lookupNamespaceURI:'dom3'.
	self assert: ( namespaceURI = 'http://www.w3.org/1999/xhtml' ).

!

test_nodelookupnamespaceuri13
	"
	Invoke lookupNamespaceURI on a Element's new Text node, which has a namespace attribute declaration 
	with a namespace prefix in its parent Element node and check if the value of the namespaceURI
	returned by using its prefix as a parameter is valid.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-lookupNamespaceURI
	"
	|
	  doc "Document"
	  docElem "Element"
	  elem "Element"
	  txt "Text"
	  namespaceURI "String"
	  appendedChild "Node"
	|
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docElem := doc  documentElement.
	elem := doc  createElement:'dom3:p' ns:'http://www.w3.org/1999/xhtml'.
	txt := doc  createTextNode:'Text'.
	appendedChild := elem  appendChild:txt.
	appendedChild := docElem  appendChild:elem.
	namespaceURI := txt  lookupNamespaceURI:'dom3'.
	self assert: ( namespaceURI = 'http://www.w3.org/1999/xhtml' ).

!

test_nodelookupnamespaceuri14
	"
	Invoke lookupNamespaceURI on a Element's new Text node, which has a namespace attribute declaration 
	with a namespace prefix in its parent Element node and check if the value of the namespaceURI
	returned by using its prefix as a parameter is valid.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-lookupNamespaceURI
	"
	|
	  doc "Document"
	  docElem "Element"
	  elem "Element"
	  cdata "CDATASection"
	  lookupNamespaceURI "String"
	  appendedChild "Node"
	|
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docElem := doc  documentElement.
	elem := doc  createElement:'dom3:p' ns:'http://www.w3.org/1999/xhtml'.
	cdata := doc  createCDATASection:'Text'.
	appendedChild := elem  appendChild:cdata.
	appendedChild := docElem  appendChild:elem.
	lookupNamespaceURI := cdata  lookupNamespaceURI:'dom3'.
	self assert: ( lookupNamespaceURI = 'http://www.w3.org/1999/xhtml' ).

!

test_nodelookupnamespaceuri15
	"
	Invoke lookupNamespaceURI on a Element's new Comment node, which has a namespace attribute declaration 
	with a namespace prefix in its parent Element node and check if the value of the namespaceURI
	returned by using its prefix as a parameter is valid.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-lookupNamespaceURI
	"
	|
	  doc "Document"
	  docElem "Element"
	  elem "Element"
	  comment "Comment"
	  clonedComment "Comment"
	  namespaceURI "String"
	  appendedChild "Node"
	|
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docElem := doc  documentElement.
	elem := doc  createElement:'dom3:p' ns:'http://www.w3.org/1999/xhtml'.
	comment := doc  createComment:'Text'.
	clonedComment := comment  cloneNode:true.
	appendedChild := elem  appendChild:clonedComment.
	appendedChild := docElem  appendChild:elem.
	namespaceURI := clonedComment  lookupNamespaceURI:'dom3'.
	self assert: ( namespaceURI = 'http://www.w3.org/1999/xhtml' ).

!

test_nodelookupnamespaceuri16
	"
	Invoke lookupNamespaceURI on a new Attribute node with with a namespace URI
	and prefix and verify if the namespaceURI returned is null.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-lookupNamespaceURI
	"
	|
	  doc "Document"
	  elem "Element"
	  attr "Attr"
	  attNode "Attr"
	  namespaceURI "String"
	|
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elem := doc  createElement:'dom3:p' ns:'http://www.w3.org/1999/xhtml'.
	attr := doc  createAttribute:'xml:lang' ns:'http://www.w3.org/XML/1998/namespace'.
	attNode := elem  setAttributeNodeNS: attr.
	namespaceURI := attr  lookupNamespaceURI:'xml'.
	self assert: namespaceURI isNil.

!

test_nodelookupnamespaceuri17
	"
	Invoke lookupNamespaceURI on the title attribute node of the acronym node with
	a namespaceURI and a node prefix and check if the value of the namespaceURI returned by 
	using its prefix as a parameter is valid.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-lookupNamespaceURI
	"
	|
	  doc "Document"
	  elem "Element"
	  elemList "NodeList"
	  attributesMap "NamedNodeMap"
	  attr "Attr"
	  namespaceURI "String"
	|
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'acronym'.
	elem := elemList  item:2.
	attributesMap := elem  attributes.
	attr := attributesMap  getNamedItem:'xsi:noNamespaceSchemaLocation'.
	namespaceURI := attr  lookupNamespaceURI:'dmstc'.
	self assert: ( namespaceURI = 'http://www.netzero.com' ).

!

test_nodelookupnamespaceuri18
	"
	Invoke lookupNamespaceURI on the default attribute node of the p node with
	a namespaceURI and a node prefix and check if the value of the namespaceURI returned by 
	using its prefix as a parameter is valid.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-lookupNamespaceURI
	"
	|
	  doc "Document"
	  elem "Element"
	  elemList "NodeList"
	  attributesMap "NamedNodeMap"
	  attr "Attr"
	  namespaceURI "String"
	|
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'p'.
	elem := elemList  item:3.
	attributesMap := elem  attributes.
	attr := attributesMap  getNamedItem:'dir'.
	namespaceURI := attr  lookupNamespaceURI:'nm'.
	self assert: ( namespaceURI = 'http://www.altavista.com' ).

!

test_nodelookupnamespaceuri19
	"
	Invoke lookupNamespaceURI on the an attribute node without a namespace prefix of
	an Element node that has a namespaceURI and prefix, and check if the value of the namespaceURI
	returned by using the Elements prefix as a parameter is valid.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-lookupNamespaceURI
	"
	|
	  doc "Document"
	  elem "Element"
	  elemList "NodeList"
	  attributesMap "NamedNodeMap"
	  attr "Attr"
	  namespaceURI "String"
	|
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'acronym'.
	elem := elemList  item:3.
	attributesMap := elem  attributes.
	attr := attributesMap  getNamedItem:'class'.
	namespaceURI := attr  lookupNamespaceURI:'xsi'.
	self assert: ( namespaceURI = 'http://www.w3.org/2001/XMLSchema-instance' ).

!

test_nodelookupnamespaceuri20
	"



	Invoke lookupNamespaceURI on the an attribute node without a namespace prefix of
	an Element node that has a namespaceURI and prefix, and check if the value of the namespaceURI 
	returned by using the Elements prefix as a parameter is valid.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-lookupNamespaceURI
	"
	|
	  doc "Document"
	  elem "Element"
	  elemList "NodeList"
	  attributesMap "NamedNodeMap"
	  attr "Attr"
	  namespaceURI "String"
	|
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'p'.
	elem := elemList  item:3.
	attributesMap := elem  attributes.
	attr := attributesMap  getNamedItem:'xmlns:nm'.
	namespaceURI := attr  lookupNamespaceURI:'nm'.
	self assert: ( namespaceURI = 'http://www.altavista.com' ).

!

test_nodelookupprefix01
	"


	
	Using lookupPrefix on this Document node check if the value returned is Null .                

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-lookupNamespacePrefix
	"
	|
	  doc "Document"
	  prefix "String"
	  nullNSURI "String"
	|
	"implementationAttribute not supported: namespaceAware"
	nullNSURI := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	prefix := doc  lookupPrefix.
	self assert: prefix isNil.

!

test_nodelookupprefix02
	"
	Using lookupPrefix on a new Document node with a namespaceURI and prefix
	and check if the value returned is the same prefix.

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-lookupNamespacePrefix
	"
	|
	  doc "Document"
	  domImpl "DOMImplementation"
	  newDoc "Document"
	  prefix "String"
	  nullDocType "DocumentType"
	  docElem "Element"
	  rootNS "String"
	  rootName "String"
	  qname "String"
	|
	"implementationAttribute not supported: namespaceAware"
	nullDocType := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docElem := doc  documentElement.
	rootNS := docElem  namespaceURI.
	rootName := docElem  tagName.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	self assert:false description:'Method "plus" is not supported yet'.
	newDoc := domImpl createDocumentNS: rootNS qualifiedName: qname doctype: nullDocType.
	prefix := newDoc  lookupPrefix.
	self assert: ( prefix = 'dom3' ).

!

test_nodelookupprefix03
	"



	Using lookupPrefix on this DocumentType node check if the value returned is Null .

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-lookupNamespacePrefix
	"
	|
	  doc "Document"
	  docType "DocumentType"
	  prefix "String"
	  nullNSURI "String"
	|
	"implementationAttribute not supported: namespaceAware"
	nullNSURI := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docType := doc  doctype.
	prefix := docType  lookupPrefix.
	self assert: prefix isNil.

!

test_nodelookupprefix04
	"



	Using lookupPrefix on an Entity and Notation node and check if the value returned is Null .

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-lookupNamespacePrefix
	"
	|
	  doc "Document"
	  docType "DocumentType"
	  entity "Entity"
	  notation "Notation"
	  entitiesMap "NamedNodeMap"
	  notationsMap "NamedNodeMap"
	  prefix "String"
	|
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docType := doc  doctype.
	entitiesMap := docType  entities.
	notationsMap := docType  notations.
	entity := entitiesMap  getNamedItem:'alpha'.
	notation := notationsMap  getNamedItem:'notation1'.
	prefix := entity  lookupPrefix.
	self assert: prefix isNil.
	prefix := notation  lookupPrefix.
	self assert: prefix isNil.

!

test_nodelookupprefix05
	"
	Using lookupPrefix on the DocumentElement node of a new document with a 
	namespaceURI and prefix and check if the prefix value returned is valid.

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-lookupNamespacePrefix
	"
	|
	  doc "Document"
	  elem "Element"
	  domImpl "DOMImplementation"
	  newDoc "Document"
	  prefix "String"
	  nullDocType "DocumentType"
	  docElem "Element"
	  rootNS "String"
	  rootName "String"
	  qname "String"
	|
	"implementationAttribute not supported: namespaceAware"
	nullDocType := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docElem := doc  documentElement.
	rootNS := docElem  namespaceURI.
	rootName := docElem  tagName.
	self assert:false description:'Method "plus" is not supported yet'.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	newDoc := domImpl createDocumentNS: rootNS qualifiedName: qname doctype: nullDocType.
	elem := newDoc  documentElement.
	prefix := elem  lookupPrefix.
	self assert: ( prefix = 'dom3' ).

!

test_nodelookupprefix06
	"
	Invoke lookupPrefix on an Element node with no prefix, which has a namespace
	attribute declaration with a namespace prefix and check if the value of the prefix
	returned by using its namespaceURI as a parameter is valid.

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-lookupNamespacePrefix
	"
	|
	  doc "Document"
	  elem "Element"
	  elemList "NodeList"
	  prefix "String"
	|
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'p'.
	elem := elemList  item:2.
	prefix := elem  lookupPrefix.
	self assert: ( prefix = 'dmstc' ).

!

test_nodelookupprefix07
	"
	Invoke lookupPrefix on an Element node with no prefix, which has a namespace
	attribute declaration with a namespace prefix in its parent Element node and check if the value of the prefix
	returned by using its namespaceURI as a parameter is valid.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-lookupNamespacePrefix
	"
	|
	  doc "Document"
	  elem "Element"
	  elemList "NodeList"
	  prefix "String"
	|
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'em'.
	elem := elemList  item:2.
	prefix := elem  lookupPrefix.
	self assert: ( prefix = 'dmstc' ).

!

test_nodelookupprefix08
	"
	Invoke lookupPrefix on an Element node with no prefix, which has 2 namespace
	attribute declarations with and without namespace prefixes and check if the value of the prefix
	returned by using each namespaceURI as a parameter is valid.

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-lookupNamespacePrefix
	"
	|
	  doc "Document"
	  elem "Element"
	  elemList "NodeList"
	  prefix "String"
	  prefixEmpty "String"
	|
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'p'.
	elem := elemList  item:0.
	prefix := elem  lookupPrefix.
	self assert: ( prefix = 'dmstc' ).
	prefixEmpty := elem  lookupPrefix.
	self assert: prefixEmpty isNil.

!

test_nodelookupprefix09
	"



	Invoke lookupPrefix on an Element node with no prefix, whose parent has no prefix and 
	2 namespace attribute declarations with and without namespace prefixes and check if the value of 
	the prefix returned by using each namespaceURI as a parameter is valid.

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-lookupNamespacePrefix
	"
	|
	  doc "Document"
	  elem "Element"
	  elemList "NodeList"
	  prefix "String"
	  prefixEmpty "String"
	|
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'em'.
	elem := elemList  item:0.
	prefix := elem  lookupPrefix.
	self assert: ( prefix = 'dmstc' ).
	prefixEmpty := elem  lookupPrefix.
	self assert: prefixEmpty isNil.

!

test_nodelookupprefix10
	"
	Invoke lookupPrefix on a new Child of a new Element node with a namespace URI
	and prefix and using the parents namespace URI as an argument, verify if the prefix
	returned is a valid prefix of the parent.

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-lookupNamespacePrefix
	"
	|
	  doc "Document"
	  parent "Element"
	  child "Element"
	  prefix "String"
	  appendedChild "Node"
	|
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	parent := doc  createElement:'dom3:p' ns:'http://www.w3.org/1999/xhtml'.
	child := doc  createElement:'br'.
	appendedChild := parent  appendChild:child.
	prefix := child  lookupPrefix.
	self assert: ( prefix = 'dom3' ).

!

test_nodelookupprefix11
	"
	Invoke lookupPrefix on an imported new Element node with a namespace URI
	and prefix in a new Document and using the parents namespace URI as an argument, verify if the prefix
	returned is a valid prefix of the parent.

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-lookupNamespacePrefix
	"
	|
	  doc "Document"
	  domImpl "DOMImplementation"
	  newDoc "Document"
	  elem "Element"
	  importedNode "Element"
	  prefix "String"
	  nullDocType "DocumentType"
	  docElem "Element"
	  rootNS "String"
	  rootName "String"
	  qname "String"
	|
	"implementationAttribute not supported: namespaceAware"
	nullDocType := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docElem := doc  documentElement.
	rootNS := docElem  namespaceURI.
	rootName := docElem  tagName.
	self assert:false description:'Method "plus" is not supported yet'.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	newDoc := domImpl createDocumentNS: rootNS qualifiedName: qname doctype: nullDocType.
	elem := doc  createElement:'dom3:br' ns:'http://www.w3.org/1999/xhtml'.
	importedNode := newDoc  importNode:elem deep:true.
	prefix := importedNode  lookupPrefix.
	self assert: ( prefix = 'dom3' ).

!

test_nodelookupprefix12
	"
	Invoke lookupPrefix on an renamed new Element node with a namespace URI
	and prefix in a new Document and using the parents namespace URI as an argument, verify if the prefix
	returned is a valid prefix of the parent.

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-lookupNamespacePrefix
	"
	|
	  doc "Document"
	  domImpl "DOMImplementation"
	  elem "Element"
	  renamedNode "Element"
	  prefix "String"
	|
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	elem := doc  createElement:'dom3:p' ns:'http://www.w3.org/1999/xhtml'.
	renamedNode := doc  renameNode:elem namespaceUri:'http://www.w3.org/1999/xhtml' qualifiedName:'ren:br'.
	prefix := renamedNode  lookupPrefix.
	self assert: ( prefix = 'ren' ).

!

test_nodelookupprefix13
	"
	Invoke lookupPrefix on a Element's new Text node, which has a namespace attribute declaration 
	with a namespace prefix in its parent Element node and check if the value of the prefix
	returned by using its namespaceURI as a parameter is valid.

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-lookupNamespacePrefix
	"
	|
	  doc "Document"
	  bodyElem "Element"
	  elem "Element"
	  txt "Text"
	  prefix "String"
	  appendedChild "Node"
	  bodyList "NodeList"
	|
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	bodyList := doc  getElementsByTagName: 'body'.
	bodyElem := bodyList  item:0.
	elem := doc  createElement:'dom3:p' ns:'http://www.w3.org/1999/xhtml'.
	txt := doc  createTextNode:'Text'.
	appendedChild := elem  appendChild:txt.
	appendedChild := bodyElem  appendChild:elem.
	prefix := txt  lookupPrefix.
	self assert: ( prefix = 'dom3' ).

!

test_nodelookupprefix14
	"
	Invoke lookupPrefix on a Element's new CDATA node, which has a namespace attribute declaration 
	with a namespace prefix in its parent Element node and check if the value of the prefix
	returned by using its namespaceURI as a parameter is valid.

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-lookupNamespacePrefix
	"
	|
	  doc "Document"
	  bodyElem "Element"
	  elem "Element"
	  cdata "CDATASection"
	  prefix "String"
	  appendedChild "Node"
	  bodyList "NodeList"
	|
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	bodyList := doc  getElementsByTagName: 'body'.
	bodyElem := bodyList  item:0.
	elem := doc  createElement:'dom3:p' ns:'http://www.w3.org/1999/xhtml'.
	cdata := doc  createCDATASection:'Text'.
	appendedChild := elem  appendChild:cdata.
	appendedChild := bodyElem  appendChild:elem.
	prefix := cdata  lookupPrefix.
	self assert: ( prefix = 'dom3' ).

!

test_nodelookupprefix15
	"
	Invoke lookupPrefix on a Element's new Comment node, which has a namespace attribute declaration 
	with a namespace prefix in its parent Element node and check if the value of the prefix
	returned by using its namespaceURI as a parameter is valid.

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-lookupNamespacePrefix
	"
	|
	  doc "Document"
	  bodyElem "Element"
	  elem "Element"
	  comment "Comment"
	  clonedComment "Comment"
	  prefix "String"
	  appendedChild "Node"
	  bodyList "NodeList"
	|
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	bodyList := doc  getElementsByTagName: 'body'.
	bodyElem := bodyList  item:0.
	elem := doc  createElement:'dom3:p' ns:'http://www.w3.org/1999/xhtml'.
	comment := doc  createComment:'Text'.
	clonedComment := comment  cloneNode:true.
	appendedChild := elem  appendChild:clonedComment.
	appendedChild := bodyElem  appendChild:elem.
	prefix := clonedComment  lookupPrefix.
	self assert: ( prefix = 'dom3' ).

!

test_nodelookupprefix16
	"
	Invoke lookupPrefix on a new Attribute node with with a namespace URI
	and prefix and verify if the prefix returned is null.

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-lookupNamespacePrefix
	"
	|
	  doc "Document"
	  elem "Element"
	  attr "Attr"
	  prefix "String"
	  attNode "Attr"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	elem := doc  createElement:'dom3:p' ns:'http://www.w3.org/1999/xhtml'.
	attr := doc  createAttribute:'xml:lang' ns:'http://www.w3.org/XML/1998/namespace'.
	attNode := elem  setAttributeNodeNS: attr.
	prefix := attr  lookupPrefix.
	self assert: prefix isNil.

!

test_nodelookupprefix17
	"
	Invoke lookupPrefix on the title attribute node of the acronym node with
	a namespaceURI and a node prefix and check if the value of the prefix returned by 
	using its namespaceURI as a parameter is valid.

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-lookupNamespacePrefix
	"
	|
	  doc "Document"
	  elem "Element"
	  elemList "NodeList"
	  attributesMap "NamedNodeMap"
	  attr "Attr"
	  prefix "String"
	|
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'acronym'.
	elem := elemList  item:2.
	attributesMap := elem  attributes.
	attr := attributesMap  getNamedItem:'xsi:noNamespaceSchemaLocation'.
	prefix := attr  lookupPrefix.
	self assert: ( prefix = 'dmstc' ).

!

test_nodelookupprefix18
	"
	Invoke lookupPrefix on the default attribute node of the p node with
	a namespaceURI and a node prefix and check if the value of the prefix returned by 
	using its namespaceURI as a parameter is valid.

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-lookupNamespacePrefix
	"
	|
	  doc "Document"
	  elem "Element"
	  elemList "NodeList"
	  attributesMap "NamedNodeMap"
	  attr "Attr"
	  prefix "String"
	|
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'p'.
	elem := elemList  item:3.
	attributesMap := elem  attributes.
	attr := attributesMap  getNamedItem:'dir'.
	prefix := attr  lookupPrefix.
	self assert: prefix isNil.
	prefix := attr  lookupPrefix.
	self assert: ( prefix = 'nm' ).

!

test_nodelookupprefix19
	"
	Invoke lookupPrefix on the an attribute node without a namespace prefix of
	an Element node that has a namespaceURI and prefix, and check if the value of the prefix 
	returned by using the Elements namespaceURI as a parameter is valid.

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-lookupNamespacePrefix
	"
	|
	  doc "Document"
	  elem "Element"
	  elemList "NodeList"
	  attributesMap "NamedNodeMap"
	  attr "Attr"
	  prefix "String"
	|
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo_nodefaultns').
	elemList := doc  getElementsByTagName: 'html:p'.
	elem := elemList  item:0.
	attributesMap := elem  attributes.
	attr := attributesMap  getNamedItem:'class'.
	prefix := attr  lookupPrefix.
	self assert: ( prefix = 'html' ).

!

test_nodelookupprefix20
	"



	Invoke lookupPrefix on the an attribute node without a namespace prefix of
	an Element node that has a namespaceURI and prefix, and check if the value of the prefix 
	returned by using the Elements namespaceURI as a parameter is valid.

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-lookupNamespacePrefix
	"
	|
	  doc "Document"
	  elem "Element"
	  elemList "NodeList"
	  attributesMap "NamedNodeMap"
	  attr "Attr"
	  prefix "String"
	|
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'p'.
	elem := elemList  item:3.
	attributesMap := elem  attributes.
	attr := attributesMap  getNamedItem:'xmlns:nm'.
	prefix := attr  lookupPrefix.
	self assert: ( prefix = 'nm' ).

!

test_noderemovechild01
	"



	Using removeChild on this Document node attempt to remove this Document node and
	verify if a NOT_FOUND_ERR error is thrown.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-1734834066
	"
	|
	  doc "Document"
	  removed "Node"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	"assertDOMException..."
	self should:[
	removed := doc  removeChild:doc.
	] raise: DOMException.
	self assert: (lastException code == DOMException NOT_FOUND_ERR).
	"end of assertDOMException..."

!

test_noderemovechild02
	"
	Using removeChild on this Document node attempt to remove a new Document node and
	vice versa and verify if a NOT_FOUND_ERR error is thrown.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-1734834066
	"
	|
	  doc "Document"
	  domImpl "DOMImplementation"
	  newDoc "Document"
	  removed "Node"
	  nullDocType "DocumentType"
	  docElem "Element"
	  rootNS "String"
	  rootName "String"
	|
	nullDocType := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docElem := doc  documentElement.
	rootNS := docElem  namespaceURI.
	rootName := docElem  tagName.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	newDoc := domImpl createDocumentNS: rootNS qualifiedName: rootName doctype: nullDocType.
	"assertDOMException..."
	self should:[
	removed := doc  removeChild:newDoc.
	] raise: DOMException.
	self assert: (lastException code == DOMException NOT_FOUND_ERR).
	"end of assertDOMException..."
	"assertDOMException..."
	self should:[
	removed := newDoc  removeChild:doc.
	] raise: DOMException.
	self assert: (lastException code == DOMException NOT_FOUND_ERR).
	"end of assertDOMException..."

!

test_noderemovechild03
	"
	Using removeChild on this DocumentElement node attempt to remove this Document node and
	verify if the DocumentElement is null.  Now try the reverse and a NOT_FOUND_ERR should be
	thrown.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-1734834066
	"
	|
	  doc "Document"
	  docElem "Element"
	  removedChild "Element"
	  removed "Node"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docElem := doc  documentElement.
	removed := doc  removeChild:docElem.
	removedChild := doc  documentElement.
	self assert: removedChild isNil.
	"assertDOMException..."
	self should:[
	removed := docElem  removeChild:doc.
	] raise: DOMException.
	self assert: (lastException code == DOMException NOT_FOUND_ERR).
	"end of assertDOMException..."

!

test_noderemovechild04
	"



	Using removeChild on this Document node attempt to remove DocumentType node and
	verify if the DocumentType node is null.   Now try the reverse and a NOT_FOUND_ERR should be
	thrown.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-1734834066
	"
	|
	  doc "Document"
	  docType "DocumentType"
	  removedDocType "DocumentType"
	  removed "Node"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docType := doc  doctype.
	removed := doc  removeChild:docType.
	removedDocType := doc  doctype.
	self assert: removedDocType isNil.
	"assertDOMException..."
	self should:[
	removed := docType  removeChild:doc.
	] raise: DOMException.
	self assert: (lastException code == DOMException NOT_FOUND_ERR).
	"end of assertDOMException..."

!

test_noderemovechild05
	"
	Using removeChild on this Document node attempt to remove a new DocumentType node and
	verify if the DocumentType node is null.  Attempting to remove the DocumentType
	a second type should result in a NOT_FOUND_ERR.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-1734834066
		Subject http://www.w3.org/Bugs/Public/show_bug.cgi?id=417
	"
	|
	  doc "Document"
	  domImpl "DOMImplementation"
	  docType "DocumentType"
	  removedDocType "DocumentType"
	  nullPubId "String"
	  nullSysId "String"
	  appendedChild "Node"
	  removedChild "Node"
	|
	nullPubId := nil.
	nullSysId := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	docType := doc  doctype.
	"try"
	[
	removedChild := doc  removeChild:docType.
	] on: DOMException do: [:ex|	].
	"end of try"
	self assert: removedChild notNil.
	removedDocType := doc  doctype.
	self assert: removedDocType isNil.
	"assertDOMException..."
	self should:[
	removedChild := docType  removeChild:doc.
	] raise: DOMException.
	self assert: (lastException code == DOMException NOT_FOUND_ERR).
	"end of assertDOMException..."

!

test_noderemovechild07
	"
Attempts to remove a notation from a Document node.  Since notations are children of 
DocumentType, not Document the operation should fail with a NOT_FOUND_ERR.  Attempting
to remove Document from a Notation should also fail either with a NOT_FOUND_ERR
or a NO_MODIFICATION_ALLOWED_ERR.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-1734834066
		Subject http://www.w3.org/Bugs/Public/show_bug.cgi?id=418
	"
	|
	  doc "Document"
	  docType "DocumentType"
	  notations "NamedNodeMap"
	  notation "Notation"
	  removedChild "Node"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docType := doc  doctype.
	notations := docType  notations.
	notation := notations  getNamedItem:'notation1'.
	"assertDOMException..."
	self should:[
	removedChild := doc  removeChild:notation.
	] raise: DOMException.
	self assert: (lastException code == DOMException NOT_FOUND_ERR).
	"end of assertDOMException..."
	"try"
	[
	removedChild := notation  removeChild:doc.
	] on: DOMException do: [:ex|	].
	"end of try"

!

test_noderemovechild08
	"



	Using removeChild on this Document node attempt to remove a new Comment node and
	verify the data of the removed comment node..

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-1734834066
	"
	|
	  doc "Document"
	  comment "Comment"
	  removedCmt "Comment"
	  data "String"
	  appendedChild "Node"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	comment := doc  createComment:'Comment'.
	appendedChild := doc  appendChild:comment.
	removedCmt := doc  removeChild:comment.
	data := removedCmt  data.
	self assert: ( data = 'Comment' ).

!

test_noderemovechild09
	"



	Using removeChild on this Document node attempt to remove a new ProcessingInstruction node and
	verify the target of the removed ProcessingInstruction node.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-1734834066
	"
	|
	  doc "Document"
	  pi "ProcessingInstruction"
	  removedPi "ProcessingInstruction"
	  target "String"
	  appendedChild "Node"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	pi := doc  createProcessingInstruction:'PIT' data:'PID'.
	appendedChild := doc  appendChild:pi.
	removedPi := doc  removeChild:pi.
	target := removedPi  target.
	self assert: ( target = 'PIT' ).

!

test_noderemovechild10
	"
	Using removeChild on a new DocumentFragment node attempt to remove a new Element node and
	verify the name of the removed Element node.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-1734834066
	"
	|
	  doc "Document"
	  docFrag "DocumentFragment"
	  elem "Element"
	  removedElem "Element"
	  elemName "String"
	  appendedChild "Node"
	  removedChild "Node"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	docFrag := doc  createDocumentFragment.
	elem := doc  createElement:'dom3:br' ns:'http://www.w3.org/1999/xhtml'.
	appendedChild := docFrag  appendChild:elem.
	removedElem := docFrag  removeChild:elem.
	elemName := removedElem  nodeName.
	self assert: ( elemName = 'dom3:br' ).

!

test_noderemovechild11
	"



	Using removeChild on a new DocumentFragment node attempt to remove a new Text node and
	verify the name of the removed Element node.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-1734834066
	"
	|
	  doc "Document"
	  docFrag "DocumentFragment"
	  txt "Text"
	  removedTxt "Text"
	  appendedChild "Node"
	  removedChild "Node"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docFrag := doc  createDocumentFragment.
	txt := doc  createTextNode:'TEXT'.
	appendedChild := docFrag  appendChild:txt.
	removedChild := docFrag  removeChild:txt.
	removedTxt := docFrag  firstChild.
	self assert: removedTxt isNil.

!

test_noderemovechild12
	"
	The method removeChild removes the child node indicated by oldChild from the list 
	of children, and returns it. 

	Using removeChild on a new DocumentFragment node attempt to remove a new EntityReference node.
        Also attempt to remove the document fragment node from the EntityReference.  Verify that a 
        NO_MODIFICATION_ALLOWED_ERR (EntityReference node is read-only) or a NOT_FOUND_ERR is thrown.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-1734834066
	"
	|
	  doc "Document"
	  docFrag "DocumentFragment"
	  eRef "EntityReference"
	  removedERef "EntityReference"
	  appendedChild "Node"
	  removedChild "Node"
	|
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docFrag := doc  createDocumentFragment.
	eRef := doc  createEntityReference:'ent1'.
	appendedChild := docFrag  appendChild:eRef.
	removedChild := docFrag  removeChild:eRef.
	removedERef := docFrag  firstChild.
	self assert: removedERef isNil.
	"try"
	[
	removedChild := eRef  removeChild:docFrag.
	] on: DOMException do: [:ex|	].
	"end of try"

!

test_noderemovechild13
	"
	Using removeChild on a new EntityReference node attempt to remove the first child 
	of this node and verify if a NO_MODIFICATION_ALLOWED_ERR is thrown.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-1734834066
	"
	|
	  doc "Document"
	  txt "Text"
	  eRef "EntityReference"
	  removed "Node"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	eRef := doc  createEntityReference:'alpha'.
	txt := eRef  firstChild.
	self assert: txt notNil.
	"assertDOMException..."
	self should:[
	removed := eRef  removeChild:txt.
	] raise: DOMException.
	self assert: (lastException code == DOMException NO_MODIFICATION_ALLOWED_ERR).
	"end of assertDOMException..."

!

test_noderemovechild14
	"
	Using removeChild on a new EntityReference node attempt to remove its last ProcessingInstruction 
	child node and verify if a NO_MODIFICATION_ALLOWED_ERR is thrown.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-1734834066
	"
	|
	  doc "Document"
	  removed "Node"
	  eRef "EntityReference"
	  pi "ProcessingInstruction"
	  entName "String"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	eRef := doc  createEntityReference:'ent4'.
	pi := eRef  lastChild.
	self assert: pi notNil.
	"assertDOMException..."
	self should:[
	removed := eRef  removeChild:pi.
	] raise: DOMException.
	self assert: (lastException code == DOMException NO_MODIFICATION_ALLOWED_ERR).
	"end of assertDOMException..."

!

test_noderemovechild15
	"
	Using removeChild on a new EntityReference node attempt to remove an Element child 
	and verify if a NO_MODIFICATION_ALLOWED_ERR is thrown. 

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-1734834066
	"
	|
	  doc "Document"
	  eRef "EntityReference"
	  elem "Element"
	  entName "String"
	  removed "Node"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	eRef := doc  createEntityReference:'ent4'.
	elem := eRef  firstChild.
	self assert: elem notNil.
	"assertDOMException..."
	self should:[
	removed := eRef  removeChild:elem.
	] raise: DOMException.
	self assert: (lastException code == DOMException NO_MODIFICATION_ALLOWED_ERR).
	"end of assertDOMException..."

!

test_noderemovechild16
	"
	Using removeChild on the first 'p' Element node attempt to remove its 'em'
	Element child and verify the name of the returned node that was removed.  Now attempt
	the reverse and verify if a NOT_FOUND_ERR is thrown.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-1734834066
	"
	|
	  doc "Document"
	  parentList "NodeList"
	  childList "NodeList"
	  parent "Element"
	  child "Element"
	  removed "Element"
	  removedName "String"
	  removedNode "Node"
	|
	^self. "ignoringElementContentWhitespace supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	parentList := doc  getElementsByTagName: 'em'.
	child := parentList  item:0.
	parent := child  parentNode.
	removed := parent  removeChild:child.
	removedName := removed  nodeName.
	self assert: ( removedName = 'em' ).
	"assertDOMException..."
	self should:[
	removedNode := child  removeChild:parent.
	] raise: DOMException.
	self assert: (lastException code == DOMException NOT_FOUND_ERR).
	"end of assertDOMException..."

!

test_noderemovechild17
	"
	Using removeChild on the first 'p' Element node attempt to remove a Text 
	node child and verify the contents of the returned node that was removed.  Now attempt
	the reverse and verify if a NOT_FOUND_ERR is thrown.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-1734834066
	"
	|
	  doc "Document"
	  parentList "NodeList"
	  parent "Element"
	  child "Text"
	  removed "Text"
	  removedValue "String"
	  removedNode "Node"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	parentList := doc  getElementsByTagName: 'em'.
	parent := parentList  item:0.
	child := parent  firstChild.
	removed := parent  removeChild:child.
	removedValue := removed  nodeValue.
	self assert: ( removedValue = 'EMP0001' ).
	"assertDOMException..."
	self should:[
	removedNode := child  removeChild:parent.
	] raise: DOMException.
	self assert: (lastException code == DOMException NOT_FOUND_ERR).
	"end of assertDOMException..."

!

test_noderemovechild18
	"



	Using removeChild on the first 'p' Element node attempt to remove a CDATASection 
	node child and verify the contents of the returned node that was removed.  Now attempt
	the reverse and verify if a NOT_FOUND_ERR is thrown.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-1734834066
	"
	|
	  doc "Document"
	  parentList "NodeList"
	  parent "Element"
	  child "CDATASection"
	  removed "CDATASection"
	  removedValue "String"
	  removedNode "Node"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	parentList := doc  getElementsByTagName: 'strong'.
	parent := parentList  item:1.
	child := parent  lastChild.
	removed := parent  removeChild:child.
	removedValue := removed  nodeValue.
	self assert: ( removedValue = 'This is an adjacent CDATASection with a reference to a tab &tab;' ).
	"assertDOMException..."
	self should:[
	removedNode := child  removeChild:parent.
	] raise: DOMException.
	self assert: (lastException code == DOMException NOT_FOUND_ERR).
	"end of assertDOMException..."

!

test_noderemovechild19
	"
	Using removeChild on the first 'p' Element node attempt to remove a EntityReference 
	node child and verify the nodeName of the returned node that was removed.  Attempt
	to remove a non-child from an entity reference and expect either a NOT_FOUND_ERR or
	a NO_MODIFICATION_ALLOWED_ERR.  Renove a child from an entity reference and expect
	a NO_MODIFICATION_ALLOWED_ERR.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-1734834066
	"
	|
	  doc "Document"
	  parentList "NodeList"
	  parent "Element"
	  child "EntityReference"
	  removed "EntityReference"
	  removedName "String"
	  removedNode "Node"
	  entRefChild "Node"
	|
	"implementationAttribute not supported: expandEntityReferences"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	parentList := doc  getElementsByTagName: 'acronym'.
	parent := parentList  item:1.
	child := parent  firstChild.
	removed := parent  removeChild:child.
	removedName := removed  nodeName.
	self assert: ( removedName = 'beta' ).
	"try"
	[
	removedNode := child  removeChild:parent.
self assert:false.	] on: DOMException do: [:ex|	].
	"end of try"
	entRefChild := child  firstChild.
	"if"
	( entRefChild notNil )  ifTrue: [
		self assert:false description:'Method "NO_MODIFICATION_ALLOWED_ERR" is not supported yet'.
	].

!

test_noderemovechild20
	"
	Using removeChild on the first 'p' Element node attempt to remove a new
	Element child and verify the name of the returned node that was removed.  Now attempt
	to do the same on a cloned child and verify if a NOT_FOUND_ERR is thrown.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-1734834066
	"
	|
	  doc "Document"
	  parentList "NodeList"
	  childList "NodeList"
	  parent "Element"
	  child "Element"
	  clonedChild "Element"
	  removed "Element"
	  removedName "String"
	  appendedChild "Node"
	  removedNode "Node"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	parentList := doc  getElementsByTagName: 'p'.
	parent := parentList  item:0.
	child := doc  createElement:'dom3:br' ns:'http://www.w3.org/1999/xhtml'.
	appendedChild := parent  appendChild:child.
	removed := parent  removeChild:child.
	removedName := removed  nodeName.
	self assert: ( removedName = 'dom3:br' ).
	clonedChild := child  cloneNode:true.
	"assertDOMException..."
	self should:[
	removedNode := parent  removeChild:clonedChild.
	] raise: DOMException.
	self assert: (lastException code == DOMException NOT_FOUND_ERR).
	"end of assertDOMException..."

!

test_noderemovechild21
	"
	Using removeChild on a new Element node attempt to remove a new Element child 
	and verify the name of the returned node that was removed.  Now append the parent
	to the documentElement and attempt to remove the child using removeChild on the
	documentElement and verify if a NOT_FOUND_ERR is thrown.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-1734834066
	"
	|
	  doc "Document"
	  docElem "Element"
	  parent "Element"
	  child "Element"
	  removed "Element"
	  removedName "String"
	  removedNode "Node"
	  appendedChild "Node"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docElem := doc  documentElement.
	parent := doc  createElement:'dom3:p' ns:'http://www.w3.org/1999/xhtml'.
	child := doc  createElement:'dom3:br' ns:'http://www.w3.org/1999/xhtml'.
	appendedChild := parent  appendChild:child.
	appendedChild := docElem  appendChild:parent.
	removed := parent  removeChild:child.
	removedName := removed  nodeName.
	self assert: ( removedName = 'dom3:br' ).
	"assertDOMException..."
	self should:[
	removedNode := docElem  removeChild:child.
	] raise: DOMException.
	self assert: (lastException code == DOMException NOT_FOUND_ERR).
	"end of assertDOMException..."

!

test_noderemovechild22
	"
	Using removeChild on a new Element node attempt to remove a new Comment child 
	and verify the name of the rturned node that was removed.  Now to remove the child 
	using removeChild on the parent and verify if a NOT_FOUND_ERR is thrown.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-1734834066
	"
	|
	  doc "Document"
	  parent "Element"
	  child "Comment"
	  removed "Comment"
	  removedName "String"
	  removedNode "Node"
	  appendedChild "Node"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	parent := doc  createElement:'dom3:p' ns:'http://www.w3.org/1999/xhtml'.
	child := doc  createComment:'DATA'.
	appendedChild := parent  appendChild:child.
	removed := parent  removeChild:child.
	removedName := removed  nodeValue.
	self assert: ( removedName = 'DATA' ).
	"assertDOMException..."
	self should:[
	removedNode := parent  removeChild:child.
	] raise: DOMException.
	self assert: (lastException code == DOMException NOT_FOUND_ERR).
	"end of assertDOMException..."

!

test_noderemovechild23
	"
	Using removeChild on a new Element node attempt to remove a new ProcessingInstruction child 
	and verify the name of the returned node that was removed.  Now to remove the child 
	using removeChild on the parent and verify if a NOT_FOUND_ERR is thrown.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-1734834066
	"
	|
	  doc "Document"
	  parent "Element"
	  child "ProcessingInstruction"
	  removed "ProcessingInstruction"
	  removedName "String"
	  removedNode "Node"
	  appendedChild "Node"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	parent := doc  createElement:'dom3:p' ns:'http://www.w3.org/1999/xhtml'.
	child := doc  createProcessingInstruction:'TARGET' data:'DATA'.
	appendedChild := parent  appendChild:child.
	removed := parent  removeChild:child.
	removedName := removed  target.
	self assert: ( removedName = 'TARGET' ).
	"assertDOMException..."
	self should:[
	removedNode := parent  removeChild:child.
	] raise: DOMException.
	self assert: (lastException code == DOMException NOT_FOUND_ERR).
	"end of assertDOMException..."

!

test_noderemovechild24
	"
	Using removeChild on an Entity node attempt to remove a Text child 
	and verify if a NO_MODIFICATION_ALLOWED_ERR gets thrown.  

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-1734834066
	"
	|
	  doc "Document"
	  docType "DocumentType"
	  entitiesMap "NamedNodeMap"
	  alphaEntity "Entity"
	  alphaText "Text"
	  removed "Text"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docType := doc  doctype.
	entitiesMap := docType  entities.
	alphaEntity := entitiesMap  getNamedItem:'alpha'.
	self assert: alphaEntity notNil.
	alphaText := alphaEntity  firstChild.
	self assert: alphaText notNil.
	"assertDOMException..."
	self should:[
	removed := alphaEntity  removeChild:alphaText.
	] raise: DOMException.
	self assert: (lastException code == DOMException NO_MODIFICATION_ALLOWED_ERR).
	"end of assertDOMException..."

!

test_noderemovechild25
	"
	Using removeChild on an Entity node attempt to remove an Element child 
	and verify if a NO_MODIFICATION_ALLOWED_ERR gets thrown.  

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-1734834066
	"
	|
	  doc "Document"
	  docType "DocumentType"
	  entitiesMap "NamedNodeMap"
	  ent4 "Entity"
	  span "Element"
	  removed "Node"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docType := doc  doctype.
	entitiesMap := docType  entities.
	ent4 := entitiesMap  getNamedItem:'ent4'.
	self assert: ent4 notNil.
	span := ent4  firstChild.
	self assert: span notNil.
	"assertDOMException..."
	self should:[
	removed := ent4  removeChild:span.
	] raise: DOMException.
	self assert: (lastException code == DOMException NO_MODIFICATION_ALLOWED_ERR).
	"end of assertDOMException..."

!

test_noderemovechild26
	"
	Using removeChild on an Entity node attempt to remove a ProcessingInstruction child 
	and verify if a NO_MODIFICATION_ALLOWED_ERR gets thrown.  

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-1734834066
	"
	|
	  doc "Document"
	  docType "DocumentType"
	  entitiesMap "NamedNodeMap"
	  ent4 "Entity"
	  pi "ProcessingInstruction"
	  removed "Node"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docType := doc  doctype.
	entitiesMap := docType  entities.
	ent4 := entitiesMap  getNamedItem:'ent4'.
	self assert: ent4 notNil.
	pi := ent4  lastChild.
	self assert: pi notNil.
	"assertDOMException..."
	self should:[
	removed := ent4  removeChild:pi.
	] raise: DOMException.
	self assert: (lastException code == DOMException NO_MODIFICATION_ALLOWED_ERR).
	"end of assertDOMException..."

!

test_noderemovechild27
	"
	The method removeChild removes the child node indicated by oldChild from the list 
	of children, and returns it. 

	Using removeChild on a Notation node attempt to remove an Entity node 
	and verify if a NO_MODIFICATION_ALLOWED_ERR or a NOT_FOUND_ERR gets thrown.  

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-1734834066
	"
	|
	  doc "Document"
	  docType "DocumentType"
	  entitiesMap "NamedNodeMap"
	  notationsMap "NamedNodeMap"
	  child "Entity"
	  parent "Notation"
	  removed "Node"
	|
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docType := doc  doctype.
	entitiesMap := docType  entities.
	notationsMap := docType  notations.
	child := entitiesMap  getNamedItem:'ent1'.
	parent := notationsMap  getNamedItem:'notation1'.
	"try"
	[
	removed := parent  removeChild:child.
	] on: DOMException do: [:ex|	].
	"end of try"

!

test_noderemovechild28
	"
	Using removeChild on an Attribute node attempt to remove its Text child node and
	and verify the name of the returned node that was removed.  Now attempt the reverse
	and verify if a NOT_FOUND_ERR is thrown.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-1734834066
	"
	|
	  doc "Document"
	  parentList "NodeList"
	  attrsMap "NamedNodeMap"
	  parent "Attr"
	  child "Text"
	  elem "Element"
	  removed "Text"
	  removedName "String"
	  removedNode "Node"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	parentList := doc  getElementsByTagName: 'acronym'.
	elem := parentList  item:0.
	attrsMap := elem  attributes.
	parent := attrsMap  getNamedItem:'xsi:noNamespaceSchemaLocation'.
	child := parent  firstChild.
	removed := parent  removeChild:child.
	removedName := removed  nodeValue.
	self assert: ( removedName = 'Yes' ).
	"assertDOMException..."
	self should:[
	removedNode := child  removeChild:parent.
	] raise: DOMException.
	self assert: (lastException code == DOMException NOT_FOUND_ERR).
	"end of assertDOMException..."

!

test_noderemovechild29
	"
	Using removeChild on a namespace Attribute node attempt to remove its Text child node and
	and verify the name of the returned node that was removed.  Now attempt the reverse
	and verify if a NOT_FOUND_ERR is thrown.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-1734834066
	"
	|
	  doc "Document"
	  parentList "NodeList"
	  attrsMap "NamedNodeMap"
	  parent "Attr"
	  child "Text"
	  elem "Element"
	  removed "Text"
	  removedName "String"
	  removedNode "Node"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	parentList := doc  getElementsByTagName: 'p'.
	elem := parentList  item:0.
	attrsMap := elem  attributes.
	parent := attrsMap  getNamedItem:'xmlns:dmstc'.
	child := parent  firstChild.
	removed := parent  removeChild:child.
	removedName := removed  nodeValue.
	self assert: ( removedName = 'http://www.usa.com' ).
	"assertDOMException..."
	self should:[
	removedNode := child  removeChild:parent.
	] raise: DOMException.
	self assert: (lastException code == DOMException NOT_FOUND_ERR).
	"end of assertDOMException..."

!

test_noderemovechild30
	"



	Using removeChild on a default Attribute node attempt to remove its Text child node and
	and verify the name of the returned node that was removed.  Now attempt the reverse
	and verify if a NOT_FOUND_ERR is thrown.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-1734834066
	"
	|
	  doc "Document"
	  parentList "NodeList"
	  attrsMap "NamedNodeMap"
	  parent "Attr"
	  child "Text"
	  elem "Element"
	  removed "Text"
	  removedNode "Node"
	  removedName "String"
	  appendedChild "Node"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	parentList := doc  getElementsByTagName: 'p'.
	elem := parentList  item:3.
	attrsMap := elem  attributes.
	parent := attrsMap  getNamedItem:'dir'.
	child := parent  firstChild.
	removed := parent  removeChild:child.
	removedName := removed  nodeValue.
	self assert: ( removedName = 'rtl' ).
	"assertDOMException..."
	self should:[
	removedNode := child  removeChild:parent.
	] raise: DOMException.
	self assert: (lastException code == DOMException NOT_FOUND_ERR).
	"end of assertDOMException..."

!

test_noderemovechild31
	"
	Using removeChild on a default Attribute node attempt to remove its EntityReference child node and
	and verify the name of the returned node that was removed.  Now attempt the reverse
	and verify if a NO_MODIFICATION_ALLOWED_ERR or NOT_FOUND_ERR is thrown.
	Then remove an child of the entity reference and expect a NO_MODIFICATION_ALLOWED_ERR.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-1734834066
	"
	|
	  doc "Document"
	  parentList "NodeList"
	  attrsMap "NamedNodeMap"
	  parent "Attr"
	  child "EntityReference"
	  entRef "EntityReference"
	  elem "Element"
	  removed "EntityReference"
	  removedNode "Node"
	  removedName "String"
	  appendedChild "Node"
	  entRefChild "Node"
	|
	"implementationAttribute not supported: expandEntityReferences"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	parentList := doc  getElementsByTagName: 'acronym'.
	elem := parentList  item:3.
	attrsMap := elem  attributes.
	parent := attrsMap  getNamedItem:'class'.
	entRef := doc  createEntityReference:'delta'.
	appendedChild := parent  appendChild:entRef.
	child := parent  lastChild.
	removed := parent  removeChild:child.
	removedName := removed  nodeName.
	self assert: ( removedName = 'delta' ).
	"try"
	[
	removedNode := child  removeChild:parent.
self assert:false.	] on: DOMException do: [:ex|	].
	"end of try"
	entRefChild := child  firstChild.
	"if"
	( entRefChild notNil )  ifTrue: [
		self assert:false description:'Method "NO_MODIFICATION_ALLOWED_ERR" is not supported yet'.
	].

!

test_nodereplacechild01
	"
	The method replaceChild replaces the child node oldChild with newChild in the list of 
	children, and returns the oldChild node.
      

	Using replaceChild on this Document node attempt to replace this Document node with itself
	and verify if a HIERARCHY_REQUEST_ERR error or a NOT_FOUND_ERR (since oldChild
        is not a child of this node) is thrown.  

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-785887307
	"
	|
	  doc "Document"
	  replaced "Node"
	|
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	"try"
	[
	doc  replaceChild:doc with: doc.
	] on: DOMException do: [:ex|	].
	"end of try"

!

test_nodereplacechild02
	"
	The method replaceChild replaces the child node oldChild with newChild in the list of 
	children, and returns the oldChild node.

	Using replaceChild on this Document node attempt to replace this DocumentType node with 
	its DocumentType (replacing node with itself -- implementation dependent) 
        
		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-785887307
	"
	|
	  doc "Document"
	  docType "DocumentType"
	  replaced "Node"
	|
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docType := doc  doctype.
	doc  replaceChild:docType with: docType.

!

test_nodereplacechild03
	"
	The method replaceChild replaces the child node oldChild with newChild in the list of 
	children, and returns the oldChild node.

	Using replaceChild on this Document node attempt to replace this Document node with 
	a new DocumentNode and verify if a HIERARCHY_REQUEST_ERR, WRONG_DOCUMENT_ERR 
        or NOT_FOUND_ERR is thrown.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-785887307
	"
	|
	  doc "Document"
	  newDoc "Document"
	  domImpl "DOMImplementation"
	  nullDocType "DocumentType"
	  replaced "Node"
	|
	"implementationAttribute not supported: namespaceAware"
	nullDocType := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	newDoc := domImpl createDocumentNS: 'http://www.w3.org/DOM' qualifiedName: 'dom3:doc' doctype: nullDocType.
	"try"
	[
	doc  replaceChild:doc with: newDoc.
	] on: DOMException do: [:ex|	].
	"end of try"

!

test_nodereplacechild04
	"
	The method replaceChild replaces the child node oldChild with newChild in the list of 
	children, and returns the oldChild node.

	Using replaceChild on this Document node attempt to replace this DocumentElement node with 
	this Document Node and verify if a HIERARCHY_REQUEST_ERR or a NOT_FOUND_ERR error is thrown.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-785887307
	"
	|
	  doc "Document"
	  docElem "Element"
	  replaced "Node"
	|
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docElem := doc  documentElement.
	"try"
	[
	doc  replaceChild:docElem with: doc.
	] on: DOMException do: [:ex|	].
	"end of try"

!

test_nodereplacechild06
	"
	Using replaceChild on this Document node attempt to replace this DocumentElement node 
	with one of its child elements and verify if the name of the replaced documentElement Node.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-785887307
	"
	|
	  doc "Document"
	  docElem "Element"
	  replaced "Element"
	  elem "Element"
	  childList "NodeList"
	  nodeName "String"
	  replacedNode "Node"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docElem := doc  documentElement.
	childList := doc  getElementsByTagName: 'p'.
	elem := childList  item:0.
	"try"
	[
	doc  replaceChild:docElem with: elem.
	] on: DOMException do: [:ex|	].
	"end of try"
	replaced := doc  documentElement.
	nodeName := replaced  nodeName.
	self assert: ( nodeName = 'p' ).

!

test_nodereplacechild07
	"
	Using replaceChild on this Document node attempt to replace this DocumentElement node 
	with  a new element and verify if the name of the replaced documentElement Node.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-785887307
	"
	|
	  doc "Document"
	  docElem "Element"
	  replaced "Element"
	  elem "Element"
	  nodeName "String"
	  replacedNode "Node"
	  rootNS "String"
	  rootName "String"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docElem := doc  documentElement.
	rootName := docElem  tagName.
	rootNS := docElem  namespaceURI.
	elem := doc  createElement:rootName ns:rootNS.
	"try"
	[
	doc  replaceChild:docElem with: elem.
	] on: DOMException do: [:ex|	].
	"end of try"
	replaced := doc  documentElement.
	nodeName := replaced  nodeName.
	self assert: ( nodeName = rootName ).

!

test_nodereplacechild08
	"
	Using replaceChild on this Document node attempt to replace this DocumentElement node 
	with  a new element that was created in another document and verify if a
	WRONG_DOCUMENT_ERR is thrown.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-785887307
	"
	|
	  doc "Document"
	  doc2 "Document"
	  docElem "Element"
	  elem "Element"
	  nodeName "String"
	  replaced "Node"
	  rootNS "String"
	  rootName "String"
	  domImpl "DOMImplementation"
	  nullDocType "DocumentType"
	|
	nullDocType := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	docElem := doc  documentElement.
	rootName := docElem  tagName.
	rootNS := docElem  namespaceURI.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	doc2 := domImpl createDocumentNS: rootNS qualifiedName: rootName doctype: nullDocType.
	elem := doc2  createElement:rootName ns:rootNS.
	"try"
	[
	doc  replaceChild:docElem with: elem.
self assert:false.	] on: DOMException do: [:ex|	].
	"end of try"

!

test_nodereplacechild10
	"
	The method replaceChild replaces the child node oldChild with newChild in the list of 
	children, and returns the oldChild node.

	Using replaceChild on this Document node attempt to replace an Entity node with
	a notation node of retieved from the DTD of another document and verify if a
	NOT_FOUND_ERR or WRONG_DOCUMENT_ERR or HIERARCHY_REQUEST err is thrown.  

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-785887307
	"
	|
	  doc "Document"
	  docType "DocumentType"
	  entitiesMap "NamedNodeMap"
	  ent "Entity"
	  doc1 "Document"
	  docType1 "DocumentType"
	  notationsMap "NamedNodeMap"
	  notation "Notation"
	  replaced "Node"
	|
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docType := doc  doctype.
	entitiesMap := docType  entities.
	ent := entitiesMap  getNamedItem:'alpha'.
	doc1 :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docType1 := doc1  doctype.
	notationsMap := docType1  notations.
	notation := notationsMap  getNamedItem:'notation1'.
	"try"
	[
	doc  replaceChild:ent with: notation.
	] on: DOMException do: [:ex|	].
	"end of try"

!

test_nodereplacechild12
	"
	Using replaceChild on this Document node, attempt to replace a new ProcessingInstruction
	node with new Comment node.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-785887307
		Subject http://www.w3.org/Bugs/Public/show_bug.cgi?id=416
	"
	|
	  doc "Document"
	  pi "ProcessingInstruction"
	  replaced "Node"
	  comment "Comment"
	  lastChild "Node"
	  nodeName "String"
	  replacedNode "Node"
	  appendedChild "Node"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	comment := doc  createComment:'dom3:doc'.
	pi := doc  createProcessingInstruction:'PITarget' data:'PIData'.
	appendedChild := doc  appendChild:comment.
	appendedChild := doc  appendChild:pi.
	doc  replaceChild:pi with: comment.
	self assert: replacedNode notNil.
	nodeName := replacedNode  nodeName.
	self assert: ( nodeName = 'PITarget' ).
	lastChild := doc  lastChild.
	self assert: lastChild notNil.
	nodeName := lastChild  nodeName.
	self assert: ( nodeName = '#comment' ).

!

test_nodereplacechild13
	"
	Using replaceChild on this Document node attempt to replace this DocumentType node with 
	a new DocumentType and verify the name of the replaced DocumentType node.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-785887307
	"
	|
	  doc "Document"
	  docType "DocumentType"
	  newDocType "DocumentType"
	  replaced "DocumentType"
	  domImpl "DOMImplementation"
	  nodeName "String"
	  nullPubId "String"
	  nullSysId "String"
	  docElem "Element"
	  docElemName "String"
	  docElemNS "String"
	|
	nullPubId := nil.
	nullSysId := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docElem := doc  documentElement.
	docElemName := docElem  tagName.
	docElemNS := docElem  namespaceURI.
	docType := doc  doctype.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	newDocType := domImpl  createDocumentType:docElemName publicId:nullPubId systemId:nullSysId.
	"try"
	[
	doc  replaceChild:docType with: newDocType.
	] on: DOMException do: [:ex|	].
	"end of try"
	nodeName := replaced  nodeName.
	self assert: ( nodeName = docElemName ).

!

test_nodereplacechild14
	"
	The method replaceChild replaces the child node oldChild with newChild in the list of 
	children, and returns the oldChild node.

	Using replaceChild on the documentElement of a newly created Document node, attempt to replace an
        element child of this documentElement node with a child that was imported from another document.  
        Verify the nodeName of the replaced element node. 

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-785887307
	"
	|
	  doc "Document"
	  newDoc "Document"
	  docElem "Element"
	  elem "Element"
	  elem2 "Element"
	  imported "Node"
	  replaced "Element"
	  domImpl "DOMImplementation"
	  nodeName "String"
	  appendedChild "Node"
	  nullDocType "DocumentType"
	|
	"implementationAttribute not supported: namespaceAware"
	nullDocType := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elem := doc  createElement:'dom3:doc1elem' ns:'http://www.w3.org/DOM/Test'.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	newDoc := domImpl createDocumentNS: 'http://www.w3.org/DOM/test' qualifiedName: 'dom3:doc' doctype: nullDocType.
	elem2 := newDoc  createElement:'dom3:doc2elem' ns:'http://www.w3.org/DOM/Test'.
	imported := newDoc  importNode:elem deep:true.
	docElem := newDoc  documentElement.
	appendedChild := docElem  appendChild:imported.
	appendedChild := docElem  appendChild:elem2.
	docElem  replaceChild:elem2 with: imported.
	nodeName := replaced  nodeName.
	self assert: ( nodeName = 'dom3:doc2elem' ).

!

test_nodereplacechild15
	"
	Using replaceChild on a DocumentFragment node attempt to replace an Element node with 
	another Element and the replaced element.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-785887307
	"
	|
	  doc "Document"
	  docFrag "DocumentFragment"
	  elem "Element"
	  elem2 "Element"
	  replaced "Element"
	  domImpl "DOMImplementation"
	  title "String"
	  appendedChild "Node"
	  docElem "Element"
	  rootName "String"
	  rootNS "String"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docElem := doc  documentElement.
	rootName := docElem  tagName.
	rootNS := docElem  namespaceURI.
	elem := doc  createElement:rootName ns:rootNS.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	docFrag := doc  createDocumentFragment.
	elem2 := doc  createElement:rootName ns:rootNS.
	elem2  setAttribute:'title' value:'new element'.
	appendedChild := docFrag  appendChild:elem2.
	docFrag  replaceChild:elem2 with: elem.
	title := replaced  getAttribute:'title'.
	self assert: ( title = 'new element' ).

!

test_nodereplacechild16
	"
	Using replaceChild on a DocumentFragment node attempt to replace an Element node with 
	another Element and verify the name of the replaced Element node.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-785887307
	"
	|
	  doc "Document"
	  docFrag "DocumentFragment"
	  elem "Element"
	  txt "Text"
	  replaced "Element"
	  nodeName "String"
	  appendedChild "Node"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elem := doc  createElement:'dom3:p' ns:'http://www.w3.org/1999/xhtml'.
	docFrag := doc  createDocumentFragment.
	txt := doc  createTextNode:'Comment'.
	appendedChild := docFrag  appendChild:txt.
	appendedChild := docFrag  appendChild:elem.
	docFrag  replaceChild:elem with: txt.
	nodeName := replaced  nodeName.
	self assert: ( nodeName = 'dom3:p' ).

!

test_nodereplacechild17
	"



	Using replaceChild on a DocumentFragment node attempt to replace a Comment node with 
	a ProcessingInstruction and vice versa verify the data of the replaced nodes.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-785887307
	"
	|
	  doc "Document"
	  docFrag "DocumentFragment"
	  pi "ProcessingInstruction"
	  cmt "Comment"
	  replacedCmt "Comment"
	  replacedPi "ProcessingInstruction"
	  data "String"
	  target "String"
	  appendedChild "Node"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docFrag := doc  createDocumentFragment.
	cmt := doc  createComment:'Comment'.
	pi := doc  createProcessingInstruction:'target' data:'Comment'.
	appendedChild := docFrag  appendChild:pi.
	appendedChild := docFrag  appendChild:cmt.
	docFrag  replaceChild:cmt with: pi.
	data := replacedCmt  data.
	self assert: ( data = 'Comment' ).
	docFrag  replaceChild:pi with: cmt.
	target := replacedPi  target.
	self assert: ( target = 'target' ).

!

test_nodereplacechild18
	"
	Using replaceChild on a DocumentFragment node attempt to replace a CDATASection node with 
	a EntityReference and vice versa verify the data of the replaced nodes.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-785887307
	"
	|
	  doc "Document"
	  docFrag "DocumentFragment"
	  entRef "EntityReference"
	  cdata "CDATASection"
	  replacedCData "CDATASection"
	  replacedEref "EntityReference"
	  cdataName "String"
	  erefName "String"
	  appendedChild "Node"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docFrag := doc  createDocumentFragment.
	cdata := doc  createCDATASection:'CDATASection'.
	entRef := doc  createEntityReference:'alpha'.
	appendedChild := docFrag  appendChild:entRef.
	appendedChild := docFrag  appendChild:cdata.
	docFrag  replaceChild:cdata with: entRef.
	cdataName := replacedCData  nodeValue.
	self assert: ( cdataName = 'CDATASection' ).
	docFrag  replaceChild:entRef with: cdata.
	erefName := replacedEref  nodeName.
	self assert: ( erefName = 'alpha' ).

!

test_nodereplacechild19
	"
	Using replaceChild on a DocumentFragment node attempt to replace an Element node with 
	its EntityReference child verify the nodeName of the replaced node.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-785887307
	"
	|
	  doc "Document"
	  docFrag "DocumentFragment"
	  entRef "EntityReference"
	  elem "Element"
	  replaced "Element"
	  nodeName "String"
	  appendedChild "Node"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docFrag := doc  createDocumentFragment.
	elem := doc  createElement:'dom3:p' ns:'http://www.w3.org/1999/xhtml'.
	entRef := doc  createEntityReference:'alpha'.
	appendedChild := elem  appendChild:entRef.
	appendedChild := docFrag  appendChild:elem.
	docFrag  replaceChild:elem with: entRef.
	nodeName := replaced  nodeName.
	self assert: ( nodeName = 'dom3:p' ).

!

test_nodereplacechild20
	"
	Using replaceChild on a DocumentFragment node attempt to replace an Element node with 
	an Attr Node and verify if a HIERARCHY_REQUEST_ERR is thrown.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-785887307
	"
	|
	  doc "Document"
	  docFrag "DocumentFragment"
	  attr "Attr"
	  elem "Element"
	  replaced "Element"
	  nodeName "String"
	  appendedChild "Node"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docFrag := doc  createDocumentFragment.
	elem := doc  createElement:'dom3:p' ns:'http://www.w3.org/1999/xhtml'.
	attr := doc  createAttribute:'xml:lang' ns:'http://www.w3.org/XML/1998/namespace'.
	appendedChild := docFrag  appendChild:elem.
	"assertDOMException..."
	self should:[
	docFrag  replaceChild:elem with: attr.
	] raise: DOMException.
	self assert: (lastException code == DOMException HIERARCHY_REQUEST_ERR).
	"end of assertDOMException..."

!

test_nodereplacechild21
	"
	The method replaceChild replaces the child node oldChild with newChild in the list of 
	children, and returns the oldChild node.

	Using replaceChild on this DocumentType node attempt to replace an Entity node with
	a notation node of retieved from the DTD of another document and verify if a
	NO_MODIFICATION_ALLOWED_ERR is thrown since DocumentType node is read-only.
	Also try replacing the docType with an entity node and see if the same exception gets thrown.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-785887307
	"
	|
	  doc "Document"
	  docType "DocumentType"
	  entitiesMap "NamedNodeMap"
	  ent "Entity"
	  doc1 "Document"
	  docType1 "DocumentType"
	  notationsMap "NamedNodeMap"
	  notation "Notation"
	  replacedChild "Node"
	|
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docType := doc  doctype.
	entitiesMap := docType  entities.
	ent := entitiesMap  getNamedItem:'alpha'.
	doc1 :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docType1 := doc1  doctype.
	notationsMap := docType1  notations.
	notation := notationsMap  getNamedItem:'notation1'.
	"assertDOMException..."
	self should:[
	docType  replaceChild:ent with: notation.
	] raise: DOMException.
	self assert: (lastException code == DOMException NO_MODIFICATION_ALLOWED_ERR).
	"end of assertDOMException..."
	"assertDOMException..."
	self should:[
	docType  replaceChild:docType with: ent.
	] raise: DOMException.
	self assert: (lastException code == DOMException NO_MODIFICATION_ALLOWED_ERR).
	"end of assertDOMException..."

!

test_nodereplacechild22
	"
	Using replaceChild on a new EntityReference node attempt to replace an EntityReference node with 
	its Element parent, with itself and vice versa verify if a NO_MODIFICATION_ALLOWED_ERR is thrown.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-785887307
	"
	|
	  doc "Document"
	  entRefMain "EntityReference"
	  entRef "EntityReference"
	  elem "Element"
	  appendedChild "Node"
	  replacedChild "Node"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elem := doc  createElement:'dom3:p' ns:'http://www.w3.org/1999/xhtml'.
	entRefMain := doc  createEntityReference:'delta'.
	entRef := doc  createEntityReference:'beta'.
	appendedChild := elem  appendChild:entRef.
	"assertDOMException..."
	self should:[
	entRefMain  replaceChild:entRef with: elem.
	] raise: DOMException.
	self assert: (lastException code == DOMException NO_MODIFICATION_ALLOWED_ERR).
	"end of assertDOMException..."
	"assertDOMException..."
	self should:[
	entRefMain  replaceChild:elem with: entRef.
	] raise: DOMException.
	self assert: (lastException code == DOMException NO_MODIFICATION_ALLOWED_ERR).
	"end of assertDOMException..."
	"assertDOMException..."
	self should:[
	entRefMain  replaceChild:entRef with: entRefMain.
	] raise: DOMException.
	self assert: (lastException code == DOMException NO_MODIFICATION_ALLOWED_ERR).
	"end of assertDOMException..."

!

test_nodereplacechild23
	"
	Using replaceChild on a new EntityReference node attempt to replace an Element, Text,
	Comment, ProcessingInstruction and CDATASection nodes with each other and in each case
	verify if a NO_MODIFICATION_ALLOWED_ERR is thrown.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-785887307
	"
	|
	  doc "Document"
	  entRef "EntityReference"
	  txt "Text"
	  elem "Element"
	  comment "Comment"
	  pi "ProcessingInstruction"
	  cdata "CDATASection"
	  replaced "Node"
	  appendedChild "Node"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elem := doc  createElement:'dom3:p' ns:'http://www.w3.org/1999/xhtml'.
	entRef := doc  createEntityReference:'delta'.
	txt := doc  createTextNode:'Text'.
	comment := doc  createComment:'Comment'.
	cdata := doc  createCDATASection:'CDATASection'.
	pi := doc  createProcessingInstruction:'target' data:'data'.
	appendedChild := elem  appendChild:entRef.
	appendedChild := elem  appendChild:txt.
	appendedChild := elem  appendChild:comment.
	appendedChild := elem  appendChild:pi.
	appendedChild := elem  appendChild:cdata.
	"assertDOMException..."
	self should:[
	entRef  replaceChild:elem with: cdata.
	] raise: DOMException.
	self assert: (lastException code == DOMException NO_MODIFICATION_ALLOWED_ERR).
	"end of assertDOMException..."
	"assertDOMException..."
	self should:[
	entRef  replaceChild:cdata with: pi.
	] raise: DOMException.
	self assert: (lastException code == DOMException NO_MODIFICATION_ALLOWED_ERR).
	"end of assertDOMException..."
	"assertDOMException..."
	self should:[
	entRef  replaceChild:pi with: comment.
	] raise: DOMException.
	self assert: (lastException code == DOMException NO_MODIFICATION_ALLOWED_ERR).
	"end of assertDOMException..."
	"assertDOMException..."
	self should:[
	entRef  replaceChild:comment with: txt.
	] raise: DOMException.
	self assert: (lastException code == DOMException NO_MODIFICATION_ALLOWED_ERR).
	"end of assertDOMException..."
	"assertDOMException..."
	self should:[
	entRef  replaceChild:txt with: elem.
	] raise: DOMException.
	self assert: (lastException code == DOMException NO_MODIFICATION_ALLOWED_ERR).
	"end of assertDOMException..."

!

test_nodereplacechild24
	"
	Using replaceChild on an EntityReference node attempt to replace an Element node with 
	an EntityReference node verify if a NO_MODIFICATION_ALLOWED_ERR gets thrown.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-785887307
	"
	|
	  doc "Document"
	  childList "NodeList"
	  entRef "EntityReference"
	  elem "Element"
	  replaced "Element"
	  nodeName "String"
	|
	"implementationAttribute not supported: expandEntityReferences"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	childList := doc  getElementsByTagName: 'acronym'.
	elem := childList  item:1.
	entRef := elem  firstChild.
	"assertDOMException..."
	self should:[
	entRef  replaceChild:elem with: entRef.
	] raise: DOMException.
	self assert: (lastException code == DOMException NO_MODIFICATION_ALLOWED_ERR).
	"end of assertDOMException..."

!

test_nodereplacechild25
	"
	Using replaceChild on an Element node attempt to replace an 
	EntityReference or Text child node 
	with an Entity node and with itself and verify if a HIERARCHY_REQUEST_ERR gets thrown.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-785887307
	"
	|
	  doc "Document"
	  docType "DocumentType"
	  entities "NamedNodeMap"
	  entity "Entity"
	  childList "NodeList"
	  entRef "Node"
	  elem "Element"
	  replaced "Element"
	  nodeName "String"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docType := doc  doctype.
	entities := docType  entities.
	entity := entities  getNamedItem:'alpha'.
	childList := doc  getElementsByTagName: 'acronym'.
	elem := childList  item:1.
	entRef := elem  firstChild.
	"assertDOMException..."
	self should:[
	elem  replaceChild:entRef with: entity.
	] raise: DOMException.
	self assert: (lastException code == DOMException HIERARCHY_REQUEST_ERR).
	"end of assertDOMException..."
	"assertDOMException..."
	self should:[
	elem  replaceChild:entRef with: elem.
	] raise: DOMException.
	self assert: (lastException code == DOMException HIERARCHY_REQUEST_ERR).
	"end of assertDOMException..."

!

test_nodereplacechild26
	"
	Using replaceChild on an Element node attempt to replace a Text child node with an Element
	node that is an ancestor of this Element node and verify if a HIERARCHY_REQUEST_ERR gets thrown.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-785887307
	"
	|
	  doc "Document"
	  childList "NodeList"
	  docElem "Element"
	  elem "Element"
	  firstChild "Node"
	  nodeName "String"
	  replaced "Node"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docElem := doc  documentElement.
	childList := doc  getElementsByTagName: 'p'.
	elem := childList  item:0.
	firstChild := elem  firstChild.
	"assertDOMException..."
	self should:[
	elem  replaceChild:firstChild with: docElem.
	] raise: DOMException.
	self assert: (lastException code == DOMException HIERARCHY_REQUEST_ERR).
	"end of assertDOMException..."

!

test_nodereplacechild27
	"
	The method replaceChild replaces the child node oldChild with newChild in the list of 
	children, and returns the oldChild node.

	Using replaceChild on an Element node attempt to replace an Element node with another 
	Element from another document and verify if a WRONG_DOCUMENT_ERR gets thrown.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-785887307
	"
	|
	  doc "Document"
	  doc2 "Document"
	  childList "NodeList"
	  childList2 "NodeList"
	  elem2 "Element"
	  elem "Element"
	  firstChild "Node"
	  nodeName "String"
	  replaced "Node"
	|
	"implementationAttribute not supported: namespaceAware"
	"implementationAttribute not supported: expandEntityReferences"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	childList := doc  getElementsByTagName: 'p' ns: '*'.
	elem := childList  item:0.
	firstChild := elem  firstChild.
	doc2 :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	childList2 := doc2  getElementsByTagName: 'p' ns: '*'.
	elem2 := childList2  item:0.
	"assertDOMException..."
	self should:[
	elem  replaceChild:firstChild with: elem2.
	] raise: DOMException.
	self assert: (lastException code == DOMException WRONG_DOCUMENT_ERR).
	"end of assertDOMException..."

!

test_nodereplacechild28
	"
Attempt to replace a text node with a text node from an
entity reference. Since the replacing text node should be removed
from its current location first, a NO_MODIFICATION_ALLOWED_ERR should
be thrown.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-785887307
	"
	|
	  doc "Document"
	  childList "NodeList"
	  acronym "Element"
	  betaRef "EntityReference"
	  dallas "Text"
	  betaText "Node"
	  appendedChild "Node"
	  replacedChild "Node"
	|
	"implementationAttribute not supported: expandEntityReferences"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	childList := doc  getElementsByTagName: 'acronym'.
	acronym := childList  item:1.
	betaRef := acronym  firstChild.
	self assert: betaRef notNil.
	betaText := betaRef  firstChild.
	self assert: betaText notNil.
	dallas := betaRef  nextSibling.
	self assert: dallas notNil.
	"assertDOMException..."
	self should:[
	acronym  replaceChild:dallas with: betaText.
	] raise: DOMException.
	self assert: (lastException code == DOMException NO_MODIFICATION_ALLOWED_ERR).
	"end of assertDOMException..."

!

test_nodereplacechild29
	"
	Using replaceChild on an Element node attempt to replace a new Element node with 
	another new Element node and verify if a NOT_FOUND_ERR gets thrown.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-785887307
	"
	|
	  doc "Document"
	  childList "NodeList"
	  elem "Element"
	  oldChild "Element"
	  newChild "Element"
	  replaced "Node"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	childList := doc  getElementsByTagName: 'p'.
	elem := childList  item:0.
	oldChild := doc  createElement:'dom3:br' ns:'http://www.w3.org/1999/xhtml'.
	newChild := doc  createElement:'dom3:span' ns:'http://www.w3.org/1999/xhtml'.
	"assertDOMException..."
	self should:[
	elem  replaceChild:oldChild with: newChild.
	] raise: DOMException.
	self assert: (lastException code == DOMException NOT_FOUND_ERR).
	"end of assertDOMException..."

!

test_nodereplacechild30
	"



	Using replaceChild on an Element node attempt to replace a new Element child node with 
	new child nodes and vice versa and in each case verify the name of the replaced node.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-785887307
	"
	|
	  doc "Document"
	  parent "Element"
	  oldChild "Element"
	  newElement "Element"
	  newText "Text"
	  newComment "Comment"
	  newPI "ProcessingInstruction"
	  newCdata "CDATASection"
	  newERef "EntityReference"
	  replaced "Node"
	  nodeName "String"
	  appendedChild "Node"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	parent := doc  createElement:'xhtml:html' ns:'http://www.w3.org/1999/xhtml'.
	oldChild := doc  createElement:'xhtml:head' ns:'http://www.w3.org/1999/xhtml'.
	newElement := doc  createElement:'xhtml:body' ns:'http://www.w3.org/1999/xhtml'.
	appendedChild := parent  appendChild:oldChild.
	appendedChild := parent  appendChild:newElement.
	newText := doc  createTextNode:'Text'.
	appendedChild := parent  appendChild:newText.
	newComment := doc  createComment:'Comment'.
	appendedChild := parent  appendChild:newComment.
	newPI := doc  createProcessingInstruction:'target' data:'data'.
	appendedChild := parent  appendChild:newPI.
	newCdata := doc  createCDATASection:'Cdata'.
	appendedChild := parent  appendChild:newCdata.
	newERef := doc  createEntityReference:'delta'.
	appendedChild := parent  appendChild:newERef.
	parent  replaceChild:oldChild with: newElement.
	nodeName := replaced  nodeName.
	self assert: ( nodeName = 'xhtml:head' ).
	parent  replaceChild:newElement with: oldChild.
	nodeName := replaced  nodeName.
	self assert: ( nodeName = 'xhtml:body' ).
	parent  replaceChild:oldChild with: newText.
	nodeName := replaced  nodeName.
	self assert: ( nodeName = 'xhtml:head' ).
	parent  replaceChild:newText with: oldChild.
	nodeName := replaced  nodeName.
	self assert: ( nodeName = '#text' ).
	parent  replaceChild:oldChild with: newComment.
	nodeName := replaced  nodeName.
	self assert: ( nodeName = 'xhtml:head' ).
	parent  replaceChild:newComment with: oldChild.
	nodeName := replaced  nodeName.
	self assert: ( nodeName = '#comment' ).
	parent  replaceChild:newPI with: oldChild.
	nodeName := replaced  nodeName.
	self assert: ( nodeName = 'target' ).
	parent  replaceChild:newCdata with: oldChild.
	nodeName := replaced  nodeName.
	self assert: ( nodeName = '#cdata-section' ).
	parent  replaceChild:newERef with: oldChild.
	nodeName := replaced  nodeName.
	self assert: ( nodeName = 'delta' ).

!

test_nodereplacechild31
	"
	Using replaceChild on an Element node that is the replacement Text of an EntityReference
	node, attempt to replace its Text child node with a new Element node and verify if 
	a NO_MODIFICATION_ALLOWED_ERR gets thrown.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-785887307
	"
	|
	  doc "Document"
	  childList "NodeList"
	  elem "Element"
	  span "Element"
	  ent4Ref "EntityReference"
	  spanText "Text"
	  newChild "Element"
	  replaced "Node"
	|
	"implementationAttribute not supported: expandEntityReferences"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	childList := doc  getElementsByTagName: 'var'.
	elem := childList  item:2.
	ent4Ref := elem  firstChild.
	span := ent4Ref  firstChild.
	self assert: span notNil.
	spanText := span  firstChild.
	self assert: spanText notNil.
	newChild := doc  createElement:'xhtml:p' ns:'http://www.w3.org/1999/xhtml'.
	"assertDOMException..."
	self should:[
	span  replaceChild:spanText with: newChild.
	] raise: DOMException.
	self assert: (lastException code == DOMException NO_MODIFICATION_ALLOWED_ERR).
	"end of assertDOMException..."

!

test_nodereplacechild32
	"
	The method replaceChild replaces the child node oldChild with newChild in the list of 
	children, and returns the oldChild node.

	Using replaceChild on an Attr node to replace its EntityReference Child with a 
	new Text Node and verify the name of the replaced child.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-785887307
	"
	|
	  doc "Document"
	  childList "NodeList"
	  elem "Element"
	  parent "Attr"
	  oldChild "Node"
	  newChild "Text"
	  replaced "Node"
	  nodeName "String"
	  nodeType "SmallInteger"
	  enRef "EntityReference"
	  enRefChild "EntityReference"
	  reference "String"
	|
	"implementationAttribute not supported: namespaceAware"
	"implementationAttribute not supported: expandEntityReferences"
	reference := 'entity1'.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	newChild := doc  createTextNode:'Text'.
	childList := doc  getElementsByTagName: 'acronym' ns: '*'.
	elem := childList  item:3.
	parent := elem  getAttributeNode:'class'.
	enRef := doc  createEntityReference:reference.
	enRefChild := parent  appendChild:enRef.
	parent  replaceChild:enRefChild with: newChild.
	nodeName := replaced  nodeName.
	self assert: ( nodeName = 'entity1' ).

!

test_nodereplacechild33
	"
	Using replaceChild on a default Attr node to replace its Text Child with a 
	new EntityReference Node and verify the value of the replaced child.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-785887307
	"
	|
	  doc "Document"
	  childList "NodeList"
	  elem "Element"
	  parent "Attr"
	  oldChild "Node"
	  newChild "EntityReference"
	  replaced "Node"
	  nodeValue "String"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	newChild := doc  createEntityReference:'delta'.
	childList := doc  getElementsByTagName: 'p'.
	elem := childList  item:3.
	parent := elem  getAttributeNode:'dir'.
	oldChild := parent  lastChild.
	parent  replaceChild:oldChild with: newChild.
	nodeValue := replaced  nodeValue.
	self assert: ( nodeValue = 'rtl' ).

!

test_nodereplacechild34
	"
	Using replaceChild on a new Attr node, replace its new EntityReference Child with a 
	new Text Node and verify the value of the new child.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-785887307
	"
	|
	  doc "Document"
	  parent "Attr"
	  oldChild "EntityReference"
	  newChild "Text"
	  nodeValue "String"
	  appendedChild "Node"
	  replaced "Node"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	parent := doc  createAttribute:'xml:lang' ns:'http://www.w3.org/XML/1998/namespace'.
	oldChild := doc  createEntityReference:'delta'.
	appendedChild := parent  appendChild:oldChild.
	newChild := doc  createTextNode:'Text'.
	parent  replaceChild:oldChild with: newChild.
	nodeValue := parent value.
	self assert: ( nodeValue = 'Text' ).

!

test_nodereplacechild35
	"
	Using replaceChild on a new Attr node, replace its new EntityRefernece Child with a 
	new Attr Node and verify if a HIERARCHY_REQUEST_ERR is thrown.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-785887307
	"
	|
	  doc "Document"
	  parent "Attr"
	  oldChild "EntityReference"
	  newChild "Attr"
	  nodeValue "String"
	  appendedChild "Node"
	  replaced "Node"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	parent := doc  createAttribute:'xml:lang' ns:'http://www.w3.org/XML/1998/namespace'.
	oldChild := doc  createEntityReference:'delta'.
	appendedChild := parent  appendChild:oldChild.
	newChild := doc  createAttribute:'xml:lang' ns:'http://www.w3.org/XML/1998/namespace'.
	"assertDOMException..."
	self should:[
	parent  replaceChild:oldChild with: newChild.
	] raise: DOMException.
	self assert: (lastException code == DOMException HIERARCHY_REQUEST_ERR).
	"end of assertDOMException..."

!

test_nodereplacechild36
	"
	Using replaceChild on a new Attr node, replace its new EntityRefernece node with a 
	new Text Node and verify if a NOT_FOUND_ERR is thrown.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-785887307
	"
	|
	  doc "Document"
	  parent "Attr"
	  oldChild "EntityReference"
	  newChild "Text"
	  nodeValue "String"
	  replaced "Node"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	parent := doc  createAttribute:'xml:lang' ns:'http://www.w3.org/XML/1998/namespace'.
	oldChild := doc  createEntityReference:'delta'.
	newChild := doc  createTextNode:'Text'.
	"assertDOMException..."
	self should:[
	parent  replaceChild:oldChild with: newChild.
	] raise: DOMException.
	self assert: (lastException code == DOMException NOT_FOUND_ERR).
	"end of assertDOMException..."

!

test_nodereplacechild37
	"
	Using replaceChild on a new Attr node, replace its new Text node with a 
	new EntityReference Node created by another document and verify if a 
	WRONG_DOCUMENT_ERR is raised.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-785887307
	"
	|
	  doc "Document"
	  doc2 "Document"
	  parent "Attr"
	  oldChild "Text"
	  newChild "EntityReference"
	  nodeValue "String"
	  replaced "Node"
	  appendedChild "Node"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	doc2 :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	parent := doc  createAttribute:'xml:lang' ns:'http://www.w3.org/XML/1998/namespace'.
	oldChild := doc  createTextNode:'Text'.
	newChild := doc2  createEntityReference:'delta'.
	appendedChild := parent  appendChild:oldChild.
	"assertDOMException..."
	self should:[
	parent  replaceChild:oldChild with: newChild.
	] raise: DOMException.
	self assert: (lastException code == DOMException WRONG_DOCUMENT_ERR).
	"end of assertDOMException..."

!

test_nodereplacechild38
	"
	Using replaceChild on an Entity node attempt to replace its Text child with new Text,
	Comment, ProcessingInstruction and CDATASection nodes and in each case verify if 
	a NO_MODIFICATION_ALLOWED_ERR is raised.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-785887307
	"
	|
	  doc "Document"
	  docType "DocumentType"
	  entitiesMap "NamedNodeMap"
	  ent "Entity"
	  oldChild "Text"
	  entRef "EntityReference"
	  txt "Text"
	  elem "Element"
	  comment "Comment"
	  pi "ProcessingInstruction"
	  cdata "CDATASection"
	  replaced "Node"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docType := doc  doctype.
	entitiesMap := docType  entities.
	ent := entitiesMap  getNamedItem:'alpha'.
	self assert: ent notNil.
	oldChild := ent  firstChild.
	self assert: oldChild notNil.
	cdata := doc  createCDATASection:'CDATASection'.
	"assertDOMException..."
	self should:[
	ent  replaceChild:oldChild with: cdata.
	] raise: DOMException.
	self assert: (lastException code == DOMException NO_MODIFICATION_ALLOWED_ERR).
	"end of assertDOMException..."
	pi := doc  createProcessingInstruction:'target' data:'data'.
	"assertDOMException..."
	self should:[
	ent  replaceChild:oldChild with: pi.
	] raise: DOMException.
	self assert: (lastException code == DOMException NO_MODIFICATION_ALLOWED_ERR).
	"end of assertDOMException..."
	comment := doc  createComment:'Comment'.
	"assertDOMException..."
	self should:[
	ent  replaceChild:oldChild with: comment.
	] raise: DOMException.
	self assert: (lastException code == DOMException NO_MODIFICATION_ALLOWED_ERR).
	"end of assertDOMException..."
	txt := doc  createTextNode:'Text'.
	"assertDOMException..."
	self should:[
	ent  replaceChild:oldChild with: txt.
	] raise: DOMException.
	self assert: (lastException code == DOMException NO_MODIFICATION_ALLOWED_ERR).
	"end of assertDOMException..."
	elem := doc  createElement:'xhtml:p' ns:'http://www.w3.org/1999/xhtml'.
	"assertDOMException..."
	self should:[
	ent  replaceChild:oldChild with: elem.
	] raise: DOMException.
	self assert: (lastException code == DOMException NO_MODIFICATION_ALLOWED_ERR).
	"end of assertDOMException..."
	entRef := doc  createEntityReference:'delta'.
	"assertDOMException..."
	self should:[
	ent  replaceChild:oldChild with: entRef.
	] raise: DOMException.
	self assert: (lastException code == DOMException NO_MODIFICATION_ALLOWED_ERR).
	"end of assertDOMException..."

!

test_nodereplacechild39
	"
Attempt to add a second document element by a replacing a trailing comment.  The attempt should result
in a HIERARCHY_REQUEST_ERR or NOT_SUPPORTED_ERR. 

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-785887307
	"
	|
	  doc "Document"
	  docElem "Element"
	  rootName "String"
	  rootNS "String"
	  newComment "Comment"
	  newElement "Element"
	  retNode "Node"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	docElem := doc  documentElement.
	rootName := docElem  tagName.
	rootNS := docElem  namespaceURI.
	newElement := doc  createElement:rootName ns:rootNS.
	newComment := doc  createComment:'second element goes here'.
	retNode := doc  appendChild:newComment.
	"try"
	[
	doc  replaceChild:newComment with: newElement.
self assert:false.	] on: DOMException do: [:ex|	].
	"end of try"

!

test_nodereplacechild40
	"
Attempt to add a second document element by a comment.  The attempt should result
in a HIERARCHY_REQUEST_ERR or NOT_SUPPORTED_ERR. 

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-785887307
	"
	|
	  doc "Document"
	  docElem "Element"
	  rootName "String"
	  publicId "String"
	  systemId "String"
	  newComment "Comment"
	  newDocType "DocumentType"
	  domImpl "DOMImplementation"
	  retNode "Node"
	|
	publicId := nil.
	systemId := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	docElem := doc  documentElement.
	rootName := docElem  tagName.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	newDocType := domImpl  createDocumentType:rootName publicId:publicId systemId:systemId.
	newComment := doc  createComment:'second element goes here'.
	doc  insert:newComment before: docElem.
	"try"
	[
	doc  replaceChild:newComment with: newDocType.
self assert:false.	] on: DOMException do: [:ex|	].
	"end of try"

!

test_nodesettextcontent01
	"
Attempt to set textContent for a Document node and check that the document appears
to be unaffected.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-textContent
	"
	|
	  doc "Document"
	  nodeName "String"
	  elemList "NodeList"
	  elem "Element"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	doc textContent:'textContent'.
	elemList := doc  getElementsByTagName: 'acronym'.
	elem := elemList  item:3.
	self assert: elem notNil.
	nodeName := elem  nodeName.
	self assert: ( nodeName = 'acronym' ).

!

test_nodesettextcontent02
	"
	The method setTextContent has no effect when the node is defined to be null.
	
	Using setTextContent on a new Document node, attempt to set the textContent of this
	new Document node to textContent.  Check if it was not set by checking the nodeName
	attribute of a new Element of this Document node.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-textContent
	"
	|
	  doc "Document"
	  domImpl "DOMImplementation"
	  newDoc "Document"
	  nodeName "String"
	  elemChild "Element"
	  newElem "Element"
	  elemList "NodeList"
	  nullDocType "DocumentType"
	  appendedChild "Node"
	  documentElem "Element"
	|
	"implementationAttribute not supported: namespaceAware"
	nullDocType := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	newDoc := domImpl createDocumentNS: 'http://www.w3.org/DOM/Test' qualifiedName: 'dom3:elem' doctype: nullDocType.
	newElem := newDoc  createElement:'dom3:childElem' ns:'http://www.w3.org/DOM/Test'.
	documentElem := newDoc  documentElement.
	appendedChild := documentElem  appendChild:newElem.
	newDoc textContent:'textContent'.
	elemList := newDoc  getElementsByTagName: 'childElem' ns: '*'.
	elemChild := elemList  item:0.
	nodeName := elemChild  nodeName.
	self assert: ( nodeName = 'dom3:childElem' ).

!

test_nodesettextcontent03
	"

	
	Using setTextContent on this DocumentType node, attempt to set the textContent of this
	DocumentType node to textContent.  Retreive the textContent and verify if it is null.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-textContent
	"
	|
	  doc "Document"
	  docType "DocumentType"
	  textContent "String"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docType := doc  doctype.
	docType textContent:'textContent'.
	textContent := docType  textContent.
	self assert: textContent isNil.

!

test_nodesettextcontent04
	"

	
	Using setTextContent on this DocumentType node, attempt to set the textContent of a
	Notation node to textContent.  Retreive the textContent and verify if it is null.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-textContent
	"
	|
	  doc "Document"
	  docType "DocumentType"
	  notationsMap "NamedNodeMap"
	  notation1 "Notation"
	  textContent "String"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docType := doc  doctype.
	notationsMap := docType  notations.
	notation1 := notationsMap  getNamedItem:'notation1'.
	notation1 textContent:'textContent'.
	textContent := notation1  textContent.
	self assert: textContent isNil.

!

test_nodesettextcontent05
	"

	
	Using setTextContent on a default Attr node, attempt to set its value to NA.  Retreive 
	the textContent and verify if it is was set to NA.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-textContent
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  elem "Element"
	  attr "Attr"
	  textContent "String"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'p'.
	elem := elemList  item:3.
	attr := elem  getAttributeNode:'dir'.
	attr textContent:'NA'.
	textContent := attr  textContent.
	self assert: ( textContent = 'NA' ).

!

test_nodesettextcontent06
	"

	
	Using setTextContent on a new Attr node with a null value, attempt to set its value to NA.  Retreive 
	the textContent and verify if it is was set to NA.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-textContent
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  elem "Element"
	  attr "Attr"
	  attrNode "Attr"
	  textContent "String"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elem := doc  createElement:'p' ns:'http://www.w3.org/1999/xhtml'.
	attr := doc  createAttribute:'xml:lang' ns:'http://www.w3.org/XML/1998/namespace'.
	attrNode := elem  setAttributeNodeNS: attr.
	attr textContent:'NA'.
	textContent := attr  textContent.
	self assert: ( textContent = 'NA' ).

!

test_nodesettextcontent07
	"

	
	Using setTextContent on an existing Text node, attempt to set its value to Text. 
	Retreive the textContent and verify if it is was set to Text.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-textContent
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  elem "Element"
	  txt "Text"
	  textContent "String"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'em'.
	elem := elemList  item:0.
	txt := elem  firstChild.
	txt textContent:'Text'.
	textContent := txt  textContent.
	self assert: ( textContent = 'Text' ).

!

test_nodesettextcontent08
	"

	
	Using setTextContent on a new Processing Instruction node, attempt to set its data to PID.  
	Retreive the textContent and verify if it is was set to PID.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-textContent
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  elem "Element"
	  pi "ProcessingInstruction"
	  textContent "String"
	  appendedChild "Node"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elem := doc  createElement:'xhtml:p' ns:'http://www.w3.org/1999/xhtml'.
	pi := doc  createProcessingInstruction:'PIT' data:'PID'.
	appendedChild := elem  appendChild:pi.
	pi textContent:'PID'.
	textContent := pi  textContent.
	self assert: ( textContent = 'PID' ).

!

test_nodesettextcontent10
	"
	The method setTextContent has no effect when the node is defined to be null.
	
	Using setTextContent on a new Element node, attempt to set its content to ELEMENT.
	Retreive the textContent and verify if it is was set to ELEMENT.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-textContent
	"
	|
	  doc "Document"
	  elem "Element"
	  txt "Text"
	  comment "Comment"
	  entRef "EntityReference"
	  cdata "CDATASection"
	  pi "ProcessingInstruction"
	  textContent "String"
	  appendedChild "Node"
	|
	"implementationAttribute not supported: namespaceAware"
	^self. "Validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elem := doc  createElement:'dom3:elem' ns:'http://www.w3.org/DOM/Test'.
	txt := doc  createTextNode:'Text '.
	comment := doc  createComment:'Comment '.
	entRef := doc  createEntityReference:'ent1'.
	pi := doc  createProcessingInstruction:'PIT' data:'PIData '.
	cdata := doc  createCDATASection:'CData'.
	appendedChild := elem  appendChild:txt.
	appendedChild := elem  appendChild:comment.
	appendedChild := elem  appendChild:entRef.
	appendedChild := elem  appendChild:pi.
	appendedChild := elem  appendChild:cdata.
	elem textContent:'ELEMENT'.
	textContent := elem  textContent.
	self assert: ( textContent = 'ELEMENT' ).

!

test_nodesettextcontent11
	"

	
	Using setTextContent on a new DocumentFragment node Element child, attempt to set its content to 
	DOCUMENTFRAGMENT.  Retreive the textContent and verify if it is was set to DOCUMENTFRAGMENT

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-textContent
	"
	|
	  doc "Document"
	  docFrag "DocumentFragment"
	  elem "Element"
	  elemChild "Element"
	  txt "Text"
	  comment "Comment"
	  entRef "EntityReference"
	  cdata "CDATASection"
	  pi "ProcessingInstruction"
	  textContent "String"
	  appendedChild "Node"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docFrag := doc  createDocumentFragment.
	elem := doc  createElement:'xhtml:p' ns:'http://www.w3.org/1999/xhtml'.
	txt := doc  createTextNode:'Text '.
	comment := doc  createComment:'Comment '.
	entRef := doc  createEntityReference:'alpha'.
	pi := doc  createProcessingInstruction:'PIT' data:'PIData '.
	cdata := doc  createCDATASection:'CData'.
	appendedChild := elem  appendChild:txt.
	appendedChild := elem  appendChild:comment.
	appendedChild := elem  appendChild:entRef.
	appendedChild := elem  appendChild:pi.
	appendedChild := elem  appendChild:cdata.
	appendedChild := docFrag  appendChild:elem.
	elem textContent:'DOCUMENTFRAGMENT'.
	elemChild := docFrag  lastChild.
	textContent := elemChild  textContent.
	self assert: ( textContent = 'DOCUMENTFRAGMENT' ).

!

test_nodesettextcontent12
	"

	
	Using setTextContent on a new EntityReference node, attempt to set its value.
	Since EntityReference nodes are ReadOnly, check if a NO_MODIFICATION_ALLOWED_ERR  
	is raised.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-textContent
	"
	|
	  doc "Document"
	  elem "Element"
	  entRef "EntityReference"
	  textContent "String"
	  appendedChild "Node"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elem := doc  documentElement.
	entRef := doc  createEntityReference:'beta'.
	appendedChild := elem  appendChild:entRef.
	"assertDOMException..."
	self should:[
	entRef textContent:'NA'.
	] raise: DOMException.
	self assert: (lastException code == DOMException NO_MODIFICATION_ALLOWED_ERR).
	"end of assertDOMException..."

!

test_nodesettextcontent13
	"

	
	Using setTextContent on an Entity node, attempt to set its replacement text.  
	Since Entity nodes are ReadOnly, check if a NO_MODIFICATION_ALLOWED_ERR  
	is raised.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-textContent
	"
	|
	  doc "Document"
	  docType "DocumentType"
	  entity "Entity"
	  entitymap "NamedNodeMap"
	  textContent "String"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docType := doc  doctype.
	entitymap := docType  entities.
	entity := entitymap  getNamedItem:'delta'.
	"assertDOMException..."
	self should:[
	entity textContent:'NA'.
	] raise: DOMException.
	self assert: (lastException code == DOMException NO_MODIFICATION_ALLOWED_ERR).
	"end of assertDOMException..."

!

test_nodesetuserdata01
	"

	
	Using setUserData with null values for the UserData and the handler parameters, check
	if returned the current userData object of this Document node is null.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-setUserData
	"
	|
	  doc "Document"
	  userData "DOMUserData"
	  prevUserData "DOMUserData"
	  nullHandler "UserDataHandler"
	  nullData "DOMUserData"
	|
	nullHandler := nil.
	nullData := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	prevUserData := doc  setUserData:nullData handler: nullHandler forKey:'something'.
	self assert: prevUserData isNil.

!

test_nodesetuserdata02
	"

	
	Using setUserData with values for the UserData as this Document and the handler as null
	parameters, check if returned the current userData object of this Document node is null.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-setUserData
	"
	|
	  doc "Document"
	  userData "DOMUserData"
	  prevUserData "DOMUserData"
	  test "DOMUserData"
	  str "String"
	  nullHandler "UserDataHandler"
	|
	test := nil.
	str := 'Junk'.
	nullHandler := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	prevUserData := doc  setUserData:test handler: nullHandler forKey:'something'.
	self assert: prevUserData isNil.

!

test_nodesetuserdata03
	"
	Invoke setUserData on this Document to set this Documents UserData to a new
	Element node.  Do the same with a new Text node and using isNodeEqual verify
	the returned Element UserData object.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-setUserData
	"
	|
	  doc "Document"
	  userData "DOMUserData"
	  retUserData "DOMUserData"
	  returnedUserData "DOMUserData"
	  success "Boolean"
	  elem "Element"
	  txt "Text"
	  nullHandler "UserDataHandler"
	|
	nullHandler := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elem := doc  createElement:'xhtml:p' ns:'http://www.w3.org/1999/xhtml'.
	txt := doc  createTextNode:'TEXT'.
	returnedUserData := doc  setUserData:elem handler: nullHandler forKey:'Key1'.
	retUserData := doc  setUserData:txt handler: nullHandler forKey:'Key1'.
	success := retUserData  isEqualNode:elem.
	self assert: success.

!

test_nodesetuserdata04
	"

	
	Invoke setUserData on a new Element to set its UserData to a new Text node
	twice using different Keys.  Using getUserData with each Key and isNodeEqual 
	verify if the returned nodes are Equal.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-setUserData
	"
	|
	  doc "Document"
	  userData "DOMUserData"
	  returned1 "DOMUserData"
	  returned2 "DOMUserData"
	  retUserData "DOMUserData"
	  success "Boolean"
	  elem "Element"
	  txt "Text"
	  nullHandler "UserDataHandler"
	|
	nullHandler := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elem := doc  createElement:'p' ns:'http://www.w3.org/1999/xhtml'.
	txt := doc  createTextNode:'TEXT'.
	retUserData := elem  setUserData:txt handler: nullHandler forKey:'Key1'.
	retUserData := elem  setUserData:txt handler: nullHandler forKey:'Key2'.
	returned1 := elem  getUserDataForKey:'Key1'.
	returned2 := elem  getUserDataForKey:'Key2'.
	success := returned1  isEqualNode:returned2.
	self assert: success.

!

test_nodesetuserdata05
	"

	
	Invoke setUserData on a new Attr to set its UserData to two Document nodes
	obtained by parsing the same xml document.  Using getUserData and isNodeEqual 
	verify if the returned nodes are Equal.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-setUserData
	"
	|
	  doc "Document"
	  doc2 "Document"
	  userData "DOMUserData"
	  returned1 "DOMUserData"
	  returned2 "DOMUserData"
	  retUserData "DOMUserData"
	  success "Boolean"
	  attr "Attr"
	  nullHandler "UserDataHandler"
	|
	nullHandler := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	doc2 :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	attr := doc  createAttribute:'lang' ns:'http://www.w3.org/XML/1998/namespace'.
	retUserData := attr  setUserData:doc handler: nullHandler forKey:'Key1'.
	retUserData := attr  setUserData:doc2 handler: nullHandler forKey:'Key2'.
	returned1 := attr  getUserDataForKey:'Key1'.
	returned2 := attr  getUserDataForKey:'Key2'.
	success := returned1  isEqualNode:returned2.
	self assert: success.

!

test_nodesetuserdata06
	"

	
	Invoke setUserData on a new Comment to set its UserData to an Entity node 
	twice using the same key.  Verify if the UserData object that was by the 
	second setUserData is the same as original Entity.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-setUserData
	"
	|
	  doc "Document"
	  docType "DocumentType"
	  entities "NamedNodeMap"
	  entity "Entity"
	  comment "Comment"
	  userData "DOMUserData"
	  returned "DOMUserData"
	  retUserData "DOMUserData"
	  success "Boolean"
	  nullHandler "UserDataHandler"
	|
	nullHandler := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docType := doc  doctype.
	entities := docType  entities.
	entity := entities  getNamedItem:'delta'.
	comment := doc  createComment:'COMMENT_NODE'.
	retUserData := comment  setUserData:entity handler: nullHandler forKey:'Key1'.
	returned := comment  setUserData:entity handler: nullHandler forKey:'Key1'.
	success := returned  isEqualNode:entity.
	self assert: success.

!

test_nodesetuserdata07
	"

	
	Invoke setUserData on a Notation to set its UserData to a Comment node 
	twice using the same key.  Verify if the UserData object that was returned 
	by second setUserData is the Comment node set in the first setUserData call.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-setUserData
	"
	|
	  doc "Document"
	  docType "DocumentType"
	  notations "NamedNodeMap"
	  notation "Notation"
	  comment "Comment"
	  userData "DOMUserData"
	  returned "DOMUserData"
	  success "Boolean"
	  retUserData "DOMUserData"
	  nullHandler "UserDataHandler"
	|
	nullHandler := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docType := doc  doctype.
	notations := docType  notations.
	notation := notations  getNamedItem:'notation1'.
	comment := doc  createComment:'COMMENT_NODE'.
	retUserData := notation  setUserData:comment handler: nullHandler forKey:'Key1'.
	returned := notation  setUserData:comment handler: nullHandler forKey:'Key1'.
	success := returned  isEqualNode:comment.
	self assert: success.

!

test_nodesetuserdata08
	"
	Invoke setUserData on a CDATASection and EntityReference node to set their 
	UserData to this Document and DocumentElement node.  Verify if the UserData 
	object that was set for both nodes is different.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-setUserData
	"
	|
	  doc "Document"
	  docElem "Element"
	  entRef "EntityReference"
	  cData "CDATASection"
	  elemList "NodeList"
	  elemName "Element"
	  userData "DOMUserData"
	  returned1 "DOMUserData"
	  returned2 "DOMUserData"
	  success "Boolean"
	  retUserData "DOMUserData"
	  nullHandler "UserDataHandler"
	|
	nullHandler := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docElem := doc  documentElement.
	entRef := doc  createEntityReference:'delta'.
	cData := doc  createCDATASection:'CDATASection'.
	retUserData := entRef  setUserData:doc handler: nullHandler forKey:'Key1'.
	retUserData := cData  setUserData:docElem handler: nullHandler forKey:'Key2'.
	returned1 := entRef  getUserDataForKey:'Key1'.
	returned2 := cData  getUserDataForKey:'Key2'.
	success := returned1  isEqualNode:returned2.
	self deny: success.

!

test_nodesetuserdata09
	"

	
	Invoke setUserData on this documentElement node to set its UserData to 
	this Document node.  Invoke getUserData on this Document node with the same
	key of the UserData that was just set on the documentElement node and verify 
	if the returned node is null.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-setUserData
	"
	|
	  doc "Document"
	  docElem "Element"
	  returned "DOMUserData"
	  nullHandler "UserDataHandler"
	  retUserData "DOMUserData"
	|
	nullHandler := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docElem := doc  documentElement.
	retUserData := docElem  setUserData:doc handler: nullHandler forKey:'Key1'.
	returned := doc  getUserDataForKey:'Key1'.
	self assert: returned isNil.

!

test_nodesetuserdata10
	"
	Invoke setUserData on a CDATASection and EntityReference node to set their 
	UserData to this Document and DocumentElement node.  Verify if the UserData 
	object that was set for both nodes is different.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Node3-setUserData
	"
	|
	  doc "Document"
	  docElem "Element"
	  entRef "Node"
	  cData "CDATASection"
	  varList "NodeList"
	  varElem "Element"
	  userData "DOMUserData"
	  returned1 "DOMUserData"
	  returned2 "DOMUserData"
	  success "Boolean"
	  retUserData "DOMUserData"
	  nullHandler "UserDataHandler"
	|
	nullHandler := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	docElem := doc  documentElement.
	varList := doc  getElementsByTagName: 'var'.
	varElem := varList  item:2.
	entRef := varElem  firstChild.
	cData := doc  createCDATASection:'CDATASection'.
	retUserData := entRef  setUserData:doc handler: nullHandler forKey:'Key1'.
	retUserData := cData  setUserData:docElem handler: nullHandler forKey:'Key2'.
	returned1 := entRef  getUserDataForKey:'Key1'.
	returned2 := cData  getUserDataForKey:'Key2'.
	success := returned1  isEqualNode:returned2.
	self deny: success.

!

test_normalizecharacters01
	"
Normalize document with normalize-characters set to false, check that
characters are not normalized.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-normalizeDocument
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-normalize-characters
		Subject http://www.w3.org/TR/2003/WD-charmod-20030822/
	"
	|
	  doc "Document"
	  docElem "Element"
	  domConfig "DOMConfiguration"
	  errorMonitor "DOMErrorMonitor"
	  pList "NodeList"
	  pElem "Element"
	  text "Text"
	  textValue "String"
	  retval "Node"
	|
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	domConfig := doc domConfig.
	domConfig setParameter: 'normalize-characters' value: false.
	domConfig setParameter: 'error-handler' value: errorMonitor.
	pList := doc  getElementsByTagName: 'p'.
	pElem := pList  item:0.
	text := doc  createTextNode:'suçon'.
	retval := pElem  appendChild:text.
	doc  normalizeDocument.
	errorMonitor  assertLowerSeverityFor: self message:'normalizeError' severity: DOMErrorMonitor SEVERITY_ERROR.
	pList := doc  getElementsByTagName: 'p'.
	pElem := pList  item:0.
	text := pElem  firstChild.
	textValue := text  nodeValue.
	self assert: ( textValue = 'barsuçon' ).

!

test_normalizecharacters02
	"
Normalize document with normalize-characters set to true, check that
characters are normalized.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-normalizeDocument
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-normalize-characters
		Subject http://www.w3.org/TR/2003/WD-charmod-20030822/
	"
	|
	  doc "Document"
	  docElem "Element"
	  domConfig "DOMConfiguration"
	  errorMonitor "DOMErrorMonitor"
	  pList "NodeList"
	  pElem "Element"
	  text "Text"
	  textValue "String"
	  retval "Node"
	  canSet "Boolean"
	|
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	domConfig := doc domConfig.
	canSet := domConfig canSetParameter: 'normalize-characters' value: true.
	"if"
	(canSet) ifTrue: [
														].

!

test_normalizecharacters03
	"
Normalize an element with normalize-characters set to false, check that
characters are not normalized.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-normalize
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-normalize-characters
		Subject http://www.w3.org/TR/2003/WD-charmod-20030822/
	"
	|
	  doc "Document"
	  docElem "Element"
	  domConfig "DOMConfiguration"
	  errorMonitor "DOMErrorMonitor"
	  pList "NodeList"
	  pElem "Element"
	  text "Text"
	  textValue "String"
	  retval "Node"
	|
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	domConfig := doc domConfig.
	domConfig setParameter: 'normalize-characters' value: false.
	domConfig setParameter: 'error-handler' value: errorMonitor.
	pList := doc  getElementsByTagName: 'p'.
	pElem := pList  item:0.
	text := doc  createTextNode:'suçon'.
	retval := pElem  appendChild:text.
	pElem  normalize.
	errorMonitor  assertLowerSeverityFor: self message:'normalizeError' severity: DOMErrorMonitor SEVERITY_ERROR.
	pList := doc  getElementsByTagName: 'p'.
	pElem := pList  item:0.
	text := pElem  firstChild.
	textValue := text  nodeValue.
	self assert: ( textValue = 'barsuçon' ).

!

test_normalizecharacters04
	"
Normalize an element with normalize-characters set to true, check that
characters are normalized.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-normalize
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-normalize-characters
		Subject http://www.w3.org/TR/2003/WD-charmod-20030822/
	"
	|
	  doc "Document"
	  docElem "Element"
	  domConfig "DOMConfiguration"
	  errorMonitor "DOMErrorMonitor"
	  pList "NodeList"
	  pElem "Element"
	  text "Text"
	  textValue "String"
	  retval "Node"
	  canSet "Boolean"
	|
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	domConfig := doc domConfig.
	canSet := domConfig canSetParameter: 'normalize-characters' value: true.
	"if"
	(canSet) ifTrue: [
														].

!

test_normalizecharacters05
	"
Normalize an document (using Node.normalize) with normalize-characters set to false, check that
characters are not normalized.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-normalize
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-normalize-characters
		Subject http://www.w3.org/TR/2003/WD-charmod-20030822/
	"
	|
	  doc "Document"
	  docElem "Element"
	  domConfig "DOMConfiguration"
	  errorMonitor "DOMErrorMonitor"
	  pList "NodeList"
	  pElem "Element"
	  text "Text"
	  textValue "String"
	  retval "Node"
	|
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	domConfig := doc domConfig.
	domConfig setParameter: 'normalize-characters' value: false.
	domConfig setParameter: 'error-handler' value: errorMonitor.
	pList := doc  getElementsByTagName: 'p'.
	pElem := pList  item:0.
	text := doc  createTextNode:'suçon'.
	retval := pElem  appendChild:text.
	doc  normalize.
	errorMonitor  assertLowerSeverityFor: self message:'normalizeError' severity: DOMErrorMonitor SEVERITY_ERROR.
	pList := doc  getElementsByTagName: 'p'.
	pElem := pList  item:0.
	text := pElem  firstChild.
	textValue := text  nodeValue.
	self assert: ( textValue = 'barsuçon' ).

!

test_normalizecharacters06
	"
Normalize a document (using Node.normalize) with normalize-characters set to true, check that
characters are normalized.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-normalize
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-normalize-characters
		Subject http://www.w3.org/TR/2003/WD-charmod-20030822/
	"
	|
	  doc "Document"
	  docElem "Element"
	  domConfig "DOMConfiguration"
	  errorMonitor "DOMErrorMonitor"
	  pList "NodeList"
	  pElem "Element"
	  text "Text"
	  textValue "String"
	  retval "Node"
	  canSet "Boolean"
	|
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	domConfig := doc domConfig.
	canSet := domConfig canSetParameter: 'normalize-characters' value: true.
	"if"
	(canSet) ifTrue: [
														].

!

test_normalizecharacters07
	"
Normalize a text node with normalize-characters set to false, check that
characters are not normalized.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-normalize
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-normalize-characters
		Subject http://www.w3.org/TR/2003/WD-charmod-20030822/
	"
	|
	  doc "Document"
	  docElem "Element"
	  domConfig "DOMConfiguration"
	  errorMonitor "DOMErrorMonitor"
	  pList "NodeList"
	  pElem "Element"
	  text "Text"
	  textValue "String"
	  retval "Node"
	|
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	domConfig := doc domConfig.
	domConfig setParameter: 'normalize-characters' value: false.
	domConfig setParameter: 'error-handler' value: errorMonitor.
	pList := doc  getElementsByTagName: 'p'.
	pElem := pList  item:0.
	text := doc  createTextNode:'suçon'.
	retval := pElem  appendChild:text.
	retval  normalize.
	errorMonitor  assertLowerSeverityFor: self message:'normalizeError' severity: DOMErrorMonitor SEVERITY_ERROR.
	pList := doc  getElementsByTagName: 'p'.
	pElem := pList  item:0.
	text := pElem  lastChild.
	textValue := text  nodeValue.
	self assert: ( textValue = 'suçon' ).

!

test_normalizecharacters08
	"
Normalize a text node with normalize-characters set to true, check that
characters are normalized.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-normalize
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-normalize-characters
		Subject http://www.w3.org/TR/2003/WD-charmod-20030822/
	"
	|
	  doc "Document"
	  docElem "Element"
	  domConfig "DOMConfiguration"
	  errorMonitor "DOMErrorMonitor"
	  pList "NodeList"
	  pElem "Element"
	  text "Text"
	  textValue "String"
	  retval "Node"
	  canSet "Boolean"
	|
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	domConfig := doc domConfig.
	canSet := domConfig canSetParameter: 'normalize-characters' value: true.
	"if"
	(canSet) ifTrue: [
														].

!

test_splitcdatasections01
	"
Add a CDATASection containing  ]]>  and call Node.normalize which should not
split or raise warning.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-normalize
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-split-cdata-sections
	"
	|
	  doc "Document"
	  elem "Element"
	  domConfig "DOMConfiguration"
	  elemList "NodeList"
	  newChild "CDATASection"
	  oldChild "Node"
	  retval "Node"
	  errorMonitor "DOMErrorMonitor"
	  errors "List"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	elemList := doc  getElementsByTagName: 'p'.
	elem := elemList  item:0.
	oldChild := elem  firstChild.
	newChild := doc  createCDATASection:'this is not ]]> good'.
	elem  replaceChild:oldChild with: newChild.
	domConfig := doc domConfig.
	domConfig setParameter: 'split-cdata-sections' value: false.
	domConfig setParameter: 'error-handler' value: errorMonitor.
	doc  normalize.
	errorMonitor  assertLowerSeverityFor: self message:'noErrors' severity: DOMErrorMonitor SEVERITY_ERROR.

!

test_textiselementcontentwhitespace01
	"
	Invoke isElementContentWhitespace on a newly created Text Node that contains only whitespace.
Should be false since there is no content model to determine if the node appears within element content.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Text3-isElementContentWhitespace
	"
	|
	  doc "Document"
	  newText "Text"
	  hasWhitespace "Boolean"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	newText := doc  createTextNode:'   '.
	hasWhitespace := newText  isElementContentWhitespace.
	self deny: hasWhitespace.

!

test_textiselementcontentwhitespace02
	"
Get the text node child of the  p  element in barfoo.  isElementContentWhitespace should
be false since the node is neither whitespace or in element content.  

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Text3-isElementContentWhitespace
	"
	|
	  doc "Document"
	  pList "NodeList"
	  pElem "Element"
	  textNode "Text"
	  isElemContentWhitespace "Boolean"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	pList := doc  getElementsByTagName: 'p'.
	pElem := pList  item:0.
	textNode := pElem  firstChild.
	isElemContentWhitespace := textNode  isElementContentWhitespace.
	self deny: isElemContentWhitespace.

!

test_textiselementcontentwhitespace03
	"
Get the newline between the  body  and  p  element.  Since node is both in element content
and whitespace, isElementContentWhitespace should return true.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Text3-isElementContentWhitespace
	"
	|
	  doc "Document"
	  pList "NodeList"
	  pElem "Element"
	  textNode "Text"
	  isElemContentWhitespace "Boolean"
	|
	^self. "Validation not supported"
	"implementationAttribute not supported: ignoringElementContentWhitespace"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	pList := doc  getElementsByTagName: 'p'.
	pElem := pList  item:0.
	textNode := pElem  previousSibling.
	isElemContentWhitespace := textNode  isElementContentWhitespace.
	self assert: isElemContentWhitespace.

!

test_textiselementcontentwhitespace04
	"
Replace the text node child of the  p  element in barfoo with whitespace and normalize with validation.
isElementContentWhitespace should be false since the node is not in element content.  

		Creator: Curt Arnold
		Autor Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Text3-isElementContentWhitespace
	"
	|
	  doc "Document"
	  pList "NodeList"
	  pElem "Element"
	  textNode "Text"
	  blankNode "Text"
	  returnedNode "Node"
	  isElemContentWhitespace "Boolean"
	  domConfig "DOMConfiguration"
	  canSetValidation "Boolean"
	  replacedNode "Node"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	domConfig := doc domConfig.
	canSetValidation := domConfig canSetParameter: 'validate' value: true.
	"if"
	(canSetValidation) ifTrue: [
											].

!

test_textiselementcontentwhitespace05
	"
Replace the whitespace before the  p  element in barfoo with non-whitespace and normalize with validation.
isElementContentWhitespace should be false since the node is not whitespace.  

		Creator: Curt Arnold
		Autor Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Text3-isElementContentWhitespace
	"
	|
	  doc "Document"
	  bodyList "NodeList"
	  bodyElem "Element"
	  textNode "Text"
	  nonBlankNode "Text"
	  returnedNode "Node"
	  isElemContentWhitespace "Boolean"
	  domConfig "DOMConfiguration"
	  canSetValidation "Boolean"
	  refChild "Node"
	  errorMonitor "DOMErrorMonitor"
	|
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	domConfig := doc domConfig.
	canSetValidation := domConfig canSetParameter: 'validate' value: true.
	"if"
	(canSetValidation) ifTrue: [
															].

!

test_textiselementcontentwhitespace06
	"
Insert whitespace before the  p  element in barfoo and normalize with validation.
isElementContentWhitespace should be true since the node is whitespace and in element content.  

		Creator: Curt Arnold
		Autor Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Text3-isElementContentWhitespace
	"
	|
	  doc "Document"
	  bodyList "NodeList"
	  bodyElem "Element"
	  refChild "Node"
	  textNode "Text"
	  blankNode "Text"
	  returnedNode "Node"
	  isElemContentWhitespace "Boolean"
	  domConfig "DOMConfiguration"
	  canSetValidation "Boolean"
	  replacedNode "Node"
	  errorMonitor "DOMErrorMonitor"
	|
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	domConfig := doc domConfig.
	canSetValidation := domConfig canSetParameter: 'validate' value: true.
	"if"
	(canSetValidation) ifTrue: [
															].

!

test_textreplacewholetext01
	"
	Invoke replaceWholeText on an existing Text Node to replace its value with a 
	new value containing white space characters.  Verify the replaceWholeText by
	verifying the values returned by wholeText
	of the returned Text node.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Text3-replaceWholeText
	"
	|
	  doc "Document"
	  itemList "NodeList"
	  elementName "Element"
	  textNode "Text"
	  replacedText "Text"
	  wholeText "String"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	itemList := doc  getElementsByTagName: 'strong'.
	elementName := itemList  item:0.
	textNode := elementName  firstChild.
	replacedText := textNode  replaceWholeText:'New Content'.
	wholeText := replacedText  wholeText.
	self assert: ( wholeText = 'New Content' ).

!

test_textreplacewholetext02
	"
	Invoke replaceWholeText on an existing Text Node to replace its value with an 
	empty string value.  Verify the repalceWholeText method by verifying if the value 
	returned is null.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Text3-replaceWholeText
	"
	|
	  doc "Document"
	  itemList "NodeList"
	  elementName "Element"
	  textNode "Text"
	  replacedText "Text"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	itemList := doc  getElementsByTagName: 'strong'.
	elementName := itemList  item:0.
	textNode := elementName  firstChild.
	replacedText := textNode  replaceWholeText:''.
	self assert: replacedText isNil.

!

test_textreplacewholetext03
	"
	Invoke replaceWholeText on an new Text Node to replace its value with a 
	new value.  Verify the repalceWholeText by verifying the values returned by 
	wholeText of the returned Text node.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Text3-replaceWholeText
	"
	|
	  doc "Document"
	  textNode "Text"
	  replacedText "Text"
	  wholeText "String"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	textNode := doc  createTextNode:'New Text'.
	replacedText := textNode  replaceWholeText:' a b c b '.
	wholeText := replacedText  wholeText.
	self assert: ( wholeText = ' a b c b ' ).

!

test_textreplacewholetext04
	"
	Invoke replaceWholeText on an new Text Node to replace its value with an 
	empty value.   

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Text3-replaceWholeText
	"
	|
	  doc "Document"
	  textNode "Text"
	  replacedText "Text"
	  wholeText "String"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	textNode := doc  createTextNode:'New Text'.
	replacedText := textNode  replaceWholeText:''.
	self assert: replacedText isNil.

!

test_textreplacewholetext05
	"
	Invoke replaceWholeText on an existing text node with newly created text and CDATASection
	nodes appended as children of its parent element node.  Verify repalceWholeText by 
	verifying the values returned by wholeText.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Text3-replaceWholeText
	"
	|
	  doc "Document"
	  itemList "NodeList"
	  elementName "Element"
	  textNode "Text"
	  cdataNode "CDATASection"
	  replacedText "Text"
	  wholeText "String"
	  appendedChild "Node"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	itemList := doc  getElementsByTagName: 'strong'.
	elementName := itemList  item:0.
	textNode := doc  createTextNode:'New Text'.
	cdataNode := doc  createCDATASection:'New CDATA'.
	appendedChild := elementName  appendChild:textNode.
	appendedChild := elementName  appendChild:cdataNode.
	textNode := elementName  firstChild.
	replacedText := textNode  replaceWholeText:'New Text and Cdata'.
	wholeText := replacedText  wholeText.
	self assert: ( wholeText = 'New Text and Cdata' ).

!

test_textreplacewholetext06
	"
	The method replaceWholeText substitutes the a specified text for the text of 
	the current node and all logically-adjacent text nodes.  This method raises
	a NO_MODIFICATION_ALLOWED_ERR if one of the Text nodes being replaced is readonly.
	
	Invoke replaceWholeText on an existing text node with newly created text and Entityreference
	nodes (whose replacement text is a character entity reference) appended as children of its parent element node.  
	Where the nodes to be removed are read-only descendants of an EntityReference, the EntityReference 
        must be removed instead of the read-only nodes. Only if any EntityReference to be removed has 
        descendants that are not EntityReference, Text, or CDATASection nodes, the replaceWholeText 
        method must fail, raising a NO_MODIFICATION_ALLOWED_ERR. Verify that the method does not raise
        an exception and verify the content of the returned text node.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Text3-replaceWholeText
	"
	|
	  doc "Document"
	  itemList "NodeList"
	  elementStrong "Element"
	  textNode "Text"
	  erefNode "EntityReference"
	  replacedText "Text"
	  appendedChild "Node"
	  nodeValue "String"
	|
	"implementationAttribute not supported: namespaceAware"
	^self. "Validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	itemList := doc  getElementsByTagName: 'strong'.
	elementStrong := itemList  item:0.
	textNode := doc  createTextNode:'New Text'.
	erefNode := doc  createEntityReference:'beta'.
	appendedChild := elementStrong  appendChild:textNode.
	appendedChild := elementStrong  appendChild:erefNode.
	textNode := elementStrong  firstChild.
	replacedText := textNode  replaceWholeText:'New Text and Cdata'.
	nodeValue := textNode  nodeValue.
	self assert: ( nodeValue = 'New Text and Cdata' ).

!

test_textreplacewholetext07
	"
Append an entity reference and a text node after to the content of the
first strong element.  Then call replaceWholeText on initial content
of that element.  Since the entity reference does not contain any 
logically-adjacent text content, only the initial text element should
be replaced. 

		Creator: IBM
		Autor Neil Delima
		Autor Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Text3-replaceWholeText
		Subject http://www.w3.org/Bugs/Public/show_bug.cgi?id=425
	"
	|
	  doc "Document"
	  itemList "NodeList"
	  elementName "Element"
	  textNode "Text"
	  erefNode "EntityReference"
	  replacedText "Text"
	  appendedChild "Node"
	  node "Node"
	  nodeValue "String"
	  nodeType "SmallInteger"
	|
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	itemList := doc  getElementsByTagName: 'strong'.
	elementName := itemList  item:0.
	erefNode := doc  createEntityReference:'ent4'.
	textNode := doc  createTextNode:'New Text'.
	appendedChild := elementName  appendChild:erefNode.
	appendedChild := elementName  appendChild:textNode.
	textNode := elementName  firstChild.
	replacedText := textNode  replaceWholeText:'New Text and Cdata'.
	textNode := elementName  firstChild.
	self assert: replacedText == textNode.
	nodeValue := textNode  nodeValue.
	self assert: ( nodeValue = 'New Text and Cdata' ).
	node := textNode  nextSibling.
	self assert: node notNil.
	nodeType := node  nodeType.
	self assert: ( nodeType = 5 ).

!

test_textreplacewholetext08
	"
Appends an entity reference containing text and an element to an existing
text node, then calls Text.replaceWholeText on the existing text node.
A NO_MODIFICATION_ALLOWED_ERR should be thrown.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Text3-replaceWholeText
		Subject http://www.w3.org/Bugs/Public/show_bug.cgi?id=425
		Subject http://www.w3.org/Bugs/Public/show_bug.cgi?id=540
	"
	|
	  doc "Document"
	  itemList "NodeList"
	  p "Element"
	  entRef "EntityReference"
	  node "Node"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	itemList := doc  getElementsByTagName: 'p'.
	p := itemList  item:0.
	entRef := doc  createEntityReference:'ent2'.
	node := p  appendChild:entRef.
	node := p  firstChild.
	"assertDOMException..."
	self should:[
	node := node  replaceWholeText:'yo'.
	] raise: DOMException.
	self assert: (lastException code == DOMException NO_MODIFICATION_ALLOWED_ERR).
	"end of assertDOMException..."

!

test_textwholetext01
	"
	Invoke wholetext on an existing Text Node that contains whitespace and verify if
	the value returned is correct.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Text3-wholeText
	"
	|
	  doc "Document"
	  itemList "NodeList"
	  elementName "Element"
	  textNode "Text"
	  nameWholeText "String"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	itemList := doc  getElementsByTagName: 'strong'.
	elementName := itemList  item:0.
	textNode := elementName  firstChild.
	nameWholeText := textNode  wholeText.
	self assert: ( nameWholeText = 'Margaret Martin' ).

!

test_textwholetext02
	"
	Invoke wholetext on an existing Text Node that contains whitespace and and verify if 
	the value returned is correct.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Text3-wholeText
	"
	|
	  doc "Document"
	  itemList "NodeList"
	  elementName "Element"
	  textNode "Text"
	  newTextNode "Text"
	  wholeText "String"
	  appendedChild "Node"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	itemList := doc  getElementsByTagName: 'strong'.
	elementName := itemList  item:0.
	newTextNode := doc  createTextNode:'New Text'.
	appendedChild := elementName  appendChild:newTextNode.
	textNode := elementName  firstChild.
	wholeText := textNode  wholeText.
	self assert: ( wholeText = 'Margaret MartinNew Text' ).

!

test_textwholetext03
	"
	Invoke wholetext on two newly created text nodes and verify if the value returned 
	is correct.

		Creator: IBM
		Autor Neil Delima
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Text3-wholeText
	"
	|
	  doc "Document"
	  elem "Element"
	  text1 "Text"
	  text2 "Text"
	  appendedChild "Node"
	  combinedText "String"
	|
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elem := doc  createElement:'p' ns:'http://www.w3.org/1999/xhtml'.
	text1 := doc  createTextNode:'Text I'.
	text2 := doc  createTextNode:' Text II'.
	appendedChild := elem  appendChild:text1.
	appendedChild := elem  appendChild:text2.
	combinedText := text1  wholeText.
	self assert: ( combinedText = 'Text I Text II' ).

!

test_typeinfogettypename03
	"
	The typeName attribute states the name of a type declared for the associated element or 
	attribute, or null if unknown. 

	Invoke getSchemaTypeInfo method on an attribute having [type definition] property.  Expose 
	{name} and {target namespace} properties of the [type definition] property.
	Verify that the typeName of id's schemaTypeInfo are correct.

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-typeName
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  attrid "Attr"
	  acElem "Element"
	  attrTypeInfo "TypeInfo"
	  typeName "String"
	|
	^self. "Schema validation not supported"
	^self. "Validation not supported"
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'acronym'.
	acElem := elemList  item:2.
	attrid := acElem  getAttributeNode:'id'.
	attrTypeInfo := attrid  schemaTypeInfo.
	typeName := attrTypeInfo  typeName.
	self assert: ( typeName = 'ID' ).

!

test_typeinfogettypename04
	"
	The typeName attribute states the name of a type declared for the associated element or 
	attribute, or null if unknown. 

	Invoke getSchemaTypeInfo method on an attribute having [member type definition]property.  Expose 
	{name} and {target namespace} properties of the [member type definition] property.
	Verify that the typeName of an em element's schemaTypeInfo is correct.

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-typeName
	"
	|
	  doc "Document"
	  docElem "Element"
	  elemList "NodeList"
	  emElem "Element"
	  elemTypeInfo "TypeInfo"
	  typeName "String"
	|
	^self. "Schema validation not supported"
	^self. "Validation not supported"
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'em'.
	emElem := elemList  item:0.
	elemTypeInfo := emElem  schemaTypeInfo.
	typeName := elemTypeInfo  typeName.
	self assert: ( typeName = 'emType' ).

!

test_typeinfogettypenamespace01
	"
	The typeNamespace attribute states the namespace of a type declared for the associated element or 
	attribute, or null if unknown. 

	Invoke getSchemaTypeInfo method on an attribute having [type definition] property.  Expose 
	{name} and {target namespace} properties of the [type definition] property.
	Verify that the typeNamespace of the attrib1 and attrib3's schemaTypeInfo are correct.

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-typeNamespace
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  acElem "Element"
	  titleAttr "Attr"
	  attrTypeInfo "TypeInfo"
	  typeNamespace "String"
	|
	^self. "Schema validation not supported"
	^self. "Validation not supported"
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'acronym'.
	acElem := elemList  item:0.
	titleAttr := acElem  getAttributeNode:'title'.
	attrTypeInfo := titleAttr  schemaTypeInfo.
	typeNamespace := attrTypeInfo  typeNamespace.
	self assert: ( typeNamespace = 'http://www.w3.org/2001/XMLSchema' ).

!

test_typeinfogettypenamespace03
	"
	The typeNamespace attribute states the namespace of a type declared for the associated element or 
	attribute, or null if unknown. 

	Invoke getSchemaTypeInfo method on an attribute having [type definition] property.  Expose 
	{name} and {target namespace} properties of the [type definition] property.
	Verify that the typeName of class's schemaTypeInfo is correct.

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-typeName
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  classAttr "Attr"
	  attrTypeInfo "TypeInfo"
	  typeNamespace "String"
	  acElem "Element"
	|
	^self. "Schema validation not supported"
	^self. "Validation not supported"
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'acronym'.
	acElem := elemList  item:1.
	classAttr := acElem  getAttributeNode:'class'.
	attrTypeInfo := classAttr  schemaTypeInfo.
	typeNamespace := attrTypeInfo  typeNamespace.
	self assert: ( typeNamespace = 'http://www.w3.org/1999/xhtml' ).

!

test_typeinfogettypenamespace04
	"
	The typeName attribute states the name of a type declared for the associated element or 
	attribute, or null if unknown. 

	Invoke getSchemaTypeInfo method on an attribute having [member type definition]property.  Expose 
	{name} and {target namespace} properties of the [member type definition] property.
	Verify that the typeNamespace of eldblUnionA's schemaTypeInfo is null??? (sv)

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-typeName
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  emElem "Element"
	  elemTypeInfo "TypeInfo"
	  typeNamespace "String"
	|
	^self. "Schema validation not supported"
	^self. "Validation not supported"
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'em'.
	emElem := elemList  item:0.
	elemTypeInfo := emElem  schemaTypeInfo.
	typeNamespace := elemTypeInfo  typeNamespace.
	self assert: ( typeNamespace = 'http://www.w3.org/1999/xhtml' ).

!

test_typeinfoisderivedfrom01
	"
DTD types always return false for isDerivedFrom.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-isDerivedFrom
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  acronymElem "Element"
	  attr "Attr"
	  elem "Element"
	  elemName "String"
	  typeInfo "TypeInfo"
	  isDerived "Boolean"
	|
	^self. "Validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'acronym'.
	acronymElem := elemList  item:0.
	attr := acronymElem  getAttributeNode:'title'.
	typeInfo := attr  schemaTypeInfo.
	self assert: typeInfo notNil.
	isDerived := typeInfo  isDerivedFromNS:'http://www.w3.org/TR/REC-xml' name:'CDATA' method:0.
	self deny: isDerived.
	isDerived := typeInfo  isDerivedFromNS:'http://www.w3.org/TR/REC-xml' name:'CDATA' method:15.
	self deny: isDerived.

!

test_typeinfoisderivedfrom02
	"
Check how xsd:string is derived from itself.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-isDerivedFrom
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  acronymElem "Element"
	  attr "Attr"
	  elem "Element"
	  elemName "String"
	  typeInfo "TypeInfo"
	  isDerived "Boolean"
	|
	^self. "Schema validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'acronym'.
	acronymElem := elemList  item:0.
	attr := acronymElem  getAttributeNode:'title'.
	typeInfo := attr  schemaTypeInfo.
	self assert: typeInfo notNil.
	isDerived := typeInfo  isDerivedFromNS:'http://www.w3.org/2001/XMLSchema' name:'string' method:1.
	self assert: isDerived.
	isDerived := typeInfo  isDerivedFromNS:'http://www.w3.org/2001/XMLSchema' name:'string' method:14.
	self deny: isDerived.
	isDerived := typeInfo  isDerivedFromNS:'http://www.w3.org/2001/XMLSchema' name:'string' method:0.
	self assert: isDerived.
	isDerived := typeInfo  isDerivedFromNS:'http://www.w3.org/2001/XMLSchema' name:'string' method:15.
	self assert: isDerived.

!

test_typeinfoisderivedfrom03
	"
Check that isDerivedFrom does considers xsd:string to be derived from anySimpleType.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-isDerivedFrom
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  acronymElem "Element"
	  attr "Attr"
	  elem "Element"
	  elemName "String"
	  typeInfo "TypeInfo"
	  isDerived "Boolean"
	  typeName "String"
	|
	^self. "Schema validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'acronym'.
	acronymElem := elemList  item:0.
	attr := acronymElem  getAttributeNode:'title'.
	typeInfo := attr  schemaTypeInfo.
	self assert: typeInfo notNil.
	typeName := typeInfo  typeName.
	self assert: ( typeName = 'string' ).
	isDerived := typeInfo  isDerivedFromNS:'http://www.w3.org/2001/XMLSchema' name:'anySimpleType' method:15.
	self assert: isDerived.

!

test_typeinfoisderivedfrom04
	"
Check if xsd:string is derived from xsd:anyType by any method.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-isDerivedFrom
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  acronymElem "Element"
	  attr "Attr"
	  elem "Element"
	  elemName "String"
	  typeInfo "TypeInfo"
	  isDerived "Boolean"
	  typeName "String"
	|
	^self. "Schema validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'acronym'.
	acronymElem := elemList  item:0.
	attr := acronymElem  getAttributeNode:'title'.
	typeInfo := attr  schemaTypeInfo.
	self assert: typeInfo notNil.
	typeName := typeInfo  typeName.
	self assert: ( typeName = 'string' ).
	isDerived := typeInfo  isDerivedFromNS:'http://www.w3.org/2001/XMLSchema' name:'anyType' method:15.
	self assert: isDerived.

!

test_typeinfoisderivedfrom05
	"
Check if xsd:string is derived from xsd:anyType by restriction.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-isDerivedFrom
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  acronymElem "Element"
	  attr "Attr"
	  elem "Element"
	  elemName "String"
	  typeInfo "TypeInfo"
	  isDerived "Boolean"
	  typeName "String"
	|
	^self. "Schema validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'acronym'.
	acronymElem := elemList  item:0.
	attr := acronymElem  getAttributeNode:'title'.
	typeInfo := attr  schemaTypeInfo.
	self assert: typeInfo notNil.
	typeName := typeInfo  typeName.
	self assert: ( typeName = 'string' ).
	isDerived := typeInfo  isDerivedFromNS:'http://www.w3.org/2001/XMLSchema' name:'anyType' method:1.
	self assert: isDerived.

!

test_typeinfoisderivedfrom06
	"
Check if xsd:string is derived from xsd:anyType by any method except restriction.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-isDerivedFrom
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  acronymElem "Element"
	  attr "Attr"
	  elem "Element"
	  elemName "String"
	  typeInfo "TypeInfo"
	  isDerived "Boolean"
	  typeName "String"
	|
	^self. "Schema validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'acronym'.
	acronymElem := elemList  item:0.
	attr := acronymElem  getAttributeNode:'title'.
	typeInfo := attr  schemaTypeInfo.
	self assert: typeInfo notNil.
	typeName := typeInfo  typeName.
	self assert: ( typeName = 'string' ).
	isDerived := typeInfo  isDerivedFromNS:'http://www.w3.org/2001/XMLSchema' name:'anyType' method:14.
	self deny: isDerived.

!

test_typeinfoisderivedfrom07
	"
Check if xsd:string is derived from xsd:anyType using 0 as derivation method.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-isDerivedFrom
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  acronymElem "Element"
	  attr "Attr"
	  elem "Element"
	  elemName "String"
	  typeInfo "TypeInfo"
	  isDerived "Boolean"
	  typeName "String"
	|
	^self. "Schema validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'acronym'.
	acronymElem := elemList  item:0.
	attr := acronymElem  getAttributeNode:'title'.
	typeInfo := attr  schemaTypeInfo.
	self assert: typeInfo notNil.
	typeName := typeInfo  typeName.
	self assert: ( typeName = 'string' ).
	isDerived := typeInfo  isDerivedFromNS:'http://www.w3.org/2001/XMLSchema' name:'anyType' method:0.
	self assert: isDerived.

!

test_typeinfoisderivedfrom08
	"
Check if classType is derived from xsd:string by any method.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-isDerivedFrom
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  acronymElem "Element"
	  attr "Attr"
	  elem "Element"
	  elemName "String"
	  typeInfo "TypeInfo"
	  isDerived "Boolean"
	  typeName "String"
	|
	^self. "Schema validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'acronym'.
	acronymElem := elemList  item:2.
	attr := acronymElem  getAttributeNode:'class'.
	typeInfo := attr  schemaTypeInfo.
	self assert: typeInfo notNil.
	typeName := typeInfo  typeName.
	self assert: ( typeName = 'classType' ).
	isDerived := typeInfo  isDerivedFromNS:'http://www.w3.org/2001/XMLSchema' name:'string' method:15.
	self assert: isDerived.

!

test_typeinfoisderivedfrom09
	"
Check if classType is derived from xsd:anySimpleType by any method.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-isDerivedFrom
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  acronymElem "Element"
	  attr "Attr"
	  elem "Element"
	  elemName "String"
	  typeInfo "TypeInfo"
	  isDerived "Boolean"
	  typeName "String"
	|
	^self. "Schema validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'acronym'.
	acronymElem := elemList  item:2.
	attr := acronymElem  getAttributeNode:'class'.
	typeInfo := attr  schemaTypeInfo.
	self assert: typeInfo notNil.
	typeName := typeInfo  typeName.
	self assert: ( typeName = 'classType' ).
	isDerived := typeInfo  isDerivedFromNS:'http://www.w3.org/2001/XMLSchema' name:'anySimpleType' method:15.
	self assert: isDerived.

!

test_typeinfoisderivedfrom10
	"
Check if classType is derived from anyType by any method.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-isDerivedFrom
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  acronymElem "Element"
	  attr "Attr"
	  elem "Element"
	  elemName "String"
	  typeInfo "TypeInfo"
	  isDerived "Boolean"
	  typeName "String"
	|
	^self. "Schema validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'acronym'.
	acronymElem := elemList  item:2.
	attr := acronymElem  getAttributeNode:'class'.
	typeInfo := attr  schemaTypeInfo.
	self assert: typeInfo notNil.
	typeName := typeInfo  typeName.
	self assert: ( typeName = 'classType' ).
	isDerived := typeInfo  isDerivedFromNS:'http://www.w3.org/2001/XMLSchema' name:'anyType' method:15.
	self assert: isDerived.

!

test_typeinfoisderivedfrom11
	"
Check if classType is derived from xsd:anyType by restriction.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-isDerivedFrom
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  acronymElem "Element"
	  attr "Attr"
	  elem "Element"
	  elemName "String"
	  typeInfo "TypeInfo"
	  isDerived "Boolean"
	  typeName "String"
	|
	^self. "Schema validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'acronym'.
	acronymElem := elemList  item:2.
	attr := acronymElem  getAttributeNode:'class'.
	typeInfo := attr  schemaTypeInfo.
	self assert: typeInfo notNil.
	typeName := typeInfo  typeName.
	self assert: ( typeName = 'classType' ).
	isDerived := typeInfo  isDerivedFromNS:'http://www.w3.org/2001/XMLSchema' name:'anyType' method:1.
	self assert: isDerived.

!

test_typeinfoisderivedfrom12
	"
Check classType is derived from anyType specifying derivationMethod as 0.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-isDerivedFrom
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  acronymElem "Element"
	  attr "Attr"
	  elem "Element"
	  elemName "String"
	  typeInfo "TypeInfo"
	  isDerived "Boolean"
	  typeName "String"
	|
	^self. "Schema validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'acronym'.
	acronymElem := elemList  item:2.
	attr := acronymElem  getAttributeNode:'class'.
	typeInfo := attr  schemaTypeInfo.
	self assert: typeInfo notNil.
	typeName := typeInfo  typeName.
	self assert: ( typeName = 'classType' ).
	isDerived := typeInfo  isDerivedFromNS:'http://www.w3.org/2001/XMLSchema' name:'anyType' method:0.
	self assert: isDerived.

!

test_typeinfoisderivedfrom13
	"
Check if classType is derived from xsd:anyType by any method other than restriction.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-isDerivedFrom
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  acronymElem "Element"
	  attr "Attr"
	  elem "Element"
	  elemName "String"
	  typeInfo "TypeInfo"
	  isDerived "Boolean"
	  typeName "String"
	|
	^self. "Schema validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'acronym'.
	acronymElem := elemList  item:2.
	attr := acronymElem  getAttributeNode:'class'.
	typeInfo := attr  schemaTypeInfo.
	self assert: typeInfo notNil.
	typeName := typeInfo  typeName.
	self assert: ( typeName = 'classType' ).
	isDerived := typeInfo  isDerivedFromNS:'http://www.w3.org/2001/XMLSchema' name:'anyType' method:14.
	self deny: isDerived.

!

test_typeinfoisderivedfrom14
	"
Check how classType is derived from itself.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-isDerivedFrom
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  acronymElem "Element"
	  attr "Attr"
	  elem "Element"
	  elemName "String"
	  typeInfo "TypeInfo"
	  isDerived "Boolean"
	  typeName "String"
	|
	^self. "Schema validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'acronym'.
	acronymElem := elemList  item:2.
	attr := acronymElem  getAttributeNode:'class'.
	typeInfo := attr  schemaTypeInfo.
	self assert: typeInfo notNil.
	typeName := typeInfo  typeName.
	self assert: ( typeName = 'classType' ).
	isDerived := typeInfo  isDerivedFromNS:'http://www.w3.org/1999/xhtml' name:'classType' method:1.
	self assert: isDerived.
	isDerived := typeInfo  isDerivedFromNS:'http://www.w3.org/1999/xhtml' name:'classType' method:14.
	self deny: isDerived.
	isDerived := typeInfo  isDerivedFromNS:'http://www.w3.org/1999/xhtml' name:'classType' method:15.
	self assert: isDerived.
	isDerived := typeInfo  isDerivedFromNS:'http://www.w3.org/1999/xhtml' name:'classType' method:0.
	self assert: isDerived.

!

test_typeinfoisderivedfrom15
	"
Check  emType  is derived from emp0001_3Type by any method.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-isDerivedFrom
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  elem "Element"
	  typeInfo "TypeInfo"
	  isDerived "Boolean"
	  typeName "String"
	|
	^self. "Schema validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'em'.
	elem := elemList  item:0.
	typeInfo := elem  schemaTypeInfo.
	self assert: typeInfo notNil.
	typeName := typeInfo  typeName.
	self assert: ( typeName = 'emType' ).
	isDerived := typeInfo  isDerivedFromNS:'http://www.w3.org/1999/xhtml' name:'emp0001_3Type' method:15.
	self assert: isDerived.

!

test_typeinfoisderivedfrom16
	"
Check emType is derived from emp0001_3Type by union.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-isDerivedFrom
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  elem "Element"
	  typeInfo "TypeInfo"
	  isDerived "Boolean"
	  typeName "String"
	|
	^self. "Schema validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'em'.
	elem := elemList  item:0.
	typeInfo := elem  schemaTypeInfo.
	self assert: typeInfo notNil.
	typeName := typeInfo  typeName.
	self assert: ( typeName = 'emType' ).
	isDerived := typeInfo  isDerivedFromNS:'http://www.w3.org/1999/xhtml' name:'emp0001_3Type' method:4.
	self assert: isDerived.

!

test_typeinfoisderivedfrom17
	"
Check if emType is derived from emp0001_3Type by any method other than union.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-isDerivedFrom
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  elem "Element"
	  typeInfo "TypeInfo"
	  isDerived "Boolean"
	  typeName "String"
	|
	^self. "Schema validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'em'.
	elem := elemList  item:0.
	typeInfo := elem  schemaTypeInfo.
	self assert: typeInfo notNil.
	typeName := typeInfo  typeName.
	self assert: ( typeName = 'emType' ).
	isDerived := typeInfo  isDerivedFromNS:'http://www.w3.org/1999/xhtml' name:'emp0001_3Type' method:11.
	self deny: isDerived.

!

test_typeinfoisderivedfrom18
	"
Check if emType is derived from xsd:ID by restriction.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-isDerivedFrom
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  elem "Element"
	  typeInfo "TypeInfo"
	  isDerived "Boolean"
	  typeName "String"
	|
	^self. "Schema validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'em'.
	elem := elemList  item:0.
	typeInfo := elem  schemaTypeInfo.
	self assert: typeInfo notNil.
	typeName := typeInfo  typeName.
	self assert: ( typeName = 'emType' ).
	isDerived := typeInfo  isDerivedFromNS:'http://www.w3.org/2001/XMLSchema' name:'ID' method:1.
	self deny: isDerived.

!

test_typeinfoisderivedfrom19
	"
Check emType is derived from anySimpleType by restriction.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-isDerivedFrom
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  elem "Element"
	  typeInfo "TypeInfo"
	  isDerived "Boolean"
	  typeName "String"
	|
	^self. "Schema validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'em'.
	elem := elemList  item:0.
	typeInfo := elem  schemaTypeInfo.
	self assert: typeInfo notNil.
	typeName := typeInfo  typeName.
	self assert: ( typeName = 'emType' ).
	isDerived := typeInfo  isDerivedFromNS:'http://www.w3.org/2001/XMLSchema' name:'anySimpleType' method:1.
	self assert: isDerived.

!

test_typeinfoisderivedfrom20
	"
Check if emType is derived from anyType by restriction.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-isDerivedFrom
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  elem "Element"
	  typeInfo "TypeInfo"
	  isDerived "Boolean"
	|
	^self. "Schema validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'em'.
	elem := elemList  item:0.
	typeInfo := elem  schemaTypeInfo.
	self assert: typeInfo notNil.
	isDerived := typeInfo  isDerivedFromNS:'http://www.w3.org/2001/XMLSchema' name:'anyType' method:1.
	self assert: isDerived.

!

test_typeinfoisderivedfrom21
	"
Check if emType is derived from itself.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-isDerivedFrom
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  elem "Element"
	  typeInfo "TypeInfo"
	  isDerived "Boolean"
	  typeName "String"
	|
	^self. "Schema validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'em'.
	elem := elemList  item:0.
	typeInfo := elem  schemaTypeInfo.
	self assert: typeInfo notNil.
	typeName := typeInfo  typeName.
	self assert: ( typeName = 'emType' ).
	isDerived := typeInfo  isDerivedFromNS:'http://www.w3.org/1999/xhtml' name:'emType' method:1.
	self assert: isDerived.
	isDerived := typeInfo  isDerivedFromNS:'http://www.w3.org/1999/xhtml' name:'emType' method:14.
	self deny: isDerived.
	isDerived := typeInfo  isDerivedFromNS:'http://www.w3.org/1999/xhtml' name:'emType' method:0.
	self assert: isDerived.
	isDerived := typeInfo  isDerivedFromNS:'http://www.w3.org/1999/xhtml' name:'emType' method:15.
	self assert: isDerived.

!

test_typeinfoisderivedfrom22
	"
Check strongType is derived from xsd:string by any method.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-isDerivedFrom
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  elem "Element"
	  typeInfo "TypeInfo"
	  isDerived "Boolean"
	  typeName "String"
	|
	^self. "Schema validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'strong'.
	elem := elemList  item:0.
	typeInfo := elem  schemaTypeInfo.
	self assert: typeInfo notNil.
	typeName := typeInfo  typeName.
	self assert: ( typeName = 'strongType' ).
	isDerived := typeInfo  isDerivedFromNS:'http://www.w3.org/2001/XMLSchema' name:'string' method:15.
	self assert: isDerived.

!

test_typeinfoisderivedfrom23
	"
Check if strongType is derived from xsd:string by list.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-isDerivedFrom
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  elem "Element"
	  typeInfo "TypeInfo"
	  isDerived "Boolean"
	  typeName "String"
	|
	^self. "Schema validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'strong'.
	elem := elemList  item:0.
	typeInfo := elem  schemaTypeInfo.
	self assert: typeInfo notNil.
	typeName := typeInfo  typeName.
	self assert: ( typeName = 'strongType' ).
	isDerived := typeInfo  isDerivedFromNS:'http://www.w3.org/2001/XMLSchema' name:'string' method:8.
	self assert: isDerived.

!

test_typeinfoisderivedfrom24
	"
Check if strongType is derived from xsd:string by any method other than list.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-isDerivedFrom
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  elem "Element"
	  typeInfo "TypeInfo"
	  isDerived "Boolean"
	  typeName "String"
	|
	^self. "Schema validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'strong'.
	elem := elemList  item:0.
	typeInfo := elem  schemaTypeInfo.
	self assert: typeInfo notNil.
	typeName := typeInfo  typeName.
	self assert: ( typeName = 'strongType' ).
	isDerived := typeInfo  isDerivedFromNS:'http://www.w3.org/2001/XMLSchema' name:'string' method:7.
	self deny: isDerived.

!

test_typeinfoisderivedfrom25
	"
Check if strongType is derived from anySimpleType by restriction.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-isDerivedFrom
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  elem "Element"
	  typeInfo "TypeInfo"
	  isDerived "Boolean"
	  typeName "String"
	|
	^self. "Schema validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'strong'.
	elem := elemList  item:0.
	typeInfo := elem  schemaTypeInfo.
	self assert: typeInfo notNil.
	typeName := typeInfo  typeName.
	self assert: ( typeName = 'strongType' ).
	isDerived := typeInfo  isDerivedFromNS:'http://www.w3.org/2001/XMLSchema' name:'anySimpleType' method:1.
	self assert: isDerived.

!

test_typeinfoisderivedfrom26
	"
Check if strongType is derived from anyType by restriction.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-isDerivedFrom
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  elem "Element"
	  typeInfo "TypeInfo"
	  isDerived "Boolean"
	  typeName "String"
	|
	^self. "Schema validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'strong'.
	elem := elemList  item:0.
	typeInfo := elem  schemaTypeInfo.
	self assert: typeInfo notNil.
	typeName := typeInfo  typeName.
	self assert: ( typeName = 'strongType' ).
	isDerived := typeInfo  isDerivedFromNS:'http://www.w3.org/2001/XMLSchema' name:'anyType' method:1.
	self assert: isDerived.

!

test_typeinfoisderivedfrom27
	"
Check if strongType is derived from anyType by union or extension.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-isDerivedFrom
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  elem "Element"
	  typeInfo "TypeInfo"
	  isDerived "Boolean"
	  typeName "String"
	|
	^self. "Schema validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'strong'.
	elem := elemList  item:0.
	typeInfo := elem  schemaTypeInfo.
	self assert: typeInfo notNil.
	typeName := typeInfo  typeName.
	self assert: ( typeName = 'strongType' ).
	isDerived := typeInfo  isDerivedFromNS:'http://www.w3.org/2001/XMLSchema' name:'anyType' method:6.
	self deny: isDerived.

!

test_typeinfoisderivedfrom28
	"
Check how strongType is derived from itself.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-isDerivedFrom
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  elem "Element"
	  typeInfo "TypeInfo"
	  isDerived "Boolean"
	  typeName "String"
	|
	^self. "Schema validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'strong'.
	elem := elemList  item:0.
	typeInfo := elem  schemaTypeInfo.
	self assert: typeInfo notNil.
	typeName := typeInfo  typeName.
	self assert: ( typeName = 'strongType' ).
	isDerived := typeInfo  isDerivedFromNS:'http://www.w3.org/1999/xhtml' name:'strongType' method:1.
	self assert: isDerived.
	isDerived := typeInfo  isDerivedFromNS:'http://www.w3.org/1999/xhtml' name:'strongType' method:14.
	self deny: isDerived.
	isDerived := typeInfo  isDerivedFromNS:'http://www.w3.org/1999/xhtml' name:'strongType' method:15.
	self assert: isDerived.
	isDerived := typeInfo  isDerivedFromNS:'http://www.w3.org/1999/xhtml' name:'strongType' method:0.
	self assert: isDerived.

!

test_typeinfoisderivedfrom29
	"
Check if anonymous type for p element is derived from pType.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-isDerivedFrom
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  elem "Element"
	  typeInfo "TypeInfo"
	  isDerived "Boolean"
	|
	^self. "Schema validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'p'.
	elem := elemList  item:0.
	typeInfo := elem  schemaTypeInfo.
	self assert: typeInfo notNil.
	isDerived := typeInfo  isDerivedFromNS:'http://www.w3.org/1999/xhtml' name:'pType' method:15.
	self assert: isDerived.

!

test_typeinfoisderivedfrom30
	"
Check if anonymous type for p element is derived from pType by restriction.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-isDerivedFrom
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  elem "Element"
	  typeInfo "TypeInfo"
	  isDerived "Boolean"
	|
	^self. "Schema validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'p'.
	elem := elemList  item:0.
	typeInfo := elem  schemaTypeInfo.
	self assert: typeInfo notNil.
	isDerived := typeInfo  isDerivedFromNS:'http://www.w3.org/1999/xhtml' name:'pType' method:1.
	self assert: isDerived.

!

test_typeinfoisderivedfrom31
	"
Check anonymous type for p element is derived from pType by any method other than restriction.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-isDerivedFrom
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  elem "Element"
	  typeInfo "TypeInfo"
	  isDerived "Boolean"
	|
	^self. "Schema validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'p'.
	elem := elemList  item:0.
	typeInfo := elem  schemaTypeInfo.
	self assert: typeInfo notNil.
	isDerived := typeInfo  isDerivedFromNS:'http://www.w3.org/1999/xhtml' name:'pType' method:14.
	self deny: isDerived.

!

test_typeinfoisderivedfrom32
	"
Check if anonymous type of p element is derived from part1.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-isDerivedFrom
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  elem "Element"
	  typeInfo "TypeInfo"
	  isDerived "Boolean"
	|
	^self. "Schema validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'p'.
	elem := elemList  item:0.
	typeInfo := elem  schemaTypeInfo.
	self assert: typeInfo notNil.
	isDerived := typeInfo  isDerivedFromNS:'http://www.w3.org/1999/xhtml' name:'part1' method:15.
	self assert: isDerived.

!

test_typeinfoisderivedfrom33
	"
Check is anonymous type of p element is derived by extension from part1.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-isDerivedFrom
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  elem "Element"
	  typeInfo "TypeInfo"
	  isDerived "Boolean"
	|
	^self. "Schema validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'p'.
	elem := elemList  item:0.
	typeInfo := elem  schemaTypeInfo.
	self assert: typeInfo notNil.
	isDerived := typeInfo  isDerivedFromNS:'http://www.w3.org/1999/xhtml' name:'part1' method:2.
	self assert: isDerived.

!

test_typeinfoisderivedfrom34
	"
Check if anonymous type of p element is derived from part1 by any method other than extension.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-isDerivedFrom
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  elem "Element"
	  typeInfo "TypeInfo"
	  isDerived "Boolean"
	|
	^self. "Schema validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'p'.
	elem := elemList  item:0.
	typeInfo := elem  schemaTypeInfo.
	self assert: typeInfo notNil.
	isDerived := typeInfo  isDerivedFromNS:'http://www.w3.org/1999/xhtml' name:'part1' method:13.
	self deny: isDerived.

!

test_typeinfoisderivedfrom35
	"
Check if anonymous type of p element is derived from xsd:simpleType.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-isDerivedFrom
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  elem "Element"
	  typeInfo "TypeInfo"
	  isDerived "Boolean"
	|
	^self. "Schema validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'p'.
	elem := elemList  item:0.
	typeInfo := elem  schemaTypeInfo.
	self assert: typeInfo notNil.
	isDerived := typeInfo  isDerivedFromNS:'http://www.w3.org/2001/XMLSchema' name:'anySimpleType' method:15.
	self deny: isDerived.

!

test_typeinfoisderivedfrom36
	"
Check if anonymous type of p element is derived from xsd:anyType.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-isDerivedFrom
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  elem "Element"
	  typeInfo "TypeInfo"
	  isDerived "Boolean"
	|
	^self. "Schema validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'p'.
	elem := elemList  item:0.
	typeInfo := elem  schemaTypeInfo.
	self assert: typeInfo notNil.
	isDerived := typeInfo  isDerivedFromNS:'http://www.w3.org/2001/XMLSchema' name:'anyType' method:15.
	self assert: isDerived.

!

test_typeinfoisderivedfrom37
	"
Check if anonymous type of p element is derived from xsd:anyType by restriction.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-isDerivedFrom
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  elem "Element"
	  typeInfo "TypeInfo"
	  isDerived "Boolean"
	|
	^self. "Schema validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'p'.
	elem := elemList  item:0.
	typeInfo := elem  schemaTypeInfo.
	self assert: typeInfo notNil.
	isDerived := typeInfo  isDerivedFromNS:'http://www.w3.org/2001/XMLSchema' name:'anyType' method:1.
	self deny: isDerived.

!

test_typeinfoisderivedfrom38
	"
Check if anonymous type of p element is derived from xsd:anyType by any method other
than extension.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-isDerivedFrom
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  elem "Element"
	  typeInfo "TypeInfo"
	  isDerived "Boolean"
	|
	^self. "Schema validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'p'.
	elem := elemList  item:0.
	typeInfo := elem  schemaTypeInfo.
	self assert: typeInfo notNil.
	isDerived := typeInfo  isDerivedFromNS:'http://www.w3.org/2001/XMLSchema' name:'anyType' method:13.
	self deny: isDerived.

!

test_typeinfoisderivedfrom39
	"
Check if anonymous type of p element derives from itself.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-isDerivedFrom
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  elem "Element"
	  typeInfo "TypeInfo"
	  isDerived "Boolean"
	  typeName "String"
	  typeNS "String"
	|
	^self. "Schema validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'p'.
	elem := elemList  item:0.
	typeInfo := elem  schemaTypeInfo.
	self assert: typeInfo notNil.
	typeName := typeInfo  typeName.
	typeNS := typeInfo  typeNamespace.
	isDerived := typeInfo  isDerivedFromNS:typeNS name:typeName method:15.
	self deny: isDerived.

!

test_typeinfoisderivedfrom40
	"
Check if emType is derived from xsd:ID by union.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-isDerivedFrom
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  elem "Element"
	  typeInfo "TypeInfo"
	  isDerived "Boolean"
	  typeName "String"
	|
	^self. "Schema validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'em'.
	elem := elemList  item:0.
	typeInfo := elem  schemaTypeInfo.
	self assert: typeInfo notNil.
	typeName := typeInfo  typeName.
	self assert: ( typeName = 'emType' ).
	isDerived := typeInfo  isDerivedFromNS:'http://www.w3.org/2001/XMLSchema' name:'ID' method:4.
	self assert: isDerived.

!

test_typeinfoisderivedfrom41
	"
Check if emType is derived from xsd:ID by any method other than union or restriction.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-isDerivedFrom
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  elem "Element"
	  typeInfo "TypeInfo"
	  isDerived "Boolean"
	  typeName "String"
	|
	^self. "Schema validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'em'.
	elem := elemList  item:0.
	typeInfo := elem  schemaTypeInfo.
	self assert: typeInfo notNil.
	typeName := typeInfo  typeName.
	self assert: ( typeName = 'emType' ).
	isDerived := typeInfo  isDerivedFromNS:'http://www.w3.org/2001/XMLSchema' name:'ID' method:10.
	self deny: isDerived.

!

test_typeinfoisderivedfrom42
	"
Check if strongType is derived from anySimpleType by list.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-isDerivedFrom
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  elem "Element"
	  typeInfo "TypeInfo"
	  isDerived "Boolean"
	  typeName "String"
	|
	^self. "Schema validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'strong'.
	elem := elemList  item:0.
	typeInfo := elem  schemaTypeInfo.
	self assert: typeInfo notNil.
	typeName := typeInfo  typeName.
	self assert: ( typeName = 'strongType' ).
	isDerived := typeInfo  isDerivedFromNS:'http://www.w3.org/2001/XMLSchema' name:'anySimpleType' method:8.
	self assert: isDerived.

!

test_typeinfoisderivedfrom43
	"
Check if anonymous type of acronym element derived from anyType by restriction.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-isDerivedFrom
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  acronymElem "Element"
	  attr "Attr"
	  elem "Element"
	  elemName "String"
	  typeInfo "TypeInfo"
	  isDerived "Boolean"
	|
	^self. "Schema validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'acronym'.
	acronymElem := elemList  item:2.
	typeInfo := acronymElem  schemaTypeInfo.
	self assert: typeInfo notNil.
	isDerived := typeInfo  isDerivedFromNS:'http://www.w3.org/2001/XMLSchema' name:'anyType' method:1.
	self deny: isDerived.

!

test_typeinfoisderivedfrom44
	"
Check if anonymous type of acronym element derived from anyType by any method other than extension.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-isDerivedFrom
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  acronymElem "Element"
	  attr "Attr"
	  elem "Element"
	  elemName "String"
	  typeInfo "TypeInfo"
	  isDerived "Boolean"
	|
	^self. "Schema validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'acronym'.
	acronymElem := elemList  item:2.
	typeInfo := acronymElem  schemaTypeInfo.
	self assert: typeInfo notNil.
	isDerived := typeInfo  isDerivedFromNS:'http://www.w3.org/2001/XMLSchema' name:'anyType' method:13.
	self deny: isDerived.

!

test_typeinfoisderivedfrom45
	"
Check if anonymous type of acronym element derived from anySimpleType by extension.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-isDerivedFrom
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  acronymElem "Element"
	  attr "Attr"
	  elem "Element"
	  elemName "String"
	  typeInfo "TypeInfo"
	  isDerived "Boolean"
	|
	^self. "Schema validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'acronym'.
	acronymElem := elemList  item:2.
	typeInfo := acronymElem  schemaTypeInfo.
	self assert: typeInfo notNil.
	isDerived := typeInfo  isDerivedFromNS:'http://www.w3.org/2001/XMLSchema' name:'anySimpleType' method:2.
	self assert: isDerived.

!

test_typeinfoisderivedfrom46
	"
Check if anonymous type of acronym element derived from anySimpleType by any method other than extension.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-isDerivedFrom
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  acronymElem "Element"
	  attr "Attr"
	  elem "Element"
	  elemName "String"
	  typeInfo "TypeInfo"
	  isDerived "Boolean"
	|
	^self. "Schema validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'acronym'.
	acronymElem := elemList  item:2.
	typeInfo := acronymElem  schemaTypeInfo.
	self assert: typeInfo notNil.
	isDerived := typeInfo  isDerivedFromNS:'http://www.w3.org/2001/XMLSchema' name:'anySimpleType' method:13.
	self deny: isDerived.

!

test_typeinfoisderivedfrom47
	"
Check if anonymous type of acronym element derived from xsd:string by extension.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-isDerivedFrom
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  acronymElem "Element"
	  attr "Attr"
	  elem "Element"
	  elemName "String"
	  typeInfo "TypeInfo"
	  isDerived "Boolean"
	|
	^self. "Schema validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'acronym'.
	acronymElem := elemList  item:2.
	typeInfo := acronymElem  schemaTypeInfo.
	self assert: typeInfo notNil.
	isDerived := typeInfo  isDerivedFromNS:'http://www.w3.org/2001/XMLSchema' name:'string' method:2.
	self assert: isDerived.

!

test_typeinfoisderivedfrom48
	"
Check if anonymous type of acronym element derived from xsd:string by any method other than extension.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-isDerivedFrom
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  acronymElem "Element"
	  attr "Attr"
	  elem "Element"
	  elemName "String"
	  typeInfo "TypeInfo"
	  isDerived "Boolean"
	|
	^self. "Schema validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'acronym'.
	acronymElem := elemList  item:2.
	typeInfo := acronymElem  schemaTypeInfo.
	self assert: typeInfo notNil.
	isDerived := typeInfo  isDerivedFromNS:'http://www.w3.org/2001/XMLSchema' name:'string' method:13.
	self deny: isDerived.

!

test_typeinfoisderivedfrom49
	"
Check if a type derived by extension from a list of a item type returns true
when asked if it derives by list from the item type.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-isDerivedFrom
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  elem "Element"
	  typeInfo "TypeInfo"
	  isDerived "Boolean"
	|
	^self. "Schema validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'typeinfo').
	elemList := doc  getElementsByTagName: 'acronym'.
	elem := elemList  item:0.
	typeInfo := elem  schemaTypeInfo.
	self assert: typeInfo notNil.
	isDerived := typeInfo  isDerivedFromNS:'http://www.w3.org/2001/XMLSchema' name:'double' method:8.
	self assert: isDerived.

!

test_typeinfoisderivedfrom50
	"
Check if a type derived by extension from a list of a item type returns true
when asked if it derives by any method from the item type.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-isDerivedFrom
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  elem "Element"
	  typeInfo "TypeInfo"
	  isDerived "Boolean"
	|
	^self. "Schema validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'typeinfo').
	elemList := doc  getElementsByTagName: 'acronym'.
	elem := elemList  item:0.
	typeInfo := elem  schemaTypeInfo.
	self assert: typeInfo notNil.
	isDerived := typeInfo  isDerivedFromNS:'http://www.w3.org/2001/XMLSchema' name:'double' method:0.
	self assert: isDerived.

!

test_typeinfoisderivedfrom51
	"
Check if a type derived by extension from a list of a item type returns false
when asked if it derives by any method other than list from the item type.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-isDerivedFrom
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  elem "Element"
	  typeInfo "TypeInfo"
	  isDerived "Boolean"
	|
	^self. "Schema validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'typeinfo').
	elemList := doc  getElementsByTagName: 'acronym'.
	elem := elemList  item:0.
	typeInfo := elem  schemaTypeInfo.
	self assert: typeInfo notNil.
	isDerived := typeInfo  isDerivedFromNS:'http://www.w3.org/2001/XMLSchema' name:'double' method:7.
	self deny: isDerived.

!

test_typeinfoisderivedfrom52
	"
Check if a type derived by extension from a list of a item type returns false
when asked if it derives by restriction from anySimpleType type.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-isDerivedFrom
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  elem "Element"
	  typeInfo "TypeInfo"
	  isDerived "Boolean"
	|
	^self. "Schema validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'typeinfo').
	elemList := doc  getElementsByTagName: 'acronym'.
	elem := elemList  item:0.
	typeInfo := elem  schemaTypeInfo.
	self assert: typeInfo notNil.
	isDerived := typeInfo  isDerivedFromNS:'http://www.w3.org/2001/XMLSchema' name:'anySimpleType' method:1.
	self deny: isDerived.

!

test_typeinfoisderivedfrom53
	"
Check if a type derived by extension from a list of a item type returns true
when asked if it derives by extension from anySimpleType.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-isDerivedFrom
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  elem "Element"
	  typeInfo "TypeInfo"
	  isDerived "Boolean"
	|
	^self. "Schema validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'typeinfo').
	elemList := doc  getElementsByTagName: 'acronym'.
	elem := elemList  item:0.
	typeInfo := elem  schemaTypeInfo.
	self assert: typeInfo notNil.
	isDerived := typeInfo  isDerivedFromNS:'http://www.w3.org/2001/XMLSchema' name:'anySimpleType' method:2.
	self assert: isDerived.

!

test_typeinfoisderivedfrom54
	"
Check if a type derived by extension from a list of a item type returns true
when asked if it derives by list from anySimpleType.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-isDerivedFrom
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  elem "Element"
	  typeInfo "TypeInfo"
	  isDerived "Boolean"
	|
	^self. "Schema validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'typeinfo').
	elemList := doc  getElementsByTagName: 'acronym'.
	elem := elemList  item:0.
	typeInfo := elem  schemaTypeInfo.
	self assert: typeInfo notNil.
	isDerived := typeInfo  isDerivedFromNS:'http://www.w3.org/2001/XMLSchema' name:'anySimpleType' method:8.
	self assert: isDerived.

!

test_typeinfoisderivedfrom55
	"
Check if a type derived by extension from a list of a item type returns true
when asked if it derives by extension from anyType type.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-isDerivedFrom
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  elem "Element"
	  typeInfo "TypeInfo"
	  isDerived "Boolean"
	|
	^self. "Schema validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'typeinfo').
	elemList := doc  getElementsByTagName: 'acronym'.
	elem := elemList  item:0.
	typeInfo := elem  schemaTypeInfo.
	self assert: typeInfo notNil.
	isDerived := typeInfo  isDerivedFromNS:'http://www.w3.org/2001/XMLSchema' name:'anyType' method:2.
	self assert: isDerived.

!

test_typeinfoisderivedfrom56
	"
Check if a type derived by extension from a list of a item type returns true
when asked if it derives by extension from anyType.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-isDerivedFrom
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  elem "Element"
	  typeInfo "TypeInfo"
	  isDerived "Boolean"
	|
	^self. "Schema validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'typeinfo').
	elemList := doc  getElementsByTagName: 'acronym'.
	elem := elemList  item:0.
	typeInfo := elem  schemaTypeInfo.
	self assert: typeInfo notNil.
	isDerived := typeInfo  isDerivedFromNS:'http://www.w3.org/2001/XMLSchema' name:'anyType' method:2.
	self assert: isDerived.

!

test_typeinfoisderivedfrom57
	"
Check if a type derived by extension from a list of a item type returns true
when asked if it derives by list from anyType.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-isDerivedFrom
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  elem "Element"
	  typeInfo "TypeInfo"
	  isDerived "Boolean"
	|
	^self. "Schema validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'typeinfo').
	elemList := doc  getElementsByTagName: 'acronym'.
	elem := elemList  item:0.
	typeInfo := elem  schemaTypeInfo.
	self assert: typeInfo notNil.
	isDerived := typeInfo  isDerivedFromNS:'http://www.w3.org/2001/XMLSchema' name:'anyType' method:8.
	self assert: isDerived.

!

test_typeinfoisderivedfrom58
	"
Check if a type derived by extension from a union returns true
when asked if it derives by union from a member type of the union.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-isDerivedFrom
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  codeElem "Element"
	  attr "Attr"
	  typeInfo "TypeInfo"
	  isDerived "Boolean"
	|
	^self. "Schema validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'typeinfo').
	elemList := doc  getElementsByTagName: 'code'.
	codeElem := elemList  item:0.
	typeInfo := codeElem  schemaTypeInfo.
	self assert: typeInfo notNil.
	isDerived := typeInfo  isDerivedFromNS:'http://www.w3.org/1999/xhtml' name:'unbounded' method:4.
	self assert: isDerived.

!

test_typeinfoisderivedfrom59
	"
Check if a type derived by extension from a union returns true
when asked if it derives by union from a restricted base of
a member of type union.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-isDerivedFrom
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  codeElem "Element"
	  attr "Attr"
	  elem "Element"
	  elemName "String"
	  typeInfo "TypeInfo"
	  isDerived "Boolean"
	|
	^self. "Schema validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'typeinfo').
	elemList := doc  getElementsByTagName: 'code'.
	codeElem := elemList  item:0.
	typeInfo := codeElem  schemaTypeInfo.
	self assert: typeInfo notNil.
	isDerived := typeInfo  isDerivedFromNS:'http://www.w3.org/2001/XMLSchema' name:'integer' method:4.
	self assert: isDerived.

!

test_typeinfoisderivedfrom60
	"
Check if xs:IDREFS is derived by list from xs:IDREF.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-isDerivedFrom
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  elem "Element"
	  attr "Attr"
	  typeInfo "TypeInfo"
	  isDerived "Boolean"
	|
	^self. "Schema validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'typeinfo').
	elemList := doc  getElementsByTagName: 'strong'.
	elem := elemList  item:0.
	typeInfo := elem  schemaTypeInfo.
	self assert: typeInfo notNil.
	isDerived := typeInfo  isDerivedFromNS:'http://www.w3.org/2001/XMLSchema' name:'IDREF' method:8.
	self assert: isDerived.

!

test_typeinfoisderivedfrom61
	"
Check if xs:byte is derived by restriction from xs:short
		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-isDerivedFrom
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  elem "Element"
	  typeInfo "TypeInfo"
	  isDerived "Boolean"
	|
	^self. "Schema validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'typeinfo').
	elemList := doc  getElementsByTagName: 'em'.
	elem := elemList  item:0.
	typeInfo := elem  schemaTypeInfo.
	self assert: typeInfo notNil.
	isDerived := typeInfo  isDerivedFromNS:'http://www.w3.org/2001/XMLSchema' name:'short' method:1.
	self assert: isDerived.

!

test_typeinfoisderivedfrom62
	"
Check if xs:byte is derived by restriction from xs:decimal
		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-isDerivedFrom
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  elem "Element"
	  typeInfo "TypeInfo"
	  isDerived "Boolean"
	|
	^self. "Schema validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'typeinfo').
	elemList := doc  getElementsByTagName: 'em'.
	elem := elemList  item:0.
	typeInfo := elem  schemaTypeInfo.
	self assert: typeInfo notNil.
	isDerived := typeInfo  isDerivedFromNS:'http://www.w3.org/2001/XMLSchema' name:'decimal' method:1.
	self assert: isDerived.

!

test_typeinfoisderivedfrom63
	"
	The isDerivedFrom method checks if this TypeInfo derives from the specified ancestor type. 
	If the document's schema is a DTD or no schema is associated with the document, this method
	will always return false.  

	Get schemaTypeInfo on an element that belongs to a document with an XML DTD.  Invoke method
	isDerivedFrom and verify that returned the typeNamespace is null.

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-isDerivedFrom
	"
	|
	  doc "Document"
	  elemList "NodeList"
	  acronymElem "Element"
	  retValue "Boolean"
	  typeNamespace "String"
	  nullName "String"
	  elemTypeInfo "TypeInfo"
	|
	^self. "Validation not supported"
	nullName := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'acronym'.
	acronymElem := elemList  item:0.
	elemTypeInfo := acronymElem  schemaTypeInfo.
	retValue := elemTypeInfo  isDerivedFromNS:'http://www.w3.org/TR/REC-xml' name:nullName method:0.
	self deny: retValue.

!

test_typeinfoisderivedfrom64
	"
Check that the simpleType of an attributes derives by restriction from itself
and from its base type. 

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-isDerivedFrom
	"
	|
	  doc "Document"
	  docElem "Element"
	  elemList "NodeList"
	  acElem "Element"
	  classAttr "Attr"
	  attrTypeInfo "TypeInfo"
	  typeName "String"
	  retValue "Boolean"
	|
	^self. "Schema validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'acronym'.
	acElem := elemList  item:1.
	classAttr := acElem  getAttributeNode:'class'.
	attrTypeInfo := classAttr  schemaTypeInfo.
	retValue := attrTypeInfo  isDerivedFromNS:'http://www.w3.org/1999/xhtml' name:'classType' method:1.
	self assert: retValue.
	retValue := attrTypeInfo  isDerivedFromNS:'http://www.w3.org/2001/XMLSchema' name:'string' method:1.
	self assert: retValue.

!

test_typeinfoisderivedfrom65
	"
	The isDerivedFrom method checks if this TypeInfo derives from the specified ancestor type. 
	
	Get schemaTypeInfo on a simple type attribute that belongs to a document with an XML schema.
	Invoke method isDerivedFrom with derivation method list and verify that the value returned is true.

		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-isDerivedFrom
	"
	|
	  doc "Document"
	  docElem "Element"
	  elemTypeInfo "Element"
	  elemList "NodeList"
	  strongElem "Element"
	  attrTypeInfo "TypeInfo"
	  typeName "String"
	  retValue "Boolean"
	|
	^self. "Schema validation not supported"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'strong'.
	strongElem := elemList  item:0.
	elemTypeInfo := strongElem  schemaTypeInfo.
	retValue := elemTypeInfo  isDerivedFromNS:'http://www.w3.org/2001/XMLSchema' name:'string' method:8.
	self assert: retValue.

!

test_typeinfoisderivedfrom66
	"
	The isDerivedFrom method checks if this TypeInfo derives from the specified ancestor type. 
	
	Get schemaTypeInfo on an element of type Union that belongs to a document with an XML schema.
	Invoke method isDerivedFrom with derivation method union and verify that the value returned is true. 
      Verify that emType is derived from emp0004_5Type by union.


		Creator: IBM
		Autor Jenny Hsu
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-isDerivedFrom
	"
	|
	  doc "Document"
	  unionElem "Element"
	  elemTypeInfo "TypeInfo"
	  typeName "String"
	  elemList "NodeList"
	  retValue "Boolean"
	|
	^self. "Schema validation not supported"
	^self. "Validation not supported"
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'em'.
	unionElem := elemList  item:0.
	elemTypeInfo := unionElem  schemaTypeInfo.
	retValue := elemTypeInfo  isDerivedFromNS:'http://www.w3.org/1999/xhtml' name:'emp0004_5Type' method:0.
	self assert: retValue.

!

test_typeinfoisderivedfrom67
	"
Checks that isDerivedFrom(...,METHOD_UNION) returns true when there
are multiple union derivation steps between the target and
ancestor type.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-isDerivedFrom
	"
	|
	  doc "Document"
	  elem "Element"
	  elemTypeInfo "TypeInfo"
	  typeName "String"
	  elemList "NodeList"
	  retValue "Boolean"
	|
	^self. "Schema validation not supported"
	^self. "Validation not supported"
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'sup'.
	elem := elemList  item:0.
	elemTypeInfo := elem  schemaTypeInfo.
	retValue := elemTypeInfo  isDerivedFromNS:'http://www.w3.org/1999/xhtml' name:'emp0004_5Type' method:4.
	self assert: retValue.

!

test_typeinfoisderivedfrom68
	"
Checks that isDerivedFrom(...,0) returns true when there
is more than one union derivation steps between the target and
ancestor type.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-isDerivedFrom
	"
	|
	  doc "Document"
	  elem "Element"
	  elemTypeInfo "TypeInfo"
	  typeName "String"
	  elemList "NodeList"
	  retValue "Boolean"
	|
	^self. "Schema validation not supported"
	^self. "Validation not supported"
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'sup'.
	elem := elemList  item:0.
	elemTypeInfo := elem  schemaTypeInfo.
	retValue := elemTypeInfo  isDerivedFromNS:'http://www.w3.org/1999/xhtml' name:'emp0004_5Type' method:0.
	self assert: retValue.

!

test_typeinfoisderivedfrom69
	"
Checks that isDerivedFrom(...,DERIVATION_UNION|DERIVATION_LIST) returns false when there
is both a union and list derivation steps between the target and
ancestor type.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-isDerivedFrom
	"
	|
	  doc "Document"
	  elem "Element"
	  elemTypeInfo "TypeInfo"
	  typeName "String"
	  elemList "NodeList"
	  retValue "Boolean"
	|
	^self. "Schema validation not supported"
	^self. "Validation not supported"
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'sup'.
	elem := elemList  item:0.
	elemTypeInfo := elem  schemaTypeInfo.
	retValue := elemTypeInfo  isDerivedFromNS:'http://www.w3.org/2001/XMLSchema' name:'integer' method:12.
	self deny: retValue.

!

test_typeinfoisderivedfrom70
	"
Checks that isDerivedFrom(...,0) returns true when there
is both a union and list derivation steps between the target and
ancestor type.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-isDerivedFrom
	"
	|
	  doc "Document"
	  elem "Element"
	  elemTypeInfo "TypeInfo"
	  typeName "String"
	  elemList "NodeList"
	  retValue "Boolean"
	|
	^self. "Schema validation not supported"
	^self. "Validation not supported"
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'sup'.
	elem := elemList  item:0.
	elemTypeInfo := elem  schemaTypeInfo.
	retValue := elemTypeInfo  isDerivedFromNS:'http://www.w3.org/2001/XMLSchema' name:'string' method:0.
	self assert: retValue.

!

test_typeinfoisderivedfrom71
	"
Checks that isDerivedFrom(...,0) returns true when target type is a list
of an union of the ancestor type.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-isDerivedFrom
	"
	|
	  doc "Document"
	  elem "Element"
	  elemTypeInfo "TypeInfo"
	  typeName "String"
	  elemList "NodeList"
	  retValue "Boolean"
	|
	^self. "Schema validation not supported"
	^self. "Validation not supported"
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'code'.
	elem := elemList  item:0.
	elemTypeInfo := elem  schemaTypeInfo.
	retValue := elemTypeInfo  isDerivedFromNS:'http://www.w3.org/1999/xhtml' name:'field' method:0.
	self assert: retValue.

!

test_typeinfoisderivedfrom72
	"
Checks that isDerivedFrom(...,DERIVATION_LIST|DERIVATION_UNION) returns false when target type is a list
of an union.
ancestor type.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-isDerivedFrom
	"
	|
	  doc "Document"
	  elem "Element"
	  elemTypeInfo "TypeInfo"
	  typeName "String"
	  elemList "NodeList"
	  retValue "Boolean"
	|
	^self. "Schema validation not supported"
	^self. "Validation not supported"
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'code'.
	elem := elemList  item:0.
	elemTypeInfo := elem  schemaTypeInfo.
	retValue := elemTypeInfo  isDerivedFromNS:'http://www.w3.org/1999/xhtml' name:'field' method:12.
	self deny: retValue.

!

test_typeinfoisderivedfrom73
	"
Checks that isDerivedFrom(...,0) returns true where the target type is a union
where the ancestor type is a member of the union and is a union itself.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#TypeInfo-isDerivedFrom
	"
	|
	  doc "Document"
	  elem "Element"
	  elemTypeInfo "TypeInfo"
	  typeName "String"
	  elemList "NodeList"
	  retValue "Boolean"
	|
	^self. "Schema validation not supported"
	^self. "Validation not supported"
	"implementationAttribute not supported: namespaceAware"
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'hc_staff').
	elemList := doc  getElementsByTagName: 'sup'.
	elem := elemList  item:0.
	elemTypeInfo := elem  schemaTypeInfo.
	retValue := elemTypeInfo  isDerivedFromNS:'http://www.w3.org/1999/xhtml' name:'emType' method:0.
	self assert: retValue.

!

test_userdatahandler01
	"
Call setUserData on a node providing a UserDataHandler and rename the node.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-handleUserDataEvent
	"
	|
	  doc "Document"
	  node "Node"
	  pList "NodeList"
	  userDataMonitor "UserDataMonitor"
	  oldUserData "DOMUserData"
	  elementNS "String"
	  newNode "Node"
	  notifications "List"
	  notification "UserDataNotification"
	  operation "short"
	  key "String"
	  data "String"
	  src "Node"
	  dst "Node"
	  greetingCount "SmallInteger"
	  salutationCount "SmallInteger"
	  hello "String"
	  mister "String"
	|
	greetingCount := 0.
	salutationCount := 0.
	hello := 'Hello'.
	mister := 'Mr.'.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	pList := doc  getElementsByTagName: 'p'.
	node := pList  item:0.
	oldUserData := node  setUserData:hello handler: userDataMonitor forKey:'greeting'.
	oldUserData := node  setUserData:mister handler: userDataMonitor forKey:'salutation'.
	elementNS := node  namespaceURI.
	newNode := doc  renameNode:node namespaceUri:elementNS qualifiedName:'div'.
	self assert:false description:'Method "allNotifications" is not supported yet'.
	self assert: notifications size = 2.
notifications do: [notification|
	self assert:false description:'Method "operation" is not supported yet'.
	self assert: ( operation = 4 ).
	self assert:false description:'Method "key" is not supported yet'.
	data := notification  data.
	"if"
	( key = 'greeting' ) ifTrue: [
			].
	self assert:false description:'Method "src" is not supported yet'.
	self assert: src == node.
	self assert:false description:'Method "dst" is not supported yet'.
	"if"
	( dst isNil )  ifTrue: [
		].
].
	self assert: ( greetingCount = 1 ).
	self assert: ( salutationCount = 1 ).

!

test_userdatahandler02
	"
Call setUserData on a node providing a UserDataHandler and clone the node.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-handleUserDataEvent
	"
	|
	  doc "Document"
	  node "Node"
	  pList "NodeList"
	  userDataMonitor "UserDataMonitor"
	  oldUserData "DOMUserData"
	  elementNS "String"
	  newNode "Node"
	  notifications "List"
	  notification "UserDataNotification"
	  operation "short"
	  key "String"
	  data "String"
	  src "Node"
	  dst "Node"
	  greetingCount "SmallInteger"
	  salutationCount "SmallInteger"
	  hello "String"
	  mister "String"
	|
	greetingCount := 0.
	salutationCount := 0.
	hello := 'Hello'.
	mister := 'Mr.'.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	pList := doc  getElementsByTagName: 'p'.
	node := pList  item:0.
	oldUserData := node  setUserData:hello handler: userDataMonitor forKey:'greeting'.
	oldUserData := node  setUserData:mister handler: userDataMonitor forKey:'salutation'.
	elementNS := node  namespaceURI.
	newNode := node  cloneNode:true.
	self assert:false description:'Method "allNotifications" is not supported yet'.
	self assert: notifications size = 2.
notifications do: [notification|
	self assert:false description:'Method "operation" is not supported yet'.
	self assert: ( operation = 1 ).
	self assert:false description:'Method "key" is not supported yet'.
	data := notification  data.
	"if"
	( key = 'greeting' ) ifTrue: [
			].
	self assert:false description:'Method "src" is not supported yet'.
	self assert: src == node.
	self assert:false description:'Method "dst" is not supported yet'.
	self assert: dst == newNode.
].
	self assert: ( greetingCount = 1 ).
	self assert: ( salutationCount = 1 ).

!

test_userdatahandler03
	"
Call setUserData on a node providing a UserDataHandler and import the node.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-handleUserDataEvent
	"
	|
	  doc "Document"
	  node "Node"
	  pList "NodeList"
	  userDataMonitor "UserDataMonitor"
	  oldUserData "DOMUserData"
	  elementNS "String"
	  newNode "Node"
	  notifications "List"
	  notification "UserDataNotification"
	  operation "short"
	  key "String"
	  data "String"
	  src "Node"
	  dst "Node"
	  greetingCount "SmallInteger"
	  salutationCount "SmallInteger"
	  hello "String"
	  mister "String"
	  newDoc "Document"
	  rootName "String"
	  rootNS "String"
	  domImpl "DOMImplementation"
	  docType "DocumentType"
	  docElem "Element"
	|
	greetingCount := 0.
	salutationCount := 0.
	hello := 'Hello'.
	mister := 'Mr.'.
	docType := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	docElem := doc  documentElement.
	rootNS := docElem  namespaceURI.
	rootName := docElem  tagName.
	newDoc := domImpl createDocumentNS: rootNS qualifiedName: rootName doctype: docType.
	pList := doc  getElementsByTagName: 'p'.
	node := pList  item:0.
	oldUserData := node  setUserData:hello handler: userDataMonitor forKey:'greeting'.
	oldUserData := node  setUserData:mister handler: userDataMonitor forKey:'salutation'.
	elementNS := node  namespaceURI.
	newNode := doc  importNode:node deep:true.
	self assert:false description:'Method "allNotifications" is not supported yet'.
	self assert: notifications size = 2.
notifications do: [notification|
	self assert:false description:'Method "operation" is not supported yet'.
	self assert: ( operation = 2 ).
	self assert:false description:'Method "key" is not supported yet'.
	data := notification  data.
	"if"
	( key = 'greeting' ) ifTrue: [
			].
	self assert:false description:'Method "src" is not supported yet'.
	self assert: src == node.
	self assert:false description:'Method "dst" is not supported yet'.
	self assert: dst == newNode.
].
	self assert: ( greetingCount = 1 ).
	self assert: ( salutationCount = 1 ).

!

test_userdatahandler04
	"
Call setUserData on a node providing a UserDataHandler and adopt the node.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#ID-handleUserDataEvent
	"
	|
	  doc "Document"
	  node "Node"
	  pList "NodeList"
	  userDataMonitor "UserDataMonitor"
	  oldUserData "DOMUserData"
	  elementNS "String"
	  newNode "Node"
	  notifications "List"
	  notification "UserDataNotification"
	  operation "short"
	  key "String"
	  data "String"
	  src "Node"
	  dst "Node"
	  greetingCount "SmallInteger"
	  salutationCount "SmallInteger"
	  hello "String"
	  mister "String"
	  newDoc "Document"
	  rootName "String"
	  rootNS "String"
	  domImpl "DOMImplementation"
	  docType "DocumentType"
	  docElem "Element"
	|
	greetingCount := 0.
	salutationCount := 0.
	hello := 'Hello'.
	mister := 'Mr.'.
	docType := nil.
	doc :=  Parser forDOM3 processDocumentInFilename:(self xmlFilenameFor:'barfoo').
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	docElem := doc  documentElement.
	rootNS := docElem  namespaceURI.
	rootName := docElem  tagName.
	newDoc := domImpl createDocumentNS: rootNS qualifiedName: rootName doctype: docType.
	pList := doc  getElementsByTagName: 'p'.
	node := pList  item:0.
	oldUserData := node  setUserData:hello handler: userDataMonitor forKey:'greeting'.
	oldUserData := node  setUserData:mister handler: userDataMonitor forKey:'salutation'.
	elementNS := node  namespaceURI.
	newNode := doc  adoptNode: node.
	self assert:false description:'Method "allNotifications" is not supported yet'.
	self assert: notifications size = 2.
notifications do: [notification|
	self assert:false description:'Method "operation" is not supported yet'.
	self assert: ( operation = 5 ).
	self assert:false description:'Method "key" is not supported yet'.
	data := notification  data.
	"if"
	( key = 'greeting' ) ifTrue: [
			].
	self assert:false description:'Method "src" is not supported yet'.
	self assert: src == node.
	self assert:false description:'Method "dst" is not supported yet'.
	self assert: dst isNil.
].
	self assert: ( greetingCount = 1 ).
	self assert: ( salutationCount = 1 ).

!

test_wellformed01
	"
Create a document with an XML 1.1 valid but XML 1.0 invalid element and
normalize document with well-formed set to true.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-normalizeDocument
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-well-formed
	"
	|
	  domImpl "DOMImplementation"
	  nullString "String"
	  nullDoctype "DocumentType"
	  doc "Document"
	  elem "Element"
	  retval "Node"
	  domConfig "DOMConfiguration"
	  errorMonitor "DOMErrorMonitor"
	  errors "List"
	  error "DOMError"
	  severity "SmallInteger"
	  type "String"
	  locator "DOMLocator"
	  relatedNode "Node"
	|
	nullString := nil.
	nullDoctype := nil.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	doc := domImpl createDocumentNS: nullString qualifiedName: nullString doctype: nullDoctype.
	"assertDOMException..."
	self should:[
	elem := doc  createElement:'LegalNameࢎ' ns:'http://www.example.org/domts/wellformed01'.
	] raise: DOMException.
	self assert: (lastException code == DOMException INVALID_CHARACTER_ERR).
	"end of assertDOMException..."
	"try"
	[
	] on: DOMException do: [:ex|	].
	"end of try"
	elem := doc  createElement:'LegalNameࢎ' ns:'http://www.example.org/domts/wellformed01'.
	retval := doc  appendChild:elem.
	domConfig := doc domConfig.
	domConfig setParameter: 'well-formed' value: true.
	domConfig setParameter: 'error-handler' value: errorMonitor.
	doc  normalizeDocument.
	errors := errorMonitor  errors.
errors do: [:error|
	severity := error  severity.
	self assert: ( severity = 2 ).
	type := error  type.
	self assert: ( type = 'wf-invalid-character-in-node-name' ).
	locator := error  location.
	relatedNode := locator  relatedNode.
	self assert: relatedNode == elem.
].
	self assert: errors size = 1.

!

test_wellformed02
	"
Create a document with an XML 1.1 valid but XML 1.0 invalid element and
normalize document with well-formed set to false.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-normalizeDocument
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-well-formed
	"
	|
	  domImpl "DOMImplementation"
	  nullString "String"
	  nullDoctype "DocumentType"
	  doc "Document"
	  elem "Element"
	  retval "Node"
	  domConfig "DOMConfiguration"
	  errorMonitor "DOMErrorMonitor"
	  errors "List"
	  canSet "Boolean"
	|
	nullString := nil.
	nullDoctype := nil.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	doc := domImpl createDocumentNS: nullString qualifiedName: nullString doctype: nullDoctype.
	"assertDOMException..."
	self should:[
	elem := doc  createElement:'LegalNameࢎ' ns:'http://www.example.org/domts/wellformed02'.
	] raise: DOMException.
	self assert: (lastException code == DOMException INVALID_CHARACTER_ERR).
	"end of assertDOMException..."
	"try"
	[
	] on: DOMException do: [:ex|	].
	"end of try"
	elem := doc  createElement:'LegalNameࢎ' ns:'http://www.example.org/domts/wellformed02'.
	retval := doc  appendChild:elem.
	domConfig := doc domConfig.
	canSet := domConfig canSetParameter: 'well-formed' value: false.
	"if"
	(canSet) ifTrue: [
						].

!

test_wellformed03
	"
Create a document with an XML 1.1 valid but XML 1.0 invalid attribute and
normalize document with well-formed set to true.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-normalizeDocument
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-well-formed
	"
	|
	  domImpl "DOMImplementation"
	  nullDoctype "DocumentType"
	  doc "Document"
	  docElem "Element"
	  attr "Attr"
	  retval "Node"
	  domConfig "DOMConfiguration"
	  errorMonitor "DOMErrorMonitor"
	  errors "List"
	  error "DOMError"
	  severity "SmallInteger"
	  type "String"
	  locator "DOMLocator"
	  relatedNode "Node"
	|
	nullDoctype := nil.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	doc := domImpl createDocumentNS: 'http://www.w3.org/1999/xhtml' qualifiedName: 'html' doctype: nullDoctype.
	docElem := doc  documentElement.
	"assertDOMException..."
	self should:[
	attr := doc  createAttribute:'LegalNameࢎ'.
	] raise: DOMException.
	self assert: (lastException code == DOMException INVALID_CHARACTER_ERR).
	"end of assertDOMException..."
	"try"
	[
	] on: DOMException do: [:ex|	].
	"end of try"
	docElem  setAttribute:'LegalNameࢎ' value:'foo'.
	attr := docElem  getAttributeNode:'LegalNameࢎ'.
	domConfig := doc domConfig.
	domConfig setParameter: 'well-formed' value: true.
	domConfig setParameter: 'error-handler' value: errorMonitor.
	doc  normalizeDocument.
	errors := errorMonitor  errors.
errors do: [:error|
	severity := error  severity.
	self assert: ( severity = 2 ).
	type := error  type.
	self assert: ( type = 'wf-invalid-character-in-node-name' ).
	locator := error  location.
	relatedNode := locator  relatedNode.
	self assert: relatedNode == attr.
].
	self assert: errors size = 1.

!

test_wellformed04
	"
Create a document with an XML 1.1 valid but XML 1.0 invalid attribute and
normalize document with well-formed set to false.

		Creator: Curt Arnold
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#Document3-normalizeDocument
		Subject http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core#parameter-well-formed
	"
	|
	  domImpl "DOMImplementation"
	  nullDoctype "DocumentType"
	  doc "Document"
	  docElem "Element"
	  attr "Attr"
	  retval "Node"
	  domConfig "DOMConfiguration"
	  errorMonitor "DOMErrorMonitor"
	  errors "List"
	  error "DOMError"
	  canSet "Boolean"
	  nullNS "String"
	|
	nullDoctype := nil.
	nullNS := nil.
	domImpl := DOMImplementationRegistry getDOMImplementation:'XML 3.0'.
	doc := domImpl createDocumentNS: 'http://www.w3.org/1999/xhtml' qualifiedName: 'html' doctype: nullDoctype.
	docElem := doc  documentElement.
	"assertDOMException..."
	self should:[
	attr := doc  createAttribute:'LegalNameࢎ' ns:nullNS.
	] raise: DOMException.
	self assert: (lastException code == DOMException INVALID_CHARACTER_ERR).
	"end of assertDOMException..."
	"try"
	[
	] on: DOMException do: [:ex|	].
	"end of try"
	docElem  setAttribute: 'LegalNameࢎ' ns: nullNS value: 'foo'.
	domConfig := doc domConfig.
	canSet := domConfig canSetParameter: 'well-formed' value: false.
	"if"
	(canSet) ifTrue: [
						self assert: error isNil.
	].

! !

!W3CDOM3CoreTests class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/XMLv2__W3CDOM3CoreTests.st,v 1.6 2007-01-03 19:45:04 stillj1 Exp $'
!

version_SVN
    ^ '$Id$'
! !

