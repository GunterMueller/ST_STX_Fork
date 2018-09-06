"{ Package: 'stx:libdb/nosql/couchDB' }"!

!Dictionary methodsFor:'*couchdb'!

removeKeyIfValueNilOrEmptyString: aKey
	| value |
	(self includesKey: aKey) ifTrue: [
		value := self at: aKey.
		(value = nil)
			ifTrue: [ self removeKey: aKey]
			ifFalse: [
				(value withBlanksTrimmed = '') ifTrue: [ self removeKey: aKey.].
			].
	].

! !

!Object methodsFor:'*couchdb'!

asJsonString
	^String streamContents: [:s |
		self jsonWriteOn: s]
! !

!stx_libdb_nosql_couchDB class methodsFor:'documentation'!

extensionsVersion_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/couchDB/extensions.st,v 1.2 2013-04-04 14:37:29 cg Exp $'
! !
