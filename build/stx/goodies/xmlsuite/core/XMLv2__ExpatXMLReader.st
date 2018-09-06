"{ Package: 'stx:goodies/xmlsuite/core' }"

"{ NameSpace: XMLv2 }"

XMLReader subclass:#ExpatXMLReader
	instanceVariableNames:'parser inCDataSection'
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-SAX2-XMLReaders'
!

!ExpatXMLReader primitiveDefinitions!
%{

/*
 * includes, defines, structure definitions
 * and typedefs come here.
 */

#include <stdio.h>
#include <expat.h>

#define CHUNK_SIZE 8192

/*
# define EXPAT_DEBUG(args) printf("ExpatXMLReader [debug]") ; printf args
/**/
/**/
# define EXPAT_DEBUG(args)
/**/

#if defined (__BORLANDC__)
# define __PRETTY_FUNCTION__ "__PRETTY_FUNCTION__ not available"
#endif


#define EXPAT_DEBUG_ENTER EXPAT_DEBUG((" Entering %s\n",__PRETTY_FUNCTION__))
#define EXPAT_DEBUG_LEAVE EXPAT_DEBUG((" Leaving  %s\n",__PRETTY_FUNCTION__))

/* 
   HACK for development. If you write thode functions in
   "Primitive functions" field, functions are not fileouted
   when you "accept" primitive method in browser, so
   C compiler can't compile native code using those methods.
*/
struct {
    OBJ* this_object;
} user_data;


static void XMLCALL
startElement(void* readerPointer, const XML_Char* nameStr, const XML_Char** attributes) {
    OBJ reader;
    OBJ attArray = nil;
    OBJ attName,attValue;
    OBJ name = nil;
    int i;
    EXPAT_DEBUG_ENTER;
    for ( i = 0; attributes[i]; i += 2 ); /* compute length of att array */
    EXPAT_DEBUG((" Element tiplet is %s\n",nameStr));
	EXPAT_DEBUG((" Number of attributes is %d\n",i));
    if ( i > 0 ) { /* there are some attributes */ 
        attArray = __ARRAY_NEW_INT(i);
        EXPAT_DEBUG((" Attribute array allocated. Entering fill loop\n"));
        for ( i = 0; attributes[i]; i += 2 ) {/* fill att array */
                EXPAT_DEBUG((" Processing attribute %s value %s\n",attributes[i],attributes[i+1]));
			__PROTECT__(attArray); 
            attName = __MKSTRING(attributes[i]);
			__PROTECT__(attName);
            attValue = __MKSTRING(attributes[i+1]);
			__UNPROTECT__(attName);
			__UNPROTECT__(attArray); /* unprotect  */
            __ArrayInstPtr(attArray)->a_element[i] = attName;
            __STORE(attArray,attName); /* string may be different memory space than array */
            __ArrayInstPtr(attArray)->a_element[i+1] = attValue;
            __STORE(attArray,attValue); /* string may be different memory space than array */
        }
        EXPAT_DEBUG((" Attribute array filled\n"));
    }
    __PROTECT__(attArray);
    name = __MKSTRING(nameStr);
    __UNPROTECT__(attArray);
    reader = **(OBJ**)readerPointer;
    EXPAT_DEBUG((" Reader is at %x, sending #expatStartElement:attributes:\n",reader));
    __SSEND2(reader, @symbol(expatStartElement:attributes:),0, name, attArray);
    EXPAT_DEBUG_LEAVE;
}

static void XMLCALL
endElement(void* readerPointer, const XML_Char* nameStr) {
    OBJ reader;
    OBJ name;
    EXPAT_DEBUG_ENTER;
    name = __MKSTRING(nameStr);    
    reader = **(OBJ**)readerPointer;
    __SSEND1(reader, @symbol(expatEndElement:),0, name);
    EXPAT_DEBUG_LEAVE;
}

static void XMLCALL
startNSPrefixMapping(void* readerPointer, const XML_Char* prefixStr, const XML_Char* uriStr) {
    OBJ reader = **(OBJ**)readerPointer;
    OBJ prefix;
    OBJ uri;
    EXPAT_DEBUG_ENTER;
    prefix = __MKSTRING(prefixStr);
    uri = __MKSTRING(uriStr);
    reader = **(OBJ**)readerPointer;   
    __SSEND2(reader, @symbol(expatStartPrefix:mappingTo:),0, uri, prefix);
    EXPAT_DEBUG_LEAVE;
}

static void XMLCALL
endNSPrefixMapping(void* readerPointer, const XML_Char* prefixStr) {
    OBJ reader;
    OBJ prefix;
    EXPAT_DEBUG_ENTER;
    prefix = __MKSTRING(prefixStr);
    reader = **(OBJ**)readerPointer;   
    __SSEND1(reader, @symbol(expatEndPrefixMapping:),0, prefix);
    EXPAT_DEBUG_LEAVE;
}

static void XMLCALL
xmlProlog(void* readerPointer, const XML_Char* verStr, const XML_Char* encStr, int standInt) {
    OBJ reader;
    OBJ version;
    OBJ encoding;
    OBJ standalone;
    EXPAT_DEBUG_ENTER;
    if (verStr == NULL) {
        version = __MKSTRING("1.0");
    } else {
        version = __MKSTRING(verStr);
    }
    if (encStr == NULL) {
        encoding = nil;
    } else {
        encoding = __MKSTRING(encStr);
    }
    standalone = __MKINT(standInt);

    reader = **(OBJ**)readerPointer;   
    __SSEND3(reader, @symbol(expatPrologVersion:encoding:standalone:),
            0, version, encoding, standalone);
    EXPAT_DEBUG_LEAVE;
}




static void XMLCALL
characters(void* readerPointer, const XML_Char* charStr, int charLen) {
    OBJ reader = **(OBJ**)readerPointer;
    OBJ chars;
    EXPAT_DEBUG_ENTER;
    chars = __MKSTRING_L(charStr,charLen);
    reader = **(OBJ**)readerPointer;   
    __SSEND1(reader, @symbol(expatCharacters:),0, chars);
    EXPAT_DEBUG_LEAVE;
}

static void XMLCALL
startCDataSection(void* readerPointer) {
        OBJ reader;
        EXPAT_DEBUG_ENTER;
        reader = **(OBJ**)readerPointer;
        __SSEND1(reader, @symbol(expatInCDataSection:),0,true);
        EXPAT_DEBUG_LEAVE;
}

static void XMLCALL
endCDataSection(void* readerPointer) {
        OBJ reader;
        EXPAT_DEBUG_ENTER;
        reader = **(OBJ**)readerPointer;
        __SSEND1(reader, @symbol(expatInCDataSection:),0,false);
        EXPAT_DEBUG_LEAVE;
}

static void XMLCALL
errorOccuredWhenParsing(XML_Parser p) {
    OBJ reader;
    OBJ errorString;
    EXPAT_DEBUG_ENTER;
    errorString = __MKSTRING(XML_ErrorString(XML_GetErrorCode(p)));
    reader = **(OBJ**)XML_GetUserData(p);
    __SSEND4(reader, @symbol(expatParseError:code:line:column:), 0,
        errorString,
        _MKSMALLINT(XML_GetErrorCode(p)),
        _MKSMALLINT(XML_GetCurrentLineNumber(p)),
        _MKSMALLINT(XML_GetCurrentColumnNumber(p)));
        EXPAT_DEBUG_LEAVE;
}

static void XMLCALL
processingInstruction(void* readerPointer, const XML_Char* targetStr, const XML_Char* dataStr) {
    OBJ reader;
    OBJ target;
    OBJ data;
    EXPAT_DEBUG_ENTER;
    target = __MKSTRING(targetStr);
    data = __MKSTRING(dataStr);
    reader = **(OBJ**)readerPointer;
    __SSEND2(reader, @symbol(expatPI:data:),0, target,data);
    EXPAT_DEBUG_LEAVE;
}

static void XMLCALL
comment(void* readerPointer, const XML_Char* commentStr) {
    OBJ reader;
    OBJ comment;
    EXPAT_DEBUG_ENTER;
    comment = __MKSTRING(commentStr);
    reader = **(OBJ**)readerPointer;
    __SSEND1(reader, @symbol(expatComment:),0, comment);
    EXPAT_DEBUG_LEAVE;
}

static int XMLCALL
unknownEncodingHandler(void *readerPointer,
                       const XML_Char *name,
                       XML_Encoding *info)
{
    OBJ reader;
    OBJ mapArray;
    int i;
    int size;
    EXPAT_DEBUG_ENTER;
    reader = **(OBJ**)readerPointer;
    EXPAT_DEBUG((" Unknown encoding %s encountered\n"));
    mapArray = __SSEND1(reader, @symbol(expatUnknownEncoding:), 0, __MKSTRING(name));
    if (! __isArray(mapArray)) goto error;
    EXPAT_DEBUG((" Got map!\n"));
    size =  (256 < __arraySize(mapArray) ? 256 : __arraySize(mapArray));   
    for (i = 0; i < size; i++) {
        if (__isInteger(__ArrayInstPtr(mapArray)->a_element[i])) {
            info->map[i] = __intVal(__ArrayInstPtr(mapArray)->a_element[i]);
            EXPAT_DEBUG((" map[%d] = %d;\n", i, info->map[i]));
        } else {
            EXPAT_DEBUG((" Non-integer value in the map array!"));
            goto error;
        }
    }
    info->convert = NULL;
    info->release = NULL;
    EXPAT_DEBUG((" OK, return 1\n"));
    EXPAT_DEBUG_LEAVE;
    return 1;
    error:
    EXPAT_DEBUG((" FAIL, return 0\n"));
    EXPAT_DEBUG_LEAVE;
    return 0;
   
}



%}
! !

!ExpatXMLReader primitiveVariables!
%{

/*
 * any local C variables
 * come here (please, define as static)
 */



%}
! !


!ExpatXMLReader class methodsFor:'testing'!

isAvailable
    "
        self isAvailable  
    "
    
   ^self perform:#primitiveIsAvailable ifNotUnderstood:[false]

    "Created: / 29-10-2006 / 22:37:05 / janfrog"
    "Modified: / 12-04-2007 / 21:31:39 / janfrog"
!

primitiveIsAvailable
    
%{
    RETURN(true);
%}.
    ^false

    "Created: / 09-02-2007 / 17:44:42 / janfrog"
! !

!ExpatXMLReader methodsFor:'SAX2 interface - Locator'!

getColumnNumber
    "Superclass says that I am responsible to implement this method"

    ^self primitiveGetCurrentColumnNumber

    "Created: / 19-05-2005 / 09:43:25 / masca"
!

getLineNumber
    "Superclass says that I am responsible to implement this method"

    ^self primitiveGetCurrentLineNumber

   "Created: / 19-05-2005 / 09:43:37 / masca"
! !

!ExpatXMLReader methodsFor:'expat events'!

expatCharacters:aString

    | handler |
    handler := self getContentHandler.
    (inCDataSection and:[handler respondsTo:#cDataSection:])
        ifTrue:[^handler cDataSection:aString].

    (aString allSatisfy:[:char|char isXMLWhiteSpace])
        ifTrue:[handler ignorableWhitespace:aString]
        ifFalse:[handler characters:aString]

    "Created: / 17-04-2005 / 09:06:07 / janfrog"
    "Modified: / 28-12-2005 / 16:18:15 / janfrog"
!

expatComment:aString

    | handler |

    handler := self getContentHandler.
    (handler respondsTo:#comment:)
        ifTrue:[handler comment:aString]

    "Created: / 17-04-2005 / 13:33:10 / janfrog"
    "Modified: / 28-12-2005 / 16:18:00 / janfrog"
!

expatEndDocument

    self getContentHandler endDocument

    "Created: / 17-04-2005 / 09:32:14 / janfrog"
!

expatEndDocumentFragment

    self getContentHandler endDocumentFragment

    "Created: / 23-04-2005 / 14:16:39 / janfrog"
!

expatEndElement:name 
    "name = String"
    
    |nodeName|

    nodeName := self nodeNameFromExpatExpandedElementName:name.
    self getContentHandler 
        endElement:nodeName localName
        namespace:nodeName ns 
        prefix:nodeName prefix

    "Created: / 16-04-2005 / 21:36:24 / janfrog"
    "Modified: / 29-09-2006 / 10:24:59 / janfrog"
!

expatEndPrefixMapping:prefix

    self getContentHandler endPrefixMapping:prefix

    "Created: / 17-04-2005 / 08:48:23 / janfrog"
!

expatInCDataSection: aBoolean

    inCDataSection := aBoolean

    "Created: / 28-12-2005 / 13:49:31 / janfrog"
    "Modified: / 28-12-2005 / 16:18:04 / janfrog"
!

expatPI:target data:data

    self getContentHandler processingInstruction:target data:data.

    "Created: / 17-04-2005 / 13:32:50 / janfrog"
!

expatParseError:msg code:code line:line column:column

    | error |

    error := SAXParseError new
                errorString:'Parse error at line ',line printString,' col ',column printString,' #',code printString,': ',msg;
                line:line;
                col:column.
    self primitiveFreeExpatParser.
    self getErrorHandler fatalError:error.

    "Created: / 17-04-2005 / 09:54:19 / janfrog"
    "Modified: / 21-04-2005 / 19:41:59 / janfrog"
!

expatPrologVersion: vers encoding: enc standalone: stand

    xmlVersion := vers.
    xmlEncoding := enc.
    standalone := stand == 1

    "Created: / 28-12-2005 / 16:18:14 / janfrog"
!

expatStartDocument

    self getContentHandler startDocument

    "Created: / 17-04-2005 / 09:32:03 / janfrog"
!

expatStartDocumentFragment

    self getContentHandler startDocumentFragment

    "Created: / 23-04-2005 / 14:16:24 / janfrog"
!

expatStartElement:name attributes:attArray 
    "name = String
     attArray = array of strings. could be nil -> no attributes"
    
    |nodeName attributes|

    nodeName := self nodeNameFromExpatExpandedElementName:name.
    attributes := attArray 
                ifNil:[ Attributes empty ]
                ifNotNil:[
                    self attributesFromExpatAttArray:attArray inScopeOfNodeName:nodeName
                ].
    self getContentHandler 
        startElement:nodeName localName 
        namespace:nodeName ns 
        prefix:nodeName prefix 
        attributes:attributes

    "Created: / 16-04-2005 / 21:36:33 / janfrog"
    "Modified: / 29-09-2006 / 10:24:25 / janfrog"
!

expatStartPrefix:prefix mappingTo:uri

    self getContentHandler startPrefix:prefix mappingTo:uri

    "Created: / 17-04-2005 / 08:47:52 / janfrog"
!

expatUnknownEncoding: aString

    | encoder |
    encoder := CharacterEncoder encoderFor: aString.
    (encoder isKindOf: CharacterEncoderImplementations::SingleByteEncoder)
        ifFalse:[^nil "multibyte encoders not supported"].
    ^( ( 0 to: 255 ) collect: [:c|encoder decode:c] ) asArray

    "Modified: / 27-10-2008 / 19:09:57 / Jan Vrany <vranyj1@fel.cvut.cz>"

! !

!ExpatXMLReader methodsFor:'expat primitives'!

primitiveChunkSize
    "Return chunk size"

%{
    RETURN(_MKSMALLINT(CHUNK_SIZE));
%}

    "Created: / 21-04-2005 / 19:38:18 / janfrog"
!

primitiveCreateExpatParser
    "Creates and initialize expat parser"

%{
    XML_Parser  p;
    OBJ** data;
    OBJ parserAddress;
    p = XML_ParserCreateNS(NULL,'|');
    if (p != NULL) {
        data = (OBJ**)malloc(sizeof (OBJ**));
        EXPAT_DEBUG((" Allocating  data=0x%x\n", data));
        *data = (OBJ*)malloc(sizeof (OBJ*));
        EXPAT_DEBUG((" Allocating *data=0x%x\n", *data));
        **data = self;
        EXPAT_DEBUG((" Parser is **data=0x%x\n", **data));
        XML_SetUserData(p,data);
        __ADD_REFCELL(*data);
        XML_SetElementHandler(p, startElement, endElement);
        XML_SetStartNamespaceDeclHandler(p, startNSPrefixMapping);
        XML_SetEndNamespaceDeclHandler(p, endNSPrefixMapping);
        XML_SetCharacterDataHandler(p, characters);
        XML_SetCommentHandler(p, comment);
        XML_SetProcessingInstructionHandler(p, processingInstruction);
        XML_SetStartCdataSectionHandler(p, startCDataSection);
        XML_SetEndCdataSectionHandler(p, endCDataSection);
        XML_SetXmlDeclHandler(p, xmlProlog);
        XML_SetUnknownEncodingHandler(p, unknownEncodingHandler, data);
        XML_SetReturnNSTriplet(p,1);

        /* Store parser into instance variable */
        parserAddress = (__MKEXTERNALADDRESS(p));
        __INST(parser) = parserAddress;
        __STORE(self, parserAddress);


        RETURN(self)
    }
%}.
    SAXError raiseErrorString:'Cannot create expat parser'

    "Created: / 21-04-2005 / 19:00:58 / janfrog"
    "Modified: / 28-12-2005 / 16:18:15 / janfrog"
!

primitiveFreeExpatParser
    "Frees previously created expat parser"

%{
    OBJ** data;
    XML_Parser p;
    if (__isExternalAddress(__INST(parser))) {        
        p = __externalAddressVal(__INST(parser));
        data = (OBJ**)XML_GetUserData(p);
        __REMOVE_REFCELL(*data);
	EXPAT_DEBUG((" Parser is **data=0x%x\n", **data));
        EXPAT_DEBUG((" Freeing    *data=0x%x\n", *data));
        free(*data);
        EXPAT_DEBUG((" Freeing     data=0x%x\n", data));	
        free(data);
        XML_ParserFree(p); 
    }
%}.
    parser := nil.

    "Created: / 21-04-2005 / 19:03:20 / janfrog"
    "Modified: / 11-08-2005 / 21:49:24 / janfrog"
!

primitiveGetCurrentColumnNumber
    "Frees previously created expat parser"

%{
    OBJ** data;
    XML_Parser p;
    if (__isExternalAddress(__INST(parser))) {        
        p = __externalAddressVal(__INST(parser));
        RETURN(_MKSMALLINT(XML_GetCurrentColumnNumber(p)));
    }
%}.
    ^nil

    "Created: / 02-05-2005 / 12:03:19 / janfrog"
    "Modified: / 11-08-2005 / 21:31:33 / janfrog"
!

primitiveGetCurrentLineNumber
    "Frees previously created expat parser"

%{
    OBJ** data;
    XML_Parser p;        
    if (__isExternalAddress(__INST(parser))) {        
        p = __externalAddressVal(__INST(parser));
        RETURN(_MKSMALLINT(XML_GetCurrentLineNumber(p)));
    }
%}.
    ^nil

    "Created: / 02-05-2005 / 12:03:30 / janfrog"
    "Modified: / 11-08-2005 / 21:31:54 / janfrog"
!

primitiveParseChunk:anExternalBytes len:anInteger
    "Frees previously created expat parser"

%{
    unsigned char* chunk;
    int chunkLen = __intVal(anInteger);
    XML_Parser p;
    EXPAT_DEBUG((" In #primitiveParseChunk:#[...] len:%d\n",chunkLen));
    if (__isExternalAddress(__INST(parser))) {        
        p = __externalAddressVal(__INST(parser));
    }
    if (__isExternalBytesLike(anExternalBytes)) {
        chunk = __externalAddressVal(anExternalBytes);
        if ( 
            XML_Parse(p, chunk, chunkLen, 0)
                == XML_STATUS_ERROR
        ) {
            errorOccuredWhenParsing(p);
            RETURN(false);
        }
    } else {
        RETURN(false);
    }
    EXPAT_DEBUG((" ...finished\n"));
%}.
    ^true

    "Created: / 21-04-2005 / 20:09:08 / janfrog"
    "Modified: / 06-10-2006 / 13:08:55 / janfrog"
! !

!ExpatXMLReader methodsFor:'expat utilities'!

attributesFromExpatAttArray:anArray inScopeOfNodeName:ownerNodeName

    | attributes nodeName att |

    anArray isEmpty ifTrue:[^Attributes empty].
    attributes := Attributes new.

    anArray pairWiseDo:[:name :value |
        nodeName := self  
                        nodeNameFromExpatExpandedAttributeName:name
                        inScopeOfNodeName:ownerNodeName.
        att := Attr named:nodeName value:value.
        attributes add:att
    ].
    ^attributes

    "Created: / 11-08-2005 / 22:08:47 / janfrog"
    "Modified: / 29-09-2006 / 10:22:46 / janfrog"
!

nodeNameFromExpatExpandedAttributeName:expandedName inScopeOfNodeName:ownerNodeName

    | a |
    a := expandedName tokensBasedOn:$|.

    (a size = 1) ifTrue:[
        ^NodeName new
            prefix:ownerNodeName prefix;
            ns:ownerNodeName ns;
            localName:a first
    ] ifFalse:[
        ^NodeName new
            prefix:a third;
            ns:a first;
            localName:a second.
    ]

    "Created: / 11-08-2005 / 22:08:47 / janfrog"
    "Modified: / 29-09-2006 / 10:25:26 / janfrog"
!

nodeNameFromExpatExpandedElementName:expandedName

    | a |
    a := expandedName tokensBasedOn:$|.

    (a size = 2) ifTrue:[
        ^NodeName new
            prefix:'';
            ns:a first;
            localName:a second
    ].             
    (a size = 3) ifTrue:[
        ^NodeName new
            prefix:a third;
            ns:a first;
            localName:a second
    ].
    ^NodeName new
        prefix:'';
        ns:'';
        localName:expandedName

    "Created: / 11-08-2005 / 22:08:47 / janfrog"
    "Modified: / 06-10-2006 / 09:42:08 / janfrog"
! !

!ExpatXMLReader methodsFor:'initialization'!

initialize

    super initialize.
    inCDataSection := false.

    "Created: / 28-12-2005 / 16:18:06 / janfrog"
! !

!ExpatXMLReader methodsFor:'parsing'!

parseFragmentStream:aStream

    | chunk chunkSize bytesRead fragmentHeader fragmentFooter |
    aStream isReadable ifFalse:[
        self getErrorHandler fatalError:
            (SAXError withMessage:'Stream is not readable')
        ].
    chunk := ExternalBytes new:(chunkSize := self primitiveChunkSize).
    fragmentHeader := '<?xml version="1.0" ?><fragment>' .
    fragmentFooter := '</fragment>'.
    self primitiveCreateExpatParser.
    aStream binary.
    self expatStartDocumentFragment.
    [
        chunk replaceBytesFrom:1 to:fragmentHeader size with:fragmentHeader startingAt:0.

        (self primitiveParseChunk:fragmentHeader len:fragmentHeader size) ifFalse:[
                self getErrorHandler fatalError:(SAXError withMessage:'Hmm...cannot parse').
                self primitiveFreeExpatParser. 
                ^self
        ].
        [aStream atEnd] whileFalse:[
            aStream readWait.
            bytesRead := aStream nextBytes:chunkSize into:chunk.
            (self primitiveParseChunk:chunk len:bytesRead) ifFalse:[
                self getErrorHandler fatalError:(SAXError withMessage:'Hmm...cannot parse').
                self primitiveFreeExpatParser. 
                ^self
            ]
        ].
        chunk replaceBytesFrom:1 to:fragmentFooter size with:fragmentFooter startingAt:0.
        (self primitiveParseChunk:chunk len:fragmentFooter size) ifFalse:[
                self getErrorHandler fatalError:(SAXError withMessage:'Hmm...cannot parse').
                self primitiveFreeExpatParser. 
                ^self
        ].
        self expatEndDocumentFragment.
    ] ensure:[
        self primitiveFreeExpatParser.
        chunk free
    ].

    "Created: / 23-04-2005 / 14:16:13 / janfrog"
    "Modified: / 15-07-2010 / 16:30:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"

!

parseStream:aStream

    | chunk chunkSize bytesRead |
    aStream isReadable ifFalse:[
        self getErrorHandler fatalError:
            (SAXError withMessage:'Stream is not readable')
        ].
    chunk := ExternalBytes new:(chunkSize := self primitiveChunkSize).
    [
        self primitiveCreateExpatParser.
        aStream binary.
        self expatStartDocument.
        [aStream atEnd] whileFalse:[
            aStream readWait.
            bytesRead := aStream nextBytes:chunkSize into:chunk.
            (self primitiveParseChunk:chunk len:bytesRead) ifFalse:[
                self getErrorHandler fatalError:(SAXError withMessage:'Hmm...cannot parse').
                self primitiveFreeExpatParser.            
            ]
        ].        
        self expatEndDocument.
    ] ensure: [
        self primitiveFreeExpatParser.
        chunk free
    ]

    "Created: / 21-04-2005 / 19:37:05 / janfrog"
    "Modified: / 15-07-2010 / 09:29:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ExpatXMLReader class methodsFor:'documentation'!

version
    ^ '$Id$'

!

version_SVN
    ^ '$Id$'
! !

