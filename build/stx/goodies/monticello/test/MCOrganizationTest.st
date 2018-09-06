"{ Package: 'stx:goodies/monticello/test' }"

MCTestCase subclass:#MCOrganizationTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Tests'
!


!MCOrganizationTest methodsFor:'as yet unclassified'!

testReordering
	|dec cats newCats |
	dec _ MCOrganizationDefinition categories: #(A B C).
	cats _ #(X Y B Z C A Q).
	newCats _ dec reorderCategories: cats original: #(B C A).
	self assert: newCats asArray = #(X Y A B C Z Q).
!

testReorderingWithNoCategoriesInVersion
	|dec cats newCats |
	dec _ MCOrganizationDefinition categories: #().
	cats _ #(X Y B Z C A Q).
	newCats _ dec reorderCategories: cats original: #().
	self assert: newCats asArray = cats.
!

testReorderingWithRemovals
	|dec cats newCats |
	dec _ MCOrganizationDefinition categories: #(A B C).
	cats _ #(X Y B Z C A Q).
	newCats _ dec reorderCategories: cats original: #(Y B C A Q).
	self assert: newCats asArray = #(X A B C Z).
! !

!MCOrganizationTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/test/MCOrganizationTest.st,v 1.2 2013-05-29 00:00:39 vrany Exp $'
! !

