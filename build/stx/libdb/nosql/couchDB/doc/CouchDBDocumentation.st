"{ Package: 'stx:libdb/nosql/couchDB/doc' }"

Object subclass:#CouchDBDocumentation
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-CouchDB-Documentation'
!


!CouchDBDocumentation class methodsFor:'as yet unclassified'!

usingDatastructureApi
" Storing Dictionary structures "
" Create database "
| db document generatedId specifiedId retrievedDocument |
db := CouchDB createOn: 'localhost' name: 'mydatabase'.

" Document/datastructure to be saved "
document := Dictionary new.
document at: 'name' put: 'Johnny'.

" Save the document, get back a generated id "
generatedId := db createDocument: document.

" Save the document, specifying an id of your own. specifiedId will be 12345"
specifiedId := db createDocument: document id: 12345.

" Now read the document, change it and save it "
retrievedDocument := db readDocument: specifiedId.
retrievedDocument at: 'name' put: 'Annie'.
db updateDocument: retrievedDocument id: specifiedId.

" If a key _id exists in the document (like al read documents would), we will overwrite that document."

retrievedDocument := db readDocument: specifiedId.
retrievedDocument at: 'name' put: 'Susan'.
db updateDocument: retrievedDocument. "Doc at specifiedId should now have Susan as value "

!

usingObjectApi
" The same mechanism as usingDatastructureApi applies, the only change is that the objectType is specified as part of the creation/opening of the database "

" The object you use has to respond to 3 rules: "
" - it has to respond to #fromCouchDBDocument: on class side, It would receive a Dictionary-like datastructure as argument "
" - it has to respond to #asCouchDBDocument on instance side, It must return a Dictionary-like datastructure "
" - it has to handle the _id and _rev properties, by saving them and exposing them in the above two methods "

| db object generatedId specifiedId retrievedObject |
db := CouchDB createOn: 'localhost' name: 'mydatabase' ofType: CouchDBTestObject.

" Object to be saved "
object := CouchDBTestObject new.
object name: 'Johnny'.

" Save the object, get back a generated id "
generatedId := db createDocument: object.

" Save the document, specifying an id of your own. specifiedId will be 12345 "
specifiedId := db createDocument: object id: 12345.

" Now read the object, change it and save it "
retrievedObject := db readDocument: specifiedId.
retrievedObject name: 'Annie'.
db updateDocument: retrievedObject.

! !

!CouchDBDocumentation class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/couchDB/doc/CouchDBDocumentation.st,v 1.1 2013-04-04 14:39:34 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/couchDB/doc/CouchDBDocumentation.st,v 1.1 2013-04-04 14:39:34 cg Exp $'
! !

