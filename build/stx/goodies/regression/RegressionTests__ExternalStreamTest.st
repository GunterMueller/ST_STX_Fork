"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#ExternalStreamTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression-Streams'
!

!ExternalStreamTest class methodsFor:'documentation'!

documentation
"
    tests functions of the new stream package (which is not yet deployed)
"
! !

!ExternalStreamTest methodsFor:'test-helpers'!

createWithSize10:fileName
    "helper"

    (fileName asFilename exists) ifTrue:[
	fileName asFilename delete
    ].
    fileName asFilename writeStream
	nextPutAll:'1234567890';
	close.
    self assert:(fileName asFilename exists).
    self assert:(fileName asFilename fileSize == 10).

    "
     self new createWithSize10:'xxx1'
    "
! !

!ExternalStreamTest methodsFor:'tests'!

testCopyFile1
    self assert:('smalltalk.rc' asFilename exists).

    'smalltalk.rc' asFilename copyTo:'smalltalk.rc2'.

    self assert:('smalltalk.rc' asFilename fileSize = 'smalltalk.rc2' asFilename fileSize).
    self assert:('smalltalk.rc' asFilename contentsOfEntireFile = 'smalltalk.rc2' asFilename contentsOfEntireFile).
    'smalltalk.rc2' asFilename delete.

    "
     self new testCopyFile1
    "
!

testPosition1
    |h s ch externalReadStream|

    externalReadStream := (Smalltalk at:#ExternalReadStream).
    self skipIf:externalReadStream isBehavior not description:'skipped until new stream package is used'.

    self createWithSize10:'xxx3'.

    h := OperatingSystem openFileForRead:'xxx3'.
    s := externalReadStream on:h.

    self assert:( s atEnd not ).
    self assert:( s position == 0 ).

    ch := s next.
    self assert:( ch = $1 ).
    self assert:( s position == 1 ).

    s skip:1.
    self assert:( s position == 2 ).
    self assert:( s peek = $3 ).
    self assert:( s position == 2 ).
    s skip:1.
    self assert:( s position == 3 ).
    self assert:( s peek = $4 ).
    self assert:( s position == 3 ).

    s close.

    'xxx3' asFilename delete.

    "
     self new testPosition1
    "
!

testPosition2
    |h s externalReadStream|

    externalReadStream := (Smalltalk at:#ExternalReadStream).
    self skipIf:externalReadStream isBehavior not description:'skipped until new stream package is used'.

    self createWithSize10:'xxx3'.

    h := OperatingSystem openFileForRead:'xxx3'.
    s := externalReadStream on:h.

    self assert:( s atEnd not ).
    self assert:( s position == 0 ).

    s setToEnd.

    self assert:( s position == 10 ).
    self assert:( s atEnd ).

    s close.

    'xxx3' asFilename delete.

    "
     self new testPosition2
    "
!

testRead1
    "open an existing file for reading; should read 10 chars"

    |h s nBytesRead externalReadStream|

    externalReadStream := (Smalltalk at:#ExternalReadStream).
    self skipIf:externalReadStream isBehavior not description:'skipped until new stream package is used'.

    self createWithSize10:'xxx3'.

    h := OperatingSystem openFileForRead:'xxx3'.
    s := externalReadStream on:h.

    '1234567890' do:[:eachExpected |
        self assert:( s next == eachExpected ).
    ].

    s close.

    'xxx3' asFilename delete.

    "
     self new testRead1
    "
!

testRead2
    "open an existing file for reading; should read 10 chars"

    |h s externalReadStream|

    externalReadStream := (Smalltalk at:#ExternalReadStream).
    self skipIf:externalReadStream isBehavior not description:'skipped until new stream package is used'.

    self createWithSize10:'xxx3'.

    h := OperatingSystem openFileForRead:'xxx3'.
    s := externalReadStream on:h.
    s binary.

    '1234567890' do:[:eachExpected |
        |eachRead|

        eachRead := s next.
        self assert:( eachRead == eachExpected asciiValue ).
    ].

    s close.

    'xxx3' asFilename delete.

    "
     self new testRead2
    "
!

testRead3
    "open an existing file for reading; should read 10 chars"

    |h s bytesRead externalReadStream|

    externalReadStream := (Smalltalk at:#ExternalReadStream).
    self skipIf:externalReadStream isBehavior not description:'skipped until new stream package is used'.

    self createWithSize10:'xxx3'.

    h := OperatingSystem openFileForRead:'xxx3'.
    s := externalReadStream on:h.

    self assert:( s atEnd not ).

    bytesRead := s next:10.
    self assert:( bytesRead = '1234567890' ).
    self assert:( s atEnd ).

    s close.

    'xxx3' asFilename delete.

    "
     self new testRead3
    "
!

testReadWait1
    |h s ok externalReadStream|

    externalReadStream := (Smalltalk at:#ExternalReadStream).
    self skipIf:externalReadStream isBehavior not description:'skipped until new stream package is used'.

    self createWithSize10:'xxx3'.

    h := OperatingSystem openFileForRead:'xxx3'.
    s := externalReadStream on:h.

    ok := (s readWaitWithTimeout:1) == false.

    self assert:( ok ).

    s close.

    'xxx3' asFilename delete.

    "
     self new testReadWait1
    "
!

testTiming1
    |h s t externalWriteStream externalReadStream|

    externalWriteStream := (Smalltalk at:#ExternalWriteStream).
    externalReadStream := (Smalltalk at:#ExternalReadStream).
    self skipIf:externalWriteStream isBehavior not description:'skipped until new stream package is used'.

    ('xxx1' asFilename exists) ifTrue:[
        'xxx1' asFilename delete
    ].

    h := OperatingSystem createFileForReadWrite:'xxx1'.
    s := externalWriteStream on:h.

    t := Time millisecondsToRun:[
        1000000 timesRepeat:[
            s nextPut:$a.
        ].
    ].
    s close.
    Transcript showCR:'Time to write: ' , t printString.

    self assert:( 'xxx1' asFilename exists ).
    self assert:( 'xxx1' asFilename fileSize == 1000000 ).

    h := OperatingSystem openFileForRead:'xxx1'.
    s := externalReadStream on:h.

    t := Time millisecondsToRun:[
        1000000 timesRepeat:[
            self assert:(s next == $a).
        ].
    ].
    s close.
    Transcript showCR:'Time to read: ' , t printString.

    ('xxx1' asFilename exists) ifTrue:[
        'xxx1' asFilename delete
    ].

    "
     self new testTiming1
    "
!

testTiming2
    |h s t externalWriteStream externalReadStream|

    externalWriteStream := (Smalltalk at:#ExternalWriteStream).
    externalReadStream := (Smalltalk at:#ExternalReadStream).
    self skipIf:externalWriteStream isBehavior not description:'skipped until new stream package is used'.

    ('xxx1' asFilename exists) ifTrue:[
        'xxx1' asFilename delete
    ].

    h := OperatingSystem createFileForReadWrite:'xxx1'.
    s := externalWriteStream on:h.

    t := Time millisecondsToRun:[
        100000 timesRepeat:[
            s nextPutAll:'0123456789'.
        ].
    ].
    s close.
    Transcript showCR:'Time to write: ' , t printString.

    self assert:( 'xxx1' asFilename exists ).
    self assert:( 'xxx1' asFilename fileSize == 1000000 ).

    h := OperatingSystem openFileForRead:'xxx1'.
    s := externalReadStream on:h.

    t := Time millisecondsToRun:[
        100000 timesRepeat:[
            self assert:((s next:10) = '0123456789').
        ].
    ].
    s close.
    Transcript showCR:'Time to read: ' , t printString.

    ('xxx1' asFilename exists) ifTrue:[
        'xxx1' asFilename delete
    ].

    "
     self new testTiming2
    "
!

testWrite1
    |h s externalWriteStream|

    externalWriteStream := (Smalltalk at:#ExternalWriteStream).
    self skipIf:externalWriteStream isBehavior not description:'skipped until new stream package is used'.

    ('xxx1' asFilename exists) ifTrue:[
        'xxx1' asFilename delete
    ].

    h := OperatingSystem createFileForReadWrite:'xxx1'.
    s := externalWriteStream on:h.

    s nextPutAll:'1234567890'.
    s close.

    self assert:( 'xxx1' asFilename exists ).
    self assert:( 'xxx1' asFilename fileSize == 10 ).
    self assert:( 'xxx1' asFilename contentsOfEntireFile = '1234567890' ).

    ('xxx1' asFilename exists) ifTrue:[
        'xxx1' asFilename delete
    ].

    "
     self new testWrite1
    "
!

testWrite2
    |h s externalWriteStream|

    externalWriteStream := (Smalltalk at:#ExternalWriteStream).
    self skipIf:externalWriteStream isBehavior not description:'skipped until new stream package is used'.

    ('xxx1' asFilename exists) ifTrue:[
        'xxx1' asFilename delete
    ].

    h := OperatingSystem createFileForReadWrite:'xxx1'.
    s := externalWriteStream on:h.

    self assert:( s position == 0 ).
    s nextPutAll:'1234567890'.
    self assert:( s position == 10 ).


    s close.

    self assert:( 'xxx1' asFilename exists ).
    self assert:( 'xxx1' asFilename fileSize == 10 ).
    self assert:( 'xxx1' asFilename contentsOfEntireFile = '1234567890' ).

    ('xxx1' asFilename exists) ifTrue:[
        'xxx1' asFilename delete
    ].

    "
     self new testWrite2
    "
!

testWrite3
    |h s externalWriteStream|

    externalWriteStream := (Smalltalk at:#ExternalWriteStream).
    self skipIf:externalWriteStream isBehavior not description:'skipped until new stream package is used'.

    ('xxx1' asFilename exists) ifTrue:[
        'xxx1' asFilename delete
    ].

    h := OperatingSystem createFileForReadWrite:'xxx1'.
    s := externalWriteStream on:h.

    s nextPutAll:'1234567890'.
    self assert:( s position == 10 ).
    s position:5.
    s nextPutAll:'abcdefghij'.
    self assert:( s position == 15 ).

    s close.

    self assert:( 'xxx1' asFilename exists ).
    self assert:( 'xxx1' asFilename fileSize == 15 ).
    self assert:( 'xxx1' asFilename contentsOfEntireFile = '12345abcdefghij' ).

    ('xxx1' asFilename exists) ifTrue:[
        'xxx1' asFilename delete
    ].

    "
     self new testWrite3
    "
! !

!ExternalStreamTest class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

