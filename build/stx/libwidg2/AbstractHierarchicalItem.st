"
 COPYRIGHT (c) 1999/2015 by eXept Software AG
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

Object subclass:#AbstractHierarchicalItem
	instanceVariableNames:'parent children'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Support'
!

!AbstractHierarchicalItem class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1999/2015 by eXept Software AG
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
    Hierarchical Items are mostly like Models, but the list of
    dependencies are kept by its HierarchicalList.
    The class is used to build up hierarchical trees.

    2015 update:
        the original HierarchicalItem has been refactored into this abstract class,
        which provides all the mechanisms, but leaves the concrete representation
        of some slots open.
        These are:
            - if and how the geometry information (width + height) are cached,
            - if and how the expanded-state is remembered.
            - if and how the underlying model is fetched

        The old class used private slots for the first three (width-height-isExpanded),
        but did not keep a reference to the model. This leads to a very poor performance,
        as many algorithms degenerated to O(n log(n)) or even O(n^2) time behavior,
        as the model was fetched by walking along the parent chain - sometimes for every item
        in a long list.

        The old class is still around and may be used for small trees,
        but we recommend rewriting applications to use the new CompactHierarchicalItem
        class, which behaves the same on the outside, but uses clever tricks to be both more
        space efficient (saving 2 slots) and time efficient (caching the model).
        For this, make sure that the subclass does not access the instvars isExpanded, width and height
        directly, but uses the getters isExpanded, width and height and the setters setExpanded:, width: and height:

    [Instance variables:]
        parent      <Item, List or nil>         parent or my HierarchicalList.
        children    <Collection or nil>         list of children

    [author:]
        Claus Gittinger (redesign and refactoring)

    [see also:]
        HierarchicalItem (the old item class)
        HierarchicalList (typical model)
        HierarchicalListView (typical user of me)
"
! !

!AbstractHierarchicalItem class methodsFor:'instance creation'!

new
    ^ (self basicNew) initialize
!

parent:aParent
    |item|

    item := self new.
    item parent:aParent.
  ^ item
! !

!AbstractHierarchicalItem class methodsFor:'protocol'!

doResetExtentOnChange
    "true: the extent of the item is reset if a change
     notification is raised from the item. the default is true
    "
    ^ true
! !

!AbstractHierarchicalItem methodsFor:'accessing'!

getChildren
    "returns the children as they are present (or not); not going to the model..."

    ^ children
!

level
    "returns the level starting with 0 for the root"

    |item level|

    item := self.
    level := 0.

    [ (item := item parentOrModel) notNil] whileTrue:[
        level := level + 1.
        level > 100000 ifTrue:[
            self halt:'possibly recursive item hierarchy'
        ].
    ].
    ^ level

    "Modified: / 09-07-2010 / 08:56:27 / cg"
!

parent
    "returns the parent or nil"

    ^ (parent notNil and:[parent isHierarchicalItem]) 
        ifTrue:[parent]
        ifFalse:[nil]
!

parent:aParent
    "set the parent (or the model if the item is the root item)"

    parent := aParent
!

rootItem
    "returns the root item"

    parent isHierarchicalItem ifTrue:[
        ^ parent rootItem
    ].
    ^ self
! !

!AbstractHierarchicalItem methodsFor:'accessing-children'!

at:anIndex
    "return the child at anIndex if valid;
     if the index is invalid, nil is returned"

    ^ self at:anIndex ifAbsent:nil
!

at:anIndex ifAbsent:exceptionBlock
    "return the child at anIndex if valid; if the index is
     invalid, the result of evaluating the exceptionBlock is returned."

    |list|

    (list := self children) notNil ifTrue:[
        ^ list at:anIndex ifAbsent:exceptionBlock
    ].
    ^ exceptionBlock value
!

at:anIndex put:anItem
    "replace a child by a new item. return anItem (sigh)"

    |children oldItem visIndex model expFlag|

    anItem isNil ifTrue:[
        self removeFromIndex:anIndex toIndex:anIndex.
        ^ nil
    ].
    anItem parent:self.

    (model := self model) isNil ifTrue:[
        self children at:anIndex put:anItem.
        ^ anItem
    ].

    model criticalDo:[
        children := self children.
        oldItem  := children at:anIndex.

        oldItem isExpanded ifTrue:[
            oldItem collapse
        ].
        visIndex := model identityIndexOf:oldItem.
        expFlag  := anItem isExpanded.
        anItem setExpanded:false.

        children at:anIndex put:anItem.

        visIndex ~~ 0 ifTrue:[
            model at:visIndex put:anItem.
        ].
        self changed:#redraw.
        expFlag ifTrue:[ anItem expand ].
    ].
    ^ anItem
!

children:aListOfChildren
    "set a new list of children"

    self criticalDo:[
        self removeAll.
        self addAll:aListOfChildren beforeIndex:1
    ].
    ^ aListOfChildren
!

first
    "returns the first child
    "
    ^ self at:1
!

last
    "returns the last child"

    ^ self at:(self size)
!

second
    "returns the second child"

    ^ self at:2
! !

!AbstractHierarchicalItem methodsFor:'accessing-hierarchy'!

collapse
    "hide all my subitems"

    |visChd index|

    self canCollapse ifTrue:[
        self setExpanded:false.

        self criticalDo:[
            (index := self listIndex) notNil ifTrue:[
                "/ do not call :#size: children will be autoloaded !!!!
                (visChd := children size) ~~ 0 ifTrue:[
                    self nonCriticalFrom:1 to:nil do:[:el|
                        visChd := visChd + el numberOfVisibleChildren
                    ].
                    self model itemRemoveFromIndex:(index + 1) toIndex:(index + visChd).
                ].
                index ~~ 0 ifTrue:[self hierarchyChanged].
            ]
        ]
    ]
!

enforcedExpand
    "expand children - even if there are no children,
     the item is initially expanded (but this might be undone later,
     when we know that no children are there"

    self expand:true
!

expand
    "expand children - but only if there are children 
     (i.e. this cannot be used before the childInfo is valid;
      aka not before the updateTask came along this item)"

    self expand:false
!

expand:enforced
    "expand children"

    |index list|

    "/ test whether the item already is expanded; #canExpand could be redefined
    "/ without checking whether the node is expanded (happens already) !!

    self isExpanded ifTrue:[ ^ self ].
    (enforced not and:[self canExpand not]) ifTrue:[ ^ self ].

    self criticalDo:[
        (index := self listIndex) notNil ifTrue:[
            "/ must set expand-flag to false, otherwise change notifications
            "/ are raised during lazy auto creation (to the list).
            self setExpanded:false.
            list := self children.
            self setExpanded:true.

            list notEmptyOrNil ifTrue:[
                list := OrderedCollection new.
                self addVisibleChildrenTo:list.
                self model itemAddAll:list beforeIndex:(index + 1).
            ].
            index ~~ 0 ifTrue:[self hierarchyChanged].
        ] ifFalse:[
            self setExpanded:true
        ]
    ].
!

makeVisible
    "expand all my parents"

    (parent notNil and:[parent isHierarchicalItem]) ifTrue:[
        self criticalDo:[
            parent makeVisible.
            parent expand.
        ]
    ].
!

recursiveCollapse
    "collapse all item and sub items
     **** must be expanded
    "
    |visChd index|

    self canCollapse ifTrue:[
        self criticalDo:[
            (index := self listIndex) notNil ifTrue:[
                "/ do not call :#size: children will be autoloaded !!!!
                (visChd := children size) ~~ 0 ifTrue:[
                    self nonCriticalFrom:1 to:nil do:[:el|
                        visChd := visChd + el numberOfVisibleChildren
                    ].
                ].
                self recursiveSetCollapsed.

                visChd ~~ 0 ifTrue:[
                    self model itemRemoveFromIndex:(index + 1)
                                           toIndex:(index + visChd)
                ].
                index ~~ 0 ifTrue:[
                    self hierarchyChanged
                ]
            ] ifFalse:[
                self recursiveSetCollapsed
            ]
        ]
    ]
!

recursiveExpand
    "expand children and sub-children
     **** must be collapsed"

    "/ test whether the item already is expanded; #canExpand could be redefined
    "/ without checking whether the node is expanded (happens already) !!

    |index list|

    self isExpanded ifTrue:[ ^ self ].

    self canExpand ifFalse:[ ^ self ].

    self setExpanded:true.

    self criticalDo:[
        self size ~~ 0 ifTrue:[
            index := self listIndex.    "/ get the visible list index

            index isNil ifTrue:[        "/ not visible
                self nonCriticalFrom:1 to:nil do:[:el|
                    el setExpanded:true
                ].
            ] ifFalse:[
                list := OrderedCollection new.
                self recursiveSetExpandedAndAddToList:list.
                self model itemAddAll:list beforeIndex:(index + 1).

                index ~~ 0 ifTrue:[self hierarchyChanged]
            ]
        ]
    ].
!

recursiveToggleExpand
    "if the item is collapsed, the item and all its sub-items
     are expanded otherwise collapsed"

    self isExpanded ifTrue:[
        self recursiveCollapse
    ] ifFalse:[
        self recursiveExpand
    ]
!

toggleExpand
    "if the item is collapsed, the item is expanded otherwise collapsed"

    self isExpanded ifTrue:[
        self collapse
    ] ifFalse:[
        self expand
    ].
! !

!AbstractHierarchicalItem methodsFor:'accessing-mvc'!

application
    "returns the responsible application or nil"

    |model|

    (model := self model) notNil ifTrue:[
        ^ model application
    ].
    ^ nil
!

applicationsDo:aOneArgBlock
    "evaluate the block for each dependent application"

    |model|

    (model := self model) notNil ifTrue:[
        model applicationsDo:aOneArgBlock
    ]
!

model
    "returns the hierachicalList model or nil.
     This is a stupid implementation here, in that the top-item's parent is assumed to
     be the model of the tree, and that is returned.
     This saves a slot in every node, but makes some algorithms O(n*log n) or even O(n^2).
     So be aware of the performance penalty"

    |item next|

    item := self. 
    [ (next := item parentOrModel) notNil ] whileTrue:[
        item := next.
    ].

    item isHierarchicalItem ifFalse:[^ item].
    ^ nil
! !

!AbstractHierarchicalItem methodsFor:'adding & removing'!

add:aChildItem
    "add a child at end"

    ^ self add:aChildItem beforeIndex:(self children size + 1).
!

add:aChildItem after:aChild
    "add an item after an existing item"

    |index|

    index := self identityIndexOf:aChild.
    index == 0 ifTrue:[ self subscriptBoundsError:index ].

    self add:aChildItem beforeIndex:(index + 1).
    ^ aChildItem
!

add:aChildItem afterIndex:anIndex
    "add an item after an index"

    ^ self add:aChildItem beforeIndex:(anIndex + 1).
!

add:aChildItem before:aChild
    "add an item before an existing item"

    |index|

    index := self identityIndexOf:aChild.
    index == 0 ifTrue:[ self subscriptBoundsError:index ].

    self add:aChildItem beforeIndex:index.
    ^ aChild
!

add:aChildItem beforeIndex:anIndex
    "add an item before an index"

    aChildItem notNil ifTrue:[
        self addAll:(Array with:aChildItem) beforeIndex:anIndex
    ].
    ^ aChildItem
!

add:aChild sortBlock:aBlock
    "add a child sorted"

    self criticalDo:[
        self basicAdd:aChild sortBlock:aBlock
    ].
    ^ aChild
!

addAll:aList
    "add children at the end"

    ^ self addAll:aList beforeIndex:(self children size + 1)
!

addAll:aList before:aChild
    "add an item before an existing item"

    |index|

    index := self identityIndexOf:aChild.
    index == 0 ifTrue:[ self subscriptBoundsError:index ].

    ^ self addAll:aList beforeIndex:index
!

addAll:aList beforeIndex:anIndex
    "add children before an index"

    aList size ~~ 0 ifTrue:[
        self criticalDo:[
            self basicAddAll:aList beforeIndex:anIndex
        ]
    ].
    ^ aList
!

addAll:aList sortBlock:aBlock
    "add children sorted"

    aList size == 0 ifTrue:[ ^ aList ].

    aBlock isNil ifTrue:[
        self addAll:aList.
    ] ifFalse:[
        self criticalDo:[
            aList do:[:el| self basicAdd:el sortBlock:aBlock ]
        ]
    ].
    ^ aList
!

addAllFirst:aCollectionOfItems
    "add children at the beginning"

    ^ self addAll:aCollectionOfItems beforeIndex:1
!

addAllLast:aCollectionOfItems
    "add children at the end"

    ^ self addAll:aCollectionOfItems
!

addFirst:aChildItem
    "add a child at the beginning"

    ^ self add:aChildItem beforeIndex:1.
!

addLast:anItem
    "add a child at the end"

    ^ self add:anItem
!

remove
    "remove the item"

    parent notNil ifTrue:[                                      "check whether parent exists"
        parent isHierarchicalItem ifTrue:[parent remove:self]   "parent is HierarchicalItem"
                                 ifFalse:[parent root:nil]      "parent is HierarchicalList"
    ].
    ^ self
!

remove:aChild
    "remove a child"

    self removeIndex:(self identityIndexOf:aChild)
!

removeAll
    "remove all children"

    |size|

    (size := children size) ~~ 0 ifTrue:[
        self removeFromIndex:1 toIndex:size
    ]
!

removeAll:aList
    "remove all children in the collection"

    |index|

    aList size ~~ 0 ifTrue:[
        self criticalDo:[
            aList do:[:el|
                (index := self identityIndexOf:el) ~~ 0 ifTrue:[
                    self removeIndex:index
                ]
            ]
        ]
    ].
    ^ aList
!

removeAllIdentical:aList
    "remove all children in the collection"

    self removeAll:aList.
    ^ aList

    "Created: / 20-09-2010 / 09:43:06 / sr"
!

removeFromIndex:startIndex
    "remove the children from startIndex up to end of children"

    ^ self removeFromIndex:startIndex toIndex:(children size)
!

removeFromIndex:startIndex toIndex:stopIndex
    "remove the children from startIndex up to and including
     the child under stopIndex.
     Returns the receiver."

    |nrOfChildren stop|

    nrOfChildren := children size.

    (startIndex <= stopIndex and:[startIndex <= nrOfChildren]) ifTrue:[
        stop := stopIndex min:nrOfChildren.
        
        self criticalDo:[
            self basicRemoveFromIndex:startIndex toIndex:stop
        ]
    ].

    children size == 0 ifTrue:[
        self clearExpandedWhenLastChildWasRemoved ifTrue:[
            self setExpanded:false.
        ]
    ].
!

removeIndex:anIndex
    "remove the child at an index"

    anIndex > 0 ifTrue:[
        self removeFromIndex:anIndex toIndex:anIndex
    ]
! !

!AbstractHierarchicalItem methodsFor:'basic adding & removing'!

basicAdd:aChild sortBlock:aBlock
    "add a child sorted"

    |size list|

    size := children size.
    list := Array with:aChild.

    (aBlock notNil and:[size ~~ 0]) ifTrue:[
        children keysAndValuesDo:[:i :el|
            (aBlock value:aChild value:el) ifTrue:[
                self basicAddAll:list beforeIndex:i.
                ^ aChild
            ]
        ]
    ].
    self basicAddAll:list beforeIndex:(size + 1).
    ^ aChild.
!

basicAddAll:aList beforeIndex:anIndex
    "add children before an index"

    |coll model notify index size|

    size := children size.

    anIndex == 1 ifTrue:[
        notify := self
    ] ifFalse:[
        anIndex > size ifTrue:[
            anIndex > (1 + size) ifTrue:[
                ^ self subscriptBoundsError:index
            ].
            notify := self at:size
        ] ifFalse:[
            notify := nil
        ]
    ].
    children isArray ifTrue:[
        children := children asOrderedCollection
    ] ifFalse:[
        size == 0 ifTrue:[
            children := OrderedCollection new
        ].
    ].
    aList do:[:anItem| anItem parent:self ].
    children addAll:aList beforeIndex:anIndex.

    (model := self model) isNil ifTrue:[
        ^ aList
    ].

    self isExpanded ifFalse:[
        notify notNil ifTrue:[
            notify changed
        ].
        ^ aList
    ].
    (index := self listIndex) isNil ifTrue:[
        ^ aList
    ].

    children from:1 to:(anIndex - 1) do:[:anItem|
        index := 1 + index + anItem numberOfVisibleChildren
    ].
    coll := OrderedCollection new.

    aList do:[:anItem|
        coll add:anItem.
        anItem addVisibleChildrenTo:coll.
    ].
    model itemAddAll:coll beforeIndex:(index + 1).

    notify notNil ifTrue:[
        notify changed
    ].
    ^ aList
!

basicRemoveFromIndex:startIndex toIndex:stopIndex
    "remove the children from startIndex up to and including
     the child under stopIndex."

    |model notify
     index "{ Class:SmallInteger }"
     start "{ Class:SmallInteger }"
     stop  "{ Class:SmallInteger }"
     size  "{ Class:SmallInteger }"
    |
    size  := self children size.
    stop  := stopIndex.
    start := startIndex.

    (stop <= size and:[start between:1 and:stop]) ifFalse:[
        ^ self subscriptBoundsError:index
    ].
    start == 1 ifTrue:[
        notify := self
    ] ifFalse:[
        stop == size ifTrue:[
            notify := self at:(start - 1)
        ] ifFalse:[
            notify := nil
        ]
    ].

    (model := self model) notNil ifTrue:[
        index := model identityIndexOf:(children at:start).
        size  := stop - start + 1.
    ] ifFalse:[
        index := 0
    ].

    children from:start to:stop do:[:aChild|
        index ~~ 0 ifTrue:[
            size := size + aChild numberOfVisibleChildren
        ].
        aChild parent:nil
    ].
    children removeFromIndex:start toIndex:stop.

    index ~~ 0 ifTrue:[
        model itemRemoveFromIndex:index toIndex:(index + size - 1)
    ].
    notify notNil ifTrue:[
        notify changed
    ].
! !

!AbstractHierarchicalItem methodsFor:'change & update'!

changed:what with:anArgument
    "the item changed; raise change notification
        #icon           icon is modified; height and width are unchanged
        #hierarchy      collapsed/expanded; height and width are unchanged
        #redraw         redraw but height and width are unchanged
        .......         all others: the height and width are reset
    "
    |model|

    what ~~ #redraw ifTrue:[
        (what ~~ #hierarchy and:[what ~~ #icon]) ifTrue:[
            self class doResetExtentOnChange ifTrue:[
                self makeWidthAndHeightUnknown
            ].
        ].
    ].
    (model := self model) notNil ifTrue:[
        model itemChanged:what with:anArgument from:self
    ].
    super changed:what with:anArgument

    "Modified: / 24-11-2010 / 17:21:20 / cg"
!

childrenOrderChanged
    "called if the order of the children changed by a user
     operation. Update the model and raise a change notification for
     each item which has changed its position
     triggered by the user operation !!"

    |model visStart list|

    self isExpanded   ifFalse:[ ^ self ].       "/ not expanded
    children size > 1 ifFalse:[ ^ self ].

    model := self model.
    model isNil ifTrue:[^ self].                       "/ no model

    visStart := model identityIndexOf:self.
    visStart == 0 ifTrue:[
        model root ~~ self ifTrue:[ ^ self ].
     "/ I'am the root but switched of by setting #showRoot to false
    ].

    self criticalDo:[
        list := OrderedCollection new.
        self addVisibleChildrenTo:list.

        list do:[:el|
            visStart := visStart + 1.

            (model at:visStart ifAbsent:el) ~~ el ifTrue:[
                model at:visStart put:el
            ].
        ]
    ].
!

fontChanged
    "called if the font has changed.
     Clear the precomputed width and height"

    self makeWidthAndHeightUnknown.

    children size ~~ 0 ifTrue:[
        children do:[:el| el fontChanged].
    ].
!

hierarchyChanged
    "hierarchy changed; optimize redrawing"

    self changed:#hierarchy with:nil
!

iconChanged
    "icon changed; optimize redrawing"

    self changed:#icon with:nil
!

labelChanged
    "called if the label has changed.
     Clear the precomputed width and height"

    self makeWidthAndHeightUnknown.

    "Created: / 17-01-2011 / 17:43:42 / cg"
! !

!AbstractHierarchicalItem methodsFor:'enumerating'!

collect:aBlock
    "for each child in the receiver (non recursive), evaluate the argument, aBlock
     and return a new collection with the results"

    |coll|

    coll := OrderedCollection new.
    self do:[:el| coll add:(aBlock value:el) ].
    ^ coll

    "Modified (comment): / 25-11-2016 / 08:42:19 / cg"
!

contains:aBlock
    "evaluate aOneArgBlock for each of the receiver's children (non recursive).
     Return true and skip remaining elements, if aBlock ever returns true, 
     otherwise return false"

    self do:[:el | (aBlock value:el) ifTrue:[^ true] ].
    ^ false

    "Modified (comment): / 25-11-2016 / 08:43:31 / cg"
!

do:aOneArgBlock
    "evaluate a block for each child (non recursive)"

    self from:1 to:nil do:aOneArgBlock

    "Modified (comment): / 25-11-2016 / 08:43:36 / cg"
!

from:startIndex do:aOneArgBlock
    "evaluate a block on each child starting with the
     child at startIndex to the end."

    self from:startIndex to:nil do:aOneArgBlock

    "Modified (comment): / 25-11-2016 / 07:45:55 / cg"
!

from:startIndex reverseDo:aOneArgBlock
    "evaluate a block on each child (non recursive) starting at end to the startIndex"

    self from:startIndex to:nil reverseDo:aOneArgBlock

    "Modified (comment): / 25-11-2016 / 08:43:42 / cg"
!

from:startIndex to:endIndex do:aOneArgBlock
    "evaluate a block on each child (non recursive),
     starting with the child at startIndex to the endIndex."

    |res|

    self size < startIndex ifTrue:[^ self "nil"].
    res := nil.

    self criticalDo:[
        res := self nonCriticalFrom:startIndex to:endIndex do:aOneArgBlock
    ].
    "/ ^ res - return the receiver, as all other collections do

    "Modified (comment): / 25-11-2016 / 08:43:51 / cg"
!

from:startIndex to:endIndex reverseDo:aOneArgBlock
    "evaluate a block on each child (non recursive),
     starting with the child at endIndex to the startIndex."

    |res|

    self size < startIndex ifTrue:[^ self "nil"].
    res := nil.

    self criticalDo:[
        res := self nonCriticalFrom:startIndex to:endIndex reverseDo:aOneArgBlock
    ].
    "/ ^ res - return the receiver, as all other collections do

    "Modified (comment): / 25-11-2016 / 08:43:58 / cg"
!

keysAndValuesDo:aTwoArgBlock
    "evaluate the argument, aBlock for every child (non recursive),
     passing both index and element as arguments."

    |key res|

    key := 1.
    res := nil.

    self do:[:el|
        res := el value:key value:el.
        key := key + 1.
    ].
    "/ ^ res - no: return the receiver, as all other collections do

    "Modified (comment): / 25-11-2016 / 08:44:03 / cg"
!

keysAndValuesReverseDo:aTwoArgBlock
    "evaluate the argument, aBlock in reverse order for every child (non recursive), 
     passing both index and element as arguments."

    |res|

    self size == 0 ifTrue:[^ self "nil"].
    res := nil.

    self criticalDo:[
        res := self nonCriticalKeysAndValuesReverseDo:aTwoArgBlock
    ].
    "/ ^ res - no: return the receiver, as all other collections do

    "Modified (comment): / 25-11-2016 / 08:44:06 / cg"
!

recursiveCollect:aBlock
    "for each child in the receiver, evaluate the argument, aBlock
     and return a new collection with the results.
     Warning: this only enumerates already visible child elements
     i.e. any collapsed items are not visited."

    |coll|

    coll := OrderedCollection new.
    self recursiveDo:[:el| coll add:(aBlock value:el) ].
    ^ coll

    "Modified (comment): / 25-11-2016 / 08:43:20 / cg"
!

recursiveDo:aOneArgBlock
    "evaluate a block on each item and all the sub-items.
     Warning: this only enumerates already visible child elements
     i.e. any collapsed items are not visited."

    self do:[:aChild|
        aOneArgBlock value:aChild.
        aChild nonCriticalRecursiveDo:aOneArgBlock
    ].

    "Modified (comment): / 25-11-2016 / 08:43:04 / cg"
!

recursiveReverseDo:aOneArgBlock
    "evaluate a block on each item and all the sub-items;
     proccesing children in reverse direction.
     Warning: this only enumerates already visible child elements
     i.e. any collapsed items are not visited."

    self reverseDo:[:aChild|
        aChild nonCriticalRecursiveReverseDo:aOneArgBlock.
        aOneArgBlock value:aChild.
    ].

    "Modified (comment): / 25-11-2016 / 08:43:09 / cg"
!

recursiveSelect:aBlock
    "return a new collection with all children and subChildren from the receiver, 
     for which the argument aBlock evaluates to true.
     Warning: this only enumerates already visible child elements
     i.e. any collapsed items are not visited."

    |coll|

    coll := OrderedCollection new.
    self recursiveDo:[:el| (aBlock value:el) ifTrue:[coll add:el] ].
    ^ coll

    "Modified (comment): / 25-11-2016 / 08:43:12 / cg"
!

reverseDo:aOneArgBlock
    "evaluate a block on each child (non recursive) in reverse direction"

    self from:1 reverseDo:aOneArgBlock

    "Modified (comment): / 25-11-2016 / 08:44:12 / cg"
!

select:aBlock
    "return a new collection with all items from the receiver (non recursive), 
     for which the argument aBlock evaluates to true."

    |coll|

    coll := OrderedCollection new.
    self do:[:el| (aBlock value:el) ifTrue:[coll add:el] ].
    ^ coll

    "Modified (comment): / 25-11-2016 / 08:44:20 / cg"
!

withAllDo:aOneArgBlock
    "recursively evaluate aOneArgBlock on each item and subitem including self"

    aOneArgBlock value:self.

    self do:[:el|
        aOneArgBlock value:el.
        el nonCriticalRecursiveDo:aOneArgBlock.
    ].

    "Modified (comment): / 25-11-2016 / 08:44:49 / cg"
! !

!AbstractHierarchicalItem methodsFor:'enumerating parents'!

parentsDetect:aBlock
    "find the first parent, for which evaluation of the block returns
     true; if none does so, report an error"

    ^ self parentsDetect:aBlock ifNone:[self errorNotFound]
!

parentsDetect:aBlock ifNone:anExceptionBlock
    "find the first parent, for which evaluation of the block returns
     true; if none does so, return the evaluation of anExceptionBlock"

    |prnt|

    prnt := self.

    self criticalDo:[
        [(prnt := prnt parent) notNil and:[prnt isHierarchicalItem]] whileTrue:[
            (aBlock value:prnt) ifTrue:[^ prnt]
        ]
    ].
    ^ anExceptionBlock value
!

parentsDo:aBlock
    "evaluate a block for each parent"

    |prnt|

    prnt := self.

    self criticalDo:[
        [(prnt := prnt parent) notNil and:[prnt isHierarchicalItem]] whileTrue:[
            aBlock value:prnt
        ]
    ].
! !

!AbstractHierarchicalItem methodsFor:'initialization'!

initialize
    self setExpanded:false
! !

!AbstractHierarchicalItem methodsFor:'private'!

addVisibleChildrenTo:aList
    "add all visible children and sub-children to the list"

    self isExpanded ifFalse:[^ self].

    self nonCriticalFrom:1 to:nil do:[:el|
        aList add:el.
        el addVisibleChildrenTo:aList.
    ].
!

clearExpandedWhenLastChildWasRemoved
    ^ true
!

criticalDo:aBlock
    |model|

    (model := self model) notNil ifTrue:[
        model recursionLock critical:aBlock
    ] ifFalse:[
        aBlock value
    ]
!

listIndex
    "returns the visible index or nil; for a non-visible root, 0 is returned"

    |index model|

    (model := self model) notNil ifTrue:[
        index := model identityIndexOf:self.

        (index ~~ 0 or:[parent == model]) ifTrue:[
            ^ index
        ]
    ].
    ^ nil
!

numberOfVisibleChildren
    "returns number of all visible children including subchildren"

    |size|

    self isExpanded ifFalse:[^ 0].
    size := 0.

    self nonCriticalFrom:1 to:nil do:[:el|
        size := 1 + size + el numberOfVisibleChildren
    ].
    ^ size
!

parentOrModel
    "returns the parent without checking for item or model"

    ^ parent
! !

!AbstractHierarchicalItem methodsFor:'private-displaying'!

displayLabel:aLabel h:lH on:aGC x:x y:y h:h
    <resource: #obsolete>
 
    "display the label at x@y"

    "/ obsolete - left in for backward compatibility
    self displayLabel:aLabel h:lH on:aGC x:x y:y h:h isHighlightedAsSelected:false
!

displayLabel:aLabel h:lH on:aGC x:x y:y h:h isHighlightedAsSelected:isHighlightedAsSelected
    "display the label at x@y"

    |y0|

    lH ~~ 0 ifTrue:[
        y0 := y - ((lH + 1 - h) // 2).
        y0 := y0 + (aLabel ascentOn:aGC).

        (aLabel isString not
        or:[(aLabel includes:(Character cr)) not]) ifTrue:[
            |labelShown|

            labelShown := aLabel.
            isHighlightedAsSelected ifTrue:[
                (aLabel isText and:[aLabel hasChangeOfEmphasis]) ifTrue:[
                    labelShown := Text string:aLabel string emphasisCollection:aLabel emphasis asArray.
                    labelShown emphasisAllRemove:#color.
                ].
            ].
            ^ labelShown displayOn:aGC x:x y:y0
        ].

        aLabel asCollectionOfLines do:[:el|
            |labelShown|

            labelShown := el.
            isHighlightedAsSelected ifTrue:[
                (el isText and:[el hasChangeOfEmphasis]) ifTrue:[
                    labelShown := Text string:el string emphasisCollection:el emphasis asArray.
                    labelShown emphasisAllRemove:#color.
                ].
            ].
            labelShown displayOn:aGC x:x y:y0.
            y0 := y0 + (el heightOn:aGC)
        ]
    ].
!

heightOf:aLabel on:aGC
    "returns the height of the label or 0"

    |h|

    aLabel isSequenceable ifFalse:[
        ^ aLabel notNil ifTrue:[aLabel heightOn:aGC] ifFalse:[0]
    ].

    aLabel isString ifFalse:[
        h := 0.
        aLabel do:[:el|h := h max:(self heightOf:el on:aGC)].
        ^ h
    ].

    h := 1 + (aLabel occurrencesOf:(Character cr)).
    ^ h * (aGC font height)
!

widthOf:aLabel on:aGC
    "returns the height of the label or 0"

    |w|

    aLabel isSequenceable ifFalse:[
        ^ aLabel notNil ifTrue:[aLabel widthOn:aGC] ifFalse:[0]
    ].

    aLabel isString ifFalse:[
        w := -5.
        aLabel do:[:el|w := w + 5 + (self widthOf:el on:aGC)].
        ^ w
    ].

    (aLabel indexOf:(Character cr)) == 0 ifTrue:[
        ^ aLabel widthOn:aGC
    ].

    w := 0.
    aLabel asCollectionOfLines do:[:el|w := w max:(el widthOn:aGC)].
    ^ w
! !

!AbstractHierarchicalItem methodsFor:'private-enumerating'!

nonCriticalDo:aOneArgBlock
    "evaluate a block noncritical for each child."

    ^ self nonCriticalFrom:1 to:nil do:aOneArgBlock
!

nonCriticalFrom:startIndex to:endIndex do:aOneArgBlock
    "evaluate a block noncritical for each child starting with the
     child at startIndex to the endIndex (if nil to end of list)."

    |list size resp|

    list := self children.
    size := list size.

    startIndex > size ifTrue:[^ nil].
    resp := nil.

    endIndex notNil ifTrue:[
        size := size min:endIndex
    ].
    startIndex to:size do:[:i| 
        |item|

        item := list at:i ifAbsent:nil.
        item isNil ifTrue:[^ resp].
        resp := aOneArgBlock value:item.
    ].
    ^ resp
!

nonCriticalFrom:startIndex to:endIndex reverseDo:aOneArgBlock
    "evaluate a block non critical for each child starting with the
     child at endIndex (if nil to end of list) to startIndex."

    |list size resp|

    list := self children.
    size := list size.
    resp := nil.

    endIndex notNil ifTrue:[
        size := size min:endIndex
    ].
    size to:startIndex by:-1 do:[:i| 
        |item|

        item := list at:i ifAbsent:nil.
        item isNil ifTrue:[^ resp].
        resp := aOneArgBlock value:item.
    ].
    ^ resp
!

nonCriticalKeysAndValuesReverseDo:aOneArgBlock
    "evaluate the argument, aBlock in reverse order for every
     child, passing both index and element as arguments."

    |list size resp|

    list := self children.
    size := list size.
    resp := nil.

    size to:1 by:-1 do:[:i| 
        |item|

        item := list at:i ifAbsent:nil.
        item isNil ifTrue:[^ resp].
        resp := aOneArgBlock value:i value:item.
    ].
    ^ resp
!

nonCriticalRecursiveDo:aOneArgBlock
    "evaluate the block non critical for each item and all the sub-items"

    self nonCriticalFrom:1 to:nil do:[:eachChild|
        aOneArgBlock value:eachChild.
        eachChild nonCriticalRecursiveDo:aOneArgBlock
    ].
!

nonCriticalRecursiveReverseDo:aOneArgBlock
    "evaluate the block non critical for each item and all the sub-items;
     proccesing children in reverse direction"

    self nonCriticalFrom:1 to:nil reverseDo:[:eachChild|
        eachChild nonCriticalRecursiveReverseDo:aOneArgBlock.
        aOneArgBlock value:eachChild.
    ].
!

nonCriticalRecursiveSort:aSortBlock
    "evaluate a block noncritical for each child."

    |unsorted sorted|

    unsorted := children.

    unsorted size ~~ 0 ifTrue:[
        sorted := unsorted sort:aSortBlock.
        sorted do:[:el| el nonCriticalRecursiveSort:aSortBlock ].
        children := sorted.
    ].
! !

!AbstractHierarchicalItem methodsFor:'private-hierarchy'!

recursiveSetCollapsed
    "collapse all children and sub-children without notifications"

    self criticalDo:[
        self recursiveSetCollapsedHelper
    ]
!

recursiveSetCollapsedHelper
    "private helper.
     collapse all children and sub-children without notifications.
     Helper only - does not lock"

    self setExpanded:false.

    "/ do not call #size: children will be autoloaded !!!!
    children size ~~ 0 ifTrue:[
        self nonCriticalFrom:1 to:nil do:[:eachChild| 
            eachChild canRecursiveCollapse ifTrue:[
                eachChild recursiveSetCollapsedHelper
            ]
        ].
    ]
!

recursiveSetExpandedAndAddToList:aList
    "expand all children and sub-children without notifications;
     add children to list"

    self criticalDo:[
        self recursiveSetExpandedAndAddToListHelper:aList
    ].
!

recursiveSetExpandedAndAddToListHelper:aList
    "private helper.
     expand all children and sub-children without notifications; adds children to aList
     Helper only - does not lock"

    self setExpanded:true.

    self nonCriticalFrom:1 to:nil do:[:eachChild|
        aList add:eachChild.

        eachChild canRecursiveExpand ifTrue:[
            eachChild recursiveSetExpandedAndAddToListHelper:aList.
        ].
    ].
! !

!AbstractHierarchicalItem methodsFor:'private-to be redefined'!

fetchChildren
    ^ nil
!

heightOn:aGC
    "return the height of the receiver, if it is to be displayed on aGC"

    self subclassResponsibility.

    "/ could in theory compute it for every draw operation;
    "/ in practice, this is not a good idea, as it could make drawing very slow
    "/ (unless that info can be easily computed)

    "/ so we force programmers to think about that issue and redefine this method
    "/ as required. If compuation is really cheap, it can be redefined as:
    "/ ^ self heightOf:(self label) on:aGC
!

isExpanded
    "returns true if the item is expanded"

    self subclassResponsibility
!

makeWidthAndHeightUnknown
    "invalidate any cached with/height information"

    "see comments in widthOn/heightOn"
    self subclassResponsibility
!

setExpanded:aBoolean
    "set expanded flag without any computation or notification.
     It is left to the subclasses responsibility, where this expanded state is stored;
     could be in the model (as a list of expanded items), in the item itself (as boolean flag),
     or somewhere else.
     For huge trees, it may make sense to not store the expanded flag in a slot 
     (in order to save space). See CompactHierarchicalItem as a clever example of how it can be
     stored without ANY additional space requirements."

    self subclassResponsibility
!

widthOn:aGC
    "return the width of the receiver, if it is to be displayed on aGC"

    self subclassResponsibility.

    "/ could in theory compute it for every draw operation;
    "/ in practice, this is not a good idea, as it could make drawing very slow
    "/ (unless that info can be easily computed)

    "/ so we force programmers to think about that issue and redefine this method
    "/ as required. If compuation is really cheap, it can be redefined as:
    "/ ^ self widthOf:(self label) on:aGC
! !

!AbstractHierarchicalItem methodsFor:'protocol-accessing'!

children
    "returns a list of children. When first asked, the list is fetched, if it was
     built lazily.
     *** to optimize: either redefine this or fetchChildren by subClass"

    children isNil ifTrue:[
        children := self fetchChildren
    ].
    ^ children
!

icon
    "returns the icon or nil;
     *** to optimize:redefine by subClass"

    |model|

    (model := self model) notNil ifTrue:[
        ^ model iconFor:self
    ].
    ^ nil
!

label
    "returns the label displayed on aGC;
     *** to optimize:redefine by subClass"

    |model|

    (model := self model) notNil ifTrue:[
        ^ model labelFor:self
    ].
    ^ nil
!

middleButtonMenu
    "returns the items middleButtonMenu or nil if no menu is defined.
     If nil is returned, the view is asked for a menu."

    <resource: #programMenu>

    |model|

    (model := self model) notNil ifTrue:[
        ^ model middleButtonMenuFor:self
    ].
    ^ nil
!

recursiveSortChildren:aSortBlock
    |children|

    (children := self children) notEmptyOrNil ifTrue:[
        self criticalDo:[
            children sort:aSortBlock.
            children do:[:aChild| aChild recursiveSortChildren:aSortBlock ]
        ]
    ].
!

sortChildren:aSortBlock
    "sort the children inplace using the 2-arg block sortBlock for comparison"

    <resource: #obsolete>
    self obsoleteMethodWarning:'use #sort:'.
    self sort:aSortBlock.
! !

!AbstractHierarchicalItem methodsFor:'protocol-displaying'!

displayIcon:anIcon atX:x y:y on:aGC
    "called to draw the icon - can be redefined to manipulate the icon"

    anIcon displayOn:aGC x:x y:y.
!

displayOn:aGC x:x y:y h:h
    <resource: #obsolete>
    "draw the receiver in the graphicsContext, aGC"

    "/ obsolete - left here for backward compatibility
    self displayOn:aGC x:x y:y h:h isHighlightedAsSelected:false
!

displayOn:aGC x:x y:y h:h isHighlightedAsSelected:isHighlightedAsSelected
    "draw the receiver in the graphicsContext, aGC"

    |label
     x0 "{ Class:SmallInteger }"|

    label := self label.
    label isNil ifTrue:[^ self].

    label isNonByteCollection ifFalse:[
        ^ self displayLabel:label h:(self heightOn:aGC) on:aGC x:x y:y h:h isHighlightedAsSelected:isHighlightedAsSelected
    ].

    x0 := x.
    label do:[:el|
        el notNil ifTrue:[
            self displayLabel:el h:(self heightOf:el on:aGC) on:aGC x:x0 y:y h:h isHighlightedAsSelected:isHighlightedAsSelected.
            x0 := x0 + 5 + (el widthOn:aGC).
        ].
    ]
! !

!AbstractHierarchicalItem methodsFor:'protocol-event processing'!

processButtonPress:button visibleX:visX visibleY: visY on: view
    "A mouse button was pressed on myself. The visX/visY coordinates
     are relative to the viewOrigin.

     If this method returns TRUE, the other method
     #processButtonPress:x:y:on: IS NOT CALLED !!!!!!
    "

    ^false

    "Created: / 18-04-2013 / 09:56:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 18-04-2013 / 11:04:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

processButtonPress:button x:x y:y
    "a mouse button was pressed in my label.
     Return true, if the event is eaten (ignored by the gc).
     By default, false is returned (should be handled by the gc)."

    ^ false
!

processButtonPress:button x:x y:y on:aGC
    "a mouse button was pressed in my label.
     Return true, if the event is eaten (ignored by the gc).
     By default, false is returned (should be handled by the gc)."

    ^ self processButtonPress:button x:x y:y
!

processButtonPressOnIcon:button on:aGC
    "a mouse button was pressed in my icon.
     Return true, if the event is eaten (ignored by the gc).
     By default, false is returned (should be handled by the gc)."

    ^ false
! !

!AbstractHierarchicalItem methodsFor:'protocol-monitoring'!

monitoringCycle
    "called every 'n' seconds by the model, if the monitoring
     cycle is enabled. The item can perform some checks, ..
     **** can be redefined by subclass to perform some actions
    "
! !

!AbstractHierarchicalItem methodsFor:'protocol-queries'!

canCollapse
    "called before collapsing the item; can be redefined
     by subclass to omit the collapse operation"

    ^ self isExpanded
!

canExpand
    "called before expanding the item; can be redefined
     by subclass to omit the expand operation"

    ^ self hasChildren
!

canRecursiveCollapse
    "called before collapsing the item; can be redefined
     by subclass to omit the collapse operation "

    ^ self canCollapse
!

canRecursiveExpand
    "called before expanding the item; can be redefined
     by subclass to omit the collapse operation"

    ^ self canExpand
!

drawHorizontalLineUpToText
    "draw the horizizontal line for the selected item up to the text
     or on default to the start of the the vertical line; only used by
     the hierarchical view
    "
    ^ false
!

hasChildren
    "checks whether the item has children; 
     the list needs not to be loaded yet( example. FileDirectory ).
     *** to optimize: redefine in subClass"

    ^ self children size ~~ 0
!

hasIndicator
    "on default the indicator is drawn if the item has children"

    ^ self hasChildren
!

isSelectable
    "returns true if the item is selectable. Can be redefined in subclasses"

    ^ true
!

string
    "access the printable string used for stepping through a list
     searching for an entry starting with a character.
     *** to optimize:redefine by subClass"

    |label|

    (label := self label) notNil ifTrue:[
        label isString      ifTrue:[ ^ label string ].
        label isImageOrForm ifTrue:[ ^ nil ].

        label isSequenceable ifFalse:[
            ^ label perform:#string ifNotUnderstood:nil
        ].

        label do:[:el||s|
            (el notNil and:[el isImageOrForm not]) ifTrue:[
                s := el perform:#string ifNotUnderstood:nil.
                s notNil ifTrue:[^ s].
            ]
        ]
    ].
    ^ nil
! !

!AbstractHierarchicalItem methodsFor:'queries'!

isChildOf:anItem
    "returns true if the item is a child of anItem"

    |item|

    item := self.

    [anItem ~~ item] whileTrue:[
        ((item := item parent) notNil and:[item isHierarchicalItem]) ifFalse:[
            ^ false
        ]
    ].
    ^ true
!

isCollapsed
    "returns true if the item is collapsed"

    ^ self isExpanded not
!

isDirectoryItem
    ^ false

    "Created: / 23-06-2006 / 12:47:05 / fm"
    "Modified: / 23-02-2007 / 12:04:23 / User"
!

isHierarchicalItem
    "used to decide if the parent is a hierarchical item or the model"

    ^ true
!

isRealChildOf:anItem
    "returns true if the item is a child of anItem"

    |item|
    item := self parent.

    [item notNil] whileTrue:[
        item == anItem ifTrue:[^ true].
        item := item parent.
    ].
    ^ false
!

isRootItem
    "returns true if the item is the root item"

    ^ parent isHierarchicalItem not
!

size
    "return the number of children"

    ^ self children size
! !

!AbstractHierarchicalItem methodsFor:'searching'!

detect:aOneArgBlock
    "find the first child (not recursive), for which evaluation of the block returns
     true; if none does so, report an error"

    ^ self detect:aOneArgBlock ifNone:[self errorNotFound]

    "Modified (comment): / 25-11-2016 / 08:40:16 / cg"
!

detect:aOneArgBlock ifNone:exceptionValue
    "find the first child (not recursive), for which evaluation of the block returns
     true; if none does so, return the value of anExceptionValue"

    self do:[:el| 
        (aOneArgBlock value:el) ifTrue:[^ el] 
    ].
    ^ exceptionValue value

    "Modified (comment): / 25-11-2016 / 08:40:18 / cg"
!

detectLast:aOneArgBlock
    "find the last child (not recursive), for which evaluation of the block returns
     true; if none does so, an exception is raised"

    ^ self detectLast:aOneArgBlock ifNone:[self errorNotFound]

    "Modified (comment): / 25-11-2016 / 08:40:21 / cg"
!

detectLast:aOneArgBlock ifNone:anExceptionValue
    "find the last child (not recursive), for which evaluation of the block returns
     true; if none does so, return the value of anExceptionValue"

    self reverseDo:[:el| (aOneArgBlock value:el) ifTrue:[^ el] ].
    ^ anExceptionValue value

    "Modified (comment): / 25-11-2016 / 08:40:23 / cg"
!

findFirst:aOneArgBlock
    "find the first child (not recursive), for which evaluation of the argument, aOneArgBlock
     returns true; return its index or 0 if none detected."


    self keysAndValuesDo:[:i :el| (aOneArgBlock value:el) ifTrue:[^ i] ].
    ^ 0

    "Modified (comment): / 25-11-2016 / 08:40:25 / cg"
!

findLast:aOneArgBlock
    "find the last child (not recursive), for which evaluation of the argument, aOneArgBlock
     returns true; return its index or 0 if none detected."

    self keysAndValuesReverseDo:[:i :el| (aOneArgBlock value:el) ifTrue:[^ i] ].
    ^ 0

    "Modified (format): / 25-11-2016 / 08:40:33 / cg"
!

identityIndexOf:aChild
    "return the index of aChild or 0 if not found. Compare using =="

    ^ self identityIndexOf:aChild startingAt:1
!

identityIndexOf:aChild startingAt:startIndex
    "return the index of aChild, starting search at startIndex.
     Compare using ==; return 0 if not found"

    |index|

    index := startIndex.

    self from:startIndex do:[:el|
        el == aChild ifTrue:[^ index ].
        index := index + 1.
    ].
    ^ 0
!

recursiveDetect:aOneArgBlock
    "recursive find the first child, for which evaluation 
     of the block returns true; if none, nil is returned.
     Warning: this only searches in already visible child elements
     i.e. any collapsed items are not searched."

    self recursiveDo:[:aChild|
        (aOneArgBlock value:aChild) ifTrue:[^ aChild]
    ].
    ^ nil
!

recursiveDetectLast:aBlock
    "recursive find the last child, for which evaluation of the block returns true; 
     if none does so, nil is returned.
     Warning: this only searches in already visible child elements
     i.e. any collapsed items are not searched."

    self recursiveReverseDo:[:aChild|
        (aBlock value:aChild) ifTrue:[^ aChild].
    ].
    ^ nil

    "Modified (comment): / 25-11-2016 / 08:41:42 / cg"
!

withAllDetect:aOneArgBlock
    "recursive find the first item including self, 
     for which evaluation of the block returns true; if none nil is returned.
     Warning: this only searches in already visible child elements
     i.e. any collapsed items are not searched."

    (aOneArgBlock value:self) ifTrue:[^ self].

    ^ self recursiveDetect:aOneArgBlock

    "Modified (comment): / 25-11-2016 / 08:41:53 / cg"
! !

!AbstractHierarchicalItem methodsFor:'sorting & reordering'!

recursiveSort:aSortBlock
    "recursive sort the children inplace using the 2-arg block sortBlock for comparison"

    self criticalDo:[
        children notEmptyOrNil ifTrue:[
            self nonCriticalRecursiveSort:aSortBlock.
            self childrenOrderChanged.
        ]
    ].
!

sort:aSortBlock
    "sort the children inplace using the 2-arg block sortBlock for comparison"

    children notEmptyOrNil ifTrue: [
        self criticalDo:[
            "/ check again (asynchronous update was possible before)
            children notEmptyOrNil ifTrue: [
                children := children sort:aSortBlock.
                self childrenOrderChanged.
            ]
        ].
    ]
! !

!AbstractHierarchicalItem class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

