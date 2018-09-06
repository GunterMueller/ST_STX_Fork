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

UpdateLikeCommand subclass:#MergeCommand
	instanceVariableNames:'branchToMerge'
	classVariableNames:''
	poolDictionaries:''
	category:'SVN-Private-Commands'
!

!MergeCommand class methodsFor:'documentation'!

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

!MergeCommand class methodsFor:'others'!

version_CVS
    ^ '$Header$'
! !

!MergeCommand methodsFor:'accessing'!

branchToMerge
    ^ branchToMerge
!

branchToMerge:aBranch
    branchToMerge := aBranch.
! !

!MergeCommand methodsFor:'executing'!

doPrepareWorkingCopy
    self do:[
        self workingCopy ensureIsValid.
        self
            doRevert;
            doFileOutAll;
            doUpdate;
            doProcessNotifications
    ]

    "Created: / 23-03-2009 / 18:35:06 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 17-08-2009 / 19:01:45 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!MergeCommand methodsFor:'executing - private'!

svnCmd
    "raise an error: must be redefined in concrete subclass(es)"

    ^'merge'

    "Created: / 15-03-2008 / 23:48:44 / janfrog"
    "Modified: / 22-11-2009 / 07:42:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

svnCmdArgumentsOn: arg
    "raise an error: must be redefined in concrete subclass(es)"

    "/super svnCmdArgumentsOn: arg.
    arg
        nextPut: branchToMerge url asString

    "Created: / 15-03-2008 / 23:48:44 / janfrog"
    "Modified: / 19-03-2008 / 12:44:01 / janfrog"
    "Modified: / 23-11-2009 / 08:51:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MergeCommand class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_SVN
    ^ '§Id: SVN__MergeCommand.st 363 2011-08-08 13:49:48Z vranyj1 §'
! !
