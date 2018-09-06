"{ Package: 'stx:libdb/nosql/minneStore' }"

"{ NameSpace: Minnestore }"

MinneStore subclass:#MSBranch
	instanceVariableNames:'leaves maximumValue leavesFileId parent maximumLeavesPerBranch
		leafPersistence unused1 unused2 unused3'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-MinneStore'
!


!MSBranch class methodsFor:'As yet unclassified'!

Comment

"

	Branches hold Leaves.

	Branches are held by a Trunk or a TreeHolder..

"
!

Copyright

	"Copyright (c) 1997,1998  Jonathan A. Carlson."

!

constructEventsTriggered

	"Private - answer the set of events that instances of the

	receiver can trigger."

    ^super constructEventsTriggered

		add: #aboutToMorph;

		yourself.
!

newOn: aPathName parent: aTreeHolder

	"This will be used when creating the first branch in a new tree."



	self initializePath: aPathName.

	^self new

		parent: aTreeHolder;

		maximumLeavesPerBranch: aTreeHolder maximumLeavesPerBranch;

		maximumValue: MSHighValue new;

		leafPersistence:

			(DOMultiObjectService newMultiUser

				fileNamePattern: 'INDX9999.OBJ';

				pathName: aPathName;

				yourself);

		yourself.
!

test1



	self testExample.

        

	self testExample allLeaves.

        

	self testExample leafGreaterThanOrEqualTo: 'Renee'.

	
!

testExample

	"Answer a small index tree for testing."



	^(self newOn: 'C:\HI')

		addLeafValue: 'Jonathan' id: 31;

		addLeafValue: 'Debra' id: 32;

		addLeafValue: 'Diane' id: 34;

		addLeafValue: 'Dan' id: 30;

		addLeafValue: 'Doug' id: 35;

		addLeafValue: 'Kristen' id: 28;

		addLeafValue: 'Renee' id: 29;

		addLeafValue: 'Andrea' id: 23;

		addLeafValue: 'Bret' id: 37;

		addLeafValue: 'Craig' id: 29;

		addLeafValue: 'Casper' id: 33;

		addLeafValue: 'Ronald' id: 54;

		addLeafValue: 'David' id: 36;

		yourself.
! !

!MSBranch methodsFor:'As yet unclassified'!

addLeafValue: anObject

id: anInteger

	"Add this leaf value/id combo to my leaves.  This is the only method leaves are to be added with."



	| existingLeaf |

	existingLeaf := self leafEqualTo: anObject.

	(existingLeaf == nil)

		ifTrue:

			[self leaves add: (MSLeaf newValue: anObject id: anInteger).

			(self leaves size >= maximumLeavesPerBranch)

				ifTrue: [^self morphIntoATrunk]]

		ifFalse:

			[existingLeaf addId: anInteger].

	ExceptionCompatibility

	on: #DOInvalidVersionError

	during: [self saveLeaves]

	do:     [:exception |

		(FlavorCompatibility exceptionDetails: exception) isDODeletedObject

			ifTrue: [parent reapplyChanges.  "The indexTree has changed. Start over."]

			ifFalse: 

				[leaves := nil.

				self addLeafValue: anObject id: anInteger].

		ExceptionCompatibility return: exception.

		].
!

addLeavesTo: aCollection

	"Add all my leaves to a collection."



	aCollection addAll: self leaves
!

addValuesFor: idSet to: aCollection

	"Add the values of all leaves that have an id in idSet to aCollection"



	self leaves do:

		[:each |

		(each ids detect: [:eachID | idSet includes: eachID] ifNone: [nil]) notNil

			ifTrue: [aCollection add: (each value isMSNilValue ifTrue: [nil] ifFalse: [each value])].

		].

	^aCollection.
!

addValuesTo: aCollection

	"Add all my leaves to a collection."



	aCollection addAll: 

		(self leaves collect: 

			[:each | each value isMSNilValue ifTrue: [nil] ifFalse: [each value]]

		).
!

asLeftBranch

	"Answer the left half of my leaves."



	| leftLeaves branch |

	leftLeaves := (self leaves copyFrom: 1 to: (leaves size // 2)).

	branch := self class new leaves: leftLeaves.

	branch maximumValue: (leftLeaves last value).

	branch leafPersistence: leafPersistence.

	branch maximumLeavesPerBranch: self maximumLeavesPerBranch.

	^branch
!

asRightBranch

	"Answer the right half of my leaves."



	| rightLeaves branch size |

	size := self leaves size.

	rightLeaves := leaves copyFrom: (size // 2) + 1 to: size.

	branch := self class new leaves: rightLeaves.

	branch maximumValue: maximumValue.

	branch leafPersistence: leafPersistence.

	branch maximumLeavesPerBranch: self maximumLeavesPerBranch.

	^branch
!

beforeStoring

	"Wipe out any reference to my tree holder and leaves."



	parent isMSTreeHolder

		ifTrue: [self clearParent].

	leavesFileId isNil

		ifTrue: [self saveLeaves].

	leaves := nil.
!

beginTransaction

	"Tell leafPersistence to begin the transaction."



	leafPersistence beginTransaction.
!

clearParent



	self parent: nil.
!

commitTransaction

	"Tell leafPersistence to commit the transaction."



	leafPersistence commitTransaction.
!

firstBranch

	"Answer the first branch in my tree."



	^self
!

firstLeaf

	"Answer the very first (lowest value) leaf that I hold."



	self leaves isEmpty

		ifTrue: [^nil].

	^self leaves first
!

gtBinarySearchFor: anObject             "value - can be either string or integer"

between: integer1                               "integer1 must be less than integer2"

and: integer2

	"Private -  Answer a leaf.  Binary search myself for a leaf with the next greater value."



	| mid midValue |

	integer2 < integer1 ifTrue: [ ^nil ].

	(integer2 - integer1) < 2 ifTrue: [

		(self object: anObject isLT: (self leaves at: integer1) value)          "This line is different from #gteBinary..."

			ifTrue: [ ^(leaves at: integer1) ].

		(self object: anObject isGTE: (self leaves at: integer2) value)   "This line is different from #gteBinary..."

			ifTrue: [ ^nil ].  "There are none greater"

		^(self leaves at: integer2) ].

	mid := (integer1 + integer2) // 2.

	(self object: anObject isLT: (midValue := (self leaves at: mid) value))

		ifTrue: [ ^self gtBinarySearchFor: anObject between: integer1 and: mid ].

	(self object: anObject isGTE: midValue)                                                                 "This line is different from #gteBinary..."

		ifTrue: [ ^self gtBinarySearchFor: anObject between: mid+1 and: integer2 ].

	" It matches exactly "

	^(self leaves at: mid).

	
!

gteBinarySearchFor: anObject            "value - can be either string or integer"

between: integer1                               "integer1 must be less than integer2"

and: integer2

	"Private -  Answer a leaf.  Binary search myself for a leaf with the next greater or equal value."



	| mid midValue |

	integer2 < integer1 ifTrue: [ ^nil ].

	(integer2 - integer1) < 2 ifTrue: [

		(self object: anObject isLTE: (self leaves at: integer1) value) "This line is different from #gtBinary..."

			ifTrue: [ ^(leaves at: integer1) ].

		(self object: anObject isGT: (self leaves at: integer2) value)   "This line is different from #gtBinary..."

			ifTrue: [ ^nil ].  "There are none greater"

		^(self leaves at: integer2) ].

	mid := (integer1 + integer2) // 2.

	(self object:anObject isLT: (midValue := (self leaves at: mid) value))

		ifTrue: [ ^self gteBinarySearchFor: anObject between: integer1 and: mid ].

	(self object: anObject isGT: midValue)                          "This line is different from #gtBinary..."

		ifTrue: [ ^self gteBinarySearchFor: anObject between: mid+1 and: integer2 ].

	"It matches exactly"

	^(self leaves at: mid).

	
!

initialize



	leaves := #new.
!

isEmpty

	"Answer true or false.  If I hold no leaves, answer true."



	^self leaves isEmpty
!

leafEqualTo: anObject

	"Answer a leaf that is = an Object."



	| leaf |

	leaf := self 

		gteBinarySearchFor: anObject 

		between: 1 

		and: self leaves size.

	leaf == nil 

		ifTrue: [^nil].

	leaf value = anObject

		ifTrue: [^leaf].

	^nil.
!

leafGreaterThan: anObject

	"Answer a leaf that is > an Object."



	^self 

		gtBinarySearchFor: anObject 

		between: 1 

		and: self leaves size.
!

leafGreaterThanOrEqualTo: anObject

	"Answer a leaf that is >= an Object."



	^self 

		gteBinarySearchFor: anObject 

		between: 1 

		and: self leaves size.
!

leafPersistence: aDOManager

	"Set the leafPersistence instance variable."



	leafPersistence := aDOManager
!

leaves

        "Answer a sorted collection of leaves."



        | deleted |

        deleted := false.

        leaves == #new

                ifTrue: [leaves := SortedCollection new].

        leaves == nil ifTrue: 

                [leaves := leafPersistence readId: leavesFileId.

                leaves isDODeletedObject ifTrue: [ExceptionCompatibility signal: #MSDeletedLeafException]].

        ^leaves
!

leaves: aSortedCollection

	"Set the maximumValue instance variable."



	leaves := aSortedCollection.
!

maximumLeavesPerBranch



	^maximumLeavesPerBranch
!

maximumLeavesPerBranch: anInteger

	"Set the maximum number of leaves allowed in a single branch before splitting."



	maximumLeavesPerBranch := anInteger
!

maximumValue

	"Answer the maximumValue instance variable."



	^maximumValue
!

maximumValue: anObject

	"Set the maximumValue instance variable."



	maximumValue := anObject
!

morphIntoATrunk

	"Morph myself into a trunk with my leaves split between its two branches."



	| trunk |

	ExceptionCompatibility signal: #MSBranchAboutToMorph.

	leavesFileId ~~ nil  "If my leaves have been saved to disk before."

		ifTrue: [leafPersistence delete: leaves. "next comment is wrong." "DOObjectIsDeletedError if leaves have already been been deleted."]

		ifFalse: [FlavorCompatibility testing. self error: 'Oops, I guess this does happen'].

	trunk := (MSTrunk newOn: self parent: parent).

	trunk saveLeaves.

	parent replace: self with: trunk.

	parent saveIndexTree.  "The tree has changed, so store it."
!

newPath: aString

	"Used when a database has been opened in a new directory."



	leafPersistence pathName: aString
!

object: object1 isGT: object2

        "Answer true if object1 is greater than object2.

        I had to implement these methods because most things don't 'compare' with MSNilValue

        while MSNilValue compares with everything."

        Smalltalk isSmalltalkX ifTrue:[
            (object1 isString or:[object2 isString]) ifTrue:[
                ^object1 isMSNilValue
                        ifTrue: [ object1>object2 ]
                        ifFalse: [ (object2 compareCaselessWith:object1) < 0].
            ].
        ].

        ^object1 isMSNilValue

                ifTrue: [object1>object2]

                ifFalse: [object2<object1].
!

object: object1 isGTE: object2

        "Answer true if object1 is greater than or equal to object2.

        I had to implement these methods because most things don't 'compare' with MSNilValue

        while MSNilValue compares with everything."


        Smalltalk isSmalltalkX ifTrue:[
            (object1 isString or:[object2 isString]) ifTrue:[
                ^object1 isMSNilValue
                        ifTrue: [ object1>=object2 ]
                        ifFalse: [ (object2 compareCaselessWith:object1) <= 0].
            ].
        ].

        ^object1 isMSNilValue

                ifTrue: [object1>=object2]

                ifFalse: [object2<=object1].
!

object: object1 isLT: object2

        "Answer true if object1 is less than object2.

        I had to implement these methods because most things don't 'compare' with MSNilValue

        while MSNilValue compares with everything."


        Smalltalk isSmalltalkX ifTrue:[
            (object1 isString or:[object2 isString]) ifTrue:[
                ^object1 isMSNilValue
                        ifTrue: [ object1<object2 ]
                        ifFalse: [ (object2 compareCaselessWith:object1) > 0].
            ].
        ].


        ^object1 isMSNilValue

                ifTrue: [object1<object2]

                ifFalse: [object2>object1].
!

object: object1 isLTE: object2

        "Answer true if object1 is less than or equal to object2.

        I had to implement these methods because most things don't 'compare' with MSNilValue

        while MSNilValue compares with everything."

        Smalltalk isSmalltalkX ifTrue:[
            (object1 isString or:[object2 isString]) ifTrue:[
                ^object1 isMSNilValue
                        ifTrue: [ object1<=object2 ]
                        ifFalse: [ (object2 compareCaselessWith:object1) >= 0].
            ].
        ].

        ^object1 isMSNilValue
                ifTrue: [object1<=object2]
                ifFalse: [object2>=object1].
!

parent: aTreeHolderOrTrunk

	"Set the instance variable."



	parent := aTreeHolderOrTrunk
!

printOn: aStream



	super printOn: aStream.

	aStream

		nextPut: $(;

		nextPutAll: 'maxValue: ';

		print: maximumValue;

		nextPut: $).
!

removeLeafValue: anObject

id: anInteger

	"Add this leaf value/id combo to my leaves.  This is the only method leaves are to be added with."



	| existingLeaf |

	existingLeaf := self leafEqualTo: anObject.

	(existingLeaf == nil)

		ifFalse:

			[existingLeaf removeId: anInteger.

			existingLeaf isEmpty

				ifTrue: [self leaves remove: existingLeaf]].

	ExceptionCompatibility

		on: #DOInvalidVersionError

		during: [self saveLeaves]

		do:     [leaves := nil.

			self removeLeafValue: anObject id: anInteger].

	
!

rollbackTransaction

	"Tell leafPersistence to rollback the transaction."



	leafPersistence rollbackTransaction.
!

saveLeaves

	"Save my leaves to disk."



	leafPersistence store: self leaves.

	leavesFileId == nil

		ifTrue: [leavesFileId := leafPersistence idFor: self leaves].   
! !

!MSBranch class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/minneStore/MSBranch.st,v 1.3 2014-02-17 21:19:29 cg Exp $'
! !
