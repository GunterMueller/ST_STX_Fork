"{ Package: 'stx:goodies/smaCC' }"

"{ NameSpace: SmaCC }"

Object subclass:#SmaCCGrammar
	instanceVariableNames:'type shiftReduceTable symbols tokens otherStartingSymbols'
	classVariableNames:'IgnoreCase MaximumCharacterValue'
	poolDictionaries:''
	category:'SmaCC-Parser Generator'
!

SmaCCGrammar comment:'SmaCCGrammar represents a LR(1) or a LALR(1) grammar.

Instance Variables:
	otherStartingSymbols	<Collection of: SmaCCSymbol>	other starting productions. The first production in the grammar is the defaulting starting position, but this can list other starting positions.
	shiftReduceTable	<Dictionary key: SmaCCSymbol value: SmaCCAction class>	when we have a shift/reduce conflict how should we handle it. This table contains the left/right associative rules. Left is a reduce action and right is a shift action.
	symbols	<OrderedCollection of: SmaCCSymbol>	all symbols in our grammar -- includes both terminal and non-terminal
	tokens	<Dictionary key: String value: SmaCCRegularExpressionNode>	the tokens for our scanner
	type	<Symbol>	the type of grammar (LALR1 or LR1)

'
!


!SmaCCGrammar class methodsFor:'instance creation'!

new
	^(super new)
		initialize;
		yourself
! !

!SmaCCGrammar class methodsFor:'accessing'!

ignoreCase
	^IgnoreCase
!

ignoreCase: aBoolean 
	IgnoreCase := aBoolean
!

maximumCharacterValue
	^MaximumCharacterValue
!

maximumCharacterValue: anInteger 
	MaximumCharacterValue := anInteger.
	SmaCCEdge initializeIsExpressions
! !

!SmaCCGrammar class methodsFor:'class initialization'!

initialize
        IgnoreCase := false.
        self maximumCharacterValue: 255

        "
         self initialize
        "
! !

!SmaCCGrammar methodsFor:'accessing'!

addEmptySymbol
	self addSymbol: SmaCCSymbol empty.
	self addSymbol: SmaCCSymbol error
!

addStartingSymbol: aSymbol 
	(otherStartingSymbols includes: aSymbol) 
		ifFalse: [otherStartingSymbols add: aSymbol]
!

allStartingSymbols
	"Return all starting symbols with the default starting symbol listed first."

	| startingSymbols default |
	default := self startSymbol.
	startingSymbols := otherStartingSymbols copy.
	startingSymbols remove: default ifAbsent: [].
	startingSymbols := startingSymbols collect: 
					[:each | 
					(SmaCCStartingSymbol name: 'B e g i n' , each name)
						addProduction: ((SmaCCRHS new)
									add: each;
									yourself);
						yourself].
	startingSymbols addFirst: default.
	^startingSymbols
!

emptySymbols
	^self symbols select: [:each | each isTerminal not and: [each isEmpty]]
!

initialItemSetFor: aSymbol 
	^(aSymbol asLRItemSet)
		type: type;
		yourself
!

makeGroupFor: aRHSCollection 
	| symbol name |
	name := aRHSCollection inject: ''
				into: [:sum :each | sum , ' | ' , each printString].
	symbol := self nonTerminalSymbolNamed: 'Group: ' , name.
	symbol isEmpty 
		ifTrue: 
			[(aRHSCollection allSatisfy: [:each | each size = 1]) 
				ifTrue: [aRHSCollection do: [:each | each reduceAction: '''1''']].
			aRHSCollection do: [:each | symbol addProduction: each]].
	^symbol
!

makeOptionalSymbolFor: aSymbol 
	| symbol |
	symbol := self nonTerminalSymbolNamed: 'Optional: ' , aSymbol printString.
	symbol isEmpty 
		ifTrue: 
			[symbol
				addProduction: ((SmaCCRHS new)
							reduceAction: 'nil';
							yourself);
				addProduction: ((SmaCCRHS new)
							add: aSymbol;
							reduceAction: '''1''';
							yourself)].
	^symbol
!

makeRepeatMultipleSymbolFor: aSymbol 
	| symbol |
	symbol := self 
				nonTerminalSymbolNamed: 'Repeat Multiple: ' , aSymbol printString.
	symbol isEmpty 
		ifTrue: 
			[symbol
				addProduction: ((SmaCCRHS new)
							add: aSymbol;
							reduceAction: 'OrderedCollection with: ''1''';
							yourself);
				addProduction: ((SmaCCRHS new)
							add: symbol;
							add: aSymbol;
							reduceAction: '''1'' add: ''2''; yourself';
							yourself)].
	^symbol
!

makeRepeatSymbolFor: aSymbol 
	| symbol |
	symbol := self nonTerminalSymbolNamed: 'Repeat: ' , aSymbol printString.
	symbol isEmpty 
		ifTrue: 
			[symbol
				addProduction: ((SmaCCRHS new)
							reduceAction: 'OrderedCollection new';
							yourself);
				addProduction: ((SmaCCRHS new)
							add: symbol;
							add: aSymbol;
							reduceAction: '''1'' add: ''2''; yourself';
							yourself)].
	^symbol
!

makeTokenIdMethodFor: aString 
	| token |
	token := (tokens includesKey: aString) 
				ifTrue: [self terminalSymbolNamed: aString]
				ifFalse: 
					[symbols detect: [:each | each name = aString]
						ifNone: [symbols add: (SmaCCTerminalSymbol name: aString)]].
	token createIdMethod: true
!

preferredActionFor: aGrammarSymbol 
	^shiftReduceTable at: aGrammarSymbol ifAbsent: [nil]
!

setStartSymbolIfNone: aGrammarSymbol 
	| startSymbol |
	self startSymbol notNil ifTrue: [^self].
	startSymbol := SmaCCStartingSymbol name: 'B e g i n'.
	self addSymbol: startSymbol.
	startSymbol addProduction: ((SmaCCRHS new)
				add: aGrammarSymbol;
				yourself)
!

startSymbol
	^symbols detect: [:each | each isStartingSymbol] ifNone: [nil]
!

tokens
	^tokens
!

unusedSymbols
	| nonTerminals problemSymbols todo symbol |
	nonTerminals := self symbols reject: [:each | each isTerminal].
	problemSymbols := nonTerminals asSet.
	problemSymbols remove: self startSymbol.
	todo := OrderedCollection with: self startSymbol.
	[todo isEmpty] whileFalse: 
			[symbol := todo removeFirst.
			symbol productionsDo: 
					[:rhs | 
					rhs do: 
							[:each | 
							each isTerminal 
								ifFalse: 
									[(problemSymbols includes: each) 
										ifTrue: 
											[todo add: each.
											problemSymbols remove: each]]]]].
	^problemSymbols
! !

!SmaCCGrammar methodsFor:'initialize-release'!

initialize
	type := #LALR1.
	symbols := OrderedCollection new.
	shiftReduceTable := Dictionary new.
	otherStartingSymbols := OrderedCollection new
!

tokens: aCollection
	tokens := aCollection
!

type: aSymbol
	type := aSymbol
! !

!SmaCCGrammar methodsFor:'precedence'!

leftPrecedenceFor: aGrammarSymbol 
	shiftReduceTable at: aGrammarSymbol put: SmaCCReduceAction
!

nonAssociativePrecedenceFor: aGrammarSymbol 
	shiftReduceTable at: aGrammarSymbol put: SmaCCRejectAction
!

rightPrecedenceFor: aGrammarSymbol 
	shiftReduceTable at: aGrammarSymbol put: SmaCCShiftAction
!

setOperatorPrecedenceFor: aGrammarSymbol to: anInteger
	aGrammarSymbol precedence: anInteger
! !

!SmaCCGrammar methodsFor:'private'!

addSymbol: aGrammarSymbol 
	^symbols add: aGrammarSymbol
!

calculateFirstSets
	| changed |
	changed := true.
	[changed] whileTrue: 
			[changed := false.
			self symbols 
				do: [:each | changed := changed | each calculateFirstTerminals]]
!

calculateLastSets
        | changed |
        changed := true.
        [changed] whileTrue: 
                        [changed := false.
                        self symbols 
                                do: [:each | changed := changed | each calculateLastTerminals]]

    "Created: / 24-02-2016 / 09:36:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

keywordTerminalNamed: aString 
	^symbols detect: [:each | each name = aString]
		ifNone: 
			[symbols addFirst: ((SmaCCTerminalSymbol name: aString)
						regularExpression: (((aString copyFrom: 2 to: aString size - 1) 
									copyReplaceAll: '""'
									with: '"') inject: nil
										into: 
											[:sum :each | 
											sum isNil 
												ifTrue: [SmaCCCharacterRENode characters: (String with: each)]
												ifFalse: [sum , (SmaCCCharacterRENode characters: (String with: each))]]);
						yourself)]
!

nonTerminalSymbolNamed: aString 
	^symbols detect: [:each | each name = aString]
		ifNone: [self addSymbol: (SmaCCNonTerminalSymbol name: aString)]
!

reduceTableIndexFor: aGrammarSymbol rhs: aRHS 
	| index |
	index := 0.
	self symbols do: 
			[:each | 
			each = aGrammarSymbol ifTrue: [^index + (each positionOf: aRHS)].
			index := index + each size].
	^0
!

symbols
	^symbols
!

symbols: aCollection
	symbols := aCollection
!

terminalSymbolNamed: aString 
	^symbols detect: [:each | each name = aString]
		ifNone: 
			[symbols add: ((SmaCCTerminalSymbol name: aString)
						regularExpression: (tokens at: aString);
						yourself)]
!

terminalSymbolNamed: aString ifAbsent: aBlock 
	^symbols detect: [:each | each name = aString]
		ifNone: 
			[symbols add: ((SmaCCTerminalSymbol name: aString)
						regularExpression: (tokens at: aString ifAbsent: [^aBlock value]);
						yourself)]
! !

!SmaCCGrammar class methodsFor:'documentation'!

version
    ^ '$Id$'
!

version_SVN
    ^ '$Id$'
! !


SmaCCGrammar initialize!
