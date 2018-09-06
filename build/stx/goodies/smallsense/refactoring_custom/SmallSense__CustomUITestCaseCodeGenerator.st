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

CustomTestCaseCodeGenerator subclass:#CustomUITestCaseCodeGenerator
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Generators'
!

!CustomUITestCaseCodeGenerator class methodsFor:'documentation'!

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

!CustomUITestCaseCodeGenerator class methodsFor:'accessing-presentation'!

description
    ^ 'Creates a new test case for UI'

    "Created: / 16-09-2014 / 11:33:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

label
    "Returns show label describing the receiver. This label
     is used in UI as menu item/tree item label."

    ^ 'New UI Test Case'

    "Created: / 16-09-2014 / 11:23:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CustomUITestCaseCodeGenerator methodsFor:'accessing - defaults'!

defaultGenerateSetUp
    ^ true

    "Created: / 16-09-2014 / 11:26:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

defaultSetUpCodeGeneratorClass
    ^ CustomUITestCaseSetUpCodeGenerator

    "Created: / 16-09-2014 / 11:20:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CustomUITestCaseCodeGenerator class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

