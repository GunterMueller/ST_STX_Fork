"{ Package: 'stx:libdb/nosql/mongoDB/stx' }"!

!Float methodsFor:'*Mongo-BSON'!

bsonTypeCode
	^1
! !

!Float methodsFor:'*Mongo'!

writeBSONOn: aBSON 
	aBSON nextDoublePut: self
! !

!Timestamp methodsFor:'As yet unclassified'!

bsonTypeCode
	^9
! !

!Timestamp methodsFor:'*Mongo'!

writeBSONOn: aBSON 
	aBSON nextTimestampPut: self
! !

!stx_libdb_nosql_mongoDB_stx class methodsFor:'documentation'!

extensionsVersion_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/mongoDB/stx/extensions.st,v 1.4 2013-04-04 22:39:46 cg Exp $'
! !
