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

GDBObject subclass:#GDBDebuggerObject
	instanceVariableNames:'debugger'
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core'
!

!GDBDebuggerObject class methodsFor:'documentation'!

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

!GDBDebuggerObject class methodsFor:'testing'!

isAbstract
    ^ self == GDBDebuggerObject
! !

!GDBDebuggerObject methodsFor:'accessing'!

debugger
    ^ debugger
! !

!GDBDebuggerObject methodsFor:'initialization & release'!

setDebugger: aGDBDebugger
    self assert: (debugger isNil or:[ aGDBDebugger isNil ]).
    debugger := aGDBDebugger

    "Created: / 07-09-2014 / 21:17:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 10-07-2017 / 12:57:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBDebuggerObject methodsFor:'private'!

ensureIsValid
    self isValid ifFalse:[
        (GDBInvalidObjectError newException)
            parameter:self;
            messageText:'Object is no longer valid';
            raise.
    ].

    "Created: / 04-02-2018 / 21:27:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBDebuggerObject methodsFor:'testing'!

isValid
    "Return `true`, if the object is still `valid`, false otherwise. For example,
     a `GDBFrame` instance may become invalid when the frame is unwound and no
     longer exist."

    ^ self subclassResponsibility

    "Created: / 04-02-2018 / 21:24:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBDebuggerObject class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

