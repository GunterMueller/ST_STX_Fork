"{ Package: 'stx:libjava/tools' }"

"{ NameSpace: Smalltalk }"

Object subclass:#JavaAbstractSourceHighlighter
	instanceVariableNames:'preferences cachedStringEmphasis cachedStringColor sourceText
		sourceIndex'
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Tools-Source'
!


!JavaAbstractSourceHighlighter class methodsFor:'formatting'!

formatClass: javaClass

    ^self new formatClassDefinition: javaClass source in: javaClass

    "Created: / 15-12-2011 / 21:54:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

formatClassDefinition:source in:class

    ^self new formatClassDefinition:source in:class

    "Created: / 04-08-2011 / 23:44:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

formatClassDefinition:source in:class elementsInto: elements

    ^self new formatClassDefinition:source in:class elementsInto: elements

    "Created: / 04-08-2011 / 23:44:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

formatExpression:source in:class

    ^self new formatExpression:source in:class

    "Created: / 04-08-2011 / 23:45:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

formatExpression:source in:class elementsInto: elements

    ^self new formatExpression:source in:class elementsInto: elements

    "Created: / 04-08-2011 / 23:43:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

formatMethod:mth source:source in:class

    ^self formatMethod: mth source: source in: class using: UserPreferences current

    "Created: / 11-02-2012 / 18:18:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

formatMethod:mth source:source in:class using: preferences

    ^self new formatMethod:mth source:source in:class using: preferences

    "Created: / 04-08-2011 / 23:45:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

formatMethod:mth source:source in:class using: preferences elementsInto: elements

    ^self new formatMethod:mth source:source in:class using: preferences elementsInto: elements

    "Created: / 04-08-2011 / 23:42:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

formatMethod:mthd source:newCode line: line number: lnr in:cls using:syntaxPreferences
    ^ self new formatMethod:mthd source:newCode line: line number: lnr in:cls using:syntaxPreferences

    "Created: / 25-06-2014 / 12:50:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaAbstractSourceHighlighter class methodsFor:'queries'!

isAbstract
    "Return if this class is an abstract class.
     True is returned here for myself only; false for subclasses.
     Abstract subclasses must redefine again."

    ^ self == JavaAbstractSourceHighlighter.
! !

!JavaAbstractSourceHighlighter methodsFor:'formatting'!

formatClassDefinition:arg1 in:arg2
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

formatClassDefinition:source in:class elementsInto: els

    sourceIndex := els.
    ^self formatClassDefinition:source in:class

    "Created: / 04-08-2011 / 23:44:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

formatExpression:source in:class
    ^ self format: source

    "Created: / 04-08-2011 / 23:45:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-10-2013 / 20:19:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

formatExpression:source in:class elementsInto: els

    sourceIndex := els.
    ^self formatExpression:source in:class

    "Created: / 04-08-2011 / 23:43:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

formatMethod:arg1 source:arg2 in:arg3 using:arg4
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

formatMethod:mth source:source in:class using: prefs elementsInto: els

    preferences := prefs.
    preferences isNil ifTrue:[
        "/ The `...codeViewThene ? UserPreferences current` trick below is 
        "/ there to make this code working with both old and editor-thene-aware 
        "/ code. Will wanish as soon as editor thene support will be
        "/ integrated.
        preferences := UserPreferences current codeViewTheme ? UserPreferences current.
    ].  
    sourceIndex := els.
    ^self formatMethod:mth source:source in:class using: prefs

    "Created: / 04-08-2011 / 23:42:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-12-2017 / 21:17:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

formatMethod:mthd source:newCode line: line number: lnr in:cls using:syntaxPreferences
    ^ self subclassResponsibility

    "Modified (comment): / 25-06-2014 / 12:49:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaAbstractSourceHighlighter methodsFor:'syntax detection'!

markArgumentIdentifierFrom:pos1 to:pos2
    self 
        markFrom:pos1 to:pos2 
        withEmphasis:(preferences argumentIdentifierEmphasis) color:(preferences argumentIdentifierColor)
!

markBadIdentifierFrom:pos1 to:pos2
    self 
        markFrom:pos1 to:pos2 
        withEmphasis:(preferences badIdentifierEmphasis) 
        color:(preferences badIdentifierColor)
!

markClassVariableIdentifierFrom:pos1 to:pos2
    self 
        markFrom:pos1 to:pos2 
        withEmphasis:(preferences classVariableIdentifierEmphasis) color:(preferences classVariableIdentifierColor)

    "Modified: / 31.3.1998 / 18:02:14 / cg"
!

markCommentFrom:pos1 to:pos2
    self 
        markFrom:pos1 to:pos2 
        withEmphasis:(preferences commentEmphasis) color:(preferences commentColor)
!

markConstantFrom:pos1 to:pos2
    self 
        markFrom:pos1 to:pos2 
        withEmphasis:(preferences constantEmphasis) color:(preferences constantColor)
!

markFrom:pos1 to:pos2 withEmphasis:fontEmp color:clrIn
    |e p2 clr|

    clr := clrIn onDevice:Screen current.

    clr = Color black ifTrue:[
        e := fontEmp
    ] ifFalse:[
        fontEmp isNil ifTrue:[
            e := (#color->clr)
        ] ifFalse:[
            e := Text addEmphasis:fontEmp to:(#color->clr).
        ]
    ].
    (p2 := pos2) isNil ifTrue:[
        p2 := sourceText size
    ] ifFalse:[
        p2 := p2 min:sourceText size
    ].
    sourceText emphasizeFrom:pos1 to:p2 with:e

    "Created: / 31.3.1998 / 13:26:53 / cg"
    "Modified: / 1.4.1998 / 12:51:56 / cg"
!

markFunctionNameFrom:pos1 to:pos2
    self 
        markFrom:pos1 to:pos2 
        withEmphasis:(preferences methodSelectorEmphasis) color:(preferences methodSelectorColor)
!

markGlobalClassIdentifierFrom:pos1 to:pos2
    self 
        markFrom:pos1 to:pos2 
        withEmphasis:(preferences globalClassIdentifierEmphasis) color:(preferences globalClassIdentifierColor)

    "Modified: / 31.3.1998 / 18:02:14 / cg"
    "Created: / 4.3.1999 / 12:53:02 / cg"
!

markGlobalIdentifierFrom:pos1 to:pos2
    self 
        markFrom:pos1 to:pos2 
        withEmphasis:(preferences globalIdentifierEmphasis) color:(preferences globalIdentifierColor)

    "Modified: / 31.3.1998 / 18:02:14 / cg"
!

markIdentifierFrom:pos1 to:pos2
    self 
        markFrom:pos1 to:pos2 
        withEmphasis:(preferences identifierEmphasis) color:(preferences identifierColor)
!

markInstVarIdentifierFrom:pos1 to:pos2
    self 
        markFrom:pos1 to:pos2 
        withEmphasis:(preferences instVarIdentifierEmphasis) color:(preferences instVarIdentifierColor)

    "Created: / 16.4.1998 / 18:35:40 / cg"
    "Modified: / 16.4.1998 / 18:37:30 / cg"
!

markKeyword:kw from:pos1 to:pos2
    |em clr|

    ( #( 'if' 'else'
         'while'
         'for'
         'do'
         'return'
         'continue'
         'break'
    ) includes:kw) ifTrue:[
        em := preferences controlFlowSelectorEmphasis. 
        clr := preferences controlFlowSelectorColor.
    ] ifFalse:[
        em := preferences jsKeywordEmphasis.
        clr := preferences jsKeywordColor.
    ].
    self 
        markFrom:pos1 to:pos2 
        withEmphasis:em color:clr

    "Modified: / 19-05-2010 / 15:07:59 / cg"
    "Modified: / 07-08-2013 / 00:28:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

markKeywordFlowFrom:pos1 to:pos2
    self 
        markFrom:pos1 to:pos2 
        withEmphasis:preferences controlFlowSelectorEmphasis
        color:preferences controlFlowSelectorColor

    "Created: / 05-09-2013 / 03:09:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

markKeywordFrom:pos1 to:pos2
    self 
        markFrom:pos1 to:pos2 
        withEmphasis:preferences jsKeywordEmphasis
        color:preferences jsKeywordColor

    "Created: / 05-09-2013 / 03:09:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

markLocalIdentifierFrom:pos1 to:pos2
    self 
        markFrom:pos1 to:pos2 
        withEmphasis:(preferences localIdentifierEmphasis) color:(preferences localIdentifierColor)
!

markProblem: problem from:pos1 to:pos2
    self 
        markFrom:pos1 to:pos2 
        withEmphasis:(preferences badIdentifierEmphasis) 
        color:(preferences badIdentifierColor)

    "Created: / 15-04-2013 / 22:23:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

markSelector:selectorString from:pos1 to:pos2 
    | fg em |

    fg := preferences selectorColor.
    em := preferences selectorEmphasis.

    self
        markFrom:pos1 to:pos2 
        withEmphasis:em color:fg

    "Modified: / 04-10-2011 / 19:48:48 / cg"
    "Modified: / 17-03-2012 / 13:26:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 17-03-2012 / 19:12:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

markSelector:selectorString from:pos1 to:pos2 receiverNode:aReceiverNodeOrNil numArgs:numArgs
    |fg selectorSymbol check ok rec em currentEnvironment currentSuperclasses currentSubclasses classToCompileFor fullSelectorCheck|

    fg := preferences selectorColor.
    em := preferences selectorEmphasis.

"/    (currentEnvironment notNil
"/    and:[ (((currentEnvironment _localVariables ? #()) contains:[:local | local name = selectorString]) 
"/          or:[((currentEnvironment _argVariables ? #()) contains:[:local | local name = selectorString])])
"/    ])
"/    ifTrue:[
"/        "/ a local call
"/    ] ifFalse:[
"/        selectorSymbol := (self translatedSmalltalkSelectorFor:selectorString numArgs:numArgs) asSymbolIfInterned.
"/        selectorSymbol isNil ifTrue:[
"/            fg := Color red.
"/        ] ifFalse:[
"/            fullSelectorCheck == true ifTrue:[
"/                aReceiverNodeOrNil notNil ifTrue:[
"/                    check := [:cls | (cls includesSelector:selectorSymbol)
"/                                     or:[cls class includesSelector:selectorSymbol]].
"/
"/                    ok := false.
"/
"/                    "/ limit search if possible
"/                    (classToCompileFor notNil
"/                     and:[aReceiverNodeOrNil isSelf or:[aReceiverNodeOrNil isSuper]]) ifTrue:[
"/                        currentSuperclasses isNil ifTrue:[
"/                            currentSuperclasses := classToCompileFor withAllSuperclasses.
"/                        ].
"/                        ok := currentSuperclasses contains:check.
"/                        (ok not and:[aReceiverNodeOrNil isSelf]) ifTrue:[
"/                            currentSubclasses isNil ifTrue:[
"/                                currentSubclasses := classToCompileFor allSubclasses.
"/                            ].
"/                            ok := currentSubclasses contains:check.
"/                        ].
"/                    ] ifFalse:[
"/                        aReceiverNodeOrNil isConstant ifTrue:[
"/                            ok := aReceiverNodeOrNil evaluate class withAllSuperclasses contains:check.
"/                        ] ifFalse:[
"/                            (aReceiverNodeOrNil isGlobal 
"/                            and:[(rec := aReceiverNodeOrNil evaluate) isBehavior]) ifTrue:[
"/                                ok := rec class withAllSuperclasses contains:check.
"/                            ] ifFalse:[
"/                                ok := Smalltalk allClasses contains:check
"/                            ]
"/                        ]
"/                    ].
"/
"/                    ok ifFalse:[
"/                        em := preferences unimplementedSelectorEmphasis.
"/                        fg := preferences unimplementedSelectorColor.
"/                    ]
"/                ]
"/            ]
"/        ].
"/    ].
    self
        markFrom:pos1 to:pos2 
        withEmphasis:em color:fg

    "Modified: / 04-10-2011 / 19:48:48 / cg"
    "Modified: / 17-03-2012 / 13:26:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

markSelectorFrom:pos1 to:pos2 
    | fg em |

    fg := preferences selectorColor.
    em := preferences selectorEmphasis.

    self
        markFrom:pos1 to:pos2 
        withEmphasis:em color:fg

    "Created: / 11-09-2013 / 05:01:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

markSelfFrom:pos1 to:pos2
    self 
        markFrom:pos1 to:pos2 
        withEmphasis:(preferences selfEmphasis) color:(preferences selfColor)
!

markStringFrom:pos1 to:pos2
    self 
        markFrom:pos1 to:pos2 
        withEmphasis:(preferences stringEmphasis) color:(preferences stringColor)
!

markUnknownIdentifierFrom:pos1 to:pos2
    self 
        markFrom:pos1 to:pos2 
        withEmphasis:(preferences unknownIdentifierEmphasis) color:(preferences unknownIdentifierColor)
!

markVariable:v from:pos to:endPos
    "support for syntaxColoring"

    |type globalValue nameSym|

    type := v type.
    (type == #BlockArg
    or:[type == #MethodArg]) ifTrue:[
        self markArgumentIdentifierFrom:pos to:endPos.
        ^ self
    ].
    (type == #BlockVariable
    or:[type == #MethodVariable]) ifTrue:[
        self markLocalIdentifierFrom:pos to:endPos.
        ^ self
    ].
    (type == #GlobalVariable) ifTrue:[
        nameSym := v name asSymbolIfInterned.
        (nameSym isNil 
        or:[(Smalltalk includesKey:nameSym) not]) ifTrue:[
            self markUnknownIdentifierFrom:pos to:endPos.
            ^ self
        ].
        globalValue := Smalltalk at:nameSym ifAbsent:nil.
        globalValue isBehavior ifTrue:[
            self markGlobalClassIdentifierFrom:pos to:endPos.
        ] ifFalse:[
            self markGlobalIdentifierFrom:pos to:endPos.
        ].
        ^ self
    ].
    (type == #ClassVariable) ifTrue:[
        self markClassVariableIdentifierFrom:pos to:endPos.
        ^ self
    ].
    (type == #InstanceVariable) ifTrue:[
        self markInstVarIdentifierFrom:pos to:endPos.
        ^ self
    ].

    self markIdentifierFrom:pos to:endPos.

    "Created: / 16.4.1998 / 18:49:34 / cg"
    "Modified: / 4.3.1999 / 12:56:13 / cg"
! !

!JavaAbstractSourceHighlighter class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

