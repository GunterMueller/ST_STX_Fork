"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PPCAbstractLiteralNode subclass:#PPCLiteralNode
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Nodes'
!


!PPCLiteralNode methodsFor:'comparing'!

recognizedSentencesPrim
    ^ Array with: literal.
! !

!PPCLiteralNode methodsFor:'printing'!

printNameOn: aStream
    super printNameOn: aStream.
    aStream nextPutAll: ', '; print: literal
! !

!PPCLiteralNode methodsFor:'visiting'!

accept: visitor
    ^ visitor visitLiteralNode: self
! !

!PPCLiteralNode class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

