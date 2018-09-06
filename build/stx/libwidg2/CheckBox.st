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
"{ Package: 'stx:libwidg2' }"

"{ NameSpace: Smalltalk }"

HorizontalPanelView subclass:#CheckBox
	instanceVariableNames:'toggleView labelView labelForegroundColor
		disabledLabelForegroundColor disabledLabelEtchedForegroundColor
		foregroundChannel resizeForLabel'
	classVariableNames:'DefaultLabelForegroundColor DefaultDisabledLabelForegroundColor
		DefaultDisabledLabelEtchedForegroundColor CheckToggleLeft'
	poolDictionaries:''
	category:'Views-Interactors'
!

!CheckBox class methodsFor:'documentation'!

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
    CheckBoxes consist of a checkToggle and a label;
    if used without a model, its action block is evaluated
    when toggled (see Toggle for more information).
    Otherwise, a valueHolder on a boolean is the preferred model
    (other models are possible - this may required different aspect
     and/or changeMessage settings; make certain to set those before
     a model is assigned, since the toggle fetches the value when
     a new model is assigned.)

    [author:]
        Claus Gittinger

    [see also:]
        Button CheckToggle
        DialogBox
        ValueHolder
"
!

examples
"
  no-op checkBox without a label:
                                                                        [exBegin]
     |b|

     b := CheckBox new.
     b open
                                                                        [exEnd]


  no-op checkBox:
                                                                        [exBegin]
     |b|

     b := CheckBox new.
     b label:'foo'.
     b open
                                                                        [exEnd]


  combined instance creation & label setup:
                                                                        [exBegin]
     |b|

     b := CheckBox label:'foo'.
     b open
                                                                        [exEnd]


  no-op checkBox, disabled:
                                                                        [exBegin]
     |b|

     b := CheckBox label:'foo'.
     b disable.
     b open
                                                                        [exEnd]


  changing colors
  (a demo only: it is no good style to fight the styleSheet):
                                                                        [exBegin]
     |panel b|

     panel := VerticalPanelView new.

     b := CheckBox label:'foo' in:panel.

     b := CheckBox label:'bar' in:panel.
     b labelView foregroundColor:Color red.

     b := CheckBox label:'baz' in:panel.
     b toggleView activeForegroundColor:Color blue.

     panel open
                                                                        [exEnd]


  using action-blocks:
                                                                        [exBegin]
     |b|

     b := CheckBox label:'check'.
     b action:[:value | Transcript show:'set to: '; showCR:value].
     b open.
                                                                        [exEnd]


  with a model (default ST-80 behavior, sending #value: to the model):
  (see changing value in the inspector)
                                                                        [exBegin]
     |b model|

     model := ValueHolder newBoolean.

     b := CheckBox label:'check'.
     b model:model.
     b open.
     model inspect.
                                                                        [exEnd]


  combined instance creation & model setup:
                                                                        [exBegin]
     |b model|

     model := ValueHolder newBoolean.

     b := CheckBox label:'check' model:model .
     b open.
     model inspect.
                                                                        [exEnd]


  with a model and different aspect & changeSelector
  setting the aspect to nil suppresses fetching the value from the model.
  (using a plug here, for demonstration only):
                                                                        [exBegin]
     |b model|

     model := Plug new.
     model respondTo:#changeCheck: with:[:arg | Transcript showCR:'change to ' , arg printString].
     model respondTo:#value with:[false].

     b := CheckBox label:'check'.
     b aspectMessage:nil; model:model; changeMessage:#changeCheck:.
     b open.
                                                                        [exEnd]


  with an enableChannel
                                                                        [exBegin]
     |b enaToggle enaHolder|

     enaHolder := true asValue.

     enaToggle := Toggle label:'enable'.
     enaToggle model:enaHolder.
     enaToggle open.

     b := CheckBox label:'check'.
     b action:[:value | Transcript show:'set to: '; showCR:value].
     b enableChannel:enaHolder.
     b open.
                                                                        [exEnd]


  with models, one checkBox disabling the others:
                                                                        [exBegin]
     |dialog translator enableChannel val1 val2 val3 eBox box1 box2 box3|

     translator := Plug new.
     translator respondTo:#enableDisable
                with:[
                        enableChannel value
                            ifTrue:[
                                box1 enable.
                                box2 enable.
                                box3 enable.
                            ]
                            ifFalse:[
                                box1 disable.
                                box2 disable.
                                box3 disable.
                            ]
                     ].

     enableChannel := true asValue.
     enableChannel onChangeSend:#enableDisable to:translator.
     val1 := true asValue.
     val2 := false asValue.
     val3 := true asValue.

     dialog := Dialog new.
     dialog addCheckBox:'enable' on:enableChannel.
     dialog addVerticalSpace.
     dialog leftIndent:30.
     box1 := dialog addCheckBox:'value1' on:val1.
     dialog addVerticalSpace.
     box2 := dialog addCheckBox:'value2' on:val2.
     dialog addVerticalSpace.
     box3 := dialog addCheckBox:'value3' on:val3.
     dialog addVerticalSpace.
     dialog addOkButton.

     dialog open.
                                                                        [exEnd]


  multiple checkBoxes on a single model (using different aspects)
                                                                        [exBegin]
     |top panel b model value1 value2|

     value1 := true.
     value2 := false.
     model := Plug new.
     model respondTo:#value1 with:[value1].
     model respondTo:#value1: with:[:val | value1 := val].
     model respondTo:#value2 with:[value2].
     model respondTo:#value2: with:[:val | value2 := val].

     top := DialogBox new.
     top extent:200@300.

     panel := VerticalPanelView new.

     b := CheckBox in:panel.
     b label:'check1'.
     b aspect:#value1; model:model; changeMessage:#value1:.

     b := CheckBox in:panel.
     b label:'check2'.
     b aspect:#value2; model:model; changeMessage:#value2:.

     top addComponent:panel.
     top addAbortButton; addOkButton.
     top openModal.

     top accepted ifTrue:[
         Transcript show:'value1: '; showCR:model value1.
         Transcript show:'value2: '; showCR:model value2.
     ]
                                                                        [exEnd]
"
! !

!CheckBox class methodsFor:'instance creation'!

label:aStringOrImage model:aModel
    "create & return a new checkBox, on aModel (typically a ValueHolder),
     with aStringOrImage as label."

    ^ (self model:aModel) label:aStringOrImage

    "Created: 17.9.1995 / 14:20:58 / claus"
    "Modified: 28.2.1997 / 19:23:59 / cg"
! !

!CheckBox class methodsFor:'defaults'!

updateStyleCache
    "extract values from the styleSheet and cache them in class variables"

    <resource: #style (#'checkBox.labelForegroundColor'
                       #'checkBox.disabledLabelForegroundColor'
                       #'checkBox.disabledLabelEtchedForegroundColor'
                       #'checkBox.toggleLeft')>

    DefaultFont                         := StyleSheet fontAt:'label.font'.
    DefaultLabelForegroundColor         := StyleSheet colorAt:'checkBox.labelForegroundColor'.
    DefaultDisabledLabelForegroundColor := StyleSheet colorAt:'checkBox.disabledLabelForegroundColor'.
    DefaultDisabledLabelForegroundColor isNil ifTrue:[
        DefaultDisabledLabelForegroundColor := StyleSheet colorAt:'button.disabledForegroundColor'.
    ].
    DefaultDisabledLabelEtchedForegroundColor := StyleSheet colorAt:'checkBox.disabledLabelEtchedForegroundColor'.
    DefaultDisabledLabelEtchedForegroundColor isNil ifTrue:[
        DefaultDisabledLabelEtchedForegroundColor := StyleSheet colorAt:'button.disabledEtchedForegroundColor'.
    ].
    CheckToggleLeft                     := StyleSheet at:'checkBox.toggleLeft' default:true

    "
     self updateStyleCache
    "

    "Created: 14.12.1995 / 14:47:22 / cg"
    "Modified: 20.10.1997 / 13:51:30 / cg"
! !

!CheckBox methodsFor:'accessing-behavior'!

action:aBlock
    "set the actionBlock; forwarded to the toggle"

    toggleView action:aBlock

    "Modified: 25.4.1996 / 16:31:19 / cg"
!

enabled
    "return true, if the checkBox is enabled.
     forwarded to toggle"

    ^ toggleView enabled.
!

enabled:aBoolean
    "enable/diable the checkBox; forwarded to toggle & change labels color"

    |clr cursor|

    toggleView enabled:aBoolean.
    self enableStateChanged.
"/    aBoolean ifTrue:[
"/        labelView etchedForegroundColor:nil.
"/        clr := labelForegroundColor.
"/        clr isNil ifTrue:[ clr := labelView foregroundColor ].
"/        cursor := Cursor hand.
"/    ] ifFalse:[
"/        disabledLabelEtchedForegroundColor notNil ifTrue:[ labelView etchedForegroundColor:disabledLabelEtchedForegroundColor ].
"/        clr := disabledLabelForegroundColor.
"/        clr isNil ifTrue:[ clr := toggleView disabledForegroundColor ].
"/        cursor := Cursor normal.
"/    ].
"/    labelView cursor:cursor.
"/    self cursor:cursor.
"/    toggleView cursor:cursor.
"/    labelView foregroundColor:clr.

    "Modified: / 25.4.1996 / 16:31:40 / cg"
    "Created: / 30.3.1999 / 14:54:48 / stefan"
!

pressAction:aBlock
    "set the pressAction; forwarded to the toggle"

    toggleView pressAction:aBlock.

    "Created: 22.9.1995 / 15:54:04 / claus"
    "Modified: 25.4.1996 / 16:31:52 / cg"
!

releaseAction:aBlock
    "set the releaseAction; forwarded to the toggle"

    toggleView releaseAction:aBlock.

    "Created: 22.9.1995 / 15:54:11 / claus"
    "Modified: 25.4.1996 / 16:32:00 / cg"
! !

!CheckBox methodsFor:'accessing-channels'!

backgroundChannel

    ^labelView backgroundChannel
!

backgroundChannel:aChannel

    labelView backgroundChannel: (backgroundChannel := aChannel).
    aChannel onChangeSend:#enableStateChanged to:self.
!

enableChannel
    "return a valueHolder for enable/disable"

    ^ toggleView enableChannel

    "Created: 30.4.1996 / 15:11:13 / cg"
!

enableChannel:aChannel
    "set the enableChannel"

    |wasEnabled|

    wasEnabled := toggleView enabled.
    toggleView enableChannel:aChannel.
    aChannel onChangeSend:#enableStateChanged to:self.

    aChannel value ~~ wasEnabled ifTrue:[
        self enableStateChanged
    ]
!

foregroundChannel

    ^labelView foregroundChannel
!

foregroundChannel:aChannel

    labelView foregroundChannel: (foregroundChannel := aChannel).
    aChannel onChangeSend:#enableStateChanged to:self.

!

labelChannel

    ^labelView labelChannel
!

labelChannel:aChannel
    labelView labelChannel notNil ifTrue:[
        labelView labelChannel removeDependent:self
    ].
    labelView labelChannel: aChannel.
    aChannel notNil ifTrue:[
        aChannel addDependent:self
    ].

! !

!CheckBox methodsFor:'accessing-colors'!

backgroundColor
    "get backgroundColor of the label view"

    ^labelView backgroundColor
!

backgroundColor:aColor
    "set backgroundColor only for myself and the label view"

    super backgroundColor:aColor.
    labelView backgroundColor:aColor.
!

disabledLabelEtchedForegroundColor
    "get the disabledLabelForegroundColor; forwarded to the toggle"

    ^ toggleView disabledEtchedForegroundColor
!

disabledLabelForegroundColor
    "get the disabledLabelForegroundColor; forwarded to the toggle"

    disabledLabelForegroundColor isNil ifTrue:[ ^ toggleView disabledForegroundColor ].
    ^ disabledLabelForegroundColor

    "Created: 16.12.1995 / 19:47:45 / cg"
    "Modified: 22.5.1996 / 13:16:55 / cg"
!

foregroundColor
    "get foregroundColor of the label view"

    ^labelView foregroundColor
!

foregroundColor: foregroundColor
    "set foregroundColor only for the label view"

    labelView foregroundColor: (labelForegroundColor := foregroundColor).
    foregroundChannel notNil ifTrue: [foregroundChannel value: foregroundColor]
!

labelForegroundColor
    "get the labels foregroundColor"

    labelForegroundColor isNil ifTrue:[ ^ labelView foregroundColor ].
    ^ labelForegroundColor

    "Created: 16.12.1995 / 19:47:20 / cg"
    "Modified: 25.4.1996 / 16:33:26 / cg"
!

viewBackground: backgroundColor
    "set backgroundColor"

    labelView backgroundColor: backgroundColor.
    super viewBackground: backgroundColor.
! !

!CheckBox methodsFor:'accessing-components'!

labelView
    "return the labelView; allows manipulation of the
     labels attributes (colors etc.)"

    ^ labelView
!

toggleView
    "return the toggleView; allows manipulation of the
     toggles attributes (colors etc.)"

    ^ toggleView
! !

!CheckBox methodsFor:'accessing-look'!

activeLogo:anImageOrString
    "set the activeLogo; forwarded to the toggle"

    toggleView activeLogo:anImageOrString

    "Created: 22.9.1995 / 15:44:08 / claus"
    "Modified: 25.4.1996 / 16:32:50 / cg"
!

font
    "return the font. Forward from label"

    ^ labelView font

    "Modified: 22.5.1996 / 13:17:07 / cg"
!

font:aFont
    "set the font. Forward to the label & resize myself.
     CAVEAT: with the addition of Text objects,
	     this method is going to be obsoleted by a textStyle
	     method, which allows specific control over
	     normalFont/boldFont/italicFont parameters."

    labelView font:aFont.
    labelView forceResize.
    self layoutChanged.
    self resize.

    "Modified: 22.5.1996 / 13:17:28 / cg"
!

label
    "return the label's logo"

    ^ labelView label

    "Modified: 25.4.1996 / 16:33:08 / cg"
!

label:aStringOrImageOrForm
    "set the logo; forward to label & resize"

    |xlatedLabel|

    xlatedLabel := self defineShortcutAndTranslateLabelStringFrom:aStringOrImageOrForm.
    self isNativeWidget ifTrue:[
        gc drawableId notNil ifTrue:[
            device changeLabel:xlatedLabel in:gc drawableId
        ]
    ].
    labelView label:xlatedLabel.
    self resizeForChangedLabel.
!

passiveLogo:anImageOrString
    "set the passiveLogo; forwarded to the toggle"

    toggleView passiveLogo:anImageOrString

    "Created: 22.9.1995 / 15:44:14 / claus"
    "Modified: 25.4.1996 / 16:33:41 / cg"
!

resizeForLabel
    ^ resizeForLabel ? false
!

resizeForLabel:aBoolean
    resizeForLabel := aBoolean
! !

!CheckBox methodsFor:'accessing-mvc'!

aspectMessage:aspectSymbol
    "set the aspectMessage; forward to label & toggle"

    labelView aspectMessage:aspectSymbol. "/ in case the label updates its logo from the model
    toggleView aspectMessage:aspectSymbol

    "Modified: 28.2.1997 / 19:50:53 / cg"
!

changeMessage:aChangeSelector
    "set the changeMessage; forward to toggle"

    toggleView changeMessage:aChangeSelector

    "Modified: 25.4.1996 / 16:33:55 / cg"
!

model:aModel
    "set the model; forward to label & toggle"

    labelView model:aModel.
    toggleView model:aModel

    "Modified: 25.4.1996 / 16:34:00 / cg"
! !

!CheckBox methodsFor:'accessing-state'!

isOn
    "return true, if the check is on; false otherwise"

    ^ toggleView isOn

    "Modified: 25.4.1996 / 16:34:15 / cg"
!

turnOff
    "turn the check off; forwarded to the toggle"

    toggleView turnOff

    "Modified: 25.4.1996 / 16:32:14 / cg"
!

turnOn
    "turn the check on; forwarded to the toggle"

    toggleView turnOn

    "Modified: 25.4.1996 / 16:32:21 / cg"
! !

!CheckBox methodsFor:'change & update'!

enableStateChanged
    "handle changes on the enableChannel or fg/bg color, change labels color."

    |clr|

    self enabled ifTrue:[
        labelView etchedForegroundColor:nil.

        (foregroundChannel notNil and: [foregroundChannel value notNil])
            ifTrue:  [labelView foregroundChannel: foregroundChannel]
            ifFalse: [labelView foregroundColor:(labelForegroundColor ? (Label defaultForegroundColor))].
        labelForegroundColor := labelView foregroundColor
    ] ifFalse:[
        disabledLabelEtchedForegroundColor notNil ifTrue:[ labelView etchedForegroundColor:disabledLabelEtchedForegroundColor ].
        labelView foregroundChannel: nil
    ].

    toggleView enabled ifTrue:[
        clr := self labelForegroundColor.
        cursor := Cursor hand.
    ] ifFalse:[
        clr := self disabledLabelForegroundColor.
        cursor := Cursor normal.
    ].
    labelView foregroundColor:clr.
    labelView cursor:cursor.
    self cursor:cursor.
    toggleView cursor:cursor.
!

update:something with:aParameter from:changedObject
    changedObject == labelView ifTrue:[
        something == #sizeOfView ifTrue:[
            self resizeForChangedLabel.
            ^ self
        ]
    ].
"/    changedObject == labelView labelChannel ifTrue:[
"/        self resizeForChangedLabel.
"/        ^ self
"/    ].
    super update:something with:aParameter from:changedObject
! !

!CheckBox methodsFor:'event handling'!

invalidate
    super invalidate.
    toggleView invalidate.
    labelView invalidate

    "Created: 1.4.1997 / 13:22:09 / cg"
    "Modified: 6.8.1997 / 18:20:12 / cg"
!

keyPress:aKey x:x y:y
    "forward some key-events to my toggle-button"

    aKey == Character space ifTrue:[
        self hasFocus ifTrue:[
            ^ toggleView toggle
        ]
    ].
    super keyPress:aKey x:x y:y

    "Created: 10.7.1996 / 11:24:16 / cg"
    "Modified: 10.7.1996 / 11:54:52 / cg"
!

performShortcutAction
    toggleView toggle
! !

!CheckBox methodsFor:'focus handling'!

showFocus:explicit
    "the button got the keyboard focus
     (either explicit, via tabbing; or implicit, by pointer movement)
      - change any display attributes as req'd."

    (styleSheet at:#'focusHighlightStyle') == #win95 ifTrue:[
        labelView hasFocus:true.
        labelView invalidate.
    ] ifFalse:[
        super showFocus:explicit
    ]

    "Created: / 17.9.1998 / 14:11:49 / cg"
    "Modified: / 17.9.1998 / 14:19:33 / cg"
!

showNoFocus:explicit
    "the button lost the keyboard focus
     (either explicit, via tabbing; or implicit, by pointer movement)
      - change any display attributes as req'd."

    (styleSheet at:#'focusHighlightStyle') == #win95 ifTrue:[
        labelView hasFocus:false.
        labelView invalidate.
    ] ifFalse:[
        ^ super showNoFocus:explicit
    ]

    "Created: / 17.9.1998 / 14:11:49 / cg"
    "Modified: / 17.9.1998 / 14:19:22 / cg"
! !

!CheckBox methodsFor:'initialization & release'!

defaultCheckToggleClass
    ^ CheckToggle
!

defaultControllerClass
    ^ ToggleController

    "Created: 18.7.1996 / 11:57:01 / cg"
!

initStyle
    "setup viewStyle specifics"

    |graphicsDevice|

    super initStyle.
    graphicsDevice := device.

    DefaultLabelForegroundColor notNil ifTrue:[
        labelForegroundColor := DefaultLabelForegroundColor onDevice:graphicsDevice.
    ].
    DefaultDisabledLabelForegroundColor notNil ifTrue:[
        disabledLabelForegroundColor := DefaultDisabledLabelForegroundColor onDevice:graphicsDevice.
    ].
    DefaultDisabledLabelEtchedForegroundColor notNil ifTrue:[
        disabledLabelEtchedForegroundColor := DefaultDisabledLabelEtchedForegroundColor onDevice:graphicsDevice.
    ].

    "Created: 14.12.1995 / 14:50:03 / cg"
    "Modified: 22.1.1997 / 11:57:03 / cg"
!

initialize
    <resource: #style (#name)>

    |checkToggleClass|

    super initialize.

    self borderWidth:0.
    hLayout := #fixLeftSpace.
    vLayout := #center.

    checkToggleClass := self defaultCheckToggleClass.

    self isNativeWidget ifTrue:[
        toggleView := checkToggleClass new. "/ but not in self - never realized
        labelView := CheckLabel new.        "/ but not in self - never realized
    ] ifFalse:[
        CheckToggleLeft ~~ false ifTrue:[
            "/ toggle first ...
            toggleView := checkToggleClass in:self.
        ].

        labelView := CheckLabel in:self.
        "/ a kludge
        styleSheet name ~~ #motif ifTrue:[
            labelView label:'check'; borderWidth:0.
        ].
        labelView forceResize.
        labelView adjust:#left.
        self initialHeight:labelView preferredHeight + ViewSpacing.

        CheckToggleLeft == false ifTrue:[
            "/ toggle last ...
            toggleView := checkToggleClass in:self.
        ].

        (styleSheet at:'checkBoxStyle' default:styleSheet name) == #motif ifTrue:[
            toggleView activeLogo:nil.
            toggleView passiveLogo:nil.
            toggleView activeLevel:-2.
            toggleView passiveLevel:2.
            toggleView extent:10@10.
            toggleView sizeFixed:true.
        ].

        "/ my controller handles both components
        labelView setController:controller.
        toggleView setController:controller.
        "/ the label can be clicked as well
        labelView cursor:Cursor hand.
    ].

    self cursor:Cursor hand.

    "
     all of my input goes to the toggle
     disabled - normally there is already an outer delegate
    "
"/    self delegate:(KeyboardForwarder toView:toggleView).

    "
     |b|

     b := CheckBox new.
     b label:'foo'.
     b open
    "

    "Modified: / 06-02-2011 / 14:18:53 / cg"
!

release
    "release dependencies"

    |channel|

    toggleView notNil ifTrue:[
        (channel := toggleView enableChannel) notNil ifTrue:[
            channel retractInterestsFor:self
        ]
    ].
    super release
! !

!CheckBox methodsFor:'native widget support'!

beNativeWidget
    super beNativeWidget.
"/    self makeElementsInvisible.
!

makeElementsInvisible
    "when using native widget, my toggle is not visible.
     (it is not destroyed, to keep a place for its attributes,
      and to allow future dynamic switching and snapshot restore on
      a non-native system)"

    toggleView notNil ifTrue:[
        toggleView beInvisible.
    ].
!

nativeWindowType
    "return a symbol describing my native window type
     (may be used internally by the device as a native window creation hint,
      if the device supports native windows)"

    ^ #CheckBox

    "Created: 2.5.1997 / 14:41:00 / cg"
! !

!CheckBox methodsFor:'private'!

resizeForChangedLabel
    labelView forceResize.
    resizeForLabel == true ifTrue:[
        self extent:(self preferredExtent)
    ].
    self layoutChanged.
    self resize.
!

sendChangeMessageWith:aValue
    "redefined to have mimic changes being sent from the toggle
     instead of myself"

    toggleView sendChangeMessageWith:aValue.
    toggleView invalidate.

    "Modified: / 22-10-2010 / 15:53:45 / cg"
! !

!CheckBox methodsFor:'queries'!

preferredExtent
    "compute & return the boxes preferredExtent from the components' sizes"

    "/ If I have an explicit preferredExtent..
    explicitExtent notNil ifTrue:[
        ^ explicitExtent
    ].

    "/ If I have a cached preferredExtent value..
    preferredExtent notNil ifTrue:[
        ^ preferredExtent
    ].

    (labelView isNil or:[labelView label isEmptyOrNil]) ifTrue:[
        ^ super preferredExtent
    ].
    ^ super preferredExtent + (10@0).

"/    prefCheck := toggleView preferredExtent.
"/    prefLabel := labelView preferredExtent.
"/    bw2 := borderWidth * 2.
"/    ^ (prefCheck x + prefLabel x + (3 * ViewSpacing)) @ ((prefCheck y max:prefLabel y) + bw2 + 2)

    "Modified: / 12-01-2008 / 23:27:45 / cg"
! !

!CheckBox class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

