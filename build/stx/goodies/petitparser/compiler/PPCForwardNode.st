"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PPCDelegateNode subclass:#PPCForwardNode
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Nodes'
!

!PPCForwardNode methodsFor:'accessing'!

child: node
    "(node name asString beginsWith: 'symbol') ifTrue: [ self halt. ]."
    ^ super child: node
!

defaultName
    ^ #fw
! !

!PPCForwardNode methodsFor:'analysis'!

check
    ^ (self name notNil and: [ 
        child name = self name and: [
        child suffix = self suffix
    ]]) ifTrue: [ 'referring to itself!!' ]
! !

!PPCForwardNode methodsFor:'visiting'!

accept: visitor
    ^ visitor visitForwardNode: self
! !

