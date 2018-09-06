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

CompletionEngineTests subclass:#SmalltalkCompletionEngineTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SmallSense-Tests'
!

!SmalltalkCompletionEngineTests class methodsFor:'documentation'!

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

!SmalltalkCompletionEngineTests methodsFor:'accessing-classes'!

completionEngineClass
    "superclass SmallSense::CompletionEngineTests says that I am responsible to implement this method"

    ^ SmalltalkCompletionEngine

    "Created: / 24-07-2014 / 11:51:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

completionLanguage
    ^ SmalltalkLanguage instance

    "Created: / 07-03-2015 / 10:35:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SmalltalkCompletionEngineTests methodsFor:'tests - classes'!

test_classes_01a

    codeView classHolder value: self class.
    codeView codeAspect: #method. 
    self complete:'foo
    ^ SmalltalkCompletionEngineTe┃'.

    self assert: result notEmpty.
    self assert: (result select:[:each | each isSmallSenseClassPO and:[each klass == SmalltalkCompletionEngineTests]]) size == 1.

    "Created: / 24-07-2014 / 15:12:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-02-2015 / 00:08:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_classes_01b

    codeView classHolder value: self class.
    codeView codeAspect: #method. 
    self complete:'foo
    ^ OrderedColl┃'.

    self assert: result notEmpty.
    self assert: (result select:[:each | each isSmallSenseClassPO and:[each klass == OrderedCollection]]) size == 1.

    "Created: / 24-07-2014 / 15:12:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-02-2015 / 00:10:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_classes_01c

    codeView classHolder value: self class.
    codeView codeAspect: #method. 
    self complete:'foo
    ^ OperatingSyst┃'.

    self assert: result notEmpty.
    self assert: (result select:[:each | each isSmallSenseVariablePO and:[each name = 'OperatingSystem' ]]) size == 1.

    "Created: / 24-07-2014 / 15:14:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-02-2015 / 00:10:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_classes_02a

    codeView classHolder value: self class.
    codeView codeAspect: #method. 
    self complete:'foo
    ^ Phase┃'.

    self assert: result notEmpty.
    self assert: (result select:[:each | each isSmallSenseClassPO and:[each klass = SmalltalkInferencer::Phase1 ]]) size == 1.

    "Created: / 24-07-2014 / 17:50:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-02-2015 / 00:10:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_classes_02b

    codeView classHolder value: self class.
    codeView codeAspect: #method. 
    self complete:'foo
    ^ SmalltalkInfe┃'.

    self assert: result notEmpty.
    self assert: (result select:[:each | each isSmallSenseClassPO and:[each klass = SmalltalkInferencer::Phase1 ]]) size == 1.

    "Created: / 24-07-2014 / 17:50:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-02-2015 / 00:10:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_classes_03

    codeView classHolder value: self class.
    codeView codeAspect: #method. 
    self complete:'foo
    ^ ClassL┃'.

    self assert: result notEmpty.
    self assert: (result select:[:each | each isSmallSenseClassPO and:[each klass = Tools::ClassList ]]) size == 1.

    "Created: / 24-07-2014 / 17:53:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-02-2015 / 00:10:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_classes_04

    codeView classHolder value: SmalltalkInferencer.
    codeView codeAspect: #method. 
    self complete:'foo
    ^ Pha┃'.

    self assert: result notEmpty.
    self assert: (result select:[:each | each isSmallSenseClassPO and:[each klass = SmalltalkInferencer::Phase1 ]]) size == 1.
    self assert: (result select:[:each | each isSmallSenseClassPO and:[each klass = SmalltalkInferencer::Phase2 ]]) size == 1.

    "Created: / 24-07-2014 / 19:10:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-02-2015 / 00:11:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_classes_05

    codeView classHolder value: SmalltalkInferencer.
    codeView codeAspect: #method. 
    self complete:'foo
    ^ Scree┃'.

    self assert: result notEmpty.
    self assert: (result select:[:each | each isSmallSenseVariablePO and:[each name = 'Screen' ]]) size == 1.

    "Created: / 24-07-2014 / 19:54:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-02-2015 / 00:11:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SmalltalkCompletionEngineTests methodsFor:'tests - methods'!

test_methods_01a    
    | po_between_and |

    codeView classHolder value: self class.
    codeView codeAspect: #method. 
    self complete:'foo
    ^ 1 betwee┃'.

    po_between_and := result detect:[:each | each isSmallSenseMethodPO and:[each selector == #between:and:]] ifNone:[ nil ].

    self assert: po_between_and notNil.

    po_between_and insert.

    self assert: (codeView list at: 2) = '    ^ 1 between:  and:  '

    "Created: / 07-03-2015 / 10:30:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_methods_02a    
    | po |

    codeView classHolder value: self class.
    codeView codeAspect: #method. 
    self complete:'foo
    ^ self test_methods_02┃'.

    po := result detect:[:each | each isSmallSenseMethodPO and:[each selector == #test_methods_02a]] ifNone:[ nil ].

    self assert: po notNil.

    "Created: / 21-08-2015 / 16:18:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

