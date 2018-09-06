"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PPCDelegateNode subclass:#PPCTokenConsumeNode
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Nodes'
!

!PPCTokenConsumeNode methodsFor:'accessing'!

name: value
    super name: value.
    
    self child name isNil ifTrue: [ 
        self child name: value.
    ]
!

nextFsa
    ^ self propertyAt: #nextFsa
!

nextFsa: aPEGFsa
    self propertyAt: #nextFsa put: aPEGFsa
!

suffix
    ^ nil
! !

!PPCTokenConsumeNode methodsFor:'as yet unclassified'!

markForInline
    ^ super markForInline
! !

!PPCTokenConsumeNode methodsFor:'ids'!

defaultName
    ^ #token
!

prefix
    ^ #consume
! !

!PPCTokenConsumeNode methodsFor:'visiting'!

accept: visitor
    ^ visitor visitTokenConsumeNode: self
! !

