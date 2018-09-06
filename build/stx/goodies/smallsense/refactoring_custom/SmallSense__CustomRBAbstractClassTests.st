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

Smalltalk::TestCase subclass:#CustomRBAbstractClassTests
	instanceVariableNames:'rbClass mock model'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Tests'
!

!CustomRBAbstractClassTests class methodsFor:'documentation'!

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
    Test extensions in RBAbstractClass.

    [author:]
        Jakub Nesveda <nesvejak@fit.cvut.cz>

"
! !

!CustomRBAbstractClassTests methodsFor:'initialization & release'!

setUp

    mock := CustomMock new.
    model := CustomNamespace new.
    model changeManager: CustomLocalChangeManager new.  
    rbClass := mock mockOf: RBAbstractClass.
    rbClass model: model.

    "Created: / 30-09-2014 / 19:36:05 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 02-02-2015 / 22:43:13 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

tearDown

    model changeManager undoChanges.
    mock unmockAll

    "Created: / 30-09-2014 / 19:44:27 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 02-02-2015 / 22:43:57 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomRBAbstractClassTests methodsFor:'tests'!

test_all_class_var_names_empty
    | expectedClassVars actualClassVars |

    rbClass compileMockMethod: 'allClassVariableNames ^ nil'.  

    expectedClassVars := #().
    actualClassVars := rbClass allClassVarNames.
    
    self assert: expectedClassVars = actualClassVars

    "Created: / 30-09-2014 / 19:40:31 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_all_class_var_names_not_empty
    | expectedClassVars actualClassVars |

    rbClass compileMockMethod: 'allClassVariableNames ^ #(''C1'' ''C2'')'.  

    expectedClassVars := #('C1' 'C2').
    actualClassVars := rbClass allClassVarNames.
    
    self assert: expectedClassVars = actualClassVars

    "Created: / 30-09-2014 / 19:47:13 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_all_superclasses_do_for_object
    | expectedClassNames actualClassNames |

    rbClass := model classNamed: #Object.  

    expectedClassNames := OrderedCollection new.
    actualClassNames := OrderedCollection new.
    rbClass allSuperclassesDo: [ :class |
        actualClassNames add: class name
    ].

    self assert: expectedClassNames = actualClassNames

    "Created: / 04-10-2014 / 13:21:42 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 04-10-2014 / 23:29:49 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_all_superclasses_do_for_object_superclass
    | expectedClassNames actualClassNames |

    rbClass 
        name: #SomeClass;
        superclass: (model classNamed: #Object).  

    expectedClassNames := OrderedCollection new add: #Object; yourself.
    actualClassNames := OrderedCollection new.
    rbClass allSuperclassesDo: [ :class |
        actualClassNames add: class name
    ].

    self assert: expectedClassNames = actualClassNames

    "Created: / 04-10-2014 / 23:28:42 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_all_superclasses_do_with_real_class
    | expectedClassNames actualClassNames realClass |

    "This actually creates realclass"
    realClass := mock mockClassOf: Object.

    rbClass 
        name: #SomeClass;
        superclass: (model classNamed: realClass name asSymbol).  

    expectedClassNames := OrderedCollection new 
        add: realClass name asSymbol;
        add: #Object;
        yourself.

    actualClassNames := OrderedCollection new.
    rbClass allSuperclassesDo: [ :class |
        actualClassNames add: class name
    ].

    self assert: expectedClassNames = actualClassNames

    "Created: / 04-10-2014 / 23:44:22 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_all_superclasses_do_with_two_superclasses
    | expectedClassNames actualClassNames superclass |

    superclass := RBClass new 
        name: #SomeClass_01;
        superclass: (model classNamed: #Object);
        yourself.

    rbClass 
        name: #SomeClass_02;
        superclass: superclass.  

    expectedClassNames := OrderedCollection new 
        add: #SomeClass_01;
        add: #Object;
        yourself.

    actualClassNames := OrderedCollection new.
    rbClass allSuperclassesDo: [ :class |
        actualClassNames add: class name
    ].

    self assert: expectedClassNames = actualClassNames

    "Created: / 04-10-2014 / 23:38:04 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_compile_method_with_all_filled
    | method compiledMethod change |

    rbClass compileMockMethod: 'isMeta ^ false'.

    method := RBMethod new
        source: 'selector_01 ^ `#literal';
        protocol: 'a test protocol';
        package: 'some_package';
        model: model;
        class: self class;
        method: (self class compiledMethodAt: #test_compile_method_with_all_filled);
        sourceCodeGenerator: (CustomSourceCodeGenerator new
            formatter: CustomNoneSourceCodeFormatter new;
            yourself);
        replace: '`#literal' with: '1';
        selector: #selector_01;
        yourself.

    change := rbClass compileMethod: method.

    self assert: (rbClass includesSelector: #selector_01).

    self assert: 'a test protocol' = (change protocol).
    self assert: 'some_package' = (change package).
    self assert: 'selector_01 ^ 1' = (change source).

    compiledMethod := rbClass compiledMethodAt: #selector_01.

    self assert: 'a test protocol' = (compiledMethod protocol).
    self assert: 'some_package' = (compiledMethod package).
    self assert: 'selector_01 ^ 1' = (compiledMethod source).

    "Created: / 10-10-2014 / 12:17:15 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_compile_method_with_real_method
    | method compiledMethod realMethod change class |

    rbClass compileMockMethod: 'isMeta ^ false'.

    class := mock mockClassOf: Object.
    class new compileMockMethod: 'selector_01 ^ 1'.
    realMethod := class compiledMethodAt: #selector_01.  

    method := RBMethod 
        for: rbClass 
        fromMethod: realMethod
        andSelector: #selector_01.

    change := rbClass compileMethod: method.

    self assert: (rbClass includesSelector: #selector_01).

    self assert: (realMethod category) = (change protocol).
    self assert: (realMethod package) = (change package).
    self assert: 'selector_01 ^ 1' = (change source).

    compiledMethod := rbClass compiledMethodAt: #selector_01.

    self assert: (realMethod category) = (compiledMethod protocol).
    self assert: (realMethod package) = (compiledMethod package).
    self assert: 'selector_01 ^ 1' = (compiledMethod source).

    "Created: / 10-10-2014 / 13:20:44 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_compile_method_with_source
    | method change expectedSource actualSource |

    rbClass compileMockMethod: 'isMeta ^ false'.

    method := RBMethod new
        source: 'selector_01 ^ 1';
        yourself.

    expectedSource := 'selector_01 ^ 1'.
    change := rbClass compileMethod: method.

    self assert: expectedSource = (change source).

    actualSource := (rbClass compiledMethodAt: #selector_01) source.

    self assert: expectedSource = actualSource

    "Created: / 10-10-2014 / 11:56:52 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_compiler_class_default
    
    self assert: Compiler == (rbClass compilerClass)

    "Created: / 16-11-2014 / 16:44:26 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_compiler_class_java
    | expectedCompiler actualCompiler |

    rbClass realClass: JavaLanguage new.

    expectedCompiler := JavaCompiler ? JavaCompilerForSmalltalkExtensionsOnly.
    actualCompiler := rbClass compilerClass.
    
    self assert: expectedCompiler = actualCompiler

    "Created: / 16-11-2014 / 16:45:33 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_compiler_class_javascript
    | expectedCompiler actualCompiler |

    rbClass realClass: STXJavaScriptLanguage new.

    expectedCompiler := JavaScriptCompiler.
    actualCompiler := rbClass compilerClass.
    
    self assert: expectedCompiler = actualCompiler

    "Created: / 16-11-2014 / 16:54:54 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_compiler_class_smalltalk

    rbClass realClass: self class.
    
    self assert: Compiler == (rbClass compilerClass)

    "Created: / 16-11-2014 / 16:44:54 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_compiler_class_with_empty_real_class
    | expectedCompiler actualCompiler |

    expectedCompiler := Object compilerClass.
    actualCompiler := rbClass compilerClass.
    
    self assert: expectedCompiler = actualCompiler

    "Created: / 15-11-2014 / 17:02:00 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 25-01-2015 / 15:20:39 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_compiler_class_with_filled_real_class
    | expectedCompiler actualCompiler |

    expectedCompiler := JavaClass compilerClass.

    rbClass realClass: JavaClass.  
    actualCompiler := rbClass compilerClass.
    
    self assert: expectedCompiler = actualCompiler

    "Created: / 15-11-2014 / 17:02:10 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 25-01-2015 / 15:22:35 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_inherits_from_model_class
    | class |

    class := model classNamed: #Object.
    rbClass
        name: #SomeTestClass01;
        superclassName: #Object.

    self assert: (rbClass inheritsFrom: class).

    "Created: / 11-10-2014 / 01:09:01 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified (format): / 13-10-2014 / 20:47:51 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_inst_and_class_methods_do_with_model_class
    |expectedMethods actualMethods|

    rbClass
        compileMockMethod:'isMeta ^ false';
        compileMockMethod:'theNonMetaclass ^ self';
        compileMockMethod:'theMetaclass ^ RBMetaclass new'.

    rbClass
        name:#SomeClass;
        superclassName:#Object;
        compile:'selector_01 ^ 1'.

    expectedMethods := OrderedCollection new
        add:(rbClass compiledMethodAt:#'selector_01');
        yourself.

    actualMethods := OrderedCollection new.

    rbClass instAndClassMethodsDo:[ :method | 
        actualMethods add:method 
    ].

    self assert:expectedMethods = actualMethods

    "Created: / 01-11-2014 / 21:48:57 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified (format): / 02-11-2014 / 10:44:53 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_inst_and_class_methods_do_with_model_subclass_class
    |expectedMethods actualMethods|

    rbClass := RBClass new
        model:model;
        name:#SomeClass;
        superclassName:#Object;
        classVariableNames:#();
        poolDictionaryNames:#();
        compile;
        compile:'selector_01 ^ 1';
        yourself.

    expectedMethods := OrderedCollection new
        add:(rbClass compiledMethodAt:#'selector_01');
        yourself.

    actualMethods := OrderedCollection new.

    rbClass instAndClassMethodsDo:[ :method | 
        actualMethods add:method 
    ].

    self assert:expectedMethods = actualMethods

    "Created: / 02-11-2014 / 10:30:54 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_inst_and_class_methods_do_with_model_subclass_class_and_metaclass
    |expectedMethods actualMethods|

    rbClass := RBClass new
        model:model;
        name:#SomeClass;
        superclassName:#Object;
        classVariableNames:#();
        poolDictionaryNames:#();
        compile;
        compile:'selector_01 ^ 1';
        yourself.

    rbClass theMetaclass compile:'selector_02 ^ 2'.

    expectedMethods := OrderedCollection new
        add:(rbClass compiledMethodAt:#'selector_01');
        add:(rbClass theMetaclass compiledMethodAt:#'selector_02');
        yourself.

    actualMethods := OrderedCollection new.

    rbClass instAndClassMethodsDo:[ :method | 
        actualMethods add:method 
    ].

    self assert:expectedMethods = actualMethods

    "Created: / 02-11-2014 / 10:41:24 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_inst_and_class_methods_do_with_real_class
    |actualSelectors realClass|

    realClass := model classNamed: self class name.  

    actualSelectors := OrderedCollection new.

    realClass instAndClassMethodsDo:[ :method | 
        actualSelectors add:method selector
    ].

    "class method"
    self assert: (actualSelectors includes:#test_inst_and_class_methods_do_with_real_class).

    "metaclass method"
    self assert: (actualSelectors includes:#documentation).
    self deny: (self class includesSelector:#documentation). "to be sure that its just in metaclass"

    "Created: / 02-11-2014 / 11:05:50 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_is_abstract_custom_value_false

    rbClass := model createClass
        name: #DummyClass;
        compile;
        isAbstract: false;
        yourself.
    
    self deny: rbClass isAbstract

    "Created: / 14-12-2014 / 17:03:03 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 14-12-2014 / 18:03:54 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_is_abstract_custom_value_true

    rbClass := model createClass
        name: #DummyClass;
        compile;
        isAbstract: true;
        yourself.
    
    self assert: rbClass isAbstract

    "Created: / 14-12-2014 / 17:02:26 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 14-12-2014 / 18:03:42 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_is_abstract_default_value_for_new_class
    
    self assert: rbClass isAbstract

    "Created: / 14-12-2014 / 17:01:50 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_is_abstract_guess_from_method

    rbClass
        compileMockMethod: 'isMeta ^ false';
        compile: 'selector_01 ^ self subclassResponsibility'.
    
    self assert: rbClass isAbstract.
    self assert: (rbClass whichSelectorsReferToSymbol: #subclassResponsibility) notEmptyOrNil

    "Created: / 14-12-2014 / 17:04:57 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_is_abstract_guess_from_my_name_referenced

    "We need some reference outside the class itself"
    model createClass
        name: #DummyClass01;
        compile;
        compile: 'selector_01 ^ DummyClass02 new'.

    rbClass
        compileMockMethod: 'isMeta ^ false';
        name: #DummyClass02.
    
    self deny: rbClass isAbstract.

    "Created: / 14-12-2014 / 17:10:43 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_is_abstract_set_for_both_class_and_metaclass

    rbClass := model createClass
        name: 'DummyClass';
        compile;
        isAbstract: false;
        yourself.
    
    self deny: (rbClass theMetaclass isAbstract).
    self deny: (rbClass theNonMetaclass isAbstract).

    rbClass isAbstract: true.

    self assert: (rbClass theMetaclass isAbstract).
    self assert: (rbClass theNonMetaclass isAbstract).

    "Created: / 14-12-2014 / 17:44:23 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_is_loaded

    self assert: rbClass isLoaded

    "Created: / 15-11-2014 / 17:12:17 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_is_subclass_of_model_class
    | class |

    class := model classNamed: #Object.

    rbClass
        name: #SomeTestClass01;
        superclassName: #Object.

    self assert: (rbClass isSubclassOf: class).

    "Created: / 11-10-2014 / 00:57:03 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_is_subclass_of_model_class_not_found
    | class |

    class := RBClass new
        name: #SomeTestClass02;
        yourself.

    rbClass
        name: #SomeTestClass01;
        superclassName: #Object.

    self deny: (rbClass isSubclassOf: class).

    "Created: / 11-10-2014 / 12:22:20 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_is_subclass_of_model_class_two_level_subclass
    | class |

    class := model classNamed: #Object.

    rbClass
        name: #SomeTestClass01;
        superclass: (RBClass new
            name: #SomeTestClass02;
            model: model;
            superclassName: #Object;
            yourself).

    self assert: (rbClass isSubclassOf: class).

    "Created: / 11-10-2014 / 01:06:52 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_is_subclass_of_real_class
    | class |

    class := Object.

    rbClass
        name: #SomeTestClass01;
        superclassName: #Object.

    self assert: (rbClass isSubclassOf: class).

    "Created: / 11-10-2014 / 01:00:06 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_is_subclass_of_real_class_two_level_subclass
    | class |

    class := Object.

    rbClass
        name: #SomeTestClass01;
        superclass: (RBClass new
            name: #SomeTestClass02;
            model: model;
            superclassName: #Object;
            yourself).

    self assert: (rbClass isSubclassOf: class).

    "Created: / 11-10-2014 / 01:05:12 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_method_dictionary_add_and_remove_methods
    | expectedMethodDictionary actualMethodDictionary expectedMethodDictionaryKeys actualMethodDictionaryKeys |

    rbClass compileMockMethod: 'isMeta ^ false'.

    expectedMethodDictionary := MethodDictionary 
        withKeys: (Array with: #selector_01 with: #selector_03) 
        andValues: (Array with: Method new with: Method new).

    rbClass
        compile: 'selector_01 ^ 1';
        compile: 'selector_02 ^ 2';
        compile: 'selector_03 ^ 3';
        removeMethod: #selector_02.

    actualMethodDictionary := rbClass methodDictionary.
    expectedMethodDictionaryKeys := expectedMethodDictionary keys asSortedCollection.
    actualMethodDictionaryKeys := actualMethodDictionary keys asSortedCollection.
    
    self assert: expectedMethodDictionaryKeys = actualMethodDictionaryKeys

    "Created: / 30-09-2014 / 20:02:39 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 30-09-2014 / 21:54:36 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_method_dictionary_add_and_remove_methods_source
    | expectedMethodDictionarySources actualMethodDictionarySources |

    rbClass
        compileMockMethod: 'isMeta ^ false';
        compile: 'selector_01 ^ 1';
        compile: 'selector_02 ^ 2';
        compile: 'selector_03 ^ 3';
        removeMethod: #selector_02.

    expectedMethodDictionarySources := OrderedCollection new
        add: 'selector_01 ^ 1';
        add: 'selector_03 ^ 3';
        asSortedCollection.

    actualMethodDictionarySources := OrderedCollection new.

    actualMethodDictionarySources := rbClass methodDictionary collect: [ :method |
        method source    
    ].

    actualMethodDictionarySources := actualMethodDictionarySources asSortedCollection.
    
    self assert: expectedMethodDictionarySources = actualMethodDictionarySources

    "Created: / 02-11-2014 / 11:22:18 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 25-01-2015 / 15:29:10 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_method_dictionary_add_and_remove_methods_with_real_class
    | expectedMethodDictionary actualMethodDictionary expectedMethodDictionaryKeys actualMethodDictionaryKeys realSelector |

    realSelector := #test_method_dictionary_add_and_remove_methods_with_real_class.

    rbClass compileMockMethod: 'isMeta ^ false'.
    rbClass realClass: self class.

    expectedMethodDictionary := self class methodDictionary 
        at: #selector_01 putOrAppend: Method new.
    expectedMethodDictionary := expectedMethodDictionary 
        at: #selector_03 putOrAppend: Method new.
    expectedMethodDictionary := expectedMethodDictionary removeKeyAndCompress: realSelector.

    rbClass
        compile: 'selector_01 ^ 1';
        compile: 'selector_02 ^ 2';
        compile: 'selector_03 ^ 3';
        removeMethod: #selector_02;
        removeMethod: #test_method_dictionary_add_and_remove_methods_with_real_class.

    actualMethodDictionary := rbClass methodDictionary.
    expectedMethodDictionaryKeys := expectedMethodDictionary keys asSortedCollection.
    actualMethodDictionaryKeys := actualMethodDictionary keys asSortedCollection.
    
    self assert: expectedMethodDictionaryKeys = actualMethodDictionaryKeys

    "Created: / 30-09-2014 / 21:55:10 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 02-10-2014 / 21:11:46 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_method_dictionary_empty
    | expectedMethodDictionary actualMethodDictionary |

    expectedMethodDictionary := MethodDictionary new.
    actualMethodDictionary := rbClass methodDictionary.
    
    self assert: (expectedMethodDictionary keys) = (actualMethodDictionary keys)

    "Created: / 30-09-2014 / 19:56:32 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_method_do_with_model_class
    |expectedMethods actualMethods|

    rbClass
        compileMockMethod:'isMeta ^ false';
        name:#SomeClass;
        superclassName:#Object;
        compile:'selector_01 ^ 1'.

    expectedMethods := OrderedCollection new
        add:(rbClass compiledMethodAt:#'selector_01');
        yourself.

    actualMethods := OrderedCollection new.

    rbClass methodsDo:[ :method | 
        actualMethods add:method 
    ].

    self assert:expectedMethods = actualMethods

    "Created: / 02-11-2014 / 11:26:41 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_method_do_with_model_class_two_methods
    |expectedMethods actualMethods|

    rbClass
        compileMockMethod:'isMeta ^ false';
        name:#SomeClass;
        superclassName:#Object;
        compile:'selector_01 ^ 1';
        compile:'selector_02 ^ 2'.

    expectedMethods := OrderedCollection new
        add:(rbClass compiledMethodAt:#selector_01);
        add:(rbClass compiledMethodAt:#selector_02);
        yourself.

    actualMethods := OrderedCollection new.

    rbClass methodsDo:[ :method | 
        actualMethods add:method 
    ].

    self assert:expectedMethods = actualMethods

    "Created: / 02-11-2014 / 11:28:42 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 08-11-2014 / 11:13:34 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_methods_do_with_real_class
    |actualMethodSelectors|

    rbClass := model classNamed: self class name.

    actualMethodSelectors := OrderedCollection new.

    rbClass methodsDo:[ :method | 
        actualMethodSelectors add:method selector
    ].

    self assert:(actualMethodSelectors includes:#test_methods_do_with_real_class).
    self deny:(actualMethodSelectors includes:#documentation).
    self assert:(self class class includesSelector:#documentation).
    self deny:(self class includesSelector:#documentation).

    "Created: / 02-11-2014 / 11:37:24 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_methods_do_with_real_metaclass
    |actualMethodSelectors|

    rbClass := model metaclassNamed: self class name.

    actualMethodSelectors := OrderedCollection new.

    rbClass methodsDo:[ :method | 
        actualMethodSelectors add:method selector
    ].

    self assert:(actualMethodSelectors includes:#documentation).
    self deny:(actualMethodSelectors includes:#test_methods_do_with_real_metaclass).
    self deny:(self class class includesSelector:#test_methods_do_with_real_metaclass).
    self assert:(self class includesSelector:#test_methods_do_with_real_metaclass).

    "Created: / 02-11-2014 / 11:43:08 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_name_set_as_string
    | expectedName actualName |

    expectedName := #SomeClass01.
    rbClass name: 'SomeClass01'.
    actualName := rbClass name.

    self assert: expectedName == actualName

    "Created: / 19-11-2014 / 21:12:17 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_name_set_as_symbol
    | expectedName actualName |

    expectedName := #SomeClass01.
    rbClass name: #SomeClass01.
    actualName := rbClass name.

    self assert: expectedName == actualName

    "Created: / 19-11-2014 / 21:15:37 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_name_without_prefix_non_prefixed_class
    | expectedClassName actualClassName |

    rbClass name: #SomeClass.
    expectedClassName := #SomeClass.
    actualClassName := rbClass nameWithoutPrefix.  

    self assert: expectedClassName = actualClassName

    "Created: / 05-10-2014 / 00:13:21 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_name_without_prefix_prefixed_class
    | expectedClassName actualClassName |

    rbClass name: #'Prefix::SomeClass'.
    expectedClassName := #SomeClass.
    actualClassName := rbClass nameWithoutPrefix.  

    self assert: expectedClassName = actualClassName

    "Created: / 05-10-2014 / 00:13:02 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 25-01-2015 / 13:17:08 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_owning_class
    | expectedClass actualClass |

    expectedClass := RBClass new.

    "Class must be defined in the model to have class and metaclass couple"
    model defineClass: 'Object subclass:#DummyClass01
        instanceVariableNames:''''
        classVariableNames:''''
        poolDictionaries:''''
        category:'''''.

    rbClass := model classNamed: #DummyClass01.  
    rbClass owningClass: expectedClass.

    actualClass := rbClass owningClass.
    
    self assert: expectedClass = actualClass

    "Created: / 29-11-2014 / 13:27:30 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_owning_class_from_definition_string
    | expectedClass actualClass |

    "Class must be defined in the model to have class and metaclass couple"
    model defineClass: 'Object subclass:#DummyClass01
        instanceVariableNames:''''
        classVariableNames:''''
        poolDictionaries:''''
        category:'''''.

    model defineClass: 'Object subclass:#DummyPrivateClass01
        instanceVariableNames:''''
        classVariableNames:''''
        poolDictionaries:''''
        privateIn:DummyClass01'.

    expectedClass := model classNamed: #DummyClass01.  

    rbClass := model classNamed: #'DummyClass01::DummyPrivateClass01'.  

    actualClass := rbClass owningClass.
    
    self assert: expectedClass = actualClass

    "Created: / 29-11-2014 / 14:21:15 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 25-01-2015 / 13:16:28 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_owning_class_or_yourself_none_owner
    | expectedClass actualClass |

    rbClass := model classNamed: self class name.  
    expectedClass := rbClass.

    actualClass := rbClass owningClassOrYourself.
    
    self assert: expectedClass = actualClass

    "Created: / 29-11-2014 / 14:59:44 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_owning_class_or_yourself_owner
    | expectedClass actualClass |

    "Class must be defined in the model to have class and metaclass couple"
    model defineClass: 'Object subclass:#DummyClass01
        instanceVariableNames:''''
        classVariableNames:''''
        poolDictionaries:''''
        category:'''''.

    expectedClass := model classNamed: #DummyClass01.
    rbClass := model classNamed: self class name.  
    rbClass owningClass: expectedClass.

    actualClass := rbClass owningClassOrYourself.
    
    self assert: expectedClass = actualClass

    "Created: / 29-11-2014 / 14:56:09 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_package_custom
    | expectedPackage actualPackage |

    expectedPackage := 'some_package'.
    rbClass package: 'some_package'.

    actualPackage := rbClass package.

    self assert: expectedPackage = actualPackage

    "Created: / 09-10-2014 / 23:40:08 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_package_empty
    | expectedPackage actualPackage |

    expectedPackage := nil.
    actualPackage := rbClass package.

    self assert: expectedPackage = actualPackage

    "Created: / 09-10-2014 / 23:39:02 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_package_from_real_class
    | expectedPackage actualPackage |

    expectedPackage := self class package.

    self assert: expectedPackage size > 3.

    rbClass realClass: self class.

    actualPackage := rbClass package.

    self assert: expectedPackage = actualPackage

    "Created: / 09-10-2014 / 23:37:01 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_private_classes_at_found
    | expectedClass actualClass |

    model defineClass: 'Object subclass:#DummyPrivateClass01
        instanceVariableNames:''''
        classVariableNames:''''
        poolDictionaries:''''
        privateIn:Object'.

    expectedClass := model classNamed: #'Object::DummyPrivateClass01'.
    self assert: (expectedClass name) = #'Object::DummyPrivateClass01'. 

    rbClass name: #Object.
    actualClass := rbClass privateClassesAt: #DummyPrivateClass01.
    
    self assert: expectedClass = actualClass

    "Created: / 16-11-2014 / 11:50:30 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 25-01-2015 / 13:17:49 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_private_classes_at_not_found
    | expectedClass actualClass |

    expectedClass := nil.
    actualClass := rbClass privateClassesAt: #None.
    
    self assert: expectedClass = actualClass

    "Created: / 16-11-2014 / 11:41:11 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_private_classes_at_not_found_with_name
    | expectedClass actualClass |

    expectedClass := nil.
    rbClass name: #DummyClass01.
    actualClass := rbClass privateClassesAt: #None.
    
    self assert: expectedClass = actualClass

    "Created: / 16-11-2014 / 11:43:06 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified (format): / 16-11-2014 / 16:25:34 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_real_shared_pool_names
    
    self assert: #() = (rbClass realSharedPoolNames)

    "Created: / 16-11-2014 / 16:40:33 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_source_code_at_existing_method
    | class expectedSource actualSource |

    class := model createClassImmediate: #DummyClass01.
    model createMethodImmediate: class source: 'selector_01 ^ 555'. 

    rbClass := model classFor: class.  

    expectedSource := 'selector_01 ^ 555'.
    actualSource := rbClass sourceCodeAt: #selector_01.  

    self assert: expectedSource = actualSource

    "Created: / 31-01-2015 / 19:14:33 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_source_code_at_new_method
    | expectedSource actualSource |

    rbClass name: #DummyClass01; 
        compileMockMethod: 'isMeta ^ false';
        compile: 'selector_01 ^ 555'. 

    expectedSource := 'selector_01 ^ 555'.
    actualSource := rbClass sourceCodeAt: #selector_01.  

    self assert: expectedSource = actualSource

    "Created: / 31-01-2015 / 19:17:46 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_source_code_at_unknown_method
    | expectedSource actualSource |

    rbClass name: #DummyClass01; 
        compileMockMethod: 'isMeta ^ false'.

    expectedSource := nil.
    actualSource := rbClass sourceCodeAt: #selector_01.  

    self assert: expectedSource = actualSource

    "Created: / 31-01-2015 / 19:20:37 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_superclass_name
    | expectedClassName actualClassName |

    rbClass
        name: #SomeClass;
        superclassName: (self class name).

    expectedClassName := self class name.
    actualClassName := rbClass superclass name.

    self assert: expectedClassName = actualClassName

    "Created: / 05-10-2014 / 00:16:02 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_top_name_space

    self assert: (rbClass topNameSpace) == (rbClass model)

    "Created: / 16-11-2014 / 16:58:50 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_top_owning_class
    | expectedClass actualClass |

    "Class must be defined in the model to have class and metaclass couple"
    model defineClass: 'Object subclass:#DummyClass01
        instanceVariableNames:''''
        classVariableNames:''''
        poolDictionaries:''''
        category:'''''.

    model defineClass: 'Object subclass:#DummyPrivateClass01
        instanceVariableNames:''''
        classVariableNames:''''
        poolDictionaries:''''
        privateIn:DummyClass01'.

    expectedClass := model classNamed: #DummyClass01.  

    rbClass := model classNamed: #'DummyClass01::DummyPrivateClass01'.  
    rbClass owningClass: expectedClass.

    actualClass := rbClass topOwningClass.
    
    self assert: expectedClass = actualClass

    "Created: / 29-11-2014 / 14:12:25 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 25-01-2015 / 13:18:24 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_with_all_superclasses_do_for_one_superclass
    | expectedClassNames actualClassNames |

    rbClass
        name: #SomeClass;
        superclassName: #Object.

    expectedClassNames := OrderedCollection new
        add: #SomeClass;
        add: #Object;
        yourself.

    actualClassNames := OrderedCollection new.

    rbClass withAllSuperclassesDo: [ :class |
        actualClassNames add: class name.
    ].

    self assert: expectedClassNames = actualClassNames

    "Created: / 05-10-2014 / 00:22:38 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomRBAbstractClassTests class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

