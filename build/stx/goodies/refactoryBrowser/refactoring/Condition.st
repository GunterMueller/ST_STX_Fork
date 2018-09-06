"{ Package: 'stx:goodies/refactoryBrowser/refactoring' }"

"{ NameSpace: Smalltalk }"

RBAbstractCondition subclass:#RBCondition
	instanceVariableNames:'block type errorBlock'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Conditions'
!

RBCondition comment:'Condition represents a condition that must be true for a refactoring to be performed.

Instance Variables:
	block	<Block>	this is the block that gets evaluated to check the condition
	errorBlock	<Block | nil>	if not nil, this is a block that if the condition fails, will produce some means of browsing the failure (such as opening a browser on the failures)
	type	<Array>		This array holds a symbol identifying the type of condition this is along
						with its parameters. Right now this is pretty useless, other than for printing,
						but in the future, we hope to be able to use this to assert postconditions of
						refactorings.'
!


!RBCondition class methodsFor:'instance creation'!

canUnderstand: aSelector in: aClass
	^self new
		type: (Array with: #understandsSelector with: aClass with: aSelector)
		block: [aClass definesMethod: aSelector]
		errorString: aClass printString , ' <1?:does not >understand<1?s:> ' , aSelector printString
!

definesClassVar: aString in: aClass
        <resource: #obsolete>
        self obsoleteMethodWarning.

        ^self new
                type: (Array with: #definesClassVar with: aClass with: aString)
                block: [(aClass allClassVarNames collect: [:each | each asString])
                                includes: aString asString]
                errorString: aClass printString , ' <1?:does not >define<1?s:> class variable ' , aString

    "Modified: / 06-08-2012 / 11:58:15 / cg"
!

definesClassVariable: aString in: aClass 
	^self new 
		type: (Array 
				with: #definesClassVar
				with: aClass
				with: aString)
		block: [aClass definesClassVariable: aString]
		errorString: aClass printString 
				, ' <1?:does not >define<1?s:> class variable ' , aString
!

definesInstVar: aString in: aClass
    "cg: same as definesInstanceVariable:in: ???"

        ^self new
                type: (Array with: #definesInstVar with: aClass with: aString)
                block: [aClass allInstanceVariableNames includes: aString]
                errorString: aClass printString , ' <1?:does not >define<1?s:> instance variable ' , aString

    "Modified (comment): / 06-08-2012 / 11:59:28 / cg"
!

definesInstanceVariable: aString in: aClass 
	^self new 
		type: (Array 
				with: #definesInstVar
				with: aClass
				with: aString)
		block: [aClass definesInstanceVariable: aString]
		errorString: aClass printString 
				, ' <1?:does not >define<1?s:> instance variable ' , aString
!

definesSelector: aSelector in: aClass
        (aSelector isNil or:[aClass isNil]) ifTrue:[^ self empty].

        ^self new
                type: (Array with: #definesSelector with: aClass with: aSelector)
                block: [aClass directlyDefinesMethod: aSelector]
                errorString: aClass printString , ' <1?:does not >define<1?s:> ' , aSelector printString
!

definesTempVar: aString in: aClass ignoreClass: subclass 
	| condition |
	condition := self new.
	condition 
		type: (Array with: #definesTempVarIgnoring with: aClass with: aString with: subclass)
		block: 
			[| method |
			method := self 
						methodDefiningTemporary: aString
						in: aClass
						ignore: [:class :aSelector | class includesClass: subclass].
			method notNil 
				ifTrue: 
					[condition errorMacro: method printString , ' defines variable ' , aString].
			method notNil]
		errorString: aClass printString 
				, ' <1?:does not >define<1?s:> temporary variable ' , aString.
	^condition
!

definesTemporaryVariable: aString in: aClass 
	| condition |
	condition := self new.
	condition 
		type: (Array with: #definesTempVar with: aClass with: aString)
		block: 
			[| method |
			method := self 
						methodDefiningTemporary: aString
						in: aClass
						ignore: [:class :selector | false].
			method notNil 
				ifTrue: 
					[condition errorMacro: method printString , ' defines variable ' , aString].
			method notNil]
		errorString: aClass printString 
				, ' <1?:does not >define<1?s:> temporary variable ' , aString.
	^condition
!

directlyDefinesClassVariable: aString in: aClass 
	^self new 
		type: (Array with: #directlyDefinesClassVar with: aClass with: aString)
		block: [aClass directlyDefinesClassVariable: aString]
		errorString: aClass printString 
				, ' <1?:does not >directly define<1?s:> class variable ' , aString
!

directlyDefinesInstanceVariable: aString in: aClass 
	^self new 
		type: (Array with: #directlyDefinesInstanceVariable with: aClass with: aString)
		block: [aClass directlyDefinesInstanceVariable: aString]
		errorString: aClass printString 
				, ' <1?:does not >directly define<1?s:> instance variable ' , aString
!

empty
	"Returns an empty condition"

	^self new 
		type: (Array with: #empty)
		block: [true]
		errorString: 'Empty'
!

hasSubclasses: aClass
	^self new
		type: (Array with: #hasSubclasses with: aClass)
		block: [aClass subclasses isEmpty not]
		errorString: aClass printString , ' has <1?:no >subclasses'
!

hasSuperclass: aClass 
	^self new 
		type: (Array with: #hasSuperclass with: aClass)
		block: [aClass superclass isNil not]
		errorString: aClass printString , ' has <1?a:no> superclass'
!

hierarchyOf: aClass canUnderstand: aSelector
        ^self new
                type: (Array with: #hierarchyUnderstandsSelector with: aClass with: aSelector)
                block: [ aClass hierarchyDefinesMethod: aSelector ]
                errorString: (aClass printString allBold
                              , ' <1?or a subclass:and all subclasses do not> understand<1?s:> ' 
                              , aSelector printString allBold)
!

hierarchyOf: aClass definesVar: aString
        ^self new
                type: (Array with: #hierarchyDefinesInstVar with: aClass with: aString)
                block: [self allSubtreeVarsIn: aClass includes: aString]
                errorString: aClass name printString , ' or one of its subclasses <1?:does not >define<1?s:> instance variable ' , aString
!

hierarchyOf: aClass definesVariable: aString 
	^self new 
		type: (Array 
				with: #hierarchyDefinesInstVar
				with: aClass
				with: aString)
		block: [aClass hierarchyDefinesVariable: aString]
		errorString: aClass printString 
				, ' or one of its subclasses <1?:does not >define<1?s:> variable ' 
					, aString
!

hierarchyOf: aClass referencesInstVar: aString
        ^self new
                type: (Array with: #hierarchyReferencesInstVar with: aClass with: aString)
                block: [aClass withAllSubclasses contains: [:each | (each whichSelectorsAccess: aString) notEmpty]]
                errorString: aClass printString , ' or subclass <1?:does not >reference<1?s:> instance variable ' , aString

    "Modified: / 13-09-2006 / 11:41:11 / cg"
!

hierarchyOf: aClass referencesInstanceVariable: aString 
	^self new 
		type: (Array 
				with: #hierarchyReferencesInstVar
				with: aClass
				with: aString)
		block: 
			[(aClass withAllSubclasses 
				detect: [:each | (each whichSelectorsReferToInstanceVariable: aString) isEmpty not]
				ifNone: [nil]) notNil]
		errorString: aClass printString 
				, ' or subclass <1?:does not >reference<1?s:> instance variable ' , aString
!

isAbstractClass: aClass 
	^self new 
		type: (Array with: #IsAbstractClass with: aClass)
		block: [aClass isAbstract]
		errorString: aClass printString , ' is <1?:not >an abstract class'
!

isClass: anObject
	^self new
		type: (Array with: #IsClass with: anObject)
		block: [anObject isBehavior]
		errorString: anObject printString , ' is <1?:not >a behavior'
!

isEmptyClass: anObject 
        ^self new type: (Array with: #IsEmptyClass with: anObject)
                block: 
                        [anObject classVariableNames isEmpty
                                and: [anObject instanceVariableNames isEmpty and: [anObject selectors isEmpty]]]
                errorString: anObject printString , ' is <1?:not >empty'
!

isGlobal: aString
	^self new
		type: (Array with: #isGlobal with: aString)
		block: [Smalltalk includesKey: aString asSymbol]
		errorString: aString , ' is <1?:not >a class or global variable'
!

isGlobal: aString in: aRBSmalltalk 
	^self new 
		type: (Array with: #isGlobal with: aString)
		block: [aRBSmalltalk includesGlobal: aString asSymbol]
		errorString: aString , ' is <1?:not >a class or global variable'
!

isImmediateSubclass: subclass of: superClass
	^self new
		type: (Array with: #immediateSubclass with: superClass with: subclass)
		block: [subclass superclass = superClass]
		errorString: subclass printString , ' is <1?:not >an immediate subclass of ' , superClass printString
!

isMetaclass: anObject 
	^self new type: (Array with: #IsMetaclass with: anObject)
		block: [anObject isMeta]
		errorString: anObject printString , ' is <1?:not >a metaclass'
!

isSelector: sel1 equalTo: sel2
        ^self new
                type: (Array with: #isSelector with: sel1 with:#sameAs with:sel2)
                block: [ sel1 == sel2 ]
                errorString: sel1 , ' is <1?:not > equal to ' , sel2
!

isSymbol: aString
	^self new
		type: (Array with: #isSymbol with: aString)
		block: [aString isSymbol]
		errorString: aString , ' is <1?:not >a symbol'
!

isValidClassName: aString
	^self new
		type: (Array with: #validClassName with: aString)
		block: [self validClassName: aString]
		errorString: aString , ' is <1?:not >a valid class name'
!

isValidClassVarName: aString for: aClass
	^self new
		type: (Array with: #validClassVarName with: aString with: aClass)
		block: [self checkClassVarName: aString in: aClass]
		errorString: aString , ' is <1?:not >a valid class variable name'
!

isValidInstVarName: aString for: aClass
    <resource: #obsolete>
    self obsoleteMethodWarning.
    ^ self isValidInstanceVariableName: aString for: aClass

    "Modified: / 06-08-2012 / 11:19:09 / cg"
!

isValidInstanceVariableName: aString for: aClass 
        ^self new 
                type: (Array 
                                with: #validInstVarName
                                with: aString
                                with: aClass)
                block: [self checkInstanceVariableName: aString in: aClass]
                errorString: '"',aString, '" is <1?:not >a valid instance variable name'

    "Modified: / 06-08-2012 / 11:13:52 / cg"
!

isValidMethodName: aString for: aClass
	^self new
		type: (Array with: #validMethodName with: aString with: aClass)
		block: [self checkMethodName: aString in: aClass]
		errorString: aString printString , ' is <1?:not >a valid method name'
!

isValidTemporaryVariableName: aString for: aClass 
        ^self new 
                type: (Array 
                                with: #validTemporaryVarName
                                with: aString
                                with: aClass)
                block: [self checkTemporaryVariableName: aString in: aClass]
                errorString: '"',aString, '" is <1?:not >a valid temporary variable name'

    "Created: / 06-08-2012 / 11:17:16 / cg"
!

referencesInstVar: aString in: aClass 
	^self new
		type: (Array with: #referencesInstVar with: aClass with: aString)
		block: [(aClass whichSelectorsAccess: aString) isEmpty not]
		errorString: aClass printString , ' <1?:does not >reference<1?s:> instance variable ' , aString
!

referencesInstanceVariable: aString in: aClass 
	^self new 
		type: (Array with: #referencesInstVar with: aClass with: aString)
		block: [(aClass whichSelectorsReferToInstanceVariable: aString) isEmpty not]
		errorString: aClass printString 
				, ' <1?:does not >reference<1?s:> instance variable ' , aString
!

subclassesOf: aClass referToSelector: aSelector 
	^self new 
		type: (Array 
				with: #subclassReferences
				with: aClass
				with: aSelector)
		block: 
			[(aClass subclasses detect: 
					[:each | 
					(each selectors detect: 
							[:sel | 
							| tree |
							tree := each parseTreeFor: sel.
							tree notNil and: [tree superMessages includes: aSelector]]
						ifNone: [nil]) notNil]
				ifNone: [nil]) notNil]
		errorString: '<1?:no:a> subclass of ' , aClass printString , ' refers to ' 
				, aSelector printString
!

withBlock: aBlock
	^self new withBlock: aBlock
!

withBlock: aBlock errorString: aString 
        ^self new 
            type: #unknown
            block: aBlock
            errorString: aString
! !

!RBCondition class methodsFor:'utilities'!

allSubtreeVarsIn: aClass includes: aVarName
	"Returns true if aVarName is already defined in the hierarchy."

	(aClass allInstVarNames includes: aVarName)
		ifTrue: [^true].
	((aClass allClassVarNames collect: [:each | each asString])
		includes: aVarName)
		ifTrue: [^true].
	aClass
		allSubclassesDo:
			[:class |
			(class instVarNames includes: aVarName)
				ifTrue: [^true].
			((class classVarNames collect: [:each | each asString])
				includes: aVarName)
				ifTrue: [^true]].
	^false
!

checkClassVarName: aName in: aClass 
        | string |
        aName isString ifFalse: [^false].
        string := aName asString.
        (self reservedNames includes: string) ifTrue: [^false].
        string isEmpty ifTrue: [^false].
        string isUppercaseFirst ifFalse: [
            "/ RBParser isSmalltalkX ifFalse:[^ false].
            RefactoringWarning raiseSignal:'Warning: class-varNames should start with an uppercase letter'.
        ].
        ^RBScanner isVariable: string

    "Modified: / 06-08-2012 / 11:21:22 / cg"
!

checkInstVarName: aName in: aClass
    <resource: #obsolete>
    self obsoleteMethodWarning.
    ^ self checkInstanceVariableName:aName in:aClass

    "Modified: / 06-08-2012 / 11:20:59 / cg"
!

checkInstanceVariableName: aName in: aClass 
        | string |
        aName isString ifFalse: [^false].
        string := aName asString.
        string isEmpty ifTrue: [^false].
        (self reservedNames includes: string) ifTrue: [^false].
        string isUppercaseFirst ifTrue: [
            "/ RBParser isSmalltalkX ifFalse:[^ false].
            aClass isMeta ifFalse:[
                ^ false
            ].
            RefactoringWarning raiseSignal:'Warning: class-instVarNames should start with a lowercase letter'.
        ].
        ^RBScanner isVariable: string

    "Modified (format): / 06-08-2012 / 11:21:32 / cg"
!

checkMethodName: aName in: aClass 
	^aName isString and: [RBScanner isSelector: aName]
!

checkSubclassResponsibilityFor: aClass 
        | matcher |
        matcher := ParseTreeSearcher new.
        matcher 
                matchesAnyMethodOf: 
                        #('`@keywords: `@args self subclassResponsibility' 
                        '`@keywords: `@args ^self subclassResponsibility' 
                        '`@keywords: `@args super subclassResponsibility' 
                        '`@keywords: `@args ^super subclassResponsibility')
                do: [:aNode :answer | true].
        matcher answer: false.
        ^((aClass whichSelectorsReferTo: #'subclassResponsibility') 
                detect: 
                        [:each | 
                        | parseTree |
                        parseTree := aClass parseTreeFor: each.
                        parseTree notNil and: [matcher executeTree: parseTree]]
                ifNone: [nil]) notNil
!

checkTemporaryVariableName: aName in: aClass 
        | string |
        aName isString ifFalse: [^false].
        string := aName asString.
        string isEmpty ifTrue: [^false].
        (self reservedNames includes: string) ifTrue: [^false].
        string isUppercaseFirst ifTrue: [
            "/ RBParser isSmalltalkX ifFalse:[^ false].
            RefactoringWarning raiseSignal:'Warning: local names should start with a lowercase letter'.
        ].
        ^RBScanner isVariable: string

    "Created: / 06-08-2012 / 11:17:06 / cg"
!

isAbstract: aClass 
	| assoc |
	aClass isMeta ifTrue: [^false].
	assoc := Smalltalk associationAt: aClass name ifAbsent: [^false].
	(self checkSubclassResponsibilityFor: aClass) ifTrue: [^true].
	Smalltalk allBehaviorsDo: 
			[:each | 
			(each whichSelectorsReferTo: assoc) isEmpty ifFalse: [^false].
			(each whichSelectorsReferTo: aClass name) isEmpty ifFalse: [^false]].
	^true
!

methodDefiningTemporary: aString in: aClass ignore: aBlock 
	| searcher method |
	searcher := ParseTreeSearcher new.
	method := nil.	"Shut-up the warning"
	searcher matches: aString do: [:aNode :answer | ^method].
	aClass withAllSubclasses do: 
			[:class | 
			class selectors do: 
					[:each | 
					(aBlock value: class value: each) 
						ifFalse: 
							[| parseTree |
							method := class methodFor: each.
							parseTree := class parseTreeFor: each.
							parseTree notNil ifTrue: [searcher executeTree: parseTree]]]].
	^nil
!

reservedNames
	^#('self' 'true' 'false' 'nil' 'thisContext' 'super')
!

validClassName: aString 
	"Class names and class variable names have the same restrictions"

	^self checkClassVarName: aString in: self
! !

!RBCondition methodsFor:'accessing'!

errorBlockFor: aBoolean
	^errorBlock
! !

!RBCondition methodsFor:'checking'!

check
	^block value
!

check:errAction
        block value ifTrue:[ ^ true ].
        errAction value:self.
        ^ false
! !

!RBCondition methodsFor:'initialize-release'!

errorBlock: anObject
	errorBlock := anObject
!

type: aSymbol block: aBlock errorString: aString 
	type := aSymbol.
	block := aBlock.
	self errorMacro: aString
!

withBlock: aBlock 
	block := aBlock.
	type := #(#generic)
! !

!RBCondition methodsFor:'printing'!

printOn: aStream 
    type == #unknown ifTrue:[
        block notNil ifTrue:[
            block method notNil ifTrue:[
                '[' printOn: aStream.
                block method whoString printOn: aStream.
                ']' printOn: aStream.
                ^ self.
            ]
        ].
    ].
    type isArray ifTrue:[
        '(' printOn: aStream.
        type 
            do:[:each | each printOn:aStream]
            separatedBy:[aStream space].
        ')' printOn: aStream.
        ^ self.
    ].

    type printOn: aStream
! !

!RBCondition class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

