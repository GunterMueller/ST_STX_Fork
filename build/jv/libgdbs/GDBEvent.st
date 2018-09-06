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

Announcement subclass:#GDBEvent
	instanceVariableNames:'token properties'
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core-Events'
!

!GDBEvent class methodsFor:'documentation'!

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

!GDBEvent class methodsFor:'accessing-magritte'!

descriptionContainer
    ^ GDBMAContainer forClass: self.

    "Created: / 23-09-2014 / 23:26:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBEvent class methodsFor:'testing'!

isAbstract
    ^ self == GDBEvent

    "Modified: / 02-06-2014 / 22:20:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBEvent methodsFor:'accessing'!

token
    ^ token
!

token:anInteger
    token := anInteger.
! !

!GDBEvent methodsFor:'accessing-properties'!

properties
    ^ GDBObject getPropertiesOf: self.

    "Modified: / 20-06-2014 / 09:04:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

propertyAt: name
    ^ GDBObject getProperty: name of: self

    "Created: / 31-05-2014 / 00:00:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 20-06-2014 / 09:05:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

propertyAt: name put: value
    ^ GDBObject setProperty: name of: self to: value

    "Created: / 31-05-2014 / 00:01:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 20-06-2014 / 09:05:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBEvent methodsFor:'testing'!

isAsyncEvent
    "return false here; to be redefined in subclass(es)"

    ^ false
!

isCommandResultEvent
    ^ false
!

isConsoleOutputEvent
    ^ false

    "Created: / 01-06-2014 / 23:37:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isExecutionEvent
    ^ false

    "Created: / 01-06-2014 / 23:38:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isLogOutputEvent
    ^ false

    "Created: / 01-06-2014 / 23:37:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isNotificationEvent
    ^ false

    "Created: / 01-06-2014 / 23:37:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isStatusEvent
    ^ false

    "Created: / 01-06-2014 / 23:38:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isTargetOutputEvent
    ^ false

    "Created: / 01-06-2014 / 23:37:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBEvent class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

