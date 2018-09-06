"{ Package: 'stx:goodies/magritte/tests' }"

"{ NameSpace: Magritte }"

MADescriptionTest subclass:#MAElementDescriptionTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Tests-Description'
!


!MAElementDescriptionTest class methodsFor:'testing'!

isAbstract
	^ true
! !

!MAElementDescriptionTest methodsFor:'private'!

actualClass
	^ MAElementDescription
!

emptyInstance
	^ String new
!

includedInstance
	self subclassResponsibility
!

includedInstanceString
	^ MAStringWriter write: self includedInstance description: self descriptionInstance
!

invalidInstance
	^ Object new
!

invalidInstanceString
	^ self invalidInstance asString
!

nullInstance
	^ nil
!

shouldSkipStringTests
	^ false
! !

!MAElementDescriptionTest methodsFor:'testing-accessing'!

testDefault
	self description default: self includedInstance.
	self assert: self description default = self includedInstance
!

testKind
	self assert: (self includedInstance isKindOf: self description kind)
!

testStringReader
	| object |
	self description stringReader: (object := MAStringReader new).
	self assert: self description stringReader = object
!

testStringWriter
	| object |
	self description stringWriter: (object := MAStringWriter new).
	self assert: self description stringWriter = object
!

testUndefined
	self description undefined: 'nop'.
	self assert: self description undefined = 'nop'
! !

!MAElementDescriptionTest methodsFor:'testing-converting'!

testAsContainer
	self assert: (self description asContainer size) = 1.
	self assert: (self description asContainer includes: self description)
! !

!MAElementDescriptionTest methodsFor:'testing-copying'!

testCopy
	super testCopy.
	self assert: self description copy default = self description default
! !

!MAElementDescriptionTest methodsFor:'testing-operators'!

testConcatenation
	| child1 child2 concatenate |
	child1 := self description copy.
	child2 := self description copy.

	concatenate := child1 , child2.
	self assert: concatenate size = 2.
	self assert: concatenate children first = child1.
	self assert: concatenate children second = child2.

	concatenate := child1 , concatenate.
	self assert: concatenate size = 3.
	self assert: concatenate children first = child1.
	self assert: concatenate children second = child1.
	self assert: concatenate children third = child2
! !

!MAElementDescriptionTest methodsFor:'testing-strings'!

testFromString
        self shouldSkipStringTests ifTrue: [ ^ self ].
        self assert: (self description
                fromString: self includedInstanceString)
                        = self includedInstance.
        self assert: (self description
                fromString: self includedInstanceString
                reader: self description stringReader)
                        = self includedInstance.
        self assert: (self description
                fromString: self includedInstanceString
                reader: self description stringReader new)
                        = self includedInstance
!

testFromStringCollection
	self shouldSkipStringTests ifTrue: [ ^ self ].
	self assert: (self description
		fromStringCollection: (Array
			with: self includedInstanceString
			with: self includedInstanceString))
				= (Array
					with: self includedInstance
					with: self includedInstance).
	self assert: (self description
		fromStringCollection: (Array
			with: self includedInstanceString
			with: self includedInstanceString)
		reader: self description stringReader)
				= (Array
					with: self includedInstance
					with: self includedInstance)
!

testFromStringEvaluated
	"This ensures that the parsing algorithm doesn't compile the input, what would cause a  security hole in the framework."

	| error |
	error := nil.
	self shouldSkipStringTests ifTrue: [ ^ self ].
	[ self description fromString: '1 / 0. nil' ]
		on: Exception 
		do: [ :err | error := err ].
	self deny: (error isKindOf: ZeroDivide)
!

testFromStringInvalid
	self shouldSkipStringTests ifTrue: [ ^ self ].
	self
		should: [ self description fromString: self invalidInstanceString ]
		raise: MAReadError
!

testFromStringNull
	self shouldSkipStringTests ifTrue: [ ^ self ].
	self assert: (self description
		fromString: self emptyInstance) isNil.
	self assert: (self description
		fromString: self emptyInstance
		reader: self description stringReader) isNil.
	self assert: (self description
		fromString: self emptyInstance
		reader: self description stringReader new) isNil
!

testToString
	self shouldSkipStringTests ifTrue: [ ^ self ].
	self assert: (self description
		toString: self includedInstance)
			= self includedInstanceString.
	self assert: (self description
		toString: self includedInstance
		writer: self description stringWriter)
			= self includedInstanceString.
	self assert: (self description
		toString: self includedInstance
		writer: self description stringWriter new)
			= self includedInstanceString
!

testToStringCollection
	self shouldSkipStringTests ifTrue: [ ^ self ].
	self assert: (self description
		toStringCollection: (Array
			with: self includedInstance
			with: self includedInstance))
				= (Array
					with: self includedInstanceString
					with: self includedInstanceString).
	self assert: (self description
		toStringCollection: (Array
			with: self includedInstance
			with: self includedInstance)
		writer: self description stringWriter)
			= (Array
				with: self includedInstanceString
				with: self includedInstanceString)
!

testToStringFromString
	self shouldSkipStringTests ifTrue: [ ^ self ].
	self assert: (self description
		fromString: (self description
			toString: self includedInstance))
				= self includedInstance.
	self assert: (self description
		fromString: (self description
			toString: self includedInstance
			writer: self description stringWriter)
		reader: self description stringReader)
				= self includedInstance.
	self assert: (self description
		fromString: (self description
			toString: self includedInstance
			writer: self description stringWriter new)
		reader: self description stringReader new)
				= self includedInstance
!

testToStringNull
	self shouldSkipStringTests ifTrue: [ ^ self ].
	self assert: (self description
		toString: self nullInstance)
			= self description undefined.
	self assert: (self description
		toString: self nullInstance
		writer: self description stringWriter)
			= self description undefined.
	self assert: (self description
		toString: self nullInstance
		writer: self description stringWriter new)
			= self description undefined
!

testToStringUndefined
	self shouldSkipStringTests ifTrue: [ ^ self ].
	self description undefined: 'n/a'.
	self assert: (self description
		toString: self nullInstance)
			= 'n/a'.
	self assert: (self description
		toString: self nullInstance
		writer: self description stringWriter)
			= 'n/a'.
	self assert: (self description
		toString: self nullInstance
		writer: self description stringWriter new)
			= 'n/a'
! !

!MAElementDescriptionTest methodsFor:'testing-testing'!

testSatisfied
	self assert: (self description isSatisfiedBy: self includedInstance).
	self assert: (self description isSatisfiedBy: self nullInstance).
	self deny: (self description isSatisfiedBy: self invalidInstance)
! !

!MAElementDescriptionTest methodsFor:'testing-validation'!

testAddCondition
	self description
		addCondition: [ :value | value isNil ].

	self assert: self description conditions size = 1.
	self assert: self description conditions first value isString
!

testAddConditionLabelled
	self description
		addCondition: [ :value | value isNil ]
		labelled: 'ist net nil'.

	self assert: self description conditions size = 1.
	self assert: self description conditions first value = 'ist net nil'
!

testKindErrorMessage
	self assert: self description kindErrorMessage notEmpty.

	self description kindErrorMessage: 'zork'.
	self assert: self description kindErrorMessage = 'zork'.

	[ self description validateKind: self invalidInstance ]
		on: MAKindError
		do: [ :err | self assert: self description kindErrorMessage = err messageText ]
!

testRequiredErrorMessage
	self assert: self description requiredErrorMessage notEmpty.

	self description requiredErrorMessage: 'zork'.
	self assert: self description requiredErrorMessage = 'zork'.

	[ self description beRequired; validateRequired: self nullInstance ]
		on: MARequiredError
		do: [ :err | self assert: self description requiredErrorMessage = err messageText ]
!

testValidate
	self description beRequired.
	self
		shouldnt: [ self description validate: self includedInstance ]
		raise: MAValidationError.
	self
		should: [ self description validate: self invalidInstance ]
		raise: MAKindError.
	self
		should: [ self description validate: self nullInstance ]
		raise: MARequiredError
!

testValidateConditions
	"This test might fail for MADateDescriptionTest, since there is a bug in Squeak."

	| object |
	object := self includedInstance.
	self description
		addCondition: [ :value | object == value ]
		labelled: 'included instance test'.
	self
		shouldnt: [ self description validate: object ]
		raise: MAConditionError.
	self
		should: [ self description validate: object copy ]
		raise: MAConditionError
!

testValidateKind
	self
		should: [ self description validateKind: self invalidInstance ]
		raise: MAKindError.
	self
		shouldnt: [ self description validateKind: self includedInstance ]
		raise: MAKindError
!

testValidateRequired
	self description beOptional.
	self
		shouldnt: [ self description validateRequired: self nullInstance ]
		raise: MARequiredError.
	self
		shouldnt: [ self description validateRequired: self includedInstance ]
		raise: MARequiredError.

	self description beRequired.
	self
		should: [ self description validateRequired: self nullInstance ]
		raise: MARequiredError.
	self
		shouldnt: [ self description validateRequired: self includedInstance ]
		raise: MARequiredError
!

testValidateSpecific
	self
		shouldnt: [ self description validate: self includedInstance ]
		raise: MARequiredError
! !

!MAElementDescriptionTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/tests/Magritte__MAElementDescriptionTest.st,v 1.3 2014-09-23 20:30:00 vrany Exp $'
!

version_CVS
    ^ '$Path: stx/goodies/magritte/tests/Magritte__MAElementDescriptionTest.st, Version: 1.0, User: jv, Time: 2014-09-23T21:30:19.748$'
! !

