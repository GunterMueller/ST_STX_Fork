"{ Package: 'stx:goodies/petitparser/compiler/tests/extras' }"

"{ NameSpace: Smalltalk }"

Object subclass:#PPCLRPNode
	instanceVariableNames:'start stop nameRange'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Extras-Tests-LRP'
!


!PPCLRPNode methodsFor:'accessing'!

nameRange
    nameRange ifNil: [self halt: 'Error in setting up range info for styling.' ].
    ^ nameRange
!

nameRange: anObject
    nameRange := anObject
!

start
    ^ start
!

start: anObject
    start := anObject
!

start: aNumber stop: anotherNumber
    
    start := aNumber.
    stop := anotherNumber.
!

stop
    ^ stop
!

stop: anObject
    stop := anObject
! !

!PPCLRPNode methodsFor:'error handing'!

onErrorNode: aBlock parser: aPPCLRPParser
    "do nothing"
! !

!PPCLRPNode methodsFor:'testing'!

isError

    ^false.
! !

!PPCLRPNode methodsFor:'visiting'!

acceptVisitor: aPPCLRPNodeVisitor
    aPPCLRPNodeVisitor visitAnyNode: self.
! !

!PPCLRPNode class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

