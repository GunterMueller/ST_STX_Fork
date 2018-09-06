"{ Encoding: utf8 }"

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

HGTestCase subclass:#HGStXTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Mercurial-Tests'
!

!HGStXTests class methodsFor:'documentation'!

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
    Tests for Mercurial-Smalltalk/X integration. Mapping packages
    to Mercurial repositories, commitning packages from image
    and so on...

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!HGStXTests methodsFor:'accessing'!

timeout
    "Returns a default timeout (sec) for the test.
     If nil is returned, no timeout enforced.

    Note that the timeout is set only when running under
    report runner, interactive tools does not use it"

    | method |
    method := self class lookupMethodFor: testSelector.
    method annotationsAt:#timeout: do:[:annotation|
         ^annotation arguments first
    ].
    ^120"sec - default timeout"

    "Created: / 13-02-2017 / 21:31:47 / vranyj1"
! !

!HGStXTests methodsFor:'running'!

loadPackage: packageId
    "A utility method to prepare a repository for package
     and load package from it"

    self repositoryNamed: (packageId copyReplaceAll:$: with:$/).
    Smalltalk loadPackage: packageId.

    "Created: / 16-11-2012 / 20:01:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

tearDown
    | classes methods |
    super tearDown.

    "Also, wipe out all mocks"
    classes := OrderedCollection new.
    methods := OrderedCollection new.
    Smalltalk allClassesDo:[:cls|
        (cls package notNil and:[cls package startsWith:'mocks']) ifTrue:[
            classes add: cls
        ] ifFalse:[
            cls methodsDo:[:m|(m package notNil and:[m package startsWith:'mocks']) ifTrue:[methods add: m]].
            cls class methodsDo:[:m|(m package notNil and:[m package startsWith:'mocks']) ifTrue:[methods add: m]].
        ]
    ].
    Class withoutUpdatingChangesDo:[
        classes do:[:cls|cls removeFromSystem].
        methods do:[:m|m mclass removeSelector: m selector]
    ].
"/    Delay waitForSeconds: 1.

    "/ Also, wipe out cached sources...
    [
        (AbstractSourceCodeManager cacheDirectoryName asFilename / 'mocks') recursiveRemove
    ] on: Error do:[:ex|
        Delay waitForSeconds: 1.
        Error ignoreIn:[
            (AbstractSourceCodeManager cacheDirectoryName asFilename / 'mocks') recursiveRemove.
        ].
    ]

    "Created: / 16-11-2012 / 19:00:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-08-2014 / 20:57:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_infrastructure
    "
        This is kind of meta-test that tests if the
        setUp/tearDown actually works. Especially, if
        no mock classes/methods are left in the image
        after tearDown. Also, make sure that all
        HGPackageModels for mocks
    "
    | pm |

    self loadPackage:'mocks:hg/p1'.

    self assert: (Smalltalk at: #'mocks_hg_p1') notNil.
    pm := HGPackageWorkingCopyRegistry packageNamed:'mocks:hg/p1'.
    self assert: pm notNil.
    self assert: ((HGPackageWorkingCopyRegistry current instVarNamed:#packages) includesKey: #'mocks:hg/p1').

    pm := nil.
    self cleanup.

    self assert: (Smalltalk at: #'mocks_hg_p1') isNil.
    self assert: repositories isNil.
    self assert: ((HGPackageWorkingCopyRegistry current instVarNamed:#packages) includesKey: #'mocks:hg/p1') not.

    "Created: / 16-11-2012 / 19:25:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-11-2012 / 15:31:54 / jv"
    "Modified: / 05-03-2014 / 21:50:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGStXTests methodsFor:'tests - commit'!

test_commit_01
    "
        Simple commit
    "

    | repo pm ct |

    repo := self repositoryNamed: 'mocks/hg/p1'.
    self assert: (Smalltalk loadPackage:'mocks:hg/p1').
    self dumpRepositoryLog: repo.


    self deny:   ((repo @ 1 / 'MockHGP1Bar.st') contents asString includesString:'zork ^ 1').

    ((Smalltalk at:#MockHGP1Bar) compile:'zork ^ 1' classified:'test') package: (Smalltalk at:#MockHGP1Bar) package.
    pm := HGPackageWorkingCopy named: 'mocks:hg/p1'.
    ct := pm commitTask.
    self assert: ct isCommitingNewHead not.
    ct message:'test_commit_01'.
    ct do.
    self dumpRepositoryLog: repo.

    "
        repo workingCopy browse
    "
    self assert: ((repo @ 2 / 'MockHGP1Bar.st') contents asString includesString:'zork ^ 1').
    self assert: (Smalltalk at:#mocks_hg_p1) hgLogicalRevision revno = 2.

    "Created: / 16-11-2012 / 18:51:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-06-2016 / 11:40:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_02a
    "
    Repeated commit
    "

    | repo pm ct |

    repo := self repositoryNamed: 'mocks/hg/p1'.
    Smalltalk loadPackage:'mocks:hg/p1'.
    pm := HGPackageWorkingCopy named: 'mocks:hg/p1'.
    self dumpRepositoryLog: repo.

    (MockHGP1Bar compile:'zork ^ 1' classified:'test') package: MockHGP1Bar package.

    self deny:   ((repo @ 1 / 'MockHGP1Bar.st') contents asString includesString:'zork ^ 1').

    ct := pm commitTask.
    ct message:'test_commit_02-1'.
    ct do.
    self dumpRepositoryLog: repo.

    self assert: ((repo @ 2 / 'MockHGP1Bar.st') contents asString includesString:'zork ^ 1').
    self assert: ((repo @ 2 ) parent1 == (repo @ 1 )).

    (MockHGP1Bar compile:'zork ^ 2' classified:'test') package: MockHGP1Bar package.

    ct := pm commitTask.
    ct message:'test_commit_02-2'.
    ct do.
    self dumpRepositoryLog: repo.

    self assert:  (repo @ 3) message = 'test_commit_02-2'.
    self assert: ((repo @ 3 / 'MockHGP1Bar.st') contents asString includesString:'zork ^ 2').
    self assert: ((repo @ 3 ) parent1 == (repo @ 2 )).

    "
    repo workingCopy browse
    "

    "Created: / 20-11-2012 / 19:33:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-03-2014 / 21:49:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_02b
    "
    Repeated commit, remove the working copy between commits
    "

    | repo pm ct |

    repo := self repositoryNamed: 'mocks/hg/p1'.
    Smalltalk loadPackage:'mocks:hg/p1'.
    pm := HGPackageWorkingCopy named: 'mocks:hg/p1'.
    (MockHGP1Bar compile:'zork ^ 1' classified:'test') package: MockHGP1Bar package.

    self deny:   ((repo @ 1 / 'MockHGP1Bar.st') contents asString includesString:'zork ^ 1').

    ct := pm commitTask.
    ct message:'test_commit_02-1'.
    ct do.

    self assert: ((repo @ 2 / 'MockHGP1Bar.st') contents asString includesString:'zork ^ 1').
    self assert: ((repo @ 2 ) parent1 == (repo @ 1 )).

    (MockHGP1Bar compile:'zork ^ 2' classified:'test') package: MockHGP1Bar package.
    pm temporaryWorkingCopy path recursiveRemove.

    ct := pm commitTask.
    ct message:'test_commit_02-2'.
    ct do.

    self assert: ((repo @ 3 / 'MockHGP1Bar.st') contents asString includesString:'zork ^ 2').
    self assert: ((repo @ 3 ) parent1 == (repo @ 2 )).

    "
    repo workingCopy browse
    "

    "Created: / 20-11-2012 / 19:35:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-03-2014 / 21:49:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_03a
    "
    Two images A, B working in parallel, commiting to same repo

    1) A: checkout, modify commit package (cs1)
    2) B: checkout, commit change         (cs2)
    2) A: modify, checkout                (cs3)

    The changeset cs3 should have cs1 as its parent1

    <skip>

    "

    | repo pmA ctA wcB s |

    "=== A modifies & commits =============================== "
    repo := self repositoryNamed: 'mocks/hg/p1'.
    Smalltalk loadPackage:'mocks:hg/p1'.
    self dumpRepositoryLog: repo.

    pmA := HGPackageWorkingCopy named: 'mocks:hg/p1'.
    (MockHGP1Bar compile:'zork ^ 1' classified:'test') package: MockHGP1Bar package.

    self deny:   ((repo @ 1 / 'MockHGP1Bar.st') contents asString includesString:'zork ^ 1').

    ctA := pmA commitTask.
    self assert: ctA isCommitingNewHead not.
    ctA message:'test_commit_03a A-1'.
    ctA do.
    self dumpRepositoryLog: repo.

    self assert: ((repo @ 2 / 'MockHGP1Bar.st') contents asString includesString:'zork ^ 1').
    self assert: ((repo @ 2 ) parent1 == (repo @ 1 )).

    "=== B modifies & commits =============================== "
    wcB := repo workingCopy.
    s := ( wcB / 'abbrev.stc' ) appendStream.
    [ s nextPutLine:'# Modification '] ensure:[s close].
    wcB commit: 'test_commit_03a B-2'.
    self dumpRepositoryLog: repo.
    self assert: ((repo @ 3 ) parent1 == (repo @ 1 )).


    "=== A modifies & commits =============================== "
    (MockHGP1Bar compile:'zork ^ 2' classified:'test') package: MockHGP1Bar package.

    ctA := pmA commitTask.
    self assert: ctA isCommitingNewHead not.
    ctA message:'test_commit_03a A-3'.
    ctA do.
    self dumpRepositoryLog: repo.

    self assert: ((repo @ 4 ) parent1 == (repo @ 2 )).

    "
    repo workingCopy browse
    "

    "Created: / 20-11-2012 / 19:45:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-03-2014 / 21:48:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_03b
    "
    Two images A, B working in parallel, commiting to same repo

    1) A: checkout, modify commit package (cs1)
    2) B: checkout, commit change         (cs2)
    3) A: flushes its temp working copy
    4) A: modify, checkout                (cs3)

    The changeset cs3 should have cs1 as its parent1
    "

    | repo pmA ctA wcB s |

    "=== A modifies & commits =============================== "
    repo := self repositoryNamed: 'mocks/hg/p1'.
    Smalltalk loadPackage:'mocks:hg/p1'.
    pmA := HGPackageWorkingCopy named: 'mocks:hg/p1'.
    (MockHGP1Bar compile:'zork ^ 1' classified:'test') package: MockHGP1Bar package.

    self deny:   ((repo @ 1 / 'MockHGP1Bar.st') contents asString includesString:'zork ^ 1').

    ctA := pmA commitTask.
    ctA message:'test_commit_03a A-1'.
    ctA do.

    self assert: ((repo @ 2 / 'MockHGP1Bar.st') contents asString includesString:'zork ^ 1').
    self assert: ((repo @ 2 ) parent1 == (repo @ 1 )).

    "=== B modifies & commits =============================== "
    wcB := repo workingCopy.
    s := ( wcB / 'abbrev.stc' ) appendStream.
    [ s nextPutLine:'# Modification '] ensure:[s close].
    wcB commit: 'test_commit_03a B-2'.
    self assert: ((repo @ 3 ) parent1 == (repo @ 1 )).

    "=== A flushed its working copy ========================= "
    pmA temporaryWorkingCopy path recursiveRemove.


    "=== A modifies & commits =============================== "
    (MockHGP1Bar compile:'zork ^ 2' classified:'test') package: MockHGP1Bar package.

    ctA := pmA commitTask.
    ctA message:'test_commit_03a A-3'.
    ctA do.

    self assert: ((repo @ 4 ) parent1 == (repo @ 2 )).

    "
    repo workingCopy browse
    "

    "Created: / 20-11-2012 / 19:51:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-03-2014 / 21:48:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_03c
    "
    Two images A, B working in parallel, commiting to same repo

                                                  (cs1) - base changeset
    2) B: checkout, modifu, commit change         (cs2)
    4) A: checkout, modify, commit change         (cs3)

    The changeset cs3 should have cs1 as its parent1
    "

    | repo pmA ctA wcB s |

    repo := self repositoryNamed: 'mocks/hg/p1'.
    Smalltalk loadPackage:'mocks:hg/p1'.
    pmA := HGPackageWorkingCopy named: 'mocks:hg/p1'.

    "=== B modifies & commits =============================== "
    wcB := repo workingCopy.
    s := ( wcB / 'abbrev.stc' ) appendStream.
    [ s nextPutLine:'# Modification '] ensure:[s close].
    wcB commit: 'test_commit_03c B-1'.
    self assert: ((repo @ 2 ) parent1 == (repo @ 1 )).

    "=== A modifies & commits =============================== "
    (MockHGP1Bar compile:'zork ^ 2' classified:'test') package: MockHGP1Bar package.

    ctA := pmA commitTask.
    ctA message:'test_commit_03c A-2'.
    ctA do.

    self assert: ((repo @ 3 ) parent1 == (repo @ 1 )).

    "
    repo workingCopy browse
    "

    "Created: / 20-11-2012 / 20:00:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-03-2014 / 21:48:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_05a
    "
    Setup:
    Two repositories: package + upstream repo (package's default).

    1) checkout, modify.
    2) commit, setup autopush to default remote.

    Check whether remote gets updated/
    "
    | path upstreamP upstream repo pm ct |

    path := (self repositoryNamed: 'mocks/hg/p1') path.
    upstreamP := repositories add:(Filename newTemporaryDirectory).
    path moveTo: (upstreamP / 'upstream').
    upstream := HGRepository on: (upstreamP / 'upstream').
    repo := upstream cloneTo: path.

    self assert: (Smalltalk loadPackage: 'mocks:hg/p1').

    "=== modifyes & commits =============================== "
    (MockHGP1Foo compile:'zork ^ 2' classified:'test') package: MockHGP1Foo package.

    pm := HGPackageWorkingCopy named: 'mocks:hg/p1'.
    ct := pm commitTask.
    ct message:'test_commit_05a 1'.
    ct remote: repo remoteDefault.
    ct do.

    self assert: (upstream @ 2) message = 'test_commit_05a 1'.


    "
    repo workingCopy browse
    "

    "Created: / 10-12-2012 / 01:58:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-03-2014 / 21:48:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_05b
    "
    Setup:
    Two repositories: package + upstream repo (package's default).

    1) checkout, modify.
    2) modify & commit in upstream
    3) commit, setup autopush to default remote.

    Check that an exception is raised as commit would create new
    head.
    "
    | path upstreamP upstream repo wc pm ct s |

    path := (self repositoryNamed: 'mocks/hg/p1') path.
    upstreamP := repositories add:(Filename newTemporaryDirectory).
    path moveTo: (upstreamP / 'upstream').
    upstream := HGRepository on: (upstreamP / 'upstream').
    repo := upstream cloneTo: path.

    self assert: (Smalltalk loadPackage: 'mocks:hg/p1').

    "=== modify & commit into upstream ================== "
    wc := upstream workingCopy.
    [
        s := ( wc / 'MockHGP1Foo.st' ) appendStream.
        s nextPutLine: 'Just a comment'
    ] ensure:[
        s close
    ].    wc commit: 'test_commit_05b 1 into upstream'.

    "=== modify & commits =============================== "
    (MockHGP1Foo compile:'zork ^ 2' classified:'test') package: MockHGP1Foo package.

    pm := HGPackageWorkingCopy named: 'mocks:hg/p1'.
    ct := pm commitTask.
    ct message:'test_commit_05b 2'.
    ct remote: repo remoteDefault.

    self should: [ ct do ] raise: HGPushWouldCreateNewHeadError





    "
    repo workingCopy browse
    "

    "Created: / 10-12-2012 / 02:09:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-03-2014 / 21:48:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_06a
    "
    Test commit into new branch
    "
    | repo pm ct |

    repo := self repositoryNamed: 'mocks/hg/p1'.
    self assert: (Smalltalk loadPackage: 'mocks:hg/p1').

    "=== modify & commit =============================== "
    (MockHGP1Foo compile:'zork ^ 2' classified:'test') package: MockHGP1Foo package.

    pm := HGPackageWorkingCopy named: 'mocks:hg/p1'.
    ct := pm commitTask.
    ct message:'test_commit_06a 1'.
    ct branch:'test_commit_06a'.
    self assert: ct isCommitingNewHead not.
    ct do.

    "=== check for the branch ========================= "
    self assert: (repo branches size  == 2).
    self assert: (repo @ 2) branches size == 1.
    self assert: (repo @ 2) branches anElement name = 'test_commit_06a'.
    self assert: (repo workingCopy branch name) = 'test_commit_06a'.

    "=== update original wc ========================== "
    self assert: ((repo workingCopy / 'MockHGP1Foo.st') contents asString includesString:'zork ^ 2') not.
    repo workingCopy update.
    self assert: ((repo workingCopy / 'MockHGP1Foo.st') contents asString includesString:'zork ^ 2').


    "
    repo workingCopy browse
    "

    "Created: / 10-12-2012 / 03:24:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-03-2014 / 21:48:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_06b
    "
    Test commit into same branch
    "
    | repo pm ct |

    repo := self repositoryNamed: 'mocks/hg/p1'.
    self assert: (Smalltalk loadPackage: 'mocks:hg/p1').

    "=== modifyes & commits =============================== "
    (MockHGP1Foo compile:'zork ^ 2' classified:'test') package: MockHGP1Foo package.

    pm := HGPackageWorkingCopy named: 'mocks:hg/p1'.
    ct := pm commitTask.
    ct message:'test_commit_06a 1'.
    ct branch:'default'.
    ct do.

    self assert: (repo branches size  == 1).
    self assert: (repo @ 2) branches size == 1.
    self assert: (repo @ 2) branches anElement name = 'default'.


    "
    repo workingCopy browse
    "

    "Created: / 10-12-2012 / 03:24:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-03-2014 / 21:48:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_06c
    "
    Test commit into existing branch should raise an error
    (theoretically possible, but would be tricky to support :-)
    "
    | repo pm ct s |

    repo := self repositoryNamed: 'mocks/hg/p1'.
    self assert: (Smalltalk loadPackage: 'mocks:hg/p1').

    "=== create the branch beforehand ===================== "
    [
        s := (repo workingCopy / 'abbrev.stc' ) appendStream.
        s cr;cr;cr.
    ] ensure:[
        s close
    ].
    repo workingCopy branch: 'test_commit_06c'.
    repo workingCopy commit: 'test_commit_06c into branch test_commit_06c'.
    repo workingCopy update: 0.

    "=== modify & commit ================================== "
    (MockHGP1Foo compile:'zork ^ 2' classified:'test') package: MockHGP1Foo package.

    pm := HGPackageWorkingCopy named: 'mocks:hg/p1'.
    ct := pm commitTask.
    ct message:'test_commit_06a 1'.
    ct branch:'test_commit_06c'.

    self should: [ ct do] raise: HGCommitError


    "
    repo workingCopy browse
    "

    "Created: / 10-12-2012 / 03:28:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-03-2014 / 21:48:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_07
    "
        Tests commit to an empty repository
    "

    | repo cls pm ct |

    repo := self repositoryNamed: 'mocks/hg/p4_empty' unpack: false.
    self dumpRepositoryLog: repo.

    cls := Object subclass:#MockHGP4_EmptyFoo instanceVariableNames:'' classVariableNames:'' poolDictionaries:''.
    cls package: #'mocks:hg/p4_empty'.
    (cls compile:'zork ^ 1' classified:'test') package: #'mocks:hg/p4_empty'.

    pm := HGPackageWorkingCopy named: #'mocks:hg/p4_empty'.
    ct := pm commitTask.
    self assert: ct isCommitingNewHead not.

    ct message:'test_commit_07'.
    ct do.
    self dumpRepositoryLog: repo.

    "
        repo workingCopy browse
    "
    self assert: ((repo @ 0 / 'MockHGP4_EmptyFoo.st') contents asString includesString:'zork ^ 1').
    self assert: (Smalltalk at:#mocks_hg_p4_empty) hgLogicalRevision revno = 0.

    "Created: / 14-01-2013 / 13:20:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-03-2014 / 21:48:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_08
    "
    Test commit into fresh branch created in repo (but with no
    changeset yet)
    "
    | repo pm ct |

    repo := self repositoryNamed: 'mocks/hg/p1'.
    repo workingCopy branch: 'branch_test_commit_08'.
    self assert: (Smalltalk loadPackage: 'mocks:hg/p1').

    "=== modifyes & commits =============================== "
    (MockHGP1Foo compile:'zork ^ 2' classified:'test') package: MockHGP1Foo package.

    pm := HGPackageWorkingCopy named: 'mocks:hg/p1'.
    ct := pm commitTask.
    self assert: ct isCommitingNewHead not.
    ct message:'test_commit_08 1'.
    ct do.

    self assert: (repo branches size == 2).
    self assert: (repo @ 2) branches size == 1.
    self assert: (repo @ 2) branches anElement name = 'branch_test_commit_08'.


    "
    repo workingCopy browse
    pm temporaryWorkingCopy browse.
    "

    "Created: / 14-01-2013 / 14:14:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-03-2014 / 21:48:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_09a
    "
        Test commit of a new subpackage
    "

    | repo cls pm ct |

    repo := self repositoryNamed: 'mocks/hg/p1'.
    self assert: (Smalltalk loadPackage: 'mocks:hg/p1').

    cls := Object subclass:#MockHGP1_New instanceVariableNames:'' classVariableNames:'' poolDictionaries:''.
    cls package: #'mocks:hg/p1/new'.
    (cls compile:'zork ^ 1' classified:'test') package: #'mocks:hg/p1/new'.

    pm := HGPackageWorkingCopy named: #'mocks:hg/p1/new'.
    ct := pm commitTask.
    self assert: ct isCommitingNewHead not.

    ct message:'test_commit_09'.
    ct do.
    self dumpRepositoryLog: repo.

    "
        repo workingCopy browse
    "
    self assert: ((repo @ 2 / 'new' / 'MockHGP1_New.st') contents asString includesString:'zork ^ 1').
    self assert: (Smalltalk at:#mocks_hg_p1_new) hgLogicalRevision revno = 2.
"/    self assert: (Smalltalk at:#mocks_hg_p1) hgLogicalRevision revno = 2.

    "Created: / 18-03-2013 / 17:21:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-03-2014 / 21:48:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_10a
    "
        Test if project definition class is automatically updated when committing.

        Case a: add a new class
    "

    | repo cls pm ct |

    repo := self repositoryNamed: 'mocks/hg/p1'.
    self assert: (Smalltalk loadPackage: 'mocks:hg/p1').

    cls := Object subclass:#MockHGP1Baz instanceVariableNames:'' classVariableNames:'' poolDictionaries:''.
    cls package: #'mocks:hg/p1'.
    (cls compile:'zork ^ 1' classified:'test') package: #'mocks:hg/p1'.

    pm := HGPackageWorkingCopy named: #'mocks:hg/p1'.
    ct := pm commitTask.
    ct message:'test_commit_10a'.
    ct doPrepareWorkingCopy.

    self assert: ((Smalltalk at: #'mocks_hg_p1') classNamesAndAttributes includes: #MockHGP1Baz).
    "
        repo workingCopy browse
    "
"/    self assert: (Smalltalk at:#mocks_hg_p1) hgLogicalRevision revno = 2.

    "Created: / 18-03-2013 / 18:40:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-03-2014 / 21:48:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_10b
    "
        Test if project definition class is automatically updated when committing.

        Case b: remove a class
    "

    | repo pm ct |

    repo := self repositoryNamed: 'mocks/hg/p1'.
    self assert: (Smalltalk loadPackage: 'mocks:hg/p1').

    Smalltalk removeClass: (Smalltalk at: #MockHGP1Bar).

    pm := HGPackageWorkingCopy named: #'mocks:hg/p1'.
    ct := pm commitTask.
    ct message:'test_commit_10b'.
    ct doPrepareWorkingCopy.

    self assert: ((Smalltalk at: #'mocks_hg_p1') classNamesAndAttributes includes: #MockHGP1Bar) not.

    "Created: / 18-03-2013 / 18:41:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-03-2014 / 21:48:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_10c
    "
        Test if project definition class is automatically updated when committing.

        Case c: add an extension
    "

    | repo pm ct |

    repo := self repositoryNamed: 'mocks/hg/p1'.
    self assert: (Smalltalk loadPackage: 'mocks:hg/p1').

    (UndefinedObject compile:'zork ^ 1' classified:'test') package: #'mocks:hg/p1'.

    pm := HGPackageWorkingCopy named: #'mocks:hg/p1'.
    ct := pm commitTask.
    ct message:'test_commit_10c'.
    ct doPrepareWorkingCopy.

    self assert: ((Smalltalk at: #'mocks_hg_p1') extensionMethodNames includes: #zork).

    "Created: / 18-03-2013 / 18:42:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-03-2014 / 21:48:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_10d
    "
        Test if project definition class is automatically updated when committing.

        Case d: introduce a new superclass (which must be listed before its subclass)
    "

    | repo cls pm ct |

    repo := self repositoryNamed: 'mocks/hg/p1'.
    self assert: (Smalltalk loadPackage: 'mocks:hg/p1').

    cls := Object subclass:#MockHGP1Baz instanceVariableNames:'' classVariableNames:'' poolDictionaries:''.
    cls package: #'mocks:hg/p1'.
    (cls compile:'zork ^ 1' classified:'test') package: #'mocks:hg/p1'.
    cls := (Smalltalk at: #MockHGP1Baz) subclass:#MockHGP1Bar instanceVariableNames:'' classVariableNames:'' poolDictionaries:''.
    cls package: #'mocks:hg/p1'.

    self assert: (Smalltalk at: #MockHGP1Bar) superclass == (Smalltalk at: #MockHGP1Baz).
    self assert: (Smalltalk at: #MockHGP1Bar) package = #'mocks:hg/p1'.

    pm := HGPackageWorkingCopy named: #'mocks:hg/p1'.
    ct := pm commitTask.
    ct message:'test_commit_10a'.
    ct doPrepareWorkingCopy.

    self assert: ((Smalltalk at: #'mocks_hg_p1') classNamesAndAttributes includes: #MockHGP1Baz).
    self assert: ((Smalltalk at: #'mocks_hg_p1') classNamesAndAttributes includes: #MockHGP1Bar).
    self assert: ((Smalltalk at: #'mocks_hg_p1') classNamesAndAttributes indexOf: #MockHGP1Baz) < ((Smalltalk at: #'mocks_hg_p1') classNamesAndAttributes indexOf: #MockHGP1Bar).

    "
        repo workingCopy browse
    "
"/    self assert: (Smalltalk at:#mocks_hg_p1) hgLogicalRevision revno = 2.

    "Created: / 28-07-2017 / 08:12:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_11a
    "
        Test if commit task detects method protocol changes
    "

    | repo pm ct |

    repo := self repositoryNamed: 'mocks/hg/p1'.
    self assert: (Smalltalk loadPackage: 'mocks:hg/p1').

    ((Smalltalk at: #MockHGP1Bar) compiledMethodAt: #qux) category: 'new category'.

    pm := HGPackageWorkingCopy named: #'mocks:hg/p1'.
    ct := pm commitTask.
    ct message:'test_commit_11a'.
    ct do.

    "
        repo workingCopy browse
    "
    self assert: ((repo @ 2 / 'MockHGP1Bar.st') contents asString includesString:'new category').

    "Created: / 18-03-2013 / 18:57:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-03-2014 / 21:48:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_11b
    "
        Test if commit task detects class category changes
    "

    | repo pm ct |

    repo := self repositoryNamed: 'mocks/hg/p1'.
    self assert: (Smalltalk loadPackage: 'mocks:hg/p1').

    (Smalltalk at: #MockHGP1Bar) category:'new category'.

    pm := HGPackageWorkingCopy named: #'mocks:hg/p1'.
    ct := pm commitTask.
    ct message:'test_commit_11b'.
    ct do.

    "
        repo workingCopy browse
    "
    self assert: ((repo @ 2 / 'MockHGP1Bar.st') contents asString includesString:'new category').

    "Created: / 18-03-2013 / 18:59:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-03-2014 / 21:48:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_11c
    "
        Test if commit task detects class removal
    "

    | repo pm ct |

    repo := self repositoryNamed: 'mocks/hg/p1'.
    self assert: (Smalltalk loadPackage: 'mocks:hg/p1').

    Smalltalk removeClass: (Smalltalk at: #MockHGP1Bar).

    pm := HGPackageWorkingCopy named: #'mocks:hg/p1'.
    ct := pm commitTask.
    ct message:'test_commit_11c'.
    ct do.

    "
        repo workingCopy browse
    "
    self should:[(repo @ 2 / 'MockHGP1Bar.st')] raise: HGError

    "Created: / 18-03-2013 / 19:00:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-03-2014 / 21:48:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_11d
    "
        Test if commit task detects method removal
    "

    | repo pm ct |

    repo := self repositoryNamed: 'mocks/hg/p1'.
    self assert: (Smalltalk loadPackage: 'mocks:hg/p1').

    (Smalltalk at: #MockHGP1Bar) removeSelector: #'qux'.

    pm := HGPackageWorkingCopy named: #'mocks:hg/p1'.
    ct := pm commitTask.
    ct message:'test_commit_11b'.
    ct do.

    "
        repo workingCopy browse
    "
    self assert: ((repo @ 2 / 'MockHGP1Bar.st') contents asString includesString:'qux') not

    "Created: / 18-03-2013 / 19:01:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-03-2014 / 21:48:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_12a
    "
        Test correct fileout or class with respect to UTF8.
        This checks for issue #8.

    "

    | repo pm ct contents |

    repo := self repositoryNamed: 'mocks/hg/p1'.
    self assert: (Smalltalk loadPackage: 'mocks:hg/p1').

    ((Smalltalk at: #MockHGP1Bar) compile:'zork

    ^''Příliš žluťoučký kůň úpěl ďábelské ódy''' classified: 'utf8 methods')
        package: (Smalltalk at: #MockHGP1Bar) package.


    pm := HGPackageWorkingCopy named: #'mocks:hg/p1'.
    ct := pm commitTask.
    ct message:'test_commit_12a'.
    ct do.

    "
        repo workingCopy browse
    "
    contents := (repo @ 2 / 'MockHGP1Bar.st') contents.
    self assert: (contents  asString includesString:'"{ Encoding: utf8 }"').
    self assert: (contents  asString includesString:'Příliš žluťoučký kůň úpěl ďábelské ódy') not.

    contents := (repo @ 1 / 'MockHGP1Bar.st') contents.
    self assert: (contents  asString includesString:'"{ Encoding: utf8 }"') not.

    "Created: / 22-03-2013 / 09:44:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-03-2014 / 21:48:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_12b
    "
        Test correct fileout of extensions with respect to UTF8.
        This checks for issue #8.
    "

    | repo pm ct contents |

    "Hack for rel 6.2.2 - due to a bug in fileout,
     non-UTF8 characters are not supported.
     Should use 'self skipIf: ... ' but this is not
     supported by 6.2.2's SUnit..."
    (Smalltalk versionString = '6.2.2') ifTrue:[ ^ self ].

    repo := self repositoryNamed: 'mocks/hg/p1'.
    self assert: (Smalltalk loadPackage: 'mocks:hg/p1').

    ((UndefinedObject) compile:'zork
    ^''Příliš žluťoučký kůň úpěl ďábelské ódy''' classified: 'utf8 methods')
    package: #'mocks:hg/p1'.

    pm := HGPackageWorkingCopy named: #'mocks:hg/p1'.
    ct := pm commitTask.
    ct message:'test_commit_12b'.
    ct do.

    "
        repo workingCopy browse
    "
    contents := (repo @ 2 / 'extensions.st') contents.
    self assert: (contents  asString includesString:'"{ Encoding: utf8 }"').
    self assert: (contents  asString includesString:'Příliš žluťoučký kůň úpěl ďábelské ódy') not.

    "Created: / 22-03-2013 / 09:46:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-03-2014 / 21:48:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_12c
    "
        Test correct fileout of extensions with respect to UTF8.
        This checks for issue #8.
    "

    | repo pm ct contents |

    repo := self repositoryNamed: 'mocks/hg/p1'.
    self assert: (Smalltalk loadPackage: 'mocks:hg/p1').

    ((UndefinedObject) compile:'zork
    ^''XUZ''' classified: 'utf8 methods')
    package: #'mocks:hg/p1'.

    pm := HGPackageWorkingCopy named: #'mocks:hg/p1'.
    ct := pm commitTask.
    ct message:'test_commit_12b'.
    ct do.

    "
        repo workingCopy browse
    "
    contents := (repo @ 2 / 'extensions.st') contents.
    self assert: (contents  asString includesString:'"{ Encoding: utf8 }"') not.

    "Created: / 22-03-2013 / 10:13:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-03-2014 / 21:47:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_13a
    "
        Test commit without package model.
        This checks for issue #7.
    "

    | repo  wc  ct currentcs |

    repo := self repositoryNamed:'test_repo_01'.
    "
     UserPreferences fileBrowserClass openOn: repo directory.
    "
    wc := repo workingCopy.
     "Modify some file"
    (wc / 'f1.txt') writingFileDo:[:s | s nextPutAll:'modified from test_01a'. ].
    ct := wc commitTask.
    ct do.

    currentcs := wc changeset.
    self assert:currentcs id revno == 5.

    "Created: / 01-04-2013 / 13:04:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_13b
    "
        Test commit without package model of a working copy after merge.
    "
    | repo wc ct |

    repo := self repositoryNamed:'mocks/hg/p3'.
    wc := repo workingCopy.
    wc update: 2.
    wc merge: (repo @ 1).
    (wc root / 'Make.spec') markResolved.
    (wc root / 'abbrev.stc') markResolved.
    (wc root / 'bc.mak') markResolved.
    (wc root / 'mocks_hg_p3.st') markResolved.
    (wc root / 'p3.rc') markResolved.
    (wc root / 'MockHGP3Foo.st') markResolved.

    "
     UserPreferences fileBrowserClass openOn: repo pathName.
    "
    ct := wc commitTask.
    ct do.

    "Created: / 01-04-2013 / 13:23:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-11-2014 / 11:27:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_14a
    "
    Test if container is removed if class is removed.
    "

    | repo pm ct |

    repo := self repositoryNamed: 'mocks/hg/p1'.
    self assert: (Smalltalk loadPackage: 'mocks:hg/p1').

    Smalltalk removeClass: (Smalltalk at: #MockHGP1Bar).

    pm := HGPackageWorkingCopy named: #'mocks:hg/p1'.
    ct := pm commitTask.
    ct message:'test_commit_14a'.
    ct do.

    self shouldnt: [ repo @ 1 / 'MockHGP1Bar.st' ] raise: HGError.
    self should:   [ repo @ 2 / 'MockHGP1Bar.st' ] raise: HGError.

    "Created: / 21-05-2013 / 16:24:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-03-2014 / 21:47:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_14b
    "
    Test if container is removed if class is removed but not if package
    specifies #hgRemoveContainesForDeletedClasses

    "

    | repo pm ct |

    repo := self repositoryNamed: 'mocks/hg/p1'.
    self assert: (Smalltalk loadPackage: 'mocks:hg/p1').
    (Smalltalk at: #mocks_hg_p1) class compile: 'hgRemoveContainesForDeletedClasses ^false' classified: 'accessing - hg'.

    Smalltalk removeClass: (Smalltalk at: #MockHGP1Bar).
    pm := HGPackageWorkingCopy named: #'mocks:hg/p1'.
    ct := pm commitTask.
    ct message:'test_commit_14b'.
    ct do.

    self shouldnt: [ repo @ 1 / 'MockHGP1Bar.st' ] raise: HGError.
    self shouldnt: [ repo @ 2 / 'MockHGP1Bar.st' ] raise: HGError.

    "Created: / 21-05-2013 / 16:47:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-03-2014 / 21:47:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_15a
    "
    Test creation of deeply nested packages
        1) load mocks:hg/p2/n2
        2) create class in mocks:hg/p2/n2_2
        3) commit


    "
    | repo pmN22 ctN22 |

    repo := self repositoryNamed: 'mocks/hg/p2'.
    self assert: (Smalltalk loadPackage:'mocks:hg/p2/n2').

    Object subclass:#MocksHgP2N22Foo
        instanceVariableNames:''
        classVariableNames:''
        poolDictionaries:''
        category:'* Mocks *'.

    (Smalltalk at:#MocksHgP2N22Foo) package: #'mocks:hg/p2/n2/n2_2'.

    pmN22 := HGPackageWorkingCopy named: #'mocks:hg/p2/n2/n2_2'.
    ctN22 := pmN22 commitTask.
    ctN22 message:'test_commit_15a 1'.
    ctN22 do.
    "
    repo workingCopy browse
    "

    "Created: / 10-06-2013 / 23:28:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-03-2014 / 21:47:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_15b
    "
    Test creation of deeply nested packages
        1) load mocks:hg/p2/n1/n1_1/n_1_1_1
        2) create class in mocks:hg/p2/n1/n1_1/n_1_1_1
        3) commit


    "
    | repo pmN111 ctN111 |

    repo := self repositoryNamed: 'mocks/hg/p2'.
    self assert: (Smalltalk loadPackage:'mocks:hg/p2/n1').

    Object subclass:#MocksHgP2N111Foo
        instanceVariableNames:''
        classVariableNames:''
        poolDictionaries:''
        category:'* Mocks *'.

    (Smalltalk at:#MocksHgP2N111Foo) package: #'mocks:hg/p2/n1/n1_1/n_1_1_1'.

    pmN111 := HGPackageWorkingCopy named: #'mocks:hg/p2/n1/n1_1/n_1_1_1'.
    ctN111 := pmN111 commitTask.
    ctN111 message:'test_commit_15b 1'.
    ctN111 do.
    "
    repo workingCopy browse
    "

    "Created: / 11-06-2013 / 00:16:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-03-2014 / 21:47:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_17a
    "
    Test class renames.

    Check, that rename is properly recorded in Mercurial history

    "
    | repo pm ct cs copies |

    repo := self repositoryNamed: 'mocks/hg/p1'.
    self assert: (Smalltalk loadPackage:'mocks:hg/p1').


    pm := HGPackageWorkingCopy named: #'mocks:hg/p1'.
    "
    repo workingCopy browse
    "

    "/ Rename class...
    Smalltalk renameClass: (Smalltalk at: #MockHGP1Bar) to:#MockHGP1Quuz.

    ct := pm commitTask.
    ct message:'test_commit_17a'.
    ct do.

    cs := repo @ 2.
    copies  := cs changes select:[:change | change isCopied ].
    self assert: cs message = 'test_commit_17a'.
    self assert: copies size == 1.
    self assert: copies anElement path = 'MockHGP1Quuz.st'.
    self assert: copies anElement source = 'MockHGP1Bar.st'.

    "Created: / 04-03-2014 / 17:34:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-03-2014 / 21:47:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_17b
    "
    Test class multiple renames of one class

    Check, that rename is properly recorded in Mercurial history

    "
    | repo pm ct cs copies |

    repo := self repositoryNamed: 'mocks/hg/p1'.
    self assert: (Smalltalk loadPackage:'mocks:hg/p1').


    pm := HGPackageWorkingCopy named: #'mocks:hg/p1'.
    "
    repo workingCopy browse
    "

    "/ Rename class...
    Smalltalk renameClass: (Smalltalk at: #MockHGP1Bar) to:#MockHGP1Bazz.
    Smalltalk renameClass: (Smalltalk at: #MockHGP1Bazz) to:#MockHGP1Buzz.
    Smalltalk renameClass: (Smalltalk at: #MockHGP1Buzz) to:#MockHGP1Bun.
    Smalltalk renameClass: (Smalltalk at: #MockHGP1Bun) to:#MockHGP1Quuz.

    ct := pm commitTask.
    ct message:'test_commit_17b'.
    ct do.

    cs := repo @ 2.
    copies  := cs changes select:[:change | change isCopied ].
    self assert: cs message = 'test_commit_17b'.
    self assert: copies size == 1.
    self assert: copies anElement path = 'MockHGP1Quuz.st'.
    self assert: copies anElement source = 'MockHGP1Bar.st'.

    "Created: / 04-03-2014 / 17:43:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-03-2014 / 21:47:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_17c
    "
    Test class circular renames of one class (issue #18)

    Check, that rename is properly recorded in Mercurial history

    "
    | repo pm ct cs copies |

    repo := self repositoryNamed: 'mocks/hg/p1'.
    self assert: (Smalltalk loadPackage:'mocks:hg/p1').


    pm := HGPackageWorkingCopy named: #'mocks:hg/p1'.
    "
    repo workingCopy browse
    "

    "/ Rename class...
    Smalltalk renameClass: (Smalltalk at: #MockHGP1Bar) to:#MockHGP1Bazz.
    Smalltalk renameClass: (Smalltalk at: #MockHGP1Bazz) to:#MockHGP1Bar.

    ct := pm commitTask.
    ct message:'test_commit_17c'.
    ct do.

    cs := repo @ 2.
    copies  := cs changes select:[:change | change isCopied ].
    self assert: cs message = 'test_commit_17c'.
    self assert: copies isEmpty.

    "Created: / 04-03-2014 / 17:45:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-03-2014 / 21:47:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_17d
    "
    Test circular rename with one more rename at the end.

    Check, that rename is properly recorded in Mercurial history

    "
    | repo pm ct cs copies |

    repo := self repositoryNamed: 'mocks/hg/p1'.
    self assert: (Smalltalk loadPackage:'mocks:hg/p1').


    pm := HGPackageWorkingCopy named: #'mocks:hg/p1'.
    "
    repo workingCopy browse
    "

    "/ Rename class...
    Smalltalk renameClass: (Smalltalk at: #MockHGP1Bar) to:#MockHGP1Bazz.
    Smalltalk renameClass: (Smalltalk at: #MockHGP1Bazz) to:#MockHGP1Buzz.
    Smalltalk renameClass: (Smalltalk at: #MockHGP1Buzz) to:#MockHGP1Bun.
    Smalltalk renameClass: (Smalltalk at: #MockHGP1Bun) to:#MockHGP1Bar.  

    ct := pm commitTask.
    ct message:'test_commit_17d'.
    ct do.

    cs := repo @ 2.
    copies  := cs changes select:[:change | change isCopied ].
    self assert: cs message = 'test_commit_17d'.
    self assert: copies isEmpty.

    "Created: / 04-03-2014 / 17:57:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-03-2014 / 21:47:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_17e
    "
    Test circular rename with one more rename at the end.

    Check, that rename is properly recorded in Mercurial history

    "
    | repo pm ct cs copies |

    repo := self repositoryNamed: 'mocks/hg/p1'.
    self assert: (Smalltalk loadPackage:'mocks:hg/p1').


    pm := HGPackageWorkingCopy named: #'mocks:hg/p1'.
    "
    repo workingCopy browse
    "

    "/ Rename class...
    Smalltalk renameClass: (Smalltalk at: #MockHGP1Bar) to:#MockHGP1Bazz.
    Smalltalk renameClass: (Smalltalk at: #MockHGP1Bazz) to:#MockHGP1Buzz.
    Smalltalk renameClass: (Smalltalk at: #MockHGP1Buzz) to:#MockHGP1Bun.
    Smalltalk renameClass: (Smalltalk at: #MockHGP1Bun) to:#MockHGP1Bar.  
    Smalltalk renameClass: (Smalltalk at: #MockHGP1Bar) to:#MockHGP1Quuz.

    ct := pm commitTask.
    ct message:'test_commit_17e'.
    ct do.

    cs := repo @ 2.
    copies  := cs changes select:[:change | change isCopied ].
    self assert: cs message = 'test_commit_17e'.
    self assert: copies size == 1.
    self assert: copies anElement path = 'MockHGP1Quuz.st'.
    self assert: copies anElement source = 'MockHGP1Bar.st'.

    "Created: / 04-03-2014 / 17:59:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-03-2014 / 21:47:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_17f
    "
    Test class renames...

    Check, that rename is properly recorded in Mercurial history

    "
    | repo pm ct cs copies |

    repo := self repositoryNamed: 'mocks/hg/p1'.
    self assert: (Smalltalk loadPackage:'mocks:hg/p1').


    pm := HGPackageWorkingCopy named: #'mocks:hg/p1'.
    "
    repo workingCopy browse
    "

    "/ Rename class...
    Smalltalk renameClass: (Smalltalk at: #MockHGP1Bar) to:#MockHGP1Baz.
    Smalltalk renameClass: (Smalltalk at: #MockHGP1Foo) to:#MockHGP1Foz.


    ct := pm commitTask.
    ct message:'test_commit_17f'.
    ct do.

    cs := repo @ 2.
    copies  := cs changes select:[:change | change isCopied ].
    self assert: cs message = 'test_commit_17f'.
    self assert: copies size == 2.

    "Created: / 04-03-2014 / 21:03:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-03-2014 / 21:47:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_17g
    "
    Test class renames.

    Check, that rename is properly recorded in Mercurial history

    "
    | repo pm ct cs copies |

    repo := self repositoryNamed: 'mocks/hg/p1'.
    self assert: (Smalltalk loadPackage:'mocks:hg/p1').


    pm := HGPackageWorkingCopy named: #'mocks:hg/p1'.
    "
    repo workingCopy browse
    "

    "/ Rename class...
    Smalltalk renameClass: (Smalltalk at: #MockHGP1Bar) to:#MockHGP1Quuz.
    Smalltalk renameClass: (Smalltalk at: #MockHGP1Foo) to:#MockHGP1Foz.
    Smalltalk renameClass: (Smalltalk at: #MockHGP1Foz) to:#MockHGP1Foo.



    ct := pm commitTask.
    ct message:'test_commit_17g'.
    ct do.

    cs := repo @ 2.
    copies  := cs changes select:[:change | change isCopied ].
    self assert: cs message = 'test_commit_17g'.
    self assert: copies size == 1.
    self assert: copies anElement path = 'MockHGP1Quuz.st'.
    self assert: copies anElement source = 'MockHGP1Bar.st'.

    "Created: / 04-03-2014 / 21:06:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-03-2014 / 21:47:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_17h
    "
    Test class renames.

    Check, that rename is properly recorded in Mercurial history

    "
    | repo pm ct cs copies |

    repo := self repositoryNamed: 'mocks/hg/p1'.
    self assert: (Smalltalk loadPackage:'mocks:hg/p1').


    pm := HGPackageWorkingCopy named: #'mocks:hg/p1'.
    "
    repo workingCopy browse
    pm temporaryWorkingCopy browse
    "

    "/ Rename class...
    Smalltalk renameClass: (Smalltalk at: #MockHGP1Bar) to:#MockHGP1Quuz.
    Smalltalk renameClass: (Smalltalk at: #MockHGP1Foo) to:#MockHGP1Bar.
    Smalltalk renameClass: (Smalltalk at: #MockHGP1Bar) to:#MockHGP1Foo.

    ct := pm commitTask.
    ct message:'test_commit_17h'.
    ct do.

    cs := repo @ 2.
    copies  := cs changes select:[:change | change isCopied ].
    self assert: cs message = 'test_commit_17h'.
    self assert: copies size == 1.
    self assert: copies anElement path = 'MockHGP1Quuz.st'.
    self assert: copies anElement source = 'MockHGP1Bar.st'.

    "Created: / 04-03-2014 / 21:08:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-03-2014 / 21:47:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_17i
    "
    Test class renames.

    Check, that rename is properly recorded in Mercurial history

    "
    | repo pm ct cs copies |

    repo := self repositoryNamed: 'mocks/hg/p1'.
    self assert: (Smalltalk loadPackage:'mocks:hg/p1').


    pm := HGPackageWorkingCopy named: #'mocks:hg/p1'.
    "
    repo workingCopy browse
    "

    "/ Rename class...
    Smalltalk renameClass: (Smalltalk at: #MockHGP1Bar) to:#MockHGP1Quuz.
    Smalltalk renameClass: (Smalltalk at: #MockHGP1Foo) to:#MockHGP1Bar.
    Smalltalk renameClass: (Smalltalk at: #MockHGP1Quuz) to:#MockHGP1Quux.
    Smalltalk renameClass: (Smalltalk at: #MockHGP1Bar) to:#MockHGP1Ban.
    Smalltalk renameClass: (Smalltalk at: #MockHGP1Quux) to:#MockHGP1Bar.
    Smalltalk renameClass: (Smalltalk at: #MockHGP1Ban) to:#MockHGP1Foo.


    ct := pm commitTask.
    ct message:'test_commit_17i'.
    ct do.

    cs := repo @ 2.
    copies  := cs changes select:[:change | change isCopied ].
    self assert: cs message = 'test_commit_17i'.
    self assert: copies isEmpty.

    "Created: / 04-03-2014 / 21:18:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-03-2014 / 21:47:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_18a
    "
    Test class rename.

    Check, that rename is properly reflected in build support files
    "
    | repo pm ct cs |

    repo := self repositoryNamed: 'mocks/hg/p1'.
    self assert: (Smalltalk loadPackage:'mocks:hg/p1').


    pm := HGPackageWorkingCopy named: #'mocks:hg/p1'.
    "
    repo workingCopy browse
    "

    "/ Rename class...
    Smalltalk renameClass: (Smalltalk at: #MockHGP1Bar) to:#MockHGP1Quuz.

    ct := pm commitTask.
    ct message:'test_commit_18a'.
    ct do.

    cs := repo @ 2.
    self assert: cs message = 'test_commit_18a'.
    self assert: ((cs / 'Make.spec') contents asString includesString: 'MockHGP1Bar') not.
    self assert: ((cs / 'Make.proto') contents asString includesString: 'MockHGP1Bar') not.    
    self assert: ((cs / 'bc.mak') contents asString includesString: 'MockHGP1Bar') not.

    "Created: / 02-04-2014 / 14:30:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_19a
    "
        Simple selective commit
    "

    | repo pm ct |

    repo := self repositoryNamed: 'mocks/hg/p1'.
    self assert: (Smalltalk loadPackage:'mocks:hg/p1').
    self dumpRepositoryLog: repo.

    self deny:   ((repo @ 1 / 'MockHGP1Bar.st') contents asString includesString:'zork ^ 1').

    ((Smalltalk at: #MockHGP1Bar) compile:'zork ^ 1' classified:'test') package: (Smalltalk at: #MockHGP1Bar) package.
    pm := HGPackageWorkingCopy named: 'mocks:hg/p1'.
    ct := pm commitTask.
    self assert: ct isCommitingNewHead not.
    ct message:'test_commit_01'.
    ct classes: (Array with: (Smalltalk at: #MockHGP1Bar)).
    ct do.
    self dumpRepositoryLog: repo.

    "
        repo workingCopy browse
    "
    self assert: ((repo @ 2 / 'MockHGP1Bar.st') contents asString includesString:'zork ^ 1').
    self assert: (Smalltalk at:#mocks_hg_p1) hgLogicalRevision revno = 2.

    "Created: / 01-05-2014 / 09:14:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_19b
    "
        Simple selective commit - modify two classes
        but commit only one.
    "

    | repo pm ct |

    repo := self repositoryNamed: 'mocks/hg/p1'.
    self assert: (Smalltalk loadPackage:'mocks:hg/p1').
    self dumpRepositoryLog: repo.

    self deny:   ((repo @ 1 / 'MockHGP1Bar.st') contents asString includesString:'zork ^ 1').
    self deny:   ((repo @ 1 / 'MockHGP1Foo.st') contents asString includesString:'zork ^ 1').

    ((Smalltalk at: #MockHGP1Bar) compile:'zork ^ 1' classified:'test') package: (Smalltalk at: #MockHGP1Bar) package.
    ((Smalltalk at: #MockHGP1Foo) compile:'zork ^ 1' classified:'test') package: (Smalltalk at: #MockHGP1Foo) package.
    pm := HGPackageWorkingCopy named: 'mocks:hg/p1'.
    ct := pm commitTask.
    self assert: ct isCommitingNewHead not.
    ct message:'test_commit_01'.
    ct classes: (Array with: (Smalltalk at: #MockHGP1Bar)).
    ct do.
    self dumpRepositoryLog: repo.

    "
        repo workingCopy browse
    "
    self assert: ((repo @ 2 / 'MockHGP1Bar.st') contents asString includesString:'zork ^ 1').
    self assert: ((repo @ 2 / 'MockHGP1Foo.st') contents asString includesString:'zork ^ 1') not.
    self assert: ((repo @ 2) changes size = 1).
    self assert: (Smalltalk at:#mocks_hg_p1) hgLogicalRevision revno = 2.

    "Created: / 01-05-2014 / 09:16:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_20a
    "
    Test, that after a commit, changeset is properly condensed
    so browser would correctly show modified (uncommited) classes.

    This tests standard package commit.
    "

    | repo pm ct |

    repo := self repositoryNamed: 'mocks/hg/p1'.
    self assert: (Smalltalk loadPackage:'mocks:hg/p1').
    self dumpRepositoryLog: repo.


    self deny:   ((repo @ 1 / 'MockHGP1Bar.st') contents asString includesString:'zork ^ 1').

    ((Smalltalk at:#MockHGP1Bar) compile:'zork ^ 1' classified:'test') package: (Smalltalk at:#MockHGP1Bar) package.
    self assert: (ChangeSet current includesChangeForClass: (Smalltalk at:#MockHGP1Bar)).

    pm := HGPackageWorkingCopy named: 'mocks:hg/p1'.
    ct := pm commitTask.
    ct message:'test_commit_20a'.
    ct do.
    "
    repo workingCopy browse
    "
    self assert: (ChangeSet current includesChangeForClass: (Smalltalk at:#MockHGP1Bar)) not.

    "Created: / 15-11-2014 / 00:25:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_20b
    "
    Test, that after a commit, changeset is properly condensed
    so browser would correctly show modified (uncommited) classes.

    This tests selective commit (modify two classes, commit only one)
    "

    | repo pm ct |

    repo := self repositoryNamed: 'mocks/hg/p1'.
    self assert: (Smalltalk loadPackage:'mocks:hg/p1').
    self dumpRepositoryLog: repo.


    self deny:   ((repo @ 1 / 'MockHGP1Bar.st') contents asString includesString:'zork ^ 1').

    ((Smalltalk at:#MockHGP1Foo) compile:'bark ^ 1' classified:'test') package: (Smalltalk at:#MockHGP1Foo) package.
    ((Smalltalk at:#MockHGP1Bar) compile:'zork ^ 1' classified:'test') package: (Smalltalk at:#MockHGP1Bar) package.
    self assert: (ChangeSet current includesChangeForClass: (Smalltalk at:#MockHGP1Foo)).
    self assert: (ChangeSet current includesChangeForClass: (Smalltalk at:#MockHGP1Bar)).

    pm := HGPackageWorkingCopy named: 'mocks:hg/p1'.
    ct := pm commitTask.
    ct message:'test_commit_20a'.
    ct paths: { (ct temporaryWorkingCopy path / 'MockHGP1Bar.st') pathName } .
    ct do.
    "
    repo workingCopy browse
    "
    self assert: (ChangeSet current includesChangeForClass: (Smalltalk at:#MockHGP1Foo)).
    self assert: (ChangeSet current includesChangeForClass: (Smalltalk at:#MockHGP1Bar)) not.

    "Created: / 15-11-2014 / 00:26:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-11-2014 / 01:41:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_20c
    "
    Test, that after a commit, changeset is properly condensed
    so browser would correctly show modified (uncommited) classes.

    This tests selective commit (modify class & create an extension, commit only class)
    "

    | repo pm ct |

    repo := self repositoryNamed: 'mocks/hg/p1'.
    self assert: (Smalltalk loadPackage:'mocks:hg/p1').
    self dumpRepositoryLog: repo.


    self deny:   ((repo @ 1 / 'MockHGP1Bar.st') contents asString includesString:'zork ^ 1').

    ((Smalltalk at:#MockHGP1Bar) compile:'zork ^ 1' classified:'test') package: (Smalltalk at:#MockHGP1Bar) package.
    (Object compile:'bark ^ 1' classified: 'test') package:  (Smalltalk at:#MockHGP1Bar) package.

    self assert: (ChangeSet current includesChangeForClass: (Smalltalk at:#MockHGP1Bar)).
    self assert: (ChangeSet current includesChangeForClass: Object selector: #bark).


    pm := HGPackageWorkingCopy named: 'mocks:hg/p1'.
    ct := pm commitTask.
    ct message:'test_commit_20a'.
    ct paths: { (ct temporaryWorkingCopy path / 'MockHGP1Bar.st') pathName }.
    ct do.
    "
    repo workingCopy browse
    "
    self assert: (ChangeSet current includesChangeForClass: (Smalltalk at:#MockHGP1Bar)) not.
    self assert: (ChangeSet current includesChangeForClass: Object selector: #bark).

    "Created: / 15-11-2014 / 00:31:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-11-2014 / 01:48:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_20d
    "
    Test, that after a commit, changeset is properly condensed
    so browser would correctly show modified (uncommited) classes.

    This tests selective commit (modify class & create an extension, commit only class)
    "

    | repo pm ct |

    repo := self repositoryNamed: 'mocks/hg/p1'.
    self assert: (Smalltalk loadPackage:'mocks:hg/p1').
    self dumpRepositoryLog: repo.


    self deny:   ((repo @ 1 / 'MockHGP1Bar.st') contents asString includesString:'zork ^ 1').

    ((Smalltalk at:#MockHGP1Bar) compile:'zork ^ 1' classified:'test') package: (Smalltalk at:#MockHGP1Bar) package.
    (Object compile:'bark ^ 1' classified: 'test') package:  (Smalltalk at:#MockHGP1Bar) package.

    self assert: (ChangeSet current includesChangeForClass: (Smalltalk at:#MockHGP1Bar)).
    self assert: (ChangeSet current includesChangeForClass: Object selector: #bark).


    pm := HGPackageWorkingCopy named: 'mocks:hg/p1'.
    ct := pm commitTask.
    ct message:'test_commit_20a'.
    ct paths: { (ct temporaryWorkingCopy path / 'extensions.st') pathName }.
    ct do.
    "
    repo workingCopy browse
    "
    self assert: (ChangeSet current includesChangeForClass: (Smalltalk at:#MockHGP1Bar)).
    self assert: (ChangeSet current includesChangeForClass: Object selector: #bark) not.

    "Created: / 15-11-2014 / 00:33:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-11-2014 / 01:48:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_21a
    "
    Test, that after a commit, changeset is properly condensed for private classes
    so browser would correctly show modified (uncommited) classes.

    This tests selective commit (modify class & create an extension, commit only class)
    "

    | repo pm ct |

    repo := self repositoryNamed: 'mocks/hg/p1'.
    self assert: (Smalltalk loadPackage:'mocks:hg/p1').
    self dumpRepositoryLog: repo.


    self deny:   ((repo @ 1 / 'MockHGP1Bar.st') contents asString includesString:'zork ^ 1').

    ((Smalltalk at:#MockHGP1Bar) compile:'zork ^ 1' classified:'test') package: (Smalltalk at:#MockHGP1Bar) package.
    "/ Create private class
    Object subclass: #Private1
        instanceVariableNames: ''
        classVariableNames: ''
        poolDictionaries: ''
        privateIn: (Smalltalk at:#MockHGP1Foo).
    "/ Compile message in private class
    ((Smalltalk at:#'MockHGP1Foo::Private1') compile:'bark ^ 2' classified:'test') package: (Smalltalk at:#MockHGP1Bar) package.

    "/ Create nested private class
    Object subclass: #Private2
        instanceVariableNames: ''
        classVariableNames: ''
        poolDictionaries: ''
        privateIn: (Smalltalk at:#'MockHGP1Foo::Private1').
    "/ Compile message in private class
    ((Smalltalk at:#'MockHGP1Foo::Private1::Private2') compile:'meouw ^ 3' classified:'test') package: (Smalltalk at:#MockHGP1Bar) package.

    self assert: (ChangeSet current includesChangeForClass: (Smalltalk at:#MockHGP1Bar)).
    self assert: (ChangeSet current includesChangeForClass: (Smalltalk at:#'MockHGP1Foo::Private1') selector: #bark).
    self assert: (ChangeSet current includesChangeForClass: (Smalltalk at:#'MockHGP1Foo::Private1::Private2') selector: #meouw).


    pm := HGPackageWorkingCopy named: 'mocks:hg/p1'.
    ct := pm commitTask.
    ct message:'test_commit_21a'.
    ct paths: { (ct temporaryWorkingCopy path / 'MockHGP1Foo.st') pathName }.
    ct do.
    "
    repo workingCopy browse
    "
    self assert: (ChangeSet current includesChangeForClass: (Smalltalk at:#MockHGP1Bar)).
    self assert: (ChangeSet current includesChangeForClass: (Smalltalk at:#'MockHGP1Foo::Private1') selector: #bark) not.
    self assert: (ChangeSet current includesChangeForClass: (Smalltalk at:#'MockHGP1Foo::Private1::Private2') selector: #meouw) not.

    "Created: / 16-11-2014 / 13:22:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_21b
    "
    Test, that after a commit, changeset is properly condensed for private classes
    so browser would correctly show modified (uncommited) classes.

    This tests selective commit (modify class & create an extension, commit only class)
    "

    | repo pm ct |

    repo := self repositoryNamed: 'mocks/hg/p1'.
    self assert: (Smalltalk loadPackage:'mocks:hg/p1').
    self dumpRepositoryLog: repo.


    self deny:   ((repo @ 1 / 'MockHGP1Bar.st') contents asString includesString:'zork ^ 1').

    ((Smalltalk at:#MockHGP1Bar) compile:'zork ^ 1' classified:'test') package: (Smalltalk at:#MockHGP1Bar) package.
    "/ Create private class
    Object subclass: #Private1
        instanceVariableNames: ''
        classVariableNames: ''
        poolDictionaries: ''
        privateIn: (Smalltalk at:#MockHGP1Foo).
    "/ Compile message in private class
    ((Smalltalk at:#'MockHGP1Foo::Private1') compile:'bark ^ 2' classified:'test') package: (Smalltalk at:#MockHGP1Bar) package.

    "/ Create nested private class
    Object subclass: #Private2
        instanceVariableNames: ''
        classVariableNames: ''
        poolDictionaries: ''
        privateIn: (Smalltalk at:#'MockHGP1Foo::Private1').
    "/ Compile message in private class
    ((Smalltalk at:#'MockHGP1Foo::Private1::Private2') compile:'meouw ^ 3' classified:'test') package: (Smalltalk at:#MockHGP1Bar) package.

    self assert: (ChangeSet current includesChangeForClass: (Smalltalk at:#MockHGP1Bar)).
    self assert: (ChangeSet current includesChangeForClass: (Smalltalk at:#'MockHGP1Foo::Private1') selector: #bark).
    self assert: (ChangeSet current includesChangeForClass: (Smalltalk at:#'MockHGP1Foo::Private1::Private2') selector: #meouw).


    pm := HGPackageWorkingCopy named: 'mocks:hg/p1'.
    ct := pm commitTask.
    ct message:'test_commit_21b'.
    ct do.
    "
    repo workingCopy browse
    "
    self assert: (ChangeSet current includesChangeForClass: (Smalltalk at:#MockHGP1Bar)) not.
    self assert: (ChangeSet current includesChangeForClass: (Smalltalk at:#'MockHGP1Foo::Private1') selector: #bark) not.
    self assert: (ChangeSet current includesChangeForClass: (Smalltalk at:#'MockHGP1Foo::Private1::Private2') selector: #meouw) not.

    "Created: / 16-11-2014 / 13:27:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_22a
    "
    Tests custom build files generation.
    "

    | repo pm ct |

    repo := self repositoryNamed: 'mocks/hg/p1'.
    self assert: (Smalltalk loadPackage:'mocks:hg/p1').
    self dumpRepositoryLog: repo.

    (Smalltalk at: #'mocks_hg_p1') class 
        compile:'generateCustomFileA <file: ''CustomA.txt'' overwrite: true> ^ ''Custom A'''
        classified: 'custom build files'.

    (Smalltalk at: #'mocks_hg_p1') class 
        compile:'generateCustomFileB <file: ''CustomB.txt'' overwrite: false> ^ ''Custom B'''
        classified: 'custom build files'.

    pm := HGPackageWorkingCopy named: 'mocks:hg/p1'.
    ct := pm commitTask.
    self assert: ct isCommitingNewHead not.
    ct message:'test_commit_22a 1'.
    ct do.
    self dumpRepositoryLog: repo.

    "
        repo workingCopy browse
    "

    self assert: ((repo @ 2 / 'CustomA.txt') contents asString includesString:'Custom A').
    self assert: ((repo @ 2 / 'CustomB.txt') contents asString includesString:'Custom B').

    "Now change the contents of generated files, commit agains
     and check that CustomA.txt changed while CustomB.not not"

    (Smalltalk at: #'mocks_hg_p1') class 
        compile:'generateCustomFileA <file: ''CustomA.txt'' overwrite: true> ^ ''Changed A'''
        classified: 'custom build files'.

    (Smalltalk at: #'mocks_hg_p1') class 
        compile:'generateCustomFileB <file: ''CustomB.txt'' overwrite: false> ^ ''Changed B'''
        classified: 'custom build files'.

    ct := pm commitTask.
    self assert: ct isCommitingNewHead not.
    ct message:'test_commit_22a 2'.
    ct do.
    self dumpRepositoryLog: repo.
    "
    (Smalltalk at: #'mocks_hg_p1') generateFile: 'CustomA.txt'
    (Smalltalk at: #'mocks_hg_p1') generateFile: 'CustomB.txt'  
    "
    self assert: ((repo @ 3 / 'CustomA.txt') contents asString includesString:'Custom A') not.
    self assert: ((repo @ 3 / 'CustomA.txt') contents asString includesString:'Changed A').
    self assert: ((repo @ 3 / 'CustomB.txt') contents asString includesString:'Custom B').

    "Created: / 16-11-2014 / 23:48:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 19-01-2015 / 22:27:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_22b
    "
    Tests custom build files generation.
    "

    | repo pm ct |

    repo := self repositoryNamed: 'mocks/hg/p1'.
    self assert: (Smalltalk loadPackage:'mocks:hg/p1').
    self dumpRepositoryLog: repo.

    (Smalltalk at: #'mocks_hg_p1') class 
        compile:'generateCustomFileA <file: ''CustomA.txt'' overwrite: true> ^ nil'
        classified: 'custom build files'.


    pm := HGPackageWorkingCopy named: 'mocks:hg/p1'.
    ct := pm commitTask.
    self assert: ct isCommitingNewHead not.
    ct message:'test_commit_22b 1'.
    ct do.
    self dumpRepositoryLog: repo.

    "
        repo workingCopy browse
    "
    self should:[ (repo @ 2 / 'CustomA.txt') ] raise: HGError. "/ no such child

    "Created: / 19-01-2015 / 22:32:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_23a
    "
    Tests creation of initial .hgignore
    "

    | repo pm ct |

    repo := self repositoryNamed: 'mocks/hg/p1'.
    self assert: (Smalltalk loadPackage:'mocks:hg/p1').
    self dumpRepositoryLog: repo.

    pm := HGPackageWorkingCopy named: 'mocks:hg/p1'.
    ct := pm commitTask.
    self assert: ct isCommitingNewHead not.
    ct message:'test_commit_23a 1'.
    ct do.
    self dumpRepositoryLog: repo.

    "
        repo workingCopy browse
    "
    self assert: (repo @ 2 / '.hgignore') notNil.

    "Created: / 20-01-2015 / 08:01:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_26a
    "
    Test commit to a fresh repository
    "

    | repo pm ct |

    repo := self repositoryNamed: 'mocks/hg/pfresh' init: true.

    Object subclass: #MockHGPFreshFoo
        instanceVariableNames: ''
        classVariableNames: ''
        poolDictionaries: ''
        category: '* Mocks *'.

    (Smalltalk at: #MockHGPFreshFoo) package: #'mocks/hg/pfresh'.

    pm := HGPackageWorkingCopy named: 'mocks/hg/pfresh'.
    ct := pm commitTask.
    self assert: ct isCommitingNewHead not.
    ct message:'test_commit_26a'.
    ct do.
    self dumpRepositoryLog: repo.

    "
        repo workingCopy browse
    "
    self assert: (repo @ 0 / 'MockHGPFreshFoo.st') notNil.
    self assert: (repo @ 0 / 'mocks_hg_pfresh.st') notNil.
    self assert: (repo @ 0 / 'Make.proto') notNil.
    self assert: ((Smalltalk at: #'mocks_hg_pfresh') classNames includes: #MockHGPFreshFoo)

    "Created: / 11-06-2015 / 06:26:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_26b
    "
    Test selective commit to a fresh repository
    "

    | repo pm ct |

    repo := self repositoryNamed: 'mocks/hg/pfresh' init: true.

    Object subclass: #MockHGPFreshFoo
        instanceVariableNames: ''
        classVariableNames: ''
        poolDictionaries: ''
        category: '* Mocks *'.

    (Smalltalk at: #MockHGPFreshFoo) package: #'mocks/hg/pfresh'.

    pm := HGPackageWorkingCopy named: 'mocks/hg/pfresh'.
    ct := pm commitTask.
    self assert: ct isCommitingNewHead not.
    ct message:'test_commit_26b'.
    ct classes: (Array with: (Smalltalk at: #MockHGPFreshFoo)).                      
    ct do.
    self dumpRepositoryLog: repo.

    "
        repo workingCopy browse
    "
    self assert: (repo @ 0 / 'MockHGPFreshFoo.st') notNil.
    self assert: (repo @ 0 / 'mocks_hg_pfresh.st') notNil.
    self assert: (repo @ 0 / 'Make.proto') notNil.
    self assert: ((Smalltalk at: #'mocks_hg_pfresh') classNames includes: #MockHGPFreshFoo)

    "Created: / 11-06-2015 / 06:29:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_27
    "
    Simple commit using shared repository
    "

    | repo pm ct |

    UserPreferences current hgUseSharedRepositories: true.  

    repo := self repositoryNamed: 'mocks/hg/p1'.
    self assert: (Smalltalk loadPackage:'mocks:hg/p1').
    self dumpRepositoryLog: repo.


    self deny:   ((repo @ 1 / 'MockHGP1Bar.st') contents asString includesString:'zork ^ 1').

    (MockHGP1Bar compile:'zork ^ 1' classified:'test') package: MockHGP1Bar package.
    pm := HGPackageWorkingCopy named: 'mocks:hg/p1'.
    ct := pm commitTask.
    self assert: ct isCommitingNewHead not.
    ct message:'test_commit_01'.
    ct do.
    self dumpRepositoryLog: repo.

    "
        repo workingCopy browse
    "
    self assert: ((repo @ 2 / 'MockHGP1Bar.st') contents asString includesString:'zork ^ 1').
    self assert: (Smalltalk at:#mocks_hg_p1) hgLogicalRevision revno = 2.

    "Created: / 25-08-2015 / 09:02:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_28
    "
    Simple commit amending
    "

    | repo pm ct tip |

    UserPreferences current hgUseSharedRepositories: true. 

    repo := self repositoryNamed: 'mocks/hg/p1'.
    self assert: (Smalltalk loadPackage:'mocks:hg/p1').
    self dumpRepositoryLog: repo.


    self deny:   ((repo @ 1 / 'MockHGP1Bar.st') contents asString includesString:'zork ^ 1').

    ((Smalltalk at:#MockHGP1Bar) compile:'zork ^ 1' classified:'test') package: (Smalltalk at:#MockHGP1Bar) package.
    pm := HGPackageWorkingCopy named: 'mocks:hg/p1'.
    ct := pm commitTask.
    self assert: ct isCommitingNewHead not.
    self assert: ct isAmendable.
    ct message:'test_commit_28'.
    ct do.
    self dumpRepositoryLog: repo.

    "
    repo workingCopy browse
    "
    self assert: ((repo @ 2 / 'MockHGP1Bar.st') contents asString includesString:'zork ^ 1').
    self assert: (Smalltalk at:#mocks_hg_p1) hgLogicalRevision revno = 2.



    ((Smalltalk at:#MockHGP1Bar) compile:'zork ^ 2' classified:'test') package: (Smalltalk at:#MockHGP1Bar) package.
    ct := pm commitTask.
    self assert: ct isCommitingNewHead not.
    ct message:'test_commit_28 (amended)'.
    ct amend: true.
    ct do.
    self dumpRepositoryLog: repo.

    "
    repo workingCopy browse
    "
    tip := (repo changesetsMatching:'tip') anElement.

    self assert: ((tip / 'MockHGP1Bar.st') contents asString includesString:'zork ^ 2').
    self assert: (Smalltalk at:#mocks_hg_p1) hgLogicalRevision revno = tip id revno.

    "Created: / 25-08-2015 / 16:16:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-01-2018 / 20:18:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_29
    "
    Simple commit amending. Check that commit cannot be amended
    when not commiting on top of head revision (but only if
    evolve is not enabled, with evolve it's possible)
    "

    | repo pm ct |

    UserPreferences current hgUseSharedRepositories: true. 

    repo := self repositoryNamed: 'mocks/hg/p2' revision: '2'.
    self skipIf: repo hasExtensionEvolve description: 'evolve extension is enabled'.
    self assert: (Smalltalk loadPackage:'mocks:hg/p2').
    self dumpRepositoryLog: repo.


    self deny:   ((repo @ 1 / 'MocksHgP2Foo.st') contents asString includesString:'zork ^ 1').

    ((Smalltalk at:#MocksHgP2Foo) compile:'zork ^ 1' classified:'test') package: (Smalltalk at:#MocksHgP2Foo) package.
    pm := HGPackageWorkingCopy named: 'mocks:hg/p2'.
    ct := pm commitTask.
    self assert: ct isCommitingNewHead.
    self assert: ct isAmendable not.
    ct message:'test_commit_29'.
    ct do.
    self dumpRepositoryLog: repo.

    "Created: / 27-08-2015 / 18:37:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-03-2018 / 23:30:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_30a
    "
    Test commit with setting up a bookmark (don't use shared working copy)
    "

     | repo pm ct |

    UserPreferences current hgUseSharedRepositories: false. 
    repo := self repositoryNamed: 'mocks/hg/p1'.
    self assert: (Smalltalk loadPackage:'mocks:hg/p1').
    self dumpRepositoryLog: repo.


    self deny:   ((repo @ 1 / 'MockHGP1Bar.st') contents asString includesString:'zork ^ 1').

    ((Smalltalk at:#MockHGP1Bar) compile:'zork ^ 1' classified:'test') package: (Smalltalk at:#MockHGP1Bar) package.
    pm := HGPackageWorkingCopy named: 'mocks:hg/p1'.
    ct := pm commitTask.
    self assert: ct isCommitingNewHead not.
    ct message: testSelector asString.
    ct bookmark: testSelector asString.
    ct do.
    self dumpRepositoryLog: repo.

    "
        repo workingCopy browse
    "
    self assert: (repo @ 2) bookmarks size == 1.
    self assert: (repo @ 2) bookmarks anElement name = testSelector.

    "Created: / 27-06-2016 / 11:39:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_30b
    "
    Test commit with setting up a bookmark (don't use shared working copy)
    "

     | repo pm ct |

    UserPreferences current hgUseSharedRepositories: true. 
    repo := self repositoryNamed: 'mocks/hg/p1'.
    self assert: (Smalltalk loadPackage:'mocks:hg/p1').
    self dumpRepositoryLog: repo.


    self deny:   ((repo @ 1 / 'MockHGP1Bar.st') contents asString includesString:'zork ^ 1').

    ((Smalltalk at:#MockHGP1Bar) compile:'zork ^ 1' classified:'test') package: (Smalltalk at:#MockHGP1Bar) package.
    pm := HGPackageWorkingCopy named: 'mocks:hg/p1'.
    ct := pm commitTask.
    self assert: ct isCommitingNewHead not.
    ct message: testSelector asString.
    ct bookmark: testSelector asString.
    ct do.
    self dumpRepositoryLog: repo.

    "
        repo workingCopy browse
    "
    self assert: (repo @ 2) bookmarks size == 1.
    self assert: (repo @ 2) bookmarks anElement name = testSelector.

    "Created: / 27-06-2016 / 11:43:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_31a
    "
    Test the following scenario when using shared working copies

      1. load package
      2. modify and commit normally (using HGCommitTask)
      3. modify and commit --amend from outside
      4. modify and commit normally again
    "

    | repo pm ct wc |

    self skipIf: HGCommand hgVersionIsGreaterOrEqualThan_4_1 not description: 'No support for successors()'.

    UserPreferences current hgUseSharedRepositories: true.       

    "/ 1. load package
    repo := self repositoryNamed: 'mocks/hg/p1'.
    self skipIf: repo hasExtensionEvolve not description: 'No evolve extension'.

    self assert: (Smalltalk loadPackage:'mocks:hg/p1').
    self dumpRepositoryLog: repo.
    self deny:   ((repo @ 1 / 'MockHGP1Bar.st') contents asString includesString:'zork ^ 1').

    "/ 2. modify and commit normally (using HGCommitTask)
    ((Smalltalk at:#MockHGP1Bar) compile:'zork ^ 1' classified:'test') package: (Smalltalk at:#MockHGP1Bar) package.
    pm := HGPackageWorkingCopy named: 'mocks:hg/p1'.
    ct := pm commitTask.
    self assert: ct isPackageLogicalRevisonObsolete not.
    self assert: ct changesetSuccessors isEmpty.
    ct message: testSelector , '-2'.
    ct do.
    self dumpRepositoryLog: repo.

    self assert: ((repo @ 2 / 'MockHGP1Bar.st') contents asString includesString:'zork ^ 1').
    self assert: (Smalltalk at:#mocks_hg_p1) hgLogicalRevision revno = 2.

    "/ 3. modify and commit --amend from outside
    wc := pm temporaryWorkingCopy.
    self assert: wc changeset id = (repo @ 2) id.
    ( wc / 'notes.txt' ) writingFileDo:[:s | s nextPutAll:'some notes' ].
    wc track: (Array with:( wc / 'notes.txt' )).
    wc commit: testSelector , '-3' files: #('notes.txt') author: testSelector amend: true.
    self dumpRepositoryLog: repo.     
    self assert: wc changeset id = (repo changesetsMatching: 'tip') first id.

    "/ 4. modify and commit normally again
    ((Smalltalk at:#MockHGP1Bar) compile:'zork ^ 100' classified:'test') package: (Smalltalk at:#MockHGP1Bar) package.
    pm := HGPackageWorkingCopy named: 'mocks:hg/p1'.
    ct := pm commitTask.
    self assert: ct isPackageLogicalRevisonObsolete.
    self assert: ct changesetSuccessors size == 1.
    self assert: ct changesetSuccessors anElement id = wc changeset id.
    ct message: testSelector , '-4'.

    "/ attempt to commit should throw HGObsoleteRevisionError.
    "/ because current logical revision is obsolete.
    self should: [ ct do ] raise: HGObsoleteRevisionError.

    "/ update the logical revision and try again.
    ct doUpdateLogicalRevisionTo: ct changesetSuccessors anElement id.
    ct do.
    self assert: wc changeset id = (repo changesetsMatching: 'tip') first id.

    "Created: / 07-02-2018 / 22:44:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-03-2018 / 11:48:11 / jv"
    "Modified: / 29-03-2018 / 15:49:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_31b
    "
    Test that the HGCommitTask >> #changesetSuccessors returns
    an empty set in case evolve extension is not enabled.
    "

    | repo pm ct |

    UserPreferences current hgUseSharedRepositories: true.       

    "/ 1. load package
    repo := self repositoryNamed: 'mocks/hg/p1'.
    self skipIf: repo hasExtensionEvolve description: 'evolve extension enabled'.

    self assert: (Smalltalk loadPackage:'mocks:hg/p1').
    self dumpRepositoryLog: repo.
    self deny:   ((repo @ 1 / 'MockHGP1Bar.st') contents asString includesString:'zork ^ 1').

    "/ 2. modify and commit normally (using HGCommitTask)
    ((Smalltalk at:#MockHGP1Bar) compile:'zork ^ 1' classified:'test') package: (Smalltalk at:#MockHGP1Bar) package.
    pm := HGPackageWorkingCopy named: 'mocks:hg/p1'.
    ct := pm commitTask.
    self assert: ct isPackageLogicalRevisonObsolete not.
    self assert: ct changesetSuccessors isEmpty.
    ct message: testSelector , '-2'.
    ct do.
    self dumpRepositoryLog: repo.

    self assert: ((repo @ 2 / 'MockHGP1Bar.st') contents asString includesString:'zork ^ 1').
    self assert: (Smalltalk at:#mocks_hg_p1) hgLogicalRevision revno = 2.

    "Created: / 22-03-2018 / 22:49:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_31c
    "
    Test the following scenario when using shared working copies

      1. load package
      2. modify and commit normally (using HGCommitTask)
      3. modify and commit --amend from outside
      4. modify and commit normally again
    "

    | repo pm ct wc |

    self skipIf: HGCommand hgVersionIsGreaterOrEqualThan_4_1 description: 'This test requires mercurtial no support for successors()'.

    UserPreferences current hgUseSharedRepositories: true.       

    "/ 1. load package
    repo := self repositoryNamed: 'mocks/hg/p1'.
    self skipIf: repo hasExtensionEvolve not description: 'No evolve extension'.

    self assert: (Smalltalk loadPackage:'mocks:hg/p1').
    self dumpRepositoryLog: repo.
    self deny:   ((repo @ 1 / 'MockHGP1Bar.st') contents asString includesString:'zork ^ 1').

    "/ 2. modify and commit normally (using HGCommitTask)
    ((Smalltalk at:#MockHGP1Bar) compile:'zork ^ 1' classified:'test') package: (Smalltalk at:#MockHGP1Bar) package.
    pm := HGPackageWorkingCopy named: 'mocks:hg/p1'.
    ct := pm commitTask.
    self assert: ct isPackageLogicalRevisonObsolete not.
    self assert: ct changesetSuccessors isEmpty.
    ct message: testSelector , '-2'.
    ct do.
    self dumpRepositoryLog: repo.

    self assert: ((repo @ 2 / 'MockHGP1Bar.st') contents asString includesString:'zork ^ 1').
    self assert: (Smalltalk at:#mocks_hg_p1) hgLogicalRevision revno = 2.

    "/ 3. modify and commit --amend from outside
    wc := pm temporaryWorkingCopy.
    self assert: wc changeset id = (repo @ 2) id.
    ( wc / 'notes.txt' ) writingFileDo:[:s | s nextPutAll:'some notes' ].
    wc track: (Array with:( wc / 'notes.txt' )).
    wc commit: testSelector , '-3' files: #('notes.txt') author: testSelector amend: true.
    self dumpRepositoryLog: repo.     
    self assert: wc changeset id = (repo changesetsMatching: 'tip') first id.

    "/ 4. modify and commit normally again
    ((Smalltalk at:#MockHGP1Bar) compile:'zork ^ 100' classified:'test') package: (Smalltalk at:#MockHGP1Bar) package.
    pm := HGPackageWorkingCopy named: 'mocks:hg/p1'.
    ct := pm commitTask.
    self assert: ct isPackageLogicalRevisonObsolete.
    self assert: ct changesetSuccessors isEmpty.

    "Created: / 29-03-2018 / 15:51:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_issue63
    "
    Issue #63: Windowns specific classes are lost when build files are generated under Unix

    See https://swing.fit.cvut.cz/projects/stx-jv/ticket/63
    "

    | pm ct classes1 classes2 |

    [

    classes1 := stx_libbasic classNamesAndAttributes.

    pm := HGPackageWorkingCopy named: 'stx:libbasic'.
    ct := pm commitTask.
    ct doInitStateVariables.
    ct doUpdateProjectDefinition.

    classes2 := stx_libbasic classNamesAndAttributes.

    self assert: (classes1 \ classes2) isEmpty.
    self assert: (classes2 \ classes1) isEmpty.


    ] ensure:[ 
        stx_libbasic  classNamesAndAttributes:classes1 usingCompiler:nil.          
    ].

    "Created: / 24-07-2017 / 23:05:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGStXTests methodsFor:'tests - commit - java'!

test_commit_16a
    "
    Test correct fileout if Java extensions
    "

    | repo pmN111 ctN111 java_lang_String changeset |

    "/ Hack for rel 6.2.2 - should use 'self skipIf: ... '
    "/ but this is not supported by 6.2.2's SUnit..."
    (Smalltalk versionString = '6.2.2') ifTrue:[ ^ self ].

    repo := self repositoryNamed: 'mocks/hg/p5'.
    self assert: (Smalltalk loadPackage:'mocks:hg/p5').

    "/ Do skipIf after package is loaded!!!!!! otherwise the
    "/ Java extension is not loaded!!

    self skipIf: self stxlibjavaAvailable not description: 'STX:LIBJAVA not available'.

    java_lang_String := Java classForName: 'java.lang.String'.
    (Compiler compile:'test_commit_16a ^ #foo'  forClass: java_lang_String)
        package:#'mocks:hg/p5'.
    self assert: (java_lang_String methodDictionary includesKey:#test_commit_16a).

    pmN111 := HGPackageWorkingCopy named: #'mocks:hg/p5'.
    ctN111 := pmN111 commitTask.
    ctN111 message:'test_commit_16a '.
    ctN111 do.
    "
    repo workingCopy browse
    "
    changeset := repo @ 2.

    self assert: (changeset changes contains:[:change | change isAdded ]).
    self deny: (changeset changes contains:[:change | change isRemoved ]).

    self assert: (changeset / 'java' / 'extensions' / 'java' / 'lang' / 'String.st' ) notNil.

    "Created: / 29-11-2013 / 16:25:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-03-2014 / 21:47:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_16b
    "
    Test covering issue #26: Java extension files are removed.

    Check, that if the particular class is not loaded in the system,
    extension file is kept intact.
    "

    | repo pmN111 ctN111 changeset |

    "/ Hack for rel 6.2.2 - should use 'self skipIf: ... '
    "/ but this is not supported by 6.2.2's SUnit..."
    (Smalltalk versionString = '6.2.2') ifTrue:[ ^ self ].


    repo := self repositoryNamed: 'mocks/hg/p5'.
    self assert: (Smalltalk loadPackage:'mocks:hg/p5').

    "/ Do skipIf after package is loaded!!!!!! otherwise the
    "/ Java extension is not loaded!!
    self skipIf: self stxlibjavaAvailable not description: 'STX:LIBJAVA not available'.

    "/ Flush Java to make sure java.lang.Object is not loaded.
    (Smalltalk at:#Java) flushAllJavaResources.


    pmN111 := HGPackageWorkingCopy named: #'mocks:hg/p5'.
    ctN111 := pmN111 commitTask.
    ctN111 message:'test_commit_16a '.
    ctN111 do.
    "
    repo workingCopy browse
    "
    changeset := repo @ 2.

    self deny: (changeset changes select:[:change | change isAdded ]) size == 1. "/.hgignore.
    self deny: (changeset changes contains:[:change | change isRemoved ]).

    self assert: (changeset / 'java' / 'extensions' / 'java' / 'lang' / 'Object.st' ) notNil.

    "Created: / 29-11-2013 / 17:34:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 20-01-2015 / 11:38:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_java_01a
    "
    Test commit of Java classes
    "

    | repo classes pm ct changeset |

    "/ Hack for rel 6.2.2 - should use 'self skipIf: ... '
    "/ but this is not supported by 6.2.2's SUnit..."
    (Smalltalk versionString = '6.2.2') ifTrue:[ ^ self ].

    repo := self repositoryNamed: 'mocks/hg/p5'.
    self assert: (Smalltalk loadPackage:'mocks:hg/p5').

    "/ Do skipIf after package is loaded!!!!!! otherwise the
    "/ Java extension is not loaded!!

    self skipIf: (self stxlibjavaAvailableRequireReboot: false) not description: 'STX:LIBJAVA not available'.

    classes := JavaCompiler compile:'
package mocks.hg.p5;

@stx.libjava.annotation.Package("mocks:hg/p5")
class Foo {
}
'.
    JavaVM registry registerClasses: classes andWait: true.
    

    pm := HGPackageWorkingCopy named: #'mocks:hg/p5'.
    ct := pm commitTask.
    ct message: testSelector.
    ct do.
    "
    repo workingCopy browse
    "
    changeset := repo @ 2.

    "/ Four files shall be added:
    "/ Foo.java
    "/ build.xml
    "/ build.auto.xml
    "/ .hgignore
    self assert: (changeset changes select:[:change | change isAdded ]) size == 5.


    self assert: (changeset / 'java' / 'src' / 'mocks' / 'hg' / 'p5' / 'Foo.java' ) notNil.

    "Created: / 04-08-2014 / 01:42:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-07-2016 / 20:39:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_java_01b
    "
    Test commit of Java class with nested class
    "

    | repo classes pm ct changeset |

    "/ Hack for rel 6.2.2 - should use 'self skipIf: ... '
    "/ but this is not supported by 6.2.2's SUnit..."
    (Smalltalk versionString = '6.2.2') ifTrue:[ ^ self ].

    repo := self repositoryNamed: 'mocks/hg/p5'.
    self assert: (Smalltalk loadPackage:'mocks:hg/p5').

    "/ Do skipIf after package is loaded!!!!!! otherwise the
    "/ Java extension is not loaded!!

    self skipIf: (self stxlibjavaAvailableRequireReboot: false) not description: 'STX:LIBJAVA not available'.

    classes := JavaCompiler compile:'
package mocks.hg.p5;

@stx.libjava.annotation.Package("mocks:hg/p5")
public class Foo {
    public static class Bar {
        public Object foo() {
            return new Object() { public int bar() { return 10; } };
        }

    }
}
'.
    JavaVM registry registerClasses: classes andWait: true.
    

    pm := HGPackageWorkingCopy named: #'mocks:hg/p5'.
    ct := pm commitTask.
    ct message: testSelector.
    ct do.
    "
    repo workingCopy browse
    "
    changeset := repo @ 2.

    "/ Four files shall be added:
    "/ Foo.java
    "/ build.xml
    "/ build.auto.xml
    "/ .hgignore      
    self assert: (changeset changes select:[:change | change isAdded ]) size == 5.

    self assert: (changeset / 'java' / 'src' / 'mocks' / 'hg' / 'p5' / 'Foo.java' ) notNil.

    "Created: / 04-08-2014 / 01:43:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-07-2016 / 20:39:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_java_01c
    "
    Test selective commit of Java class into fresh, non-java package   
    "

    | repo classes pm ct changeset |

    "/ Hack for rel 6.2.2 - should use 'self skipIf: ... '
    "/ but this is not supported by 6.2.2's SUnit..."
    (Smalltalk versionString = '6.2.2') ifTrue:[ ^ self ].

    repo := self repositoryNamed: 'mocks/hg/pfresh' init: true.

    "/ Do skipIf after package is loaded!!!!!! otherwise the
    "/ Java extension is not loaded!!

    self skipIf: (self stxlibjavaAvailableRequireReboot: false) not description: 'STX:LIBJAVA not available'.

    Object subclass: #MockHGPFreshFoo
        instanceVariableNames: ''
        classVariableNames: ''
        poolDictionaries: ''
        category: '* Mocks *'.  
    (Smalltalk at: #MockHGPFreshFoo) package: #'mocks:hg/pfresh'.

    pm := HGPackageWorkingCopy named: #'mocks:hg/pfresh'.    
    ct := pm commitTask.
    ct message: testSelector.
    ct do.

    "/ Check that there's no #javaBundle (yet)
    self assert: ((Smalltalk at:#'mocks_hg_pfresh') class methodDictionary includesKey: #javaBundle) not.

    classes := JavaCompiler compile:'
package mocks.hg.pfresh;

@stx.libjava.annotation.Package("mocks:hg/pfresh")
class Foo {
}
'.
    JavaVM registry registerClasses: classes andWait: true.
    


    ct := pm commitTask.
    ct message: testSelector.
    ct classes: classes.
    ct do.
    "
    repo workingCopy browse
    ct temporaryWorkingCopy browse
    "
    changeset := repo @ 1.

    "/ Three files shall be added:
    "/ Foo.java
    "/ build.xml
    "/ build.auto.xml
    self assert: (changeset changes select:[:change | change isAdded ]) size == 3.
    self assert: (changeset / 'java' / 'src' / 'mocks' / 'hg' / 'pfresh' / 'Foo.java' ) notNil.

    "/ Check that #javaBundle has been generated
    self assert: ((Smalltalk at:#'mocks_hg_pfresh') class methodDictionary includesKey: #javaBundle)

    "Created: / 11-06-2015 / 08:01:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-06-2015 / 19:41:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 11-06-2015 / 22:05:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_java_01d
    "
    Test commit of Java class into fresh, non-java package
    "

    | repo classes pm ct changeset |

    "/ Hack for rel 6.2.2 - should use 'self skipIf: ... '
    "/ but this is not supported by 6.2.2's SUnit..."
    (Smalltalk versionString = '6.2.2') ifTrue:[ ^ self ].

    repo := self repositoryNamed: 'mocks/hg/pfresh' init: true.

    "/ Do skipIf after package is loaded!!!!!! otherwise the
    "/ Java extension is not loaded!!

    self skipIf: (self stxlibjavaAvailableRequireReboot: false) not description: 'STX:LIBJAVA not available'.

    Object subclass: #MockHGPFreshFoo
        instanceVariableNames: ''
        classVariableNames: ''
        poolDictionaries: ''
        category: '* Mocks *'.  
    (Smalltalk at: #MockHGPFreshFoo) package: #'mocks:hg/pfresh'.

    pm := HGPackageWorkingCopy named: #'mocks:hg/pfresh'.    
    ct := pm commitTask.
    ct message: testSelector.
    ct do.

    "/ Check that there's no #javaBundle (yet)
    self assert: ((Smalltalk at:#'mocks_hg_pfresh') class methodDictionary includesKey: #javaBundle) not.

    classes := JavaCompiler compile:'
package mocks.hg.pfresh;

@stx.libjava.annotation.Package("mocks:hg/pfresh")
class Foo {
}
'.
    JavaVM registry registerClasses: classes andWait: true.
    


    ct := pm commitTask.
    ct message: testSelector.
    ct do.
    "
    repo workingCopy browse
    ct temporaryWorkingCopy browse
    "
    changeset := repo @ 1.

    "/ Three files shall be added:
    "/ Foo.java
    "/ build.xml
    "/ build.auto.xml
    self assert: (changeset changes select:[:change | change isAdded ]) size == 3.
    self assert: (changeset / 'java' / 'src' / 'mocks' / 'hg' / 'pfresh' / 'Foo.java' ) notNil.

    "/ Check that #javaBundle has been generated
    self assert: ((Smalltalk at:#'mocks_hg_pfresh') class methodDictionary includesKey: #javaBundle)

    "Created: / 11-06-2015 / 21:26:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_java_01e
    "
    Test selective commit of Java class
    "

    | repo classes pm ct changeset |

    "/ Hack for rel 6.2.2 - should use 'self skipIf: ... '
    "/ but this is not supported by 6.2.2's SUnit..."
    (Smalltalk versionString = '6.2.2') ifTrue:[ ^ self ].

    repo := self repositoryNamed: 'mocks/hg/p5'.
    self assert: (Smalltalk loadPackage:'mocks:hg/p5').

    "/ Do skipIf after package is loaded!!!!!! otherwise the
    "/ Java extension is not loaded!!

    self skipIf: (self stxlibjavaAvailableRequireReboot: false) not description: 'STX:LIBJAVA not available'.

    classes := JavaCompiler compile:'
package mocks.hg.p5;

@stx.libjava.annotation.Package("mocks:hg/p5")
class Foo {
}
'.
    JavaVM registry registerClasses: classes andWait: true.
    

    pm := HGPackageWorkingCopy named: #'mocks:hg/p5'.
    ct := pm commitTask.
    ct message: testSelector.
    ct classes: classes.
    ct do.
    "
    repo workingCopy browse
    ct temporaryWorkingCopy browse
    "
    changeset := repo @ 2.

    "/ Three files shall be added:
    "/ Foo.java
    "/ build.xml
    "/ build.auto.xml
    self assert: (changeset changes select:[:change | change isAdded ]) size == 3.

    self assert: (changeset / 'java' / 'src' / 'mocks' / 'hg' / 'p5' / 'Foo.java' ) notNil.

    "Created: / 11-06-2015 / 08:01:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"

    
! !

!HGStXTests methodsFor:'tests - commit - nested'!

test_commit_nested_01a
    "
    Nested packages
      mocks:hg/p2
      mocks:hg/p2/n1
      mocks:hg/p2/n2

    1) load all of them
    2) modify & commit p1
    3) check that n1 & n2 has same logical revision as p1.
    "

    | repo pmP2 pmP2N1 pmP2N2 ctP2 |

    repo := self repositoryNamed: 'mocks/hg/p2'.
    self assert: (Smalltalk loadPackage:'mocks:hg/p2').
    self assert: (Smalltalk loadPackage:'mocks:hg/p2/n1').
    self assert: (Smalltalk loadPackage:'mocks:hg/p2/n2').
    pmP2   := HGPackageWorkingCopy named: 'mocks:hg/p2'.
    pmP2N1 := HGPackageWorkingCopy named: 'mocks:hg/p2/n1'.
    pmP2N2 := HGPackageWorkingCopy named: 'mocks:hg/p2/n2'.
    self assert: pmP2N1 revision = pmP2N2 revision.

    "=== A modifies & commits =============================== "
    ((Smalltalk at: #MocksHgP2Foo) compile:'zork ^ 2' classified:'test') package: (Smalltalk at: #MocksHgP2Foo) package.

    ctP2 := pmP2 commitTask.
    ctP2 message:'test_commit_nested_01a 1'.
    ctP2 do.

    self assert: pmP2 revision = pmP2N1  revision.
    self assert: pmP2 revision = pmP2N2   revision.

    "
    repo workingCopy browse
    "

    "Created: / 18-02-2014 / 20:32:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-03-2014 / 21:47:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_nested_01b
    "
    Nested packages
      mocks:hg/p2
      mocks:hg/p2/n1
      mocks:hg/p2/n2

    1) load all of them
    2) modify & commit n1
    3) check that p1 & n2 has same logical revision as n1.
    "

    | repo pmP2 pmP2N1 pmP2N2 ctP2N1 |

    repo := self repositoryNamed: 'mocks/hg/p2'.
    self assert: (Smalltalk loadPackage:'mocks:hg/p2').
    self assert: (Smalltalk loadPackage:'mocks:hg/p2/n1').
    self assert: (Smalltalk loadPackage:'mocks:hg/p2/n2').
    pmP2   := HGPackageWorkingCopy named: 'mocks:hg/p2'.
    pmP2N1 := HGPackageWorkingCopy named: 'mocks:hg/p2/n1'.
    pmP2N2 := HGPackageWorkingCopy named: 'mocks:hg/p2/n2'.
    self assert: pmP2N1 revision = pmP2N2 revision.

    "=== A modifies & commits =============================== "
    ((Smalltalk at: #MocksHgP2N1Foo) compile:'zork ^ 2' classified:'test') package: (Smalltalk at: #MocksHgP2N1Foo) package.

    ctP2N1 := pmP2N1 commitTask.
    ctP2N1 message:'test_commit_nested_01b 1'.
    ctP2N1 do.

    self assert: pmP2 revision = pmP2N1 revision.
    self assert: pmP2 revision = pmP2N2 revision.

    "
    repo workingCopy browse
    "

    "Created: / 18-02-2014 / 20:35:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-03-2014 / 21:47:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_nested_01c
    "
    Nested packages
      mocks:hg/p2
      mocks:hg/p2/n1
      mocks:hg/p2/n2

    1) load all of them
    2) modify & commit n2
    3) check that p1 & n1 has same logical revision as n2.
    "

    | repo pmP2 pmP2N1 pmP2N2 ctP2N2 |

    repo := self repositoryNamed: 'mocks/hg/p2'.
    self assert: (Smalltalk loadPackage:'mocks:hg/p2').
    self assert: (Smalltalk loadPackage:'mocks:hg/p2/n1').
    self assert: (Smalltalk loadPackage:'mocks:hg/p2/n2').
    pmP2   := HGPackageWorkingCopy named: 'mocks:hg/p2'.
    pmP2N1 := HGPackageWorkingCopy named: 'mocks:hg/p2/n1'.
    pmP2N2 := HGPackageWorkingCopy named: 'mocks:hg/p2/n2'.
    self assert: pmP2N1 revision = pmP2N2 revision.

    "=== A modifies & commits =============================== "
    ((Smalltalk at: #MocksHgP2N2Foo) compile:'zork ^ 2' classified:'test') package: (Smalltalk at: #MocksHgP2N2Foo) package.

    ctP2N2 := pmP2N2 commitTask.
    ctP2N2 message:'test_commit_nested_01c 1'.
    ctP2N2 do.

    self assert: pmP2 revision = pmP2N1 revision.
    self assert: pmP2 revision = pmP2N2 revision.

    "
    repo workingCopy browse
    "

    "Created: / 18-02-2014 / 20:36:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-03-2014 / 21:47:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_nested_02a
    "
    Two packages in single repository but without 'parent' package.
      mocks:hg/p2/n1
      mocks:hg/p2/n2

    1) load both (they should be of same revision)
    2) modify & commit n1
    3) check that n2 has same logical revision as n1.
    "

    | repo pmN1 pmN2 ctN1 |

    repo := self repositoryNamed: 'mocks/hg/p2'.
    self assert: (Smalltalk loadPackage:'mocks:hg/p2/n1').
    self assert: (Smalltalk loadPackage:'mocks:hg/p2/n2').
    pmN1 := HGPackageWorkingCopy named: 'mocks:hg/p2/n1'.
    pmN2 := HGPackageWorkingCopy named: 'mocks:hg/p2/n2'.
    self assert: pmN1 revision = pmN2 revision.

    "=== A modifies & commits =============================== "
    (MocksHgP2N1Foo compile:'zork ^ 2' classified:'test') package: MocksHgP2N1Foo package.

    ctN1 := pmN1 commitTask.
    ctN1 message:'test_commit_nested_02a 1'.
    ctN1 do.

    self assert: pmN1 revision = pmN2 revision.

    "
    repo workingCopy browse
    "

    "Created: / 18-02-2014 / 20:37:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-03-2014 / 21:47:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_nested_03a
    "
    Nested packages
      mocks:hg/p2
      mocks:hg/p2/n1
      mocks:hg/p2/n2

    1) load all of them
    2) modify & commit p1 & n1
    3) check that n1 & n2 has same logical revision as p1.
       check that n1 has been commited too.
    "

    | repo pmP2 pmP2N1 pmP2N2 ctP2 |

    repo := self repositoryNamed: 'mocks/hg/p2'.
    self assert: (Smalltalk loadPackage:'mocks:hg/p2').
    self assert: (Smalltalk loadPackage:'mocks:hg/p2/n1').
    self assert: (Smalltalk loadPackage:'mocks:hg/p2/n2').
    pmP2   := HGPackageWorkingCopy named: 'mocks:hg/p2'.
    pmP2N1 := HGPackageWorkingCopy named: 'mocks:hg/p2/n1'.
    pmP2N2 := HGPackageWorkingCopy named: 'mocks:hg/p2/n2'.
    self assert: pmP2N1 revision = pmP2N2 revision.

    "=== A modifies & commits =============================== "
    ((Smalltalk at: #MocksHgP2Foo) compile:'zork ^ 2' classified:'test') package: (Smalltalk at: #MocksHgP2Foo) package.
    ((Smalltalk at: #MocksHgP2N1Foo) compile:'zork ^ 2' classified:'test') package: (Smalltalk at: #MocksHgP2N1Foo) package.

    ctP2 := pmP2 commitTask.
    ctP2 message:'test_commit_nested_01a 1'.
    ctP2 do.

    self assert: pmP2 revision = pmP2N1  revision.
    self assert: pmP2 revision = pmP2N2   revision.
    self assert: ((repo @ 4 / 'MocksHgP2Foo.st') contents asString includesString:'zork ^ 2').
    self assert: ((repo @ 4 / 'n1' / 'MocksHgP2N1Foo.st') contents asString includesString:'zork ^ 2').

    "
    repo workingCopy browse
    "

    "Created: / 18-02-2014 / 20:57:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-03-2014 / 21:46:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_nested_03b
    "
    Nested packages
      mocks:hg/p2
      mocks:hg/p2/n1
      mocks:hg/p2/n2

    1) load all of them
    2) modify p1 & n1, commit n1
    3) check that commit task warn about parent package
       being changed and in need to be commited too...
    "

    | repo pmP2 pmP2N1 pmP2N2 ctP2N1 |

    repo := self repositoryNamed: 'mocks/hg/p2'.
    self assert: (Smalltalk loadPackage:'mocks:hg/p2').
    self assert: (Smalltalk loadPackage:'mocks:hg/p2/n1').
    self assert: (Smalltalk loadPackage:'mocks:hg/p2/n2').
    pmP2   := HGPackageWorkingCopy named: 'mocks:hg/p2'.
    pmP2N1 := HGPackageWorkingCopy named: 'mocks:hg/p2/n1'.
    pmP2N2 := HGPackageWorkingCopy named: 'mocks:hg/p2/n2'.
    self assert: pmP2N1 revision = pmP2N2 revision.

    "=== A modifies & commits =============================== "
    ((Smalltalk at: #MocksHgP2Foo) compile:'zork ^ 2' classified:'test') package: (Smalltalk at: #MocksHgP2Foo) package.
    ((Smalltalk at: #MocksHgP2N1Foo) compile:'zork ^ 2' classified:'test') package: (Smalltalk at: #MocksHgP2N1Foo) package.

    ctP2N1 := pmP2N1 commitTask.
    ctP2N1 message:'test_commit_nested_03b 1'.

    self assert: ctP2N1 isCommitingAllChangedPackages not.

    ctP2N1 do.

    self assert: pmP2 revision = pmP2N1  revision.
    self assert: pmP2 revision = pmP2N2   revision.
    self assert: ((repo @ 4 / 'MocksHgP2Foo.st') contents asString includesString:'zork ^ 2') not.
    self assert: ((repo @ 4 / 'n1' / 'MocksHgP2N1Foo.st') contents asString includesString:'zork ^ 2').

    "
    repo workingCopy browse
    "

    "Created: / 18-02-2014 / 21:38:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-03-2014 / 21:46:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_nested_04a
    "
    Nested packages
      mocks:hg/p2      @ 3
      mocks:hg/p2/n1   @ 3
      mocks:hg/p2/n2   @ 2

    1) load all of them
    2) modify & commit p1
    3) check that n1 has same logical revision as p1
       but NOT n2
    "

    | repo pmP2 pmP2N1 pmP2N2 ctP2 |

    repo := self repositoryNamed: 'mocks/hg/p2'.
    self assert: (Smalltalk loadPackage:'mocks:hg/p2').
    self assert: (Smalltalk loadPackage:'mocks:hg/p2/n1').
    self assert: (Smalltalk loadPackage:'mocks:hg/p2/n2').

    "/ Force n2 to think it comes from rev 2...
    ((Smalltalk at: #'mocks_hg_p2_n2') class compiledMethodAt: #version_HG) 
        annotateWith: (HGRevisionAnnotation revision: (repo @ 2) id).



    pmP2   := HGPackageWorkingCopy named: 'mocks:hg/p2'.
    pmP2N1 := HGPackageWorkingCopy named: 'mocks:hg/p2/n1'.
    pmP2N2 := HGPackageWorkingCopy named: 'mocks:hg/p2/n2'.
    self assert: pmP2 revision = pmP2N1 revision.
    self assert: pmP2N2 revision = '84a2ca31f8d9' asHGChangesetId.         

    "=== A modifies & commits =============================== "
    ((Smalltalk at: #MocksHgP2Foo) compile:'zork ^ 2' classified:'test') package: (Smalltalk at: #MocksHgP2Foo) package.

    ctP2 := pmP2 commitTask.
    ctP2 message:'test_commit_nested_01a 1'.
    ctP2 do.

    self assert: pmP2 revision = pmP2N1 revision.
    self assert: pmP2N2 revision = '84a2ca31f8d9' asHGChangesetId.          

    "
    repo workingCopy browse
    "

    "Created: / 18-02-2014 / 21:10:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-03-2014 / 21:46:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_nested_04b
    "
    Nested packages
      mocks:hg/p2      @ 3
      mocks:hg/p2/n1   @ 3
      mocks:hg/p2/n2   @ 2

    1) load all of them
    2) modify & commit n1
    3) check that n1 has same logical revision as p1
       but NOT n2
    "

    | repo pmP2 pmP2N1 pmP2N2 ctP2N1 |

    repo := self repositoryNamed: 'mocks/hg/p2'.
    self assert: (Smalltalk loadPackage:'mocks:hg/p2').
    self assert: (Smalltalk loadPackage:'mocks:hg/p2/n1').
    self assert: (Smalltalk loadPackage:'mocks:hg/p2/n2').

    "/ Force n2 to think it comes from rev 2...
    ((Smalltalk at: #'mocks_hg_p2_n2') class compiledMethodAt: #version_HG) 
        annotateWith: (HGRevisionAnnotation revision: (repo @ 2) id).



    pmP2   := HGPackageWorkingCopy named: 'mocks:hg/p2'.
    pmP2N1 := HGPackageWorkingCopy named: 'mocks:hg/p2/n1'.
    pmP2N2 := HGPackageWorkingCopy named: 'mocks:hg/p2/n2'.
    self assert: pmP2 revision = pmP2N1 revision.
    self assert: pmP2N2 revision ='84a2ca31f8d9' asHGChangesetId.     

    "=== A modifies & commits =============================== "
    ((Smalltalk at: #MocksHgP2Foo) compile:'zork ^ 2' classified:'test') package: (Smalltalk at: #MocksHgP2Foo) package.

    ctP2N1 := pmP2N1 commitTask.
    ctP2N1 message:'test_commit_nested_04b 1'.
    ctP2N1 do.

    self assert: pmP2 revision = pmP2N1 revision.
    self assert: pmP2N2 revision = '84a2ca31f8d9' asHGChangesetId.          

    "
    repo workingCopy browse
    "

    "Created: / 18-02-2014 / 21:11:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-03-2014 / 21:46:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_nested_04c
    "
    Nested packages
      mocks:hg/p2      @ 3
      mocks:hg/p2/n1   @ 3
      mocks:hg/p2/n2   @ 2

    1) load all of them
    2) modify & commit n2
    3) check that n1 has same logical revision as p1
       but NOT n2
    "

    | repo pmP2 pmP2N1 pmP2N2 ctP2N2 |

    repo := self repositoryNamed: 'mocks/hg/p2'.
    self assert: (Smalltalk loadPackage:'mocks:hg/p2').
    self assert: (Smalltalk loadPackage:'mocks:hg/p2/n1').
    self assert: (Smalltalk loadPackage:'mocks:hg/p2/n2').

    "/ Force n2 to think it comes from rev 2...
    ((Smalltalk at: #'mocks_hg_p2_n2') class compiledMethodAt: #version_HG) 
        annotateWith: (HGRevisionAnnotation revision: (repo @ 2) id).



    pmP2   := HGPackageWorkingCopy named: 'mocks:hg/p2'.
    pmP2N1 := HGPackageWorkingCopy named: 'mocks:hg/p2/n1'.
    pmP2N2 := HGPackageWorkingCopy named: 'mocks:hg/p2/n2'.
    self assert: pmP2 revision = pmP2N1 revision.
    self assert: pmP2N2 revision = '84a2ca31f8d9' asHGChangesetId.  

    "=== A modifies & commits =============================== "
    ((Smalltalk at: #MocksHgP2Foo) compile:'zork ^ 2' classified:'test') package: (Smalltalk at: #MocksHgP2Foo) package.

    ctP2N2 := pmP2N2 commitTask.
    ctP2N2 message:'test_commit_nested_04c 1'.
    ctP2N2 do.

    self assert: pmP2 revision = pmP2N1 revision.
    self assert: pmP2 revision = '9e9134b80dfa' asHGChangesetId.  
    self assert: pmP2N2 revision revno == 4.  

    "
    repo workingCopy browse
    "

    "Created: / 18-02-2014 / 21:12:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-03-2014 / 21:46:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_nested_05a
    "
    Nested packages
      mocks:hg/p2/n1   @ 3
      mocks:hg/p2/n2   @ 3

    1) load both of them
    2) modify n1 & commit p2
    3) check that p2 has same logical revision as n1 and n2
       check that no mocks_hg_p2 project definition is created
       and commited (in this situation p2 is a virtual package)
    "

    | repo pmP2 pmP2N1 pmP2N2 ct |

    repo := self repositoryNamed: 'mocks/hg/p2'.
    self assert: (Smalltalk loadPackage:'mocks:hg/p2/n1').
    self assert: (Smalltalk loadPackage:'mocks:hg/p2/n2').

    pmP2   := HGPackageWorkingCopy named: 'mocks:hg/p2'.
    pmP2N1 := HGPackageWorkingCopy named: 'mocks:hg/p2/n1'.
    pmP2N2 := HGPackageWorkingCopy named: 'mocks:hg/p2/n2'.
    self assert: pmP2 isVirtual.
    self assert: pmP2N1 isVirtual not.
    self assert: pmP2N2 isVirtual not.
    self assert: pmP2 revision = pmP2N1 revision.
    self assert: pmP2 revision = pmP2N2 revision.
    "/ Package mocks:hg/p2 is NOT loaded
    self assert: (Smalltalk at:#'mocks_hg_p2') isNil.

    "=== A modifies & commits =============================== "
    ((Smalltalk at: #MocksHgP2N1Foo) compile:'zork ^ 2' classified:'test') package: (Smalltalk at: #MocksHgP2N1Foo) package.

    ct := pmP2 commitTask.
    ct message:'test_commit_nested_05a 1'.
    ct do.

    self assert: pmP2 revision = pmP2N1 revision.
    self assert: pmP2 revision = pmP2N2 revision.

    self assert: pmP2 revision revno == 4.  
    "/ Package mocks:hg/p2 is NOT loaded
    self assert: (Smalltalk at:#'mocks_hg_p2') isNil

    "
    repo workingCopy browse
    "

    "Created: / 26-02-2014 / 22:56:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-03-2014 / 21:46:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_nested_05b
    "
    Nested packages
      mocks:hg/p2/n1   @ 3
      mocks:hg/p2/n2   @ 3

    1) load both of them
    2) modify n1 & commit n1 + n2
    3) check that n1 has same logical revision as n2
       check that no mocks_hg_p2 project definition is created
       and commited (in this situation p2 is a virtual package)
    "

    | repo pmP2N1 pmP2N2 ct |

    repo := self repositoryNamed: 'mocks/hg/p2'.
    self assert: (Smalltalk loadPackage:'mocks:hg/p2/n1').
    self assert: (Smalltalk loadPackage:'mocks:hg/p2/n2').

    pmP2N1 := HGPackageWorkingCopy named: 'mocks:hg/p2/n1'.
    pmP2N2 := HGPackageWorkingCopy named: 'mocks:hg/p2/n2'.

    self assert: pmP2N1 isVirtual not.
    self assert: pmP2N2 isVirtual not.
    self assert: pmP2N1 revision = pmP2N2 revision.



    "=== A modifies & commits =============================== "
    ((Smalltalk at: #MocksHgP2N1Foo) compile:'zork ^ 2' classified:'test') package: (Smalltalk at: #MocksHgP2N1Foo) package.

    ct := (pmP2N1 , pmP2N2) commitTask.
    ct message:'test_commit_nested_05b 1'.
    ct do.

    self assert: pmP2N1 revision = pmP2N2  revision.
    self assert: pmP2N1 revision revno == 4.  
    self assert: (Smalltalk at:#'mocks_hg_p2') isNil

    "
    repo workingCopy browse
    "

    "Created: / 26-02-2014 / 22:56:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-03-2014 / 21:46:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_nested_06a_1
    "
    Nested packages
      mocks:hg/p2
      mocks:hg/p2/n1
      mocks:hg/p2/n2

    1) load all of them
    2) modify MocksHgP2Foo & (selectively) commit MocksHgP2Foo
    3) check that n1 & n2 has same logical revision as p1.
    "

    | repo pmP2 pmP2N1 pmP2N2 ctP2 cs |

    repo := self repositoryNamed: 'mocks/hg/p2'.
    self assert: (Smalltalk loadPackage:'mocks:hg/p2').
    self assert: (Smalltalk loadPackage:'mocks:hg/p2/n1').
    self assert: (Smalltalk loadPackage:'mocks:hg/p2/n2').
    pmP2   := HGPackageWorkingCopy named: 'mocks:hg/p2'.
    pmP2N1 := HGPackageWorkingCopy named: 'mocks:hg/p2/n1'.
    pmP2N2 := HGPackageWorkingCopy named: 'mocks:hg/p2/n2'.
    self assert: pmP2N1 revision = pmP2N2 revision.

    "=== A modifies & commits =============================== "
    ((Smalltalk at: #MocksHgP2Foo) compile:'zork ^ 2' classified:'test') package: (Smalltalk at: #MocksHgP2Foo) package.

    ctP2 := pmP2 commitTask.
    ctP2 classes: (Array with: (Smalltalk at: #MocksHgP2Foo)).
    ctP2 message:'test_commit_nested_06a 1'.
    ctP2 do.

    self assert: pmP2 revision = pmP2N1  revision.
    self assert: pmP2 revision = pmP2N2  revision.

    cs := repo @ 4.
    self assert: cs changes size == 1.
    self assert: cs changes anElement path = 'MocksHgP2Foo.st'.
    


    "
    repo workingCopy browse
    "

    "Created: / 01-05-2014 / 00:07:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_nested_06a_2
    "
    Nested packages
      mocks:hg/p2
      mocks:hg/p2/n1
      mocks:hg/p2/n2

    1) load all of them
    2) modify MocksHgP2Foo & (selectively) commit MocksHgP2Foo
    3) check that n1 & n2 has same logical revision as p1.
    "

    | repo pmP2 pmP2N1 pmP2N2 ctP2 cs |

    repo := self repositoryNamed: 'mocks/hg/p2'.
    self assert: (Smalltalk loadPackage:'mocks:hg/p2').
    self assert: (Smalltalk loadPackage:'mocks:hg/p2/n1').
    self assert: (Smalltalk loadPackage:'mocks:hg/p2/n2').
    pmP2   := HGPackageWorkingCopy named: 'mocks:hg/p2'.
    pmP2N1 := HGPackageWorkingCopy named: 'mocks:hg/p2/n1'.
    pmP2N2 := HGPackageWorkingCopy named: 'mocks:hg/p2/n2'.
    self assert: pmP2N1 revision = pmP2N2 revision.

    "=== A modifies & commits =============================== "
    ((Smalltalk at: #MocksHgP2Foo) compile:'zork ^ 2' classified:'test') package: (Smalltalk at: #MocksHgP2Foo) package.
    ((Smalltalk at: #mocks_hg_p2) compile:'qux ^ 2' classified:'test') package: (Smalltalk at: #mocks_hg_p2) package.

    ctP2 := pmP2 commitTask.
    ctP2 classes: (Array with: (Smalltalk at: #MocksHgP2Foo)).
    ctP2 message:'test_commit_nested_06a 1'.
    ctP2 do.

    self assert: pmP2 revision = pmP2N1  revision.
    self assert: pmP2 revision = pmP2N2  revision.

    cs := repo @ 4.
    self assert: cs changes size == 1.
    self assert: cs changes anElement path = 'MocksHgP2Foo.st'.
    


    "
    repo workingCopy browse
    "

    "Created: / 01-05-2014 / 00:10:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-05-2014 / 10:02:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_nested_06b_1
    "
    Nested packages
      mocks:hg/p2
      mocks:hg/p2/n1
      mocks:hg/p2/n2

    1) load all of them
    2) modify MocksHgP2Foo & (selectively) commit MocksHgP2Foo
    3) check that n1 & n2 has same logical revision as p1.
    "

    | repo pmP2 pmP2N1 pmP2N2 ctP2 cs |

    repo := self repositoryNamed: 'mocks/hg/p2'.
    self assert: (Smalltalk loadPackage:'mocks:hg/p2').
    self assert: (Smalltalk loadPackage:'mocks:hg/p2/n1').
    self assert: (Smalltalk loadPackage:'mocks:hg/p2/n2').
    pmP2   := HGPackageWorkingCopy named: 'mocks:hg/p2'.
    pmP2N1 := HGPackageWorkingCopy named: 'mocks:hg/p2/n1'.
    pmP2N2 := HGPackageWorkingCopy named: 'mocks:hg/p2/n2'.
    self assert: pmP2N1 revision = pmP2N2 revision.

    "=== A modifies & commits =============================== "
    ((Smalltalk at: #MocksHgP2N1Foo) compile:'zork ^ 2' classified:'test') package: (Smalltalk at: #MocksHgP2N1Foo) package.

    ctP2 := pmP2 commitTask.
    ctP2 classes: (Array with: (Smalltalk at: #MocksHgP2N1Foo)).
    ctP2 message:'test_commit_nested_06a 1'.
    ctP2 do.

    self assert: pmP2 revision = pmP2N1  revision.
    self assert: pmP2 revision = pmP2N2  revision.

    cs := repo @ 4.
    self assert: cs changes size == 1.
    self assert: cs changes anElement path = 'n1/MocksHgP2N1Foo.st'.
    


    "
    repo workingCopy browse
    "

    "Created: / 01-05-2014 / 09:21:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_nested_06b_2
    "
    Nested packages
      mocks:hg/p2
      mocks:hg/p2/n1
      mocks:hg/p2/n2

    1) load all of them
    2) modify MocksHgP2Foo & (selectively) commit MocksHgP2Foo
    3) check that n1 & n2 has same logical revision as p1.
    "

    | repo pmP2 pmP2N1 pmP2N2 ctP2 cs |

    repo := self repositoryNamed: 'mocks/hg/p2'.
    self assert: (Smalltalk loadPackage:'mocks:hg/p2').
    self assert: (Smalltalk loadPackage:'mocks:hg/p2/n1').
    self assert: (Smalltalk loadPackage:'mocks:hg/p2/n2').
    pmP2   := HGPackageWorkingCopy named: 'mocks:hg/p2'.
    pmP2N1 := HGPackageWorkingCopy named: 'mocks:hg/p2/n1'.
    pmP2N2 := HGPackageWorkingCopy named: 'mocks:hg/p2/n2'.
    self assert: pmP2N1 revision = pmP2N2 revision.

    "=== A modifies & commits =============================== "
    ((Smalltalk at: #MocksHgP2N1Foo) compile:'zork ^ 2' classified:'test') package: (Smalltalk at: #MocksHgP2N1Foo) package.
    ((Smalltalk at: #mocks_hg_p2) compile:'qux ^ 2' classified:'test') package: (Smalltalk at: #mocks_hg_p2) package.

    ctP2 := pmP2 commitTask.
    ctP2 classes: (Array with: (Smalltalk at: #MocksHgP2N1Foo)).
    ctP2 message:'test_commit_nested_06a 1'.
    ctP2 do.

    self assert: pmP2 revision = pmP2N1  revision.
    self assert: pmP2 revision = pmP2N2  revision.

    cs := repo @ 4.
    self assert: cs changes size == 1.
    self assert: cs changes anElement path = 'n1/MocksHgP2N1Foo.st'.
    


    "
    repo workingCopy browse
    "

    "Created: / 01-05-2014 / 09:21:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_nested_06b_3
    "
    Nested packages
      mocks:hg/p2
      mocks:hg/p2/n1
      mocks:hg/p2/n2

    1) load all of them
    2) modify MocksHgP2Foo & (selectively) commit MocksHgP2Foo
    3) check that n1 & n2 has same logical revision as p1.
    "

    | repo pmP2 pmP2N1 pmP2N2 ctP2 cs |

    repo := self repositoryNamed: 'mocks/hg/p2'.
    self assert: (Smalltalk loadPackage:'mocks:hg/p2').
    self assert: (Smalltalk loadPackage:'mocks:hg/p2/n1').
    self assert: (Smalltalk loadPackage:'mocks:hg/p2/n2').
    pmP2   := HGPackageWorkingCopy named: 'mocks:hg/p2'.
    pmP2N1 := HGPackageWorkingCopy named: 'mocks:hg/p2/n1'.
    pmP2N2 := HGPackageWorkingCopy named: 'mocks:hg/p2/n2'.
    self assert: pmP2N1 revision = pmP2N2 revision.

    "=== A modifies & commits =============================== "
    ((Smalltalk at: #MocksHgP2N1Foo) compile:'zork ^ 2' classified:'test') package: (Smalltalk at: #MocksHgP2N1Foo) package.
    ((Smalltalk at: #mocks_hg_p2_n1) compile:'qux ^ 2' classified:'test') package: (Smalltalk at: #mocks_hg_p2_n1) package.

    ctP2 := pmP2 commitTask.
    ctP2 classes: (Array with: (Smalltalk at: #MocksHgP2N1Foo)).
    ctP2 message:'test_commit_nested_06a 1'.
    ctP2 do.

    self assert: pmP2 revision = pmP2N1  revision.
    self assert: pmP2 revision = pmP2N2  revision.

    cs := repo @ 4.
    self assert: cs changes size == 1.
    self assert: cs changes anElement path = 'n1/MocksHgP2N1Foo.st'.
    


    "
    repo workingCopy browse
    "

    "Created: / 01-05-2014 / 09:22:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_nested_06b_4
    "
    Nested packages
      mocks:hg/p2
      mocks:hg/p2/n1
      mocks:hg/p2/n2

    1) load all of them
    2) modify MocksHgP2Foo & (selectively) commit MocksHgP2Foo
    3) check that n1 & n2 has same logical revision as p1.
    "

    | repo pmP2 pmP2N1 pmP2N2 ctP2 cs |

    repo := self repositoryNamed: 'mocks/hg/p2'.
    self assert: (Smalltalk loadPackage:'mocks:hg/p2').
    self assert: (Smalltalk loadPackage:'mocks:hg/p2/n1').
    self assert: (Smalltalk loadPackage:'mocks:hg/p2/n2').
    pmP2   := HGPackageWorkingCopy named: 'mocks:hg/p2'.
    pmP2N1 := HGPackageWorkingCopy named: 'mocks:hg/p2/n1'.
    pmP2N2 := HGPackageWorkingCopy named: 'mocks:hg/p2/n2'.
    self assert: pmP2N1 revision = pmP2N2 revision.

    "=== A modifies & commits =============================== "
    ((Smalltalk at: #MocksHgP2N1Foo) compile:'zork ^ 2' classified:'test') package: (Smalltalk at: #MocksHgP2N1Foo) package.
    ((Smalltalk at: #MocksHgP2N2Foo) compile:'qux ^ 2' classified:'test') package: (Smalltalk at: #MocksHgP2N2Foo) package.

    ctP2 := pmP2 commitTask.
    ctP2 classes: (Array with: (Smalltalk at: #MocksHgP2N1Foo)).
    ctP2 message:'test_commit_nested_06a 1'.
    ctP2 do.

    self assert: pmP2 revision = pmP2N1  revision.
    self assert: pmP2 revision = pmP2N2  revision.

    cs := repo @ 4.
    self assert: cs changes size == 1.
    self assert: cs changes anElement path = 'n1/MocksHgP2N1Foo.st'.
    


    "
    repo workingCopy browse
    "

    "Created: / 01-05-2014 / 09:23:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_nested_06c_1
    "
    Nested packages
      mocks:hg/p2
      mocks:hg/p2/n1
      mocks:hg/p2/n2

    1) load all of them
    2) modify MocksHgP2Foo & (selectively) commit MocksHgP2Foo
    3) check that n1 & n2 has same logical revision as p1.
    "

    | repo pmP2 pmP2N1 pmP2N2 ctP2 cs |

    repo := self repositoryNamed: 'mocks/hg/p2'.
    self assert: (Smalltalk loadPackage:'mocks:hg/p2').
    self assert: (Smalltalk loadPackage:'mocks:hg/p2/n1').
    self assert: (Smalltalk loadPackage:'mocks:hg/p2/n2').
    pmP2   := HGPackageWorkingCopy named: 'mocks:hg/p2'.
    pmP2N1 := HGPackageWorkingCopy named: 'mocks:hg/p2/n1'.
    pmP2N2 := HGPackageWorkingCopy named: 'mocks:hg/p2/n2'.
    self assert: pmP2N1 revision = pmP2N2 revision.

    "=== A modifies & commits =============================== "
    ((Smalltalk at: #MocksHgP2N1Foo) compile:'zork ^ 2' classified:'test') package: (Smalltalk at: #MocksHgP2N1Foo) package.
    ((Smalltalk at: #MocksHgP2N2Foo) compile:'qux ^ 2' classified:'test') package: (Smalltalk at: #MocksHgP2N2Foo) package.

    ctP2 := pmP2 commitTask.
    ctP2 classes: (Array with: (Smalltalk at: #MocksHgP2N1Foo) with: (Smalltalk at: #MocksHgP2N2Foo)).
    ctP2 message:'test_commit_nested_06a 1'.
    ctP2 do.

    self assert: pmP2 revision = pmP2N1  revision.
    self assert: pmP2 revision = pmP2N2  revision.

    cs := repo @ 4.
    self assert: cs changes size == 2.
    self assert: (cs changes contains: [:e| e path = 'n1/MocksHgP2N1Foo.st' ]).
    self assert: (cs changes contains: [:e| e path = 'n2/MocksHgP2N2Foo.st' ]).
    


    "
    repo workingCopy browse
    "

    "Created: / 01-05-2014 / 09:25:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_nested_06c_2
    "
    Nested packages
      mocks:hg/p2
      mocks:hg/p2/n1
      mocks:hg/p2/n2

    1) load all of them
    2) modify MocksHgP2N1Foo, MocksHgP2N1Foo & (selectively) commit MocksHgP2N1Foo and MocksHgP2N1Foo
    3) check that n1 & n2 has same logical revision as p1.
    "

    | repo pmP2 pmP2N1 pmP2N2 ctP2 cs |

    repo := self repositoryNamed: 'mocks/hg/p2'.
    self assert: (Smalltalk loadPackage:'mocks:hg/p2').
    self assert: (Smalltalk loadPackage:'mocks:hg/p2/n1').
    self assert: (Smalltalk loadPackage:'mocks:hg/p2/n2').
    pmP2   := HGPackageWorkingCopy named: 'mocks:hg/p2'.
    pmP2N1 := HGPackageWorkingCopy named: 'mocks:hg/p2/n1'.
    pmP2N2 := HGPackageWorkingCopy named: 'mocks:hg/p2/n2'.
    self assert: pmP2N1 revision = pmP2N2 revision.

    "=== A modifies & commits =============================== "
    ((Smalltalk at: #MocksHgP2N1Foo) compile:'zork ^ 2' classified:'test') package: (Smalltalk at: #MocksHgP2N1Foo) package.
    ((Smalltalk at: #MocksHgP2N2Foo) compile:'qux ^ 2' classified:'test') package: (Smalltalk at: #MocksHgP2N2Foo) package.

    ctP2 := (pmP2N1 , pmP2N2) commitTask.
    ctP2 classes: (Array with: (Smalltalk at: #MocksHgP2N1Foo) with: (Smalltalk at: #MocksHgP2N2Foo)).
    ctP2 message:'test_commit_nested_06a 1'.
    ctP2 do.

    self assert: pmP2 revision = pmP2N1  revision.
    self assert: pmP2 revision = pmP2N2  revision.

    cs := repo @ 4.
    self assert: cs changes size == 2.
    self assert: (cs changes contains: [:e| e path = 'n1/MocksHgP2N1Foo.st' ]).
    self assert: (cs changes contains: [:e| e path = 'n2/MocksHgP2N2Foo.st' ]).
    


    "
    repo workingCopy browse
    "

    "Created: / 01-05-2014 / 09:25:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_nested_07a
    "
    Nested packages
      mocks:hg/p2
      mocks:hg/p2/n1
      mocks:hg/p2/n2

    1) load all of them
    2) modify & commit p2 & p2/n1, commit both 
    3) check that current ChangeSet has no changes for commited classes
    "

    | repo pmP2 pmP2N1 pmP2N2 ctP2 |

    repo := self repositoryNamed: 'mocks/hg/p2'.
    self assert: (Smalltalk loadPackage:'mocks:hg/p2').
    self assert: (Smalltalk loadPackage:'mocks:hg/p2/n1').
    self assert: (Smalltalk loadPackage:'mocks:hg/p2/n2').
    pmP2   := HGPackageWorkingCopy named: 'mocks:hg/p2'.
    pmP2N1 := HGPackageWorkingCopy named: 'mocks:hg/p2/n1'.
    pmP2N2 := HGPackageWorkingCopy named: 'mocks:hg/p2/n2'.

    "=== A modifies & commits =============================== "
    ((Smalltalk at: #MocksHgP2Foo) compile:'zork ^ 2' classified:'test') package: (Smalltalk at: #MocksHgP2Foo) package.
    ((Smalltalk at: #Object) compile:'bark ^ 2' classified:'test') package: (Smalltalk at: #MocksHgP2N1Foo) package.

    self assert: (ChangeSet current includesChangeForClass: (Smalltalk at:#MocksHgP2Foo)).     
    self assert: (ChangeSet current includesChangeForClass: (Smalltalk at:#Object) selector: #bark).     

    ctP2 := pmP2 commitTask.
    ctP2 message:'test_commit_nested_07a 1'.
    ctP2 paths:{
        (ctP2 temporaryWorkingCopy path / 'MocksHgP2Foo.st') pathName.
        (ctP2 temporaryWorkingCopy path / 'n1' / 'extensions.st') pathName.
    }.
    ctP2 do.

    self assert: (ChangeSet current includesChangeForClass: (Smalltalk at:#MocksHgP2Foo)) not.     
    self assert: (ChangeSet current includesChangeForClass: (Smalltalk at:#MocksHgP2N1Foo)) not.     
    "
    repo workingCopy browse
    "

    "Created: / 16-11-2014 / 07:24:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-11-2014 / 08:45:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_nested_07b
    "
    Nested packages
      mocks:hg/p2
      mocks:hg/p2/n1
      mocks:hg/p2/n2

    1) load all of them
    2) modify & commit p2 & p2/n1, commit only p1
    3) check that current ChangeSet has no changes for commited classes
    "

    | repo pmP2 pmP2N1 pmP2N2 ctP2 |

    repo := self repositoryNamed: 'mocks/hg/p2'.
    self assert: (Smalltalk loadPackage:'mocks:hg/p2').
    self assert: (Smalltalk loadPackage:'mocks:hg/p2/n1').
    self assert: (Smalltalk loadPackage:'mocks:hg/p2/n2').
    pmP2   := HGPackageWorkingCopy named: 'mocks:hg/p2'.
    pmP2N1 := HGPackageWorkingCopy named: 'mocks:hg/p2/n1'.
    pmP2N2 := HGPackageWorkingCopy named: 'mocks:hg/p2/n2'.

    "=== A modifies & commits =============================== "
    ((Smalltalk at: #MocksHgP2Foo) compile:'zork ^ 2' classified:'test') package: (Smalltalk at: #MocksHgP2Foo) package.
    ((Smalltalk at: #MocksHgP2N1Foo) compile:'bark ^ 2' classified:'test') package: (Smalltalk at: #MocksHgP2N1Foo) package.

    self assert: (ChangeSet current includesChangeForClass: (Smalltalk at:#MocksHgP2Foo)).     
    self assert: (ChangeSet current includesChangeForClass: (Smalltalk at:#MocksHgP2N1Foo)).     

    ctP2 := pmP2 commitTask.
    ctP2 message:'test_commit_nested_07a 1'.
    ctP2 paths:{
        (ctP2 temporaryWorkingCopy path / 'MocksHgP2Foo.st') pathName.
    }.
    ctP2 do.

    self assert: (ChangeSet current includesChangeForClass: (Smalltalk at:#MocksHgP2Foo)) not.     
    self assert: (ChangeSet current includesChangeForClass: (Smalltalk at:#MocksHgP2N1Foo)).     
    "
    repo workingCopy browse
    "

    "Created: / 16-11-2014 / 08:42:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_nested_07c
    "
    Nested packages
      mocks:hg/p2
      mocks:hg/p2/n1
      mocks:hg/p2/n2

    1) load all of them
    2) modify & commit p2 & p2/n1, commit only n1 
    3) check that current ChangeSet has no changes for commited classes
    "

    | repo pmP2 pmP2N1 pmP2N2 ctP2 |

    repo := self repositoryNamed: 'mocks/hg/p2'.
    self assert: (Smalltalk loadPackage:'mocks:hg/p2').
    self assert: (Smalltalk loadPackage:'mocks:hg/p2/n1').
    self assert: (Smalltalk loadPackage:'mocks:hg/p2/n2').
    pmP2   := HGPackageWorkingCopy named: 'mocks:hg/p2'.
    pmP2N1 := HGPackageWorkingCopy named: 'mocks:hg/p2/n1'.
    pmP2N2 := HGPackageWorkingCopy named: 'mocks:hg/p2/n2'.

    "=== A modifies & commits =============================== "
    ((Smalltalk at: #MocksHgP2Foo) compile:'zork ^ 2' classified:'test') package: (Smalltalk at: #MocksHgP2Foo) package.
    ((Smalltalk at: #MocksHgP2N1Foo) compile:'bark ^ 2' classified:'test') package: (Smalltalk at: #MocksHgP2N1Foo) package.

    self assert: (ChangeSet current includesChangeForClass: (Smalltalk at:#MocksHgP2Foo)).     
    self assert: (ChangeSet current includesChangeForClass: (Smalltalk at:#MocksHgP2N1Foo)).     

    ctP2 := pmP2 commitTask.
    ctP2 message:'test_commit_nested_07a 1'.
    ctP2 paths:{
        (ctP2 temporaryWorkingCopy path / 'n1' / 'MocksHgP2N1Foo.st') pathName.
    }.
    ctP2 do.

    self assert: (ChangeSet current includesChangeForClass: (Smalltalk at:#MocksHgP2Foo)).     
    self assert: (ChangeSet current includesChangeForClass: (Smalltalk at:#MocksHgP2N1Foo)) not.     
    "
    repo workingCopy browse
    "

    "Created: / 16-11-2014 / 08:43:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_nested_07d
    "
    Nested packages
      mocks:hg/p2
      mocks:hg/p2/n1
      mocks:hg/p2/n2

    1) load all of them
    2) modify & commit p2 & p2/n1, none
    3) check that current ChangeSet has no changes for commited classes
    "

    | repo pmP2 pmP2N1 pmP2N2 ctP2 |

    repo := self repositoryNamed: 'mocks/hg/p2'.
    self assert: (Smalltalk loadPackage:'mocks:hg/p2').
    self assert: (Smalltalk loadPackage:'mocks:hg/p2/n1').
    self assert: (Smalltalk loadPackage:'mocks:hg/p2/n2').
    pmP2   := HGPackageWorkingCopy named: 'mocks:hg/p2'.
    pmP2N1 := HGPackageWorkingCopy named: 'mocks:hg/p2/n1'.
    pmP2N2 := HGPackageWorkingCopy named: 'mocks:hg/p2/n2'.

    "=== A modifies & commits =============================== "
    ((Smalltalk at: #MocksHgP2Foo) compile:'zork ^ 2' classified:'test') package: (Smalltalk at: #MocksHgP2Foo) package.
    ((Smalltalk at: #MocksHgP2N1Foo) compile:'bark ^ 2' classified:'test') package: (Smalltalk at: #MocksHgP2N1Foo) package.

    self assert: (ChangeSet current includesChangeForClass: (Smalltalk at:#MocksHgP2Foo)).     
    self assert: (ChangeSet current includesChangeForClass: (Smalltalk at:#MocksHgP2N1Foo)).     

    ctP2 := pmP2 commitTask.
    ctP2 message:'test_commit_nested_07a 1'.
    ctP2 paths:{
    }.
    ctP2 do.

    self assert: (ChangeSet current includesChangeForClass: (Smalltalk at:#MocksHgP2Foo)).     
    self assert: (ChangeSet current includesChangeForClass: (Smalltalk at:#MocksHgP2N1Foo)).     
    "
    repo workingCopy browse
    "

    "Created: / 16-11-2014 / 08:44:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_nested_07e
    "
    Nested packages
      mocks:hg/p2
      mocks:hg/p2/n1
      mocks:hg/p2/n2

    1) load all of them
    2) modify & commit p2 & p2/n1, commit both 
    3) check that current ChangeSet has no changes for commited classes
    "

    | repo pmP2 pmP2N1 pmP2N2 ctP2 |

    repo := self repositoryNamed: 'mocks/hg/p2'.
    self assert: (Smalltalk loadPackage:'mocks:hg/p2').
    self assert: (Smalltalk loadPackage:'mocks:hg/p2/n1').
    self assert: (Smalltalk loadPackage:'mocks:hg/p2/n2').
    pmP2   := HGPackageWorkingCopy named: 'mocks:hg/p2'.
    pmP2N1 := HGPackageWorkingCopy named: 'mocks:hg/p2/n1'.
    pmP2N2 := HGPackageWorkingCopy named: 'mocks:hg/p2/n2'.

    "=== A modifies & commits =============================== "
    ((Smalltalk at: #MocksHgP2Foo) compile:'zork ^ 2' classified:'test') package: (Smalltalk at: #MocksHgP2Foo) package.
    ((Smalltalk at: #Object) compile:'bark ^ 2' classified:'test') package: (Smalltalk at: #MocksHgP2N1Foo) package.

    self assert: (ChangeSet current includesChangeForClass: (Smalltalk at:#MocksHgP2Foo)).     
    self assert: (ChangeSet current includesChangeForClass: (Smalltalk at:#Object) selector: #bark).     

    ctP2 := pmP2 commitTask.
    ctP2 message:'test_commit_nested_07a 1'.
    ctP2 paths:{
        (ctP2 temporaryWorkingCopy path / 'MocksHgP2Foo.st') pathName.
        (ctP2 temporaryWorkingCopy path / 'n1' / 'extensions.st') pathName.
    }.
    ctP2 do.

    self assert: (ChangeSet current includesChangeForClass: (Smalltalk at:#MocksHgP2Foo)) not.     
    self assert: (ChangeSet current includesChangeForClass: (Smalltalk at:#Object) selector: #bark) not.     
    "
    repo workingCopy browse
    "

    "Created: / 16-11-2014 / 08:45:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_nested_07f
    "
    Nested packages
      mocks:hg/p2
      mocks:hg/p2/n1
      mocks:hg/p2/n2

    1) load all of them
    2) modify & commit p2 & p2/n1, commit both 
    3) check that current ChangeSet has no changes for commited classes
    "

    | repo pmP2 pmP2N1 pmP2N2 ctP2 |

    repo := self repositoryNamed: 'mocks/hg/p2'.
    self assert: (Smalltalk loadPackage:'mocks:hg/p2').
    self assert: (Smalltalk loadPackage:'mocks:hg/p2/n1').
    self assert: (Smalltalk loadPackage:'mocks:hg/p2/n2').
    pmP2   := HGPackageWorkingCopy named: 'mocks:hg/p2'.
    pmP2N1 := HGPackageWorkingCopy named: 'mocks:hg/p2/n1'.
    pmP2N2 := HGPackageWorkingCopy named: 'mocks:hg/p2/n2'.

    "=== A modifies & commits =============================== "
    ((Smalltalk at: #MocksHgP2Foo) compile:'zork ^ 2' classified:'test') package: (Smalltalk at: #MocksHgP2Foo) package.
    ((Smalltalk at: #Object) compile:'bark ^ 2' classified:'test') package: (Smalltalk at: #MocksHgP2N1Foo) package.

    self assert: (ChangeSet current includesChangeForClass: (Smalltalk at:#MocksHgP2Foo)).     
    self assert: (ChangeSet current includesChangeForClass: (Smalltalk at:#Object) selector: #bark).     

    ctP2 := pmP2 commitTask.
    ctP2 message:'test_commit_nested_07a 1'.
    ctP2 paths:{
        (ctP2 temporaryWorkingCopy path / 'MocksHgP2Foo.st') pathName.
    }.
    ctP2 do.

    self assert: (ChangeSet current includesChangeForClass: (Smalltalk at:#MocksHgP2Foo)) not.     
    self assert: (ChangeSet current includesChangeForClass: (Smalltalk at:#Object) selector: #bark).     
    "
    repo workingCopy browse
    "

    "Created: / 16-11-2014 / 08:46:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_nested_08a
    "
    Nested packages
      mocks:hg/p2
      mocks:hg/p2/n1
      mocks:hg/p2/n2

    1) load hg/p2, hg/p2/n1
    2) commit hg/p2/n1
    3) check that no .hgignore has been created in n1
    "

    | repo pmP2 pmP2N1 ctP2N1 |

    repo := self repositoryNamed: 'mocks/hg/p2'.
    self assert: (Smalltalk loadPackage:'mocks:hg/p2').
    self assert: (Smalltalk loadPackage:'mocks:hg/p2/n1').
    pmP2   := HGPackageWorkingCopy named: 'mocks:hg/p2'.
    pmP2N1 := HGPackageWorkingCopy named: 'mocks:hg/p2/n1'.

    ctP2N1 := pmP2N1 commitTask.
    ctP2N1 message:'test_commit_nested_08a 1'.
    ctP2N1 do.

    self should: [ (repo @ 4) / 'n1' / '.hgignore' ] raise: HGError.  

    "
    repo workingCopy browse
    "

    "Created: / 20-01-2015 / 19:48:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_nested_08b
    "
    Nested packages
      mocks:hg/p2
      mocks:hg/p2/n1
      mocks:hg/p2/n2

    1) load hg/p2/n1
    2) commit hg/p2 (which is virtual now)
    3) check that .hgignore has been created in p2
    "

    | repo pmP2 ctP2 |

    repo := self repositoryNamed: 'mocks/hg/p2'.

    self assert: (Smalltalk loadPackage:'mocks:hg/p2/n1').

    pmP2 := HGPackageWorkingCopy named: 'mocks:hg/p2'.

    ctP2 := pmP2 commitTask.
    ctP2 message:'test_commit_nested_08a 1'.
    ctP2 do.

    self should:   [ (repo @ 4) / 'n1' / '.hgignore' ] raise: HGError.
    self shouldnt: [ (repo @ 4) / '.hgignore' ] raise: HGError.  

    "
    repo workingCopy browse
    "

    "Created: / 20-01-2015 / 19:54:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGStXTests methodsFor:'tests - copyright updater'!

test_copyright_line_01
    | line |

    line := HGCopyrightLine readFrom: ' COPYRIGHT (c) 1994 by Claus Gittinger'.
    self 
        assert: line prefix = ' COPYRIGHT (c)';
        assert: line years = (1994 to: 1994);
        assert: line holder = 'by Claus Gittinger';
        assert: line asString = ' COPYRIGHT (c) 1994 by Claus Gittinger'.


    line := HGCopyrightLine readFrom: '              All Rights Reserved' onError: [ 1 ].
    self 
        assert: line == 1.

    line := HGCopyrightLine readFrom: ' COPYRIGHT (c) 1994-1998 by Claus Gittinger'.
    self 
        assert: line prefix = ' COPYRIGHT (c)';
        assert: line years = (1994 to: 1998);
        assert: line holder = 'by Claus Gittinger';
        assert: line asString = ' COPYRIGHT (c) 1994-1998 by Claus Gittinger'.

    line := HGCopyrightLine readFrom: ' COPYRIGHT (c) 2005-now Jan Vrany'.
    self 
        assert: line prefix = ' COPYRIGHT (c)';
        assert: line years = (2005 to: 'now');
        assert: line holder = 'Jan Vrany';
        assert: line asString = ' COPYRIGHT (c) 2005-now Jan Vrany'.

    line := HGCopyrightLine readFrom: ' COPYRIGHT (c) Claus Gittinger / eXept Software AG'.
    self 
        assert: line prefix = ' COPYRIGHT (c)';
        assert: line years isNil;
        assert: line holder = 'Claus Gittinger / eXept Software AG';
        assert: line asString = ' COPYRIGHT (c) Claus Gittinger / eXept Software AG'.

    "Created: / 14-05-2018 / 16:18:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-06-2018 / 08:38:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_copyright_line_02
    | lines |

    lines := #( ' COPYRIGHT (c) 1994-1997 BB'        
                ' COPYRIGHT (c) 1995-1997 DD'
                ' COPYRIGHT (c) 1995-1997 CC'
                ' COPYRIGHT (c) 1994 AA'
                ) collect:[:l | HGCopyrightLine readFrom: l ].
    lines sort.
    self assert: lines first holder = 'AA'.
    self assert: lines second holder = 'BB'.
    self assert: lines third holder = 'CC'.
    self assert: lines fourth holder = 'DD'.

    "Created: / 14-05-2018 / 16:54:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-06-2018 / 08:38:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGStXTests methodsFor:'tests - manager API'!

test_log_01

    | log repo |


    repo := self repositoryNamed: 'mocks/hg/p1'.
    self assert: (Smalltalk loadPackage:'mocks:hg/p1').

    log := HGSourceCodeManager
                revisionLogOf:MockHGP1Bar
                fromRevision:0 toRevision:0
                numberOfRevisions:nil
                fileName:'MockHGP1Bar.st'
                directory: 'hg/p1'
                module:'mocks'.

    self assert: (log at: #container) = 'MockHGP1Bar.st'.
    self assert: (log at: #cvsRoot) = repo pathName.
    self assert: (log at: #newestRevision) = '1:847b035d9aed'.
    self assert: (log at: #revisions) size == 1.

    "Created: / 04-12-2012 / 01:07:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_log_02

    | log repo |


    repo := self repositoryNamed: 'mocks/hg/p1'.
    self assert: (Smalltalk loadPackage:'mocks:hg/p1').

    log := HGSourceCodeManager
                revisionLogOf:MockHGP1Bar
                fromRevision:nil toRevision:nil
                numberOfRevisions:nil
                fileName:'MockHGP1Bar.st'
                directory: 'hg/p1'
                module:'mocks'.

    self assert: (log at: #container) = 'MockHGP1Bar.st'.
    self assert: (log at: #cvsRoot) = repo pathName.
    self assert: (log at: #newestRevision) = '1:847b035d9aed'.
    self assert: (log at: #revisions) size == 2.
    self assert: ((log at: #revisions) first  at:#revision) = '1:847b035d9aed'.
    self assert: ((log at: #revisions) second at:#revision) = '0:99acfa83a3bf'.

    "Created: / 04-12-2012 / 01:26:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_log_03

    | log repo |


    repo := self repositoryNamed: 'mocks/hg/p1'.
    self assert: (Smalltalk loadPackage:'mocks:hg/p1').

    log := HGSourceCodeManager
                revisionLogOf:MockHGP1Bar
                fromRevision:nil toRevision:nil
                numberOfRevisions:1
                fileName:'MockHGP1Bar.st'
                directory: 'hg/p1'
                module:'mocks'.

    self assert: (log at: #container) = 'MockHGP1Bar.st'.
    self assert: (log at: #cvsRoot) = repo pathName.
    self assert: (log at: #newestRevision) = '1:847b035d9aed'.
    self assert: (log at: #revisions) size == 1.
    self assert: ((log at: #revisions) first  at:#revision) = '1:847b035d9aed'.

    "Created: / 04-12-2012 / 01:31:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_log_04a

    | log repo |


    repo := self repositoryNamed: 'mocks/hg/p1'.
    self assert: (Smalltalk loadPackage:'mocks:hg/p1').

    log := HGSourceCodeManager
                revisionLogOf:MockHGP1Bar
                fromRevision:'1:847b035d9aed' toRevision:nil
                numberOfRevisions:nil
                fileName:'MockHGP1Bar.st'
                directory: 'hg/p1'
                module:'mocks'.

    self assert: (log at: #container) = 'MockHGP1Bar.st'.
    self assert: (log at: #cvsRoot) = repo pathName.
    self assert: (log at: #newestRevision) = '1:847b035d9aed'.
    self assert: (log at: #revisions) size == 2.
    self assert: ((log at: #revisions) first  at:#revision) = '1:847b035d9aed'.
    self assert: ((log at: #revisions) second at:#revision) = '0:99acfa83a3bf'.

    "Created: / 04-12-2012 / 01:32:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_log_04b

    | log repo |


    repo := self repositoryNamed: 'mocks/hg/p1'.
    self assert: (Smalltalk loadPackage:'mocks:hg/p1').

    log := HGSourceCodeManager
                revisionLogOf:MockHGP1Bar
                fromRevision:'1:847b035d9aed' toRevision:'0:99acfa83a3bf'
                numberOfRevisions:nil
                fileName:'MockHGP1Bar.st'
                directory: 'hg/p1'
                module:'mocks'.

    self assert: (log at: #container) = 'MockHGP1Bar.st'.
    self assert: (log at: #cvsRoot) = repo pathName.
    self assert: (log at: #newestRevision) = '1:847b035d9aed'.
    self assert: (log at: #revisions) size == 2.
    self assert: ((log at: #revisions) first  at:#revision) = '1:847b035d9aed'.
    self assert: ((log at: #revisions) second at:#revision) = '0:99acfa83a3bf'.

    "Created: / 04-12-2012 / 01:32:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_log_04c

    | log repo |


    repo := self repositoryNamed: 'mocks/hg/p1'.
    self assert: (Smalltalk loadPackage:'mocks:hg/p1').

    log := HGSourceCodeManager
                revisionLogOf:MockHGP1Bar
                fromRevision:nil toRevision:'0:99acfa83a3bf'
                numberOfRevisions:nil
                fileName:'MockHGP1Bar.st'
                directory: 'hg/p1'
                module:'mocks'.

    self assert: (log at: #container) = 'MockHGP1Bar.st'.
    self assert: (log at: #cvsRoot) = repo pathName.
    self assert: (log at: #newestRevision) = '1:847b035d9aed'.
    self assert: (log at: #revisions) size == 2.
    self assert: ((log at: #revisions) first  at:#revision) = '1:847b035d9aed'.
    self assert: ((log at: #revisions) second at:#revision) = '0:99acfa83a3bf'.

    "Created: / 04-12-2012 / 01:32:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_log_04d

    | log repo |


    repo := self repositoryNamed: 'mocks/hg/p1'.
    self assert: (Smalltalk loadPackage:'mocks:hg/p1').

    log := HGSourceCodeManager
                revisionLogOf:MockHGP1Bar
                fromRevision:'0:99acfa83a3bf' toRevision:'0:99acfa83a3bf'
                numberOfRevisions:nil
                fileName:'MockHGP1Bar.st'
                directory: 'hg/p1'
                module:'mocks'.

    self assert: (log at: #container) = 'MockHGP1Bar.st'.
    self assert: (log at: #cvsRoot) = repo pathName.
    self assert: (log at: #newestRevision) = '1:847b035d9aed'.
    self assert: (log at: #revisions) size == 1.
    self assert: ((log at: #revisions) first at:#revision) = '0:99acfa83a3bf'.

    "Created: / 04-12-2012 / 01:33:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_log_05a

    | log repo |


    repo := self repositoryNamed: 'mocks/hg/p6' revision: '0'.
    self assert: (Smalltalk loadPackage:'mocks:hg/p6').
    self assert: (Smalltalk at: #MocksHGP6Bar) revisionInfo changesetId = '0:c76faa501252' asHGChangesetId.

    log := HGSourceCodeManager
                revisionLogOf:(Smalltalk at: #MocksHGP6Bar)
                fromRevision:'0:c76faa501252' toRevision:'0:c76faa501252'
                numberOfRevisions:nil
                fileName:'MocksHGP6Bar.st'
                directory: 'hg/p6'
                module:'mocks'.

    self assert: (log at: #container) = 'MocksHGP6Bar.st'.
    self assert: (log at: #cvsRoot) = repo pathName.
    self assert: (log at: #newestRevision) = '4:f71dfc6c6f9b'.
    self assert: (log at: #revisions) size == 1.
    self assert: ((log at: #revisions) first at:#revision) = '0:c76faa501252'.

    "Created: / 11-02-2014 / 11:31:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-02-2014 / 12:58:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_log_05b
    "
    Test revision log of removed item.
    "

    | log repo |

    repo := self repositoryNamed: 'mocks/hg/p6' revision: '0'.
    self assert: (Smalltalk loadPackage:'mocks:hg/p6').
    self assert: (Smalltalk at: #MocksHGP6Foo) revisionInfo changesetId = '0:c76faa501252' asHGChangesetId.

    log := HGSourceCodeManager
                revisionLogOf:(Smalltalk at: #MocksHGP6Foo)
                fromRevision:'0:c76faa501252' toRevision:'0:c76faa501252'
                numberOfRevisions:nil
                fileName:'MocksHGP6Foo.st'
                directory: 'hg/p6'
                module:'mocks'.

    self assert: (log at: #container) = 'MocksHGP6Foo.st'.
    self assert: (log at: #cvsRoot) = repo pathName.
    self assert: (log at: #newestRevision) = '0:c76faa501252'.
    self assert: (log at: #revisions) size == 1.
    self assert: ((log at: #revisions) first at:#revision) = '0:c76faa501252'.

    "Created: / 11-02-2014 / 11:34:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-02-2014 / 13:55:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_newestRevisionOf_01
    | rev |

    self repositoryNamed: 'mocks/hg/p6' revision: 4.
    self assert: (Smalltalk loadPackage:'mocks:hg/p6').

    rev := HGSourceCodeManager newestRevisionOf: (Smalltalk at: #MocksHGP6Bar).

    self assert: rev = '4:f71dfc6c6f9b'.

    "Created: / 24-04-2016 / 11:41:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_newestRevisionOf_02
    | rev |

    self repositoryNamed: 'mocks/hg/p6' revision: 1.
    self assert: (Smalltalk loadPackage:'mocks:hg/p6').

    rev := HGSourceCodeManager newestRevisionOf: (Smalltalk at: #MocksHGP6Bar).

    self assert: rev = '4:f71dfc6c6f9b'.

    "Created: / 24-04-2016 / 11:46:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_newestRevisionOf_03a
    | rev |

    self repositoryNamed: 'mocks/hg/p6' revision: 2.
    self assert: (Smalltalk loadPackage:'mocks:hg/p6').

    rev := HGSourceCodeManager newestRevisionOf: (Smalltalk at: #MocksHGP6Foo).

    self assert: rev = '2:581b3cabbf8f'.

    "Created: / 24-04-2016 / 11:47:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_newestRevisionOf_03b
    | repo rev |

    repo := self repositoryNamed: 'mocks/hg/p6' revision: 4.
    "
    repo workingCopy browse
    "
    self assert: (Smalltalk loadPackage:'mocks:hg/p6').

    (Object subclass:#MocksHGP6Foo instanceVariableNames:'' classVariableNames:'' poolDictionaries:'')
        package: 'mocks:hg/p6'.
    rev := HGSourceCodeManager newestRevisionOf: (Smalltalk at: #MocksHGP6Foo).

    self assert: rev = '4:f71dfc6c6f9b'.

    "Created: / 24-04-2016 / 11:48:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_newestRevisionOf_03c
    | rev |

    self repositoryNamed: 'mocks/hg/p6' revision: 4.
    self assert: (Smalltalk loadPackage:'mocks:hg/p6').

    (Object subclass:#MocksHGP6Blah instanceVariableNames:'' classVariableNames:'' poolDictionaries:'')
        package: 'mocks:hg/p6'.
    rev := HGSourceCodeManager newestRevisionOf: (Smalltalk at: #MocksHGP6Blah).

    self assert: rev isNil

    "Created: / 24-04-2016 / 11:56:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_stream_01a

    | stream repo contents |


    repo := self repositoryNamed: 'mocks/hg/p1'.
    self assert: (Smalltalk loadPackage:'mocks:hg/p1').

    stream := HGSourceCodeManager
                streamForClass:MockHGP1Bar
                fileName:'MockHGP1Bar.st'
                revision: '0:99acfa83a3bf'
                directory: 'hg/p1'
                module:'mocks'
                cache: false.
    contents := stream contents.

    self assert: contents first = '"{ Package: ''mocks/hg/p1'' }"'

    "Created: / 04-12-2012 / 02:04:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_stream_01b

    | stream repo contents |


    repo := self repositoryNamed: 'mocks/hg/p1'.
    self assert: (Smalltalk loadPackage:'mocks:hg/p1').

    stream := HGSourceCodeManager
                streamForClass:MockHGP1Bar
                fileName:'MockHGP1Bar.st'
                revision: '1:847b035d9aed'
                directory: 'hg/p1'
                module:'mocks'
                cache: false.
    contents := stream contents.

    self assert: contents first = '"{ Package: ''mocks:hg/p1'' }"'

    "Created: / 04-12-2012 / 02:05:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_stream_01c

    | stream repo contents |

    repo := self repositoryNamed: 'mocks/hg/p1'.
    self assert: (Smalltalk loadPackage:'mocks:hg/p1').

    stream := HGSourceCodeManager
                streamForClass:MockHGP1Bar
                fileName:'MockHGP1Bar.st'
                revision: #newest
                directory: 'hg/p1'
                module:'mocks'
                cache: false.
    contents := stream contents.

    self assert: contents first = '"{ Package: ''mocks:hg/p1'' }"'

    "Created: / 09-07-2013 / 15:26:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_stream_02a

    | stream repo contents |


    repo := self repositoryNamed: 'mocks/hg/p1'.
    self assert: (Smalltalk loadPackage:'mocks:hg/p1').

    stream := HGSourceCodeManager
                streamForClass:MockHGP1Bar
                fileName:'MockHGP1Bar.st'
                revision: '0:99acfa83a3bf'
                directory: 'hg/p1'
                module:'mocks'
                cache: true.

    contents := stream contents.

    self assert: contents first = '"{ Package: ''mocks/hg/p1'' }"'.
    self assert: stream isFileStream.

    stream := HGSourceCodeManager
                streamForClass:MockHGP1Bar
                fileName:'MockHGP1Bar.st'
                revision: '0:99acfa83a3bf'
                directory: 'hg/p1'
                module:'mocks'
                cache: true.

    contents := stream contents.

    self assert: contents first = '"{ Package: ''mocks/hg/p1'' }"'.
    self assert: stream isFileStream.

    "Created: / 04-12-2012 / 02:08:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-12-2012 / 10:12:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_stream_02b

    | stream repo contents |


    repo := self repositoryNamed: 'mocks/hg/p1'.
    self assert: (Smalltalk loadPackage:'mocks:hg/p1').

    stream := HGSourceCodeManager
                streamForClass:MockHGP1Bar
                fileName:'MockHGP1Bar.st'
                revision: '1:847b035d9aed'
                directory: 'hg/p1'
                module:'mocks'
                cache: true.
    [
        contents := stream contents.
    ] ensure: [
        stream close
    ].

    self assert: contents first = '"{ Package: ''mocks:hg/p1'' }"'

    "Created: / 04-12-2012 / 10:11:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_stream_02c

    | stream repo |


    repo := self repositoryNamed: 'mocks/hg/p1'.
    (repo pathName asFilename / '.hg' ) recursiveRemove.
    self assert: (Smalltalk loadPackage:'mocks:hg/p1').

    stream := HGSourceCodeManager
                streamForClass:MockHGP1Bar
                fileName:'MockHGP1Bar.st'
                revision: '0:99acfa83a3bf'
                directory: 'hg/p1'
                module:'mocks'
                cache: true.

    self assert: stream isNil.

    "Created: / 27-03-2013 / 11:11:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_stream_03a

    | stream repo contents |


    repo := self repositoryNamed: 'mocks/hg/p1'.
    self assert: (Smalltalk loadPackage:'mocks:hg/p1').
    (Smalltalk at:#MockHGP1Bar) setBinaryRevision: '$Changeset: 847b035d9aed2f8aa50f0214488febc771c8eac8 $ SCM=HG'.

    stream := HGSourceCodeManager getSourceStreamFor:(Smalltalk at:#MockHGP1Bar).
    [
        contents := stream contents.
    ] ensure: [
        stream close
    ].

    self assert: contents first = '"{ Package: ''mocks:hg/p1'' }"'

    "Created: / 18-03-2013 / 16:58:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_stream_04a
    "
        Tests of extension stream
    "

    | stream repo contents |


    repo := self repositoryNamed: 'mocks/hg/p4'.
    self assert: (Smalltalk loadPackage:'mocks:hg/p4').
    stream := HGSourceCodeManager streamForExtensionFile:'extensions.st' package: 'mocks:hg/p4' directory: 'hg/p4' module: 'mocks' cache: false.

    [
        contents := stream contents.
    ] ensure: [
        stream close
    ].

    self assert: contents first = '"{ Package: ''mocks:hg/p4'' }"!!'

    "Created: / 27-03-2013 / 11:37:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_stream_04b
    "
        Tests of extension stream
    "

    | stream repo contents |

    Class tryLocalSourceFirst:false.
    repo := self repositoryNamed: 'mocks/hg/p4'.
    self assert: (Smalltalk loadPackage:'mocks:hg/p4').
    stream := HGSourceCodeManager streamForExtensionFile:'extensions.st' package: 'mocks:hg/p4' directory: 'hg/p4' module: 'mocks' cache: false.

    [
        contents := stream contents.
    ] ensure: [
        stream close
    ].

    self assert: contents first = '"{ Package: ''mocks:hg/p4'' }"!!'

    "Created: / 08-07-2013 / 02:20:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGStXTests methodsFor:'tests - misc'!

test_misc_Class_revisionOfManager_01a
    | repo cls |

    repo := self repositoryNamed: 'mocks/hg/p1'.
    Smalltalk loadPackage:'mocks:hg/p1/'.

    cls := Smalltalk at: #MockHGP1Bar.
    self assert: (cls revisionOfManager: HGSourceCodeManager) asHGChangesetId = repo workingCopy changesetId.

    "Created: / 23-05-2014 / 12:15:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_misc_Class_revisionOfManager_01b
    | repo cls |

    repo := self repositoryNamed: 'mocks/hg/p1'.
    Smalltalk loadPackage:'mocks:hg/p1/'.

    cls := Object subclass:#MockHGP1Qux
        instanceVariableNames:''
        classVariableNames:''
        poolDictionaries:''
        category:'* Mocks *'.
    cls setPackage: #'mocks:hg/p1'.
    self assert: (cls revisionOfManager: HGSourceCodeManager) isNil

    "Created: / 23-05-2014 / 13:13:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_misc_Class_revisionOfManager_01c
    | repo cls |

    repo := self repositoryNamed: 'mocks/hg/p1'.
    Smalltalk loadPackage:'mocks:hg/p1/'.

    cls := Object subclass:#MockHGP1N1Qux
        instanceVariableNames:''
        classVariableNames:''
        poolDictionaries:''
        category:'* Mocks *'.
    cls setPackage: #'mocks:hg/p1/n1'.
    self assert: (cls revisionOfManager: HGSourceCodeManager) isNil

    "Created: / 23-05-2014 / 12:20:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_misc_fileReleaseAndRevisionNr
    "
    ProjectDefinition>>fileReleaseNr and ProjectDefinition>>fileRevisionNr
    are used to generate package.rc used on Windows.

    String returned must be an integer and must be a valid short value
    - otherwise, BCC won't compile/link the library.

    If this test fail it means that implementation fileReleaseNr/fileRevisionNr
    is rubbish. As of 2012-11-23, it uses 'self revision' and expects
    (but does not check!!) the resulting string is in X.Y form. In mercurial,
    #revision returns node id (SHA1 hash string).

    It has to be fixed there!!
    "

    | repo |

    repo := self repositoryNamed: 'mocks/hg/p1'.
    Smalltalk loadPackage:'mocks:hg/p1'.

    self assert: ((Smalltalk at:#'mocks_hg_p1') fileReleaseNr allSatisfy:[:c|c isDigit]).
    self assert: ((Smalltalk at:#'mocks_hg_p1') fileReleaseNr asInteger <= 16r7FFF).

    self assert: ((Smalltalk at:#'mocks_hg_p1') fileRevisionNr allSatisfy:[:c|c isDigit]).
    self assert: ((Smalltalk at:#'mocks_hg_p1') fileRevisionNr asInteger <= 16r7FFF).

    "Created: / 23-11-2012 / 11:02:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_misc_hgRevision_01
    | repo |

    repo := self repositoryNamed: 'mocks/hg/p1'.
    Smalltalk loadPackage:'mocks:hg/p1'.
    self dumpRepositoryLog: repo.

    self assert: (Smalltalk at:#'mocks_hg_p1') hgLogicalRevision  = (HGChangesetId fromString: '1:847b035d9aed').

    "Created: / 23-11-2012 / 11:00:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-05-2013 / 13:18:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_misc_packagegroup_01a
    | repo pmP2 pmP2N1 pmP2N2 pg|

    repo := self repositoryNamed: 'mocks/hg/p2'.
    Smalltalk loadPackage:'mocks:hg/p2'.
    Smalltalk loadPackage:'mocks:hg/p2/n1'.
    Smalltalk loadPackage:'mocks:hg/p2/n2'.
    pmP2 := HGPackageWorkingCopy named: 'mocks:hg/p2'.
    pmP2N1 := HGPackageWorkingCopy named: 'mocks:hg/p2/n1'.
    pmP2N2 := HGPackageWorkingCopy named: 'mocks:hg/p2/n2'.

    pg := SCMCommonPackageModelGroup with: pmP2.

    self assert: (pg includes: pmP2).
    self assert: (pg includes: pmP2N1).
    self assert: (pg includes: pmP2N2).

    "Created: / 03-03-2014 / 09:00:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-03-2014 / 21:46:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_misc_packagegroup_01b
    | repo pmP2 pmP2N1 pmP2N2 pg|

    repo := self repositoryNamed: 'mocks/hg/p2'.
    Smalltalk loadPackage:'mocks:hg/p2'.
    Smalltalk loadPackage:'mocks:hg/p2/n1'.
    Smalltalk loadPackage:'mocks:hg/p2/n2'.
    pmP2 := HGPackageWorkingCopy named: 'mocks:hg/p2'.
    pmP2N1 := HGPackageWorkingCopy named: 'mocks:hg/p2/n1'.
    pmP2N2 := HGPackageWorkingCopy named: 'mocks:hg/p2/n2'.

    pg := SCMCommonPackageModelGroup with: pmP2N1.

    self assert: (pg includes: pmP2) not.
    self assert: (pg includes: pmP2N1).
    self assert: (pg includes: pmP2N2) not.

    "Created: / 03-03-2014 / 09:02:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-03-2014 / 21:46:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_misc_packagegroup_02a
    | repo pmP2 pmP2N1 pmP2N2 pg|

    repo := self repositoryNamed: 'mocks/hg/p2'.
    Smalltalk loadPackage:'mocks:hg/p2'.
    Smalltalk loadPackage:'mocks:hg/p2/n1'.
    Smalltalk loadPackage:'mocks:hg/p2/n2'.
    pmP2 := HGPackageWorkingCopy named: 'mocks:hg/p2'.
    pmP2N1 := HGPackageWorkingCopy named: 'mocks:hg/p2/n1'.
    pmP2N2 := HGPackageWorkingCopy named: 'mocks:hg/p2/n2'.

    pg := SCMCommonPackageModelGroup with: pmP2N1.
    pg add: pmP2N2.

    self assert: (pg includes: pmP2) not.
    self assert: (pg includes: pmP2N1).
    self assert: (pg includes: pmP2N2).

    "Created: / 03-03-2014 / 09:03:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-03-2014 / 21:46:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_misc_packagegroup_02b
    | repo pmP2 pmP2N1 pmP2N2 pg|

    repo := self repositoryNamed: 'mocks/hg/p2'.
    Smalltalk loadPackage:'mocks:hg/p2'.
    Smalltalk loadPackage:'mocks:hg/p2/n1'.
    Smalltalk loadPackage:'mocks:hg/p2/n2'.
    pmP2 := HGPackageWorkingCopy named: 'mocks:hg/p2'.
    pmP2N1 := HGPackageWorkingCopy named: 'mocks:hg/p2/n1'.
    pmP2N2 := HGPackageWorkingCopy named: 'mocks:hg/p2/n2'.

    pg := SCMCommonPackageModelGroup with: pmP2N1.
    pg add: pmP2.

    self assert: (pg includes: pmP2).
    self assert: (pg includes: pmP2N1).
    self assert: (pg includes: pmP2N2).

    "Created: / 03-03-2014 / 09:03:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-03-2014 / 21:46:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_misc_packagemodel_01
    | repo pm |

    repo := self repositoryNamed: 'mocks/hg/p1'.
    Smalltalk loadPackage:'mocks:hg/p1'.
    pm := HGPackageWorkingCopy named: 'mocks:hg/p1'.
    self assert: pm parent == nil.

    "Created: / 03-12-2012 / 15:45:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-03-2014 / 21:45:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_misc_packagemodel_02
    | repo pmP2 pmP2N1|

    repo := self repositoryNamed: 'mocks/hg/p2'.
    Smalltalk loadPackage:'mocks:hg/p2'.
    pmP2 := HGPackageWorkingCopy named: 'mocks:hg/p2'.
    pmP2N1 := HGPackageWorkingCopy named: 'mocks:hg/p2/n1'.

    self assert: pmP2 parent isNil.
    self assert: pmP2N1 parent == pmP2.
    self assert: (pmP2 construct:'n1') == pmP2N1

    "Created: / 03-12-2012 / 15:46:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-03-2014 / 21:45:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_misc_packagemodel_03
    | repo pmP2N1 pmP2N2|

    repo := self repositoryNamed: 'mocks/hg/p2'.
    Smalltalk loadPackage:'mocks:hg/p2'.
    pmP2N1 := HGPackageWorkingCopy named: 'mocks:hg/p2/n1'.
    pmP2N2 := HGPackageWorkingCopy named: 'mocks:hg/p2/n2'.

    self assert: pmP2N1 parent == pmP2N2 parent.

    "Created: / 03-12-2012 / 15:48:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-03-2014 / 21:45:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_misc_packagemodel_03b
    | repo pmP2N1 pmP2N2|

    repo := self repositoryNamed: 'mocks/hg/p2'.
    Smalltalk loadPackage:'mocks:hg/p2/n1'.
    Smalltalk loadPackage:'mocks:hg/p2/n2'.
    pmP2N1 := HGPackageWorkingCopy named: 'mocks:hg/p2/n1'.
    pmP2N2 := HGPackageWorkingCopy named: 'mocks:hg/p2/n2'.

    self assert: pmP2N1 parent == pmP2N2 parent.
    self assert: pmP2N1 repository == pmP2N2 repository.

    "Created: / 03-12-2012 / 15:48:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-03-2014 / 21:45:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGStXTests methodsFor:'tests - package revisions'!

test_packagerev_01
    | repo rev |

    repo := self repositoryNamed: 'mocks/hg/p6'.
    rev := (repo @ 1) rootPackage.

    self assert: rev name = 'mocks:hg/p6'.
    self assert: rev parent isNil.
    self assert: rev children isEmpty.
    self assert: rev isVirtual not.

    "Created: / 06-03-2014 / 22:00:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-03-2014 / 10:06:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_packagerev_02
    | repo p2rev p2n1rev p2n2rev |

    repo := self repositoryNamed: 'mocks/hg/p2'.
    p2rev := (repo @ 3) rootPackage.

    self assert: p2rev name = 'mocks:hg/p2'.
    self assert: p2rev parent isNil.
    self assert: p2rev children size == 2.
    self assert: p2rev isVirtual not.

    p2n1rev := p2rev children detect:[:e | e name = 'mocks:hg/p2/n1' ] ifNone:[ nil ].
    p2n2rev := p2rev children detect:[:e | e name = 'mocks:hg/p2/n2' ] ifNone:[ nil ].

    self assert: p2n1rev notNil.
    self assert: p2n2rev notNil.

    self assert: p2n1rev parent == p2rev. 
    self assert: p2n1rev children isEmpty.
    self assert: p2n1rev isVirtual not.

    self assert: p2n1rev siblings size == 1.
    self assert: p2n1rev siblings anElement == p2n2rev.

    self assert: p2n2rev parent == p2rev. 
    self assert: p2n2rev children size == 1.
    self assert: p2n2rev children anElement name = 'mocks:hg/p2/n2/n2_1'.
    self assert: p2n2rev siblings size == 1.
    self assert: p2n2rev siblings anElement == p2n1rev.
    self assert: p2n2rev isVirtual not.

    "Created: / 07-03-2014 / 09:53:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-03-2014 / 10:07:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_packagerev_03a
    | repo p7rev p7n1rev p7n2rev |

    repo := self repositoryNamed: 'mocks/hg/p7'.
    p7rev := (repo @ 0) rootPackage.

    self assert: p7rev name = 'mocks:hg/p7'.
    self assert: p7rev parent isNil.
    self assert: p7rev children size == 2.
    self assert: p7rev isVirtual.

    p7n1rev := p7rev children detect:[:e | e name = 'mocks:hg/p7/n1' ] ifNone:[ nil ].
    p7n2rev := p7rev children detect:[:e | e name = 'mocks:hg/p7/n2' ] ifNone:[ nil ].

    self assert: p7n1rev notNil.
    self assert: p7n1rev isVirtual not.
    self assert: p7n2rev notNil.
    self assert: p7n2rev isVirtual not.

    "Created: / 08-03-2014 / 10:09:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_packagerev_03b
    | repo p7rev p7n1rev p7n2rev p7n3rev p7n3n1rev p7n3n2rev |

    repo := self repositoryNamed: 'mocks/hg/p7'.
    p7rev := (repo @ 1) rootPackage.

    self assert: p7rev name = 'mocks:hg/p7'.
    self assert: p7rev parent isNil.
    self assert: p7rev children size == 3.
    self assert: p7rev isVirtual.

    p7n1rev := p7rev children detect:[:e | e name = 'mocks:hg/p7/n1' ] ifNone:[ nil ].
    p7n2rev := p7rev children detect:[:e | e name = 'mocks:hg/p7/n2' ] ifNone:[ nil ].
    p7n3rev := p7rev children detect:[:e | e name = 'mocks:hg/p7/n3' ] ifNone:[ nil ].

    self assert: p7n1rev notNil.
    self assert: p7n1rev isVirtual not.
    self assert: p7n2rev notNil.
    self assert: p7n2rev isVirtual not.
    self assert: p7n3rev notNil.
    self assert: p7n3rev isVirtual.

    p7n3n1rev := p7n3rev children detect:[:e | e name = 'mocks:hg/p7/n3/n1' ] ifNone:[ nil ].
    p7n3n2rev := p7n3rev children detect:[:e | e name = 'mocks:hg/p7/n3/n2' ] ifNone:[ nil ].
    self assert: p7n3n1rev notNil.
    self assert: p7n3n1rev isVirtual not.
    self assert: p7n3n2rev notNil.
    self assert: p7n3n2rev isVirtual not.

    "Created: / 08-03-2014 / 10:11:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_packagerev_changeset_01
    | repo p6rev p6cs |

    repo := self repositoryNamed: 'mocks/hg/p6'.
    p6rev := (repo @ 1) rootPackage.
    p6cs  := p6rev changeSet.

    self assert: p6cs size == 21.

    "01"self assert: (p6cs contains:[:c | c isClassDefinitionChange and:[ c className = 'MocksHGP6Bar' ] ] ).
    "02"self assert: (p6cs contains:[:c | c isMethodCodeChange and:[ c className = 'MocksHGP6Bar' and:[ c selector == #bar ] ] ]).
    "03"self assert: (p6cs contains:[:c | c isMethodCodeChange and:[ c className = 'MocksHGP6Bar' and:[ c selector == #name ] ] ]).
    "04"self assert: (p6cs contains:[:c | c isMethodCodeChange and:[ c className = 'MocksHGP6Bar class' and:[ c selector == #version_HG ] ] ]).

    "05"self assert: (p6cs contains:[:c | c isClassDefinitionChange and:[ c className = 'MocksHGP6Foo' ] ] ).
    "06"self assert: (p6cs contains:[:c | c isMethodCodeChange and:[ c className = 'MocksHGP6Foo' and:[ c selector == #foo1 ] ] ]).
    "07"self assert: (p6cs contains:[:c | c isMethodCodeChange and:[ c className = 'MocksHGP6Foo' and:[ c selector == #foo2 ] ] ]).
    "08"self assert: (p6cs contains:[:c | c isMethodCodeChange and:[ c className = 'MocksHGP6Foo' and:[ c selector == #foo3 ] ] ]).
    "09"self assert: (p6cs contains:[:c | c isMethodCodeChange and:[ c className = 'MocksHGP6Foo class' and:[ c selector == #version_HG ] ] ]).

    "10"self assert: (p6cs contains:[:c | c isClassDefinitionChange and:[ c className = 'mocks_hg_p6' ] ] ).
    "11"self assert: (p6cs contains:[:c | c isMethodCodeChange and:[ c className = 'mocks_hg_p6 class' and:[ c selector == #excludedFromPreRequisites ] ] ]).
    "12"self assert: (p6cs contains:[:c | c isMethodCodeChange and:[ c className = 'mocks_hg_p6 class' and:[ c selector == #mandatoryPreRequisites ] ] ]).
    "13"self assert: (p6cs contains:[:c | c isMethodCodeChange and:[ c className = 'mocks_hg_p6 class' and:[ c selector == #referencedPreRequisites ] ] ]).
    "14"self assert: (p6cs contains:[:c | c isMethodCodeChange and:[ c className = 'mocks_hg_p6 class' and:[ c selector == #subProjects ] ] ]).
    "15"self assert: (p6cs contains:[:c | c isMethodCodeChange and:[ c className = 'mocks_hg_p6 class' and:[ c selector == #classNamesAndAttributes ] ] ]).
    "16"self assert: (p6cs contains:[:c | c isMethodCodeChange and:[ c className = 'mocks_hg_p6 class' and:[ c selector == #extensionMethodNames ] ] ]).
    "17"self assert: (p6cs contains:[:c | c isMethodCodeChange and:[ c className = 'mocks_hg_p6 class' and:[ c selector == #description ] ] ]).
    "18"self assert: (p6cs contains:[:c | c isMethodCodeChange and:[ c className = 'mocks_hg_p6 class' and:[ c selector == #legalCopyright ] ] ]).
    "19"self assert: (p6cs contains:[:c | c isMethodCodeChange and:[ c className = 'mocks_hg_p6 class' and:[ c selector == #productName ] ] ]).
    "20"self assert: (p6cs contains:[:c | c isMethodCodeChange and:[ c className = 'mocks_hg_p6 class' and:[ c selector == #version_HG ] ] ]).
    "21"self assert: (p6cs contains:[:c | c isMethodCodeChange and:[ c className = 'mocks_hg_p6 class' and:[ c selector == #companyName ] ] ]).

    "Created: / 13-03-2014 / 22:35:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-03-2014 / 21:04:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_packagerev_changeset_02
    | repo p6rev p6cs |

    repo := self repositoryNamed: 'mocks/hg/p6'.
    p6rev := (repo @ 5) rootPackage.
    p6cs  := p6rev changeSet.

    self assert: (p6cs contains:[:c | c isMethodCodeChange and:[ c className = 'Object' and:[ c selector == #greet ] ] ]).

    "Created: / 14-03-2014 / 21:19:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_packagerev_changeset_03
    | repo p6hgcs p6rev p6cs |

    repo := self repositoryNamed: 'mocks/hg/p6'.
    p6hgcs := repo @ 1.
    "/ Simulate missing abbrev.stc...  
    p6hgcs root children removeKey: 'abbrev.stc'.

    p6rev := p6hgcs rootPackage.
    p6cs  := p6rev changeSet.

    self assert: p6cs size == 21.

    "01"self assert: (p6cs contains:[:c | c isClassDefinitionChange and:[ c className = 'MocksHGP6Bar' ] ] ).
    "02"self assert: (p6cs contains:[:c | c isMethodCodeChange and:[ c className = 'MocksHGP6Bar' and:[ c selector == #bar ] ] ]).
    "03"self assert: (p6cs contains:[:c | c isMethodCodeChange and:[ c className = 'MocksHGP6Bar' and:[ c selector == #name ] ] ]).
    "04"self assert: (p6cs contains:[:c | c isMethodCodeChange and:[ c className = 'MocksHGP6Bar class' and:[ c selector == #version_HG ] ] ]).

    "05"self assert: (p6cs contains:[:c | c isClassDefinitionChange and:[ c className = 'MocksHGP6Foo' ] ] ).
    "06"self assert: (p6cs contains:[:c | c isMethodCodeChange and:[ c className = 'MocksHGP6Foo' and:[ c selector == #foo1 ] ] ]).
    "07"self assert: (p6cs contains:[:c | c isMethodCodeChange and:[ c className = 'MocksHGP6Foo' and:[ c selector == #foo2 ] ] ]).
    "08"self assert: (p6cs contains:[:c | c isMethodCodeChange and:[ c className = 'MocksHGP6Foo' and:[ c selector == #foo3 ] ] ]).
    "09"self assert: (p6cs contains:[:c | c isMethodCodeChange and:[ c className = 'MocksHGP6Foo class' and:[ c selector == #version_HG ] ] ]).

    "10"self assert: (p6cs contains:[:c | c isClassDefinitionChange and:[ c className = 'mocks_hg_p6' ] ] ).
    "11"self assert: (p6cs contains:[:c | c isMethodCodeChange and:[ c className = 'mocks_hg_p6 class' and:[ c selector == #excludedFromPreRequisites ] ] ]).
    "12"self assert: (p6cs contains:[:c | c isMethodCodeChange and:[ c className = 'mocks_hg_p6 class' and:[ c selector == #mandatoryPreRequisites ] ] ]).
    "13"self assert: (p6cs contains:[:c | c isMethodCodeChange and:[ c className = 'mocks_hg_p6 class' and:[ c selector == #referencedPreRequisites ] ] ]).
    "14"self assert: (p6cs contains:[:c | c isMethodCodeChange and:[ c className = 'mocks_hg_p6 class' and:[ c selector == #subProjects ] ] ]).
    "15"self assert: (p6cs contains:[:c | c isMethodCodeChange and:[ c className = 'mocks_hg_p6 class' and:[ c selector == #classNamesAndAttributes ] ] ]).
    "16"self assert: (p6cs contains:[:c | c isMethodCodeChange and:[ c className = 'mocks_hg_p6 class' and:[ c selector == #extensionMethodNames ] ] ]).
    "17"self assert: (p6cs contains:[:c | c isMethodCodeChange and:[ c className = 'mocks_hg_p6 class' and:[ c selector == #description ] ] ]).
    "18"self assert: (p6cs contains:[:c | c isMethodCodeChange and:[ c className = 'mocks_hg_p6 class' and:[ c selector == #legalCopyright ] ] ]).
    "19"self assert: (p6cs contains:[:c | c isMethodCodeChange and:[ c className = 'mocks_hg_p6 class' and:[ c selector == #productName ] ] ]).
    "20"self assert: (p6cs contains:[:c | c isMethodCodeChange and:[ c className = 'mocks_hg_p6 class' and:[ c selector == #version_HG ] ] ]).
    "21"self assert: (p6cs contains:[:c | c isMethodCodeChange and:[ c className = 'mocks_hg_p6 class' and:[ c selector == #companyName ] ] ]).

    "Created: / 14-03-2014 / 21:46:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_packagerev_changeset_04
    | repo p6hgcs p6rev p6cs warnings |

    repo := self repositoryNamed: 'mocks/hg/p6'.
    p6hgcs := repo @ 1.
    "/ Simulate missing class (listed in classNamesAndAttributes)
    p6hgcs root children removeKey: 'MocksHGP6Bar.st'.

    p6rev := p6hgcs rootPackage.
    warnings := OrderedCollection new.
    [
        p6cs := p6rev changeSet.
    ] on: SCMWarning do:[:ex |
        warnings add: ex.
        ex proceed.
    ].

    self assert: p6cs size == 17.
    self assert: warnings size == 1.

    "05"self assert: (p6cs contains:[:c | c isClassDefinitionChange and:[ c className = 'MocksHGP6Foo' ] ] ).
    "06"self assert: (p6cs contains:[:c | c isMethodCodeChange and:[ c className = 'MocksHGP6Foo' and:[ c selector == #foo1 ] ] ]).
    "07"self assert: (p6cs contains:[:c | c isMethodCodeChange and:[ c className = 'MocksHGP6Foo' and:[ c selector == #foo2 ] ] ]).
    "08"self assert: (p6cs contains:[:c | c isMethodCodeChange and:[ c className = 'MocksHGP6Foo' and:[ c selector == #foo3 ] ] ]).
    "09"self assert: (p6cs contains:[:c | c isMethodCodeChange and:[ c className = 'MocksHGP6Foo class' and:[ c selector == #version_HG ] ] ]).

    "10"self assert: (p6cs contains:[:c | c isClassDefinitionChange and:[ c className = 'mocks_hg_p6' ] ] ).
    "11"self assert: (p6cs contains:[:c | c isMethodCodeChange and:[ c className = 'mocks_hg_p6 class' and:[ c selector == #excludedFromPreRequisites ] ] ]).
    "12"self assert: (p6cs contains:[:c | c isMethodCodeChange and:[ c className = 'mocks_hg_p6 class' and:[ c selector == #mandatoryPreRequisites ] ] ]).
    "13"self assert: (p6cs contains:[:c | c isMethodCodeChange and:[ c className = 'mocks_hg_p6 class' and:[ c selector == #referencedPreRequisites ] ] ]).
    "14"self assert: (p6cs contains:[:c | c isMethodCodeChange and:[ c className = 'mocks_hg_p6 class' and:[ c selector == #subProjects ] ] ]).
    "15"self assert: (p6cs contains:[:c | c isMethodCodeChange and:[ c className = 'mocks_hg_p6 class' and:[ c selector == #classNamesAndAttributes ] ] ]).
    "16"self assert: (p6cs contains:[:c | c isMethodCodeChange and:[ c className = 'mocks_hg_p6 class' and:[ c selector == #extensionMethodNames ] ] ]).
    "17"self assert: (p6cs contains:[:c | c isMethodCodeChange and:[ c className = 'mocks_hg_p6 class' and:[ c selector == #description ] ] ]).
    "18"self assert: (p6cs contains:[:c | c isMethodCodeChange and:[ c className = 'mocks_hg_p6 class' and:[ c selector == #legalCopyright ] ] ]).
    "19"self assert: (p6cs contains:[:c | c isMethodCodeChange and:[ c className = 'mocks_hg_p6 class' and:[ c selector == #productName ] ] ]).
    "20"self assert: (p6cs contains:[:c | c isMethodCodeChange and:[ c className = 'mocks_hg_p6 class' and:[ c selector == #version_HG ] ] ]).
    "21"self assert: (p6cs contains:[:c | c isMethodCodeChange and:[ c className = 'mocks_hg_p6 class' and:[ c selector == #companyName ] ] ]).

    "Created: / 14-03-2014 / 22:39:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_packagerev_changeset_05
    | repo p6hgcs p6rev p6cs warnings |

    repo := self repositoryNamed: 'mocks/hg/p6'.
    p6hgcs := repo @ 5.
    "/ Simulate missing extensions.st
    p6hgcs root children removeKey: 'extensions.st'.

    p6rev := p6hgcs rootPackage.
    warnings := OrderedCollection new.
    [
        p6cs := p6rev changeSet.
    ] on: SCMWarning do:[:ex |
        warnings add: ex.
        ex proceed.
    ].

    self assert: warnings size == 1.

    self deny: (p6cs contains:[:c | c isMethodCodeChange and:[ c className = 'Object' and:[ c selector == #greet ] ] ]).

    "Created: / 14-03-2014 / 22:51:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_packagerev_changeset_06
    | repo p6hgcs p6rev p6cs warnings |

    repo := self repositoryNamed: 'mocks/hg/p6'.
    p6hgcs := repo @ 5.
    "/ Simulate empty extensionMethodNames but non-empty extensions.st
    p6hgcs rootPackage definition extensionMethodNames: nil.  

    p6rev := p6hgcs rootPackage.
    warnings := OrderedCollection new.
    [
        p6cs := p6rev changeSet.
    ] on: SCMWarning do:[:ex |
        warnings add: ex.
        ex proceed.
    ].

    self assert: warnings size == 1.

    self assert: (p6cs contains:[:c | c isMethodCodeChange and:[ c className = 'Object' and:[ c selector == #greet ] ] ]).

    "Created: / 14-03-2014 / 22:53:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGStXTests methodsFor:'utilities'!

cleanup
    "Wipeout all mock package leftovers. Could be used
     to simulate work from another fresh image"

    self tearDown

    "Created: / 20-11-2012 / 19:32:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

stxlibjavaAvailable
    ^ self stxlibjavaAvailableRequireReboot: true.

    "Created: / 29-11-2013 / 16:21:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-08-2014 / 01:39:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

stxlibjavaAvailableRequireReboot: reboot

    (Smalltalk at:#JavaVM) isNil ifTrue:[
        [
            Smalltalk loadPackage:'stx:libjava'.
            Smalltalk loadPackage:'stx:libjava/tools'.
        ] on: PackageLoadError do:[
            ^ false.
        ]
    ].

    ((Smalltalk at:#JavaVM) isNil or:[(Smalltalk at:#Java) isNil]) ifTrue:[
        ^ false
    ].

    ((Smalltalk at:#JavaVM) booted not or:[ reboot ]) ifTrue:[
        ^ [
            "/ Opps, workaround - have to nil out Java:ExtensionsPathPackages
            Smalltalk at: #'Java:ExtensionsPathPackages' put: nil.
            (Smalltalk at:#JavaVM) reboot.
            true.
        ] on:Error do:[:ex | 
            false 
        ]
    ].

    ^ true.

    "Created: / 04-08-2014 / 01:36:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGStXTests class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

