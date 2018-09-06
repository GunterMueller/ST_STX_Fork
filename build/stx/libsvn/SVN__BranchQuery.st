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

Query subclass:#BranchQuery
	instanceVariableNames:'repository'
	classVariableNames:''
	poolDictionaries:''
	category:'SVN-Queries'
!

!BranchQuery class methodsFor:'documentation'!

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

!BranchQuery class methodsFor:'others'!

version_CVS
    ^ '$Header$'
! !

!BranchQuery methodsFor:'accessing'!

repository
    ^ repository

    "Created: / 14-04-2008 / 11:53:58 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

repository:something
    repository := something.

    "Created: / 14-04-2008 / 11:53:58 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!BranchQuery methodsFor:'default actions'!

defaultAction

    | branch |
    branch := repository branchOrNil.
    branch ifNil:[branch := (BranchSelectionDialog on: repository) open; branch].    
    branch ifNil:
        [branch := repository branches 
                    detect:[:b | b isTrunk]
                    ifNone:[self error: 'No branch!!']].
    ^branch

    "Created: / 14-04-2008 / 11:55:22 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 17-03-2009 / 18:05:54 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 10-03-2010 / 18:26:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BranchQuery class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_SVN
    ^ '§Id: SVN__BranchQuery.st 363 2011-08-08 13:49:48Z vranyj1 §'
! !
