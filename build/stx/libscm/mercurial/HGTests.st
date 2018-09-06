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

HGTestCase subclass:#HGTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Mercurial-Tests'
!

!HGTests class methodsFor:'documentation'!

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
    Tests for core Mercurial code - no Smalltalk/X specific code.
    Commiting, cloning, walking history and so on...

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!HGTests methodsFor:'tests - basic workflow'!

test_basic_01a
    "Test modification of working copy and commit back"

    | repo  wc  f1_txt  oldcs  currentcs |

    repo := self repositoryNamed:'test_repo_01'.
     "
     UserPreferences fileBrowserClass openOn: repo directory.
    "
    wc := repo workingCopy.
    oldcs := wc changeset.
    self assert:oldcs id revno == 4.
     "Modify some file"
    f1_txt := wc / 'f1.txt'.
    self assert:f1_txt isModified not.
    f1_txt writingFileDo:[:s | s nextPutAll:'modified from test_01a'. ].
    self assert:f1_txt isModified.
    wc commit:'test_01a commit 1'.
    currentcs := wc changeset.
    self assert:f1_txt isModified not.
    self assert:currentcs id revno == 5.
    self assert:currentcs parent1 = oldcs.
    self assert:currentcs author = 'test_basic_01a <test_basic_01a@HGTests>'

    "Created: / 19-09-2012 / 23:06:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-11-2012 / 11:42:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGTests methodsFor:'tests - bookmarks'!

test_bookmarks_01a
    "
    Simply set bookmark
    "

    | repo wc|

    repo := self repositoryNamed:'test_repo_01'.
    wc := repo workingCopy.
    self assert: (repo @ 4) bookmarks isEmpty.

    wc bookmarkAs: 'test_bookmarks_01'.

    self assert: (repo @ 4) bookmarks size == 1.
    self assert: (repo @ 4) bookmarks anElement name = 'test_bookmarks_01'.
    self assert: (repo @ 4) bookmarks anElement isActive.

    self assert: wc bookmarks size == 1.
    self assert: wc bookmarks anElement name = 'test_bookmarks_01'.
    self assert: wc bookmarks anElement isActive.

    "Created: / 20-03-2014 / 09:11:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 20-03-2014 / 17:30:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_bookmarks_01b
    "
    Simply set bookmark
    "

    | repo wc |

    repo := self repositoryNamed:'test_repo_01'.
    wc := repo workingCopy.
    self assert: (repo @ 4) bookmarks isEmpty.

    (repo @ 4) bookmarkAs: 'test_bookmarks_01'.

    self assert: (repo @ 4) bookmarks size == 1.
    self assert: (repo @ 4) bookmarks anElement name = 'test_bookmarks_01'.

    (HGCommand hgVersionIsGreaterOrEqualThan: #(2 6)) ifTrue:[ 
        "/ In Mercurial 2.6+, setting breakpoint on specific revision
        "/ does NOT activate it
        self assert: (repo @ 4) bookmarks anElement isActive not.
    ] ifFalse:[ 
        "/ Due to a bug, in Mercurial prior 2.6 bookmark was activated,
        "/ see commit 3f785b38af38d2fca6b8f3db56b8007a84cd73a
        self assert: (repo @ 4) bookmarks anElement isActive.
    ].    

    self assert: wc bookmarks size == 1.
    self assert: wc bookmarks anElement name = 'test_bookmarks_01'.

    (HGCommand hgVersionIsGreaterOrEqualThan: #(2 6)) ifTrue:[ 
        "/ In Mercurial 2.6+, setting breakpoint on specific revision
        "/ does NOT activate it
        self assert: wc bookmarks anElement isActive not.
    ] ifFalse:[ 
        "/ Due to a bug, in Mercurial prior 2.6 bookmark was activated,
        "/ see commit 3f785b38af38d2fca6b8f3db56b8007a84cd73a
        self assert: wc bookmarks anElement isActive.
    ].

    "Created: / 20-03-2014 / 09:11:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-11-2014 / 14:52:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_bookmarks_01c
    "
    Simply set bookmark
    "

    | repo wc|

    repo := self repositoryNamed:'test_repo_01'.
    wc := repo workingCopy.
    self assert: (repo @ 4) bookmarks isEmpty.

    (repo @ 3) bookmarkAs: 'test_bookmarks_01'.

    self assert: (repo @ 3) bookmarks size == 1.
    self assert: (repo @ 3) bookmarks anElement name = 'test_bookmarks_01'.
    self assert: (repo @ 3) bookmarks anElement isActive not.

    self assert: (repo @ 4) bookmarks isEmpty.
    self assert: wc bookmarks isEmpty.

    "Created: / 20-03-2014 / 09:12:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 20-03-2014 / 17:30:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_bookmarks_02
    "
    Set the same bookmark twice
    "

    | repo wc|

    repo := self repositoryNamed:'test_repo_01'.
    wc := repo workingCopy.
    self assert: (repo @ 4) bookmarks isEmpty.

    (repo @ 4) bookmarkAs: 'test_bookmarks_02'.
    self should: [ (repo @ 4) bookmarkAs: 'test_bookmarks_02' ] raise: HGBookmarkError.

    "Created: / 20-03-2014 / 09:21:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_bookmarks_03a
    "
    Set two bookmarks on checked-out changeset, 
    check that last one is active.
    "

    | repo wc|

    repo := self repositoryNamed:'test_repo_01'.
    wc := repo workingCopy.
    self assert: (repo @ 4) bookmarks isEmpty.
    "
     UserPreferences fileBrowserClass openOn: repo pathName asFilename.
    "   
    wc bookmarkAs: 'test_bookmarks_03 A'.
    self assert: (repo @ 4) bookmarks size == 1.
    self assert: (repo @ 4) bookmarks anElement isActive.    

    wc bookmarkAs: 'test_bookmarks_03 B'.

    self assert: (repo @ 4) bookmarks size == 2.
    self assert: ((repo @ 4) bookmarks detect:[:e | e name = 'test_bookmarks_03 A' ]) isActive not.
    self assert: ((repo @ 4) bookmarks detect:[:e | e name = 'test_bookmarks_03 B' ]) isActive.

    "Created: / 20-03-2014 / 09:23:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 20-03-2014 / 18:47:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 20-03-2014 / 22:43:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_bookmarks_03b
    "
    Set two bookmarks on non-checked changeset,
    check none is active.
    "

    | repo wc|

    repo := self repositoryNamed:'test_repo_01'.
    wc := repo workingCopy.
    self assert: (repo @ 3) bookmarks isEmpty.

    (repo @ 3) bookmarkAs: 'test_bookmarks_03 A'.

    self assert: (repo @ 3) bookmarks size == 1.
    self assert: (repo @ 3) bookmarks anElement isActive not.    

    (repo @ 3) bookmarkAs: 'test_bookmarks_03 B'.
    self assert: (repo @ 3) bookmarks size == 2.
    self assert: ((repo @ 3) bookmarks detect:[:e | e name = 'test_bookmarks_03 A' ]) isActive not.
    self assert: ((repo @ 3) bookmarks detect:[:e | e name = 'test_bookmarks_03 B' ]) isActive not.

    "Created: / 20-03-2014 / 09:24:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-03-2014 / 01:05:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_bookmarks_04a
    "
    Simply set & remove bookmark
    "

    | repo cs |

    repo := self repositoryNamed:'test_repo_01'.
    cs := repo @ 4.
    self assert: cs bookmarks isEmpty.

    cs bookmarkAs: 'test_bookmarks_04a'.

    self assert: cs bookmarks size == 1.
    self assert: cs bookmarks anElement name = 'test_bookmarks_04a'.

    (HGCommand hgVersionIsGreaterOrEqualThan: #(2 6)) ifTrue:[ 
        "/ In Mercurial 2.6+, setting breakpoint on specific revision
        "/ does NOT activate it
        self assert: cs bookmarks anElement isActive not.
    ] ifFalse:[ 
        "/ Due to a bug, in Mercurial prior 2.6 bookmark was activated,
        "/ see commit 3f785b38af38d2fca6b8f3db56b8007a84cd73a
        self assert: cs bookmarks anElement isActive.
    ].     


"/    self assert: cs bookmarks anElement isActive not.

    cs bookmarks anElement remove.

    self assert: (repo @ 4) bookmarks isEmpty.

    "Created: / 20-03-2014 / 09:29:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-11-2014 / 14:57:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_bookmarks_04b
    "
    Simply set & remove bookmark
    "

    | repo cs |

    repo := self repositoryNamed:'test_repo_01'.
    cs := repo @ 3.
    self assert: cs bookmarks isEmpty.

    cs bookmarkAs: 'test_bookmarks_04b'.

    self assert: cs bookmarks size == 1.
    self assert: cs bookmarks anElement name = 'test_bookmarks_04b'.
    self assert: cs bookmarks anElement isActive not.

    cs bookmarks anElement remove.

    self assert: cs bookmarks isEmpty.

    "Created: / 20-03-2014 / 09:31:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-03-2014 / 01:06:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_bookmarks_04c
    "
    Simply set two bookmarks & remove one bookmark
    "

    | repo cs wc |

    repo := self repositoryNamed:'test_repo_01'.
    cs := repo @ 4.
    wc := repo workingCopy.
    self assert: cs bookmarks isEmpty.

    wc bookmarkAs: 'test_bookmarks_04b A'.
    wc bookmarkAs: 'test_bookmarks_04b B'.

    self assert: cs bookmarks size == 2.

    (cs bookmarks detect:[:e | e name = 'test_bookmarks_04b A']) remove.

    self assert: cs bookmarks size == 1.
    self assert: cs bookmarks anElement name = 'test_bookmarks_04b B'.
    self assert: cs bookmarks anElement isActive.

    "Created: / 20-03-2014 / 09:32:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-03-2014 / 01:25:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGTests methodsFor:'tests - branches'!

test_branches_01
    "
    Test listing branches
    "

    | repo branches |

    repo := self repositoryNamed:'test_repo_02'.
    branches := repo branches.

    self assert: branches first name = 'default'.
    self assert: branches first isActive.
    self assert: branches first isClosed not.

    self assert: branches second name = 'branch1'.
    self assert: branches second isActive not.
    self assert: branches second isClosed not.

    self assert: branches third name = 'branch2'.
    self assert: branches third isActive.
    self assert: branches third isClosed.

    "Created: / 27-11-2012 / 19:50:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_branches_02
    "
    Test getting current branch (branch of currently checked-out working copy)
    "

    | repo wc branch |

    repo := self repositoryNamed:'test_repo_02'.
    wc := repo workingCopy.
    branch := wc branch.

    self assert: branch name = 'default'.
    self assert: wc changeset branch == branch.

    "Created: / 27-11-2012 / 20:44:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_branches_03
    "
    Test listing branches
    "

    | repo branches |

    repo := self repositoryNamed:'test_repo_02'.
    branches := repo branches.

    self assert: branches first heads size == 1.
    self assert: branches first heads anElement id revno == 5.

    self assert: branches second heads size == 1.
    self assert: branches second heads anElement id revno == 4.

    "Created: / 27-11-2012 / 21:40:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_branches_04
    "
    Change branch & commit. Check whether commited changeset
    has the branch set.
    "

    | repo wc |

    repo := self repositoryNamed:'test_repo_01'.
    wc := repo workingCopy.
    self assert: repo branches size == 1.
    wc branch: 'test_branches_04'.

    "Modify some file"
    (wc / 'f1.txt') writingFileDo:[:s | s nextPutAll:'modified...' ].
    wc commit:'test_branches_04 1'.

    self assert: wc changeset branches size == 1.
    self assert: wc changeset branches anElement name = 'test_branches_04'.
    self assert: repo branches size == 2.

    "Created: / 10-12-2012 / 03:10:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_branches_05
    "
    Freshly created repository should have 'default' branch

    "

    | repo branches |

    repo := self repositoryNamed:'test_repo_empty' unpack: false.
    branches := repo branches.
    self assert: branches size == 1.
    self assert: branches anElement name = 'default'

    "Created: / 14-01-2013 / 14:08:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGTests methodsFor:'tests - changesets'!

test_changeset_01
    "
    Test accessing changesets
    "

    | repo cs |

    repo := self repositoryNamed:'test_repo_01'.

    cs := repo @ 4.
    self assert: cs id printString = '4:6f88e1f44d9e'.

    cs := repo @ '4:6f88e1f44d9eb86e0b56ca15e30e5d786acd83c7'.
    self assert: cs id printString = '4:6f88e1f44d9e'.

    cs := repo @ '4:6f88e1f44d9e'.
    self assert: cs id printString = '4:6f88e1f44d9e'.

    "Created: / 16-11-2012 / 21:03:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 30-11-2012 / 23:34:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_changeset_02
    "
    Tests identity if changesets (cacheing)
    "

    | repo cs1 cs2 |

    repo := self repositoryNamed:'test_repo_01'.

    cs1 := repo @ 4.
    cs2 := repo @ 4.
    self assert: cs1 == cs2.

    cs2 := repo @ '4:6f88e1f44d9eb86e0b56ca15e30e5d786acd83c7'.
    self assert: cs1 == cs2.

    cs2 := repo @ '4:6f88e1f44d9e'.
    self assert: cs1 == cs2.

    "Created: / 16-11-2012 / 22:10:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_changeset_03
    "
    Test walking history though parents
    "

    | repo cs0 cs1 cs2 cs3 |

    repo := self repositoryNamed:'test_repo_01'.

    cs0 := repo @ 0.
    cs1 := repo @ 1.
    cs2 := repo @ 2.
    cs3 := repo @ 3.

    self assert: cs3 parent1 == cs2.
    self assert: cs3 parent2 isNil.
    self assert: cs2 parent1 == cs1.
    self assert: cs2 parent2 isNil.
    self assert: cs1 parent1 == cs0.
    self assert: cs1 parent2 isNil.
    self assert: cs0 parent1 isNil.
    self assert: cs0 parent2 isNil.

    "Created: / 16-11-2012 / 22:14:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_changeset_04
    "
    Test access to changeset contents
    "

    | repo cs |

    repo := self repositoryNamed:'test_repo_01'.

    cs := repo @ 1.

    self assert: cs root children size == 2.
    self assert: (cs root / 'b') children size == 2.
    self assert: (cs root / 'b') parent == cs root.
    self assert: (cs root / 'f1.txt') children size == 0.

    self should: [cs root / 'abraka'] raise: HGError.
    self should: [cs root / 'c' / 'abraka'] raise: HGError.

    "Created: / 16-11-2012 / 22:38:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-11-2012 / 00:23:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_changeset_05
    "
    Test access to changeset contents
    "

    | repo |

    repo := self repositoryNamed:'test_repo_01'.

    self assert: (repo @ 0 / 'f1.txt') contents asString = 'f1-C0
'.

    self assert: (repo @ 1 / 'f1.txt') contents asString = 'f1-C0
f1-C1
'

    "Created: / 17-11-2012 / 00:19:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_changeset_06
    "
    Test access to changeset contents
    "

    | repo cs |

    repo := self repositoryNamed:'test_repo_02'.
    cs := repo @ 5.
    self assert: cs parent1 id revno = 0.
    self assert: cs parent2 id revno = 4.

    "Created: / 27-11-2012 / 20:54:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_changeset_07
    "
    Test accessing changesets
    "

    | repo cs0 cs1 |

    repo := self repositoryNamed:'test_repo_01'.

    cs0 := repo @ 0.
    cs1 := repo @ 1.

    self assert: cs0 children size == 1.
    self assert: (cs0 children includesIdentical: cs1).

    "Created: / 05-12-2012 / 17:41:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_changeset_08a
    "
    Test accessiong commit history using revsets
    "

    | repo csets |

    repo := self repositoryNamed:'test_repo_01'.
    "
    @  changeset:   4:6f88e1f44d9e
    o  changeset:   3:912a64597e4f
    o  changeset:   2:db43a5baa9ac
    o  changeset:   1:98087d77fbaa
    o  changeset:   0:98b9033d3bac
    "
    csets := repo log: '912a64597e4f:98087d77fbaa' limit: nil.
    self assert: csets size = 3.
    self assert: csets first id printString = '3:912a64597e4f'.  
    self assert: csets second id printString = '2:db43a5baa9ac'.
    self assert: csets third id printString = '1:98087d77fbaa'.

    "Created: / 07-02-2014 / 18:30:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-02-2014 / 22:38:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_changeset_08b
    "
    Test accessiong commit history using revsets
    "

    | repo csets |

    repo := self repositoryNamed:'test_repo_01'.
    "
    @  changeset:   4:6f88e1f44d9e
    o  changeset:   3:912a64597e4f
    o  changeset:   2:db43a5baa9ac
    o  changeset:   1:98087d77fbaa
    o  changeset:   0:98b9033d3bac
    "
    csets := repo log: 'p1(912a64597e4f)' limit: nil.
    self assert: csets size = 1.
    self assert: csets first id printString = '2:db43a5baa9ac'.

    "Created: / 08-02-2014 / 22:39:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_changeset_08c
    "
    Test accessiong commit history using revsets
    "

    | repo csets |

    repo := self repositoryNamed:'test_repo_01'.
    "
    @  changeset:   4:6f88e1f44d9e
    o  changeset:   3:912a64597e4f
    o  changeset:   2:db43a5baa9ac
    o  changeset:   1:98087d77fbaa
    o  changeset:   0:98b9033d3bac
    "
    csets := repo log: 'p2(912a64597e4f)' limit: nil.
    self assert: csets isEmpty.

    "Created: / 09-02-2014 / 10:08:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_changeset_08d
    "
    Test accessiong commit history using revsets
    "

    | repo |

    repo := self repositoryNamed:'test_repo_01'.
    "
    @  changeset:   4:6f88e1f44d9e
    o  changeset:   3:912a64597e4f
    o  changeset:   2:db43a5baa9ac
    o  changeset:   1:98087d77fbaa
    o  changeset:   0:98b9033d3bac
    "
    self should: [
        repo log: 'branch(blabla)' limit: nil.
    ] raise: HGUnknownRevisionError.

    "Created: / 09-02-2014 / 10:08:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_changeset_08e
    "
    Test accessiong commit history using revsets
    "

    | repo csets |

    repo := self repositoryNamed:'test_repo_01'.
    "
    @  changeset:   4:6f88e1f44d9e
    o  changeset:   3:912a64597e4f
    o  changeset:   2:db43a5baa9ac
    o  changeset:   1:98087d77fbaa
    o  changeset:   0:98b9033d3bac
    "
    csets := repo log: 'merge()' limit: nil.
    self assert: csets isEmpty.

    "Created: / 09-02-2014 / 10:09:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_changeset_08f
    "
    Test accessiong commit history using revsets
    "

    | repo |

    repo := self repositoryNamed:'test_repo_01'.
    "
    @  changeset:   4:6f88e1f44d9e
    o  changeset:   3:912a64597e4f
    o  changeset:   2:db43a5baa9ac
    o  changeset:   1:98087d77fbaa
    o  changeset:   0:98b9033d3bac
    "
    self should: [
        repo log: 'merge() and' limit: nil
    ] raise: HGError

    "Created: / 09-02-2014 / 10:09:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 09-02-2014 / 19:27:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_changeset_08g
    "
    Test accessiong commit history using revsets
    "

    | repo csets |

    repo := self repositoryNamed:'test_repo_01'.
    "
    @  changeset:   4:6f88e1f44d9e
    o  changeset:   3:912a64597e4f
    o  changeset:   2:db43a5baa9ac
    o  changeset:   1:98087d77fbaa
    o  changeset:   0:98b9033d3bac
    "
    csets := repo log: '912a64597e4f:98087d77fbaa' limit: 2.
    self assert: csets size = 2.
    self assert: csets first id printString = '3:912a64597e4f'.  
    self assert: csets second id printString = '2:db43a5baa9ac'.

    "Created: / 09-02-2014 / 19:27:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_changeset_09
    "
    Tests HGChangeset>>messageDigestUpTo:...
    "

    | repo cs1 cs2 digest |

    repo := self repositoryNamed:'test_repo_01'.
    "
    @  changeset:   4:6f88e1f44d9e
    o  changeset:   3:912a64597e4f
    o  changeset:   2:db43a5baa9ac
    o  changeset:   1:98087d77fbaa
    o  changeset:   0:98b9033d3bac
    "
    cs1 :=  repo @ '98b9033d3bac'.
    cs2 :=  repo @ 'db43a5baa9ac'.

    digest := cs2 messageDigestUpTo: cs1.
    self assert: digest = '### 98b9033d3bac
Commit 0

### 98087d77fbaa
Commit 1

### db43a5baa9ac
Commit 2
'

    "Created: / 03-06-2015 / 07:02:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-09-2015 / 09:52:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_changeset_10
    "
    Test access to non-existent changeset
    "

    | repo |

    repo := self repositoryNamed:'test_repo_01'.

    self should: [ repo @ 100] raise: HGUnknownRevisionError

    "Created: / 27-08-2015 / 19:37:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_changeset_11
    "
    Test access of null-changeset
    "

    | cs |

    cs := HGChangeset null.
    self assert: cs id = HGChangesetId null.
    self assert: cs parent1 == cs.
    self assert: cs parent2 == cs.
    self assert: cs user = ''.
    self assert: cs message = ''.
    self assert: cs summary = ''.
    self assert: cs timestamp = (Timestamp secondsSince1970:0)

    "Created: / 10-06-2016 / 10:22:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_changeset_12
    "
    Test #successors
    "

    | repo cs |

    repo := self repositoryNamed:'test_repo_01'.
    cs := repo @ 1.    
    self assert: cs successors isEmpty.

    "Created: / 22-03-2018 / 22:41:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_csentry_newer_01

    | repo cs csentry newer |

    repo := self repositoryNamed: 'mocks/hg/p6' revision: 1.   
     "
     UserPreferences fileBrowserClass openOn: repo pathName.
    "
    cs := repo @ 1.
    csentry := cs / 'MocksHGP6Bar.st'.
    newer := csentry newer: true.
    self assert: newer size == 2.
    self assert: newer first changesetId = '4:f71dfc6c6f9b' asHGChangesetId.
    self assert: newer second changesetId = '2:581b3cabbf8f' asHGChangesetId.

    "Created: / 24-04-2016 / 12:16:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGTests methodsFor:'tests - commit'!

test_commit_02
    "
                    base    (r4)
        1) modify & commit  (r5)
        2) update wc to r4
        3) modifty & commit (r6)

        check:  i) before 1) only one head r4
                ii) after 3) two heads r5, r6, both with parent r4

    "

    | repo wc heads |

    repo := self repositoryNamed:'test_repo_01'.
    wc := repo workingCopy.
    heads := wc heads.
    self assert: wc changeset id revno == 4.
    self assert: heads size == 1.
    self assert: heads anElement id revno = 4.
    ( wc / 'f1.txt' ) writingFileDo:[:s | s nextPutAll:'modified from test_commit_02 1'. ].
    wc commit:'test_commit_02 commit 1'.

    wc update: 4.

    self assert: wc changeset id revno == 4.
    ( wc / 'f1.txt' ) writingFileDo:[:s | s nextPutAll:'modified from test_commit_02 2'. ].

    wc commit:'test_commit_02 commit 2'.

    heads := wc heads.
    self assert: heads size == 2.
    self assert: heads first parent1 == (repo @ 4).
    self assert: heads second parent1 == (repo @ 4).










     "
     UserPreferences fileBrowserClass openOn: repo directory.
    "

    "Created: / 27-11-2012 / 10:36:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-11-2012 / 21:53:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_03
    "
    Commit without configured author should raise an error
    "

    | repo wc |

    repo := self repositoryNamed:'test_repo_01'.
    wc := repo workingCopy.
    ( wc / 'f1.txt' ) writingFileDo:[:s | s nextPutAll:'modified from test_commit_02 2'. ].

    "Now, fake missing ui.username config entry"
    (repo config root includesKey: #ui) ifTrue:[
        (repo config get:#ui) removeKey: 'username' ifAbsent:[nil].
    ].

    "Try commit"
    HGAuthorQuery answer: nil do:["/See HGtestCase>>performCase
    self should:[wc commit:'test_commit_03 commit 1'] raise: HGCommitError
    ]










     "
     UserPreferences fileBrowserClass openOn: repo directory.
    "

    "Created: / 07-12-2012 / 15:42:52 / jv"
    "Modified: / 18-02-2014 / 12:31:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_04
    "
    Commit with specified date
    "

    | repo wc cs|

    repo := self repositoryNamed:'test_repo_01'.
    wc := repo workingCopy.
    ( wc / 'f1.txt' ) writingFileDo:[:s | s nextPutAll:'modified from test_commit_04 2'. ].

    wc commit: 'test_commit_04 2' date: '0 0'.

    cs := repo @ 5.
    self assert: cs id printString = '5:15e269cc7406'.

    "
     UserPreferences fileBrowserClass openOn: repo directory.
    "

    "Created: / 01-02-2013 / 14:46:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-02-2013 / 10:22:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_05
    "
    Bookmark changeset and commit. Make sure bookmark moved.
    "

    | repo wc|

    repo := self repositoryNamed:'test_repo_01'.
    wc := repo workingCopy.
    self assert: (repo @ 4) bookmarks isEmpty.

    "/ Bookmark currently checked-out working copy.
    wc bookmarkAs: 'test_commit_05'.

    self assert: (repo @ 4) bookmarks size == 1.
    self assert: (repo @ 4) bookmarks anElement name = 'test_commit_05'.
    self assert: (repo @ 4) bookmarks anElement isActive.


    ( wc / 'f1.txt' ) writingFileDo:[:s | s nextPutAll:'modified from test_commit_04 2'. ].
    wc commit: 'test_commit_05 1'.

    "/ Bookmark should move...
    self assert: (repo @ 4) bookmarks isEmpty.
    self assert: (repo @ 5) bookmarks size == 1.
    self assert: (repo @ 5) bookmarks anElement name = 'test_commit_05'.
    self assert: (repo @ 5) bookmarks anElement isActive.



    "
     UserPreferences fileBrowserClass openOn: repo directory.
    "

    "Created: / 20-03-2014 / 08:53:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_06a
    "Test commit with funny characters in commit message.
     This basically tests proper parameter quoting in HG 
     command (issue #5)"

    | repo  wc  f1_txt |

    repo := self repositoryNamed:'test_repo_01'.
     "
     UserPreferences fileBrowserClass openOn: repo directory.
    "
    wc := repo workingCopy.
    self assert:wc changeset id revno == 4.
     "Modify some file"
    f1_txt := wc / 'f1.txt'.
    f1_txt writingFileDo:[:s | s nextPutAll:'modified from test_commit_06'. ].

    wc commit:'A really "funny" message'.
    self assert:wc changeset id revno == 5.
    self assert:wc changeset message = 'A really "funny" message'.

    "Created: / 19-09-2012 / 23:06:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-11-2012 / 11:42:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_06b
    "Test commit with funny characters in commit message.
     This basically tests proper parameter quoting in HG 
     command (issue #5)"

    | repo  wc  f1_txt |

    repo := self repositoryNamed:'test_repo_01'.
     "
     UserPreferences fileBrowserClass openOn: repo directory.
    "
    wc := repo workingCopy.
    self assert:wc changeset id revno == 4.
     "Modify some file"
    f1_txt := wc / 'f1.txt'.
    f1_txt writingFileDo:[:s | s nextPutAll:'modified from test_commit_06'. ].

    wc commit:'A really "very funny" message'.
    self assert:wc changeset id revno == 5.
    self assert:wc changeset message = 'A really "very funny" message'.

    "Created: / 19-09-2012 / 23:06:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-11-2012 / 11:42:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_06c
    "Test commit with funny characters in commit message.
     This basically tests proper parameter quoting in HG 
     command (issue #5)"

    | repo  wc  f1_txt |

    repo := self repositoryNamed:'test_repo_01'.
     "
     UserPreferences fileBrowserClass openOn: repo directory.
    "
    wc := repo workingCopy.
    self assert:wc changeset id revno == 4.
     "Modify some file"
    f1_txt := wc / 'f1.txt'.
    f1_txt writingFileDo:[:s | s nextPutAll:'modified from test_commit_06'. ].

    wc commit:'malicious argument\"&whoami'.
    self assert:wc changeset id revno == 5.
    self assert:wc changeset message = 'malicious argument\"&whoami'.

    "Created: / 19-09-2012 / 23:06:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-11-2012 / 11:42:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_07a
    "Test commit with an emptu commit message.
     This basically tests proper parameter quoting in HG 
     command (issue #5)"

    | repo  wc  f1_txt |

    self skipIf: true description: 'unfinished'.

    repo := self repositoryNamed:'test_repo_01'.
    "
     UserPreferences fileBrowserClass openOn: repo directory.
    "
    wc := repo workingCopy.
    self assert:wc changeset id revno == 4.
     "Modify some file"
    f1_txt := wc / 'f1.txt'.
    f1_txt writingFileDo:[:s | s nextPutAll:'modified from test_commit_06'. ].

    wc commit:''.
    self assert:wc changeset id revno == 5.
    self assert:wc changeset message = ''.

    "Created: / 19-09-2012 / 23:06:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-11-2012 / 11:42:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_08a
    "
    Test amending    
    "

    | repo wc heads tip |

    repo := self repositoryNamed:'test_repo_01'.
    wc := repo workingCopy.
    heads := wc heads.
    self assert: wc changeset id revno == 4.
    self assert: heads size == 1.
    self assert: heads anElement id revno = 4.

    ( wc / 'f1.txt' ) writingFileDo:[:s | s nextPutAll:'modified from test_commit_08a 1'. ].
    wc commit:'test_commit_08a commit 1'.
    self assert: wc changeset id revno == 5 .
    self assert: wc changeset parent1 id revno == 4 .

    ( wc / 'f1.txt' ) writingFileDo:[:s | s nextPutAll:'modified from test_commit_08a 2'. ].

    wc commit:'test_commit_02 commit 2' files: nil author: nil amend: true.

    tip := (repo changesetsMatching:'tip') anElement.     
    self assert: wc changeset id revno == tip id revno .
    self assert: wc changeset parent1 id revno == 4 .


     "
     UserPreferences fileBrowserClass openOn: repo directory.
    "

    "Created: / 25-08-2015 / 16:14:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-01-2018 / 20:59:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_commit_09a
    "
    Test support for obsolete changesets
    "

    | repo wc cs0 cs1 cs2 cs3 |

    repo := self repositoryNamed:'test_repo_01'.
    self skipIf: repo hasExtensionEvolve not description: 'evolve extension is required to test obsolete changesets'.
    wc := repo workingCopy.
    cs0 := wc changeset.
    self assert: cs0 isObsolete not.

    ( wc / 'f1.txt' ) writingFileDo:[:s | s nextPutAll:'modified from ', testSelector, ' 1'. ].
    wc commit:testSelector ,' 1'.
    cs1 := wc changeset.
    self assert: cs0 isObsolete not.
    self assert: cs0 successors isEmpty.
    self assert: cs1 isObsolete not.
    self assert: cs1 successors isEmpty.

    ( wc / 'f1.txt' ) writingFileDo:[:s | s nextPutAll:'modified from ', testSelector, ' 2'. ].
    wc commit:testSelector ,' 2' files: nil author: nil amend: true.
    cs2 := wc changeset.
    self assert: cs0 isObsolete not.
    self assert: cs0 successors isEmpty.
    self assert: cs1 isObsolete.
    "/ HGChangeset >> successors is not supported on
    "/ Mercurial < 4.1. In that case, successors returns an 
    "/ empty array.
    HGCommand hgVersionIsGreaterOrEqualThan_4_1 ifTrue:[
        self assert: cs1 successors size == 1.
        self assert:(cs1 successors includes: cs2).
    ].
    self assert: cs2 isObsolete not. 
    self assert: cs2 successors isEmpty.



    ( wc / 'f1.txt' ) writingFileDo:[:s | s nextPutAll:'modified from ', testSelector, ' 3'. ].
    wc commit:testSelector ,' 3' files: nil author: nil amend: true.
    cs3 := wc changeset.
    self assert: cs0 isObsolete not.
    self assert: cs1 isObsolete.
    HGCommand hgVersionIsGreaterOrEqualThan_4_1 ifTrue:[  
        self assert: cs1 successors size == 1.
        self assert:(cs1 successors includes: cs2).
    ].
    self assert: cs2 isObsolete.    
    HGCommand hgVersionIsGreaterOrEqualThan_4_1 ifTrue:[  
        self assert: cs2 successors size == 1.
        self assert:(cs2 successors includes: cs3).
    ].
    self assert: cs3 isObsolete not.

     "
     UserPreferences fileBrowserClass openOn: repo path .
    "

    "Created: / 08-02-2018 / 09:35:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-02-2018 / 15:36:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 30-03-2018 / 22:34:36 / jv"
! !

!HGTests methodsFor:'tests - mercurial'!

test_mercurial_test_commit_t
    "
    Taken from Mercurial source code: tests/test-commit.t
    "

    | repo wc |

    repo := self repositoryNamed: 'test' init: true.
    wc := repo workingCopy.
    ( wc / 'foo' )
        contents: 'foo';
        track.
    OperatingSystem isMSWINDOWSlike ifFalse:[
        self should:   [ wc commit: '' ] raise: HGCommitError withMessage: 'empty commit message'.
    ].
    self shouldnt: [ wc commit: 'commit-1' date:'0 0'] raise: HGError.
    ( wc / 'foo' )
        contents: 'foo/foo'.
    self should:   [ wc commit: 'commit-3' date:'1 444444444'] raise: HGCommitError withMessage: 'impossible time zone offset: 444444444'.

    "Created: / 04-02-2013 / 11:04:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-02-2013 / 12:37:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGTests methodsFor:'tests - merging'!

test_merge_01
    "
    Basic working copy tests after merge
    "

    | repo wc |

    repo := self repositoryNamed:'mocks/hg/p3'.
    wc := repo workingCopy.
    wc update: 2.
    wc merge: (repo @ 1).

    self assert: (wc root / 'Make.proto') isConflict.
    self assert: (wc root / 'Make.proto') isResolved.
    self deny:   (wc root / 'Make.proto') isUnresolved.

    self assert: (wc root / 'Make.spec') isConflict.
    self deny:   (wc root / 'Make.spec') isResolved.
    self assert: (wc root / 'Make.spec') isUnresolved.

    self deny: (wc root / 'MockHGP3Qux.st') isConflict.
    self deny: (wc root / 'MockHGP3Qux.st') isResolved.
    self deny: (wc root / 'MockHGP3Qux.st') isUnresolved.











     "
     UserPreferences fileBrowserClass openOn: repo directory.
    "

    "Created: / 14-01-2013 / 15:34:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-01-2013 / 16:58:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGTests methodsFor:'tests - misc'!

test_config_01
    "
    Test listing repository heads
    "

    | repo1 repo2  |

    repo1 := self repositoryNamed:'test_repo_02'.
    repo2 := repo1 cloneTo: (repositories add: (Filename newTemporaryDirectory / 'repo') pathName).

    self assert: ((repo2 config get: 'paths') get: 'default') = repo1 pathName.

    "Created: / 06-12-2012 / 21:42:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_config_02
    "
    Test listing repository heads
    "

    | repo1 s |

    repo1 := self repositoryNamed:'test_repo_02'.

    self assert: (repo1 config get: #('foo' 'bar') default: nil) isNil.
    Delay waitForSeconds: 1.

    [
        s := (repo1 path / '.hg' / 'hgrc') appendStream.
        s nextPutLine:'[foo]'.
        s nextPutLine:'bar = baz'.
    ] ensure:[
        s close
    ].

    self assert: (repo1 config get: #('foo' 'bar') default: nil) = 'baz'.

    "Created: / 09-12-2012 / 23:01:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_hasExtension
    "
    Tests HGRepository>>hasExtension:.
    Since we cannot guarantee that the system under test will
    have the extension enabled, just test for errors (DNU)
    "

    | repo |

    repo := self repositoryNamed:'test_repo_02'.           
    "/ This one is likely not enabled...
    self assert: (repo hasExtension: 'blablablalibscm' , Random nextInteger printString) not.
    repo hasExtension: 'purge'.
    repo hasExtension: 'evolve'.

    "Created: / 22-03-2016 / 19:56:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_heads_01
    "
    Test listing repository heads
    "

    | repo heads |

    repo := self repositoryNamed:'test_repo_02'.
    heads := repo heads.

    self assert: heads size == 2.
    self assert: heads first id revno == 5.
    self assert: heads second id revno == 4.

    "Created: / 27-11-2012 / 21:34:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_heads_02
    "
    Test listing repository heads on an emptu repository
    "

    | repo heads |

    repo := self repositoryNamed:'test_repo_empty' init: true.
    heads := repo heads.

    self assert: heads isEmpty.

    "Created: / 08-03-2013 / 19:33:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_hgCommand_01
    "
    Check whether hg executable is correctly set/found
    in different setups
    "
    | savedHgCommand |

    savedHgCommand := UserPreferences current hgCommand.
    [ 
        HGCommand hgCommand: nil.
        UserPreferences current hgCommand: '**some**rubbish**'.
        self should: [ HGCommand new executable ] raise: HGCommandError.

        HGCommand hgCommand: nil.
        UserPreferences current hgCommand: Filename newTemporary pathName.
        self should: [ HGCommand new executable ] raise: HGCommandError.

        HGCommand hgCommand: nil.
        UserPreferences current hgCommand: Filename newTemporaryDirectory pathName.
        self should: [ HGCommand new executable ] raise: HGCommandError.

        OperatingSystem isUNIXlike ifTrue:[
            HGCommand hgCommand: nil.
            UserPreferences current hgCommand: '/bin/ls'.
            self should: [ HGCommand new executable ] raise: HGCommandError.
        ].
    ] ensure:[ 
        UserPreferences current hgCommand: savedHgCommand. 
        HGCommand hgCommand: nil.
    ].

    "Created: / 17-07-2014 / 14:41:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_hgCommand_02
    "
    Check whether hg executable is correctly set/found
    in different setups
    "
    | savedHgCommand pathOfHgCommand |

    savedHgCommand := UserPreferences current hgCommand.
    pathOfHgCommand := OperatingSystem pathOfCommand:'hg'.

    self skipIf: pathOfHgCommand isNil description: 'No hg command found along the PATH'.
    pathOfHgCommand isNil ifTrue:[ ^ self ]. "/ For St/X 6.2.2 - there's no skipIf.
    [ 
        HGCommand hgCommand: nil.
        UserPreferences current hgCommand: pathOfHgCommand.
        self assert: (HGCommand new executable = pathOfHgCommand).

        HGCommand hgCommand: nil.
        UserPreferences current hgCommand: pathOfHgCommand asFilename baseName .
        self assert: (HGCommand new executable = pathOfHgCommand).

        HGCommand hgCommand: nil.
        UserPreferences current hgCommand: nil.
        self assert: (HGCommand new executable = pathOfHgCommand).
    ] ensure:[ 
        UserPreferences current hgCommand: savedHgCommand. 
        HGCommand hgCommand: nil.
    ].

    "Created: / 17-07-2014 / 14:41:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_hgCommand_03_unix
    "
    Check whether hg executable is correctly set/found
    in different setups
    "
    | savedHgCommand pathOfHgCommand pathOfPython cmd |

    savedHgCommand := UserPreferences current hgCommand.
    pathOfHgCommand := OperatingSystem pathOfCommand:'hg'.
    pathOfPython := OperatingSystem pathOfCommand:'python'.

    self skipIf: OperatingSystem isUNIXlike not description: 'Valid only on UNIX systems'.
    OperatingSystem isUNIXlike ifFalse:[ ^ self ]. "/ For St/X 6.2.2 - there's no skipIf.

    self skipIf: pathOfHgCommand isNil description: 'No hg command found along the PATH'.
    pathOfHgCommand isNil ifTrue:[ ^ self ]. "/ For St/X 6.2.2 - there's no skipIf.

    self skipIf: pathOfPython isNil description: 'No hg command found along the PATH'.
    pathOfPython isNil ifTrue:[ ^ self ]. "/ For St/X 6.2.2 - there's no skipIf.
    
    [ 
        HGCommand hgCommand: nil.
        UserPreferences current hgCommand: ('python "%1"' bindWith: pathOfHgCommand).
        cmd := HGCommand commit message:'123'.
        self assert: (cmd executable = pathOfPython).
        self assert: (cmd arguments size == 8).
        self assert: (cmd arguments at:1) = pathOfPython.
        self assert: (cmd arguments at:2) = pathOfHgCommand.
        self assert: (cmd arguments at:3) = '--noninteractive'.	
        self assert: (cmd arguments at:4) = '--config'.
        self assert: (cmd arguments at:5) = 'extensions.share='.
        self assert: (cmd arguments at:6) = 'commit'.
        self assert: (cmd arguments at:7) = '-m'.

        HGCommand hgCommand: nil.
        UserPreferences current hgCommand: ('"%1" "%2"' bindWith: pathOfPython with: pathOfHgCommand).         
        cmd := HGCommand commit message:'123'.
        self assert: (cmd executable = pathOfPython).
        self assert: (cmd arguments size == 8).
        self assert: (cmd arguments at:1) = pathOfPython.
        self assert: (cmd arguments at:2) = pathOfHgCommand.
        self assert: (cmd arguments at:3) = '--noninteractive'.
        self assert: (cmd arguments at:4) = '--config'.
        self assert: (cmd arguments at:5) = 'extensions.share='. 
        self assert: (cmd arguments at:6) = 'commit'.
        self assert: (cmd arguments at:7) = '-m'. 
    ] ensure:[ 
        UserPreferences current hgCommand: savedHgCommand. 
        HGCommand hgCommand: nil.
    ].

    "Created: / 17-07-2014 / 14:46:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_hgCommand_04
    "
    Check whether #hgExecutable correctly reports and
    error when `hg` command is not configured and not found
    in strandard places.
    "
    | savedHgCommand |

    savedHgCommand := UserPreferences current hgCommand.
    [ 
        HGCommand hgCommand: nil.
        MessageTracer mock: #hgCommand in: HGCommand class do: [ nil ]. 
        Smalltalk at: #'HGCommand:HGExecutable' put: nil.

        self should: [ HGCommand hgExecutable ] raise: HGInvalidExecutableError.
    ] ensure:[ 
        MessageTracer unmock: #hgCommand in: HGCommand class.
        UserPreferences current hgCommand: savedHgCommand. 
        HGCommand hgCommand: nil.
    ].

    "Created: / 23-04-2016 / 19:49:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_remotes_01
    "
    Tests listing og repository remotes (upstream repos)
    "

    | repo remotes s |

    repo := self repositoryNamed:'test_repo_01'.

    [
        s := (repo path / '.hg' / 'hgrc') appendStream.
        s nextPutLine:'[paths]'.
        s nextPutLine:'default = https://swing.fit.cvut.cz/hg/mocks.xxx'.
        s nextPutLine:'jv1 = /home/jv/xxx/jv1/yyy'
    ] ensure:[
        s close.    
    ].

    remotes := repo remotes.

    self assert: remotes size == 2.
    self assert: (remotes contains:[:e|e name = 'default' and:[e url asString = 'https://swing.fit.cvut.cz/hg/mocks.xxx']]).

    "/ Sigh, it seems somebody changed implementation asString in URL. Sigh...
    self assert: (remotes contains:[:e|e name = 'jv1' and:[e url asString = '///home/jv/xxx/jv1/yyy' or:[e url asString = '/home/jv/xxx/jv1/yyy']]]).

    "Created: / 09-12-2012 / 23:16:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 29-11-2013 / 16:14:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_share_01
    "
    Test shared repositories
    "

    | repoA repoBDir repoB |

    repoA := self repositoryNamed: 'test_share_01_A' init: true.
    repoBDir := (HGRepositoriesResource current directoryForRepositoryNamed: 'test_share_01_B' init: false).
    repoB := repoA shareTo: repoBDir.

    self assert: repoA isShared not.
    self assert: repoB isShared.

    "Created: / 25-08-2015 / 13:11:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_version
    "
    Checks for hg version (just that it does not fail)
    "

    HGCommand hgVersion.
    HGCommand hgVersionOf: nil arguments: nil

    "Created: / 21-01-2013 / 05:22:36 / jv"
    "Modified: / 17-07-2014 / 15:09:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGTests methodsFor:'tests - node id'!

test_nodeid_01
    "
    Tests parsing node id
    "

    | id |

    id := HGChangesetId fromString:'4:6f88e1f44d9eb86e0b56ca15e30e5d786acd83c7'.
    self assert: id revno = 4.
    self assert: id asByteArray = #[111 136 225 244 77 158 184 110 11 86 202 21 227 14 93 120 106 205 131 199].

    id := HGChangesetId fromString:'4:6f88e1f44d9e'.
    self assert: id revno = 4.
    self assert: id asByteArray = #[111 136 225 244 77 158].

    "/Only revno
    id := HGChangesetId fromString:'1234'.
    self assert: id revno = 1234.
    self assert: id asByteArray = #[].

    "/Only hash
    id := HGChangesetId fromString:'6f88e1f44d9eb86e0b56ca15e30e5d786acd83c7'.
    self assert: id revno isNil. "/meaning - unknown.
    self assert: id asByteArray = #[111 136 225 244 77 158 184 110 11 86 202 21 227 14 93 120 106 205 131 199].

    "/Only short hash
    id := HGChangesetId fromString:'6f88e1f44d9e'.
    self assert: id revno isNil. "/meaning - unknown.
    self assert: id asByteArray = #[111 136 225 244 77 158].

    "/Short hash that looks like a revno only
    id := HGChangesetId fromString:'087537207973'.
    self assert: id revno isNil. "/meaning - unknown.
    self assert: id asByteArray = #[16r08 16r75 16r37 16r20 16r79 16r73].

    "Created: / 16-11-2012 / 21:27:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-07-2016 / 17:54:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_nodeid_02
    "
    Tests conversions
    "

    | id |

    id := '4:6f88e1f44d9eb86e0b56ca15e30e5d786acd83c7' asHGChangesetId.
    self assert: id revno = 4.
    self assert: id asByteArray = #[111 136 225 244 77 158 184 110 11 86 202 21 227 14 93 120 106 205 131 199].

    id := 1234 asHGChangesetId.
    self assert: id revno = 1234.
    self assert: id asByteArray = #[].

    id := #[ 111 136 225 244 77 158 184 110 11 86 202 21 227 14 93 120 106 205 131 199 ]
    asHGChangesetId.
    self assert: id revno isNil.
    self assert: id asByteArray = #[111 136 225 244 77 158 184 110 11 86 202 21 227 14 93 120 106 205 131 199].

    "Created: / 16-11-2012 / 21:32:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 30-11-2012 / 23:36:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_nodeid_03
    "
    Tests comparison
    "

    | id1 id2 |

    id1 := HGChangesetId new revno: 4.
    id2 := HGChangesetId new revno: 4.

    self assert: id1 = id2.



    "/ #[111 136 225 244 77 158 184 110 11 86 202 21 227 14 93 120 106 205 131 199].

    "Created: / 16-11-2012 / 21:41:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGTests methodsFor:'tests - push/pull'!

test_pull_01a
    "
    Test whether notifications are signalled to the caller.
    "

    | repoA wcA repoCDir repoC wcC |

    repoA := self repositoryNamed: 'test_push_01_A' init: true.
    wcA := repoA workingCopy.
    repoCDir := HGRepositoriesResource current directoryForRepositoryNamed: 'test_push_01_C' init: false.
    repoC := repoA cloneTo: repoCDir.
    wcC := repoC workingCopy.

    15 timesRepeat:[
        self should: [ repoA pull: '/some/funny/directory' ] raise: HGError suchThat:[:ex|ex description startsWith: 'repository'].
    ].

    "Created: / 18-03-2013 / 10:33:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_pull_01b
    "
    Test whether notifications are signalled to the caller.
    "

    | repoA wcA repoCDir repoC wcC log info |

    repoA := self repositoryNamed: 'test_push_01_A' init: true.
    wcA := repoA workingCopy.
    repoCDir := HGRepositoriesResource current directoryForRepositoryNamed: 'test_push_01_C' init: false.
    repoC := repoA cloneTo: repoCDir.
    wcC := repoC workingCopy.

    log := OrderedCollection new.
    [ info := repoC pull: repoA pathName ] on: HGNotification do:[:not|log add: not. not proceed].
    self assert: log size = 1.
    self assert: info numChangesets = 0.
    self assert: info numChanges = 0.
    self assert: info numFiles = 0.

    "Created: / 18-03-2013 / 10:33:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_pull_01c
    "
    Test whether notifications are signalled to the caller.
    "

    | repoA wcA repoCDir repoC wcC log info |

    repoA := self repositoryNamed: 'test_push_01_A' init: true.
    wcA := repoA workingCopy.
    repoCDir := HGRepositoriesResource current directoryForRepositoryNamed: 'test_push_01_C' init: false.
    repoC := repoA cloneTo: repoCDir.
    wcC := repoC workingCopy.


    (wcA / 'foo') writingFileDo:[:s|s nextPutAll: 'foo'; syncData]; track.
    wcA commit:'test_push_01 1'.

    log := OrderedCollection new.
    [ info := repoC pull: repoA pathName ] on: HGNotification do:[:not|log add: not. not proceed].
    self assert: (repoC @ 0) message = 'test_push_01 1'.
    self assert: log size >= 5.
    self assert: info numChangesets = 1.
    self assert: info numChanges = 1.
    self assert: info numFiles = 1.

    "Created: / 18-03-2013 / 10:34:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 30-12-2017 / 08:50:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_pull_01d
    "
    Test whether notifications are signalled to the caller.
    "

    | repoA wcA repoCDir repoC wcC log info |

    repoA := self repositoryNamed: 'test_push_01_A' init: true.
    wcA := repoA workingCopy.
    repoCDir := HGRepositoriesResource current directoryForRepositoryNamed: 'test_push_01_C' init: false.
    repoC := repoA cloneTo: repoCDir.
    wcC := repoC workingCopy.


    (wcA / 'foo') writingFileDo:[:s|s nextPutAll: 'foo'; syncData]; track.
    wcA commit:'test_push_01 1'.

    (wcA / 'foo') writingFileDo:[:s|s nextPutAll: 'bar'; syncData]; track.
    wcA commit:'test_push_01 2'.

    (wcA / 'foo') writingFileDo:[:s|s nextPutAll: 'baz'; syncData]; track.
    wcA commit:'test_push_01 3'.      

    log := OrderedCollection new.
    [ info := repoC pull: repoA pathName ] on: HGNotification do:[:not|log add: not. not proceed].
    self assert: (repoC @ 0) message = 'test_push_01 1'.
    self assert: log size >= 5.
    self assert: info numChangesets = 3.
    self assert: info numChanges = 3.
    self assert: info numFiles = 1.

    "Created: / 29-12-2017 / 21:37:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 30-12-2017 / 08:50:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_push_01a
    "
    Test whether notifications are signalled to the caller.
    "

    | repoA wcA repoCDir repoC |

    repoA := self repositoryNamed: 'test_push_01_A' init: true.
    wcA := repoA workingCopy.
    repoCDir := HGRepositoriesResource current directoryForRepositoryNamed: 'test_push_01_C' init: false.
    repoC := repoA cloneTo: repoCDir.

    15 timesRepeat:[    
        self should: [ repoA push: '/some/funny/directory' ] raise: HGError 
            suchThat:[:ex|
                ex description startsWith: 'repository'
        ].
    ].

    "Created: / 18-03-2013 / 10:34:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_push_01b
    "
    Test whether notifications are signalled to the caller.
    "

    | repoA wcA repoCDir repoC log info |

    repoA := self repositoryNamed: 'test_push_01_A' init: true.
    wcA := repoA workingCopy.
    repoCDir := HGRepositoriesResource current directoryForRepositoryNamed: 'test_push_01_C' init: false.
    repoC := repoA cloneTo: repoCDir.

    log := OrderedCollection new.
    [ info := repoA push: repoC pathName ] on: HGNotification do:[:not|log add: not. not proceed].
    self assert: log size = 1.
    self assert: info numChangesets = 0.
    self assert: info numChanges = 0.
    self assert: info numFiles = 0.

    "Created: / 18-03-2013 / 10:34:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_push_01c
    "
    Test whether notifications are signalled to the caller.
    "

    | repoA wcA repoCDir repoC log info |

    repoA := self repositoryNamed: 'test_push_01_A' init: true.
    wcA := repoA workingCopy.
    repoCDir := HGRepositoriesResource current directoryForRepositoryNamed: 'test_push_01_C' init: false.
    repoC := repoA cloneTo: repoCDir.

    (wcA / 'foo') writingFileDo:[:s|s nextPutAll: 'foo'; syncData]; track.
    wcA commit:'test_push_01 1'.

    log := OrderedCollection new.
    [ info := repoA push: repoC pathName ] on: HGNotification do:[:not|log add: not. not proceed].
    self assert: (repoC @ 0) message = 'test_push_01 1'.
    self assert: log size = 5.
    self assert: info numChangesets = 1.
    self assert: info numChanges = 1.
    self assert: info numFiles = 1.

    "Created: / 18-03-2013 / 10:35:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-07-2013 / 12:11:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGTests methodsFor:'tests - wc'!

test_wc_01a

    " Test revisions "

    | repo  wc  f1_txt revs |

    repo := self repositoryNamed:'test_repo_01'.
     "
     UserPreferences fileBrowserClass openOn: repo directory.
    "
    wc := repo workingCopy.

    f1_txt := wc / 'f1.txt'.
    revs := f1_txt revisions.

    self assert: revs size == 2.
    self assert: revs first contents asString = 'f1-C0
f1-C1
'.

    self assert: revs second contents asString = 'f1-C0
'

    "Created: / 05-12-2012 / 19:50:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_wc_01b

    " Test revisions "

    | repo  wc  f1_txt revs |

    repo := self repositoryNamed:'test_repo_01'.
     "
     UserPreferences fileBrowserClass openOn: repo directory.
    "
    wc := repo workingCopy.
    wc update: 0.

    f1_txt := wc / 'f1.txt'.
    revs := f1_txt revisions.

    self assert: revs size == 2.
    self assert: revs first contents asString = 'f1-C0
f1-C1
'.

    self assert: revs second contents asString = 'f1-C0
'

    "Created: / 05-12-2012 / 19:50:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_wc_02a

    " Test revisions "

    | repo  wc  f1_txt revs |

    repo := self repositoryNamed:'test_repo_01'.
     "
     UserPreferences fileBrowserClass openOn: repo directory.
    "
    wc := repo workingCopy.

    f1_txt := wc / 'c' / 'f3.txt'.
    revs := f1_txt revisions.

    self assert: revs size == 3.
    self assert: revs first pathName = 'c/f3.txt'.
    self assert: revs first contents asString = 'f3-C0
f3-C2
f3-C4
'.
    self assert: revs second pathName = 'c/f3.txt'.
    self assert: revs second contents asString = 'f3-C0
f3-C2
'.
    self assert: revs third pathName = 'b/f3.txt'.
    self assert: revs third contents asString = 'f3-C0
'.

    "Created: / 05-12-2012 / 19:54:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_wc_02b

    " Test revisions "

    | repo  wc  f1_txt revs |

    repo := self repositoryNamed:'test_repo_01'.
     "
     UserPreferences fileBrowserClass openOn: repo directory.
    "
    wc := repo workingCopy.
    wc update: 2.

    f1_txt := wc / 'c' / 'f3.txt'.
    revs := f1_txt revisions.

    self assert: revs size == 3.
    self assert: revs first pathName = 'c/f3.txt'.
    self assert: revs first contents asString = 'f3-C0
f3-C2
f3-C4
'.
    self assert: revs second pathName = 'c/f3.txt'.
    self assert: revs second contents asString = 'f3-C0
f3-C2
'.
    self assert: revs third pathName = 'b/f3.txt'.
    self assert: revs third contents asString = 'f3-C0
'.

    "Created: / 05-12-2012 / 20:00:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_wc_02c

    " Test revisions "

    | repo  wc  f1_txt revs |

    repo := self repositoryNamed:'test_repo_01'.
     "
     UserPreferences fileBrowserClass openOn: repo directory.
    "
    wc := repo workingCopy.
    wc update: 0.

    f1_txt := wc / 'b' / 'f3.txt'.
    revs := f1_txt revisions.

    self assert: revs size == 3.
    self assert: revs first pathName = 'c/f3.txt'.
    self assert: revs first contents asString = 'f3-C0
f3-C2
f3-C4
'.
    self assert: revs second pathName = 'c/f3.txt'.
    self assert: revs second contents asString = 'f3-C0
f3-C2
'.
    self assert: revs third pathName = 'b/f3.txt'.
    self assert: revs third contents asString = 'f3-C0
'.

    "Created: / 05-12-2012 / 20:00:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_wc_03a

    " 
        Test HGWorkingCopy>>changeset/changesetId on
        an empty repository
    "

    | repo  wc |

    repo := self repositoryNamed:'test_repo_empty' init: true.
     "
     UserPreferences fileBrowserClass openOn: repo directory.
    "
    wc := repo workingCopy.
    self assert: (wc path / '.hg' / 'dirstate') exists not.
    self assert: wc changesetId = HGChangesetId null.
    self assert: wc changeset   = HGChangeset null.

    ( wc / 'a.txt' ) writingFileDo:[:s|s nextPutAll: 'a'].
    ( wc / 'a.txt' ) track.

    self assert: (wc path / '.hg' / 'dirstate') exists.
    self assert: wc changesetId = HGChangesetId null.
    self assert: wc changeset   = HGChangeset null.

    "Created: / 08-03-2013 / 19:49:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGTests class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id::                                                                                                                        '
! !

