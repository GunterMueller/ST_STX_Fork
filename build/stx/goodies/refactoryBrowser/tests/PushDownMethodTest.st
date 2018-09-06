"{ Package: 'stx:goodies/refactoryBrowser/tests' }"

RefactoringTest subclass:#PushDownMethodTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Testing'
!


!PushDownMethodTest methodsFor:'failure tests'!

testPushDownMethodOnNonAbstractClass
	| refactoring |
	refactoring := PushDownMethodRefactoring pushDown: #(#yourself)
				from: Object.
	self shouldFail: refactoring
!

testPushDownNonExistantMenu
	| refactoring |
	refactoring := PushDownMethodRefactoring 
				pushDown: #(#someMethodThatDoesNotExist)
				from: LintRuleTest.
	self shouldFail: refactoring
! !

!PushDownMethodTest methodsFor:'tests'!

testPushDownMethod
	| refactoring class |
	refactoring := PushDownMethodRefactoring pushDown: #(#name:)
				from: LintRuleTest.
	self executeRefactoring: refactoring.
	class := refactoring model classNamed: #LintRuleTest.
	self deny: (class directlyDefinesMethod: #name:).
	class subclasses do: 
			[:each | 
			self assert: (each parseTreeFor: #name:) 
						= (RBParser parseMethod: 'name: aString name := aString')]
!

testPushDownMethodThatReferencesPoolDictionary
	| refactoring class parseTree |

	Smalltalk isSmalltalkX ifTrue:[
	    "no poolDictionaries supported"
	    ^ self
	].

	parseTree _ LintRuleTest parseTreeFor: #junk.
	self
		proceedThroughWarning: 
			[refactoring _ PushDownMethodRefactoring pushDown: #(junk ) from: LintRuleTest.
			self executeRefactoring: refactoring].
	class _ refactoring model classNamed: #LintRuleTest.
	self deny: (class directlyDefinesMethod: #junk).
	class subclasses do: 
		[:each | 
		self assert: (each parseTreeFor: #junk)
				= parseTree.
		self assert: (each directlyDefinesPoolDictionary: 'TextConstants' asSymbol)]

    "Modified: / 23.11.2001 / 13:27:39 / cg"
! !

!PushDownMethodTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/tests/PushDownMethodTest.st,v 1.4 2003-10-06 14:39:33 cg Exp $'
! !
