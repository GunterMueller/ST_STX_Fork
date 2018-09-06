"
jv:vdb - Visual / VM Debugger
Copyright (C) 2015-now Jan Vrany

This software is licensed under 'Creative Commons Attribution-NonCommercial 4.0 International License'

You may find a full license text in LICENSE.txt or at http://creativecommons.org/licenses/by-nc/4.0/
"
"{ Package: 'jv:vdb' }"

"{ NameSpace: Smalltalk }"

VDBAbstractUnixConsoleApplication subclass:#VDBUnixReplayServerConsoleApplication
	instanceVariableNames:'rrHolder rr'
	classVariableNames:''
	poolDictionaries:''
	category:'VDB-UI-Console-Unix'
!

!VDBUnixReplayServerConsoleApplication class methodsFor:'documentation'!

copyright
"
jv:vdb - Visual / VM Debugger
Copyright (C) 2015-now Jan Vrany

This software is licensed under 'Creative Commons Attribution-NonCommercial 4.0 International License'

You may find a full license text in LICENSE.txt or at http://creativecommons.org/licenses/by-nc/4.0/
"
! !

!VDBUnixReplayServerConsoleApplication class methodsFor:'accessing'!

windowTitle
    ^ 'Replay Console'

    "Created: / 26-07-2018 / 17:12:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBUnixReplayServerConsoleApplication methodsFor:'accessing'!

consoleInput
    "superclass VDBAbstractConsoleApplication says that I am responsible to implement this method"

    ^ rr consoleInput

    "Modified: / 26-07-2018 / 17:14:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

consoleOutput
    "superclass VDBAbstractConsoleApplication says that I am responsible to implement this method"

    ^ rr consoleOutput

    "Modified: / 26-07-2018 / 17:14:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBUnixReplayServerConsoleApplication methodsFor:'acessing'!

rr
    ^ rr

    "Created: / 26-07-2018 / 17:17:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

rr: aRR
    self rrHolder value: aRR

    "Created: / 26-07-2018 / 17:17:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBUnixReplayServerConsoleApplication methodsFor:'aspects'!

consoleView
    consoleView isNil ifTrue:[ 
        consoleView :=VT100TerminalView new.
        consoleView foregroundColor: Color white
                    backgroundColor: Color black;
                    cursorForegroundColor: Color white
                          backgroundColor: Color white.
        rr notNil ifTrue:[ 
            consoleView inStream: self consoleInput.
            consoleView outStream: self consoleOutput.
            consoleView startReaderProcessWhenVisible.
        ].
    ].
    ^ consoleView

    "Created: / 26-07-2018 / 20:27:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

rrHolder
    "return/create the 'debuggerHolder' value holder (automatically generated)"

    rrHolder isNil ifTrue:[
        rrHolder := ValueHolder new.
        rrHolder addDependent:self.
    ].
    ^ rrHolder

    "Created: / 26-07-2018 / 17:17:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

rrHolder:aValueModel
    "set the 'debuggerHolder' value holder (automatically generated)"

    |oldValue newValue|

    rrHolder notNil ifTrue:[
        oldValue := rrHolder value.
        rrHolder removeDependent:self.
    ].
    rrHolder := aValueModel.
    rrHolder notNil ifTrue:[
        rrHolder addDependent:self.
    ].
    newValue := rrHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:rrHolder.
    ].

    "Created: / 26-07-2018 / 17:18:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBUnixReplayServerConsoleApplication methodsFor:'change & update'!

update:something with:aParameter from:changedObject
    "Invoked when an object that I depend upon sends a change notification."

    changedObject == rrHolder ifTrue:[
        rrHolder value == rr ifFalse:[
            rr notNil ifTrue:[ 
                self unsubscribe.
            ].
            rr := rrHolder value.
            rr notNil ifTrue:[ 
                self subscribe.
            ].
        ].
        ^ self.
    ].
    super update:something with:aParameter from:changedObject

    "Created: / 26-07-2018 / 17:19:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBUnixReplayServerConsoleApplication methodsFor:'event handling'!

onRRExitEvent: anRRTerminaedEvent
    consoleView notNil ifTrue:[
        | status info |
        status := anRRTerminaedEvent status.
        consoleView cr.
        (status success or:[status status == #signal and:[status code == UnixOperatingSystem sigTERM]]) ifTrue:[ 
            info := resources string: '>> replay server terminated'
        ] ifFalse:[status isError ifTrue:[
            info := resources string: '>> replay server terminated (with status %1)' with: anRRTerminaedEvent status code.
        ] ifFalse:[status status == #signal ifTrue:[ 
            info := resources string: '>> replay server crashed (signal %1)' with: anRRTerminaedEvent status code.    
        ]]].
        consoleView nextPutLine: (info asText allBold colorizeAllWith:Color red).
    ].

    "Created: / 31-07-2018 / 08:52:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

onRRStartEvent: anRRStartedEvent

    "Created: / 31-07-2018 / 08:52:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBUnixReplayServerConsoleApplication methodsFor:'initialization & release'!

subscribe
    "Register for debugger events. To be overrided by subclasses"
    
    super subscribe.
    rr notNil ifTrue:[
        (rr announcer)
            when:RRStartEvent
                send:#onRRStartEvent:
                to:self;
            when:RRExitEvent
                send:#onRRExitEvent:
                to:self.
        consoleView notNil ifTrue:[
            consoleView stopReaderProcess.
            consoleView inStream:self consoleInput.
            consoleView outStream:self consoleOutput.
            consoleView startReaderProcessWhenVisible.
        ].
    ].

    "Created: / 26-07-2018 / 17:19:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 31-07-2018 / 08:53:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

unsubscribe
    "Unsubscribe myself fo debugger events"

    super unsubscribe.
    rr notNil ifTrue:[ 
        rr announcer unsubscribe: self. 
    ].
    consoleView notNil ifTrue:[ 
        consoleView stopReaderProcess.
        consoleView inStream: nil.
        consoleView outStream: nil.
    ].

    "Created: / 26-07-2018 / 17:20:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 31-07-2018 / 08:38:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBUnixReplayServerConsoleApplication methodsFor:'startup & release'!

closeRequest
    (rr notNil and:[ rr running ]) ifTrue:[ 
        (Dialog confirm: (resources string: 'Replay Server is running. Stop server and close?')) ifFalse:[ 
            ^ self.
        ].
        rr stop.
    ].
    ^ super closeRequest.

    "Created: / 27-07-2018 / 07:49:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

