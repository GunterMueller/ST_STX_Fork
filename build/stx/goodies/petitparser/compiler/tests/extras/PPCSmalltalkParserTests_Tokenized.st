"{ Package: 'stx:goodies/petitparser/compiler/tests/extras' }"

"{ NameSpace: Smalltalk }"

PPCSmalltalkParserTests subclass:#PPCSmalltalkParserTests_Tokenized
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Extras-Tests-Misc'
!

!PPCSmalltalkParserTests_Tokenized methodsFor:'accessing'!

compiler
    ^ PPCCompiler newWithOptions: #( #tokenize: false )
! !

