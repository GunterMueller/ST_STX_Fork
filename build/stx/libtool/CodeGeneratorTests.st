"
 Copyright (c) 2007-2010 Jan Vrany, SWING Research Group, Czech Technical University in Prague
 Copyright (c) 2009-2010 eXept Software AG

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the 'Software'), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
"
"{ Package: 'stx:libtool' }"

"{ NameSpace: Smalltalk }"

TestCase subclass:#CodeGeneratorTests
	instanceVariableNames:'cg'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Browsers'
!

!CodeGeneratorTests class methodsFor:'documentation'!

copyright
"
 Copyright (c) 2007-2010 Jan Vrany, SWING Research Group, Czech Technical University in Prague
 Copyright (c) 2009-2010 eXept Software AG

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the 'Software'), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
"
! !

!CodeGeneratorTests methodsFor:'initialization & release'!

setUp

    cg := CodeGenerator new

    "Created: / 07-07-2009 / 09:26:20 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

tearDown

    | mocks |
    mocks := Set new.
    self class selectorsDo:
        [:selector| 
        (selector startsWith: 'mock')
            ifTrue:[mocks add: selector]].
    mocks do:
        [:selector|
        self class removeSelector: selector].

    "Modified: / 07-07-2009 / 09:34:22 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!CodeGeneratorTests methodsFor:'mocks - do not remove'!

mmock_03

    ^3

    "Created: / 07-07-2009 / 19:21:52 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

mmock_03: x

    ^x

    "Created: / 07-07-2009 / 19:55:10 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!CodeGeneratorTests methodsFor:'tests'!

test_01

    cg
        class: self class;
        replace: '`@e' with: '1';
        source: 'mock_01 ^ `@e';
        compile.

    self assert: (self respondsTo: #mock_01).
    self assert: (self mock_01 = 1).

    "Created: / 07-07-2009 / 09:29:56 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

test_02

    cg
        class: self class;
        replace: '`@selector' with: #mock_02;
        source: '`@selector ^ 2';
        compile.

    self assert: (self respondsTo: #mock_02).
    self assert: (self mock_02 = 2).

    "Created: / 07-07-2009 / 19:07:13 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

test_02b

    cg
        class: self class;
        replace: '`@selector:' with: #mock_02:;
        source: '`@selector: arg ^ arg';
        compile.

    self assert: (self respondsTo: #mock_02:).
    self assert: (self mock_02: 20) = 20.

    "Created: / 07-07-2009 / 19:54:03 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

test_03

    cg
        class: self class;
        replace: '`@selector' with: 'mmock_03';
        source: 'mock_03 ^ self `@selector';
        compile.

    self assert: (self respondsTo: #mock_03).
    self assert: (self mock_03 = 3).

    "Created: / 07-07-2009 / 19:22:37 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

test_03b

    cg
        class: self class;
        replace: '`@selector:' with: #mmock_03:;
        source: 'mock_03b ^ self `@selector: 30';
        compile.

    self assert: (self respondsTo: #mock_03b).
    self assert: (self mock_03b = 30).

    "Created: / 07-07-2009 / 19:54:35 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

test_04a

    cg
        class: self class;
        source: '`@selector ^ 4';
        replace: '`@selector' with: #mock_04a;
        compile.

    self assert: (self respondsTo: #mock_04a).
    self assert: (self mock_04a = 4).

    "Created: / 24-04-2014 / 11:13:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_04b

    cg
        class: self class;
        source: '`@selpart1 anArg `@selpart2 anArg2 ^ anArg + anArg2';
        replace: '`@selpart1' with: #mock_04:;
        replace: '`@selpart2' with: #b:;
        compile.

    self assert: (self respondsTo: #mock_04:b:).
    self assert: ((self mock_04:123 b: 123) = (123+123)).

    "Created: / 24-04-2014 / 11:15:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_05

    cg
        class: self class;
        source: 'mock_05
                "comment"

                ^ 10';
        compile.

    self assert: (self respondsTo: #mock_05).
    self assert: (self perform: #mock_05) == 10.
    self assert: ((self class >> #mock_05) source includesString: 'comment')

    "Created: / 24-04-2014 / 11:28:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 24-05-2014 / 01:02:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CodeGeneratorTests class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libtool/CodeGeneratorTests.st,v 1.5 2014-05-24 00:10:50 vrany Exp $'
!

version_SVN
    ^ '$Id: CodeGeneratorTests.st,v 1.5 2014-05-24 00:10:50 vrany Exp $'
! !

