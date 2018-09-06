"{ Package: 'stx:goodies/refactoryBrowser/tests' }"

RefactoringTest subclass:#ProtectInstanceVariableTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Testing'
!


!ProtectInstanceVariableTest methodsFor:'failure tests'!

testVariableNotDefined
	| refactoring |
	refactoring _ ProtectInstanceVariableRefactoring variable: 'rewrite' class: SubclassOfClassToRename.
	self shouldFail: refactoring.
! !

!ProtectInstanceVariableTest methodsFor:'setup'!

setUp
	super setUp.
	Class withoutUpdatingChangesDo:[
	    Object 
		subclass:#ClassToRename
		instanceVariableNames:'v1 v2 rewriteRule1'
		classVariableNames:'Cv1 Cv2'
		poolDictionaries:''
		category:'test'.

	    (Smalltalk at:#ClassToRename)
		subclass:#SubclassOfClassToRename
		instanceVariableNames:'s1 s2 rewriteRule2'
		classVariableNames:'SCv1 SCv2'
		poolDictionaries:''
		category:'test'.
	]
!

tearDown
	super tearDown.

	Class withoutUpdatingChangesDo:[
	    ClassToRename notNil ifTrue:[Smalltalk removeClass:ClassToRename].
	    SubclassOfClassToRename notNil ifTrue:[Smalltalk removeClass:SubclassOfClassToRename].
	].
! !

!ProtectInstanceVariableTest methodsFor:'tests'!

testProtectInstanceVariable
	| refactoring class |

	refactoring := ProtectInstanceVariableRefactoring 
				variable: 'rewrite' , 'Rule1'
				class: SubclassOfClassToRename.
	self executeRefactoring: refactoring.
	class := refactoring model classNamed: #SubclassOfClassToRename.
	self 
		assert: (class parseTreeFor: #calls1) = (RBParser 
						parseMethod: 'calls1
								^rewriteRule1 := (rewriteRule1 := self calls)').
	self 
		assert: (class parseTreeFor: #calls) = (RBParser 
						parseMethod: 'calls
								^rewriteRule1 := rewriteRule1 , rewriteRule1').
	self deny: (class directlyDefinesMethod: ('rewrite' , 'Rule1') asSymbol).
	self deny: (class directlyDefinesMethod: ('rewrite' , 'Rule1:') asSymbol)
! !

!ProtectInstanceVariableTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/tests/ProtectInstanceVariableTest.st,v 1.4 2003-10-06 14:39:33 cg Exp $'
! !
