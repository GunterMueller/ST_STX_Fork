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

CustomAccessMethodsCodeGenerator subclass:#CustomChangeNotificationSetterMethodsCodeGenerator
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Generators'
!

!CustomChangeNotificationSetterMethodsCodeGenerator class methodsFor:'documentation'!

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

!CustomChangeNotificationSetterMethodsCodeGenerator class methodsFor:'accessing-presentation'!

description
    "Returns more detailed description of the receiver"
    
    ^ 'Setter methods with Change Notification for selected instance variables'

    "Modified: / 06-07-2014 / 13:48:27 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

group
    "Returns a collection strings describing a group to which
     receiver belongs. A groups may be nested hence the array of
     strings. For example for subgroup 'Accessors' in group 'Generators'
     this method should return #('Generators' 'Accessors')."

    "/ By default return an empty array which means the item will appear
    "/ in top-level group.
    ^ #('Accessors' 'Setters')

    "Created: / 22-08-2014 / 18:54:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

label
    "Returns show label describing the receiver. This label
     is used in UI as menu item/tree item label."
    
    ^ 'Setter Method(s) with Change Notification'

    "Modified: / 06-07-2014 / 13:47:01 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomChangeNotificationSetterMethodsCodeGenerator methodsFor:'code generation'!

sourceForClass: aClass variableName: aName
    "Returns setter method with change notification for given class and variable name"

    | methodName comment argName |

    methodName := self methodNameFor: aName.
    argName := self argNameForMethodName: methodName.  
    comment := ''.

    userPreferences generateCommentsForSetters ifTrue:[
        | varType |

        varType := self varTypeOf: aName class: aClass. 
        comment := '"set the value of the %1 variable ''%2'' and send a change notification (automatically generated)"'.
        comment := comment bindWith: varType with: aName.
    ].

    ^ self sourceCodeGenerator
        source: '`@methodName
            `"comment

            (`variableName ~~ `argName) ifTrue:[
                `variableName := `argName.
                self changed: `#variableName.
            ].';
        replace: '`@methodName' with: (methodName, ': ', argName) asSymbol;
        replace: '`argName' with: argName asString;
        replace: '`variableName' with: aName asString;
        replace: '`#variableName' with: ($#, aName asSymbol);
        replace: '`"comment' with: comment;
        newSource.

    "Modified: / 19-09-2014 / 22:16:18 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomChangeNotificationSetterMethodsCodeGenerator class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

