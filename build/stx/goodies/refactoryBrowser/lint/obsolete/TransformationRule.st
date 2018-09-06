"{ Package: 'stx:goodies/refactoryBrowser/lint' }"

LintRule subclass:#TransformationRule
	instanceVariableNames:'rewriteRule builder class'
	classVariableNames:'RecursiveSelfRule'
	poolDictionaries:''
	category:'Refactory-Lint'
!

TransformationRule comment:'TransformationRule is a LintRule that transforms code using rewrite rules.

Instance Variables:
	builder	<RefactoryBuilder>	the changes we''ve made
	class	<Behavior>	the class we''re looking at currently (only needed so we don''t have to pass the class around)
	rewriteRule	<ParseTreeRewriter>	the rule we''re replacing the code with

Class Variables:
	RecursiveSelfRule	<ParseTreeSearcher>	a rule that checks our rewrites so we don''t make directly recursive methods (e.g., "foo ^self foo")

'
!


!TransformationRule class methodsFor:'instance creation'!

rewrite: stringArrays methods: aBoolean name: aName 
	| rewriteRule |
	rewriteRule := ParseTreeRewriter new.
	stringArrays do: 
			[:each | 
			aBoolean 
				ifTrue: [rewriteRule replaceMethod: each first with: each last]
				ifFalse: [rewriteRule replace: each first with: each last]].
	^(self new)
		name: aName;
		rewriteUsing: rewriteRule;
		yourself
! !

!TransformationRule class methodsFor:'accessing'!

initializeRecursiveSelfRule
	RecursiveSelfRule := ParseTreeSearcher new.
	RecursiveSelfRule 
		matchesAnyMethodOf: 
			#('`@methodName: `@args | `@temps | self `@methodName: `@args1' 
			'`@methodName: `@args | `@temps | ^self `@methodName: `@args1')
		do: [:aNode :answer | true].
	^RecursiveSelfRule
!

recursiveSelfRule
	^RecursiveSelfRule isNil 
		ifTrue: [self initializeRecursiveSelfRule]
		ifFalse: [RecursiveSelfRule]
! !

!TransformationRule class methodsFor:'transformations'!

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

cascadedNextPutAlls
	^self
		rewrite: #(
			#('``@rcvr nextPutAll: ``@object1 , ``@object2'
					"->"
				'``@rcvr nextPutAll: ``@object1; nextPutAll: ``@object2')
			#('``@rcvr show: ``@object1 , ``@object2'
					"->"
				'``@rcvr show: ``@object1; show: ``@object2'))
		methods: false
		name: 'Use cascaded nextPutAll:''s instead of #, in #nextPutAll:'
!

detectIfNone
	^self rewrite: #(
			#('(``@collection detect: [:`each | | `@temps | ``@.Statements] ifNone: [nil]) isNil'
				"->"	'(``@collection contains: [:`each | | `@temps | ``@.Statements]) not')
			#('(``@collection detect: [:`each | | `@temps | ``@.Statements] ifNone: [nil]) = nil'
				"->"	'(``@collection contains: [:`each | | `@temps | ``@.Statements]) not')
			#('(``@collection detect: [:`each | | `@temps | ``@.Statements] ifNone: [nil]) == nil'
				"->"	'(``@collection contains: [:`each | | `@temps | ``@.Statements]) not')
			#('(``@collection detect: [:`each | | `@temps | ``@.Statements] ifNone: [nil]) notNil'
				"->"	'``@collection contains: [:`each | | `@temps | ``@.Statements]')
			#('(``@collection detect: [:`each | | `@temps | ``@.Statements] ifNone: [nil]) ~= nil'
				"->"	'``@collection contains: [:`each | | `@temps | ``@.Statements]')
			#('(``@collection detect: [:`each | | `@temps | ``@.Statements] ifNone: [nil]) ~~ nil'
				"->"	'``@collection contains: [:`each | | `@temps | ``@.Statements]'))
		methods: false
		name: 'detect:ifNone: -> contains:'
!

equalNil
	^self
		rewrite: #(
			#('``@object = nil'	"->"	'``@object isNil') 
			#('``@object == nil'	"->"	'``@object isNil') 
			#('``@object ~= nil'	"->"	'``@object notNil') 
			#('``@object ~~ nil'	"->"	'``@object notNil'))
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
			#('``@a < ``@b ifTrue: [``@a] ifFalse: [``@b]'	"->"	'``@a min: ``@b')
			#('``@a <= ``@b ifTrue: [``@a] ifFalse: [``@b]'	"->"	'``@a min: ``@b')
			#('``@a > ``@b ifTrue: [``@a] ifFalse: [``@b]'	"->"	'``@a max: ``@b')
			#('``@a >= ``@b ifTrue: [``@a] ifFalse: [``@b]'	"->"	'``@a max: ``@b')
			#('``@a < ``@b ifTrue: [``@b] ifFalse: [``@a]'	"->"	'``@a max: ``@b')
			#('``@a <= ``@b ifTrue: [``@b] ifFalse: [``@a]'	"->"	'``@a max: ``@b')
			#('``@a > ``@b ifTrue: [``@b] ifFalse: [``@a]'	"->"	'``@a min: ``@b')
			#('``@a >= ``@b ifTrue: [``@b] ifFalse: [``@a]'	"->"	'``@a min: ``@b')
			#('`a < ``@b ifTrue: [`a := ``@b]'				"->"	'`a := `a max: ``@b')
			#('`a <= ``@b ifTrue: [`a := ``@b]'				"->"	'`a := `a max: ``@b')
			#('`a < ``@b ifFalse: [`a := ``@b]'				"->"	'`a := `a min: ``@b')
			#('`a <= ``@b ifFalse: [`a := ``@b]'			"->"	'`a := `a min: ``@b')
			#('`a > ``@b ifTrue: [`a := ``@b]'				"->"	'`a := `a min: ``@b')
			#('`a >= ``@b ifTrue: [`a := ``@b]'				"->"	'`a := `a min: ``@b')
			#('`a > ``@b ifFalse: [`a := ``@b]'				"->"	'`a := `a max: ``@b')
			#('`a >= ``@b ifFalse: [`a := ``@b]'			"->"	'`a := `a max: ``@b')
			#('``@b < `a ifTrue: [`a := ``@b]'				"->"	'`a := `a min: ``@b')
			#('``@b <= `a ifTrue: [`a := ``@b]'				"->"	'`a := `a min: ``@b')
			#('``@b < `a ifFalse: [`a := ``@b]'				"->"	'`a := `a max: ``@b')
			#('``@b <= `a ifFalse: [`a := ``@b]'			"->"	'`a := `a max: ``@b')
			#('``@b > `a ifTrue: [`a := ``@b]'				"->"	'`a := `a max: ``@b')
			#('``@b >= `a ifTrue: [`a := ``@b]'				"->"	'`a := `a max: ``@b')
			#('``@b > `a ifFalse: [`a := ``@b]'				"->"	'`a := `a min: ``@b')
			#('``@b >= `a ifFalse: [`a := ``@b]'			"->"	'`a := `a min: ``@b'))
		methods: false
		name: 'Rewrite ifTrue:ifFalse: using min:/max:'
!

notElimination
	^self
		rewrite: #(
			#('``@object not not'	"->"	'``@object') 
			#('``@object not ifTrue: ``@block' 	"->"	'``@object ifFalse: ``@block') 
			#('``@object not ifFalse: ``@block'	"->"	'``@object ifTrue: ``@block') 
			#('``@collection select: [:`each | | `@temps | ``@.Statements. ``@object not]'
				"->"	'``@collection reject: [:`each | | `@temps | ``@.Statements. ``@object]')
			#('``@collection reject: [:`each | | `@temps | ``@.Statements. ``@object not]'
				"->"	'``@collection select: [:`each | | `@temps | ``@.Statements. ``@object]')
			#('[| `@temps | ``@.Statements. ``@object not] whileTrue: ``@block'
				"->"	'[| `@temps | ``@.Statements. ``@object] whileFalse: ``@block')
			#('[| `@temps | ``@.Statements. ``@object not] whileFalse: ``@block'
				"->"	'[| `@temps | ``@.Statements. ``@object] whileTrue: ``@block')
			#('[| `@temps | ``@.Statements. ``@object not] whileTrue'
				"->"	'[| `@temps | ``@.Statements. ``@object] whileFalse')
			#('[| `@temps | ``@.Statements. ``@object not] whileFalse'
				"->"	'[| `@temps | ``@.Statements. ``@object] whileTrue')
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
				"->"	'`var := ``@cursor showWhile: [| `@temps | ``@.Statements. ``@object]') 
			#('``@cursor showWhile: [| `@temps | ``@.Statements. ^``@object]'
				"->"	'^``@cursor showWhile: [| `@temps | ``@.Statements. ``@object]'))
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
				"->"	'`var := [| `@temps | ``@.Statements. ``@object] valueNowOrOnUnwindDo: ``@block') 
			#('[| `@temps | ``@.Statements. ^``@object] valueNowOrOnUnwindDo: ``@block'
				"->"	'^[| `@temps | ``@.Statements. ``@object] valueNowOrOnUnwindDo: ``@block') 
			#('[| `@temps | ``@.Statements. `var := ``@object] valueOnUnwindDo: ``@block'
				"->"	'`var := [| `@temps | ``@.Statements. ``@object] valueOnUnwindDo: ``@block') 
			#('[| `@temps | ``@.Statements. ^``@object] valueOnUnwindDo: ``@block'
				"->"	'^[| `@temps | ``@.Statements. ``@object] valueOnUnwindDo: ``@block'))
		methods: false
		name: 'Move assignment out of valueNowOrUnwindDo: blocks'
! !

!TransformationRule methodsFor:'accessing'!

changes
	^builder changes
!

checkMethod: aSmalllintContext 
	(rewriteRule canMatchMethod: aSmalllintContext compiledMethod) 
		ifFalse: [^self].
	class := aSmalllintContext selectedClass.
	(rewriteRule executeTree: aSmalllintContext parseTree) 
		ifTrue: 
			[(self class recursiveSelfRule executeTree: rewriteRule tree
				initialAnswer: false) 
					ifFalse: 
						[builder 
							compile: rewriteRule tree printString
							in: class
							classified: aSmalllintContext protocol]]
!

problemCount
	^builder problemCount
!

resetResult
	builder := CompositeRefactoryChange named: 'Some transformations'
! !

!TransformationRule methodsFor:'initialize-release'!

rewriteUsing: searchReplacer 
	rewriteRule := searchReplacer.
	self resetResult
! !

!TransformationRule methodsFor:'private'!

viewResults
	"I reset the result so that we don't fill up memory with methods to compile in the builder."

	builder inspect.
	self resetResult
! !

!TransformationRule methodsFor:'rules'!

superSends
	| rule |
	rule := ParseTreeRewriter new.
	rule 
		replace: 'super `@message: ``@args'
		with: 'self `@message: ``@args'
		when: 
			[:aNode | 
			(class withAllSubclasses 
				detect: [:each | each includesSelector: aNode selector]
				ifNone: [nil]) isNil].
	self rewriteUsing: rule
! !

!TransformationRule methodsFor:'testing'!

hasConflicts
	^true
!

isEmpty
	^builder changes isEmpty
! !

!TransformationRule class methodsFor:'documentation'!

version
    ^ '$Header$'
! !
