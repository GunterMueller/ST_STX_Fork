"{ Package: 'stx:goodies/monticello/test' }"

MCTestCase subclass:#MCPackageTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Tests'
!


!MCPackageTest methodsFor:'running'!

tearDown
	self mockSnapshot install
! !

!MCPackageTest methodsFor:'tests'!

testUnload
	| mock |
	self mockPackage unload.
	self deny: (Smalltalk hasClassNamed: #MCMockClassA).
	self deny: (MCSnapshotTest includesSelector: #mockClassExtension).

	mock _ (Smalltalk at: #MCMock).
	self assert: (mock subclasses detect: [:c | c name = #MCMockClassA] ifNone: []) isNil
! !

!MCPackageTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/test/MCPackageTest.st,v 1.2 2013-05-28 23:59:48 vrany Exp $'
! !

