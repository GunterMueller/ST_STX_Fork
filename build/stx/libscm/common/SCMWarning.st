"
stx:libscm - a new source code management library for Smalltalk/X
Copyright (C) 2012-2015 Jan Vrany

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
"{ Package: 'stx:libscm/common' }"

Notification subclass:#SCMWarning
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Common-StX-Exceptions'
!

!SCMWarning class methodsFor:'documentation'!

copyright
"
stx:libscm - a new source code management library for Smalltalk/X
Copyright (C) 2012-2015 Jan Vrany

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

!SCMWarning methodsFor:'default actions'!

defaultAction
    "Default action for warnings: log warning using system logger and
     show on Transcript (if Transcript is a view)"

    | message |

    message := self description.
    Logger log: message severity: #warning facility: 'SCM'.
    Transcript isView ifTrie:[  
        Transcript show:'[SCM] Warning: '; showCR: message.
    ].
    self proceed.

    "Created: / 14-03-2014 / 22:38:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

