"
 Copyright (c) 2007-2010 Jan Vrany
 Copyright (c) 2009-2010 eXept Software AG
 Copyright (c) 2016 Jan Vrany

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

BranchCommand subclass:#UpdateLikeCommand
	instanceVariableNames:'workingCopy depth'
	classVariableNames:''
	poolDictionaries:''
	category:'SVN-Private-Commands'
!

!UpdateLikeCommand class methodsFor:'documentation'!

copyright
"
 Copyright (c) 2007-2010 Jan Vrany
 Copyright (c) 2009-2010 eXept Software AG
 Copyright (c) 2016 Jan Vrany

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

!UpdateLikeCommand class methodsFor:'others'!

version_CVS
    ^ '$Header$'
! !

!UpdateLikeCommand methodsFor:'accessing'!

depth:aString

    self assert: 
        (#('empty' 'files' 'immediates' 'infinity') includes: aString).
    
    depth := aString.

    "Modified: / 23-04-2011 / 18:50:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

workingCopy
    ^ workingCopy

    "Created: / 19-03-2008 / 12:44:24 / janfrog"
!

workingCopy:aSVNWorkingCopy

    self assert: (aSVNWorkingCopy isKindOf: SVN::WorkingCopy).
    
    workingCopy := aSVNWorkingCopy.
    branch := aSVNWorkingCopy branch.

    "Created: / 19-03-2008 / 12:44:24 / janfrog"
    "Modified: / 19-08-2009 / 12:22:34 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!UpdateLikeCommand methodsFor:'executing'!

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

    "Created: / 08-11-2008 / 08:39:02 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!UpdateLikeCommand methodsFor:'executing - private'!

svnCleanup

    ^CleanupCommand new
        workingCopy: workingCopy;
        execute.

    "Created: / 08-11-2008 / 08:39:15 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

svnCmdArgumentsOn:arg 
    "raise an error: must be redefined in concrete subclass(es)"

    arg
        nextPut: '-r'; nextPut: self revision printString.
    arg
        nextPut: '--depth'; nextPut: depth ? 'infinity'.

    "Created: / 16-03-2008 / 10:00:34 / janfrog"
    "Modified: / 23-04-2011 / 18:48:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

svnCmdWorkdir

    ^workingCopy path pathName

    "Created: / 19-03-2008 / 12:43:21 / janfrog"
    "Modified: / 19-08-2009 / 12:47:54 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

svnProcessCommandOutput: stdout err: stderr 
    "Superclass says that I am responsible to implement this method"

    | notifications |
    notifications := OrderedCollection new: 8.
    stdout contents asStringCollection do:
        [:line|
        line isEmpty ifFalse:[
            (line startsWith:'Summary of conflicts')       
                ifTrue:[^notifications].
            (line startsWith:'Summary of updates') ifTrue:[ 
                ^ notifications
            ].
            ((line startsWith:'--- Merging') 
                or:[(line startsWith:'Fetching external item into')
                or:[(line startsWith:'External at revision')]])
                ifFalse:[notifications add: ((WCActionNotification readFromString: line) wc: workingCopy; yourself)]]].
    ^notifications.

    "Created: / 03-10-2008 / 16:31:45 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 18-08-2009 / 14:38:55 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 15-01-2016 / 23:39:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UpdateLikeCommand class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_SVN
    ^ '§Id: SVN__UpdateLikeCommand.st 362 2011-08-08 13:07:42Z vranyj1 §'
! !

