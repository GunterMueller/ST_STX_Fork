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

SCMAbstractCommitTask subclass:#HGCommitTask
	instanceVariableNames:'author remote branch amend bookmark'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Mercurial-StX-Tasks'
!

!HGCommitTask class methodsFor:'documentation'!

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

!HGCommitTask methodsFor:'accessing'!

amend
    ^ amend == true

    "Modified: / 25-08-2015 / 13:16:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

amend:aBoolean
    amend := aBoolean.
!

author
    ^author isNil ifTrue:[
        | a |
        a := HGAuthorQuery query.
        a isNil ifTrue:[
            a := temporaryWorkingCopy repository config ui_username.
        ].
        a
    ] ifFalse:[
        author
    ]

    "Modified: / 07-12-2012 / 16:17:02 / jv"
    "Modified: / 18-02-2014 / 11:33:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

author:aString
    author := aString.
!

bookmark
    ^ bookmark
!

bookmark:aString
    bookmark := aString.
!

branch
    ^ branch
!

branch:aString
    branch := aString.
!

changeset
    "Return a changeset the commit will be based on (as HGChangeset)"

    | rev |

    rev := packages revision.
    ^ (packages repository changesetWithId:rev)

    "Created: / 08-02-2018 / 21:07:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changesetSuccessors
    "Return a set of non-obsolete successors of the 'current' changeset
     (as set of HGCHangeset). If the current changeset is not obsolete
     an empty set is returned"

    | queue successors |

    queue := OrderedCollection withAll: self changeset successors.
    successors := Set new.
    [ queue isEmpty ] whileFalse:[  
        | cs |

        cs := queue removeFirst.
        cs isObsolete ifTrue:[ 
            queue addAll: cs successors
        ] ifFalse:[ 
            successors add: cs
        ].
    ].
    ^ successors

    "Created: / 08-02-2018 / 21:14:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

filesToGenerateFor: package skipNotOverwritable: skipNotOverwritable     
    | files |

    files := super filesToGenerateFor: package skipNotOverwritable: skipNotOverwritable.
    (skipNotOverwritable and:[package parent isNil and:[ (package temporaryWorkingCopyRoot / '.hgignore') exists not ]]) ifTrue:[ 
        files add: '.hgignore'
    ].
    ^ files

    "Created: / 11-06-2015 / 08:19:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

message
    (message isNil and:[self isMergeCommit]) ifTrue:[
        message := String streamContents:[:s|
            | parent2 |
            s nextPutAll: 'Merged '.
            s nextPutAll: temporaryWorkingCopy parent1Id printStringWithoutNumber.
            s nextPutAll: ' and '.
            s nextPutAll: temporaryWorkingCopy parent2Id printStringWithoutNumber.

            parent2 := temporaryWorkingCopy parent2.
            (parent2 branches includes: temporaryWorkingCopy branch) ifFalse:[
                parent2 branches size == 1 ifTrue:[
                    s nextPutAll: ' (branch '.
                    s nextPutAll: parent2 branches anElement name.
                    s nextPutAll: ')'
                ]
            ]

        ].
        ^message.
    ].
    ^super message.

    "Created: / 01-04-2013 / 13:53:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-03-2014 / 15:07:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

remote
    ^ remote
!

remote:something
    remote := something.
! !

!HGCommitTask methodsFor:'executing'!

doCommit: msg files: containers
    "Actually commit the changes, To be overridden by subclasses"

    self synchronized:[
        | wc repository createBranch |

        wc := temporaryWorkingCopy.
        repository := packages notEmpty ifTrue:[packages anElement repository] ifFalse:[ temporaryWorkingCopy repository ].
        createBranch := branch notNil and:[branch ~= wc branch name].

        createBranch ifTrue:[
            (repository branches contains:[:b|b name = branch]) ifTrue:[
                HGCommitError raiseErrorString: 'Commiting to an existing branch is not allowed'.
                ^self.
            ].
            wc branch: branch.
        ].
        "/Cannot commit only some files after merge, in that case, commit everything"
        self isMergeCommit ifTrue:[
            wc commit: msg files: nil author: self author amend: amend
        ] ifFalse:[
            wc commit: msg files: containers author: self author amend: amend
        ].
        self isPackageCommit ifTrue:[
            bookmark notNil ifTrue:[ 
                wc repository bookmark: wc changesetId as: bookmark.  
            ].
            wc repository isShared ifFalse:[ 
                "/ Push from temporary clone to original
                wc repository push: nil force: true.
                "/Also, mark original (package) working copy as given branch
                "/so subsequent 'hg update' will update from that branch
                createBranch ifTrue:[
                    repository workingCopy branch: branch.
                ].
            ].
            "/ If working copy us not shared or when using Mercurial < 3.3 (which does not support
            "/ sharing of bookmarks), also set the bookmark on package working copy.
            bookmark notNil ifTrue:[
                (wc repository isShared not or:[ HGCommand hgVersionIsGreaterOrEqualThan_3_3 not]) ifTrue:[ 
                    repository bookmark: wc changesetId as: bookmark. 
                ].
            ].

            remote notNil ifTrue:[
                repository push: remote name force: false.
            ].
        ]
    ].

    "Created: / 15-11-2012 / 16:52:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 10-12-2012 / 10:53:14 / jv"
    "Modified: / 27-06-2016 / 11:50:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doPrepareWorkingCopy2

    self isPackageCommit ifTrue:[
        self do:[
            | p |

            p := packages anElement.
            p ensureTemporaryWorkingCopyAtRevision:p revision.

            self doFileOut
        ]
    ].

    "Created: / 28-11-2012 / 09:42:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-02-2014 / 23:27:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doUpdateLogicalRevisionTo: newRev
    "Force the logical revision of packages to given revision.
     This is used to update logical revision to a successor
     of an obsolete revision.

     Use wisely!!
    "
    | oldRev |

    oldRev := packages revision.
    packages do:[:p | p updateLogicalRevisionFrom:oldRev to:newRev  ].
    self assert: packages revision = newRev

    "Created: / 08-02-2018 / 22:14:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommitTask methodsFor:'executing - private'!

doCompileCopyrightMethodsFor: package

    package definition hgEnsureCopyrightMethod ifFalse:[ ^ self ].
    super doCompileCopyrightMethodsFor: package.

    "Created: / 21-02-2014 / 23:00:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doCompileVersionMethods

    packages do:[:each |
        each isVirtual ifFalse:[
            | klasses |

            klasses := self classesToFileOutFor: each.
            (each definition hgEnsureVersion_HGMethod or:[each root definition hgEnsureVersion_HGMethod]) ifFalse:[
                klasses := klasses select:[:cls| self shouldFileOutClass: cls].
            ].
            self doCompileVersionMethodsFor: each in: klasses asArray.
        ]
    ].

    "Created: / 09-10-2013 / 11:58:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-02-2014 / 09:53:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doRemoveOldContainersFor: package

    (package definition hgRemoveContainesForDeletedClasses or:[package root definition hgRemoveContainesForDeletedClasses]) ifFalse:[
        ^self.
    ].
    super doRemoveOldContainersFor: package

    "Created: / 21-02-2014 / 23:23:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommitTask methodsFor:'private'!

generateFile: file for: package 
    file = '.hgignore' ifTrue:[ 
        ^ self generateHGIgnoreFor: package
    ].
    ^ super generateFile: file for: package

    "Created: / 20-01-2015 / 08:12:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

generateHGIgnoreFor:package
    "Initial contents of .hgignore for Smalltalk/X packages"
    ^ 
'
syntax: glob
*Init.c   
makefile
*.so
*.H
*.o
*.STH
*.sc
objbc
objvc
*.class
java/libs/*.jar
java/libs-src/*.jar
*-Test.xml
st.chg
'

    "Created: / 20-01-2015 / 08:12:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommitTask methodsFor:'queries'!

isAmendable
    "Return true, if commit may amend previous one, false otherwise"

    temporaryWorkingCopy repository isShared ifFalse:[ 
        "/ If the repository is NOT shared, we cannot ammend
        "/ because cloned changesets are in public phase and thus
        "/ cannot be amended. Also, we would have to strip the
        "/ original revision in the original repository and then
        "/ push the amended one. Doable, but too moch work...
        ^ false
    ].
    "/ One cannot ammend when there's no commit at all
    temporaryWorkingCopy changesetId = HGChangesetId null ifTrue:[ 
        ^ false
    ].
    "/ Any changeset can be amended if we have evolve 
    "/ extension
    temporaryWorkingCopy repository hasExtensionEvolve ifTrue:[ 
        ^ true
    ].

    "/ One cannot ammend changeset with children, so
    "/ check whether the logical revision is one od the
    "/ heads.
    ^ self isCommitingNewHead not

    "Created: / 27-08-2015 / 18:29:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-02-2018 / 18:56:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isCommitingNewHead
    "Return true, if a new head is to be commited, false otherwise.

     !!!!!!NOTE!!!!!!
     When there is no head at all such as when commiting to a fresh repository
     or into a just-created branch, this method returns FALSE."

    | heads  changeset |

    heads := temporaryWorkingCopy heads.
    heads isEmpty ifTrue:[
        ^ false
    ].
    changeset := temporaryWorkingCopy changeset.
    ^ (heads includes:changeset) not

    "Created: / 08-03-2013 / 20:11:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-04-2013 / 12:57:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isMergeCommit
    "Return true, if this commit is a merge commit, i.e.,
     if commited changeset will have two parents"

    ^temporaryWorkingCopy parent2Id isNull not

    "Created: / 01-04-2013 / 13:03:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isPackageLogicalRevisonObsolete
    "Return `true`, if 'current package revision' is obsolete,
     `false` otherwise. By 'current package revision' we mean
     a revision that the smalltalk thinks the code is based on."
    
    ^ self changeset isObsolete

    "Created: / 08-02-2018 / 20:32:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommitTask class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '§Id::                                                                                                                        §'
! !

