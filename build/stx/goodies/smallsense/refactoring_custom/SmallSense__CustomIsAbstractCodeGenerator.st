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

CustomCodeGenerator subclass:#CustomIsAbstractCodeGenerator
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Generators'
!

!CustomIsAbstractCodeGenerator class methodsFor:'documentation'!

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

!CustomIsAbstractCodeGenerator class methodsFor:'accessing-presentation'!

description
    "Returns more detailed description of the receiver"

    ^ 'Mark class as abstract (by implementing class method #isAbstract)'

    "Created: / 20-03-2014 / 01:31:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

label
    "Returns show label describing the receiver. This label
     is used in UI as menu item/tree item label."

    ^ 'Mark class as abstract'

    "Created: / 20-03-2014 / 01:32:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CustomIsAbstractCodeGenerator class methodsFor:'queries'!

availableInContext:aCustomContext
    "Returns true if the generator/refactoring is available in given
     context, false otherwise.
     
     Called by the UI to figure out what generators / refactorings
     are available at given point. See class CustomContext for details."

    ^ aCustomContext selectedClasses notEmptyOrNil

    "Created: / 20-03-2014 / 01:34:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

availableInPerspective:aCustomPerspective
    "Returns true if the generator/refactoring is available in given
     perspective, false otherwise.
     
     Called by the UI to figure out what generators / refactorings
     to show"

    ^ aCustomPerspective isClassPerspective

    "Created: / 20-03-2014 / 01:33:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CustomIsAbstractCodeGenerator methodsFor:'executing'!

buildInContext:aCustomContext
    | classes |

    classes := aCustomContext selectedClasses.
    classes do:[:class |
        | metaclass className |

        metaclass := class theMetaclass.
        className := class theNonMetaclass name.

        (metaclass includesSelector: #isAbstract) ifFalse:[  
            self compile: ('isAbstract
    ^ self == %1' bindWith: className) forClass: metaclass inCategory: 'testing'
        ].   
    ]

    "Created: / 16-09-2014 / 07:20:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-11-2014 / 17:23:31 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

