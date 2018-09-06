"
 COPYRIGHT (c) 2001 by eXept Software AG
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

ExecutionError subclass:#MessageNotUnderstood
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Exceptions-Errors'
!

!MessageNotUnderstood class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2001 by eXept Software AG
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
    raised when a message is sent to an object, which is not understood
    by the receiver, and the message was not handled by a class specific
    doesNotUnderstand: handler.
"
! !

!MessageNotUnderstood class methodsFor:'initialization'!

initialize
    NotifierString := 'message not understood'.

    "
     self initialize
    "
! !

!MessageNotUnderstood class methodsFor:'save evaluation'!

ignoreNotUnderstoodOf:aSelector in:aBlock
    "evaluate aBlock; if a messageNotUnderstood occurs,
     for which the message was aSelector, ignore the error
     and return.
     Other selector errors lead into the debugger.
     If no error occurs, return the blocks value"

    ^ self handle:[:ex |
        ex selector == aSelector ifFalse:[
            ex reject
        ]
    ] do:aBlock.
!

ignoreNotUnderstoodOfAny:aCollectionOfSelectors in:aBlock
    "evaluate aBlock; if a messageNotUnderstood occurs,
     for which the message was any in aCollectionOfSelectors, ignore the error
     and return.
     Other selector errors lead into the debugger.
     If no error occurs, return the blocks value"

    ^ self handle:[:ex |
        (aCollectionOfSelectors includesIdentical:ex selector) ifFalse:[
            ex reject
        ]
    ] do:aBlock.
! !

!MessageNotUnderstood methodsFor:'accessing'!

message
    ^ parameter

    "
     [
        123 perform:#foo
     ] on:MessageNotUnderstood do:[:ex |
        Transcript show:'message object: '; showCR:ex message storeString.
        Transcript show:'receiver: '; showCR:ex receiver storeString.
        Transcript show:'selector: '; showCR:ex message selector storeString.
        Transcript show:'arguments: '; showCR:ex message arguments storeString.
     ]
    "
!

receiver
    ^ originator

    "
     [
        123 perform:#foo
     ] on:MessageNotUnderstood do:[:ex |
        Transcript showCR:ex receiver
     ]
    "
!

selector
    ^ parameter selector

    "
     [
        123 perform:#foo
     ] on:MessageNotUnderstood do:[:ex |
        Transcript show:'selector: '; showCR:ex selector storeString.
     ]
    "
! !

!MessageNotUnderstood methodsFor:'printing & storing'!

description
    "the human readable description of the exception"

    |searchClass sel description sender|

    "extract the class that should have implemented the message.
     (in case of a super-send, this is not the receiver's class)"

    "/ suspendedContext is the actual doesNotUnderstand context;
    "/ its sender is the bad (failing) one, which has the search class information
    "/ (the doesNotUnderstand is always an undirected send)
    "/ Q: is that correct VM-behavior?
    "/ One might argue, that the DNU should be also directed 
    "/ (or else add the searchClass information to the Message object)
    suspendedContext notNil ifTrue:[
        searchClass := suspendedContext searchClass.
        (sender := suspendedContext sender) notNil ifTrue:[
            "/ just in case, this gets ever fixed
            sender receiver == suspendedContext receiver ifTrue:[
                searchClass := sender searchClass.
            ].
        ].
    ].
    searchClass isNil ifTrue:[
        searchClass := self receiver class.
    ].
    searchClass notNil ifTrue:[
        "displayString is better than 'cls name',
         since it appends (obsolete) for outdated classes.
         (this happens if you send messages to old instances
          after changing a classes definition)"

        description := searchClass displayString.
        description isString ifFalse:[
            description := '(** ???-class **)'
        ].
    ] ifFalse:[    
        description := '(** nil-class **)'
    ].
    sel := self selector.
    sel class == Symbol ifTrue:[
        description := description , ' does not understand: ' , sel storeString.
        "/ description := sel, ' not understood by ' ,  description.
    ] ifFalse:[
        "a non-symbol selector may happen when things go mad in a primitive, 
         or a method has been called by #perform: or #valueWithReceiver: with a wrong arg."

        description := description , ' does not understand nonSymbol: ' , sel printString.
        "/ description := sel printString, ' (nonSymbol) not understood by ' ,  description.
    ].

    ^ description


    "
        2 foo:3
        2 perform:55
        nil // 2
    "

    "Modified: / 19-08-2010 / 15:33:03 / cg"
! !

!MessageNotUnderstood class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


MessageNotUnderstood initialize!
