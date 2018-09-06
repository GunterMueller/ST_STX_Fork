"{ Package: 'stx:goodies/petitparser/compiler/tests/extras' }"

"{ NameSpace: Smalltalk }"

PPCLRPContainedElement subclass:#PPCLRPVariable
	instanceVariableNames:'name value'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Extras-Tests-LRP'
!


!PPCLRPVariable class methodsFor:'installation'!

name: aString value: aValue
    |retval|
    retval := self new.
    retval name: aString.
    retval value: aValue.
    ^retval
! !

!PPCLRPVariable methodsFor:'accessing'!

name
    ^ name
!

name: anObject
    name := anObject
!

value
    ^ value
!

value: anObject
    value := anObject
! !

!PPCLRPVariable methodsFor:'printing'!

printOn: aStream
    aStream nextPutAll: 'PPCLRPVariable '.
    aStream nextPutAll: self name.
    aStream nextPutAll: ' : '.
    aStream nextPutAll: self value asString.
    
! !

!PPCLRPVariable methodsFor:'visiting'!

acceptVisitor: aPPCLRPNodeVisitor
    aPPCLRPNodeVisitor visitVariableNode: self
! !

!PPCLRPVariable class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

