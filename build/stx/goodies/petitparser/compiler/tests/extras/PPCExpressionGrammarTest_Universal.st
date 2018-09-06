"{ Package: 'stx:goodies/petitparser/compiler/tests/extras' }"

"{ NameSpace: Smalltalk }"

PPCExpressionGrammarTest subclass:#PPCExpressionGrammarTest_Universal
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Extras-Tests-Misc'
!

!PPCExpressionGrammarTest_Universal methodsFor:'accessing'!

compiler
    ^ PPCCompiler newWithOptions: #( #tokenize: false ) 
! !

