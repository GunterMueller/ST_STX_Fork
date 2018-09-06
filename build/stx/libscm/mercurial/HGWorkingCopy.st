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

HGRepositoryObject subclass:#HGWorkingCopy
	instanceVariableNames:'root mergeState'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Mercurial-Core'
!

Object subclass:#MergeState
	instanceVariableNames:'wc states'
	classVariableNames:''
	poolDictionaries:''
	privateIn:HGWorkingCopy
!

!HGWorkingCopy class methodsFor:'documentation'!

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

!HGWorkingCopy methodsFor:'accessing'!

bookmarks
    "Return bookmarks of working copy parent"

    ^ self changeset bookmarks

    "Created: / 20-03-2014 / 08:55:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

branch
    "Return currently checked-out branch"

    | name |

    name := 'default'.
    (root asFilename / '.hg' / 'branch') exists ifTrue:[
        "File DOES contain trailing newline"    
        name := (root asFilename / '.hg' / 'branch') contents first.
    ].
    ^repository branchWithName: name createIfAbsent: true.

    "Created: / 27-11-2012 / 13:51:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-01-2013 / 14:23:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

branch: aStringOrHGBranch
    "Set branch for subsequent commits. Returns new branch as HGBranch"

    | name |

    name := aStringOrHGBranch asString.

    self branch name = name ifTrue:[ ^ self ].

    (root asFilename / '.hg' / 'branch') exists ifTrue:[
        (root asFilename / '.hg' / 'branch') 
            copyTo: (root asFilename / '.hg' / 'undo.branch')
    ] ifFalse:[
        "File DOES contain trailing newline"
        (root asFilename / '.hg' / 'undo.branch') writingFileDo:[:s|
            s nextPutLine: 'default'.
        ]    
    ].
    (root asFilename / '.hg' / 'branch') writingFileDo:[:s|
        s nextPutLine: name.
    ].

    "Return HGBranch here"
    ^ aStringOrHGBranch isString ifFalse:[
        aStringOrHGBranch
    ] ifTrue:[
        repository branchWithName: name createIfAbsent: true.
    ]

    "Created: / 10-12-2012 / 03:04:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changeset
    "Return an HGChangesetId on which the working copy is based on.
     This is parent1"

    ^self parent1

    "Created: / 13-11-2012 / 21:47:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-04-2013 / 12:44:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changesetId
    "Return an HGChangeset on which the working copy is based on.
     This is parent1"

    ^self parent1Id

    "Created: / 08-03-2013 / 19:50:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-04-2013 / 12:43:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

commitTask
    ^HGCommitTask new temporaryWorkingCopy: self

    "Created: / 01-04-2013 / 12:56:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

conflicts
    "Return entries with conflicts (both resolved and unresolved)"

    ^self mergeState paths collect:[:p|root / p]

    "Created: / 14-01-2013 / 21:48:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

heads
    "Return heads of currently checked-out branch"

    ^self branch heads

    "Created: / 27-11-2012 / 21:51:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parent1
    "Return an HGChangeset representing parent1 of the receiver"

    ^repository changesetWithId: self parent1Id.

    "Created: / 01-04-2013 / 12:44:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parent1Id
    "Return an HGChangesetId of parent1 of this working copy."

    | id dirstate |

    dirstate := root asFilename / '.hg' / 'dirstate'.
    dirstate exists ifFalse:[ 
        "No changeset yet - fresh repository"
        ^ HGChangesetId null 
    ].

    dirstate readingFileDo:[:s|
        s binary.
        id := HGChangesetId fromBytes: (s next: 20).
    ].

    ^id.

    "Created: / 01-04-2013 / 12:42:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parent2
    "Return an HGChangeset representing parent2 of the receiver"

    ^repository changesetWithId: self parent2Id.

    "Created: / 01-04-2013 / 12:52:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parent2Id
    "Return an HGChangesetId of parent1 of this working copy."

    | id dirstate |

    dirstate := root asFilename / '.hg' / 'dirstate'.
    dirstate exists ifFalse:[ 
        "No changeset yet - fresh repository"
        ^ HGChangesetId null 
    ].

    dirstate readingFileDo:[:s|
        s binary.
        s skip: 20.
        id := HGChangesetId fromBytes: (s next: 20).
    ].

    ^id.

    "Created: / 01-04-2013 / 12:43:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

path
    "Return a path to the root directory of the receiver as *Filename*. 
     Use #root to get the root working copy file"

    ^repository path

    "Created: / 17-10-2012 / 13:53:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

pathName
    "Return a path to the root directory of the receiver as *String*
     Use #root to get the root working copy file"

    ^repository pathName

    "Created: / 05-12-2012 / 19:25:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

repository
    ^repository

    "Created: / 15-11-2012 / 09:48:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

root
    ^ root
!

statusesOf: workingCopyFiles
    "Return a dictionary mapping `workingCopyFiles` to their actual
     status (unmodified, modified, added, missing. removed...)"

    | relativePathNames cmd out statuses |

    statuses := Dictionary new.
    workingCopyFiles notEmpty ifTrue:[
        relativePathNames := workingCopyFiles collect:[ :e | e pathNameRelative ].
        cmd := HGCommand status.
        cmd workingDirectory: repository pathName.
        cmd paths: relativePathNames.
        out := repository execute: cmd.
        self assert: out size == workingCopyFiles size.

        workingCopyFiles do:[:each | 
            statuses at: each put: (out detect:[:pair | pair second = each pathNameRelative]) first.
        ].
    ].
    ^ statuses

    "Created: / 23-02-2017 / 14:38:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 23-02-2017 / 20:03:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGWorkingCopy methodsFor:'accessing-private'!

mergeState
    mergeState isNil ifTrue:[
        mergeState := HGCachedFileData 
                        on: ((Filename named: root pathName) / '.hg' / 'merge' / 'state')
                        reader: [MergeState new setWorkingCopy: self]
    ].
    ^mergeState value

    "Created: / 14-01-2013 / 16:38:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGWorkingCopy methodsFor:'actions'!

bookmarkAs: aString
    "Creates a new bookmark on working copy parent, make that bookmark active and return it. 
     Raises an HGBookmarkError if bookmark with the same name already exist"

    ^ repository bookmark: nil as: aString.

    "Created: / 20-03-2014 / 08:57:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 20-03-2014 / 18:42:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

commit: message
    "Commits all uncommited changes with given message"

    ^self commit: message files: nil

    "Created: / 12-11-2012 / 22:35:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

commit: message author: authorOrNil
    "Commits all uncommited changes with given message"

    ^self commit: message files: nil author: authorOrNil

    "Created: / 01-02-2013 / 14:29:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

commit: message author: authorOrNil date: dateSpecOrNil
    "Commits all uncommited changes with given message"

    ^self commit: message files: nil author: authorOrNil date: dateSpecOrNil

    "Created: / 01-02-2013 / 14:29:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

commit: message date: dateSpecOrNil
    "Commits all uncommited changes with given message"

    ^self commit: message files: nil author: nil date: dateSpecOrNil

    "Created: / 01-02-2013 / 14:29:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

commit:message files:files 
    "Commit given files with given message. If files
     is nil, all tracked modified files are commited"

    ^ self commit:message files:files author: nil"means - default"

    "Created: / 12-11-2012 / 22:36:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 17-11-2012 / 01:01:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-12-2012 / 11:44:14 / jv"
!

commit:message files:files author: authorOrNil
    "Commit given files with given message and author. If files
     is nil, all tracked modified files are commited"

    ^self commit:message files:files author: authorOrNil date: nil

    "Created: / 07-12-2012 / 11:41:52 / jv"
    "Modified: / 07-12-2012 / 15:45:38 / jv"
    "Modified: / 01-02-2013 / 14:28:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

commit:message files:files author: authorOrNil amend: amend
    "Commit given files with given message and author. 
     If `files` is nil, all tracked modified files are commited.
     If `authorOrNil` is nil, then default author (as configured in .hgrc)
     is used.
     If `amend` is true, previous changeset is amended (by means of `hg commit --amend`)
     instead creating a new changeset with current one as parent.
     "

    ^self commit:message files:files author: authorOrNil date: nil amend: amend.

    "Created: / 25-08-2015 / 16:01:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

commit:message files:files author: authorOrNil date: dateSpecOrNil
    "Commit given files with given message, author and date
     (if provided). If files is nil, all tracked modified files 
     are commited.

     Date can be a Timestamp or a String
     "
    ^ self commit:message files:files author: authorOrNil date: dateSpecOrNil amend: false

    "Created: / 01-02-2013 / 14:28:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-08-2015 / 16:02:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

commit:message files:files author: authorOrNil date: dateSpecOrNil amend: amend
    "Commit given files with given message, author and date
     (if provided). If files is nil, all tracked modified files 
     are commited.
     If `authorOrNil` is nil, then default author (as configured in .hgrc)
     is used.
     Date can be a Timestamp or a String
     If `amend` is true, previous changeset is amended (by means of `hg commit --amend`)
     instead creating a new changeset with current one as parent.                  
     "

    | author |

    author := authorOrNil.
    author isNil ifTrue:[
        author := HGAuthorQuery query.
        author isNil ifTrue:[
            author := repository config get: #(ui username) default: nil.
            author isNil ifTrue:[
                HGCommitError newException
                    parameter: { repository . message . files };
                    messageText: 'Commit author not specified!!';
                    raise
            ].
        ].
    ].

    ^self repository execute:
        (HGCommand commit
            workingDirectory:root pathName;
            message:message;
            files:files;
            author: author;
            date: dateSpecOrNil;
            amend: amend;
            yourself).

    "Created: / 25-08-2015 / 16:02:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

commit:message files:files date: dateSpecOrNil
    "Commit given files with given message and author. If files
     is nil, all tracked modified files are commited"

    ^self commit:message files:files author: nil date: dateSpecOrNil

    "Created: / 01-02-2013 / 14:28:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

merge: aChangesetOrChangesetId
    "Merge given changeset into workinf copy."

    ^self repository execute:
        (HGCommand merge
            workingDirectory: self path;
            revision: aChangesetOrChangesetId asHGChangesetId asString;
            tool: 'internal:dump';
            yourself)

    "Created: / 14-01-2013 / 15:14:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-03-2013 / 22:59:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

track: workingCopyFiles
    "Make sure that all `workingCopyFiles` are tracked by the working copy
     so subsequent #commit: would commit them to the repository."
        
    | statuses workingCopyFilesToAdd |

    statuses := self statusesOf: workingCopyFiles.
    workingCopyFilesToAdd := workingCopyFiles select:[:e | (statuses at: e) isNotTracked ].
    workingCopyFilesToAdd notEmpty ifTrue:[
        repository execute:
                (HGCommand add
                    workingDirectory: repository pathName;
                    paths: (workingCopyFilesToAdd collect:[ :e| e pathNameRelative ]);
                    yourself)
    ].

    "Created: / 23-02-2017 / 15:11:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 23-02-2017 / 16:29:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

update
    "Update the working copy to the latest rev in current branch"

    ^self update: self branch name

    "Created: / 10-12-2012 / 11:25:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

update: revisionOrBranch

    self changeset id = revisionOrBranch ifTrue:[ ^ self ].

    ^self repository execute:
        (HGCommand update
            workingDirectory: self path;
            revision: revisionOrBranch asString;
            yourself)

    "Created: / 21-11-2012 / 00:21:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-03-2013 / 23:00:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGWorkingCopy methodsFor:'initialization'!

setRepository: aHGRepository
    super setRepository: aHGRepository.
    root :=HGWorkingCopyFile wc: self path: repository path.

    "Created: / 19-09-2012 / 09:43:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 19-10-2012 / 15:44:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGWorkingCopy methodsFor:'inspecting'!

browse
    "Opens a file browser on the working copy"

    root browse

    "Created: / 04-02-2012 / 17:14:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-11-2012 / 17:00:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGWorkingCopy methodsFor:'instance creation'!

/ aString
    ^root construct: aString

    "Created: / 24-09-2012 / 13:49:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

construct: aString

    ^root construct: aString

    "Created: / 24-09-2012 / 13:50:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGWorkingCopy::MergeState methodsFor:'accessing'!

at: path
    ^self states at: path ifAbsent:[$C"like clean"].

    "Created: / 14-01-2013 / 16:47:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

includesKey: path
    ^self states includesKey: path

    "Created: / 14-01-2013 / 16:48:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

paths
    ^self states keys

    "Created: / 14-01-2013 / 21:46:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGWorkingCopy::MergeState methodsFor:'initialization'!

setWorkingCopy: anHGWorkingCopy
    wc := anHGWorkingCopy.

    "Created: / 14-01-2013 / 16:39:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGWorkingCopy::MergeState methodsFor:'private'!

states
    states isNil ifTrue:[
        states := wc repository execute:
                    (HGCommand resolve__list
                        workingDirectory: wc pathName;
                        yourself) .
    ].
    ^states

    "Created: / 14-01-2013 / 16:47:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-03-2013 / 23:00:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGWorkingCopy class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '§Id::                                                                                                                        §'
! !

