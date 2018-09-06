"{ Package: 'stx:goodies/petitparser/compiler/tests/extras' }"

"{ NameSpace: Smalltalk }"

PPCLRPContainedElement subclass:#PPCLRPComment
	instanceVariableNames:'text'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Extras-Tests-LRP'
!

!PPCLRPComment class methodsFor:'instance creation'!

text: aString
    ^ self new text: aString
! !

!PPCLRPComment methodsFor:'accessing'!

text
    ^ text
!

text: anObject
    text := anObject
! !

!PPCLRPComment methodsFor:'as yet unclassified'!

printOn: aStream
    aStream nextPutAll: 'PPCLRPComment : '.
    aStream nextPutAll: self text asString.
! !

