"{ Package: 'stx:goodies/petitparser/islands' }"!

!PPChoiceParser methodsFor:'*petitislands'!

acceptsEpsilonOpenSet: set
	set add: self.
	^ self children anySatisfy: [:e | e acceptsEpsilonOpenSet: set ].
! !

!PPContext methodsFor:'*petitislands'!

waterPosition
	^ self globalAt:  #waterPosition ifAbsentPut: [ nil ]
! !

!PPContext methodsFor:'*petitislands'!

waterPosition: position
	^ self globalAt:  #waterPosition put: position
! !

!PPDelegateParser methodsFor:'*petitislands'!

acceptsEpsilon
	^ parser acceptsEpsilonOpenSet: (IdentitySet with: self).
! !

!PPDelegateParser methodsFor:'*petitislands'!

acceptsEpsilonOpenSet: set
	(set includes: parser) ifFalse: [ 
		set add: parser.
		^ parser acceptsEpsilonOpenSet: set 
	].
	^ false
! !

!PPEpsilonParser methodsFor:'*petitislands'!

acceptsEpsilon
	^ true
! !

!PPListParser methodsFor:'*petitislands'!

acceptsEpsilon
	^ self acceptsEpsilonOpenSet: IdentitySet new.
! !

!PPLiteralParser methodsFor:'*petitislands'!

acceptsEpsilon
	^ false
! !

!PPOptionalParser methodsFor:'*petitislands'!

acceptsEpsilon
	^ true
! !

!PPOptionalParser methodsFor:'*petitislands'!

acceptsEpsilonOpenSet: set
	^ true
! !

!PPParser methodsFor:'*petitislands'!

acceptsEpsilon
	"return true, if parser can accept epsilon without failure"
	^ self subclassResponsibility
! !

!PPParser methodsFor:'*petitislands'!

acceptsEpsilonOpenSet: set
	"private helper for acceptsEmpsilon that makes sure to avoid cycles (using open set)"
	self children isEmpty ifTrue: [ ^ self acceptsEpsilon ].
	
	self shouldBeImplemented .
! !

!PPParser methodsFor:'*petitislands'!

island
	^ PPIsland new
		island: self;
		yourself;
		memoized
! !

!PPParser methodsFor:'*petitislands'!

island: water
	^ PPIsland new
		island: self;
		water: water;
		yourself;
		memoized
! !

!PPParser methodsFor:'*petitislands'!

nextSets
	| nextSets |
	
	nextSets := IdentityDictionary new.
	self allParsersDo: [ :each | nextSets at: each put: IdentitySet new ].
	
	(nextSets at: self) add: PPSentinel instance.
	
	[ 	| changed |
		changed := false.
	
		nextSets keysAndValuesDo: [:parser :next |
			changed := (parser 
				nextSets: nextSets
				into: next) or: [ changed ].
		].
		changed ] whileTrue.
	
	^ nextSets
! !

!PPParser methodsFor:'*petitislands'!

nextSets: aNextDictionary into: aSet
	"return true/false, if something has changed or not...."
	| childSet change tally |
	
	change := false.

	self children do: [:each | 
		childSet := aNextDictionary at: each.
		tally := childSet size.
		childSet addAll: aSet.
		change := change or: [ tally ~= childSet size ].
	].

	^ change
	
! !

!PPPredicateParser methodsFor:'*petitislands'!

acceptsEpsilon
	^ false
! !

!PPRepeatingParser methodsFor:'*petitislands'!

nextSets: aNextDictionary into: aSet
	| tally childSet change |

	change := super nextSets: aNextDictionary  into: aSet.

	childSet := aNextDictionary at: parser.
	tally := aSet size.
	childSet add: parser.
	^ change or: [ tally ~= aSet size ].
! !

!PPSequenceParser methodsFor:'*petitislands'!

acceptsEpsilonOpenSet: set
	set add: self.
	^ self children allSatisfy: [:e | e acceptsEpsilonOpenSet: set ]
! !

!PPSequenceParser methodsFor:'*petitislands'!

nextSets: aNextDictionary into: aSet
	
	| nextSet eachNextSet change tally |
	nextSet := aSet copy.
	
	change := false.
	
	self children reverseDo: [:each |
		eachNextSet := aNextDictionary at: each.	
		tally := eachNextSet size.
		eachNextSet addAll: nextSet.
		change := change or: [ tally ~= eachNextSet size ].
		
		each acceptsEpsilon ifTrue: [
			nextSet add: each.
		] ifFalse: [
			nextSet := IdentitySet with: each.
		].
	].

	^ change
! !

!stx_goodies_petitparser_islands class methodsFor:'documentation'!

extensionsVersion_HG

    ^ '$Changeset: <not expanded> $'
! !
