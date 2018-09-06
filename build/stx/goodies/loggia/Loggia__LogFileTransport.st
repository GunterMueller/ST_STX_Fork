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

PlainFileTransport subclass:#LogFileTransport
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'System-Support-Loggia-Transports'
!

!LogFileTransport class methodsFor:'documentation'!

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

!LogFileTransport methodsFor:'initialization'!

initialize

    super initialize.

    renewal := false.
    reopen := false

    "Created: / 05-05-2005 / 16:35:14 / masca"
! !

!LogFileTransport methodsFor:'private'!

printMessage:aLogMessage
    aLogMessage printFullOn:stream.
    stream
	cr;
	nextPutAll:'===============================';
	cr;
	flush.

    "Created: / 25-12-2008 / 12:06:00 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!LogFileTransport methodsFor:'testing'!

isFileTransport
    ^ true

    "Modified: / 20-05-2005 / 11:46:14 / masca"
!

isSetUp

    ^filename notEmptyOrNil

    "Modified: / 20-05-2005 / 11:45:59 / masca"
! !

!LogFileTransport methodsFor:'utilities'!

storeConfigurationOf: aString on: aStream

    super storeConfigurationOf: aString on: aStream.

    filename ifNotNil: [
	self to: aString send: 'filename:' with: filename asString storeString on: aStream].
    self to: aString send: 'renewal:' with: renewal on: aStream.
    self to: aString send: 'reopen:' with: reopen on: aStream

    "Created: / 05-05-2005 / 16:53:24 / masca"
! !

!LogFileTransport class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/loggia/Loggia__LogFileTransport.st,v 1.3 2014-07-01 10:21:10 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/loggia/Loggia__LogFileTransport.st,v 1.3 2014-07-01 10:21:10 cg Exp $'
!

version_SVN
    ^ '§Id: Loggia__LogFileTransport.st 20 2011-09-01 15:04:29Z vranyj1 §'
! !
