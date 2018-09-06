"{ Package: 'stx:goodies/monticello/test' }"

MCTestCase subclass:#MCRepositoryTest
	instanceVariableNames:'repository ancestors'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Tests'
!


!MCRepositoryTest class methodsFor:'as yet unclassified'!

isAbstract
        ^ self = MCRepositoryTest
! !

!MCRepositoryTest methodsFor:'accessing'!

snapshotAt: aVersionInfo
	^ (repository versionWithInfo: aVersionInfo) snapshot
! !

!MCRepositoryTest methodsFor:'actions'!

addVersion: aVersion
	self subclassResponsibility 
!

addVersionWithSnapshot: aSnapshot name: aString
	| version |
	version _ self versionWithSnapshot: aSnapshot name: aString.
	self addVersion: version.
	^ version info
!

saveSnapshot1
	^ self saveSnapshot: self snapshot1 named: 'rev1'
!

saveSnapshot2
	^ self saveSnapshot: self snapshot2 named: 'rev2'
!

saveSnapshot: aSnapshot named: aString
	| version |
	version _ self versionWithSnapshot: aSnapshot name: aString.
	repository storeVersion: version.
	^ version info
	
! !

!MCRepositoryTest methodsFor:'asserting'!

assertMissing: aVersionInfo
	self assert: (repository versionWithInfo: aVersionInfo) isNil
!

assertVersionInfos: aCollection
	self assert: repository allVersionInfos asSet = aCollection asSet
! !

!MCRepositoryTest methodsFor:'building'!

snapshot1
	^ (MCSnapshot fromDefinitions: (Array with: (MCOrganizationDefinition categories: #('y'))))
!

snapshot2
	^ (MCSnapshot fromDefinitions: (Array with: (MCOrganizationDefinition categories: #('x'))))
!

versionWithSnapshot: aSnapshot name: aString
	| info |
	info _ self mockVersionInfo: aString. 
	^ MCVersion 
		package: (MCPackage new name: aString)
		info: info
		snapshot: aSnapshot
! !

!MCRepositoryTest methodsFor:'tests'!

testAddAndLoad
	| node |
	node _ self addVersionWithSnapshot: self snapshot1 name: 'rev1'.
	self assert: (self snapshotAt: node) = self snapshot1.
!

testIncludesName
	self deny: (repository includesVersionNamed: 'MonticelloTest-xxx.1-rev1').
	self saveSnapshot1.
	self assert: (repository includesVersionNamed: 'MonticelloTest-xxx.1-rev1').
	self deny: (repository includesVersionNamed: 'MonticelloTest-xxx.1-rev2').
	self saveSnapshot2.
	self assert:  (repository includesVersionNamed: 'MonticelloTest-xxx.1-rev2').
!

testLoadMissingNode
	| node |
	node _ MCVersionInfo new.
	self assertMissing: node
!

testStoreAndLoad
	| node node2 |
	node _ self saveSnapshot1.
	node2 _ self saveSnapshot2.
	self assert: (self snapshotAt: node) = self snapshot1.
	self assert: (self snapshotAt: node2) = self snapshot2.
! !

!MCRepositoryTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/test/MCRepositoryTest.st,v 1.3 2013-05-29 00:02:12 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/test/MCRepositoryTest.st,v 1.3 2013-05-29 00:02:12 vrany Exp $'
! !

