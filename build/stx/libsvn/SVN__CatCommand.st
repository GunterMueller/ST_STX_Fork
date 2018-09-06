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

BranchCommand subclass:#CatCommand
	instanceVariableNames:'workingCopy path'
	classVariableNames:''
	poolDictionaries:''
	category:'SVN-Private-Commands'
!

!CatCommand class methodsFor:'documentation'!

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

!CatCommand class methodsFor:'others'!

version_CVS
    ^ '$Header$'
! !

!CatCommand methodsFor:'accessing'!

path
    ^ path
!

path:aString
    path := aString.
!

workingCopy
    ^ workingCopy

    "Created: / 16-03-2008 / 10:10:38 / janfrog"
!

workingCopy:aSVNWorkingCopy

    self assert: (aSVNWorkingCopy isKindOf: SVN::WorkingCopy).

    workingCopy := aSVNWorkingCopy.

    "Created: / 16-03-2008 / 10:10:38 / janfrog"
    "Modified: / 19-08-2009 / 11:28:58 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!CatCommand methodsFor:'executing - private'!

svnCmd
    "raise an error: must be redefined in concrete subclass(es)"

    ^'cat'

    "Created: / 02-04-2008 / 15:53:19 / janfrog"
!

svnCmdArgumentsOn: arg 
    "raise an error: must be redefined in concrete subclass(es)"
    
    arg
        nextPut: '-r';
        nextPut: revision printString.
    workingCopy 
        ifNotNil:[arg nextPut: path]
        ifNil:[arg nextPut: self url asString , '/' , path]

    "Created: / 02-04-2008 / 15:53:47 / janfrog"
    "Modified: / 19-08-2009 / 10:00:23 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 02-01-2010 / 13:19:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

svnCmdWorkdir
  ^workingCopy 
        ifNotNil: [workingCopy path pathName]
        ifNil: [super svnCmdWorkdir ]

    "Modified: / 02-01-2010 / 13:18:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

svnProcessCommandOutput:stdOut err:stdErr 
    ^ stdOut contents

    "Created: / 03-10-2008 / 16:31:45 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!CatCommand methodsFor:'initialization'!

initialize

    super initialize.
    revision := SVN::Revision head

    "Created: / 09-10-2008 / 20:35:59 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!CatCommand class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_SVN
    ^ '§Id: SVN__CatCommand.st 363 2011-08-08 13:49:48Z vranyj1 §'
! !
