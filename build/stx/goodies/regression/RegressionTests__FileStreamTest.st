"
 COPYRIGHT (c) Claus Gittinger / eXept Software AG
 COPYRIGHT (c) 2017 Jan Vrany
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

TestCase subclass:#FileStreamTest
	instanceVariableNames:'testFilename'
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression-Streams'
!

!FileStreamTest class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) Claus Gittinger / eXept Software AG
 COPYRIGHT (c) 2017 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!FileStreamTest methodsFor:'helpers'!

createBigDirectoryWithManyFiles
    "create a directory with 20000 files"

    'c:\tmp' asFilename exists ifFalse:[
	'c:\tmp' asFilename makeDirectory
    ].
    'c:\tmp\BigDirectory' asFilename exists ifFalse:[
	'c:\tmp\BigDirectory' asFilename makeDirectory
    ].

    1 to:20000 do:[:i|
       |f s buffer|
       f :='c:\tmp\BigDirectory' asFilename
		    construct:(i printString leftPaddedTo:5 with:$0).
       s := f writeStream binary.
       buffer := ByteArray new:1024.
       32 timesRepeat:[ s nextPutAll:buffer ].
       s close.
    ].

    "
     self new createBigDirectoryWithManyFiles
    "

    "Created: / 12.8.1998 / 13:25:25 / cg"
!

createTestFile
    "create a test file (100k size)"

    |f bytes|

    f := testFilename writeStream binary.
    bytes := ByteArray new:1024.
    1 to:bytes size do:[:i |
        bytes at:i put:(i \\ 256).
    ].

    100 timesRepeat:[
        f nextPutAll:bytes.
    ].

    f close.

    "
     self new createTestFile
    "

    "Created: / 12-08-1998 / 13:25:25 / cg"
    "Modified: / 31-05-2017 / 07:23:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doTestWrite:size
    "basic writing. writes a chunk of data and reads it back to verify its written correctly
     Called with different sizes and interrupted while writing"

    |file s sz buffer byte|

    buffer := ByteArray new:size.
    1 to:buffer size do:[:idx |
	buffer at:idx put:(idx \\ 256)
    ].

    file := Filename newTemporary.
    s := file writeStream.

    s binary.
    s nextPutAll:buffer.
    s close.

    sz := file fileSize.
    sz ~= size ifTrue:[self error:'size mismatch'].

    s := file readStream.
    s binary.
    1 to:size do:[:idx |
	byte := s next.
	byte ~~ (idx \\ 256) ifTrue:[self error:'read data mismatch'].
    ].
    s close.

    (file binaryContentsOfEntireFile ~= buffer) ifTrue:[
	self error:'read data mismatch2'
    ].
    file delete.

    "
     self testWrite:1024
    "
!

readFileExpecting:expect
    "read test file, expect n bytes"

    |f buffer n nRead|

    f := testFilename readStream binary.
    buffer := ByteArray new:128.

    n := 0.
    [f atEnd] whileFalse:[
        nRead := f nextBytes:128 into:buffer.
        n := n + nRead.
    ].
    f close.
    self assert:(expect = n) description:('got <1p>; expected:<2p>' expandMacrosWith:n with:expect)

    "Created: / 12-08-1998 / 13:29:41 / cg"
    "Modified: / 31-05-2017 / 07:23:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!FileStreamTest methodsFor:'running'!

setUp
    testFilename := Filename newTemporary

    "Created: / 31-05-2017 / 07:22:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

tearDown
    testFilename exists ifTrue:[
        testFilename remove
    ]

    "Modified: / 31-05-2017 / 07:23:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!FileStreamTest methodsFor:'tests'!

testAppend1
    "basic open for appending."

    |file s sz actualContents expectedContents|

    file := Filename newTemporary.
    s := file writeStream.
    s binary.
    s nextPutAll:(1 to:100).
    s close.

    sz := file fileSize.
    self should:[ sz = 100 ]. "/ size mismatch

    s := file appendingWriteStream.
    s binary.
    s nextPutAll:(101 to:200).
    s close.

    sz := file fileSize.
    self should:[ sz = 200 ]. "/ size mismatch

    actualContents := file binaryContentsOfEntireFile.
    expectedContents := (1 to:200) asByteArray.
    self should:[ (actualContents = expectedContents) ].   "/ contents mismatch

    file delete.

    "
     self new testAppend1
    "
!

testOpenRead1
    "basic open for reading."

    |sz|

    self createTestFile.

    sz := testFilename fileSize.

    self readFileExpecting:sz.

    "
     self new testOpenRead1
    "

    "Modified: / 31-05-2017 / 07:23:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testRead1
    "read a file - check count read with files size."

    |sz|

    self createTestFile.

    sz := testFilename fileSize.

    self readFileExpecting:sz.

    "
     self new testRead1
    "

    "Modified: / 12-08-1998 / 13:29:55 / cg"
    "Modified: / 31-05-2017 / 07:23:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testRead2
    "read a file - check count read with files size.
     Do this in 20 threads"

    |sz verbose errorOccured sema|

    verbose := false.

    self createTestFile.
    self assert:(testFilename exists).

    sz := testFilename fileSize.
    sema := Semaphore new:1-20.
    20 timesRepeat:[
        [
            [
                self readFileExpecting:sz.
                verbose ifTrue:[ 'done' printCR ].
            ] on:Error do:[:ex|
                errorOccured := ex.
            ].
            sema signal.
        ] fork.
    ].
    self assert:(sema waitWithTimeout:20) notNil.
    self assert:errorOccured isNil.

    "
     self new testRead2
    "

    "Modified: / 10-01-2012 / 19:28:45 / cg"
    "Modified: / 31-05-2017 / 07:24:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testRead3
    "read a file - check count read with files size.
     Do this and interrupt the reading thread heavily"

    |sz p count nLoop errorOccured|

    nLoop := 1000.

    self createTestFile.

    sz := testFilename fileSize.

    p := [
        [
            nLoop timesRepeat:[
                self readFileExpecting:sz.
            ].
        ] on:Error do:[:ex|
            errorOccured := ex.
        ].
    ] forkAt:7.

    count := 0.
    [p isDead] whileFalse:[
        Delay waitForMilliseconds:5.
        p interruptWith:[count := count + 1].
    ].
    self assert:errorOccured isNil.
    self assert:count > 50. "/ at least 50 times interrupted...
    "/ Transcript printf:'read file %d times; interrupted %d times\n' with:nLoop with:count.

    "
     self new testRead3
    "

    "Modified: / 12-08-1998 / 13:42:13 / cg"
    "Modified: / 31-05-2017 / 07:23:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testRewrite1
    "basic open for writing (with truncation)."

    |file s sz|

    file := Filename newTemporary.
    s := file writeStream.
    s binary.
    s nextPutAll:(1 to:200).
    s close.

    sz := file fileSize.
    sz ~= 200 ifTrue:[self error:'size mismatch'].

    s := file writeStream.
    s binary.
    s nextPutAll:(101 to:200).
    s close.

    sz := file fileSize.
    sz ~= 100 ifTrue:[self error:'size mismatch'].

    (file binaryContentsOfEntireFile ~= (101 to:200) asByteArray) ifTrue:[
	self error:'contents mismatch'
    ].

    file delete.

    "
     self new testRewrite1
    "
!

testRewrite2
    "basic open for re-writing (without truncation)."

    |file s sz|

    file := Filename newTemporary.
    s := file writeStream.
    s binary.
    s nextPutAll:(1 to:200).
    s close.

    sz := file fileSize.
    sz ~= 200 ifTrue:[self error:'size mismatch'].

    s := file readWriteStream.
    s binary.
    s nextPutAll:(101 to:200).
    s close.

    sz := file fileSize.
    sz ~= 200 ifTrue:[self error:'size mismatch'].

    (file binaryContentsOfEntireFile ~=
	((101 to:200) asByteArray , (101 to:200) asByteArray)) ifTrue:[
	self error:'contents mismatch'
    ].

    file delete.

    "
     self new testRewrite2
    "
!

testTTYa
    | stream |

    self createTestFile.
    stream := testFilename readStream.
    [
        self deny: stream isTTY.
    ] ensure:[ 
        stream close.
    ].

    "Created: / 31-05-2017 / 07:30:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testWrite1
    "basic writing in various block sizes"

    self doTestWrite:1024.
    self doTestWrite:2048.
    self doTestWrite:4096.
    self doTestWrite:8192.
    self doTestWrite:8192*2.
    self doTestWrite:8192*4.
    self doTestWrite:8192*8.
    self doTestWrite:8192*16.
    self doTestWrite:8192*32.
    self doTestWrite:8192*64.
    self doTestWrite:8192*128.

    "
     self new testWrite1
    "

    "Modified (comment): / 18-01-2012 / 12:02:34 / cg"
!

testWrite2
    "basic writing"

    10 timesRepeat:[
	self testWrite1.
    ].

    "
     self new testWrite2
    "
!

testWrite3
    "writing with many interrupts"

    <timeout: 300>"5 mins"

    |interruptor|

    interruptor := [
	[true] whileTrue:[
	    Delay waitForMilliseconds:10.
	].
    ] forkAt:9.

    [
	50 timesRepeat:[
	    self testWrite1.
	].
    ] valueNowOrOnUnwindDo:[
	interruptor terminate
    ].

    "
     self new testWrite3
    "

    "Modified (comment): / 18-01-2012 / 12:02:21 / cg"
    "Modified: / 26-04-2013 / 16:58:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testWriteEOLModes

    testFilename writingFileDo:[:s |
        s eolMode:#crlf.
        s nextPutLine:'hello'
    ].
    self assert:(testFilename fileSize == 7).
    self assert:(testFilename binaryContentsOfEntireFile = #[16r68 16r65 16r6C 16r6C 16r6F 16r0D 16r0A]).

    testFilename writingFileDo:[:s |
        s eolMode:#nl.
        s nextPutLine:'hello'
    ].
    self assert:(testFilename fileSize == 6).
    self assert:(testFilename binaryContentsOfEntireFile = #[16r68 16r65 16r6C 16r6C 16r6F 16r0A]).

    testFilename writingFileDo:[:s |
        s eolMode:#cr.
        s nextPutLine:'hello'
    ].
    self assert:(testFilename fileSize == 6).
    self assert:(testFilename binaryContentsOfEntireFile = #[16r68 16r65 16r6C 16r6C 16r6F 16r0D]).

    "/ ------------------------

    testFilename writingFileDo:[:s |
        s eolMode:#crlf.
        s nextPutAll:'hello' , Character cr
    ].
    self assert:(testFilename fileSize == 7).
    self assert:(testFilename binaryContentsOfEntireFile = #[16r68 16r65 16r6C 16r6C 16r6F 16r0D 16r0A]).

    testFilename writingFileDo:[:s |
        s eolMode:#nl.
        s nextPutAll:'hello' , Character cr
    ].
    self assert:(testFilename fileSize == 6).
    self assert:(testFilename binaryContentsOfEntireFile = #[16r68 16r65 16r6C 16r6C 16r6F 16r0A]).

    testFilename writingFileDo:[:s |
        s eolMode:#cr.
        s nextPutAll:'hello' , Character cr
    ].
    self assert:(testFilename fileSize == 6).
    self assert:(testFilename binaryContentsOfEntireFile = #[16r68 16r65 16r6C 16r6C 16r6F 16r0D]).

    "/ in binary mode, this should be ignored
    testFilename writingFileDo:[:s |
        s binary.
        s eolMode:#crlf.
        s nextPutAll:'hello' , Character cr
    ].
    self assert:(testFilename fileSize == 6).
    self assert:(testFilename binaryContentsOfEntireFile = #[16r68 16r65 16r6C 16r6C 16r6F 16r0A]).


    "
     self new testWriteEOLModes
    "

    "Modified: / 31-05-2017 / 07:26:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!FileStreamTest class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

