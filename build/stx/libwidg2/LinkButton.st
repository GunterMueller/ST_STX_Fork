"
 COPYRIGHT (c) 2006 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libwidg2' }"

"{ NameSpace: Smalltalk }"

Button subclass:#LinkButton
	instanceVariableNames:'labelsAndActions'
	classVariableNames:'DefaultLinkColor'
	poolDictionaries:''
	category:'Views-Layout'
!

!LinkButton class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 by eXept Software AG
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
    Looks like a Label, but behaves like a button with individually clickable text components.
    Can be used to create html-page-look-alike links in a view,
    especially to make label-looking action buttons (as in the browser's info view).

    [author:]
        cg (cg@CG-VOSTRO)

    [instance variables:]

    [class variables:]

    [see also:]

"
!

examples
"
                                                                    [exBegin]
    |v l|

    v := StandardSystemView new.
    l := LinkButton in:v.
    l label:
        (('Hello' actionForAll:[ Transcript showCR:'Hello Clicked']) 
        , ' '
        , ('World' actionForAll:[ Transcript showCR:'World Clicked'])).

    v open
                                                                    [exEnd]


                                                                    [exBegin]
    |v l|

    v := StandardSystemView new.
    l := LinkButton in:v.
    l label:
        ((('Hello' actionForAll:[ Transcript showCR:'Hello Clicked']) colorizeAllWith:(Color blue)) 
        , ' '
        , ('World' actionForAll:[ Transcript showCR:'World Clicked'])).

    v open
                                                                    [exEnd]


                                                                    [exBegin]
    |v l|

    v := StandardSystemView new.
    l := LinkButton in:v.
    l labelsAndActions:{ 
                        'Hello' -> [ Transcript showCR:'Hello Clicked'].
                        ' ' -> nil.
                        'World' -> [ Transcript showCR:'World Clicked'].
                       }.
    l foregroundColor:Color blue.
    v open
                                                                    [exEnd]


                                                                    [exBegin]
    |v l|

    v := StandardSystemView new.
    l := LinkButton in:v.
    l labelsAndActions:{ 
                        'Hello' -> nil.
                        ' ' -> nil.
                        'World' -> [ Transcript showCR:'World Clicked'].
                       }.
    l foregroundColor:Color blue.
    v open
                                                                    [exEnd]
    Dialog aboutToOpenBoxNotificationSignal handle:[:ex |
        |lbl|

        lbl := LinkButton label:(('XXX' 
                                        colorizeAllWith:Color blue)
                                        actionForAll:[ Transcript showCR:'xxx' ]).
        ex box verticalPanel addComponent:lbl.
    ] do:[
        self warn:'Bla bla bla'
    ].

"
! !

!LinkButton class methodsFor:'defaults'!

updateStyleCache
    "extract values from the styleSheet and cache them in class variables"

    <resource: #style ( #'linkButton.linkColor' )>

    DefaultLinkColor := StyleSheet colorAt:#'linkButton.linkColor' default:Color blue.
! !

!LinkButton methodsFor:'accessing'!

actionAt:aPoint
    |pressAction emphasis pointInLabel|

    pressAction := self pressAction ifNil:[ self releaseAction ].
    pressAction isNil ifTrue:[
        pressAction := self pressChannel ifNil:[ self releaseChannel ].
    ].
    labelsAndActions isNil ifTrue:[
        "take action from logo, which is normally a text with an action-emphasis"
        logo notNil ifTrue:[
            pointInLabel := (aPoint - (labelOriginX@labelOriginY)).
            logo isStringCollection ifTrue:[
                |lineIndex line pointInLine|

                lineIndex := (pointInLabel y // self font height) + 1.
                line := logo at:lineIndex ifAbsent:nil.
                line notNil ifTrue:[
                    pointInLine := pointInLabel - (0 @ ((lineIndex - 1) * self font height)).
                    emphasis := line emphasisAtPoint:pointInLine on:self. 
                ].    
            ] ifFalse:[    
                emphasis := logo emphasisAtPoint:pointInLabel on:self. 
            ].
            (emphasis isNil or:[emphasis isSymbol]) ifTrue:[
                ^ pressAction.
            ].
            emphasis isAssociation ifTrue:[
                emphasis key == #actionBlock ifTrue:[
                    ^ emphasis value.
                ].
                ^ pressAction.
            ].
            emphasis do:[:eachElement|
                eachElement isAssociation ifTrue:[
                    eachElement key == #actionBlock ifTrue:[
                        ^ eachElement value.
                    ].
                ].
            ].
        ].    
        ^ pressAction.
    ].

    self labelsAndActionsWithPositionsDo:[:lbl :action :leftX :rightX |
        (aPoint x between:leftX and:rightX) ifTrue:[
            ^ labelsAndActions notNil ifTrue:action ifFalse:pressAction
        ].
    ].
    ^ nil
!

labelsAndActions
    "returns the collection of label->action associations. 
     For display, the label strings are drawn as one concatenated string (add separating spaces, if you have to).
     When clicked on a string, the corresponding action is called"

    ^ labelsAndActions
!

labelsAndActions:aCollectionOfAssociations
    "set the collection of label->action associations. 
     For display, the label strings are drawn as one concatenated string (add separating spaces, if you have to).
     When clicked on a string, the corresponding action is called"

    labelsAndActions := aCollectionOfAssociations.
    self label:((aCollectionOfAssociations collect:[:assoc | assoc key]) asStringWith:'')
!

level:anInteger
    enterLevel := leaveLevel := onLevel := offLevel := level := anInteger.
    margin := level abs.
! !

!LinkButton methodsFor:'initialization'!

allViewBackground:something if:condition
    "set the viewBackground to something, a color, image or form,
     in myself and recursively in all of my subviews"

    self viewBackground:something if:condition.
    self backgroundColor:something.
!

defaultControllerClass
    ^ LinkButtonController
!

initStyle
    super initStyle.

    level := enterLevel := leaveLevel := onLevel := offLevel := 0.
    self borderWidth: 0.
    DefaultLinkColor notNil ifTrue:[
        |color|
        self paint:(color := DefaultLinkColor onDevice:device).
        self foreground:color.
    ].
    enteredFgColor := nil.
    enteredBgColor := nil.

"/    activeFgColor := enteredFgColor := foreground.
"/    activeBgColor := enteredBgColor := viewBackground.

    "Modified: / 07-09-2011 / 04:29:29 / cg"
!

initialize
    super initialize.
    self enableMotionEvents
! !

!LinkButton methodsFor:'private'!

actionEmphasisIn:aText atPoint:aPoint
    "check for an actionBlock-emphasis in aString at aPoint.
     Answer an Array with the whole emphasis and the actionBlock,
     or nil"
    
    |emphasis|

    emphasis := aText emphasisAtPoint:aPoint on:self.
    (emphasis isNil or:[emphasis isSymbol]) ifTrue:[
        ^ #(nil nil).
    ].
    emphasis isAssociation ifTrue:[
        emphasis key == #actionBlock ifTrue:[
            ^ Array with:emphasis with:emphasis value.
        ].
        ^ #(nil nil).
    ].
    emphasis detect:[:eachElement|
        eachElement isAssociation ifTrue:[
            eachElement key == #actionBlock ifTrue:[
                ^ Array with:emphasis with:eachElement value.
            ].
        ].
    ] ifNone:[].
    ^ #(nil nil).
!

labelsAndActionsWithPositionsDo:aFourArgBlock
    |leftX rightX w|

    leftX := labelOriginX.
    labelsAndActions isNil ifTrue:[
        w := (self font widthOf:logo on:device).
        rightX := leftX + w-1.
        aFourArgBlock 
            value:logo
            value:self pressAction
            value:leftX
            value:rightX.
        ^ self
    ].

    labelsAndActions do:[:assoc | 
        |lbl wEach|

        lbl := assoc key.
        wEach := (self font widthOf:lbl on:device).
        rightX := leftX + wEach-1.
        aFourArgBlock 
            value:assoc key
            value:assoc value
            value:leftX
            value:rightX.

        leftX := rightX+1.
    ].
    ^ nil
! !

!LinkButton methodsFor:'redrawing'!

drawFocusFrame
    "/ intentionally ignored
    ^ self
!

drawStringLogo:aString x:x y:y
    "redefined to draw any anchor under the mouse pointer with an underlined emphasis"

    |str entered mousePoint start len emphasis|

    mousePoint := controller lastMousePoint.
    entered := controller entered.

    labelsAndActions isNil ifTrue:[
        (entered not or:[mousePoint isNil]) ifTrue:[
            self displayString:aString x:x y:y.
            ^ self.
        ].

        str := aString.
        emphasis := (self actionEmphasisIn:aString atPoint:mousePoint) first.
        emphasis notNil ifTrue:[
            start := 1.
            aString emphasisCollection runsDo:[:eachLen :eachEmphasis|
                len isNil ifTrue:[
                    eachEmphasis == emphasis ifTrue:[
                        len := eachLen.
                    ] ifFalse:[
                        start := start + eachLen.  
                    ].
                ].
            ].
            len notNil ifTrue:[
                str := str deepCopy.
                str emphasisFrom:start to:start+len-1 add:#underline.
                "/ str emphasisFrom:start to:start+len-1 add:(#color -> foreground).
            ].
        ].
        self displayString:str x:x y:y.
        ^ self.
    ].

    self labelsAndActionsWithPositionsDo:[:lbl :action :leftX :rightX |
        |l|

        l := lbl.
        action notNil ifTrue:[
            (entered and:[mousePoint notNil and:[mousePoint x between:leftX and:rightX]]) ifTrue:[
                l := l allUnderlined
            ].
        ].
        self displayString:l x:leftX y:y.
    ].

    "Modified: / 07-09-2011 / 04:47:13 / cg"
!

is3D
    ^ false.
! !

!LinkButton class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

