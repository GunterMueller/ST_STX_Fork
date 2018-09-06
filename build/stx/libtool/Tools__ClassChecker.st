"
 COPYRIGHT (c) 2004 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libtool' }"

"{ NameSpace: Tools }"

Object subclass:#ClassChecker
	instanceVariableNames:'checkedClass badClasses badClassInfo badMethods badMethodInfo
		obsoleteWarners allObsoleteMethods checksPerformed'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Browsers-New'
!

!ClassChecker class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2004 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

documentation
"
    embeddable application displaying the class-categories.
    Provides an outputGenerator, which enumerates the classes in
    the selected categories.

    Attention: do not change the method categories 'checks-' into something else.
    The 'checks-' prefix is used to detect checks and these are listed in the browsers
    lint dialog.

    [author:]
        Claus Gittinger (cg@exept.de)
"
! !

!ClassChecker class methodsFor:'queries'!

individualChecks
    "return a list of supported checks"

    |checks|

    checks := OrderedCollection new.
    self methodDictionary keysAndValuesDo:[:sel :mthd |
	(mthd category startsWith:'checks')  ifTrue:[checks add:sel]
    ].
    checks sort.
    ^ checks

    "
     self individualChecks
    "

    "Created: / 18.8.2000 / 22:30:46 / cg"
    "Modified: / 18.8.2000 / 22:31:02 / cg"
! !

!ClassChecker methodsFor:'accessing'!

badClassInfo
    ^ badClassInfo
!

badMethodInfo
    ^ badMethodInfo
!

checkedClass
    "return the value of the instance variable 'checkedClass' (automatically generated)"

    ^ checkedClass
!

checkedClass:something
    "set the value of the instance variable 'checkedClass' (automatically generated)"

    checkedClass := something.
    checksPerformed := nil.
! !

!ClassChecker methodsFor:'checking'!

allChecks
    self errorChecks.
    self warningChecks.
    self styleChecks.
!

doCheck:whichCheck
    checksPerformed isNil ifTrue:[
	checksPerformed := Set new.
    ].
    (checksPerformed includes:whichCheck) ifFalse:[
	checksPerformed add:whichCheck.
	self perform:whichCheck
    ]
!

errorChecks
    self doCheck:#subclassResponsibilityNotDefined.
    self doCheck:#sentNotImplemented.
    self doCheck:#definesEqualButNotHash.
    self doCheck:#instanceVariablesNeverWritten.
!

styleChecks
    self doCheck:#checkProtocols.
    self doCheck:#sendsObsoleteMethodWarningButNotTaggedAsObsoleteOrViceVersa.
    self doCheck:#unusedInstanceVariables.
    self doCheck:#unusedClassVariables.

"/    self doCheck:#guardingClause.

    "Modified: / 18-05-2010 / 14:38:15 / cg"
!

warningChecks
    self doCheck:#messageNeverSentAndNotUsedAsSymbol.
    self doCheck:#sendsObsoleteMessages.
    self doCheck:#instanceVariablesNeverUsed.
    self doCheck:#instanceVariablesNeverWritten.
    self doCheck:#classVariablesNeverUsed.
    self doCheck:#classVariablesNeverWritten.
    self doCheck:#classInstanceVariablesNeverUsed.
    self doCheck:#classInstanceVariablesNeverWritten.
    self doCheck:#invalidKeyInImageResourceMethod
! !

!ClassChecker methodsFor:'checks-individual'!

checkProtocols
    checkedClass instAndClassSelectorsAndMethodsDo:[:mSelector :method |
	self checkProtocolOf:method
    ]
!

checkVariableNameConventions
    |badInstVars badClassVars|

    badInstVars := checkedClass instanceVariableNames select:[:varName | varName isUppercaseFirst].
    badClassVars := checkedClass classVarNames select:[:varName | varName first isLowercase].

    badInstVars notEmpty ifTrue:[
        badInstVars := (badInstVars collect:[:v | '''' , v , '''']) asStringWith:$, .
        self 
            rememberBadClass:checkedClass
            info:('instVars ' , badInstVars , ' should be lowercase (#checkNameConventions)').
    ].
    badClassVars notEmpty ifTrue:[
        badClassVars := (badClassVars collect:[:v | '''' , v , '''']) asStringWith:$, .
        self 
            rememberBadClass:checkedClass
            info:('classVars ' , badClassVars , ' should be uppercase (#checkNameConventions)').
    ].
!

classInstanceVariablesNeverUsed
    self instanceVariablesNeverUsedIn:checkedClass theMetaclass.
!

classInstanceVariablesNeverWritten
    self instanceVariablesNeverWrittenIn:checkedClass theMetaclass.
!

classVariablesNeverUsed
    |cls notUsedHere notUsedAnyWhere anySubclass|

    cls := checkedClass theNonMetaclass.
    notUsedHere := cls classVarNames asNewSet.
    notUsedHere isEmpty ifTrue:[^ self].

    self removeUsedClassVariablesIn:cls from:notUsedHere.
    self removeUsedClassVariablesIn:cls class from:notUsedHere.

    notUsedHere notEmpty ifTrue:[
        notUsedAnyWhere := notUsedHere copy.
        anySubclass := false.
        cls allSubclassesDo:[:eachSubclass |
            anySubclass := true.
            notUsedAnyWhere notEmpty ifTrue:[
                self removeUsedClassVariablesIn:eachSubclass from:notUsedAnyWhere.
                self removeUsedClassVariablesIn:eachSubclass class from:notUsedAnyWhere.
            ]
        ].

        notUsedHere do:[:eachVariable |
            |className|

            className := checkedClass name allBold.
            self 
                rememberBadClass:cls
                info:('classVar ' , eachVariable allBold , ' is unused in ' , className , ' (#classVariablesNeverUsed)').
            (notUsedAnyWhere includes:eachVariable) ifTrue:[
                self 
                    rememberBadClass:cls
                    info:('classVar ' , eachVariable allBold , ' is not even used in subclasses of ' , className , ' (#classVariablesNeverUsed)')
            ]
        ].
    ]
!

classVariablesNeverWritten
    |cls notWrittenHere notWrittenAnyWhere anySubclass|

    cls := checkedClass theNonMetaclass.
    notWrittenHere := cls classVarNames asNewSet.
    notWrittenHere isEmpty ifTrue:[^ self].

    self removeWrittenClassVariablesIn:cls from:notWrittenHere.
    self removeWrittenClassVariablesIn:cls class from:notWrittenHere.

    notWrittenHere notEmpty ifTrue:[
        notWrittenAnyWhere := notWrittenHere copy.
        anySubclass := false.
        cls allSubclassesDo:[:eachSubclass |
            anySubclass := true.
            notWrittenAnyWhere notEmpty ifTrue:[
                self removeWrittenClassVariablesIn:eachSubclass from:notWrittenAnyWhere.
                self removeWrittenClassVariablesIn:eachSubclass class from:notWrittenAnyWhere.
            ]
        ].

        notWrittenHere do:[:eachVariable |
            |className|

            className := cls name allBold.
            self 
                rememberBadClass:cls
                info:('classVar ' , eachVariable allBold , ' is not set in ' , className , ' (#classVariablesNeverWritten)').
            (notWrittenAnyWhere includes:eachVariable) ifTrue:[
                self 
                    rememberBadClass:cls
                    info:('classVar ' , eachVariable allBold , ' is not even set in subclasses of ' , className , ' (#classVariablesNeverWritten)')
            ]
        ].
    ]
!

definesEqualButNotHash
    (checkedClass includesSelector:#=) ifTrue:[
	(checkedClass includesSelector:#hash) ifFalse:[
	    self 
		rememberBadClass:checkedClass 
		info:(checkedClass name allBold, ' redefines #=, but not #hash (#definesEqualButNotHash)').
	]
    ]
!

guardingClause
    |detector|

    detector := ParseTreeLintRule guardingClause.
    detector runOnEnvironment: (Array with:checkedClass).
self breakPoint:#cg.
!

instanceVariablesNeverUsed
    self instanceVariablesNeverUsedIn:checkedClass theNonMetaclass.
!

instanceVariablesNeverWritten
    self instanceVariablesNeverWrittenIn:checkedClass theNonMetaclass.
!

invalidKeyInImageResourceMethod
    Icon flushCachedIcons.
    checkedClass instAndClassSelectorsAndMethodsDo:[:sel :mthd | 
        |img key name mclass|

        (mthd hasImageResource) ifTrue:[
           ((mclass := mthd mclass) notNil and:[mclass isMeta]) ifTrue:[
               img := mthd valueWithReceiver:(mclass theNonMetaclass) arguments:#().
               key := (Icon classVarAt:#KnownIcons) keyAtIdentityValue:img.
               key notNil ifTrue:[
                   name := (mclass name , ' ', mthd selector).
                   name ~= key ifTrue:[
                       name := (mclass theNonMetaclass name , ' ', mthd selector).
                       name ~= key ifTrue:[
                           self 
                               rememberBadMethod:mthd 
                               key:#invalidKeyInImageResourceMethod
                               info:('key in constantNamed: does not match the method name')
                       ]
                   ]
               ]
           ]
        ]
    ].
!

messageNeverSent
    "/ old code: (slow)
"/    checkedClass instAndClassSelectorsAndMethodsDo:[:mSelector :method |
"/        (self anySendsOf:mSelector) ifFalse:[
"/            self 
"/                rememberBadMethod:method 
"/                info:('#' , mSelector , ' is nowhere sent (#messageNeverSent)')
"/        ].
"/    ].

    |selectorsOfInterest|

    selectorsOfInterest := IdentitySet new.
    checkedClass instAndClassSelectorsAndMethodsDo:[:mSelector :method |  selectorsOfInterest add:mSelector].
    (self messagesNeverSentIn:selectorsOfInterest) do:[:eachNeverSent |
	self 
	    rememberBadMethod:(checkedClass compiledMethodAt:eachNeverSent) 
	    key:#messageNeverSent
	    info:('#' , eachNeverSent allBold, ' is nowhere sent (#messageNeverSent)')
    ].

    "Modified: / 18.8.2000 / 22:54:45 / cg"
!

messageNeverSentAndNotUsedAsSymbol
    |selectorsOfInterest|

    selectorsOfInterest := IdentitySet new.
    checkedClass instAndClassSelectorsAndMethodsDo:[:mSelector :method |  selectorsOfInterest add:mSelector].
    (self messagesNeverSentAndNotUsedAsSymbolIn:selectorsOfInterest) do:[:eachNeverSent |
	self 
	    rememberBadMethod:(checkedClass compiledMethodAt:eachNeverSent) 
	    key:#messageNeverSentAndNotUsedAsSymbol
	    info:('#' , eachNeverSent allBold, ' is nowhere sent and selector-symbol not used in any method (#messageNeverSentAndNotUsedAsSymbol)')
    ].

    "Modified: / 18.8.2000 / 23:10:56 / cg"
!

parseMethod:method in:aClass withParserDo:aBlock onErrorDo:errorBlock
    |source parser|

    source := method source.
    parser := Parser
                parseMethod:source
                in:aClass
                ignoreErrors:true
                ignoreWarnings:true.

    (parser notNil and:[parser ~~ #Error]) ifTrue:[
        aBlock value:parser
    ] ifFalse:[
        errorBlock value
    ].

    "Created: / 18-05-2010 / 15:17:19 / cg"
!

sendsObsoleteMessages
    obsoleteWarners isNil ifTrue:[
        obsoleteWarners := Object selectors select:[:each | each startsWith:'obsoleteMethodWarning'].
    ].
    allObsoleteMethods isNil ifTrue:[
        allObsoleteMethods := IdentitySet new.
        Method allSubInstancesDo:[:eachMethod | |lits selector|
                ((lits := eachMethod literals) notNil
                and:[lits includesAny:obsoleteWarners]) ifTrue:[
                     (eachMethod messagesSent includesAny:obsoleteWarners) ifTrue:[
                        selector := eachMethod selector.
                        selector notNil ifTrue:[
                            allObsoleteMethods add:selector.
                        ]
                    ].
                ].
            ].

        "/ manually patchup; there are some which should not be considered as bad ...
        allObsoleteMethods removeAllFoundIn:#( #','  #'at:'  #'at:put:'  #'raise').
        allObsoleteMethods removeAllFoundIn:#( #'asText').
        allObsoleteMethods removeAllFoundIn:obsoleteWarners.
    ].

    checkedClass instAndClassSelectorsAndMethodsDo:[:sel :mthd | 
        |lits sentMessages whichOnes pT searcher nodes|

        ((lits := mthd literals) notNil
        and:[lits includesAny:allObsoleteMethods]) ifTrue:[
            sentMessages := mthd messagesSent.
            (sentMessages includesAny:allObsoleteMethods) ifTrue:[
                whichOnes := sentMessages select:[:each | allObsoleteMethods includes:each].

                (RBParser notNil
                and:[RBParser isLoaded]) ifTrue:[
                    "/ lets look at this a bit more detailed;
                    "/ parse it and see if we can filter out any messages 
                    "/ (i.e. look if we can figure out the receiver type)

"/                    pT := RBParser 
"/                            parseMethod: (mthd source)
"/                            onError: [:aString :pos | nil].
"/                    pT notNil ifTrue:[
"/                        searcher := ParseTreeSearcher 
"/                                        allMessageSendsMatchingAny:whichOnes ignoreCase:false.
"/                        nodes := searcher executeTree:pT initialAnswer:(OrderedCollection new).
"/                        nodes := nodes 
"/                            select:
"/                                [:aSendNode |
"/                                    self halt.
"/                                ].
"/                        whichOnes := nodes collect:[:aSendNode | aSendNode selector].
"/                    ].
                ].

                whichOnes asOrderedCollection sort do:[:eachObsoleteMessage |
                    self 
                        rememberBadMethod:mthd 
                        key:#sendsObsoleteMessages
                        info:('possibly sends an obsolete message: ' , eachObsoleteMessage , ' (#sendsObsoleteMessages)')
                ].
            ].
        ]
    ]
!

sendsObsoleteMethodWarningButNotTaggedAsObsoleteOrViceVersa
    |obsoleteWarners|

    obsoleteWarners := #( #'obsoleteMethodWarning' #'obsoleteMethodWarning:' ).

    checkedClass instAndClassSelectorsAndMethodsDo:[:sel :mthd | 
        |lits sentMessages whichOnes pT searcher nodes|

        ((lits := mthd literals) notNil
        and:[lits includesAny:obsoleteWarners]) ifTrue:[
            mthd isObsolete ifFalse:[
                self 
                    rememberBadMethod:mthd 
                    key:#sendsObsoleteMethodWarningButNotTaggedAsObsoleteOrViceVersa
                    info:('sends obsoleteMethodWarning but not tagged as obsolete')
            ].
        ] ifFalse:[
            mthd isObsolete ifTrue:[
                self 
                    rememberBadMethod:mthd 
                    key:#sendsObsoleteMethodWarningButNotTaggedAsObsoleteOrViceVersa
                    info:('tagged as obsolete but does not send an obsoleteMethodWarning')
            ].
        ].
    ]
!

sentNotImplemented
    |alreadyChecked alreadyCheckedSelf alreadyCheckedSuper|

    alreadyChecked := IdentitySet new.
    alreadyCheckedSelf := IdentitySet new.
    alreadyCheckedSuper := IdentitySet new.

    checkedClass methodDictionary keysAndValuesDo:[:mSelector :method |
	|sentSelectors selfSelectors superSelectors selectorsNoWhereImplemented|

	selectorsNoWhereImplemented := IdentitySet new.
	sentSelectors := method messagesSent.
	sentSelectors do:[:eachSelector |
	    (alreadyChecked includes:eachSelector) ifFalse:[
		(self anyImplementationOf:eachSelector) ifTrue:[
		    alreadyChecked add:eachSelector
		] ifFalse:[
		    selectorsNoWhereImplemented add:eachSelector.
		    self 
			rememberBadMethod:method 
			key:#sentNotImplemented
			info:('#' , eachSelector allBold, ' is nowhere implemented (#sentNotImplemented)')
		]
	    ]
	].

	selfSelectors := method messagesSentToSelf.
	selfSelectors do:[:eachSelector |
	    (selectorsNoWhereImplemented includes:eachSelector) ifFalse:[
		(alreadyCheckedSelf includes:eachSelector) ifFalse:[
		    (self anyImplementationOf:eachSelector inOrAbove:checkedClass) ifTrue:[
			alreadyCheckedSelf add:eachSelector
		    ] ifFalse:[            
			self 
			    rememberBadMethod:method 
			    key:#sentNotImplemented
			    info:('#' , eachSelector allBold, ' is not implemented in the class (#sentNotImplemented)')
		    ]
		]
	    ]
	].
        
	superSelectors := method messagesSentToSuper.
	superSelectors do:[:eachSelector |
	    (selectorsNoWhereImplemented includes:eachSelector) ifFalse:[
		(alreadyCheckedSuper includes:eachSelector) ifFalse:[
		    (self anyImplementationOf:eachSelector inOrAbove:(checkedClass superclass)) ifTrue:[
			alreadyCheckedSuper add:eachSelector
		    ] ifFalse:[            
			self 
			    rememberBadMethod:method 
			    key:#sentNotImplemented
			    info:('#' , eachSelector allBold, ' is not implemented in any superclass (#sentNotImplemented)')
		    ]
		]
	    ]
	].
    ].
!

subclassResponsibilityNotDefined
    |classesInBetween|

    checkedClass allSuperclasses do:[:eachSuperClass |
	eachSuperClass methodDictionary keysAndValuesDo:[:mSelector :method |
	    (method referencesLiteral:#subclassResponsibility) ifTrue:[
		"/ parse it to see if it really does ...
		(method sends:#subclassResponsibility) ifTrue:[
		    "/ ok, got one;
		    "/ now, see if it is defined below this superClass
		    classesInBetween := checkedClass withAllSuperclasses copy.
		    classesInBetween removeAll:(eachSuperClass withAllSuperclasses).
		    (self anyImplementationOf:mSelector in:classesInBetween) ifFalse:[
			(self methodShouldBeIgnoredInSubclassResponsibilityNotDefined:method)
			ifFalse:[
			    self 
				rememberBadMethod:method 
				key:#subclassResponsibilityNotDefined
				info:(checkedClass name allBold , ' should redefine the #' , mSelector allBold , ' method (#subclassResponsibilityNotDefined)').
			].
		    ].
		]
	    ]
	]
    ].
!

unusedClassVariables
    |remainingVars|

    remainingVars := checkedClass theNonMetaclass classVarNames asNewSet.

    checkedClass theNonMetaclass withAllSubclassesDo:[:eachClassToCheck |
        eachClassToCheck instAndClassMethodsDo:[:method |
            self 
                parseMethod:method in:method mclass 
                withParserDo:[:parser |
                    remainingVars removeAllFoundIn:(parser usedClassVars)
                ]
                onErrorDo:[]
        ].
    ].

    remainingVars asSortedCollection do:[:eachVar |
        self rememberBadClass:checkedClass info:'Unused class variable: ',eachVar
    ].

    "Created: / 18-05-2010 / 14:37:42 / cg"
!

unusedInstanceVariables
    |remainingVars|

    remainingVars := checkedClass theNonMetaclass instVarNames asNewSet.

    checkedClass theNonMetaclass withAllSubclassesDo:[:eachClassToCheck |
        eachClassToCheck methodDictionary keysAndValuesDo:[:mSelector :method |
            self 
                parseMethod:method in:eachClassToCheck 
                withParserDo:[:parser |
                    remainingVars removeAllFoundIn:(parser usedInstVars)
                ]
                onErrorDo:[]
        ].
    ].

    remainingVars asSortedCollection do:[:eachVar |
        self rememberBadClass:checkedClass info:'Unused instance variable: ',eachVar
    ].

    "Created: / 18-05-2010 / 14:32:09 / cg"
! !

!ClassChecker methodsFor:'helpers'!

anyImplementationOf:aSelector
    Smalltalk allClassesDo:[:eachClass |
	(eachClass theNonMetaclass includesSelector:aSelector) ifTrue:[^ true].
	(eachClass theMetaclass includesSelector:aSelector) ifTrue:[^ true].
    ].
    ^ false
!

anyImplementationOf:aSelector in:aCollectionOfClasses
    ^ aCollectionOfClasses 
        contains:[:aClass | (aClass includesSelector:aSelector) ].
!

anyImplementationOf:aSelector inOrAbove:aClass
    aClass withAllSuperclassesDo:[:eachClass |
	(eachClass includesSelector:aSelector) ifTrue:[^ true].
    ].
    ^ false
!

anySendsOf:aSelector
    Smalltalk allMethodsDo:[:mthd |
        (mthd sends:aSelector) ifTrue:[^ true].
    ].
    ^ false
!

checkProtocolOf:aMethod
    |mClass mSelector protocol superClass implClass superProtocol|

    mClass := aMethod mclass.
    mSelector := aMethod selector.
    mClass isNil ifTrue:[^ true].
    mSelector isNil ifTrue:[^ true].

    protocol := aMethod category.
    protocol isNil ifTrue: [^true].

    superClass := mClass superclass.
    superClass isNil ifTrue: [^true].

    implClass := superClass whichClassIncludesSelector:mSelector.
    implClass isNil ifTrue: [^true].

    superProtocol := (implClass compiledMethodAt:mSelector) category.
    superProtocol = protocol ifTrue: [^true].
    superProtocol isNil ifTrue: [^true].

    self 
        rememberBadMethod:aMethod
        key:#checkProtocols
        info:('#' , mSelector allBold , ' is classified under "' , protocol allBold , '" in '
              , mClass name , ' and under "' , superProtocol allBold , '" in ' , implClass name
              , ' (#checkProtocols)')

    "Modified: / 18.8.2000 / 23:13:53 / cg"
!

checkUnusedVariables:aMethod rememberReadInstVarsIn:readInstVars writtenInstVarsIn:writtenInstVars readClassVarsIn:readClassVars writtenClassVarsIn:writtenClassVars
    |p mClass sourceString|

    sourceString := aMethod source.

    mClass := aMethod mclass.

    p := Parser parseMethodSilent:sourceString in:mClass.
    readInstVars addAll:(p readInstVars).
    writtenInstVars addAll:(p modifiedInstVars).
    readClassVars addAll:(p readClassVars).
    writtenClassVars addAll:(p modifiedClassVars).
!

instanceVariablesNeverUsedIn:aClass
    |notUsedHere notUsedAnyWhere anySubclass|

    notUsedHere := aClass instVarNames asNewSet.
    notUsedHere isEmpty ifTrue:[^ self].

    self removeUsedInstanceVariablesIn:aClass from:notUsedHere.

    notUsedHere notEmpty ifTrue:[
        notUsedAnyWhere := notUsedHere copy.
        anySubclass := false.
        aClass allSubclassesDo:[:eachSubclass |
            anySubclass := true.
            notUsedAnyWhere notEmpty ifTrue:[
                self removeUsedInstanceVariablesIn:eachSubclass from:notUsedAnyWhere.
            ]
        ].

        notUsedHere do:[:eachVariable |
            |className|

            className := aClass name allBold.
            self 
                rememberBadClass:aClass 
                info:('instVar ' , eachVariable allBold , ' is unused in ' , className , ' (#instanceVariablesNeverUsed)').

            anySubclass ifTrue:[
                (notUsedAnyWhere includes:eachVariable) ifTrue:[
                    self 
                        rememberBadClass:aClass 
                        info:('instVar ' , eachVariable allBold , ' is not even used in subclasses of ' , className , ' (#instanceVariablesNeverUsed)')
                ]
            ]
        ].
    ]
!

instanceVariablesNeverWrittenIn:aClass
    |notWrittenHere notWrittenAnyWhere anySubclass|

    notWrittenHere := aClass instVarNames asNewSet.
    notWrittenHere isEmpty ifTrue:[^ self].

    self removeWrittenInstanceVariablesIn:aClass from:notWrittenHere.

    notWrittenHere notEmpty ifTrue:[
        notWrittenAnyWhere := notWrittenHere copy.
        anySubclass := false.
        aClass allSubclassesDo:[:eachSubclass |
            anySubclass := true.
            notWrittenAnyWhere notEmpty ifTrue:[
                self removeWrittenInstanceVariablesIn:eachSubclass from:notWrittenAnyWhere.
            ]
        ].

        notWrittenHere do:[:eachVariable |
            |className|

            className := aClass name allBold.
            self 
                rememberBadClass:aClass
                info:('instVar ' , eachVariable allBold , ' is nowhere set in ' , className , ' (#instanceVariablesNeverWritten)').
            anySubclass ifTrue:[
                (notWrittenAnyWhere includes:eachVariable) ifTrue:[
                    self 
                        rememberBadClass:aClass
                        info:('instVar ' , eachVariable allBold , ' is not even set in subclasses of ' , className , ' (#instanceVariablesNeverWritten)')
                ]
            ]
        ].
    ]
!

messagesNeverSentAndNotUsedAsSymbolIn:selectorsOfInterest
    |remaining toRemove checkBlock|

    remaining := selectorsOfInterest asNewIdentitySet.
    toRemove := IdentitySet new.

    checkBlock := [:eachClass |
        eachClass instAndClassSelectorsAndMethodsDo:[:mSel :mthd | |lits|
            lits := mthd literals.
            lits notNil ifTrue:[
                lits traverse:[:eachLiteral |
                    eachLiteral isSymbol ifTrue:[        
                        remaining remove:eachLiteral ifAbsent:nil.
                    ]
                ].
                remaining isEmpty ifTrue:[^ remaining].
            ]
        ].
    ].

    "/ start searching in the checkedClass - chances are high, we find some here
    checkBlock value:checkedClass.
    checkedClass superclass notNil ifTrue:[checkBlock value:checkedClass superclass].
    Smalltalk allClassesDo:checkBlock.

    ^ remaining

    "Modified: / 18.8.2000 / 23:05:53 / cg"
    "Created: / 18.8.2000 / 23:06:55 / cg"
!

messagesNeverSentIn:selectorsOfInterest
    |remaining|

    remaining := selectorsOfInterest copy.
    Smalltalk allMethodsDo:[:mthd |
        |lits|

        lits := mthd literals.
        lits notNil ifTrue:[
            (lits includesAny:remaining) ifTrue:[
                remaining removeAllFoundIn:(mthd messagesSent).
                remaining isEmpty ifTrue:[^ remaining].
            ]
        ]
    ].
    ^ remaining

    "Created: / 18.8.2000 / 22:53:38 / cg"
    "Modified: / 18.8.2000 / 22:56:59 / cg"
!

methodShouldBeIgnoredInSubclassResponsibilityNotDefined:aMethod
    "a kludge for now - would like to have a pragma, resource or other
     way to mark such a method"

    aMethod == (Object compiledMethodAt:#implementedBySubclass) ifTrue:[^ true].
    aMethod == (Object compiledMethodAt:#readBinaryContentsFromData:manager:) ifTrue:[^ true].
    aMethod == (Object compiledMethodAt:#finalize) ifTrue:[^ true].
    ^ false.
!

rememberBadClass:class info:whatIsWrong
    |entry|

    badClasses isNil ifTrue:[
	badClasses := IdentitySet new.
    ].
    badClasses add:class.

    badClassInfo isNil ifTrue:[
	badClassInfo := IdentityDictionary new.
    ].
    entry := badClassInfo at:class ifAbsentPut:[ OrderedCollection new ].
    entry add:whatIsWrong.
!

rememberBadMethod:method key:key info:whatIsWrong
    |entry|

    badMethods isNil ifTrue:[
        badMethods := Set new.
    ].
    (badMethods includes:(method -> key)) ifTrue:[^ self].

    badMethods add:(method -> key).

    badMethodInfo isNil ifTrue:[
        badMethodInfo := IdentityDictionary new.
    ].
    entry := badMethodInfo at:method ifAbsentPut:[ OrderedCollection new ].
    entry add:whatIsWrong.
!

rememberBadMethods:methods key:key info:whatIsWrong
    methods do:[:eachMethod |  
	self rememberBadMethod:eachMethod key:key info:whatIsWrong
    ].
!

removeUsedClassVariablesIn:aClass from:aCollectionOfVariablenames
    aClass selectorsAndMethodsDo:[:mSelector :method |
	|src usedVars parser|

	src := method source.
	src notNil ifTrue:[
	    parser := Parser
			    parseMethod:src 
			    in:aClass 
			    ignoreErrors:true 
			    ignoreWarnings:true.

	    (parser notNil and:[parser ~~ #Error]) ifTrue:[
		aCollectionOfVariablenames removeAllFoundIn:(parser usedClassVars).
		aCollectionOfVariablenames isEmpty ifTrue:[^ self].
	    ]
	].
    ].
!

removeUsedInstanceVariablesIn:aClass from:aCollectionOfVariablenames
    aClass selectorsAndMethodsDo:[:mSelector :method |
	|src usedVars parser|

	src := method source.
	src notNil ifTrue:[
	    parser := Parser
			    parseMethod:src 
			    in:aClass 
			    ignoreErrors:true 
			    ignoreWarnings:true.

	    (parser notNil and:[parser ~~ #Error]) ifTrue:[
		aCollectionOfVariablenames removeAllFoundIn:(parser usedInstVars).
		aCollectionOfVariablenames isEmpty ifTrue:[^ self].
	    ]
	].
    ].
!

removeWrittenClassVariablesIn:aClass from:aCollectionOfVariablenames
    aClass selectorsAndMethodsDo:[:mSelector :method |
	|src usedVars parser|

	src := method source.
	src notNil ifTrue:[
	    parser := Parser
			    parseMethod:src 
			    in:aClass 
			    ignoreErrors:true 
			    ignoreWarnings:true.

	    (parser notNil and:[parser ~~ #Error]) ifTrue:[
		aCollectionOfVariablenames removeAllFoundIn:(parser modifiedClassVars).
		aCollectionOfVariablenames isEmpty ifTrue:[^ self].
	    ]
	].
    ].
!

removeWrittenInstanceVariablesIn:aClass from:aCollectionOfVariablenames
    aClass selectorsAndMethodsDo:[:mSelector :method |
	|src usedVars parser|

	src := method source.
	src notNil ifTrue:[
	    parser := Parser
			    parseMethod:src 
			    in:aClass 
			    ignoreErrors:true 
			    ignoreWarnings:true.

	    (parser notNil and:[parser ~~ #Error]) ifTrue:[
		aCollectionOfVariablenames removeAllFoundIn:(parser modifiedInstVars).
		aCollectionOfVariablenames isEmpty ifTrue:[^ self].
	    ]
	].
    ].
! !

!ClassChecker class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libtool/Tools__ClassChecker.st,v 1.21 2014-11-28 16:09:23 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libtool/Tools__ClassChecker.st,v 1.21 2014-11-28 16:09:23 cg Exp $'
! !

