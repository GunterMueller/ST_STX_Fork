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

GDBDebuggerObject subclass:#GDBTransientObject
	instanceVariableNames:'stateSequenceNumber'
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core'
!

!GDBTransientObject class methodsFor:'documentation'!

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

!GDBTransientObject class methodsFor:'testing'!

isAbstract
    ^ self == GDBTransientObject
! !

!GDBTransientObject methodsFor:'initialization'!

debugger: aGDBDebugger
    self assert: (debugger isNil or:[ debugger == aGDBDebugger ]).
    debugger := aGDBDebugger.
    stateSequenceNumber := debugger currentInferiorStateSequnceNumber

    "Created: / 27-02-2015 / 15:10:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-02-2015 / 17:22:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBTransientObject methodsFor:'testing'!

isValid
    ^ debugger currentInferiorStateSequnceNumber ~~ stateSequenceNumber
! !

