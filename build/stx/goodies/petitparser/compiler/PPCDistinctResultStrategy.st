"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PPCScannerResultStrategy subclass:#PPCDistinctResultStrategy
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Scanner'
!

!PPCDistinctResultStrategy methodsFor:'as yet unclassified'!

recordFailure: retval offset: offset
    offset == 0 ifTrue: [ 
        codeGen codeRecordDistinctMatch: nil.
        ^ self
    ].
    codeGen codeRecordDistinctMatch: nil offset: offset 
!

recordMatch: retval offset: offset
    offset == 0 ifTrue: [ 
        codeGen codeRecordDistinctMatch: retval.
        ^ self
    ].

    codeGen codeRecordDistinctMatch: retval offset: offset
!

reset
    ^ codeGen code: 'self resetDistinct.'.
!

returnFailure: retval offset: offset
    (offset == 0) ifFalse: [ 
        codeGen codeIf: 'currentChar isNil' then: nil else: [ 
         	codeGen code: ('context skip: -', offset asString); codeDot.
        ]
    ].

    codeGen codeReturn: [ codeGen codeRecordDistinctFailure: nil ].
!

returnMatch: retval offset: offset
    (offset == 0) ifFalse: [ 
        codeGen code: 'self back.'.
    ].

    codeGen codeReturn: [ codeGen codeRecordDistinctMatch: retval ].
!

returnResult: state
    codeGen codeNl.
    codeGen codeReturnDistinct.	
! !

