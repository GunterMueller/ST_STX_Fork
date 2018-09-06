"{ Package: 'stx:goodies/monticello/test' }"

MCTestCase subclass:#MCInitializationTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Tests'
!


!MCInitializationTest class methodsFor:'as yet unclassified'!

isAbstract
        ^ (Smalltalk classNamed: #MczInstaller) isNil

    "Modified: / 16-11-2006 / 16:43:53 / cg"
! !

!MCInitializationTest methodsFor:'as yet unclassified'!

tearDown
	(MCWorkingCopy forPackage: self mockPackage) unregister
!

testWorkingCopy
	MczInstaller storeVersionInfo: self mockVersion.
	MCWorkingCopy initialize.
	MCWorkingCopy allManagers
						detect: [:man | man package name = self mockPackage name]
						ifNone: [self assert: false]
! !

!MCInitializationTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/test/MCInitializationTest.st,v 1.2 2013-05-29 00:01:07 vrany Exp $'
! !

