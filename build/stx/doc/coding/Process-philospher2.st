"{ Namespace: 'CodingExamples' }"

Object subclass:#Philosopher2
	 instanceVariableNames:'rand name leftChopStick rightChopStick'
	 classVariableNames:'FetchLock'
	 poolDictionaries:''
	 category:'examples-Processes'!

Philosopher2 comment:'
This example shows a CORRECT implementation of the philosopher:
both chopsticks are fetched in a block which is protected by a semaphore.
'!

!Philosopher2 class methodsFor:'instance creation'!

new
    FetchLock isNil ifTrue:[
	FetchLock := Semaphore forMutualExclusion
    ].
    ^ self basicNew initialize
! !

!Philosopher2 methodsFor:'setup'!

initialize
    rand := Random new
!

name:aString
    name := aString
!

leftChopStick:chopStick1 rightChopStick:chopStick2
    leftChopStick := chopStick1.
    rightChopStick := chopStick2.
! !

!Philosopher2 methodsFor:'actions'!

takeLeftChopStick
    leftChopStick wait
!

takeRightChopStick
    rightChopStick wait
!

takeChopSticks
    FetchLock critical:[
	self takeLeftChopStick.
	self takeRightChopStick
    ]
!

dropChopSticks
    leftChopStick signal.
    rightChopStick signal
!

eat
    Transcript showCR:(name , ' eating').
    "eat for a while"
    (Delay forSeconds:(rand nextBetween:1 and:5) asInteger) wait
!

think
    Transcript showCR:(name , ' thinking').
    "think for a while"
    (Delay forSeconds:(rand nextBetween:1 and:5) asInteger) wait
!

life
    "the life of a philosopher ..."

    1 to:10 do:[:round |
	self takeChopSticks.
	self eat.
	self dropChopSticks.
	self think
    ]
! !
