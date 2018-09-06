"{ Encoding: utf8 }"

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
"{ Package: 'stx:libui' }"

"{ NameSpace: Smalltalk }"

ComponentSpec subclass:#ViewWithLabelSpec
	instanceVariableNames:'hasCharacterOrientedLabel label foregroundColor backgroundColor
		translateLabel labelChannel resizeForLabel adjust formatString
		enableDisableColorChannel multiLineLabel'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI-Specs'
!

!ViewWithLabelSpec class methodsFor:'documentation'!

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

    "Modified: 4.9.1995 / 19:40:34 / claus"
!

documentation
"
    Not normally used by applications.

    special channel:
        enableDisableColor      this is an optional boolean channel, which can be 
                                connected to another view's enable channel.
                                If will change the label's foreground color to the
                                buttonDisabledColor / buttonEnabledColor respectively.
                                Use this if labels/framedBoxes etc. are to change their 
                                color under the control of an enable channel.

    [author:]
        Claus Atzkern

    [see also:]
        UIBuilder
        UIPainter
"
! !

!ViewWithLabelSpec class methodsFor:'interface specs'!

basicsEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:ViewWithLabelSpec andSelector:#basicsEditSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: basicsEditSpec
        window: 
       (WindowSpec
          label: 'ViewWithLabel Basics'
          name: 'ViewWithLabel Basics'
          min: (Point 10 10)
          bounds: (Rectangle 14 46 414 146)
        )
        component: 
       (SpecCollection
          collection: (
           (FramedBoxSpec
              label: 'Basic Attributes'
              name: 'FramedBox'
              layout: (LayoutFrame 0 0.0 6 0 0 1.0 99 0)
              labelPosition: topLeft
              translateLabel: true
              component: 
             (SpecCollection
                collection: (
                 (LabelSpec
                    label: 'ID:'
                    name: 'nameLabel'
                    layout: (AlignmentOrigin 83 0 24 0 1 0.5)
                    resizeForLabel: true
                    adjust: right
              translateLabel: true
                  )
                 (InputFieldSpec
                    name: 'nameField'
                    layout: (LayoutFrame 85 0 13 0 0 1.0 35 0)
                    activeHelpKey: id
                    tabable: true
                    model: name
                    group: inputGroup
                    acceptChannel: acceptChannel
                    modifiedChannel: modifiedChannel
                    acceptOnPointerLeave: false
                  )
                 (LabelSpec
                    label: 'Label:'
                    name: 'labelLabel'
                    layout: (AlignmentOrigin 83 0 49 0 1 0.5)
                    resizeForLabel: true
                    adjust: right
              translateLabel: true
                  )
                 (InputFieldSpec
                    name: 'labelField'
                    layout: (LayoutFrame 85 0.0 38 0 0 1.0 60 0)
                    activeHelpKey: label
                    tabable: true
                    model: label
                    group: inputGroup
                    acceptChannel: acceptChannel
                    modifiedChannel: modifiedChannel
                    acceptOnPointerLeave: false
                  )
                 )
               
              )
            )
           )
         
        )
      )
! !

!ViewWithLabelSpec class methodsFor:'interface-painter'!

addBindingsTo:env for:inst channel:aChannel 
    "add bindings as required to allow the GUI Painter to operate on an instance of me"

    super addBindingsTo:env for:inst channel:aChannel.

    self 
        adaptApects:
                    #(  
                        label 
                        style 
                        colors 
                        foregroundColor 
                        backgroundColor 
                        initiallyInvisible 
                        translateLabel
                        hasImageOrientedLabel
                        resizeForLabel
                        alignment
                        adjust
                        formatString
                        multiLineLabel
                     )
        to:env 
        for:inst 
        channel:aChannel.

    self 
        adaptApects:
                    #(  
                        labelChannel
                        foregroundChannel
                        enableDisableColorChannel
                     )
        to:env 
        for:inst 
        channel:aChannel
        converter:#symbolOrNil.

    env at:#alignmentList put:(ValueHolder 
                                with: #(#left #right #center #centerEach
                                        #leftRight #rightLeft #centerRight #centerLeft) ).

    "Modified: / 26-10-1997 / 03:47:39 / cg"
    "Modified: / 24-05-2018 / 11:30:25 / Claus Gittinger"
!

slices
    "return the slices for the attribute sections in the GUI Painter"

    ^#(     
        (Basics basicsEditSpec)
        (Colors colorSpec)
      )



! !

!ViewWithLabelSpec class methodsFor:'queries'!

supportsLabel
    "answer whether corresponding view instances of the spec class can have labels"

    ^ true


! !

!ViewWithLabelSpec methodsFor:'accessing'!

adjust
    "return the value of the instance variable 'adjust' (automatically generated)"

    ^ adjust ? (self defaultAdjust)
!

adjust:something
    "set the value of the instance variable 'adjust' (automatically generated)"

    something isNil ifTrue:[
        adjust := (self defaultAdjust)
    ] ifFalse:[
        adjust := something asSymbol.
    ]
!

alignment
    ^ self adjust
!

alignment:aSymbol
    self adjust:aSymbol
!

defaultAdjust
    ^ #center
!

formatString
    ^ formatString
!

formatString:something
    formatString := something.
!

hasCharacterOrientedLabel
    "return the value of the instance variable 'hasCharacterOrientedLabel' (automatically generated)"

    ^ hasCharacterOrientedLabel ? true
!

hasCharacterOrientedLabel:something
    "set the value of the instance variable 'hasCharacterOrientedLabel' (automatically generated)"

    hasCharacterOrientedLabel := something.
!

hasImageOrientedLabel
    ^ self hasCharacterOrientedLabel not

!

hasImageOrientedLabel:something
    self hasCharacterOrientedLabel:something not.

!

label
    "return the label"

    ^ label

    "Modified: 4.9.1995 / 18:46:12 / claus"
!

label:aString
    "set the label"

    label := aString.

    "Modified: 4.9.1995 / 18:46:12 / claus"
!

multiLineLabel
    "specifies if the label string has '\' to be xlated to return"

    ^ multiLineLabel ? false
!

multiLineLabel:aBoolean
    "specifies if the label string has '\' to be xlated to return"

    multiLineLabel := aBoolean
!

resizeForLabel
    "return the value of the instance variable 'resizeForLabel' (automatically generated)"

    ^ resizeForLabel ? false

    "Created: 26.3.1997 / 17:27:20 / cg"
!

resizeForLabel:something
    "set the value of the instance variable 'resizeForLabel' (automatically generated)"

    resizeForLabel := something.

    "Created: 26.3.1997 / 17:27:20 / cg"
!

setLabel:aLabel
    "ST-80 compatibility
    "
    self label:aLabel
!

translateLabel
    "return the value of the instance variable 'translateLabel' (automatically generated)"

    ^ translateLabel ? true

    "Created: 28.2.1997 / 12:20:56 / cg"
!

translateLabel:something
    "set the value of the instance variable 'translateLabel' (automatically generated)"

    translateLabel := something.

    "Created: 28.2.1997 / 12:20:56 / cg"
! !

!ViewWithLabelSpec methodsFor:'accessing-channels'!

enableDisableColorChannel
    ^ enableDisableColorChannel
!

enableDisableColorChannel:aspectSelector
    enableDisableColorChannel := aspectSelector
!

labelChannel
    "return the value of the instance variable 'labelChannel' (automatically generated)"

    ^ labelChannel

    "Created: 28.3.1997 / 20:40:48 / cg"
!

labelChannel:something
    "set the value of the instance variable 'labelChannel' (automatically generated)"

    labelChannel := something.

    "Created: 28.3.1997 / 20:40:48 / cg"
! !

!ViewWithLabelSpec methodsFor:'accessing-color & font'!

backgroundColor
    "return backgroundColor"

    ^ backgroundColor

    "Modified: 4.9.1995 / 18:46:12 / claus"
!

backgroundColor:something
    "set backgroundColor"

    backgroundColor := something.

    "Modified: 4.9.1995 / 18:46:12 / claus"
!

foregroundColor
    "return foregroundColor"

    ^ foregroundColor

    "Modified: 4.9.1995 / 18:46:12 / claus"
!

foregroundColor:something
    "set foregroundColor"

    foregroundColor := something.

    "Modified: 4.9.1995 / 18:46:12 / claus"
! !

!ViewWithLabelSpec methodsFor:'building'!

aspectSelectors
    "add more aspect selectors (these generate aspect methods in the definer)"

    |more|

    more := super aspectSelectors.

    labelChannel      notNil ifTrue:[more add:labelChannel].

    ^ more

    "Modified: / 10.2.2000 / 01:24:18 / cg"
!

setAttributesIn:aView with:aBuilder
    "set my attributes to aView"

    |fgClr bgClr hasLabel lbl|

    hasLabel := false.
    (aBuilder isEditing and:[labelChannel notNil])
    ifTrue:[
        (aBuilder applicationClass class whichClassIncludesSelector:labelChannel) notNil ifTrue:[
            lbl := (aBuilder applicationClass perform:labelChannel)
        ] ifFalse:[
            lbl := labelChannel
        ].
        hasLabel := true.
    ] ifFalse:[
        labelChannel isNil ifTrue:[
            lbl := (self getLabel:label translate:translateLabel with:aBuilder).
            hasLabel := true.
        ]
    ].
    hasLabel ifTrue:[
        self multiLineLabel ifTrue:[ lbl := lbl withCRs ].
        aView label:lbl.
    ].

    adjust notNil ifTrue:[aView adjust:adjust].
    super setAttributesIn:aView with:aBuilder.

"/    "/ attention - view should not resize, if it has a layout
"/    savedLayout := aView geometryLayout.
"/    style notNil ifTrue:[self setStyle:style in:aView with:aBuilder].
"/    savedLayout notNil ifTrue:[
"/        aView geometryLayout:savedLayout
"/    ].

    fgClr := foregroundColor.
    fgClr isNil ifTrue:[ aBuilder isEditing ifTrue: [fgClr := Color black]].
    fgClr notNil ifTrue: [aView foregroundColor:(self resolveColor:fgClr ifUnknown:[Color red] with:aBuilder)].

    bgClr := backgroundColor.
    bgClr isNil ifTrue:[ aBuilder isEditing ifTrue: [bgClr := aView class defaultViewBackgroundColor]].
    bgClr notNil ifTrue: [aView backgroundColor:(self resolveColor:bgClr ifUnknown:[Color yellow] with:aBuilder)].

    aView sizeFixed:(self resizeForLabel not).

    "Modified: / 30.10.2001 / 13:58:45 / cg"
!

setChannelsIn:aView with:aBuilder
    "set channels in aView"

    |c|

    super setChannelsIn:aView with:aBuilder.

    aBuilder isEditing ifFalse:[
        labelChannel notNil ifTrue:[
            c := self channel:#labelChannel inBuilder:aBuilder.
            c notNil ifTrue:[aView labelChannel:c].
        ].
        enableDisableColorChannel notNil ifTrue:[
            c := self channel:#enableDisableColorChannel inBuilder:aBuilder.
            c notNil ifTrue:[
                aView 
                    foregroundChannel:
                        (BlockValue
                            with:[:ena | 
                                ena ifTrue:[
                                    Button defaultForegroundColor] 
                                ifFalse:[
                                    Button defaultDisabledForegroundColor]]
                            argument:c).
            ].
        ].
    ].

    "Modified: / 27.7.1998 / 19:32:48 / cg"
!

setColorAttributesIn:v with:aBuilder
    |clr|

    colors notNil ifTrue:[
        clr := colors at:#backgroundColor ifAbsent:nil.
        clr notNil ifTrue:[
            v backgroundColor:clr.
            v enteredBackgroundColor:clr.
            v activeBackgroundColor:clr.
        ].
        clr := colors at:#foregroundColor ifAbsent:nil.
        clr notNil ifTrue:[
            v foregroundColor:clr.
            v perform:#'enteredForegroundColor:' with:clr ifNotUnderstood:nil.
            v perform:#'activeForegroundColor:' with:clr ifNotUnderstood:nil.
        ].
        clr := colors at:#selectionBackgroundColor ifAbsent:nil.
        clr notNil ifTrue:[
            v activeBackgroundColor:clr.
            v enteredBackgroundColor:clr.
        ].
    ].

    "Created: 6.3.1997 / 16:19:31 / cg"
    "Modified: 8.3.1997 / 00:28:09 / cg"
! !

!ViewWithLabelSpec methodsFor:'converting'!

fromLiteralArrayEncoding:aSpecArray
    "read my attributes from aSpecArray"

    super fromLiteralArrayEncoding:aSpecArray.

    label isArray ifTrue:[self breakPoint:#ca. label := label decodeAsLiteralArray].
    foregroundColor notNil ifTrue:[foregroundColor := foregroundColor decodeAsLiteralArray].
    backgroundColor notNil ifTrue:[backgroundColor := backgroundColor decodeAsLiteralArray].
!

skippedInLiteralEncoding
    "define the inst-slots which are skipped when generating a literalArrayEncoding;
     (to skip the ones with default values.)"

    |l|

    l := super skippedInLiteralEncoding asOrderedCollection.

    (label isString and:[label size ~~ 0]) ifFalse:[l add:#label].

    self multiLineLabel == false    ifTrue:[ l add:#multiLineLabel ].
    style                     isNil ifTrue:[ l add:#style ].
    foregroundColor           isNil ifTrue:[ l add:#foregroundColor ].
    backgroundColor           isNil ifTrue:[ l add:#backgroundColor ].
    labelChannel              isNil ifTrue:[ l add:#labelChannel ].
    enableDisableColorChannel isNil ifTrue:[ l add:#enableDisableColorChannel ].
    (formatString isEmptyOrNil) ifTrue:[ l add:#formatString ].
    self adjust == self defaultAdjust ifTrue:[l add:#adjust].

    initiallyInvisible ~~ true ifTrue:[ l add:#initiallyInvisible ].
    "/ translateLabel     ~~ true ifTrue:[ l add:#translateLabel ].

    self hasCharacterOrientedLabel ifTrue:[ l add:#hasCharacterOrientedLabel ].

    resizeForLabel isNil                      ifTrue:[l add:#resizeForLabel].
    ^ l

    "Modified: / 20.6.1998 / 13:41:56 / cg"
! !

!ViewWithLabelSpec methodsFor:'parsing a view'!

fromView:aView callBack:aBlock
    "extract attributes from aView"

    label := aView label.
    label isText ifTrue:[ label := label string ].
    label isString ifTrue:[
        (label includes:(Character cr)) ifTrue:[
            label := label copyReplaceAll:Character cr with:$\.
            multiLineLabel := true.
        ].
    ].
    style := aView font.

    foregroundColor := aView foregroundColor.
    backgroundColor := aView backgroundColor.
    initiallyInvisible := aView isHiddenOnRealize.

    super fromView:aView callBack:aBlock.

    "Modified: / 07-07-2010 / 20:48:30 / cg"
! !

!ViewWithLabelSpec methodsFor:'queries'!

labelSelector
    label notNil ifTrue:[
        label isSymbol ifTrue:[
            ^ label
        ]
    ].
    ^ nil

! !

!ViewWithLabelSpec class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libui/ViewWithLabelSpec.st,v 1.97 2018-05-24 09:32:46 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libui/ViewWithLabelSpec.st,v 1.97 2018-05-24 09:32:46 cg Exp $'
! !

