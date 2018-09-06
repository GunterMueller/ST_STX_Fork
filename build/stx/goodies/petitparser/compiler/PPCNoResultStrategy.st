"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PPCScannerResultStrategy subclass:#PPCNoResultStrategy
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Scanner'
!

!PPCNoResultStrategy methodsFor:'as yet unclassified'!

recordFailure: retval offset: offset
    "nothing to do"
!

recordMatch: retval offset: offset
    "nothing to do"
!

reset
    "nothing to do"
!

returnFailure: retval offset: offset
    "nothing to do"
!

returnMatch: retval offset: offset
    codeGen code: 'stream position: stream position - 1.'.
    codeGen codeReturn
!

returnResult: state
    codeGen codeReturn
! !

