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

Object subclass:#EditSupport
	instanceVariableNames:'textView backspaceIsUndo completionController
		completionEnvironment snippets ignoreKeystrokes
		ignoreKeystrokesPosition ignoreKeystrokesStartLine
		ignoreKeystrokesStartCol electricInsertSuppressed'
	classVariableNames:''
	poolDictionaries:''
	category:'SmallSense-Core-Services'
!

!EditSupport class methodsFor:'documentation'!

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

!EditSupport class methodsFor:'instance creation'!

forLanguage: aProgrammingLanguage
    aProgrammingLanguage notNil ifTrue:[
        aProgrammingLanguage isSmalltalk ifTrue:[
            ^ SmalltalkEditSupport new
        ].
        (aProgrammingLanguage askFor: #isJava) ifTrue:[    
            ^ JavaEditSupport new
        ].
        (aProgrammingLanguage askFor: #isGroovy) ifTrue:[    
            ^ GroovyEditSupport new
        ]  
    ].

    ^GenericEditSupport new.

    "Created: / 24-07-2013 / 23:20:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-10-2013 / 08:41:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!EditSupport methodsFor:'accessing'!

electricInsertSuppressed
    ^ electricInsertSuppressed
!

environment
    ^ completionEnvironment ? Smalltalk

    "Created: / 15-05-2014 / 16:44:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-02-2015 / 23:58:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

language
    ^ self subclassResponsibility.

    "Created: / 24-07-2013 / 23:44:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

textView
    ^ textView

    "Created: / 03-02-2014 / 23:28:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!EditSupport methodsFor:'accessing-classes'!

completionControllerClass
    "raise an error: this method should be implemented (TODO)"

    ^ CompletionController

    "Created: / 13-05-2014 / 16:13:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

completionEngineClass
    "Returns a code completion engine class or nil, of 
     no completion is supported"

    ^ nil

    "Created: / 03-10-2013 / 17:43:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

scannerClass
    "Returns a class to use for scanning lines. If nil, scanning is
     not supported and scanLine* methods will return an empty array."

    ^ nil

    "Created: / 22-10-2013 / 00:33:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!EditSupport methodsFor:'editing'!

electricDeleteCharacterAtCol: col 
    textView deleteCharAtLine: textView cursorLine col: col

    "Created: / 22-01-2014 / 21:17:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

electricDeleteCharacterAtLine:line col: col 
    textView deleteCharAtLine: line col: col

    "Created: / 22-01-2014 / 21:16:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

electricDo:aBlock 
    textView completionSupport notNil ifTrue:[
        (textView completionSupport)
            stopCompletionProcess;
            closeCompletionView.
    ].
    textView hasSelection ifTrue:[
        textView undoableDo:[ textView deleteSelection ].
    ].
    textView undoableDo:[ aBlock value. ].
    backspaceIsUndo := true.

    "Created: / 17-09-2013 / 23:15:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-10-2013 / 03:15:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

electricInsert:text 
    self electricInsert:text advanceCursorBy:nil.

    "Created: / 22-10-2013 / 11:08:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

electricInsert:stringOrLines advanceCursorBy:offsetOrNil 
    ^ self 
            electricInsert:stringOrLines
            advanceCursorBy:offsetOrNil
            ignoreKeystrokes:nil

    "Created: / 22-10-2013 / 11:56:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 19-01-2014 / 20:29:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

electricInsert:stringOrLines advanceCursorBy:offsetOrNil ignoreKeystrokes:ignoreKeystrokeSequence 
    "Insert given stringOrLines. If offsetOrNil is not nil, then
     move cursor by `offsetOrNil` after the **begining** of
     inserted text. If `ignoreKeystrokeSequence` is not nil and not empty, then if
     subsequent key strokes are ignored (i.e, does nothing) if matches
     the given sequence. This is used to avoid duplication if user is not
     aware of electric insertion and types whole text that has been
     (electrically) inserted).

     `stringOrLines` could be either string or collection of strings (lines)
     `offsetOrNil` could be either integer (cursor is then advanced by
            offsetOrNil characters after **begining** of inserted text)
            or point (x,y, cursor is then advanced by x lines after current
            line and by y characters after beggining of the inserted text
            (if x == 0) or at set at column y (if x ~~ 0)
     `ignoreKeystrokeSequence` a sequenceable collection of keys (in a form
            as passed to #keyPress:x:y: method."
    
    | lineOffset colOffset oldCursorLine oldCursorCol newCursorLine newCursorCol advanceCursor |

    advanceCursor := false.
    ignoreKeystrokeSequence notNil ifTrue:[ 
        oldCursorLine := textView cursorLine.
        oldCursorCol := textView cursorCol.
    ].
    offsetOrNil notNil ifTrue:[
        lineOffset := offsetOrNil isPoint ifTrue:[
                offsetOrNil x
            ] ifFalse:[ 0 ].
        colOffset := offsetOrNil isPoint ifTrue:[
                offsetOrNil y
            ] ifFalse:[
                offsetOrNil
            ].
        newCursorLine := textView cursorLine + lineOffset.
        newCursorCol := (lineOffset == 0 
                ifTrue:[ textView cursorCol ]
                ifFalse:[ 0 ]) + colOffset.
        advanceCursor := true.
    ].
    self 
        electricDo:[
            stringOrLines isString ifTrue:[
                "/ Simple strin
                textView insertStringAtCursor:stringOrLines.
            ] ifFalse:[
                "/ C
                textView insertLines:stringOrLines withCR:false.
            ].
            advanceCursor ifTrue:[
                (textView cursorLine ~~ newCursorLine 
                    or:[ textView cursorCol ~~ newCursorCol ]) 
                        ifTrue:[ textView cursorLine:newCursorLine col:newCursorCol. ].
            ].
        ].
    ignoreKeystrokeSequence notEmptyOrNil ifTrue:[
        ignoreKeystrokes := ignoreKeystrokeSequence.
        ignoreKeystrokesPosition := 1.
        stringOrLines isString ifTrue:[ 
            ignoreKeystrokesStartLine := oldCursorLine.
            ignoreKeystrokesStartCol := oldCursorCol + (stringOrLines size - ignoreKeystrokeSequence size)
        ].
    ].

    "Created: / 19-01-2014 / 20:29:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-03-2015 / 06:29:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

electricInsert:text ignoreKeystrokes:ignore 
    self 
        electricInsert:text
        advanceCursorBy:nil
        ignoreKeystrokes:ignore

    "Created: / 21-01-2014 / 23:29:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

electricInsertBlockOpenedBy:openText closedBy:closeText 
    | indent  lines  autoIndent |

    textView completionSupport notNil ifTrue:[
        (textView completionSupport)
            stopCompletionProcess;
            closeCompletionView.
    ].
    indent := self indentAtCursorLine.
    autoIndent := textView autoIndent.
    textView autoIndent:false.
    [
        textView 
            undoableDo:[
                lines := Array 
                        with:openText ? ''
                        with:''
                        with:((String new:indent withAll:Character space) , closeText).
                self electricInsert:lines advanceCursorBy:1 @ (indent + 5)
            ].
    ] ensure:[ textView autoIndent:autoIndent ].

    "Created: / 25-07-2013 / 10:41:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-01-2014 / 21:20:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

electricInsertSnippet
    ^ false

    "Created: / 22-10-2013 / 01:54:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!EditSupport methodsFor:'event handling'!

keyPress: key x:x y:y in: view
    "Handles an event in given view (a subview of codeView).
     If the method returns true, the event will not be processed
     by the view.

     IMPORTANT: Never ever call `^ super keyPress: key x:x y:y in: view`,
     as keyPresIgnore... advances position and calling keyPressIgnore here
     and calling super would advance it twice!!
     "

    view ~~ textView ifTrue:[ ^ false ].

    (self keyPressIgnored: key) ifTrue:[
        ^ true.
    ].

    UserPreferences current smallSenseElectricEditSupportEnabled ifFalse:[ ^ false ].

    key == Character space ifTrue:[
        ^ self electricInsertSnippet
    ].

    ^false

    "Created: / 24-07-2013 / 23:31:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-05-2015 / 00:01:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

keyPressIgnored
    "Advance position in keyPressIgnore buffer. Return true if position has been edvanced, false othwrwise"
    ignoreKeystrokes notNil ifTrue:[
        ignoreKeystrokesPosition := ignoreKeystrokesPosition + 1.
        ignoreKeystrokesPosition > ignoreKeystrokes size ifTrue:[
            "/ Nil out instvars if there's no more keys to ignore.
            ignoreKeystrokes := ignoreKeystrokesPosition := nil.
        ].
        ^ true.
    ].
    ^ false.

    "Created: / 11-08-2014 / 14:56:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

keyPressIgnored: key
    ignoreKeystrokes notNil ifTrue:[
        (ignoreKeystrokes at: ignoreKeystrokesPosition) == key ifTrue:[
            "/ Key stroke should be ignored...
            ignoreKeystrokesPosition := ignoreKeystrokesPosition + 1.
            ignoreKeystrokesPosition > ignoreKeystrokes size ifTrue:[
                "/ Nil out instvars if there's no more keys to ignore.
                ignoreKeystrokes := ignoreKeystrokesPosition := ignoreKeystrokesStartLine := ignoreKeystrokesStartCol := nil.
            ].
            ^ true.
        ] ifFalse:[
            "/ User continued typing something else. If it *seems* to be
            "/ thet user wanted something else, then delete the rest, i.e.,
            "/ user typed:
            "/ 
            "/ th
            "/ 
            "/ then the machinery completed `isContext` so the text is
            "/ 
            "/ thisContext
            "/ 
            "/ and user continues typing `isValue`. In that case user wanted to
            "/ `thisValue` instead of `thisContext` - in this case remove the rest
            "/ of what has been completed.
            "/ 
            "/ However, imagine following case: user types `th` so it completes
            "/ `thisContext` like in previous case. Now the user types . (dot).
            "/ to end the statement. In this case, perhaps `thisContext` is what
            "/ he needs.
            "/ 
            "/ How to tell between those two cases?
            "/ 
            "/ Currently, a simple heuristics is used - if the typed character can be
            "/ part of an identifier, then it's the former case, otherwise assume
            "/ the latter. We'll see.
            "/
            (key isCharacter and:[key isLetterOrDigit or:[key == $_]]) ifTrue:[ 
                ignoreKeystrokesStartLine notNil ifTrue:[  
                    textView deleteCharsAtLine: ignoreKeystrokesStartLine fromCol: ignoreKeystrokesStartCol + ignoreKeystrokesPosition - 1 toCol: ignoreKeystrokesStartCol + ignoreKeystrokes size - 1.
                    textView setCursorLine: ignoreKeystrokesStartLine.
                    textView setCursorCol: ignoreKeystrokesStartCol + ignoreKeystrokesPosition - (ignoreKeystrokesPosition > 1 ifTrue:[ 1 ] ifFalse:[ 0 ]).
                ].
            ].
            ignoreKeystrokes := ignoreKeystrokesPosition := ignoreKeystrokesStartLine := ignoreKeystrokesStartCol := nil.
            ^ false.
        ].
    ].
    ^ false.

    "Created: / 20-01-2014 / 09:11:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-03-2015 / 12:47:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 06-03-2015 / 07:08:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

keyPressSpace
    ^ self electricInsertSnippet

    "Created: / 22-10-2013 / 01:43:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!EditSupport methodsFor:'initialization'!

initializeCompletion
    | controller |

    UserPreferences current smallSenseCompletionEnabled ifTrue:[
        self completionEngineClass notNil ifTrue:[
            controller := self completionControllerClass for: textView.
            controller support: self.
            textView completionSupport: controller.
        ].
    ].

    "Created: / 18-05-2014 / 12:40:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-02-2015 / 23:44:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initializeForService:anEditService
    completionEnvironment := anEditService environment.
    self initializeForTextView: anEditService textView.

    "Created: / 27-09-2013 / 13:19:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-02-2015 / 00:16:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initializeForTextView: anEditTextView
    textView := anEditTextView.
    backspaceIsUndo := false.
    electricInsertSuppressed := false.
    self initializeCompletion.

    "Created: / 12-02-2015 / 00:16:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-03-2015 / 17:14:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!EditSupport methodsFor:'private'!

indentAtCursorLine
    | line |

    line := textView listAt: textView cursorLine.
    ^ line isNil ifTrue:[
        (textView cursorCol - 1) max: 0.
    ] ifFalse:[
        (line indexOfNonSeparator - 1) max: 0.
    ]

    "Created: / 25-07-2013 / 00:13:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-02-2015 / 23:44:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

wordBeforeCursor
    ^ self wordBeforeCursorConsisitingOfCharactersMatching: [:c | c isAlphaNumeric ].

    "Created: / 27-09-2013 / 15:53:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 31-03-2014 / 23:03:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

wordBeforeCursorConsisitingOfCharactersMatching: characterMatchBlock
    |  currentLine wordStart wordEnd |
    currentLine := textView list at: textView cursorLine ifAbsent:[ ^ '' ].
    currentLine isNil ifTrue:[ ^ '' ].
    wordEnd := textView cursorCol - 1.
    wordEnd > currentLine size ifTrue:[ ^ '' ].
    wordEnd ~~ 0 ifTrue:[
        wordStart := wordEnd.
        [ wordStart > 0 and:[characterMatchBlock value:(currentLine at: wordStart) ] ] whileTrue:[
            wordStart := wordStart - 1.
        ].
        wordStart := wordStart + 1.
        wordStart <= wordEnd ifTrue:[
            ^ currentLine copyFrom: wordStart to: wordEnd.
        ].
    ].
    ^ ''

    "Created: / 31-03-2014 / 23:02:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-06-2014 / 07:27:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!EditSupport methodsFor:'private-scanning'!

scanLineAt: lineNumber 
    "Scans line at given line number.

     Returns and array of tokens, **excluding** EOF. Each token is represented
     by four subsequent items in the array: token type, token value, start position, end position.
     Thus, returned array size is always multiple of 4."

    ^ self scanLineAt: lineNumber using: self scannerClass

    "Created: / 22-10-2013 / 00:34:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

scanLineAt: lineNumber using: scannerClass
    "Scans line at given line number using given scanner class.

     Returns and array of tokens, **excluding** EOF. Each token is represented
     by four subsequent items in the array: token type, token value, start position, end position.
     Thus, returned array size is always multiple of 4."

    | line scanner token tokenLastEndPosition |

    scannerClass isNil ifTrue:[ ^ #() ].
    line := textView listAt: textView cursorLine.
    line isNil ifTrue:[ ^ #() ].
    scanner := scannerClass for: line string.
    tokenLastEndPosition := 0.
    ^ OrderedCollection streamContents:[:tokens |
        [
            [ token := scanner nextToken.token ~~ #EOF ] whileTrue:[
                tokens 
                    nextPut: token; 
                    nextPut: (scanner tokenName notNil ifTrue:[scanner tokenName] ifFalse:[ scanner tokenValue printString ]); 
                    nextPut: scanner tokenStartPosition;
                    nextPut: (tokenLastEndPosition := scanner tokenEndPosition).
            ].
        ] on: Error do:[
                tokens 
                    nextPut: 'Error'; 
                    nextPut: (line copyFrom: tokenLastEndPosition + 1 to: line size); 
                    nextPut: tokenLastEndPosition + 1;
                    nextPut: line size.
        ].
    ].

    "Created: / 22-10-2013 / 00:31:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-02-2015 / 23:43:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

scanLineAtCursor
    "Scans current cursor line.

     Returns and array of tokens, **excluding** EOF. Each token is represented
     by four subsequent items in the array: token type, token value, start position, end position.
     Thus, returned array size is always multiple of 4."

    ^ self scanLineAt: textView cursorLine using: self scannerClass

    "Created: / 22-10-2013 / 00:34:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-02-2015 / 23:44:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!EditSupport class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

