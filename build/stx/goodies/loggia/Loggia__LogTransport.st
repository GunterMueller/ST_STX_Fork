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

Object subclass:#LogTransport
	instanceVariableNames:'name mutex'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Support-Loggia'
!

!LogTransport class methodsFor:'documentation'!

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

!LogTransport class methodsFor:'instance creation'!

named: aString
    self isSingleton ifTrue:[ 
        self error: 'Cannot set name of singleton trasports'.
    ].
    ^ self new 
        name:aString;
        yourself.

    "Created: / 23-09-2014 / 11:03:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

new
    ^ self basicNew initialize.

    "Created: / 23-06-2005 / 09:22:28 / masca"
! !

!LogTransport class methodsFor:'accessing'!

isSingleton

    ^false
! !

!LogTransport class methodsFor:'testing'!

isAbstract
    ^self == Loggia::LogTransport

    "Created: / 12-04-2012 / 19:00:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!LogTransport methodsFor:'accessing'!

browserUI

    ^nil

    "Created: / 05-05-2005 / 14:46:14 / masca"
!

configurationUI

    ^nil
!

logFacility

    ^Logger systemFacilityName
!

name

    ^name
!

name: aString

    name := aString
! !

!LogTransport methodsFor:'accessing-presentation'!

string

    ^self name

    "Created: / 01-09-2011 / 10:35:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!LogTransport methodsFor:'initialization'!

initialize

    super initialize.
    mutex := Semaphore forMutualExclusion

    "Created: / 23-06-2005 / 09:23:33 / masca"
! !

!LogTransport methodsFor:'printing'!

displayString

    ^name ifNil: ['unnamed: ' , self class name]

    "^LabelAndIcon
	icon: (self isSetUp ifTrue: [nil] ifFalse: [ToolbarIconLibrary fileclose16x16Icon])
	string: (name ifNil: ['unnamed: ' , self class name])"
! !

!LogTransport methodsFor:'private'!

logProcessingError: aString of: aLogMessage
    "An error occurred while processing the given message, log this
    though the logger. The may lead to infinite cycle, use with care."

    Logger
	log: aString
	at: #warn
	for: self
	with: aLogMessage
!

to: variable send: message with: argument on: stream

    stream
	nextPutAll: variable;
	space;
	nextPutAll: message;
	space;
	nextPutAll: argument printString;
	nextPut: $.;
	cr

    "Created: / 05-05-2005 / 16:54:24 / masca"
! !

!LogTransport methodsFor:'processing'!

close
    "Called when the transport is removed. Maybe close some sockets or files."

    ^self
!

commit
    "Commit the transport. This can be used by some transports to commit messages
    that have been received after the last reset. For example, a mail transport can now
    send all cached log messages within one email message."

    ^self
!

process: aLogMessage
    "Process the log message, do what the transport is expected to do..."

    self subclassResponsibility
!

reset
    "Reset the transport. This can be used by some transports, eg. a file transport
    can open a new file for the ongoing messages."

    ^self
! !

!LogTransport methodsFor:'testing'!

canBeRemoved

    ^(Logger transports includes: self) "and: [self class isSingleton not]"
!

isBOSSFileTransport
    ^ false

    "Created: / 20-05-2005 / 11:46:14 / masca"
!

isCustomBlockTransport
    ^ false

    "Modified: / 20-05-2005 / 11:46:14 / masca"
!

isDirectoryTransport
    ^ false

    "Modified: / 20-05-2005 / 11:46:14 / masca"
!

isFileTransport
    ^ false

    "Modified: / 20-05-2005 / 11:46:14 / masca"
!

isHaltingTransport
    ^ false

    "Modified: / 20-05-2005 / 11:46:14 / masca"
!

isInMemoryTransport
    ^ false

    "Modified: / 20-05-2005 / 11:46:14 / masca"
!

isMailTransport
    ^ false

    "Modified: / 20-05-2005 / 11:46:14 / masca"
!

isMultiplexTransport
    ^ false

    "Modified: / 20-05-2005 / 11:46:14 / masca"
!

isNullTransport
    ^ false

    "Modified: / 20-05-2005 / 11:46:14 / masca"
!

isSMSTransport
    ^ false

    "Modified: / 20-05-2005 / 11:46:14 / masca"
!

isSetUp
    "Answers whether the transport is set up, for example a mail
    transport must have SMTP server, multiplex transport must have
    at least one transport to multiplex to, file transport must
    know the filename, etc."

    ^true

    "Modified: / 20-05-2005 / 11:47:35 / masca"
!

isSyslogTransport
    ^ false

    "Modified: / 20-05-2005 / 11:46:14 / masca"
!

isTranscriptTransport
    ^ false

    "Modified: / 20-05-2005 / 11:46:14 / masca"
! !

!LogTransport methodsFor:'utilities'!

storeConfigurationOf: aString on: aStream
    "Store configuration of the receiver that, when evaluated, will configure
    transport with the given name."

    self to: aString send: 'name:' with: name storeString on: aStream

    "Created: / 05-05-2005 / 16:46:56 / masca"
! !

!LogTransport class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/loggia/Loggia__LogTransport.st,v 1.5 2014-09-23 10:59:22 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/loggia/Loggia__LogTransport.st,v 1.5 2014-09-23 10:59:22 vrany Exp $'
!

version_SVN
    ^ '$Id: Loggia__LogTransport.st,v 1.5 2014-09-23 10:59:22 vrany Exp $'
! !

