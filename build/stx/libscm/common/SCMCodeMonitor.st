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

Object subclass:#SCMCodeMonitor
	instanceVariableNames:'sequenceNumber'
	classVariableNames:'Current SequenceNumberMax'
	poolDictionaries:''
	category:'SCM-Common-StX'
!

!SCMCodeMonitor class methodsFor:'documentation'!

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
!

documentation
"
    SCMCodeMonitor is helper class that monitors code changes
    in Smalltalk. Upon each change (class or method added/removed/moved
    to package/...) it increases internal sequenceNumber.

    Client may use that sequence number to check whether some
    cached data are still valid - they should be considered
    out-of-date if sequence number from monitor differs from
    sequence number remembered when cached value has been 
    computed.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!SCMCodeMonitor class methodsFor:'initialization'!

initialize
    "Invoked at system start or when the class is dynamically loaded."

    "/ please change as required (and remove this comment)

    SequenceNumberMax := SmallInteger maxVal

    "Modified: / 28-02-2014 / 23:25:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SCMCodeMonitor class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!SCMCodeMonitor class methodsFor:'accessing'!

sequenceNumber
    Current isNil ifTrue:[ 
        Current := self new.
    ].
    ^ Current sequenceNumber

    "Created: / 28-02-2014 / 23:23:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SCMCodeMonitor methodsFor:'accessing'!

sequenceNumber
    ^ sequenceNumber

    "Created: / 28-02-2014 / 23:29:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SCMCodeMonitor methodsFor:'change & update'!

update:something with:aParameter from:changedObject
    "Invoked when an object that I depend upon sends a change notification."

    ((something == #methodInClass) 
        or:[ something == #projectOrganization
        or:[ something == #classRemove 
        or:[ something == #newClass ]]]
    ) ifTrue:[ 
        sequenceNumber := sequenceNumber == SequenceNumberMax ifTrue:[0] ifFalse:[sequenceNumber := sequenceNumber + 1].
        ^ self
    ].
    ^ self
"/    Transcript showCR: '>> ', something

    "Modified: / 01-03-2014 / 00:13:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SCMCodeMonitor methodsFor:'initialization'!

initialize
    "Invoked when a new instance is created."

    sequenceNumber := 0.
    Smalltalk addDependent: self.  

    "/ super initialize.   -- commented since inherited method does nothing

    "Modified: / 28-02-2014 / 23:25:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !


SCMCodeMonitor initialize!
