"{ Package: 'stx:goodies/monticello/test' }"

TestCase subclass:#MCDependencySorterTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Tests'
!


!MCDependencySorterTest methodsFor:'asserting'!

assertItems: anArray orderAs: depOrder withRequired: missingDeps toLoad: unloadableItems
	self assertItems: anArray orderAs: depOrder withRequired: missingDeps  toLoad: unloadableItems  extraProvisions: #()
!

assertItems: anArray orderAs: depOrder withRequired: missingDeps toLoad: unloadableItems extraProvisions: provisions
	| order sorter items missing unloadable |
	items _ anArray collect: [:ea | self itemWithSpec: ea].
	sorter _ MCDependencySorter items: items.
	sorter addExternalProvisions: provisions.
	order _ (sorter orderedItems collect: [:ea | ea name]) asArray.
	self assert: order = depOrder.
	missing _ sorter externalRequirements.
	self assert: missing asSet = missingDeps asSet.
	unloadable _ (sorter itemsWithMissingRequirements collect: [:ea | ea name]) asArray.
	self assert: unloadable asSet = unloadableItems asSet
! !

!MCDependencySorterTest methodsFor:'building'!

itemWithSpec: anArray
	^ MCMockDependentItem new
		name: anArray first;
		provides: anArray second;
		requires: anArray third
! !

!MCDependencySorterTest methodsFor:'tests'!

testCascadingUnresolved
	self assertItems: #(
		(a (x) (z))
		(b () (x))
		(c () ()))
	orderAs: #(c)
	withRequired: #(z)
	toLoad: #(a b)	
!

testCycle
	self assertItems: #(
		(a (x) (y))
		(b (y) (x)))
	orderAs: #()
	withRequired: #()
	toLoad: #(a b)	
!

testExtraProvisions
	self assertItems:
		#((a (x) (z))
		(b () (x)))
	orderAs: #(a b)
	withRequired: #()
	toLoad: #()	
	extraProvisions: #(x z)
!

testMultiRequirementOrdering
	self assertItems: #(
		(a (x) (z))
		(b (y) ())
		(c (z) ())
		(d () (x y z)))
		orderAs: #(b c a d)
		withRequired: #()
		toLoad: #()
!

testSimpleOrdering
	self assertItems: #((a (x) ())
								 (c () (y))
								 (b (y) (x)))
		orderAs: #(a b c)
		withRequired: #()
		toLoad: #()
!

testSimpleUnresolved
	self assertItems: #(
		(a () (z)))
	orderAs: #()
	withRequired: #(z)
	toLoad: #(a)
		
!

testUnusedAlternateProvider
	self assertItems: #(
		(a (x) (z))
		(b () (x))
		(c (x) ()))
	orderAs: #(c b)
	withRequired: #(z)
	toLoad: #(a)	
! !

!MCDependencySorterTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/test/MCDependencySorterTest.st,v 1.2 2013-05-29 00:00:09 vrany Exp $'
! !

