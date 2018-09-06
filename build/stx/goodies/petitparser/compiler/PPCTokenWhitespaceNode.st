"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PPCDelegateNode subclass:#PPCTokenWhitespaceNode
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Nodes'
!

!PPCTokenWhitespaceNode methodsFor:'as yet unclassified'!

accept: visitor
    ^ visitor visitTokenWhitespaceNode: self.
! !

