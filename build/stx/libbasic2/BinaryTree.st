"
 COPYRIGHT (c) 2003 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic2' }"

"{ NameSpace: Smalltalk }"

Collection subclass:#BinaryTree
	instanceVariableNames:'treeRoot sortBlock'
	classVariableNames:'DefaultSortBlock'
	poolDictionaries:''
	category:'Collections-Ordered-Trees'
!

!BinaryTree class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2003 by eXept Software AG
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
    Loosely based on the Public Domain BinaryTreeNode class from Steve Chepurny.

    WARNING:
        This tree does not reorganize itself. 
        Thus, its performance might degenerate to that of a linked list (see performance) when elements
        are added in 'already sorted' or reverse order.
        The performance is OK, if elements are added in random order and the tree is therefore more or less
        balanced.
        The worst case is to add elements in order, reverseOrder or zig-zag order.
        Use instances of my subclasses, which balance the tree if in doubt.

    EXTRA WARNING:
        the inherited storeString will generate the elements in sorted order,
        which generates exactly the generated worst case when read-back.
        If you use this class and need textual persistency, you should consider rewriting
        the storeOn: method, to enumerate elements in a binary segmentation fashion.
        Otherwise, please use one of the self-balancing trees instead,
        for example AATree or BTree.
        
    Changes:
        Changed to be Collection-protocol compatible.
        Slight speedup in insert-code.

    [author:]
        Steve Chepurny (original BinaryTreeNode implementation)
        Claus Gittinger (cg@alan)

    [instance variables:]

    [class variables:]

    [see also:]

"
!

examples
"
  a degenerated tree:
                                                                [exBegin]
    |coll|

    coll := BinaryTree new.
    (1 to:10) do:[:i | coll add:i].
    coll addAll:(20 to:30).
    coll inspect   
                                                                [exEnd]

                                                                [exBegin]
    |tree|

    tree := self new.
    tree add:'hello'.
    tree add:'aaaa'.
    tree add:'AAAb'.
    tree add:'aaaC'.
    tree add:'world'.
    tree asOrderedCollection     
                                                                [exEnd]

                                                                [exBegin]
    |tree|

    tree := self sortBlock:[:a :b | a asLowercase < b asLowercase].
    tree add:'hello'.
    tree add:'aaaa'.
    tree add:'AAAb'.
    tree add:'aaaC'.
    tree add:'world'.
    tree asOrderedCollection     
                                                                [exEnd]

  timing examples and benchmarks: see examples in AATree:  


  A functional example of a UCB-CS61A lecture's example.
  The task is to extract all values within a given range (min..max) from
  a binary tree.
  The range 'function' below does this; given a binary tree, a min and max value,
      range(bst, min, max)
  returns an array of all values which are within that range.
  Only the relevant branches of the binary tree are to be visited, of course.
                                                                [exBegin]
    |t rangeNode range|

    t := BinaryTree new.
    t add:54; add:37; add:19; add:45; add:80; add:65; add:91; add:57.

    rangeNode := [:node :min :max |
                |nodeValue leftTree rightTree left right middle|

                leftTree := node leftSubtree.
                rightTree := node rightSubtree.
                nodeValue := node data.

                left := (leftTree notNil and:[nodeValue > min]) 
                            ifTrue:[ rangeNode value:leftTree value:min value:max ]
                            ifFalse:[ #() ].

                right := (rightTree notNil and:[nodeValue < max]) 
                            ifTrue:[ rangeNode value:rightTree value:min value:max ]
                            ifFalse:[ #() ].

                middle := (nodeValue between:min and:max)
                            ifTrue:[ (Array with:nodeValue) ]    
                            ifFalse:[ #() ].

                left, middle, right
        ].
    range := [:tree :min :max |
                rangeNode value:tree rootNode value:min value:max
        ].
    range value:t value:30 value:60.                
                                                                [exEnd]

"
! !

!BinaryTree class methodsFor:'initialization'!

initialize
    "setup the default sortBlock.
     Use #<, since this is the base method in Magnitude."

    "/ only do this once at early startup
    DefaultSortBlock isNil ifTrue:[
        DefaultSortBlock := [:a :b | a < b]
    ]

    "
     BinaryTree initialize
    "
! !

!BinaryTree class methodsFor:'instance creation'!

new
    "return a new instance using the default sortOrder (which is a < b)"

    ^ self basicNew sortBlock:DefaultSortBlock
!

new:n
    "return a new instance using the default sortOrder (which is a < b)"

    ^ self new
!

sortBlock:aTwoArgBlock
    "return a new instance using the given sortBlock (which returns true if a < b)"

    ^ self basicNew sortBlock:aTwoArgBlock

    "
     |tree|

     tree := self sortBlock:[:a :b | a asLowercase < b asLowercase].
     tree add:'hello'.
     tree add:'aaaa'.
     tree add:'AAAb'.
     tree add:'aaaC'.
     tree add:'world'.
     tree asOrderedCollection
    "
! !

!BinaryTree methodsFor:'accessing'!

rootNode
    "return the rootNode of the tree"

    ^ treeRoot
!

sortBlock:something
    "set the sort block.
     This is allowed only before any elements are stored in the tree"

    self assert:treeRoot isNil message:'changing sortBlock in BinaryTree'.
    sortBlock := something.
! !

!BinaryTree methodsFor:'adding & removing'!

add:anObject
    "add anObject to the collection. The object is inserted as defined by the sortBlock.
     Returns anObject"

    treeRoot isNil ifTrue:[
        treeRoot := self rootTreeNodeClass data:anObject.
    ] ifFalse:[
        treeRoot insertNode:(self treeNodeClass data:anObject) sortBlock:sortBlock
    ].
    ^ anObject "sigh - collection protocol"

    "
     BinaryTree withAll:#(16 3 1 0 4 7 9)
     BinaryTree new add:1; add:2; yourself
     BinaryTree with:1 with:2 with:3
    "

    "Modified: / 05-08-2012 / 12:34:42 / cg"
!

includes:anElement
    "return true, if the argument, anObject is contained in the collection.
     Uses #= when comparing; i.e. the search is for an equal object."

    treeRoot isNil ifTrue:[
        ^ false.
    ].
    ^ treeRoot includesValue:anElement sortBlock:sortBlock.

    "
     BinaryTree new 
        addAll:#( 2 1 4.0 3 6 5 7); 
        includes:4           
    "
    "
     BinaryTree new 
        addAll:#( 2 1 4.0 3 6 5 7); 
        includes:4.0           
    "

    "
     BinaryTree new 
        addAll:#(2 1 4 3 6 5 7); 
        includesIdentical:4           
    "

    "
     BinaryTree new 
        addAll:#( 2 1 4.0 3 6 5 7); 
        includesIdentical:4           
    "
!

includesIdentical:anElement
    "return true, if the argument, anObject is contained in the collection.
     Uses #== (instead of #=) when comparing; 
     i.e. the search is for the object itself, not some object being just equal."

    treeRoot isNil ifTrue:[
        ^ false.
    ].
    ^ treeRoot includesIdenticalValue:anElement sortBlock:sortBlock.

    "
     BinaryTree new 
        addAll:#(4 2 1 4.0 3 6 5 7); 
        includesIdentical:4           
    "

    "
     BinaryTree new 
        addAll:#( 2 1 4.0 3 6 5 7); 
        includesIdentical:4           
    "

    "
     BinaryTree new 
        addAll:#(4 2 1 3 6 5 7); 
        includesIdentical:8
    "

    "
     BinaryTree new 
        addAll:#( 2 1 4.0 3 6 5 7); 
        includes:4           
    "
    "
     BinaryTree new 
        addAll:#( 2 1 4.0 3 6 5 7); 
        includes:4.0           
    "
!

remove:oldObject ifAbsent:exceptionValue
    |newRoot|

    treeRoot isNil ifTrue:[
        ^ exceptionValue value.
    ].
    newRoot := treeRoot removeValue:oldObject using:#= sortBlock:sortBlock.
    newRoot isNil ifTrue:[
        treeRoot data = oldObject ifFalse:[
            ^ exceptionValue value.
        ].
    ].
    treeRoot := newRoot.    
    ^ oldObject "sigh - collection protocol"

    "
     BinaryTree new 
        addAll:#(4 2 1 3 6 5 7); 
        removeIdentical:4;
        yourself   
    "

    "
     BinaryTree new 
        addAll:#(4 2 1 3 6 5 7); 
        removeIdentical:7;
        yourself      
    "
!

removeIdentical:oldObject ifAbsent:exceptionValue
    |newRoot|

    treeRoot isNil ifTrue:[
        ^ exceptionValue value.
    ].
    newRoot := treeRoot removeValue:oldObject using:#== sortBlock:sortBlock.
    newRoot isNil ifTrue:[
        treeRoot data == oldObject ifFalse:[
            ^ exceptionValue value.
        ].
    ].
    treeRoot := newRoot.    
    ^ oldObject "sigh - collection protocol"

    "
     BinaryTree new 
        addAll:#(4 2 1 3 6 5 7); 
        removeIdentical:4;
        yourself   
    "

    "
     BinaryTree new 
        addAll:#(4 2 1 3 6 5 7); 
        removeIdentical:7;
        yourself      
    "
! !

!BinaryTree methodsFor:'enumerating'!

do:aBlock
    "enumerate the tree in order"

    treeRoot notNil ifTrue:[
        treeRoot inOrderDo:[:eachNode | aBlock value:(eachNode data)].
    ].

    "
     |coll|

     coll:= OrderedCollection new.
     (BinaryTree withAll:#(5 4 3 2 1 6 7 8 9 0)) do:[:each| coll add:each].
     coll
    "

    "
     |coll|

     coll:= OrderedCollection new.
     (BinaryTree withAll:#(5 4 3 2 1 6 7 8 9 0)) preOrderDo:[:each| coll add:each].
     coll
    "

    "
     |coll|

     coll:= OrderedCollection new.
     (BinaryTree withAll:#(5 4 3 2 1 6 7 8 9 0)) postOrderDo:[:each| coll add:each].
     coll
    "
!

postOrderDo:aBlock
    "enumerate in postOrder - Left, Right, Root"

    treeRoot notNil ifTrue:[
        treeRoot postOrderDo:[:eachNode | aBlock value:(eachNode data)].
    ].
!

preOrderDo:aBlock
    "enumerate in preOrder - Root, Left, Right"

    treeRoot notNil ifTrue:[
        treeRoot preOrderDo:[:eachNode | aBlock value:(eachNode data)].
    ].
! !

!BinaryTree methodsFor:'queries'!

isFixedSize
    "return true if the receiver cannot grow"

    ^ false
!

rootTreeNodeClass
    ^ self treeNodeClass

    "Created: / 05-08-2012 / 12:30:26 / cg"
!

size
    "return the number of tree elements"

    ^ treeRoot size
!

treeNodeClass
    ^ BinaryTreeNode

    "Created: / 05-08-2012 / 11:36:26 / cg"
! !

!BinaryTree class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


BinaryTree initialize!
