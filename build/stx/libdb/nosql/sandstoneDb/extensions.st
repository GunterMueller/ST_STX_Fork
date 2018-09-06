"{ Package: 'stx:libdb/nosql/sandstoneDb' }"!

!ArrayedCollection methodsFor:'*sandstonedb-serialization'!

sandstoneDeepCopyVisits: visitedParts 
	"sandstoneDeepCopy works just like deepCopy until it hits another active record
	at which point the copying stops, and the actual references is returned."
	| newObject |
	visitedParts at: self ifPresent: [ :it | ^ it ].
	newObject := self copy.
	visitedParts at: self put: newObject.
	"optimized implementation taking advantaged of ordering"
	newObject doWithIndex: 
		[ :each :index | 
		each isSandstoneActiveRecord ifFalse: 
			[ newObject 
				at: index
				put: (each sandstoneDeepCopyVisits: visitedParts) ] ].
	^ newObject
! !

!ArrayedCollection methodsFor:'*sandstonedb-serialization'!

sandstoneMarkReferencesVisits: visitedParts 
	"Mark components of the introspectee which are 
	Sandstone active records to become references.
	Do this deeply (sub components)."
	self class isMeta ifTrue: [ ^ self ].
	visitedParts at: self ifPresent: [:it | ^ self ].
	visitedParts at: self put: self.
	self doWithIndex: 
		[ :each :index | 
		each isSandstoneActiveRecord 
			ifTrue: [ self at: index put: each asReferenceMarker ]
			ifFalse: [ each sandstoneMarkReferencesVisits: visitedParts ] ].
	^ self
! !

!ArrayedCollection methodsFor:'*sandstonedb-serialization'!

sandstoneResolveReferencesVisits: visitedParts 
	"Make components of the introspectee which are 
	Sandstone references to active record to become active records.
	Do this deeply (sub components)."
	self class isMeta ifTrue: [ ^ self ].
	visitedParts at: self ifPresent: [ :it | ^ it ].
	visitedParts at: self put: self.
	"It is crucial to modify the introspectee by iterating a copy of it"
	self copy doWithIndex: 
		[ :each :index | 
		each isSandstoneMarker 
			ifTrue: [ self at: index put: each asOriginalObject ]
			ifFalse: [ each sandstoneResolveReferencesVisits: visitedParts ] ].
	^ self
! !

!Boolean methodsFor:'*sandstonedb'!

sandstoneDeepCopyVisits: visitedParts
	^ self
! !

!Boolean methodsFor:'*sandstonedb'!

sandstoneMarkReferencesVisits: visitedParts
	^ self
! !

!Boolean methodsFor:'*sandstonedb'!

sandstoneResolveReferencesVisits: visitedParts 
	^ self
! !

!Character methodsFor:'*sandstonedb'!

sandstoneDeepCopyVisits: visitedParts
	^ self
! !

!Character methodsFor:'*sandstonedb'!

sandstoneMarkReferencesVisits: visitedParts
	^ self
! !

!Character methodsFor:'*sandstonedb'!

sandstoneResolveReferencesVisits: visitedParts 
	^ self
! !

!Class methodsFor:'*SandstoneDb'!

sandstoneDeepCopyVisits: aCollection 
	SDCommitError signal: 'An ActiveRecord can not reference a class or another object that references a class. '
! !

!Complex methodsFor:'*SandstoneDbSqueak'!

sandstoneDeepCopy
	^ self
! !

!Complex methodsFor:'*SandstoneDbSqueak'!

sandstoneDeepCopyVisits: visitedParts
	^ self
! !

!Complex methodsFor:'*SandstoneDbSqueak'!

sandstoneMarkReferencesVisits: visitedParts
	^ self
! !

!Complex methodsFor:'*SandstoneDbSqueak'!

sandstoneResolveReferencesVisits: visitedParts 
	^ self
! !

!DataStream class methodsFor:'*sandstonedb'!

fileNamed: aName do: aBlock 
	| file |
	file := self fileNamed: aName.
	^ file 
		ifNil: [ nil ]
		ifNotNil: [ [ aBlock value: file ] ensure: [ file close ] ]
! !

!DataStream class methodsFor:'*sandstonedb'!

newFileNamed: aName do: aBlock 
	| file |
	file := self newFileNamed: aName.
	^ file 
		ifNil: [ nil ]
		ifNotNil: [ [ aBlock value: file ] ensure: [ file close ] ]
! !

!DataStream class methodsFor:'*sandstonedb'!

oldFileNamed: aName do: aBlock 
	| file |
	file := self oldFileNamed: aName.
	^ file 
		ifNil: [ nil ]
		ifNotNil: [ [ aBlock value: file ] ensure: [ file close ] ]
! !

!DataStream class methodsFor:'*sandstonedb'!

readOnlyFileNamed: aString
	| strm |
	strm := self on: (FileStream readOnlyFileNamed: aString).
	strm byteStream setFileTypeToObject.
	^ strm
! !

!DataStream class methodsFor:'*sandstonedb'!

readOnlyFileNamed: aName do: aBlock 
	| file |
	file := self readOnlyFileNamed: aName.
	^ file 
		ifNil: [ nil ]
		ifNotNil: [ [ aBlock value: file ] ensure: [ file close ] ]
! !

!Dictionary methodsFor:'*sandstonedb'!

sandstoneResolveReferencesVisits: visitedParts
	super sandstoneResolveReferencesVisits: visitedParts.
	self rehash.
	^ self
! !

!FileDirectory methodsFor:'*sandstonedb'!

sandstoneRename: oldFileName toBe: newFileName
	| oldName newName |
	"a non interactive version of rename that won't promp the UI on failure"
	oldName := self fullNameFor: oldFileName.
	newName := self fullNameFor: newFileName.
	(StandardFileStream 
		retryWithGC:[self primRename: oldName asVmPathName to: newName asVmPathName]
		until:[:result| result notNil]
		forFileNamed: oldName) ~~ nil ifTrue:[^self].
	(self fileExists: oldFileName) ifFalse:[
		^self error:'Attempt to rename a non-existent file'.
	].
	^self error:'Failed to rename file'.
! !

!FileDirectory methodsFor:'*sandstonedb'!

withSubdirectoriesDo: aBlock 
	self directoryNames do: [ :n | aBlock value: (self directoryNamed: n) ]
! !

!InstructionStream methodsFor:'*sandstonedb-serialization'!

sandstoneDeepCopyVisits: visitedParts 
	SDCommitError signal: 'An ActiveRecord can not reference any sub instances of instruction stream.  Make sure you are not saving blocks. '
! !

!Integer methodsFor:'*sandstonedb'!

asReducedSumOfDigits
	"Answers the sum of the digits present in the 
	decimal representation of the receiver 
	but also repeating the procedure if the 
	answers is greater than 9."
	^ 10 <= self 
		ifFalse: [ self ]
		ifTrue: 
			[ self = 10 
				ifTrue: [ 0 ]
				ifFalse: 
					[ (self asString 
						inject: 0
						into: [ :sum :e | sum + e digitValue ]) asReducedSumOfDigits ] ]
! !

!Number methodsFor:'*sandstonedb'!

sandstoneDeepCopyVisits: visitedParts
	^ self
! !

!Number methodsFor:'*sandstonedb'!

sandstoneMarkReferencesVisits: visitedParts
	^ self
! !

!Number methodsFor:'*sandstonedb'!

sandstoneResolveReferencesVisits: visitedParts 
	^ self
! !

!Object methodsFor:'*sandstonedb-testing'!

isSandstoneActiveRecord
	"Answers true if the receiver is
	a Sandstone Active Record."

	^ false
! !

!Object methodsFor:'*sandstonedb-testing'!

isSandstoneMarker
	^ false
! !

!Object methodsFor:'*sandstonedb-serialization'!

sandstoneDeepCopyVisits: visitedParts 
	"sandstoneDeepCopy works just like deepCopy until it hits another active record
	at which point the copying stops, and the actual references is returned."
	| newObject class index value |
	visitedParts at: self ifPresent: [ :it | ^ it ].
	class := self class.
	class isVariable 
		ifTrue: 
			[ index := self basicSize.
			newObject := class basicNew: index.
			[ index > 0 ] whileTrue: 
				[ newObject 
					basicAt: index
					put: ((self basicAt: index) sandstoneDeepCopyVisits: visitedParts).
				index := index - 1 ] ]
		ifFalse: [ newObject := class basicNew ].
	visitedParts at: self put: newObject.
	index := class instSize.
	[ index > 0 ] whileTrue: 
		[ value := self instVarAt: index.
		newObject 
			instVarAt: index
			put: (value isSandstoneActiveRecord 
					ifTrue: [ value ]
					ifFalse: [ value sandstoneDeepCopyVisits: visitedParts ]).
		index := index - 1 ].
	^ newObject
! !

!Object methodsFor:'*sandstonedb-serialization'!

sandstoneMarkReferencesVisits: visitedParts 
	"Mark components of the introspectee which are 
	Sandstone active records to become references.
	Do this deeply (sub components)."
	self class isMeta ifTrue: [ ^ self ].
	visitedParts at: self ifPresent: [:it | ^ it ].
	visitedParts at: self put: self.
	self class allInstVarNames do: 
		[ :name | 
		| var |
		var := self instVarNamed: name.
		var isSandstoneActiveRecord 
			ifTrue: 
				[ self 
					instVarNamed: name
					put: var asReferenceMarker ]
			ifFalse: [ var sandstoneMarkReferencesVisits: visitedParts ] ].
	^ self
! !

!Object methodsFor:'*sandstonedb-serialization'!

sandstoneResolveReferencesVisits: visitedParts 
	"Mark components of the introspectee which are 
	Sandstone references to active record to become active records.
	Do this deeply (sub components)."
	self class isMeta ifTrue: [ ^ self ].
	visitedParts at: self ifPresent: [:it | ^ it ].
	visitedParts at: self put: self.
	self class allInstVarNames do: 
		[ :name | 
		| var |
		var := self instVarNamed: name.
		(var isSandstoneMarker) 
			ifTrue: 
				[ self 
					instVarNamed: name
					put: var asOriginalObject ]
			ifFalse: [ var sandstoneResolveReferencesVisits: visitedParts ] ].
	^ self
! !

!Semaphore methodsFor:'*SandstoneDb'!

sandstoneDeepCopyVisits: aCollection 
	SDCommitError signal: 'An ActiveRecord can not reference a semaphore or another object that references a semaphor. '
! !

!Set methodsFor:'*sandstonedb'!

sandstoneResolveReferencesVisits: visitedParts
	super sandstoneResolveReferencesVisits: visitedParts.
	self rehash.
	^ self
! !

!SmartRefStream methodsFor:'*sandstonedb'!

sandstoneNextAndClose
	"Speedy way to grab one object. Only use when we are inside an object
	binary file.I created my own version of nextAndClose to get rid of the 
	interactive stuff the real one tries to do.  If I fail, then I fail, so be it"
	| obj |
	byteStream peek = ReferenceStream versionCode ifFalse: [ SDLoadError signal: 'old object file' ].
	obj := self next.
	self close.
	^ obj
! !

!SmartRefStream methodsFor:'*sandstonedb'!

sandstoneNextPutObjOnly: anObject 
	"Really write three objects: (version, class structure, object).  But only when called from the outside.  Not in fileOut format.  No class definitions will be written for instance-specific classes.  Error if find one.  (Use nextPut: instead)"
	| info |
	topCall 
		ifNil: 
			[ topCall := anObject.
			super nextPut: ReferenceStream versionCode.
			info := self instVarInfo: anObject.
			objCount := 0.
			super nextPut: info.
			super nextPut: anObject.	"<- the real writing"
			"Class inst vars not written here!!"
			topCall := nil
			"references is an IDict of every object that got written
			(in case you want to take statistics)"
			"Transcript cr; show: structures keys printString."	"debug"	"reset it" ]
		ifNotNil: [ super nextPut: anObject ]
! !

!String methodsFor:'*sandstonedb-serialization'!

sandstoneDeepCopyVisits: visitedParts
	^ self shallowCopy
! !

!String methodsFor:'*sandstonedb-serialization'!

sandstoneMarkReferencesVisits: visitedParts
	^ self
! !

!String methodsFor:'*sandstonedb-serialization'!

sandstoneResolveReferencesVisits: visitedParts 
	^ self
! !

!UndefinedObject methodsFor:'*sandstonedb'!

sandstoneDeepCopyVisits: visitedParts
	^ self
! !

!UndefinedObject methodsFor:'*sandstonedb'!

sandstoneMarkReferencesVisits: visitedParts
	^ self
! !

!UndefinedObject methodsFor:'*sandstonedb'!

sandstoneResolveReferencesVisits: visitedParts 
	^ self
! !

!stx_libdb_nosql_sandstoneDb class methodsFor:'documentation'!

extensionsVersion_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/sandstoneDb/extensions.st,v 1.4 2013-04-17 23:18:47 cg Exp $'
! !
