"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PPCAbstractActionNode subclass:#PPCSymbolActionNode
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Nodes'
!


!PPCSymbolActionNode methodsFor:'accessing'!

symbol
    ^ self block
!

symbol: aSymbol
    self block: aSymbol
! !

!PPCSymbolActionNode methodsFor:'visiting'!

accept: visitor
    ^ visitor visitSymbolActionNode: self
! !

!PPCSymbolActionNode class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

