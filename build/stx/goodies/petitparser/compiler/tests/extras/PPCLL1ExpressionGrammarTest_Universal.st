"{ Package: 'stx:goodies/petitparser/compiler/tests/extras' }"

"{ NameSpace: Smalltalk }"

PPCLL1ExpressionGrammarTest subclass:#PPCLL1ExpressionGrammarTest_Universal
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Extras-Tests-Expressions'
!


!PPCLL1ExpressionGrammarTest_Universal methodsFor:'accessing'!

compiler
    ^ PPCCompiler newWithOptions: #( #tokenize: false )

    "Modified: / 07-09-2015 / 11:37:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCLL1ExpressionGrammarTest_Universal class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

