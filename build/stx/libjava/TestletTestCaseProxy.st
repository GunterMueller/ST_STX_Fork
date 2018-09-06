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

JavaTestCaseProxy subclass:#TestletTestCaseProxy
	instanceVariableNames:'harness'
	classVariableNames:'TestCases'
	poolDictionaries:''
	category:'Languages-Java-Tests-Proxies'
!

!TestletTestCaseProxy class methodsFor:'documentation'!

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

!TestletTestCaseProxy class methodsFor:'accessing'!

lookupHierarchyRoot
    ^ TestletTestCaseProxy

    "Created: / 01-03-2011 / 11:41:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-03-2011 / 14:54:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 29-04-2011 / 10:25:26 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

selector: aSymbol

    ^super selector: aSymbol

    "Created: / 01-03-2011 / 11:55:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TestletTestCaseProxy class methodsFor:'private'!

testSelectors
    "testlet always has only one test method, but maybe for the future.."

    ^ #( #'test(Lgnu/testlet/TestHarness;)V' ).

    "Created: / 01-03-2011 / 10:49:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-03-2011 / 00:34:39 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 29-05-2011 / 22:54:06 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 09-08-2011 / 16:31:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TestletTestCaseProxy class methodsFor:'queries'!

isTestlet
	^ true

! !

!TestletTestCaseProxy class methodsFor:'subclass creation'!

for: javaClass 
    "Answers a new (anonymous) testcase proxy for
     given javaClass"

    self assert: javaClass isJavaClass description: 'Not a java class'.
    self assert: javaClass isTestletLike
        description: 'Not a testcase-like class'.
    ^self forClassNamed: javaClass binaryName

    "Created: / 01-03-2011 / 10:30:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-03-2011 / 00:20:49 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 29-04-2011 / 10:21:39 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 08-10-2013 / 22:28:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TestletTestCaseProxy methodsFor:'accessing'!

nameForHDTestReport

    ^(self class javaClassName copyReplaceAll:$/ with: $.) copyTo: (self class javaClassName lastIndexOf: $/) - 1.

    "Created: / 01-04-2011 / 16:10:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"

!

selectorForHDTestReport

    ^self class javaClassName copyFrom: 
		(self class javaClassName lastIndexOf: $/) + 1



! !

!TestletTestCaseProxy methodsFor:'error handling'!

doesNotUnderstand: msg

    "Here, we have to emulate stx.libjava.tests.TestHarness.Proxy interface..."
    | sel |

    sel  := msg selector.
    (sel includes:$() ifTrue:[
        sel == #'check(Z)V' ifTrue:[
            ^self assert: msg arg1 == 1 description: ('Assertion failed (checkpoint: %1)' bindWith: self checkPointName).
        ].
        sel == #'message(Ljava/lang/String;I)V' ifTrue:[
            | text type |
            text := Java as_ST_String: msg arg1.
            type := msg arguments at: 2.
            ^self message: text type: type.                
        ].
        sel == #'directory(I)Ljava/lang/String;' ifTrue:[
            ^Java as_String: (self directory: msg arg1) asString.
        ].
    ].
    ^super doesNotUnderstand: msg

    "Created: / 31-05-2011 / 16:30:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TestletTestCaseProxy methodsFor:'private'!

checkPointName

    | jstring |
    jstring := harness instVarNamed: #checkPoint.
    ^jstring notNil ifTrue:[
        Java as_ST_String: jstring
    ] ifFalse:[
        '<no checkpoint set>'
    ]

    "Modified: / 29-04-2011 / 10:52:53 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Created: / 09-08-2011 / 12:16:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

createHarness

    harness := (Java classForName: 'stx.libjava.tests.TestHarness') new.
    harness instVarNamed: #proxy put: self.

    "Modified: / 29-04-2011 / 10:52:53 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Created: / 09-08-2011 / 11:29:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

performTest

    <resource: #skipInDebuggersWalkBack>

    self createHarness.
    "/ JavaVM unimplementedNativeMethodSignal is Signal, not exception.
    "/ Therefore it MUST be caught here!!!!!!                                        
    [
        self javaClass new 
            perform: 'test(Lgnu/testlet/TestHarness;)V' sunitAsSymbol
            with: harness.
    ] on: JavaVM unimplementedNativeMethodSignal do:[:ex|
        ex class sunitSignalWith: ex description
    ]

    "Created: / 01-03-2011 / 14:50:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-12-2011 / 21:15:54 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified (comment): / 12-02-2014 / 12:33:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TestletTestCaseProxy methodsFor:'private - Proxy interface'!

directory: type
    "
        public static final int DIR_TMP = 1;
        public static final int DIR_SRC = 2;
        public static final int DIR_RES = 3;
        public static final int DIR_BLD = 4;
    "

    type == 1 ifTrue:[
        ^Filename newTemporaryDirectory.  
    ] ifFalse:[type == 2 ifTrue:[
"/        ^JavaTestsResource classpathForMauve anyOne asFilename directory / 'bin'
        ^JavaTestsResource classpathForMauve anyOne asFilename directory / 'src'
    ] ifFalse:[type == 3 ifTrue:[
        ^(JavaTestsResource classpathForMauve anyOne asFilename directory / 'src') asString , Filename separator
    ] ifFalse:[type == 4 ifTrue:[
        ^JavaTestsResource classpathForMauve anyOne asFilename
    ] ifFalse:[
        ^self error:'Unknown type code'
    ]]]].

    "Created: / 10-08-2011 / 15:03:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-11-2013 / 09:55:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

message:msg type: type
    "
        public static final int MSG_DBG = 1;
        public static final int MSG_INF = 2;
        public static final int MSG_ERR = 3;
    "
    type == 1 ifTrue:[Transcript showCR:' Testlet [DBG]: '] ifFalse:[
    type == 2 ifTrue:[Transcript showCR:' Testlet [INF]: '] ifFalse:[
    type == 3 ifTrue:[Transcript showCR:' Testlet [ERR]: '] ifFalse:[
                      Transcript showCR:' Testlet [???]: ']]].
    Transcript showCR: msg.
    type == 3 ifTrue:[self error: msg].

    "Created: / 10-08-2011 / 15:06:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TestletTestCaseProxy class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/TestletTestCaseProxy.st,v 1.6 2015-03-20 12:08:01 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !

