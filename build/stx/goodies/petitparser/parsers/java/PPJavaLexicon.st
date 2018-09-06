"{ Package: 'stx:goodies/petitparser/parsers/java' }"

"{ NameSpace: Smalltalk }"

PPCompositeParser subclass:#PPJavaLexicon
	instanceVariableNames:'unicodeEscape rawInputCharacter unicodeMarker hexDigit
		lineTerminator unicodeInputCharacter inputElements sub
		inputElement whiteSpace comment javaToken keyword literal
		separator operator identifier traditionalComment endOfLineComment
		commentTail charactersInLine commentTailStar notStar
		notStarNotSlash inputCharacter booleanLiteral nullLiteral
		identifierChars javaLetter javaLetterOrDigit keywords
		floatingPointLiteral integerLiteral characterLiteral
		stringLiteral hexIntegerLiteral octalIntegerLiteral
		decimalIntegerLiteral decimalNumeral integerTypeSuffix hexNumeral
		octalNumeral nonZeroDigit digits hexDigits octalDigits octalDigit
		hexadecimalFloatingPointLiteral decimalFloatingPointLiteral
		exponentPart floatTypeSuffix exponentIndicator signedInteger sign
		hexSignificand binaryExponent binaryExponentIndicator
		escapeSequence singleCharacter stringCharacters stringCharacter
		octalEscape zeroToThree input operators separators trueToken
		falseToken nullToken'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitJava-Core'
!

PPJavaLexicon comment:'A parser with a definitions for some basic Java gramar partsGrammar rules follow as closely as possible the specification found in "The Java Language Specification Third Edition"URL = '
!


!PPJavaLexicon class methodsFor:'accessing'!

ignoredNames
	"Answer a collection of instance-variables that should not be automatically initialized with productions, but that are used internal to the composite parser."

	| newArray |	
	newArray := Array new: ((self namesToIgnore size) + (super ignoredNames size)).
	newArray
		replaceFrom: 1
		to: self namesToIgnore size
		with: self namesToIgnore.
	newArray
		replaceFrom: (self namesToIgnore size + 1)
		to: newArray size
		with: super ignoredNames.	
	^newArray
!

namesToIgnore

	^#('keywords' 'operators' 'separators')
! !

!PPJavaLexicon methodsFor:'accessing'!

start
	"Default start production."

	^ input end
! !

!PPJavaLexicon methodsFor:'grammar-comments'!

charactersInLine   

	^ inputCharacter plus
!

comment
	"traditional -> /*
	 endOfLine -> //"
	^ traditionalComment / endOfLineComment
!

commentTail

	^ 	('*' asParser , commentTailStar ) /
		(notStar , commentTail)
!

commentTailStar 

	^ ('/' asParser ) /
	  ('*' asParser , commentTailStar ) /
	  (notStarNotSlash , commentTail )
!

endOfLineComment 

	^ '//' asParser , charactersInLine optional
!

notStar

	^  ('*' asParser not , inputCharacter)/lineTerminator
!

notStarNotSlash  

	^ lineTerminator / ((PPPredicateObjectParser anyOf: '*/') not , inputCharacter )
!

traditionalComment

	^ '/*' asParser , commentTail
! !

!PPJavaLexicon methodsFor:'grammar-identifiers'!

identifier 

	^  self asToken: (((keyword not) , (booleanLiteral not) , (nullLiteral not) , identifierChars ))
!

identifierChars
	
	^ javaLetter plus , javaLetterOrDigit star
!

javaLetter

	^ (#letter asParser) / (PPPredicateObjectParser anyOf: '_$')
!

javaLetterOrDigit

	^ javaLetter / (#digit asParser)
! !

!PPJavaLexicon methodsFor:'grammar-input'!

input

	^ (inputElements optional) , (sub optional)
!

inputElement

	^ whiteSpace / comment / javaToken
!

inputElements

	^ inputElement plus
!

javaToken


	^ identifier / keyword / literal / separator / operator
!

sub

	^ (Character value: 26) asParser 
! !

!PPJavaLexicon methodsFor:'grammar-keywords'!

keyword

        | keywordParsers |
        
        keywordParsers := keywords keys asSortedCollection collect: [:eachKey | keywords at: eachKey ].
        ^ self asToken: ( (keywordParsers reduce: [ :a :b | a / b ]) )

    "Modified (format): / 21-04-2015 / 15:27:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPJavaLexicon methodsFor:'grammar-lineTerminators'!

inputCharacter 

	^(lineTerminator not) , unicodeInputCharacter ==> #second
!

lineTerminator

    self flag: 'Hack alert - should be fixed immediately in PJTraditionalCommentsNode>>comment:'.

        ^ (((Character codePoint: 10) asParser) ==> [ :lf | Array with: lf with: nil ])
          / (((Character codePoint: 13) asParser , ((Character codePoint: 10) asParser ) optional )) ==> [ :nodes | Array with: nodes first with: nil ]

    "Modified: / 21-04-2015 / 17:16:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPJavaLexicon methodsFor:'grammar-literals'!

literal
	"a literal must be a single token. Whitespaces are not allowed inside the literal"
	
	^ nullLiteral / booleanLiteral / floatingPointLiteral / integerLiteral / characterLiteral / stringLiteral
! !

!PPJavaLexicon methodsFor:'grammar-literals-boolean'!

booleanLiteral 

 ^ trueToken / falseToken
!

falseToken
	^ ('false' asParser , #word asParser not) javaToken
!

nullToken
	^ ('null' asParser , #word asParser not) javaToken
!

trueToken
	^ ('true' asParser , #word asParser not) javaToken
! !

!PPJavaLexicon methodsFor:'grammar-literals-character'!

characterLiteral 

 ^ ($' asParser , ( escapeSequence / singleCharacter ), $' asParser) javaToken
!

singleCharacter 	

	^( PPPredicateObjectParser anyOf: '''\') not , inputCharacter ==> #second
! !

!PPJavaLexicon methodsFor:'grammar-literals-escape'!

escapeSequence 

	^ ($\ asParser , (PPPredicateObjectParser anyOf: 'btnfr""''\' ) ) /
	   octalEscape 
!

octalEscape

	^ $\ asParser , ( (zeroToThree , octalDigit , octalDigit) / (octalDigit , octalDigit optional) )
!

zeroToThree

	^PPPredicateObjectParser anyOf: '0123'
! !

!PPJavaLexicon methodsFor:'grammar-literals-floating'!

binaryExponent

 ^ binaryExponentIndicator , signedInteger
!

binaryExponentIndicator

  ^ PPPredicateObjectParser anyOf: 'pP'
!

decimalFloatingPointLiteral

	|dot|
	dot := $. asParser.

 ^ ( ( (dot , digits) 
        / 
        (digits , dot , digits optional)) , 
			exponentPart optional , floatTypeSuffix optional ) 
  	/ 
  	(digits , 
		( (exponentPart , floatTypeSuffix optional) 
		  /
		  (exponentPart optional , floatTypeSuffix) ))
!

exponentIndicator

  ^ PPPredicateObjectParser anyOf: 'eE'
!

exponentPart

 ^ exponentIndicator , signedInteger
!

floatTypeSuffix

	^ PPPredicateObjectParser anyOf: 'fFdD'
!

floatingPointLiteral

  ^ (hexadecimalFloatingPointLiteral / decimalFloatingPointLiteral) javaToken
!

hexSignificand 
	|dot|
	dot := $. asParser.

 ^  (hexNumeral , dot optional) /
    ($0 asParser , (PPPredicateObjectParser anyOf: 'xX') , hexDigits optional , dot , hexDigits )
!

hexadecimalFloatingPointLiteral

 ^ hexSignificand , binaryExponent , floatTypeSuffix optional
!

sign

  ^PPPredicateObjectParser anyOf: '-+'
!

signedInteger

  ^ sign optional , digits
! !

!PPJavaLexicon methodsFor:'grammar-literals-integer'!

decimalIntegerLiteral

 ^ decimalNumeral , (integerTypeSuffix optional)
!

decimalNumeral 

	^($0 asParser) / (nonZeroDigit , digits optional) 
!

digits 
	"digit is already defined, no need to redefine it"
	^#digit asParser plus
!

hexDigits 

	^hexDigit plus
!

hexIntegerLiteral 

  ^ hexNumeral , (integerTypeSuffix optional)
!

hexNumeral 

	^$0 asParser, (PPPredicateObjectParser anyOf: 'xX' ), hexDigits
!

integerLiteral

  ^ (hexIntegerLiteral / octalIntegerLiteral / decimalIntegerLiteral) javaToken
!

integerTypeSuffix

	^ PPPredicateObjectParser anyOf: 'lL'
!

nonZeroDigit 

	^PPPredicateObjectParser anyOf: '123456789'.
!

octalDigit 

	^PPPredicateObjectParser anyOf: '01234567'
!

octalDigits

	^ octalDigit plus
!

octalIntegerLiteral 

 ^ octalNumeral , (integerTypeSuffix optional)
!

octalNumeral 

	^($0 asParser) , octalDigits
! !

!PPJavaLexicon methodsFor:'grammar-literals-null'!

nullLiteral 

 ^ nullToken
! !

!PPJavaLexicon methodsFor:'grammar-literals-string'!

stringCharacter
		
	^ ( ( PPPredicateObjectParser anyOf: '"\') not , inputCharacter ==> #second ) /
	   escapeSequence 
!

stringCharacters

	^ stringCharacter plus
!

stringLiteral 

 ^ ($" asParser , stringCharacters optional , $" asParser) javaToken
! !

!PPJavaLexicon methodsFor:'grammar-operators'!

operator
        | operatorParsers |
        
        operatorParsers := operators keys asSortedCollection collect: [:eachKey | operators at: eachKey ].                                                
        ^self asToken:  (operatorParsers reduce: [ :a :b | a / b ])

    "Modified: / 21-04-2015 / 15:26:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPJavaLexicon methodsFor:'grammar-separators'!

separator	
	^self asToken: (PPPredicateObjectParser anyOf: '(){}[];,.' )
! !

!PPJavaLexicon methodsFor:'grammar-unicode-escapes'!

hexDigit 

	^#hex asParser
!

rawInputCharacter

	^#any asParser
!

unicodeEscape

	^ $\ asParser , unicodeMarker , hexDigit , hexDigit , hexDigit , hexDigit
!

unicodeInputCharacter
	 ^ unicodeEscape / rawInputCharacter
!

unicodeMarker

	^$u asParser plus
! !

!PPJavaLexicon methodsFor:'grammar-whiteSpace'!

whiteSpace

	^ (Character space asParser ) /
	  (Character tab asParser ) /
	  ((Character value: 12) asParser ) /
		lineTerminator 
! !

!PPJavaLexicon methodsFor:'initialization'!

initialize

	super initialize.
	
	self initializeKeywords.
	self initializeOperators.
	self initializeSeparators.
!

initializeKeywords

	| values |
	keywords := Dictionary new.
	values := #('abstract' 'assert' 'boolean' 'break' 'byte' 'case'  'catch' 'char' 'class' 'const'
	   'continue' 'default' 'do' 'double' 'else' 'enum' 'extends' 'final'  'finally' 'float'
	   'for' 'if' 'goto' 'implements' 'import' 'instanceof' 'int' 'interface' 'long' 'native'
	   'new' 'package' 'private' 'protected' 'public' 'return' 'short' 'static' 'strictfp' 'super'
	   'switch' 'synchronized' 'this' 'throw' 'throws' 'transient' 'try' 'void' 'volatile' 'while').
	
	values do: [:eachKeyword |
		keywords at: eachKeyword 
			put: (PPUnresolvedParser named: ('keyword', eachKeyword first asUppercase asString , eachKeyword allButFirst))		
		].
	
	keywords keysAndValuesDo:  [:key :value |
		(keywords at: key) def: (key asParser ,  #word asParser not)]
!

initializeOperators

	| values |
	operators := Dictionary new.
	values := #(	'>>>=' '>>>' '>>=' '>>' '>=' '>'	'<<=' '<<' '<=' '<'	'++' '+=' '+'	'--' '-=' '-'	'&&' '&=' '&'
					'||' '|=' '|'	'*=' '*'	'%=' '%'	'/=' '/'	'^=' '^'	'!!=' '!!'	'==' '='	'~'	'?'	':'	'@' ).
	" @ ? perhaps for annotation but not in the doc "
	values do: [:eachOperator |
		operators at: eachOperator 
			put: (PPUnresolvedParser named: ('operator', eachOperator asString))		
		].
	
	operators  keysAndValuesDo:  [:key :value |
		(operators at: key) def: (key asParser)]
!

initializeSeparators

	| values |
	separators := Dictionary new.
	values := #( '(' ')' '{' '}' '[' ']' ';' ',' '.' ).
	
	values do: [:eachSeparator |
		separators at: eachSeparator 
			put: (PPUnresolvedParser named: ('separator', eachSeparator asString))		
		].
	
	separators  keysAndValuesDo:  [:key :value |
		(separators at: key) def: (key asParser)]
! !

!PPJavaLexicon methodsFor:'utility'!

asToken: aParser

	^aParser javaToken
!

emptySquaredParenthesis

	^ self asToken: (((self tokenFor: '['), (self tokenFor: ']')))
!

tokenFor: aString

	^self asToken: (keywords at: aString 
						ifAbsent: [separators at: aString 
							ifAbsent: [operators at: aString] ])
! !

!PPJavaLexicon class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

