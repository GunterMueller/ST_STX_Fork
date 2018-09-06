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

TestCase subclass:#SmalltalkParserTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SmallSense-Tests-Obsolete'
!

!SmalltalkParserTests class methodsFor:'documentation'!

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

!SmalltalkParserTests methodsFor:'parseTests'!

test1
    |collector|
    collector := self 
                doForSource:'  
                    |u w b c d tokenValue val uu bb cc dd |
                   u := 3.
                    b:=u.
                    c:=u floor.
                    d floor:u.
                    d floor:3 b:u.
                    self rememberSymbolUsed:tokenValue.
                    array:=#( 3 4 5 6 ).
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

    "Created: / 21-12-2010 / 23:07:13 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 22-02-2011 / 12:35:19 / Jakub <zelenja7@fel.cvut.cz>"
!

test10
    |collector|

    collector := self 
                doForSource:'  
                    | b|
                    u := 3.
                    b:=u.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    self assert:(collector tree nextStatement nextStatement) isNil.
    self assert:(collector tree expression) isAssignment.
    self assert:(collector tree expression variable) isVariable.
    self assert:(collector tree expression expression) isConstant.
    self assert:(collector tree nextStatement expression) isAssignment.
    self assert:(collector tree nextStatement expression variable) isVariable.
    self 
        assert:(collector tree nextStatement expression expression) isVariable.

    "Created: / 15-02-2011 / 15:23:50 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 18-02-2011 / 16:49:19 / Jakub <zelenja7@fel.cvut.cz>"
!

test11
    |collector|
    collector := self 
                doForSource:'  
                    | b|
                    u := 3
                    b:=u.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    self assert:(collector tree nextStatement nextStatement nextStatement) isNil.
    self assert:(collector tree expression) isAssignment.
    self assert:(collector tree expression variable) isVariable.
    self assert:(collector tree expression variable name= 'u').
    self assert:(collector tree expression expression) isUnaryMessage.
    self assert:(collector tree expression expression receiver) isConstant.
    self assert:(collector tree expression expression receiver value=3) .
    self assert:(collector tree expression expression selector asString)='b'.
    self assert:(collector tree expression expression args isNil ).
    self assert:(collector tree nextStatement expression) isErrorNode.
    self assert:(collector tree nextStatement expression errorToken)= ':='.
    self assert:(collector tree nextStatement nextStatement expression) isVariable.
    self assert:(collector tree nextStatement nextStatement expression name)='u'.

    "Created: / 15-02-2011 / 15:24:01 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 18-02-2011 / 16:58:56 / Jakub <zelenja7@fel.cvut.cz>"
!

test11a
    |collector|
    collector := self 
                doForSource:'  
                    | b|
                    u := 3
                    b:=u.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    self assert:(collector tree nextStatement nextStatement) isNil.
    self assert:(collector tree expression) isAssignment.
    self assert:(collector tree expression variable) isVariable.
    self assert:(collector tree expression variable name= 'u').

    self assert:(collector tree expression expression) isErrorNode.
    self assert:(collector tree expression expression children first receiver) isConstant.
    self assert:(collector tree expression expression children first receiver) value =3 .

    self assert:(collector tree nextStatement expression) isAssignment.
    self assert:(collector tree nextStatement expression) variable name = 'b'.
    self assert:(collector tree nextStatement expression) expression isVariable.
    self assert:(collector tree nextStatement expression) expression name = 'u'.

    "Created: / 16-09-2013 / 23:16:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test11b
    |collector|
    collector := self 
                doForSource:'  
                    | b|
                    u := 3 between: 1 and: 10
                    b:=u.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    self assert:(collector tree nextStatement nextStatement) isNil.
    self assert:(collector tree expression) isAssignment.
    self assert:(collector tree expression variable) isVariable.
    self assert:(collector tree expression variable name= 'u').

    self assert:(collector tree expression expression) isErrorNode.
    self assert:(collector tree expression expression children first receiver) isConstant.
    self assert:(collector tree expression expression children first receiver) value =3 .

    self assert:(collector tree nextStatement expression) isAssignment.
    self assert:(collector tree nextStatement expression) variable name = 'b'.
    self assert:(collector tree nextStatement expression) expression isVariable.
    self assert:(collector tree nextStatement expression) expression name = 'u'.

    "Created: / 16-09-2013 / 23:16:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test11c
    |collector|
    collector := self 
                doForSource:'  
                    | b|
                    u := 3 between: 1 and: 10 + 10
                    b:=u.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    self assert:(collector tree nextStatement nextStatement) isNil.
    self assert:(collector tree expression) isAssignment.
    self assert:(collector tree expression variable) isVariable.
    self assert:(collector tree expression variable name= 'u').

    self assert:(collector tree expression expression) isErrorNode.
    self assert:(collector tree expression expression children first receiver) isConstant.
    self assert:(collector tree expression expression children first receiver) value =3 .

    self assert:(collector tree nextStatement expression) isAssignment.
    self assert:(collector tree nextStatement expression) variable name = 'b'.
    self assert:(collector tree nextStatement expression) expression isVariable.
    self assert:(collector tree nextStatement expression) expression name = 'u'.

    "Created: / 16-09-2013 / 23:16:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test12
    |collector|
    collector := self 
                doForSource:'  
                    | b|
                     : 3
                    '.
self assert:collector notNil.
    self assert:collector tree notNil.
    self assert:(collector tree nextStatement  nextStatement) isNil.
    self assert:(collector tree expression) isErrorNode.
    self assert:(collector tree expression errorToken =':').
    self assert:(collector tree nextStatement expression) isConstant.
    self assert:(collector tree nextStatement expression value=3).

    "Created: / 15-02-2011 / 15:25:36 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 18-02-2011 / 17:08:54 / Jakub <zelenja7@fel.cvut.cz>"
!

test13
    |collector|

    collector := self 
                doForSource:'  
                    | b|
                    u := 3
                    :=u.
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    self 
        assert:(collector tree nextStatement nextStatement nextStatement) isNil.
    self assert:(collector tree expression) isAssignment.
    self assert:(collector tree expression variable) isVariable.
    self assert:(collector tree expression variable name = 'u').
    self assert:(collector tree expression expression) isConstant.
    self assert:(collector tree expression expression value =3).
    self assert:(collector tree nextStatement expression) isErrorNode.
    self assert:(collector tree nextStatement expression errorToken) = ':='.
    self 
        assert:(collector tree nextStatement nextStatement expression) isVariable.
    self 
        assert:(collector tree nextStatement nextStatement expression name) = 'u'.

    "Created: / 15-02-2011 / 16:48:11 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 17-03-2011 / 17:21:48 / Jakub <zelenja7@fel.cvut.cz>"
!

test14
    |collector|
    collector := self 
                doForSource:'  
                    | b|
                    u := 3
                    :u.
                    '.
 self assert:collector notNil.
    self assert:collector tree notNil.
    self 
        assert:(collector tree nextStatement nextStatement nextStatement) isNil.
    self assert:(collector tree expression) isAssignment.
    self assert:(collector tree expression variable) isVariable.
    self assert:(collector tree expression variable name = 'u').
    self assert:(collector tree expression expression) isConstant.
    self assert:(collector tree expression expression value =3).
    self assert:(collector tree nextStatement expression) isErrorNode.
    self assert:(collector tree nextStatement expression errorToken) = ':'.
    self 
        assert:(collector tree nextStatement nextStatement expression) isVariable.
    self 
        assert:(collector tree nextStatement nextStatement expression name) = 'u'.

    "Created: / 15-02-2011 / 17:03:42 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 18-02-2011 / 19:52:39 / Jakub <zelenja7@fel.cvut.cz>"
!

test15
    |collector|
    collector := self 
                doForSource:'  
                    | b|
                    u := 3
                    =u.
                    '.
 self assert:collector notNil.
    self assert:collector tree notNil.
    self 
        assert:(collector tree nextStatement ) isNil.
    self assert:(collector tree expression) isAssignment.
    self assert:(collector tree expression variable) isVariable.
    self assert:(collector tree expression variable name = 'u').
    self assert:(collector tree expression expression) isBinaryMessage.
    self assert:(collector tree expression expression receiver value =3).
    self assert:(collector tree expression expression receiver ) isConstant.
    self assert:(collector tree expression expression selector )= #=.
    self assert:(collector tree expression expression args size=1 ).
    self assert:(collector tree expression expression arg ) isVariable.    
    self assert:(collector tree expression expression arg name='u' ).

    "Created: / 15-02-2011 / 17:04:33 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 18-02-2011 / 19:56:28 / Jakub <zelenja7@fel.cvut.cz>"
!

test19
    |collector|
    collector := self 
                doForSource:'  
                    |b c|
                   u := 3 u:=
                    c u floor.
                    '.
self assert:collector notNil.
self assert:collector tree notNil.
self assert:collector tree expression isAssignment.
self assert:collector tree nextStatement expression isErrorNode.
self assert:collector tree nextStatement expression errorToken=':='.
self assert:collector tree nextStatement nextStatement expression isUnaryMessage.

    "Created: / 15-02-2011 / 18:15:51 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 18-02-2011 / 20:00:13 / Jakub <zelenja7@fel.cvut.cz>"
!

test2

    |collector|
    collector := self 
                doForSource:'
                    u :'.
self assert:collector notNil.
self assert:collector tree notNil.
self assert:(collector tree expression name ='u').
self assert:(collector tree expression) isVariable.
self assert:(collector tree nextStatement expression isErrorNode).
self assert: collector tree nextStatement expression errorToken=':'.

    "Created: / 09-02-2011 / 20:54:42 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 18-02-2011 / 15:04:33 / Jakub <zelenja7@fel.cvut.cz>"
!

test24
    |collector|
    collector := self 
                doForSource:'  
                    |u w|
                   self :                  '.
self assert:collector notNil.
self assert:collector tree notNil.
self assert:collector tree expression isSelf.
self assert:collector tree nextStatement expression isErrorNode.
self assert:collector tree nextStatement expression errorToken=':'.

    "Created: / 15-02-2011 / 18:37:23 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 18-02-2011 / 20:02:46 / Jakub <zelenja7@fel.cvut.cz>"
!

test25
    |collector|
"    collector := self 
                doForSource:'  
                    |u w|
                   self :=5                  '.
self assert:collector notNil.
self assert:collector tree notNil.
self assert:collector tree expression isSelf.
self assert:collector tree nextStatement expression isErrorNode.
self assert:collector tree nextStatement expression errorToken=':='.
self assert:collector tree nextStatement nextStatement expression isConstant."

    "Created: / 15-02-2011 / 18:37:56 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 28-02-2011 / 17:28:20 / Jakub <zelenja7@fel.cvut.cz>"
!

test26
    |collector|
    collector := self 
                doForSource:'  
                    |u w|
                   false :=5                  '.
self assert:collector notNil.
self assert:collector tree notNil.
self assert:collector tree expression isConstant.
self assert:collector tree nextStatement expression isErrorNode.
self assert:collector tree nextStatement expression errorToken=':='.
self assert:collector tree nextStatement nextStatement expression isConstant.

    "Created: / 15-02-2011 / 19:50:17 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 18-02-2011 / 20:05:19 / Jakub <zelenja7@fel.cvut.cz>"
!

test27
    |collector|
    collector := self 
                doForSource:'  
                    |u w|
                   nil :=5                  '.
self assert:collector notNil.
self assert:collector tree notNil.
self assert:collector tree expression isConstant.
self assert:collector tree nextStatement expression isErrorNode.
self assert:collector tree nextStatement expression errorToken=':='.
self assert:collector tree nextStatement nextStatement expression isConstant.

    "Created: / 15-02-2011 / 19:51:02 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 18-02-2011 / 20:05:32 / Jakub <zelenja7@fel.cvut.cz>"
!

test28
    |collector|
    collector := self 
                doForSource:'  
                    |d w tokenValue|
                   d floor:3 b:u
                    self rememberSymbolUsed:tokenValue.                '.
self assert:collector notNil.
self assert:collector tree notNil.

    "Created: / 15-02-2011 / 19:52:23 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 18-02-2011 / 20:06:33 / Jakub <zelenja7@fel.cvut.cz>"
!

test29
    |collector|
    collector := self 
                doForSource:'  
                    |d u w|
                   d floor:3 b:u
                    self                 '.
self assert:collector notNil.
self assert:collector tree notNil.

    "Created: / 15-02-2011 / 19:53:15 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 18-02-2011 / 20:06:46 / Jakub <zelenja7@fel.cvut.cz>"
!

test3
    |collector|

    collector := self doForSource:'
                    u ='.
    self assert:collector notNil.
    self assert:collector tree notNil.
    self assert:(collector tree expression) isBinaryMessage.
    self assert:(collector tree expression receiver name = 'u').
    self assert:(collector tree expression receiver) isVariable.
    self assert:(collector tree expression selector) == #=.
    self assert:(collector tree expression args size) = 1.
    self assert:(collector tree expression arg) isErrorNode.
    self assert:(collector tree expression arg errorToken = 'EOF').

    "Created: / 11-02-2011 / 15:32:58 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 18-02-2011 / 15:20:22 / Jakub <zelenja7@fel.cvut.cz>"
!

test30
    |collector|
    collector := self 
                doForSource:'  
                    |array |
                  self rememberSymbolUsed:tokenValue
                    array:=#( 3 4 5 6 ).           '.
self assert:collector notNil.
self assert:collector tree notNil.

    "Created: / 15-02-2011 / 19:54:10 / Jakub <zelenja7@fel.cvut.cz>"
!

test31
    |collector|
    collector := self 
                doForSource:'  
                    |array tokenValue|
                  self rememberSymbolUsed:tokenValue
                    array:=( 3 4 5 6 ).           '.
self assert:collector notNil.
self assert:collector tree notNil.
self assert:collector tree expression isMessage.
self assert:collector tree nextStatement expression isErrorNode.
self assert:collector tree nextStatement expression errorToken=':='.
self assert:collector tree nextStatement nextStatement  expression isUnaryMessage.

    "Created: / 16-02-2011 / 15:51:47 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 18-02-2011 / 20:15:19 / Jakub <zelenja7@fel.cvut.cz>"
!

test32
    |collector|
    collector := self 
                doForSource:'  
                    |uu w|
                    [u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.

                    ].

                    '.
self assert:collector notNil.
self assert:collector tree notNil.

    "Created: / 16-02-2011 / 15:54:07 / Jakub <zelenja7@fel.cvut.cz>"
!

test33
    |collector|

    collector := self 
                doForSource:'  
                    |uu w|
                    u== #Symbol or:[u=3]]ifTrue:[
                    uu := 4.

                    ].

                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    self assert:collector tree expression isMessage.
    self assert:collector tree expression receiver isBinaryMessage.
    self assert:collector tree expression receiver receiver isVariable.
    self assert:collector tree expression receiver receiver name = 'u'.
    self assert:collector tree expression receiver selector = #'=='.
    self assert:collector tree expression receiver args size = 1.
    self assert:collector tree expression receiver arg isConstant.
    self assert:collector tree expression receiver arg value = #Symbol.
    self assert:collector tree expression selector = #or:.
    self assert:collector tree expression args size = 1.
    self assert:collector tree expression arg1 isBlock.
    self assert:collector tree expression arg1 statements expression 
                isBinaryMessage.
    self assert:collector tree nextStatement expression isErrorNode.
    self assert:collector tree nextStatement expression errorToken = ']'.
    self 
        assert:collector tree nextStatement nextStatement expression isMessage.
    self 
        assert:collector tree nextStatement nextStatement expression receiver 
                isErrorNode.
    self 
        assert:collector tree nextStatement nextStatement expression receiver 
                errorToken = 'Keyword'.
    self 
        assert:collector tree nextStatement nextStatement expression selector 
                = #ifTrue:.
    self 
        assert:collector tree nextStatement nextStatement expression args size = 1.
    self 
        assert:collector tree nextStatement nextStatement expression arg1 
                statements expression 
                isAssignment.

    "Created: / 16-02-2011 / 15:55:49 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 18-02-2011 / 20:52:03 / Jakub <zelenja7@fel.cvut.cz>"
!

test34
    |collector|
    collector := self 
                doForSource:'  
                    |array |
                  self rememberSymbolUsed:tokenValue
                    array:=#( 3 4 5 6 .           '.
self assert:collector notNil.
self assert:collector tree notNil.
self assert:collector tree expression isMessage.
self assert:collector tree nextStatement expression isErrorNode.
self assert:collector tree nextStatement expression errorToken=':='.
self assert:collector tree nextStatement nextStatement  expression isConstant.

    "Created: / 16-02-2011 / 16:09:35 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 18-02-2011 / 20:16:54 / Jakub <zelenja7@fel.cvut.cz>"
!

test35
    |collector|
    collector := self 
                doForSource:'  
                    |uu w|
                    [u== #Symbol or:u=3]]ifTrue:[
                    uu := 4.

                    ].

                    '.
 self assert:collector notNil.
    self assert:collector tree notNil.
    self assert:collector tree expression isBlock.
    self assert:collector tree expression statements expression isMessage.
    self assert:collector tree expression statements expression receiver isBinaryMessage.
    self assert:collector tree expression statements expression receiver receiver isVariable.
    self assert:collector tree expression statements expression receiver receiver name = 'u'.
    self assert:collector tree expression statements expression receiver selector = #'=='.
    self assert:collector tree expression statements expression receiver args size = 1.
    self assert:collector tree expression statements expression receiver arg isConstant.
    self assert:collector tree expression statements expression receiver arg value = #Symbol.
    self assert:collector tree expression statements expression selector = #or:.
    self assert:collector tree expression statements expression args size = 1.
    self assert:collector tree expression statements expression arg1 isBinaryMessage.
    self assert:collector tree nextStatement expression isErrorNode.
    self assert:collector tree nextStatement expression errorToken = ']'.
    self 
        assert:collector tree nextStatement nextStatement expression isMessage.
    self 
        assert:collector tree nextStatement nextStatement expression receiver 
                isErrorNode.
    self 
        assert:collector tree nextStatement nextStatement expression receiver 
                errorToken = 'Keyword'.
    self 
        assert:collector tree nextStatement nextStatement expression selector 
                = #ifTrue:.
    self 
        assert:collector tree nextStatement nextStatement expression args size = 1.
    self 
        assert:collector tree nextStatement nextStatement expression arg1 
                statements expression 
                isAssignment.

    "Created: / 16-02-2011 / 16:47:18 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 18-02-2011 / 20:56:11 / Jakub <zelenja7@fel.cvut.cz>"
!

test36
    |collector|
    collector := self 
                doForSource:'  
                    |uu w|
                    [u== #Symbol ifTrue:[
                    uu := 4.

                    ].

                    '.
   self assert:collector notNil.
    self assert:collector tree notNil.
    self assert:collector tree expression isBlock.
    self assert:collector tree expression statements expression isMessage.
    self assert:collector tree expression statements expression receiver isBinaryMessage.
    self assert:collector tree expression statements expression receiver receiver isVariable.
    self assert:collector tree expression statements expression receiver receiver name = 'u'.
    self assert:collector tree expression statements expression receiver selector = #'=='.
    self assert:collector tree expression statements expression receiver args size = 1.
    self assert:collector tree expression statements expression receiver arg isConstant.
    self assert:collector tree expression statements expression receiver arg value = #Symbol.
    self assert:collector tree expression statements expression selector = #ifTrue: .
    self assert:collector tree expression statements expression args size = 1.
    self assert:collector tree expression statements expression arg1 isBlock.
    self assert:collector tree expression statements expression arg1 statements expression 
                isAssignment.

    "Created: / 16-02-2011 / 16:48:07 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 18-02-2011 / 21:13:22 / Jakub <zelenja7@fel.cvut.cz>"
!

test37
    |collector|

    collector := self 
                doForSource:'  
                    |uu w|
                    [u== #Symbol) ifTrue:[
                    uu := 4.

                    ].

                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    self assert:collector tree expression isBlock.
    self 
        assert:collector tree expression statements expression isBinaryMessage.
    self 
        assert:collector tree expression statements expression receiver name = 'u'.
    self 
        assert:collector tree expression statements expression selector = #'=='.
    self assert:collector tree expression statements expression args size = 1.
    self 
        assert:collector tree expression statements expression arg1 value = #Symbol.
    self 
        assert:collector tree expression statements nextStatement expression 
                isErrorNode.
    self 
        assert:collector tree expression statements nextStatement expression 
                errorToken = ')'.
    self 
        assert:collector tree expression statements nextStatement nextStatement 
                expression isMessage.
    self 
        assert:collector tree expression statements nextStatement nextStatement expression 
                receiver isErrorNode.
    self 
        assert:collector tree expression statements nextStatement nextStatement expression 
                receiver errorToken 
                = 'Keyword'.
    self 
        assert:collector tree expression statements nextStatement nextStatement expression 
                selector = #ifTrue:.
    self 
        assert:collector tree expression statements nextStatement nextStatement expression args 
                size = 1.
    self 
        assert:collector tree expression statements nextStatement nextStatement expression arg1 
                isBlock.
    self 
        assert:collector tree expression statements nextStatement nextStatement expression arg1 
                statements expression 
                isAssignment.

    "Created: / 16-02-2011 / 17:21:06 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 18-02-2011 / 21:25:27 / Jakub <zelenja7@fel.cvut.cz>"
!

test38
    |collector|
    collector := self 
                doForSource:'  
                    |uu w|
                    [:=

                    ].

                    '.
self assert:collector notNil.
self assert:collector tree notNil.
self assert:collector tree expression isBlock.
self assert:collector tree expression statements expression  isErrorNode.
self assert:collector tree expression statements expression errorToken=':='.

    "Created: / 18-02-2011 / 11:55:35 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 18-02-2011 / 21:40:40 / Jakub <zelenja7@fel.cvut.cz>"
!

test39
    |collector|                
    collector := self 
                doForSource:'  
                    |uu w|
                    :=3

                    '.
self assert:collector notNil.
self assert:collector tree notNil.
self assert:collector tree expression isErrorNode.
self assert:collector tree expression errorToken=':='.
self assert:collector tree  nextStatement expression isConstant.
self assert:collector tree  nextStatement expression value=3.

    "Created: / 18-02-2011 / 17:11:24 / Jakub <zelenja7@fel.cvut.cz>"
!

test4
    |collector|

    collector := self doForSource:'
                    u 3'.
    self assert:collector notNil.
    self assert:collector tree notNil.
    self assert:(collector tree expression) isUnaryMessage.
    self assert:(collector tree expression receiver name = 'u').
    self assert:(collector tree expression receiver) isVariable.
    self assert:(collector tree expression selector asString) = '3'.

    "Created: / 15-02-2011 / 14:13:48 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 18-03-2011 / 22:10:14 / Jakub <zelenja7@fel.cvut.cz>"
!

test40
    |collector|
    collector := self 
                doForSource:'  
                    |array tokenValue|
                  self rememberSymbolUsed:tokenValue
                    array:=( 3 4 5 6.           '.
self assert:collector notNil.
self assert:collector tree notNil.
self assert:collector tree expression isMessage.
self assert:collector tree nextStatement expression isErrorNode.
self assert:collector tree nextStatement expression errorToken=':='.
self assert:collector tree nextStatement nextStatement  expression isUnaryMessage.

    "Created: / 18-02-2011 / 20:17:31 / Jakub <zelenja7@fel.cvut.cz>"
!

test41
    |collector|
    collector := self 
                doForSource:'  
                    |array tokenValue|
                  self rememberSymbolUsed:tokenValue
                    array:=( 3 4 5 6 :=u           '.
self assert:collector notNil.
self assert:collector tree notNil.
self assert:collector tree expression isMessage.
self assert:collector tree nextStatement expression isErrorNode.
self assert:collector tree nextStatement expression errorToken=':='.
self assert:collector tree nextStatement nextStatement  expression isUnaryMessage.
self assert:collector tree nextStatement nextStatement nextStatement  expression isErrorNode.
self assert:collector tree nextStatement nextStatement nextStatement  expression errorToken=':='.
self assert:collector tree nextStatement nextStatement nextStatement nextStatement  expression isVariable.

    "Created: / 18-02-2011 / 20:35:35 / Jakub <zelenja7@fel.cvut.cz>"
!

test42
    |collector|
    collector := self 
                doForSource:'  
                    |array tokenValue|
                  self rememberSymbolUsed:tokenValue
                    array:= 3 4 5 6 :=u)           '.
self assert:collector notNil.
self assert:collector tree notNil.
self assert:collector tree expression isMessage.
self assert:collector tree nextStatement expression isErrorNode.
self assert:collector tree nextStatement expression errorToken=':='.
self assert:collector tree nextStatement nextStatement  expression isUnaryMessage.
self assert:collector tree nextStatement nextStatement nextStatement  expression isErrorNode.
self assert:collector tree nextStatement nextStatement nextStatement  expression errorToken=':='.
self assert:collector tree nextStatement nextStatement nextStatement nextStatement  expression isVariable.
self assert:collector tree nextStatement nextStatement nextStatement nextStatement nextStatement expression isErrorNode.
self assert:collector tree nextStatement nextStatement nextStatement nextStatement nextStatement expression errorToken=')'.

    "Created: / 18-02-2011 / 20:37:17 / Jakub <zelenja7@fel.cvut.cz>"
!

test43
    |collector|
    collector := self 
                doForSource:'  
                    |uu w b|
                    [u== #Symbol ifTrue:[
                    uu := 4.

                    ].
                      b:=3
                    '.
   self assert:collector notNil.
    self assert:collector tree notNil.
    self assert:collector tree expression isBlock.
    self assert:collector tree expression statements expression isMessage.
    self assert:collector tree expression statements expression receiver isBinaryMessage.
    self assert:collector tree expression statements expression receiver receiver isVariable.
    self assert:collector tree expression statements expression receiver receiver name = 'u'.
    self assert:collector tree expression statements expression receiver selector = #'=='.
    self assert:collector tree expression statements expression receiver args size = 1.
    self assert:collector tree expression statements expression receiver arg isConstant.
    self assert:collector tree expression statements expression receiver arg value = #Symbol.
    self assert:collector tree expression statements expression selector = #ifTrue: .
    self assert:collector tree expression statements expression args size = 1.
    self assert:collector tree expression statements expression arg1 isBlock.
    self assert:collector tree expression statements expression arg1 statements expression 
                isAssignment.

    "Created: / 18-02-2011 / 21:16:10 / Jakub <zelenja7@fel.cvut.cz>"
!

test44
    |collector|
    collector := self 
                doForSource:'  
                    |b c|
                   u :=b b: u:c
                    '.
self assert:collector notNil.
self assert:collector tree notNil.
self assert:collector tree expression isAssignment.

    "Created: / 20-02-2011 / 18:54:11 / Jakub <zelenja7@fel.cvut.cz>"
!

test45
    |collector|
    collector := self 
                doForSource:'
                    | a b |
                    a := [self pr   
                    b := self navigationState isFullClassSourceBrowser
                                                    or:[self isJavaMethod and:[JavaMethod showFullSource]].     
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    self assert:collector tree expression isAssignment.
    self assert:collector tree expression expression isBlock.
    self assert:collector tree expression expression statements isStatement.
    self assert:collector tree expression expression statements expression isErrorNode.
    self assert:collector tree expression expression statements expression children first isMessage.
    self assert:collector tree expression expression statements expression children first selector = 'pr'.

    "Created: / 19-09-2013 / 11:19:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test46
    |collector|
    collector := self 
                doForSource:'
                    | a b |
                    a := a and:[self pr   
                    b := self navigationState isFullClassSourceBrowser
                                                    or:[self isJavaMethod and:[JavaMethod showFullSource]].     
                    '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    self assert:collector tree expression isAssignment.
    self assert:collector tree expression expression isMessage.
    self assert:collector tree expression expression args last isBlock.
    self assert:collector tree expression expression args last statements expression isErrorNode.
    self assert:collector tree expression expression args last statements expression children first isMessage.
    self assert:collector tree expression expression args last statements expression children first selector = 'pr'.

    "Created: / 19-09-2013 / 11:48:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test47
    |collector|
    collector := self 
                doForSource:'
                    |mthd doScrollToTop code codeView doAutoFormat doSyntaxColoring doUpdateCode prevMthd doShowFullClassSource |

                    doAutoFormat := self doAutoFormat value and:[RBFormatter notNil and:[mthd prog
                    doShowFullClassSource := self navigationState isFullClassSourceBrowser
                                                or:[mthd isJavaMethod and:[JavaMethod showFullSource]].
                    doUpdateCode := true.
                    codeView := self codeView.
                    self assert:codeView notNil.

                    code := self sourceOfMethod:mthd.
                    code isText ifTrue:[
                        "/Already done...
                        doSyntaxColoring := false.
                    ] ifFalse:[
                        "/Do no coloring here if CodeView2 is used,
                        "/since CodeView2 itself cares about the coloring!!
                        "/Not working correctly -> do the coloring until fixed in CodeView2
                        "/JV: Then make a bug report because otherwise it won''t be
                        "/    ever fixed.
                        "(UserPreferences current useCodeView2In: #Browser)"false ifTrue:[
                            doSyntaxColoring := code size < 2000
                        ] ifFalse:[
                            doSyntaxColoring := self doSyntaxColoring value == true.
                        ].
                    ].


                    doAutoFormat ifTrue:[
                        Error catch:[
                            code := RBFormatter format:code
                        ].
                    ].

                    doShowFullClassSource ifTrue:[
                        "As whole class source coce is shown,
                         there is no need to set codeview''s content if previous method
                         belonged to the same class. Code is already shown, we need only
                         to scrool to it..."
                        "hmm...hmm...how implement it in a better, more generic way?"        
                        mthd isSynthetic not ifTrue:[
                            prevMthd := navigationState lastMethodShownInCodeView.
                            prevMthd notNil ifTrue:[
                                doUpdateCode := prevMthd isSynthetic or:[mthd mclass ~~ prevMthd mclass]
                            ].


                        ].
                    ].
                    doUpdateCode ifTrue:[
                        doSyntaxColoring ifTrue:[
                            "/ immediate coloring, if code is not too large;
                            "/ otherwise, do it in the background.
                            code size < 2000 " 10000 " ifTrue:[
                                Error handle:[:ex |
                                    Transcript showCR:''error in syntaxHighlighter: '',ex description.
                                ] do:[
                                    code := self syntaxHighlightedCodeFor:code method:mthd.
                                ].
                            ] ifFalse:[
                                self enqueueDelayedStartSyntaxHighlightProcess.
                            ].

                            [
                                codeView modifiedChannel removeDependent:self.
                                codeView modified:false.
                                self showCode:code scrollToTop:doScrollToTop.
                            ] ensure:[
                                codeView modifiedChannel addDependent:self.
                            ]
                        ] ifFalse:[
                            self showCode:code scrollToTop:doScrollToTop.
                        ].
                    ].
                    navigationState lastMethodShownInCodeView: mthd.

                    "/ scroll, for file-based classes (java, ruby, etc.)
                    doShowFullClassSource ifTrue:[
                        mthd sourceLineNumber ~~ 1 ifTrue:[
                            doScrollToTop ifTrue:[ "/ifFalse:[
                                codeView scrollToLine:mthd sourceLineNumber
                            ]
                        ].
                    ].
                    self codeAspect:(code ifNil:[nil] ifNotNil:[SyntaxHighlighter codeAspectMethod]).
                    self normalLabel.
                    self updatePackageInfoForMethod:mthd.'.

    self assert: collector tree notNil.

    "Created: / 19-09-2013 / 11:54:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 20-09-2013 / 00:58:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test5
    |collector|

    collector := self doForSource:'
                    u +'.
    self assert:collector notNil.
    self assert:collector tree notNil.
    self assert:(collector tree expression) isBinaryMessage.
    self assert:(collector tree expression receiver name = 'u').
    self assert:(collector tree expression receiver) isVariable.
    self assert:(collector tree expression selector) isSymbol.
    self assert:(collector tree expression selector asString) = '+'.
    self assert:(collector tree expression args size) = 1.
    self assert:(collector tree expression arg) isErrorNode.
    self assert:(collector tree expression arg errorToken = 'EOF').

    "Created: / 15-02-2011 / 15:18:25 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 18-02-2011 / 15:31:37 / Jakub <zelenja7@fel.cvut.cz>"
!

test6
    |collector|

    collector := self doForSource:'
                    u +.'.
    self assert:collector notNil.
    self assert:collector tree notNil.
    self assert:(collector tree expression) isBinaryMessage.
    self assert:(collector tree expression receiver name = 'u').
    self assert:(collector tree expression receiver) isVariable.
    self assert:(collector tree expression selector) isSymbol.
    self assert:(collector tree expression selector asString) = '+'.
    self assert:(collector tree expression args size) = 1.
    self assert:(collector tree expression arg) isErrorNode.
    self assert:(collector tree expression arg errorToken = '.').

    "Created: / 15-02-2011 / 15:19:08 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 18-02-2011 / 15:32:56 / Jakub <zelenja7@fel.cvut.cz>"
!

test7
    |collector|

    collector := self doForSource:'
                    u 3.'.
    self assert:collector notNil.
    self assert:collector tree notNil.
    self assert:(collector tree expression) isUnaryMessage.
    self assert:(collector tree expression receiver name = 'u').
    self assert:(collector tree expression receiver) isVariable.
    self assert:(collector tree expression selector asString) = '3'.

    "Created: / 15-02-2011 / 15:19:22 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 18-03-2011 / 22:10:21 / Jakub <zelenja7@fel.cvut.cz>"
!

test8
    |collector|

    collector := self doForSource:'
                    u =.'.
    self assert:collector notNil.
    self assert:collector tree notNil.
    self assert:(collector tree expression) isBinaryMessage.
    self assert:(collector tree expression receiver name = 'u').
    self assert:(collector tree expression receiver) isVariable.
    self assert:(collector tree expression selector) == #'='.
    self assert:(collector tree expression args size) = 1.
    self assert:(collector tree expression arg) isErrorNode.
    self assert:(collector tree expression arg errorToken = '.').

    "Created: / 15-02-2011 / 15:19:38 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 18-02-2011 / 15:34:13 / Jakub <zelenja7@fel.cvut.cz>"
!

test9
    |collector|

    collector := self doForSource:'
                    u :.'.
    self assert:collector notNil.
    self assert:collector tree notNil.
    self assert:(collector tree expression name = 'u').
    self assert:(collector tree expression) isVariable.
    self assert:(collector tree nextStatement expression isErrorNode).
    self assert:collector tree nextStatement expression errorToken = ':'.
    self assert:collector tree nextStatement nextStatement isNil.

    "Created: / 15-02-2011 / 15:19:52 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 18-02-2011 / 15:35:42 / Jakub <zelenja7@fel.cvut.cz>"
!

testBadAssignment
    |collector|

    collector := self doForSource:'
                    u := '.
    self assert:collector notNil.
    self assert:collector tree notNil.
    self assert:(collector tree expression) isAssignment.
    self assert:(collector tree expression variable name = 'u').
    self assert:(collector tree expression variable) isVariable.
    self assert:(collector tree expression expression) isErrorNode.
    self assert:(collector tree expression expression errorToken = 'EOF').

    "Modified: / 18-02-2011 / 15:39:33 / Jakub <zelenja7@fel.cvut.cz>"
! !

!SmalltalkParserTests class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id$'
! !

