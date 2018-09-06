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

Magritte::MAAccessor subclass:#GDBMAPropertyAccessor
	instanceVariableNames:'name'
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Support'
!

!GDBMAPropertyAccessor class methodsFor:'documentation'!

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

!GDBMAPropertyAccessor class methodsFor:'instance-creation'!

forPropertyNamed: aString
    ^ self new
        name: aString;
        yourself

    "Created: / 23-09-2014 / 22:19:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBMAPropertyAccessor class methodsFor:'testing'!

isAbstract
    ^ false

    "Created: / 23-09-2014 / 22:38:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBMAPropertyAccessor methodsFor:'accessing'!

name
    ^ name
!

name:aString
    name := aString.
! !

!GDBMAPropertyAccessor methodsFor:'model'!

read: object

    | nmXlated names index properties |

    nmXlated := (name includes: $-) ifTrue:[ name copyReplaceAll: $- with: $_] ifFalse:[ name ].
    index := (names := object class allInstVarNames) indexOf: nmXlated.
    index ~~ 0 ifTrue:[ 
        ^ object instVarAt: index.
    ].
    index := names indexOf: #properties.
    index ~~ 0 ifTrue:[ 
        properties := object instVarAt: index.
        properties notNil ifTrue:[ 
            ^ properties at: name ifAbsent:[ nil ]
        ].
    ].
    ^ nil

    "Created: / 23-09-2014 / 22:15:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

write: value to: object

    | nmXlated names index properties |

    nmXlated := (name includes: $-) ifTrue:[ name copyReplaceAll: $- with: $_] ifFalse:[ name ].
    index := (names := object class allInstVarNames) indexOf: nmXlated.
    index ~~ 0 ifTrue:[ 
        object instVarAt: index put: value.
    ] ifFalse:[
        index := names indexOf: #properties.
        index ~~ 0 ifTrue:[ 
            properties := object instVarAt: index.
            properties isNil ifTrue:[ 
                properties := Dictionary new.
                object instVarAt: index put: properties.
            ].
            properties at: name put: value.
        ].
    ].

    "Created: / 23-09-2014 / 22:16:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBMAPropertyAccessor class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

