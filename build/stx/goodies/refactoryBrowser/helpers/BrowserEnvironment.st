"{ Package: 'stx:goodies/refactoryBrowser/helpers' }"

"{ NameSpace: Smalltalk }"

Object subclass:#BrowserEnvironment
	instanceVariableNames:'label searchStrings searchActions cachedClasses'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Environments'
!

BrowserEnvironment comment:'BrowserEnvironment represents the classes/methods that are to be browsed. Not only is this class the superclass of all environments, it also represents browsing everything.

Instance Variables:
        label           <String>        a description of what we''re looking at
        searchStrings   <Collection of: String> 
                                        strings to look for whenever we select a method
        searchActions   <Collection of: SearchAction> 
                                        actions to look for whenever we select a method
'
!


!BrowserEnvironment class methodsFor:'instance creation'!

new
        ^(self basicNew)
                initialize;
                yourself
! !

!BrowserEnvironment methodsFor:'accessing'!

addSearchAction:aSearchActionInstance
    searchActions isNil ifTrue:[
        searchActions := OrderedCollection new.
    ].
    searchActions add: aSearchActionInstance
!

addSearchString: aString
    #todo. "/ cg: can someone explain to me what that sortBlock is useful for?

    self assert:aString isString.
    searchStrings isNil ifTrue:[
        Smalltalk isSmalltalkX ifTrue:[
            searchStrings := SortedCollection 
                            sortBlock:[:a :b | 
                                |idxA idxB|

                                idxA := a indexOf: $: ifAbsent: [a size].
                                idxB := b indexOf: $: ifAbsent: [b size].
                                idxA < idxB
                            ].
        ] ifFalse:[
            searchStrings := SortedCollection 
                            sortBlock:[:a :b |
                                |idxA idxB|

                                idxA := a indexOf: $: ifAbsent: [a size].
                                idxB := b indexOf: $: ifAbsent: [b size].
                                idxA > idxB
                            ].
        ].
    ].
    (searchStrings includes:aString) ifFalse:[
        searchStrings add: aString
    ].
!

asClassEnvironment
    | result |
    result := ClassEnvironment new.
    self classesAndSelectorsDo: [ :class :selector | result addClass: class ].
    ^ result
!

categories
	^RefactoryBrowserPlatformSupport systemOrganization categories select: [:each | self includesCategory: each]
!

classNamesFor: aCategoryName
	^(RefactoryBrowserPlatformSupport systemOrganization listAtCategoryNamed: aCategoryName)
		select:
			[:each |
			| class |
			class := Smalltalk at: each ifAbsent: [nil].
			class notNil and: [(self includesClass: class)
					or: [self includesClass: class class]]]
!

classVariables
    "for protocol compatibility with selectorEnvironment 
     (avoid a dnu in RBVariableNotDefinedRule, when selected in Jans Rule-dialog)"

   ^#()
!

classVariablesFor: aClass 
	^aClass classVarNames
!

classesAndSelectorsDo: aBlock 
    self classesDo:[:class | 
        self selectorsForClass: class do: [:sel | aBlock value: class value: sel]
    ]
!

editor
	^RefactoringBrowser onEnvironment: self
!

instanceVariables
    "for protocol compatibility with selectorEnvironment 
     (avoid a dnu in RBVariableNotDefinedRule, when selected in Jans Rule-dialog)"

   ^#()
!

instanceVariablesFor: aClass 
	^aClass instVarNames
!

navigatorClass
	^SystemNavigator
!

numberClasses
	^self classNames size
!

numberSelectors
	| total |
	total := 0.
	self 
		allClassesDo: [:each | self selectorsForClass: each do: [:sel | total := total + 1]].
	^total
!

openEditor
	^RefactoringBrowser openOnEnvironment: self
!

problemCount
	^self numberSelectors
!

protocolsFor: aClass
	^aClass organization categories select: [:each | self includesProtocol: each in: aClass]
!

searchActions
    "return collected searchActions, if any.
     These may be added by search rules during the search to allow later positioning/selection
     in the browser."

    searchActions isNil ifTrue: [searchActions := OrderedCollection new].
    ^searchActions
!

searchStrings
        searchStrings isNil ifTrue: [searchStrings := OrderedCollection new].
        ^searchStrings
!

searchStrings: aCollection
    self assert:(aCollection isNil
                 or:[aCollection conform:#isString]).
    searchStrings := aCollection
!

selectionIntervalFor: aString 
	| interval |
	self searchStrings isEmpty ifTrue: [^nil].
	interval := self selectionParseTreeIntervalFor: aString.
	interval notNil ifTrue: [^interval].
	self searchStrings do: 
			[:each | 
			| search index |
			search := each isSymbol ifTrue: [each keywords first] ifFalse: [each].
			index := aString indexOfSubCollection: search startingAt: 1.
			index > 0 ifTrue: [^index to: index + search size - 1]].
	^nil
!

selectionParseTreeIntervalFor: aString 
	| parseTree answerBlock |
	parseTree := RBParser parseMethod: aString onError: [:str :pos | ^nil].
	answerBlock := [:aNode :answer | ^aNode sourceInterval].
	self searchStrings do: 
			[:each | 
			| matcher tree |
			matcher := ParseTreeSearcher new.
			each isSymbol 
				ifTrue: 
					[matcher matchesTree: (RBLiteralNode value: each) do: answerBlock.
					tree := ParseTreeSearcher buildSelectorTree: each.
					tree notNil ifTrue: [matcher matchesTree: tree do: answerBlock]]
				ifFalse: 
					[tree := RBVariableNode named: each.
					matcher
						matchesTree: tree do: answerBlock;
						matchesArgumentTree: tree do: answerBlock].
			matcher executeTree: parseTree].
	^nil
!

selectorsFor: aProtocol in: aClass
	^(aClass organization listAtCategoryNamed: aProtocol)
		select: [:each | self includesSelector: each in: aClass]
!

selectorsForClass: aClass 
	| selectors |
	selectors := Set new: 50.
	self selectorsForClass: aClass do: [:each | selectors add: each].
	^selectors
!

selectorsForClass: aClass do: aBlock 
	aClass selectorsAndMethodsDo: 
			[:each :meth | 
			(self includesSelector: each in: aClass) ifTrue: [aBlock value: each]]
!

superclassOrder: category
        "Answer an ordered collection containing the classes in category (a string).
        The classes are ordered with superclasses first so they can be filed in."

        | list |
        list := (self classNamesFor: category asSymbol)
                                collect: [:title | self at: title].
        ^ list topologicalSort:[:a :b | b isSubclassOf:a]

    "Modified: / 25-09-2015 / 05:51:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

whichCategoryIncludes: aClassName
        (Smalltalk dialectName = 'SmalltalkX') ifTrue:[
            | class |

            class := Smalltalk at:aClassName asSymbol.
            class isNil ifTrue: [ ^ nil ].
            ^ class category
        ].
        ^RefactoryBrowserPlatformSupport systemOrganization categoryOfElement: aClassName

    "Modified: / 05-11-2014 / 21:26:45 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

whichProtocolIncludes: aSelector in: aClass
        |mthd|

        (Smalltalk isSmalltalkX) ifTrue:[
            mthd := aClass compiledMethodAt:aSelector.
            mthd isNil ifTrue:[
                ^ nil
            ].
            ^ mthd category 
        ].

        ^aClass organization categoryOfElement: aSelector
! !

!BrowserEnvironment methodsFor:'accessing-classes'!

associationAt: aKey
	| association class |
	association := Smalltalk associationAt: aKey ifAbsent: [nil].
	association value isBehavior
				ifTrue: [class := association value]
				ifFalse: [class := association value class].
	((self includesClass: class) or: [self includesClass: class class])
		ifTrue: [^ association]
		ifFalse: [^ nil]
!

at: aKey
	^self at: aKey ifAbsent: [Smalltalk keyNotFoundError: aKey]
!

at: aKey ifAbsent: aBlock
        | assoc classOrNoClass |
        Smalltalk isSmalltalkX ifTrue:[
            classOrNoClass := Smalltalk at:aKey asSymbol ifAbsent:nil.
            classOrNoClass notNil ifTrue:[
                classOrNoClass isBehavior ifTrue:[
                    ^ classOrNoClass
                ].
            ].
            ^ aBlock value.
        ] ifFalse:[
            assoc := self associationAt: aKey.
            ^assoc isNil
                ifTrue: [aBlock value]
                ifFalse: [assoc value]
        ].
!

cacheClasses
    "search now for my classes and remember them for the future"

    |setOfClasses|

    cachedClasses := nil.   "/ prevent classesDo: from using the cache

    setOfClasses := IdentitySet new.
    self classesDo:[:cls |
        setOfClasses add:cls.
    ].
    cachedClasses := setOfClasses.
!

classNames
        "returns the names of the non-meta classes only"

        | names |
        names := Set new.
        self classesDo: 
                        [:each | 
                        names add: (each isMeta ifTrue: [each soleInstance] ifFalse: [each]) name].
        ^names
!

classes
    | classes |

    classes := Set new.
    self classesDo: [:each | classes add: each].
    ^classes
!

classesDo: aBlock
    cachedClasses notNil ifTrue:[
        cachedClasses do:aBlock
    ] ifFalse:[ 
        self allClassesDo: [:each | (self includesClass: each) ifTrue: [aBlock value: each]]
    ].
!

forgetCachedClasses
    cachedClasses := nil.
!

keys
        | keys |
        keys := Set new.

        (Smalltalk isSmalltalkX) ifTrue:[
            "care for dummies (behaviors, which are not named the same as their key"
            Smalltalk keysAndValuesDo: [:key :value | 
                | class |

                value isBehavior ifTrue: [
                    value name == key ifTrue:[
                        (self includesClass: value) ifTrue: [keys add: key]
                    ]
                ].
                class := value class.
                (self includesClass: class) ifTrue: [keys add: key].
            ].
            ^ keys
        ].

        Smalltalk keysAndValuesDo: 
                        [:key :value | 
                        | class |

                        value isBehavior 
                                ifTrue: [(self includesClass: value) ifTrue: [keys add: key]].
                        class := value class.
                        (self includesClass: class) ifTrue: [keys add: key]].
        ^keys
! !

!BrowserEnvironment methodsFor:'category'!

writeCategory: aCategory on: aStream
	^ RefactoryBrowserPlatformSupport systemOrganization printOutCategory: aCategory on: aStream
! !

!BrowserEnvironment methodsFor:'copying'!

copyEmpty
	^self class new
! !

!BrowserEnvironment methodsFor:'enumerating'!

selectionIntervalsForSource:sourceCode do: aBlock
    self selectionIntervalsForSource:sourceCode tree:nil rule:nil in:nil do:aBlock 
!

selectionIntervalsForSource:sourceCode tree:anRBProgramNode do: aBlock 
    "Evaluate block for each interval in source and its parse tree that matches"

    self selectionIntervalsForSource:sourceCode tree:anRBProgramNode rule:nil in:nil do:aBlock 
!

selectionIntervalsForSource:sourceCode tree:anRBProgramNode in:aClass do: aBlock 
    "Evaluate block for each interval in source and its parse tree that matches"

    self selectionIntervalsForSource:sourceCode tree:anRBProgramNode rule:nil in:aClass do:aBlock 
!

selectionIntervalsForSource:sourceCode tree:anRBProgramNodeOrNil rule:aRuleOrNil in: aClassOrNil do: aBlock 
    "Evaluate block for each interval in source that matches.
     cg:
     This is *very* stupid.
     A naive string search will highlight all kinds of stupid wrong strings.
     Therefore, I have added searchActions, which can provide better info
     (see temporaryNotUsed rule, for example)    
     "

    | searches |

    searchActions notEmptyOrNil ifTrue:[
        searchActions do:[:each |
            |start stop|

            start := each startPosition.
            stop := each stopPosition.
            aBlock value: (start to:stop).
        ].
        ^ self.
    ].
    
    searchStrings notEmptyOrNil ifTrue:[
        searches := self searchStrings asSet.
        searches do:[:search|
            | i |
            i := 1.
            [ 
                i := sourceCode findString: search asString startingAt: i.
                i ~~ 0
            ] whileTrue:[
                aBlock value: (i to: (i + search size - 1)).
                i := i + search size + 1.
            ]
        ]
    ].
    
    "Created: / 02-02-2012 / 21:02:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-10-2014 / 15:19:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BrowserEnvironment methodsFor:'environments'!

& anEnvironment 
	"If we or anEnvironment includes everything, then just include the other environment (optimization)"

	self isSystem ifTrue: [^anEnvironment].
	anEnvironment isSystem ifTrue: [^self].
	^AndEnvironment onEnvironment: self and: anEnvironment
!

forCategories: categoryList 
	^CategoryEnvironment onEnvironment: self categories: categoryList
!

forClass: aClass protocols: protocolCollection 
	^ProtocolEnvironment onEnvironment: self
		class: aClass
		protocols: protocolCollection
!

forClass: aClass selectors: selectorCollection 
	^(SelectorEnvironment 
		onMethods: selectorCollection
		forClass: aClass
		in: self)
		label: aClass name , '>>' 
					, (selectorCollection detect: [:each | true] ifNone: ['']);
		yourself
!

forClasses: classCollection 
	| classes |
	classes := OrderedCollection new: classCollection size * 2.
	classCollection do: 
			[:each | 
			classes add: each;
				add: each class].
	^ClassEnvironment onEnvironment: self classes: classes
!

implementorsMatching: aString 
	^SelectorEnvironment implementorsMatching: aString in: self
!

implementorsOf: aSelector 
	^SelectorEnvironment implementorsOf: aSelector in: self
!

instVarReadersTo: instVarName in: aClass 
	^VariableEnvironment 
		on: self
		readersOfInstanceVariable: instVarName
		in: aClass
!

instVarRefsTo: instVarName in: aClass 
	^VariableEnvironment 
		on: self
		referencesToInstanceVariable: instVarName
		in: aClass
!

instVarWritersTo: instVarName in: aClass 
	^VariableEnvironment 
		on: self
		writersOfInstanceVariable: instVarName
		in: aClass
!

matches: aString 
	^SelectorEnvironment matches: aString in: self
!

not
	self isSystem ifTrue: [^SelectorEnvironment new].
	^NotEnvironment onEnvironment: self
!

referencesTo: aLiteral 
	^SelectorEnvironment referencesTo: aLiteral in: self
!

referencesTo: aLiteral in: aClass 
        | classes |
        classes := aClass withAllSuperclasses asNewSet.
        classes
                addAll: aClass allSubclasses;
                addAll: aClass class withAllSuperclasses;
                addAll: aClass class allSubclasses.
        ^(self forClasses: classes) referencesTo: aLiteral
!

selectMethods: aBlock 
    | env |
    
    env := SelectorEnvironment onEnvironment: self.
    self classesAndSelectorsDo:[:eachClass :sel | 
        (aBlock value: (eachClass compiledMethodAt: sel)) ifTrue: [
            env addClass: eachClass selector: sel
        ]
    ].
    ^env
!

| anEnvironment 
	"If we or anEnvironment includes everything, then return it instead of creating 
	an or that will include everything."

	self isSystem ifTrue: [^self].
	anEnvironment isSystem ifTrue: [^anEnvironment].
	^(self not & anEnvironment not) not
! !

!BrowserEnvironment methodsFor:'fileOut'!

fileOutCategory: aCategory on: aStream
	^RefactoryBrowserPlatformSupport systemOrganization fileOutCategorySource: aCategory on: aStream
! !

!BrowserEnvironment methodsFor:'initialization & release'!

initialize
!

label: aString
	label := aString
! !

!BrowserEnvironment methodsFor:'printing'!

printOn: aStream
	aStream nextPutAll: self label
!

storeOn: aStream 
	aStream
		nextPutAll: self class name;
		nextPutAll: ' new'
! !

!BrowserEnvironment methodsFor:'private'!

allClassesDo: aBlock 
	Smalltalk allBehaviorsDo: aBlock
!

defaultLabel
	^'Smalltalk'
!

label
	^label isNil
		ifTrue: [self defaultLabel]
		ifFalse: [label]
! !

!BrowserEnvironment methodsFor:'testing'!

definesClass: aClass
	^true
!

includesCategory: aCategory
	^true
!

includesClass: aClass
	^true
!

includesProtocol: aProtocol in: aClass
	^true
!

includesSelector: aSelector in: aClass
	^true
!

isClassEnvironment
	^false
!

isEmpty
	^false
!

isPackageEnvironment
        ^false
!

isParseTreeEnvironment
    ^ false
!

isSelector
	^false
!

isSystem
	^true
! !

!BrowserEnvironment class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

