"
jv:vdb - Visual / VM Debugger
Copyright (C) 2015-now Jan Vrany

This software is licensed under 'Creative Commons Attribution-NonCommercial 4.0 International License'

You may find a full license text in LICENSE.txt or at http://creativecommons.org/licenses/by-nc/4.0/
"
"{ Package: 'jv:vdb' }"

"{ NameSpace: Smalltalk }"

VDBAbstractUnixConsoleApplication subclass:#VDBUnixInferiorConsoleApplication
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'VDB-UI-Console-Unix'
!

!VDBUnixInferiorConsoleApplication class methodsFor:'documentation'!

copyright
"
jv:vdb - Visual / VM Debugger
Copyright (C) 2015-now Jan Vrany

This software is licensed under 'Creative Commons Attribution-NonCommercial 4.0 International License'

You may find a full license text in LICENSE.txt or at http://creativecommons.org/licenses/by-nc/4.0/
"
! !

!VDBUnixInferiorConsoleApplication class methodsFor:'accessing'!

windowTitle
    ^ 'Inferior Console'

    "Created: / 08-01-2018 / 18:59:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBUnixInferiorConsoleApplication class methodsFor:'startup-web applications'!

initialPageSpec
    "this is only required for web-applications"

    ^ self shouldImplement
!

pageSpecs
    "this is only required for web-applications"

    ^ self shouldImplement
! !

!VDBUnixInferiorConsoleApplication methodsFor:'accessing'!

consoleInput
    "superclass VDBAbstractConsoleApplication says that I am responsible to implement this method"

    ^ debugger inferiorStdout

    "Modified: / 01-06-2017 / 09:46:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

consoleOutput
    "superclass VDBAbstractConsoleApplication says that I am responsible to implement this method"

    ^ debugger inferiorStdout

    "Modified: / 01-06-2017 / 09:45:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBUnixInferiorConsoleApplication class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

