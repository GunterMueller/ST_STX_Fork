"{ Package: 'stx:goodies/xmlsuite/core' }"

"{ NameSpace: XMLv2 }"

Object subclass:#XMLWriter
	instanceVariableNames:'stream pendingNamespaceDeclarations'
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-XML Writer'
!


!XMLWriter class methodsFor:'instance creation'!

on:aStream

    ^self new stream: aStream

    "Created: / 18-10-2005 / 11:49:49 / janfrog"
!

onFile:aStringOrFilename

    ^self on: aStringOrFilename asFilename writeStream

    "Created: / 21-11-2005 / 17:00:06 / janfrog"
! !

!XMLWriter methodsFor:'Compatibility-VW'!

documentLocator:aSAXLocator

    "ignored"

    "Created: / 18-10-2005 / 12:50:26 / janfrog"
! !

!XMLWriter methodsFor:'SAX2 events'!

characters:aString

    self nextPutString:aString

    "Created: / 18-10-2005 / 12:46:54 / janfrog"
    "Modified: / 21-10-2005 / 14:58:05 / janfrog"
!

endDocument

    self stream isExternalStream
        ifTrue:[self stream close]

    "Created: / 18-10-2005 / 12:07:45 / janfrog"
    "Modified: / 23-11-2005 / 14:44:30 / janfrog"
!

endElement:localName namespace:namespace prefix:prefix

    self
        nextPut:$<;
        nextPut:$/;
        nextPutPrefix:prefix localName:localName;
        nextPut:$>

    "Created: / 18-10-2005 / 12:24:53 / janfrog"
!

endPrefixMapping:prefix

    "ignored"

    "Created: / 18-10-2005 / 14:48:26 / janfrog"
!

ignorableWhitespace:aString

    self characters:aString

    "Created: / 18-10-2005 / 12:46:46 / janfrog"
    "Modified: / 21-10-2005 / 15:38:45 / janfrog"
!

processingInstruction:target data:data

    self
        nextPut:$<;
        nextPut:$?;
        nextPutAll:target;
        space;
        nextPutAll:data;
        nextPut:$?;
        nextPut:$>

    "Created: / 18-10-2005 / 12:45:25 / janfrog"
!

setDocumentLocator:aDocumentLocator

    "ignored"

    "Created: / 18-10-2005 / 12:48:16 / janfrog"
!

startDocument

    self nextPutProlog

    "Created: / 18-10-2005 / 11:49:05 / janfrog"
!

startElement:localName namespace:namespace prefix:prefix attributes:attributes 
    self
        nextPut:$<;
        nextPutPrefix:prefix localName:localName;
        nextPutAttributes:attributes , (pendingNamespaceDeclarations ? #())
            implicitNamespace:namespace;
        nextPut:$>.
    pendingNamespaceDeclarations := nil

    "Created: / 18-10-2005 / 12:10:05 / janfrog"
    "Modified: / 09-04-2007 / 11:20:13 / janfrog"
!

startPrefix:prefix mappingTo:uri

    | declAttr |

    declAttr := Attr new
                    qualifiedName:'xmlns' , (prefix isNilOrEmptyCollection ifTrue:[''] ifFalse:[':', prefix]);
                    value:uri.

    pendingNamespaceDeclarations ifNil:[pendingNamespaceDeclarations := Attributes new].

    pendingNamespaceDeclarations add: declAttr

    "Created: / 18-10-2005 / 12:43:47 / janfrog"
    "Modified: / 18-10-2005 / 14:51:02 / janfrog"
! !

!XMLWriter methodsFor:'SAX2 interface - extensions'!

cDataSection: aString

    self 
        nextPutAll:'<!![CDATA[';
        nextPutAll:aString;
        nextPutAll:']]'

    "Created: / 28-12-2005 / 13:53:07 / janfrog"
    "Modified: / 28-12-2005 / 16:18:04 / janfrog"
!

comment:aString

    self 
        nextPutAll:'<!!--';
        nextPutAll:aString;
        nextPutAll:'-->'

    "Created: / 18-10-2005 / 15:32:52 / janfrog"
! !

!XMLWriter methodsFor:'accessing'!

contentHandler

    ^self

    "Created: / 18-10-2005 / 12:47:43 / janfrog"
!

stream
    ^ stream

    "Created: / 18-10-2005 / 11:50:02 / janfrog"
!

stream:something
    stream := something.

    "Created: / 18-10-2005 / 11:50:02 / janfrog"
!

streamContents

    ^stream contents

    "Created: / 18-10-2005 / 11:52:30 / janfrog"
! !

!XMLWriter methodsFor:'streaming'!

cr

    self nextPut:Character cr

    "Created: / 18-10-2005 / 11:54:20 / janfrog"
!

next:anInteger put:aCharacter

    stream next:anInteger put:aCharacter

    "Created: / 27-11-2005 / 11:43:55 / janfrog"
!

nextPut:aCharacter

    stream nextPut:aCharacter

    "Created: / 18-10-2005 / 11:53:49 / janfrog"
    "Modified: / 21-10-2005 / 14:57:31 / janfrog"
!

nextPutAll:aCollection

    stream nextPutAll:aCollection

    "Created: / 18-10-2005 / 11:54:03 / janfrog"
    "Modified: / 21-10-2005 / 14:57:28 / janfrog"
!

nextPutString:aString

    stream nextPutAll:aString asXMLEscapedString

    "Created: / 21-10-2005 / 14:57:51 / janfrog"
!

space

    self nextPut:Character space

    "Created: / 18-10-2005 / 11:54:14 / janfrog"
! !

!XMLWriter methodsFor:'writing'!

nextPutAttribute:anAttr implicitNamespace:implicitNS 
    self
        space;
        nextPutAll:
            (anAttr namespaceURI = implicitNS
                ifTrue:[anAttr localName ]
                ifFalse:[anAttr nodeName]);
        nextPut:$=;
        nextPut:$";
        nextPutString:(anAttr nodeValue);
        nextPut:$"

    "Created: / 09-04-2007 / 11:19:59 / janfrog"
!

nextPutAttributes:attributes implicitNamespace:defaultNS 
    attributes do:[:attr | 
        self nextPutAttribute:attr implicitNamespace:defaultNS
    ]

    "Created: / 09-04-2007 / 11:20:13 / janfrog"
!

nextPutPrefix:prefix localName:localName

    prefix isNilOrEmptyCollection 
        ifTrue:[self nextPutAll:localName]
        ifFalse:[self nextPutAll:prefix; nextPut:$:; nextPutAll:localName]

    "Created: / 18-10-2005 / 12:22:52 / janfrog"
!

nextPutProlog

    self 
        nextPutAll:'<?xml version="1.0" encoding="';
        nextPutAll:self xmlEncodingName;
        nextPutAll:'"?>'

    "Created: / 18-10-2005 / 12:06:48 / janfrog"
! !

!XMLWriter methodsFor:'writing support'!

xmlEncodingName

    ^'utf-8'

    "Created: / 18-10-2005 / 12:07:16 / janfrog"
! !

!XMLWriter class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/XMLv2__XMLWriter.st,v 1.6 2007-04-10 08:35:54 vranyj1 Exp $'
!

version_SVN
    ^ '$Id$'
! !
