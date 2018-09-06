"{ Package: 'stx:goodies/monticello/test' }"

MCTestCase subclass:#MCSnapshotTest
	instanceVariableNames:'snapshot'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Tests'
!


!MCSnapshotTest methodsFor:'running'!

setUp
	snapshot _  self mockSnapshot.
! !

!MCSnapshotTest methodsFor:'tests'!

testCreation
	|d|
	d _  self mockSnapshot definitions.
	self assert: (d anySatisfy: [:ea | ea isClassDefinition and: [ea className = #MCMockClassA]]).
	self assert: (d anySatisfy: [:ea | ea isMethodDefinition and: [ea selector = #mockClassExtension]]).
	self assert: (d allSatisfy: [:ea | ea isClassDefinition not or: [ea category endsWith: 'Mocks']]).
	
!

testInstanceReuse
	| x m n y |
	x _ (MCPackage new name: self mockCategoryName) snapshot.
	Smalltalk garbageCollect.
	n _ MCDefinition allSubInstances size.
	y _ (MCPackage new name: self mockCategoryName) snapshot.
	Smalltalk garbageCollect.
	m _ MCDefinition allSubInstances size.
	self assert: m = n
! !

!MCSnapshotTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/test/MCSnapshotTest.st,v 1.2 2013-05-29 00:01:35 vrany Exp $'
! !

