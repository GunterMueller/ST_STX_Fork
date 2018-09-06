"
 COPYRIGHT (c) 1995 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 This is a demo example:

 THIS SOFTWARE IS PROVIDED BY THE CONTRIBUTOR ``AS IS'' AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED.  IN NO EVENT SHALL THE CONTRIBUTOR BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 SUCH DAMAGE.
"

MailHandler subclass:#POPMailHandler
	instanceVariableNames:'connection isPop3 hostName password'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-MailTool'
!

!POPMailHandler  class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1995 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 This is a demo example:

 THIS SOFTWARE IS PROVIDED BY THE CONTRIBUTOR ``AS IS'' AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED.  IN NO EVENT SHALL THE CONTRIBUTOR BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 SUCH DAMAGE.
"
!

documentation
"
    handles mail via a POP3 server (see RFC 1225).
    Set either the shell environment variable MAILSERVER
    or the smalltalk global MAILSERVER to the name of your
    mail host for the MailView to use the POPMailHandler.
"
!

examples
"
    Smalltalk at:#MAILSERVER put:'localhost'.
    MailView open
"
! !

!POPMailHandler  class methodsFor:'instance creation'!

forHost:aHostName
    ^ self new forHost:aHostName

    "Created: 16.11.1995 / 20:54:09 / cg"
! !

!POPMailHandler methodsFor:'accessing'!

deleteMail:mailNr
    (deletedMessages includes:mailNr) ifFalse:[
	deletedMessages add:mailNr.
    ].
    self halt.

    "Created: 16.11.1995 / 22:52:11 / cg"
!

fullLetterText:mailNr
    |lines s|

    self send:'RETR ' , mailNr printString.
    (s := self getResponseString) isNil ifTrue:[
	connection notNil ifTrue:[
	    self send:'RETR ' , mailNr printString.
	    s := self getResponseString
	].
	s isNil ifTrue:[
	    ^ nil
	].
    ].
    (self isOk:s) ifFalse:[
	self warn:'error :' , s.
	^ nil
    ].
    lines := self getMultilineAnswer.
    ^ lines

    "Created: 16.11.1995 / 22:52:11 / cg"
    "Modified: 17.11.1995 / 11:18:05 / cg"
!

headerText:mailNr
    |s lines idx|

    cachedHeaderNr == mailNr ifTrue:[
	^ cachedHeader
    ].

    self send:'TOP ' , mailNr printString, ' 1'.
    (s := self getResponseString) isNil ifTrue:[^ headerLines].
    (self isOk:s) ifFalse:[
	self warn:'error :' , s.
	^ headerLines
    ].
    lines := self getMultilineAnswer.
    idx := lines findFirst:[:l | l isEmpty].
    idx ~~ 0 ifTrue:[
	lines := lines copyTo:(idx - 1)
    ].

    cachedHeaderNr := mailNr.
    cachedHeader := lines.
    ^ lines.

    "Created: 17.11.1995 / 10:14:23 / cg"
    "Modified: 17.11.1995 / 14:19:53 / cg"
! !

!POPMailHandler methodsFor:'initialization'!

forHost:aHostName
    |username passwd|

    connection := Socket newTCPclientToHost:aHostName port:'pop3'.
    connection isNil ifTrue:[
        connection := Socket newTCPclientToHost:aHostName port:'pop2'.
        connection isNil ifTrue:[
            self warn:'no pop service on ' , aHostName.
            ^ nil
        ].
        isPop3 := false.
    ] ifFalse:[
        isPop3 := true.
    ].
    connection buffered:false.
    connection useCRLF:true.

    (self getGreeting) ifFalse:[
        connection close.
        ^ nil
    ].

    username := OperatingSystem getLoginName.
    password := EnterBox requestPassword:('enter password for ', username, '@' , aHostName).
    password isNil ifTrue:[
        connection close.
        ^ nil
    ].

    (self sendHello:username password:password) ifFalse:[
        connection close.
        ^ nil
    ].

    hostName := aHostName.
    ^ self

    "
     (Smalltalk at:#MAILHOST put:'andi'). MailView open
     (Smalltalk at:#MAILHOST put:'exept'). MailView open
     (Smalltalk at:#MAILHOST put:'atzi'). MailView open
     (Smalltalk at:#MAILHOST put:'andi'). MailView open

     POPMailHandler forHost:'exept'
     POPMailHandler forHost:'sgi'
     POPMailHandler forHost:'andi'
     POPMailHandler forHost:'atzi'
     Socket newTCPclientToHost:'exept' port:'pop3'.
     Socket newTCPclientToHost:'exept' port:'pop2'.
    "

    "Created: 16.11.1995 / 21:01:44 / cg"
    "Modified: 17.11.1995 / 11:15:45 / cg"
    "Modified: 5.9.1996 / 13:19:54 / stefan"
!

initialize
    "initialize myself - scan through mailfile - get letter-positions"

    anyChanges := false.

    "Created: 16.11.1995 / 20:54:48 / cg"
!

reconnect
    isPop3 ifTrue:[
	connection := Socket newTCPclientToHost:hostName port:'pop3'.
    ] ifFalse:[
	connection := Socket newTCPclientToHost:hostName port:'pop2'.
    ].

    connection isNil ifTrue:[
	self warn:'could not reconnect to ' , hostName.
	^ false
    ].
    connection buffered:false.
    connection useCRLF:true.

    (self getGreeting) ifFalse:[
	connection close.
	^ false
    ].

    (self sendHello:(OperatingSystem getLoginName) password:password) ifFalse:[
	connection close.
	^ false
    ].

    ^ true

    "Created: 17.11.1995 / 11:14:44 / cg"
    "Modified: 17.11.1995 / 16:55:08 / cg"
!

release
    connection notNil ifTrue:[
	self sendQuit.
	connection close.
	connection := nil
    ].

    "Created: 17.11.1995 / 13:12:02 / cg"
    "Modified: 17.11.1995 / 16:55:31 / cg"
! !

!POPMailHandler methodsFor:'misc'!

getGreeting
    |s|

    connection readWaitWithTimeout:15.
    (s := connection nextLine) isNil ifTrue:[
	self warn:'mail service does not respond (no ' , (isPop3 ifTrue:'pop3' ifFalse:'pop2') , ' greeting)'.
	^ false
    ].
    Transcript showCR:'connected with: ' , s.
"/    Transcript show:'<< '; showCR:s.
"/    self information:'connected with: ' , s.
    ^ true

    "Created: 16.11.1995 / 21:52:15 / cg"
    "Modified: 16.11.1995 / 22:44:35 / cg"
!

getMultilineAnswer
    |lines line|

    lines := OrderedCollection new.
    [true] whileTrue:[
	line := self getResponseString.
	line = '.' ifTrue:[
	    ^ lines
	].
	(line startsWith:'..') ifTrue:[
	    line := line copyFrom:2
	].
	lines add:line
    ].

    "Created: 16.11.1995 / 23:56:42 / cg"
    "Modified: 17.11.1995 / 00:03:23 / cg"
!

getResponseCode
    |code lastResponse|

    lastResponse := self getResponseString.
    lastResponse notNil ifTrue:[
"        lastResponse printNewline.     "
	code := Number readFromString:lastResponse       
    ].
    ^ code

    "Created: 16.11.1995 / 20:59:30 / cg"
    "Modified: 16.11.1995 / 21:41:10 / cg"
!

getResponseString
    |lastResponse|

    connection isNil ifTrue:[^ nil].

    (connection readWaitWithTimeout:30) ifTrue:[^ nil].
    lastResponse := connection nextLine.
    lastResponse isNil ifTrue:[
	self warn:'mail service closed connection'.
	^ nil.
    ].
"/    Transcript show:'<< '; showCR:lastResponse.
    ^ lastResponse

    "Created: 16.11.1995 / 20:59:30 / cg"
    "Modified: 17.11.1995 / 11:17:23 / cg"
!

isOk:aResponse
    aResponse isNil ifTrue:[^ false].
    isPop3 ifTrue:[
	^ aResponse startsWith:'+OK'
    ].
    ^ false.

    "Created: 16.11.1995 / 22:13:56 / cg"
!

scanMailFile
    headerLines := nil.
    ^ self

    "Created: 17.11.1995 / 10:34:37 / cg"
    "Modified: 17.11.1995 / 12:41:17 / cg"
!

send:aCommandString
    |retryCount|

    connection isNil ifTrue:[^ false].

    Transcript show:'>> '; showCR:aCommandString.

    retryCount := 0.
    PipeStream brokenPipeSignal handle:[:ex |
	connection close.
	connection := nil.
	retryCount > 3 ifFalse:[
	    retryCount := retryCount + 1.
	    (self reconnect) ifTrue:[
		self information:'mail connection broken - reconnected'.
	    ]. 
	    ex restart
	].
	self warn:'mail connection broken'.
	^ false.
    ] do:[
       connection nextPutLine:aCommandString.
    ].
    ^ true.

    "Created: 16.11.1995 / 22:04:29 / cg"
    "Modified: 17.11.1995 / 12:42:13 / cg"
!

sendHello:username password:passwd
    |s numberOfLetters|

    isPop3 ifTrue:[
        self send:'USER ' , username.
        (s := self getResponseString) isNil ifTrue:[^ false].
        (self isOk:s) ifFalse:[
            self warn:'mail service error: ' , s.
            ^ false.
        ].

        self send:'PASS ' , passwd.
        (s := self getResponseString) isNil ifTrue:[^ false].
        (self isOk:s) ifFalse:[
            self warn:'mail service error: ' , s.
            ^ false.
        ].
        ^ true
    ].

    self send:'HELO ' , username , ' ', passwd.
    s := self getResponseString.
    s isNil ifTrue:[
        self warn:'mail service closed connection'.
        ^ false.
    ].
    (s startsWith:'-') ifTrue:[
        self warn:'mail service refused; reason: ' , (s copyFrom:3).
        ^ false
    ].
    numberOfLetters := Integer readFrom:(s copyFrom:2) onError:0.
    ^ true

    "Created: 16.11.1995 / 21:03:56 / cg"
    "Modified: 16.11.1995 / 22:16:14 / cg"
    "Modified: 5.9.1996 / 11:19:30 / stefan"
!

sendQuit
    |s|

    self send:'QUIT'.
    isPop3 ifTrue:[
	(s := self getResponseString) isNil ifTrue:[^ false].
	(self isOk:s) ifFalse:[
	    self warn:'mail service error: ' , s.
	    ^ false.
	].
	^ true
    ].

    ^ (self getResponseCode == 221)

    "Created: 16.11.1995 / 21:03:56 / cg"
    "Modified: 17.11.1995 / 13:12:47 / cg"
! !

!POPMailHandler methodsFor:'queries'!

numberOfLetters
    "answer the number of letters in mail"

    |s words|

    self send:'STAT'.
    (s := self getResponseString) isNil ifTrue:[^ 0].
    (self isOk:s) ifFalse:[
	self warn:'error :' , s.
	^ 0
    ].
    words := s asCollectionOfWords.

    ^ Number readFrom:(words at:2) onError:0

    "Created: 16.11.1995 / 22:12:22 / cg"
    "Modified: 16.11.1995 / 22:51:37 / cg"
! !

!POPMailHandler  class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/MailTool/POPMailHandler.st,v 1.7 1996-09-05 13:00:30 stefan Exp $'
! !
