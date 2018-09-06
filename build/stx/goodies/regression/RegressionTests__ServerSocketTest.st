"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#ServerSocketTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression-Streams'
!

!ServerSocketTest class methodsFor:'documentation'!

documentation
"
    documentation to be added.

    [author:]
	james (james@CHANTI)

    [instance variables:]

    [class variables:]

    [see also:]

"
!

history
    "Created: / 21-09-2004 / 14:28:22 / james"
! !

!ServerSocketTest methodsFor:'initialize / release'!

setUp
    "common setup - invoked before testing."

    super setUp
!

tearDown
    "common cleanup - invoked after testing."

    super tearDown
! !

!ServerSocketTest methodsFor:'tests'!

testServerSocket
    "Tests if we can open a server socket"

    |serverListenSocket serverSocket clientSocket|

    serverListenSocket := Socket newTCPserverAtPort:9998.
    self assert:serverListenSocket notNil.
    serverListenSocket listenFor:1.

    clientSocket := Socket newTCPclientToHost:'localhost' port:9998.
    self assert:clientSocket notNil.
    clientSocket buffered:false.
    Transcript showCR:'client: socket connected it'.
    'can now do transfer via sock'.
    Transcript showCR:'sending <hello>'.
    clientSocket nextPutLine:'hello'.

    serverSocket := serverListenSocket accept.
    self assert:serverSocket notNil.
    self assert:(serverSocket nextLine = 'hello').

    clientSocket close.
    serverSocket close.
    serverListenSocket close.



    "
     self run:#test1
     self new test1
    "
! !

!ServerSocketTest class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

