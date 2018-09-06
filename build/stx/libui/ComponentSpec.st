"
 COPYRIGHT (c) 1996 by Claus Gittinger
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libui' }"

"{ NameSpace: Smalltalk }"

UISpecification subclass:#ComponentSpec
	instanceVariableNames:'level borderWidth initiallyInvisible visibilityChannel
		backgroundChannel backgroundImage foregroundChannel'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI-Specs'
!

!ComponentSpec class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1996 by Claus Gittinger
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
    Not normally used by applications.

    Notice: 
        this class was implemented using protocol information
        from alpha testers, literature and by read public domain code
        - it may not be complete or compatible to
        the corresponding ST-80 class. 
        If you encounter any incompatibilities, please forward a note 
        describing the incompatibility verbal (i.e. no code) to the ST/X team.

    [author:]
        Claus Atzkern

    [see also:]
        UIBuilder
        UIPainter
"

! !

!ComponentSpec class methodsFor:'interface specs'!

channelsEditSpec
    ^ self visibilityAndBackgroundChannelEditSpec
! !

!ComponentSpec class methodsFor:'interface-painter'!

addBindingsTo:env for:anInstance channel:aChannel 
    "add bindings as required to allow the GUI Painter to operate on an instance of me"

    super addBindingsTo:env for:anInstance channel:aChannel.

    self 
        adaptApects:
                    #(  
                        initiallyInvisible
                     )
        to:env 
        for:anInstance 
        channel:aChannel.

    self 
        adaptApects:
                    #(  
                        backgroundChannel
                     )
        to:env 
        for:anInstance 
        channel:aChannel
        converter:#symbolOrNil.

    self 
        adaptApects:
                    #(  
                        foregroundChannel
                     )
        to:env 
        for:anInstance 
        channel:aChannel
        converter:#symbolOrNil.

    self 
        adaptApects:#(
                        visibilityChannel
                     )
        to:env 
        for:anInstance 
        channel:aChannel
        converter:#symbolOrBooleanOrNil.

    self 
        adaptApects:
                    #(  
                        level
                        borderWidth
                     )
        to:env 
        for:anInstance 
        channel:aChannel
        converter:#symbolOrNumberOrNil.
! !

!ComponentSpec methodsFor:'accessing'!

backgroundImage
    ^ backgroundImage

    "Created: 28.3.1997 / 20:40:50 / cg"
!

backgroundImage:aspectSelector
    backgroundImage := aspectSelector.
!

borderWidth
    "return border width"

    ^ borderWidth ? 0

!

borderWidth:aWidth
    "set border width"

    borderWidth := aWidth


!

initiallyInvisible
    ^ initiallyInvisible  ? false
!

initiallyInvisible:something
    initiallyInvisible := something.
!

initiallyVisible
    ^ self initiallyInvisible not.
!

initiallyVisible:something
    self initiallyInvisible: something not.
!

level
    "attention: returns anIntegerOrNilOrSymbol"
    ^ level
!

level:anIntegerOrNilOrSymbol
    level := anIntegerOrNilOrSymbol.
! !

!ComponentSpec methodsFor:'accessing-channels'!

backgroundChannel
    ^ backgroundChannel

    "Created: 28.3.1997 / 20:40:50 / cg"
!

backgroundChannel:aspectSelector
    backgroundChannel := aspectSelector.

    "Created: 28.3.1997 / 20:40:50 / cg"
!

foregroundChannel
    ^ foregroundChannel
!

foregroundChannel:aspectSelector
    foregroundChannel := aspectSelector.
!

visibilityChannel
    ^ visibilityChannel
!

visibilityChannel:something
    visibilityChannel := something
! !

!ComponentSpec methodsFor:'building'!

setAttributesIn:aView with:aBuilder
    "set my attributes to aView"

    super setAttributesIn:aView with:aBuilder.

    self setBorderAttributeIn:aView with:aBuilder.

    backgroundImage notNil ifTrue:[
        aView viewBackground:(aBuilder aspectFor:backgroundImage).
    ].

    self setLevelAttributeIn:aView with:aBuilder.
    
    visibilityChannel isNil ifTrue:[
       self setVisibilityAttribute:(self initiallyInvisible) in:aView.
    ].
!

setBorderAttributeIn:aView with:aBuilder
    "set my border attribute to aView"

    |bw|
    
    (bw := borderWidth) notNil ifTrue:[
        bw isSymbol ifTrue:[
            bw := aView styleSheet at:bw default:nil.
        ].    
        bw notNil ifTrue:[
            aView borderWidth:bw
        ].
    ] ifFalse: [
        "/ aView borderWidth: 0  --- no; use default
    ].
!

setChannelsIn:aView with:aBuilder
    "set channels in aView"

    |c|

    super setChannelsIn:aView with:aBuilder.

    aBuilder isEditing ifFalse:[
        visibilityChannel notNil ifTrue:[
            c := self channel:#visibilityChannel inBuilder:aBuilder.
            c notNil ifTrue:[
                self setVisibilityChannel:c inView:aView with:aBuilder
            ].
        ].
        backgroundChannel notNil ifTrue:[
            c := self channel:#backgroundChannel inBuilder:aBuilder.
            c notNil ifTrue:[aView backgroundChannel:c].
        ].
        foregroundChannel notNil ifTrue:[
            c := self channel:#foregroundChannel inBuilder:aBuilder.
            c notNil ifTrue:[aView foregroundChannel:c].
        ].
    ]
!

setKeyboardFocusAttributesIn:aView with:aBuilder
    "helper - common code for InputField and TextEditor"

    |keyboardProcessor|

    self hasKeyboardFocusInitially ifTrue:[
        keyboardProcessor := aBuilder keyboardProcessor.
        keyboardProcessor componentWithInitialFocus:aView.
        aView scrolledView takeFocusWhenMapped:true.
    ].

    "Modified: / 22-01-2011 / 12:03:19 / cg"
!

setLevelAttributeIn:aView with:aBuilder
    "set my level attribute to aView"

    |lvl|
    
    (lvl := level) notNil ifTrue:[
        lvl isSymbol ifTrue:[
            lvl := aView styleSheet at:lvl default:nil.
        ].    
        lvl notNil ifTrue:[
            aView level:lvl
        ].
    ] ifFalse: [
        "/ aView level: 0  --- no; use default
    ].
!

setMenuIn:aView with:aBuilder
    "generic support here - sigh menuComponent AND label use it,
     but do not inherit (should label inherit from menuComponent ?)"

    |app holder menuSel theMenu|

    aBuilder isEditing ifTrue:[^ self].
    (menuSel := self menuSelector) notNil ifTrue:[
        (app := aBuilder application) notNil ifTrue:[
            holder := aBuilder menuFor:menuSel.
        ] ifFalse:[
            holder := menuSel asValue
        ].
        holder notNil ifTrue:[
            "/ if it's an array:
            "/     app class provided a spec
            "/ otherwise:
            "/     app instance provided a holder

            holder isArray ifTrue:[
                theMenu := holder decodeAsLiteralArray.
                theMenu receiver:app.
                holder := theMenu asValue.
            ].

            self setMenuPerformerIn:theMenu forView:aView with:aBuilder.

            MessageNotUnderstood 
                ignoreNotUnderstoodOfAny:#(menuHolder: menuMessage:)
                in:[
                    aView menuHolder:holder; menuMessage:#value.

                    "/ mhmh - does this break existing apps
                    "/ (i.e. if it depends on the selected item to get
                    "/  the menuMessage ?)
                    "/ for now, leave it as it is and make the spec explicit.
                    "/ performer isNil ifTrue:[aView menuPerformer:app].
                ]
        ]
    ].

    "Modified: / 01-11-1997 / 03:12:33 / cg"
    "Modified (format): / 13-02-2017 / 19:59:05 / cg"
!

setMenuPerformerIn:aMenu forView:aView with:aBuilder
    "generic support here - sigh menuComponent AND label use it,
     but do not inherit (should label inherit from menuComponent ?)"

    |recv performer|

    (performer := self performer) notNil ifTrue:[
        recv := self getBindingIn:aBuilder binding:performer.
        recv notNil ifTrue:[
            aMenu notNil ifTrue:[
                aMenu receiver:recv
            ] ifFalse:[
                aView menuPerformer:recv
            ]
        ]
    ].

! !

!ComponentSpec methodsFor:'converting'!

skippedInLiteralEncoding
    "define the inst-slots which are skipped when generating a literalArrayEncoding;
     (to skip the ones with default values.)"

    |l|

    l := super skippedInLiteralEncoding asOrderedCollection.

    level               isNil                   ifTrue:[ l add:#level ].
    visibilityChannel   isNil                   ifTrue:[ l add:#visibilityChannel ].
    backgroundChannel   isNil                   ifTrue:[ l add:#backgroundChannel ].
    foregroundChannel   isNil                   ifTrue:[ l add:#foregroundChannel ].
    (borderWidth isNil or:[borderWidth == 0])   ifTrue:[ l add:#borderWidth].
    (initiallyInvisible == true)                ifFalse:[l add:#initiallyInvisible].

    ^ l
! !

!ComponentSpec methodsFor:'parsing a view'!

fromView:aView callBack:aBlock
    "extract attributes from aView"

    level           := aView level.
    borderWidth     := aView borderWidth.
    initiallyInvisible := aView isHiddenOnRealize.

    super fromView:aView callBack:aBlock


! !

!ComponentSpec methodsFor:'queries-UIDefiner'!

aspectSelectors
    "add more aspect selectors (these generate aspect methods in the definer)"

    |more|

    more := super aspectSelectors.
    visibilityChannel notNil ifTrue:[more add:visibilityChannel].
    backgroundChannel notNil ifTrue:[more add:backgroundChannel].
    foregroundChannel notNil ifTrue:[more add:foregroundChannel].
    ^ more

    "Modified: / 10.2.2000 / 01:25:12 / cg"
!

defaultModelValueFor:someAspect
    "used by the UIDefiner - return the aspect's default value"

    someAspect == visibilityChannel ifTrue:[
        ^ true
    ].

    ^ super defaultModelValueFor:someAspect

    "Created: / 5.2.2000 / 21:13:21 / cg"
    "Modified: / 10.2.2000 / 01:27:54 / cg"
! !

!ComponentSpec class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libui/ComponentSpec.st,v 1.44 2017-11-28 18:21:20 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libui/ComponentSpec.st,v 1.44 2017-11-28 18:21:20 cg Exp $'
! !

