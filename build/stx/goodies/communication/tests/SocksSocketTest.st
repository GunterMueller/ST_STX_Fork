"{ Package: 'stx:goodies/communication/tests' }"

TestCase subclass:#SocksSocketTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Net-Communication-SOCKS'
!

!SocksSocketTest class methodsFor:'documentation'!

documentation
"
    documentation to be added.

    [author:]
	cg

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!SocksSocketTest methodsFor:'initialize / release'!

setUp
    "common setup - invoked before testing."

    super setUp
!

tearDown
    "common cleanup - invoked after testing."

    super tearDown
! !

!SocksSocketTest methodsFor:'tests'!

test01_connect
    |sock|

    sock := SocksSocket new socks5 connectToHostNamed:'71.105.237.142' port:35867.
self halt.
    sock close.

    "
     self run:#test01_connect
     self new test01_connect
    "

    "Created: / 27-12-2011 / 14:28:19 / cg"
! !

!SocksSocketTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/tests/SocksSocketTest.st,v 1.2 2016-05-02 15:41:09 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/tests/SocksSocketTest.st,v 1.2 2016-05-02 15:41:09 cg Exp $'
! !
