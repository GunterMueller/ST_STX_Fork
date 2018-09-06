"{ Package: 'stx:goodies/monticello/test' }"

MCTestCase subclass:#MCVersionTest
	instanceVariableNames:'version'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Tests'
!


!MCVersionTest methodsFor:'asserting'!

assert: aSelector orders: sexpr as: array
	| expected |
	expected := OrderedCollection new.
	version := self versionFromTree: sexpr.
	version perform: aSelector with: [:ea | expected add: ea info name].
	self assert: expected asArray = array
!

assert: aSelector orders: sexpr as: expected unresolved: unresolved
	| missing visited |
	visited := OrderedCollection new.
	missing := OrderedCollection new.
	version := self versionFromTree: sexpr.
	version 
		perform: aSelector 
		with: [:ea | visited add: ea info name]
		with: [:ea | missing add: ea name].
	self assert: visited asArray = expected.
	self assert: missing asArray = unresolved.
! !

!MCVersionTest methodsFor:'building'!

dependencyFromTree: sexpr
	^ MCMockDependency fromTree: sexpr
!

versionFromTree: sexpr
	^ (self dependencyFromTree: sexpr) resolve
! !

!MCVersionTest methodsFor:'tests'!

testAllAvailablePostOrder
	self 
		assert: #allAvailableDependenciesDo: 
		orders: #(a ((b (d e)) c)) 
		as: #(d e b c)
!

testAllMissing
	self 
		assert: #allDependenciesDo: 
		orders: #(a ((b (d e)) (c missing))) 
		as: #(d e b)
!

testAllUnresolved
	self 
		assert: #allDependenciesDo:ifUnresolved: 
		orders: #(a ((b (d e)) (c missing)))
		as: #(d e b)
		unresolved: #(c)
!

testDependencyOrder
	self 
		assert: #allDependenciesDo: 
		orders: #(a (b c)) 
		as: #(b c)
!

testPostOrder
	self 
		assert: #allDependenciesDo: 
		orders: #(a ((b (d e)) c)) 
		as: #(d e b c)
!

testWithAll
	self 
		assert: #withAllDependenciesDo: 
		orders: #(a ((b (d e)) c)) 
		as: #(d e b c a)
!

testWithAllMissing
	self 
		assert: #withAllDependenciesDo: 
		orders: #(a ((b (d e)) (c missing))) 
		as: #(d e b a)
!

testWithAllUnresolved
	self 
		assert: #withAllDependenciesDo:ifUnresolved: 
		orders: #(a ((b (d e)) (c missing)))
		as: #(d e b a)
		unresolved: #(c)
! !

!MCVersionTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/test/MCVersionTest.st,v 1.2 2013-05-29 00:01:51 vrany Exp $'
! !

