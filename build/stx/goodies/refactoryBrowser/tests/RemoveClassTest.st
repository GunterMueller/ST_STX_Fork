"{ Package: 'stx:goodies/refactoryBrowser/tests' }"

RefactoringTest subclass:#RemoveClassTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Testing'
!


!RemoveClassTest methodsFor:'failure tests'!

testBadName
	self 
		shouldFail: (RemoveClassRefactoring classNames: #(#RecursiveSelfRule))
!

testRemoveReferenced
	self 
		shouldFail: (RemoveClassRefactoring classNames: #(#BasicLintRuleTest))
! !

!RemoveClassTest methodsFor:'tests'!

testRemoveClass
	| refactoring |

	((Smalltalk respondsTo:#isSmalltalkX) and:[Smalltalk isSmalltalkX]) ifTrue:[
	    FooLintRuleTest autoload
	].
	refactoring := RemoveClassRefactoring 
				classNames: (Array with: ('Foo' , 'LintRuleTest') asSymbol).
	self executeRefactoring: refactoring.
	self 
		assert: (refactoring model classNamed: ('Foo' , 'LintRuleTest') asSymbol) 
				isNil.
	self 
		assert: (refactoring model classNamed: #TransformationRuleTest) superclass 
				= (refactoring model classNamed: #LintRuleTest)
! !

!RemoveClassTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/tests/RemoveClassTest.st,v 1.4 2003-10-06 14:39:33 cg Exp $'
! !
