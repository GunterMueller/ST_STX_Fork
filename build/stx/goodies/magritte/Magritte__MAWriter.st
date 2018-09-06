"{ Package: 'stx:goodies/magritte' }"

"{ NameSpace: Magritte }"

MAStreamingVisitor subclass:#MAWriter
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Model-Visitor'
!


!MAWriter class methodsFor:'instance creation'!

write: anObject
	^ self new write: anObject
!

write: anObject description: aDescription
	^ self new write: anObject description: aDescription
!

write: anObject description: aDescription to: aStream
	^ self new write: anObject description: aDescription to: aStream
! !

!MAWriter methodsFor:'private'!

defaultWriteStream
	self subclassResponsibility
!

error: aString 
	MAWriteError signal: aString
! !

!MAWriter methodsFor:'visiting'!

write: anObject
	^ self write: anObject description: anObject description
!

write: anObject description: aDescription
	^ self write: anObject description: aDescription to: self defaultWriteStream
!

write: anObject description: aDescription to: aStream
        self
                object: anObject;
                stream: aStream;
                visit: aDescription.
        ^ self contents
! !

!MAWriter class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/Magritte__MAWriter.st,v 1.2 2009-08-14 21:40:30 cg Exp $'
! !
