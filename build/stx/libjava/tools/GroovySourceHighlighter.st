"
 COPYRIGHT (c) 1996-2015 by Claus Gittinger

 New code and modifications done at SWING Research Group [1]:

 COPYRIGHT (c) 2010-2015 by Jan Vrany, Jan Kurs and Marcel Hlopko
                            SWING Research Group, Czech Technical University in Prague

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 [1] Code written at SWING Research Group contains a signature
     of one of the above copright owners. For exact set of such code,
     see the differences between this version and version stx:libjava
     as of 1.9.2010
"
"{ Package: 'stx:libjava/tools' }"

"{ NameSpace: Smalltalk }"

Object subclass:#GroovySourceHighlighter
	instanceVariableNames:'preferences cachedStringEmphasis cachedStringColor sourceText
		sourceIndex'
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Groovy-Tools-Source'
!

GroovyScanner subclass:#Scanner
	instanceVariableNames:'buffer bufferFirst bufferLast highlighter'
	classVariableNames:''
	poolDictionaries:''
	privateIn:GroovySourceHighlighter
!

!GroovySourceHighlighter class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1996-2015 by Claus Gittinger

 New code and modifications done at SWING Research Group [1]:

 COPYRIGHT (c) 2010-2015 by Jan Vrany, Jan Kurs and Marcel Hlopko
                            SWING Research Group, Czech Technical University in Prague

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 [1] Code written at SWING Research Group contains a signature
     of one of the above copright owners. For exact set of such code,
     see the differences between this version and version stx:libjava
     as of 1.9.2010

"
!

documentation
"
    A syntax highligter for Groovy. This highlighter is SmallSense-aware and
    supports incremental highlighting.
    However, it does only lexical highlighting. I.e. it has no idea of Groovy syntax,
    and only cares for keywords vs. non-keywords.
    Definitely needs improvement.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!GroovySourceHighlighter class methodsFor:'formatting'!

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

formatMethod:source in:class

    ^self formatMethod: nil source: source in: class using: UserPreferences current

    "Created: / 02-10-2013 / 14:37:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

formatMethod:source in:class using: preferences

    ^self new formatMethod:nil source:source in:class using: preferences

    "Created: / 02-10-2013 / 14:37:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
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
! !

!GroovySourceHighlighter methodsFor:'formatting'!

formatClassDefinition:source in:class
    preferences isNil ifTrue:[
        "/ The `...codeViewThene ? UserPreferences current` trick below is 
        "/ there to make this code working with both old and editor-thene-aware 
        "/ code. Will wanish as soon as editor thene support will be
        "/ integrated.
        preferences := UserPreferences current codeViewTheme ? UserPreferences current. 
    ].
    ^ self format: source

    "Created: / 04-08-2011 / 23:44:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-12-2017 / 21:15:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

formatClassDefinition:source in:class elementsInto: els

    sourceIndex := els.
    ^self formatClassDefinition:source in:class

    "Created: / 04-08-2011 / 23:44:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

formatExpression:source in:class

    preferences isNil ifTrue:[
        "/ The `...codeViewThene ? UserPreferences current` trick below is 
        "/ there to make this code working with both old and editor-thene-aware 
        "/ code. Will wanish as soon as editor thene support will be
        "/ integrated.
        preferences := UserPreferences current codeViewTheme ? UserPreferences current.
     ].
    ^ self format: source

    "Created: / 04-08-2011 / 23:45:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-12-2017 / 21:15:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

formatExpression:source in:class elementsInto: els

    sourceIndex := els.
    ^self formatExpression:source in:class

    "Created: / 04-08-2011 / 23:43:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

formatMethod:mth source:source in:class using: prefs
    preferences := prefs.
    preferences isNil ifTrue:[
        "/ The `...codeViewThene ? UserPreferences current` trick below is 
        "/ there to make this code working with both old and editor-thene-aware 
        "/ code. Will wanish as soon as editor thene support will be
        "/ integrated.
        preferences := UserPreferences current codeViewTheme ? UserPreferences current.
    ].
    ^ self format: source

    "Created: / 04-08-2011 / 23:45:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-12-2017 / 21:15:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
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
    "Modified: / 05-12-2017 / 21:16:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

formatMethod:mthd source:newCode line: line number: lnr in:cls using:syntaxPreferences
    | scanner |

    line isEmptyOrNil ifTrue:[ ^  nil ].

    sourceText := line asText.
    preferences := syntaxPreferences.
    preferences isNil ifTrue:[
 preferences isNil ifTrue:[
        "/ The `...codeViewThene ? UserPreferences current` trick below is 
        "/ there to make this code working with both old and editor-thene-aware 
        "/ code. Will wanish as soon as editor thene support will be
        "/ integrated.
        preferences := UserPreferences current codeViewTheme ? UserPreferences current.
    ].      ]. 
    scanner := Scanner for: line asString.
    scanner highlighter: self.
    Error ignoreIn:[
        [ scanner nextToken ~~ #EOF ] whileTrue.
    ].
    ^ sourceText

    "Created: / 04-08-2013 / 00:26:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-12-2017 / 21:16:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GroovySourceHighlighter methodsFor:'formatting-private'!

format: source
    "Simple formatting based on lexical structure only"

    | scanner token lastToken0 lastToken1 lastValue0 lastValue1 lastPosition0 lastPosition1 |

    sourceText := source string asText.         "make new text"
    scanner := Scanner for: source string.
    scanner highlighter: self.
    [
        [ (token := scanner nextToken) ~~ #EOF ] whileTrue:[
            "/ Here, try to guess what's selector...
            token == $( ifTrue:[
                lastPosition0 == #Identifier ifTrue:[
                    self markSelectorFrom: lastPosition0  to: lastPosition0 + lastValue0 size - 1.
                ].
            ].

            lastToken1 := lastToken0.
            lastValue1 := lastValue0.
            lastPosition1  := lastPosition0.

            lastToken0 := token.
            lastValue0 := scanner tokenValue.
            lastPosition0 := scanner tokenStartPosition.
        ].
    ] on: Error do:[:ex|
    ].   
    ^ sourceText

    "Created: / 02-10-2013 / 14:40:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-10-2013 / 20:27:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GroovySourceHighlighter methodsFor:'queries'!

doLexicalHighlightingOnly
    ^ true

    "Created: / 09-09-2013 / 02:25:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-10-2013 / 14:28:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GroovySourceHighlighter methodsFor:'syntax detection'!

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

!GroovySourceHighlighter::Scanner methodsFor:'accessing'!

highlighter
    ^ highlighter
!

highlighter:aGroovySyntaxHighlighter
    highlighter := aGroovySyntaxHighlighter.
! !

!GroovySourceHighlighter::Scanner methodsFor:'error handling'!

syntaxError:aMessage position:position to:endPos
    "a syntax error happened"

    endPos notNil ifTrue:[
        highlighter markBadIdentifierFrom:position to: endPos.
    ]

    "Created: / 13-04-2012 / 18:31:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GroovySourceHighlighter::Scanner methodsFor:'initialization'!

initialize
    "initialize the scanner"

    super initialize.
    saveComments := true.
    buffer := Array new: 3.
    bufferFirst := 1.
    bufferLast := 0.

    "Created: / 17-03-2012 / 00:02:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-09-2013 / 18:51:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GroovySourceHighlighter::Scanner methodsFor:'private'!

checkForKeyword:string
    | isKW |

    isKW := super checkForKeyword:string.
    isKW ifTrue:[
        highlighter markKeyword:string from:tokenStartPosition + 1 to:tokenStartPosition + string size.
        ^ true.
    ].

    (#( "/ Extra groovy keywords
        'def' 
    ) includes: string) ifTrue:[
        highlighter markKeyword:string from:tokenStartPosition + 1 to:tokenStartPosition + string size.
        ^ true.
    ].
    ^ false

    "Created: / 17-03-2012 / 00:15:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-10-2013 / 14:44:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GroovySourceHighlighter::Scanner methodsFor:'reading next token'!

nextToken
    | t |

    t := super nextToken.
    t == #String ifTrue:[
        highlighter markStringFrom:tokenStartPosition + 1 to: tokenEndPosition + 1.  
    ] ifFalse:[
    t == #Integer ifTrue:[
        highlighter markConstantFrom:tokenStartPosition + 1 to: tokenEndPosition + 1.
    ]].
    bufferLast := (bufferLast \\ buffer size) + 1.
    bufferLast == bufferFirst ifTrue:[
        bufferFirst := (bufferFirst \\ buffer size) + 1.
    ].
    buffer at: bufferLast put: self token.
    "/ Now, do a quick check for some common token sequences...not a full parsing,
    "/ but helps a bit
    ((bufferLast - bufferFirst) \\ 10) > 2 ifTrue:[
        "/ Quick check for method call sequence...
"/        t == $( ifTrue:[
"/
"/            ((buffer at:(bufferLast - 1) \\ buffer size) type == #Identifier
"/                and:[(buffer at:(bufferLast - 2) \\ buffer size) type == $.
"/                and:[(buffer at:(bufferLast - 1) \\ buffer size) value first isLowercase]])
"/                ifTrue:[
"/                    | nameToken |
"/    
"/                    nameToken := (buffer at:(bufferLast - 1) \\ buffer size).
"/                    highlighter markSelector: nameToken value from: nameToken startPosition to: nameToken endPosition.
"/                    ^ t
"/                ].
"/        ].
        "/ Add more patterns here
    ].

    ^ t

    "Created: / 14-05-1998 / 15:48:04 / cg"
    "Modified: / 16-05-1998 / 19:12:29 / cg"
    "Created: / 17-03-2012 / 19:15:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-09-2013 / 00:04:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

skipComment
    super skipComment.
    highlighter markCommentFrom:((tokenStartPosition + 1) max: 1) to: source position.
    ^nil

    "Created: / 17-03-2012 / 00:04:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

skipEOLComment
    super skipEOLComment.
    highlighter markCommentFrom:((tokenStartPosition - 1) max: 1) to: source position.
    ^nil

    "Created: / 17-03-2012 / 00:05:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GroovySourceHighlighter class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

