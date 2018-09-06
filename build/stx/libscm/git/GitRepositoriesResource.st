"
 Copyright (c) 2007-2011 Jan Vrany
 Copyright (c) 2007-2011 eXept Software AG

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
"{ Package: 'stx:libscm/git' }"

TestResource subclass:#GitRepositoriesResource
	instanceVariableNames:'repositoryDirectory'
	classVariableNames:'GitRepositoriesArchiveDir'
	poolDictionaries:''
	category:'SCM-Git-Core-Tests'
!

!GitRepositoriesResource class methodsFor:'documentation'!

copyright
"
 Copyright (c) 2007-2011 Jan Vrany
 Copyright (c) 2007-2011 eXept Software AG

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

!GitRepositoriesResource class methodsFor:'class initialization'!

initialize

    GitRepositoriesArchiveDir := (Smalltalk packageDirectoryForPackageId:self package)
                    / 'tests' / 'repositories'

    "Created: / 09-12-2010 / 23:07:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 27-12-2011 / 18:07:34 / dundee"
    "Modified: / 19-09-2012 / 18:41:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitRepositoriesResource methodsFor:'accessing'!

directoryForRepositoryNamed: nm

    "Returns path to repository named nm.
     Initial content of repository will be loaded from
     zip archive located in
        <package path>/stx/libsvn/tests/repositories/<name>.git.zip
     If the file does not exists, repository will be empty."

    | archive repo |
    archive := GitRepositoriesArchiveDir / (nm , '.git.zip').
    self assert:archive exists description:'dump file does not exist'.
    self assert:repositoryDirectory exists description:'repository directory does not exist'.

    OperatingSystem 
        executeCommand:('unzip %1' bindWith: (archive asAbsoluteFilename pathName))
        inDirectory:repositoryDirectory 
        onError:[:status | self assert:false description:'svnadmin create failed'].

    repo := (repositoryDirectory asAbsoluteFilename / nm).
    self assert: repo exists.
    self assert: (repo / '.git') exists.

    ^repo pathName

    "Created: / 19-09-2012 / 18:57:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitRepositoriesResource methodsFor:'running'!

setUp

    repositoryDirectory := Filename newTemporaryDirectory

    "Created: / 09-12-2010 / 23:53:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 27-12-2011 / 18:07:04 / dundee"
!

tearDown
    [
        repositoryDirectory recursiveRemove
    ] on: Error do:[

    ]

    "Created: / 09-12-2010 / 23:54:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 30-09-2012 / 05:26:04 / jv"
! !

!GitRepositoriesResource methodsFor:'testing'!

isAvailable

    ^GitRepositoriesArchiveDir exists and:[OperatingSystem canExecuteCommand:'unzip']

    "Created: / 09-12-2010 / 23:06:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 27-12-2011 / 18:05:57 / dundee"
    "Modified: / 19-09-2012 / 19:06:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitRepositoriesResource class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !

GitRepositoriesResource initialize!
