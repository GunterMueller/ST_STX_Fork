"{ Package: 'stx:libdb/libopenDBX/driver' }"

DBXEncodingStrategy subclass:#DBXNoEncoding
	instanceVariableNames:''
	classVariableNames:'Instance'
	poolDictionaries:''
	category:'DataBase-OpenDBXDriver-Encoding'
!


!DBXNoEncoding class methodsFor:'as yet unclassified'!

instance
	^Instance ifNil: [Instance := self new].
! !

!DBXNoEncoding methodsFor:'as yet unclassified'!

encoderFor: anObject 
	^DBXNullTextConverter instance.
! !

!DBXNoEncoding class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/DBXNoEncoding.st,v 1.2 2013-04-15 13:11:41 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/DBXNoEncoding.st,v 1.2 2013-04-15 13:11:41 cg Exp $'
! !

