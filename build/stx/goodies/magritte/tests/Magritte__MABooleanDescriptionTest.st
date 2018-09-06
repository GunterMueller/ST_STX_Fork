"{ Package: 'stx:libcompat' }"

"{ NameSpace: Magritte }"

MAElementDescriptionTest subclass:#MABooleanDescriptionTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Tests-Description'
!


!MABooleanDescriptionTest class methodsFor:'testing'!

isAbstract
	^ false
! !

!MABooleanDescriptionTest methodsFor:'private'!

actualClass
	^ MABooleanDescription
!

includedInstance
	^ true
! !

!MABooleanDescriptionTest methodsFor:'testing'!

testFalseString
	self description falseString: 'nein'.
	self assert: (self description labelForOption: false) = 'nein'
!

testLabelForOption
	self assert: (self description labelForOption: true) = 'true'.
	self assert: (self description labelForOption: false) = 'false'.
	self assert: (self description labelForOption: nil) = ''
!

testOptions
	self assert: (self description options) = #(false true).
	self assert: (self description allOptionsWith: Object new) = #(false true)
!

testTrueString
	self description trueString: 'ja'.
	self assert: (self description labelForOption: true) = 'ja'
! !

!MABooleanDescriptionTest methodsFor:'testing-validation'!

testValidateConditions
! !

!MABooleanDescriptionTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/tests/Magritte__MABooleanDescriptionTest.st,v 1.1 2009-07-29 15:24:44 cg Exp $'
! !
