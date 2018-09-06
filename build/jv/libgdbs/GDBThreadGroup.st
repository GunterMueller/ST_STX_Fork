"{ Encoding: utf8 }"

"
jv:libgdbs - GNU Debugger Interface Library
Copyright (C) 2015-now Jan Vrany

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
"{ Package: 'jv:libgdbs' }"

"{ NameSpace: Smalltalk }"

GDBDebuggerObject subclass:#GDBThreadGroup
	instanceVariableNames:'id type executable running pid exit_code threads'
	classVariableNames:'ExecutableSentinel'
	poolDictionaries:'GDBCommandStatus'
	category:'GDB-Core'
!

!GDBThreadGroup class methodsFor:'documentation'!

copyright
"
jv:libgdbs - GNU Debugger Interface Library
Copyright (C) 2015-now Jan Vrany

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

!GDBThreadGroup class methodsFor:'initialization'!

initialize
    "Invoked at system start or when the class is dynamically loaded."

    ExecutableSentinel := Object new.

    "Modified: / 07-06-2018 / 10:05:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBThreadGroup class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
!

newWithDebugger: debugger id: aString
    ^ self new setDebugger: debugger; setId: aString; yourself

    "Created: / 07-09-2014 / 21:18:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBThreadGroup class methodsFor:'accessing - GDB value descriptors'!

description
    ^ (super description)
        define:#id as:String;
        define:#pid as:Integer;
        yourself.

    "
    self description
    "

    "Created: / 06-09-2014 / 02:21:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 01-10-2014 / 01:29:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

descriptionType
    ^ Magritte::MASingleOptionDescription new
        optionsAndLabels: (Array with: 
            GDBThreadGroupTypeProcess -> 'process'  
        );
        accessor: (GDBMAPropertyAccessor forPropertyNamed: 'type');
        label: 'type';
        comment: 'The type of the thread group. At present, only ‘process’ is a valid type.';
        yourself.

    "Created: / 01-10-2014 / 01:29:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-11-2017 / 20:08:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBThreadGroup methodsFor:'accessing'!

executable
    "Return name path of the executable (if known) or nil (if unknown)"

    (executable isNil and:[ pid notNil and:[self isStopped or:[debugger hasFeature:'async']]]) ifTrue:[
        | result tg |

        result := debugger send: GDBMI_list_thread_groups new.
        result status ~~ CommandStatusDone ifTrue:[ 
            self error: 'Failed to send command.'
        ].
        tg := (result propertyAt: 'groups') detect: [: each | each id = id ].
        "/ In some cases the executable is not known - it may not exist (such as
        "/ when debugging bare-metal code) or the target does not report it
        "/ (may happen, for example wine's winedbg GDB proxy does not report
        "/ executable names).
        "/ 
        "/ In this case, we store a sentinel object in `executable` instvar
        "/ to prevent repeated queries which are bound to fail (see the nil-check
        "/ above.
        executable := tg executableOrNil ? ExecutableSentinel.
    ].
    ^ executable == ExecutableSentinel ifTrue:[ nil ] ifFalse:[ executable ]

    "Created: / 06-06-2017 / 00:04:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-03-2018 / 21:44:53 / jv"
    "Modified (comment): / 07-06-2018 / 10:09:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

executableOrNil
    ^ executable

    "Created: / 06-06-2018 / 15:43:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

exitCode
    ^ exit_code

    "Created: / 07-09-2014 / 12:34:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

id
    ^ id
!

pid
    ^ pid
!

threadWithId: tid
    ^ threads ? #() detect:[:e | e isDead not and:[ e id = tid ] ] ifNone:[
        self error: ('No thread with id ''%1'' found!!' bindWith: tid)        
    ].

    "Created: / 07-09-2014 / 21:37:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-09-2014 / 01:23:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

threads
    threads isNil ifTrue:[ 
        threads := List new.
    ]. 
    ^ threads

    "Modified: / 06-09-2014 / 02:23:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 07-09-2014 / 21:42:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

type
    ^ type
! !

!GDBThreadGroup methodsFor:'event handling'!

onThreadCreatedEvent:aGDBThreadCreatedEvent 
    | thread |

    threads isNil ifTrue:[
        threads := List new.
    ].
    thread := GDBThread 
            newWithDebugger:debugger
            id:aGDBThreadCreatedEvent threadId
            group:self.
    threads add:thread.
    aGDBThreadCreatedEvent setThread:thread.

    "Created: / 07-09-2014 / 21:25:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

onThreadExitedEvent:aGDBThreadExitedEvent 
    | thread |

    thread := self threadWithId:aGDBThreadExitedEvent threadId.
    threads remove: thread.
    thread setStatus: GDBThreadStateTerminated theOneAndOnlyInstance.
    aGDBThreadExitedEvent setThread:thread.

    "Created: / 07-09-2014 / 21:25:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-07-2017 / 13:42:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-01-2018 / 09:44:09 / jv"
!

onThreadSelectedEvent: aGDBThreadSelectedEvent
    | thread |

    thread := self threadWithId:aGDBThreadSelectedEvent threadId.
    aGDBThreadSelectedEvent 
        setThread: thread;
        setFrame: (thread stack at: (aGDBThreadSelectedEvent frame level + 1))

    "Created: / 29-07-2018 / 22:21:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBThreadGroup methodsFor:'initialization'!

initialize
    "Invoked when a new instance is created."

    running := false.

    "Modified: / 06-06-2017 / 00:25:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setExitCode: anInteger
    exit_code := anInteger.
    running := false.
    threads removeAll.

    "Created: / 06-09-2014 / 02:33:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-06-2017 / 00:24:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setId: aString
    id := aString.

    "Created: / 06-09-2014 / 02:32:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setPid: anInteger
    pid := anInteger.
    exit_code := nil.
    executable := nil.
    running := true.

    "Created: / 06-09-2014 / 02:32:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-06-2017 / 00:24:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBThreadGroup methodsFor:'printing & storing'!

printOn:aStream
    "append a printed representation if the receiver to the argument, aStream"

    super printOn: aStream.
    aStream nextPutAll:'(id '.
    id printOn:aStream.
    aStream nextPutAll:', pid '.
    pid printOn:aStream.
    aStream nextPutAll:')'.

    "Modified: / 02-03-2015 / 07:10:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBThreadGroup methodsFor:'private'!

threadAdd: aGDBThread
    self threads add: aGDBThread

    "Created: / 06-09-2014 / 02:23:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

threadRemove: aGDBThread
    self threads remove: aGDBThread

    "Created: / 06-09-2014 / 02:23:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBThreadGroup methodsFor:'testing'!

isDead
    "Return true if program finished, either normally or abruptly (usng `kill` command).
     To tell whether is has finished normally or it has been terminated see
     #isFinished and / or #isTerminated"

    ^ self isRunning not and:[ pid notNil ]

    "Created: / 06-09-2014 / 02:38:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-06-2017 / 09:22:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isFinished
    "Return true if program finished its execution normally (as opposed to be
     terminated by the debugger), false otherwise. 

     @see also #isTerminated
     @see also #isDead
    "

    ^ self isDead  and:[ exit_code notNil ]

    "Created: / 06-06-2017 / 09:23:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isRunning
    "Return true, if program is currently running, false otherwise.
     Note, that program is running even of it's stopped byt the debugger.
     See #isStopped"

    ^ running

    "Created: / 06-09-2014 / 02:38:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-06-2017 / 00:25:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isStopped
    ^ threads notEmptyOrNil and:[ threads anySatisfy: [:t | t isStopped ] ].

    "Created: / 30-09-2014 / 00:49:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isTerminated
    "Return true if program has been terminated (as opposed to finishing normally),
     false otherwise.

     @see also #isFinished
     @see also #isDead
    "

    ^ self isDead and:[ exit_code isNil ]

    "Created: / 06-06-2017 / 09:26:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isValid
    ^ debugger isConnected and:[ self isDead not ]

    "Created: / 04-02-2018 / 21:31:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBThreadGroup class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


GDBThreadGroup initialize!
