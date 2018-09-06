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

GDBNotificationEvent subclass:#GDBThreadGroupEvent
	instanceVariableNames:'threadGroup id'
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core-Events'
!

!GDBThreadGroupEvent class methodsFor:'documentation'!

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

!GDBThreadGroupEvent class methodsFor:'accessing - GDB value descriptors'!

description
    ^ (super description)
        define:#id as:String;
        yourself

    "Created: / 06-09-2014 / 02:10:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBThreadGroupEvent methodsFor:'accessing'!

threadGroup
    ^ threadGroup
!

threadGroupId
    ^ id

    "Created: / 07-09-2014 / 15:08:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBThreadGroupEvent methodsFor:'initialization'!

setThreadGroup: aGDBThreadGroup
    self assert: id = aGDBThreadGroup id.
    threadGroup := aGDBThreadGroup.

    "Created: / 07-09-2014 / 12:45:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-09-2014 / 18:05:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBThreadGroupEvent class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

