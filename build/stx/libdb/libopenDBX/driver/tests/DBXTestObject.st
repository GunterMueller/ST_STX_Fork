"{ Package: 'stx:libdb/libopenDBX/driver/tests' }"

Object subclass:#DBXTestObject
	instanceVariableNames:'encoding'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-OpenDBXDriverTests-Encoding'
!


!DBXTestObject methodsFor:'as yet unclassified'!

encoding: encodingName
	encoding := encodingName.
!

queryEncoding
	^encoding
! !

!DBXTestObject class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/tests/DBXTestObject.st,v 1.2 2013-04-15 13:18:39 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/tests/DBXTestObject.st,v 1.2 2013-04-15 13:18:39 cg Exp $'
! !

