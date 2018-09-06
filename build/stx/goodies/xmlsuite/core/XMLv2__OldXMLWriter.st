"{ Package: 'stx:goodies/xmlsuite/core' }"

"{ NameSpace: XMLv2 }"

Object subclass:#OldXMLWriter
	instanceVariableNames:'stream depth namespaces namespaceId nsStack
		pendingNamespaceDeclarations formatOutput'
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-XML Writer'
!

ContentHandler subclass:#ContentHandler
	instanceVariableNames:'writer'
	classVariableNames:''
	poolDictionaries:''
	privateIn:OldXMLWriter
!


!OldXMLWriter class methodsFor:'instance creation'!

new
    ^ self basicNew initialize.

    "Created: / 16-04-2005 / 20:38:09 / janfrog"
!

on:aStream

    ^self new initializeOn:aStream

    "Created: / 22-04-2005 / 22:13:11 / janfrog"
! !

!OldXMLWriter class methodsFor:'utilities'!

write:aDOMNode

    self new write:aDOMNode

    "Created: / 22-04-2005 / 22:12:17 / janfrog"
!

write:aDOMNode on:aStream

    ^(self on:aStream) write:aDOMNode

    "Created: / 22-04-2005 / 22:14:23 / janfrog"
!

write:aDOMNode on:aStream format:aBoolean

    ^(self on:aStream) 
        formatOutput:aBoolean;
        write:aDOMNode

    "Created: / 15-06-2005 / 19:12:58 / janfrog"
! !

!OldXMLWriter methodsFor:'accessing'!

encoding:encodingName

    stream ifNil:[self error:'No stream yet!!'].
    stream encoder:(CharacterEncoder encoderFor:encodingName)

    "Created: / 15-06-2005 / 19:28:03 / janfrog"
!

formatOutput
    ^ formatOutput

    "Created: / 15-06-2005 / 19:00:15 / janfrog"
!

formatOutput:aBoolean
    formatOutput := aBoolean.

    "Created: / 15-06-2005 / 19:00:15 / janfrog"
!

stream
    ^ stream

    "Created: / 22-04-2005 / 22:14:39 / janfrog"
!

stream:aStream
    self initializeOn:aStream

    "Created: / 15-06-2005 / 19:27:49 / janfrog"
! !

!OldXMLWriter methodsFor:'accessing - sax'!

contentHandler

    ^XMLWriter::ContentHandler new writer:self

    "Created: / 16-04-2005 / 20:37:06 / janfrog"
! !

!OldXMLWriter methodsFor:'initialization'!

initialize

    self initializeOn:Transcript

    "Created: / 22-04-2005 / 22:13:23 / janfrog"
!

initializeOn:aStream

    stream := EncodedStream 
                stream:aStream 
                encoder:(CharacterEncoder encoderForUTF8).
    depth := 0.
    namespaces := Dictionary new.
    namespaceId := 0.
    formatOutput := true.

    namespaces at:'http://www.w3.org/XML/1998/namespace' put: 'xml'

    "Created: / 22-04-2005 / 22:13:23 / janfrog"
    "Modified: / 15-06-2005 / 19:03:54 / janfrog"
! !

!OldXMLWriter methodsFor:'utilities'!

decIndent

    depth := depth - 1

    "Created: / 16-04-2005 / 20:40:55 / janfrog"
!

ensureNamespaceDeclaredFor: aNodeTag

    | qualifier |

    aNodeTag namespace isNilOrEmptyCollection ifTrue:[^self].
    
    "(namespaces includesKey: aNodeTag namespace)"
    (nsStack top includes:aNodeTag namespace) ifTrue: [
        aNodeTag qualifier: (namespaces at: aNodeTag namespace).
        ^self].

    qualifier := aNodeTag qualifier.
    (qualifier isNilOrEmptyCollection) ifTrue:[
        qualifier := namespaces at:aNodeTag namespace 
            ifAbsent:[
                | q |
                (namespaces values includes:'') ifFalse:[
                    q := ''.
                ] ifTrue:[
                    q := 'ns' , (namespaceId := namespaceId + 1) printString
                ].
                q
            ]
    ].
    namespaces at: aNodeTag namespace put: qualifier.
    nsStack top add:aNodeTag namespace.
    aNodeTag qualifier:qualifier.


    pendingNamespaceDeclarations := pendingNamespaceDeclarations ,
            (' xmlns' , (qualifier isEmpty ifTrue: [''] ifFalse: [':' , qualifier])) ,
                '="' ,
                    aNodeTag namespace,
                        '"'

    "Created: / 03-05-2005 / 11:07:41 / janfrog"
    "Modified: / 30-05-2005 / 16:42:15 / masca"
    "Modified: / 15-06-2005 / 11:08:56 / janfrog"
!

format:aDocument

    aDocument acceptVisitor:self

    "Created: / 22-04-2005 / 22:11:41 / janfrog"
!

incIndent

    depth := depth + 1

    "Created: / 16-04-2005 / 20:40:49 / janfrog"
!

write:aDOMNode

    aDOMNode acceptVisitor:self

    "Created: / 22-04-2005 / 22:12:31 / janfrog"
! !

!OldXMLWriter methodsFor:'visiting'!

visitComment:aComment

    self
        indent;
        nextPutComment:aComment text;
        cr.

    "Created: / 22-04-2005 / 22:11:10 / janfrog"
!

visitDocument:aDocument

    nsStack := Stack new.
    nsStack push:(Set new addAll:(namespaces keys); yourself).
    self nextPutXMLDecl ; cr.
    aDocument elements do:[:e|e acceptVisitor:self].
    nsStack := nil.

    "Created: / 22-04-2005 / 22:05:49 / janfrog"
    "Modified: / 15-06-2005 / 11:11:59 / janfrog"
!

visitElement:anElement

    | nsStackWasNil |

    pendingNamespaceDeclarations := ''.
    nsStack ifNil:[
        nsStackWasNil := true.
        nsStack := Stack new.
        nsStack push:(Set new addAll:(namespaces keys); yourself).
    ] ifNotNil:[
        nsStackWasNil := false
    ].
    nsStack push:(nsStack top copy).
    anElement elements isEmpty
        ifTrue:[self visitEmptyElement:anElement]
        ifFalse:[self visitElementWithChildren:anElement].
    nsStack pop.
    nsStackWasNil ifTrue:[nsStack := nil].

    "Created: / 22-04-2005 / 22:10:02 / janfrog"
    "Modified: / 30-05-2005 / 16:30:11 / masca"
    "Modified: / 15-06-2005 / 11:14:40 / janfrog"
!

visitElementWithChildren:anElement 
    |text|

    self ensureNamespaceDeclaredFor:anElement tag.
    self
        indent;
        nextPutOpenElement;
        nextPutElementPrefix:anElement tag qualifiedName
            localName:anElement tag type;
        nextPutAttributes:anElement attributes
            implicitNamespace:anElement tag namespace;
        nextPutAll:pendingNamespaceDeclarations;
        nextPutCloseElement.
    text := anElement elements size = 1 
                and:[ anElement elements anyOne isText ].
    text ifFalse:[
        self
            cr;
            incIndent
    ].
    anElement elements do:[:e | 
        e acceptVisitor:self
    ].
    text ifFalse:[
        self
            decIndent;
            indent
    ].
    self
        nextPutOpenElement;
        nextPut:$/;
        nextPutElementPrefix:anElement tag asString localName:'';
        nextPutCloseElement;
        cr.

    "Created: / 22-04-2005 / 22:32:18 / janfrog"
    "Modified: / 09-04-2007 / 11:20:13 / janfrog"
!

visitEmptyElement:anElement 
    self ensureNamespaceDeclaredFor:anElement tag.
    self
        indent;
        nextPutOpenElement;
        nextPutElementPrefix:anElement tag qualifier localName:anElement tag type;
        nextPutAttributes:anElement attributes
            implicitNamespace:anElement tag namespace;
        nextPutAll:pendingNamespaceDeclarations;
        nextPut:$/;
        nextPutCloseElement;
        cr.

    "Created: / 22-04-2005 / 22:29:32 / janfrog"
    "Modified: / 09-04-2007 / 11:20:13 / janfrog"
!

visitPI:aPI

    self 
        indent;
        nextPutPI:aPI name data:aPI text;
        cr

    "Created: / 22-04-2005 / 22:19:16 / janfrog"
    "Modified: / 23-04-2005 / 09:18:21 / janfrog"
!

visitText:aText

    self
        "/indent;
        nextPutAll:aText text
        "/cr.

    "Created: / 22-04-2005 / 22:10:42 / janfrog"
    "Modified: / 03-05-2005 / 10:58:47 / janfrog"
! !

!OldXMLWriter methodsFor:'writing'!

cr
    formatOutput ifTrue:[stream cr]

    "Created: / 16-04-2005 / 20:39:25 / janfrog"
    "Modified: / 15-06-2005 / 19:04:59 / janfrog"
!

indent

    formatOutput ifTrue:[
        stream next:depth*2 put:Character space
    ]

    "Created: / 16-04-2005 / 20:40:01 / janfrog"
    "Modified: / 15-06-2005 / 19:04:50 / janfrog"
!

nextPut:aCharacter

    stream nextPut:aCharacter

    "Created: / 16-04-2005 / 20:53:34 / janfrog"
!

nextPutAll:aString

    stream nextPutAll:aString

    "Created: / 16-04-2005 / 20:41:42 / janfrog"
    "Modified: / 16-05-2005 / 14:29:46 / masca"
!

nextPutAttribute:anAttr implicitNamespace:anObject 
    self ensureNamespaceDeclaredFor:anAttr tag.
    self
        nextPutAttributeName:anAttr tag qualifiedName;
        nextPut:$=;
        nextPutAttributeValue:anAttr value.

    "Created: / 09-04-2007 / 11:19:59 / janfrog"
!

nextPutAttributeName:qName

    self
        nextPutAll:qName

    "Created: / 17-04-2005 / 13:42:46 / janfrog"
!

nextPutAttributeValue:value

    self
        nextPut:$";
        nextPutAll:value;
        nextPut:$"

    "Created: / 17-04-2005 / 13:42:57 / janfrog"
    "Modified: / 22-04-2005 / 22:48:24 / janfrog"
!

nextPutAttributes:anAttributes implicitNamespace:defaultNS 
    anAttributes do:[:a | 
        self
            space;
            nextPutAttribute:a implicitNamespace:defaultNS
    ]

    "Created: / 09-04-2007 / 11:20:13 / janfrog"
!

nextPutCloseElement

    stream nextPut:$>

    "Created: / 17-04-2005 / 09:37:40 / janfrog"
!

nextPutComment:aString

    self
        nextPutAll:'<!!-- ';
        nextPutAll:aString;
        nextPutAll:' -->'.

    "Created: / 17-04-2005 / 13:37:41 / janfrog"
!

nextPutElementPrefix:prefix localName:localName

    prefix isNilOrEmptyCollection ifTrue:[
        self
            nextPutAll:localName
    ] ifFalse: [
        self 
            nextPutAll:prefix;
            nextPut:$:;
            nextPutAll:localName
    ]

    "Created: / 18-10-2005 / 10:50:19 / janfrog"
!

nextPutOpenElement

    stream nextPut:$<

    "Created: / 17-04-2005 / 09:37:32 / janfrog"
!

nextPutPI:target data:data

    stream
        nextPut:$<;
        nextPut:$?; 
        nextPutAll:target;
        space;
        nextPutAll:data;
        nextPut:$?; 
        nextPut:$>

    "Created: / 17-04-2005 / 09:36:14 / janfrog"
    "Modified: / 15-06-2005 / 19:56:48 / janfrog"
!

nextPutXMLDecl

    self nextPutPI:'xml' data:'version="1.0" encoding="'
        , stream encoder nameOfEncoding 
            , '"'

    "Created: / 17-04-2005 / 09:34:41 / janfrog"
    "Modified: / 15-06-2005 / 11:03:58 / janfrog"
!

space
    stream space

    "Created: / 16-04-2005 / 22:19:46 / janfrog"
! !

!OldXMLWriter::ContentHandler class methodsFor:'documentation'!

version
    ^'$Id$'
! !

!OldXMLWriter::ContentHandler methodsFor:'SAX2 interface'!

characters:aString

    writer
        indent;
        nextPutAll:aString withoutSeparators;
        cr.

    "Created: / 17-04-2005 / 09:08:07 / janfrog"
!

comment:string

    writer
        indent;
        nextPutComment:string;
        cr

    "Created: / 17-04-2005 / 13:36:58 / janfrog"
!

endElement:localName namespace:namespace prefix:prefix 
    writer
        decIndent;
        indent;
        nextPutOpenElement;
        nextPut:$/;
        nextPutElementPrefix:prefix localName:localName;
        nextPutCloseElement;
        cr

    "Created: / 22-04-2005 / 21:41:16 / janfrog"
    "Modified: / 18-10-2005 / 10:50:52 / janfrog"
!

processingInstruction:target data:data

    writer
        indent;
        nextPutPI:target data:data;
        cr

    "Created: / 17-04-2005 / 13:36:38 / janfrog"
!

startDocument

    writer
        nextPutXMLDecl;
        cr.

    "Created: / 17-04-2005 / 09:33:58 / janfrog"
!

startElement:localName namespace:namespace prefix:prefix attributes:anAttributes 
    writer
        indent;
        nextPutOpenElement;
        nextPutElementPrefix:prefix localName:localName;
        nextPutAttributes:anAttributes implicitNamespace:namespace;
        nextPutCloseElement;
        cr;
        incIndent.

    "/nextPutAll:'  <!!-- ns:',namespace,' -->'

    "Created: / 22-04-2005 / 21:40:32 / janfrog"
    "Modified: / 09-04-2007 / 11:20:13 / janfrog"
! !

!OldXMLWriter::ContentHandler methodsFor:'accessing'!

writer
    ^ writer

    "Created: / 16-04-2005 / 20:37:10 / janfrog"
!

writer:something
    writer := something.

    "Created: / 16-04-2005 / 20:37:10 / janfrog"
! !

!OldXMLWriter class methodsFor:'documentation'!

version
    ^ '$Id$'
!

version_SVN
    ^ '$Id$'
! !

