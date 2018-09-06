"{ Package: 'stx:goodies/petitparser/compiler/tests/extras' }"

"{ NameSpace: Smalltalk }"

PPCLRPContainedElement subclass:#PPCLRPState
	instanceVariableNames:'name body nestedMachine startTime compareMachines'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Extras-Tests-LRP'
!


!PPCLRPState class methodsFor:'instance creation'!

name: aString body: anArray
    |retval|
    retval := self new.
    retval name: aString.
    retval body: anArray.
    ^retval
! !

!PPCLRPState methodsFor:'accessing'!

body
    ^ body
!

body: anObject
    body := anObject.
    body do: [ :aBodyElement|
        (aBodyElement isKindOf: PPCLRPContainedElement)
            ifTrue: [aBodyElement container: self] ].
!

fullName
    ^self container fullName, '/', self name 
!

machines
    ^self body select:[:item | item class = PPCLRPMachine]
!

name
    ^ name
!

name: anObject
    name := anObject
! !

!PPCLRPState methodsFor:'error handing'!

onErrorNode: aBlock parser: aPPCLRPParser

    ^body do:[:aNode| aNode onErrorNode: aBlock parser: aPPCLRPParser]
! !

!PPCLRPState methodsFor:'printing'!

printOn: aStream
    aStream nextPutAll: 'PPCLRPState '.
    aStream nextPutAll: self name.
    aStream nextPutAll: ' : '.
    aStream nextPutAll: self body asString.
    
! !

!PPCLRPState methodsFor:'visiting'!

acceptVisitor: aPPCLRPNodeVisitor
    aPPCLRPNodeVisitor visitStateNode: self.
! !

!PPCLRPState class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

