"{ Package: 'stx:libdb/nosql/mongoDB' }"

BSONError subclass:#BSONUndefindedType
	instanceVariableNames:'code'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-Mongo-BSON'
!


!BSONUndefindedType class methodsFor:'as yet unclassified'!

signalCode: aNumber
	^self new 
		code: aNumber;
		signal
! !

!BSONUndefindedType methodsFor:'accessing'!

code
	^code
!

code: aNumber
	code := aNumber
!

messageText 
	^'Undefined type ', self code asString
! !

!BSONUndefindedType class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/mongoDB/BSONUndefindedType.st,v 1.1 2013-04-04 21:53:37 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/mongoDB/BSONUndefindedType.st,v 1.1 2013-04-04 21:53:37 cg Exp $'
! !

