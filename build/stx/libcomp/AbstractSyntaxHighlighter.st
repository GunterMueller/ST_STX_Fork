"
 COPYRIGHT (c) 2006 by eXept Software AG
 COPYRIGHT (c) 2016-2017 Jan Vrany
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

Parser subclass:#AbstractSyntaxHighlighter
	instanceVariableNames:'method sourceText preferences fullSelectorCheck commentColor
		commentEmphasis constantColor constantEmphasis'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Compiler'
!

!AbstractSyntaxHighlighter class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 by eXept Software AG
 COPYRIGHT (c) 2016-2017 Jan Vrany
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
    common superclass for (smalltalk-) syntax highlighting.

    This will parse the source code and update the local copy of the
    sourceText (in that instvar) by changing emphasis and color,
    as syntax elements are encountered.
    This is done by redefining appropriate markXXX methods, which are
    called by the parser whenever an interesting syntactic construct is encountered.
    These methods are no-ops in the Parser class, but redefined here to update
    the colorization of sourceText.

    Caveat:
        used to be a smalltalk syntax highlighter and therefore (wrongly) subclassed Parser.
        However, over time, much functionality was added, which is of use for other languages also
        and this class will therefore be changed to use composition and have parsing delegated.
        to be independent of the language and to not inherit stuff, which is not needed.
"
! !

!AbstractSyntaxHighlighter class methodsFor:'api highlighting'!

formatClassDefinition:aString in:aClass
    "format (recolor) a class definition expression in a given class.
     Return the text containing font changes and color information."

    ^ self formatExpression:aString in:aClass
!

formatClassDefinition:aString in:aClass elementsInto: elements
    "format (recolor) a class definition expression in a given class.
     Return the text containing font changes and color information."

    ^ self formatExpression:aString in:aClass

    "Created: / 10-04-2011 / 18:18:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

formatExpression:aString in:aClass
    "format (recolor) an expression in a given class.
     Return the text containing font changes and color information."

    |parser tree text|

    aString isNil ifTrue:[^ nil].

    parser := self for:(ReadStream on:aString string) in:aClass.
    parser ignoreErrors:true.
    parser ignoreWarnings:true.
    parser sourceText:(text := aString string asText).
    "/ use an array here - this can be changed much faster using #at:put:
    text emphasisCollection:(Array new:aString size).

    parser nextToken.
    tree := parser expression.
    "/ now, convert the emphasis-array to a runArray
    text emphasisCollection:(text emphasis asRunArray).

    tree == #Error ifTrue:[
        ^ self colorize:text forErrorAtPosition:parser sourceStream position withOriginal:aString.
    ].
    ^ text

    "
     self
        formatExpression:'(1 + 2) max:5'
        in:UndefinedObject
    "

    "Modified: / 7.4.1998 / 09:57:19 / cg"
    "Created: / 9.4.1998 / 16:57:16 / cg"
!

formatMethod:aString in:aClass
    <resource: #obsolete>
    "format (recolor) a method in a given class.
     Return the text containing font changes and color information."

    self obsoleteMethodWarning:'use #formatMethodSource:in:'.
    ^ self formatMethod:nil source:aString in:aClass using:nil

    "
     self
	formatMethod:'foo
    ^ self bar:''hello''.

    ' , (Character doubleQuote asString) , 'some comment' , (Character doubleQuote asString) , '
'
	in:UndefinedObject
    "

    "Modified: / 28-04-2010 / 13:03:04 / cg"
!

formatMethod:aString in:aClass using:preferencesOrNil
    <resource: #obsolete>
    "format (recolor) a method in a given class.
     Return the text containing font changes and color information."

    self obsoleteMethodWarning:'use #formatMethodSource:in:using:'.
    ^ self formatMethod:nil source:aString in:aClass using:preferencesOrNil

    "Modified: / 28-04-2010 / 13:03:15 / cg"
!

formatMethod:methodOrNil source:aString in:aClass
    "format (recolor) a method in a given class.
     Return the text containing font changes and color information."

    ^ self formatMethod:methodOrNil source:aString in:aClass using:nil

    "
     self
	formatMethod:'foo
    ^ self bar:''hello''.

    ' , (Character doubleQuote asString) , 'some comment' , (Character doubleQuote asString) , '
'
	in:UndefinedObject
    "

    "Created: / 28-04-2010 / 13:44:24 / cg"
!

formatMethod:methodOrNil source:aString in:aClass using:preferencesOrNil
    "format (recolor) a method in a given class.
     Return the text containing font changes and color information."

    |highlighter tree newText|

    aString isNil ifTrue:[^ nil].

    Error handle:[:ex |
        "/ Transcript showCR:ex description.
        self breakPoint:#cg.

        (ParseError handles:ex) ifFalse:[
            ex creator isHandled ifTrue:[
                "/ Transcript showCR:'handled' .
                ex reject.
            ].
            "Parse error may happen when re-formatting incomplete code while editing"
"/            ('SyntaxHighlighter [info]: error during highlight: ' , ex description) infoPrintCR.
            "/ ex suspendedContext fullPrintAll.
        ].
        highlighter notNil ifTrue:[
            ^ self colorize:(newText ? aString) forErrorAtPosition:highlighter sourceStream position withOriginal:aString
        ].
        ^ aString
    ] do:[
        |sourceString|

        sourceString := aString string.
        newText := sourceString asUnicode16String asText.
        "/ use an array here (instead of the RunArray) - this can be changed much faster using #at:put:
        newText emphasisCollection:(Array new:sourceString size).

        highlighter := self for:(ReadStream on:aString string) in:aClass.
        highlighter method:methodOrNil.
        preferencesOrNil notNil ifTrue:[highlighter preferences:preferencesOrNil].
        "/ highlighter ignoreErrors:true.
        highlighter ignoreWarnings:true.
        highlighter sourceText:newText.

        tree := highlighter parseMethod.
        newText := highlighter sourceText.  "/ might have changed identity
        "/ now, convert the emphasis-array to a runArray
        newText emphasisCollection:(newText emphasis asRunArray).

        tree == #Error ifTrue:[
            ^ self colorize:newText forErrorAtPosition:highlighter sourceStream position withOriginal:aString.
        ].
        ^ newText
    ]

    "
     self
        formatMethod:'foo
    ^ self bar:''hello''.

    ' , (Character doubleQuote asString) , 'some comment' , (Character doubleQuote asString) , '
'
        in:UndefinedObject
    "

    "Created: / 28-04-2010 / 13:01:42 / cg"
    "Modified: / 05-07-2011 / 11:22:20 / cg"
!

formatMethodSource:aString in:aClass
    "format (recolor) a method in a given class.
     Return the text containing font changes and color information."

    ^ self formatMethod:nil source:aString in:aClass using:nil

    "
     self
	formatMethod:'foo
    ^ self bar:''hello''.

    ' , (Character doubleQuote asString) , 'some comment' , (Character doubleQuote asString) , '
'
	in:UndefinedObject
    "

    "Created: / 28-04-2010 / 12:58:13 / cg"
!

formatMethodSource:aString in:aClass using:preferencesOrNil
    "format (recolor) a method in a given class.
     Return the text containing font changes and color information."

    ^ self formatMethod:nil source:aString in:aClass using:preferencesOrNil

    "Modified: / 28-04-2010 / 13:02:11 / cg"
!

formatStatements:aString in:aClass
    "Format (recolor) a list of statements with optional temporaries in a given class.
     Return the text containing font changes and color information."

    |parser tree text|

    aString isNil ifTrue:[^ nil].

    parser := self for:(ReadStream on:aString string) in:aClass.
    parser ignoreErrors:true.
    parser ignoreWarnings:true.
    parser sourceText:(text := aString string asText).
    "/ use an array here - this can be changed much faster using #at:put:
    text emphasisCollection:(Array new:aString size).

    parser nextToken.
    tree := parser parseMethodBody.
    "/ now, convert the emphasis-array to a runArray
    text emphasisCollection:(text emphasis asRunArray).

    tree == #Error ifTrue:[
        ^ self colorize:text forErrorAtPosition:parser sourceStream position withOriginal:aString.
    ].
    ^ text

    "
     SyntaxHighlighter
        formatStatements:'| a b | a error: b'
        in:UndefinedObject
    "

    "Created: / 22-02-2016 / 20:50:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractSyntaxHighlighter class methodsFor:'highlighting'!

colorize:text forErrorAtPosition:pos withOriginal:originalString
    |eColor endPos|

    endPos := pos + 1.

    "/ mhmh - which is better ...

    "/ alternative1: colorize the rest after the error in red

    eColor := UserPreferences current errorColor.
    eColor notNil ifTrue:[
        ^ text
            emphasizeFrom:endPos 
            to:text size 
            with:(#color->eColor).
    ].

    "/ alternative2: take the original emphasis for the rest
    endPos >= text size ifTrue:[
        ^ text
    ] ifFalse:[
        ^ (text copyTo:endPos) , (originalString copyFrom:(endPos+1))
    ].

    "/ alternative3: no emphasis for rest.
    ^ text
! !

!AbstractSyntaxHighlighter class methodsFor:'misc'!

collectionEnumerationSelectors
    "these are considered wellknown, builtin selectors of very common
     collection enumeration methods.
     These are optionally shown with another color (dark green)"

    ^ #(
	collect:
	select:
	inject:into:
	count:
	collect:thenSelect:
	select:thenCollect:
    )

    "Created: / 14-02-2012 / 15:56:59 / cg"
!

controlFlowSelectors
    "these are considered wellknown, builtin selectors of very common
     control flow constructs. Correspond to syntax or special forms in other
     languages. These are optionally shown with another color (blue)"

    ^ #(
        ifTrue: ifFalse:
        ifTrue:ifFalse: ifFalse:ifTrue:
        ifNil: ifNotNil:
        ifNil:ifNotNil: ifNotNil:ifNil:
        and: or:

        whileTrue:
        whileFalse:

        to:do:
        downTo:do:
        to:by:do:

        loop
        repeat
        whileTrue
        whileFalse
        doWhile:
        doUntil:

        do:
        doWithIndex:
        pairWiseDo:
        keysAndValuesDo:

        withPriority:do:
        handle:do:
        on:do:
        catch:
        ignoreIn:

        "/ newProcess
        fork:
        ensure:
        ifCurtailed:
        valueOnUnwindDo:
        valueNowOrOnUnwindDo:

        caseOf:
        caseOf:otherwise:
    )

    "Created: / 08-09-2006 / 15:56:47 / cg"
!

debugSelectors
    "these are considered harmful if left in a deployed application:
     selectors for debugging which open a debugger (unless haltSignal is
     caught or disabled, which end-user apps should do).
     These are optionally shown with another color (redish)"

    ^ #(
	halt halt:
    )

    "Modified (comment): / 27-07-2013 / 11:45:07 / cg"
!

errorRaisingSelectors
    "these are error raisers.
     These are optionally shown with another color (red)"

    ^ #(
	error error:
	raise raiseRequest:
	raiseErrorString: raiseRequestErrorString:
	raiseWith: raiseRequestWith:
	raiseWith:errorString: raiseRequestWith:errorString:
	subclassResponsibility
	obsoleteMethodWarning obsoleteMethodWarning:
    )
!

isControlFlowSelector:aSelector
    "these are considered wellknown, builtin selectors of very common
     control flow constructs. Correspond to syntax or special forms in other
     languages. These are optionally shown with another color (blue)"

    (self controlFlowSelectors includesIdentical:aSelector) ifTrue:[^ true].

    true "((aSelector startsWith:'with') or:[ aSelector startsWith:'all'])" ifTrue:[
	((aSelector endsWith:'do:') or:[ aSelector endsWith:'Do:']) ifTrue:[
	    ^ true
	]
    ].
    ^ false.
! !

!AbstractSyntaxHighlighter class methodsFor:'queries'!

isAbstract
    ^ self == AbstractSyntaxHighlighter
! !

!AbstractSyntaxHighlighter class methodsFor:'utilities'!

mark:sourceText from:pos1 to:pos2 withAddedEmphasis:addedEmphasis
    sourceText emphasisFrom:pos1 to:pos2 add:addedEmphasis

    "Created: / 01-06-2012 / 21:43:36 / cg"
!

mark:sourceText from:pos1 to:pos2 withEmphasis:fontEmp color:clrIn
    self mark:sourceText from:pos1 to:pos2 withEmphasis:fontEmp color:clrIn font:nil
!

mark:sourceText from:pos1 to:pos2 withEmphasis:fontEmp color:clrIn font:fontIn
    "all positions are 1-based"
    
    |e p2 clr|

    (clrIn isNil or:[clrIn = Color black]) ifTrue:[
        e := fontEmp
    ] ifFalse:[
        clr := clrIn onDevice:Screen current.
        fontEmp isNil ifTrue:[
            e := (#color->clr)
        ] ifFalse:[
            e := Text addEmphasis:fontEmp to:(#color->clr).
        ]
    ].
    fontIn notNil ifTrue:[
        e := Text addEmphasis:e to:(#font->fontIn)
    ].

    (p2 := pos2) isNil ifTrue:[
        p2 := sourceText size
    ] ifFalse:[
        p2 := p2 min:sourceText size
    ].
    sourceText emphasizeFrom:pos1 to:p2 with:e

    "Created: / 01-06-2012 / 21:42:41 / cg"
    "Modified (comment): / 21-10-2017 / 14:24:20 / cg"
!

mark:sourceText from:pos1 to:pos2 withEmphasis:fontEmp color:fgClr1 ifNil:fgClr2 backgroundColor:bgClr
    |e p2 clr fgClr|

    fgClr := fgClr1 ? fgClr2.
    (fgClr isNil or:[fgClr = Color black]) ifTrue:[
	e := fontEmp
    ] ifFalse:[
	clr := fgClr onDevice:Screen current.
	fontEmp isNil ifTrue:[
	    e := (#color->clr)
	] ifFalse:[
	    e := Text addEmphasis:fontEmp to:(#color->clr).
	]
    ].
    bgClr notNil ifTrue:[
	e := Text addEmphasis:(#backgroundColor->bgClr) to:e.
    ].
    (p2 := pos2) isNil ifTrue:[
	p2 := sourceText size
    ] ifFalse:[
	p2 := p2 min:sourceText size
    ].
    sourceText emphasizeFrom:pos1 to:p2 with:e

    "Created: / 01-06-2012 / 21:44:17 / cg"
!

mark:sourceText from:pos1 to:pos2 withEmphasis:fontEmp ifNil:fontEmp2 color:fgClr1 ifNil:fgClr2 backgroundColor:bgClr
    |e p2 clr fgClr|

    fgClr := fgClr1 ? fgClr2.
    (fgClr isNil or:[fgClr = Color black]) ifTrue:[
        e := fontEmp ? fontEmp2
    ] ifFalse:[
        clr := fgClr onDevice:Screen current.
        (fontEmp ? fontEmp2) isNil ifTrue:[
            e := (#color->clr)
        ] ifFalse:[
            e := Text addEmphasis:(fontEmp ? fontEmp2) to:(#color->clr).
        ]
    ].
    bgClr notNil ifTrue:[
        e := Text addEmphasis:(#backgroundColor->bgClr) to:e.
    ].
    (p2 := pos2) isNil ifTrue:[
        p2 := sourceText size
    ] ifFalse:[
        p2 := p2 min:sourceText size
    ].
    sourceText emphasizeFrom:pos1 to:p2 with:e

    "Created: / 01-06-2012 / 21:44:17 / cg"
! !

!AbstractSyntaxHighlighter methodsFor:'accessing'!

fetchHeavilyUsedPreferenceValues
    preferences isNil ifTrue:[
        commentColor :=  commentEmphasis := nil.
        constantColor := constantEmphasis := nil.
        ^ self.
    ].
    
    commentColor := preferences commentColor.
    commentEmphasis := preferences commentEmphasis.


    constantColor := preferences constantColor.
    constantEmphasis := preferences constantEmphasis.

    "Created: / 21-10-2017 / 14:13:33 / cg"
    "Modified: / 31-05-2018 / 12:21:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

method:aMethod
    "the original method, if known (for subclasses which can make use of it)"

    method := aMethod.

    "Created: / 28-04-2010 / 13:15:33 / cg"
!

preferences: aUserPreferences
    preferences := aUserPreferences.

    fullSelectorCheck := UserPreferences current fullSelectorCheck.
    self fetchHeavilyUsedPreferenceValues.
    
    "Modified: / 21-10-2017 / 14:20:06 / cg"
    "Modified (format): / 05-12-2017 / 21:04:36 / jv"
    "Modified (format): / 05-12-2017 / 21:05:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"

!

sourceText
    "retrieve the updated source text after the highlighting process"

    ^ sourceText

    "Created: / 31.3.1998 / 11:49:05 / cg"
!

sourceText:aString
    "this text will be updated by the highlighting process"

    sourceText := aString.

    "Created: / 31-03-1998 / 11:49:05 / cg"
    "Modified: / 28-04-2010 / 13:22:27 / cg"
! !

!AbstractSyntaxHighlighter methodsFor:'error handling'!

parseError:aMessage position:position to:endPos
"/ Transcript showCR:aMessage.
    super parseError:aMessage position:position to:endPos.

    self
	markFrom:position to:endPos
	withEmphasis:nil color:UserPreferences current errorColor
!

showErrorMessage:aMessage position:pos
"/ Transcript showCR:aMessage.
    super showErrorMessage:aMessage position:pos.

    self
	markFrom:pos to:nil
	withEmphasis:nil color:UserPreferences current errorColor
!

syntaxError:aMessage position:position to:endPos
"/ Transcript showCR:aMessage.
    super syntaxError:aMessage position:position to:endPos.

    self
	markFrom:position to:endPos
	withEmphasis:nil color:UserPreferences current errorColor
!

warning:msg position:pos1 to:pos2
"/    self markUnknownIdentifierFrom:pos1 to:pos2

"/    self
"/        markFrom:pos1 to:pos2
"/        withEmphasis:nil color:UserPreferences current errorColor

    "Modified: / 25.9.1999 / 18:42:30 / cg"
! !

!AbstractSyntaxHighlighter methodsFor:'initialization'!

initialize
    <modifier: #super> "must be called if redefined"

    super initialize.

    foldConstants := false.
    "/ The `...codeViewThene ? UserPreferences current` trick below is 
    "/ there to make this code working with both old and editor-thene-aware 
    "/ code. Will wanish as soon as editor thene support will be
    "/ integrated.
    self preferences: (UserPreferences current codeViewTheme ? UserPreferences current).

    "Created: / 31-03-1998 / 15:12:55 / cg"
    "Modified: / 21-10-2017 / 14:20:11 / cg"
    "Modified: / 05-12-2017 / 21:09:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractSyntaxHighlighter methodsFor:'misc'!

collectionEnumerationSelectors
    ^ self class collectionEnumerationSelectors
!

controlFlowSelectors
    ^ self class controlFlowSelectors
!

debugSelectors
    ^ self class debugSelectors
!

defineAsUndeclaredVariable:aName
    "redefined to NOT declare undefined vars"

    ^ VariableNode globalNamed:aName

    "Modified: / 19.10.1998 / 19:38:12 / cg"
!

errorRaisingSelectors
    ^ self class errorRaisingSelectors
!

isSyntaxHighlighter
    ^ true

!

plausibilityCheck:aNode
    "redefined to NOT do checks"

    ^ nil

    "Modified: / 19.10.1998 / 19:38:12 / cg"
    "Created: / 19.10.1998 / 19:57:18 / cg"
! !

!AbstractSyntaxHighlighter methodsFor:'syntax detection'!

markCommentFrom:pos1 to:pos2
    "all positions are 1-based"

    self 
        markFrom:pos1 to:pos2 
        withEmphasis:commentEmphasis 
        color:commentColor

    "
     UserPreferences current commentEmphasis
     UserPreferences current commentColor
    "

    "Modified (comment): / 21-10-2017 / 14:24:51 / cg"
    "Modified: / 31-05-2018 / 12:21:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

markConstantFrom:pos1 to:pos2
    self 
        markFrom:pos1 to:pos2 
        withEmphasis:constantEmphasis 
        color:constantColor

    "Created: / 31-03-1998 / 18:09:22 / cg"
    "Modified: / 21-10-2017 / 14:15:48 / cg"
!

markFrom:pos1 length:len withEmphasis:fontEmp color:clrIn
    self markFrom:pos1 to:pos1+len-1 withEmphasis:fontEmp color:clrIn

    "Created: / 21-10-2017 / 14:47:46 / cg"
!

markFrom:pos1 to:pos2 withAddedEmphasis:addedEmphasis
    self class
	mark:sourceText from:pos1 to:pos2 withAddedEmphasis:addedEmphasis

    "Created: / 15-01-2008 / 11:48:18 / cg"
!

markFrom:pos1 to:pos2 withEmphasis:fontEmp color:clrIn
    self class
	mark:sourceText from:pos1 to:pos2 withEmphasis:fontEmp color:clrIn

    "Created: / 31-03-1998 / 13:26:53 / cg"
    "Modified: / 01-06-2012 / 21:43:04 / cg"
!

markFrom:pos1 to:pos2 withEmphasis:fontEmp color:clrIn font:fontInOrNil
    "all positions are 1-based"

    self class
        mark:sourceText from:pos1 to:pos2 withEmphasis:fontEmp color:clrIn font:fontInOrNil

    "Created: / 31-03-1998 / 13:26:53 / cg"
    "Modified: / 01-06-2012 / 21:43:04 / cg"
    "Modified (comment): / 21-10-2017 / 14:24:47 / cg"
!

markFrom:pos1 to:pos2 withEmphasis:fontEmp color:fgClr1 ifNil:fgClr2 backgroundColor:bgClr
    self class
	mark:sourceText from:pos1 to:pos2 withEmphasis:fontEmp color:fgClr1 ifNil:fgClr2 backgroundColor:bgClr

    "Created: / 13-02-2012 / 11:48:09 / cg"
!

markFrom:pos1 to:pos2 withEmphasis:fontEmp ifNil:fontEmp2 color:fgClr1 ifNil:fgClr2 backgroundColor:bgClr
    self class
        mark:sourceText from:pos1 to:pos2 withEmphasis:fontEmp ifNil:fontEmp2 color:fgClr1 ifNil:fgClr2 backgroundColor:bgClr

    "Created: / 13-02-2012 / 11:48:09 / cg"
!

markVariable:v
    |pos endPos|

    pos := tokenPosition.
    endPos := pos+tokenName size-1.
    self markVariable:v from:pos to:endPos assigned:false

    "Modified: / 30-11-2010 / 14:44:28 / cg"
! !

!AbstractSyntaxHighlighter class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$ Id $'
! !

