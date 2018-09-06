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

CustomCodeGeneratorOrRefactoringTestCase subclass:#CustomNamespaceTests
	instanceVariableNames:'refactoryChangeManager'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Tests'
!

!CustomNamespaceTests class methodsFor:'documentation'!

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

!CustomNamespaceTests methodsFor:'accessing'!

generatorOrRefactoring
    ^ nil

    "Modified: / 31-05-2014 / 22:48:25 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomNamespaceTests methodsFor:'initialization & release'!

setUp

    super setUp.
    refactoryChangeManager := RefactoryChangeManager instance.

    "Created: / 16-04-2014 / 21:39:50 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 31-05-2014 / 22:45:57 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomNamespaceTests methodsFor:'private'!

lastUndoChange

    refactoryChangeManager undoableOperations isEmpty ifTrue: [ 
        ^ nil 
    ] ifFalse: [
        ^ refactoryChangeManager undoChange
    ].

    "Created: / 16-04-2014 / 21:40:37 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 31-05-2014 / 19:53:08 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomNamespaceTests methodsFor:'tests'!

test_all_class_var_names
    | class actualClassVars expectedClassVars |

    class := model createClass
        name: #MockClassForTestCase;
        classVariableNames: #('ClassVar1' 'ClassVar2');
        yourself.

    expectedClassVars := (Object allClassVarNames, (Array with: #ClassVar1 with: #ClassVar2)).
    actualClassVars := class theNonMetaclass allClassVarNames.

    self assert: expectedClassVars = actualClassVars

    "Created: / 20-06-2014 / 22:35:27 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 09-10-2014 / 10:47:56 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_at_class_found
    | expectedClass actualClass |

    expectedClass := model createClass
        name: #DummyClass01;
        compile;
        yourself.

    actualClass := model at: #DummyClass01.
    
    self assert: expectedClass = actualClass

    "Modified: / 16-11-2014 / 17:08:24 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_at_class_missing
    | expectedClass actualClass |

    expectedClass := nil.

    actualClass := model at: #DummyClass01.
    
    self assert: expectedClass = actualClass

    "Created: / 16-11-2014 / 17:08:44 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_changes_empty_as_default

    self assert: model changes size == 0

    "Created: / 22-07-2014 / 22:52:23 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 25-01-2015 / 16:23:26 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_class_and_class_method_generated_as_one_undo_change
    | className class lastUndoChange |

    lastUndoChange := self lastUndoChange.

    className := #MockClassForTestingOneUndoChange.

    self assertClassNotExists: className.

    model := CustomNamespace new.
    model changeManager: refactoryChangeManager.

    class := model createClass
        name: className;
        compile;
        yourself.  

    self assertClassNotExists: className.

    model createMethod
        class: class theMetaclass;
        protocol: 'a protocol';
        source: 'aSelector
        ^ nil';
        compile.

    self assertClassNotExists: className.
    self assert: lastUndoChange = (self lastUndoChange).

    model execute.

    self assertClassExists: className.
    self deny: lastUndoChange = (self lastUndoChange).
    self assert: ((Smalltalk classNamed: className) class includesSelector: #aSelector).
    self assert: ((Smalltalk classNamed: className) includesSelector: #aSelector) not.

    refactoryChangeManager undoOperation.

    self assertClassNotExists: className.
    self assert: lastUndoChange = (self lastUndoChange).

    "Created: / 17-04-2014 / 23:54:22 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 25-01-2015 / 14:40:26 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_class_and_instance_method_generated_as_one_undo_change
    | className class lastUndoChange |

    lastUndoChange := self lastUndoChange.

    className := #MockClassForTestingOneUndoChange.

    self assertClassNotExists: className.

    model := CustomNamespace new.
    model changeManager: refactoryChangeManager.  

    class := model createClass
        name: className;
        compile;
        yourself.  

    self assertClassNotExists: className.

    model createMethod
        class: class;
        protocol: 'a protocol';
        source: 'aSelector
        ^ nil';
        compile.

    self assertClassNotExists: className.
    self assert: lastUndoChange = (self lastUndoChange).

    model execute.

    self assertClassExists: className.
    self deny: lastUndoChange = (self lastUndoChange).
    self assert: ((Smalltalk classNamed: className) includesSelector: #aSelector).

    refactoryChangeManager undoOperation.

    self assertClassNotExists: className.
    self assert: lastUndoChange = (self lastUndoChange).

    "Created: / 17-04-2014 / 23:54:05 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 25-01-2015 / 14:40:42 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_comment_in_method_generated
    | class generatedSource expectedSource |

    class := self class.

    model createMethod
        class: self class;
        protocol: 'a protocol';
        source: 'aSelector
            "a comment"
            ^ nil';
        compile.

    self assert: (class includesSelector: #aSelector) not.

    model execute.

    generatedSource := (class sourceCodeAt: #aSelector).
    expectedSource := 'aSelector
    "a comment"

    ^ nil'.

    self assert: (class includesSelector: #aSelector).
    self assert: (generatedSource includesSubString: '"a comment"').
    self assertSource: expectedSource sameAs: generatedSource

    "Created: / 27-04-2014 / 15:57:17 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 26-08-2014 / 23:42:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 09-10-2014 / 23:06:38 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_create_class_immediate
    | mockClass |

    mockClass := model createClassImmediate: 'MockClassForTestCase'.

    self assert: mockClass new className = 'MockClassForTestCase'.
    self assert: mockClass superclass new className = 'Object'.
    self assert: mockClass instanceVariableString = ''.
    self assert: mockClass classVariableString = ''.
    self assert: mockClass poolDictionaries = ''.
    self assert: mockClass category = ''.

    "Created: / 15-06-2014 / 17:27:41 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 27-07-2014 / 12:42:53 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_create_class_immediate_object_changes_kept
    | expectedId actualId mockClass |

    mockClass := model createClassImmediate: 'MockClassForTestCase01'.
    expectedId := mockClass identityHash.
    mockClass package: #some_package.

    model createClassImmediate: 'MockClassForTestCase02'.
    self assertClassExists: #MockClassForTestCase02.  

    actualId := (Smalltalk at: #MockClassForTestCase01) identityHash.

    self assert: expectedId = actualId.
    self assert: (Smalltalk at: #MockClassForTestCase01) package = #some_package.

    "Created: / 02-11-2014 / 16:27:21 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_create_class_immediate_super_class_name_instance_variable_names_class_variable_names_pool_dictionaries_category_private_in_private_class
    | mockClass |

    mockClass := model
        createClassImmediate: 'MockClassForTestCase' 
        superClassName: 'Object'
        instanceVariableNames: 'instVar'
        classVariableNames: 'ClassVar'
        poolDictionaries: 'pollDict01'
        category: 'Some-Category01'
        privateIn: 'Object'.

    self assert: mockClass name = 'Object::MockClassForTestCase'.
    self assert: mockClass superclass name = 'Object'.
    self assert: mockClass instanceVariableString = 'instVar'.
    self assert: mockClass classVariableString = 'ClassVar'.
    self assert: mockClass poolDictionaries = 'pollDict01'.
    self assert: mockClass category = Object category.
    self assert: (mockClass owningClass name) = 'Object'.

    "Modified: / 31-10-2014 / 00:19:37 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_create_class_immediate_super_class_name_private_in
    | mockClass |

    mockClass := model
        createClassImmediate: 'MockClassForTestCase' 
        superClassName: 'Object'
        privateIn: 'Object'.

    self assert: mockClass name = 'Object::MockClassForTestCase'.
    self assert: mockClass superclass name = 'Object'.
    self assert: mockClass instanceVariableString = ''.
    self assert: mockClass classVariableString = ''.
    self assert: mockClass poolDictionaries = ''.
    self assert: mockClass category = Object category.
    self assert: (mockClass owningClass name) = 'Object'.

    "Modified: / 31-10-2014 / 00:20:36 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_create_class_immediate_with_category
    | mockClass |

    mockClass := model createClassImmediate: 'MockClassForTestCase' category: 'Some-Category01'.

    self assert: mockClass new className = 'MockClassForTestCase'.
    self assert: mockClass superclass new className = 'Object'.
    self assert: mockClass instanceVariableString = ''.
    self assert: mockClass classVariableString = ''.
    self assert: mockClass poolDictionaries = ''.
    self assert: mockClass category = 'Some-Category01'.

    "Modified: / 19-10-2014 / 20:56:27 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_create_class_immediate_with_given_super_class_name
    | mockClass |

    mockClass := model createClassImmediate: 'MockClassForTestCase' superClassName: 'Object'.

    self assert: mockClass new className = 'MockClassForTestCase'.
    self assert: mockClass superclass new className = 'Object'.
    self assert: mockClass instanceVariableString = ''.
    self assert: mockClass classVariableString = ''.
    self assert: mockClass poolDictionaries = ''.
    self assert: mockClass category = ''.

    "Created: / 27-07-2014 / 12:42:35 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_create_class_immediate_with_instance_and_class_variables
    | mockClass |

    mockClass := model
        createClassImmediate: 'MockClassForTestCase' 
        superClassName: 'Object'
        instanceVariableNames: 'instVar'
        classVariableNames: 'ClassVar'.

    self assert: mockClass new className = 'MockClassForTestCase'.
    self assert: mockClass superclass new className = 'Object'.
    self assert: mockClass instanceVariableString = 'instVar'.
    self assert: mockClass classVariableString = 'ClassVar'.
    self assert: mockClass poolDictionaries = ''.
    self assert: mockClass category = ''.

    "Created: / 23-08-2014 / 22:24:02 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_create_class_immediate_with_instance_variables
    | mockClass |

    mockClass := model
        createClassImmediate: 'MockClassForTestCase' 
        instanceVariableNames: 'instVar'.

    self assert: mockClass new className = 'MockClassForTestCase'.
    self assert: mockClass superclass new className = 'Object'.
    self assert: mockClass instanceVariableString = 'instVar'.
    self assert: mockClass classVariableString = ''.
    self assert: mockClass poolDictionaries = ''.
    self assert: mockClass category = ''.

    "Created: / 23-08-2014 / 22:26:24 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_create_class_immediate_with_super_class_name_instance_variable_names_class_variable_names_pool_dictionaries_category    
    | mockClass |

    mockClass := model
        createClassImmediate: 'MockClassForTestCase' 
        superClassName: 'Object'
        instanceVariableNames: 'instVar'
        classVariableNames: 'ClassVar'
        poolDictionaries: 'pollDict01'
        category: 'Some-Category01'.

    self assert: mockClass new className = 'MockClassForTestCase'.
    self assert: mockClass superclass new className = 'Object'.
    self assert: mockClass instanceVariableString = 'instVar'.
    self assert: mockClass classVariableString = 'ClassVar'.
    self assert: mockClass poolDictionaries = 'pollDict01'.
    self assert: mockClass category = 'Some-Category01'.

    "Modified (comment): / 19-10-2014 / 20:53:28 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_create_class_is_stored_in_model_when_compiled
    | class classFromModel |

    class := model createClass
        name: #MockClassForTestCase;
        compile;
        yourself.

    class compile: 'selector_01 ^ 1'.

    classFromModel := model classNamed: #MockClassForTestCase.

    self assert: class == classFromModel.
    self assert: (classFromModel includesSelector: #selector_01).

    "Created: / 03-11-2014 / 22:47:00 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_create_class_then_access_metaclass
    | class |

    class := model createClass.
    class name: 'SomeClass'.
    class superclassName: self class name.
    "The compile method creates the change object and registers 
    the class in the model (RBNamespace/CustomNamespace)"
    class compile.

    self assert: class theMetaClass notNil.
    self assert: class theMetaClass theNonMetaClass == class

    "Created: / 14-11-2014 / 23:53:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 19-11-2014 / 21:32:37 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_create_class_with_instance_variable
    | expectedVariables actualVariables |

    model createClass
        name: #DummyClass01;
        instanceVariableNames: (Array with: 'instanceVariable');
        compile.

    model execute.

    expectedVariables := #('instanceVariable').
    actualVariables := (Smalltalk at: #DummyClass01) instanceVariableNames.

    self assert: expectedVariables = actualVariables

    "Created: / 30-11-2014 / 19:11:59 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_create_class_with_name_as_string
    | class |

    class := model createClass
        name: 'SomeClass';
        superclassName: self class name;
        compile;
        yourself.

    self assert: class == (model classNamed: #SomeClass).
    self assert: class == (model classNamed: 'SomeClass').
    self assert: (class theMetaclass) == (model metaclassNamed: #SomeClass).
    self assert: (class theMetaclass) == (model metaclassNamed: 'SomeClass').

    "Created: / 19-11-2014 / 21:02:05 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_create_class_with_superclass_name_as_string
    | superclass |

    model createClass
        name: 'SomeClass';
        superclassName: 'Object';
        compile.

    superclass := model classNamed: 'Object'.  

    self assert: superclass == (model classNamed: #Object).
    self assert: superclass == (model classNamed: 'Object').
    self assert: (superclass theMetaclass) == (model metaclassNamed: #Object).
    self assert: (superclass theMetaclass) == (model metaclassNamed: 'Object').

    "Created: / 23-11-2014 / 21:15:44 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_create_class_within_given_package
    | class package |

    package := self class package.
    self assert: package size > 3.

    model createClass
        name: #MockClassForTestCase;
        package: package;
        compile.

    model execute.

    class := Smalltalk classNamed: 'MockClassForTestCase'.

    self assert: class new className = 'MockClassForTestCase'.
    self assert: class superclass new className = 'Object'.
    self assert: class instanceVariableString = ''.
    self assert: class classVariableString = ''.
    self assert: class poolDictionaries = ''.
    self assert: class category = '** As yet undefined **'.
    self assert: class package = package.

    "Created: / 30-08-2014 / 20:35:35 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified (format): / 09-10-2014 / 23:23:06 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_create_class_without_given_package
    | class package |

    package := self class package.
    self assert: package size > 3.

    model createClass
        name: #MockClassForTestCase;
        compile.

    model execute.

    class := Smalltalk classNamed: 'MockClassForTestCase'.

    self assert: class new className = 'MockClassForTestCase'.
    self assert: class superclass new className = 'Object'.
    self assert: class instanceVariableString = ''.
    self assert: class classVariableString = ''.
    self assert: class poolDictionaries = ''.
    self assert: class category = '** As yet undefined **'.
    self deny: class package = package.

    "Created: / 30-08-2014 / 20:57:22 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 25-01-2015 / 14:41:08 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_create_method_immediate
    | mockClass expectedSource actualSource |

    expectedSource := 'instanceMethod:aParam
    ^ self'.

    mockClass := model createClassImmediate: 'MockClassForTestCase' superClassName: 'Object'.
    model createMethodImmediate: mockClass protocol: 'a protocol' source: expectedSource.

    actualSource := (mockClass sourceCodeAt: #instanceMethod:).

    self assertSource: expectedSource sameAs: actualSource.
    self assert: (mockClass compiledMethodAt: #instanceMethod:) category = 'a protocol'

    "Created: / 15-06-2014 / 17:28:36 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 24-06-2014 / 21:59:23 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_create_method_immediate_object_changes_kept
    | expectedId actualId mockClass method |

    mockClass := model createClassImmediate: 'MockClassForTestCase' superClassName: 'Object'.
    method := model createMethodImmediate: mockClass protocol: 'a protocol' source: 'selector_01 ^ 11'.
    expectedId := method identityHash.
    method package: #some_package.
    model createMethodImmediate: mockClass protocol: 'a protocol' source: 'selector_02 ^ 22'.
    actualId := (mockClass compiledMethodAt:#selector_01) identityHash.

    self assert: expectedId = actualId.
    self assert: ((mockClass compiledMethodAt:#selector_01) package) = #some_package.

    "Created: / 02-11-2014 / 16:12:09 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_create_method_immediate_protocol_source_package
    | expectedSource actualSource mockClass |

    expectedSource := 'instanceMethod:aParam
    ^ self'.

    mockClass := model createClassImmediate: 'MockClassForTestCase' superClassName: 'Object'.
    model createMethodImmediate: mockClass 
        protocol: 'a protocol' 
        source: expectedSource 
        package: #some_package01.

    actualSource := (mockClass sourceCodeAt: #instanceMethod:).

    self assertSource: expectedSource sameAs: actualSource.
    self assert: (mockClass compiledMethodAt: #instanceMethod:) category = 'a protocol'.    
    self assert: (mockClass compiledMethodAt: #instanceMethod:) package = #some_package01.

    "Modified: / 17-10-2014 / 10:02:42 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_create_method_immediate_with_preset_protocol
    | mockClass expectedSource actualSource |

    expectedSource := 'instanceMethod:aParam
    ^ self'.

    mockClass := model createClassImmediate: 'MockClassForTestCase' superClassName: 'Object'.
    model createMethodImmediate: mockClass source: expectedSource.

    actualSource := (mockClass sourceCodeAt: #instanceMethod:).

    self assertSource: expectedSource sameAs: actualSource.
    self assert: (mockClass compiledMethodAt: #instanceMethod:) category = 'protocol'

    "Created: / 23-08-2014 / 21:48:51 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_create_method_within_given_package
    | mockClass package method |

    package := self class package.
    self assert: package size > 3.

    mockClass := model createClassImmediate: 'MockClassForTestCase' superClassName: 'Object'.
    model createMethod
        class: mockClass;
        protocol: 'a protocol';
        package: package;
        source: 'selector ^ 123';
        compile.

    model execute.

    method := (mockClass compiledMethodAt: #selector).

    self assert: method package = package

    "Created: / 30-08-2014 / 18:45:35 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 10-10-2014 / 00:02:52 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_create_method_without_given_package
    | mockClass package method |

    package := self class package.
    self assert: package size > 3.

    mockClass := model createClassImmediate: 'MockClassForTestCase' superClassName: 'Object'.
    model createMethod
        class: mockClass;
        protocol: 'a protocol';
        source: 'selector ^ 123';
        compile.

    model execute.

    method := (mockClass compiledMethodAt: #selector).

    self deny: method package = package.

    "Created: / 30-08-2014 / 18:46:52 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 25-01-2015 / 14:41:26 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_define_class_with_private_class
    | expectedClass actualClass |

    expectedClass := model createClass
        name: #DummyClass01;
        compile;
        yourself.

    model defineClass: 'DummyClass01 subclass:#DummyPrivate01
        instanceVariableNames:''''
        classVariableNames:''''
        poolDictionaries:''''
        privateIn:DummyClass01'.    

    actualClass := (model classNamed: #'DummyClass01::DummyPrivate01') owningClass.   

    self assert: expectedClass = actualClass

    "Modified: / 25-01-2015 / 13:12:24 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_define_class_without_private_class
    | expectedClass actualClass |

    expectedClass := nil.

    model defineClass: 'Object subclass:#DummyClass01
        instanceVariableNames:''''
        classVariableNames:''''
        poolDictionaries:''''
        category:'''''.    

    actualClass := (model classNamed: #DummyClass01) owningClass.   

    self assert: expectedClass = actualClass

    "Created: / 29-11-2014 / 14:51:14 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_empty_class_definition_string
    | expectedDefinition actualDefinition |

    expectedDefinition := 'Object subclass: #''Unknown Class''
        instanceVariableNames: ''''
        classVariableNames: ''''
        poolDictionaries: ''''
        category: ''** As yet undefined **'''.

    actualDefinition := model createClass definitionString.                                     

    self assertSource: expectedDefinition sameAs: actualDefinition.

    "Created: / 10-10-2014 / 15:41:45 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_empty_class_in_changes

    model createClass compile.
    self assert:(model changes changesSize) = 1.

    "Created: / 22-07-2014 / 22:22:04 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 10-10-2014 / 15:48:35 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_is_namespace
    
    self assert: model isNamespace

    "Modified: / 16-11-2014 / 17:09:28 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_method_source_builded
    | method expectedSource actualSource |

    method := model createMethod
        source: '`@methodName
    ^ `variableName';
        replace: '`@methodName' with: #selector;
        replace: '`variableName' with: 'aName';
        yourself.

    expectedSource := 'selector
    ^ aName'.

    actualSource := method newSource.

    self assertSource: expectedSource sameAs: actualSource

    "Created: / 18-05-2014 / 17:14:13 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 26-08-2014 / 23:40:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 10-10-2014 / 15:56:56 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_method_source_builded_with_comment
    | method buildedSource expectedSource |

    method := model createMethod
        source: '`@methodName

    `"comment

    ^ `variableName';
        replace: '`@methodName' with: #selector;
        replace: '`variableName' with: 'aName';
        replace: '`"comment' with: '"a comment"';
        yourself.

    buildedSource := method newSource.
    expectedSource := 'selector
    "a comment"

    ^ aName'.

    self assertSource: expectedSource sameAs: buildedSource

    "Created: / 19-05-2014 / 18:57:25 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 26-08-2014 / 23:55:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 10-10-2014 / 15:56:32 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_method_source_with_original_formatting
    | method originalSource actualSource expectedSource |

    originalSource := 'methodName

    `variableName do: [ each | each call ].'.

    expectedSource := 'methodName

    collection do: [ each | each call ].'.

    model formatter: CustomNoneSourceCodeFormatter new.
    method := model createMethod
        source: originalSource;
        replace: '`variableName' with: 'collection';
        yourself.

    actualSource := method newSource.

    self assertSource: expectedSource sameAs: actualSource.

    "Created: / 22-07-2014 / 23:04:43 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 10-10-2014 / 15:57:21 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_nil_changes_not_in_change_collector

    self should: [ 
        model createMethod compile.
    ] raise: Error.

    self assert: model changes changesSize = 0.

    "Created: / 22-07-2014 / 22:16:37 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 10-10-2014 / 16:00:56 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_put_model_class_changed_class
    |class|

    model createNewClassFor: self class. "Actually creates class modification"

    class := RBClass new
        model: model;  
        name: self class name;
        yourself.

    model putModelClass: class.  

    self assert: class == (model classNamed: class name).

    "Created: / 04-11-2014 / 00:50:58 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_put_model_class_changed_metaclass
    |class|

    model createNewClassFor: self class. "Actually creates class modification"

    class := RBMetaclass new
        model: model;  
        name: self class name;
        yourself.

    model putModelClass: class.  

    self assert: class == (model metaclassNamed: class name).

    "Created: / 04-11-2014 / 01:10:25 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_put_model_class_new_class
    |class|

    class := RBClass new
        model: model;  
        name: #DummyClassForTestCase01;
        superclassName: #Object;
        instVarNames: #();
        classVariableNames: #();
        poolDictionaryNames: #();
        yourself.

    model defineClass: class definitionString.
    model putModelClass: class.  

    self assert: class == (model classNamed: #DummyClassForTestCase01).

    "Created: / 04-11-2014 / 00:25:58 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_put_model_class_new_metaclass
    |class metaclass|

    class := RBClass new
        model: model;  
        name: #DummyClassForTestCase01;
        superclassName: #Object;
        instVarNames: #();
        classVariableNames: #();
        poolDictionaryNames: #();
        yourself.

    metaclass := RBMetaclass new
        model: model;
        name: #DummyClassForTestCase01;
        yourself.

    model defineClass: class definitionString.
    model putModelClass: metaclass.  

    self deny: class == (model metaclassNamed: #DummyClassForTestCase01).
    self assert: metaclass == (model metaclassNamed: #DummyClassForTestCase01).

    "Created: / 04-11-2014 / 00:31:56 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_put_model_class_undefined_error
    |class|

    class := RBClass new
        name: #DummyClassForTestCase01.

    self should: [ 
        model putModelClass: class.  
    ] raise: Error

    "Modified (format): / 04-11-2014 / 00:22:25 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_undo_changes_for_multiple_executes
    "Note: Methods createClassImmediate and createMethodImmediate have execute call inside"
    
    |mockSuperClassName mockClassName mockSuperClass|

    mockSuperClassName := 'MockSuperClassForTestCase'.
    mockClassName := 'MockClassForTestCase'.
    mockSuperClass := model createClassImmediate:mockSuperClassName
            superClassName:'Object'.
    model createClassImmediate:mockClassName
        superClassName:mockSuperClassName.
    
    "/ Instance method
    
    model 
        createMethodImmediate:mockSuperClass
        protocol:'instance-protocol'
        source:'instanceMethod: aParam
    self shouldImplement'.
    
    "/ Class method
    
    model 
        createMethodImmediate:mockSuperClass class
        protocol:'class-protocol'
        source:'classMethod: aParam
    self shouldImplement'.
    self assertClassExists:mockSuperClassName.
    self assertClassExists:mockClassName.
    model undoChanges.
    self assertClassNotExists:mockSuperClassName.
    self assertClassNotExists:mockClassName.

    "Created: / 15-06-2014 / 16:21:52 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 19-10-2014 / 14:57:07 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomNamespaceTests class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

