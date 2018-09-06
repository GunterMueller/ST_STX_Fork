"{ Package: 'stx:goodies/refactoryBrowser/tests' }"

LintRuleTest subclass:#CompositeLintRuleTest
	instanceVariableNames:'rules'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Test data'
!


!CompositeLintRuleTest class methodsFor:'instance creation'!

allRules
	^self ruleFor: self protocol: 'all checks'
!

ruleFor: aClass protocol: aProtocol 
	^self
		rules: (((BrowserEnvironment new selectorsFor: aProtocol asSymbol in: aClass class)
				collect: [:selector | aClass perform: selector])
					asSortedCollection: [:a :b | a name < b name])
		name: ((aProtocol asString copy) at: 1 put: aProtocol first asUppercase;
				yourself)
!

rules: aCollection 
	^self new rules: aCollection
!

rules: aCollection name: aString 
	^(self new) rules: aCollection;
		name: aString;
		yourself
! !

!CompositeLintRuleTest class methodsFor:'all checks'!

lintChecks
	^self rules: (BasicLintRuleTest protocols
				collect: [:each | self ruleFor: BasicLintRuleTest protocol: each])
		name: 'Lint checks'
!

transformations
	^self ruleFor: TransformationRuleTest protocol: 'transformations'
! !

!CompositeLintRuleTest methodsFor:'accessing'!

checkClass: aSmalllintContext 
	rules do: 
			[:each | 
			each checkClass: aSmalllintContext.
			Processor yield]
!

checkMethod: aSmalllintContext 
	rules do: 
			[:each | 
			each checkMethod: aSmalllintContext.
			Processor yield]
!

failedRules
	^rules inject: OrderedCollection new into: [:oc :each | oc addAll: each failedRules; yourself]
!

problemCount
	^rules inject: 0 into: [:count :each | count + each problemCount]
!

rules
	^rules
! !

!CompositeLintRuleTest methodsFor:'initialize-release'!

resetResult
	rules do: [:each | each resetResult]
!

rules: aCollection
	rules := aCollection
! !

!CompositeLintRuleTest methodsFor:'private'!

viewResults
	rules do: [:each | each viewResults]
! !

!CompositeLintRuleTest methodsFor:'testing'!

hasConflicts
	^(rules detect: [:each | each hasConflicts] ifNone: [nil]) notNil
!

isComposite
	^true
!

isEmpty
	^(rules detect: [:each | each isEmpty not] ifNone: [nil]) isNil
! !

!CompositeLintRuleTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/tests/CompositeLintRuleTest.st,v 1.3 2003-10-06 14:39:33 cg Exp $'
! !
