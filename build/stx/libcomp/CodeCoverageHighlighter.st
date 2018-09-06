"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 2010 by eXept Software AG
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

AbstractSyntaxHighlighter subclass:#CodeCoverageHighlighter
	instanceVariableNames:'methodInvocationInfo cachedColorForCoveredCode
		cachedColorForUncoveredCode'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Compiler'
!

!CodeCoverageHighlighter class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2010 by eXept Software AG
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
    colors a method according to some methodInvocationInfo.
"
! !

!CodeCoverageHighlighter methodsFor:'accessing'!

colorForCoveredCode
    cachedColorForCoveredCode isNil ifTrue:[
        cachedColorForCoveredCode := UserPreferences current colorForInstrumentedFullyCoveredCode
    ].
    ^ cachedColorForCoveredCode

    "Created: / 28-04-2010 / 12:38:51 / cg"
    "Modified: / 28-04-2010 / 14:08:10 / cg"
!

colorForUncoveredCode
    cachedColorForUncoveredCode isNil ifTrue:[
        cachedColorForUncoveredCode := UserPreferences current colorForInstrumentedNeverCalledCode
    ].
    ^ cachedColorForUncoveredCode

    "Created: / 28-04-2010 / 12:38:51 / cg"
    "Modified: / 28-04-2010 / 14:08:16 / cg"
!

method:aMethod
    method := aMethod.
    self updateMethodInvocationInfo.

    "Modified: / 28-04-2010 / 13:22:16 / cg"
!

methodInvocationInfo:something
    methodInvocationInfo := something.

    "Modified: / 28-04-2010 / 13:38:56 / cg"
!

sourceText:aString
    sourceText := aString.
    self updateMethodInvocationInfo.

    "Created: / 28-04-2010 / 13:22:35 / cg"
!

updateMethodInvocationInfo
    (method notNil 
    and:[ method isInstrumented
    and:[ method source asString string asStringCollection withTabsExpanded asString
          = sourceText asString string asStringCollection withTabsExpanded asString]]) ifTrue:[
        methodInvocationInfo := method methodInvocationInfo
    ] ifFalse:[
        methodInvocationInfo := nil
    ].

    "Created: / 28-04-2010 / 13:22:02 / cg"
    "Modified: / 28-04-2010 / 14:32:02 / cg"
! !

!CodeCoverageHighlighter methodsFor:'syntax detection'!

markArgumentIdentifierFrom:pos1 to:pos2
    "intentionally left empty"
!

markBlockFrom:pos1 to:pos2
"/    methodInvocationInfo notNil ifTrue:[
"/        method blockInvocationInfo do:[:eachBlockInfo |
"/            eachBlockInfo characterPosition = pos1 ifTrue:[
"/                eachBlockInfo hasBeenExecuted ifTrue:[
"/                    sourceText 
"/                        emphasizeFrom:pos1 to:pos2 
"/                        with:#color->self colorForCoveredCode.
"/                        "/ with:#backgroundColor->self colorForCoveredCode lightened lightened lightened.
"/                    ^ self.
"/                ].
"/            ].
"/        ].
"/    ].
"/
"/    sourceText 
"/        emphasizeFrom:pos1 to:pos2 
"/        with:#color->self colorForUncoveredCode.
"/        "/ with:#backgroundColor->self colorForUncoveredCode lightened lightened lightened.
"/
"/

    "Modified: / 28-04-2010 / 15:49:34 / cg"
!

markBracketAt:pos
    |level colors clr em|

    preferences emphasizeParenthesisLevel ifFalse:[
        self 
            markFrom:pos to:pos 
            withEmphasis:(preferences bracketEmphasis) 
            color:(preferences bracketColor).

        ^ self
    ].

    level := currentBlock isNil ifTrue:[1] ifFalse:[currentBlock nestingLevel + 2].
    (sourceText at:pos) = $] ifTrue:[
        level := level - 1.
    ].

    colors := Array 
                with:(Color black)
                with:(Color blue)
                with:(Color green blendWith:(Color grey:30))
                with:(Color red blendWith:(Color grey:30))
                with:(Color yellow darkened).

    clr := colors at:((level-1) \\ colors size + 1).
    em := #normal.
    level > 1 ifTrue:[
        em := #bold.
    ].
    self 
        markFrom:pos to:pos 
        withEmphasis:em 
        color:clr
!

markCommentFrom:pos1 to:pos2
    self 
        markFrom:pos1 to:pos2 
        withEmphasis:(preferences commentEmphasis) 
        color:(Color gray "preferences commentColor")

    "
     UserPreferences current commentEmphasis
    "

    "Modified: / 24-05-2011 / 19:43:31 / cg"
!

markMethodArgumentIdentifierFrom:pos1 to:pos2
    self 
        markFrom:pos1 to:pos2 
        withEmphasis:(preferences argumentIdentifierEmphasis) 
        color:(preferences argumentIdentifierColor)

    "Created: / 21-08-2011 / 08:12:29 / cg"
!

markMethodSelectorFrom:pos1 to:pos2
    |clr|

"/    methodInvocationInfo notNil ifTrue:[
"/        methodInvocationInfo hasBeenCalled ifTrue:[
"/            clr := self colorForCoveredCode
"/        ] ifFalse:[
"/            clr := self colorForUncoveredCode
"/        ].
"/    ].
"/    clr notNil ifTrue:[
"/        "/ sourceText emphasizeFrom:1 to:sourceText size with:(#backgroundColor "#color" -> clr lightened lightened).
"/        sourceText emphasizeFrom:1 to:sourceText size with:(#color -> clr).
"/    ].

    self 
        markFrom:pos1 to:pos2 
        withEmphasis:(preferences methodSelectorEmphasis) 
        color:(clr ? preferences methodSelectorColor).

"/    emp notNil ifTrue:[
"/        sourceText emphasisFrom:1 to:sourceText size add:emp.
"/    ].

    "Modified: / 21-08-2011 / 08:10:36 / cg"
!

markUnknownIdentifierFrom:pos1 to:pos2
    self 
        markFrom:pos1 to:pos2 
        withEmphasis:(preferences unknownIdentifierEmphasis) 
        color:(preferences unknownIdentifierColor)

    "Created: / 31.3.1998 / 19:09:26 / cg"
    "Modified: / 31.3.1998 / 19:10:30 / cg"
!

parseMethod
    |clr|

    methodInvocationInfo notNil ifTrue:[
        methodInvocationInfo hasBeenCalled ifTrue:[
            clr := self colorForCoveredCode
        ] ifFalse:[
            clr := self colorForUncoveredCode
        ].
        "/ sourceText emphasizeFrom:1 to:sourceText size with:(#backgroundColor "#color" -> clr lightened lightened).
        sourceText emphasizeFrom:1 to:sourceText size with:(#color -> clr).
    ].

    super parseMethod.

    methodInvocationInfo notNil ifTrue:[
        (method blockInvocationInfo copy sort:[:a :b | a startPosition < b startPosition])
            do:[:eachBlockInfo |
                |pos clr|

                clr := eachBlockInfo hasBeenExecuted 
                            ifTrue:[ self colorForCoveredCode ]
                            ifFalse:[ self colorForUncoveredCode ].
                sourceText 
                    emphasizeFrom:eachBlockInfo startPosition to:eachBlockInfo endPosition 
                    "/ with:(#backgroundColor "#color" -> clr lightened lightened)
                    with:#color->clr.
            ]
    ].

    "Created: / 28-04-2010 / 15:49:27 / cg"
! !

!CodeCoverageHighlighter class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libcomp/CodeCoverageHighlighter.st,v 1.7 2015-02-28 00:54:47 cg Exp $'
! !

