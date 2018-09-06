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

CustomTestCaseCodeGenerator subclass:#CustomCodeGeneratorOrRefactoringTestCaseCodeGenerator
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Generators'
!

!CustomCodeGeneratorOrRefactoringTestCaseCodeGenerator class methodsFor:'documentation'!

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

!CustomCodeGeneratorOrRefactoringTestCaseCodeGenerator class methodsFor:'accessing-presentation'!

description
    ^ 'Creates a new test case for custom code generator/refactoring'

    "Modified: / 23-08-2014 / 19:50:52 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 16-09-2014 / 11:33:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

group
    "Returns a collection strings describing a group to which
     receiver belongs. A groups may be nested hence the array of
     strings. For example for subgroup 'Accessors' in group 'Generators'
     this method should return #('Generators' 'Accessors')."

    "/ By default return an empty array which means the item will appear
    "/ in top-level group.
    ^ #('Generators')

    "Created: / 22-08-2014 / 18:50:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

label
    ^ 'New Code Generator Testcase'

    "Modified: / 23-08-2014 / 19:50:58 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 22-08-2014 / 18:50:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CustomCodeGeneratorOrRefactoringTestCaseCodeGenerator class methodsFor:'queries'!

availableInContext:aCustomContext 
    | classes |

    classes := aCustomContext selectedClasses.
    ^ classes notEmpty 
        and:[ classes allSatisfy: [:e | e inheritsFrom: CustomCodeGeneratorOrRefactoring ] ].

    "Created: / 15-09-2014 / 15:19:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CustomCodeGeneratorOrRefactoringTestCaseCodeGenerator methodsFor:'accessing - defaults'!

defaultTestSuperName
    ^ 'CustomCodeGeneratorOrRefactoringTestCase'

    "Created: / 16-09-2014 / 10:32:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CustomCodeGeneratorOrRefactoringTestCaseCodeGenerator methodsFor:'executing - private'!

generateTestCaseCodeFor:aTestClass forClassUnderTest:aClass 
    | source className package |

    super generateTestCaseCodeFor:aTestClass forClassUnderTest:aClass.
    className := aClass theNonMetaClass name.

    package := PackageId noProjectID.
    samePackageAsTestedClass ifTrue: [ 
        package := aClass package
    ].

    source := 'test_code_generated
    | expectedSource |

    expectedSource := ''instanceVariable
    ^ instanceVariable''.

    self executeGeneratorInContext: #classWithInstanceVariable.
    self assertMethodSource: expectedSource atSelector: #instanceVariable'.

    model createMethod
        class: aTestClass;

        protocol: 'tests';
        source: source;
        package: package;
        compile.

    model createMethod
        class: aTestClass;

        protocol: 'accessing';
        source: 'generatorOrRefactoring
    ^ `className new';
        replace: '`className' with: className asString;
        package: package;
        compile

    "Created: / 16-09-2014 / 10:40:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 31-01-2015 / 18:39:38 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomCodeGeneratorOrRefactoringTestCaseCodeGenerator class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

