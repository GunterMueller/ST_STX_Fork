"
  Copyright (c) 2005 Ian Piumarta
  All rights reserved.

  Permission is hereby granted, free of charge, to any person obtaining a
  copy of this software and associated documentation files (the 'Software'),
  to deal in the Software without restriction, including without limitation
  the rights to use, copy, modify, merge, publish, distribute, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, provided that the above copyright notice(s) and this
  permission notice appear in all copies of the Software and that both the
  above copyright notice(s) and this permission notice appear in supporting
  documentation.

  THE SOFTWARE IS PROVIDED 'AS IS'.  USE ENTIRELY AT YOUR OWN RISK.

  Last edited: 2007-01-25 03:17:27 by piumarta on emilia.local
"
"{ Package: 'stx:libbasic2' }"

"{ NameSpace: Smalltalk }"

SequenceableCollection subclass:#AVLTree
	instanceVariableNames:'rootNode orderBlock'
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Ordered-Trees'
!

Object subclass:#AVLNil
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:AVLTree
!

Object subclass:#AVLTreeNode
	instanceVariableNames:'left right height value'
	classVariableNames:''
	poolDictionaries:''
	privateIn:AVLTree
!

!AVLTree class methodsFor:'documentation'!

copyright
"
  Copyright (c) 2005 Ian Piumarta
  All rights reserved.

  Permission is hereby granted, free of charge, to any person obtaining a
  copy of this software and associated documentation files (the 'Software'),
  to deal in the Software without restriction, including without limitation
  the rights to use, copy, modify, merge, publish, distribute, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, provided that the above copyright notice(s) and this
  permission notice appear in all copies of the Software and that both the
  above copyright notice(s) and this permission notice appear in supporting
  documentation.

  THE SOFTWARE IS PROVIDED 'AS IS'.  USE ENTIRELY AT YOUR OWN RISK.

  Last edited: 2007-01-25 03:17:27 by piumarta on emilia.local
"
!

documentation
"
    AVLTree -- balanced trees.

    This implements another kind of self-balancing tree, named after their inventors,
    AVLTree is obsoleted by AATree, which has the same best/worst/average characteristics 
    (it is also self-balancing), but is always faster (roughly by a factor of 1.5 to 2).
    
    Consider using an AATree instead.
    (unless a special situation arises, of which we don't know yet)

    [see also:]
        AATree
        BTree
        SortedCollection
        https://en.wikipedia.org/wiki/AVL_tree

    Examples:
    
    |t|

    t := AVLTree new.
    self assert:(t depth == 0).
    self assert:(t size == 0).
    self assert:(t isEmpty).

    t add:'hello'.
    self assert:(t depth == 0).
    self assert:(t size == 1).
    self assert:(t notEmpty).

    t add:'world'.
    self assert:(t depth == 1).
    self assert:(t size == 2).

    t add:'aaa'.
    self assert:(t depth == 1).
    self assert:(t size == 3).

    t add:'bbb'.
    self assert:(t depth == 2).
    self assert:(t size == 4).

    self assert:(t printString = 'AVLTree(aaa bbb hello world)').

    t remove:'aaa'.
    self assert:(t printString = 'AVLTree(bbb hello world)').
    self assert:(t depth == 1).
    self assert:(t size == 3).
    
    | words tree |
    words := #( Peter Piper picked a peck of pickled peppers
                A peck of pickled peppers Peter Piper picked
                If Peter Piper picked a peck of pickled peppers
                Where is the peck of pickled peppers Peter Piper picked? ).
    tree := AVLTree new.
    tree addAll: words.
    tree printOn:Transcript. Transcript cr; cr.
    tree := AVLTree withSortBlock: [:a :b | b < a].
    tree addAll: words.
    tree printOn:Transcript. Transcript cr; cr.
"
!

performance
"
    Time to insert random 1000000 into SortedCollection: 840ms
    Time to insert random 1000000 into BinaryTree: 2040ms
    Time to insert random 1000000 into AATree: 3060ms
    Time to insert random 1000000 into AVLTree: 3780ms
    
    Time to insert ordered 1000000 into SortedCollection: 30ms
    Time to insert ordered 1000000 into BinaryTree: 72200ms
    Time to insert ordered 1000000 into AATree: 110ms
    Time to insert ordered 1000000 into AVLTree: 180ms

    Time to insert reverse ordered 1000000 into SortedCollection: 30ms
    Time to insert reverse ordered 1000000 into BinaryTree: 73880ms
    Time to insert reverse ordered 1000000 into AATree: 80ms
    Time to insert reverse ordered 1000000 into AVLTree: 160ms
"
! !

!AVLTree class methodsFor:'instance creation'!

new
    ^ super new initialize
!

withSortBlock: binaryBlock
    ^ self new orderBlock:binaryBlock.
! !

!AVLTree methodsFor:'accessing'!

orderBlock:aBlock
    orderBlock := aBlock
! !

!AVLTree methodsFor:'adding & removing'!

add: anObject
    self addNode: (AVLTreeNode withValue: anObject).
    ^anObject
!

remove: anObject        
    ^self removeNode: (AVLTreeNode withValue: anObject)
! !

!AVLTree methodsFor:'enumeration'!

do: unaryBlock          
    ^rootNode avlTreeNodeDo: unaryBlock
!

reverseDo: unaryBlock   
    ^rootNode avlTreeNodeReverseDo: unaryBlock
! !

!AVLTree methodsFor:'initialization'!

initialize
    super initialize.
    rootNode   := AVLNil.
    orderBlock := [:a :b | a < b].
! !

!AVLTree methodsFor:'private'!

addNode: aNode
    rootNode := rootNode avlTreeNodeInsert: aNode orderedBy: orderBlock.
    ^aNode
!

removeNode: aNode       
    ^rootNode := rootNode avlTreeNodeRemove: aNode orderedBy: orderBlock
! !

!AVLTree methodsFor:'queries'!

depth                   
    ^rootNode avlTreeNodeHeight
!

isEmpty
    ^rootNode == AVLNil
!

size
    ^rootNode avlTreeSize
! !

!AVLTree methodsFor:'searching'!

find: anObject          
    ^self findNode: (AVLTreeNode with: anObject)
!

findNode: aNode         
    ^rootNode avlTreeNodeFind: aNode orderedBy: orderBlock
! !

!AVLTree::AVLNil class methodsFor:'avl polymorphy'!

avlTreeNodeDo: unaryBlock
    ^ nil
!

avlTreeNodeFind: aNode
    ^AVLNil
!

avlTreeNodeHeight       
    ^0
!

avlTreeNodeInsert: aNode orderedBy: binaryBlock
    ^aNode
!

avlTreeNodeMoveRight: aNode
    ^aNode
!

avlTreeNodeRemove: aNode orderedBy: binaryBlock
    ^AVLNil
!

avlTreeNodeReverseDo: unaryBlock
    ^nil
!

avlTreeSize
    ^0
! !

!AVLTree::AVLTreeNode class methodsFor:'instance creation'!

new
    ^ self basicNew initialize.
!

withValue: anObject
    ^ self new value:anObject.
! !

!AVLTree::AVLTreeNode methodsFor:'accessing'!

height
    ^ height
!

left
    ^ left
!

left:aTreeNode
    left := aTreeNode.
!

right
    ^ right
!

right:aTreeNode
    right := aTreeNode.
!

value
    ^ value
!

value:anObject
    value := anObject
! !

!AVLTree::AVLTreeNode methodsFor:'adding & removing'!

avlTreeNodeRemove: aNode orderedBy: binaryBlock
    (aNode equals: self orderedBy: binaryBlock)
        ifTrue:
           [| temp |
            temp := left avlTreeNodeMoveRight: right.
            left := right := AVLTree::AVLNil.
            ^temp].
    (aNode precedes: self orderedBy: binaryBlock)
        ifTrue:  [left  := left  avlTreeNodeRemove: aNode orderedBy: binaryBlock]
        ifFalse: [right := right avlTreeNodeRemove: aNode orderedBy: binaryBlock].
    ^self balance
! !

!AVLTree::AVLTreeNode methodsFor:'enumeration'!

avlTreeNodeDo: unaryBlock
    left avlTreeNodeDo: unaryBlock.
    unaryBlock value: value.
    right avlTreeNodeDo: unaryBlock.
!

avlTreeNodeReverseDo: unaryBlock
    right avlTreeNodeReverseDo: unaryBlock.
    unaryBlock value: value.
    left avlTreeNodeReverseDo: unaryBlock.
! !

!AVLTree::AVLTreeNode methodsFor:'initialization'!

initialize
    left := right := AVLTree::AVLNil.
    height := 0.
    value := nil.
! !

!AVLTree::AVLTreeNode methodsFor:'misc'!

avlTreeNodeFind: aNode orderedBy: binaryBlock
    (self equals:aNode orderedBy: binaryBlock) ifTrue: [^self].
    ^(aNode precedes: self orderedBy: binaryBlock)
        ifTrue:  [left  avlTreeNodeFind: aNode orderedBy: binaryBlock]
        ifFalse: [right avlTreeNodeFind: aNode orderedBy: binaryBlock]
!

avlTreeNodeMoveRight: aNode
    right := right avlTreeNodeMoveRight: aNode.
    ^self balance
! !

!AVLTree::AVLTreeNode methodsFor:'printing & storing'!

printOn: aStream
    super printOn: aStream.
    aStream
        nextPut: $(;
        print: value;
        nextPut: $)
! !

!AVLTree::AVLTreeNode methodsFor:'private'!

balance
    | delta |
    delta := self delta.
    delta < -1
        ifTrue:
           [right delta > 0 ifTrue: [right := right rotateRight].
            ^self rotateLeft].
    delta > 1
        ifTrue:
           [left delta < 0 ifTrue: [left := left rotateLeft].
            ^self rotateRight].
    height := 0.
    (left avlTreeNodeHeight > height) ifTrue: [height := left  avlTreeNodeHeight].
    (right avlTreeNodeHeight > height) ifTrue: [height := right avlTreeNodeHeight].
    height := height + 1.
!

rotateLeft
    | pivot |
    pivot := right.
    right := pivot left.
    pivot left: self balance.
    ^pivot balance
!

rotateRight
    | pivot |
    pivot := left.
    left := pivot right.
    pivot right: self balance.
    ^pivot balance
! !

!AVLTree::AVLTreeNode methodsFor:'queries'!

avlTreeNodeHeight           
    ^height 
!

avlTreeNodeInsert: aNode orderedBy: binaryBlock
    (aNode precedes: self orderedBy: binaryBlock)
        ifTrue:  [left  := left  avlTreeNodeInsert: aNode orderedBy: binaryBlock]
        ifFalse: [right := right avlTreeNodeInsert: aNode orderedBy: binaryBlock].
    ^self balance
!

avlTreeSize
    ^ (left avlTreeSize) + 1 + (right avlTreeSize)
!

delta                       
    ^ (left avlTreeNodeHeight) - (right avlTreeNodeHeight)
!

equals: aNode orderedBy: binaryBlock
    | l r lr rl |
    l  := self value.
    r  := aNode value.
    lr := binaryBlock value: l value: r.
    rl := binaryBlock value: r value: l.
    "Partial order (<=): l = r  =>      (l <= r) and     (l >= r)  =>       lr  and      rl."
    "Strict  order (< ): l = r  =>  not (l <  r) and not (l >  r)  =>  not (lr) and not (rl)."
    "Augustus tells us the latter really means l = r  =>  not (lr or rl), saving us one send."
    ^(lr and: [rl]) or: [(lr or: [rl]) not]
!

precedes: aNode orderedBy: binaryBlock      
    ^ binaryBlock value: (self value) value: (aNode value)
! !

!AVLTree class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

