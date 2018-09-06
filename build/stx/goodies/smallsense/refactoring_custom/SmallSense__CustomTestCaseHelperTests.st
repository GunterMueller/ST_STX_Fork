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

Smalltalk::TestCase subclass:#CustomTestCaseHelperTests
	instanceVariableNames:'testCaseHelper'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Helpers-Tests'
!

!CustomTestCaseHelperTests class methodsFor:'documentation'!

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

!CustomTestCaseHelperTests methodsFor:'initialization & release'!

setUp
    super setUp.

    testCaseHelper := CustomTestCaseHelper new

    "Modified: / 08-11-2014 / 21:11:09 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomTestCaseHelperTests methodsFor:'tests'!

test_test_category_ending_with_tests
    | expectedCategory actualCategory |

    expectedCategory := 'Some-Category-Tests'.
    actualCategory := testCaseHelper testCategory:'Some-Category-Tests'.    

    self assert: expectedCategory equals: actualCategory.

    "Created: / 30-08-2014 / 22:06:14 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 08-11-2014 / 21:13:10 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_test_category_ending_without_tests
    | expectedCategory actualCategory |

    expectedCategory := 'Some-Category-Tests'.
    actualCategory := testCaseHelper testCategory:'Some-Category'.    

    self assert: expectedCategory equals: actualCategory.

    "Created: / 30-08-2014 / 22:07:13 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 08-11-2014 / 21:13:18 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

