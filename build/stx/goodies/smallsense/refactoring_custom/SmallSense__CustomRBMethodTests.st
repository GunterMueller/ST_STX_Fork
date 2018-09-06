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

Smalltalk::TestCase subclass:#CustomRBMethodTests
	instanceVariableNames:'rbMethod mock model'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Tests'
!

!CustomRBMethodTests class methodsFor:'documentation'!

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

!CustomRBMethodTests methodsFor:'initialization & release'!

setUp

    mock := CustomMock new.
    rbMethod := mock mockOf: RBMethod.
    model := RBNamespace new.
    rbMethod model: model.

    "Created: / 30-09-2014 / 19:36:05 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 06-10-2014 / 07:38:49 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

tearDown

    mock unmockAll

    "Created: / 30-09-2014 / 19:44:27 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomRBMethodTests methodsFor:'tests'!

test_category_custom_set
    | expectedCategory actualCategory |

    expectedCategory := 'test category'.

    rbMethod category: expectedCategory. 
    actualCategory := rbMethod category.

    self assert: expectedCategory = actualCategory

    "Created: / 06-10-2014 / 08:11:36 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_category_empty
    | expectedCategory actualCategory |

    expectedCategory := 'as yet unclassified'.

    "actually we need to set model class with real class
    and selector or source to retrieve 'as yet unclassified' category/protocol"
    rbMethod
        modelClass: (model classNamed: #Object);
        selector: #someSelector.
    actualCategory := rbMethod category.

    self assert: expectedCategory = actualCategory

    "Created: / 06-10-2014 / 08:12:16 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_category_empty_with_none_class
    | expectedCategory actualCategory |

    expectedCategory := 'as yet unclassified'.

    actualCategory := rbMethod category.

    self assert: expectedCategory = actualCategory

    "Created: / 08-10-2014 / 18:40:37 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_category_from_compiled_method
    | expectedCategory actualCategory |

    expectedCategory := 'tests'.

    rbMethod method: (self class compiledMethodAt: #test_category_from_compiled_method).
    actualCategory := rbMethod category.

    self assert: expectedCategory = actualCategory

    "Created: / 06-10-2014 / 08:20:43 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_category_from_real_class
    | expectedCategory actualCategory |

    expectedCategory := 'tests'.

    rbMethod
        class: self class;
        selector: #test_category_from_real_class.

    actualCategory := rbMethod category.

    self assert: expectedCategory = actualCategory

    "Created: / 06-10-2014 / 08:21:29 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_class_for_model_class
    | expectedModelClass actualModelClass |

    expectedModelClass := RBClass new.

    rbMethod class: expectedModelClass. 
    actualModelClass := rbMethod modelClass.

    self assert: expectedModelClass = actualModelClass

    "Created: / 06-10-2014 / 07:36:05 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_class_for_real_class
    | expectedModelClass actualModelClass |

    expectedModelClass := model classNamed: #Object.

    rbMethod class: Object. 
    actualModelClass := rbMethod modelClass.

    self assert: expectedModelClass = actualModelClass

    "Created: / 06-10-2014 / 07:36:35 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_class_for_real_metaclass
    | expectedModelClass actualModelClass |

    expectedModelClass := model metaclassNamed: #Object.

    rbMethod class: Object class. 
    actualModelClass := rbMethod modelClass.

    self assert: expectedModelClass = actualModelClass

    "Created: / 06-10-2014 / 07:42:19 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_compile_with_code_generator
    | actualMethod generator class source expectedSource actualSource |

    generator := CustomSourceCodeGenerator new
        formatter: CustomNoneSourceCodeFormatter new;
        yourself.

    class := RBClass new
        name: #SomeTestClass;
        model: model;
        superclassName: #Object;
        yourself.

    actualMethod := class compiledMethodAt: #selector_01.
    self assert: actualMethod isNil. 

    source := 'selector_01
    "Comment"

    `variable := 500.
    ^ `variable'.

    expectedSource := 'selector_01
    "Comment"

    variableName := 500.
    ^ variableName'.

    rbMethod
        class: class;
        sourceCodeGenerator: generator;
        source: source;
        replace: '`variable' with: 'variableName';
        protocol: 'test protocol';
        compile.

    actualMethod := class compiledMethodAt: #selector_01.
    actualSource := actualMethod source.

    self assert: actualSource = expectedSource.
    self assert: (actualMethod protocol) = (rbMethod protocol)

    "Created: / 06-10-2014 / 22:45:23 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 10-10-2014 / 15:14:51 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_compile_with_custom_package
    | actualMethod class change |

    class := RBClass new
        name: #SomeTestClass;
        model: model;
        superclassName: #Object;
        yourself.

    actualMethod := class compiledMethodAt: #selector_01.
    self assert: actualMethod isNil. 

    change := rbMethod
        class: class;
        source: 'selector_01 ^ 12';
        protocol: 'test protocol';
        package: 'my_package';
        compile.

    actualMethod := class compiledMethodAt: #selector_01.

    self assert: (actualMethod source) = (rbMethod source).
    self assert: (actualMethod protocol) = (rbMethod protocol).
    self assert: (actualMethod package) = (rbMethod package).

    self assert: (change source) = (rbMethod source).
    self assert: (change protocol) = (rbMethod protocol).
    self assert: (change package) = (rbMethod package).

    "Created: / 10-10-2014 / 11:25:45 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_compile_without_code_generator
    | actualMethod class |

    class := RBClass new
        name: #SomeTestClass;
        model: model;
        superclassName: #Object;
        yourself.

    actualMethod := class compiledMethodAt: #selector_01.
    self assert: actualMethod isNil. 

    rbMethod
        class: class;
        source: 'selector_01 ^ 12';
        protocol: 'test protocol';
        compile.

    actualMethod := class compiledMethodAt: #selector_01.

    self assert: (actualMethod source) = (rbMethod source).
    self assert: (actualMethod protocol) = (rbMethod protocol)

    "Created: / 06-10-2014 / 21:11:48 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 06-10-2014 / 22:33:44 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_compile_without_custom_package
    | actualMethod class change |

    class := RBClass new
        name: #SomeTestClass;
        model: model;
        superclassName: #Object;
        yourself.

    actualMethod := class compiledMethodAt: #selector_01.
    self assert: actualMethod isNil. 

    change := rbMethod
        class: class;
        source: 'selector_01 ^ 12';
        protocol: 'test protocol';
        compile.

    actualMethod := class compiledMethodAt: #selector_01.

    self assert: (actualMethod source) = (rbMethod source).
    self assert: (actualMethod protocol) = (rbMethod protocol).
    self assert: (actualMethod package) = (rbMethod package).

    self assert: (change source) = (rbMethod source).
    self assert: (change protocol) = (rbMethod protocol).
    self assert: (change package) = (rbMethod package).

    "Created: / 10-10-2014 / 11:51:51 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_compiled_method_empty
    | expectedMethod actualMethod |

    expectedMethod := nil.
    actualMethod := rbMethod method.

    self assert: expectedMethod = actualMethod

    "Created: / 08-10-2014 / 19:27:27 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_compiled_method_for_real_method
    | expectedMethod actualMethod |

    expectedMethod := self class compiledMethodAt: #test_compiled_method_for_real_method.

    rbMethod := RBMethod 
        for: RBClass new 
        fromMethod: expectedMethod 
        andSelector: #test_compiled_method_for_real_method.

    actualMethod := rbMethod method.

    self assert: expectedMethod = actualMethod

    "Created: / 08-10-2014 / 19:30:55 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_compiled_method_for_real_method_empty
    | expectedMethod actualMethod |

    expectedMethod := self class compiledMethodAt: #test_compiled_method_for_real_method.

    rbMethod 
        modelClass: (RBClass existingNamed: self className asSymbol); 
        selector: #test_compiled_method_for_real_method.

    actualMethod := rbMethod method.

    self assert: expectedMethod = actualMethod

    "Created: / 08-10-2014 / 19:32:38 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_compiled_method_when_selector_empty
    | expectedMethod actualMethod |

    expectedMethod := nil.

    rbMethod 
        modelClass: (RBClass existingNamed: self className asSymbol);
        source: 'selector_01 ^ 1'.

    actualMethod := rbMethod method.

    self assert: expectedMethod = actualMethod

    "Created: / 08-10-2014 / 19:36:21 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_mclass
    | expectedClass actualClass |

    expectedClass := RBClass new. 
    rbMethod modelClass: expectedClass.

    actualClass := rbMethod mclass.

    self assert: expectedClass = actualClass

    "Created: / 25-11-2014 / 22:27:03 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 27-11-2014 / 23:18:39 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_method_arg_names_none_arg
    | expectedArguments actualArguments |

    expectedArguments := nil.

    rbMethod source: 'selector ^ 5'. 
    actualArguments := rbMethod methodArgNames.

    self assert: expectedArguments = actualArguments

    "Created: / 07-10-2014 / 21:39:24 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_method_arg_names_one_arg
    | expectedArguments actualArguments |

    expectedArguments := #('arg_01').

    rbMethod source: 'selector: arg_01 ^ 5'. 
    actualArguments := rbMethod methodArgNames.

    self assert: expectedArguments = actualArguments

    "Created: / 07-10-2014 / 21:39:56 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_method_arg_names_two_args
    | expectedArguments actualArguments |

    expectedArguments := #('arg_01' 'arg_02').

    rbMethod source: 'selector: arg_01 param: arg_02 ^ 5'. 
    actualArguments := rbMethod methodArgNames.

    self assert: expectedArguments = actualArguments

    "Created: / 07-10-2014 / 21:57:02 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_method_definition_template_none_arg
    | expectedMethodDefinition actualMethodDefinition |

    expectedMethodDefinition := 'selector'.

    rbMethod source: 'selector ^ 5'. 
    actualMethodDefinition := rbMethod methodDefinitionTemplate.

    self assert: expectedMethodDefinition = actualMethodDefinition

    "Created: / 07-10-2014 / 22:32:06 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_method_definition_template_two_args
    | expectedMethodDefinition actualMethodDefinition |

    expectedMethodDefinition := 'selector:arg_01 param:arg_02'.

    rbMethod source: 'selector: arg_01 param: arg_02 ^ 5'. 
    actualMethodDefinition := rbMethod methodDefinitionTemplate.

    self assert: expectedMethodDefinition = actualMethodDefinition

    "Created: / 07-10-2014 / 22:24:29 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_new_source_code_generator_with_replacements
    | expectedSource actualSource |

    expectedSource := 'selector_01 ^ 1'.
    rbMethod
        source: 'selector_01 ^ `#literal';
        sourceCodeGenerator: ( CustomSourceCodeGenerator new
            formatter: CustomNoneSourceCodeFormatter new;
            yourself);
        replace: '`#literal' with: '1'.

    actualSource := rbMethod newSource.

    self assert: expectedSource = actualSource

    "Created: / 10-10-2014 / 15:12:35 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_new_source_none_code_generator
    | expectedSource actualSource |

    expectedSource := 'selector_01 ^ 1'.
    rbMethod source: 'selector_01 ^ 1'.

    actualSource := rbMethod newSource.

    self assert: expectedSource = actualSource

    "Created: / 10-10-2014 / 14:43:33 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_new_source_some_code_generator
    | expectedSource actualSource |

    expectedSource := 'selector_01 ^ 1'.
    rbMethod
        source: 'selector_01 ^ 1';
        sourceCodeGenerator: ( CustomSourceCodeGenerator new
            formatter: CustomNoneSourceCodeFormatter new;
            yourself).

    actualSource := rbMethod newSource.

    self assert: expectedSource = actualSource

    "Created: / 10-10-2014 / 15:10:16 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_package_custom
    | expectedPackage actualPackage |

    expectedPackage := 'some_package'.

    rbMethod package: 'some_package'.    
    actualPackage := rbMethod package. 

    self assert: expectedPackage = actualPackage

    "Created: / 10-10-2014 / 11:20:58 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_package_empty
    | expectedPackage actualPackage |

    expectedPackage := PackageId noProjectID.
    actualPackage := rbMethod package. 

    self assert: expectedPackage = actualPackage

    "Created: / 10-10-2014 / 11:16:35 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_package_from_real_method
    | expectedPackage actualPackage |

    expectedPackage := self class package.

    self assert: expectedPackage size > 3.

    rbMethod method: (self class compiledMethodAt: #test_package_from_real_method).    
    actualPackage := rbMethod package. 

    self assert: expectedPackage = actualPackage

    "Created: / 10-10-2014 / 11:16:56 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_programming_language_default
    | expectedLanguage actualLanguage |

    expectedLanguage := SmalltalkLanguage instance.
    actualLanguage := rbMethod programmingLanguage.

    self assert: expectedLanguage = actualLanguage

    "Created: / 26-12-2014 / 12:17:36 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_programming_language_from_real_class
    | expectedLanguage actualLanguage |

    expectedLanguage := JavaLanguage instance.
    rbMethod modelClass: (RBClass new realClass: JavaClass new; yourself).
    actualLanguage := rbMethod programmingLanguage.

    self assert: expectedLanguage = actualLanguage

    "Created: / 26-12-2014 / 12:59:00 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_programming_language_from_real_method
    | expectedLanguage actualLanguage |

    expectedLanguage := JavaLanguage instance.
    rbMethod method: (JavaMethod new mclass: JavaClass new; yourself).
    actualLanguage := rbMethod programmingLanguage.

    self assert: expectedLanguage = actualLanguage

    "Created: / 26-12-2014 / 12:23:20 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_real_method_arg_names_none_arg
    "to check what Method >> methodArgNames returns"

    | expectedArguments actualArguments class method |

    class := mock mockClassOf: Object.  
    class new compileMockMethod: 'selector ^ 5'.
    method := class compiledMethodAt: #selector.  

    expectedArguments := nil.
    actualArguments := method methodArgNames.

    self assert: expectedArguments = actualArguments

    "Created: / 07-10-2014 / 21:41:58 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_real_method_arg_names_one_arg
    "to check what Method >> methodArgNames returns"

    | expectedArguments actualArguments class method |

    class := mock mockClassOf: Object.  
    class new compileMockMethod: 'selector: arg_01 ^ 5'.
    method := class compiledMethodAt: #selector:.  

    expectedArguments := #('arg_01').
    actualArguments := method methodArgNames.

    self assert: expectedArguments = actualArguments

    "Created: / 07-10-2014 / 21:53:00 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_real_method_arg_names_two_args
    "to check what Method >> methodArgNames returns"

    | expectedArguments actualArguments class method |

    class := mock mockClassOf: Object.  
    class new compileMockMethod: 'selector: arg_01 param: arg_02 ^ 5'.
    method := class compiledMethodAt: #selector:param:.  

    expectedArguments := #('arg_01' 'arg_02').
    actualArguments := method methodArgNames.

    self assert: expectedArguments = actualArguments

    "Created: / 07-10-2014 / 21:55:50 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_selector_empty
    | expectedSelector actualSelector |

    expectedSelector := nil.
    actualSelector := rbMethod selector.

    self assert: expectedSelector = actualSelector

    "Created: / 26-12-2014 / 13:33:05 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_selector_empty_for_empty_source
    | expectedSelector actualSelector |

    expectedSelector := nil.
    rbMethod source: ''.
    actualSelector := rbMethod selector.

    self assert: expectedSelector = actualSelector

    "Created: / 26-12-2014 / 13:33:54 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_selector_from_source
    | expectedSelector actualSelector |

    expectedSelector := #selector_01.
    rbMethod source: 'selector_01 ^ 1'.
    actualSelector := rbMethod selector.

    self assert: expectedSelector = actualSelector

    "Created: / 26-12-2014 / 13:37:37 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_selector_set
    | expectedSelector actualSelector |

    expectedSelector := #selector_01.
    rbMethod selector: expectedSelector.
    actualSelector := rbMethod selector.

    self assert: expectedSelector = actualSelector

    "Created: / 26-12-2014 / 13:39:32 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_sends_literal_or_sends_another_literal_first

    rbMethod source: 'selector ^ self subclassResponsibility'.  

    self assert: (rbMethod sends:#subclassResponsibility or:#subclassResponsibility:)

    "Created: / 03-10-2014 / 20:14:19 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_sends_literal_or_sends_another_literal_second

    rbMethod source: 'selector
    "comment"

    ^ self subclassResponsibility: #arg.'.  

    self assert: (rbMethod sends:#subclassResponsibility or:#subclassResponsibility:)

    "Created: / 04-10-2014 / 00:03:41 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_sends_literal_or_sends_another_with_real_method
    | someObject |

    someObject := mock mockOf: Object.
    someObject compileMockMethod: 'selector_01
    "comment"

    ^ self subclassResponsibility: #arg.'.

    self assert: ((someObject class compiledMethodAt: #selector_01) isKindOf: CompiledCode).

    rbMethod := RBMethod 
        for: (RBClass existingNamed: someObject className asSymbol)   
        fromMethod: (someObject class compiledMethodAt: #selector_01) 
        andSelector: #selector_01. 


    self assert: (rbMethod sends:#subclassResponsibility or:#subclassResponsibility:)

    "Created: / 04-10-2014 / 00:05:09 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomRBMethodTests class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

