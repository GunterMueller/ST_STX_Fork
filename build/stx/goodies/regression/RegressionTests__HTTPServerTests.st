"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#HTTPServerTests
	instanceVariableNames:'server'
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression-Services'
!


!HTTPServerTests methodsFor:'initialize / release'!

tearDown
    "common cleanup - invoked after testing."

    server notNil ifTrue:[
	server terminateServer.
	server := nil.
    ].
    super tearDown
! !

!HTTPServerTests methodsFor:'tests'!

test01_startup_shutdown
    |port|

    port := 9876.

    server := HTTPServer newServerOnPort:port.
    self assert:server notNil.
    self assert:server isRunning not.
    self assert:server isServing not.
    self assert:server hasSoapEnabled not.

    server start.
    self assert:server isRunning.

    server waitUntilServing.

    self assert:server isRunning.
    self assert:server isServing.
    self assert:server hasSoapEnabled not.

    server stop.

    server waitUntilStopped.
    self assert:server isServing not.

    server terminateServer.

    self assert:server isRunning not.

    "
     self new test01_startup_shutdown
    "
!

test02_simpleResponses
    |port service response|

    port := 9876.

    server := HTTPServer newServerOnPort:port.
    self assert:server notNil.
    self assert:server isRunning not.
    self assert:server isServing not.
    self assert:server hasSoapEnabled not.

    service := HTTPPluggableActionService new.
    service register:[ :req | req reply:'1' ] as:'one'.
    service register:[ :req | req reply:'2' ] as:'two'.
    service register:[ :req | req reply:'1.1' ] as:'one/one'.
    service registerServiceOn:server.

    self assert:server isRunning not.
    self assert:server isServing not.
    self assert:server hasSoapEnabled not.

    server start.
    self assert:server isRunning.

    server waitUntilServing.

    self assert:server isRunning.
    self assert:server isServing.
    self assert:server hasSoapEnabled not.

    "/ send a request to it

    response := HTTPInterface get:('http://localhost:%1/one' bindWith:port).
    self assert:(response notNil).
    self assert:(response isErrorResponse not).
    self assert:(response data asString = '1').

    response := HTTPInterface get:('http://localhost:%1/two' bindWith:port).
    self assert:(response notNil).
    self assert:(response isErrorResponse not).
    self assert:(response data asString = '2').

    response := HTTPInterface get:('http://localhost:%1/one/one' bindWith:port).
    self assert:(response notNil).
    self assert:(response isErrorResponse not).
    self assert:(response data asString = '1.1').

    server terminateServer.

    "
     self new test02_simpleResponses
    "
!

test03_restResponse
    |port service response object|

    port := 9876.

    server := HTTPServer newServerOnPort:port.
    server debugErrors:true.

    service := HTTPDemoRestService new.
    service linkName:'rest'.
    service registerServiceOn:server.

    server start.
    server waitUntilServing.

    response := HTTPInterface get:('http://localhost:%1/rest/Object/class' bindWith:port).
    self assert:(response notNil).
    self assert:(response isErrorResponse not).

    self assert:(response data notEmpty).
    object := JSONReader fromJSON:response data asString.
    self assert:(object isDictionary).
    self assert:(object at:'Class') = 'Object'.
    self assert:(object at:'Selector') = 'class'.
    self assert:(object at:'Source') asString = (Object compiledMethodAt:#class) source asString.

    "/ verify that the following requests are denied
    response := HTTPInterface post:('http://localhost:%1/rest/Object/class' bindWith:port) with:'foo=1&bar=2'.
    self assert:(response notNil).
    self assert:(response isErrorResponse).

    response := HTTPInterface put:('http://localhost:%1/rest/Object/class' bindWith:port) with:'foo=1&bar=2' contentType:nil.
    self assert:(response notNil).
    self assert:(response isErrorResponse).

    response := HTTPInterface delete:('http://localhost:%1/rest/Object/class' bindWith:port).
    self assert:(response notNil).
    self assert:(response isErrorResponse).

    server terminateServer.

    "
     self new test03_restResponse
    "
! !

!HTTPServerTests class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

