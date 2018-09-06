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

UpdateLikeTask subclass:#MergeTask
	instanceVariableNames:'branch revision'
	classVariableNames:''
	poolDictionaries:''
	category:'SVN-Tasks'
!

!MergeTask class methodsFor:'documentation'!

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

!MergeTask class methodsFor:'others'!

version_CVS
    ^ '$Header$'
! !

!MergeTask methodsFor:'accessing'!

branch
    ^ branch
!

branch:aBranch
    branch := aBranch.
    self changed: #branch with: aBranch

    "Modified: / 25-11-2009 / 18:00:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

revision
    ^ revision
!

revision:aRevision
    revision := aRevision.
    self changed:#revision with: aRevision

    "Modified: / 25-11-2009 / 18:00:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MergeTask methodsFor:'executing'!

doApplyUpdates
    super doApplyUpdates.
    ProgressNotification notify:'Removing conflict flags...'.
    (ResolvedCommand new)
        workingCopy:self workingCopy;
        paths:(notifications collect:[:each | each entry path ]);
        execute.

    "Created: / 26-11-2009 / 14:55:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MergeTask methodsFor:'executing - private'!

doUpdate
    ActivityNotification notify:'Merging working copy...'.
    notifications := (MergeCommand new)
                workingCopy:self workingCopy;
                branchToMerge:branch;
                execute.

    "Created: / 22-11-2009 / 07:45:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-11-2009 / 14:54:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MergeTask methodsFor:'testing'!

isMergeTask
    ^ true
! !

!MergeTask class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_SVN
    ^ '§Id: SVN__MergeTask.st 363 2011-08-08 13:49:48Z vranyj1 §'
! !
