"{ Package: 'stx:goodies/magritte/tests' }"

"{ NameSpace: Magritte }"

MAElementDescriptionTest subclass:#MAReferenceDescriptionTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Tests-Description'
!


!MAReferenceDescriptionTest class methodsFor:'testing'!

isAbstract
	^ true
! !

!MAReferenceDescriptionTest methodsFor:'private'!

actualClass
	^ MAReferenceDescription
!

referenceInstance
	^ MAStringDescription new
! !

!MAReferenceDescriptionTest methodsFor:'running'!

setUp
	super setUp.
	self description reference: self referenceInstance.
	self assert: self description reference accessor notNil
! !

!MAReferenceDescriptionTest methodsFor:'testing-copying'!

testCopyReference
	self assert: self description copy reference = self description reference.
	self deny: self description copy reference == self description reference
! !

!MAReferenceDescriptionTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/tests/Magritte__MAReferenceDescriptionTest.st,v 1.1 2009-07-29 15:19:42 cg Exp $'
! !
