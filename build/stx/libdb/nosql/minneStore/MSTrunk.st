"{ Package: 'stx:libdb/nosql/minneStore' }"

"{ NameSpace: Minnestore }"

MinneStore subclass:#MSTrunk
	instanceVariableNames:'leftTrunkOrBranch rightTrunkOrBranch maximumValue parent unused1
		unused2 unused3'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-MinneStore'
!


!MSTrunk class methodsFor:'As yet unclassified'!

Comment

"

	Trunks hold Trunks and Branches.

	Branches hold Leaves.

"
!

Copyright

	"Copyright (c) 1997,1998  Jonathan A. Carlson."

!

newOn: anMSBranch parent: aTreeHolderOrTrunk

	"Answer a new instance of myself with aBranch split between my right and left branches."



	^self new

		left: anMSBranch asLeftBranch

		right: anMSBranch asRightBranch

		parent: aTreeHolderOrTrunk
! !

!MSTrunk methodsFor:'As yet unclassified'!

addLeafValue: anObject id: anInteger

	"Add a leaf value/id to my trunks or branches."



	leftTrunkOrBranch maximumValue >= anObject

		ifTrue: [leftTrunkOrBranch addLeafValue: anObject id: anInteger]

		ifFalse: [rightTrunkOrBranch addLeafValue: anObject id: anInteger]
!

addLeavesTo: aCollection



	leftTrunkOrBranch addLeavesTo: aCollection.

	rightTrunkOrBranch addLeavesTo: aCollection.

	^aCollection
!

addValuesFor: idSet to: aCollection

	"Add the values of all leaves that have an id in idSet to aCollection"



	leftTrunkOrBranch addValuesFor: idSet to: aCollection.

	rightTrunkOrBranch addValuesFor: idSet to: aCollection.

	^aCollection.
!

addValuesTo: aCollection

	"Add all leaf values to aCollection"



	leftTrunkOrBranch addValuesTo: aCollection.

	rightTrunkOrBranch addValuesTo: aCollection.

	^aCollection.
!

allLeaves

	"This is only used for testing right now."



	^self addLeavesTo: (OrderedCollection new).
!

allValues

	"Answer all of the values that I index."



	^self addValuesTo: (OrderedCollection new)

!

allValuesFor: idSet

	"Answer all of the values that I index for the object ids in the list."



	^self addValuesFor: idSet to: OrderedCollection new.
!

beforeStoring



	parent isMSTreeHolder

		ifTrue: [self clearParent].  "logic moved to MSTreeHolder>>commitTransaction"

	leftTrunkOrBranch beforeStoring.

	rightTrunkOrBranch beforeStoring.
!

beginTransaction

	"Only do this to the first branch because all branches share the same leaf DOManager."



	self firstBranch beginTransaction.

	
!

clearParent



	self parent: nil.
!

commitTransaction

	"Only do this to the first branch because all branches share the same leaf DOManager."



	self firstBranch commitTransaction.

	
!

firstBranch

	"Answer the first branch in my tree."



	^leftTrunkOrBranch firstBranch.
!

firstLeaf

	"Answer the very first (lowest value) leaf that I hold."



	^leftTrunkOrBranch isEmpty

		ifTrue: [rightTrunkOrBranch firstLeaf]

		ifFalse: [leftTrunkOrBranch firstLeaf].
!

isEmpty

	"Answer true or false.  If both left and right trunk/branches are empty, answer true."



	^leftTrunkOrBranch isEmpty and: [rightTrunkOrBranch isEmpty]
!

leafEqualTo: anObject

        "Answer a leaf that is = an Object."

        |compare|

"/        Smalltalk isSmalltalkX ifTrue:[
"/            anObject isMSNilValue ifTrue:[
"/                compare := leftTrunkOrBranch maximumValue isNil
"/                           or:[leftTrunkOrBranch maximumValue isMSNilValue].
"/            ] ifFalse:[
"/                compare := leftTrunkOrBranch maximumValue >= anObject.
"/            ].
"/            ^compare
"/                    ifTrue: [leftTrunkOrBranch leafEqualTo: anObject]
"/                    ifFalse: [rightTrunkOrBranch leafEqualTo: anObject]
"/        ].

        ^leftTrunkOrBranch maximumValue >= anObject

                ifTrue: [leftTrunkOrBranch leafEqualTo: anObject]

                ifFalse: [rightTrunkOrBranch leafEqualTo: anObject]
!

leafGreaterThan: anObject

        "Answer a leaf that is > an Object."


        Smalltalk isSmalltalkX ifTrue:[
            (leftTrunkOrBranch maximumValue isString or:[anObject isString]) ifTrue:[
                (leftTrunkOrBranch maximumValue compareCaselessWith: anObject) > 0
                        ifTrue:
                                [leftTrunkOrBranch isEmpty  "may be empty from removing stuff."
                                        ifFalse: [^leftTrunkOrBranch leafGreaterThan: anObject]].
                ^rightTrunkOrBranch leafGreaterThan: anObject.
            ]
        ].

        leftTrunkOrBranch maximumValue > anObject

                ifTrue:

                        [leftTrunkOrBranch isEmpty  "may be empty from removing stuff."

                                ifFalse: [^leftTrunkOrBranch leafGreaterThan: anObject]].

        ^rightTrunkOrBranch leafGreaterThan: anObject.
!

leafGreaterThanOrEqualTo: anObject

        "Answer a leaf that is >= an Object."


        Smalltalk isSmalltalkX ifTrue:[
            (leftTrunkOrBranch maximumValue isString or:[anObject isString]) ifTrue:[
                (leftTrunkOrBranch maximumValue compareCaselessWith: anObject) >= 0
                        ifTrue: 
                                [leftTrunkOrBranch isEmpty   "may be empty from removing stuff."
                                        ifFalse: [^leftTrunkOrBranch leafGreaterThanOrEqualTo: anObject]].
                ^rightTrunkOrBranch leafGreaterThanOrEqualTo: anObject.
            ]
        ].

        leftTrunkOrBranch maximumValue >= anObject

                ifTrue: 

                        [leftTrunkOrBranch isEmpty   "may be empty from removing stuff."

                                ifFalse: [^leftTrunkOrBranch leafGreaterThanOrEqualTo: anObject]].

        ^rightTrunkOrBranch leafGreaterThanOrEqualTo: anObject.
!

left: leftBranch

right: rightBranch

parent: aTreeHolderOrTrunk

	"Set my left and right branches."



	leftTrunkOrBranch := (leftBranch parent: self).

	rightTrunkOrBranch := (rightBranch parent: self).

	parent := aTreeHolderOrTrunk.
!

maximumLeavesPerBranch: anInteger

	"Set the maximum number of leaves allowed in a single branch before splitting.

	Push this info down to the branches."



	leftTrunkOrBranch maximumLeavesPerBranch: anInteger.

	rightTrunkOrBranch maximumLeavesPerBranch: anInteger.
!

maximumValue

	"Instance variable getter.  If nil, set to max value of my right trunk or branch."



	maximumValue == nil

		ifTrue: [maximumValue := rightTrunkOrBranch maximumValue].

	^maximumValue.
!

newPath: aString



	leftTrunkOrBranch newPath: aString.
!

parent: anMSTreeHolder



	parent := anMSTreeHolder
!

printOn: aStream



	super printOn: aStream.

	aStream

		nextPut: $(;

		nextPutAll: 'maxValue: ';

		print: maximumValue;

		nextPut: $).
!

reapplyChanges

	"Send this message up to my parent."



	^parent reapplyChanges
!

removeLeafValue: anObject id: anInteger

	"Remove this leaf value/id from my branches."



	leftTrunkOrBranch maximumValue >= anObject

		ifTrue: [leftTrunkOrBranch removeLeafValue: anObject id: anInteger]

		ifFalse: [rightTrunkOrBranch removeLeafValue: anObject id: anInteger]
!

replace: aBranch with: aTrunk

	"used when a branch is morphing into a trunk."



	leftTrunkOrBranch == aBranch

		ifTrue: [leftTrunkOrBranch := aTrunk].

	rightTrunkOrBranch == aBranch

		ifTrue: [rightTrunkOrBranch := aTrunk].
!

rollbackTransaction

	"Only do this to the first branch because all branches share the same leaf DOManager."



	self firstBranch rollbackTransaction.

	
!

saveIndexTree

	"Pass this message along to my parent Trunk or TreeHolder."



	parent saveIndexTree
!

saveLeaves

	"Ask (politely) my trunks or branches to save themselves."



	leftTrunkOrBranch saveLeaves.

	rightTrunkOrBranch saveLeaves.
! !

!MSTrunk class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/minneStore/MSTrunk.st,v 1.3 2014-02-17 21:19:29 cg Exp $'
! !
