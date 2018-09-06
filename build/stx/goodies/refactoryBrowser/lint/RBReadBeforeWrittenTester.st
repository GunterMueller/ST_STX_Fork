"
 Copyright (C) Original SmallLint Authors
 Copyright (C) The Squeak Team
 Copyright (C) The Pharo Team
 Copyright (C) 2011-2013 Jan Vrany (porting, Smalltalk/X rules & tweaks)
 Copyright (C) 2011-2013 Claus Gittinger (porting, Smalltalk/X rules & tweaks)

 Permission is hereby granted, free of charge, to any 
 person obtaining a copy of this software and associated 
 documentation files (the 'Software'), to deal in the 
 Software without restriction, including without limitation 
 the rights to use, copy, modify, merge, publish, distribute, 
 sublicense, and/or sell copies of the Software, and to 
 permit persons to whom the Software is furnished to do so, 
 subject to the following conditions:

 The above copyright notice and this permission notice shall 
 be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, 
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES 
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY 
 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
"
"{ Package: 'stx:goodies/refactoryBrowser/lint' }"

"{ NameSpace: Smalltalk }"

Object subclass:#RBReadBeforeWrittenTester
	instanceVariableNames:'read checkNewTemps scopeStack searcher'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-ParseTree Matching'
!

!RBReadBeforeWrittenTester class methodsFor:'documentation'!

copyright
"
 Copyright (C) Original SmallLint Authors
 Copyright (C) The Squeak Team
 Copyright (C) The Pharo Team
 Copyright (C) 2011-2013 Jan Vrany (porting, Smalltalk/X rules & tweaks)
 Copyright (C) 2011-2013 Claus Gittinger (porting, Smalltalk/X rules & tweaks)

 Permission is hereby granted, free of charge, to any 
 person obtaining a copy of this software and associated 
 documentation files (the 'Software'), to deal in the 
 Software without restriction, including without limitation 
 the rights to use, copy, modify, merge, publish, distribute, 
 sublicense, and/or sell copies of the Software, and to 
 permit persons to whom the Software is furnished to do so, 
 subject to the following conditions:

 The above copyright notice and this permission notice shall 
 be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, 
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES 
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY 
 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
"
! !

!RBReadBeforeWrittenTester class methodsFor:'instance creation'!

new
	^super new initialize
! !

!RBReadBeforeWrittenTester class methodsFor:'accessing'!

isVariable: aString readBeforeWrittenIn: aBRProgramNode 
	^(self isVariable: aString writtenBeforeReadIn: aBRProgramNode) not
!

isVariable: aString writtenBeforeReadIn: aBRProgramNode 
	^(self readBeforeWritten: (Array with: aString) in: aBRProgramNode) 
		isEmpty
!

readBeforeWritten: varNames in: aParseTree 
	^(self new)
		checkNewTemps: false;
		initializeVars: varNames;
		executeTree: aParseTree;
		read
!

variablesReadBeforeWrittenIn: aParseTree 
	^(self new)
		executeTree: aParseTree;
		read
! !

!RBReadBeforeWrittenTester methodsFor:'accessing'!

executeTree: aParseTree 
	^searcher executeTree: aParseTree
!

read
	self currentScope
		keysAndValuesDo: [:key :value | value == true ifTrue: [read add: key]].
	^read
! !

!RBReadBeforeWrittenTester methodsFor:'initialize-release'!

checkNewTemps: aBoolean 
	checkNewTemps := aBoolean
!

createSearchTrees
	searcher := ParseTreeSearcher new.

	"Case 1 - Set the values, depending on whether we matched an assignment"
	searcher
		matches: '`var := `@object'
			do: 
				[:aNode :ans | 
				searcher executeTree: aNode value.
				self variableWritten: aNode.
				ans];
		matches: '`var'
			do: 
				[:aNode :ans | 
				self variableRead: aNode.
				ans].

	"Handle the special while* and ifTrue:ifFalse: blocks separately"
	searcher
		matchesAnyOf: 
				#('[| `@temps | ``@.Statements] whileTrue: ``@block' 
				'[| `@temps | ``@.Statements] whileTrue' 
				'[| `@temps | ``@.Statements] whileFalse: ``@block' 
				'[| `@temps | ``@.Statements] whileFalse')
			do: [:aNode :ans | ans];
		matchesAnyOf: 
				#('`@condition ifTrue: [| `@tTemps | `@.trueBlock] ifFalse: [| `@fTemps| `@.falseBlock]' 
				'`@condition ifFalse: [| `@fTemps | `@.falseBlock] ifTrue: [| `@tTemps | `@.trueBlock]')
			do: 
				[:aNode :ans | 
				searcher executeTree: aNode receiver.
				self processIfTrueIfFalse: aNode.
				ans].

	"Case 2 - Recursive call yourself on the body of the block node just matched"
	searcher matches: '[:`@args | | `@temps | `@.Statements]'
		do: 
			[:aNode :ans | 
			self processBlock: aNode.
			ans].
	searcher matches: '| `@temps | `@.Stmts'
		do: 
			[:aNode :ans | 
			self processStatementNode: aNode.
			ans]
!

initialize
	scopeStack := OrderedCollection with: Dictionary new.
	read := Set new.
	checkNewTemps := true.
	self createSearchTrees
!

initializeVars: varNames 
	varNames do: [:each | self currentScope at: each put: nil]
! !

!RBReadBeforeWrittenTester methodsFor:'private'!

copyDictionary: aDictionary 
	"We could send aDictionary the copy message, but that doesn't copy the associations."

	| newDictionary |
	newDictionary := Dictionary new: aDictionary size.
	aDictionary
		keysAndValuesDo: [:key :value | newDictionary at: key put: value].
	^newDictionary
!

createScope
	scopeStack add: (self copyDictionary: scopeStack last)
!

currentScope
	^scopeStack last
!

processBlock: aNode 
	| newScope |
	self createScope.
	self executeTree: aNode body.
	newScope := self removeScope.
	newScope keysAndValuesDo: 
			[:key :value | 
			(value == true and: [(self currentScope at: key) isNil]) 
				ifTrue: [self currentScope at: key put: value]]
!

processIfTrueIfFalse: aNode 
	| trueScope falseScope |
	self createScope.
	self executeTree: aNode arguments first body.
	trueScope := self removeScope.
	self createScope.
	self executeTree: aNode arguments last body.
	falseScope := self removeScope.
	self currentScope keysAndValuesDo: 
			[:key :value | 
			value isNil 
				ifTrue: 
					[(trueScope at: key) == (falseScope at: key) 
						ifTrue: [self currentScope at: key put: (trueScope at: key)]
						ifFalse: 
							[((trueScope at: key) == true or: [(falseScope at: key) == true]) 
								ifTrue: [self currentScope at: key put: true]]]]
!

processStatementNode: aNode 
	| temps |
	(checkNewTemps not or: [aNode temporaries isEmpty]) 
		ifTrue: 
			[aNode statements do: [:each | self executeTree: each].
			^self].
	self createScope.
	temps := aNode temporaries collect: [:each | each name].
	self initializeVars: temps.
	aNode statements do: [:each | self executeTree: each].
	self removeScope keysAndValuesDo: 
			[:key :value | 
			(temps includes: key) 
				ifTrue: [value == true ifTrue: [read add: key]]
				ifFalse: 
					[(self currentScope at: key) isNil 
						ifTrue: [self currentScope at: key put: value]]]
!

removeScope
	^scopeStack removeLast
!

variableRead: aNode 
	(self currentScope includesKey: aNode name) ifTrue: 
			[(self currentScope at: aNode name) isNil
				ifTrue: [self currentScope at: aNode name put: true]]
!

variableWritten: aNode 
	(self currentScope includesKey: aNode variable name) ifTrue: 
			[(self currentScope at: aNode variable name) isNil
				ifTrue: [self currentScope at: aNode variable name put: false]]
! !

!RBReadBeforeWrittenTester class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

