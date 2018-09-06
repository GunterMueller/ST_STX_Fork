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

LogTransport subclass:#TranscriptTransport
	instanceVariableNames:''
	classVariableNames:'DefaultInstance'
	poolDictionaries:''
	category:'System-Support-Loggia-Transports'
!

!TranscriptTransport class methodsFor:'documentation'!

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

!TranscriptTransport class methodsFor:'accessing'!

default

    DefaultInstance ifNil: [DefaultInstance := self new].
    ^DefaultInstance
!

isSingleton

    ^true
! !

!TranscriptTransport methodsFor:'accessing'!

configurationUI

    ^TransportsUI::SingletonTransportUI on: self
! !

!TranscriptTransport methodsFor:'processing'!

process: aLogMessage

    Transcript isView ifTrue:
	[Transcript
	    beginEntry;
	    color: aLogMessage messageColor].

    Transcript
	nextPutAll: '[' , aLogMessage facility , '!!' , aLogMessage severity asString , ']';
	normal;
	show: aLogMessage printFull;
	cr.
    Transcript isView ifTrue:
	[Transcript
	    endEntry]

    "Modified: / 20-05-2005 / 11:06:41 / masca"
    "Modified: / 14-05-2008 / 14:06:49 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!TranscriptTransport methodsFor:'testing'!

canBeRemoved

    ^false

    "Created: / 05-05-2005 / 14:09:03 / masca"
!

isTranscriptTransport
    ^ true

    "Modified: / 20-05-2005 / 11:46:14 / masca"
! !

!TranscriptTransport class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/loggia/Loggia__TranscriptTransport.st,v 1.2 2014-07-01 10:21:11 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/loggia/Loggia__TranscriptTransport.st,v 1.2 2014-07-01 10:21:11 cg Exp $'
!

version_SVN
    ^ '§Id: Loggia__TranscriptTransport.st 20 2011-09-01 15:04:29Z vranyj1 §'
! !
