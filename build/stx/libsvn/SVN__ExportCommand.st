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

BranchCommand subclass:#ExportCommand
	instanceVariableNames:'path destination depth'
	classVariableNames:''
	poolDictionaries:''
	category:'SVN-Private-Commands'
!

!ExportCommand class methodsFor:'documentation'!

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

!ExportCommand methodsFor:'accessing'!

depth:aString

    self assert: 
        (#('empty' 'files' 'immediates' 'infinity') includes: aString).
    
    depth := aString.

    "Modified: / 23-04-2011 / 18:50:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

destination
    ^ destination
!

destination:something
    destination := something.
!

path
    ^ path
!

path:something
    path := something.
! !

!ExportCommand methodsFor:'executing'!

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

!ExportCommand methodsFor:'executing - private'!

svnCleanup

    ^CleanupCommand new
        workingCopy: destination;
        execute.

    "Created: / 08-11-2008 / 08:39:15 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

svnCmd

    ^'export'

    "Created: / 08-11-2008 / 08:39:15 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Created: / 12-10-2011 / 10:45:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

svnCmdArgumentsOn:arg 
    "raise an error: must be redefined in concrete subclass(es)"

    arg
        nextPut: '-r'; nextPut: self revision printString.
    arg
        nextPut: '--depth'; nextPut: depth ? 'infinity'.

    path notNil ifTrue:[
        arg nextPut: (self url , '/' , path)
    ] ifFalse:[
        arg nextPut: self url    
    ].

    destination notNil ifTrue:[
        arg nextPut: destination
    ]

    "Created: / 16-03-2008 / 10:00:34 / janfrog"
    "Modified: / 12-10-2011 / 10:32:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

svnCmdWorkdir

    ^Filename currentDirectory pathName

    "Created: / 19-03-2008 / 12:43:21 / janfrog"
    "Modified: / 19-08-2009 / 12:47:54 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 12-10-2011 / 10:47:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

svnProcessCommandOutput: stdout err: stderr 

    ^stdout contents

    "Created: / 03-10-2008 / 16:31:45 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 18-08-2009 / 14:38:55 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 12-10-2011 / 10:28:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ExportCommand class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !
