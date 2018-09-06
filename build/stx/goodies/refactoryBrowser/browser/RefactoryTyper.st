"{ Package: 'stx:goodies/refactoryBrowser/browser' }"

Object subclass:#RefactoryTyper
	instanceVariableNames:'model class variableTypes bestGuesses variableMessages bindings
		backpointers methodName selectorLookup'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Support'
!

!RefactoryTyper class methodsFor:'documentation'!

examples
"
        | types model |
        model := RBNamespace new.
        types := RefactoryTyper 
                                typesFor: 'foo'
                                in: (RBParser 
                                                parseExpression: 'foo printString; testBasicLintRuleTypes; testParseTreeTypes')
                                model: model.
        self assert: types size = 1.
        self assert: (types includes: (model classFor: self class))
"
! !

!RefactoryTyper class methodsFor:'instance creation'!

new
	^(super new)
		initialize;
		yourself
!

newFor: aRBNamespace 
	^(self new)
		model: aRBNamespace;
		yourself
! !

!RefactoryTyper class methodsFor:'accessing'!

classesFor: variableName in: aParseTree model: aRBSmalltalkOrNil ignoredSelectors:ignoredSelectors
        "ignore ignoredSelectors in the messages-sent analysis.
         This is needed for the code completion, when a partial selector has already been
         entered, to ignore exactly this one"

        | types |

        types := self typesFor: variableName in: aParseTree model: aRBSmalltalkOrNil ignoredSelectors:ignoredSelectors.
        ^ types 
            collect:[:clsOrRBClass | Smalltalk classNamed:clsOrRBClass name]
            thenReject:[:clsOrNil | clsOrNil isNil]
!

typesFor: variableName in: aParseTree 
        ^ self typesFor: variableName in: aParseTree model: nil
!

typesFor: variableName in: aParseTree model: aRBSmalltalkOrNil 
        ^ self
                typesFor: variableName in: aParseTree model: aRBSmalltalkOrNil
                ignoredSelectors:nil
!

typesFor: variableName in: aParseTree model: aRBSmalltalkOrNil ignoredSelectors:ignoredSelectors
        "ignore ignoredSelectors in the messages-sent analysis.
         This is needed for the code completion, when a partial selector has already been
         entered, to ignore exactly this one"

        | searcher messages typer newInstClasses collectGlobal typesFromMessages|

        newInstClasses := Set new.
        collectGlobal := 
                [:aNode :answer |
                    |globl cls|

                    globl := aNode value receiver name.
                    (globl isUppercaseFirst
                        and:[ (cls := (aRBSmalltalkOrNil ? Smalltalk) classNamed:globl asSymbol) isBehavior ]) 
                    ifTrue:[
                        newInstClasses add:cls
                    ].
                ].

        searcher := ParseTreeSearcher new.
        searcher 
                matches: variableName , ' `@message: ``@args'
                do: [:aNode :answer |
                        (ignoredSelectors isNil
                                or:[ (ignoredSelectors includes:aNode selector) not ])
                        ifTrue:[
                            answer 
                                add: aNode selector;
                                yourself
                        ]
                    ];

                matches: variableName , ' := `global new'
                do: collectGlobal;
 
                matches: variableName , ' := `global new: `@e '
                do: collectGlobal.

        messages := searcher executeTree: aParseTree initialAnswer: Set new.
        typer := self new.
        aRBSmalltalkOrNil notNil ifTrue:[
            typer model: aRBSmalltalkOrNil
        ].

        typesFromMessages := (typer findTypeFor: messages).

        ^ Set new
                addAll:(newInstClasses reject:[:cls | typesFromMessages contains:[:rbType | rbType name = cls name]]);
                addAll:typesFromMessages;
                yourself.
! !

!RefactoryTyper methodsFor:'accessing'!

guessTypesFor: anInstVarName 
	^bestGuesses at: anInstVarName ifAbsent: [self typesFor: anInstVarName]
!

guessTypesFor: anInstVarName in: aClass
    aClass autoload.

    class = aClass ifFalse: [self runOn: aClass].
    ^bestGuesses at: anInstVarName
            ifAbsent: [self typesFor: anInstVarName in: aClass]

    "Modified (format): / 04-08-2011 / 20:38:36 / cg"
!

runOn: aClass 
	variableTypes := Dictionary new.
	variableMessages := Dictionary new.
	bestGuesses := Dictionary new.
	class := model classFor: aClass.
	class instanceVariableNames isEmpty ifTrue: [^self].
	self
		selectedClass: aClass;
		computeEquivalenceClassesForMethodsAndVars;
		computeMessagesSentToVariables;
		computeTypes;
		refineTypesByLookingAtAssignments
!

selectedClass: aClass 
	class := model classFor: aClass
!

typesFor: anInstVarName 
	^variableTypes at: anInstVarName ifAbsent: [Set new]
!

typesFor: anInstVarName in: aClass 
	class = aClass ifFalse: [self runOn: aClass].
	^variableTypes at: anInstVarName ifAbsent: [Set new]
! !

!RefactoryTyper methodsFor:'assignments'!

guessTypeFromAssignment: aNode 
	| type set newType |
	type := nil.
	aNode value isAssignment 
		ifTrue: 
			[^self guessTypeFromAssignment: (RBAssignmentNode variable: aNode variable
						value: aNode value value)].
	aNode value isBlock ifTrue: [type := model classFor: [] class].
	aNode value isLiteral 
		ifTrue: 
			[aNode value value isNil ifTrue: [^self].
			type := model classFor: (self typeFor: aNode value value)].
	aNode value isMessage 
		ifTrue: 
			[aNode value receiver isVariable 
				ifTrue: [type := model classNamed: aNode value receiver name asSymbol].
			aNode value selector == #asValue 
				ifTrue: [type := model classNamed: #ValueHolder].
			(#(#and: #or: #= #== #~= #~~ #<= #< #~~ #> #>=) 
				includes: aNode value selector) ifTrue: [type := model classFor: Boolean]].
	type isNil ifTrue: [^self].
	set := variableTypes at: aNode variable name.
	newType := set detect: [:each | type includesClass: each] ifNone: [nil].
	newType isNil ifTrue: [^self].
	newType = (model classFor: Object) ifTrue: [newType := type].
	(bestGuesses at: aNode variable name ifAbsentPut: [Set new]) add: newType
!

refineTypesByLookingAtAssignments
	| searcher needsSearch |
	needsSearch := false.
	searcher := ParseTreeSearcher new.
	variableTypes keysAndValuesDo: 
			[:key :value | 
			(key first == $-) 
				ifFalse: 
					[needsSearch := true.
					searcher matches: key , ' := ``@object'
						do: [:aNode :answer | self guessTypeFromAssignment: aNode]]].
	needsSearch ifTrue: [self executeSearch: searcher]
!

typeFor: anObject 
	'' class == anObject class ifTrue: [^String].
	^(#(true false) includes: anObject) 
		ifTrue: [Boolean]
		ifFalse: [anObject class]
! !

!RefactoryTyper methodsFor:'computing types'!

computeTypes
	variableMessages
		keysAndValuesDo: [:key :value | variableTypes at: key put: (self findTypeFor: value)]
!

findTypeFor: selectorCollection 
	^selectorCollection inject: model rootClasses
		into: 
			[:classes :each | 
			self refineTypes: classes
				with: (selectorLookup at: each ifAbsentPut: [self implementorsOf: each])]
!

implementorsOf: aSelector 
	| classes |
	classes := OrderedCollection new.
	model rootClasses do: 
			[:each | 
			self 
				implementorsOf: aSelector
				in: each
				storeIn: classes].
	^classes
!

implementorsOf: aSelector in: aClass storeIn: classes 
	(aClass directlyDefinesMethod: aSelector) 
		ifTrue: 
			[classes add: aClass.
			^self].
	aClass subclasses do: 
			[:each | 
			self 
				implementorsOf: aSelector
				in: each
				storeIn: classes]
!

refineTypes: aClassCollection with: anotherClassCollection 
	| classSet |
	classSet := Set new.
	aClassCollection do: 
			[:each | 
			anotherClassCollection do: 
					[:cls | 
					(cls includesClass: each) 
						ifTrue: [classSet add: cls]
						ifFalse: [(each includesClass: cls) ifTrue: [classSet add: each]]]].
	^classSet
! !

!RefactoryTyper methodsFor:'equivalence classes'!

computeEquivalenceClassesForMethodsAndVars
	| searcher |
	bindings := Set new.
	backpointers := Dictionary new.
	class instanceVariableNames 
		do: [:each | backpointers at: each put: (bindings add: (Set with: each))].
	class withAllSubclasses do: 
			[:sub | 
			sub selectors 
				do: [:each | backpointers at: each put: (bindings add: (Set with: each))]].
	searcher := ParseTreeSearcher new.
	searcher matches: '^``@object'
		do: [:aNode :answer | self processNode: aNode value].
	self executeSearch: searcher
!

merge: aName 
	| set1 set2 |
	set1 := backpointers at: methodName ifAbsent: [nil].
	set2 := backpointers at: aName ifAbsent: [nil].
	(set1 isNil or: [set2 isNil or: [set1 == set2]])
		ifTrue: [^self].
	set1 addAll: set2.
	set2 do: [:each | backpointers at: each put: set1].
	bindings remove: set2 ifAbsent:nil
!

processNode: aNode 
	(aNode isVariable and: [class instanceVariableNames includes: aNode name]) 
		ifTrue: [^self merge: aNode name].
	(aNode isMessage 
		and: [aNode receiver isVariable and: [aNode receiver name = 'self']]) 
			ifTrue: [^self merge: aNode selector].
	aNode isAssignment 
		ifTrue: 
			[self
				processNode: aNode value;
				processNode: aNode variable].
	(aNode isMessage and: 
			[#(#ifTrue: #ifFalse: #ifTrue:ifFalse: #ifFalse:ifTrue:) 
				includes: aNode selector]) 
		ifTrue: 
			[aNode arguments do: 
					[:each | 
					each isBlock 
						ifTrue: 
							[each body statements isEmpty 
								ifFalse: [self processNode: each body statements last]]]]
! !

!RefactoryTyper methodsFor:'initialize-release'!

initialize
	model := RBNamespace new.
	class := model classFor: Object.
	variableTypes := Dictionary new.
	variableMessages := Dictionary new.
	selectorLookup := IdentityDictionary new.
	bestGuesses := Dictionary new
! !

!RefactoryTyper methodsFor:'printing'!

collectionNameFor: aString 
	^'-<1s>-' expandMacrosWith: aString
!

printOn: aStream 
	aStream
		nextPutAll: class name;
		cr.
	class instanceVariableNames do: 
			[:each | 
			aStream
				tab;
				nextPutAll: each;
				tab;
				nextPut: $<.
			self printTypeFor: each on: aStream.
			aStream
				nextPut: $>;
				cr]
!

printType: aClass for: aString on: aStream 
	| name colTypes |
	colTypes := #().
	name := self collectionNameFor: aString.
	(aClass includesClass: (model classFor: Collection))
		ifTrue: [colTypes := self guessTypesFor: name].
	colTypes isEmpty ifFalse: [aStream nextPut: $(].
	aClass printOn: aStream.
	colTypes isEmpty
		ifFalse: 
			[aStream nextPutAll: ' of: '.
			colTypes size > 1 ifTrue: [aStream nextPut: $(].
			self printTypeFor: name on: aStream.
			colTypes size > 1 ifTrue: [aStream nextPut: $)]].
	colTypes isEmpty ifFalse: [aStream nextPut: $)]
!

printTypeFor: aString on: aStream 
	| types |
	types := (self guessTypesFor: aString) 
				asSortedCollection: [:a :b | a name < b name].
	1 to: types size
		do: 
			[:i | 
			i == 1 ifFalse: [aStream nextPutAll: ' | '].
			self 
				printType: (types at: i)
				for: aString
				on: aStream]
! !

!RefactoryTyper methodsFor:'private'!

executeSearch: searcher 
	class withAllSubclasses do: 
			[:each | 
			each selectors do: 
					[:sel | 
					| parseTree |
					methodName := sel.
					parseTree := each parseTreeFor: sel.
					parseTree notNil ifTrue: [searcher executeTree: parseTree]]]
!

model
	^model
!

model: aRBSmalltalk
	model := aRBSmalltalk
!

rootClasses
	^Class rootsOfTheWorld
! !

!RefactoryTyper methodsFor:'selectors'!

computeMessagesSentToVariables
	| searcher |
	variableMessages := Dictionary new.
	class instanceVariableNames 
		do: [:each | variableMessages at: each put: Set new].
	searcher := ParseTreeSearcher new.
	class instanceVariableNames do: 
			[:each | 
			| block |
			block := 
					[:aNode :answer | 
					(variableMessages at: each ifAbsentPut: [Set new]) add: aNode selector.
					self processCollectionMessagesFor: each in: aNode].
			searcher matches: each , ' `@messageName: ``@args' do: block.
			(backpointers at: each) do: 
					[:sel | 
					sel isSymbol 
						ifTrue: 
							[searcher 
								matches: ('(self <1s>) `@messageName: ``@args' 
										expandMacrosWith: (ParseTreeSearcher buildSelectorString: sel)) asString
								do: block]]].
	searcher answer: variableMessages.
	self executeSearch: searcher
! !

!RefactoryTyper methodsFor:'selectors-collections'!

processCollectionFor: key messagesTo: aName in: aBlock 
	| searcher |
	searcher := ParseTreeSearcher new.
	searcher matches: aName , ' `@message: ``@args'
		do: 
			[:aNode :answer | 
			self processCollectionMessagesFor: key in: aNode.
			answer
				add: aNode selector;
				yourself].
	searcher executeTree: aBlock
		initialAnswer: (variableMessages at: (self collectionNameFor: key)
				ifAbsentPut: [Set new])
!

processCollectionMessagesFor: variableName in: aParseTree 
	| parent block |
	aParseTree isMessage ifFalse: [^self].
	(#(#first #at: #last) includes: aParseTree selector) 
		ifTrue: 
			[parent := aParseTree parent.
			(parent notNil and: [parent isMessage]) ifFalse: [^self].
			aParseTree == parent receiver ifFalse: [^self].
			(variableMessages at: (self collectionNameFor: variableName)
				ifAbsentPut: [Set new]) add: parent selector.
			self processCollectionMessagesFor: (self collectionNameFor: variableName)
				in: parent].
	(#(#do: #do:separatedBy: #collect: #reject: #select: #detect: #detect:ifNone:) 
		includes: aParseTree selector) 
			ifTrue: 
				[block := aParseTree arguments first.
				block isBlock ifFalse: [^self].
				self 
					processCollectionFor: variableName
					messagesTo: block arguments first name
					in: block].
	#inject:into: == aParseTree selector 
		ifTrue: 
			[block := aParseTree arguments last.
			block isBlock ifFalse: [^self].
			self 
				processCollectionFor: variableName
				messagesTo: block arguments last name
				in: block]
! !

!RefactoryTyper class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/browser/RefactoryTyper.st,v 1.14 2013-07-15 08:57:42 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/browser/RefactoryTyper.st,v 1.14 2013-07-15 08:57:42 cg Exp $'
! !

