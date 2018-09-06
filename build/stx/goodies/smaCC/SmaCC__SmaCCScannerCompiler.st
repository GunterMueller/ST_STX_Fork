"{ Package: 'stx:goodies/smaCC' }"

"{ NameSpace: SmaCC }"

Object subclass:#SmaCCScannerCompiler
	instanceVariableNames:'grammar scannerClass scannerDefinitionString'
	classVariableNames:''
	poolDictionaries:''
	category:'SmaCC-Parser Generator'
!

SmaCCScannerCompiler comment:'SmaCCScannerCompiler represents the compiler for the scanner part of the parser.

Instance Variables:
	grammar	<SmaCCGrammar>	the grammar that defines the scanner
	scannerClass	<RBAbstractClass>	the class to compile the scanner into
	scannerDefinitionString	<String>	the string that defines the scanner'
!


!SmaCCScannerCompiler methodsFor:'accessing'!

scannerClass
	^scannerClass
!

scannerClass: anObject
	scannerClass := anObject
!

scannerDefinitionString: aString
	scannerDefinitionString := aString
!

symbols
	^grammar symbols
! !

!SmaCCScannerCompiler methodsFor:'compiling-scanner'!

addActionsForSymbols
        | selectorMap |
        selectorMap := Dictionary new.
        (1 to: self symbols size) with: self symbols
                do: 
                        [:index :each | |eachRegex selector|

                        eachRegex := each regularExpression.
                        eachRegex notNil ifTrue: 
                                        [
                                        selector := (self scannerActionFor: each name). 
                                        selector notNil ifTrue: [selectorMap at: index put: selector].
                                        eachRegex action: index].
                        each createIdMethod ifTrue: [self compileTokenIdMethodFor: each]].
        ^selectorMap
!

addSpecialSymbols
	grammar tokens keysDo: 
			[:each | 
			(self scannerActionFor: each) notNil 
				ifTrue: [grammar terminalSymbolNamed: each]]
!

compileEmptySymbolTokenId
        | stream |
        stream := WriteStream on: (String new: 100).
        stream
                nextPutAll: 'emptySymbolTokenId';
                cr;
                tab;
                nextPutAll: '^';
                nextPutAll: (self symbols identityIndexOf: SmaCCSymbol empty) printString.
        self scannerClass compile: stream contents classified: #'generated-tokens'

    "Modified: / 06-09-2005 / 20:41:47 / janfrog"
!

compileErrorSymbolTokenId
        | stream |
        stream := WriteStream on: (String new: 100).
        stream
                nextPutAll: 'errorTokenId';
                cr;
                tab;
                nextPutAll: '^';
                nextPutAll: (self symbols identityIndexOf: SmaCCSymbol error) printString.
        self scannerClass compile: stream contents classified: #'generated-tokens'

    "Modified: / 06-09-2005 / 20:41:58 / janfrog"
!

compileKeywordInitializerUsing: aDictionary selectorMap: selectorMapDictionary 
	| stream dataStream |
	aDictionary isEmpty ifTrue: [^self].
	stream := WriteStream on: String new.
	stream nextPutAll: 'initializeKeywordMap'.
	stream nextPutAll: ' keywordMap :=  Dictionary new. '.
	dataStream := WriteStream on: Array new.
	aDictionary keysAndValuesDo: 
			[:key :value | 
			value keys asSortedCollection do: 
					[:each | 
					dataStream nextPut: (Array 
								with: (selectorMapDictionary at: key ifAbsent: [key])
								with: each
								with: (selectorMapDictionary at: (value at: each) ifAbsent: [value at: each]))]].
	stream
		nextPutAll: '#(';
		cr.
	dataStream contents do: 
			[:each | 
			stream nextPutAll: '#('.
			each do: [:item | item storeOn: stream] separatedBy: [stream nextPut: $ ].
			stream nextPut: $)]
		separatedBy: [stream cr].
	stream nextPut: $).
	stream 
		nextPutAll: ' do: [:each | (keywordMap at: each first ifAbsentPut: [Dictionary new]) at: (each at: 2) put: each last]. ^keywordMap'.
	scannerClass metaclass 
		compile: (RBParser parseMethod: stream contents) formattedCode
		classified: #'generated-initialization'
!

compileScanner
	| regex selectorMap regexPartition dfa keywordmap |
	regex := nil.
	self addSpecialSymbols.
	grammar 
		symbols: (self symbols asSortedCollection: 
					[:a :b | 
					| aRegex bRegex |
					aRegex := a regularExpression.
					bRegex := b regularExpression.
					bRegex isNil or: 
							[aRegex notNil 
								and: [(aRegex position ifNil: [0]) < (bRegex position ifNil: [0])]]]).
	selectorMap := self addActionsForSymbols.
	regexPartition := self regularExpressionsPartitionedByIsKeyword.
	regex := self generalRegexesFrom: regexPartition.
	dfa := regex asDFA.
	keywordmap := Dictionary new.
	(regexPartition at: true ifAbsent: [#()]) do: 
			[:each | 
			| action strings newAction |
			strings := each possibleMatches.
			1 to: strings size
				do: 
					[:i | 
					newAction := dfa simulate: (ReadStream on: (strings at: i)).
					i = 1 
						ifTrue: [action := newAction]
						ifFalse: [action = newAction ifFalse: [action := nil]]].
			action isNil 
				ifTrue: [regex := regex | each]
				ifFalse: 
					[action do: 
							[:state | 
							strings do: 
									[:string | 
									(keywordmap at: state ifAbsentPut: [Dictionary new]) at: string
										put: each action]]]].
	self compileKeywordInitializerUsing: keywordmap selectorMap: selectorMap.
	regex asDFA compileInto: scannerClass usingSelectorMap: selectorMap.
	self compileEmptySymbolTokenId.
	self compileErrorSymbolTokenId.
	SmaCCGrammar ignoreCase 
		ifTrue: 
			[scannerClass compile: 'keywordFor: aString 
	^aString asUppercase'
				classified: #'generated-scanner']
!

compileScannerDefinitionComment
        | stream |
        stream := WriteStream on: (String new: 1000).
        stream
                nextPutAll: 'scannerDefinitionComment';
                cr;
                cr;
                tab;
                nextPut: $";
                nextPutAll: (scannerDefinitionString copyReplaceAll: $" withAll:'""');
                nextPut: $".
        self scannerClass metaclass compile: stream contents
                classified: #'generated-comments'
!

compileTokenIdMethodFor: aTerminalSymbol 
        | stream |
        stream := WriteStream on: (String new: 1000).
        stream
                nextPutAll: (aTerminalSymbol name copyFrom: 2
                                        to: aTerminalSymbol name size - 1);
                nextPutAll: 'Id';
                cr;
                tab;
                nextPutAll: '^';
                nextPutAll: (self symbols identityIndexOf: aTerminalSymbol) printString.
        scannerClass compile: stream contents classified: #'generated-tokens'

    "Modified: / 06-09-2005 / 20:42:43 / janfrog"
!

generalRegexesFrom: regexPartition 
	| regexs combinedRegex |
	regexs := regexPartition at: false ifAbsent: [regexPartition at: true].
	combinedRegex := regexs first.
	2 to: regexs size
		do: [:i | combinedRegex := combinedRegex | (regexs at: i)].
	^combinedRegex
!

regularExpressionsPartitionedByIsKeyword
        | regexPartition |
        regexPartition := Dictionary new.
        self symbols do: 
                        [:each |  |regex|
                        regex := each regularExpression.
                        regex notNil ifTrue: 
                                        [
                                        (regexPartition at: regex isKeywordLiteral
                                                ifAbsentPut: [OrderedCollection new]) add: regex]].
        ^regexPartition
!

scannerActionFor: aString
	| selector |
	aString size > 2 ifFalse: [^nil].
	selector := (aString copyFrom: 2 to: aString size - 1) asSymbol.
	^((scannerClass definesMethod: selector) 
		and: [(Object canUnderstand: selector) not and: [selector argumentCount = 0]]) 
			ifTrue: [selector]
			ifFalse: [nil]
! !

!SmaCCScannerCompiler methodsFor:'initialize-release'!

grammar: aGrammar
	grammar := aGrammar
!

parseTokens
	grammar tokens: (SmaCCScannerParser parse: scannerDefinitionString)
! !

!SmaCCScannerCompiler class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/smaCC/SmaCC__SmaCCScannerCompiler.st,v 1.1 2006-02-09 21:14:22 vranyj1 Exp $'
!

version_SVN
    ^ '$Id$'
! !
