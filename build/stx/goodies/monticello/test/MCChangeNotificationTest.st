"{ Package: 'stx:goodies/monticello/test' }"

MCTestCase subclass:#MCChangeNotificationTest
	instanceVariableNames:'workingCopy'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Tests'
!


!MCChangeNotificationTest methodsFor:'events'!

modifiedEventFor: aSelector ofClass: aClass
	| method |
	method := aClass compiledMethodAt: aSelector.
	^ ModifiedEvent 
				methodChangedFrom: method
				to: method
				selector: aSelector
				inClass: aClass.
! !

!MCChangeNotificationTest methodsFor:'private'!

foreignMethod
	"see testForeignMethodModified"
! !

!MCChangeNotificationTest methodsFor:'running'!

setUp
	workingCopy _ MCWorkingCopy forPackage: self mockPackage.
	
!

tearDown
	workingCopy unregister
! !

!MCChangeNotificationTest methodsFor:'tests'!

testCoreMethodModified
	| event |
	workingCopy modified: false.
	event := self modifiedEventFor: #one ofClass: self mockClassA.
	MCWorkingCopy methodModified: event.
	self assert: workingCopy modified
!

testExtMethodModified
	| event mref |
	workingCopy modified: false.
	mref := workingCopy packageInfo extensionMethods first.
	event := self modifiedEventFor: mref methodSymbol ofClass: mref actualClass.
	MCWorkingCopy methodModified: event.
	self assert: workingCopy modified
!

testForeignMethodModified
	| event |
	workingCopy modified: false.
	event := self modifiedEventFor: #foreignMethod ofClass: self class.
	MCWorkingCopy methodModified: event.
	self deny: workingCopy modified
! !

!MCChangeNotificationTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/test/MCChangeNotificationTest.st,v 1.2 2013-05-29 00:02:05 vrany Exp $'
! !

