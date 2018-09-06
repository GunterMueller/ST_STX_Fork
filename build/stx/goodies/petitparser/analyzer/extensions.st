"{ Package: 'stx:goodies/petitparser/analyzer' }"!

!PPActionParser methodsFor:'*petitanalyzer-matching'!

match: aParser inContext: aDictionary seen: anIdentitySet
	^ (super match: aParser inContext: aDictionary seen: anIdentitySet) and: [ self block = aParser block ]
! !

!PPDelegateParser methodsFor:'*petitanalyzer-transforming'!

replace: aParser with: anotherParser
	super replace: aParser with: anotherParser.
	parser == aParser ifTrue: [ parser := anotherParser ]
! !

!PPEpsilonParser methodsFor:'*petitanalyzer-testing'!

isNullable
	^ true
! !

!PPFailingParser methodsFor:'*petitanalyzer-matching'!

match: aParser inContext: aDictionary seen: anIdentitySet
	^ (super match: aParser inContext: aDictionary seen: anIdentitySet) and: [ self message = aParser message ]
! !

!PPLimitedRepeatingParser methodsFor:'*petitanalyzer-transforming'!

replace: aParser with: anotherParser
	super replace: aParser with: anotherParser.
	limit == aParser ifTrue: [ limit := anotherParser ]
! !

!PPListParser methodsFor:'*petitanalyzer-matching'!

copyInContext: aDictionary seen: aSeenDictionary
	| copy copies |
	aSeenDictionary at: self ifPresent: [ :value | ^ value ].
	copy := aSeenDictionary at: self put: self copy.
	copies := OrderedCollection new.
	parsers do: [ :each |
		| result |
		result := each
			copyInContext: aDictionary
			seen: aSeenDictionary.
		result isCollection
			ifTrue: [ copies addAll: result ]
			ifFalse: [ copies add: result ] ].
	^ copy
		setParsers: copies;
		yourself
! !

!PPListParser methodsFor:'*petitanalyzer-transforming'!

replace: aParser with: anotherParser
	super replace: aParser with: anotherParser.
	parsers keysAndValuesDo: [ :index :parser |
		parser == aParser
			ifTrue: [ parsers at: index put: anotherParser ] ]
! !

!PPLiteralParser methodsFor:'*petitanalyzer-matching'!

match: aParser inContext: aDictionary seen: anIdentitySet
	^ (super match: aParser inContext: aDictionary seen: anIdentitySet) and: [ self literal = aParser literal and: [ self message = aParser message ] ]
! !

!PPNotParser methodsFor:'*petitanalyzer-private'!

firstSets: aFirstDictionary into: aSet

! !

!PPNotParser methodsFor:'*petitanalyzer-testing'!

isFirstSetTerminal
	^ true
! !

!PPOptionalParser methodsFor:'*petitanalyzer-testing'!

isNullable
	^ true
! !

!PPParser methodsFor:'*petitanalyzer-named'!

allNamedParsers
	"Answer all the named parse nodes of the receiver."

	| result |
	result := OrderedCollection new.
	self allNamedParsersDo: [ :parser | result addLast: parser ].
	^ result
! !

!PPParser methodsFor:'*petitanalyzer-named'!

allNamedParsersDo: aBlock
	"Iterate over all the named parse nodes of the receiver."

	self allParsersDo: [ :each |
		each name notNil
			ifTrue: [ aBlock value: each ] ]
! !

!PPParser methodsFor:'*petitanalyzer-matching'!

copyInContext: aDictionary
	^ self copyInContext: aDictionary seen: IdentityDictionary new
! !

!PPParser methodsFor:'*petitanalyzer-matching'!

copyInContext: aDictionary seen: aSeenDictionary
	| copy |
	aSeenDictionary
		at: self
		ifPresent: [ :value | ^ value ].
	copy := aSeenDictionary
		at: self
		put: self copy.
	copy children do: [ :each |
		copy
			replace: each
			with: (each copyInContext: aDictionary seen: aSeenDictionary) ].
	^ copy
! !

!PPParser methodsFor:'*petitanalyzer-querying'!

cycleSet
	"Answer a set of all nodes that are within one or more cycles of left-recursion. This is generally not a problem if at least one of the nodes is memoized, but it might make the grammar very inefficient and should be avoided if possible."

	| cycles |
	cycles := IdentitySet new.
	self cycleSet: OrderedCollection new firstSets: self firstSets into: cycles.
	^ cycles
! !

!PPParser methodsFor:'*petitanalyzer-private'!

cycleSet: aDictionary
	"PRIVATE: Answer the children that could be part of a cycle-set with the receiver, subclasses might restrict the number of children returned. aDictionary is pre-calcualted first-sets."

	^ self children
! !

!PPParser methodsFor:'*petitanalyzer-private'!

cycleSet: aStack firstSets: aDictionary into: aSet
	"PRIVATE: Try to find a cycle, where aStack contains the previously visited parsers. The method returns quickly when the receiver is a terminal, terminals cannot be part of a cycle. If aStack already contains the receiver, then we are in a cycle. In this case we don't process the children further and add the nodes to aSet."

	| index |
	self isTerminal
		ifTrue: [ ^ self ].
	(index := aStack indexOf: self) > 0
		ifTrue: [ ^ aSet addAll: (aStack copyFrom: index to: aStack size) ].
	aStack addLast: self.
	(self cycleSet: aDictionary)
		do: [ :each | each cycleSet: aStack firstSets: aDictionary into: aSet ].
	aStack removeLast
! !

!PPParser methodsFor:'*petitanalyzer-querying'!

firstSet
	"Answer the first-set of the receiver. Note, this implementation is inefficient when called on different receivers of the same grammar, instead use #firstSets to calculate the first-sets at once."

	^ self firstSets at: self
! !

!PPParser methodsFor:'*petitanalyzer-querying'!

firstSets
	"Answer a dictionary with all the parsers reachable from the receiver as key and their first-set as value. The first-set of a parser is the list of terminal parsers that begin the parser derivable from that parser."

	| firstSets |
	firstSets := IdentityDictionary new.
	self allParsersDo: [ :each |
		firstSets at: each put: (each isFirstSetTerminal
			ifTrue: [ IdentitySet with: each ]
			ifFalse: [ IdentitySet new ]).
		each isNullable
			ifTrue: [ (firstSets at: each) add: PPSentinel instance ] ].
	[	| changed tally |
		changed := false.
		firstSets keysAndValuesDo: [ :parser :first |
			tally := first size.
			parser firstSets: firstSets into: first.
			changed := changed or: [ tally ~= first size ] ].
		changed ] whileTrue.
	^ firstSets
! !

!PPParser methodsFor:'*petitanalyzer-private'!

firstSets: aFirstDictionary into: aSet
	"PRIVATE: Try to add additional elements to the first-set aSet of the receiver, use the incomplete aFirstDictionary."

	self children do: [ :parser | aSet addAll: (aFirstDictionary at: parser) ]
! !

!PPParser methodsFor:'*petitanalyzer-querying'!

followSet
	"Answer the follow-set of the receiver starting at the receiver. Note, this implementation is inefficient when called on different receivers of the same grammar, instead use #followSets to calculate the follow-sets at once."

	^ self followSets at: self
! !

!PPParser methodsFor:'*petitanalyzer-querying'!

followSets
	"Answer a dictionary with all the parsers reachable from the receiver as key and their follow-set as value. The follow-set of a parser is the list of terminal parsers that can appear immediately to the right of that parser."

	| current previous continue firstSets followSets |
	current := previous := 0.
	firstSets := self firstSets.
	followSets := IdentityDictionary new.
	self allParsersDo: [ :each | followSets at: each put: IdentitySet new ].
	(followSets at: self) add: PPSentinel instance.
	[	followSets keysAndValuesDo: [ :parser :follow |
			parser
				followSets: followSets
				firstSets: firstSets
				into: follow ].
		current := followSets
			inject: 0
			into: [ :result :each | result + each size ].
		continue := previous < current.
		previous := current.
		continue ] whileTrue.
	^ followSets
! !

!PPParser methodsFor:'*petitanalyzer-private'!

followSets: aFollowDictionary firstSets: aFirstDictionary into: aSet
	"PRIVATE: Try to add additional elements to the follow-set aSet of the receiver, use the incomplete aFollowDictionary and the complete aFirstDictionary."

	self children do: [ :parser | (aFollowDictionary at: parser) addAll: aSet ]
! !

!PPParser methodsFor:'*petitanalyzer-named'!

innerChildren
	"Answer the inner children of the receiver."

	| result |
	result := OrderedCollection new.
	self innerChildrenDo: [ :parser | result addLast: parser ].
	^ result
! !

!PPParser methodsFor:'*petitanalyzer-named'!

innerChildrenDo: aBlock
	"Iterate over the inner children of the receiver."

	self innerChildrenDo: aBlock seen: IdentitySet new
! !

!PPParser methodsFor:'*petitanalyzer-named'!

innerChildrenDo: aBlock seen: aSet
	"Iterate over the inner children of the receiver."

	self children do: [ :each |
		(aSet includes: each)
			ifTrue: [ ^ self ].
		aSet add: each.
		each name isNil ifTrue: [
			aBlock value: each.
			each innerChildrenDo: aBlock seen: aSet ] ]
! !

!PPParser methodsFor:'*petitanalyzer-testing'!

isFirstSetTerminal
	"Answer true if the receiver is a terminal or leaf parser, that means it does not delegate to any other parser."

	^ self children isEmpty
! !

!PPParser methodsFor:'*petitanalyzer-testing'!

isNullable
	"Answer true if the receiver is a nullable parser, e.g. it can successfully parse nothing."

	^ false
! !

!PPParser methodsFor:'*petitanalyzer-testing'!

isTerminal
	"Answer true if the receiver is a terminal or leaf parser, that means it does not delegate to any other parser."

	^ self children isEmpty
! !

!PPParser methodsFor:'*petitanalyzer-matching'!

match: aParser inContext: aDictionary
	^ self match: aParser inContext: aDictionary seen: IdentitySet new
! !

!PPParser methodsFor:'*petitanalyzer-matching'!

match: aParser inContext: aDictionary seen: anIdentitySet
	"This is the default implementation to match two parsers. This code can properly handle recursion. This is code is supposed to be overridden in subclasses that add new state."

	(self == aParser or: [ anIdentitySet includes: self ])
		ifTrue: [ ^ true ].
	anIdentitySet add: self.
	^ self class = aParser class and: [ self matchList: self children against: aParser children inContext: aDictionary seen: anIdentitySet ]
! !

!PPParser methodsFor:'*petitanalyzer-matching'!

matchList: matchList against: parserList inContext: aDictionary seen: aSet
	^ self matchList: matchList index: 1 against: parserList index: 1 inContext: aDictionary seen: aSet
! !

!PPParser methodsFor:'*petitanalyzer-matching'!

matchList: matchList index: matchIndex against: parserList index: parserIndex inContext: aDictionary seen: aSet
	| parser currentIndex currentDictionary currentSeen parsers |
	matchList size < matchIndex
		ifTrue: [ ^ parserList size < parserIndex ].
	parser := matchList at: matchIndex.
	parser class = PPListPattern ifTrue: [
		currentIndex := parserIndex - 1.
		[ currentDictionary := aDictionary copy.
		currentSeen := aSet copy.
		parserList size < currentIndex or: [
			parsers := parserList copyFrom: parserIndex to: currentIndex.
			(currentDictionary at: parser ifAbsentPut: [ parsers ]) = parsers and: [
				(self
					matchList: matchList
					index: matchIndex + 1
					against: parserList
					index: currentIndex + 1
					inContext: currentDictionary
					seen: currentSeen)
					ifTrue: [
						currentDictionary keysAndValuesDo: [ :key :value | aDictionary at: key put: value ].
						^ true ].
				false ] ] ] whileFalse: [ currentIndex := currentIndex + 1 ].
		^ false ].
	parserList size < parserIndex
		ifTrue: [ ^ false ].
	(parser match: (parserList at: parserIndex) inContext: aDictionary seen: aSet)
		ifFalse: [ ^ false ].
	^ self
		matchList: matchList
		index: matchIndex + 1
		against: parserList
		index: parserIndex + 1
		inContext: aDictionary
		seen: aSet
! !

!PPParser methodsFor:'*petitanalyzer-named'!

namedChildren
	"Answer the named children of the receiver."

	| result |
	result := OrderedCollection new.
	self namedChildrenDo: [ :parser | result addLast: parser ].
	^ result
! !

!PPParser methodsFor:'*petitanalyzer-named'!

namedChildrenDo: aBlock
	"Iterate over the named children of the receiver."

	self namedChildrenDo: aBlock seen: IdentitySet new
! !

!PPParser methodsFor:'*petitanalyzer-named'!

namedChildrenDo: aBlock seen: aSet
	"Iterate over the named children of the receiver."

	self children do: [ :each |
		(aSet includes: each)
			ifTrue: [ ^ self ].
		aSet add: each.
		each name isNil
			ifTrue: [ each namedChildrenDo: aBlock seen: aSet ]
			ifFalse: [ aBlock value: each ] ]
! !

!PPParser methodsFor:'*petitanalyzer-transforming'!

replace: aParser with: anotherParser
	"Replace the references of the receiver pointing to aParser with anotherParser."
! !

!PPParser methodsFor:'*petitanalyzer-transforming'!

transform: aBlock
	"Answer a copy of all parsers reachable from the receiver transformed using aBlock."

	| mapping root |
	mapping := IdentityDictionary new.
	self allParsersDo: [ :each |
		mapping
			at: each
			put: (aBlock value: each copy) ].
	root := mapping at: self.
	[	| changed |
		changed := false.
		root allParsersDo: [ :each |
			each children do: [ :old |
				mapping at: old ifPresent: [ :new |
					each replace: old with: new.
					changed := true ] ] ].
		changed ] whileTrue.
	^ root
! !

!PPPluggableParser methodsFor:'*petitanalyzer-matching'!

match: aParser inContext: aDictionary seen: anIdentitySet
	^ (super match: aParser inContext: aDictionary seen: anIdentitySet) and: [ self block = aParser block ]
! !

!PPPredicateParser methodsFor:'*petitanalyzer-matching'!

match: aParser inContext: aDictionary seen: anIdentitySet
	^ (super match: aParser inContext: aDictionary seen: anIdentitySet) and: [ self block = aParser block and: [ self message = aParser message ] ]
! !

!PPPredicateSequenceParser methodsFor:'*petitanalyzer-matching'!

match: aParser inContext: aDictionary seen: anIdentitySet
	^ (super match: aParser inContext: aDictionary seen: anIdentitySet) and: [ self size = aParser size ]
! !

!PPRepeatingParser methodsFor:'*petitanalyzer-private'!

followSets: aFollowDictionary firstSets: aFirstDictionary into: aSet
	| firstSet |
	super followSets: aFollowDictionary firstSets:  aFirstDictionary into: aSet.

	firstSet := aFirstDictionary at: self.
	self children do: [:p | (aFollowDictionary at: p) addAll: (firstSet reject: [:each | each isNullable]) ]
! !

!PPRepeatingParser methodsFor:'*petitanalyzer-testing'!

isNullable
	^ min = 0
! !

!PPRepeatingParser methodsFor:'*petitanalyzer-matching'!

match: aParser inContext: aDictionary seen: anIdentitySet
	^ (super match: aParser inContext: aDictionary seen: anIdentitySet) and: [ self min = aParser min and: [ self max = aParser max ] ]
! !

!PPSequenceParser methodsFor:'*petitanalyzer-private'!

cycleSet: aDictionary
	| firstSet |
	1 to: parsers size do: [ :index |
		firstSet := aDictionary at: (parsers at: index).
		(firstSet anySatisfy: [ :each | each isNullable ])
			ifFalse: [ ^ parsers copyFrom: 1 to: index ] ].
	^ parsers
! !

!PPSequenceParser methodsFor:'*petitanalyzer-private'!

firstSets: aFirstDictionary into: aSet
	| nullable |
	parsers do: [ :parser |
		nullable := false.
		(aFirstDictionary at: parser) do: [ :each |
			each isNullable
				ifTrue: [ nullable := true ]
				ifFalse: [ aSet add: each ] ].
		nullable
			ifFalse: [ ^ self ] ].
	aSet add: PPSentinel instance
! !

!PPSequenceParser methodsFor:'*petitanalyzer-private'!

followSets: aFollowDictionary firstSets: aFirstDictionary into: aSet
	parsers keysAndValuesDo: [ :index :parser |
		| followSet firstSet |
		followSet := aFollowDictionary at: parser.
		index = parsers size
			ifTrue: [ followSet addAll: aSet ]
			ifFalse: [
				(self class withAll: (parsers
					copyFrom: index + 1 to: parsers size))
						firstSets: aFirstDictionary
						into: (firstSet := IdentitySet new).
				(firstSet anySatisfy: [ :each | each isNullable ])
					ifTrue: [ followSet addAll: aSet ].
				followSet addAll: (firstSet
					reject: [ :each | each isNullable ]) ] ]
! !

!PPTokenParser methodsFor:'*petitanalyzer-matching'!

match: aParser inContext: aDictionary seen: anIdentitySet
	^ (super match: aParser inContext: aDictionary seen: anIdentitySet) and: [ self tokenClass = aParser tokenClass ]
! !

!stx_goodies_petitparser_analyzer class methodsFor:'documentation'!

extensionsVersion_HG

    ^ '$Changeset: <not expanded> $'
! !
