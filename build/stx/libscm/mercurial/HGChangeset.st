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

HGRepositoryObject subclass:#HGChangeset
	instanceVariableNames:'lazy id branches bookmarks author timestamp message summary
		parent1 parent2 root rootPackage changes obsolete successors'
	classVariableNames:'NullChangeset'
	poolDictionaries:''
	category:'SCM-Mercurial-Core'
!

!HGChangeset class methodsFor:'documentation'!

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
    A HGChangeset represent one changeset in Mercurial repository.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]
        http://mercurial.selenic.com/wiki/UnderstandingMercurial

"
! !

!HGChangeset class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!HGChangeset class methodsFor:'accessing'!

null
    NullChangeset isNil ifTrue:[
        NullChangeset := self new.
        NullChangeset 
            setNonLazy;
            setId: HGChangesetId null;
            setParent1: NullChangeset;
            setParent2: NullChangeset;
            setAuthor: '';
            setMessage: '';
            setTimestamp: (Timestamp utcSecondsSince1970:0).
    ].
    ^NullChangeset

    "
        HGChangesetId null
    "

    "Created: / 19-10-2012 / 15:51:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 10-06-2016 / 10:41:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGChangeset methodsFor:'accessing'!

/ name
    "Return an HGChangesetFile representing a file 
    (in root of the directory)"

    self ensureNotLazy.
    ^self construct: name

    "Created: / 16-11-2012 / 22:24:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-12-2012 / 00:34:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

author
    self ensureNotLazy.
    ^ author

    "Modified: / 16-12-2012 / 00:33:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

bookmarks
    ^ repository bookmarks select:[:bookmark | bookmark changesetId = id ]

    "Modified: / 20-03-2014 / 02:32:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

branch
    "Return branch (as HGBranch) in which this changeset is commited. It the changeset is commited in
     multiple branches, raise an error"

    self ensureNotLazy.
    branches size ~~ 1 ifTrue:[
        HGError 
            raiseSignalWith: self 
            errorString:('Changeset %1 commited in more than one branch' bindWith: id)
    ].
    ^self branches anElement

    "Created: / 27-11-2012 / 20:49:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-12-2012 / 00:34:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

branches
    "Return list of branches (as HGBranch) in which this changeset is commited"

    self ensureNotLazy.
    (branches anySatisfy:[:b|b isString]) ifTrue:[
        | all |

        all := repository branches.
        branches := branches collect:[:nm|all detect:[:b|b name = nm] ifNone:[HGNoSuchBranchError raiseSignalWith: nm errorString:'No such branch: ', nm]]
    ].
    ^branches.

    "Created: / 27-11-2012 / 20:40:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-12-2012 / 00:34:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changes
    "Return a list of HGChange that describes differences against parent1 changeset"

    self ensureNotLazy.
    ^ changes

    "Created: / 05-12-2012 / 18:36:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-12-2012 / 00:34:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

children
    | ids |

    self ensureNotLazy.
    ids := self repository execute:
            (HGCommand log
                workingDirectory: repository pathName;
                childrenOnly: true;
                revset: id revno printString;
                yourself).

    self assert: ids size == 1.
    self assert: ids first first = id.
    ^ids first second collect:[:e|repository changesetWithId: e].

    "Created: / 05-12-2012 / 17:31:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-03-2013 / 23:09:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

construct: name
    "Return an HGChangesetFile representing a file 
    (in root of the directory)"

    self ensureNotLazy.    
    ^self root construct: name

    "Created: / 16-11-2012 / 22:25:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-12-2012 / 00:34:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

id
    ^ id

    "Modified: / 16-12-2012 / 00:34:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

labels
    ^OrderedCollection new  
        addAll: self branches;
        addAll: self bookmarks;
        addAll: self tags;
        yourself

    "Created: / 21-03-2014 / 01:45:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

message
    self ensureNotLazy.
    ^ message

    "Modified (format): / 16-12-2012 / 00:35:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

messageDigest
    | dialog |

    Display isNil ifTrue:[ 
        Smalltalk openDisplay.
        Display isNil ifTrue:[
            ^ nil "/ No way to ask for a changeset
        ]        
    ].

    dialog := HGChangesetDialog new.
    dialog repository: repository.
    dialog revset: ('merge() and branch(%1)' bindWith: repository workingCopy branch name) asHGRevset.
    dialog open ifTrue:[ 
        ^ self messageDigestUpTo: dialog changeset.
    ].
    ^ nil.

    "Created: / 03-06-2015 / 07:26:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

messageDigestUpTo: changeset
    "Return a a 'digested commit message' up to given changeset.
     The returned string is in form of

     ### shorthash 
     oldest commit message

     ### shoethash 
     middle commit message

     ### shoethash
     newest commit message

     This may be handy when exporting a commit to monticello to include
     commit message containing a digest of messages since last time the
     code was exported"

    | changesets |

    changesets := repository log: (changeset id printString, '::' , self id printString) limit: nil.
    ^ String streamContents:[ :s|
        changesets do:[:changeset | 
            s nextPutAll: '### '.    
            s nextPutLine: changeset id printStringWithoutNumber.
            s nextPutLine: changeset message.  
        ] separatedBy:[ 
            s cr.
        ].
    ]
    "
    (HGPackageWorkingCopy named: 'stx:libscm') repository workingCopy changeset messageDigest
    "

    "Created: / 03-06-2015 / 06:50:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-09-2015 / 01:45:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parent1
    self ensureNotLazy.
    parent1 class == HGChangesetId ifTrue:[
        parent1 := repository changesetWithId: parent1
    ].
    ^parent1

    "Modified: / 16-12-2012 / 00:35:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parent2
    self ensureNotLazy.
    parent2 class == HGChangesetId ifTrue:[
        parent2 := repository changesetWithId: parent2
    ].
    ^parent2

    "Modified: / 16-12-2012 / 00:35:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

root
    "Return an HGChangesetFile represening the root of
     the changeset,i.e, root of the directory tree 
     represented by given changeset"

    | filenames |

    root notNil ifTrue:[ ^ root ].
    self ensureNotLazy.
    filenames := HGCommand locate
                    workingDirectory: repository pathName;
                    revision: id revno;
                    execute.
    root := HGChangesetFile new setChangeset: self name: ''.
    filenames do:[:each|root create: each].

    ^root.

    "Created: / 16-11-2012 / 22:26:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-12-2012 / 00:35:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

rootPackage
    "Return an HGPackageRevision represening the root St/X package
     in the repository at this revision"

    rootPackage isNil ifTrue:[ 
        rootPackage := HGPackageRevision changeset:self root:self root.
    ].
    ^ rootPackage

    "Created: / 06-03-2014 / 09:22:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

successors
    "Return the list of successors for this changeset.

     If there are no successors or successors are not supported
     (e.g., using Mercurial < 4.1), an empty array is returned.
    "
    | ids |    

    HGCommand hgVersionIsGreaterOrEqualThan_4_1 ifFalse:[ ^ #() ].

    "/ In theory, we coould (and should) use HGCachedFileData, however
    "/ at least on UNIX systems the timestamp resolution is only 1sec
    "/ which is too coarse to work reliably on modern fast machines.
    "/
    "/ Sp, no caching until we get at least milliscond resolution. 
    "/ Sigh.
    "
    successors isNil ifTrue:[ 
        successors := HGCachedFileData
                        on: repository pathToHgStore00changelog_i
                        reader:[
                            | ids |    

                            ids := repository execute:
                                        (HGCommand log
                                            workingDirectory: repository path asString;
                                            revset: 'successors(', id printStringWithoutNumber, ')';
                                            hidden: true; 
                                            yourself).  
                            ids reject: [ :each | each id = id ] thenCollect:[ :each | repository changesetWithId: each id ]
                        ].       
    ].
    ^ successors value.
    "
    ids := repository execute:
                (HGCommand log
                    workingDirectory: repository path asString;
                    revset: 'successors(', id printStringWithoutNumber, ')';
                    hidden: true; 
                    yourself).  
    ^ids reject: [ :each | each id = id ] thenCollect:[ :each | repository changesetWithId: each id ]

    "Created: / 08-02-2018 / 15:27:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-03-2018 / 15:32:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

summary
    summary isNil ifTrue:[
        self ensureNotLazy.
        message isEmpty ifTrue:[ 
            summary := ''.
        ] ifFalse:[
            summary := message readStream nextLine.
        ]

    ].
    ^ summary

    "Created: / 11-03-2014 / 21:33:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-01-2016 / 08:35:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

tags
    "/ Not yet supported...
    ^ #()

    "Created: / 16-03-2014 / 23:05:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

timestamp
    self ensureNotLazy.
    ^ timestamp

    "Modified: / 16-12-2012 / 00:35:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

user
    ^ self author

    "Created: / 15-03-2014 / 13:31:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGChangeset methodsFor:'actions'!

bookmarkAs:aString
    "Create a new bookmark on receiver and return it.
     Raises an HGBookmarkError error if such bookmark already exists."
    ^ repository bookmark: self as: aString

    "Created: / 20-03-2014 / 17:13:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGChangeset methodsFor:'converting'!

asHGCRevset
    ^self id asHGRevset

    "Created: / 07-02-2014 / 13:03:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

asHGChangesetId
    ^self id

    "Created: / 14-01-2013 / 16:04:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGChangeset methodsFor:'enumerating'!

allChildrenDo: oneArgBlock
    "Evaluates given block for each child recursively."

    self childrenDo:[:e|
        oneArgBlock value: e.
        e allChildrenDo: oneArgBlock         
    ]

    "Created: / 05-12-2012 / 19:36:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

allParentsDo: oneArgBlock
    "Evaluates given block for each parent recursively."

    self parentsDo:[:e|
        oneArgBlock value: e.
        e allParentsDo: oneArgBlock         
    ]

    "Created: / 05-12-2012 / 19:36:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

childrenDo: oneArgBlock
    "Evaluates given block for each immediate child (i.e., does not
     recurse - use #allChildrenDo: to enmerate grand-children as well"

    self children do: oneArgBlock.

    "Created: / 05-12-2012 / 19:34:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parentsDo: oneArgBlock
    "Evaluates given block for each immediate parent (i.e., does not
     recurse - use #allParentsDo: to enmerate grand-parents as well"

    | p |

    p := self parent1.
    p notNil ifTrue:[oneArgBlock value:p].
    p := self parent2.
    p notNil ifTrue:[oneArgBlock value:p].

    "Created: / 05-12-2012 / 19:37:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGChangeset methodsFor:'initialization'!

initialize
    "Invoked when a new instance is created."

    "/ super initialize.   -- commented since inherited method does nothing
    lazy := true.

    "Modified: / 16-12-2012 / 00:33:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setAuthor: aString
    author := aString

    "Created: / 13-11-2012 / 10:23:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-11-2012 / 17:30:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setBranches: aCollection
    branches := aCollection.

    "Created: / 27-11-2012 / 20:25:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setChanges: aCollection
    changes := aCollection

    "Created: / 05-12-2012 / 18:36:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setId: anHGNodeId
    id := anHGNodeId

    "Created: / 13-11-2012 / 10:08:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setMessage: aString
    message := aString

    "Created: / 13-11-2012 / 10:23:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setNonLazy
    lazy := false.

    "Created: / 16-12-2012 / 00:37:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setParent1: anHGChangeset
    parent1 := anHGChangeset

    "Created: / 10-06-2016 / 10:34:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setParent1Id: anHGChangesetId
    anHGChangesetId ~~ HGChangesetId null ifTrue:[
        parent1 := anHGChangesetId
    ]

    "Created: / 13-11-2012 / 10:23:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-11-2012 / 18:05:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 10-06-2016 / 10:33:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setParent2: anHGChangeset
    parent2 := anHGChangeset

    "Created: / 10-06-2016 / 10:34:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setParent2Id: anHGChangesetId
    anHGChangesetId ~~ HGChangesetId null ifTrue:[
        parent2 := anHGChangesetId
    ]

    "Created: / 13-11-2012 / 10:23:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-11-2012 / 18:05:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 10-06-2016 / 10:34:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setSlotsFrom: otherChangeset
    "Fetches all instvars from given pre-initialized changeset"

    self class allInstVarNames withIndexDo:[:nm :i|
        (#(id root) includes: nm) ifFalse:[
            self instVarAt: i put: (otherChangeset instVarAt: i)
        ].        
    ]

    "Created: / 16-12-2012 / 00:28:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-02-2013 / 13:50:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setTimestamp: aTimestamp
    timestamp := aTimestamp

    "Created: / 13-11-2012 / 17:24:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGChangeset methodsFor:'inspecting'!

inspector2TabChangeset
    ^ Tools::Inspector2Tab new
            priority: 100;
            label:'Details';
            application:[ HGChangesetViewer new changeset: self ];
            yourself

    "Created: / 25-03-2014 / 01:52:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

inspector2Tabs
    ^ super inspector2Tabs , #(inspector2TabChangeset)

    "Created: / 25-03-2014 / 01:54:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGChangeset methodsFor:'printing & storing'!

displayString
    ^ self id printStringWithoutNumber, '   ' , self summary

    "Created: / 15-03-2014 / 01:14:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

printOn:aStream
    "append a printed representation if the receiver to the argument, aStream"

    super printOn:aStream.
    aStream nextPutAll:'('.
    id printOn:aStream.
    aStream space.
    lazy ifTrue:[
        aStream nextPut:$L.
    ] ifFalse:[
        aStream nextPut:$N.
    ].
    aStream nextPutAll:')'.

    "Modified: / 22-01-2013 / 20:53:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGChangeset methodsFor:'private'!

ensureNotLazy
    | loaded |
    lazy ifFalse:[ ^ self ].
    loaded := repository changesetWithId: id into: self.
    "/just a defensive check
    self assert: loaded == self.

    "Created: / 16-12-2012 / 00:33:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-01-2013 / 16:40:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

loaded
    ^lazy not

    "Created: / 22-01-2013 / 16:02:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-01-2013 / 20:52:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGChangeset methodsFor:'testing'!

isHGChangeset
    ^true

    "Created: / 22-01-2013 / 13:38:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isMerge
    "Return `true`, if the changeset is a 'merge' changeset, `false` otherwise."

    ^ self parent2 notNil.

    "Created: / 23-04-2018 / 22:43:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isObsolete
    "Return `true`, if the changeset is obsolete, `false` otherwise."

    "/ In theory, we coould (and should) use HGCachedFileData, however
    "/ at least on UNIX systems the timestamp resolution is only 1sec
    "/ which is too coarse to work reliably on modern fast machines.
    "/
    "/ Sp, no caching until we get at least milliscond resolution. 
    "/ Sigh.
    "
    obsolete isNil ifTrue:[
        obsolete := HGCachedFileData
                        on: repository pathToHgStore00changelog_i
                        reader:[
                            [ 
                                repository log: id printStringWithoutNumber limit: 1.
                                false
                            ] on: HGObsoleteRevisionError do:[
                                true
                            ]
                        ].                                
    ].
    ^obsolete value.
    "
    ^ [ 
        repository log: id printStringWithoutNumber limit: 1.
        false
    ] on: HGObsoleteRevisionError do:[
        true
    ]

    "Created: / 08-02-2018 / 09:14:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-03-2018 / 22:53:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGChangeset methodsFor:'utilities'!

helpText
    "Return default help text for this changeset. The format
     is similar to default format of `hg log`"

    ^ String streamContents:[ :s |
        s nextPutAll: 'Changeset: '; nextPutAll: id printString; cr.
        (self branches size ~~ 1 or:[ self branches anElement isDefault not]) ifTrue:[
            s nextPutAll: 'Branch: '.
            self branches do:[:branch | s nextPutAll: branch name ] separatedBy:[ s nextPutAll:', '].
            s cr.
        ].
        self tags notEmpty ifTrue:[
            s nextPutAll: 'Tag: '.
            self tags do:[:tag | s nextPutAll: tag name ] separatedBy:[ s nextPutAll:', '].
            s cr.
        ].
        self bookmarks notEmpty ifTrue:[
            s nextPutAll: 'Bookmark: '.
            self bookmarks do:[:bookmark | s nextPutAll: bookmark name ] separatedBy:[ s nextPutAll:', '].
            s cr.
        ].
        s nextPutAll: 'Author: '; nextPutAll: self author; cr.
        s nextPutAll: 'Date: '; nextPutAll: self timestamp printString ; cr.
        self parent1 notNil ifTrue:[ 
            s nextPutAll: 'Parent1: '.
            s nextPutAll: self parent1 id printString.
            s space.
            s nextPutAll: self parent1 summary.
            s cr.
        ].
        self parent2 notNil ifTrue:[ 
            s nextPutAll: 'Parent2: '.
            s nextPutAll: self parent2 id printString.
            s space.
            s nextPutAll: self parent2 summary.
            s cr.
        ].
        s cr.
        s nextPutAll: self message.
    ]

    "
    (HGPackageWorkingCopy named: 'stx:libscm') repository workingCopy parent1 helpText
    "

    "Created: / 10-09-2015 / 09:06:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGChangeset class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id::                                                                                                                        '
! !

