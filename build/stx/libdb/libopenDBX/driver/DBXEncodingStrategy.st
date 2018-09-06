"{ Package: 'stx:libdb/libopenDBX/driver' }"

Object subclass:#DBXEncodingStrategy
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-OpenDBXDriver-Encoding'
!


!DBXEncodingStrategy methodsFor:'as yet unclassified'!

encoderFor: anObject
	"I will return instance of TextConverter to convert data related to given object.
	The method of deciding how to encode the data depends on the implementation."
	self subclassResponsibility.
!

encodingFor: anObject
	"I will return instance of TextConverter to convert data related to given object.
	The method of deciding how to encode the data depends on the implementation."
	self subclassResponsibility.
! !

!DBXEncodingStrategy class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/DBXEncodingStrategy.st,v 1.2 2013-04-15 13:11:32 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/DBXEncodingStrategy.st,v 1.2 2013-04-15 13:11:32 cg Exp $'
! !

