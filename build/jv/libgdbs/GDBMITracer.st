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

Object subclass:#GDBMITracer
	instanceVariableNames:'record buffer'
	classVariableNames:''
	poolDictionaries:'GDBDebugFlags'
	category:'GDB-Private-MI Trace'
!

!GDBMITracer class methodsFor:'documentation'!

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

!GDBMITracer class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!GDBMITracer methodsFor:'accessing'!

trace
    ^ record
! !

!GDBMITracer methodsFor:'initialization'!

initialize
    "Invoked when a new instance is created."
    
    record := GDBMITrace new.
    buffer := (String new:100) writeStream.

    "/ responseBuffer := nil.
    "/ super initialize.   -- commented since inherited method does nothing
    "Modified: / 24-06-2014 / 00:10:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 09-03-2018 / 08:53:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBMITracer methodsFor:'recording'!

recordCommand: command
    record >>> command

    "Created: / 22-06-2014 / 21:39:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 24-06-2014 / 00:36:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

recordResponse: aString
    buffer nextPutAll: aString

    "Created: / 22-06-2014 / 21:56:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 24-06-2014 / 00:10:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

recordResponseChar: aCharacter
    buffer nextPut: aCharacter

    "Created: / 22-06-2014 / 21:42:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 24-06-2014 / 00:10:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

recordResponseEnd
    record <<< buffer contents.
    buffer reset.

    "Created: / 22-06-2014 / 21:54:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 24-06-2014 / 00:36:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBMITracer class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

