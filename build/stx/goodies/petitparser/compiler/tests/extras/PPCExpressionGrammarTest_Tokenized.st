"{ Package: 'stx:goodies/petitparser/compiler/tests/extras' }"

"{ NameSpace: Smalltalk }"

PPCExpressionGrammarTest subclass:#PPCExpressionGrammarTest_Tokenized
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Extras-Tests-Misc'
!


!PPCExpressionGrammarTest_Tokenized methodsFor:'accessing'!

compiler
    ^ PPCCompiler newWithOptions: #( #tokenize: false )
! !

!PPCExpressionGrammarTest_Tokenized class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

