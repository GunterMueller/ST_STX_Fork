"{ NameSpace: Demos }"

Animation subclass:#GlobeDemo
	instanceVariableNames:'current globeIndex'
	classVariableNames:'CachedGlobeForms'
	poolDictionaries:''
	category:'demos-Animations'
!

!GlobeDemo class methodsFor:'documentation'!

documentation
"
    suns globes

    [author:]
	Claus Gittinger - written spring 90

    [start with:]
	GlobeDemo open

    [see also:]
	RoundGlobe 
	Image
"
! !

!GlobeDemo class methodsFor:'defaults'!

defaultIcon
    "return the icon of the topView"

    ^ Image fromFile:'bitmaps/Globe.icon' resolution:100
! !

!GlobeDemo class methodsFor:'startup'!

open
    |anim|

    anim := self
                extent:(256 @ 256)
                label:'Globe'
                icon:self defaultIcon
                minExtent:(256 @ 256)
                maxExtent:(256 @ 256).

    anim open.
    ^ anim

    "GlobeDemo open"

    "Modified: / 27.1.1998 / 20:02:19 / cg"
! !

!GlobeDemo methodsFor:'drawing'!

drawGlobe:whichGlobe
    |form|
    form := forms at:whichGlobe.
    form notNil ifTrue:[
	self displayOpaqueForm:form x:0 y:0
    ].
    device flush
!

redraw
    self drawGlobe:globeIndex
!

step
    globeIndex := globeIndex + phase.
    (globeIndex > (forms size)) ifTrue:[
	globeIndex := globeIndex - (forms size)
    ].
    self drawGlobe:globeIndex
! !

!GlobeDemo methodsFor:'initialization'!

initForms
    |fileName form|

    forms isNil ifTrue:[
        forms := Array new:30.
        CachedGlobeForms isNil ifTrue:[
            CachedGlobeForms := WeakArray new:30
        ].
        1 to:(forms size) do:[:i |
            ((form := CachedGlobeForms at:i) isNil 
            or:[form == 0]) ifTrue:[
                fileName := 'globe' , (i printString) , '.xbm'.
                'GLOBE: reading ' infoPrint. fileName infoPrintNL.
"used to be:
                form := Form fromFile:fileName.
 which creates the form on Display (and we do not want this
 in multi-display setups ...
"
                form := Smalltalk bitmapFromFileNamed:fileName forClass:self class.
                "/ form := Image fromFile:fileName on:device.
                form isNil ifTrue:[
                    self notify:('cannot read bitmap ', fileName).
                    ^ self
                ].
                CachedGlobeForms at:i put:form
            ].
            forms at:i put:form.
        ]
    ]
!

initialize
    super initialize.
    phase := 1.
    current := 0.
    delay := 0.1.
    globeIndex := 1
! !

!GlobeDemo class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Animation/GlobeDemo.st,v 1.17 1999-12-23 16:48:07 cg Exp $'
! !
