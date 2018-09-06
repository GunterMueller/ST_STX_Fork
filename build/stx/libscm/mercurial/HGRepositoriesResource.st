"
stx:libscm - a new source code management library for Smalltalk/X
Copyright (C) 2012-2015 Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License. 

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
"{ Package: 'stx:libscm/mercurial' }"

"{ NameSpace: Smalltalk }"

TestResource subclass:#HGRepositoriesResource
	instanceVariableNames:'repositoryDirectoryRoot repositoryDirectory'
	classVariableNames:'HGRepositoriesArchiveDir'
	poolDictionaries:''
	category:'SCM-Mercurial-Tests'
!

!HGRepositoriesResource class methodsFor:'documentation'!

copyright
"
stx:libscm - a new source code management library for Smalltalk/X
Copyright (C) 2012-2015 Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License. 

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
!

documentation
"
    This resouce provides some pre-created respositories to run tests
    against. 

    == test_repo_01 ========================================

            @  changeset:   4:6f88e1f44d9e
            |  tag:         tip
            |  user:        Jan Vrany <jan.vrany@fit.cvut.cz>
            |  date:        Wed Oct 17 13:20:53 2012 +0200
            |  summary:     Commit 4
            |
            o  changeset:   3:912a64597e4f
            |  user:        Jan Vrany <jan.vrany@fit.cvut.cz>
            |  date:        Wed Oct 17 13:20:38 2012 +0200
            |  summary:     Commit 3
            |
            o  changeset:   2:db43a5baa9ac
            |  user:        Jan Vrany <jan.vrany@fit.cvut.cz>
            |  date:        Wed Oct 17 13:20:18 2012 +0200
            |  summary:     Commit 2
            |
            o  changeset:   1:98087d77fbaa
            |  user:        Jan Vrany <jan.vrany@fit.cvut.cz>
            |  date:        Wed Oct 17 13:19:14 2012 +0200
            |  summary:     Commit 1
            |
            o  changeset:   0:98b9033d3bac
               user:        Jan Vrany <jan.vrany@fit.cvut.cz>
               date:        Wed Oct 17 13:18:37 2012 +0200
               summary:     Commit 0

    == test_repo_02 ========================================

            @    changeset:   5:f22945219f9b
            |\   tag:         tip
            | |  parent:      0:c81883a66d71
            | |  parent:      4:5bd21fb5eea8
            | |  user:        Jan Vrany <jan.vrany@fit.cvut.cz>
            | |  date:        Tue Nov 27 18:16:25 2012 +0000
            | |  summary:     Commit 5 (merged branch1)
            | |
            | o  changeset:   4:5bd21fb5eea8
            | |  branch:      branch1
            | |  parent:      1:60544c149e47
            | |  user:        Jan Vrany <jan.vrany@fit.cvut.cz>
            | |  date:        Tue Nov 27 18:15:31 2012 +0000
            | |  summary:     Commit 4
            | |
            | | o  changeset:   3:32d32dee719f
            | | |  branch:      branch2
            | | |  user:        Jan Vrany <jan.vrany@fit.cvut.cz>
            | | |  date:        Tue Nov 27 18:12:40 2012 +0000
            | | |  summary:     Commit 3 (branch2 is dead-end)
            | | |
            +---o  changeset:   2:d67d1ec9e26d
            | |    branch:      branch2
            | |    parent:      0:c81883a66d71
            | |    user:        Jan Vrany <jan.vrany@fit.cvut.cz>
            | |    date:        Tue Nov 27 18:12:03 2012 +0000
            | |    summary:     Commit 2 (create branch2 & modified file)
            | |
            | o  changeset:   1:60544c149e47
            |/   branch:      branch1
            |    user:        Jan Vrany <jan.vrany@fit.cvut.cz>
            |    date:        Tue Nov 27 18:10:36 2012 +0000
            |    summary:     Commit 1 (created branch1)
            |
            o  changeset:   0:c81883a66d71
               user:        Jan Vrany <jan.vrany@fit.cvut.cz>
               date:        Tue Nov 27 18:09:47 2012 +0000
               summary:     Commit 0

    == mocks_hg_p1 ========================================

            @  changeset:   1:847b035d9aed
            |  tag:         tip
            |  user:        Jan Vrany <jan.vrany@fit.cvut.cz>
            |  date:        Wed Jan 29 13:56:10 2014 +0000
            |  summary:     Package name and version_HG fixed
            |
            o  changeset:   0:99acfa83a3bf
               user:        Jan Vrany <jan.vrany@fit.cvut.cz>
               date:        Fri Nov 16 11:29:05 2012 +0000
               summary:     Initial commit

    == mocks_hg_p2 ========================================

            @  changeset:   3:9e9134b80dfa
            |  tag:         tip
            |  user:        Jan Vrany <jan.vrany@fit.cvut.cz>
            |  date:        Sat Dec 01 15:42:22 2012 +0000
            |  summary:     - MocksHgP2N2N21Foo
            |
            o  changeset:   2:84a2ca31f8d9
            |  user:        Jan Vrany <jan.vrany@fit.cvut.cz>
            |  date:        Sat Dec 01 15:42:04 2012 +0000
            |  summary:     - mocks_hg_p2_n2
            |
            o  changeset:   1:efa1cc55f9f9
            |  user:        Jan Vrany <jan.vrany@fit.cvut.cz>
            |  date:        Sat Dec 01 15:41:47 2012 +0000
            |  summary:     - MocksHgP2N1Foo
            |
            o  changeset:   0:a662a0c5d8dd
               user:        Jan Vrany <jan.vrany@fit.cvut.cz>
               date:        Sat Dec 01 15:41:22 2012 +0000
               summary:     - mocks_hg_p2


    == mocks_hg_p3 ========================================

            o  changeset:   2:54cd319e4818
            |  branch:      branch1
            |  tag:         tip
            |  parent:      0:01f38ab5d98c
            |  user:        Jan Vrany <jan.vrany@fit.cvut.cz>
            |  date:        Mon Jan 14 14:47:02 2013 +0000
            |  summary:     Branch 1
            |
            | o  changeset:   1:54db7f7bc5b0
            |/   user:        Jan Vrany <jan.vrany@fit.cvut.cz>
            |    date:        Mon Jan 14 14:43:07 2013 +0000
            |    summary:     changed:
            |
            @  changeset:   0:01f38ab5d98c
               user:        Jan Vrany <jan.vrany@fit.cvut.cz>
               date:        Mon Jan 14 14:07:24 2013 +0000
               summary:     Initial package contents


    == mocks_hg_p4 ========================================

            @  changeset:   0:a0b5785fb55a
               tag:         tip
               user:        Jan Vrany <jan.vrany@fit.cvut.cz>
               date:        Wed Mar 27 11:31:36 2013 +0000
               summary:     Initial commit

    == mocks_hg_p5 ========================================

        @  changeset:   1:5abd9179e43d
        |  tag:         tip
        |  user:        Jan Vrany <jan.vrany@fit.cvut.cz>
        |  date:        Fri Nov 29 16:16:27 2013 +0000
        |  summary:     Added standard Java bundle
        |
        o  changeset:   0:07139f6f7907
           user:        Jan Vrany <jan.vrany@fit.cvut.cz>
           date:        Fri Nov 29 16:09:27 2013 +0000
           summary:     Initial commit

    == mocks_hg_p6 ========================================

        o  changeset:   6:7d0045fb7dba
        |  tag:         tip
        |  user:        Jan Vrany <jan.vrany@fit.cvut.cz>
        |  date:        Tue Feb 11 10:44:38 2014 +0000
        |  summary:     Removed extension method Object>>#greet
        |
        o  changeset:   5:ef448ae1bbbd
        |  user:        Jan Vrany <jan.vrany@fit.cvut.cz>
        |  date:        Tue Feb 11 10:43:51 2014 +0000
        |  summary:     Added extension method Object>>#greet.
        |
        o  changeset:   4:f71dfc6c6f9b
        |  user:        Jan Vrany <jan.vrany@fit.cvut.cz>
        |  date:        Tue Feb 11 10:39:47 2014 +0000
        |  summary:     MocksHGP6Bar>>#bar renamed to #greet
        |
        o  changeset:   3:c751cced3329
        |  user:        Jan Vrany <jan.vrany@fit.cvut.cz>
        |  date:        Tue Feb 11 10:37:44 2014 +0000
        |  summary:     Removed class MocksHGP6Foo.
        |
        o  changeset:   2:581b3cabbf8f
        |  user:        Jan Vrany <jan.vrany@fit.cvut.cz>
        |  date:        Tue Feb 11 10:36:53 2014 +0000
        |  summary:     Added new class MocksHGP6Qux
        |
        o  changeset:   1:506702fda231
        |  user:        Jan Vrany <jan.vrany@fit.cvut.cz>
        |  date:        Tue Feb 11 10:34:13 2014 +0000
        |  summary:     MocksHGP6Bar refactored
        |
        o  changeset:   0:c76faa501252
           user:        Jan Vrany <jan.vrany@fit.cvut.cz>
           date:        Tue Feb 11 12:53:12 2014 +0000
           summary:     Initial commit



    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!HGRepositoriesResource class methodsFor:'class initialization'!

initialize

    HGRepositoriesArchiveDir := (Smalltalk getPackageDirectoryForPackage:self package)
                    / 'tests' / 'repositories'

    "Created: / 09-12-2010 / 23:07:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 27-12-2011 / 18:07:34 / dundee"
    "Modified: / 13-07-2016 / 17:54:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGRepositoriesResource methodsFor:'accessing'!

directoryForRepositoryNamed: nm
    ^self directoryForRepositoryNamed: nm unpack: true

    "Created: / 19-09-2012 / 18:57:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-01-2013 / 13:13:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

directoryForRepositoryNamed: nm init: init
    "Returns path to repository named nm.

     If `init` is true, then the repository is created and initialized
     (with no content at all). If 'init' is false, then only directory
     name is returned (without creating it)."

    ^self directoryForRepositoryNamed: nm unpack: false init: init

    "Created: / 01-02-2013 / 13:38:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

directoryForRepositoryNamed: nm revision: revision
    ^self directoryForRepositoryNamed: nm unpack: true revision: revision

    "Created: / 11-02-2014 / 11:16:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

directoryForRepositoryNamed: nm unpack: unpack
    "Returns path to repository named nm.

     If `unpack` is true, then the repository is frechly created and thus
     empty. If 'unpack' is true, then initial content of repository will 
     be loaded from zip archive located in
        <package path>/stx/libsvn/tests/repositories/<name>.git.zip
     If the files does not exists, an error is raised"

    ^self directoryForRepositoryNamed: nm unpack: unpack init: true

    "Created: / 14-01-2013 / 13:13:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-02-2013 / 13:39:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

directoryForRepositoryNamed: nm unpack: unpack init: init
    "Returns path to repository named nm.

     If `unpack` is true, then the repository is frechly created and thus
     empty, unless 'init' is false (in that case, only a name of directory
     that does not exists yet ir returned.

     If 'unpack' is true, then initial content of repository will 
     be loaded from zip archive located in
        <package path>/stx/libsvn/tests/repositories/<name>.git.zip
     If the files does not exists, an error is raised"

    ^ self directoryForRepositoryNamed: nm unpack: unpack init: init revision: nil

    "Created: / 01-02-2013 / 13:35:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-02-2014 / 11:12:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

directoryForRepositoryNamed: nm unpack: unpack init: init revision: revision     
    "Returns path to repository named nm.

     If `unpack` is true, then the repository is frechly created and thus
     empty, unless 'init' is false (in that case, only a name of directory
     that does not exists yet ir returned.

     If 'unpack' is true, then initial content of repository will 
     be loaded from zip archive located in
        <package path>/stx/libsvn/tests/repositories/<name>.git.zip
     If the files does not exists, an error is raised.

     If `revision` is not nil, then update working copy to specified revision,
     otherwise keep it as it is. Note, that `revision` is only valid if
     `unpack` is true. If not and `revision` is not nil, error is raised.       
     "

    | archiveNm archive repo dir ok runningUnderJenkins |

    "/ runningUnderJenkins := (OperatingSystem getEnvironment:'JENKINS_SERVER_COOKIE') notNil.
    "/ runningUnderJenkins := true.
    runningUnderJenkins := false.

    unpack ifTrue:[
        self assert: init description: 'Cannot unpack non-initialized repo!!'
    ].

    archiveNm := nm copy 
                    replaceAll:$/ with:$_; 
                    yourself.
    archive := HGRepositoriesArchiveDir / (archiveNm , '.hg.zip').
    unpack ifTrue:[
        self assert:archive exists description:'dump file does not exist'.
    ].

    dir := repositoryDirectory.
    self assert:dir exists description:'repository directory does not exist'.

    init ifFalse:[
        ^ (dir asAbsoluteFilename / nm) pathName.
    ].

    unpack ifTrue:[
        ok := true.
        OperatingSystem 
            executeCommand:('unzip %1' bindWith: (archive asAbsoluteFilename pathName))
            inputFrom: nil
            outputTo: (runningUnderJenkins ifTrue:[ Stdout ] ifFalse:[ nil ])
            errorTo: (runningUnderJenkins ifTrue:[ Stderr ] ifFalse:[ nil ])
            inDirectory:dir 
            onError:[:status | 
                Stdout nextPutLine: ('Oops, unzip command failed: pid=%1 status=%2, code=%3' bindWith: status status with: status code with: status pid).
                ok := false
            ].
        ok ifFalse:[
            self tearDownRepositoryDirectory.
            self setUpRepositoryDirectory.
            dir := repositoryDirectoryRoot.
            OperatingSystem 
                executeCommand:('unzip %1' bindWith: (archive asAbsoluteFilename pathName))
                inputFrom: nil
                outputTo: (runningUnderJenkins ifTrue:[ Stdout ] ifFalse:[ nil ])
                errorTo: (runningUnderJenkins ifTrue:[ Stderr ] ifFalse:[ nil ])
                inDirectory:dir 
                onError:[:status | 
                    Stdout nextPutLine: ('Oops, unzip command second attempt failed: pid=%1 status=%2, code=%3' bindWith: status status with: status code with: status pid).
                    self assert:false description:('unzip command second attempt failed: pid=%1 status=%2, code=%3' bindWith: status status with: status code with: status pid).
                ].
        ].
        revision notNil ifTrue:[ 
            OperatingSystem 
                executeCommand:('hg update -r %1' bindWith: revision)
                inputFrom: nil
                outputTo: (runningUnderJenkins ifTrue:[ Stdout ] ifFalse:[ nil ])
                errorTo: (runningUnderJenkins ifTrue:[ Stderr ] ifFalse:[ nil ])
                inDirectory:(dir asAbsoluteFilename / nm) 
                onError:[:status | self assert:false description:('hg uppdate -r %1 failed' bindWith: revision)].         
        ].
    ] ifFalse:[
        | repodir |

        self assert: revision isNil description:'unpack is false but revision given'.
        repodir := (dir asAbsoluteFilename / nm).
        repodir directory recursiveMakeDirectory.
        ok := true.
        self assert: repodir directory exists description: ('failed to make directory %1' bindWith: repodir pathName).
        OperatingSystem 
                executeCommand:('hg init %1' bindWith: (repodir baseName))
                inputFrom: nil
                outputTo: (runningUnderJenkins ifTrue:[ Stdout ] ifFalse:[ nil ])
                errorTo: (runningUnderJenkins ifTrue:[ Stderr ] ifFalse:[ nil ])                                                
                inDirectory:repodir directory pathName 
                onError:[:status | 
                    Stdout nextPutLine: ('`hg init` command failed: pid=%1 status=%2, code=%3' bindWith: status status with: status code). 
                    ok := false.
                ].
        ok := ok and:[(repodir / '.hg') exists].
        ok ifFalse:[
            self tearDownRepositoryDirectory.
            self setUpRepositoryDirectory.
            dir := repositoryDirectoryRoot.
            repodir := (dir asAbsoluteFilename / nm).
            repodir directory recursiveMakeDirectory.    
            OperatingSystem
                    executeCommand:('hg init %1' bindWith: (repodir baseName))
                    inputFrom: nil
                    outputTo: (runningUnderJenkins ifTrue:[ Stdout ] ifFalse:[ nil ])
                    errorTo: (runningUnderJenkins ifTrue:[ Stderr ] ifFalse:[ nil ])
                    inDirectory:repodir directory pathName
                    onError:[:status |
                        Stdout nextPutLine: ('`hg init` command failed: pid=%1 status=%2, code=%3' bindWith: status status with: status code).                    
                        self assert:false description:'`hg init` second atempt failed'
                    ].
        ].              
        self assert: (repodir / '.hg') exists description: ('repository initialized but no .hg found in %1' bindWith: repodir pathName).                        
    ].

    repo := (dir asAbsoluteFilename / nm).
    runningUnderJenkins ifTrue:[ 
        Stdout nextPutLine: ('contents of repositoryDirectory=%1' bindWith: dir asAbsoluteFilename pathName).
        OperatingSystem 
            executeCommand:('ls -lR %1' bindWith: dir asAbsoluteFilename pathName)
            inputFrom: nil
            outputTo: Stdout
            errorTo: Stderr.
        Stdout nextPutLine: ('contents enc').
    ].
    self assert: repo exists.
    self assert: (repo / '.hg') exists.

    ^repo pathName

    "Created: / 11-02-2014 / 11:12:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-02-2017 / 10:17:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-02-2017 / 21:32:59 / vranyj1"
!

directoryForRepositoryNamed: nm unpack: unpack revision: revision
    "Returns path to repository named nm.

     If `unpack` is true, then the repository is frechly created and thus
     empty. If 'unpack' is true, then initial content of repository will 
     be loaded from zip archive located in
        <package path>/stx/libsvn/tests/repositories/<name>.git.zip
     If the files does not exists, an error is raised.

     If `revision` is not nil, then update working copy to specified revision,
     otherwise keep it as it is. Note, that `revision` is only valid if
     `unpack` is true. If not and `revision` is not nil, error is raised.
     "

    ^self directoryForRepositoryNamed: nm unpack: unpack init: true revision: revision

    "Created: / 11-02-2014 / 11:12:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGRepositoriesResource methodsFor:'running'!

setUp

    repositoryDirectoryRoot := Filename newTemporaryDirectory.

    "Created: / 09-12-2010 / 23:53:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 27-12-2011 / 18:07:04 / dundee"
    "Modified: / 08-02-2017 / 09:46:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setUpRepositoryDirectory
    repositoryDirectory := Filename newTemporaryDirectoryIn: repositoryDirectoryRoot.
    Smalltalk packagePath: (Smalltalk packagePath asOrderedCollection
                                addFirst: repositoryDirectory pathName;
                                yourself)

    "Created: / 08-02-2017 / 09:46:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

tearDown
    self tearDownRepositoryDirectory.
    [
        repositoryDirectoryRoot recursiveRemove
    ] on: Error do:[
        "Stupid windows!!"
    ]

    "Created: / 09-12-2010 / 23:54:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 30-09-2012 / 05:26:04 / jv"
    "Modified: / 08-02-2017 / 10:12:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

tearDownRepositoryDirectory
    repositoryDirectory notNil ifTrue:[
        Smalltalk packagePath: (Smalltalk packagePath asOrderedCollection
                                    remove: repositoryDirectory pathName;
                                    yourself).
    ].
    repositoryDirectory := nil.

    "Created: / 08-02-2017 / 09:47:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGRepositoriesResource methodsFor:'testing'!

isAvailable

    ^HGRepositoriesArchiveDir exists and:[OperatingSystem canExecuteCommand:'unzip']

    "Created: / 09-12-2010 / 23:06:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 27-12-2011 / 18:05:57 / dundee"
    "Modified: / 17-10-2012 / 13:02:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGRepositoriesResource class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id::                                                                                                                        '
! !


HGRepositoriesResource initialize!
