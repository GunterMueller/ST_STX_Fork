"{ Package: 'stx:libdb/libopenDBX/driver' }"

DBXEncodingStrategy subclass:#DBXAutomaticEncoding
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-OpenDBXDriver-Encoding'
!


!DBXAutomaticEncoding methodsFor:'as yet unclassified'!

encoderFor: aConnection 
	| encoding |
	encoding := aConnection queryEncoding.
	^TextConverter newForEncoding: encoding.
! !

!DBXAutomaticEncoding class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/DBXAutomaticEncoding.st,v 1.2 2013-04-15 13:10:11 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/DBXAutomaticEncoding.st,v 1.2 2013-04-15 13:10:11 cg Exp $'
! !

