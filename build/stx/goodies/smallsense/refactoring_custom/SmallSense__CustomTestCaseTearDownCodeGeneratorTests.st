"
A custom code generation and refactoring support for Smalltalk/X
Copyright (C) 2013-2015 Jakub Nesveda
Copyright (C) 2015-2016 Jan Vrany

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

CustomCodeGeneratorOrRefactoringTestCase subclass:#CustomTestCaseTearDownCodeGeneratorTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Generators-Tests'
!

!CustomTestCaseTearDownCodeGeneratorTests class methodsFor:'documentation'!

copyright
"
A custom code generation and refactoring support for Smalltalk/X
Copyright (C) 2013-2015 Jakub Nesveda
Copyright (C) 2015-2016 Jan Vrany

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

!CustomTestCaseTearDownCodeGeneratorTests methodsFor:'accessing'!

generatorOrRefactoring
    ^ CustomTestCaseTearDownCodeGenerator new
! !

!CustomTestCaseTearDownCodeGeneratorTests methodsFor:'tests'!

test_tear_down_method_generated_default_package
    | expectedPackage class actualPackage |

    class := model createClass
        name: #DummyTestCase01;
        superclassName: #TestCase;
        package: #dummy_package01;
        compile;
        yourself. 

    context selectedClasses: {class}.  

    expectedPackage := #dummy_package01.
    generatorOrRefactoring executeInContext: context.
    actualPackage := ((Smalltalk at: #DummyTestCase01) compiledMethodAt: #tearDown) package.  
    self assert: expectedPackage = actualPackage

    "Created: / 31-01-2015 / 21:41:26 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_tear_down_method_generated_not_same_package
    | expectedPackage class actualPackage |

    class := model createClass
        name: #DummyTestCase01;
        superclassName: #TestCase;
        package: #dummy_package01;
        compile;
        yourself. 

    context selectedClasses: {class}.  

    expectedPackage := PackageId noProjectID.
    generatorOrRefactoring samePackageAsTestedClass: false.  
    generatorOrRefactoring executeInContext: context.
    actualPackage := ((Smalltalk at: #DummyTestCase01) compiledMethodAt: #tearDown) package.  
    self assert: expectedPackage = actualPackage

    "Created: / 31-01-2015 / 21:42:32 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_tear_down_method_generated_same_method_protocol  
    | class expectedCategory actualCategory |

    class := model createClass
        name: #DummyTestCase01;
        superclassName: #TestCase;
        compile;
        yourself. 

    context selectedClasses: {class}.  

    expectedCategory := ((Smalltalk at:#TestCase) compiledMethodAt: #tearDown) category.
    generatorOrRefactoring executeInContext: context.
    actualCategory := ((Smalltalk at: #DummyTestCase01) compiledMethodAt: #tearDown) category.
    self assert: expectedCategory = actualCategory

    "Created: / 31-01-2015 / 21:42:23 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 12-06-2015 / 20:47:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_tear_down_method_generated_same_package
    | expectedPackage class actualPackage |

    class := model createClass
        name: #DummyTestCase01;
        superclassName: #TestCase;
        package: #dummy_package01;
        compile;
        yourself. 

    context selectedClasses: {class}.  

    expectedPackage := #dummy_package01.
    generatorOrRefactoring samePackageAsTestedClass: true.  
    generatorOrRefactoring executeInContext: context.
    actualPackage := ((Smalltalk at: #DummyTestCase01) compiledMethodAt: #tearDown) package.  
    self assert: expectedPackage = actualPackage

    "Created: / 31-01-2015 / 21:42:12 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_tear_down_method_generated_tear_down_implemented
    | expectedSource class |

    class := model createClass
        name: #DummyTestCase01;
        superclassName: #TestCase;
        compile;
        yourself. 

    context selectedClasses: {class}.  

    expectedSource := 'tearDown
    "Add your own code here..."

    super tearDown.'.
    generatorOrRefactoring executeInContext: context.  
    self assertMethodSource: expectedSource atSelector: #tearDown forClass: class

    "Created: / 31-01-2015 / 21:42:03 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_tear_down_method_generated_tear_down_not_implemented
    | expectedSource class |

    class := model createClass
        name: #DummyTestCase01;
        compile;
        yourself.

    context selectedClasses: {class}.  

    expectedSource := 'tearDown
    "Add your own code here..."
    "/ super tearDown.'.
    generatorOrRefactoring buildForClass: class.  
    self assertMethodSource: expectedSource atSelector: #tearDown forClass: class

    "Created: / 31-01-2015 / 21:41:48 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

