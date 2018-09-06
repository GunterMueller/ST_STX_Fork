"{ Package: 'stx:libcompat' }"

"{ NameSpace: Magritte }"

MAElementDescriptionTest subclass:#MAMagnitudeDescriptionTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Tests-Description'
!


!MAMagnitudeDescriptionTest class methodsFor:'testing'!

isAbstract
	^ true
! !

!MAMagnitudeDescriptionTest methodsFor:'private'!

actualClass
	^ MAMagnitudeDescription
!

excludedInstance
	self subclassResponsibility
!

maxInstance
	self subclassResponsibility
!

minInstance
	self subclassResponsibility
! !

!MAMagnitudeDescriptionTest methodsFor:'testing'!

testInfToInf
	self assert: self description min isNil.
	self assert: self description max isNil.

	self assert: (self description isSatisfiedBy: self minInstance).
	self assert: (self description isSatisfiedBy: self includedInstance).
	self assert: (self description isSatisfiedBy: self maxInstance)
!

testInfToVal
	self description max: self includedInstance.

	self assert: self description min isNil.
	self assert: self description max = self includedInstance.

	self assert: (self description isSatisfiedBy: self minInstance).
	self assert: (self description isSatisfiedBy: self includedInstance).
	self deny: (self description isSatisfiedBy: self maxInstance)
!

testValToInf
	self description min: self includedInstance.

	self assert: self description min = self includedInstance.
	self assert: self description max isNil.

	self deny: (self description isSatisfiedBy: self minInstance).
	self assert: (self description isSatisfiedBy: self includedInstance).
	self assert: (self description isSatisfiedBy: self maxInstance)
!

testValToVal
	self description min: self includedInstance.
	self description max: self includedInstance.

	self assert: self description min = self includedInstance.
	self assert: self description max = self includedInstance.

	self deny: (self description isSatisfiedBy: self minInstance).
	self assert: (self description isSatisfiedBy: self includedInstance).
	self deny: (self description isSatisfiedBy: self maxInstance)
! !

!MAMagnitudeDescriptionTest methodsFor:'testing-accessing'!

testMax
	self description max: self maxInstance.
	self assert: self description max = self maxInstance
!

testMin
	self description min: self minInstance.
	self assert: self description min = self minInstance
!

testMinMax
	self description min: self minInstance max: self maxInstance.
	self assert: self description min = self minInstance.
	self assert: self description max = self maxInstance
! !

!MAMagnitudeDescriptionTest methodsFor:'testing-validation'!

testRangeErrorMessage
	self description
		min: self minInstance;
		max: self maxInstance.
	self assert: self description rangeErrorMessage notEmpty.

	self description rangeErrorMessage: 'zork'.
	self assert: self description rangeErrorMessage = 'zork'.

	[ self description validate: self excludedInstance ]
		on: MARangeError
		do: [ :err | self assert: self description rangeErrorMessage = err messageText ]
!

testRangeErrorMessageGenerated
	self description min: nil max: nil.
	self assert: self description rangeErrorMessage isNil.
	
	self description min: nil max: self maxInstance.
	self assert: self description rangeErrorMessage notEmpty.
	
	self description min: self minInstance max: nil.
	self assert: self description rangeErrorMessage notEmpty.

	self description min: self minInstance max: self maxInstance.
	self assert: self description rangeErrorMessage notEmpty
!

testValidateSpecific
	super testValidateSpecific.
	self description
		min: self minInstance;
		max: self maxInstance.
	self
		shouldnt: [ self description validate: self includedInstance ]
		raise: MARangeError.
	self
		should: [ self description validate: self excludedInstance ]
		raise: MARangeError
! !

!MAMagnitudeDescriptionTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/tests/Magritte__MAMagnitudeDescriptionTest.st,v 1.1 2009-07-29 15:24:36 cg Exp $'
! !
