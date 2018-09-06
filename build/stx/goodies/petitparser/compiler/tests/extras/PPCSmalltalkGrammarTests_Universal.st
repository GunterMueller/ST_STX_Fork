"{ Package: 'stx:goodies/petitparser/compiler/tests/extras' }"

"{ NameSpace: Smalltalk }"

PPCSmalltalkGrammarTests subclass:#PPCSmalltalkGrammarTests_Universal
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Extras-Tests-Misc'
!

!PPCSmalltalkGrammarTests_Universal methodsFor:'accessing'!

compiler
    ^ PPCCompiler newWithOptions: #( #tokenize: false ) 
! !

