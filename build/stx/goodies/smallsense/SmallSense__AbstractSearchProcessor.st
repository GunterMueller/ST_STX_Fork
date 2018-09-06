"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2014 Jan Vrany

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

Object subclass:#AbstractSearchProcessor
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SmallSense-Core-Interface-Search'
!

AbstractSearchProcessor class instanceVariableNames:'recentlySearchedObjectPOs'

"
 No other class instance variables are inherited by this class.
"
!

!AbstractSearchProcessor class methodsFor:'documentation'!

copyright
"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2014 Jan Vrany

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

!AbstractSearchProcessor class methodsFor:'accessing'!

recentlySearchedObjectPOs
    recentlySearchedObjectPOs isNil ifTrue:[
        recentlySearchedObjectPOs := OrderedSet new.
    ].
    ^ recentlySearchedObjectPOs

    "Created: / 13-12-2014 / 08:23:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractSearchProcessor class methodsFor:'queries'!

isAbstract
    "Return if this class is an abstract class.
     True is returned here for myself only; false for subclasses.
     Abstract subclasses must redefine again."

    ^ self == SmallSense::AbstractSearchProcessor.
! !

!AbstractSearchProcessor class methodsFor:'remembering'!

rememberSearchObjectPO: aPO
    self recentlySearchedObjectPOs add: aPO

    "Created: / 11-01-2015 / 06:19:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractSearchProcessor methodsFor:'accessing'!

canDoNextStepFor: aPO
    "Return true if navigation can take a next step for given PO
     (i.e., if user can 'dive in'), false otherwise.
     To be overriden by subclasses to avoid excessive processor creation."

    ^ (self processorForNextStepFor: aPO) notNil.

    "Created: / 23-01-2015 / 22:16:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

processorForNextStepFor: aPO
    "Return a processor for next navigation step for given PO.
     If nil is returned, then there's no next step (i.e.,
     a user connot 'dive in')"

    ^ nil

    "Created: / 23-01-2015 / 22:04:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

recentlySearchedObjectPOs
    ^ self class recentlySearchedObjectPOs asArray reversed

    "Created: / 11-01-2015 / 06:21:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractSearchProcessor methodsFor:'accessing - presentation'!

label
    "Return a label for this processor. This one is used as section label
     in Spotter"

    ^ self subclassResponsibility

    "Created: / 10-01-2015 / 06:40:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractSearchProcessor methodsFor:'remembering'!

rememberSearchObjectPO: po
    self class rememberSearchObjectPO: po

    "Created: / 11-01-2015 / 06:19:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

rememberSearchObjectPOs: pos
    pos do:[:po | self rememberSearchObjectPO: po ]

    "Created: / 11-01-2015 / 06:19:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractSearchProcessor methodsFor:'searching'!

matchingObjectPOsFor: objects

    self subclassResponsibility.

    "Created: / 30-04-2014 / 09:46:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

matchingObjectPOsForPattern:pattern filter: filter inEnvironment:environment
    ^ self matchingObjectPOsFor: 
        (self matchingObjectsForPattern: pattern filter: filter inEnvironment: environment).

    "Created: / 12-12-2014 / 23:31:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

matchingObjectsForPattern:pattern filter: filter inEnvironment:environment
    | objects |

    objects := self matchingObjectsForPattern:pattern filter: filter inEnvironment:environment relax: 1.
    objects notEmptyOrNil ifTrue:[ ^ objects ].

    objects := self matchingObjectsForPattern:pattern filter: filter inEnvironment:environment relax: 2.
    objects notEmptyOrNil ifTrue:[ ^ objects ].

    objects := self matchingObjectsForPattern:pattern filter: filter inEnvironment:environment relax: 3.
    ^ objects

    "Created: / 12-12-2014 / 21:23:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

matchingObjectsForPattern:pattern filter: filter inEnvironment:environment relax: level
    self subclassResponsibility

    "Created: / 12-12-2014 / 21:22:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

