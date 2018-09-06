"{ Package: 'stx:goodies/petitparser/compiler/tests/extras' }"

"{ NameSpace: Smalltalk }"

PPCSmalltalkGrammarTests subclass:#PPCSmalltalkGrammarTests_Tokenized
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Extras-Tests-Misc'
!

!PPCSmalltalkGrammarTests_Tokenized methodsFor:'accessing'!

compiler
    ^ PPCCompiler newWithOptions: #( #tokenize: false )
! !

