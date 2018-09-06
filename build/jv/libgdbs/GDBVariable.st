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

GDBDebuggerObject subclass:#GDBVariable
	instanceVariableNames:'frame name value type arg varobj'
	classVariableNames:'VarobjUnavailable'
	poolDictionaries:''
	category:'GDB-Core'
!

!GDBVariable class methodsFor:'documentation'!

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

!GDBVariable class methodsFor:'initialization'!

initialize
    "Invoked at system start or when the class is dynamically loaded."

    VarobjUnavailable := Object new.

    "Modified (comment): / 05-07-2018 / 11:05:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBVariable class methodsFor:'accessing - GDB value descriptors'!

description
    ^ (super description)
        define:#name as:String;
        define:#arg as:Boolean;       
        yourself

    "Created: / 16-09-2014 / 23:59:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-07-2018 / 11:07:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBVariable methodsFor:'accessing'!

children
    | vobj |

    vobj := self varobj.
    ^ vobj notNil ifTrue:[ vobj children ] ifFalse: [ #() ].

    "Created: / 05-07-2018 / 11:59:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

expression
    ^ self name

    "Created: / 05-07-2018 / 11:58:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

name
    ^ name
!

path
    ^ self expression

    "Created: / 05-07-2018 / 11:58:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

type
    ^ type
!

value
    | vobj |

    vobj := self varobj.
    ^ vobj notNil ifTrue:[ vobj value ] ifFalse: [ value ].

    "Created: / 27-02-2015 / 23:37:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-07-2018 / 12:02:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visualizer: aString   
    "Ignored, to make it polymorphic with GDBVariableObject"

    "Created: / 01-09-2018 / 00:57:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBVariable methodsFor:'accessing-private'!

varobj
    varobj isNil ifTrue:[ 
        varobj := [ debugger evaluate: name in: frame ] on: GDBCommandFailedError do: [ VarobjUnavailable ].
    ].
    varobj == VarobjUnavailable ifTrue:[ ^ nil ].
    ^ varobj

    "Created: / 27-02-2015 / 17:18:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-01-2018 / 23:10:31 / jv"
    "Modified: / 05-07-2018 / 11:06:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBVariable methodsFor:'copying'!

duplicate
    "Create and returns a duplicate of the receiver, representing
     the same value. Other than that the returned duplicate is completely 
     independent" 

    varobj == VarobjUnavailable ifTrue:[ 
        ^ self
    ].
    ^ varobj duplicate

    "Created: / 01-09-2018 / 00:27:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBVariable methodsFor:'initialization'!

setFrame: aGDBFrame
    self assert: frame isNil.
    self assert: (debugger isNil or:[ debugger == aGDBFrame debugger ]).
    frame := aGDBFrame.
    self setDebugger: frame debugger.

    "Created: / 27-02-2015 / 17:08:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-02-2018 / 21:41:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setValue: aString
    value := aString

    "Created: / 01-02-2018 / 21:34:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBVariable methodsFor:'inspecting'!

inspectorExtraAttributes
    ^ super inspectorExtraAttributes
        add:('-varobj' -> [ self varobj ]);
        yourself

    "Created: / 13-06-2017 / 14:51:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBVariable methodsFor:'printing & storing'!

printOn:aStream
    "append a printed representation if the receiver to the argument, aStream"

    super printOn:aStream.
    aStream nextPutAll:'('.
    name printOn: aStream.
    aStream nextPutAll:': '.
    aStream nextPutAll: self valueString.
    aStream nextPutAll:')'.

    "Modified: / 13-06-2017 / 17:01:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

valueString
    "Return value as string to be presented to user. The difference
     to sending `value displayString` is that #valueString returns a
     pretty-printed value (if pretty printing was enabled for GDB)

     @see GDBMI_enable_pretty_printing
     @see GDBDebugger >> enablePrettyPrinting
    "

    ^ value notNil ifTrue:[ value ] ifFalse:[ self value displayString ]

    "Created: / 11-06-2017 / 23:24:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 12-06-2017 / 09:26:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBVariable methodsFor:'testing'!

hasChanged
    | vobj |

    vobj := self varobj.
    ^ vobj notNil ifTrue:[ vobj hasChanged ] ifFalse: [ false ].

    "Created: / 05-07-2018 / 11:59:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hasChildren
    | vobj |

    vobj := self varobj.
    ^ vobj notNil ifTrue:[ vobj hasChildren ] ifFalse: [ false ].

    "Created: / 05-07-2018 / 12:00:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isArgument
    ^ arg == true

    "Created: / 05-07-2018 / 11:08:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isValid
    ^ frame isValid

    "Created: / 04-02-2018 / 21:32:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parentIsDynamic
    ^ false

    "Created: / 01-09-2018 / 22:52:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBVariable class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


GDBVariable initialize!
