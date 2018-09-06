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

CustomAccessMethodsCodeGenerator subclass:#CustomLazyInitializationGetterMethodsCodeGenerator
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Generators'
!

!CustomLazyInitializationGetterMethodsCodeGenerator class methodsFor:'documentation'!

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

!CustomLazyInitializationGetterMethodsCodeGenerator class methodsFor:'accessing-presentation'!

description
    "Returns more detailed description of the receiver"

    ^ 'Getter methods with Lazy Initialization in Getter for selected instance variables'

    "Created: / 29-06-2014 / 19:12:18 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

group
    "Returns a collection strings describing a group to which
     receiver belongs. A groups may be nested hence the array of
     strings. For example for subgroup 'Accessors' in group 'Generators'
     this method should return #('Generators' 'Accessors')."

    "/ By default return an empty array which means the item will appear
    "/ in top-level group.
    ^ #('Accessors' 'Getters')

    "Created: / 22-08-2014 / 18:56:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

label
    "Returns show label describing the receiver. This label
     is used in UI as menu item/tree item label."

    ^ 'Getter Method(s) with Lazy Initialization'

    "Created: / 29-06-2014 / 19:16:08 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 06-07-2014 / 23:14:30 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomLazyInitializationGetterMethodsCodeGenerator methodsFor:'code generation'!

sourceForClass: aClass variableName: aName
    "Returns getter with lazy initialization method source code for given class and variable name"

    | methodName comment |

    methodName := self methodNameFor: aName.
    comment := ''.

    userPreferences generateCommentsForGetters ifTrue:[
        | varType |

        varType := self varTypeOf: aName class: aClass. 
        comment := '"return the %1 instance variable ''%2'' with lazy instance creation (automatically generated)"'.
        comment := comment bindWith: varType with: aName.
    ].

    ^ self sourceCodeGenerator
        source: '`@methodName
            `"comment

            `variableName isNil ifTrue:[
                `variableName := self class `@defaultMethodName.
            ].
            ^ `variableName';
        replace: '`@methodName' with: methodName asSymbol;
        replace: '`@defaultMethodName' with: (self defaultMethodNameFor: aName) asSymbol;
        replace: '`variableName' with: aName asString;
        replace: '`"comment' with: comment;
        newSource.

    "Created: / 24-06-2014 / 23:24:41 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 19-09-2014 / 22:35:12 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomLazyInitializationGetterMethodsCodeGenerator methodsFor:'executing'!

buildInContext: aCustomContext
    | generator |

    generator := CustomDefaultGetterMethodsCodeGenerator subGeneratorOrRefactoringOf:self.
    generator executeInContext: aCustomContext.

    super buildInContext: aCustomContext

    "Created: / 30-06-2014 / 18:00:47 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

