"{ Package: 'stx:libbasic2' }"

"{ NameSpace: Smalltalk }"

TSTree subclass:#TSMultiTree
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Ordered-Trees'
!

!TSMultiTree class methodsFor:'documentation'!

documentation
"
    BTree and TSTree

    A bunch of collection classes that are useful for building large indices of things. 
    It's especially geared towards people using OODBs like GOODS, but can be used it in the image too: 
    the BTree class is great for when you need to select numeric keys by range, 
    and TSTree makes a solid basis for full-text search. 
    TreeSet has an interesting optimized #intersection: that lets you compare two collections without 
    looking at every item of either. 

    TSMultiTree is pretty much like TSTree but it can store multiple
    (different) values per key. Uses equality compare (=) to search for 
    the occurrence.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!TSMultiTree class methodsFor:'queries'!

treeNodeClass
    ^ TSMultiTreeNode
! !

!TSMultiTree class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

