"{ Namespace: 'CodingExamples' }"

Object subclass:#Philosopher
	 instanceVariableNames:'rand name leftChopStick rightChopStick'
	 classVariableNames:''
	 poolDictionaries:''
	 category:'examples-Processes'!

Philosopher comment:'
This example shows a WRONG implementation of the philosopher:

the philosopher will grap the chopsticks one by one thus
there is a possibility of producing a deadlock eventually ...

Notice: currently, a deadlock cannot happen if preemtive scheduling
is turned off (since no process switch will ocuur between the 2 fetch-
chopstick opertions). However, you may try to run this with timeslicing
(see goodies/timeslice) turned on and see what happens ...
'!

!Philosopher class methodsFor:'instance creation'!

new
    ^ self basicNew initialize
! !

!Philosopher methodsFor:'setup'!

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

!Philosopher methodsFor:'actions'!

takeLeftChopStick
    leftChopStick wait
!

takeRightChopStick
    rightChopStick wait
!

takeChopSticks
    self takeLeftChopStick.
    self takeRightChopStick
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
