"
 COPYRIGHT (c) 1998 by eXept Software AG
 COPYRIGHT (c) 2018 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libview2' }"

"{ NameSpace: Smalltalk }"

Object subclass:#MenuItem
	instanceVariableNames:'activeHelpKey enabled label itemValue nameKey translateLabel
		isButton startGroup isVisible hideMenuOnActivated triggerOnDown
		indication submenu submenuChannel submenuProvider shortcutKey
		labelImage accessCharacterPosition argument choice choiceValue
		font auxValue showBusyCursorWhilePerforming keepLinkedMenu
		horizontalLayout sendToOriginator ignoreMnemonicKeys
		ignoreShortcutKeys isMenuSlice uuid receiver'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Support'
!

!MenuItem class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1998 by eXept Software AG
 COPYRIGHT (c) 2018 Jan Vrany
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
    not yet finished MenuItem class - this will eventually replace
    most of the MenuView and PopUpMenu stuff.
    (and hopefully be ST-80 compatible ...)

    For now, only a subset of the full protocol is implemented.

    [author:]
        Claus Gittinger

    [see also:]
        MenuItem
        PopUpMenu
"

! !

!MenuItem class methodsFor:'instance creation'!

label:aString
    "create and return a new menuItem, given a label string"

    ^ self new 
        label:aString;
        yourself

    "Created: / 14-08-1998 / 19:19:14 / cg"
!

label:labelString choice:choiceAspect choiceValue:selectorOrValue
    "create and return a new menuItem, given its label and choice/value.
     This will create a Radio-Button-like item."

    ^ (self new) 
        label:labelString; choice:choiceAspect; choiceValue:selectorOrValue; 
        yourself

    "Modified (format): / 26-04-2012 / 12:06:41 / cg"
!

label:labelString itemValue:selectorOrValue
    "create and return a new menuItem, given its label and value"

    ^ (self new) 
        label:labelString itemValue:selectorOrValue; 
        yourself

    "Created: / 09-09-2012 / 13:21:48 / cg"
!

label:labelString itemValue:selectorOrValue argument:messageArg
    "create and return a new menuItem, given its label and value
     and an argument to be passed with the action"

    ^ (self new) 
        label:labelString; 
        itemValue:selectorOrValue argument:messageArg;
        yourself

    "Created: / 09-09-2012 / 13:22:31 / cg"
!

label:labelString itemValue:selectorOrValue enabled:enabledHolder
    "create and return a new menuItem, given its label, value
     and enabled holder, which can be a boolean, a boolean valueHolder,
     a block or a selector (to be sent to the application)"

    ^ (self new) 
        label:labelString itemValue:selectorOrValue enabled:enabledHolder

    "Created: / 09-09-2012 / 13:23:05 / cg"
!

label:labelString itemValue:selectorOrValue translateLabel:translateLabel
    "create and return a new menuItem, given its label, value and translateLabel flag"

    ^ (self new) 
        label:labelString 
        itemValue:selectorOrValue 
        translateLabel:translateLabel
!

label:labelString submenuChannel:aSymbolOrValueHolder
    "create and return a new menuItem, given its label and value"

    ^ (self new) 
        label:labelString submenuChannel:aSymbolOrValueHolder; 
        yourself
!

label:labelString value:selectorOrValue
    <resource: #obsolete>
    "create and return a new menuItem, given its label and value"

    ^ self label:labelString itemValue:selectorOrValue

    "Created: / 04-08-1998 / 17:34:18 / cg"
!

label:labelString value:selectorOrValue argument:messageArg
    <resource: #obsolete>
    "create and return a new menuItem, given its label and value"

    ^ (self new) 
        label:labelString; value:selectorOrValue; argument:messageArg;
        yourself

    "Created: / 26-04-2012 / 12:06:34 / cg"
!

label:labelString value:selectorOrValue enabled:enabledHolder
    <resource: #obsolete>
    "create and return a new menuItem, given its label and value"

    ^ (self new) 
        label:labelString; value:selectorOrValue; 
        enabled:enabledHolder;
        yourself

    "Created: / 29-10-2010 / 12:21:27 / cg"
!

labeled:aString
    <resource: #obsolete>

    "create and return a new menuItem, given a label string"

    ^ self label:aString

    "Modified: / 26-04-2012 / 12:07:12 / cg"
!

separator
    "create and return a new menuItem for a separator"

    ^ self new 
        label:'-'; translateLabel:false;
        yourself

    "Modified: / 26-04-2012 / 12:07:04 / cg"
! !

!MenuItem class methodsFor:'constants'!

supportedStartGroupValues
    "start group #left #right #conditionalRight ...
     At the moment only #left/nil, #right/#conditionalRight are implemented.

     The meanings are:
        nil                 - default under control of the menu
        #left               - left align
        #right              - place at the right far end
        #conditionalRight   - controlled by a styleSheet variable;
                              like #right under all non-win32 systems,
                              ignored on win32.
                              Use with help-menu, which should be at the far right on some
                              viewStyles, but not under win32."

    ^ #(nil #left #right #conditionalRight)

    "Created: / 16-10-2006 / 13:09:27 / cg"
! !

!MenuItem methodsFor:'Compatibility-ST80'!

enablementSelector:aSymbol
    "dummy for now - for visualworks compatibility (specs)"

    "/ self halt.
!

helpText:aString
    "dummy for now - for visualworks compatibility (specs)"

    activeHelpKey := aString.
!

indicationSelector:aSymbol
    "dummy for now - for visualworks compatibility (specs)"

    "/ self halt.
!

isEnabled:aBoolean
    self enabled:aBoolean

    "Created: / 27.10.1997 / 16:34:55 / cg"
!

shortcutModifiers:something
    "dummy for now - for visualworks compatibility (specs)"

    "/ self halt.
!

value
    "obsolete - please use #itemValue (value is bad: it prevents us from using a valueHolder)"

    ^ itemValue

    "Created: 25.2.1997 / 19:50:14 / cg"
!

value:something
    "obsolete - please use #itemValue: (value is bad: it prevents us from using a valueHolder)"

    itemValue := something

    "Created: 25.2.1997 / 19:11:13 / cg"
! !

!MenuItem methodsFor:'accessing'!

accessCharacterPosition
    "get the index of the access character in the label text or string, or nil if none"
    
    ^ accessCharacterPosition
!

accessCharacterPosition:index 
    "set the index of the access character in the label text or string, or nil if none"
    
    accessCharacterPosition := index
!

activeHelpKey
    "the key used as index (and argument) to the help/flyByHelpSpec"

    ^ activeHelpKey
!

activeHelpKey:aKey
    "the key used as index (and argument) to the help/flyByHelpSpec"

    activeHelpKey := aKey
!

argument
    "get argument given to the value (selector)"
    
    ^ argument
!

argument:something 
    "set argument given to the value (selector)"
    
    |arg|

    (arg := something) notNil ifTrue:[
        arg isString ifTrue:[
            (arg size == 0 or:[ (arg indexOfNonSeparatorStartingAt:1) == 0 ]) ifTrue:[
                arg := nil
            ]
        ]
    ].
    argument := arg
!

auxValue
    "an additional, arbitrary value"

    ^ auxValue
!

auxValue:something 
    "set the auxValue - an arbitrary user value"
    
    auxValue := something
!

choice:something
    choice := something.

    "Created: / 14.8.1998 / 14:32:06 / cg"
!

choiceValue
    ^ choiceValue

    "Created: / 14.8.1998 / 15:39:26 / cg"
!

choiceValue:something
    choiceValue := something.

    "Created: / 14.8.1998 / 15:39:26 / cg"
!

font
    "get the specific font for an item or nil"
    
    ^ font
!

font:aFont 
    "set a specific font for an item"

    font := aFont.
!

hierarchicalUUID

    ^ self uuid
!

horizontalLayout
    "by default, submenus have a vertical layout;
     if true, the submenu has a horizontal layout."
    
    ^ horizontalLayout ? false
!

horizontalLayout:aBoolean 
    "by default, submenus have a vertical layout;
     if true, the submenu has a horizontal layout."
    
    horizontalLayout := aBoolean.
!

ignoreMnemonicKeys
    "if true, mnemonic (access character) in the submenus under the item are ignored;
     Set this to speedup accelerator key processing for slow dynamci menus.
     The default is set to false"
    
    ^ ignoreMnemonicKeys ? false

    "Modified (comment): / 08-09-2011 / 04:30:19 / cg"
!

ignoreMnemonicKeys:aBoolean 
    "if true, mnemonic (access character) in the submenus under the item are ignored;
     Set this to speedup accelerator key processing for slow dynamci menus.
     the default is set to false"
    
    ignoreMnemonicKeys := aBoolean.

    "Modified (comment): / 08-09-2011 / 04:52:23 / cg"
!

ignoreShortcutKeys
    "if true, shortcutKeys (accelerators) in the submenus under the item are ignored;
     the default is set to false"
    
    ^ ignoreShortcutKeys ? false
!

ignoreShortcutKeys:aBoolean 
    "if true, shortcutKeys (accelerators) in the submenus under the item are ignored;
     the default is set to false"
    
    ignoreShortcutKeys := aBoolean.
!

indication
    "value of the items on/off indicator (CheckToggle).
     Usually a valueHolder"
    
    ^ indication

    "Created: 25.2.1997 / 20:59:28 / cg"
!

indication:someValueHolder 
    "value of the items on/off indicator (CheckToggle).
     someValueHolder is usually a value holder"
    
    indication := someValueHolder.

    "Created: 25.2.1997 / 20:59:28 / cg"
!

isMenuSlice:aBoolean
    isMenuSlice := aBoolean.
!

isVisible
    "a visibility holder; either a block, boolean or value holder.
     If the menu is permanently visible, it should be a valueHolder,
     as the value is otherwise only checked for before the menu is opened"

    ^ isVisible ? true
!

isVisible:something
    "a visibility holder; either a block, boolean or value holder.
     If the menu is permanently visible, it should be a valueHolder,
     as the value is otherwise only checked for before the menu is opened"

    isVisible := something
!

itemValue
    "the item's action; if it is a block, that is evaluated;
     if a symbol, that message is sent to the menu's receiver"

    ^ itemValue

    "Created: 25.2.1997 / 19:50:14 / cg"
!

itemValue:aBlockOrSymbol
    "set the item's action; if it is a block, that is evaluated;
     if a symbol, that message is sent to the menu's receiver"

    itemValue := aBlockOrSymbol

    "Created: 25.2.1997 / 19:11:13 / cg"
!

itemValue:selectorOrBlock argument:anArgument
    "set the item's action and an argument; if it is ablock, that is evaluated;
     if a symbol, that message is sent to the menu's receiver"

    itemValue := selectorOrBlock.
    argument := anArgument

    "Created: / 09-09-2012 / 13:05:14 / cg"
!

keepLinkedMenu
    "if true, a linked submenu menu is only computed once (slightly faster),
     but then, the linked menu cannot be dynamic"

    ^ keepLinkedMenu ? false
!

keepLinkedMenu:aBoolean
    "if true, a linked submenu menu is only computed once (slightly faster),
     but then, the linked menu cannot be dynamic"

    keepLinkedMenu := aBoolean ? false.
!

label:aString icon:anImage
    self label:aString.
    self resourceRetriever: (ResourceRetriever icon:anImage string:'')
!

label:labelString itemValue:selectorOrBlock
    label := labelString.
    itemValue := selectorOrBlock

    "Created: / 09-09-2012 / 13:18:34 / cg"
!

label:labelString itemValue:selectorOrBlock argument:something
    "define label, value and an argument to be passed with the action"

    label := labelString.
    itemValue := selectorOrBlock.
    argument := something

    "Created: / 09-09-2012 / 13:19:36 / cg"
!

label:labelString itemValue:selectorOrBlock enabled:enabledHolder
    "define label, value
     and enabled holder, which can be a boolean, a boolean valueHolder,
     a block or a selector (to be sent to the application)"

    label := labelString.
    itemValue := selectorOrBlock.
    enabled := enabledHolder
!

label:labelString itemValue:selectorOrBlock translateLabel:translateLabelBoolean
    label := labelString.
    itemValue := selectorOrBlock.
    translateLabel := translateLabelBoolean
!

label:labelString submenuChannel:aSymbolOrValueHolder
    label := labelString.
    submenuChannel := aSymbolOrValueHolder
!

labelImage
    ^ labelImage
!

labelImage:something
    labelImage := something.

    "/ VW compatibility: if I have a label also,
    "/ this will become a LabelAndImage.
    something isImage ifTrue:[
        label notNil ifTrue:[
            labelImage := LabelAndIcon icon:labelImage string:label
        ]
    ].
!

nameKey
    ^ nameKey


!

nameKey:aNameKey
    nameKey := aNameKey.


!

rawLabel
    ^ label

    "Created: 25.2.1997 / 19:48:16 / cg"
!

rawLabel:aString
    label := aString

    "Created: 25.2.1997 / 19:11:02 / cg"
!

receiver
    "Returns an object that will be used to resolve 'aspects'
     and as a receiver of 'action' selectors."
    ^ receiver

    "Modified (comment): / 05-02-2018 / 12:09:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

receiver:anObject
    "Set an object that will be used to resolve 'aspects'
     and as a receiver of 'action' selectors."
    receiver := anObject.

    "Modified (comment): / 05-02-2018 / 12:09:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

resourceRetriever
    |retriever|

    retriever := labelImage.
    (retriever notNil and:[retriever isKindOf:ResourceRetriever]) ifTrue:[
        ^ retriever
    ].
    ^ nil
!

resourceRetriever:aRetriever
    self labelImage:aRetriever
!

shortcutKey
    "get the key to press to select the menu item from the keyboard"
    
    ^ shortcutKey
!

shortcutKey:something 
    "set the  key to press to select the menu item from the keyboard"
    
    shortcutKey := something.
!

shortcutKeyCharacter
    "Backward compatibility; same as #shortcutKey.
     get the  key to press to select the menu item from the keyboard"
    
    ^ self shortcutKey
!

shortcutKeyCharacter:something 
    "Backward compatibility; same as #shortcutKey:.
     set the  key to press to select the menu item from the keyboard"
    
    self shortcutKey:something.
!

submenu
    "get the submenu or nil"
    
    ^ submenu value

    "Created: / 25.2.1997 / 20:59:28 / cg"
    "Modified: / 19.6.1998 / 00:33:58 / cg"
!

submenu:aMenu 
    "set the submenu or nil"
    
    (aMenu isValueModel or:[ aMenu isBlock ]) ifTrue:[
        submenuChannel notNil ifTrue:[
            "/ programmers error ?
            "/ how can I decide which one to use if there is both
            "/ a channel and a subMenu ...
            self error:'overwriting submenuchannel' mayProceed:true.
        ].
        submenuChannel := aMenu
    ] ifFalse:[
        submenu := aMenu.
    ]

    "Created: / 25.2.1997 / 20:59:28 / cg"
    "Modified: / 5.2.2000 / 16:53:28 / cg"
!

submenuChannel
    "get the submenuChannel or nil"
    
    ^ submenuChannel
!

submenuChannel:aMenuHolder 
    "set the submenuChannel or nil"
    
    submenuChannel := aMenuHolder.
!

submenuProvider 
    "useful if a sub-menu is plugged in from another application (i.e. when
     a submenu is fetched via a channel AND the top-menus application cannot provide
     it"
    
    ^ submenuProvider

    "Created: / 22-09-2010 / 13:55:55 / cg"
!

submenuProvider:something 
    "useful if a sub-menu is plugged in from another application (i.e. when
     a submenu is fetched via a channel AND the top-menus application cannot provide
     it"
    
    submenuProvider := something.

    "Created: / 22-09-2010 / 13:55:40 / cg"
!

uuid

    ^ uuid
!

uuid:aUUID
    "return my name component to be used for resource-access"

    uuid := aUUID
! !

!MenuItem methodsFor:'accessing-behavior'!

beOff
    "set indication off"

    self indication:false
!

beOn
    "set indication on"

    self indication:true
!

choice
    "return the menu items choice indicator (RadioButton)"

    ^ choice

    "Created: / 14.8.1998 / 14:34:55 / cg"
    "Modified: / 14.8.1998 / 15:11:57 / cg"
!

disable
    enabled := false

    "Created: 25.2.1997 / 19:39:09 / cg"
!

enable
    enabled := true

    "Created: 25.2.1997 / 19:39:00 / cg"
!

enabled
    "returns a boolean, valueHolder or block"

    ^ enabled
!

enabled:enabledHolder
    "enabledHolder can be a boolean, a boolean valueHolder,
     a block or a selector (to be sent to the application)"

    enabled := enabledHolder
!

hideMenuOnActivated
    "hide the menu when the item was activated; the default is true"

    ^ hideMenuOnActivated ? true
!

hideMenuOnActivated:aBool
   "hide the menu when the item was activated; the default is true"

    hideMenuOnActivated := aBool ? true
!

sendToOriginator
    "if true, the message is sent to the originating widget;
     otherwise (the default), it it sent to the receiver/application."

   ^ sendToOriginator ? false
!

sendToOriginator:anBoolean
    "if true, the message is sent to the originating widget;
     otherwise (the default), it it sent to the receiver/application."

    sendToOriginator := anBoolean
!

showBusyCursorWhilePerforming
    "get the flag which controls if a busy cursor is to be shown
     while performing the menu action. Defaults to false."

    ^ showBusyCursorWhilePerforming ? false

!

showBusyCursorWhilePerforming:aBoolean
    "set/clear the flag which controls if a busy cursor is to be shown
     while performing the menu action. Defaults to false."

    showBusyCursorWhilePerforming := aBoolean

!

translateLabel
    "returns true if the label is to be translated.
     The default is true"

    ^ translateLabel ? true
!

translateLabel:aBoolean
    "sets whether label is translated"

    translateLabel := aBoolean
!

triggerOnDown
   "returns true if the action is triggered when pressed.
    The default is false (trigger when released)"

   ^ triggerOnDown ? false
!

triggerOnDown:aBool
   "controls if the action is triggered when pressed or released"

    triggerOnDown := aBool.
! !

!MenuItem methodsFor:'accessing-look'!

icon:anImage
    self resourceRetriever: (ResourceRetriever icon:anImage)
!

isButton
    "returns whether item looks like a Button
    "
    ^ isButton ? false
!

isButton:anBoolean
    "sets whether item looks like a Button
    "
    isButton := anBoolean


!

label
    ^ self filteredLabel "/ label

    "Created: / 25.2.1997 / 19:48:16 / cg"
    "Modified: / 19.6.1998 / 00:02:55 / cg"
!

label:aString
    label := aString

    "Created: 25.2.1997 / 19:55:16 / cg"
!

startGroup
    "start group #left #right #conditionalRight ... or nil
     at the moment only #right and #conditionalRight are implemented"

    ^ startGroup ? #left

    "Modified: / 16-10-2006 / 13:05:52 / cg"
!

startGroup:aSymbol
    "start group #left #right #conditionalRight ...
     at the moment only #right and #conditionalRight are implemented.
     The meanings are:
        nil                 - default under control of the menu
        #left               - left align
        #right              - place at the right far end
        #conditionalRight   - controlled by a styleSheet variable;
                              like #right under all non-win32 systems,
                              ignored on win32.
                              Use with help-menu, which should be at the far right on some
                              viewStyles, but not under win32.
    "

    (self class supportedStartGroupValues includes:aSymbol) ifTrue:[
        startGroup := aSymbol
    ] ifFalse:[
        self warn:('unsupported group: ', aSymbol printString ).
        startGroup := #left
    ]

    "Modified: / 16-10-2006 / 13:09:45 / cg"
! !

!MenuItem methodsFor:'accessing-resource'!

findGuiResourcesIn:aResourceContainerOrApplication
    "setup a resource container
    "
    ^ self findGuiResourcesIn:aResourceContainerOrApplication rememberResourcesIn:nil
!

findGuiResourcesIn:aResourceContainerOrApplication rememberResourcesIn:aValueHolderOrNil
    "resolve national language translations from aResourceContainerOrApplication"

    |retriever m itemFont|

    (aResourceContainerOrApplication isNil or:[self isMenuSlice]) ifTrue:[
        ^ self.
    ].

    "while traversing all the menus, resolve symbolic fonts too"
    itemFont := self font.
    itemFont isSymbol ifTrue:[
        itemFont := aResourceContainerOrApplication resolveFont:itemFont.
        self font:itemFont.
    ].

    (self translateLabel and:[label ~= '-']) ifTrue:[
        label := ResourceRetriever 
                        findResourceLabel:label 
                        in:aResourceContainerOrApplication
                        rememberResourcesIn:aValueHolderOrNil.
    ].

    (retriever := self resourceRetriever) notNil ifTrue:[ 
        retriever findGuiResourcesIn:aResourceContainerOrApplication.
        retriever labelText notNil ifTrue: [retriever labelText:label].
    ].   
    (m := self submenu) notNil ifTrue:[
        m := m value.
        m notNil ifTrue:[
            m findGuiResourcesIn:aResourceContainerOrApplication rememberResourcesIn:aValueHolderOrNil
        ]
    ]

    "Modified: / 18.6.1998 / 16:54:25 / cg"
!

receiver:aReceiver perform:aSelector with:anArgument ifNone:aBlock
    "send the one-arg-message aSelector to the application;
     the result returned from the send or nil is returned
    "
    |result|

    MessageNotUnderstood handle:[:ex|
        ex selector ~~ aSelector ifTrue:[
            ex reject
        ].
        result := aBlock value.
    ] do:[
        aSelector numArgs == 0 ifTrue:[
            result := aReceiver perform:aSelector.
        ] ifFalse:[
            result := aReceiver perform:aSelector with:anArgument.
        ].
    ].
    ^ result
!

resolveSliceMenuItemsIn:aReceiver rememberResourcesIn:aValueHolderOrNil
    |menu|

    self isMenuSlice ifFalse:[
        self error:'not a slice menu' mayProceed:true.
        ^ Array with:self.
    ].

    aReceiver isNil ifTrue:[
        ^ nil
    ].
    menu := self receiver:aReceiver perform:submenuChannel with:argument
        ifNone:[ 
            self receiver:(aReceiver class) perform:submenuChannel with:argument 
                ifNone:[
                    "/ ('MenuItem [info]: no aspect for slice ',submenuChannel) infoPrintCR.
                    nil
                ].
        ].

    menu := menu value.
    menu isNil ifTrue:[^ nil].

    menu isCollection ifTrue:[
        menu := Menu decodeFromLiteralArray:menu.
    ].
    menu findGuiResourcesIn:aReceiver rememberResourcesIn:aValueHolderOrNil.
    ^ menu items

    "Modified: / 27-03-2007 / 11:20:43 / cg"
! !

!MenuItem methodsFor:'converting'!

skippedInLiteralEncoding
    |coll|

    coll := super skippedInLiteralEncoding asOrderedCollection.

    label isNil ifTrue:[ coll add:#label ].
    (translateLabel isNil or:[translateLabel == true or:[#('' '-' '=') includes:label]]) ifTrue:[ coll add:#translateLabel ].
    self isButton ifFalse:[ coll add:#isButton ].
    self triggerOnDown ifFalse:[ coll add:#triggerOnDown ].
    self hideMenuOnActivated ifTrue:[ coll add:#hideMenuOnActivated].
    nameKey isNil ifTrue:[ coll add:#nameKey ].
    (self isVisible isNil) ifTrue:[coll add:#isVisible].
    (startGroup isNil or:[startGroup == #left]) ifTrue:[coll add:#startGroup].
    itemValue isNil ifTrue:[ coll add:#itemValue].
    activeHelpKey isNil ifTrue:[ coll add:#activeHelpKey].
    enabled == true "could be a symbol" ifTrue:[ coll add:#enabled].
    shortcutKey isNil ifTrue:[ coll add:#shortcutKeyCharacter].
    font isNil ifTrue:[ coll add:#font].
    accessCharacterPosition isNil ifTrue:[coll add:#accessCharacterPosition].
    self horizontalLayout ifFalse:[coll add:#horizontalLayout].
    self showBusyCursorWhilePerforming ifFalse:[ coll add:#showBusyCursorWhilePerforming ].
    argument isNil ifTrue:[ coll add:#argument].
    self resourceRetriever isNil ifTrue:[ coll add:#resourceRetriever].
    indication isNil ifTrue:[ coll add:#indication].
    choice isNil ifTrue:[coll add:#choice].
    choiceValue isNil ifTrue:[ coll add:#choiceValue].
    auxValue isNil ifTrue:[ coll add:#auxValue ].
    submenuChannel isNil ifTrue:[ coll add:#submenuChannel].
    self keepLinkedMenu ifFalse:[ coll add:#keepLinkedMenu].
    submenu value isNil ifTrue:[coll add:#submenu ].
    self sendToOriginator ifFalse:[coll add:#sendToOriginator ].

    self ignoreShortcutKeys ifFalse:[coll add:#ignoreShortcutKeys ].
    self ignoreMnemonicKeys ifFalse:[coll add:#ignoreMnemonicKeys ].

    self isMenuSlice ifFalse:[coll add:#isMenuSlice].

    ^ coll

    "Modified: / 22-08-2012 / 21:22:20 / cg"
    "Modified: / 05-02-2018 / 12:23:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MenuItem methodsFor:'encoding & decoding'!

fromLiteralArrayEncoding:aLiteralEncodedArray
    "read my contents from a aLiteralEncodedArray"

    |selector value retriever|

    2 to:aLiteralEncodedArray size by:2 do:[:i |
        selector := aLiteralEncodedArray at:i.
        value    := (aLiteralEncodedArray at:i+1).
        selector == #argument: ifFalse:[
            value := value decodeAsLiteralArray
        ].
        self perform:selector with:value
    ].
    "/ kludge in case someone forgets to call findGUIResourcesIn:
    (retriever := self resourceRetriever) notNil ifTrue:[ 
        retriever labelText notNil ifTrue: [retriever labelText: label].
    ].   

    "
     #( #MenuItem #rawLabel: 'left' #nameKey: 'identifier'  #value: #left )
         decodeAsLiteralArray
    "

    "Modified: / 4.2.2000 / 12:50:28 / cg"
! !

!MenuItem methodsFor:'printing & storing'!

printOn:aStream
    aStream nextPutAll:self classNameWithArticle.
    aStream nextPutAll:'('.
    aStream nextPutAll:label storeString.
    aStream nextPutAll:')'
! !

!MenuItem methodsFor:'private-accessing'!

filteredLabel
    "return the label without any &-chars"

    |rawLabel l in out c emp e|

    rawLabel := self rawLabel.
    rawLabel isString ifFalse:[^ rawLabel].

    "/ be careful to preserve any emphasis ...
    "/ bad kludge ...
    rawLabel isText ifTrue:[
        emp := RunArray new.
    ].

    out := WriteStream on:''.
    in := rawLabel readStream.
    [in atEnd] whileFalse:[
        emp notNil ifTrue:[
            e := rawLabel emphasisAt:(in position + 1).
        ].
        c := in next.
        c bitsPerCharacter > out collection bitsPerCharacter ifTrue:[
            out setCollection:(c stringSpecies fromString:out collection).
        ].
        c == $& ifTrue:[
            in peek == $& ifTrue:[
                out nextPut:c.
                emp notNil ifTrue:[
                    emp add:e
                ]
            ]
        ] ifFalse:[
            out nextPut:c.
            emp notNil ifTrue:[
                emp add:e
            ]
        ]
    ].
    l := out contents.
    emp notNil ifTrue:[
        ^ Text string:l emphasisCollection:emp
    ].
    ^ l.

    "Created: / 19.6.1998 / 00:02:10 / cg"
    "Modified: / 20.6.1998 / 17:15:18 / cg"
! !

!MenuItem methodsFor:'queries'!

hasChoice
    "test whether choice exists
    "
  ^ self choice notNil

    "Created: / 14.8.1998 / 14:34:29 / cg"
!

hasIndication
    "test whether indication on/off exists
    "
    ^ self indication notNil

    "Modified: / 28-10-2010 / 23:30:52 / cg"
!

hasSubmenu
    ^ self submenu notNil

    "Created: 25.2.1997 / 20:56:20 / cg"
!

isEnabled
    ^ enabled value ? true

    "Created: 25.2.1997 / 19:39:17 / cg"
!

isHidden
    "not yet supported"

    ^ false

    "Created: / 27.10.1997 / 15:13:43 / cg"
!

isMenuItem
    ^ true
!

isMenuSlice
    "returns true if the menu is a slice buildin its items
     into its container menu
    "
    ^ submenuChannel notNil and:[isMenuSlice == true].
!

isOff
    "test whether indication on/off exists and is off
    "
    |indication|

    indication := self indication.
    ^ indication value == false

    "Modified: / 28-10-2010 / 23:30:57 / cg"
!

isOn
    "test whether indication on/off exists and is on
    "
    |indication|

    indication := self indication.
    ^ indication value == true

    "Modified: / 28-10-2010 / 23:31:02 / cg"
!

isSeparatorItem
    ^ #('' '-' '=') includes:label

    "Created: 25.2.1997 / 19:39:17 / cg"
! !

!MenuItem methodsFor:'utilities'!

replaceArgument: oldValue with: newValue

    "Recusively Replace argument in menu items where
     current argument is equal to oldValue by newValue"

    argument = oldValue ifTrue:[
        argument := newValue.
    ].
    submenu notNil ifTrue:[
        submenu replaceArgument: oldValue with: newValue
    ].

    "Created: / 12-10-2011 / 20:12:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MenuItem class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

