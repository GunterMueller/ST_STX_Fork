"{ Package: 'stx:goodies/petitparser/parsers/smalltalk/tests' }"

PPCompositeParserTest subclass:#PPSmalltalkGrammarTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitSmalltalk-Tests'
!


!PPSmalltalkGrammarTests class methodsFor:'accessing'!

packageNamesUnderTest
	^ #('PetitSmalltalk')
! !

!PPSmalltalkGrammarTests methodsFor:'accessing'!

parserClass
	^ PPSmalltalkGrammar
! !

!PPSmalltalkGrammarTests methodsFor:'testing'!

testArray1
	self 
		parse: '{}'
		rule: #array
!

testArray2
	self 
		parse: '{self foo}'
		rule: #array
!

testArray3
	self 
		parse: '{self foo. self bar}'
		rule: #array
!

testArray4
	self 
		parse: '{self foo. self bar.}'
		rule: #array
!

testAssignment1
	self 
		parse: '1'
		rule: #expression
!

testAssignment2
	self 
		parse: 'a := 1'
		rule: #expression
!

testAssignment3
	self 
		parse: 'a := b := 1'
		rule: #expression
!

testAssignment4
	PPSmalltalkGrammar allowUnderscoreAssignment
		ifTrue: [ self parse: 'a _ 1' rule: #expression ]
		ifFalse: [ self fail: 'a _ 1' rule: #expression ]
!

testAssignment5
	PPSmalltalkGrammar allowUnderscoreAssignment
		ifTrue: [ self parse: 'a _ b _ 1' rule: #expression ]
		ifFalse: [ self fail: 'a _ b _ 1' rule: #expression ]
!

testAssignment6
	self 
		parse: 'a := (b := c)'
		rule: #expression
!

testBlock1
	self 
		parse: '[]'
		rule: #block
!

testComment1
	self 
		parse: '1"one"+2'
		rule: #expression
!

testComment2
	self 
		parse: '1 "one" +2'
		rule: #expression
!

testComment3
	self 
		parse: '1"one"+"two"2'
		rule: #expression
!

testComment4
	self 
		parse: '1"one""two"+2'
		rule: #expression
!

testComment5
	self 
		parse: '1"one"	"two"+2'
		rule: #expression
!

testComment6a
        "Tests Smalltalk/X EOL comments"
        self 
                parse: '1+2"/ xxxxx'
                rule: #expression.

    "Created: / 07-11-2014 / 01:50:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testComment6b
        "Tests Smalltalk/X EOL comments"
        self 
                parse: '1"/ xxxxx
                        +2 "/yyyy'
                rule: #expression.

    "Created: / 07-11-2014 / 01:50:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testComment6c
        "Tests Smalltalk/X EOL comments"
        self 
                parse: ('1"/ xxxxx', (Character codePoint: 13) asString, ' + 1')
                rule: #expression.

    "Created: / 07-11-2014 / 01:51:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testComment6d
        "Tests Smalltalk/X EOL comments"
        self 
                parse: ('1"/ xxxxx', (Character codePoint: 10) asString, ' + 1')
                rule: #expression.

    "Created: / 07-11-2014 / 01:51:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testComment6e
        "Tests Smalltalk/X EOL comments"
        self 
                parse: ('1"/ xxxxx', (Character codePoint: 13) asString, (Character codePoint: 10) asString, ' + 1')
                rule: #expression.

    "Created: / 07-11-2014 / 01:51:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testCompleteness
	"This test asserts that all subclasses override all test methods."
	
	self class allSubclasses do: [ :subclass |
		self class testSelectors do: [ :selector |
			self 
				assert: (selector = #testCompleteness or: [ subclass selectors includes: selector ])
				description: subclass printString , ' does not test ' , selector printString ] ]
!

testMethod1
	self 
		parse: 'negated ^ 0 - self'
		rule: #method
!

testMethod2
	"Spaces at the beginning of the method."
	self 
		parse: '	  negated ^ 0 - self'
		rule: #method
!

testMethod3
	"Spaces at the end of the method."
	self 
		parse: '	negated ^ 0 - self  '
		rule: #method
!

testSequence1
	self 
		parse: '| a | 1 . 2'
		rule: #sequence
!

testStatements1
	self 
		parse: '1'
		rule: #sequence
!

testStatements2
	self 
		parse: '1 . 2'
		rule: #sequence
!

testStatements3
	self 
		parse: '1 . 2 . 3'
		rule: #sequence
!

testStatements4
	self 
		parse: '1 . 2 . 3 .'
		rule: #sequence
!

testStatements5
	self 
		parse: '1 . . 2'
		rule: #sequence
!

testStatements6
	self 
		parse: '1. 2'
		rule: #sequence
!

testStatements7
	self 
		parse: '. 1'
		rule: #sequence
!

testStatements8
	self 
		parse: '.1'
		rule: #sequence
!

testStatements9
	self 
		parse: ''
		rule: #statements
!

testTemporaries1
	self 
		parse: '| a |'
		rule: #sequence
!

testTemporaries2
	self 
		parse: '| a b |'
		rule: #sequence
!

testTemporaries3
	self 
		parse: '| a b c |'
		rule: #sequence
!

testVariable1
	self 
		parse: 'trueBinding'
		rule: #primary
!

testVariable2
	self 
		parse: 'falseBinding'
		rule: #primary
!

testVariable3
	self 
		parse: 'nilly'
		rule: #primary
!

testVariable4
	self 
		parse: 'selfish'
		rule: #primary
!

testVariable5
	self 
		parse: 'supernanny'
		rule: #primary
!

testVariable6
	PPSmalltalkGrammar allowUnderscoreAssignment ifFalse: [
		self 
			parse: 'super_nanny'
			rule: #primary ]
!

testVariable7
	PPSmalltalkGrammar allowUnderscoreAssignment ifFalse: [
		self 
			parse: '__gen_var_123__'
			rule: #primary ]
! !

!PPSmalltalkGrammarTests methodsFor:'testing-blocks'!

testArgumentsBlock1
	self 
		parse: '[ :a | ]'
		rule: #block
!

testArgumentsBlock2
	self 
		parse: '[ :a :b | ]'
		rule: #block
!

testArgumentsBlock3
	self 
		parse: '[ :a :b :c | ]'
		rule: #block
!

testComplexBlock1
	self 
		parse: '[ :a | | b | c ]'
		rule: #block
!

testComplexBlock2
	self 
		parse: '[:a||b|c]'
		rule: #block
!

testSimpleBlock1
	self 
		parse: '[ ]'
		rule: #block
!

testSimpleBlock2
	self 
		parse: '[ nil ]'
		rule: #block
!

testSimpleBlock3
	self 
		parse: '[ :a ]'
		rule: #block
!

testStatementBlock1
	self 
		parse: '[ nil ]'
		rule: #block
!

testStatementBlock2
	self 
		parse: '[ | a | nil ]'
		rule: #block
!

testStatementBlock3
	self 
		parse: '[ | a b | nil ]'
		rule: #block
! !

!PPSmalltalkGrammarTests methodsFor:'testing-literals'!

testArrayLiteral1
	self 
		parse: '#()'
		rule: #arrayLiteral
!

testArrayLiteral10
	self 
		parse: '#((1 2) #(1 2 3))'
		rule: #arrayLiteral
!

testArrayLiteral11
	self 
		parse: '#([1 2] #[1 2 3])'
		rule: #arrayLiteral
!

testArrayLiteral2
	self 
		parse: '#(1)'
		rule: #arrayLiteral
!

testArrayLiteral3
	self 
		parse: '#(1 2)'
		rule: #arrayLiteral
!

testArrayLiteral4
	self 
		parse: '#(true false nil)'
		rule: #arrayLiteral
!

testArrayLiteral5
	self 
		parse: '#($a)'
		rule: #arrayLiteral
!

testArrayLiteral6
	self 
		parse: '#(1.2)'
		rule: #arrayLiteral
!

testArrayLiteral7
	self 
		parse: '#(size #at: at:put: #''=='')'
		rule: #arrayLiteral
!

testArrayLiteral8
	self 
		parse: '#(''baz'')'
		rule: #arrayLiteral
!

testArrayLiteral9
	self 
		parse: '#((1) 2)'
		rule: #arrayLiteral
!

testByteLiteral1
	self 
		parse: '#[]'
		rule: #byteLiteral
!

testByteLiteral2
	self 
		parse: '#[0]'
		rule: #byteLiteral
!

testByteLiteral3
	self 
		parse: '#[255]'
		rule: #byteLiteral
!

testByteLiteral4
	self 
		parse: '#[ 1 2 ]'
		rule: #byteLiteral
!

testByteLiteral5
	self 
		parse: '#[ 2r1010 8r77 16rFF ]'
		rule: #byteLiteral
!

testCharLiteral1
	self 
		parse: '$a'
		rule: #charLiteral
!

testCharLiteral2
	self 
		parse: '$ '
		rule: #charLiteral
!

testCharLiteral3
	self 
		parse: '$$'
		rule: #charLiteral
!

testNumberLiteral1
	self 
		parse: '0'
		rule: #numberLiteral
!

testNumberLiteral10
	self 
		parse: '10r10'
		rule: #numberLiteral
!

testNumberLiteral11
	self 
		parse: '8r777'
		rule: #numberLiteral
!

testNumberLiteral12
	self 
		parse: '16rAF'
		rule: #numberLiteral
!

testNumberLiteral13
	self 
		parse: '16rCA.FE'
		rule: #numberLiteral
!

testNumberLiteral14
	self 
		parse: '3r-22.2'
		rule: #numberLiteral
!

testNumberLiteral15
    ((Smalltalk respondsTo: #isSmalltalkX) and:[ Smalltalk isSmalltalkX ]) ifTrue:[ 
        ^ self.
    ].
    self 
            parse: '0.50s2'
            rule: #numberLiteral

    "Modified: / 07-10-2014 / 23:02:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testNumberLiteral2
	self 
		parse: '0.1'
		rule: #numberLiteral
!

testNumberLiteral3
	self 
		parse: '123'
		rule: #numberLiteral
!

testNumberLiteral4
	self 
		parse: '123.456'
		rule: #numberLiteral
!

testNumberLiteral5
	self 
		parse: '-0'
		rule: #numberLiteral
!

testNumberLiteral6
	self 
		parse: '-0.1'
		rule: #numberLiteral
!

testNumberLiteral7
	self 
		parse: '-123'
		rule: #numberLiteral
!

testNumberLiteral8
	self 
		parse: '-123'
		rule: #numberLiteral
!

testNumberLiteral9
	self 
		parse: '-123.456'
		rule: #numberLiteral
!

testSpecialLiteral1
	self 
		parse: 'true'
		rule: #trueLiteral
!

testSpecialLiteral2
	self 
		parse: 'false'
		rule: #falseLiteral
!

testSpecialLiteral3
	self 
		parse: 'nil'
		rule: #nilLiteral
!

testStringLiteral1
	self 
		parse: ''''''
		rule: #stringLiteral
!

testStringLiteral2
	self 
		parse: '''ab'''
		rule: #stringLiteral
!

testStringLiteral3
	self 
		parse: '''ab''''cd'''
		rule: #stringLiteral
!

testSymbolLiteral1
	self 
		parse: '#foo'
		rule: #symbolLiteral
!

testSymbolLiteral2
	self 
		parse: '#+'
		rule: #symbolLiteral
!

testSymbolLiteral3
	self 
		parse: '#key:'
		rule: #symbolLiteral
!

testSymbolLiteral4
	self 
		parse: '#key:value:'
		rule: #symbolLiteral
!

testSymbolLiteral5
	self 
		parse: '#''testing-result'''
		rule: #symbolLiteral
!

testSymbolLiteral6
	PPSmalltalkGrammar allowUnderscoreAssignment ifFalse: [
		self 
			parse: '#__gen__binding'
			rule: #symbolLiteral ]
!

testSymbolLiteral7
	self 
		parse: '# fucker'
		rule: #symbolLiteral
!

testSymbolLiteral8
	self 
		parse: '##fucker'
		rule: #symbolLiteral
!

testSymbolLiteral9
	self 
		parse: '## fucker'
		rule: #symbolLiteral
! !

!PPSmalltalkGrammarTests methodsFor:'testing-messages'!

testBinaryExpression1
	self 
		parse: '1 + 2'
		rule: #expression
!

testBinaryExpression2
	self 
		parse: '1 + 2 + 3'
		rule: #expression
!

testBinaryExpression3
	self 
		parse: '1 // 2'
		rule: #expression
!

testBinaryExpression4
	self 
		parse: '1 -- 2'
		rule: #expression
!

testBinaryExpression5
	self 
		parse: '1 ==> 2'
		rule: #expression.
!

testBinaryMethod1
	self 
		parse: '+ a'
		rule: #method
!

testBinaryMethod2
	self 
		parse: '+ a | b |'
		rule: #method
!

testBinaryMethod3
	self 
		parse: '+ a b'
		rule: #method
!

testBinaryMethod4
	self 
		parse: '+ a | b | c'
		rule: #method
!

testBinaryMethod5
	self 
		parse: '-- a'
		rule: #method
!

testCascadeExpression1
	self 
		parse: '1 abs; negated'
		rule: #expression
!

testCascadeExpression2
	self 
		parse: '1 abs negated; raisedTo: 12; negated'
		rule: #expression
!

testCascadeExpression3
	self 
		parse: '1 + 2; - 3'
		rule: #expression
!

testKeywordExpression1
	self 
		parse: '1 to: 2'
		rule: #expression
!

testKeywordExpression2
	self 
		parse: '1 to: 2 by: 3'
		rule: #expression
!

testKeywordExpression3
	self 
		parse: '1 to: 2 by: 3 do: 4'
		rule: #expression
!

testKeywordMethod1
	self 
		parse: 'to: a'
		rule: #method
!

testKeywordMethod2
	self 
		parse: 'to: a do: b | c |'
		rule: #method
!

testKeywordMethod3
	self 
		parse: 'to: a do: b by: c d'
		rule: #method
!

testKeywordMethod4
	self 
		parse: 'to: a do: b by: c | d | e'
		rule: #method
!

testUnaryExpression1
	self 
		parse: '1 abs'
		rule: #expression
!

testUnaryExpression2
	self 
		parse: '1 abs negated'
		rule: #expression
!

testUnaryMethod1
	self 
		parse: 'abs'
		rule: #method
!

testUnaryMethod2
	self 
		parse: 'abs | a |'
		rule: #method
!

testUnaryMethod3
	self 
		parse: 'abs a'
		rule: #method
!

testUnaryMethod4
	self 
		parse: 'abs | a | b'
		rule: #method
!

testUnaryMethod5
	self 
		parse: 'abs | a |'
		rule: #method
! !

!PPSmalltalkGrammarTests methodsFor:'testing-pragmas'!

testPragma1
	self 
		parse: 'method <foo>'
		rule: #method
!

testPragma10
	self 
		parse: 'method <foo: bar>'
		rule: #method
!

testPragma11
	self 
		parse: 'method <foo: true>'
		rule: #method
!

testPragma12
	self 
		parse: 'method <foo: false>'
		rule: #method
!

testPragma13
	self 
		parse: 'method <foo: nil>'
		rule: #method
!

testPragma14
	self 
		parse: 'method <foo: ()>'
		rule: #method
!

testPragma15
	self 
		parse: 'method <foo: #()>'
		rule: #method
!

testPragma16
	self 
		parse: 'method < + 1 >'
		rule: #method
!

testPragma2
	self 
		parse: 'method <foo> <bar>'
		rule: #method
!

testPragma3
	self 
		parse: 'method | a | <foo>'
		rule: #method
!

testPragma4
	self 
		parse: 'method <foo> | a |'
		rule: #method
!

testPragma5
	self 
		parse: 'method <foo> | a | <bar>'
		rule: #method
!

testPragma6
	self 
		parse: 'method <foo: 1>'
		rule: #method
!

testPragma7
	self 
		parse: 'method <foo: 1.2>'
		rule: #method
!

testPragma8
	self 
		parse: 'method <foo: ''bar''>'
		rule: #method
!

testPragma9
	self 
		parse: 'method <foo: #''bar''>'
		rule: #method
! !

!PPSmalltalkGrammarTests class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

