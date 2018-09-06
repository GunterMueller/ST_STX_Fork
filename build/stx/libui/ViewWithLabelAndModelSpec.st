"
 COPYRIGHT (c) 1995 by eXept Software AG
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

ViewWithLabelSpec subclass:#ViewWithLabelAndModelSpec
	instanceVariableNames:'tabable model initiallyDisabled enableChannel disabledLogo'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI-Specs'
!

!ViewWithLabelAndModelSpec class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1995 by eXept Software AG
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

    [author:]
        Claus Gittinger

    [see also:]
        UIBuilder
        UIPainter
"





! !

!ViewWithLabelAndModelSpec class methodsFor:'interface-painter'!

addBindingsTo:aDirectory for:anInstance channel:aChannel 
    "add bindings as required to allow the GUI Painter to operate on an instance of me"

    super addBindingsTo:aDirectory for:anInstance channel:aChannel.

    self 
        adaptApects:
                    #(  
                        tabable
                        initiallyDisabled
                        disabledLogo
                     )
        to:aDirectory 
        for:anInstance 
        channel:aChannel.

    self 
        adaptApects:#(
                        model
                        enableChannel
                     )
        to:aDirectory 
        for:anInstance 
        channel:aChannel
        converter:#symbolOrNil

    "Modified: / 26.10.1997 / 03:21:28 / cg"
    "Created: / 26.10.1997 / 13:39:06 / cg"
! !

!ViewWithLabelAndModelSpec methodsFor:'accessing'!

disabledLogo
    "return the value of the instance variable 'disabledLogo' (automatically generated)"

    ^ disabledLogo

    "Created: / 26.10.1997 / 13:31:15 / cg"
!

disabledLogo:something
    "set the value of the instance variable 'disabledLogo' (automatically generated)"

    disabledLogo := something
!

initiallyDisabled
    "return the value of the instance variable 'initiallyDisabled' (automatically generated)"

    ^ initiallyDisabled ? false

    "Created: / 26.10.1997 / 13:31:05 / cg"
!

initiallyDisabled:something
    "set the value of the instance variable 'initiallyDisabled' (automatically generated)"

    initiallyDisabled := something.

    "Created: / 26.10.1997 / 13:31:11 / cg"
!

model
    "return model"

    ^ model

    "Created: / 26.10.1997 / 13:30:56 / cg"
!

model:something
    "set model"

    something isNil ifTrue:[
        model := something.
    ] ifFalse:[
        model := something asSymbol
    ]

    "Created: / 26.10.1997 / 13:31:00 / cg"
!

setModel:something
    "set model"

    model := something.

    "Created: / 26.10.1997 / 13:31:31 / cg"
!

tabable
    "return tabable"

    ^ tabable ? true

    "Created: / 26.10.1997 / 13:30:46 / cg"
    "Modified: / 5.2.2000 / 19:46:45 / cg"
!

tabable:something
    "set tabable"

    tabable := something.

    "Created: / 26.10.1997 / 13:30:50 / cg"
! !

!ViewWithLabelAndModelSpec methodsFor:'accessing-channels'!

enableChannel
    "return the value of the instance variable 'enableChannel' (automatically generated)"

    ^ enableChannel

    "Created: / 26.10.1997 / 13:31:15 / cg"
!

enableChannel:something
    "set the value of the instance variable 'enableChannel' (automatically generated)"

    something isNil ifTrue:[
        enableChannel := nil.
    ] ifFalse:[
        enableChannel := something asSymbol
    ]

    "Created: / 26.10.1997 / 13:31:20 / cg"
! !

!ViewWithLabelAndModelSpec methodsFor:'building'!

setAttributesIn:aView with:aBuilder
    "set my attributes to aView"

    |lbl|

    super setAttributesIn:aView with:aBuilder.

    (disabledLogo isString and:[disabledLogo size ~~ 0])
    ifTrue:[
        lbl := (self getLabel:label translate:translateLabel with:aBuilder).
        aView perform:#passiveLogo: with:lbl ifNotUnderstood:nil.
        aView perform:#activeLogo: with:lbl ifNotUnderstood:nil.

        aView disabledLogo:(self getLabel:disabledLogo translate:translateLabel with:aBuilder).
    ] ifFalse:[
        aBuilder isEditing ifTrue:[
            aView perform:#disabledLogo: with:nil ifNotUnderstood:nil"/ lbl.
        ]
    ].

    self tabable == true ifTrue:[aBuilder makeTabable:aView].

    self setModelAttributeIn:aView with:aBuilder.
    self setEnableAttributesIn:aView with:aBuilder.
!

setChannelsIn:aView with:aBuilder
    "set channels in aView"

    |c|

    super setChannelsIn:aView with:aBuilder.

    enableChannel notNil ifTrue:[
        aBuilder isEditing ifFalse:[
            c := self channel:#enableChannel inBuilder:aBuilder.
            c notNil ifTrue:[aView enableChannel:c].
        ]
    ]
!

setEnableAttributesIn:aView with:aBuilder
    |enaDisa|

    enableChannel isNil ifTrue:[
        aBuilder isEditing ifFalse:[
            enaDisa := initiallyDisabled == true ifTrue:[#disable] ifFalse:[#enable].
            aView perform:enaDisa ifNotUnderstood:nil.
        ]
    ].
! !

!ViewWithLabelAndModelSpec methodsFor:'converting'!

skippedInLiteralEncoding
    "define the inst-slots which are skipped when generating a literalArrayEncoding;
     (to skip the ones with default values.)"

    |l|

    l := super skippedInLiteralEncoding asOrderedCollection.

    (disabledLogo isString and:[disabledLogo size ~~ 0]) ifFalse:[l add:#disabledLogo].

    tabable isNil               ifTrue:[l add:#tabable].
    initiallyDisabled  ~~ true  ifTrue:[l add:#initiallyDisabled].
    enableChannel isNil         ifTrue:[l add:#enableChannel].

    ^l

    "Modified: / 5.2.2000 / 20:08:47 / cg"
! !

!ViewWithLabelAndModelSpec methodsFor:'parsing a view'!

fromView:aView callBack:aBlock
    "extract attributes from aView"

    initiallyDisabled := (aView enabled ? true) not.
    super fromView:aView callBack:aBlock


! !

!ViewWithLabelAndModelSpec methodsFor:'queries-UIDefiner'!

aspectSelectors
    "add more aspect selectors (these generate aspect methods in the definer)"

    |more|

    more := super aspectSelectors.
    enableChannel notNil ifTrue:[more add:enableChannel].
    ^ more

    "Created: / 26.10.1997 / 13:31:56 / cg"
    "Modified: / 10.2.2000 / 01:24:22 / cg"
!

defaultModelValueFor:someAspect
    "used by the UIDefiner - return the aspects default value"

    <ignore: RBReturnsBooleanAndOtherRule rationale:'by definition' author:'cg'>

    someAspect == enableChannel ifTrue:[
        ^ true
    ].
    someAspect == labelChannel ifTrue:[
        ^ 'buttonLabel'
    ].

    ^ super defaultModelValueFor:someAspect

    "Created: / 26-10-1997 / 19:02:15 / cg"
    "Modified: / 16-07-2017 / 14:00:55 / cg"
!

modelSelector
    "return my model selector"

    ^ model
           
! !

!ViewWithLabelAndModelSpec class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libui/ViewWithLabelAndModelSpec.st,v 1.20 2017-11-28 18:21:52 cg Exp $'
! !

