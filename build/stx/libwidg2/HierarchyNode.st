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

"{ NameSpace: Smalltalk }"

Object subclass:#HierarchyNode
	instanceVariableNames:'name id parent children contents disabled hide level
		childCollectionClass'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support'
!

!HierarchyNode class methodsFor:'documentation'!

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
    class to build up tree like structures to represent
    file-trees, class tress etc.
    Especially suited for use with SelectionInHierarchy and
    SelectionInHierarchyView.
    See examples in SelectionInHierarchyView.

    Notice: this class (together with SelectionInHierarchy and
           SelectionInHierarchyView) has been obsoleted by
           corresponding SelectionInTree* classes.
           These provide similar (but more) functionality.

    [Author:]
        W. Olberding AEG Factory Automation

    [See also:]
        SelectionInHierarchy
        SelectionInHierarchyView
        SelectionInTree SelectionInTreeView TreeItem
"
! !

!HierarchyNode class methodsFor:'instance creation'!

new
    ^ self basicNew initialize
!

newAsTreeFromSmalltalkClass:aClass
    "create a tree of nodes with aClass and all its
    subclasses as contents."

    ^ self
        newAsTreeFromSmalltalkClass:aClass
        level:(aClass allSuperclasses size).

    "Modified: 15.4.1997 / 16:34:23 / cg"
!

newAsTreeFromSmalltalkClass:aClass level:level
    "create a tree of nodes with aClass and all its
     subclasses as contents. Set the initial level as given."

    |newInst clsName|

    aClass isNil ifTrue:[
        "/ nil subclasses requested
        clsName := 'nil'
    ] ifFalse:[
        "/ regular tree requested
        clsName := aClass name
    ].

    newInst := self new.
    newInst name:clsName.
    newInst contents:aClass.
    newInst level:level.
    newInst childCollectionClass:OrderedCollection.

    aClass isNil ifTrue:[
        ((Smalltalk allClasses select:[:cls | cls superclass isNil])
            asSortedCollection:[:a :b | a name < b name])
        do:[:aSubClass |
            newInst addChild:(self newAsTreeFromSmalltalkClass:aSubClass level:level+1).
        ]
    ] ifFalse:[
        (aClass subclasses asSortedCollection:[:a :b | a name < b name])
        do:[:aSubClass |
            newInst addChild:(self newAsTreeFromSmalltalkClass:aSubClass level:level+1).
        ]
    ].
    ^newInst

    "Created: 15.4.1997 / 16:33:52 / cg"
    "Modified: 3.7.1997 / 12:25:03 / cg"
!

newWithName:aString
    "create a new node with a name"

    |newInst|

    newInst := self new.
    newInst name: aString.
    ^newInst

    "Modified: 15.4.1997 / 16:32:06 / cg"
!

newWithName: aString andId: anId
    "create a new node with a name and id"

    |newInst|

    newInst := self new.
    newInst name: aString.
    newInst id:   anId.
    ^newInst

    "Modified: 15.4.1997 / 16:32:22 / cg"
! !

!HierarchyNode methodsFor:'accessing'!

childCollectionClass:aCollectionClass
    "set the class of the child-collection.
     Default is Set."

     childCollectionClass := aCollectionClass.
     children := aCollectionClass withAll:children.
!

children
    "Answer my immediate children."

    ^ children

	"Modified: 10.10.94 / 16:13:34 / W.Olberding"
!

children:aCollectionWithElementsOfMyKind 
    "set my children"

    aCollectionWithElementsOfMyKind do:[:child | 
         child parent: self.
         child level: level + 1.
    ].
    children := aCollectionWithElementsOfMyKind.

    "Modified: 10.10.1994 / 16:13:33 / W.Olberding"
    "Modified: 15.4.1997 / 16:48:38 / cg"
!

contents
    "Answer the contents of me (e.g. a set of items)"

    ^contents

	"Modified: 10.10.94 / 16:13:33 / W.Olberding"
!

contents: anObject 
    "Set the contents of me to any object (e.g. a set of items)"

    contents:= anObject

        "Modified: 10.10.94 / 16:13:33 / W.Olberding"
!

disabled
    "return disabled"

    ^ disabled

	"Modified: 10.10.94 / 16:13:33 / W.Olberding"
!

disabled: aBool 
    "set disabled"

    disabled := aBool.

	"Modified: 10.10.94 / 16:13:33 / W.Olberding"
!

hide: aBoolean

   "Set hide to aBoolean"

   hide:= aBoolean

	"Modified: 10.10.94 / 16:13:33 / W.Olberding"
!

hideToFalseForPath
    "set the hide-flag to false"

      hide:= false.
      parent isNil ifTrue: [^self].
      parent hideToFalseForPath

	"Modified: 10.10.94 / 16:13:33 / W.Olberding"
!

id
    "return id"

    ^ id

	"Modified: 10.10.94 / 16:13:33 / W.Olberding"
!

id:something
    "set id"

    id := something.

	"Modified: 10.10.94 / 16:13:33 / W.Olberding"
!

level
    "answer the level in hierarchy (0=root)"

    ^level

	"Modified: 10.10.94 / 16:13:33 / W.Olberding"
!

level: anInteger 
    "set the level in hierarchy (0=root)"

    level := anInteger.

	"Modified: 10.10.94 / 16:13:33 / W.Olberding"
!

name
    "return name"

    ^ name

	"Modified: 10.10.94 / 16:13:33 / W.Olberding"
!

name: aString 
    "set the name that identifys me within my parent's context."

    name :=   aString.

	"Modified: 10.10.94 / 16:13:33 / W.Olberding"
!

ordered:aBoolean
    "set/clear the children-are-ordered flag.
     If unordered (the default), children are kept in a set;
     if ordered, they are kept in an orderedCollection."

     aBoolean ifTrue:[
        children := children asOrderedCollection
     ] ifFalse:[
        children := children asSet
     ].
!

parent:something
    "set parent"

    parent := something.

	"Modified: 10.10.94 / 16:13:33 / W.Olberding"
!

pathName
    "return a full path name to me"

    |n|

    n := self delimiterString , name.
    parent isNil ifTrue: [^ n].
    ^ parent pathName , n.

    "Modified: 10.10.1994 / 16:13:33 / W.Olberding"
    "Modified: 15.4.1997 / 16:52:02 / cg"
! !

!HierarchyNode methodsFor:'constants'!

delimiter
	"Answer the delimiter character"

	^$/

	"Modified: 10.10.94 / 16:13:35 / W.Olberding"
!

delimiterString
	"Answer the delimiter character asString"

	^self delimiter asString

	"Modified: 10.10.94 / 16:13:35 / W.Olberding"
! !

!HierarchyNode methodsFor:'copying'!

copyWithParent:aParent
    |node|

    node := self copy.
    node parent:aParent.
    node level:((aParent level) + 1).
    node children:(children collect:[:aChild| aChild copyWithParent:self]).
  ^ node
! !

!HierarchyNode methodsFor:'hierarchy operations'!

addChild:anObjectOfMyKind 
    "add anObjectOfMyKind to my children"

    anObjectOfMyKind parent: self.
    anObjectOfMyKind level: level +1.
    self children add:anObjectOfMyKind.

    "Modified: 10.10.1994 / 16:13:34 / W.Olberding"
    "Modified: 15.4.1997 / 16:49:17 / cg"
!

addChildren: aCollectionWithElementsOfMyKind 
    "add aCollectionWithElementsOfMyKind to my children"

    aCollectionWithElementsOfMyKind do:[:child | 
         child parent: self.
         child level: level +1.
    ].
    self children addAll:aCollectionWithElementsOfMyKind.

    "Modified: 10.10.1994 / 16:13:34 / W.Olberding"
    "Modified: 15.4.1997 / 16:49:03 / cg"
!

allChildren
    "Answer my immediate children plus all my grandchildren
      -- in hierachical order and alphabeticaly sorted by name within one level."

     | kids |
     kids := OrderedCollection new.
     self addAllChildrenTo: kids.
     ^kids.

	"Modified: 10.10.94 / 16:13:34 / W.Olberding"
!

allParents 
    "return all my parents (next first - root last)"

    parent isNil ifTrue:  [ ^OrderedCollection new: 0  ]
		 ifFalse: [ ^parent, parent allParents ].

	"Modified: 10.10.94 / 16:13:34 / W.Olberding"
!

collapse 
      "Hide my children in hierachical printouts."

	 hide := true

	"Modified: 10.10.94 / 16:13:34 / W.Olberding"
!

collapseAll 
    "Hide my children and all my grandchildren in hierachical printouts."

    hide := true.
    self children do: [:kid | kid collapseAll ].

    "Modified: 10.10.1994 / 16:13:34 / W.Olberding"
    "Modified: 15.4.1997 / 16:49:34 / cg"
!

expand 
      "Show my immediate children in hierachical printouts."

	 hide := false.

	"Modified: 10.10.94 / 16:13:34 / W.Olberding"
!

expandAll 
    "Show my children and all grand children in hierachical printouts."

    hide := false.
    self children do: [:kid | kid expandAll ].

    "Modified: 10.10.1994 / 16:13:34 / W.Olberding"
    "Modified: 15.4.1997 / 16:49:48 / cg"
!

parent
    "return parent"

    ^ parent

	"Modified: 10.10.94 / 16:13:34 / W.Olberding"
!

removeAllChildren
    "Remove all children of me from the tree, i.e. let them
     forget myself as parent."

    | kids |

    kids := self allChildren.
    kids do: [:kid | kid parent: nil ].
    children := childCollectionClass new.

    "Modified: 10.10.1994 / 16:13:34 / W.Olberding"
    "Modified: 15.4.1997 / 16:50:01 / cg"
!

removeChild: anObjectOfMyKind 
    "remove anObjectOfMyKind from my children"

    anObjectOfMyKind parent: nil.
    children remove: anObjectOfMyKind.

    "Modified: 10.10.1994 / 16:13:34 / W.Olberding"
    "Modified: 15.4.1997 / 16:50:23 / cg"
!

removeYourself
    "remove me and all my children"

    parent isNil ifTrue: [^nil].
    parent removeChild: self.

    "Modified: 10.10.1994 / 16:13:34 / W.Olberding"
    "Modified: 15.4.1997 / 16:52:33 / cg"
!

withAllChildren
    "Answer me, my immediate children and all my grandchildren
      -- in hierachical order and alphabeticaly sorted by name within one level."

     | kids |
     kids := OrderedCollection with: self .
     self addAllChildrenTo: kids.
     ^kids.

	"Modified: 10.10.94 / 16:13:34 / W.Olberding"
!

withAllShownChildren
    "Answer me, my immediate children and all my grandchildren which are
     currently not hidden.
      -- in hierachical order and alphabeticaly sorted by name within one level."

     | kids |
     kids := OrderedCollection with: self .
     self addAllShownChildrenTo: kids.
     ^kids.

	"Modified: 10.10.94 / 16:13:34 / W.Olberding"
! !

!HierarchyNode methodsFor:'hierarchy sequencable operations'!

addChildAndSubChildren:aHierarchyNode after:aChild
    "add aHierarchyNode to my children after an existing child or at end"

    |node index|

    node := aHierarchyNode copyWithParent:self.

    (index := self indexOfChild:aChild) == 0 ifTrue:[
        self children add:node
    ] ifFalse:[
        self children add:node afterIndex:index
    ].
!

addChildAndSubChildren:aHierarchyNode at:anIndex
    "add aHierarchyNode to my children at an index or at end"

    |node cseq|

    node := aHierarchyNode copyWithParent:self.
    cseq := self children.

    (cseq isSequenceable and:[cseq size >= anIndex]) ifTrue:[
        cseq add:node beforeIndex:anIndex
    ] ifFalse:[
        cseq add:node
    ]
!

indexOfChild:aChild
    |seq|

    aChild notNil ifTrue:[
        seq := self children.
        seq isSequenceable ifTrue:[
            ^ seq findFirst:[:c| c == aChild ]
        ]
    ].
  ^ 0
! !

!HierarchyNode methodsFor:'initialization & release'!

initialize
        "init some defaults"

     "  name 
        id 
        parent --"

    childCollectionClass := Set.
    children := Set new.

       " contents    := Set new."

    disabled := false.
    hide     := false.
    level    := 0. "=root"

    "Modified: 10.10.1994 / 16:13:35 / W.Olberding"
    "Modified: 15.4.1997 / 16:50:44 / cg"
! !

!HierarchyNode methodsFor:'private'!

addAllChildrenTo:aCollection
    "Add all my children in hierachical and alphabetical order
     to aCollection."

    |myChildren|

    "/ myChildren := children asSortedCollection:[:x :y | x name < y name ].
    myChildren := self children.
    myChildren do:[:aChild |
        aCollection addLast: aChild.
        aChild addAllChildrenTo:aCollection.
    ].

    "Modified: 10.10.1994 / 16:13:35 / W.Olberding"
    "Modified: 15.4.1997 / 16:47:53 / cg"
!

addAllShownChildrenTo: aCollection
    "Add all my children in hierachical and alphabetical order
     if they are not hidden."

    |myChildren|

    hide ifTrue: [^self].
"/    myChildren := self children asSortedCollection:[:x :y | x name < y name ].
    myChildren := self children.
    myChildren do: [:aChild |
        aCollection addLast: aChild.
        aChild addAllShownChildrenTo: aCollection.
    ].

    "Modified: 10.10.1994 / 16:13:35 / W.Olberding"
    "Modified: 15.4.1997 / 16:53:08 / cg"
! !

!HierarchyNode methodsFor:'queries'!

childrenHidden
      "Answer true if my children shall be hidden
       in hierachical printouts etc."

      ^hide.

	"Modified: 10.10.94 / 16:13:33 / W.Olberding"
!

childrenShown
      "Answer true if my children shall be shown
       in hierachical printouts etc."

      ^hide not.

	"Modified: 10.10.94 / 16:13:33 / W.Olberding"
!

hasChildren

	^children size > 0.

	"Modified: 10.10.94 / 16:13:33 / W.Olberding"
!

isCollapsable
	"Answer true if I have shown children"

	self hasChildren ifTrue: [ ^hide == false ].
	^false.

	"Modified: 10.10.94 / 16:13:33 / W.Olberding"
!

isExpandable
	"Answer true if I have hidden children"

	self hasChildren ifTrue: [ ^hide == true ].
	^false.

	"Modified: 10.10.94 / 16:13:33 / W.Olberding"
! !

!HierarchyNode class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

