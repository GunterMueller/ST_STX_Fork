"{ Package: 'stx:libbasic2' }"

"{ NameSpace: Smalltalk }"

Collection subclass:#BTree
	instanceVariableNames:'root'
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Ordered-Trees'
!

Object subclass:#BTreeKeys
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:BTree
!

BTree::BTreeKeys variableSubclass:#BTreeKeysArray
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:BTree
!

Object variableSubclass:#BTreeNode
	instanceVariableNames:'parent keys'
	classVariableNames:''
	poolDictionaries:''
	privateIn:BTree
!

BTree::BTreeNode variableSubclass:#BTreeInteriorNode
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:BTree::BTreeNode
!

BTree::BTreeNode variableSubclass:#BTreeLeafNode
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:BTree
!

BTree::BTreeKeys subclass:#BTreeStringKeys
	instanceVariableNames:'keys prefix abbreviations'
	classVariableNames:''
	poolDictionaries:''
	privateIn:BTree
!

!BTree class methodsFor:'documentation'!

documentation
"
    BTree and TSTree
    
    A bunch of collection classes that are useful for building large indices of things. 
    It's especially geared towards people using OODBs like GOODS, but can be used it in the image too: 
    the BTree class is great for when you need to select numeric keys by range, 
    and TSTree makes a solid basis for full-text search. 
    TreeSet has an interesting optimized #intersection: that lets you compare two collections without 
    looking at every item of either. 
    I'm also going to be rolling some code in here from Benjamin Pollack specifically aimed at indexing 
    by date ranges, which lets you do quick queries of all the events that overlap with a specific week, 
    for instance. 

    This is an implementation of the BTree data structure as a Smalltalk collection. 
    It provides log(n) inserts, deletes, and retrieves of values by key. 
    The keys have to be sortable (ie, Magnitudes).

    This is useful in situations where you want to minimize the number and size of individual objects 
    that need to be accessed when using a large collection - for example, when objects are being swapped 
    out to an object database such as GOODS. 
    It is probably not a good choice for a collection that will be kept entirely in memory.


    What you get: efficient sorted iteration through the keys, possibly limited to 
    a given range.  For example, if you store a list of people keyed by their 
    birthdate, and then want to find everyone born in a certain year, in order of 
    birth, you can do that very fast.

    Also in the BTree package is a TSTree, which has similar properties for String 
    keys.  So as well as keeping them sorted, you can do efficient lookups of all 
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
!

examples
"
    |coll|

    coll := BTree new.
    (1 to:10) do:[:i | coll at:(i printString) put:(i squared) ].
    coll inspect.
    coll at:'10'       
"
! !

!BTree class methodsFor:'instance creation'!

keys: aBTreeKeys
	^ self basicNew initializeWithKeys: aBTreeKeys
!

new
	^ self order: 5
!

order: aNumber
	^ self keys: (BTreeKeysArray new: aNumber)
! !

!BTree methodsFor:'accessing'!

at: aMagnitude
	^ self at: aMagnitude ifAbsent: [self error: aMagnitude printString, ' not found']
!

at: aMagnitude ifAbsent: errorBlock
       | leaf |
       leaf := root existingLeafForKey: aMagnitude.
       leaf isNil ifTrue: [^ errorBlock value].
       ^ leaf valueForKey: aMagnitude ifAbsent: errorBlock

    "Modified (format): / 18-11-2011 / 14:10:16 / cg"
!

depth
	^ root depth
!

keys
	^ Array streamContents:
		[:s |
		self keysDo: [:k | s nextPut: k]]
!

order
	^ root size
!

values
	^ Array streamContents:
		[:s |
		self keysAndValuesDo: [:k :v | s nextPut: v]]
! !

!BTree methodsFor:'adding'!

at: aMagnitude put: anObject
	| leaf |
	leaf _ root leafForKey: aMagnitude.
	leaf insertKey: aMagnitude value: anObject.
	root _ leaf root.
	^ anObject
!

removeKey: aMagnitude
	| leaf |
	leaf _ root leafForKey: aMagnitude.
	leaf removeKey: aMagnitude.
	root _ leaf root
! !

!BTree methodsFor:'enumerating'!

commonKeysWith: aTree keysAndValuesDo: aBlock
	^ aTree depth < self depth
		ifTrue: [aTree root commonKeysWith: root keysAndValuesDo: aBlock flip: true]
		ifFalse: [root commonKeysWith: aTree root keysAndValuesDo: aBlock flip: false]
!

do: aBlock
	root allLeavesDo: [:ea | ea valuesDo: aBlock]
!

from: start to: end do: aBlock
	self from: start to: end keysAndValuesDo: [:k :v | aBlock value: v]
!

from: start to: end keysAndValuesDo: aBlock
	root leavesFrom: start to: end do:
		[:ea |
		ea keysAndValuesDo:
			[:k :v |
			(k between: start and: end) ifTrue:
				[aBlock value: k value: v]]]
!

keysAndValuesDo: aBlock
	root allLeavesDo: [:ea | ea keysAndValuesDo: aBlock]
!

keysDo: aBlock
    "evaluate the argument, aBlock for every key in the collection."

    root allLeavesDo: [:ea | ea keysDo: aBlock]

    "Modified: / 24-08-2010 / 10:13:24 / cg"
! !

!BTree methodsFor:'initialize-release'!

initializeWithKeys: aBTreeKeys
	aBTreeKeys size > 3 ifFalse: [self error: 'The BTree order must be at least 4'].
	root _ BTreeLeafNode keys: aBTreeKeys
! !

!BTree methodsFor:'private'!

root
	^ root
! !

!BTree methodsFor:'testing'!

isFixedSize
    "return true if the receiver cannot grow"

    ^ false
! !

!BTree::BTreeKeys class methodsFor:'documentation'!

documentation
"
    [author:]
        Avi Bryant

    [license:]
        Dual licensed under both SqueakL and MIT. 
        This enables both base Squeak inclusion and 100% reuse.
"
! !

!BTree::BTreeKeys methodsFor:'accessing'!

first
    ^ self at:1

    "Modified (format): / 02-08-2011 / 09:19:05 / cg"
! !

!BTree::BTreeKeys methodsFor:'as yet unclassified'!

emptyCopy
    ^ self class new:self size

    "Modified (format): / 02-08-2011 / 09:19:22 / cg"
!

findIndexForKey:aMagnitude 
    self 
        withIndexDo:[:key :i | 
            (key isNil or:[ key > aMagnitude ]) ifTrue:[
                ^ i - 1
            ]
        ].
    ^ self size

    "Modified (format): / 02-08-2011 / 09:19:10 / cg"
!

shiftLeftTo:index 
    index to:self size - 1 by:1 do:[:i | 
        self at:i put:(self at:i + 1)
    ].
    self at:self size put:nil.

    "Modified (format): / 02-08-2011 / 09:18:52 / cg"
!

shiftRightFrom:index 
    self size to:index + 1 by:-1 do:[:i | 
        self at:i put:(self at:i - 1)
    ]

    "Modified (format): / 02-08-2011 / 09:18:57 / cg"
! !

!BTree::BTreeKeys methodsFor:'enumeration'!

withIndexDo:aBlock 
    1 to:self size do:[:i | 
        aBlock value:(self at:i) value:i
    ]

    "Modified (format): / 02-08-2011 / 09:19:01 / cg"
! !

!BTree::BTreeKeys methodsFor:'queries'!

canGrow
    ^ (self at:self size) isNil

    "Modified (format): / 02-08-2011 / 09:19:27 / cg"
!

canShrink
    ^ (self at:self size // 2 + 1) notNil

    "Modified (format): / 02-08-2011 / 09:19:23 / cg"
! !

!BTree::BTreeKeysArray class methodsFor:'documentation'!

documentation
"
    [author:]
        Avi Bryant

    [license:]
        Dual licensed under both SqueakL and MIT. 
        This enables both base Squeak inclusion and 100% reuse.
"
! !

!BTree::BTreeNode class methodsFor:'as yet unclassified'!

keys: anArray
	^ (self new: (anArray size)) keys: anArray
! !

!BTree::BTreeNode class methodsFor:'documentation'!

documentation
"
    [author:]
        Avi Bryant

    [license:]
        Dual licensed under both SqueakL and MIT. 
        This enables both base Squeak inclusion and 100% reuse.
"
! !

!BTree::BTreeNode methodsFor:'accessing'!

children
	^ Array streamContents: [:s | self childrenDo: [:ea | s nextPut: ea]]
!

depth
	^ parent ifNil: [1] ifNotNil: [1 + parent depth]
!

firstKey
	^ keys first
!

parent
	^ parent
!

parent: aBTreeNode
	parent _ aBTreeNode
!

root
	^ parent
		ifNil: [self]
		ifNotNil: [parent root]
!

values
	^ Array streamContents: [:s | self valuesDo: [:ea | s nextPut: ea]]
! !

!BTree::BTreeNode methodsFor:'enumerating'!

allChildrenDo: aBlock
	self childrenDo:
		[:ea |
		aBlock value: ea.
		ea allChildrenDo: aBlock]
!

allLeavesDo: aBlock
	self withAllChildrenDo: [:ea | ea isLeaf ifTrue: [aBlock value: ea]]
!

childrenDo: aBlock
	self subclassResponsibility
!

keysAndValuesDo: aBlock
        keys withIndexDo:
                [:key :i |
                key notNil ifTrue: [aBlock value: key value: (self at: i)]]

    "Modified: / 08-08-2010 / 14:39:17 / cg"
!

keysDo: aBlock
    keys withIndexDo:[:key :i |
        key isNil ifTrue:[^ self].
        aBlock value: key
    ]

    "Modified: / 02-08-2011 / 09:17:49 / cg"
!

leavesFrom: start to: end do: aBlock
	self subclassResponsibility
!

valuesDo: aBlock
	self keysAndValuesDo: [:k :v | aBlock value: v]
!

withAllChildrenDo: aBlock
	aBlock value: self.
	self allChildrenDo: aBlock.
! !

!BTree::BTreeNode methodsFor:'inserting'!

insertKey: aMagnitude value: anObject
	| index key |
	index _ keys findIndexForKey: aMagnitude.
	index = 0 ifTrue:
		[self canGrow
			ifTrue:
				[self shiftRightFrom: 1.
				^ self insertKey: aMagnitude value: anObject at: 1]
			ifFalse:
				[self split.
				^ (parent childForKey: aMagnitude) insertKey: aMagnitude value: anObject]].
	
	key _ keys at: index.
	key = aMagnitude ifTrue:
		[^ self insertKey: aMagnitude value: anObject at: index].
	index < self size ifTrue:
		[key _ keys at: index + 1.
		key
			ifNil: [^ self insertKey: aMagnitude value: anObject at: index+1]
			ifNotNil:
				[self canGrow ifTrue:
					[self shiftRightFrom: index+1.
					^ self insertKey: aMagnitude value: anObject at: index+1]]].

	"otherwise"
	self split.
	^ (parent childForKey: aMagnitude) insertKey: aMagnitude value: anObject
! !

!BTree::BTreeNode methodsFor:'private'!

ensureParent
        parent isNil ifTrue:[
                parent := BTreeInteriorNode keys: keys emptyCopy.
                parent insertKey: self firstKey value: self
        ].
        ^ parent

    "Modified: / 18-11-2011 / 14:11:11 / cg"
!

grow
        | sibling |
        parent notNil ifTrue:
                [sibling := parent nextSiblingForChild: self.
                sibling isNil ifTrue: ["we're the new root" parent := nil. ^ self].
                sibling canShrink
                        ifTrue: [self stealFrom: sibling]
                        ifFalse: [self mergeWith: sibling]]

    "Modified: / 18-11-2011 / 14:29:49 / cg"
!

insertKey: aMagnitude value: anObject at: index
	keys at: index put: aMagnitude.
	self at: index put: anObject
!

keys: anArray
	keys _ anArray
!

mergeWith: aNode		
	| oldKey |
	oldKey _ self firstKey.
	aNode keysAndValuesDo:
		[:k :v |
		self insertKey: k value: v].
	parent removeKey: aNode firstKey.
	parent updateKey: oldKey to: self firstKey.
!

shiftLeftTo: index
	keys shiftLeftTo: index.
	index to: self size - 1 by: 1 do:
		[:i |
		self at: i put: (self at: i+1)].
	self at: self size put: nil.
!

shiftRightFrom: index
	keys shiftRightFrom: index.
	self size to: index+1 by: -1 do:
		[:i |
		self at: i put: (self at: i-1)]
!

split
	| other midpoint |
	other _ self class keys: keys emptyCopy.
	midpoint _ self size // 2 + 1.
	midpoint to: self size do:
		[:i |
		other insertKey: (keys at: i) value: (self at: i) at: (i - midpoint + 1).
		keys at: i put: nil.
		self at: i put: nil].
	
	self ensureParent insertKey: other firstKey value: other
!

stealFrom: aNode
        | key value |
        aNode firstKey > self firstKey
                ifTrue: [value := aNode at: 1. key := aNode firstKey]
                ifFalse:
                        [aNode keysAndValuesDo: [:k :v | key := k. value := v].
                        parent notNil ifTrue: [parent updateKey: self firstKey to: key]].
        self insertKey: key value: value.
        aNode removeKey: key

    "Modified: / 08-08-2010 / 14:39:50 / cg"
! !

!BTree::BTreeNode methodsFor:'removing'!

removeKey: aMagnitude
        | index key |
        self canShrink ifFalse: [self grow].
        
        index := keys findIndexForKey: aMagnitude.
        key := keys at: index.
        key = aMagnitude ifFalse: [^ self error: 'No such key'].
        
        self shiftLeftTo: index.
        
        index = 1 ifTrue: [parent notNil ifTrue: [parent updateKey: key to: self firstKey]]

    "Modified: / 08-08-2010 / 14:39:29 / cg"
! !

!BTree::BTreeNode methodsFor:'testing'!

canGrow
	^ keys canGrow
!

canShrink
	^ keys canShrink
!

isLeaf
	self subclassResponsibility
! !

!BTree::BTreeNode::BTreeInteriorNode class methodsFor:'documentation'!

documentation
"
    [author:]
        Avi Bryant

    [license:]
        Dual licensed under both SqueakL and MIT. 
        This enables both base Squeak inclusion and 100% reuse.
"
! !

!BTree::BTreeNode::BTreeInteriorNode methodsFor:'accessing'!

childForKey: aMagnitude
	| index |
	index _ keys findIndexForKey: aMagnitude.
	index = 0 ifTrue:
		[keys at: 1 put: aMagnitude.
		^ self at: 1].
	^ self at: index
		
!

existingChildForKey: aMagnitude
       "Unlike #childForKey:, this method looks for a child, but doesn't mess with the tree if it doesn't exist."
       | index |
       index _ keys findIndexForKey: aMagnitude.
       index = 0
               ifTrue: [^ nil]
               ifFalse: [^ self at: index].
!

existingLeafForKey: aMagnitude
       "Unlike #leafForKey:, this method looks for a leaf but doesn't mess with the tree if it doesn't exist."
       | child |
       child := self existingChildForKey: aMagnitude.
       ^ child notNil 
            ifTrue: [child existingLeafForKey: aMagnitude]
            ifFalse:[nil]

    "Modified: / 19-11-2016 / 12:20:31 / cg"
!

insertKey: aMagnitude value: anObject at: index
	super insertKey: aMagnitude value: anObject at: index.
	anObject parent: self
!

updateKey: oldMagnitude to: newMagnitude
       keys withIndexDo:
               [:key :i |
               key = oldMagnitude ifTrue:
                       [(i = 1 and: [parent notNil]) ifTrue:
                               [parent updateKey: oldMagnitude to: newMagnitude].
                       ^ keys at: i put: newMagnitude]].
       self error: 'No such key'
! !

!BTree::BTreeNode::BTreeInteriorNode methodsFor:'enumerating'!

childrenDo: aBlock
	self valuesDo: aBlock
!

leavesFrom: start to: end do: aBlock
	| startIndex endIndex |
	startIndex _ (keys findIndexForKey: start) max: 1.
	endIndex _ (keys findIndexForKey: end).
	startIndex to: endIndex do: [:i | (self at: i) leavesFrom: start to: end do: aBlock]
! !

!BTree::BTreeNode::BTreeInteriorNode methodsFor:'misc'!

commonKeysWith: aNode keysAndValuesDo: aBlock flip: aBoolean
    | index |
    aNode firstKey < self firstKey ifTrue: [^ aNode commonKeysWith: self keysAndValuesDo: aBlock flip: aBoolean not].
    index := (keys findIndexForKey: aNode firstKey) max: 1.
    index to: self size do: [:i |
        |c|

        (c := self at: i) notNil ifTrue:[
             c commonKeysWith: aNode keysAndValuesDo: aBlock flip: aBoolean
        ]
    ]
! !

!BTree::BTreeNode::BTreeInteriorNode methodsFor:'queries'!

depth
	^ 1 + self firstChild depth
!

firstChild
	self childrenDo: [:ea | ^ ea].
	self error: 'No children'.
!

isLeaf
	^ false
!

leafForKey: aMagnitude
	^ (self childForKey: aMagnitude) leafForKey: aMagnitude
!

nextSiblingForChild: aNode
	| index |
	index _ keys findIndexForKey: aNode firstKey.
	^ (index = self size or: [(keys at: index+1) isNil]) 
		ifTrue: [index = 1 ifFalse: [self at: index - 1] ifTrue: [nil]]
		ifFalse: [self at: index + 1]
! !

!BTree::BTreeLeafNode class methodsFor:'documentation'!

documentation
"
    [author:]
        Avi Bryant

    [license:]
        Dual licensed under both SqueakL and MIT. 
        This enables both base Squeak inclusion and 100% reuse.
"
! !

!BTree::BTreeLeafNode methodsFor:'as yet unclassified'!

childrenDo: aBlock
	"no children"
!

commonKeysWith: aNode keysAndValuesDo: aBlock flip: aBoolean
        | index key block leaf advanceKey last |

        aBoolean 
             ifTrue: [ block := [:k :v1 :v2 | aBlock value: k value: v2 value: v1] ] 
             ifFalse: [ block := aBlock ].

        index := 0.
        advanceKey :=
                [index := index + 1.
                index > self size ifTrue: [^ self].
                key := keys at: index.
                key isNil ifTrue: [^ self]].
        last := self lastKey.
        
        advanceKey value.
        [key < aNode firstKey] whileTrue: [advanceKey value ].
                
        [
            leaf := aNode existingLeafForKey: key.
            leaf lastKey < key 
                ifTrue: [advanceKey value ] 
                ifFalse:[
                    leaf keysAndValuesDo: [:otherKey :otherValue |
                        otherKey > last ifTrue: [^ self].
                        [key < otherKey] whileTrue: [advanceKey value ].
                        key = otherKey ifTrue: [block value: key value: (self at: index) value: otherValue]
                    ].
                    key > leaf lastKey ifFalse: [advanceKey value ]
                ]
        ] loop

    "Modified (format): / 18-11-2011 / 14:10:45 / cg"
!

existingLeafForKey: aMagnitude
       ^ self
!

keys
	^ Array streamContents: [:s | self keysDo: [:ea | s nextPut: ea]]
!

lastKey
	| last |
	last _ nil.
	self keysDo: [:k | last _ k].
	^ last
!

leafForKey: aMagnitude
	^ self
!

leavesFrom: start to: end do: aBlock
	aBlock value: self
!

valueForKey: aMagnitude ifAbsent: errorBlock
        | i |
        i _ keys findIndexForKey: aMagnitude.
        (i > 0 and: [(keys at: i) = aMagnitude])
                ifTrue: [^ self at: i].
        ^ errorBlock value
!

valueForKey: aMagnitude ifPresent: aBlock
        ^ aBlock value: (self valueForKey: aMagnitude ifAbsent: [nil])
! !

!BTree::BTreeLeafNode methodsFor:'queries'!

depth
	^ 1
!

isLeaf
	^ true
! !

!BTree::BTreeStringKeys class methodsFor:'as yet unclassified'!

new
	^ self new: 8
!

new: aNumber
	^ self basicNew initializeWithSize: aNumber
! !

!BTree::BTreeStringKeys class methodsFor:'documentation'!

documentation
"
    [author:]
        Avi Bryant

    [license:]
        Dual licensed under both SqueakL and MIT. 
        This enables both base Squeak inclusion and 100% reuse.
"
! !

!BTree::BTreeStringKeys methodsFor:'as yet unclassified'!

abbreviationSize
	^ 3
!

abbreviationsAndIndicesDo: aBlock
	| stream |
	stream _ abbreviations readStream.
	1 to: self size do:
		[:i |
		stream atEnd
			ifFalse: [aBlock value: prefix, (stream next: self abbreviationSize) value: i]
			ifTrue: [aBlock value: nil value: i]]
!

at: aNumber
	^ keys at: aNumber
!

at: aNumber put: aString
	keys at: aNumber put: aString.
	prefix _ self nilPrefix.
!

buildAbbreviationsFrom: readStreams
	| nextChars |
	1 to: self abbreviationSize do:
		[:i |
		nextChars _ readStreams collect: [:ea | ea next ifNil: [Character value: 0]].
		nextChars withIndexDo:
			[:c :j |
			abbreviations at: (j-1 * self abbreviationSize) + i put: c]].
	^ abbreviations
!

extractPrefixFrom: readStreams
        | prefixStream nextChars |
        prefixStream := '' writeStream.
        
        [readStreams anySatisfy: [:ea | ea atEnd]] whileFalse:
                [nextChars _ readStreams collect: [:ea | ea next].
                (nextChars conform: [:ea | ea = nextChars first])
                                ifTrue: [prefixStream nextPut: nextChars first]
                                ifFalse: [readStreams do: [:ea | ea skip: -1]. ^ prefixStream contents]].
        ^ prefixStream contents
!

findIndexForKey: aString
        | stream str diff |
        prefix = self nilPrefix ifTrue: [self rebuildAbbreviations].
        stream _ aString readStream.
        str _ stream nextAvailable: prefix size + self abbreviationSize. 
        diff _ prefix size + self abbreviationSize - str size.
        str _ str, (String new: diff).
        self abbreviationsAndIndicesDo:
                [:abbr :i |
                abbr isNil ifTrue: [^ i - 1].
                str < abbr ifTrue: [^ i - 1].
                str = abbr ifTrue: [^ super findIndexForKey: aString]].
        ^ self size

    "Modified: / 18-11-2011 / 14:30:07 / cg"
!

initializeWithSize: aNumber
	keys _ Array new: aNumber.
	prefix _ self nilPrefix.
!

nilPrefix
	^ '^^^'
!

rebuildAbbreviations
	| keyStreams filled |
	filled _ keys count: [:ea | ea notNil].
	abbreviations _ String new: (filled * self abbreviationSize).
	filled = 0 ifTrue: [prefix _ ''. ^ self ].
	keyStreams _ (1 to: filled) collect: [:i | (keys at: i) readStream].
	
	prefix _ self extractPrefixFrom: keyStreams.
	abbreviations _ self buildAbbreviationsFrom: keyStreams.
!

size
	^ keys size
! !

!BTree class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

