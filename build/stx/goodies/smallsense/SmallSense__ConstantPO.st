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

PO subclass:#ConstantPO
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SmallSense-Core-Interface-PO'
!

!ConstantPO class methodsFor:'documentation'!

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

!ConstantPO methodsFor:'accessing'!

label
    "Return a text to be displayed. The label may be cached
     `label` instvar."

    ^ '???'

    "Created: / 20-05-2014 / 11:31:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

stringToCompleteForLanguage:aProgrammingLanguage
    "Answers a string to complete"

    ^ '???'

    "Created: / 20-05-2014 / 11:32:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ConstantPO methodsFor:'accessing-private'!

subject
    "Return the real object for which the receiver
     is a presentor.
     
     For internal usage only."

    ^ self shouldNotImplement

    "Created: / 20-06-2014 / 11:10:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ConstantPO methodsFor:'testing'!

isSmallSenseConstantPO
    ^ true
! !

!ConstantPO class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id$'
! !

