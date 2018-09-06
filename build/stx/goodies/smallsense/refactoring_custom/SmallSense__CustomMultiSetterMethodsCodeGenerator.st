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

CustomAccessMethodsCodeGenerator subclass:#CustomMultiSetterMethodsCodeGenerator
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Generators'
!

!CustomMultiSetterMethodsCodeGenerator class methodsFor:'documentation'!

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

!CustomMultiSetterMethodsCodeGenerator class methodsFor:'accessing-presentation'!

description
    "Returns more detailed description of the receiver"
    
    ^ 'Multi-Setter Method(s) for selected instance variables'

    "Modified: / 13-07-2014 / 19:06:56 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

group
    "Returns a collection strings describing a group to which
     receiver belongs. A groups may be nested hence the array of
     strings. For example for subgroup 'Accessors' in group 'Generators'
     this method should return #('Generators' 'Accessors')."

    "/ By default return an empty array which means the item will appear
    "/ in top-level group.
    ^ #('Accessors' 'Getters')

    "Created: / 22-08-2014 / 18:54:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

label
    "Returns show label describing the receiver. This label
     is used in UI as menu item/tree item label."
    
    ^ 'Multi-Setter Method(s)'

    "Modified: / 13-07-2014 / 19:06:16 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomMultiSetterMethodsCodeGenerator class methodsFor:'queries'!

availableInContext:aCustomContext

    ^ aCustomContext selectedClasses notEmptyOrNil and: [ 
        aCustomContext selectedVariables notEmptyOrNil and: [ 
            aCustomContext selectedVariables size >= 2
        ]
    ]

    "Created: / 13-07-2014 / 19:14:36 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomMultiSetterMethodsCodeGenerator methodsFor:'code generation'!

createMultiSetterMethodForVariables: aVariableNames inClass: aClass
    "Creates multi-setter access method for given variable names and class"

    | setterSelector comment assignVariablesCode |

    setterSelector := ''.
    comment := ''.
    assignVariablesCode := ''.

    userPreferences generateCommentsForSetters ifTrue: [ 
        comment := '"set instance variables"'.
    ].

    aVariableNames do: [ :variableName |
        | argumentName |

        argumentName := variableName asString, 'Arg'.

        setterSelector := setterSelector, variableName asString, ': ', argumentName, ' '.
        assignVariablesCode := assignVariablesCode, variableName asString, ' := ', argumentName, '. '.
    ].

    model createMethod
        class: aClass;
        protocol: 'accessing';
        source: '`@setterSelector
            `"comment

            `@assignVariablesCode
        ';
        replace: '`@setterSelector' with: setterSelector asSymbol;
        replace: '`"comment' with: comment;
        replace: '`@assignVariablesCode' with: assignVariablesCode;
        compile.

    "Created: / 13-07-2014 / 20:45:41 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 08-10-2014 / 19:00:20 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomMultiSetterMethodsCodeGenerator methodsFor:'executing'!

buildInContext: aCustomContext
    "Creates multi-setter access methods for given context"

    aCustomContext selectedClasses do:[ :class | 
        self
            createMultiSetterMethodForVariables: aCustomContext selectedVariables
            inClass: class 
    ].

    "Modified: / 13-07-2014 / 20:45:41 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomMultiSetterMethodsCodeGenerator class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

