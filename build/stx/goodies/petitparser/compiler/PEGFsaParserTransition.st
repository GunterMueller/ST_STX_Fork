"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PEGFsaPredicateTransition subclass:#PEGFsaParserTransition
	instanceVariableNames:'parser'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-FSA'
!

!PEGFsaParserTransition methodsFor:'accessing'!

parser
    ^ parser
!

parser: anObject
    self halt: 'delete me!!'.
    parser := anObject
! !

!PEGFsaParserTransition methodsFor:'as yet unclassified'!

acceptsCodePoint: codePoint
    self halt: 'should not be sent...'.
    ^ true
!

isParser
    ^ true
! !

