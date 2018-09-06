"
 Copyright (c) 2007-2010 Jan Vrany
 Copyright (c) 2009-2010 eXept Software AG

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
"{ Package: 'stx:libsvn' }"

"{ NameSpace: SVN }"

BranchCommand subclass:#LogCommand
        instanceVariableNames:'path limit'
        classVariableNames:''
        poolDictionaries:''
        category:'SVN-Private-Commands'
!

!LogCommand class methodsFor:'documentation'!

copyright
"
 Copyright (c) 2007-2010 Jan Vrany
 Copyright (c) 2009-2010 eXept Software AG

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

!LogCommand class methodsFor:'others'!

version_CVS
    ^ '$Header$'
! !

!LogCommand methodsFor:'accessing'!

limit
    ^ limit
!

limit:something
    limit := something.
!

path
    ^ path
!

path:aString
    path := aString.
! !

!LogCommand methodsFor:'executing - private'!

svnCmd
    "raise an error: must be redefined in concrete subclass(es)"

    ^'log'

    "Created: / 11-04-2008 / 13:25:11 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

svnCmdArgumentsOn: args 
    args
        nextPut: '--verbose';
        nextPut: '--xml'.
    limit notNil ifTrue:[
        args nextPut: '--limit'.
        args nextPut: limit printString.
    ].
    revision notNil ifTrue:[
        args nextPut: '--revision'.
        args nextPut: revision printString.        
    ].
    args
        nextPut: self url , '/' , path

    "Created: / 11-04-2008 / 13:25:04 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-08-2009 / 10:02:30 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified (format): / 15-10-2011 / 16:58:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

svnParseXML: doc 
    ^ (doc root / 'logentry') asCollection 
        collect: [:entryNode | RevisionLogEntry readFromXml: entryNode ]

    "Created: / 11-04-2008 / 13:26:20 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-04-2008 / 18:48:52 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

svnProcessCommandOutput:out err:err 
    ^ self svnParseXML:((XML::XMLParser on:out)
                validate:false;
                scanDocument)

    "Created: / 03-10-2008 / 16:31:45 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!LogCommand class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_SVN
    ^ '§Id: SVN__LogCommand.st 392 2011-10-15 15:23:37Z vranyj1 §'
! !
