"{ Package: 'stx:goodies/petitparser/compiler/tests/extras' }"

"{ NameSpace: Smalltalk }"

PPCLRPNode subclass:#PPCLRPSpawn
	instanceVariableNames:'machine state'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Extras-Tests-LRP'
!

!PPCLRPSpawn class methodsFor:'instance creation'!

machine: machineName state: stateName
    |retval|
    retval := self new.
    retval machine: machineName.
    retval state: stateName.
    ^retval
! !

!PPCLRPSpawn methodsFor:'accessing'!

machine
    ^ machine
!

machine: anObject
    machine := anObject
!

state
    ^ state
!

state: anObject
    state := anObject
! !

!PPCLRPSpawn methodsFor:'printing'!

printOn: aStream
    aStream nextPutAll: 'PPCLRPSpawn '.
    aStream nextPutAll: machine asString.
    aStream nextPutAll: ' : '.
    aStream nextPutAll: state asString.
! !

