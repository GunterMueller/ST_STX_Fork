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

GDBAsyncEvent subclass:#GDBExecutionEvent
	instanceVariableNames:'thread_id threads'
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core-Events'
!

!GDBExecutionEvent class methodsFor:'documentation'!

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

!GDBExecutionEvent methodsFor:'accessing'!

threads
    ^ threads
! !

!GDBExecutionEvent methodsFor:'initialization'!

setThreads: aCollection
    self assert: threads isNil.
    threads := aCollection

    "Created: / 08-09-2014 / 22:02:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBExecutionEvent methodsFor:'testing'!

isExecutionEvent
    ^ true

    "Created: / 01-06-2014 / 23:38:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

