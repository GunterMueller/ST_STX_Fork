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

TestResource subclass:#RepositoryResource
	instanceVariableNames:'manager repositories workingcopies'
	classVariableNames:''
	poolDictionaries:''
	category:'SVN-Tests-Resources'
!

!RepositoryResource class methodsFor:'documentation'!

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

!RepositoryResource methodsFor:'accessing'!

manager
    ^ manager
! !

!RepositoryResource methodsFor:'private'!

packageIdToDirectoryName: package

    | dirname |
    dirname := package copy asString.
    dirname replaceAll:$: with:$..
    dirname replaceAll:$/ with:$..
    ^dirname

    "Created: / 09-12-2009 / 10:11:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RepositoryResource methodsFor:'running'!

setUp

    | directory |
    directory := Filename newTemporaryDirectory.
    repositories := (directory / 'repositories') makeDirectory; yourself.
    workingcopies := (directory / 'workingcopies') makeDirectory; yourself.

    manager := SVN::RepositoryManager new 
                    configurations: OrderedCollection new;
                    workingCopyBase: workingcopies pathName.

    "Created: / 09-12-2009 / 09:53:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

tearDown

    repositories directoryName asFilename recursiveRemove.
    manager := nil

    "Created: / 09-12-2009 / 09:54:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RepositoryResource methodsFor:'utilities'!

createRepositoryFor: package

    ^self createRepositoryFor: package withExtraFiles: nil

    "Created: / 09-12-2009 / 10:23:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

createRepositoryFor: package withExtraFiles: extraFiles

    | repodir repo wc |
    repodir := repositories / (self packageIdToDirectoryName: package).
    repodir exists ifTrue:[repodir recursiveRemove].
    manager configurations addFirst:
        (RepositoryConfiguration
            package: package
            url: 'file://' , repodir asAbsoluteFilename pathName).
    manager reset.

    (CreateRepositoryCommand new)
        repositoryPath:repodir pathName;
        execute.

    
    repo := manager repositoryForPackage: package.
    wc := repo workingCopy.
    wc path exists ifTrue:[wc path recursiveRemove].
    wc checkout.


    self 
        assert: extraFiles isNilOrEmptyCollection
        description: 'extra package files are not yet supported'.

    (wc path / 'trunk') makeDirectory.
    (wc path / 'branches') makeDirectory.
    (wc path / 'tags') makeDirectory.

    (Smalltalk allClassesInPackage: package) do:
        [:class|class fileOutIn: wc path / 'trunk' withTimeStamp: false].

    (AddCommand new)
        workingCopy: wc;
        paths:#( '*' );
        execute.
    (CommitCommand new)
        workingCopy: wc;
        message:'Initial commit from SVN::RepositoryResource>>createRepositoryFor:withExtraFiles:';
        execute.
    wc path
        recursiveRemove;
        makeDirectory.
    manager reset

    "Modified: / 19-08-2009 / 13:22:13 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Created: / 09-12-2009 / 10:22:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 09-12-2009 / 13:09:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

removeRepositoryFor: package

    | repodir repo wc |
    repodir := repositories / (self packageIdToDirectoryName: package).
    repo := manager repositoryForPackage: package.
    wc := repo workingCopy.

    manager configurations remove:
        (manager configurations detect:[:conf|conf package = package]).
    
    wc path recursiveRemove.
    repodir recursiveRemove.
    manager reset.

    "Created: / 09-12-2009 / 10:37:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RepositoryResource class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '§Id: SVN__RepositoryResource.st 350 2011-07-07 18:42:56Z vranyj1 §'
! !

