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

Object subclass:#HGRepository
	instanceVariableNames:'uuid path wc changesets branches heads bookmarks bookmark config
		colors lock server'
	classVariableNames:'Cache UseCommandServer'
	poolDictionaries:''
	category:'SCM-Mercurial-Core'
!

HGRepositoryObject subclass:#Changesets
	instanceVariableNames:'changesets revno2nodeIdMap'
	classVariableNames:''
	poolDictionaries:''
	privateIn:HGRepository
!

!HGRepository class methodsFor:'documentation'!

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

!HGRepository class methodsFor:'initialization'!

flush
    "Flush all cached repositories"

    Cache := CacheDictionary new: 8

    "Created: / 25-01-2013 / 18:58:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initialize
    "Invoked at system start or when the class is dynamically loaded."

    | useCommandServer |

    Cache := CacheDictionary new: 8.

    useCommandServer := OperatingSystem getEnvironment: 'STX_LIBSCM_MERCURIAL_USE_COMMAND_SERVER'.
    useCommandServer isNil ifTrue:[
        UseCommandServer := false.  
    ] ifFalse:[
        UseCommandServer := (useCommandServer = '1').
    ]

    "Modified: / 09-03-2013 / 22:21:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGRepository class methodsFor:'instance creation'!

init: aStringOrFilename
    "Create a new repository in given directory and
     return HGRepository for it"

    | dir |

    dir := aStringOrFilename asFilename.
    dir exists ifTrue:[ 
        dir isDirectory ifTrue:[ 
            dir directoryContents notEmpty ifTrue:[ 
                HGRepositoryError raiseErrorString: 'Directory exists but not empty'.  
                ^ self.
            ].
        ] ifFalse:[ 
            HGRepositoryError raiseErrorString: 'Given path is not a directory'.
            ^ self.
        ].
    ].
    HGCommand init
        path: dir;
        execute.
    ^self on: dir.

    "Created: / 13-02-2014 / 12:38:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

on: aStringOrFilename
    ^self on: aStringOrFilename cached: false

    "Created: / 17-10-2012 / 13:30:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-12-2012 / 12:59:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

on: aStringOrFilename cached: cache
    | path |

    path := aStringOrFilename asFilename.
    ^cache ifTrue:[
        Cache at: path ifAbsentPut:[self new initializeOn: path]
    ] ifFalse:[
        self new initializeOn: path
    ]

    "Created: / 16-12-2012 / 12:58:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGRepository class methodsFor:'cloning'!

clone: aFilenameOrUrlOrString to: aStringOrFilename
    "Clones repository at given URL to given directory.
     Returns an instance HGRepository representing the clone."

    ^self clone: aFilenameOrUrlOrString to: aStringOrFilename update: true

    "Created: / 14-11-2012 / 22:46:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-11-2012 / 00:20:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 25-03-2016 / 17:27:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

clone: aFilenameOrUrlOrString to: aStringOrFilename update: update
    "Clones repository at given URL to given directory.
     Returns an instance HGRepository representing the clone."

    | url dst dir |

    url := aFilenameOrUrlOrString asString.
    dst := aStringOrFilename asFilename.

    dst exists ifTrue:[
        HGError raiseErrorString: 'Cannot clone to existsing directory!!'.
        ^nil
    ].
    dir := dst directory.
    dir exists ifFalse:[
        HGError raiseErrorString: 'Directory for clone does not exist!!'.
        ^nil
    ].
    dir isWritable ifFalse:[
        HGError raiseErrorString: 'Cannot clone into write-protected directory'.
        ^nil
    ].

    HGCommand clone
        url: url;
        path: dst pathName;
        update: update;
        execute.
    ^self on: dst.

    "Created: / 21-11-2012 / 00:20:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-02-2014 / 12:40:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

share: source to: destination
    "Shares repository at given source director to given desctination directory.
     Returns an instance HGRepository representing the shared repository."

     ^ self share: source to: destination update: true.

    "Created: / 25-08-2015 / 01:53:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

share: source to: destination update: update
    "Shares repository at given source director to given desctination directory.
     Returns an instance HGRepository representing the shared repository."

    | src dst dir |

    src := source asFilename.
    dst := destination asFilename.

    src exists ifFalse:[ 
        HGError raiseErrorString: 'Source repository does not exist!!'.
        ^nil
    ].
    src isDirectory ifFalse:[ 
        HGError raiseErrorString: 'Source repository is not a repository but file!!'.
        ^nil
    ].
    src isReadable ifFalse:[ 
        HGError raiseErrorString: 'Source repository is not readable!!'.
        ^nil
    ].
    (src / '.hg') isDirectory ifFalse:[ 
        HGError raiseErrorString: 'Source repository is not a valid Mercurial repository!!'.
        ^nil
    ].

    dst exists ifTrue:[
        HGError raiseErrorString: 'Cannot share to existsing directory!!'.
        ^nil
    ].
    dir := dst directory.
    dir exists ifFalse:[
        HGError raiseErrorString: 'Directory for share does not exist!!'.
        ^nil
    ].
    dir isWritable ifFalse:[
        HGError raiseErrorString: 'Cannot share into write-protected directory'.
        ^nil
    ].

    HGCommand share
        source: src pathName;
        destination: dst pathName;
        update: update;
        execute.
    ^self on: dst.

    "Created: / 25-08-2015 / 01:48:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGRepository class methodsFor:'utilities'!

discover: aStringOrFilename
    "Find a Mercurial repository in given directory or super-directories
     and return it (as an instance of Filename). If no repository is found, 
     returns nil.

     Currently, it searches for presence of .hg directory"

    | f |
    f := aStringOrFilename.
    f isDirectory ifFalse:[
        f := f directory
    ].
    [ ( f / '.hg' ) exists ] whileFalse:[
        f isRootDirectory ifTrue:[ ^nil ].
        f := f directory.
    ].
    ^f

    "Created: / 13-11-2012 / 22:34:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-11-2012 / 00:02:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

discoverPackage: packageId
    "Find a Mercurial repository in current package path for given package id.
     and return it (as an instance of Filename). If no repository is found, 
     returns nil."

    | pkg pkgDir i |

    pkg := packageId.
    [ pkg notNil ] whileTrue:[
        pkgDir := Smalltalk getPackageDirectoryForPackage: pkg.
        (pkgDir notNil and:[(HGRepository discover: pkgDir) notNil]) ifTrue:[
            ^self discover: pkgDir
        ].
        i := pkg lastIndexOf: $/.
        i == 0 ifTrue:[ i := pkg lastIndexOf: $: ].
        i > 1 ifTrue:[pkg := pkg copyTo: i - 1] ifFalse:[pkg := nil].
    ].
    ^nil

    "Modified: / 14-11-2012 / 00:02:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 04-07-2013 / 02:15:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGRepository methodsFor:'accessing'!

bookmark
    "Returns currently active bookmark or nil if none is active"

    | name |    

    bookmark isNil ifTrue:[
        bookmark := HGCachedFileData
                        on: ((Filename named: self pathName) / '.hg' / 'bookmarks.current')
                        reader:[:old :file |
                            | nm |

                            nm := nil.
                            file exists ifTrue:[ 
                                file readingFileDo:[:s| nm := s nextLine ].
                            ].
                            nm.
                        ].
        bookmark setData: nil
    ].
    name := bookmark value.
    name isNil ifTrue:[ ^ nil ].

    ^ self bookmarks detect:[:e | e name = name ].

    "Created: / 20-03-2014 / 17:31:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

bookmarks
    "Returns a list of bookmarks in the repository"

    bookmarks isNil ifTrue:[
        bookmarks := HGCachedFileData
                        on: self pathToHgBookmarks
                        reader:[:old :file |
                            | new newMap obsolete |

                            file exists ifTrue:[ 
                                file readingFileDo:[:s|
                                    new := (HGCommandParser on: s) parseDotHgBookmarks.
                                ].
                            ] ifFalse:[ 
                                new := #().
                            ].

                            newMap := Dictionary new.
                            new do:[:eachNew | 
                                newMap at: eachNew name put: eachNew
                            ].
                            obsolete := Set new.
                            "/ Iterate over existing bookmarks. If new set of bookmarks includes
                            "/ it, then update changeset and remove from new. If not, add it into
                            "/ obsolete.
                            old do:[:eachOld | 
                                | eachNew |

                                eachNew := newMap at: eachOld ifAbsent: nil.
                                eachNew notNil ifTrue:[ 
                                    eachOld setChangesetId: eachNew changesetId.
                                    new remove: eachNew.
                                ] ifFalse:[ 
                                    obsolete add: eachOld.
                                ].
                            ].
                            new do:[:b|b setRepository: self].
                            old removeAll: obsolete.
                            old addAll: new.
                            old.
                        ].
        bookmarks setData: OrderedCollection new.
    ].
    ^bookmarks value

    "Created: / 20-03-2014 / 02:13:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-08-2015 / 17:01:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

branches
    "Returns a list of named branches in the repository,
     including closed ones"

    branches isNil ifTrue:[
        branches := HGCachedFileData
                        on: self pathToHgStore00changelog_i
                        reader:[:old |
                            | rbranches current names |
                            rbranches := old.
                            current := self execute:
                                        (HGCommand branches
                                            workingDirectory: path pathName;
                                            active: false;
                                            closed: true;
                                            yourself).
                            names := rbranches collect:[:b|b name].
                            current := current ? #() reject:[:b|names includes: b name].
                            current do:[:b|b setRepository: self].
                            rbranches addAll: current.
                            rbranches isEmpty ifTrue:[
                                rbranches add: (HGBranch new setName: 'default'; setRepository: self).
                            ].
                            rbranches.
                        ].
        branches setData: OrderedCollection new.
    ].
    ^branches value

    "Created: / 27-11-2012 / 19:57:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-08-2015 / 16:56:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

config
    ^config

    "Created: / 06-12-2012 / 21:40:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

heads
    "Returns a list of heads (as HGChangeset)"

    heads isNil ifTrue:[
        heads := HGCachedFileData
                        on: self pathToHgStore00changelog_i
                        reader:[
                            | ids |

                            ids := self execute: HGCommand heads.
                            ids collect:[:id|self changesetWithId: id].
                        ].                                
    ].
    ^heads value.

    "Created: / 27-11-2012 / 21:33:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-08-2015 / 16:56:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

path
    "Return path to the repository (directory with .hg directory)"
    ^ path

    "Modified (comment): / 25-08-2015 / 16:46:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

pathName
    "Return path to the repository (directory with .hg store)"
    ^ path pathName

    "Created: / 16-11-2012 / 22:36:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

remoteDefault
    "Return default remote (upstream) repository or nil if none"

    ^self remotes detect:[:e|e isDefault] ifNone:[nil]

    "Created: / 10-12-2012 / 01:26:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

remotes
    "Returns a collection of configured remote (upstream) repositories"

    | paths remotes |

    paths := self config get: #paths default: nil.
    paths isNil ifTrue:[ ^ #() ].
    paths isEmpty ifTrue:[ ^ #() ].
    remotes := OrderedCollection new.
    paths keysAndValuesDo:[:name :url|
        remotes add: (HGRemote new setRepository: self; setName: name url:url value).
    ].
    ^remotes

    "Created: / 09-12-2012 / 22:51:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

uuid
    "Returns unique ID identifing this concrete instance
     of a repository"

    ^ uuid

    "Modified (comment): / 14-11-2012 / 23:22:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

workingCopy
    wc isNil ifTrue:[
	wc := HGWorkingCopy new setRepository: self.
    ].
    ^wc

    "Created: / 19-10-2012 / 15:42:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGRepository methodsFor:'accessing-changesets'!

@ id
    ^self changesetWithId: id.

    "Created: / 16-11-2012 / 20:29:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changesetWithId: id
    ^changesets changesetWithId: id

    "Created: / 13-11-2012 / 17:58:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changesetsMatching: revset
    "Returns a list of changesets that matches given revset, but not more than
     `limit` changesets.

    revset could be either HGRevset or plain string.
    "
    ^self changesetsMatching: revset limit: nil

    "Created: / 03-06-2015 / 06:57:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changesetsMatching: revset limit: limit
    "Returns a list of changesets that matches given revset, but not more than
     `limit` changesets.

    revset could be either HGRevset or plain string.
    limit is an integer or nil for no limit at all (use with caution
    on large repositories this may take a while)
    "
    ^changesets changesetsMatching: revset limit: limit

    "Created: / 07-02-2014 / 13:08:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 03-06-2015 / 06:52:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGRepository methodsFor:'accessing-private'!

branchWithName: name 
    "Returns branch with given name. If there is no such branch,
     an exception is raised"

    ^self branchWithName: name ifAbsent:[
        HGNoSuchBranchError newException
            parameter: name;
            messageText: 'No such branch: ', name;
            raiseSignal
    ]

    "Created: / 27-11-2012 / 13:55:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

branchWithName: name createIfAbsent: create

    ^self branchWithName: name ifAbsent:[
        | b |
        b := HGBranch new setRepository: self.
        b setName: name.
        branches value add: b.
        b
    ]

    "Created: / 10-12-2012 / 03:14:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-02-2013 / 13:39:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

branchWithName: name ifAbsent: block

    ^self branches detect:[:b|b name = name] ifNone: block

    "Created: / 27-11-2012 / 14:31:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changesetWithId: id into: cs
    ^changesets load: id into: cs

    "Created: / 16-12-2012 / 01:26:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-01-2013 / 20:56:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

lock
    ^lock

    "Created: / 16-12-2012 / 00:39:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

pathToHgBookmarks
    "Return path to the repository .hg/bookmarks directory (as Filename)"

    | dotHg shared |

    dotHg := path / '.hg'.
    [ 
        shared := dotHg / 'shared'.
        shared exists and:[ shared contents includes: 'bookmarks;' ]
    ] whileTrue:[ 
        dotHg := (dotHg / 'sharedpath') contents asString trimSeparators asFilename          
    ].
    ^dotHg / 'bookmarks'

    "Created: / 25-08-2015 / 16:57:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

pathToHgStore
    "Return path to the repository .hg/store directory (as Filename)"

    | dotHg sharedpathLink |

    "/ Check for shared repositories...

    dotHg := path / '.hg'.
    [ 
        sharedpathLink := dotHg / 'sharedpath'.
        sharedpathLink exists 
    ] whileTrue:[ 
        dotHg := sharedpathLink contents asString trimSeparators asFilename
    ].
    ^ dotHg / 'store'

    "Created: / 25-08-2015 / 16:56:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

pathToHgStore00changelog_i
    "Return path to the repository .hg/store/00changelog.i directory (as Filename)"

    ^ self pathToHgStore  / '00changelog.i'

    "Created: / 25-08-2015 / 16:56:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGRepository methodsFor:'initialize & release'!

initializeOn: aStringOrFilename
    | p |

    p := aStringOrFilename asFilename.
    p exists ifFalse:[
        HGRepositoryError raiseSignal: 'Given path does not exists'.
        ^nil.
    ].
    p isDirectory ifFalse:[
        HGRepositoryError raiseSignal: 'Given path is not a directory'.
        ^nil.
    ].
    (p / '.hg') isDirectory ifFalse:[
        HGRepositoryError raiseSignal: 'Given path does not contain a repository (.hg subdir not found - try use #lookup:)'.
        ^nil.
    ].
    path := p.
    changesets := HGRepository::Changesets new setRepository: self.
    uuid := UUID new.
    config := HGConfig new setRepository: self.
"/    colors := HGColorLibrary new.
    lock := RecursionLock new.

    "Created: / 17-10-2012 / 13:35:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 24-03-2014 / 12:42:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGRepository methodsFor:'inspecting'!

inspector2TabContentsView
    <inspector2Tab>

    ^ wc inspector2TabContentsView

    "Created: / 12-06-2015 / 10:36:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGRepository methodsFor:'operations'!

cloneTo: aStringOrFilename
    "Creates a clone of the receiver into given directory.
     Returns an instance HGRepository representing the clone."

    ^self class clone: path to: aStringOrFilename

    "Created: / 14-11-2012 / 22:43:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

cloneTo: aStringOrFilename update: update
    "Creates a clone of the receiver into given directory.
     Returns an instance HGRepository representing the clone.
     If update is true, repository working copy is updated, otherwise
     it's left empty"

    ^self class clone: path to: aStringOrFilename update: update

    "Created: / 21-11-2012 / 00:21:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

execute: anHGCommand
    | value |    
    anHGCommand workingDirectoryOrNil isNil ifTrue:[
        anHGCommand workingDirectory: path
    ].

    "The command server does not work on Windows because readWait is
     broken on Windows!!"
    (UseCommandServer and:[OperatingSystem isMSWINDOWSlike not]) ifTrue:[
        server isNil ifTrue:[
            server := HGCommandServer new repository: self.
            server start.
        ].
        value := server execute: anHGCommand
    ] ifFalse:[
        value := anHGCommand execute
    ].
    "/ Flush caches. Theoretically this is not needed but file modification
    "/ detection in HGCachedFileData is not accurate. Here we know something
    "/ changed so better flush caches to avoid false hits.
    anHGCommand modifiesRepository ifTrue:[
        bookmark notNil ifTrue:[ bookmark flush ].
        bookmarks notNil ifTrue:[ bookmarks flush ].
        branches notNil ifTrue:[ branches flush ].
        heads notNil ifTrue:[ heads flush ].
    ].
    ^ value.

    "Created: / 03-03-2013 / 22:52:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-10-2015 / 07:32:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

log: revset limit: limit
    "Returns a list of changesets that matches given revset, but not more than
     `limit` changesets.

    revset could be either HGRevset or plain string.
    limit is an integer or nil for not limit at all (use with caution
    on large repositories this may take a while)
    "
    ^ self changesetsMatching: revset limit: limit

    "Created: / 07-02-2014 / 13:08:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 20-03-2014 / 09:02:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

pull
    "Pulls changesets from default upstream repository.
     See .hg/hgrc, section path"

    ^self pull: nil

    "Created: / 15-11-2012 / 10:00:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-02-2013 / 15:31:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

pull: remote
    "Push changesets to given remote repository. 'remote' can be either 
     an instance HGRemote, an instance of URL or a String (remote alias). 
     If 'remote' nil, default upstream repository is used, ' 

    See .hg/hgrc, section for configured aliases"

    ^self execute: 
        (HGCommand pull
            url: (remote ? 'default') asString;
            yourself)

    "Created: / 04-02-2013 / 15:30:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-03-2013 / 22:53:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

push
    "Pushes changesets to default upstream repository.
     See .hg/hgrc, section path"

    ^self push: nil force: false

    "Created: / 15-11-2012 / 09:59:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-11-2012 / 21:58:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

push: remote
    "Push changesets to given remote repository. 'remote' can be either 
     an instance HGRemote, an instance of URL or a String (remote alias). 
     If 'remote' nil, default upstream repository is used, ' 

    See .hg/hgrc, section for configured aliases"

    ^self push: remote force: false

    "Created: / 15-11-2012 / 10:00:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-11-2012 / 21:59:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 04-02-2013 / 15:31:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

push: remote force: force
    "Push changesets to given remote repository. 'remote' can be either 
     an instance HGRemote, an instance of URL or a String (remote alias)'  
     If force is true, push is forced (allowing creation
     of new heads in remote repo),

     See .hg/hgrc, section path"

    ^self execute:
        (HGCommand push
            workingDirectory: path pathName;
            url: (remote ? 'default') asString;
            force: force;
            yourself)

    "Created: / 27-11-2012 / 21:58:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-03-2013 / 22:54:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

shareTo: aStringOrFilename
    "Creates a shared repository of the receiver into given directory.
     Returns an instance HGRepository representing the shared repository."
    ^ self shareTo: aStringOrFilename update: true

    "Created: / 25-08-2015 / 13:12:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

shareTo: aStringOrFilename update: update
    "Creates a shared repository of the receiver into given directory.
     Returns an instance HGRepository representing the shared repository.
     If update is true, repository working copy is updated, otherwise
     it's left empty"

    ^self class share: path to: aStringOrFilename update: update

    "Created: / 25-08-2015 / 01:54:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGRepository methodsFor:'operations-private'!

bookmark: changesetOrChangesetIdOrNil as: name
    "Sets bookmark named `name` on `changesetOrChangesetIdOrNil` and return it.
     If `changesetOrChangesetIdOrNil` is nil then bookmark is created on
     working copy parent and made active.

     Raises an HGBookmarkError error if such bookmark already exists."

    self bookmarks do:[:each | 
        each name = name ifTrue:[ 
            HGBookmarkError newException
                messageText: ('Bookmark ''%1'' already exists (remove it first and then set it again)' bindWith: name);
                raise.
            ^ self.
        ].
    ].

    self execute:
        (HGCommand bookmark
            workingDirectory: path pathName;
            revision: (changesetOrChangesetIdOrNil notNil ifTrue:[changesetOrChangesetIdOrNil asHGChangesetId] ifFalse:[ nil ]);
            name: name;
            yourself).

    "Created: / 20-03-2014 / 09:21:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-03-2014 / 21:52:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

bookmarkDelete: anHGBookmark
    self execute:
        (HGCommand bookmark_delete
            workingDirectory: self pathName;
            name: anHGBookmark name;
            yourself).

    "Created: / 21-03-2014 / 01:24:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-03-2014 / 21:52:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGRepository methodsFor:'synchronized evaluation'!

synchronizationSemaphore
    ^lock

    "Created: / 16-12-2012 / 00:40:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

synchronizationSemaphore: aRecursionLock
    lock := aRecursionLock

    "Created: / 16-12-2012 / 00:40:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGRepository methodsFor:'testing'!

hasExtension: extension
    "Return true, if the repository has `extension` enabled, false otherwise"

    | extensions value |

    extensions := self config get: 'extensions' default: nil.
    extensions notNil ifTrue:[ 
        value := extensions get: extension default: 0.
        value ~~ 0 ifTrue:[ 
            ^value isEmptyOrNil or:[ value asFilename exists ]
        ].
    ].
    ^ false

    "
    (HGRepository on: (Smalltalk getPackageDirectoryForPackage: #'stx:libscm')) hasExtension: 'evolve'
    "

    "Created: / 16-03-2016 / 23:56:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hasExtensionEvolve
    "Return true, if evolve extension is enabled on the receiver"

    ^ self hasExtension:'evolve'

    "Created: / 16-03-2016 / 23:57:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isShared
    "Return true, if this repository is shared, i.e., created by means
     of `hg share`"

    ^ (path / '.hg' / 'sharedpath') exists

    "Created: / 25-08-2015 / 13:08:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGRepository::Changesets class methodsFor:'documentation'!

documentation
"
    A simple object to maintain and load changesets metadata lazily.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!HGRepository::Changesets class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!HGRepository::Changesets methodsFor:'accessing'!

changesetWithId: idobj
    | id xid cs |

    id := idobj asHGChangesetId.
    id = HGChangesetId null ifTrue:[ ^ HGChangeset null].
    "/Try to translate it...
    id hasRevnoOnly ifTrue:[
        xid := revno2nodeIdMap at: id revno ifAbsent:[nil].
    ].
    xid := xid ? id.


    "/Look in cache using xlated id...
    cs := changesets at: xid ifAbsent:[ nil ].
    cs notNil ifTrue: [ ^ cs ].

    self synchronized:[
        "/Look in cache using xlated id...
        cs := changesets at: xid ifAbsent:[ nil ].
        cs notNil ifTrue: [ ^ cs ].

        cs := (xid isFull and:[xid hasRevno]) ifTrue:[
                    "/Full id, can make it lazy
                    HGChangeset new setId: xid; setRepository: repository
                ] ifFalse:[
                    "/Short id, we have to load it
                    self load: xid into: nil
                ].

        self assert: cs id isFull.
        self assert: cs id hasRevno.
        changesets at: cs id put: cs.
        revno2nodeIdMap  at: cs id revno put: cs id.
    ].
    ^cs .

    "Created: / 13-11-2012 / 17:52:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 08-03-2013 / 19:54:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changesetsMatching: revset limit: limit
    | csets |

    csets := self repository execute:
                    (HGCommand log
                        workingDirectory: repository path asString;
                        revset: revset;
                        limit: limit; 
                        yourself).
    csets := csets collect:[ :cset |
        | existing |

        cset setRepository: repository.  
        existing := changesets at: cset id ifAbsent:[ nil ].
        existing isNil ifTrue:[ 
            cset setRepository: repository .
            changesets at: cset id put: cset. 
            revno2nodeIdMap at: cset id revno put: cset id.
            cset
        ] ifFalse:[ 
            existing.
        ].

    ].
    ^ csets

    "Created: / 07-02-2014 / 13:11:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-03-2014 / 01:37:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGRepository::Changesets methodsFor:'initialization'!

initialize
    "Invoked when a new instance is created."

    "/ please change as required (and remove this comment)
    changesets := Dictionary new.
    revno2nodeIdMap := Dictionary new.

    "/ super initialize.   -- commented since inherited method does nothing

    "Modified: / 16-11-2012 / 21:58:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGRepository::Changesets methodsFor:'private'!

load: id into: changesetOrNil
    "Load all data for changeset with given id.
     If changesetOrNil is not nil, then update given
     changeset.

     Return changeset with filled data, i.e,, changeset is
     non-lazy"

     | csets cs |
     csets := repository execute:
                    (HGCommand log
                        workingDirectory: repository path asString;
                        revsets: (self loadRevsetsForLoad: id);
                        hidden: true; "/ Hidden changeset are supported since 2.5, but
                                      "/ the HGCommand::log cares of this itself, so it's
                                      "/ safe to pass true here.
                        yourself).
     "/just to be defensive...
     csets do:[:each| 
        | existing |

        each setRepository: repository.
        existing := changesets at: each id ifAbsentPut:[each].
        existing ~~ each ifTrue:[
            existing setSlotsFrom: each.
            existing setNonLazy.
            self assert: existing id isShort not.
            self assert: existing id revno notNil.
            self assert: existing loaded.
        ].
        existing id = id ifTrue:[
            cs := existing
        ].
    ].
    self assert: cs notNil.
    ^cs

    "Created: / 16-12-2012 / 00:57:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-03-2016 / 17:26:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

loadRevsetsForLoad: id
    | revsets ids start stop addId |

    revsets := OrderedCollection new.
    ids := changesets keys asOrderedCollection sort: [:a :b|a revno > b revno].
    addId := true.
    ids do:[:each| | cs |        
        cs := changesets at: each.
        cs loaded ifFalse:[
            start isNil ifTrue:[
                start := stop := each.
                each = id ifTrue:[
                    addId := false
                ].
            ] ifFalse:[
                each revno < (start revno - 20) ifTrue:[
                    revsets add: (start revno printString , ':' , (start revno - 20) printString).
                    start := stop := each.
                ] ifFalse:[
                    each = id ifTrue:[
                        addId := false
                    ].
                    stop := each.
                ].
            ]
        ] ifTrue:[
            start notNil ifTrue:[
                start ~~ stop ifTrue:[
                    revsets add: (start revno printString , ':' , stop revno printString).
                ] ifFalse:[
                    revsets add: start revno printString
                ].
            ].
            start := stop := nil.
        ]
    ].
    start notNil ifTrue:[
        start ~~ stop ifTrue:[
            revsets add: (start revno printString , ':' , stop revno printString).
        ] ifFalse:[
            revsets add: start revno printString
        ].
    ].
    (addId or:[revsets isEmpty]) ifTrue:[revsets add: id printString].
    ^revsets

    "Created: / 22-01-2013 / 16:41:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-03-2013 / 23:59:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGRepository class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id::                                                                                                                        '
! !


HGRepository initialize!
