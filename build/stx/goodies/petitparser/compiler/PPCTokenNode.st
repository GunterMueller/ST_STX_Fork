"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PPCDelegateNode subclass:#PPCTokenNode
	instanceVariableNames:'tokenClass'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Nodes'
!

!PPCTokenNode methodsFor:'accessing'!

tokenClass
    
    ^ tokenClass
!

tokenClass: anObject
    
    tokenClass := anObject
!

tokenType
    ^ self identityHash printString
! !

!PPCTokenNode methodsFor:'comparing'!

= anotherNode
    super = anotherNode ifFalse: [ ^ false ].
    ^ tokenClass = anotherNode tokenClass.
!

hash
    ^ super hash bitXor: tokenClass hash
! !

!PPCTokenNode methodsFor:'ids'!

defaultName
    ^ #token
! !

!PPCTokenNode methodsFor:'testing'!

isTokenNode
    ^ true
! !

!PPCTokenNode methodsFor:'visiting'!

accept: visitor
    ^ visitor visitTokenNode: self
! !

