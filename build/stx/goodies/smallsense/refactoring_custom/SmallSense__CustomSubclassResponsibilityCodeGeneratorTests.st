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

CustomCodeGeneratorOrRefactoringTestCase subclass:#CustomSubclassResponsibilityCodeGeneratorTests
	instanceVariableNames:'mockSuperClass mockClass'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Generators-Tests'
!

!CustomSubclassResponsibilityCodeGeneratorTests class methodsFor:'documentation'!

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

!CustomSubclassResponsibilityCodeGeneratorTests methodsFor:'accessing'!

generatorOrRefactoring

    ^ CustomSubclassResponsibilityCodeGenerator new

    "Created: / 29-08-2014 / 21:41:14 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomSubclassResponsibilityCodeGeneratorTests methodsFor:'initialization & release'!

setUp

    super setUp.
    mockSuperClass := model createClassImmediate: 'MockSuperClassForTestCase' superClassName: 'Object'.
    mockClass := model createClassImmediate: 'MockClassForTestCase' superClassName: (mockSuperClass new className).

    "Created: / 14-04-2014 / 17:16:28 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 29-08-2014 / 21:39:57 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomSubclassResponsibilityCodeGeneratorTests methodsFor:'tests'!

test_determine_is_class_abstract_model_class
    | expectedIsAbstract actualIsAbstract class |

    class := model createClass
        name: #DummyClass01;
        compile;
        yourself.

    expectedIsAbstract := false.
    generatorOrRefactoring determineIsClassAbstract: class.
    actualIsAbstract := class isAbstract.
    
    self assert: expectedIsAbstract = actualIsAbstract

    "Created: / 14-12-2014 / 23:46:38 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_determine_is_class_abstract_real_abstract_class_wrapped_with_model_class
    | expectedIsAbstract actualIsAbstract class realClass |

    realClass := model createClassImmediate: #DummyClass01.
    model createMethodImmediate: realClass class source: 'isAbstract ^ true'.

    class := model classNamed: #DummyClass01.
    expectedIsAbstract := true.
    generatorOrRefactoring determineIsClassAbstract: class.
    actualIsAbstract := class isAbstract.
    
    self assert: expectedIsAbstract = actualIsAbstract

    "Created: / 14-12-2014 / 23:45:11 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_determine_is_class_abstract_real_class
    | expectedIsAbstract actualIsAbstract |

    expectedIsAbstract := false.
    generatorOrRefactoring determineIsClassAbstract: self class.
    actualIsAbstract := self class isAbstract.
    
    self assert: expectedIsAbstract = actualIsAbstract

    "Modified: / 14-12-2014 / 23:35:29 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_determine_is_class_abstract_real_class_wrapped_with_model_class
    | expectedIsAbstract actualIsAbstract class |

    class := model classNamed: self class name.
    expectedIsAbstract := false.
    generatorOrRefactoring determineIsClassAbstract: class.
    actualIsAbstract := class isAbstract.
    
    self assert: expectedIsAbstract = actualIsAbstract

    "Created: / 14-12-2014 / 23:38:39 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_none_subclass_responsibility

    context selectedClasses: (Array with: mockClass).

    model createMethodImmediate: mockSuperClass protocol: 'instance-protocol' source: 'instanceMethod: aParam
    ^ self'.

    self assert: (mockClass includesSelector: #instanceMethod:) not. 
    self assert: (mockClass class includesSelector: #instanceMethod:) not.

    generatorOrRefactoring executeInContext: context.

    self assert: (mockClass includesSelector: #instanceMethod:) not.
    self assert: (mockClass class includesSelector: #instanceMethod:) not.

    "Created: / 13-05-2014 / 21:49:38 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 25-11-2014 / 20:12:33 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_subclass_responsibility_class_method
    | expectedSource |

    context selectedClasses: (Array with: mockClass).

    model createMethodImmediate: mockSuperClass class protocol: 'class-protocol' source: 'classMethod: aParam
    self subclassResponsibility'.

    self assert: (mockClass includesSelector: #classMethod:) not.
    self assert: (mockClass class includesSelector: #classMethod:) not.

    generatorOrRefactoring executeInContext: context.

    self assert: (mockClass includesSelector: #classMethod:) not.
    self assert: (mockClass class includesSelector: #classMethod:). 

    expectedSource := 'classMethod:aParam
    self shouldImplement'.

    self assertMethodSource: expectedSource atSelector: #classMethod: forClass: mockClass class.

    "Created: / 15-04-2014 / 22:05:19 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 25-11-2014 / 20:12:27 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_subclass_responsibility_instance_method

    |expectedSource|

    context selectedClasses: (Array with: mockClass).

    model createMethodImmediate: mockSuperClass protocol: 'instance-protocol' source: 'instanceMethod: aParam
    self subclassResponsibility'.

    self assert: (mockClass includesSelector: #instanceMethod:) not. 
    self assert: (mockClass class includesSelector: #instanceMethod:) not.

    generatorOrRefactoring executeInContext: context.

    self assert: (mockClass includesSelector: #instanceMethod:).
    self assert: (mockClass class includesSelector: #instanceMethod:) not.

    expectedSource := 'instanceMethod:aParam
    self shouldImplement'.

    self assertMethodSource: expectedSource atSelector: #instanceMethod: forClass: mockClass.

    "Created: / 14-04-2014 / 18:10:52 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 25-11-2014 / 20:12:12 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomSubclassResponsibilityCodeGeneratorTests class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

