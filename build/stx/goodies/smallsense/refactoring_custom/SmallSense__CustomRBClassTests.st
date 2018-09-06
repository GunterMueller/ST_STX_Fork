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

Smalltalk::TestCase subclass:#CustomRBClassTests
	instanceVariableNames:'rbClass mock model'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Tests'
!

!CustomRBClassTests class methodsFor:'documentation'!

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
    Test extensions in RBClass.

    [author:]
        Jakub Nesveda <nesvejak@fit.cvut.cz>

"
! !

!CustomRBClassTests methodsFor:'initialization & release'!

setUp

    mock := CustomMock new.
    model := RBNamespace new.
    rbClass := mock mockOf: RBClass.
    rbClass model: model.

    "Created: / 30-09-2014 / 19:36:05 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 05-10-2014 / 00:27:06 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

tearDown

    mock unmockAll

    "Created: / 30-09-2014 / 19:44:27 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomRBClassTests methodsFor:'tests'!

test_compile_for_class
    | lastChange savedRbClass |

    rbClass
        name: #SomeClass;
        superclassName: #Object;
        instVarNames: #('inst1' 'inst2');
        classVariableNames: #('Cls1');
        poolDictionaryNames: (Array with: 'poolDict1');
        category: 'Some-Test-Category';
        compile.  

    model changes do: [ :change |
        lastChange := change
    ].
    savedRbClass := model classNamed: #SomeClass.

    self assert: (lastChange isKindOf: AddClassChange).  
    self assert: (lastChange changeClassName) = #SomeClass.  
    self assert: (lastChange category) = 'Some-Test-Category'.  
    self assert: (lastChange classVariableNames) = (#('Cls1') asStringCollection).  
    self assert: (lastChange instanceVariableNames) = (#('inst1' 'inst2') asStringCollection).  
    self assert: (lastChange poolDictionaryNames) = (OrderedCollection newFrom: #('poolDict1')).  
    self assert: (lastChange superclassName) = #Object.  

    self assert: (savedRbClass isKindOf: RBClass).  
    self assert: (savedRbClass name) = #SomeClass.  
    self assert: (savedRbClass category) = 'Some-Test-Category'.  
    self assert: (savedRbClass classVariableNames) = (OrderedCollection newFrom: #('Cls1')).  
    self assert: (savedRbClass instanceVariableNames) = (OrderedCollection newFrom: #('inst1' 'inst2')).  
    self assert: (savedRbClass poolDictionaryNames) = (OrderedCollection newFrom: #('poolDict1')).  
    self assert: (savedRbClass superclass name) = #Object.

    "Created: / 05-10-2014 / 00:27:50 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 25-01-2015 / 13:24:45 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_compile_for_class_with_set_package
    | lastChange savedRbClass |

    rbClass
        name: #SomeClass;
        superclassName: #Object;
        instVarNames: #('inst1' 'inst2');
        classVariableNames: #('Cls1');
        poolDictionaryNames: (Array with: 'poolDict1');
        category: 'Some-Test-Category';
        package: 'some_package';
        compile.  

    model changes do: [ :change |
        lastChange := change
    ].
    savedRbClass := model classNamed: #SomeClass.

    self assert: (lastChange isKindOf: AddClassChange).  
    self assert: (lastChange changeClassName) = #SomeClass.  
    self assert: (lastChange category) = 'Some-Test-Category'.  
    self assert: (lastChange classVariableNames) = (#('Cls1') asStringCollection).  
    self assert: (lastChange instanceVariableNames) = (#('inst1' 'inst2') asStringCollection).  
    self assert: (lastChange poolDictionaryNames) = (OrderedCollection newFrom: #('poolDict1')).  
    self assert: (lastChange superclassName) = #Object.  
    self assert: (lastChange package) = 'some_package'.  

    self assert: (savedRbClass isKindOf: RBClass).  
    self assert: (savedRbClass name) = #SomeClass.  
    self assert: (savedRbClass category) = 'Some-Test-Category'.  
    self assert: (savedRbClass classVariableNames) = (OrderedCollection newFrom: #('Cls1')).  
    self assert: (savedRbClass instanceVariableNames) = (OrderedCollection newFrom: #('inst1' 'inst2')).  
    self assert: (savedRbClass poolDictionaryNames) = (OrderedCollection newFrom: #('poolDict1')).  
    self assert: (savedRbClass superclass name) = #Object.
    self assert: (savedRbClass package) = 'some_package'.

    "Created: / 09-10-2014 / 23:41:34 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 25-01-2015 / 13:25:08 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_compile_for_real_class_with_set_package
    | lastChange savedRbClass expectedPackage |

    expectedPackage := self class package deepCopy.

    self assert: expectedPackage notEmpty.

    rbClass := RBClass existingNamed: self class name.
    rbClass
        model: model;
        compile.

    model changes do: [ :change |
        lastChange := change
    ].
    savedRbClass := model classNamed: self class name.

    self assert: (lastChange isKindOf: AddClassChange).
    self assert: (lastChange package) = expectedPackage.  

    self assert: (savedRbClass isKindOf: RBClass).
    self assert: (savedRbClass package) = expectedPackage.

    "Created: / 09-10-2014 / 23:54:35 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 25-01-2015 / 15:36:55 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_compile_with_custom_namespace
    | lastChange savedRbClass customModel |

    customModel := CustomNamespace new.

    rbClass
        model: customModel;
        name: #SomeClass;
        superclassName: #Object;
        instVarNames: #('inst1' 'inst2');
        classVariableNames: #('Cls1');
        poolDictionaryNames: (Array with: 'poolDict1');
        category: 'Some-Test-Category';
        package: #some_package;
        compile.  

    customModel changes do: [ :change |
        lastChange := change
    ].

    savedRbClass := customModel classNamed: #SomeClass.

    self assert: rbClass == savedRbClass.

    self assert: (lastChange isKindOf: AddClassChange).  
    self assert: (lastChange changeClassName) = #SomeClass.  
    self assert: (lastChange category) = 'Some-Test-Category'.  
    self assert: (lastChange classVariableNames) = (#('Cls1') asStringCollection).  
    self assert: (lastChange instanceVariableNames) = (#('inst1' 'inst2') asStringCollection).  
    self assert: (lastChange poolDictionaryNames) = (OrderedCollection newFrom: #('poolDict1')).  
    self assert: (lastChange superclassName) = #Object.  
    self assert: (lastChange package) = #some_package.  

    self assert: (savedRbClass isKindOf: RBClass).  
    self assert: (savedRbClass name) = #SomeClass.  
    self assert: (savedRbClass category) = 'Some-Test-Category'.  
    self assert: (savedRbClass classVariableNames) = (OrderedCollection newFrom: #('Cls1')).  
    self assert: (savedRbClass instanceVariableNames) = (OrderedCollection newFrom: #('inst1' 'inst2')).  
    self assert: (savedRbClass poolDictionaryNames) = (OrderedCollection newFrom: #('poolDict1')).  
    self assert: (savedRbClass superclass name) = #Object.
    self assert: (savedRbClass package) = #some_package.

    "Created: / 04-11-2014 / 00:17:12 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 25-01-2015 / 13:25:34 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_compile_with_rb_namespace
    | lastChange savedRbClass customModel |

    customModel := RBNamespace new.

    rbClass
        model: customModel;
        name: #SomeClass;
        superclassName: #Object;
        instVarNames: #('inst1' 'inst2');
        classVariableNames: #('Cls1');
        poolDictionaryNames: (Array with: 'poolDict1');
        category: 'Some-Test-Category';
        package: #some_package;
        compile.  

    customModel changes do: [ :change |
        lastChange := change
    ].

    savedRbClass := customModel classNamed: #SomeClass.

    self assert: (lastChange isKindOf: AddClassChange).  
    self assert: (lastChange changeClassName) = #SomeClass.  
    self assert: (lastChange category) = 'Some-Test-Category'.  
    self assert: (lastChange classVariableNames) = (#('Cls1') asStringCollection).  
    self assert: (lastChange instanceVariableNames) = (#('inst1' 'inst2') asStringCollection).  
    self assert: (lastChange poolDictionaryNames) = (OrderedCollection newFrom: #('poolDict1')).  
    self assert: (lastChange superclassName) = #Object.  
    self assert: (lastChange package) = #some_package.  

    self assert: (savedRbClass isKindOf: RBClass).  
    self assert: (savedRbClass name) = #SomeClass.  
    self assert: (savedRbClass category) = 'Some-Test-Category'.  
    self assert: (savedRbClass classVariableNames) = (OrderedCollection newFrom: #('Cls1')).  
    self assert: (savedRbClass instanceVariableNames) = (OrderedCollection newFrom: #('inst1' 'inst2')).  
    self assert: (savedRbClass poolDictionaryNames) = (OrderedCollection newFrom: #('poolDict1')).  
    self assert: (savedRbClass superclass name) = #Object.
    self assert: (savedRbClass package) = #some_package.

    "Created: / 04-11-2014 / 00:17:41 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 25-01-2015 / 13:25:53 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_real_class_with_set_package
    | savedRbClass expectedPackage |

    expectedPackage := self class package deepCopy.

    self assert: expectedPackage notEmpty.

    rbClass := RBClass existingNamed: self class name.

    savedRbClass := model classNamed: self class name.

    self assert: (savedRbClass isKindOf: RBClass).
    self assert: (savedRbClass package) = expectedPackage.

    "Created: / 09-10-2014 / 23:58:59 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 25-01-2015 / 15:37:16 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_the_metaclass_for_new_class
    | expectedMetaName actualMetaName |

    "Should be 'SomeTestClass class', but if we change it 
    then some could be broken"
    expectedMetaName := #SomeTestClass.

    rbClass
        name: #SomeTestClass;
        classVariableNames: #();
        poolDictionaryNames: #();
        compile. 

    actualMetaName := rbClass theMetaclass name.

    self assert: expectedMetaName = actualMetaName

    "Created: / 08-10-2014 / 12:06:30 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_the_metaclass_for_real_class
    | expectedMetaName actualMetaName |

    "Should be 'SomeTestClass class', but if we change it 
    then some could be broken"
    expectedMetaName := #Object.

    rbClass 
        realName: #Object;
        name: #Object;
        compile.

    actualMetaName := rbClass theMetaclass name.

    self assert: expectedMetaName = actualMetaName

    "Created: / 08-10-2014 / 12:16:59 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 08-10-2014 / 13:42:49 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomRBClassTests class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

