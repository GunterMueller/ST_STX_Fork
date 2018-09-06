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

Smalltalk::TestCase subclass:#CustomBrowserEnvironmentTests
	instanceVariableNames:'environment'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Tests'
!

!CustomBrowserEnvironmentTests class methodsFor:'documentation'!

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

!CustomBrowserEnvironmentTests methodsFor:'initialization & release'!

setUp

    environment := BrowserEnvironment new.

    "Modified: / 05-11-2014 / 21:29:20 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomBrowserEnvironmentTests methodsFor:'tests'!

test_which_category_includes_existing_class
    | expectedCategory actualCategory className |

    expectedCategory := self class category.

    className := self class name.
    actualCategory := environment whichCategoryIncludes: className.

    self assert: expectedCategory = actualCategory.

    "Created: / 05-11-2014 / 21:33:34 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_which_category_includes_non_existing_class
    | expectedCategory actualCategory className |

    expectedCategory := nil.

    className := #DummyClassForTestCase01.
    self assert: (Smalltalk at: className) isNil.

    actualCategory := environment whichCategoryIncludes: className.

    self assert: expectedCategory = actualCategory.

    "Created: / 05-11-2014 / 21:32:27 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

