"{ Encoding: utf8 }"

"{ Package: 'stx:goodies/communication/ssdp/tests' }"

"{ NameSpace: Smalltalk }"

TestCase subclass:#SSDPTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Net-Communication-SSDP-Tests'
!

!SSDPTests class methodsFor:'documentation'!

documentation
"
    documentation to be added.

    [author:]
        cg

    [instance variables:]

    [class variables:]

    [see also:]

"
!

examples
"

  more examples to be added:
                                                                [exBegin]
    ... add code fragment for 
    ... executable example here ...
                                                                [exEnd]
"
! !

!SSDPTests methodsFor:'initialize / release'!

setUp
    "common setup - invoked before testing."

    super setUp
!

tearDown
    "common cleanup - invoked after testing."

    super tearDown
! !

!SSDPTests methodsFor:'tests'!

test01_simpleService
    |server|

    server := SSDPServer v4SiteLocal.
    server
            offerServiceType: 'ssdp:testService'
            atLocation: 'http:/test.local/'.

    Delay waitForSeconds:60.
    server shutDown.

    "
     self run:#test01_simpleService
     self new test01_simpleService
    "
!

test02_simpleClient
    |client|

    client := SSDPClient v4SiteLocal.
    client
          filter: 'ssdp:all'
          whenAvailable: [ :resource |
                  resource printOn: Transcript.
                  'is available' printOn: Transcript.
                  Transcript nextPut: Character cr. ]
          whenUnavailable: [ :resource |
                  resource printOn: Transcript.
                  'is becoming unavailable' printOn: Transcript.
                  Transcript nextPut: Character cr.  ].

    "
     self run:#test02_simpleClient
     self new test02_simpleClient
    "
! !

!SSDPTests class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/ssdp/tests/SSDPTests.st,v 1.4 2018-05-14 20:41:40 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/ssdp/tests/SSDPTests.st,v 1.4 2018-05-14 20:41:40 cg Exp $'
! !

