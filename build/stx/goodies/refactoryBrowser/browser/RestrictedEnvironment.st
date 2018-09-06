"{ Package: 'stx:goodies/refactoryBrowser/browser' }"

"{ NameSpace: Smalltalk }"

LimitedEnvironment subclass:#RestrictedEnvironment
	instanceVariableNames:'classDict'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Environments'
!

RestrictedEnvironment comment:'RestrictedEnvironment represents a collection of methods to be browsed.

Instance Variables:
	classDict	<Dictionary key: Behavior value: Symbol>	the methods to browse for each class'
!


!RestrictedEnvironment class methodsFor:'instance creation'!

implementorsMatching: aString in: anEnvironment 
	| classDict |
	classDict := Dictionary new.
	anEnvironment classesDo: 
			[:class | 
			| selectors |
			selectors := (anEnvironment selectorsForClass: class)
						select: [:each | aString match: each].
			selectors isEmpty ifFalse: [classDict at: class put: selectors]].
	^(self onEnvironment: anEnvironment) on: classDict;
		label: 'Implementors of ' , aString;
		yourself
!

implementorsOf: aSelector in: anEnvironment 
	| classDict |
	classDict := Dictionary new.
	anEnvironment classesDo: [:class | ((class includesSelector: aSelector)
			and: [anEnvironment includesSelector: aSelector in: class])
			ifTrue: [classDict at: class put: (Set with: aSelector)]].
	^(self onEnvironment: anEnvironment)
		on: classDict;
		label: 'Implementors of ' , aSelector; yourself
!

matches: aString in: anEnvironment 
	| newEnvironment |
	newEnvironment := (self onEnvironment: anEnvironment)
				label: 'Matching: ' , aString;
				searchStrings: (Array with: aString); yourself.
	anEnvironment classesDo: [:each | (anEnvironment selectorsForClass: each)
			do: 
				[:sel | 
				| method |
				method := each compiledMethodAt: sel.
				method allLiterals do: [:lit | lit isString ifTrue: [(aString match: lit)
							ifTrue: [newEnvironment addClass: each selector: sel]]]]].
	^newEnvironment
!

onMethods: selectorCollection forClass: aClass in: anEnvironment 
	| env |
	env := self onEnvironment: anEnvironment.
	selectorCollection do: [:each | env addClass: aClass selector: each].
	^env
!

referencesTo: aLiteral in: anEnvironment 
	| classDict literalPrintString |
	literalPrintString := aLiteral isVariableBinding
				ifTrue: [aLiteral key asString]
				ifFalse: 
					[aLiteral isString ifTrue: [aLiteral] ifFalse: [aLiteral printString]].
	classDict := Dictionary new.
	anEnvironment classesDo: 
			[:class | 
			| selectors |
			selectors := (class whichSelectorsReferTo: aLiteral)
						select: [:aSelector | anEnvironment includesSelector: aSelector in: class].
			selectors isEmpty ifFalse: [classDict at: class put: selectors]].
	^(self onEnvironment: anEnvironment) on: classDict;
		label: 'References to: ' , literalPrintString;
		searchStrings: (Array with: literalPrintString);
		yourself
!

referencesTo: aLiteral inClass: aClass in: anEnvironment 
	| classDict literalPrintString classes |
	literalPrintString := aLiteral isVariableBinding
				ifTrue: [aLiteral key asString]
				ifFalse: 
					[literalPrintString := aLiteral isString ifTrue: [aLiteral] ifFalse: [aLiteral printString]].
	classDict := Dictionary new.
	classes := aClass withAllSuperclasses asOrderedCollection.
	classes addAll: aClass allSubclasses;
		addAll: aClass class withAllSuperclasses;
		addAll: aClass class allSubclasses.
	classes do: 
			[:each | 
			| class selectors classSelectors |
			class := (anEnvironment includesClass: each) ifTrue: [each] ifFalse: [nil].
			class notNil ifTrue: 
					[classSelectors := anEnvironment selectorsForClass: class.
					selectors := (class whichSelectorsReferTo: aLiteral)
								select: [:aSelector | classSelectors includes: aSelector].
					selectors isEmpty ifFalse: [classDict at: class put: selectors].
					classSelectors := anEnvironment selectorsForClass: class class.
					selectors := (class class whichSelectorsReferTo: aLiteral)
								select: [:aSelector | classSelectors includes: aSelector].
					selectors isEmpty ifFalse: [classDict at: class class put: selectors]]].
	^(self onEnvironment: anEnvironment) on: classDict;
		label: 'References to: ' , literalPrintString;
		searchStrings: (Array with: literalPrintString);
		yourself
! !

!RestrictedEnvironment methodsFor:'accessing'!

navigatorClass
	^self numberSelectors = 1
		ifTrue: [BrowserNavigator]
		ifFalse: [ClassSelectorNavigator]
!

numberSelectors
	"This doesn't compute the correct result when a method that is included in our method list is not in the
	environment we are wrapping. It is implemented this way for efficiency."

	^classDict values inject: 0 into: [:val :each | val + each size]
!

problemCount
	^self numberSelectors
! !

!RestrictedEnvironment methodsFor:'accessing-classes'!

classNames
	^(classDict keys
		collect: [:each | each isMeta ifTrue: [each soleInstance name] ifFalse: [each name]])
			asOrderedCollection
! !

!RestrictedEnvironment methodsFor:'adding'!

addClass: aClass
	classDict at: aClass put: aClass selectors
!

addClass: aClass selector: aSymbol 
	(classDict at: aClass ifAbsentPut: [Set new])
		add: aSymbol
! !

!RestrictedEnvironment methodsFor:'copying'!

postCopy
	| newDict |
	newDict := classDict copy.
	newDict keysAndValuesDo: [:key :value | newDict at: key put: value copy].
	classDict := newDict.
	^super postCopy
! !

!RestrictedEnvironment methodsFor:'initialize-release'!

initialize
	super initialize.
	classDict := Dictionary new
!

on: aDict
	classDict := aDict
! !

!RestrictedEnvironment methodsFor:'private'!

defaultLabel
	^'some methods'
!

privateIncludesSelector: aSelector inClass: aClass
	^(classDict at: aClass ifAbsent: [#()])
		includes: aSelector
! !

!RestrictedEnvironment methodsFor:'removing'!

removeClass: aClass
	classDict removeKey: aClass ifAbsent: []
!

removeClass: aClass selector: aSelector
	(classDict at: aClass ifAbsent: [^self])
		remove: aSelector ifAbsent: []
! !

!RestrictedEnvironment methodsFor:'testing'!

includesCategory: aCategory 
	^(super includesCategory: aCategory)
		and: [(self classNamesFor: aCategory)
				contains: 
					[:className | 
					| class |
					class := self at: className ifAbsent: [nil].
					class notNil and: [(classDict includesKey: class)
							or: [classDict includesKey: class class]]]]
!

includesClass: aClass 
	^(classDict at: aClass ifAbsent: [#()]) isEmpty not
		and: [super includesClass: aClass]
!

includesProtocol: aProtocol in: aClass 
	^(super includesProtocol: aProtocol in: aClass)
		and: [(environment selectorsFor: aProtocol in: aClass)
				contains: [:aSelector | self privateIncludesSelector: aSelector inClass: aClass]]
!

includesSelector: aSelector in: aClass 
	^(environment includesSelector: aSelector in: aClass)
		and: [self privateIncludesSelector: aSelector inClass: aClass]
!

isEmpty
	^classDict isEmpty
!

isSelector
	^true
! !

!RestrictedEnvironment class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Id$'
!

version_SVN
    ^ '$Id$'
! !

