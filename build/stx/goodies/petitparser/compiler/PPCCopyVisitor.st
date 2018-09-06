"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PPCRewritingVisitor subclass:#PPCCopyVisitor
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Visitors'
!

!PPCCopyVisitor methodsFor:'as yet unclassified'!

visitNode: node
    | newNode |
    self change.
    newNode := node copy.
    ^ super visitNode: newNode.
! !

