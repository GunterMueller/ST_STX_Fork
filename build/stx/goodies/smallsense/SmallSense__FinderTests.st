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

TestCase subclass:#FinderTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SmallSense-Tests-Obsolete'
!

!FinderTests class methodsFor:'documentation'!

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

!FinderTests methodsFor:'BeforeStatementTests'!

testBeforeStatement1
    |collector finder foundNode|

    collector := self 
                doForSource:'
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u.
                    d floor: 3 b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:2
                position:21
                tree:collector tree.
    self assert:(foundNode beforeStatement isNil).

    "Created: / 02-03-2011 / 20:02:25 / Jakub <zelenja7@fel.cvut.cz>"
!

testBeforeStatement10
    |collector finder foundNode|

    collector := self 
                doForSource:'
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u.
                    d floor: 3 b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:4
                position:21
                tree:collector tree.
    self assert:(foundNode beforeStatement notNil).
    self assert:(foundNode beforeStatement isAssignment).

    "Created: / 02-03-2011 / 20:16:47 / Jakub <zelenja7@fel.cvut.cz>"
!

testBeforeStatement11
    |collector finder foundNode|

    collector := self 
                doForSource:'
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u.
                    d floor: 3 b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:4
                position:23
                tree:collector tree.
    self assert:(foundNode beforeStatement notNil).
    self assert:(foundNode beforeStatement isVariable).

    "Created: / 02-03-2011 / 21:13:28 / Jakub <zelenja7@fel.cvut.cz>"
!

testBeforeStatement12
    |collector finder foundNode|

    collector := self 
                doForSource:'
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u.
                    d floor: 3 b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:4
                position:24
                tree:collector tree.
    self assert:(foundNode beforeStatement notNil).
    self assert:(foundNode beforeStatement isVariable).

    "Created: / 02-03-2011 / 21:13:46 / Jakub <zelenja7@fel.cvut.cz>"
!

testBeforeStatement13
    |collector finder foundNode|

    collector := self 
                doForSource:'
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u.
                    d floor: 3 b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:4
                position:25
                tree:collector tree.
    self assert:(foundNode beforeStatement notNil).
    self assert:(foundNode beforeStatement isVariable).

    "Created: / 02-03-2011 / 21:20:04 / Jakub <zelenja7@fel.cvut.cz>"
!

testBeforeStatement14
    |collector finder foundNode|

    collector := self 
                doForSource:'
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u.
                    d floor: 3 b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:4
                position:26
                tree:collector tree.
    self assert:(foundNode beforeStatement notNil).
    self assert:(foundNode beforeStatement isVariable).
    self assert:(foundNode beforeStatement name = 'u').

    "Created: / 02-03-2011 / 21:20:27 / Jakub <zelenja7@fel.cvut.cz>"
!

testBeforeStatement15
    |collector finder foundNode|

    collector := self 
                doForSource:'
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u.
                    d floor: 3 b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:4
                position:31
                tree:collector tree.
    self assert:(foundNode beforeStatement notNil).
    self assert:(foundNode beforeStatement isVariable).
    self assert:(foundNode beforeStatement name = 'u').

    "Created: / 02-03-2011 / 21:37:15 / Jakub <zelenja7@fel.cvut.cz>"
!

testBeforeStatement16
    |collector finder foundNode|

    collector := self 
                doForSource:'
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u.
                    d floor: 3 b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:4
                position:32
                tree:collector tree.
    self assert:(foundNode beforeStatement notNil).
    self assert:(foundNode beforeStatement isMessage).

    "Created: / 02-03-2011 / 21:37:39 / Jakub <zelenja7@fel.cvut.cz>"
!

testBeforeStatement17
    |collector finder foundNode|

    collector := self 
                doForSource:'
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u.
                    d floor: 3 b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:4
                position:33
                tree:collector tree.
    self assert:(foundNode beforeStatement notNil).
    self assert:(foundNode beforeStatement isMessage).

    "Created: / 02-03-2011 / 21:42:47 / Jakub <zelenja7@fel.cvut.cz>"
!

testBeforeStatement18
    |collector finder foundNode|

    collector := self 
                doForSource:'
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u.
                    d floor: 3 b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:4
                position:35
                tree:collector tree.
    self assert:(foundNode beforeStatement notNil).
    self assert:(foundNode beforeStatement isMessage).

    "Created: / 02-03-2011 / 21:44:49 / Jakub <zelenja7@fel.cvut.cz>"
!

testBeforeStatement19
    |collector finder foundNode|

    collector := self 
                doForSource:'
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u.
                    d floor: 3 b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:4
                position:36
                tree:collector tree.
    self assert:(foundNode beforeStatement notNil).
    self assert:(foundNode beforeStatement isMessage).

    "Created: / 02-03-2011 / 21:45:11 / Jakub <zelenja7@fel.cvut.cz>"
!

testBeforeStatement2
    |collector finder foundNode|

    collector := self 
                doForSource:'
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u.
                    d floor: 3 b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:2
                position:24
                tree:collector tree.
    self assert:(foundNode beforeStatement notNil).
    self assert:(foundNode beforeStatement isVariable).

    "Created: / 02-03-2011 / 20:02:40 / Jakub <zelenja7@fel.cvut.cz>"
!

testBeforeStatement20
    |collector finder foundNode|

    collector := self 
                doForSource:'
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u.
                    d floor: 3 b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:4
                position:38
                tree:collector tree.
    self assert:(foundNode beforeStatement notNil).
    self assert:(foundNode beforeStatement isMessage).

    "Created: / 02-03-2011 / 21:59:58 / Jakub <zelenja7@fel.cvut.cz>"
!

testBeforeStatement21
    |collector finder foundNode|

    collector := self 
                doForSource:'
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u.
                    d floor: 3 b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:4
                position:40
                tree:collector tree.
    self assert:(foundNode beforeStatement notNil).
    self assert:(foundNode beforeStatement isAssignment).

    "Created: / 02-03-2011 / 22:00:10 / Jakub <zelenja7@fel.cvut.cz>"
!

testBeforeStatement22
    |collector finder foundNode|

    collector := self 
                doForSource:'
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u.
                    d floor: 3 b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:5
                position:21
                tree:collector tree.
    self assert:(foundNode beforeStatement notNil).
    self assert:(foundNode beforeStatement isAssignment).

    "Created: / 02-03-2011 / 22:13:33 / Jakub <zelenja7@fel.cvut.cz>"
!

testBeforeStatement23
    |collector finder foundNode|

    collector := self 
                doForSource:'
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u.
                    d floor: 3 b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:5
                position:22
                tree:collector tree.
    self assert:(foundNode beforeStatement notNil).
    self assert:(foundNode beforeStatement isAssignment).

    "Created: / 02-03-2011 / 22:13:51 / Jakub <zelenja7@fel.cvut.cz>"
!

testBeforeStatement24
    |collector finder foundNode|

    collector := self 
                doForSource:'
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u.
                    d floor: 3 b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:5
                position:23
                tree:collector tree.
    self assert:(foundNode beforeStatement notNil).
    self assert:(foundNode beforeStatement isVariable).

    "Created: / 02-03-2011 / 22:14:12 / Jakub <zelenja7@fel.cvut.cz>"
!

testBeforeStatement25
    |collector finder foundNode|

    collector := self 
                doForSource:'
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u.
                    d floor: 3 b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:5
                position:29
                tree:collector tree.
    self assert:(foundNode beforeStatement notNil).
    self assert:(foundNode beforeStatement isVariable).

    "Created: / 02-03-2011 / 22:14:52 / Jakub <zelenja7@fel.cvut.cz>"
!

testBeforeStatement26
    |collector finder foundNode|

    collector := self 
                doForSource:'
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u.
                    d floor: 3 b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:5
                position:30
                tree:collector tree.
    self assert:(foundNode beforeStatement notNil).
    self assert:(foundNode beforeStatement isSelectorNode).

    "Created: / 02-03-2011 / 22:18:54 / Jakub <zelenja7@fel.cvut.cz>"
!

testBeforeStatement27
    |collector finder foundNode|

    collector := self 
                doForSource:'
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u.
                    d floor: 3 b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:5
                position:31
                tree:collector tree.
    self assert:(foundNode beforeStatement notNil).
    self assert:(foundNode beforeStatement isSelectorNode).

    "Created: / 02-03-2011 / 22:31:14 / Jakub <zelenja7@fel.cvut.cz>"
!

testBeforeStatement28
    |collector finder foundNode|

    collector := self 
                doForSource:'
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u.
                    d floor: 3 b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:5
                position:32
                tree:collector tree.
    self assert:(foundNode beforeStatement notNil).
    self assert:(foundNode beforeStatement isSelectorNode).

    "Created: / 02-03-2011 / 22:37:05 / Jakub <zelenja7@fel.cvut.cz>"
!

testBeforeStatement29
    |collector finder foundNode|

    collector := self 
                doForSource:'
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u .
                    d floor: 3 b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:5
                position:33
                tree:collector tree.
    self assert:(foundNode beforeStatement notNil).
    self assert:(foundNode beforeStatement isMessage).

    "Created: / 02-03-2011 / 22:37:13 / Jakub <zelenja7@fel.cvut.cz>"
!

testBeforeStatement3
    |collector finder foundNode|

    collector := self 
                doForSource:'
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u.
                    d floor: 3 b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:2
                position:26
                tree:collector tree.
    self assert:(foundNode beforeStatement notNil).
    self assert:(foundNode beforeStatement isVariable).

    "Created: / 02-03-2011 / 20:07:16 / Jakub <zelenja7@fel.cvut.cz>"
!

testBeforeStatement30
    |collector finder foundNode|

    collector := self 
                doForSource:'
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u .
                    d floor: 3 b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:5
                position:40
                tree:collector tree.
    self assert:(foundNode beforeStatement notNil).
    self assert:(foundNode beforeStatement isMessage).

    "Created: / 02-03-2011 / 22:37:57 / Jakub <zelenja7@fel.cvut.cz>"
!

testBeforeStatement31
    |collector finder foundNode|

    collector := self 
                doForSource:'
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u .
                    d floor: 3 b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:6
                position:21
                tree:collector tree.
    self assert:(foundNode beforeStatement notNil).
    self assert:(foundNode beforeStatement isMessage).

    "Created: / 02-03-2011 / 22:43:37 / Jakub <zelenja7@fel.cvut.cz>"
!

testBeforeStatement32
    |collector finder foundNode|

    collector := self 
                doForSource:'
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u .
                    d floor: 3 b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:6
                position:22
                tree:collector tree.
    self assert:(foundNode beforeStatement notNil).
    self assert:(foundNode beforeStatement isMessage).

    "Created: / 02-03-2011 / 22:44:37 / Jakub <zelenja7@fel.cvut.cz>"
!

testBeforeStatement33
    |collector finder foundNode|

    collector := self 
                doForSource:'
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u .
                    d  floor: 3 b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:6
                position:23
                tree:collector tree.
    self assert:(foundNode beforeStatement notNil).
    self assert:(foundNode beforeStatement isVariable).

    "Created: / 02-03-2011 / 22:44:48 / Jakub <zelenja7@fel.cvut.cz>"
!

testBeforeStatement34
    |collector finder foundNode|

    collector := self 
                doForSource:'
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u .
                    d  floor: 3 b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:6
                position:24
                tree:collector tree.
    self assert:(foundNode beforeStatement notNil).
    self assert:(foundNode beforeStatement isVariable).

    "Created: / 02-03-2011 / 22:51:21 / Jakub <zelenja7@fel.cvut.cz>"
!

testBeforeStatement35
    |collector finder foundNode|

    collector := self 
                doForSource:'
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u .
                    d  floor: 3 b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:6
                position:29
                tree:collector tree.
    self assert:(foundNode beforeStatement notNil).
    self assert:(foundNode beforeStatement isVariable).

    "Created: / 02-03-2011 / 22:51:33 / Jakub <zelenja7@fel.cvut.cz>"
!

testBeforeStatement36
    |collector finder foundNode|

    collector := self 
                doForSource:'
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u .
                    d  floor: 3 b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:6
                position:30
                tree:collector tree.
    self assert:(foundNode beforeStatement notNil).
    self assert:(foundNode beforeStatement isSelectorNode).

    "Created: / 02-03-2011 / 22:51:50 / Jakub <zelenja7@fel.cvut.cz>"
!

testBeforeStatement37
    |collector finder foundNode|

    collector := self 
                doForSource:'
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u .
                    d  floor: 3 b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:6
                position:31
                tree:collector tree.
    self assert:(foundNode beforeStatement notNil).
    self assert:(foundNode beforeStatement isSelectorNode).

    "Created: / 02-03-2011 / 22:52:09 / Jakub <zelenja7@fel.cvut.cz>"
!

testBeforeStatement38
    |collector finder foundNode|

    collector := self 
                doForSource:'
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u .
                    d  floor: 3 b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:6
                position:33
                tree:collector tree.
    self assert:(foundNode beforeStatement notNil).
    self assert:(foundNode beforeStatement isConstant).

    "Created: / 02-03-2011 / 22:52:39 / Jakub <zelenja7@fel.cvut.cz>"
!

testBeforeStatement39
    |collector finder foundNode|

    collector := self 
                doForSource:'
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u .
                    d  floor: 3 b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:6
                position:35
                tree:collector tree.
    self assert:(foundNode beforeStatement notNil).
    self assert:(foundNode beforeStatement isSelectorNode).

    "Created: / 02-03-2011 / 22:57:40 / Jakub <zelenja7@fel.cvut.cz>"
!

testBeforeStatement4
    |collector finder foundNode|

    collector := self 
                doForSource:'
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u.
                    d floor: 3 b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:2
                position:27
                tree:collector tree.
    self assert:(foundNode beforeStatement notNil).
    self assert:(foundNode beforeStatement isVariable).

    "Created: / 02-03-2011 / 20:07:32 / Jakub <zelenja7@fel.cvut.cz>"
!

testBeforeStatement40
    |collector finder foundNode|

    collector := self 
                doForSource:'
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u .
                    d  floor: 3 b:u .
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:6
                position:37
                tree:collector tree.
    self assert:(foundNode beforeStatement notNil).
    self assert:(foundNode beforeStatement isMessage).

    "Created: / 02-03-2011 / 22:58:16 / Jakub <zelenja7@fel.cvut.cz>"
!

testBeforeStatement41
    |collector finder foundNode|

    collector := self 
                doForSource:'
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u .
                    d  floor: 3 b:u .
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:7
                position:21
                tree:collector tree.
    self assert:(foundNode beforeStatement notNil).
    self assert:(foundNode beforeStatement isMessage).

    "Created: / 02-03-2011 / 22:58:46 / Jakub <zelenja7@fel.cvut.cz>"
!

testBeforeStatement42
    |collector finder foundNode|

    collector := self 
                doForSource:'
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u .
                    d  floor: 3 b:u .
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:7
                position:26
                tree:collector tree.
    self assert:(foundNode beforeStatement notNil).
    self assert:(foundNode beforeStatement isSelf).

    "Created: / 02-03-2011 / 22:59:09 / Jakub <zelenja7@fel.cvut.cz>"
!

testBeforeStatement43
    |collector finder foundNode|

    collector := self 
                doForSource:'
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u .
                    d  floor: 3 b:u .
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:7
                position:45
                tree:collector tree.
    self assert:(foundNode beforeStatement notNil).
    self assert:(foundNode beforeStatement isSelectorNode).

    "Created: / 02-03-2011 / 23:00:06 / Jakub <zelenja7@fel.cvut.cz>"
!

testBeforeStatement44
    |collector finder foundNode|

    collector := self 
                doForSource:'
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u .
                    d  floor: 3 b:u .
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:7
                position:49
                tree:collector tree.
    self assert:(foundNode beforeStatement notNil).
    self assert:(foundNode beforeStatement isMessage).

    "Created: / 02-03-2011 / 23:01:40 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 08-04-2011 / 00:05:41 / Jakub <zelenja7@fel.cvut.cz>"
!

testBeforeStatement45
    |collector finder foundNode|

    collector := self 
                doForSource:'
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u .
                    d  floor: 3 b:u .
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:7
                position:51
                tree:collector tree.
    self assert:(foundNode beforeStatement notNil).
    self assert:(foundNode beforeStatement isMessage).

    "Created: / 02-03-2011 / 23:02:49 / Jakub <zelenja7@fel.cvut.cz>"
!

testBeforeStatement46
    |collector finder foundNode|

    collector := self 
                doForSource:'
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u .
                    d  floor: 3 b:u .
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:7
                position:55
                tree:collector tree.
    self assert:(foundNode beforeStatement notNil).
    self assert:(foundNode beforeStatement isVariable).

    "Created: / 02-03-2011 / 23:03:14 / Jakub <zelenja7@fel.cvut.cz>"
!

testBeforeStatement47
    |collector finder foundNode|

    collector := self 
                doForSource:'
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u .
                    d  floor: 3 b:u .
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:7
                position:60
                tree:collector tree.
    self assert:(foundNode beforeStatement notNil).
    self assert:(foundNode beforeStatement isSelectorNode).

    "Created: / 02-03-2011 / 23:04:14 / Jakub <zelenja7@fel.cvut.cz>"
!

testBeforeStatement48
    |collector finder foundNode|

    collector := self 
                doForSource:'
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u .
                    d  floor: 3 b:u .
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:7
                position:63
                tree:collector tree.
    self assert:(foundNode beforeStatement notNil).
    self assert:(foundNode beforeStatement isMessage).

    "Created: / 02-03-2011 / 23:04:38 / Jakub <zelenja7@fel.cvut.cz>"
!

testBeforeStatement49
    |collector finder foundNode|

    collector := self 
                doForSource:'
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u .
                    d  floor: 3 b:u .
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:7
                position:65
                tree:collector tree.
    self assert:(foundNode beforeStatement notNil).
    self assert:(foundNode beforeStatement isMessage).

    "Created: / 02-03-2011 / 23:14:59 / Jakub <zelenja7@fel.cvut.cz>"
!

testBeforeStatement5
    |collector finder foundNode|

    collector := self 
                doForSource:'
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u.
                    d floor: 3 b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:3
                position:21
                tree:collector tree.
    self assert:(foundNode beforeStatement notNil).
    self assert:(foundNode beforeStatement isAssignment).

    "Created: / 02-03-2011 / 20:07:50 / Jakub <zelenja7@fel.cvut.cz>"
!

testBeforeStatement50
    |collector finder foundNode|

    collector := self 
                doForSource:'
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u .
                    d  floor: 3 b:u .
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:7
                position:68
                tree:collector tree.
    self assert:(foundNode beforeStatement notNil).
    self assert:(foundNode beforeStatement isVariable).

    "Created: / 02-03-2011 / 23:15:18 / Jakub <zelenja7@fel.cvut.cz>"
!

testBeforeStatement51
    |collector finder foundNode|

    collector := self 
                doForSource:'
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u .
                    d  floor: 3 b:u .
                    self rememberSymbolUsed:nil  . c  call: b  . b call:  c dd:d.
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:7
                position:73
                tree:collector tree.
    self assert:(foundNode beforeStatement notNil).
    self assert:(foundNode beforeStatement isSelectorNode).

    "Created: / 02-03-2011 / 23:15:34 / Jakub <zelenja7@fel.cvut.cz>"
!

testBeforeStatement52
    |collector finder foundNode|

    collector := self 
                doForSource:'
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u .
                    d  floor: 3 b:u .
                    self rememberSymbolUsed:nil  . c  call: b  . b call:  c dd:d.
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:7
                position:75
                tree:collector tree.
    self assert:(foundNode beforeStatement notNil).
    self assert:(foundNode beforeStatement isSelectorNode).

    "Created: / 02-03-2011 / 23:16:16 / Jakub <zelenja7@fel.cvut.cz>"
!

testBeforeStatement53
    |collector finder foundNode|

    collector := self 
                doForSource:'
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u .
                    d  floor: 3 b:u .
                    self rememberSymbolUsed:nil  . c  call: b  . b call:  c dd:d.
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:7
                position:77
                tree:collector tree.
    self assert:(foundNode beforeStatement notNil).
    self assert:(foundNode beforeStatement isVariable).

    "Created: / 02-03-2011 / 23:16:32 / Jakub <zelenja7@fel.cvut.cz>"
!

testBeforeStatement54
    |collector finder foundNode|

    collector := self 
                doForSource:'
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u .
                    d  floor: 3 b:u .
                    self rememberSymbolUsed:nil  . c  call: b  . b call:  c dd:d  .
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:7
                position:83
                tree:collector tree.
    self assert:(foundNode beforeStatement notNil).
    self assert:(foundNode beforeStatement isMessage).

    "Created: / 02-03-2011 / 23:16:56 / Jakub <zelenja7@fel.cvut.cz>"
!

testBeforeStatement55
    |collector finder foundNode|

    collector := self 
                doForSource:'
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u .
                    d  floor: 3 b:u .
                    self rememberSymbolUsed:nil  . c  call: b  . b call:  c dd:d  .
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:8
                position:20
                tree:collector tree.
    self assert:(foundNode beforeStatement notNil).
    self assert:(foundNode beforeStatement isMessage).

    "Created: / 02-03-2011 / 23:17:32 / Jakub <zelenja7@fel.cvut.cz>"
!

testBeforeStatement56
    |collector finder foundNode|

    collector := self 
                doForSource:'
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u .
                    d  floor: 3 b:u .
                    self rememberSymbolUsed:nil  . c  call: b  . b call:  c dd:d  .
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:8
                position:28
                tree:collector tree.
    self assert:(foundNode beforeStatement notNil).
    self assert:(foundNode beforeStatement isVariable).

    "Created: / 02-03-2011 / 23:43:04 / Jakub <zelenja7@fel.cvut.cz>"
!

testBeforeStatement57
    |collector finder foundNode|

    collector := self 
                doForSource:'
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u .
                    d  floor: 3 b:u .
                    self rememberSymbolUsed:nil  . c  call: b  . b call:  c dd:d  .
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:8
                position:41
                tree:collector tree.
    self assert:(foundNode beforeStatement notNil).
    self assert:(foundNode beforeStatement isVariable).

    "Created: / 02-03-2011 / 23:43:29 / Jakub <zelenja7@fel.cvut.cz>"
!

testBeforeStatement58
    |collector finder foundNode|

    collector := self 
                doForSource:'
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u .
                    d  floor: 3 b:u .
                    self rememberSymbolUsed:nil  . c  call: b  . b call:  c dd:d  .
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:8
                position:44
                tree:collector tree.
    self assert:(foundNode beforeStatement notNil).
    self assert:(foundNode beforeStatement isAssignment).

    "Created: / 02-03-2011 / 23:44:12 / Jakub <zelenja7@fel.cvut.cz>"
!

testBeforeStatement59
    |collector finder foundNode|

    collector := self 
                doForSource:'
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u .
                    d  floor: 3 b:u .
                    self rememberSymbolUsed:nil  . c  call: b  . b call:  c dd:d  .
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:9
                position:42
                tree:collector tree.
    self assert:(foundNode beforeStatement notNil).
    self assert:(foundNode beforeStatement isVariable).

    "Created: / 02-03-2011 / 23:44:49 / Jakub <zelenja7@fel.cvut.cz>"
!

testBeforeStatement6
    |collector finder foundNode|

    collector := self 
                doForSource:'
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u.
                    d floor: 3 b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:3
                position:22
                tree:collector tree.
    self assert:(foundNode beforeStatement notNil).
    self assert:(foundNode beforeStatement isAssignment).

    "Created: / 02-03-2011 / 20:15:09 / Jakub <zelenja7@fel.cvut.cz>"
!

testBeforeStatement60
    |collector finder foundNode|

    collector := self 
                doForSource:'
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u .
                    d  floor: 3 b:u .
                    self rememberSymbolUsed:nil  . c  call: b  . b call:  c dd:d  .
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:11
                position:22
                tree:collector tree.
    self assert:(foundNode beforeStatement notNil).
    self assert:(foundNode beforeStatement isAssignment).

    "Created: / 02-03-2011 / 23:46:27 / Jakub <zelenja7@fel.cvut.cz>"
!

testBeforeStatement61
    |collector finder foundNode|

    collector := self 
                doForSource:'
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u .
                    d  floor: 3 b:u .
                    self rememberSymbolUsed:nil  . c  call: b  . b call:  c dd:d  .
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:11
                position:27
                tree:collector tree.
    self assert:(foundNode beforeStatement notNil).
    self assert:(foundNode beforeStatement isSelectorNode).

    "Created: / 02-03-2011 / 23:46:50 / Jakub <zelenja7@fel.cvut.cz>"
!

testBeforeStatement62
    |collector finder foundNode|

    collector := self 
                doForSource:'
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u .
                    d  floor: 3 b:u .
                    self rememberSymbolUsed:nil  . c  call: b  . b call:  c dd:d  .
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:11
                position:45
                tree:collector tree.
    self assert:(foundNode beforeStatement notNil).
    self assert:(foundNode beforeStatement isMessage).

    "Created: / 02-03-2011 / 23:47:36 / Jakub <zelenja7@fel.cvut.cz>"
!

testBeforeStatement63
    |collector finder foundNode|

    collector := self 
                doForSource:'
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u .
                    d  floor: 3 b:u .
                    self rememberSymbolUsed:nil  . c  call: b  . b call:  c dd:d  .
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:11
                position:35
                tree:collector tree.
    self assert:(foundNode beforeStatement notNil).
    self assert:(foundNode beforeStatement isMessage).

    "Created: / 02-03-2011 / 23:57:56 / Jakub <zelenja7@fel.cvut.cz>"
!

testBeforeStatement64
    |collector finder foundNode|

    collector := self 
                doForSource:'
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u .
                    d  floor: 3 b:u .
                    self rememberSymbolUsed:nil  . c  call: b  . b call:  c dd:d  .
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:11
                position:51
                tree:collector tree.
    self assert:(foundNode beforeStatement notNil).
    self assert:(foundNode beforeStatement isBlock).

    "Created: / 02-03-2011 / 23:58:33 / Jakub <zelenja7@fel.cvut.cz>"
!

testBeforeStatement65
    |collector finder foundNode|

    collector := self 
                doForSource:'
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u .
                    d  floor: 3 b:u .
                    self rememberSymbolUsed:nil  . c  call: b  . b call:  c dd:d  .
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:11
                position:61
                tree:collector tree.
    self assert:(foundNode beforeStatement notNil).
    self assert:(foundNode beforeStatement isSelectorNode).

    "Created: / 02-03-2011 / 23:59:03 / Jakub <zelenja7@fel.cvut.cz>"
!

testBeforeStatement7
    |collector finder foundNode|

    collector := self 
                doForSource:'
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u.
                    d floor: 3 b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:3
                position:23
                tree:collector tree.
    self assert:(foundNode beforeStatement notNil).
    self assert:(foundNode beforeStatement isVariable).

    "Created: / 02-03-2011 / 20:15:27 / Jakub <zelenja7@fel.cvut.cz>"
!

testBeforeStatement8
    |collector finder foundNode|

    collector := self 
                doForSource:'
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u.
                    d floor: 3 b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:3
                position:24
                tree:collector tree.
    self assert:(foundNode beforeStatement notNil).
    self assert:(foundNode beforeStatement isVariable).

    "Created: / 02-03-2011 / 20:15:55 / Jakub <zelenja7@fel.cvut.cz>"
!

testBeforeStatement9
    |collector finder foundNode|

    collector := self 
                doForSource:'
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u.
                    d floor: 3 b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:3
                position:27
                tree:collector tree.
    self assert:(foundNode beforeStatement notNil).
    self assert:(foundNode beforeStatement isAssignment).

    "Created: / 02-03-2011 / 20:16:10 / Jakub <zelenja7@fel.cvut.cz>"
! !

!FinderTests methodsFor:'FinderTests'!

testFinder1
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa.
                    d floor:u .
                    d floor:3 b:u.
                     self rememberSymbolUsed:nil. 
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ]     .
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:3
                position:1
                tree:collector tree.
    self assert:(foundNode beforeNode).
    self assert:((foundNode position) = 1).
    self assert:((foundNode line) = 3).
    self assert:(foundNode node isNil).
    self assert:(foundNode statement isAssignment).

    "Created: / 22-02-2011 / 14:40:34 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 27-02-2011 / 23:36:22 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder10
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3 .
                    b:=u.
                    c:=u 
                        floor 
                        aa.
                    d floor:u.
                    d floor:3 b:u.
                    self rememberSymbolUsed:nil. 
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:5
                position:24
                tree:collector tree.
    self assert:(foundNode afterNode).
    self assert:((foundNode line) = 5).
    self assert:((foundNode position) = 24).
    self assert:(foundNode statement isAssignment).

    "Created: / 25-02-2011 / 13:46:15 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 25-02-2011 / 17:13:25 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder100
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor: u.
                    d floor:3  b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:18
                position:22
                tree:collector tree.
    self assert:(foundNode beforeNode).
    self assert:((foundNode line) = 18).
    self assert:((foundNode position) = 22).
    self assert:((foundNode node) ~= (foundNode statement)).
    self assert:(foundNode statement isMessage).

    "Created: / 28-02-2011 / 18:29:35 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder101
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor: u.
                    d floor:3  b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:18
                position:23
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode line) = 18).
    self assert:((foundNode position) = 23).
    self assert:(foundNode node isVariable).
    self assert:(foundNode node name = 'u').
    self assert:(foundNode node line = 18).
    self assert:(foundNode node charIndex = 23).
    self assert:(foundNode statement isMessage).

    "Created: / 28-02-2011 / 18:44:06 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder102
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor: u.
                    d floor:3  b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:18
                position:24
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode line) = 18).
    self assert:((foundNode position) = 24).
    self assert:(foundNode node isVariable).
    self assert:(foundNode node name = 'u').
    self assert:(foundNode node line = 18).
    self assert:(foundNode node charIndex = 23).
    self assert:(foundNode statement isMessage).

    "Created: / 28-02-2011 / 18:45:17 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder103
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor: u.
                    d floor:3  b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:18
                position:25
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode line) = 18).
    self assert:((foundNode position) = 25).
    self assert:(foundNode node isSelectorNode).
    self assert:(foundNode node lines size = 1).
    self assert:(foundNode node lines at:1) = 18.
    self assert:(foundNode node selectorsPosition = 24).
    self assert:(foundNode node selectors asString = '==').
    self assert:(foundNode statement isMessage).

    "Created: / 28-02-2011 / 18:45:32 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder104
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor: u.
                    d floor:3  b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol or: [u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:18
                position:26
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode line) = 18).
    self assert:((foundNode position) = 26).
    self assert:(foundNode node isSelectorNode).
    self assert:(foundNode node lines size = 1).
    self assert:(foundNode node lines at:1) = 18.
    self assert:(foundNode node selectorsPosition = 24).
    self assert:(foundNode node selectors asString = '==').
    self assert:(foundNode statement isMessage).

    "Created: / 28-02-2011 / 18:48:13 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder105
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor: u.
                    d floor:3  b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol or: [u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:18
                position:27
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode line) = 18).
    self assert:((foundNode position) = 27).
    self assert:(foundNode node isConstant).
    self assert:(foundNode node value = #Symbol).
    self assert:(foundNode node line = 18).
    self assert:(foundNode node charIndex = 27).
    self assert:(foundNode statement isMessage).

    "Created: / 28-02-2011 / 18:48:41 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder106
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor: u.
                    d floor:3  b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:18
                position:34
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode line) = 18).
    self assert:((foundNode position) = 34).
    self assert:(foundNode node isConstant).
    self assert:(foundNode node value = #Symbol).
    self assert:(foundNode node line = 18).
    self assert:(foundNode node charIndex = 27).
    self assert:(foundNode statement isMessage).

    "Created: / 28-02-2011 / 18:49:43 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder107
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor: u.
                    d floor:3  b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:18
                position:35
                tree:collector tree.
    self assert:(foundNode afterNode).
    self assert:((foundNode line) = 18).
    self assert:((foundNode position) = 35).
    self assert:(foundNode node isMessage).
    self assert:(foundNode statement isMessage).

    "Created: / 28-02-2011 / 18:52:10 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder108
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor: u.
                    d floor:3  b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:18
                position:36
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode line) = 18).
    self assert:((foundNode position) = 36).
    self assert:(foundNode node isSelectorNode).
    self assert:(foundNode node lines size = 1).
    self assert:(foundNode node lines at:1) = 18.
    self assert:((foundNode node selectorsPosition at:1) = 36).
    self assert:(foundNode node selectors asString = 'or:').
    self assert:(foundNode statement isMessage).

    "Created: / 28-02-2011 / 18:53:20 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder109
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor: u.
                    d floor:3  b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:18
                position:39
                tree:collector tree.
    self assert:(foundNode afterNode).
    self assert:((foundNode line) = 18).
    self assert:((foundNode position) = 39).
    self assert:(foundNode node isSelectorNode).
    self assert:(foundNode node lines size = 1).
    self assert:(foundNode node lines at:1) = 18.
    self assert:((foundNode node selectorsPosition at:1) = 36).
    self assert:(foundNode node selectors asString = 'or:').
    self assert:(foundNode statement isMessage).

    "Created: / 28-02-2011 / 18:55:26 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder11
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa.
                    d floor:u.
                    d floor:3 b:u.
                    self rememberSymbolUsed:nil. 
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:5
                position:29
                tree:collector tree.
    self assert:(foundNode beforeNode).
    self assert:((foundNode line) = 5).
    self assert:((foundNode position) = 29).
    self assert:(foundNode statement isAssignment).

    "Created: / 25-02-2011 / 13:47:36 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 28-02-2011 / 19:52:00 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder110
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor: u.
                    d floor:3  b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [
                    u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:18
                position:40
                tree:collector tree.
    self assert:(foundNode afterNode).
    self assert:((foundNode line) = 18).
    self assert:((foundNode position) = 40).
    self assert:(foundNode node isSelectorNode).
    self assert:(foundNode node lines size = 1).
    self assert:(foundNode node lines at:1) = 18.
    self assert:((foundNode node selectorsPosition at:1) = 36).
    self assert:(foundNode node selectors asString = 'or:').
    self assert:(foundNode statement isMessage).

    "Created: / 28-02-2011 / 18:56:26 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder111
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor: u.
                    d floor:3  b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [
                    u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:19
                position:20
                tree:collector tree.
    self assert:(foundNode beforeNode).
    self assert:((foundNode line) = 19).
    self assert:((foundNode position) = 20).
    self assert:(foundNode node isMessage).
    self assert:((foundNode node) ~= (foundNode statement)).
    self assert:(foundNode statement isMessage).

    "Created: / 28-02-2011 / 18:57:19 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder112
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor: u.
                    d floor:3  b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [
                    u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:18
                position:42
                tree:collector tree.
    self assert:(foundNode beforeNode).
    self assert:((foundNode line) = 18).
    self assert:((foundNode position) = 42).
    self assert:(foundNode node isMessage).
    self assert:((foundNode node) ~= (foundNode statement)).
    self assert:(foundNode statement isMessage).

    "Created: / 28-02-2011 / 19:39:49 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder113
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor: u.
                    d floor:3  b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [
                    u=3  ]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:19
                position:25
                tree:collector tree.
    self assert:(foundNode afterNode).
    self assert:((foundNode line) = 19).
    self assert:((foundNode position) = 25).
    self assert:(foundNode node isMessage).
    self assert:((foundNode node) ~= (foundNode statement)).
    self assert:(foundNode statement isMessage).

    "Created: / 28-02-2011 / 19:46:28 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder114
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor: u.
                    d floor:3  b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [
                    u=3  ]  ]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:19
                position:27
                tree:collector tree.
    self assert:(foundNode afterNode).
    self assert:((foundNode line) = 19).
    self assert:((foundNode position) = 27).
    self assert:(foundNode node isBlock).
    self assert:(foundNode node lineNumber = 18).
    self assert:(foundNode node endLineNumber = 19).
    self assert:(foundNode node charStartIndex = 40).
    self assert:(foundNode node charEndIndex = 26).
    self assert:((foundNode node) ~= (foundNode statement)).
    self assert:(foundNode statement isMessage).

    "Created: / 28-02-2011 / 19:47:30 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder115
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor: u.
                    d floor:3  b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [
                    u=3  ]  ]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:19
                position:29
                tree:collector tree.
    self assert:(foundNode afterNode).
    self assert:((foundNode line) = 19).
    self assert:((foundNode position) = 29).
    self assert:(foundNode node isBlock).
    self assert:(foundNode node lineNumber = 18).
    self assert:(foundNode node endLineNumber = 19).
    self assert:(foundNode node charStartIndex = 40).
    self assert:(foundNode node charEndIndex = 26).
    self assert:((foundNode node) ~= (foundNode statement)).
    self assert:(foundNode statement isMessage).

    "Created: / 28-02-2011 / 19:48:17 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder116
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor: u.
                    d floor:3  b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [
                    u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:19
                position:30
                tree:collector tree.
    self assert:(foundNode afterNode).
    self assert:((foundNode line) = 19).
    self assert:((foundNode position) = 30).
    self assert:(foundNode node isBlock).
    self assert:(foundNode node lineNumber = 18).
    self assert:(foundNode node endLineNumber = 19).
    self assert:(foundNode node charStartIndex = 21).
    self assert:(foundNode node charEndIndex = 29).
    self assert:((foundNode node) ~= (foundNode statement)).
    self assert:(foundNode statement isMessage).

    "Created: / 28-02-2011 / 19:48:46 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder117
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor: u.
                    d floor:3  b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [
                    u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:23
                position:23
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode line) = 23).
    self assert:((foundNode position) = 23).
    self assert:(foundNode node isVariable).
    self assert:(foundNode node name = 'dd').
    self assert:(foundNode node line = 23).
    self assert:(foundNode node charIndex = 21).
    self assert:(foundNode statement isMessage).

    "Created: / 28-02-2011 / 19:54:03 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder118
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor: u.
                    d floor:3  b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [
                    u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   

.
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:27
                position:23
                tree:collector tree.
    self assert:(foundNode afterNode).
    self assert:((foundNode line) = 27).
    self assert:((foundNode position) = 23).
    self assert:(foundNode node isBlock).
    self assert:(foundNode node lineNumber = 26).
    self assert:(foundNode node endLineNumber = 27).
    self assert:(foundNode node charStartIndex = 27).
    self assert:(foundNode node charEndIndex = 21).
    self assert:((foundNode node) ~= (foundNode statement)).
    self assert:(foundNode statement isMessage).

    "Created: / 28-02-2011 / 19:56:23 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder119
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor: u.
                    d floor:3  b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [
                    u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   

.
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:26
                position:29
                tree:collector tree.
    self assert:(foundNode beforeNode).
    self assert:((foundNode line) = 26).
    self assert:((foundNode position) = 29).
    self assert:(foundNode node isMessage).
    self assert:(foundNode statement isMessage).

    "Created: / 28-02-2011 / 19:59:44 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder12
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa.
                    d floor:u.
                    d floor:3 b:u.
                    self rememberSymbolUsed:nil. 
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:6
                position:20
                tree:collector tree.
    self assert:(foundNode beforeNode).
    self assert:((foundNode line) = 6).
    self assert:((foundNode position) = 20).
    self assert:(foundNode statement isAssignment).

    "Created: / 25-02-2011 / 13:48:20 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder13
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa.
                    d floor:u.
                    d floor:3 b:u.
                    self rememberSymbolUsed:nil. 
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:6
                position:21
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode position) = 21).
    self assert:((foundNode line) = 6).
    self assert:(foundNode node isVariable).
    self assert:(foundNode node name = 'b').
    self assert:(foundNode node line = 6).
    self assert:(foundNode node charIndex = 21).
    self assert:(foundNode statement isAssignment).

    "Created: / 25-02-2011 / 13:48:29 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder14
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa.
                    d floor:u.
                    d floor:3 b:u.
                    self rememberSymbolUsed:nil. 
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:6
                position:22
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode position) = 22).
    self assert:((foundNode line) = 6).
    self assert:(foundNode node isVariable).
    self assert:(foundNode node name = 'b').
    self assert:(foundNode node line = 6).
    self assert:(foundNode node charIndex = 21).
    self assert:(foundNode statement isAssignment).

    "Created: / 25-02-2011 / 13:49:39 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder15
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa.
                    d floor:u.
                    d floor:3 b:u.
                    self rememberSymbolUsed:nil. 
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:6
                position:23
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode position) = 23).
    self assert:((foundNode line) = 6).
    self assert:(foundNode node isAssignment).
    self assert:(foundNode statement isAssignment).

    "Created: / 25-02-2011 / 13:49:48 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder16
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa.
                    d floor:u.
                    d floor:3 b:u.
                    self rememberSymbolUsed:nil. 
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:6
                position:24
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode position) = 24).
    self assert:((foundNode line) = 6).
    self assert:(foundNode node isVariable).
    self assert:(foundNode node name = 'u').
    self assert:(foundNode node line = 6).
    self assert:(foundNode node charIndex = 24).
    self assert:(foundNode statement isAssignment).

    "Created: / 25-02-2011 / 13:50:39 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder17
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa.
                    d floor:u.
                    d floor:3 b:u.
                    self rememberSymbolUsed:nil. 
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:6
                position:25
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode position) = 25).
    self assert:((foundNode line) = 6).
    self assert:(foundNode node isVariable).
    self assert:(foundNode node name = 'u').
    self assert:(foundNode node line = 6).
    self assert:(foundNode node charIndex = 24).
    self assert:(foundNode statement isAssignment).

    "Created: / 25-02-2011 / 13:51:19 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder18
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa.
                    d floor:u.
                    d floor:3 b:u.
                    self rememberSymbolUsed:nil. 
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:6
                position:26
                tree:collector tree.
    self assert:(foundNode beforeNode).
    self assert:((foundNode line) = 6).
    self assert:((foundNode position) = 26).
    self assert:(foundNode statement isAssignment).

    "Created: / 25-02-2011 / 13:51:45 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 25-02-2011 / 17:31:30 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder19
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa.
                    d floor:u.
                    d floor:3 b:u.
                    self rememberSymbolUsed:nil. 
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:7
                position:20
                tree:collector tree.
    self assert:(foundNode beforeNode).
    self assert:((foundNode line) = 7).
    self assert:((foundNode position) = 20).
    self assert:(foundNode statement isAssignment).

    "Created: / 25-02-2011 / 13:52:27 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder2
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa.
                    d floor:u.
                    d floor:3 b:u.
                    self rememberSymbolUsed:nil. 
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:3
                position:21
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode position) = 21).
    self assert:((foundNode line) = 3).
    self assert:(foundNode node isVariable).
    self assert:(foundNode node name = 'u').
    self assert:(foundNode node line = 3).
    self assert:(foundNode node charIndex = 21).
    self assert:(foundNode statement isAssignment).

    "Created: / 25-02-2011 / 13:34:28 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder20
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa.
                    d floor:u.
                    d floor:3 b:u.
                    self rememberSymbolUsed:nil. 
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:7
                position:21
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode position) = 21).
    self assert:((foundNode line) = 7).
    self assert:(foundNode node isVariable).
    self assert:(foundNode node line = 7).
    self assert:(foundNode node charIndex = 21).
    self assert:(foundNode node name = 'c').
    self assert:(foundNode statement isAssignment)
!

testFinder21
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa.
                    d floor:u.
                    d floor:3 b:u.
                    self rememberSymbolUsed:nil. 
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:7
                position:22
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode position) = 22).
    self assert:((foundNode line) = 7).
    self assert:(foundNode node isVariable).
    self assert:(foundNode node line = 7).
    self assert:(foundNode node charIndex = 21).
    self assert:(foundNode node name = 'c').
    self assert:(foundNode statement isAssignment)
!

testFinder22
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa.
                    d floor:u.
                    d floor:3 b:u.
                    self rememberSymbolUsed:nil. 
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:7
                position:23
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode line) = 7).
    self assert:((foundNode position) = 23).
    self assert:(foundNode node isAssignment).
    self assert:(foundNode statement isAssignment).

    "Created: / 25-02-2011 / 14:30:37 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder23
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa.
                    d floor:u.
                    d floor:3 b:u.
                    self rememberSymbolUsed:nil. 
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:7
                position:24
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode position) = 24).
    self assert:((foundNode line) = 7).
    self assert:(foundNode node isVariable).
    self assert:(foundNode node line = 7).
    self assert:(foundNode node charIndex = 24).
    self assert:(foundNode node name = 'u').
    self assert:(foundNode statement isAssignment)
!

testFinder24
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa.
                    d floor:u.
                    d floor:3 b:u.
                    self rememberSymbolUsed:nil. 
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:7
                position:25
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode position) = 25).
    self assert:((foundNode line) = 7).
    self assert:(foundNode node isVariable).
    self assert:(foundNode node line = 7).
    self assert:(foundNode node charIndex = 24).
    self assert:(foundNode node name = 'u').
    self assert:(foundNode statement isAssignment)
!

testFinder26
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa.
                    d floor:u.
                    d floor:3 b:u.
                    self rememberSymbolUsed:nil. 
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:7
                position:26
                tree:collector tree.
    self assert:(foundNode afterNode).
    self assert:((foundNode position) = 26).
    self assert:((foundNode line) = 7).
    self assert:(foundNode node isVariable).
    self assert:(foundNode node line = 7).
    self assert:(foundNode node charIndex = 24).
    self assert:(foundNode node name = 'u').
    self assert:(foundNode statement isAssignment)
!

testFinder27
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa.
                    d floor:u.
                    d floor:3 b:u.
                    self rememberSymbolUsed:nil. 
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:8
                position:1
                tree:collector tree.
    self assert:(foundNode afterNode).
    self assert:((foundNode position) = 1).
    self assert:((foundNode line) = 8).
    self assert:(foundNode node isVariable).
    self assert:(foundNode node line = 7).
    self assert:(foundNode node charIndex = 24).
    self assert:(foundNode node name = 'u').
    self assert:(foundNode statement isAssignment)
!

testFinder28
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa.
                    d floor:u.
                    d floor:3 b:u.
                    self rememberSymbolUsed:nil. 
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:8
                position:25
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode position) = 25).
    self assert:((foundNode line) = 8).
    self assert:(foundNode node isSelectorNode).
    self assert:(foundNode node lines size = 1).
    self assert:(foundNode node lines at:1) = 8.
    self assert:(foundNode node selectorsPosition = 25).
    self assert:(foundNode node selectors asString = 'floor').
    self assert:(foundNode statement isAssignment)
!

testFinder29
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa.
                    d floor:u.
                    d floor:3 b:u.
                    self rememberSymbolUsed:nil. 
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:8
                position:30
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode position) = 30).
    self assert:((foundNode line) = 8).
    self assert:(foundNode node isSelectorNode).
    self assert:(foundNode node lines size = 1).
    self assert:(foundNode node lines at:1) = 8.
    self assert:(foundNode node selectorsPosition = 25).
    self assert:(foundNode node selectors asString = 'floor').
    self assert:(foundNode statement isAssignment)
!

testFinder3
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa.
                    d floor:u.
                    d floor:3 b:u.
                    self rememberSymbolUsed:nil. 
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:3
                position:22
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode position) = 22).
    self assert:((foundNode line) = 3).
    self assert:(foundNode node isVariable).
    self assert:(foundNode node line = 3).
    self assert:(foundNode node charIndex = 21).
    self assert:(foundNode node name = 'u').
    self assert:(foundNode statement isAssignment).

    "Created: / 25-02-2011 / 13:36:19 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder30
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa.
                    d floor:u.
                    d floor:3 b:u.
                    self rememberSymbolUsed:nil. 
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:8
                position:32
                tree:collector tree.
    self assert:(foundNode afterNode).
    self assert:((foundNode position) = 32).
    self assert:((foundNode line) = 8).
    self assert:(foundNode node isUnaryMessage).
    self assert:(foundNode statement isAssignment)
!

testFinder31
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa.
                    d floor:u.
                    d floor:3 b:u.
                    self rememberSymbolUsed:nil. 
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:9
                position:25
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode position) = 25).
    self assert:((foundNode line) = 9).
    self assert:(foundNode node isSelectorNode).
    self assert:(foundNode node lines size = 1).
    self assert:(foundNode node lines at:1) = 9.
    self assert:(foundNode node selectorsPosition = 25).
    self assert:(foundNode node selectors asString = 'aa').
    self assert:(foundNode statement isAssignment)
!

testFinder32
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d floor:u.
                    d floor:3 b:u.
                    self rememberSymbolUsed:nil. c call:b. b call:c dd:d.
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:9
                position:28
                tree:collector tree.
    self assert:(foundNode afterNode).
    self assert:((foundNode line) = 9).
    self assert:((foundNode position) = 28).
    self assert:(foundNode statement isAssignment).

    "Created: / 25-02-2011 / 14:41:23 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 25-02-2011 / 17:40:06 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder33
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d floor:u.
                    d floor:3 b:u.
                    self rememberSymbolUsed:nil. c call:b. b call:c dd:d.
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:9
                position:30
                tree:collector tree.
    self assert:(foundNode afterNode).
    self assert:((foundNode line) = 9).
    self assert:((foundNode position) = 30).
    self assert:(foundNode statement isAssignment).

    "Created: / 28-02-2011 / 14:32:35 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder34
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d floor:u.
                    d floor:3 b:u.
                    self rememberSymbolUsed:nil. c call:b. b call:c dd:d.
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:9
                position:31
                tree:collector tree.
    self assert:(foundNode beforeNode).
    self assert:((foundNode line) = 9).
    self assert:((foundNode position) = 31).
    self assert:(foundNode statement isMessage).

    "Created: / 28-02-2011 / 14:33:08 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder35
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d floor:u.
                    d floor:3 b:u.
                    self rememberSymbolUsed:nil. c call:b. b call:c dd:d.
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:10
                position:20
                tree:collector tree.
    self assert:(foundNode beforeNode).
    self assert:((foundNode line) = 10).
    self assert:((foundNode position) = 20).
    self assert:(foundNode statement isMessage).

    "Created: / 28-02-2011 / 14:34:07 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder36
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d floor:u.
                    d floor:3 b:u.
                    self rememberSymbolUsed:nil. c call:b. b call:c dd:d.
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:10
                position:21
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode line) = 10).
    self assert:((foundNode position) = 21).
    self assert:(foundNode node isVariable).
    self assert:(foundNode node name = 'd').
    self assert:(foundNode node line = 10).
    self assert:(foundNode node charIndex = 21).
    self assert:(foundNode statement isMessage).

    "Created: / 28-02-2011 / 14:34:41 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder37
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d floor:u.
                    d floor:3 b:u.
                    self rememberSymbolUsed:nil. c call:b. b call:c dd:d.
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:10
                position:22
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode line) = 10).
    self assert:((foundNode position) = 22).
    self assert:(foundNode node isVariable).
    self assert:(foundNode node name = 'd').
    self assert:(foundNode node line = 10).
    self assert:(foundNode node charIndex = 21).
    self assert:(foundNode statement isMessage).

    "Created: / 28-02-2011 / 14:36:19 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder38
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor:u.
                    d floor:3 b:u.
                    self rememberSymbolUsed:nil. c call:b. b call:c dd:d.
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:10
                position:23
                tree:collector tree.
    self assert:(foundNode afterNode).
    self assert:((foundNode line) = 10).
    self assert:((foundNode position) = 23).
    self assert:(foundNode node isVariable).
    self assert:(foundNode node name = 'd').
    self assert:(foundNode node line = 10).
    self assert:(foundNode node charIndex = 21).
    self assert:(foundNode statement isMessage).

    "Created: / 28-02-2011 / 14:37:09 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder39
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor:u.
                    d floor:3 b:u.
                    self rememberSymbolUsed:nil. c call:b. b call:c dd:d.
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:10
                position:24
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode line) = 10).
    self assert:((foundNode position) = 24).
    self assert:(foundNode node isSelectorNode).
    self assert:(foundNode node selectors asString = 'floor:').
    self assert:(foundNode node selectorsPosition size = 1).
    self assert:((foundNode node selectorsPosition at:1) = 24).
    self assert:(foundNode node lines size = 1).
    self assert:((foundNode node lines at:1) = 10).
    self assert:(foundNode statement isMessage).

    "Created: / 28-02-2011 / 14:37:53 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 18-03-2011 / 22:08:24 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder4
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa.
                    d floor:u.
                    d floor:3 b:u.
                    self rememberSymbolUsed:nil. 
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:3
                position:23
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode position) = 23).
    self assert:((foundNode line) = 3).
    self assert:(foundNode node isAssignment).
    self assert:(foundNode statement isAssignment).

    "Created: / 25-02-2011 / 13:39:04 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder40
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor:u.
                    d floor:3 b:u.
                    self rememberSymbolUsed:nil. c call:b. b call:c dd:d.
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:10
                position:27
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode line) = 10).
    self assert:((foundNode position) = 27).
    self assert:(foundNode node isSelectorNode).
    self assert:(foundNode node selectors asString = 'floor:').
    self assert:(foundNode node selectorsPosition size = 1).
    self assert:((foundNode node selectorsPosition at:1) = 24).
    self assert:(foundNode node lines size = 1).
    self assert:((foundNode node lines at:1) = 10).
    self assert:(foundNode statement isMessage).

    "Created: / 28-02-2011 / 14:43:08 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 18-03-2011 / 22:08:34 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder41
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor: u.
                    d floor:3 b:u.
                    self rememberSymbolUsed:nil. c call:b. b call:c dd:d.
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:10
                position:29
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode line) = 10).
    self assert:((foundNode position) = 29).
    self assert:(foundNode node isSelectorNode).
    self assert:(foundNode node selectors asString = 'floor:').
    self assert:(foundNode node selectorsPosition size = 1).
    self assert:((foundNode node selectorsPosition at:1) = 24).
    self assert:(foundNode node lines size = 1).
    self assert:((foundNode node lines at:1) = 10).
    self assert:(foundNode statement isMessage).

    "Created: / 28-02-2011 / 14:43:42 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 18-03-2011 / 22:08:39 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder42
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor: u.
                    d floor:3 b:u.
                    self rememberSymbolUsed:nil. c call:b. b call:c dd:d.
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:10
                position:30
                tree:collector tree.
    self assert:(foundNode afterNode).
    self assert:((foundNode line) = 10).
    self assert:((foundNode position) = 30).
    self assert:(foundNode node isSelectorNode).
    self assert:(foundNode node selectors asString = 'floor:').
    self assert:(foundNode node selectorsPosition size = 1).
    self assert:((foundNode node selectorsPosition at:1) = 24).
    self assert:(foundNode node lines size = 1).
    self assert:((foundNode node lines at:1) = 10).
    self assert:(foundNode statement isMessage).

    "Created: / 28-02-2011 / 14:43:57 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 18-03-2011 / 22:08:45 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder43
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor: u.
                    d floor:3 b:u.
                    self rememberSymbolUsed:nil. c call:b. b call:c dd:d.
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:10
                position:31
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode line) = 10).
    self assert:((foundNode position) = 31).
    self assert:(foundNode node isVariable).
    self assert:(foundNode node name = 'u').
    self assert:(foundNode node line = 10).
    self assert:(foundNode node charIndex = 31).
    self assert:(foundNode statement isMessage).

    "Created: / 28-02-2011 / 14:44:31 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder44
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor: u.
                    d floor:3 b:u.
                    self rememberSymbolUsed:nil. c call:b. b call:c dd:d.
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:10
                position:32
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode line) = 10).
    self assert:((foundNode position) = 32).
    self assert:(foundNode node isVariable).
    self assert:(foundNode node name = 'u').
    self assert:(foundNode node line = 10).
    self assert:(foundNode node charIndex = 31).
    self assert:(foundNode statement isMessage).

    "Created: / 28-02-2011 / 14:45:35 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder45
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor: u.
                    d floor:3 b:u.
                    self rememberSymbolUsed:nil. c call:b. b call:c dd:d.
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:10
                position:33
                tree:collector tree.
    self assert:(foundNode beforeNode).
    self assert:((foundNode line) = 10).
    self assert:((foundNode position) = 33).
    self assert:(foundNode statement isMessage).

    "Created: / 28-02-2011 / 14:45:55 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder46
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor: u.
                    d floor:3 b:u.
                    self rememberSymbolUsed:nil. c call:b. b call:c dd:d.
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:11
                position:20
                tree:collector tree.
    self assert:(foundNode beforeNode).
    self assert:((foundNode line) = 11).
    self assert:((foundNode position) = 20).
    self assert:(foundNode statement isMessage).

    "Created: / 28-02-2011 / 14:47:00 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder47
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor: u.
                    d floor:3 b:u.
                    self rememberSymbolUsed:nil. c call:b. b call:c dd:d.
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:11
                position:21
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode line) = 11).
    self assert:((foundNode position) = 21).
    self assert:(foundNode node isVariable).
    self assert:(foundNode node name = 'd').
    self assert:(foundNode node line = 11).
    self assert:(foundNode node charIndex = 21).
    self assert:(foundNode statement isMessage).

    "Created: / 28-02-2011 / 15:34:49 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder48
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor: u.
                    d floor:3 b:u.
                    self rememberSymbolUsed:nil. c call:b. b call:c dd:d.
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:11
                position:22
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode line) = 11).
    self assert:((foundNode position) = 22).
    self assert:(foundNode node isVariable).
    self assert:(foundNode node name = 'd').
    self assert:(foundNode node line = 11).
    self assert:(foundNode node charIndex = 21).
    self assert:(foundNode statement isMessage).

    "Created: / 28-02-2011 / 15:36:14 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder49
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor: u.
                    d floor:3 b:u.
                    self rememberSymbolUsed:nil. c call:b. b call:c dd:d.
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:11
                position:23
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode line) = 11).
    self assert:((foundNode position) = 23).
    self assert:(foundNode node isSelectorNode).
    self assert:(foundNode node selectors asString = 'floor:b:').
    self assert:(foundNode node selectorsPosition size = 2).
    self assert:((foundNode node selectorsPosition at:1) = 23).
    self assert:((foundNode node selectorsPosition at:2) = 31).
    self assert:(foundNode node lines size = 2).
    self assert:((foundNode node lines at:1) = 11).
    self assert:((foundNode node lines at:2) = 11).
    self assert:(foundNode statement isMessage).

    "Created: / 28-02-2011 / 15:36:58 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 18-03-2011 / 22:08:55 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder5
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa.
                    d floor:u.
                    d floor:3 b:u.
                    self rememberSymbolUsed:nil. 
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:4
                position:1
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode position) = 1).
    self assert:((foundNode line) = 4).
    self assert:(foundNode node isAssignment).
    self assert:(foundNode statement isAssignment).

    "Created: / 25-02-2011 / 13:40:43 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder50
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor: u.
                    d floor:3 b:u.
                    self rememberSymbolUsed:nil. c call:b. b call:c dd:d.
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:11
                position:28
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode line) = 11).
    self assert:((foundNode position) = 28).
    self assert:(foundNode node isSelectorNode).
    self assert:(foundNode node selectors asString = 'floor:b:').
    self assert:(foundNode node selectorsPosition size = 2).
    self assert:((foundNode node selectorsPosition at:1) = 23).
    self assert:((foundNode node selectorsPosition at:2) = 31).
    self assert:(foundNode node lines size = 2).
    self assert:((foundNode node lines at:1) = 11).
    self assert:((foundNode node lines at:2) = 11).
    self assert:(foundNode statement isMessage).

    "Created: / 28-02-2011 / 15:41:42 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 18-03-2011 / 22:09:01 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder51
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor: u.
                    d floor:3 b:u.
                    self rememberSymbolUsed:nil. c call:b. b call:c dd:d.
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:11
                position:29
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode line) = 11).
    self assert:((foundNode position) = 29).
    self assert:(foundNode node isConstant).
    self assert:(foundNode node value = 3).
    self assert:(foundNode node line = 11).
    self assert:(foundNode node charIndex = 29).
    self assert:(foundNode statement isMessage).

    "Created: / 28-02-2011 / 15:42:13 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder52
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor: u.
                    d floor:3  b:u.
                    self rememberSymbolUsed:nil. c call:b. b call:c dd:d.
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:11
                position:30
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode line) = 11).
    self assert:((foundNode position) = 30).
    self assert:(foundNode node isConstant).
    self assert:(foundNode node value = 3).
    self assert:(foundNode node line = 11).
    self assert:(foundNode node charIndex = 29).
    self assert:(foundNode statement isMessage).

    "Created: / 28-02-2011 / 15:54:26 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder53
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor: u.
                    d floor:3  b:u.
                    self rememberSymbolUsed:nil. c call:b. b call:c dd:d.
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:11
                position:31
                tree:collector tree.
    self assert:(foundNode afterNode).
    self assert:((foundNode line) = 11).
    self assert:((foundNode position) = 31).
    self assert:(foundNode node isConstant).
    self assert:(foundNode node value = 3).
    self assert:(foundNode node line = 11).
    self assert:(foundNode node charIndex = 29).
    self assert:(foundNode statement isMessage).

    "Created: / 28-02-2011 / 15:55:13 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder54
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor: u.
                    d floor:3  b:u.
                    self rememberSymbolUsed:nil. c call:b. b call:c dd:d.
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:11
                position:32
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode line) = 11).
    self assert:((foundNode position) = 32).
    self assert:(foundNode node isSelectorNode).
    self assert:(foundNode node selectors asString = 'floor:b:').
    self assert:(foundNode node selectorsPosition size = 2).
    self assert:((foundNode node selectorsPosition at:1) = 23).
    self assert:((foundNode node selectorsPosition at:2) = 32).
    self assert:(foundNode node lines size = 2).
    self assert:((foundNode node lines at:1) = 11).
    self assert:((foundNode node lines at:2) = 11).
    self assert:(foundNode statement isMessage).

    "Created: / 28-02-2011 / 15:55:30 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 18-03-2011 / 22:09:06 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder55
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor: u.
                    d floor:3  b:u.
                    self rememberSymbolUsed:nil. c call:b. b call:c dd:d.
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:11
                position:33
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode line) = 11).
    self assert:((foundNode position) = 33).
    self assert:(foundNode node isSelectorNode).
    self assert:(foundNode node selectors asString = 'floor:b:').
    self assert:(foundNode node selectorsPosition size = 2).
    self assert:((foundNode node selectorsPosition at:1) = 23).
    self assert:((foundNode node selectorsPosition at:2) = 32).
    self assert:(foundNode node lines size = 2).
    self assert:((foundNode node lines at:1) = 11).
    self assert:((foundNode node lines at:2) = 11).
    self assert:(foundNode statement isMessage).

    "Created: / 28-02-2011 / 15:56:34 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 18-03-2011 / 22:09:12 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder550
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor: u.
                    d floor:  3  b:u.
                    self rememberSymbolUsed:nil. c call:b. b call:c dd:d.
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:11
                position:30
                tree:collector tree.
    self assert:(foundNode afterNode).
    self assert:((foundNode line) = 11).
    self assert:((foundNode position) = 30).
    self assert:(foundNode node isSelectorNode).
    self assert:(foundNode node selectors asString = 'floor:b:').
    self assert:(foundNode node selectorsPosition size = 2).
    self assert:((foundNode node selectorsPosition at:1) = 23).
    self assert:((foundNode node selectorsPosition at:2) = 34).
    self assert:(foundNode node lines size = 2).
    self assert:((foundNode node lines at:1) = 11).
    self assert:((foundNode node lines at:2) = 11).
    self assert:(foundNode statement isMessage).

    "Created: / 03-03-2011 / 21:01:09 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 18-03-2011 / 22:09:17 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder551
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor: u.
                    d floor:  3  b:  u.
                    self rememberSymbolUsed:nil. c call:b. b call:c dd:d.
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:11
                position:37
                tree:collector tree.
    self assert:(foundNode afterNode).
    self assert:((foundNode line) = 11).
    self assert:((foundNode position) = 37).
    self assert:(foundNode node isSelectorNode).
    self assert:(foundNode node selectors asString = 'floor:b:').
    self assert:(foundNode node selectorsPosition size = 2).
    self assert:((foundNode node selectorsPosition at:1) = 23).
    self assert:((foundNode node selectorsPosition at:2) = 34).
    self assert:(foundNode node lines size = 2).
    self assert:((foundNode node lines at:1) = 11).
    self assert:((foundNode node lines at:2) = 11).
    self assert:(foundNode statement isMessage).

    "Created: / 03-03-2011 / 21:02:22 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 18-03-2011 / 22:09:22 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder552
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor: u.
                    d floor:  3  b:  u.
                    self rememberSymbolUsed:nil. c call:b. b call:c dd:d.
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:11
                position:38
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode line) = 11).
    self assert:((foundNode position) = 38).
    self assert:(foundNode node isVariable).
    self assert:(foundNode node name = 'u').
    self assert:(foundNode statement isMessage).

    "Created: / 03-03-2011 / 21:02:56 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder553
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor: u.
                    d floor:  3  b:  u  .
                    self rememberSymbolUsed:nil. c call:b. b call:c dd:d.
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:11
                position:40
                tree:collector tree.
    self assert:(foundNode afterNode).
    self assert:((foundNode line) = 11).
    self assert:((foundNode position) = 40).
    self assert:(foundNode node isMessage).
    self assert:(foundNode statement isMessage).

    "Created: / 03-03-2011 / 21:04:05 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder56
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor: u.
                    d floor:3  b:u.
                    self rememberSymbolUsed:nil. c call:b. b call:c dd:d.
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:11
                position:34
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode line) = 11).
    self assert:((foundNode position) = 34).
    self assert:(foundNode node isVariable).
    self assert:(foundNode node name = 'u').
    self assert:(foundNode node line = 11).
    self assert:(foundNode node charIndex = 34).
    self assert:(foundNode statement isMessage).

    "Created: / 28-02-2011 / 15:56:58 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder57
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor: u.
                    d floor:3  b:u.
                    self rememberSymbolUsed:nil. c call:b. b call:c dd:d.
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:11
                position:35
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode line) = 11).
    self assert:((foundNode position) = 35).
    self assert:(foundNode node isVariable).
    self assert:(foundNode node name = 'u').
    self assert:(foundNode node line = 11).
    self assert:(foundNode node charIndex = 34).
    self assert:(foundNode statement isMessage).

    "Created: / 28-02-2011 / 15:57:56 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder58
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor: u.
                    d floor:3  b:u.
                    self rememberSymbolUsed:nil. c call:b. b call:c dd:d.
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:11
                position:36
                tree:collector tree.
    self assert:(foundNode beforeNode).
    self assert:((foundNode line) = 11).
    self assert:((foundNode position) = 36).
    self assert:(foundNode statement isMessage).

    "Created: / 28-02-2011 / 15:58:09 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder59
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor: u.
                    d floor:3  b:u.
                    self rememberSymbolUsed:nil. c call:b. b call:c dd:d.
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:12
                position:20
                tree:collector tree.
    self assert:(foundNode beforeNode).
    self assert:((foundNode line) = 12).
    self assert:((foundNode position) = 20).
    self assert:(foundNode statement isMessage).

    "Created: / 28-02-2011 / 15:58:52 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder6
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa.
                    d floor:u.
                    d floor:3 b:u.
                    self rememberSymbolUsed:nil. 
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:5
                position:20
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode line) = 5).
    self assert:((foundNode position) = 20).
    self assert:(foundNode node isAssignment).
    self assert:(foundNode statement isAssignment).

    "Created: / 25-02-2011 / 13:41:15 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder60
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor: u.
                    d floor:3  b:u.
                    self rememberSymbolUsed:nil. c call:b. b call:c dd:d.
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:12
                position:21
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode line) = 12).
    self assert:((foundNode position) = 21).
    self assert:(foundNode node isSelf).
    self assert:(foundNode node line = 12).
    self assert:(foundNode node charIndex = 21).
    self assert:(foundNode statement isMessage).

    "Created: / 28-02-2011 / 15:59:49 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder61
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor: u.
                    d floor:3  b:u.
                    self rememberSymbolUsed:nil. c call:b. b call:c dd:d.
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:12
                position:25
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode line) = 12).
    self assert:((foundNode position) = 25).
    self assert:(foundNode node isSelf).
    self assert:(foundNode node line = 12).
    self assert:(foundNode node charIndex = 21).
    self assert:(foundNode statement isMessage).

    "Created: / 28-02-2011 / 16:04:08 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder62
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor: u.
                    d floor:3  b:u.
                    self rememberSymbolUsed:nil. c call:b. b call:c dd:d.
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:12
                position:26
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode line) = 12).
    self assert:((foundNode position) = 26).
    self assert:(foundNode node isSelectorNode).
    self assert:(foundNode node selectors isSymbol).
    self assert:(foundNode node selectors asString = 'rememberSymbolUsed:').
    self assert:(foundNode node selectorsPosition size = 1).
    self assert:((foundNode node selectorsPosition at:1) = 26).
    self assert:(foundNode node lines size = 1).
    self assert:((foundNode node lines at:1) = 12).
    self assert:(foundNode statement isMessage).

    "Created: / 28-02-2011 / 16:04:35 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder63
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor: u.
                    d floor:3  b:u.
                    self rememberSymbolUsed:nil. c call:b. b call:c dd:d.
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:12
                position:44
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode line) = 12).
    self assert:((foundNode position) = 44).
    self assert:(foundNode node isSelectorNode).
    self assert:(foundNode node selectors isSymbol).
    self assert:(foundNode node selectors asString = 'rememberSymbolUsed:').
    self assert:(foundNode node selectorsPosition size = 1).
    self assert:((foundNode node selectorsPosition at:1) = 26).
    self assert:(foundNode node lines size = 1).
    self assert:((foundNode node lines at:1) = 12).
    self assert:(foundNode statement isMessage).

    "Created: / 28-02-2011 / 16:06:15 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder64
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor: u.
                    d floor:3  b:u.
                    self rememberSymbolUsed:nil. c call:b. b call:c dd:d.
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:12
                position:45
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode line) = 12).
    self assert:((foundNode position) = 45).
    self assert:(foundNode node isConstant).
    self assert:((foundNode node type) = #Nil).
    self assert:(foundNode node line = 12).
    self assert:(foundNode node charIndex = 45).
    self assert:(foundNode statement isMessage).

    "Created: / 28-02-2011 / 16:06:43 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder65
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor: u.
                    d floor:3  b:u.
                    self rememberSymbolUsed:nil  . c call:b. b call:c dd:d.
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:12
                position:48
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode line) = 12).
    self assert:((foundNode position) = 48).
    self assert:(foundNode node isConstant).
    self assert:((foundNode node type) = #Nil).
    self assert:(foundNode node line = 12).
    self assert:(foundNode node charIndex = 45).
    self assert:(foundNode statement isMessage).

    "Created: / 28-02-2011 / 16:08:29 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder66
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor: u.
                    d floor:3  b:u.
                    self rememberSymbolUsed:nil  . c call:b. b call:c dd:d.
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:12
                position:49
                tree:collector tree.
    self assert:(foundNode afterNode).
    self assert:((foundNode line) = 12).
    self assert:((foundNode position) = 49).
    self assert:(foundNode statement isMessage).

    "Created: / 28-02-2011 / 16:09:03 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder67
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor: u.
                    d floor:3  b:u.
                    self rememberSymbolUsed:nil  . c call:b. b call:c dd:d.
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:12
                position:50
                tree:collector tree.
    self assert:(foundNode afterNode).
    self assert:((foundNode line) = 12).
    self assert:((foundNode position) = 50).
    self assert:(foundNode statement isMessage).

    "Created: / 28-02-2011 / 16:29:10 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder68
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor: u.
                    d floor:3  b:u.
                    self rememberSymbolUsed:nil  . c call:b. b call:c dd:d.
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:12
                position:51
                tree:collector tree.
    self assert:(foundNode beforeNode).
    self assert:((foundNode line) = 12).
    self assert:((foundNode position) = 51).
    self assert:(foundNode statement isMessage).

    "Created: / 28-02-2011 / 16:29:26 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder69
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor: u.
                    d floor:3  b:u.
                    self rememberSymbolUsed:nil  . c call:b  . b call:c dd:d.
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:12
                position:52
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode line) = 12).
    self assert:((foundNode position) = 52).
    self assert:(foundNode node isVariable).
    self assert:(foundNode node name = 'c').
    self assert:(foundNode node line = 12).
    self assert:(foundNode node charIndex = 52).
    self assert:(foundNode statement isMessage).

    "Created: / 28-02-2011 / 16:30:18 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder7
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa.
                    d floor:u.
                    d floor:3 b:u.
                    self rememberSymbolUsed:nil. 
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:4
                position:21
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode line) = 4).
    self assert:((foundNode position) = 21).
    self assert:(foundNode node isAssignment).
    self assert:(foundNode statement isAssignment).

    "Created: / 25-02-2011 / 13:42:37 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder70
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor: u.
                    d floor:3  b:u.
                    self rememberSymbolUsed:nil  . c call:b  . b call:c dd:d.
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:12
                position:53
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode line) = 12).
    self assert:((foundNode position) = 53).
    self assert:(foundNode node isVariable).
    self assert:(foundNode node name = 'c').
    self assert:(foundNode node line = 12).
    self assert:(foundNode node charIndex = 52).
    self assert:(foundNode statement isMessage).

    "Created: / 28-02-2011 / 16:31:33 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder71
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor: u.
                    d floor:3  b:u.
                    self rememberSymbolUsed:nil  . c  call:b  . b call:c dd:d.
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:12
                position:54
                tree:collector tree.
    self assert:(foundNode afterNode).
    self assert:((foundNode line) = 12).
    self assert:((foundNode position) = 54).
    self assert:(foundNode node isVariable).
    self assert:(foundNode node name = 'c').
    self assert:(foundNode node line = 12).
    self assert:(foundNode node charIndex = 52).
    self assert:(foundNode statement isMessage).

    "Created: / 28-02-2011 / 16:32:27 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder72
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor: u.
                    d floor:3  b:u.
                    self rememberSymbolUsed:nil  . c  call:b  . b call:c dd:d.
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:12
                position:55
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode line) = 12).
    self assert:((foundNode position) = 55).
    self assert:(foundNode node isSelectorNode).
    self assert:(foundNode node selectors asString = 'call:').
    self assert:(foundNode node selectorsPosition size = 1).
    self assert:((foundNode node selectorsPosition at:1) = 55).
    self assert:(foundNode node lines size = 1).
    self assert:((foundNode node lines at:1) = 12).
    self assert:(foundNode statement isMessage).

    "Created: / 28-02-2011 / 16:32:49 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 18-03-2011 / 22:09:28 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder73
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor: u.
                    d floor:3  b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:12
                position:59
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode line) = 12).
    self assert:((foundNode position) = 59).
    self assert:(foundNode node isSelectorNode).
    self assert:(foundNode node selectors asString = 'call:').
    self assert:(foundNode node selectorsPosition size = 1).
    self assert:((foundNode node selectorsPosition at:1) = 55).
    self assert:(foundNode node lines size = 1).
    self assert:((foundNode node lines at:1) = 12).
    self assert:(foundNode statement isMessage).

    "Created: / 28-02-2011 / 17:28:35 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 18-03-2011 / 22:09:33 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder74
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor: u.
                    d floor:3  b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:12
                position:60
                tree:collector tree.
    self assert:(foundNode afterNode).
    self assert:((foundNode line) = 12).
    self assert:((foundNode position) = 60).
    self assert:(foundNode node isSelectorNode).
    self assert:(foundNode node selectors asString = 'call:').
    self assert:(foundNode node selectorsPosition size = 1).
    self assert:((foundNode node selectorsPosition at:1) = 55).
    self assert:(foundNode node lines size = 1).
    self assert:((foundNode node lines at:1) = 12).
    self assert:(foundNode statement isMessage).

    "Created: / 28-02-2011 / 17:29:57 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 18-03-2011 / 22:09:38 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder75
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor: u.
                    d floor:3  b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:12
                position:61
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode line) = 12).
    self assert:((foundNode position) = 61).
    self assert:(foundNode node isVariable).
    self assert:(foundNode node name = 'b').
    self assert:(foundNode node line = 12).
    self assert:(foundNode node charIndex = 61).
    self assert:(foundNode statement isMessage).

    "Created: / 28-02-2011 / 17:30:16 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder76
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor: u.
                    d floor:3  b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:12
                position:62
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode line) = 12).
    self assert:((foundNode position) = 62).
    self assert:(foundNode node isVariable).
    self assert:(foundNode node name = 'b').
    self assert:(foundNode node line = 12).
    self assert:(foundNode node charIndex = 61).
    self assert:(foundNode statement isMessage).

    "Created: / 28-02-2011 / 17:31:03 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder77
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor: u.
                    d floor:3  b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:12
                position:64
                tree:collector tree.
    self assert:(foundNode afterNode).
    self assert:((foundNode line) = 12).
    self assert:((foundNode position) = 64).
    self assert:(foundNode statement isMessage).

    "Created: / 28-02-2011 / 17:31:44 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder78
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor: u.
                    d floor:3  b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:12
                position:65
                tree:collector tree.
    self assert:(foundNode beforeNode).
    self assert:((foundNode line) = 12).
    self assert:((foundNode position) = 65).
    self assert:(foundNode statement isMessage).

    "Created: / 28-02-2011 / 17:34:50 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder79
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor: u.
                    d floor:3  b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:12
                position:66
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode line) = 12).
    self assert:((foundNode position) = 66).
    self assert:(foundNode node isVariable).
    self assert:(foundNode node name = 'b').
    self assert:(foundNode node line = 12).
    self assert:(foundNode node charIndex = 66).
    self assert:(foundNode statement isMessage).

    "Created: / 28-02-2011 / 17:35:28 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder8
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa.
                    d floor:u.
                    d floor:3 b:u.
                    self rememberSymbolUsed:nil. 
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:5
                position:22
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode line) = 5).
    self assert:((foundNode position) = 22).
    self assert:(foundNode node isConstant).
    self assert:(foundNode node value = 3).
    self assert:(foundNode node line = 5).
    self assert:(foundNode node charIndex = 22).
    self assert:(foundNode statement isAssignment).

    "Created: / 25-02-2011 / 13:43:50 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder80
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor: u.
                    d floor:3  b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:12
                position:79
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode line) = 12).
    self assert:((foundNode position) = 79).
    self assert:(foundNode node isVariable).
    self assert:(foundNode node name = 'd').
    self assert:(foundNode node line = 12).
    self assert:(foundNode node charIndex = 78).
    self assert:(foundNode statement isMessage).

    "Created: / 28-02-2011 / 17:36:26 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder81
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor: u.
                    d floor:3  b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:12
                position:80
                tree:collector tree.
    self assert:(foundNode beforeNode).
    self assert:((foundNode line) = 12).
    self assert:((foundNode position) = 80).
    self assert:(foundNode statement isAssignment).

    "Created: / 28-02-2011 / 17:36:59 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder82
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor: u.
                    d floor:3  b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:13
                position:20
                tree:collector tree.
    self assert:(foundNode beforeNode).
    self assert:((foundNode line) = 13).
    self assert:((foundNode position) = 20).
    self assert:(foundNode statement isAssignment).

    "Created: / 28-02-2011 / 17:38:37 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder83
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor: u.
                    d floor:3  b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:13
                position:21
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode line) = 13).
    self assert:((foundNode position) = 21).
    self assert:(foundNode node isVariable).
    self assert:(foundNode node name = 'array').
    self assert:(foundNode node line = 13).
    self assert:(foundNode node charIndex = 21).
    self assert:(foundNode statement isAssignment).

    "Created: / 28-02-2011 / 17:39:51 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder84
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor: u.
                    d floor:3  b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:13
                position:26
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode line) = 13).
    self assert:((foundNode position) = 26).
    self assert:(foundNode node isVariable).
    self assert:(foundNode node name = 'array').
    self assert:(foundNode node line = 13).
    self assert:(foundNode node charIndex = 21).
    self assert:(foundNode statement isAssignment).

    "Created: / 28-02-2011 / 17:40:54 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder85
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor: u.
                    d floor:3  b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:13
                position:30
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode line) = 13).
    self assert:((foundNode position) = 30).
    self assert:(foundNode node isConstant).
    self assert:(foundNode node type = #Array).
    self assert:(foundNode node line = 13).
    self assert:(foundNode node charIndex = 30).
    self assert:(foundNode statement isAssignment).

    "Created: / 28-02-2011 / 17:41:18 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder86
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor: u.
                    d floor:3  b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:14
                position:30
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode line) = 14).
    self assert:((foundNode position) = 30).
    self assert:(foundNode node isConstant).
    self assert:(foundNode node type = #Array).
    self assert:(foundNode node line = 13).
    self assert:(foundNode node charIndex = 30).
    self assert:(foundNode statement isAssignment).

    "Created: / 28-02-2011 / 17:42:54 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder87
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor: u.
                    d floor:3  b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:15
                position:22
                tree:collector tree.
    self assert:(foundNode afterNode).
    self assert:((foundNode line) = 15).
    self assert:((foundNode position) = 22).
    self assert:(foundNode statement isAssignment).

    "Created: / 28-02-2011 / 17:43:20 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder88
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor: u.
                    d floor:3  b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:16
                position:20
                tree:collector tree.
    self assert:(foundNode beforeNode).
    self assert:((foundNode line) = 16).
    self assert:((foundNode position) = 20).
    self assert:(foundNode statement isAssignment).

    "Created: / 28-02-2011 / 17:44:33 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder89
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor: u.
                    d floor:3  b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:16
                position:21
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode line) = 16).
    self assert:((foundNode position) = 21).
    self assert:(foundNode node isVariable).
    self assert:(foundNode node name = 'val').
    self assert:(foundNode node line = 16).
    self assert:(foundNode node charIndex = 21).
    self assert:(foundNode statement isAssignment).

    "Created: / 28-02-2011 / 17:51:48 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder9
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa.
                    d floor:u.
                    d floor:3 b:u.
                    self rememberSymbolUsed:nil. 
                    array:=#(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:5
                position:23
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode line) = 5).
    self assert:((foundNode position) = 23).
    self assert:(foundNode node isConstant).
    self assert:(foundNode node value = 3).
    self assert:(foundNode node line = 5).
    self assert:(foundNode node charIndex = 22).
    self assert:(foundNode statement isAssignment).

    "Created: / 25-02-2011 / 13:44:06 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder90
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor: u.
                    d floor:3  b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:16
                position:24
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode line) = 16).
    self assert:((foundNode position) = 24).
    self assert:(foundNode node isVariable).
    self assert:(foundNode node name = 'val').
    self assert:(foundNode node line = 16).
    self assert:(foundNode node charIndex = 21).
    self assert:(foundNode statement isAssignment).

    "Created: / 28-02-2011 / 18:16:29 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder91
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor: u.
                    d floor:3  b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:16
                position:25
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode line) = 16).
    self assert:((foundNode position) = 25).
    self assert:(foundNode node isAssignment).
    self assert:(foundNode statement isAssignment).

    "Created: / 28-02-2011 / 18:16:46 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder92
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor: u.
                    d floor:3  b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:16
                position:27
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode line) = 16).
    self assert:((foundNode position) = 27).
    self assert:(foundNode node isAssignment).
    self assert:(foundNode statement isAssignment).

    "Created: / 28-02-2011 / 18:17:24 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder93
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor: u.
                    d floor:3  b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:16
                position:28
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode line) = 16).
    self assert:((foundNode position) = 28).
    self assert:(foundNode node isVariable).
    self assert:(foundNode node name isSymbol).
    self assert:(foundNode node name asString = 'ConstantNode').
    self assert:(foundNode node line = 16).
    self assert:(foundNode node charIndex = 28).
    self assert:(foundNode statement isAssignment).

    "Created: / 28-02-2011 / 18:17:40 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder94
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor: u.
                    d floor:3  b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:16
                position:40
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode line) = 16).
    self assert:((foundNode position) = 40).
    self assert:(foundNode node isVariable).
    self assert:(foundNode node name isSymbol).
    self assert:(foundNode node name asString = 'ConstantNode').
    self assert:(foundNode node line = 16).
    self assert:(foundNode node charIndex = 28).
    self assert:(foundNode statement isAssignment).

    "Created: / 28-02-2011 / 18:19:16 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder95
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor: u.
                    d floor:3  b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:17
                position:41
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode line) = 17).
    self assert:((foundNode position) = 41).
    self assert:(foundNode node isSelectorNode).
    self assert:(foundNode node selectors isSymbol).
    self assert:(foundNode node selectors asString = 'type:value:').
    self assert:(foundNode node selectorsPosition size = 2).
    self assert:((foundNode node selectorsPosition at:1) = 41).
    self assert:((foundNode node selectorsPosition at:2) = 41).
    self assert:(foundNode node lines size = 2).
    self assert:((foundNode node lines at:1) = 16).
    self assert:((foundNode node lines at:2) = 17).
    self assert:(foundNode statement isAssignment).

    "Created: / 28-02-2011 / 18:19:53 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder96
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor: u.
                    d floor:3  b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:16
                position:55
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode line) = 16).
    self assert:((foundNode position) = 55).
    self assert:(foundNode node isVariable).
    self assert:(foundNode node name = 'tokenType').
    self assert:(foundNode node line = 16).
    self assert:(foundNode node charIndex = 46).
    self assert:(foundNode statement isAssignment).

    "Created: / 28-02-2011 / 18:23:07 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder97
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor: u.
                    d floor:3  b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:17
                position:57
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode line) = 17).
    self assert:((foundNode position) = 57).
    self assert:(foundNode node isVariable).
    self assert:(foundNode node name = 'tokenValue').
    self assert:(foundNode node line = 17).
    self assert:(foundNode node charIndex = 47).
    self assert:(foundNode statement isAssignment).

    "Created: / 28-02-2011 / 18:24:30 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder98
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor: u.
                    d floor:3  b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:18
                position:20
                tree:collector tree.
    self assert:(foundNode beforeNode).
    self assert:((foundNode line) = 18).
    self assert:((foundNode position) = 20).
    self assert:(foundNode statement isMessage).

    "Created: / 28-02-2011 / 18:25:13 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinder99
    |collector finder foundNode|

    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd tokenType array|
                    u 
                    := 
                     3.
                    b:=u.
                    c:=u 
                        floor 
                        aa   .
                    d  floor: u.
                    d floor:3  b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4 
                    5 6 
                    ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ].
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:18
                position:21
                tree:collector tree.
    self assert:(foundNode beforeNode).
    self assert:((foundNode line) = 18).
    self assert:((foundNode position) = 21).
    self assert:(foundNode statement isMessage).

    "Created: / 28-02-2011 / 18:26:31 / Jakub <zelenja7@fel.cvut.cz>"
! !

!FinderTests methodsFor:'FinderTestsErrorNode'!

testFinderErrorNode1
    |collector finder foundNode|

    collector := self 
                doForSource:'
                    
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u.
                    d floor: 3 b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:2
                position:1
                tree:collector tree.
    self assert:(foundNode beforeNode).
    self assert:((foundNode line) = 2).
    self assert:((foundNode position) = 1).
    self assert:(foundNode statement isAssignment).

    "Created: / 02-03-2011 / 15:34:00 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinderErrorNode10
    |collector finder foundNode|

    collector := self 
                doForSource:'
|helperNode b c d|
b := 3 f
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u.
                    d floor: 3 b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:3
                position:9
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode line) = 3).
    self assert:((foundNode position) = 9).
    self assert:(foundNode node isSelectorNode).
    self assert:(foundNode statement isAssignment).

    "Created: / 02-03-2011 / 17:27:59 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinderErrorNode11
    |collector finder foundNode|

    collector := self 
                doForSource:'
|helperNode b c d|
b := 3 floor:
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u.
                    d floor: 3 b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:3
                position:14
                tree:collector tree.
    self assert:(foundNode afterNode).
    self assert:((foundNode line) = 3).
    self assert:((foundNode position) = 14).
    self assert:(foundNode node isSelectorNode).
    self assert:(foundNode statement isAssignment).

    "Created: / 02-03-2011 / 17:29:25 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinderErrorNode12
    |collector finder foundNode|

    collector := self 
                doForSource:'
|helperNode b c d|
b := 3 floor: (
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u.
                    d floor: 3 b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:3
                position:16
                tree:collector tree.
    self assert:(foundNode afterNode).
    self assert:((foundNode line) = 3).
    self assert:((foundNode position) = 16).
    self assert:(foundNode node isSelectorNode).
    self assert:(foundNode statement isAssignment).

    "Created: / 02-03-2011 / 17:30:13 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinderErrorNode13
    |collector finder foundNode|

    collector := self 
                doForSource:'
|helperNode b c d|
b := 3 floor: ( s
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u.
                    d floor: 3 b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:3
                position:18
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode line) = 3).
    self assert:((foundNode position) = 18).
    self assert:(foundNode node isVariable).
    self assert:(foundNode statement isAssignment).

    "Created: / 02-03-2011 / 17:31:44 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinderErrorNode14
    |collector finder foundNode|

    collector := self 
                doForSource:'
|helperNode b c d|
b := 3 floor: ( self
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u.
                    d floor: 3 b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:3
                position:21
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode line) = 3).
    self assert:((foundNode position) = 21).
    self assert:(foundNode node isSelf).
    self assert:(foundNode statement isAssignment).

    "Created: / 02-03-2011 / 17:33:10 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinderErrorNode15
    |collector finder foundNode|

    collector := self 
                doForSource:'
|helperNode b c d|
b := 3 floor: ( self
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u.
                    d floor: 3 b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:3
                position:22
                tree:collector tree.
    self assert:(foundNode afterNode).
    self assert:((foundNode line) = 3).
    self assert:((foundNode position) = 22).
    self assert:(foundNode node isSelf).
    self assert:(foundNode statement isAssignment).

    "Created: / 02-03-2011 / 17:33:20 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinderErrorNode16
    |collector finder foundNode|

    collector := self 
                doForSource:'
|helperNode b c d|
b := 3 floor: ( self b
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u.
                    d floor: 3 b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:3
                position:23
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode line) = 3).
    self assert:((foundNode position) = 23).
    self assert:(foundNode node isSelectorNode).
    self assert:(foundNode statement isAssignment).

    "Created: / 02-03-2011 / 17:35:09 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinderErrorNode17
    |collector finder foundNode|

    collector := self 
                doForSource:'
|helperNode b c d|
b := 3 floor: ( self b b:
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u.
                    d floor: 3 b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:3
                position:26
                tree:collector tree.
    self assert:(foundNode afterNode).
    self assert:((foundNode line) = 3).
    self assert:((foundNode position) = 26).
    self assert:(foundNode node isSelectorNode).
    self assert:(foundNode statement isAssignment).

    "Created: / 02-03-2011 / 17:36:02 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinderErrorNode18
    |collector finder foundNode|

    collector := self 
                doForSource:'
|helperNode b c d|
b := 3 floor: ( self b b:
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u.
                    d floor: 3 b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:3
                position:25
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode line) = 3).
    self assert:((foundNode position) = 25).
    self assert:(foundNode node isSelectorNode).
    self assert:(foundNode statement isAssignment).
    self assert:(foundNode beforeStatement notNil).
    self assert:(foundNode beforeStatement isMessage).

    "Created: / 02-03-2011 / 17:38:35 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 03-03-2011 / 18:22:41 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinderErrorNode19
    |collector finder foundNode|

    collector := self 
                doForSource:'
|helperNode b c d|
b := 3 floor: ( self b b:
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u.
                    d floor: 3 b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:3
                position:26
                tree:collector tree.
    self assert:(foundNode afterNode).
    self assert:((foundNode line) = 3).
    self assert:((foundNode position) = 26).
    self assert:(foundNode node isSelectorNode).
    self assert:(foundNode statement isAssignment).
    self assert:(foundNode beforeStatement notNil).
    self assert:(foundNode beforeStatement isSelectorNode).

    "Created: / 02-03-2011 / 20:01:58 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 03-03-2011 / 18:23:37 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinderErrorNode2
    |collector finder foundNode|

    collector := self 
                doForSource:'
|                    
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u.
                    d floor: 3 b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:2
                position:2
                tree:collector tree.
    self assert:(foundNode beforeNode).
    self assert:((foundNode line) = 2).
    self assert:((foundNode position) = 2).
    self assert:(foundNode statement isErrorNode).
    self assert:(foundNode statement errorToken = ':=').
    self assert:(foundNode beforeStatement isNil).

    "Created: / 02-03-2011 / 15:34:12 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinderErrorNode20
    |collector finder foundNode|

    collector := self 
                doForSource:'
|helperNode b c d|
b := 3 floor: ( self b b:)
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u.
                    d floor: 3 b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:3
                position:27
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode line) = 3).
    self assert:((foundNode position) = 27).
    self assert:(foundNode node isErrorNode).
    self assert:(foundNode statement isAssignment).
    self assert:(foundNode beforeStatement notNil).
    self assert:(foundNode beforeStatement isSelectorNode).

    "Created: / 03-03-2011 / 18:24:01 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinderErrorNode21
    |collector finder foundNode|

    collector := self 
                doForSource:'
|helperNode b c d|
b := 3 floor: ( self b b:) r
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u.
                    d floor: 3 b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:3
                position:28
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode line) = 3).
    self assert:((foundNode position) = 28).
    self assert:(foundNode node isSelectorNode).
    self assert:(foundNode statement isAssignment).
    self assert:(foundNode beforeStatement notNil).
    self assert:(foundNode beforeStatement isMessage).

    "Created: / 03-03-2011 / 18:26:16 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinderErrorNode22
    |collector finder foundNode|

    collector := self 
                doForSource:'
|helperNode b c d|
b := 3 floor: ( self b b:) round:
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u.
                    d floor: 3 b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:3
                position:34
                tree:collector tree.
    self assert:(foundNode afterNode).
    self assert:((foundNode line) = 3).
    self assert:((foundNode position) = 34).
    self assert:(foundNode node isSelectorNode).
    self assert:(foundNode statement isAssignment).
    self assert:(foundNode beforeStatement notNil).
    self assert:(foundNode beforeStatement isSelectorNode).

    "Created: / 03-03-2011 / 18:27:16 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinderErrorNode23
    |collector finder foundNode|

    collector := self 
                doForSource:'
|helperNode b c d|
b := 3 floor: ( self b b:) round: a
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u.
                    d floor: 3 b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:3
                position:36
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode line) = 3).
    self assert:((foundNode position) = 36).
    self assert:(foundNode node isVariable).
    self assert:(foundNode statement isAssignment).
    self assert:(foundNode beforeStatement notNil).
    self assert:(foundNode beforeStatement isSelectorNode).

    "Created: / 03-03-2011 / 21:05:27 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinderErrorNode24
    |collector finder foundNode|

    collector := self 
                doForSource:'
|helperNode b c d|
b := 3 floor: ( self b b:) round: a:
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u.
                    d floor: 3 b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:3
                position:37
                tree:collector tree.
    self assert:(foundNode afterNode).
    self assert:((foundNode line) = 3).
    self assert:((foundNode position) = 37).
    self assert:(foundNode node isSelectorNode).
    self assert:(foundNode statement isAssignment).
    self assert:(foundNode beforeStatement notNil).
    self assert:(foundNode beforeStatement isSelectorNode).

    "Created: / 03-03-2011 / 21:05:49 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinderErrorNode25
    |collector finder foundNode|

    collector := self 
                doForSource:'
|helperNode b c d|
b := 3 floor: ( self b b:) round: a:. 
:
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u.
                    d floor: 3 b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:4
                position:2
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode line) = 4).
    self assert:((foundNode position) = 2).
    self assert:(foundNode node isErrorNode).
    self assert:(foundNode statement isErrorNode).
    self assert:(foundNode beforeStatement notNil).
    self assert:(foundNode beforeStatement isAssignment).

    "Created: / 03-03-2011 / 21:09:10 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinderErrorNode26
    |collector finder foundNode|

    collector := self 
                doForSource:'
|helperNode b c d|
b := 3 floor: ( self b b:) round: a:. 
:=
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u.
                    d floor: 3 b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:4
                position:3
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode line) = 4).
    self assert:((foundNode position) = 3).
    self assert:(foundNode node isErrorNode).
    self assert:(foundNode statement isErrorNode).
    self assert:(foundNode beforeStatement notNil).
    self assert:(foundNode beforeStatement isAssignment).

    "Created: / 03-03-2011 / 21:12:12 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinderErrorNode3
    |collector finder foundNode|

    collector := self 
                doForSource:'
||                    
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u.
                    d floor: 3 b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:2
                position:3
                tree:collector tree.
    self assert:(foundNode beforeNode).
    self assert:((foundNode line) = 2).
    self assert:((foundNode position) = 3).
    self assert:(foundNode statement isAssignment).

    "Created: / 02-03-2011 / 16:31:36 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinderErrorNode4
    |collector finder foundNode|

    collector := self 
                doForSource:'
|helperNode b c d|
b
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u.
                    d floor: 3 b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:3
                position:2
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode line) = 3).
    self assert:((foundNode position) = 2).
    self assert:(foundNode node isVariable).
    self assert:(foundNode node name = 'b').
    self assert:(foundNode node line = 3).
    self assert:(foundNode node charIndex = 1).
    self assert:(foundNode statement isMessage).

    "Created: / 02-03-2011 / 16:33:15 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinderErrorNode5
    |collector finder foundNode|

    collector := self 
                doForSource:'
|helperNode b c d|
b
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u.
                    d floor: 3 b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:3
                position:3
                tree:collector tree.
    self assert:(foundNode afterNode).
    self assert:((foundNode line) = 3).
    self assert:((foundNode position) = 3).
    self assert:(foundNode node isVariable).
    self assert:(foundNode node name = 'b').
    self assert:(foundNode node line = 3).
    self assert:(foundNode node charIndex = 1).
    self assert:(foundNode statement isMessage).

    "Created: / 02-03-2011 / 16:38:07 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinderErrorNode6
    |collector finder foundNode|

    collector := self 
                doForSource:'
|helperNode b c d|
b :
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u.
                    d floor: 3 b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:3
                position:4
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode line) = 3).
    self assert:((foundNode position) = 4).
    self assert:(foundNode node isErrorNode).
    self assert:(foundNode node errorToken = ':').
    self assert:(foundNode node line = 3).
    self assert:(foundNode node charIndex = 3).
    self assert:(foundNode statement isErrorNode).
    self assert:(foundNode beforeStatement notNil).
    self assert:(foundNode beforeStatement isVariable).

    "Created: / 02-03-2011 / 16:38:34 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinderErrorNode7
    |collector finder foundNode|

    collector := self 
                doForSource:'
|helperNode b c d|
b :=
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u.
                    d floor: 3 b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:3
                position:5
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode line) = 3).
    self assert:((foundNode position) = 5).
    self assert:(foundNode node isAssignment).
    self assert:(foundNode statement isAssignment).

    "Created: / 02-03-2011 / 16:41:19 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinderErrorNode8
    |collector finder foundNode|

    collector := self 
                doForSource:'
|helperNode b c d|
b := 3
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u.
                    d floor: 3 b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:3
                position:7
                tree:collector tree.
    self assert:(foundNode inNode).
    self assert:((foundNode line) = 3).
    self assert:((foundNode position) = 7).
    self assert:(foundNode node isConstant).
    self assert:(foundNode statement isAssignment).

    "Created: / 02-03-2011 / 17:26:32 / Jakub <zelenja7@fel.cvut.cz>"
!

testFinderErrorNode9
    |collector finder foundNode|

    collector := self 
                doForSource:'
|helperNode b c d|
b := 3
                    u := 3.
                    b:=u.
                    c:=u floor  aa   .
                    d  floor: u.
                    d floor: 3 b:u.
                    self rememberSymbolUsed:nil  . c  call: b  . b call:c dd:d.
                    array := #(3 4  5 6 ).
                    val := ConstantNode type:tokenType 
                                        value:tokenValue.
                    [ u== #Symbol  or: [u=3  ]  ]  ifTrue:[
                    uu := 4.
                    bb:=uu.
                    cc:=uu floor.
                    dd floor:uu.
                    dd floor:3 b:uu.
                    ].
                    dd do:[:w|w seduce.
                    ]   
                    ^self.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    finder := SmallSenseFinder new.
    foundNode := finder 
                find:3
                position:8
                tree:collector tree.
    self assert:(foundNode afterNode).
    self assert:((foundNode line) = 3).
    self assert:((foundNode position) = 8).
    self assert:(foundNode node isConstant).
    self assert:(foundNode statement isAssignment).

    "Created: / 02-03-2011 / 17:27:33 / Jakub <zelenja7@fel.cvut.cz>"
! !

!FinderTests class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id$'
! !

