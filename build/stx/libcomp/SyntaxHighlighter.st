"
 COPYRIGHT (c) 1998 by eXept Software AG
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

AbstractSyntaxHighlighter subclass:#SyntaxHighlighter
	instanceVariableNames:'currentSuperclasses currentSubclasses
		cachedLocalIdentifierEmphasis cachedLocalIdentifierColor
		cachedStringEmphasis cachedStringColor'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Compiler'
!

!SyntaxHighlighter class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1998 by eXept Software AG
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
    colors a method.
"


! !

!SyntaxHighlighter class methodsFor:'constants'!

codeAspectClassDefinition
    ^ #classDefinition

    "Created: / 27-07-2012 / 22:17:24 / cg"
!

codeAspectExpression
    ^ #expression

    "Created: / 27-07-2012 / 22:01:26 / cg"
!

codeAspectFile
    ^ #file

    "Created: / 21-10-2017 / 13:25:14 / cg"
!

codeAspectStatements
    ^ #statements

    "Created: / 22-02-2016 / 20:57:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

codeAspectMethod
    ^ #method

    "Created: / 27-07-2012 / 22:01:42 / cg"
! !

!SyntaxHighlighter methodsFor:'initialization'!

initialize
    <modifier: #super> "must be called if redefined"

    super initialize.

    foldConstants := false.
"/    parserFlags allowDollarInIdentifier:true.

    "Created: / 31-03-1998 / 15:12:55 / cg"
    "Modified: / 05-01-1980 / 00:44:03 / cg"
    "Modified: / 05-12-2017 / 21:09:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SyntaxHighlighter methodsFor:'syntax detection'!

markArgumentIdentifierFrom:pos1 to:pos2
    self 
        markFrom:pos1 to:pos2 
        withEmphasis:(preferences argumentIdentifierEmphasis) 
        color:(preferences argumentIdentifierColor)

    "Modified: / 31.3.1998 / 18:01:27 / cg"
!

markAssignedClassVariableIdentifierFrom:pos1 to:pos2
    self 
        markFrom:pos1 to:pos2 
        withEmphasis:(preferences sideEffectAssignmentEmphasis) ifNil:(preferences classVariableIdentifierEmphasis)
        color:(preferences sideEffectAssignmentColor) ifNil:(preferences classVariableIdentifierColor)
        backgroundColor:(preferences sideEffectAssignmentBackgroundColor)

    "Created: / 13-02-2012 / 11:49:59 / cg"
!

markAssignedGlobalIdentifierFrom:pos1 to:pos2
    self 
        markFrom:pos1 to:pos2 
        withEmphasis:(preferences sideEffectAssignmentEmphasis) ifNil:(preferences globalIdentifierEmphasis)
        color:(preferences sideEffectAssignmentColor) ifNil:(preferences globalIdentifierColor)
        backgroundColor:(preferences sideEffectAssignmentBackgroundColor)

    "Modified: / 31-03-1998 / 18:02:14 / cg"
    "Created: / 13-02-2012 / 11:44:33 / cg"
!

markAssignedIdentifierFrom:pos1 to:pos2
    "any other identifier (PrivateClass, Workspace, Doit, etc.)"

    self markAssignedGlobalIdentifierFrom:pos1 to:pos2
!

markAssignedInstVarIdentifierFrom:pos1 to:pos2
    self 
        markFrom:pos1 to:pos2 
        withEmphasis:(preferences sideEffectAssignmentEmphasis) ifNil:(preferences instVarIdentifierEmphasis)
        color:(preferences sideEffectAssignmentColor) ifNil:(preferences instVarIdentifierColor)
        backgroundColor:(preferences sideEffectAssignmentBackgroundColor)

    "Created: / 13-02-2012 / 11:50:19 / cg"
!

markAssignedPoolVariableIdentifierFrom:pos1 to:pos2
    self 
        markFrom:pos1 to:pos2 
        withEmphasis:(preferences sideEffectAssignmentEmphasis) ifNil:(preferences poolVariableIdentifierEmphasis)
        color:(preferences sideEffectAssignmentColor) ifNil:(preferences poolVariableIdentifierColor)
        backgroundColor:(preferences sideEffectAssignmentBackgroundColor)

    "Created: / 13-02-2012 / 11:49:14 / cg"
!

markAssignedVariable:v from:pos to:endPos
    "support for syntaxColoring"

    |type|

    type := v type.
    (type == #BlockArg
    or:[ type == #MethodArg
    or:[ type == #BlockVariable
    or:[ type == #MethodVariable]]]) ifTrue:[
        self markVariable:v from:pos to:endPos assigned:true.
        ^ self
    ].
    (type == #GlobalVariable) ifTrue:[
        self markAssignedGlobalIdentifierFrom:pos to:endPos.
        ^ self
    ].
    (type == #PoolVariable) ifTrue:[
        self markAssignedPoolVariableIdentifierFrom:pos to:endPos.
        ^ self
    ].
    (type == #ClassVariable) ifTrue:[
        self markAssignedClassVariableIdentifierFrom:pos to:endPos.
        ^ self
    ].
    (type == #InstanceVariable) ifTrue:[
        self markAssignedInstVarIdentifierFrom:pos to:endPos.
        ^ self
    ].

    self markAssignedIdentifierFrom:pos to:endPos.

    "Created: / 13-02-2012 / 11:42:23 / cg"
!

markBadIdentifierFrom:pos1 to:pos2
    self 
        markFrom:pos1 to:pos2 
        withEmphasis:(preferences badIdentifierEmphasis) 
        color:(preferences badIdentifierColor)
!

markBlockFrom:pos1 to:pos2
    "an experiment (which does not look too good, after all):
     the deeper the nesting of the block, the darker the background color."

"/    |level color|
"/
"/    level := currentBlock isNil ifTrue:[1] ifFalse:[currentBlock nestingLevel+1].
"/    level > 5 ifTrue:[
"/        color := Color yellow darkened.
"/    ] ifFalse:[
"/        color := {
"/                    Color yellow lightened lightened.
"/                    Color yellow lightened          .
"/                    Color yellow                    .
"/                    Color yellow slightlyDarkened   .
"/                    Color yellow darkened           .
"/                } at:level.
"/    ].
"/    self 
"/        markFrom:pos1 to:pos2 
"/        withAddedEmphasis:(#backgroundColor->color).
!

markBooleanConstantFrom:pos1 to:pos2
    self 
        markFrom:pos1 to:pos2 
        withEmphasis:(preferences booleanConstantEmphasis) 
        color:(preferences booleanConstantColor)

    "Created: / 31.3.1998 / 18:09:01 / cg"
    "Modified: / 31.3.1998 / 19:36:44 / cg"
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

markClassVariableIdentifierFrom:pos1 to:pos2
    self 
        markFrom:pos1 to:pos2 
        withEmphasis:(preferences classVariableIdentifierEmphasis) 
        color:(preferences classVariableIdentifierColor)

    "Modified: / 31.3.1998 / 18:02:14 / cg"
!

markGlobalClassIdentifierFrom:pos1 to:pos2
    self 
        markFrom:pos1 to:pos2 
        withEmphasis:(preferences globalClassIdentifierEmphasis) 
        color:(preferences globalClassIdentifierColor)

    "Modified: / 31.3.1998 / 18:02:14 / cg"
    "Created: / 4.3.1999 / 12:53:02 / cg"
!

markGlobalIdentifierFrom:pos1 to:pos2
    self 
        markFrom:pos1 to:pos2 
        withEmphasis:(preferences globalIdentifierEmphasis) 
        color:(preferences globalIdentifierColor)

    "Modified: / 31.3.1998 / 18:02:14 / cg"
!

markHereFrom:pos1 to:pos2
    self 
        markFrom:pos1 to:pos2 
        withEmphasis:(preferences hereEmphasis) 
        color:(preferences hereColor)

    "Modified: / 31.3.1998 / 18:02:25 / cg"
!

markIdentifierFrom:pos1 to:pos2
    self 
        markFrom:pos1 to:pos2 
        withEmphasis:(preferences identifierEmphasis) 
        color:(preferences identifierColor)

    "Modified: / 31.3.1998 / 18:02:39 / cg"
    "Created: / 31.3.1998 / 18:04:56 / cg"
!

markInstVarIdentifierFrom:pos1 to:pos2
    self 
        markFrom:pos1 to:pos2 
        withEmphasis:(preferences instVarIdentifierEmphasis)    
        color:(preferences instVarIdentifierColor)

    "Created: / 16.4.1998 / 18:35:40 / cg"
    "Modified: / 16.4.1998 / 18:37:30 / cg"
!

markLocalIdentifierFrom:pos1 to:pos2
    cachedLocalIdentifierEmphasis isNil ifTrue:[
        cachedLocalIdentifierEmphasis := preferences localIdentifierEmphasis.
        cachedLocalIdentifierColor := preferences localIdentifierColor.
    ].
    self 
        markFrom:pos1 to:pos2 
        withEmphasis:cachedLocalIdentifierEmphasis 
        color:cachedLocalIdentifierColor

    "Modified: / 31.3.1998 / 18:02:39 / cg"
!

markMethodSelectorFrom:pos1 to:pos2
    self 
        markFrom:pos1 to:pos2 
        withEmphasis:(preferences methodSelectorEmphasis) 
        color:(preferences methodSelectorColor)

    "Modified: / 31.3.1998 / 18:02:52 / cg"
!

markNumberConstantFrom:pos1 to:pos2
    self 
        markFrom:pos1 to:pos2 
        withEmphasis:(preferences numberConstantEmphasis) 
        color:(preferences numberConstantColor)

    "Modified: / 31.3.1998 / 18:01:44 / cg"
    "Created: / 31.3.1998 / 18:09:22 / cg"
!

markParenthesisAt:pos
    |colors clr em|

    preferences emphasizeParenthesisLevel ifFalse:[^ self].

    colors := Array 
                with:(Color black)
                with:(Color blue)
                with:(Color green blendWith:(Color grey:30))
                with:(Color red blendWith:(Color grey:30))
                with:(Color yellow darkened).
                        
    clr := colors at:((parenthesisLevel-1) \\ colors size + 1).
    em := #normal.
    parenthesisLevel > 1 ifTrue:[
        em := #bold.
    ].
    self 
        markFrom:pos to:pos 
        withEmphasis:em 
        color:clr
!

markPoolVariableIdentifierFrom:pos1 to:pos2
    self 
        markFrom:pos1 to:pos2 
        withEmphasis:(preferences poolVariableIdentifierEmphasis) 
        color:(preferences poolVariableIdentifierColor)
!

markReturnAt:pos
    "/ sourceText := (sourceText copyTo:pos-1),(Character value:16r21e7),(sourceText copyFrom:pos+1).
    self 
        markFrom:pos to:pos 
        withEmphasis:(preferences returnEmphasis) 
        color:(preferences returnColor)

    "Modified: / 31.3.1998 / 19:36:44 / cg"
    "Created: / 5.1.1980 / 00:44:27 / cg"
!

markSelector:selectorString from:pos1 to:pos2 receiverNode:aReceiverNode
    |fg selectorSymbol check ok rec em|

"/ uncommenting the code below
"/ will suppress highlighting of common selectors ...
"/
"/    (#(
"/        'ifTrue:' 
"/        'ifFalse:'
"/        'not'
"/        'and:'
"/        'or:'
"/        '='
"/        '=='
"/        '~='
"/        '~~'
"/    ) includes:sel) ifTrue:[
"/        ^ self
"/    ].

    fg := preferences selectorColor.
    em := preferences selectorEmphasis.
    selectorSymbol := selectorString asSymbolIfInterned.
    selectorSymbol isNil ifTrue:[
        em := preferences unimplementedSelectorEmphasis.
        fg := preferences unimplementedSelectorColor.
    ] ifFalse:[
        ok := true.

        fullSelectorCheck == true ifTrue:[

            check := [:cls | (cls includesSelector:selectorSymbol)
                             or:[cls class includesSelector:selectorSymbol]].

            ok := false.

            "/ limit search if possible
            (classToCompileFor notNil
             and:[aReceiverNode isSelf or:[aReceiverNode isSuper]]) ifTrue:[
                currentSuperclasses isNil ifTrue:[
                    currentSuperclasses := classToCompileFor withAllSuperclasses.
                ].
                ok := currentSuperclasses contains:check.
                (ok not and:[aReceiverNode isSelf]) ifTrue:[
                    currentSubclasses isNil ifTrue:[
                        currentSubclasses := classToCompileFor allSubclasses.
                    ].
                    ok := currentSubclasses contains:check.
                ].
            ] ifFalse:[
                aReceiverNode isLiteral ifTrue:[
                    ok := aReceiverNode evaluate class withAllSuperclasses contains:check.
                ] ifFalse:[
                    (aReceiverNode isGlobal 
                    and:[(rec := aReceiverNode evaluate) isBehavior]) ifTrue:[
                        ok := rec class withAllSuperclasses contains:check.
                    ] ifFalse:[
                        ok := Smalltalk allClasses contains:check
                    ]
                ]
            ].
        ].

        ok ifFalse:[
            em := preferences unimplementedSelectorEmphasis.
            fg := preferences unimplementedSelectorColor.
        ] ifTrue:[
            (self class isControlFlowSelector:selectorSymbol) ifTrue:[
                em := preferences controlFlowSelectorEmphasis.
                fg := preferences controlFlowSelectorColor
            ] ifFalse:[
                (self collectionEnumerationSelectors includesIdentical:selectorSymbol) ifTrue:[
                    em := preferences collectionEnumerationSelectorEmphasis.
                    fg := preferences collectionEnumerationSelectorColor
                ] ifFalse:[
                    (self debugSelectors includesIdentical:selectorSymbol) ifTrue:[
                        em := preferences debugSelectorEmphasis.
                        fg := preferences debugSelectorColor
                    ] ifFalse:[
                        (self errorRaisingSelectors includesIdentical:selectorSymbol) ifTrue:[
                            em := preferences errorRaisingSelectorEmphasis.
                            fg := preferences errorRaisingSelectorColor
                        ].
                    ].
                ].
            ].
            em isNil ifTrue:[
                em := preferences selectorEmphasis
            ].
            fg isNil ifTrue:[
                fg := preferences selectorColor
            ].
        ].
    ].
    self
        markFrom:pos1 to:pos2 
        withEmphasis:em 
        color:fg

    "Modified: / 14-02-2012 / 16:03:52 / cg"
!

markSelfFrom:pos1 to:pos2
    self 
        markFrom:pos1 to:pos2 
        withEmphasis:(preferences selfEmphasis) 
        color:(preferences selfColor)

    "Modified: / 31.3.1998 / 18:03:10 / cg"
!

markStringFrom:pos1 to:pos2
    cachedStringEmphasis isNil ifTrue:[
        cachedStringEmphasis := preferences stringEmphasis.
        cachedStringColor := preferences stringColor.
    ].
    self 
        markFrom:pos1 to:pos2 
        withEmphasis:cachedStringEmphasis 
        color:cachedStringColor

    "Modified: / 31.3.1998 / 18:03:18 / cg"
!

markSuperFrom:pos1 to:pos2
    self 
        markFrom:pos1 to:pos2 
        withEmphasis:(preferences superEmphasis) 
        color:(preferences superColor)

    "Modified: / 31.3.1998 / 18:03:26 / cg"
!

markSymbolFrom:pos1 to:pos2
    self 
        markFrom:pos1 to:pos2 
        withEmphasis:(preferences symbolEmphasis) 
        color:(preferences symbolColor)

    "Created: / 1.4.1998 / 12:56:47 / cg"
    "Modified: / 1.4.1998 / 12:58:00 / cg"
!

markThisContextFrom:pos1 to:pos2
    self 
        markFrom:pos1 to:pos2 
        withEmphasis:(preferences thisContextEmphasis) 
        color:(preferences thisContextColor)

    "Modified: / 31.3.1998 / 18:03:36 / cg"
!

markUnknownIdentifierFrom:pos1 to:pos2
    self 
        markFrom:pos1 to:pos2 
        withEmphasis:(preferences unknownIdentifierEmphasis) 
        color:(preferences unknownIdentifierColor)

    "Created: / 31.3.1998 / 19:09:26 / cg"
    "Modified: / 31.3.1998 / 19:10:30 / cg"
!

markVariable:v from:pos to:endPos assigned:assigned
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
        nameSym notNil ifTrue:[
            globalValue := Smalltalk at:nameSym ifAbsent:nil.
        ].
        globalValue isBehavior ifTrue:[
            self markGlobalClassIdentifierFrom:pos to:endPos.
        ] ifFalse:[
            self markGlobalIdentifierFrom:pos to:endPos.
        ].
        ^ self
    ].
    (type == #PoolVariable) ifTrue:[
        self markPoolVariableIdentifierFrom:pos to:endPos.
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

!SyntaxHighlighter class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

