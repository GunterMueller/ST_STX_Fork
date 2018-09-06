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

FileTransport subclass:#PlainFileTransport
	instanceVariableNames:'stream reopen'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Support-Loggia-Transports'
!

!PlainFileTransport class methodsFor:'documentation'!

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

!PlainFileTransport class methodsFor:'testing'!

isAbstract
    ^self == Loggia::PlainFileTransport

    "Created: / 12-04-2012 / 19:00:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PlainFileTransport methodsFor:'accessing'!

configurationUI

    ^PlainFileTransportUI on: self

    "Created: / 25-12-2008 / 12:24:17 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

filename: aFilename
    stream notNil ifTrue:[ self closeFile ].
    super filename: aFilename.

    "Created: / 11-04-2012 / 23:16:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

reopen
    ^ reopen

    "Created: / 25-12-2008 / 12:26:47 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

reopen: aBoolean

    reopen := aBoolean

    "Created: / 25-12-2008 / 12:26:47 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!PlainFileTransport methodsFor:'private'!

closeFile
    stream close.
    stream := nil.

    "Created: / 25-12-2008 / 12:02:25 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

openFile
    ^ stream := filename asFilename appendStream

    "Created: / 25-12-2008 / 12:04:47 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

printMessage:arg
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility

    "Created: / 25-12-2008 / 12:06:25 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!PlainFileTransport methodsFor:'processing'!

process:aLogMessage
    mutex
	critical:[
	    stream ifNil:[ self openFile ].
	    self printMessage:aLogMessage.
	    stream flush.
	    reopen ifTrue:[
		self closeFile
	    ]
	]

    "Modified: / 23-06-2005 / 09:27:55 / masca"
    "Created: / 25-12-2008 / 12:06:19 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 11-04-2012 / 23:15:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PlainFileTransport class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/loggia/Loggia__PlainFileTransport.st,v 1.7 2014-07-01 10:21:10 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/loggia/Loggia__PlainFileTransport.st,v 1.7 2014-07-01 10:21:10 cg Exp $'
!

version_SVN
    ^ '§Id: Loggia__PlainFileTransport.st 20 2011-09-01 15:04:29Z vranyj1 §'
! !
