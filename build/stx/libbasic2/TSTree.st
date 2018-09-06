"{ Package: 'stx:libbasic2' }"

"{ NameSpace: Smalltalk }"

Collection subclass:#TSTree
	instanceVariableNames:'root'
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Ordered-Trees'
!

!TSTree class methodsFor:'documentation'!

documentation
"
    BTree and TSTree

    A bunch of collection classes that are useful for building large indices of things. 
    It's especially geared towards people using OODBs like GOODS, but can be used it in the image too: 
    the BTree class is great for when you need to select numeric keys by range, 
    and TSTree makes a solid basis for full-text search. 
    TreeSet has an interesting optimized #intersection: that lets you compare two collections without 
    looking at every item of either. 

    TSTree has similar properties as BTree for String  keys. 
    So as well as keeping them sorted, you can do efficient lookups of all 
    the keys with a given prefix.  One other neat trick TSTree can do is a certain 
    amount of fuzzy matching (eg find all keys with an edit distance of 3 from 
    'foo') which makes it especially useful for spell checking and similar 
    applications.

    [author:]
        Avi Bryant

    [license:]
        Dual licensed under both SqueakL and MIT. 
        This enables both base Squeak inclusion and 100% reuse.
"
! !

!TSTree class methodsFor:'queries'!

treeNodeClass
    ^ TSTreeNode
! !

!TSTree methodsFor:'accessing'!

at: aString
	^ self at: aString ifAbsent: [self error: aString printString, ' not found']
!

at: aString ifAbsent: exceptionBlock
        |ret|
        
        aString isEmpty ifTrue: [^ exceptionBlock value].
        root isNil ifTrue: [^ exceptionBlock value].
        
        ret := root lookupString: aString startingAt: 1.
        ret notNil ifTrue:[^ ret].
        ^ exceptionBlock value
!

at: aString ifAbsentPut: exceptionBlock
	^ self at: aString ifAbsent: [self at: aString put: exceptionBlock value]
!

at: aString put: anObject
        aString isEmpty ifTrue: [self error: 'Keys cannot be empty'].
        root isNil ifTrue: [root := self class treeNodeClass key: aString first].
        root lookupString: aString startingAt: 1 insert: anObject.
        ^ anObject

    "Modified: / 26-04-2014 / 11:23:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

removeKey: aString
	^ self removeKey: aString ifAbsent: [self error: 'Could not find key ', aString printString]
!

removeKey: aString ifAbsent: errorBlock
        | val |
        val := root removeString:aString startingAt:1.
        root canBeCulled ifTrue: [root := nil].
        val notNil ifTrue:[^ val].
        ^ errorBlock value
!

values
	^ Array streamContents: [:s | self do: [:ea | s nextPut: ea]]
! !

!TSTree methodsFor:'enumerating'!

do: aBlock
        root notNil ifTrue: [root do: aBlock]

    "Modified: / 08-08-2010 / 15:16:53 / cg"
! !

!TSTree methodsFor:'searching'!

matchesForPrefix: aString
	^ Array streamContents:
		[:s |
		self matchesForPrefix: aString do:
			[:match |
			s nextPut: match]]
!

matchesForPrefix: aString do: aBlock
        aString isEmpty
                ifTrue: [self do: aBlock]
                ifFalse: [root notNil ifTrue: [root matchesForPrefix: aString startingAt: 1 do: aBlock]]

    "Modified: / 08-08-2010 / 15:17:01 / cg"
!

matchesForString: aString distance: aNumber
	^ Array streamContents:
		[:s |
		self matchesForString: aString distance: aNumber do:
			[:match |
			s nextPut: match]]
!

matchesForString: aString distance: aNumber do: aBlock
	self matchesForString: aString distance: aNumber limitNodes: nil do: aBlock
!

matchesForString: aString distance: aNumber limitNodes: maxNodes do: aBlock
        | nodeCount |
        nodeCount := 0.
        aString isEmpty ifTrue: [^ self].
        root isNil ifTrue: [^ self].
        root matchesForString: aString startingAt: 1 distance: aNumber do: aBlock nodesDo:
                [:ea |
                nodeCount := nodeCount + 1.
                nodeCount = maxNodes ifTrue: [^ self]]
! !

!TSTree methodsFor:'testing'!

isFixedSize
    "return true if the receiver cannot grow"

    ^ false
! !

!TSTree class methodsFor:'documentation'!

version_CVS
    ^ '$Header$'
! !

