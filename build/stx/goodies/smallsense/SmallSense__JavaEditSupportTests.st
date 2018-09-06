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

EditSupportTests subclass:#JavaEditSupportTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SmallSense-Tests'
!

!JavaEditSupportTests class methodsFor:'documentation'!

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

!JavaEditSupportTests methodsFor:'accessing-classes'!

editSupportClass
    "superclass SmallSense::EditSupportTests says that I am responsible to implement this method"

    ^ JavaEditSupport

    "Created: / 13-08-2014 / 15:16:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaEditSupportTests methodsFor:'tests - return'!

test_return_01a
    UserPreferences current smallSenseElectricEditSupportEnabled: true.
    codeView contents:'
public class SimpleClient {
}'.

    codeView setCursorLine: 2 col: 28.

    codeViewInteractor type: #Return.

    self assert: (codeView cursorCol = 5).  
    self assert: (codeView cursorLine = 3).
    self assert: (codeView list at: 3) isEmptyOrNil.

    "Created: / 13-08-2014 / 15:34:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_return_01b
    UserPreferences current smallSenseElectricEditSupportEnabled: true.
    codeView contents:'
public class SimpleClient {
}'.

    codeView setCursorLine: 2 col: 35.

    codeViewInteractor type: #Return.

    self assert: (codeView cursorCol = 5).  
    self assert: (codeView cursorLine = 3).

    "Created: / 13-08-2014 / 15:34:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_return_02a
    UserPreferences current smallSenseElectricEditSupportEnabled: true.
    codeView contents:'
public class SimpleClient {
    int i;
}'.

    codeView setCursorLine: 3 col: 11.

    codeViewInteractor type: #Return.

    self assert: (codeView cursorCol = 5).  
    self assert: (codeView cursorLine = 4).

    "Created: / 13-08-2014 / 15:33:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_return_02b
    UserPreferences current smallSenseElectricEditSupportEnabled: true.
    codeView contents:'
public class SimpleClient {
    int i;


}'.

    codeView setCursorLine: 4 col: 15.

    codeViewInteractor type: #Return.

    self assert: (codeView cursorCol = 5).  
    self assert: (codeView cursorLine = 5).

    "Created: / 13-08-2014 / 15:33:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_return_03b
    UserPreferences current smallSenseElectricEditSupportEnabled: true.
    codeView contents:'
public class SimpleClient {
    int i;


}'.

    codeView setCursorLine: 3 col: 9.

    codeViewInteractor type: #Return.

    self assert: (codeView cursorCol = 1).  
    self assert: (codeView cursorLine = 4).
    self assert: (codeView list at: 4) = 'i;'

    "Created: / 13-08-2014 / 20:39:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

