"{ Package: 'stx:goodies/magritte' }"

"{ NameSpace: Magritte }"

MAFileModel subclass:#MAMemoryFileModel
	instanceVariableNames:'contents'
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Model-Models'
!

MAMemoryFileModel comment:'I represent a file using a ByteArray in the object memory. I am not practicable for big files: use me for development and testing only.'
!


!MAMemoryFileModel methodsFor:'accessing'!

contents
	^ contents ifNil: [ contents := ByteArray new ]
!

contents: aByteArray
	super contents: aByteArray.
	contents := aByteArray asByteArray
! !

!MAMemoryFileModel methodsFor:'initialization'!

finalize
	super finalize.
	contents := nil
! !

!MAMemoryFileModel class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/Magritte__MAMemoryFileModel.st,v 1.1 2009-07-29 14:50:53 cg Exp $'
! !
