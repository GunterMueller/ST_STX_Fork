"
 COPYRIGHT (c) 2015 Jan Vrany
 COPYRIGHT (c) 2017 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libwidg/tests' }"

"{ NameSpace: Smalltalk }"

TestCase subclass:#EditTextViewTests
	instanceVariableNames:'preferences textView textViewInteractor'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Text-Tests'
!

!EditTextViewTests class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2015 Jan Vrany
 COPYRIGHT (c) 2017 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!EditTextViewTests methodsFor:'running'!

setUp
    | topView |

    self skipIf: Screen current isNil description: 'No display connection'.

    Smalltalk loadPackage: 'stx:goodies/sunit/ext/ui'.

    preferences := UserPreferences new.
    MessageTracer mock: #current  in: UserPreferences class do: [ preferences ].
    self assert: UserPreferences current == preferences.

    topView := StandardSystemView new.
    topView extent: 320 @ 200.
    topView label: self printString.
    textView := EditTextView origin: 0.0@0.0 extent: 1.0@1.0 in: topView.
    textView setTabPositions: ListView tab4Positions.

    textViewInteractor := textView interactor.

    topView open.
    topView waitUntilVisible.

    "Created: / 23-07-2014 / 07:15:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-07-2018 / 09:43:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

tearDown
    textView topView destroy.
    MessageTracer unmock: #current  in: UserPreferences class

    "Created: / 23-07-2014 / 07:17:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-10-2017 / 22:59:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!EditTextViewTests methodsFor:'tests'!

test_01
    textView contents: 'Hello, here is Smalltalk X'.
    textView setCursorCol: 14.

    textViewInteractor type: #SelectWord.
    self assert: textView selectionAsString = 'is'.

    textViewInteractor type: #CtrlShiftCursorRight.
    textViewInteractor type: #CtrlShiftCursorRight.

    self assert: textView selectionAsString = 'is Smalltalk '.
 
    "Created: / 24-02-2015 / 08:21:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_issue124_case1_01
    "
    See https://swing.fit.cvut.cz/projects/stx-jv/ticket/124#comment:19
    "    

    textView contents:'1234'.
    textView setCursorCol:3.
    textView selectToEndOfLine.
    self assert:textView selectionAsString = '34'.
    textView setClipboardText:'Smalltalk'.
    textViewInteractor type:#Paste.
    self assert:textView selectionAsString = 'Smalltalk'.
    self assert:textView contents asString = ('12Smalltalk' , Character cr).
    textViewInteractor type:#Undo.
    self assert:textView contents asString = ('1234' , Character cr).

    "Created: / 17-03-2017 / 09:46:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 04-05-2017 / 22:31:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_issue124_case1_02
    "
    See https://swing.fit.cvut.cz/projects/stx-jv/ticket/124#comment:19
    "

    textView contents:'1234'.
    textView setCursorCol:3.
    textView selectToEndOfLine.
    self assert:textView selectionAsString = '34'.
    textView setClipboardText:'1-LINEA
2-LINEB
3-LINEC
'.
    textViewInteractor type:#Paste.
    self assert:textView selectionAsString = '1-LINEA
2-LINEB
3-LINEC
'.
    self assert:textView contents asString = ('121-LINEA
2-LINEB
3-LINEC
').
    textViewInteractor type:#Undo.
    self assert:textView contents asString = ('1234' , Character cr).

    "Created: / 17-03-2017 / 09:48:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-03-2017 / 14:13:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 04-05-2017 / 22:31:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_issue124_case1_04
    "
    See https://swing.fit.cvut.cz/projects/stx-jv/ticket/124#comment:19
    "
    textViewInteractor type:'1234'.
    self assert:textView contents asString = ('1234' , Character cr).
    textViewInteractor type:#Undo.
    self assert:textView contents asString = ('' , Character cr).

    "Created: / 17-03-2017 / 21:42:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 04-05-2017 / 22:31:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_issue124_case1_05
    "
    See https://swing.fit.cvut.cz/projects/stx-jv/ticket/124#comment:19
    "

    textViewInteractor type:'1234'.
    self assert:textView contents asString = ('1234' , Character cr).
    textView setClipboardText:'Blah blag'.
    textViewInteractor type:#Paste.
    self assert:textView contents asString = ('1234Blah blag' , Character cr).
    textViewInteractor type:#Undo.
    self assert:textView contents asString = ('1234' , Character cr).
    textViewInteractor type:#Undo.
    self assert:textView contents asString = ('' , Character cr).

    "Created: / 17-03-2017 / 22:43:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 04-05-2017 / 22:32:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_issue130_01a
    "
    Test indenting code by Tab. Scenario:
        1. Position code to beggining of a line 2.
        2. Select a line by pression Shift-Down so that 'cursor' is before first character on line 3.
        3. Press Tab

    Check that only line 2 has been indented.
    Check, that selection begin/end col has not been updated

    See https://swing.fit.cvut.cz/projects/stx-jv/ticket/130
    "    
    textView contents:'1111
2222
3333
4444'.
    textView cursorLine:2 col: 1.

    textViewInteractor type:#ShiftDown.
    self assert: textView selectionStartCol == 1.
    self assert: textView selectionEndCol == 0.
    textViewInteractor type:#Tab.
    self assert: textView contents = '1111
    2222
3333
4444
'.
    self assert: textView selectionStartCol == 1.
    self assert: textView selectionEndCol == 0.

    "Created: / 11-10-2017 / 22:29:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_issue130_01b
    "
    Test indenting code by Tab. Scenario:
        1. Position code to beggining of a line 2.
        2. Select 2 libes by pression Shift-Down twice so that 'cursor' is before first character on line 4.
        3. Press Tab

    Check that only line 2 and 3 have been indented.
    Check, that selection has not been changed

    See https://swing.fit.cvut.cz/projects/stx-jv/ticket/130
    "    
    textView contents:'1111
2222
3333
4444'.
    textView cursorLine:2 col: 1.

    textViewInteractor type:#ShiftDown.
    textViewInteractor type:#ShiftDown.
    self assert: textView selectionStartCol == 1.
    self assert: textView selectionEndCol == 0.    
    textViewInteractor type:#Tab.
    self assert: textView contents = '1111
    2222
    3333
4444
'.
    self assert: textView selectionStartCol == 1.
    self assert: textView selectionEndCol == 0.

    "Created: / 11-10-2017 / 22:30:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_issue130_01c
    "
    Test indenting code by Tab. Like 01b but uses tab width of 8 spaces.
        1. Position code to beggining of a line 2.
        2. Select 2 libes by pression Shift-Down twice so that 'cursor' is before first character on line 4.
        3. Press Tab

    Check that only line 2 and 3 have been indented.
    Check, that selection has not been changed

    See https://swing.fit.cvut.cz/projects/stx-jv/ticket/130
    "    
    textView setTabPositions: ListView tab8Positions.
    textView contents:'1111
2222
3333
4444'.
    textView cursorLine:2 col: 1.

    textViewInteractor type:#ShiftDown.
    textViewInteractor type:#ShiftDown.
    self assert: textView selectionStartCol == 1.
    self assert: textView selectionEndCol == 0.    
    textViewInteractor type:#Tab.
    self assert: textView contents = '1111
        2222
        3333
4444
'.
    self assert: textView selectionStartCol == 1.
    self assert: textView selectionEndCol == 0.

    "Created: / 12-10-2017 / 23:18:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_issue130_01d
    "
    Test indenting code by Tab. Like 01b but select from ;bottom' to 'top':
        1. Position code to beggining of a line 4.
        2. Select 2 libes by pression Shift-Uo twice so that 'cursor' is before first character on line 2.
        3. Press Tab

    Check that only line 3 and 4 have been indented.
    Check, that selection has not been changed

    See https://swing.fit.cvut.cz/projects/stx-jv/ticket/130
    "    
    textView contents:'1111
2222
3333
4444'.
    textView cursorLine:5 col: 1.

    textViewInteractor type:#ShiftUp.
    textViewInteractor type:#ShiftUp.
    self assert: textView selectionStartCol == 1.
    self assert: textView selectionEndCol == 0.    
    textViewInteractor type:#Tab.
    self assert: textView contents = '1111
2222
    3333
    4444
'.
    self assert: textView selectionStartCol == 1.
    self assert: textView selectionEndCol == 0.

    "Created: / 12-10-2017 / 23:26:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-10-2017 / 23:28:10 / jv"
!

test_issue130_02a
    "
    Test indenting code by Tab. Scenario:
        1. Position code to the middle of line 2
        2. Select a line by pression Shift-Down so the end of the selection is in
           the middle of line 3
        3. Press Tab

    Check that lines 2 and 3 have been indented.
    Check that selection has been 'indented' too.

    See https://swing.fit.cvut.cz/projects/stx-jv/ticket/130
    "    
    textView contents:'1111
2222
3333
4444'.
    textView cursorLine:2 col: 3.

    textViewInteractor type:#ShiftDown.
    self assert: textView selectionStartCol == 3.
    self assert: textView selectionEndCol == 2.        
    textViewInteractor type:#Tab.
    self assert: textView contents = '1111
    2222
    3333
4444
'.
    self assert: textView selectionStartCol == 7.
    self assert: textView selectionEndCol == 6.

    "Created: / 11-10-2017 / 22:33:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_issue130_02b
    "
    Test indenting code by Tab. Scenario:
        1. Position code to the middle of line 2
        2. Select 2 lines by pression Shift-Down twice so the end of the selection is in
           the middle of line 4
        3. Press Tab

    Check that lines 2 to 4 have been indented.
    Check that selection has been 'indented' too.

    See https://swing.fit.cvut.cz/projects/stx-jv/ticket/130
    "    
    textView contents:'1111
2222
3333
4444'.
    textView cursorLine:2 col: 3.

    textViewInteractor type:#ShiftDown.
    textViewInteractor type:#ShiftDown.      
    self assert: textView selectionStartCol == 3.
    self assert: textView selectionEndCol == 2.         
    textViewInteractor type:#Tab.
    self assert: textView contents = '1111
    2222
    3333
    4444
'.
    self assert: textView selectionStartCol == 7.
    self assert: textView selectionEndCol == 6.

    "Created: / 11-10-2017 / 22:34:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_issue130_02c
    "
    Test indenting code by Tab. Scenario:
        1. Position code just before first non-bwhitespace character on
           (already indented) line 2.
        2. Select 2 lines by pressing Shift-Down so the end of the selection is
           just before first non-bwhitespace character on (already indented) line 3.
        3. Press Tab

    Check that lines 2 and 3 have been indented.
    Check that selection has been 'indented' too.

    See https://swing.fit.cvut.cz/projects/stx-jv/ticket/130
    "    
    textView contents:'1111
    2222
    3333
4444'.
    textView cursorLine:2 col: 5.

    textViewInteractor type:#ShiftDown.
    self assert: textView selectionStartCol == 5.
    self assert: textView selectionEndCol == 4.     
    textViewInteractor type:#Tab.
    self assert: textView contents = '1111
        2222
        3333
4444
'.
    self assert: textView selectionStartCol == 9.
    self assert: textView selectionEndCol == 8.

    "Created: / 11-10-2017 / 22:35:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_ussue230_01a
    "
     Test paste over selection
        1. Copy some code to clipboard
        2. Select word in an editor
        3. Paste

     Check, that selected code has been replaced by
     pasted text.
"
    
    textView contents:'Here is some word.'.
    textView 
        selectFromLine:1
        col:9
        toLine:1
        col:12.
    self assert:textView selection first = 'some'.
    textView setClipboardText:'pasted'.
    textViewInteractor type:#Paste.
    self assert:textView selection first = 'pasted'.
    self assert:textView contents = 'Here is pasted word.
'.

    "Created: / 17-07-2018 / 09:28:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-07-2018 / 09:28:42 / jv"
!

test_ussue230_01b
    "
     Test paste over selection
        1. Copy some code to clipboard
        2. Select word in an editor using select-world
        3. Paste

     Check, that selected code has been replaced by
     pasted text.
"
    
    textView contents:'Here is some word.'.
    textView setCursorCol:10.
    textViewInteractor type:#SelectWord.
    self assert:textView selection first = 'some'.
    textView setClipboardText:'pasted'.
    textViewInteractor type:#Paste.
    self assert:textView selection first = 'pasted'.
    self assert:textView contents = 'Here is pasted word.
'.

    "Created: / 17-07-2018 / 09:38:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-07-2018 / 09:39:21 / jv"
!

test_ussue230_01c
    "
     Test paste over selection
        1. Copy some code to clipboard using select world, then copy.
        2. Select word in an editor using select-world
        3. Paste

     Check, that selected code has been replaced by
     pasted text.
"
    
    textView contents:'Here is some word.'.
    textView setCursorCol:10.
    textViewInteractor type:#SelectWord.
    self assert:textView selection first = 'some'.
    textViewInteractor type:#Copy.
    textView setCursorCol:3.
    textViewInteractor type:#SelectWord.
    self assert:textView selection first = 'Here'.
    textViewInteractor type:#Paste.
    self assert:textView selection first = 'some'.
    self assert:textView contents = 'some is some word.
'.

    "Created: / 17-07-2018 / 10:13:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!EditTextViewTests class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

