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

LogTransport subclass:#SMSTransport
	instanceVariableNames:'numbers prefix'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Support-Loggia-Transports'
!

!SMSTransport class methodsFor:'documentation'!

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

!SMSTransport methodsFor:'accessing'!

addNumber: aString

    numbers add: aString
!

configurationUI

    self shouldImplement
!

numbers
    ^ numbers
!

prefix
    ^ prefix
!

prefix: aString

    prefix := aString
!

removeNumber: aString

    numbers remove: aString ifAbsent: []
! !

!SMSTransport methodsFor:'private'!

sendSMS: messageString to: numberString

    self shouldImplement
! !

!SMSTransport methodsFor:'processing'!

process: aLogMessage

    | message |
    message := prefix , ':' , (aLogMessage printLimitedTo: 150 - prefix size).
    numbers do: [:e | self sendSMS: message to: e]
! !

!SMSTransport methodsFor:'testing'!

isSMSTransport
    ^ true

    "Modified: / 20-05-2005 / 11:46:14 / masca"
!

isSetUp

    ^false
    "^numbers isEmpty not"
! !

!SMSTransport methodsFor:'utilities'!

storeConfigurationOf: aString on: aStream

    super storeConfigurationOf: aString on: aStream.

    self to: aString send: 'prefix:' with: prefix storeString on: aStream.
    numbers do: [:e |
	self to: aString send: 'addNumber:' with: e storeString on: aStream]

    "Created: / 05-05-2005 / 17:03:11 / masca"
! !

!SMSTransport class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/loggia/Loggia__SMSTransport.st,v 1.3 2014-07-01 10:21:10 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/loggia/Loggia__SMSTransport.st,v 1.3 2014-07-01 10:21:10 cg Exp $'
!

version_SVN
    ^ '§Id: Loggia__SMSTransport.st 20 2011-09-01 15:04:29Z vranyj1 §'
! !
