"{ Package: 'stx:libdb/libopenDBX/driver' }"

DBXEncodingStrategy subclass:#DBXStaticEncoding
	instanceVariableNames:'encoder'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-OpenDBXDriver-Encoding'
!


!DBXStaticEncoding class methodsFor:'as yet unclassified'!

newForEncoding: nameOfEncoding
	|o|
	o := self basicNew.
	o encoder: (TextConverter newForEncoding: nameOfEncoding).
	^o.
! !

!DBXStaticEncoding methodsFor:'as yet unclassified'!

encoder: aTextConverter 
	encoder := aTextConverter.
!

encoderFor: anObject
	^encoder copy.
! !

!DBXStaticEncoding class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/DBXStaticEncoding.st,v 1.2 2013-04-15 13:11:31 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/DBXStaticEncoding.st,v 1.2 2013-04-15 13:11:31 cg Exp $'
! !

