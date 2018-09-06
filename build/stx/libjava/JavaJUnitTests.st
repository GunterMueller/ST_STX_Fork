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

TestCase subclass:#JavaJUnitTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Tests-Libraries'
!

!JavaJUnitTests class methodsFor:'documentation'!

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

!JavaJUnitTests class methodsFor:'resource'!

resources

    ^ Array 
        with: JavaInitializedResource 
        with: JavaLibrariesResource
        with: JavaTestsResource

    "Created: / 28-02-2011 / 15:28:52 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 08-04-2011 / 17:03:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaJUnitTests methodsFor:'running'!

setUp

    super setUp.
    Java addToClassPath: '/usr/share/java/junit4.jar'.

    "Created: / 16-03-2011 / 15:28:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaJUnitTests methodsFor:'tests - jUnit 3.x'!

test_junit3x_01
    | runner  junit3testcase  result |

    "/ Java effectiveClassPath
    runner := Java classForName: 'org.junit.runner.JUnitCore'.
    self assert: runner notNil.
    junit3testcase := Java classForName: 'stx.libjava.tests.JUnit3Tests'.
    self assert: junit3testcase notNil.
     "signature: Result runClass(java.lang.Class[] classes)"
    result := runner 
                perform: #'runClasses([Ljava/lang/Class;)Lorg/junit/runner/Result;'
                with: (Array with: (JavaVM javaClassObjectForClass: junit3testcase)).
     "
     result getFailures
    "
    self assert: result getRunCount = 4.
    self assert: result getFailureCount = 2.
    self assert: result wasSuccessful not.

    "Created: / 06-02-2011 / 12:14:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-04-2011 / 23:02:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 09-10-2011 / 16:56:54 / m"
! !

!JavaJUnitTests methodsFor:'tests - jUnit 4.x'!

test_junit4x_01
    | runner  junit4testcase  result |

    "/ Java effectiveClassPath
    runner := Java classForName: 'org.junit.runner.JUnitCore'.
    self assert: runner notNil.
    junit4testcase := Java classForName: 'stx.libjava.tests.JUnit4Tests'.
    self assert: junit4testcase notNil.
     "signature: Result runClass(java.lang.Class[] classes)"
    result := runner 
                perform: #'runClasses([Ljava/lang/Class;)Lorg/junit/runner/Result;'
                with: (Array with: (JavaVM javaClassObjectForClass: junit4testcase)).
     "
     result getFailures
    "
    self assert: result getRunCount = 4.
    self assert: result getFailureCount = 1.
    self assert: result wasSuccessful not.

    "Created: / 06-02-2011 / 12:14:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-02-2011 / 17:27:16 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 09-10-2011 / 16:57:01 / m"
    "Modified: / 03-04-2016 / 09:38:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaJUnitTests class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaJUnitTests.st,v 1.6 2015-03-20 12:08:00 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !

