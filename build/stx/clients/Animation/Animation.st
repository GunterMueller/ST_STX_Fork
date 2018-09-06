"{ Package: 'stx:clients/Animation' }"

"{ NameSpace: Demos }"

StandardSystemView subclass:#Animation
	instanceVariableNames:'halted delay phase xpos forms myBlock standalone'
	classVariableNames:'CachedForms'
	poolDictionaries:''
	category:'demos-Animations'
!

!Animation class methodsFor:'documentation'!

documentation
"
    walking man demo

    [author:]
	Claus Gittinger - written spring 90

    [start with:]
	Animation open

    [see also:]
	GlobeDemo RoundGlobe 
	Image
"


! !

!Animation class methodsFor:'defaults'!

defaultIcon
    "return the icon of the topView"

    ^ Image fromFile:'bitmaps/Animation.icon' resolution:100

! !

!Animation class methodsFor:'startup'!

open
    |anim display|

    display := Screen current.

    anim := self
                origin:0 @ (display usableHeight - 64)
                extent:(display usableWidth @ 64)
                label:'Animation'
                icon:self defaultIcon
                minExtent:(100 @ 64)
                maxExtent:(display usableWidth @ 64).

    anim open.
    ^ anim

    "Animation open"
! !

!Animation methodsFor:'control'!

faster
    (delay > 0.0001) ifTrue:[
	Processor removeTimedBlock:myBlock.
	delay := (delay / 2) .
	Processor addTimedBlock:myBlock afterSeconds:delay.
    ]
!

go
    halted ifTrue:[
	Processor addTimedBlock:myBlock afterSeconds:delay.
	halted := false
    ]
!

slower
    Processor removeTimedBlock:myBlock.
    delay := delay * 2.
    Processor addTimedBlock:myBlock afterSeconds:delay.
!

stop
    halted ifFalse:[
	Processor removeTimedBlock:myBlock.
	halted := true
    ]
! !

!Animation methodsFor:'drawing'!

cycle
    "
     dont update if iconified
    "
    shown ifTrue:[
	self step.
    ].
    halted ifFalse:[
	Processor addTimedBlock:myBlock afterSeconds:delay
    ]
!

drawForm:whichForm atX:x y:y
    |form|
    form := forms at:whichForm.
    form notNil ifTrue:[
	self displayOpaqueForm:form x:x y:y
    ]
!

drawPicture:whichForm at:xpos
    self drawForm:whichForm atX:xpos y:0.
    device flush
!

step
    "clear previous form - draw new one"

    self clearRectangle:(Rectangle left:xpos top:0 width:32 height:64).

    xpos := xpos + 4.
    (xpos > self width) ifTrue:[
	xpos := 0
    ].
    phase := phase + 1.
    (phase > (forms size)) ifTrue:[
	phase := phase - (forms size)
    ].
    self drawPicture:phase at:xpos.
! !

!Animation methodsFor:'events'!

destroy
    self stop.
    super destroy.
    Processor removeTimedBlock:myBlock
!

keyPress:key x:x y:y
    (key == $f) ifTrue: [
	^ self faster
    ].
    (key == $s) ifTrue: [
	^ self slower
    ].
    (key == $h) ifTrue:[
	^ self stop
    ].
    (key == $g) ifTrue:[
	^ self go
    ].
    (key == $q) ifTrue:[
	^ self destroy
    ]
!

redraw
    self drawPicture:phase at:xpos
! !

!Animation methodsFor:'initialization'!

initForms
    |form fileName|

    forms isNil ifTrue:[
        forms := Array new:8.
        CachedForms isNil ifTrue:[
            CachedForms := WeakArray new:8
        ].
        1 to:(forms size) do:[:i |
            ((form := CachedForms at:i) isNil 
            or:[form == 0]) ifTrue:[
                fileName := 'man' , (i printString) , '.xbm'.
                'reading ' print. fileName printNewline.
"used to be:
                form := Form fromFile:fileName resolution:100.
 which creates the form on Display (and we do not want this
 in multi-display setups ...
"
                form := Smalltalk bitmapFromFileNamed:fileName forClass:self class.
                "/ form := Image fromFile:fileName resolution:100 on:device.
                form isNil ifTrue:[
                    self notify:('cannot read bitmap ', fileName).
                    ^ self
                ].
                CachedForms at:i put:form
            ].
            forms at:i put:form
        ]
    ]
!

initialize
    super initialize.

    standalone := false.
    halted := false.
    delay := 0.2.
    xpos := 0.
    phase := 1.
    self initForms.
    self viewBackground:background.
    myBlock := [self cycle]
!

initializeMiddleButtonMenu
    |labels|

    labels := resources array:#('faster'
				'slower'
				'-'
				'stop'
				'step'
				'go'
				'-'
				'quit').

    self middleButtonMenu:(PopUpMenu
				labels:labels
			     selectors:#(faster
					 slower
					 nil
					 stop
					 step
					 go
					 nil
					 destroy)
				receiver:self
				     for:self)
!

realize
    super realize.
    Processor addTimedBlock:myBlock afterSeconds:delay
!

restarted
    super restarted.
    Processor addTimedBlock:myBlock afterSeconds:delay

    "Created: / 6.5.1999 / 10:19:06 / cg"
! !

!Animation class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Animation/Animation.st,v 1.18 2006-10-10 15:13:59 stefan Exp $'
! !
