"{ Package: 'stx:goodies/refactoryBrowser/lint/spelling' }"

RBSpellingRule subclass:#RBClassCategoriesSpellingRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Spelling'
!


!RBClassCategoriesSpellingRule methodsFor:'accessing'!

name
	^ 'Class categories'
!

resultClass
        ^ CategoryEnvironment "/ RBCategoryEnvironment
! !

!RBClassCategoriesSpellingRule methodsFor:'running'!

checkClass: aContext 
	| category |
	aContext selectedClass isMeta 
		ifTrue: [ ^ self ].
	category := aContext selectedClass category.
	(self checkSelector: category) do: [ :each | 
		result
			addSearchString: each;
			addCategory: category ]
! !

!RBClassCategoriesSpellingRule class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/lint/spelling/RBClassCategoriesSpellingRule.st,v 1.3 2013-08-21 00:09:03 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/lint/spelling/RBClassCategoriesSpellingRule.st,v 1.3 2013-08-21 00:09:03 cg Exp $'
! !

