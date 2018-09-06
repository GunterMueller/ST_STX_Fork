"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 1997 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic2' }"

"{ NameSpace: Smalltalk }"

Object subclass:#DirectoryContents
	instanceVariableNames:'directory timeStamp contents isReadable isRootDirectory accessKey'
	classVariableNames:'CachedDirectories LockSema ReadersList'
	poolDictionaries:''
	category:'System-Support'
!

Object subclass:#DirectoryContentsItem
	instanceVariableNames:'info fileName'
	classVariableNames:'CachedRemoteMountPoints CachedRemoteMountPointsTimeStamp'
	poolDictionaries:''
	privateIn:DirectoryContents
!

!DirectoryContents class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1997 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"


!

documentation
"
    DirectoryContents provides a cached view onto a fileDirectory.


    Notice:
        This class is not available in other ST-systems;
        Applications using it may not be portable.

    [author:]
        Claus Atzkern

    [see also:]
        Filename
        FileStream DirectoryStream OperatingSystem
"

! !

!DirectoryContents class methodsFor:'initialization'!

initialize
    "setup lock-mechanism
    "
    LockSema    := RecursionLock new.
    ReadersList := Dictionary new.
! !

!DirectoryContents class methodsFor:'instance creation'!

new
    ^ self basicNew initialize
! !

!DirectoryContents class methodsFor:'accessing'!

cachedDirectoryNamed:aFileOrString
    "answer the valid cached directory or nil"

    ^ self directoryAt:aFileOrString
!

directoryNamed:aDirectory
    "returns the DirectoryContents for a directory named 
     aDirectoryName, aString, nil or Filename
    "
    |directory contents lockRead pathName addToList|

    aDirectory isNil ifTrue:[^ nil].

    directory := aDirectory asFilename.
    directory exists ifFalse:[ ^ nil ].

    directory := directory asAbsoluteFilename.
    contents := nil.

    LockSema critical:[
        CachedDirectories notNil ifTrue:[
            "/ remove all obsolete directories - without doing a system call
            CachedDirectories := CachedDirectories select:[:aDir| aDir timeStamp notNil ].

            contents := self directoryAt:directory.

            contents isNil ifTrue:[
                |n max|

                max := self maxCachedDirectories.

                CachedDirectories size > max ifTrue:[
                    "/ remove directories with contents less 64 and not obsolete (system call)
                    CachedDirectories := CachedDirectories
                        select:[:aDir| (aDir size > 64 and:[aDir isObsolete not]) ].

                    n := CachedDirectories size + 2 - max.
                    n > 0 ifTrue:[
                        "/ remove oldest directories
                        CachedDirectories removeLast:n.
                    ].
                ].
            ].
        ].
        contents isNil ifTrue:[
            ReadersList isNil ifTrue:[ReadersList := Dictionary new].
            pathName := directory pathName.
            lockRead := ReadersList at:pathName ifAbsentPut:[Semaphore forMutualExclusion].
        ]
    ].
    contents notNil ifTrue:[^ contents].
    addToList := false.

    lockRead critical:[
        [  "/ test whether another task got the semaphore and
           "/ has read the directory contents
           (contents := self directoryAt:directory) isNil ifTrue:[
                "/ read the directory contents
                contents  := self new directory:directory.
                "/ only cache if the mod'Time is valid.
                addToList := contents timeStamp notNil.
            ]
        ] ensure:[
            LockSema critical:[
                addToList ifTrue:[
                    CachedDirectories isNil ifTrue:[
                        CachedDirectories := OrderedCollection new
                    ].
                    CachedDirectories add:contents
                ].
                (lockRead isEmpty and:[ReadersList notNil]) ifTrue:[
                    ReadersList removeKey:pathName ifAbsent:nil
                ]
            ]
        ]
    ].    

    ^ contents
! !

!DirectoryContents class methodsFor:'cache flushing'!

flushCache
    "flush list of remembered directory contents"

    LockSema critical:[ CachedDirectories := nil ].

    "
     self flushCache
    "

    "Created: / 11.2.2000 / 00:13:59 / cg"
!

flushCachedDirectoryFor:aDirectoryOrString
    "remove directory from cache
    "
    |directory|

    aDirectoryOrString isNil ifTrue:[^ self ].                   

    directory := aDirectoryOrString asFilename.
    directory isSymbolicLink ifTrue:[^ self].

    self
        directoryAt:directory
        checkForValidContentsDo:[:aDirectory| false ].  "/ should be removed from cache
!

lowSpaceCleanup
    "flush list of remembered directory contents when low on memory"

    self flushCache

    "
     self lowSpaceCleanup
    "

    "Created: / 18.2.1998 / 18:17:05 / cg"
    "Modified: / 24.9.1998 / 17:51:15 / cg"
! !

!DirectoryContents class methodsFor:'constants'!

maxCachedDirectories
    "returns number of maximum cached directories
    "
    ^ 20

    "Modified: / 25.2.1998 / 19:56:24 / cg"
! !

!DirectoryContents class methodsFor:'private'!

accessKeyForDirectory:aDirectoryOrString
    "computes a fast access key to retrieve the directory in the cache
    "
    |key last|
    
    aDirectoryOrString isNil ifTrue:[^ nil ].

    aDirectoryOrString isFilename ifTrue:[ key := aDirectoryOrString nameString ]
                                 ifFalse:[ key := aDirectoryOrString ].

    key size > 1 ifTrue:[
        last := key last.
        (last == $/ or:[last == $\]) ifTrue:[
            ^ key copyButLast:1.
        ].
    ].
    ^ key
!

directoryAt:aFileOrString
    "checks whether directory already exists and is valid.
     If true the directory is returned otherwise nil
    "
    ^ self
        directoryAt:aFileOrString
        checkForValidContentsDo:[:aContents| aContents isObsolete not ].
!

directoryAt:aFileOrString checkForValidContentsDo:checkIsValidBlock
    "answer the directoryContents stored under aFileOrString in the cache.
     If the evaluation of the checkIsValidBlock returns false, the contents
     will be removed from the cache and nil is returned."

    |index directory file fastKey|

    fastKey := self accessKeyForDirectory:aFileOrString.
    fastKey isNil ifTrue:[^ nil ].  "/ the name is nil

    directory := nil.

    LockSema critical:[
        CachedDirectories notNil ifTrue:[
            index := CachedDirectories findFirst:[:d| d accessKey = fastKey ].

            index == 0 ifTrue:[
                file  := aFileOrString asFilename asAbsoluteFilename.
                index := CachedDirectories findFirst:[:d| d directory = file ].
            ].

            index ~~ 0 ifTrue:[
                directory := CachedDirectories removeAtIndex:index.

                (checkIsValidBlock value:directory) ifTrue:[
                    "/ keep the last accessed directory at end
                    CachedDirectories add:directory.
                ] ifFalse:[
                    "/ validation block answers false - return nil and removed from cache
                    directory := nil.
                ].
            ].
        ].
    ].
    ^ directory
! !

!DirectoryContents class methodsFor:'queries'!

directoryNamed:aDirectoryName detect:aTwoArgBlock
    "evaluate the block, [:filename :isDirectory] on the directory
     contents of a directory named aDirectoryName, until the block
     returns true. If nothing detected false is returned
    "
    ^ self directoryNamed:aDirectoryName detect:aTwoArgBlock onOpenErrorDo:nil
!

directoryNamed:aDirectoryName detect:aTwoArgBlock onOpenErrorDo:exceptionBlock
    "evaluate the block, [:filename :isDirectory] on the directory
     contents of a directory named aDirectoryName, until the block
     returns true. If nothing detected false is returned.

     if the directory cannot be open, the exceptionBlock is processed
     with the filename.
    "
    |directory contents isReadable file|

    directory := aDirectoryName asFilename.
    contents  := self directoryAt:directory.

    contents notNil ifTrue:[
        (isReadable := contents isReadable) ifTrue:[
            contents contentsDo:[:aFile :isDir|
                (aTwoArgBlock value:aFile value:isDir) ifTrue:[^ true]
            ].
            ^ false.
        ].
    ] ifFalse:[
        (isReadable := directory exists) ifTrue:[
            [
                directory directoryContentsDo:[:fn |
                    file := directory construct:fn.
                    (aTwoArgBlock value:file value:(file isDirectory)) ifTrue:[
                        ^ true
                    ]
                ].
            ] on:(FileStream openErrorSignal, StreamIOError) do:[:ex|
                isReadable := false.
            ].
        ].
    ].
    (isReadable not and:[exceptionBlock notNil]) ifTrue:[
        exceptionBlock value:directory.
    ].
    ^ false
! !

!DirectoryContents class methodsFor:'startup & release'!

preSnapshot
    "flush list of cached directory contents before saving a snapshot
     (do not save them in the image)"

    self flushCache.
! !

!DirectoryContents class methodsFor:'utilities'!

contentsItemForFileName:aFilenameOrString 
    | aFilename directory directoryContents|

    aFilename := aFilenameOrString asFilename.
    directory := aFilename directory.

    directoryContents := self directoryAt:directory.

    directoryContents notNil ifTrue:[
        directoryContents itemsDo:[:fileItemThere |
            fileItemThere fileName = aFilename ifTrue:[
                ^ fileItemThere.
            ].
        ].
    ].

    aFilename exists ifFalse:[
        directoryContents notNil ifTrue:[ directoryContents beObsolete ].
        ^ nil
    ].
    ^ (DirectoryContentsItem new fileName:aFilename) info:aFilename info.
! !

!DirectoryContents methodsFor:'accessing'!

accessKey
    ^ accessKey
!

beObsolete
    "mark self as obsolete
     clear contents and reset time"

    |saveCont|

    timeStamp := nil.
    saveCont  := contents.
    contents  := #().

    saveCont notEmptyOrNil ifTrue:[
        "/ clear the info - if someone has a reference to the item
        saveCont do:[:eachItem | eachItem resetInfo ].
    ].
!

directory
    "returns the directoy name as Filename
    "
    ^ directory
!

modificationTime
    "get the last modification time of the directory.
     Note that sometimes a root directory does not return
     a valid modification time - so do not cache it."

    |modifyTime|

    timeStamp isNil ifTrue:[^ nil].

    modifyTime := directory modificationTime.
    modifyTime notNil ifTrue:[
        ^ modifyTime 
   ].

    isRootDirectory ifFalse:[
        "if it is not a root directory, assume that we have no access"
        isReadable := false.
        self beObsolete.
    ].
    ^ nil
!

timeStamp
    "get the last timeStamp (when the directory info was read) of the directory
    "
    ^ timeStamp
! !

!DirectoryContents methodsFor:'enumerating'!

contentsAndBaseNamesDo:aThreeArgBlock
    "evaluate the block on each file; the argument to the block is the
     filename, the baseName and true in case of a directory
     block arguments: [:fileName :aBaseName :isDirectory|
    "

    self itemsDo:[:eachItem |
        aThreeArgBlock 
            value:(eachItem fileName) 
            value:(eachItem baseName ) 
            value:(eachItem isDirectory)
    ].
!

contentsDo:aTwoArgBlock
    "evaluate the block on each file; the argument to the block is the
     filename and true in case of a directory
     block arguments: [:fileName :isDirectory|
    "

    self itemsDo:[:eachItem |
        aTwoArgBlock
            value:(eachItem fileName) 
            value:(eachItem isDirectory)
    ].
!

directoriesAndBasenamesDo:aTwoArgBlock
    "evaluate block on each directory; a Filename and Basename.
     The directories are sorted
    "

    self itemsDo:[:eachItem |
        eachItem isDirectory ifTrue:[
            aTwoArgBlock value:(eachItem fileName) value:(eachItem baseName)
        ]
    ]
!

directoriesDo:aOneArgBlock
    "evaluate block on each directory; a Filename. The directories are sorted
    "

    self itemsDo:[:eachItem |
        eachItem isDirectory ifTrue:[
            aOneArgBlock value:(eachItem fileName) 
        ]
    ].
!

filesAndBasenamesDo:aTwoArgBlock
    "evaluate block on each file; a Filename and a Basename.
     The files are sorted.
    "

    self itemsDo:[:eachItem |
        eachItem isDirectory ifFalse:[
            aTwoArgBlock value:(eachItem fileName) value:(eachItem baseName)
        ]
    ]
!

filesDo:aOneArgBlock
    "evaluate block on each file; a Filename. The files are sorted.
    "

    self itemsDo:[:eachItem |
        eachItem isDirectory ifFalse:[
            aOneArgBlock value:(eachItem fileName)
        ]
    ]
!

itemsDo:aBlock
    "evaluate the block on each contentsItem, which contains the fileName and type info"

    contents do:aBlock.
! !

!DirectoryContents methodsFor:'instance creation'!

directory:aFilename 
    |time stream linkInfo sourcePath|

    directory := aFilename asFilename.
    isRootDirectory := directory isRootDirectory.
    accessKey := self class accessKeyForDirectory:directory.
    contents := OrderedCollection new.
    isReadable := false.
    time := Timestamp now.
    [
        [
            stream := DirectoryStream 
                    directoryNamed:(directory osNameForDirectoryContents).

            stream notNil ifTrue:[
                [
                    (stream atEnd or:[ (linkInfo := stream nextLinkInfo) isNil ])
                ] whileFalse:[
                    sourcePath := linkInfo sourcePath.
                    (sourcePath = '.' or:[ sourcePath = '..' ]) ifFalse:[
                        |fitem|

                        fitem := DirectoryContentsItem new 
                                fileName:(directory construct:sourcePath)
                                linkInfo:linkInfo.
                        contents add:fitem.
                    ].
                ].
                isReadable := true.
            ].
        ] on:(FileStream openErrorSignal , StreamError) do:[:ex | isReadable := false. ].
    ] ensure:[
        stream notNil ifTrue:[
            stream close
        ].
        isReadable ifFalse:[
            contents := #()
        ].
    ].
    contents sort:[:a :b | a nameString < b nameString ].
    contents := contents asArray.
    timeStamp := time.
! !

!DirectoryContents methodsFor:'obsolete'!

updateContents
    <resource:#obsolete>

    "ensure that the file-info os present for every item
     ** obsolete - access info if required"

    "/    contents do:[:eachItem | eachItem updateInfo ].
! !

!DirectoryContents methodsFor:'printing'!

printOn:aStream
    aStream nextPutAll:'DirectoryContents of: '.
    aStream nextPutAll:(directory pathName).
! !

!DirectoryContents methodsFor:'queries'!

isObsolete
    "returns true if the directory contents represented by the receiver is obsolete
     (i.e. if the fileSystem's directory has been changed in the meanwhile)
    "
    |mt|

    timeStamp isNil ifTrue:[^ true].

    mt := self modificationTime.
    mt isNil ifTrue:[^ true ].

    "we compare only seconds, since the modification time is not as (millisecond) accurate as the timestamp"
    timeStamp getSeconds < mt getSeconds ifTrue:[
        self beObsolete.
        ^ true.
    ].
    ^ false
!

isReadable
    "answer true if the directory is readable
     no open error raised during reading the directory"

    ^ isReadable
!

isRootDirectory
    ^ isRootDirectory
!

size
    "get number of files including directories in the directory
    "
    ^ contents size
! !

!DirectoryContents methodsFor:'testing'!

includesIdentical:anItem
    ^ contents includesIdentical:anItem
!

isEmpty
    "returns true if directory is empty
    "
    ^ contents size == 0
!

isEmptyOrNil
    "return true if I am nil or an empty collection" 

    ^ contents size == 0

    "Modified (comment): / 17-08-2011 / 09:30:15 / cg"
!

notEmpty
    "returns true if directory is not empty
    "
    ^ contents size ~~ 0
!

notEmptyOrNil
    "returns true if directory is not empty
    "
    ^ contents size ~~ 0
! !

!DirectoryContents::DirectoryContentsItem class methodsFor:'instance creation'!

fileName:aFilename
    ^ self new fileName:aFilename.
! !

!DirectoryContents::DirectoryContentsItem methodsFor:'accessing'!

baseName
    ^ fileName baseName
!

fileName
    ^ fileName
!

fileName:something
    "set the value of the instance variable 'fileName' (automatically generated)"

    fileName := something.
!

fileName:aFilename linkInfo:aLinkInfo
    fileName := aFilename.

    (aLinkInfo notNil and:[aLinkInfo isValid])
        ifTrue:[self updateInfoFrom:aLinkInfo].
!

info
    info isNil ifTrue:[
        self updateInfo.
    ].
    info isSymbol ifTrue:[^ nil]. "/ a remote directory
    ^ info
!

info:something
    "set the value of the instance variable 'type' (automatically generated)"

    info := something.
!

nameString
    "raw access to nameString"

    ^ fileName nameString
!

type
    info isNil ifTrue:[
        self updateInfo.
    ].
    info isSymbol ifTrue:[^ info].
    ^ info type
! !

!DirectoryContents::DirectoryContentsItem methodsFor:'converting'!

asFilename

    ^fileName

    "Created: / 08-05-2012 / 15:15:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!DirectoryContents::DirectoryContentsItem methodsFor:'misc'!

cachedRemoteMountPoints
    |mountPoints now|

    mountPoints := CachedRemoteMountPoints.

    (mountPoints isNil
    or:[ CachedRemoteMountPointsTimeStamp isNil
    or:[ now := Timestamp now.
         (now secondDeltaFrom: CachedRemoteMountPointsTimeStamp) > 30 
    ]]) ifTrue:[
        CachedRemoteMountPointsTimeStamp := now.
        mountPoints := OperatingSystem mountPoints.
        mountPoints := mountPoints select:[:mp | mp isRemote].
        CachedRemoteMountPoints := mountPoints.
    ].

    ^ mountPoints.
!

resetAttributes
    "reset the attributes... done if I'am a normal file"

    (info isNil or:[info isSymbol]) ifTrue:[^ self ].

    self isDirectory ifFalse:[
        info := nil.
    ].
!

resetInfo
    info := nil.
!

updateInfo
    "ensure that the file-info is present
        DirectoryContents flushCache
    "
    info isNil ifTrue:[
        self updateInfoFrom:(fileName linkInfo).
    ].
!

updateInfoFrom:aLinkInfo
    "might be reused by updateLinkInfo"
    |mountPoint nameString linkName|

    info := aLinkInfo.

    (info notNil and:[info isSymbolicLink]) ifTrue:[
        OperatingSystem isMSWINDOWSlike ifFalse:[
            linkName := info path.

            linkName notNil ifTrue:[
                "have to check for both link and link target"
                mountPoint := self cachedRemoteMountPoints 
                            detect:[:mInfo | |p|
                                p := mInfo mountPointPath.
                                ((linkName startsWith:p) and:[ linkName startsWith:(p , '/') ])
                            ]
                            ifNone:nil.

                info := fileName info.  "get the info of the link target"   
            ].
        ].
    ] ifFalse:[
        "have to check for mountPoint only"
        nameString := fileName name.

        mountPoint := self cachedRemoteMountPoints 
                    detect:[:mInfo | mInfo mountPointPath = nameString ]
                    ifNone:nil.
    ].
    mountPoint notNil ifTrue:[
        info := #remoteDirectory.
    ] ifFalse:[
        info isNil ifTrue:[
            "/ broken symbolic link
            info := #symbolicLink.
        ]
    ].
! !

!DirectoryContents::DirectoryContentsItem methodsFor:'printing'!

printOn:aStream
    aStream nextPutAll:'DirectoryContentsItem for: '.
    fileName printOn:aStream.
! !

!DirectoryContents::DirectoryContentsItem methodsFor:'queries'!

isDirectory
    |t|

    t := self type.
    ^ (t == #directory or:[t == #remoteDirectory])
!

isRemoteDirectory
    ^ self type == #remoteDirectory
!

isSpecialFile
    |type|

    type := self type.

    ^ (type ~~ #directory
        and:[type ~~ #remoteDirectory
        and:[type ~~ #regular
        and:[type ~~ #symbolicLink
    ]]])
!

isSymbolicLink
    ^ self type == #symbolicLink
! !

!DirectoryContents class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


DirectoryContents initialize!
