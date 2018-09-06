"{ Package: 'stx:goodies/refactoryBrowser/browser' }"

"{ NameSpace: Smalltalk }"

BrowserEnvironmentWrapper subclass:#SelectorEnvironment
	instanceVariableNames:'classSelectors metaClassSelectors'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Environments'
!

SelectorEnvironment comment:'SelectorEnvironment represents a collection of methods to be browsed.

Instance Variables:
	classSelectors  <Dictionary key: Symbol value: (Collection of: Symbol)> selectors for the class side
	metaClassSelectors      <Dictionary key: Symbol value: (Collection of: Symbol)> selectors for the metaclass side
'
!


!SelectorEnvironment class methodsFor:'instance creation'!

implementorsMatching: aString in: anEnvironment 
        | classDict metaDict |
        classDict := IdentityDictionary new.
        metaDict := IdentityDictionary new.
        anEnvironment classesDo: 
                        [:class | 
                        | selectors |
                        selectors := Set new.
                        anEnvironment selectorsForClass: class
                                do: [:each | (aString match: each) ifTrue: [selectors add: each]].
                        selectors isEmpty 
                                ifFalse: 
                                        [class isMeta 
                                                ifTrue: [metaDict at: class soleInstance name put: selectors]
                                                ifFalse: [classDict at: class name put: selectors]]].
        ^(self onEnvironment: anEnvironment)
                classSelectors: classDict metaClassSelectors: metaDict;
                label: 'Implementors of ' , aString;
                yourself
!

implementorsOf: aSelector in: anEnvironment 
	| classDict metaDict selectors |
	classDict := IdentityDictionary new.
	metaDict := IdentityDictionary new.
	selectors := Array with: aSelector.
	anEnvironment classesDo: 
			[:class | 
			((class includesSelector: aSelector) 
				and: [anEnvironment includesSelector: aSelector in: class]) 
					ifTrue: 
						[class isMeta 
							ifTrue: [metaDict at: class soleInstance name put: selectors]
							ifFalse: [classDict at: class name put: selectors]]].
	^(self onEnvironment: anEnvironment)
		classSelectors: classDict metaClassSelectors: metaDict;
		label: 'Implementors of ' , aSelector;
		yourself
!

matches: aString in: anEnvironment 
    | newEnvironment |
    
    newEnvironment := (self onEnvironment: anEnvironment)
                            label: 'Matching: ' , aString;
                            searchStrings: (Array with: aString);
                            yourself.
    anEnvironment classesAndSelectorsDo:[:eachClass :sel | 
        | method |
        method := eachClass compiledMethodAt: sel.
        method allLiterals do:[:lit | 
            lit isString ifTrue:[ 
                (aString match: lit) ifTrue: [
                    newEnvironment addClass: eachClass selector: sel
                ]
            ]
        ]
    ].
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
! !

!SelectorEnvironment methodsFor:'accessing'!

navigatorClass
	^self numberSelectors = 1
		ifTrue: [BrowserNavigator]
		ifFalse: [ClassSelectorNavigator]
!

numberSelectors
        "cg: should be named 'numberOfMethods', as that is what it returns (think of same selector in different classes)"

        "This doesn't compute the correct result when a method that is included in our method list is not in the
        environment we are wrapping. It is implemented this way for efficiency."

        ^(classSelectors inject: 0 into: [:sum :each | sum + each size]) 
                + (metaClassSelectors inject: 0 into: [:sum :each | sum + each size])
!

selectorsForClass: aClass do: aBlock 
	^(self privateSelectorsForClass: aClass) 
		do: [:each | (aClass includesSelector: each) ifTrue: [aBlock value: each]]
! !

!SelectorEnvironment methodsFor:'accessing-classes'!

classNames
	| names |
	names := Set new: classSelectors size + metaClassSelectors size.
	names
		addAll: classSelectors keys;
		addAll: metaClassSelectors keys.
	^names asOrderedCollection
!

classesDo: aBlock 
    cachedClasses notNil ifTrue:[
        cachedClasses do:aBlock
    ] ifFalse:[ 
        classSelectors keysDo: 
                        [:each | 
                        | class |
                        class := Smalltalk at: each ifAbsent: [nil].
                        class notNil 
                                ifTrue: [(self includesClass: class) ifTrue: [aBlock value: class]]].
        metaClassSelectors keysDo: 
                        [:each | 
                        | class |
                        class := Smalltalk at: each ifAbsent: [nil].
                        class notNil 
                                ifTrue: 
                                        [(self includesClass: class class) ifTrue: [aBlock value: class class]]]
    ]
! !

!SelectorEnvironment methodsFor:'adding'!

addClass: aClass 
	aClass isMeta 
		ifTrue: 
			[metaClassSelectors at: aClass soleInstance name put: aClass selectors]
		ifFalse: [classSelectors at: aClass name put: aClass selectors]
!

addClass: aClass selector: aSymbol
        (aClass isMeta 
                ifTrue: 
                        [metaClassSelectors at: aClass soleInstance name ifAbsentPut: [Set new]]
                ifFalse: [classSelectors at: aClass name ifAbsentPut: [Set new]]) add: aSymbol
! !

!SelectorEnvironment methodsFor:'copying'!

postCopy
	| newDict |
	newDict := classSelectors copy.
	newDict keysAndValuesDo: [:key :value | newDict at: key put: value copy].
	classSelectors := newDict.
	newDict := metaClassSelectors copy.
	newDict keysAndValuesDo: [:key :value | newDict at: key put: value copy].
	metaClassSelectors := newDict.
	^super postCopy
! !

!SelectorEnvironment methodsFor:'initialize-release'!

classSelectors: classSelectorDictionary metaClassSelectors: metaClassSelectorDictionary 
	classSelectors := classSelectorDictionary.
	metaClassSelectors := metaClassSelectorDictionary
!

classes: classArray metaClasses: metaArray 
	"Used to recreate an environment from its storeString"

	classSelectors := Dictionary new.
	metaClassSelectors := Dictionary new.
	classArray 
		do: [:each | classSelectors at: each first put: each last asSet].
	metaArray 
		do: [:each | metaClassSelectors at: each first put: each last asSet]
!

initialize
	super initialize.
	classSelectors := IdentityDictionary new.
	metaClassSelectors := IdentityDictionary new
!

on: aDict 
        aDict keysAndValuesDo: 
                        [:class :selectors | 
                        class isMeta 
                                ifTrue: [metaClassSelectors at: class soleInstance name put: selectors]
                                ifFalse: [classSelectors at: class name put: selectors]]
! !

!SelectorEnvironment methodsFor:'printing'!

storeOn: aStream 
        | classBlock |
        aStream
                nextPutAll: '((';
                nextPutAll: self class name;
                nextPutAll: ' onEnvironment: '.
        environment storeOn: aStream.
        aStream
                nextPut: $);
                nextPutAll: ' classes: #('.

        ((Smalltalk respondsTo:#isSmalltalkX) and:[Smalltalk isSmalltalkX]) ifTrue:[
            classBlock := 
                            [:key :value | 
                            aStream
                                    nextPutAll: '#(';
                                    nextPutAll: key storeString;    "SmalltalkX"
                                    nextPutAll: ' #('.
                            value do: 
                                            [:each | 
                                            aStream
                                                    nextPutAll: each storeString;    "SmalltalkX"
                                                    nextPut: $ ].
                            aStream
                                    nextPutAll: '))';
                                    cr].
        ] ifFalse:[
            classBlock := 
                            [:key :value | 
                            aStream
                                    nextPutAll: '#(';
                                    nextPutAll: key;   
                                    nextPutAll: ' #('.
                            value do: 
                                            [:each | 
                                            aStream
                                                    nextPutAll: each;    
                                                    nextPut: $ ].
                            aStream
                                    nextPutAll: '))';
                                    cr].
        ].
        classSelectors keysAndValuesDo: classBlock.
        aStream nextPutAll: ') metaClasses: #('.
        metaClassSelectors keysAndValuesDo: classBlock.
        aStream nextPutAll: '))'
! !

!SelectorEnvironment methodsFor:'private'!

defaultLabel
    |n nClassSelectors nMetaClassSelectors|

    nClassSelectors := (classSelectors collect:[:each | each value size]) sum.
    nMetaClassSelectors := (metaClassSelectors collect:[:each | each value size]) sum. 

    n := nClassSelectors + nMetaClassSelectors.
    n == 1 ifTrue:[
        ^ (classSelectors notEmptyOrNil 
                    ifTrue:[ classSelectors ]
                    ifFalse:[ metaClassSelectors ])
            anElement anElement.
    ].
    ^ n printString, ' methods'
"/    ^'some methods'

    "Modified: / 08-03-2012 / 03:36:07 / cg"
!

privateIncludesSelector: aSelector inClass: aClass 
	^(self privateSelectorsForClass: aClass) includes: aSelector
!

privateSelectorsForClass: aClass 
	^aClass isMeta 
		ifTrue: [metaClassSelectors at: aClass soleInstance name ifAbsent: [#()]]
		ifFalse: [classSelectors at: aClass name ifAbsent: [#()]]
! !

!SelectorEnvironment methodsFor:'removing'!

removeClass: aClass 
	aClass isMeta 
		ifTrue: [metaClassSelectors removeKey: aClass soleInstance name ifAbsent: []]
		ifFalse: [classSelectors removeKey: aClass name ifAbsent: []]
!

removeClass: aClass selector: aSelector 
	(aClass isMeta 
		ifTrue: [metaClassSelectors at: aClass soleInstance name ifAbsent: [^self]]
		ifFalse: [classSelectors at: aClass name ifAbsent: [^self]]) 
			remove: aSelector
			ifAbsent: []
! !

!SelectorEnvironment methodsFor:'testing'!

includesCategory: aCategory 
	^(super includesCategory: aCategory) and: 
			[(self classNamesFor: aCategory) contains: 
					[:className | 
					(classSelectors includesKey: className) 
						or: [metaClassSelectors includesKey: className]]]
!

includesClass: aClass 
	^(self privateSelectorsForClass: aClass) isEmpty not 
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
	^classSelectors isEmpty and: [metaClassSelectors isEmpty]
!

isSelector
	^true
! !

!SelectorEnvironment class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

