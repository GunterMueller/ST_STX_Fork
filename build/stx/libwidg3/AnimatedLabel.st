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

Label subclass:#AnimatedLabel
	instanceVariableNames:'imageSequence frameDelay animationProcess'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Misc'
!

!AnimatedLabel class methodsFor:'documentation'!

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
    this implements labels which show a little animation sequence
    (sequence of images) instead of a fixed logo.

    [see also:]
        ActionWaitBox ProgressIndicator
        Label Image

    [author:]
        Claus Gittinger
"
!

examples
"
  plain animated label:
                                                                        [exBegin]
    |label images|

    label := AnimatedLabel new.

    images := Array new:8.
    1 to:8 do:[:i |
        images at:i put:(Image fromFile:'../../clients/Animation/bitmaps/man' , i printString , '.xbm')
    ].

    label imageSequence:images; frameDelay:0.1.
    label open
                                                                        [exEnd]


  animated label in a DialogBox:
                                                                        [exBegin]
    |dialog label images|

    dialog := Dialog new.
    dialog label:'writing'.

    dialog addTextLabel:'saving your data - please wait ...'.

    label := AnimatedLabel new.

    images := Array new:12.
    1 to:12 do:[:i |
        images at:i put:(Image fromFile:'../../libwidg3/bitmaps/write.' , i printString , '.xbm')
    ].

    label imageSequence:images; frameDelay:0.1.
    dialog addComponent:label.

    (dialog addAbortButton) label:'abort'.
    dialog open.
                                                                        [exEnd]

  same, using the more convenient ActionWaitBox:
                                                                        [exBegin]
    |box label images|

    box := ActionWaitBox new.
    box label:'writing'.

    box addTextLabel:'saving your data - please wait ...'.

    label := AnimatedLabel new.

    images := Array new:12.
    1 to:12 do:[:i |
        images at:i put:(Image fromFile:'../../libwidg3/bitmaps/write.' , i printString , '.xbm')
    ].

    label imageSequence:images; frameDelay:0.1.
    box addComponent:label.

    (box addAbortButton) label:'abort'.
    box openDoing:
            [
                10 timesRepeat:[(Delay forSeconds:1) wait]
            ].
                                                                        [exEnd]
"
! !

!AnimatedLabel methodsFor:'accessing'!

frameDelay:seconds
   frameDelay := seconds
!

imageSequence:aCollectionOfImages
    imageSequence := aCollectionOfImages.
    self label:imageSequence first
! !

!AnimatedLabel methodsFor:'initialization'!

initialize
    super initialize.
    frameDelay := 1/20.
! !

!AnimatedLabel methodsFor:'realization'!

destroy
    self stopAnimationProcess.
    super destroy.
!

mapped
    super mapped.

    animationProcess isNil ifTrue:[
        self startAnimationProcess
    ]
!

release
    self stopAnimationProcess.
    super release.
!

startAnimationProcess
    animationProcess isNil ifTrue:[
        animationProcess := [
            [shown] whileTrue:[
                imageSequence do:[:anImage |
                    shown ifTrue:[
                        self label:anImage; redraw.
                        self flush
                    ].
                    (Delay forSeconds:frameDelay) wait
                ]
            ].
            animationProcess := nil.
        ] newProcess.
        animationProcess name:'label animation'.
        animationProcess priority:(Processor currentPriority + 1).
        animationProcess restartable:true.
        animationProcess resume.
    ]
!

stopAnimationProcess
    |p|

    (p := animationProcess) notNil ifTrue:[
        animationProcess := nil.
        p terminate.
    ].
!

unmap
    self stopAnimationProcess.
    super unmap.
! !

!AnimatedLabel class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libwidg3/AnimatedLabel.st,v 1.5 2016-09-22 18:21:36 mawalch Exp $'
! !

