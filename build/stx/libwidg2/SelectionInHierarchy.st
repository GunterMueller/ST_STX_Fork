"
 COPYRIGHT (c) 1994 by AEG Industry Automation
 COPYRIGHT (c) 1994 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libwidg2' }"

Model subclass:#SelectionInHierarchy
	instanceVariableNames:'root list selection'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-Models'
!

!SelectionInHierarchy class methodsFor:'documentation'!

copyright 
"
 COPYRIGHT (c) 1994 by AEG Industry Automation
 COPYRIGHT (c) 1994 by Claus Gittinger
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
    model for a selection in a hierarchical list.
    See examples in SelectionInHierarchyView.

    Notice: this class was provided for free by a customer
            It is more or less obsoleted by SelectionInTree, which provides
            similar (but more sphisticated) functionality.
            SelectionInHierarchy remains in the system for backward compatibility.

    [Author:]
        W. Olberding AEG Factory Automation

    [See also:]
        HierarchyNode
        SelectionInHierarchyView
        SelectionInTree SelectionInTreeView TreeItem
"
! !

!SelectionInHierarchy methodsFor:'accessing'!

getHierarchyNodeForContents: something
     "return the hierarchyNode whose contents is something"

     root notNil ifTrue:[
         ^ root allChildren detect:[:each| (each contents = something)] ifNone:nil.
     ].
     ^ nil
!

list
    "Answer a collection of nodes representing the
    list of currently viewed objects."

    ^list

    "Modified: 10.10.1994 / 16:13:36 / W.Olberding"
    "Modified: 15.4.1997 / 16:29:26 / cg"
!

root: aHierarchyNode
        "Set the root object - this means initialization."

        root := aHierarchyNode.
        selection := nil.
        self setNewList.
!

selectedPath 
    "Answer the pathName to the currently selected node."

    |node|

    (node := self selectedNode) isNil ifFalse:[
        ^ node pathName
    ].
    ^ ''
!

setHideToChildren: aBoolean startingAt: aHierarchyNode

     "set the hide-Falg to aBoolean starting at aHierarchyNode down"

     root notNil ifTrue:[
         root allChildren do:[:each| each hide:aBoolean].
         self setNewList.
     ]
!

showCompleteHierarchyStartingAtNode: aHierarchyNode
	"Set the hide-Flag to false for the hierarchy starting at aHierarchyNode"

	 | |
	aHierarchyNode isNil ifTrue: [^self].
	aHierarchyNode hideToFalseForPath.
	self setNewList.

	"Modified: 10.10.94 / 16:13:36 / W.Olberding"
! !

!SelectionInHierarchy methodsFor:'accessing-sequencable'!

addChildAndSubChildren:aHierarchyNode below:existingHierarchyNode after:aChild
    "Add a new HierarchyNode to the tree."

     existingHierarchyNode addChildAndSubChildren:aHierarchyNode after:aChild. 
     self setNewList.
!

addChildAndSubChildren:aHierarchyNode below:existingHierarchyNode at:anIndex

     existingHierarchyNode addChildAndSubChildren:aHierarchyNode at:anIndex.
     self setNewList.
! !

!SelectionInHierarchy methodsFor:'adding & removing'!

add:aChild below:aParent
    "add a new HierarchyNode to the tree."

     aParent addChild:aChild. 
     self setNewList.
!

add: aChild  belowIndex:aParentIndex
    "Add a new HierarchyNode to the tree below the node
     which is found in the list at anIndex."

    |parent|

    parent := list at:aParentIndex ifAbsent:[ ^ nil ]. 
    self add:aChild below:parent
!

remove:aHierarchyNode
    "Remove aHierarchyNode and all its children. "

     aHierarchyNode removeYourself.   
     self setNewList.
    ^aHierarchyNode
!

removeBelow: existingHierarchyNode
    "Remove all children below an existingHierarchyNode ."

     existingHierarchyNode hasChildren ifTrue:[
        existingHierarchyNode removeAllChildren. 
        self setNewList
     ].
!

removeBelowIndex: anIndex
        "Remove all the children of aHierarchyNode 
        which is found in the list at anIndex."

       | existingHierarchyNode |
         existingHierarchyNode := list at: anIndex ifAbsent: [^nil]. 
        ^self removeBelow:existingHierarchyNode.

        "Modified: 10.10.94 / 16:13:37 / W.Olberding"
!

removeIndex: anIndex
	"Remove the HierarchyNode and all its children
	which is found in the list at anIndex."

       | existingHierarchyNode |
	 existingHierarchyNode := list at: anIndex ifAbsent: [^nil]. 
	^self remove: existingHierarchyNode.

	"Modified: 10.10.94 / 16:13:36 / W.Olberding"
! !

!SelectionInHierarchy methodsFor:'hierarchy manipulation'!

collapse 
    "If possible, collapse the tree  at the currently selected node.
     The tree structure can be restored again with #expand. "

    |node|

    (node := self selectedNode) notNil ifTrue:[
        node isCollapsable ifTrue:[
            node collapse.
            self setNewList
        ]
    ]
!

collapseAll 
    "If possible, collapse the tree at the currently selected node.
     A latter #expand will show the next hierarchy level"

    |node|

    (node := self selectedNode) notNil ifTrue:[
        node isCollapsable ifTrue:[
            node collapseAll.
            self setNewList
        ]
    ]
!

expand 
    "If possible, expand  the tree 
     at the currently selected node."

    |node|

    (node := self selectedNode) notNil ifTrue:[
        node isExpandable ifTrue:[
            node expand.
            self setNewList
        ]
    ]
!

expandAll 
    "If possible, expand  the tree compleately to all leaves
     at the currently selected node."

    |node|

    (node := self selectedNode) notNil ifTrue:[
        node expandAll.
        self setNewList
    ]
!

hideShow
   "If possible, expand or collaps the tree 
    at the currently selected node."

    |node|

    (node := self selectedNode) notNil ifTrue:[
        node isExpandable ifTrue:[
            node expand
        ] ifFalse:[
            node isCollapsable ifFalse:[ ^ self ].
            node collapse
        ].
        self setNewList
    ]
! !

!SelectionInHierarchy methodsFor:'private'!

setNewList
    "Travers the tree and build a new list."

    root notNil ifTrue:[
        list := root withAllShownChildren
    ] ifFalse:[
        list := #()
    ].
    self changed:#list.
! !

!SelectionInHierarchy methodsFor:'selection'!

doubleClickSelection: anIndex
    "Set the current selected object to be the element
    at anIndex of the selection list.
    Also expand or collapse the tree at that point."

    self selectionIndex:anIndex.  
    self hideShow.
!

selectedNode
    "returns current selected node or nil
    "
    (selection isNil or:[selection == 0]) ifFalse:[
        ^ list at:selection
    ].
    ^ nil
!

selection
    "get the selection or nil
    "
    ^ self selectionIndex
!

selection:anIndexOrNil
    "set the selection"

    self selectionIndex:anIndexOrNil
!

selectionIndex
    "get the selection or nil
    "
    ^ selection
!

selectionIndex:anIndexOrNil
    "set the selection
    "
    anIndexOrNil == selection ifFalse:[
        anIndexOrNil == 0 ifTrue:[
            selection isNil ifTrue:[^ self ].
            selection := nil
        ] ifFalse:[
            selection := anIndexOrNil
        ].
        self changed: #selection.
     ]
! !

!SelectionInHierarchy methodsFor:'testing & debugging'!

root
    "get the root node
    "
    ^ root
! !

!SelectionInHierarchy class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libwidg2/SelectionInHierarchy.st,v 1.14 2010-02-01 12:20:22 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libwidg2/SelectionInHierarchy.st,v 1.14 2010-02-01 12:20:22 cg Exp $'
! !
