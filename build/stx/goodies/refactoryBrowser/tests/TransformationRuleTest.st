"{ Package: 'stx:goodies/refactoryBrowser/tests' }"

FooLintRuleTest subclass:#TransformationRuleTest
	instanceVariableNames:'rewriteRule builder class'
	classVariableNames:'RecursiveSelfRule'
	poolDictionaries:''
	category:'Refactory-Test data'
!


!TransformationRuleTest class methodsFor:'instance creation'!

rewrite: stringArrays methods: aBoolean name: aName 
	| rewriteRule |
	rewriteRule := ParseTreeRewriter new.
	stringArrays do: 
			[:each | 
			aBoolean
				ifTrue: [rewriteRule addMethodSearch: each first -> each last]
				ifFalse: [rewriteRule addSearch: each first -> each last]].
	^(self new) name: aName;
		rewriteUsing: rewriteRule;
		yourself
! !

!TransformationRuleTest class methodsFor:'class initialization'!

initializeAfterLoad1
	RecursiveSelfRule := ParseTreeSearcher new.
	RecursiveSelfRule
		addMethodSearches: #('`@methodName: `@args | `@temps | self `@methodName: `@args' '`@methodName: `@args | `@temps | ^self `@methodName: `@args')
				-> [:aNode :answer | true]
!

nuke
	RecursiveSelfRule := nil
! !

!TransformationRuleTest class methodsFor:'transformations'!

assignmentInIfTrue
	^self rewrite: #(
			#('``@Boolean ifTrue: [`variable := ``@true] ifFalse: [`variable := ``@false]'
			"->"
			'`variable := ``@Boolean ifTrue: [``@true] ifFalse: [``@false]')
			#('``@Boolean ifFalse: [`variable := ``@true] ifTrue: [`variable := ``@false]'
			"->"
			'`variable := ``@Boolean ifFalse: [``@true] ifTrue: [``@false]'))
		methods: false
		name: 'Move variable assignment outside of single statement ifTrue:ifFalse: blocks'
!

atIfAbsent
	^self rewrite: #(
			#('``@dictionary at: ``@key 
					ifAbsent: [| `@temps | 
							``@.Statements1.
							``@dictionary at: ``@key put: ``@object.
							``@.Statements2.
							``@object]'
			"->"
			'``@dictionary at: ``@key
					ifAbsentPut: [| `@temps |
							``@.Statements1.
							``@.Statements2.
							``@object]')
			#('``@dictionary at: ``@key
					ifAbsent: [| `@temps |
							``@.Statements.
							``@dictionary at: ``@key put: ``@object]'
			"->"
			'``@dictionary at: ``@key
					ifAbsentPut: [| `@temps |
							``@.Statements.
							``@object]'))
		methods: false
		name: 'at:ifAbsent: -> at:ifAbsentPut:'
!

betweenAnd
	^self rewrite: #(
			#('``@a >= ``@b and: [``@a <= ``@c]' "->" '``@a between: ``@b and: ``@c')
			#('``@a >= ``@b & (``@a <= ``@c)' "->" '``@a between: ``@b and: ``@c')
			#('``@b <= ``@a and: [``@a <= ``@c]' "->" '``@a between: ``@b and: ``@c')
			#('``@b <= ``@a & (``@a <= ``@c)' "->" '``@a between: ``@b and: ``@c')
			#('``@a <= ``@c and: [``@a >= ``@b]' "->" '``@a between: ``@b and: ``@c')
			#('``@a <= ``@c & (``@a >= ``@b)' "->" '``@a between: ``@b and: ``@c')
			#('``@c >= ``@a and: [``@a >= ``@b]' "->" '``@a between: ``@b and: ``@c')
			#('``@c >= ``@a & (``@a >= ``@b)' "->" '``@a between: ``@b and: ``@c')
			#('``@a >= ``@b and: [``@c >= ``@a]' "->" '``@a between: ``@b and: ``@c')
			#('``@a >= ``@b & (``@c >= ``@a)' "->" '``@a between: ``@b and: ``@c')
			#('``@b <= ``@a and: [``@c >= ``@a]' "->" '``@a between: ``@b and: ``@c')
			#('``@b <= ``@a & (``@c >= ``@a)' "->" '``@a between: ``@b and: ``@c')
			#('``@a <= ``@c and: [``@b <= ``@a]' "->" '``@a between: ``@b and: ``@c')
			#('``@a <= ``@c & (``@b <= ``@a)' "->" '``@a between: ``@b and: ``@c')
			#('``@c >= ``@a and: [``@b <= ``@a]' "->" '``@a between: ``@b and: ``@c')
			#('``@c >= ``@a & (``@b <= ``@a)' "->" '``@a between: ``@b and: ``@c'))
		methods: false
		name: '"a >= b and: [a <= c]" -> "a between: b and: c"'
!

detectIfNone
	^self rewrite: #(
			#('(``@collection detect: [:`each | | `@temps | ``@.Statements] ifNone: [nil]) isNil'
				"->"    '(``@collection contains: [:`each | | `@temps | ``@.Statements]) not')
			#('(``@collection detect: [:`each | | `@temps | ``@.Statements] ifNone: [nil]) = nil'
				"->"    '(``@collection contains: [:`each | | `@temps | ``@.Statements]) not')
			#('(``@collection detect: [:`each | | `@temps | ``@.Statements] ifNone: [nil]) == nil'
				"->"    '(``@collection contains: [:`each | | `@temps | ``@.Statements]) not')
			#('(``@collection detect: [:`each | | `@temps | ``@.Statements] ifNone: [nil]) notNil'
				"->"    '``@collection contains: [:`each | | `@temps | ``@.Statements]')
			#('(``@collection detect: [:`each | | `@temps | ``@.Statements] ifNone: [nil]) ~= nil'
				"->"    '``@collection contains: [:`each | | `@temps | ``@.Statements]')
			#('(``@collection detect: [:`each | | `@temps | ``@.Statements] ifNone: [nil]) ~~ nil'
				"->"    '``@collection contains: [:`each | | `@temps | ``@.Statements]'))
		methods: false
		name: 'detect:ifNone: -> contains:'
!

equalNil
	^self
		rewrite: #(
			#('``@object = nil'     "->"    '``@object isNil') 
			#('``@object == nil'    "->"    '``@object isNil') 
			#('``@object ~= nil'    "->"    '``@object notNil') 
			#('``@object ~~ nil'    "->"    '``@object notNil'))
		methods: false
		name: '= nil -> isNil AND ~= nil -> notNil'
!

guardClause
	^self
		rewrite: #(
			#('`@methodName: `@args 
					| `@temps | 
					`@.Statements. 
					`@condition ifTrue: [| `@trueTemps | `.Statement1. `.Statement2. `@.Statements1]'
			"->"
			'`@methodName: `@args
					| `@temps `@trueTemps |
					`@.Statements.
					`@condition ifFalse: [^self].
					`.Statement1.
					`.Statement2.
					`@.Statements1') 
			#('`@methodName: `@args 
					| `@temps | 
					`@.Statements. 
					`@condition ifFalse: [| `@falseTemps | `.Statement1. `.Statement2. `@.Statements1]'
			"->"
			'`@methodName: `@args
					| `@temps `@falseTemps |
					`@.Statements.
					`@condition ifTrue: [^self].
					`.Statement1.
					`.Statement2.
					`@.Statements1'))
		methods: true
		name: 'Eliminate guarding clauses'
!

minMax
	^self rewrite: #(
			#('``@a < ``@b ifTrue: [``@a] ifFalse: [``@b]'  "->"    '``@a min: ``@b')
			#('``@a <= ``@b ifTrue: [``@a] ifFalse: [``@b]' "->"    '``@a min: ``@b')
			#('``@a > ``@b ifTrue: [``@a] ifFalse: [``@b]'  "->"    '``@a max: ``@b')
			#('``@a >= ``@b ifTrue: [``@a] ifFalse: [``@b]' "->"    '``@a max: ``@b')
			#('``@a < ``@b ifTrue: [``@b] ifFalse: [``@a]'  "->"    '``@a max: ``@b')
			#('``@a <= ``@b ifTrue: [``@b] ifFalse: [``@a]' "->"    '``@a max: ``@b')
			#('``@a > ``@b ifTrue: [``@b] ifFalse: [``@a]'  "->"    '``@a min: ``@b')
			#('``@a >= ``@b ifTrue: [``@b] ifFalse: [``@a]' "->"    '``@a min: ``@b')
			#('`a < ``@b ifTrue: [`a := ``@b]'                              "->"    '`a := `a max: ``@b')
			#('`a <= ``@b ifTrue: [`a := ``@b]'                             "->"    '`a := `a max: ``@b')
			#('`a < ``@b ifFalse: [`a := ``@b]'                             "->"    '`a := `a min: ``@b')
			#('`a <= ``@b ifFalse: [`a := ``@b]'                    "->"    '`a := `a min: ``@b')
			#('`a > ``@b ifTrue: [`a := ``@b]'                              "->"    '`a := `a min: ``@b')
			#('`a >= ``@b ifTrue: [`a := ``@b]'                             "->"    '`a := `a min: ``@b')
			#('`a > ``@b ifFalse: [`a := ``@b]'                             "->"    '`a := `a max: ``@b')
			#('`a >= ``@b ifFalse: [`a := ``@b]'                    "->"    '`a := `a max: ``@b')
			#('``@b < `a ifTrue: [`a := ``@b]'                              "->"    '`a := `a min: ``@b')
			#('``@b <= `a ifTrue: [`a := ``@b]'                             "->"    '`a := `a min: ``@b')
			#('``@b < `a ifFalse: [`a := ``@b]'                             "->"    '`a := `a max: ``@b')
			#('``@b <= `a ifFalse: [`a := ``@b]'                    "->"    '`a := `a max: ``@b')
			#('``@b > `a ifTrue: [`a := ``@b]'                              "->"    '`a := `a max: ``@b')
			#('``@b >= `a ifTrue: [`a := ``@b]'                             "->"    '`a := `a max: ``@b')
			#('``@b > `a ifFalse: [`a := ``@b]'                             "->"    '`a := `a min: ``@b')
			#('``@b >= `a ifFalse: [`a := ``@b]'                    "->"    '`a := `a min: ``@b'))
		methods: false
		name: 'Rewrite ifTrue:ifFalse: using min:/max:'
!

notElimination
	^self
		rewrite: #(
			#('``@object not not'   "->"    '``@object') 
			#('``@object not ifTrue: ``@block'      "->"    '``@object ifFalse: ``@block') 
			#('``@object not ifFalse: ``@block'     "->"    '``@object ifTrue: ``@block') 
			#('``@collection select: [:`each | | `@temps | ``@.Statements. ``@object not]'
				"->"    '``@collection reject: [:`each | | `@temps | ``@.Statements. ``@object]')
			#('``@collection reject: [:`each | | `@temps | ``@.Statements. ``@object not]'
				"->"    '``@collection select: [:`each | | `@temps | ``@.Statements. ``@object]')
			#('[| `@temps | ``@.Statements. ``@object not] whileTrue: ``@block'
				"->"    '[| `@temps | ``@.Statements. ``@object] whileFalse: ``@block')
			#('[| `@temps | ``@.Statements. ``@object not] whileFalse: ``@block'
				"->"    '[| `@temps | ``@.Statements. ``@object] whileTrue: ``@block')
			#('[| `@temps | ``@.Statements. ``@object not] whileTrue'
				"->"    '[| `@temps | ``@.Statements. ``@object] whileFalse')
			#('[| `@temps | ``@.Statements. ``@object not] whileFalse'
				"->"    '[| `@temps | ``@.Statements. ``@object] whileTrue')
			#('(``@a <= ``@b) not' "->" '``@a > ``@b')
			#('(``@a < ``@b) not' "->" '``@a >= ``@b')
			#('(``@a = ``@b) not' "->" '``@a ~= ``@b')
			#('(``@a == ``@b) not' "->" '``@a ~~ ``@b')
			#('(``@a ~= ``@b) not' "->" '``@a = ``@b')
			#('(``@a ~~ ``@b) not' "->" '``@a == ``@b')
			#('(``@a >= ``@b) not' "->" '``@a < ``@b')
			#('(``@a > ``@b) not' "->" '``@a <= ``@b'))                     
		methods: false
		name: 'Eliminate unnecessary not''s'
!

showWhileBlocks
	^self
		rewrite: #(
			#('``@cursor showWhile: [| `@temps | ``@.Statements. `var := ``@object]'
				"->"    '`var := ``@cursor showWhile: [| `@temps | ``@.Statements. ``@object]') 
			#('``@cursor showWhile: [| `@temps | ``@.Statements. ^``@object]'
				"->"    '^``@cursor showWhile: [| `@temps | ``@.Statements. ``@object]'))
		methods: false
		name: 'Move assignment out of showWhile: blocks'
!

superSends
	^(self new)
		name: 'Rewrite super messages to self messages when both refer to same method';
		superSends;
		yourself
!

unwindBlocks
	^self
		rewrite: #(
			#('[| `@temps | ``@.Statements. `var := ``@object] valueNowOrOnUnwindDo: ``@block'
				"->"    '`var := [| `@temps | ``@.Statements. ``@object] valueNowOrOnUnwindDo: ``@block') 
			#('[| `@temps | ``@.Statements. ^``@object] valueNowOrOnUnwindDo: ``@block'
				"->"    '^[| `@temps | ``@.Statements. ``@object] valueNowOrOnUnwindDo: ``@block') 
			#('[| `@temps | ``@.Statements. `var := ``@object] valueOnUnwindDo: ``@block'
				"->"    '`var := [| `@temps | ``@.Statements. ``@object] valueOnUnwindDo: ``@block') 
			#('[| `@temps | ``@.Statements. ^``@object] valueOnUnwindDo: ``@block'
				"->"    '^[| `@temps | ``@.Statements. ``@object] valueOnUnwindDo: ``@block'))
		methods: false
		name: 'Move assignment out of valueNowOrUnwindDo: blocks'
! !

!TransformationRuleTest methodsFor:'accessing'!

checkMethod: aSmalllintContext 
	class := aSmalllintContext selectedClass.
	(rewriteRule executeTree: aSmalllintContext parseTree) ifTrue: 
			[(RecursiveSelfRule executeTree: rewriteRule tree initialAnswer: false)
				ifFalse: 
					[builder compile: rewriteRule tree printString
						in: class
						classified: aSmalllintContext protocols]]
!

problemCount
	^builder problemCount
!

resetResult
	builder := CompositeRefactoryChange new
! !

!TransformationRuleTest methodsFor:'initialize-release'!

rewriteUsing: searchReplacer 
	rewriteRule := searchReplacer.
	self resetResult
! !

!TransformationRuleTest methodsFor:'private'!

viewResults
	"I reset the result so that we don't fill up memory with methods to compile in the builder."

	builder inspect.
	self resetResult
! !

!TransformationRuleTest methodsFor:'rules'!

superSends
	| rule |
	rule := ParseTreeRewriter new.
	rule addSearch: 'super `@message: ``@args'
				-> (
					[:aNode | 
					(class withAllSubclasses
						detect: [:each | each includesSelector: aNode selector]
						ifNone: [nil]) isNil]
							-> 'self `@message: ``@args').
	self rewriteUsing: rule
! !

!TransformationRuleTest methodsFor:'testing'!

hasConflicts
	^true
!

isEmpty
	^builder changes isEmpty
! !

!TransformationRuleTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/tests/TransformationRuleTest.st,v 1.3 2003-10-06 14:39:34 cg Exp $'
! !
