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

TestCase subclass:#JavaClassReloaderTests
	instanceVariableNames:'testClassLoader'
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Tests-ClassReloading'
!

!JavaClassReloaderTests class methodsFor:'documentation'!

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

history

    "Created: #resources / 21-12-2012 / 18:09:27 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified: #setUp / 02-10-2013 / 22:54:13 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified: #tearDown / 02-10-2013 / 22:54:16 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
! !

!JavaClassReloaderTests class methodsFor:'resources'!

resources

  ^ Array 
        with: JavaInitializedResource.

    "Created: / 21-12-2012 / 18:09:27 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
! !

!JavaClassReloaderTests methodsFor:'interfaces'!

testAddingInterface
    OperatingSystem getLoginName = 'm' ifTrue:[
        self assert: false message: 'implement me!!'
    ]

    "Created: / 16-12-2012 / 17:40:40 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified: / 03-04-2013 / 22:07:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaClassReloaderTests methodsFor:'private'!

compile: sourceCode
    | classes |

    classes := JavaCompiler compile: sourceCode.
"/    classes do:[:cls|cls classLoader: testClassLoader] .
    ^classes

    "Created: / 16-12-2012 / 17:02:41 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified: / 09-04-2013 / 22:39:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

compileAndRegister: sourceCode
    |compiledClasses|

    compiledClasses := self compile: sourceCode.
    ^ self register: compiledClasses.

    "Created: / 16-12-2012 / 16:59:19 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
!

performTest

    JavaClassReader classLoaderQuerySignal answer: testClassLoader do:[
        super performTest
    ].

    "Created: / 16-12-2012 / 16:35:01 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
!

register: aClassOrArray

    ^aClassOrArray isArray ifTrue:[
        JavaVM registry registerClasses: aClassOrArray .
        JavaVM registry classNamed: aClassOrArray anElement binaryName loader: aClassOrArray anElement classLoader
    ] ifFalse:[
        JavaVM registry registerClass: aClassOrArray.
        JavaVM registry classNamed: aClassOrArray binaryName loader: aClassOrArray classLoader
    ].

    "Created: / 16-12-2012 / 17:02:04 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified: / 14-10-2013 / 23:12:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testInfrastructure

    |compiledClass|

    self assert: (JavaClassReader classLoaderQuerySignal query = testClassLoader ) 
        message: 'tests should run in testClassLoader sandbox'.
    compiledClass := self compileAndRegister: '
public class HelloSun {

    public String hello() {
        return "helloooo";
    }

}
'.
    self assert: compiledClass notNil message: 'Java compiler should be working for these tests to run'.
    self assert: compiledClass classLoader = testClassLoader message: 'compiled classes should have testClassLoader as their defining cl'.
    self assert: (JavaVM registry getClassesDefinedBy: testClassLoader) size = 1 message: 'only classes from these tests should use testClassLoader'.
    self assert: (JavaVM registry getClassesDefinedBy: testClassLoader) anElement == compiledClass message: 'compiled classes should be registered in testClassLoader'.

    "Created: / 16-12-2012 / 16:38:17 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
! !

!JavaClassReloaderTests methodsFor:'running'!

setUp
    testClassLoader := JAVA java lang ClassLoader new.
    ObjectMemory garbageCollect.

    "Created: / 16-12-2012 / 16:32:32 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified: / 02-10-2013 / 22:54:13 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
!

tearDown
    JavaVM registry unregisterClassLoader: testClassLoader.
    ObjectMemory garbageCollect.

    "Created: / 16-12-2012 / 16:33:31 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified: / 02-10-2013 / 22:54:16 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
! !

!JavaClassReloaderTests methodsFor:'test helpers'!

callerClass
    | callerClass |
    callerClass := (JavaCompiler 
            compile: '
package classReloadingTests;
public class Caller {
    public String callFooToString(Object c) {
        return c.toString();
    }   
}
') anElement.
    callerClass 
        ifNil: [ self error: 'callerClass is expected to be not nil in these tests' ].
    ^ callerClass.

    "Created: / 06-12-2012 / 21:41:35 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 18-12-2012 / 14:00:12 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified: / 04-01-2013 / 14:51:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

compileAndRegisterChangingClassParent

    self compileAndRegister: '
package classReloadingTests;
public class ChangingClassParent {
    public String foo() {
        return "parent";
    }

    public String toString() {
        return "" + foo();
    }   
}'.

    "Created: / 18-12-2012 / 13:47:32 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
! !

!JavaClassReloaderTests methodsFor:'tests - classes'!

test_classes_01a
    "
    1) compile simple class with static method that returns an instance
       **non-existent** class Missing
    2) 
    3) compile Missing class
    4) call that static method, should return an instance of Missing
    "

    | user missing  |
    user := self compileAndRegister:'
public class test_classes_01a_user { 
    public static Object foo() {
        return new test_classes_01a_Missing();
    }
}'.

    self should: [ user new foo ] raise: JavaUnresolvedCompilationError.

    missing := self compileAndRegister:'
public class test_classes_01a_Missing {
}
'.

    self shouldnt: [ user new foo ] raise: JavaUnresolvedCompilationError.
    self assert: user new foo class == missing.

    "Created: / 16-10-2013 / 13:26:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaClassReloaderTests methodsFor:'tests - concurrency'!

test_concurrency_01
    "
    Test whether an update of class is atomic    

    1) compile simple class with one method
    2) spawn a hammering thread that run that method in a loop.
    3) change the method to call another method
    4) change the method back
    5) repeat steps 3) and 4) 100 times.

    Check, that everything works, no error occur...
    "

    <timeout: 600> "10min"

    | source1 source2 class hammerer iterations stop error limit probes |

    source1 := '
public class test_concurrency_01 { 
    public String bar() {
        String s = foo();
        assert(s instanceof String);
        return s;
    }
    public String foo() { 
        return "XXX"; 
    }
}'.                                  

    source2 := '
public class test_concurrency_01 { 
    public String bar() {
        String s = foo();
        assert(s instanceof String);
        return s;
    }

    public String foo() { 
        return foo(this.getClass().getName()); 
    }

    public String foo(String s) {
        return s;
    }
}'.


    class := self compileAndRegister: source1.
    self assert: class new foo = 'XXX'.

    "/ Spawn a hammering thread...
    stop := false.
    error := nil.
    iterations := 0.
    hammerer := [ 
        | inst |

        inst := class new.
        [ 
            [ stop ] whileFalse:[ 
                | string |
                string := inst bar.
                Object assert: string isString.
                iterations := iterations + 1.
            ].
        ] on: Error do:[:ex |
            error := ex.
            self yourself.
        ]
    ] fork.


    probes := 0.
    [ error isNil and:[ probes < 100 ] ] whileTrue:[
        Transcript 
            show: 'JavaClassReloaderTests>>test_concurrency_01, iteration ';
            showCR: probes printString.
        limit := iterations + 10.
        "/ Wait until some more iterations are done...
        [ (iterations < limit) and:[error isNil ] ] whileTrue:[ 
            Delay waitForMilliseconds: 100. 
        ].          

        class := self compileAndRegister: (probes even ifTrue:[source2] ifFalse:[source2]).

        limit := iterations + 10.
        "/ Wait until some more iterations are done...
        [ (iterations < limit) and:[error isNil ] ] whileTrue:[ 
            Delay waitForMilliseconds: 100. 
        ].
        probes := probes + 1.
    ].

    stop := true.
    hammerer terminate.

    self assert: error isNil.

    "Created: / 01-04-2015 / 12:03:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-04-2015 / 19:25:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaClassReloaderTests methodsFor:'tests - fields'!

test_fields_00a
    "
     1) compile simple class with one field
     2) change type of the field from int to Object
"
    
    | jclass1  jinst1  jclass2  jinst2  callerClass |
    jclass1 := self 
            compileAndRegister: '
public class test_01 { 
    public int foo = 1;
    public int bar() {
        return 1;
    }
}'.

    self assert: jclass1 hasMultipleVersions not message: 'java class should not have multiple versions initially'.

    jinst1 := jclass1 new.
    jclass2 := self 
            compileAndRegister: '
public class test_01 { 
    public Object foo = new Object();
    public int bar() {
        return 2;
    }
}'.
    jinst2 := jclass2 new.
    callerClass := self 
            compileAndRegister: '
public class CallerClass {
    public static Object getFoo(test_01 inst) {
        return inst.foo;
    }
}'.
    self assert: jclass1 ~~ jclass2.
    self assert: jclass1 fields size == 1.
    self assert: jclass1 fields anElement descriptor = 'I'.
    self assert: jinst1 bar == 1.
    self assert: jclass2 fields size == 1.
    self assert: jclass2 fields anElement descriptor = 'Ljava/lang/Object;'.
    self assert: jinst2 bar == 2.
    self shouldnt: [ callerClass getFoo: jinst1 ] raise: Error.
    self shouldnt: [ callerClass getFoo: jinst2 ] raise: Error.

    "Created: / 09-04-2013 / 15:00:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 09-04-2013 / 16:17:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-10-2013 / 12:51:20 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
!

test_fields_00b
    "
     1) compile simple class with one field
     2) change type of the field from Object to int
"
    
    | jclass1  jinst1  jclass2  jinst2  callerClass |
    jclass1 := self 
            compileAndRegister: '
public class test_01 { 
    public Object foo = new Object();
    public int bar() {
        return 1;
    }
}'.
    jinst1 := jclass1 new.
    jclass2 := self 
            compileAndRegister: '
public class test_01 { 
    public int foo = 42;
    public int bar() {
        return 2;
    }
}'.
    jinst2 := jclass2 new.
    callerClass := self 
            compileAndRegister: '
public class CallerClass {
    public static int getFoo(test_01 inst) {
        return inst.foo;
    }
}'.
    self assert: jclass1 ~~ jclass2.
    self assert: jclass1 fields size == 1.
    self assert: jclass1 fields anElement descriptor = 'Ljava/lang/Object;'.
    self assert: jinst1 bar == 1.
    self assert: jclass2 fields size == 1.
    self assert: jclass2 fields anElement descriptor = 'I'.
    self assert: jinst2 bar == 2.
    self shouldnt: [ callerClass getFoo: jinst1 ] raise: Error.
    self shouldnt: [ callerClass getFoo: jinst2 ] raise: Error.

    "Created: / 20-09-2013 / 00:05:59 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified: / 12-10-2013 / 18:19:51 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
!

test_fields_01a
    "
    1) compile simple class with one field
    2) change type of the field from String to Object
    3) as this is type generalization, no new class version
        should be introduced, new field type is used by old class

    "

    | jclass1 jinst1 jclass2 jinst2 callerClass |

    jclass1 := self compileAndRegister:'
public class test_01 { 
    public String foo = "xxx";
    public int bar() {
        return 1;
    }
}'.
    jinst1 := jclass1 new.

    jclass2 := self compileAndRegister:'
public class test_01 { 
    public Object foo = new Object();
    public int bar() {
        return 2;
    }
}'.
    jinst2 := jclass2 new.

    callerClass := self compileAndRegister:'
public class CallerClass {
    public static Object getFoo(test_01 inst) {
        return inst.foo;
    }
}'.

    self assert: jclass1 == jclass2.

    self assert: jclass1 fields size == 1.
    self assert: jclass1 fields anElement descriptor = 'Ljava/lang/Object;'.
    self assert: jinst1 bar == 2.

    self assert: jclass2 fields size == 1.
    self assert: jclass2 fields anElement descriptor = 'Ljava/lang/Object;'.
    self assert: jinst2 bar == 2.

    self shouldnt:   [ callerClass getFoo: jinst1 ] raise: Error.
    self shouldnt: [ callerClass getFoo: jinst2 ] raise: Error.

    "Created: / 09-04-2013 / 15:24:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-10-2013 / 19:28:02 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
!

test_fields_01b
    "
    1) compile simple class with one field
    2) change type of the field from Object to String
    3) new class version should be created

    "

    | jclass1 jinst1 jclass2 jinst2 callerClass |

    jclass1 := self compileAndRegister:'
public class test_01 { 
    public Object foo = new Object();
    public int bar() {
        return 1;
    }
}'.
    jinst1 := jclass1 new.

    callerClass := self compileAndRegister:'
public class CallerClass {
    public static Object getFoo(test_01 inst) {
        return inst.foo;
    }
}'.

    jclass2 := self compileAndRegister:'
public class test_01 { 
    public String foo = "XXX";
    public int bar() {
        return 2;
    }
}'.
    jinst2 := jclass2 new.



    self assert: jclass1 ~~ jclass2.

    self assert: jclass1 fields size == 1.
    self assert: jclass1 fields anElement descriptor = 'Ljava/lang/Object;'.
    self assert: jinst1 bar == 1.

    self assert: jclass2 fields size == 1.
    self assert: jclass2 fields anElement descriptor = 'Ljava/lang/String;'.
    self assert: jinst2 bar == 2.

    self shouldnt: [ callerClass getFoo: jinst1 ] raise: Error.
    self shouldnt:   [ callerClass getFoo: jinst2 ] raise: Error.

    "Created: / 09-04-2013 / 15:25:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-10-2013 / 19:28:25 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
!

test_fields_02a
    "
    1) compile simple class with one public field
    2) add second field after the first one
    3) create caller class that accesses the public field
    4) check that caller class accesses the right field
       on both old and new instance
    "

    | jclass1 jinst1 jclass2 jinst2 callerClass |

    jclass1 := self compileAndRegister:'
public class test_fields_02a { 
    public String foo = "foo";
}'.
    jinst1 := jclass1 new.


    jclass2 := self compileAndRegister:'
public class test_fields_02a { 
    public String foo = "foo+bar";
    public String bar = "foo+bar";
}'.

    self assert: jclass1 isObsolete.
    self assert: jclass1 class isObsolete.
    self deny: jclass2 isObsolete.
    self deny: jclass2 class isObsolete.
    
    jinst2 := jclass2 new.

    callerClass := self compileAndRegister:'
public class test_fields_02a_caller {
    public static String getFoo(test_fields_02a x) {
        return x.foo;
    }
}'.

    self assert: jclass2 fields size == 2.

    self assert: (callerClass getFoo: jinst1) = 'foo'.   
    self assert: (callerClass getFoo: jinst2) = 'foo+bar'.

    "Created: / 09-04-2013 / 15:32:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 19-09-2016 / 16:52:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_fields_02b
    "
    1) compile simple class with one public field
    2) add second field after the first one
    3) create caller class that accesses the public field
    4) check that caller class accesses the right field
       on both old and new instance
    "

    | jclass1 jinst1 jclass2 jinst2 callerClass |

    jclass1 := self compileAndRegister:'
public class test_fields_02b { 
    public String foo = "foo";
}'.
    jinst1 := jclass1 new.

    callerClass := self compileAndRegister:'
public class test_fields_02b_caller {
    public static String getFoo(test_fields_02b x) {
        return x.foo;
    }
}'.

    jclass2 := self compileAndRegister:'
public class test_fields_02b { 
    public String foo = "foo+bar";
    public String bar = "foo+bar";
}'.
    jinst2 := jclass2 new.

    self assert: jclass2 fields size == 2.

    self assert: (callerClass getFoo: jinst1) = 'foo'.   
    self assert: (callerClass getFoo: jinst2) = 'foo+bar'.

    "Created: / 09-04-2013 / 15:30:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_fields_03a
    "
    1) compile simple class with one public field
    2) add second field before the first one
    3) create caller class that accesses the public field
    4) check that caller class accesses the right field
       on both old and new instance
    "

    | jclass1 jinst1 jclass2 jinst2 callerClass |

    jclass1 := self compileAndRegister:'
public class test_fields_03a { 
    public String foo = "foo";
}'.
    jinst1 := jclass1 new.


    jclass2 := self compileAndRegister:'
public class test_fields_03a { 
    public String bar = "foo+bar";
    public String foo = "foo+bar";
}'.
    jinst2 := jclass2 new.

    callerClass := self compileAndRegister:'
public class test_fields_03a_caller {
    public static String getFoo(test_fields_03a x) {
        return x.foo;
    }
}'.

    self assert: jclass2 fields size == 2.

    self assert: (callerClass getFoo: jinst1) = 'foo'.   
    self assert: (callerClass getFoo: jinst2) = 'foo+bar'.

    "Created: / 09-04-2013 / 15:33:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_fields_03b
    "
    1) compile simple class with one public field
    2) add second field before the first one
    3) create caller class that accesses the public field
    4) check that caller class accesses the right field
       on both old and new instance
    "

    | jclass1 jinst1 jclass2 jinst2 callerClass |

    jclass1 := self compileAndRegister:'
public class test_fields_03b { 
    public String foo = "foo";
}'.
    jinst1 := jclass1 new.

    callerClass := self compileAndRegister:'
public class test_fields_03b_caller {
    public static String getFoo(test_fields_03b x) {
        return x.foo;
    }
}'.

    jclass2 := self compileAndRegister:'
public class test_fields_03b { 
    public String bar = "foo+bar";
    public String foo = "foo+bar";
}'.
    jinst2 := jclass2 new.



    self assert: jclass2 fields size == 2.

    self assert: (callerClass getFoo: jinst1) = 'foo'.   
    self assert: (callerClass getFoo: jinst2) = 'foo+bar'.

    "Created: / 09-04-2013 / 15:34:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_fields_03c
    "
    1) compile simple class with one public field
    2) add second field before the first one
    3) create caller class that accesses the new field
    4) check that caller class accesses the new field
       on new instance
    5) check that caller class accessing new field on
       old instances throws exception
    "

    | jclass1 jinst1 jclass2 jinst2 callerClass |

    jclass1 := self compileAndRegister:'
public class test_fields_03c { 
    public String foo = "foo";
}'.
    jinst1 := jclass1 new.


    jclass2 := self compileAndRegister:'
public class test_fields_03c { 
    public String bar = "foo+bar";
    public String foo = "foo+bar";
}'.
    jinst2 := jclass2 new.

    callerClass := self compileAndRegister:'
public class test_fields_03c_caller {
    public static String getBar(test_fields_03c x) {
        return x.bar;
    }
}'.

    self assert: jclass2 fields size == 2.

    self assert: (callerClass getBar: jinst2) = 'foo+bar'.
    self should: [ callerClass getBar: jinst1 ] raise: Error.

    "Created: / 09-04-2013 / 15:53:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_fields_04a
    "
    1) compile simple class with two public fields
    2) remove first field
    3) create caller class that accesses the second field
    4) check that caller class accesses the right field
       on both old and new instances
    "

    | jclass1 jinst1 jclass2 jinst2 callerClass |

    jclass1 := self compileAndRegister:'
public class test_fields_04a { 
    public String foo = "foo";
    public String bar = "bar+foo";
}'.
    jinst1 := jclass1 new.

    jclass2 := self compileAndRegister:'
public class test_fields_04a { 
    public String bar = "bar";
}'.
    jinst2 := jclass2 new.

    callerClass := self compileAndRegister:'
public class test_fields_04a_caller {
    public static String getBar(test_fields_04a x) {
        return x.bar;
    }
}'.

    self assert: jclass2 fields size == 1.

    self assert: (callerClass getBar: jinst1) = 'bar+foo'.   
    self assert: (callerClass getBar: jinst2) = 'bar'.

    "Created: / 09-04-2013 / 15:46:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_fields_04b
    "
    1) compile simple class with two public fields
    2) remove first field
    3) create caller class that accesses the second field
    4) check that caller class accesses the right field
       on both old and new instances
    "

    | jclass1 jinst1 jclass2 jinst2 callerClass |

    jclass1 := self compileAndRegister:'
public class test_fields_04b { 
    public String foo = "foo";
    public String bar = "bar+foo";
}'.
    jinst1 := jclass1 new.

    callerClass := self compileAndRegister:'
public class test_fields_04b_caller {
    public static String getBar(test_fields_04b x) {
        return x.bar;
    }
}'.

    jclass2 := self compileAndRegister:'
public class test_fields_04b { 
    public String bar = "bar";
}'.
    jinst2 := jclass2 new.



    self assert: jclass2 fields size == 1.

    self assert: (callerClass getBar: jinst1) = 'bar+foo'.   
    self assert: (callerClass getBar: jinst2) = 'bar'.

    "Created: / 09-04-2013 / 15:45:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_fields_04c
    "
    1) compile simple class with two public fields
    2) create caller class that accesses the first field
    3) remove first field
    4) check that caller class accesses the first field
       on old instances
    5) check that accessing the first field on new instances
       raises exception
    "

    | jclass1 jinst1 jclass2 jinst2 callerClass |

    jclass1 := self compileAndRegister:'
public class test_fields_04c { 
    public String foo = "foo";
    public String bar = "bar+foo";
}'.
    jinst1 := jclass1 new.

    callerClass := self compileAndRegister:'
public class test_fields_04c_caller {
    public static String getFoo(test_fields_04c x) {
        return x.foo;
    }
}'.

    jclass2 := self compileAndRegister:'
public class test_fields_04c { 
    public String bar = "bar";
}'.
    jinst2 := jclass2 new.


    self assert: jclass1 ~~ jclass2.
    self assert: jclass2 fields size == 1.

    self assert: (callerClass getFoo: jinst1) = 'foo'.   
    self should: [ callerClass getFoo: jinst2 ] raise: Error.

    "Created: / 09-04-2013 / 15:57:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-10-2013 / 18:14:20 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
!

test_fields_05a
    "
    1) compile simple class with one field
    2) change visibility of the field
    3) accessing the field should raise exception
    "

    | jclass1 jinst1 jclass2 callerClass |

    jclass1 := self compileAndRegister:'
public class test_fields_05a { 
    public String foo = "public_foo";
}'.

    callerClass := self compileAndRegister:'
public class CallerClass {
    public static String getFoo(test_fields_05a inst) {
        return inst.foo;
    }
}'.  

    jinst1 := jclass1 new.
    self assert: (callerClass getFoo: jinst1) = 'public_foo'.  

    jclass2 := self compileAndRegister:'
public class test_fields_05a { 
    private String foo = "private_foo";
}'.       
    self should:   [ callerClass getFoo: jinst1 ] raise: Error.

    "Created: / 09-04-2013 / 16:16:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-10-2013 / 18:17:00 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
!

test_fields_05b
    "
    1) compile simple class with private field
    2) change visibility of the field to public
    3) accessing the field should not raise exception anymore
    "

    | jclass1 jinst1 jclass2 callerClass |

    jclass1 := self compileAndRegister:'
public class test_fields_05b { 
    private String foo = "private_foo";
}'.

    callerClass := self compileAndRegister:'
public class CallerClass {
    public static String getFoo(test_fields_05b inst) {
        return inst.foo;
    }
}'. 

    jinst1 := jclass1 new.
    self should: [ callerClass getFoo: jinst1 ] raise: Error.

    jclass2 := self compileAndRegister:'
public class test_fields_05b { 
    public String foo = "public_foo";
}'.

    callerClass := self compileAndRegister:'
public class CallerClass {
    public static String getFoo(test_fields_05b inst) {
        return inst.foo;
    }
}'.
    self assert: jclass1 == jclass2.
    self assert: (callerClass getFoo: jinst1) = 'private_foo'.

    "Created: / 11-04-2013 / 10:41:52 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified (format): / 13-10-2013 / 21:05:17 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified: / 15-10-2013 / 00:03:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_fields_in_parent_01a
    "
    1) compile Parent class with one public field
    2) subclass it by Child
    3) add field to parent
    4) check that Child has multivers
    "

    | parentClass parentClass2 childClass |

    parentClass := self compileAndRegister:'
public class test_fields_in_parent_01a { 
    public String foo = "foo";
}'.

    childClass := self compileAndRegister:'
public class test_fields_in_parent_01a_child extends test_fields_in_parent_01a {     
}'.   

    self assert: childClass hasMultipleVersions not.  

    parentClass2 := self compileAndRegister:'
public class test_fields_in_parent_01a {     
    public String bar = "bar";
    public String foo = "foo";  
}'. 

    self assert: childClass hasMultipleVersions.

    "Created: / 28-10-2013 / 12:41:18 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
! !

!JavaClassReloaderTests methodsFor:'tests - garbage versions'!

test_old_versions_cleaned_01
    "
    1) compile simple class with one public field
    2) compile new version - add second field after the first one
    3) check that both versions exist after GC
    4) throw away the reference to the first version
    5) check only second version exists after GC
    "

    | jclass1 jinst1 jclass2 jinst2 |

    self skipIf: true description: 'To be reviewd'.

    jclass1 := self compileAndRegister:'
public class test_old_versions_cleaned_01 { 
    public String foo = "foo";
}'.
    jinst1 := jclass1 new.

    jclass2 := self compileAndRegister:'
public class test_old_versions_cleaned_01 { 
    public String foo = "foo+bar";
    public String bar = "foo+bar";
}'.
    jinst2 := jclass2 new.

    ObjectMemory garbageCollect.
    ObjectMemory scavenge.

    self assert: jclass1 hasMultipleVersions.
    self assert: jclass2 hasMultipleVersions.

    jclass1 :=  nil.
    jinst1 :=  nil.

    ObjectMemory garbageCollect.
    ObjectMemory scavenge.  

    self assert: jclass2 hasMultipleVersions not.

    "Created: / 28-10-2013 / 12:28:50 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified: / 20-09-2016 / 21:30:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaClassReloaderTests methodsFor:'tests - hierarchy'!

test_hierarchy_00

    "
    1) compile a parent and a child class, parent having a method
    2) change parent's method
    3) assert the method is changed in child
    "

    | jclass1_A jclass1_B jinst1_B jclass_caller jinst2_B jclass2_B |

    jclass1_A := self compileAndRegister:'
public class test_hierarchy_00_A { 
    public int foo() {
        return 1;
    }
}'.

     jclass1_B := self compileAndRegister:'
public class test_hierarchy_00_B extends test_hierarchy_00_A { 
}'.

    jclass_caller :=  self compileAndRegister:'
public class test_hierarchy_00_caller  {
    public int call(test_hierarchy_00_B b) {
        return b.foo();
    }
}'.

    jinst1_B := jclass1_B new.

    self assert: (jclass_caller new call: jinst1_B) == 1.

    jclass2_B := self compileAndRegister:'
public class test_hierarchy_00_B extends test_hierarchy_00_A { 
  public int foo() {
        return 2;
    }
}'.

    jinst2_B := jclass2_B new.

    self assert: (jclass_caller new call: jinst1_B) == 2.
    self assert: (jclass_caller new call: jinst2_B) == 2.

    "Created: / 09-04-2013 / 16:09:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-04-2013 / 11:24:33 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
!

test_hierarchy_01a

    "
    1) compile a parent and a child class
    2) add field to parent
    3) assert the field is present in new instances of child
    "

    | jclass1_A jclass2_A jclass1_B jinst1_B jclass_caller jinst2_B jclass2_B |

    jclass1_A := self compileAndRegister:'
public class test_hierarchy_01_A {}'.

     jclass1_B := self compileAndRegister:'
public class test_hierarchy_01_B extends test_hierarchy_01_A {}'.

    jinst1_B := jclass1_B new.    

    jclass2_A := self compileAndRegister:'
public class test_hierarchy_01_A {
    public int foo = 1;
}'.

    jclass2_B := self compileAndRegister:'
public class test_hierarchy_01_B extends test_hierarchy_01_A {}'. 

    jclass_caller :=  self compileAndRegister:'
public class test_hierarchy_01_caller  {
    public int call(test_hierarchy_01_B b) {
        return b.foo;
    }
}'.

    jinst2_B := jclass2_B new.

    self should: [ jclass_caller new call: jinst1_B ] raise: Error.
    self assert: (jclass_caller new call: jinst2_B) == 1.

    "Created: / 11-04-2013 / 11:37:21 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified: / 13-10-2013 / 16:17:18 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
!

test_hierarchy_02a

    "
    1) compile a grandparent, a parent and a child class, 
          grandparent having a method, child overriding
          the method and calling super.
    2) override method in parent
    3) assert the method from parent is called by super in child's method
    "

    | jclass1_A jclass1_B jclass1_C jinst1_C jclass_caller jinst2_C jclass2_B |

    jclass1_A := self compileAndRegister:'
public class test_hierarchy_02_A { 
    public int foo() {
        return 1;
    }
}'.

     jclass1_B := self compileAndRegister:'
public class test_hierarchy_02_B extends test_hierarchy_02_A {}'.

     jclass1_C := self compileAndRegister:'
public class test_hierarchy_02_C extends test_hierarchy_02_B {
    public int foo() {
        return super.foo();
    }
}'.

    jclass_caller :=  self compileAndRegister:'
public class test_hierarchy_02_caller  {
    public int call(test_hierarchy_02_C c) {
        return c.foo();
    }
}'.

    jinst1_C := jclass1_C new.

    self assert: (jclass_caller new call: jinst1_C) == 1.

    jclass2_B := self compileAndRegister:'
public class test_hierarchy_02_B extends test_hierarchy_02_A { 
  public int foo() {
        return 2;
    }
}'.

    jinst2_C := jclass1_C new.

    self assert: (jclass_caller new call: jinst1_C) == 2.
    self assert: (jclass_caller new call: jinst2_C) == 2.

    "Created: / 11-04-2013 / 11:07:26 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified (comment): / 21-08-2013 / 23:39:24 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
!

test_hierarchy_02b

    "
    only a variation of test_hierarchy_02a
    1) compile a grandparent, a parent and a child class, 
          grandparent having a method, child overriding
          the method and calling super.
    2) override method in parent
    3) assert the method from parent is called by super in child's method    
    "

    | jclass1_A jclass1_B jclass1_C jinst1_C jclass_caller jinst2_C jclass2_B |

    jclass1_A := self compileAndRegister:'
public class test_hierarchy_02_A { 
    public int foo() {
        return 1;
    }

    public int bar() {
        return 10;
    }
}'.

     jclass1_B := self compileAndRegister:'
public class test_hierarchy_02_B extends test_hierarchy_02_A {}'.

     jclass1_C := self compileAndRegister:'
public class test_hierarchy_02_C extends test_hierarchy_02_B {
    public int foo() {
        return super.foo();
    }

    public int bar() {
        return super.bar();
    }
}'.

    jclass_caller :=  self compileAndRegister:'
public class test_hierarchy_02_caller  {
    public int callFoo(test_hierarchy_02_C c) {
        return c.foo();
    }

    public int callBar(test_hierarchy_02_C c) {
        return c.bar();
    }
}'.

    jinst1_C := jclass1_C new.

    self assert: (jclass_caller new callFoo: jinst1_C) == 1.
    self assert: (jclass_caller new callBar: jinst1_C) == 10.

    jclass2_B := self compileAndRegister:'
public class test_hierarchy_02_B extends test_hierarchy_02_A { 
    public int bar() {
        return 20;
    }        
}'.

    jinst2_C := jclass1_C new.

    self assert: (jclass_caller new callFoo: jinst1_C) == 1.
    self assert: (jclass_caller new callFoo: jinst2_C) == 1.
    self assert: (jclass_caller new callBar: jinst1_C) == 20.
    self assert: (jclass_caller new callBar: jinst2_C) == 20.

    "Created: / 11-04-2013 / 11:07:49 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified (comment): / 21-08-2013 / 23:39:18 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
!

test_hierarchy_03a

    "
    1) compile a grandparent, a parent and a child class, 
          grandparent and child having a constructor, child calling
          super in its constructor
    2) add constructor to parent class
    3) assert the constructor from parent is called from child's contructor    
    "

    | jclass1_A jclass1_B jclass1_C jinst1_C jclass_caller jinst2_C jclass2_B |

    jclass1_A := self compileAndRegister:'
public class test_hierarchy_03_A {
    protected int foo;

    public test_hierarchy_03_A(int foo) {
        this.foo = foo;
    }

    public int getFoo() {
        return foo;
    }
}'.

     jclass1_B := self compileAndRegister:'
public class test_hierarchy_03_B extends test_hierarchy_03_A {
    public test_hierarchy_03_B(int foo) {
        super(foo);
    }  
}'.

     jclass1_C := self compileAndRegister:'
public class test_hierarchy_03_C extends test_hierarchy_03_B {
    public test_hierarchy_03_C(int foo) {
        super(foo);
    }    
}'.

    jclass_caller :=  self compileAndRegister:'
public class test_hierarchy_03_caller  {
    public int getFoo(test_hierarchy_03_C c) {
        return c.getFoo();
    }
}'.

    jinst1_C := jclass1_C new: 1.

    self assert: (jclass_caller new getFoo: jinst1_C) == 1.

    jclass2_B := self compileAndRegister:'
public class test_hierarchy_03_B extends test_hierarchy_03_A { 
    public test_hierarchy_03_B(int foo) {
        super(2 * foo);
    }        
}'.

    jinst2_C := jclass1_C new: 2.

    self assert: (jclass_caller new getFoo: jinst1_C) == 1.
    self assert: (jclass_caller new getFoo: jinst2_C) == 4.

    "Created: / 11-04-2013 / 11:14:12 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified: / 21-08-2013 / 23:47:03 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
!

test_hierarchy_04a

    "
    1) compile a parent1, parent2 and a child class, 
          parent1 having an Integer field, parent2 having a String field.
          Child extends parent1.
    2) change child's superclass to parent2
    3) assert new instances of child have new field
    "

    | jclass1_A1 jclass1_A2 jclass1_B jclass2_B jinst1_B jinst2_B jclass_caller |

    jclass1_A1 := self compileAndRegister:'
public class test_hierarchy_04_A1 {
    public Integer foo = 1;
}'.

    jclass1_A2 := self compileAndRegister:'
public class test_hierarchy_04_A2 {
    public String foo = "foo";
}'.

     jclass1_B := self compileAndRegister:'
public class test_hierarchy_04_B extends test_hierarchy_04_A1 {}'.     

    jclass_caller :=  self compileAndRegister:'
public class test_hierarchy_04_caller  {
    public Object getFoo(test_hierarchy_04_B c) {
        return c.foo;
    }
}'.

    jinst1_B := jclass1_B new.

    self assert: ((jclass_caller new getFoo: jinst1_B) equals: (Java as_Integer: 1)).

    jclass2_B := self compileAndRegister:'
public class test_hierarchy_04_B extends test_hierarchy_04_A2 {}'.

    jinst2_B := jclass2_B new.


    self assert: ((jclass_caller new getFoo: jinst1_B) equals: (Java as_Integer: 1)).
    self assert: (jclass_caller new getFoo: jinst2_B) = (Java as_String: 'foo').

    "Created: / 11-04-2013 / 13:16:03 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified: / 12-10-2013 / 18:04:03 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
! !

!JavaClassReloaderTests methodsFor:'tests - methods'!

testAddingMethod    
    "    
    1) compile a class inheriting from ChangingClassParent.
    2) instantiate inheriting class.
    3) assert calling foo on subclass uses method from superclass'.
    4) recompile inheriting class with overridden foo method.
    5) assert overridden method is used.
    "
   | caller inst |
   caller := self callerClass new.
   self compileAndRegisterChangingClassParent.

    self compileAndRegister: '
package classReloadingTests;
public class ChangingClass extends ChangingClassParent {}
'.
     
    inst := JAVA classReloadingTests ChangingClass new.
    self assert: (caller callFooToString: inst) = 'parent'.        

    self compileAndRegister: '
package classReloadingTests;
public class ChangingClass extends ChangingClassParent {
    public String foo() {
        return "child";
    }
}'.
    self assert: (caller callFooToString: inst) = 'child'.

    "Created: / 06-12-2012 / 21:52:02 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified (comment): / 18-12-2012 / 14:12:06 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
!

testChangingSignatureOfMethod
    "
    1) compile a class with foo method returning string.    
    2) instantiate the class.    
    3) assert method returns string.
    4) recompile class with foo method returning int.
    5) assert new method is used.
    "

    | caller inst |
    caller := self callerClass new.

    self compileAndRegister: '
package classReloadingTests;
public class ChangingClass {
    public String toString() {
        return "" + foo();
    }

    public String foo() {
        return "child";
    }
}
'.
    inst := JAVA classReloadingTests ChangingClass new.
    self assert: (caller callFooToString: inst) = 'child'.        

    self compileAndRegister: '
package classReloadingTests;
public class ChangingClass {
    public String toString() {
        return "" + foo();
    }

    public int foo() {
        return 5;
    }
}'.
    self assert: (caller callFooToString: inst) = '5'.

    "Created: / 06-12-2012 / 21:50:53 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified (comment): / 18-12-2012 / 14:08:36 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
!

testModifyingMethod
    "
    1) compile a class with foo method.    
    2) instantiate the class.    
    3) assert method returns string.
    4) recompile class with foo method returning different string.
    5) assert new method is used.
    "

    | caller inst |
    caller := self callerClass new.

    self compileAndRegister: '
package classReloadingTests;
public class ChangingClass {
    public String toString() {
        return "" + foo();
    }

    public String foo() {
        return "child";
    }
}
'.
    inst := JAVA classReloadingTests ChangingClass new.
    self assert: (caller callFooToString: inst) = 'child'.        

    self compileAndRegister: '
package classReloadingTests;
public class ChangingClass {
    public String toString() {
        return "" + foo();
    }

    public String foo() {
        return "modified child";
    }
}'.
        self assert: (caller callFooToString: inst) = 'modified child'.

    "Created: / 06-12-2012 / 21:51:14 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified (comment): / 18-12-2012 / 14:09:48 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
!

testRemovingMethod   
  "    
    1) compile a class inheriting from ChangingClassParent, which overrides foo method.
    2) instantiate inheriting class.
    3) assert calling foo on subclass uses overridden method'.
    4) recompile inheriting class without foo method.
    5) assert parent method is used.
    "
   | caller inst |
   caller := self callerClass new.
   self compileAndRegisterChangingClassParent.

    self compileAndRegister: '
package classReloadingTests;
public class ChangingClass extends ChangingClassParent {
    public String foo() {
        return "child";
    }
}'.

    inst := JAVA classReloadingTests ChangingClass new.
    self assert: (caller callFooToString: inst) = 'child'.

    self compileAndRegister: '
package classReloadingTests;
public class ChangingClass extends ChangingClassParent {}'.
    self assert: (caller callFooToString: inst) = 'parent'.

    "Created: / 16-12-2012 / 16:01:58 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified (comment): / 18-12-2012 / 14:11:56 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
!

test_00
    "
    1) compile simple class with no method
    3) recompile same source again.
    4) check that class does not change
    "

    | jclass1 jclass2 |
    jclass1 := self compileAndRegister:'
public class test_01 { 
    public int foo() { 
        return 10; 
    }
}'.
    self assert: jclass1 new foo == 10.

    jclass2 := self compileAndRegister:'
public class test_01 { 
    public int foo() { 
        return 10; 
    }
}'.

    self assert: jclass1 == jclass2. "/only method update, so reloaded class should be the same
    self assert: (JavaVM registry getClassesDefinedBy: testClassLoader) size = 1 message: 'only classes from these tests should use testClassLoader'.
    self assert: (JavaVM registry getClassesDefinedBy: testClassLoader) anElement == jclass1 message: 'compiled classes should be registered in testClassLoader'.

    "Created: / 16-12-2012 / 23:51:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_00b
    "
    1) compile simple class with no method but in package
    3) recompile same source again.
    4) check that class does not change
    "

    | jclass1 jclass2 |
    jclass1 := self compileAndRegister:'
package zork;
public class test_01 { 
    public int foo() { 
        return 10; 
    }
}'.
    self assert: jclass1 new foo == 10.

    jclass2 := self compileAndRegister:'
package zork;
public class test_01 { 
    public int foo() { 
        return 10; 
    }
}'.

    self assert: jclass1 == jclass2. "/only method update, so reloaded class should be the same
    self assert: (JavaVM registry getClassesDefinedBy: testClassLoader) size = 1 message: 'only classes from these tests should use testClassLoader'.
    self assert: (JavaVM registry getClassesDefinedBy: testClassLoader) anElement == jclass1 message: 'compiled classes should be registered in testClassLoader'.

    "Created: / 16-12-2012 / 23:56:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 18-12-2012 / 12:02:24 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
!

test_01
    "
    1) compile simple class with one method return 10
    2) call that method, check that it returns 10
    3) recompile to return 20
    4) call that method, check that it returns 20
    "

    | jclass1 jclass2 |
    jclass1 := self compileAndRegister:'
public class test_01 { 
    public int foo() { 
        return 10; 
    }
}'.
    self assert: jclass1 new foo == 10.

    jclass2 := self compileAndRegister:'
public class test_01 { 
    public int foo() { 
        return 20; 
    }
}'.

    self assert: jclass2 new foo == 20.
    self assert: jclass1 == jclass2. "/only method update, so reloaded class should be the same

    "Created: / 16-12-2012 / 23:48:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_02a
    "
    1) compile simple class with one method return 10
    2) call that method indirectly, check that it returns 10
    3) recompile to return 20
    4) call that method indirectly, check that it returns 20
    "

    | jclass1 jclass2 caller |
    jclass1 := self compileAndRegister:'
public class test_02 { 
    public int foo() { 
        return 10; 
    }
}'.
    caller := self compileAndRegister:'
public class test_02_caller {
    public int qux(test_02 t) {
        return t.foo();
    }
}
'.
    self assert: (caller new qux: (jclass1 new)) == 10.

    jclass2 := self compileAndRegister:'
public class test_02 { 
    public int foo() { 
        return 20; 
    }
}'.
    self assert: (caller new qux: (jclass2 new)) == 20.

    "Created: / 17-12-2012 / 00:02:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_02b
    "
    1) compile simple class with one method return 10
    2) call that method indirectly using fresh instance (NEW), 
       check that it returns 10
    3) recompile to return 20
    4) call that method indirectly, check that it returns 20
    "

    | jclass1 jclass2 caller |
    jclass1 := self compileAndRegister:'
public class test_02 { 
    public int foo() { 
        return 10; 
    }
}'.
    caller := self compileAndRegister:'
public class test_02_caller {
    public int qux() {
        test_02 t = new test_02();
        return t.foo();
    }
}
'.
    self assert: (caller new qux) == 10.

    jclass2 := self compileAndRegister:'
public class test_02 { 
    public int foo() { 
        return 20; 
    }
}'.
    self assert: (caller new qux) == 20.

    "Created: / 17-12-2012 / 00:04:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_02c
    "
    Same as 02a, but with static methods
    "

    | jclass1 jclass2 caller |
    jclass1 := self compileAndRegister:'
public class test_02 { 
    public static int foo() {
        return 10; 
    }
}'.
    caller := self compileAndRegister:'
public class test_02_caller {
    public int qux() {
        return test_02.foo();
    }
}
'.
    self assert: (caller new qux) == 10.

    jclass2 := self compileAndRegister:'
public class test_02 { 
    public static int foo() { 
        return 20; 
    }
}'.
    self assert: (caller new qux) == 20.

    "Created: / 17-12-2012 / 00:03:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-12-2012 / 12:07:59 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
!

test_03a
    "
    1) compile simple class with one public **static** method that returns 10
    2) call that method indirectly, check that it returns 10
    3) change it to private method
    4) calling method should raise exception
    "

    | jclass1 jclass2 caller |
    jclass1 := self compileAndRegister:'
public class test_03 { 
    public static int foo() {
        return 10; 
    }
}'.
    caller := self compileAndRegister:'
public class test_03_caller {
    public static int qux() {
        return test_03.foo();
    }
}
'.
    self assert: (caller new qux) == 10.

    jclass2 := self compileAndRegister:'
public class test_03 { 
    private static int foo() { 
        return 20; 
    }
}'.
    self should: [ caller new qux ] raise: Error.

    "Created: / 11-04-2013 / 10:44:18 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified: / 21-08-2013 / 23:09:27 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified (comment): / 16-10-2013 / 11:12:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_03b
    "
    1) compile simple class with one private **static** method that returns 10
    2) call that method indirectly, check that it raises exception
    3) change it to public method
    4) calling method should not raise exception anymore
    "

    | jclass1 jclass2 jclass3 caller |
    jclass1 := self compileAndRegister:'
public class test_03 { 
    public static int foo() {
        return 10; 
    }
}'.
    caller := self compileAndRegister:'
public class test_03_caller {
    public static int qux() {
        return test_03.foo();
    }
}
'.
    self assert: (caller new qux) == 10.      

    jclass2 := self compileAndRegister:'
public class test_03 { 
    private static int foo() { 
        return 20; 
    }
}'.

    self should: [ caller new qux ] raise: Error. 
 
    jclass3 := self compileAndRegister:'
public class test_03 { 
    public static int foo() { 
        return 42; 
    }
}'.
    self assert: (caller new qux) == 42.

    "Created: / 11-04-2013 / 10:46:31 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified: / 21-08-2013 / 23:11:15 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified (comment): / 16-10-2013 / 11:11:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_04b
    "
    1) compile simple class with one private **static** method that returns 10
    2) call that method indirectly, check that it raises exception
    3) change it to public method
    4) calling method should not raise exception anymore
    "

    | jclass1 jclass2 jclass3 caller |
    jclass1 := self compileAndRegister:'
public class test_04 { 
    public int foo() {
        return 10; 
    }
}'.
    caller := self compileAndRegister:'
public class test_03_caller {
    public int qux(test_04 test) {
        return test.foo();
    }
}
'.
    self assert: (caller new qux: jclass1 new) == 10.      

    jclass2 := self compileAndRegister:'
public class test_04 { 
    private int foo() { 
        return 20; 
    }
}'.

    self should: [ caller new qux: jclass1 new ] raise: Error. 
 
    jclass3 := self compileAndRegister:'
public class test_04 { 
    public int foo() { 
        return 42; 
    }
}'.
    self assert: (caller new qux: jclass1 new) == 42.

    "Created: / 16-10-2013 / 11:17:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_05
    "
    1) compile simple class with one method, set a method-level breakpoint on it
    3) recompile same source again.
    4) check that class does not change
    "

    | jclass1 jclass2 |
    jclass1 := self compileAndRegister:'
public class test_01 { 
    public int foo() { 
        return 10; 
    }
}'.
    self assert: jclass1 new foo == 10.
    MessageTracer trapMethod: (jclass1 >> #'foo()V').

    jclass2 := self compileAndRegister:'
public class test_01 { 
    public int foo() { 
        return 15; 
    }
}'.

    self assert: jclass1 == jclass2. "/only method update, so reloaded class should be the same
    self assert: (JavaVM registry getClassesDefinedBy: testClassLoader) size = 1 message: 'only classes from these tests should use testClassLoader'.
    self assert: (JavaVM registry getClassesDefinedBy: testClassLoader) anElement == jclass1 message: 'compiled classes should be registered in testClassLoader'.

    "Created: / 17-08-2014 / 08:34:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaClassReloaderTests methodsFor:'tests - overloads'!

test_overloads_00a
    "
    1) compile simple class with one method taking Object arg
    3) compile caller class passing in String
    4) recompile simple class, overload the method with one taking String arg
    5) assert caller class invokes the String method
    "

    | jclass1 jclass2 callerClass jinst1 jinst2 |
    jclass1 := self compileAndRegister:'
public class test_overloads_00 { 
    public int foo(Object o) { 
        return 1; 
    }
}'.    

    callerClass := self compileAndRegister:'
public class CallerClass { 
    public int call(test_overloads_00 o) { 
        return o.foo("foo"); 
    }
}'.
    jinst1 := jclass1 new.

    self assert: (callerClass new call: jinst1) = 1.

    jclass2 := self compileAndRegister:'
public class test_overloads_00 { 
    public int foo(Object o) { 
        return 1; 
    }

    public int foo(String s) { 
        return 2; 
    }
}'. 
    jinst2 := jclass2 new.

    self assert: (callerClass new call: jinst1) = 2.
    self assert: (callerClass new call: jinst2) = 2.

    "Created: / 11-04-2013 / 13:29:44 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
!

test_overloads_00b
    "
    1) compile simple class with two methods taking Object and String arg
    3) compile caller class passing in String
    4) recompile simple class, remove overloaded method taking String arg
    5) assert caller class invokes the Object method
    "

    | jclass1 jclass2 callerClass jinst1 jinst2 |
    jclass1 := self compileAndRegister:'
public class test_overloads_00 { 
    public int foo(Object o) { 
        return 1; 
    }

    public int foo(String s) { 
        return 2; 
    }
}'.    

    callerClass := self compileAndRegister:'
public class CallerClass { 
    public int call(test_overloads_00 o) { 
        return o.foo("foo"); 
    }
}'.
    jinst1 := jclass1 new.

    self assert: (callerClass new call: jinst1) = 2.

    jclass2 := self compileAndRegister:'
public class test_overloads_00 { 
    public int foo(Object o) { 
        return 1; 
    }
}'. 
    jinst2 := jclass2 new.

    self assert: (callerClass new call: jinst1) = 1.
    self assert: (callerClass new call: jinst2) = 1.

    "Created: / 11-04-2013 / 13:30:38 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
!

test_overloads_01a
    "
    1) compile simple class with one method taking Object arg
    3) compile caller class passing in String
    4) recompile simple class, overload the method with one taking String arg
    5) assert caller class invokes the String method
    "

    | jclass1A jclass1B jclass2A callerClass jinst1 jinst2 |
    jclass1A := self compileAndRegister:'
public class test_overloads_01_A { 
    public int foo(Object o) { 
        return 1; 
    }
}'.    

    jclass1B := self compileAndRegister:'
public class test_overloads_01_B extends test_overloads_01_A {
    public int foo(String foo) {
        return super.foo(foo) + 10;
    }
}'.

    callerClass := self compileAndRegister:'
public class CallerClass { 
    public int call(test_overloads_01_B o) { 
        return o.foo("foo"); 
    }
}'.
    jinst1 := jclass1B new.

    self assert: (callerClass new call: jinst1) = 11.

    jclass2A := self compileAndRegister:'
public class test_overloads_01_A { 
    public int foo(Object o) { 
        return 1; 
    }

    public int foo(String s) { 
        return 2; 
    }
}'. 
    jinst2 := jclass1B new.

    self assert: (callerClass new call: jinst1) = 12.
    self assert: (callerClass new call: jinst2) = 12.

    "Created: / 11-04-2013 / 13:34:59 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified: / 15-10-2013 / 23:33:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_overloads_01b
    "
    1) compile simple class with two overloaded methods taking Object and String arg
    3) compile caller class passing in String
    4) recompile simple class, remove overloaded method aking String arg
    5) assert caller class invokes the Object method
    "

    | jclass1A jclass1B jclass2A callerClass jinst1 jinst2 |
    jclass1A := self compileAndRegister:'
public class test_overloads_01_A { 
    public int foo(Object o) { 
        return 1; 
    }    

    public int foo(String s) { 
        return 2; 
    }
}'.    

    jclass1B := self compileAndRegister:'
public class test_overloads_01_B extends test_overloads_01_A {
    public int foo(String foo) {
        return super.foo(foo) + 10;
    }
}'.

    callerClass := self compileAndRegister:'
public class CallerClass { 
    public int call(test_overloads_01_B o) { 
        return o.foo("foo"); 
    }
}'.
    jinst1 := jclass1B new.

    self assert: (callerClass new call: jinst1) = 12.

    jclass2A := self compileAndRegister:'
public class test_overloads_01_A { 
    public int foo(Object o) { 
        return 1; 
    } 
}'. 
    jinst2 := jclass1B new.

    self assert: (callerClass new call: jinst1) = 11.
    self assert: (callerClass new call: jinst2) = 11.

    "Created: / 11-04-2013 / 13:35:15 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified: / 15-10-2013 / 23:34:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaClassReloaderTests methodsFor:'tests - unloading'!

test_unloading_01
    "
    1) compile class A1 and class A2 inheriting from A1 
    2) compile class B that instantiates A and  call its method A2.bar from B.foo
    3) remove class A1 (should remove A2 as well)
    4) call B.foo and checks it raises ClassNotFoundException
    5) compile class A2
    6) call B.foo and checks it returns new value
    "

    | jclassA1 jclassA2 jclassB jinstB |

    jclassA1 := self compileAndRegister:'
public class test_unloading_01_A1 { 
    public int bar() {
        return 1;
    }
}'.

    jclassA2 := self compileAndRegister:'
public class test_unloading_01_A2 extends test_unloading_01_A1 { 
}'.


    jclassB := self compileAndRegister:'
public class test_unloading_01_B { 
    public int foo() {
        return (new test_unloading_01_A2()).bar();
    }
}'.
    jinstB := jclassB new.
    self assert: jinstB foo == 1.
    self assert: (Smalltalk allClasses includesIdentical: jclassA1).
    self assert: (Smalltalk allClasses includesIdentical: jclassA2).


    jclassA1 removeFromSystem.
    self assert: (Smalltalk allClasses includesIdentical: jclassA1) not.
    self assert: (Smalltalk allClasses includesIdentical: jclassA2) not.

    [
        jinstB foo.
        self assert: false "/ should raise ClassNotFoundException
    ] on: JAVA java lang ClassNotFoundException do:[
        self assert: true.
    ].

    jclassA2 := self compileAndRegister:'
public class test_unloading_01_A2 { 
    public int bar() {
        return 20;
    }
}'.

    self assert: jinstB foo == 20.

    "Created: / 14-09-2013 / 18:57:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_unloading_02
    "
    1) compile class A 
    2) compile class B that instantiates A and  call its method A. bar from B.foo
    3) remove class A
    4) call B.foo and checks it raises ClassNotFoundException
    5) compile class A
    6) call B.foo and checks it returns new value
    "

    | jclassA jclassB jinstB |

    jclassA := self compileAndRegister:'
public class test_unloading_01_A { 
    public int bar() {
        return 1;
    }
}'.

    jclassB := self compileAndRegister:'
public class test_unloading_01_B { 
    public int foo() {
        return (new test_unloading_01_A()).bar();
    }
}'.
    jinstB := jclassB new.
    self assert: jinstB foo == 1.

    jclassA removeFromSystem.
    [
        jinstB foo.
        self assert: false "/ should raise ClassNotFoundException
    ] on: JAVA java lang ClassNotFoundException do:[
        self assert: true.
    ].

    jclassA := self compileAndRegister:'
public class test_unloading_01_A { 
    public int bar() {
        return 20;
    }
}'.

    self assert: jinstB foo == 20.

    "Created: / 16-10-2013 / 10:11:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_unloading_02a
    "
    1) compile interface I1 and class A2 implementing I1
    2) compile class B that instantiates A and  call its method A2.bar from B.foo
    3) remove class I1 (should remove A2 as well)
    4) call B.foo and checks it raises ClassNotFoundException
    5) compile class A2
    6) call B.foo and checks it returns new value
    "

    | jclassI1 jclassA2 jclassB jinstB |

    jclassI1 := self compileAndRegister:'
public interface test_unloading_01_I1 { 
    public int bar()
}'.

    jclassA2 := self compileAndRegister:'
public class test_unloading_01_A2 implements test_unloading_01_I1 { 
    public int bar() { return 1; }
}'.


    jclassB := self compileAndRegister:'
public class test_unloading_01_B { 
    public int foo() {
        return (new test_unloading_01_A2()).bar();
    }
}'.
    jinstB := jclassB new.
    self assert: jinstB foo == 1.
    self assert: (Smalltalk allClasses includesIdentical: jclassI1).
    self assert: (Smalltalk allClasses includesIdentical: jclassA2).


    jclassI1 removeFromSystem.
    self assert: (Smalltalk allClasses includesIdentical: jclassI1) not.
    self assert: (Smalltalk allClasses includesIdentical: jclassA2) not.

    [
        jinstB foo.
        self assert: false "/ should raise ClassNotFoundException
    ] on: JAVA java lang ClassNotFoundException do:[
        self assert: true.
    ].

    jclassA2 := self compileAndRegister:'
public class test_unloading_01_A2 { 
    public int bar() {
        return 20;
    }
}'.

    self assert: jinstB foo == 20.

    "Created: / 14-09-2013 / 19:02:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_unloading_02b
    "
    1) compile interface I1, I2, I2 implenting I1, and class A2 implementing I2
    2) compile class B that instantiates A and  call its method A2.bar from B.foo
    3) remove class I1 (should remove A2 as well)
    4) call B.foo and checks it raises ClassNotFoundException
    5) compile class A2
    6) call B.foo and checks it returns new value
    "

    | jclassI1 jclassI2 jclassA2 jclassB jinstB |

    jclassI1 := self compileAndRegister:'
public interface test_unloading_01_I1 { 
    public int bar()
}'.

    jclassI2 := self compileAndRegister:'
public interface test_unloading_01_I2 extends  test_unloading_01_I1 { 
}'.


    jclassA2 := self compileAndRegister:'
public class test_unloading_01_A2 implements test_unloading_01_I1 { 
    public int bar() { return 1; }
}'.


    jclassB := self compileAndRegister:'
public class test_unloading_01_B { 
    public int foo() {
        return (new test_unloading_01_A2()).bar();
    }
}'.
    jinstB := jclassB new.
    self assert: jinstB foo == 1.
    self assert: (Smalltalk allClasses includesIdentical: jclassI1).
    self assert: (Smalltalk allClasses includesIdentical: jclassA2).


    jclassI1 removeFromSystem.
    self assert: (Smalltalk allClasses includesIdentical: jclassI1) not.
    self assert: (Smalltalk allClasses includesIdentical: jclassI2) not.
    self assert: (Smalltalk allClasses includesIdentical: jclassA2) not.

    [
        jinstB foo.
        self assert: false "/ should raise ClassNotFoundException
    ] on: JAVA java lang ClassNotFoundException do:[
        self assert: true.
    ].

    jclassA2 := self compileAndRegister:'
public class test_unloading_01_A2 { 
    public int bar() {
        return 20;
    }
}'.

    self assert: jinstB foo == 20.

    "Created: / 14-09-2013 / 19:04:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-09-2013 / 00:40:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_unloading_03a
    "
    1) compile class A with inner class InnerA
    2) remove class A
    3) check that InnerA has been removed too.
    "

    | jclassA jclassInnerA |

    self compileAndRegister:'
public class test_unloading_03a_A { 
    public static class InnerA {
    }
}'.

    jclassA := JavaVM classNamed: #'test_unloading_03a_A' definedBy: testClassLoader.
    jclassInnerA := JavaVM classNamed: #'test_unloading_03a_A$InnerA' definedBy: testClassLoader.

    self assert: (Smalltalk allClasses includesIdentical: jclassA).
    self assert: (Smalltalk allClasses includesIdentical: jclassInnerA).

    jclassA removeFromSystem.

    self assert: (Smalltalk allClasses includesIdentical: jclassA) not.
    self assert: (Smalltalk allClasses includesIdentical: jclassInnerA) not.

    self assert: (JavaVM classNamed: #'test_unloading_03a_A' definedBy: testClassLoader) isNil.    
    self assert: (JavaVM classNamed: #'test_unloading_03a_A$InnerA' definedBy: testClassLoader) isNil.

    "Created: / 08-08-2014 / 22:00:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-08-2014 / 23:02:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_unloading_03b
    "
    1) compile class A with inner class InnerA
    2) remove class A
    3) check that both classes are gone
    "

    | jclassA jclassInnerA |

    self compileAndRegister:'
public class test_unloading_03a_A { 
    public static class InnerA {
    }
}'.

    jclassA := JavaVM classNamed: #'test_unloading_03a_A' definedBy: testClassLoader.
    jclassInnerA := JavaVM classNamed: #'test_unloading_03a_A$InnerA' definedBy: testClassLoader.

    self assert: (Smalltalk allClasses includesIdentical: jclassA).
    self assert: (Smalltalk allClasses includesIdentical: jclassInnerA).

    jclassInnerA removeFromSystem.

    self assert: (Smalltalk allClasses includesIdentical: jclassA) .
    self assert: (Smalltalk allClasses includesIdentical: jclassInnerA) not.

    self assert: (JavaVM classNamed: #'test_unloading_03a_A' definedBy: testClassLoader) notNil.    
    self assert: (JavaVM classNamed: #'test_unloading_03a_A$InnerA' definedBy: testClassLoader) isNil.

    "Created: / 11-08-2014 / 09:25:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_unloading_03c
    "
    1) compile class A with inner class InnerA
    2) remove class A
    3) check that both classes are gone
    "

    | jclassA jclassInnerA |

    self compileAndRegister:'
public class test_unloading_03a_A { 
    public static class InnerA {
    }
}'.

    jclassA := JavaVM classNamed: #'test_unloading_03a_A' definedBy: testClassLoader.
    jclassInnerA := JavaVM classNamed: #'test_unloading_03a_A$InnerA' definedBy: testClassLoader.

    self assert: (Smalltalk allClasses includesIdentical: jclassA).
    self assert: (Smalltalk allClasses includesIdentical: jclassInnerA).

    jclassA removeFromSystem.
    jclassInnerA removeFromSystem.

    self assert: (Smalltalk allClasses includesIdentical: jclassA) not.
    self assert: (Smalltalk allClasses includesIdentical: jclassInnerA) not.

    self assert: (JavaVM classNamed: #'test_unloading_03a_A' definedBy: testClassLoader) isNil.    
    self assert: (JavaVM classNamed: #'test_unloading_03a_A$InnerA' definedBy: testClassLoader) isNil.

    "Created: / 11-08-2014 / 09:25:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_unloading_03d
    "
    1) compile class A with inner class InnerA
    2) remove class A
    3) check that both classes are gone
    "

    | jclassA jclassInnerA |

    self compileAndRegister:'
public class test_unloading_03a_A { 
    public static class InnerA {
    }
}'.

    jclassA := JavaVM classNamed: #'test_unloading_03a_A' definedBy: testClassLoader.
    jclassInnerA := JavaVM classNamed: #'test_unloading_03a_A$InnerA' definedBy: testClassLoader.

    self assert: (Smalltalk allClasses includesIdentical: jclassA).
    self assert: (Smalltalk allClasses includesIdentical: jclassInnerA).

    jclassInnerA removeFromSystem.
    jclassA removeFromSystem.

    self assert: (Smalltalk allClasses includesIdentical: jclassA) not.
    self assert: (Smalltalk allClasses includesIdentical: jclassInnerA) not.

    self assert: (JavaVM classNamed: #'test_unloading_03a_A' definedBy: testClassLoader) isNil.    
    self assert: (JavaVM classNamed: #'test_unloading_03a_A$InnerA' definedBy: testClassLoader) isNil.

    "Created: / 11-08-2014 / 09:26:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_unloading_04a
    "
    1) compile class A with annonymous class A$1
    2) remove class A then A$1
    3) check that A$1 has been removed too.
    "

    | jclassA jclassA_1 |

    self compileAndRegister:'
public class test_unloading_04a_A { 
    public Object foo() {
        return new Object() { public void bar() { } };
    }
}'.

    jclassA := JavaVM classNamed: #'test_unloading_04a_A' definedBy: testClassLoader.
    jclassA_1 := JavaVM classNamed: #'test_unloading_04a_A$1' definedBy: testClassLoader.

    self assert: (Smalltalk allClasses includesIdentical: jclassA).
    self assert: (Smalltalk allClasses includesIdentical: jclassA_1).

    jclassA removeFromSystem.

    self assert: (Smalltalk allClasses includesIdentical: jclassA) not.
    self assert: (Smalltalk allClasses includesIdentical: jclassA_1) not.

    self assert: (JavaVM classNamed: #'test_unloading_04a_A' definedBy: testClassLoader) isNil.    
    self assert: (JavaVM classNamed: #'test_unloading_04a_A$1' definedBy: testClassLoader) isNil.

    "Created: / 12-08-2014 / 22:17:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_unloading_04b
    "
    1) compile class A with annonymous class A$1
    2) remove class A$1
    3) check that A$1 has been removed too.
    "

    | jclassA jclassA_1 |

    self compileAndRegister:'
public class test_unloading_04b_A { 
    public Object foo() {
        return new Object() { public void bar() { } };
    }
}'.

    jclassA := JavaVM classNamed: #'test_unloading_04b_A' definedBy: testClassLoader.
    jclassA_1 := JavaVM classNamed: #'test_unloading_04b_A$1' definedBy: testClassLoader.

    self assert: (Smalltalk allClasses includesIdentical: jclassA).
    self assert: (Smalltalk allClasses includesIdentical: jclassA_1).

    jclassA_1 removeFromSystem.

    self assert: (Smalltalk allClasses includesIdentical: jclassA).
    self assert: (Smalltalk allClasses includesIdentical: jclassA_1) not.

    self assert: (JavaVM classNamed: #'test_unloading_04b_A' definedBy: testClassLoader) notNil.    
    self assert: (JavaVM classNamed: #'test_unloading_04b_A$1' definedBy: testClassLoader) isNil.

    "Created: / 12-08-2014 / 22:23:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_unloading_04c
    "
    1) compile class A with annonymous class A$1
    2) remove class A then A$1
    3) check that A$1 has been removed too.
    "

    | jclassA jclassA_1 |

    self compileAndRegister:'
public class test_unloading_04c_A { 
    public Object foo() {
        return new Object() { public void bar() { } };
    }
}'.

    jclassA := JavaVM classNamed: #'test_unloading_04c_A' definedBy: testClassLoader.
    jclassA_1 := JavaVM classNamed: #'test_unloading_04c_A$1' definedBy: testClassLoader.

    self assert: (Smalltalk allClasses includesIdentical: jclassA).
    self assert: (Smalltalk allClasses includesIdentical: jclassA_1).

    jclassA removeFromSystem.
    jclassA_1 removeFromSystem.

    self assert: (Smalltalk allClasses includesIdentical: jclassA) not.
    self assert: (Smalltalk allClasses includesIdentical: jclassA_1) not.

    self assert: (JavaVM classNamed: #'test_unloading_04c_A' definedBy: testClassLoader) isNil.    
    self assert: (JavaVM classNamed: #'test_unloading_04c_A$1' definedBy: testClassLoader) isNil.

    "Created: / 12-08-2014 / 22:24:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_unloading_04d
    "
    1) compile class A with annonymous class A$1
    2) remove class A then A$1
    3) check that A$1 has been removed too.
    "

    | jclassA jclassA_1 |

    self compileAndRegister:'
public class test_unloading_04d_A { 
    public Object foo() {
        return new Object() { public void bar() { } };
    }
}'.

    jclassA := JavaVM classNamed: #'test_unloading_04d_A' definedBy: testClassLoader.
    jclassA_1 := JavaVM classNamed: #'test_unloading_04d_A$1' definedBy: testClassLoader.

    self assert: (Smalltalk allClasses includesIdentical: jclassA).
    self assert: (Smalltalk allClasses includesIdentical: jclassA_1).

    jclassA_1 removeFromSystem.
    jclassA removeFromSystem.

    self assert: (Smalltalk allClasses includesIdentical: jclassA) not.
    self assert: (Smalltalk allClasses includesIdentical: jclassA_1) not.

    self assert: (JavaVM classNamed: #'test_unloading_04d_A' definedBy: testClassLoader) isNil.    
    self assert: (JavaVM classNamed: #'test_unloading_04d_A$1' definedBy: testClassLoader) isNil.

    "Created: / 12-08-2014 / 22:25:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_unloading_04e
    "
    1) compile class A with nested class A$Nested and annonymous class A$1
    2) remove class A then A$Nested
    3) check that A$1 has been removed too.
    "

    | jclassA jclassA_Nested jclassA_1 |

    self compileAndRegister:'
public class test_unloading_04e_A {
    public static class Nested {
        public Object foo() {
            return new Object() { public int bar() { return 10; } };
        }
    }
}'.

    jclassA := JavaVM classNamed: #'test_unloading_04e_A' definedBy: testClassLoader.
    jclassA_Nested := JavaVM classNamed: #'test_unloading_04e_A$Nested' definedBy: testClassLoader.
    jclassA_1 := JavaVM classNamed: #'test_unloading_04e_A$1' definedBy: testClassLoader.

    self assert: (Smalltalk allClasses includesIdentical: jclassA).
    self assert: (Smalltalk allClasses includesIdentical: jclassA_Nested).
    self assert: (Smalltalk allClasses includesIdentical: jclassA_1).

    jclassA removeFromSystem.

    self assert: (Smalltalk allClasses includesIdentical: jclassA) not.
    self assert: (Smalltalk allClasses includesIdentical: jclassA_Nested) not.
    self assert: (Smalltalk allClasses includesIdentical: jclassA_1) not.

    self assert: (JavaVM classNamed: #'test_unloading_04e_A' definedBy: testClassLoader) isNil.    
    self assert: (JavaVM classNamed: #'test_unloading_04e_A$Nested' definedBy: testClassLoader) isNil.
    self assert: (JavaVM classNamed: #'test_unloading_04e_A$1' definedBy: testClassLoader) isNil.

    "Created: / 10-10-2014 / 12:08:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaClassReloaderTests class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaClassReloaderTests.st,v 1.2 2015-03-20 12:07:59 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id::                                                                                                                        '
! !

