"
 COPYRIGHT (c) Claus Gittinger / eXept Software AG
 COPYRIGHT (c) 2015-2017 Jan Vrany
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

TestCase subclass:#PipeStreamTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression-Streams'
!

!PipeStreamTest class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) Claus Gittinger / eXept Software AG
 COPYRIGHT (c) 2015-2017 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!PipeStreamTest methodsFor:'tests'!

testPipeWriteRead
    | makeReader makeWriter count threads ok blocker |

    count := 1000.
    threads := 200.

    (OperatingSystem isMSWINDOWSlike) ifTrue:[
        "/ Sigh, when having too much threads on Windows,
        "/ this test lead to deadlock. This has to be investigated
        "/ and fixed. See
        "/ 
        "/    https://swing.fit.cvut.cz/projects/stx-jv/ticket/104
        threads := 20.
    ].
    ok := true.
    blocker := Semaphore new: 2 - threads.

    makeReader := [ :stream |
        [
            | c |
            c := 0.
            [ stream atEnd ] whileFalse:[
                stream next.
                c := c + 1.
            ].
            ok := ok and:[ count == c ].
            blocker signal.
        ].
    ].

    makeWriter := [ :stream |
        [
            [ count timesRepeat:[stream nextPut: $P] ] on: Error do:[ :ex |
                Transcript showCR: 'ERROR in writer: ',  ex description.
                ex suspendedContext fullPrintOn: Transcript.
                ok := false
            ] ensure:[ 
                stream close.
            ]
        ]                                                   
    ].

    2 to: threads do:[:i |
       | pipe rs rp ws wp |

        pipe := NonPositionableExternalStream makePipe.
        rs := pipe at:1.
        ws := pipe at:2.

        rp := (makeReader value: rs) newProcess.
        rp name: i printString , ' R ' , testSelector.
        wp := (makeWriter value: ws) newProcess.
        wp name: i printString , ' W ' , testSelector.
        rp resume.
        wp resume.
    ].

    blocker wait.
    self assert: ok.

    "Created: / 27-03-2014 / 16:21:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-12-2015 / 13:17:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-09-2016 / 03:23:36 / jv"
!

testReadCheckPipe4
    "readCheck a pipe.
     Do this and interrupt the reading thread heavily"

    | s p count nLoop|

    nLoop := 1000.

    "/ self createTestFile.

    s := PipeStream readingFrom:'sleep 5'.

    p := [
	s readWait.
	'readWait finished' printCR.
    ] forkAt:7.

    count := 0.
    [p isDead] whileFalse:[
	Delay waitForMilliseconds:5.
	p interruptWith:[count := count + 1].
    ].
    ('readWait interrupted <1p> times' expandMacrosWith:count) printCR.

    s close.

    "
     self new testReadCheckPipe4
    "

    "Modified: / 12.8.1998 / 13:42:13 / cg"
!

testReadCheckPipe5
    "readCheck a pipe.
     Do this and interrupt the reading thread heavily"

    | s p count nLoop|

    nLoop := 1000.

    "/ self createTestFile.

    s := PipeStream readingFrom:'sleep 5; echo hello'.

    p := [
	s readWait.
	'readWait finished' printCR.
    ] forkAt:7.

    count := 0.
    [p isDead] whileFalse:[
	Delay waitForMilliseconds:5.
	p interruptWith:[count := count + 1].
    ].
    ('readWait interrupted <1p> times' expandMacrosWith:count) printCR.

    s close.

    "
     self new testReadCheckPipe5
    "

    "Modified: / 12.8.1998 / 13:42:13 / cg"
!

testReadPipe6
    "read a pipe.
     Do this and interrupt the reading thread heavily"

    | s p count nLoop error |

    error := nil.
    nLoop := 1000.

    "/ self createTestFile.

    s := PipeStream readingFrom:'sleep 5'.

    p := [
	[
	    'read: ' print. s nextLine printCR.
	] on: Error do:[:ex|
	    error := ex.
	]
    ] forkAt:7.

    count := 0.
    [p isDead] whileFalse:[
	Delay waitForMilliseconds:5.
	p interruptWith:[count := count + 1].
    ].
    ('read interrupted <1p> times' expandMacrosWith:count) printCR.

    s close.

    self assert: error isNil

    "
     self new testReadPipe6
    "

    "Modified: / 12.8.1998 / 13:42:13 / cg"
!

testReadPipe7
    "read a pipe.
     Do this and interrupt the reading thread heavily"

    |s p count nLoop error |

    nLoop := 1000.

    "/ self createTestFile.

    s := PipeStream readingFrom:'sleep 5; echo hello'.

    p := [
	[
	    'read: ' print. s nextLine printCR.
	] on: Error do:[:ex|
	    error := ex.
	]
    ] forkAt:7.

    count := 0.
    [p isDead] whileFalse:[
	Delay waitForMilliseconds:5.
	p interruptWith:[count := count + 1].
    ].
    ('read interrupted <1p> times' expandMacrosWith:count) printCR.

    s close.

    self assert: error isNil

    "
     self test7
    "

    "Modified: / 12.8.1998 / 13:42:13 / cg"
!

testTTY
    "Test TTY / PTY related methods on pipes (should throw error)"

    | s |

    s := PipeStream readingFrom:'echo hello'.
    [ 
        self deny: s isTTY.
        self should: [ s getTTYAttributes ] raise: OsError.
        s nextLine
    ] ensure:[
        s close.
    ]

    "Created: / 31-05-2017 / 07:35:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-06-2017 / 21:27:13 / jv"
! !

!PipeStreamTest class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

