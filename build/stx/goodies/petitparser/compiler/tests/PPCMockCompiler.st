"{ Package: 'stx:goodies/petitparser/compiler/tests' }"

"{ NameSpace: Smalltalk }"

Object subclass:#PPCMockCompiler
	instanceVariableNames:'lines'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Tests-Core'
!


!PPCMockCompiler class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!PPCMockCompiler methodsFor:'accessing'!

lines
    
    ^ lines
!

lines: anObject
    
    lines := anObject
! !

!PPCMockCompiler methodsFor:'as yet unclassified'!

add: string
    lines add: string
!

addConstant: object as: id
    "TODO"
!

code: string
    lines add: string
! !

!PPCMockCompiler methodsFor:'initialization'!

initialize
    super initialize.
    lines := OrderedCollection new.
! !

!PPCMockCompiler class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

