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

OrderedCollection subclass:#GDBMITrace
	instanceVariableNames:'lock'
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Private-MI Trace'
!

Object subclass:#Command
	instanceVariableNames:'string'
	classVariableNames:''
	poolDictionaries:''
	privateIn:GDBMITrace
!

Object subclass:#Response
	instanceVariableNames:'string'
	classVariableNames:''
	poolDictionaries:''
	privateIn:GDBMITrace
!

!GDBMITrace class methodsFor:'documentation'!

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

!GDBMITrace class methodsFor:'instance creation'!

new
    ^ super new initialize.

    "Created: / 24-06-2014 / 00:07:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

new: size
    "return an initialized instance"

    ^ (super new: size) initialize.

    "Created: / 24-06-2014 / 00:06:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBMITrace methodsFor:'adding & removing'!

add:anObject
    "add the argument, anObject to the end of the collection
     Return the argument, anObject."

    ^ lock critical:[ 
        super add:anObject
    ].

    "Modified: / 29-01-1998 / 10:52:32 / cg"
    "Modified: / 23-06-2014 / 23:55:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

add:anObject beforeIndex:index
    "add the argument, anObject to the end of the collection.
     Return the receiver (sigh - ST-80 compatibility)."

    ^ lock critical:[ 
        super add:anObject beforeIndex:index
    ].

    "Modified: / 23-06-2014 / 23:55:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addAll:aCollection beforeIndex:index
    "insert all elements of the argument
     Return the receiver."

    ^ lock critical:[ 
        super addAll:aCollection beforeIndex:index      
    ].

    "Modified: / 23-06-2014 / 23:55:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addAllLast:aCollection
    "add all elements of the argument, aCollection to the end of the collection.
     Return the argument, aCollection."

    ^ lock critical:[ 
        super addAllLast:aCollection       
    ].

    "Modified: / 23-06-2014 / 23:56:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addFirst:anObject
    "add the argument, anObject to the beginning of the collection.
     Return the argument, anObject."

     ^ lock critical:[ 
        super addFirst:anObject
    ].

    "Modified: / 29-01-1998 / 10:53:09 / cg"
    "Modified: / 23-06-2014 / 23:56:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBMITrace methodsFor:'initialization'!

initialize
    "Invoked when a new instance is created."

    "/ please change as required (and remove this comment)
    super initialize.
    lock := RecursionLock new.

    "/ super initialize.   -- commented since inherited method does nothing

    "Modified: / 24-06-2014 / 00:05:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBMITrace methodsFor:'printing & storing'!

printOn:aStream
    self do:[:each | each printOn: aStream ]

    "Modified: / 23-06-2014 / 23:51:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBMITrace methodsFor:'recording'!

<<< aString
    self add: (Response new string: aString)

    "Created: / 24-06-2014 / 00:35:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

>>> aString
    self add: (Command new string: aString)

    "Created: / 24-06-2014 / 00:35:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBMITrace methodsFor:'saving & restoring'!

saveInClass: class selector: selector
    "Save recorded session in given class under given selector"

    | source |

    source := String new writeStream.
    source nextPutAll: selector; cr; cr.
    source nextPutAll:' ^ (GDBSessionRecord new: '.
    self size printOn: source.
    source nextPutAll: ')'; cr; cr.

    self do:[:each | 
        each isCommand ifTrue:[ 
            source nextPutLine: '>>>'.
        ] ifFalse:[
            source nextPutLine: '<<<'.
        ].
        each string storeOn: source.
        source nextPut: $;; cr; cr.  
    ].
    source nextPutAll: 'yourself'.

    class compile: source contents classified: 'recorded sessions'

    "Created: / 23-06-2014 / 23:14:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 24-06-2014 / 00:44:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

saveInSimulatorResourceAs: selector
    ^ self saveInClass: GDBSimulatorResource selector: selector

    "Created: / 23-06-2014 / 23:17:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBMITrace::Command methodsFor:'accessing'!

string
    ^ string
!

string:something
    string := something.
! !

!GDBMITrace::Command methodsFor:'printing & storing'!

printOn:aStream
    "append a printed representation if the receiver to the argument, aStream"

    aStream nextPutLine: '>>>'.
    string printOn: aStream.
    aStream cr.

    "Modified: / 24-06-2014 / 00:09:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBMITrace::Command methodsFor:'testing'!

isCommand
    ^ true

    "Created: / 24-06-2014 / 00:41:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isResponse
    ^ false

    "Created: / 24-06-2014 / 00:41:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBMITrace::Response methodsFor:'accessing'!

string
    ^ string
!

string:something
    string := something.
! !

!GDBMITrace::Response methodsFor:'printing & storing'!

printOn:aStream
    "append a printed representation if the receiver to the argument, aStream"

    aStream nextPutLine: '<<<'.
    string printOn: aStream.
    aStream cr.

    "Modified: / 24-06-2014 / 00:08:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBMITrace::Response methodsFor:'testing'!

isCommand
    ^ false

    "Created: / 24-06-2014 / 00:41:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isResponse
    ^ true

    "Created: / 24-06-2014 / 00:41:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

