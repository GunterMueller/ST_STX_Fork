"{ Package: 'stx:goodies/petitparser/compiler/tests/extras' }"

"{ NameSpace: Smalltalk }"

PPCLRPCompiledParserSmokeTest subclass:#PPCLRPCompiledParserSmokeTest_Universal
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Extras-Tests-LRP'
!

!PPCLRPCompiledParserSmokeTest_Universal methodsFor:'accessing'!

compiler
    ^ PPCCompiler newWithOptions: #( #tokenize: false )

    "Modified: / 07-09-2015 / 11:37:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

