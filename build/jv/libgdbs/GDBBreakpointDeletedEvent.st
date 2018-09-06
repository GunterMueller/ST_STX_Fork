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

GDBNotificationEvent subclass:#GDBBreakpointDeletedEvent
	instanceVariableNames:'id'
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core-Events'
!

!GDBBreakpointDeletedEvent class methodsFor:'documentation'!

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

!GDBBreakpointDeletedEvent class methodsFor:'accessing - GDB value descriptors'!

description
    ^ (super description)
        define:#id as:String;
        yourself

    "Created: / 06-09-2014 / 02:12:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-05-2018 / 15:05:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBBreakpointDeletedEvent methodsFor:'accessing'!

id
    ^ id
!

type
	^  'breakpoint-deleted'
! !

