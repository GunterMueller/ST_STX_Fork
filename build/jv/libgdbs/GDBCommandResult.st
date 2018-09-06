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

GDBObject subclass:#GDBCommandResult
	instanceVariableNames:'command status value'
	classVariableNames:''
	poolDictionaries:'GDBCommandStatus'
	category:'GDB-Core-Commands'
!

!GDBCommandResult class methodsFor:'documentation'!

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

!GDBCommandResult methodsFor:'accessing'!

command
    ^ command
!

command:something
    command := something.
!

status
    ^ status
!

status:something
    status := something.
!

value
    "Returns a command result value as GDB object or nil, if
     command result is just a set of properties. In that case,
     use #propertyAt: to query individual property values."
    ^ value

    "Modified (comment): / 19-03-2015 / 08:19:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBCommandResult methodsFor:'accessing-properties'!

properties
    ^ GDBObject getPropertiesOf: self.

    "Modified: / 20-06-2014 / 09:04:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

propertyAt: name
    ^ GDBObject getProperty: name of: self

    "Created: / 31-05-2014 / 00:00:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 20-06-2014 / 09:05:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

propertyAt: name put: val
    ^ GDBObject setProperty: name of: self to: val

    "Created: / 31-05-2014 / 00:01:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 20-06-2014 / 09:05:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBCommandResult methodsFor:'testing'!

isDone
    ^ status = CommandStatusDone

    "Created: / 12-06-2017 / 09:36:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isError
    ^ status = CommandStatusError

    "Created: / 12-06-2017 / 09:36:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBCommandResult class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

