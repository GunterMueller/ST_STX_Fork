"{ Package: 'stx:goodies/refactoryBrowser/browser' }"

BrowserEnvironmentWrapper subclass:#VariableEnvironment
	instanceVariableNames:'instanceVariables instanceVariableReaders instanceVariableWriters
		classVariables selectorCache'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Environments'
!


!VariableEnvironment class methodsFor:'instance creation'!

on: anEnvironment readersOfInstanceVariable: aString in: aClass 
	^(self onEnvironment: anEnvironment)
		label: 'Readers of ''' , aString , ''' in ' , aClass name;
		addClass: aClass instanceVariableReader: aString;
		yourself
!

on: anEnvironment referencesToClassVariable: aSymbol in: aClass 
	^(self onEnvironment: anEnvironment)
		label: 'References to ''' , aSymbol , ''' in ' , aClass name;
		addClass: aClass classVariable: aSymbol;
		yourself
!

on: anEnvironment referencesToInstanceVariable: aString in: aClass 
	^(self onEnvironment: anEnvironment)
		label: 'References to ''' , aString , ''' in ' , aClass name;
		addClass: aClass instanceVariable: aString;
		yourself
!

on: anEnvironment writersOfInstanceVariable: aString in: aClass 
	^(self onEnvironment: anEnvironment)
		label: 'Writers of ''' , aString , ''' in ' , aClass name;
		addClass: aClass instanceVariableWriter: aString;
		yourself
!

readersOfInstanceVariable: aString in: aClass 
	^self 
		on: BrowserEnvironment new
		readersOfInstanceVariable: aString
		in: aClass
!

referencesToClassVariable: aSymbol in: aClass 
	^self 
		on: BrowserEnvironment new
		referencesToClassVariable: aSymbol
		in: aClass
!

referencesToInstanceVariable: aString in: aClass 
	^self 
		on: BrowserEnvironment new
		referencesToInstanceVariable: aString
		in: aClass
!

writersOfInstanceVariable: aString in: aClass 
	^self 
		on: BrowserEnvironment new
		writersOfInstanceVariable: aString
		in: aClass
! !

!VariableEnvironment methodsFor:'accessing'!

addClass: aClass classVariable: aSymbol 
	(classVariables at: aClass name ifAbsentPut: [Set new]) add: aSymbol.
	self flushCachesFor: aClass.
	self addSearchString: aSymbol
!

addClass: aClass instanceVariable: aString 
	(instanceVariables at: aClass name ifAbsentPut: [Set new]) add: aString.
	self flushCachesFor: aClass.
	self addSearchString: aString
!

addClass: aClass instanceVariableReader: aString 
	(instanceVariableReaders at: aClass name ifAbsentPut: [Set new]) 
		add: aString.
	self flushCachesFor: aClass.
	self addSearchString: aString
!

addClass: aClass instanceVariableWriter: aString 
	(instanceVariableWriters at: aClass name ifAbsentPut: [Set new]) 
		add: aString.
	self flushCachesFor: aClass.
	self addSearchString: aString
!

classNamesWithVariables
	| classNames |
	classNames := Set new.
	classNames
		addAll: instanceVariables keys;
		addAll: instanceVariableReaders keys;
		addAll: instanceVariableWriters keys;
		addAll: classVariables keys.
	^classNames
!

classVariablesFor: aClass 
	^classVariables at: aClass name ifAbsent: [#()]
!

environmentForClassVariable: aSymbol in: aClass 
        | selectorEnvironment assoc block |
        selectorEnvironment := SelectorEnvironment onEnvironment: self.
        selectorEnvironment addSearchString: aSymbol.
        ((classVariables at: aClass name ifAbsent: [#()]) includes: aSymbol) 
                ifFalse: [^selectorEnvironment].

        ((Smalltalk respondsTo:#isSmalltalkX) and:[Smalltalk isSmalltalkX]) ifTrue:[
            block := 
                            [:each | 
                            (each whichSelectorsReferToClassVariable:aSymbol) 
                                    do: [:sel | selectorEnvironment addClass: each selector: sel]].
        ] ifFalse:[
            assoc := aClass bindingFor: aSymbol.
            block := 
                            [:each | 
                            (each whichSelectorsReferTo: assoc) 
                                    do: [:sel | selectorEnvironment addClass: each selector: sel]].
        ].
        aClass withAllSubclasses do: 
                        [:each | 
                        block
                                value: each;
                                value: each class].
        ^selectorEnvironment
!

environmentForInstanceVariable: aString in: aClass 
	| selectorEnvironment isReader isWriter |
	selectorEnvironment := SelectorEnvironment onEnvironment: self.
	selectorEnvironment addSearchString: aString.
	isReader := isWriter := false.
	((instanceVariables at: aClass name ifAbsent: [#()]) includes: aString) 
		ifTrue: 
			[isReader := true.
			isWriter := true].
	((instanceVariableWriters at: aClass name ifAbsent: [#()]) 
		includes: aString) ifTrue: [isWriter := true].
	((instanceVariableReaders at: aClass name ifAbsent: [#()]) 
		includes: aString) ifTrue: [isReader := true].
	aClass withAllSubclasses do: 
			[:each | 
			isWriter 
				ifTrue: 
					[(each whichSelectorsAssign: aString) 
						do: [:sel | selectorEnvironment addClass: each selector: sel]].
			isReader 
				ifTrue: 
					[(each whichSelectorsRead: aString) 
						do: [:sel | selectorEnvironment addClass: each selector: sel]]].
	^selectorEnvironment
!

instanceVariablesFor: aClass 
	| vars name |
	vars := Set new.
	name := aClass name.
	vars
		addAll: (instanceVariables at: name ifAbsent: [#()]);
		addAll: (instanceVariableReaders at: name ifAbsent: [#()]);
		addAll: (instanceVariableWriters at: name ifAbsent: [#()]).
	^vars
!

numberVariables
	^self accessorMethods inject: 0
		into: [:sum :each | sum + ((self perform: each) inject: 0 into: [:s :e | s + e size])]
!

problemCount
	^self numberVariables
!

removeClass: aClass classVariable: aSymbol 
	| vars |
	vars := classVariables at: aClass name ifAbsent: [Set new].
	vars remove: aSymbol ifAbsent: [].
	vars isEmpty ifTrue: [classVariables removeKey: aClass name ifAbsent: []].
	self flushCachesFor: aClass
!

removeClass: aClass instanceVariable: aString 
	| vars |
	vars := instanceVariables at: aClass name ifAbsent: [Set new].
	vars remove: aString ifAbsent: [].
	vars isEmpty 
		ifTrue: [instanceVariables removeKey: aClass name ifAbsent: []].
	self flushCachesFor: aClass
!

removeClass: aClass instanceVariableReader: aString 
	| vars |
	vars := instanceVariableReaders at: aClass name ifAbsent: [Set new].
	vars remove: aString ifAbsent: [].
	vars isEmpty 
		ifTrue: [instanceVariableReaders removeKey: aClass name ifAbsent: []].
	self flushCachesFor: aClass
!

removeClass: aClass instanceVariableWriter: aString 
	| vars |
	vars := instanceVariableWriters at: aClass name ifAbsent: [Set new].
	vars remove: aString ifAbsent: [].
	vars isEmpty 
		ifTrue: [instanceVariableWriters removeKey: aClass name ifAbsent: []].
	self flushCachesFor: aClass
! !

!VariableEnvironment methodsFor:'copying'!

copyDictionary: aDictionary 
	| copy |
	copy := Dictionary new: aDictionary size.
	aDictionary keysAndValuesDo: [:key :value | copy at: key put: value].
	^copy
!

postCopy
	super postCopy.
	instanceVariables := self copyDictionary: instanceVariables.
	instanceVariableReaders := self copyDictionary: instanceVariableReaders.
	instanceVariableWriters := self copyDictionary: instanceVariableWriters.
	classVariables := self copyDictionary: classVariables.
	selectorCache := nil
! !

!VariableEnvironment methodsFor:'initialize-release'!

initialize
	super initialize.
	instanceVariables := Dictionary new.
	classVariables := Dictionary new.
	instanceVariableReaders := Dictionary new.
	instanceVariableWriters := Dictionary new
! !

!VariableEnvironment methodsFor:'printing'!

storeOn: aStream 
	aStream
		nextPut: $(;
		nextPutAll: self class name;
		nextPutAll: ' new '.
	#(#instanceVariables #instanceVariableReaders #instanceVariableWriters #classVariables) 
		do: 
			[:each | 
			aStream
				nextPutAll: each;
				nextPutAll: ': '.
			(self perform: each) storeOn: aStream.
			aStream nextPutAll: '; '].
	aStream nextPutAll: ' yourself)'
! !

!VariableEnvironment methodsFor:'private'!

accessorMethods
	^#(#instanceVariables #instanceVariableReaders #instanceVariableWriters #classVariables)
!

allClassesDo: aBlock 
	| classes instVarBlock |
	classes := Set new.
	instVarBlock := 
			[:each | 
			| class |
			class := self classForName: each.
			classes addAll: class withAllSubclasses].
	instanceVariables keysDo: instVarBlock.
	instanceVariableReaders keysDo: instVarBlock.
	instanceVariableWriters keysDo: instVarBlock.
	classVariables keysDo: 
			[:each | 
			| class |
			class := self classForName: each.
			class notNil 
				ifTrue: 
					[classes
						addAll: class withAllSubclasses;
						addAll: class class withAllSubclasses]].
	classes do: aBlock
!

classForName: aString 
	| name isMeta class |
	isMeta := aString includes: $ .
	name := (isMeta 
				ifTrue: [aString copyFrom: 1 to: (aString size - 6 max: 1)]
				ifFalse: [aString]) asSymbol.
	class := Smalltalk at: name ifAbsent: [nil].
	^class notNil & isMeta ifTrue: [class class] ifFalse: [class]
!

classVariableSelectorsFor: aClass 
        | selectors classVars nonMetaClass |
        nonMetaClass := aClass isMeta 
                                ifTrue: [aClass soleInstance]
                                ifFalse: [aClass].
        selectors := Set new.
        classVars := Set new.
        classVariables keysDo: 
                        [:each | 
                            | cls |
                            cls := self classForName: each.
                            (cls notNil and: [nonMetaClass includesBehavior: cls]) 
                                    ifTrue: [classVars addAll: (classVariables at: each)]].
        classVars do: 
                        [:each | 
                            | binding |
                            ((Smalltalk respondsTo:#isSmalltalkX) and:[Smalltalk isSmalltalkX]) ifTrue:[
                                selectors addAll: (aClass whichSelectorsReferToClassVariable: each)
                            ] ifFalse:[
                                binding := aClass bindingFor: each.
                                binding notNil 
                                        ifTrue: [selectors addAll: (aClass whichSelectorsReferTo: binding)]]
                        ].
        ^selectors
!

classVariables
	^classVariables
!

classVariables: anObject
	classVariables := anObject
!

computeSelectorCacheFor: aClass 
	^(self instanceVariableSelectorsFor: aClass)
		addAll: (self classVariableSelectorsFor: aClass);
		yourself
!

flushCachesFor: aClass 
	| nonMetaClass |
	selectorCache isNil ifTrue: [^self].
	nonMetaClass := aClass isMeta 
				ifTrue: [aClass soleInstance]
				ifFalse: [aClass].
	nonMetaClass withAllSubclasses do: 
			[:each | 
			selectorCache
				removeKey: each ifAbsent: [];
				removeKey: each class ifAbsent: []]
!

instanceVariableReaders
	^instanceVariableReaders
!

instanceVariableReaders: anObject
	instanceVariableReaders := anObject
!

instanceVariableSelectorsFor: aClass 
	| selectors |
	selectors := Set new.
	#(#instanceVariables #instanceVariableReaders #instanceVariableWriters) 
		with: #(#whichSelectorsAccess: #whichSelectorsRead: #whichSelectorsAssign:)
		do: 
			[:var :sel | 
			| instVars |
			instVars := Set new.
			(self perform: var) keysDo: 
					[:each | 
					| cls |
					cls := self classForName: each.
					(cls notNil and: [aClass includesBehavior: cls]) 
						ifTrue: [instVars addAll: ((self perform: var) at: each)]].
			instVars do: [:each | selectors addAll: (aClass perform: sel with: each)]].
	^selectors
!

instanceVariableWriters
	^instanceVariableWriters
!

instanceVariableWriters: anObject
	instanceVariableWriters := anObject
!

instanceVariables
	^instanceVariables
!

instanceVariables: anObject
	instanceVariables := anObject
!

navigatorClass
	^self numberVariables > 1 
		ifTrue: [VariableNavigator]
		ifFalse: 
			[self numberSelectors = 0 
				ifTrue: [VariableNavigator]
				ifFalse: [ClassSelectorNavigator]]
!

selectorCache
	^selectorCache isNil 
		ifTrue: [selectorCache := Dictionary new]
		ifFalse: [selectorCache]
!

selectorCacheFor: aClass 
	^self selectorCache at: aClass
		ifAbsentPut: [self computeSelectorCacheFor: aClass]
! !

!VariableEnvironment methodsFor:'testing'!

includesCategory: aCategory 
	^(self classNamesFor: aCategory) isEmpty not
!

includesClass: aClass 
	(super includesClass: aClass) ifFalse: [^false].
	(instanceVariables includesKey: aClass) ifTrue: [^true].
	(classVariables includesKey: aClass) ifTrue: [^true].
	^((self selectorCacheFor: aClass) 
		detect: [:each | self includesSelector: each in: aClass]
		ifNone: [nil]) notNil
!

includesProtocol: aProtocol in: aClass 
	^(self selectorsFor: aProtocol in: aClass) isEmpty not
!

includesSelector: aSymbol in: aClass 
	^(environment includesSelector: aSymbol in: aClass) 
		and: [(self selectorCacheFor: aClass) includes: aSymbol]
!

isEmpty
	self accessorMethods 
		do: [:each | (self perform: each) isEmpty ifFalse: [^false]].
	^true
! !

!VariableEnvironment class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/browser/VariableEnvironment.st,v 1.8 2013-06-25 22:50:46 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/browser/VariableEnvironment.st,v 1.8 2013-06-25 22:50:46 cg Exp $'
!

version_SVN
    ^ '$Id: VariableEnvironment.st,v 1.8 2013-06-25 22:50:46 cg Exp $'
! !

