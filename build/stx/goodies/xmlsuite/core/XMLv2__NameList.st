"{ Package: 'stx:goodies/xmlsuite/core' }"

"{ NameSpace: XMLv2 }"

OrderedCollection subclass:#NameList
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-DOM3'
!


!NameList methodsFor:'DOM3 interface'!

contains: aString
    "Warning: #contains override"

    ^(self
        detect: [:e | e key = aString]
        ifNone: [nil])
            notNil
!

contains: nameString ns: nsString
    "Warning: #contains override"

    ^(self
        detect: [:e | e key = nameString and: [e value = nsString]]
        ifNone: [nil])
            notNil
!

getName: anInteger

    | assoc |
    assoc := self at: anInteger ifAbsent: [nil].
    ^assoc ifNotNil: [^assoc key]
!

getNamespaceURI: anInteger

    | assoc |
    assoc := self at: anInteger ifAbsent: [nil].
    ^assoc ifNotNil: [^assoc value]
!

length

    ^self size
! !

!NameList class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/XMLv2__NameList.st,v 1.1.1.1 2005-11-01 22:05:52 vranyj1 Exp $'
!

version_SVN
    ^ '$Id$'
! !
