"{ Package: 'stx:goodies/petitparser/compiler/tests/extras' }"

"{ NameSpace: Smalltalk }"

PPCSmalltalkGrammarVerificationTest subclass:#PPCSmalltalkGrammarVerificationTest_Universal
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Extras-Tests-Smalltalk'
!

!PPCSmalltalkGrammarVerificationTest_Universal methodsFor:'accessing'!

compiler
    "Return compiler to use when compiling parser (as instance of PPCConfiguration)"
    
    ^ PPCCompiler newWithOptions: #( #tokenize: false )

    "Created: / 29-07-2015 / 19:54:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-09-2015 / 11:37:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

