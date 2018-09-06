"{ Package: 'stx:goodies/petitparser/tests' }"

"{ NameSpace: Smalltalk }"

PPArithmeticParserTest subclass:#PPExpressionParserTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitTests-Tests'
!


!PPExpressionParserTest class methodsFor:'testing'!

shouldInheritSelectors
	^ true
! !

!PPExpressionParserTest methodsFor:'accessing'!

parserInstance
	| expression parens number |
	expression := PPExpressionParser new.
	parens := $( asParser trim , expression , $) asParser trim
		==> [ :value | value second ].
	number := (#digit asParser plus , ($. asParser , #digit asParser plus) optional) flatten trim
		==> [ :value | value asNumber ].
	expression term: parens / number.
	expression
		group: [ :g |
			g prefix: $- asParser trim do: [ :op :a | a negated ] ];
		group: [ :g |
			g postfix: '++' asParser trim do: [ :a :op | a + 1 ].
			g postfix: '--' asParser trim do: [ :a :op | a - 1 ] ];
		group: [ :g |
			g right: $^ asParser trim do: [ :a :op :b | a raisedTo: b ] ];
		group: [ :g |
			g left: $* asParser trim do: [ :a :op :b | a * b ].
			g left: $/ asParser trim do: [ :a :op :b | a / b ] ];
		group: [ :g |
			g left: $+ asParser trim do: [ :a :op :b | a + b ].
			g left: $- asParser trim do: [ :a :op :b | a - b ] ].
	^ expression end
! !

!PPExpressionParserTest methodsFor:'testing'!

testPostfixAdd
	self assert: '0++' is: 1.
	self assert: '0++++' is: 2.
	self assert: '0++++++' is: 3.

	self assert: '0+++1' is: 2.
	self assert: '0+++++1' is: 3.
	self assert: '0+++++++1' is: 4
!

testPostfixSub
	self assert: '1--' is: 0.
	self assert: '2----' is: 0.
	self assert: '3------' is: 0.

	self assert: '2---1' is: 0.
	self assert: '3-----1' is: 0.
	self assert: '4-------1' is: 0.
!

testPrefixNegate
	self assert: '1' is: 1.
	self assert: '-1' is: -1.
	self assert: '--1' is: 1.
	self assert: '---1' is: -1
! !

!PPExpressionParserTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/PPExpressionParserTest.st,v 1.4 2014-03-04 14:34:13 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/PPExpressionParserTest.st,v 1.4 2014-03-04 14:34:13 cg Exp $'
!

version_SVN
    ^ '$Id: PPExpressionParserTest.st,v 1.4 2014-03-04 14:34:13 cg Exp $'
! !

