"
    Public domain (1996 published in c.l.s) no limitation on use.

    This class is provided as-is, without any warranty. 
    It is not part of or covered by the ST/X copyright.
"
"{ Package: 'stx:libbasic2' }"

Object subclass:#BinaryTreeNode
	instanceVariableNames:'data leftSubtree rightSubtree'
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Ordered-Trees'
!

!BinaryTreeNode class methodsFor:'documentation'!

copyright
"
    Public domain (1996 published in c.l.s) no limitation on use.

    This class is provided as-is, without any warranty. 
    It is not part of or covered by the ST/X copyright.
"
!

documentation
"
    goody from comp.lang.smalltalk;
    original header:

        Here's a complete implementation of a binary tree class:


    [organization:]
        The National Capital FreeNet, Ottawa, Ontario, Canada

    [author:]
        al938@FreeNet.Carleton.CA (Steve Chepurny)

    [see also:]
        LinkedList Chain
        Link ValueLink ChainLink
"
!

examples
"
  manual building of a tree (but see BinaryTree for a collection-facade):
                                                                        [exBegin]
    |tree|

    tree := BinaryTreeNode data:2.
    tree leftSubtree:(BinaryTreeNode new data:1).
    tree rightSubtree:(BinaryTreeNode new data:3).
    tree printOn:Transcript.
                                                                        [exEnd]

  insertion:
                                                                        [exBegin]
    |tree|

    tree := BinaryTreeNode data:'hello'.
    #('the' 'quick' 'brown' 'fox' 'jumps' 'over' 'the' 'lazy' 'dogs')
    do:[:word |
        tree insert:(BinaryTreeNode data:word).
    ].
    tree inOrderDo:[:node |
        Transcript showCR:node data
    ]
                                                                        [exEnd]
"
! !

!BinaryTreeNode class methodsFor:'instance creation'!

data:data
    "Returns a new binary tree node, holding data"

    ^ self basicNew data:data

    "Modified: 10.5.1996 / 15:00:13 / cg"
    "Created: 10.5.1996 / 15:00:35 / cg"
!

empty
    "Returns a new binary tree with subtrees as binary tree nodes"

    ^ self new
	    leftSubtree: self new;
	    rightSubtree: self new

    "Modified: 10.5.1996 / 15:00:02 / cg"
! !

!BinaryTreeNode methodsFor:'accessing'!

data
    ^ data
!

data:anObject 
    data := anObject
!

leftSubtree
    ^leftSubtree
!

leftSubtree: aBinaryTree
    leftSubtree := aBinaryTree
!

nextNodeInOrder
    "return the node holding the next value"

    ^ rightSubtree leftMostNode
!

predecessor
    "return the previous value"

    ^ self prevNodeInOrder data
!

prevNodeInOrder
    "return the node holding the previous value"

    ^ leftSubtree rightMostNode
!

rightSubtree
    ^rightSubtree
!

rightSubtree: aBinaryTree
    rightSubtree := aBinaryTree
!

successor
    "return the next value"

    ^ self nextNodeInOrder data
! !

!BinaryTreeNode methodsFor:'enumeration'!

do: aBlock
    "applies aBlock to each element's data in the binary tree in inorder"

    self inOrderDo:[:eachNode | aBlock value:eachNode data]
!

inOrderDo:aBlock
    "Traverses the elements of the binary tree in
        LEFT - ROOT - RIGHT order, 
     applying a block to each node.

     We use an interative approach here, to avoid VM stack overflow"

    |nextNode stack|

    stack := Stack new.
    nextNode := self.
    [
        |left|

        stack push:nextNode.
        left := nextNode leftSubtree.
        left isNil ifTrue:[
            [
                stack isEmpty ifTrue:[
                    ^ self
                ].
                nextNode := stack pop.
                aBlock value:nextNode.
                nextNode := nextNode rightSubtree.
            ] doWhile:[nextNode isNil]
        ] ifFalse:[
            nextNode := left.
        ].
    ] loop.

    "
      BinaryTree withAll:#(2 16 3 1 0 4 7 9)
    "
!

postOrderDo: aBlock
    "Traverses the elements of the binary tree in
        LEFT - RIGHT - ROOT order, 
     applying a block to each node"

    leftSubtree notNil ifTrue:[
        leftSubtree postOrderDo: aBlock
    ].
    rightSubtree notNil ifTrue:[
        rightSubtree postOrderDo: aBlock
    ].

    aBlock value: self.
!

preOrderDo: aBlock
    "Traverses the elements of the binary tree in
        ROOT - LEFT - RIGHT order, 
     applying a block to each node"

    aBlock value: self.

    leftSubtree notNil ifTrue:[
        leftSubtree preOrderDo: aBlock
    ].
    rightSubtree notNil ifTrue:[
        rightSubtree preOrderDo: aBlock
    ].
! !

!BinaryTreeNode methodsFor:'insert & delete'!

insert:aBinaryTreeNode
    <resource: #obsolete>
    "insert a node, comparing nodes using a default sort rule"

    self obsoleteMethodWarning.
    ^ self insertNode:aBinaryTreeNode

    "Created: / 10-05-1996 / 15:09:44 / cg"
!

insert:newBinaryTreeNode sortBlock:sortBlock
    <resource: #obsolete>
    "insert a node, comparing nodes using sortBlock"

    self obsoleteMethodWarning.
    self insertNode:newBinaryTreeNode sortBlock:sortBlock

    "Modified: / 05-08-2012 / 12:35:21 / cg"
!

insertNode:aBinaryTreeNode
    "insert a node, comparing nodes using a default sort rule"

    ^ self
        insertNode:aBinaryTreeNode
        sortBlock:[:a :b | a < b]

    "Created: / 05-08-2012 / 12:33:00 / cg"
!

insertNode:newBinaryTreeNode sortBlock:sortBlock
    "insert a node, comparing nodes using sortBlock"

    |node newValue left right|

    "/ the following might be ugly - however, it it slightly faster than the stuff below.
    "/ AND it does not suffer stack exhaustion....
    "/ (we MUST have LCO in smalltalk for this to be automatically faster

    node := self.
    newValue := newBinaryTreeNode data.
    [true] whileTrue:[
        (sortBlock value:newValue value:node data) ifTrue:[
            "newValue is less the node data"
            left := node leftSubtree.
            left isNil ifTrue:[
                node leftSubtree:newBinaryTreeNode.
                ^ self
            ].
            node := left
        ] ifFalse:[
            "newValue is larger or equal than node data"
            right := node rightSubtree.
            right isNil ifTrue:[
                node rightSubtree:newBinaryTreeNode.
                ^ self
            ].
            "if right data is less than node, we would be jumping back..."
            node := right
        ]
    ].
    "not reached"

"/    (sortBlock value:newBinaryTreeNode data value:data) ifTrue:[
"/        leftSubtree isNil ifTrue:[
"/            leftSubtree := newBinaryTreeNode.
"/        ] ifFalse:[
"/            leftSubtree insertNode:newBinaryTreeNode sortBlock:sortBlock
"/        ]
"/    ] ifFalse:[
"/        rightSubtree isNil ifTrue:[
"/            rightSubtree := newBinaryTreeNode.
"/        ] ifFalse:[
"/            rightSubtree insertNode:newBinaryTreeNode sortBlock:sortBlock
"/        ]
"/    ]

    "
     BinaryTree withAll:#(16 3 1 0 4 7 9)             
    "

    "Created: / 05-08-2012 / 12:33:39 / cg"
! !

!BinaryTreeNode methodsFor:'printing'!

printDataOn:aStream
    data printOn: aStream.

    "Created: / 05-08-2012 / 14:00:10 / cg"
!

printOn: aStream
    "Append the ascii representation to aStream"

    data isNil
        ifTrue: [aStream nextPutAll: '--']
        ifFalse: [
            aStream nextPut: $(.
            self printDataOn: aStream. aStream space.
            leftSubtree printOn: aStream. aStream space.
            rightSubtree printOn: aStream.
            aStream nextPut: $)]

    "Modified: / 06-08-2012 / 08:05:04 / cg"
!

printOn:aStream indent:i
    "Append the graphical ascii representation to aStream"

    data isNil
        ifTrue: [aStream spaces:i. aStream nextPutAll: '--']
        ifFalse: [
            aStream spaces:i. aStream nextPut: $(.
            self printDataOn: aStream. 
            aStream cr.
            leftSubtree isNil 
                ifTrue:[ aStream spaces:i+2. '--' printOn: aStream]
                ifFalse:[ leftSubtree printOn: aStream indent:i+2 ]. 
            aStream cr.
            rightSubtree isNil 
                ifTrue:[ aStream spaces:i+2. '--' printOn: aStream]
                ifFalse:[ rightSubtree printOn: aStream indent:i+2 ]. 
            aStream nextPut: $)
        ]

    "Modified: / 06-08-2012 / 08:05:15 / cg"
! !

!BinaryTreeNode methodsFor:'private helpers'!

removeLeftMostNode
    |left ll parent|

    leftSubtree isNil ifTrue:[
        self error:'should not happen'
    ].

    parent := self.
    left := leftSubtree.
    [ (ll := left leftSubtree) notNil ] whileTrue:[
        parent := left.
        left := ll.
    ].
    parent leftSubtree:(left rightSubtree).
    left rightSubtree:nil.
    ^ left.
!

removeLeftRightMostNode
    |rightMost|

    leftSubtree rightSubtree isNil ifTrue:[
        rightMost := leftSubtree.
        leftSubtree := leftSubtree leftSubtree.
        ^ rightMost.
    ].

    ^ leftSubtree removeRightMostNode

    "
     |tree|

     tree := BinaryTreeNode data:4.
     #(2 6 1 3 5 7)
     do:[:word |
         tree insertNode:(BinaryTreeNode data:word).
     ].
     tree printOn:Transcript indent:0. Transcript cr.
     '---------------------------' printOn:Transcript. Transcript cr.
     Transcript showCR:tree removeLeftRightMostNode.
     tree printOn:Transcript indent:0. Transcript cr.
    "
!

removeRightLeftMostNode
    |leftMost|

    rightSubtree leftSubtree isNil ifTrue:[
        leftMost := rightSubtree.
        rightSubtree := rightSubtree rightSubtree.
        ^ leftMost.
    ].

    ^ rightSubtree removeLeftMostNode

    "
     |tree|

     tree := BinaryTreeNode data:4.
     #(2 6 1 3 5 7)
     do:[:word |
         tree insertNode:(BinaryTreeNode data:word).
     ].
     tree printOn:Transcript indent:0. Transcript cr.
     '---------------------------' printOn:Transcript. Transcript cr.
     Transcript showCR:tree removeRightLeftMostNode.
     tree printOn:Transcript indent:0. Transcript cr.
    "
!

removeRightMostNode
    |right rr parent|

    rightSubtree isNil ifTrue:[
        self error:'should not happen'
    ].

    parent := self.
    right := rightSubtree.
    [ (rr := right rightSubtree) notNil ] whileTrue:[
        parent := right.
        right := rr.
    ].
    parent rightSubtree:(right leftSubtree).
    right leftSubtree:nil.
    ^ right.

    "
     |tree|

     tree := BinaryTreeNode data:4.
     #(2 6 1 3 5 7)
     do:[:word |
         tree insertNode:(BinaryTreeNode data:word).
     ].
     Transcript showCR:tree.
     Transcript showCR:(tree removeLeftRightMostNode). 
     Transcript showCR:tree.
    "
!

removeValue:oldValue using:compareOp sortBlock:sortBlock
    "remove a value - returns a new treeNode, or nil if the value is not in the tree"

    |thisIsMyNode newTop newLeft newRight|

    "/ speed hack - avoids message sends (and also better inline caching)
    compareOp == #== ifTrue:[
        thisIsMyNode := (data == oldValue).
    ] ifFalse:[
        compareOp == #= ifTrue:[
            thisIsMyNode := (data = oldValue).
        ] ifFalse:[
            thisIsMyNode := data perform:compareOp with:oldValue.
        ].
    ].

    thisIsMyNode ifTrue:[
        leftSubtree isNil ifTrue:[
            ^ rightSubtree
        ].
        rightSubtree isNil ifTrue:[
            ^ leftSubtree
        ].
        newTop := self removeRightLeftMostNode.
"/        self assert:(rightSubtree isNil or:[(sortBlock value:rightSubtree data value:newTop data) not]).
"/        self assert:(leftSubtree isNil or:[sortBlock value:leftSubtree data value:newTop data]).
        newTop 
            leftSubtree:leftSubtree; 
            rightSubtree:rightSubtree.
        ^ newTop.
    ].

    (sortBlock value:oldValue value:data) ifTrue:[
        "oldValue is less the node data
         and should be in the left part"
        leftSubtree isNil ifTrue:[
            ^ nil
        ].
        newLeft := leftSubtree removeValue:oldValue using:compareOp sortBlock:sortBlock.
        newLeft isNil ifTrue:[
            (leftSubtree data perform:compareOp with:oldValue) ifFalse:[
                ^ nil
            ].
        ].
        leftSubtree := newLeft.
    ] ifFalse:[
        "oldValue is larger or equal (equal if doing identity-compare above)
         than the node data and should be in the right part"
        rightSubtree isNil ifTrue:[
            ^ nil
        ].
        newRight := rightSubtree removeValue:oldValue using:compareOp sortBlock:sortBlock.
        newRight isNil ifTrue:[
            (rightSubtree data perform:compareOp with:oldValue) ifFalse:[
                ^ nil
            ].
        ].
        rightSubtree := newRight.
    ].
    ^ self. 
! !

!BinaryTreeNode methodsFor:'queries'!

depth
    "Returns the depth of the binary tree (0 for leafs)"

    ^ self level - 1.
!

getTreeWithAnInteger: anInteger
    "Private - Returns the BinaryTree with data anInteger.  
     If anInteger not in the tree it returns nil."

    self inOrderDo: [:each| each data = anInteger ifTrue:[^each]].
    ^nil.
!

inOrderSuccessor
    "Returns the in-order successor the of receiver.
     (that is the leftMost node on the right side)
     If receiver is empty then returns the receiver."

    rightSubtree isNil ifTrue:[^ self].
    ^ rightSubtree leftMostNode
!

includesIdenticalValue:aValue sortBlock:sortBlock
    "return true, if aValue is contained as some node's data"

    data == aValue ifTrue:[ ^ true ].
    (sortBlock value:aValue value:data) ifTrue:[
        leftSubtree isNil ifTrue:[
            ^ false
        ].
        ^ leftSubtree includesIdenticalValue:aValue sortBlock:sortBlock.
    ].
    rightSubtree isNil ifTrue:[
        ^ false
    ].
    ^ rightSubtree includesIdenticalValue:aValue sortBlock:sortBlock.
!

includesValue:aValue sortBlock:sortBlock
    "return true, if some node's data is equal to aValue"

    data = aValue ifTrue:[ ^ true ].

    (sortBlock value:aValue value:data) ifTrue:[
        leftSubtree isNil ifTrue:[
            ^ false
        ].
        ^ leftSubtree includesValue:aValue sortBlock:sortBlock.
    ].
    rightSubtree isNil ifTrue:[
        ^ false
    ].
    ^ rightSubtree includesValue:aValue sortBlock:sortBlock.
!

isEmpty
    "returns true if the binary tree is empty and false otherwise"

    ^ data isNil
!

isLeaf
    "Returns true if self is a leaf"

    ^ ((leftSubtree isNil) and: [rightSubtree isNil])
!

leftMostNode
    "Returns the leftMost (smallest-valued) node"

    leftSubtree isNil ifTrue:[^ self].
    ^ leftSubtree leftMostNode
!

level
    "Returns the level of the binary tree (1 for leafs)"

    |l|

    l := 0.
    leftSubtree notNil ifTrue:[
        l := leftSubtree level
    ].
    rightSubtree notNil ifTrue:[
        l := l max:(rightSubtree level)
    ].
    ^ l + 1
!

rightMostNode
    "Returns the rightMost (largest-valued) node"

    rightSubtree isNil ifTrue:[^ self].
    ^ rightSubtree rightMostNode
!

size
    "Returns the size of the binary tree"

    ^ 1
    + (leftSubtree isNil ifTrue: [0] ifFalse:[leftSubtree size])
    + (rightSubtree isNil ifTrue: [0] ifFalse:[rightSubtree size])
! !

!BinaryTreeNode class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic2/BinaryTreeNode.st,v 1.9 2013-04-08 14:36:27 stefan Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic2/BinaryTreeNode.st,v 1.9 2013-04-08 14:36:27 stefan Exp $'
! !

