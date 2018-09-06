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

StrongSubscription subclass:#GDBEventSubscription
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Private'
!

!GDBEventSubscription class methodsFor:'documentation'!

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

!GDBEventSubscription class methodsFor:'private'!

blockFor: anObject withSelector: aSelector

    | args |
    args := aSelector numArgs.      

    anObject isView ifTrue:[ 
        args = 0 ifTrue: [ ^[ anObject sensor pushUserEvent: aSelector for: anObject ] ].
        args = 1 ifTrue: [ ^[ :anAnnouncement | anObject sensor pushUserEvent: aSelector for: anObject withArgument: anAnnouncement ] ].
        args = 2 ifTrue: [ ^[ :anAnnouncement :anAnnouncer | anObject sensor pushUserEvent: aSelector for: anObject withArguments: (Array with: anAnnouncement with: anAnnouncer) ] ].
        self error: 'Couldn''t create block'.        
    ].
    (anObject isKindOf: ApplicationModel) ifTrue:[ 
        args = 0 ifTrue: [ ^[ anObject window sensor pushUserEvent: aSelector for: anObject ] ].
        args = 1 ifTrue: [ ^[ :anAnnouncement | anObject window sensor pushUserEvent: aSelector for: anObject withArgument: anAnnouncement ] ].
        args = 2 ifTrue: [ ^[ :anAnnouncement :anAnnouncer | anObject window sensor pushUserEvent: aSelector for: anObject withArguments: (Array with: anAnnouncement with: anAnnouncer) ] ].
        self error: 'Couldn''t create block'.        
    ].
    ^ super blockFor: anObject withSelector: aSelector

    "Created: / 18-09-2014 / 00:10:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

