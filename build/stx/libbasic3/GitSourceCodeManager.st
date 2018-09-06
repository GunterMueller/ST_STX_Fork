"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 2012 by Claus Gittinger
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

AbstractSourceCodeManager subclass:#GitSourceCodeManager
	instanceVariableNames:''
	classVariableNames:'Verbose DefaultRepository PerModuleRepositories DisabledModules
		RecentlyCheckedModulesAndPackages GitCommandTimeout GitTempDir
		GitCommandSemaphore GitExecutable GitCommitOptions
		GitUpdateOptions WorkDirectory'
	poolDictionaries:''
	category:'System-SourceCodeManagement'
!

!GitSourceCodeManager class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2012 by Claus Gittinger
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
    Attention: this will be removed soon - it has been obsoleted by the
    new mercurial support found in libscm/mercurial.

    SourceCodeManager which accesses the sourcecode through Git.
    ongoing work - unfinished and unusable

    Comment:
        The code here is a copy-paste mess; it definitely needs some cleanup...

    [author:]
        Claus Gittinger

    [see also:]
"
! !

!GitSourceCodeManager class methodsFor:'initialization'!

forgetDisabledModules
    DisabledModules := nil.
!

gitCommandSemaphore
    GitCommandSemaphore isNil ifTrue:[
        GitCommandSemaphore := (Semaphore new:10) name:'Concurrent GIT Commands'.    "/ at most 10 git activities concurrently
    ].
    ^ GitCommandSemaphore
!

initialize
    | s |

    "/ GitCommandSemaphore := (Semaphore new:10) name:'Concurrent GIT Commands'.    "/ at most 10 git activities concurrently
    GitCommitOptions := ''.
    GitUpdateOptions := ''.
    DisabledModules := nil.
    PerModuleRepositories isNil ifTrue:[
        PerModuleRepositories := Dictionary new.
    ].

    "/ will do that lazy later, to avoid making startup slower and slower...
"/    ok := OperatingSystem canExecuteCommand:(self gitExecutable).
"/    ok ifFalse:[
"/        'GitSourceCodeManager [warning]: disabled because no >>git<< command was found' infoPrintCR.
"/        ^ self
"/    ].

    "/
    "/ optionally set the WorkTreeDirectoryName from $STX_WORKTREE;
    "/ if non-nil, a working tree is kept there
    "/ and updated/commited files are not removed.
    "/ If you use a regular (make-) tree, 
    "/ set WorkTreeDirectoryName (or the environment variable) to that.
    "/
    "/ this is not yet finished.
    "/
    s := OperatingSystem getEnvironment:'STX_WORKTREE'.
    s notNil ifTrue:[
        WorkTreeDirectoryName := s.
        UseWorkTree := true.
    ]

    "
     AbstractSourceCodeManager initialize
     GitSourceCodeManager initialize
    "

    "Created: / 04-11-1995 / 19:14:38 / cg"
    "Modified: / 19-12-1995 / 14:25:46 / stefan"
    "Modified (comment): / 20-03-2012 / 19:05:00 / cg"
!

initializeForRepository:aDirectoryName
    "reinitialize. 
     Can be used from the launcher to change/configure the repository."

    |dir|

    self repositoryName:aDirectoryName.
    AbstractSourceCodeManager initialize.
    GitSourceCodeManager initialize.

    (dir := aDirectoryName asFilename) exists ifFalse:[
        dir recursiveMakeDirectory.
    ].
    (dir construct:'.git') exists ifFalse:[
        self executeGitCommand:'init' inDirectory:dir
    ].

    "Created: / 13-08-1997 / 17:20:57 / cg"
    "Modified: / 25-09-1997 / 12:28:05 / stefan"
    "Modified: / 23-07-2012 / 16:16:57 / cg"
!

initializeRepository
    self initializeForRepository:(self repositoryName)

    "Created: / 02-03-2012 / 16:56:21 / cg"
! !

!GitSourceCodeManager class methodsFor:'accessing'!

executeGitCommand:cmd inDirectory:dir
    |retCode out err|

    retCode := self 
        executeGitCommand:cmd 
        outputTo:(out := WriteStream on:(String new:100)) 
        errorTo:(err := WriteStream on:(String new:100))     
        inDirectory:dir.
    retCode ifFalse:[
        Transcript showCR:'-----------------------------------------------'.
        Transcript showCR:'out:'.
        Transcript showCR:out contents.
        Transcript showCR:'err:'.
        Transcript showCR:err contents.
    ].
    ^ retCode

    "Created: / 23-07-2012 / 16:17:06 / cg"
!

executeGitCommand:cmd outputTo:outStreamOrNil errorTo:errStreamOrNil inDirectory:dir
    ^ OperatingSystem 
        executeCommand:'git ',cmd 
        outputTo:outStreamOrNil 
        errorTo:errStreamOrNil     
        inDirectory:dir asFilename pathName.

    "Created: / 24-07-2012 / 09:33:29 / cg"
!

gitBinDirectory:ignoredString 
    "ignored - for backward compatibility (to read old settings files)"
    "Created: / 14-01-2012 / 20:49:46 / cg"
!

gitCommandTimeout
    ^ GitCommandTimeout ? ("360" 120 seconds)

    "Modified (comment): / 08-01-2012 / 19:02:44 / cg"
    "Created: / 02-03-2012 / 15:23:40 / cg"
!

gitCommandTimeout:aTimeDuration
    GitCommandTimeout := aTimeDuration asTimeDuration.

    "Created: / 02-03-2012 / 15:23:46 / cg"
!

gitCommitOptions
    ^ GitCommitOptions ? ''

    "Created: / 02-03-2012 / 15:23:51 / cg"
!

gitCommitOptions:aString 
    GitCommitOptions := aString.

    "Created: / 02-03-2012 / 15:23:57 / cg"
!

gitExecutable
    "return the name of the git executable."

    ^ GitExecutable ? 'git'

    "Created: / 02-03-2012 / 15:24:02 / cg"
!

gitExecutable:aString
    "set the name of the git executable."

    aString isEmptyOrNil ifTrue:[
        GitExecutable := nil
    ] ifFalse:[        
        GitExecutable := aString.
    ].

    "Modified: / 21-09-2006 / 16:41:33 / cg"
    "Created: / 02-03-2012 / 15:24:07 / cg"
!

gitTmpDirectory
    "return the name of the tmp repository.
     That's the directory, where temporary files are created for checkin/checkout.
     If nil, the system's default tempDirectory is used."

    ^ (GitTempDir ? Filename tempDirectory pathName)

    "
     CVSTempDir := nil   
    "

    "Created: / 02-03-2012 / 15:24:12 / cg"
!

gitTmpDirectory:aPathNameString
    "set the name of the tmp repository.
     That's the directory, where temporary files are created for checkin/checkout.
     If nil, the system's default tempDirectory is used."

    GitTempDir := aPathNameString

    "Created: / 02-03-2012 / 15:24:18 / cg"
!

gitUpdateOptions
    ^ GitUpdateOptions ? ''

    "Created: / 02-03-2012 / 15:24:24 / cg"
!

gitUpdateOptions:aString 
    GitUpdateOptions := aString.

    "Created: / 02-03-2012 / 15:24:28 / cg"
!

knownModules
    "return the modules, we currently know"

    PerModuleRepositories isEmptyOrNil ifTrue:[^ #() ].
    ^ PerModuleRepositories keys

    "Modified: / 14-01-2012 / 21:23:37 / cg"
!

knownRepositories
    "return the modules, we currently know"

    ^ PerModuleRepositories values copyWith:DefaultRepository

    "Modified: / 14-01-2012 / 21:23:59 / cg"
!

repositoryForPackage:packageId
    "superclass AbstractSourceCodeManager class says that I am responsible to implement this method"

    ^self getGitRepositoryForModule: ( packageId upTo:$:)

    "Modified: / 10-10-2011 / 19:38:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-03-2012 / 15:25:19 / cg"
!

repositoryInfoPerModule
    "return the dictionary, which associates gitRepositories to module names.
     If no entry is contained in this dictionary for some module,
     the default crepository will be used."

    ^ PerModuleRepositories ? #()

    "Modified (comment): / 02-03-2012 / 15:25:28 / cg"
!

repositoryInfoPerModule:aDictionary
    "set the dictionary, which associates repositories to module names.
     If no entry is contained in this dictionary for some module,
     the default repository will be used."

    PerModuleRepositories := aDictionary

    "Modified: / 14-01-2012 / 21:25:21 / cg"
!

repositoryName
    "return the name of the global repository.
     This is used, if no per-module repository is defined."

    ^ DefaultRepository

    "Created: / 14-09-1996 / 13:22:05 / cg"
    "Modified: / 14-01-2012 / 21:25:42 / cg"
!

repositoryName:aDirectoryName
    "set the name of the repository;
     that's the name of the global repository, which is used 
     if no specific repository was defined for a module."

    DisabledModules := nil.
    DefaultRepository := aDirectoryName.

    "Created: / 14-09-1996 / 13:22:24 / cg"
    "Modified: / 14-01-2012 / 21:26:17 / cg"
!

repositoryName:aRepositoryName forModule:aModuleName
    "set the repository which provides the sources for all 
     classes in a particular module.
     This can be used from an rc-script, to specify a repository
     for a particular module.
     If left unspecified, the global (i.e. fallBack) repository is used."

    DisabledModules := nil.
    PerModuleRepositories at:aModuleName put:aRepositoryName

    "Modified (comment): / 14-01-2012 / 21:27:08 / cg"
!

repositoryNameForModule:aModuleName
    "return the repository which provides the sources for all 
     classes in a particular module.
     Nil is returned for unspecified moduleRoots; in this case, 
     the global (i.e. fallBack) repository will be used for source access."

    ^ PerModuleRepositories at:aModuleName ifAbsent:nil.

    "Created: / 19-09-1997 / 06:13:06 / cg"
!

repositoryNameForPackage:packageId     
    ^ self repositoryNameForModule:(packageId upTo:$:)

    "Created: / 10-10-2011 / 19:44:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 25-07-2012 / 18:23:06 / cg"
!

workDirectory
    ^ WorkDirectory

    "Created: / 03-03-2012 / 11:08:29 / cg"
!

workDirectory:aPath
    WorkDirectory := aPath

    "Created: / 03-03-2012 / 11:08:37 / cg"
! !

!GitSourceCodeManager class methodsFor:'basic administration'!

addFile:fileName inDirectory:dirPath
    self executeGitCommand:('add "',fileName,'"') inDirectory:dirPath

    "Created: / 25-07-2012 / 23:07:57 / cg"
!

checkForExistingContainer:fileName inModule:moduleName directory:dirName
    "check for a container to be present"

    |path subDir|

    path := (self repositoryName asFilename construct:moduleName) construct:dirName.
    path exists ifFalse:[
        subDir := moduleName asFilename construct:dirName.
        self executeGitCommand:'checkout ',subDir name inDirectory:self repositoryName.
    ].
    ^ (path construct:fileName) exists

    "Created: / 23-07-2012 / 16:21:02 / cg"
!

checkForExistingModule:moduleName
    "check for a module to be present"

    |path subDir|

    path := self repositoryName asFilename construct:moduleName.
    path exists ifFalse:[
        subDir := moduleName asFilename.
        self executeGitCommand:'checkout ',subDir name inDirectory:self repositoryName.
        self breakPoint:#cg.
    ].
    ^ path exists

    "Created: / 23-07-2012 / 18:44:27 / cg"
!

checkForExistingModule:moduleName directory:packageDir
    "check for a package directory to be present"

    |path subDir|

    path := (self repositoryName asFilename construct:moduleName) construct:packageDir.
    path exists ifFalse:[
        subDir := moduleName asFilename construct:packageDir.
        self executeGitCommand:'checkout ',subDir name inDirectory:self repositoryName.
    ].
    ^ path exists

    "Created: / 23-07-2012 / 19:07:34 / cg"
!

checkin:containerFilename text:someText directory:packageDir module:moduleDir logMessage:logMessage force:force
    |path relPath|

    relPath := (moduleDir asFilename construct:packageDir) construct:containerFilename.
    path := self repositoryName asFilename construct:relPath.
    path contents: someText.

    ^ self checkinClass:nil 
        fileName:containerFilename 
        directory:packageDir 
        module:moduleDir
        source:nil
        logMessage:logMessage 
        force:force

    "Created: / 25-07-2012 / 14:29:10 / cg"
!

checkinClass:aClassOrNil fileName:classFileName directory:packageDir module:moduleDir source:sourceFileOrNil logMessage:logMessage force:force
    "checkin of a class into the source repository.
     Return true if ok, false if not."

    |path relPath logArg out err|

    relPath := (moduleDir asFilename construct:packageDir) construct:classFileName.
    path := self repositoryName asFilename construct:relPath.
    sourceFileOrNil notNil ifTrue:[
        sourceFileOrNil asFilename moveTo: path.
    ].

    (self executeGitCommand:'add ',relPath name inDirectory:self repositoryName) ifFalse:[
        self halt:'git command failed'
    ].

    out := WriteStream on:(String new:100).
    err := WriteStream on:(String new:100).
    (self executeGitCommand:'status --porcelain' outputTo:out errorTo:err inDirectory:self repositoryName) ifFalse:[
        self halt:'git command failed'
    ].
    (out contents withoutSeparators isEmptyOrNil) ifTrue:[
        (err contents withoutSeparators isEmptyOrNil) ifTrue:[
            "/ nothing to commit
            ^ true
        ].
    ].
    logArg := logMessage copyReplaceAll:$" withAll:''''''.
    (self executeGitCommand:'commit -m "',logArg,'"' inDirectory:self repositoryName) ifFalse:[
        self halt:'git command failed'
    ].
    ^ true

    "Created: / 23-07-2012 / 20:05:14 / cg"
!

commitRepository:repositoryDirectory logMessage:logMessage
    |logArg|

    self 
        executeGitCommand:('status') 
        outputTo:Transcript 
        errorTo:Transcript     
        inDirectory:repositoryDirectory.

    logArg := logMessage copyReplaceAll:$" withAll:''''''.
    self 
        executeGitCommand:('commit -m "',logArg,'"') 
        outputTo:Transcript 
        errorTo:Transcript     
        inDirectory:repositoryDirectory.

    "Created: / 25-07-2012 / 22:47:57 / cg"
!

createContainerFor:aClass inModule:moduleName directory:dirName container:fileName
    "create a new container & check into it an initial version of aClass"

    ^ self shouldImplement
!

createModule:moduleName
    "create a new module directory"

    |dir|

    dir := self repositoryName asFilename construct:moduleName.
    dir exists ifTrue:[^ true].
    dir recursiveMakeDirectory.
    ^ dir exists.

    "Created: / 23-07-2012 / 19:04:51 / cg"
!

createModule:moduleName directory:directory
    "create a new package directory"

    |dir|

    dir := (self repositoryName asFilename construct:moduleName) construct:directory.
    dir exists ifTrue:[^ true].
    dir recursiveMakeDirectory.
    ^ dir exists.

    "Created: / 23-07-2012 / 19:08:22 / cg"
!

initialRevisionStringFor:aClass inModule:moduleDir directory:packageDir container:fileName
    "return a string usable as initial revision string"

    ^ self 
        revisionStringFor:aClass 
        inModule:moduleDir 
        directory:packageDir 
        container:fileName 
        revision:'1'

    "Created: / 23-07-2012 / 18:40:25 / cg"
!

revisionInfoFromString:aString 
    "{ Pragma: +optSpace }"

    "return a VersionInfo object filled with revision info.
     This extracts the relevant info from aString."

    ^ self revisionInfoFromStandardVersionString:aString

    "
     self revisionInfoFromString:'Path: stx/libbasic/Array.st, Version: 123, User: cg, Time: 2011-12-21T21:03:08.826' 
    "

    "Created: / 23-07-2012 / 19:02:56 / cg"
!

updateRepository:repositoryDirectory
    self executeGitCommand:'update' inDirectory:repositoryDirectory

    "Created: / 25-07-2012 / 18:55:56 / cg"
! !

!GitSourceCodeManager class methodsFor:'debugging'!

verboseSourceCodeAccess
    ^ Verbose ? false
!

verboseSourceCodeAccess:aBoolean
    Verbose := aBoolean
! !

!GitSourceCodeManager class methodsFor:'queries'!

isContainerBased
    ^ false

    "Created: / 24-07-2012 / 18:21:32 / cg"
!

isExperimental
    ^ true

    "Created: / 21-01-2013 / 09:10:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isResponsibleForPackage:aString
    ^true.

    "Created: / 09-07-2011 / 14:32:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 02-03-2012 / 15:05:14 / cg"
!

managerTypeName
    ^ 'Git'

    "Created: / 16-08-2006 / 11:05:56 / cg"
!

nameOfVersionMethodForExtensions
    ^ #'extensionsVersion_Git'

    "Modified: / 02-03-2012 / 15:05:02 / cg"
!

nameOfVersionMethodInClasses
    ^ #'version_Git'

    "Modified: / 02-03-2012 / 15:04:56 / cg"
!

settingsApplicationClass
    "link to my settings application (needed for the settings dialog"

    ^ GitSourceCodeManagementSettingsAppl

    "Created: / 19-04-2011 / 12:43:29 / cg"
    "Modified: / 02-03-2012 / 15:04:50 / cg"
! !

!GitSourceCodeManager class methodsFor:'saving'!

savePreferencesOn:aStream
    aStream nextPutLine:'GitSourceCodeManager notNil ifTrue:['.
    self repositoryInfoPerModule notEmptyOrNil ifTrue:[
        aStream nextPutLine:'    GitSourceCodeManager repositoryInfoPerModule:' , self repositoryInfoPerModule storeString , '.'.
    ].
    GitExecutable notNil ifTrue:[
        aStream nextPutLine:'    GitSourceCodeManager gitExecutable:' , GitExecutable storeString , '.'.
    ].
    (Smalltalk at:#SourceCodeManager) == self ifTrue:[
        aStream nextPutLine:'    Smalltalk at:#SourceCodeManager put: GitSourceCodeManager.'.
        aStream nextPutLine:'    GitSourceCodeManager initializeForRepository:' , self repositoryName storeString , '.'.
    ] ifFalse:[
        aStream nextPutLine:'    GitSourceCodeManager repositoryName:' , self repositoryName storeString , '.'.
    ].
    aStream nextPutLine:'].'.

    "Created: / 09-11-2006 / 15:09:25 / cg"
    "Modified: / 02-03-2012 / 15:17:42 / cg"
! !

!GitSourceCodeManager class methodsFor:'testing'!

isGit
    ^ true

    "Created: / 02-03-2012 / 15:17:19 / cg"
! !

!GitSourceCodeManager class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


GitSourceCodeManager initialize!
