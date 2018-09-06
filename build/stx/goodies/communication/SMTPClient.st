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

NVTClient subclass:#SMTPClient
	instanceVariableNames:'clientHostName'
	classVariableNames:'SMTPErrorSignal'
	poolDictionaries:''
	category:'Net-Communication-SMTP'
!

!SMTPClient class methodsFor:'documentation'!

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
    a very simple SMTP mail client.
    Right now, there are two entries:
        sendMessageString:
            which expects a string argument, containing all of
            the mail info (from lines, subject etc.)
        
        sendMessage:
            which expects a letter object, which itself is able
            to convert itself to a string. At the time of writing,
            such a letter object does not exist,
"
!

examples
"
                                                            [exBegin]
    SMTPClient new
        userName:'sr';
        connectTo:(IPSocketAddress localHost);
        sendMessageString:'this is a test message\.\last line' withCRs 
                to:'stefan.reise@gmx.de';
        close.
                                                            [exEnd]

                                                            [exBegin]
    SMTPClient new
        userName:'cg';
        connectTo:(IPSocketAddress hostName:'exeptn');
        sendMessageString:'This is a test message\.\last line' withCRs 
            withSubject:'testmail' 
            to:'sr@exeptn';
        close.
                                                            [exEnd]


                                                            [exBegin]
    |m|

    m := Net::MailMessage new.
    m 
        from:'stefan.reise@exept.de';
        to:'stefan.reise@gmx.de';
        subject:'Test von stx';
        contents:'Dies ist ein mailtext';
        yourself.

    SMTPClient new
        userName:'stefan.reise';
        password:'rappel72';
        connectTo:(IPSocketAddress hostName:'mail.exept.de');
        sendMessage:m;
        close.
                                                            [exEnd]
"
! !

!SMTPClient class methodsFor:'class initialization'!

initialize
    SMTPErrorSignal isNil ifTrue:[
        SMTPErrorSignal := NetErrorSignal newSignalMayProceed:true.
        SMTPErrorSignal nameClass:self message:#smtpErrorSignal.
        SMTPErrorSignal notifierString:'SMTP:'.
    ].

    "
     self initialize.
    "
! !

!SMTPClient class methodsFor:'signal constants'!

smtpErrorSignal
    ^ SMTPErrorSignal
! !

!SMTPClient methodsFor:'accessing'!

clientHostName
    ^ clientHostName
!

clientHostName:something
    clientHostName := something.
!

passWord
    <resource: #obsolete>
    ^ password
!

passWord:something
    <resource: #obsolete>
    password := something.
! !

!SMTPClient methodsFor:'defaults'!

defaultPassword
    ^ nil 
!

defaultPort
    ^ 25 "/ Socket portOfService:'smtp' 
!

defaultUser
    ^ 'anonymous' 
! !

!SMTPClient methodsFor:'operations'!

help
    "send a 'HELP' command to ask about the partners capabilities.
     Return a collection of help lines."

    |rslt|

    CommandErrorSignal catch:[
        responseLines := OrderedCollection new.
        self sendCommand:'HELP'.
    ].
    (lastReplyCode == 214) ifTrue:[
        rslt := responseLines.
        responseLines := nil.
        ^ rslt asStringCollection
    ].
    ^ nil

    "
     |snmp|

     snmp := SMTPClient new.
     snmp connectTo:'foo' user:'anonymous'.
     Transcript showCR:(snmp help).
     snmp close
    "
!

sendMessage:rfc822Message
    "send an rfc822Message (Net::MailMessage)"

   |receiverLine ccLine bccLine messageText|

    self sendCommand:('MAIL FROM:%<<1s>%>' expandMacrosWith:rfc822Message from first).

    receiverLine := ''.
    ccLine := ''.
    bccLine := ''.

    rfc822Message to do: [:eachReceiver |
        self sendCommand: ('RCPT TO:<%1>' bindWith: eachReceiver).
        receiverLine := receiverLine, ' ', eachReceiver.
    ].

    rfc822Message cc do: [:eachReceiver |
        self sendCommand: ('RCPT TO:<%1>' bindWith: eachReceiver).
        ccLine := ccLine, ' ', eachReceiver.
    ].

    rfc822Message bcc do: [:eachReceiver |
        self sendCommand: ('RCPT TO:<%1>' bindWith: eachReceiver).
        bccLine := bccLine, ' ', eachReceiver.
    ].

    self sendCommand:'DATA'.

    messageText := String streamContents:[:s| rfc822Message sendOn:s].

    messageText asCollectionOfLines do:[:eachLine |
        (eachLine startsWith:$.) ifTrue:[
            self sendLine:('.' , eachLine).
        ] ifFalse:[
            self sendLine:eachLine.
        ]
    ].
    self sendLine:'.'.
!

sendMessage:rfc822Message to:receiver
    "send an rfc822Message"

    self sendMessage:rfc822Message toAll:(Array with:receiver)
!

sendMessage:rfc822Message toAll:receivers
    "send an rfc822Message"

    |previousUserName msgStream|

    previousUserName := userName.

    [
        userName isNil ifTrue:[
            userName := rfc822Message from first
        ].

        msgStream := '' writeStream.
        rfc822Message writeOn:msgStream.

        self sendMessageString:(msgStream contents) toAll:receivers
    ] ensure:[
        userName := previousUserName
    ].
!

sendMessageString:rfc822MessageString to:receiver
    "send an rfc822MessageString"

    self sendMessageString:rfc822MessageString toAll:(Array with:receiver)
!

sendMessageString:rfc822MessageString toAll:receivers 
    "send an rfc822MessageString"
    
    self 
        sendMessageString:rfc822MessageString
        withSubject:nil
        toAll:receivers

    "
     |snmp|

     snmp := SMTPClient new.
     snmp connectTo:'exept'.
     snmp userName:'cg@exept.de'.
     snmp sendMessageString:'this is a test message\.\last line' withCRs to:'cg@exept.de'.
     snmp close"

    "Modified: / 20-09-2007 / 13:58:43 / cg"
!

sendMessageString:rfc822MessageString withSubject:aSubjectString contentType:aContentTypString to:receiver 
    "send an rfc822MessageString"
    
    self 
        sendMessageString:rfc822MessageString
        withSubject:aSubjectString
        contentType:aContentTypString
        toAll:(Array with:receiver)

    "Modified: / 20-09-2007 / 13:58:37 / cg"
!

sendMessageString:rfc822MessageString withSubject:aSubjectString contentType:aContentTypString to:receiver cc:ccReceiver bcc:bccReceiver 
    "send an rfc822MessageString"
    
    |cc bcc|

    ccReceiver notNil ifTrue:[
        cc := Array with:ccReceiver
    ].
    bccReceiver notNil ifTrue:[
        bcc := Array with:bccReceiver
    ].
    self 
        sendMessageString:rfc822MessageString
        withSubject:aSubjectString
        contentType:aContentTypString
        toAll:(Array with:receiver)
        toAllCc:cc
        toAllBcc:bcc

    "Modified: / 20-09-2007 / 13:58:57 / cg"
!

sendMessageString:rfc822MessageString withSubject:aSubjectString contentType:aContentTypString to:receiver fromLabel:fromLabel
    "send an rfc822MessageString"
    
    self 
        sendMessageString:rfc822MessageString
        withSubject:aSubjectString
        contentType:aContentTypString
        toAll:(Array with:receiver)
        fromLabel:fromLabel

    "Modified: / 20-09-2007 / 13:58:37 / cg"
!

sendMessageString:rfc822MessageString withSubject:aSubjectString contentType:aContentTypeString toAll:receivers 
    "send an rfc822MessageString"
    
    self 
        sendMessageString:rfc822MessageString
        withSubject:aSubjectString
        contentType:aContentTypeString
        toAll:receivers
        toAllCc:nil
        toAllBcc:nil

    "Modified: / 20-09-2007 / 13:59:01 / cg"
!

sendMessageString:rfc822MessageString withSubject:aSubjectString contentType:aContentTypeString toAll:receivers fromLabel:fromLabel
    "send an rfc822MessageString"
    
    self 
        sendMessageString:rfc822MessageString
        withSubject:aSubjectString
        contentType:aContentTypeString
        toAll:receivers
        toAllCc:nil
        toAllBcc:nil
        fromLabel:fromLabel
    "Modified: / 20-09-2007 / 13:59:01 / cg"
!

sendMessageString:rfc822MessageString withSubject:aSubjectString contentType:aContentTypeString toAll:receivers toAllCc:ccReceivers toAllBcc:bccReceivers
    self
        sendMessageString:rfc822MessageString 
        withSubject:aSubjectString 
        contentType:aContentTypeString 
        toAll:receivers 
        toAllCc:ccReceivers 
        toAllBcc:bccReceivers 
        fromLabel:userName
!

sendMessageString:rfc822MessageString withSubject:aSubjectString contentType:aContentTypeString toAll:receivers toAllCc:ccReceivers toAllBcc:bccReceivers fromLabel:fromLabel
    "send an rfc822MessageString"

    |receiverLine fromLine ccLine bccLine|

    self sendCommand:('MAIL FROM:%<<1s>%>' expandMacrosWith:userName).

    receiverLine := ''.
    ccLine := ''.
    bccLine := ''.

    receivers do: [:eachReceiver |
        self sendCommand: ('RCPT TO:<%1>' bindWith: eachReceiver).
        receiverLine := receiverLine, ' ', eachReceiver.
    ].

    ccReceivers notEmptyOrNil ifTrue:[
        ccReceivers do: [:eachReceiver |
            self sendCommand: ('RCPT TO:<%1>' bindWith: eachReceiver).
            ccLine := ccLine, ' ', eachReceiver.
        ]
    ].

    bccReceivers notEmptyOrNil ifTrue:[
        bccReceivers do: [:eachReceiver |
            self sendCommand: ('RCPT TO:<%1>' bindWith: eachReceiver).
            bccLine := bccLine, ' ', eachReceiver.
        ]
    ].

    self sendCommand:'DATA'.

    aSubjectString notNil ifTrue:[
        self sendLine:'Subject:', aSubjectString.
    ].             

    fromLabel notEmptyOrNil ifTrue:[
        fromLine := fromLabel.
    ] ifFalse:[
        fromLine := userName.
    ].                 

    self sendLine:'From: ', fromLine.
    self sendLine:'To: ', receiverLine.

    ccReceivers notEmptyOrNil ifTrue:[
        self sendLine:'Cc: ', ccLine.
    ].
"/    not needed ?!!? self sendLine:'Bcc: ', bccLine.

    aContentTypeString notEmptyOrNil ifTrue:[
        self sendLine:'Content-Type: ', aContentTypeString.
    ].

    self sendLine:''.  "/header-content divider

    rfc822MessageString asCollectionOfLines do:[:eachLine |
        (eachLine startsWith:$.) ifTrue:[
            self sendLine:('.' , eachLine).
        ] ifFalse:[
            self sendLine:eachLine.
        ]
    ].
    self sendCommand:'.'.

    "
    |snmp|

     snmp := SMTPClient new.
     snmp connectTo:'bar'.
     snmp userName:'foo@bar.baz'.
     snmp sendMessageString:('this is a test message cc/bcc \.\last line' withCRs) 
          withSubject:'test cc/bcc [4]' 
          contentType:nil 
          toAll:#('foo@bar.baz') 
          toAllCc:#('fooCC@bar.baz') 
          toAllBcc:#('fooBcc@bar.baz').
     snmp close
    "
!

sendMessageString:rfc822MessageString withSubject:aSubjectString to:receiver 
    "send an rfc822MessageString"
    
    self 
        sendMessageString:rfc822MessageString
        withSubject:aSubjectString
        toAll:(Array with:receiver)

    "Modified: / 20-09-2007 / 13:59:11 / cg"
!

sendMessageString:rfc822MessageString withSubject:aSubjectString to:receiver cc:ccReceiver bcc:bccReceiver 
    "send an rfc822MessageString"
    
    self 
        sendMessageString:rfc822MessageString
        withSubject:aSubjectString
        contentType:nil
        toAll:(Array with:receiver)
        toAllCc:(Array with:ccReceiver)
        toAllBcc:(Array with:bccReceiver)

    "Modified: / 20-09-2007 / 13:59:15 / cg"
!

sendMessageString:rfc822MessageString withSubject:aSubjectString toAll:receivers 
    self 
        sendMessageString:rfc822MessageString
        withSubject:aSubjectString
        contentType:nil
        toAll:receivers

    "
     |snmp|

     snmp := SMTPClient new.
     snmp connectTo:'exept'.
     snmp userName:'penk@exept.de'.
     snmp sendMessageString:('this is a test message\.\last line' withCRs) withSubject:'Message from SmalltalkX' to:'penk@exept.de'.
     snmp close
    "

    "Modified: / 20-09-2007 / 13:59:31 / cg"
!

verifyUser:userName
    SMTPErrorSignal handle:[
        ^ false
    ] do:[
        self sendCommand:('VRFY ' , userName).
    ].
    ^ true

    "
     |snmp|

     snmp := SMTPClient new.
     snmp connectTo:'exept'.
     Transcript showCR:(snmp verifyUser:'fooUser').
     snmp close
    "
! !

!SMTPClient methodsFor:'private - commands & responses'!

handleReplyCode:lastReplyCode
    "Raise an error if the last response from the SMTP server has an error."

    lastReplyCode >= 500 ifTrue:[ 
        SMTPErrorSignal raiseErrorString:' ', lastResponse.
        ^ ERROR
    ].
    ^ super handleReplyCode:lastReplyCode
!

sendGoodByeCommand
    self sendCommand:('QUIT').
! !

!SMTPClient methodsFor:'private - connection setup'!

getInitialConnectResponse
    self getResponse
!

performLoginSequence
    "invoked after the socket connection has been setup"

    self sendCommand:('HELO ' , (clientHostName ? connection getFullSocketAddress hostName)).
    password notEmptyOrNil ifTrue:[
        self sendCommand:'AUTH LOGIN '.
        self sendCommand:(Base64Coder encode:userName).
        self sendCommand:(Base64Coder encode:password).
    ].

   "                                                                                                
     |smtp|

     smtp := SMTPClient new.
     smtp connectTo:'exeptn'.
     smtp close
    "
! !

!SMTPClient class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/SMTPClient.st,v 1.23 2018-01-19 22:29:39 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/SMTPClient.st,v 1.23 2018-01-19 22:29:39 cg Exp $'
! !


SMTPClient initialize!
