"{ Package: 'stx:goodies/refactoryBrowser/parser' }"

"{ NameSpace: Smalltalk }"

RBProgramNodeVisitor subclass:#RBFormatter
	instanceVariableNames:'codeStream lineStart firstLineLength tabs preserveLiterals
		suppressBeforeComment suppressAfterComment alreadyIndented
		rewriteOldAssignments'
	classVariableNames:'TabIndent SpaceAfterReturnToken SpaceAfterKeywordSelector
		SpaceAroundTemporaries SpaceAfterBlockStart SpaceBeforeBlockEnd
		EmptyLineAfterTemporaries CStyleBlocks NodeVisitedAsReceiverQuery
		MaxLengthForSingleLineBlocks STXModifications
		BlockArgumentsOnNewLine OldStyleAssignments
		EmptyLineAfterMethodComment EmptyLineBeforeFinalMethodComment
		SpaceAroundLiteralArrayElements PeriodAfterLastStatementPolicy
		SpaceForEmptyLiteralArray STXStyleMethodComments'
	poolDictionaries:''
	category:'Refactory-Parser'
!


!RBFormatter class methodsFor:'initialization'!

initializeSettings
    OldStyleAssignments isNil ifTrue:[
        OldStyleAssignments := false.
        STXModifications := true.
        MaxLengthForSingleLineBlocks := 20.

        RBParser isSmalltalkX ifTrue:[
            self initializeSettingsForSTX.
        ] ifFalse:[
            self initializeSettingsForBR
        ].
    ]

    "
     self initialize
    "

    "Modified: / 6.2.2000 / 14:33:56 / cg"
!

initializeSettingsForBR
    "BR original settings"

    TabIndent := 8.
    SpaceAfterReturnToken := false.
    SpaceAfterKeywordSelector := true.
    SpaceAroundTemporaries := true.
    EmptyLineAfterTemporaries := false.
    EmptyLineAfterMethodComment := false.
    EmptyLineBeforeFinalMethodComment := false.
    CStyleBlocks := false.
    BlockArgumentsOnNewLine := false.
    SpaceAfterBlockStart := false.
    SpaceBeforeBlockEnd := false.
    PeriodAfterLastStatementPolicy := #add.
    SpaceAroundLiteralArrayElements := false.
    STXStyleMethodComments := false.
!

initializeSettingsForSTX
    "ST/X settings"

    |prefs|

    TabIndent := 4.
    SpaceAfterReturnToken := true.
    SpaceAfterKeywordSelector := false.
    SpaceAroundTemporaries := false.
    EmptyLineAfterTemporaries := true.
    EmptyLineAfterMethodComment := true.
    EmptyLineBeforeFinalMethodComment := true.
    CStyleBlocks := true.
    BlockArgumentsOnNewLine := false.
    SpaceAfterBlockStart := true.
    SpaceBeforeBlockEnd := true.
    PeriodAfterLastStatementPolicy := #keep.
    SpaceAroundLiteralArrayElements := true.
    STXStyleMethodComments := true.

    ((Smalltalk respondsTo:#isSmalltalkX) and:[Smalltalk isSmalltalkX]) ifTrue:[
        " a helper query; used to pass additional information    "
        " down to lower levels, without rewriting everything...  "

        NodeVisitedAsReceiverQuery := QuerySignal new.
        NodeVisitedAsReceiverQuery defaultAnswer:false.

        prefs := UserPreferences current.

        TabIndent                    := prefs at:#'formatter.tabIndent'                    ifAbsent:TabIndent.
        SpaceAfterReturnToken        := prefs at:#'formatter.spaceAfterReturnToken'        ifAbsent:SpaceAfterReturnToken.
        SpaceAfterKeywordSelector    := prefs at:#'formatter.spaceAfterKeywordSelector'    ifAbsent:SpaceAfterKeywordSelector.
        SpaceAroundTemporaries       := prefs at:#'formatter.spaceAroundTemporaries'       ifAbsent:SpaceAroundTemporaries.
        EmptyLineAfterTemporaries    := prefs at:#'formatter.emptyLineAfterTemporaries'    ifAbsent:EmptyLineAfterTemporaries.
        EmptyLineAfterMethodComment  := prefs at:#'formatter.emptyLineAfterMethodComment'  ifAbsent:EmptyLineAfterMethodComment.
        CStyleBlocks                 := prefs at:#'formatter.cStyleBlocks'                 ifAbsent:CStyleBlocks.
        BlockArgumentsOnNewLine      := prefs at:#'formatter.blockArgumentsOnNewLine'      ifAbsent:BlockArgumentsOnNewLine.
        SpaceAfterBlockStart         := prefs at:#'formatter.spaceAfterBlockStart'         ifAbsent:SpaceAfterBlockStart.
        SpaceBeforeBlockEnd          := prefs at:#'formatter.spaceBeforeBlockEnd'          ifAbsent:SpaceBeforeBlockEnd.
        MaxLengthForSingleLineBlocks := prefs at:#'formatter.maxLengthForSingleLineBlocks' ifAbsent:MaxLengthForSingleLineBlocks.
    ]
! !

!RBFormatter class methodsFor:'defaults'!

blockArgumentsOnNewLine
    "return the blockArgumentsOnNewLine flag; if on, block arguments
     are on a new line.
     defaults to true in original formatter; false in ST/X"

    ^ BlockArgumentsOnNewLine 



!

blockArgumentsOnNewLine:aBoolean
    "set/clear the blockArgumentsOnNewLine flag; if on, block arguments
     are on a new line.
     defaults to true in original formatter; false in ST/X"

    BlockArgumentsOnNewLine := aBoolean



!

cStyleBlocks
    "return the cStyleBlocks flag; if on, blocks are formatted
     the c-style (k&r style); if off, they are formatted the lisp-style.
     defaults to false in original formatter; true in ST/X"

    ^ CStyleBlocks 
!

cStyleBlocks:aBoolean
    "set/clear the cStyleBlocks flag; if on, blocks are formatted
     the c-style (k&r style); if off, they are formatted the lisp-style.
     defaults to false in original formatter; true in ST/X"

    CStyleBlocks := aBoolean
!

emptyLineAfterMethodComment
    "return the emptyLineAfterMethodComment flag; if on, an empty line
     is inserted after the methods initial comment.
     defaults to false in original formatter; true in ST/X"

    ^ EmptyLineAfterMethodComment
!

emptyLineAfterMethodComment:aBoolean
    "set/clear the emptyLineAfterMethodComment flag; if on, an empty line
     is inserted after the methods initial comment.
     defaults to false in original formatter; true in ST/X"

    EmptyLineAfterMethodComment := aBoolean
!

emptyLineAfterTemporaries
    "return the emptyLineAfterTemporaries flag; if on, an empty line
     is inserted after the locals declaration part.
     defaults to false in original formatter; true in ST/X"

    ^ EmptyLineAfterTemporaries
!

emptyLineAfterTemporaries:aBoolean
    "set/clear the emptyLineAfterTemporaries flag; if on, an empty line
     is inserted after the locals declaration part.
     defaults to false in original formatter; true in ST/X"

    EmptyLineAfterTemporaries := aBoolean
!

maxLengthForSingleLineBlocks
    "return the maxLengthForSingleLineBlocks setting; 
     blocks with code longer than this are broken into multiple lines.
     defaults to false in original formatter; true in ST/X"

    ^ MaxLengthForSingleLineBlocks 
!

maxLengthForSingleLineBlocks:anInteger
    "set the maxLengthForSingleLineBlocks value; 
     blocks with code longer than this are broken into multiple lines.
     defaults to false in original formatter; true in ST/X"

    MaxLengthForSingleLineBlocks := anInteger
!

periodAfterLastStatementPolicy
    "return the periodAfterLastStatementPolicy flag; 
     this can be one of #keep, #add or #remove"

    ^ PeriodAfterLastStatementPolicy
!

periodAfterLastStatementPolicy:aSymbol
    "set the periodAfterLastStatementPolicy flag; 
     this can be one of #keep, #add or #remove"

    PeriodAfterLastStatementPolicy := aSymbol
!

spaceAfterBlockStart
    "return the spaceAfterBlockStart flag; if on, a space character
     is inserted after a [ token."

    ^ SpaceAfterBlockStart
!

spaceAfterBlockStart:aBoolean
    "set/clear the spaceAfterBlockStart flag; if on, a space character
     is inserted after a [ token."

    SpaceAfterBlockStart := aBoolean
!

spaceAfterKeywordSelector
    "return the spaceAfterKeywordSelector flag; if on, a space character
     is inserted after a : in a keyword message (to separate the arg).
     defaults to true in original formatter; false in ST/X"

    ^ SpaceAfterKeywordSelector
!

spaceAfterKeywordSelector:aBoolean
    "set/clear the spaceAfterKeywordSelector flag; if on, a space character
     is inserted after a : in a keyword message (to separate the arg).
     defaults to true in original formatter; false in ST/X"

    SpaceAfterKeywordSelector := aBoolean
!

spaceAfterReturnToken
    "return the spaceAfterReturn flag; if on, a space character
     is inserted after a ^ token.
     defaults to false in original formatter; true in ST/X"

    ^ SpaceAfterReturnToken
!

spaceAfterReturnToken:aBoolean
    "set/clear the spaceAfterReturn flag; if on, a space character
     is inserted after a ^ token.
     defaults to false in original formatter; true in ST/X"

    SpaceAfterReturnToken := aBoolean
!

spaceAroundTemporaries
    "return the spaceAroundTemporariesr flag; if on, a space character
     is inserted before the first and after the last local variable
     in the locals declaration part (i.e. as in | foo bar |)
     defaults to true in original formatter; false in ST/X"

    ^ SpaceAroundTemporaries
!

spaceAroundTemporaries:aBoolean
    "set/clear the spaceAroundTemporariesr flag; if on, a space character
     is inserted before the first and after the last local variable
     in the locals declaration part (i.e. as in | foo bar |)
     defaults to true in original formatter; false in ST/X"

    SpaceAroundTemporaries := aBoolean
!

spaceBeforeBlockEnd
    "return the spaceBeforeBlockEnd flag; if on, a space character
     is inserted before a ] token."

    ^ SpaceBeforeBlockEnd
!

spaceBeforeBlockEnd:aBoolean
    "set/clear the spaceBeforeBlockEnd flag; if on, a space character
     is inserted before a ] token."

    SpaceBeforeBlockEnd := aBoolean
!

tabIndent
    "the indent; defaults to 8 in original formatter;
     4 in ST/X"

    ^ TabIndent ? 4
!

tabIndent:newIndent
    "set the indent; defaults to 8 in original formatter;
     4 in ST/X"

    TabIndent := newIndent
! !

!RBFormatter class methodsFor:'formatting-public'!

format:aMethodSource
    |tree newSource|

    tree := RBParser 
		    parseMethod:aMethodSource
		    onError: [:aString :position | ^ aMethodSource "ignore any error"].
    tree isNil ifTrue:[^ aMethodSource].

    newSource := tree printString.
    ^ newSource

    "
     RBFormatter format:'foo ^ self'
    "
! !

!RBFormatter methodsFor:'accessing'!

codeStream
	^codeStream
!

firstLineLength
	^firstLineLength isNil
		ifTrue: [codeStream position]
		ifFalse: [firstLineLength]
!

format: aNode 
        codeStream reset.
        self visitNode: aNode.
        ^codeStream contents

    "Modified: / 17-08-2015 / 23:30:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isMultiLine
	^firstLineLength notNil
!

lastLineLength
	^codeStream position - (lineStart max: 0)
!

rewriteOldAssignments:aBoolean
    "if true (which is the default), old style assignments '_'
     are formatted as ':='.
     There is only one use of turning this off: when the original
     source is to be preserve (i.e. when generating code for an old ST,
     or showing a searchString's original pattern)"

    rewriteOldAssignments := aBoolean.
!

suppressAfterComment:something
    suppressAfterComment := something.
!

suppressBeforeComment:something
    suppressBeforeComment := something.
! !

!RBFormatter methodsFor:'additions - ST/X'!

addTab
        RBParser isSmalltalkX ifTrue:[
            codeStream spaces:self class tabIndent
        ] ifFalse:[
            codeStream tab
        ]

    "Created: / 19.11.1999 / 18:14:28 / cg"
    "Modified: / 19.11.1999 / 18:22:30 / cg"
! !

!RBFormatter methodsFor:'copying'!

postCopy
        super postCopy.
        lineStart := self lineLength negated.
        codeStream := CharacterWriteStream on: (String new: 60).
        firstLineLength := nil
! !

!RBFormatter methodsFor:'initialize-release'!

initialize
        super initialize.

        self class initializeSettings.

        codeStream := CharacterWriteStream on: (String new: 60).
        tabs := 0.
        lineStart := 0.
        rewriteOldAssignments := true.
! !

!RBFormatter methodsFor:'private'!

crNoIndent
	firstLineLength isNil ifTrue: [firstLineLength := codeStream position].
	codeStream cr.
	lineStart := codeStream position

    "Modified: / 19.11.1999 / 18:15:02 / cg"
!

for: aValue do: doBlock separatedBy: separatorBlock 
	"This is implemented here since IBM Smalltalk doesn't implement a do:separatedBy: method"

	aValue isEmpty ifTrue: [^self].
	1 to: aValue size - 1
		do: 
			[:i | 
			doBlock value: (aValue at: i).
			separatorBlock value].
	doBlock value: aValue last
!

indent
	firstLineLength isNil ifTrue: [firstLineLength := codeStream position].
	codeStream cr.
	tabs timesRepeat: [self addTab].
	lineStart := codeStream position

    "Modified: / 19.11.1999 / 18:15:02 / cg"
!

indent: anInteger
    tabs := anInteger

    "Created: / 24-07-2015 / 19:22:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

indent: anInteger while: aBlock 
	tabs := tabs + anInteger.
	aBlock value.
	tabs := tabs - anInteger
!

indentOnly
        tabs timesRepeat: [self addTab].
        lineStart := codeStream position

    "Modified: / 19.11.1999 / 18:15:02 / cg"
!

indentWhile: aBlock 
	self indent: 1 while: aBlock
!

lineLength
	^codeStream position - lineStart
!

lineStart: aPosition 
	lineStart := aPosition
!

maxLineSize
	^75
!

maximumArgumentsPerLine
	^2
!

needsParenthesisFor: aNode 
        | parent grandparent |
        aNode isValue ifFalse: [^false].
        aNode hasParentheses ifTrue:[
            " if original code had parentheses - generate them again "
            "/ but not, if its a numeric literal (for which we print its orig source)
            (aNode isLiteralNumber and:[ aNode source notNil ]) ifTrue:[^ false].
            ^ true
        ].   
        parent := aNode parent.
        parent isNil ifTrue: [^false].
        (aNode isMessage and: [parent isMessage and: [parent receiver == aNode]])
                ifTrue: 
                        [grandparent := parent parent.
                        (grandparent notNil and: [grandparent isCascade]) ifTrue: [^true]].
        parent isSqueakArray ifTrue: [^false].
        aNode precedence < parent precedence ifTrue: [^false].
        aNode isAssignment & parent isAssignment ifTrue: [^false].
        (aNode isAssignment or:[ aNode isCascade ]) ifTrue: [^true].
        aNode precedence == 0 ifTrue: [^false].
        aNode isMessage ifFalse: [^true].
        aNode precedence = parent precedence ifFalse: [^true].
        aNode isUnary ifTrue: [^false].
        aNode isKeyword ifTrue: [^true].
        parent receiver == aNode ifFalse: [^true].
        ^self precedenceOf: parent selector greaterThan: aNode selector

    "Modified: / 27-10-2011 / 09:21:11 / cg"
!

possiblyIndent
    "cr-tab - but only if not already at beginning"

    codeStream position == lineStart ifFalse:[
	self indent.
    ].
!

precedenceOf: parentSelector greaterThan: childSelector 
        "Put parentheses around things that are preceived to have 'lower' precedence. For example, 'a + b * c' 
        -> '(a + b) * c' but 'a * b + c' -> 'a * b + c'"

        | childIndex parentIndex operators |
        operators := #(#($| $& $?) #($= $~ $< $>) #($- $+) #($* $/ $% $\) #($@)).
        childIndex := 0.
        parentIndex := 0.
        1 to: operators size
                do: 
                        [:i | 
                        ((operators at: i) includes: parentSelector first) ifTrue: [parentIndex := i].
                        ((operators at: i) includes: childSelector first) ifTrue: [childIndex := i]].
        ^childIndex < parentIndex
!

selectorsToLeaveOnLine
	^#(#to:do: #to:by: #to:by:do: timesRepeat:)
!

selectorsToStartOnNewLine
	^#(#ifTrue:ifFalse: #ifFalse:ifTrue: #ifTrue: #ifFalse:)
! !

!RBFormatter methodsFor:'private-formatting'!

formatArrayNodeExpressions: statements 
    ^ self formatArrayNodeExpressions: statements singleLine: false

    "Modified: / 11-02-2012 / 10:47:24 / cg"
!

formatArrayNodeExpressions: statements singleLine: singleLine
        | lastIndex tB tA|

        statements isEmptyOrNil ifTrue: [^''].

        tB := suppressBeforeComment.
        tA := suppressAfterComment.
        suppressBeforeComment := true.
        suppressAfterComment := true.

        lastIndex := statements size.

        statements keysAndValuesDo:[:idx :stat | 
            |wantPeriod|

            self formatStatementCommentsBefore:(stat commentsBefore) for:stat.
            self visitNode: stat.

            wantPeriod := (idx ~~ lastIndex)
                          or:[ PeriodAfterLastStatementPolicy == #add
                          " or:[ PeriodAfterLastStatementPolicy == #keep 
                               and:[ aSequenceNode lastHasPeriod]] " ].
            wantPeriod ifTrue:[
                singleLine ifTrue:[
                    idx ~~ lastIndex ifTrue:[
                        codeStream space
                    ]
                ].
                codeStream nextPutAll: '.'.
            ].

            self formatComments:(stat commentsAfter) for:stat spaceBefore:true spaceAfter:false.
            idx ~~ lastIndex ifTrue:[ 
                singleLine ifTrue:[
                    codeStream space
                ] ifFalse:[ 
                    self indent 
                ].
            ]
        ].

        suppressBeforeComment := tB.
        suppressAfterComment := tA.
        ^codeStream contents

    "Created: / 11-02-2012 / 10:29:41 / cg"
!

formatLiteral: aLiteralNode
        (aLiteralNode isLiteralNumber and:[ aLiteralNode token radix notNil ])
        ifTrue:[
            "to preserve the original radix..."
            aLiteralNode value printOn: codeStream base:aLiteralNode token radix showRadix:true.
            ^ self
        ].
        (aLiteralNode isLiteralArray 
        or:[ aLiteralNode isLiteralByteArray ]) ifTrue:[
            self formatLiteralArray:aLiteralNode.
            ^ self.
        ].
        ^ self formatLiteralValue: aLiteralNode value

    "Modified: / 27-04-2010 / 00:25:30 / cg"
!

formatLiteralArray:aLiteralNode
        |elementTokens delimiters needSpace prevLineNr thisLineNr
         firstElement firstElementsColumn source|

        aLiteralNode isLiteralArray ifTrue:[
            delimiters := '()'.
            elementTokens := aLiteralNode token value.
        ] ifFalse:[
            aLiteralNode isLiteralByteArray ifTrue:[
                delimiters := '[]'.
                elementTokens := aLiteralNode token elementTokens.
            ] ifFalse:[
                self halt:'unsupported extension'
            ].
        ].

        codeStream nextPutAll:'#'.
        codeStream nextPut:delimiters first.
        needSpace := SpaceAroundLiteralArrayElements ? true.
        thisLineNr := aLiteralNode lineNumber.
        source := aLiteralNode source.
        firstElement := true.

        elementTokens do:[:eachElement |
            |thisElementsColumn source|

            thisElementsColumn := eachElement columnNumber.
            firstElement ifTrue:[
                firstElementsColumn := thisElementsColumn.
                firstElement := false.
            ].

            prevLineNr := thisLineNr.
            thisLineNr := eachElement lineNumber.
            prevLineNr ~= thisLineNr ifTrue:[
                self indent.
                codeStream spaces:(thisElementsColumn - firstElementsColumn).
                " needSpace := false. "
            ].
            needSpace ifTrue:[
                codeStream space.
            ].
            source isNil ifTrue:[
                codeStream nextPutAll:(eachElement realValue storeString).
            ] ifFalse:[    
                codeStream nextPutAll:(eachElement originalCodeIn:source).
            ].
            needSpace := true.
        ].

        elementTokens isEmptyOrNil ifTrue:[
            (SpaceForEmptyLiteralArray ? false) ifTrue:[
                codeStream space.
            ]
        ] ifFalse:[
            (needSpace and:[SpaceAroundLiteralArrayElements ? true]) ifTrue:[
                codeStream space.
            ]
        ].
        codeStream nextPut:delimiters second.
!

formatLiteralValue: aValue 
        | isArray classOfValue|

        classOfValue := aValue class.
        isArray := classOfValue == Array or:[ classOfValue == ByteArray].
        isArray ifTrue: 
                        [codeStream nextPutAll: (isArray ifTrue: ['#('] ifFalse: ['#[']).
                        self for: aValue
                                do: [:each | self formatLiteralValue: each]
                                separatedBy: [codeStream nextPut: $ ].
                        codeStream nextPut: (isArray ifTrue: [$)] ifFalse: [$]]).
                        ^self].

        aValue isSymbol ifTrue: 
                        [self formatSymbol: aValue.
                        ^self].
        classOfValue == Character ifTrue: 
                        [codeStream nextPut: $$;
                                nextPut: aValue.
                        ^self].

        aValue storeOn: codeStream

    "Modified: / 20.11.1999 / 18:46:25 / cg"
!

formatMessage: aMessageNode cascade: cascadeBoolean 
	self formatMessage: aMessageNode cascade: cascadeBoolean newLine:true
!

formatMessage: aMessageNode cascade: cascadeBoolean newLine:newLine
	| selectorParts arguments multiLine formattedArgs indentFirst firstArgLength length  howMuchIndent|
	selectorParts := aMessageNode selectorParts.
	arguments := aMessageNode arguments.
	formattedArgs := OrderedCollection new.
	multiLine := aMessageNode selector numArgs > self maximumArgumentsPerLine.
	length := aMessageNode selector size + arguments size + 1.
	firstArgLength := 0.

	howMuchIndent := 1.
	CStyleBlocks ifTrue:[
	    aMessageNode receiver isBlock ifTrue:[ 
		howMuchIndent := -1.    
	    ] ifFalse:[
"
		(aMessageNode arguments size > 0
		and:[(self startMessageSendOnNewLine: aMessageNode)]) ifTrue:[ 
		    howMuchIndent := 0.    
		].
"
	    ]
	].

	self indent:howMuchIndent while: 
			[1 to: arguments size
				do: 
					[:i | 
					| formatter string |
					formatter := (self copy) 
								lineStart: (selectorParts at: i) length negated;
								yourself.
					string := formatter format: (arguments at: i).
					formattedArgs add: string.
					i == 1 ifTrue: [firstArgLength := formatter firstLineLength].
					length := length + string size.
					multiLine := multiLine or: [formatter isMultiLine]]].
	multiLine := multiLine or: [length + self lineLength > self maxLineSize].
	indentFirst := cascadeBoolean not and: 
					[multiLine and: 
							[(self startMessageSendOnNewLine: aMessageNode) or: 
									[self lineLength + selectorParts first length + 2 + firstArgLength 
										> self maxLineSize]]].
	(newLine and:[indentFirst]) ifTrue: [self indent].
	self 
		formatMessageSelector: selectorParts
		withArguments: formattedArgs
		multiline: multiLine.
!

formatMessageSelector: selectorParts withArguments: formattedArgs multiline: multiLine 
	formattedArgs isEmpty 
		ifTrue: [codeStream nextPutAll: selectorParts first value]
		ifFalse: 
			[1 to: formattedArgs size
				do: 
					[:i | |part|

					i ~~ 1 & multiLine not ifTrue: [codeStream nextPut: $ ].
					part := (selectorParts at: i) value.
					codeStream 
						nextPutAll: part.
					(SpaceAfterKeywordSelector
					or:[(part endsWith:$:) not ]) ifTrue:[
					    codeStream 
						nextPut: $ .
					].
					codeStream 
						nextPutAll: (formattedArgs at: i).
					(multiLine and: [i < formattedArgs size]) ifTrue: [self indent]]]

    "Modified: / 22.11.1999 / 11:27:20 / cg"
!

formatMethodPatternFor: aMethodNode 
	| selectorParts arguments |
	selectorParts := aMethodNode selectorParts.
	arguments := aMethodNode arguments.
	arguments isEmpty
		ifTrue: [codeStream nextPutAll: selectorParts first value]
		ifFalse: 
			[selectorParts with: arguments
				do: 
					[:selector :arg | |part commentsBefore|
					codeStream nextPutAll: (part := selector value).
					(SpaceAfterKeywordSelector
					or:[(part endsWith:$:) not]) ifTrue:[
					    codeStream space .
					].
					commentsBefore := arg commentsBefore.
					commentsBefore size > 0 ifTrue:[
					    self formatArgumentComments:commentsBefore for:arg.
					].
					self visitArgument: arg.
					codeStream space ]]

    "Modified: / 22.11.1999 / 11:27:58 / cg"
!

formatPragma: aPragmaNode
        codeStream nextPut: $<.
        "/ This is for compatibility with Squeak/Pharo
        aPragmaNode selector isBinarySelector ifTrue:[ 
            codeStream space.
        ].
        self 
            formatMessageSelector: aPragmaNode selectorParts
                withArguments: (aPragmaNode arguments collect:[ :e | self copy format: e ])
                multiline: false.
        codeStream nextPut: $>

    "Created: / 07-10-2014 / 23:43:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-08-2015 / 23:34:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

formatStatementsFor: aSequenceNode 
        | statements lastIndex tB tA|

        statements := aSequenceNode statements.
        statements isEmptyOrNil ifTrue: [^self].

        tB := suppressBeforeComment.
        tA := suppressAfterComment.
        suppressBeforeComment := true.
        suppressAfterComment := true.

        lastIndex := statements size.

        statements keysAndValuesDo:[:idx :stat | 
            |wantPeriod|

            self formatStatementCommentsBefore:(stat commentsBefore) for:stat.
            self visitNode: stat.

            wantPeriod := (idx ~~ lastIndex)
                          or:[ PeriodAfterLastStatementPolicy == #add
                          or:[ PeriodAfterLastStatementPolicy == #keep and:[aSequenceNode lastHasPeriod]]].
            wantPeriod ifTrue:[
                codeStream nextPut: $..
            ].

            self formatComments:(stat commentsAfter) for:stat spaceBefore:true spaceAfter:false.
"
            self formatStatementComments:(stat commentsAfter) for:stat.
"
            idx ~~ lastIndex ifTrue:[ self indent ].
        ].

        suppressBeforeComment := tB.
        suppressAfterComment := tA.
!

formatSymbol: aSymbol 
	"Format the symbol, if its not a selector then we must put quotes around it. The and: case below, 
	handles the VisualWorks problem of not accepting two bars as a symbol."

	RBParser isSmalltalkX ifTrue:[
	    " ST/X's symbol generates a legal storeString (when spaces are embedded...) "
	    aSymbol storeOn: codeStream.
	    ^self
	].

	codeStream nextPut: $#.
	((RBScanner isSelector: aSymbol) and: [aSymbol ~~ #'||'])
		ifTrue: [codeStream nextPutAll: aSymbol]
		ifFalse: [aSymbol asString printOn: codeStream]
!

formatTagFor: aMethodNode 
	| primitiveSources |
	primitiveSources := aMethodNode primitiveSources.
	primitiveSources do: 
			[:each | 
			codeStream nextPutAll: each.
			self indent]
!

formatTemporariesFor: aSequenceNode 
	| temps first numTemps hasIndent maxLength |

	temps := aSequenceNode temporaries.
	temps isEmpty ifTrue: [^self].

	codeStream nextPutAll: '|'.
	SpaceAroundTemporaries ifTrue:[codeStream space.].
	first := true.
	hasIndent := true.

	maxLength := temps inject:0 into:[:maxSoFar :thisNode | maxSoFar max:(thisNode name size)].

	numTemps := temps size.
	temps keysAndValuesDo: 
			[:idx :each | 

			first ifFalse:[
			    codeStream space.
			    SpaceAroundTemporaries ifTrue:[codeStream space.].
			].
			each commentsBefore size > 0 ifTrue:[
			    hasIndent := true.
			    self formatTemporaryComments:each commentsBefore for: each.
			    numTemps > 1 ifTrue:[
				self possiblyIndent.
			    ].
			    first ifTrue:[
				codeStream space
			    ].
			].
			each commentsAfter size > 0 ifTrue:[
			    hasIndent ifFalse:[
				numTemps > 1 ifTrue:[
				    self indent. codeStream space.
				    SpaceAroundTemporaries ifTrue:[codeStream space.].
				]
			    ].
			].                 
			codeStream nextPutAll: each name.
			each commentsAfter size > 0 
			    ifTrue:[
				codeStream spaces:(maxLength - each name size + 1).
				self formatTemporaryComments:each commentsAfter for:each.
				numTemps > 1 ifTrue:[
				    idx ~~ numTemps ifTrue:[
					self possiblyIndent. 
				    ]
				].
				hasIndent := true.] 
			    ifFalse:[
				hasIndent := false.].
			first ifTrue:[
			    first := false].
			].

	SpaceAroundTemporaries ifTrue:[
	    codeStream space.
	].
	codeStream nextPut: $|.
	EmptyLineAfterTemporaries ifTrue:[
	    codeStream cr
	].
	self indent

    "Modified: / 22.11.1999 / 11:25:59 / cg"
!

newLinesFor: aString startingAt: anIndex 
	| count cr lf index char |
	cr := Character value: 13.
	lf := Character value: 10.
	count := 0.
	index := anIndex - 1.
	[index > 0 and: 
			[char := aString at: index.
			char isSeparator]] 
		whileTrue: 
			[char == lf 
				ifTrue: 
					[count := count + 1.
					(aString at: (index - 1 max: 1)) == cr ifTrue: [index := index - 1]].
			char == cr ifTrue: [count := count + 1].
			index := index - 1].
	^count
! !

!RBFormatter methodsFor:'private-formatting-comments'!

formatArgumentComments:comments for: aNode 
	self formatComments:comments for: aNode spaceAfter:true.
!

formatBlockCommentFor:aNode 
	|comments nComments comment commentString|

	comments := aNode comments.
	nComments := comments size.
	nComments == 0 ifTrue:[ ^  self ].

	nComments == 1 ifTrue:[
	    comment := comments first.    
	    commentString := aNode source copyFrom:comment first to:comment last.
	    comment isEOLComment ifTrue:[
		self indent.
		codeStream nextPutAll:commentString.
		codeStream cr.
	    ] ifFalse:[
		codeStream nextPutAll:commentString.
	    ].
	    ^ self
	].

	self formatStatementCommentFor:aNode.        
!

formatComments:comments for: aNode spaceAfter:spaceafter
    self formatComments:comments for: aNode spaceBefore:false spaceAfter:spaceafter
!

formatComments:comments for: aNode spaceBefore:spaceBefore spaceAfter:spaceafter
        | first needSpace needCR prevComment |

        comments isEmpty ifTrue:[^ self].

        (comments first lineNumber > aNode firstLineNumber) ifTrue:[
            self indent.
        ].

        first := true.
        needSpace := false.
        needCR := false.

        comments do:[:eachComment | 
            | crs comment lines|

            (first and:[spaceBefore]) ifTrue:[
                codeStream space
            ].

            needSpace := true.
"
            crs := self newLinesFor: source startingAt: eachComment first.
            (crs - 1 max: 0) timesRepeat: [codeStream cr].
            crs == 0 ifTrue: [self addTab] ifFalse: [self indent].
"
            comment := eachComment characters.

            RBParser isSmalltalkX ifTrue:[
                eachComment isEOLComment ifTrue:[
                    firstLineLength isNil ifTrue:[
                        firstLineLength := comment size
                    ].
                    eachComment lineNumber == aNode lineNumber ifTrue:[ 
                        
                    ] ifFalse:[
                        eachComment startColumn == 1 ifTrue:[
                            self crNoIndent.  
                        ] ifFalse:[
                            self indent.  
                        ].
                    ].
                    codeStream nextPutAll:comment.
                    needSpace := false.
                    needCR := true.
                ] ifFalse:[
                    (comment includes:Character cr) ifTrue:[
                        lines := comment asStringCollection.
                        lines keysAndValuesDo:[:idx :line |
                            |lineWithoutSeparators|

                            lineWithoutSeparators := line withoutSeparators.
                            idx ~~ 1 ifTrue:[
                                (idx == lines size 
                                and:[lineWithoutSeparators = '"']) ifTrue:[
                                    self indent.
                                    codeStream nextPutAll:lineWithoutSeparators
                                ] ifFalse:[
                                    self indent.
                                    codeStream space.
                                    codeStream nextPutAll:lineWithoutSeparators.
                                ]
                            ] ifFalse:[
                                codeStream nextPutAll:lineWithoutSeparators.
                            ].
                        ].
                        needSpace := true.
                    ] ifFalse:[
                        first ifFalse:[codeStream space].
                        codeStream nextPutAll: comment.
                        needSpace := true.
                    ].
                ].
            ] ifFalse:[
                first ifFalse:[codeStream space].
                codeStream nextPutAll: comment.
                needSpace := true.
            ].
            first := false.
            prevComment := eachComment.
        ].

    needSpace ifTrue:[
        spaceafter ifTrue:[
            codeStream space.
        ]
    ].
    needCR ifTrue:[
        self indent.
    ].

    "Modified: / 06-02-2000 / 14:34:12 / cg"
    "Modified: / 15-10-2014 / 02:28:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

formatMethodComment:aComment for:aNode indentBefore:indentBefore 
    self formatMethodComment:aComment for:aNode indentBefore:indentBefore indentAfter:true

    "Modified: / 6.2.2000 / 14:33:42 / cg"
!

formatMethodComment:aComment for:aNode indentBefore:indentBefore indentAfter:indentAfter
        | source cString lines|

        source := aNode source.
"/        source isNil ifTrue: [^self].

        indentBefore ifTrue: [self indent].
        cString := source notNil 
                    ifTrue:[aNode source copyFrom:(aComment first) to:(aComment last)]
                    ifFalse:[aComment characters].
        cString isEmptyOrNil ifTrue:[ ^ self ].
        aComment isEOLComment ifTrue:[
            codeStream nextPutAll: cString.
        ] ifFalse:[
            cString := cString copyFrom:2 to:(cString size - 1).
            lines := cString asCollectionOfLines.
            lines isEmpty ifTrue:[
                ^ self.
            ].
            lines last isBlank ifTrue:[
                lines := lines copyButLast:1.
            ].

            "/ try to keep the relative indentation
            codeStream nextPut: $".
            lines doWithIndex:[:eachCommentLine :idx |
                |lineIndent relIndent currentIndent indent|

                idx == 1 ifTrue:[
                    codeStream nextPutAll:eachCommentLine.
                ] ifFalse:[
                    lineIndent := eachCommentLine indexOfNonSeparator.
                    lineIndent == 0 ifTrue:[
                        "/ mhmh - seems that the user wanted it this way
                    ] ifFalse:[
                        currentIndent := tabs * self class tabIndent.
                        relIndent := lineIndent - (aComment startColumn).
                        relIndent == 0 ifTrue:[
                            STXStyleMethodComments ifTrue:[
                                relIndent := 1.
                            ].
                        ].
                        indent := (currentIndent + relIndent) max:0.
                        codeStream spaces:indent.
                    ].
                    codeStream nextPutAll:(eachCommentLine withoutSeparators).
                ].
                ((STXStyleMethodComments not and:[lines size > 1]) or:[idx < lines size]) ifTrue:[
                    codeStream cr.
                ].
            ].
            (STXStyleMethodComments not and:[lines size > 1]) ifTrue:[ self indentOnly ].
            codeStream nextPut: $".
        ].

        STXModifications ifTrue:[
            false "aBoolean" ifTrue:[
                codeStream cr.
            ].
        ] ifFalse:[
            codeStream cr.
        ].
        indentAfter ifTrue: [self indent]

    "Modified: / 06-02-2000 / 14:33:42 / cg"
    "Modified: / 24-05-2014 / 00:17:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

formatMethodCommentFor:aNode indentBefore:aBoolean 
    |comments|

    comments := aNode commentsBefore.
    comments isEmptyOrNil ifTrue:[^ self].

    self formatMethodComments: comments for: aNode indentBefore: aBoolean.

    "Modified: / 06-02-2000 / 14:33:42 / cg"
    "Modified: / 24-05-2014 / 00:10:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

formatMethodComments:comments for:aNode indentBefore:indentBefore 
        | source |

        comments isEmptyOrNil ifTrue:[^ self].
"/        source := aNode source.
"/        source isNil ifTrue: [^self].

        comments do:[:each |
            self formatMethodComment:each for: aNode indentBefore: indentBefore
        ].

        EmptyLineAfterMethodComment ifTrue:[
            indentBefore ifTrue:[
                self indent.
                " codeStream cr."
            ]
        ].

    "Modified: / 06-02-2000 / 14:33:42 / cg"
    "Modified: / 24-05-2014 / 00:12:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

formatMethodCommentsAfter:comments for:aNode 
    | source cString code n |

    source := aNode source.
    source isNil ifTrue: [^self].
    comments isEmptyOrNil ifTrue:[ ^ self].

    " special case for comment-only methods: leave as is "
    aNode isMethod ifTrue:[
	aNode body hasStatements ifFalse:[

	    " skip back in the generated code to the first column "
	    code := codeStream contents.
	    n := 0.
	    [ (code at:(code size - n)) == Character space ] whileTrue:[ n := n + 1 ].
	    codeStream skip:(n negated).

	    comments do:[:eachComment |
		codeStream spaces:(eachComment startColumn - 1).
		cString := aNode source copyFrom:eachComment first to:eachComment last.
		codeStream nextPutAll: cString.
		codeStream cr.
	    ].
	    ^ self.
	].
    ].

    self 
	indentWhile:[ 
	    EmptyLineBeforeFinalMethodComment ifTrue:[
		codeStream cr.
	    ].
	    self indent.

	    comments keysAndValuesDo:[:idx :eachComment |
		self formatMethodComment:eachComment for:aNode indentBefore:false indentAfter:(idx ~~ comments size)
	    ]
	]
!

formatMethodCommentsAfterRightBar:comments for:aNode  
	| source |

	comments isEmptyOrNil ifTrue:[^ self].
	source := aNode source.
	source isNil ifTrue: [^self].

	comments do:[:each |
	    self formatMethodComment:each for: aNode indentBefore: false
	].

!

formatStatementCommentFor: aNode 
	self formatStatementComments:aNode comments for: aNode
!

formatStatementComments:comments for: aNode 
        | source |
        source := aNode source.
        source isNil ifTrue: [^self].

        comments 
            do:[:eachComment | 
                | crs comment lines|

                crs := self newLinesFor: source startingAt: eachComment first.
                (crs - 1 max: 0) timesRepeat: [codeStream cr].
                crs == 0 ifTrue: [self addTab] ifFalse: [self indent].
                comment := (source copyFrom: eachComment first to: eachComment last).        
                RBParser isSmalltalkX ifTrue:[
                    eachComment isEOLComment ifTrue:[
                        codeStream nextPutAll:comment.
                        codeStream cr.
                        firstLineLength isNil ifTrue:[
                            firstLineLength := comment size - 1
                        ].
                    ] ifFalse:[
                        (comment includes:Character cr) ifTrue:[
                            lines := comment asStringCollection.
                            lines keysAndValuesDo:[:idx :line |
                                |lineWithoutSeparators|

                                idx ~~ 1 ifTrue:[
                                    lineWithoutSeparators := line withoutSeparators.

                                    (idx == lines size 
                                    and:[lineWithoutSeparators = '"']) ifTrue:[
                                        self indent.
                                        codeStream nextPutAll: lineWithoutSeparators
                                    ] ifFalse:[
                                        self indent.
                                        codeStream space.
                                        codeStream nextPutAll: line withoutLeadingSeparators.
                                    ]
                                ] ifFalse:[
                                    codeStream nextPutAll: line.
                                ].
                            ]
                        ] ifFalse:[
                            codeStream nextPutAll: comment.
                        ].
                    ].
                ] ifFalse:[
                    codeStream nextPutAll: comment
                ]
        ]

    "Modified: / 6.2.2000 / 14:34:12 / cg"
!

formatStatementCommentsBefore:comments for:aNode
    comments notEmptyOrNil ifTrue:[
        self formatComments:comments for:aNode spaceBefore:false spaceAfter:true.
    ]
!

formatTemporaryComments:comments for: aNode 
	self formatComments:comments for: aNode spaceAfter:false.
! !

!RBFormatter methodsFor:'testing'!

startMessageSendOnNewLine: aMessageNode 
	(self selectorsToStartOnNewLine includes: aMessageNode selector) 
		ifTrue: [^true].
	(self selectorsToLeaveOnLine includes: aMessageNode selector) ifTrue: [^false].
	(CStyleBlocks 
	and:[aMessageNode arguments size > 0
	and:[ aMessageNode arguments first isBlock]]) ifTrue:[^ true].
	^aMessageNode selector numArgs > self maximumArgumentsPerLine
!

tagBeforeTemporaries
	^RBParser isVisualWorks
! !

!RBFormatter methodsFor:'visiting'!

visitNode: aNode 
        | parenthesis |

        suppressBeforeComment ~~ true ifTrue:[aNode acceptCommentsBeforeVisitor:self].

        parenthesis := self needsParenthesisFor: aNode.
        parenthesis ifTrue: [codeStream nextPut: $(].
        aNode acceptVisitor: self.
        parenthesis ifTrue: [codeStream nextPut: $)].

        suppressAfterComment ~~ true ifTrue:[aNode acceptCommentsAfterVisitor:self].
! !

!RBFormatter methodsFor:'visiting-comments'!

formatCommentsAfter:comments for:aNode 
    self 
	formatComments:comments
	for:aNode
	spaceBefore:true
	spaceAfter:false
!

formatCommentsBefore:comments for:aNode 
    self 
	formatComments:comments
	for:aNode
	spaceBefore:false
	spaceAfter:true
!

formatMethodCommentsBefore:comments for:aNode 
    | source |

    comments isEmptyOrNil ifTrue:[^ self].
    source := aNode source.
    source isNil ifTrue: [^self].

    comments do:[:each |
	self formatMethodComment:each for: aNode indentBefore:true
    ].

    EmptyLineAfterMethodComment ifTrue:[
	self indent.
    ].

    "Modified: / 6.2.2000 / 14:33:42 / cg"
!

formatSequenceCommentsBefore:comments for:aNode 
    comments notEmptyOrNil ifTrue:[ 
	self 
	    formatMethodComments:comments
	    for:aNode
	    indentBefore:false.
	self indent
    ]
! !

!RBFormatter methodsFor:'visitor-double dispatching'!

acceptArrayNode:anArrayNode 
    "format a squeak constructed array { expr1. expr2. ... exprN }"

    |multiline formattedExpressions formatter oldIndent|

    oldIndent := tabs.

    formatter := (self copy)
                    lineStart:0;
                    yourself.

    "try as single line first"
    formattedExpressions := formatter formatArrayNodeExpressions: anArrayNode statements singleLine: true.
    multiline := (self lineLength + formattedExpressions size > self maxLineSize)
                or:[ formatter isMultiLine 
                or:[ false "(anArrayNode statements size > 4)" 
                or:[ anArrayNode statements 
                        contains:[:el | el isLiteral not
                                        and:[ el isVariable not 
                                        and:[ true
                                              "an experiment: allow short expressions; 
                                               does reduce readablility"
                                              "/ |elFormatter|
                                              "/ elFormatter := (self copy) lineStart:0; yourself.
                                              "/ (elFormatter format: el) size > 10.
                                            ]]]
                    ]]].

    multiline ifTrue:[
        formattedExpressions := nil.
"/        "again, as multiline"
"/        formatter := (self copy)
"/                        lineStart:0;
"/                        yourself.
"/        formatter indent.
"/        formattedExpressions := formatter formatArrayNodeExpressions: anArrayNode statements singleLine: false.
    ].

    codeStream nextPut:${.

    formattedExpressions notNil ifTrue:[
        "/ already, as single line
        SpaceAfterBlockStart ifTrue:[ 
            formattedExpressions notEmpty ifTrue:[ codeStream space. ] 
        ].
        codeStream nextPutAll:formattedExpressions.
    ] ifFalse:[
        self indent:1 while:[
            self indent.
            self formatArrayNodeExpressions: anArrayNode statements singleLine: false.
        ].
    ].

    CStyleBlocks ifTrue:[
        multiline ifTrue:[
            self indent
        ] ifFalse:[
            SpaceBeforeBlockEnd 
                ifTrue:[ formattedExpressions notEmpty ifTrue:[ codeStream space. ] ].
        ].
    ] ifFalse:[
        SpaceBeforeBlockEnd 
            ifTrue:[ formattedExpressions notEmpty ifTrue:[ codeStream space. ] ].
    ].
    codeStream nextPut:$}.
    tabs := oldIndent.

    "Modified: / 11-02-2012 / 12:11:55 / cg"
!

acceptAssignmentNode: anAssignmentNode 
    self indent: 1 while:[
        |oldStyle|

        oldStyle := OldStyleAssignments.
        oldStyle := oldStyle or:[ rewriteOldAssignments not ].

        self visitNode: anAssignmentNode variable.
        codeStream nextPutAll:(' ',anAssignmentNode assignmentOperator,' '). "/ oldStyle ifTrue:[' _ '] ifFalse:[' := ']).
        self visitNode: anAssignmentNode value
    ]

    "Modified: / 11-02-2012 / 12:10:13 / cg"
!

acceptBlockNode:aBlockNode 
    |seqNode multiline formattedBody formatter parent parentSelector|

    (CStyleBlocks 
        and:[ (parent := aBlockNode parent) notNil and:[ parent isMessage ] ]) 
            ifTrue:
                [ parent receiver == aBlockNode 
                    ifTrue:
                        [ " I am the receiver of a message (i.e. typically a control structure) "
                        ^ self acceptBlockNodeCStyle:aBlockNode ].
                parentSelector := parent selector.
                parentSelector == #timesRepeat: 
                    ifTrue:
                        [ " I am the receiver of a message (i.e. typically a control structure) "
                        self indent:-2 while:[ ^ self acceptBlockNodeCStyle:aBlockNode ] ] ].
    seqNode := aBlockNode body.
    formatter := (self copy)
                lineStart:0;
                yourself.
    seqNode isNil ifTrue:[ 
        formattedBody := ''
    ] ifFalse:[
        formattedBody := formatter format:seqNode 
    ].
    multiline := (self lineLength + formattedBody size > self maxLineSize) 
                or:[ formatter isMultiLine ].
    (CStyleBlocks and:[ multiline ]) 
        ifTrue:
            [ self indent:-1 while:[ self acceptBlockNodeCStyle:aBlockNode ].
            ^ self ].
    multiline ifTrue:[ self indent ].
    codeStream nextPut:$[.
    SpaceAfterBlockStart 
        ifTrue:
            [ (formattedBody notEmpty and:[ aBlockNode arguments isEmptyOrNil ]) 
                ifTrue:[ codeStream space. ] ].
    self formatBlockArguments:aBlockNode.
    aBlockNode arguments isEmpty 
        ifFalse:
            [ codeStream nextPutAll:'| '.
            multiline ifTrue:[ self indent ] ].
    codeStream nextPutAll:formattedBody.
    SpaceBeforeBlockEnd 
        ifTrue:[ formattedBody notEmpty ifTrue:[ codeStream space. ] ].
    codeStream nextPut:$].
!

acceptBlockNodeCStyle: aBlockNode 
        | seqNode l multiline formattedBody formatter lines|

        seqNode := aBlockNode body.

        formatter := (self copy) lineStart: 0; yourself.
        formatter indentWhile:[
            formattedBody := formatter format: seqNode.
            lines := formattedBody asCollectionOfLines.
            (lines notEmpty and:[lines last isBlank]) ifTrue:[
                formattedBody := (lines copyButLast:1) asStringWith:Character cr.
            ].
        ].
        multiline := (l := self lineLength + formattedBody size) > self maxLineSize
                                or: [formatter isMultiLine].
        multiline := multiline or:[l > (MaxLengthForSingleLineBlocks ? 60)].

        codeStream nextPut: $[.
        multiline ifFalse:[
            SpaceAfterBlockStart 
                ifTrue:[
                    (formattedBody notEmpty and:[aBlockNode hasArguments not]) 
                        ifTrue:[
                            codeStream space.]].
        ].
        self indentWhile:[
            (BlockArgumentsOnNewLine or:[aBlockNode hasArguments not]) ifTrue:[
                multiline ifTrue:[
                    self indent.
                ].
            ].

            self formatBlockArguments:aBlockNode.
            aBlockNode arguments isEmpty 
                ifFalse:[ 
                    codeStream nextPutAll: '| '.
                    multiline ifTrue: [self indent]].
        ].
        codeStream nextPutAll: formattedBody.
        multiline 
            ifTrue: [self indent]
            ifFalse:[ 
                SpaceBeforeBlockEnd 
                    ifTrue:[
                        formattedBody notEmpty 
                            ifTrue:[
                                codeStream space.]]].
        codeStream nextPut: $].

    "Modified: / 6.2.2000 / 14:15:52 / cg"
!

acceptCascadeNode: aCascadeNode 
	| messages |

	messages := aCascadeNode messages.
	self visitNode: messages first receiver.
	self indentWhile: 
			[self 
				for: messages
				do: 
					[:each | 
					self
						indent;
						indentWhile: [self formatMessage: each cascade: true]]
				separatedBy: [codeStream nextPut: $;]]
!

acceptLiteralNode: aLiteralNode 
	^self formatLiteral: aLiteralNode
!

acceptMessageNode:aMessageNode 
    |receiver selector numArgs keywords arguments newFormatter code block block1 block2 cStyle newLine idx|

    receiver := aMessageNode receiver.
    newFormatter := self copy.
     
    "/ pre-generate the code for the receiver into a string. 
    "/ Need length and info if that expanded to multiple lines.
    
    newFormatter suppressBeforeComment:false.
    newFormatter suppressAfterComment:false.
    newFormatter visitNode:receiver.
    code := newFormatter codeStream contents.
    codeStream nextPutAll:code.
    selector := aMessageNode selector.
    numArgs := selector argumentCount.
    arguments := aMessageNode arguments.
    keywords := selector keywords.
    cStyle := CStyleBlocks.
    cStyle ifTrue:[
        idx := self whichArgIsToBeFormattedKRLikeIn:selector.
        ((numArgs == 1) 
            and:[
                (idx == 1) 
                    and:[
                        (block := arguments at:1 ifAbsent:nil) isBlock 
                            and:[ newFormatter isMultiLine not ]
                    ]
            ]) 
                ifTrue:[
                    codeStream space.
                    codeStream nextPutAll:selector.
                    SpaceAfterKeywordSelector ifTrue:[
                        codeStream space.
                    ].
                    self acceptBlockNodeCStyle:block.
                    ^ self.
                ].
        ((numArgs == 2) 
            and:[
                (idx == #both) 
                    and:[
                        (block1 := arguments at:1) isBlock 
                            and:[ (block2 := arguments at:2) isBlock and:[ newFormatter isMultiLine not ] ]
                    ]
            ]) 
                ifTrue:[
                    |parent|
                    (parent := aMessageNode parent) notNil ifTrue:[
                        " if used as value - do it as a one-liner if it fits "
                        ((parent isMessage) or:[ parent isReturn ]) ifTrue:[
                            newFormatter isMultiLine ifFalse:[
                                cStyle := false.
                            ]
                        ].
                    ].    
                    codeStream space.
                    codeStream nextPutAll:(keywords at:1).
                    SpaceAfterKeywordSelector ifTrue:[
                        codeStream space.
                    ].
                    self acceptBlockNodeCStyle:block1.
                    codeStream space.
                    codeStream nextPutAll:(keywords at:2).
                    SpaceAfterKeywordSelector ifTrue:[
                        codeStream space.
                    ].
                    self acceptBlockNodeCStyle:block2.
                    ^ self.
                ].
        ((#( #to:do: ) includes:selector) 
            and:[ (block := arguments at:2) isBlock and:[ newFormatter isMultiLine not ] ]) 
                ifTrue:[
                    codeStream space.
                    codeStream nextPutAll:(keywords at:1).
                    newFormatter := self copy.
                    code := newFormatter format:(arguments at:1).
                    SpaceAfterKeywordSelector ifTrue:[
                        codeStream space.
                    ].
                    codeStream nextPutAll:code.
                    codeStream space.
                    codeStream nextPutAll:(keywords at:2).
                    SpaceAfterKeywordSelector ifTrue:[
                        codeStream space.
                    ].
                    self acceptBlockNodeCStyle:block.
                    ^ self.
                ].
        ((numArgs == 3) 
            and:[
                (#( #to:by:do: ) includes:selector) 
                    and:[ (block := arguments at:3) isBlock and:[ newFormatter isMultiLine not ] ]
            ]) 
                ifTrue:[
                    codeStream space.
                    codeStream nextPutAll:(keywords at:1).
                    newFormatter := self copy.
                    code := newFormatter format:(arguments at:1).
                    SpaceAfterKeywordSelector ifTrue:[
                        codeStream space.
                    ].
                    codeStream nextPutAll:code.
                    codeStream space.
                    codeStream nextPutAll:(keywords at:2).
                    newFormatter := self copy.
                    code := newFormatter format:(arguments at:2).
                    SpaceAfterKeywordSelector ifTrue:[
                        codeStream space.
                    ].
                    codeStream nextPutAll:code.
                    codeStream space.
                    codeStream nextPutAll:(keywords at:3).
                    SpaceAfterKeywordSelector ifTrue:[
                        codeStream space.
                    ].
                    self acceptBlockNodeCStyle:block.
                    ^ self.
                ].
    ].
    codeStream space.
    newFormatter isMultiLine ifTrue:[
        lineStart := codeStream position - newFormatter lastLineLength
    ].
    newLine := newFormatter isMultiLine not or:[ receiver isBlock not ].
    self indent:(newFormatter isMultiLine ifTrue:[
                2
            ] ifFalse:[ 1 ])
        while:[
            self 
                formatMessage:aMessageNode
                cascade:false
                newLine:newLine
        ]

    "Modified: / 6.2.2000 / 14:14:39 / cg"
!

acceptMethodNode: aMethodNode 
        |body|

        self formatMethodCommentsBefore:(aMethodNode commentsBefore) for:aMethodNode.
        self formatMethodPatternFor: aMethodNode.
        body := aMethodNode body.
        body notNil ifTrue:[
            self indentWhile: 
                        [
"
                        self formatMethodCommentFor: aMethodNode indentBefore: true.
"
                        self indent.
                        self tagBeforeTemporaries ifTrue: [self formatTagFor: aMethodNode].
                        body statements isEmpty 
                                ifFalse: [self visitNode: body]]]
!

acceptOptimizedNode: anOptimizedNode 
	codeStream nextPutAll: '##('.
	self visitNode: anOptimizedNode body.
	codeStream nextPut: $)
!

acceptPragmaNode: aLiteralNode 
    ^ self formatPragma: aLiteralNode

    "Created: / 07-10-2014 / 23:43:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

acceptReturnNode:aReturnNode 
    |tA tB|

    codeStream nextPut:$^.
    SpaceAfterReturnToken ifTrue:[ 
	codeStream space
    ].

    tB := suppressBeforeComment.
    tA := suppressAfterComment.
    suppressBeforeComment := false.
    suppressAfterComment := false.

    self visitNode:aReturnNode value.

    suppressBeforeComment := tB.
    suppressAfterComment := tA.

    "Modified: / 22.11.1999 / 11:16:42 / cg"
!

acceptSTXPrimitiveCCodeNode: aPrimitiveNode 
	self formatMethodCommentFor: aPrimitiveNode indentBefore: false.
	codeStream cr.
	codeStream nextPutAll:aPrimitiveNode formattedCode.
!

acceptSTXPrimitiveValueCCodeNode: aPrimitiveNode 
	self formatMethodCommentFor: aPrimitiveNode indentBefore: false.
	codeStream nextPutAll:aPrimitiveNode formattedCode.
!

acceptSequenceNode: aSequenceNode 
	" self formatMethodCommentFor: aSequenceNode indentBefore: false. "
	self formatTemporariesFor: aSequenceNode.
	self formatMethodCommentsAfterRightBar:aSequenceNode commentsAfterRightBar for: aSequenceNode.
	self tagBeforeTemporaries ifFalse: 
			[| parent |
			parent := aSequenceNode parent.
			(parent notNil and: [parent isMethod]) ifTrue: [self formatTagFor: parent]].
	self formatStatementsFor: aSequenceNode
!

acceptVariableNode: aVariableNode 
	codeStream nextPutAll: aVariableNode name.
!

formatBlockArguments:aBlockNode 
    aBlockNode arguments 
	do:[:each | 
	    self 
		formatComments:(each commentsBefore)
		for:each
		spaceBefore:false
		spaceAfter:true.
	    codeStream nextPut:$:.
	    codeStream nextPutAll:each name.
	    self 
		formatComments:(each commentsAfter)
		for:each
		spaceBefore:true
		spaceAfter:false.
	    codeStream space ]
!

whichArgIsToBeFormattedKRLikeIn:selector
    "for CStyle (kernigham-ritchie style) formatting of blocks arguments.
     Return the arg-index or nil"
     
    ( #(
        #'ifTrue:' #'ifFalse:' 
        #'do:' 
        #'whileTrue:' #'whileFalse:'
    ) includes:selector) ifTrue:[
        ^ 1
    ].
    ( #(
        #'ifTrue:ifFalse:' 
        #'ifFalse:ifTrue:'
    ) includes:selector) ifTrue:[
        ^ #both
    ]. 
    ^ nil
! !

!RBFormatter class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

