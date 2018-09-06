"{ NameSpace: CodingExamples }"

Process subclass:#FunnyProcessExample
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'examples-Processes'
!


!FunnyProcessExample methodsFor:'examples'!

start
    "I am a very funny kind of process thingy
     (at least for smalltalkers) ...
     ... in that I represent a process without a block,
     but instead, the processes code is this start-method.

     This is the Java way of dealing with processes
     (those poor guys have no blocks ;-)
     and therefore must create subclasses of Thread for
     each, which gets some startup message.

     You can do the same in Smalltalk - but only for
     demonstration purpose - its a step backward"

    Transcript showCR:'here is a funny process ...'.
    Delay waitForSeconds:3.
    Transcript showCR:'... that was a stupid process'.

    "
     FunnyProcessExample new resume
    "

    "Modified: 25.1.1997 / 01:53:33 / cg"
! !

!FunnyProcessExample class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/doc/coding/Process-funny.st,v 1.2 1997-01-25 00:54:00 cg Exp $'
! !
