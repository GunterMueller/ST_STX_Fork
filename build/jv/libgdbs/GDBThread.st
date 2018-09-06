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

GDBDebuggerObject subclass:#GDBThread
	instanceVariableNames:'id group status info stack'
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core'
!

!GDBThread class methodsFor:'documentation'!

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

!GDBThread class methodsFor:'instance creation'!

newWithDebugger: debugger id: id group: group
    ^ self new
        setDebugger: debugger;
        setId: id;
        setGroup: group;
        setStatus: GDBThreadStateRunning theOneAndOnlyInstance;
        yourself.

    "Created: / 07-09-2014 / 21:33:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-01-2018 / 22:33:26 / jv"
! !

!GDBThread class methodsFor:'accessing - GDB value descriptors'!

description
    ^ (super description)
        define:#id as:Integer;
        yourself

    "Created: / 06-09-2014 / 02:21:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBThread methodsFor:'accessing'!

group
    ^ group
!

id
    ^ id

    "Created: / 07-09-2014 / 22:41:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

name
    ^ self targetId

    "Created: / 10-03-2015 / 00:32:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

stack
    self ensureIsStopped.
    stack isNil ifTrue:[
        stack := GDBTransientDataHolder debugger: debugger factory:[ :old | 
            [
                | result depth new oldFrameIndex oldFrame newFrameIndex newFrame |

                result := debugger send: (GDBMI_stack_info_depth new arguments: (Array with: '--thread' with: id with: 100)).
                depth := result propertyAt: #depth.
                result := debugger send: (GDBMI_stack_list_frames new arguments: (Array with:  '--thread' with: id with: 0 with: depth - 1 )).
                new := result propertyAt: #stack.

                "/ Now, walk from the bottom of the stack (the least recent frame) and
                "/ ipdate `new` array with frames from `old` array to preserve the
                "/ identity.
                newFrameIndex := new size.
                oldFrameIndex := old size.
                [ newFrameIndex > 0 and:[ oldFrameIndex > 0 ] ] whileTrue:[ 
                    newFrame := new at: newFrameIndex.
                    oldFrame := old at: oldFrameIndex.
                    "/ If frame addrs matches, both frames really represent the same thing so
                    "/ just replace the 'new' frame with the 'old'.
                    newFrame addr = oldFrame addr ifTrue:[ 
                        "/ OK, the two frames are really the same thing
                        oldFrame setLevel: newFrame level. "/ Update level
                        new at: newFrameIndex put: (old at: oldFrameIndex).
                        newFrameIndex := newFrameIndex - 1.
                        oldFrameIndex := oldFrameIndex - 1.
                    ] ifFalse:[ 
                        "/ No, frame pc differs. This is the first time they differ so
                        "/ it could be the same frame just on different PC (since PC of
                        "/ caller did not change). Subsequent frames could also be "same"
                        "/ if they're inlined into caller - in this case, the PC (#addr) of
                        "/ the caller frame and inlined callee are the same.
                        "/ 
                        "/ So, we update subsequent frames as long as 
                        "/  a) function names are the same AND
                        "/  b) PC is the same as PC of its caller
                        "/
                        "/ Complicated, isn't it?
                        | oldAddr newAddr |
                        oldAddr := oldFrame addr.
                        newAddr := newFrame addr.
                        [ newFrameIndex > 0 and:[ oldFrameIndex > 0 ] ] whileTrue:[
                            newFrame := new at: newFrameIndex.
                            oldFrame := old at: oldFrameIndex.    
                            ("a)"oldFrame func = newFrame func and: ["b)"oldFrame addr = oldAddr and:[newFrame addr = newAddr]]) ifTrue:[ 
                                "/ Update the frame...
                                oldFrame setAddr: newFrame addr.
                                oldFrame setLine: newFrame line.
                                oldFrame setLevel: newFrame level.
                                new at: newFrameIndex put: (old at: oldFrameIndex).
                                newFrameIndex := newFrameIndex - 1.
                                oldFrameIndex := oldFrameIndex - 1.    
                            ] ifFalse:[
                                "/ Terminate the loop, see the condition above.
                                oldFrameIndex := 0. 
                            ].
                        ]
                    ].
                ].
                "/ For the remaining really new frames, set the debugger
                "/ and the thread.
                [ newFrameIndex > 0 ] whileTrue:[ 
                    newFrame := new at: newFrameIndex.
                    newFrame setDebugger: debugger.
                    newFrame setThread: self.
                    newFrameIndex := newFrameIndex - 1.
                ].
                new
            ] on: GDBError do:[ :ex |
                self isRunning ifFalse:[
                    ex pass.
                ].
                old.
            ].
        ].
    ].
    ^ stack value

    "Created: / 09-09-2014 / 00:02:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-09-2018 / 00:11:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

status
    status isUnknown ifTrue:[ 
        status := self info state
    ].
    ^ status

    "Modified: / 12-07-2017 / 13:36:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

targetId
    ^ self info targetId

    "Created: / 10-03-2015 / 00:32:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBThread methodsFor:'accessing-private'!

info
    info isNil ifTrue:[
        info := GDBTransientDataHolder debugger: debugger factory:[ 
            | result infos |

            result := debugger send: (GDBMI_thread_info new arguments: (Array with: id)).
            infos := result propertyAt: #threads.
            self assert: (infos isEmptyOrNil or:[ infos size == 1 and:[ infos first id = id ] ]).
            infos isEmptyOrNil 
                ifTrue:[ GDBThreadInfo new setId: id state: GDBThreadStateTerminated theOneAndOnlyInstance ] 
                ifFalse:[ infos first ]
        ].
    ].
    ^ info value

    "Created: / 08-03-2015 / 09:07:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-11-2017 / 20:21:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBThread methodsFor:'displaying'!

displayString
    ^ '%1 [%2]' bindWith: self name with: self status

    "Created: / 10-03-2015 / 00:32:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBThread methodsFor:'event handling'!

onRunningEvent: aGDBRunningEvent
    self assert: (aGDBRunningEvent threads includesIdentical: self).
    status := GDBThreadStateRunning theOneAndOnlyInstance.

    "Created: / 12-07-2017 / 13:50:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

onStoppedEvent: aGDBStoppedEvent
    self assert: (aGDBStoppedEvent threads includesIdentical: self).
    status := GDBThreadStateStopped theOneAndOnlyInstance.

    "Created: / 12-07-2017 / 13:50:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBThread methodsFor:'initialization'!

setGroup: aGDBThreadGroup
    self assert: group isNil.
    group := aGDBThreadGroup.

    "Created: / 07-09-2014 / 21:32:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setId: tid
    self assert: id isNil.
    id := tid.

    "Created: / 07-09-2014 / 21:31:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-03-2015 / 09:08:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setStatus: aGDBThreadState
    status := aGDBThreadState

    "Created: / 12-07-2017 / 13:43:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setTerminated

    "Created: / 07-09-2014 / 21:37:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-03-2015 / 09:08:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBThread methodsFor:'printing & storing'!

printOn:aStream
    "append a printed representation if the receiver to the argument, aStream"

    aStream nextPutAll:'thread  '.
    id printOn:aStream.
"/    aStream nextPutAll:'in group '.
"/    group id printOn:aStream.
    aStream nextPutAll:' ['.
    self status printOn:aStream.
    aStream nextPutAll:']'.

    "Modified: / 08-03-2015 / 09:07:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBThread methodsFor:'private'!

ensureIsStopped
    self isStopped ifFalse:[
        (GDBInvalidObjectError newException)
            parameter:self;
            messageText:'Invalid state (thread is running or already dead)';
            raise.
    ].

    "Created: / 09-09-2014 / 00:04:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-09-2014 / 23:51:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBThread methodsFor:'testing'!

isDead
    ^ self isTerminated

    "Created: / 22-09-2014 / 00:54:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-03-2015 / 12:35:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-01-2018 / 22:34:04 / jv"
!

isRunning
    ^ self status isRunning

    "Created: / 07-09-2014 / 23:23:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-03-2015 / 09:08:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isStopped
    ^ self status isStopped

    "Created: / 07-09-2014 / 23:23:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-03-2015 / 09:08:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isTerminated
    ^ self status isTerminated

    "Created: / 07-09-2014 / 23:23:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-03-2015 / 09:08:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isValid
    ^ group isValid and:[ self isDead not ]

    "Created: / 04-02-2018 / 21:31:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBThread class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

