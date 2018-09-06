"
A custom code generation and refactoring support for Smalltalk/X
Copyright (C) 2013-2015 Jakub Nesveda
Copyright (C) 2015 Jan Vrany

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
"{ Package: 'stx:goodies/smallsense/refactoring_custom' }"

"{ NameSpace: SmallSense }"

CustomNewClassGenerator subclass:#CustomCodeGeneratorClassGenerator
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Generators'
!

!CustomCodeGeneratorClassGenerator class methodsFor:'documentation'!

copyright
"
A custom code generation and refactoring support for Smalltalk/X
Copyright (C) 2013-2015 Jakub Nesveda
Copyright (C) 2015 Jan Vrany

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

!CustomCodeGeneratorClassGenerator class methodsFor:'accessing-presentation'!

description
    "Returns more detailed description of the receiver"

    ^ 'Generates template class for code generator'

    "Modified: / 29-03-2014 / 19:38:48 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

group
    "Returns a collection strings describing a group to which
     receiver belongs. A groups may be nested hence the array of
     strings. For example for subgroup 'Accessors' in group 'Generators'
     this method should return #('Generators' 'Accessors')."

    "/ By default return an empty array which means the item will appear
    "/ in top-level group.
    ^ #(Generators)

    "Created: / 22-08-2014 / 18:48:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

label
    "Returns show label describing the receiver. This label
     is used in UI as menu item/tree item label."

    ^ 'New Code Generator'

    "Modified: / 29-03-2014 / 19:21:56 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 22-08-2014 / 18:50:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CustomCodeGeneratorClassGenerator methodsFor:'accessing - ui'!

defaultClassName

    ^ 'CustomXXXCodeGenerator'

    "Created: / 09-11-2014 / 01:13:37 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

newClassNameLabel

    ^ 'Enter class name for new generator'

    "Created: / 09-11-2014 / 01:14:04 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomCodeGeneratorClassGenerator methodsFor:'executing - private'!

buildForClass: aClass

    aClass
        superclassName: #'SmallSense::CustomCodeGenerator';
        category: self class category.

    "Created: / 09-11-2014 / 01:15:04 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 12-06-2015 / 20:55:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CustomCodeGeneratorClassGenerator class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

