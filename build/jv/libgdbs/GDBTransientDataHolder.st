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

Object subclass:#GDBTransientDataHolder
	instanceVariableNames:'debugger factory value seqno'
	classVariableNames:'InvalidValue'
	poolDictionaries:''
	category:'GDB-Private'
!

!GDBTransientDataHolder class methodsFor:'documentation'!

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

!GDBTransientDataHolder class methodsFor:'initialization'!

initialize
    "Invoked at system start or when the class is dynamically loaded."

    "/ please change as required (and remove this comment)

    InvalidValue := Object new

    "Modified: / 29-01-2018 / 23:58:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBTransientDataHolder class methodsFor:'instance creation'!

debugger: aGDBDebugger factory: aBlock
    ^ self new setDebugger: aGDBDebugger factory: aBlock

    "Created: / 17-09-2014 / 22:08:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBTransientDataHolder methodsFor:'accessing'!

value
    | token old new |
    (value ~~ InvalidValue and:[debugger currentInferiorStateSequnceNumber == seqno]) ifTrue:[ 
        ^ value.
    ].
    old := value == InvalidValue ifTrue:[ nil ] ifFalse:[ value ].
    value := token := Object new.
    new := factory valueWithOptionalArgument: old.
    value == token ifTrue:[ 
        self value: new.
    ].
    ^ value

    "Created: / 17-09-2014 / 22:06:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 31-01-2018 / 09:28:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

value: anObject
    value := anObject.
    seqno := debugger currentInferiorStateSequnceNumber.

    "Created: / 30-01-2018 / 00:05:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 30-01-2018 / 09:06:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBTransientDataHolder methodsFor:'initialization'!

setDebugger: aGDBDebugger factory: aBlock
    debugger := aGDBDebugger.
    factory := aBlock.
    value := InvalidValue

    "Created: / 17-09-2014 / 22:08:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 29-01-2018 / 23:59:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBTransientDataHolder class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


GDBTransientDataHolder initialize!
