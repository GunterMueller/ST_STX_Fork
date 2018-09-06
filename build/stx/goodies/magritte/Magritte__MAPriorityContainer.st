"{ Package: 'stx:goodies/magritte' }"

"{ NameSpace: Magritte }"

MAContainer subclass:#MAPriorityContainer
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Model-Description'
!

MAPriorityContainer comment:'I am a container holding a collection of descriptions and I keep them sorted according to their priority.'
!


!MAPriorityContainer class methodsFor:'accessing-defaults'!

defaultCollection
	^ SortedCollection new
! !

!MAPriorityContainer methodsFor:'actions'!

resort
	self setChildren: self children copy
! !

!MAPriorityContainer methodsFor:'initialization'!

setChildren: aCollection
	super setChildren: aCollection asSortedCollection
! !

!MAPriorityContainer methodsFor:'moving'!

moveDown: aDescription
	self shouldNotImplement
!

moveUp: aDescription
	self shouldNotImplement
! !

!MAPriorityContainer methodsFor:'visiting'!

acceptMagritte: aVisitor
	aVisitor visitPriorityContainer: self
! !

!MAPriorityContainer class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/Magritte__MAPriorityContainer.st,v 1.1 2009-07-29 14:47:15 cg Exp $'
! !
