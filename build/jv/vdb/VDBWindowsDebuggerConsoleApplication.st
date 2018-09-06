"
jv:vdb - Visual / VM Debugger
Copyright (C) 2015-now Jan Vrany

This software is licensed under 'Creative Commons Attribution-NonCommercial 4.0 International License'

You may find a full license text in LICENSE.txt or at http://creativecommons.org/licenses/by-nc/4.0/
"
"{ Package: 'jv:vdb' }"

"{ NameSpace: Smalltalk }"

VDBAbstractApplication subclass:#VDBWindowsDebuggerConsoleApplication
	instanceVariableNames:'consoleView consoleInput consoleOutput consoleOutputLock
		consoleProcess consolePrompt consolePromptPrinted
		outstandingCommand outstandingCommandToken
		outstandingCommandBlocker ignoreNextLogStreamEvent completing
		completions'
	classVariableNames:''
	poolDictionaries:'GDBCommandStatus'
	category:'VDB-UI-Console-Windows'
!

!VDBWindowsDebuggerConsoleApplication class methodsFor:'documentation'!

copyright
"
jv:vdb - Visual / VM Debugger
Copyright (C) 2015-now Jan Vrany

This software is licensed under 'Creative Commons Attribution-NonCommercial 4.0 International License'

You may find a full license text in LICENSE.txt or at http://creativecommons.org/licenses/by-nc/4.0/
"
!

documentation
""
! !

!VDBWindowsDebuggerConsoleApplication class methodsFor:'accessing'!

windowTitle
    ^ 'Debugger Console'

    "Created: / 08-01-2018 / 18:59:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBWindowsDebuggerConsoleApplication class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:VDBConsoleApplication andSelector:#windowSpec
     VDBConsoleApplication new openInterface:#windowSpec
     VDBConsoleApplication open
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpec
       window: 
      (WindowSpec
         label: 'Debugger Console'
         name: 'Debugger Console'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 782 332)
       )
       component: 
      (SpecCollection
         collection: (
          (ArbitraryComponentSpec
             name: 'Console'
             layout: (LayoutFrame 0 0 0 0 0 1 0 1)
             hasBorder: false
             component: consoleView
           )
          )
        
       )
     )

    "Modified: / 09-06-2014 / 09:57:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBWindowsDebuggerConsoleApplication class methodsFor:'plugIn spec'!

aspectSelectors
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this. If it is corrupted,
     the UIPainter may not be able to read the specification."

    "Return a description of exported aspects;
     these can be connected to aspects of an embedding application
     (if this app is embedded in a subCanvas)."

    ^ #(
        #debuggerHolder
      ).

! !

!VDBWindowsDebuggerConsoleApplication methodsFor:'actions'!

postBuildConsoleView: aTextCollector
    consoleView := aTextCollector scrolledView.
    consoleView readOnly: true;       
                font: CodeView defaultFont;
                foregroundColor: Color white
                backgroundColor: Color black;
                cursorForegroundColor: Color white
                      backgroundColor: Color white.

    "Modified: / 08-01-2018 / 19:16:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBWindowsDebuggerConsoleApplication methodsFor:'aspects'!

consoleView
    consoleView isNil ifTrue:[
        consoleView := VDBWindowsDebuggerConsoleView new.
        consoleView font: self textFont;
                    foregroundColor: Color white
                    backgroundColor: Color black;
                    cursorForegroundColor: Color white
                          backgroundColor: Color white.     
        consoleView localEcho:true.
        consoleView inputTranslateCRToNL:true.
        consoleView lineEditMode:true.
        consoleView inStream:consoleInput.
        consoleView outStream:consoleOutput.
        consoleView startReaderProcessWhenVisible.
    ].
    ^ consoleView

    "Created: / 09-06-2014 / 10:11:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-04-2018 / 22:40:59 / jv"
    "Modified: / 20-08-2018 / 10:19:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBWindowsDebuggerConsoleApplication methodsFor:'event handling'!

onCommandEvent: event
    event command == outstandingCommand ifTrue:[ 
        outstandingCommandToken := event token.
        ignoreNextLogStreamEvent := true.
    ].

    "Created: / 06-06-2014 / 22:43:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-06-2014 / 12:35:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

onCommandResultEvent: event
    outstandingCommandToken notNil ifTrue:[ 
        event token == outstandingCommandToken ifTrue:[ 
            "/ Check if command ended up with an error. If so,
            "/ print the error message.
            event result status == CommandStatusError ifTrue:[ 
                self showCR: ('Error: %1 ' bindWith: (event result propertyAt: #msg)).
            ] ifFalse:[
                "/ Check if the command issues is actually a MI command,
                "/ if so, print "Done" to the console since MI command don't
                "/ provide user feedback.
                outstandingCommand isMICommand ifTrue:[ 
                    self showCR: ('Done ( %1 , see even log for result value)' bindWith: outstandingCommand value)
                ].
            ].
            outstandingCommand := outstandingCommandToken := nil. 
            outstandingCommandBlocker signalForAll.     
        ].
    ].

    "Created: / 06-06-2014 / 22:44:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-02-2015 / 13:01:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

onEventSetProcessingFinished: event
    self showPrompt.

    "Created: / 18-09-2014 / 23:11:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

onLogOutputEvent: event
    completing ifTrue:[
        self halt.
    ] ifFalse:[
        ignoreNextLogStreamEvent ifTrue:[ 
            ignoreNextLogStreamEvent := false.
        ] ifFalse:[
            self onStreamOutputEvent: event  
        ]
    ].

    "Created: / 11-06-2014 / 12:37:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-09-2016 / 01:12:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-04-2018 / 22:50:14 / jv"
!

onStreamOutputEvent: event
    completing ifTrue:[
        completions addAll: event value asStringCollection.
    ] ifFalse:[
        consolePromptPrinted ifTrue:[ self showCR:'' ].
        consolePromptPrinted := false.
        event value asStringCollection do:[:line |  
            line notEmptyOrNil ifTrue:[ 
                self showCR: line.  
            ].
        ].
    ].

    "Created: / 11-06-2014 / 12:00:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-09-2016 / 01:11:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBWindowsDebuggerConsoleApplication methodsFor:'hooks'!

commonPostOpen
    consoleProcess isNil ifTrue:[
        consoleProcess := 
            [
                [
                    | cmdLine cmd |
                    self showPrompt.
                    cmdLine := consoleInput nextLine asString.
                    consolePromptPrinted := false.
                    self showCR: cmdLine.
                    cmdLine notEmptyOrNil ifTrue:[
                        cmd := (GDBMIParser on:cmdLine) parseCommand.
                        cmd isCLICommand ifTrue:[ 
                            cmd runOnBackground: true.  
                        ].
                        outstandingCommand := cmd.
                        debugger send:cmd andWait:false. 
                        outstandingCommandBlocker wait.
                    ]
                ] loop. 
            ] newProcess.
        consoleProcess name: 'VDB Debugger Console REPL loop'.
        consoleProcess resume.
    ].

    "Created: / 10-06-2014 / 01:25:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-09-2016 / 00:42:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBWindowsDebuggerConsoleApplication methodsFor:'initialization & release'!

initialize
    super initialize.

    consoleInput := GDBInternalPipeStream new.
    consoleOutput := GDBInternalPipeStream new.
    consoleOutputLock := RecursionLock new.
    consolePrompt := '(gdb) '.
    consolePromptPrinted := false.
    outstandingCommandBlocker := Semaphore new.
    ignoreNextLogStreamEvent := false.
    completing := false.

    "Created: / 10-06-2014 / 01:23:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-09-2016 / 00:33:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-04-2018 / 23:13:27 / jv"
!

release
    super release.
    consoleProcess terminate.

    "Created: / 10-06-2014 / 01:34:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

subscribe   
    "Register for debugger events. To be overrided by subclasses"

    debugger announcer 
        when: GDBCommandEvent           send: #onCommandEvent:          to: self;
        when: GDBCommandResultEvent     send: #onCommandResultEvent:    to: self;

        when: GDBConsoleOutputEvent      send: #onStreamOutputEvent:     to: self;
        when: GDBTargetOutputEvent       send: #onStreamOutputEvent:     to: self;
        when: GDBLogOutputEvent          send: #onLogOutputEvent:        to: self;

        when: GDBEventSetProcessingFinished send: #onEventSetProcessingFinished: to: self.

    "Created: / 06-06-2014 / 21:26:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-09-2014 / 23:11:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBWindowsDebuggerConsoleApplication methodsFor:'private'!

completeLine: aString
    | result |

    (debugger inferiors allSatisfy:[:inferior | inferior isRunning]) ifTrue:[ 
        consoleView flash.
        ^ #()
    ].

    completing := true.
    completions := OrderedCollection new.
    [
        result := debugger send: 'complete ', aString.
    ] ensure:[ 
        completing := false.
    ].
    self halt.

    "Created: / 16-09-2016 / 01:09:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBWindowsDebuggerConsoleApplication methodsFor:'private - writing'!

show: aString
    consoleOutputLock critical:[ 
        consoleOutput nextPutAll: aString.
    ].

    "Created: / 11-06-2014 / 08:02:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-06-2014 / 11:53:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

showCR: aString
    consoleOutputLock critical:[ 
        consoleOutput nextPutAll: aString.
        consoleOutput nextPut: Character nl.
        consoleOutput nextPut: Character return.
    ].

    "Created: / 11-06-2014 / 08:02:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-06-2014 / 11:56:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

showPrompt
    consolePromptPrinted ifFalse:[
        self show: consolePrompt.
        consolePromptPrinted := true.
    ].

    "Created: / 18-09-2014 / 23:18:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-04-2018 / 23:01:24 / jv"
! !

!VDBWindowsDebuggerConsoleApplication class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

