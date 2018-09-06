"{ Package: 'stx:libdb/nosql/minneStore' }"

"{ NameSpace: Minnestore }"

MinneStore subclass:#MSTreeHolder
	instanceVariableNames:'name getter setter path domain owner indexTree
		indexTreePersistence maximumLeavesPerBranch lastLeafValueFound
		indexTreeChanges persistenceCreationMethod unused1 unused2
		unused3'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-MinneStore'
!


!MSTreeHolder class methodsFor:'As yet unclassified'!

Comment

^'

Instances of this class hold an index tree for Smalltalk objects.  Think of 

this index tree as an index on a column in a relational table.

        

Each table row represents an object instance.

Each table column represents an aspect or attribute of that object.



Index tree locking strategy:

1) IndexTree (Trunks & Branches) are stored together in one file.  

    Each Leaves collection is stored in its own file.

2) The tree is not usually locked when updating leaves.

    Assume only the leaves need updating.

3) If #DOInvalidVersionError is signaled when saving the leaves, then... (see MSBranch>>addLeaf:id:)

	a) If the leaves were deleted, lock indexTree, read it, and redo every leaf add since last commit.

	    (deleted leaves mean that a branch has been split into a trunk by someone else).

	b) If leaves just changed, reload leaves and add.

'
!

Copyright

	"Copyright (c) 1997,1998  Jonathan A. Carlson."

!

newOn: aPathName owner: anMSObjectSet

    "Public - Answer a new instance of myself with path

    set to aString."



    ^(self basicNew)

		path: aPathName;

		owner: anMSObjectSet;

		maximumLeavesPerBranch: anMSObjectSet maximumLeavesPerBranch;

		initialize;

		yourself.
!

test



	| path tmp |

	path := 'C:\JUNK'.

	DOService initializeTestPath: path.

	tmp := (self newOn: path)

		addValue: 'Hi' id: 5;

		addValue: 'bye' id: 9;

		addValue: 'cu' id: 10;

		addValue: 'pow-wow' id: 11;

		addValue: 'jon' id: 31;

		addValue: 'deb' id: 32;

		addValue: 'kris' id: 28;

		addValue: 'paul' id: 60;

		addValue: 'rosalie' id: 54;

		yourself.

	^tmp
! !

!MSTreeHolder methodsFor:'As yet unclassified'!

addRedoBlock: aBlock



	indexTreeChanges ~= nil

		ifTrue: [indexTreeChanges add: aBlock].
!

addValue: aValue

id: anInteger

	"Public - Record this change and execute it."



	self addRedoBlock: [self privateAddValue: aValue id: anInteger].

	self privateAddValue: aValue id: anInteger.
!

allValues

	"Answer all of the values that I index."



	^self indexTree allValues
!

allValuesFor: idCollection

	"Answer all of the values that I index."



	^self indexTree allValuesFor: idCollection asSet 
!

atMSText: aString remove: anId

    "Private -"



	FlavorCompatibility needsWork.

	aString asMSText wordsDo: 

		[ :eachWord | self removeValue: eachWord asLowercase id: anId ].
!

beforeStoring



	indexTree := nil.
!

beginTransaction



	indexTreePersistence beginTransaction.

	self indexTree beginTransaction.

	indexTreeChanges == nil

		ifTrue: [indexTreeChanges := OrderedCollection new].
!

between: anObject1 and: anObject2

    "Public - Answer a collection of ids that have values between

    anObject1 and anObject2 (inclusive)."



    | result anOC object1 object2 |

    anObject1 isNil ifTrue: [ object1 := MSNilValue new]

	ifFalse: [ object1 := anObject1 ].

    anObject2 isNil ifTrue: [ object2 := MSNilValue new]

	ifFalse: [ object2 := anObject2 ].

    anOC := OrderedCollection new.

    object1 > object2 ifTrue: [ ^anOC ].

    result := self leafGreaterThanOrEqualTo: object1.

    [ result isNil or: [result value > object2] ] whileFalse: [

	anOC addAll: result ids.

	result := self nextLeaf.].

    ^anOC.
!

commitTransaction



	self indexTree commitTransaction.

	indexTree clearParent.

	indexTreePersistence commitTransaction.

	indexTree parent: self.

	indexTreeChanges := nil.
!

domain: aClass

    "Private - Setter.  A Domain must respond to the method #lowValue."



	domain := aClass.
!

equals: aValue

	"Public -    Answer a collection of object ids that have this key value."



	| leaf value ids anOC |

	aValue isCollectionOtherThanString

		ifTrue:

			[anOC := OrderedCollection new.

			aValue do:[:each | anOC addAll: (self equals: each)].

			^anOC].

	aValue isNil

		ifTrue: [value := MSNilValue new]

		ifFalse: [value := aValue].

	leaf := self indexTree leafEqualTo: value.

	ids := (leaf == nil

		ifTrue: [OrderedCollection new]

		ifFalse: [leaf ids asOrderedCollection]).

	lastLeafValueFound := "Set the last leaf value found instance variable."

		(leaf == nil

			ifTrue: [nil]

			ifFalse: [leaf value]).

	^ids.
!

firstLeaf

	"Answer the first (lowest value) leaf in my indexTree."



	| leaf |

	leaf := self indexTree firstLeaf.

	lastLeafValueFound :=

		(leaf == nil

			ifTrue: [nil]

			ifFalse: [leaf value]).

	^leaf.
!

getter

    "Answer the getter method to use to get the value used in this index."



    ^getter
!

getter: aSymbol

    "Public - set the getter method that answers the value used by this index."



    getter := aSymbol
!

greaterThan: anObject

	"Public - Answer a collection of ids that have key values

    greater than anObject."



	| result anOC object |

	anObject isNil

		ifTrue: [object := MSNilValue new]

		ifFalse: [object := anObject].

	result := self leafGreaterThan: object.

	anOC := OrderedCollection new.

	[result isNil]

		whileFalse:

			[anOC addAll: result ids.

			result := self nextLeaf.

			].

	^anOC.
!

greaterThanOrEqualTo: anObject

	"Public - Answer a collection of ids that have key values

    greater than or equal to anObject."



	| result anOC object |

	anObject isNil

		ifTrue: [object := MSNilValue new]

		ifFalse: [object := anObject].

	result := self leafGreaterThanOrEqualTo: object.

	anOC := OrderedCollection new.

	[result isNil]

		whileFalse:

			[anOC addAll: result ids.

			result := self nextLeaf.

			].

	^anOC.
!

hasAllWords: aStringOrArrayOfStrings

    "Public - Answer a collection of ids that have all the words in anArrayOfStrings."



    | mainColl subColl arrayOfStrings |

    (domain == MSText or: [MSText subclasses includes: domain])

	ifFalse: [self error: 'Use #where:hasAllWords: method only on an MSText index'].

    ((FlavorCompatibility isString: aStringOrArrayOfStrings) or: [aStringOrArrayOfStrings isMSText])

	ifTrue: [arrayOfStrings := aStringOrArrayOfStrings asMSText words]

	ifFalse: [arrayOfStrings := aStringOrArrayOfStrings].

    (FlavorCompatibility isCollection: arrayOfStrings)

	ifFalse: [^self error: 'Invalid collection parameter: ' , arrayOfStrings printString].

    mainColl := OrderedCollection new.

    arrayOfStrings

	do:

	    [:eachWord |

	    (FlavorCompatibility isString: eachWord)

		ifFalse: [^self error: 'Invalid String parameter: ' , eachWord printString].

	    mainColl isEmpty "true on first time thru"

		ifTrue:

		    [subColl := mainColl := self startsWith: eachWord asLowercase]

		ifFalse:

		    [subColl := self startsWith: eachWord asLowercase.

		    mainColl := mainColl intersectionOf: subColl].

	    mainColl isEmpty

		ifTrue: [^mainColl].

	    ].

    ^mainColl.
!

hasSomeWords: aStringOrArrayOfStrings

    "Public - Answer a collection of ids that have at least one of the

    words in aStringOrArrayOfStrings.  Ids will be sorted by descending

    number of words matched."



    | bag result numWordsFound max arrayOfStrings |

    (domain == MSText or: [MSText subclasses includes: domain])

	ifFalse: [self error: 'Use #where:hasSomeWords: method only on an MSText index'].

    ((FlavorCompatibility isString: aStringOrArrayOfStrings) or: [aStringOrArrayOfStrings isMSText])

	ifTrue: [arrayOfStrings := aStringOrArrayOfStrings asMSText words] "change string to an array of words"

	ifFalse: [arrayOfStrings := aStringOrArrayOfStrings].

    (FlavorCompatibility isCollection: arrayOfStrings)

	ifFalse: [^self error: 'Invalid collection parameter: ' , arrayOfStrings printString].

    bag := Bag new.

    numWordsFound := 0.

    arrayOfStrings

	do:

	    [:eachWord |

	    (FlavorCompatibility isString: eachWord)

		ifFalse: [^self error: 'Invalid String parameter: ' , eachWord printString].

	    (result := self startsWith: eachWord asLowercase) isEmpty

		ifFalse:

		    [numWordsFound := numWordsFound + 1.

		    bag addAll: result.

		    ].

	    ].

    ^bag asArrayByDescendingOccurrences.
!

includes: aString

    "Public - Answer a collection of ids that have values including aString.

    The whole index must be searched to find these."



    | result anOC |

    (domain == String or: [ String subclasses includes: domain ])

	ifFalse: [self error: 'Use #where:includes: method only on a string index' ].

    (FlavorCompatibility isString: aString) ifFalse: [ ^self error: 'Invalid string parameter:', aString printString ].

    result := self firstLeaf.

    anOC := OrderedCollection new.

    [ result isNil ] whileFalse: [

	(result value indexOfString: aString) > 0

	    ifTrue: [ anOC addAll: result ids ].

	result := self nextLeaf.].

    ^anOC.
!

indexTree



	indexTree == nil

		ifTrue: [self readIndexTree].

	^indexTree.
!

indexTree: aTreeHolderOrBranch



	indexTree := aTreeHolderOrBranch.

!

initialize

	"Initialize my instance variables."



	indexTree := MSBranch newOn: path parent: self.

	indexTreePersistence := DOSingleObjectService perform: self persistenceCreationMethod with: (path, self persistenceTreeFileName).

	self saveIndexTree.
!

isMSTreeHolder



	^true
!

leafGreaterThan: anObject

    "Private - Answer an MSLeaf greater than anObject.  

	If none is found, answer nil."



	| leaf |

	leaf := self indexTree leafGreaterThan: anObject.

	lastLeafValueFound :=

		(leaf == nil

			ifTrue: [nil]

			ifFalse: [leaf value]).

	^leaf.
!

leafGreaterThanOrEqualTo: anObject

    "Private - Answer an MSLeaf greater than or equal to anObject.      

	If none is found, answer nil."



	| leaf |

	leaf := self indexTree leafGreaterThanOrEqualTo: anObject.

	lastLeafValueFound :=

		(leaf == nil

			ifTrue: [nil]

			ifFalse: [leaf value]).

	^leaf.
!

lessThan: anObject

    "Public - Answer a collection of ids that have values

    greater than anObject."



    | result anOC object |

    anObject isNil ifTrue: [ ^Array new ]. "Nothing less than nil"

    result := self firstLeaf.

    anOC := OrderedCollection new.

    [ result isNil ] whileFalse: [

	result value >= anObject ifTrue: [ ^anOC ].

	anOC addAll: result ids.

	result := self nextLeaf.].

    ^anOC.
!

lessThanOrEqualTo: anObject

    "Public - Answer a collection of ids that have key values

    greater than anObject."



    | result anOC |

    anObject isNil ifTrue: [ ^self equals: nil ].  "Nothing is less than nil"

    result := self firstLeaf.

    anOC := OrderedCollection new.

    [ result isNil ] whileFalse: [

	result value > anObject ifTrue: [ ^anOC ].

	anOC addAll: result ids.

	result := self nextLeaf.].

    ^anOC.
!

maximumLeavesPerBranch



	^maximumLeavesPerBranch
!

maximumLeavesPerBranch: anInteger

	"Set the maximum number of leaves allowed in a single branch before splitting.

	Push this info down to the branches."



	maximumLeavesPerBranch := anInteger.
!

name

    "Answer the name of the index I hold."



    ^name
!

name: aSymbol

    "Public - setter"



    name := aSymbol.
!

newPath: aString

	"Used when a database has been opened in a new directory."



	self path: aString.

	indexTreePersistence pathName: path.

FlavorCompatibility testing.    FlavorCompatibility assert: (indexTree isNil).

	indexTree := indexTreePersistence readForUpdate.

	indexTree parent: self.

	indexTree newPath: aString.

	self saveIndexTree.
!

nextLeaf

	"Answer the next leaf after the last leaf found."



	lastLeafValueFound == nil

		ifTrue: [^nil].

	^self leafGreaterThan: lastLeafValueFound.

	
!

owner: anMSObjectSet



	owner := anMSObjectSet
!

path

	"Answer my path name."



	^path
!

path: aString

	"Set the path instance variable."



	path := (aString last = FlavorCompatibility directoryDelimiter)

		ifTrue: [aString]

		ifFalse: [aString , FlavorCompatibility directoryDelimiterString].

	
!

persistenceCreationMethod



	persistenceCreationMethod == nil

		ifTrue: [persistenceCreationMethod := owner persistenceCreationMethod].

	^persistenceCreationMethod.
!

persistenceTreeFileName



	^'Tree.obj'.
!

printOn: aStream



    super printOn: aStream.

    aStream

	nextPut: $( ;

	print: self name ;

	nextPut: $) .
!

private2AddValue: aValue

id: anInteger

	"Private - This method is used by privateAddValue:id:"



	ExceptionCompatibility

		on: #MSBranchAboutToMorph

		during: [^self indexTree addLeafValue: aValue id: anInteger]

		do: 

			[:exception |

			ExceptionCompatibility

				on: #DOInvalidVersionError

				during: [indexTreePersistence lock: indexTree]

				do: [ :error | self reapplyChanges.  ExceptionCompatibility return: error].

			ExceptionCompatibility resume: exception. "The locking was successful"

			]
!

private2RemoveValue: aValue

id: anInteger

	"Private - pass this message on to my indexTree."



	^self indexTree removeLeafValue: aValue id: anInteger.
!

privateAddValue: aValue

id: anInteger

	"Private - Do some MSText testing and call private2AddValue:id:"



	| value |

	aValue isNil

		ifTrue:

			[value := MSNilValue new]

		ifFalse:

			[value := aValue.

			domain == MSText

				ifTrue:

					[^value asMSText

						wordsDo:

							[:each | self private2AddValue: each id: anInteger].].

			].

	self private2AddValue: value id: anInteger.

	
!

privateRemoveValue: aValue

id: anInteger

	"Private - Do some MSText testing and call private2RemoveValue:id:"



	| value |

	aValue isNil

		ifTrue: [value := MSNilValue new]

		ifFalse:

			[value := aValue.

			domain == MSText

				ifTrue:

					[^value asMSText

						wordsDo:

							[:each | self private2RemoveValue: each id: anInteger].].

			].

	^self private2RemoveValue: value id: anInteger.
!

readIndexTree



	indexTree := indexTreePersistence read.

	indexTree parent: self.
!

reapplyChanges

	"Re-read my index and reapply all the changes since the beginning of the transaction."

	"Assumption: This will be a read for update because we'll be inside a transaction."



	self readIndexTree.

	indexTreeChanges

		do: [:each | each value].
!

removeValue: aValue id: anInteger

	"Public - pass this message on to my indexTree."

        

	| value |

"       value := aValue isNil ifTrue: [MSNilValue new] ifFalse: [aValue].  line added 1998-02-17"

	self addRedoBlock: [self privateRemoveValue: aValue id: anInteger].

	self privateRemoveValue: aValue id: anInteger.
!

replace: aBranch with: aTrunk

	"Used by anMSBranch when it morphs into a trunk"



	indexTree := aTrunk
!

rollbackTransaction



	self indexTree rollbackTransaction.

	indexTreePersistence rollbackTransaction.

	indexTreeChanges := nil.
!

saveIndexTree

	"Save my index tree to disk."



	indexTree beforeStoring.

	indexTreePersistence specialStore: indexTree.

	indexTree parent: self.
!

setter

    "Answer the setter method to use to get the value used in this index."



    ^setter
!

setter: aSymbol

    "Public - set the setter method that answers the value used by this index."



    setter := aSymbol
!

startsWith: aString

    "Public - Answer a collection of ids that have values starting with aString."



    | result anOC |

    (domain == String or: [ domain == MSText ])

	ifFalse: [ self error: 'Use #where:startsWith: method only on a string index' ].

    (FlavorCompatibility isString: aString) ifFalse: [ ^self error: 'Invalid string parameter:', aString printString ].

    result := self leafGreaterThanOrEqualTo: aString.

    anOC := OrderedCollection new.

    [ result isNil ] whileFalse: [

	(result value startsWith: aString)

	    ifTrue: [ anOC addAll: result ids ]

	    ifFalse: [ ^anOC ].

	result := self nextLeaf.].

    ^anOC.
! !

!MSTreeHolder class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/minneStore/MSTreeHolder.st,v 1.3 2014-02-17 21:19:29 cg Exp $'
! !
