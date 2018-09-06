"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

Object subclass:#PPCTokenGuard
	instanceVariableNames:'node'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Guards'
!

!PPCTokenGuard class methodsFor:'as yet unclassified'!

on: node
    ^ self new
        node: node;
        yourself
! !

!PPCTokenGuard methodsFor:'as yet unclassified'!

firstToken
    self assert: node firstSetWithTokens  size = 1.
    ^ node firstSetWithTokens anyOne
!

makesSense
    ^ node firstSetWithTokens size = 1 and: [ node firstSetWithTokens anyOne isTokenNode ]
!

node
    ^ node
!

node: aPPCNode
    node := aPPCNode
! !

