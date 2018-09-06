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

Object subclass:#GDBProcess
	instanceVariableNames:'pid connection debuggerInput debuggerOutput'
	classVariableNames:'GDBExecutable'
	poolDictionaries:''
	category:'GDB-Private'
!

!GDBProcess class methodsFor:'documentation'!

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

!GDBProcess class methodsFor:'instance creation'!

new
    OperatingSystem isUNIXlike ifTrue:[ ^ GDBUnixProcess basicNew initialize].
    OperatingSystem isMSWINDOWSlike ifTrue:[ ^ GDBWindowsProcess basicNew initialize].
    GDBError raiseErrorString: 'Unssuported operating system'.

    "
    GDBProcess new release.
    "

    "Modified: / 16-12-2017 / 00:10:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 11-01-2018 / 23:02:11 / jv"
! !

!GDBProcess class methodsFor:'accessing'!

gdbExecutable
    ^ UserPreferences current vdbGdbExecutable

    "Created: / 01-03-2015 / 08:07:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-09-2018 / 09:24:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

gdbExecutable: aString
    UserPreferences current vdbGdbExecutable: aString

    "Created: / 01-03-2015 / 08:07:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-09-2018 / 09:24:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBProcess class methodsFor:'queries'!

isAbstract
    "Return if this class is an abstract class.
     True is returned here for myself only; false for subclasses.
     Abstract subclasses must redefine again."

    ^ self == GDBProcess.
! !

!GDBProcess methodsFor:'accessing'!

connection:aGDBConnection
    connection := aGDBConnection.
!

consoleInput
    ^ nil

    "Created: / 02-06-2017 / 23:35:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-12-2017 / 23:58:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

consoleOutput
    ^ nil

    "Created: / 02-06-2017 / 23:35:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-12-2017 / 23:58:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

debuggerInput
    "raise an error: must be redefined in concrete subclass(es)"

    ^ debuggerInput

    "Modified: / 15-12-2017 / 23:58:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

debuggerOutput
    "raise an error: must be redefined in concrete subclass(es)"

    ^ debuggerOutput

    "Modified: / 15-12-2017 / 23:58:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

nativeTargetFeatures
    ^ self subclassResponsibility

    "Created: / 09-04-2018 / 15:40:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

pid
    ^ pid
! !

!GDBProcess methodsFor:'initialization & release'!

initialize
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
! !

!GDBProcess methodsFor:'private'!

exited: status
    pid := nil.
    connection released: status

    "Created: / 20-06-2014 / 21:35:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-01-2018 / 21:50:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBProcess class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

