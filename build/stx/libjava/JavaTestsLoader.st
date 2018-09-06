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

Object subclass:#JavaTestsLoader
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Tests'
!

!JavaTestsLoader class methodsFor:'documentation'!

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

!JavaTestsLoader class methodsFor:'accessing'!

buildSuiteForLibjava

    ^(self buildSuiteFrom: (self loadLibjava)) name: 'stx:libjava Test Suite'

    "
        JavaTestsLoader buildSuiteForLibjava
    "

    "Created: / 21-06-2011 / 17:39:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

buildSuiteForMauve

    ^(self buildSuiteFrom: (self loadMauve)) name: 'Mauve Test Suite'

    "
        JavaTestsLoader buildSuiteForMauve
    "

    "Created: / 21-06-2011 / 17:40:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

buildSuiteForMauveToFix

    ^self buildSuiteFrom: 
        (self loadMauveToFix)

    "
        JavaTestsLoader buildSuiteForMauveToFix
    "

    "Created: / 21-06-2011 / 17:40:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaTestsLoader class methodsFor:'loading'!

load
    JavaTestsResource build.
    self loadIn:JavaTestsResource classpath

    "Created: / 07-05-2011 / 18:43:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

load:testdir 
    |base dirs|

    base := ((Smalltalk getPackageDirectoryForPackage: #stx:libjava) / 'test' / testdir) 
                pathName.
    dirs := JavaTestsResource classpath 
                select:[:each | each startsWith:base ].
    self loadIn:dirs.

    "
        JavaTestsLoader load: 'libjava'"

    "Created: / 07-05-2011 / 18:40:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-01-2013 / 23:27:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaTestsLoader class methodsFor:'loading - test suites'!

loadLibjava
    | cp |
    JavaTestsResource new setUp.
    cp := JavaTestsResource classpathForLibjava.
    ^ self loadIn: cp

    "Created: / 21-06-2011 / 17:35:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 03-11-2011 / 10:17:12 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

loadMauve
    |cp|

    JavaTestsResource new setUp.
    cp := JavaTestsResource classpathForMauve.
    ^self loadIn: cp

    "Created: / 11-06-2011 / 16:03:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

loadMauve: pattern
    |cp|

    JavaTestsResource new setUp.
    cp := JavaTestsResource classpathForMauve.
    ^self loadIn: cp matching: pattern.

    "
        JavaTestsLoader loadMauve:'gnu.testlet.java.lang.String.*'
    "

    "Created: / 12-06-2011 / 21:56:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 20-06-2011 / 19:00:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

loadMauveToFix
    |cp|

    JavaTestsResource new setUp.
    cp := JavaTestsResource classpathForMauve.
    self 
        loadIn: cp matching:'gnu.testlet.java.lang.*';
        loadIn: cp matching:'gnu.testlet.java.lang.reflect.*';
        loadIn: cp matching:'gnu.testlet.java.util.*';
        loadIn: cp matching:'gnu.testlet.java.io.*';
        loadIn: cp matching:'gnu.testlet.java.nio.*'.

    "
        JavaTestsLoader loadMauveToFix    
    "

    "Created: / 11-06-2011 / 16:07:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaTestsLoader class methodsFor:'private'!

buildSuiteFrom: classes

    | javaTestCases suite |

    javaTestCases := OrderedCollection new.
    suite := TestSuite new.

    classes do:
        [:jclass|
        ((self ignoredTestCaseNames includes: jclass binaryName) not
                and:[jclass isTestCaseLike])
                    ifTrue:
                        [ | tc |
                        tc := jclass asTestCase.
                                                (tc askFor:#isTestlet) ifTrue:[
                                                        tc shouldFork: true.
                                                ].
                        tc isAbstract ifFalse:[javaTestCases add:tc ]]].

    javaTestCases sort:[:a :b| a javaClassName < b javaClassName  ].

    javaTestCases do:
                [:each | 
                suite addTests:each buildSuite tests ].

    ^suite

    "Modified: / 08-10-2013 / 22:48:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

ignoredTestCaseNames
    "Return an array of java slashed class names to be ignored when
     building testsuite"

    ^#(
        #'stx/libjava/tests/JUnit3Tests'
        #'stx/libjava/tests/JUnit4Tests'

        "Fails because of broken finalization, ignore for now.."
        #'gnu/testlet/java/nio/channels/FileChannel/manyopen'
    )

    "Created: / 23-07-2012 / 20:06:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

loadIn: directories

    ^self loadIn: directories matching: '*'

    "Created: / 11-06-2011 / 16:05:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

loadIn: directories matching: pattern 
    | classes |

    JavaInitializedResource new setUp.
    JavaLibrariesResource new setUp.
    JavaTestsResource new setUp.
    classes := OrderedCollection new.
    directories do: [
        :each | 
        each asFilename exists ifTrue: [
            classes addAll: (JavaVM loadClassesIn: each matching: pattern)
        ]
    ].
    ^ classes

    "Created: / 11-06-2011 / 16:05:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 20-06-2011 / 19:02:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaTestsLoader class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaTestsLoader.st,v 1.6 2015-03-20 12:08:00 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !

