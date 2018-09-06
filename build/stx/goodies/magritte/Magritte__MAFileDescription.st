"{ Package: 'stx:goodies/magritte' }"

"{ NameSpace: Magritte }"

MAElementDescription subclass:#MAFileDescription
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Model-Description'
!

MAFileDescription comment:'I am a description of files, their contents, filename and mime-type. Possible values include instances of *MAFileModel*. My visual representation could be a file-upload dialog.'
!




!MAFileDescription class methodsFor:'accessing'!

label
	^ 'File'
! !

!MAFileDescription class methodsFor:'testing'!

isAbstract
	^ false
! !

!MAFileDescription methodsFor:'accessing'!

kind
	^ self propertyAt: #modelClass ifAbsent: [ MAMemoryFileModel ]
!

kind: aClass
	"Set the file model class to be used."

	self propertyAt: #modelClass put: aClass
! !

!MAFileDescription methodsFor:'visiting'!

acceptMagritte: aVisitor
	aVisitor visitFileDescription: self
! !

!MAFileDescription class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/Magritte__MAFileDescription.st,v 1.4 2009-08-14 20:08:51 cg Exp $'
! !
