"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PPCChoiceNode subclass:#PPCTokenChoiceNode
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Nodes'
!

!PPCTokenChoiceNode methodsFor:'as yet unclassified'!

accept: visitor
    visitor visitTokenChoiceNode: self.
! !

