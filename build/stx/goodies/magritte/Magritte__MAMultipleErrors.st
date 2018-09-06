"{ Package: 'stx:goodies/magritte' }"

"{ NameSpace: Magritte }"

MAValidationError subclass:#MAMultipleErrors
	instanceVariableNames:'collection'
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Model-Exception'
!

MAMultipleErrors comment:'I am an error that is raised whenever there are multiple validation rules failing.'
!


!MAMultipleErrors class methodsFor:'instance-creation'!

description: aDescription errors: aCollection signal: aString 
	^ self new
		setDescription: aDescription;
		setCollection: aCollection;
		signal: aString;
		yourself
! !


!MAMultipleErrors methodsFor:'accessing'!

collection
	^ collection
! !

!MAMultipleErrors methodsFor:'initialization'!

setCollection: aCollection
	collection := aCollection
! !

!MAMultipleErrors methodsFor:'printing'!

printOn: aStream
	self collection
		do: [ :each | aStream print: each ]
		separatedBy: [ aStream nextPut: Character cr ]
! !

!MAMultipleErrors class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/Magritte__MAMultipleErrors.st,v 1.3 2009-08-14 20:16:27 cg Exp $'
! !
