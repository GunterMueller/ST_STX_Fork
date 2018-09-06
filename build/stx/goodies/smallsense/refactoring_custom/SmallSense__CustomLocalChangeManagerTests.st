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

Smalltalk::TestCase subclass:#CustomLocalChangeManagerTests
	instanceVariableNames:'changeManager'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Tests'
!

!CustomLocalChangeManagerTests class methodsFor:'documentation'!

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

!CustomLocalChangeManagerTests methodsFor:'initialization & release'!

setUp
    super setUp.

    changeManager := CustomLocalChangeManager new.

    "Modified: / 30-11-2014 / 17:32:31 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

tearDown
    super tearDown.

    (Smalltalk at: #DummyClass01) notNil ifTrue: [ 
        Class withoutUpdatingChangesDo: [ 
            (Smalltalk at: #DummyClass01) removeFromSystem
        ]
    ]

    "Created: / 30-11-2014 / 17:40:11 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomLocalChangeManagerTests methodsFor:'private'!

lastChangeInRefactoryChangeManagerAt: aSelector

    ^ [ 
        RefactoryChangeManager instance perform: aSelector
    ] on: Collection emptyCollectionSignal do: [ 
        nil
    ]

    "Created: / 30-11-2014 / 18:09:24 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomLocalChangeManagerTests methodsFor:'tests'!

test_perform_change_with_nothing_external_modified
    | expectedUndo expectedRedo actualUndo actualRedo expectedChangeContents actualChangeContents |

    expectedUndo := self lastChangeInRefactoryChangeManagerAt: #undoChange.
    expectedRedo := self lastChangeInRefactoryChangeManagerAt: #redoChange.
    expectedChangeContents := ObjectMemory nameForChanges asFilename contents.

    self assert: (Smalltalk at: #DummyClass01) isNil.

    changeManager performChange: (AddClassChange definition: 'Object subclass:#DummyClass01
        instanceVariableNames:''''
        classVariableNames:''''
        poolDictionaries:''''
        category:'''' 
    ').

    self assert: (Smalltalk at: #DummyClass01) notNil.

    changeManager undoChanges.

    self assert: (Smalltalk at: #DummyClass01) isNil.

    actualUndo := self lastChangeInRefactoryChangeManagerAt: #undoChange.
    actualRedo := self lastChangeInRefactoryChangeManagerAt: #redoChange.
    actualChangeContents := ObjectMemory nameForChanges asFilename contents.

    self assert: expectedRedo == actualRedo.
    self assert: expectedUndo == actualUndo.
    self assert: expectedChangeContents = actualChangeContents.

    "Modified: / 30-11-2014 / 18:20:20 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

