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

WCCommand subclass:#MoveCommand
	instanceVariableNames:'src dst'
	classVariableNames:''
	poolDictionaries:''
	category:'SVN-Private-Commands'
!

!MoveCommand class methodsFor:'documentation'!

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

!MoveCommand class methodsFor:'others'!

version_CVS
    ^ '$Header$'
! !

!MoveCommand methodsFor:'accessing'!

dst
    ^ dst

    "Created: / 16-03-2008 / 10:22:26 / janfrog"
!

dst:something
    dst := something.

    "Created: / 16-03-2008 / 10:22:26 / janfrog"
!

src
    ^ src

    "Created: / 16-03-2008 / 10:22:26 / janfrog"
!

src:something
    src := something.

    "Created: / 16-03-2008 / 10:22:26 / janfrog"
! !

!MoveCommand methodsFor:'executing - private'!

svnCmd
    "raise an error: must be redefined in concrete subclass(es)"

    ^'move'

    "Created: / 16-03-2008 / 10:22:26 / janfrog"
!

svnCmdArgumentsOn:arg
    "raise an error: must be redefined in concrete subclass(es)"

    | srcArg dstArg wcPath |
    wcPath := workingCopy path pathName.
    srcArg := (src startsWith: wcPath) 
                ifTrue:[src copyFrom: wcPath size + 2]
                ifFalse:[src].
    dstArg := (src startsWith: wcPath) 
                ifTrue:[dst copyFrom: wcPath size + 2]
                ifFalse:[dst].


    super svnCmdArgumentsOn:arg.
    arg
        nextPut: srcArg;
        nextPut: dstArg

    "Created: / 16-03-2008 / 10:22:26 / janfrog"
    "Modified: / 28-07-2010 / 22:29:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MoveCommand class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_SVN
    ^ '§Id: SVN__MoveCommand.st 363 2011-08-08 13:49:48Z vranyj1 §'
! !
