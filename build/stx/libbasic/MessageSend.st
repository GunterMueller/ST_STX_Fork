"{ Encoding: utf8 }"

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
"{ Package: 'stx:libbasic' }"

"{ NameSpace: Smalltalk }"

Message subclass:#MessageSend
	instanceVariableNames:'receiver'
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Methods'
!

!MessageSend class methodsFor:'documentation'!

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
    Instances of MessageSend can be used for simulation programs.
    They keep some receiver, selector and arguments and can be evaluated
    at any time later. (basically, they are like MessageObjects, but keep
    the receiver in addition to the selector & arguments).

    They can also be used as replacement for simple [self foo]-blocks.
    Of course, they could also be replaced by blocks such as
    '[receiver perform:selector withArguments:arguments]', 
    but blocks are somewhat more expensive in their creation and require
    more storage.

    If you plan to write a simulator and want to queue cillions of blocks,
    try to use MessageSends instead of blocks
    (or even: message, if the receiver is constant);
    this will save you a lot of memory.

    However, the send-operation itself is faster in a block, since it
    will use a better caching scheme (inline-cache) for its send, while
    sending here is done with a #perform:, which is not inline-cached. 
    Also, blocks are more flexible, in that they allow access to local
    variables of the defining method - and work without a need to define an
    extra visited method (read literature on visitor patterns).

    Thus it is not sure, which one is actually better to use ...

    You can either store arguments in the messageSend object, or
    leave them undefined until the send is actually performed, and
    pass any arguments with the value:-messages.

    [See also:]
        Block  Message

    [author:]
        Claus Gittinger
"
!

examples
"
    Example:
       |m|

       m := MessageSend receiver:1 selector:#+ arguments:#(2).
       m value. 



    is almost the same as:
       |m|

       m := [1+2].
       m value. 



    Example2 (a simulation)
        |q|

        q := Queue new.
        ...
        'put some action into the queue'
        q nextPut:(MessageSend receiver:someone selector:#foo arguments:#().
        ...
        'evaluate next action from the queue'
        q next value
        ...

    if all sends are going to the same receiver, use:
        |q|

        q := Queue new.
        ...
        'put some action into the queue'
        q nextPut:(Message selector:#foo arguments:#().
        ...
        'evaluate next action from the queue'
        q next sendTo:someone
        ...
"
! !

!MessageSend class methodsFor:'instance creation'!

receiver:r selector:sel
    "create & return a new instance which can be used to
     send sel to some receiver, r"

    ^ self receiver:r selector:sel arguments:nil

    "
     (MessageSend receiver:nil selector:#foo) value
    "

    "Modified: 20.3.1997 / 21:55:16 / cg"
!

receiver:r selector:sel argument:something
    "create & return a new instance which can be used to
     send sel with arguments to some receiver, r"

    ^ self receiver:r selector:sel arguments:(Array with:something)

    "
     (MessageSend receiver:nil selector:#foo: argument:1) value
    "
!

receiver:r selector:sel arguments:argArray
    "create & return a new instance which can be used to
     send sel with arguments to some receiver, r"

    |newMessage|

    newMessage := super new setSelector:sel arguments:argArray.
    newMessage receiver:r.
    ^ newMessage

    "
     (MessageSend receiver:nil selector:#foo: arguments:#(1)) value
    "

    "Modified: 20.3.1997 / 21:55:44 / cg"
! !

!MessageSend methodsFor:'Compatibility-Squeak'!

cull: optionalFirstArg 
    "activate the receiver with one or zero arguments.
     Squeak compatibility, but also present in VW Smalltalk"

    selector numArgs >= 1 ifTrue:[^ self value:optionalFirstArg].
    ^ self value

    "Modified: / 03-06-2014 / 12:40:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

cull: optionalFirstArg cull: optionalSecondArg
    "activate the receiver with two or less arguments.
     Squeak compatibility, but also present in VW Smalltalk"

    | nargs |

    nargs := selector numArgs.
    nargs >= 2 ifTrue:[^ self value:optionalFirstArg value:optionalSecondArg].
    nargs = 1 ifTrue:[^ self value:optionalFirstArg].
    ^ self value

    "Modified (format): / 03-06-2014 / 12:40:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

cull: firstArg cull: optionalSecondArg cull: optionalThirdArg
    "activate the receiver with three or less arguments.
     Squeak compatibility, but also present in VW Smalltalk"

    | nargs |

    nargs := selector numArgs.
    nargs >= 2 ifTrue:[
        nargs >= 3 ifTrue:[
            ^ self value:firstArg value:optionalSecondArg value:optionalThirdArg
        ].
        ^ self value:firstArg value:optionalSecondArg
    ].
    nargs = 1 ifTrue:[^ self value:firstArg].
    ^ self value

    "Modified: / 03-06-2014 / 12:40:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MessageSend methodsFor:'Compatibility-V''Age'!

evaluate
    ^ self value

    "Created: / 22-12-2010 / 12:59:25 / cg"
!

evaluateWith:someArgument
    ^ self value:someArgument

    "Created: / 22-12-2010 / 13:50:33 / cg"
!

evaluateWithArguments:argArray
    ^ self valueWithArguments:argArray

    "Created: / 22-12-2010 / 12:59:42 / cg"
! !

!MessageSend methodsFor:'accessing'!

argumentCount
    "VisualAge/ANSI compatibility: return the number of arguments of the message"

    ^ selector argumentCount

    "Modified: 23.4.1996 / 16:52:51 / cg"
!

numArgs
    "return the number of arguments of the message"

    ^ selector numArgs

    "Modified: 23.4.1996 / 16:52:51 / cg"
!

receiver
    "return the receiver of the message"

    ^ receiver

    "Modified: 23.4.1996 / 16:52:59 / cg"
!

receiver:r
    "set the receiver of the message"

    receiver := r

    "Modified: 23.4.1996 / 16:53:04 / cg"
! !

!MessageSend methodsFor:'evaluation'!

value
    "evaluate the messagesend with the original arguments"

    ^ receiver perform:selector withArguments:args
!

value:someArgument
    "evaluate the messagesend, with someArgument instead of the original"

    ^ receiver perform:selector withOptionalArgument:someArgument

    "Modified: / 14-09-2010 / 16:04:39 / cg"
!

value:arg1 value:arg2
    "evaluate the messagesend, with arg1 and arg2 instead of the original
     arguments"

    ^ receiver perform:selector withOptionalArgument:arg1 and:arg2

    "Modified: / 14-09-2010 / 16:04:58 / cg"
!

value:arg1 value:arg2 value:arg3
    "evaluate the messagesend, with arg1, arg2 and arg3 instead of the original
     arguments"

    ^ receiver perform:selector with:arg1 with:arg2 with:arg3
!

valueWithArguments:argArray
    "evaluate the messagesend, with arguments taken from argArray,
     instead of the original arguments"

    ^ receiver perform:selector withArguments:argArray
!

valueWithOptionalArgument:arg
    "evaluate the messagesend.
     Optionally pass an argument (if the selector is for a one arg message)."

    ^ receiver perform:selector withOptionalArgument:arg
!

valueWithOptionalArgument:arg1 and:arg2
    "evaluate the messagesend.
     Optionally pass up to two arguments."

    ^ receiver perform:selector withOptionalArgument:arg1 and:arg2
! !

!MessageSend methodsFor:'printing & storing'!

displayOn:aGCOrStream
    "Compatibility
     append a printed desription on some stream (Dolphin,  Squeak)
     OR:
     display the receiver in a graphicsContext at 0@0 (ST80).
     This method allows for any object to be displayed in some view
     (although the fallBack is to display its printString ...)"

    "/ what a kludge - Dolphin and Squeak mean: printOn: a stream;
    "/ ST/X (and some old ST80's) mean: draw-yourself on a GC.
    aGCOrStream isStream ifFalse:[
        ^ super displayOn:aGCOrStream.
    ].

    aGCOrStream 
        nextPutAll:self class name;
        nextPut:$(.
    receiver displayOn:aGCOrStream. 
    aGCOrStream nextPutAll:'>>'.
    selector storeOn:aGCOrStream. 
    aGCOrStream nextPut:$)
!

printOn:aStream
    "append a user printed representation of the receiver to aStream.
     The format is suitable for a human - not meant to be read back."

    receiver printOn:aStream.
    aStream nextPutAll:'>>'.
    selector printOn:aStream

    "Modified: 23.4.1996 / 16:53:35 / cg"
! !

!MessageSend class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/MessageSend.st,v 1.26 2015-03-27 11:21:29 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic/MessageSend.st,v 1.26 2015-03-27 11:21:29 cg Exp $'
! !

