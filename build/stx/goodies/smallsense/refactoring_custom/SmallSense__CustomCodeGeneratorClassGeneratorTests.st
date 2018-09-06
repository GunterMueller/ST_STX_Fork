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

CustomCodeGeneratorOrRefactoringTestCase subclass:#CustomCodeGeneratorClassGeneratorTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Generators-Tests'
!

!CustomCodeGeneratorClassGeneratorTests class methodsFor:'documentation'!

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

!CustomCodeGeneratorClassGeneratorTests methodsFor:'accessing'!

generatorOrRefactoring

    ^ CustomCodeGeneratorClassGenerator new

    "Created: / 27-09-2014 / 11:27:33 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 12-11-2014 / 23:17:51 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomCodeGeneratorClassGeneratorTests methodsFor:'tests'!

test_code_generator_class_created

    | newGenerator testClassName |

    testClassName := #SmallSense::CustomCodeGeneratorForTestCase.

    self assertClassNotExists: testClassName.

    generatorOrRefactoring dialog answer: testClassName forSelector: #requestClassName:initialAnswer:.

    generatorOrRefactoring executeInContext: CustomBrowserContext new.

    newGenerator := Smalltalk classNamed: testClassName.

    self assertClassExists: testClassName.
    self assert: (newGenerator includesSelector: #buildInContext:).
    self assert: (newGenerator class includesSelector: #buildInContext:) not.
    self assert: (newGenerator includesSelector: #availableInContext:) not.
    self assert: (newGenerator class includesSelector: #availableInContext:).

    "Created: / 31-03-2014 / 23:20:33 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 12-11-2014 / 23:22:59 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 12-06-2015 / 20:49:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CustomCodeGeneratorClassGeneratorTests class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

