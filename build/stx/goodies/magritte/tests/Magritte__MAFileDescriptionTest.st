"{ Package: 'stx:goodies/magritte/tests' }"

"{ NameSpace: Magritte }"

MAElementDescriptionTest subclass:#MAFileDescriptionTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Tests-Description'
!


!MAFileDescriptionTest class methodsFor:'testing'!

isAbstract
	^ false
! !

!MAFileDescriptionTest methodsFor:'private'!

actualClass
	^ MAFileDescription
!

includedInstance
	^ MAMemoryFileModel new
		contents: 'Lukas Renggli';
		filename: 'author.txt';
		yourself
!

shouldSkipStringTests
	^ true
! !

!MAFileDescriptionTest methodsFor:'testing-accessing'!

testKind
	super testKind.
	self description kind: MAExternalFileModel.
	self assert: self description kind = MAExternalFileModel
! !

!MAFileDescriptionTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/tests/Magritte__MAFileDescriptionTest.st,v 1.1 2009-07-29 15:19:26 cg Exp $'
! !
