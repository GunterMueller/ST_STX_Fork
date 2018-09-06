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

JavaTestCaseProxy subclass:#JUnitTestCaseProxy
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Tests-Proxies'
!

!JUnitTestCaseProxy class methodsFor:'documentation'!

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

!JUnitTestCaseProxy class methodsFor:'initialization'!

initialize

    TestCases := Dictionary new.

    "Created: / 01-03-2011 / 10:43:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JUnitTestCaseProxy class methodsFor:'accessing'!

lookupHierarchyRoot

    ^JUnitTestCaseProxy

    "Created: / 01-03-2011 / 11:41:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-03-2011 / 14:54:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JUnitTestCaseProxy class methodsFor:'private'!

isTestSelector: selector
    | javaClass |

    self == JUnitTestCaseProxy ifTrue:[ ^ #() ].
    javaClass := self javaClass.
    (javaClass includesBehavior:(JavaVM classForName:'junit.framework.TestCase')) 
        ifTrue:[ ^ selector startsWith:'test' ].

    self testSelectors includes: selector.
    "
        (JUnitTestCase for: JAVA::stx::libjava::tests::junit::JUnit3Tests)
            testSelectors"

    "Created: / 17-04-2012 / 22:48:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testSelectors
    | javaClass testMethods ignoredMethods |

    self == JUnitTestCaseProxy ifTrue:[ ^ #() ].
    javaClass := self javaClass.

    "/ Old JUnit 3.x style...
    (javaClass includesBehavior:(JavaVM classForName:'junit.framework.TestCase')) ifTrue:[ 
        ^ javaClass selectors select:[:sel | sel startsWith:'test' ]. 
    ].

    "/ New JUnit 4.x style
    testMethods := (javaClass selectMethodsAnnotatedWith: 'Lorg/junit/Test;' "Has to be type name!!!!!!").
    ignoredMethods := (javaClass selectMethodsAnnotatedWith: 'Lorg/junit/Ignore;' "Has to be type name!!!!!!").

    ^ ( testMethods \ ignoredMethods ) collect:[:m | m selector ].


    "
        (JUnitTestCase for: JAVA::stx::libjava::tests::junit::JUnit3Tests)
            testSelectors"

    "Created: / 01-03-2011 / 10:49:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-03-2011 / 00:34:39 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 14-11-2013 / 11:59:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JUnitTestCaseProxy class methodsFor:'subclass creation'!

for:javaClass 
    "Answers a new (anonymous) testcase proxy for
     given javaClass"

    self assert:javaClass isJavaClass description:'Not a java class'.
    self assert:javaClass isTestCaseLike
        description:'Not a testcase-like class'.    
    ^self forClassNamed: javaClass binaryName

    "Created: / 01-03-2011 / 10:30:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-03-2011 / 00:20:49 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 08-10-2013 / 22:28:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JUnitTestCaseProxy methodsFor:'accessing'!

nameForHDTestReport

    ^self class javaClassName copyReplaceAll:$/ with: $.

    "Created: / 01-04-2011 / 16:10:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"

!

selectorForHDTestReport

	^testSelector upTo:$(

!

shouldSkip
    "Returns true, if this testcase should be skipped when a testsuite is run.
     This inly a hint, a test runner is not obliged to respect return value.

     Currently, the only user is stx/goodies/builder/reports"

    | method |
    method := self javaClass lookupMethodFor: testSelector.
    ^method notNil and:[(method annotations runtimeVisible includesKey: 'Lorg/junit/Ignore;')].

    "Created: / 03-12-2012 / 22:02:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JUnitTestCaseProxy methodsFor:'private'!

performTest

    <resource: #skipInDebuggersWalkBack>

    | assertions assumptions |

    assertions := SignalSet 
                    with: (Java classForName:'java.lang.AssertionError')
                    with: (Java classForName:'junit.framework.AssertionFailedError').
    assumptions := (Java classForName:'org.junit.internal.AssumptionViolatedException').

    "/ JavaVM unimplementedNativeMethodSignal is Signal, not exception.
    "/ Therefore it MUST be caught here!!!!!!                                        
    [
        "This is the tricky part. We have to auto-magically convert
         JUnit's AssertionFailedError to sUnits TestFailure's. 
         Also, JUnit assumption violations are converted to test skips."
        [
            self javaClass new perform: testSelector sunitAsSymbol
        ] on: assumptions do:[:ex |
            TestResult skipped sunitSignalWith: ex getMessage    
        ] on: assertions do: [:ex |
            TestResult failure sunitSignalWith: ex getMessage
        ]
    ] on: JavaVM unimplementedNativeMethodSignal do:[:ex|
        ex class sunitSignalWith: ex description
    ]

    "Created: / 01-03-2011 / 14:50:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-04-2016 / 10:23:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JUnitTestCaseProxy class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JUnitTestCaseProxy.st,v 1.6 2015-03-20 12:07:59 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !


JUnitTestCaseProxy initialize!
