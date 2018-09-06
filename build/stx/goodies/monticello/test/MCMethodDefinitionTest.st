"{ Package: 'stx:goodies/monticello/test' }"

MCTestCase subclass:#MCMethodDefinitionTest
	instanceVariableNames:'navigation isModified'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Tests'
!


!MCMethodDefinitionTest methodsFor:'mocks'!

override ^ 1
! !

!MCMethodDefinitionTest methodsFor:'running'!

ownPackage
	^ MCWorkingCopy forPackage: (MCPackage named: 'Monticello')
!

setUp
	navigation _ (Smalltalk hasClassNamed: #SystemNavigation)
		ifTrue: [(Smalltalk at: #SystemNavigation) new]
		ifFalse: [Smalltalk].
	isModified _ self ownPackage modified.
!

tearDown
	self restoreMocks.
	(MCWorkingCopy forPackage: (MCPackage named: 'FooBarBaz')) unregister.
	self class compile: 'override ^ 1' classified: 'mocks'.
	self ownPackage modified: isModified
! !

!MCMethodDefinitionTest methodsFor:'testing'!

testCannotLoad
	| definition |
	definition _ self mockMethod: #kjahs87 class: 'NoSuchClass' source: 'kjahs87 ^self' meta: false.
	self should: [definition load] raise: Error.
	self assert: (navigation allImplementorsOf: #kjahs87) isEmpty
!

testComparison
	|d1 d2 d3 d4 d5 |
	d1 _ self mockMethod: #one class: 'A' source: '1' meta: false.
	d2 _ self mockMethod: #one class: 'A' source: '2' meta: false.
	d3 _ self mockMethod: #one class: 'A' source: '1' meta: true.
	d4 _ self mockMethod: #two class: 'A' source: '1' meta: false.
	d5 _ self mockMethod: #two class: 'A' source: '1' meta: false.
	
	self assert: (d1 isRevisionOf: d2).
	self deny: (d1 isSameRevisionAs: d2).
	
	self deny: (d1 isRevisionOf: d3).
	self deny: (d1 isRevisionOf: d4).
	
	self assert: (d4 isSameRevisionAs: d5).
!

testLoadAndUnload
	|definition|
	definition _ self mockMethod: #one class: 'MCMockClassA' source: 'one ^2' meta: false.
	self assert: self mockInstanceA one = 1.
	definition load.
	self assert: self mockInstanceA one = 2.
	definition unload.
	self deny: (self mockInstanceA respondsTo: #one)
!

testPartiallyRevertOverrideMethod
	| definition |
	self class compile: 'override ^ 2' classified: '*foobarbaz'.
	self class compile: 'override ^ 3' classified: self mockOverrideMethodCategory.
	self class compile: 'override ^ 4' classified: self mockOverrideMethodCategory.
	definition _ (MethodReference class: self class selector: #override) asMethodDefinition.
	self assert: definition isOverrideMethod.
	self assert: self override = 4.
	definition unload.
	self assert: self override = 2.
	self assert: (MethodReference class: self class selector: #override) category = '*foobarbaz'.
	
!

testRevertOldMethod
	| definition changeRecord |
	Object compile: 'yourself ^ self' classified: MCMockPackageInfo new methodCategoryPrefix.
	definition _ (MethodReference class: Object selector: #yourself) asMethodDefinition.
	changeRecord _ definition scanForPreviousVersion.
	self assert: changeRecord notNil.
	self assert: changeRecord category = 'accessing'.
	changeRecord fileIn.
!

testRevertOverrideMethod
	| definition |
	self class compile: 'override ^ 2' classified: self mockOverrideMethodCategory.
	definition _ (MethodReference class: self class selector: #override) asMethodDefinition.
	self assert: definition isOverrideMethod.
	self assert: self override = 2.
	definition unload.
	self assert: self override = 1.
	self assert: (MethodReference class: self class selector: #override) category = 'mocks'.
	
! !

!MCMethodDefinitionTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/test/MCMethodDefinitionTest.st,v 1.2 2013-05-29 00:00:53 vrany Exp $'
! !

