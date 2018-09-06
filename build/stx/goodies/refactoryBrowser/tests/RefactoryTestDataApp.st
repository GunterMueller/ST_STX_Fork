"{ Package: 'stx:goodies/refactoryBrowser/tests' }"

Object subclass:#RefactoryTestDataApp
	instanceVariableNames:'temporaryVariable'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Test data'
!


!RefactoryTestDataApp methodsFor:'accessing'!

referencesConditionFor: aClass 
	| environment association |
	^(RBCondition withBlock: 
			[association := Smalltalk associationAt: aClass name
						ifAbsent: [self refactoringError: 'Could not find class'].
			environment := (self environment referencesTo: association) 
						| (self environment referencesTo: aClass name).
			environment isEmpty])
		errorMacro: aClass , ' is referenced.<n>Browse references?';
		errorBlock: [environment openEditor];
		yourself
! !

!RefactoryTestDataApp methodsFor:'inline'!

called: anObject on1: aBlock 
	| each |
	each := anObject printString.
	Transcript
		show: each;
		cr.
	aBlock value: each
!

called: anObject on: aBlock 
	Transcript
		show: anObject printString;
		cr.
	aBlock value
!

caller
	| anObject |
	anObject := 5.
	self 
		called: anObject + 1
		on: [^anObject]
!

caller1
	| anObject |
	anObject := 5.
	self called: anObject + 1
		on1: 
			[:each | 
			each printString.
			^anObject]
!

caller2
	^(1 to: 10) inject: 1 into: [:sum :each | sum * (self foo: each)]
!

foo: aValue
	^(1 to: 10) inject: aValue into: [:sum :each | sum + each]
!

inlineComponent
	| a |
	a := 5.
	^a class
		superclass;
		hasImmediateInstances;
		yourself
!

inlineFailed
	| x y q |
	x := 5.
	y := 10.
	q := x + 1 fooMax: y.
	^q
!

inlineLast
	5 = 3 ifTrue: [^self caller] ifFalse: [^self caller2]
!

inlineMax
	| x y q |
	x := 5.
	y := 10.
	q := x + 1 max: y.
	^q
!

inlineTemporary
	| temp |
	self isNil ifTrue: [temp := 4].
	^temp
!

multipleCalls
	self caller2.
	self caller2
! !

!RefactoryTestDataApp methodsFor:'lint'!

asOrderedCollectionNotNeeded
	self foo addAll: (1 to: 10) asOrderedCollection
!

assignmentInBlock
	[^self printString] ensure: [self close]
!

assignmentInIfTrue
	| variable |
	self isVariable 
		ifTrue: [variable := self]
		ifFalse: [variable := self printString].
	^variable
!

atIfAbsent
	^Smalltalk at: #Test
		ifAbsent: 
			[| collection |
			collection := #().
			Smalltalk at: #Test put: collection]
!

badMessage
	self become: String new
!

booleanPrecedence
	^true & 4 = 45
!

collectSelectNotUsed
	(1 to: 10) select: [:each | each = 4]
!

collectionMessagesToExternalObject
	self someObject collection remove: 10
!

collectionProtocol
	| newCollection |
	newCollection := OrderedCollection new.
	(1 to: 10) asOrderedCollection do: 
			[:each | 
			| new |
			new := each * 2.
			newCollection add: new].
	^newCollection
!

consistencyCheck
	^(1 to: 10) at: 1
!

contains
	^((1 to: 10) detect: [:each | each > 2] ifNone: [nil]) isNil
!

detectContains
	^(1 to: 10) do: [:each | each > 2 ifTrue: [^each]]
!

endTrueFalse
	self isVariable 
		ifTrue: 
			[self printString.
			self isVariable printString]
		ifFalse: 
			[self printString.
			^4]
!

equalNotUsed
	| string |
	string = '' yourself.
	(1 to: 10) do: [:i | string := i printString].
	^string
!

equalsTrue
	^true == self
!

extraBlock
	^[:arg | arg + 43] value: 45
!

fileBlocks
	| file |
	^
	[file := 'asdf' asFilename readStream.
	file contents] ensure: [file close]
!

fullBlocks
	^[thisContext]
!

guardingClause
	self isSymbol 
		ifFalse: 
			[self printString.
			self isSymbol printString]
!

ifTrueReturns
	self isSymbol ifFalse: [^true].
	^false
!

isLiteral
	^false
!

justSendsSuper
	super justSendsSuper
!

literalArrayCharacters
	^#($a $b $c) includes: $a
!

longMethods
	self printString.
	self printString.
	self isVariable ifTrue: [self printString].
	self isVariable ifTrue: [self printString].
	self isVariable ifTrue: [self printString].
	self isVariable ifTrue: [self printString]
!

minMax
	"Bug in 3<5 ifTrue: [3]  ifFalse: [5]"

^3<5 ifTrue: [3]  ifFalse: [5]
"       | var |
	var := 4.
	var < 5 ifTrue: [var := 5].
	^var"
!

missingYourself
	^(OrderedCollection new)
		add: 1;
		add: 2;
		removeFirst
!

modifiesCollection
	| collection |
	collection := (1 to: 10) asOrderedCollection.
	collection do: [:each | each > 5 ifTrue: [collection remove: each]].
	^collection
!

precedence
	^self isArray ifFalse: [self block + 5 * 34] ifTrue: [self printString = 10]
!

refersToClass
	^RefactoryTestDataApp
!

release
	self printString
!

returnInEnsure
	[self error: 'asdf'] ensure: [^4]
!

returnsBooleanAndOther
	self isVariable ifTrue: [^false].
	self printString
!

returnsIfTrue
	^self isNil ifTrue: [4]
!

searchingLiteral
	^self printString = #a or: [#() = self printString | ( #() == self printString)]
!

sendsDifferentSuper
	super printString
!

sizeCheck
	self isEmpty
		ifFalse: [self do: 
					[:each | 
					Transcript
						show: each;
						cr]]
!

stringConcatenation
	| string |
	string := '' yourself.
	(1 to: 10) do: [:i | string := string , i printString].
	^string
!

tempVarOverridesInstVar
	| temporaryVariable |
	temporaryVariable := 4.
	^temporaryVariable
!

tempsReadBeforeWritten
	| temp |
	self isVariable ifTrue: [temp := 4].
	^temp
!

threeElementPoint
	^5 @ 5 + 6 @ 6
!

toDo
	1 to: self size do: [:i | (self at: i) printString]
!

toDoCollect
	| array |
	array := Array new: 10.
	1 to: 10 do: [:i | array at: i put: i * i].
	^array
!

toDoWithIncrement
	| counter |
	counter := 0.
	1 to: 10
		by: 2
		do: [:i | counter := counter + 2].
	^counter
!

usesAdd
	^(1 to: 10) asOrderedCollection addAll: (11 to: 20)
!

variableAssignedLiteral
	temporaryVariable := #()
!

whileTrue
	| i |
	i := 1.
	[i < self size] whileTrue: 
			[(self at: i) printString.
			i := i + 1]
!

yourselfNotUsed
	self
		printString;
		printString;
		yourself
! !

!RefactoryTestDataApp methodsFor:'test'!

callFoo
	^self testFoo: 5
!

callMethod
	^self renameThisMethod: 5
!

exampleCall
	^self rename: 1 two: 2
!

inlineFoo: aBlock 
	| bar baz asdf |
	bar := aBlock value: self.
	baz := bar + bar.
	asdf := baz + bar.
	^asdf
!

inlineJunk
	| asdf |
	asdf := self inlineFoo: 
					[:each | 
					| temp |
					temp := each.
					temp , temp].
	^asdf foo: 
			[:bar | 
			| baz |
			baz := bar.
			baz * baz]
!

inlineMethod
	| temp |
	temp := self
				foo;
				inlineMethod;
				bar.
	^temp
!

inlineParameterMethod: aSymbol
	^aSymbol isSymbol
!

moveDefinition
	| temp |
	^(self collect: 
			[:each | 
			temp := each printString.
			temp , temp]) 
		select: 
			[:each | 
			temp := each size.
			temp odd]
!

noMoveDefinition
	| temp |
	^(self collect: 
			[:each | 
			temp := each printString.
			temp , temp]) 
		select: [:each | temp := each size + temp]
!

rename: this two: argumentMethod
	^self printString , this , argumentMethod
!

renameThisMethod: anArg
	^self
!

selectorNotReferenced
	^self selectorNotReferenced + 4
!

sendInlineParameterMethod
	^self inlineParameterMethod: #(#asdf)
!

symbolReference
	^#(#renameThisMethod: #(4 #renameThisMethod:))
!

testFoo: anObject
	^self class + anObject
!

testMethod
	^self class
!

testMethod1
	^self testMethod1 
		, ([:each | each testMethod1] value: #(#(#testMethod1) 2 #testMethod1))
! !

!RefactoryTestDataApp class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/tests/RefactoryTestDataApp.st,v 1.3 2003-10-06 14:39:33 cg Exp $'
! !
