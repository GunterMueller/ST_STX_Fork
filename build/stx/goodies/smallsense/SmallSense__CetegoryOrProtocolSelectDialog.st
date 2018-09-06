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

AbstractSelectDialog subclass:#CetegoryOrProtocolSelectDialog
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SmallSense-Core-Interface-Search'
!

!CetegoryOrProtocolSelectDialog class methodsFor:'documentation'!

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

!CetegoryOrProtocolSelectDialog methodsFor:'accessing - private'!

matchingObjectForString: aString
    "Creates a new object from given string. Called only when
     #canCreateMatchingObjectFromString: returns true"

    ^ aString asSymbol

    "Created: / 23-06-2014 / 15:25:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CetegoryOrProtocolSelectDialog methodsFor:'accessing-defaults'!

defaultTitle
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
! !

!CetegoryOrProtocolSelectDialog methodsFor:'queries'!

canCreateMatchingObjectFromString:string 
    "Return true, a new object can be created with given string value"
    
    ^ string notEmptyOrNil

    "Created: / 23-06-2014 / 15:15:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 10-01-2015 / 13:36:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

canSelect:selection
    ^ selection isKindOf: PO

    "Created: / 05-05-2014 / 23:50:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-12-2014 / 12:08:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CetegoryOrProtocolSelectDialog methodsFor:'searching'!

matchingObjectPOsForPattern:arg1 relax:arg2
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
! !

