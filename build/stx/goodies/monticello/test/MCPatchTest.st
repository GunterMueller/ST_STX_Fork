"{ Package: 'stx:goodies/monticello/test' }"

MCTestCase subclass:#MCPatchTest
	instanceVariableNames:'patch'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Tests'
!


!MCPatchTest methodsFor:'as yet unclassified'!

setUp
	|rev1 rev2|
	rev1 _  MCSnapshotResource takeSnapshot.
	self change: #one toReturn: 2.
	rev2 _  MCSnapshotResource takeSnapshot.
	patch _ rev2 patchRelativeToBase: rev1.
	self change: #one toReturn: 1.
!

tearDown
	self restoreMocks
!

testPatchContents
	self assert: patch operations size = 1.
	self assert: patch operations first isModification.
	self assert: patch operations first definition selector = #one.
! !

!MCPatchTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/test/MCPatchTest.st,v 1.2 2013-05-29 00:01:43 vrany Exp $'
! !

