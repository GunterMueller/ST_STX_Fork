"{ Package: 'stx:libcompat' }"

"{ NameSpace: Magritte }"

MARelationDescriptionTest subclass:#MAToManyRelationDescriptionTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Tests-Description'
!


!MAToManyRelationDescriptionTest class methodsFor:'testing'!

isAbstract
	^ false
! !

!MAToManyRelationDescriptionTest methodsFor:'private'!

actualClass
	^ MAToManyRelationDescription
!

includedInstance
	^ Array with: self addressInstance1 with: self addressInstance2
! !

!MAToManyRelationDescriptionTest methodsFor:'testing-properties'!

testDefinitive
	self description beDefinitive.
	self assert: self description isDefinitive.
	self assert: self description definitive.

	self description beModifiable.
	self deny: self description isDefinitive.
	self deny: self description definitive
!

testOrdered
	self description beOrdered.
	self assert: self description isOrdered.
	self assert: self description ordered.

	self description beUnordered.
	self deny: self description isOrdered.
	self deny: self description ordered
!

testSorted
	self description beSorted.
	self assert: self description isSorted.
	self assert: self description sorted.

	self description beUnsorted.
	self deny: self description isSorted.
	self deny: self description sorted
! !

!MAToManyRelationDescriptionTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/tests/Magritte__MAToManyRelationDescriptionTest.st,v 1.1 2009-07-29 15:24:16 cg Exp $'
! !
