"
 COPYRIGHT (c) 1994 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"

OrderedCollection subclass:#HandlerCollection
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Exceptions'
!

!HandlerCollection class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1994 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

documentation
"
    A HandlerCollection allows a group of unrelated signals to be handled
    by individual handlers - their evaluation is equivalent to a corresponding
    number of nested signal handlers, but somwehat easier to program.
    In the real world, handlerCollections are seldom needed and actually currently
    not used by the system.
"
! !

!HandlerCollection methodsFor:'adding'!

on:aSignal handle:aHandler
    "add a signal<->handler pair to the receiver collection"

    self addFirst:(aSignal -> aHandler)
! !

!HandlerCollection methodsFor:'private'!

from:start to:stop handleDo:aBlock
    "this method recursively sets up a bunch of nested
     handlers, and finally evaluates the argument, aBlock"

    |signalHandlerPair|

    stop < start ifTrue:[
	^ aBlock value
    ].
    signalHandlerPair := self at:start.
    ^ (signalHandlerPair key) 
	  handle:(signalHandlerPair value)
	  do:[self from:start+1 to:stop handleDo:aBlock]
! !

!HandlerCollection methodsFor:'save evaluation'!

handleDo:aBlock
    "evaluate the argument, aBlock.
     If any of the signals in the receiver is raised during evaluation,
     evaluate the corresponding handleBlock from the receiver,
     passing it an Exception argument.
     The handler may decide how to react to the signal by sending
     a corresponding message to the exception (see there).
     If none of the signals is raised during evaluation, return the 
     value returned by aBlock."

     ^ self from:1 to:self size handleDo:aBlock

    "
     |h num|

     h := HandlerCollection new.
     h on:(Number divisionByZeroSignal)
       handle:[:ex | 'division by zero' printNL. ex proceed].

     h on:(Object haltSignal)
       handle:[:ex | 'halt encountered ' printNL. ex proceed].

     h on:(Float domainErrorSignal)
       handle:[:ex | 'domain error  ' printNL. ex proceed].

     h handleDo:[
	num := 0.

	'now dividing' printNL.
	1 // num.

	'now doing bad arcSin' printNL.
	num := 50.
	num arcSin.

	'now halting' printNL.
	self halt.
     ]
    "
! !

!HandlerCollection class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic2/HandlerCollection.st,v 1.5 1999-07-28 21:00:09 cg Exp $'
! !
