"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2015 Jan Vrany

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
"{ Package: 'stx:goodies/smallsense' }"

"{ NameSpace: SmallSense }"

Smalltalk::TestCase subclass:#SmalltalkInferencerTests
	instanceVariableNames:'inferencer manager'
	classVariableNames:''
	poolDictionaries:''
	category:'SmallSense-Tests'
!

!SmalltalkInferencerTests class methodsFor:'documentation'!

copyright
"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2015 Jan Vrany

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

!SmalltalkInferencerTests methodsFor:'running'!

setUp
    manager := SmallSense::Manager new.
    inferencer := SmallSense::SmalltalkInferencer new.
    inferencer manager: manager.

    "Created: / 21-08-2015 / 14:28:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

tearDown
    manager := inferencer := nil

    "Created: / 21-08-2015 / 14:33:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SmalltalkInferencerTests methodsFor:'tests'!

test_self_01
    | tree |

    inferencer class: self class source: 'foo ^ self bar'.
    tree := inferencer process.

    self assert: tree expression receiver inferedType type isClassType.
    self assert: tree expression receiver inferedType type klass == self class

    "Created: / 21-08-2015 / 16:13:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_self_02
    | tree |

    inferencer class: self class source: 'foo self sub'.
    tree := inferencer process.

    self assert: tree expression receiver inferedType type isClassType.
    self assert: tree expression receiver inferedType type klass == self class

    "Created: / 21-08-2015 / 16:13:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

