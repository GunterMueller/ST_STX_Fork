"
 COPYRIGHT (c) 1989 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

Collection subclass:#FileDirectory
	instanceVariableNames:'pathName lazy'
	classVariableNames:'PathOfCurrentDirectory'
	poolDictionaries:''
	category:'Compatibility-Squeak'
!

ArrayedCollection subclass:#DirectoryEntry
	instanceVariableNames:'name creationTime modificationTime dirFlag fileSize'
	classVariableNames:''
	poolDictionaries:''
	privateIn:FileDirectory
!

!FileDirectory class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1989 by Claus Gittinger
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
    Notice:
        This class is obsolete and does work only under UNIX. 
        Use Filename instead. It is left here for squeak compatibility.

        This class is not available in other ST-systems;
        in contrast, VisualWorks provides a Filename class.
        Therefore, Filename has taken over the functionality.

    FileDirectories represent directories in the underlying host system.
    They provide various methods to create/delete and query for files and/or
    directories. Also, since FileDirectory inherits from Collection, it
    provides all enumeration and testing protocol. For example, you can
    loop over the filenames in a directory using 'aFileDirectory do:[:nm | ...]'.

    [author:]
        Claus Gittinger

    [see also:]
        Filename
        FileStream DirectoryStream OperatingSystem
"
! !

!FileDirectory class methodsFor:'initialization'!

initialize
    "/
    "/ want to know about image restart
    "/
    ObjectMemory addDependent:self
!

update:something with:aParameter from:changedObject
    "/
    "/ currentDirectory may be different when restarted
    "/
    something == #earlySystemInstallation ifTrue:[
        PathOfCurrentDirectory := nil
    ]

    "Created: / 15.6.1996 / 15:20:21 / cg"
    "Modified: / 11.12.1998 / 16:28:40 / cg"
! !

!FileDirectory class methodsFor:'instance creation'!

currentDirectory
    "create and return a new FileDirectory for the current directory"

    "/ self obsoleteMethodWarning:'use Filename'.
    ^ self on:(Filename currentDirectory name)

    "
     FileDirectory currentDirectory contents
     FileDirectory currentDirectory files
     FileDirectory currentDirectory isReadable
     FileDirectory currentDirectory pathName
    "

    "Modified: / 20-08-2011 / 12:19:51 / cg"
!

directoryNamed:name
    "create and return a new FileDirectory for the directory
     with given pathname"

    "/ self obsoleteMethodWarning:'use Filename'.
    name asString = '.' ifTrue:[
        Filename currentDirectory name ~= '.' ifTrue:[
            ^ self currentDirectory
        ]
    ].
    ^ self on:(name asFilename constructString:'')

    "
     (FileDirectory directoryNamed:'..') pathName
     (FileDirectory directoryNamed:'../..') files
    "

    "Modified: / 20-08-2011 / 12:19:57 / cg"
!

directoryNamed:name in:aFileDirectory
    "create and return a new FileDirectory for the directory with given name
     in another FileDirectory"

    |baseName|

    "/ self obsoleteMethodWarning:'use Filename'.

    name asFilename isAbsolute ifTrue:[
        ^ self directoryNamed:name
    ].
    
    (aFileDirectory isKindOf:FileDirectory) ifTrue:[
        baseName := aFileDirectory pathName
    ] ifFalse:[
        baseName := aFileDirectory
    ].
    ^ self on:((Filename named:baseName) constructString:name)

    "Modified: / 28-04-1997 / 22:34:47 / dq"
    "Modified: / 20-08-2011 / 12:20:03 / cg"
!

on:aDirectoryPathName
    ^ (self basicNew) pathName:aDirectoryPathName

    "Created: / 20-08-2011 / 12:19:28 / cg"
!

rootDirectory
    "create and return a new FileDirectory for the root directory"

    "/ self obsoleteMethodWarning:'use Filename'.
    ^ self on:(Filename rootDirectory name)

    "
     FileDirectory rootDirectory contents
     FileDirectory rootDirectory files
     FileDirectory rootDirectory isReadable
    "

    "Modified: / 20-08-2011 / 12:20:09 / cg"
! !

!FileDirectory class methodsFor:'Compatibility-Squeak'!

default
    ^ (self basicNew) pathName:(Filename defaultDirectory name)
!

localNameFor:aFileNameString
    ^ aFileNameString asFilename baseName
!

pathNameDelimiter
    ^ Filename separator
!

slash
    ^ Filename separator asString

    "Created: / 20-08-2011 / 12:18:27 / cg"
! !

!FileDirectory class methodsFor:'private'!

fullPathNameOf:name in:path
    |sep|

    sep := OperatingSystem fileSeparator asString.

    "/ is it an absolute path ?

    (name startsWith:sep) ifTrue:[
        ^ name
    ].

    "/ temporary kludge; this and the previous should
    "/ go into OS isAbsolutePath ..

    OperatingSystem isMSDOSlike ifTrue:[
        ('[a-zA-Z]:*' match:name) ifTrue:[
            "/ drive spec ...
            ^ name
        ]
    ].                  
    ^ path , sep , name

    "Modified: 28.4.1997 / 22:06:17 / cg"
    "Modified: 28.4.1997 / 22:34:18 / dq"
! !

!FileDirectory methodsFor:'Compatibility-Squeak'!

assureExistence
    self asFilename recursiveMakeDirectory
!

containingDirectory
    ^ self class
        directoryNamed:(self asFilename directory pathName)
!

deleteDirectory:dirName
    "Squeak/ST80 compatibility"

    ^ self removeDirectory:dirName
!

deleteFileNamed:fileName
    "Squeak/ST80 compatibility"

    ^ self removeFile:fileName
!

directoryEntryFor:name
    |info|

    info := self infoOf:name.
    info isNil ifTrue:[
        info := (self filenameFor:name) linkInfo.
    ].
    ^ DirectoryEntry new
        name:name
        creationTime:(info creationTime)
        modificationTime:(info modificationTime)
        dirFlag:(info isDirectory)
        fileSize:(info isDirectory)

    "
     (FileDirectory directoryNamed:'.') entries
    "

    "Modified: / 29-08-2011 / 08:19:48 / cg"
!

directoryExists:dir
    "Squeak/ST80 compatibility"

    |f|

    f := self filenameFor:dir.
    ^ f exists and:[f isDirectory ].
!

directoryNames
    "Squeak/ST80 compatibility"

    ^ self directories
!

entries
    ^ self contents collect:[:nm | self directoryEntryFor:nm].
!

fileExists:dir
    "Squeak/ST80 compatibility"

    |f|

    f := self filenameFor:dir.
    ^ f exists and:[f isDirectory not ].
!

fileNames
    "Squeak/ST80 compatibility"

    ^ self files
!

forceNewFileNamed:fn
    "Squeak/ST80 compatibility"

    |f|

    f := self filenameFor:fn.
    ^ f writeStream
!

includesKey:name
    "Squeak/ST80 compatibility"

    ^ self exists:name
!

oldFileNamed:fn
    "Squeak/ST80 compatibility"

    |f|

    f := self filenameFor:fn.
    ^ f readStream
!

readOnlyFileNamed:fn
    "Squeak/ST80 compatibility"

    |f|

    f := self filenameFor:fn.
    ^ f readStream
!

recursiveDelete
    self asFilename recursiveRemove
! !

!FileDirectory methodsFor:'accessing'!

baseName
    "return my baseName
     - thats the directory name without leading parent-dirs"

    lazy ifTrue:[self getFullPathName].
    ^ pathName asFilename baseName
!

contents 
    "return a collection with all files and subdirectories in the receiver.
     Skips any '.' or '..' entries (UNIX)"

    |coll|

    coll := OrderedCollection new.
    self do:[:name |
        name ~= '.' ifTrue:[
            name ~= '..' ifTrue:[
                coll add:name
            ]
        ]
    ].
    coll sort.
    ^ coll

    "Modified: 20.6.1997 / 17:05:43 / cg"
!

directories
    "return a collection with all subdirectories in the receiver directory"

    |coll|

    coll := OrderedCollection new.
    self directoriesDo:[:name |
	coll add:name
    ].
    coll sort.
    ^ coll
!

directoryName
    "return my directoryName
     - thats the directory name where I'm in"

    lazy ifTrue:[self getFullPathName].
    ^ pathName asFilename directoryName
!

files
    "return a collection with all plain files in the receiver directory"

    |coll|

    coll := OrderedCollection new.
    self filesDo:[:name |
	coll add:name
    ].
    coll sort.
    ^ coll
!

pathName
    "return my full pathname"

    lazy ifTrue:[self getFullPathName].
    ^ pathName
!

pathName:dirName
    "set my pathname; return nil if not a valid path; self otherwise"

    pathName := dirName.
    (dirName startsWith:OperatingSystem fileSeparator) ifFalse:[
	lazy := true
    ] ifTrue:[
	(dirName startsWith:'./') ifFalse:[
"/        (dirName includes:$.) ifTrue:[
	    lazy := true
	]
    ].
    ^ self
! !

!FileDirectory methodsFor:'basic'!

createDirectory:newName
    "create a new filedirectory as a subdirectory of myself;
     return true if successful"

    |realName|

    (newName notNil and:[newName notEmpty]) ifTrue:[
	(newName ~= '.' and:[newName ~= '..']) ifTrue:[
	    ((newName at:1) == OperatingSystem fileSeparator) ifTrue:[
		realName := newName copyFrom:2
	    ] ifFalse:[
		realName := newName
	    ].
	    ^ (self filenameFor:realName) makeDirectory
	]
    ].
    ^ false
!

link:oldFileName to:newFileName
    "link oldFileName to newFileName in myself, return true if successful"

    |path1 path2|

    path1 := self pathNameOf:oldFileName.
    path2 := self pathNameOf:newFileName.
    ^ OperatingSystem linkFile:path1 to:path2
!

remove:aFileOrDirectoryName
    "remove the file or directory from myself; return true if successful"

    ^ (self filenameFor:aFileOrDirectoryName) remove
!

removeDirectory:dirName
    "remove the directory 'dirName' from myself; return true if successful.
     If the directory is not empty, the containing files/directories are also
     removed."

    ^ (self filenameFor:dirName) recursiveRemove
!

removeFile:fileName
    "remove the file 'fileName' from myself; return true if successful"

    ^ (self filenameFor:fileName) remove
!

renameFile:oldFileName newName:newFileName
    "rename the file; return true if successful"

    |f1 f2|

    f1 := self filenameFor:oldFileName.
    f2 := self filenameFor:newFileName.
    ^ f1 renameTo:f2
! !

!FileDirectory methodsFor:'converting'!

asFilename
    "return myself as a filename"

    ^ self pathName asFilename
!

asFilename:someFile
    "return a filename for a file named someFile in myself"

    ^ self asFilename construct:someFile
! !

!FileDirectory methodsFor:'enumerating'!

allDirectoriesDo:aBlock
    "evaluate the argument, aBlock for every directory name
     in the directory and in all subdirectories"

    |aStream command line|

    lazy ifTrue:[self getFullPathName].
    command := 'cd ' , pathName , '; find . -type d -print'.
    aStream := PipeStream readingFrom:command.
    aStream isNil ifTrue:[^ nil].
    [aStream atEnd] whileFalse:[
	line := aStream nextLine.
	line notNil ifTrue:[
	    (line = '.') ifFalse:[
		"cut off initial ./"
		line := line copyFrom:3
	    ].
	    aBlock value:line
	]
    ].
    aStream close
!

allFilesDo:aBlock
    "evaluate the argument, aBlock for every file name in the directory and in all
     subdirectories"

    |aStream command line|

    lazy ifTrue:[self getFullPathName].
    command := 'cd ' , pathName , '; find . -print'.
    aStream := PipeStream readingFrom:command.
    aStream isNil ifTrue:[^ nil].
    [aStream atEnd] whileFalse:[
	line := aStream nextLine.
	line notNil ifTrue:[
	    (line = '.') ifFalse:[
		"cut off initial ./"
		line := line copyFrom:3
	    ].
	    aBlock value:line
	]
    ].
    aStream close
!

directoriesDo:aBlock
    "evaluate the argument, aBlock for every subdirectory name in the directory"

    self where:[:name | (self isDirectory:name) ifTrue:[
			    ((name ~= '.') and:[name ~= '..'])
			] ifFalse:[
			    false
			]
	       ] do:aBlock
!

do:aBlock
    "evaluate the argument, aBlock for every name in the directory"

    self where:[:name | true] do:aBlock
!

filesDo:aBlock
    "evaluate the argument, aBlock for every plain file name in the directory"

    self where:[:name | (self isDirectory:name) not] do:aBlock
!

namesDo:aBlock
    "evaluate the argument, aBlock for every name in the directory.
     for ST-80 compatibility"

    self do:aBlock
!

where:testBlock do:aBlock
    "evaluate the argument, aBlock for every object in the directory
     for which testBlock evaluates to true."

    |aStream name|

    ExternalStream openErrorSignal catch:[
        aStream := DirectoryStream directoryNamed:pathName.
    ].
    aStream isNil ifTrue:[^ nil].
    [aStream atEnd] whileFalse:[
        name := aStream nextLine.
        name notNil ifTrue:[
            (testBlock value:name) ifTrue:[
                aBlock value:name
            ]
        ]
    ].
    aStream close
! !

!FileDirectory methodsFor:'instance creation'!

directoryNamed:aName
    "create & return a new fileDirectory for a subdirectory in myself"

    ^ self class directoryNamed:aName in:self pathName
! !

!FileDirectory methodsFor:'printing & storing'!

printOn:aStream
    "append a user printed representation of the receiver to aStream.
     The format is suitable for a human - not meant to be read back."

    lazy ifTrue:[self getFullPathName].
    aStream nextPutAll:'(a FileDirectory pathName:';
            nextPutAll:pathName;
            nextPutAll:')'
!

storeOn:aStream
    "append a printed representation of the receiver to aStream,
     which allows reconstructing it via readFrom:"

    lazy ifTrue:[self getFullPathName].
    aStream nextPutAll:'(FileDirectory directoryNamed:'.
    aStream nextPutAll:pathName.
    aStream nextPut:$)
! !

!FileDirectory methodsFor:'private'!

filenameFor:fileName
    "return a filename representing the argument, fileName
     either in myself (if the arg is a releative path) or absolute otherwise."

    ^ pathName asFilename filenameFor:fileName
!

fullNameFor:fileName
    "return a filename representing the argument, fileName
     either in myself (if the arg is a releative path) or absolute otherwise."

    ^ (pathName asFilename filenameFor:fileName) asAbsoluteFilename
!

getFullPathName
    "make my pathname be a full pathname - i.e. starting at root"

    |shortPathName|


    (pathName = OperatingSystem fileSeparator asString) ifTrue:[
	lazy := false.
	^ self
    ].

    "since currentDirectory is used very often, cache its path here"

    (pathName = '.') ifTrue:[
	PathOfCurrentDirectory notNil ifTrue:[
	    pathName := PathOfCurrentDirectory.
	    lazy := false.
	    ^ self
	]
    ].

    shortPathName := pathName.

    pathName := OperatingSystem pathNameOf:pathName.
    lazy := false.

    "
     if it was the current dir, keep name for next query
    "
    (shortPathName = '.') ifTrue:[
	PathOfCurrentDirectory := pathName
    ]
!

pathNameOf:fileName
    "return the pathname for an entry in myself"

    ^ (pathName asFilename construct:fileName) osName
! !

!FileDirectory methodsFor:'queries'!

accessModeOf:name
    "return the access-mode bits (rwxrwxrwx) of a file in myself"

    ^ OperatingSystem accessModeOf:(self pathNameOf:name)
!

changeAccessModeOf:name to:modeBits
    "set the access-mode bits (rwxrwxrwx) of a file in myself"

    ^ OperatingSystem changeAccessModeOf:(self pathNameOf:name) to:modeBits
!

exists
    "return true if this directory exists"

    ^ (Filename named:pathName) isDirectory

    "
     (FileDirectory directoryNamed:'fooBar') exists
     (FileDirectory directoryNamed:'/tmp') exists
    "
!

exists:name
    "return true, if the given name exists in myself"

    ^ (self filenameFor:name) exists
!

id
    "return the directories file-id (inode number)"

    ^ (Filename named:pathName) id
!

infoOf:name
    "return an array filled with file info for the file 'aFileName';
     return nil if such a file does not exist"

    ^ (self filenameFor:name) info
!

isDirectory:name
    "return true, if the given name is that of a directory in myself"

    ^ (self filenameFor:name) isDirectory
!

isExecutable:name
    "return true, if the given file is executable"

    ^ (self filenameFor:name) isExecutable
!

isReadable:name
    "return true, if the given file is readable"

    ^ (self filenameFor:name) isReadable
!

isWritable:name
    "return true, if the given file is readable"

    ^ (self filenameFor:name) isWritable
!

species
    "return the type of collection to be returned by collect, select etc."

    ^ OrderedCollection
!

timeOfLastChange
    "return the timeStamp of myself"

    ^ (Filename named:pathName) modificationTime
!

timeOfLastChange:name
    "return the timeStamp of a file in myself"

    ^ (self filenameFor:name) modificationTime
!

typeOf:name
    "return the symbolic type of a file in myself"

    ^ (self filenameFor:name) type
! !

!FileDirectory methodsFor:'testing'!

isEmpty
    "return true, if the directory is empty;
     redefined since '.' and '..' do not count as entries here."

    self do:[:fName |
	((fName ~= '.') and:[fName ~= '..']) ifTrue:[^ false].
    ].
    ^ true
! !

!FileDirectory::DirectoryEntry methodsFor:'accessing'!

at: index
    "compatibility interface"
    "self halt: 'old-style access to DirectoryEntry'"
    index = 1 ifTrue: [ ^self name ].
    index = 2 ifTrue: [ ^self creationTime ].
    index = 3 ifTrue: [ ^self modificationTime ].
    index = 4 ifTrue:[ ^self isDirectory ].
    index = 5 ifTrue:[ ^self fileSize ].
    self error: 'invalid index specified'.
!

creationTime
    ^ creationTime
!

dirFlag
    ^ dirFlag
!

fileSize
    ^ fileSize
!

modificationTime
    ^ modificationTime
!

name
    ^ name
!

name:nameArg creationTime:creationTimeArg modificationTime:modificationTimeArg dirFlag:dirFlagArg fileSize:fileSizeArg 
    name := nameArg.
    creationTime := creationTimeArg.
    modificationTime := modificationTimeArg.
    dirFlag := dirFlagArg.
    fileSize := fileSizeArg.
! !

!FileDirectory class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/FileDirectory.st,v 1.54 2013-08-16 11:49:12 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic/FileDirectory.st,v 1.54 2013-08-16 11:49:12 cg Exp $'
! !


FileDirectory initialize!
