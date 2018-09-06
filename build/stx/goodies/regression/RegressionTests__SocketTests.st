"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#SocketTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression-Streams'
!


!SocketTests methodsFor:'tests - open-close'!

test10_concurrentOpenClose
    |p1 p2 sock host port n1 n2|

    host := 'www.exept.de'.
    port := 80.
    n1 := n2 := 0.

    p1 :=
	[
	    [true] whileTrue:[
		sock := Socket newTCPclientToAddress:host port:port.
		Processor yield.
		n1 := n1 + 1.
		sock close
	    ]
	] newProcess.

    p2 :=
	[
	    [true] whileTrue:[
		sock := Socket newTCPclientToAddress:host port:port.
		Processor yield.
		n2 := n2 + 1.
		sock close
	    ]
	] newProcess.

    p1 resume.
    p2 resume.

    Delay waitForSeconds:20.
    p1 terminate.
    p2 terminate.

    Transcript showCR:'n1: %1; n2: %2' with:n1 with:n2

    "Created: / 29-11-2011 / 14:43:57 / cg"
!

test11_concurrentOpenClose
    "using a non-existing host name (hoping that the connect will take longer then,
     and we can enforce concurrent execution)"

    |p1 p2 sock port n1 n2|

    port := 80.
    n1 := n2 := 0.

    p1 :=
	[
	    |host|

	    [true] whileTrue:[
		host := 'www.nonexisting-%1.de' bindWith:(UUID genRandomUUID).
		HostNameLookupError handle:[:ex |
		] do:[
		    sock := Socket newTCPclientToAddress:host port:port.
		    Processor yield.
		    n1 := n1 + 1.
		    sock close
		].
	    ]
	] newProcess.

    p2 :=
	[
	    |host|

	    [true] whileTrue:[
		host := 'www.nonexisting-%1.de' bindWith:(UUID genRandomUUID).
		HostNameLookupError handle:[:ex |
		] do:[
		    sock := Socket newTCPclientToAddress:host port:port.
		    Processor yield.
		    n2 := n2 + 1.
		    sock close
		]
	    ]
	] newProcess.

    p1 resume.
    p2 resume.

    Delay waitForSeconds:20.
    p1 terminate.
    p2 terminate.

    Transcript showCR:'n1: %1; n2: %2' with:n1 with:n2

    "Created: / 29-11-2011 / 18:17:04 / cg"
! !

!SocketTests methodsFor:'tests - socket address'!

test20_localAddress
    "fails on MAC-osx"

    |addr hostNameFromOS nm|

    OperatingSystem isUNIXlike ifTrue:[
	hostNameFromOS := PipeStream outputFromCommand:'hostname'.
    ].

    addr := IPSocketAddress localHost.
    self assert:(addr hostAddress = #[127 0 0 1]).

    nm := addr hostName.
    self assert:(nm notEmptyOrNil).

    addr := IPSocketAddress addressString:'127.0.0.1'.
    self assert:(addr hostAddress = #[127 0 0 1]).
    addr port:51121.
    nm := addr hostName.
    self assert:(nm notEmptyOrNil).
    self assert:(addr hostAddress = #[127 0 0 1]).
    self assert:(addr port = 51121).
! !

!SocketTests class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

