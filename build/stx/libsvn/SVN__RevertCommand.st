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

WCPathCommand subclass:#RevertCommand
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SVN-Private-Commands'
!

!RevertCommand class methodsFor:'documentation'!

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

!RevertCommand class methodsFor:'others'!

version_CVS
    ^ '$Header$'
! !

!RevertCommand methodsFor:'executing - private'!

svnCmd
    "raise an error: must be redefined in concrete subclass(es)"

    ^'revert'

    "Created: / 22-10-2008 / 16:43:32 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

svnCmdArgumentsOn:argStream

    paths 
        ifNil:
            [argStream
                nextPut:'--recursive';
                nextPut:'.']
        ifNotNil:
            [argStream nextPutAll: paths]

    "Created: / 28-10-2008 / 08:50:47 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 13-02-2010 / 19:48:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RevertCommand class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_SVN
    ^ '§Id: SVN__RevertCommand.st 363 2011-08-08 13:49:48Z vranyj1 §'
! !
