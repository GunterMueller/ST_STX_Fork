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

AbstractListDialog subclass:#AbstractSelectDialog
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SmallSense-Core-Interface-Search'
!

!AbstractSelectDialog class methodsFor:'documentation'!

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

!AbstractSelectDialog class methodsFor:'queries'!

isAbstract
    "Return if this class is an abstract class.
     True is returned here for myself only; false for subclasses.
     Abstract subclasses must redefine again."

    ^ self == SmallSense::AbstractSelectDialog.
! !

!AbstractSelectDialog methodsFor:'accessing-defaults'!

defaultTitle
    ^ (resources string: 'Select...')

    "Created: / 13-12-2014 / 12:57:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractSelectDialog methodsFor:'searching'!

matchingObjectPOsForPattern: pattern
    | pos |

    1 to: 3 do:[:i |
        pos := self matchingObjectPOsForPattern: pattern relax: i.
        pos notEmptyOrNil ifTrue:[ ^ pos ]
    ].

    "Created: / 13-12-2014 / 08:39:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

matchingObjectPOsForPattern: pattern relax: relax
    self subclassResponsibility

    "Created: / 13-12-2014 / 08:40:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

