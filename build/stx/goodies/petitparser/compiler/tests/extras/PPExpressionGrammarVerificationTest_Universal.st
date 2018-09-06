"{ Package: 'stx:goodies/petitparser/compiler/tests/extras' }"

"{ NameSpace: Smalltalk }"

PPCExpressionGrammarVerificationTest subclass:#PPExpressionGrammarVerificationTest_Universal
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Extras-Tests-Expressions'
!

!PPExpressionGrammarVerificationTest_Universal methodsFor:'accessing'!

compiler
    "Return compiler to use when compiling parser (as instance of PPCConfiguration)"
    
    ^ PPCCompiler newWithOptions: #( #tokenize: false )

    "Modified: / 07-09-2015 / 11:37:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

