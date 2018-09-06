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

CustomCodeSelectionRefactoring subclass:#CustomCodeSelectionToResourceTranslation
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Refactorings'
!

!CustomCodeSelectionToResourceTranslation class methodsFor:'documentation'!

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
!

documentation
"
    Wraps variable, literal, string or expression code selection
    with following translation call: resources string:'Some string...'
    Ie.: when 'Some string...' is selected in the code editor then its
    replaced by: resources string:'Some string...'

    [author:]
        Jakub Nesveda <nesvejak@fit.cvut.cz>

"
! !

!CustomCodeSelectionToResourceTranslation class methodsFor:'accessing-presentation'!

description
    "Returns more detailed description of the receiver"

    ^ 'Wrap code selection with translation call - resources string:'

    "Created: / 21-08-2014 / 23:46:18 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

label
    "Returns show label describing the receiver. This label
     is used in UI as menu item/tree item label."

    ^ 'Selection to Resources Translation'

    "Created: / 21-08-2014 / 23:43:03 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomCodeSelectionToResourceTranslation methodsFor:'executing'!

buildInContext:aCustomContext
    "Performs a refactoring within given context scope"

    refactoryBuilder 
          replace:'`@expression'
          with:'(resources string: (`@expression))'
          inContext:aCustomContext

    "Created: / 23-08-2014 / 00:16:58 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 05-11-2014 / 22:57:44 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomCodeSelectionToResourceTranslation class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

