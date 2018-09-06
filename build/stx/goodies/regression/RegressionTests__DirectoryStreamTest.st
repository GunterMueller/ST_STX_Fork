"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#DirectoryStreamTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression-Streams'
!


!DirectoryStreamTest methodsFor:'cleanup'!

tearDown
    self testDirName recursiveRemove
! !

!DirectoryStreamTest methodsFor:'helpers'!

testDirName
    ^ 'testDir' asFilename
! !

!DirectoryStreamTest methodsFor:'tests'!

test01
    "basic open for appending."

    |s dir t|

    dir := self testDirName.
    dir asFilename makeDirectory.
    s := DirectoryStream directoryNamed:dir.

    self assert:s atEnd.
    self assert:s nextLine isNil.

    s close.

    self assert:dir asFilename directoryContents size == 0.

    (dir asFilename construct:'file1') writingFileDo:[:s | s nextPutAll:'foo'].

    dir := self testDirName.
    dir asFilename makeDirectory.
    s := DirectoryStream directoryNamed:dir.

    self assert:s atEnd not.
    self assert:(t := s nextLine) = 'file1'.
    self assert:s atEnd.
    self assert:s nextLine isNil.

    s close.

    self assert:dir asFilename directoryContents size == 1.

    "
     self new test01
    "
! !

!DirectoryStreamTest class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

