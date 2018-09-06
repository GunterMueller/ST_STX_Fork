"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2015 Jan Vrany

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
"{ Package: 'stx:goodies/smallsense' }"

"{ NameSpace: SmallSense }"

Object subclass:#TypeHolder
	instanceVariableNames:'type'
	classVariableNames:''
	poolDictionaries:''
	category:'SmallSense-Smalltalk-Types'
!

!TypeHolder class methodsFor:'documentation'!

copyright
"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2015 Jan Vrany

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

!TypeHolder class methodsFor:'instance creation'!

with: aSmallSenseType

    ^self new type: aSmallSenseType; yourself

    "Created: / 16-12-2011 / 01:42:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TypeHolder methodsFor:'accessing'!

trustfullness
    ^type trustfullness

    "Created: / 17-05-2012 / 19:50:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

trustfullness:aSmallInteger
    type trustfullness:aSmallInteger

    "Created: / 17-05-2012 / 19:50:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

trustfullnessAdd: anInteger
    type trustfullnessAdd: anInteger

    "Created: / 17-05-2012 / 19:50:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

type
    ^ type
!

type:aSmallSenseType

    self assert: aSmallSenseType isTypeHolder not.
    type := aSmallSenseType.

    "Modified: / 16-12-2011 / 02:12:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TypeHolder methodsFor:'adding & removing'!

addClass: aClass

    self type: (type union: (ClassType new klass: aClass)).

    "Created: / 26-11-2011 / 14:04:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addClasses: aCollection

    | union |
    union := UnionType new.
    union addType: type.
    union addTypes: (aCollection collect: [:c|ClassType new klass:c]).
    self type: union

    "Created: / 26-11-2011 / 14:04:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TypeHolder methodsFor:'enumerating'!

classes
    ^ type classes

    "Created: / 04-10-2013 / 13:20:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

classesDo: aBlock

    type classesDo: aBlock

    "Created: / 16-12-2011 / 13:34:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

typesDo: aBlock

    type typesDo: aBlock

    "Created: / 16-12-2011 / 02:17:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TypeHolder methodsFor:'operations'!

classSide

    ^self class with: type classSide

    "Created: / 16-12-2011 / 13:24:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

instanceSide

    ^self class with: type instanceSide

    "Created: / 16-12-2011 / 13:24:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

union: anotherType

    self type: (type union: anotherType)

    "Created: / 16-12-2011 / 02:18:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-09-2013 / 02:30:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TypeHolder methodsFor:'printing & storing'!

printOn:aStream
    "append a printed representation if the receiver to the argument, aStream"

    type printOn: aStream

    "Modified: / 16-12-2011 / 01:46:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

printWithoutAnglesOn: aStream

    self subclassResponsibility

    "Created: / 16-12-2011 / 01:45:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TypeHolder methodsFor:'testing'!

isClassType

    ^type isClassType

    "Created: / 16-12-2011 / 02:00:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 24-07-2013 / 13:08:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isTypeHolder

    ^true

    "Created: / 16-12-2011 / 02:05:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isUnionType

    ^type isUnionType

    "Created: / 16-12-2011 / 02:00:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 24-07-2013 / 13:09:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isUnknownType

    ^type isUnknownType

    "Created: / 24-07-2013 / 13:09:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TypeHolder class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id$'
! !

