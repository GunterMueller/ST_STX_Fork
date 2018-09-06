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

LogTransport subclass:#InMemoryTransport
	instanceVariableNames:'messages messagesLimit autoProxy dropAttachment'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Support-Loggia-Transports'
!

!InMemoryTransport class methodsFor:'documentation'!

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

!InMemoryTransport methodsFor:'accessing'!

autoProxy
    ^ autoProxy
!

autoProxy: aBoolean

    autoProxy := aBoolean
!

browserUI

    ^LogMessagesBrowserUI on: self

    "Created: / 05-05-2005 / 14:46:33 / masca"
!

configurationUI

    ^InMemoryTransportUI on: self
!

dropAttachment
    ^ dropAttachment
!

dropAttachment: aBoolean

    dropAttachment := aBoolean
!

messages
    ^ messages
!

messagesLimit
    ^ messagesLimit
!

messagesLimit: anIntegerOrNil

    messagesLimit := anIntegerOrNil
! !

!InMemoryTransport methodsFor:'initialization'!

initialize

    super initialize.
    messages := OrderedCollection" List" new.
    messagesLimit := nil "unlimited".
    autoProxy := false.
    dropAttachment := false
! !

!InMemoryTransport methodsFor:'processing'!

process: aLogMessage

    autoProxy ifTrue: [aLogMessage dropOriginator].
    dropAttachment ifTrue: [aLogMessage dropAttachedObject].

    mutex critical: [
	(messagesLimit notNil and: [messages size > messagesLimit])
	    ifTrue: [messages removeFirst: (messages size - messagesLimit)].
	messages addLast: aLogMessage
    ].

    self changed: #messages

    "Modified: / 23-06-2005 / 09:28:45 / masca"
! !

!InMemoryTransport methodsFor:'testing'!

isInMemoryTransport
    ^ true

    "Modified: / 20-05-2005 / 11:46:14 / masca"
! !

!InMemoryTransport methodsFor:'utilities'!

appendMessagesFrom: aFilename

    | boss |
    boss := BinaryObjectStorage onOld: aFilename asFilename readStream.
    [
	[ boss atEnd ] whileFalse:
	    [messages addLast:boss next]
    ] ensure: [boss close].
    self changed: #messages

    "Created: / 17-05-2005 / 17:09:07 / masca"
    "Modified: / 20-05-2005 / 11:38:31 / masca"
!

dropMessages

    messages := OrderedCollection" List" new.
    self changed:#messages.
!

saveMessagesTo: aFilename

    | boss |
    boss := BinaryObjectStorage onNew: aFilename asFilename writeStream.
    [
	messages do:[:m|boss nextPut: m]
    ] ensure: [boss close]

    "Created: / 17-05-2005 / 17:07:10 / masca"
    "Modified: / 20-05-2005 / 11:36:05 / masca"
!

saveMessagesTo: aFilename format: format

    (format == #boss or:[format == #binary]) ifTrue:[
	| boss |
	boss := BinaryObjectStorage onNew: aFilename asFilename writeStream.
	[
	    messages do:[:m|boss nextPut: m]
	] ensure: [
	    boss close
	].
	^self.
    ].

    (format == #text) ifTrue:[
	aFilename asFilename writingFileDo:[:s|
	    messages do:[:m|m printFullOn: s].
	    s cr; nextPutAll: '---'; cr.
	].
	^self.
    ].

    self error:'Unsupported format: ', format

    "Created: / 08-04-2012 / 10:18:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

storeConfigurationOf: aString on: aStream

    super storeConfigurationOf: aString on: aStream.

    self to: aString send: 'messagesLimit:' with: messagesLimit on: aStream.
    self to: aString send: 'autoProxy:' with: autoProxy on: aStream.
    self to: aString send: 'dropAttachment:' with: dropAttachment on: aStream

    "Created: / 05-05-2005 / 16:52:25 / masca"
! !

!InMemoryTransport class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/loggia/Loggia__InMemoryTransport.st,v 1.3 2014-07-01 10:21:10 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/loggia/Loggia__InMemoryTransport.st,v 1.3 2014-07-01 10:21:10 cg Exp $'
!

version_SVN
    ^ '§Id: Loggia__InMemoryTransport.st 20 2011-09-01 15:04:29Z vranyj1 §'
! !
