"
jv:libgdbs - GNU Debugger Interface Library
Copyright (C) 2015-now Jan Vrany

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
"{ Package: 'jv:libgdbs/tests' }"

"{ NameSpace: Smalltalk }"

TestResource subclass:#GDBDebuggeesResource
	instanceVariableNames:''
	classVariableNames:'DotExe'
	poolDictionaries:''
	category:'GDB-Core-Tests'
!

!GDBDebuggeesResource class methodsFor:'documentation'!

copyright
"
jv:libgdbs - GNU Debugger Interface Library
Copyright (C) 2015-now Jan Vrany

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

!GDBDebuggeesResource class methodsFor:'initialization'!

initialize
    DotExe := OperatingSystem isMSWINDOWSlike ifTrue:['.exe'] ifFalse:['']

! !

!GDBDebuggeesResource methodsFor:'accessing'!

binary: aString
    | binary |

    binary := (Smalltalk getPackageDirectoryForPackage:self class package)
            / 'c' / Smalltalk configuration / (aString , DotExe).
    self assert:binary exists.
    self assert:binary isExecutable.
    ^ binary pathName

!

binaryBreakpoints1
    ^ self binary: 'breakpoints1'

    "Created: / 18-05-2018 / 10:51:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

binaryFactorial1
    ^ self binary: 'factorial1'

    "Created: / 28-02-2015 / 00:47:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-07-2017 / 11:52:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-01-2018 / 12:43:37 / jv"
!

binaryPressAnyKey
    ^ self binary: 'press_any_key'.

    "Created: / 08-03-2015 / 07:24:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-01-2018 / 12:43:55 / jv"
!

binaryPyVarobj
    ^ self binary: 'py-varobj'

    "Created: / 01-06-2018 / 16:25:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

binaryVariables1
    ^ self binary: 'variables1'

    "Created: / 30-01-2018 / 10:25:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBDebuggeesResource class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


GDBDebuggeesResource initialize!
