"
jv:vdb - Visual / VM Debugger
Copyright (C) 2015-now Jan Vrany

This software is licensed under 'Creative Commons Attribution-NonCommercial 4.0 International License'

You may find a full license text in LICENSE.txt or at http://creativecommons.org/licenses/by-nc/4.0/
"
"{ Package: 'jv:vdb' }"

"{ NameSpace: Smalltalk }"

VDBAbstractUnixConsoleApplication subclass:#VDBUnixDebuggerConsoleApplication
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'VDB-UI-Console-Unix'
!

!VDBUnixDebuggerConsoleApplication class methodsFor:'documentation'!

copyright
"
jv:vdb - Visual / VM Debugger
Copyright (C) 2015-now Jan Vrany

This software is licensed under 'Creative Commons Attribution-NonCommercial 4.0 International License'

You may find a full license text in LICENSE.txt or at http://creativecommons.org/licenses/by-nc/4.0/
"
! !

!VDBUnixDebuggerConsoleApplication class methodsFor:'accessing'!

windowTitle
    ^ 'Debugger Console'

    "Created: / 08-01-2018 / 18:59:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBUnixDebuggerConsoleApplication class methodsFor:'startup-web applications'!

initialPageSpec
    "this is only required for web-applications"

    ^ self shouldImplement
!

pageSpecs
    "this is only required for web-applications"

    ^ self shouldImplement
! !

!VDBUnixDebuggerConsoleApplication methodsFor:'accessing'!

consoleInput
    "superclass VDBAbstractConsoleApplication says that I am responsible to implement this method"

    ^ debugger consoleInput

    "Modified: / 01-06-2017 / 09:45:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

consoleOutput
    "superclass VDBAbstractConsoleApplication says that I am responsible to implement this method"

    ^ debugger consoleOutput

    "Modified: / 01-06-2017 / 09:46:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBUnixDebuggerConsoleApplication class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

