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

GDBEvent subclass:#GDBAsyncEvent
	instanceVariableNames:'type'
	classVariableNames:'EventTypeToEventClassMap'
	poolDictionaries:''
	category:'GDB-Core-Events'
!

!GDBAsyncEvent class methodsFor:'documentation'!

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

!GDBAsyncEvent class methodsFor:'initialization'!

initialize
    "Invoked at system start or when the class is dynamically loaded."

    EventTypeToEventClassMap := Dictionary new.
    Smalltalk isStandAloneApp ifTrue:[
        self allSubclassesDo:[:cls|
            | type |    

            type := cls basicNew type.
            type notNil ifTrue:[ 
                EventTypeToEventClassMap at: type put: cls.
            ].
        ]
    ].

    "Modified: / 08-09-2014 / 23:49:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBAsyncEvent class methodsFor:'accessing'!

eventClassForType: type
    | eventClassName eventClass |

    eventClass := EventTypeToEventClassMap at: type ifAbsent:[
        eventClassName := (String streamContents:[ :out | 
            | in |

            out nextPutAll: 'GDB'.
            in := type readStream.
            out nextPut: in next asUppercase.
            [ in atEnd ] whileFalse:[ 
                | c |

                c := in next.
                c == $- ifTrue:[ 
                    c := in next asUppercase.
                ].
                out nextPut: c.
            ].
            out nextPutAll: 'Event'.  
        ]) asSymbol.

        eventClass := Smalltalk at: eventClassName asSymbol.
        eventClass isNil ifTrue:[ 
            Smalltalk isStandAloneApp ifFalse:[  
                eventClass := self subclass:eventClassName
                                    instanceVariableNames:''
                                    classVariableNames:''
                                    poolDictionaries:''
                                    category:'GDB-Core-Events'.
                eventClass compile: (String streamContents: [ :s|s nextPutAll:'type'; cr; tab; nextPutAll:'^  '; nextPutAll: type storeString ]) classified: 'accessing'.
            ] ifTrue:[
                eventClass := self.
            ]
        ].
        eventClass
    ].
    ^ eventClass

    "Created: / 12-06-2014 / 17:03:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-06-2014 / 07:12:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBAsyncEvent class methodsFor:'accessing - GDB value descriptors'!

description
    ^ (super description)
    
    "/define: #prop as: String;
     yourself

    "Created: / 08-09-2014 / 21:59:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 23-09-2014 / 23:18:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBAsyncEvent class methodsFor:'queries'!

isAbstract
    "Return if this class is an abstract class.
     True is returned here for myself only; false for subclasses.
     Abstract subclasses must redefine again."

    ^ self == GDBAsyncEvent.

    "Modified: / 02-06-2014 / 22:20:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBAsyncEvent methodsFor:'accessing'!

type
    ^ type
!

type:aString
    type := aString.
! !

!GDBAsyncEvent methodsFor:'displaying'!

displayString
    ^ type

    "Created: / 12-06-2014 / 01:15:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBAsyncEvent methodsFor:'testing'!

isAsyncEvent
    ^ true

    "Created: / 11-07-2017 / 11:03:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBAsyncEvent class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


GDBAsyncEvent initialize!
