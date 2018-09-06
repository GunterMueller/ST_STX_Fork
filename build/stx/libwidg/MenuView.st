"
 COPYRIGHT (c) 1989 by Claus Gittinger
 COPYRIGHT (c) 2017 Jan Vrany
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libwidg' }"

"{ NameSpace: Smalltalk }"

SelectionInListView subclass:#MenuView
	instanceVariableNames:'selectors args receiver enableFlags disabledFgColor
		disabledEtchedFgColor onOffFlags subMenus subMenuShown superMenu
		checkColor lineLevel lineInset masterView needResize
		hideOnRelease sizeFixed shortKeys maxShortKeyStringLen actions
		checkOnImage checkOffImage blockOfSubMenuShown
		delayedSubmenuHideOrShowAction lastMousePoint'
	classVariableNames:'DefaultCheckColor DefaultViewBackground DefaultForegroundColor
		DefaultBackgroundColor DefaultDisabledForegroundColor
		DefaultDisabledEtchedForegroundColor
		DefaultHilightForegroundColor DefaultHilightBackgroundColor
		DefaultHilightLevel DefaultHilightStyle DefaultHilightFrameColor
		DefaultLineLevel DefaultLineInset DefaultShadowColor
		DefaultLightColor ShowAcceleratorKeys DefaultCheckOnImage
		DefaultCheckOffImage'
	poolDictionaries:''
	category:'Views-Menus'
!

!MenuView class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1989 by Claus Gittinger
 COPYRIGHT (c) 2017 Jan Vrany
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
    Notice:
        MenuView is going to be obsoleted - use Menu & MenuItem,
        and display them in a MenuPanel for new applications.

    a menu view used for both pull-down-menus and pop-up-menus (and also,
    for nonModal menus, such as the OldLaunchers click-menu).
    the action to be performed can be defined either as:

    1) action:aBlockWithOneArg
       which defines a block to be called with the line number (1..n)
       of the selected line.

    2) selectors:selectorArray [args: argArray] [receiver:anObject]
       which defines the messages to be sent to the model or
       receiver. Giving an explicit receiver overrides the model.

    It is also possible to define both actionBlock and selectorArray.

    The wellknown popups are created by wrapping a MenuView into an instance of
    PopUpMenu (read the description of popupmenu).

    menu entries starting with '\c' are check-entries.
    menu entries starting with '\b' are checkBox-entries.
    menu entries starting with '\t' are thumbUp/Down-entries.
    menu entries conisting of '-' alone, are separating lines.
    menu entries conisting of '=' alone, are double separating lines.


    StyleSheet defaults:

        menuFont                    font to use for menus

        menuViewBackground          view background (should be same as menuBackgroundColor)
        menuForegroundColor         foreground color
        menuBackgroundColor         background color

        menuShadowColor             shadow color for 3D effects
        menuLightColor              lightColor for 3D effects
        menuHilightForegroundColor  hilighted items foregroundColor
        menuHilightBackgroundColor  hilighted items backgroundColor

        menuHilightFrameColor       frame arounf hilighted items (or nil, if none)
                                    defaults to selectionHilightFrameColor
        menuHilightLevel            3D level of selected items
        menuHilightStyle            #openwin or nil (special kludge)
        menuSeparatingLineLevel     3D level of sep. lines
        menuSeparatingLineInset     left/right inset of sep. lines
        menuDisabledForegroundColor foreground color of disabled items
        menuCheckColor              color to use for check marks
        menuFont                    font to use

    other values and some defaults are inherited via SelectionInListViews
    styles (i.e. look for selectionForegroundColor ...)

    [author:]
        Claus Gittinger

    [see also:]
        PopUpMenu PullDownMenu
        ClickMenuView
        LineMenu PatternMenu
"
!

examples
"
    See real examples in PopUpMenu & PullDownMenu

    Examples:
	Notice: normally, menuviews are wrapped into either a popup-
	menu or pulldown-menu.
	But they can also be used stand-alone as in the following examples:

									[exBegin]
	|m|
	m := MenuView
		labels:#('foo'
			 'bar'
			 'baz')
		selectors:#(
			    #foo
			    #bar
			    #baz)
		receiver:nil.
	m open
									[exEnd]

									[exBegin]
	|m|
	m := MenuView
		labels:#('foo'
			 'bar'
			 'baz')
		selectors:#foo:
		args:#(1 2 3)   
		receiver:nil.
	m open
									[exEnd]
"
! !

!MenuView class methodsFor:'instance creation'!

forMenu:aTopMenu
    "create and return a new menuView, which will be contained in
     aTopMenus superView"

    aTopMenu isNil ifTrue:[
	^ self new
    ].
    ^ self in:(aTopMenu superView).

    "Created: 5.6.1996 / 11:29:27 / cg"
!

labels:labels
    "create and return a new MenuView. The parent view,
     selectors and receiver should be set later."

    ^ self labels:labels selectors:nil args:nil receiver:nil 
!

labels:labels selector:aSelector args:argArray receiver:anObject for:aTopMenu
    "create and return a new MenuView
     - receiverObject gets message aSelector with argument from
       argArray for ALL entries"

    "OBSOLETE protocol: labels:selectors:args:receiver: knows how to handle a
     single symbol-arg for selectors ..."

    ^ self labels:labels selectors:aSelector args:argArray receiver:anObject in:(aTopMenu superView)
!

labels:labels selector:aSelector args:argArray receiver:anObject in:aTopMenu
    "create and return a new MenuView
     - receiverObject gets message aSelector with argument from
       argArray for all entries"

    "OBSOLETE protocol: labels:selectors:args:receiver: knows how to handle a
     single symbol-arg for selectors ..."

    ^ self labels:labels selectors:aSelector args:argArray receiver:anObject in:aTopMenu
!

labels:labels selectors:selArray
    "create and return a new MenuView. The parent veiw
     and receiver should be set later."

    ^ self labels:labels selectors:selArray args:nil receiver:nil 
!

labels:labels selectors:selArray accelerators:shorties
    "create and return a new MenuView. The parent veiw
     and receiver should be set later."

    ^ self labels:labels selectors:selArray accelerators:shorties args:nil receiver:nil 
!

labels:labels selectors:selArray accelerators:shorties args:argArray receiver:anObject
    "create and return a new MenuView. The parent view
     should be set later."

    ^ (self new) 
	labels:labels
	selectors:selArray
	accelerators:shorties 
	args:argArray 
	receiver:anObject
!

labels:labels selectors:selArray accelerators:shorties args:argArray receiver:anObject for:aTopMenu
    "create and return a new MenuView for a topMenu"

    ^ self labels:labels selectors:selArray accelerators:shorties args:argArray receiver:anObject in:(aTopMenu superView)

    "Created: 5.6.1996 / 16:51:46 / cg"
!

labels:labels selectors:selArray accelerators:shorties args:argArray receiver:anObject in:aView
    "create and return a new MenuView in aView
     - receiverObject gets message from selectorArray with argument
       from argArray"

    ^ (self in:aView) 
	labels:labels 
	selectors:selArray
	accelerators:shorties 
	args:argArray
	receiver:anObject
!

labels:labels selectors:selArray accelerators:shorties receiver:anObject
    "create and return a new MenuView. The parent view
     should be set later."

    ^ self labels:labels selectors:selArray accelerators:shorties args:nil receiver:anObject
!

labels:labels selectors:selArray args:argArray
    "create and return a new MenuView. The parent view
     should be set later."

    ^ self labels:labels selectors:selArray args:argArray
!

labels:labels selectors:selArray args:argArray receiver:anObject
    "create and return a new MenuView. The parent view
     should be set later."

    ^ (self new) 
	labels:labels
	selectors:selArray
	args:argArray 
	receiver:anObject
!

labels:labels selectors:selArray args:argArray receiver:anObject for:aTopMenu
    "create and return a new MenuView for a topMenu"

    ^ self labels:labels selectors:selArray args:argArray receiver:anObject in:(aTopMenu superView)
!

labels:labels selectors:selArray args:argArray receiver:anObject in:aView
    "create and return a new MenuView in aView
     - receiverObject gets message from selectorArray with argument
       from argArray"

    ^ (self in:aView) 
	labels:labels 
	selectors:selArray
	args:argArray
	receiver:anObject
!

labels:labels selectors:selArray receiver:anObject
    "create and return a new MenuView. The parent view
     should be set later."

    ^ self labels:labels selectors:selArray args:nil receiver:anObject
!

labels:labels selectors:selArray receiver:anObject for:aTopMenu
    ^ self labels:labels selectors:selArray args:nil receiver:anObject for:aTopMenu
!

labels:labels selectors:selArray receiver:anObject in:aView
    "create and return a new MenuView in aView
     - receiverObject gets message from selectorArray without argument"

    ^ self labels:labels selectors:selArray args:nil receiver:anObject in:aView
! !

!MenuView class methodsFor:'defaults'!

showAcceleratorKeys
    ^ ShowAcceleratorKeys ~~ false

    "Created: 2.3.1996 / 14:52:34 / cg"
    "Modified: 2.3.1996 / 14:54:58 / cg"
!

showAcceleratorKeys:aBoolean
    ShowAcceleratorKeys := aBoolean

    "Created: 2.3.1996 / 14:52:43 / cg"
!

updateStyleCache
    "extract values from the styleSheet and cache them in class variables"

    <resource: #style (#'menu.foregroundColor'     #'menu.backgroundColor'
                       #'menu.viewBackground'
                       #'menu.shadowColor'         #'menu.lightColor'
                       #'menu.hilightForegroundColor' #'menu.hilightBackgroundColor'
                       #'menu.hilightFrameColor'   #'selection.hilightFrameColor'
                       #'menu.hilightLevel'        #'menu.hilightStyle'
                       #'menu.separatingLineLevel' #'menu.separatingLineInset'
                       #'menu.disabledForegroundColor' 
                       #'menu.checkColor' #'menu.checkOnImage' #'menu.checkOffImage'
                       #'menu.font' #'menu.showAccelerators')>

    DefaultViewBackground := StyleSheet colorAt:#'menu.viewBackground'.
    DefaultForegroundColor := StyleSheet colorAt:#'menu.foregroundColor'.
    DefaultBackgroundColor := StyleSheet colorAt:#'menu.backgroundColor'.
    DefaultShadowColor := StyleSheet colorAt:#'menu.shadowColor'.
    DefaultLightColor := StyleSheet colorAt:#'menu.lightColor'.
    DefaultHilightForegroundColor := StyleSheet colorAt:#'menu.hilightForegroundColor'.
    DefaultHilightBackgroundColor := StyleSheet colorAt:#'menu.hilightBackgroundColor'.
    DefaultHilightFrameColor := StyleSheet colorAt:#'menu.hilightFrameColor' 
                                default:(StyleSheet colorAt:#'selection.hilightFrameColor').
    DefaultHilightLevel := StyleSheet at:#'menu.hilightLevel'.
    DefaultHilightStyle := StyleSheet at:#'menu.hilightStyle'.
    DefaultLineLevel := StyleSheet at:#'menu.separatingLineLevel'.
    DefaultLineInset := StyleSheet at:#'menu.separatingLineInset'.
    DefaultDisabledForegroundColor := StyleSheet colorAt:#'menu.disabledForegroundColor' default:nil.
    DefaultDisabledForegroundColor isNil ifTrue:[
        DefaultDisabledForegroundColor := StyleSheet colorAt:#'selection.disabledForegroundColor' default:Color darkGray.
        DefaultDisabledForegroundColor isNil ifTrue:[
            DefaultDisabledForegroundColor := StyleSheet colorAt:#'button.disabledForegroundColor' default:Color darkGray.
        ]
    ].
    DefaultDisabledEtchedForegroundColor := StyleSheet colorAt:#'menu.disabledEtchedForegroundColor'.
    DefaultDisabledEtchedForegroundColor isNil ifTrue:[
        DefaultDisabledEtchedForegroundColor := StyleSheet colorAt:#'button.disabledEtchedForegroundColor'.
    ].
    DefaultCheckColor := StyleSheet colorAt:#'menu.checkColor'.
    DefaultCheckOnImage := StyleSheet at:#'menu.checkOnImage'.
    DefaultCheckOffImage := StyleSheet at:#'menu.checkOffImage'.
    DefaultFont := StyleSheet fontAt:#'menu.font'.
    ShowAcceleratorKeys := StyleSheet at:#'menu.showAccelerators' default:true.

    "
     self updateStyleCache
    "

    "Modified: / 19.5.1998 / 22:02:30 / cg"
! !

!MenuView methodsFor:'accessing-behavior'!

action
    ^ actionBlock

    "Created: 25.5.1996 / 15:11:51 / cg"
!

disable:indexOrName
    "disable an entry"

    self setEnable:indexOrName to:false
!

disableAll
    "disable all entries"

    self disableAll:selectors

    "Created: 23.12.1995 / 16:56:05 / cg"
!

disableAll:collectionOfIndicesOrNames
    "disable an collection of entries"

    collectionOfIndicesOrNames do:[:entry |
	self disable:entry
    ]
!

enable:indexOrName
    "enable an entry"

    self setEnable:indexOrName to:true 
!

enableAll:collectionOfIndicesOrNames
    "enable an collection of entries"

    collectionOfIndicesOrNames do:[:entry |
	self enable:entry
    ]
!

hideOnRelease:aBoolean
    hideOnRelease := aBoolean
!

isEnabled:indexOrName
    "return true, if the item at anIndexOrName is enabled"

    |index|

    enableFlags isNil ifTrue:[^ true].
    indexOrName isNumber ifTrue:[ ^ enableFlags at: indexOrName ].

    index := self indexOf:indexOrName.
    index ~~ 0 ifTrue:[
        ^ enableFlags at:index
    ].
    "ask submenus for convenience"
    (indexOrName isNumber not and:[subMenus notNil]) ifTrue:[
        subMenus do:[:m |
            m notNil ifTrue:[
                (m isEnabled:indexOrName) ifTrue:[^ true].
            ]
        ]
    ].
    ^ false
!

setEnable:indexOrName to:aBoolean
    "enable/disable an entry"

    |index|

    enableFlags isNil ifTrue:[
        aBoolean ifTrue:[ ^ self ].
        enableFlags := Array new: list size
    ].

    index := self indexOf:indexOrName.
    index ~~ 0 ifTrue:[
        (enableFlags at:index) ~~ aBoolean ifTrue:[
            enableFlags at:index put:aBoolean.
            shown ifTrue:[
                self redrawLine:index
            ]
        ]
    ] ifFalse:[
        "try submenus for convenience"
        (indexOrName isNumber not and:[subMenus notNil]) ifTrue:[
            subMenus do:[:m |
                (m notNil and:[m isBlock not]) ifTrue:[
                    m setEnable:indexOrName to:aBoolean
                ]
            ]
        ]
    ]
! !

!MenuView methodsFor:'accessing-items'!

accelerators:collectionOfShortKeys
    "set the accelerator keys collection.
     You should pass translated symbolic keys - the menu will automatically
     show the untranslated original key sequences."

    shortKeys := collectionOfShortKeys copy.
    maxShortKeyStringLen := nil.
    shown ifTrue:[
	self resize
    ] ifFalse:[
	needResize := true
    ].

    "Created: 28.2.1996 / 17:15:31 / cg"
    "Modified: 30.4.1996 / 15:55:14 / cg"
!

actionAt:indexOrName
    "return an individual action"

    |i|

    i := self indexOf:indexOrName.
    (actions notNil and:[i ~~ 0]) ifTrue:[^ actions at:i ifAbsent:nil].
    ^ nil

    "Created: 24.3.1996 / 17:17:22 / cg"
!

actionAt:indexOrName put:aBlock
    "set an individual action"

    |i|

    i := self indexOf:indexOrName.
    i ~~ 0 ifTrue:[
        actions isNil ifTrue:[
            actions := OrderedCollection new.
        ].
        actions ensureSizeAtLeast:i.
        actions at:i put:aBlock
    ]

    "Created: 24.3.1996 / 17:18:15 / cg"
!

actions
    ^ actions 
!

actions:aCollectionOfActionBlocks
    "set all actions"

    actions := aCollectionOfActionBlocks

    "Created: 5.7.1996 / 11:33:09 / cg"
!

addItemList:list after:itemNameOrSelector
    self addItemList:list resources:nil after:itemNameOrSelector
!

addItemList:list resources:resources after:itemNameOrSelector
    self 
        addLabels:(list collect:[:row | row at:1])
        selectors:(list collect:[:row | row at:2 ifAbsent:nil])
        accelerators:(list collect:[:row | row at:3 ifAbsent:nil])
        resources:resources
        after:itemNameOrSelector
!

addLabel:aLabel selector:aSelector
    "add another label/selector pair at the end"

    self addLabel:aLabel selector:aSelector after:nil

    "Modified: 28.2.1996 / 17:54:11 / cg"
!

addLabel:aLabel selector:aSelector after:aLabelOrSelectorOrNumber 
    "insert another label/selector pair at some place.
     Being very friendly here, allowing label-string, selector or numeric
     index for the argument aLabelOrSelectorOrNumber.

     To be independent of the entries label, we recommend you use the selector
     as index; in systems which translate strings for national variants,
     this makes your code easier to maintain."

    self 
	addLabels:(Array with:aLabel)
	selectors:(Array with:aSelector)
	after:aLabelOrSelectorOrNumber

    "
     |v1 v2 v3 v4|

     v1 := CodeView new open.

     v2 := CodeView new open.
     v2 middleButtonMenu:
	(v2 editMenu addLabel:'new entry' selector:#foo after:#pasteSelection; yourself).

     v3 := CodeView new open.
     v3 middleButtonMenu:
	(v3 editMenu addLabel:'new entry' selector:#foo after:#others; yourself).

     v4 := CodeView new open.
     v4 middleButtonMenu:
	(v4 editMenu addLabel:'new entry' selector:#foo after:1; yourself).
    "

    "Modified: 28.2.1996 / 18:04:35 / cg"
!

addLabel:aLabel selector:aSelector arg:anArg
    "add another label/selector/argument trio.
     OBSOLETE"

    |idx|

    idx := list size + 1.
    self addLabel:aLabel selector:aSelector.
    args at:idx put:anArg

    "Modified: 28.2.1996 / 18:08:39 / cg"
!

addLabel:aLabel selector:aSelector before:aLabelOrSelectorOrNumber 
    "insert another label/selector pair at some place.
     Being very friendly here, allowing label-string, selector or numeric
     index for the argument aLabelOrSelectorOrNumber.

     To be independent of the entries label, we recommend you use the selector
     as index; in systems which translate strings for national variants,
     this makes your code easier to maintain."

    self 
	addLabels:(Array with:aLabel)
	selectors:(Array with:aSelector)
	before:aLabelOrSelectorOrNumber

    "
     |v1 v2 v3 v4 v5|

     v1 := CodeView new open.

     v2 := CodeView new open.
     v2 middleButtonMenu:
	(v2 editMenu addLabel:'new entry' selector:#foo before:'paste'; yourself).

     v3 := CodeView new open.
     v3 middleButtonMenu:
	(v3 editMenu addLabel:'new entry' selector:#foo before:#pasteOrReplace; yourself).

     v4 := CodeView new open.
     v4 middleButtonMenu:
	(v4 editMenu addLabel:'new entry' selector:#foo before:#again; yourself).

     v5 := CodeView new open.
     v5 middleButtonMenu:
	(v5 editMenu addLabel:'new entry' selector:#foo before:1; yourself).

     Notice: v2 above is an example on how NOT to do it - it will not work with nationalized menus
    "

    "Modified: 28.2.1996 / 18:04:00 / cg"
!

addLabels:moreLabels selectors:moreSelectors
    "add more labels and selectors at the END"

    self addLabels:moreLabels selectors:moreSelectors after:nil

    "Modified: 28.2.1996 / 17:46:50 / cg"
!

addLabels:moreLabels selectors:moreSelectors accelerators:shorties
    "add more labels and selectors at the END"

    self addLabels:moreLabels selectors:moreSelectors accelerators:shorties after:nil

    "Modified: 28.2.1996 / 17:46:50 / cg"
    "Created: 28.2.1996 / 17:47:17 / cg"
!

addLabels:moreLabels selectors:moreSelectors accelerators:shorties after:aLabelOrSelectorOrNumber 
    "insert more labels/selectors at some place.
     Being very friendly here, allowing label-string, selector or numeric
     index for the argument aLabelOrSelectorOrNumber.
     If such an item is not found, insert the new items at the END.

     To be independent of the entries label, we recommend you use the selector
     as index; in systems which translate strings for national variants,
     this makes your code easier to maintain."

    |idx|

    aLabelOrSelectorOrNumber isNil ifTrue:[
	idx := list size + 1
    ] ifFalse:[
	idx := (self indexOf:aLabelOrSelectorOrNumber) + 1.
	idx == 1 ifTrue:[
	    idx := list size + 1
	]
    ].

    ^ self 
	addLabels:moreLabels 
	selectors:moreSelectors 
	accelerators:shorties
	before:idx

    "Created: 28.2.1996 / 17:48:24 / cg"
    "Modified: 4.3.1996 / 23:26:02 / cg"
!

addLabels:moreLabels selectors:moreSelectors accelerators:shorties before:aLabelOrSelectorOrNumber 
    self 
        addLabels:moreLabels
        selectors:moreSelectors
        accelerators:shorties
        resources:nil
        before:aLabelOrSelectorOrNumber
!

addLabels:moreLabels selectors:moreSelectors accelerators:shorties resources:resources after:aLabelOrSelectorOrNumber 
    "insert more labels/selectors at some place.
     Being very friendly here, allowing label-string, selector or numeric
     index for the argument aLabelOrSelectorOrNumber.
     If such an item is not found, insert the new items at the END.

     To be independent of the entries label, we recommend you use the selector
     as index; in systems which translate strings for national variants,
     this makes your code easier to maintain."

    |idx|

    aLabelOrSelectorOrNumber isNil ifTrue:[
        idx := list size + 1
    ] ifFalse:[
        idx := (self indexOf:aLabelOrSelectorOrNumber) + 1.
        idx == 1 ifTrue:[
            idx := list size + 1
        ]
    ].

    ^ self 
        addLabels:moreLabels 
        selectors:moreSelectors 
        accelerators:shorties
        resources:resources
        before:idx

    "Created: 28.2.1996 / 17:48:24 / cg"
    "Modified: 4.3.1996 / 23:26:02 / cg"
!

addLabels:moreLabels selectors:moreSelectors accelerators:shorties resources:resources before:aLabelOrSelectorOrNumber 
    "insert more labels/selectors at some place.
     Being very friendly here, allowing label-string, selector or numeric
     index for the argument aLabelOrSelectorOrNumber. 
     If such an item is not found, insert the new items at the beginning.

     To be independent of the entries label, we recommend you use the selector
     as index; in systems which translate strings for national variants,
     this makes your code easier to maintain."

    |idx oldSize
     i     "{ Class: SmallInteger }" 
     nMore "{ Class: SmallInteger }"|

    list isNil ifTrue:[
        list := OrderedCollection new.
"/        ^ self addLabels:moreLabels selectors:moreSelectors resources:resources
    ].
    "
     be user friendly - allow both label or selector
     to be passed
    "
    aLabelOrSelectorOrNumber isNil ifTrue:[
        idx := 1
    ] ifFalse:[
        idx := self indexOf:aLabelOrSelectorOrNumber.
        (idx between:2 and:(list size + 1)) ifFalse:[
            "add to beginning"
            idx := 1
        ]
    ].

    nMore := moreLabels size.
    self assert:moreSelectors size == nMore.

    oldSize := list size.

    list := list asOrderedCollection.
    i := idx.
    moreLabels do:[:aLabel |
        |l|

        resources notNil 
            ifTrue:[l := resources string:aLabel]
            ifFalse:[l := aLabel].

        "/ remove ampersands
        l := MenuPanel
                processAmpersandCharactersFor:l 
                withAccessCharacterPosition:nil.

        "/ wrong: needed for accelerators.
        "/ l := self labelWithoutDoubleAmpersands:l.
        list add:l beforeIndex:i. i := i + 1.
    ].

    selectors := (selectors ? #()) asOrderedCollection.
    i := idx.
    moreSelectors do:[:sel |
        selectors add:sel beforeIndex:i. i := i + 1.
    ].

    enableFlags := (enableFlags ? #()) asOrderedCollection.
    i := idx.
    nMore timesRepeat:[
        enableFlags add:true beforeIndex:i. i := i + 1.
    ].

    subMenus notNil ifTrue:[
        subMenus := subMenus asOrderedCollection.
        i := idx.
        i >= subMenus size ifTrue:[
            subMenus grow:i-1
        ].
        nMore timesRepeat:[
            subMenus add:nil beforeIndex:i. i := i + 1.
        ].
    ].
    args notNil ifTrue:[
        args := args asOrderedCollection.
        i := idx.
        i >= args size ifTrue:[
            args grow:i-1
        ].
        nMore timesRepeat:[
            args add:nil beforeIndex:i. i := i + 1.
        ]
    ].
    actions notNil ifTrue:[
        actions := actions asOrderedCollection.
        i := idx.
        i >= actions size ifTrue:[
            actions grow:i-1
        ].
        nMore timesRepeat:[
            actions add:nil beforeIndex:i. i := i + 1.
        ]
    ].
    onOffFlags notNil ifTrue:[
        onOffFlags := onOffFlags asOrderedCollection.
        i := idx.
        i >= onOffFlags size ifTrue:[
            onOffFlags grow:i-1
        ].
        nMore timesRepeat:[
            onOffFlags add:nil beforeIndex:i. i := i + 1.
        ]
    ].
    shortKeys isNil ifTrue:[
        shortKeys := OrderedCollection new:oldSize.
        shortKeys grow:oldSize
    ].
    shortKeys := shortKeys asOrderedCollection.
    i := idx.
    shorties isNil ifTrue:[
        nMore timesRepeat:[
            shortKeys add:nil beforeIndex:i. i := i + 1.
        ]
    ] ifFalse:[
        maxShortKeyStringLen := nil.
        shorties do:[:sel |
            shortKeys add:sel beforeIndex:i. i := i + 1.
        ]
    ].

    shown ifTrue:[
        self resize
    ] ifFalse:[
        needResize := true
    ].

    "
     |v1 v2 v3 v4 v5 m|


     v1 := CodeView new open.
     v1 contents:'original menu'.

     v2 := CodeView new open.
     v2 contents:'before copy'.
     m := v2 editMenu.
     m
        addLabels:#('new entry1' 'new entry2') 
        selectors:#(foo bar) 
        before:#copySelection 
        accelerators:#(Copy Cut Paste).
     v2 middleButtonMenu:m.

     v3 := CodeView new open.
     v3 contents:'before again '.
     m := v3 editMenu.
     m
        addLabels:#('new entry1' 'new entry2') 
        selectors:#(foo bar) 
        before:#again.
     v3 middleButtonMenu:m.

     v4 := CodeView new open.
     v4 contents:'at beginning '.
     m := v4 editMenu.
     m
        addLabels:#('new entry1' 'new entry2' '-') 
        selectors:#(foo bar nil) 
        before:1.
     v4 middleButtonMenu:m.

     v5 := CodeView new open.
     v5 contents:'at end '.
     m := v5 editMenu.
     m
        addLabels:#('-' 'new entry1' 'new entry2') 
        selectors:#(nil foo bar).
     v5 middleButtonMenu:m.
    "

    "Created: / 28-02-1996 / 17:49:44 / cg"
    "Modified: / 15-02-2012 / 18:54:54 / cg"
!

addLabels:moreLabels selectors:moreSelectors after:aLabelOrSelectorOrNumber 
    "insert more labels/selectors at some place.
     Being very friendly here, allowing label-string, selector or numeric
     index for the argument aLabelOrSelectorOrNumber.
     If such an item is not found, insert the new items at the END.

     To be independent of the entries label, we recommend you use the selector
     as index; in systems which translate strings for national variants,
     this makes your code easier to maintain."

    ^ self 
	addLabels:moreLabels 
	selectors:moreSelectors 
	accelerators:nil
	after:aLabelOrSelectorOrNumber

    "Modified: 28.2.1996 / 17:47:52 / cg"
!

addLabels:moreLabels selectors:moreSelectors before:aLabelOrSelectorOrNumber 
    "insert more labels/selectors at some place.
     Being very friendly here, allowing label-string, selector or numeric
     index for the argument aLabelOrSelectorOrNumber.
     If such an item is not found, insert the new items at the beginning.

     To be independent of the entries label, we recommend you use the selector
     as index; in systems which translate strings for national variants,
     this makes your code easier to maintain."

    self 
	addLabels:moreLabels 
	selectors:moreSelectors 
	accelerators:nil 
	before:aLabelOrSelectorOrNumber 

    "
     |v1 v2 v3 v4 m|


     v1 := CodeView new open.

     v2 := CodeView new open.
     m := v2 editMenu.
     m
	addLabels:#('new entry1' 'new entry2') 
	selectors:#(foo bar) 
	before:'paste'.
     v2 middleButtonMenu:m.

     v3 := CodeView new open.
     m := v3 editMenu.
     m
	addLabels:#('new entry1' 'new entry2') 
	selectors:#(foo bar) 
	before:#again.
     v3 middleButtonMenu:m.

     v4 := CodeView new open.
     m := v4 editMenu.
     m
	addLabels:#('new entry1' 'new entry2') 
	selectors:#(foo bar) 
	before:1.
     v4 middleButtonMenu:m.
    "

    "Modified: 28.2.1996 / 17:49:30 / cg"
!

addLabels:moreLabels selectors:moreSelectors resources:resources
    "add more labels and selectors at the END"

    self addLabels:moreLabels selectors:moreSelectors resources:resources after:nil

    "Modified: 28.2.1996 / 17:46:50 / cg"
!

addLabels:moreLabels selectors:moreSelectors resources:resources accelerators:shorties
    "add more labels and selectors at the END"

    self addLabels:moreLabels selectors:moreSelectors accelerators:shorties resources:resources after:nil

    "Modified: 28.2.1996 / 17:46:50 / cg"
    "Created: 28.2.1996 / 17:47:17 / cg"
!

addLabels:moreLabels selectors:moreSelectors resources:resources after:aLabelOrSelectorOrNumber 
    "insert more labels/selectors at some place.
     Being very friendly here, allowing label-string, selector or numeric
     index for the argument aLabelOrSelectorOrNumber.
     If such an item is not found, insert the new items at the END.

     To be independent of the entries label, we recommend you use the selector
     as index; in systems which translate strings for national variants,
     this makes your code easier to maintain."

    ^ self 
        addLabels:moreLabels 
        selectors:moreSelectors 
        accelerators:nil
        resources:resources
        after:aLabelOrSelectorOrNumber

    "Modified: 28.2.1996 / 17:47:52 / cg"
!

addLabels:moreLabels selectors:moreSelectors resources:resources before:aLabelOrSelectorOrNumber 
    "insert more labels/selectors at some place.
     Being very friendly here, allowing label-string, selector or numeric
     index for the argument aLabelOrSelectorOrNumber.
     If such an item is not found, insert the new items at the beginning.

     To be independent of the entries label, we recommend you use the selector
     as index; in systems which translate strings for national variants,
     this makes your code easier to maintain."

    self 
        addLabels:moreLabels 
        selectors:moreSelectors 
        accelerators:nil 
        resources:resources
        before:aLabelOrSelectorOrNumber 

    "
     |v1 v2 v3 v4 m|


     v1 := CodeView new open.

     v2 := CodeView new open.
     m := v2 editMenu.
     m
        addLabels:#('new entry1' 'new entry2') 
        selectors:#(foo bar) 
        before:'paste'.
     v2 middleButtonMenu:m.

     v3 := CodeView new open.
     m := v3 editMenu.
     m
        addLabels:#('new entry1' 'new entry2') 
        selectors:#(foo bar) 
        before:#again.
     v3 middleButtonMenu:m.

     v4 := CodeView new open.
     m := v4 editMenu.
     m
        addLabels:#('new entry1' 'new entry2') 
        selectors:#(foo bar) 
        before:1.
     v4 middleButtonMenu:m.
    "

    "Modified: 28.2.1996 / 17:49:30 / cg"
!

addSeparatingLine
    "add a separating line at the END"

    self addLabel:'-' selector:nil

    "Modified: 28.2.1996 / 17:50:08 / cg"
!

addSeparatingLineAfter:aLabelOrSelectorOrNumber
    "add a separating line after an item"

    self addLabel:'-' selector:nil after:aLabelOrSelectorOrNumber

    "Modified: 28.2.1996 / 17:50:14 / cg"
!

args
    "return the argument array"

    ^ args
!

args:anArray
    "set the argument array"

    args := anArray copy

    "Modified: 30.4.1996 / 15:55:03 / cg"
!

argsAt:indexOrName put:something
    "set an individual selector"

    |i|

    i := self indexOf:indexOrName.
    i ~~ 0 ifTrue:[args at:i put:something]
!

checkFlags 
    "return an array filled with the check-mark flags.
     Non check-menu items have a nil entry in this array."

    ^ onOffFlags
!

checkFlags:aCollectionOfBooleansOrNils
    onOffFlags := aCollectionOfBooleansOrNils
!

checkToggleAt:indexOrName
    "return a check-toggles boolean state.
     If the item is not a check-item, return nil."

    |index|

    index := self indexOf:indexOrName.
    index == 0 ifTrue:[^ nil].
    onOffFlags isNil ifTrue:[^ nil].
    index > onOffFlags size ifTrue:[^ nil].
    ^ onOffFlags at:index

    "Modified: 22.4.1996 / 10:51:54 / cg"
!

checkToggleAt:indexOrName put:aBoolean
    "set/clear a check-toggle"

    |index|

    index := self indexOf:indexOrName.
    index == 0 ifTrue:[
"/        'no item: ' print. indexOrName printNL.
	^ self
    ].

    onOffFlags isNil ifTrue:[
	onOffFlags := Array new:(list size)
    ].
    onOffFlags at:index put:aBoolean.
    shown ifTrue:[
	self redrawLine:index
    ]

    "Modified: 6.3.1996 / 16:31:43 / cg"
!

hasItems
    "return true, if I have items"

    ^ list notEmptyOrNil
!

indexOf:indexOrName
    "return the index of the label named:aName or , if its a symbol
     the index in the selector list. 
     If indexOrName is not a valid item, return 0."

    indexOrName isSymbol ifTrue:[
	^ selectors indexOf:indexOrName
    ].
    indexOrName isString ifTrue:[
	^ list indexOf:indexOrName
    ].
    indexOrName isNil ifTrue:[^ 0].

    (indexOrName respondsTo:#string) ifTrue:[
	^ list indexOf:indexOrName asString
    ].
    ^ indexOrName

    "Modified: 27.4.1996 / 15:25:16 / cg"
!

labelAt:indexOrName put:aString
    "change the label at index to be aString"

    |i nItems|

    i := self indexOf:indexOrName.
    i == 0 ifTrue:[^ self].
    list at:i put:aString.

    "create onOff flags, if this label has a check-mark"
    (self isCheckItem:aString) ifTrue:[
	nItems := list size.
	onOffFlags isNil ifTrue:[
	    onOffFlags := Array new:nItems
	] ifFalse:[
	    [onOffFlags size < nItems] whileTrue:[
		onOffFlags := onOffFlags copyWith:nil 
	    ]
	].
	onOffFlags at:i put:false
    ].
    shown ifTrue:[
	self resize
    ] ifFalse:[
	needResize := true
    ]
!

labels
    "return the menu-labels"

    ^ list
!

labels:text
    "set the labels to the argument, text"

    |l nItems|

    (text isString) ifTrue:[
        l := text asStringCollection
    ] ifFalse:[
        l := text copy
    ].
    "/ wrong: needed for accelerators.
    "/ l := l collect:[:s | self labelWithoutDoubleAmpersands:s].
"/    self list:l 
    self setList:l expandTabs:false.
    nItems := list size.
    enableFlags := Array new:nItems withAll:true.
    onOffFlags := Array new:nItems.

    text notNil ifTrue:[
        text keysAndValuesDo:[:index :line |
            (self isCheckItem:line) ifTrue:[
                onOffFlags at:index put:false
            ].
        ].
    ].
    shown ifTrue:[
        self resize
    ] ifFalse:[
        needResize := true
    ]

    "Modified: / 06-10-2011 / 16:45:57 / cg"
!

labels:text selectors:selArray accelerators:shorties args:argArray receiver:anObject
    "set all relevant stuff"

    self labels:text selectors:selArray args:argArray receiver:anObject.
    shortKeys := shorties copy.

    "Created: 28.2.1996 / 18:56:38 / cg"
    "Modified: 30.4.1996 / 15:54:48 / cg"
!

labels:text selectors:selArray args:argArray receiver:anObject
    "set all relevant stuff"

    self labels:text.
    selArray isSymbol ifTrue:[
	selectors := Array new:(text size) withAll:selArray
    ] ifFalse:[
	selectors := selArray copy.
    ].
    args := argArray copy.
    receiver := anObject

    "Modified: 14.5.1996 / 15:30:10 / cg"
!

menuPerformer:someone
    "set the menuPerformer of the message.
     This also sets the menuPerformer in all subMenus."

    menuPerformer := someone.
    subMenus notNil ifTrue:[
        subMenus do:[:aMenu |
            (aMenu notNil and:[aMenu isBlock not]) ifTrue:[
                aMenu menuPerformer:someone
            ]
        ]
    ]

    "Created: 21.1.1997 / 15:42:00 / cg"
!

receiver
    "return the receiver of the message"

    ^ receiver
!

receiver:anObject
    "set the receiver of the message.
     This also sets the receiver in all subMenus."

    receiver := anObject.
    subMenus notNil ifTrue:[
        subMenus do:[:aMenu |
            (aMenu notNil and:[aMenu isBlock not]) ifTrue:[
                aMenu receiver:anObject
            ]
        ]
    ]

    "Modified: 21.1.1997 / 15:41:32 / cg"
!

remove:indexOrName
    "remove the label at index"

    |i|

    i := self indexOf:indexOrName.
    i == 0 ifTrue:[^ self].
    list := list asOrderedCollection removeIndex:i.
    selectors := selectors asOrderedCollection removeIndex:i.
    enableFlags notNil ifTrue:[ enableFlags := enableFlags asOrderedCollection removeIndex:i ].
    subMenus notNil ifTrue:[
        subMenus := subMenus asOrderedCollection removeIndex:i.
    ].
    shortKeys notNil ifTrue:[
        shortKeys := shortKeys asOrderedCollection removeIndex:i.
        maxShortKeyStringLen := nil.
    ].
    shown ifTrue:[
        self resize
    ] ifFalse:[
        needResize := true
    ]

    "Modified: 28.2.1996 / 18:27:57 / cg"
!

selectorAt:indexOrName
    "return an individual selector"

    |i|

    i := self indexOf:indexOrName.
    i ~~ 0 ifTrue:[^ selectors at:i].
    ^ nil
!

selectorAt:indexOrName put:aSelector
    "set an individual selector"

    |i|

    i := self indexOf:indexOrName.
    i ~~ 0 ifTrue:[selectors at:i put:aSelector]
!

selectors
    "return the selector array"

    ^ selectors
!

selectors:anArray
    "set the selector array"

    selectors := anArray copy

    "Modified: 30.4.1996 / 15:54:07 / cg"
!

someMenuItemLabeled:aLabel
    "find a menu item.
     Currently, in ST/X, instances of MenuItem are only created as dummy"

    |idx|

    idx := self indexOf:aLabel.
    idx ~~ 0 ifTrue:[
	^ MenuItem new menu:self index:idx
    ].
    subMenus notNil ifTrue:[
	subMenus do:[:aMenu |
	    |item|

	    aMenu notNil ifTrue:[
		(item := aMenu someMenuItemLabeled:aLabel) notNil ifTrue:[
		    ^ item
		]
	    ]
	].
    ].
    ^ nil
! !

!MenuView methodsFor:'accessing-look'!

font:aFont
    "adjust size for new font.
     CAVEAT: with the addition of Text objects,
             this method is going to be obsoleted by a textStyle
             method, which allows specific control over
             normalFont/boldFont/italicFont parameters."

    super font:aFont.
    preferredExtent := nil.
    shown ifTrue:[
        self resize
    ] ifFalse:[
        needResize := true
    ]

    "Modified: 22.5.1996 / 12:36:37 / cg"
! !

!MenuView methodsFor:'accessing-misc'!

masterView
    "return the popup-masterview I am contained in."

    ^ masterView
!

masterView:aPopUpView
    "set the popup-masterview I am contained in."

    masterView := aPopUpView
!

selection:index
    "set the selection"

    super selection:(self validateSelection:index)

    "Modified: / 29-11-2010 / 19:53:36 / cg"
!

setSelection:index
    super setSelection:(self validateSelection:index)

    "Created: / 25-05-1996 / 12:27:33 / cg"
    "Modified: / 29-11-2010 / 19:53:31 / cg"
!

sizeFixed:aBoolean
    sizeFixed := aBoolean

    "Created: 9.2.1996 / 01:12:40 / cg"
!

superMenu
    "ret the menu I am contained in 
     - need this to hide main menus when a submenu performed its action"

    ^ superMenu
!

superMenu:aMenu
    "set the menu I am contained in 
     - need this to hide main menus when a submenu performed its action"

    superMenu := aMenu
!

validateSelection:index
    |sel line|

    sel := index.
    sel notNil ifTrue:[
        line := self listAt:index.
        (self isGraphicItem:line) ifTrue:[
            "
             not really selectable, but a separating line
            "
            sel := nil
        ]
    ].
    ^ sel

    "Created: / 29-11-2010 / 18:51:24 / cg"
! !

!MenuView methodsFor:'accessing-submenus'!

subMenuAt:indexOrName
    "return a submenu, or nil"

    |i|

    subMenus isNil ifTrue:[^ nil].
    i := self indexOf:indexOrName.
    i == 0 ifTrue:[^ nil].
    ^ subMenus at:i
!

subMenuAt:indexOrName put:aPopUpMenu
    "define a submenu"

    |i newSubMenus|

    i := self indexOf:indexOrName.
    i == 0 ifTrue:[
        'MenuView [warning]: no submenu with for index: ' infoPrint. indexOrName infoPrintCR.
        ^ nil
    ].

    subMenus size < i ifTrue:[
        newSubMenus := Array new:(list size max:i).
        subMenus notNil ifTrue:[
            newSubMenus replaceFrom:1 with:subMenus.
        ].
        subMenus := newSubMenus.
        shown ifTrue:[
            self resize
        ] ifFalse:[
            needResize := true
        ]
    ].

    subMenus at:i put:aPopUpMenu.
    (aPopUpMenu notNil and:[aPopUpMenu isBlock not]) ifTrue:[
        aPopUpMenu device:device.
        (receiver notNil and:[aPopUpMenu receiver isNil]) ifTrue:[
            aPopUpMenu receiver:receiver
        ]
    ].

    "Modified: 17.1.1997 / 01:03:55 / cg"
!

subMenuShown
    "return the currently visible submenu - or nil if there is none"

    ^ subMenuShown
! !

!MenuView methodsFor:'disabled scrolling'!

makeSelectionVisible
    ^ self
! !

!MenuView methodsFor:'drawing'!

drawAccelerator:aSymbolicKey inVisibleLine:visLineNr with:fg and:bg
    "draw the accelerator at the right."

    |s x l isSubMenuEntry|

    "/ this is somewhat complicated: we have the symbolic key at hand,
    "/ but want to show the untranslated (inverse keyBoardMapped) key & modifier
    "/
    s := self shortKeyStringFor:aSymbolicKey.
    s isNil ifTrue:[^ self].

    l := self visibleLineToAbsoluteLine:visLineNr.

    disabledEtchedFgColor notNil ifTrue:[
        (self isInSelection:l) ifFalse:[
            (self isEnabled:l) ifFalse:[
                s := s asText emphasisAllAdd:(#etchColor -> disabledEtchedFgColor)
            ]
        ]
    ].
    isSubMenuEntry := (subMenus notNil and:[(subMenus at:l) notNil]).

    isSubMenuEntry ifFalse:[
        "/ this aligns them along their left
        x := width - textStartLeft - self shortKeyInset.
    ] ifTrue:[
        "/ this aligns them at the right
        x := width - leftMargin - (gc font widthOf:s).
        x := x - 16    "/ should query for the arrow size here ...
    ].

    hilightStyle == #openwin ifTrue:[
        x := x - 2            "/ inset of rounded rectangle
    ].

    self drawLine:s fromX:x inVisible:visLineNr with:fg and:bg

    "Created: / 28-02-1996 / 18:48:05 / cg"
    "Modified: / 08-08-2006 / 15:47:11 / cg"
    "Modified: / 08-02-2017 / 23:21:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

drawCheckLine:line inVisibleLine:visLineNr with:fg and:bg
    "draw an on/off-mark (or the space for it).
     Supported checkmark types:
        \c  simple mark; space if off
        \b  box mark
        \t  thumbsUp/thumbsDown mark
    "

    |w h y x l check xR yB form markIndex i2 markType found|

    l := self visibleLineToListLine:visLineNr.
    onOffFlags isNil ifTrue:[^ false]. "/ not a check-item line
    check := onOffFlags at:l ifAbsent:nil.
    check isNil ifTrue:[^ false]. "/ not a check-item line
    check := check value.

    markIndex := 1.
    found := false.
    [markIndex ~~ 0 and:[found not]] whileTrue:[
        markIndex := line indexOf:$\ startingAt:markIndex.
        markIndex ~~ 0 ifTrue:[
            i2 := markIndex + 1.
            found := 'cbt' includes:(line at:i2).
            found ifFalse:[
                markIndex := i2 + 1.
            ].
        ].
    ].
    markIndex == 0ifTrue:[
        ^ super drawVisibleLine:visLineNr from:1 to:line size with:fg and:bg.
    ].

    markType := line at:i2.

    x := (self xOfCol:markIndex inVisibleLine:visLineNr) - viewOrigin x.
    y := (self yOfVisibleLine:visLineNr) - (lineSpacing//2).

    gc paint:bg.
    gc fillRectangleX:margin y:y width:(width-(margin*2)) height:fontHeight.
    markIndex ~~ 1 ifTrue:[
        super drawVisibleLine:visLineNr from:1 to:(markIndex-1) with:fg and:bg.
    ].

    (markType == $c) ifTrue:[
        w := gc font widthOf:'V'.
        check ifTrue:[
            form := checkOnImage.
        ] ifFalse:[
            form := checkOffImage.
        ]
    ] ifFalse:[
        (markType == $b) ifTrue:[
            w := gc font maxWidth. "/ font widthOf:'   '.
        ] ifFalse:[
            (markType == $t) ifTrue:[
                check ifTrue:[form := Cursor thumbsUp sourceForm]
                      ifFalse:[form := Cursor thumbsDown sourceForm]
            ]
        ]
    ].

    form notNil ifTrue:[
        w := form width.
    ].

    self drawLine:(line copyFrom:markIndex+2) fromX:x+w inVisible:visLineNr with:fg and:bg.
    gc paint:(check ifTrue:[checkColor == bg ifTrue:[fg] ifFalse:[checkColor]] ifFalse:[fg]).

    h := gc font ascent.
    y := y + ((gc font height - h) // 2).
    yB := y + h - 1.

    form notNil ifTrue:[
        gc displayForm:form x:x y:y
    ] ifFalse:[
        (markType == $c) ifTrue:[
            check ifTrue:[
                xR := x + (w // 3).
                gc displayLineFromX:x y:(y + (h // 2)) toX:xR y:yB.
                gc displayLineFromX:xR y:yB toX:(x + w - 1) y:y
            ]
        ] ifFalse:[
            (markType == $b) ifTrue:[
                check ifTrue:[
                    xR := x + w - 2.
                    gc displayLineFromX:x y:y toX:xR y:yB.
                    gc displayLineFromX:xR y:y toX:x y:yB.
                ].
                gc paint:fg.
                gc displayRectangleX:x y:y width:h height:h.
            ]
        ].
    ].
    ^ true

    "Modified: / 6.5.1997 / 18:04:38 / stefan"
    "Modified: / 17.8.1998 / 10:25:01 / cg"
!

drawVisibleLine:visLineNr with:fg and:bg
    |lNr lineString xLatedLine isSpecial key|

    lNr := self visibleLineToListLine:visLineNr.
    lineString := self visibleAt:visLineNr.

    isSpecial := lineString notNil and:[lineString asString string includes:$\].
    isSpecial ifFalse:[
        "
         a normal entry
        "
        super drawVisibleLine:visLineNr with:fg and:bg
    ] ifTrue:[
        "
         some speciality in this line; try checkMark
        "
        ((self isCheckItem:lineString) 
        and:[self drawCheckLine:lineString inVisibleLine:visLineNr with:fg and:bg])
        ifFalse:[
            xLatedLine := lineString replString:'\\' withString:'\'.
            super drawLine:xLatedLine inVisible:visLineNr with:fg and:bg.
        ].
    ].

    "/
    "/ is there a shortKey ?
    "/
    ((ShowAcceleratorKeys ~~ false)
    and:[shortKeys notNil 
    and:[(key := shortKeys at:lNr ifAbsent:nil) notNil]]) ifTrue:[
        self drawAccelerator:key inVisibleLine:visLineNr with:fg and:bg
    ]

    "Modified: / 31.5.1999 / 12:35:48 / cg"
!

drawVisibleLineSelected:visLineNr with:fg and:bg
    "redraw a single line as selected."

    |listLine
     y  "{ Class: SmallInteger }" 
     y2 "{ Class: SmallInteger }" 
     r2 rI lI radius topLeftColor botRightColor |


    hilightStyle ~~ #openwin ifTrue:[
        ^ super drawVisibleLineSelected:visLineNr with:fg and:bg.
    ].

    "
     openwin draws selections in a menu as (edged) rounded rectangles
    "
    listLine := self visibleLineToListLine:visLineNr.
    listLine notNil ifTrue:[

        self drawVisibleLine:visLineNr with:fg and:bg.

        y := (self yOfVisibleLine:visLineNr)  - (lineSpacing//2).
        y2 := y + fontHeight - 1.
        r2 := fontHeight.
        radius := r2 // 2.
        rI := 0. "/ 2.
        lI := 1. "/ 2.

        "
         refill with normal bg, where arcs will be drawn below
        "
        gc paint:bgColor.
        gc fillRectangleX:margin y:y width:radius height:fontHeight.
        gc fillRectangleX:width-radius-margin y:y width:radius height:fontHeight.
        "
         fill the arcs
        "
        gc paint:hilightBgColor.
        gc fillArcX:margin+lI            y:y width:r2 height:r2+rI from:90 angle:180. 
        gc fillArcX:width-r2-rI-margin-1 y:y width:r2 height:r2+rI from:270 angle:180. 

        "
         a highlight-border around
        "
        hilightFrameColor notNil ifTrue:[
            gc paint:hilightFrameColor.
            gc displayLineFromX:radius+2 y:y toX:width-radius-3 y:y.
            gc displayLineFromX:radius+2 y:y2 toX:width-radius-3 y:y2.

            gc displayArcX:margin+lI y:y width:r2 height:r2+rI from:90 angle:180. 
            gc displayArcX:width-r2-rI-margin-1 y:y width:r2 height:r2+rI from:270 angle:180. 
            ^ self
        ].

        "
         an edge around
        "
        (hilightLevel ~~ 0) ifTrue:[
            (hilightLevel < 0) ifTrue:[
                topLeftColor := shadowColor.
                botRightColor := lightColor.
            ] ifFalse:[
                topLeftColor := lightColor.
                botRightColor := shadowColor.
            ].

            gc paint:topLeftColor.
            gc displayLineFromX:radius+2 y:y toX:width-radius-3 y:y.

            gc displayArcX:margin+lI y:y width:r2 height:r2+rI-1 from:90 angle:125. 
            gc displayArcX:width-r2-rI-margin-1 y:y width:r2 height:r2+rI-1 from:270+125 angle:55. 

            gc paint:botRightColor.

            gc displayLineFromX:radius+2 y:y2 toX:width-radius-3 y:y2.
            gc displayArcX:margin+lI y:y width:r2 height:r2+rI-1 from:90+125 angle:55. 
            gc displayArcX:width-r2-rI-margin-1 y:y width:r2 height:r2+rI-1 from:270 angle:125. 
        ].
        ^ self
    ].
    ^ super drawVisibleLine:visLineNr with:fg and:bg

    "Created: 28.2.1996 / 18:41:17 / cg"
    "Modified: 14.10.1997 / 00:05:43 / cg"
! !

!MenuView methodsFor:'event handling'!

buttonMotion:state x:x y:y
    (self sensor hasButtonMotionEventFor:self) ifFalse:[
        self setSelectionForX:x y:y now:(UserPreferences current delayedMenuShowAndHide) not.
    ]

    "Modified: / 29-11-2010 / 19:48:55 / cg"
!

buttonPress:button x:x y:y
    self setSelectionForX:x y:y now:true.

    "Modified: / 29-11-2010 / 19:38:36 / cg"
!

buttonRelease:button x:x y:y
    |hide|

    self cancelDelayedSubmenuHideOrShowAction.

    subMenuShown notNil ifTrue:[
        ^ self
    ].

    (x >= 0 
    and:[x < width
    and:[y >= 0 
    and:[y < height]]]) ifTrue:[
        superMenu notNil ifTrue:[
            superMenu submenuTriggered.

            shown ifFalse:[
                superView notNil ifTrue:[
                    superView shown ifTrue:[
                        superView isPopUpView ifTrue:[
                            superView hide
                        ].
                    ]
                ]
            ]
        ].
        self performSelectedAction.
    ].

    "/
    "/ not within mySelf
    "/

    superMenu notNil ifTrue:[
        hide := hideOnRelease.
        hide ifFalse:[
            superMenu shown ifFalse:[
                superView notNil ifTrue:[
                    superView shown ifTrue:[
                        hide := true
                    ]
                ]
            ].
        ].
        hide ifTrue:[
            superView hide
        ].
    ].

"/    (superView notNil and:[superView isPopUpView]) ifTrue:[
"/ 'refetch focus' printNL.
"/        superView regainControl.
"/        superView getKeyboardFocus.
"/        superView hide
"/    ]

    "Modified: / 29-11-2010 / 19:39:42 / cg"
!

keyPress:aKey x:x y:y

    <resource: #keyboard (#Return #MenuSelect #Escape #CursorRight #CursorLeft)>

    |m|

    self cancelDelayedSubmenuHideOrShowAction.
    subMenuShown notNil ifTrue:[
        subMenuShown menuView keyPress:aKey x:0 y:0.
        ^ self
    ].

    "
     Return, space or the (virtual) MenuSelect
     key trigger a selected entry.
    "
    (aKey == #Return
    or:[aKey == #MenuSelect
    or:[aKey == Character space]]) ifTrue:[
        selection notNil ifTrue:[
            (subMenus notNil and:[(m := subMenus at:selection) notNil]) ifTrue:[
                self showSubmenu:selection.
                m isBlock ifFalse:[m hideOnLeave:false].
            ] ifFalse:[
                subMenuShown := nil.
                self buttonRelease:2 x:0 y:0.
            ]
        ].
        ^ self
    ].
    aKey == #Escape ifTrue:[
        masterView notNil ifTrue:[
            masterView hideSubmenu.
            masterView hide.
            ^ self.
        ].
        superView hide.
        ^ self
    ].
    aKey == #CursorRight ifTrue:[
        selection notNil ifTrue:[
            (subMenus notNil and:[(m := subMenus at:selection) notNil]) ifTrue:[
                self showSubmenu:selection.
                m isBlock ifFalse:[m hideOnLeave:false].
                ^ self
            ]
        ].
    ].
    aKey == #CursorLeft ifTrue:[
        masterView notNil ifTrue:[
            masterView hideSubmenu.
            masterView regainControl.
        ].
        superView hide.
        ^ self
    ].

    super keyPress:aKey x:x y:y

    "Modified: / 29-11-2010 / 19:39:31 / cg"
!

pointerLeave:state
    subMenuShown notNil ifTrue:[
        ^ self
    ].
"/    self setSelectionForX:-1 y:-1. "force deselect"
    self setSelection:nil
"/    superMenu notNil ifTrue:[
"/        superMenu regainControl.
"/    ]

    "Modified: 25.5.1996 / 12:27:18 / cg"
! !

!MenuView methodsFor:'initialization & release'!

create
    super create.
    subMenuShown := nil.
    self resizeIfChanged
!

destroy
    "
     have to destroy the submenus manually here,
     since they are no real subviews of myself
    "
    subMenus notNil ifTrue:[
	subMenus do:[:m |
	    m notNil ifTrue:[
		m destroy
	    ]
	].
	subMenus := nil
    ].
    super destroy.
!

fetchDeviceResources
    "fetch device colors, to avoid reallocation at redraw time"

    super fetchDeviceResources.

    checkColor notNil ifTrue:[checkColor := checkColor onDevice:device].
    disabledFgColor notNil ifTrue:[disabledFgColor := disabledFgColor onDevice:device].

    hilightFgColorNoFocus := hilightFgColor.
    hilightBgColorNoFocus := hilightBgColor.

    "Created: 14.1.1997 / 00:08:55 / cg"
!

initEvents
    super initEvents.
    self enableLeaveEvents.
    self enableMotionEvents.

    windowGroup notNil ifTrue:[
        windowGroup sensor compressMotionEvents:true
    ]

    "Modified: 7.3.1996 / 14:18:09 / cg"
!

initStyle
    "setup viewStyle specifics"

    |style graphicsDevice|

    super initStyle.

    graphicsDevice := device.
    DefaultCheckColor notNil ifTrue:[
        checkColor := DefaultCheckColor
    ] ifFalse:[
        checkColor := fgColor.
    ].
    disabledFgColor := DefaultDisabledForegroundColor.
    disabledEtchedFgColor := DefaultDisabledEtchedForegroundColor.

    DefaultForegroundColor notNil ifTrue:[
        fgColor := DefaultForegroundColor onDevice:graphicsDevice
    ].
    DefaultBackgroundColor notNil ifTrue:[
        bgColor := DefaultBackgroundColor onDevice:graphicsDevice
    ].

    DefaultShadowColor notNil ifTrue:[
        shadowColor := DefaultShadowColor onDevice:graphicsDevice
    ].
    DefaultLightColor notNil ifTrue:[
        lightColor := DefaultLightColor onDevice:graphicsDevice
    ].

    DefaultHilightLevel notNil ifTrue:[
        hilightLevel := DefaultHilightLevel
    ] ifFalse:[
        hilightLevel := 0.
    ].

    "/ a temporary kludge to prevent drawing the white line below the selection.
    hilightStyle == #macosx ifTrue:[
        hilightStyle := nil
    ].
    "/ hilightStyle := DefaultHilightStyle.

    hilightFrameColor := DefaultHilightFrameColor.

    styleSheet is3D ifTrue:[
        "some 3D style menu - set hilight defaults to same"

        DefaultHilightForegroundColor notNil ifTrue:[
            hilightFgColor := DefaultHilightForegroundColor onDevice:graphicsDevice
        ] ifFalse:[
            hilightFgColor := fgColor.
        ].
        DefaultHilightBackgroundColor notNil ifTrue:[
            hilightBgColor := DefaultHilightBackgroundColor onDevice:graphicsDevice
        ] ifFalse:[
            hilightBgColor := bgColor.
        ].
        DefaultLineLevel notNil ifTrue:[
            lineLevel := DefaultLineLevel
        ] ifFalse:[
            lineLevel := -1.
        ]
    ] ifFalse:[
        "some 2D style menu - set hilight defaults to inverse"
        DefaultHilightForegroundColor notNil ifTrue:[
            hilightFgColor := DefaultHilightForegroundColor onDevice:graphicsDevice
        ] ifFalse:[
            hilightFgColor := bgColor.
        ].
        DefaultHilightBackgroundColor notNil ifTrue:[
            hilightBgColor := DefaultHilightBackgroundColor onDevice:graphicsDevice
        ] ifFalse:[
            hilightBgColor := fgColor.
        ].
        DefaultLineLevel notNil ifTrue:[
            lineLevel := DefaultLineLevel
        ] ifFalse:[
            lineLevel := 0.
        ]
    ].

    DefaultLineInset notNil ifTrue:[
        lineInset := DefaultLineInset
    ] ifFalse:[
        lineInset := (graphicsDevice horizontalPixelPerMillimeter * 0.8) rounded.
    ].

    "
     the following has to be changed to
     use the styleSheet too
    "
    style := styleSheet name.

    (style == #iris) ifTrue:[
        graphicsDevice hasGrayscales ifTrue:[
            lineSpacing := 3
        ].
    ].
    (style == #motif) ifTrue:[
        lineSpacing := (2 * hilightLevel)
    ].
"/ stupid - these are clobbered somewhere; see initialize and recreate
"/    hilightStyle == #openwin ifTrue:[
"/        "add some space for rounded-hilight area"
"/        self leftMargin:(font height // 2 + 2 "inset of rounded rect") "10".
"/    ] ifFalse:[
"/        (hilightLevel ~~ 0) ifTrue:[
"/            self leftMargin:hilightLevel abs + self margin abs + 1.
"/            lineSpacing := lineSpacing max:(hilightLevel abs * 2).
"/        ]
"/    ].
    (style == #st80) ifTrue:[
        level := 0.
    ].
    DefaultViewBackground notNil ifTrue:[
        viewBackground := DefaultViewBackground onDevice:graphicsDevice
    ].

    "Modified: / 22-01-1997 / 11:57:23 / cg"
    "Modified (comment): / 05-10-2011 / 15:50:59 / az"
!

initialize
    |style|

    super initialize.
    hideOnRelease := false.
    autoScroll := false.
    sizeFixed := false.

    (((style := styleSheet name) ~~ #normal) 
    and:[style ~~ #mswindows]) ifTrue:[
        self borderWidth: 1.
        (style ~~ #st80) ifTrue:[self level:1]
    ].

    "stupid - have to redo this ..."
    hilightStyle == #openwin ifTrue:[
        "add some space for rounded-hilight area"
        self leftMargin:(gc font height " // 2" + 2 "inset of rounded rect") "10".
    ] ifFalse:[
        (hilightLevel ~~ 0) ifTrue:[
            self leftMargin:hilightLevel abs + margin abs + 1.
            lineSpacing := lineSpacing max:(hilightLevel abs * 2).
        ].
        lineSpacing := lineSpacing max:2.
    ].

    "Modified: 5.6.1996 / 14:36:56 / cg"
!

recreate
    "when recreated after a snapin or a migration, resize myself, in case
     font dimensions have changed on the display"

    super recreate.
    hilightStyle == #openwin ifTrue:[
        "add some space for rounded-hilight area"
        self leftMargin:(gc font height // 2 + 2 "inset of rounded rect") "10".
    ] ifFalse:[
        (hilightLevel ~~ 0) ifTrue:[
            self leftMargin:hilightLevel abs + self margin abs + 1.
            lineSpacing := lineSpacing max:(hilightLevel abs * 2).
        ]
    ].
    self resize

    "Modified: 28.2.1996 / 19:39:37 / cg"
!

reinitialize
    "this is called right after snapIn;
     a kind of kludge - reset cursor (in case the save was
     done with myself being shown and active)"

    super reinitialize.
    selection := nil. "self selection:nil."
    self showPassive
! !

!MenuView methodsFor:'private'!

isCheckItem:line
    "return true if \c, \b or \t is contained in the line arg.
     Care for '\\'."

    |idx|

    line isString ifTrue:[
        idx := 1.
        [idx ~~ 0] whileTrue:[
            idx := line indexOf:$\ startingAt:idx.
            (idx ~~ 0) ifTrue:[
                idx < line size ifTrue:[
                    ('cbt' includes:(line at:(idx+1))) ifTrue:[
                        ^ true
                    ].
                ].
                idx := idx + 2.
            ].
        ].
    ].
    ^ false.

    "Modified: / 31.5.1999 / 12:59:07 / cg"
!

isGraphicItem:line
    "redefine in subclasses to return false,
     if no graphicLines are wanted (codeCompletionView does this)"
     
    (line = '-') ifTrue:[^ true].
    (line = '=') ifTrue:[^ true].
    (line = '') ifTrue:[^ true].
    ^ false.
!

labelWithoutDoubleAmpersands:label
    (label isString and:[label includesString:'&&']) ifTrue:[
        ^ label copyReplaceString:'&&' withString:'&'    
    ] ifFalse:[
        ^ label
    ].
!

performSelectedAction
    |theSelector theAction isCheck checkOn val idx didItHere|

    (superView notNil and:[superView isPopUpView]) ifTrue:[superView hideForAction].
    superMenu notNil ifTrue:[superMenu submenuTriggered].

    idx := selection.
    idx notNil ifTrue:[
        
        (subMenus isNil or:[(subMenus at:idx) isNil]) ifTrue:[
            didItHere := false.

            self showActive.
            [
                superMenu notNil ifTrue:[
                    superMenu showActive
                ].

                val := idx.
                args notNil ifTrue:[
                    val := args at:idx
                ].

                isCheck := false.
                onOffFlags notNil ifTrue:[
                    onOffFlags size >= idx ifTrue:[
                        checkOn := (onOffFlags at:idx).
                        isCheck := checkOn notNil.
                        isCheck ifTrue:[
                            checkOn := val := checkOn not.
                            onOffFlags at:idx put:checkOn.
                        ]
                    ]
                ].

                "
                 ST-80 style model notification
                "
                self sendChangeMessageWith:val.

                "
                 item actions or selectors-array
                "
                device activePointerGrab == self ifTrue:[
                    device ungrabPointer.
                ].

                actions notNil ifTrue:[
                    theAction := actions at:idx ifAbsent:nil.
                ].

                theAction isNil ifTrue: [
                    selectors notNil ifTrue: [

                        "/ selectors may be:
                        "/  - a single selector used for all items
                        "/  - an array of selectors used per item

                        selectors isSymbol ifTrue:[
                            theSelector := selectors
                        ] ifFalse:[
                            (idx notNil 
                             and:[idx <= selectors size]) ifTrue:[
                                theSelector := selectors at:idx
                            ]
                        ].
                    ].
                ].

                (theSelector notNil 
                or:[theAction notNil]) ifTrue:[
                    AbortOperationRequest handle:[:ex |
                        ex return
                    ] do:[
                        |theReceiver|

                        didItHere :=  true.
                        theAction notNil ifTrue:[
                            theAction valueWithOptionalArgument:val 
                        ] ifFalse:[
                            "/ support for ST-80 style message splitting:
                            "/ if there is a menuPerformer it gets the
                            "/ message (if understood).
                            "/ Otherwise if there is a model, try that.
                            "/ Finally, if there is a receiver,
                            "/ its sent to that one.

                            theReceiver := menuPerformer.
                            (theReceiver isNil
                             or:[(theReceiver respondsTo:theSelector) not])
                            ifTrue:[
                                theReceiver := model.
                            ].
                            (theReceiver isNil
                             or:[(theReceiver respondsTo:theSelector) not])
                            ifTrue:[
                                theReceiver := receiver.
                            ].

                            theSelector isBlock ifTrue:[
                                theSelector value 
                            ] ifFalse:[    
                                theSelector isArray ifTrue:[
                                    theReceiver perform:(theSelector first) withArguments:(theSelector copyFrom:2)
                                ] ifFalse:[
                                    theSelector numArgs == 0 ifTrue:[
                                        theReceiver perform:theSelector
                                    ] ifFalse:[
                                        isCheck ifTrue:[
                                            self redrawLine:idx.
                                            val := checkOn.
                                        ].
                                        theReceiver perform:theSelector with:val 
                                    ]
                                ]
                            ]
                        ]

                    ]
                ].

                "
                 any action-block ?
                "
                actionBlock notNil ifTrue:[
                    AbortOperationRequest handle:[:ex |
                        ex return
                    ] do:[
                        didItHere ifTrue:[
                            val := nil
                        ].
                        actionBlock numArgs == 1 ifTrue:[
                            actionBlock value:val
                        ] ifFalse:[
                            actionBlock value:self value:val
                        ]
                    ]
                ].

            ] ensure:[
                realized ifTrue:[
                    self showPassive.
                ].
                superMenu notNil ifTrue:[
                    superMenu showPassive
                ]
            ].
        ].
    ]

    "Created: 4.3.1996 / 11:19:22 / cg"
    "Modified: 21.1.1997 / 15:42:52 / cg"
!

recomputeSize
    "resize myself to my preferred size
     OBSOLETE - use resize"

    self resize.
!

resize
    "resize myself to my preferred size"

    sizeFixed == true ifFalse:[
	widthOfWidestLine := nil.  "/ i.e. unknown
	super resize.
    ]

    "Modified: 9.2.1996 / 02:42:32 / cg"
!

resizeIfChanged
    needResize == true ifTrue:[
	self resize.
	needResize := false
    ]
!

selectionChangedFrom:oldSelection

    "Created: 4.3.1996 / 22:10:54 / cg"
!

setSelectionForX:x y:y now:now
    "select whatever is under x/y coordinate - if there is
     a subMenu, show it"

    <resource: #style (#'menu.subMenuPopInRightHalfOnly')>

    |newSelection subMenu|

    lastMousePoint := x@y.

    (x < 0 
    or:[x >= width
    or:[y < 0
    or:[y >= height]]]) ifTrue:[
        "
         moved outside
        "
        self cancelDelayedSubmenuHideOrShowAction.

        subMenuShown notNil ifTrue:[
            ^ self
        ].

        superMenu notNil ifTrue:[
            superMenu regainControl
        ].
    ].

    newSelection := self positionToSelectionX:x y:y.
    newSelection ~= selection ifTrue:[
        newSelection notNil ifTrue:[
            (self isEnabled:newSelection) ifFalse:[
                newSelection := nil
            ]
        ].
    ].
    newSelection = selection ifTrue:[
        now ifFalse:[
            ^ self
        ]
    ].

    superMenu notNil ifTrue:[
        superMenu cancelDelayedSubmenuHideOrShowAction.
    ].
    self cancelDelayedSubmenuHideOrShowAction.
    (subMenuShown isNil or:[now]) ifTrue:[
        self setSelection:newSelection.
    ].

    now ifTrue:[
        subMenu := nil.
        newSelection notNil ifTrue:[
            subMenus notNil ifTrue:[
                ((styleSheet at:#'menu.subMenuPopInRightHalfOnly' default:false) not
                or:[x > (width // 2)]) ifTrue:[
                    subMenu := (subMenus at:newSelection).
                ]
            ]
        ].

        subMenuShown notNil ifTrue:[
            self hideSubmenu.
            subMenuShown := nil.
        ].
        subMenu notNil ifTrue:[
            self showSubmenu:newSelection.
        ].
    ] ifFalse:[
        "/ new, delayed code
        delayedSubmenuHideOrShowAction := 
            [
                self setSelectionForX:lastMousePoint x y:lastMousePoint y now:true.
            ].

        Processor 
            addTimedBlock:delayedSubmenuHideOrShowAction 
            afterMilliseconds:100.

    ].

    "Created: / 29-11-2010 / 19:09:54 / cg"
! !

!MenuView methodsFor:'queries'!

preferredExtent 
    "compute & return my preferredExtent from labels width's"

    |margin2 w h extra|

    "/ If I have an explicit preferredExtent..
    explicitExtent notNil ifTrue:[
        ^ explicitExtent
    ].

    "/ If I have a cached preferredExtent value..
    preferredExtent notNil ifTrue:[
        ^ preferredExtent
    ].

    widthOfWidestLine := nil.  "/ i.e. unknown

    margin2 := margin * 2.
    w := self widthOfContents + leftMargin + leftMargin + margin2.
    h := (self numberOfLines) * fontHeight - lineSpacing + (2 * topMargin) + margin2.
    hilightLevel ~~ 0 ifTrue:[
        h := h + (hilightLevel abs)
    ].

    extra := 0.
    "if there is a submenu, add some space for the right arrow"
    subMenus notNil ifTrue:[
        extra := 16
    ].
    ((ShowAcceleratorKeys ~~ false) and:[shortKeys notNil]) ifTrue:[
        extra := extra max:(self shortKeyInset) + 10 "/ spacing
    ].
    ^ ((w+extra) @ h).

    "Modified: 23.1.1997 / 02:36:17 / cg"
!

selectedItemHasSubmenu
    selection isNil ifTrue:[^false].
    ^ (subMenus notNil and:[(subMenus at:selection) notNil]).

    "Modified: 20.11.1997 / 00:07:50 / cg"
!

shortKeyInset
    "compute the width req'd for the shortKey"

    maxShortKeyStringLen isNil ifTrue:[
        shortKeys isNil ifTrue:[
            maxShortKeyStringLen := 0
        ] ifFalse:[
            maxShortKeyStringLen := shortKeys 
                                        inject:0 
                                        into:[:maxSoFar :thisKey | |short|

                                                thisKey isNil ifTrue:[
                                                    maxSoFar
                                                ] ifFalse:[
                                                    short := self shortKeyStringFor:thisKey.
                                                    short isNil ifTrue:[
                                                        maxSoFar
                                                    ] ifFalse:[
                                                        maxSoFar max:(gc font widthOf:short)
                                                    ]
                                                ]
                                             ]
        ].
    ].
    ^ maxShortKeyStringLen

    "Created: / 28-02-1996 / 16:30:09 / cg"
    "Modified: / 08-08-2006 / 15:47:07 / cg"
    "Modified: / 08-02-2017 / 23:20:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

shortKeyPrefixFor:aModifier
    <resource: #obsolete>
    "obsolete?"

    |m|

"/    aModifier = 'Alt' ifTrue:[
"/        ^ '@-'
"/    ].
"/    aModifier = 'Cmd' ifTrue:[
"/        ^ '@-'
"/    ].
"/    aModifier = 'Meta' ifTrue:[
"/        ^ '$-'
"/    ].
"/    aModifier = 'Ctrl' ifTrue:[
"/        ^ '^-'
"/    ].
"/    ^ aModifier.

    m := device modifierKeyTopFor:aModifier.
    m notNil ifTrue:[
        ^ m , '-'
    ].
    ^ aModifier.

    "Created: 28.2.1996 / 16:32:17 / cg"
    "Modified: 20.3.1996 / 17:03:34 / cg"
!

wantsFocusWithButtonPress
    ^ false.
! !

!MenuView methodsFor:'redrawing'!

redrawFromVisibleLine:start to:stop
    "redraw a line range - redefined to care for special entries."

    "/ the natural way to do it is:
    "/
    "/    start to:stop do:[:visLine |
    "/        self redrawVisibleLine:visLine
    "/    ]
    "/
    "/ but I want to draw the stuff in big chunks for slow machines ...
    "/ Q: is it worth it ?

    |first 
     index   "{ Class: SmallInteger }"
     current "{ Class: SmallInteger }"
     line special index0|

    index0 := self visibleLineToListLine:start.
    index0 notNil ifTrue:[
        index := index0.
        first := start.
        current := start.
        [current <= stop] whileTrue:[
            line := self visibleAt:current.
            line notNil ifTrue:[
                line isText ifFalse:[
                    line := line asString string
                ]
            ].

            special := line notNil
                       and:[line isString
                       and:[(self isGraphicItem:line) 
                            or:[line includes:$\ ]]].

            (special
            or:[shortKeys notNil
            or:[(self isEnabled:index) not]]) ifTrue:[
                "a special case"
                (first < current) ifTrue:[
                    super redrawFromVisibleLine:first to:(current - 1)
                ].
                self redrawVisibleLine:current.
                first := current + 1
            ].
            current := current + 1.
            index := index + 1
        ].
        (first < current) ifTrue:[
            super redrawFromVisibleLine:first to:(current - 1)
        ].

        "draw submenu marks"
        subMenus notNil ifTrue:[
            index := index0.
            start to:stop do:[:l |
                index <= subMenus size ifTrue:[
                    (subMenus at:index) notNil ifTrue:[
                        self drawRightArrowInVisibleLine:l
                    ].
                    index := index + 1
                ]
            ]
        ]
    ]

    "Modified: 12.5.1996 / 21:13:31 / cg"
!

redrawVisibleLine:visLineNr
    "redefined from normal list-line drawing, to handle special
     lines. These are:
        lines consisting of '-' only: draw a horizontal separating line
        lines consisting of '=' only: draw double separating line
        empty line                  : leave blank
     there may be more in the future.
    "

    |line lineNr y isSpecial isSeparatingLine 
     isDoubleLine right clr1 clr2 text key|

    line := self visibleAt:visLineNr.

    isSpecial := isDoubleLine := isSeparatingLine := false.
    (self isGraphicItem:line) ifTrue:[
        (line = '-') ifTrue:[
            isSeparatingLine := isSpecial := true.
        ] ifFalse:[
            (line = '=') ifTrue:[
                isSeparatingLine := isSpecial := isDoubleLine := true.
            ] ifFalse:[
                (line = '') ifTrue:[
                    isSpecial := true
                ]
            ]
        ].
    ].
    
    isSpecial ifFalse:[
        lineNr := self visibleLineToListLine:visLineNr.
        (self isEnabled:lineNr) ifFalse:[
            text := self visibleAt:visLineNr.
            disabledEtchedFgColor notNil ifTrue:[
                text := text asText emphasisAllAdd:(#etchColor -> disabledEtchedFgColor)
            ].
            self 
                drawLine:text 
                atX:(textStartLeft - viewOrigin x) 
                inVisible:visLineNr 
                with:disabledFgColor 
                and:bgColor.

            "/
            "/ is there a shortKey ?
            "/
            ((ShowAcceleratorKeys ~~ false)
            and:[shortKeys notNil 
            and:[(key := shortKeys at:lineNr ifAbsent:nil) notNil]]) ifTrue:[
                self drawAccelerator:key inVisibleLine:visLineNr with:disabledFgColor and:bgColor
            ]
            "/ self drawVisibleLine:visLineNr with:disabledFgColor and:bgColor
        ] ifTrue:[
            super redrawVisibleLine:visLineNr
        ].

        "/
        "/ is there a submenu ?
        "/
        (subMenus notNil and:[(subMenus at:lineNr ifAbsent:nil) notNil]) ifTrue:[
            self drawRightArrowInVisibleLine:visLineNr
        ].
        ^ self
    ].

    "/
    "/ handle separating lines
    "/

    y := self yOfVisibleLine:visLineNr.

    gc paint:bgColor.
    gc fillRectangleX:0 y:y width:width height:fontHeight.

    isSeparatingLine ifTrue:[
        y := y + (fontHeight // 2).
        isDoubleLine ifTrue:[
            y := y - (fontHeight // 8).
        ].

        right := width - 1 - lineInset.

        lineLevel == 0 ifTrue:[
            gc paint:fgColor.
            gc displayLineFromX:lineInset y:y toX:right y:y.
            isDoubleLine ifTrue:[
                y := y + (fontHeight // 4).
                gc displayLineFromX:lineInset y:y toX:right y:y
            ]
        ] ifFalse:[
            "the inset on each side"

            lineLevel < 0 ifTrue:[
                clr1 := shadowColor.
                clr2 := lightColor.
            ] ifFalse:[
                clr1 := lightColor.
                clr2 := shadowColor.
            ].

            gc paint:clr1.
            gc displayLineFromX:lineInset y:y toX:right y:y.
            gc paint:clr2.
            y := y + 1.
            gc displayLineFromX:lineInset y:y toX:right y:y.
            isDoubleLine ifTrue:[
                y := y + (fontHeight // 4).
                gc displayLineFromX:lineInset y:y toX:right y:y.
                y := y - 1.
                gc paint:clr1.
                gc displayLineFromX:lineInset y:y toX:right y:y.
            ]
        ]
    ]

    "Modified: 2.3.1996 / 14:48:08 / cg"
!

redrawVisibleLine:visLine col:col
    "redefined to always draw a full line - for openwin handling"

    self redrawVisibleLine:visLine
!

redrawVisibleLine:visLine from:startCol
    "redefined to always draw a full line - for openwin handling"

    self redrawVisibleLine:visLine
!

redrawVisibleLine:visLine from:startCol to:endCol
    "redefined to always draw a full line - for openwin handling"

    self redrawVisibleLine:visLine
! !

!MenuView methodsFor:'selections'!

isValidSelection:aNumber
    "return true, if aNumber is ok for a selection lineNo"

    |line|

    (super isValidSelection:aNumber) ifFalse:[^ false].
    (self isEnabled:aNumber) ifFalse:[^ false].

    line := self listAt:aNumber.
    ^ (self isGraphicItem:line) not

    "Modified: / 8.8.1998 / 03:31:14 / cg"
! !

!MenuView methodsFor:'showing'!

realize
    self resizeIfChanged.
    super realize

    "Modified: 28.2.1996 / 18:17:05 / cg"
!

show
    self hiddenOnRealize:false.
    self showPassive.
    self realize

    "Modified: 21.3.1996 / 17:21:46 / cg"
!

unmap
    "unmap the view - the view stays created (but invisible), and can be remapped again later."

    self hideSubmenu.
    super unmap.

    "Created: 25.2.1997 / 23:01:56 / cg"
    "Modified: 25.2.1997 / 23:02:09 / cg"
! !

!MenuView methodsFor:'submenu notifications'!

cancelDelayedSubmenuHideOrShowAction
    delayedSubmenuHideOrShowAction notNil ifTrue:[
        Processor removeTimedBlock:delayedSubmenuHideOrShowAction.
        delayedSubmenuHideOrShowAction := nil.
    ].

    "Created: / 29-11-2010 / 19:21:36 / cg"
!

hideSubmenu
    "hide the currently shown subMenu (if any)"

    |m id|

    (m := subMenuShown) notNil ifTrue:[
        "/ race condition kludge ...
        m realized ifFalse:[
            (id := m id) notNil ifTrue:[
                device unmapWindow:id.
            ]
        ] ifTrue:[
            m hide.
        ].

        subMenuShown := nil.
        "/ self setSelection:nil.
    ].

    "Modified: / 29-11-2010 / 18:57:37 / cg"
!

regainControl
    "take over pointer control from a submenu"

    masterView notNil ifTrue:[
        masterView regainControl.
        subMenuShown := nil.
    ].

    "Modified: 4.3.1996 / 23:17:15 / cg"
!

showActive
    "submenu is about to perform a menu-action - show wait cursor here as well"

    self cursor:(Cursor wait)
!

showPassive
    "submenu has finished its menu-action - show normal cursor again"

    self cursor:(Cursor hand)
!

showSubmenu:index
    "show subMenu at index"

    |org mx my menuOrBlock menu rightInset|

    rightInset := 5.

    menuOrBlock := subMenus at:index.
    menuOrBlock isNil ifTrue:[^ self].
    menuOrBlock == subMenuShown ifTrue:[^ self].

    menuOrBlock isBlock ifTrue:[ 
        menuOrBlock == blockOfSubMenuShown ifTrue:[^ self].
        menu := menuOrBlock value.
    ] ifFalse:[
        menu := menuOrBlock.
    ].

    mx := width - rightInset.
    my := self yOfVisibleLine:index.
    "
     need to know the physical screen coordinate,
     to map the subview there
    "
    org := device translatePoint:(mx @ my) fromView:self toView:nil.

    "
     before showing, process all of my expose events
    "
"/    "/ mhmh - is this still needed ?
"/    windowGroup notNil ifTrue:[
"/        windowGroup processExposeEvents
"/    ].

    menu topView device:device.   "/ req'd for multiDisplay operation
    menu superMenu:self.

    actionBlock notNil ifTrue:[
        "/ mhmh - I am an ST-80 style menu
        "/ which does not send any messages to the receiver,
        "/ but returns the selector instead.
        "/ let my submenu do so as well ...

         menu menuView action:actionBlock
    ].

    "
     realize the submenu in MY windowgroup
    "
    windowGroup notNil ifTrue:[
        menu windowGroup:windowGroup.
        windowGroup addTopView:menu.
    ].
    menu fixSize.
    menu origin:org.
    menu makeFullyVisible.

    "/ cg: Jan-2010
    "/ if the submenu covers me, try to show it to the left instead of the right)
    (menu screenBounds intersects:(self screenBounds insetBy:(rightInset*2))) ifTrue:[
        menu origin:(org - (width @ 0) - (menu width @ 0) + ((rightInset*2) @ 0)).
        menu makeFullyVisible.
    ].

    menu noShadow.
    menu haveControl:true. "/ grap pointers during mapped 

    "/ race condition kludge ...
    menu realized ifFalse:[
        menu realize. 
    ] ifTrue:[
        device mapWindow:menu id.
    ].
"/    device flush.
    menuOrBlock isBlock ifTrue:[
        blockOfSubMenuShown := menuOrBlock
    ] ifFalse:[
        blockOfSubMenuShown := nil
    ].
    subMenuShown := menu

    "Modified: / 10.10.2001 / 14:12:44 / cg"
!

submenuTriggered
    "submenu has performed some action - have to deselect here"

    self setSelection:nil.

    "a bad kludge - 5 minutes before writing the alpha tapes ..."
    superView isPopUpView ifTrue:[
	superView hide
    ].
    superMenu notNil ifTrue:[
	superMenu submenuTriggered 
    ].

    "Modified: 25.5.1996 / 12:27:42 / cg"
! !

!MenuView class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

