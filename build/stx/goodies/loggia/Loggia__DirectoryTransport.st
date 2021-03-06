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

LogTransport subclass:#DirectoryTransport
	instanceVariableNames:'directory prefix suffix'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Support-Loggia-Transports'
!

!DirectoryTransport class methodsFor:'documentation'!

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

!DirectoryTransport methodsFor:'accessing'!

configurationUI

    ^DirectoryTransportUI on: self
!

directory
    ^ directory
!

directory: aStringOrFilename

    directory := aStringOrFilename
!

prefix
    ^ prefix
!

prefix: aString

    prefix := aString
!

suffix
    ^ suffix
!

suffix: aString

    suffix := aString
! !

!DirectoryTransport methodsFor:'initialization'!

initialize

    super initialize.

    prefix := ''.
    suffix := ''
! !

!DirectoryTransport methodsFor:'processing'!

process: aLogMessage

    | name file |
    name := String new writeStream.
    name nextPutAll: prefix.
    aLogMessage timestamp printGeneralizedOn: name.
    name nextPut: $_.
    Random nextInteger printOn: name.
    name nextPutAll: suffix.

    file := (directory asFilename construct: name contents) writeStream.
    aLogMessage printFullOn: file.
    file close

    "Modified: / 20-05-2005 / 10:59:27 / masca"
! !

!DirectoryTransport methodsFor:'testing'!

isDirectoryTransport
    ^ true

    "Modified: / 20-05-2005 / 11:46:14 / masca"
!

isSetUp

    ^directory isEmptyOrNil not and: [directory asFilename exists]
! !

!DirectoryTransport methodsFor:'utilities'!

storeConfigurationOf: aString on: aStream

    super storeConfigurationOf: aString on: aStream.

    directory ifNotNil: [
	self to: aString send: 'directory:' with: directory asString storeString on: aStream].
    self to: aString send: 'prefix:' with: prefix storeString on: aStream.
    self to: aString send: 'suffix:' with: suffix storeString on: aStream

    "Created: / 05-05-2005 / 17:15:14 / masca"
! !

!DirectoryTransport class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/loggia/Loggia__DirectoryTransport.st,v 1.3 2014-07-01 10:21:10 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/loggia/Loggia__DirectoryTransport.st,v 1.3 2014-07-01 10:21:10 cg Exp $'
!

version_SVN
    ^ '�Id: Loggia__DirectoryTransport.st 20 2011-09-01 15:04:29Z vranyj1 �'
! !
