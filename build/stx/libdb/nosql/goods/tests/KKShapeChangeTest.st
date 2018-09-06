"{ Package: 'stx:libdb/nosql/goods/tests' }"

KKAbstractDBTest subclass:#KKShapeChangeTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-GOODS-Test'
!


!KKShapeChangeTest methodsFor:'running'!

expectedExistingVariableName

	^#existingVariable
!

newConnection
	^ KKConnection
		hostname: self dbHost
		port: self dbPort
!

newVariableName

	^#newVariable
!

tearDown
	"Make sure that KKClassForShapeChangeTest has only one i-var left named #existingVariable"

	| names |
	[names := KKClassForShapeChangeTest allInstVarNames.
	names size > 1 ifTrue:
		[names := names copyWithout: self expectedExistingVariableName.
		names do: [:name | KKClassForShapeChangeTest removeInstVarName: name]]]
			ensure: [super tearDown]
!

testSanity

	"Make sure that class has expected variable only, add a variable so that tearDown can remove it.  If this test fails then it probably means that KKClassForShapeChangeTest has been modified (maybe by some other test case) and not returned to its correct state."

	self assert: (KKClassForShapeChangeTest allInstVarNames size = 1).
	self assert: (KKClassForShapeChangeTest allInstVarNames first = self expectedExistingVariableName).

	KKClassForShapeChangeTest addInstVarName: #newVariable.
!

testTwoDifferentShapesInDatabase

	"Store two instances of KKClassForShapeChangeTest in the database with different shapes.  Make sure that we can make sense out of what we get back."

	| instance1 instance2 |
	instance1 := KKClassForShapeChangeTest new.
	instance1 instVarNamed: self expectedExistingVariableName put:  1.
	dbOne root at: 'instance1' put: instance1.
	dbOne commit.

	dbTwo refresh.
	KKClassForShapeChangeTest addInstVarName: self newVariableName.
	instance2 := KKClassForShapeChangeTest new.
	instance2 instVarNamed: self expectedExistingVariableName put: 'existing'.
	instance2 instVarNamed: self newVariableName put: 'new'.
	dbTwo root at: 'instance2' put: instance2.
	dbTwo commit.

	instance1 := nil.
	instance2 := nil.

	dbOne flushAll.
	"self assert: dbOne cacheSize = 0."
	self assert: ((dbOne root at: 'instance1') instVarNamed: self expectedExistingVariableName) = 1.
	self assert: ((dbOne root at: 'instance1') instVarNamed: self newVariableName) isNil.
	self assert: ((dbOne root at: 'instance2') instVarNamed: self expectedExistingVariableName) = 'existing'.
	self assert: ((dbOne root at: 'instance2') instVarNamed: self newVariableName) = 'new'.
! !

!KKShapeChangeTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/tests/KKShapeChangeTest.st,v 1.3 2013-03-28 10:38:50 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/tests/KKShapeChangeTest.st,v 1.3 2013-03-28 10:38:50 cg Exp $'
! !

