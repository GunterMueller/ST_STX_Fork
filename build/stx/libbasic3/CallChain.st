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
"{ Package: 'stx:libbasic3' }"

Object subclass:#CallChain
	instanceVariableNames:'receiver selector class isBlock rest'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Debugging-Support'
!

!CallChain class methodsFor:'documentation'!

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
    This is is used as a companion to MessageTally.
    Instances of it are used to represent a calling chain.
    They are simply holders for some of the contexts values - no
    intelligence here.
    (MessageTally could have used the contexts themself, but these
     may create more overhead)

    [author:]
        Claus Gittinger

    [see also:]
        MessageTally ProfileTree
        MessageTracer
        AbstractTime
"
! !

!CallChain class methodsFor:'instance creation'!

callChainTo:aContext stopAtCallerForWhich:aBlock
    "entered whenever the probed block gets interrupted;
     generate a chain of callInfo objects to aContext"

    "{ Pragma: +optSpeed }"

    |con chain info atEnd sender home
     recClass selector mthdClass|

    con := aContext.
    con isNil ifTrue:[^ nil].

    "/ skip any intermediate contexts
    [con receiver == Processor] whileTrue:[
        con := con sender
    ].

    "got it - collect info from contexts"

    "walk up"

    con isNil ifTrue:[^ nil].
    (aBlock value:con) ifTrue:[^ nil].

    atEnd := false.

    [atEnd] whileFalse:[
        con isNil ifTrue:[
            atEnd := true
        ] ifFalse:[
            sender := con sender.
            sender isNil ifTrue:[
                atEnd := true
            ] ifFalse:[
                (aBlock value:sender) ifTrue:[
                    atEnd := true
"/                ] ifFalse:[
"/                    (sender isBlockContext) ifTrue:[
"/                        (aBlock value:sender sender) ifTrue:[
"/                            atEnd := true
"/                        ]
"/                    ]
                ]
            ]
        ].
        atEnd ifFalse:[
            info := self basicNew.
            home := con methodHome.

            home isNil ifTrue:[
                recClass := UndefinedObject.
                selector := 'optimized'.
                mthdClass := UndefinedObject.
            ] ifFalse:[
                recClass := home receiver class.
                selector := home selector.
                mthdClass := home methodClass.
            ].

            info 
                receiver:recClass
                selector:selector
                class:mthdClass
                isBlock:(con isBlockContext).
            info rest:chain.
            chain := info.
            con := sender
        ]
    ].

    ^ chain

    "Created: / 04-07-2010 / 09:43:27 / cg"
! !

!CallChain methodsFor:'accessing'!

isBlock
    "return true, if this is a callChain for a block-context"

    ^ isBlock

    "Modified: 18.5.1996 / 18:52:05 / cg"
!

methodClass
    "return the contexts methods class"

    ^ class

    "Modified: 18.5.1996 / 18:54:04 / cg"
!

receiver
    "return the contexts receiver"

    ^ receiver

    "Modified: 18.5.1996 / 18:54:12 / cg"
!

receiver:r selector:s class:cls 
    "private tally interface - set receiver, selector and class.
     the block flag is cleared."

    receiver := r.
    selector := s.
    class := cls.
    isBlock := false.

    "Modified: 18.5.1996 / 18:54:42 / cg"
!

receiver:r selector:s class:cls isBlock:blk
    "private tally interface - set receiver, selector, class
     and the block flag."

    receiver := r.
    selector := s.
    class := cls.
    isBlock := blk.

    "Created: 18.5.1996 / 18:52:34 / cg"
    "Modified: 18.5.1996 / 18:54:58 / cg"
!

rest
    "return the chains link"

    ^ rest

    "Modified: 18.5.1996 / 18:55:24 / cg"
!

rest:r
    "set the chains link"

    rest := r.

    "Modified: 18.5.1996 / 18:55:19 / cg"
!

selector
    "return the contexts selector"

    ^ selector

    "Modified: 18.5.1996 / 18:55:11 / cg"
! !

!CallChain methodsFor:'comparing'!

= someInfo
    "return true, if the argument chain is for the same method invocation"

    receiver == someInfo receiver ifFalse:[^ false].
    selector == someInfo selector ifFalse:[^ false].
    ^ class == someInfo methodClass

    "Modified: 18.5.1996 / 18:55:47 / cg"
!

hash
    "return an integer useful for hashing on the receiver;
     redefined since = is redefined here."

    ^ (receiver hash bitXor:selector hash) bitXor:class hash
! !

!CallChain class methodsFor:'documentation'!

version
    ^ '$Header: CallChain.st 1909 2012-03-31 00:14:49Z vranyj1 $'
!

version_CVS
    ^ '§Header: /cvs/stx/stx/libbasic3/CallChain.st,v 1.14 2010/07/04 08:06:27 cg Exp §'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '§Id: CallChain.st 1909 2012-03-31 00:14:49Z vranyj1 §'
! !

