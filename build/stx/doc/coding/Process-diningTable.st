"{ Namespace: 'CodingExamples' }"

Object subclass:#DiningTable
	 instanceVariableNames:'chopSticks philosophers'
	 classVariableNames:''
	 poolDictionaries:''
	 category:'examples-Processes'!

DiningTable comment:'
a table with dining philosophers around.
a table with n philosophers is created with:
    DiningTable new:n

dinner starts with:
    <aDiningTable> dinner
'!

!DiningTable class methodsFor:'instance creation'!

new:numberOfPhilosophers
    ^ self basicNew initializeFor:numberOfPhilosophers

    "(DiningTable new:5) dinner"
! !

!DiningTable methodsFor:'setup'!

initializeFor:numberOfPhilosophers
    "create chopsticks"

    chopSticks := Array new:numberOfPhilosophers.
    1 to:numberOfPhilosophers do:[:index |
	chopSticks at:index put:(Semaphore new:1)
    ].

    philosophers := Array new:numberOfPhilosophers.
    1 to:numberOfPhilosophers do:[:index |
	|p|

	p := Philosopher new.
	p name:('philosopher ' , index printString).
	p leftChopStick:(chopSticks at:index)
	  rightChopStick:(chopSticks at:(index \\ numberOfPhilosophers) + 1).
	philosophers at:index put:p
    ]
! !

!DiningTable methodsFor:'dinner'!

startPhilosopher:p
    [
	p life
    ] fork
!

dinner
    "start philosophers lifes ..."

    philosophers do:[:p |
	self startPhilosopher:p
    ].
! !
