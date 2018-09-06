"
jv:vdb - Visual / VM Debugger
Copyright (C) 2015-now Jan Vrany

This software is licensed under 'Creative Commons Attribution-NonCommercial 4.0 International License'

You may find a full license text in LICENSE.txt or at http://creativecommons.org/licenses/by-nc/4.0/
"
"{ Package: 'jv:vdb' }"

"{ NameSpace: Smalltalk }"

TerminalView subclass:#VDBWindowsDebuggerConsoleView
	instanceVariableNames:'tabPressed completions'
	classVariableNames:''
	poolDictionaries:''
	category:'VDB-UI-Console-Windows'
!

!VDBWindowsDebuggerConsoleView class methodsFor:'documentation'!

copyright
"
jv:vdb - Visual / VM Debugger
Copyright (C) 2015-now Jan Vrany

This software is licensed under 'Creative Commons Attribution-NonCommercial 4.0 International License'

You may find a full license text in LICENSE.txt or at http://creativecommons.org/licenses/by-nc/4.0/
"
! !

!VDBWindowsDebuggerConsoleView methodsFor:'event handling'!

keyPress:aKey x:x y:y
    <resource: #keyboard (#Tab)>

    inStream isNil ifTrue:[^ self].

    "aKey == #Tab"false ifTrue:[ 
        DebugKeyboard ifTrue:[
            Transcript showCR:'----'; show:'keyPress:' ; showCR:aKey printString.
        ].
        tabPressed ifTrue:[ 
            tabPressed := false.
            ^ self doTabTab.
        ] ifFalse:[ 
            tabPressed := true.    
            ^ self doTab
        ].
    ].
    tabPressed := false.
    ^ super keyPress:aKey x:x y:y




    "
     DebugKeyboard := true
    "

    "Created: / 15-09-2016 / 23:55:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-09-2016 / 00:56:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-04-2018 / 22:57:53 / jv"
! !

!VDBWindowsDebuggerConsoleView methodsFor:'functions'!

doTab
"/    | line |
"/
"/    line := lineBuffer.
"/    lineBuffer := nil.
"/    self application completeLine: line.

    "Created: / 15-09-2016 / 23:56:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-09-2016 / 01:09:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-04-2018 / 22:58:55 / jv"
!

doTabTab
"/    self application completeShow

    "Created: / 16-09-2016 / 00:56:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-04-2018 / 22:59:02 / jv"
! !

!VDBWindowsDebuggerConsoleView methodsFor:'initialization'!

initialize
    "Invoked when a new instance is created."

    "/ please change as required (and remove this comment)
    super initialize.
    tabPressed := false.

    "Modified: / 16-09-2016 / 00:55:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBWindowsDebuggerConsoleView class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

