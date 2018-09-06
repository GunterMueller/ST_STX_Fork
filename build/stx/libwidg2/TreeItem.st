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

Object subclass:#TreeItem
	instanceVariableNames:'name tree parent children contents hide readChildren'
	classVariableNames:'UnknownContents'
	poolDictionaries:''
	category:'Interface-Support'
!

!TreeItem class methodsFor:'documentation'!

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
    class to build up tree-like structures to represent file-trees, class tress etc.

    Especially suited for use with SelectionInTree and SelectionInTreeView.

    NOTICE: 
        this class has been obsoleted by HierarchicalItem with its corresponding
        view class HierarchicalListView. Please use these new ones.

    [Author:]
        W. Olberding
        Claus Atzkern

    [See also:]
        SelectionInTree
        SelectionInTreeView

"
! !

!TreeItem class methodsFor:'instance creation'!

contents:aContents
    |node|

    node := self new.
    node contents:aContents.
  ^ node
!

name:aName
    ^ self name:aName contents:nil
!

name:aName contents:aContents
    |node|

    node := self new.
    node name:aName.
    node contents:aContents.
  ^ node
!

name:aName value:aContents
    ^ self name:aName contents:aContents
!

new
    ^ self basicNew initialize
! !

!TreeItem class methodsFor:'class initialization'!

initialize
    UnknownContents isNil ifTrue:[
        UnknownContents := Object new.
    ]

    "
     self initialize
    "
! !

!TreeItem class methodsFor:'default icons'!

keysAndIcons
    "returns an IdentityDictionary containing a list of images and keys used
     by any file entry; could be redefined by subclass
    "
    ^ nil

! !

!TreeItem class methodsFor:'example-instance creation'!

newAsTreeFromSmalltalkClass:aClass
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

    aClass isNil ifTrue:[
        ((Smalltalk allClasses select:[:cls | cls superclass isNil])
            asSortedCollection:[:a :b | a name < b name])
        do:[:aSubClass |
            newInst add:(self newAsTreeFromSmalltalkClass:aSubClass).
        ]
    ] ifFalse:[
        (aClass subclasses asSortedCollection:[:a :b | a name < b name])
        do:[:aSubClass |
            newInst add:(self newAsTreeFromSmalltalkClass:aSubClass).
        ]
    ].
    ^newInst

"
      |top model sel root|

      root  := TreeItem newAsTreeFromSmalltalkClass:ByteArray.
      root expand.
      model := SelectionInTree new root:root.
      top := StandardSystemView new.
      top extent:300@300.

      sel := SelectionInTreeView new.
      sel model: model.
      sel action:[:nr | Transcript show:'selected:'; showCR:nr].
      top add:(ScrollableView forView:sel) in:((0.0 @ 0.0 ) corner:( 1.0 @ 1.0)).
      top open.
"
! !

!TreeItem methodsFor:'accessing'!

contents
    "get the contents; 
     usually, the contents is computed lazily i.e. #retrieveContents
     is invoked when the contents has not yet been set.
    "
    contents == UnknownContents ifTrue:[        
        self retrieveContents
    ].
    ^contents
!

contents:something 
    "set contents
    "
    contents := something
!

editor
    "returns an editor on the editable value or nil
    "
    ^ nil
!

hide
    ^ hide
!

hide:aBoolean
   "set hide flag
   "    
   hide:= aBoolean
!

icon
    "get the icon
    "        
    ^self retrieveAndEvaluate: #iconAction
    
!

level
    "get level
    "
    |p
     lv "{ Class:SmallInteger }"
    |
    lv := 1.
    p  := self.

    [ (p := p parent) notNil ] whileTrue:[ lv := lv + 1 ].
    ^ lv
!

middleButtonMenu
    "returns the middleButtonMenu of the item or nil
    "
    ^ nil
!

name
    "get name
    "   
    name isNil ifTrue:[    
        self retrieveLabel
    ].
    ^name
!

name:aString
    name := aString.
!

parent
    "get parent
    "
    ^ parent
!

parent:something
    "set parent
    "
    parent := something.
!

value
    "get contents
    "
    ^ self contents
!

value:something 
    "allow TreeItem to be used as a model"

    self contents:something
! !

!TreeItem methodsFor:'accessing-children'!

basicLastChild
    "returns the last child without checking for valid sequence
    "
    ^ children last
!

children
    "get list of children
    "
    (readChildren and:[children isEmpty]) ifTrue:[       
        self retrieveChildren
    ].
    ^children
!

children:aCollection 
    "set children
    "
    aCollection isNil ifTrue:[
        children removeAll
    ] ifFalse:[
        aCollection notNil ifTrue:[
            aCollection do:[:child| child parent:self ].
            readChildren := false
        ].
        children := aCollection
    ]
!

firstChild
    "returns first child in sequence
    "
    self children notEmpty ifTrue:[
        ^ children at:1
    ].
    ^ nil
        
!

lastChild
    "returns the last child in sequence"

    self children notEmpty ifTrue:[
        ^ children last
    ].
    ^ nil
!

readChildren:aBoolean
   "set read children flag
   "    
   readChildren:= aBoolean
! !

!TreeItem methodsFor:'accessing-dimensions'!

childrenWidthOn:aDevice
    "returns the maximum name length of my children
    "
    |max name|

    max := 0.

    children do:[:aChild|
        (name := aChild name) notNil ifTrue:[
            max := max max:(name widthOn:aDevice)
        ]
    ].
    ^ max
! !

!TreeItem methodsFor:'accessing-hierarchy'!

collapse 
    "hide all my children
    "
    hide := true
!

collapseAll 
    "hide all my children and sub children
    "
    hide := true.

    children notEmpty ifTrue:[
        children do:[:aChild| aChild collapseAll]
    ]
!

expand
    "show all my children
    "
    hide := false
!

expandAll 
    "show all my children and sub children
    "
    hide := false.

    self children notEmpty ifTrue:[
        children do:[:aChild| aChild expandAll ]
    ]
! !

!TreeItem methodsFor:'accessing-mvc'!

model
    "get my model (an instance of selection in tree) or nil
    "    
    ^ parent notNil ifTrue:[parent model] ifFalse:[tree]
!

model:aSelectionInTree
    "set my model (an instance of selection in tree) or nil
    "    
    tree:= aSelectionInTree
!

tree
    "get my model (an instance of selection in tree) or nil
    "    
    ^ self model
!

tree:aSelectionInTree
    "set my model (an instance of selection in tree) or nil
    "    
    self model:aSelectionInTree
! !

!TreeItem methodsFor:'adding & removing'!

add:something
    "add a child or collection of children add end
    "
    self add:something beforeIndex:(self children size + 1)

!

add:something after:aChild
    "add a child or collection of children add end
    "
    self add:something afterIndex:(self indexOfChild:aChild)
!

add:something afterIndex:anIndex
    "add a child or collection after an index
    "
    self add:something beforeIndex:(anIndex + 1)
!

add:something before:aChild
    "add a child or collection of children add end
    "
    self add:something beforeIndex:(self indexOfChild:aChild)
!

add:something beforeIndex:anIndex
    "add a child or collection before an index
    "
    |idx children|

    children := self children.

    (idx := anIndex) > children size ifTrue:[
        idx := children size + 1
    ] ifFalse:[
        idx == 0 ifTrue:[idx := 1]
    ].

    self each:something do:[:el|
        children add:el beforeIndex:idx.
        el parent:self.
        el allWithParentAndChildrenDo:[:aParent :aChild| aChild parent:aParent ].
        idx := idx + 1.
    ]
!

addFirst: something
    "add a child at the beginning
    "
    self add:something beforeIndex:1
!

remove:something 
    "remove a child or collection of children
    "
    self each:something do:[:aChild| self removeChild:aChild ].
  ^ something
!

removeAll
    "remove all children
    "
    self childrenDo:[:aChild| aChild parent:nil ].
    self children removeAll.
!

removeChild:aChild
    "remove a aChild
    "
    |item|

    (item := self children remove:aChild ifAbsent:nil) notNil ifTrue:[
        item parent:nil
    ].
    ^ item
!

removeIndex:anIndex
    "remove child at index
    "
    ^ self removeChild:(self childAt:anIndex)
! !

!TreeItem methodsFor:'change & update'!

changed
    "node changed; raise notification to model
    "
    self changed:#value
!

changed:what
    "node changed; raise notification to model
    "
    |model|

    what == #value 
        ifTrue:  [self retrieveLabel]
        ifFalse: [what == #children ifTrue: [self retrieveChildren]].

    (model := self model) notNil ifTrue:[
        model update:what with:nil from:self
    ]
!

changedSelected
    "called if the node is selected
    "
!

update:something with:aParameter from:anItem
    "raise change notification to my model
    "
    |m|

    (m := self model) notNil ifTrue:[
        m update:something with:aParameter from:anItem
    ]
! !

!TreeItem methodsFor:'converting'!

fromLiteralArrayEncoding:aLiteralEncodedArray
    "read my contents from a aLiteralEncodedArray.
    "
    |narg|

    (     (aLiteralEncodedArray size > 0)
     and:[(name := aLiteralEncodedArray at:1) isString]) ifFalse:[
        ^ nil
    ].
    narg := aLiteralEncodedArray at:2 ifAbsent:nil.

    name isSymbol ifTrue:[
        (narg isArray and:[aLiteralEncodedArray size == 2]) ifTrue:[
            ^ self fromLiteralArrayEncoding:narg
        ].
        ^ nil
    ].

    narg isArray ifFalse:[
        contents := narg.
        narg := aLiteralEncodedArray at:3 ifAbsent:nil.
    ].

    narg isArray ifTrue:[
        children := OrderedCollection new.

        narg do:[:aSubArray||aChild|
            children add:(aChild := TreeItem new).
            aChild fromLiteralArrayEncoding:aSubArray.
            aChild parent:self.
        ]
    ]



!

literalArrayEncoding
    "return myself encoded as a literal array
    "
    |array childs size noChld|

    contents isString ifTrue:[size := 2]
                     ifFalse:[size := 1].

    noChld := self numberOfChildren.

    noChld == 0 ifTrue:[
        array := Array new:size
    ] ifFalse:[
        array  := Array new:size + 1.
        childs := Array new:noChld.
        array at:(size + 1) put:childs.

        self children keysAndValuesDo:[:i :aChild|
            childs at:i put:(aChild literalArrayEncoding)
        ]
    ].
    array at:1 put:(name ? '').

    contents isString ifTrue:[
        array at:2 put:contents
    ].
    parent isNil ifTrue:[
        array := Array with:#TreeItem with:array.
    ].
    ^ array


! !

!TreeItem methodsFor:'copying'!

copy
    |node newContents|

    node := self species new.

    contents ~~ UnknownContents ifTrue:[
        newContents := contents copy.
    ] ifFalse:[
        newContents := UnknownContents
    ].
    node name:name copy.
    node contents:newContents.
    node children:(self children collect:[:c| c copy]).
    node readChildren:readChildren.
    ^ node
! !

!TreeItem methodsFor:'enumerating'!

allChildrenDo:aOneArgBlock
    "evaluate a block on each children and subchildren
    "
    self children do:[:aChild|
        aOneArgBlock value:aChild.
        aChild allChildrenDo:aOneArgBlock
    ]
!

allWithParentAndChildrenDo:aTwoArgBlock
    self childrenDo:[:aChild|
        aTwoArgBlock value:self value:aChild.
        aChild allWithParentAndChildrenDo:aTwoArgBlock
    ]
!

childrenDo:aOneArgBlock
    "evaluate a block on each children( excluding  sub-children )
    "
    self children do:aOneArgBlock
!

detectParent:aBlock
    "evaluate aBlock for my parent-chain; return the parent for which it returns true"

    |p|

    p := parent.
    [p notNil] whileTrue:[
        (aBlock value:p) ifTrue:[^ p].
        p := p parent
    ].
    ^ nil

!

each:something do:aOneArgBlock
    "evaluate a block for something or in case of a collection for each
     element in the collection
    "
    something notNil ifTrue:[
        something isCollection ifTrue:[something do:aOneArgBlock]
                              ifFalse:[aOneArgBlock value:something]
    ]

! !

!TreeItem methodsFor:'initialization & release'!

initialize
    "setup defaults
    "
    super initialize.

    children := OrderedCollection new.
    readChildren := hide := true.
    contents := UnknownContents.
! !

!TreeItem methodsFor:'printing & storing'!

asString
    "sometimes used by the SelectionInListView to get the name"

    ^ self name
!

displayOn:aGCOrStream
    "Compatibility
     append a printed desription on some stream (Dolphin,  Squeak)
     OR:
     display the receiver in a graphicsContext at 0@0 (ST80).
     This method allows for any object to be displayed in some view
     (although the fallBack is to display its printString ...)"

    "/ what a kludge - Dolphin and Squeak mean: printOn: a stream;
    "/ ST/X (and some old ST80's) mean: draw-yourself on a GC.
    aGCOrStream isStream ifFalse:[
        ^ super displayOn:aGCOrStream.
    ].

    aGCOrStream 
        nextPutAll:self class name;
        nextPut:$(.
    self printOn:aGCOrStream. 
    aGCOrStream nextPut:$)
!

printOn:aStream
    "sometimes used by the SelectionInListView to get the name"

    aStream nextPutAll:self name
!

printString
    "sometimes used by the SelectionInListView to get the name"

    ^ self name
!

printableEditValue
    "returns the printable edit value or nil"

    ^ nil
! !

!TreeItem methodsFor:'queries'!

canEdit
    "returns true if field is editable
    "
    ^ false
!

hasChildren
    "returns true if any child exists
    "
    ^ self children notEmpty
!

hasChildrenWithSubChildren
    "returns true if any child exists and has children too"

    self children contains:[:aChild| aChild hasChildren]
!

hasExpandedChildren
    "returns true if any of my children is expanded
    "
    ^ children contains:[:aChild | aChild hidden not].

    "Modified: / 13-10-2006 / 13:00:05 / cg"
!

hidden
    "returns true if node is not visible
    "
    ^ hide
!

isCollapsable
    "is collabsable; children existing and shown
    "
    ^ (self hasChildren and:[hide == false])
!

isContainedByParent:aParent
    "returns true if contained in subtree of a parent
    "
    |p|

    p := parent.

    [p notNil] whileTrue:[
        p == aParent ifTrue:[^ true ].
        p := p parent
    ].
    ^ false
!

isExpandable
    "is expandable; children existing and hidden
    "
    ^ (self hasChildren and:[hide == true])

!

isExpanded
    "return true if I am expanded"
    ^ hide not

!

numberOfChildren
    "returns number of children
    "
    ^ self children size
!

showIndicator
    "returns true if children exists
    "
    ^ self hasChildren
!

shown
    "returns true if node is visible
    "
    ^ hide not
! !

!TreeItem methodsFor:'recomputation'!

addVisibleChildrenTo:aList
    "add all visible children and sub-children to the list
    "  
    |item
     size "{ Class: SmallInteger }"
     idx  "{ Class: SmallInteger }"
    |

    hide ifFalse:[
        readChildren ifTrue:[
            self children
        ].
        (size := children size) ~~ 0 ifTrue:[
            idx := 1.
            size timesRepeat:[
                aList add:(item := children at:idx).
                item addVisibleChildrenTo:aList.
                idx := idx + 1.
            ]
        ]
    ]



!

numberOfAllVisibleChildren
    "returns number of all visible children including all the children of children
    "
    |total "{ Class: SmallInteger }"|

    hide ifTrue:[
        ^ 0
    ].
    readChildren ifTrue:[ self children ].

    (total := children size) ~~ 0 ifTrue:[
        children do:[:aChild| total := total + aChild numberOfAllVisibleChildren ].
    ].
    ^ total



! !

!TreeItem methodsFor:'retrieving'!

childrenAction
    "get children action block
    "
    |m|

    ^ (m := self model) notNil ifTrue:[m childrenAction] ifFalse:[nil]
!

contentsAction
    "get contents action block
    "
    |m|

    ^ (m := self model) notNil ifTrue:[m contentsAction] ifFalse:[nil]
!

iconAction
    "get icon action block
    "
    |m|

    ^ (m := self model) notNil ifTrue:[m iconAction] ifFalse:[nil]
!

labelAction
    "get label action block "

    |m|

    ^ (m := self model) notNil ifTrue:[m labelAction] ifFalse:[nil]
!

retrieveAll
    "retrieve all values from model
    "
    self "retrieveContents;" retrieveLabel; retrieveChildren
!

retrieveAndEvaluate: aBlockSymbol
    "retrieve a specific value from model; if no model exists, nil is returned
    "
    |arg model|

    (model := self model) isNil ifTrue:[
        ^ nil
    ].
    arg := model perform:aBlockSymbol.

    arg isBlock ifFalse:[
        ^ arg value
    ].

    ^ arg valueWithOptionalArgument:self
!

retrieveChildren
    "retrieve children from model
    "
    |retChildren cls|

    retChildren := self retrieveAndEvaluate:#childrenAction.

    retChildren notNil ifTrue:[
        retChildren isCollection ifFalse: [retChildren := OrderedCollection with:retChildren].
        cls := self class.

        self children: (retChildren collect: 
        [:obj|      
            (obj isKindOf:cls) ifTrue:[obj]
                              ifFalse:[cls new contents:obj]       
        ]). 
        readChildren := false.
    ].     

    ^ children
!

retrieveContents
    "retrieve contents value from model;
    "
    |cont|

    (cont := self retrieveAndEvaluate: #contentsAction) isNil ifTrue:[
        contents == UnknownContents ifTrue:[
            cont := ''
        ]
    ].
    ^ contents := cont
!

retrieveLabel
    "retrieve label from model
    "
    |n|

    (n := self retrieveAndEvaluate:#labelAction) isNil ifTrue:[
        n := name ? ''
    ].
    ^ name := n
! !

!TreeItem methodsFor:'searching'!

childAt:anIndex
    "get child at an index or nil"

    ^ self children at:anIndex ifAbsent:nil
!

detectChild:aOneArgBlock
    "evaluate the block on each child; 
     returns the child's node or nil.
     This searches my direct children only - not walking down sublevels.
    "

    ^ self children detect:aOneArgBlock ifNone:nil
!

detectChild:aTwoArgBlock arguments:args
    "detect a child the evaluation of the block returns true. The
     first argument to the block is the item, the second argument
     the value derived from the argument list at node-level ...
     I.e. for each sublevel, a different block arg can be specified.
     The number of arguments also defines the search level.
     i.e. if you pass (1 to:10) as args, the block will get the sub-level
     as second argument and stop the search after 10 levels.
    "

    ^ self detectChild:aTwoArgBlock arguments:args index:1
!

detectFirstChild:anOneArgBlock
    "detect the first child which evaluation of anOneArgBlock returns true.
     Recursively walks down the node-tree.
    "
    |node children|

    (anOneArgBlock value:self) ifTrue:[
        ^ self.
    ].
    (children := self children) notEmpty ifTrue:[
        children do:[:aChild |
            (node := aChild detectFirstChild:anOneArgBlock) notNil ifTrue:[
                ^ node
            ]
        ]
    ].  
    ^ nil
!

indexOfChild:aChild
    "get index of a child or 0
    "
    ^ aChild notNil ifTrue:[self children identityIndexOf:aChild]
                   ifFalse:[0]
! !

!TreeItem methodsFor:'searching-private'!

detectChild:aTwoArgBlock arguments:args index:idxArgs
    "helper for limited search.
     detect a child the evaluation of the block returns true. The
     first argument to the block is the item, the second argument
     the value derived from the argument list at an index.
     This one recursively walks down the tree searching for a node.
    "
    |num node|

    (num := args size) >= idxArgs ifTrue:[
        (aTwoArgBlock value:self value:(args at:idxArgs)) ifFalse:[
            ^ nil
        ].

        idxArgs == num ifTrue:[
            ^ self
        ].

        self children notEmpty ifTrue:[
            num := idxArgs + 1.

            children do:[:aChild|
                node := aChild detectChild:aTwoArgBlock arguments:args index:num.

                node notNil ifTrue:[
                    ^ node
                ]
            ]
        ]
    ].
    ^ nil
! !

!TreeItem class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


TreeItem initialize!
