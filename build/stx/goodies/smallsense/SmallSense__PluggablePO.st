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

PO subclass:#PluggablePO
	instanceVariableNames:'icon hint subject'
	classVariableNames:''
	poolDictionaries:''
	category:'SmallSense-Core-Interface-PO'
!

!PluggablePO class methodsFor:'documentation'!

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

!PluggablePO methodsFor:'accessing'!

hint
    "Return a hint text to be displayed in gray after a label
     (if there's space). If nil is returned, no hint is shown"

    ^ hint

    "Created: / 13-12-2014 / 07:51:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hint:something
    hint := something.
!

icon
    ^ icon
!

icon:something
    icon := something.
!

label
    "Return a text to be displayed. The label may be cached
     `label` instvar."

    ^ label

    "Created: / 13-12-2014 / 07:49:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

label: aString
    label := aString

    "Created: / 13-12-2014 / 12:25:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

stringToCompleteForLanguage:aProgrammingLanguage
    "Answers a string to complete"

    ^ self shouldNotImplement

    "Created: / 13-12-2014 / 07:50:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

subject:something
    subject := something.
! !

!PluggablePO methodsFor:'accessing-private'!

subject
    "Return the real object for which the receiver
     is a presentor.
     
     For internal usage only."

    ^ subject

    "Created: / 13-12-2014 / 07:50:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PluggablePO methodsFor:'testing'!

isSmallSensePluggablePO
    ^ true
! !

