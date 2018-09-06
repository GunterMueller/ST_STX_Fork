"{ Package: 'stx:goodies/refactoryBrowser/tests' }"

RefactoringTest subclass:#MoveVariableDefinitionTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Testing'
!


!MoveVariableDefinitionTest methodsFor:'tests'!

testMoveDefinition
	| refactoring |
	refactoring := MoveVariableDefinitionRefactoring 
				bindTight: (self convertInterval: (19 to: 22)
						for: (RefactoryTestDataApp sourceCodeAt: #moveDefinition))
				in: RefactoryTestDataApp
				selector: #moveDefinition.
	self executeRefactoring: refactoring.
	self 
		assert: ((refactoring model classNamed: #RefactoryTestDataApp) 
				parseTreeFor: #moveDefinition) = (RBParser 
							parseMethod: 'moveDefinition
								^(self collect: 
										[:each | 
										| temp |
										temp := each printString.
										temp , temp]) 
									select: 
										[:each | 
										| temp |
										temp := each size.
										temp odd]')
!

testMoveDefinitionIntoBlockThatIsAReceiverOfACascadedMessage
	| refactoring |
	refactoring := MoveVariableDefinitionRefactoring 
				bindTight: (self convertInterval: (48 to: 58)
						for: (RefactoryTestDataApp sourceCodeAt: #referencesConditionFor:))
				in: RefactoryTestDataApp
				selector: #referencesConditionFor:.
	self executeRefactoring: refactoring.
	self 
		assert: ((refactoring model classNamed: #RefactoryTestDataApp) 
				parseTreeFor: #referencesConditionFor:) = (RBParser 
							parseMethod: 'referencesConditionFor: aClass 
								| environment  |
								^(RBCondition withBlock: 
										[| association |association := Smalltalk associationAt: aClass name
													ifAbsent: [self refactoringError: ''Could not find class''].
										environment := (self environment referencesTo: association) 
													| (self environment referencesTo: aClass name).
										environment isEmpty])
									errorMacro: aClass , '' is referenced.<n>Browse references?'';
									errorBlock: [environment openEditor];
									yourself')
!

testNoMoveDefinition
	self shouldFail: (MoveVariableDefinitionRefactoring 
				bindTight: (self convertInterval: (21 to: 24)
						for: (RefactoryTestDataApp sourceCodeAt: #moveDefinition))
				in: RefactoryTestDataApp
				selector: #noMoveDefinition)
!

testNonExistantName
	self
		shouldFail: (MoveVariableDefinitionRefactoring 
					bindTight: (1 to: 10)
					in: LintRuleTest
					selector: #name1);
		shouldFail: (MoveVariableDefinitionRefactoring 
					bindTight: (self convertInterval: (44 to: 54)
							for: (LintRuleTest sourceCodeAt: #displayName))
					in: LintRuleTest
					selector: #displayName);
		shouldFail: (MoveVariableDefinitionRefactoring 
					bindTight: (self convertInterval: (16 to: 25)
							for: (LintRuleTest sourceCodeAt: #displayName))
					in: LintRuleTest
					selector: #displayName)
! !

!MoveVariableDefinitionTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/tests/MoveVariableDefinitionTest.st,v 1.3 2003-10-06 14:39:33 cg Exp $'
! !
