"{ Package: 'stx:libdb/nosql/mongoDB' }"

MongoCollection subclass:#MongoMetaCollection
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-Mongo-Core'
!


!MongoMetaCollection class methodsFor:'instance creation'!

name: aString
	^self database: nil name: aString
! !

!MongoMetaCollection class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/mongoDB/MongoMetaCollection.st,v 1.1 2013-04-04 20:59:55 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/mongoDB/MongoMetaCollection.st,v 1.1 2013-04-04 20:59:55 cg Exp $'
! !

