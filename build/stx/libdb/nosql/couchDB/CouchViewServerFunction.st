"{ Package: 'stx:libdb/nosql/couchDB' }"

Object subclass:#CouchViewServerFunction
	instanceVariableNames:'emits server'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-CouchDB-Viewserver'
!


!CouchViewServerFunction class methodsFor:'as yet unclassified'!

server: aServer
	^self new server: aServer; yourself
! !

!CouchViewServerFunction methodsFor:'as yet unclassified'!

emitKey: key value: val

	emits ifNil: [emits := OrderedCollection new].
	emits add: (Array with: key with: val)
!

emits
	| result |
	result := emits.
	emits := nil.
	^result ifNil: [Array new]
!

error: aString

	CouchViewServerFunctionError signal: aString
!

log: object

	server log: object
!

server: aServer

	server := aServer
! !

!CouchViewServerFunction class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/couchDB/CouchViewServerFunction.st,v 1.1 2013-04-04 14:38:04 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/couchDB/CouchViewServerFunction.st,v 1.1 2013-04-04 14:38:04 cg Exp $'
! !

