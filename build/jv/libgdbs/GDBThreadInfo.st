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

GDBObject subclass:#GDBThreadInfo
	instanceVariableNames:'id target_id frame state'
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Private'
!

!GDBThreadInfo class methodsFor:'documentation'!

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

!GDBThreadInfo class methodsFor:'accessing - GDB value descriptors'!

description
    ^ (super description)
        define:#'id' as:Integer;
        define:#'target-id' as:String;
        "/ define:#'frame' as: GDBFrame
        define:#'state' as: String;
        yourself

    "Created: / 06-09-2014 / 02:21:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-11-2017 / 17:20:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBThreadInfo methodsFor:'accessing'!

id
    ^ id
!

state
    ^ state
!

targetId
    ^ target_id

    "Created: / 08-03-2015 / 08:39:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBThreadInfo methodsFor:'accessing-private'!

_state: aString
    state := GDBThreadState fromString: aString

    "Created: / 08-03-2015 / 08:35:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBThreadInfo methodsFor:'initialization'!

setId: idArg state: stateArg
    id := idArg.
    state := stateArg

    "Created: / 08-03-2015 / 10:27:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBThreadInfo class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

