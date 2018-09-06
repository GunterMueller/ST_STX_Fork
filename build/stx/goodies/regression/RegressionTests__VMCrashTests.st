"
 COPYRIGHT (c) Claus Gittinger / eXept Software AG
 COPYRIGHT (c) 2016-2018 Jan Vrany
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

VMCrashTestCase subclass:#VMCrashTests
	instanceVariableNames:'x y'
	classVariableNames:'SkipIssue200'
	poolDictionaries:''
	category:'tests-Regression-RuntimeSystem'
!

!VMCrashTests class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) Claus Gittinger / eXept Software AG
 COPYRIGHT (c) 2016-2018 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!VMCrashTests class methodsFor:'initialization'!

initialize
    "Invoked at system start or when the class is dynamically loaded."

    "/ Following hack is to make tests for Issue #200 run on
    "/ JV's machine but noone else.

    SkipIssue200 := (#('sao' 'win7') includes: OperatingSystem getHostName) not

    "
    SkipIssue200 := true.
    SkipIssue200 := false.
    "

    "Modified (comment): / 23-05-2018 / 14:46:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

skipIssue200
    ^ SkipIssue200

    "
    SkipIssue200 := true.
    SkipIssue200 := false.
    "

    "Created: / 23-05-2018 / 14:45:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

skipIssue200: aBoolean
    SkipIssue200 := aBoolean

    "
    SkipIssue200 := true.
    SkipIssue200 := false.
    "

    "Created: / 23-05-2018 / 14:45:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VMCrashTests methodsFor:'private'!

childOf: aSimpleView withUUID: aUUIDOrString
    aSimpleView automationUUID asString = aUUIDOrString asString ifTrue:[ ^ aSimpleView ].
    aSimpleView subViews do:[:each | 
        | found |

        found := self childOf: each withUUID: aUUIDOrString.
        found notNil ifTrue:[ ^ found ].  
    ].
    ^ nil

    "Created: / 21-12-2017 / 15:50:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VMCrashTests methodsFor:'tests - GC'!

iter_java_initialize
    <spawn: true>

    1 to: 100 do:[:i |
	Stdout nextPutLine: 'Pass '  , i printString.
	Java release: JavaRelease JDK7.
	Java initialize.
	JavaVM initializeVM.
	Java flushAllJavaResources.
	Stdout nextPutLine: 'Full GC...'.
	Smalltalk garbageCollect.
	Stdout nextPutLine: 'Pass '  , i printString , '...OK'.
    ].

    "Created: / 08-09-2014 / 12:33:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_issue_171_crash_in_Smalltalk_keys
    <timeout: 120> "2min"
    <spawn: true>

    "
    Commit a68e1e09f73a/stx:libbasic caused following code to crash the VM.
    "

    Smalltalk keys.

    "Created: / 09-08-2017 / 10:00:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_issue_182_crash_when_java_is_flushed
    <timeout: 300> "300min"
    <spawn: true>

    "
    If some code is still running when Java is flushed the
    VM crashed.
    "

    | blocker iters |

    Smalltalk loadPackage:'stx:libjava/tests'.

    blocker := Semaphore new.
    JavaVM reboot.

    [
        [
            | issue182 |

            issue182 := JAVA stx libjava tests mocks Issue182 new.
            issue182 loopFor: 15.
        ] on: JavaClassFormatError do:[
            "/ This is expected
        ] on: Error do:[:ex |
            ex suspendedContext fullPrintAllOn: Stdout.
        ].
        blocker signal.
    ] fork.
    Delay waitForSeconds: 5.
    JAVA stx libjava tests mocks Issue182 constantPool atAllPut: nil.
    blocker wait.

    "Created: / 19-10-2017 / 19:55:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-10-2017 / 11:51:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_issue_64_vm_crashes_in_fclose
    "
    Quickly opening and closing files for long enough used to kill the
    VM.

    This testcase keeps opening and closing files for 10 minutes. Just a
    stress-test.
    "

    <spawn: true>
    <timeout: 660> "11min"

    | timeout deadline iterStart iterStop directory files oldSpaceSizeLimit i |

    "/ See https://swing.fit.cvut.cz/projects/stx-jv/ticket/64
    self skipIf: OperatingSystem isMSWINDOWSlike description: 'Temporarily skipped because of issue #64'.


    timeout := self timeout.
    deadline := OperatingSystem getMillisecondTime + ((timeout - 60"extra min to cover variance") * 1000).
    iterStart := iterStop := 0.
    i := 0.
    directory := Smalltalk getPackageDirectoryForPackage: #'stx:goodies'.

    oldSpaceSizeLimit := ObjectMemory oldSpaceUsed + (128"MB"*1024*1024).

    [ OperatingSystem getMillisecondTime < (deadline - (iterStop - iterStart)) ] whileTrue:[
	iterStart := OperatingSystem getMillisecondTime.

	i := i + 1.
	Stdout nextPutLine: 'Pass '  , i printString.
	files := directory recursiveDirectoryContentsAsFilenames select:[:each | each isRegularFile ].
	files := files select: [ :e | e suffix = 'st' ].
	files collect:[ :e | (FileStream fileNamed: e) contents asString ].
	Stdout nextPutLine: 'Pass '  , i printString , '...OK'.
	(oldSpaceSizeLimit notNil and:[ ObjectMemory oldSpaceUsed > oldSpaceSizeLimit ]) ifTrue:[
	    Stdout nextPutLine: 'GC'.
	    files := nil.
	    ObjectMemory compressingGarbageCollect.
	    oldSpaceSizeLimit := ObjectMemory oldSpaceUsed + (128"MB"*1024*1024).
	    Stdout nextPutLine: 'GC...OK '.
	].
	iterStop := OperatingSystem getMillisecondTime.
    ].

    "Created: / 04-09-2016 / 03:16:19 / jv"
    "Modified: / 27-02-2017 / 12:10:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_java_initialize
    "
    Running `JavaVM boot` for long enough used to kill the
    VM due to problems in memory managements.

    This testcase runs for 10 minutes a test in separate VM
    that 100 times boots and flushes the VM.
    "

    <spawn: false>
    <timeout: 660> "11min"

    | timeout deadline iterStart iterStop |

    timeout := self timeout.
    deadline := OperatingSystem getMillisecondTime + ((timeout - 60"extra min to cover variance") * 1000).
    iterStart := iterStop := 0.
    [ OperatingSystem getMillisecondTime < (deadline - (iterStop - iterStart)) ] whileTrue:[
	iterStart := OperatingSystem getMillisecondTime.
	(self class selector: #iter_java_initialize) runCase.
	iterStop := OperatingSystem getMillisecondTime.
    ].

    "Created: / 08-09-2014 / 12:14:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_newspace_overflow

    <timeout: 120> "2min"
    <spawn: true>

    | newSize newLimit |

    newSize := ObjectMemory newSpaceSize.
    newLimit := (newSize * 0.9) rounded.
    "/ Allocate some garbage to fill in new space...
    [ ObjectMemory newSpaceUsed < newLimit ] whileTrue:[
	| a |

	a := Array new: 100.
    ].
    "/ Now, allocate some really huge object
    [
	String new: 300 * 1024 * 1024"300MB"
    ] on: AllocationFailure do:[:ex |
	"/ Do nothing, allocation failure is valid error
    ].

    "Created: / 05-09-2014 / 19:44:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-09-2014 / 18:50:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 24-06-2016 / 00:41:29 / jv"
!

test_newspace_resize

    <timeout: 120> "2min"
    <spawn: true>

    | newSize newLimit holder |

    newSize := ObjectMemory newSpaceSize.
    [
    ObjectMemory scavenge.
    newLimit := (ObjectMemory newSpaceSize * 0.9) rounded.

    "/ Fill in new space so it's 90% full, no garbage.
    holder := OrderedCollection new.
    [ ObjectMemory newSpaceUsed < newLimit ] whileTrue:[
	holder add: (Array new: 100).
    ].
    "/ Grow the new space to two times the current size.
    ObjectMemory newSpaceSize: 2 * newSize.
    self assert: (ObjectMemory newSpaceSize >= (2 * newSize)).
    self assert: (ObjectMemory newSpaceUsed / ObjectMemory newSpaceSize) < 0.5.

    "/ Fill in new space so it's 90% full, no garbage.
    newLimit := (ObjectMemory newSpaceSize * 0.9) rounded.
    [ ObjectMemory newSpaceUsed < newLimit ] whileTrue:[
	holder add: (Array new: 100).
    ].
    "/ Increase old space to make sure there's enough
    "/ old space to tenure objects to. See
    "/
    "/ ObjectMemory >> newSpaceSize:
    "/
    ObjectMemory moreOldSpace: newSize * 2.
    ObjectMemory newSpaceSize: newSize.
    self assert: (ObjectMemory newSpaceSize < (newSize + 4096"page size as tolerance for page aligning")).

    ] ensure:[
	ObjectMemory newSpaceSize: newSize.
    ].

    "Created: / 21-09-2017 / 23:16:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-10-2017 / 22:28:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 08-10-2017 / 23:51:30 / jv"
! !

!VMCrashTests methodsFor:'tests - context'!

callResend1
    x == 1 ifTrue:[
        x := 2.
        thisContext resend.
        ^ self.
    ].
    x == 2 ifTrue:[
        x := 3.
        y := thisContext.
        thisContext unwindThenDo:[ AbortOperationRequest raise ]
    ].
    self assert:false.

    "Created: / 17-11-2017 / 13:59:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

callUnwindThenRestart1
    x == 1 ifTrue:[
        x := 2.
        thisContext unwindAndRestart.
    ] ifFalse:[
        x := 3.
    ].

    "Created: / 14-11-2017 / 20:58:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

callUnwindThenRestart2a
    [
        self callUnwindThenRestart2b
    ] ensure:[
        y := 10
    ].

    "Created: / 14-11-2017 / 21:10:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

callUnwindThenRestart2b
    x == 1 ifTrue:[
        x := 2.
        thisContext sender sender unwindAndRestart.
    ] ifFalse:[
        x := 3.
    ].

    "Created: / 14-11-2017 / 21:10:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

callUnwindThenRestart3
    x == 1 ifTrue:[
        x := 2.
        thisContext unwindAndRestart.
        ^ self.
    ].
    x == 2 ifTrue:[
        x := 3.
        thisContext unwindThenDo:[  AbortOperationRequest raise  ]
    ].
    self assert: false.

    "Created: / 14-11-2017 / 21:21:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testResend1
    <spawn: true>

    | aborted |

    x := 1.
    y := 1.
    aborted := false.
    [
        self callResend1.
    ] on:AbortOperationRequest do:[:ex | aborted := true. ].
    self assert:aborted.
    self assert:x == 3.
    self assert:y method == (self class >> #callResend1)

    "
     VMCrashTests new testResend1
    "

    "Created: / 17-11-2017 / 13:58:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-11-2017 / 15:17:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testUnwindThenRestart1
    <spawn: true>

    x := 1.
    y := 1.
    self callUnwindThenRestart1.
    self assert: x == 3.
    self assert: y == 1.

    "
    VMCrashTests new testUnwindThenRestart1
    "

    "Created: / 14-11-2017 / 20:58:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testUnwindThenRestart2
    <spawn: true>

    x := 1.
    y := 1.
    self callUnwindThenRestart2a.
    self assert: x == 3.
    self assert: y == 10.

    "
    VMCrashTests new testUnwindThenRestart1
    "

    "Created: / 14-11-2017 / 21:09:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testUnwindThenRestart3
    | aborted |

    <spawn: true>

    x := 1.
    y := 1.
    aborted := false.
    [
        self callUnwindThenRestart3.
    ] on: AbortOperationRequest do:[:ex |
        aborted := true.
    ].
    self assert: aborted.
    self assert: x == 3.
    self assert: y == 1.

    "
    VMCrashTests new testUnwindThenRestart3
    "

    "Created: / 14-11-2017 / 21:20:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-11-2017 / 13:56:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VMCrashTests methodsFor:'tests - misc'!

endlessB
    | b |

    b := [ b value ].
    b value

    "Created: / 18-12-2017 / 09:32:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

endlessB:a1
    | b |

    b := [:x1 | b value:x1 ].
    b value:a1

    "Created: / 18-12-2017 / 21:03:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

endlessB:a1 _:a2
    | b |

    b := [ :x1 :x2 | b value:x1 value:x2].
    b value:a1 value:a2

    "Created: / 18-12-2017 / 21:03:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

endlessB:a1 _:a2 _:a3
    | b |

    b := [ :x1 :x2 :x3 |b value:x1 value:x2 value:x3].
    b value:a1 value:a2 value:a3

    "Created: / 18-12-2017 / 21:03:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

endlessM
    self endlessM

    "Created: / 18-12-2017 / 09:31:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_issue_186b0_c
    "
     https://swing.fit.cvut.cz/projects/stx-jv/ticket/186
    "
    <spawn: true>

    ObjectMemory justInTimeCompilation:false.
    ParserFlags withSTCCompilation:#always
        do:[ self class recompile:#endlessB ].
    [
        self endlessB.
        self assert:false.
    ] on:RecursionError
            do:[:ex |
        Debugger classResources.
        self assert:true.
    ]

    "Created: / 18-12-2017 / 09:34:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 18-12-2017 / 21:07:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_issue_186b0_i
    "
     https://swing.fit.cvut.cz/projects/stx-jv/ticket/186"
    <spawn: true>

    ObjectMemory justInTimeCompilation:false.
    [
        self endlessB.
        self assert:false.
    ] on:RecursionError
            do:[:ex |
        Debugger classResources.
        self assert:true.
    ]

    "Created: / 18-12-2017 / 09:28:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 18-12-2017 / 21:08:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_issue_186b0_j
    "
     https://swing.fit.cvut.cz/projects/stx-jv/ticket/186"
    <spawn: true>


    ObjectMemory justInTimeCompilation:true.
    self skipIf:ObjectMemory justInTimeCompilation not
        description:'JIT not supported by current platform'.
    [
        self endlessB.
        self assert:false.
    ] on:RecursionError
            do:[:ex |
        Debugger classResources.
        self assert:true.
    ]

    "Created: / 18-12-2017 / 09:28:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 18-12-2017 / 21:08:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_issue_186b1_c
    "
     https://swing.fit.cvut.cz/projects/stx-jv/ticket/186"
    <spawn: true>


    ObjectMemory justInTimeCompilation:false.
    ParserFlags withSTCCompilation:#always
        do:[ self class recompile:#endlessB: ].
    [
        self endlessB: 1.
        self assert:false.
    ] on:RecursionError
            do:[:ex |
        Debugger classResources.
        self assert:true.
    ]

    "Created: / 18-12-2017 / 21:04:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_issue_186b1_i
    "
     https://swing.fit.cvut.cz/projects/stx-jv/ticket/186"
    <spawn: true>


    ObjectMemory justInTimeCompilation:false.
    [
        self endlessB:1.
        self assert:false.
    ] on:RecursionError
            do:[:ex |
        Debugger classResources.
        self assert:true.
    ]

    "Created: / 18-12-2017 / 21:05:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_issue_186b1_j
    "
     https://swing.fit.cvut.cz/projects/stx-jv/ticket/186"
    <spawn: true>


    ObjectMemory justInTimeCompilation:true.
    self skipIf:ObjectMemory justInTimeCompilation not
        description:'JIT not supported by current platform'.
    [
        self endlessB:1.
        self assert:false.
    ] on:RecursionError
            do:[:ex |
        Debugger classResources.
        self assert:true.
    ]

    "Created: / 18-12-2017 / 21:05:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_issue_186b2_c
    "
     https://swing.fit.cvut.cz/projects/stx-jv/ticket/186"
    <spawn: true>

    ObjectMemory justInTimeCompilation:false.
    ParserFlags withSTCCompilation:#always
        do:[ self class recompile:#endlessB:_: ].
    [
        self endlessB: 1 _:2.
        self assert:false.
    ] on:RecursionError
            do:[:ex |
        Debugger classResources.
        self assert:true.
    ]

    "Created: / 18-12-2017 / 21:04:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_issue_186b2_i
    "
     https://swing.fit.cvut.cz/projects/stx-jv/ticket/186"
    <spawn: true>


    ObjectMemory justInTimeCompilation:false.
    [
        self endlessB:1 _:2.
        self assert:false.
    ] on:RecursionError
            do:[:ex |
        Debugger classResources.
        self assert:true.
    ]

    "Created: / 18-12-2017 / 21:05:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_issue_186b2_j
    "
     https://swing.fit.cvut.cz/projects/stx-jv/ticket/186"
    <spawn: true>


    ObjectMemory justInTimeCompilation:true.
    self skipIf:ObjectMemory justInTimeCompilation not
        description:'JIT not supported by current platform'.
    [
        self endlessB:1 _:2.
        self assert:false.
    ] on:RecursionError
            do:[:ex |
        Debugger classResources.
        self assert:true.
    ]

    "Created: / 18-12-2017 / 21:05:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_issue_186b3_c
    "
     https://swing.fit.cvut.cz/projects/stx-jv/ticket/186"
    <spawn: true>


    ObjectMemory justInTimeCompilation:false.
    ParserFlags withSTCCompilation:#always
        do:[ self class recompile:#endlessB:_:_: ].
    [
        self endlessB: 1 _:2 _:3.
        self assert:false.
    ] on:RecursionError
            do:[:ex |
        Debugger classResources.
        self assert:true.
    ]

    "Created: / 18-12-2017 / 21:05:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_issue_186b3_i
    "
     https://swing.fit.cvut.cz/projects/stx-jv/ticket/186"
    <spawn: true>


    ObjectMemory justInTimeCompilation:false.
    [
        self endlessB:1 _:2 _:3.
        self assert:false.
    ] on:RecursionError
            do:[:ex |
        Debugger classResources.
        self assert:true.
    ]

    "Created: / 18-12-2017 / 21:06:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_issue_186b3_j
    "
     https://swing.fit.cvut.cz/projects/stx-jv/ticket/186"
    <spawn: true>


    ObjectMemory justInTimeCompilation:true.
    self skipIf:ObjectMemory justInTimeCompilation not
        description:'JIT not supported by current platform'.
    [
        self endlessB:1 _:2 _:3.
        self assert:false.
    ] on:RecursionError
            do:[:ex |
        Debugger classResources.
        self assert:true.
    ]

    "Created: / 18-12-2017 / 21:05:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_issue_186m_c
    "
    https://swing.fit.cvut.cz/projects/stx-jv/ticket/186
    "
    <spawn: true>

    ObjectMemory justInTimeCompilation: false.
    ParserFlags withSTCCompilation:#always do:[
        self class recompile:#endlessM
    ].
    [
        self endlessM.
        self assert: false.
    ] on: RecursionError do:[:ex |
        Debugger classResources.
        self assert: true.
    ]

    "Created: / 18-12-2017 / 09:34:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_issue_186m_i
    "
    https://swing.fit.cvut.cz/projects/stx-jv/ticket/186
    "
    <spawn: true>

    ObjectMemory justInTimeCompilation: false.

    [
        self endlessM.
        self assert: false.
    ] on: RecursionError do:[:ex |
        Debugger classResources.
        self assert: true.
    ]

    "Created: / 18-12-2017 / 09:26:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_issue_186m_j
    "
    https://swing.fit.cvut.cz/projects/stx-jv/ticket/186
    "
    <spawn: true>

    ObjectMemory justInTimeCompilation: true.
    self skipIf: ObjectMemory justInTimeCompilation not description: 'JIT not supported by current platform'.

    [
        self endlessM.
        self assert: false.
    ] on: RecursionError do:[:ex |
        Debugger classResources.
        self assert: true.
    ]

    "Created: / 18-12-2017 / 09:27:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_run_CharacterTests_from_browser
    <timeout: 120> "2min"
    <spawn: true>

    | browser browserInteractor button buttonInteractor |

    Screen current isNil ifTrue:[
        Smalltalk openDisplay.
    ].
    self skipIf:Screen current isNil description:'No display connection'.
    Smalltalk loadPackage:'stx:goodies/sunit/ext/ui'.              

    CharacterTests autoload.
     browser := Tools::NewSystemBrowser new.
    browser open.
    browserInteractor := browser interactor.    
    browserInteractor do:[ browser switchToClass: CharacterTests ].
    self assert: browser theSingleSelectedClass == CharacterTests.
    button := self childOf: browser window withUUID: '79afa5fe-a549-4419-b035-21af25ac5ec3'.
    self assert: button notNil.
    buttonInteractor := button interactor.
    buttonInteractor do:[button controller performAction].

    "Created: / 21-12-2017 / 15:26:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_stx_libjava_testSuite_inspect
    <timeout: 120> "2min"
    <spawn: true>

    (Smalltalk at:#stx_libjava) testSuite inspect.
    Delay waitForSeconds: 5.

    "Created: / 01-05-2017 / 21:34:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-12-2017 / 15:23:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VMCrashTests methodsFor:'tests - regression'!

iter_issue_200: class
    "
    https://swing.fit.cvut.cz/projects/stx-jv/ticket/200
    "
    | t e |

    "
    SkipIssue200 := true.
    SkipIssue200 := false.
    "
    self skipIf: SkipIssue200 description: 'Skipped bu default since it may crash systems with less memory (especially Linux)'.
    self skipIf: ((OperatingSystem getSystemInfo includesKey: #physicalRam) not or:[(OperatingSystem getSystemInfo at: #physicalRam) < (10 * 1024 * 1024 * 1024)]) description: 'This bug required > 6GB RAM physical to manifest'.

    t := class new: 46. 
    Stdout nextPutLine: class name.
    [ 
        1 to: 64 do:[:i | 
            Stdout nextPutLine: 'Iteration ', i printString , ' - ', (t size*2) printString. 
            t := t , t.
        ] 
    ] on: Error do:[:ex | 
        Stdout nextPutLine: ex description.
        e := ex.
    ]. 
    self assert: e class == AllocationFailure

    "Created: / 12-04-2018 / 11:20:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 23-05-2018 / 14:46:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_issue_197a
    "
    https://swing.fit.cvut.cz/projects/stx-jv/ticket/197
    "
    <spawn: true>

    | path |

    self skipIf: OperatingSystem isMSWINDOWSlike not  description: 'This test is Windows-specific'.

    path := (Unicode16String new: 10000) replaceAll: Character space with: $x.
    OperatingSystem primGetFileAttributes: path

    "Created: / 27-03-2018 / 09:05:57 / jv"
!

test_issue_200_Array
    "
    https://swing.fit.cvut.cz/projects/stx-jv/ticket/200
    "
    <spawn: true>
    <timeout: 660> "11min" 

    self iter_issue_200: Array

    "Created: / 12-04-2018 / 11:21:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_issue_200_ByteArray
    "
    https://swing.fit.cvut.cz/projects/stx-jv/ticket/200
    "
    <spawn: true>
    <timeout: 660> "11min" 

    self iter_issue_200: ByteArray

    "Created: / 12-04-2018 / 11:21:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_issue_200_DoubleArray
    "
    https://swing.fit.cvut.cz/projects/stx-jv/ticket/200
    "
    <spawn: true>
    <timeout: 660> "11min" 

    self iter_issue_200: DoubleArray

    "Created: / 12-04-2018 / 11:23:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_issue_200_FloatArray
    "
    https://swing.fit.cvut.cz/projects/stx-jv/ticket/200
    "
    <spawn: true>
    <timeout: 660> "11min" 

    self iter_issue_200: FloatArray

    "Created: / 12-04-2018 / 11:23:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_issue_200_IntegerArray
    "
    https://swing.fit.cvut.cz/projects/stx-jv/ticket/200
    "
    <spawn: true>
    <timeout: 660> "11min" 

    self iter_issue_200: IntegerArray

    "Created: / 12-04-2018 / 11:22:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_issue_200_LongIntegerArray
    "
    https://swing.fit.cvut.cz/projects/stx-jv/ticket/200
    "
    <spawn: true>
    <timeout: 660> "11min" 

    self iter_issue_200: LongIntegerArray

    "Created: / 12-04-2018 / 11:21:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_issue_200_SignedIntegerArray
    "
    https://swing.fit.cvut.cz/projects/stx-jv/ticket/200
    "
    <spawn: true>
    <timeout: 660> "11min" 

    self iter_issue_200: SignedIntegerArray

    "Created: / 12-04-2018 / 11:22:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_issue_200_SignedLongIntegerArray
    "
    https://swing.fit.cvut.cz/projects/stx-jv/ticket/200
    "
    <spawn: true>
    <timeout: 660> "11min" 

    self iter_issue_200: SignedLongIntegerArray

    "Created: / 12-04-2018 / 11:21:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_issue_200_String
    "
    https://swing.fit.cvut.cz/projects/stx-jv/ticket/200
    "
    <spawn: true>
    <timeout: 660> "11min" 

    self iter_issue_200: String

    "Created: / 12-04-2018 / 11:21:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_issue_200_Unicode16String
    "
    https://swing.fit.cvut.cz/projects/stx-jv/ticket/200
    "
    <spawn: true>
    <timeout: 660> "11min" 

    self iter_issue_200: Unicode16String.

    "Created: / 12-04-2018 / 11:17:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_issue_200_Unicode32String
    "
    https://swing.fit.cvut.cz/projects/stx-jv/ticket/200
    "
    <spawn: true>
    <timeout: 660> "11min" 

    self iter_issue_200: Unicode32String.

    "Created: / 12-04-2018 / 11:21:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_issue_205a
    "
    https://swing.fit.cvut.cz/projects/stx-jv/ticket/205
    "
    <spawn: false>
    <timeout: 120>"2min"

    self spawnSmalltalk:#('-P' '1 to: 1000 do:[:each | each := each * 100. Delay waitForMilliseconds: 20. ObjectMemory garbageCollect ]. Smalltalk exit:0')

    "Created: / 17-04-2018 / 15:18:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 25-05-2018 / 22:22:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_issue_205b
    "
    https://swing.fit.cvut.cz/projects/stx-jv/ticket/205
    "
    <spawn: true>
    <timeout: 180>"3min"
    | ws |

    Screen current isNil ifTrue:[
        Smalltalk openDisplay.
    ].
    self skipIf:Screen current isNil description:'No display connection'.

    ParserFlags allowAssignmentToBlockArgument: true.
    ParserFlags warnAssignmentToBlockArgument: false.
    ws := Workspace new.
    ws open.
    ws contents: '1 to: 1000 do:[:each | each := each * 100. Delay waitForMilliseconds: 20. ObjectMemory garbageCollect]'.
    Delay waitForSeconds: 1.
    ws selectAll.
    Delay waitForSeconds: 1.  
    ws doIt.
    ws close.
    Stdout nextPutAll: 'Passed!!'.

    "Created: / 17-04-2018 / 16:10:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-05-2018 / 22:22:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VMCrashTests class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


VMCrashTests initialize!
