"
 COPYRIGHT (c) 1997 by eXept Software AG / Claus Gittinger
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

Model subclass:#SelectionInTree
	instanceVariableNames:'root list selection showRoot contentsAction labelAction
		childrenAction iconAction indicatorList indicatorTask accessLock'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-Models'
!

!SelectionInTree class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1997 by eXept Software AG / Claus Gittinger
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
    list and selection holder for hierarchical list structures. Used
    to buildup file-trees, class trees etc.

    Especially suited for use with SelectionInTreeView.

    Notice: this class replaces SelectionInHierarchy, which provides
            similar (but less sphisticated) functionality.

    [See also:]
        TreeItem
        SelectionInTreeView

    [Author:]
        W. Olberding
        Claus Atzkern
"
! !

!SelectionInTree class methodsFor:'instance creation'!

new
    ^ self basicNew initialize
! !

!SelectionInTree class methodsFor:'defaults'!

defaultItemClass
    "returns the default item class or nil (the default)
    "
    ^ nil



! !

!SelectionInTree methodsFor:'accessing'!

list
    "get the list of currently shown objects
    "
    ^ list
!

root
    "get the root node
    "
    ^ root
!

root:aRoot
    "set a new root
    "
    |tree|

    root notNil ifTrue: [
        tree := root tree.
        root tree:nil.
    ] ifFalse:[
        tree := self
    ].
    self stopRunningTasks.

    (root := aRoot) notNil ifTrue:[
        root tree:tree.
        root parent:nil.
    ].
    self recomputeList
!

value
    ^ list
! !

!SelectionInTree methodsFor:'accessing hierarchy new'!

doMakeVisible:something
    "make an item or list of items to become visible
    "
    |anchor parent|

    self each:something do:[:anItem|
        parent := anItem.
        anchor := nil.

        parent notNil ifTrue:[
            [(parent := parent parent) notNil] whileTrue:[
                parent hidden ifTrue:[
                    anchor notNil ifTrue:[ anchor expand ].
                    anchor := parent.
                ]
            ].
            anchor notNil ifTrue:[
                self expandItem:anchor do:[anchor expand]
            ]
        ].
    ]
! !

!SelectionInTree methodsFor:'accessing-behavior'!

childrenAction
    "get children action block
    "
    ^childrenAction
!

childrenAction:aBlock
    "set children action block
    "
    childrenAction := aBlock.
!

contentsAction
    "get contents action block
    "
    ^contentsAction
!

contentsAction:aBlock
    "set contents action block
    "
    contentsAction := aBlock.
!

iconAction
    "get icon action block
    "
    ^iconAction
!

iconAction:aBlock
    "set icon action block
    "
    iconAction := aBlock.
!

labelAction
    "get label action block
    "
    ^labelAction
!

labelAction:aBlock
    "set label action block
    "
    labelAction := aBlock.
!

showRoot
    "list with or without root
    "
    ^ showRoot
!

showRoot:aState
    "list with or without root
    "
    aState ~~ showRoot ifTrue:[
        showRoot := aState.

        root notNil ifTrue:[
            aState ifTrue:[
                list addFirst:root.
                self changed:#insertCollection: with:(Array with:1 with:1 with:nil).
            ] ifFalse:[
                list removeFirst.
                self changed:#removeFrom: with:(Array with:1 with:1 with:nil).
            ].
        ].
    ].
! !

!SelectionInTree methodsFor:'accessing-hierarchy'!

collapse:something 
    "collapse a node or collection of nodes
    "
    |listChanged|

    listChanged := false.

    self each:something do:[:aNode|
        aNode isCollapsable ifTrue:[
            aNode collapse.
            listChanged := true
        ]
    ].
    listChanged ifTrue:[
        self listFromRoot.
        self changed:#list.
    ]

!

expand
    "expand the root
    "
    self expand:root
!

expand:something 
    "expand a node or collection of nodes
    "
    |listChanged|

    listChanged := false.

    self each:something do:[:aNode|
        aNode isExpandable ifTrue:[
            aNode expand.
            listChanged := true
        ]
    ].
    listChanged ifTrue:[
        self listFromRoot.
        self changed:#list.
    ]
! !

!SelectionInTree methodsFor:'accessing-hierarchy new'!

doCollapse:something
    "collapse all children under an item or a sequence of items;
     if the list changed, notifications are raised
    "
    self each:something do:[:anItem|
        self collapseItem:anItem do:[ anItem collapse ]
    ]
!

doCollapseAll:something
    "collapse all children and subChildren under an item or sequence of items;
     if the list changed, notifications are raised
    "
    self each:something do:[:anItem|
        self collapseItem:anItem do:[ anItem collapseAll ]
    ]
!

doExpand:something
    "expand all children under an item or collection of items;
     if the list changed, notifications are raised
    "
    self each:something do:[:anItem|
        self expandItem:anItem do:[anItem expand]
    ]
!

doExpandAll:something
    "expand all children and subChildren under an item or sequence of items;
     if the list changed, notifications are raised
    "
    self each:something do:[:anItem|
        self expandItem:anItem do:[anItem expandAll]
    ]
! !

!SelectionInTree methodsFor:'adding & removing'!

add:something after:aChild
    "add a node or collection of nodes to parent after a child
    "
    "add a node or collection of nodes to after a child
    "
    |p|

    (aChild notNil and:[(p := aChild parent) notNil]) ifTrue:[
        self add:something afterIndex:(p indexOfChild:aChild) below:p
    ]

!

add:something afterIndex:anIndex below:aParent
    "add a node or collection of nodes to parent after an index
    "
    self add:something beforeIndex:(anIndex + 1) below:aParent
!

add:something before:aChild
    "add a node or collection of nodes to before a child
    "
    |p|

    (aChild notNil and:[(p := aChild parent) notNil]) ifTrue:[
        self add:something beforeIndex:(p indexOfChild:aChild) below:p
    ]
!

add:something beforeIndex:anIndex below:aParent
    "add a node or collection of nodes to aParents children
     before anIndex (which is a child-index)
    "
    |children start index size pList|

    (    aParent isNil
     or:[something isNil
     or:[(something isCollection and:[something isEmpty])]]
    ) ifTrue:[
        ^ self
    ].

    (start := self indexOf:aParent) == 0 ifTrue:[
        "/
        "/ parent not visible; list not changed
        "/
        aParent == root ifFalse:[
            aParent add:something beforeIndex:anIndex.
          ^ self
        ]
    ] ifFalse:[
        aParent shown ifFalse:[
            aParent add:something beforeIndex:anIndex.
            self changed:#at: with:start.
            ^ self
        ]
    ].
    children := aParent children.

    (children isEmpty or:[anIndex <= 1]) ifTrue:[
        index := 1.
    ] ifFalse:[
        size  := children size.

        anIndex > size ifTrue:[
            index := size + 1.
            start := aParent numberOfAllVisibleChildren + start.
        ] ifFalse:[
            index := anIndex.
            start := (self indexOf:(children at:index)) - 1.
        ]
    ].
    aParent add:something beforeIndex:index.

    (start := start + 1) == 0 ifTrue:[
        "/
        "/ not visible
        "/
        ^ self
    ].
    pList := OrderedCollection new:2048.

    self each:something do:[:aNode|
        pList add:aNode.
        aNode addVisibleChildrenTo:pList
    ].
    pList isEmpty ifTrue:[
        ^ self
    ].
    list addAll:pList beforeIndex:start.

    self changed:#insertCollection:
            with:(Array with:start with:pList size with:aParent).

!

add:something below:aParent
    "add a node or collection of nodes to parent
    "
    aParent notNil ifTrue:[
        self add:something beforeIndex:(aParent numberOfChildren + 1) below:aParent
    ]
!

remove:something
    "remove a node or collection of nodes
    "
    |node index loNums loItem start size parent stop|

    something isNil ifTrue:[
        ^ something
    ].
    loNums := SortedCollection new.

    self each:something do:[:el|
        node := el isNumber ifTrue:[list at:el ifAbsent:nil]
                           ifFalse:[el].

        node notNil ifTrue:[
            self stopIndicatorValidationFor:node.

            node parent isNil ifTrue:[
                "/ remove all including root
                node == root ifTrue:[ self root:nil ].
              ^ something
            ].
            index := self indexOf:node.

            index == 0 ifTrue:[
                "/ not visible
                node parent removeChild:node
            ] ifFalse:[
                loNums add:index
            ].
        ]
    ].

    loNums isEmpty ifTrue:[
        "/ nothing visible changed
        ^ something
    ].
    loItem := OrderedCollection new.
    loNums do:[:i| loItem add:(list at:i)].

    loItem do:[:aNode|
        start := self indexOf:aNode.

        start ~~ 0 ifTrue:[
            parent := aNode parent.
            size   := 1 + aNode numberOfAllVisibleChildren.
            stop   := start + size - 1.
            parent remove:aNode.
            list removeFromIndex:start toIndex:stop.

            self changed:#removeFrom:
                    with:(Array with:start with:stop with:parent).
        ]
    ].
    ^ something
!

removeAllOtherThanRoot
    "remove all other than the root
    "
    |listChanged|

    root notNil ifTrue:[
        listChanged := root isCollapsable.
        root children:(OrderedCollection new).

        listChanged ifTrue:[
            self listFromRoot.
            self changed:#list
        ]
    ]
!

removeIndex:something
    "remove a node at index or collection of indexed nodes
    "
    self remove:something
!

removeSelection
    "remove selected nodes
    "
    |sel|

    sel := self selectionIndex.
    self selectionIndex:nil.
    self remove:sel.
!

replaceNode:aNode with:aNewNode
    "replace a node by a new node; if the new node is nil, the node and its
     children are removed. Otherwise the children are taken over to the new
     node.
    "
    |parent index children|

    (aNode isNil or:[aNode == aNewNode]) ifTrue:[
        ^ self
    ].

    aNewNode isNil ifTrue:[
        ^ self remove:aNode
    ].
    self stopIndicatorValidationFor:aNode.

    aNewNode children:(aNode children).    
    aNode    children:nil.

    aNode == root ifTrue:[
        aNewNode tree:(aNode tree).
        aNewNode parent:nil.
        root := aNewNode.
    ] ifFalse:[
        parent := aNode parent.
        aNewNode tree:nil.
        aNewNode parent:parent.
        children := parent children.
        index := children identityIndexOf:aNode.
        children at:index put:aNewNode.
    ].

    aNode tree:nil.        
    aNode parent:nil.        

    (index := self indexOf:aNode) ~~ 0 ifTrue:[
        list at:index put:aNewNode.
        self changed:#at: with:index
    ].
! !

!SelectionInTree methodsFor:'change & update'!

invalidate
    "called; something changed what requires a redraw but no recomputation.
     for example a name
    "
    self dependents do:[:aDependent|
        aDependent isView ifTrue:[ aDependent invalidate ]
    ].


!

update:something with:aParameter from:aModel

    self dependents do:[:aDependent|
        aDependent update:something with:aParameter from:aModel
    ]
! !

!SelectionInTree methodsFor:'enumerating'!

each:something do:aBlock
    "evaluate a block for something or in case of a collection for each
     element in the collection
    "
    something notNil ifTrue:[
        something isCollection ifTrue:[something do:[:el|aBlock value:el]]
                              ifFalse:[aBlock value:something]
    ]

! !

!SelectionInTree methodsFor:'initialization'!

initialize

    showRoot      := true.
    indicatorList := OrderedCollection new.
    accessLock    := Semaphore forMutualExclusion.
    list          := List new.
! !

!SelectionInTree methodsFor:'private'!

recomputeList
    "Travers the tree and build a new list."

    self listFromRoot.
    self changed:#list.
! !

!SelectionInTree methodsFor:'private-hierarchy'!

collapseItem:anItem do:collapseBlock
    "collapse all children under an item; raise a notification if
     the list changed
    "
    |start stop size|

    anItem isCollapsable ifFalse:[
        ^ self
    ].

    (start := self indexOf:anItem) == 0 ifTrue:[
        "/
        "/ item not visible
        "/
        collapseBlock value.
    ] ifFalse:[
        size := anItem numberOfAllVisibleChildren.
        collapseBlock value.

        size == 0 ifTrue:[
            "/
            "/ no children before; list not changed 
            "/
            self changed:#at: with:start
        ] ifFalse:[        
            stop  := start + size.
            start := start + 1.
            list removeFromIndex:start toIndex:stop.
            self changed:#removeFrom: with:(Array with:start with:stop with:anItem).
        ]
    ]
!

expandItem:anItem do:expandBlock
    "expand all children under an item; raise a notification if
     the list changed
    "
    |start size pList|

    anItem isExpandable ifFalse:[
        ^ self
    ].
    expandBlock value.

    (start := self indexOf:anItem) ~~ 0 ifTrue:[
        anItem addVisibleChildrenTo:(pList := OrderedCollection new:2048).

        (size := pList size) ~~ 0 ifTrue:[
            start := 1 + start.
            list addAll:pList beforeIndex:start.

            self changed:#insertCollection:
                    with:(Array with:start with:size with:anItem).
        ] ifFalse:[
            self changed:#at: with:start
        ]
    ]
!

listFromRoot
    "Traverse the tree and build a new list;
     no change notification is raised
    "
    list clearContents.

    root notNil ifTrue:[
        showRoot ifTrue:[ list add:root ].
        root addVisibleChildrenTo:list
    ]

! !

!SelectionInTree methodsFor:'queries'!

indexOf:anItem
    "returns the index of an item or 0
    "
    ^ anItem notNil ifTrue:[list identityIndexOf:anItem]
                   ifFalse:[0]
! !

!SelectionInTree methodsFor:'searching'!

detectFirstItem:aOneArgBlock
    "detect an item the evaluation of the block returns true. 
     The argument to the block is the item.
     This recursively enumerates the tree for the first item for which
     the block returns true.
    "
    root notNil ifTrue:[
        ^ root detectFirstChild:aOneArgBlock
    ].
    ^ nil


!

detectItem:aOneArgBlock
    "detect an item the evaluation of the block returns true. 
     The argument to the block is the item.
     This searches top-level items only.
    "
    root notNil ifTrue:[
        ^ root detectChild:aOneArgBlock
    ].
    ^ nil


!

detectItem:aTwoArgBlock arguments:aListOfArgs
    "detect an item the evaluation of the block returns true. 
     The first argument to the block is the item, the second argument
     the value derived from the argument list at level.
     This recursively walks down the tree up to aListOfArgs size levels;
     i.e. if you pass (1 to:10) as aListOfArgs, the block will get the sub-level
     as second argument and stop the search after 10 levels.
    "

    root notNil ifTrue:[
        ^ root detectChild:aTwoArgBlock arguments:aListOfArgs
    ].
    ^ nil


! !

!SelectionInTree methodsFor:'selection'!

selectNode:aNode
    |index|

    (index := self indexOf:aNode) ~~ 0 ifTrue:[
        self selectionIndex:index
    ]
!

selectNodes:aCollectionOfNodes
    | indices|

    indices := aCollectionOfNodes 
                    collect:[:aNode | self indexOf:aNode]
                    thenSelect:[:idx | idx ~~ 0].
    indices sort.
    self selectionIndex:indices

    "Created: / 6.3.1999 / 22:37:59 / cg"
!

selectedNode
    "returns selected node or nil
    "
    |nodes|
    (nodes := self selectedNodes) notNil ifTrue: [
        ^nodes first
    ].
    ^nil


!

selectedNodes
    "returns list of selected nodes or nil
    "
    |node coll|

    selection isNil ifTrue:[
        ^ nil
    ].

    selection isCollection ifFalse:[
        node := list at:selection ifAbsent:nil.
      ^ node notNil ifTrue:[Array with:node] ifFalse:[nil]
    ].

    selection isEmpty ifTrue:[
        ^ nil
    ].

    coll := OrderedCollection new:(selection size).

    selection do:[:idx|
        (node := list at:idx ifAbsent:nil) notNil ifTrue:[
            coll add:node
        ]
    ].
    ^ coll asNilIfEmpty
!

selectedNodesDo:aOneArgBlock
    "evaluate the block on eack node selected
    "
    |node|

    selection isNil ifTrue:[
        ^ nil
    ].

    selection isCollection ifFalse:[
        node := list at:selection ifAbsent:nil.
        node notNil ifTrue:[
            aOneArgBlock value:node
        ].
        ^ self
    ].

    selection do:[:i|
        node := list at:i ifAbsent:nil.

        node notNil ifTrue:[
            aOneArgBlock value:node
        ].
    ].
!

selection
    "get the selection or nil
    "
    ^ self selectionIndex
!

selection:indexesOrNil
    "set the selection"

    self selectionIndex:indexesOrNil
!

selectionIndex
    "get the selection or nil
    "
    ^ selection
!

selectionIndex:indexesOrNil
    "set the selection
    "
    |oldSel|

    oldSel := selection.
    self setSelectionIndex:indexesOrNil.

    oldSel = selection ifFalse:[
        self changed:#selectionIndex.

        self selectedNodesDo:[:aNode|
            aNode changedSelected
        ]
    ]
!

setSelection:indexesOrNil
    "set the selection without raising a notification
    "
    self setSelectionIndex:indexesOrNil
!

setSelectionIndex:indexesOrNil
    "set the selection without raising a notification
    "
    |indexes|

    indexes := indexesOrNil.

    indexes size == 0 ifTrue:[
        (indexes isCollection or:[indexes == 0]) ifTrue:[
            indexes := nil
        ]
    ].
    selection := indexes

! !

!SelectionInTree methodsFor:'update indication task'!

startIndicatorValidationFor:aNode
    "add a node to list of updating indications
    "
    |index|

    accessLock critical:[
        |prio|

        index := indicatorList identityIndexOf:aNode.

        index ~~ 0 ifTrue:[
            indicatorList removeIndex:index.    "/ reorganize list to be faster
        ].
        indicatorList addLast: "addFirst:" aNode.

        indicatorTask isNil ifTrue:[
            prio := Processor activePriority.
            indicatorTask := [
                [ self taskCycle ] whileTrue:[ Processor yield ]
            ] forkAt:(prio - 1).
            indicatorTask priorityRange:(prio-1 to:prio).
        ]
    ].

    "Modified: / 26.9.1998 / 15:20:44 / cg"
!

stopIndicatorValidationFor:aNodeOrList
    "remove a node or list of nodes from list of updating indications
    "
    accessLock critical:[
        aNodeOrList isCollection ifTrue:[
            aNodeOrList do:[:aNode|
                indicatorList removeIdentical:aNode ifAbsent:nil
            ]
        ] ifFalse:[
            indicatorList removeIdentical:aNodeOrList ifAbsent:nil
        ]
    ]


!

stopRunningTasks
    "stop task
    "
    accessLock critical:[ indicatorList removeAll ]

!

taskCycle
    "run one cycle fetching indicator state.
     This is done in the background to avoid long startup
     delays, in case the indicator information takes long to
     gather (i.e. when reading directories)"

    |node flag|

    accessLock critical:[
        indicatorList isEmpty ifTrue:[          "/ queue is empty; terminate task
            indicatorTask := nil.
            ^ false
        ].
        node := indicatorList removeFirst.      "/ run task on first node
        node hasValidIndicator ifTrue:[         "/ up to date
            ^ true
        ].
        node setShowIndicator:(node defaultShowSeparator).      "/ disable registry
    ].

    flag := DirectoryContents directoryNamed:(node fileName) detect:(node matchAction).
    node showIndicator:flag.
    ^ true

    "Modified: / 26.9.1998 / 15:11:16 / cg"
! !

!SelectionInTree class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

