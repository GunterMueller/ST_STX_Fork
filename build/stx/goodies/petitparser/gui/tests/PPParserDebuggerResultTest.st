"{ Package: 'stx:goodies/petitparser/gui/tests' }"

TestCase subclass:#PPParserDebuggerResultTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitGui-Tests'
!


!PPParserDebuggerResultTest methodsFor:'tests'!

testArithmetic
	| parser result |
	parser := PPArithmeticParser new.
	result := PPParserDebuggerResult parse: '1 + 2' with: parser.
	self assert: result children size = 1.
	self assert: result children first result = 3
!

testNumberParser
	| parser result |
	parser := PPArithmeticParser new productionAt: #number.
	result := PPParserDebuggerResult parse: '1' with: parser.
	self assert: result children isEmpty.
	self assert: result result = 1
! !

!PPParserDebuggerResultTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/gui/tests/PPParserDebuggerResultTest.st,v 1.1 2014-03-04 21:16:27 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/gui/tests/PPParserDebuggerResultTest.st,v 1.1 2014-03-04 21:16:27 cg Exp $'
! !

