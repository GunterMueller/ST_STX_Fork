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

GDBEvent subclass:#GDBStreamOutputEvent
	instanceVariableNames:'value'
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core-Events'
!

!GDBStreamOutputEvent class methodsFor:'documentation'!

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

!GDBStreamOutputEvent class methodsFor:'testing'!

isAbstract
    ^ self == GDBStreamOutputEvent

    "Modified: / 02-06-2014 / 22:21:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBStreamOutputEvent methodsFor:'accessing'!

value
    ^ value
!

value:aString
    value := aString.
! !

!GDBStreamOutputEvent methodsFor:'displaying'!

displayString
    ^ value upTo: Character cr.

    "Created: / 11-06-2014 / 12:51:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBStreamOutputEvent methodsFor:'printing & storing'!

printOn:aStream
    "append a printed representation if the receiver to the argument, aStream"

    super printOn:aStream.
    aStream nextPut:$(.
    value printOn:aStream.
    aStream nextPut:$).

    "Modified: / 03-06-2014 / 00:18:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

