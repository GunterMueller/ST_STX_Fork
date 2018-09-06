"
jv:vdb - Visual / VM Debugger
Copyright (C) 2015-now Jan Vrany

This software is licensed under 'Creative Commons Attribution-NonCommercial 4.0 International License'

You may find a full license text in LICENSE.txt or at http://creativecommons.org/licenses/by-nc/4.0/
"
"{ Package: 'jv:vdb' }"

"{ NameSpace: Smalltalk }"

Object subclass:#RR
	instanceVariableNames:'port pty pid announcer'
	classVariableNames:'RRExecutable RRPort'
	poolDictionaries:''
	category:'RR'
!

!RR class methodsFor:'documentation'!

copyright
"
jv:vdb - Visual / VM Debugger
Copyright (C) 2015-now Jan Vrany

This software is licensed under 'Creative Commons Attribution-NonCommercial 4.0 International License'

You may find a full license text in LICENSE.txt or at http://creativecommons.org/licenses/by-nc/4.0/
"
!

documentation
"
    Class `RR` represents a Smalltalk inteface to
    Mozilla rr

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]
        https://rr-project.org/

"
! !

!RR class methodsFor:'initialization'!

initialize
    "Invoked at system start or when the class is dynamically loaded."

    "/ please change as required (and remove this comment)

    RRExecutable := nil. "/ nil means default
    RRPort := 9876

    "Modified: / 27-07-2018 / 07:40:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RR class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
!

replay
    ^ self new

    "Created: / 26-07-2018 / 16:53:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RR class methodsFor:'accessing'!

executable
    ^ RRExecutable ? (OperatingSystem pathOfCommand:'rr')

    "Created: / 26-07-2018 / 21:55:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

executable: aString
    RRExecutable := aString

    "Created: / 26-07-2018 / 21:54:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RR class methodsFor:'queries'!

available
    | exe |

    exe := self executable.
    ^ exe notNil and:[ OperatingSystem canExecuteCommand: exe ]

    "
    RR available
    "

    "Created: / 26-07-2018 / 21:56:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RR methodsFor:'accessing'!

announcer
    ^ announcer
!

consoleInput
    ^ pty master

    "Created: / 26-07-2018 / 16:56:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

consoleOutput
    ^ pty master

    "Created: / 26-07-2018 / 16:56:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

port
    ^ port

    "Created: / 26-07-2018 / 22:11:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RR methodsFor:'initialization'!

initialize
    "Invoked when a new instance is created."

    announcer := Announcer new.

    "Modified: / 31-07-2018 / 08:29:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RR methodsFor:'private'!

exited:status 
    pid := nil.
    announcer announce:((RRExitEvent new)
                setRR:self;
                setStatus:status).
    pty release.
    pty := nil.
    port := nil

    "Created: / 26-07-2018 / 17:03:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 31-07-2018 / 08:34:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RR methodsFor:'queries'!

running
    "Return true, if RR replay server is running"

    ^ pid notNil

    "Created: / 27-07-2018 / 07:42:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RR methodsFor:'start & stop'!

start
    | args |

    pty := GDBPTY new.
    port := RRPort.
    RRPort := RRPort + 1.
    args := Array 
            with:(OperatingSystem pathOfCommand:'rr')
            with:'replay'
            with:'-s'
            with:port printString.
    Processor 
        monitor:[
            pid := OperatingSystem 
                    exec:args first
                    withArguments:args
                    environment:OperatingSystem getEnvironment
                    fileDescriptors:{
                            pty slave fileDescriptor.
                            pty slave fileDescriptor.
                            pty slave fileDescriptor
                        }
                    fork:true
                    newPgrp:false
                    inDirectory:Filename currentDirectory
                    showWindow:false.
            pid.
        ]
        action:[:stat | self exited:stat ].
    pid isNil ifTrue:[
        pty close.
        self error:'Failed to launch gdb'.
    ].
    announcer announce:(RRStartEvent new setRR:self)
!

stop
    OperatingSystem sendSignal:(OperatingSystem sigTERM) to:pid toGroup:false toAll:false.

    "Created: / 26-07-2018 / 21:23:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !


RR initialize!
