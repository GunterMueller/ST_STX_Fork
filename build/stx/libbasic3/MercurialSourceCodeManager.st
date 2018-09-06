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

AbstractSourceCodeManager subclass:#MercurialSourceCodeManager
	instanceVariableNames:''
	classVariableNames:'Verbose DefaultRepository PerModuleRepositories HGTempDir
		DisabledModules HGCommandSemaphore HGExecutable HGCommitOptions
		HGUpdateOptions HGCommandTimeout
		RecentlyCheckedModulesAndPackages WorkDirectory'
	poolDictionaries:''
	category:'System-SourceCodeManagement'
!

!MercurialSourceCodeManager class methodsFor:'documentation'!

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

    SourceCodeManager which accesses the sourcecode through hg (mercurial).
    ongoing work - unfinished and unusable

    Comment:
        The code here is a copy-paste mess; it definitely needs some cleanup...

    [author:]
        Claus Gittinger

    [see also:]
"
! !

!MercurialSourceCodeManager class methodsFor:'initialization'!

forgetDisabledModules
    DisabledModules := nil.
!

hgCommandSemaphore
    HGCommandSemaphore isNil ifTrue:[
        HGCommandSemaphore := (Semaphore new:10) name:'Concurrent Mercurial Commands'.    "/ at most 10 hg activities concurrently
    ].
    ^ HGCommandSemaphore
!

initialize
    | s |

    "/ HGCommandSemaphore := (Semaphore new:10) name:'Concurrent Mercurial Commands'.    "/ at most 10 hg activities concurrently
    HGCommitOptions := ''.
    HGUpdateOptions := ''.
    DisabledModules := nil.
    PerModuleRepositories isNil ifTrue:[
        PerModuleRepositories := Dictionary new.
    ].

    "/ will do that lazy later, to avoid making startup slower and slower...
"/    ok := OperatingSystem canExecuteCommand:(self hgExecutable).
"/    ok ifFalse:[
"/        'MercurialSourceCodeManager [warning]: disabled because no >>hg<< command was found' infoPrintCR.
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
     MercurialSourceCodeManager initialize
    "

    "Created: / 04-11-1995 / 19:14:38 / cg"
    "Modified: / 19-12-1995 / 14:25:46 / stefan"
    "Modified (comment): / 20-03-2012 / 19:04:55 / cg"
!

initializeForRepository:aDirectoryName
    "reinitialize. 
     Can be used from the launcher to change/configure the repository."

    self repositoryName:aDirectoryName.
    AbstractSourceCodeManager initialize.
    MercurialSourceCodeManager initialize.

    "Created: / 13-08-1997 / 17:20:57 / cg"
    "Modified: / 25-09-1997 / 12:28:05 / stefan"
    "Modified (comment): / 14-01-2012 / 21:40:18 / cg"
! !

!MercurialSourceCodeManager class methodsFor:'accessing'!

hgBinDirectory:ignoredString
    "ignored - for backward compatibility (to read old settings files)"

    "Created: / 14-01-2012 / 20:49:46 / cg"
!

hgCommandTimeout
    ^ HGCommandTimeout ? ("360" 120 seconds)

    "Modified (comment): / 08-01-2012 / 19:02:44 / cg"
    "Created: / 14-01-2012 / 20:51:10 / cg"
!

hgCommandTimeout:aTimeDuration
    HGCommandTimeout := aTimeDuration asTimeDuration.

    "Created: / 14-01-2012 / 20:51:26 / cg"
!

hgCommitOptions
    ^ HGCommitOptions ? ''

    "Created: / 14-01-2012 / 20:36:07 / cg"
!

hgCommitOptions:aString 
    HGCommitOptions := aString.

    "Created: / 14-01-2012 / 20:36:16 / cg"
!

hgExecutable
    "return the name of the hg executable."

    ^ HGExecutable ? 'hg'

    "Created: / 14-01-2012 / 20:51:38 / cg"
!

hgExecutable:aString
    "set the name of the hg executable."

    aString isEmptyOrNil ifTrue:[
        HGExecutable := nil
    ] ifFalse:[        
        HGExecutable := aString.
    ].

    "Modified: / 21-09-2006 / 16:41:33 / cg"
    "Created: / 14-01-2012 / 20:52:02 / cg"
!

hgTmpDirectory
    "return the name of the tmp repository.
     That's the directory, where temporary files are created for checkin/checkout.
     If nil, the system's default tempDirectory is used."

    ^ (HGTempDir ? Filename tempDirectory pathName)

    "
     CVSTempDir := nil   
    "

    "Created: / 14-01-2012 / 20:52:13 / cg"
!

hgTmpDirectory:aPathNameString
    "set the name of the tmp repository.
     That's the directory, where temporary files are created for checkin/checkout.
     If nil, the system's default tempDirectory is used."

    HGTempDir := aPathNameString

    "Created: / 14-01-2012 / 20:52:43 / cg"
!

hgUpdateOptions
    ^ HGUpdateOptions ? ''

    "Created: / 14-01-2012 / 20:36:23 / cg"
!

hgUpdateOptions:aString 
    HGUpdateOptions := aString.

    "Created: / 14-01-2012 / 20:36:29 / cg"
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

    ^self getHGRepositoryForModule: ( packageId upTo:$:)

    "Modified: / 10-10-2011 / 19:38:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-01-2012 / 21:24:21 / cg"
!

repositoryInfoPerModule
    "return the dictionary, which associates hgRepositories to module names.
     If no entry is contained in this dictionary for some module,
     the default crepository will be used."

    ^ PerModuleRepositories ? #()

    "Modified (comment): / 14-01-2012 / 21:24:58 / cg"
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
    "superclass AbstractSourceCodeManager class says that I am responsible to implement this method"
    
    ^ self getHGRepositoryForModule:(packageId upTo:$: )

    "Created: / 10-10-2011 / 19:44:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-01-2012 / 21:27:47 / cg"
!

workDirectory
    ^ WorkDirectory

    "Created: / 03-03-2012 / 11:08:29 / cg"
!

workDirectory:aPath
    WorkDirectory := aPath

    "Created: / 03-03-2012 / 11:08:37 / cg"
! !

!MercurialSourceCodeManager class methodsFor:'basic administration'!

createContainerFor:aClass inModule:moduleName directory:dirName container:fileName
    "create a new container & check into it an initial version of aClass"

    ^ self shouldImplement
! !

!MercurialSourceCodeManager class methodsFor:'debugging'!

verboseSourceCodeAccess
    ^ Verbose ? false
!

verboseSourceCodeAccess:aBoolean
    Verbose := aBoolean
! !

!MercurialSourceCodeManager class methodsFor:'queries'!

isExperimental
    ^ true

    "Created: / 21-01-2013 / 09:10:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isResponsibleForPackage:aString

    | id |

    "JV@2011-07-09: The real check is too slow. Cache needed here"
    ^true.

"/    id := aString asPackageId. 
"/    ^self checkForExistingModule: id module directory: id directory.

    "Created: / 09-07-2011 / 14:32:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

managerTypeName
    ^ 'Mercurial'

    "Created: / 16-08-2006 / 11:05:56 / cg"
!

nameOfVersionMethodForExtensions
    ^ #'extensionsVersion_HG'

    "Modified: / 14-01-2012 / 22:01:19 / cg"
!

nameOfVersionMethodInClasses
    ^ #'version_HG'

    "Modified: / 14-01-2012 / 22:01:29 / cg"
!

settingsApplicationClass
    "link to my settings application (needed for the settings dialog"

    ^ MercurialSourceCodeManagementSettingsAppl

    "Created: / 19-04-2011 / 12:43:29 / cg"
    "Modified: / 14-01-2012 / 22:01:36 / cg"
! !

!MercurialSourceCodeManager class methodsFor:'saving'!

savePreferencesOn:aStream
    aStream nextPutLine:'MercurialSourceCodeManager notNil ifTrue:['.
    self repositoryInfoPerModule notEmptyOrNil ifTrue:[
        aStream nextPutLine:'    MercurialSourceCodeManager repositoryInfoPerModule:' , self repositoryInfoPerModule storeString , '.'.
    ].
    HGExecutable notNil ifTrue:[
        aStream nextPutLine:'    MercurialSourceCodeManager hgExecutable:' , HGExecutable storeString , '.'.
    ].
    (Smalltalk at:#SourceCodeManager) == self ifTrue:[
        aStream nextPutLine:'    Smalltalk at:#SourceCodeManager put: MercurialSourceCodeManager.'.
        aStream nextPutLine:'    MercurialSourceCodeManager initializeForRepository:' , self repositoryName storeString , '.'.
    ] ifFalse:[
        aStream nextPutLine:'    MercurialSourceCodeManager repositoryName:' , self repositoryName storeString , '.'.
    ].
    aStream nextPutLine:'].'.

    "Created: / 09-11-2006 / 15:09:25 / cg"
    "Modified: / 14-01-2012 / 22:03:40 / cg"
! !

!MercurialSourceCodeManager class methodsFor:'testing'!

isMercurial
    ^ true

    "Created: / 14-01-2012 / 21:54:04 / cg"
! !

!MercurialSourceCodeManager class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


MercurialSourceCodeManager initialize!
