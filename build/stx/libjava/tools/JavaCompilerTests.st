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
"{ Package: 'stx:libjava/tools' }"

"{ NameSpace: Smalltalk }"

TestCase subclass:#JavaCompilerTests
	instanceVariableNames:'classloader'
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Tests-Compiling'
!

!JavaCompilerTests class methodsFor:'documentation'!

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

    "Created: #resources / 21-12-2012 / 18:24:51 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
! !

!JavaCompilerTests class methodsFor:'accessing'!

resources
    ^ Array with: JavaInitializedResource

    "Created: / 02-01-2013 / 15:16:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaCompilerTests methodsFor:'helpers'!

registerFooBarSuperclass
    | sourceCode  compiledClasses |
    sourceCode := '
package stx.libjava;
class FooBar {    

}
'.
    compiledClasses := JavaCompiler compile: sourceCode.
    compiledClasses isNil ifTrue: [
        self 
            error: 'these tests need PackageVisibleClass and aparently it could not be compiled'
    ].
    JavaVM registry registerClasses: compiledClasses.

    "Created: / 09-12-2012 / 09:28:10 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified: / 09-12-2012 / 20:35:03 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified: / 02-01-2013 / 17:02:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

registerPackageVisibleClass
    | sourceCode  compiledClasses |
    sourceCode := '
package stx.libjava.tests;
class PackageVisibleClass {

    public int foo() {
        return 42;
    }

}
'.
    compiledClasses := JavaCompiler compile: sourceCode.
    compiledClasses isNil ifTrue: [
        self 
            error: 'these tests need PackageVisibleClass and aparently it could not be compiled'
    ].
    JavaVM registry registerClasses: compiledClasses.

    "Created: / 08-12-2012 / 20:31:13 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified: / 02-01-2013 / 17:02:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaCompilerTests methodsFor:'tests'!

testCompilingFromComplexStringWithComplexAssertions
    | sourceCode  compiledClass |
    self registerPackageVisibleClass.
    sourceCode := '
package stx.libjava.tests;
import org.junit.Test;
import static java.lang.String.*;
public class Wohoo {

    public int foo() {
        return new PackageVisibleClass().foo();
    }
}
'.
    compiledClass := (JavaCompiler compile: sourceCode) anElement.
    self assert: compiledClass notNil message: 'compiler should return compiled class'.
    self assert: compiledClass isJavaClass message: 'compiler should return java class'.
    self assert: compiledClass javaName = 'stx.libjava.tests.Wohoo' message: 'class name is not correct'.
    self assert: compiledClass javaPackage = 'stx.libjava.tests' message: 'java package is not correct'.
    self assert: (compiledClass lookupMethodFor: #'foo()I') notNil message: 'compiled class should have the foo method'.

    "Created: / 16-12-2012 / 15:38:56 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified: / 02-01-2013 / 16:33:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testCompilingFromString
    | sourceCode  compiledClasses |
    sourceCode := '
public class Foo {

    public int foo() {
        return 42;
    }

}
'.
    compiledClasses := (JavaCompiler compile: sourceCode) anElement.
    self assert: compiledClasses notNil
        message: 'compiler should return compiled class'.
    self assert: compiledClasses isJavaClass
        message: 'compiler should return java class'.

    "Created: / 06-12-2012 / 22:59:42 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 02-01-2013 / 17:04:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testCompilingFromStringWithImports
    | sourceCode  compiledClasses |
    sourceCode := '
package stx.libjava.tests;
import org.junit.Test;
public class Wohoo {

    public int foo() {
        return 42;
    }
}
'.
    compiledClasses := (JavaCompiler compile: sourceCode) anElement.
    self assert: compiledClasses notNil
        message: 'compiler should return compiled class'.
    self assert: compiledClasses isJavaClass
        message: 'compiler should return java class'.

    "Created: / 08-12-2012 / 20:29:05 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified: / 02-01-2013 / 17:05:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testCompilingFromStringWithPackage
    | sourceCode  compiledClasses |
    sourceCode := '
package stx.libjava.tests;
public class Wohoo {

    public int foo() {
        return 42;
    }
}
'.
    compiledClasses := (JavaCompiler compile: sourceCode) anElement.
    self assert: compiledClasses notNil
        message: 'compiler should return compiled class'.
    self assert: compiledClasses isJavaClass
        message: 'compiler should return java class'.

    "Created: / 06-12-2012 / 23:30:54 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 02-01-2013 / 17:05:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testCompilingFromStringWithPackageDependencies
    | sourceCode  compiledClasses |
    self registerPackageVisibleClass.
    sourceCode := '
package stx.libjava.tests;
public class Wohoo {

    public int foo() {
        return new PackageVisibleClass().foo();
    }
}
'.
    compiledClasses := (JavaCompiler compile: sourceCode) anElement.
    self assert: compiledClasses notNil
        message: 'compiler should return compiled class'.
    self assert: compiledClasses isJavaClass
        message: 'compiler should return java class'.

    "Created: / 08-12-2012 / 20:30:05 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified: / 02-01-2013 / 17:05:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testCompilingSyntacticallyIncorrectCode_01
    | sourceCode  compiledClasses |
    sourceCode := '
    public class Foo {

    public int foo() {
        return 
'.
    compiledClasses := (JavaCompiler compile: sourceCode) anElement.
    "ECJ can compile even this..."
    self assert: compiledClasses notEmptyOrNil.

    "Created: / 15-04-2013 / 20:56:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaCompilerTests methodsFor:'tests - incomplete / invalid code'!

test_invalid_01
    | source inst |
    source := '
    public class Foo {
        public int foo() {
            return "XXXX";
        }
    }
'.
    JavaCompiler compile: source register: true notifying: nil.

    inst := JAVA Foo new.

    self should: [ inst foo ] raise: JavaUnresolvedCompilationError

    "Created: / 19-04-2013 / 09:55:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaCompilerTests class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/tools/JavaCompilerTests.st,v 1.2 2015-03-20 13:29:52 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id::                                                                                                                        '
! !

