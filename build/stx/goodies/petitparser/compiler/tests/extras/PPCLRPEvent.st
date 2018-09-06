"{ Package: 'stx:goodies/petitparser/compiler/tests/extras' }"

"{ NameSpace: Smalltalk }"

PPCLRPContainedElement subclass:#PPCLRPEvent
	instanceVariableNames:'name trigger triggerBlock'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Extras-Tests-LRP'
!


!PPCLRPEvent class methodsFor:'instance creation'!

named: aString trigger: aBlock
    |retval|
    retval := self new.
    retval name: aString.
    retval trigger: aBlock.
    ^ retval
! !

!PPCLRPEvent methodsFor:'accessing'!

name
    ^ name
!

name: anObject
    name := anObject
!

trigger
    ^ trigger
!

trigger: anObject
    trigger := anObject
! !

!PPCLRPEvent methodsFor:'printing'!

printOn: aStream
    aStream nextPutAll: 'PPCLRPEvent '.
    aStream nextPutAll: self name.
    aStream nextPutAll: ' : '.
    aStream nextPutAll: self trigger asString.
    
! !

!PPCLRPEvent methodsFor:'visiting'!

acceptVisitor: aPPCLRPNodeVisitor
    aPPCLRPNodeVisitor visitEventNode: self
! !

!PPCLRPEvent class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

