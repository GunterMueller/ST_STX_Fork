"{ Package: 'stx:libdb/nosql/mongoDB' }"

Object subclass:#CollectionValidation
	instanceVariableNames:'values'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-Mongo-Core'
!


!CollectionValidation class methodsFor:'instance creation'!

on: aDictionary 
	^self new setValues: aDictionary
! !

!CollectionValidation methodsFor:'private'!

setValues: aDictionary 
	values := aDictionary
! !

!CollectionValidation methodsFor:'testing'!

isOK
	^(values at: 'ok') = 1.0
! !

!CollectionValidation class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/mongoDB/CollectionValidation.st,v 1.1 2013-04-04 21:04:18 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/mongoDB/CollectionValidation.st,v 1.1 2013-04-04 21:04:18 cg Exp $'
! !

