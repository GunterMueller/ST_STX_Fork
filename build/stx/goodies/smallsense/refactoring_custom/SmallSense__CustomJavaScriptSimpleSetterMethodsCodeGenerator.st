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

CustomSimpleSetterMethodsCodeGenerator subclass:#CustomJavaScriptSimpleSetterMethodsCodeGenerator
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Generators'
!

!CustomJavaScriptSimpleSetterMethodsCodeGenerator class methodsFor:'documentation'!

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
    Same purpose like superclass, but for STX JavaScript language.

    [author:]
        Jakub Nesveda <nesvejak@fit.cvut.cz>
"
! !

!CustomJavaScriptSimpleSetterMethodsCodeGenerator class methodsFor:'queries'!

availableForProgrammingLanguages

    ^ {STXJavaScriptLanguage instance}

    "Created: / 31-01-2015 / 18:16:04 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomJavaScriptSimpleSetterMethodsCodeGenerator methodsFor:'code generation'!

sourceForClass: aClass variableName: aName
    "Returns simple setter for given STX JavaScript class and variable name."

    | methodName comment argName |

    methodName := aName.
    argName := self argNameForMethodName: methodName.  
    comment := ''.

    userPreferences generateCommentsForSetters ifTrue:[
        | varType |

        varType := self varTypeOf: aName class: aClass. 
        comment := '
    // set the value of the %1 variable ''%2'' (automatically generated)'.
        comment := comment bindWith: varType with: aName.
    ].

    ^ methodName, '(', argName, ') {', comment, '
    ', aName, ' = ', argName, ';
}'.

    "Created: / 31-01-2015 / 18:15:11 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

