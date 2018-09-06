"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PPCDelegateNode subclass:#PPCAbstractActionNode
	instanceVariableNames:'block'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Nodes'
!


!PPCAbstractActionNode methodsFor:'accessing'!

block
    
    ^ block
!

block: anObject
    
    block := anObject
!

defaultName
    ^ #action
! !

!PPCAbstractActionNode methodsFor:'comparing'!

= anotherNode
    super = anotherNode ifFalse: [ ^ false ].
    ^ block = anotherNode block.
!

hash
    ^ super hash bitXor: block hash
! !

!PPCAbstractActionNode class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

