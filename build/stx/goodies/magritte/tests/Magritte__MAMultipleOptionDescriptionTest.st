"{ Package: 'stx:libcompat' }"

"{ NameSpace: Magritte }"

MAOptionDescriptionTest subclass:#MAMultipleOptionDescriptionTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Tests-Description'
!


!MAMultipleOptionDescriptionTest class methodsFor:'accessing-default'!

defaultUnique
	^ false
! !

!MAMultipleOptionDescriptionTest class methodsFor:'testing'!

isAbstract
	^ false
! !

!MAMultipleOptionDescriptionTest methodsFor:'private'!

actualClass
	^ MAMultipleOptionDescription
!

includedInstance
	^ self optionInstances copyFrom: 1 to: 2
! !

!MAMultipleOptionDescriptionTest methodsFor:'testing-properties'!

testOrdered
	self description beOrdered.
	self assert: self description isOrdered.
	self assert: self description ordered.

	self description beUnordered.
	self deny: self description isOrdered.
	self deny: self description ordered
!

testSorted
	self description beDistinct.
	self assert: self description isDistinct.
	self assert: self description distinct.

	self description beIndefinite.
	self deny: self description isDistinct.
	self deny: self description distinct
! !

!MAMultipleOptionDescriptionTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/tests/Magritte__MAMultipleOptionDescriptionTest.st,v 1.1 2009-07-29 15:21:02 cg Exp $'
! !
