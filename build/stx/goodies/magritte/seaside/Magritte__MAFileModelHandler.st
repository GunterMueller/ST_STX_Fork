"{ Package: 'stx:goodies/magritte/seaside' }"

"{ NameSpace: Magritte }"

WARequestHandler subclass:#MAFileModelHandler
	instanceVariableNames:'model'
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Seaside-Core'
!


!MAFileModelHandler class methodsFor:'instance creation'!

on: aFileModel
	^ self new initializeOn: aFileModel
! !

!MAFileModelHandler methodsFor:'accessing'!

model
	^ model
! !

!MAFileModelHandler methodsFor:'comparing'!

= aHandler
	^ self species = aHandler species and: [ self model = aHandler model ]
!

hash
	^ self model hash
! !

!MAFileModelHandler methodsFor:'initialization'!

initializeOn: aFileModel
	model := aFileModel
! !

!MAFileModelHandler methodsFor:'processing'!

handleRequest: aRequest
	| response |
	response := WAResponse new.
	response
		cacheForever;
		contentType: self model mimetype;
		headerAt: 'Content-Disposition' put: 'inline; filename="' , self model filename , '"';
		contents: self model contents readStream.
	^ response
! !

!MAFileModelHandler class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/seaside/Magritte__MAFileModelHandler.st,v 1.2 2009-08-14 20:28:05 cg Exp $'
! !
