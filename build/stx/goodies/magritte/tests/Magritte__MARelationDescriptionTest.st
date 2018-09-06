"{ Package: 'stx:libcompat' }"

"{ NameSpace: Magritte }"

MAReferenceDescriptionTest subclass:#MARelationDescriptionTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Tests-Description'
!


!MARelationDescriptionTest class methodsFor:'testing'!

isAbstract
	^ true
! !

!MARelationDescriptionTest methodsFor:'private'!

actualClass
	^ MARelationDescription
!

addressInstance1
	^ MAMockAddress new
		street: 'Tillierstrasse 17';
		plz: 3005; place: 'Bern';
		yourself
!

addressInstance2
	^ MAMockAddress new
		street: 'In der Au';
		plz: 8765; place: 'Engi';
		yourself
!

shouldSkipStringTests
	^ true
! !

!MARelationDescriptionTest methodsFor:'running'!

setUp
	super setUp.
	self description
		reference: MAMockAddress description;
		classes: (Array with: MAMockAddress)
! !

!MARelationDescriptionTest methodsFor:'testing-copying'!

testCopyClasses
	self assert: self description copy classes = self description classes.
	self deny: self description copy classes == self description classes
! !

!MARelationDescriptionTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/tests/Magritte__MARelationDescriptionTest.st,v 1.1 2009-07-29 15:22:17 cg Exp $'
! !
