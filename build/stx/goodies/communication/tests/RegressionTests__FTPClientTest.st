"{ Package: 'stx:goodies/communication/tests' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#FTPClientTest
	instanceVariableNames:'ftpHost ftpUser ftpPassword'
	classVariableNames:'FtpHost FtpUser FtpPassword'
	poolDictionaries:''
	category:'tests-Regression'
!

!FTPClientTest class methodsFor:'documentation'!

documentation
"
    documentation to be added.

    [author:]
	Claus Gittinger (cg@alan)

    [instance variables:]

    [class variables:]

    [see also:]

"
!

history
    "Created: / 7.11.2002 / 14:27:37 / cg"
! !

!FTPClientTest methodsFor:'helpers'!

newFtpConnection
    |ftp|

    ftp := FTPClient new.
    ftp connectTo:ftpHost user:ftpUser password:ftpPassword.
    ^ ftp.
! !

!FTPClientTest methodsFor:'initialize / release'!

setUp
    "common setup - invoked before testing"

    super setUp.

    ftpHost := FtpHost ? 'ftp.exept.de'.
    ftpUser := FtpUser ? 'anonymous'.
    ftpPassword := FtpPassword ? 'bla@foo.com'.

"
    FtpHost := 'exept.exept.de'.
    FtpUser := Dialog request:'user:'.
    FtpPassword := Dialog request:'passwd:'.
"

"
    FtpHost := nil.
    FtpUser := nil.
    FtpPassword := nil.
"

"/    FTPClient verbose:true.
"/    FTPClient verbose:false.
! !

!FTPClientTest methodsFor:'tests'!

test_01_Connect
    |ftp peerHostname|

    ftp := self newFtpConnection.

    self assert:(ftp connection notNil).
    "/ self assert:(ftp connection port == 21).
    "/ self assert:(ftp connection getPeer = (IPSocketAddress hostAddress:#[217 172 183 25] port:21)).
    peerHostname := ftp connection getPeer hostName.
    self assert:((peerHostname = 'florenz025.server4you.de')
                 or:[(peerHostname = 'www.exept.de')
                 or:[(peerHostname = 'ftp.exept.de')
                 or:[(peerHostname = 'mail.exept.de')]]]).

    ftp close.

    "
     self debug:#test_01_Connect
     [ self debug:#test_01_Connect ] fork
'' printCR
Socket debug:true
    "
!

test_02_SystemType
    |ftp list|

    ftp := self newFtpConnection.
    list := ftp systemType.
    ftp close.

    Transcript show:'System type: '; showCR:list.

    "
     self debug:#test_02_SystemType
    "
!

test_03_Help
    |ftp list|

    ftp := self newFtpConnection.
    list := ftp help.
    ftp close.

    Transcript show:'Help output: '; showCR:list.

    "
     self debug:#test_03_Help
    "
!

test_04_Status
    |ftp result|

    ftp := self newFtpConnection.
    result := ftp systemStatus.
    ftp close.

    Transcript show:'Server status: '; showCR:result.

    "
     self debug:#test_04_Status
    "
!

test_05_ChDir
    |ftp list|

    ftp := self newFtpConnection.
    list := ftp cd:'download'.
    list := ftp list.
    ftp close.

    Transcript showCR:'Directory listing of download:'; showCR:list.

    "
     self debug:#test_05_ChDir
    "
!

test_06_ChDirUp
    |ftp list1 list2|

    ftp := self newFtpConnection.
    list1 := ftp list.
    ftp cd:'download'.
    ftp cdUp.
    list2 := ftp list.
    ftp close.

    self should:list1 = list2.

    Transcript showCR:list2.

    "
     self debug:#test_06_ChDirUp
    "
!

test_07_Dir
    |ftp list|

    ftp := self newFtpConnection.
    list := ftp list.
    ftp close.

    Transcript showCR:'Directory contents: '; showCR:list.

    "
     self debug:#test_07_Dir
    "
!

test_07a_DirActive
    |ftp list|

    ftp := self newFtpConnection.
    ftp passiveMode:false.
    list := ftp list.
    ftp close.

    Transcript showCR:'Directory contents: '; showCR:list.

    "
     self debug:#test_07a_DirActive
    "
!

test_07b_DirPassive
    |ftp list|

    ftp := self newFtpConnection.
    ftp passiveMode:true.
    list := ftp list.
    ftp close.

    Transcript showCR:'Directory contents: '; showCR:list.

    "
     self debug:#test_07b_DirPassive
    "
!

test_08_Get
    |ftp s|

    ftp := self newFtpConnection.
    s := ftp get:'download/wartungsvertrag.pdf'.

    ftp close.

    Transcript showCR:'Size of wartungsvertrag.pdf (binary fetch): ', s size printString.

    "
     self debug:#test_08_Get
     100 timesRepeat:[self debug:#test_08_Get]
    "
!

test_08a_GetActive
    |ftp s|

    ftp := self newFtpConnection.
    ftp passiveMode:false.
    s := ftp get:'download/wartungsvertrag.pdf'.

    ftp close.

    Transcript showCR:'Size of wartungsvertrag.pdf (binary fetch): ', s size printString.

    "
     self debug:#test_08a_GetActive
    "
!

test_08b_GetPassive
    |ftp s|

    ftp := self newFtpConnection.
    ftp passiveMode:true.
    s := ftp get:'download/wartungsvertrag.pdf'.

    ftp close.

    Transcript showCR:'Size of wartungsvertrag.pdf (binary fetch): ', s size printString.

    "
     self debug:#test_08b_GetPassive
    "
!

test_09_GetAscii
    |ftp s|

    ftp := self newFtpConnection.
    ftp ascii.
    s := ftp get:'download/wartungsvertrag.pdf'.

    ftp close.

    s := s asString.

    Transcript showCR:'Size of wartungsvertrag.pdf (ascii fetch): ', s size printString.

    "
     self debug:#test_09_GetAscii
    "
!

test_10_GetPassive
    |ftp s prevMode|

    ftp := self newFtpConnection.
    prevMode := ftp passiveMode:true.
    s := ftp get:'download/wartungsvertrag.pdf'.
    prevMode := ftp passiveMode:prevMode.

    ftp close.

    Transcript showCR:'Size of wartungsvertrag.pdf (passiveMode): ', s size printString.

    "
     self debug:#test_10_GetPassive
    "
!

test_11_Put
    |ftp s|

    "/ this test fails for most servers - they do not allow putting files.
    "/ change to a server you know to allow writing (or a local one)
    "/ and uncomment.
    FtpHost isNil ifTrue:[^ self].

    ftp := self newFtpConnection.

    ftp ascii.

    s := ftp putStreamFor:'testfile'.
    s nextPutLine:'this is line 1'.
    s nextPutLine:'this is line 2'.
    s nextPutLine:'this is the last line'.
    s close.

    ftp close.

    "
     self debug:#test_11_Put
    "
!

test_12_Get2
    "two gets"

    |ftp s1 s2|

    ftp := self newFtpConnection.
    s1 := ftp get:'download/wartungsvertrag.pdf'.
    s2 := ftp get:'download/wartungsvertrag.pdf'.

    ftp close.

    Transcript showCR:'Size of wartungsvertrag.pdf (binary fetch): ', s1 size printString.
    Transcript showCR:'Size of wartungsvertrag.pdf (binary fetch): ', s2 size printString.
    self assert:(s1 = s2).

    "
     self debug:#test_12_Get2
    "
!

test_12a_Get2Active
    "two gets"

    |ftp s1 s2|

    ftp := self newFtpConnection.
    ftp passiveMode:false.
    s1 := ftp get:'download/wartungsvertrag.pdf'.
    s2 := ftp get:'download/wartungsvertrag.pdf'.

    ftp close.

    Transcript showCR:'Size of wartungsvertrag.pdf (binary fetch): ', s1 size printString.
    Transcript showCR:'Size of wartungsvertrag.pdf (binary fetch): ', s2 size printString.
    self assert:(s1 = s2).

    "
     self debug:#test_12a_Get2Active
    "
!

test_12b_Get2Passive
    "two gets"

    |ftp s1 s2|

    ftp := self newFtpConnection.
    ftp passiveMode:true.
    s1 := ftp get:'download/wartungsvertrag.pdf'.
    s2 := ftp get:'download/wartungsvertrag.pdf'.

    ftp close.

    Transcript showCR:'Size of wartungsvertrag.pdf (binary fetch): ', s1 size printString.
    Transcript showCR:'Size of wartungsvertrag.pdf (binary fetch): ', s2 size printString.
    self assert:(s1 = s2).

    "
     self debug:#test_12b_Get2Passive
    "
!

test_13_Size
    |ftp size fileContents|

    ftp := self newFtpConnection.
    ftp binary.
    size := ftp sizeOf:'download/wartungsvertrag.pdf'.
    fileContents := ftp get:'download/wartungsvertrag.pdf'.
    ftp close.

    Transcript show:'Size of download/wartungsvertrag.pdf: '; showCR:size.

    self assert:size = fileContents size.

    "
     self debug:#test_13_Size
    "
!

test_14_Put2
    |ftp s|

    "/ this test fails for most servers - they do not allow putting files.
    "/ change to a server you know to allow writing (or a local one)
    "/ and uncomment.
    FtpHost isNil ifTrue:[^ self].

    ftp := self newFtpConnection.

    ftp ascii.

    s := ftp putStreamFor:'testfile1'.
    s nextPutLine:'1-this is line 1'.
    s nextPutLine:'1-this is line 2'.
    s nextPutLine:'1-this is the last line'.
    s close.

    s := ftp putStreamFor:'testfile2'.
    s nextPutLine:'2-this is line 1'.
    s nextPutLine:'2-this is line 2'.
    s nextPutLine:'2-this is the last line'.
    s close.

    ftp close.

    "
     self debug:#test_14_Put2
    "
!

xtest_15_TerminateConnect1
    |p|

    p := [ self test_01_Connect ] newProcess.
    p resume.
    Delay waitForSeconds:0.01.
    p interruptWith:[ p terminate ].

    "
     self debug:#test_15_TerminateConnect1
'' printCR
Socket debug:true
    "
!

xtest_16_TerminateConnect2
    |p|

    p := [ self test_01_Connect ] newProcess.
    p resume.
    Delay waitForSeconds:0.02.
    p terminate.

    "
     self debug:#test_16_TerminateConnect2
'' printCR
Socket debug:true
    "
! !

!FTPClientTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/tests/RegressionTests__FTPClientTest.st,v 1.2 2016-05-30 15:20:03 cg Exp $'
! !

