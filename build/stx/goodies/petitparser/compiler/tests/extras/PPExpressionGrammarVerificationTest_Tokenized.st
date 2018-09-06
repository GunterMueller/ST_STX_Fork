"{ Package: 'stx:goodies/petitparser/compiler/tests/extras' }"

"{ NameSpace: Smalltalk }"

PPCExpressionGrammarVerificationTest subclass:#PPExpressionGrammarVerificationTest_Tokenized
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Extras-Tests-Expressions'
!


!PPExpressionGrammarVerificationTest_Tokenized methodsFor:'accessing'!

compiler
    "Return compiler to use when compiling parser (as instance of PPCConfiguration)"
    
    ^ PPCCompiler newWithOptions: #( #tokenize: true )

    "Modified: / 07-09-2015 / 11:36:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPExpressionGrammarVerificationTest_Tokenized class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

