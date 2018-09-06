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

Command subclass:#WCCommand
	instanceVariableNames:'alreadyCleaned workingCopy'
	classVariableNames:''
	poolDictionaries:''
	category:'SVN-Private-Commands'
!

!WCCommand class methodsFor:'documentation'!

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

!WCCommand class methodsFor:'others'!

version_CVS
    ^ '$Header$'
! !

!WCCommand methodsFor:'accessing'!

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

!WCCommand methodsFor:'executing'!

execute
    ^[super execute] on:SVN::WorkingCopyLockedError do:
        [:ex | 
        alreadyCleaned 
            ifTrue:
                [ex pass]
            ifFalse:
                [self svnCleanup.
                alreadyCleaned := true.
                self execute]]

    "Created: / 08-11-2008 / 08:30:34 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!WCCommand methodsFor:'executing - private'!

svnCleanup

    ^CleanupCommand new
        workingCopy: workingCopy;
        execute.

    "Created: / 08-11-2008 / 08:14:29 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

svnCmdArgumentsOn:arg 

    "arg nextPut:'-m'; nextPut: (message ? '')"

    "Created: / 16-03-2008 / 10:18:46 / janfrog"
    "Modified: / 19-03-2008 / 15:58:57 / janfrog"
!

svnCmdWorkdir
    "raise an error: must be redefined in concrete subclass(es)"

    ^workingCopy path pathName

    "Created: / 16-03-2008 / 10:10:34 / janfrog"
    "Modified: / 19-08-2009 / 11:29:10 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

svnProcessCommandOutput:out err:err 
    ^ out contents

    "Created: / 03-10-2008 / 16:31:45 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!WCCommand methodsFor:'initialization'!

initialize

    super initialize.
    alreadyCleaned := false

    "Created: / 08-11-2008 / 08:15:55 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!WCCommand class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_SVN
    ^ '§Id: SVN__WCCommand.st 363 2011-08-08 13:49:48Z vranyj1 §'
! !
