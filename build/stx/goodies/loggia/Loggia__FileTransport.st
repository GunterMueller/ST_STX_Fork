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

LogTransport subclass:#FileTransport
	instanceVariableNames:'filename renewal'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Support-Loggia-Transports'
!

!FileTransport class methodsFor:'documentation'!

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

!FileTransport class methodsFor:'testing'!

isAbstract
    ^self == Loggia::FileTransport

    "Created: / 12-04-2012 / 19:00:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!FileTransport methodsFor:'accessing'!

filename
    ^ filename

    "Created: / 25-12-2008 / 11:54:28 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

filename: aStringOrFilename

    filename := aStringOrFilename

    "Created: / 25-12-2008 / 11:54:28 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

renewal

    ^ renewal

    "Modified: / 05-05-2005 / 16:35:21 / masca"
    "Created: / 25-12-2008 / 11:58:32 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

renewal: aBoolean

    renewal := aBoolean

    "Created: / 25-12-2008 / 11:58:32 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!FileTransport methodsFor:'private'!

closeFile

    ^self subclassResponsibility

    "Created: / 25-12-2008 / 11:59:42 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!FileTransport methodsFor:'processing'!

commit
    | filenameForRotatedLog |


    renewal ifFalse:[
        ^ self
    ].
    mutex
        critical:[
            self closeFile.
            filenameForRotatedLog := String new writeStream.
            filenameForRotatedLog nextPutAll:filename asString.
            filenameForRotatedLog nextPut:$_.
            Timestamp now printGeneralizedOn:filenameForRotatedLog.
            filename := filenameForRotatedLog contents asFilename
        ]

    "Modified: / 23-06-2005 / 09:27:15 / masca"
    "Created: / 25-12-2008 / 12:00:56 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 28-10-2014 / 16:16:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!FileTransport class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/loggia/Loggia__FileTransport.st,v 1.4 2014-10-28 18:09:30 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/loggia/Loggia__FileTransport.st,v 1.4 2014-10-28 18:09:30 vrany Exp $'
!

version_SVN
    ^ '$Id: Loggia__FileTransport.st,v 1.4 2014-10-28 18:09:30 vrany Exp $'
! !

