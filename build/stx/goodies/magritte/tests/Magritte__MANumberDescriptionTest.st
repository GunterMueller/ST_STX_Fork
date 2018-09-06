"{ Package: 'stx:goodies/magritte/tests' }"

"{ NameSpace: Magritte }"

MAMagnitudeDescriptionTest subclass:#MANumberDescriptionTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Tests-Description'
!


!MANumberDescriptionTest class methodsFor:'testing'!

isAbstract
	^ false
! !

!MANumberDescriptionTest methodsFor:'private'!

actualClass
	^ MANumberDescription
!

excludedInstance
	^ 0.6180
!

includedInstance
	^ 2.7182
!

maxInstance
	^ 3.1415
!

minInstance
	^ 1.6180
!

testFromString
	"We do some special tests here because #visitNumberDescription: in
	MAStringReader works around problems with Number>>readFrom."
	self shouldSkipStringTests
		ifTrue: [^ self].
	super testFromString.
	self
		should: [self description fromString: 'xyz']
		raise: MAReadError
		description: 'Non-numeric string should raise an error'.
	self
		should: [self description fromString: '12-234']
		raise: MAReadError
		description: 'Non-numeric string should raise an error'.
	self
		should: [self description fromString: '1.4.2007']
		raise: MAReadError
		description: 'Non-numeric string should raise an error'.
	self assert: (self description fromString: '') isNil description: 'Empty string should be parsed to nil'.
	self assert: (self description fromString: '-20')
			= -20 description: 'Negative numbers should be accepted'
! !

!MANumberDescriptionTest methodsFor:'testing'!

testBeInteger
	self description beInteger.
	self assert: (self description isSatisfiedBy: 1).
	self assert: (self description isSatisfiedBy: -1).
	self deny: (self description isSatisfiedBy: 1 / 2).
	self deny: (self description isSatisfiedBy: 1.2)
!

testBeNegative
	self description beNegative.
	self assert: (self description isSatisfiedBy: -1).
	self assert: (self description isSatisfiedBy: -1.5).
	self deny: (self description isSatisfiedBy: 1).
	self deny: (self description isSatisfiedBy: 1.5)
!

testBePositive
	self description bePositive.
	self assert: (self description isSatisfiedBy: 1).
	self assert: (self description isSatisfiedBy: 1.5).
	self deny: (self description isSatisfiedBy: -0.1).
	self deny: (self description isSatisfiedBy: -1)
!

testValidateConditions
! !

!MANumberDescriptionTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/tests/Magritte__MANumberDescriptionTest.st,v 1.1 2009-07-29 15:18:44 cg Exp $'
! !
