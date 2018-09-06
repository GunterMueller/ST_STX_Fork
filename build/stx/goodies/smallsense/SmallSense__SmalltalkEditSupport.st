"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2015 Jan Vrany
Copyright (C) 2014 Claus Gittinger

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License. 

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
"{ Package: 'stx:goodies/smallsense' }"

"{ NameSpace: SmallSense }"

EditSupport subclass:#SmalltalkEditSupport
	instanceVariableNames:'lastTypedKey0 lastTypedKey1 lastTypedKey2 lastTypedKey3'
	classVariableNames:''
	poolDictionaries:''
	category:'SmallSense-Smalltalk'
!

!SmalltalkEditSupport class methodsFor:'documentation'!

copyright
"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2015 Jan Vrany
Copyright (C) 2014 Claus Gittinger

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License. 

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
! !

!SmalltalkEditSupport class methodsFor:'utilities'!

indent: text by: level
    ^ String streamContents:[ :out |
        | in |

        in := text readStream.
        [ in atEnd ] whileFalse:[
            in peek == Character cr ifTrue:[
                out nextPut: in next.
                out next: level put: Character space.
            ] ifFalse:[
                out nextPut: in next.
            ].
        ].
    ]

    "Created: / 04-05-2014 / 23:29:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

undent: stringOrStringCollection
    | lines indent tabwidth ignoreIndentOfFirstLineIfZero indentOfFirstLineIsZero |

    stringOrStringCollection isStringCollection ifTrue:[ 
        ignoreIndentOfFirstLineIfZero := false.
        stringOrStringCollection removeLast.
        lines := stringOrStringCollection.
    ] ifFalse:[
        ignoreIndentOfFirstLineIfZero := true.
        lines := stringOrStringCollection asStringCollection.
    ].
    tabwidth := (ListView userDefaultTabPositions = ListView tab4Positions) ifTrue:[ 4 ] ifFalse: [ 8 ].
    indent := nil.
    indentOfFirstLineIsZero := false.

    1 to: lines size do:[:lineNo |
        | line lineIndent |

        line := lines at: lineNo.
        lineIndent := line indexOfNonSeparator.
        (lineIndent ~~ 0) ifTrue:[
            indent isNil ifTrue:[
                indent := ((lineIndent - 1) // tabwidth) * tabwidth.
            ] ifFalse:[ 
                indent := (((lineIndent - 1) // tabwidth) * tabwidth) min: indent.
            ].
            indent == 0 ifTrue:[
                (lineNo == 1 and:[ignoreIndentOfFirstLineIfZero]) ifTrue:[
                    indent := nil.
                    indentOfFirstLineIsZero := true.
                ] ifFalse:[
                    ^ stringOrStringCollection isStringCollection
                        ifTrue:[ stringOrStringCollection asStringWithoutFinalCR ]
                        ifFalse:[ stringOrStringCollection ]
                ].
            ].
        ].
    ].
    1 to: lines size do:[:lineNr |  
        (lineNr ~~ 1 or:[indentOfFirstLineIsZero not]) ifTrue:[ 
            lines at: lineNr put: ((lines at: lineNr) copyFrom: indent + 1).
        ].
    ].
    ^ lines asStringWithoutFinalCR

    "Created: / 04-05-2014 / 23:09:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 23-07-2014 / 23:24:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SmalltalkEditSupport methodsFor:'accessing'!

language
    "superclass SmallSenseEditorSupport says that I am responsible to implement this method"

    ^SmalltalkLanguage instance

    "Modified: / 24-07-2013 / 23:46:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SmalltalkEditSupport methodsFor:'accessing-classes'!

completionEngineClass
    ^ SmalltalkCompletionEngine

    "Created: / 02-10-2013 / 13:30:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

scannerClass
    "Returns a class to use for scanning lines. If nil, scanning is
     not supported and scanLine* methods will return an empty array."

    ^ Scanner

    "Created: / 22-10-2013 / 00:39:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SmalltalkEditSupport methodsFor:'editing'!

electricInsert:stringOrLines advanceCursorBy:offsetOrNil
    | ignore |

    (stringOrLines isString and:[ stringOrLines first == lastTypedKey0 ]) ifTrue:[
        ignore := stringOrLines copyFrom:2.
    ].
    ^ self
            electricInsert:stringOrLines
            advanceCursorBy:offsetOrNil
            ignoreKeystrokes:ignore

    "Created: / 20-01-2014 / 09:27:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

electricInsertSnippet
    lastTypedKey0 == Character space ifTrue:[
        ^ self electricInsertSnippetAfterSpace
    ].
    lastTypedKey0 == $: ifTrue:[
        ^ self electricInsertSnippetAfterDoubleColon
    ].
    ^ false.

    "Created: / 22-10-2013 / 02:55:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

electricInsertSnippetAfterDoubleColon
    | tokens  lastToken0  lastValue0 |

    tokens := self scanLineAtCursor.
    tokens isEmptyOrNil ifTrue:[
        ^ false
    ].
    lastToken0 := tokens at:(tokens size - 3).
    lastToken0 = 'Error' ifTrue:[
        ^ false
    ].
    (tokens last > textView cursorCol) ifTrue:[
        ^ false
    ].
    ((lastToken0 == #Identifier)
        and:[ (textView cursorCol - 1) == tokens last ])
            ifTrue:[
                lastValue0 := tokens at:tokens size - 2.
                tokens size > 4 ifTrue:[
                    (#( #do #select #reject #detect #contains #allSatisfy #anySatisfy )
                        includes:lastValue0)
                            ifTrue:[
                                | collectionName iterationVariableName space part1 part2 |

                                space := RBFormatter spaceAfterKeywordSelector ifTrue:[' '] ifFalse:[ '' ].
                                iterationVariableName := 'each'.
                                tokens size > 4 ifTrue:[
                                    collectionName := tokens at:tokens size - 6.
                                    iterationVariableName := self iterationVariableNameForCollectionNamed: collectionName.
                                ].
                                part1 := ':' , space , '[:' , iterationVariableName , ' | '.
                                part2 := ' ]'.
                                self electricInsert:part1 , part2 advanceCursorBy:part1 size.
                                ^ true.
                            ].
                    RBFormatter spaceAfterKeywordSelector ifTrue:[
                        self electricInsert:': '.
                        ^ true.
                    ]
                ].
            ].
    ^ false.

    "Created: / 22-10-2013 / 03:05:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 04-03-2015 / 07:54:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

electricInsertSnippetAfterSpace
    | tokens  lastToken0  lastValue0 |

    tokens := self scanLineAtCursor.
    tokens isEmptyOrNil ifTrue:[
        ^ false
    ].
    lastToken0 := tokens at:(tokens size - 3).
    lastToken0 = 'Error' ifTrue:[
        ^ false
    ].
    (tokens last > textView cursorCol) ifTrue:[
        ^ false
    ].
    lastToken0 == #Keyword ifTrue:[
        lastValue0 := tokens at:tokens size - 2.
        tokens size > 4 ifTrue:[
            (#( #do: #select: #reject: #detect: #contains: #allSatisfy: #anySatisfy: )
                includes:lastValue0)
                    ifTrue:[
                        | collectionName  eachName  part1  part2 |

                        eachName := 'each'.
                        tokens size > 4 ifTrue:[
                            ((collectionName := tokens at:tokens size - 6) last = $s) ifTrue:[
                                (collectionName endsWith:'ses') ifTrue:[
                                    eachName := collectionName copyButLast:2
                                ] ifFalse:[
                                    eachName := collectionName copyButLast:1
                                ].
                            ].
                        ].
                        part1 := ' [:' , eachName , ' | '.
                        part2 := ' ]'.
                        self electricInsert:part1 , part2 advanceCursorBy:part1 size.
                        ^ true.
                    ].
        ]
    ].
    ^ false.

    "Created: / 22-10-2013 / 03:00:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-02-2015 / 00:02:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SmalltalkEditSupport methodsFor:'event handling'!

keyPress: key x:x y:y in: view

    "Handles an event in given view (a subview of codeView).
     If the method returns true, the event will not be processed
     by the view."

    view ~~ textView ifTrue:[ ^ false ].

    (self keyPressIgnored: key) ifTrue:[
        ^ true.
    ].

    lastTypedKey3 := lastTypedKey2.
    lastTypedKey2 := lastTypedKey1.
    lastTypedKey1 := lastTypedKey0.
    lastTypedKey0 := key.

    key == #CodeCompletion ifTrue:[
        | controller |

        (controller := self textView completionSupport) notNil ifTrue:[
            ^ controller handleKeyPress:key x:x y:y
        ].
        ^ false
    ].

    key == #BackSpace ifTrue:[
        backspaceIsUndo ifTrue:[
             textView undo.
             backspaceIsUndo := false.
             electricInsertSuppressed := true.
             ^ true.
        ].
    ].
    backspaceIsUndo := false.

    key == #Paste ifTrue:[
        ^ self keyPressPaste.
    ].

    electricInsertSuppressed ifTrue:[ 
        (key isCharacter and:[ key isSeparator ]) ifTrue:[ 
            electricInsertSuppressed := false.
        ].
    ].

    UserPreferences current smallSenseElectricEditSupportEnabled ifFalse:[ ^ false ]. 

    key == $^ ifTrue:[
        ^ self keyPressReturnToken
    ].
    key == #Return ifTrue: [
        ^ self keyPressReturn
    ].

    key == $: ifTrue: [
        ^ self keyPressDoubleColon.
    ].

    key == $= ifTrue: [
        ^ self keyPressEqual
    ].

    key == Character space ifTrue:[
        ^ self electricInsertSnippet
    ].

    key == $[ ifTrue:[
        ^ self keyPressOpenBracket.
    ].

    ^ false.

    "Created: / 07-03-2010 / 09:36:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 04-05-2015 / 00:05:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

keyPressDoubleColon
    electricInsertSuppressed ifTrue:[ ^ false ].
    ^ self electricInsertSnippetAfterDoubleColon

    "Created: / 22-10-2013 / 03:08:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-03-2015 / 17:07:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

keyPressEqual
    | line |

    electricInsertSuppressed ifTrue:[ ^ false ].      
    line := textView listAt:textView cursorLine.
    line isNil ifTrue:[ ^ false ].
    line := line string.
    line size > textView cursorCol ifTrue: [ ^ false ].
    line size < (textView cursorCol - 1) ifTrue: [ ^ false ].
    (line at: textView cursorCol - 1) == $: ifTrue: [
        self electricInsert:'= '.
        ^ true
    ].
    ^ false

    "Created: / 22-10-2013 / 11:01:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-03-2015 / 17:07:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

keyPressOpenBracket
    "Opening `[` has been pressed. Complete closing bracket and position
     cursor in between them, but only of there's no other text on current line"

    | line |

    electricInsertSuppressed ifTrue:[ ^ false ].      
    line := textView listAt: textView cursorLine.
    line notNil ifTrue:[
        line := line string.
        line size > textView cursorCol ifTrue: [
            line size downTo: textView cursorCol - 1 do:[:i |
                (line at:i) == Character space ifFalse:[ ^ false ].
            ]
        ].
    ].

    RBFormatter spaceAfterBlockStart ifTrue:[
        RBFormatter spaceBeforeBlockEnd ifTrue:[
            self electricInsert:'[  ]' advanceCursorBy: 2 ignoreKeystrokes: nil.
        ] ifFalse:[
            self electricInsert:'[ ]' advanceCursorBy: 2 ignoreKeystrokes: nil.
        ].
    ] ifFalse:[
        RBFormatter spaceBeforeBlockEnd ifTrue:[
            self electricInsert:'[ ]' advanceCursorBy: 1 ignoreKeystrokes: nil .
        ] ifFalse:[
            self electricInsert:'[]' advanceCursorBy: 1 ignoreKeystrokes: nil.
        ].
    ].
    ^ true.

    "Created: / 22-01-2014 / 21:35:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-03-2015 / 06:33:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

keyPressPaste
    | textSelected textPasted currentLineNo currentLine currentLineIsEmpty |

    UserPreferences current smallSenseSmalltalkIndentOnPasteEnabled ifFalse:[ ^ false ].

    electricInsertSuppressed ifTrue:[ ^ false ].      
    textView checkModificationsAllowed ifTrue:[
        textSelected := textPasted := textView getTextSelectionOrTextSelectionFromHistory.
        currentLineNo := textView currentLine.
        currentLineIsEmpty := true.
        ((currentLineNo > textView list size)
            or:[ (currentLine := textView list at: currentLineNo) isNil
                or:[ (currentLineIsEmpty := currentLine indexOfNonSeparator == 0) ]]) ifTrue:[
                    | indent |

                    currentLineIsEmpty ifTrue:[
                        indent := textView leftIndentForLine: currentLineNo.
                        textView setCursorCol: indent + 1.
                    ].
                    textPasted := self class undent: textPasted.
                    textPasted := self class indent: textPasted by: textView cursorCol - 1.

                ].

        textView undoablePasteOrReplace: textPasted info: nil.
    ].
    ^ true

    "Created: / 03-05-2014 / 01:08:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-03-2015 / 17:07:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

keyPressReturn
    | line tokens c i t currentLineIndent closingBracketIndex |

    electricInsertSuppressed ifTrue:[ ^ false ].      
    line := textView listAt: textView cursorLine.
    line isNil ifTrue:[ ^ false ].
    line := line string.

    "/ Check whether there is any text afer cursor
    "/ except of single closing `]`. If there's some text
    "/ don't do anything smart. If there's only single closing
    "/ ']', then remeber it.
    closingBracketIndex := 0.
    line size > textView cursorCol ifTrue: [
        line size downTo: ((textView cursorCol - 1) max: 1) do:[:i |
            (c :=line at:i) == Character space ifFalse:[
                (c == $] and:[closingBracketIndex == 0]) ifTrue:[
                    closingBracketIndex := i.
                ] ifFalse:[
                    ^ false
                ].
            ].
        ]
    ].

    (line indexOfAny:'[|/') == 0 ifTrue:[ ^ false ].

    "/ Insert "/ at the beggining of the line if current line starts with "/
    i := currentLineIndent := line indexOfNonSeparator.
    (i ~~ 0 and:[ i < line size and:[(line at:i) == $" and:[(line at:i + 1) == $/]]]) ifTrue:[
        "/ OK, current line contains eol-comment. Split into
        "/ two actions so backspace deletes only the inserted '"/ ' text
        self electricInsert:#( '' '' ) advanceCursorBy:(1 @ i).
        self electricInsert:'"/ '.
        ^ true
    ].

    "/ Now insert/reindent closing bracket ( ']' ) for block, byt only
    "/ if current preference is C-style blocks
    RBFormatter cStyleBlocks ifFalse:[ ^ false ].
    "/ There are two possible cases:
    "/ (i)  there is no single closing bracket on the line, then
    "/      add closing ] but only iff last typed character is
    "/      either [ or |  !!!!!!!! Otherwise we would get annoying behaviour
    "/      when there's already valid code and someone position cursor after
    "/      opening bracket and press enter.
    "/ (ii) there's single closing bracket on current line
    "/      (closingBracketIndex is non-zero)
    (closingBracketIndex == 0 and:[('[|' includes: lastTypedKey1) not]) ifTrue:[ ^ false ].

    i := textView cursorCol - 1.
    [ (line at: i) isSeparator and:[i > 0] ] whileTrue:[ i := i - 1 ].
    i == 0 ifTrue:[ ^ false ].
    (line at: i) == $[ ifTrue:[
        self electricDo:[
            closingBracketIndex ~~ 0 ifTrue:[
                self electricDeleteCharacterAtCol: closingBracketIndex
            ].
            self electricInsertBlockOpenedBy:nil closedBy:'].'.
        ].
        ^ true
    ].
    tokens := self tokensAtCursorLine.
    tokens isEmpty ifTrue:[ ^ false ].
    i := tokens size.
    t := tokens at: i.
    t == $[ ifTrue:[
        self electricDo:[
            closingBracketIndex ~~ 0 ifTrue:[
                self electricDeleteCharacterAtCol: closingBracketIndex
            ].
            self electricInsertBlockOpenedBy:nil closedBy:'].'.
        ].
        ^ true
    ].
    t == $| ifTrue:[
        i := i - 1.
        [ i > 1 and:[ (tokens at: i) == #Identifier and:[ (tokens at: i - 1) == $: ]] ] whileTrue:[ i := i - 2 ].

        (i ~~ 0 and: [(tokens at: i) == $[]) ifTrue:[
            self electricDo:[
                closingBracketIndex ~~ 0 ifTrue:[
                    self electricDeleteCharacterAtCol: closingBracketIndex
                ].
                self electricInsertBlockOpenedBy:nil closedBy:'].'.
            ].
            ^ true
        ].
        i := tokens size  - 1.
        [ i > 0 and:[ (tokens at: i) == #Identifier ] ] whileTrue:[ i := i - 1 ].
        (i ~~ 0 and: [(tokens at: i) == $|]) ifTrue:[
            RBFormatter emptyLineAfterTemporaries ifTrue:[
                self electricDo:[
                    closingBracketIndex ~~ 0 ifTrue:[
                        self electricDeleteCharacterAtCol: closingBracketIndex
                    ].
                    self electricInsert:#( '' '' '' ) advanceCursorBy:2 @ currentLineIndent.
                ].
                ^ true
            ]
        ]
    ].
    ^ false.

    "Created: / 25-07-2013 / 00:02:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-03-2015 / 17:07:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

keyPressReturnToken
    electricInsertSuppressed ifTrue:[ ^ false ].      
    RBFormatter spaceAfterReturnToken ifTrue:[
        self electricDo:[
            textView insertStringAtCursor:'^ '
        ].
        ^ true
    ].
    ^ false

    "Created: / 24-07-2013 / 23:59:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-03-2015 / 17:07:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SmalltalkEditSupport methodsFor:'initialization'!

initializeForService: anEditService
    super initializeForService: anEditService.
    anEditService textView autoIndent:true.

    "Created: / 27-09-2013 / 13:22:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-02-2015 / 23:59:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SmalltalkEditSupport methodsFor:'private'!

iterationVariableNameForCollectionNamed: collectionName
    | eachName |

    eachName := 'each'.
    ((collectionName) last = $s) ifTrue:[
        (collectionName endsWith:'ses') ifTrue:[
            eachName := collectionName copyButLast:2
        ] ifFalse:[
            eachName := collectionName copyButLast:1
        ].
        UserPreferences current smallSenseSmalltalkIterationVariableNamePrefixWithEach ifTrue:[ 
            eachName := 'each' , eachName capitalized.
        ].
        eachName size > UserPreferences current smallSenseSmalltalkIterationVariableNameMaxLength ifTrue:[ 
            eachName := 'each'.
        ].
    ].
    ^ eachName

    "Created: / 04-03-2015 / 07:52:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

tokensAtCursorLine
    | line scanner token |

    line := (textView listAt: textView cursorLine) string.
    line := line copyTo: textView cursorCol - 1.
    line isEmpty ifTrue:[ ^ #() ].
    scanner := Scanner for: line.
    ^ OrderedCollection streamContents:[:tokens |
        [ token := scanner nextToken.token ~~ #EOF ] whileTrue:[
            tokens nextPut: token.
        ].
    ].

    "Created: / 25-07-2013 / 00:07:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-02-2015 / 00:02:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SmalltalkEditSupport class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

