"{ Package: 'stx:goodies/sunit' }"

"{ NameSpace: Smalltalk }"

TestResource subclass:#SimpleTestResource
	instanceVariableNames:'runningState hasRun hasSetup'
	classVariableNames:''
	poolDictionaries:''
	category:'SUnit-Tests'
!

SimpleTestResource class instanceVariableNames:'preventAvailability'

"
 The following class instance variables are inherited by this class:

	TestResource - current
	TestAsserter - 
	Object - 
"
!


!SimpleTestResource class methodsFor:'accessing'!

allowAvailability
	^preventAvailability isNil
!

rawCurrentForTest
	^current
! !

!SimpleTestResource class methodsFor:'utility'!

preventAvailabilityDuring: aBlock
	"Only setter of preventAvailability."

	preventAvailability := false.
	^aBlock ensure: [preventAvailability := nil]
! !

!SimpleTestResource methodsFor:'accessing'!

runningState

	^runningState
!

runningState: aSymbol

	runningState := aSymbol
! !

!SimpleTestResource methodsFor:'running'!

setRun
	hasRun := true
!

setUp

	self runningState: self startedStateSymbol.
	hasSetup := true
!

startedStateSymbol

	^#started
!

stoppedStateSymbol

	^#stopped
!

tearDown

	self runningState: self stoppedStateSymbol
! !

!SimpleTestResource methodsFor:'testing'!

hasRun
	^hasRun
!

hasSetup
	^hasSetup
!

isAvailable
	^self class allowAvailability and:
		[self runningState == self startedStateSymbol]
! !

!SimpleTestResource class methodsFor:'documentation'!

version_SVN
    ^ '§Id: SimpleTestResource.st 214 2011-03-14 12:22:21Z vranyj1 §'
! !

