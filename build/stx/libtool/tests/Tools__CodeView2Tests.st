"
 COPYRIGHT (c) 2017 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libtool/tests' }"

"{ NameSpace: Tools }"

TestCase subclass:#CodeView2Tests
	instanceVariableNames:'preferences codeView textView textViewInteractor'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-CodeView-Tests'
!

!CodeView2Tests class methodsFor:'documentation'!

copyright
"
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

!CodeView2Tests methodsFor:'running'!

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
    codeView := CodeView2 origin: 0.0@0.0 extent: 1.0@1.0 in: topView.     
    textView := codeView textView.
    textView setTabPositions: ListView tab4Positions.

    textViewInteractor := textView interactor.

    topView open.
    topView waitUntilVisible.

    "Created: / 23-07-2014 / 07:15:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-07-2018 / 12:22:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

tearDown
    textView topView destroy.
    MessageTracer unmock: #current  in: UserPreferences class

    "Created: / 23-07-2014 / 07:17:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-10-2017 / 22:59:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CodeView2Tests methodsFor:'tests'!

test_issue230_01a
    "
     Test paste over selection
        1. Copy some code to clipboard
        2. Select word in an editor
        3. Paste

     Check, that selected code has been replaced by
     pasted text."
    
    textView contents:'Here is some word.'.
    textView 
        selectFromLine:1
        col:9
        toLine:1
        col:12.
    self assert:textView selection first equals: 'some'.
    textView setClipboardText:'pasted'.
    textViewInteractor type:#Paste.
    self assert:textView selection first equals: 'pasted'.
    self assert:textView contents equals: 'Here is pasted word.
'.

    "Created: / 17-07-2018 / 09:28:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-07-2018 / 09:28:42 / jv"
    "Modified: / 29-08-2018 / 21:43:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_issue230_01b
    "
     Test paste over selection
        1. Copy some code to clipboard
        2. Select word in an editor using select-world
        3. Paste

     Check, that selected code has been replaced by
     pasted text."
    
    textViewInteractor type:'Here is some word.'.
    textView setCursorCol:10.
    textViewInteractor type:#SelectWord.
    self assert:textView selection first equals: 'some'.
    textView setClipboardText:'pasted'.
    textViewInteractor type:#Paste.
    self assert:textView selection first equals: 'pasted'.
    self assert:textView contents equals: 'Here is pasted word.
'.

    "Created: / 17-07-2018 / 09:37:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 29-08-2018 / 21:43:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_issue230_01c
    "
     Test paste over selection
        1. Copy some code to clipboard using select world, then copy.
        2. Select word in an editor using select-world
        3. Paste

     Check, that selected code has been replaced by
     pasted text."
    
    textView contents:'Here is some word.'.
    textView setCursorCol:10.
    textViewInteractor type:#SelectWord.
    self assert:textView selection first equals: 'some'.
    textViewInteractor type:#Copy.
    textView setCursorCol:3.
    textViewInteractor type:#SelectWord.
    self assert:textView selection first equals: 'Here'.
    textViewInteractor type:#Paste.
    self assert:textView selection first equals: 'some'.
    self assert:textView contents equals: 'some is some word.
'.

    "Created: / 17-07-2018 / 10:16:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 29-08-2018 / 21:43:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CodeView2Tests class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

