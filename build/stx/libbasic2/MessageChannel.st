"
 COPYRIGHT (c) 1995 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"

"{ Package: 'stx:libbasic2' }"

MessageSend subclass:#MessageChannel
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Methods'
!

!MessageChannel class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1995 by Claus Gittinger
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
    MessageChannel provides the same functionality as MessageSend.
    It has been provided for ST-80 compatibility.

    Like with MessageSend, instances of MessageChannel can be used for 
    simulation programs.
    They keep some receiver and selector and can be evaluated at any time later.
    (think of them as a cheaper alternative to blocks).

    In contrast to MessageSend, MessageChannels expect arguments to be passed
    if all sends are going to the same receiver, use:

    example:
	|q|

	q := Queue new:120.
	1 to:100 do:[:i |
	    q nextPut:(MessageChannel receiver:i selector:#+).
	].
	[q notEmpty] whileTrue:[
	    |m|

	    m := q next.
	    (m value:1) printNL.
	].
"
! !

!MessageChannel class methodsFor:'instance creation'!

receiver:r selector:sel
    ^ super receiver:r selector:sel arguments:nil
! !

!MessageChannel methodsFor:'evaluation'!

value
    "evaluate the messagesend with the original arguments"

    ^ receiver perform:selector
! !

!MessageChannel class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic2/MessageChannel.st,v 1.5 2003-08-29 19:21:23 cg Exp $'
! !
