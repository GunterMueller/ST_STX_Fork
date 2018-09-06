"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PPCScannerResultStrategy subclass:#PPCUniversalResultStrategy
	instanceVariableNames:'tokens'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Scanner'
!

!PPCUniversalResultStrategy methodsFor:'accessing'!

indexForRetval: retval
"	tokens withIndexDo: [ :e :index | 
        (e == retval) ifTrue: [ ^ index ]
    ].

    self error: 'This should not happen!!'
"
    ^ codeGen idGen numericIdFor: retval
!

tokens
    ^ tokens
!

tokens: array
    self assert: (array isArray).
    tokens := array 
! !

!PPCUniversalResultStrategy methodsFor:'as yet unclassified'!

recordFailure: retval
    self error: 'deprecated?'.
    codeGen codeRecordFailure: (self indexForRetval: retval)
!

recordFailure: retval offset: offset
    codeGen codeRecordFailure: (self indexForRetval: retval)
!

recordMatch: retval
    self error: 'deprecated?'.
    codeGen codeComment: 'symbol: ', retval storeString.
    codeGen codeRecordMatch: (self indexForRetval: retval)
!

recordMatch: retval offset: offset
    codeGen codeComment: 'symbol: ', retval storeString.
    codeGen codeRecordMatch: (self indexForRetval: retval) offset: offset
!

reset
"	^ codeGen code: 'self reset:', tokens storeString, '.'"
    ^ codeGen code: 'self reset.'	
!

returnMatch: retval offset: offset
    codeGen codeComment: 'symbol: ', retval storeString.
    codeGen codeReturn: [ codeGen codeRecordMatch: (self indexForRetval: retval) offset: offset ]
!

returnResult: state
    self assert: (state isKindOf: PEGFsaState).
    codeGen codeReturn.
! !

