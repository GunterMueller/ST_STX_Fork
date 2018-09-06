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

GDBNotificationEvent subclass:#GDBThreadSelectedEvent
	instanceVariableNames:'thread frame id'
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core-Events'
!

!GDBThreadSelectedEvent class methodsFor:'documentation'!

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

!GDBThreadSelectedEvent class methodsFor:'accessing - GDB value descriptors'!

description
    ^ (super description)
        define:#id as:Integer;
        define:#'frame' as:GDBFrame;
        yourself

    "Created: / 06-09-2014 / 02:08:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 29-07-2018 / 22:06:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBThreadSelectedEvent methodsFor:'accessing'!

frame
    ^ frame

    "Created: / 29-07-2018 / 22:12:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

thread
    ^ thread

    "Created: / 29-07-2018 / 22:11:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

threadGroup
    ^ thread group

    "Created: / 30-07-2018 / 07:34:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

threadId
    ^ id

    "Created: / 29-07-2018 / 22:11:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

type
	^  'thread-selected'
! !

!GDBThreadSelectedEvent methodsFor:'initialization'!

setFrame: aGDBFrame
    frame := aGDBFrame

    "Created: / 29-07-2018 / 22:12:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 30-07-2018 / 07:08:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setThread: aGDBThread
    thread := aGDBThread

    "Created: / 29-07-2018 / 22:12:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBThreadSelectedEvent class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

