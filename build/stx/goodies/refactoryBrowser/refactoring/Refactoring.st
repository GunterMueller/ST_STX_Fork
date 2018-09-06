"{ Package: 'stx:goodies/refactoryBrowser/refactoring' }"

Object subclass:#Refactoring
	instanceVariableNames:'model options'
	classVariableNames:'RefactoringOptions'
	poolDictionaries:''
	category:'Refactory-Refactorings'
!


!Refactoring class methodsFor:'instance creation'!

new
	^(super new)
		initialize;
		yourself
! !

!Refactoring class methodsFor:'accessing'!

initializeRefactoringOptions
        "self initializeRefactoringOptions"

        RefactoringOptions := IdentityDictionary new.
        RefactoringOptions
                at: #implementorToInline
                        put: 
                                [:ref :imps | |sel|

                                sel := ref inlineSelector.
                                Smalltalk isSmalltalkX ifTrue:[
                                    Dialog 
                                        choose:(self classResources stringWithCRs:'Which implementation of\    %1\should be inlined ?' with:sel storeString allBold)
                                        fromList:imps
                                        values: imps
                                        lines:5 
                                        cancel: [AbortSignal raise]
                                ] ifFalse:[
                                    BrowserApplicationModel basicNew 
                                            choose: ('Which implementation of\    ' , sel storeString allBold, '\should be inlined ?\') withCRs
                                            fromList: imps
                                            values: imps
                                            lines: 5
                                            cancel: [AbortSignal raise]
                                ]];
                at: #methodName
                        put: 
                                [:ref :methodName | 
                                | dialog nm |
                                MethodNameDialog isNil ifTrue:[
                                    nm := Dialog request:'Name of Method'.
                                    nm isEmptyOrNil ifTrue:[ nil ] ifFalse:[ methodName selector:nm. methodName]
                                ] ifFalse:[
                                    dialog := MethodNameDialog for: methodName.
                                    dialog browseButtonsVisibleHolder value:false.
                                    dialog open ifTrue: [methodName] ifFalse: [nil]
                                ]];
                at: #selfArgumentName
                        put: 
                                [:ref | 
                                Dialog
                                        request: 'Enter name for argument to refer to "self" in extracted method'
                                        onCancel:[AbortSignal raise]];
                at: #selectVariableToMoveTo
                        put: 
                                [:ref :class :selector | 
                                | parseTree nameList ignoreList |
                                parseTree := class parseTreeFor: selector.
                                parseTree isNil 
                                        ifTrue: 
                                                [parseTree := RBMethodNode selector: #value
                                                                        body: (RBSequenceNode statements: #())].
                                ignoreList := OrderedCollection new.
                                nameList := OrderedCollection new.
                                nameList add: '---- Arguments ----'.
                                ignoreList add:nameList size.
                                nameList addAll: parseTree argumentNames asSortedCollection.
                                nameList add: '---- Instance Variables ----'.
                                ignoreList add: nameList size.
                                nameList addAll: class allInstanceVariableNames asSortedCollection.
"/                                nameList add: '---- Class Variables ----'.
"/                                ignoreList add: nameList size.
"/                                nameList addAll: class allClassVariableNames asSortedCollection.

                                BrowserApplicationModel basicNew 
                                        choose: 'Select variable to move method into:'
                                        fromList: nameList
                                        values: nameList
                                        ignore: ignoreList
                                        initialSelection: nil
                                        lines: 8
                                        cancel: [AbortSignal raise]];
                at: #variableTypes
                        put: 
                                [:ref :types :selected | 
                                VariableTypeDialog 
                                        chooseClassesFromList: types
                                        initialSelections: selected
                                        model: ref model
                                        cancel: [AbortSignal raise]];
                at: #extractAssignment
                        put: 
                                [:ref :varName | 
                                Dialog
                                        confirmWithCancel: ('Do you want to extract the assignment of <1s><n>at the end of selection?' 
                                                        expandMacrosWith: varName allBold)
                                        default:false
                                        onCancel:[AbortSignal raise]];
                at: #extractEvenWithOtherAssignmentsTo
                        put: 
                                [:ref :varName | 
                                Dialog
                                        confirm: ('"<1s>" is assigned/used outside of the extracted code.\Extract anyway (possibly non-isomorph refactoring) ?' 
                                                        expandMacrosWith: varName allBold) withCRs
                                        noLabel:(Dialog classResources string:'Cancel') "onCancel:[AbortSignal raise]"];
                at: #extractMultiple
                        put: 
                                [:ref | 
                                Dialog
                                        confirmWithCancel: ('Do you want to replace the other occurrence(s) of this pattern in this method also?')
                                        default:true onCancel:[AbortSignal raise]];
                at: #extractAll
                        put: 
                                [:ref | 
                                Dialog
                                        confirmWithCancel: ('Do you want to replace the other occurrence(s) of this pattern everywhere in the class?')
                                        default:true onCancel:[AbortSignal raise]];
                at: #inlineExpression
                        put: 
                                [:ref :string | 
                                Dialog
                                        confirmWithCancel: ('Do you want to inline "<1s>"? If not, it will be assigned as a temporary.' 
                                                        expandMacrosWith: string)
                                        onCancel:[AbortSignal raise]];
                at: #alreadyDefined
                        put: 
                                [:ref :class :selector | 
                                Dialog
                                        confirmWithCancel: ('<1s> is already defined in the <2p> hierarchy.<n>Extracting it to an existing selector may change behavior.<n>Do you wish to use <1s> anyway?' 
                                                        expandMacrosWith: selector
                                                        with: class)
                                        onCancel:[AbortSignal raise]];
                at: #useExistingMethod
                        put: 
                                [:ref :selector | 
                                Dialog
                                        confirmWithCancel: 'Use existing method ' , selector allBold , ' instead of creating new method?' 
                                        default:true
                                        onCancel:[AbortSignal raise]];
                at: #openBrowser put: [:ref :env | env openEditor]

    "Modified: / 13-02-2012 / 13:01:53 / cg"
!

refactoringOptions
	RefactoringOptions isNil ifTrue: [self initializeRefactoringOptions].
	^RefactoringOptions
!

setDefaultOption: aSymbol to: aBlock 
	self refactoringOptions at: aSymbol put: aBlock
! !

!Refactoring class methodsFor:'accessing signal'!

preconditionErrorSignal
	^RefactoringError
!

preconditionSignal
	^RefactoringError , RefactoringWarning
! !

!Refactoring class methodsFor:'class initialization'!

initialize
	"Refactoring initialize"

	RefactoringWarning autoload.
	RefactoringError autoload.

" -- old code --
	PreconditionWarningSignal := (Signal genericSignal newSignal) notifierString: 'Refactoring Warning -';
				nameClass: self message: #preconditionWarningSignal;
				yourself.
	PreconditionErrorSignal := (PreconditionWarningSignal newSignal) notifierString: 'Refactoring Error -';
				nameClass: self message: #preconditionErrorSignal;
				yourself
"
! !

!Refactoring methodsFor:'accessing'!

changes
	^self model changes
!

copyOptionsFrom: aDictionary 
	| dict |
	dict := self options.
	dict == self class refactoringOptions 
		ifTrue: [^self options: aDictionary copy].
	dict keysAndValuesDo: 
			[:key :value | 
			value == (self class refactoringOptions at: key) 
				ifTrue: [dict at: key put: (aDictionary at: key)]].
	self options: dict
!

options
	^options isNil ifTrue: [self class refactoringOptions] ifFalse: [options]
!

options: aDictionary 
	options := aDictionary
!

setOption: aSymbol toUse: aBlock 
	| dict |
	dict := self options.
	dict == self class refactoringOptions ifTrue: [dict := dict copy].
	dict at: aSymbol put: aBlock.
	self options: dict
! !

!Refactoring methodsFor:'initialize-release'!

initialize
!

model: aRBNamespace 
	model := aRBNamespace
! !

!Refactoring methodsFor:'performing'!

preconditions
	self subclassResponsibility
!

reparentClasses: behaviorCollection to: newClass 
	behaviorCollection do: 
			[:aClass | 
			Object subclassDefinerClass 
				evaluate: (self replaceClassNameIn: aClass definition to: newClass name)
				notifying: nil
				logged: true]
!

replaceClassNameIn: definitionString to: aSymbol 
	| parseTree |
	parseTree := RBParser parseExpression: definitionString.
	parseTree receiver: (RBVariableNode named: aSymbol).
	^parseTree formattedCode
!

undo
	^self error: 'Not implemented yet'
! !

!Refactoring methodsFor:'preconditions'!

checkPreconditions
        | conditions |

        conditions := self preconditions.

        " raise directly from the failed condition - allows for proceedable checks "
        conditions check:[:badCondition | self refactoringErrorFor:badCondition].

"/        | conditions block errorString |
"/        conditions check 
"/            ifFalse:[ 
"/                errorString := conditions errorString.
"/                block := conditions errorBlock.
"/                block notNil 
"/                        ifTrue: [self refactoringError: errorString with: block]
"/                        ifFalse: [self refactoringError: errorString]]
! !

!Refactoring methodsFor:'printing'!

changeString
    ^ self printString
! !

!Refactoring methodsFor:'private'!

classObjectFor: anObject 
	anObject isBehavior ifTrue: [^self model classFor: anObject].
	anObject isSymbol ifTrue: [^self model classNamed: anObject].
	^anObject
!

onError: aBlock do: errorBlock 
	^aBlock on: self class preconditionSignal
		do: 
			[:ex | 
			errorBlock value.
			ex return: nil]
!

primitiveExecute
	self checkPreconditions.
	self transform
!

refactoringError: aString 
	RefactoringError raiseSignal: aString
!

refactoringError: aString with: aBlock 
	RefactoringError raiseSignal: aString with: aBlock
!

refactoringErrorFor: failedCondition 
        | errorString block |

        errorString := failedCondition errorString.
        block := failedCondition errorBlock.

        RefactoringError raiseSignal:errorString with:block isResumable:failedCondition mayProceed.
!

refactoringWarning: aString 
	RefactoringWarning raiseSignal: aString
!

refactoringWarning: aString with:aParameter
	RefactoringWarning raiseRequestWith:aParameter errorString: aString
!

uniqueMethodNameFor: anInteger 
	| before after index name |
	before := 'a'.
	after := ''.
	anInteger timesRepeat: [after := after , 'z:'].
	index := 0.
        
	[name := before , index printString , after.
	(Symbol findInterned: name) notNil] 
			whileTrue: [index := index + 1].
	^name asSymbol
!

variableNamesFor: aClass 
	| variableNames |
	variableNames := aClass allInstVarNames asSet.
	variableNames
		addAll: (aClass allClassVarNames collect: [:each | each asString]).
	^variableNames
!

writeLogFor: aClass 
	((Smalltalk respondsTo:#isSmalltalkX) and:[Smalltalk isSmalltalkX]) ifTrue:[
	    " nothing needed ... "
	] ifFalse:[
	    SourceFileManager default logChange: aClass definition
	]

    "Modified: / 4.2.2000 / 18:46:28 / cg"
! !

!Refactoring methodsFor:'queries'!

shouldBeConfirmed
    "Return true, if the refactoring change should be confirmed
     before applying. Used to suppress confirming *trivial* changes
     but only iff `UserPreferences current confirmRefactorings` is true.

     CAUTION: If UserPreferences current confirmRefactorings is false,
              refactorings are *never* confirmed
    "
    ^true

    "Created: / 26-08-2013 / 12:04:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Refactoring methodsFor:'requests'!

openBrowserOn: anEnvironment 
	^(self options at: #openBrowser) value: self value: anEnvironment
!

requestExtractAll
	^(self options at: #extractAll) value: self
!

requestExtractMultiple
	^(self options at: #extractMultiple) value: self
!

requestImplementorToInline: implementorsCollection 
	^(self options at: #implementorToInline) value: self
		value: implementorsCollection
!

requestMethodNameFor: aMethodName 
	^(self options at: #methodName) value: self value: aMethodName
!

requestSelfArgumentName
	^(self options at: #selfArgumentName) value: self
!

selectVariableToMoveMethodTo: aSelector class: aClass 
	^(self options at: #selectVariableToMoveTo) 
		value: self
		value: aClass
		value: aSelector
!

selectVariableTypesFrom: initialTypeCollection selected: selectedTypeCollection 
	^(self options at: #variableTypes) 
		value: self
		value: initialTypeCollection
		value: selectedTypeCollection
!

shouldExtractAssignmentTo: aString 
	^(self options at: #extractAssignment) value: self value: aString
!

shouldExtractEvenWithOtherAssignmentsTo: varName 
    Smalltalk isSmalltalkX ifFalse:[
        self refactoringError: 'Cannot extract assignments to temporaries without all references (' , varName ,')'.
        ^ false.        
    ].

    ^(self options at: #extractEvenWithOtherAssignmentsTo) value: self value: varName
!

shouldInlineExpression: aString 
	^(self options at: #inlineExpression) value: self value: aString
!

shouldOverride: aSelector in: aClass 
	^(self options at: #alreadyDefined) 
		value: self
		value: aClass
		value: aSelector
!

shouldUseExistingMethod: aSelector 
	^(self options at: #useExistingMethod) value: self value: aSelector
! !

!Refactoring methodsFor:'support'!

checkClass: aRBClass selector: aSelector using: aMatcher 
	| parseTree |
	parseTree := aRBClass parseTreeFor: aSelector.
	parseTree notNil ifTrue: [aMatcher executeTree: parseTree].
	^aMatcher answer
!

convertAllClassesSelect: aBlock using: searchReplacer notifying: changeBuilder 
	"Perform a search and replace all classes using the tree matcher, searchReplacer.
	Search only the selectors that aBlock returns for a given class. Write the changes to the
	changeBuilder."

	Smalltalk allBehaviorsDo: 
			[:aClass | 
			(aBlock value: aClass) do: 
					[:selector | 
					self convertMethod: selector
						for: aClass
						using: searchReplacer
						notifying: changeBuilder]]
!

convertAllReferencesTo: aSymbol using: searchReplacer 
	self model allReferencesTo: aSymbol
		do: 
			[:method | 
			self 
				convertMethod: method selector
				for: method modelClass
				using: searchReplacer]
!

convertAllReferencesToClass: aRBClass using: searchReplacer 
	self model allReferencesToClass: aRBClass
		do: 
			[:method | 
			self 
				convertMethod: method selector
				for: method modelClass
				using: searchReplacer]
!

convertClasses: classSet select: aBlock using: searchReplacer 
	classSet do: 
			[:aClass | 
			(aBlock value: aClass) do: 
					[:selector | 
					self 
						convertMethod: selector
						for: aClass
						using: searchReplacer]]
!

convertClasses: classSet select: aBlock using: searchReplacer notifying: changeBuilder
	"Perform a search and replace on the classes, classSet, using the tree matcher, searchReplacer.
	Search only the selectors that aBlock returns for a given class. Write the changes to the
	changeBuilder."

	classSet do: [:aClass | (aBlock value: aClass)
			do: [:selector | "Convert each method"
				self
					convertMethod: selector
					for: aClass
					using: searchReplacer
					notifying: changeBuilder]]
!

convertClasses: classSet select: aBlock using: searchReplacer notifying: changeBuilder message: aString
        "Perform a search and replace on the classes, classSet, using the tree matcher, searchReplacer.
        Search only the selectors that aBlock returns for a given class. Write the changes to the
        changeBuilder. Display aString in a percent done box updating it after each class has been searched."

        | tally count controller model |
        model := 0 asValue.
        tally := classSet inject: 0 into: [:val :each | val + (aBlock value: each) size].
        count := 0.0.

        "First open the percent done window"
        controller := ProgressWidgetView progressOpenOn: model label: aString.

        [model value: 0.
        classSet do: [:aClass | (aBlock value: aClass)
                        do:
                                [:selector |

                                "Convert each method, and then update the percent done window."
                                self
                                        convertMethod: selector
                                        for: aClass
                                        using: searchReplacer
                                        notifying: changeBuilder.

                                count := count + 1.
                                model value: count / tally]]]

                ensure: [

                        "All done, just need to close the window now"
                        controller closeAndUnschedule]
!

convertMethod: selector for: aClass using: searchReplacer 
	"Convert the parse tree for selector using the searchReplacer. If a
	change is made then compile it into the changeBuilder."

	| parseTree oldSource newSource|
	parseTree := aClass parseTreeFor: selector.
	parseTree isNil ifTrue: [^self].

	(searchReplacer executeTree: parseTree) 
		ifTrue: [
		    searchReplacer isRewritingOriginalSource ifTrue:[
			oldSource := aClass sourceCodeFor:selector.
			newSource := searchReplacer executeReplacementsInSource:oldSource.
			searchReplacer forgetReplacements.
			aClass compileTree: searchReplacer tree usingSource:newSource.
		    ] ifFalse:[
			aClass compileTree: searchReplacer tree
		    ]
		]
!

convertMethod: selector for: aClass using: searchReplacer notifying: changeBuilder 
	"Convert the parse tree for selector using the searchReplacer. If a
	change is made then compile it into the changeBuilder."

	| parseTree newSource cat |
	parseTree := aClass parseTreeFor: selector.
	parseTree isNil ifTrue: [^self].
	(searchReplacer executeTree: parseTree) ifTrue:[
	    (searchReplacer isRewritingOriginalSource) ifTrue:[
		newSource := searchReplacer executeReplacementsInSource:(aClass compiledMethodAt:selector) source.
		searchReplacer forgetReplacements.
	    ] ifFalse:[
		newSource := searchReplacer tree printString.
	    ].
	    ((Smalltalk respondsTo:#isSmalltalkX) and:[Smalltalk isSmalltalkX]) ifTrue:[
		cat := (aClass realClass compiledMethodAt:selector) category
	    ] ifFalse:[
		cat := aClass whichCategoryIncludesSelector: selector.
	    ].
	    changeBuilder compile: newSource
				in: aClass
				classified: cat
	]
!

usesAssignmentOf: varName in: aClass classVariable: isClassVar 
	| matcher literal definingClass |
	matcher := ParseTreeSearcher new.
	matcher
		answer: false;
		matches: varName , ' := ``@object'
			do: [:aNode :answer | answer or: [aNode isUsed]].
	isClassVar 
		ifTrue: 
			[literal := self 
						associationForClassVariable: varName
						in: aClass
						ifAbsent: [self refactoringError: 'Could not find class variable name']].
	definingClass := isClassVar 
				ifTrue: 
					[aClass isMeta ifTrue: [aClass soleInstance] ifFalse: [aClass]]
				ifFalse: [aClass].
	^(definingClass withAllSubclasses 
		, (isClassVar ifTrue: [definingClass class withAllSubclasses] ifFalse: [#()]) 
			detect: 
				[:each | 
				((isClassVar 
					ifTrue: [each whichSelectorsReferTo: literal]
					ifFalse: [each whichSelectorsWrite: varName]) detect: 
							[:sel | 
							self 
								checkClass: each
								selector: sel
								using: matcher]
						ifNone: [nil]) notNil]
			ifNone: [nil]) notNil
! !

!Refactoring methodsFor:'testing'!

canReferenceVariable: aString in: aClass 
	(aClass definesVariable: aString) ifTrue: [^true].
	(self model includesGlobal: aString asSymbol) ifTrue: [^true].
	^(self poolVariableNamesFor: aClass) includes: aString
!

includesSelector: aSelector in: aClass 
	"Returns a boolean indicating whether or not the complete method-scope of 
	this class (all sub and superclasses) defines a method named 
	aSymbol."

	(aClass canUnderstand: aSelector) ifTrue: [^true].
	^(aClass allSubclasses detect: [:each | each includesSelector: aSelector]
		ifNone: [nil]) notNil
!

isAbstract: aClass 
	^RBCondition isAbstract: aClass
!

isRefactoryChange
    ^ false
!

subclassOf: aClass redefines: aSelector 
	"Return true, if one of your subclasses redefines the method with name, aMethod"

	aClass
		allSubclassesDo: [:each | (each includesSelector: aSelector) ifTrue: [^true]].
	^false
! !

!Refactoring methodsFor:'transforming'!

defaultEnvironment
	^BrowserEnvironment new
!

execute
        self primitiveExecute.

        self model changes name:self changeString.
        Smalltalk isSmalltalkX ifTrue:[
            Parser parseErrorSignal handle:[:ex |
                self refactoringError:('Error during compilation:\\' , ex description) withCRs.
                AbortSignal raise.
            ] do:[
                RefactoringManager instance addRefactoring: self
            ]
        ] ifFalse:[
            RefactoringManager instance addRefactoring: self
        ]
!

model
        model isNil 
                ifTrue: 
                        [model := (RBNamespace onEnvironment: self defaultEnvironment)
                                                name: self printString;
                                                yourself].
        ^model
!

performComponentRefactoring: aRefactoring 
	aRefactoring copyOptionsFrom: self options.
	aRefactoring primitiveExecute
!

transform
	self subclassResponsibility
! !

!Refactoring methodsFor:'utilities'!

allImplementorsOf: aSelector 
    "Answer a collection of all the classes that implement the message aSelector."

    | aCollection |

    aCollection := OrderedCollection new.
    Cursor wait showWhile: [
        Smalltalk allBehaviorsDo:[:class | 
            (class includesSelector: aSelector) ifTrue: [
                aCollection add: class
            ]
        ]
    ].
    ^aCollection

    "Modified: / 07-05-2010 / 10:56:50 / cg"
!

allSubtreeVarsIn: aClass includes: aVarName 
	^RBCondition allSubtreeVarsIn: aClass includes: aVarName
!

associationForClassVariable: aName in: aClass ifAbsent: aBlock 
	^aClass realClass classPool associationAt: aName asSymbol
		ifAbsent: [aClass realClass classPool associationAt: aName asString ifAbsent: aBlock]
!

checkInstVarName: aName in: aClass 
	^RBCondition checkInstVarName: aName in: aClass
!

checkInstanceVariableName: aName in: aClass 
	^RBCondition checkInstanceVariableName: aName in: aClass
!

checkMethodName: aName in: aClass 
	^RBCondition checkMethodName: aName in: aClass
!

confirm: aString
        "open a modal yes-no dialog."

        ^Dialog confirm: aString
!

poolVariableNamesFor: aClass 
	| pools |
	pools := Set new.
	aClass withAllSuperclasses do: 
			[:each | 
			each allPoolDictionaryNames do: 
					[:pool | 
					pools addAll: ((Smalltalk at: pool asSymbol) keys 
								collect: [:name | name asString])]].
	^pools
!

request: aString
	^Dialog request: aString
!

safeMethodNameFor: aClass basedOn: aString 
	"Creates an unused method name containing aString"

	| baseString newString hasParam i |
	baseString := aString copy.
	baseString at: 1 put: baseString first asLowercase.
	newString := baseString.
	hasParam := newString last = $:.
	hasParam 
		ifTrue: [baseString := newString copyFrom: 1 to: newString size - 1].
	i := 0.
	[aClass hierarchyDefinesMethod: newString asSymbol] whileTrue: 
			[i := i + 1.
			newString := baseString , i printString 
						, (hasParam ifTrue: [':'] ifFalse: [''])].
	^newString asSymbol
!

whichClass: aClass defines: anInstVarName 
	| currentClass |
	currentClass := aClass.
	[currentClass isNil] whileFalse: 
			[(currentClass instVarNames includes: anInstVarName) ifTrue: [^currentClass].
			currentClass := currentClass superclass].
	^nil
!

whichClass: aClass definesClassVariable: aClassVarName 
	| currentClass classVarString |
	classVarString := aClassVarName asString.
	currentClass := aClass.
	[currentClass isNil] whileFalse: 
			[((currentClass classVarNames collect: [:each | each asString])
				includes: classVarString) ifTrue: [^currentClass].
			currentClass := currentClass superclass].
	^nil
!

whichVariableNode: aParseTree inInterval: anInterval name: aName 
	| matcher block |
	matcher := ParseTreeSearcher new.
	block := 
			[:aNode :answer | 
			(aNode intersectsInterval: anInterval) ifTrue: [aNode] ifFalse: [answer]].
	matcher
		matches: aName do: block;
		matchesArgument: aName do: block.
	^matcher executeTree: aParseTree initialAnswer: nil
! !

!Refactoring class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/refactoring/Refactoring.st,v 1.45 2013-08-26 11:23:22 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/refactoring/Refactoring.st,v 1.45 2013-08-26 11:23:22 vrany Exp $'
! !


Refactoring initialize!
