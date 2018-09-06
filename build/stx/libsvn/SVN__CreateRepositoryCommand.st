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

Command subclass:#CreateRepositoryCommand
	instanceVariableNames:'repositoryPath'
	classVariableNames:''
	poolDictionaries:''
	category:'SVN-Private-Commands'
!

!CreateRepositoryCommand class methodsFor:'documentation'!

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

!CreateRepositoryCommand class methodsFor:'others'!

version_CVS
    ^ '$Header$'
! !

!CreateRepositoryCommand methodsFor:'accessing'!

repositoryPath
    ^ repositoryPath
!

repositoryPath:aString
    repositoryPath := aString.
! !

!CreateRepositoryCommand methodsFor:'executing - private'!

svnCmd
    "raise an error: must be redefined in concrete subclass(es)"

    ^'create'

    "Modified: / 08-04-2009 / 20:36:48 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

svnCmdArgumentsOn:argStream
    "raise an error: must be redefined in concrete subclass(es)"

    argStream nextPut: repositoryPath

    "Modified: / 08-04-2009 / 21:36:53 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

svnGlobalArgumentsOn: argStream

    "No global arguments"

    "Created: / 08-04-2009 / 20:38:41 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

svnProcessCommandOutput:svnStdoutStream err:svnStderrStream

    "Nothing to do"

    "Modified: / 08-04-2009 / 20:38:13 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

svnProgram

    ^'svnadmin'

    "Created: / 08-04-2009 / 20:36:18 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!CreateRepositoryCommand class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_SVN
    ^ '§Id: SVN__CreateRepositoryCommand.st 362 2011-08-08 13:07:42Z vranyj1 §'
! !
