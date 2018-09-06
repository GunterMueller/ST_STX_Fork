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

PlainFileTransport subclass:#CSVTransport
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'System-Support-Loggia-Transports'
!

!CSVTransport class methodsFor:'documentation'!

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

!CSVTransport methodsFor:'private'!

printMessage:aLogMessage

    self
	nextPutAll: aLogMessage timestamp; comma;
	nextPutAll: aLogMessage severity; comma;
	nextPutAll: aLogMessage facility; comma;
	nextPutAll: aLogMessage originator; comma;
	nextPutAll: aLogMessage message; comma.
    (aLogMessage attachedObject isCollection and:[aLogMessage attachedObject isByteCollection not])
	ifTrue:
	    [aLogMessage attachedObject do:
		[:each|
		self nextPutAll: each; comma]]
	ifFalse:
	    [self nextPutAll: aLogMessage attachedObject; comma].

    self    cr.

    "Created: / 25-12-2008 / 12:06:34 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 29-12-2008 / 18:36:02 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!CSVTransport methodsFor:'streaming'!

comma

    ^self nextPut: $,.

    "Created: / 25-12-2008 / 12:18:59 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

cr

    ^self
	nextPut: Character return;
	nextPut: Character lf

    "Created: / 25-12-2008 / 12:18:27 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

nextPut: aCharacter

    stream nextPut: aCharacter

    "Created: / 25-12-2008 / 12:14:13 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

nextPutAll: anObject

    self nextPutEscapedString:
	(anObject isString
	    ifTrue:[anObject]
	    ifFalse:[anObject printString])

    "Created: / 25-12-2008 / 12:13:52 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

nextPutEscapedString: aString

    stream nextPut: $".

    (aString includes: $")
	ifFalse:
	    [stream nextPutAll: aString]
	ifTrue:
	    [|s|
	    s := aString readStream.
	    [ s atEnd ] whileFalse:
		[|c|
		c := s next.
		(c = $") ifTrue:[stream nextPut: $" ].
		stream nextPut: c]].

    stream nextPut: $".

    "Created: / 25-12-2008 / 12:17:26 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

space

    ^self nextPut: Character space.

    "Created: / 25-12-2008 / 12:17:44 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!CSVTransport class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/loggia/Loggia__CSVTransport.st,v 1.3 2014-07-01 10:21:10 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/loggia/Loggia__CSVTransport.st,v 1.3 2014-07-01 10:21:10 cg Exp $'
!

version_SVN
    ^ '§Id: Loggia__CSVTransport.st 20 2011-09-01 15:04:29Z vranyj1 §'
! !
