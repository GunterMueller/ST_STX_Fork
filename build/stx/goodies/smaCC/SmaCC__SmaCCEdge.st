"{ Package: 'stx:goodies/smaCC' }"

"{ NameSpace: SmaCC }"

Object subclass:#SmaCCEdge
	instanceVariableNames:'toNode characters'
	classVariableNames:'IsExpressions'
	poolDictionaries:''
	category:'SmaCC-Scanner Generator'
!

SmaCCEdge comment:'SmaCCEdge represents a transition in a Finite Automata (directed graph). It is labeled with the characters (possibly none, indicating an epsilon transition) that cause the transition.

Instance Variables:
	characters	<SortedCollection of: Character>	The characters that cause the transition. Note that there are no duplicates and all characters are sorted.
	toNode	<SmaCCNode>	The node that this is transitioning to.'
!


!SmaCCEdge class methodsFor:'instance creation'!

to: aNode on: aStringOrNil 
	| edge |
	edge := self new.
	edge to: aNode on: aStringOrNil.
	^edge
! !

!SmaCCEdge class methodsFor:'class initialization'!

generateCharacterSetFor: aSelector 
        | stream |
        stream := String new writeStream.
        0 to: SmaCCGrammar maximumCharacterValue
                do: 
                        [:i | 
                        | ch |
                        ch := Character value: i.
                        (ch perform: aSelector) ifTrue: [stream nextPut: ch]].
        ^stream contents

    "Modified: / 26-05-2006 / 22:16:27 / janfrog"
!

initializeIsExpressions
    "Creates a map from sets of characters to selectors that start with 'is' on Character. This allows generated scanners to take
     full advantage of selectors that are already implemented on Character"
    
    |selectors|

    IsExpressions := Dictionary new.
    selectors := OrderedCollection new.

    "This code ensures that any extension isXXX methods will not
     be taken"
    Character methodDictionary do:
                [:method| | selector |
                selector := method selector.
                ((selector startsWith:'is') and:[method numArgs = 0 and:[method package == Character package]])
                    ifTrue:[selectors add:selector]].

    selectors do:[:sel | 
        |string|

        string := self generateCharacterSetFor:sel.
        string isEmpty ifFalse:[
            IsExpressions at:string put:sel
        ]
    ]

    "Modified: / 15-02-2010 / 16:57:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SmaCCEdge methodsFor:'accessing'!

mergeWith: anEdge 
	characters := String withAll: ((characters , anEdge characters) asSet 
						asSortedCollection: [:a :b | a asInteger < b asInteger])
!

to
	^toNode
! !

!SmaCCEdge methodsFor:'comparing'!

< anEdge
        "required for ST/X, where SortedCollection uses < to compare"

        ^self to id < anEdge to id
!

<= anEdge 
	^self to id <= anEdge to id
!

= anEdge 
	self class = anEdge class ifFalse: [^false].
	^self to = anEdge to and: [self characters = anEdge characters]
!

hash
	^(self to hash bitShift: 14) bitXor: characters hash
! !

!SmaCCEdge methodsFor:'compiling'!

closestIsExpression
	"Attempts to find the #is selector that most closely matches the character set that this edge transitions on."

	| expressions closest |
	expressions := IsExpressions keys 
				select: [:each | (each reject: [:ch | self includesCharacter: ch]) isEmpty].
	expressions isEmpty ifTrue: [^nil].
	closest := IsExpressions 
				at: (expressions asSortedCollection: [:a :b | a size > b size]) first.
	(self minMaxPairsWithout: closest) size 
		<= (self minMaxPairsWithout: nil) size ifFalse: [^nil].
	^closest
!

expression
	| stream isSelector |
	stream := WriteStream on: (String new: 128).
	stream nextPut: $(.
	characters size = SmaCCGrammar maximumCharacterValue 
		ifTrue: [self outputInvertedMatchOn: stream]
		ifFalse: 
			[isSelector := self outputClosestIsMethodOn: stream.
			self outputExpressionOn: stream without: isSelector].
	stream nextPut: $).
	^stream contents
!

minMaxPairsWithout: aSelector 
	"Converts a list of characters into a collection of pairs representing the minimum and maximum of each sequence.
	The list is first filtered to include only those characters that fail aSelector."

	| start last pairs charsLeft |
	charsLeft := aSelector isNil 
				ifTrue: [characters]
				ifFalse: [characters reject: [:ch | ch perform: aSelector]].
	pairs := OrderedCollection new.
	charsLeft isEmpty ifTrue: [^pairs].
	last := charsLeft first.
	start := nil.
	charsLeft do: 
			[:each | 
			last asInteger + 1 = each asInteger 
				ifFalse: 
					[start notNil ifTrue: [pairs add: (Array with: start with: last)].
					start := each].
			last := each].
	pairs add: (Array with: start with: last).
	^pairs
!

outputClosestIsMethodOn: stream 
	| expr |
	expr := self closestIsExpression.
	expr isNil ifFalse: [stream nextPutAll: 'currentCharacter ' , expr].
	^expr
!

outputExpressionFor: aPair on: stream 
	aPair first == aPair last 
		ifTrue: [^self outputMatchSingleCharacter: aPair first on: stream].
	aPair first = (Character value: 0) 
		ifTrue: [^self outputMatchLessThan: aPair last on: stream].
	aPair last = (Character value: SmaCCGrammar maximumCharacterValue) 
		ifTrue: [^self outputMatchGreaterThan: aPair first on: stream].
	self outputMatchRange: aPair on: stream
!

outputExpressionOn: aStream without: aSelector 
	| pairs |
	pairs := self minMaxPairsWithout: aSelector.
	pairs isEmpty ifTrue: [^self].
	aSelector notNil ifTrue: [aStream nextPutAll: ' or: ['].
	pairs do: [:each | self outputExpressionFor: each on: aStream]
		separatedBy: [aStream nextPutAll: ' or: ['].
	aStream next: pairs size - 1 put: $].
	aSelector notNil ifTrue: [aStream nextPut: $]]
!

outputInvertedMatchOn: aStream 
	| char |
	char := Character value: ((0 to: SmaCCGrammar maximumCharacterValue) 
						detect: [:each | (characters includes: (Character value: each)) not]).
	aStream
		nextPutAll: 'currentCharacter ~~ ';
		nextPutAll: char storeString
!

outputMatchGreaterThan: aCharacter on: stream 
	stream
		nextPutAll: 'currentCharacter >= ';
		nextPutAll: aCharacter storeString
!

outputMatchLessThan: aCharacter on: stream 
	stream
		nextPutAll: 'currentCharacter <= ';
		nextPutAll: aCharacter storeString
!

outputMatchRange: aPair on: stream 
	stream
		nextPutAll: '(currentCharacter between: ';
		nextPutAll: aPair first storeString;
		nextPutAll: ' and: ';
		nextPutAll: aPair last storeString;
		nextPutAll: ')'
!

outputMatchSingleCharacter: aCharacter on: stream 
	stream
		nextPutAll: 'currentCharacter == ';
		nextPutAll: aCharacter storeString
! !

!SmaCCEdge methodsFor:'initialize-release'!

to: aNode on: aStringOrNil 
	toNode := aNode.
	characters := aStringOrNil
! !

!SmaCCEdge methodsFor:'printing'!

printOn: aStream 
	aStream
		nextPutAll: '---';
		nextPutAll: (characters ifNil: ['""']);
		nextPutAll: '--->';
		nextPutAll: toNode printString
! !

!SmaCCEdge methodsFor:'private'!

characters
	^characters
!

removeCharacters: aCollection 
	characters := characters 
				reject: [:each | self does: aCollection includeCharacter: each]
! !

!SmaCCEdge methodsFor:'public'!

conflictsWith: anEdge 
	^characters anySatisfy: [:each | anEdge characters includes: each]
!

does: aString includeCharacter: aCharacter 
	| start stop mid |
	start := 1.
	stop := aString size.
	stop = 0 ifTrue: [^false].
	
	[mid := (start + stop) // 2.
	mid == start] whileFalse: 
				[(aString at: mid) asInteger < aCharacter asInteger 
					ifTrue: [start := mid]
					ifFalse: [stop := mid]].
	^(aString at: start) == aCharacter or: [(aString at: stop) == aCharacter]
!

includesCharacter: aCharacter 
	^self does: characters includeCharacter: aCharacter
!

isEmpty
	^characters isEmpty
!

isEpsilonTransition
	^characters isNil
! !

!SmaCCEdge class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/smaCC/SmaCC__SmaCCEdge.st,v 1.2 2006-05-28 20:08:49 vranyj1 Exp $'
!

version_SVN
    ^ '$Id$'
! !
