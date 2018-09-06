"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2015 Jan Vrany

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

EditSupportTests subclass:#SmalltalkEditSupportTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SmallSense-Tests'
!

!SmalltalkEditSupportTests class methodsFor:'documentation'!

copyright
"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2015 Jan Vrany

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

!SmalltalkEditSupportTests methodsFor:'accessing-classes'!

editSupportClass
    "superclass SmallSense::EditSupportTests says that I am responsible to implement this method"

    ^ SmalltalkEditSupport

    "Created: / 23-07-2014 / 07:16:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SmalltalkEditSupportTests methodsFor:'tests - completion'!

test_complete_if_unambiguous_01    

    UserPreferences current smallSenseCompleteIfUnambiguous: true.  
    codeView editedMethodOrClass: self class.
    codeView contents:'editService'.
    codeView setCursorCol: 12.

    codeViewInteractor type: #(Return Tab).
    codeViewInteractor type: 't'.
    Delay waitForMilliseconds: 250.
    codeViewInteractor type: 'h'.
    self assert: (codeView list at: 2) = '    thisContext'.
    Delay waitForMilliseconds: 250.
    codeViewInteractor type: 'i'.
    codeViewInteractor type:'sContext'.
    self assert: (codeView list at: 2) = '    thisContext'.

    "Created: / 23-07-2014 / 23:38:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-05-2015 / 23:50:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_complete_if_unambiguous_02

    UserPreferences current smallSenseCompleteIfUnambiguous: true.  
    codeView editedMethodOrClass: self class.
    codeView contents:'editService'.
    codeView setCursorCol: 12.

    codeViewInteractor type: #(Return Tab).
    codeViewInteractor type: 't'.
    Delay waitForMilliseconds: 250.
    codeViewInteractor type: 'h'.
    self assert: (codeView list at: 2) = '    thisContext'.
    Delay waitForMilliseconds: 250.
    codeViewInteractor type: 'is receiver'.
    self assert: (codeView list at: 2) = '    thisContext receiver'.

    "Created: / 11-08-2014 / 15:00:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_complete_if_unambiguous_03

    UserPreferences current smallSenseCompleteIfUnambiguous: true.  
    codeView editedMethodOrClass: self class.
    codeView contents:'editService'.
    codeView setCursorCol: 12.

    codeViewInteractor type: #(Return Tab).
    codeViewInteractor type: 't'.
    Delay waitForMilliseconds: 250.
    codeViewInteractor type: 'h'.
    self assert: (codeView list at: 2) = '    thisContext'.
    Delay waitForMilliseconds: 250.
    codeViewInteractor type: 'isValue'.
    self assert: (codeView list at: 2) = '    thisValue'.

    "Created: / 11-08-2014 / 15:01:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_complete_if_unambiguous_04

    UserPreferences current smallSenseCompleteIfUnambiguous: true.  
    codeView editedMethodOrClass: self class.
    codeView contents:'editService'.
    codeView setCursorCol: 12.

    codeViewInteractor type: #(Return Tab).
    codeViewInteractor type: 't'.
    Delay waitForMilliseconds: 250.
    codeViewInteractor type: 'h'.
    self assert: (codeView list at: 2) = '    thisContext'.
    Delay waitForMilliseconds: 250.
    codeViewInteractor type: #(BackSpace).
    self assert: (codeView list at: 2) = '    t'.
    codeViewInteractor type: 'h'.
    Delay waitForMilliseconds: 250.
    self assert: (codeView list at: 2) = '    th'.
    Delay waitForMilliseconds: 250.
    codeViewInteractor type: 'e := t'.
    Delay waitForMilliseconds: 250.
    codeViewInteractor type: 'h'.
    Delay waitForMilliseconds: 250.
    self assert: (codeView list at: 2) = '    the := thisContext'.

    "Created: / 03-03-2015 / 17:01:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SmalltalkEditSupportTests methodsFor:'tests - electric snippets'!

test_electric_snippet_do_01

    UserPreferences current smallSenseElectricEditSupportEnabled: true.  
    codeView editedMethodOrClass: self class.
    codeView contents:'editService
    snippets do'.
    codeView setCursorLine: 2; setCursorCol: 16.

    codeViewInteractor type: ':'.
    Delay waitForMilliseconds: 250.
    self assert: (codeView list at: 2) = '    snippets do:[:snippet |  ]'.
    codeViewInteractor type: #(BackSpace).
    self assert: (codeView list at: 2) = '    snippets do'.
    codeViewInteractor type: ':'.
    Delay waitForMilliseconds: 250.
    self assert: (codeView list at: 2) = '    snippets do:'.

    "Created: / 04-03-2015 / 05:54:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-05-2015 / 21:59:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_electric_snippet_do_02

    UserPreferences current smallSenseElectricEditSupportEnabled: true.  
    codeView editedMethodOrClass: self class.
    codeView contents:'editService
    snippets do'.
    codeView setCursorLine: 2; setCursorCol: 16.

    codeViewInteractor type: ':'.
    Delay waitForMilliseconds: 250.
    self assert: (codeView list at: 2) = '    snippets do:[:snippet |  ]'.
    codeViewInteractor type: 'aBlock'.
    self assert: (codeView list at: 2) = '    snippets do: aBlock'.

    "Created: / 04-03-2015 / 06:11:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-05-2015 / 21:59:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_electric_snippet_do_03

    UserPreferences current smallSenseElectricEditSupportEnabled: true.  
    UserPreferences current smallSenseSmalltalkIterationVariableNamePrefixWithEach: true.
    codeView editedMethodOrClass: self class.
    codeView contents:'editService
    snippets do'.
    codeView setCursorLine: 2; setCursorCol: 16.

    codeViewInteractor type: ':'.
    Delay waitForMilliseconds: 250.
    self assert: (codeView list at: 2) = '    snippets do:[:eachSnippet |  ]'.

    "Created: / 04-03-2015 / 08:13:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-05-2015 / 21:59:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_electric_snippet_do_04

    UserPreferences current smallSenseElectricEditSupportEnabled: true.  
    UserPreferences current smallSenseSmalltalkIterationVariableNameMaxLength: 5.
    codeView editedMethodOrClass: self class.
    codeView contents:'editService
    snippets do'.
    codeView setCursorLine: 2; setCursorCol: 16.

    codeViewInteractor type: ':'.
    Delay waitForMilliseconds: 250.
    self assert: (codeView list at: 2) = '    snippets do:[:each |  ]'.

    "Created: / 04-03-2015 / 08:14:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-05-2015 / 21:59:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_electric_snippet_do_05

    UserPreferences current smallSenseElectricEditSupportEnabled: false.
    codeView editedMethodOrClass: self class.
    codeView contents:'editService
    snippets do'.
    codeView setCursorLine: 2; setCursorCol: 16.

    codeViewInteractor type: ':'.
    Delay waitForMilliseconds: 250.
    self assert: (codeView list at: 2) = '    snippets do:'.
    codeViewInteractor type: #(BackSpace).
    self assert: (codeView list at: 2) = '    snippets do'.
    codeViewInteractor type: ':'.
    Delay waitForMilliseconds: 250.
    self assert: (codeView list at: 2) = '    snippets do:'.

    "Created: / 02-05-2015 / 21:58:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SmalltalkEditSupportTests methodsFor:'tests - indent-on-paste'!

test_indent_on_paste_01a

    UserPreferences current smallSenseSmalltalkIndentOnPasteEnabled: true.
    codeView contents:'test
    Debug ifTrue:[ 

    ].
    self halt.'.

    codeView selectFromLine: 5 col: 5 toLine: 5 col: 14.

    codeViewInteractor type: #Cut.
    codeViewInteractor type: #(CursorUp CursorUp).
    codeViewInteractor type: #Paste.

    self assert: (codeView list at: 3) = '        self halt.'.

    "Created: / 23-07-2014 / 09:46:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-08-2014 / 14:26:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_indent_on_paste_01b

    UserPreferences current smallSenseSmalltalkIndentOnPasteEnabled: true.
    codeView contents:'test
    Debug ifTrue:[ 

    ].
    self halt.'.

    codeView selectFromLine:5 col:1 toLine:6 col:0.

    codeViewInteractor type: #Cut.
    codeViewInteractor type: #(CursorUp CursorUp).
    codeViewInteractor type: #Paste.

    self assert: (codeView list at: 3) = '        self halt.'.

    "Created: / 23-07-2014 / 09:47:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-08-2014 / 14:26:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_indent_on_paste_02a

    UserPreferences current smallSenseSmalltalkIndentOnPasteEnabled: true.
    codeView contents:'test
    Debug ifTrue:[ 

    ].
    param isNil ifTrue:[
        self halt.
    ]'.

    codeView selectFromLine: 5 col: 5 toLine: 7 col: 5.

    codeViewInteractor type: #Cut.
    codeViewInteractor type: #(CursorUp CursorUp).
    codeViewInteractor type: #Paste.

    self assert: (codeView list at: 3) = '        param isNil ifTrue:['.
    self assert: (codeView list at: 4) = '            self halt.'.
    self assert: (codeView list at: 5) = '        ]'.

    "Created: / 23-07-2014 / 10:20:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-08-2014 / 14:26:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_indent_on_paste_02b

    UserPreferences current smallSenseSmalltalkIndentOnPasteEnabled: true.
    codeView contents:'test
    Debug ifTrue:[ 

    ].
    param isNil ifTrue:[
        self halt.
    ]'.

    codeView selectFromLine: 5 col: 1 toLine: 8 col: 0.

    codeViewInteractor type: #Cut.
    codeViewInteractor type: #(CursorUp CursorUp).
    codeViewInteractor type: #Paste.

    self assert: (codeView list at: 3) = '        param isNil ifTrue:['.
    self assert: (codeView list at: 4) = '            self halt.'.
    self assert: (codeView list at: 5) = '        ]'.

    "Created: / 23-07-2014 / 10:20:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-08-2014 / 14:26:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_indent_on_paste_03a

    UserPreferences current smallSenseSmalltalkIndentOnPasteEnabled: true.
    codeView contents:'test
    Debug ifTrue:[ 

    ].
    param isNil ifTrue:[
        self halt.
    ]'.

    codeView selectFromLine: 5 col: 5 toLine: 6 col: 18.

    codeViewInteractor type: #Cut.
    codeViewInteractor type: #(CursorUp CursorUp).
    codeViewInteractor type: #Paste.

    self assert: (codeView list at: 3) = '        param isNil ifTrue:['.
    self assert: (codeView list at: 4) = '            self halt.'.

    "Created: / 23-07-2014 / 23:28:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-08-2014 / 14:26:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_indent_on_paste_03b

    UserPreferences current smallSenseSmalltalkIndentOnPasteEnabled: true.
    codeView contents:'test
    Debug ifTrue:[ 

    ].
    param isNil ifTrue:[
        self halt.
    ]'.

    codeView selectFromLine: 5 col: 1 toLine: 7 col: 0.


    codeViewInteractor type: #Cut.
    codeViewInteractor type: #(CursorUp CursorUp).
    codeViewInteractor type: #Paste.

    self assert: (codeView list at: 3) = '        param isNil ifTrue:['.
    self assert: (codeView list at: 4) = '            self halt.'.

    "Created: / 23-07-2014 / 23:28:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-08-2014 / 14:26:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_indent_on_paste_04a

    UserPreferences current smallSenseSmalltalkIndentOnPasteEnabled: true.
    codeView contents:'test
    Debug ifTrue:[ 
        Transcript showCR:''XXX''.
    ].
    self halt.'.

    codeView selectFromLine: 5 col: 5 toLine: 5 col: 14.

    codeViewInteractor type: #Cut.
    codeViewInteractor type: #(CursorUp CursorUp).
    codeViewInteractor type: #Paste.

    self assert: (codeView list at: 3) = '    self halt.    Transcript showCR:''XXX''.'.

    "Created: / 24-07-2014 / 10:18:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-08-2014 / 14:26:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_indent_on_paste_04b

    UserPreferences current smallSenseSmalltalkIndentOnPasteEnabled: true.
    codeView contents:'test
    Debug ifTrue:[ 
        Transcript showCR:''XXX''.
    ].
    self halt.'.

    codeView selectFromLine: 5 col: 5 toLine: 6 col: 0.

    codeViewInteractor type: #Cut.
    codeViewInteractor type: #(CursorUp CursorUp).
    codeViewInteractor type: #Paste.

    self assert: (codeView list at: 3) = '    self halt.'.
    self assert: (codeView list at: 4) = '    Transcript showCR:''XXX''.'.

    "Created: / 24-07-2014 / 10:21:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-08-2014 / 14:26:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_indent_on_paste_04c

    UserPreferences current smallSenseSmalltalkIndentOnPasteEnabled: true.
    codeView contents:'test
    Debug ifTrue:[ 
        Transcript showCR:''XXX''.
    ].
    self halt.'.

    codeView selectFromLine: 5 col: 5 toLine: 6 col: 0.

    codeViewInteractor type: #Cut.
    codeViewInteractor type: #(CursorUp CursorUp CursorRight CursorRight CursorRight CursorRight).
    codeViewInteractor type: #Paste.

    self assert: (codeView list at: 3) = '        self halt.'.
    self assert: (codeView list at: 4) = 'Transcript showCR:''XXX''.'.

    "Created: / 24-07-2014 / 10:22:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-08-2014 / 14:26:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

