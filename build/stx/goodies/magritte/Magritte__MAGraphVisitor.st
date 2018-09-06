"{ Package: 'stx:goodies/magritte' }"

"{ NameSpace: Magritte }"

MAVisitor subclass:#MAGraphVisitor
	instanceVariableNames:'seen object'
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Model-Visitor'
!


!MAGraphVisitor methodsFor:'accessing'!

object
	^ object
! !

!MAGraphVisitor methodsFor:'initialization'!

initialize
	super initialize.
	seen := IdentitySet new
! !

!MAGraphVisitor methodsFor:'private'!

use: anObject during: aBlock
	| previous |
	(seen includes: anObject)
		ifTrue: [ ^ self ].
	anObject isNil
		ifFalse: [ seen add: anObject ].
	previous := object. object := anObject.
	aBlock ensure: [ object := previous ]
! !

!MAGraphVisitor class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/Magritte__MAGraphVisitor.st,v 1.1 2009-07-29 14:49:28 cg Exp $'
! !
