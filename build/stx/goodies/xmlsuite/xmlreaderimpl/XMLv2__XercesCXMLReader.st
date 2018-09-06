'From Smalltalk/X, Version:5.4.4 on 06-04-2009 at 03:59:51 PM'                  !

"{ Package: 'stx:goodies/xmlsuite/xmlreaderimpl' }"

"{ NameSpace: XMLv2 }"

XMLReader subclass:#XercesCXMLReader
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-SAX2-XMLReaders'
!

!XercesCXMLReader primitiveDefinitions!
%{

/*
 * includes, defines, structure definitions
 * and typedefs come here.
 */

#include <stdio.h>
#include "support/StxXercesUtils.hpp"
#include "support/StxXercesHandlerCallbacks.h"


void StxXercesStartDocument(OBJ* handler_ref) {
	__SSEND0(*handler_ref, @symbol(xercesStartDocument), 0);
}

void StxXercesEndDocument(OBJ* handler_ref) {
	__SSEND0(*handler_ref, @symbol(xercesEndDocument), 0);
}


StxXercesFillAttributes(StxXercesAttributes attrs, OBJ attrs_obj) {
	unsigned int i;
	OBJ uri_obj, localname_obj, qname_obj, value_obj;
	for ( i = 0; i < StxXercesAttributesGetLength(attrs); i++) {
		uri_obj = __MKSTRING(StxXercesAttributesGetUri(attrs, i)); __PROTECT__(uri_obj);
		localname_obj = __MKSTRING(StxXercesAttributesGetLocalName(attrs, i)); __PROTECT__(localname_obj);
		qname_obj = __MKSTRING(StxXercesAttributesGetQName(attrs, i)); __PROTECT__(qname_obj);
		value_obj = __MKSTRING(StxXercesAttributesGetValue(attrs, i)); __PROTECT__(value_obj);
		__SSEND4(attrs_obj, @symbol(addAttribute:namespace:qname:value:), 0,
			localname_obj, uri_obj, qname_obj, value_obj);			
		__UNPROTECT__(uri_obj); __UNPROTECT__(localname_obj); __UNPROTECT__(qname_obj); __UNPROTECT__(value_obj);
	}		
}


void StxXercesStartElement(OBJ* handler_ref, char* uri, char* localname, char* qname, StxXercesAttributes attrs) {	
	OBJ uri_obj, localname_obj, qname_obj, attrs_obj;
	uri_obj = __MKSTRING(uri); __PROTECT__(uri_obj);
	localname_obj = __MKSTRING(localname); __PROTECT__(localname_obj);
	qname_obj = __MKSTRING(qname); __PROTECT__(qname_obj);
	attrs_obj = __NEW(@global(XMLv2::Attributes)); __PROTECT__(attrs_obj);
	StxXercesFillAttributes(attrs, attrs_obj);
	__SSEND4(*handler_ref, @symbol(xercesStartElement:namespace:qname:attributes:),
		0, localname_obj, uri_obj, qname_obj, attrs_obj);
	__UNPROTECT__(uri_obj); __UNPROTECT__(localname_obj); __UNPROTECT__(qname_obj); __UNPROTECT__(attrs_obj);
}
void StxXercesEndElement(OBJ* handler_ref, char* uri, char* localname, char* qname) {
	OBJ uri_obj, localname_obj, qname_obj;
	uri_obj = __MKSTRING(uri); __PROTECT__(uri_obj);
	localname_obj = __MKSTRING(localname); __PROTECT__(localname_obj);
	qname_obj = __MKSTRING(qname); __PROTECT__(qname_obj);
	__SSEND3(*handler_ref, @symbol(xercesEndElement:namespace:qname:),
		0, localname_obj, uri_obj, qname_obj);
	__UNPROTECT__(uri_obj); __UNPROTECT__(localname_obj); __UNPROTECT__(qname_obj);
}



void StxXercesCharacters(OBJ* handler_ref, char* characters) {
	OBJ characters_obj;
	characters_obj = __MKSTRING(characters);
	__SSEND1(*handler_ref, @symbol(xercesCharacters:), 0, characters_obj);
}

void StxXercesIgnorableWhitespace(OBJ* handler_ref, char* characters) {
	OBJ characters_obj;
	characters_obj = __MKSTRING(characters);
	__SSEND1(*handler_ref, @symbol(xercesIgnorableWhitespace:), 0, characters_obj);
}

void StxXercesComment(OBJ* handler_ref, char* characters) {
	OBJ characters_obj;
	characters_obj = __MKSTRING(characters);
	__SSEND1(*handler_ref, @symbol(xercesComment:), 0, characters_obj);
}

void StxXercesStartPrefixMapping(OBJ* handler_ref, char* prefix, char* uri) {
	OBJ prefix_obj, uri_obj;
	prefix_obj = __MKSTRING(prefix); __PROTECT__(prefix_obj);
	uri_obj = __MKSTRING(uri);
	__SSEND2(*handler_ref, @symbol(xercesStartPrefix:mappingTo:), 0, prefix_obj, uri_obj);
	__UNPROTECT__(prefix_obj);
}
void StxXercesEndPrefixMapping(OBJ* handler_ref, char* prefix) {
	OBJ prefix_obj;
	prefix_obj = __MKSTRING(prefix);
	__SSEND1(*handler_ref, @symbol(xercesEndPrefixMapping:), 0, prefix_obj);
}

void StxXercesStartHandleElementPSVI(OBJ* handler_ref,char* localname, char* uri, StxXercesPSVIElement elementPSVI) {
	OBJ localname_obj, uri_obj;
	localname_obj = __MKSTRING(localname); __PROTECT__(localname_obj);
	uri_obj = __MKSTRING(uri); __PROTECT__(uri_obj);
	__SSEND3(*handler_ref, @symbol(xercesHandleElement:namespace:psvi:), 0, localname_obj, uri_obj, nil );
	__UNPROTECT__(localname_obj);  __UNPROTECT__(uri_obj);

}

%}

! !

!XercesCXMLReader class methodsFor:'private - xerces'!

primInitialize

%{
	RETURN(__MKINT(StxXercesInitialize()));
%}.

!

primTerminate

%{
	RETURN(__MKINT(StxXercesTerminate()));
%}.

! !

!XercesCXMLReader methodsFor:'SAX2 interface - Locator'!

getColumnNumber
    "Superclass XMLv2::XMLReader says that I am responsible to implement this method"

    self shouldImplement

    "Created: / 15-12-2008 / 07:22:15 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

getLineNumber
    "Superclass XMLv2::XMLReader says that I am responsible to implement this method"

    self shouldImplement

    "Created: / 15-12-2008 / 07:22:15 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!XercesCXMLReader methodsFor:'private'!

parseFragmentStream:aStream
    "Superclass XMLv2::XMLReader says that I am responsible to implement this method"

    self shouldImplement

    "Created: / 15-12-2008 / 07:22:15 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

parseStream:aStream

    ^self xercesParseStream: aStream binary

    "Created: / 15-12-2008 / 07:22:15 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 06-04-2009 / 13:35:03 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!XercesCXMLReader methodsFor:'private - xerces'!

xercesCharacters: aString

    self getContentHandler characters: aString

    "Created: / 06-04-2009 / 13:29:40 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

xercesEndDocument

    self getContentHandler endDocument

    "Created: / 06-04-2009 / 13:29:40 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

xercesEndElement:localName namespace: ns qname: qname

    self getContentHandler 
            endElement: localName
            namespace: ns
            prefix: (qname copyTo: (qname size - localName size - 1))

    "Created: / 06-04-2009 / 13:33:52 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

xercesEndPrefixMapping: prefix 

    self getContentHandler endPrefixMapping: prefix

    "Created: / 06-04-2009 / 15:48:18 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

xercesParseStream: stream

%{
	StxXercesParse(self, stream);
%}.

!

xercesStartDocument

    self getContentHandler startDocument

    "Created: / 06-04-2009 / 13:26:48 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

xercesStartElement:localName namespace: ns qname: qname attributes: attrs

    self getContentHandler 
            startElement: localName
            namespace: ns
            prefix: (qname copyTo: (qname size - localName size - 1))
            attributes: attrs

    "Created: / 06-04-2009 / 13:33:37 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

xercesStartPrefix:prefix mappingTo:ns

    self getContentHandler startPrefix:prefix mappingTo:ns

    "Created: / 06-04-2009 / 15:45:03 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

