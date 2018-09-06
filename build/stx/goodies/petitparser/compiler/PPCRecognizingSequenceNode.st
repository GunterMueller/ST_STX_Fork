"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PPCSequenceNode subclass:#PPCRecognizingSequenceNode
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Nodes'
!

!PPCRecognizingSequenceNode methodsFor:'accessing'!

suffix
    ^ super suffix isNil ifTrue: [ 'fast' ] ifFalse: [ super suffix, '_fast' ]
! !

!PPCRecognizingSequenceNode methodsFor:'visiting'!

accept: visitor
    ^ visitor visitRecognizingSequenceNode: self
! !

