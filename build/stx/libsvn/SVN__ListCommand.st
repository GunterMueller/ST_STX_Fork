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

BranchCommand subclass:#ListCommand
	instanceVariableNames:'url recursive'
	classVariableNames:''
	poolDictionaries:''
	category:'SVN-Private-Commands'
!

!ListCommand class methodsFor:'documentation'!

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

!ListCommand class methodsFor:'executing'!

list: url 
    ^ (self new)
        url: url;
        execute

    "Created: / 19-03-2008 / 08:27:10 / janfrog"
    "Modified: / 19-08-2009 / 13:28:59 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!ListCommand class methodsFor:'others'!

version_CVS
    ^ '$Header$'
! !

!ListCommand methodsFor:'accessing'!

recursive
    ^ recursive ? false

    "Created: / 15-03-2008 / 20:56:05 / janfrog"
!

recursive:aBoolean
    recursive := aBoolean.

    "Created: / 15-03-2008 / 20:56:05 / janfrog"
!

url
    ^ url ifNil:[ branch url]

    "Modified: / 19-08-2009 / 13:28:35 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

url:aString
    url := aString.
! !

!ListCommand methodsFor:'executing - private'!

svnCmd
    "raise an error: must be redefined in concrete subclass(es)"

    ^'list'

    "Created: / 15-03-2008 / 21:03:32 / janfrog"
!

svnCmdArgumentsOn: argStream 
    self recursive ifTrue: [ argStream nextPut: '--recursive' ].
    argStream
        nextPut: '-r';
        nextPut: self revision printString;
        nextPut: '--xml';
        nextPut: self url asString

    "Created: / 15-03-2008 / 21:21:11 / janfrog"
    "Modified: / 16-03-2008 / 07:38:11 / janfrog"
    "Modified: / 19-04-2008 / 13:57:44 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

svnParseXML: doc 
    ^ (doc root / 'list' / 'entry') asCollection 
        collect: [:entryNode | RepositoryEntry readFromXml: entryNode ]

    "Created: / 19-04-2008 / 13:56:45 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-08-2009 / 09:05:49 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

svnProcessCommandOutput:out err:err 
    ^ self svnParseXML:((XML::XMLParser on:out)
                validate:false;
                scanDocument)

    "Created: / 03-10-2008 / 16:31:45 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!ListCommand class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_SVN
    ^ '§Id: SVN__ListCommand.st 362 2011-08-08 13:07:42Z vranyj1 §'
! !
