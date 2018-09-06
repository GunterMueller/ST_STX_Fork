"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PPCNode subclass:#PPCListNode
	instanceVariableNames:'children'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Nodes'
!


!PPCListNode class methodsFor:'as yet unclassified'!

withAll: aCollection
    ^ self basicNew children: aCollection
! !

!PPCListNode methodsFor:'accessing'!

children
    ^ children
!

children: anObject
    
    children := anObject
!

firstChild
    ^ self children first
!

secondChild
    ^ self children second
! !

!PPCListNode methodsFor:'analysis'!

acceptsEpsilon
    self subclassResponsibility
!

acceptsEpsilonOpenSet: set
    self subclassResponsibility
! !

!PPCListNode methodsFor:'copying'!

postCopy
    super postCopy.
    children := children copy
! !

!PPCListNode methodsFor:'transformation'!

replace: node with: anotherNode
    children keysAndValuesDo: [ :index :child |
        child == node ifTrue: [ children at: index put: anotherNode ] 
    ]
! !

!PPCListNode class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

