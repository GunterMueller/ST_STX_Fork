"{ Package: 'stx:goodies/smaCC' }"

"{ NameSpace: SmaCC }"

Object subclass:#SmaCCGrammarCompiler
	instanceVariableNames:'shiftTable itemSets startingStateMap actions parserClass
		parserDefinitionString scannerCompiler grammar model'
	classVariableNames:''
	poolDictionaries:''
	category:'SmaCC-Parser Generator'
!

SmaCCGrammarCompiler comment:'SmaCCGrammarCompiler compiles a SmaCCGrammar.

Instance Variables:
	actions	<Array>	the action table for the parser. It contains the action (shift/reduce/accept/reject) for each possible state/symbol pair
	grammar	<SmaCCGrammar>	our grammar
	itemSets	<SequenceableCollection of: SmaCCItemSet>	the item sets for our grammar
	model	<RBNameSpace>	where we are compiling our changes into
	parserClass	<RBAbstractClass>	the parser class for our changes
	parserDefinitionString	<String>	the definition of our parser
	scannerCompiler	<SmaCCScannerCompiler>	a compiler for the scanner
	shiftTable	<Dictionary key: (Array with: Integer with: SmaCCSymbol) value: Integer>	a table mapping a state/symbol pair to the new state that is aquired by shifting the symbol
	startingStateMap	<Dictionary key: SmaCCSymbol value: Integer>	the state for SmaCCSymbol''s starting item set

'
!


!SmaCCGrammarCompiler class methodsFor:'instance creation'!

new
	^self basicNew initialize
! !

!SmaCCGrammarCompiler methodsFor:'accessing'!

grammar
	^grammar isNil ifTrue: [grammar := SmaCCGrammar new] ifFalse: [grammar]
!

itemSets
    ^ itemSets

    "Created: / 14-02-2008 / 11:55:14 / janfrog"
!

parserClass
	^parserClass
!

parserClass: aClassOrString
	(aClassOrString isKindOf: Behavior) 
		ifTrue: [parserClass := model classFor: aClassOrString]
		ifFalse: 
			[parserClass := model classNamed: aClassOrString.
			parserClass isNil 
				ifTrue: [parserClass := self defineClass: aClassOrString asSubclassOf: SmaCCParser]]
!

scannerClass: aClassOrString
	(aClassOrString isKindOf: Behavior) 
		ifTrue: [scannerCompiler scannerClass: (model classFor: aClassOrString)]
		ifFalse: 
			[scannerCompiler scannerClass: (model classNamed: aClassOrString).
			scannerCompiler scannerClass isNil 
				ifTrue: 
					[scannerCompiler 
						scannerClass: (self defineClass: aClassOrString asSubclassOf: SmaCCScanner)]]
! !

!SmaCCGrammarCompiler methodsFor:'action table'!

actionForState: anInteger on: aGrammarSymbol 
	| action newStateIndex |
	action := (itemSets at: anInteger) action: aGrammarSymbol
				prefer: (grammar preferredActionFor: aGrammarSymbol).
	action isShift 
		ifTrue: 
			[newStateIndex := shiftTable 
						at: (Array with: anInteger with: aGrammarSymbol).
			^(newStateIndex bitShift: 2) + action id].
	action isReduce 
		ifTrue: 
			[^((grammar reduceTableIndexFor: action symbol rhs: action rhs) 
				bitShift: 2) + action id].
	^action id
!

compressTable: table 
	^table collect: 
			[:row | 
			| stream uniqueItems |
			stream := WriteStream on: ByteArray new.
			uniqueItems := (row asSet)
						remove: 3 ifAbsent: [];
						asArray.
			uniqueItems size = 1 
				ifTrue: 
					[stream nextPut: 0.
					stream
						nextPut: (uniqueItems first bitShift: -8);
						nextPut: (uniqueItems first bitAnd: 16rFF).
					(1 to: row size) with: row
						do: 
							[:index :each | 
							each ~~ 3 
								ifTrue: 
									[stream
										nextPut: (index bitShift: -8);
										nextPut: (index bitAnd: 16rFF)]]]
				ifFalse: 
					[stream nextPut: 1.
					(1 to: row size) with: row
						do: 
							[:index :each | 
							each ~~ 3 
								ifTrue: 
									[stream
										nextPut: (each bitShift: -8);
										nextPut: (each bitAnd: 16rFF);
										nextPut: (index bitShift: -8);
										nextPut: (index bitAnd: 16rFF)]]].
			stream contents]
!

createItemSets
	| itemSet newState index |
	startingStateMap := Dictionary new.
	grammar calculateFirstSets.
	itemSets := OrderedCollection new.
	grammar allStartingSymbols do: 
			[:each | 
			itemSets add: (grammar initialItemSetFor: each).
			startingStateMap at: each put: itemSets size].
	shiftTable := Dictionary new.
	index := 1.
	[index <= itemSets size] whileTrue: 
			[itemSet := itemSets at: index.
			grammar symbols do: 
					[:each | 
					newState := itemSet moveOn: each.
					newState notEmpty 
						ifTrue: 
							[shiftTable at: (Array with: index with: each)
								put: (self indexOfState: newState)]].
			index := index + 1]
!

createTransitionTable
	| table |
	table := OrderedCollection new.
	(1 to: itemSets size) with: itemSets
		do: 
			[:index :each | 
			table add: ((1 to: scannerCompiler symbols size) 
						collect: [:i | self actionForState: index on: (scannerCompiler symbols at: i)])].
	actions := self compressTable: table
!

indexOfState: newState 
	| newStateIndex |
	newStateIndex := itemSets indexOf: newState.
	newStateIndex == 0 
		ifTrue: 
			[itemSets add: newState.
			newStateIndex := itemSets size]
		ifFalse: [(itemSets at: newStateIndex) mergeWith: newState].
	^newStateIndex
!

transitionTable
	actions isNil 
		ifTrue: 
			[self createItemSets.
			self createTransitionTable].
	^actions
! !

!SmaCCGrammarCompiler methodsFor:'compiling'!

changes
	^model changes
!

compileChanges
        |each|

        RefactoryChangeManager instance performChange: self changes.
        each := scannerCompiler scannerClass realClass.
        each notNil ifTrue:[each initializeKeywordMap]
!

compileDefinitionComments
	scannerCompiler compileScannerDefinitionComment.
	self compileParserDefinitionComment
!

compileInto: sClass andParser: pClass 
        self scannerClass: sClass.
        self parserClass: pClass.
        self createChanges.
        Smalltalk isSmalltalkX ifTrue:[
            Class withoutUpdatingChangesDo:[
                self compileChanges
            ]
        ] ifFalse:[
            self compileChanges
        ]
            
!

compileItemSetsComment
	| stream |
	stream := WriteStream on: (String new: 1000).
	stream
		nextPutAll: 'itemSetsComment';
		cr;
		cr;
		tab;
		nextPut: $";
		cr.
	(1 to: itemSets size) with: itemSets
		do: 
			[:index :each | 
			stream
				nextPutAll: index printString;
				nextPutAll: (each printString copyReplaceAll: '"' with: '""');
				cr].
	stream nextPut: $".
	self parserClass metaclass compile: stream contents
		classified: #'generated-comments'
!

compileParser
	self compileTransitionTable.
	self compileStartingStateIds.
	self compileReductionTable.
	self compileScannerClassIntoParser
!

compileParserDefinitionComment
        | stream |
        stream := WriteStream on: (String new: 1000).
        stream
                nextPutAll: 'parserDefinitionComment';
                cr;
                cr;
                tab;
                nextPut: $";
                nextPutAll: (parserDefinitionString copyReplaceAll: $"
                                        withAll: '""');
                nextPut: $".

        parserClass metaclass compile: stream contents
                classified: #'generated-comments'
!

compileReductionTable
	| stream |
	stream := WriteStream on: (String new: 1000).
	stream
		nextPutAll: 'reduceTable';
		cr;
		tab;
		nextPutAll: '^#(';
		cr.
	self reduceTable do: 
			[:each | 
			stream nextPutAll: '#('.
			each do: [:e | stream nextPutAll: e storeString]
				separatedBy: [stream space].
			stream
				nextPut: $);
				cr].
	stream nextPut: $).
	parserClass compile: stream contents classified: #'generated-tables'
!

compileScannerClassIntoParser
	| stream |
	stream := WriteStream on: (String new: 1000).
	stream
		nextPutAll: 'scannerClass';
		cr;
		tab;
		nextPutAll: '^';
		nextPutAll: scannerCompiler scannerClass name.
	self parserClass metaclass compile: stream contents classified: #'generated-accessing'
!

compileStartingStateIds
	startingStateMap keysAndValuesDo: 
			[:symbol :position | 
			| stream |
			stream := WriteStream on: (String new: 1000).
			stream
				nextPutAll: 'startingStateFor';
				nextPutAll: symbol compileName;
				cr;
				tab;
				nextPutAll: '^';
				nextPutAll: position printString.
			parserClass metaclass compile: stream contents
				classified: #'generated-starting states']
!

compileSymbolComment
    |stream pairs|

    pairs := OrderedCollection new.

    stream := WriteStream on:(String new:1000).
    stream
        nextPutAll:'symbolComment';
        cr;
        cr;
        tab;
        nextPutAll:'^#('; cr.

    (1 to:scannerCompiler symbols size) with:scannerCompiler symbols do:
        [:index :symbol | 
        stream tab;tab.
        index storeOn: stream.
        stream tab.
        symbol name storeOn: stream.
        stream cr].

    stream nextPutAll:')'.

    self parserClass metaclass compile:stream contents
        classified:#'generated-comments'

    "Modified: / 18-11-2008 / 20:05:44 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 28-03-2010 / 12:33:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

compileTransitionTable
	| stream |
	stream := WriteStream on: (String new: 1000).
	stream
		nextPutAll: 'transitionTable';
		cr;
		tab;
		nextPutAll: '^#(';
		cr.
	self transitionTable do: 
			[:each | 
			stream nextPutAll: '#['.
			each do: [:byte | stream nextPutAll: byte printString]
				separatedBy: [stream nextPut: $ ].
			stream
				nextPut: $];
				cr].
	stream nextPut: $).
	parserClass compile: stream contents classified: #'generated-tables'
!

createChanges
	self removeOldMethods.
	self checkForEmptySymbols.
	self checkForUnusedSymbols.
	scannerCompiler compileScanner.
	self compileParser
!

defineClass: aString asSubclassOf: aBehavior
        |defString|

        Smalltalk dialectName = 'SmalltalkX' ifTrue:[
            defString := aBehavior name , ' subclass: #' , aString 
                                    , ' instanceVariableNames: '''' classVariableNames: '''' poolDictionaries: '''' '
                                    , ' category: ''SmaCC-Generated Classes'' '.
        ] ifFalse:[
            defString := aBehavior name , ' subclass: #' , aString 
                                    , ' instanceVariableNames: '''' classVariableNames: '''' poolDictionaries: '''' '.
        ].
        model defineClass: defString.
        ^model classNamed: aString asSymbol
! !

!SmaCCGrammarCompiler methodsFor:'initialize-release'!

buildScanner: scannerString andParser: parserString 
	| parser |
	scannerCompiler grammar: self grammar.
	scannerCompiler scannerDefinitionString: scannerString.
	parserDefinitionString := parserString.
	scannerCompiler parseTokens.
	parser := SmaCCGrammarParser on: (ReadStream on: parserString).
	parser grammar: grammar.
	parser parse
!

initialize
	scannerCompiler := SmaCCScannerCompiler new.
	model := (RBNamespace new)
				name: 'Compile Scanner/Parser';
				yourself.
	startingStateMap := Dictionary new
! !

!SmaCCGrammarCompiler methodsFor:'private'!

checkForEmptySymbols
        | problemSymbols stream |
        problemSymbols := grammar emptySymbols.
        problemSymbols isEmpty ifTrue: [^self].
        stream := WriteStream on: String new.
        problemSymbols do: [:each | stream nextPutAll: each printString]
                separatedBy: [stream space].
        Smalltalk isSmalltalkX ifTrue:[
            SmaCCCompilationNotification raiseSignal: 'Missing non-terminal productions'
                    with: stream contents
        ] ifFalse:[
            SmaCCCompilationNotification signal: 'Missing non-terminal productions'
                    with: stream contents
        ]
!

checkForUnusedSymbols
        | problemSymbols stream |
        problemSymbols := grammar unusedSymbols.
        problemSymbols isEmpty ifTrue: [^self].
        stream := WriteStream on: String new.
        problemSymbols do: [:each | stream nextPutAll: each printString]
                separatedBy: [stream space].
        Smalltalk isSmalltalkX ifTrue:[
            SmaCCCompilationNotification raiseSignal: 'Unused non-terminal symbols' with: stream contents
        ] ifFalse:[
            SmaCCCompilationNotification signal: 'Unused non-terminal symbols' with: stream contents
        ]
!

removeOldMethods
	self
		removeOldMethodsFrom: scannerCompiler scannerClass;
		removeOldMethodsFrom: scannerCompiler scannerClass metaclass;
		removeOldMethodsFrom: parserClass;
		removeOldMethodsFrom: parserClass metaclass
!

removeOldMethodsFrom: aRBClass 
	(aRBClass selectors select: 
			[:each | 
			(aRBClass protocolsFor: each) 
				allSatisfy: [:protocol | protocol notNil and: ['generated*' match: protocol]]]) 
		do: [:each | aRBClass removeMethod: each]
! !

!SmaCCGrammarCompiler methodsFor:'public'!

reduceTable
    |table|

    table := OrderedCollection new.
    scannerCompiler symbols do:[:each | 
        each isTerminal ifFalse:[
            each 
                productionsDo:[:rhs | | idx |
                    idx := (scannerCompiler symbols identityIndexOf:each).
                    table add:(Array 
                                with:idx
                                with:rhs size
                                with:(rhs compileSourceFor:each in:parserClass))
                ]
        ]
    ].
    ^ table

    "Modified: / 05-09-2005 / 20:45:04 / janfrog"
! !

!SmaCCGrammarCompiler class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/smaCC/SmaCC__SmaCCGrammarCompiler.st,v 1.2 2008-02-17 10:30:22 vranyj1 Exp $'
!

version_SVN
    ^ '$Id$'
! !
