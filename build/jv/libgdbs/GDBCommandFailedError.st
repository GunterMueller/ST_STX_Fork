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

GDBError subclass:#GDBCommandFailedError
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core-Exeptions'
!

!GDBCommandFailedError class methodsFor:'documentation'!

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

!GDBCommandFailedError class methodsFor:'raising'!

raiseForResult: result
    <resource: #skipInDebuggersWalkBack>

    self newException
        result: result;
        raise.

    "Created: / 13-09-2017 / 14:47:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBCommandFailedError methodsFor:'accessing'!

command
    "Returns the command (as `GDBCommand`) that failed."

    ^ self result command

    "Created: / 13-09-2017 / 14:40:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

result
    "Returns the command result (as `GDBCommandResult`) for the failure"

    ^ self parameter

    "Created: / 13-09-2017 / 14:41:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

result: aGDBCommandResult
    parameter := aGDBCommandResult.
    messageText := 'Command failed: ', (aGDBCommandResult propertyAt: 'msg').

    "Created: / 13-09-2017 / 14:48:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

