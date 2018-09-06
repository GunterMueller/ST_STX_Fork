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

CustomCodeGenerator subclass:#CustomJavaSimpleSetterMethodsCodeGenerator
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Generators'
!

!CustomJavaSimpleSetterMethodsCodeGenerator class methodsFor:'documentation'!

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

!CustomJavaSimpleSetterMethodsCodeGenerator class methodsFor:'accessing-presentation'!

description
    "Returns more detailed description of the receiver"

    ^ 'Generates setter methods for instance variables of Java Class'

    "Created: / 01-02-2015 / 20:42:59 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

label
    "Returns show label describing the receiver. This label
     is used in UI as menu item/tree item label."

    ^ 'Setter Method(s)'

    "Created: / 01-02-2015 / 20:43:33 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomJavaSimpleSetterMethodsCodeGenerator class methodsFor:'queries'!

availableForProgrammingLanguages
    "Returns list of programming language instances for which this generator / refactoring works.
    (SmalltalkLanguage instance, JavaLanguage instance, GroovyLanguage instance, etc.)

     See also availableForProgrammingLanguagesInContext:withPerspective:"

    ^ {JavaLanguage instance}

    "Created: / 01-02-2015 / 20:44:19 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

availableInContext: aCustomContext
    "Returns true if the generator/refactoring is available in given
     context, false otherwise.
     
     Called by the UI to figure out what generators / refactorings
     are available at given point. See class CustomContext for details."

    ^ aCustomContext selectedClasses notEmptyOrNil

    "Created: / 01-02-2015 / 20:40:38 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

availableInPerspective: aCustomPerspective
    "Returns true if the generator/refactoring is available in given
     perspective, false otherwise.
     
     Called by the UI to figure out what generators / refactorings
     to show"

    ^ aCustomPerspective isClassPerspective

    "Created: / 01-02-2015 / 20:41:14 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomJavaSimpleSetterMethodsCodeGenerator methodsFor:'executing - private'!

buildInContext: aCustomContext
    "Prototype generator for Java language - proper way should be usage of some Java parser"

    self warn: 'Experimenatal generator, may not work as expected.'.  

    aCustomContext selectedClasses do: [ :class |
        class instanceVariableNames do: [ :varName |
            | setter type newDefinition endOfClass |

            type := (class realClass typeOfField: varName) asString.
            setter := '
    public ', type, ' ', varName, '(', type, ' ', varName, ') {
        this.', varName, ' = ', varName, ';
    }
'.
            newDefinition := class realClass definition.
            endOfClass := newDefinition lastIndexOf: $}.
            newDefinition := (newDefinition copyTo: endOfClass - 1), setter, (newDefinition copyFrom: endOfClass).
            JavaCompiler compile: newDefinition
        ]
    ]

    "Created: / 01-02-2015 / 17:58:54 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 02-02-2015 / 22:20:34 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

