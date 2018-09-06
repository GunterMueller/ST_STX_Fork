"{ Package: 'stx:goodies/petitparser/compiler/tests/extras' }"

"{ NameSpace: Smalltalk }"

PPCSmalltalkParserTests subclass:#PPCSmalltalkParserTests_Universal
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Extras-Tests-Misc'
!

!PPCSmalltalkParserTests_Universal methodsFor:'accessing'!

compiler
    ^ PPCCompiler newWithOptions: #( #tokenize: false ) 
! !

