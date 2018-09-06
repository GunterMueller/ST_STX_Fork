"
 COPYRIGHT (c) 2011 by Claus Gittinger
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic3' }"

"{ NameSpace: Smalltalk }"

AbstractSourceCodeManager subclass:#FileBasedSourceCodeManager
	instanceVariableNames:''
	classVariableNames:'Verbose RepositoryPath ModulePathes'
	poolDictionaries:''
	category:'System-SourceCodeManagement'
!

!FileBasedSourceCodeManager class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2011 by Claus Gittinger
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
    A simple file based sourceCodeManager, which saves versions in a local directory.
    Versions will be stored as filename.st.vNr (i.e. Foo.st.1, Foo.st.2, etc.)

    This is more an example of the protocol which needs to be implemented,
    than a real manager (although it may be useful for tiny private projects or classroom examples)

    [author:]
        Claus Gittinger
"
! !

!FileBasedSourceCodeManager class methodsFor:'accessing'!

getRepositoryPathForModule:aModuleName
    "internal: used when accessing a source repository.
     Return the path to the top directory for a particular module.
     If no specific path was defined for that module, return the value of
     the global (fallBack) repositoryPath.
     Nil is returned if no repository is available."

    ModulePathes isNil ifTrue:[^ RepositoryPath].
    aModuleName isNil ifTrue:[^ RepositoryPath].
    ^ ModulePathes at:aModuleName ifAbsent:RepositoryPath.

    "Modified: / 20-05-1998 / 16:30:12 / cg"
    "Created: / 21-12-2011 / 23:05:51 / cg"
!

knownModules
    "return the modules, we currently know"

    ModulePathes isEmptyOrNil ifTrue:[^ #() ].
    ^ ModulePathes keys

    "Modified: / 26-12-2011 / 00:49:10 / cg"
!

repositoryInfoPerModule
    "return the dictionary, which associates repository paths to module names.
     If no entry is contained in this dictionary for some module,
     the default path will be used."

    ^ ModulePathes ? #()

    "Created: / 22-12-2011 / 00:35:32 / cg"
!

repositoryInfoPerModule:aDictionary
    "set the dictionary, which associates repository paths to module names.
     If no entry is contained in this dictionary for some module,
     the default path will be used."

    ModulePathes := aDictionary

    "Created: / 22-12-2011 / 00:34:52 / cg"
!

repositoryPath
    "return the path of the default repository"

    ^ RepositoryPath

    "Created: / 21-12-2011 / 14:55:12 / cg"
!

repositoryPath:aPath
    "set the path of the default repository"

    RepositoryPath := aPath

    "Created: / 22-12-2011 / 00:30:19 / cg"
! !

!FileBasedSourceCodeManager class methodsFor:'queries'!

defaultRepositoryPath
    ^ './repository'

    "Created: / 21-12-2011 / 23:59:52 / cg"
!

enabled
    ^ true "/ false.

    "Created: / 21-12-2011 / 17:53:34 / cg"
!

isContainerBased
    "true, if the SCM uses some kind of source container (,v files).
     False, if it is like a database or filesystem."

    ^ false

    "Created: / 21-12-2011 / 18:53:55 / cg"
!

isResponsibleForPackage:aString
    ^ true.

    "Created: / 09-07-2011 / 14:32:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 22-12-2011 / 00:05:54 / cg"
!

managerTypeName
    ^ 'FileRepository'

    "Created: / 16-08-2006 / 11:05:56 / cg"
!

nameOfVersionMethodForExtensions
    ^ #'extensionsVersion_FileRepository'

    "Modified: / 21-12-2011 / 13:02:45 / cg"
!

nameOfVersionMethodInClasses
    ^ #'version_FileRepository'

    "Modified: / 21-12-2011 / 13:02:52 / cg"
!

repositoryNameForPackage:packageId 
    "superclass AbstractSourceCodeManager class says that I am responsible to implement this method"

    ^ self getRepositoryPathForModule:(packageId upTo:$: )

    "Created: / 21-12-2011 / 23:07:02 / cg"
!

settingsApplicationClass
    "link to my settings application (needed for the settings dialog"

    ^ FileBasedSourceCodeManagementSettingsAppl

    "Created: / 19-04-2011 / 12:43:29 / cg"
    "Modified: / 21-12-2011 / 13:02:58 / cg"
!

supportsCheckinLogMessages
    "no, log-messages are not supported (I am too stupid)"

    ^ false

    "Created: / 21-12-2011 / 18:02:42 / cg"
! !

!FileBasedSourceCodeManager class methodsFor:'saving'!

savePreferencesOn:aStream
    aStream nextPutLine:'FileBasedSourceCodeManager notNil ifTrue:['.
    self repositoryInfoPerModule notEmptyOrNil ifTrue:[
        aStream nextPutLine:'    FileBasedSourceCodeManager repositoryInfoPerModule:' , self repositoryInfoPerModule storeString , '.'.
    ].
    (Smalltalk at:#SourceCodeManager) == self ifTrue:[
        aStream nextPutLine:'    Smalltalk at:#SourceCodeManager put:FileBasedSourceCodeManager.'.
    ].
    aStream nextPutLine:'    FileBasedSourceCodeManager repositoryPath:' , self repositoryPath storeString , '.'.
    aStream nextPutLine:'].'.

    "Created: / 09-11-2006 / 15:09:25 / cg"
    "Modified: / 22-12-2011 / 00:46:29 / cg"
! !

!FileBasedSourceCodeManager class methodsFor:'source code administration'!

checkForExistingContainer:fileName inModule:moduleName directory:dirName
    ^ self checkForExistingModule:moduleName directory:dirName

    "Created: / 21-12-2011 / 17:56:23 / cg"
!

checkForExistingModule:moduleDir
    "check for a package directory to be present"

    |dir|

    dir := self moduleDirectoryFor:moduleDir.
    ^ dir exists

    "Created: / 21-12-2011 / 18:37:28 / cg"
!

checkForExistingModule:moduleDir directory:packageDir
    "check for a package directory to be present"

    |dir|

    dir := self packageDirectoryForModule:moduleDir package:packageDir.
    ^ dir exists

    "Created: / 21-12-2011 / 18:03:33 / cg"
!

checkinClass:aClass fileName:classFileName directory:packageDir module:moduleDir source:sourceFile logMessage:logMessage force:force
    "Return true if ok, false if not."

    |targetDir newestRevision newRevision newFile packageMode filter outStream|

    targetDir := self packageDirectoryForModule:moduleDir package:packageDir.
    targetDir exists ifFalse:[
        targetDir recursiveMakeDirectory
    ].
    (targetDir filesMatching:(classFileName,'_*')) do:[:eachVersionFile |
        |versionString|

        versionString := eachVersionFile copyFrom:(classFileName size + 2).
        (newestRevision isNil 
        or:[ self isRevision:versionString after:newestRevision ]) ifTrue:[
            newestRevision := versionString
        ].
    ].

    newestRevision isNil ifTrue:[
        newRevision := '1'
    ] ifFalse:[
        newRevision := self revisionAfter:newestRevision
    ].
    newFile := (targetDir construct:classFileName,'_',newRevision printString).

    self updateVersionMethodOf:aClass for:(self revisionStringFor:aClass inModule:moduleDir directory:packageDir container:classFileName revision:newRevision).

    packageMode := self checkMethodPackagesOf:aClass.
    packageMode == #base ifTrue:[
        filter := [:mthd | mthd package == aClass package].
    ].

    [
        outStream := newFile writeStream.
    ] on:FileStream openErrorSignal do:[:ex|
        self reportError:('fileout failed').
        ^ false
    ].

    Method flushSourceStreamCache.
    Class fileOutErrorSignal handle:[:ex |
        outStream close.
        newFile delete.
        self reportError:('fileout failed (',ex description,')').
        ^ false
    ] do:[
        self 
            fileOutSourceCodeOf:aClass 
            on:outStream 
            withTimeStamp:false 
            withInitialize:true 
            withDefinition:true
            methodFilter:filter.
    ].
    outStream close.

    newFile exists ifFalse:[
        self reportError:'fileout failed'.
        ^ false.
    ].

    ^ true

    "Created: / 21-12-2011 / 19:01:07 / cg"
!

createModule:moduleDir
    "create a module directory"

    |dir|

    dir := self moduleDirectoryFor:moduleDir.
    dir recursiveMakeDirectory.
    ^ dir exists.

    "Created: / 21-12-2011 / 18:38:22 / cg"
!

createModule:moduleDir directory:packageDir
    "create a package directory"

    |dir|

    dir := self packageDirectoryForModule:moduleDir package:packageDir.
    dir recursiveMakeDirectory.
    ^ dir exists.

    "Created: / 21-12-2011 / 18:44:20 / cg"
!

initialRevisionStringFor:aClass inModule:moduleDir directory:packageDir container:fileName
    "return a string usable as initial revision string"

    ^ self 
        revisionStringFor:aClass 
        inModule:moduleDir 
        directory:packageDir 
        container:fileName 
        revision:'1'

    "Created: / 21-12-2011 / 18:14:03 / cg"
!

moduleDirectoryFor:moduleDir
    "a modules directory as filename"

    |root|

    root := self getRepositoryPathForModule:moduleDir.
    root isNil ifTrue:[
        RepositoryPath := root := './versions'.
    ].

    ^ (root asFilename construct:moduleDir)

    "Created: / 21-12-2011 / 18:38:38 / cg"
!

packageDirectoryForModule:moduleDir package:package
    "a packages directory as filename"

    |dir|

    dir := self moduleDirectoryFor:moduleDir.
    ^ dir construct:package

    "Created: / 21-12-2011 / 18:43:27 / cg"
!

revisionInfoFromString:aString 
    "{ Pragma: +optSpace }"

    "return a VersionInfo object filled with revision info.
     This extracts the relevant info from aString."

    ^ self revisionInfoFromStandardVersionString:aString

    "
     self revisionInfoFromString:'Path: stx/libbasic/Array.st, Version: 123, User: cg, Time: 2011-12-21T21:03:08.826' 
    "

    "Created: / 21-12-2011 / 14:50:12 / cg"
!

revisionLogOf:clsOrNil 
        fromRevision:rev1OrNil toRevision:rev2OrNil numberOfRevisions:limitOrNil 
        fileName:classFileName directory:packageDir module:moduleDir 

    |info log targetDir count newestRevision|

    targetDir := self packageDirectoryForModule:moduleDir package:packageDir.
    targetDir exists ifFalse:[^ nil ].

    info := IdentityDictionary new.
    log := OrderedCollection new.
    count := 0.

    (targetDir filesMatching:(classFileName,'_*')) do:[:eachVersionFile |
        |versionString cs versionChange info|

        versionString := eachVersionFile copyFrom:(classFileName size + 2).
        count := count + 1.
        (newestRevision isNil 
        or:[ self isRevision:versionString after:newestRevision ]) ifTrue:[
            newestRevision := versionString
        ].

        (rev1OrNil isNil 
            or:[ rev1OrNil = 0
            or:[ versionString = rev1OrNil
            or:[ self isRevision:versionString after:rev1OrNil ]]])
        ifTrue:[
            (rev2OrNil isNil 
                or:[ rev2OrNil = 0
                or:[ versionString = rev2OrNil
                or:[ self isRevision:rev2OrNil after:versionString ]]])
            ifTrue:[
                (limitOrNil isNil
                or:[ log size < limitOrNil ])
                ifTrue:[
                    cs := ChangeSet fromFile:(targetDir construct:eachVersionFile).
                    versionChange := cs detect:[:chg | chg isMethodChange
                                                       and:[chg selector = self nameOfVersionMethodInClasses]]
                                        ifNone:nil.
                    versionChange notNil ifTrue:[
                        info := self revisionInfoFromString:versionChange source.
                    ] ifFalse:[
                        info := self versionInfoClass new.
                    ].

                    info revision:versionString.
                    log add:info.
                ]
            ].
        ].
    ].
    log sort:[:a :b | self isRevision:b revision after:a revision].

    info at:#revisions put:log.
    info at:#numberOfRevisions put:count.
    info at:#newestRevision put:newestRevision.

    ^ info

    "Created: / 21-12-2011 / 20:39:31 / cg"
!

streamForClass:aClass fileName:classFileName revision:revision directory:packageDir module:moduleDir cache:doCache
    |targetDir oldFile|

    targetDir := self packageDirectoryForModule:moduleDir package:packageDir.
    oldFile := (targetDir construct:classFileName,'_',revision).
    ^ oldFile readStream

    "Created: / 21-12-2011 / 20:49:01 / cg"
! !

!FileBasedSourceCodeManager class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_FileRepository
    ^ '$Path: stx/libbasic3/FileBasedSourceCodeManager.st, Version: 13, User: cg, Time: 2011-12-22T00:40:40.985$'
! !

