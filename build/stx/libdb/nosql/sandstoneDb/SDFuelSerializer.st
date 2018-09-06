"{ Package: 'stx:libdb/nosql/sandstoneDb' }"

SDSerializer subclass:#SDFuelSerializer
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-SandstoneDb-Fuel'
!


!SDFuelSerializer methodsFor:'actions'!

materializeFromFile: aFile
	^ FLMaterializer materializeFromFileNamed: aFile
!

serialize: anObject toFile: aFile
	| serializer |
	StandardFileStream
		newFileNamed: aFile
		do: [ :f | 
			f binary.
			serializer := FLSerializer on: f.
			serializer serialize: anObject.
			f flush ]
! !

!SDFuelSerializer class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/sandstoneDb/SDFuelSerializer.st,v 1.4 2013-04-17 23:18:47 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/sandstoneDb/SDFuelSerializer.st,v 1.4 2013-04-17 23:18:47 cg Exp $'
! !

