"
 COPYRIGHT (c) 2002 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:goodies/communication' }"

"{ NameSpace: Smalltalk }"

Object subclass:#NVTClient
	instanceVariableNames:'connection domain portNr userName password hostName lastResponse
		lastReplyCode responseLines responseTimeout connectionTimeout
		replyPending'
	classVariableNames:'NetErrorSignal ConnectFailedSignal LoginFailedSignal
		CommandErrorSignal UnimplementedOperationErrorSignal
		TransmissionErrorSignal TimeoutErrorSignal Verbose
		DefaultResponseTimeout CRLF SUCCESS ERROR INFORMATION'
	poolDictionaries:''
	category:'Net-Communication-Support'
!

!NVTClient class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2002 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

documentation
"
    Abstract superclass for Network Virtual Terminal protocol clients;
    i.e. FTPCLient, SMTPClient, TelnetClient etc..

    [author:]
        Claus Gittinger

    [see also:]
        FTPClient
        appropriate RFC's
"
! !

!NVTClient class methodsFor:'instance creation'!

connectTo:host
    "open a connection to some host as anonymous user"

    ^ self new connectTo:host

    "Created: 24.3.1997 / 11:29:33 / cg"
    "Modified: 29.3.1997 / 13:17:21 / cg"
!

new
    "return a new ftpClient instance"

    ^ self basicNew initialize

    "Created: 29.3.1997 / 13:17:16 / cg"
!

openOnHostNamed:host
    "open a connection to some host; do not login"

    ^ self new connectToHost:host

    "Created: / 25-11-2011 / 11:20:50 / cg"
! !

!NVTClient class methodsFor:'Signal constants'!

commandErrorSignal
    "return the parent of all errors related to command execution"

    ^ CommandErrorSignal

    "Modified: 25.3.1997 / 10:50:35 / cg"
    "Created: 25.3.1997 / 10:51:31 / cg"
!

connectFailedSignal
    "return the parent of all errors related to connection setup"

    ^ ConnectFailedSignal

    "Created: 25.3.1997 / 10:46:37 / cg"
    "Modified: 25.3.1997 / 10:50:35 / cg"
!

loginFailedSignal
    "return the signal raised if the login fails"

    ^ LoginFailedSignal

    "Created: 25.3.1997 / 10:46:45 / cg"
    "Modified: 25.3.1997 / 10:50:51 / cg"
!

netErrorSignal
    "return the parent of all net errors"

    ^ NetErrorSignal

    "Modified: 25.3.1997 / 10:50:35 / cg"
    "Created: 25.3.1997 / 10:51:31 / cg"
!

timeoutErrorSignal
    "return the signal raised on response timeout"

    ^ TimeoutErrorSignal

    "Modified: 25.3.1997 / 10:50:35 / cg"
    "Created: 29.3.1997 / 13:14:14 / cg"
!

transmissionErrorSignal
    "return the parent signal related to all data transmission errors"

    ^ TransmissionErrorSignal

    "Modified: 25.3.1997 / 10:50:35 / cg"
    "Created: 25.3.1997 / 10:52:33 / cg"
!

unimplementedOperationErrorSignal
    "return the signal raised if some command is not implemented by
     the partner (should not happen)"

    ^ UnimplementedOperationErrorSignal

    "Modified: 25.3.1997 / 10:50:35 / cg"
    "Created: 25.3.1997 / 10:52:11 / cg"
! !

!NVTClient class methodsFor:'class initialization'!

initialize
    CRLF := String with:(Character return) with:(Character nl).
    SUCCESS := #SUCCESS.
    ERROR   := #ERROR.
    INFORMATION := #INFORMATION.

    Verbose := false.
    "Verbose := true."
    DefaultResponseTimeout := 30.

    NetErrorSignal isNil ifTrue:[
        NetErrorSignal := ErrorSignal newSignalMayProceed:false.
        NetErrorSignal nameClass:self message:#ftpErrorSignal.
        NetErrorSignal notifierString:'Network client error'.

        ConnectFailedSignal := NetErrorSignal newSignalMayProceed:false.
        ConnectFailedSignal nameClass:self message:#connectFailedSignal.
        ConnectFailedSignal notifierString:'Network client: connect failed'.

        LoginFailedSignal := ConnectFailedSignal newSignalMayProceed:false.
        LoginFailedSignal nameClass:self message:#loginFailedSignal.
        LoginFailedSignal notifierString:'Network client: login failed:'.

        CommandErrorSignal := NetErrorSignal newSignalMayProceed:false.
        CommandErrorSignal nameClass:self message:#commandErrorSignal.
        CommandErrorSignal notifierString:'Network client: command failed:'.

        UnimplementedOperationErrorSignal := CommandErrorSignal newSignalMayProceed:false.
        UnimplementedOperationErrorSignal nameClass:self message:#unimplementedOperationErrorSignal.
        UnimplementedOperationErrorSignal notifierString:'Network client: unimplemented operation:'.

        TimeoutErrorSignal := CommandErrorSignal newSignalMayProceed:false.
        TimeoutErrorSignal nameClass:self message:#timeoutErrorSignal.
        TimeoutErrorSignal notifierString:'Network client: response timeout'.

        TransmissionErrorSignal := CommandErrorSignal newSignalMayProceed:false.
        TransmissionErrorSignal nameClass:self message:#transmissionErrorSignal.
        TransmissionErrorSignal notifierString:'Network client: data transmission failed:'.
    ].

    "
     self initialize.
     Verbose := true.
    "

    "Created: 25.3.1997 / 10:36:55 / cg"
    "Modified: 29.3.1997 / 16:48:25 / cg"
! !

!NVTClient class methodsFor:'debugging'!

verbose:aBoolean
    Verbose := aBoolean

    "
     self verbose:false.
     self verbose:true.
    "
! !

!NVTClient class methodsFor:'queries'!

isAbstract
    "Return if this class is an abstract class.
     True is returned here for myself only; false for subclasses.
     Abstract subclasses must redefine this again."

    ^ self == NVTClient.
! !

!NVTClient methodsFor:'accessing'!

password
    ^ password
!

password:something
    password := something.
!

userName: aString
    userName := aString
! !

!NVTClient methodsFor:'connection setup'!

connectTo:host
    "connect to some user as anonymous user"

    self 
        connectTo:host
        port:nil
        user:(userName ? self defaultUser) 
        password:(password ? self defaultPassword).

    "Modified: 24.3.1997 / 11:41:47 / cg"
!

connectTo:host port:portNrOrNil user:user password:pw
    "connect to some host as some user"

    hostName := host.
    portNr := portNrOrNil.
    portNr isNil ifTrue:[
        portNr := self defaultPort
    ].
    userName := user.
    password := pw.
    self doConnect.

    "Created: 24.3.1997 / 11:40:21 / cg"
    "Modified: 24.3.1997 / 11:43:43 / cg"
!

connectTo:host user:user
    "connect to some host as user"

    self 
        connectTo:host
        port:nil
        user:user
        password:(password ? self defaultPassword).

    "Modified: 24.3.1997 / 11:42:41 / cg"
!

connectTo:host user:user password:pw
    "connect to some host as user"

    self 
        connectTo:host 
        port:nil 
        user:user 
        password:pw
!

connectToHost:host
    "open a connection; do not login: - VW compatibility"

    self 
        connectTo:host
        port:nil
        user:nil 
        password:nil.

    "Modified (comment): / 25-11-2011 / 11:20:38 / cg"
!

connectionTimeout:millis
    "set timeout for establishing a connection. If the millis arg is nonNil, stop trying to
     connect after that many milliseconds and raises an exception
    "
    connectionTimeout := millis
!

useIPv4Only
    domain := #AF_INET
!

useIPv6Only
    domain := #AF_INET6
! !

!NVTClient methodsFor:'defaults'!

defaultPassword
    self subclassResponsibility
!

defaultPort
    self subclassResponsibility
!

defaultUser
    self subclassResponsibility
! !

!NVTClient methodsFor:'error handling'!

commandFailed
    ^ CommandErrorSignal raiseErrorString:self errorStringFromResponse

    "Created: 25.3.1997 / 12:03:05 / cg"
    "Modified: 25.3.1997 / 12:15:01 / cg"
!

connectionFailed
    lastResponse notNil ifTrue:[
        ^ ConnectFailedSignal raiseErrorString:self errorStringFromResponse
    ].
    ^ ConnectFailedSignal raise

    "Created: 25.3.1997 / 12:03:05 / cg"
    "Modified: 25.3.1997 / 13:27:27 / cg"
!

errorStringFromResponse
    ^ lastResponse copyFrom:(lastResponse indexOf:Character space ifAbsent:1)

    "Created: 25.3.1997 / 12:15:41 / cg"
!

loginFailed
    ^ LoginFailedSignal raiseErrorString:self errorStringFromResponse

    "Created: 25.3.1997 / 10:56:47 / cg"
    "Modified: 25.3.1997 / 12:15:07 / cg"
!

responseTimeoutError
    ^ TimeoutErrorSignal raise

    "Modified: 25.3.1997 / 12:15:01 / cg"
    "Created: 29.3.1997 / 13:14:49 / cg"
!

unimplementedOperationError
    ^ UnimplementedOperationErrorSignal raiseErrorString:self errorStringFromResponse

    "Modified: 25.3.1997 / 12:15:11 / cg"
    "Created: 27.3.1997 / 14:59:50 / cg"
! !

!NVTClient methodsFor:'initialization'!

initialize
    responseTimeout := DefaultResponseTimeout.
    domain := Socket defaultIpDomainForConnect.
! !

!NVTClient methodsFor:'private - commands & responses'!

clearReplyPending
    replyPending := false.
!

getResponse
    "wait for and read a response.
     Leaves result in lastResponse (ascii) and lastReplyCode (numeric).
     MultiLine responses are collected in responseLines.
     Finally, handleReplyCode (redefinable) is asked to xlate from response code to
     exception (if any) "

    ^ self
        getResponseHandlingReplyCodesWith:[:numericCode | self handleReplyCode:numericCode].
!

getResponseHandlingReplyCodesWith:handleReplyCodeBlock
    "wait for and read a response.
     Leaves result in lastResponse (ascii) and lastReplyCode (numeric).
     MultiLine responses are collected in responseLines.
     Finally, handleReplyCode (redefinable) is asked to xlate from response code to
     exception (if any) "

    |response done replyStatus|

    replyPending := false.    

    [
        Verbose ifTrue:[
            Transcript showCR:'?'.
        ].

        StreamError handle:[:ex |
            TransmissionErrorSignal raiseErrorString:'connection broken'.
            ^ ERROR
        ] do:[
            done := false.
            [done] whileFalse:[
                [connection readWaitWithTimeout:responseTimeout] whileTrue:[
                    self responseTimeoutError.
                ].
                response := connection nextLine.
                response isNil ifTrue:[
                    TransmissionErrorSignal 
                        raiseErrorString:
                                (connection atEnd 
                                    ifTrue:'connection closed by foreign host' 
                                    ifFalse:'connection broken').
                    ^ ERROR
                ].
                Verbose ifTrue:[
                    Transcript showCR:'<- ' , response.
                ].
                [response first isDigit] whileFalse:[
                    responseLines notNil ifTrue:[
                        responseLines add:response.
                    ].
                    Verbose ifTrue:[
                        Transcript showCR:'?'.
                    ].
                    connection readWait.
                    response := connection nextLine.
                    Verbose ifTrue:[
                        Transcript showCR:'<- ' , response.
                    ]
                ].
                (response at:4) == Character space ifTrue:[
                    done := true
                ].
            ].
            lastResponse := response.
        ].

        lastReplyCode := Integer readFrom:response onError:999.

        replyStatus := handleReplyCodeBlock value:lastReplyCode.
        replyStatus == INFORMATION
    ] whileTrue.

    ^ replyStatus
!

handleReplyCode:replyCode
    (replyCode between:100 and:199) ifTrue:[
        "intermediate message; final reply code follows"
        ^ INFORMATION
    ].
    (replyCode between:200 and:299) ifTrue:[
        ^ SUCCESS
    ].
    (replyCode between:300 and:399) ifTrue:[
        "this really means: need more information"
        ^ SUCCESS
    ].

    "/ 400 and above: error

    replyCode == 500 ifTrue:[
        self unimplementedOperationError.
        ^ ERROR
    ].
    replyCode == 530 ifTrue:[
        self loginFailed.
        ^ ERROR
    ].

    self commandFailed.
    ^ ERROR
!

sendCommand:aCommandString
    "send a command, wait for response.
     Leaves result in lastResponse (ascii) and lastReplyCode (numeric)"

    self sendCommandNoWait:aCommandString.
    ^ self getResponse.

    "
     Verbose := true
     Verbose := false
    "
    "
     |ftp|

     ftp := FTPClient new.
     ftp connectTo:'porty' user:'anonymous'.
     ftp sendCommand:'SYST'.
     ftp close
    "
    "
     |ftp|

     ftp := FTPClient new.
     ftp connectTo:'porty' user:'anonymous'.
     ftp sendCommand:'HELP'.
     ftp close
    "

    "Modified: 3.4.1997 / 20:49:16 / cg"
!

sendCommandNoWait:aCommandString
    "send a command, do not wait for response."

    replyPending ifTrue:[
        self getResponse
    ].
    replyPending := false.

    self sendLine:aCommandString.
!

sendLine:aLine
    "send a line with CRLF"

    Verbose ifTrue:[
        Transcript showCR:'-> ' , aLine.
    ].
    StreamError handle:[:ex |
        TransmissionErrorSignal raiseErrorString:'connection broken'.
        ^ self
    ] do:[
        "/ Used to write command-string followed by (separate writes) cr and lf.
        "/ must be sent as a single packet for router to be able to perform
        "/ PORT translation. oops - that was hard to find (nowhere documented).
        connection nextPutAll:(aLine , CRLF).
    ]

    "Created: 24.3.1997 / 20:45:31 / cg"
    "Modified: 2.4.1997 / 12:31:57 / cg"
! !

!NVTClient methodsFor:'private - connection setup'!

close
    "disconnect -  if redefined (to send a BYE message), do not forget to
     invoke me here as well"

    |con|

    (con := connection) notNil ifTrue:[
        self sendGoodByeCommand.
        connection := nil.
        con shutDown.
    ]
!

connection
    ^ connection
!

doConnect
    "connect, using the previously defined userName, password and hostName"

    connection := Socket 
                        newTCPclientToHost:hostName
                        port:portNr
                        domain:domain
                        withTimeout:connectionTimeout.

    connection isNil ifTrue:[
        lastResponse := ' (cannot connect to host)'.
        ^ self connectionFailed.
    ].
    connection buffered:false.

    replyPending := false.

    TransmissionErrorSignal handle:[:ex |
        lastResponse := ' (cannot connect to host)'.
        ^ self connectionFailed.
    ] do:[
        self getInitialConnectResponse.
    ].
    self performLoginSequence.

    "
     FTPClient connectTo:'ftp.exept.de'
    "

    "Created: 24.3.1997 / 11:40:55 / cg"
    "Modified: 28.3.1997 / 21:03:43 / cg"
!

getInitialConnectResponse
    "invoked right after the socket connection has been setup;
     subclass implementation should read all initial hello-bla"

    self subclassResponsibility
!

performLoginSequence
    "invoked after the socket connection has been setup and the initial
     connect response blah has been read.
     A subclass implementation should perform whatever login sequence has to be performed."

    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

sendGoodByeCommand
    "invoked before the socket connection is shutDown.
     A subclass implementation may want to redefine this for a graceful goodBy
     (typically sending a quit-command)"

    "/ intentionally left blank 
! !

!NVTClient methodsFor:'queries'!

isConnected
    ^ connection notNil
! !

!NVTClient class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/NVTClient.st,v 1.23 2017-02-10 10:24:55 cg Exp $'
! !


NVTClient initialize!
