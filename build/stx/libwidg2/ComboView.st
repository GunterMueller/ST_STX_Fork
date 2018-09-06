"
 COPYRIGHT (c) 1996 by eXept Software AG / Claus Gittinger
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

View subclass:#ComboView
	instanceVariableNames:'field pullDownButton list listHolder listMsg action resizableMenu
		currentIndex comboMenuHolder comboMenuMessage'
	classVariableNames:'DefaultButtonForm ComboButtonForms'
	poolDictionaries:''
	category:'Views-Interactors'
!

!ComboView class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1996 by eXept Software AG / Claus Gittinger
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
    A ComboView combines some field (typically an enterField or Label)
    with a drop down list of default inputs;
    ComboView is abstract, providing protocol common to ComboBoxView and
    ComboListView. See documentation & examples there.

    [author:]
        Claus Gittinger

    [instance variables:]
        currentIndex    Integer     index into the list, that is currently selected

    [see also:]
        PopUpList
        ComboListView ComboBoxView ExtendedComboBox
        PullDownMenu Label EntryField
"
!

examples
"
  see examples in ComboListView and ComboBoxView
"
! !

!ComboView class methodsFor:'defaults'!

buttonForm
    "return the pull-buttons image"

    <resource: #style (#'comboView.downForm' 
                       #'comboView.downFormFile')>

    |fileName form|

    DefaultButtonForm notNil ifTrue:[
        ^ DefaultButtonForm
    ].

    form := StyleSheet at:#'comboView.downForm'.
    form isNil ifTrue:[
        fileName := StyleSheet at:#'comboView.downFormFile' "default:'ComboDn.14.xbm'".
        fileName notNil ifTrue:[
            form := Smalltalk imageFromFileNamed:fileName forClass:self.
            form isNil ifTrue:[
                form := Smalltalk imageFromFileNamed:fileName inPackage:'stx:libwidg'.
            ]
        ].
    ].
    form isNil ifTrue:[
        form  := self defaultButtonForm.
    ].
    form notNil ifTrue:[
        form := DefaultButtonForm := form onDevice:Display.
        ^ form
    ].
    ^ nil

    "Modified: / 28.4.1999 / 12:49:42 / cg"
!

comboButtonFor:aComboView
    <resource: #style (#'comboView.disabledDownForm' 
                       #'comboView.disabledDownFormFile'
                       #'comboView.activeDownFormFile'
                       #'comboView.button.activeForegroundColor'
                       #'comboView.button.activeBackgroundColor'
                       #'comboView.button.activeLevel'
                       #'comboView.button.passiveLevel'  )>

    |pullDownButton fn logo disabledLogo activeLogo enteredLogo lvl clr|

    pullDownButton := ComboBoxButton in:aComboView.
    pullDownButton controller beTriggerOnDown.
    pullDownButton label:(logo := self buttonForm).

    ComboButtonForms isNil ifTrue:[
        ComboButtonForms := IdentityDictionary new.
    ].

    disabledLogo := ComboButtonForms at:disabledLogo ifAbsentPut:[|logo|
        logo := StyleSheet at:#'comboView.disabledDownForm'.

        logo isNil ifTrue:[
            fn := StyleSheet at:#'comboView.disabledDownFormFile'.
            fn notNil ifTrue:[
                logo := Smalltalk imageFromFileNamed:fn forClass:self.
                logo isNil ifTrue:[
                    logo := Smalltalk imageFromFileNamed:fn inPackage:'stx:libwidg'.
                ]
            ]
        ].
        logo
    ].    

    activeLogo := ComboButtonForms at:#activeLogo ifAbsentPut:[|logo|
        logo := StyleSheet at:#'comboView.activeDownForm'.

        logo isNil ifTrue:[
            fn := StyleSheet at:#'comboView.activeDownFormFile'.
            fn notNil ifTrue:[
                logo := Smalltalk imageFromFileNamed:fn forClass:self.
                logo isNil ifTrue:[
                    logo := Smalltalk imageFromFileNamed:fn inPackage:'stx:libwidg'.
                ]
            ]
        ].
        logo
    ].    

    enteredLogo := ComboButtonForms at:#enteredLogo ifAbsentPut:[|logo|
        logo := StyleSheet at:#'comboView.enteredDownForm'.

        logo isNil ifTrue:[
            fn := StyleSheet at:#'comboView.enteredDownFormFile'.
            fn notNil ifTrue:[
                logo := Smalltalk imageFromFileNamed:fn forClass:self.
                logo isNil ifTrue:[
                    logo := Smalltalk imageFromFileNamed:fn inPackage:'stx:libwidg'.
                ]
            ]
        ].    
        logo
    ].

    disabledLogo notNil ifTrue:[
        pullDownButton passiveLogo:logo.
        pullDownButton activeLogo:logo.
        pullDownButton disabledLogo:disabledLogo.
    ].

    pullDownButton showLamp:false.

    activeLogo notNil ifTrue:[
        pullDownButton activeLogo:activeLogo.
        pullDownButton passiveLogo:logo.
        pullDownButton label:logo.
    ].

    enteredLogo notNil ifTrue:[
        pullDownButton enteredLogo:enteredLogo.
    ].

    (lvl := StyleSheet at:#'comboView.button.activeLevel') notNil ifTrue:[
        pullDownButton activeLevel:lvl
    ].
    (lvl := StyleSheet at:#'comboView.button.passiveLevel') notNil ifTrue:[
        pullDownButton passiveLevel:lvl
    ].

    (clr := StyleSheet colorAt:#'comboView.button.activeForegroundColor') notNil ifTrue:[
        pullDownButton activeForegroundColor:clr
    ].
    (clr := StyleSheet colorAt:#'comboView.button.activeBackgroundColor') notNil ifTrue:[
        pullDownButton activeBackgroundColor:clr
    ].

    pullDownButton activeLevel == pullDownButton passiveLevel ifTrue:[
        pullDownButton activeLevel:0.
    ].
    ^ pullDownButton.
!

defaultFont
    "/ for now - should come from the styleSheet

    ^ EditField defaultFont.
    "/ ^ SelectionInListView defaultFont.

    "Created: 4.6.1997 / 15:44:17 / cg"
!

defaultListMessage
    ^ #list

    "Created: 26.2.1997 / 19:34:50 / cg"
!

updateStyleCache
    "flush the forms cache"

    DefaultButtonForm := ComboButtonForms := nil.

    "Created: / 3.11.1997 / 15:28:48 / cg"
! !

!ComboView class methodsFor:'image specs'!

defaultButtonForm
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self defaultButtonForm inspect
     ImageEditor openOnClass:self andSelector:#defaultButtonForm
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'ComboView class defaultButtonForm'
        ifAbsentPut:[(Depth1Image width:12 height:12) bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@')
            colorMapFromArray:#[0 0 0]
            mask:((ImageMask width:12 height:12) bits:(ByteArray fromPackedString:'@@<OC0<OC0=?;3?OG8<OC0XO@@=?;0@O'); yourself); yourself]
! !

!ComboView class methodsFor:'queries'!

isAbstract
    "Return if this class is an abstract class.
     True is returned here for myself only; false for subclasses.
     Abstract subclasses must redefine this again."

    ^ self == ComboView.
! !

!ComboView methodsFor:'accessing-behavior'!

action:aBlock
    "specify, a block, which is evaluated when the lists selection changes.
     This is an additional hook - normally, you would communicate with the model
     alone"

    action := aBlock.

    "Created: 26.7.1996 / 17:44:18 / cg"
    "Modified: 26.2.1997 / 19:37:18 / cg"
!

enabled
    "return true, if it is enabled"
    
    enableChannel isNil ifTrue:[^ true].
    ^ enableChannel value ? true
!

enabled:aBoolean
    "enable/disable components"

    self enableChannel value:aBoolean.

    "Modified: / 30.3.1999 / 14:56:18 / stefan"
!

resizableMenu
    "return true, if the menu is to be resizable.
     This feature is as yet unimplemented."
    
    ^ resizableMenu ? false
!

resizableMenu:aBoolean
    "enable/disable, if the menu is to be resizable.
     This feature is as yet unimplemented."
    
    resizableMenu := aBoolean
! !

!ComboView methodsFor:'accessing-channels'!

enableChannel 
    "return a valueHolder for enable/disable"

    enableChannel isNil ifTrue:[
        self enableChannel:(true asValue).
    ].
    ^ enableChannel

    "Modified: / 30.3.1999 / 16:20:25 / stefan"
! !

!ComboView methodsFor:'accessing-components'!

field
    "return the field (input or label) component.
     For knowledgable users only."

    ^ field

    "Created: / 26.9.1999 / 13:33:15 / cg"
!

menuButton
    "return the menuButton component"

    ^ pullDownButton

    "Created: 28.2.1996 / 15:03:14 / cg"
! !

!ComboView methodsFor:'accessing-contents'!

contents
    "get the contents of my field"

    |m|

    (m := field model) isNil ifTrue:[
        ^ field contents
    ].
    ^ m value

    "Created: / 14-05-1996 / 13:05:16 / cg"
    "Modified: / 21-03-2012 / 12:06:42 / cg"
!

contents:something
    "set the contents of my field; questionable"

    |m|

    (m := field model) notNil ifTrue:[
        m value:something
    ]

    "Created: 14.5.1996 / 13:05:33 / cg"
    "Modified: 26.2.1997 / 16:56:08 / cg"
!

list
    "return the list"

    ^ list

    "Created: / 18.5.1998 / 18:58:08 / cg"
!

list:aList
    "set the list explicitely; used internally or 
     to be send from the outside if no model/listHolder is used."

    list ~~ aList ifTrue:[
        self assert:aList isSequenceable.
        currentIndex := 1.
        list := aList.
    ].
    "maybe some values have been added to / removed from list"
    self enableStateChanged.

    "Modified: / 30.3.1999 / 14:17:38 / stefan"
! !

!ComboView methodsFor:'accessing-look'!

backgroundColor

    ^field backgroundColor
!

backgroundColor:aColor

    field backgroundColor:aColor
!

font:aFont

    super font:aFont.
    self setFieldsFont:aFont.
!

foregroundColor

    ^field foregroundColor
!

foregroundColor:aColor

    field foregroundColor:aColor
! !

!ComboView methodsFor:'accessing-mvc'!

comboMenuHolder
    ^ comboMenuHolder
!

comboMenuHolder:aMenuHolder
    "allows for arbitrary menus to be opened via the combo button"

    comboMenuHolder := aMenuHolder.
!

comboMenuHolder:aMenuHolder comboMenuMessage:aSelectorToTheHolder
    "allows for arbitrary menus to be opened via the combo button"

    comboMenuHolder := aMenuHolder.
    comboMenuMessage := aSelectorToTheHolder.
!

comboMenuMessage
    ^ comboMenuMessage
!

comboMenuMessage:aSelectorToTheHolder
    "allows for arbitrary menus to be opened via the combo button"

    comboMenuMessage := aSelectorToTheHolder.
!

listHolder:aValueHolder
    "set the listHolder.
     If not set, the list is supposed to be set explicitely"

    listHolder notNil ifTrue:[
        listHolder removeDependent:self.
    ].
    listHolder := aValueHolder.
    listHolder notNil ifTrue:[
        aValueHolder addDependent:self.
    ].

    "/ cg: either fetch it here or when realized;
    "/ (otherwise we'd never fetch the list if it won't change later)
"/    realized ifTrue:[
        self getListFromModel.
"/    ]

    "Modified: / 09-11-2007 / 15:59:18 / cg"
!

listMessage:aSymbol
    "define the message selector sent to the model, to fetch
     the list. If not defined, #list is used"

    listMsg := aSymbol

    "Created: 14.2.1997 / 19:16:52 / cg"
    "Modified: 26.2.1997 / 19:33:09 / cg"
!

model:aModel
    "set the model, which is supposed to provide the boxes value.
     If a listMessage was defined, it is also responsible for providing
     the list"

    super model:aModel.

    listHolder isNil ifTrue:[
        self getListFromModel.
    ].
    self getValueFromModel.

    "Modified: 28.2.1997 / 19:08:45 / cg"
! !

!ComboView methodsFor:'change & update'!

update:something with:aParameter from:changedObject

    changedObject == model ifTrue:[
        listHolder isNil ifTrue:[
            self getListFromModel.
        ].
        self getValueFromModel.
        ^ self
    ].
    changedObject == listHolder ifTrue:[
        self getListFromModel.
        ^ self
    ].

    super update:something with:aParameter from:changedObject

    "Created: / 15.7.1996 / 12:26:49 / cg"
    "Modified: / 28.2.1997 / 13:48:51 / cg"
    "Modified: / 30.3.1999 / 14:17:55 / stefan"
! !

!ComboView methodsFor:'event handling'!

enableStateChanged
    "the enable state has changed - pass this to my field and pullDownButton"

    |msg|

    (enableChannel isNil or:[enableChannel value]) ifTrue:[
        msg := #enable
    ] ifFalse:[
        msg := #disable
    ].
    field perform:msg ifNotUnderstood:nil.

    list isEmptyOrNil ifTrue:[
        "/ may only do this, if the list is static or a valueModel. 
        "/ If it is a block, we do not know what value will be returned the next
        "/ time.
        listHolder isBlock ifFalse:[
            msg := #disable
        ].
    ].
    pullDownButton perform:msg ifNotUnderstood:nil.

    "Modified: / 22.2.1999 / 00:47:46 / cg"
    "Modified: / 30.3.1999 / 14:17:10 / stefan"
!

handlesMouseWheelMotion:event inView:aView
    "we handle delegated mousewheel events"

    ^ true
!

keyPress:key x:x y:y
    "pull the menu on space and return keys"

    <resource: #keyboard (#Return)>

    (key == Character space or:[key == #Return]) ifTrue:[
        self pullMenu.
        ^ self.
    ].

    ^ super keyPress:key x:x y:y

    "Modified: / 21.4.1998 / 20:10:05 / cg"
!

mouseWheelMotion:buttonState x:x y:y amount:amount deltaTime:dTime view:delegatingView
    "scroll through the list items"

    self enableChannel value ifFalse:[
        ^ self.
    ].
    
    list isNil ifTrue:[
        self getListFromModel.
        list isEmptyOrNil ifTrue:[
            "nothing to scroll"
            ^ self
        ].
    ].

    self deltaSelect:amount sign negated.
!

processEvent:anEvent
    |evView point x y button|

    "/ only care for buttonpress in my field...
    anEvent isButtonPressEvent ifFalse:[^ false].
    evView := anEvent view.
    evView isNil ifTrue:[^ false].

    button := anEvent state.
    ((button == 1) or:[button == #select]) ifFalse:[
        ^ false
    ].

    (field isNil or:[field shown not]) ifTrue:[
        ^ false
    ].
    (field isKeyboardConsumer and:[field isEnabled]) ifTrue:[
        ^ false
    ].

    x := anEvent x.
    y := anEvent y.

    evView ~~ field ifTrue:[
        (evView isSameOrComponentOf:field) ifFalse:[
            ^ false
        ].
        point := x @ y.
        point := device translatePoint:point fromView:evView toView:field.
        x := point x.
        y := point y.
    ].
    (x between:0 and:field width) ifFalse:[^ false].
    (y between:0 and:field height) ifFalse:[^ false].

    self pullMenu == false ifTrue:[ ^ false ].

    "/ although eaten, we still must care for the focus !!
    self wantsFocusWithButtonPress ifTrue:[
        self windowGroup notNil ifTrue:[
            self windowGroup focusView:self.
"/ Transcript showCR:self windowGroup focusCameByTab.
        ]
    ].
    ^ true
! !

!ComboView methodsFor:'initialization & release'!

destroy
    |wgrp|

    (wgrp := self windowGroup) notNil ifTrue:[
       wgrp removePreEventHook:self.
    ].
    super destroy.
!

initStyle
    super initStyle.

    self borderWidth:(EditField defaultBorderWidth).
    self borderColor:(EditField defaultBorderColor).
!

initialize
    |prefExt leftInset rightInset prefWidth halfSpacing nm lvl|

    super initialize.

    listMsg := self class defaultListMessage.
    aspectMsg := self class defaultAspectMessage.
    changeMsg := self class defaultChangeMessage.

    self initializeField.
    field origin:margin@margin corner:1.0@1.0.
    self shadowColor:(field shadowColor).

    self initializeButton.
    pullDownButton pressAction:[self pullMenu].
    prefExt := pullDownButton preferredExtent.
    prefWidth := prefExt x.

    pullDownButton origin:1.0@0.0 corner:1.0@1.0.
    styleSheet is3D ifTrue:[
        halfSpacing := ViewSpacing // 2.
        leftInset := rightInset := prefWidth + halfSpacing.
        (lvl := styleSheet at:#'comboView.level' default:nil) notNil ifTrue:[
            self level:lvl.
            field level:0.
            field rightInset:margin.
        ] ifFalse:[
            pullDownButton rightInset:halfSpacing.
            field leftInset:halfSpacing
        ].
    ] ifFalse:[
        leftInset := prefWidth + pullDownButton borderWidth.
        rightInset := prefWidth.
    ].

    "/ what a hack...
    nm := styleSheet name.
    (nm = #win95 or:[nm = #win98 or:[nm = #winXP or:[nm = #st80 or:[nm = #winVista]]]]) ifTrue:[
        field level:0.
        lvl isNil ifTrue:[self level:-1].
        pullDownButton rightInset:0.
        nm ~= #st80 ifTrue:[
            leftInset := (ArrowButton new preferredWidth).
            rightInset := leftInset.
        ].
        field origin:0.0@0.0.
        field leftInset:0.
"/        field topInset:1; bottomInset:1.
"/        nm = #winXP ifTrue:[
"/            self borderWidth:1.
"/            self borderColor:(Color blue lightened).
"/        ].
    ].
    field rightInset:rightInset.
    pullDownButton leftInset:leftInset negated.

    self initialHeight:field preferredHeight + ViewSpacing.
    "
     |b|

     b := ComboBoxView new.
     b list:#('hello' 'world' 'this' 'is' 'st/x').
     b open
    "

    "Created: / 28.2.1996 / 15:03:17 / cg"
    "Modified: / 8.9.1998 / 20:33:22 / cg"
!

initializeButton
    pullDownButton := self class comboButtonFor:self.
    pullDownButton disable.
!

initializeField
    "concrete subclass is responsible to instantiate
     a field widget here.
     For comboList, this will be a label;
     for comboBox, this will be an editfield"
     
    self subclassResponsibility

    "Created: 29.3.1997 / 11:17:14 / cg"
!

realize
    |pullMenuIfClickedOnField wgrp|

    super realize.

    pullMenuIfClickedOnField := 
            styleSheet 
                at:#'comboView.pullMenuIfClickedOnField'
                default:[ OperatingSystem isMSWINDOWSlike ].

    pullMenuIfClickedOnField == true ifTrue:[
        wgrp := self windowGroup.
        wgrp notNil ifTrue:[ wgrp addPreEventHook:self ].
    ].
!

release
    listHolder notNil ifTrue:[
        listHolder removeDependent:self.
        listHolder := nil.
    ].
    super release
! !

!ComboView methodsFor:'menu interaction'!

createPullDownMenuForList:aList
    "pull the menu - triggered from the button"

    |menu index|

    comboMenuHolder notNil ifTrue:[
        menu := (comboMenuHolder perform:comboMenuMessage ? #value). 
        (menu isKindOf:Menu) ifTrue:[
            menu := MenuPanel new menu:menu.
        ]
    ] ifFalse:[
        menu := MenuPanel new.
        menu doAccessCharacterTranslation:false.
        menu labels:aList.
        menu hideOnRelease:false.
        menu backgroundColor: field backgroundColor. 

        index := 1.

        menu do:[:el |
            el value:#select: argument:index.
            index := index + 1.
        ].
        menu receiver:self.
    ].

    menu font:self font.
    menu preferredWidth:self width.

    ^ menu

    "Modified: / 25-03-2014 / 01:21:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

deltaSelect:delta
    "change selection by delta. Wrap at start/end"

    |newIndex|

    list size == 0 ifTrue:[^ self].

    newIndex := currentIndex + delta.
    newIndex > list size ifTrue:[
        newIndex := 1.
    ] ifFalse:[
        newIndex <= 0 ifTrue:[
            newIndex := list size.
        ].
    ].

    self select:newIndex.
!

pullMenu
    "pull the menu - triggered from the button
     returns false if the menu cannot be opened"

    |menu origin opensMenu|

    self getListFromModel.

    opensMenu := ((list notEmptyOrNil or:[comboMenuHolder notNil])
                and:[self enableChannel value]).

    opensMenu ifTrue:[
        menu := self createPullDownMenuForList:list.
        origin := device translatePoint:(0 @ self height) fromView:self toView:nil.
        "/ menu extentChangedFlag:false.
        "/ menu originChangedFlag:false.
        menu showAt:origin resizing:false.
    ].

    pullDownButton turnOff.
    ^ opensMenu

    "Created: / 10.10.2001 / 14:47:25 / cg"
    "Modified: / 10.10.2001 / 15:04:44 / cg"
!

select:anIndex
    "sent from the popped menu, when an item was selected"

    self subclassResponsibility

    "Modified: 27.2.1997 / 15:19:07 / cg"
! !

!ComboView methodsFor:'message delegation'!

doesNotUnderstand:aMessage
    "delegate to my field"

    (field respondsTo:aMessage selector) ifTrue:[
        ^ aMessage sendTo:field
    ].
    ^ super doesNotUnderstand:aMessage

    "Created: 28.2.1996 / 15:03:17 / cg"
    "Modified: 28.2.1996 / 15:06:09 / cg"
!

flash
    "delegate to my field"

    field flash
!

flash:message withColor:flashColor
    "delegate to my field"

    field flash:message withColor:flashColor
!

respondsTo:aSymbol
    "delegate to my field"

    ^ (field respondsTo:aSymbol) or:[super respondsTo:aSymbol]

    "Created: 2.5.1996 / 16:57:34 / stefan"
! !

!ComboView methodsFor:'private'!

getListFromModel
    "fetch the list - either from the listHolder, or
     from the model. If no listMessage was defined, fetch it
     using #list."

    listHolder notNil ifTrue:[
        "/ should blocks be evaluated when the pull-down list is actually needed?    
        "/ listHolder isBlock ifFalse:[
            self list:listHolder value
        "/ ]
    ] ifFalse:[
        (model notNil and:[listMsg notNil]) ifTrue:[
            (model respondsTo:listMsg) ifTrue:[
                self list:(model perform:listMsg)
            ]
        ]
    ].

    "Created: 15.7.1996 / 12:22:56 / cg"
    "Modified: 26.2.1997 / 19:40:58 / cg"
!

getValueFromModel

    "Modified: 15.7.1996 / 12:28:59 / cg"
!

setFieldsFont:aFont
    field font:aFont.
! !

!ComboView methodsFor:'queries'!

preferredExtent
    "compute & return the boxes preferredExtent from the components' preferrences"

    |fieldPref buttonPref m menuPrefX menuPrefY w h|

    "/ If I have an explicit preferredExtent..
    explicitExtent notNil ifTrue:[
        ^ explicitExtent
    ].

    "/ If I have a cached preferredExtent value..
    preferredExtent notNil ifTrue:[
        ^ preferredExtent
    ].

    list isNil ifTrue:[
        self getListFromModel
    ].

    list isNil ifTrue:[
        menuPrefX := menuPrefY := 0
    ] ifFalse:[
        |graphicsDevice|

        graphicsDevice := device ? Screen current.
        m := (MenuView onDevice:graphicsDevice) labels:list.
        menuPrefX := m preferredWidth.

        "/ the menuView returns rubbish ...
"/        menuPrefY := (m preferredExtentForLines:1 cols:10) y
        
        "/ any non-strings ?
        menuPrefY := list 
            inject:('X' heightOn:self) 
            into:[:max :el | el isString ifTrue:[
                                max
                              ] ifFalse:[
                                max max:(el heightOn:self) 
                              ]
                 ].
    ].

    fieldPref := field preferredExtent.
    buttonPref := pullDownButton preferredExtent.

    w := ((fieldPref x max:menuPrefX) max:50) + buttonPref x.
    w := w + margin + margin.
    h := (fieldPref y max:buttonPref y) max:menuPrefY.
    h := h + margin + margin.
    ^ w @ h

    "Created: / 28-02-1996 / 15:03:17 / cg"
    "Modified: / 18-07-2011 / 09:31:31 / cg"
! !

!ComboView methodsFor:'testing'!

isComboView
    ^ true
! !

!ComboView class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

