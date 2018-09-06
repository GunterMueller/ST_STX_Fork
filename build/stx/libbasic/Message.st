"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 1988 by Claus Gittinger
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

Object subclass:#Message
	instanceVariableNames:'selector args'
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Methods'
!

!Message class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1988 by Claus Gittinger
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
    Instances of Message represent a message being sent, consisting of
    the message selector and the message arguments.

    During normal execution, message objects are NEVER used -
    instead, argument passing is done more performant via the stack
    or in registers (depends on how your C compiler passes arguments).

    However, messageObjects ARE created, when a message send fails 
    (i.e. some message is not understood).
    In this case, the selector and arguments of the failing message
    are squashed into a new instance of Message, and a #doesNotUnderstand: 
    message is sent to the original receiver, passing the message object
    as argument.

    Typically, #doesNotUnderstand: is not redefined in the receiver's class,
    so the lookup finds Object>>doesNotUnderstand: and this is evaluated.
    There, a debugger is opened on the suspended thread (actually, it is a little
    more complicated: actually a MessageNotUnderstood exception is raised there,
    which - if not handled by an exception handler - opens the debugger).

    However, it is possible and common to redefine the doesNotUnderstand method, 
    which allows for re-evaluation of the failed send (after some cleanup),
    to upload some code, to forward the message to another destination,
    or to simply ignore the error.

    As an example of its use, see the implementation of the Autoload-class,
    or how ScrollableView forwards unknown messages to its slave-view.

    Elegance hint: as mentioned above, Object>>doesNotUnderstand: actually
    raises an exception which can be handled. In many situations, providing 
    an exception handler instead of redefining #doesNotUnderstand is the 
    better way to do things.


    Notice:
    The layout of Message-objects is known by the runtime system (VM)
    (it has to create those objects in case of a failure)
    so it is not allowed to change the definition of this class.

    [See also:]
        Signal  Exception  MessageSend

    [author:]
        Claus Gittinger
"
! !

!Message class methodsFor:'instance creation'!

selector:aSymbol
    "return a new message object for a send without arguments"

    ^ self basicNew setSelector:aSymbol arguments:nil
!

selector:aSymbol argument:anArg
    "return a new message object for a send with one argument"

    ^ self basicNew setSelector:aSymbol arguments:(Array with:anArg)
!

selector:aSymbol argument:arg1 argument:arg2
    "return a new message object for a send with two arguments"

    ^ self basicNew setSelector:aSymbol arguments:(Array with:arg1 with:arg2)
!

selector:aSymbol arguments:argArray
    "return a new message object for a send with many arguments"

    ^ self basicNew setSelector:aSymbol arguments:argArray
! !

!Message class methodsFor:'obsolete'!

selector:aSymbol with:anArg
    "return a new message object for a send with one argument.
     OBSOLETE: use #selector:argument: for ST-80 compatibility."

    <resource:#obsolete>

    ^ self basicNew setSelector:aSymbol arguments:(Array with:anArg)
!

selector:aSymbol with:arg1 with:arg2
    "return a new message object for a send with two arguments.
     OBSOLETE: use #selector:arguments: for ST-80 compatibility."

    <resource:#obsolete>

    ^ self basicNew setSelector:aSymbol arguments:(Array with:arg1 with:arg2)
!

selector:aSymbol withAll:argArray
    "return a new message object for a send with many arguments.
     OBSOLETE: use #selector:arguments: for ST-80 compatibilty."

    <resource:#obsolete>

    ^ self basicNew setSelector:aSymbol arguments:argArray
! !

!Message class methodsFor:'queries'!

isBuiltInClass
    "return true if this class is known by the run-time-system.
     Here, true is returned for myself, false for subclasses."

    ^ self == Message

    "Modified: 23.4.1996 / 15:59:30 / cg"
! !

!Message methodsFor:'Compatibility-Dolphin'!

value:aReceiver
    "evaluate myself for receiver.
     Same as #sendTo: - compatibility with Dolphin"

    ^ aReceiver perform:selector withArguments:args
! !

!Message methodsFor:'Compatibility-GNU'!

reinvokeFor:aReceiver
    "send the selector with argument to a receiver.
     Same as sendTo: - for GNU-ST compatibility."

    ^ self sendTo:aReceiver
! !

!Message methodsFor:'Compatibility-Squeak'!

argument
    "return the 1st argument of the message"

    args size == 1 ifFalse:[
        self error:'Not a 1-arg message'
    ].
    ^ args at:1
! !

!Message methodsFor:'accessing'!

arg1
    "return the first argument of the message"

    ^ args at:1
!

argumentCount
    "VisualAge/ANSI compatibility: return the number of arguments of the message"

    ^ args size
!

arguments
    "return the arguments of the message"
    
    args isNil ifTrue:[^ #()].
    ^ args.
!

arguments:argArray
    "set arguments of the receiver"

    args := argArray

    "Created: / 31-05-2007 / 17:53:10 / cg"
!

numArgs
    "return the number of arguments of the message"

    ^ args size
!

selector
    "return the selector of the message"

    ^ selector
!

selector:aSymbol
    selector := aSymbol

    "Created: / 31-05-2007 / 17:53:06 / cg"
! !

!Message methodsFor:'printing & storing'!

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
    selector storeOn:aGCOrStream. 
    aGCOrStream nextPut:$)
!

printOn:aStream
    "append a user printed representation of the receiver to aStream.
     The format is suitable for a human - not meant to be read back."

    selector printOn:aStream
! !

!Message methodsFor:'private-accessing'!

setSelector:aSymbol
    selector := aSymbol.
!

setSelector:aSymbol arguments:argArray
    "set selector and arguments of the receiver"

    selector := aSymbol.
    args := argArray
! !

!Message methodsFor:'sending'!

sendTo:aReceiver
    "send the selector with argument(s) to aReceiver"

    ^ aReceiver perform:selector withArguments:args
!

sendTo:aReceiver usingClass:aClass
    "send the selector with argument(s) to aReceiver using the method named by selector from aClass"

    ^ (aClass compiledMethodAt:selector) valueWithReceiver:aReceiver arguments:args selector:selector
!

sendTo:aReceiver usingMethod:aMethod
    "send the selector with argument(s) to aReceiver using compiledMethod aMethod"

    ^ aMethod valueWithReceiver:aReceiver arguments:args selector:selector
! !

!Message class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

