"{ Package: 'stx:goodies/smaCC' }"

"{ NameSpace: SmaCC }"

Object subclass:#SmaCCParser
	instanceVariableNames:'scanner currentToken errorToken stateStack nodeStack'
	classVariableNames:''
	poolDictionaries:''
	category:'SmaCC-Runtime'
!

SmaCCParser comment:'SmaCCParser is an abstract class that defines most of the parsing actions. Subclasses will define methods that specify their transitions and reduction actions. These are normally defined automatically when compiling the parser.

Subclasses must implement the following messages:
	accessing
		emptySymbolTokenId
		reduceTable
		transitionTable

Instance Variables:
	currentToken	<SmaCCToken>	the token last returned by the scanner that has not been shifted (reduce actions leave the current token alone)
	nodeStack	<OrderedCollection>	collection of items on stack. These items are specific to the parser and can be any object. 
	scanner	<SmaCCScanner>	our scanner
	stateStack	<OrderedCollection of: Integer>	the stack of states for our parser (standard LR state stack)

'
!


!SmaCCParser class methodsFor:'instance creation'!

new
	^(super new)
		initialize;
		yourself
!

on: aStream 
	| parser scanner |
	scanner := self scannerClass on: aStream.
	parser := self new.
	parser scanner: scanner.
	^parser
! !

!SmaCCParser class methodsFor:'accessing'!

parse: aString 
	^self parse: aString startingAt: self defaultStartingState
!

parse: aString onError: aBlock
        ^[self parse: aString] on: SmaCCParserError
                do: [:ex | 
                    Smalltalk isSmalltalkX ifTrue:[
                        ex return: (aBlock value: ex description value: ex parameter position)
                    ].
                    ex return: (aBlock value: ex description value: ex tag position)
                ]
!

parse: aString startingAt: anInteger 
	^self parseStream: (ReadStream on: aString) startingAt: anInteger
!

parse: aString startingAt: anInteger onError: aBlock
        ^[self parse: aString startingAt: anInteger] on: SmaCCParserError
                do: [:ex | 
                    Smalltalk isSmalltalkX ifTrue:[
                        ex return: (aBlock value: ex description value: ex parameter position)
                    ].
                    ex return: (aBlock value: ex description value: ex tag position)]
!

parseStream: aStream 
	^self parseStream: aStream startingAt: self defaultStartingState
!

parseStream: aStream onError: aBlock
        ^[self parseStream: aStream] on: SmaCCParserError
                do: [:ex | 
                    Smalltalk isSmalltalkX ifTrue:[
                        ex return: (aBlock value: ex description value: ex parameter position)
                    ].
                    ex return: (aBlock value: ex description value: ex tag position)]
!

parseStream: aStream startingAt: anInteger 
	| parser |
	parser := self on: aStream.
	parser setStartingState: anInteger.
	^parser parse
!

parseStream: aStream startingAt: anInteger onError: aBlock
        ^[self parseStream: aStream startingAt: anInteger] on: SmaCCParserError
                do: [:ex | 
                    Smalltalk isSmalltalkX ifTrue:[
                        ex return: (aBlock value: ex description value: ex parameter position)
                    ].
                    ex return: (aBlock value: ex description value: ex tag position)]
! !

!SmaCCParser class methodsFor:'private'!

defaultStartingState
	^1
!

scannerClass
	^self subclassResponsibility
! !

!SmaCCParser methodsFor:'accessing'!

emptySymbolTokenId
	^scanner emptySymbolTokenId
!

errorTable
	^#()
!

errorTokenId
	^scanner errorTokenId
!

parse
	self setDefaultStartingStateIfNone.
	self performParsingLoop.
	^nodeStack last
!

position
	^currentToken isNil 
		ifTrue: [scanner position]
		ifFalse: [currentToken startPosition]
!

reduceTable
	^self subclassResponsibility
!

transitionTable
	^self subclassResponsibility
! !

!SmaCCParser methodsFor:'initialize-release'!

initialize
	nodeStack := OrderedCollection new
!

scanner: aScanner 
	scanner := aScanner
!

setStartingState: startingState 
	stateStack := OrderedCollection with: startingState
! !

!SmaCCParser methodsFor:'private'!

acceptAction
	^0
!

actionFor: aSymbolIndex 
	^self actionForState: self currentState and: aSymbolIndex
!

actionForCurrentToken
	^self actionFor: currentToken id first
!

actionForState: stateIndex and: aSymbolIndex 
	| index row |
	row := self transitionTable at: stateIndex.
	(row at: 1) == 0 
		ifTrue: 
			[index := self 
						binarySearchIn: row
						for: aSymbolIndex
						size: 2.
			index == 0 
				ifTrue: [^self errorAction]
				ifFalse: [^((row at: 2) bitShift: 8) + (row at: 3)]]
		ifFalse: 
			[index := self 
						binarySearchIn: row
						for: aSymbolIndex
						size: 4.
			index == 0 
				ifTrue: [^self errorAction]
				ifFalse: [^((row at: index - 2) bitShift: 8) + (row at: index - 1)]]
!

actionMask
	^2r11
!

binarySearchIn: aRow for: aSymbolIndex size: step 
	| start mid length high low midItem stop |
	high := aSymbolIndex bitShift: -8.
	low := aSymbolIndex bitAnd: 16rFF.
	start := 4.
	stop := aRow size - 1.
	length := (stop - start) // step.
	[length > 4] whileTrue: 
			[length := length bitShift: -1.
			mid := length * step + start.
			midItem := aRow at: mid.
			((midItem == high and: [(aRow at: mid + 1) <= low]) or: [midItem < high]) 
				ifTrue: [start := mid]
				ifFalse: [stop := mid]].
	[start <= stop] whileTrue: 
			[((aRow at: start) == high and: [(aRow at: start + 1) == low]) 
				ifTrue: [^start].
			start := start + step].
	^0
!

currentState
	^stateStack last
!

errorAction
	^3
!

findErrorHandlerIfNoneUseErrorNumber: anInteger 
	| handlerStates index startingErrorToken newStack |
	handlerStates := self errorHandlerStates reverse.
	startingErrorToken := currentToken.
	
	[index := (1 to: handlerStates size) detect: 
					[:each | 
					| state |
					state := handlerStates at: each.
					state ~= 0 and: 
							[newStack := stateStack copyFrom: 1 to: handlerStates size - each + 1.
							newStack add: state.
							self willShift: newStack]]
				ifNone: [nil].
	index isNil] 
			whileTrue: 
				[self dismissErrorToken.
				currentToken id first = self emptySymbolTokenId 
					ifTrue: 
						[currentToken := startingErrorToken.
						self reportError: anInteger]].
	index - 1 timesRepeat: [self dismissStackTopForErrorRecovery].
	stateStack addLast: (handlerStates at: index).
	nodeStack addLast: startingErrorToken
!

getNextToken
	currentToken isNil ifTrue: [currentToken := scanner next]
!

liftFirstValue: aCollection 
	^aCollection first
!

liftLastValue: aCollection 
	^aCollection last
!

liftSecondValue: aCollection 
	^aCollection at: 2
!

performParsingLoop
	| action actionType |
	
	[self getNextToken.
	action := self actionForCurrentToken.
	action = self acceptAction] 
			whileFalse: 
				[actionType := action bitAnd: self actionMask.
				action := action bitShift: -2.
				actionType == self shiftAction 
					ifTrue: [self shift: action]
					ifFalse: 
						[actionType == self reduceAction 
							ifTrue: [self reduce: action]
							ifFalse: [self handleError: action]]].
	self checkForErrors
!

performReduceMethod: aSymbol with: items 
	^aSymbol last == $: 
		ifTrue: [self perform: aSymbol with: items]
		ifFalse: [self perform: aSymbol]
!

reduce: anInteger 
	| reduceEntry items size |
	reduceEntry := self reduceTable at: anInteger.
	items := OrderedCollection new: (size := reduceEntry at: 2).
	size timesRepeat: 
			[items addFirst: nodeStack removeLast.
			stateStack removeLast].
	nodeStack add: (self performReduceMethod: (reduceEntry at: 3) with: items).
	stateStack add: ((self actionFor: (reduceEntry at: 1)) bitShift: -2)
!

reduceAction
	^2r10
!

reduceFor: aCollection 
	| newCollection item |
	(aCollection allSatisfy: [:each | each class ~~ OrderedCollection]) 
		ifTrue: [^aCollection].
	aCollection first class == OrderedCollection 
		ifTrue: 
			[newCollection := aCollection first.
			2 to: aCollection size
				do: 
					[:i | 
					item := aCollection at: i.
					item class = OrderedCollection 
						ifTrue: [newCollection addAll: item]
						ifFalse: [newCollection add: item]].
			^newCollection].
	newCollection := OrderedCollection new.
	aCollection do: 
			[:each | 
			each class == OrderedCollection 
				ifTrue: [newCollection addAll: each]
				ifFalse: [newCollection add: each]].
	^newCollection
!

setDefaultStartingStateIfNone
	stateStack isNil 
		ifTrue: [self setStartingState: self class defaultStartingState]
!

shift: stateIndex 
	stateStack add: stateIndex.
	nodeStack add: currentToken.
	currentToken := nil
!

shiftAction
	^2r01
! !

!SmaCCParser methodsFor:'private-error handling'!

checkForErrors
	"If we have an error correction installed, we might have handled the errors. If we did, we don't 
	want to return the result, so we raise a final exception that can't be proceeded."

	errorToken isNil ifTrue: [^self].
	currentToken := errorToken.
	self reportErrorMessage: 'Token not expected'
!

dismissErrorToken
	currentToken := nil.
	self getNextToken
!

dismissStackTopForErrorRecovery
	stateStack removeLast.
	^nodeStack removeLast
!

errorHandlerStates
	^stateStack collect: 
			[:each | 
			| action |
			action := self actionForState: each and: self errorTokenId.
			(action bitAnd: self actionMask) = 1 
				ifTrue: [action bitShift: -2]
				ifFalse: [0]]
!

handleError: anInteger 
	errorToken isNil ifTrue: [errorToken := currentToken].
	(currentToken id first = self emptySymbolTokenId 
		or: [self hasErrorHandler not]) ifTrue: [self reportError: anInteger].
	self findErrorHandlerIfNoneUseErrorNumber: anInteger
!

hasErrorHandler
	^self errorHandlerStates anySatisfy: [:each | each ~~ 0]
!

reportError: anInteger 
	self reportErrorMessage: (anInteger = 0 
				ifTrue: ['Token not expected']
				ifFalse: [self errorTable at: anInteger])
!

reportErrorMessage: aString
        Smalltalk isSmalltalkX ifTrue:[
            errorToken ifNotNil:[
                | errorMessage |
                errorMessage := ((errorToken value = '') and:[scanner stream atEnd])
                                    ifTrue:['Unexpected end of file']
                                    ifFalse:[aString].
                SmaCCParserError raiseSignal: errorMessage with: self
            ] ifNil:[
                SmaCCParserError raiseSignal: aString with:self
            ]
        ] ifFalse:[
            SmaCCParserError signal: aString with: self
        ]

    "Modified: / 05-01-2007 / 13:04:48 / janfrog"
    "Modified: / 29-03-2010 / 13:15:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

willShift: potentialStateStack 
	| action compoundAction reduceEntry size |
	compoundAction := self actionForState: potentialStateStack last
				and: currentToken id first.
	action := compoundAction bitAnd: self actionMask.
	action == self shiftAction ifTrue: [^true].
	action == self reduceAction 
		ifTrue: 
			[reduceEntry := self reduceTable at: (compoundAction bitShift: -2).
			size := reduceEntry at: 2.
			size timesRepeat: [potentialStateStack removeLast].
			potentialStateStack 
				add: ((self actionForState: potentialStateStack last
						and: (reduceEntry at: 1)) bitShift: -2).
			^self willShift: potentialStateStack].
	^false
! !

!SmaCCParser methodsFor:'public'!

isEOFToken
	^currentToken id first = self emptySymbolTokenId
! !

!SmaCCParser class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/smaCC/SmaCC__SmaCCParser.st,v 1.4 2007-01-05 15:16:41 vranyj1 Exp $'
!

version_SVN
    ^ '$Id$'
! !
