"
 COPYRIGHT (c) 2005-2011 by Jan Vrany & Martin Dvorak

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the 'Software'), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
"
"{ Package: 'stx:goodies/loggia' }"

"{ NameSpace: Loggia }"

LogTransport subclass:#MailTransport
	instanceVariableNames:'host port user password caching messages receivers subject'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Support-Loggia-Transports'
!

!MailTransport class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2005-2011 by Jan Vrany & Martin Dvorak

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the 'Software'), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
"
! !

!MailTransport methodsFor:'accessing'!

addReceiver: aString

    receivers add: aString
!

caching
    ^ caching
!

caching: aBoolean

    caching := aBoolean
!

configurationUI

    ^MailTransportUI on: self
!

host
    ^ host
!

host: aString

    host := aString
!

messages

    messages ifNil: [messages := OrderedCollection new].
    ^messages
!

password
    ^ password
!

password: aStringOrNil

    password := aStringOrNil
!

port
    ^ port
!

port: anInteger

    port := anInteger
!

receivers
    ^ receivers
!

removeReceiver: aString

    receivers remove: aString ifAbsent: []
!

subject
    ^ subject
!

subject: aString

    subject := aString
!

user
    ^ user
!

user: aString

    user := aString
! !

!MailTransport methodsFor:'initialization'!

initialize

    super initialize.

    host := 'smtp.example.com'.
    port := 25.
    user := 'log@example.com'.
    caching := false.
    receivers := Set new.
    subject := 'log message'
! !

!MailTransport methodsFor:'private'!

addMessage: aLogMessage

    aLogMessage dropOriginator.
    mutex critical: [self messages add: aLogMessage]

    "Modified: / 23-06-2005 / 09:30:03 / masca"
!

cautiouslySendMessages: aCollection

    self isSetUp ifFalse: [^self].

    [
	Error handle: [:ex | ex return] do: [self sendMessages: aCollection]
    ] fork

    "Modified: / 05-05-2005 / 14:43:18 / masca"
!

openCommunicationOn: aSMTPClient

    | receiversLine |
    aSMTPClient sendCommand: ('MAIL FROM:%<<1s>%>' expandMacrosWith: user).

    receiversLine := ''.
    receivers do: [:e |
	aSMTPClient sendCommand: ('RCPT TO:<%1>' bindWith: e).
	receiversLine := receiversLine, ' ', e
    ].
    aSMTPClient sendCommand: 'DATA'.
    aSMTPClient sendLine: 'Subject: ' , subject.
    aSMTPClient sendLine: 'From: ' , user.
    aSMTPClient sendLine: 'To: ' , receiversLine.
    aSMTPClient sendLine: ''.
!

sendMessages: aCollection

    | smtp |
    smtp := SMTPClient new.

    smtp connectTo: host port: port user: user password: password.

    self openCommunicationOn: smtp.

    aCollection
	do: [:message |
	    message printFull asCollectionOfLines do: [:e |
		smtp sendLine: ((e startsWith: $.) ifTrue: ['.' , e] ifFalse: [e])]]
	separatedBy: [smtp sendLine: '=============================='].

    smtp sendLine: '.'.
    smtp close

    "smtp
	sendMessageString: 'LOGMESSAGE'
	withSubject: subject
	toAll: receivers"
! !

!MailTransport methodsFor:'processing'!

commit

    (caching and: [messages isEmptyOrNil not])
	ifTrue: [
	    mutex critical: [
		self cautiouslySendMessages: messages.
		messages := nil
	    ]
	]

    "Modified: / 23-06-2005 / 09:31:01 / masca"
!

process: aLogMessage

    caching
	ifTrue: [self addMessage: aLogMessage]
	ifFalse: [self cautiouslySendMessages: (Array with: aLogMessage)]
!

reset

    messages := nil
! !

!MailTransport methodsFor:'testing'!

isMailTransport
    ^ true

    "Modified: / 20-05-2005 / 11:46:14 / masca"
!

isSetUp

    ^host isEmptyOrNil not
	and: [user isEmptyOrNil not
	and: [receivers isEmpty not
	and: [subject isEmptyOrNil not]]]
! !

!MailTransport methodsFor:'utilities'!

storeConfigurationOf: aString on: aStream

    super storeConfigurationOf: aString on: aStream.

    self to: aString send: 'host:' with: host storeString on: aStream.
    self to: aString send: 'port:' with: port printString on: aStream.
    self to: aString send: 'user:' with: user storeString on: aStream.
    self to: aString send: 'password:' with: password on: aStream.
    self to: aString send: 'caching:' with: caching on: aStream.
    self to: aString send: 'subject:' with: subject storeString on: aStream.
    receivers do: [:e |
	self to: aString send: 'addReceiver:' with: e storeString on: aStream.
    ]

    "Created: / 05-05-2005 / 17:00:30 / masca"
! !

!MailTransport class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/loggia/Loggia__MailTransport.st,v 1.2 2014-07-01 10:21:10 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/loggia/Loggia__MailTransport.st,v 1.2 2014-07-01 10:21:10 cg Exp $'
!

version_SVN
    ^ '§Id: Loggia__MailTransport.st 20 2011-09-01 15:04:29Z vranyj1 §'
! !
