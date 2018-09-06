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

GDBNotificationEvent subclass:#GDBThreadEvent
	instanceVariableNames:'thread id group_id'
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core-Events'
!

!GDBThreadEvent class methodsFor:'documentation'!

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

!GDBThreadEvent class methodsFor:'accessing - GDB value descriptors'!

description
    ^ (super description)
        define:#id as:Integer;
        define:#'group-id' as:String;
        yourself

    "Created: / 06-09-2014 / 02:08:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBThreadEvent methodsFor:'accessing'!

thread
    ^ thread
!

threadGroup
    ^ thread threadGroup

    "Created: / 07-09-2014 / 18:07:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

threadGroupId
    ^ group_id

    "Created: / 07-09-2014 / 18:07:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

threadId
    ^ id

    "Created: / 07-09-2014 / 18:07:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBThreadEvent methodsFor:'initialization'!

setThread: aGDBThread
    thread := aGDBThread

    "Created: / 07-09-2014 / 15:05:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBThreadEvent class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

