"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PPCListNode subclass:#PPCTokenizingParserNode
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Nodes'
!

!PPCTokenizingParserNode methodsFor:'accessing'!

defaultName
    ^ #tokenizingParser
!

initialize
    super initialize.
    children := Array new: 3
!

parser
    ^ children at: 1
!

parser: node
    children at: 1 put: node
!

tokens
    ^ children at: 3
!

tokens: anObject
    children at: 3 put: anObject
!

whitespace
    ^ children at: 2
!

whitespace: node
    children at: 2 put: node
! !

!PPCTokenizingParserNode methodsFor:'visiting'!

accept: visitor
    ^ visitor visitTokenizingParserNode: self
! !

