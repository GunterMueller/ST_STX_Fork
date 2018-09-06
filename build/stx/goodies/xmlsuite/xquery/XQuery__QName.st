"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

Object subclass:#QName
	instanceVariableNames:'prefix namespaceURI localName'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Types'
!


!QName class methodsFor:'instance creation'!

withPrefix: prefix withLocalName: lName
    ^ self new
        localName: lName;
        prefix: prefix;
        yourself.

    "Created: / 03-10-2009 / 12:50:38 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 06-10-2009 / 12:35:54 / Jan Kurs <kursj1@fel.cvut.cz>"
!

withQNameString: qNameString
    | idx prefix localName |
    idx := qNameString lastIndexOf: $: .
    idx isZero 
        ifFalse:
            [prefix := qNameString copyTo: idx - 1. 
            localName := qNameString copyFrom: idx + 1]
        ifTrue:
            [localName := qNameString].

    ^self withPrefix: prefix withLocalName: localName.

    "Created: / 03-10-2009 / 12:47:56 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 03-10-2009 / 14:27:18 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!QName methodsFor:'accessing'!

localName
    ^ localName

    "Created: / 06-10-2009 / 12:33:30 / Jan Kurs <kursj1@fel.cvut.cz>"
!

localName:something
    self assert: (self isNCName: something).
    localName := something.

    "Created: / 06-10-2009 / 12:33:37 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 06-10-2009 / 14:47:24 / Jan Kurs <kursj1@fel.cvut.cz>"
!

name
    self error: 'deprecated'.
    ^ localName

    "Modified: / 06-10-2009 / 12:33:48 / Jan Kurs <kursj1@fel.cvut.cz>"
!

name:something
    self error: 'deprecated'.
    localName := something.

    "Modified: / 06-10-2009 / 12:33:55 / Jan Kurs <kursj1@fel.cvut.cz>"
!

namespaceURI
    namespaceURI ifNil:
    [
        namespaceURI := ''.
    ].

    ^ namespaceURI.

    "Modified: / 04-10-2009 / 16:58:58 / Jan Kurs <kursj1@fel.cvut.cz>"
!

namespaceURI:something
    namespaceURI := something.
!

prefix
    prefix ifNil:
    [
        ^ ''.
    ].
    ^ prefix.

    "Modified: / 03-10-2009 / 18:16:25 / Jan Kurs <kursj1@fel.cvut.cz>"
!

prefix:something
    prefix := something.
!

qName
    self prefix ifEmpty: [
        ^ self localName.
    ]
    ifNotEmpty:[
        ^ self prefix, ':', self localName
    ].

    "Created: / 03-10-2009 / 14:34:35 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 06-10-2009 / 12:49:27 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!QName methodsFor:'comparing'!

= qName
    (qName class = self class) ifFalse: [ ^ false ].

    ^ qName localName = self localName and: [
        qName namespaceURI = self namespaceURI ].

    "Created: / 06-10-2009 / 12:34:31 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!QName methodsFor:'converting'!

asString
    ^ self qName.

    "Created: / 03-10-2009 / 18:14:21 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!QName methodsFor:'printing'!

printOn:aStream 
    self qName printOn:aStream.

    "Created: / 04-10-2009 / 12:33:53 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!QName methodsFor:'queries'!

hasPrefix
    ^ self prefix notEmpty

    "Created: / 06-10-2009 / 11:48:48 / Jan Kurs <kursj1@fel.cvut.cz>"
!

isNCName: name
    "TEST if the nodeName is valid NCName - I don't have any tool for 
        regex matcing :o("

"/    ('[A-Za-z_][A-Za-z]*' matchRegex: aNodeName) ifTrue:
    (name includesString: ' ') ifTrue:
    [
        XQueryInterpreterError raiseErrorString: 'Node name: "', name, '" is not valid NCName'.
    ].
    ^ true.

    "Created: / 06-10-2009 / 14:47:47 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!QName class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
