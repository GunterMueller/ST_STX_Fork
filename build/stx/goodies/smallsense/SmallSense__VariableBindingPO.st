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

PO subclass:#VariableBindingPO
	instanceVariableNames:'binding'
	classVariableNames:''
	poolDictionaries:''
	category:'SmallSense-Java-Interface-PO'
!

!VariableBindingPO class methodsFor:'documentation'!

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

!VariableBindingPO methodsFor:'accessing'!

binding
    ^ binding
!

binding:b
    binding := b.
!

label
    "Return a text to be displayed. The label may be cached
     `label` instvar."

    ^ binding name

    "Created: / 14-08-2014 / 09:02:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

stringToCompleteForLanguage:aProgrammingLanguage
    "Answers a string to complete"

    ^ binding name

    "Created: / 14-08-2014 / 09:02:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VariableBindingPO methodsFor:'testing'!

isSmallSenseVariableBindingPO
    ^ true

    "Created: / 14-08-2014 / 09:01:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

