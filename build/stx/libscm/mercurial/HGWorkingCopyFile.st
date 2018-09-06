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

Object subclass:#HGWorkingCopyFile
	instanceVariableNames:'wc children filename revisions'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Mercurial-Core'
!

Object subclass:#LazyRevision
	instanceVariableNames:'collection index changeset wc path'
	classVariableNames:''
	poolDictionaries:''
	privateIn:HGWorkingCopyFile
!

!HGWorkingCopyFile class methodsFor:'documentation'!

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
    A representation on a file in working copy. It behaves just like 
    ordinary filename but also provides methods for quering it's
    state (added/removed/modified...), access to previous versions
    and so on.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!HGWorkingCopyFile class methodsFor:'instance creation'!

wc: aHGWorkingCopy path: aStringOrFilename
    ^self new setWorkingCopy: aHGWorkingCopy path: aStringOrFilename

    "Created: / 24-09-2012 / 13:52:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGWorkingCopyFile methodsFor:'* As yet uncategorized *'!

writeStream
    ^ filename writeStream

    "Created: / 17-09-2013 / 02:53:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGWorkingCopyFile methodsFor:'accessing'!

changeset
    ^wc changeset

    "Created: / 05-12-2012 / 19:23:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

pathName
    ^filename pathName

    "Created: / 12-11-2012 / 22:43:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

pathNameRelative
    ^self == wc root
        ifTrue:['']
        ifFalse:[filename pathName copyFrom: (wc root pathName size + 2)]

    "Created: / 25-09-2012 / 00:28:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-11-2012 / 11:23:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

pathNameRelativeSlashed
    | p |

    p := self pathNameRelative.
    (p includes:$\) ifTrue:[
        p := p copyReplaceAll:$\ with:$/.
    ].
    ^p

    "Created: / 06-12-2012 / 17:11:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

repository
    ^wc repository

    "Created: / 03-03-2013 / 20:40:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

revisions
    | path pathS |

    path := self pathNameRelative.
    pathS := OperatingSystem isMSWINDOWSlike 
                ifTrue:[path copyReplaceAll:$\ with: $/]
                ifFalse:[path].


    revisions isNil ifTrue:[
        | old oldIds |
        oldIds := self repository execute:
                    (HGCommand log
                        workingDirectory: wc pathName;
                        idsOnly: true;
                        path: path;
                        yourself).
        pathS.
        old := OrderedCollection new.
        oldIds withIndexDo: [:id :index|
            old add: (
                LazyRevision new
                    setCollection: old index: index changesetId: id workingCopy: wc path: pathS)
"/            | cs f |
"/
"/            f := (cs := wc repository changesetWithId: id) / p.
"/
"/            cs changes do:[:chg|
"/                "/Catch renames...
"/                (chg isCopied and:[chg path = p]) ifTrue:[
"/                    p := chg source.
"/                ]
"/            ].
"/            f.
        ].

        revisions := old.
    ].
    "/older revisions are cached, newer not since they may change...

    ^((wc changeset / pathS) newer:true) , revisions

    "Created: / 05-12-2012 / 19:09:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-12-2012 / 03:50:58 / jv"
    "Modified: / 08-02-2014 / 22:02:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sha1
    "Returns a SHA1 sum of file's contents"
    | sha1 |

    filename readingFileDo:[:s | sha1 := SHA1Stream hashValueOf:s].
    ^ sha1

    "Created: / 24-04-2018 / 15:38:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

status
    | statuses  |

    statuses := wc statusesOf: (Array with: self).
    ^ statuses at: self.

    "Created: / 24-09-2012 / 22:27:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 23-02-2017 / 14:39:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

workingCopy
    ^wc

    "Created: / 13-03-2013 / 00:10:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGWorkingCopyFile methodsFor:'delegating'!

doesNotUnderstand: aMessage

    ^(filename respondsTo: aMessage selector) ifTrue:[
        aMessage sendTo: filename
    ] ifFalse:[
        super doesNotUnderstand: aMessage
    ].

    "Created: / 24-09-2012 / 13:46:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGWorkingCopyFile methodsFor:'enumerating-contents'!

directoryContentsAsFilenamesDo:aBlock
    "evaluate aBlock for each file in the directory represented by the receiver.
     The block is invoked with a filename-argument.
     The enumerations order is undefined - i.e. usually NOT sorted by
     filenames (but by creation time - on some systems).
     This excludes entries for '.' or '..'.
     NoOp for non-existing directories; however, this behavior
     may be changed in the near future, to raise an exception instead.
     So users of this method better test for existing directory before.
     Notice: this enumerates fileName objects; see also
     #directoryContentsDo:, which enumerates strings."

    self directoryContentsDo:[:entry |
        aBlock value:(self construct:entry).
    ]

    "
     '.' asFilename directoryContentsAsFilenamesDo:[:fn | Transcript showCR:fn pathName].
    "

    "Modified: / 18.9.1997 / 18:42:23 / stefan"
    "Modified: / 23.12.1999 / 20:56:35 / cg"
! !

!HGWorkingCopyFile methodsFor:'initialization'!

setWorkingCopy: aHGWorkingCopy path: aStringOrFilename

    wc := aHGWorkingCopy.
    filename := aStringOrFilename asFilename.

    "Created: / 24-09-2012 / 13:53:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGWorkingCopyFile methodsFor:'inspecting'!

browse
    "Opens a file browser on the working copy"

    HGSourceCodeManager workingCopyBrowserClass openOnDirectory: filename

    "Created: / 04-02-2012 / 17:14:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-12-2012 / 15:48:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

inspector2TabContentsView
    <inspector2Tab>   

    ^ filename inspector2TabContentsView

    "Created: / 12-06-2015 / 10:35:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGWorkingCopyFile methodsFor:'instance creation'!

/ aString
    ^self construct: aString

    "Created: / 24-09-2012 / 13:49:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

construct: aString
    ^(aString includes: Filename separator) ifTrue:[
        self components: (aString tokensBasedOn: Filename separator)
    ] ifFalse:[
        self component: aString
    ]

    "Created: / 24-09-2012 / 13:50:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGWorkingCopyFile methodsFor:'instance creation-private'!

component: aString

    aString = '.' ifTrue:[ ^ self ].
    aString = '..' ifTrue:[ ^ self error:'Not yet supported' ].

    children isNil ifTrue: [ children := Dictionary new ].
    ^children 
        at: aString 
        ifAbsentPut:[HGWorkingCopyFile wc: wc path: (filename construct: aString)]

    "Created: / 24-09-2012 / 23:26:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-12-2012 / 02:09:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

components: anArray"OfStrings"
    ^anArray inject: self into:[:entry :name | entry component: name ]

    "Created: / 24-09-2012 / 23:25:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGWorkingCopyFile methodsFor:'operations'!

markResolved
    self repository execute:
        (HGCommand resolve
            workingDirectory: filename directory;
            mark: true;
            files: (Array with: filename baseName);
            yourself)

    "Created: / 15-01-2013 / 10:22:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-03-2013 / 23:01:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

markUnresolved
    self repository execute:
        (HGCommand resolve
            workingDirectory: filename directory;
            unmark: true;
            files: (Array with: filename baseName);
            yourself).

    "Created: / 15-01-2013 / 10:22:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-03-2013 / 23:02:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

moveTo: destination
    "Make sure that this entry is tracked by Mercurial"

    self isTracked ifTrue:[
        self repository execute:
            (HGCommand mv
                workingDirectory: filename directory;
                source: filename pathName;
                destination: destination pathName;
                yourself)
    ].
    filename exists ifTrue:[
        filename moveTo: destination pathName
    ].

    "Created: / 15-11-2012 / 00:23:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-03-2013 / 23:02:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

remove
    "Make sure that this entry is tracked by Mercurial"

    self isTracked ifTrue:[
        self repository execute:
            (HGCommand remove
               workingDirectory: filename directory;
               force: true;
               paths: { filename baseName };
               yourself)
    ].
    filename remove

    "Created: / 15-11-2012 / 00:08:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-10-2013 / 18:26:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

track
    <resource: #obsolete>
    "Make sure that this entry is tracked by Mercurial. 

     This method is obsolete, please use HGWorkingCopy >> track: instead
     as it allows to track multiple files at once (making tools a little 
     faster)"
    wc track: (Array with: self)

    "Created: / 15-11-2012 / 00:08:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 23-02-2017 / 15:11:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 23-02-2017 / 16:31:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGWorkingCopyFile methodsFor:'printing & storing'!

printOn:aStream
    "append a printed representation if the receiver to the argument, aStream"

    | path |

    aStream nextPut:$[.
    path := filename pathName.
    path := path copyFrom: wc path pathName size + 1.
    aStream nextPutAll: path.
    aStream nextPut:$].

    "Modified: / 17-10-2012 / 13:51:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGWorkingCopyFile methodsFor:'reading-directories'!

directoryContentsAsFilenames
    "return the contents of the directory as a collection of filenames.
     This excludes any entries for '.' or '..'.
     Returns nil for non-existing directories; however, this behavior
     may be changed in the near future, to raise an exception instead.
     So users of this method better test for existing directory before.
     Notice: 
        this returns the file-names as fileName instances; 
        see also #directoryContents, which returns strings."

    |names|

    names := filename directoryContents.
    names isNil ifTrue:[^ nil].
    ^ names collect:[:entry | self construct:entry].

    "
     '.' asFilename directoryContentsAsFilenames   
     '/XXXdoesNotExist' asFilename directoryContentsAsFilenames
    "

    "Modified: / 15-11-2012 / 01:13:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

directoryContentsAsFilenamesMatching: patternOrCollectionOfThose

    "
        Same as directoryContentsAsFilenames, but returns only files
        that matches given patterns. This uses String>>matches:
        for pattern matching
    "

    |names|

    names := filename directoryContentsMatching: patternOrCollectionOfThose .
    names isNil ifTrue:[^ nil].
    ^ names asOrderedCollection collect:[:entry | self construct:entry].

    "
    '/etc' asFilename
        directoryContentsAsFilenamesMatching: 'pass*'

    '/etc' asFilename
            directoryContentsAsFilenamesMatching: #('pass*' 'nsswitch.conf')
    "

    "Created: / 03-06-2009 / 09:57:45 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 15-11-2012 / 01:13:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

recursiveDirectoryContentsAsFilenames
    "return the contents of the directory and all subdirectories
     as a collection of filenames.
     This excludes any entries for '.' or '..'.
     Returns nil for non-existing directories; however, this behavior
     may be changed in the near future, to raise an exception instead.
     So users of this method better test for existing directory before.
     Notice: 
        this returns the file-names as fileName instances; 
        see also #recursiveDirectoryContents, which returns strings.

     Warning: this may take a long time to execute."

    |names|

    names := filename recursiveDirectoryContents.
    names isNil ifTrue:[^ nil].
    ^ names collect:[:entry | self construct:entry].

    "Created: / 15-11-2012 / 01:11:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGWorkingCopyFile methodsFor:'testing'!

isAdded
    ^ self status isAdded

    "Modified: / 23-10-2012 / 11:13:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isClean
    ^ self status isClean

    "Modified: / 23-10-2012 / 11:13:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isCleanOrIgnored
    | s |

    s := self status.
    ^s isClean or:[s isIgnored]

    "Created: / 15-11-2012 / 01:25:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isConflict
    "Return true, if the file had a conflict during merge or update.

     Note, that this return true even if the file was later merged
     and conflicts resolved. To check whether conflicts are resolved or
     not, use #isResolved or isUnresolved"

    ^wc mergeState includesKey: self pathNameRelative.

    "Created: / 14-01-2013 / 16:54:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isIgnored
    ^ self status isIgnored

    "Modified: / 23-10-2012 / 11:13:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isMissing
    ^ self status isMissing

    "Modified: / 23-10-2012 / 11:12:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isModified
    ^ self status isModified

    "Modified: / 23-10-2012 / 11:13:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isNotTracked
    ^ self status isNotTracked

    "Modified: / 23-10-2012 / 11:13:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isRemoved
    ^ self status isRemoved

    "Modified: / 23-10-2012 / 11:13:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isResolved
    "Return true, if the file had a conflict during merge or update
     and is marked as resolved."

    ^(wc mergeState at: self pathNameRelative) == $R

    "Created: / 14-01-2013 / 16:56:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isTracked
    | s |

    s := self status.
    ^s isNotTracked not and:[s isIgnored not and:[s isRemoved not]]

    "Created: / 15-11-2012 / 00:11:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isUnresolved
    "Return true, if the file had a conflict during merge or update
     and is marked as not yet resolved."

    ^(wc mergeState at: self pathNameRelative) == $U

    "Created: / 14-01-2013 / 16:56:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isUntracked
    "An alias for not-tracked"
    ^ self isNotTracked

    "Created: / 14-11-2012 / 23:56:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isUntrackedOrIgnored
    | s |

    s := self status.
    ^s isNotTracked or:[s isIgnored]

    "Created: / 15-11-2012 / 01:23:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isUnversioned
    "An alias for not-tracked"
    ^ self isNotTracked

    "Created: / 14-11-2012 / 23:56:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGWorkingCopyFile::LazyRevision methodsFor:'accessing'!

changeset
    ^changeset isHGChangeset 
        ifTrue:[changeset]
        ifFalse:[changeset := wc repository changesetWithId: changeset]

    "Created: / 22-01-2013 / 13:38:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changesetId
    ^changeset isHGChangesetId
        ifTrue:[changeset]
        ifFalse:[changeset id]

    "Created: / 22-01-2013 / 13:38:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGWorkingCopyFile::LazyRevision methodsFor:'error handling'!

doesNotUnderstand: aMessage
    (HGChangesetFile canUnderstand: aMessage selector) ifFalse:[
        ^ super doesNotUnderstand: aMessage
    ].
    self ensureNotLazy.
    ^aMessage sendTo: (collection at: index).

    "Created: / 22-01-2013 / 13:41:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGWorkingCopyFile::LazyRevision methodsFor:'initialization'!

setCollection: coll index: idx changesetId: csId workingCopy: workCopy path: p
    collection := coll.
    index := idx.
    changeset := csId.
    wc := workCopy.
    path := p.

    "Created: / 22-01-2013 / 13:32:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setPath: p
    path := p.

    "Created: / 22-01-2013 / 13:48:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGWorkingCopyFile::LazyRevision methodsFor:'private'!

ensureNotLazy
    | cs file renamed |

    index ~~ 1 ifTrue:[
        (collection at: index - 1) ensureNotLazy.
    ].

    cs := self changeset.
    file := cs / path.
    collection at: index put: file.
    index ~~ collection size ifTrue:[
        cs changes do:[:chg|
            "/Catch renames...
            (chg isCopied and:[chg path = path]) ifTrue:[
                renamed := chg source.
                index + 1 to: collection size do:[:i|
                    (collection at: i) setPath: renamed.
                ].
                ^self
            ]
        ].
    ].

    "Created: / 22-01-2013 / 13:48:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGWorkingCopyFile class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '§Id::                                                                                                                        §'
! !

