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

CustomAccessMethodsCodeGenerator subclass:#CustomValueHolderWithChangeNotificationGetterMethodsCodeGenerator
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Generators'
!

!CustomValueHolderWithChangeNotificationGetterMethodsCodeGenerator class methodsFor:'documentation'!

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

!CustomValueHolderWithChangeNotificationGetterMethodsCodeGenerator class methodsFor:'accessing-presentation'!

description

    ^ 'Getter methods with ValueHolder and change notification for selected instance variables'

    "Created: / 30-06-2014 / 19:31:27 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

group
    "Returns a collection strings describing a group to which
     receiver belongs. A groups may be nested hence the array of
     strings. For example for subgroup 'Accessors' in group 'Generators'
     this method should return #('Generators' 'Accessors')."

    "/ By default return an empty array which means the item will appear
    "/ in top-level group.
    ^ #('Accessors' 'Getters')

    "Created: / 22-08-2014 / 18:55:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

label

    ^ 'Getter Method(s) for ValueHolder with Change Notification'

    "Created: / 30-06-2014 / 19:36:20 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomValueHolderWithChangeNotificationGetterMethodsCodeGenerator methodsFor:'accessing'!

protocol
    "Returns protocol name in which will belong getter method"

    ^ 'aspects'

    "Created: / 30-06-2014 / 19:48:14 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomValueHolderWithChangeNotificationGetterMethodsCodeGenerator methodsFor:'code generation'!

sourceForClass: aClass variableName: aName
    "Returns getter method source code with ValueHolder and change notification for given class and variable name"

    | methodName comment |

    methodName := self methodNameFor: aName.
    comment := ''.

    userPreferences generateCommentsForGetters ifTrue:[
        comment := '"return/create the ''%1'' value holder with change notification (automatically generated)"'.
        comment := comment bindWith: aName.
    ].  

    ^ self sourceCodeGenerator
        source: '`@methodName
            `"comment

            `variableName isNil ifTrue:[
                `variableName := ValueHolder new.
                `variableName addDependent: self.
            ].
            ^ `variableName';
        replace: '`@methodName' with: methodName asSymbol;
        replace: '`variableName' with: aName asString;
        replace: '`"comment' with: comment;
        newSource.

    "Created: / 30-06-2014 / 19:18:35 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 19-09-2014 / 22:37:00 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomValueHolderWithChangeNotificationGetterMethodsCodeGenerator class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

