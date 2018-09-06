"{ Package: 'stx:goodies/petitparser' }"

"{ NameSpace: Smalltalk }"

Object subclass:#PPParser
	instanceVariableNames:'properties'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitParser-Parsers'
!


!PPParser class methodsFor:'instance creation'!

named: aString
	^ self new name: aString
!

new
	^ self basicNew initialize
! !










!PPParser methodsFor:'accessing'!

children
	"Answer a set of child parsers that could follow the receiver."

	^ #()
!

name
	"Answer the production name of the receiver."
	
	^ self propertyAt: #name ifAbsent: [ nil ]
!

name: aString
	self propertyAt: #name put: aString
! !

!PPParser methodsFor:'accessing-properties'!

hasProperty: aKey
	"Test if the property aKey is present."
	
	^ properties notNil and: [ properties includesKey: aKey ]
!

propertyAt: aKey
	"Answer the property value associated with aKey."
	
	^ self propertyAt: aKey ifAbsent: [ self error: 'Property not found' ]
!

propertyAt: aKey ifAbsent: aBlock
	"Answer the property value associated with aKey or, if aKey isn't found, answer the result of evaluating aBlock."
	
	^ properties isNil
		ifTrue: [ aBlock value ]
		ifFalse: [ properties at: aKey ifAbsent: aBlock ]
!

propertyAt: aKey ifAbsentPut: aBlock
	"Answer the property associated with aKey or, if aKey isn't found store the result of evaluating aBlock as new value."
	
	^ self propertyAt: aKey ifAbsent: [ self propertyAt: aKey put: aBlock value ]
!

propertyAt: aKey put: anObject
	"Set the property at aKey to be anObject. If aKey is not found, create a new entry for aKey and set is value to anObject. Answer anObject."

	^ (properties ifNil: [ properties := Dictionary new: 1 ])
		at: aKey put: anObject
!

removeProperty: aKey
	"Remove the property with aKey. Answer the property or raise an error if aKey isn't found."
	
	^ self removeProperty: aKey ifAbsent: [ self error: 'Property not found' ]
!

removeProperty: aKey ifAbsent: aBlock
	"Remove the property with aKey. Answer the value or, if aKey isn't found, answer the result of evaluating aBlock."
	
	| answer |
	properties isNil ifTrue: [ ^ aBlock value ].
	answer := properties removeKey: aKey ifAbsent: aBlock.
	properties isEmpty ifTrue: [ properties := nil ].
	^ answer
! !

!PPParser methodsFor:'context'!

parse: anObject withContext: aPPContext
	"Parse anObject with the receiving parser and answer the parse-result or an instance of PPFailure."

	aPPContext stream: anObject asPetitStream.
	^ self parseWithContext: aPPContext.
!

parseWithContext: context
	| result |
	context initializeFor: self.
	result := self parseOn: context.
	
	"Return the furthest failure, it gives better results than the last failure"
	(result isPetitFailure and: [ context furthestFailure notNil]) 
		ifTrue: [ ^ context furthestFailure ].
	^ result
	
!

updateContext: aPPContext
	"nothing to do"
! !

!PPParser methodsFor:'converting'!

asParser
	"Answer the receiving parser."
	
	^ self
! !

!PPParser methodsFor:'copying'!

postCopy
	super postCopy.
	properties := properties copy
! !

!PPParser methodsFor:'enumerating'!

allParsers
	"Answer all the parse nodes of the receiver."

	| result |
	result := OrderedCollection new.
	self allParsersDo: [ :parser | result addLast: parser ].
	^ result
!

allParsersDo: aBlock
	"Iterate over all the parse nodes of the receiver."

	self allParsersDo: aBlock seen: IdentitySet new
!

allParsersDo: aBlock seen: aSet
	"Iterate over all the parse nodes of the receiver, do not visit and follow the ones contained in aSet."

	(aSet includes: self)
		ifTrue: [ ^ self ].
	aSet add: self.
	aBlock value: self.
	self children
		do: [ :each | each allParsersDo: aBlock seen: aSet ]
! !

!PPParser methodsFor:'initialization'!

initialize
! !

!PPParser methodsFor:'inspecting'!

inspector2TabTree
    <inspector2Tab>

    ^ (self newInspector2Tab)
        label:'Tree';
        priority:50;
        view: [
            | list view |

            list := PluggableHierarchicalList new.
            list childBlock: [ :parent | parent children ].
            list labelBlock: [ :child | child printString ].
            list root: self.
            view := ScrollableView for:HierarchicalListView.
            view useDefaultIcons: false.
            view list: list.
            view
        ];
        yourself

    "Modified: / 22-05-2015 / 17:05:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 31-07-2015 / 09:34:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPParser methodsFor:'operations'!

, aParser 
	"Answer a new parser that parses the receiver followed by aParser."

	^ PPSequenceParser with: self with: aParser
!

/ aParser 
	"Answer a new parser that parses the receiver, if the receiver fails try with aParser (ordered-choice)."
	
	^ PPChoiceParser with: self with: aParser
!

and
	"Answer a new parser (logical and-predicate) that succeeds whenever the receiver does, but never consumes input."

	^ PPAndParser on: self
!

def: aParser
	"Redefine the receiver as the argument aParser. This method is useful when defining recursive parsers: instantiate a PPUnresolvedParser and later redefine it with another one."

	^ self becomeForward: (aParser name: self name)
!

end
	"Answer a new parser that succeeds at the end of the input and return the result of the receiver."

	^ PPEndOfInputParser on: self
!

memoized
	"Answer a new memoized parser, for refraining redundant computations. This ensures polynomial time O(n^4) for left-recursive grammars and O(n^3) for non left-recursive grammars in the worst case. Not necessary for most grammars that are carefully written and in O(n) anyway."
	
	^ PPMemoizedParser on: self
!

negate
        "Answer a new parser consumes any input token but the receiver."
        
        ^ self not , #any asParser ==> #second
!

not
	"Answer a new parser (logical not-predicate) that succeeds whenever the receiver fails, but never consumes input."

	^ PPNotParser on: self
!

optional
	"Answer a new parser that parses the receiver, if possible."

	^ PPOptionalParser on: self
!

times: anInteger
	"Answer a new parser that parses the receiver exactly anInteger times."
	
	^ self min: anInteger max: anInteger
!

wrapped
	"Answer a new parser that is simply wrapped."
	
	^ PPDelegateParser on: self
!

| aParser
	"Answer a new parser that either parses the receiver or aParser. Fail if both pass or fail (exclusive choice, unordered choice)."

	^ (self not , aParser) / (aParser not , self) ==> #second
! !

!PPParser methodsFor:'operations-convenience'!

delimitedBy: aParser
	"Answer a new parser that parses the receiver one or more times, separated and possibly ended by aParser."
	
	^ (self separatedBy: aParser) , (aParser optional) ==> [ :node |
		node second isNil
			ifTrue: [ node first ]
			ifFalse: [ node first copyWith: node second ] ]
!

separatedBy: aParser
	"Answer a new parser that parses the receiver one or more times, separated by aParser."
	
	^ (PPSequenceParser with: self with: (PPSequenceParser with: aParser with: self) star) ==> [ :nodes |
		| result |
		result := Array new: 2 * nodes second size + 1.
		result at: 1 put: nodes first.
		nodes second 
			keysAndValuesDo: [ :index :pair | result replaceFrom: 2 * index to: 2 * index + 1 with: pair startingAt: 1 ].
		result ]
! !

!PPParser methodsFor:'operations-mapping'!

==> aBlock
	"Answer a new parser that performs aBlock as action handler on success."

	^ PPActionParser on: self block: aBlock
!

answer: anObject
	"Answer a new parser that always returns anObject from a successful parse."

	^ self ==> [ :nodes | anObject ]
!

flatten
	"Answer a new parser that flattens the underlying collection."
	
	^ PPFlattenParser on: self
!

token
	"Answer a new parser that transforms the input to a token."
	
	^ PPTokenParser on: self
!

token: aTokenClass
	"Answer a new parser that transforms the input to a token of class aTokenClass."
	
	^ self token tokenClass: aTokenClass
!

trim
	"Answer a new parser that consumes spaces before and after the receiving parser."
	
	^ self trimSpaces
! !

!PPParser methodsFor:'operators'!

// aParser 
	"
		Answer a new parser that parses the receiver, if the receiver fails try with aParser (ordered-choice).
		If the receiver passes, limit must pass as well.
	"
	
	^ PPLimitedChoiceParser with: self with: aParser
!

if: aBlock
	^ PPConditionalParser on: self block: aBlock
! !

!PPParser methodsFor:'operators-convenience'!

withoutSeparators
	"Filters out the separators from a parse result produced by one of the productions #delimitedBy: or #separatedBy:."
	
	^ self ==> [ :items |
		| result |
		result := Array new: items size + 1 // 2.
		1 to: result size do: [ :index | result at: index put: (items at: 2 * index - 1) ].
		result ]
! !

!PPParser methodsFor:'operators-mapping'!

>=> aBlock
	"Answer a new parser that wraps the receiving parser with a two argument block. The first argument is the parsed stream, the second argument a continuation block on the delegate parser."

	^ PPWrappingParser on: self block: aBlock
!

foldLeft: aBlock
	"Answer a new parser that that folds the result of the receiver from left-to-right into aBlock. The argument aBlock must take two or more arguments."
	
	| size args |
	size := aBlock numArgs.
	args := Array new: size.
	^ self ==> [ :nodes |
		args at: 1 put: nodes first.
		2 to: nodes size by: size - 1 do: [ :index |
			args
				replaceFrom: 2 to: size with: nodes startingAt: index;
				at: 1 put: (aBlock valueWithArguments: args) ].
		args first ]
!

foldRight: aBlock
	"Answer a new parser that that folds the result of the receiver from right-to-left into aBlock. The argument aBlock must take two or more arguments."

	| size args |
	size := aBlock numArgs.
	args := Array new: size.
	^ self ==> [ :nodes |
		args at: size put: nodes last.
		nodes size - size + 1 to: 1 by: 1 - size do: [ :index |
			args
				replaceFrom: 1 to: size - 1 with: nodes startingAt: index;
				at: size put: (aBlock valueWithArguments: args) ].
		args at: size ]
!

map: aBlock
	"Answer a new parser that works on the receiving sequence an passes in each element as a block argument."
	
	^ aBlock numArgs = 1
		ifTrue: [ self ==> aBlock ]
		ifFalse: [ self error: aBlock numArgs asString , ' arguments expected.' ]
!

trim: aParser
	"Answer a new parser that consumes and ignores aParser repeatedly before and after the receiving parser."
	
	^ PPTrimmingParser on: self trimmer: aParser
!

trimBlanks
	"Answer a new parser that consumes blanks before and after the receiving parser."
	
	^ self trim: #blank asParser
!

trimLeft
	"Answer a new parser that consumes spaces before the receiving parser."
	
	^ self trimSpacesLeft
!

trimRight
	"Answer a new parser that consumes spaces after the receiving parser."
	
	^ self trimSpacesRight
!

trimSpaces
	"Answer a new parser that consumes spaces before and after the receiving parser."
	
	^ self trim: #space asParser
!

trimSpacesLeft
	"Answer a new parser that consumes spaces before the receiving parser."
	
	^ (#space asParser star, self) ==> #second
!

trimSpacesRight
	"Answer a new parser that consumes spaces after the receiving parser."
	
	^ (self, #space asParser star) ==> #first
! !

!PPParser methodsFor:'operators-repeating'!

max: anInteger
	"Answer a new parser that parses the receiver at most anInteger times."
	
	^ self star setMax: anInteger
!

max: anInteger greedy: aParser
	"Answer a new parser that parses the receiver at most anInteger times until it reaches aParser. This is a greedy non-blind implementation. aParser is not consumed."
	
	^ (self starGreedy: aParser) setMax: anInteger
!

max: anInteger lazy: aParser
	"Answer a new parser that parses the receiver at most anInteger times until it reaches aParser. This is a lazy non-blind implementation. aParser is not consumed."
	
	^ (self starLazy: aParser) setMax: anInteger
!

min: anInteger
	"Answer a new parser that parses the receiver at least anInteger times."
	
	^ self star setMin: anInteger
!

min: anInteger greedy: aParser
	"Answer a new parser that parses the receiver at least anInteger times until it reaches aParser. This is a greedy non-blind implementation. aParser is not consumed."
	
	^ (self starGreedy: aParser) setMin: anInteger
!

min: anInteger lazy: aParser
	"Answer a new parser that parses the receiver at least anInteger times until it reaches aParser. This is a lazy non-blind implementation. aParser is not consumed."
	
	^ (self starLazy: aParser) setMin: anInteger
!

min: aMinInteger max: aMaxInteger
	"Answer a new parser that parses the receiver at least aMinInteger and at most aMaxInteger times."
	
	^ self star setMin: aMinInteger; setMax: aMaxInteger
!

min: aMinInteger max: aMaxInteger greedy: aParser
	"Answer a new parser that parses the receiver at least aMinInteger and at most aMaxInteger times until it reaches aParser. This is a greedy non-blind implementation. aParser is not consumed."
	
	^ (self starGreedy: aParser) setMin: aMinInteger; setMax: aMaxInteger
!

min: aMinInteger max: aMaxInteger lazy: aParser
	"Answer a new parser that parses the receiver at least aMinInteger and at most aMaxInteger times until it reaches aParser. This is a greedy non-blind implementation. aParser is not consumed."
	
	^ (self starLazy: aParser) setMin: aMinInteger; setMax: aMaxInteger
!

plus
	"Answer a new parser that parses the receiver one or more times."

	^ self star setMin: 1
!

plusGreedy: aParser
	"Answer a new parser that parses the receiver one or more times until it reaches aParser. This is a greedy non-blind implementation of the star operator. aParser is not consumed."
	
	^ (self starGreedy: aParser) setMin: 1
!

plusLazy: aParser
	"Answer a new parser that parses the receiver one or more times until it reaches aParser. This is a lazy non-blind implementation of the star operator. aParser is not consumed."
	
	^ (self starLazy: aParser) setMin: 1
!

star
	"Answer a new parser that parses the receiver zero or more times. This is a greedy and blind implementation that tries to consume as much input as possible and it does not consider what comes afterwards."

	^ PPPossessiveRepeatingParser on: self
!

starGreedy: aParser
	"Answer a new parser that parses the receiver zero or more times until it reaches aParser. This is a greedy non-blind implementation of the star operator. aParser is not consumed."
	
	^ PPGreedyRepeatingParser on: self limit: aParser
!

starLazy: aParser
	"Answer a new parser that parses the receiver zero or more times until it reaches aParser. This is a lazy non-blind implementation of the star operator. aParser is not consumed."
	
	^ PPLazyRepeatingParser on: self limit: aParser
! !

!PPParser methodsFor:'parsing'!

matches: anObject
	"Answer if anObject can be parsed by the receiver."
	
	^ (self parse: anObject) isPetitFailure not
!

matchesIn: anObject
	"Search anObject repeatedly for the matches of the receiver. Answered an OrderedCollection of the matched parse-trees."

	| result |
	result := OrderedCollection new.
	self 
		matchesIn: anObject
		do: [ :each | result addLast: each ].
	^ result
!

matchesIn: anObject do: aBlock
	"Search anObject repeatedly for the matches of the receiver. Evaluate aBlock for each match with the matched parse-tree as the argument. Make sure to always consume exactly one character with each step, to not miss any match."

	((self and ==> aBlock , #any asParser) / #any asParser) star parse: anObject
!

matchesSkipIn: anObject
	"Search anObject repeatedly for the matches of the receiver. Answer an OrderedCollection of the matched parse-trees. Skip over matches."

	| result |
	result := OrderedCollection new.
	self 
		matchesSkipIn: anObject
		do: [ :each | result addLast: each ].
	^ result
!

matchesSkipIn: anObject do: aBlock
	"Search anObject repeatedly for the matches of the receiver. Evaluate aBlock for each match with the matched parse-tree as the argument. Skip over matches."

	(self ==> aBlock / #any asParser) star parse: anObject
!

matchingRangesIn: anObject
	"Search anObject repeatedly for the matches of the receiver. Answer an OrderedCollection of ranges of each match (index of first character to: index of last character)."
	
	| result |
	result := OrderedCollection new.
	self
		matchingRangesIn: anObject
		do: [ :value | result addLast: value ].
	^ result
!

matchingRangesIn: anObject do: aBlock
	"Search anObject repeatedly for the matches of the receiver. Evaluate aBlock with the range of each match (index of first character to: index of last character)."

	self token
		matchesIn: anObject
		do: [ :token | aBlock value: (token start to: token stop) ]
!

matchingSkipRangesIn: anObject
	"Search anObject repeatedly for the matches of the receiver. Skip over matches. Answer an OrderedCollection of ranges of each match (index of first character to: index of last character)."
	
	| result |
	result := OrderedCollection new.
	self
		matchingSkipRangesIn: anObject
		do: [ :value | result addLast: value ].
	^ result
!

matchingSkipRangesIn: anObject do: aBlock
	"Search anObject repeatedly for the matches of the receiver. Skip over matches. Evaluate aBlock with the range of each match (index of first character to: index of last character)."
	
	self token
		matchesSkipIn: anObject
		do: [ :token | aBlock value: (token start to: token stop) ]
!

parse: anObject
	"Parse anObject with the receiving parser and answer the parse-result or an instance of PPFailure."

	^ self parse: anObject withContext: PPContext new
!

parse: anObject onError: aBlock
	"Parse anObject with the receiving parser and answer the parse-result or answer the result of evaluating aBlock. Depending on the number of arguments of the block it is simply evaluated, evaluated with the failure object, or evaluated with the error message and position."
	
	| result |
	result := self parse: anObject.
	result isPetitFailure
		ifFalse: [ ^ result ].
	aBlock numArgs = 0
		ifTrue: [ ^ aBlock value ].
	aBlock numArgs = 1
		ifTrue: [ ^ aBlock value: result ].
	^ aBlock value: result message value: result position
!

parseOn: aPPContext
	"Parse aStream with the receiving parser and answer the parse-result or an instance of PPFailure. Override this method in subclasses to specify custom parse behavior. Do not call this method from outside, instead use #parse:."
	
	self subclassResponsibility
! !

!PPParser methodsFor:'printing'!

printNameOn: aStream
	self name isNil
		ifTrue: [ aStream print: self hash ]
		ifFalse: [ aStream nextPutAll: self name ]
!

printOn: aStream
	super printOn: aStream.
	aStream nextPut: $(.
	self printNameOn: aStream.
	aStream nextPut: $)
! !

!PPParser methodsFor:'testing'!

isPetitParser
	^ true
!

isUnresolved
	^ false
! !

!PPParser class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/PPParser.st,v 1.7 2014-03-04 23:58:41 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/PPParser.st,v 1.7 2014-03-04 23:58:41 cg Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id: PPParser.st,v 1.7 2014-03-04 23:58:41 cg Exp $'
! !

