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

Object subclass:#SCMAbstractRevisionInfo
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Common-StX'
!

!SCMAbstractRevisionInfo class methodsFor:'documentation'!

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

!SCMAbstractRevisionInfo class methodsFor:'testing'!

isAbstract
    ^ self == SCMAbstractRevisionInfo
! !

!SCMAbstractRevisionInfo methodsFor:'accessing'!

at:aKey
    "backward compatible dictionary-like accessing"

    (self respondsTo:aKey) ifTrue:[
        ^ self perform:aKey
    ].
    ^ self errorKeyNotFound:aKey

    "
     self new at:#binaryRevision
     self new at:#foo
    "

    "Modified: / 22-10-2008 / 20:23:31 / cg"
!

at:aKey ifAbsent:replacement
    "backward compatible dictionary-like accessing"

    (self respondsTo:aKey) ifTrue:[
        ^ (self perform:aKey) ? replacement
    ].
    ^ replacement

    "
     self new at:#binaryRevision
     self new at:#foo ifAbsent:#bar
    "

    "Created: / 22-10-2008 / 20:19:42 / cg"
!

at:aKey put:value
    "backward compatible dictionary-like accessing"

    (self respondsTo:aKey) ifTrue:[
        self perform:aKey asMutator with:value. 
	^ value "/ sigh
    ].
    ^ self errorKeyNotFound:aKey

    "
     self new at:#binaryRevision put:#bar
     self new at:#foo put:#bar
    "

    "Created: / 22-10-2008 / 20:20:54 / cg"
! !

!SCMAbstractRevisionInfo methodsFor:'enumerating'!

keys
    ^ self properties

    "Created: / 01-05-2014 / 16:22:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

keysAndValuesDo:aBlock
    self properties do:[:nm |
        aBlock value:(nm asSymbol) value:(self perform:nm asSymbol)
    ].

    "Created: / 22-10-2008 / 20:48:08 / cg"
    "Modified: / 01-05-2014 / 16:22:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SCMAbstractRevisionInfo methodsFor:'private'!

properties
    "Return a list of properties this revision info provides"

    ^ self subclassResponsibility

    "Modified (comment): / 01-05-2014 / 16:22:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

