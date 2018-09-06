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

TestCase subclass:#HGCommandParserTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Mercurial-Tests'
!

!HGCommandParserTests class methodsFor:'documentation'!

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
! !

!HGCommandParserTests methodsFor:'tests - bookmarks'!

test_bookmarks_01

    | bookmarks |

    bookmarks := (HGCommandParser on: '   issue17-better-log-support 403:5cc256ed28a1
   issue33-http-auth         377:b2123fd2888b
   issue37-update-to-revision 399:858944cebec4
 * master                    403:5cc256ed28a1
') parseBookmarks.

    self assert: bookmarks size == 4.
    self assert: bookmarks first class == HGBookmark.
    self assert: bookmarks first name = 'issue17-better-log-support'.
    self assert: bookmarks first changesetId revno = 403.
    self assert: bookmarks first changesetId hexPrintString = '5CC256ED28A1'.

    self assert: bookmarks fourth class == HGBookmark.
    self assert: bookmarks fourth name = 'master'.
    self assert: bookmarks fourth changesetId revno = 403.
    self assert: bookmarks fourth changesetId hexPrintString = '5CC256ED28A1'.

    "Created: / 19-03-2014 / 23:40:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 20-03-2014 / 17:12:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_dot_hg_bookmarks_01

    | bookmarks |

    bookmarks := (HGCommandParser on: '5cc256ed28a11cd07117f9ee98f5aeb296e96cea issue17-better-log-support
5cc256ed28a11cd07117f9ee98f5aeb296e96cea master
858944cebec4a9ca6825aaaa3838513e35fe604f issue37-update-to-revision X X
b2123fd2888bb4077501d7d276639a463753d02e issue33-http-auth
') parseDotHgBookmarks.

    self assert: bookmarks size == 4.
    self assert: bookmarks first class == HGBookmark.
    self assert: bookmarks first name = 'issue17-better-log-support'.
    self assert: bookmarks first changesetId hexPrintString = '5CC256ED28A11CD07117F9EE98F5AEB296E96CEA'.

    self assert: bookmarks third class == HGBookmark.
    self assert: bookmarks third name = 'issue37-update-to-revision X X'.


    self assert: bookmarks fourth class == HGBookmark.
    self assert: bookmarks fourth name = 'issue33-http-auth'.
    self assert: bookmarks fourth changesetId hexPrintString = 'B2123FD2888BB4077501D7D276639A463753D02E'.

    "Created: / 20-03-2014 / 02:07:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 20-03-2014 / 18:54:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommandParserTests methodsFor:'tests - commands'!

test_cmd_branches_01

    | branches |

    branches := (HGCommandParser on: 'default                        5:f22945219f9be25a1fe436d81afece07b89330be
branch1                        4:5bd21fb5eea8a7cb4adf45bccfea76cda11df84a (inactive)
branch2                        3:32d32dee719fb422a69cfa6f7f8c1d8e299de2df (closed)
') parseCommandBranches.

    self assert: branches size == 3.

    self assert: branches first name = 'default'.
    self assert: branches first isActive.
    self assert: branches first isClosed not.

    self assert: branches second name = 'branch1'.
    self assert: branches second isActive not.
    self assert: branches second isClosed not.

    self assert: branches third name = 'branch2'.
    self assert: branches third isActive.
    self assert: branches third isClosed.

    "Created: / 27-11-2012 / 19:00:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_cmd_branches_02

    | branches |

    branches := (HGCommandParser on: 'invalid branchheads cache (visible): tip differs
default                     5694:756610fa329d48cd8b225524016713485aefbb95
jv                          5684:2c32b6c5d3543cd0381f9b346d62bfeabb95e6c6
') parseCommandBranches.

    self assert: branches size == 2.

    self assert: branches first name = 'default'.
    self assert: branches first isActive.
    self assert: branches first isClosed not.

    self assert: branches second name = 'jv'.
    self assert: branches second isActive.
    self assert: branches second isClosed not.

    "Created: / 08-10-2014 / 20:39:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_cmd_err_branches_01

    (HGCommandParser on: 'invalidating branch cache (tip differs)
') parseErrorBranches.

    "Created: / 06-02-2013 / 19:19:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_cmd_heads_01

    | heads |

    heads := (HGCommandParser on: '6:4e0568ffbf1a53f2d8980ba9844d2af6f0bac455
5:f22945219f9be25a1fe436d81afece07b89330be
4:5bd21fb5eea8a7cb4adf45bccfea76cda11df84a
') parseCommandHeads.

    self assert: heads size == 3.

    self assert: heads first  printString = '6:4e0568ffbf1a'.
    self assert: heads second printString = '5:f22945219f9b'.
    self assert: heads third  printString = '4:5bd21fb5eea8'.

    "Created: / 27-11-2012 / 21:22:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 30-10-2017 / 20:59:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_cmd_help_01

    | expected got |

    expected := 'hg rollback

roll back the last transaction (DANGEROUS) (DEPRECATED)

    Please use "hg commit --amend" instead of rollback to correct mistakes in
    the last commit.

    This command should be used with care. There is only one level of
    rollback, and there is no way to undo a rollback. It will also restore the
    dirstate at the time of the last transaction, losing any dirstate changes
    since that time. This command does not alter the working directory.

    Transactions are used to encapsulate the effects of all commands that
'.

    got := (HGCommandParser on: expected) parseCommandHelp.

    self assert: expected = got

    "Created: / 07-02-2014 / 10:24:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_cmd_log_children_01

    | children |

    children := (HGCommandParser on: '1:4e0568ffbfaa
6:4e0568ffbf1a 5:f22945219f9b 4:5bd21fb5eea8
') 
                parseCommandLogChildren.

    self assert: children first second size == 3.

    self assert: children first second first  printString = '6:4e0568ffbf1a'.
    self assert: children first second second printString = '5:f22945219f9b'.
    self assert: children first second third  printString = '4:5bd21fb5eea8'.

    "Created: / 05-12-2012 / 23:35:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 30-10-2017 / 20:59:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_cmd_log_file_01

    | heads |

    heads := (HGCommandParser 
                   on:'6:4e0568ffbf1a53f2d8980ba9844d2af6f0bac455
5:f22945219f9be25a1fe436d81afece07b89330be
4:5bd21fb5eea8a7cb4adf45bccfea76cda11df84a
') 
                       parseCommandLogIdsOnly.

    self assert: heads size == 3.

    self assert: heads first  printString = '6:4e0568ffbf1a'.
    self assert: heads second printString = '5:f22945219f9b'.
    self assert: heads third  printString = '4:5bd21fb5eea8'.

    "Created: / 05-12-2012 / 19:16:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 30-10-2017 / 20:59:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_cmd_merge_01

    | nergeinfo |

    nergeinfo := (HGCommandParser on: 'merging Make.proto
merging Make.spec
merging MockHGP3Foo.st
merging abbrev.stc
merging bc.mak
merging libInit.cc
merging mocks_hg_p3.st
merging p3.rc
2 files updated, 3 files merged, 0 files removed, 5 files unresolved
use ''hg resolve'' to retry unresolved file merges or ''hg update -C .'' to abandon
') parseCommandMerge.

    self assert: nergeinfo numUpdated = 2.
    self assert: nergeinfo numMerged = 3.
    self assert: nergeinfo numRemoved = 0.
    self assert: nergeinfo numUnresolved = 5.

    "Created: / 14-01-2013 / 15:58:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_cmd_merge_02

    | nergeinfo |

    nergeinfo := (HGCommandParser on: 'remote changed CharacterEncoderImplementations__SJIS.st which local deleted
use (c)hanged version or leave (d)eleted? c
merging AbortAllOperationRequest.st
merging AbortAllOperationWantedQuery.st
merging AbstractClassInstantiationError.st
merging Make.proto
merging Make.spec
merging MockHGP3Foo.st
merging abbrev.stc
merging bc.mak
merging libInit.cc
merging mocks_hg_p3.st
merging p3.rc
2 files updated, 3 files merged, 0 files removed, 5 files unresolved
use ''hg resolve'' to retry unresolved file merges or ''hg update -C .'' to abandon
') parseCommandMerge.

    self assert: nergeinfo numUpdated = 2.
    self assert: nergeinfo numMerged = 3.
    self assert: nergeinfo numRemoved = 0.
    self assert: nergeinfo numUnresolved = 5.

    "Created: / 15-01-2013 / 09:28:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_cmd_merge_03

    | nergeinfo |

    nergeinfo := (HGCommandParser on:' local changed lcmake.bat which remote deleted
use (c)hanged version or (d)elete? c
merging ApplicationDefinition.st
merging Bag.st
merging CharacterEncoder.st
merging Class.st
merging Collection.st
merging Dictionary.st
merging Float.st
merging LibraryDefinition.st
merging LongFloat.st
merging Make.proto
merging Make.spec
merging Makefile
merging OrderedCollection.st
merging PeekableStream.st
merging ProjectDefinition.st
merging SequenceableCollection.st
merging Set.st
merging ShortFloat.st
merging Smalltalk.st
merging UnixOperatingSystem.st
merging UserPreferences.st
merging WeakIdentitySet.st
merging abbrev.stc
merging bc.mak
merging libInit.cc
merging libbasic.rc
merging mingwmake.bat
merging stx_libbasic.st
merging vcmake.bat
0 files updated, 22 files merged, 0 files removed, 7 files unresolved
use ''hg resolve'' to retry unresolved file merges or ''hg update -C .'' to abandon
'
) parseCommandMerge.

    self assert: nergeinfo numUpdated = 0.
    self assert: nergeinfo numMerged = 22.
    self assert: nergeinfo numRemoved = 0.
    self assert: nergeinfo numUnresolved = 7.

    "Created: / 22-03-2013 / 08:55:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_cmd_merge_04

    | nergeinfo |

    nergeinfo := (HGCommandParser on:'merging Make.proto
merging Make.spec
merging MockHGP3Foo.st
merging abbrev.stc
merging bc.mak
merging libInit.cc
merging mocks_hg_p3.st
merging p3.rc
2 files updated, 3 files merged, 0 files removed, 5 files unresolved
use ''hg resolve'' to retry unresolved file merges or ''hg merge --abort'' to abandon
'
) parseCommandMerge.

    self assert: nergeinfo numUpdated = 2.
    self assert: nergeinfo numMerged = 3.
    self assert: nergeinfo numRemoved = 0.
    self assert: nergeinfo numUnresolved = 5.

    "Created: / 23-08-2018 / 10:40:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_cmd_pull_01

    | info |

    info := (HGCommandParser on: 'pulling from /home/jv/Private/Projects/SmalltalkX/sources/branches/jv1/build/stx/libjava
searching for changes
no changes found
') parseCommandPull.

    self assert: info numChangesets = 0.
    self assert: info numChanges = 0.
    self assert: info numFiles = 0.
    self assert: info numHeads = 0.

    "Created: / 14-02-2013 / 15:25:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_cmd_pull_02

    | info |

    info := (HGCommandParser on: 'pulling from ssh://hg@bitbucket.org/janvrany/stx-libscm
searching for changes
requesting all changes
adding changesets
adding manifests
adding file changes
added 1 changesets with 11 changes to 111 files
(run ''hg update'' to get a working copy)
') parseCommandPull.

    self assert: info numChangesets = 1.
    self assert: info numChanges = 11.
    self assert: info numFiles = 111.
    self assert: info numHeads = 0.

    "Created: / 13-07-2013 / 12:08:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_cmd_pull_05b

    | info |

    info := (HGCommandParser on: 'pulling from ssh://hg@bitbucket.org/janvrany/stx-libscm
searching for changes
no changes found
remote: X11 forwarding request failed on channel 0
') parseCommandPull.

    self assert: info numChangesets = 0.
    self assert: info numChanges = 0.
    self assert: info numFiles = 0.
    self assert: info numHeads = 0.

    "Created: / 13-07-2013 / 11:47:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_cmd_pull_06a

    | info |

    info := (HGCommandParser on: 'pulling from ssh://dialin.exept.de/repositories/hg/exept.workflow
searching for changes
adding changesets
adding manifests
adding file changes
added 16 changesets with 16 changes to 14 files (+1 heads)
(run ''hg heads'' to see heads)  
') parseCommandPull.

    self assert: info numChangesets = 16.
    self assert: info numChanges = 16.
    self assert: info numFiles = 14.
    self assert: info numHeads = 1.

    "Created: / 14-11-2013 / 13:14:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_cmd_pull_07a

    | info |

    info := (HGCommandParser on: 'pulling from /tmp/stx_tmp_jv/stxtmp_22008_oOBi/stxtmp_22008_BcX3/test_push_01_A
requesting all changes
adding changesets
adding manifests
adding file changes
added 3 changesets with 3 changes to 1 files
new changesets b3a08f50401a:9ea2239e9a9a
(run ''hg update'' to get a working copy)
') parseCommandPull.

    self assert: info numChangesets = 3.
    self assert: info numChanges = 3.
    self assert: info numFiles = 1.
    self assert: info numHeads = 0.

    "Created: / 29-12-2017 / 22:06:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_cmd_push_01

    | info |

    info := (HGCommandParser on: 'pushing to /home/jv/Private/Projects/SmalltalkX/sources/branches/jv1/build/stx/libjava
searching for changes
no changes found
') parseCommandPush.

    self assert: info numChangesets = 0.
    self assert: info numChanges = 0.
    self assert: info numFiles = 0.
    self assert: info numHeads = 0.

    "Created: / 06-02-2013 / 18:44:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_cmd_push_01b

    | info |

    info := (HGCommandParser on: 'pushing to /home/jv/Private/Projects/SmalltalkX/sources/branches/jv1/build/stx/libjava
no changes found
') parseCommandPush.

    self assert: info numChangesets = 0.
    self assert: info numChanges = 0.
    self assert: info numFiles = 0.
    self assert: info numHeads = 0.

    "Created: / 12-02-2013 / 23:48:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_cmd_push_02

    | info |

    info := (HGCommandParser on: 'pushing to /home/jv/Private/Projects/SmalltalkX/sources/branches/jv1/build/stx/libscm
searching for changes
adding changesets
adding manifests
adding file changes
added 1 changesets with 3 changes to 3 files
'
) parseCommandPush.

    self assert: info numChangesets = 1.
    self assert: info numChanges = 3.
    self assert: info numFiles = 3.
    self assert: info numHeads = 0.

    "Created: / 06-02-2013 / 18:56:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_cmd_push_03

    | info |

    info := (HGCommandParser on: 'pushing to https://vranyj1@swing.fit.cvut.cz/hg/stx.libbasic
searching for changes
remote: adding changesets
remote: adding manifests
remote: adding file changes
remote: added 2 changesets with 18 changes to 18 files (-1 heads)
'
) parseCommandPush.

    self assert: info numChangesets = 2.
    self assert: info numChanges = 18.
    self assert: info numFiles = 18.
    self assert: info numHeads = -1.

    "Created: / 02-07-2013 / 01:19:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_cmd_push_05a

    | info |

    info := (HGCommandParser on: 'pushing to https://vranyj1@swing.fit.cvut.cz/hg/stx.libbasic
searching for changes
remote: X11 forwarding request failed on channel 0
remote: adding changesets
remote: adding manifests
remote: adding file changes
remote: added 2 changesets with 18 changes to 18 files (-1 heads)
'
) parseCommandPush.

    self assert: info numChangesets = 2.
    self assert: info numChanges = 18.
    self assert: info numFiles = 18.
    self assert: info numHeads = -1.

    "Created: / 13-07-2013 / 11:45:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_cmd_push_05b

    | info |

    info := (HGCommandParser on: 'pushing to ssh://hg@bitbucket.org/janvrany/stx-libscm
searching for changes
no changes found
remote: X11 forwarding request failed on channel 0
'
) parseCommandPush.

    self assert: info numChangesets = 0.
    self assert: info numChanges = 0.
    self assert: info numFiles = 0.
    self assert: info numHeads = 0.

    "Created: / 13-07-2013 / 11:46:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_cmd_showconfig_01

    | section |

    section := (HGCommandParser on: 'foo.bar=qux
') parseCommandShowConfig.

    self assert: ((section get: 'foo') get: 'bar') = 'qux'

    "Created: / 06-12-2012 / 15:59:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-12-2012 / 19:39:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_cmd_showconfig_02

    | section |

    section := (HGCommandParser on: 'foo.bar=qux
foo.baz=qoor
') parseCommandShowConfig.

    self assert: ((section get: 'foo') get: 'bar') = 'qux'.
    self assert: ((section get: 'foo') get: 'baz') = 'qoor'.

    self should:[(section get: 'foo') get: 'zork'] raise: Error.
    self should:[(section get: 'zork') get: 'zork'] raise: Error.

    "Created: / 06-12-2012 / 16:18:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-12-2012 / 20:07:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_cmd_showconfig_03

    | section |

    section := (HGCommandParser on: 'foo.bar=qux
foo.baz=qoor
') parseCommandShowConfig.

    self assert: ((section get: 'foo') get: 'bar' default: 'urg') = 'qux'.
    self assert: ((section get: 'foo') get: 'zork' default: 'qoor') = 'qoor'.

    "Created: / 06-12-2012 / 20:19:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_cmd_showconfig_04

    | section |

    section := (HGCommandParser on: 'foo.bar=qux
') parseCommandShowConfig.

    self assert: (section get: #('foo' 'bar')) = 'qux'.
    self assert: (section get: #('foo' 'baz') default:'quark') = 'quark'.
    self assert: (section get: #('zork' 'baz') default:'quark') = 'quark'.

    "Created: / 06-12-2012 / 21:50:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_cmd_status_01

    | statuses |

    statuses := (HGCommandParser on: 'M HGRevisionInfo.st
? something.txt
') parseCommandStatus.

    self assert: statuses size == 2.
    self assert: statuses first first isModified.
    self assert: statuses first second = 'HGRevisionInfo.st'.

    self assert: statuses second first isUntracked.
    self assert: statuses second second = 'something.txt'.

    "Created: / 21-11-2012 / 00:53:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_cmd_status_02

    | statuses |

    statuses := (HGCommandParser on: 'A HGRevisionInfo.st
  HGVersionInfo.st
') parseCommandStatus.

    self assert: statuses size == 1.
    self assert: statuses first first isCopied.
    self assert: statuses first first source = 'HGVersionInfo.st'.
    self assert: statuses first second = 'HGRevisionInfo.st'.

    "Created: / 21-11-2012 / 01:08:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_cmd_status_03

    | statuses |

    statuses := (HGCommandParser on: 'A HGRevisionInfo.st
  HGVersionInfo.st
? something.txt
') parseCommandStatus.

    self assert: statuses size == 2.
    self assert: statuses first first isCopied.
    self assert: statuses first first source = 'HGVersionInfo.st'.
    self assert: statuses first second = 'HGRevisionInfo.st'.

    self assert: statuses second first isUntracked.
    self assert: statuses second second = 'something.txt'.

    "Created: / 21-11-2012 / 01:09:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_cmd_update_01

    | nergeinfo |

    nergeinfo := (HGCommandParser on: '9 files updated, 0 files merged, 1 files removed, 0 files unresolved
') parseCommandUpdate.

    self assert: nergeinfo numUpdated = 9.
    self assert: nergeinfo numMerged = 0.
    self assert: nergeinfo numRemoved = 1.
    self assert: nergeinfo numUnresolved = 0.

    "Created: / 14-01-2013 / 15:46:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommandParserTests methodsFor:'tests - errors'!

test_error_01

    self shouldnt:[
        (HGCommandParser on: '/home/jv/.hgext/mercurial_keyring.py:368: UserWarning: Basic Auth Realm was unquoted
return basic_http_error_auth_reqed.orig(self, authreq, host, req, headers)
') parseError ] raise: Error.

    "Created: / 02-07-2013 / 01:10:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_error_02

    self should:[
        (HGCommandParser on: '*** failed to import extension histedit: No module named histedit
abort: repository /some/funny/directory not found!!') parseError ] raise: HGError.

    "Created: / 06-11-2014 / 00:12:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_error_03
    "Test for Mercurial >= 4.3 that introduced new format of errors (see below).
     Sigh."

    self should:[
        (HGCommandParser on: 'hg: parse error: impossible time zone offset: 444444444
') parseErrorCommit ] raise: HGCommitError

    "Created: / 17-10-2017 / 09:46:09 / jv"
!

test_error_04
    "Test for Mercurial >= 4.3 that introduced new format of errors (see below).
     Sigh."

    self should:[ (HGCommandParser on: 'abort: unknown revision ''96DB65258808720D8D5EA6CB7A6A4D4F4E467325''!!\' withCRs) parseError ] 
         raise: HGUnknownRevisionError suchThat:[ :ex | ex parameter = '96DB65258808720D8D5EA6CB7A6A4D4F4E467325' asHGChangesetId ].

    self should:[ (HGCommandParser on: 'abort: hidden revision ''96DB65258808720D8D5EA6CB7A6A4D4F4E467325''!!\(use --hidden to access hidden revisions)' withCRs) parseError ] 
         raise: HGObsoleteRevisionError suchThat:[ :ex | ex parameter = '96DB65258808720D8D5EA6CB7A6A4D4F4E467325' asHGChangesetId ]

    "Created: / 08-02-2018 / 08:32:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommandParserTests methodsFor:'tests - misc'!

test_misc_01

    | id |

    id := (HGCommandParser on: '4:6f88e1f44d9eb86e0b56ca15e30e5d786acd83c7') parseNodeId.
    self assert: ( id revno == 4 ).
    self assert: ( id hexPrintString = '6F88E1F44D9EB86E0B56CA15E30E5D786ACD83C7' ).

    id := (HGCommandParser on: '4:6f88e1f44d9e') parseNodeId.
    self assert: ( id revno == 4 ).
    self assert: ( id hexPrintString = '6F88E1F44D9E' ).

    id := (HGCommandParser on: '-1:0000000000000000000000000000000000000000') parseNodeId.
    self assert: id == HGChangesetId null.

    id := (HGCommandParser on: '-1:000000000000') parseNodeId.
    self assert: id == HGChangesetId null.


    "/ Too short id
    self 
        should:[id := (HGCommandParser on: '4:6f88e1f44d9eb86e0b56ca15e30e5d786acd83') parseNodeId.]
        raise: Error.
    self 
        should:[id := (HGCommandParser on: '4:6f88e1f44d9') parseNodeId.]
        raise: Error.


    "/ Invalid char
    self 
        should:[id := (HGCommandParser on: '4:6f88e1f44d9eb86e0b56ca15e30e5d786acd8X') parseNodeId.]
        raise: Error.

        self 
        should:[id := (HGCommandParser on: '4:6f88e1f44d9X') parseNodeId.]
        raise: Error.

    "Created: / 13-11-2012 / 16:34:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_misc_03a

    | rev |

    rev := (HGCommandParser on: '4:6f88e1f44d9eb86e0b56ca15e30e5d786acd83c7
default
3:912a64597e4f133ffbc1fdabdda99167a2d69ce2 -1:0000000000000000000000000000000000000000 





Jan Vrany <jan.vrany@fit.cvut.cz>
2012-10-17 13:20 +0200
Commit 4
**EOE**
') parseLogEntry.

    self assert: rev id revno = 4.
    self assert: rev author = 'Jan Vrany <jan.vrany@fit.cvut.cz>'.
    self assert: rev timestamp hour = 13.
    self assert: rev message = 'Commit 4'.

    "Created: / 05-12-2012 / 17:37:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 19-03-2014 / 23:25:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_misc_03b

    | rev |

    rev := (HGCommandParser on: '4:6f88e1f44d9eb86e0b56ca15e30e5d786acd83c7
default
3:912a64597e4f133ffbc1fdabdda99167a2d69ce2 -1:0000000000000000000000000000000000000000 





Jan Vrany <jan.vrany@fit.cvut.cz>
2012-10-17 13:20 +0200
Commit 4
Two lones
**EOE**
') parseLogEntry.

    self assert: rev message = 'Commit 4
Two lones'.

    "Created: / 21-11-2012 / 18:09:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 19-03-2014 / 23:25:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_misc_03c

    | rev |

    rev := (HGCommandParser on: '4:6f88e1f44d9eb86e0b56ca15e30e5d786acd83c7
default
3:912a64597e4f133ffbc1fdabdda99167a2d69ce2 -1:0000000000000000000000000000000000000000 





Jan Vrany <jan.vrany@fit.cvut.cz>
2012-10-17 13:20 +0200
Commit 4
Two lones
**EOE**
') parseLogEntry.

    self assert: rev message = 'Commit 4
Two lones'.

    "Created: / 05-12-2012 / 17:39:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 19-03-2014 / 23:25:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_misc_04

    | revs |

    revs := (HGCommandParser on: '4:6f88e1f44d9eb86e0b56ca15e30e5d786acd83c7
default
3:912a64597e4f133ffbc1fdabdda99167a2d69ce2 -1:0000000000000000000000000000000000000000 





Jan Vrany <jan.vrany@fit.cvut.cz>
2012-10-17 13:20 +0200
Commit 4
**EOE**
3:912a64597e4f133ffbc1fdabdda99167a2d69ce2
default
2:db43a5baa9acaf2536d8b12c070b4f5e0363d45c -1:0000000000000000000000000000000000000000 





Jan Vrany <jan.vrany@fit.cvut.cz>
2012-10-17 13:20 +0200
Commit 3
**EOE**
') parseLog.

    self assert: revs size == 2

    "Created: / 13-11-2012 / 17:31:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 19-03-2014 / 23:32:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_misc_05a

    | rev |

    rev := (HGCommandParser on: '4:6f88e1f44d9eb86e0b56ca15e30e5d786acd83c7
default
3:912a64597e4f133ffbc1fdabdda99167a2d69ce2 -1:0000000000000000000000000000000000000000 

b/f2.txt b/f3.txt f1.txt


README.txt
Jan Vrany <jan.vrany@fit.cvut.cz>
2012-10-17 13:20 +0200
Commit 4
**EOE**
') parseLogEntry.

    self assert: rev changes size == 4.

    "Created: / 05-12-2012 / 18:34:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 19-03-2014 / 23:25:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_misc_05b

    | rev |

    rev := (HGCommandParser on: '4:6f88e1f44d9eb86e0b56ca15e30e5d786acd83c7
default
3:912a64597e4f133ffbc1fdabdda99167a2d69ce2 -1:0000000000000000000000000000000000000000 

c/f3.txt
c/f3.txt (b/f3.txt)
b/f3.txt

Jan Vrany <jan.vrany@fit.cvut.cz>
2012-10-17 13:20 +0200
Commit 4
**EOE**
') parseLogEntry.

    self assert: rev changes size == 1.

    "Created: / 05-12-2012 / 18:45:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 19-03-2014 / 23:25:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_misc_06

    | list |

    list := (HGCommandParser on: 'examples/tomcat6/apache-tomcat-6.0.35-src/.classpath (examples/tomcat/apache-tomcat-6.0.35-src/.classpath)examples/tomcat6/apache-tomcat-6.0.35-src/.project (examples/tomcat/apache-tomcat-6.0.35-src/.project)')
                parsePathCopyList.

    self assert: list size == 2

    "Created: / 10-01-2013 / 23:21:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_misc_06b

    | list |

    list := (HGCommandParser on: 'examples (examples)examples/tomcat6/ (examples/tomcat/)')
                parsePathCopyList.

    self assert: list size == 2

    "Created: / 10-01-2013 / 23:23:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_version_2_3_3

    | vsn |

    vsn := (HGCommandParser on: 'Mercurial Distributed SCM (version 2.3.2)
(see http://mercurial.selenic.com for more information)

Copyright (C) 2005-2012 Matt Mackall and others
This is free software; see the source for copying conditions. There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
') parseCommandVersion.

    self assert: vsn = #(2 3 2)

    "Created: / 19-11-2012 / 20:59:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_version_2_4

    | vsn |

    vsn := (HGCommandParser on: 'Mercurial Distributed SCM (version 2.4)
(see http://mercurial.selenic.com for more information)

Copyright (C) 2005-2012 Matt Mackall and others
This is free software; see the source for copying conditions. There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
') parseCommandVersion.

    self assert: vsn = #(2 4 nil)

    "Created: / 19-11-2012 / 21:00:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_version_2_9_20140204

    | vsn |

    vsn := (HGCommandParser on: 'Mercurial Distributed SCM (version 2.9+20140204)
(see http://mercurial.selenic.com for more information)

Copyright (C) 2005-2014 Matt Mackall and others
This is free software; see the source for copying conditions. There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
') parseCommandVersion.

    self assert: vsn = #(2 9 nil)

    "Created: / 01-12-2014 / 20:16:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_version_3_2_1_128_b913c394386f

    | vsn |

    vsn := (HGCommandParser on: 'Mercurial Distributed SCM (version 3.2.1+128-b913c394386f)
(see http://mercurial.selenic.com for more information)

Copyright (C) 2005-2014 Matt Mackall and others
This is free software; see the source for copying conditions. There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
') parseCommandVersion.

    self assert: vsn = #(3 2 1)

    "Created: / 01-12-2014 / 20:13:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommandParserTests methodsFor:'tests - shell'!

test_shell_bash

    | tokens |

    tokens := (HGCommandParser on: 'hg') parseShellCommandAsForSh.
    self assert: tokens size == 1.
    self assert: tokens first = 'hg'.

    tokens := (HGCommandParser on: '\h\g') parseShellCommandAsForSh.
    self assert: tokens size == 1.
    self assert: tokens first = 'hg'.    

    tokens := (HGCommandParser on: '''hg''') parseShellCommandAsForSh.
    self assert: tokens size == 1.
    self assert: tokens first = 'hg'.    

    tokens := (HGCommandParser on: '"hg"') parseShellCommandAsForSh.
    self assert: tokens size == 1.
    self assert: tokens first = 'hg'.    

    tokens := (HGCommandParser on: '"h""g"') parseShellCommandAsForSh.
    self assert: tokens size == 1.
    self assert: tokens first = 'hg'.    
    
    tokens := (HGCommandParser on: '''h''''g''') parseShellCommandAsForSh.
    self assert: tokens size == 1.
    self assert: tokens first = 'hg'.    
    
    tokens := (HGCommandParser on: 'hg --debug') parseShellCommandAsForSh.
    self assert: tokens size == 2.
    self assert: tokens first = 'hg'.
    self assert: tokens second = '--debug'.

    tokens := (HGCommandParser on: 'echo "123"') parseShellCommandAsForSh.
    self assert: tokens size == 2.
    self assert: tokens first = 'echo'.
    self assert: tokens second = '123'.

    tokens := (HGCommandParser on: 'echo "\123"') parseShellCommandAsForSh.
    self assert: tokens size == 2.
    self assert: tokens first = 'echo'.
    self assert: tokens second = '\123'.

    tokens := (HGCommandParser on: 'echo "\"123"') parseShellCommandAsForSh.
    self assert: tokens size == 2.
    self assert: tokens first = 'echo'.
    self assert: tokens second = '"123'.

    tokens := (HGCommandParser on: 'echo "\''123"') parseShellCommandAsForSh.
    self assert: tokens size == 2.
    self assert: tokens first = 'echo'.
    self assert: tokens second = '\''123'.

    tokens := (HGCommandParser on: 'echo "1"23"4"') parseShellCommandAsForSh.
    self assert: tokens size == 2.
    self assert: tokens first = 'echo'.
    self assert: tokens second = '1234'.

    tokens := (HGCommandParser on: 'echo 12\ 34') parseShellCommandAsForSh.
    self assert: tokens size == 2.
    self assert: tokens first = 'echo'.
    self assert: tokens second = '12 34'.

    "Created: / 17-07-2014 / 13:51:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_shell_cmd

    | tokens |

    tokens := (HGCommandParser on: 'hg') parseShellCommandAsForCmd.
    self assert: tokens size == 1.
    self assert: tokens first = 'hg'.

    tokens := (HGCommandParser on: '^h^g') parseShellCommandAsForCmd.
    self assert: tokens size == 1.
    self assert: tokens first = 'hg'.    

    tokens := (HGCommandParser on: '"hg"') parseShellCommandAsForCmd.
    self assert: tokens size == 1.
    self assert: tokens first = 'hg'.    

    tokens := (HGCommandParser on: '"h""g"') parseShellCommandAsForCmd.
    self assert: tokens size == 1.
    self assert: tokens first = 'hg'.    

    tokens := (HGCommandParser on: 'hg --debug') parseShellCommandAsForCmd.
    self assert: tokens size == 2.
    self assert: tokens first = 'hg'.
    self assert: tokens second = '--debug'.

    tokens := (HGCommandParser on: 'echo "123"') parseShellCommandAsForCmd.
    self assert: tokens size == 2.
    self assert: tokens first = 'echo'.
    self assert: tokens second = '123'.

    tokens := (HGCommandParser on: 'echo "\123"') parseShellCommandAsForCmd.
    self assert: tokens size == 2.
    self assert: tokens first = 'echo'.
    self assert: tokens second = '\123'.

    tokens := (HGCommandParser on: 'echo ''1 2''') parseShellCommandAsForCmd.
    self assert: tokens size == 3.
    self assert: tokens first = 'echo'.
    self assert: tokens second = '''1'.
    self assert: tokens third = '2'''.

    tokens := (HGCommandParser on: 'echo "1"23"4"') parseShellCommandAsForCmd.
    self assert: tokens size == 2.
    self assert: tokens first = 'echo'.
    self assert: tokens second = '1234'.

    tokens := (HGCommandParser on: 'echo 12^ 34') parseShellCommandAsForCmd.
    self assert: tokens size == 2.
    self assert: tokens first = 'echo'.
    self assert: tokens second = '12^ 34'.

    "Created: / 17-07-2014 / 14:26:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommandParserTests class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id::                                                                                                                        '
! !

