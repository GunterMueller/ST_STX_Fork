"
 COPYRIGHT (c) 2005 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libjavascript' }"

"{ NameSpace: Smalltalk }"

JavaScriptParser subclass:#JavaScriptSyntaxHighlighter
	instanceVariableNames:'sourceText fullSelectorCheck preferences currentSuperclasses
		currentSubclasses'
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-JavaScript-Compiling & Parsing'
!

!JavaScriptSyntaxHighlighter class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2005 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!JavaScriptSyntaxHighlighter class methodsFor:'api highlighting'!

formatClassDefinition:aString in:aClass elementsInto: elements
    "format (recolor) a class definition expression in a given class.
     Return the text containing font changes and color information."

    ^ self
        format:aString 
        with:[:parser | parser classDefinition] 
        in:aClass

    "Created: / 10-04-2011 / 18:18:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-08-2012 / 22:07:57 / cg"
!

formatFileContents:aString elementsInto:elementsCollection
    "format (recolor) a file's contents.
     Return the text containing font changes and color information.
     Here, nothing is done ,just for protocol completeness"

    ^ aString
!

formatMethod:aMethodOrNil source:aString in:aClass using:preferencesOrNil elementsInto: elements
    ^ self formatMethod:aMethodOrNil source:aString in:aClass using:preferencesOrNil

    "Created: / 05-07-2011 / 10:41:14 / cg"
    "Modified: / 20-07-2011 / 16:29:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

formatMethodSource:aString in:aClass using:preferencesOrNil
    "format (recolor) a method in a given class.
     Return the text containing font changes and color information."

    ^ self formatMethod:nil source:aString in:aClass using:preferencesOrNil

    "Created: / 20-04-2018 / 15:15:13 / stefan"
! !

!JavaScriptSyntaxHighlighter class methodsFor:'highlighting'!

format:aString with:aBlock in:aClass
    "format (recolor) a method in a given class.
     Return the text containing font changes and color information."

    ^ self format:aString with:aBlock in:aClass using:nil

    "
     self
        formatMethod:'foo 
    ^ self bar:''hello''.

    ' , (Character doubleQuote asString) , 'some comment' , (Character doubleQuote asString) , '
'
        in:UndefinedObject
    "

    "Modified: / 23.10.1998 / 22:48:45 / cg"
!

format:aString with:aBlock in:aClass using:preferencesOrNil
    "format (recolor) a method in a given class.
     Return the text containing font changes and color information."

    |parser tree text endPos eColor errorHappened preferencesUsed|

    aString isNil ifTrue:[^ nil].
    errorHappened := false.
    preferencesUsed := preferencesOrNil ? UserPreferences current.

    Error handle:[:ex |
        ex creator ~~ ParseError ifTrue:[
            ex reject.
        ].

        "Parse error may happen when re-formatting incomplete code while editing"
        "/ ('SyntaxHighlighter [info]: error during highlight: ' , ex description) infoPrintCR.
        "/ ex suspendedContext fullPrintAll.
        errorHappened := true
    ] do:[
        parser := self for:(ReadStream on:aString string) in:aClass.
        parser preferences:preferencesUsed.
        parser ignoreErrors:true.
        parser ignoreWarnings:true.
        parser sourceText:(text := aString string asText).
        "/ use an array here - this can be changed much faster using #at:put:
        text emphasisCollection:(Array new:aString size).

        parser nextToken.
        tree := aBlock value:parser.
        "/ now, convert the emphasis-array to a runArray
        text emphasisCollection:(text emphasis asRunArray).

        errorHappened := tree == #Error.
    ].
    errorHappened ifTrue:[
        eColor := preferencesUsed errorColor.
        eColor notNil ifTrue:[
            "/ mhmh - which is better ...
            "/ alternative1: color rest after error in red
            text 
                emphasizeFrom:(parser sourceStream position + 1 min:parser tokenPosition) 
                to:text size 
                with:(#color->eColor).
        ] ifFalse:[
            "/ alternative2: take original emphasis for rest

            endPos := parser sourceStream position + 1.
            endPos >= text size ifTrue:[
                ^ text
            ].
            ^ (text copyTo:endPos) , (aString copyFrom:(endPos+1))
        ].
        "/ alternative3: no emphasis for rest.
    ].
    ^ text

    "
     self
        formatMethod:'foo 
    ^ self bar:''hello''.

    ' , (Character doubleQuote asString) , 'some comment' , (Character doubleQuote asString) , '
'
        in:UndefinedObject
    "

    "Modified (comment): / 26-04-2012 / 12:16:44 / cg"
!

formatClassDefinition:aString in:aClass
    "format (recolor) a class definition expression in a given class.
     Return the text containing font changes and color information."

    ^ self
        format:aString 
        with:[:parser | parser classDefinition] 
        in:aClass
!

formatExpression:aString in:aClass
    "format (recolor) an expression in a given class.
     Return the text containing font changes and color information."

    ^ self
        format:aString 
        with:[:parser | parser expression] 
        in:aClass

    "
     self
        formatExpression:'(1 + 2) max:5' 
        in:UndefinedObject
    "
!

formatExpression:aString in:aClass elementsInto:elementsCollection
    ^ self formatExpression:aString in:aClass

    "Created: / 04-10-2011 / 19:47:03 / cg"
!

formatMethod:aString in:aClass
    "format (recolor) a method in a given class.
     Return the text containing font changes and color information."

    ^ self
        format:aString 
        with:[:parser | parser functionOrStaticFunction:true] 
        in:aClass
!

formatMethod:aMethod source:aString in:aClass
    ^ self formatMethod:aMethod source:aString in:aClass using:nil

    "Created: / 30-01-2011 / 16:18:28 / cg"
!

formatMethod:aMethod source:aString in:aClass using:preferencesOrNil
    "format (recolor) a method in a given class.
     Return the text containing font changes and color information."

    ^ self
        format:aString 
        with:[:parser | parser functionOrStaticFunction:true] 
        in:aClass
        using:preferencesOrNil

    "Created: / 05-10-2011 / 23:23:29 / cg"
    "Modified: / 20-04-2018 / 15:24:13 / stefan"
!

formatStatementList:aString in:aClass elementsInto: elements
    "format (recolor) a statement list in a given class.
     Return the text containing font changes and color information."

    ^ self 
        format:aString with:[:parser | parser statementBlockBody]
        in:aClass

    "
     self
        formatStatementList:'(1 + 2) max:5. 1 + 2' 
        in:UndefinedObject
        elementsInto:(OrderedCollection new).
    "

    "Created: / 07-11-2013 / 21:34:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaScriptSyntaxHighlighter methodsFor:'accessing'!

preferences:something
    preferences := something.
!

sourceText
    "return the value of the instance variable 'sourceText' (automatically generated)"

    ^ sourceText

    "Created: / 31.3.1998 / 11:49:05 / cg"
!

sourceText:something
    "set the value of the instance variable 'sourceText' (automatically generated)"

    sourceText := something.

    "Created: / 31.3.1998 / 11:49:05 / cg"
! !

!JavaScriptSyntaxHighlighter methodsFor:'error handling'!

parseError:aMessage position:position to:endPos
    super parseError:aMessage position:position to:endPos.

    self 
        markFrom:position to:endPos 
        withEmphasis:nil color:UserPreferences current errorColor
! !

!JavaScriptSyntaxHighlighter methodsFor:'initialization'!

initialize
    super initialize.

    foldConstants := false.

    preferences := preferences ? UserPreferences current.

    fullSelectorCheck := preferences fullSelectorCheck.
! !

!JavaScriptSyntaxHighlighter methodsFor:'private'!

isSyntaxHighlighter
    ^ true
!

isUnknownGlobal:nameSym
    ^ nameSym isNil or:[(Smalltalk includesKey:nameSym) not]

    "Created: / 15-08-2017 / 16:39:10 / cg"
! !

!JavaScriptSyntaxHighlighter methodsFor:'syntax detection'!

markArgumentIdentifierFrom:pos1 to:pos2
    self 
        markFrom:pos1 to:pos2 
        withEmphasis:(preferences argumentIdentifierEmphasis) color:(preferences argumentIdentifierColor)
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
    AbstractSyntaxHighlighter
        mark:sourceText from:pos1 to:pos2 withEmphasis:fontEmp color:clrIn

    "Created: / 31-03-1998 / 13:26:53 / cg"
    "Modified: / 01-06-2012 / 21:48:21 / cg"
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
    "keywords get a special color"

    |isControl em clr|

    "/ not all keywords are control keywords (there are others such as 'var', 'in' etc.)
    isControl := ( 
                    #( 
                        'if' 'else'
                        'while'
                        'for'
                        'do'
                        'return'
                        'from'
                        'try' 'catch' 'finally'
                        'switch' 'case' 'default'
                    ) includes:kw).

    isControl ifTrue:[
        em := preferences controlFlowSelectorEmphasis. 
        clr := preferences controlFlowSelectorColor.
    ].
    em isNil ifTrue:[
        em := preferences jsKeywordEmphasis.
    ].
    clr isNil ifTrue:[
        clr := preferences jsKeywordColor.
    ].
    self 
        markFrom:pos1 to:pos2 
        withEmphasis:em color:clr

    "Modified: / 14-02-2012 / 16:00:58 / cg"
!

markLocalIdentifierFrom:pos1 to:pos2
    self 
        markFrom:pos1 to:pos2 
        withEmphasis:(preferences localIdentifierEmphasis) color:(preferences localIdentifierColor)
!

markSelector:selectorString from:pos1 to:pos2 receiverNode:aReceiverNodeOrNil numArgs:numArgs
    |fg selectorSymbol check ok rec em|

    fg := preferences selectorColor.
    em := preferences selectorEmphasis.

    (currentEnvironment notNil
    and:[ (((currentEnvironment _localVariables ? #()) contains:[:local | local name = selectorString]) 
          or:[((currentEnvironment _argVariables ? #()) contains:[:local | local name = selectorString])])
    ])
    ifTrue:[
        "/ a local call
    ] ifFalse:[
        selectorSymbol := (self translatedSmalltalkSelectorFor:selectorString numArgs:numArgs) asSymbolIfInterned.
        selectorSymbol isNil ifTrue:[
            fg := Color red.
        ] ifFalse:[
            ok := true.

            fullSelectorCheck == true ifTrue:[
                aReceiverNodeOrNil notNil ifTrue:[
                    check := [:cls | (cls includesSelector:selectorSymbol)
                                     or:[cls class includesSelector:selectorSymbol]].

                    ok := false.

                    "/ limit search if possible
                    (classToCompileFor notNil
                     and:[aReceiverNodeOrNil isSelf or:[aReceiverNodeOrNil isSuper]]) ifTrue:[
                        currentSuperclasses isNil ifTrue:[
                            currentSuperclasses := classToCompileFor withAllSuperclasses.
                        ].
                        ok := currentSuperclasses contains:check.
                        (ok not and:[aReceiverNodeOrNil isSelf]) ifTrue:[
                            currentSubclasses isNil ifTrue:[
                                currentSubclasses := classToCompileFor allSubclasses.
                            ].
                            ok := currentSubclasses contains:check.
                        ].
                    ] ifFalse:[
                        aReceiverNodeOrNil isConstant ifTrue:[
                            ok := aReceiverNodeOrNil evaluate class withAllSuperclasses contains:check.
                        ] ifFalse:[
                            (aReceiverNodeOrNil isGlobal 
                            and:[(rec := aReceiverNodeOrNil evaluate) isBehavior]) ifTrue:[
                                ok := rec class withAllSuperclasses contains:check.
                            ] ifFalse:[
                                ok := Smalltalk allClasses contains:check
                            ]
                        ]
                    ].
                ]
            ].


            ok ifFalse:[
                em := preferences unimplementedSelectorEmphasis ? em.
                fg := preferences unimplementedSelectorColor ? fg.
            ] ifTrue:[
                (AbstractSyntaxHighlighter isControlFlowSelector:selectorSymbol) ifTrue:[
                    em := preferences controlFlowSelectorEmphasis ? em.
                    fg := preferences controlFlowSelectorColor ? fg
                ] ifFalse:[
                    (AbstractSyntaxHighlighter collectionEnumerationSelectors includesIdentical:selectorSymbol) ifTrue:[
                        em := preferences collectionEnumerationSelectorEmphasis ? em.
                        fg := preferences collectionEnumerationSelectorColor ? fg
                    ] ifFalse:[
                        (AbstractSyntaxHighlighter debugSelectors includesIdentical:selectorSymbol) ifTrue:[
                            em := preferences debugSelectorEmphasis ? em.
                            fg := preferences debugSelectorColor ? fg
                        ] ifFalse:[
                            (AbstractSyntaxHighlighter errorRaisingSelectors includesIdentical:selectorSymbol) ifTrue:[
                                em := preferences errorRaisingSelectorEmphasis ? em.
                                fg := preferences errorRaisingSelectorColor ? fg
                            ].
                        ].
                    ].
                ].
            ].
        ].
    ].
    self
        markFrom:pos1 to:pos2 
        withEmphasis:em color:fg

    "Modified: / 04-10-2011 / 19:48:48 / cg"
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

markSuperFrom:pos1 to:pos2
    self 
        markFrom:pos1 to:pos2 
        withEmphasis:(preferences superEmphasis) 
        color:(preferences superColor)
!

markUnknownIdentifierFrom:pos1 to:pos2
    self 
        markFrom:pos1 to:pos2 
        withEmphasis:(preferences unknownIdentifierEmphasis) color:(preferences unknownIdentifierColor)
!

markVariable:v
    "support for syntaxColoring"

    |pos endPos|

    pos := tokenPosition.
    endPos := pos+tokenName size-1.
    self markVariable:v from:pos to:endPos
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
        (self isUnknownGlobal:nameSym) ifTrue:[
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

    "Created: / 16-04-1998 / 18:49:34 / cg"
    "Modified: / 15-08-2017 / 16:39:29 / cg"
! !

!JavaScriptSyntaxHighlighter class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libjavascript/JavaScriptSyntaxHighlighter.st,v 1.34 2018-05-18 02:27:38 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjavascript/JavaScriptSyntaxHighlighter.st,v 1.34 2018-05-18 02:27:38 cg Exp $'
! !

