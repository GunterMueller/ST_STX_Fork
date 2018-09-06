"{ Package: 'stx:goodies/magritte' }"

"{ NameSpace: Magritte }"

MAStreamingVisitor subclass:#MAReader
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Model-Visitor'
!


!MAReader class methodsFor:'instance creation'!

read: aStream description: aDescription
	^ self new read: aStream description: aDescription
! !

!MAReader methodsFor:'private'!

error: aString 
	MAReadError signal: aString
! !

!MAReader methodsFor:'visiting'!

read: aStream description: aDescription
	self
		stream: aStream;
		visit: aDescription.
	^ self object
! !

!MAReader class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/Magritte__MAReader.st,v 1.1 2009-07-29 14:55:15 cg Exp $'
! !
