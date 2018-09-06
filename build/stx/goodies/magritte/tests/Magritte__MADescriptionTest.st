"{ Package: 'stx:goodies/magritte/tests' }"

"{ NameSpace: Magritte }"

MAObjectTest subclass:#MADescriptionTest
	instanceVariableNames:'description'
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Tests-Description'
!


!MADescriptionTest class methodsFor:'testing'!

isAbstract
	^ true
!

shouldInheritSelectors
	^ true
! !

!MADescriptionTest methodsFor:'accessing'!

description
	^ description
!

instance
	^ description
! !

!MADescriptionTest methodsFor:'private'!

actualClass
	^ MADescription
!

descriptionInstance
	^ self actualClass new
		accessor: MANullAccessor new;
		yourself
! !

!MADescriptionTest methodsFor:'running'!

setUp
	super setUp.
	description := self descriptionInstance.
	self assert: description accessor notNil
! !

!MADescriptionTest methodsFor:'testing-accessing'!

testAccessor
	self description accessor: (MASelectorAccessor selector: #foo).
	self assert: self description accessor selector = #foo
!

testComment
	self description comment: 'bar'.
	self assert: self description comment = 'bar'
!

testGroup
	self assert: self description group isNil.
	self description group: 'foo'.
	self assert: self description group = 'foo'
!

testLabel
	self description label: 'foo'.
	self assert: self description label = 'foo'
!

testPriority
	self description priority: 123.
	self assert: self description priority = 123
! !

!MADescriptionTest methodsFor:'testing-actions'!

testReadonly
	self description beReadonly.
	self assert: self description readonly.
	self assert: self description isReadonly.

	self description beWriteable.
	self deny: self description readonly.
	self deny: self description isReadonly
!

testRequired
	self description beRequired.
	self assert: self description required.
	self assert: self description isRequired.

	self description beOptional.
	self deny: self description required.
	self deny: self description isRequired
!

testVisible
	self description beHidden.
	self deny: self description visible.
	self deny: self description isVisible.

	self description beVisible.
	self assert: self description visible.
	self assert: self description isVisible
! !

!MADescriptionTest methodsFor:'testing-converting'!

testAsContainer
	self subclassResponsibility
! !

!MADescriptionTest methodsFor:'testing-copying'!

testCopyAccessor
	self assert: self description copy accessor = self description accessor.
	self deny: self description copy accessor == self description accessor
! !

!MADescriptionTest methodsFor:'testing-identity'!

testDictionaryKey
	| dictionary |
	dictionary := Dictionary new.

	dictionary at: self instance put: 1.
	self assert: (dictionary at: self instance) = 1.

	dictionary at: self instance put: 2.
	self assert: (dictionary at: self instance) = 2
!

testSetElement
	| set |
	set := Set new.

	set add: self instance.
	self assert: set size = 1.
	self assert: (set includes: self instance).

	set add: self instance.
	self assert: set size = 1.
	self assert: (set includes: self instance)
! !

!MADescriptionTest methodsFor:'testing-testing'!

testHasChildren
	self deny: self description hasChildren
!

testHasComment
	self description comment: nil.
	self deny: self description hasComment.

	self description comment: ''.
	self deny: self description hasComment.

	self description comment: 'comment'.
	self assert:  self description hasComment
!

testHasLabel
	self description label: nil.
	self deny: self description hasLabel.

	self description label: ''.
	self deny: self description hasLabel.

	self description label: 'label'.
	self assert:  self description hasLabel
!

testIsContainer
	self deny: self description isContainer
!

testIsDescription
	self assert: self description isDescription
!

testIsSortable
	self assert: (self description isSortable or: [ self description isSortable not ])
! !

!MADescriptionTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/tests/Magritte__MADescriptionTest.st,v 1.1 2009-07-29 15:20:22 cg Exp $'
! !
