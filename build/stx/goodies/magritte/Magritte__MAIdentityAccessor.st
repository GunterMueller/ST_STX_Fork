"{ Package: 'stx:goodies/magritte' }"

"{ NameSpace: Magritte }"

MAAccessor subclass:#MAIdentityAccessor
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Model-Accessor'
!

MAIdentityAccessor comment:'I am a read-only access strategy and I answer the model itself when being read.'
!


!MAIdentityAccessor class methodsFor:'testing'!

isAbstract
	^ false
! !

!MAIdentityAccessor methodsFor:'model'!

read: aModel
	^ aModel
!

write: anObject to: aModel 
	MAWriteError signal: 'Not supposed to write to ' , aModel asString , '.'
! !

!MAIdentityAccessor methodsFor:'testing'!

canRead: aModel
	^ true
! !

!MAIdentityAccessor class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/Magritte__MAIdentityAccessor.st,v 1.1 2009-07-29 14:48:42 cg Exp $'
! !
