"
 COPYRIGHT (c) 2009 by eXept Software AG
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

BinaryTree subclass:#AATree
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Ordered-Trees'
!

!AATree class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2009 by eXept Software AG
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
    An AA tree is a form of balanced tree used for storing and retrieving ordered data efficiently.
    AA trees are named for Arne Andersson, their inventor.

    AA trees are a variation of the red-black tree, which in turn is an enhancement to the 
    binary search tree. One caveat with the implementation is that it needs an extra level instvar
    in the treeNode; this results in 25% more storage overhead as compared to a Red/Black or plain Binary tree.
    For performance data, see performance.

    Usage:
        As seen in the performance charts, AA trees offer better average and worst case
        performance, with a slightly lower best case performance. 
        Thus providing a more predictable performance 
        (within a factor of 2, as opposed to a much wider range for sortedCollections)

    [instance variables:]
        treeRoot             TreeNode        the top node
        sortBlock            Block           sorter; 
                                             gets two args a,b and should return true if a is
                                             to come before b in the collection    

    [author:]
        Original algorithm by Arne Andersson
        ported from wikipedia to Smalltalk code by Claus Gittinger

    [see also:]
        BTree
        SortedCollection
        https://en.wikipedia.org/wiki/AA_tree
"
!

examples
"
                                                                [exBegin]
    |coll|

    coll := AATree new.
    (1 to:10) do:[:i | coll add:i].
    coll addAll:(20 to:30).
    coll inspect   
                                                                [exEnd]

                                                                [exBegin]
    |tree|

    tree := AATree new.
    tree add:'hello'.
    tree add:'aaaa'.
    tree add:'AAAb'.
    tree add:'aaaC'.
    tree add:'world'.
    tree asOrderedCollection     
                                                                [exEnd]

                                                                [exBegin]
    |tree|

    tree := AATree sortBlock:[:a :b | a asLowercase < b asLowercase].
    tree add:'hello'.
    tree add:'aaaa'.
    tree add:'AAAb'.
    tree add:'aaaC'.
    tree add:'world'.
    tree asOrderedCollection     
                                                                [exEnd]

    timing 1:
                                                                [exBegin]
    |N randomNumbers coll1_BT coll2_AT coll3_SC coll4_AVL t1_BT t2_AT t3_SC t4_AVL|

    N := 1000000.
    randomNumbers := (1 to:N) collect:[:i | Random nextInteger].

    ObjectMemory garbageCollect.
    t1_BT := Time millisecondsToRun:[
        coll1_BT := BinaryTree new.
        coll1_BT addAll:randomNumbers
    ].
    coll1_BT := nil.
    ObjectMemory garbageCollect.

    t2_AT := Time millisecondsToRun:[
        coll2_AT := AATree new.
        coll2_AT addAll:randomNumbers
    ].
    coll2_AT := nil.
    ObjectMemory garbageCollect.

    t3_SC := Time millisecondsToRun:[
        coll3_SC := SortedCollection new.
        coll3_SC addAll:randomNumbers
    ].
    coll3_SC := nil.
    ObjectMemory garbageCollect.

    t4_AVL := Time millisecondsToRun:[
        coll4_AVL := AVLTree new.
        coll4_AVL addAll:randomNumbers
    ].
    coll4_AVL := nil.
    ObjectMemory garbageCollect.

    randomNumbers := nil.

    Transcript show:'Time to insert random '; show:N; show:' into SortedCollection: '; show:t3_SC; showCR:'ms'.
    Transcript show:'Time to insert random '; show:N; show:' into BinaryTree: '; show:t1_BT; showCR:'ms'.
    Transcript show:'Time to insert random '; show:N; show:' into AATree: '; show:t2_AT; showCR:'ms'.
    Transcript show:'Time to insert random '; show:N; show:' into AVLTree: '; show:t4_AVL; showCR:'ms'.

    ObjectMemory garbageCollect.
    t1_BT := Time millisecondsToRun:[
        coll1_BT := BinaryTree new.
        coll1_BT addAll:(1 to:100000).
    ].
    coll1_BT := nil.
    ObjectMemory garbageCollect.

    t2_AT := Time millisecondsToRun:[
        coll2_AT := AATree new.
        coll2_AT addAll:(1 to:100000)
    ].
    coll2_AT := nil.
    ObjectMemory garbageCollect.

    t3_SC := Time millisecondsToRun:[
        coll3_SC := SortedCollection new.
        coll3_SC addAll:(1 to:100000)
    ].
    coll3_SC := nil.
    ObjectMemory garbageCollect.

    t4_AVL := Time millisecondsToRun:[
        coll4_AVL := AVLTree new.
        coll4_AVL addAll:(1 to:100000)
    ].
    coll4_AVL := nil.
    ObjectMemory garbageCollect.

    Transcript show:'Time to insert ordered '; show:N; show:' into SortedCollection: '; show:t3_SC; showCR:'ms'.
    Transcript show:'Time to insert ordered '; show:N; show:' into BinaryTree: '; show:t1_BT; showCR:'ms'.
    Transcript show:'Time to insert ordered '; show:N; show:' into AATree: '; show:t2_AT; showCR:'ms'.
    Transcript show:'Time to insert ordered '; show:N; show:' into AVLTree: '; show:t4_AVL; showCR:'ms'.

    ObjectMemory garbageCollect.
    t1_BT := Time millisecondsToRun:[
        coll1_BT := BinaryTree new.
        coll1_BT addAll:(100000 downTo:1).
    ].
    coll1_BT := nil.
    ObjectMemory garbageCollect.

    t2_AT := Time millisecondsToRun:[
        coll2_AT := AATree new.
        coll2_AT addAll:(100000 downTo:1)
    ].
    coll2_AT := nil.
    ObjectMemory garbageCollect.

    t3_SC := Time millisecondsToRun:[
        coll3_SC := SortedCollection new.
        coll3_SC addAll:(100000 downTo:1)
    ].
    coll3_SC := nil.
    ObjectMemory garbageCollect.

    t4_AVL := Time millisecondsToRun:[
        coll4_AVL := AVLTree new.
        coll4_AVL addAll:(100000 downTo:1)
    ].
    coll4_AVL := nil.
    ObjectMemory garbageCollect.

    Transcript show:'Time to insert reverse ordered '; show:N; show:' into SortedCollection: '; show:t3_SC; showCR:'ms'.
    Transcript show:'Time to insert reverse ordered '; show:N; show:' into BinaryTree: '; show:t1_BT; showCR:'ms'.
    Transcript show:'Time to insert reverse ordered '; show:N; show:' into AATree: '; show:t2_AT; showCR:'ms'.
    Transcript show:'Time to insert reverse ordered '; show:N; show:' into AVLTree: '; show:t4_AVL; showCR:'ms'.
                                                                [exEnd]

  timing 2:  
                                                                [exBegin]
    |allSelectors coll1_SC coll2_BT coll3_AT coll4_Trie t1_SC t2_BT t3_AT t4_Trie|

    allSelectors := OrderedCollection new.
    Smalltalk allClassesDo:[:cls |
        cls instAndClassSelectorsAndMethodsDo:[:sel :mthd |
            allSelectors add:sel.
        ].
    ].
    Transcript show:'Unique selectors: '; show:allSelectors asSet size; showCR:''.

    t1_SC := Time millisecondsToRun:[
        coll1_SC := SortedCollection new.
        allSelectors do:[:sel |
            coll1_SC add:sel
        ].
    ].
    Transcript show:'Time to insert '; show:coll1_SC size; show:' selectors into SortedCollection: '; show:t1_SC; showCR:'ms'.

    t2_BT := Time millisecondsToRun:[
        coll2_BT := BinaryTree new.
        allSelectors do:[:sel |
            coll2_BT add:sel
        ].
    ].
    Transcript show:'Time to insert '; show:coll2_BT size; show:' selectors into BinaryTree: '; show:t2_BT; showCR:'ms'.

    t3_AT := Time millisecondsToRun:[
        coll3_AT := BinaryTree new.
        allSelectors do:[:sel |
            coll3_AT add:sel
        ].
    ].
    Transcript show:'Time to insert '; show:coll3_AT size; show:' selectors into AATree: '; show:t3_AT; showCR:'ms'.

    t4_Trie := Time millisecondsToRun:[
        coll4_Trie := TrieCollection new.
        allSelectors do:[:sel |
            coll4_Trie add:sel
        ].
    ].
    Transcript show:'Time to insert '; show:coll4_Trie size; show:' selectors into Trie: '; show:t4_Trie; showCR:'ms'.

    t1_SC := Time millisecondsToRun:[
        allSelectors do:[:sel |
            coll1_SC remove:sel
        ].
    ].
    self assert:(coll1_SC isEmpty).
    Transcript show:'Time to remove selectors from SortedCollection: '; show:t1_SC; showCR:'ms'.

    t2_BT := Time millisecondsToRun:[
        allSelectors do:[:sel |
            coll2_BT remove:sel
        ].
    ].
    self assert:(coll2_BT isEmpty).
    Transcript show:'Time to remove selectors from BinaryTree: '; show:t2_BT; showCR:'ms'.

    t3_AT := Time millisecondsToRun:[
        allSelectors do:[:sel |
            coll3_AT remove:sel
        ].
    ].
    self assert:(coll3_AT isEmpty).
    Transcript show:'Time to remove selectors from AATree: '; show:t3_AT; showCR:'ms'.

    t4_Trie := Time millisecondsToRun:[
        allSelectors do:[:sel |
            coll4_Trie remove:sel
        ].
    ].
    self assert:(coll4_Trie isEmpty).
    Transcript show:'Time to remove selectors from Trie: '; show:t4_Trie; showCR:'ms'.
                                                                [exEnd]

"
!

performance
"
    warning: the times below are very old, taken on a pentium-class machine.
    Your times will be much shorter, so only look at the ratios.
    
    SortedCollection keeps the collection sorted and dense.
    It is super fast, when adding in 'almost sorted' or almost reverse-sorted order, 
    or when only a few elements are to be added later.
    To create a big sorted collection, it is better to first collect them all unsorted in
    an orderedCollection, then convert in one operation using asSortedCollection.

        Time to insert random 100000 individually into SortedCollection: 6037ms
        Time to insert random 100000 en-bloque into SortedCollection: 172ms
        Time to insert in order 100000 individually into SortedCollection: 31ms
        Time to insert in order 100000 en-bloque into SortedCollection: 125ms
        Time to insert in reverse order 100000 individually into SortedCollection: 93ms
        Time to insert in reverse order 100000 en-bloque into SortedCollection: 125ms
        Time to remove in random order 100000 from SortedCollection: 6380ms
        Time to remove in order 100000 from SortedCollection: 109ms
        Time to remove in reverse order 100000 from SortedCollection: 125ms

    BinaryTree (which is not balancing) degenerates to a linear list, 
    if elements come in already sorted or reverse sorted,
    but behaves better than AATree if they come in randomly:

        Time to insert random 100000 individually into BinaryTree: 156ms
        Time to insert random 100000 en-bloque into BinaryTree: 156ms
        Time to insert in order 100000 individually into BinaryTree: 195921ms
        Time to insert in order 100000 en-bloque into BinaryTree: 205266ms
        Time to insert in reverse order 100000 individually into BinaryTree: 202271ms
        Time to insert in reverse order 100000 en-bloque into BinaryTree: 197684ms
        Time to remove in random order 100000 from BinaryTree: 234ms
        Time to remove in order 100000 from BinaryTree: 78ms
        Time to remove in reverse order 100000 from BinaryTree: 78ms

    AATree is slower than the best-case above (because it keeps the tre balanced), 
    but has a much better worst case performance.
    Thus providing a more predictable performance (all roughly within a factor of 2):

        Time to insert random 100000 individually into AATree: 281ms
        Time to insert random 100000 en-bloque into AATree: 265ms
        Time to insert in order 100000 individually into AATree: 281ms
        Time to insert in order 100000 en-bloque into AATree: 328ms
        Time to insert in reverse order 100000 individually into AATree: 203ms
        Time to insert in reverse order 100000 en-bloque into AATree: 218ms
        Time to remove in random order 100000 from AATree: 452ms
        Time to remove in order 100000 from AATree: 312ms
        Time to remove in reverse order 100000 from AATree: 499ms
"
! !

!AATree methodsFor:'adding & removing'!

add:anObject
    "add the argument, anObject to the receiver.
     Returns the object (sigh).

     WARNING: do not add/remove elements while iterating over the receiver.
              Iterate over a copy to do this."

    treeRoot isNil ifTrue:[
        treeRoot := self treeNodeClass data:anObject level:1.
    ] ifFalse:[
        treeRoot := treeRoot insert:anObject usingSortBlock:sortBlock.
    ].
    ^ anObject "sigh - collection protocol"

    "Modified: / 05-08-2012 / 12:36:26 / cg"
!

treeNodeClass
    ^ AATreeNode

    "Created: / 05-08-2012 / 11:39:29 / cg"
! !

!AATree class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

