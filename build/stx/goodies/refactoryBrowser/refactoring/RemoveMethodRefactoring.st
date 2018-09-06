"{ Package: 'stx:goodies/refactoryBrowser/refactoring' }"

MethodRefactoring subclass:#RemoveMethodRefactoring
	instanceVariableNames:'selectors'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Refactorings'
!


!RemoveMethodRefactoring class methodsFor:'instance creation'!

model: aRBSmalltalk removeMethods: selectorCollection from: aClass 
	^(self new)
		model: aRBSmalltalk;
		removeMethods: selectorCollection from: aClass;
		yourself
!

removeMethods: selectorCollection from: aClass
	^self new removeMethods: selectorCollection from: aClass
! !

!RemoveMethodRefactoring methodsFor:'initialize-release'!

removeMethods: selectorCollection from: aClass 
	class := self classObjectFor: aClass.
	selectors := selectorCollection
! !

!RemoveMethodRefactoring methodsFor:'preconditions'!

checkReferencesToAnyOf: aSelectorCollection 
	aSelectorCollection do: 
			[:each | 
			self model allReferencesTo: each
				do: 
					[:aRBMethod | 
					(aSelectorCollection includes: aRBMethod selector) 
						ifFalse: 
							[self 
								refactoringError: ('Possible call to <2s> in <1p><n>Browse references?' 
										expandMacrosWith: aRBMethod modelClass
										with: each)
								with: [self openBrowserOn: (BrowserEnvironment new referencesTo: each)]]]]
!

checkReferencesToSuperSendsToAnyOf: superMessages 
	[superMessages isEmpty] whileFalse: 
			[self 
				refactoringWarning: ('Although <1s> is equivalent to a superclass method,<n>it contains a super send so it might modify behavior.' 
						expandMacrosWith: superMessages first).
			superMessages remove: superMessages first]
!

checkSuperMethods
	| superMessages nonSupers |
	nonSupers := OrderedCollection new.
	superMessages := OrderedCollection new.
	(selectors reject: [:each | self justSendsSuper: each]) do: 
			[:each | 
			(self superclassEquivalentlyDefines: each) 
				ifTrue: 
					[(class parseTreeFor: each) superMessages isEmpty 
						ifFalse: [superMessages add: each]]
				ifFalse: [nonSupers add: each]].
	nonSupers isEmpty & superMessages isEmpty ifTrue: [^self].
	self checkReferencesToAnyOf: nonSupers.
	self checkReferencesToSuperSendsToAnyOf: superMessages
!

justSendsSuper: aSelector 
	| matcher parseTree superclass |
	matcher := ParseTreeSearcher justSendsSuper.
	parseTree := class parseTreeFor: aSelector.
	(matcher executeTree: parseTree initialAnswer: false) ifFalse: [^false].
	parseTree lastIsReturn ifTrue: [^true].
	superclass := class superclass whichClassIncludesSelector: aSelector.
	superclass isNil ifTrue: [^true].	"Since there isn't a superclass that implements the message, we can 
								 delete it since it would be an error anyway."
	parseTree := superclass parseTreeFor: aSelector.
	matcher := ParseTreeSearcher new.
	matcher matches: '^``@object'
		do: 
			[:aNode :answer | 
			answer
				add: aNode value;
				yourself].
	matcher executeTree: parseTree initialAnswer: Set new.
	^(matcher answer 
		detect: [:each | (each isVariable and: [each name = 'self']) not]
		ifNone: [nil]) isNil
!

preconditions
        ^(selectors inject: RBCondition empty
                into: [:cond :each | cond & (RBCondition definesSelector: each in: class)]) 
                        & (RBCondition withBlock: 
                                                [self checkSuperMethods.
                                                true])
!

superclassEquivalentlyDefines: aSelector 
	| superTree myTree |
	class superclass isNil ifTrue: [^false].
	superTree := class superclass parseTreeFor: aSelector.
	myTree := class parseTreeFor: aSelector.
	(superTree isNil or: [myTree isNil]) ifTrue: [^false].
	^superTree equalTo: myTree exceptForVariables: #()
! !

!RemoveMethodRefactoring methodsFor:'printing'!

storeOn: aStream 
	aStream nextPut: $(.
	self class storeOn: aStream.
	aStream nextPutAll: ' removeMethods: '.
	selectors asArray storeOn: aStream.
	aStream nextPutAll: ' from: '.
	class storeOn: aStream.
	aStream nextPut: $)
! !

!RemoveMethodRefactoring methodsFor:'transforming'!

transform
	selectors do: [:each | class removeMethod: each]
! !

!RemoveMethodRefactoring class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/refactoring/RemoveMethodRefactoring.st,v 1.10 2004-06-18 08:15:31 ca Exp $'
! !
