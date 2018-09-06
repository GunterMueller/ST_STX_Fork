"{ Package: 'stx:goodies/sunit' }"

"{ NameSpace: Smalltalk }"

TestResource subclass:#ExampleTestResource
	instanceVariableNames:'runningState'
	classVariableNames:''
	poolDictionaries:''
	category:'SUnit-Tests'
!


!ExampleTestResource class methodsFor:'testing'!

isAvailable

	^super isAvailable and: [self current isStarted]
! !

!ExampleTestResource methodsFor:'accessing'!

runningState

	^runningState
!

runningState: aSymbol

	runningState := aSymbol
! !

!ExampleTestResource methodsFor:'constants'!

startedStateSymbol

	^#started
!

stoppedStateSymbol

	^#stopped
! !

!ExampleTestResource methodsFor:'running'!

setUp

	self runningState: self startedStateSymbol
!

tearDown

	self runningState: self stoppedStateSymbol
! !

!ExampleTestResource methodsFor:'testing'!

isAvailable

	^self runningState == self startedStateSymbol
!

isStarted

	^self runningState == self startedStateSymbol
!

isStopped

	^self runningState == self stoppedStateSymbol
! !

!ExampleTestResource class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/sunit/ExampleTestResource.st,v 1.3 2011-06-29 19:15:49 cg Exp $'
!

version_SVN
    ^ '§Id: ExampleTestResource.st 182 2009-12-05 18:12:17Z vranyj1 §'
! !

