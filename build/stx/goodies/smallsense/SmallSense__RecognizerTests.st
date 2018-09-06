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

TestCase subclass:#RecognizerTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SmallSense-Tests-Obsolete'
!

!RecognizerTests class methodsFor:'documentation'!

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

!RecognizerTests methodsFor:'RecognizerTest'!

testRecognizer1
    |collector recognizer foundCollection|

    collector := self 
                doForSource:'
| ahoj|        

                    u := 3.
                    b:=u.
                    c:=  u  floor  aa   .
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
    recognizer := SmallSenseRecognizer new.
    foundCollection := recognizer 
                recognize:2
                position:2
                collector:collector.
    self assert:(foundCollection ~~ OrderedCollection).
    self assert:(foundCollection objectNameCollection size > 17).

    "    self assert:(foundNode beforeNode).
        self assert:((foundNode line)=2).
        self assert:((foundNode position)=2).
        self assert:(foundNode statement isErrorNode).
        self assert:(foundNode statement errorToken =':=').
        self assert:(foundNode beforeStatement isNil)."

    "Created: / 04-03-2011 / 12:55:37 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 17-03-2011 / 18:45:41 / Jakub <zelenja7@fel.cvut.cz>"
!

testRecognizer10
    |collector recognizer foundCollection|

    collector := self 
                doForSource:'
| helper|
    c
                    u := 3.
                    b:=u.
                    c:=  u  floor  aa   .
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
    recognizer := SmallSenseRecognizer new.
    foundCollection := recognizer 
                recognize:3
                position:7
                collector:collector.
    self assert:(foundCollection ~~ OrderedCollection).
    self assert:(foundCollection objectNameCollection size > 18).

    "    self assert:(foundNode beforeNode).
        self assert:((foundNode line)=2).
        self assert:((foundNode position)=2).
        self assert:(foundNode statement isErrorNode).
        self assert:(foundNode statement errorToken =':=').
        self assert:(foundNode beforeStatement isNil)."

    "Created: / 07-03-2011 / 19:27:26 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 17-03-2011 / 18:49:13 / Jakub <zelenja7@fel.cvut.cz>"
!

testRecognizer11
    |collector recognizer foundCollection|

    collector := self 
                doForSource:'
| helper|
    c fl
                    u := 3.
                    b:=u.
                    c:=  u  floor  aa   .
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
    recognizer := SmallSenseRecognizer new.
    foundCollection := recognizer 
                recognize:3
                position:7
                collector:collector.
    self assert:(foundCollection ~~ OrderedCollection).
    self assert:(foundCollection objectNameCollection size > 18).

    "    self assert:(foundNode beforeNode).
        self assert:((foundNode line)=2).
        self assert:((foundNode position)=2).
        self assert:(foundNode statement isErrorNode).
        self assert:(foundNode statement errorToken =':=').
        self assert:(foundNode beforeStatement isNil)."

    "Created: / 07-03-2011 / 19:34:06 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 17-03-2011 / 18:50:27 / Jakub <zelenja7@fel.cvut.cz>"
!

testRecognizer12
    |collector recognizer foundCollection|

    collector := self 
                doForSource:'
| helper|
    c fl:[
                    u := 3.
                    b:=u.
                    c:=  u  floor  aa   .
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
    recognizer := SmallSenseRecognizer new.
    foundCollection := recognizer 
                recognize:3
                position:12
                collector:collector.
    self assert:(foundCollection ~~ OrderedCollection).
    self assert:(foundCollection objectNameCollection size > 48).

    "    self assert:(foundNode beforeNode).
        self assert:((foundNode line)=2).
        self assert:((foundNode position)=2).
        self assert:(foundNode statement isErrorNode).
        self assert:(foundNode statement errorToken =':=').
        self assert:(foundNode beforeStatement isNil)."

    "Created: / 07-03-2011 / 19:39:40 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 06-04-2011 / 19:04:40 / Jakub <zelenja7@fel.cvut.cz>"
!

testRecognizer13
    |collector recognizer foundCollection|

    collector := self 
                doForSource:'
| helper|
    c fl:[# >
                    u := 3.
                    b:=u.
                    c:=  u  floor  aa   .
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
    recognizer := SmallSenseRecognizer new.
    foundCollection := recognizer 
                recognize:3
                position:14
                collector:collector.
    self assert:(foundCollection ~~ OrderedCollection).
    self assert:(foundCollection objectNameCollection size > 48).

    "    self assert:(foundNode beforeNode).
        self assert:((foundNode line)=2).
        self assert:((foundNode position)=2).
        self assert:(foundNode statement isErrorNode).
        self assert:(foundNode statement errorToken =':=').
        self assert:(foundNode beforeStatement isNil)."

    "Created: / 07-03-2011 / 19:40:28 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 06-04-2011 / 19:04:55 / Jakub <zelenja7@fel.cvut.cz>"
!

testRecognizer14
    |collector recognizer foundCollection|

    collector := self 
                doForSource:'
| helper|
    c fl:[# >  he
                    u := 3.
                    b:=u.
                    c:=  u  floor  aa   .
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
    recognizer := SmallSenseRecognizer new.
    foundCollection := recognizer 
                recognize:3
                position:18
                collector:collector.
    self assert:(foundCollection ~~ OrderedCollection).
    self assert:(foundCollection objectNameCollection size = 3).

    "    self assert:(foundNode beforeNode).
        self assert:((foundNode line)=2).
        self assert:((foundNode position)=2).
        self assert:(foundNode statement isErrorNode).
        self assert:(foundNode statement errorToken =':=').
        self assert:(foundNode beforeStatement isNil)."

    "Created: / 07-03-2011 / 19:43:01 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 06-04-2011 / 19:05:34 / Jakub <zelenja7@fel.cvut.cz>"
!

testRecognizer15
    |collector recognizer foundCollection|

    collector := self 
                doForSource:'
| helper|
    c fl:[# >  he   ah
                    u := 3.
                    b:=u.
                    c:=  u  floor  aa   .
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
    recognizer := SmallSenseRecognizer new.
    foundCollection := recognizer 
                recognize:3
                position:23
                collector:collector.
    self assert:(foundCollection ~~ OrderedCollection).
    self assert:(foundCollection objectNameCollection size > 48).

    "    self assert:(foundNode beforeNode).
        self assert:((foundNode line)=2).
        self assert:((foundNode position)=2).
        self assert:(foundNode statement isErrorNode).
        self assert:(foundNode statement errorToken =':=').
        self assert:(foundNode beforeStatement isNil)."

    "Created: / 07-03-2011 / 19:55:35 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 06-04-2011 / 19:05:44 / Jakub <zelenja7@fel.cvut.cz>"
!

testRecognizer16
    |collector recognizer foundCollection|

    collector := self 
                doForSource:'
self

                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    recognizer := SmallSenseRecognizer new.
    foundCollection := recognizer 
                recognize:2
                position:6
                collector:collector.
    self assert:(foundCollection ~~ OrderedCollection).
    self assert:(foundCollection objectNameCollection size >= self class selectors size).

    "    self assert:(foundNode beforeNode).
        self assert:((foundNode line)=2).
        self assert:((foundNode position)=2).
        self assert:(foundNode statement isErrorNode).
        self assert:(foundNode statement errorToken =':=').
        self assert:(foundNode beforeStatement isNil)."

    "Created: / 04-04-2011 / 14:05:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-04-2011 / 19:05:56 / Jakub <zelenja7@fel.cvut.cz>"
!

testRecognizer2
    |collector recognizer foundCollection|

    collector := self 
                doForSource:'
| ahoj|
    u
                    u := 3.
                    b:=u.
                    c:=  u  floor  aa   .
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
    recognizer := SmallSenseRecognizer new.
    foundCollection := recognizer 
                recognize:3
                position:7
                collector:collector.
    self assert:(foundCollection ~~ OrderedCollection).
    self assert:(foundCollection objectNameCollection size > 92).

    "    self assert:(foundNode beforeNode).
        self assert:((foundNode line)=2).
        self assert:((foundNode position)=2).
        self assert:(foundNode statement isErrorNode).
        self assert:(foundNode statement errorToken =':=').
        self assert:(foundNode beforeStatement isNil)."

    "Created: / 04-03-2011 / 16:23:04 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 17-03-2011 / 18:46:09 / Jakub <zelenja7@fel.cvut.cz>"
!

testRecognizer3
    |collector recognizer foundCollection|

    collector := self 
                doForSource:'
| helper|
    helper
                    u := 3.
                    b:=u.
                    c:=  u  floor  aa   .
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
    recognizer := SmallSenseRecognizer new.
    foundCollection := recognizer 
                recognize:3
                position:12
                collector:collector.
    self assert:(foundCollection ~~ OrderedCollection).
    self assert:(foundCollection objectNameCollection size =1).

    "    self assert:(foundNode beforeNode).
        self assert:((foundNode line)=2).
        self assert:((foundNode position)=2).
        self assert:(foundNode statement isErrorNode).
        self assert:(foundNode statement errorToken =':=').
        self assert:(foundNode beforeStatement isNil)."

    "Created: / 04-03-2011 / 17:40:05 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 17-03-2011 / 18:47:48 / Jakub <zelenja7@fel.cvut.cz>"
!

testRecognizer4
    |collector recognizer foundCollection|

    collector := self 
                doForSource:'
| helper|
    10
                    u := 3.
                    b:=u.
                    c:=  u  floor  aa   .
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
    recognizer := SmallSenseRecognizer new.
    foundCollection := recognizer 
                recognize:3
                position:8
                collector:collector.
    self assert:(foundCollection ~~ OrderedCollection).
    self assert:(foundCollection objectNameCollection size >= 142).

    "    self assert:(foundNode beforeNode).
        self assert:((foundNode line)=2).
        self assert:((foundNode position)=2).
        self assert:(foundNode statement isErrorNode).
        self assert:(foundNode statement errorToken =':=').
        self assert:(foundNode beforeStatement isNil)."

    "Created: / 07-03-2011 / 18:14:26 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 17-03-2011 / 18:41:05 / Jakub <zelenja7@fel.cvut.cz>"
!

testRecognizer5
    |collector recognizer foundCollection|

    collector := self 
                doForSource:'
| helper|
    self
                    u := 3.
                    b:=u.
                    c:=  u  floor  aa   .
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
    recognizer := SmallSenseRecognizer new.
    foundCollection := recognizer 
                recognize:3
                position:10
                collector:collector.
    self assert:(foundCollection ~~ OrderedCollection).
    self assert:(foundCollection objectNameCollection size >= self class selectors size).

    "    self assert:(foundNode beforeNode).
        self assert:((foundNode line)=2).
        self assert:((foundNode position)=2).
        self assert:(foundNode statement isErrorNode).
        self assert:(foundNode statement errorToken =':=').
        self assert:(foundNode beforeStatement isNil)."

    "Created: / 07-03-2011 / 18:33:31 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 04-04-2011 / 14:06:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-04-2011 / 19:06:08 / Jakub <zelenja7@fel.cvut.cz>"
!

testRecognizer6
    |collector recognizer foundCollection|

    collector := self 
                doForSource:'
| helper|
    super
                    u := 3.
                    b:=u.
                    c:=  u  floor  aa   .
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
    recognizer := SmallSenseRecognizer new.
    foundCollection := recognizer 
                recognize:3
                position:11
                collector:collector.
    self assert:(foundCollection ~~ OrderedCollection).
    self assert:(foundCollection objectNameCollection size >= 503).

    "    self assert:(foundNode beforeNode).
        self assert:((foundNode line)=2).
        self assert:((foundNode position)=2).
        self assert:(foundNode statement isErrorNode).
        self assert:(foundNode statement errorToken =':=').
        self assert:(foundNode beforeStatement isNil)."

    "Created: / 07-03-2011 / 18:35:35 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 08-04-2011 / 00:06:23 / Jakub <zelenja7@fel.cvut.cz>"
!

testRecognizer7
    |collector recognizer foundCollection|

    collector := self 
                doForSource:'
| helper|
    :
                    u := 3.
                    b:=u.
                    c:=  u  floor  aa   .
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
    recognizer := SmallSenseRecognizer new.
    foundCollection := recognizer 
                recognize:3
                position:11
                collector:collector.
    self assert:(foundCollection ~~ OrderedCollection).
    self assert:(foundCollection objectNameCollection size >17).

    "    self assert:(foundNode beforeNode).
        self assert:((foundNode line)=2).
        self assert:((foundNode position)=2).
        self assert:(foundNode statement isErrorNode).
        self assert:(foundNode statement errorToken =':=').
        self assert:(foundNode beforeStatement isNil)."

    "Created: / 07-03-2011 / 18:39:58 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 17-03-2011 / 18:45:29 / Jakub <zelenja7@fel.cvut.cz>"
!

testRecognizer8
    |collector recognizer foundCollection|

    collector := self 
                doForSource:'
| helper|
    :
                    u := 3.
                    b:=u.
                    c:=  u  floor  aa   .
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
    recognizer := SmallSenseRecognizer new.
    foundCollection := recognizer 
                recognize:3
                position:6
                collector:collector.
    self assert:(foundCollection ~~ OrderedCollection).
    self assert:(foundCollection objectNameCollection size >= 48).

    "    self assert:(foundNode beforeNode).
        self assert:((foundNode line)=2).
        self assert:((foundNode position)=2).
        self assert:(foundNode statement isErrorNode).
        self assert:(foundNode statement errorToken =':=').
        self assert:(foundNode beforeStatement isNil)."

    "Created: / 07-03-2011 / 19:26:53 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 06-04-2011 / 19:07:02 / Jakub <zelenja7@fel.cvut.cz>"
!

testRecognizer9
    |collector recognizer foundCollection|

    collector := self 
                doForSource:'
| helper|
    :
                    u := 3.
                    b:=u.
                    c:=  u  floor  aa   .
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
    recognizer := SmallSenseRecognizer new.
    foundCollection := recognizer 
                recognize:3
                position:4
                collector:collector.
    self assert:(foundCollection ~~ OrderedCollection).
    self assert:(foundCollection objectNameCollection size >= 48).

    "    self assert:(foundNode beforeNode).
        self assert:((foundNode line)=2).
        self assert:((foundNode position)=2).
        self assert:(foundNode statement isErrorNode).
        self assert:(foundNode statement errorToken =':=').
        self assert:(foundNode beforeStatement isNil)."

    "Created: / 07-03-2011 / 19:27:11 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 06-04-2011 / 19:07:13 / Jakub <zelenja7@fel.cvut.cz>"
! !

!RecognizerTests class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !

