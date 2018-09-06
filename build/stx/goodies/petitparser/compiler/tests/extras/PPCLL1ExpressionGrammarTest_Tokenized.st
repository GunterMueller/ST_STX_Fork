"{ Package: 'stx:goodies/petitparser/compiler/tests/extras' }"

"{ NameSpace: Smalltalk }"

PPCLL1ExpressionGrammarTest subclass:#PPCLL1ExpressionGrammarTest_Tokenized
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Extras-Tests-Expressions'
!

!PPCLL1ExpressionGrammarTest_Tokenized methodsFor:'accessing'!

compiler
    ^ PPCCompiler newWithOptions: #( #tokenize: true )

    "Modified: / 07-09-2015 / 11:36:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

