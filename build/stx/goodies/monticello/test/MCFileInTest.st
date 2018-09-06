"{ Package: 'stx:goodies/monticello/test' }"

MCTestCase subclass:#MCFileInTest
	instanceVariableNames:'stream expected diff'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Tests'
!


!MCFileInTest methodsFor:'asserting'!

assertNoChange
	| actual |
	actual _ MCSnapshotResource takeSnapshot.
	diff _ actual patchRelativeToBase: expected.
	self assert: diff isEmpty
! !

!MCFileInTest methodsFor:'running'!

setUp
        expected _ self mockSnapshot.
        Smalltalk isSmalltalkX ifTrue:[
            stream _ (ReadWriteStream on: String new) binary.
        ] ifFalse:[
            stream _ RWBinaryOrTextStream on: String new.
        ].
!

tearDown
	(diff isNil or: [diff isEmpty not])
		 ifTrue: [expected updatePackage: self mockPackage]
! !

!MCFileInTest methodsFor:'testing'!

alterInitialState
	self mockClassA touchCVar
!

assertFileOutFrom: writerClass canBeFiledInWith: aBlock
        (writerClass on: stream) writeSnapshot: self mockSnapshot.
        self alterInitialState.
        self assertSuccessfulLoadWith: aBlock.
        self mockPackage unload.
        self assertSuccessfulLoadWith: aBlock.

    "Modified: / 29-05-2013 / 00:55:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

assertInitializersCalled
	| cvar |
	cvar _ self mockClassA cVar.
	self assert: cvar = #initialized
!

assertSuccessfulLoadWith: aBlock
        stream reset.
        aBlock value.
        self assertNoChange.
        self assertInitializersCalled.

    "Modified: / 29-05-2013 / 00:55:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testStWriter
        self
                assertFileOutFrom: MCStWriter
                canBeFiledInWith: [stream fileIn].

    "Modified: / 29-05-2013 / 00:55:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MCFileInTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/test/MCFileInTest.st,v 1.3 2013-05-28 23:59:40 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/test/MCFileInTest.st,v 1.3 2013-05-28 23:59:40 vrany Exp $'
! !

