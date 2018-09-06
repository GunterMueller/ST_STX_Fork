"{ Package: 'stx:goodies/petitparser/compiler/tests/extras' }"

"{ NameSpace: Smalltalk }"

PPCompositeParserTest subclass:#PPLL1ExpressionGrammarTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Extras-Tests-Expressions'
!


!PPLL1ExpressionGrammarTest methodsFor:'as yet unclassified'!

parserClass
    ^ PPLL1ExpressionGrammar
!

testAdd
    result := self parse: '1+2' rule: #term.
    self assert: result isArray.
    self assert: result first = 1.
    self assert: result second inputValue = '+'.
    self assert: result third = 2.
!

testMul
    result := self parse: '1 * 2' rule: #mul.
    self assert: result isArray.
    self assert: result first = 1.
    self assert: result second inputValue = '*'.
    self assert: result third = 2.
!

testNumber
    result := self parse: '1' rule: #number.
    self assert: result = 1.
!

testParens
    result := self parse: '(1)' rule: #parens.
    self assert: result size = 3.
    self assert: result first inputValue = '('.
    self assert: result second = 1.
    self assert: result third inputValue = ')'.
    
!

testPrim
    result := self parse: '1' rule: #prim.
    self assert: result = 1.
!

testPrim2
    result := self parse: '(1)' rule: #prim.
    self assert: result size = 3.
    self assert: result second = 1.
!

testProd
    result := self parse: '1' rule: #prod.
    self assert: result = 1.
!

testTerm
    result := self parse: '1' rule: #term.
    self assert: result = 1.
    
!

testTerm11
    result := self parse: '1 + 2' rule: #term.
    self assert: result size = 3.
    self assert: result first = 1.
    self assert: result second inputValue = '+'.
    self assert: result third = 2.
    
!

testTerm12
    result := self parse: '1 + 2 * 3' rule: #term.
    self assert: result size = 3.
    self assert: result second inputValue = '+'.
    self assert: result first = 1.
    self assert: result third isArray.
    self assert: result third first = 2.
    self assert: result third second inputValue = '*'.
    self assert: result third third = 3.
!

testTerm13
    result := self parse: '1 * 2 + 3' rule: #term.
    self assert: result size = 3.
    self assert: result first isArray.
    self assert: result first first = 1.
    self assert: result first second inputValue = '*'.
    self assert: result first third = 2.	
    self assert: result second inputValue = '+'.
    self assert: result third = 3.
! !

!PPLL1ExpressionGrammarTest class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

