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

CustomCodeGeneratorOrRefactoringTestCase subclass:#CustomAccessMethodsCodeGeneratorTests
	instanceVariableNames:'expectedSource class'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Generators-Tests'
!

!CustomAccessMethodsCodeGeneratorTests class methodsFor:'documentation'!

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

!CustomAccessMethodsCodeGeneratorTests methodsFor:'accessing'!

generatorOrRefactoring
    | mockClass mockClassInstance |

    mockClass := mock mockClassOf:CustomAccessMethodsCodeGenerator.
    mockClass compileMockMethod: 'description ^ ''some description'' '.

    mockClassInstance := mockClass new.
    mockClassInstance compileMockMethod: 'sourceForClass:aClass variableName:varName
        ^ varName, '' ^ '', varName'.

    ^ mockClassInstance

    "Modified: / 26-09-2014 / 10:54:28 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomAccessMethodsCodeGeneratorTests methodsFor:'tests'!

test_arg_name_for_method_name_boolean
    | actualArgName |

    actualArgName := generatorOrRefactoring argNameForMethodName: 'isSomething'.

    self assert: 'aBoolean' = actualArgName

    "Created: / 04-07-2014 / 12:38:50 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_arg_name_for_method_name_other
    | actualArgName |

    actualArgName := generatorOrRefactoring argNameForMethodName: 'selector'.

    self assert: 'something' = actualArgName

    "Created: / 04-07-2014 / 12:39:48 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_build_in_context_with_none_selected_variable
    | classWithInstVars testCompleted |

    testCompleted := false.
    [ 
        classWithInstVars := self createClass.
        classWithInstVars
            instanceVariableNames: #('instanceVariable_01' 'instanceVariable_02' 'instanceVariable_03');
            compile.

        context selectedClasses: (Array with: classWithInstVars).

        generatorOrRefactoring executeInContext: context.

        self assertMethodCount: 3 inClass: classWithInstVars.

        expectedSource := 'instanceVariable_02 ^ instanceVariable_02'.
        self assertMethodSource: expectedSource atSelector: #instanceVariable_02.

        expectedSource := 'instanceVariable_01 ^ instanceVariable_01'.
        self assertMethodSource: expectedSource atSelector: #instanceVariable_01.

        expectedSource := 'instanceVariable_03 ^ instanceVariable_03'.
        self assertMethodSource: expectedSource atSelector: #instanceVariable_03.

        testCompleted := true.
    ] ensure: [
        self assert: testCompleted
    ].

    "Created: / 20-06-2014 / 20:29:25 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 30-11-2014 / 15:44:11 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_build_in_context_with_one_selected_variable
    | class |

    class := self createClass.
    class
        instanceVariableNames: (Array with: 'instanceVariable_01' with: 'instanceVariable_02' with: 'instanceVariable_03');
        compile.

    context selectedClasses: (Array with: class).
    context selectedVariables: (Array with: 'instanceVariable_02').

    generatorOrRefactoring executeInContext: context.

    self assertMethodCount: 1 inClass: class.

    expectedSource := 'instanceVariable_02 ^ instanceVariable_02'.
    self assertMethodSource: expectedSource atSelector: #instanceVariable_02.

    "Created: / 17-06-2014 / 08:57:28 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 26-09-2014 / 10:57:18 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_build_in_context_with_two_selected_variables
    | class |

    class := self createClass.
    class
        instanceVariableNames: (Array with: 'instanceVariable_01' with: 'instanceVariable_02' with: 'instanceVariable_03');
        compile.

    context selectedClasses: (Array with: class).
    context selectedVariables: (Array with: 'instanceVariable_02' with: 'instanceVariable_01').

    generatorOrRefactoring executeInContext: context.

    self assertMethodCount: 2 inClass: class.

    expectedSource := 'instanceVariable_02 ^ instanceVariable_02'.
    self assertMethodSource: expectedSource atSelector: #instanceVariable_02.

    expectedSource := 'instanceVariable_01 ^ instanceVariable_01'.
    self assertMethodSource: expectedSource atSelector: #instanceVariable_01.

    "Created: / 20-06-2014 / 20:26:02 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 26-09-2014 / 11:03:39 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_default_method_name_for_variable_name
    | actualDefaultMethodName |

    actualDefaultMethodName := generatorOrRefactoring defaultMethodNameFor: 'varName'.

    self assert: 'defaultVarName' = actualDefaultMethodName

    "Created: / 29-06-2014 / 23:33:34 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_method_name_for_all_upper_case
    | actualMethodName |

    actualMethodName := generatorOrRefactoring methodNameFor: 'VAR'.

    self assert: 'VAR' = actualMethodName

    "Created: / 20-06-2014 / 21:11:56 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_method_name_for_class_variable
    | actualMethodName |

    actualMethodName := generatorOrRefactoring methodNameFor: 'ClassVar'.

    self assert: 'classVar' = actualMethodName

    "Created: / 20-06-2014 / 20:36:02 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_method_name_for_instance_variable

    self assert: 'instVar' = (generatorOrRefactoring methodNameFor: 'instVar')

    "Created: / 20-06-2014 / 20:35:22 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_method_name_for_number
    | actualMethodName |

    actualMethodName := generatorOrRefactoring methodNameFor: 'Var_7'.

    self assert: 'var_7' = actualMethodName

    "Created: / 20-06-2014 / 21:13:36 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_var_type_of_class_instance_variable
    | actualVarType |

    class := self createClass theMetaclass.
    class
        instanceVariableNames: (Array with: 'ClassInstVar1' with: 'ClassInstVar2').

    self assert: class isMeta.

    actualVarType := generatorOrRefactoring varTypeOf: 'ClassInstVar2' class: class.

    self assert: 'classInstVar' = actualVarType

    "Created: / 23-06-2014 / 19:27:17 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 26-09-2014 / 21:33:53 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_var_type_of_instance_variable
    | actualVarType |

    class := self createClass.
    class instanceVariableNames: 'instVar1 instVar2'.

    actualVarType := generatorOrRefactoring varTypeOf: 'instVar2' class: class.

    self assert: 'instance' = actualVarType

    "Created: / 23-06-2014 / 19:26:28 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_var_type_of_static
    | actualVarType |

    class := self createClass.
    class classVariableNames: (Array with: 'ClassVar1' with: 'ClassVar2').

    actualVarType := generatorOrRefactoring varTypeOf: 'ClassVar2' class: class.

    self assert: 'static' = actualVarType

    "Created: / 20-06-2014 / 21:22:15 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 26-09-2014 / 21:47:26 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomAccessMethodsCodeGeneratorTests class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

