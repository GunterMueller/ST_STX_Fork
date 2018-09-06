"{ Encoding: utf8 }"

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

LogTransport subclass:#SyslogTransport
	instanceVariableNames:'socket address hostname facility severity'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Support-Loggia-Transports'
!

!SyslogTransport class methodsFor:'documentation'!

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

!SyslogTransport methodsFor:'accessing'!

addressBytes

    ^address hostAddress
!

addressBytes: aByteArray

    address hostAddress: aByteArray
!

configurationUI

    ^SyslogTransportUI on: self
!

facility
    ^ facility
!

facility: anInteger

    facility := anInteger
!

hostname
    ^ hostname
!

hostname: aString

    hostname := aString
!

port

    ^address port
!

port: anInteger

    address port: anInteger
!

severity
    ^ severity
!

severity: anInteger

    severity := anInteger
! !

!SyslogTransport methodsFor:'initialization'!

initialize
    super initialize.

    socket := Socket newUDP.
    address := IPSocketAddress localHost port: 514.

    hostname := 'stx'.
    facility := 16.
    severity := 6

    "Modified (format): / 24-02-2018 / 23:42:56 / stefan"
! !

!SyslogTransport methodsFor:'private'!

messageSize

    ^400
!

printStringOf: aLogMessage
    | stream timeInfo |

    stream := (String new: self messageSize + 30) writeStream.

    stream nextPut: $<.
    self priority printOn: stream.
    stream nextPut: $>.

    timeInfo := aLogMessage timestamp asUtcTimestamp timeInfo.
    stream
        nextPutAll: (#('Jan' 'Feb' 'Mar' 'Apr' 'May' 'Jun' 'Jul' 'Aug' 'Sep' 'Oct' 'Nov' 'Dec') at: timeInfo month);
        space.
    timeInfo day printOn: stream leftPaddedTo: 2 with: Character space.
    stream space.
    timeInfo hours printOn: stream leftPaddedTo: 2 with: $0.
    stream nextPut: $:.
    timeInfo minutes printOn: stream leftPaddedTo: 2 with: $0.
    stream nextPut: $:.
    timeInfo seconds printOn: stream leftPaddedTo: 2 with: $0.

    stream
        space;
        nextPutAll: hostname;
        space.

    stream nextPutAll: (aLogMessage printLimitedTo: self messageSize).

    ^ stream contents

    "Modified (format): / 24-02-2018 / 23:30:42 / stefan"
!

priority

    ^facility * 8 + severity
! !

!SyslogTransport methodsFor:'processing'!

process: aLogMessage

    socket sendTo: address buffer: (self printStringOf: aLogMessage) asByteArray
! !

!SyslogTransport methodsFor:'testing'!

isSetUp

    ^true
!

isSyslogTransport
    ^ true

    "Modified: / 20-05-2005 / 11:46:14 / masca"
! !

!SyslogTransport methodsFor:'utilities'!

storeConfigurationOf: aString on: aStream

    super storeConfigurationOf: aString on: aStream.

    self to: aString send: 'hostname:' with: hostname storeString on: aStream.
    self to: aString send: 'facility:' with: facility on: aStream.
    self to: aString send: 'severity:' with: severity on: aStream

    "Created: / 05-05-2005 / 17:03:34 / masca"
! !

!SyslogTransport class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/loggia/Loggia__SyslogTransport.st,v 1.4 2018-02-24 22:49:24 stefan Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/loggia/Loggia__SyslogTransport.st,v 1.4 2018-02-24 22:49:24 stefan Exp $'
!

version_SVN
    ^ '$Id: Loggia__SyslogTransport.st,v 1.4 2018-02-24 22:49:24 stefan Exp $'
! !

