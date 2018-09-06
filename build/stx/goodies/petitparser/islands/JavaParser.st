"{ Package: 'stx:goodies/petitparser/islands' }"

"{ NameSpace: Smalltalk }"

PPCompositeParser subclass:#JavaParser
	instanceVariableNames:'javaClass classDef classBody methodDef arguments methodBody
		methodName block modifiers classId type throws javaClassIsland
		methodModifiers semicolon comment singleLineComment string water'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitIslands-Examples'
!

JavaParser comment:'A JavaParser is a island parser, that can extract method names from a java file.Instance Variables	arguments:		<Object>	block:		<Object>	classBody:		<Object>	classDef:		<Object>	classId:		<Object>	javaClass:		<Object>	javaClassIsland:		<Object>	methodBody:		<Object>	methodDef:		<Object>	methodModifiers:		<Object>	methodName:		<Object>	modifiers:		<Object>	semicolon:		<Object>	throws:		<Object>	type:		<Object>arguments	- xxxxxblock	- xxxxxclassBody	- xxxxxclassDef	- xxxxxclassId	- xxxxxjavaClass	- xxxxxjavaClassIsland	- xxxxxmethodBody	- xxxxxmethodDef	- xxxxxmethodModifiers	- xxxxxmethodName	- xxxxxmodifiers	- xxxxxsemicolon	- xxxxxthrows	- xxxxxtype	- xxxxx'
!

!JavaParser methodsFor:'as yet unclassified'!

start
	^ javaClassIsland
! !

!JavaParser methodsFor:'class'!

block
	^ (${ asParser,
		((block island: water) plus / nil asParser island),
	$} asParser) ==> [:tokens | nil ]
		
!

classBody
	 ^ 
	(${ asParser,
		(
		((methodDef island: water) ==> [:tokens | tokens second]) plus /
		((nil asParser island: water) ==> [ :tokens | OrderedCollection new ])
		),
	$} asParser) ==> [:tokens | tokens second select: [:e | e isNil not ]]
!

classDef
	^ modifiers trim, 'class' asParser, classId trim ==> [:tokens | tokens third ]
!

classId
	^ (#uppercase asParser, (#letter asParser / #digit asParser) star) flatten 
!

javaClass
	^ classDef, ((classBody island:water) ==> [:tokens | tokens second ])
!

javaClassIsland
	^ (javaClass island: water) ==> [:tokens | tokens second]
!

methodModifiers
	^( ('public' asParser / 'private' asParser / 'protected' asParser) optional, 
	  'static' asParser trim optional, 
	  'final' asParser trim optional,
	  'abstract' asParser trim optional,
	  'synchronized' asParser trim optional,	
	  'native' asParser trim optional) ==> [ :tokens | nil ]
!

modifiers
	^ ('public' asParser / 'private' asParser), 'final' asParser trim optional, 'abstract' asParser trim optional
! !

!JavaParser methodsFor:'comments and strings'!

comment
	| end |
	end := '*/' asParser.
	^ ('/*' asParser, (#any asParser starLazy: end), end)
!

singleLineComment
	| end |
	end := #newline asParser.
	^ ('//' asParser, (#any asParser starLazy: end), end)
!

string
	| end |
	end := $" asParser.
	^ ($" asParser, (#any asParser starLazy: end), end)
		name: 'string';
		yourself.
! !

!JavaParser methodsFor:'context'!

updateContext: aPPContext
	super updateContext: aPPContext.
"	aPPContext globalAt: #waterObjects put: (OrderedCollection 
			with: self comment 
			with: self singleLineComment
			with: self string
			with: self block)."
! !

!JavaParser methodsFor:'method'!

arguments
	^ $( asParser, nil asParser island,  $) asParser trim
!

methodBody 
	^ semicolon / block
!

methodDef
	^ methodModifiers, (type island: water), (methodName island:water), (arguments island:water), methodBody ==> [:tokens | tokens third second ]
!

methodName
	^ (#letter asParser, (#letter asParser / #digit asParser) star) flatten 
!

semicolon
	^ ';' asParser
!

throws
	^ 'throws' asParser trim, type trim, ($, asParser, type trim) star
!

type
	^ (#letter asParser, (#letter asParser / #digit asParser) star) flatten 
!

water
	"
		This will allow to skip over
			- Strings, 
			- Comments 
			- and blocks 
		when parsing water. This way, comments and strings cannot confuse the result.
	"

	^ comment / string / singleLineComment / block / #any asParser
! !

