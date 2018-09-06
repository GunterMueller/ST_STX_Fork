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

GDBExecutionEvent subclass:#GDBStoppedEvent
	instanceVariableNames:'frame reason stopped_threads'
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core-Events'
!

!GDBStoppedEvent class methodsFor:'documentation'!

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

!GDBStoppedEvent class methodsFor:'accessing - GDB value descriptors'!

description
    ^ (super description)
        define:#'thread-id' as:Integer;
        define:#'stopped-threads' as:String;
        define:#'frame' as: GDBFrame;
        define:#'reason' as: String;
        yourself

    "Created: / 08-09-2014 / 22:13:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 31-08-2018 / 14:15:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBStoppedEvent methodsFor:'accessing'!

frame
    ^ frame
!

reason
    "Return stop reason as reported by the GDB.

     See GDBStopReasons for list of common reasons. Note, that
     that list os not exhaustive."

    ^ reason

    "Modified (comment): / 31-08-2018 / 23:20:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

stoppedThread
    thread_id isNil ifTrue:[ ^ nil ].
    ^ threads detect:[:thread | thread id = thread_id ]

    "Created: / 22-09-2014 / 23:24:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-02-2015 / 12:36:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-01-2018 / 11:52:17 / jv"
!

stoppedThreadId
    ^ thread_id asInteger

    "Created: / 08-09-2014 / 22:15:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-09-2014 / 23:28:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

stoppedThreadIds
    ^ stopped_threads ? 'all'

    "Created: / 08-09-2014 / 22:15:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-01-2018 / 11:50:38 / jv"
!

type
	^  'stopped'
! !

!GDBStoppedEvent methodsFor:'initialization'!

reason: aString
    GDBStopReasons classVarNames do:[:name | 
        | value |

        value := GDBStopReasons classVarNamed: name.
        aString = value ifTrue:[ 
            reason := value.
            ^ self.
        ].
    ].
    reason := aString

    "Created: / 31-08-2018 / 23:23:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBStoppedEvent class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

