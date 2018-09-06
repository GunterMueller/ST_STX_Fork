"
 Copyright (c) 2010-2011 Jan Vrany, Jan Kurs & Marcel Hlopko,
                         SWING Research Group, Czech Technical University
                         in Prague

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
"{ Package: 'stx:libjava' }"

"{ NameSpace: Smalltalk }"

TestCase subclass:#JavaLookupTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Tests-Interop'
!

!JavaLookupTests class methodsFor:'documentation'!

copyright
"
 Copyright (c) 2010-2011 Jan Vrany, Jan Kurs & Marcel Hlopko,
                         SWING Research Group, Czech Technical University
                         in Prague

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
!

documentation
"
    This testcase tests the java-smalltalk interop lookup
    (JavaLookup)

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!JavaLookupTests class methodsFor:'resources'!

resources
    ^ Array with: JavaTestsResource.

    "Created: / 11-04-2011 / 19:38:11 / kursjan <kursjan@fit.cvut.cz>"
    "Modified: / 29-08-2011 / 23:35:06 / Jan Kurs <kursjan@fit.cvut.cz>"
    "Modified: / 19-03-2014 / 11:27:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaLookupTests methodsFor:'running'!

setUp
    | md |

    Smalltalk loadPackage: 'stx:libjava/tests'.
    self javaTestClasses do:[:each | 
        md := each methodDictionary.
        md copy keysAndValuesDo:[:sel :m|
            m isProxyMethod ifTrue:[md removeKey: sel]
        ].
    ].
    self personManipulatorClass theClass constantPool invalidate.

    "Created: / 03-12-2012 / 17:50:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-12-2012 / 13:35:52 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified: / 19-03-2014 / 13:47:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaLookupTests methodsFor:'support'!

javaTestClass
    ^ JAVA stx libjava tests mocks interop Object.

    "Created: / 05-09-2011 / 20:13:48 / Jan Kurs <kursjan@fit.cvut.cz>"
    "Modified: / 30-11-2012 / 22:16:24 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 19-03-2014 / 11:28:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

javaTestClasses
    "raise an error: this method should be implemented (TODO)"

    ^ OrderedCollection streamContents:[:s|
        s
            nextPut: self javaTestClass;
            nextPut: JAVA stx libjava tests mocks interop Person theClass.
    ]

    "Created: / 19-03-2014 / 13:45:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

personManipulatorClass
    "Person Manipulator can interact with Person class defined in Java"

    ^ JAVA stx libjava tests mocks interop PersonManipulator.

    "Created: / 06-09-2011 / 21:48:16 / Jan Kurs <kursjan@fit.cvut.cz>"
    "Modified: / 30-11-2012 / 22:16:19 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 19-03-2014 / 11:28:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setManipulatorClass
    "Person Manipulator can interact with Person class defined in Java"

    ^ JAVA stx libjava tests mocks interop SetManipulator.

    "Created: / 25-09-2011 / 16:41:02 / Jan Kurs <kursjan@fit.cvut.cz>"
    "Modified: / 30-11-2012 / 22:13:34 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 19-03-2014 / 11:28:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaLookupTests methodsFor:'tests - java extensions'!

test_java_extension_01

    Compiler compile: 'fooPerson ^ 0' forClass: JAVA stx libjava tests mocks interop Person theClass.
    self assert: JAVA stx libjava tests mocks interop Person new fooPerson == 0.

    "Created: / 04-10-2013 / 15:07:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 19-03-2014 / 11:28:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_java_extension_02_1

    Compiler compile: 'fooIPerson1 ^ 1' forClass: JAVA stx libjava tests mocks interop IPerson1 theClass.
    self assert: JAVA stx libjava tests mocks interop Person new fooIPerson1 == 1.

    "Created: / 04-10-2013 / 15:13:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 19-03-2014 / 11:28:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_java_extension_02_2

    Compiler compile: 'fooIPerson2 ^ 2' forClass: JAVA stx libjava tests mocks interop IPerson2 theClass.
    self assert: JAVA stx libjava tests mocks interop Person new fooIPerson2 == 2

    "Created: / 04-10-2013 / 15:12:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 19-03-2014 / 11:28:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_java_extension_03

    Compiler compile: 'fooIPersonSuper ^ 3' forClass: JAVA stx libjava tests mocks interop IPersonSuper theClass.
    self assert: JAVA stx libjava tests mocks interop Person new fooIPersonSuper == 3

    "Created: / 04-10-2013 / 15:11:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 19-03-2014 / 11:29:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_java_extension_04

    Compiler compile: 'fooIPerson ^ 3' forClass: JAVA stx libjava tests mocks interop IPerson1 theClass.
    Compiler compile: 'fooIPerson ^ 4' forClass: JAVA stx libjava tests mocks interop IPerson2 theClass.
    self should:[self assert: JAVA stx libjava tests mocks interop Person new fooIPerson] raise: Object ambiguousMessageSignal

    "Created: / 04-10-2013 / 15:43:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 19-03-2014 / 11:29:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_java_extension_05

    Compiler compile: 'fooIPerson1_05 ^ 50' forClass: JAVA stx libjava tests mocks interop IPerson1 theClass.
    self assert: JAVA stx libjava tests mocks interop Director new fooIPerson1_05 == 50.

    "Created: / 04-10-2013 / 20:09:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 19-03-2014 / 11:29:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaLookupTests methodsFor:'tests - java lookup'!

test3
    "I am not sure with this test :)"
    self shouldnt: [(Java classForName: 'stx.libjava.tests.mocks.interop.Object') new isNumber] raise: Exception.
    self assert: (Java classForName: 'stx.libjava.tests.mocks.interop.Object') new isNumber = false.

    "Created: / 11-04-2011 / 19:43:37 / kursjan <kursjan@fit.cvut.cz>"
!

testBasic
    self
        shouldnt:[ (Java classForName:'java.lang.Object') new hash ]
        raise:Exception.
    self
        shouldnt:[ (Java classForName:'java.lang.Object') new toString ]
        raise:Exception.

    "Created: / 11-04-2011 / 19:22:07 / kursjan <kursjan@fit.cvut.cz>"
!

testBoolean
    self assert: (self javaTestClass new getTrue) = true.

    "Created: / 11-04-2011 / 19:32:51 / kursjan <kursjan@fit.cvut.cz>"
    "Created: / 05-09-2011 / 21:06:13 / Jan Kurs <kursjan@fit.cvut.cz>"
!

testBoolean2
    self assert: (self javaTestClass new getFalse) = false.

    "Created: / 11-04-2011 / 19:32:51 / kursjan <kursjan@fit.cvut.cz>"
    "Created: / 05-09-2011 / 21:06:25 / Jan Kurs <kursjan@fit.cvut.cz>"
!

testBoolean3
    self assert: (self javaTestClass new getTruePrim) = true.

    "Created: / 11-04-2011 / 19:32:51 / kursjan <kursjan@fit.cvut.cz>"
    "Created: / 05-09-2011 / 21:07:29 / Jan Kurs <kursjan@fit.cvut.cz>"
!

testBoolean4
    self assert: (self javaTestClass new getFalsePrim) = false.

    "Created: / 11-04-2011 / 19:32:51 / kursjan <kursjan@fit.cvut.cz>"
    "Created: / 05-09-2011 / 21:07:38 / Jan Kurs <kursjan@fit.cvut.cz>"
!

testBoolean5
    self assert: (self javaTestClass new getFalseWithConversion) = false.

    "Created: / 11-04-2011 / 19:32:51 / kursjan <kursjan@fit.cvut.cz>"
    "Created: / 25-09-2011 / 19:23:36 / Jan Kurs <kursjan@fit.cvut.cz>"
!

testBoolean6
    self assert: (self javaTestClass new getFalseFromBooleanValueOf) = false.

    "Created: / 11-04-2011 / 19:32:51 / kursjan <kursjan@fit.cvut.cz>"
    "Created: / 25-09-2011 / 19:40:22 / Jan Kurs <kursjan@fit.cvut.cz>"
!

testClass
    self assert: ((Java classForName: 'java.lang.Object') isKindOf: JavaClass).
    self assert: ((Java classForName: 'java.lang.Object') new isKindOf: JavaObject)


    "Created: / 11-04-2011 / 19:22:07 / kursjan <kursjan@fit.cvut.cz>"
!

testDoesNotUnderstand
    self
        should:[ (Java classForName:'java.lang.Object') new bafickyBaf ]
        raise:MessageNotUnderstood.

    "Created: / 11-04-2011 / 19:22:07 / kursjan <kursjan@fit.cvut.cz>"
    "Created: / 30-08-2011 / 22:06:16 / Jan Kurs <kursjan@fit.cvut.cz>"
!

testInterfaceMethodsWithNarrowerReturnType
    "when a class A implements an interface I, and overridden method has narrower
    return type (e.g. method in I should return java.lang.Object, but overridden
    method in A declares return type of java.lang.String), java compiler generates
    synthetic method with the same name and return type declared in I, which just
    delegates to overridden method. This situation should not be considered
    as error case, instead, one of the methods should be returned."

self assert: (self javaTestClass new getMethodReturningObject) = 'working'.

    "Created: / 16-12-2012 / 12:56:01 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
!

testMultipleParameters
    "test multiple parameters"

    self
        assert: (self javaTestClass new foo) = 0

    "Created: / 11-04-2011 / 19:48:54 / kursjan <kursjan@fit.cvut.cz>"
    "Modified: / 05-09-2011 / 20:18:03 / Jan Kurs <kursjan@fit.cvut.cz>"
!

testMultipleParameters1
    "test multiple parameters"

    self
        assert: (self javaTestClass new foo: 1) = 1

    "Created: / 11-04-2011 / 19:48:54 / kursjan <kursjan@fit.cvut.cz>"
    "Created: / 05-09-2011 / 20:18:14 / Jan Kurs <kursjan@fit.cvut.cz>"
!

testMultipleParameters2
    "test multiple parameters"

    self
        assert: (self javaTestClass new foo: 1 and: 2) = 2

    "Created: / 11-04-2011 / 19:48:54 / kursjan <kursjan@fit.cvut.cz>"
    "Created: / 05-09-2011 / 20:18:30 / Jan Kurs <kursjan@fit.cvut.cz>"
!

testPassingNilAsParameter
    "
    Scenario: from smalltalk, pass a nil to an overloaded method with object-type argument.

    Question: What to do? Both matches, so Ambibuous message looks good,
    but then it behave differently if you do
        foo overloadedMethod: 'XXX'
        foo overloadedMethod: nil
    than if you do
        foo overloadedMethod: nil
        foo overloadedMethod: 'XXX'.
    On the other hand, which method do choose? Random one? Would lead into
    hard-to-debug situations.

    No good solution so far..."

    self skipIf: true description:'Solution wanted'

"/    self
"/        should:[r := self javaTestClass new overloadedMethod: nil]
"/        raise: AmbiguousMessage

    "Created: / 16-12-2012 / 11:35:14 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified: / 26-07-2016 / 08:07:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testPassingNilAsParameter2
    "nil should match any formal argument object type (so should not match primitives)"

    self assert: (self javaTestClass new overloadedMethodInt: nil) = 2.

    "Created: / 16-12-2012 / 16:21:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testSayHello
    self assert: (self javaTestClass new sayHello = 'hello').

    "Created: / 11-04-2011 / 19:32:51 / kursjan <kursjan@fit.cvut.cz>"
    "Modified: / 05-09-2011 / 21:05:40 / Jan Kurs <kursjan@fit.cvut.cz>"
!

testSayHelloStatic
    self assert: self javaTestClass staticSayHello = 'static hello'.

    "Created: / 11-04-2011 / 19:32:51 / kursjan <kursjan@fit.cvut.cz>"
    "Created: / 05-09-2011 / 20:26:44 / Jan Kurs <kursjan@fit.cvut.cz>"
!

testTypeOverloading
    "test type overloading"

    self assert:(self javaTestClass new overloadedMethod: 1) = 4.
    self assert:(self javaTestClass new overloadedMethod: 'Hi') = 3.
    self assert:(self javaTestClass new overloadedMethod: 'Hi') = 3.
    self assert:(self javaTestClass new overloadedMethod: 1) = 4.

    "Created: / 11-04-2011 / 20:02:54 / kursjan <kursjan@fit.cvut.cz>"
    "Modified: / 05-09-2011 / 21:37:53 / Jan Kurs <kursjan@fit.cvut.cz>"
    "Modified (format): / 03-12-2012 / 17:45:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testTypeOverloading_02
    "Tests overloaded method resulution"

    | director |

    director := JAVA stx libjava tests mocks interop Director new.
    director setTag1: 1.
    self assert: (director instVarNamed: #tag1) class == JAVA java lang Integer.
    self assert: ((director instVarNamed: #tag1) instVarNamed: #value) == 11.

    "Created: / 19-03-2014 / 12:39:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testTypeOverloading_03
    "Tests overloaded method resulution. Scenario:

    1) create an instance of Person
    2) send it #setTag1: JAVA java lang Object new.
       This creates a proxy #setTag1: that should call
       setTag1(Ljava/lang/Object;)V
    3) create an instance of TheOneAndOnlyBoss
    4) send it #setTag1: JAVA java lang Object new.
       This should send TheOneAndOnlyBoss#setTag1(I)V"

    | person tag boss |

    self assert: (Java classNamed:'stx.libjava.tests mocks.interop.TheOneAndOnlyBoss') isNil.
    person := JAVA stx libjava tests mocks interop Person new.
    tag := JAVA java lang Object new.
    person setTag1: tag.
    self assert: (person instVarNamed: #tag1) == tag.

    boss := JAVA stx libjava tests mocks interop TheOneAndOnlyBoss new.   
    boss setTag1: 1.
    self assert: (boss instVarNamed: #tag1) class == JAVA java lang Integer.
    self assert: ((boss instVarNamed: #tag1) instVarNamed: #value) == 1001.

    "
    JavaClassReloader unload: (Java classNamed:'stx.libjava.tests mocks.interop.TheOneAndOnlyBoss')
    "

    "Created: / 19-03-2014 / 13:31:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 19-03-2014 / 17:15:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaLookupTests methodsFor:'tests - java lookup - ctors'!

test_ctor01_Integer_a
    | o |

    o :=  self javaTestClass new: 1.
    self assert: (o instVarNamed: #eventsTally) == 1.
    self assert: (o instVarNamed: #events) first = 'Integer Constructor'.

    "Created: / 02-12-2013 / 23:39:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_ctor01_Integer_b
    | o |

    o :=  self javaTestClass new: (JAVA java lang Integer new: 1).
    self assert: (o instVarNamed: #eventsTally) == 1.
    self assert: (o instVarNamed: #events) first = 'Integer Constructor'.

    "Created: / 02-12-2013 / 23:39:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_ctor01_String
    | o |

    o :=  self javaTestClass new: 'String'.
    self assert: (o instVarNamed: #eventsTally) == 1.
    self assert: (o instVarNamed: #events) first = 'String Constructor'.

    "Created: / 02-12-2013 / 23:38:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_ctor01_default
    | o |

    o :=  self javaTestClass new.
    self assert: (o instVarNamed: #eventsTally) == 1.
    self assert: (o instVarNamed: #events) first = 'Default Constructor'.

    "Created: / 02-12-2013 / 23:34:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaLookupTests methodsFor:'tests - java lookup - fields'!

test_field_static_01
    self javaTestClass instVarNamed:#ICONST1 put: 1.
    self assert: (self javaTestClass ICONST1 == 1).
    self assert: (self javaTestClass ICONST_2 == 2).

    "/ It should not be possible to modify a final field
    self should: [self javaTestClass ICONST1: 10] raise: NoModificationError

    "Created: / 25-07-2016 / 23:33:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-07-2016 / 20:48:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_field_static_02
    self javaTestClass instVarNamed: #CHR put: $C codePoint.
    self assert: (self javaTestClass CHR == $C).
    self javaTestClass CHR: $X.
    self assert: (self javaTestClass CHR == $X).

    "Created: / 26-07-2016 / 08:23:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-07-2016 / 17:21:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_field_static_03
    | obj |

    obj := self javaTestClass new.
    self assert: (obj chr == Character null).
    obj chr: $X.
    self assert: (obj chr == $X).

    "Created: / 26-07-2016 / 18:02:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaLookupTests methodsFor:'tests - obsolete'!

_testSetManipulator_add
    "test interaction of smalltalk Set and java.util.Set"
    | aSet anObject |
    self breakPoint: #jk info: 'using SetSample, because it contains DNU hook - this is workaround'.
    aSet := SetSample new.
    anObject := Object new.

    self setManipulatorClass new addElement: aSet and: anObject.
    self assert: aSet size = 1.
    self assert:(self setManipulatorClass new getSize: aSet) = 1.
    self assert:(aSet contains: [:e | e = anObject ]).

    "Created: / 29-10-2012 / 07:17:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_testSetManipulator_contains
    "test interaction of smalltalk Set and java.util.Set"
    | aSet anObject |
    self breakPoint: #jk info: 'using SetSample, because it contains DNU hook - this is workaround'.
    aSet := SetSample new.
    anObject := Object new.

    self assert: (self setManipulatorClass new contains: aSet and: anObject) = false.
    aSet add: anObject.
    self assert: (self setManipulatorClass new contains: aSet and: anObject) = true.

    "Created: / 29-10-2012 / 07:18:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_testSetManipulator_getSize
    "test interaction of smalltalk Set and java.util.Set"
    | aSet |
    self breakPoint: #jk info: 'using SetSample, because it contains DNU hook - this is workaround'.
    aSet := SetSample new.

    self  assert:(self setManipulatorClass new getSize: aSet) = 0.
    aSet add: Object new.
    self  assert:(self setManipulatorClass new getSize: aSet) = 1.

    "Created: / 29-10-2012 / 07:17:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_testSetManipulator_isEmpty
    "test interaction of smalltalk Set and java.util.Set"
    | aSet |
    self breakPoint: #jk info: 'using SetSample, because it contains DNU hook - this is workaround'.
    aSet := SetSample new.

    self  assert: (self setManipulatorClass new isEmpty:aSet).
    aSet add: Object new.
    self  assert: (self setManipulatorClass new isEmpty:aSet) not.

    "Created: / 29-10-2012 / 07:17:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_testSetManipulator_remove
    "test interaction of smalltalk Set and java.util.Set"
    | aSet anObject |
    self breakPoint: #jk info: 'using SetSample, because it contains DNU hook - this is workaround'.
    aSet := SetSample new.
    anObject := Object new.


    aSet add: anObject.
    self setManipulatorClass new remove: aSet and: anObject.
    self assert: aSet size = 0.
    self assert:(self setManipulatorClass new getSize: aSet) = 0.
    self assert:(aSet contains: [:e | e = anObject ]) not.

    "Created: / 29-10-2012 / 07:17:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaLookupTests methodsFor:'tests - smalltalk lookup'!

testPersonManipulator_getAge
    "test interaction of Smalltallk objects with Java code"
    | person |
    person := PersonSample new.

    person name: 'Anne'.
    person age: 18.

    "/ !!!!!! The three assertions in a row is by purpose !!!!!!
    "/ Do not remove them. The reason is that with JIT on,
    "/ the JIT compiler recompiles method each time a reference
    "/ is resolved. This should cover different code paths.

    self assert:(self personManipulatorClass new getPersonAge: person) = 18.
    self assert:(self personManipulatorClass new getPersonAge: person) = 18.
    self assert:(self personManipulatorClass new getPersonAge: person) = 18.

    "Created: / 11-04-2011 / 20:02:54 / kursjan <kursjan@fit.cvut.cz>"
    "Created: / 25-09-2011 / 17:27:45 / Jan Kurs <kursjan@fit.cvut.cz>"
    "Modified (comment): / 20-01-2014 / 10:11:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testPersonManipulator_getName
    "test interaction of Smalltallk objects with Java code"
    | person |
    person := PersonSample new.

    person name: 'Anne'.
    person age: 18.

    "/ !!!!!! The three assertions in a row is by purpose !!!!!!
    "/ Do not remove them. The reason is that with JIT on,
    "/ the JIT compiler recompiles method each time a reference
    "/ is resolved. This should cover different code paths.

    self assert:(self personManipulatorClass new getPersonName: person) = 'Anne'.
    self assert:(self personManipulatorClass new getPersonName: person) = 'Anne'.
    self assert:(self personManipulatorClass new getPersonName: person) = 'Anne'.

    "Created: / 11-04-2011 / 20:02:54 / kursjan <kursjan@fit.cvut.cz>"
    "Created: / 25-09-2011 / 17:27:34 / Jan Kurs <kursjan@fit.cvut.cz>"
    "Modified: / 20-01-2014 / 10:11:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaLookupTests class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaLookupTests.st,v 1.5 2015-03-20 12:08:00 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !

