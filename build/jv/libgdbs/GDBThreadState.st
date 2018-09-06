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

Object subclass:#GDBThreadState
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core'
!

GDBThreadState class instanceVariableNames:'theOneAndOnlyInstance'

"
 No other class instance variables are inherited by this class.
"
!

!GDBThreadState class methodsFor:'documentation'!

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

!GDBThreadState class methodsFor:'instance creation'!

flushSingleton
    "flushes the cached singleton"

    theOneAndOnlyInstance := nil

    "
     self flushSingleton
    "
!

fromString: aString
    aString = 'running' ifTrue:[ ^ GDBThreadStateRunning theOneAndOnlyInstance ].
    aString = 'stopped' ifTrue:[ ^ GDBThreadStateStopped theOneAndOnlyInstance ].
    aString = 'terminated' ifTrue:[ ^ GDBThreadStateTerminated theOneAndOnlyInstance ].

    self error: 'Inavlid thread state'

    "Created: / 08-03-2015 / 08:37:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

new
    "returns a singleton"

    ^ self theOneAndOnlyInstance.
!

theOneAndOnlyInstance
    "returns a singleton"

    self == GDBThreadState ifTrue:[ 
        self error: 'GDBThreadState is an abstract superclass'
    ].

    theOneAndOnlyInstance isNil ifTrue:[
        theOneAndOnlyInstance := self basicNew initialize.
    ].
    ^ theOneAndOnlyInstance.

    "Modified: / 01-10-2014 / 01:27:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBThreadState class methodsFor:'testing'!

isAbstract
    ^ self == GDBThreadState
! !

!GDBThreadState methodsFor:'testing'!

isRunning
    ^ false

    "Created: / 07-09-2014 / 23:22:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isStopped
    ^ false

    "Created: / 07-09-2014 / 23:22:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isTerminated
    ^ false

    "Created: / 07-09-2014 / 23:22:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isUnknown
    ^ false

    "Created: / 12-07-2017 / 13:35:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

