"{ Package: 'stx:goodies/refactoryBrowser/lint' }"

LintRule subclass:#CompositeLintRule
	instanceVariableNames:'rules'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint'
!

CompositeLintRule comment:'CompositeLintRule groups LintRules into a single rule (composite pattern).

Instance Variables:
	rules   <Collection of: LintRule>       the rules that make up the composite

'
!


!CompositeLintRule class methodsFor:'instance creation'!

allRules
	^self ruleFor: self protocol: 'all checks'
!

ruleFor: aClass protocol: aProtocol
	| allRules |
	allRules := aClass withAllSubclasses inject: OrderedCollection new
				into:
					[:sum :each |
					sum
						addAll: ((BrowserEnvironment new selectorsFor: aProtocol asSymbol in: each class)
								collect: [:selector | |rule|
										rule := each perform: selector.
										"/ added by CG: append name
										rule name:(rule name , ' [',selector,']').
										rule
									  ]);
						yourself].
	^self rules: (allRules asSortedCollection: [:a :b | a name < b name])
		name: ((aProtocol asString copy)
				at: 1 put: aProtocol first asUppercase;
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

!CompositeLintRule class methodsFor:'all checks'!

lintChecks
	^self rules: (BasicLintRule protocols
				collect: [:each | self ruleFor: BasicLintRule protocol: each])
		name: 'Lint checks'
!

transformations
	^self ruleFor: TransformationRule protocol: 'transformations'
! !

!CompositeLintRule methodsFor:'accessing'!

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

!CompositeLintRule methodsFor:'initialize-release'!

resetResult
	rules do: [:each | each resetResult]
!

rules: aCollection
	rules := aCollection
! !

!CompositeLintRule methodsFor:'private'!

viewResults
	rules do: [:each | each viewResults]
! !

!CompositeLintRule methodsFor:'testing'!

hasConflicts
	^(rules detect: [:each | each hasConflicts] ifNone: [nil]) notNil
!

isComposite
	^true
!

isEmpty
	^(rules detect: [:each | each isEmpty not] ifNone: [nil]) isNil
! !

!CompositeLintRule class methodsFor:'documentation'!

version
    ^ '$Header$'
! !
