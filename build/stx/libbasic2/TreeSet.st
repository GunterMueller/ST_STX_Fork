"{ Package: 'stx:libbasic2' }"

"{ NameSpace: Smalltalk }"

Collection subclass:#TreeSet
	instanceVariableNames:'tree sortKey'
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Ordered-Trees'
!

!TreeSet class methodsFor:'documentation'!

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

    [author:]
        Avi Bryant

    [license:]
        Dual licensed under both SqueakL and MIT.
        This enables both base Squeak inclusion and 100% reuse.
"
! !

!TreeSet class methodsFor:'instance creation'!

keys: aBtreeKeys sortSelector: aSymbol
	^ self basicNew initializeWithKeys: aBtreeKeys sortSelector: aSymbol
!

new
	^ self sortBy: #hash
!

sortBy: aSymbol
	^ self keys: (BTreeKeysArray new: 64) sortSelector: aSymbol
! !

!TreeSet methodsFor:'initialize-release'!

initializeWithKeys: aBtreeKeys sortSelector: aSymbol
	tree _ BTree keys: aBtreeKeys.
	sortKey _ aSymbol
! !

!TreeSet methodsFor:'plugs'!

keyForValue: anObject
	^ anObject perform: sortKey
!

value: anObject matches: otherObject
	^ anObject = otherObject
! !

!TreeSet methodsFor:'private'!

bucket: anArray includes: anObject
	^ anArray anySatisfy: [:ea | (self value: anObject matches: ea)]
!

tree
	^ tree
! !

!TreeSet methodsFor:'public'!

add: anObject
	| key bucket |
	key _ self keyForValue: anObject.
	bucket _ tree at: key ifAbsent: [#()].
	(self bucket: bucket includes: anObject) ifFalse:
		[tree at: key put: (bucket copyWith: anObject)].
!

do: aBlock
	tree do: [:bucket | bucket do: aBlock]
!

includes: anObject
	| bucket |
	bucket _  tree at: (self keyForValue: anObject) ifAbsent: [^ false].
	^ self bucket: bucket includes: anObject
!

intersect:aCollection 
    aCollection species ~~ self species ifTrue:[
        ^ super intersect:aCollection
    ].
    aCollection sortSelector ~= self sortSelector ifTrue:[
        ^ super intersect:aCollection
    ].
    ^ Array 
        streamContents:[:s | 
            tree commonKeysWith:aCollection tree
                keysAndValuesDo:[:key :left :right | s nextPutAll:(left intersect:right)]
        ]

    "Created: / 20-01-2017 / 19:23:01 / stefan"
!

remove: anObject
    "remove all occurrences of anObject
     Warning:
        This is inconsistent with the inherited collection>>remove:,
        which only remove the first occurrence.
        Should this be fixed?"

    | key bucket |

    key := self keyForValue: anObject.
    bucket := tree at: key ifAbsent: [^ self].
    (self bucket: bucket includes: anObject) ifTrue:[
        "/ cg: wrong code here: removes all, not only the first match
        bucket := bucket reject: [:ea | self value: anObject matches: ea].
        bucket isEmpty
                ifTrue: [tree removeKey: key]
                ifFalse: [tree at: key put: bucket]
    ]
!

sortSelector
	^ sortKey
! !

!TreeSet methodsFor:'testing'!

isFixedSize
    "return true if the receiver cannot grow"

    ^ false
! !

!TreeSet class methodsFor:'documentation'!

version_CVS
    ^ '$Header$'
! !

