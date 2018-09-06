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

CustomAccessMethodsCodeGenerator subclass:#CustomDefaultGetterMethodsCodeGenerator
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Generators'
!

!CustomDefaultGetterMethodsCodeGenerator class methodsFor:'documentation'!

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

!CustomDefaultGetterMethodsCodeGenerator class methodsFor:'accessing-presentation'!

description

    ^ 'Getter methods for default variable value in metaclass'

    "Created: / 30-06-2014 / 11:14:23 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

group
    "Returns a collection strings describing a group to which
     receiver belongs. A groups may be nested hence the array of
     strings. For example for subgroup 'Accessors' in group 'Generators'
     this method should return #('Generators' 'Accessors')."

    "/ By default return an empty array which means the item will appear
    "/ in top-level group.
    ^ #('Accessors' 'Getters')

    "Created: / 22-08-2014 / 18:54:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

label

    ^ 'Getter Method(s) for default variable value'

    "Created: / 30-06-2014 / 11:15:07 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomDefaultGetterMethodsCodeGenerator methodsFor:'code generation'!

sourceForClass: aClass variableName: aName
    "Returns getter method source code for default variable value"

    | comment |

    comment := ''.

    userPreferences generateCommentsForGetters ifTrue:[
        comment := '"default value for the ''%1'' instance variable (automatically generated)"'.
        comment := comment bindWith: aName.
    ].

    ^ self sourceCodeGenerator
        source: '`@methodName
            `"comment

            self shouldImplement.
            ^ nil';
        replace: '`@methodName' with: (self defaultMethodNameFor: aName) asSymbol;
        replace: '`"comment' with: comment;
        newSource.

    "Created: / 30-06-2014 / 10:49:03 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 19-09-2014 / 22:34:45 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomDefaultGetterMethodsCodeGenerator methodsFor:'protected'!

methodClass: aClass
    "Assure that method is generated only for metaclass."

    ^ aClass theMetaclass

    "Created: / 30-06-2014 / 11:11:00 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomDefaultGetterMethodsCodeGenerator class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

