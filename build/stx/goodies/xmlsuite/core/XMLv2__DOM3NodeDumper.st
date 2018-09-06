"{ Package: 'stx:goodies/xmlsuite/core' }"

"{ NameSpace: XMLv2 }"

Object subclass:#DOM3NodeDumper
	instanceVariableNames:'stream indent'
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-XML Writer'
!


!DOM3NodeDumper class methodsFor:'instance creation'!

new
    ^ self basicNew initialize.

    "Created: / 05-08-2005 / 13:16:17 / janfrog"
!

on:aStream

    ^self new stream:aStream

    "Created: / 05-08-2005 / 13:16:58 / janfrog"
! !

!DOM3NodeDumper class methodsFor:'utilities'!

dump:aDocument

    ^self new dump:aDocument

    "Created: / 05-08-2005 / 13:26:44 / janfrog"
! !

!DOM3NodeDumper methodsFor:'accessing'!

stream:something
    stream := something.

    "Created: / 05-08-2005 / 13:16:44 / janfrog"
! !

!DOM3NodeDumper methodsFor:'initialization'!

initialize

    indent := 0.
    stream := Transcript.

    "Created: / 05-08-2005 / 13:16:17 / janfrog"
! !

!DOM3NodeDumper methodsFor:'streaming'!

nextPut:aString

    stream 
        next:indent put:(Character space);
        nextPut:aString;
        cr.

    "Created: / 05-08-2005 / 13:24:07 / janfrog"
! !

!DOM3NodeDumper methodsFor:'utilities'!

dump:aDocument

    aDocument acceptVisitor:self

    "Created: / 05-08-2005 / 13:26:26 / janfrog"
! !

!DOM3NodeDumper methodsFor:'visiting'!

visitAttr:anAttr

    self nextPut:'ATTR ', anAttr nodeName , ' NS ' , anAttr namespaceURI.
    indent := indent + 2.
    anAttr childNodes do:[:node|
        node acceptVisitor:self
    ].
    indent := indent - 2.

    "Created: / 05-08-2005 / 13:38:57 / janfrog"
!

visitComment:aComment

    self nextPut:'COMMENT ' , aComment data

    "Created: / 05-08-2005 / 14:21:34 / janfrog"
!

visitDocument:aDocument
    indent := 0.
    aDocument childNodes do:[:node|
        node acceptVisitor:self
    ]

    "Created: / 05-08-2005 / 13:17:15 / janfrog"
!

visitElement:anElement

    self nextPut:'ELEMENT ', anElement nodeName , ' NS ' , anElement namespaceURI.
    indent := indent + 2.
    anElement attributes do:[:attr|
        attr acceptVisitor:self
    ].
    anElement childNodes do:[:node|
        node acceptVisitor:self
    ].
    indent := indent - 2.

    "Created: / 05-08-2005 / 13:20:15 / janfrog"
!

visitProcessingInstruction:aProcessingInstruction

    self nextPut:'PROCESSING INSTRUCTION ' , 
                    aProcessingInstruction target ,
                        ' DATA ' ,
                            aProcessingInstruction data

    "Created: / 05-08-2005 / 14:21:10 / janfrog"
!

visitText:aText

    self nextPut:'TEXT ' , aText data.

    "Created: / 05-08-2005 / 13:26:01 / janfrog"
! !

!DOM3NodeDumper class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/XMLv2__DOM3NodeDumper.st,v 1.1.1.1 2005-11-01 22:05:43 vranyj1 Exp $'
!

version_SVN
    ^ '$Id$'
! !
