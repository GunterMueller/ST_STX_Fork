"{ Package: 'stx:goodies/refactoryBrowser/tests' }"

RefactoringBrowserTest subclass:#VariableTypeTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Testing'
!


!VariableTypeTest methodsFor:'tests'!

testBasicLintRuleTypes
	| typer types |
	typer := RefactoryTyper new.
	types := typer guessTypesFor: 'classBlock' in: BasicLintRuleTest.
	"self assert: types size = 1."
	self 
		assert: ([] class withAllSuperclasses 
				detect: [:each | types includes: (typer model classFor: each)]
				ifNone: [nil]) notNil.
	types := typer typesFor: 'methodBlock' in: (typer model classFor: BasicLintRuleTest).
	"self should: [types size = 2]."
	self 
		assert: ([] class withAllSuperclasses 
				detect: [:each | types includes: (typer model classFor: each)]
				ifNone: [nil]) notNil.
	"self should: [types includes: MessageChannel]."
	typer printString
!

testCompositeLintRuleTypes
	| typer types |
	((Smalltalk respondsTo:#isSmalltalkX) and:[Smalltalk isSmalltalkX]) ifTrue:[
	    CompositeLintRuleTest autoload
	].
	typer := RefactoryTyper new runOn: CompositeLintRuleTest.
	types := typer guessTypesFor: 'rules'.
	self assert: types size = 1.
	self assert: (types includes: (typer model classFor: Collection)).
	types := typer typesFor: '-rules-'.
	self assert: types size = 2.
	self assert: (types includes: (typer model classFor: LintRule)).
	self assert: (types includes: (typer model classFor: LintRuleTest)).
	self assert: (typer guessTypesFor: 'asdf') isEmpty.
	typer printString
!

testLintRuleTypes
	| typer types |
	typer := RefactoryTyper new.
	types := typer guessTypesFor: 'name' in: LintRuleTest.
	self assert: types size = 1.
	self assert: (types includes: (typer model classFor: String))
!

testParseTreeTypes
	| types model |
	model := RBNamespace new.
	types := RefactoryTyper 
				typesFor: 'foo'
				in: (RBParser 
						parseExpression: 'foo printString; testBasicLintRuleTypes; testParseTreeTypes')
				model: model.
	self assert: types size = 1.
	self assert: (types includes: (model classFor: self class))
! !

!VariableTypeTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/tests/VariableTypeTest.st,v 1.4 2003-10-06 14:39:34 cg Exp $'
! !
