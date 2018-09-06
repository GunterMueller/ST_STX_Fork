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

CustomAccessMethodsCodeGenerator subclass:#CustomSimpleGetterMethodsCodeGenerator
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Generators'
!

!CustomSimpleGetterMethodsCodeGenerator class methodsFor:'documentation'!

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

!CustomSimpleGetterMethodsCodeGenerator class methodsFor:'accessing-presentation'!

description

    ^ 'Getter methods for selected instance variables'

    "Modified: / 11-05-2014 / 16:37:33 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

group
    "Returns a collection strings describing a group to which
     receiver belongs. A groups may be nested hence the array of
     strings. For example for subgroup 'Accessors' in group 'Generators'
     this method should return #('Generators' 'Accessors')."

    "/ By default return an empty array which means the item will appear
    "/ in top-level group.
    ^ #('Accessors' 'Getters')

    "Created: / 22-08-2014 / 18:56:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

label

    ^ 'Getter Method(s)'

    "Modified (format): / 11-05-2014 / 16:29:56 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomSimpleGetterMethodsCodeGenerator methodsFor:'code generation'!

sourceForClass: aClass variableName: aName
    "Returns simple getter method source code for given class and variable name"

    | methodName comment |

    methodName := self methodNameFor: aName.
    comment := ''.

    userPreferences generateCommentsForGetters ifTrue:[
        | varType |

        varType := self varTypeOf: aName class: aClass.
        comment := '"return the %1 variable ''%2'' (automatically generated)"'.
        comment := comment bindWith: varType with: aName.
    ].  

    ^ self sourceCodeGenerator
        source: '`@methodName
        `"comment

        ^ `variableName';
        replace: '`@methodName' with: methodName asSymbol;
        replace: '`variableName' with: aName asString;
        replace: '`"comment' with: comment;
        newSource.

    "Created: / 19-05-2014 / 20:32:34 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 19-09-2014 / 22:35:39 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

