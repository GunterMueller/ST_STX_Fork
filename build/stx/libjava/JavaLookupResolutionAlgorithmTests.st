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

TestCase subclass:#JavaLookupResolutionAlgorithmTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Tests-Interop'
!

!JavaLookupResolutionAlgorithmTests class methodsFor:'documentation'!

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
    This testcase tests the method lookup algorithm used to lookup
    Java methods when calling Java from Smalltalk or vice versa.

    Does not test proxy generation.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!JavaLookupResolutionAlgorithmTests methodsFor:'running'!

testLookup
    |lo o match ilc|

    lo := JavaLookup instance.
    o := (Java classForName:('java.lang.Object')) new.
    ilc := nil.
    match := lo 
                lookupMethodForSelector:#toString
                directedTo:o class
                for:o
                withArguments:nil
                from:thisContext
                ilc: ilc.
    self assert: match body class = ProxyMethodJavaMethodInvocationNode.
    self assert: match body method descriptor name = #toString.
    self assert: match body method descriptor parameters isEmpty.
    self assert: match body method descriptor return javaClassName =  #'java/lang/String'.

    "Created: / 30-08-2011 / 21:23:56 / Jan Kurs <kursjan@fit.cvut.cz>"
    "Modified: / 30-12-2011 / 10:44:48 / kursjan <kursjan@fit.cvut.cz>"
!

testLookup2
    |lo o match|

    lo := JavaLookup instance.
    o := (Java classForName:('java.lang.Object')) new.
    match := lo 
                lookupMethodForSelector:#hashCode
                directedTo:o class
                for:o
                withArguments:nil
                from:thisContext
                ilc: nil.
    self assert: match body class = ProxyMethodJavaMethodInvocationNode.
    self assert: match body method descriptor name = #hashCode.
    self assert: match body method descriptor parameters isEmpty.
    self assert: match body method descriptor return javaClassName =  #int.

    "Created: / 30-08-2011 / 21:54:53 / Jan Kurs <kursjan@fit.cvut.cz>"
    "Modified: / 30-12-2011 / 10:46:34 / kursjan <kursjan@fit.cvut.cz>"
!

testLookup3
    |lo o match |

    lo := JavaLookup instance.
    o := (Java classForName:('java.lang.Object')) new.
    match := lo 
                lookupMethodForSelector:#wait
                directedTo:o class
                for:o
                withArguments:nil
                from:thisContext
                ilc: nil.

    self assert: match body class = ProxyMethodJavaMethodInvocationNode.
    self assert: match body method descriptor name = #wait.
    self assert: match body method descriptor parameters isEmpty.
    self assert: match body method descriptor return javaClassName =  #void.

    "Created: / 30-08-2011 / 21:55:36 / Jan Kurs <kursjan@fit.cvut.cz>"
    "Modified: / 30-12-2011 / 10:47:49 / kursjan <kursjan@fit.cvut.cz>"
!

testLookup4
    |lo o match|

    lo := JavaLookup instance.
    o := (Java classForName:('java.lang.Object')) new.
    match := lo 
                lookupMethodForSelector:#wait:
                directedTo:o class
                for:o
                withArguments: (Array with: 1)
                from:thisContext
                ilc: nil.

    self assert: match body class = ProxyMethodBlockInvocationNode. "/ Recompilation fallback

    "Created: / 30-08-2011 / 21:57:59 / Jan Kurs <kursjan@fit.cvut.cz>"
    "Modified: / 30-12-2011 / 10:49:09 / kursjan <kursjan@fit.cvut.cz>"
    "Modified: / 12-05-2012 / 21:34:05 / Jan Kurs (kursjan@fit.cvut.cz)"
!

testLookupException
    |lo o match|

    lo := JavaLookup instance.
    o := (Java classForName:('java.lang.Object')) new.
    match := lo 
                lookupMethodForSelector:#foo:
                directedTo:o class
                for:o
                withArguments:nil
                from:thisContext
                ilc: nil.
    self assert:match isNil.

    "Created: / 30-08-2011 / 22:10:50 / Jan Kurs <kursjan@fit.cvut.cz>"
    "Modified: / 30-12-2011 / 10:50:03 / kursjan <kursjan@fit.cvut.cz>"
! !

!JavaLookupResolutionAlgorithmTests class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaLookupResolutionAlgorithmTests.st,v 1.5 2015-03-20 12:08:00 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !

