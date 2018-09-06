"{ Package: 'stx:goodies/magritte' }"

"{ NameSpace: Magritte }"

MAVisitor subclass:#MAStreamingVisitor
	instanceVariableNames:'stream object'
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Model-Visitor'
!


!MAStreamingVisitor methodsFor:'accessing'!

object
	^ object
!

object: anObject
	object := anObject
!

stream
	^ stream
!

stream: aStream
	stream := aStream
! !

!MAStreamingVisitor methodsFor:'private'!

object: anObject during: aBlock
	| previous |
	previous := self object. self object: anObject.
	aBlock ensure: [ self object: previous ]
! !

!MAStreamingVisitor methodsFor:'streaming'!

contents
	^ self stream contents
! !

!MAStreamingVisitor class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/Magritte__MAStreamingVisitor.st,v 1.1 2009-07-29 14:53:40 cg Exp $'
! !
