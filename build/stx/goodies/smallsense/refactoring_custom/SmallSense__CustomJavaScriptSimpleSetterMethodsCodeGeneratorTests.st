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

CustomCodeGeneratorOrRefactoringTestCase subclass:#CustomJavaScriptSimpleSetterMethodsCodeGeneratorTests
	instanceVariableNames:'javaScriptClass'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Generators-Tests'
!

!CustomJavaScriptSimpleSetterMethodsCodeGeneratorTests class methodsFor:'documentation'!

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

!CustomJavaScriptSimpleSetterMethodsCodeGeneratorTests methodsFor:'accessing'!

generatorOrRefactoring
    ^ CustomJavaScriptSimpleSetterMethodsCodeGenerator new
! !

!CustomJavaScriptSimpleSetterMethodsCodeGeneratorTests methodsFor:'initialization & release'!

setUp
    | classDefinition |

    super setUp.

    classDefinition := 'public class DummyJavaStriptClass01 extends Object {
    var instVar01;
}'.

    Class withoutUpdatingChangesDo: [   
        JavaScriptCompiler evaluate: classDefinition notifying: nil compile: nil
    ].

    javaScriptClass := Smalltalk at: #DummyJavaStriptClass01.

    "Modified: / 01-02-2015 / 16:22:44 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

tearDown

    Class withoutUpdatingChangesDo: [   
        javaScriptClass removeFromSystem
    ].
    "super tearDown."
    "Call of undoing changes produces error relevant
    to parsing JavaScript source code as Smalltalk code."
    "changeManager undoChanges."
    mock unmockAll

    "Modified: / 01-02-2015 / 16:21:27 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomJavaScriptSimpleSetterMethodsCodeGeneratorTests methodsFor:'tests'!

test_simple_setter_generated_with_comment
    | expectedSource |

    userPreferences generateComments: true.

    context selectedClasses: {javaScriptClass}.  

    expectedSource := 'instVar01(something) {
    // set the value of the instance variable ''instVar01'' (automatically generated)
    instVar01 = something;
}'.

    generatorOrRefactoring executeInContext: context.

    self assertMethodSource: expectedSource atSelector: #'instVar01:' forClass: javaScriptClass

    "Created: / 01-02-2015 / 16:24:34 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_simple_setter_generated_without_comment
    | expectedSource |

    userPreferences generateComments: false.

    context selectedClasses: {javaScriptClass}.  

    expectedSource := 'instVar01(something) {
    instVar01 = something;
}'.

    generatorOrRefactoring executeInContext: context.

    self assertMethodSource: expectedSource atSelector: #'instVar01:' forClass: javaScriptClass

    "Created: / 01-02-2015 / 16:26:05 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

