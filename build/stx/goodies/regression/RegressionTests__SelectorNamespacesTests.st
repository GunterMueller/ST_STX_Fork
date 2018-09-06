"
 COPYRIGHT (c) 2006 by eXept Software AG
 COPYRIGHT (c) 2016-2017 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#SelectorNamespacesTests
	instanceVariableNames:'ambiguousMessageSelector'
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression'
!

!SelectorNamespacesTests class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 by eXept Software AG
 COPYRIGHT (c) 2016-2017 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!SelectorNamespacesTests methodsFor:'error handling'!

ambiguousMessage: aMessage

    ambiguousMessageSelector := aMessage selector

    "Created: / 19-08-2010 / 22:29:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SelectorNamespacesTests methodsFor:'initialization & release'!

setUp

    (NameSpace name: #TestNS3) import: (NameSpace name: #TestNS2).

    (NameSpace name: #TestNS4) import: (NameSpace name: #TestNS1).
    (NameSpace name: #TestNS4) import: (NameSpace name: #TestNS2).

    ObjectMemory flushCaches

    "Modified: / 21-07-2010 / 17:12:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

tearDown

    (NameSpace name: #TestNS1) setImports: nil.
    (NameSpace name: #TestNS2) setImports: nil.
    (NameSpace name: #TestNS3) setImports: nil.
    (NameSpace name: #TestNS4) setImports: nil.

    "Created: / 21-07-2010 / 16:02:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SelectorNamespacesTests methodsFor:'methods'!

bar

    <namespace: #TestNS1 >

    ^self foo

    "Created: / 21-07-2010 / 15:59:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

foo
    <namespace: #TestNS1 >

    ^#foo_NS1

    "Created: / 01-07-2010 / 18:09:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-07-2010 / 15:45:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

foo
    <namespace: #TestNS2 >

    ^#foo_NS2

    "Created: / 21-07-2010 / 15:47:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

baz

    <namespace: TestNS3>

    ^self foo

    "Created: / 21-07-2010 / 16:00:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

qux

    <namespace: TestNS4>

    ^self foo

    "Created: / 21-07-2010 / 16:02:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

foo

    ^#foo

    "Created: / 01-07-2010 / 18:09:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-07-2010 / 20:46:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SelectorNamespacesTests methodsFor:'tests'!

test_01

    self assert: self foo == #foo.
    self assert: self bar == #foo_NS1

    "Created: / 01-07-2010 / 18:47:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-07-2010 / 15:59:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_02

    "Basic imports"

    self assert: 
        ((NameSpace name: #TestNS3) imports includes: (NameSpace name: #TestNS2)).
    self assert: self baz == #foo_NS2.

    "Created: / 21-07-2010 / 16:05:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-07-2010 / 17:19:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_03

    "Ambiguous send"
    "Disable, I need a kind of unwind-protect on a C level. 
     Is that possible?"
    
    self shouldnt:[self qux] raise: AmbiguousMessage.
    self assert: ambiguousMessageSelector == #foo.

    "Created: / 19-08-2010 / 22:28:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SelectorNamespacesTests class methodsFor:'documentation'!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '§ Id: SelectorNamespacesTests.st 10567 2010-08-19 20:39:34Z vranyj1  §'
! !

