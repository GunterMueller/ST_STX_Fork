"
 COPYRIGHT (c) 1997 by eXept Software AG
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

Model subclass:#Menu
	instanceVariableNames:'items groupSizes receiver'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Support'
!

Query subclass:#NeedResourcesQuery
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:Menu
!

!Menu class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1997 by eXept Software AG
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
    not yet finished Menu class - this will eventually replace
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

!Menu class methodsFor:'instance creation'!

labelArray:arrayOfString lines:linesArray values:valueArrayOrNil
    "return a menu with menu items built with labels from arrayOfString (not Symbols).  
     The linesArray describes which menu items are the last menu item in their group. 
     The valueArray contains value objects for each menu item 
     (or is nil if no value objects are specified)."

    |nLabel valueArray menuItems groupLengths|

    nLabel := arrayOfString size.

    valueArrayOrNil isNil ifTrue:[
        (valueArray := arrayOfString isEmpty) ifTrue: [
            valueArray := #()
        ] ifFalse:[
            valueArray := (1 to:nLabel)
        ]
    ] ifFalse:[
        valueArray := valueArrayOrNil
    ].

    nLabel ~~ valueArray size ifTrue: [
        ^ self error: 'illegal menu combination'
    ].

    menuItems := Array new:nLabel.
    1 to:nLabel do:[:i |
        |mi v|

        mi := MenuItem label:(arrayOfString at:i) asString.
        v := valueArray at:i.
        (v isKindOf:Menu) ifTrue:[mi submenu:v].
        menuItems at:i put:mi
    ].

    (linesArray size == 0) ifTrue:[
        groupLengths := (menuItems isEmpty)
                            ifTrue: [Array new:0]
                            ifFalse: [Array with:menuItems size]
    ] ifFalse:[
        groupLengths := Array new:(linesArray size + 1).
        groupLengths at:1 put:linesArray first.
        2 to:linesArray size do: [:i | 
            groupLengths at:i put:((linesArray at:i) - (linesArray at:i - 1))
        ].
        groupLengths at:groupLengths size put:(menuItems size - linesArray last).
    ].

    ^ self new 
        menuItems:menuItems 
        menuItemGroups:groupLengths 
        values:valueArray

    "Modified: / 19.4.1998 / 11:30:18 / cg"
!

labelArray:arrayOfString values:valueArrayOrNil
    "return a menu with menu items built with labels from arrayOfString (not Symbols).  
     The valueArray contains value objects for each menu item 
     (or is nil if no value objects are specified)."

    ^ self 
        labelArray:arrayOfString 
        lines:nil 
        values: valueArrayOrNil

!

labelList:arrayOfGroupStrings values:valueArrayOrNil
    |labels lines|

    lines := arrayOfGroupStrings collect:[:each | each size].
    labels := arrayOfGroupStrings collectAll:[:eachGroup | eachGroup].
    ^ self labelArray:labels lines:lines values:valueArrayOrNil

    "Modified: 20.6.1997 / 10:46:45 / cg"
    "Created: 13.9.1997 / 10:35:46 / cg"
!

labels:aString lines:linesArray values:valueArrayOrNil
    ^ self 
	labelArray:(aString asCollectionOfLines)
	lines:linesArray
	values:valueArrayOrNil

    "Created: / 31.10.1997 / 03:12:20 / cg"
    "Modified: / 31.10.1997 / 03:23:42 / cg"
!

labels:aString values:valueArrayOrNil
    ^ self 
        labelArray:(aString asCollectionOfLines)
        lines:#()
        values:valueArrayOrNil

    "Modified: / 31.10.1997 / 03:23:42 / cg"
    "Created: / 12.11.2001 / 16:06:36 / cg"
! !

!Menu methodsFor:'Compatibility-ST80'!

addLine
    self addSeparator
!

indexOfMenuItem:anItem
    ^ items indexOf:anItem

    "Created: / 27.10.1997 / 16:34:19 / cg"
!

indexOfMenuItemForWhich:aBlock
    ^ items findFirst:aBlock

    "Created: / 27.10.1997 / 16:34:19 / cg"
!

menuButtons
    "ST-80 seems to use a special menuButton class here.
     Here, kludge a collection of menuItems."

    ^ items

    "Created: / 27.10.1997 / 16:33:35 / cg"
! !

!Menu methodsFor:'Compatibility-Squeak'!

add:label target:target selector:selector
    self addItem:(MenuItem label:label itemValue:[target perform:selector]).
!

balloonTextForLastItem:aString
    items last helpText:aString
!

labels:labels lines:lines selections:selections
    |labelArray|

    labels isString ifTrue:[
        labelArray := labels asCollectionOfLines.
    ] ifFalse:[
        labelArray := labels.
    ].

    1 to:labelArray size do:[:idx |
        self addItem:(MenuItem 
                        label:(labelArray at:idx)
                        itemValue:(selections at:idx)).

        (lines includes:idx) ifTrue:[
            self addSeparator.
        ].
    ].

    "Modified: / 09-09-2012 / 13:08:55 / cg"
! !

!Menu methodsFor:'accessing'!

atMenuItemLabeled:aString putSubmenu:aMenu visible:visible
    (self menuItemLabeled:aString)
        submenu:aMenu;
        isVisible:visible

    "Created: / 30-06-2011 / 10:30:22 / cg"
!

atNameKey:aNameKey
    "return the menuItem for the given nameKey; nil if no such item is in the menu.
     Searches in allItems (i.e. also in subMenus)"

    self allItemsDo:[:anItem|
	anItem nameKey == aNameKey ifTrue:[^ anItem]
    ].
    ^ nil

    "Modified: / 27.10.1997 / 15:12:00 / cg"
!

atNameKey:aNameKey ifPresentDo:aBlock
    "look for a menuItem withthe given nameKey. If one is found, aBlock is evaluated for it.
     If not, nothing is done.
     Searches in allItems (i.e. also in subMenus).
     Returns the item or nil."

    |item|

    (item := self atNameKey:aNameKey) notNil ifTrue:[
        aBlock value:item.
    ].
    ^ item
!

groupSizes
    ^ groupSizes
!

groupSizes:something
    groupSizes := something.
!

items
    ^ items
!

items:aCollectionOfMenuItems
    items := aCollectionOfMenuItems
!

labelAt:anIndex
    "gets the label of the menu item at the given index or nil
    "
    |item|

    (item := self menuItemAt:anIndex) notNil ifTrue:[
        ^ item label
    ].
    ^ nil

    "Modified: / 2.2.1998 / 13:28:32 / cg"
!

labelAtValue:aValue
    "gets the label of the menu item assigned to value
    "
    |item|

    item := self menuAndSubmenusDetectItem:[:anItem | anItem value == aValue ].

    item notNil ifTrue:[
        ^ item label
    ].
    ^ nil

    "Modified: / 2.2.1998 / 13:28:28 / cg"
!

labels
    "return a collection of labels from my items"

    items isNil ifTrue:[^ #()].
    ^ items collect:[:anItem | anItem label]

    "Created: / 25.2.1997 / 19:47:53 / cg"
    "Modified: / 19.6.1998 / 02:36:22 / cg"
!

lastItem
    "returns the last item or nil, if there are none"

    ^ items isEmptyOrNil 
        ifTrue:[nil]
        ifFalse:[items last]
!

lines
    "return the indexes of the menu items that are the last menu item in their group (except the very last)."

    |lines groupSz|

    (groupSz := groupSizes size) <= 1 ifTrue: [^ #()].
    lines := Array new:(groupSz - 1).
    lines at:1 put:groupSizes first.
    2 to:(groupSz-1) do:[:i |
        lines at:i put:(lines at:(i - 1)) + (groupSizes at:i)
    ].
    ^ lines

    "Modified: / 2.2.1998 / 13:28:19 / cg"
!

menuItemAt:index 
    "gets the menu item at the given index. When the index is out of bounds
     nil is returned"
    
    (index > 0 and:[ index <= items size ]) ifTrue:[
        ^ items at:index
    ].
    ^ nil

    "Modified: / 30-06-2011 / 10:51:39 / cg"
!

menuItemLabeled:anItemLabel 
    "return the menuItem for the given nameKey; nil if no such item is in the menu.
     Searches all items (i.e. also submenu items)"
    
    self 
        allItemsDo:[:anItem | 
            |l|

            ((l := anItem label) sameAs:anItemLabel) ifTrue:[
                ^ anItem
            ].
            (l includes:$&) ifTrue:[
                ((l copyWithout:$&) sameAs:anItemLabel) ifTrue:[
                    ^ anItem
                ]
            ]
        ].
    ^ nil

    "Created: / 13-09-1997 / 10:25:16 / cg"
    "Modified: / 30-06-2011 / 10:51:44 / cg"
!

menuItemWithArgument:aValue 
    "return the menuItem for the given value; nil if no such item is in the menu.
     Searches all items (i.e. also submenu items)"
    
    self 
        allItemsDo:[:anItem | 
            |l|

            (anItem argument = aValue) ifTrue:[
                ^ anItem
            ].
        ].
    ^ nil

    "Created: / 19-04-2011 / 14:42:18 / cg"
    "Modified: / 30-06-2011 / 10:51:50 / cg"
!

menuItemWithKey:aValue 
    "return the menuItem for the given key; nil if no such item is in the menu.
     Searches all items (i.e. also submenu items)"
    
    self 
        allItemsDo:[:anItem | 

            (anItem nameKey = aValue) ifTrue:[
                ^ anItem
            ].
        ].
    ^ nil

    "Created: / 19-04-2011 / 14:42:18 / cg"
    "Modified: / 30-06-2011 / 10:51:50 / cg"
    "Created: / 07-10-2011 / 15:04:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

menuItemWithValue:aValue 
    "return the menuItem for the given value; nil if no such item is in the menu.
     Searches all items (i.e. also submenu items)"
    
    self 
        allItemsDo:[:anItem | 
            |l|

            (anItem value == aValue) ifTrue:[
                ^ anItem
            ].
        ].
    ^ nil

    "Created: / 13-09-1997 / 10:25:16 / cg"
    "Modified: / 30-06-2011 / 10:51:56 / cg"
!

menuItems
    ^ items ? #()
!

menuItems:aCollectionOfMenuItems menuItemGroups:sizes values:values
    |n|

    items := groupSizes := nil.

    aCollectionOfMenuItems size == 0 ifTrue:[ ^ self ].

    items := aCollectionOfMenuItems.

    sizes size > 0 ifTrue:[
        groupSizes := sizes.

        n := sizes inject:0 into:[:sumSoFar :this | sumSoFar + this].

        n = items size ifTrue:[
            groupSizes := sizes copyButLast:1
        ]
    ].

    values notNil ifTrue:[
        items with:values do:[:anItem :aValue |anItem value:aValue]
    ].

    "Modified: / 19.4.1998 / 11:47:34 / cg"
!

menuPerformer:something
    "set the receiver of the menu messages"

    receiver := something.

    "Modified: / 2.2.1998 / 13:26:29 / cg"
!

numberOfItems
    "return the number of items in this menu"

    ^ items size

    "Created: / 6.3.1997 / 15:15:53 / cg"
    "Modified: / 2.2.1998 / 13:26:40 / cg"
!

receiver
    "return the receiver of the menu messages"

    ^ receiver

    "Modified: / 2.2.1998 / 13:26:20 / cg"
!

receiver:something
    "set the receiver of the menu messages"

    receiver := something.

    "Modified: / 2.2.1998 / 13:26:29 / cg"
!

valueAt:index
    "return a collection of values from my items"

    ^ (items at:index) value

    "Created: 25.2.1997 / 19:49:41 / cg"
!

valueAt:anIndex put:aValue
    "put value an an index"

    (items at:anIndex) value:aValue

    "Created: 6.3.1997 / 15:15:48 / cg"
!

values
    "return a collection of values from my items"

    ^ items collect:[:anItem | anItem value]

    "Created: 25.2.1997 / 19:49:29 / cg"
!

values:aCollectionOfValues
    "return a collection of values from my items"

    |s|

    s := aCollectionOfValues readStream.
    self itemsDo:[:item |
        |val|

        val := s next.
        item value:val
    ].
    s atEnd ifFalse:[
        self error:'not enough elements in the value collection' mayProceed:true
    ]

    "Created: / 27.10.1997 / 15:15:47 / cg"
!

visibleMenuItemGroups
    |itemGroups visibleItemGroups nextItem|

    itemGroups := OrderedCollection new.
    nextItem := 1.
    groupSizes do:[:groupSize |
        itemGroups addLast: (items copyFrom:nextItem to:nextItem + groupSize - 1).
        nextItem := nextItem + groupSize
    ].
    self hasHiddenItems ifFalse:[^ itemGroups].

    "Remove the hidden items."
    visibleItemGroups := OrderedCollection new.
    itemGroups do:[:eachItemGroup |
        |visibleItemGroup|

        visibleItemGroup := eachItemGroup reject:[:eachMenuItem | eachMenuItem hidden].
        visibleItemGroup notEmpty ifTrue:[
            visibleItemGroups addLast: visibleItemGroup
        ]
    ].
    ^ visibleItemGroups

    "Created: / 27.10.1997 / 15:07:50 / cg"
    "Modified: / 2.2.1998 / 13:25:52 / cg"
! !

!Menu methodsFor:'accessing-resource'!

findGuiResourcesIn:aResourceContainerOrApplication
    "setup a resource owner"

    receiver isNil ifTrue:[
        receiver := aResourceContainerOrApplication
    ].
    self 
        findGuiResourcesIn:aResourceContainerOrApplication 
        rememberResourcesIn:(ValueHolder new)

    "Modified: / 26-10-2006 / 16:37:57 / cg"
!

findGuiResourcesIn:aResourceContainerOrApplication rememberResourcesIn:aValueHolderOrNil
    "resolve national language translations from aResourceContainerOrApplication"

    |resolvedItems rcv|

    "/ cg: do not recursively change the receiver - it could be set for the top
    "/ menu via #receiver: by the application.
    "/ if the submenu's receiver is nil, the parentmenus receiver will be used, which is ok.
    "/ But if it was changed below, we would need a recursive setting in #receiver: as well.

"/    receiver isNil ifTrue:[
"/        receiver := aResourceContainerOrApplication
"/    ].
    items isEmptyOrNil ifTrue:[^ self].
    NeedResourcesQuery query ifFalse:[^self].

    resolvedItems := OrderedCollection new.

    items do:[:anItem |
        anItem isMenuSlice ifTrue:[ 
            |resItems|

            rcv := aResourceContainerOrApplication.
            [rcv notNil and:[resItems isNil]] whileTrue:[
                resItems := anItem resolveSliceMenuItemsIn:rcv rememberResourcesIn:aValueHolderOrNil.
                rcv := rcv perform:#masterApplication ifNotUnderstood:nil.
            ].

            resItems notEmptyOrNil ifTrue:[
                resolvedItems addAll:resItems.
            ]
        ] ifFalse:[
            anItem findGuiResourcesIn:aResourceContainerOrApplication rememberResourcesIn:aValueHolderOrNil.
            resolvedItems add:anItem.
        ].
    ].
    items := resolvedItems.

    "Modified: / 22-09-2010 / 13:34:38 / cg"
! !

!Menu methodsFor:'adding & removing'!

addItem:aMenuItem
    "add a menuItem at the end;
     useful to build a menu programmatically (or, to add more items dynamically)"

    items isNil ifTrue:[
        items := OrderedCollection new
    ] ifFalse:[
        items := items asOrderedCollection
    ].
    items add:aMenuItem.

    "Modified: / 4.8.1998 / 17:31:13 / cg"
!

addItem:aMenuItem beforeIndex:anIndex
    "add a menuItem at some position;
     useful to build a menu programmatically (or, to add more items dynamically)"

    items isNil ifTrue:[
        items := OrderedCollection new
    ] ifFalse:[
        items := items asOrderedCollection
    ].
    items add:aMenuItem beforeIndex:anIndex.

    "Modified: / 4.8.1998 / 17:31:39 / cg"
!

addItem:aMenuItem value:aValue
    aMenuItem itemValue:aValue.
    self addItem:aMenuItem.

    "Modified: / 09-09-2012 / 13:08:50 / cg"
!

addItemGroup:aGroup
    "add a group of items at the end;
     useful to build a menu programmatically (or, to add more items dynamically)"

    groupSizes isNil ifTrue:[
        groupSizes := OrderedCollection with:items size.
    ].
    groupSizes add:aGroup size.

    aGroup do:[:item |
        self addItem:item
    ].

    "Created: / 27.10.1997 / 15:02:15 / cg"
    "Modified: / 4.8.1998 / 17:32:06 / cg"
!

addItemGroup:aGroup values:values
    "add a group of items at the end;
     useful to build a menu programmatically (or, to add more items dynamically)"

    aGroup with:values do:[:item :value |
        item value:value
    ].
    self addItemGroup:aGroup

    "Modified: / 4.8.1998 / 17:32:18 / cg"
!

addItemGroupLabels:labels values:values
    "add a group of items at the end;
     useful to build a menu programmatically (or, to add more items dynamically)"

    |items|

    items := labels with:values
                collect:[:label :value | 
                            MenuItem label:label itemValue:value
                        ].
    self addItemGroup:items

    "Created: / 27.10.1997 / 19:49:27 / cg"
    "Modified: / 4.8.1998 / 17:35:22 / cg"
!

addItemLabel:label value:value
    "add an item at the end;
     useful to build a menu programmatically (or, to add more items dynamically)"

    self addItem:(MenuItem label:label itemValue:value)

    "Created: / 27.10.1997 / 19:47:12 / cg"
    "Modified: / 4.8.1998 / 17:34:44 / cg"
!

addItems: collection
    "Add all items in given collection.
     Useful to build a menu programmatically (or, to add more items dynamically)"

    items isNil ifTrue:[
        items := OrderedCollection new
    ] ifFalse:[
        items := items asOrderedCollection
    ].
    items addAll: collection

    "Created: / 01-09-2013 / 16:43:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addItemsFrom: anotherMenu
    "Add all items from another menu.
     Useful to build a menu programmatically (or, to add more items dynamically)"

    self addItems: anotherMenu items ? #()

    "Created: / 01-09-2013 / 16:44:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-10-2013 / 19:28:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addSeparator
    "add a separating line item at the end;
     useful to build a menu programmatically (or, to add more items dynamically)"

    self addItem:(MenuItem separator).
!

removeItem:aMenuItem
    "remove an item from the menu"

    |idx|

    items notNil ifTrue:[
        idx := items identityIndexOf:aMenuItem.
        idx ~~ 0 ifTrue:[
            items removeAtIndex:idx
        ]
    ].

    "Created: / 13.9.1997 / 10:27:31 / cg"
    "Modified: / 2.2.1998 / 13:26:49 / cg"
!

removeItemAt:anIndex
    "remove item at an index
    "
    anIndex <= items size ifTrue:[
        ^ items removeAtIndex:anIndex
    ].
    ^ nil
! !

!Menu methodsFor:'converting'!

asOldStylePopUpMenuFor:anApplicationOrNil
    "a temporary kludge - will vanish, when oldStyle MenuView and PopUpMenu are gone"

    |menuView itemsShown|

    itemsShown := items 
        select:[:each |
            |visibilityInItem|

            visibilityInItem := each isVisible.
            visibilityInItem isNil ifTrue:[
                true
            ] ifFalse:[
                visibilityInItem isBoolean ifTrue:[
                    visibilityInItem
                ] ifFalse:[
                    visibilityInItem isSymbol ifTrue:[
                        anApplicationOrNil isNil
                        or:[ (anApplicationOrNil perform:visibilityInItem) value ].
                    ] ifFalse:[
                        visibilityInItem value
                    ].
                ].
            ].
        ].

    menuView := MenuView 
        labels:(itemsShown collect:[:each | each label])
        selectors:(itemsShown collect:[:each | each value])
        accelerators:(itemsShown collect:[:each | each shortcutKey])
        args:(itemsShown collect:[:each | each argument])
        receiver:receiver.

    itemsShown doWithIndex:[:each :idx |
        |enabledInItem enabled|

        enabledInItem := each enabled.
        enabledInItem notNil ifTrue:[
            enabledInItem isSymbol ifTrue:[
                enabled := anApplicationOrNil isNil or:[ (anApplicationOrNil perform:enabledInItem) ].
            ] ifFalse:[
                enabled := enabledInItem
            ].
            enabled value ifFalse:[
                menuView disable:idx
            ].
        ].
    ].

    menuView actions:(itemsShown
                        collect:[:each |
                            [ 
                                |actionOrSymbol|

                                actionOrSymbol := each itemValue.
                                actionOrSymbol isBlock ifTrue:[
                                    actionOrSymbol value
                                ] ifFalse:[
                                    receiver perform:actionOrSymbol 
                                ]
                            ]
                        ]
                      ).

    ^ PopUpMenu forMenu:menuView

    "Modified: / 30-06-2011 / 10:35:57 / cg"
!

fromLiteralArrayEncoding:aLiteralEncodedArray
    "read my contents from a aLiteralEncodedArray"

    |items groups values|

    items := aLiteralEncodedArray at:2.

    items notNil ifTrue:[
        items := items collect:[:item | item decodeAsLiteralArray].
    ].
    groups := aLiteralEncodedArray at:3 ifAbsent:nil.
    values := aLiteralEncodedArray at:4 ifAbsent:nil.
    self menuItems:items menuItemGroups:groups values:values.

    "extract from PD folder.st:
     #(#Menu #(
                #(#MenuItem 
                        #rawLabel: 'left' 
                        #value: #left ) 
                #(#MenuItem 
                        #rawLabel: 'center' 
                        #value: #center ) 
                #(#MenuItem 
                        #rawLabel: 'right' 
                        #value: #right ) 
              ) 
             #(3 ) 
             nil 
       ) decodeAsLiteralArray
    "
    "
     #(#Menu #(
                #(#MenuItem 
                        #label: 'Straighten Up' ) 
                #(#MenuItem 
                        #label: 'Inspect' ) 
                #(#MenuItem 
                        #label: 'Coredump' ) 
              ) 
             #(3 ) 
            #(#straightenUp #inspect #halt ) 
       ) decodeAsLiteralArray startUp  
    "

    "extract from iconicBrowser.st:
     #(#Menu #(
                #(#MenuItem 
                        #label: 'Straighten Up' ) 
                #(#MenuItem 
                        #label: 'Inspect' ) 
                #(#MenuItem 
                        #label: 'Coredump' ) 
              ) 
             #(3 ) 
             #(1 2 3 )
       ) decodeAsLiteralArray startUp  
    "

    "extract from refactory213.st:
     #(#Menu #(
                #(#MenuItem 
                    #label: 'File List' 
                    #accessCharacterPosition: 1 ) 
                #(#MenuItem #label: 'File Editor...' 
                    #accessCharacterPosition: 6 ) 
                #(#MenuItem #label: 'Refactoring Tool...' 
                    #accessCharacterPosition: 1 ) 
                #(#MenuItem #label: 'Workspace' 
                    #accessCharacterPosition: 1 ) 
                #(#MenuItem #label: 'New Canvas' 
                    #accessCharacterPosition: 1 ) 
                #(#MenuItem #label: 'Palette' 
                    #accessCharacterPosition: 1 ) 
                #(#MenuItem #label: 'Canvas Tool' 
                    #accessCharacterPosition: 1 ) 
                #(#MenuItem #label: 'Image Editor' 
                    #accessCharacterPosition: 1 ) 
                #(#MenuItem #label: 'Menu Editor' 
                    #accessCharacterPosition: 1 ) 
                #(#MenuItem #label: 'Advanced' 
                    #accessCharacterPosition: 1 ) 
                #(#MenuItem #label: 'DLL and C Connect' 
                    #accessCharacterPosition: 1 ) 
                #(#MenuItem #label: 'System Transcript' 
                    #accessCharacterPosition: 8 ) 
              ) 
              #(4 5 2 1 ) 
              #(#openFileList #openFileEditor #openRefactoringTool #toolsNewWorkspace #toolsNewCanvas #toolsPalette #toolsCanvasTool #toolsMaskEditor #toolsMenuEditor nil #openExternalFinder #toggleSystemTranscript ) 
        ) decodeAsLiteralArray startUp
    "

    "submenus:
     #(#Menu #(
                #(#MenuItem 
                        #label: 'Foo' 
                        #submenu: #(#Menu #(
                                            #(#MenuItem #label: 'foo 1')     
                                            #(#MenuItem #label: 'foo 2')     
                                          )
                                          nil
                                          #(11 22)
                                   )     
                 ) 
                #(#MenuItem 
                        #label: 'Inspect' ) 
                #(#MenuItem 
                        #label: 'Coredump' ) 
              ) 
             #(3 ) 
             #(1 2 3 )
       ) decodeAsLiteralArray startUp  
    "

    "Modified: / 08-08-2010 / 14:43:03 / cg"
!

literalArrayEncoding
    "return myself encoded as a literal array"

    |coll array size|

    coll := OrderedCollection new.
    coll add:#Menu.

    (size := items size) == 0  ifTrue:[
        array := nil
    ] ifFalse:[
        array := Array new:size.
        items keysAndValuesDo:[:anIndex :anItem|
            array at:anIndex put:(anItem literalArrayEncoding)
        ]
    ].
    coll add:array.

    (size := groupSizes size) == 0  ifTrue:[
        array := nil
    ] ifFalse:[
        array := Array new:size.
        groupSizes keysAndValuesDo:[:anIndex :aSize|
            array at:anIndex put:(aSize literalArrayEncoding)
        ]
    ].
    coll add:array.
    coll add:nil.
  ^ coll asArray
! !

!Menu methodsFor:'enumerating'!

allItemsDetect:aOneArgBlock ifNone:exceptionalValue
    "find an element amongst each item and submenu items"

    self itemsDo:[:anItem|
        |sub subItem|

        (aOneArgBlock value:anItem) ifTrue:[^ anItem].
        (sub := anItem submenu) notNil ifTrue:[
            subItem := sub allItemsDetect:aOneArgBlock ifNone:nil.
            subItem notNil ifTrue:[^ subItem].
        ]
    ].
    ^ exceptionalValue value
!

allItemsDo:aOneArgBlock
    "evaluate block on each item and submenu items
    "
    self itemsDo:[:anItem|
        |sub|

        aOneArgBlock value:anItem.
        (sub := anItem submenu) notNil ifTrue:[
            sub allItemsDo:aOneArgBlock
        ]
    ]

    "Modified: / 19.6.1998 / 00:34:53 / cg"
!

detectItem:aBlock
    "evaluate the argument, aBlock for each item in the menu until the
     block returns true; in this case return the item which caused the
     true evaluation.
     If none of the evaluations returns true, return the result of the
     evaluation of the exceptionBlock
    "
    ^ self detectItem:aBlock ifNone:[self errorNotFound]

!

detectItem:aBlock ifNone:exceptionBlock
    "evaluate the argument, aBlock for each item in the menu until the
     block returns true; in this case return the item which caused the
     true evaluation.
     If none of the evaluations returns true, return the result of the
     evaluation of the exceptionBlock
    "
    items notNil ifTrue:[
        ^ items detect:aBlock ifNone:exceptionBlock
    ].
    ^ exceptionBlock value
!

itemsDo:aOneArgBlock
    "evaluate the block for each item in the current menu
    "
    items notNil ifTrue:[items do:aOneArgBlock]
!

menuAndSubmenusDetectItem:aOneArgBlock
    "evaluate the block for each item in the current menu and all
     submenus. In case that the block returns a non nil argument,
     the item will be returned
    "
    |item|

    items notNil ifTrue:[
        items do:[:anItem|
            |sub|

            (aOneArgBlock value:anItem) ifTrue:[
                ^ anItem
            ].
            (sub := anItem submenu) notNil ifTrue:[
                item := sub menuAndSubmenusDetectItem:aOneArgBlock.
                item notNil ifTrue:[
                    ^ item
                ]
            ]
        ]
    ].
    ^ nil

    "Modified: / 19.6.1998 / 00:35:00 / cg"
! !

!Menu methodsFor:'kludged fixes'!

destroy
    "dummy to allow a menu to be used where a MenuView used to be"

    "Created: 28.7.1997 / 10:16:52 / cg"
! !

!Menu methodsFor:'menu items'!

removeAllAccelerators
    self allItemsDo:[:eachItem |
        eachItem shortcutKey:nil.
    ].
!

someMenuItemLabeled:aLabel
    "get the menu item with that label; in case that the label
     is not found, nil is returned
    "
    ^ self someMenuItemLabeled:aLabel ifNone:nil

    "Created: / 14.11.1997 / 20:55:17 / cg"
!

someMenuItemLabeled:aLabel ifNone:exceptionBlock
    "get the menu item labeled aLabel; in case that the value
     is not found, the given exceptionBlock is executed and its value returned
    "
    |item|

    item := self menuAndSubmenusDetectItem:[:anItem| anItem label = aLabel].

    item notNil ifTrue:[
	^ item
    ].
    ^ exceptionBlock value

    "Created: / 14.11.1997 / 20:56:13 / cg"
!

someMenuItemWithValue:aValue
    "get the menu item assigned with the value; in case that the value
     is not found nil is returned
    "
    ^ self someMenuItemWithValue:aValue ifNone:nil
!

someMenuItemWithValue:aValue ifNone:exceptionBlock
    "get the menu item assigned with the value; in case that the value
     is not found, the given exceptionBlock is executed and returned
    "
    |item|

    item := self menuAndSubmenusDetectItem:[:anItem| anItem value == aValue].

    item notNil ifTrue:[
	^ item
    ].
  ^ exceptionBlock value
! !

!Menu methodsFor:'queries'!

hasHiddenItems
    "test whether any item is hidden"

    self allItemsDo:[:anItem|
	anItem isHidden ifTrue:[^ true]
    ].
    ^ false

    "Modified: / 27.10.1997 / 15:12:44 / cg"
!

hasItems
    "test whether there are any menu-items"

    ^ items notEmptyOrNil
!

hasSubMenuAt:anIndex
    "test whether the menu item at the given index has a submenu
    "
    ^ (self menuItemAt:anIndex) hasSubmenu
! !

!Menu methodsFor:'startup'!

show
    "realize the menu at its last position; returns the value associated with the
     selected item, 0 if none was selected"

    ^ (MenuPanel menu:self) show ? 0


!

showAt:aPoint
    "realize the menu at aPoint; returns the value associated with the
     selected item, 0 if none was selected"

    ^ self showAt:aPoint resizing:true


!

showAt:aPoint resizing:aBoolean
    "realize the menu at aPoint; returns the value associated with the
     selected item, 0 if none was selected"

    ^ ((MenuPanel menu:self) showAt:aPoint resizing:aBoolean) ? 0

    "Modified: / 8.7.1998 / 19:57:55 / cg"
!

showAtPointer
    "realize the menu at the current pointer position; returns the value associated with the
     selected item, 0 if none was selected"

    ^ self startUp
!

showCenteredIn:aView
    "realize the menu visible at the aView center; returns the value associated with the
     selected item, 0 if none was selected"

    ^ ((MenuPanel menu:self) showCenteredIn:aView) ? 0

    "Modified: / 8.7.1998 / 19:58:05 / cg"
!

startUp
    "display the menu as a popUp; returns the value associated with the
     selected item, nil if none was selected.
     (should we return 0 form ST-80 compatibility ?)"

    ^ (MenuPanel menu:self) startUp "/ ? 0

"   
        |m|

        m := #(#Menu #(
                        #(#MenuItem 
                                #rawLabel: 'left' 
                                #value: #left ) 
                        #(#MenuItem 
                                #rawLabel: 'center' 
                                #value: #center ) 
                        #(#MenuItem 
                                #rawLabel: 'right' 
                                #value: #right ) ) 
                 #(2) 
                nil 
        ) decodeAsLiteralArray.

      Transcript showCR:(m startUp)        
"
!

startUpAt:aPoint
    "display the menu as a popUp at aPoint; returns the value associated with the
     selected item, 0 if none was selected"

    ^ ((MenuPanel menu:self) startUpAt:aPoint) ? 0

"   
        |m|

        m := #(#Menu #(
                        #(#MenuItem 
                                #rawLabel: 'left' 
                                #value: #left ) 
                        #(#MenuItem 
                                #rawLabel: 'center' 
                                #value: #center ) 
                        #(#MenuItem 
                                #rawLabel: 'right' 
                                #value: #right ) ) 
                 #(2) 
                nil 
        ) decodeAsLiteralArray.

      Transcript showCR:(m startUpAt:100@100)        
"

    "Created: / 21.5.1998 / 14:15:21 / cg"
    "Modified: / 21.5.1998 / 14:17:46 / cg"
!

startUpFor:originatingWidget
    "display the menu as a popUp; returns the value associated with the
     selected item, nil if none was selected.
     (should we return 0 for ST-80 compatibility ?)"

    ^ (MenuPanel menu:self) startUpFor:originatingWidget "/ ? 0

"   
        |m|

        m := #(#Menu #(
                        #(#MenuItem 
                                #rawLabel: 'left' 
                                #value: #left ) 
                        #(#MenuItem 
                                #rawLabel: 'center' 
                                #value: #center ) 
                        #(#MenuItem 
                                #rawLabel: 'right' 
                                #value: #right ) ) 
                 #(2) 
                nil 
        ) decodeAsLiteralArray.

      Transcript showCR:(m startUp)        
"
!

startUpOrNil
    "display the menu as a popUp; returns the value associated with the
     selected item, nil if none was selected"

    ^ (MenuPanel menu:self) startUpOrNil
! !

!Menu methodsFor:'utilities'!

replaceArgument: oldValue with: newValue

    "Recusively Replace argument in menu items where
     current argument is equal to oldValue by newValue"

    self itemsDo:[:item|
        item replaceArgument: oldValue with: newValue
    ]

    "Created: / 12-10-2011 / 20:11:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Menu::NeedResourcesQuery class methodsFor:'defaults'!

defaultAnswer
    ^ true
! !

!Menu class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

