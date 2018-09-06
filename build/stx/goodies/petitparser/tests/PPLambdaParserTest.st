"{ Package: 'stx:goodies/petitparser/tests' }"

"{ NameSpace: Smalltalk }"

PPCompositeParserTest subclass:#PPLambdaParserTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitTests-Tests'
!


!PPLambdaParserTest methodsFor:'accessing'!

parserClass
	^ PPLambdaParser
! !

!PPLambdaParserTest methodsFor:'testing'!

testAbstraction
	self assert: '\x.y' is: #('x' 'y').
	self assert: '\x.\y.z' is: #('x' ('y' 'z'))
!

testApplication
	self assert: '(x x)' is: #('x' 'x').
	self assert: '(x y)' is: #('x' 'y').
	self assert: '((x y) z)' is: #(('x' 'y') 'z').
	self assert: '(x (y z))' is: #('x' ('y' 'z'))
!

testVariable
	self assert: 'x' is: 'x'.
	self assert: 'xy' is: 'xy'.
	self assert: 'x12' is: 'x12'
! !

!PPLambdaParserTest methodsFor:'testing-curch'!

testAnd
	self assert: self parserClass and equals: #('p' #('q' #(#('p' 'q') 'p')))
!

testFalse
	self assert: self parserClass false equals: #('x' #('y' 'y'))
!

testIfThenElse
	self assert: self parserClass ifthenelse equals: #('p' 'p')
!

testNot
	self assert: self parserClass not equals: #('p' #('a' #('b' #(#('p' 'b') 'a'))))
!

testOr
	self assert: self parserClass or equals: #('p' #('q' #(#('p' 'p') 'q')))
!

testTrue
	self assert: self parserClass true equals: #('x' #('y' 'x'))
! !

!PPLambdaParserTest methodsFor:'testing-utilities'!

testParseOnError
	| beenHere |
	result := self parserClass parse: '\x.y' onError: [ self fail ].
	self assert: result equals: #('x' 'y').
	beenHere := false.
	result := self parserClass parse: '\x.' onError: [ beenHere := true ].
	self assert: beenHere.
	beenHere := false.
	result := self parserClass
		parse: '\x.'
		onError: [ :fail | 
			beenHere := true.
			fail ].
	self assert: beenHere.
	self assert: (result message includesSubstring: 'separator').
	self assert: (result message includesSubstring: 'expected').
	self assert: result position equals: 3.
	beenHere := false.
	result := self parserClass
		parse: '\x.'
		onError: [ :msg :pos | 
			self assert: (msg includesSubstring: 'separator').
			self assert: (msg includesSubstring: 'expected').
			self assert: pos equals: 3.
			beenHere := true ].
	self assert: result.
	self assert: beenHere
!

testParseStartingAtOnError
	| beenHere |
	result := self parserClass parse: 'x' startingAt: #variable onError: [ self fail ].
	self assert: result equals: 'x'.
	beenHere := false.
	result := self parserClass parse: '\' startingAt: #variable onError: [ beenHere := true ].
	self assert: beenHere.
	beenHere := false.
	result := self parserClass
		parse: '\'
		startingAt: #variable
		onError: [ :fail | 
			beenHere := true.
			fail ].
	self assert: beenHere.
	self assert: result message equals: 'separator expected'.
	self assert: result position equals: 0.
	beenHere := false.
	result := self parserClass
		parse: '\'
		startingAt: #variable
		onError: [ :msg :pos | 
			self assert: msg equals: 'separator expected'.
			self assert: pos equals: 0.
			beenHere := true ].
	self assert: beenHere
!

testProductionAt
	self assert: (parser productionAt: #foo) isNil.
	self assert: (parser productionAt: #foo ifAbsent: [ true ]).
	
	self assert: (parser productionAt: #start) notNil.
	self assert: (parser productionAt: #start ifAbsent: [ true ]) notNil.
	
	self assert: (parser productionAt: #variable) notNil.
	self assert: (parser productionAt: #variable ifAbsent: [ true ]) notNil
! !

!PPLambdaParserTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/PPLambdaParserTest.st,v 1.4 2014-03-04 14:34:18 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/PPLambdaParserTest.st,v 1.4 2014-03-04 14:34:18 cg Exp $'
!

version_SVN
    ^ '$Id: PPLambdaParserTest.st,v 1.4 2014-03-04 14:34:18 cg Exp $'
! !

