"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#CEStringExtensionTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression-CollectionExtensions'
!


!CEStringExtensionTest methodsFor:'tests'!

testIntervalFromStartLineStartColumnToEndLineEndColumn
	| string |
	string := '123
56
89'.
	self assert: (string intervalFromStartLine: 1 startColumn: 1 toEndLine: 1 endColumn: 2) = (1 to: 2).
	self assert: (string intervalFromStartLine: 2 startColumn: 2 toEndLine: 3 endColumn: 2) = (6 to: 9)
!

testIntervalOfLine
	| string |
	string := '123
56
89'.
	self assert: (string intervalOfLine: 1) = (1 to: 4).
	self assert: (string intervalOfLine: 2) = (5 to: 7).
	self assert: (string intervalOfLine: 3) = (8 to: 9)
!

testIntervalOfLineCorrespondingToIndex
	| string |
	string := '123
56
89'.
	self assert: (string intervalOfLineCorrespondingToIndex: 1) = (1 to: 4).
	self assert: (string intervalOfLineCorrespondingToIndex: 7) = (5 to: 7).
	self assert: (string intervalOfLineCorrespondingToIndex: 9) = (8 to: 9)
!

testPiecesCutWhereCamelCase

	self assert: ('' piecesCutWhereCamelCase) isEmpty.
	self assert: ('fBar' piecesCutWhereCamelCase) asArray  = #('f' 'Bar').
	self assert: ('fooBar' piecesCutWhereCamelCase) asArray  = #('foo' 'Bar').
	self assert: ('FOOBar') piecesCutWhereCamelCase asArray = #('FOO' 'Bar').
	self assert: ('fooBar1' piecesCutWhereCamelCase) asArray  = #('foo' 'Bar' '1').
	self assert: ('FOOBar12AndSomething') piecesCutWhereCamelCase asArray = #('FOO' 'Bar' '12' 'And' 'Something').
! !

!CEStringExtensionTest class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

