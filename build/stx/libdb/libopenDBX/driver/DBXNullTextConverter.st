"{ Package: 'stx:libdb/libopenDBX/driver' }"

TextConverter subclass:#DBXNullTextConverter
	instanceVariableNames:''
	classVariableNames:'Instance'
	poolDictionaries:''
	category:'DataBase-OpenDBXDriver-Encoding'
!


!DBXNullTextConverter class methodsFor:'as yet unclassified'!

instance
	^Instance ifNil:[Instance:=DBXNullTextConverter basicNew].
! !

!DBXNullTextConverter methodsFor:'as yet unclassified'!

convertFromSystemString: aString
	^aString.
!

convertToSystemString: aString
	^aString.
!

nextFromStream: aStream
	^aStream next.
!

nextPut: aChar toStream: aStream
	aStream nextPut: aChar.
! !

!DBXNullTextConverter class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/DBXNullTextConverter.st,v 1.2 2013-04-15 13:11:05 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/DBXNullTextConverter.st,v 1.2 2013-04-15 13:11:05 cg Exp $'
! !

