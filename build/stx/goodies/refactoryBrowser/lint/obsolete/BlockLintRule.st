"{ Package: 'stx:goodies/refactoryBrowser/lint' }"

BasicLintRule subclass:#BlockLintRule
	instanceVariableNames:'classBlock methodBlock'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint'
!


!BlockLintRule class methodsFor:'bugs'!

overridesSpecialMessage
        | detector |
        detector := self new.
        detector name: 'Overrides a "special" message'.
        detector resultClass: ClassEnvironment.
        detector classBlock: 
                        [:context :result | 
                        ((context selectedClass isMeta
                                ifTrue: [self metaclassShouldNotOverride]
                                ifFalse: [self classShouldNotOverride]) detect: 
                                                [:each | 
                                                context selectedClass superclass notNil and: 
                                                                [(context selectedClass superclass canUnderstand: each)
                                                                        and: [context selectedClass includesSelector: each]]]
                                        ifNone: [nil]) notNil ifTrue: [result addClass: context selectedClass]].
        ^detector
!

sentNotImplemented
        | detector |
        detector := self new.
        detector name: 'Messages sent but not implemented'.
        detector methodBlock: 
                        [:context :result | 
                        | message |
                        message := context messages detect: [:each | (context implements: each) not]
                                                ifNone: [nil].
                        message isNil ifTrue: 
                                        [message := context superMessages detect: 
                                                                        [:each | 
                                                                        context selectedClass superclass isNil
                                                                                or: [(context selectedClass superclass canUnderstand: each) not]]
                                                                ifNone: [nil].
                                        message isNil ifTrue: 
                                                        [message := context selfMessages
                                                                                detect: [:each | (context selectedClass canUnderstand: each) not]
                                                                                ifNone: [nil]]].
                        message notNil ifTrue: 
                                        [result addSearchString: message.
                                        result addClass: context selectedClass selector: context selector]].
        ^detector
!

subclassResponsibilityNotDefined
        | detector subclassResponsibilitySymbol |
        detector := self new.
        detector name: 'Subclass responsibility not defined'.
        subclassResponsibilitySymbol := 'subclassResponsibility' asSymbol.
        detector classBlock: 
                        [:context :result | 
                        (context selectedClass whichSelectorsReferTo: subclassResponsibilitySymbol)
                                do: 
                                        [:each | 
                                        (context selectedClass withAllSubclasses detect: 
                                                        [:class | 
                                                        class subclasses isEmpty
                                                                and: [(class whichClassIncludesSelector: each) == context selectedClass]]
                                                ifNone: [nil]) notNil
                                                ifTrue: [result addClass: context selectedClass selector: each]]].
        ^detector
!

undeclaredReference
        | detector |
        detector := self new.
        detector name: 'References an undeclared variable'.
        detector methodBlock: 
                        [:context :result | 
                        | undeclared |
                        ((Smalltalk respondsTo:#isSmalltalkX) and:[Smalltalk isSmalltalkX]) ifTrue:[
                            " need alternative way to detect undeclared ... "
                        ] ifFalse:[
                            undeclared := Undeclared associations detect: 
                                                            [:each | 
                                                            (context uses: each)
                                                                    and: [context compiledMethod refersToLiteral: each]]
                                                    ifNone: [nil].
                        ].
                        undeclared notNil ifTrue: 
                                        [result addSearchString: undeclared key.
                                        result addClass: context selectedClass selector: context selector]].
        ^detector

    "Modified: / 26.9.2001 / 21:10:51 / cg"
!

usesTrue
        | detector trueBinding falseBinding |
        detector := self new.
        trueBinding := Smalltalk associationAt: #True.
        falseBinding := Smalltalk associationAt: #False.
        detector name: 'Uses True/False instead of true/false'.
        detector methodBlock: 
                        [:context :result | 
                        | method |
                        method := context compiledMethod.
                        ((method refersToLiteral: trueBinding)
                                or: [method refersToLiteral: falseBinding]) ifTrue: 
                                                [result addClass: context selectedClass selector: context selector.
                                                result searchStrings: #('True' 'False')]].
        ^detector
!

variableNotDefined
        | detector |
        detector := self new.
        detector name: 'Variable used, but not defined anywhere'.
        detector methodBlock: 
                        [:context :result | 
                        context compiledMethod withAllBlockMethodsDo: 
                                        [:each | 
                                        each literalsDo: 
                                                        [:lit | 
                                                        lit isVariableBinding ifTrue: 
                                                                        [((Smalltalk associationAt: lit key ifAbsent: [nil]) == lit
                                                                                or: [(Undeclared associationAt: lit key ifAbsent: [nil]) == lit])
                                                                                ifFalse: 
                                                                                        [(context selectedClass fullBindingFor: lit key) == lit ifFalse: 
                                                                                                        [result addClass: context selectedClass selector: context selector.
                                                                                                        result addSearchString: lit key]]]]]].
        ^detector
! !

!BlockLintRule class methodsFor:'intention revealing'!

missingSubclassResponsibility
        | detector |
        detector := self new.
        detector
                name: 'Method defined in all subclasses, but not in superclass';
                resultClass: MultiEnvironment;
                openUsing: #openWithoutFilters.
        detector classBlock: 
                        [:context :result | 
                        | subs |
                        subs := context selectedClass subclasses.
                        subs size > 1 & context selectedClass isMeta not 
                                ifTrue: 
                                        [| sels |
                                        sels := Bag new.
                                        subs do: [:each | sels addAll: each selectors].
                                        sels asSet do: 
                                                        [:each | 
                                                        ((sels occurrencesOf: each) == subs size 
                                                                and: [(context selectedClass canUnderstand: each) not]) 
                                                                        ifTrue: 
                                                                                [| envName |
                                                                                envName := context selectedClass name , '>>' , each.
                                                                                subs do: 
                                                                                                [:subClass | 
                                                                                                result 
                                                                                                        addClass: subClass
                                                                                                        selector: each
                                                                                                        into: envName]]]]].
        ^detector
! !

!BlockLintRule class methodsFor:'miscellaneous'!

badMessage
        | detector badMessages |
        detector := self new.
        detector name: 'Sends "questionable" message'.
        badMessages := self badSelectors.
        detector classBlock: 
                        [:context :result | 
                        | selectors |
                        selectors := badMessages inject: Set new
                                                into: 
                                                        [:set :each | 
                                                        set addAll: (context selectedClass whichSelectorsReferTo: each);
                                                                yourself].
                        selectors do: [:each | result addClass: context selectedClass selector: each].
                        selectors isEmpty ifFalse: [result searchStrings: badMessages]].
        ^detector
!

classNameInSelector
        | detector |
        detector := self new.
        detector name: 'Redundant class name in selector'.
        detector methodBlock: 
                        [:context :result | 
                        (context selectedClass isMeta and: 
                                        [(context selector
                                                indexOfSubCollection: context selectedClass soleInstance name
                                                startingAt: 1) > 0])
                                ifTrue: [result addClass: context selectedClass selector: context selector]].
        ^detector
!

fullBlocks
        | detector |
        detector := self new.
        detector name: 'Method with full blocks'.
        detector methodBlock: 
                        [:context :result | 
                        context compiledMethod withAllBlockMethodsDo: 
                                        [:method |
                                        ((Smalltalk respondsTo:#isSmalltalkX) and:[Smalltalk isSmalltalkX])
                                        ifFalse:[
                                            method needsHybridFrame
                                                    ifTrue: [result addClass: context selectedClass selector: context selector]
                                        ]
                                        ]].
        ^detector

    "Modified: / 26.9.2001 / 21:13:44 / cg"
!

instVarInSubclasses
        | detector |
        detector := self new.
        detector
                name: 'Instance variables defined in all subclasses';
                resultClass: VariableEnvironment;
                openUsing: #openWithoutFilters.
        detector classBlock: 
                        [:context :result | 
                        | subs |
                        subs := context selectedClass subclasses.
                        subs size > 1 
                                ifTrue: 
                                        [| sels |
                                        sels := Bag new.
                                        subs do: [:each | sels addAll: each instVarNames].
                                        sels asSet do: 
                                                        [:val | 
                                                        | count |
                                                        count := sels occurrencesOf: val.
                                                        count == subs size 
                                                                ifTrue: [result addClass: context selectedClass instanceVariable: val]]]].
        ^detector
!

longMethods
        | detector matcher |
        detector := self new.
        detector name: 'Long methods'.
        matcher := ParseTreeSearcher new.
        matcher matches: '`.Stmt'
                do: 
                        [:aNode :answer | 
                        (aNode children inject: answer
                                into: [:sum :each | matcher executeTree: each initialAnswer: sum]) + 1].
        detector methodBlock: 
                        [:context :result | 
                        (matcher executeTree: context parseTree initialAnswer: 0) 
                                >= self longMethodSize 
                                        ifTrue: [result addClass: context selectedClass selector: context selector]].
        ^detector
!

refersToClass
        | detector |
        detector := self new.
        detector name: 'Refers to class name instead of "self class"'.
        detector classBlock: 
                        [:context :result | 
                        | sels className |
                        className := (context selectedClass isMeta
                                                ifTrue: [context selectedClass soleInstance]
                                                ifFalse: [context selectedClass]) name.
                        sels := context selectedClass
                                                whichSelectorsReferTo: (Smalltalk associationAt: className).
                        sels do: [:each | result addClass: context selectedClass selector: each].
                        sels isEmpty ifFalse: [result addSearchString: className]].
        ^detector
!

utilityMethods
        | detector |
        detector := self new.
        detector name: 'Utility methods'.
        detector methodBlock: 
                        [:context :result | 
                        (context selectedClass isMeta | (context selector numArgs == 0) or: 
                                        [(context protocols detect: 
                                                        [:each | 
                                                        (self utilityProtocols detect: [:protocol | protocol match: each]
                                                                ifNone: [nil]) notNil]
                                                ifNone: [nil]) notNil]) 
                                ifFalse: 
                                        [(self subclassOf: context selectedClass overrides: context selector) 
                                                ifFalse: 
                                                        [(context superMessages isEmpty and: [context selfMessages isEmpty]) 
                                                                ifTrue: 
                                                                        [(context selectedClass allInstVarNames 
                                                                                , context selectedClass allClassVarNames asArray , #('self') 
                                                                                detect: [:each | context parseTree references: each]
                                                                                ifNone: [nil]) isNil 
                                                                                ifTrue: [result addClass: context selectedClass selector: context selector]]]]].
        ^detector
!

variableAssignedLiteral
        | detector |
        detector := self new.
        detector
                name: 'Variable is only assigned a single literal value';
                resultClass: VariableEnvironment;
                openUsing: #openWithoutFilters.
        detector classBlock: 
                        [:context :result | 
                        | allSubclasses |
                        allSubclasses := context selectedClass withAllSubclasses.
                        context selectedClass instVarNames do: 
                                        [:each | 
                                        | defClass selector |
                                        (allSubclasses inject: 0
                                                into: 
                                                        [:sum :class | 
                                                        | sels |
                                                        sels := class whichSelectorsAssign: each.
                                                        sels size == 1 
                                                                ifTrue: 
                                                                        [selector := sels asArray first.
                                                                        defClass := class].
                                                        sum + sels size]) 
                                                        == 1 
                                                        ifTrue: 
                                                                [| tree searcher |
                                                                searcher := ParseTreeSearcher new.
                                                                searcher matches: each , ' := ``@object'
                                                                        do: [:aNode :answer | answer isNil and: [aNode value isLiteral]].
                                                                tree := defClass parseTreeFor: selector.
                                                                tree notNil 
                                                                        ifTrue: 
                                                                                [(searcher executeTree: tree initialAnswer: nil) == true 
                                                                                        ifTrue: [result addClass: context selectedClass instanceVariable: each]]]]].
        ^detector
! !

!BlockLintRule class methodsFor:'possible bugs'!

abstractClass
        | detector subclassResponsibilitySymbol |
        detector := self new.
        detector name: 'References an abstract class'.
        detector resultClass: ClassEnvironment.
        subclassResponsibilitySymbol := 'subclassResponsibility' asSymbol.
        detector classBlock: 
                        [:context :result | 
                        (context selectedClass whichSelectorsReferTo: subclassResponsibilitySymbol)
                                isEmpty ifFalse: 
                                                [(context
                                                        uses: (Smalltalk associationAt: context selectedClass name ifAbsent: [nil]))
                                                                ifTrue: [result addClass: context selectedClass]]].
        ^detector
!

addRemoveDependents
        | detector |
        detector := self new.
        detector resultClass: ClassEnvironment.
        detector name: 'Number of addDependent: messages > removeDependent:'.
        detector classBlock: 
                        [:context :result | 
                        | count |
                        count := 0.
                        ((Set
                                withAll: (context selectedClass whichSelectorsReferTo: #addDependent:))
                                        addAll: (context selectedClass whichSelectorsReferTo: #removeDependent:);
                                yourself) do: 
                                        [:sel | 
                                        (context selectedClass compiledMethodAt: sel) messagesDo: 
                                                        [:each | 
                                                        each == #addDependent: ifTrue: [count := count + 1].
                                                        each == #removeDependent: ifTrue: [count := count - 1]]].
                        count > 0 ifTrue: [result addClass: context selectedClass]].
        ^detector
!

classInstVarNotInitialized
        | detector |
        detector := self new.
        detector name: 'Has class instance variables but no initialize method'.
        detector resultClass: ClassEnvironment.
        detector classBlock: 
                [:context :result | 
                | definesVar class |
                context selectedClass isMeta
                        ifTrue: 
                                [class := context selectedClass.
                                definesVar := false.
                                [definesVar or: [class isNil or: [class isMeta not]]]
                                        whileFalse: 
                                                [definesVar := class instVarNames isEmpty not.
                                                class := class superclass].
                                (definesVar and: [(context selectedClass includesSelector: #initialize) not])
                                        ifTrue: [result addClass: context selectedClass]]].
        ^detector
!

collectionCopyEmpty
        | detector |
        detector := self new.
        detector
                name: 'Subclass of collection that has instance variable but doesn''t define copyEmpty'.
        detector resultClass: ClassEnvironment.
        detector classBlock: 
                        [:context :result | 
                        (context selectedClass isVariable 
                                        and: [(context selectedClass includesSelector: #copyEmpty:) not 
                                                and: [context selectedClass instVarNames isEmpty not
                                                        and: [context selectedClass inheritsFrom: Collection]]])
                                ifTrue: [result addClass: context selectedClass]].
        ^detector
!

definesEqualNotHash
	| detector |
	detector := self new.
	detector name: 'Defines = but not hash'.
	detector rationale: 'If objects of a class redefine equality, then to work properly in hashed collections like Sets or Dictionaries they must also have a hash method that returns equal hashes for each pair of objects for which = returns true.'.
	detector resultClass: ClassEnvironment.
	detector classBlock: 
			[:context :result | 
			((context selectedClass includesSelector: #=)
				and: [(context selectedClass includesSelector: #hash) not])
				ifTrue: [result addClass: context selectedClass]].
	^detector
!

literalArrayContainsComma
        | detector |
        detector := self new.
        detector name: 'Literal array contains a #,'.
        detector methodBlock: 
                        [:context :result | 
                        (context compiledMethod allLiterals inject: false
                                into: [:sum :each | sum or: [self doesLiteralArrayContainComma: each]]) 
                                        ifTrue: [result addClass: context selectedClass selector: context selector]].
        ^detector
!

returnsBooleanAndOther
        | detector matcher |
        detector := self new.
        detector name: 'Returns a boolean and non boolean'.
        matcher := ParseTreeSearcher new.
        matcher matches: '^``@xObject'
                do: 
                        [:aNode :answer | 
                        answer
                                add: aNode value;
                                yourself].
        detector methodBlock: 
                        [:context :result | 
                        | hasBool hasSelf |
                        hasBool := false.
                        hasSelf := context parseTree lastIsReturn not.
                        (matcher executeTree: context parseTree initialAnswer: Set new) do: 
                                        [:each | 
                                        hasBool := hasBool or: 
                                                                        [(each isLiteral and: [#(true false) includes: each value]) 
                                                                                or: [each isMessage and: [#(#and: #or:) includes: each selector]]].
                                        hasSelf := hasSelf or: 
                                                                        [(each isVariable and: [each name = 'self']) 
                                                                                or: [each isLiteral and: [(#(true false) includes: each value) not]]]].
                        hasSelf & hasBool 
                                ifTrue: [result addClass: context selectedClass selector: context selector]].
        ^detector
!

sendsDifferentSuper
        | detector |
        detector := self new.
        detector name: 'Sends different super message'.
        detector methodBlock: 
                        [:context :result | 
                        | message |
                        (message := context superMessages detect: [:each | each ~= context selector]
                                                ifNone: [nil]) notNil ifTrue: 
                                        [result addSearchString: message.
                                        result addClass: context selectedClass selector: context selector]].
        ^detector
!

superSends
	| detector definer superMethod |
	detector := self new.
	detector name: 'Missing super sends in selected methods.'.
	detector methodBlock: 
			[:context :result | 
			(context selectedClass isMeta not
				and: [ self superMessages includes: context selector ]) ifTrue: [
					definer := context selectedClass superclass ifNotNilDo: [ :sc | sc whichClassIncludesSelector: context selector ].
					definer ifNotNil: [ "super defines same method"
						(context superMessages includes: context selector) ifFalse: [ "but I don't call it"
							superMethod := (definer compiledMethodAt: context selector ifAbsent: []).
							(superMethod isReturnSelf or: [ superMethod sendsSelector: #subclassResponsibility ])
										ifFalse: [result addClass: context selectedClass selector: context selector] ]]]].
	^detector
!

superSendsNew
	| detector matcher |
	detector := self new.
	detector name: 'Sends super new initialize'.
	matcher := ParseTreeSearcher new.
	matcher matchesAnyOf: #('super new initialize' '(super new: `@expr) initialize' 'self new initialize' '(self new: `@expr) initialize')
		do: [ :aNode :answer | answer + 1 ].
	detector methodBlock: [:context :result |
		context selectedClass isMeta ifTrue: [
			(matcher executeTree: context parseTree initialAnswer: 0) > 0 ifTrue: [ result addClass: context selectedClass selector: context selector]]].
	^detector
!

superSends_V1
        | detector |
        detector := self new.
        detector name: 'Missing super sends'.
        detector methodBlock: 
                        [:context :result | 
                        (context selectedClass isMeta not
                                and: [self superMessages includes: context selector]) ifTrue: 
                                                [(context selectedClass superclass notNil
                                                        and: [context selectedClass superclass canUnderstand: context selector])
                                                                ifTrue: 
                                                                        [(context superMessages includes: context selector)
                                                                                ifFalse: [result addClass: context selectedClass selector: context selector]]]].
        ^detector
!

tempVarOverridesInstVar
        | detector matcher vars varName |
        detector := self new.
        detector name: 'Instance variable overridden by temporary variable'.
        matcher := (ParseTreeSearcher new)
                                matchesArgument: '`xxxvar'
                                        do: 
                                                [:aNode :answer | 
                                                answer or: 
                                                                [varName := aNode name.
                                                                vars includes: varName]];
                                yourself.
        detector methodBlock: 
                        [:context :result | 
                        vars := context instVarNames.
                        (matcher executeTree: context parseTree initialAnswer: false) 
                                ifTrue: 
                                        [result addClass: context selectedClass selector: context selector.
                                        result addSearchString: varName]].
        ^detector
!

tempsReadBeforeWritten
        | detector |
        detector := self new.
        detector name: 'Temporaries read before written'.
        detector methodBlock: 
                        [:context :result | 
                        (RBReadBeforeWrittenTester variablesReadBeforeWrittenIn: context parseTree) 
                                do: 
                                        [:each | 
                                        result addClass: context selectedClass selector: context selector.
                                        result addSearchString: each]].
        ^detector
! !

!BlockLintRule class methodsFor:'private'!

badSelectors
        ^#(#become: #isKindOf: #changeClassToThatOf: #respondsTo: #isMemberOf: #performMethod: #performMethod:arguments: #performMethod:with: #performMethod:with:with: #performMethod:with:with:with: #allOwners #allOwnersWeakly: #firstOwner #instVarAt: #instVarAt:put: #nextInstance #nextObject #ownerAfter: #primBecome:  #halt)
!

classShouldNotOverride
        ^#(#== #class)
!

doesLiteralArrayContainComma: aLiteral 
        aLiteral class == Array ifFalse: [^false].
        (aLiteral includes: #,) ifTrue: [^true].
        ^aLiteral inject: false
                into: [:sum :each | sum or: [self doesLiteralArrayContainComma: each]]
!

literalTrueFalseOrNilSymbolsIn: aLiteral 
	| retval |
	aLiteral class == Array ifFalse: [^#()].
	retval := OrderedCollection withAll: (aLiteral select: [:ea | ea isSymbol and: [#(#true #false #nil ) includes: ea]]).
	aLiteral do: [ :each | retval addAll: (self literalTrueFalseOrNilSymbolsIn: each) ].
	^retval.
!

longMethodSize
        ^10
!

metaclassShouldNotOverride
        ^#(#name #comment)
!

subclassOf: aClass overrides: aSelector 
        ^(aClass subclasses detect: 
                        [:each | 
                        (each includesSelector: aSelector)
                                or: [self subclassOf: each overrides: aSelector]]
                ifNone: [nil]) notNil
!

superMessages
        ^#(#release #postCopy #postBuildWith: #preBuildWith: #postOpenWith: #noticeOfWindowClose: #initialize)
!

utilityProtocols
        "If a method is defined in one of these protocols, then don't check if its a utility method."

        ^#('*utilit*')
! !

!BlockLintRule class methodsFor:'squeak bugs'!

methodHasNoTimeStamp
	| detector |
	detector := self new.
	detector name: 'Method has no timeStamp'.
	detector rationale: 'For proper versioning, every method should have a timestamp.'.
	detector methodBlock: 
			[:context :result | 
			context compiledMethod timeStamp isEmpty
					ifTrue: [result addClass: context selectedClass selector: context selector]].
	^detector
!

methodSourceContainsLinefeeds
	| detector |
	detector := self new.
	detector name: 'Method source contains linefeeds'.
	detector rationale: 'Squeak code should not contain linefeed characters.'.
	detector methodBlock: 
			[:context :result | 
			(context sourceCode includes: Character lf)
					ifTrue: [result addClass: context selectedClass selector: context selector]].
	^detector
! !

!BlockLintRule class methodsFor:'unnecessary code'!

classNotReferenced
        | detector |
        detector := self new.
        detector name: 'Class not referenced'.
        detector resultClass: ClassEnvironment.
        detector classBlock: 
                        [:context :result | 
                        (context selectedClass isMeta
                                or: [context selectedClass subclasses isEmpty not])
                                        ifFalse: 
                                                [| assoc |
                                                assoc := Smalltalk associationAt: context selectedClass name.
                                                ((context uses: assoc) or: [context uses: context selectedClass name])
                                                        ifFalse: 
                                                                [result addClass: context selectedClass;
                                                                        addClass: context selectedClass class]]].
        ^detector
!

equivalentSuperclassMethods
    |detector|
    detector := self new.
    detector name:'Methods equivalently defined in superclass'.
    detector methodBlock:[:context :result | 
            |superclass selector|

            superclass := context selectedClass superclass.
            selector := context selector.
            (superclass notNil 
                and:[(#(copyright documentation) includes:selector) not                
                and:[(superclass canUnderstand:selector) 
                and:[(((superclass whichClassIncludesSelector:selector) compiledMethodAt:selector) 
                      equivalentTo:context compiledMethod) 
                ]]] 
            ) ifTrue:[
                result addClass:context selectedClass selector:selector
            ]
    ].
    ^ detector
!

implementedNotSent
        | detector |
        detector := self new.
        detector name: 'Methods implemented but not sent'.
        detector methodBlock: 
                        [:context :result | 
                        (context uses: context selector)
                                ifFalse: [result addClass: context selectedClass selector: context selector]].
        ^detector
!

justSendsSuper
        | detector matcher |
        detector := self new.
        detector name: 'Method just sends super message'.
        matcher := ParseTreeSearcher justSendsSuper.
        detector methodBlock: 
                        [:context :result | 
                        (context parseTree isPrimitive not 
                                and: [matcher executeMethod: context parseTree initialAnswer: false]) 
                                        ifTrue: [result addClass: context selectedClass selector: context selector]].
        ^detector
!

onlyReadOrWritten
        | detector |
        detector := self new.
        detector
                name: 'Instance variables not read AND written';
                resultClass: VariableEnvironment;
                openUsing: #openWithoutFilters.
        detector classBlock: 
                        [:context :result | 
                        | allSubclasses |
                        allSubclasses := context selectedClass withAllSubclasses.
                        context selectedClass instVarNames do: 
                                        [:each | 
                                        | isRead isWritten |
                                        isRead := false.
                                        isWritten := false.
                                        allSubclasses detect: 
                                                        [:class | 
                                                        isRead ifFalse: [isRead := (class whichSelectorsRead: each) isEmpty not].
                                                        isWritten 
                                                                ifFalse: [isWritten := (class whichSelectorsAssign: each) isEmpty not].
                                                        isRead & isWritten]
                                                ifNone: [result addClass: context selectedClass instanceVariable: each]]].
        ^detector
!

unreferencedVariables
        | detector |
        detector := self new.
        detector
                name: 'Variables not referenced';
                resultClass: VariableEnvironment;
                openUsing: #openWithoutFilters.
        detector classBlock: 
                        [:context :result | 
                        | allSubclasses |
                        allSubclasses := context selectedClass withAllSubclasses.
                        context selectedClass instVarNames do: 
                                        [:each | 
                                        allSubclasses 
                                                detect: [:class | (class whichSelectorsAccess: each) isEmpty not]
                                                ifNone: [result addClass: context selectedClass instanceVariable: each]].
                        context selectedClass isMeta 
                                ifFalse: 
                                        [context selectedClass classPool associationsDo: 
                                                        [:each | 
                                                        (context uses: each) 
                                                                ifFalse: [result addClass: context selectedClass classVariable: each key]]]].
        ^detector
!

variableReferencedOnce
        | detector |
        detector := self new.
        detector 
                name: 'Variable referenced in only one method and always assigned first'.
        detector classBlock: 
                        [:context :result | 
                        | allSubclasses |
                        allSubclasses := context selectedClass withAllSubclasses.
                        context selectedClass instVarNames do: 
                                        [:each | 
                                        | defClass selector |
                                        (allSubclasses inject: 0
                                                into: 
                                                        [:sum :class | 
                                                        | sels |
                                                        sels := class whichSelectorsAccess: each.
                                                        sels size == 1 
                                                                ifTrue: 
                                                                        [selector := sels asArray first.
                                                                        defClass := class].
                                                        sum + sels size]) 
                                                        == 1 
                                                        ifTrue: 
                                                                [| tree |
                                                                tree := defClass parseTreeFor: selector.
                                                                tree notNil 
                                                                        ifTrue: 
                                                                                [(RBReadBeforeWrittenTester isVariable: each writtenBeforeReadIn: tree) 
                                                                                        ifTrue: 
                                                                                                [result addClass: defClass selector: selector.
                                                                                                result addSearchString: each]]]]].
        ^detector
! !

!BlockLintRule methodsFor:'accessing'!

checkClass: aSmalllintContext 
        ^classBlock value: aSmalllintContext value: result
!

checkMethod: aSmalllintContext 
        ^methodBlock value: aSmalllintContext value: result
! !

!BlockLintRule methodsFor:'initialize-release'!

classBlock: aBlock
        classBlock := aBlock
!

initialize
        super initialize.
        classBlock := [:context :aResult | ].
        methodBlock := [:context :aResult | ]
!

methodBlock: aBlock
        methodBlock := aBlock
! !

!BlockLintRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !
