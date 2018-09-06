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
"{ Package: 'stx:libwidg3' }"

"{ NameSpace: Smalltalk }"

DialogBox subclass:#ActionWaitBox
	instanceVariableNames:'action actionProcess'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-DialogBoxes'
!

!ActionWaitBox class methodsFor:'documentation'!

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
    ActionWaitBoxes are boxes which block the caller while some action
    is performed. For example, when some long time computation is performed,
    an instance of myself can be shown on top of the busy view, to
    let the user know what is going on.
    See examples for a concrete application.

    [see also:]
        AnimatedLabel ProgressIndicator

    [author:]
        Claus Gittinger
"
!

examples
"
                                                                [exBegin]
    |box label images|

    box := ActionWaitBox new.
    box label:'computing ...'.

    label := AnimatedLabel new.

    images := Array new:12.
    1 to:12 do:[:i |
        images at:i put:(Image fromFile:'bitmaps/write.' , i printString , '.xbm')
    ].

    label imageSequence:images; frameDelay:0.1.
    box addComponent:label.

    (box addAbortButton) label:'abort'.

    box action:[
                1 to:20 do:[:run |
                       1000 factorial. 
                       run printNL
                ].
               ].
    box openWithExtent:100@100.
                                                                [exEnd]

                                                                [exBegin]
    |box label images|

    box := ActionWaitBox new.
    box label:'computing ...'.

    label := AnimatedLabel new.

    images := Array new:12.
    1 to:12 do:[:i |
        images at:i put:(Image fromFile:'bitmaps/write.' , i printString , '.xbm')
    ].

    label imageSequence:images; frameDelay:0.1.
    box addComponent:label.

    (box addAbortButton) label:'abort'.

    box openDoing:[
                1 to:20 do:[:run |
                       1000 factorial. 
                       run printNL
                ].
               ].
                                                                [exEnd]
"
! !

!ActionWaitBox methodsFor:'accessing'!

action:aBlock
    "set the block to be performed by myself"

    action := aBlock
! !

!ActionWaitBox methodsFor:'realization'!

abortPressed
    "sent by the cancel button; user pressed abort button
     - hide myself and evaluate okAction"

    actionProcess notNil ifTrue:[
	actionProcess terminate.
    ].
    super abortPressed.

!

openDoing:aBlock
    action := aBlock.
    self open
!

realize
    super realize.

    actionProcess :=
        [
            action value.
            actionProcess := nil.
            self destroy
        ] forkAt:(Processor activePriority - 1).
! !

!ActionWaitBox class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libwidg3/ActionWaitBox.st,v 1.7 2017-03-15 16:23:43 mawalch Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libwidg3/ActionWaitBox.st,v 1.7 2017-03-15 16:23:43 mawalch Exp $'
! !

