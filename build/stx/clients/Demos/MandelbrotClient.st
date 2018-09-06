"{ NameSpace: Demos }"

Object subclass:#MandelbrotClient
	instanceVariableNames:'socket clientSpeed'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-Graphics'
!


!MandelbrotClient class methodsFor:'instance creation'!

forHost:aHostName
    ^ self new connectToHost:aHostName

    "Created: / 15.7.1998 / 16:59:41 / cg"
! !

!MandelbrotClient methodsFor:'private'!

readLine
    |waiting l c|

    l := '' writeStream.
    [true] whileTrue:[
        waiting := true.
        [waiting] whileTrue:[
"/            'MandelClient [info]: wait' infoPrintCR.
            waiting := socket readWaitWithTimeoutMs:2000.
        ].
"/        'MandelClient [info]: read' infoPrintCR.
        c := socket next.
        (c == Character return 
        or:[c == Character nl]) ifTrue:[
            ^ l contents
        ].
        l nextPut:c.
    ].

    "Modified: / 15.7.1998 / 17:53:12 / cg"
!

requestWithReply:requestString
    "send a request to the server, wait for an answer.
     Return nil for error-reply, non-nil is the returned value."

    |answer s|

    socket writeWait.
    'MandelClient [info]: sending: ' infoPrint. requestString infoPrintCR.
    socket nextPutLine:requestString.
    socket flush.

    'MandelClient [info]: read' infoPrintCR.
    answer := self readLine.
    'MandelClient [info]: received: ' infoPrint. answer infoPrintCR.
    (answer startsWith:$-) ifTrue:[^ nil].
    s := answer readStream.
    s next.
    ^ Object readFrom:s onError:nil.

    "Created: / 15.7.1998 / 17:06:25 / cg"
    "Modified: / 15.7.1998 / 17:26:37 / cg"
! !

!MandelbrotClient methodsFor:'requests'!

computeRowAtR:r iFrom:iMin to:iMax n:nI threshold:threshold iterations:maxCount
    "send a computation request to the server;
     return the iteration count data as an integerArray"

    |answer|

    answer := self requestWithReply:
                        'computeRowAtR:' , r storeString 
                        , 'iFrom:' , iMin storeString
                        , 'to:' , iMax storeString
                        , 'n:' , nI storeString
                        , 'threshold:' , threshold storeString
                        , 'iterations:' , maxCount storeString.

    answer isNil ifTrue:[
        self error:'error reply from request'.
        ^ nil
    ].
    ^ answer.

    "
     |client result|

     client := self forHost:'localhost'.
     result := client computeRowAtR:-2 iFrom:-4 to:4 n:100 threshold:100 iterations:40.
     client shutDown.
     result inspect.
    "

    "Modified: / 15.7.1998 / 17:53:40 / cg"
    "Created: / 15.7.1998 / 17:57:42 / cg"
!

serverSpeedTest
    "send a speed-test request to the server,
     and remember the speed. This can be used to distribute requests
     equally among servers."

    |answer best|

    best := 0.
    5 timesRepeat:[
        answer := self requestWithReply:'speedTest'.
        answer isNil ifTrue:[
            self error:'error reply from request'.
            ^ self
        ].
        best := best max:answer.
    ].
    clientSpeed := best.

    "
     |client|

     client := self forHost:'localhost'.
     client inspect.
     client shutDown
    "

    "Modified: / 18.8.1998 / 17:47:49 / cg"
! !

!MandelbrotClient methodsFor:'startup'!

connectToHost:aHostName
    socket := Socket newTCPclientToHost:aHostName port:(MandelbrotServer defaultPortNumber).
    socket isNil ifTrue:[^ nil].
    socket buffered:false.

    self serverSpeedTest.

    "Modified: / 15.7.1998 / 17:17:19 / cg"
!

shutDown
    socket shutDown.
    socket := nil.

    "Created: / 15.7.1998 / 17:07:17 / cg"
! !

!MandelbrotClient class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/MandelbrotClient.st,v 1.2 1998-08-18 15:48:16 cg Exp $'
! !
