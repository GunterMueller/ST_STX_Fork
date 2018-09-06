"{ Package: 'stx:goodies/petitparser/compiler/tests/extras' }"

"{ NameSpace: Smalltalk }"

PPCLRPContainedElement subclass:#PPCLRPMachine
	instanceVariableNames:'initState name body currentState scope triggeredTransition
		compareStates compareTransitions'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Extras-Tests-LRP'
!

!PPCLRPMachine class methodsFor:'instance creation'!

name: aString body: anArray
    |retval|
    retval := self new.
    retval name: aString.
    retval body: anArray.
    ^retval
! !

!PPCLRPMachine methodsFor:'accessing'!

allTransitions
    ^self body select:[:item | item isKindOf: PPCLRPTransition]
!

body
    ^ body
!

body: anObject
    body := anObject.
    body do: [ :aBodyElement| aBodyElement container: self ].
!

containerMachine
    self container isNil
        ifTrue: [ ^nil ]
        ifFalse: [ ^self container container ]
!

eps
    ^self body select:[:item | item isMemberOf: PPCLRPEpsilonTransition]
!

events
    ^self body select:[:item | item class = PPCLRPEvent]
!

machines
    ^self body select:[:item | item class = PPCLRPMachine]
!

myVarsAndParentVars

    |recblock |
    recblock := [  ].
    recblock := [ :aMachine| |variables|
        aMachine ifNil:[
            OrderedCollection new.	
        ] ifNotNil: [
            variables := recblock value: aMachine containerMachine.
            variables addAll: (aMachine variables collect:[:aVarNode| aVarNode name]).
            variables
        ]
    ].

    ^recblock value: self.
    
!

name
    ^ name
!

name: anObject
    name := anObject
!

ontime
    ^self body select:[:item | item isMemberOf: PPCLRPTimeoutTransition]
!

states
    ^self body select:[:item | item class = PPCLRPState]
!

transitions
    ^self body select:[:item | item isMemberOf: PPCLRPTransition]
!

variables
    ^self body select:[:item | item class = PPCLRPVariable]
!

wildtrans
    ^self body select:[:item | item class = PPCLRPWildcardTransition]
! !

!PPCLRPMachine methodsFor:'error handing'!

onErrorNode: aBlock parser: aPPCLRPParser

    ^body do: [ :aNode| aNode onErrorNode: aBlock parser: aPPCLRPParser]
! !

!PPCLRPMachine methodsFor:'printing'!

printOn: aStream
    aStream nextPutAll: 'PPCLRPMachine '.
    aStream nextPutAll: self name.
    aStream nextPutAll: ' : '.
    aStream nextPutAll: self body asString.
    
! !

!PPCLRPMachine methodsFor:'visiting'!

acceptVisitor: aPPCLRPNodeVisitor
    aPPCLRPNodeVisitor visitMachineNode: self.
! !

