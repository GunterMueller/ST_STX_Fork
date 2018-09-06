"{ Package: 'stx:libdb/nosql/sandstoneDb/tests' }"

SDActiveRecordTests subclass:#SDFileStoreTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-SandstoneDb-Tests'
!


!SDFileStoreTests class methodsFor:'testing'!

isAbstract
	^ false
! !

!SDFileStoreTests methodsFor:'defaults'!

defaultStore
	^ SDFileStore new
! !

!SDFileStoreTests methodsFor:'running'!

testDeleteFailedCommits
	kid save.
	(store
		dirForClass: kid class
		atId: kid id)
		copyFileNamed: kid id , '.obj'
		toFileNamed: kid id , '.obj.new'.
	self assert: ((store
			dirForClass: kid class
			atId: kid id) fileExists: kid id , '.obj').
	self assert: ((store
			dirForClass: kid class
			atId: kid id) fileExists: kid id , '.obj.new').
	store deleteFailedCommitsForClass: kid class.
	self assert: ((store
			dirForClass: kid class
			atId: kid id) fileExists: kid id , '.obj').
	self deny: ((store
			dirForClass: kid class
			atId: kid id) fileExists: kid id , '.obj.new')
!

testDeleteOldVersions
	| id |
	kid save.
	kid save.
	id := kid id.
	kid delete.
	self assert: ((store
			dirForClass: kid class
			atId: id) fileNamesMatching: id , '.*') isEmpty
!

testFinishPartialCommits
	kid save.
	(store
		dirForClass: kid class
		atId: kid id)
		rename: kid id , '.obj'
		toBe: kid id , '.obj.new'.
	self deny: ((store
			dirForClass: kid class
			atId: kid id) fileExists: kid id , '.obj').
	self assert: ((store
			dirForClass: kid class
			atId: kid id) fileExists: kid id , '.obj.new').
	store finishPartialCommitsForClass: kid class.
	self assert: ((store
			dirForClass: kid class
			atId: kid id) fileExists: kid id , '.obj').
	self deny: ((store
			dirForClass: kid class
			atId: kid id) fileExists: kid id , '.obj.new')
!

testLoadMissingFile
	kid save.
	(store
		dirForClass: kid class
		atId: kid id) deleteFileNamed: kid id , '.obj'.
	self
		should:
			[ store
				loadClass: kid class
				atId: kid id ]
		raise: SDLoadError
!

testLoadTime
	| commitTime people lookupTime loadTime |
	people := (1 to: 25) collect: [ :it | self personClass testPerson ].
	commitTime := [ people do: [ :each | each save ] ] timeToRun milliSeconds.
	lookupTime := [ people do: [ :each | self personClass atId: each id ] ] timeToRun milliSeconds.
	loadTime := [
	SDActiveRecord resetStoreForLoad.
	SDPersonMock
		withAllSubclassesDo: [ :each | SDActiveRecord store ensureForClass: each ];
		withAllSubclassesDo: [ :each | each warmUp ].
	SDActiveRecord store ensureForClass: SDFooObject.
	SDFooObject warmUp ] timeToRun milliSeconds.
	Transcript
		show: commitTime;
		cr;
		show: loadTime;
		cr;
		show: lookupTime;
		cr;
		cr.
	self assert: commitTime < 1 seconds
!

testSaveMissingFile
	self assert: kid isNew.
	kid save.
	self deny: kid isNew.
	(store
		dirForClass: kid class
		atId: kid id) deleteFileNamed: kid id , '.obj'.
	kid save.
	self deny: kid isNew
!

testStorageDir
	"Active records id's must find a proper subdirectory entry in the defined structure"
	| ids legalNames |
	legalNames := (0 to: 9) collect: [ :e | e asString ].
	ids := Set new: 1000.
	1000 timesRepeat: [ ids add: UUID new asString36 ].
	ids add: 'abaoblwgnaydxokccorveamoq'.
	ids do:
		[ :anId |
		self assert: (legalNames includes: (store
					dirForClass: self personClass
					atId: anId) localName) ]
! !

!SDFileStoreTests class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/sandstoneDb/tests/SDFileStoreTests.st,v 1.4 2013-04-17 23:47:36 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/sandstoneDb/tests/SDFileStoreTests.st,v 1.4 2013-04-17 23:47:36 cg Exp $'
! !

