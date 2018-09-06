"
 COPYRIGHT (c) 1998 by eXept Software AG
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

View subclass:#ExtendedComboBox
	instanceVariableNames:'menuButton menuField menuWrapper adjust menuWidgetHolder
		menuWidget menuHeight openAction isReadOnly closeOnSelect
		menuExtent usePreferredWidthForMenu hasHorizontalScrollBar
		hasVerticalScrollBar miniScrollerHorizontal miniScrollerVertical
		autoHideScrollBars'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Interactors'
!

PopUpView subclass:#MenuWrapper
	instanceVariableNames:'comboBox widget lastPointerView implicitGrabView eventHandler
		resizeCursor restoreCursor'
	classVariableNames:''
	poolDictionaries:''
	privateIn:ExtendedComboBox
!

!ExtendedComboBox class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1998 by eXept Software AG
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
    An ExtendedComboBox looks much like a ComboBox, but allows for any view
    to be popped up (in contrast to a ComboBox, which has a hardWired selectionInList-
    menu).
    The popped view may optionally be decorated with scrollBars.
    As a side effect, an ExtendedComboBox with a SelectionInListView or Menu
    can now be used as a replacement for ComboBoxes when long-lists are to be shown,
    since those can now be scrolled.

    [author:]
        Claus Atzkern

    [see also:]
        ComboBox ComboView
        PopUpList SelectionInListView
        ComboListView
        PullDownMenu Label EntryField
"

!

examples
"
    example 1: SelectionInListView
                                                                                [exBegin]
    |top menu widget list sidx|

    top  := StandardSystemView extent:200@35.
    menu := ExtendedComboBox origin:5 @ 5 corner:1.0 @ 0.0 in:top.
    list := #('foo' 'bar' 'baz' 'hjh' 'kk' 'claus' 'gjhj').
    sidx := 4.
    menu bottomInset:(menu preferredExtent y negated).
    menu contents:(list at:sidx).

    widget := SelectionInListView new.
    widget list:list.
    widget doubleClickAction:[:i| menu contents:(widget at:i) ].
    widget selection:sidx.
    menu menuWidget:widget.
    top open.
                                                                                [exEnd]



    example 2: FileSelectionTree
                                                                                [exBegin]
    |top menu widget|

    top  := StandardSystemView extent:200@35.
    menu := ExtendedComboBox origin:5 @ 5 corner:1.0 @ 0.0 in:top.
    menu bottomInset:(menu preferredExtent y negated).

    widget := FileSelectionTree new.
    widget directory:(Filename homeDirectory).

    widget doubleClickAction:[:i||n|
        n := widget selectedNode.
        n isDirectory ifFalse:[menu contents:(n pathName)]
    ].
    menu menuHeight:400.
    menu menuWidget:widget.
    top  open.
                                                                                [exEnd]



    example 3: SelectionInTreeView
                                                                                [exBegin]
    |top menu widget|

    top  := StandardSystemView extent:200@35.
    menu := ExtendedComboBox origin:5 @ 5 corner:1.0 @ 0.0 in:top.
    menu bottomInset:(menu preferredExtent y negated).
    menu contents:'foo'.

    widget := SelectionInTreeView new.
    widget root:(TreeItem newAsTreeFromSmalltalkClass:Object).

    widget doubleClickAction:[:i||n|
        n := widget selectedNode.
        n hasChildren ifFalse:[menu contents:(n name)]
    ].
    menu menuHeight:300.
    menu menuWidget:widget.
    top  open.
                                                                                [exEnd]

    example 3: Funny
                                                                                [exBegin]
    |top menu widget|

    top  := StandardSystemView extent:250@35.
    menu := ExtendedComboBox origin:5 @ 5 corner:1.0 @ 0.0 in:top.
    menu bottomInset:(menu preferredExtent y negated).
    menu contents:'lets do the timeWarp again...'.

    widget := ClockView new.
    menu menuHeight:[widget width].
    menu menuWidget:widget.
    top open.
                                                                                [exEnd]


    example 3: Funny - again 
               (use widgets pref-width; even if the combo-box is smaller)
                                                                                [exBegin]
    |top menu widget|

    top  := StandardSystemView extent:80@35.
    menu := ExtendedComboBox origin:5 @ 5 corner:1.0 @ 0.0 in:top.
    menu bottomInset:(menu preferredExtent y negated).
    menu contents:'time...'.

    widget := ClockView new.
    menu menuWidget:widget.
    menu usePreferredWidthForMenu:true.
    top open.
                                                                                [exEnd]


    example 4: Funny - again 
               (use widgets pref-width; even if the combo-box is smaller,
                adjust the height for the width)
                                                                                [exBegin]
    |top menu widget|

    top  := StandardSystemView extent:80@35.
    menu := ExtendedComboBox origin:5 @ 5 corner:1.0 @ 0.0 in:top.
    menu bottomInset:(menu preferredExtent y negated).
    menu contents:'time...'.

    widget := ClockView new.
    menu menuWidget:widget.
    menu usePreferredWidthForMenu:true.
    menu menuHeight:[widget width].
    top open.
                                                                                [exEnd]

    example 5: Subcanvas with a spec
                                                                                [exBegin]
    |top menu widget list sidx spec|

    spec :=  #(#FullSpec
          #window: 
           #(#WindowSpec
              #name: 'Define Color'
              #layout: #(#LayoutFrame 13 0 29 0 352 0 159 0)
              #label: 'Define Color'
              #min: #(#Point 340 110)
              #max: #(#Point 1152 900)
              #bounds: #(#Rectangle 13 29 353 160)
              #usePreferredExtent: false
          )
          #component: 
           #(#SpecCollection
              #collection: 
               #(
                 #(#VerticalPanelViewSpec
                    #name: 'VerticalPanel1'
                    #layout: #(#LayoutFrame 0 0.0 0 0.0 58 0 -40 1.0)
                    #component: 
                     #(#SpecCollection
                        #collection: 
                         #(
                           #(#LabelSpec
                              #name: 'RedLabel'
                              #label: 'Red:'
                              #translateLabel: true
                              #adjust: #right
                              #extent: #(#Point 58 26)
                          )
                           #(#LabelSpec
                              #name: 'GreenLabel'
                              #label: 'Green:'
                              #translateLabel: true
                              #adjust: #right
                              #extent: #(#Point 58 27)
                          )
                           #(#LabelSpec
                              #name: 'BlueLabel'
                              #label: 'Blue:'
                              #translateLabel: true
                              #adjust: #right
                              #extent: #(#Point 58 26)
                          )
                        )
                    )
                    #horizontalLayout: #fit
                    #verticalLayout: #fitSpace
                    #horizontalSpace: 3
                    #verticalSpace: 3
                )
                 #(#VerticalPanelViewSpec
                    #name: 'VerticalPanel2'
                    #layout: #(#LayoutFrame 60 0 0 0.0 -160 1.0 -40 1.0)
                    #component: 
                     #(#SpecCollection
                        #collection: 
                         #(
                           #(#SliderSpec
                              #name: 'RedSlider'
                              #tabable: true
                              #model: #red
                              #orientation: #horizontal
                              #stop: 255
                              #step: 1
                              #backgroundColor: #(#Color 100.0 0.0 0.0)
                              #extent: #(#Point 118 16)
                          )
                           #(#SliderSpec
                              #name: 'GreenSlider'
                              #tabable: true
                              #model: #green
                              #orientation: #horizontal
                              #stop: 255
                              #step: 1
                              #backgroundColor: #(#Color 0.0 100.0 0.0)
                              #extent: #(#Point 118 16)
                          )
                           #(#SliderSpec
                              #name: 'BlueSlider'
                              #tabable: true
                              #model: #blue
                              #orientation: #horizontal
                              #stop: 255
                              #step: 1
                              #backgroundColor: #(#Color 0.0 0.0 100.0)
                              #extent: #(#Point 118 16)
                          )
                        )
                    )
                    #horizontalLayout: #fit
                    #verticalLayout: #spreadSpace
                    #horizontalSpace: 3
                    #verticalSpace: 3
                )
                 #(#VerticalPanelViewSpec
                    #name: 'VerticalPanel3'
                    #layout: #(#LayoutFrame -158 1 0 0.0 -120 1 -40 1.0)
                    #component: 
                     #(#SpecCollection
                        #collection: 
                         #(
                           #(#InputFieldSpec
                              #name: 'RedField'
                              #model: #red
                              #type: #numberInRange
                              #numChars: 3
                              #minValue: 0
                              #maxValue: 255
                              #extent: #(#Point 38 20)
                          )
                           #(#InputFieldSpec
                              #name: 'GreenField'
                              #model: #green
                              #type: #numberInRange
                              #numChars: 3
                              #minValue: 0
                              #maxValue: 255
                              #extent: #(#Point 38 20)
                          )
                           #(#InputFieldSpec
                              #name: 'BlueField'
                              #model: #blue
                              #type: #numberInRange
                              #numChars: 3
                              #minValue: 0
                              #maxValue: 255
                              #extent: #(#Point 38 20)
                          )
                        )
                    )
                    #horizontalLayout: #fit
                    #verticalLayout: #spreadSpace
                    #horizontalSpace: 3
                    #verticalSpace: 3
                )
                 #(#LabelSpec
                    #name: 'PreviewBox'
                    #layout: #(#LayoutFrame -116 1 0 0.0 -2 1.0 -40 1.0)
                    #label: 'Preview'
                    #translateLabel: true
                    #level: -1
                )
                 #(#HorizontalPanelViewSpec
                    #name: 'HorizontalPanel1'
                    #layout: #(#LayoutFrame 0 0.0 -32 1 0 1.0 0 1.0)
                    #component: 
                     #(#SpecCollection
                        #collection: 
                         #(
                           #(#ActionButtonSpec
                              #name: 'CancelButton'
                              #label: 'Cancel'
                              #translateLabel: true
                              #model: #doCancel
                              #extent: #(#Point 165 26)
                          )
                           #(#ActionButtonSpec
                              #name: 'OKButton'
                              #label: 'OK'
                              #translateLabel: true
                              #model: #doAccept
                              #extent: #(#Point 166 26)
                          )
                        )
                    )
                    #horizontalLayout: #fitSpace
                    #verticalLayout: #centerMax
                    #horizontalSpace: 3
                    #verticalSpace: 3
                )
              )
          )
      ).

    top  := StandardSystemView extent:200@35.
    menu := ExtendedComboBox origin:5 @ 5 corner:1.0 @ 0.0 in:top.
    list := #('foo' 'bar' 'baz' 'hjh' 'kk' 'claus' 'gjhj').
    sidx := 4.
    menu bottomInset:(menu preferredExtent y negated).
    menu contents:(list at:sidx).

    widget := SubCanvas new.
    widget client:(SimpleDialog new).
    widget spec:spec.
    menu menuWidget:widget.
    top open.
                                                                                [exEnd]




"
! !

!ExtendedComboBox methodsFor:'accessing'!

contents
    "return the value of the field (the model's value)"

    model isNil ifTrue:[
        ^ menuField contents
    ].
    ^ model value
!

contents:aValue
    "set the value of the field (the models value)"

    model notNil ifTrue:[
        model value:aValue.
    ]
!

menuExtent
    ^ menuExtent
!

menuExtent:anExtent
    menuExtent := anExtent.

    anExtent notNil ifTrue:[
        menuHeight := nil.
    ] ifFalse:[
        menuHeight := anExtent y max:50.
    ].
    usePreferredWidthForMenu := true.
!

menuWidget
    "get the menu widget or nil"

    ^ menuWidget
!

menuWidget:aWidgetOrFilenameOrSequenceableCollectionOrNil
    "set the menu widget or nil"

    menuWidget ~~ aWidgetOrFilenameOrSequenceableCollectionOrNil ifTrue:[
        menuWrapper notNil ifTrue:[
            self closeMenu.
            menuWrapper destroy.
            menuWrapper := nil.
        ].
        aWidgetOrFilenameOrSequenceableCollectionOrNil isView ifTrue:[
            menuWidget := aWidgetOrFilenameOrSequenceableCollectionOrNil.
            ^ self
        ].

        aWidgetOrFilenameOrSequenceableCollectionOrNil isFilename ifTrue:[
            self setupMenuWidgetForDirectory:aWidgetOrFilenameOrSequenceableCollectionOrNil.
            ^ self
        ].

        aWidgetOrFilenameOrSequenceableCollectionOrNil isSequenceable ifTrue:[
            self setupMenuWidgetForList:aWidgetOrFilenameOrSequenceableCollectionOrNil.
            ^ self
        ].

        aWidgetOrFilenameOrSequenceableCollectionOrNil isNil ifTrue:[
            menuWidget := aWidgetOrFilenameOrSequenceableCollectionOrNil.
            ^ self
        ].

        self error:'invalid menuWidget'
    ].
! !

!ExtendedComboBox methodsFor:'accessing-actions'!

openAction
    "returns the action, called before opening the pulldown menu"

    ^ openAction
!

openAction:aOneArgBlock
    "set the action, called before opening the pulldown menu;
     the argument to the action is the menu widget"

    openAction := aOneArgBlock
! !

!ExtendedComboBox methodsFor:'accessing-behavior'!

closeOnSelect
    "if true, then the comboList is closed when the model value/selection changed"

    ^ closeOnSelect
!

closeOnSelect:aBoolean
    "if true, then the comboList is closed when the model value/selection changed"

    closeOnSelect := aBoolean.
!

disable
    "disable me and my components"

    self closeMenu.

    menuField disable.
    menuButton disable.
!

enable
    "enable me and my components"

    menuField enable.
    menuButton enable
!

enabled
    "returns true, if enabled"

    ^ menuButton enabled
!

readOnly
    "returns true if the menuField is readonly"

    ^ isReadOnly
!

readOnly:aBoolean
    "set the menuField to be readonly or writable"

    isReadOnly == aBoolean ifTrue:[ ^ self ].

    isReadOnly := aBoolean.

    menuField isNil ifTrue:[
        self createEditField.
    ].

    menuField readOnly:aBoolean.
! !

!ExtendedComboBox methodsFor:'accessing-bg & border'!

backgroundColor
    "get the background color of the menu field"

    ^ menuField backgroundColor
!

backgroundColor:aColor
    "set the background color of the menu field"

    menuField backgroundColor:aColor
!

foregroundColor
    "return the foreground color of the menu field"

    ^ menuField foregroundColor
!

foregroundColor:aColor
    "set the foreground color of the menu field"

    menuField foregroundColor:aColor
! !

!ExtendedComboBox methodsFor:'accessing-channels'!

enableChannel 
    "return a valueHolder for enable/disable"

    ^ menuButton enableChannel
!

enableChannel:aValueHolder 
    "set a valueHolder for enable/disable"

    menuField enableChannel:aValueHolder.
    menuButton enableChannel:aValueHolder.
!

menuWidgetHolder
    "returns the menu widget or nil"

    ^ menuWidgetHolder
!

menuWidgetHolder:aHolder
    "returns the menu widget or nil"

    menuWidgetHolder notNil ifTrue:[
        menuWidgetHolder removeDependent:self
    ].
    menuWidgetHolder := aHolder.
    menuWidgetHolder notNil ifTrue:[
        menuWidgetHolder addDependent:self
    ].

    self menuWidget:(menuWidgetHolder value).
!

model:aModel
    "set the model"

    super model:(aModel ? ValueHolder new).
    menuField notNil ifTrue:[ menuField model:model ].
! !

!ExtendedComboBox methodsFor:'accessing-components'!

editor
    ^ menuField
!

menuField
    <resource: #obsolete>

    self obsoleteMethodWarning:'Use #editor for ComboBox compatibility'.
    ^ menuField
!

menuHolder:anObject
    "change the one that provides the menu (via menuMsg)."

    super menuHolder:anObject.
    menuField notNil ifTrue:[  
        menuField menuHolder:anObject
    ]
! !

!ExtendedComboBox methodsFor:'accessing-default menus'!

directory:aDirectory
    <resource: #obsolete>
    "creates a FileSelectionTree as menuWidget - menu, setting the root to the directory"

    self obsoleteMethodWarning:'use #setupMenuWidgetForDirectory:'.
    self setupMenuWidgetForDirectory:aDirectory
!

list:aList
    <resource: #obsolete>
    "creates a SelectionInListView as menuWidget - menu setting the list"

    self obsoleteMethodWarning:'use #setupMenuWidgetForList:'.
    self setupMenuWidgetForList:aList
!

setupMenuWidgetForDirectory:aDirectory
    "creates a FileSelectionTree as menuWidget - setting the root to the directory"

    menuWidget isNil ifTrue:[
        self autoHideScrollBars:false.
        menuWidget := FileSelectionTree new.

        menuWidget doubleClickAction:[:aDummy||node|
            node := menuWidget selectedNode.

            node isDirectory ifFalse:[
                self contents:(node pathName)
            ]
        ]
    ].
    self menuHeight:400.
    menuWidget directory:aDirectory.
!

setupMenuWidgetForList:aList
    "creates a SelectionInListView as menuWidget - menu setting the list"

    menuWidget isNil ifTrue:[
        menuWidget := SelectionInListView onDevice:(device ? Screen current).

        menuWidget doubleClickAction:[:anIndex| 
            self contents:(menuWidget at:anIndex)
        ]
    ].
    menuWidget list:aList
! !

!ExtendedComboBox methodsFor:'accessing-dimension'!

menuHeight
    "get the maximum height of the menu widget or nil"

    ^ menuHeight
!

menuHeight:aHeight
    "set the maximum height of the menu widget or nil"

    menuHeight := aHeight.
!

preferredExtent
    "compute & return the preferredExtent from the components' preferrences"

    |fieldPref buttonPref m w h f|

    "/ If I have an explicit preferredExtent..
    explicitExtent notNil ifTrue:[
        ^ explicitExtent
    ].
    "/ If I have a cached preferredExtent value..
    preferredExtent notNil ifTrue:[
        ^ preferredExtent
    ].

    fieldPref  := menuField preferredExtent.
    buttonPref := menuButton preferredExtent.
    f := 2 + gc font maxHeight + (gc font maxDescent * 2) + (menuField margin * 2).
    h := (fieldPref y max:f) max:buttonPref y.
    m := margin max:1.
    h := h + m + m.

    w := (fieldPref x max:100) + buttonPref x.

    menuWidget notNil ifTrue:[
        f := menuWidget preferredWidth "widthOfContents" + buttonPref x + 20.
        w := f max:w
    ].
    w := w + margin + margin.

    ^ w @ h
!

usePreferredWidthForMenu
    "returns true if the menu is to be opened with its menu preferred width"

    ^ usePreferredWidthForMenu
!

usePreferredWidthForMenu:aBoolean
    "open the menu with its preferred width"

    usePreferredWidthForMenu := aBoolean
! !

!ExtendedComboBox methodsFor:'accessing-look'!

adjust
    "returns the button-adjust symbol, which is one of
         #left  -> left adjust  
         #right -> right adjust"

    ^ adjust ? #right
!

adjust:how
    "set the button-adjust, which must be one of
         #left  -> left adjust  
         #right -> right adjust"

    |rightInset|

    (adjust ~~ how and:[(how == #left or:[how == #right])]) ifTrue:[
        (adjust := how) == #left ifTrue:[
            menuButton origin:0.0@0.0 corner:0.0@1.0
        ] ifFalse:[
            menuButton origin:1.0@0.0 corner:1.0@1.0
        ].

        rightInset := menuButton leftInset.
        menuButton leftInset:(menuButton rightInset).
        menuButton rightInset:rightInset.

        rightInset := menuField leftInset.
        menuField  leftInset:(menuField rightInset).
        menuField rightInset:rightInset.
    ].
!

font:aFont
    "set the font of the menu field"

    super font:aFont.
    menuField font:aFont.
! !

!ExtendedComboBox methodsFor:'accessing-scrollbars'!

autoHideScrollBars
    "set/clear the flag which controls if scrollBars should
     be made invisible dynamically, when there is nothing to scroll
     (and shown if there is)"

    ^ autoHideScrollBars
!

autoHideScrollBars:aBoolean
    "set/clear the flag which controls if scrollBars should
     be made invisible dynamically, when there is nothing to scroll
     (and shown if there is)"

    autoHideScrollBars := aBoolean
!

hasHorizontalScrollBar
    "return the horizontal scrollability.
     If disabled, the horizontal scrollBar is made invisible."

    ^ hasHorizontalScrollBar
!

hasHorizontalScrollBar:aBool
    "enable/disable horizontal scrollability.
     If disabled, the horizontal scrollBar is made invisible."

    hasHorizontalScrollBar := aBool
!

hasVerticalScrollBar
    "return the vertical scrollability.
     If disabled, the vertical scrollBar is made invisible."

    ^ hasVerticalScrollBar
!

hasVerticalScrollBar:aBool
    "enable/disable vertical scrollability.
     If disabled, the vertical scrollBar is made invisible."

    hasVerticalScrollBar := aBool
!

miniScrollerHorizontal
    "return the flag which controls if the horizontal scrollBar is either a miniScroller,
     or a full scrollBar."

    ^ miniScrollerHorizontal
!

miniScrollerHorizontal:aBool
    "control the horizontal scrollBar to be either a miniScroller,
     or a full scrollBar."

    miniScrollerHorizontal := aBool
!

miniScrollerVertical
    "return the flag which controls if the vertical scrollBar is either a miniScroller,
     or a full scrollBar."

    ^ miniScrollerVertical
!

miniScrollerVertical:aBool
    "control the vertical scrollBar to be either a miniScroller,
     or a full scrollBar."

    miniScrollerVertical := aBool
! !

!ExtendedComboBox methodsFor:'change & update'!

update:what with:aPara from:aModel
    "one of my models changed"

    aModel == self model ifTrue:[
        closeOnSelect ifTrue:[
            self closeMenu
        ].
        ^ self
    ].
    aModel == self menuWidgetHolder ifTrue:[
        self menuWidget:(aModel value).
        ^ self
    ].
    super update:what with:aPara from:aModel
! !

!ExtendedComboBox methodsFor:'error handling'!

doesNotUnderstand:aMessage 
    "delegate messages to the widget"
    
    menuWidget notNil ifTrue:[
        ^ aMessage sendTo:menuWidget
    ].
    ^ super doesNotUnderstand:aMessage
! !

!ExtendedComboBox methodsFor:'event handling'!

keyPress:key x:x y:y
    "handle a key press event"

    <resource: #keyboard (#Return)>

    (key == Character space or:[key == #Return]) ifTrue:[
        self enabled ifTrue:[
            self openMenu
        ]
    ] ifFalse:[
        super keyPress:key x:x y:y
    ]
!

processEvent:anEvent
    <resource: #keyboard (#Escape )>

    |evView button point x y|

    anEvent isKeyPressEvent ifTrue:[
        anEvent key == #Escape ifTrue:[
            (menuWrapper notNil and:[menuWrapper realized]) ifTrue:[
                self closeMenu.
                ^ true.
            ]
        ]
    ].

    anEvent isButtonPressEvent ifFalse:[
        ^ false
    ].

    button := anEvent state.
    ((button == 1) or:[button == #select]) ifFalse:[
        ^ false
    ].
    (menuField notNil and:[menuField shown]) ifFalse:[
        ^ false
    ].
    (isReadOnly and:[self enabled]) ifFalse:[
        ^ false
    ].

    evView := anEvent view.
    evView isNil ifTrue:[^ false].

    point := Point x:(anEvent x) y:(anEvent y).

    evView ~~ menuField ifTrue:[
        (evView isSameOrComponentOf:menuField) ifFalse:[
            ^ false
        ].
        point := device translatePoint:point fromView:evView toView:menuField.
    ].
    x := point x.
    (x between:0 and:menuField width) ifFalse:[^ false].

    y := point y.
    (y between:0 and:menuField height) ifFalse:[^ false].

    self openMenu.
    ^ true
! !

!ExtendedComboBox methodsFor:'initialization'!

createEditField
    |nm fieldLevel|

    nm := styleSheet name.

    menuField isNil ifTrue:[
        menuField := EditField in:self.
        menuField borderWidth:0.
    ].
    menuField origin:0.0 @ 0.0 corner:1.0 @ 1.0.

    styleSheet is3D ifTrue:[
        (styleSheet at:'comboView.level' default:nil) notNil ifTrue:[
            fieldLevel := 0.
        ] ifFalse:[
            menuField leftInset:(ViewSpacing // 2).
        ]
    ].

    (nm = #win95 or:[nm = #win98 or:[ nm = #winXP or:[nm = #st80 or:[nm = #winVista]]]]) ifTrue:[
        fieldLevel := 0.
        menuField leftInset:0.
    ].
    fieldLevel := styleSheet at:'comboView.fieldLevel' default:fieldLevel.

    fieldLevel notNil ifTrue:[
        menuField level:fieldLevel.
    ].

    menuButton notNil ifTrue:[ menuField rightInset:(menuButton leftInset negated) ].

    menuField menuHolder:(self menuHolder).

    menuField model:model.
    menuField font:self font.
    self shown ifTrue:[ menuField realize ].
!

destroy
    |wgrp|

    (wgrp := self windowGroup) notNil ifTrue:[
       wgrp removePreEventHook:self.
    ].
    menuWidget notNil ifTrue:[
        menuWidget destroy.
    ].
    self menuWidgetHolder:nil.
    super destroy
!

initStyle
    super initStyle.

    self borderWidth:(EditField defaultBorderWidth).
    self borderColor:(EditField defaultBorderColor).
!

initialize
    "setup defaults"

    |prefExt prefWidth lvl rightInset leftInset halfSpacing nm|

    super initialize.

    closeOnSelect := true.

    menuField isNil ifTrue:[
        self createEditField.
    ].

    self initializeButton.
    menuButton pressAction:[self openMenu].
    prefExt   := menuButton preferredExtent.
    prefWidth := prefExt x.

    menuButton origin:1.0@0.0 corner:1.0@1.0.
    styleSheet is3D ifTrue:[
        halfSpacing := ViewSpacing // 2.
        leftInset := rightInset := prefWidth + halfSpacing.
        (lvl := styleSheet at:#'comboView.level' default:nil) notNil ifTrue:[
            self level:lvl.
"/            menuField level:0.
"/            menuField rightInset:margin.
        ] ifFalse:[
            menuButton rightInset:halfSpacing.
"/            menuField leftInset:margin.
        ].
    ] ifFalse:[
        leftInset := prefWidth + menuButton borderWidth.
        rightInset := prefWidth.
    ].

    "/ what a hack...
    nm := styleSheet name.
    (nm = #win95 or:[nm = #win98 or:[nm = #winXP or:[nm = #st80 or:[nm = #winVista]]]]) ifTrue:[
        lvl isNil ifTrue:[self level:-1].
        menuButton rightInset:0.
        nm ~= #st80 ifTrue:[
            leftInset := (ArrowButton new preferredWidth).
            rightInset := leftInset.
        ].
    ].
    menuButton leftInset:leftInset negated.
    self model:nil.

    adjust                   := #right.
    usePreferredWidthForMenu := false.
    isReadOnly               := false.

    autoHideScrollBars       := true.
    hasHorizontalScrollBar   := true.
    hasVerticalScrollBar     := true.
    miniScrollerHorizontal   := true.
    miniScrollerVertical     := true.

    self readOnly:true.
!

initializeButton
    menuButton := ComboView comboButtonFor:self.
!

realize
    |wgrp pullMenuIfClickedOnField|

    super realize.

    pullMenuIfClickedOnField := styleSheet at:#'comboView.pullMenuIfClickedOnField'
                   default:[ OperatingSystem isMSWINDOWSlike ].

    pullMenuIfClickedOnField == true ifTrue:[
        wgrp := self windowGroup.
        wgrp notNil ifTrue:[ wgrp addPreEventHook:self ].
    ].
!

release
    "release dependencies"

    self menuWidgetHolder:nil.
    super release.
! !

!ExtendedComboBox methodsFor:'queries'!

menuIsScrollable
    "returns true if the menu is scrollable"

    ^ (self hasVerticalScrollBar or:[self hasHorizontalScrollBar])
! !

!ExtendedComboBox methodsFor:'testing'!

isComboView
    ^ true
! !

!ExtendedComboBox methodsFor:'user interaction'!

closeMenu
    "close the menu"

    |id|

    menuWrapper notNil ifTrue:[
        menuWrapper realized ifFalse:[
            (id := menuWrapper id) notNil ifTrue:[
                device unmapWindow:id
            ]
        ] ifTrue:[
           menuWrapper unmap
        ].
"/        menuWrapper windowGroup:nil.
"/        self windowGroup removeView:menuWrapper.
    ].
    menuButton turnOff.
!

openMenu
    "pull the menu - triggered from the button"

    |h w menuOrigin useableExt widgetPrfExt graphicsDevice|

    openAction notNil ifTrue:[
        openAction valueWithOptionalArgument:menuWidget
    ].
    menuWrapper isNil ifTrue:[
        menuWidget isNil ifTrue:[^ self].
        menuWrapper := MenuWrapper onDevice:(device ? Screen current).
        menuWrapper for:menuWidget in:self.
    ].
    menuButton turnOn.

    graphicsDevice := device.
    menuOrigin   := graphicsDevice translatePoint:(0@height) fromView:self toView:nil.
    "/ notice, the position-dependent query: if there is a higher secondary screen,
    "/ this makes a difference in where a popUpMenu is allowed...
    "/ useableExt   := device usableExtent.
    useableExt := graphicsDevice usableWidth @ (graphicsDevice usableHeightAt:menuOrigin).

    menuExtent notNil ifTrue:[
        widgetPrfExt := menuExtent.
    ] ifFalse:[
        widgetPrfExt := menuWrapper preferredExtent.
    ].
    menuHeight isNil ifTrue:[
        menuHeight := (5 + widgetPrfExt y) min:(useableExt y // 2).
    ].

    usePreferredWidthForMenu ifFalse:[
        w := width.
    ] ifTrue:[
        (w := widgetPrfExt x+(menuWrapper borderWidth*2)) <= width ifTrue:[
            "/ w := width
        ] ifFalse:[
            (w + menuOrigin x) > useableExt x ifTrue:[
                menuOrigin x:((useableExt x - w) max:0)
            ]
        ]
    ].
    "/ nice side-effect; set width first, to allow menuHeight
    "/ to be a block computing the height based upon the width.
    "/ (allows for geometry adjustments)

    menuWrapper width:w.
    h := (useableExt y - menuOrigin y - 4) min:(menuHeight value).
    menuWrapper height:h.

    menuWrapper origin:menuOrigin extent:(w@h).
    menuWrapper openModal.
    menuWrapper notNil ifTrue:[
        menuWrapper realized ifTrue:[
            self closeMenu
        ].
    ].

    "Modified: / 10.10.2001 / 14:44:22 / cg"
! !

!ExtendedComboBox::MenuWrapper class methodsFor:'documentation'!

documentation
"
    problem: we have a grab - and get all events;
    to simulate regular behaior inside, we have to synthetically simulate
    focus control and implicit grab on buttonPress.

    [instance variables:]
        comboBox                <ExtendedComboBox>

        widget                  <View>          the widget which contains the menu

        lastPointerView         <View>          view which contained the
                                                mouse pointer.
                                                used for enter/leave event generation.

        implicitGrabView         <View>         view in which button was pressed;
                                                nilled when released (wherever).
                                                If non-nil, all events are forwarded to this
                                                one (for example to scroll with mouse outside the scrollbar)

        eventHandler            <OneArgBlock>   if not nil, the block will
                                                handle all inputEvents

        resizeCursor            <Cursor>        shown for resize handle

        restoreCursor           <Cursor>        default cursor
"
! !

!ExtendedComboBox::MenuWrapper methodsFor:'accessing'!

application
    "return the application, under which this view was opened,
     or nil, if there is no application
    "
    ^ comboBox application

!

clearImplicitGrab
    implicitGrabView := nil
!

preferredExtent
    "compute & return the preferredExtent from the components' preferrences
    "
    ^ (widget preferredExtent max:(widget widthOfContents @ widget heightOfContents))
      + (margin * 2) + 8.
!

widget
    "returns the widget wrapped by the menuView
    "
    ^ widget
! !

!ExtendedComboBox::MenuWrapper methodsFor:'event handling'!

dispatchEvent:event withFocusOn:focusViewOrNil delegate:doDelegate
    "dispatch the event"

    |x y oldGrabber p graphicsDevice|

    eventHandler notNil ifTrue:[
        (eventHandler value:event) ifTrue:[^ self].
    ].

    (event isInputEvent not
    or:[event isPointerEnterLeaveEvent]) ifTrue:[
        super dispatchEvent:event withFocusOn:focusViewOrNil delegate:doDelegate.
        ^ self
    ].

    event isButtonMotionEvent ifTrue:[
        implicitGrabView isNil ifTrue:[
            (self isEventAssignedToResizeArea:event) ifTrue:[
                self setupResizeEventHandler.
                ^ self.
            ].
        ].
    ].

    event isButtonPressEvent ifTrue:[
        x := event x.
        y := event y.

        ((0@0 extent:self extent) containsPoint:(x @ y)) ifFalse:[
            comboBox closeMenu.
            "/ if I took the grab from someone else, this buttonEvent should
            "/ also go to that one ...but not, if it falls into my own ext-comboBox (sigh)
            "/ (example: a sub-ext-box in an ext-box, clicking on the outer boxes menuButton)
            graphicsDevice := device.
            (oldGrabber := graphicsDevice activePointerGrab) notNil ifTrue:[
                p := graphicsDevice translatePoint:(x@y) fromView:self toView:comboBox.
                ((0@0 extent:comboBox extent) containsPoint:p) ifFalse:[        
                    p := graphicsDevice translatePoint:(x@y) fromView:self toView:oldGrabber.
                    event view:oldGrabber.
                    event x:p x.
                    event y:p y.

                    "/ this is a hack
                    oldGrabber class == self class ifTrue:[
                        oldGrabber clearImplicitGrab.
                    ].
                    oldGrabber dispatchEvent:event withFocusOn:focusViewOrNil delegate:doDelegate.
                ].
            ].
            ^  self.
        ]
    ].
    self forwardEvent:event withFocusOn:focusViewOrNil.
!

forwardEvent:ev withFocusOn:focusView
    "handle an event
    "
    |view x y p syntheticEvent|

    "/ situation: we get a buttonPress, set implicitGrab (for scrollbars etc.)
    "/ but never get the buttonRelease, since someone else (a popUp) grabbed the
    "/ pointer in the meantime, and has eaten the release event ... (double-sigh)
    implicitGrabView notNil ifTrue:[
        (ev isButtonReleaseEvent or:[self sensor leftButtonPressed]) ifFalse:[
            implicitGrabView := nil.
        ].
    ].

    ((x := ev x) isNil or:[(y := ev y) isNil]) ifTrue:[
        ^ self
    ].

    implicitGrabView notNil ifTrue:[
        ev isButtonEvent ifTrue:[
            p := device translatePoint:(x@y) fromView:self toView:implicitGrabView.
            ev view:implicitGrabView.
            ev x:p x.
            ev y:p y.
            implicitGrabView dispatchEvent:ev withFocusOn:focusView delegate:false.

            (ev isButtonReleaseEvent "or:[ev isButtonMultiPressEvent]") ifTrue:[
                implicitGrabView := nil.
            ].
            ^ self
        ]
    ].

    ev isKeyPressEvent ifTrue:[
        ev key == #Escape ifTrue:[
            self hideRequest.
            ^ self.
        ].
    ].

    view := self detectViewAtX:x y:y.
    view isNil ifTrue:[
        ^ super dispatchEvent:ev withFocusOn:focusView delegate:false
    ].

    p := device translatePoint:(x@y) fromView:self toView:view.

    ev isButtonPressEvent ifTrue:[
        (view wantsFocusWithButtonPress) ifTrue:[
            view requestFocus.
        ].
        view ~~ self ifTrue:[ "/ can this ever be self ?
            implicitGrabView := view.
        ]
    ].

    ev isButtonMotionEvent ifTrue:[
        lastPointerView ~~ view ifTrue:[
            "/ must generate enter/leave ... (sigh)
            lastPointerView notNil ifTrue:[
                "/ XXX: should be fixed
                syntheticEvent := WindowEvent pointerLeave:0 view:lastPointerView.  
                lastPointerView dispatchEvent:syntheticEvent withFocusOn:nil delegate:false.
            ].
            view notNil ifTrue:[
                syntheticEvent := WindowEvent pointerEnter:0 x:x y:y view:view.
                view dispatchEvent:syntheticEvent withFocusOn:nil delegate:false.
            ].
            lastPointerView := view.
        ].
    ].

    ev view:view.
    ev x:p x.
    ev y:p y.
    view dispatchEvent:ev withFocusOn:focusView delegate:false.

    "Modified: / 10.10.2001 / 13:54:20 / cg"
!

setupResizeEventHandler
    |clickExtent clickPoint|


    self windowGroup showCursor:resizeCursor.

    eventHandler := [:ev|
        ev isButtonEvent ifTrue:[
            clickPoint notNil ifTrue:[
                ev isButtonMotionEvent ifTrue:[ 
                    |offset extent|

                    offset := self sensor mousePoint - clickPoint.
                    extent := (clickExtent + offset) max:(comboBox width)@50.
                    self extent:extent.
                ] ifFalse:[
                    ev isButtonReleaseEvent ifTrue:[
                        comboBox menuExtent:self extent.
                    ].
                    clickPoint := clickExtent := nil.
                ].
            ].

            clickPoint isNil ifTrue:[
                ev isButtonMotionEvent ifTrue:[
                    (self isEventAssignedToResizeArea:ev) ifFalse:[
                        self windowGroup showCursor:restoreCursor.
                        clickPoint := clickExtent := eventHandler := nil.
                    ].
                ].
                ev isButtonPressEvent ifTrue:[  "/ start resize
                    clickPoint  := self sensor mousePoint.
                    clickExtent := self extent.
                ].
            ].
        ].
        ev isInputEvent
    ].
! !

!ExtendedComboBox::MenuWrapper methodsFor:'focus handling'!

wantsFocusWithButtonPress
    "views which do not like to take the keyboard focus
     with buttonPress can do so by redefining this
     to return false"

    ^ false


! !

!ExtendedComboBox::MenuWrapper methodsFor:'initialization'!

for:aWidget in:aReceiver 
    "create a wrapper for a widget and the receiver, an extented comboBox
    "
    |hasScr isAdded|

    comboBox := aReceiver.
    widget   := aWidget.
    hasScr   := aWidget isScrollWrapper.
    isAdded  := false.

    comboBox menuIsScrollable ifTrue:[
        hasScr ifFalse:[
            "/ we have to add the scrooledView to self before
            "/ setting the scrolledView - application should
            "/ derive from my comboBox (build within subCanvas)
            widget := ScrollableView origin:0.0 @ 0.0 corner:1.0 @ 1.0 in:self.
            widget scrolledView:aWidget.

            hasScr := isAdded := true.
        ].
        widget horizontalScrollable:(comboBox hasHorizontalScrollBar).
        widget   verticalScrollable:(comboBox hasVerticalScrollBar).
        widget       horizontalMini:(comboBox miniScrollerHorizontal).
        widget         verticalMini:(comboBox miniScrollerVertical).
        widget   autoHideScrollBars:(comboBox autoHideScrollBars).
    ].

    isAdded ifFalse:[
        widget origin:0.0 @ 0.0 corner:1.0 @ 1.0.
        self add:widget.
    ].
    hasScr ifTrue:[
        widget level:0.
        widget := widget scrolledView.
    ].    
!

hideRequest
    "hide request from windowGroup (i.e. via Escape key).
     Can be redefined in subclasses which don't like this"

    eventHandler := nil.
    comboBox closeMenu.
!

initialize
    super initialize.
    super level:0.
    super borderWidth:1.
    self enableMotionEvents.
!

level:aNumber
!

mapped
    "grab resources (mouse and keyboard)
    "
    eventHandler := nil.

    resizeCursor isNil ifTrue:[
        restoreCursor := self cursor.
        resizeCursor  := Cursor fourWay onDevice:device.
    ].
    super mapped.
    self assignInitialKeyboardFocus.
    widget notNil ifTrue:[widget level:0].
! !

!ExtendedComboBox::MenuWrapper methodsFor:'queries'!

isEventAssignedToResizeArea:ev
    |x y|

    ((x := ev x) notNil and:[(y := ev y) notNil]) ifTrue:[ |evView|
        evView := ev view.
        
        evView ~~ self ifTrue:[ |p|
            p := device translatePoint:(x@y) fromView:evView toView:self.
            x := p x.
            y := p y.
        ].

        (x - width)  abs <= 5 ifTrue:[
            (y - height) abs <= 5 ifTrue:[^ true].
        ].
    ].
    ^ false
!

raiseDeiconified
    ^ self raise

!

type
    ^ nil.


! !

!ExtendedComboBox::MenuWrapper methodsFor:'searching'!

detectViewAtX:x y:y
    "detect view at x@y. if no view is detected or
     the it is my view, nil is returned
    "
    |v|

    (x notNil or:[y notNil]) ifTrue:[
        ((x between:0 and:width) and:[y between:0 and:height]) ifTrue:[
            v := self detectViewAtX:x y:y in:self.
            v ~~ self ifTrue:[^ v].
        ]
    ].
    ^ nil
!

detectViewAtX:x y:y in:aTopView
    "detect view at x@y in a top view; if no view is detected
     the topview is returned
    "
    ^ aTopView detectViewAt:(x@y).

"/ cg: old code was (refactored to use common code)
"/
"/    |subviews|
"/
"/    (subviews := aTopView subViews) notNil ifTrue:[
"/        subviews do:[:v||p|
"/            (    (x between:(v left) and:(v right))
"/             and:[y between:(v top)  and:(v bottom)]
"/            ) ifTrue:[
"/                p := device translatePoint:(x@y) fromView:aTopView toView:v.
"/                ^ self detectViewAtX:p x y:p y in:v.
"/            ]
"/        ]
"/    ].
"/    ^ aTopView

    "Modified: / 10.10.2001 / 13:53:15 / cg"
! !

!ExtendedComboBox class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

