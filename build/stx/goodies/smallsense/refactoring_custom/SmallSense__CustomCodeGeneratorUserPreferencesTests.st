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

CustomCodeGeneratorOrRefactoringTestCase subclass:#CustomCodeGeneratorUserPreferencesTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Tests'
!

!CustomCodeGeneratorUserPreferencesTests class methodsFor:'documentation'!

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

!CustomCodeGeneratorUserPreferencesTests methodsFor:'accessing'!

generatorOrRefactoring
    ^ nil

    "Modified: / 09-06-2014 / 22:42:50 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomCodeGeneratorUserPreferencesTests methodsFor:'tests'!

test_user_preferences_same_for_tests

    self assert: userPreferences generateComments.
    self assert: userPreferences generateCommentsForAspectMethods.
    self assert: userPreferences generateCommentsForGetters.
    self assert: userPreferences generateCommentsForSetters.

    "Created: / 09-06-2014 / 22:29:31 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 25-01-2015 / 15:49:50 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

