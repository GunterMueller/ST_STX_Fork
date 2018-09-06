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

CustomCodeGeneratorOrRefactoringTestCase subclass:#CustomAddMethodChangeTests
	instanceVariableNames:'class change'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Tests'
!

!CustomAddMethodChangeTests class methodsFor:'documentation'!

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

!CustomAddMethodChangeTests methodsFor:'accessing'!

generatorOrRefactoring

    ^ nil

    "Created: / 16-10-2014 / 22:57:19 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomAddMethodChangeTests methodsFor:'initialize & release'!

setUp
    super setUp.

    class := model createClassImmediate: 'DummyTestClass01'.  
    change := AddMethodChange compile: 'selector_01 ^ 1' in: class.

    "Modified: / 17-10-2014 / 09:31:51 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomAddMethodChangeTests methodsFor:'tests'!

test_as_undo_operation_new_package_nil

    | undo |

    model createMethodImmediate: class 
        protocol: 'a protocol' 
        source: 'selector_01 ^ 555' 
        package: #some_package01.

    self assertMethodSource: 'selector_01 ^ 555' atSelector: #selector_01 forClass: class.

    change package: nil.
    undo := change execute. "calls internally asUndoOperation"

    self assertMethodSource: 'selector_01 ^ 1' atSelector: #selector_01 forClass: class.

    self assert: #some_package01 = ((class compiledMethodAt: #selector_01) package).

    undo execute.

    self assertMethodSource: 'selector_01 ^ 555' atSelector: #selector_01 forClass: class.
    self assert: #some_package01 = ((class compiledMethodAt: #selector_01) package).

    "Created: / 17-10-2014 / 10:39:38 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_as_undo_operation_new_package_not_set

    | undo |

    model createMethodImmediate: class 
        protocol: 'a protocol' 
        source: 'selector_01 ^ 555' 
        package: #some_package01.

    self assertMethodSource: 'selector_01 ^ 555' atSelector: #selector_01 forClass: class.

    undo := change execute. "calls internally asUndoOperation"

    self assertMethodSource: 'selector_01 ^ 1' atSelector: #selector_01 forClass: class.

    self assert: #some_package01 = ((class compiledMethodAt: #selector_01) package).

    undo execute.

    self assertMethodSource: 'selector_01 ^ 555' atSelector: #selector_01 forClass: class.
    self assert: #some_package01 = ((class compiledMethodAt: #selector_01) package).

    "Created: / 17-10-2014 / 10:43:01 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_as_undo_operation_old_package_different_from_new_package

    | undo |

    model createMethodImmediate: class 
        protocol: 'a protocol' 
        source: 'selector_01 ^ 555' 
        package: #some_package02.

    self assertMethodSource: 'selector_01 ^ 555' atSelector: #selector_01 forClass: class.

    change package: #some_package01.
    undo := change execute. "calls internally asUndoOperation"

    self assertMethodSource: 'selector_01 ^ 1' atSelector: #selector_01 forClass: class.

    self assert: #some_package01 = ((class compiledMethodAt: #selector_01) package).

    undo execute.

    self assertMethodSource: 'selector_01 ^ 555' atSelector: #selector_01 forClass: class.
    self assert: #some_package02 = ((class compiledMethodAt: #selector_01) package).

    "Created: / 17-10-2014 / 10:38:22 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_as_undo_operation_old_package_nil

    | undo |

    model createMethodImmediate: class 
        protocol: 'a protocol' 
        source: 'selector_01 ^ 555' 
        package: nil.

    self assertMethodSource: 'selector_01 ^ 555' atSelector: #selector_01 forClass: class.

    change package: #some_package01.
    undo := change execute. "calls internally asUndoOperation"

    self assertMethodSource: 'selector_01 ^ 1' atSelector: #selector_01 forClass: class.

    self assert: #some_package01 = ((class compiledMethodAt: #selector_01) package).

    undo execute.

    self assertMethodSource: 'selector_01 ^ 555' atSelector: #selector_01 forClass: class.
    self assert: (PackageId noProjectID) = ((class compiledMethodAt: #selector_01) package).

    "Created: / 17-10-2014 / 10:37:05 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_as_undo_operation_old_package_same_as_new

    | undo |

    model createMethodImmediate: class 
        protocol: 'a protocol' 
        source: 'selector_01 ^ 555' 
        package: #some_package01.

    self assertMethodSource: 'selector_01 ^ 555' atSelector: #selector_01 forClass: class.

    change package: #some_package01.
    undo := change execute. "calls internally asUndoOperation"

    self assertMethodSource: 'selector_01 ^ 1' atSelector: #selector_01 forClass: class.

    self assert: #some_package01 = ((class compiledMethodAt: #selector_01) package).

    undo execute.

    self assertMethodSource: 'selector_01 ^ 555' atSelector: #selector_01 forClass: class.
    self assert: #some_package01 = ((class compiledMethodAt: #selector_01) package).

    "Created: / 17-10-2014 / 10:08:49 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_as_undo_operation_old_package_same_as_new_with_redo

    | undo redo |

    model createMethodImmediate: class 
        protocol: 'a protocol' 
        source: 'selector_01 ^ 555' 
        package: #some_package01.

    self assertMethodSource: 'selector_01 ^ 555' atSelector: #selector_01 forClass: class.

    change package: #some_package01.
    undo := change execute. "calls internally asUndoOperation"

    self assertMethodSource: 'selector_01 ^ 1' atSelector: #selector_01 forClass: class.

    self assert: #some_package01 = ((class compiledMethodAt: #selector_01) package).

    redo := undo execute.

    self assertMethodSource: 'selector_01 ^ 555' atSelector: #selector_01 forClass: class.
    self assert: #some_package01 = ((class compiledMethodAt: #selector_01) package).

    redo execute.

    self assertMethodSource: 'selector_01 ^ 1' atSelector: #selector_01 forClass: class.
    self assert: #some_package01 = ((class compiledMethodAt: #selector_01) package).

    "Created: / 17-10-2014 / 22:14:37 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_get_and_set_package

    self assert: change package isNil.

    change package: #some_package01.

    self assert: #some_package01 = (change package).

    "Created: / 17-10-2014 / 09:35:22 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomAddMethodChangeTests class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

