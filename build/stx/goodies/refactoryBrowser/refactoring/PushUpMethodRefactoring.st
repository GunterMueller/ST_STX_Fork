"{ Package: 'stx:goodies/refactoryBrowser/refactoring' }"

"{ NameSpace: Smalltalk }"

MethodRefactoring subclass:#PushUpMethodRefactoring
	instanceVariableNames:'removeDuplicates selectors'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Refactorings'
!


!PushUpMethodRefactoring class methodsFor:'instance creation'!

model: aRBSmalltalk pushUp: selectorCollection from: aClass 
	^(self new)
		model: aRBSmalltalk;
		pushUp: selectorCollection from: aClass;
		yourself
!

pushUp: selectorCollection from: aClass 
	^self new pushUp: selectorCollection from: aClass
! !

!PushUpMethodRefactoring methodsFor:'initialize-release'!

pushUp: selectorCollection from: aClass 
	class := self classObjectFor: aClass.
	selectors := selectorCollection.
	removeDuplicates := false
! !

!PushUpMethodRefactoring methodsFor:'performing'!

checkClassVars
	selectors do: [:each | self checkClassVarsFor: each]
!

checkInstVars
	selectors do: [:each | self checkInstVarsFor: each]
!

copyDownMethod: aSelector using: builder 
	| oldProtocol oldSource superclassDefiner subclasses |
	superclassDefiner := class superclass whichClassIncludesSelector: aSelector.
	superclassDefiner isNil ifTrue: [^self].
	oldSource := superclassDefiner sourceCodeAt: aSelector.
	oldSource isNil ifTrue: 
			[self refactoringError: ('Source code for <1s> superclass method not available'
						expandMacrosWith: aSelector)].
	oldProtocol := superclassDefiner whichCategoryIncludesSelector: aSelector.
	subclasses := class superclass subclasses
				reject: [:each | each includesSelector: aSelector].
	subclasses isEmpty ifTrue: [^self].
	((superclassDefiner compiledMethodAt: aSelector) superMessages
		detect: [:each | superclassDefiner includesSelector: each]
		ifNone: [nil]) notNil ifTrue: 
			[self refactoringError: ('Cannot push up <1s> since we must copy down the superclass method in <2p><n>to the other subclasses, and the superclass method sends a super message which is overriden.'
						expandMacrosWith: aSelector
						with: superclassDefiner)].
	self refactoringWarning: 'Do you want to copy down the superclass method to the classes that don''t define '
				, aSelector.
	subclasses do: 
			[:each | 
			builder compile: oldSource
				in: each
				classified: oldProtocol]
!

copyDownMethodsUsing: builder 
	selectors do: [:each | self copyDownMethod: each using: builder]
!

pushUp: aSelector using: builder 
	| method source |
	method := class compiledMethodAt: aSelector.
	source := method getSource.
	source isNil
		ifTrue: [self refactoringError: 'Source for method not available'].
	builder compile: source
		in: class superclass
		classified: (class whichCategoryIncludesSelector: aSelector)
! !

!PushUpMethodRefactoring methodsFor:'preconditions'!

checkBackReferencesTo: aSelector 
        | definingClass pushUpParseTree |
        definingClass := class superclass whoDefinesMethod: aSelector.
        definingClass isNil ifTrue: [^self].
        pushUpParseTree := class parseTreeFor: aSelector.
        class superclass allSubclasses do: 
                        [:each | 
                        each selectors do: 
                                        [:sel | 
                                        | mthd skip parseTree |
                                        skip := false.
                                        mthd := each methodFor:sel.
                                        mthd notNil ifTrue:[
                                            mthd := mthd method.
                                            mthd notNil ifTrue:[
                                                skip := (mthd sendsSelector:aSelector) not
                                            ]
                                        ].
                                        skip ifFalse:[parseTree := each parseTreeFor: sel].
                                        (parseTree notNil and: 
                                                        [(parseTree superMessages includes: aSelector) 
                                                                and: [definingClass == (each whoDefinesMethod: aSelector)]]) 
                                                ifTrue: 
                                                        [removeDuplicates := true.
                                                        (aSelector == sel 
                                                                and: [parseTree equalTo: pushUpParseTree exceptForVariables: #()]) 
                                                                        ifFalse: 
                                                                                [self 
                                                                                        refactoringError: ('Cannot push up <1s> since it would override the method defined in <2p>' 
                                                                                                        expandMacrosWith: aSelector
                                                                                                        with: definingClass)]]]]

    "Modified: / 05-02-2017 / 01:24:52 / cg"
!

checkClassVarsFor: aSelector 
	class nonMetaclass classVariableNames do: 
			[:each | 
			((class whichSelectorsReferToClassVariable: each) includes: aSelector) 
				ifTrue: 
					[self refactoringError: ('<1p> refers to <2s> which is defined in <3p>' 
								expandMacrosWith: aSelector
								with: each
								with: class)]]
!

checkInstVarsFor: aSelector 
        class instanceVariableNames 
            do:[:each | 
                ((class whichSelectorsReferToInstanceVariable: each) includes: aSelector) ifTrue:[ 
                    self
                        refactoringError: ('<1s> refers to variable "<2s>" which is defined in subclass <3p>' 
                                expandMacrosWith: aSelector
                                with: each allBold
                                with: class)]]

    "Modified: / 18-09-2007 / 22:52:42 / cg"
!

checkSiblingSuperSendsFrom: aRBClass 
        aRBClass selectors do: 
            [:each | 
            | tree skip mthd |

            skip := false.
            mthd := aRBClass methodFor:each.
            mthd notNil ifTrue:[
                mthd := mthd method.
                mthd notNil ifTrue:[
                    skip := (selectors contains:[:sel | (mthd sendsSelector:sel)]) not
                ]
            ].
            skip ifFalse:[tree := aRBClass parseTreeFor: each.].

            tree notNil 
                ifTrue: 
                    [tree superMessages do: 
                        [:aSelector | 
                        (selectors includes: aSelector) 
                            ifTrue: 
                                [| definer |
                                definer := aRBClass superclass whoDefinesMethod: aSelector.
                                (definer notNil and: [class includesClass: definer]) 
                                    ifTrue: 
                                        [self 
                                            refactoringError: (
                                                'Cannot push up <1s> since <2p>>><3s> sends a super message to it.' 
                                                    expandMacrosWith: aSelector
                                                    with: aRBClass
                                                    with: each)]]]]].
        aRBClass subclasses "allSubclasses" do: [:each | self checkSiblingSuperSendsFrom: each]

    "Modified: / 05-02-2017 / 01:24:58 / cg"
!

checkSuperMessages
	self checkSuperSendsFromPushedUpMethods.
	self checkSuperSendsFromSiblings
!

checkSuperSendsFromPushedUpMethods
	selectors do: 
			[:each | 
			| parseTree |
			parseTree := class parseTreeFor: each.
			(parseTree superMessages 
				detect: [:sup | class superclass directlyDefinesMethod: sup]
				ifNone: [nil]) notNil 
				ifTrue: 
					[self 
						refactoringError: ('Cannot push up <1s> since it sends a super message that is defined in the superclass.' 
								expandMacrosWith: each)]]
!

checkSuperSendsFromSiblings
	| siblings |
	siblings := class superclass subclasses reject: [:each | each = class].
	siblings do: [:aRBClass | self checkSiblingSuperSendsFrom: aRBClass]
!

checkSuperclass
        | overrideSelectors |
        overrideSelectors := selectors 
                                select: [:each | class superclass directlyDefinesMethod:each].
        overrideSelectors := overrideSelectors reject: 
                                        [:each | 
                                        | myTree superTree |
                                        myTree := class parseTreeFor: each.
                                        superTree := class superclass parseTreeFor: each.
                                        superTree equalTo: myTree exceptForVariables: #()].
        overrideSelectors isEmpty ifTrue: [^self].
        class superclass isAbstract 
                ifFalse: 
                        [self refactoringError: ('Non-abstract class <2p> already defines <1p>' 
                                                expandMacrosWith: overrideSelectors asArray first
                                                with: class superclass)].
        overrideSelectors do: [:each | self checkBackReferencesTo: each]
!

preconditions
        ^(selectors inject: (RBCondition hasSuperclass: class)
                into: [:cond :each | cond & (RBCondition definesSelector: each in: class)]) 
                        & (RBCondition withBlock: 
                                                [self checkInstVars.
                                                self checkClassVars.
                                                self checkSuperclass.
                                                self checkSuperMessages.
                                                true])
! !

!PushUpMethodRefactoring methodsFor:'printing'!

storeOn: aStream 
	aStream nextPut: $(.
	self class storeOn: aStream.
	aStream nextPutAll: ' pushUp: '.
	selectors asArray storeOn: aStream.
	aStream nextPutAll: ' from: '.
	class storeOn: aStream.
	aStream nextPut: $)
! !

!PushUpMethodRefactoring methodsFor:'private'!

copyDownMethod: aSelector 
        | oldProtocol oldSource superclassDefiner subclasses refactoring |
        superclassDefiner := class superclass whoDefinesMethod: aSelector.
        superclassDefiner isNil ifTrue: [^self].
        oldProtocol := superclassDefiner protocolsFor: aSelector.
        subclasses := class superclass subclasses 
                                reject: [:each | each directlyDefinesMethod: aSelector].
        subclasses isEmpty ifTrue: [^self].
        oldSource := superclassDefiner sourceCodeFor: aSelector.
        oldSource isNil 
                ifTrue: 
                        [self 
                                refactoringError: ('Source code for <1s> superclass method not available' 
                                                expandMacrosWith: aSelector)].
        ((superclassDefiner parseTreeFor: aSelector) superMessages 
                contains: [:each | superclassDefiner directlyDefinesMethod: each])  
                ifTrue: 
                        [self 
                                refactoringError: ('Cannot push up <1s> since we must copy down the superclass method in <2p><n>to the other subclasses, and the superclass method sends a super message which is overriden.' 
                                                expandMacrosWith: aSelector
                                                with: superclassDefiner)].
        "/ that is a wuestion - not a warning
        "/ self 
        "/        refactoringWarning: 'Do you want to copy down the superclass method to the classes that don''t define ' 
        "/                        , aSelector.
        self 
                refactoringWarning: 'Copying down the superclass method to the classes that don''t define ' 
                                , aSelector.
        refactoring := ExpandReferencedPoolsRefactoring 
                                model: self model
                                forMethod: (superclassDefiner parseTreeFor: aSelector)
                                fromClass: superclassDefiner
                                toClasses: subclasses.
        self performComponentRefactoring: refactoring.
        subclasses do: [:each | each compile: oldSource classified: oldProtocol]

    "Modified: / 05-02-2017 / 01:11:35 / cg"
! !

!PushUpMethodRefactoring methodsFor:'transforming'!

copyDownMethods
	selectors do: [:each | self copyDownMethod: each]
!

pushUp: aSelector 
	| source refactoring |
	source := class sourceCodeFor: aSelector.
	source isNil 
		ifTrue: [self refactoringError: 'Source for method not available'].
	refactoring := ExpandReferencedPoolsRefactoring 
				model: self model
				forMethod: (class parseTreeFor: aSelector)
				fromClass: class
				toClasses: (Array with: class superclass).
	self performComponentRefactoring: refactoring.
	class superclass compile: source
		classified: (class protocolsFor: aSelector)
!

pushUpMethods
	selectors do: [:each | self pushUp: each]
!

removeDuplicateMethods
	selectors do: [:each | self removeDuplicatesOf: each]
!

removeDuplicatesOf: aSelector 
        | howMany tree |

        tree := class superclass parseTreeFor: aSelector.

        removeDuplicates ifFalse:[
            howMany := 0.
            class superclass allSubclasses do:[:each | 
                ((each directlyDefinesMethod: aSelector) 
                and:[ (tree equalTo: (each parseTreeFor: aSelector) exceptForVariables: #()) 
                and:[ (each superclass whoDefinesMethod: aSelector) == class superclass]]) 
                ifTrue:[
                    howMany := howMany + 1.
                ]
            ].
            howMany > 0 ifTrue:[
                removeDuplicates := true.
                selectors size == 1 ifTrue:[
                    self refactoringWarning:('Do you want to remove %1 other duplicate subclass methods for %2 ?' 
                                            bindWith:howMany
                                            with:aSelector).
                ] ifFalse:[
                    self refactoringWarning:('Do you want to remove the other duplicate subclass methods ?').
                ].
            ].
        ].

        class superclass allSubclasses do:[:each | 
            ((each directlyDefinesMethod: aSelector) 
            and:[ (tree equalTo: (each parseTreeFor: aSelector) exceptForVariables: #()) 
            and:[ (each superclass whoDefinesMethod: aSelector) == class superclass]]) 
            ifTrue:[
                each removeMethod: aSelector
            ]
        ]
!

removePushedUpMethods
	selectors do: [:each | class removeMethod: each]
!

transform
	self
		copyDownMethods;
		pushUpMethods;
		removePushedUpMethods;
		removeDuplicateMethods
! !

!PushUpMethodRefactoring class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

