"
 COPYRIGHT (c) 1993 by Claus Gittinger
 COPYRIGHT (c) 2016 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libcomp' }"

"{ NameSpace: Smalltalk }"

Parser subclass:#Explainer
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'System-Compiler'
!

Object variableSubclass:#ActionWithInfo
	instanceVariableNames:'block info'
	classVariableNames:''
	poolDictionaries:''
	privateIn:Explainer
!

!Explainer class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1993 by Claus Gittinger
 COPYRIGHT (c) 2016 Jan Vrany
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
    a very simple explainer - much more should be added...

    This one is involved, when the 'explain' menu function is used in a
    codeView (popup or via CMD-E), or if the mouse button is clicked
    on some code construct in the new browser (then a short explanaition
    is shown in the lower info area).

    Most of the texts returned here are heuristically motivated,
    based on the experience with beginners and their frequently asked questions.

    TODO:
    this is in an experimental stage; the naive type inferer replicates code
    found in DWIM support; it should use the code there.
    
    [author:]
        Claus Gittinger
"
! !

!Explainer class methodsFor:'explaining'!

explainLiteralNode:node in:code forClass:cls short:short interval:intervalIfKnown
    |expl literalValue literalsClass findInnerMost elementIndex codeOfCharacterBeforeCursor|

    literalValue := node value.
    literalsClass := literalValue class.
    expl := (self asClassLink:literalsClass name "allBold") , '-constant'.

    (literalValue isInteger) ifTrue:[
        (literalValue ~~ 0 and:[literalValue ~~ 1]) ifTrue:[
            expl := expl , ' ('.
            #(2 10 16) with:#('binary: ' 'decimal: ' 'hex: ') do:[:base :baseExpl |
                |bStr|

                base ~= (node token radix ? 10) ifTrue:[
                    bStr := base==10
                                ifTrue:[literalValue printString]
                                ifFalse:[(literalValue printStringRadix:base) leftPaddedTo:2 with:$0]. "/ looks better: at least a size of 2
                    "/ oops - someone looks at a largeInteger
                    bStr := bStr contractAtEndTo:40.
                    expl := expl , ' ' , baseExpl, bStr
                ].
            ].
            expl := expl , ' )'.
        ].  
        ^ expl.
    ].                
    (literalValue isCharacter) ifTrue:[
        expl := expl , ' ',literalValue storeString,' (code: ',literalValue codePoint printString,' hex: 16r',literalValue codePoint hexPrintString,')'.
        ^ expl.
    ].

    (node isLiteralArray and:[intervalIfKnown notNil]) ifTrue:[
        "/ see which element we have to explain
        findInnerMost :=
            [:token |
                token value keysAndValuesDo:[:index :eachToken |
                    |selectorOrName selectorExplanation|

                    ((eachToken start to:eachToken stop) intersect:intervalIfKnown) notEmpty ifTrue:[
                        elementIndex := index.  "/ see below

                        eachToken value isArray ifTrue:[
                            findInnerMost value:eachToken.
                        ].
                        eachToken value isSymbol ifTrue:[
                            selectorOrName := eachToken value.
                            selectorOrName isUppercaseFirst ifTrue:[
                                (Smalltalk includesKey:selectorOrName) ifTrue:[
                                    ^ expl, ' / ', (Explainer explainGlobal:selectorOrName inClass:cls short:short)
                                ].
                            ].
                            selectorExplanation := (Explainer explainSelector:selectorOrName inClass:cls short:short).
                            selectorExplanation isNil ifTrue:[^ expl].
                            ^ expl, ' / ', selectorExplanation.
                        ].
                    ].
                ]
             ].
        findInnerMost value:node token.
    ].

    (literalValue isArray or:[ literalValue isByteArray or:[ literalValue isString ]]) ifTrue:[
        literalValue size == 0 ifTrue:[
            ^ 'empty ' , expl
        ].
        elementIndex notNil ifTrue:[
            ^ expl , (' (size=%1; element=%2)' bindWith:literalValue size with:elementIndex)
        ].
        literalValue isString ifTrue:[
            elementIndex := intervalIfKnown start - node token start.

            (elementIndex between:1 and:literalValue size) ifTrue:[
                codeOfCharacterBeforeCursor := (literalValue at:elementIndex) codePoint.
                ^ expl , (' (size=%1; position=%2; codePoint=16r%3)' 
                        bindWith:literalValue size 
                        with:elementIndex
                        with:codeOfCharacterBeforeCursor hexPrintString)
            ]
        ].
        ^ expl , (' (size=%1)' bindWith:literalValue size)
    ].

    ^ expl

    "Modified (format): / 30-04-2016 / 16:00:05 / cg"
!

explainMessageNode:node in:code forClass:cls short:short interval:intervalIfKnown
    "answer a string which explains node"

    |receiver nm srchClass selector selectorString implClass
     boldSelectorString globalValue recClassSet
     implMethod implMethodComment info definer
     instances classesOfInstVars implementingClasses canBeNil
     bestMatches hint redefiningClasses|

    selector := node buildSelectorString.
    selectorString := selector printString contractTo:50.
    selector := selector asSymbolIfInterned.    "/ avoid creating new symbols.
    selector isNil ifTrue:[
        ^ '%1 is NOWHERE impemented.' bindWith:boldSelectorString
    ].

    selectorString := self asLink:selectorString to:(self actionToBrowseImplementorsOf:selector).
    boldSelectorString := selectorString "allBold".
    
    recClassSet := self guessPossibleClassesFor:(node receiver) in:code forClass:cls.
    recClassSet size == 1 ifTrue:[
        srchClass := recClassSet first.
        "take care - Set cannot store nil!!"
        implementingClasses := (recClassSet collect:[:cls | cls whichClassIncludesSelector:selector]) asArray.

        (implementingClasses includes:nil) ifTrue:[
            implementingClasses size > 1 ifTrue:[
                ^ 'possibly not understood: %1 (%2 other implementors)'
                    bindWith:selector "allBold"
                    with:(implementingClasses size - 1)
            ].

            (#('self'  'super' 'true' 'false' 'thisContext') includes:selector) ifTrue:[
                ^ ('%1 is NOT understood here (missing period after previous statement?)' 
                        bindWith:selector allBold)
            ].

            hint := ''.    
            (recClassSet contains:[:cls | cls isMeta not and:[cls theMetaclass canUnderstand:selector]]) ifTrue:[
                hint := '. But class understands it - did you mean "rcvr class ',selector,'..." ?'.
            ].
            bestMatches := Parser findBestSelectorsFor:selector in:srchClass.
            bestMatches notEmptyOrNil ifTrue:[
                |guessedClass|
                guessedClass := srchClass whichClassIncludesSelector:bestMatches first.
                guessedClass notNil ifTrue:[
                    ^ ('%1 is NOT understood here (best guess is: "%2" from %3)'
                        bindWith:selector allBold
                        with:(bestMatches first "allBold")
                        with:guessedClass name) , hint.
                ].
            ].
            ^ ('%1 is NOT understood here' bindWith:selector allBold), hint
        ].
    ].

    implementingClasses isNil ifTrue:[
        receiver := node receiver.
        receiver isVariable ifTrue:[
            nm := receiver name.
            nm = 'self' ifTrue:[
                srchClass := cls
            ].
            nm = 'super' ifTrue:[
                srchClass := cls superclass
            ].
            definer := receiver whoDefines:nm.
            definer isNil ifTrue:[
                "/ not a local or argument
                (cls instanceVariableNames includes:nm) ifTrue:[
                    "/ ok - an instVar; see what values we find...
                    instances := cls allSubInstances select:[:eachInst| eachInst isProtoObject not].
                    classesOfInstVars := instances collect:[:eachInst | (eachInst instVarNamed:nm) class] as:Set.
                    canBeNil := (classesOfInstVars remove:UndefinedObject ifAbsent:[]) notNil.
                    "take care - Set cannot store nil!!"
                    implementingClasses := classesOfInstVars collect:[:cls | (cls whichClassIncludesSelector:selector) ? 0].
                    implementingClasses remove:0 ifAbsent:[].
                ] ifFalse:[
                    nm isUppercaseFirst ifTrue:[
                        nm knownAsSymbol ifTrue:[
                            globalValue := Smalltalk at:nm asSymbol.
                            globalValue isClass ifTrue:[
                                srchClass := globalValue class.
                            ].
                        ]
                    ].
                ].
            ].
        ].

        receiver isLiteral ifTrue:[
            srchClass := receiver value class
        ].

        srchClass notNil ifTrue:[
            implClass := srchClass whichClassIncludesSelector:selector.
            implClass isNil ifTrue:[
                ^ '%1 is NOT understood here.' bindWith:boldSelectorString
            ].
            redefiningClasses := srchClass allSubclasses select:[:cls | cls implements:selector].
        ] ifFalse:[
            implementingClasses isNil ifTrue:[
                implementingClasses := Smalltalk allImplementorsOf:selector
            ].
        ].
    ].

    implClass isNil ifTrue:[
        implementingClasses size == 1 ifTrue:[
            implClass := implementingClasses anElement.
        ]
    ].
    implClass notNil ifTrue:[ 
        |clsName action1 action2|

        implMethod := implClass compiledMethodAt:selector.
        clsName := implClass name.
        clsName := self asLink:clsName to:(self actionToBrowseClass:implClass selector:selector).
        info := '%1  %2' bindWith:clsName "allBold" with:selectorString.
        info := self asLink:info to:(action1 := self actionToBrowseClass:implClass selector:selector info:nil).
        
        redefiningClasses size > 0 ifTrue:[
            redefiningClasses size == 1 ifTrue:[
                |redefiner|
                redefiner := redefiningClasses first.
                info := info,(' (redefined in %1)'
                                bindWith:(self 
                                            asLink:redefiner name
                                            to:(action2 := self actionToBrowseClass:redefiner selector:selector))).
                action2 info:((redefiner compiledMethodAt:selector) source) 
            ] ifFalse:[    
                info := info,' (redefined in '
                             ,('%1 classes' 
                                    bindWith:(self 
                                              asLink:redefiningClasses size printString
                                              info:'Browse redefiners'
                                              to:(action2 := self actionToBrowseImplementorsOf:selector in:redefiningClasses)))
                             ,')'. 
                action2 info:'Browse redefiners'            
            ].
        ].
        
        implMethodComment := self fetchDescriptionOfMethod:"fetchCommentOfMethod:"implMethod.
        implMethodComment notNil ifTrue:[
            info := info , Character cr , implMethodComment.
            action1 info:implMethod source.
        ].
        ^ info
"/        (srchClass isNil and:[(cls includesBehavior:implClass) not]) ifTrue:[
"/            "/ info := 'guess: ', info.
"/            info := info , ' (guess)'.
"/        ].
    ] ifFalse:[
        info := Explainer explainSelector:selector inClass:cls short:short.
    ].

"/    implementingClasses notEmptyOrNil ifTrue:[
"/        implMethods := implementingClasses collect:[:implClass | implClass compiledMethodAt:selector].
"/        implMethods size <= 8 ifTrue:[
"/            implMethods size < 4 ifTrue:[
"/                "/ show full comments
"/                comments := implMethods 
"/                                collect:[:implMethod | implMethod comment]
"/                                thenSelect:[:comment | comment notEmptyOrNil].
"/            ] ifFalse:[
"/                "/ show first lines one
"/                comments := implMethods 
"/                                collect:[:implMethod | (self fetchCommentOfMethod:implMethod)]
"/                                thenSelect:[:comment | comment notEmptyOrNil].
"/            ].
"/            comments := comments collect:[:each | each colorizeAllWith:(UserPreferences current commentColor) ].
"/            short ifTrue:[
"/                comments := comments collect:[:implMethodComment | implMethodComment firstLine] as:Set.
"/                comments size == 1 ifTrue:[
"/                    ^ info , ' ' , (comments first).
"/                ].
"/                ^ info
"/            ].
"/            info := info,'\'withCRs.
"/            comments 
"/                with:implementingClasses 
"/                do:[:eachComment :eachClass | 
"/                    info := info,'\comment in ',eachClass name,':\',(eachComment asStringCollection asString) 
"/                ].
"/        ].
"/    ].
    ^ info

    "Modified: / 30-04-2016 / 17:08:11 / cg"
!

explainMethodNode:node in:code forClass:cls short:short interval:intervalIfKnown
    |srchClass selector selectorString implClass
     "sendingMethods numSendingMethods sendingClasses" |

    selector := node selector.
    selector := selector asSymbolIfInterned.    "/ avoid creating new symbols.
    selectorString := selector printString contractTo:50.

    (srchClass := cls superclass) notNil ifTrue:[
        implClass := srchClass whichClassIncludesSelector:selector.
        implClass notNil ifTrue:[
            ^ '%1 overrides implementation in %2.'
              bindWith:(self asLink:selectorString "allBold" to:(self actionToOpenMethodFinderFor:selector))
              with:(self asLink:implClass name "allBold" to:(self actionToBrowseClass:implClass selector:selector))
        ].
    ].
    (cls includesSelector:selector) ifFalse:[
        ^ '%1: a new method.' bindWith:selectorString "allBold"
    ].
"/
"/        sendingMethods := SystemBrowser
"/                                allCallsOn:selector
"/                                in:(cls withAllSubclasses , cls allSubclasses)
"/                                ignoreCase:false
"/                                match:false.
"/        sendingMethods := sendingMethods select:[:eachMethod | eachMethod mclass notNil].  "/ remove unbound ones
"/
"/        sendingClasses := (sendingMethods collect:[:eachMethod | eachMethod mclass]) asSet.
"/        numSendingMethods := sendingMethods size.
"/        numSendingMethods == 1 ifTrue:[
"/            sendingClasses first == cls ifTrue:[
"/                ^ '%1: sent locally from %2.'
"/                    bindWith:boldSelectorString
"/                    with:sendingMethods first selector "allBold"
"/            ].
"/            ^ '%1: sent in hierarchy from %2 in %3.'
"/                bindWith:boldSelectorString
"/                with:sendingMethods first selector "allBold"
"/                with:sendingClasses first name.
"/        ].
"/        numSendingMethods == 2 ifTrue:[
"/            sendingClasses asIdentitySet size == 1 ifTrue:[
"/                sendingClasses first == cls ifTrue:[
"/                    ^ '%1: sent locally from %2 and %3.'
"/                        bindWith:boldSelectorString
"/                        with:sendingMethods first selector "allBold"
"/                        with:sendingMethods second selector "allBold"
"/                ].
"/                ^ '%1: sent in hierarchy from %2 and %3 in %4.'
"/                    bindWith:boldSelectorString
"/                    with:sendingMethods first selector "allBold"
"/                    with:sendingMethods second selector "allBold"
"/                    with:sendingClasses first name.
"/            ].
"/        ].
"/        numSendingMethods == 0 ifTrue:[
"/"/            ^ '%1: no sender found.'
"/"/                bindWith:boldSelectorString.
"/            ^ nil
"/        ].
"/        ^ '%1: %2 sending methods in hierarchy.'
"/            bindWith:boldSelectorString
"/            with:numSendingMethods.
"/
"/        "/ the following is too expensive...
"/"/        sendingMethods := SystemBrowser allCallsOn:selector in:Smalltalk allClasses.
"/"/        numSendingMethods == 0 ifTrue:[
"/"/            ^ '%1: nowhere sent.' bindWith:boldSelectorString
"/"/        ].
"/"/        numSendingMethods == 1 ifTrue:[
"/"/            sendingMethods first mclass == cls ifTrue:[
"/"/                ^ '%1: only sent from %2.'
"/"/                    bindWith:boldSelectorString
"/"/                    with:sendingMethods first selector "allBold"
"/"/            ].
"/"/            ^ '%1: only sent from %2 in %3.'
"/"/                bindWith:boldSelectorString
"/"/                with:sendingMethods first selector "allBold"
"/"/                with:sendingMethods first mclass name.
"/"/        ].
"/"/        sendingClasses := (sendingMethods collect:[:eachMethod | eachMethod mclass]) asSet.
"/"/        sendingClasses size == 1 ifTrue:[
"/"/            sendingClasses first == cls ifTrue:[
"/"/                ^ '%1: locally sent from %2 methods.'
"/"/                    bindWith:boldSelectorString
"/"/                    with:numSendingMethods
"/"/            ].
"/"/            ^ '%1 only sent from %2 methods in %3.'
"/"/                bindWith:boldSelectorString
"/"/                with:numSendingMethods
"/"/                with:sendingClasses first name.
"/"/        ].

    ^ nil

    "Modified: / 09-10-2006 / 12:11:16 / cg"
!

explainNode:node in:code forClass:cls short:short
    self explainNode:node in:code forClass:cls short:short interval:nil
!

explainNode:node in:code forClass:cls short:short interval:intervalIfKnown
    "parsetree based explanations"
    
    node isVariable ifTrue:[
        ^ self explainVariableNode:node in:code forClass:cls short:short interval:intervalIfKnown.
    ].

    node isLiteral ifTrue:[
        ^ self explainLiteralNode:node in:code forClass:cls short:short interval:intervalIfKnown
    ].

    node isMessage ifTrue:[
        ^ self explainMessageNode:node in:code forClass:cls short:short interval:intervalIfKnown
    ].

    node isMethod ifTrue:[
        ^ self explainMethodNode:node in:code forClass:cls short:short interval:intervalIfKnown
    ].
    ^ nil

    "Modified (comment): / 27-11-2017 / 18:05:22 / cg"
!

explainVariableNode:node in:code forClass:cls short:short interval:intervalIfKnown
    |expl nm nmBold definingNode namePart argNode argClass argClassSet|

    nm := node name.

    (#( 'self' 'super' 'thisContext' 'here') includes:nm) ifTrue:[
        ^ Explainer explainPseudoVariable:nm in:cls short:short
    ].

    nm notNil ifTrue:[ nmBold := nm "allBold" ].

    definingNode := node whoDefines:nm.
    definingNode notNil ifTrue:[
        namePart := '''' , nmBold , ''''.
        definingNode isMethod ifTrue:[
            argNode := definingNode arguments detect:[:arg | arg name = nm] ifNone:nil.
            argNode notNil ifTrue:[
                expl := namePart , ': a method argument.'.

                argClassSet := self guessPossibleClassesFor:argNode in:code forClass:cls.
                argClassSet size == 1 ifTrue:[
                    argClass := argClassSet first.
                ].
            ].
        ].
        expl isNil ifTrue:[
            definingNode isBlock ifTrue:[
                (definingNode arguments contains:[:arg | arg name = nm]) ifTrue:[
                    expl := namePart , ': a block argument.'
                ].
            ].
        ].
        expl isNil ifTrue:[
            | parentNode setOfTypes isLocal typesDescription |
            
            (parentNode := definingNode parent) notNil ifTrue:[
                (isLocal := parentNode isMethod) ifTrue:[
                    expl := namePart , ': a method temporary.'.
                ] ifFalse:[
                    (isLocal := parentNode isBlock) ifTrue:[
                       expl := namePart , ': a block temporary.'.
                    ]
                ].
                isLocal ifTrue:[
                    setOfTypes := Set new.
                    self addTypesAssignedToLocal:nm inTree:parentNode to:setOfTypes.
                    setOfTypes remove:UndefinedObject ifAbsent:[].
                    typesDescription := self typeDescriptionFor:setOfTypes andSelector:nil.
                    typesDescription notNil ifTrue:[
                        expl := expl,' (',typesDescription,')'.
                    ].    
                ].    
            ].
        ].
        expl isNil ifTrue:[
            expl := namePart , ': temporary.'
        ].
        (cls allInstanceVariableNames includes:nm) ifTrue:[
            expl := expl , ' (instance variable is hidden)'
        ].
        ^ expl.
    ].

    ^ Explainer explain:node name in:code forClass:cls short:short

    "Modified: / 07-11-2006 / 12:22:09 / cg"
!

fetchCommentOfMethod:mthd
    "retrieve the comment of a method 
     (if possible and there is one; otherwise, return nil)"

    |methodSource methodComment lines maxNumLines|

    self withWaitCursorDo:[
        SourceCodeManagerError handle:[:ex |
        ] do:[
            methodSource := mthd source.
            methodComment := mthd comment
        ].
    ].
        
    methodComment isEmptyOrNil ifTrue:[^ nil].
    
    lines := methodComment asStringCollection.
    maxNumLines := 1.
true ifTrue:[
    methodComment := (lines copyToMax:maxNumLines) asString.
    maxNumLines := 5.
] ifFalse:[    
    methodComment := lines first.
    methodComment := methodComment withoutSeparators.
    (methodComment endsWith:',') ifTrue:[ methodComment := methodComment copyButLast:1].
    methodComment := methodComment withoutSeparators.
].
    (lines size > maxNumLines) ifTrue:[
        methodComment := methodComment , '\...' withCRs
    ].
    ^ (methodComment) withColor:(UserPreferences current commentColor).

    "Created: / 14-09-2006 / 14:11:58 / cg"
    "Modified (comment): / 30-04-2016 / 16:17:18 / cg"
!

fetchDescriptionOfMethod:mthd
    "retrieve a desription of a method 
     (if possible and there is one; otherwise, return nil)"

    |methodDecl methodSource methodComment lines maxNumLines firstIndent|

    self withWaitCursorDo:[
        SourceCodeManagerError handle:[:ex |
        ] do:[
            methodSource := mthd source.
            mthd selector isNil ifTrue:[
                methodDecl := '??? (method removed from class)'.
            ] ifFalse:[        
                methodDecl := mthd methodDefinitionTemplate.
            ].        
            methodComment := mthd comment.
        ].
    ].
    methodComment isEmptyOrNil ifTrue:[
        ^ methodDecl
    ].
    lines := methodComment asStringCollection withoutLeadingAndTrailingBlankLines.
    lines isEmptyOrNil ifTrue:[
        ^ methodDecl
    ].
    
    firstIndent := 0.
    lines size > 1 ifTrue:[
        |line2|
        line2 := lines at:2.
        line2 notEmpty ifTrue:[
            firstIndent := (line2 indexOfNonSeparator - 1) max:0.
        ].    
    ].    
    lines := lines 
                        collect:[:line | 
                            |l|
                            l := line withTabsExpanded.
                            l indexOfNonSeparator > firstIndent ifTrue:[
                                l := l copyFrom:firstIndent+1
                            ].
                            l
                        ].
    methodComment := lines asString.
    
    ^ methodDecl , Character cr , 
        (methodComment withColor:(UserPreferences current commentColor)). 
    
"/    methodComment isEmptyOrNil ifTrue:[^ nil].
"/    
"/    lines := methodComment asStringCollection.
"/    maxNumLines := 1.
"/true ifTrue:[
"/    methodComment := (lines copyToMax:maxNumLines) asString.
"/    maxNumLines := 5.
"/] ifFalse:[    
"/    methodComment := lines first.
"/    methodComment := methodComment withoutSeparators.
"/    (methodComment endsWith:',') ifTrue:[ methodComment := methodComment copyButLast:1].
"/    methodComment := methodComment withoutSeparators.
"/].
"/    (lines size > maxNumLines) ifTrue:[
"/        methodComment := methodComment , '\...' withCRs
"/    ].
"/    ^ (methodComment) withColor:(UserPreferences current commentColor).

    "Created: / 14-09-2006 / 14:11:58 / cg"
    "Modified (format): / 20-06-2017 / 10:29:13 / cg"
!

guessPossibleClassesFor:node in:code forClass:cls
    "given a node of some code of a method in cls,
     return a collection of possible types of the node."

    |nm globalValue definer instances classesOfInstVars ns|

    node isVariable ifTrue:[
        nm := node name.

        nm = #self ifTrue:[
            ^ cls withAllSubclasses
        ].
        nm = #here ifTrue:[
            ^ cls withAllSuperclasses
        ].
        nm = #super ifTrue:[
            ^ cls allSuperclasses
        ].

        definer := node whoDefines:nm.
        definer isNil ifTrue:[
            "/ not a local or argument
            (cls instanceVariableNames includes:nm) ifTrue:[
                "/ ok - an instVar; see what values we find...
                instances := cls allSubInstances select:[:eachInst | eachInst isProtoObject not].
                classesOfInstVars := instances collect:[:eachInst | (eachInst instVarNamed:nm) class] as:Set.
                ^ classesOfInstVars.
            ].
            (cls classVariableNames includes:nm) ifTrue:[
                ^ Array with:(cls classVarAt:nm asSymbol) class.
            ].
            nm isUppercaseFirst ifTrue:[
                nm knownAsSymbol ifTrue:[
                    globalValue := Smalltalk at:nm asSymbol.
                    globalValue isClass ifTrue:[
                        ^ Array with:globalValue class.
                    ].
                ].
                ((ns := cls topNameSpace) notNil and:[ns ~~ Smalltalk]) ifTrue:[
                    nm knownAsSymbol ifTrue:[
                        globalValue := ns at:nm asSymbol.
                        globalValue isClass ifTrue:[
                            ^ Array with:globalValue class.
                        ].
                    ].
                ]
            ].
        ].
        definer isMethod ifTrue:[
            |callers argNr setOfTypes|
            
            argNr := definer arguments findFirst:[:arg | arg name = nm]. 
            setOfTypes := IdentitySet new.
            "/ see who calls this message; are there any calls with an obvious type?
            callers := SystemBrowser allCallsOn:definer selector.
            callers do:[:eachCaller |
                |tree|
                (tree := eachCaller parseTree) notNil ifTrue:[
                    tree allMessageNodesDo:[:msg |
                        |argExpr|

                        msg selector = definer selector ifTrue:[
                            argExpr := (msg arguments at:argNr).
                            self addTypeOfExpressionNode:argExpr forAssignmentTo:nil to:setOfTypes.
                        ].                
                    ].
                ].                
            ].                
            setOfTypes notEmpty ifTrue:[
                ^ setOfTypes.
            ].    
        ].    
        ^ nil
    ].

    node isLiteral ifTrue:[
        ^ Array with:(node value class)
    ].

"/    node isMessage ifTrue:[
"/        recClassSet := self guessPossibleImplementorClassesFor:(node receiver) in:code forClass:cls.
"/        recClassSet isNil ifTrue:[ ^ nil ].
"/        recClassSet isEmpty ifTrue:[ ^ nil ].
"/
"/        implSet := recClassSet collect:[:recClass | recClass whichClassIncludesSelector:node selector].
"/        "/ toDo: for each implementor, parse its method for possible return types.
"/        ^ rsltClassSet.
"/    ].
    ^ nil

    "Modified: / 07-02-2012 / 22:19:53 / cg"
!

withWaitCursorDo:aBlock
    "with wait cursor;
     however: this class is in libcomp (should be in libtool)
     so check if WindowGroup (from libview) is present"

    |windowGroup wg|

    windowGroup := Smalltalk at:#WindowGroup.
    windowGroup notNil ifTrue:[
        (wg := windowGroup activeGroup) notNil ifTrue:[
            ^ wg withWaitCursorDo:aBlock.
        ].
    ].
    ^ aBlock value.
! !

!Explainer class methodsFor:'explaining-naive'!

explain:someText in:source forClass:aClass
    "Given a source and a substring of it, return a string containing
     an explanation.
     This is just a q&d implementation - to be correct, it should use the parser,
     and explain from the parsetree (instead of doing string matches).
     This leads to some wrong explanations, for example if some string is
     used as selector within a string, or if a variable is named like a
     message selector. I.e. the explanation should be context sensitive.
     Also, there could be much more detailed explanations."

    ^ self explain:someText in:source forClass:aClass short:false

    "Modified: / 07-06-2007 / 11:34:05 / cg"
!

explain:someText in:source forClass:aClass short:shortText
    "Given a source and a substring of it, return a string containing
     an explanation.
     This is just a q&d implementation - to be correct, it should use the parser,
     and explain from the parsetree (instead of doing string matches).
     This leads to some wrong explanations, for example if some string is
     used as selector within a string, or if a variable is named like a
     message selector. I.e. the explanation should be context sensitive.
     Also, there could be much more detailed explanations."

    |explainer variables c string explanation tmp1
     spc sym sel stringText cls clsName val valString color|

    string := someText string withoutSeparators.
    string isEmpty ifTrue:[ ^ nil ].

    stringText := string allBold.
    "/ stringText := '''' , stringText , ''''.

    "
     ask parser for variable names
    "
    ParseError catch:[
        explainer := self parseMethod:source in:aClass ignoreErrors:true ignoreWarnings:true.
    ].
    "/ bad leftover from a stupid return value from ancient times
    explainer == #Error ifTrue:[ explainer := nil ].

    (explainer notNil) ifTrue:[
        "look for variables"

        variables := explainer methodVars.
        (variables notNil and:[variables includes:string]) ifTrue:[
            ^ stringText , ' a method variable.'
        ].
        variables := explainer methodArgs.
        (variables notNil and:[variables includes:string]) ifTrue:[
            ^ stringText , ' a method argument.'
        ]
    ].

    explainer isNil ifTrue:[
        explainer := self for:(ReadStream on:source) in:aClass
    ].

    "instvars/class instVars"
    c := aClass whichClassDefinesInstVar:string.
    c notNil ifTrue:[
        c isMeta ifTrue:[
            clsName := c theNonMetaclass name.
            shortText ifTrue:[
                clsName := self asClassLink:clsName.
                stringText := stringText , ': a class instVar in ' , clsName
            ] ifFalse:[
                stringText := stringText, ': a class instance variable inherited from ' , clsName
            ].
            val := aClass theNonMetaclass instVarNamed:string.
            valString := self valueStringFor:val.
            ^ stringText , ' (' , valString , ').'
        ].
        ^ self explainInstanceVariable:string inClass:c short:shortText.
    ].

    string isWideString ifFalse:[
        "classvars"
        c := explainer inWhichClassIsClassVar:string.
        c notNil ifTrue:[
            val := c theNonMetaclass classVarAt:string. "/ Smalltalk at:(clsName , ':' , string) asSymbol.
            valString := self valueStringFor:val.

            val == true ifTrue:[
                color := Color green darkened.
            ] ifFalse:[
                val == false ifTrue:[
                    color := Color red darkened
                ] ifFalse:[
                    val == nil ifTrue:[
                        color := Color darkGrey
                    ].    
                ].    
            ].    
            color notNil ifTrue:[
                stringText := stringText withColor:color.
                valString := valString withColor:color. 
            ].
            
            clsName := c name.
            shortText ifTrue:[
                clsName := self asClassLink:clsName.
                stringText := stringText , ': a classVar in ' , clsName
            ] ifFalse:[
                stringText := stringText , ': a class variable in ' , clsName
            ].

            ^ stringText , ' (' , valString , ').'
        ].

        "private classes"
        c := aClass theNonMetaclass.
        c privateClasses do:[:pClass |
            (pClass name = string
             or:[pClass nameWithoutPrefix = string]) ifTrue:[
                stringText := self asClassLink:pClass name.
                stringText := stringText , ': a private class in ''' , c name , '''.'.
                shortText ifFalse:[
                    stringText := (stringText , '\\It is only visible locally.') withCRs
                ].
                ^ stringText withCRs
            ].
        ].

        aClass theNonMetaclass sharedPoolNames do:[:eachPoolName |
            |sharedPool sharedPoolSym poolName|

            sharedPoolSym := string asSymbolIfInterned.
            sharedPoolSym notNil ifTrue:[
                sharedPool := Smalltalk classNamed:eachPoolName.
                sharedPool notNil ifTrue:[
                    sharedPool isSharedPool ifFalse:[
                        ^ 'oops - not a shared pool: ',eachPoolName
                    ].
                    (sharedPool includesKey:sharedPoolSym) ifTrue:[
                        poolName := sharedPool name.
                        poolName := self asClassLink:eachPoolName.
                        stringText := stringText , ': a pool variable in ',poolName.
                        val := sharedPool at:sharedPoolSym.
                        valString := self valueStringFor:val.
                        ^ stringText , ' (' , valString , ').'
                    ].
                ].
            ].
        ].

        "namespace & global variables"
        (spc := aClass nameSpace) notNil ifTrue:[
            sym := (spc name , '::' , string) asSymbolIfInterned.
            sym notNil ifTrue:[
                (cls := Smalltalk at:sym) isBehavior ifTrue:[
                    stringText := self asClassLink:sym.
                    string :=  stringText , ': '.
                    cls name = sym ifFalse:[
                        string :=  string , 'refers to ',cls name,', '
                    ].
                    cls isSharedPool ifTrue:[
                        string := string , 'a sharedPool'.
                    ] ifFalse:[
                        string := string , 'a class'.
                    ].

                    string :=  string , ' in the ''' , spc name , ''' nameSpace'.
                    string := string , ' {', cls category ,'}'.
                    shortText ifFalse:[
                        string := (string
                             , '\\It is only visible within this nameSpace.'
                             , '\Access from the outside is possible'
                             , '\by the special name ''' , spc name , '::' , string , '''.') withCRs
                    ].
                    ^ string withCRs
                ].
            ].
        ].

        "/ string knownAsSymbol ifTrue:[
            "globals & symbols"

            explanation := self explainKnownSymbol:string inClass:aClass short:shortText.
            explanation notNil ifTrue:[ 
                string isBinarySelector ifTrue:[
                    "/ some are both known as syntax AND as selector (for example: #| )
                    tmp1 := self explainSyntax:string short:shortText.
                    tmp1 notNil ifTrue:[ 
                        ^ tmp1 , '\\also:\\' withCRs , explanation
                    ].
                ].
                ^ explanation
            ].

            "/ try with added colon ...
            sel := string , ':'.
            Symbol allInstancesDo:[:sym |
                (sym startsWith:sel) ifTrue:[
                    explanation := self explainKnownSymbol:sym inClass:aClass short:shortText.
                    explanation notNil ifTrue:[ ^ explanation].
                ]
            ].
        "/ ].

        "try for some obvious things"
        explanation := self explainPseudoVariable:string in:aClass short:true.
        explanation notNil ifTrue:[ ^ explanation].
    ].

    "try syntax ..."

    explanation := self explainSyntax:string short:shortText.
    explanation notNil ifTrue:[ ^ explanation].

    shortText ifTrue:[
        |selector|
        
        (selector := SystemBrowser extractSelectorFrom:string) notNil ifTrue:[
            selector ~= string string ifTrue:[
                ^ self explain:selector in:source forClass:aClass short:shortText    
            ].    
        ]. 
        someText size == 1 ifTrue:[
            ^ 'no explanation; character encoding: %1 (0x%2)'
                    bindWith:someText first codePoint
                    with:(someText first codePoint hexPrintString:4)
        ].    
        ^ 'no explanation'
    ].

    explainer isNil ifTrue:[
        ^ 'parse error - no explanation'
    ].
    ^ 'Sorry, I cannot explain this (could not figure out what this is).
Please try again with an individual token selected.'

    "Created: / 03-12-1995 / 12:47:37 / cg"
    "Modified: / 16-04-1997 / 12:46:11 / stefan"
    "Modified: / 23-08-2017 / 12:44:12 / cg"
!

explainGlobal:string inClass:aClass short:shortText
    "return an explanation or nil"

    ^ self explainGlobalOrPoolVariable:string inClass:aClass short:shortText

    "Modified: / 14-10-2010 / 11:33:17 / cg"
    "Modified (comment): / 28-02-2012 / 10:45:58 / cg"
!

explainGlobalOrPoolVariable:varName inClass:aClass short:shortText
    "return an explanation or nil"

    |template bindings
     sym explanation val pool valText doc|

    "if not even known as key, it's definitely not a global"
    sym := varName asSymbolIfInterned.
    sym isNil ifTrue:[^ nil].
       
    template := nil.
    bindings := Dictionary new.
    
    "a pool variable?"
    aClass notNil ifTrue:[
        aClass theNonMetaclass sharedPoolNames do:[:eachPoolName |
            pool := Smalltalk at:eachPoolName.
            pool isNil ifTrue:[
                "/ oops - on the fly we encountered a non existing pool...
            ] ifFalse:[
                (pool classVarNames includes:varName) ifTrue:[
                    template := '%(varName): pool variable in "%(poolName)"'.
                    bindings at:'poolName' put:eachPoolName.                    
                    val := pool classVarAt:sym.
                ].
            ].
        ].
    ].

    bindings at:'varName' put:varName allBold.

    template isNil ifTrue:[
        "try globals"
        (Smalltalk includesKey:sym) ifFalse:[
            ^ '%(varName): an undefined variable.' bindWithArguments:bindings.
        ].    
        template := '%(varName): global'.
        val := Smalltalk at:sym.
    ].

    val isBehavior ifTrue:[
        "/ a class
        val name = sym ifFalse:[
            "/ an alias (such as OperatingSystem, Screen etc.)
            template := template,'. Refers to %(realName)'.
            bindings at:'realName' put:val name.
        ].

        (val isRealNameSpace) ifTrue:[
            template := template,', a namespace.'.
            ^ template bindWithArguments:bindings.
        ].
        
        "/ a real class
        bindings at:'category' put:(val category ? 'uncategorized').
        shortText ifTrue:[
            template := template , ',' , (val isLoaded ifTrue:[' a'] ifFalse:[' an autoloaded']).
            template := template , (val isSharedPool ifTrue:[' pool'] ifFalse:[' class']).
            template := template , ' in %(package) {%(category)}.'.
            bindings at:'package' put:val package.
            bindings at:'varName' put:(self asClassLink:varName "val name").
            ^ template bindWithArguments:bindings
        ].

        val name = varName ifTrue:[
            false ifTrue:[
                "/ TODO: generate a short documentation string (comment plus interface)
                "/ and return { #html->htmlText . #text->regularText}
                "/ so caller can extract what he wants to see...
                ^ ((Smalltalk at:#HTMLDocGenerator) htmlDocOf:val).
            ].
            explanation := varName , ' is '.
            explanation := explanation , (val isLoaded ifTrue:['a'] ifFalse:['an autoloaded']).
            explanation := explanation , (val isSharedPool ifTrue:[' sharedPool'] ifFalse:[' class']).
            explanation := explanation , ' categorized as "' , val category , '"'.
            explanation := explanation , '\' withCRs , 'in the "' , val package , '" package.'.
            (doc := val commentOrDocumentationString) notEmptyOrNil ifTrue:[
                doc := doc asStringCollection.
                doc size > 25 ifTrue:[
                    doc := doc copyTo:25.
                    doc add:''; add:'   ... <more documentation cut off>'.
                ].
                doc := doc asString withColor:(UserPreferences current commentColor).
                explanation := explanation,'\\' withCRs,val name,'''s documentation:\'withCRs, doc
            ].
            ^ explanation.
        ].

        explanation := explanation , '

' , varName , ' is bound to the class ' , val name ,
' in the "' , val category , '" category.'.
        ^ explanation.
    ].

    valText := self valueStringFor:val.

    shortText ifTrue:[
        ^ '%1: a global (%2)' 
            bindWith:varName 
            with:(self asLink:valText to:(self actionToBrowseClass:val class selector:nil))
    ].

    explanation := explanation , '

Its current value is "%1".' bindWith:valText.
    ^ explanation.

    "Created: / 14-10-2010 / 11:33:04 / cg"
    "Modified: / 16-11-2016 / 13:08:07 / cg"
    "Modified: / 05-05-2016 / 00:25:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

explainHereIn:aClass short:shortText
    "return an explanation"

    |className|

    className := aClass name.

    shortText ifTrue:[
        ^ '"here" - message lookup always starts in "%1" (always call local method).' bindWith:className
    ].

    ^ 'like "self", "','here'allBold,'" refers to the object which received the message.

However, when sending a message to "here", the search for methods
implementing this message will start in the defining class (' , className , '),
instead of the receiver''s class (' , className , ' or subclass).
Thus, using "here", redefined methods will NOT be reached with a here-send and it is ensured,
that the local method is called.'

    "Created: / 28-02-2012 / 10:44:55 / cg"
!

explainInstanceVariable:instVarName inClass:aClass short:shortText
    |varNameInText classNameInText template stringText setOfTypes typesDescription|

    varNameInText := instVarName allBold.
    classNameInText := aClass name.
    
    shortText ifTrue:[
        template := '%1: instVar in %2'.
        varNameInText := self 
                            asLink:varNameInText 
                            info:('Click to browse references to %1' bindWith:instVarName)
                            to:(self actionToBrowseInstvarRefsTo:instVarName inClass:aClass).
        classNameInText := self asClassLink:classNameInText.
    ] ifFalse:[
        template := '%1: an instance variable in %2'
    ].
    stringText := template bindWith:varNameInText with:classNameInText.

    "/ look for instances
    setOfTypes := IdentitySet new.
    self addTypesOfInstvar:instVarName inClass:aClass fromExistingInstancesTo:setOfTypes.
    "/ look for assignments
    aClass withAllSubclassesDo:[:cls | 
        self addTypesAssignedToInstvar:instVarName inClass:cls to:setOfTypes
    ].
    
    "/ generate a list of up-to 3 links
    typesDescription := self typeDescriptionFor:setOfTypes andSelector:nil.
    typesDescription notNil ifTrue:[
        stringText := stringText,' (',typesDescription,')'
    ].
    ^ stringText
!

explainKnownSymbol:string inClass:aClass
    "return an explanation or nil"

    ^ self explainKnownSymbol:string inClass:aClass short:false

    "Modified (comment): / 28-02-2012 / 10:45:40 / cg"
!

explainKnownSymbol:string inClass:aClass short:shortText
    "return an explanation or nil"

    |sym expl|

    sym := string asSymbolIfInterned.
    sym isNil ifTrue:[^ nil].

    "try globals and pools"
    (Smalltalk includesKey:sym) ifTrue:[
        expl := self explainGlobalOrPoolVariable:string inClass:aClass short:shortText.
        expl notNil ifTrue:[^ expl].
    ].

    expl := self explainSelector:string inClass:aClass short:shortText.
    expl notNil ifTrue:[^ expl].
    ^ self explainGlobalOrPoolVariable:string inClass:aClass short:shortText.

    "Modified: / 18-01-2011 / 19:13:07 / cg"
    "Modified (comment): / 28-02-2012 / 10:46:06 / cg"
!

explainPseudoVariable:string in:aClass
    "return an explanation for the pseudoVariables self, super etc."

    <resource: #obsolete>

    ^ self explainPseudoVariable:string in:aClass short:false

    "Modified (format): / 28-02-2012 / 10:47:17 / cg"
!

explainPseudoVariable:string in:aClass short:shortText
    "return an explanation for the pseudoVariables self, super etc."

    (string = 'self') ifTrue:[
        ^ self explainSelfIn:aClass short:shortText
    ].

    (string = 'super') ifTrue:[
        ^ self explainSuperIn:aClass short:shortText
    ].

    (string = 'here') ifTrue:[
        ^ self explainHereIn:aClass short:shortText
    ].

    (string = 'thisContext') ifTrue:[
        shortText ifTrue:[
            ^ '''thisContext'' - the current stack frame as an object.'
        ].
        ^ 'thisContext is a pseudo variable (i.e. it is built in).

ThisContext always refers to the context object for the currently executed method or
block (an instance of Context or BlockContext respectively). The calling chain and calling
receivers/selectors can be accessed via thisContext.'
    ].

    (string = 'true') ifTrue:[
        shortText ifTrue:[
            ^ '''true'' - the truth and nothing but the truth.'
        ].
        ^ 'true is a pseudo variable (i.e. it is built in).

True represents logical truth. It is the one and only instance of class True.'
    ].

    (string = 'false') ifTrue:[
        shortText ifTrue:[
            ^ '''false'' - obvisously not true.'
        ].
        ^ 'false is a pseudo variable (i.e. it is built in).

False represents logical falseness. It is the one and only instance of class False.'
    ].

    (string = 'nil') ifTrue:[
        shortText ifTrue:[
            ^ '''nil'' - undefined, unknown, void or dont care.'
        ].
        ^ 'nil is a pseudo variable (i.e. it is built in).

Nil is used for unitialized variables (among other uses).
Nil is the one and only instance of class UndefinedObject.'
    ].
    ^ nil

    "Modified (comment): / 28-02-2012 / 10:46:18 / cg"
!

explainSelector:string inClass:aClass short:shortText
    "return an explanation or nil"

    |selector listOfImplementingClasses listOfImplementingClassNames listOfSimilarSelectors
     firstImplementingClassOfSimilar count tmp commonSuperClass s s2
     firstImplementingClass
     firstImplementingClassName secondImplementingClassName thirdImplementingClassName
     classProvidingComment
     cm msg t check|

    selector := string asSymbolIfInterned.
    selector isNil ifTrue:[^ nil].

    "/ look who implements it
    listOfImplementingClassNames := Set new.
    listOfImplementingClasses := Set new.
    listOfSimilarSelectors := Set new.

    check :=
        [:sel :mthd :cls |
            sel == selector ifTrue:[
                listOfImplementingClasses add:cls.
                listOfImplementingClassNames add:(cls name).
                firstImplementingClass isNil ifTrue:[
                    firstImplementingClass := cls.
                    firstImplementingClassName := cls name.
                ]
            ] ifFalse:[
                (sel startsWith:selector) ifTrue:[
                    listOfSimilarSelectors add:sel.
                    firstImplementingClassOfSimilar isNil ifTrue:[
                        firstImplementingClassOfSimilar := cls
                    ]
                ]
            ]
        ].

    Smalltalk allClassesDo:[:c|
        c methodDictionary keysAndValuesDo:[:sel :mthd |
            check value:sel value:mthd value:c
        ].
        c class methodDictionary keysAndValuesDo:[:sel :mthd |
            check value:sel value:mthd value:c class
        ].
    ].

    (aClass canUnderstand:selector) ifTrue:[
        s2 := ('Instances of ''' , aClass name , ''' respond to #') , selector "allBold" , '.'.
        shortText ifFalse:[
            s2 := '\\' , s2
                  , '\- inherited from ' withCRs
                  , (aClass whichClassIncludesSelector:selector) name "allBold".
        ].
        firstImplementingClass := (aClass whichClassIncludesSelector:selector)
    ] ifFalse:[
        s2 := ''.
    ].

    count := listOfImplementingClassNames size.
    (count ~~ 0) ifTrue:[
        "
         for up-to 4 implementing classes,
         list them
        "
        listOfImplementingClassNames := listOfImplementingClassNames asOrderedCollection sort.
        shortText ifTrue:[
            tmp := ' is implemented in '.
        ] ifFalse:[
            tmp := ' is a selector implemented in '.
        ].
        "/ s := string allBold.
        count > 1 ifTrue:[
            s := self asLink:selector to:(self actionToOpenMethodFinderFor:selector).
        ] ifFalse:[
            s := self asLink:selector to:(self actionToBrowseClass:listOfImplementingClasses first selector:selector).
        ].

        shortText ifTrue:[
            |typesDescription|

            msg := s , tmp.
            typesDescription := self typeDescriptionFor:listOfImplementingClasses andSelector:selector wordBetween:'and'.
            typesDescription notNil ifTrue:[
                msg := msg,typesDescription
            ].
        ] ifFalse:[
            (count == 1) ifTrue:[
                t := firstImplementingClassName.
                firstImplementingClass isMeta ifTrue:[
                    t := 'the ' , t
                ].
                msg := s , tmp , t , '.'.
                shortText ifFalse:[
                    msg := msg , s2.
                ]
            ] ifFalse:[
                firstImplementingClassName := listOfImplementingClassNames at:1.
                secondImplementingClassName := listOfImplementingClassNames at:2.
                (count == 2) ifTrue:[
                    msg := s,tmp,firstImplementingClassName,' and ',secondImplementingClassName,'.'.
                    shortText ifFalse:[
                        msg := msg , s2.
                    ].
                ] ifFalse:[
                    thirdImplementingClassName := listOfImplementingClassNames at:3.
                    (count == 3) ifTrue:[
                        msg := s,tmp,firstImplementingClassName,',',secondImplementingClassName,' and ',thirdImplementingClassName,'.'.
                        shortText ifFalse:[
                            msg := msg , s2.
                        ].
                    ] ifFalse:[
                        false "shortText" ifTrue:[
                            msg := s , tmp , count printString , ' classes'.
                            commonSuperClass := Class commonSuperclassOf:listOfImplementingClassNames.
                            commonSuperClass notNil ifTrue:[
                                (commonSuperClass == Object
                                and:[commonSuperClass includesSelector:selector]) ifTrue:[
                                    msg := msg , ' (including ' , 'Object' "allBold", ')'
                                ] ifFalse:[
                                    (commonSuperClass ~= Object) ifTrue:[
                                        msg := msg , ' (under ' , commonSuperClass name, ')'
                                    ]
                                ].
                            ].
                            msg := msg , '.'.
                            ^ msg
                        ].

                        "
                         if there are more, look for a common
                         superclass and show it ...
                        "
                        commonSuperClass := (Behavior commonSuperclassOf:listOfImplementingClasses) ? Object.
                        (commonSuperClass ~~ Object
                        and:[commonSuperClass ~~ Behavior
                        and:[commonSuperClass ~~ Class
                        and:[commonSuperClass ~~ ClassDescription]]]) ifTrue:[
                            (listOfImplementingClasses includes:commonSuperClass) ifTrue:[
                                msg := s . tmp , count printString , commonSuperClass name
                                         , ' and redefined in ' , (count - 1) printString
                                         , ' subclasses'
                                         , s2.
                                firstImplementingClass := commonSuperClass
                            ] ifFalse:[
                                msg := s , tmp, count printString , ' subclasses of ' , commonSuperClass name , s2
                            ]
                        ] ifFalse:[
                            (commonSuperClass == Object
                            and:[commonSuperClass includesSelector:selector]) ifTrue:[
                                shortText ifTrue:[
                                    msg := s , tmp , count printString , ' classes (incl. Object)'.
                                ] ifFalse:[
                                    msg := s , tmp , count printString , ' classes.

All objects seem to respond to that message,
since there is an implementation in Object.' , s2.
                                ].
                                firstImplementingClass := Object
                            ] ifFalse:[
                                ((commonSuperClass == Behavior
                                 or:[commonSuperClass == Class
                                 or:[commonSuperClass == ClassDescription]])
                                and:[commonSuperClass includesSelector:selector]) ifTrue:[
                                    shortText ifTrue:[
                                        msg := s , tmp , count printString , ' classes (incl. all classes)'.
                                    ] ifFalse:[
                                        msg := s , tmp , count printString , ' classes.

All classes seem to respond to that message,
since there is an implementation in ' , commonSuperClass name , '.' , s2.
                                    ].
                                    firstImplementingClass := commonSuperClass
                                ] ifFalse:[
                                    "
                                     otherwise just give the number.
                                    "
                                    msg := s , tmp , count printString , ' classes.' , s2
                                ]
                            ]
                        ]
                    ]
                ].
            ].
        ].
        "/ look for a comment...
        count == 1 ifTrue:[
            classProvidingComment := firstImplementingClass.
        ] ifFalse:[
            commonSuperClass isNil ifTrue:[
                commonSuperClass := Behavior commonSuperclassOf:listOfImplementingClasses.
            ] .

            ((listOfImplementingClasses includes:commonSuperClass)
              and:[ (commonSuperClass implements:selector) ]
            ) ifTrue:[
                classProvidingComment := commonSuperClass
            ] ifFalse:[
                "/ avoid some obvious misleading paths...
                classProvidingComment := { Number . Collection . Stream . View }
                                            detect:[:cls | (listOfImplementingClasses includes:cls)
                                                           or:[cls canUnderstand:selector]  ]
                                            ifNone:nil.
                classProvidingComment notNil ifTrue:[
                    classProvidingComment := classProvidingComment whichClassImplements:selector.
                ] ifFalse:[
                    classProvidingComment := firstImplementingClass.
                    [
                        classProvidingComment superclass notNil
                        and:[ classProvidingComment superclass implements:selector ]
                    ] whileTrue:[
                        classProvidingComment := classProvidingComment superclass
                    ].
                ].
            ].
        ].
        classProvidingComment notNil ifTrue:[
            cm := self fetchDescriptionOfMethod:"fetchCommentOfMethod:"(classProvidingComment compiledMethodAt:selector).
        ].
        cm isNil ifTrue:[
            "/ should: find the class with most subclasses from the list
            (listOfImplementingClasses includes:Collection) ifTrue:[
                classProvidingComment := Collection
            ] ifFalse:[
                (listOfImplementingClasses includes:Stream) ifTrue:[
                    classProvidingComment := Stream
                ] ifFalse:[
                    classProvidingComment := listOfImplementingClasses
                            detect:[:cls |
                                |mthd|
                                (mthd := cls compiledMethodAt:selector) notNil
                                and:[ (self fetchCommentOfMethod:mthd) notNil]]
                            ifNone:nil.
                ]
            ].
            cm isNil ifTrue:[
                classProvidingComment notNil ifTrue:[
                    cm := self fetchDescriptionOfMethod:(classProvidingComment compiledMethodAt:selector).
                ]
            ].
        ].
        cm notNil ifTrue:[
            cm := (' %1 says:\' withCRs bindWith:(self asClassLink:classProvidingComment name)),cm.

            "/ msg := msg,(msg last isSeparator ifTrue:[''] ifFalse:[' ']),cm
            msg := msg,(Character cr),cm
        ].
        ^ msg
    ].

    "/ none implements it (typo?);
    count := listOfSimilarSelectors size.
    (count ~~ 0) ifTrue:[
        listOfSimilarSelectors := listOfSimilarSelectors asOrderedCollection sort.

        (count == 1) ifTrue:[
            |sel selLink clsLink implementors|

            sel := listOfSimilarSelectors first.
            selLink := self asLink:sel to:(self actionToOpenMethodFinderFor:sel).
            "/ clsLink := self asLink:firstImplementingClassOfSimilar name to:(self actionToBrowseClass:firstImplementingClassOfSimilar selector:sel).
            implementors := Smalltalk allImplementorsOf:sel.
            clsLink := self typeDescriptionFor:implementors andSelector:sel.
            msg := selLink , ' is implemented in ' , clsLink , '.'.
            shortText ifFalse:[
                msg := msg , s2.
            ]
        ] ifFalse:[
            |sel1 sel2|
            sel1 := listOfSimilarSelectors first.
            sel2 := listOfSimilarSelectors second.
            msg := 'similar selectors: %1, %2'
                        bindWith:(self asLink:sel1 to:(self actionToOpenMethodFinderFor:sel1))
                        with:(self asLink:sel2 to:(self actionToOpenMethodFinderFor:sel1)).
            count > 2 ifTrue:[
                msg := msg,'...'.
            ].
        ].
        ^ msg
    ].

    ^ nil

    "Modified: / 17-06-1996 / 17:09:30 / stefan"
    "Created: / 23-03-1999 / 13:29:33 / cg"
    "Modified: / 01-05-2016 / 15:42:24 / cg"
    "Modified: / 22-05-2017 / 11:35:31 / mawalch"
!

explainSelfIn:aClass short:shortText
    "return an explanation"

    |subClasses subNames selfString className nSubClasses 
     classLink classLink2 subclassesLink|

    selfString := '''' , 'self' "allBold" , ''''.

    subClasses := aClass allSubclasses.
    nSubClasses := subClasses size.

    aClass isMeta ifTrue:[
        className := aClass theNonMetaclass name.
        subNames := subClasses collect:[:c | c theNonMetaclass name].
        shortText ifTrue:[
            classLink := (self asClassLink:className).
            nSubClasses == 0 ifTrue:[
                ^ selfString , (' - the %1 class.' bindWith:classLink)
            ].
            nSubClasses == 1 ifTrue:[
                classLink2 := self asClassLink:subNames first.
                ^ selfString , (' - the %1- or %2 class.' bindWith:classLink with:classLink2)
            ].
            subclassesLink := self 
                        asLink:('%1 subclasses' bindWith:nSubClasses)  
                        info:('Click to browse subclasses')    
                        to:(self actionToBrowseClasses:subClasses). 

            ^ selfString , (' - the %1 class or one of its %2.' bindWith:classLink with:subclassesLink)
        ].
        
        nSubClasses == 0 ifTrue:[
            ^ selfString , 'refers to the object which received the message.

In this case, it will be the ' , className , '-class itself.'
        ].

        nSubClasses <= 5 ifTrue:[
            ^ selfString , ' refers to the object which received the message.

In this case, it will be the ' , className , '-class
or one of its subclasses:

' , subNames asStringCollection asString
        ].

        ^ selfString , ' refers to the object which received the message.

In this case, it will be the ' , className , '-class
or one of its ' , nSubClasses printString , ' subclasses.'
    ].

    subClasses := aClass allSubclasses.
    subNames := subClasses collect:[:c | c theNonMetaclass name].
    className := aClass name.
    shortText ifTrue:[
        classLink := self asClassLink:className.
        nSubClasses == 0 ifTrue:[
            ^ selfString , (' - an instance of %1.' bindWith:classLink)
        ].
        nSubClasses == 1 ifTrue:[
            classLink2 := self asClassLink:subNames first.
            ^ selfString , (' - an instance of %1 or %2.' bindWith:classLink with:classLink2)
        ].
        subclassesLink := self 
                    asLink:('%1 subclasses' bindWith:nSubClasses)  
                    info:('Click to browse subclasses')    
                    to:(self actionToBrowseClasses:subClasses). 
        ^ selfString , (' - an instance of %1 or one of its %2.' bindWith:classLink with:subclassesLink)
    ].
    
    nSubClasses == 0 ifTrue:[
        ^ selfString , 'refers to the object which received the message.

In this case, it will be an instance of ' , className , '.'
    ].

    nSubClasses <= 5 ifTrue:[
        ^ selfString , ' refers to the object which received the message.

In this case, it will be an instance of ' , className , '
or one of its subclasses:

' , subNames asStringCollection asString
    ].

    ^ selfString , ' refers to the object which received the message.

In this case, it will be an instance of ' , className , '
or one of its ' , nSubClasses printString , ' subclasses.'

    "Modified: / 09-10-2006 / 12:11:44 / cg"
    "Modified (comment): / 28-02-2012 / 10:47:06 / cg"
!

explainSuperIn:aClass short:shortText
    "return an explanation"

    |superName|

    superName := aClass superclass name.

    shortText ifTrue:[
        ^ '"super" - message lookup starts in superclass "%1" (call redefined method).' bindWith:(self asClassLink:superName)
    ].

    ^ 'like "self", "','super'allBold,'" refers to the object which received the message.

However, when sending a message to "super", the search for methods
implementing this message will start in the superclass (' , superName , '),
instead of the receiver''s class (' , aClass name , ' or subclass).
Thus, using "super", a redefined method can call the original (redefined) method of its superclass.'

    "Modified (comment): / 28-02-2012 / 10:47:03 / cg"
!

explainSyntax:string
    "try syntax ...; return explanation or nil"

    ^ self explainSyntax:string short:false
!

explainSyntax:string short:shortText
    "try syntax ...; return explanation or nil.
     This is meant for beginners..."

    |fullMsg stringWithoutSeparators|
    
    ((string = ':=') or:[string = '_']) ifTrue:[
        fullMsg := '<variable> := <expression>

":=" and "_" (which is left-arrow in some fonts) mean assignment.
The variable is bound to (i.e. points to) the value of <expression>.
The "_" form is historic and should not be used with new code.'.

        shortText ifTrue:[
            string = '_' ifTrue:[
                ^ (self 
                    asLink:'"_"' 
                    info:fullMsg 
                    to:nil),' - old style for assignment. Consider changing to ":=".'
            ].
            ^ (self 
                asLink:'":="' 
                info:fullMsg 
                to:nil),' - assign to variable on the left (syntax).'
        ].
        ^ fullMsg
    ].

    (string = '^') ifTrue:[
        shortText ifTrue:[
            ^ '"^" - return value from method (syntax)'.
        ].
        ^ '^ <expression>

A return statement evaluates <expression> and returns its value from the method.
A return inside a block exits the method where the block is defined (not only the block).'
    ].

    (string = ';') ifTrue:[
        shortText ifTrue:[
            ^ '";" - a cascade expression (syntax)'.
        ].
        ^ '<expression> ; selector1 ; .... ; selectorN

a cascade expression; evaluate expression, and send messages
<selector1> ... <selectorN> to the first expression''s receiver.
Returns the value of the last send. The cascade sends may also have arguments.'
    ].

    (string = '|') ifTrue:[
        shortText ifTrue:[
            ^ '"|" - local variables (syntax)'.
        ].
        ^ '| locals |  or: [:arg | statements]

"|" is used to mark a local variable declaration or separates arguments
from the statements in a block. Notice, that in a block-argument declaration
these arg nams must be prefixed by a colon character.
"|" is also a selector understood by Booleans.'
    ].

    (string startsWith:'$' ) ifTrue:[
        shortText ifTrue:[
            ^ '"$x" - ',(self asClassLink:'Character'),' literal (syntax)'.
        ].
        ^ 'is a Character literal constant.

Character objects represent indivdual text cheracters in Unicode encoding.
For example, $a is the character "a" with an encoding of 97 "hex: 16r61".
Smalltalk/X supports unicode and uses this encoding internally for all characters
and strings. Notice, that not all Smalltalk implementations allow non-ascii (i.e. codes > 255).'
    ].

    (string startsWith:'#' ) ifTrue:[
        (string startsWith:'#(' ) ifTrue:[
            shortText ifTrue:[
                ^ '"#(..)" - ',(self asClassLink:'Array'),' literal (syntax)'.
            ].
            ^ 'is a constant Array (literal).

The array-object is created at compilation time and a reference to this is
used at execution time (thus, the same object is referred to every time).
The elements of a constant Array must be numbers, strings, symbols, nil, true or false,
other array constants or byte-arrays.
(notice, that not all Smalltalk implementations allow true, false and nil as
 element in an Array-constant).'
        ].

        (string startsWith:'#[') ifTrue:[
            shortText ifTrue:[
                ^ '"#[..]" - ',(self asClassLink:'ByteArray'),' literal (syntax)'.
            ].
            ^ 'is a constant ByteArray (literal).

The elements of a constant ByteArray must be Integer constants in the range
0 .. 255.
(notice, that not all Smalltalk implementations support constant ByteArrays).'
        ].

        (string startsWith:'#''') ifTrue:[
            shortText ifTrue:[
                ^ '"#''..''" - ',(self asClassLink:'Symbol'),' literal (syntax)'.
            ].
            ^ 'is a constant symbol containing non-alphanumeric characters.

Symbols are unique strings, meaning that there exists
exactly one instance of a given symbol. Therefore symbols can
be compared using == (identity compare) in addition to = (contents compare).
Beside this, Symbols behave mostly like Strings but are immutable.'
        ].

        shortText ifTrue:[
            ^ '"#.." - ',(self asClassLink:'Symbol'),' literal (syntax)'.
        ].
        ^ 'is a constant symbol.

Symbols are unique strings, meaning that there exists
exactly one instance of a given symbol. Therefore symbols can
be compared using == (identity compare) in addition to = (contents compare).
Beside this, Symbols behave mostly like Strings but are immutable.'
    ].
    ((string startsWith:'(') or:[string endsWith:')']) ifTrue:[
        shortText ifTrue:[
            ^ ''.
        ].
        ^ '( <expression> )

expression grouping. Without them, expressions are evaluated left to right,
with unary messages preceeding binary messages, preceeding keyword mesages.'
    ].

    ((string startsWith:'[') or:[string endsWith:']']) ifTrue:[
        shortText ifTrue:[
            ^ '"[..]" - a ',(self asClassLink:'Block'),' (aka lambda/closure for experts)'.
        ].
        ^ '[:arg1 .. :argN | statements]

defines a block.
Blocks represent pieces of executable code. The definition of a block does
not evaluate it, instead a reference to the blocks computation is created.
The block can be evaluated later, by sending it a value/value: message
(it can be even evaluated multiple times).
Blocks are often passed as arguments to Booleans (i.e. "bool ifTrue:[...]"),
other blocks (i.e. "[...] whileTrue: [...]"]) or collections (i.e. "coll do:[...]").
Blocks are also often used as callbacks from UI components or as exception handlers.'
    ].

    ((string startsWith:'{') or:[string endsWith:'}']) ifTrue:[
        shortText ifTrue:[
            ^ '"{..}" ',(self asClassLink:'Array'),' instantiation (syntax)'.
        ].
        ^ '{ <expr1>. .. <exprN> }

This is syntactic sugar for "Array with:<expr1> .. with:<exprN>".

A new array is created with N elements initialized from the N expressions.
The expressions are separated by a period statement separator.
The expressions are evaluated at execution time, and a new array is always created
when executed (as opposed to an array literal, which is computed only once at
compilation time) and which is shared.
Notice that this construct is not supported by all Smalltalk dialects, so its use
makes your program somewhat dialect specific.'
    ].

    (string = ':') ifTrue:[
        shortText ifTrue:[
            ^ ''.
        ].
        ^ 'colons have different meaning depending on context:

1) they separate keyword-parts in symbols and keyword-messages as in:

    #at:put:                     a constant keyword symbol

    rec at:index put:value       sends the #at:put: message to rec,
                                 passing index and value as arguments.

2) within block-argument declarations as in:

    [:arg1 :arg2 | statements]

3) within an identifier, they separate the nameSpace part from
   the name part; as in:

    Smalltalk::Array    - the Array class in the Smalltalk nameSpace.
    Foo::Array          - the Array class in the Foo nameSpace.
'
    ].

    (string = '.') ifTrue:[
        ^ 'statement. "<- period here"
statement

within a method or block, individual statements are separated by periods.
'
    ].

    stringWithoutSeparators := string withoutSeparators.
    
    (stringWithoutSeparators startsWith:'"') ifTrue:[
        (stringWithoutSeparators startsWith:'"/') ifTrue:[
            shortText ifTrue:[
                ^ 'an end-of-line comment (syntax)'.
            ].
            ^ '"/ comment
EOL (end-of-line) comment

anything up to the end of line is a comment and ignored (but not inside a string).
Notice that EOL-comments are only supported by Smalltalk/X (i.e. non-portable).
'
        ].
        (stringWithoutSeparators startsWith:'"<<') ifTrue:[
            shortText ifTrue:[
                ^ 'a token delimited comment; up to line starting with the token after ''<<''.'.
            ].
            ^ '"<<TOKEN
...
TOKEN

Token delimited comment

anything up to a line which starts with the token is a comment and ignored (but not inside a string).
Notice that Token-comments are only supported by Smalltalk/X (i.e. non-portable).
'
        ].

        shortText ifTrue:[
            ^ 'a comment (syntax)'.
        ].
        ^ '" comment ... "
comment

anything between double quotes is a comment and ignored (but not inside a string).
'
    ].

    "/ is it a symbol without hash-character ?
    "/
"/    string knownAsSymbol ifTrue:[
"/        ^ 'is nothing, but #' , string , ' is known as a symbol.
"/
"/Symbols are unique strings, meaning that there exists
"/exactly one instance of a given symbol. Therefore symbols can
"/be compared using == (identity compare) in addition to = (contents compare).
"/Beside this, Symbols behave mostly like Strings.'
"/    ].

    ((stringWithoutSeparators startsWith:'<') and:[stringWithoutSeparators endsWith:'>']) ifTrue:[
        shortText ifTrue:[
            (stringWithoutSeparators includesString:'resource:') ifTrue:[
                ^ 'a ',(self 
                    asLink:'resource annotation' 
                    info:fullMsg 
                    to:(self actionToBrowseClass:Annotation)),' (syntax)'
            ].    
            ^ 'an ',(self 
                asLink:'annotation / pragma' 
                info:fullMsg 
                to:(self actionToBrowseClass:Annotation)),' (syntax)'
        ].
    ].
    
    ^ nil

    "Modified: / 28-07-2017 / 10:32:11 / cg"
!

typeDescriptionFor:setOfTypes andSelector:selectorOrNil
    "up to 3 types are shown by name; more are simply counted"
    
    ^ self typeDescriptionFor:setOfTypes andSelector:selectorOrNil wordBetween:'or'
!

typeDescriptionFor:setOfTypes andSelector:selectorOrNil wordBetween:wordbetween
    "up to 3 types are shown by name; more are simply counted"
    
    |types numTypes
     type1 type2 type3
     nm1 nm2 nm3 link stringForType|

    stringForType := 
        [:class |
            class == UndefinedObject ifTrue:['nil']
            ifFalse:[ class == True ifTrue:['true']
            ifFalse:[ class == False ifTrue:['false']
            ifFalse:[ class == VoidObject ifTrue:['Void']
            ifFalse:[ class name ]]]]
        ].
        
    "/ reduce...
    self compressSetOfTypes:setOfTypes.
    setOfTypes isEmpty ifTrue:[^ nil].
    
    types := setOfTypes asOrderedCollection.
    types sortBySelector:#name.

    "/ now make this a nice string
    numTypes := types size.
    type1 := types first.
    
    nm1 := self asLink:(stringForType value:type1) to:(self actionToBrowseClass:type1 selector:selectorOrNil).
    numTypes == 1 ifTrue:[
        ^ nm1
    ].
    
    type2 := types second.
    nm2 := self asLink:(stringForType value:type2) to:(self actionToBrowseClass:type2 selector:selectorOrNil).
    numTypes == 2 ifTrue:[
        ^ nm1,' ',wordbetween,' ',nm2
    ].
    type3 := types third.
    nm3 := self asLink:(stringForType value:type3) to:(self actionToBrowseClass:type3 selector:selectorOrNil).
    numTypes == 3 ifTrue:[
         ^ nm1,', ',nm2,' ',wordbetween,' ',nm3
    ].
    link := self actionToBrowseClasses:types.
"/    selectorOrNil notNil ifTrue:[
"/        link := self actionToOpenMethodFinderFor:selectorOrNil. 
"/    ].
    ^ self asLink:('%1 classes' bindWith:numTypes) to:link.

    "Modified (format): / 11-11-2017 / 12:30:09 / cg"
!

valueStringFor:aValue
    |valString|

    "/ only show the value, if it is really short...
    (aValue isBoolean
        or:[aValue isNil
        or:[aValue isString
        or:[aValue isNumber
        or:[aValue isPoint
        or:[aValue isCharacter
    ]]]]]) ifTrue:[
        ^ aValue storeString.
    ].

    (aValue isColor) ifTrue:[
        ^ 'Color: ',('   ' emphasizeAllWith:(#backgroundColor->aValue)).
    ].

    ((aValue isKindOf:GUID)
     or:[aValue isUUID]) ifTrue:[
        valString := aValue printString.
    ].

    (valString isEmptyOrNil
     or:[ valString size > 50
     or:[ valString includes:Character cr ]]) ifTrue:[
        valString := aValue classNameWithArticle.
    ].

    ^ valString

    "Modified: / 14-10-2010 / 11:57:52 / cg"
! !

!Explainer class methodsFor:'naive type inferer'!

addTypeOfExpressionNode:expr forAssignmentTo:varName to:setOfTypes
    "pick up low hanging type information.
     This is far from being complete, but often gives a hint good enough for code completion
     and info in the browser."

    |val valClass|

    "/ only look for wellknown types on the right side.
    expr isLiteral ifTrue:[
        val := expr value.
        valClass := val class.
        val isImmutable ifTrue:[
            valClass := [ valClass mutableClass ] on:Error do:[ valClass ].
        ].
        self rememberType:valClass in:setOfTypes.
        ^ setOfTypes.
    ].

    expr isMessage ifTrue:[
        self addTypeOfMessageNode:expr forAssignmentTo:varName to:setOfTypes.
        ^ setOfTypes.
    ].

    ^ setOfTypes
    
    "Created: / 30-04-2016 / 15:28:59 / cg"
    "Modified: / 30-04-2016 / 20:17:35 / cg"
!

addTypeOfMessageNode:expr forAssignmentTo:varName to:setOfTypes
    "pick up low hanging type information.
     This is far from being complete, but often gives a hint good enough for code completion
     and info in the browser."

    |valClass msgSelector msgReceiver|

    msgSelector := expr selector.
    msgReceiver := expr receiver.
        
    msgSelector == #? ifTrue:[
        self addTypeOfExpressionNode:(expr arg1) forAssignmentTo:varName to:setOfTypes.
        ^ setOfTypes
    ].
    
    "/ really really only very low hanging fruit...
    "/ ignore #/ here, because of filename
    ( #(+ - *) includes:msgSelector ) ifTrue:[
        true "(msgReceiver isLiteralNumber or:[expr arg1 isLiteralNumber])" ifTrue:[
            self rememberType:Number in:setOfTypes.
            ^ setOfTypes.
        ].    
"/        "/ ignore foo := foo OP expr
"/        "/ ignore foo := expr OP foo
"/        (msgReceiver isVariable and:[msgReceiver name = varName]) ifFalse:[
"/            (expr arg1 isVariable and:[expr arg1 name = varName]) ifFalse:[
"/                self rememberType:Number in:setOfTypes.
"/            ]
"/        ].
        ^ setOfTypes.
    ].

    ( #(// size hash identityHash) includes:msgSelector ) ifTrue:[
        self rememberType:Integer in:setOfTypes.
        ^ setOfTypes.
    ].
    
    ( #(next next:) includes:msgSelector ) ifTrue:[
        |rcvrTypes|
        
        rcvrTypes := self addTypeOfExpressionNode:msgReceiver forAssignmentTo:nil to:Set new.
        rcvrTypes notEmpty ifTrue:[
            self breakPoint:#cg.
            self rememberType:Character in:setOfTypes.
        ].
        ^ setOfTypes.
    ].
    
    ( msgSelector startsWith:'as') ifTrue:[
        valClass := Smalltalk classNamed:(msgSelector copyFrom:3).
        valClass notNil ifTrue:[
            self rememberType:valClass in:setOfTypes.
            ^ setOfTypes.
        ].
    ].
    
    ( #(copy shallowCopy) includes:msgSelector ) ifTrue:[
        msgReceiver isLiteral ifTrue:[
            self addTypeOfExpressionNode:msgReceiver forAssignmentTo:varName to:setOfTypes.
        ].
        ^ setOfTypes
    ].

    msgReceiver isGlobal ifTrue:[
        |instCreatorMessages globalValue implMethod|

        instCreatorMessages := #(new new: basicNew basicNew:).
        
        globalValue := msgReceiver value.
        globalValue isBehavior ifTrue:[
            ( instCreatorMessages includes:msgSelector ) ifTrue:[
                self rememberType:globalValue in:setOfTypes.
                ^ setOfTypes.
            ].
            implMethod := globalValue class lookupMethodFor:msgSelector.
            "/ mhmh - fuzzy; if the implementing message sends any of the above to itself...
            "/ assume it is returning it.
            implMethod isNil ifTrue:[
                "/ will not be understood
self breakPoint:#cg.
                ^ setOfTypes.
            ].    
            (implMethod messagesSentToSelf includesAny:instCreatorMessages) ifTrue:[
self breakPoint:#cg.
                self rememberType:globalValue in:setOfTypes.
                ^ setOfTypes.
            ].    
            "/ very fuzzy - if the implementing method is in the "instance creation" category...
            ((implMethod category ? '') startsWith:'instance creation') ifTrue:[
self breakPoint:#cg.
                self rememberType:globalValue in:setOfTypes.
                ^ setOfTypes.
            ].    
        ].
        "/ self breakPoint:#cg.
        ^ setOfTypes
    ].
    
    "/ self breakPoint:#cg.
    ^ setOfTypes

    "Modified: / 10-10-2017 / 16:57:09 / cg"
!

addTypesAssignedToInstvar:instVarName inClass:aClass method:aMethod to:setOfTypes
    "look to asssignments to an instance variable, and pick up low hanging class information.
     This is far from being complete, but often gives a hint good enough for code completion
     and info in the browser."

    | code |

    SourceCodeManagerError handle:[:ex |
    ] do:[    
        code := aMethod source.
    ].
    (code notNil) ifTrue:[
        self addTypesAssignedToInstvar:instVarName inClass:aClass source:code to:setOfTypes
    ]

    "Created: / 30-04-2016 / 15:07:33 / cg"
!

addTypesAssignedToInstvar:instVarName inClass:aClass source:code to:setOfTypes
    "look to asssignments to an instance variable, and pick up low hanging class information.
     This is far from being complete, but often gives a hint good enough for code completion
     and info in the browser."

    |tree|

    "/ quick check (avoids expensive parse)
    (code includesString:instVarName) ifFalse:[ ^ self ].

    tree := Parser parse:code class:aClass.
    (tree isNil or:[tree == #Error]) ifTrue:[ ^ self ]. "/ unparsable

    self addTypesAssignedToInstvar:instVarName inTree:tree to:setOfTypes.

    "Created: / 30-04-2016 / 15:09:18 / cg"
!

addTypesAssignedToInstvar:instVarName inClass:aClass to:setOfTypes
    "look to asssignments to an instance variable, and pick up low hanging class information.
     This is far from being complete, but often gives a hint good enough for code completion
     and info in the browser."

    aClass methodDictionary do:[:m |
        self addTypesAssignedToInstvar:instVarName inClass:aClass method:m to:setOfTypes
    ].

    "Created: / 30-04-2016 / 14:52:56 / cg"
!

addTypesAssignedToInstvar:instVarName inTree:tree to:setOfTypes
    "look to asssignments to an instance variable, and pick up low hanging class information.
     This is far from being complete, but often gives a hint good enough for code completion
     and info in the browser."

    |visitor|

    visitor := PluggableParseNodeVisitor new. 
    visitor 
        actionForNodeClass:AssignmentNode 
        put:[:node |
            (node variable isInstanceVariableNamed:instVarName) ifTrue:[
                self addTypeOfExpressionNode:(node expression) forAssignmentTo:instVarName to:setOfTypes
            ].
            true "/ yes - visit subnodes
        ].        
    visitor visit:tree.
!

addTypesAssignedToLocal:localName inTree:tree to:setOfTypes
    "look to asssignments to a local variable, and pick up low hanging class information.
     This is far from being complete, but often gives a hint good enough for code completion
     and info in the browser."

    |visitor|

    "/ hack, allowing to deal with both types of AST (sigh)
    (tree isKindOf:(Smalltalk at:#RBProgramNode)) ifTrue:[
        visitor := (Smalltalk at:#RBPluggableProgramNodeVisitor) new.
        visitor 
            actionForNodeClass:(Smalltalk at:#RBAssignmentNode)
            put:[:node |
                |leftSide|

                leftSide := node variable.
                (leftSide isTemporary and:[ leftSide name = localName ]) ifTrue:[
                    self addTypeOfExpressionNode:(node value) forAssignmentTo:localName to:setOfTypes
                ].
                true "/ yes - visit subnodes
            ].        
        visitor visitNode:tree.
    ] ifFalse:[    
        visitor := PluggableParseNodeVisitor new. 
        visitor 
            actionForNodeClass:AssignmentNode 
            put:[:node |
                |leftSide expr|

                leftSide := node variable.
                (leftSide isLocalVariable and:[ leftSide name = localName ]) ifTrue:[
                    expr := node expression.
                    self addTypeOfExpressionNode:expr forAssignmentTo:localName to:setOfTypes
                ].
                true "/ yes - visit subnodes
            ].        
        visitor visit:tree.
    ].

    "Modified (format): / 05-05-2016 / 00:19:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addTypesOfInstvar:instVarName inClass:aClass fromExistingInstancesTo:setOfTypes
    "look for existing instances and see that type is there"

    |instIndex|

    instIndex := aClass instVarIndexFor:instVarName.
    aClass allSubInstancesDo:[:i |
        |val varClass|

        val := (i instVarAt:instIndex).
        val notNil ifTrue:[
            varClass := val class.
            self rememberType:varClass in:setOfTypes.
        ].
    ].

    "Created: / 30-04-2016 / 14:56:11 / cg"
    "Modified: / 30-04-2016 / 20:05:03 / cg"
!

compressSetOfTypes:setOfTypes
    |toAdd toRemove|

    "/ reduce by eliminating common superclasses...

    toAdd := Set new.
    toRemove := Set new.
    setOfTypes do:[:type1 |
        setOfTypes do:[:type2 |
            |common|

            type1 superclass == type2 ifTrue:[
                toRemove add:type1.
            ] ifFalse:[
                type2 superclass == type1 ifTrue:[
                    toRemove add:type2.
                ] ifFalse:[    
                    common := type1 commonSuperclass:type2.
                    common ~~ Object ifTrue:[
                        toRemove add:type1.
                        toRemove add:type2.
                        toAdd add:common.
                    ].    
                ].                        
            ].
        ]
    ]. 
    setOfTypes removeAll:toRemove.
    setOfTypes addAll:toRemove.

    "/ hack
    setOfTypes size == 2 ifTrue:[
        ((setOfTypes includes:True) and:[setOfTypes includes:False]) ifTrue:[
            setOfTypes removeAll; add:Boolean.
            ^ self.
        ].
        ((setOfTypes includes:SmallInteger) and:[setOfTypes includes:LargeInteger]) ifTrue:[
            setOfTypes removeAll; add:Integer.
            ^ self.
        ]
    ].

    "Created: / 30-04-2016 / 15:37:38 / cg"
!

rememberType:aClass in:setOfTypes
    setOfTypes add:aClass

    "Created: / 30-04-2016 / 15:35:44 / cg"
    "Modified: / 30-04-2016 / 20:05:09 / cg"
! !

!Explainer class methodsFor:'utilities'!

actionToBrowseClass:class
    ^ self actionToBrowseClass:class selector:nil.
!

actionToBrowseClass:class selector:selectorOrNil
    ^ self actionToBrowseClass:class selector:selectorOrNil info:nil
!

actionToBrowseClass:class selector:selectorOrNil info:info
    self assert:class isBehavior.
    ^ ActionWithInfo
        block:
            [
                self thisOrNewBrowserInto:[:browser :openHow |
                    browser
                        spawnFullBrowserInClass:class selector:selectorOrNil in:openHow
                ]
            ]
        info:info
!

actionToBrowseClasses:classes 
    ^ ActionWithInfo
        block:[
            "/ Tools::NewSystemBrowser browseClasses:classes
            self thisOrNewBrowserInto:[:browser :openHow |
                browser spawnClassBrowserFor:classes in:openHow
            ]
        ]
        info:nil
!

actionToBrowseImplementorsOf:selector
    ^ self actionToBrowseImplementorsOf:selector in:[Smalltalk allClasses]
!

actionToBrowseImplementorsOf:selector in:classes
    ^ ActionWithInfo
        block:[
            self thisOrNewBrowserInto:[:browser :openHow |
                browser
                    spawnMethodImplementorsBrowserFor:{ selector }
                    match:false
                    in:openHow
                    classes:classes value
                    label:('Implementors of %1' bindWith:selector)
            ]
        ]
        info:('Click to browse implementors')
!

actionToBrowseInstvarRefsTo:instVarName inClass:class
    ^ ActionWithInfo
        block:[
            self thisOrNewBrowserInto:[:browser :openHow |
                browser   
                    browseVarRefsToAny:{ instVarName }
                    classes:{ class }
                    variables:#instVarNames access:#readOrWrite all:true
                    title:'references to ',instVarName
                    in:openHow
            ]
        ]
        info:nil
!

actionToBrowseMethod:mthd
    self assert:mthd isMethod.
    ^ self actionToBrowseClass:(mthd mclass) selector:(mthd selector).
!

actionToOpenMethodFinderFor:selector 
    MethodFinderWindow notNil ifTrue:[
        ^ ActionWithInfo
            block:[ 
                MethodFinderWindow openOnSelectorPattern:selector
            ]
            info:nil.
    ].
    ^ self actionToBrowseImplementorsOf:selector
!

asClassLink:nameOfClass
    "return text with a hyperlink to browse a class by that name"
    
    |cls|
    
    cls := Smalltalk classNamed:nameOfClass string asUppercaseFirst.
    cls isNil ifTrue:[^ nameOfClass].

    ^ self 
        asLink:nameOfClass  
        info:('Click to browse %1' bindWith:nameOfClass)    
        to:(self actionToBrowseClass:cls) 
!

asLink:aString info:info to:actionOrNil
    actionOrNil isNil ifTrue:[^ aString].
    ^ aString asActionLinkTo:(ActionWithInfo block:actionOrNil info:info)
!

asLink:aString to:actionOrNil
    actionOrNil isNil ifTrue:[^ aString].
    ^ aString asActionLinkTo:actionOrNil
!

infoStringForClasses:aCollectionOfClasses withPrefix:prefix
    "get a nice user readable list for some classes.
     Up to 4 are named, otherwise the count is presented.
     The prefix can be sth like ' other', ' sub', ' super',
     ' implementing' etc. Or it can be an empty string.
     To be shown in the info line at the bottom."

    |nClassNames sortedByName classNames link1 link2 link3 link4|

    aCollectionOfClasses isEmpty ifTrue:[
        ^ 'No %1classes' bindWith:prefix.
    ].

    classNames := aCollectionOfClasses asIdentitySet asOrderedCollection 
                        collect:[:each | each theNonMetaclass name].

    nClassNames := classNames size.

    nClassNames <= 4 ifTrue:[
        sortedByName := classNames sort.
        link1 := self asClassLink:sortedByName first.
        nClassNames == 1 ifTrue:[
            ^ '%2' "'1 %1class: %2'" bindWith:prefix with:link1.
        ].
        link2 := self asClassLink:classNames second.
        nClassNames == 2 ifTrue:[
            ^ '%2 and %3' "'2 %1classes: %2 and %3'" bindWith:prefix
                        with:link1
                        with:link2.
        ].
        link3 := self asClassLink:classNames third.
        nClassNames == 3 ifTrue:[
            ^ '%2, %3 and %4' "'3 %1classes: %2, %3 and %4'" bindWith:prefix
                        with:link1
                        with:link2
                        with:link3.
        ].
        link4 := self asClassLink:classNames fourth.
        nClassNames == 4 ifTrue:[
            ^ '%2, %3, %4 and %5' "'4 %1classes: %2, %3, %4 and %5'" bindWith:prefix
                        with:link1
                        with:link2
                        with:link3
                        with:link4.
        ].
    ].
    ^ self
        asLink:('%1 %2classes' bindWith:nClassNames printString with:prefix)
        info:'Browse classes' 
        to:(self actionToBrowseClasses:aCollectionOfClasses)        

    "Modified: / 27-07-2006 / 10:09:02 / cg"
!

infoStringForClasses:aCollectionOfClasses withPrefix:prefix actionGenerator:actionGeneratorOrNil
    "get a nice user readable list for some classes.
     Up to 4 are named, otherwise the count is presented.
     The prefix can be sth like ' other', ' sub', ' super',
     ' implementing' etc. Or it can be an empty string.
     To be shown in the info line at the bottom."

    |nClassNames classes sortedByName classNames
     link1 link2 link3 link4 actionGenerator|

    aCollectionOfClasses isEmpty ifTrue:[
        ^ 'No %1classes' bindWith:prefix.
    ].

    actionGenerator := actionGeneratorOrNil isNil
                        ifTrue:[ [:classes | self actionToBrowseClasses:classes] ]
                        ifFalse:[ actionGeneratorOrNil ].
                        
    classes := aCollectionOfClasses asIdentitySet asOrderedCollection. 
    classNames := classes collect:[:each | each theNonMetaclass name].

    nClassNames := classNames size.

    nClassNames <= 4 ifTrue:[
        sortedByName := classNames sortWith:classes.

        link1 := self asLink:classNames first "allBold"
                      info:('Browse %1' bindWith:classNames first)
                      to:(actionGenerator value:{classes first}).
        nClassNames == 1 ifTrue:[
            ^ '%2' "'1 %1class: %2'" 
                bindWith:prefix 
                with:link1.
        ].
        link2 := self asLink:classNames second "allBold" to:(actionGenerator value:{classes second}).
        nClassNames == 2 ifTrue:[
            ^ '%2 and %3' "'2 %1classes: %2 and %3'" 
                bindWith:prefix
                with:link1
                with:link2.
        ].
        link3 := self asLink:classNames third "allBold" to:(actionGenerator value:{classes third}).
        nClassNames == 3 ifTrue:[
            ^ '%2, %3 and %4' "'3 %1classes: %2, %3 and %4'" 
                bindWith:prefix
                with:link1
                with:link2
                with:link3.
        ].
        link4 := self asLink:classNames fourth "allBold" to:(actionGenerator value:{classes fourth}).
        nClassNames == 4 ifTrue:[
            ^ '%2, %3, %4 and %5' "'4 %1classes: %2, %3, %4 and %5'" 
                bindWith:prefix
                with:link1
                with:link2
                with:link3
                with:link4.
        ].
    ].
    ^ self 
        asLink:('%1 %2classes' bindWith:(nClassNames printString "allBold") with:prefix)
        to:(actionGenerator value:classes)    

    "Modified: / 27-07-2006 / 10:09:02 / cg"
!

infoStringForMethods:aCollectionOfMethods withPrefix:prefix
    "get a nice user readable list for some methods.
     Up to 3 are named, otherwise the count is presented.
     The prefix can be sth like ' other', ' sender', ' implementor',
     Or it can be an empty string.
     Result is meant to be shown in the info line at the bottom of a browser."

    |nMethodNames sortedByName methodNames|

    aCollectionOfMethods isEmpty ifTrue:[
        ^ 'No %1' bindWith:prefix.
    ].

    methodNames := aCollectionOfMethods asOrderedCollection 
                    collect:[:each | each whoString].

    nMethodNames := methodNames size.

    nMethodNames <= 3 ifTrue:[
        nMethodNames == 1 ifTrue:[
            ^ '%2' "'1 %1class: %2'" bindWith:prefix with:(methodNames first allBold).
        ].
        sortedByName := methodNames sort.
        nMethodNames == 2 ifTrue:[
            ^ '%2 and %3' "'2 %1classes: %2 and %3'" bindWith:prefix
                        with:(sortedByName first allBold)
                        with:(sortedByName second allBold).
        ].
        nMethodNames == 3 ifTrue:[
            ^ '%2, %3 and %4' "'3 %1classes: %2, %3 and %4'" bindWith:prefix
                        with:(sortedByName first allBold)
                        with:(sortedByName second allBold)
                        with:(sortedByName third allBold).
        ].
        nMethodNames == 4 ifTrue:[
            ^ '%2, %3, %4 and %5' "'4 %1classes: %2, %3, %4 and %5'" bindWith:prefix
                        with:(sortedByName first allBold)
                        with:(sortedByName second allBold)
                        with:(sortedByName third allBold)
                        with:(sortedByName fourth allBold).
        ].
    ].
    ^ '%1 %2methods' bindWith:nMethodNames printString allBold with:prefix.

    "
     Time millisecondsToRun:[
         self infoStringForMethods:(SystemBrowser allCallsOn:#'at:put:') withPrefix:''
     ].   
     Time millisecondsToRun:[
         self infoStringForMethods:(SystemBrowser allCallsOn:#'actionToBrowseClasses:') withPrefix:''
     ].
    "
!

methodImplementorsInfoFor:aMethod inEnvironment:environment
    "get something about the implementors of aMethod
     to be shown in the info line at the bottom"

    |implementors msg senders msg2|

    implementors := SystemBrowser
        findImplementorsOf:aMethod selector
        in:(environment allClasses)
        ignoreCase:false.

    implementors notEmpty ifTrue:[
        msg := 'Only implemented here.'.
        implementors remove:aMethod ifAbsent:nil.
        implementors notEmpty ifTrue:[
            implementors := implementors collect:[:mthd | mthd mclass ? mthd getMclass].
            implementors notEmpty ifTrue:[
                msg := 'Also ',(self asLink:'implemented' to:(self actionToBrowseImplementorsOf:aMethod selector)),' in '.
                msg := msg , (self infoStringForClasses:implementors withPrefix:'other ').
                msg := msg , '.'.
            ]
        ].
    ].

false ifTrue:[  "/ too slow
    senders := SystemBrowser
        findSendersOf:aMethod selector
        in:(environment allClasses)
        ignoreCase:false.
    senders notEmpty ifTrue:[
        msg2 := 'Sent from ' , senders size printString, ' methods.'.
    ] ifFalse:[
        msg2 := 'No senders.'.
    ].
    msg := msg , '/' , msg2
].

    ^ msg
!

methodInheritanceInfoFor:aMethod
    |methodsSuperclass inheritedClass msg methodsClass sel mthd selectorString|

    methodsClass := aMethod mclass.
    methodsClass isNil ifTrue:[^ nil].

    methodsSuperclass := methodsClass superclass.
    methodsSuperclass isNil ifTrue:[^ nil].

    sel := aMethod selector.
    inheritedClass := methodsSuperclass whichClassIncludesSelector:sel.
    inheritedClass notNil ifTrue:[
        mthd := inheritedClass compiledMethodAt:sel.
        (mthd sendsSelector:#'subclassResponsibility') ifTrue:[
            msg := '%1 overrides subclassResponsibility in %2'.
        ] ifFalse:[
            msg := '%1 overrides implementation in %2'.
        ].
        selectorString := sel contractTo:30.
        ^ msg 
            bindWith:(self 
                        asLink:selectorString "allBold" 
                        info:('Browse all implementors of %1' bindWith:selectorString)
                        to:(self actionToOpenMethodFinderFor:sel)) 
            with:(self 
                    asLink:inheritedClass name "allBold" 
                    info:('Browse %1  %2' bindWith:inheritedClass name with:sel)
                    to:(self actionToBrowseClass:inheritedClass selector:sel)).
    ].

    ^ msg

    "Modified: / 05-02-2017 / 01:24:25 / cg"
!

methodRedefinitionInfoFor:aMethod
    "return a user readable string telling in how many subclasses
     a method is redefined.
     To be shown in the info line of a browser"
     
    |redefiningClasses msg methodsClass|

    methodsClass := aMethod mclass.
    methodsClass isNil ifTrue:[^ nil].

    redefiningClasses := methodsClass allSubclasses select:[:eachClass | eachClass includesSelector:aMethod selector].
    redefiningClasses size ~~ 0 ifTrue:[
        msg := 'redefined in '.
        msg := msg , (self 
                        infoStringForClasses:redefiningClasses 
                        withPrefix:'sub'
                        actionGenerator:[:classes | 
                            classes size == 1 ifTrue:[
                                |cls|

                                cls := classes first.
                                self 
                                    actionToBrowseClass:cls 
                                    selector:aMethod selector 
                                    info:('Browse implementation in %1' bindWith:cls name)
                            ] ifFalse:[
                                self
                                    actionToBrowseImplementorsOf:aMethod selector 
                                    in:classes
                            ].    
                        ]).
        msg := msg , '.'.
    ].

    ^ msg
!

methodSendersInfoFor:selector inEnvironment:environment
    "get something about the senders of a message.
     to be shown in the info line at the bottom.
     This may be slow; so think about doing it in background..."

    |senders|

    senders := SystemBrowser
                findSendersOf:selector
                in:(environment allClasses)
                ignoreCase:false
                match:false.

    senders notEmpty ifTrue:[
        ^ 'Sent from ' , senders size printString, ' methods.'.
    ] ifFalse:[
        ^ 'No senders.'.
    ].
!

methodSpecialInfoFor:aMethod
    "handles special cases - such as documentation methods"

    |cls sel|

    (cls := aMethod mclass) isNil ifTrue:[^ nil].
    (sel := aMethod selector) isNil ifTrue:[^ nil].

    cls isMeta ifTrue:[
        (AbstractSourceCodeManager isVersionMethodSelector:sel) ifTrue:[
            ^ 'The version method is required for the source code repository - do not modify.'.
        ].
        sel == #documentation ifTrue:[
            ^ 'ST/X stores documentation in this method (not in comment slots)'.
        ].
    ].
    ^ nil
!

thisOrNewBrowserInto:aTwoArgBlock
    "if I am invoked by a browser, 
     invoke the twoArgBlock withit and an #newBuffer arg.
     Otherwise, create a new (invisible) browser and pass it to the block
     with a #newBrowser arg."
     
    |windowGroupClass browserClass wg app|
    
    "/ stupid: I am in libcomp; should be in libtool
    windowGroupClass := Smalltalk at:#WindowGroup.
    windowGroupClass isNil ifTrue:[^ self].
    browserClass := Smalltalk at:#'Tools::NewSystemBrowser'.
    browserClass isNil ifTrue:[^ self].
    
    ((wg := windowGroupClass activeGroup) notNil
        and:[ (app := wg application) isKindOf:browserClass ]
    ) ifTrue:[
        ^ aTwoArgBlock value:app value:#newBuffer
    ].        
    ^ aTwoArgBlock value:(browserClass basicNew) value:#newBrowser
! !

!Explainer::ActionWithInfo class methodsFor:'instance creation'!

block:aBlock info:info
    ^ self new block:aBlock info:info
! !

!Explainer::ActionWithInfo methodsFor:'accessing'!

block:blockArg info:infoArg 
    block := blockArg.
    info := infoArg.
!

info:something
    info := something.
! !

!Explainer::ActionWithInfo methodsFor:'evaluation'!

info
    ^ info
!

value
    ^ block value
!

value:arg
    ^ block value:arg
! !

!Explainer class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

