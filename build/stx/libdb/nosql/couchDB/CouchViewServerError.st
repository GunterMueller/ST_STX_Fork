"{ Package: 'stx:libdb/nosql/couchDB' }"

Error subclass:#CouchViewServerError
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-CouchDB-Viewserver'
!


!CouchViewServerError methodsFor:'as yet unclassified'!

jsonWriteOn: stream

	stream nextPutAll: '{"error": "', self class name ,'", "reason": "', self messageText ,'"}'
! !

!CouchViewServerError class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/couchDB/CouchViewServerError.st,v 1.1 2013-04-04 14:37:37 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/couchDB/CouchViewServerError.st,v 1.1 2013-04-04 14:37:37 cg Exp $'
! !

