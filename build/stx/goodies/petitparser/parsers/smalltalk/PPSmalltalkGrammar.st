"{ Package: 'stx:goodies/petitparser/parsers/smalltalk' }"

PPCompositeParser subclass:#PPSmalltalkGrammar
	instanceVariableNames:'array arrayItem arrayLiteral arrayLiteralArray assignment
		assignmentToken binary binaryExpression binaryMessage
		binaryMethod binaryPragma binaryToken block blockArgument
		blockArguments blockArgumentsWith blockArgumentsWithout blockBody
		byteLiteral byteLiteralArray cascadeExpression cascadeMessage
		char charLiteral charToken expression falseLiteral falseToken
		identifier identifierToken keyword keywordExpression
		keywordMessage keywordMethod keywordPragma keywordToken literal
		message method methodDeclaration methodSequence multiword
		nilLiteral nilToken number numberLiteral numberToken parens
		period periodToken pragma pragmaMessage pragmas primary return
		sequence startExpression startMethod statements string
		stringLiteral stringToken symbol symbolLiteral symbolLiteralArray
		temporaries trueLiteral trueToken unary unaryExpression
		unaryMessage unaryMethod unaryPragma unaryToken variable'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitSmalltalk-Core'
!

PPSmalltalkGrammar comment:'A parser for Smalltalk methods and expressions.'
!

!PPSmalltalkGrammar class methodsFor:'accessing'!

parseExpression: aString
	^ self new parseExpression: aString
!

parseExpression: aString onError: aBlock
	^ self new parseExpression: aString onError: aBlock
!

parseMethod: aString
	^ self new parseMethod: aString
!

parseMethod: aString onError: aBlock
	^ self new parseMethod: aString onError: aBlock
! !

!PPSmalltalkGrammar class methodsFor:'testing'!

allowUnderscoreAssignment
	^ (Scanner respondsTo: #allowUnderscoreAsAssignment) and: [ Scanner allowUnderscoreAsAssignment ]
! !


!PPSmalltalkGrammar methodsFor:'accessing'!

start
	"Default start production."

	^ startMethod
!

startExpression
	"Start production for the expression."

	^ sequence end
!

startMethod
	"Start production for the method."

	^ method end
! !

!PPSmalltalkGrammar methodsFor:'grammar'!

array
	^ ${ asParser smalltalkToken , (expression delimitedBy: periodToken) optional , $} asParser smalltalkToken
!

assignment
	^ variable , assignmentToken
!

expression
	^ assignment star , cascadeExpression
!

literal
	^ numberLiteral / stringLiteral / charLiteral / arrayLiteral / byteLiteral / symbolLiteral / nilLiteral / trueLiteral / falseLiteral
!

message
	^ keywordMessage / binaryMessage / unaryMessage
!

method
	^ methodDeclaration , methodSequence
!

methodDeclaration
	^ keywordMethod / unaryMethod / binaryMethod
!

methodSequence
	^ periodToken star , pragmas , periodToken star , temporaries , periodToken star , pragmas , periodToken star , statements
!

parens
	^ $( asParser smalltalkToken , expression , $) asParser smalltalkToken
!

pragma
	^ $< asParser smalltalkToken , pragmaMessage , $> asParser smalltalkToken
!

pragmas
	^ pragma star
!

primary
	^ literal / variable / block / parens / array
!

return
	^ $^ asParser smalltalkToken , expression
!

sequence
	^ temporaries , periodToken star , statements
!

statements
	^ 	(expression wrapped , ((periodToken plus , statements ==> [ :nodes | nodes first , nodes last ])
								/ periodToken star)
			==> [ :nodes | (Array with: nodes first) , (nodes last) ])
	/	(return , periodToken star
			==> [ :nodes | (Array with: nodes first) , (nodes last) ])
	/	(periodToken star)
!

temporaries
	^ ($| asParser smalltalkToken , variable star , $| asParser smalltalkToken) optional ==> [ :nodes | nodes ifNil: [ #() ] ]
!

variable
	^ identifierToken
! !

!PPSmalltalkGrammar methodsFor:'grammar-blocks'!

block
	^ $[ asParser smalltalkToken , blockBody , $] asParser smalltalkToken
!

blockArgument
	^ $: asParser smalltalkToken , variable
!

blockArguments
	^ blockArgumentsWith / blockArgumentsWithout
!

blockArgumentsWith
	^ blockArgument plus , ($| asParser smalltalkToken / ($] asParser smalltalkToken and ==> [ :node | nil ]))
!

blockArgumentsWithout
	^ nil asParser ==> [ :nodes | Array with: #() with: nil ]
!

blockBody
	^ blockArguments , sequence
! !

!PPSmalltalkGrammar methodsFor:'grammar-literals'!

arrayItem
	^ literal / symbolLiteralArray / arrayLiteralArray / byteLiteralArray
!

arrayLiteral
	^ '#(' asParser smalltalkToken , arrayItem star , $) asParser smalltalkToken
!

arrayLiteralArray
	^ $( asParser smalltalkToken , arrayItem star , $) asParser smalltalkToken
!

byteLiteral
	^ '#[' asParser smalltalkToken , numberLiteral star , $] asParser smalltalkToken
!

byteLiteralArray
	^ $[ asParser smalltalkToken , numberLiteral star , $] asParser smalltalkToken
!

charLiteral
	^ charToken
!

falseLiteral
	^ falseToken
!

nilLiteral
	^ nilToken
!

numberLiteral
	^ numberToken
!

stringLiteral
	^ stringToken
!

symbolLiteral
	"This is totally fucked up: The Pharo compiler allows multiple #, arbitrary spaces between the # and the symbol, as well as comments inbetween. And yes, it is used."

	^ $# asParser smalltalkToken plus , symbol smalltalkToken ==> [ :tokens | tokens first copyWith: tokens last ]
!

symbolLiteralArray
	^ symbol smalltalkToken
!

trueLiteral
	^ trueToken
! !

!PPSmalltalkGrammar methodsFor:'grammar-messages'!

binaryExpression
	^ unaryExpression , binaryMessage star
!

binaryMessage
	^ (binaryToken , unaryExpression) ==> [ :nodes | 
		Array 
			with: (Array with: nodes first)
			with: (Array with: nodes second) ]
!

cascadeExpression
	^ keywordExpression , cascadeMessage star
!

cascadeMessage
	^ $; asParser smalltalkToken , message
!

keywordExpression
	^ binaryExpression , keywordMessage optional
!

keywordMessage
	^ (keywordToken , binaryExpression) plus ==> [ :nodes | 
		Array 
			with: (nodes collect: [ :each | each first ])
			with: (nodes collect: [ :each | each second ]) ]
!

unaryExpression
	^ primary , unaryMessage star
!

unaryMessage
	^ unaryToken ==> [ :node | 
		Array 
			with: (Array with: node)
			with: Array new ]
! !

!PPSmalltalkGrammar methodsFor:'grammar-methods'!

binaryMethod
	^ (binaryToken , variable) ==> [ :nodes | 
		Array 
			with: (Array with: nodes first)
			with: (Array with: nodes second) ]
!

keywordMethod
	^ (keywordToken , variable) plus ==> [ :nodes | 
		Array 
			with: (nodes collect: [ :each | each first ])
			with: (nodes collect: [ :each | each second ]) ]
!

unaryMethod
	^ identifierToken ==> [ :node | 
		Array 
			with: (Array with: node)
			with: Array new ]
! !

!PPSmalltalkGrammar methodsFor:'grammar-pragmas'!

binaryPragma
	^ (binaryToken , arrayItem) ==> [ :nodes | 
		Array 
			with: (Array with: nodes first)
			with: (Array with: nodes second) ]
!

keywordPragma
	^ (keywordToken , arrayItem) plus ==> [ :nodes | 
		Array 
			with: (nodes collect: [ :each | each first ])
			with: (nodes collect: [ :each | each second ]) ]
!

pragmaMessage
	^ keywordPragma / unaryPragma / binaryPragma
!

unaryPragma
	^ identifierToken ==> [ :node | 
		Array 
			with: (Array with: node)
			with: (Array new) ]
! !

!PPSmalltalkGrammar methodsFor:'parsing'!

parseExpression: aString 
	^ self parseExpression: aString onError: [ :msg :pos | self error: msg ]
!

parseExpression: aString onError: aBlock
	^ startExpression parse: aString onError: aBlock
!

parseMethod: aString 
	^ self parseMethod: aString onError: [ :msg :pos | self error: msg ]
!

parseMethod: aString onError: aBlock
	^ startMethod parse: aString onError: aBlock
! !

!PPSmalltalkGrammar methodsFor:'primitives'!

binary
	^ (PPPredicateObjectParser anyOf: '!!%&*+,-/<=>?@\|~') plus
!

char
	^ $$ asParser , #any asParser
!

identifier
	^ self class allowUnderscoreAssignment
		ifTrue: [ #letter asParser , #word asParser star ]
		ifFalse: [
			(PPPredicateObjectParser
				on: [ :each | each isLetter or: [ each = $_ ] ]
				message: 'letter expected') ,
			(PPPredicateObjectParser
				on: [ :each | each isAlphaNumeric or: [ each = $_ ] ]
				message: 'letter or digit expected') star ]
!

keyword
	^ identifier , $: asParser
!

multiword
	^ keyword plus
!

number
    ((Smalltalk respondsTo:#isSmalltalkX) and:[ Smalltalk isSmalltalkX ]) ifTrue:[
        ^ ($- asParser optional , #digit asParser) and , [ :context | 
                [ Number readSmalltalkSyntaxFrom: context stream ] 
                        on: Error
                        do: [ :err | PPFailure message: err messageText at: context position ] ] 
                                asParser

    ] ifFalse:[
        ^ ($- asParser optional , #digit asParser) and , [ :context | 
                [ (NumberParser on: context stream) nextNumber ] 
                        on: Error
                        do: [ :err | PPFailure message: err messageText at: context position ] ] 
                                asParser
    ]

    "Modified: / 07-10-2014 / 21:50:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

period
	^ $. asParser
!

string
	^ $' asParser , ('''''' asParser / $' asParser negate) star , $' asParser
!

symbol
	^ unary / binary / multiword / string
!

unary
	^ identifier , $: asParser not
! !

!PPSmalltalkGrammar methodsFor:'token'!

assignmentToken
	^ self class allowUnderscoreAssignment
		ifTrue: [ (':=' asParser / '_' asParser) smalltalkToken ]
		ifFalse: [ ':=' asParser smalltalkToken ]
!

binaryToken
	^ binary smalltalkToken
!

charToken
	^ char smalltalkToken
!

falseToken
	^ ('false' asParser , #word asParser not) smalltalkToken
!

identifierToken
	^ identifier smalltalkToken
!

keywordToken
	^ keyword smalltalkToken
!

nilToken
	^ ('nil' asParser , #word asParser not) smalltalkToken
!

numberToken
	^ number smalltalkToken
!

periodToken
	^ period smalltalkToken
!

stringToken
	^ string smalltalkToken
!

trueToken
	^ ('true' asParser , #word asParser not) smalltalkToken
!

unaryToken
	^ unary smalltalkToken
! !

