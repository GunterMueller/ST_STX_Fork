"
A custom code generation and refactoring support for Smalltalk/X
Copyright (C) 2013-2015 Jakub Nesveda
Copyright (C) 2015 Jan Vrany
Copyright (C) 2017 Jan Vrany

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

CustomTestCaseSetUpCodeGenerator subclass:#CustomUITestCaseSetUpCodeGenerator
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Generators'
!

!CustomUITestCaseSetUpCodeGenerator class methodsFor:'documentation'!

copyright
"
A custom code generation and refactoring support for Smalltalk/X
Copyright (C) 2013-2015 Jakub Nesveda
Copyright (C) 2015 Jan Vrany
Copyright (C) 2017 Jan Vrany

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

!CustomUITestCaseSetUpCodeGenerator class methodsFor:'accessing-presentation'!

description
    ^ 'Generates initial #setUp for UI test cases'

    "Created: / 16-09-2014 / 11:24:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

label
    ^ 'TestCase setUp method (for UI Test Cases)'

    "Created: / 16-09-2014 / 11:23:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CustomUITestCaseSetUpCodeGenerator methodsFor:'private'!

methodSource:callSuper 
    | source |

    callSuper ifTrue:[
        source := 'setUp
    self skipIf: Screen current isNil description: ''No display connection''.
    Smalltalk loadPackage: ''stx:goodies/sunit/ext/ui''.
    super setUp.

    "Add your own code here..."
'.
    ] ifFalse:[
        source := 'setUp
    self skipIf: Screen current isNil description: ''No display connection''.
    Smalltalk loadPackage: ''stx:goodies/sunit/ext/ui''.
    "/ super setUp.

    "Add your own code here..."
'.
    ].
    ^ source

    "Created: / 07-08-2017 / 15:09:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CustomUITestCaseSetUpCodeGenerator class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

