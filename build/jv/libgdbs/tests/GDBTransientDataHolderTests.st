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

TestCase subclass:#GDBTransientDataHolderTests
	instanceVariableNames:'seqNo'
	classVariableNames:''
	poolDictionaries:'GDBCommandStatus'
	category:'GDB-Private-Tests'
!

!GDBTransientDataHolderTests class methodsFor:'documentation'!

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

!GDBTransientDataHolderTests methodsFor:'private'!

currentInferiorStateSequnceNumber
    ^ seqNo

    "Created: / 30-01-2018 / 08:13:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBTransientDataHolderTests methodsFor:'running'!

setUp
    seqNo := 0

    "Created: / 30-01-2018 / 08:13:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBTransientDataHolderTests methodsFor:'tests'!

test_01
    | holder value evaluated |

    value := 0.
    evaluated := false.
    holder := GDBTransientDataHolder debugger: self factory: [ evaluated := true. value ].

    self assert: holder value == 0.
    self assert: evaluated.


    "/ factory should not be evaluated and old value should
    "/ bre returned since sequence number has not changed.
    evaluated := false. value := 1.
    self assert: holder value == 0.
    self assert: evaluated not.
    self assert: holder value == 0.
    self assert: evaluated not.

    "/ change the sequence number a check the value has been
    "/ rreevaluated
    seqNo := seqNo + 1.
    self assert: holder value == 1.
    self assert: evaluated.

    "Created: / 30-01-2018 / 08:11:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_02
    | holder value token evaluated |

    value := 0.
    token := Object new.
    evaluated := false.
    holder := GDBTransientDataHolder debugger: self factory: [ evaluated := true. holder value: token. value ].

    self assert: holder value == token.
    self assert: evaluated.


    "/ factory should not be evaluated and old value should
    "/ bre returned since sequence number has not changed.
    evaluated := false. value := 1.
    self assert: holder value == token.
    self assert: evaluated not.
    self assert: holder value == token.
    self assert: evaluated not.

    "/ change the sequence number a check the value has been
    "/ rreevaluated
    seqNo := seqNo + 1.
    evaluated := false. value := 1. token := Object new.
    self assert: holder value == token.
    self assert: evaluated.

    "Created: / 30-01-2018 / 09:08:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_03
    | holder evaluated |

    evaluated := false.
    holder := GDBTransientDataHolder debugger: self factory: [ :old | evaluated := true. old notNil ifTrue:[ old + 1 ] ifFalse: [ 100 ] ].

    self assert: holder value == 100.
    self assert: evaluated.

    "/ factory should not be evaluated and old value should
    "/ bre returned since sequence number has not changed.
    evaluated := false. 
    self assert: holder value == 100.
    self assert: evaluated not.
    self assert: holder value == 100.
    self assert: evaluated not.

    "/ change the sequence number a check the value has been
    "/ rreevaluated
    seqNo := seqNo + 1.
    evaluated := false. 
    self assert: holder value == 101.
    self assert: evaluated.

    "/ factory should not be evaluated and old value should
    "/ bre returned since sequence number has not changed.
    evaluated := false. 
    self assert: holder value == 101.
    self assert: evaluated not.
    self assert: holder value == 101.
    self assert: evaluated not.

    "Created: / 31-01-2018 / 09:26:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBTransientDataHolderTests class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

