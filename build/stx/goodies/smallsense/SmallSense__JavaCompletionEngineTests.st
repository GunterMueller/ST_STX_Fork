"{ Encoding: utf8 }"

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

AbstractJavaCompletionEngineTests subclass:#JavaCompletionEngineTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SmallSense-Tests'
!

!JavaCompletionEngineTests class methodsFor:'documentation'!

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

!JavaCompletionEngineTests methodsFor:'accessing-classes'!

completionEngineClass
    "superclass SmallSense::CompletionEngineTests says that I am responsible to implement this method"

    ^ JavaCompletionEngine

    "Created: / 07-08-2014 / 02:00:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

completionLanguage
    ^ JavaLanguage instance

    "Created: / 07-03-2015 / 10:35:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaCompletionEngineTests methodsFor:'tests'!

test_method_01

    <skip>

    self complete:'public class Foo {
        public int bar(Object o) {
            return o.has┃
        }
    }'.

    self assert: result notEmpty.
    self assert: (result contains:[:each | each isSmallSenseMethodBindingPO
                                                and:[ each binding selector = 'hashCode' ] ])

    "Created: / 13-08-2014 / 02:05:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-08-2014 / 22:45:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_types_01

    <skip>

    self complete:'public class Foo {
        public int addTo(Arra┃
        }
    }'.

    self assert: result notEmpty.
    self assert: (result contains:[:each | each isSmallSenseClassPO 
                                                and:[ each klass == JAVA java util ArrayList ] ])

    "Created: / 13-08-2014 / 00:35:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-08-2014 / 02:02:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_types_02

    <skip>

    self complete:'public class Foo {
        protected Arra┃
    }'.

    self assert: result notEmpty.
    self assert: (result contains:[:each | each isSmallSenseClassPO 
                                                and:[ each klass == JAVA java util ArrayList ] ])

    "Created: / 13-08-2014 / 00:40:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-08-2014 / 02:02:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_variables_01

    <skip>

    self complete:'public class Foo {
        public int field;
        public int sum(int number1, int number2) {
            return num┃
        }
    }'.

    self assert: result size == 3.
    self assert: (result contains:[:each | each isSmallSenseVariableBindingPO
                                                and:[ each binding name = 'number1' ] ]).
    self assert: (result contains:[:each | each isSmallSenseVariableBindingPO
                                                and:[ each binding name = 'number2' ] ]).
    self assert: (result contains:[:each | each isSmallSenseVariableBindingPO
                                                and:[ each binding name = 'field' ] ]).

    "Created: / 07-08-2014 / 02:00:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-08-2014 / 09:08:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

