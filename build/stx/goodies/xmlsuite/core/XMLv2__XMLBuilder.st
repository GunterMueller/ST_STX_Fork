"{ Package: 'stx:goodies/xmlsuite/core' }"

"{ NameSpace: XMLv2 }"

Object subclass:#XMLBuilder
	instanceVariableNames:'writer pendingAttributes currentDepth prefixToNamespaceMapping
		objectToXmlIdMapping'
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-XML Writer'
!

!XMLBuilder class methodsFor:'documentation'!

documentation
"
    documentation to be added.

    [author:]
        Jan Vrany (janfrog@bruxa)

    [instance variables:]

    [class variables:]

    [see also:]

"
!

history
    "Created: / 21-11-2005 / 12:47:11 / janfrog"
! !

!XMLBuilder class methodsFor:'instance creation'!

new
    ^ self basicNew initialize.

    "Created: / 21-11-2005 / 17:04:10 / janfrog"
!

on: aStream

    ^self new initializeOnStream: aStream

    "Created: / 21-11-2005 / 17:01:35 / janfrog"
!

onFile: aStringOrFilename

    ^self new initializeOnStream:aStringOrFilename asFilename writeStream

    "Created: / 21-11-2005 / 17:02:12 / janfrog"
! !

!XMLBuilder class methodsFor:'xml id management'!

generateXmlIdFor: anObject

    ^ ('xmlid.' ,
        anObject class nameWithoutPrefix ,
            '.' ,
                anObject identityHash printString)

                replaceAll:Character space
                with:$.

    "Created: / 30-11-2005 / 17:45:12 / janfrog"
    "Modified: / 25-12-2005 / 18:17:11 / janfrog"
! !

!XMLBuilder methodsFor:'accessing'!

defaultWriter
    ^ self defaultWriterClass new

    "Created: / 27-11-2005 / 11:48:03 / janfrog"
!

defaultWriterClass
    ^ IndentingXMLWriter

    "Created: / 27-11-2005 / 11:48:19 / janfrog"
!

outputStream: aStream

    ^self writer stream: aStream

    "Created: / 23-11-2005 / 14:31:11 / janfrog"
!

pendingAttributes

    ^pendingAttributes ifNil:
        [pendingAttributes := Attributes new]

    "Created: / 21-11-2005 / 13:02:17 / janfrog"
!

streamContents

    ^self writer streamContents

    "Created: / 21-11-2005 / 13:50:58 / janfrog"
!

writer

    ^ writer

    "Created: / 21-11-2005 / 12:49:51 / janfrog"
    "Modified: / 21-11-2005 / 17:03:59 / janfrog"
!

writer:aXMLWriter

    writer := aXMLWriter.

    "Created: / 21-11-2005 / 12:49:51 / janfrog"
! !

!XMLBuilder methodsFor:'basic building'!

attribute:qualifiedName value:attributeValue 
    |nodeName|

    nodeName := self nodeNameFromQName:qualifiedName.
    self pendingAttributes add:(Attr named:nodeName value:attributeValue)

    "Created: / 23-11-2005 / 14:08:02 / janfrog"
!

declareNamespace: namespaceUri withPrefix:prefix

    | xmlnsDeclAttributeName |

    xmlnsDeclAttributeName := 
        prefix isEmpty 
            ifTrue:['xmlns']
            ifFalse:['xmlns:',prefix].

    self 
        attribute:xmlnsDeclAttributeName
        value: namespaceUri.

    prefixToNamespaceMapping 
        at: prefix
        put:(Array with:namespaceUri with:currentDepth + 1)

    "Created: / 21-11-2005 / 17:49:51 / janfrog"
    "Modified: / 27-11-2005 / 10:48:41 / janfrog"
!

documentWith: blockOrString

    writer startDocument.

    blockOrString isString ifTrue:[writer characters: blockOrString].
    blockOrString isBlock ifTrue:[blockOrString value].

    writer endDocument.

    "Created: / 21-11-2005 / 18:02:48 / janfrog"
!

element:qualifiedName with:blockOrString 
    |nodeName|

    nodeName := self nodeNameFromQName:qualifiedName.
    self writer 
        startElement:nodeName localName
        namespace:nodeName ns
        prefix:nodeName prefix
        attributes:self pendingAttributes.
    pendingAttributes isEmpty ifFalse:[
        pendingAttributes := nil
    ].
    currentDepth := currentDepth + 1.
    blockOrString isString ifTrue:[
        self writer characters:blockOrString
    ] ifFalse:[
        blockOrString value
    ].
    currentDepth := currentDepth - 1.
    self writer 
        endElement:nodeName localName
        namespace:nodeName ns
        prefix:nodeName prefix

    "Created: / 23-11-2005 / 14:07:53 / janfrog"
!

text: aString

    self writer characters: aString

    "Created: / 23-11-2005 / 14:13:15 / janfrog"
! !

!XMLBuilder methodsFor:'initialization'!

initialize
    writer := self defaultWriter.
    pendingAttributes := Attributes new.
    currentDepth := 0.
    prefixToNamespaceMapping := Dictionary new.
    objectToXmlIdMapping := IdentityDictionary new.

    "Created: / 21-11-2005 / 17:03:03 / janfrog"
    "Modified: / 27-11-2005 / 11:48:03 / janfrog"
!

initializeOnStream: aStream

    writer stream: aStream

    "Created: / 21-11-2005 / 17:03:51 / janfrog"
! !

!XMLBuilder methodsFor:'namespace handling'!

nodeNameFromQName: qName
    |nsName|
    nsName := ''.
    (qName includesString:':') ifTrue:[
        nsName := (qName split:':') at:2.
    ].
    ^NodeName new 
        qualifiedName: qName;
        ns:nsName.

    "Created: / 21-11-2005 / 13:00:10 / janfrog"
    "Modified: / 28-03-2011 / 18:36:42 / Pavel Strnad <strnapa1@fel.cvut.cz>"
! !

!XMLBuilder methodsFor:'xml id management'!

generateXmlIdFor:arg
    ^ self class generateXmlIdFor:arg

    "Created: / 30-11-2005 / 17:45:12 / janfrog"
!

xmlIdFor: anObject

    ^objectToXmlIdMapping
        at: anObject
        ifAbsentPut: [self generateXmlIdFor: anObject]

    "Created: / 27-11-2005 / 10:50:58 / janfrog"
    "Modified: / 28-11-2005 / 15:12:22 / janfrog"
! !

!XMLBuilder class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/XMLv2__XMLBuilder.st,v 1.5 2005-12-28 11:02:55 vranyj1 Exp $'
!

version_SVN
    ^ '$Id$'
! !
