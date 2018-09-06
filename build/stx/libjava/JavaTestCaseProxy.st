"
 COPYRIGHT (c) 1996-2015 by Claus Gittinger

 New code and modifications done at SWING Research Group [1]:

 COPYRIGHT (c) 2010-2015 by Jan Vrany, Jan Kurs and Marcel Hlopko
                            SWING Research Group, Czech Technical University in Prague

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 [1] Code written at SWING Research Group contains a signature
     of one of the above copright owners. For exact set of such code,
     see the differences between this version and version stx:libjava
     as of 1.9.2010
"
"{ Package: 'stx:libjava' }"

"{ NameSpace: Smalltalk }"

TestCase subclass:#JavaTestCaseProxy
	instanceVariableNames:''
	classVariableNames:'TestCases'
	poolDictionaries:''
	category:'Languages-Java-Tests-Proxies'
!

JavaTestCaseProxy class instanceVariableNames:'javaClassName shouldFork'

"
 The following class instance variables are inherited by this class:

	TestCase - lastOutcomes
	TestAsserter - 
	Object - 
"
!

!JavaTestCaseProxy class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1996-2015 by Claus Gittinger

 New code and modifications done at SWING Research Group [1]:

 COPYRIGHT (c) 2010-2015 by Jan Vrany, Jan Kurs and Marcel Hlopko
                            SWING Research Group, Czech Technical University in Prague

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 [1] Code written at SWING Research Group contains a signature
     of one of the above copright owners. For exact set of such code,
     see the differences between this version and version stx:libjava
     as of 1.9.2010

"
! !

!JavaTestCaseProxy class methodsFor:'initialization'!

initialize

    TestCases := Dictionary new.

    "Created: / 01-03-2011 / 10:43:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setJavaClassName: aSymbol

    javaClassName ifNotNil:
        [self error: 'Attempting to set java class name twice'].
    javaClassName := aSymbol.

    "Created: / 01-03-2011 / 10:43:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaTestCaseProxy class methodsFor:'accessing'!

javaClass

    ^JavaVM classNamed: javaClassName

    "Created: / 01-03-2011 / 11:30:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-07-2016 / 23:50:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

javaClassName

    ^javaClassName

    "Created: / 01-03-2011 / 11:30:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

shouldFork
    ^ shouldFork ? false

    "Modified: / 13-06-2011 / 16:34:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

shouldFork:aBoolean
    shouldFork := aBoolean.
!

sunitName

    ^javaClassName

    "Created: / 10-08-2011 / 21:21:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaTestCaseProxy class methodsFor:'private'!

lastTestRunResultChanged: selector
    super lastTestRunResultChanged: selector.

    Smalltalk changed:#lastTestRunResult with:(Array with:self javaClass with:selector).
    self javaClass changed:#lastTestRunResult with:selector.

    "Created: / 27-07-2016 / 00:14:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testSelectors
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
! !

!JavaTestCaseProxy class methodsFor:'queries'!

isAbstract

    ^self == JavaTestCaseProxy or:[self superclass == JavaTestCaseProxy]

    "Created: / 21-06-2011 / 16:56:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isTestlet

    ^false

    "Created: / 21-06-2011 / 16:57:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaTestCaseProxy class methodsFor:'subclass creation'!

for: javaClass 

    self subclassResponsibility

    "Modified: / 21-06-2011 / 17:08:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

forClassNamed: name 
    "Answers a new (anonymous) testcase proxy for
     given javaClass"

    | meta  cls   |
    TestCases at: name ifPresent: [:c | ^ c ].
    meta := Metaclass new.
    meta setSuperclass: self class.
    meta instSize: self class instSize.
    cls := meta new.
    cls setSuperclass: self.
    cls flags: self flags.
    cls instSize: self instSize.
    cls setJavaClassName: name.
    cls 
        setName: (self name , ' for: (Java classForName: ' , name storeString 
                , ')') asSymbol.
    cls setCategory: #'(java test case proxies)'.
    TestCases at: name put: cls.
    ^ cls

    "Modified: / 03-03-2011 / 00:20:49 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 29-04-2011 / 10:21:39 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Created: / 21-06-2011 / 17:07:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaTestCaseProxy methodsFor:'accessing'!

javaClass

    | javaClass |

    self 
        assert: (javaClass := self class javaClass) isJavaClass
        description: 'java class does not exists'.
    ^javaClass

    "Created: / 01-03-2011 / 14:48:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"

!

timeout
    ^120"sec"

    "Modified: / 04-06-2014 / 09:49:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaTestCaseProxy methodsFor:'queries'!

shouldSkip
    ^false

    "Created: / 29-11-2012 / 12:03:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaTestCaseProxy class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaTestCaseProxy.st,v 1.6 2015-03-20 12:08:00 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !


JavaTestCaseProxy initialize!
