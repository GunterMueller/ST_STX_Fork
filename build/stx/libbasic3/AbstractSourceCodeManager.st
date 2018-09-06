"
 COPYRIGHT (c) 1995 by Claus Gittinger
 COPYRIGHT (c) 2015-2016 Jan Vrany
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

Object subclass:#AbstractSourceCodeManager
	instanceVariableNames:''
	classVariableNames:'CacheDirectoryName CachingSources DefaultManager ManagerPerModule
		UseWorkTree Verbose WorkTreeDirectoryName
                PackagesWithoutExtensionMethodConfirmation		
                SuppressExtensionMethodConfirmation
                ManagerForPackageCache'               
	poolDictionaries:''
	category:'System-SourceCodeManagement'
!

Object subclass:#PackageAndManager
	instanceVariableNames:'package managerTypeName'
	classVariableNames:''
	poolDictionaries:''
	privateIn:AbstractSourceCodeManager
!

!AbstractSourceCodeManager class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1995 by Claus Gittinger
 COPYRIGHT (c) 2015-2016 Jan Vrany
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
    Abstract superclass for sourceCodeManagers.

    Concrete subclasses provide access to a source repository.
    Most protocol here traps into subclassResponsbility errors.
    Please read more documentation in concrete subclasses 
    (especially: CVSSourceCodeManager) for how to use this manager and
    what to redefine in another repository manager if required.

    [author:]
        Claus Gittinger
"
! !

!AbstractSourceCodeManager class methodsFor:'initialization'!

forgetDisabledModules
    ^ self
!

initCacheDirPath
    "initialize the name of the cacheDirectory.
     This is:
        <tempDir>/stx_sourceCache (non-UNIX)
        ~/.smalltalk/source-cache (UNIX, as <tempDir> is pruned upon each reboot)
    "
    "JV@2012-03-14: Changed to use .smalltalk/source-cache on UNIX machines"
    "CG: why only on unix machines???"
    
    |dir|
    
    CachingSources isNil ifTrue:[
        CachingSources := true.
    ].

    dir := Filename homeDirectory / '.smalltalk/sourceCache'. 
    dir isWritableDirectory ifFalse:[
        dir := Filename defaultTempDirectory / 'stx_sourceCache'.
    ].  
    CacheDirectoryName := dir pathName.

"/    OperatingSystem isUNIXlike ifTrue:[
"/        CacheDirectoryName := '~/.smalltalk/sourceCache'.
"/    ] ifFalse:[
"/        CacheDirectoryName := (Filename defaultTempDirectory constructString:'stx_sourceCache').
"/    ].
    
    "
     self initCacheDirPath     
    "

    "Modified: / 12-07-1999 / 10:01:31 / cg"
    "Modified (comment): / 19-07-2012 / 14:03:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initialize
    "setup for caching and no workTree"

    CachingSources isNil ifTrue:[CachingSources := true].
    UseWorkTree    isNil ifTrue:[UseWorkTree := false].
    ManagerForPackageCache := Dictionary new.

    CachingSources ifTrue:[
        self validateCacheDirPath.
    ].
    Smalltalk addDependent:self

    "Modified: / 02-03-2012 / 17:00:11 / cg"
    "Modified: / 01-10-2015 / 06:07:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

update:something with:aParameter from:changedObject
    "flush resources on language changes"

    something == #returnFromSnapshot ifTrue:[
        self validateCacheDirPath
    ]
!

validateCacheDirPath
    (CacheDirectoryName isNil 
    or:[CacheDirectoryName asFilename exists not]) ifTrue:[
        self initCacheDirPath   
    ].
!

validateWorkingCopy: path
    "Return true, if given path is a valid working 
     copy of this manager; false otherwise."

    "/ JV@2015-10-02: Following is certainly a kludge, but defined
    "/ here tp avoid forking stx:libsvn..."
    self name == #SVNSourceCodeManager ifTrue:[
        ^ (path asFilename / '.svn') isDirectory
    ].
    ^ false

    "Created: / 02-10-2015 / 09:52:07 / jv"
! !

!AbstractSourceCodeManager class methodsFor:'accessing'!

availableManagers
    ^ AbstractSourceCodeManager 
        allSubclasses 
            reject:[:cls | (cls isAbstract) or:[cls isExperimental ]].

    "
     self availableManagers   
    "
!

cacheDirectoryName
    "return the name of the cache directory, where checked out class
     sources are kept for faster access. The default is '/tmp/stx_sourceCache'.
     This cache is shared among all ST/X users on a system."

    self cachingSources ifTrue:[
        (CacheDirectoryName isNil) ifTrue:[
            self initCacheDirPath   
        ].
    ].
    ^ CacheDirectoryName

    "Modified: 12.9.1996 / 02:20:45 / cg"
!

cacheDirectoryName:aStringOrFilename
    "set the name of the cache directory, where checked out class
     sources are kept for faster access. The default is '/tmp/stx_sourceCache'.
     This cache is shared among all ST/X users on a system.
     The directory is typically set via the launcher's setting menu, 
     or from a startup rc-file."

    CacheDirectoryName := aStringOrFilename.

    "HACK, HACK, since ManagerPerModule is lazy-initialize before
     preferences are read, sigh. We need a better system..."

    ManagerPerModule := nil.

    "Created: / 16-12-1995 / 15:18:43 / cg"
    "Modified: / 12-09-1996 / 02:21:35 / cg"
    "Modified (comment): / 09-07-2011 / 16:02:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

cachingSources
    "return true, if source caching is enabled.
     (see cacheDirectoryName for what that means)"

    ^ CachingSources ? false

    "Created: 16.12.1995 / 15:17:50 / cg"
    "Modified: 12.9.1996 / 02:22:19 / cg"
!

cachingSources:aBoolean
    "enable/disable the caching of source files.
     (see cacheDirectoryName for what that means)"

    CachingSources := aBoolean.
    aBoolean ifTrue:[
        CacheDirectoryName isNil ifTrue:[
            self validateCacheDirPath
        ].    
    ].    

    "
     AbstractSourceCodeManager cachingSources:true
    "
    
    "Created: 16.12.1995 / 15:18:13 / cg"
    "Modified: 12.9.1996 / 02:22:42 / cg"
!

defaultManager
    "return the default sourceCodeManager class"

    ^ DefaultManager

    "Created: 7.12.1995 / 17:14:22 / cg"
    "Modified: 12.9.1996 / 02:22:56 / cg"
!

enabledManagers
    "Return list of source code managers that are enabled"

    "If source code management is disabled, return #(). Following code
     is hack since  there is no global boolean flag, sigh"
    (Smalltalk at:#SourceCodeManager) isNil ifTrue:[
        ^ #()
    ].
    ^ self availableManagers select:[:manager | manager enabled].  



    "
     self enabledManagers   
    "

    "Created: / 23-01-2012 / 19:13:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

managerForMatchingModule:aPackageIDMatchString put:aSourceCodeManagerClass
    "update the per-module manager definitions, adding a manager class for a matchString"

    ManagerPerModule isNil ifTrue:[
        ManagerPerModule := UserPreferences current managerPerMatchingModuleDefinitions.
    ].
    ManagerPerModule do:[:each |
        |packageMatch|

        packageMatch := each package.
        (packageMatch = aPackageIDMatchString) ifTrue:[
            each manager:aSourceCodeManagerClass.
            ^ self
        ].
    ].
    ManagerPerModule add:
        (PackageAndManager 
            package: aPackageIDMatchString 
            manager: aSourceCodeManagerClass).
    ManagerForPackageCache := Dictionary new. 

    "
     self managerForModule:'stx:libbasic2' put:SVNSourceCodeManager
     self managerForModule:'stx:libbasic2' put:CVSSourceCodeManager
     self managerForModule:'stx:libbasic2'
     self managerForModule:'exept:expecco' 
    "

    "Created: / 18-04-2011 / 19:48:19 / cg"
    "Modified: / 01-10-2015 / 06:04:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

managerForPackage: aSymbol
    "return the sourceCodeManager for a aPackageID, nil if unspecified in the manager per package list"

    | prjsym prjdef prjdir parentPrjId manager |

    prjsym := aSymbol asSymbol.
    "JV@2012-01-23: If source code management is disabled, return nil. Following code
     is hack since  there is no global boolean flag, sigh"
    (Smalltalk at:#SourceCodeManager) isNil ifTrue:[ ^nil ].

    "First, search the cache..."
    ManagerForPackageCache at: prjsym ifPresent:[ :manager | ^ manager ].

    "If not found in the cache, search configured managers"
    self managerPerMatchingModuleDefinitions do:[:each |
        (each match:prjsym) ifTrue:[
            ManagerForPackageCache at: prjsym put: each manager.
            ^ each manager
        ].
    ].

    "If there's no configuration for given package, try to use the same
     that was used when package was compiled"
    prjdef := ProjectDefinition definitionClassForPackage: prjsym.
    (prjdef notNil and:[prjdef binaryRevisionString notNil]) ifTrue:[ 
        manager := prjdef sourceCodeManagerFromBinaryRevision.
        (manager notNil and:[manager enabled and:[manager isResponsibleForPackage: prjsym]]) ifTrue:[ 
            ManagerForPackageCache at: prjsym put: manager.
            ^manager
        ].
    ].

    "Still no luck, try to auto-configure."
    prjdef notNil ifTrue:[
        prjdir := prjdef packageDirectory.
        (prjdir notNil and:[prjdir isDirectory]) ifTrue:[
            | managers |
            managers := self availableManagers select:[:mgr |
                mgr enabled
                    and:[(mgr isResponsibleForPackage: prjsym)
                    and:[mgr validateWorkingCopy: prjdir] ] .    
            ].
            managers size == 1 ifTrue:[
                manager := managers anElement.
                ManagerForPackageCache at: prjsym put: manager.
                ^manager
            ]
        ].
    ].
    parentPrjId := prjsym asPackageId parentPackage.
    parentPrjId notNil ifTrue:[ 
        ^ self managerForPackage: parentPrjId asSymbol  
    ].
    ^ DefaultManager

    "
     self managerForPackage:'stx:libbasic' 
     self managerForPackage:'stx:libbasic2'
     self managerForPackage:'exept:expecco'  
    "

    "Created: / 18-04-2011 / 19:39:19 / cg"
    "Created: / 10-10-2011 / 14:50:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 19-10-2011 / 16:45:38 / cg"
    "Modified: / 02-10-2015 / 10:24:41 / jv"
    "Modified: / 04-03-2016 / 15:33:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

managerPerMatchingModuleDefinitions
    "return the sourceCodeManager definitions"

    ManagerPerModule isNil ifTrue:[
        ManagerPerModule := UserPreferences current managerPerMatchingModuleDefinitions
    ].
    ^ ManagerPerModule

    "Created: / 18-04-2011 / 20:09:16 / cg"
    "Modified: / 09-07-2011 / 13:36:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

managerPerMatchingModuleDefinitions:aCollection
    "set the sourceCodeManager definitions; must be an orderedCollection of packageMatchString -> manager
     associations 
     (not a dictionary, because order is relevant in the matching process, where the first match counts)"

    ManagerPerModule := aCollection.
    UserPreferences current managerPerMatchingModuleDefinitions:aCollection.
    ManagerForPackageCache := Dictionary new.

    "Created: / 18-04-2011 / 20:09:21 / cg"
    "Modified: / 01-10-2015 / 06:04:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

named: managerTypeName

    ^self availableManagers 
        detect:[:each|each managerTypeName = managerTypeName]
        ifNone:[nil]

    "
        AbstractSourceCodeManager named: 'CVS'
        AbstractSourceCodeManager named: 'Perforce'        
    "

    "Created: / 09-07-2011 / 13:51:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

repositoryInfoPerModule
    "return the dictionary, which associates CVSRoots to module names.
     If no entry is contained in this dictionary for some module,
     the default cvsRoot (CVSRoot) will be used."

    ^ #()

    "Created: / 09-11-2006 / 15:25:17 / cg"
!

repositoryInfoPerModule:info
    "/ ignore here
!

repositoryName
    "return the name of the repository.
     Since this is an abstract class, return nil (i.e. none)"

    ^ nil

    "Modified: 12.9.1996 / 02:20:45 / cg"
    "Created: 14.9.1996 / 13:21:37 / cg"
!

repositoryNameForPackage:packageId 
    "Return the repository ULR for the given package. 
     Used for testing/debugging source code management configuration"
    
    ^ self subclassResponsibility

    "Created: / 10-10-2011 / 19:44:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 21-12-2011 / 23:03:00 / cg"
!

shownInBrowserMenus
    "can be redefined in subclasses which can be suppressed in the browser's menus"

    ^ UserPreferences current at:(self nameWithoutPrefix,'.enabled') ifAbsent:false.

    "Created: / 08-01-2012 / 19:56:22 / cg"
!

shownInBrowserMenus:aBoolean
    "can be redefined in subclasses which can be suppressed in the browser's menus"

    ManagerForPackageCache := Dictionary new.
    ^ UserPreferences current at:(self nameWithoutPrefix,'.enabled') put:aBoolean.

    "Created: / 15-01-2012 / 14:09:21 / cg"
    "Modified: / 01-10-2015 / 06:07:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

useWorkTree
    "return the setting of useWorkTree, which (eventually)
     controls if an up-to-date view of a CVS working tree should be
     kept in sync. This is not yet implemented."

    ^ UseWorkTree

    "Created: 16.12.1995 / 15:36:48 / cg"
    "Modified: 12.9.1996 / 02:24:01 / cg"
!

useWorkTree:aBoolean
    "enable/disable the useWorkTree feature, which (eventually)
     controls if an up-to-date view of a CVS working tree should be
     kept in sync. This is not yet implemented."

    UseWorkTree := aBoolean

    "Created: 16.12.1995 / 15:37:29 / cg"
    "Modified: 12.9.1996 / 02:24:38 / cg"
!

utilities
    "Returns a 'utilities' object that can be used by tools. 

     By default, it returns an instance of
     SourceCodeManagerUtilities with receiver as its
     manager, but individual managers may override this
     method and supply its own, customized utilities."

    ^ (self isContainerBased
            ifTrue: [ SourceCodeManagerUtilitiesForContainerBasedManagers ]
            ifFalse: [ SourceCodeManagerUtilitiesForWorkspaceBasedManagers ]
      ) forManager: self

    "
     SourceCodeManager defaultManager
     SourceCodeManager defaultManager utilities
    "

    "Created: / 10-10-2011 / 15:10:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 25-07-2012 / 17:08:05 / cg"
!

workTreeDirectoryName
    "return the name of the workTree, which is kept in sync
     with the current class versions. This is not yet implemented"

    ^ WorkTreeDirectoryName

    "Created: 16.12.1995 / 15:35:21 / cg"
    "Modified: 12.9.1996 / 02:25:13 / cg"
!

workTreeDirectoryName:aStringOrFilename
    "set the name of the workTree, which is kept in sync
     with the current class versions. This is not yet implemented"

    WorkTreeDirectoryName := aStringOrFilename

    "Created: 16.12.1995 / 15:35:34 / cg"
    "Modified: 12.9.1996 / 02:25:19 / cg"
! !

!AbstractSourceCodeManager class methodsFor:'basic access'!

checkinClass:aClass fileName:classFileName directory:packageDir module:moduleDir source:sourceFile logMessage:logMessage force:force
    "checkin of a class into the source repository.
     Return true if ok, false if not."

    ^ self subclassResponsibility.

    "Created: 14.2.1997 / 21:17:33 / cg"
    "Modified: 14.2.1997 / 21:18:48 / cg"
!

checkoutModule:aModule directory:aPackage andDo:aBlock
    "check out everything from a package into a temporary directory.
     Then evaluate aBlock, passing the name of that temp-directory.
     Afterwards, the tempDir is removed.
     Return true, if OK, false if any error occurred."

    ^ self subclassResponsibility

    "Created: / 23-08-2006 / 14:07:08 / cg"
!

streamForClass:aClass fileName:classFileName revision:revision directory:packageDir module:moduleDir cache:doCache
    "extract a classes source code and return an open readStream on it.
     A revision of nil selects the current (in image) revision.
     The classes source code is extracted using the revision and the sourceCodeInfo,
     which itself is extracted from the classes packageString."

    ^ self subclassResponsibility

    "Modified: 14.2.1997 / 21:18:35 / cg"
!

streamForExtensionFile:fileName package:package directory:dir module:mod cache:doCache
    |defClass extensionsRevisionString extensionsRevisionInfo rev|

    defClass := ProjectDefinition definitionClassForPackage:package.
    extensionsRevisionString := defClass perform:(self nameOfVersionMethodForExtensions) ifNotUnderstood:nil.
    extensionsRevisionString isNil ifTrue:[
        Transcript showCR:'SourceCodeManager [warning]: no valid version info for extensions of "',package,'"'.
        ^ self streamForClass:nil fileName:fileName revision:nil directory:dir module:mod cache:false.
    ].

    extensionsRevisionInfo := self revisionInfoFromString:extensionsRevisionString inClass:nil.
    extensionsRevisionInfo isNil ifTrue:[
        self halt:('oops - possibly corrupted extensions version string: "%1" in class %2' bindWith:extensionsRevisionString with:defClass name).
        "/ check for umlaut-remover/adder bug from felix in extensionsRevisionString !!!!!!!!
        ^ self streamForClass:nil fileName:fileName revision:nil directory:dir module:mod cache:false.
    ].

    self assert:(fileName = 'extensions.st').
    self assert:(fileName = extensionsRevisionInfo fileName).

    rev := extensionsRevisionInfo revision.
    ^ self streamForClass:nil fileName:fileName revision:rev directory:dir module:mod cache:doCache.

    "Modified: / 01-07-2011 / 13:52:38 / cg"
! !

!AbstractSourceCodeManager class methodsFor:'basic administration'!

checkForExistingContainer:fileName inModule:moduleName directory:dirName
    "check for a container to be present"

    ^ self subclassResponsibility.

    "Created: / 13-09-2006 / 18:22:24 / cg"
!

checkForExistingContainer:fileName inPackage:aPackage
    "check if a source-code container is present in a packages directory."

    |packageDir moduleDir|

    packageDir := aPackage asPackageId directory.
    moduleDir := aPackage asPackageId module. 

    ^ self 
        checkForExistingContainer:fileName
        inModule:moduleDir 
        directory:packageDir

    "Created: / 13-09-2006 / 18:10:30 / cg"
!

checkForExistingContainerForClass:aClass
    "check if a source-code container for a given class is present in the repository."

    |sourceInfo packageDir moduleDir classFileName|

    sourceInfo := self sourceInfoOfClass:aClass.
    sourceInfo isNil ifTrue:[
        ('SourceCodeManager [warning]: no sourceInfo for class: ' , aClass name) errorPrintCR.
        ^ false
    ].

    packageDir := self directoryFromSourceInfo:sourceInfo.
    moduleDir := self moduleFromSourceInfo:sourceInfo.  "/ use the modules name as CVS module
    classFileName := self containerFromSourceInfo:sourceInfo.

    ^ self 
        checkForExistingContainer:classFileName 
        inModule:moduleDir 
        directory:packageDir

    "Created: / 13-05-1998 / 22:35:50 / cg"
    "Modified: / 13-09-2006 / 18:23:20 / cg"
!

checkForExistingModule:moduleName
    "check for a module directory to be present"

    ^ self subclassResponsibility.

    "Created: 9.12.1995 / 19:02:23 / cg"
    "Modified: 14.2.1997 / 21:19:01 / cg"
!

checkForExistingModule:moduleDir directory:packageDir
    "check for a package directory to be present"

    ^ self subclassResponsibility.

    "Created: / 23-08-2006 / 14:03:06 / cg"
!

createContainerFor:aClass inModule:moduleName directory:dirName container:fileName
    "create a new container & check into it an initial version of aClass"

    ^ self subclassResponsibility.

    "Created: 9.12.1995 / 19:02:47 / cg"
    "Modified: 14.2.1997 / 21:19:11 / cg"
!

createContainerFor:cls inModule:moduleName package:packageDir container:classFileName
    "create a new container & check into it an initial version of aClass"

    ^ self checkinClass:cls fileName:classFileName directory:packageDir module:moduleName logMessage:'Initial check in' force:false.

    "Created: / 23-07-2012 / 19:14:34 / cg"
!

createModule:moduleName
    "create a new module directory"

    ^ self subclassResponsibility.

    "Created: 9.12.1995 / 19:02:23 / cg"
    "Modified: 14.2.1997 / 21:19:16 / cg"
!

createModule:module directory:directory
    "create a new package directory"

    ^ self subclassResponsibility.

    "Created: / 23-08-2006 / 14:04:41 / cg"
!

initialRevisionStringFor:aClass inModule:moduleDir directory:packageDir container:fileName
    "return a string usable as initial revision string"

    ^ self subclassResponsibility

    "Created: / 23-08-2006 / 14:05:42 / cg"
!

revisionLogOf:clsOrNil 
    fromRevision:firstRev toRevision:lastRef 
    fileName:classFileName directory:packageDir module:moduleDir 

    ^ self 
        revisionLogOf:clsOrNil
        fromRevision:firstRev
        toRevision:lastRef
        numberOfRevisions:nil
        fileName:classFileName
        directory:packageDir
        module:moduleDir
!

revisionLogOf:clsOrNil 
    fromRevision:rev1OrNil toRevision:rev2OrNil numberOfRevisions:limitOrNil 
    fileName:classFileName directory:packageDir module:moduleDir 

    "Return info about the repository container and (part of) the revisionlog as a collection 
     of revision entries. Return nil on failure.

     This must be implemented by a concrete source-code manager

     If numRevisionsOrNil is notNil, it limits the number of revision records returned -
     only numRevions of the newest revision infos will be collected.

     The returned information is a structure (IdentityDictionary)
     filled with:
            #container          -> the container file name (for container-based SCMs)
            #cvsRoot            -> the CVS root (repository) 
            #filename           -> the actual source file name
            #newestRevision     -> the revisionString of the newest revision
            #numberOfRevisions  -> the number of revisions in the container (nil for all)
            #revisions          -> collection of per-revision info (see below)

            firstRevOrNil / lastRevOrNil specify from which revisions a logEntry is wanted:
             -If firstRevOrNil is nil, the first revision is the initial revision
              otherwise, the log starts with that revision.
             -If lastRevOrNil is nil, the last revision is the newest revision
              otherwise, the log ends with that revision.

             -If both are nil, all logEntries are extracted.
             -If both are 0 (not nil), no logEntries are extracted (i.e. only the header).

            per revision info consists of one record per revision:

              #revision              -> the revision string
              #author                -> who checked that revision into the repository
              #date                  -> when was it checked in
              #state                 -> the RCS state
              #numberOfChangedLines  -> the number of changed line w.r.t the previous
              #logMessage            -> the checkIn log message

            revisions are ordered newest first 
            (i.e. the last entry is for the initial revision; the first for the most recent one)
            Attention: if state = 'dead' that revision is no longer valid.
        "

    self subclassResponsibility

    "Created: / 15-11-1995 / 18:12:51 / cg"
    "Modified: / 14-02-1997 / 21:14:01 / cg"
    "Modified: / 11-02-2014 / 13:03:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractSourceCodeManager class methodsFor:'cache administration'!

condenseSourceCache
    "remove all cached old versions (i.e. leave the newest only)"

    |extractBaseAndVersion versionIsGreater vsnNumberString baseName|

    (CacheDirectoryName isNil or:[CacheDirectoryName asFilename isDirectory not]) ifTrue:[
        ^ self
    ].

    extractBaseAndVersion := 
        [:filenameString |
            |i|

            i := filenameString size.
            [i > 0 and:[(filenameString at:i) isDigit or:[(filenameString at:i) == $.]]] whileTrue:[ i := i - 1 ].
            vsnNumberString := filenameString copyFrom:i + 1.
            (filenameString at:i) == $_ ifTrue:[i := i - 1].
            baseName := filenameString copyTo:i.
        ].        

    versionIsGreater :=
        [:vA :vB |
            |seqA seqB sequenceIsGreater|

            seqA := (vA asCollectionOfSubstringsSeparatedBy:$.) collect:[:each | Integer readFrom:each].
            seqB := (vB asCollectionOfSubstringsSeparatedBy:$.) collect:[:each | Integer readFrom:each].
            sequenceIsGreater :=
                [:seqA :seqB :index |

                    |elA elB|

                    elA := seqA at:index.
                    elB := seqB at:index.
                    elA > elB ifTrue:[
                        true
                    ] ifFalse:[
                        elA < elB ifTrue:[
                            false
                        ] ifFalse:[
                            sequenceIsGreater value:seqA value:seqB value:index+1.
                        ].
                    ].
                ].

            sequenceIsGreater value:seqA value:seqB value:1.
        ].    

    CacheDirectoryName asFilename withAllDirectoriesDo:[:d |
        |allFiles newestVersions|

        newestVersions := Dictionary new.
        allFiles := d files.
        allFiles do:[:eachFilename |
            |prevVsnString|

            extractBaseAndVersion value:eachFilename baseName.

            vsnNumberString notEmpty ifTrue:[
                prevVsnString := newestVersions at:baseName ifAbsent:nil.
                prevVsnString isNil ifTrue:[
                    newestVersions at:baseName put:vsnNumberString.
                ] ifFalse:[
                    (versionIsGreater value:vsnNumberString value:prevVsnString) ifTrue:[
                        newestVersions at:baseName put:vsnNumberString
                    ]
                ].
            ].
        ].

        allFiles do:[:eachFilename |
            extractBaseAndVersion value:eachFilename baseName.
            (vsnNumberString isEmpty 
            or:[(vsnNumberString ~= (newestVersions at:baseName))]) ifTrue:[
                eachFilename remove
            ]
        ].
    ]

    "
     self condenseSourceCache
    "

    "Modified: / 29-08-2006 / 11:25:25 / cg"
!

flushSourceCache
    "remove all cached versions"

    |d|

    CacheDirectoryName notNil ifTrue:[
        d := CacheDirectoryName asFilename.
        d isDirectory ifTrue:[
            d directoryContentsAsFilenames do:[:eachFile |
                eachFile recursiveRemove
            ]
        ].
    ].
    Method flushSourceStreamCache.

    "
     self flushSourceCache
    "

    "Modified: / 30-09-2011 / 13:33:33 / cg"
! !

!AbstractSourceCodeManager class methodsFor:'debugging'!

verboseSourceCodeAccess
    ^ Verbose ? false
!

verboseSourceCodeAccess:aBoolean
    Verbose := aBoolean
! !

!AbstractSourceCodeManager class methodsFor:'obsolete backward compatibility'!

checkForExistingContainerInModule:moduleDir directory:packageDir container:fileName
    <resource: #obsolete>
    "check for a container to exist"

    self obsoleteMethodWarning.
    ^ self checkForExistingContainer:fileName inModule:moduleDir directory:packageDir

    "Modified: / 13-09-2006 / 18:23:45 / cg"
!

checkForExistingContainerInModule:moduleName package:dirName container:fileName
    "check for a container to be present"

    <resource: #obsolete>

    self obsoleteMethodWarning.
    ^ self 
        checkForExistingContainer:fileName
        inModule:moduleName 
        directory:dirName

    "Modified: / 13-09-2006 / 18:23:35 / cg"
!

checkForExistingModule:moduleDir package:packageDir
    "check for a package directory to be present"

    <resource: #obsolete>
    self obsoleteMethodWarning.
    ^ self checkForExistingModule:moduleDir directory:packageDir.

    "Created: / 09-12-1995 / 19:02:23 / cg"
    "Modified: / 23-08-2006 / 14:03:25 / cg"
!

checkoutModule:aModule package:aPackage andDo:aBlock
    "check out everything from a package into a temporary directory.
     Then evaluate aBlock, passing the name of that temp-directory.
     Afterwards, the tempDir is removed.
     Return true, if OK, false if any error occurred."

    <resource: #obsolete>
    self obsoleteMethodWarning.
    ^ self checkoutModule:aModule directory:aPackage andDo:aBlock

    "Modified: / 23-08-2006 / 14:07:31 / cg"
!

createModule:module package:package
    "create a new package directory"

    <resource: #obsolete>
    self obsoleteMethodWarning.
    ^ self createModule:module directory:package.

    "Created: / 09-12-1995 / 19:02:23 / cg"
    "Modified: / 23-08-2006 / 14:04:59 / cg"
!

getExistingContainersInModule:aModule package:aPackage
    "{ Pragma: +optSpace }"

    "return a collection containing the names of existing containers"

    <resource: #obsolete>
    self obsoleteMethodWarning.
    ^ self getExistingContainersInModule:aModule directory:aPackage

    "Created: / 20-05-1998 / 19:49:12 / cg"
    "Modified: / 23-08-2006 / 14:12:24 / cg"
!

getExistingPackagesInModule:aModule
    "{ Pragma: +optSpace }"

    "return a collection containing the names of existing packages"

    <resource: #obsolete>
    self obsoleteMethodWarning.
    ^ self getExistingDirectoriesInModule:aModule

    "Created: / 20-05-1998 / 19:38:34 / cg"
    "Modified: / 23-08-2006 / 14:14:04 / cg"
!

initialRevisionStringFor:aClass inModule:moduleDir package:packageDir container:fileName
    "return a string usable as initial revision string"

    <resource: #obsolete>

    self obsoleteMethodWarning.
    ^ self initialRevisionStringFor:aClass inModule:moduleDir directory:packageDir container:fileName

    "Created: / 14-02-1997 / 21:01:41 / cg"
    "Modified: / 23-08-2006 / 14:06:18 / cg"
    "Modified (format): / 21-12-2011 / 18:58:53 / cg"
! !

!AbstractSourceCodeManager class methodsFor:'private'!

checkMethodPackagesOf:aClass
    "check if aClass contains methods from another package;
     ask if these should be checked in with the class.
     Raises abortSignal if checkIn is to be suppressed.
     returns:
        #base   - only check in methods from the classes package
        #all    - check in all

     the old code looked for all extensions, and allowed them to be moved to the base-package.
     This was dangerous, as if one presses yes too quickly, extensions move to the base too easy.
     The new code only allows for extensions from the __NOPROJECT__ package to be moved.
     Extensions always remain extensions, and must be moved by an explicit method-menu action.
    "

    |checkInClassPackageOnly clsPackage otherPackages otherPackageNames methodsFromOtherPackages
     methodCategoriesInOtherPackages methodCategoryInOtherPackages
     msg answer isDefaultAnswer labels actions hasUnassignedExtensions
     unassignedMethods methodCategoriesWithUnassignedMethods methodCategoryWithUnassignedMethods 
     args anyPackageChange|

    checkInClassPackageOnly := false.

    clsPackage := aClass package.

    otherPackages := Set new.
    methodsFromOtherPackages := OrderedCollection new.
    hasUnassignedExtensions := false.
    unassignedMethods := OrderedCollection new.
    methodCategoriesWithUnassignedMethods := Set new.
    methodCategoriesInOtherPackages := Set new.

    aClass instAndClassSelectorsAndMethodsDo:[:sel :mthd |
        |mthdPackage|

        (mthdPackage := mthd package) ~= clsPackage ifTrue:[
            mthdPackage = PackageId noProjectID ifTrue:[
                hasUnassignedExtensions := true.
                unassignedMethods add:mthd.        
                methodCategoriesWithUnassignedMethods add:(mthd category).
            ] ifFalse:[
                methodsFromOtherPackages add:mthd.
                otherPackages add:mthdPackage.
                methodCategoriesInOtherPackages add:(mthd category).
            ].
        ]
    ].

    hasUnassignedExtensions ifFalse:[
        aClass allPrivateClassesDo:[:eachPrivateClass |
            aClass setPackage:clsPackage.
            eachPrivateClass instAndClassSelectorsAndMethodsDo:[:sel :mthd |
                mthd setPackage:clsPackage
            ]
        ].
        ^ #base
    ].

    otherPackages := otherPackages asOrderedCollection sort.
    otherPackageNames := 
        String streamContents:[:stream| 
            otherPackages 
                do:[:eachPackageName| eachPackageName printOn:stream] 
                separatedBy:[stream nextPutAll:', '].
        ].

    methodCategoriesInOtherPackages size == 1 ifTrue:[
        methodCategoryInOtherPackages := methodCategoriesInOtherPackages anElement.
    ].
    methodCategoriesWithUnassignedMethods size == 1 ifTrue:[
        methodCategoryWithUnassignedMethods := methodCategoriesWithUnassignedMethods anElement.
    ].

    isDefaultAnswer := false.
    (SourceCodeManagerUtilities yesToAllNotification notNil 
    and:[SourceCodeManagerUtilities yesToAllNotification isHandled]) ifTrue:[
        answer := isDefaultAnswer := true.
    ] ifFalse:[
        methodCategoriesWithUnassignedMethods size == 1 ifTrue:[
            unassignedMethods size == 1 ifTrue:[
                msg := 'The class ''%1'' contains the unassigned (loose) method: %6'.
            ] ifFalse:[
                msg := 'The class ''%1'' contains %3 unassigned (loose) method(s)'.
            ].
            msg := msg , '\(In the ''%4'' category).'.
        ] ifFalse:[
            msg := 'The class ''%1'' contains %3 unassigned (loose) methods in %5 categories.'.
        ].
        unassignedMethods size == 1 ifTrue:[
            msg := msg , '\\Move this method to the ''%2'' package ?'.
            msg := msg , '\\Hint: if this is meant to be an extension of another package,\move it to the appropriate package and checkIn the extension(s).'.
        ] ifFalse:[
            msg := msg , '\\Move those to the ''%2'' package ?'.
            msg := msg , '\\Hint: if these are meant to be extensions of another package,\move them to the appropriate package and checkIn the extensions.'.
        ].

        args := Array
                    with:aClass name allBold
                    with:clsPackage allBold
                    with:unassignedMethods size
                    with:methodCategoryWithUnassignedMethods
                    with:methodCategoriesWithUnassignedMethods size
                    with:unassignedMethods first selector allBold.

        SourceCodeManagerUtilities yesToAllNotification isHandled       
        ifTrue:[
            labels := #('Cancel' 'No' 'Browse' 'Yes to All' 'Yes').
            actions := #(#cancel false #browse #yesToAll true).
        ] ifFalse:[
            labels := #('Cancel' 'No' 'Browse' 'Yes').
            actions := #(#cancel false #browse true).
        ].

        (SuppressExtensionMethodConfirmation == true
        or:[ self isPackageWithoutExtensionMethodConfirmation:aClass package])
        ifTrue:[
            answer := true
        ] ifFalse:[    
            Dialog
                withOptoutOption:[ self rememberPackageWithoutExtensionMethodConfirmation:aClass package ]
                labelled:(SystemBrowser classResources string:'Do not show this dialog again (for this package)')
                andOptoutOption:[ SuppressExtensionMethodConfirmation := true ]
                labelled:(SystemBrowser classResources string:'Do not show this dialog again (for any package)')
                do:[
                    answer := OptionBox 
                                  request:(SystemBrowser classResources
                                            stringWithCRs:msg
                                            withArgs:args) 
                                  label:'Change packageID ?'
                                  image:(InfoBox iconBitmap)
                                  buttonLabels:(Dialog resources array:labels)
                                  values:actions
                                  default:true.
                ].
        ].            
        answer == #browse ifTrue:[
            UserPreferences systemBrowserClass
                browseMethods:unassignedMethods
                title:('Unassigned (loose) Methods in %1' bindWith:aClass name)
                sort:true.
            answer := #cancel.
        ].
"/        answer == #browseExtensions ifTrue:[
"/            UserPreferences current systemBrowserClass
"/                browseMethods:methodsFromOtherPackages
"/                title:('Extensions for %1' bindWith:aClass name)
"/                sort:true.
"/            answer := #cancel.
"/        ].
    ].

    answer == #cancel ifTrue:[
        AbortSignal raise
    ].
    answer == #yesToAll ifTrue:[
        SourceCodeManagerUtilities yesToAllNotification raiseWith:true.
        answer := true.
    ].

    "/ ok, move them over
    answer == true ifTrue:[
        "/ change all method's packageID to the classes packageId
        anyPackageChange := false.
        aClass instAndClassSelectorsAndMethodsDo:[:sel :mthd |
            mthd package == PackageId noProjectID ifTrue:[
                mthd makeLocalStringSource.
                mthd setPackage:clsPackage.
                anyPackageChange := true.
            ]
        ].
        aClass allPrivateClassesDo:[:eachPrivateClass |
            aClass setPackage:clsPackage.
            eachPrivateClass instAndClassSelectorsAndMethodsDo:[:sel :mthd |
                mthd package ~= clsPackage ifTrue:[
                    mthd makeLocalStringSource.
                    mthd setPackage:clsPackage.
                    anyPackageChange := true.
                ]
            ]
        ].
        anyPackageChange ifTrue:[
            aClass changed:#projectOrganization.
            Smalltalk changed:#projectOrganization with:(Array with:aClass). 
        ].
    ].
    ^ #base

    "Modified: / 18-11-2016 / 11:34:14 / cg"
!

checkTabSpaceConventionIn: aStream
    "This method checks whether data in given stream follows 
     tab-space discipline.

     More precisely, this checks that each line starts with zero or more
     tabs (16r9) followed by 0-7 spaces (16r32) followed by non-space non-tab
     character.
     This is done for two reasons:
      1) Makefiles (and Make.proto/Make.spec) files MUST not have leading spaces in their rules, but tabs.
        otherwise, make fails badly.

      2) for diff-comparison, a consisten tab/space discipline avoids false diff-positivies, which resulted from simple
        edititing with different editors with different tab conventions.
     "

    | checkStream |

    aStream isFileStream ifTrue:[
        aStream flush.
        checkStream := aStream pathName asFilename readStream .
    ] ifFalse:[
        aStream isExternalStream not ifTrue:[
            checkStream := aStream contents asString readStream.
        ].
    ].
    [
        [ checkStream atEnd ] whileFalse:[
            | line done nspaces |

            nspaces := 0.
            line := checkStream nextLine readStream.
            done := line atEnd.
            [ done ] whileFalse:[
                | c |

                c := line next.
                c == Character space ifTrue:[
                    nspaces := nspaces + 1.
                    nspaces == 8 ifTrue:[
"/                        self breakPoint: #jv info: 'Oops, every consecutive 8 spaces should be a tab!! CHECK THE CALLER NOW!!!!!!'.
"/ 
                        "/ There are only two solutions: either (i) relax the rule and do not make any conversion
                        "/ (ii) or write a sed script to fix all sources, commit and then debug why it is so,
                        "/ Otherwise, we merging will forever be pain in the...
                        self breakPoint: #cg info: 'Oops, every consecutive 8 spaces should be a tab!! CHECK THE CALLER NOW!!!!!!'.
                    ].
                ].
                c == Character tab  ifTrue:[
                    nspaces ~~ 0 ifTrue:[
"/                        self breakPoint: #jv info: 'Oops, spaces followed by tab!! CHECK THE CALLER NOW!!!!!!'.

                        "/ There are only two solutions: either (i) relax the rule and do not make any conversion
                        "/ (ii) or write a sed script to fix all sources, commit and then debug why it is so,
                        "/ Otherwise, we merging will forever be pain in the...
                        self breakPoint: #cg info: 'Oops, spaces followed by tab!! CHECK THE CALLER NOW!!!!!!'.
                    ].
                ].
                done := (c ~~ Character space  and:[c ~~ Character tab ]) or:[line atEnd].
            ].
        ].
    ] ensure:[
        checkStream close.
    ].

    "
    Good:
      AbstractSourceCodeManager checkTabSpaceConventionIn: #[9 32 32 32 32 97 ] readStream
      AbstractSourceCodeManager checkTabSpaceConventionIn: #[97 10 10 10 9 32 32 32 32 97 ] readStream

    Bad:
      AbstractSourceCodeManager checkTabSpaceConventionIn: #[32 32 32 32  32 32 32 32 97 ] readStream
      AbstractSourceCodeManager checkTabSpaceConventionIn: #[97 10 10 10 32 32 32 32 32 32 32 32 32 32 32 32 32 32 32 32 97 ] readStream
      AbstractSourceCodeManager checkTabSpaceConventionIn: #[97 10 10 10 9 32 32 32 32 32 32 32 32 97 ] readStream
      AbstractSourceCodeManager checkTabSpaceConventionIn: #[97 10 10 10 32 32 32 32 9 97 ] readStream


    "

    "Created: / 29-11-2013 / 12:01:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 29-11-2013 / 14:02:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

compileVersionMethod:methodName of:aClass for:newRevisionString

    |cls mthd code|

    cls := aClass theMetaclass.

    self assert: cls programmingLanguage isSmalltalk.

    code :=
methodName , '
    ^ ''' , newRevisionString , '''
'.

    mthd := Compiler 
                compile:code  
                forClass:cls
                inCategory:#documentation
                notifying:nil
                install:true
                skipIfSame:false
                silent:true.

    mthd notNil ifTrue:[
        mthd setPackage:aClass package
    ]
!

containerFromSourceInfo:info
    "given a sourceInfo, return the classes container"

    (info includesKey:#fileName) ifTrue:[
        ^ info at:#fileName
    ].
    (info includesKey:#expectedFileName) ifTrue:[
        ^ info at:#expectedFileName
    ].
    ^ (info at:#classFileNameBase) , '.st'

    "Modified: 12.9.1996 / 02:31:52 / cg"
!

createTempDirectory:packageDir forModule:moduleDir in:aParentDir
    "create a temp directory for checking out"

    |tempdir dir|

    "/ if CVSTempDir isNil, use current.
    OsError handle:[:ex |
        self reportError:('cannot create temporary directory').
        ^ nil.
    ] do:[
        tempdir := Filename newTemporaryDirectoryIn:aParentDir.
    ].

    moduleDir notNil ifTrue:[
        dir := tempdir construct:moduleDir.
        dir makeDirectory.

        packageDir notNil ifTrue:[
            dir := dir construct:packageDir.
            dir recursiveMakeDirectory.
        ].
        dir exists ifFalse:[
            (tempdir construct:moduleDir) recursiveRemove.
            tempdir recursiveRemove.
            self reportError:('cannot create temporary directory').
            ^ nil.
        ].
    ].
    ^ tempdir

    "self createTempDirectory:'fooPackage' forModule:'fooModule'"

    "Created: / 09-12-1995 / 19:14:35 / cg"
    "Modified: / 19-12-1995 / 16:13:02 / stefan"
    "Modified: / 29-08-2006 / 13:16:23 / cg"
!

directoryFromContainerPath:containerPath forClass:aClass
    "given a full path as in an RCS header, 
     extract the directory (i.e. package)."

    ^ self directoryFromContainerPath:containerPath forPackage:(aClass package)

    "
     CVSSourceCodeManager directoryFromContainerPath:'/files/CVS/stx/libbasic/Array.st' forClass:Array
    "
!

directoryFromContainerPath:containerPath forPackage:packageID
    "given a full path as in an RCS header, 
     extract the directory (i.e. package) within the module.
     Notice: 
        for top-level folder-only modules (like exept, smalltalk), 
        an empty string is returned."

    |path idx|

    path := self pathInRepositoryFrom:containerPath forPackage:packageID.
    path isNil ifTrue:[^ nil].

    "/ these are always UNIX filenames ...
    idx := path indexOf:$/.
    idx ~~ 0 ifTrue:[
        "/ be careful: for top-level module descriptions (folders),
        "/ the directory is empty
        (path indexOf:$/ startingAt:idx+1) == 0 ifTrue:[
            "/ there is no directory
            ^ ''
        ].
        path := path copyFrom:(idx + 1)
    ].

    "/ the code below used to be:
    "/     ^ path asFilename directoryName
    "/ however, that only works under UNIX, since
    "/ we MUST return a unix pathname here.
    "/ therefore, do what unix would do here ...

    idx := path lastIndexOf:$/.
    idx == 0 ifTrue:[
        "/ huh ?
        ^ path
    ].
    ^ path copyTo:(idx - 1)

    "
     CVSSourceCodeManager directoryFromContainerPath:'/files/CVS/stx/libbasic/Array.st'
    "

    "Created: / 25.9.1998 / 15:37:06 / cg"
    "Modified: / 25.9.1998 / 15:38:59 / cg"
!

directoryFromSourceInfo:info
    "given a sourceInfo, return the classes package directory"

    ^ info at:#directory ifAbsent:nil.

    "Created: / 23-08-2006 / 14:10:29 / cg"
!

isPackageWithoutExtensionMethodConfirmation:aPackageID
    "usually, the checkin dialog asks if unpackaged methods should be moved
     to the package. 
     This can be suppressed on a per-package base with a checkbox ('do not...again')
     in the dialog.
     This method returns true, if this was done for a particular package"

    ^ PackagesWithoutExtensionMethodConfirmation notNil
    and:[ PackagesWithoutExtensionMethodConfirmation includes:aPackageID]
!

moduleFromContainerPath:containerPath forClass:aClass
    "given a full path as in an RCS header, extract the module."

    ^ self moduleFromContainerPath:containerPath forPackage:aClass package

    "
     SourceCodeManager moduleFromContainerPath:'/files/CVS/stx/libbasic/Array.st' forClass:Array
    "
!

moduleFromContainerPath:containerPath forPackage:packageID
    "given a full path as in an RCS header, extract the module."

    |path idx|

    path := self pathInRepositoryFrom:containerPath forPackage:packageID.
    path isNil ifTrue:[^ nil].

    "/ these are always UNIX filenames
    idx := path indexOf:$/.
    idx == 0 ifTrue:[^ path].
    ^ path copyTo:(idx - 1)

    "
     SourceCodeManager moduleFromContainerPath:'/files/CVS/stx/libbasic/Array.st'
    "

    "Created: / 25.11.1995 / 18:42:20 / cg"
    "Modified: / 11.8.1998 / 23:01:24 / cg"
!

moduleFromSourceInfo:info
    "given a sourceInfo, return the classes module directory"

    ^ info at:#module.  "/ use the modules name as CVS module

    "Created: 6.2.1996 / 17:26:38 / cg"
    "Modified: 12.9.1996 / 02:32:23 / cg"
!

packageFromSourceInfo:info
    "given a sourceInfo, return the classes package directory"

    <resource: #obsolete>
    self obsoleteMethodWarning.
    ^ info at:#directory.

    "Created: / 06-02-1996 / 17:26:23 / cg"
    "Modified: / 23-08-2006 / 14:11:18 / cg"
!

pathInRepositoryFrom:containerPath forPackage:packageID
    "this tries to extract the path within a repository, 
     given some path as present in an RCS Header string.
     Typically, this ought to be that string directly; 
     however, if the repository directory is accessed via a symbolic link during
     ci/co, some systems extract different strings with co.
     One such system here had a symbolic link from /phys/ibm/CVS... to /file/CVS,
     and extracted sources had /phys/ibm/CVS in their header.
     Do not depend on the code below to work correctly all the time."

    |top lastTop idx|

    containerPath isNil ifTrue:[^ nil].

    packageID notNil ifTrue:[
        idx := containerPath indexOfSubCollection:((packageID copyReplaceAll:$: with:$/),'/').
        idx ~~ 0 ifTrue:[
            ^ containerPath copyFrom:idx.
        ].
    ].

    "/
    "/ the following is heuristics, in case that the packageID is not known
    "/ (should not be required)
    "/
    top := self repositoryTopDirectoryFromCVSRoot.
    top notNil ifTrue:[

        (containerPath startsWith:(top , '/')) ifTrue:[
            ^ containerPath copyFrom:(top size + 2).
        ].
        (containerPath startsWith:(top)) ifTrue:[
            ^ containerPath copyFrom:(top size + 1).
        ].

        "/ hardcase - the repository-filename in the versionInfo
        "/ does not match my repository top.
        "/ check for mangled prefix (happens with symbolic links)

        lastTop := '/' , top asFilename baseName, '/'.
        idx := containerPath indexOfSubCollection:lastTop.
        idx ~~ 0 ifTrue:[
            ('SourceCodeManager [warning]: repository path mismatch: ' , (containerPath copyTo:idx-1) , lastTop , ' vs. ' , top , '/') infoPrintCR.
            'SourceCodeManager [info]: warning: assuming that mismatch is ok.' infoPrintCR.
            ^ containerPath copyFrom:(idx + lastTop size).
        ]
    ].

    ^ nil

    "
     SourceCodeManager pathInRepositoryFrom:'/files/CVS/stx/libbasic/Array.st'    forPackage:Array package 
     SourceCodeManager pathInRepositoryFrom:'/phys/ibm/CVS/stx/libbasic/Array.st' forPackage:Array package 

     SourceCodeManager pathInRepositoryFrom:'/files/CVS/stx/libbasic/Array.st'    forPackage:nil          
     SourceCodeManager pathInRepositoryFrom:'/phys/ibm/CVS/stx/libbasic/Array.st' forPackage:nil 
    "

    "Created: / 25-11-1995 / 18:42:20 / cg"
    "Modified: / 21-06-2006 / 12:06:14 / cg"
    "Modified (comment): / 24-09-2012 / 11:10:50 / cg"
!

postCheckInClass:aClass
    "invoked after a checkIn"

    |p|

    (p := Project current) notNil ifTrue:[
        p condenseChangesForClassCheckin:aClass.
    ].

    "/
    "/ Set the source code for every method of the checked in class
    "/ Ensure that the source code for the compiled methods is the original one
    "/ Done to avoid checking out from the repository using binaryRevision and sourcePosition
    "/
    aClass instAndClassSelectorsAndMethodsDo:[:sel :mthd |
        mthd package = aClass package ifTrue:[
            mthd makeLocalStringSource.
        ]
    ].
    aClass allPrivateClassesDo:[:eachPrivateClass |
        eachPrivateClass instAndClassSelectorsAndMethodsDo:[:sel :mthd |
            mthd package = aClass package ifTrue:[
                mthd makeLocalStringSource.
            ].
        ]
    ].
!

postCheckInExtensionsForPackage:aPackageId
    "invoked after a checkIn"

    |p extensionMethods|

    (p := Project current) notNil ifTrue:[
        p condenseChangesForExtensionsCheckInInPackage:aPackageId.
    ].

    "/
    "/ Set the source code for every extension method of the checked in aPackageId
    "/ Ensure that the source code for the compiled methods is the original one
    "/ Done to avoid checking out from the repository
    "/
    extensionMethods := Smalltalk allExtensionsForPackage:aPackageId.
    extensionMethods do:[:mthd |
        mthd makeLocalStringSource.
    ].
!

rememberPackageWithoutExtensionMethodConfirmation:aPackageID
    "usually, the checkin dialog asks if unpackaged methods should be moved
     to the package. 
     This can be suppressed on a per-package base with a checkbox ('do not...again')
     in the dialog.
     This method adds a package to the set of non-asking packages"

    PackagesWithoutExtensionMethodConfirmation isNil ifTrue:[
        PackagesWithoutExtensionMethodConfirmation := Set new
    ].    
    PackagesWithoutExtensionMethodConfirmation add:aPackageID
!

reportError:msg
    |fullMsg|

    fullMsg := self class name,' [error]: ',msg.
    fullMsg errorPrintCR.
    SourceCodeManagerError raiseErrorString:fullMsg.

    "Created: / 29-08-2006 / 12:44:19 / cg"
!

repositoryTopDirectory
    "return the name of the repository"

    ^ nil

    "Created: 25.11.1995 / 18:38:59 / cg"
    "Modified: 12.9.1996 / 02:32:40 / cg"
!

sourceCacheDirectory
    "return the sourceCache directories name"

    |dir nm|

    (nm := self cacheDirectoryName) isNil ifTrue:[^ nil].

    (dir := nm asFilename) exists ifFalse:[
        OsError catch:[
            dir recursiveMakeDirectory.
        ].
        dir exists ifFalse:[
            ('SourceCodeManager [warning]: could not create cache dir "',CacheDirectoryName,'"') errorPrintCR.
            ^ nil
        ].
        "/
        "/ make it read/writable for everyone
        "/
        dir makeReadableForAll.
        dir makeWritableForAll.
        dir makeExecutableForAll.
    ].
    ^ dir

    "Modified: 10.1.1997 / 15:13:20 / cg"
!

sourceInfoOfClass:aClass
    "helper: return a classes sourceCodeInfo by extracting its
     versionString components."

    |cls clsPackage packageInfo revInfo actualSourceFileName classFileNameBase
     newInfo container expectedFileName
     directoryFromVersion moduleFromVersion fileNameFromVersion 
     directoryFromPackage moduleFromPackage repairedPath|

    cls := aClass theNonMetaclass.

    newInfo := IdentityDictionary new.

    "/
    "/ the info given by the classes source ...
    "/ (i.e. its revisionString)
    "/
    revInfo := cls revisionInfoOfManager: self.
    revInfo notNil ifTrue:[
        revInfo keysAndValuesDo:[:key :value |
            newInfo at:key put:value
        ]
    ].

    "/
    "/ the info given by the classes binary ...
    "/ (i.e. its package-ID)
    "/ if present, we better trust that one.
    "/ however, it only contains partial information (module:directory:libName).
    "/ (but is available even without a source)
    "/
    clsPackage := cls package.
    "/ hack: fix on-the-fly if corrupted top-module's package (FolderInfo)
    (clsPackage endsWith:':') ifTrue:[
        ('SourceCodeManager [warning]: fixing corrupted package identifier: ',clsPackage) infoPrintCR.
        clsPackage := clsPackage copyButLast asSymbol.
        cls setPackage:clsPackage.
    ].
    cls name = clsPackage ifTrue:[
        "/ very special - the top-module's FolderInfo
        newInfo at:#module put:clsPackage.
        newInfo at:#directory put:''.
    ] ifFalse:[        
        packageInfo := cls packageSourceCodeInfo.
        packageInfo notNil ifTrue:[
            packageInfo keysAndValuesDo:[:key :value |
                newInfo at:key put:value
            ]
        ]
    ].

    "/
    "/ no information
    "/
    (packageInfo isNil and:[revInfo isNil]) ifTrue:[
        ('SourceCodeManager [warning]: class `' , cls name , ''' has neither source nor compiled-in info') infoPrintCR.
        ^ nil
    ].

    "/
    "/ validate for conflicts
    "/ trust binary if in doubt
    "/ (in case some cheater edited the version string)
    "/
    revInfo notNil ifTrue:[
        container := revInfo at:#repositoryPathName ifAbsent:nil.
        (container notNil) ifTrue:[
            moduleFromVersion := self moduleFromContainerPath:container forClass:aClass.
            moduleFromVersion notNil ifTrue:[
                newInfo at:#module put:moduleFromVersion.
            ].
            directoryFromVersion := self directoryFromContainerPath:container forClass:aClass.
            directoryFromVersion notNil ifTrue:[
                newInfo at:#directory put:directoryFromVersion.
            ].
            fileNameFromVersion := container asFilename baseName.
            (fileNameFromVersion endsWith:',v') ifTrue:[
                fileNameFromVersion := fileNameFromVersion copyButLast:2.
            ].
            newInfo at:#fileName put:fileNameFromVersion.

            packageInfo notNil ifTrue:[
                (packageInfo includesKey:#directory) ifTrue:[
                    directoryFromPackage := packageInfo at:#directory.
                    moduleFromPackage := packageInfo at:#module.

                    (directoryFromPackage ~= directoryFromVersion 
                    or:[moduleFromPackage ~= moduleFromVersion]) ifTrue:[
                        (directoryFromVersion isNil or:[moduleFromVersion isNil]) ifTrue:[
                            directoryFromPackage ~= 'no package' ifTrue:[
                                moduleFromVersion notNil ifTrue:[
                                    ('SourceCodeManager [warning]: conflicting source infos (binary: ' 
                                        , (moduleFromPackage ? 'nil')  , '/' , (directoryFromPackage  ? 'nil')
                                        , ' vs. source:'
                                        , (moduleFromVersion ? 'nil') , '/' , (directoryFromVersion ? 'nil')
                                        , ')') infoPrintCR.
                                    ('SourceCodeManager [info]: using binary info: ' 
                                        , moduleFromPackage , '/' , directoryFromPackage
                                    ) infoPrintCR.
                                ].
                                newInfo at:#directory put:directoryFromPackage.
                                newInfo at:#module put:moduleFromPackage.
                            ]
                        ] ifFalse:[
                            directoryFromPackage ~= 'no package' ifTrue:[
                                ('SourceCodeManager [warning]: class: ', aClass name, ' - conflicting source infos (binary: ' 
                                    , moduleFromPackage  , '/' , directoryFromPackage
                                    , ' vs. source:'
                                    , moduleFromVersion  , '/' , directoryFromVersion, ')') infoPrintCR.
                            ]
                        ]
                    ]
                ]
            ].
        ]
    ].

    "/
    "/ the filename I'd expect from its name ...
    "/
    classFileNameBase := cls classBaseFilename.

    (newInfo includesKey:#fileName) ifFalse:[
        newInfo at:#fileName put:classFileNameBase
    ].

    "/ guess on the container
    ((newInfo includesKey:#directory) and:[newInfo includesKey:#module]) ifTrue:[
        |moduleDirectory pathInRepository|

        (newInfo at:#directory) isEmpty ifTrue:[
            moduleDirectory := (newInfo at:#module).
        ] ifFalse:[
            moduleDirectory := (newInfo at:#module) , '/' , (newInfo at:#directory).
        ].        
        container isNil ifTrue:[
            container := moduleDirectory , '/' , classFileNameBase , ',v'.
        ].
        pathInRepository := moduleDirectory , '/' , classFileNameBase.
        newInfo at:#pathInRepository put:pathInRepository.
    ].

    container notNil ifTrue:[
        newInfo at:#repositoryPathName put:container.
    ].

    (newInfo includesKey:#pathInRepository) ifFalse:[
        (fileNameFromVersion := newInfo at:#fileName ifAbsent:nil) notNil ifTrue:[
            cls projectDirectory notNil ifTrue:[
                (repairedPath := cls projectDirectory asFilename construct:fileNameFromVersion) exists ifTrue:[
                    Transcript showCR:('Oldstyle, broken or invalid version-info in class: ',cls name allBold,'. Please check').
                    newInfo at:#pathInRepository put:repairedPath pathName.
                ].
            ].
        ].
    ].

    "/ check ..
    revInfo notNil ifTrue:[
        actualSourceFileName := revInfo at:#fileName ifAbsent:nil.
        actualSourceFileName notNil ifTrue:[
            expectedFileName := classFileNameBase.
            actualSourceFileName ~= expectedFileName ifTrue:[
                ('SourceCodeManager [warning]: source of class ' , cls name , ' in ' , actualSourceFileName , ';') infoPrintCR.
                ('SourceCodeManager [info]: (expected: ' , expectedFileName , '); renamed or missing abbreviation ?') infoPrintCR.
                ('SourceCodeManager [info]: This may fail to autoload later if left unchanged.') infoPrintCR.
                newInfo at:#expectedFileName put:expectedFileName.
                newInfo at:#renamed put:true.
                classFileNameBase := actualSourceFileName
            ]
        ]
    ].

    newInfo at:#classFileNameBase put:(classFileNameBase asFilename nameWithoutSuffix).
    ^ newInfo

    "
     SourceCodeManager sourceInfoOfClass:Array
    "

    "Modified: / 22-10-2008 / 20:49:15 / cg"
    "Modified: / 19-07-2012 / 13:38:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateVersionMethod:selector of:aClass for:newRevisionString
    "{ Pragma: +optSpace }"

    "helper for the checkin procedure.
     Update my #version_XXX method, to now return newRevisionString."

    Class methodRedefinitionNotification answer:#keep do:[
        Class withoutUpdatingChangesDo:[
            |oldVersion|

"/            "/ must preserve the binary version, as methods still have the offsets into the old source file inside
"/            oldVersion := aClass revision.
"/            aClass setBinaryRevision:oldVersion.

            self compileVersionMethod:selector of:aClass for:newRevisionString.
        ]
    ].

    "Modified: / 29-09-2011 / 21:59:41 / cg"
    "Created: / 02-12-2011 / 14:18:14 / cg"
!

updateVersionMethodOf:aClass for:newRevisionString
    "{ Pragma: +optSpace }"

    "helper for the checkin procedure.
     Update my #version_XXX method, to now return newRevisionString."

    self updateVersionMethod:(self nameOfVersionMethodInClasses) of:aClass for:newRevisionString.

    "Updates the old method #version (if present)"
    true "(aClass theMetaclass includesSelector: Class nameOfOldVersionMethod)" ifTrue: [
        self updateVersionMethod:(Class nameOfOldVersionMethod) of:aClass for:newRevisionString.
    ].

    "Modified: / 02-12-2011 / 14:19:37 / cg"
! !

!AbstractSourceCodeManager class methodsFor:'queries'!

enabled

    "JV@2012-01-19: Quick hack, see senders. Is that what you mean?"

    ^self askFor:#shownInBrowserMenus

    "Created: / 19-01-2012 / 10:39:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initialRevisionString
    "redefinable in subclasses"

    ^ '1.0'
!

isContainerBased
    "true, if the SCM uses some kind of source container (,v files).
     False, if it is like a database or filesystem."

    ^ true

    "Created: / 21-12-2011 / 18:53:49 / cg"
!

isExperimental
    ^ false

    "Created: / 16-08-2006 / 11:22:47 / cg"
!

isExtensionsVersionMethodSelector: selector 
    "true if the given selector is for ANY of the manager's extensions version methods.
     These are all named extensionVersion_XXX, where XXX is manager-specific (CVS, P4, SVN etc.).
     For backward compatibility (times, when there was only one CVS sourcecode manager,
     the selector named 'extensionsVersion' alone also counts as a version method
     (which might be a somewhat bad idea in the long term...)."

    selector isNil ifTrue: [^ false].

    ^ selector == self nameOfVersionMethodForExtensions 
    or:[selector startsWith: self prefixOfVersionMethodForExtensionsSelector]

    "Modified (comment): / 09-07-2011 / 12:31:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 26-01-2012 / 14:30:45 / cg"
!

isResponsibleForModule:module
    ^ self repositoryInfoPerModule keys includes:module

    "Created: / 09-11-2006 / 15:24:57 / cg"
!

isResponsibleForPackage:aStringOrSymbol
    "Returns true if the manager can handle source code for given package.

     Answering true does not imply that receiver is configured default
     manager for that package, it only means that it has a repository
     configured for given package."

    self subclassResponsibility

    "Modified (comment): / 11-10-2011 / 11:58:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 01-12-2011 / 20:56:32 / cg"
!

isRevision:revision1 after:revision2
    "true, if the dotted revision string revision1 is > than revision2"

    ^ (revision1 compareAsVersionNumberWith:revision2) > 0

    "
     SourceCodeManager isRevision:'1' after:'2'      
     SourceCodeManager isRevision:'2' after:'1'      
     SourceCodeManager isRevision:'1.1' after:'2.1.2' 
     SourceCodeManager isRevision:'2.1' after:'1.2.3' 
     SourceCodeManager isRevision:'1' after:'1.1'    
     SourceCodeManager isRevision:'1.1' after:'1'    
     SourceCodeManager isRevision:'1.1' after:'1.2' 
     SourceCodeManager isRevision:'1.10' after:'1.2' 
     SourceCodeManager isRevision:'1.2' after:'1.1' 
     SourceCodeManager isRevision:'1.2.3.4' after:'1.2.3.5' 
     SourceCodeManager isRevision:'1.2.3.4' after:'1.2.3.3' 
     SourceCodeManager isRevision:'1.2.3.4' after:'1.2.3'   
     SourceCodeManager isRevision:'1.2.3.4' after:'1.2.3.4'   
    "

    "Created: / 21-12-2011 / 19:15:35 / cg"
!

isRevision:revision1 sameOrAfter:revision2
    "true, if the dotted revision string revision1 is >= than revision2"

    ^ (revision1 compareAsVersionNumberWith:revision2) >= 0

    "Created: / 26-09-2012 / 18:15:58 / cg"
!

isVersionMethodForExtensionsSelector: selector
    <resource: #obsolete>
 
    "true if the given selector is for one of the manager's extensions version methods.
     These are all named extensionVersion_XXX, where XXX is manager-specific (CVS, P4, SVN etc.).
     For backward compatibility (times, when there was only one CVS sourcecode manager,
     the selector named 'extensionsVersion' alone also counts as a version method
     (which might be a somewhat bad idea in the long term...)."

    self obsoleteMethodWarning:'use isExtensionsVersionMethodSelector'.
    ^self isExtensionsVersionMethodSelector: selector
!

isVersionMethodSelector: selector 
    "true if the given selector is for one of the manager's version methods.
     These are all named version_XXX, where XXX is manager-specific (CVS, P4, SVN etc.).
     For backward compatibility (times, when there was only one CVS sourcecode manager,
     the selector named 'version' alone also counts as a version method
     (which might be a somewhat bad idea in the long term...)."

    selector isNil ifTrue: [^ false].

    ^ selector == self nameOfVersionMethodInClasses 
    or:[selector startsWith: self prefixOfVersionMethodSelector]

    "Modified (comment): / 09-07-2011 / 12:31:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 29-09-2011 / 14:56:15 / cg"
!

managerTypeName

    "Answers version manager name suitable for UI,
     i,e., CVS, SubVersion, Perforce"

    ^ self subclassResponsibility

    "Modified (comment): / 03-10-2011 / 13:27:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

managerTypeNameShort

    "Answers short version manager name suitable for UI,
     i,e., CVS, SVN, P4. Used in cases where sorter strings
     are preferred. Defaults to #managerTypeName"

    ^self managerTypeName

    "Created: / 03-10-2011 / 13:28:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

nameOfVersionMethodForExtensions
    "that is the old name; now, we use extensionsVersion_<SCM>"

    ^ #'extensionsVersion'

    "Modified (comment): / 29-09-2011 / 13:27:04 / cg"
!

nameOfVersionMethodInClasses
    "that is the old name; now, we use version_<SCM>"

    ^ #'version'

    "Modified (comment): / 29-09-2011 / 13:27:09 / cg"
!

performsCompilabilityChecks
    "Should return true, if the manager itself performs
     compilability checks, false otherwise.

     Basically a hack, see my senders..."

    ^false"/by default

    "Created: / 11-04-2012 / 16:54:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

prefixOfVersionMethodForExtensionsSelector
    "all scm-extensionsVersion methods start with this prefix"

    ^ 'extensionsVersion_'

    "Created: / 26-01-2012 / 14:29:32 / cg"
!

prefixOfVersionMethodSelector
    "all scm-version methods start with this prefix"

    ^ 'version_'

    "Created: / 29-09-2011 / 13:26:29 / cg"
!

revisionAfter:aRevisionString
    "generate the next revision number after the given number"

    |idx|

    idx := aRevisionString lastIndexOf:$..
    idx == 0 ifTrue:[
        ^ ((Integer readFrom:aRevisionString) + 1) printString
    ].

    ^ (aRevisionString copyTo:idx) , ((Integer readFrom:(aRevisionString copyFrom:(idx+1)))+1) printString

    "
     SourceCodeManager revisionAfter:'1.2.3.4' 
     SourceCodeManager revisionAfter:'123'  
     SourceCodeManager revisionAfter:'1.24'  
    "

    "Created: 20.11.1995 / 12:54:05 / cg"
    "Modified: 12.9.1996 / 02:33:03 / cg"
!

settingsApplicationClass
    "link to my settings application (needed for the settings dialog"

    self subclassResponsibility

    "Created: / 19-04-2011 / 12:43:54 / cg"
    "Modified: / 19-04-2011 / 13:52:45 / cg"
!

sourceCodeManagerForPackage:aPackageID
    |defaultManager module mgr|

    "JV@2012-01-23: If source code management is disabled, return #()."
    defaultManager := Smalltalk at:#SourceCodeManager.
    defaultManager isNil ifTrue:[ "eg. disabled" ^ nil ].

    aPackageID notNil ifTrue:[
        "/ see if there is a package-specific manager
        (mgr := self managerForPackage:aPackageID) notNil ifTrue:[^ mgr].

        "/ more or less obsolete now - I know which manager is to be used per package
        "/        self availableManagers do:[:mgr |
        "/            (mgr isResponsibleForPackage:aPackageID) ifTrue:[^ mgr ].
        "/        ].

        "/ old stuff: see if there is a module-specific manager
        module := aPackageID upTo:$:.
        self availableManagers do:[:mgr |
            (mgr isResponsibleForModule:module) ifTrue:[^ mgr ].
        ]
    ].
    ^ defaultManager

    "
     self sourceCodeManagerForPackage:'stx:libbasic'.
     self sourceCodeManagerForPackage:'stx:libboss'.
     self managerForMatchingModule:'stx:libba*' put:SVNSourceCodeManager.
     self sourceCodeManagerForPackage:'stx:libbasic'.
     self sourceCodeManagerForPackage:'stx:libboss'.
    "

    "Modified: / 18-04-2011 / 19:53:03 / cg"
    "Modified: / 23-01-2012 / 19:44:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

supportsCheckinLogMessages
    "true, if log-messages are supported"

    ^ true

    "Created: / 21-12-2011 / 18:02:34 / cg"
!

versionInfoClass

    ^VersionInfo
!

versionMethodKeyword

    "Answers the keyword used by the version management system to
     expand a current version in a file (_without_ dollars). For
     CVS it is 'Header', for SVN 'Id', others may use different
     keywords. If nil is returned, then the version management does
     not use any keyword."

    "/TODO: Now, 'Header' is returned for backward compatibility. In future
    "/it should be changed to self subclassResponsibility

    ^'Header'

    "Created: / 27-09-2011 / 14:52:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

versionMethodTemplateForJavaScript
    ^ self versionMethodTemplateForJavaScriptFor:(self nameOfVersionMethodInClasses)

    "
     CVSSourceCodeManager versionMethodTemplateForJavaScript
    "

    "Created: / 19-08-2011 / 01:20:28 / cg"
!

versionMethodTemplateForJavaScriptFor:aSelector
    "do not make the thing below a single string - otherwise
     it would get expanded by the sourcecodemanager, which we do not want here"

    ^
"'function ',"aSelector,'() {
    return "$' , self versionMethodKeyword , '$";
}'

    "Created: / 19-08-2011 / 01:20:56 / cg"
    "Modified: / 20-09-2012 / 12:13:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

versionMethodTemplateForRuby
    ^ self versionMethodTemplateForRubyFor:(self nameOfVersionMethodInClasses)

    "
     CVSSourceCodeManager versionMethodTemplateForRuby
    "
!

versionMethodTemplateForRubyFor:aSelector
    "do not make the thing below a single string - otherwise
     it would get expanded by the sourcecodemanager, which we do not want here"

    ^
'def self.',aSelector,'()
    return "$' , self versionMethodKeyword , '$"
end'

    "Modified (comment): / 19-08-2011 / 01:19:40 / cg"
    "Modified: / 27-09-2011 / 16:46:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

versionMethodTemplateForSmalltalk
    ^ self versionMethodTemplateForSmalltalkFor:(self nameOfVersionMethodInClasses)

    "
     CVSSourceCodeManager versionMethodTemplateForSmalltalk
    "
!

versionMethodTemplateForSmalltalkFor:aSelector
    "do not make the thing below a single string - otherwise
     it would get expanded by the sourcecodemanager, which we do not want here"

    ^
aSelector,'
    ^ ''$', self versionMethodKeyword , '$''
'

    "Modified (comment): / 19-08-2011 / 01:19:08 / cg"
    "Modified: / 27-09-2011 / 16:46:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractSourceCodeManager class methodsFor:'source code access'!

basicCheckinClass:aClass fileName:classFileName directory:packageDir module:moduleDir logMessage:logMessage force:force
    "low level checkin of a class into the source repository. Does not deal with any version method updates,
     only does the checkin, using a temporary file.
     Return true if ok, false if not."

    aClass isPrivate ifTrue:[
        self reportError:'refuse to check in private classes.'.
        ^ false.
    ].
    ^ self 
        withClass:aClass 
        classFileName:classFileName 
        filedOutToTemporaryFileDo:[:tempFile |
            self 
                checkinClass:aClass
                fileName:classFileName 
                directory:packageDir 
                module:moduleDir
                source:(tempFile name)
                logMessage:logMessage
                force:force.
        ].

    "
     SourceCodeManager checkinClass:Array
    "

    "Modified: / 25-09-1997 / 12:16:00 / stefan"
    "Created: / 21-12-2011 / 19:30:06 / cg"
!

checkinClass:aClass fileName:classFileName directory:packageDir module:moduleDir logMessage:logMessage
    "checkin of a class into the source repository.
     Return true if ok, false if not."

    ^ self
        checkinClass:aClass 
        fileName:classFileName 
        directory:packageDir 
        module:moduleDir 
        logMessage:logMessage
        force:false

    "Modified: 11.9.1996 / 16:15:43 / cg"
!

checkinClass:aClass fileName:classFileName directory:packageDir module:moduleDir logMessage:logMessage force:force
    "checkin of a class into the source repository.
     Return true if ok, false if not."

    |theMetaclass className answer allLabel allValue 
     nameOfVersionMethodInClasses revision question|

    className := aClass name.
    theMetaclass := aClass theMetaclass.
    nameOfVersionMethodInClasses := self nameOfVersionMethodInClasses.

    (revision := aClass revisionOfManager:self) isNil ifTrue:[ 
        force ifFalse:[
            ('SourceCodeManager [warning]: class "%1" has no revision string (for %2)' bindWith:className with:self managerTypeName) errorPrintCR.

            AbortAllOperationWantedQuery query ifTrue:[
                allLabel := #('Cancel All').
                allValue := #(cancelAll).
            ] ifFalse:[
                allLabel := #().
                allValue := #().
            ].

            ((theMetaclass includesSelector:#version)
               or:[theMetaclass includesSelector: nameOfVersionMethodInClasses]) ifTrue:[

                (theMetaclass includesSelector: nameOfVersionMethodInClasses) ifTrue:[
                    question := 'Class "%1" has a broken revision string (for %2).\\Checkin as newest?' 
                ] ifFalse:[
                    question := 'Class "%1" has no revision string (for %2).\\Initial Checkin?' 
                ].
                answer := OptionBox 
                            request:(question bindWith:className allBold with:self managerTypeName) withCRs
                            label:'Confirm'
                            buttonLabels:(allLabel , #('Cancel' 'Browse & Cancel' 'CheckIn')) 
                            values:(allValue , #(false #browse #checkIn))
                            default:#checkIn.
                answer == #browse ifTrue:[
                    UserPreferences browserClass openInClass:theMetaclass.
                    AbortOperationRequest raise. ^ false
                ].    
            ] ifFalse:[
                force ifTrue:[
                    revision := self newestRevisionInFile:classFileName directory:packageDir module:moduleDir.
                    revision isNil ifTrue:[
                        revision := self initialRevisionString   "/ initial checkin
                    ].
                ] ifFalse:[
                    revision := self initialRevisionString   "/ initial checkin
                ].
                answer := #create.
"/                answer := OptionBox 
"/                            request:('Class %1 has no revision string.\\Check in as newest ?' bindWith:className allBold) withCRs
"/                            label:'Confirm'
"/                            buttonLabels:(allLabel , #('Cancel' 'CheckIn' 'Create & CheckIn')) 
"/                            values:(allValue , #(false #checkIn #create))
"/                            default:#create.
            ].
            answer == false ifTrue:[ AbortOperationRequest raise. ^ false ].
            answer == #cancelAll ifTrue:[ AbortAllOperationRequest raise. ^ false ].
            answer == #create ifTrue:[ 
                self updateVersionMethodOf:aClass for:(self revisionStringFor:aClass inModule:moduleDir directory:packageDir container:classFileName revision:revision).
            ].
        ]
    ].

    "Ensure that the method #version_XXX is present before checking in XXX. 
     It will be missing when checking in classes with only the old method #version"

    ^ self basicCheckinClass:aClass fileName:classFileName directory:packageDir module:moduleDir logMessage:logMessage force:force.

    "
     SourceCodeManager checkinClass:Array
    "

    "Created: / 11-09-1996 / 16:15:17 / cg"
    "Modified: / 25-09-1997 / 12:16:00 / stefan"
    "Modified: / 30-04-2016 / 12:59:59 / cg"
!

checkinClass:aClass logMessage:logMessage
    "checkin of a class into the source repository.
     Return true if ok, false if not."

    |sourceInfo packageDir moduleDir classFileName|

    sourceInfo := self sourceInfoOfClass:aClass.
    sourceInfo isNil ifTrue:[
        self reportError:('no sourceInfo for class: ' , aClass name).
        ^ false
    ].

    packageDir := self directoryFromSourceInfo:sourceInfo.
    moduleDir := self moduleFromSourceInfo:sourceInfo.  "/ use the modules name as CVS module
    classFileName := self containerFromSourceInfo:sourceInfo.

    ^ self 
        checkinClass:aClass 
        fileName:classFileName 
        directory:packageDir 
        module:moduleDir 
        logMessage:logMessage


    "
     SourceCodeManager checkinClass:Array logMessage:'foo'
    "

    "Created: / 06-11-1995 / 18:56:00 / cg"
    "Modified: / 29-08-2006 / 12:46:28 / cg"
!

getFile:fileName revision:revision directory:packageDir module:moduleDir 
    |s contents|

    s := self 
            streamForFile:fileName 
            revision:revision 
            directory:packageDir
            module:moduleDir.
    s isNil ifTrue:[^ nil].
    contents := s contentsAsString.
    s close.
    ^ contents

    "
     SourceCodeManager 
        getFile:'Make.spec' 
        revision:#newest 
        directory:'libbasic2' 
        module:'stx'
    "

    "Created: / 29-08-2006 / 15:47:08 / cg"
!

getMostRecentSourceStreamForClassNamed:aClassName
    "given a class, return an open stream to its most recent source
     (not knowing anything about its version).
     Used when autoloading classes."

    ^ self
        getMostRecentSourceStreamForClassNamed:aClassName 
        inPackage:nil
!

getMostRecentSourceStreamForClassNamed:aClassName inPackage:forcedPackage
    "given a class, return an open stream to its most recent source
     (not knowing anything about its version).
     Used when autoloading classes or to compare a classes source with the most
     recent found in the repostitory.
     The forcePackage argument passes the classes package information
     and is only required when autoloading or when the class is not already
     present (i.e. there is no way to extract the package info).
     If nil, the package is extracted from the class - which must exist."

    |cls sourceInfo classFileName packageDir moduleDir s components i|

    cls := Smalltalk classNamed:aClassName.
    cls notNil ifTrue:[
        sourceInfo := self sourceInfoOfClass:cls.
    ].
    sourceInfo notNil ifTrue:[
        packageDir := self directoryFromSourceInfo:sourceInfo.
        moduleDir := self moduleFromSourceInfo:sourceInfo.  "/ use the modules name as CVS module
        classFileName := self containerFromSourceInfo:sourceInfo.
    ] ifFalse:[
        classFileName := (Smalltalk fileNameForClass:aClassName), '.st'.
        packageDir := Smalltalk sourceDirectoryNameOfClass:aClassName.
        packageDir notNil ifTrue:[
            (packageDir startsWith:'stx/') ifTrue:[
                "this is a backward compatibility leftover - will vanish"
                packageDir := packageDir copyFrom:5.
            ] ifFalse:[
                i := packageDir indexOf:$:.
                i ~~ 0 ifTrue:[
                    moduleDir := packageDir copyTo:i-1.
                    packageDir := packageDir copyFrom:i+1
                ]
            ]
        ].
        moduleDir isNil ifTrue:[
            moduleDir := 'stx'
        ].
    ].

    packageDir isNil ifTrue:[
        forcedPackage isNil ifTrue:[
            'SourceCodeManager [warning]: could not extract packageDir' errorPrintCR.
            ^ nil
        ].
        moduleDir := forcedPackage asPackageId module.
        packageDir := forcedPackage asPackageId directory.
    ].

    s := self 
        streamForClass:nil
        fileName:classFileName 
        revision:#newest 
        directory:packageDir 
        module:moduleDir
        cache:false.

    s isNil ifTrue:[
        "/ guessed moduleDir ?
        
        sourceInfo isNil ifTrue:[
            components := Filename components:packageDir.
            moduleDir := components first.
            packageDir := (Filename fromComponents:(components copyFrom:2)) asString.
            s := self 
                streamForClass:nil
                fileName:classFileName 
                revision:#newest 
                directory:packageDir 
                module:moduleDir
                cache:false.
        ]
    ].
    ^ s.

    "Created: / 12-10-1996 / 17:22:54 / cg"
    "Modified: / 06-10-2006 / 16:17:33 / cg"
!

getMostRecentSourceStreamForFile:aFileName inPackage:aPackage
    "given a filename, return an open stream to its most recent contents
     (not knowing anything about its version).
     Used when autoloading extensions or to compare a classes source with the most
     recent found in the repostitory."

    |directory module|

    module := aPackage asPackageId module.
    directory := aPackage asPackageId directory.

    ^ self 
        streamForFile:aFileName 
        revision:#newest 
        directory:directory 
        module:module.

    "Created: / 12-10-1996 / 17:22:54 / cg"
    "Modified: / 29-08-2006 / 15:49:02 / cg"
!

getSourceStreamFor:aClass
    "extract a classes source code and return an open readStream on it.
     The classes source code is extracted using the revision and the sourceCodeInfo,
     which itself is extracted from the classes packageString."

    ^ self getSourceStreamFor:aClass revision:nil

    "Created: 12.10.1996 / 17:21:03 / cg"
    "Modified: 12.10.1996 / 17:22:02 / cg"
!

getSourceStreamFor:aClass revision:aRevisionStringOrNil
    "extract a classes source code and return an open readStream on it.
     A revision of nil selects the current (in image) revision.
     The classes source code is extracted using the revision and the sourceCodeInfo,
     which itself is extracted from the classes packageString."

    ^ self getSourceStreamFor:aClass revision:aRevisionStringOrNil cache:true
!

getSourceStreamFor:aClass revision:aRevisionStringOrNil cache:cache
    "extract a classes source code and return an open readStream on it.
     A revision of nil selects the current (in image) revision.
     The classes source code is extracted using the revision and the sourceCodeInfo,
     which itself is extracted from the classes packageString."

    |classFileName binaryRevision revision revisionUsed
     packageDir moduleDir sourceInfo revForMeOrNil|

    aRevisionStringOrNil == #newest ifTrue:[
        ^ self getMostRecentSourceStreamForClassNamed:(aClass theNonMetaclass name).
    ].

    (revisionUsed := aRevisionStringOrNil) isNil ifTrue:[
        revision := aClass revisionOfManager:self.
        binaryRevision := aClass binaryRevision.
        binaryRevision isNil ifTrue:[
            revision isNil ifTrue:[
                ('SourceCodeManager [warning]: class "%1" has no revision string' bindWith:aClass name) infoPrintCR.
                ^ nil.
            ].
            revisionUsed := revision
        ] ifFalse:[
            "/ see if this is a versionString for me (i.e. if I can extract my version string from it)
            revForMeOrNil := self revisionInfoFromString:aClass binaryRevisionString.
            revForMeOrNil isNil ifTrue:[
                revision isNil ifTrue:[
                    ('SourceCodeManager [info]: binary revision "%3" of "%1" is not for %4 - cannot extract version' 
                        bindWith:aClass name
                        with:revision with:binaryRevision
                        with:self name) infoPrintCR.
                ] ifFalse:[
                    ('SourceCodeManager [info]: binary revision "%3" of "%1" is not for %4 - trusting revision %2' 
                        bindWith:aClass name
                        with:revision with:binaryRevision
                        with:self name) infoPrintCR.
                ].
                ^ nil
            ] ifFalse:[
                revision ~= binaryRevision ifTrue:[
                    ('SourceCodeManager [info]: "%1" has %4-revision (%2) vs. binary revision (%3) - trusting binaryRevision' 
                        bindWith:aClass name
                        with:revision with:binaryRevision
                        with:self name) infoPrintCR.
                    "/ self halt.
                ].
                revisionUsed := binaryRevision.
            ].
        ]
    ].

    sourceInfo := self sourceInfoOfClass:aClass.
    sourceInfo isNil ifTrue:[
"/       ('SourceCodeManager [warning]: no sourceInfo for class "%1"' bindWith:aClass name) infoPrintCR.
"/        ^ nil
        "/ let's hope...
        classFileName := aClass classFilename.
        packageDir := aClass package asPackageId directory.
        moduleDir := aClass package asPackageId module.
    ] ifFalse:[
        packageDir := self directoryFromSourceInfo:sourceInfo.
        packageDir isNil ifTrue:[
            packageDir := aClass package asPackageId directory.
            moduleDir := aClass package asPackageId module.
        ] ifFalse:[
            moduleDir := self moduleFromSourceInfo:sourceInfo.  "/ use the modules name as CVS module
        ].
        classFileName := self containerFromSourceInfo:sourceInfo.
    ].
    ^ self 
        streamForClass:aClass
        fileName:classFileName 
        revision:revisionUsed 
        directory:packageDir 
        module:moduleDir
        cache:cache

    "Created: / 12-10-1996 / 17:21:52 / cg"
    "Modified: / 29-09-2011 / 22:02:55 / cg"
!

loadPackageWithId:aPackageId fromRepositoryAsAutoloaded: doLoadAsAutoloaded
    "Should be redefined by subclasses.
     Raise an exception, if load failed."

    PackageLoadError raiseRequestWith:aPackageId errorString:'unimplemented feature, load package'.
!

streamForFile:fileName revision:revision directory:packageDir module:moduleDir 
    ^ self
        streamForClass:nil
        fileName:fileName 
        revision:revision 
        directory:packageDir 
        module:moduleDir
        cache:true

    "
     SourceCodeManager 
        streamForFile:'Make.spec' 
        revision:#newest 
        directory:'libbasic2' 
        module:'stx'
    "

    "Created: / 29-08-2006 / 15:41:43 / cg"
!

withClass:aClass classFileName:classFileName filedOutToTemporaryFileDo:aBlock
    "helper. fileout and eval aBlock"

    |tempDir tempFile ok packageMode filter|

    packageMode := self checkMethodPackagesOf:aClass.
    packageMode == #base ifTrue:[
        filter := [:mthd | mthd package == aClass package].
    ].

    tempDir := Filename newTemporaryDirectory.
    ok := false.
    [
        |aStream|

        tempFile := tempDir construct:classFileName.
        [
            aStream := tempFile writeStream.
        ] on:FileStream openErrorSignal do:[:ex|
            self reportError:('temporary fileout failed').
            ^ false
        ].

        Method flushSourceStreamCache.
        Class fileOutErrorSignal handle:[:ex |
            aStream close.
            self reportError:('fileout failed (',ex description,')').
            ^ false
        ] do:[
            self 
                fileOutSourceCodeOf:aClass 
                on:aStream 
                withTimeStamp:false 
                withInitialize:true 
                withDefinition:true
                methodFilter:filter.
        ].
        aStream close.

        tempFile exists ifFalse:[
            self reportError:'temporary fileout failed'.
            ^ false.
        ].
        ok := aBlock value:tempFile 
    ] ensure:[
        tempDir recursiveRemove
    ].
    ^ ok

    "
     SourceCodeManager checkinClass:Array
    "

    "Modified: / 25-09-1997 / 12:16:00 / stefan"
    "Modified: / 20-08-2011 / 14:52:01 / cg"
    "Created: / 25-07-2012 / 19:38:23 / cg"
! !

!AbstractSourceCodeManager class methodsFor:'source code administration'!

fileOutSourceCodeExtensions: extensions package: package on: stream
    "File out extension methods for given package on stream. 
     Not programming-language safe  - can handle smalltalk methods."

    ^self fileOutSourceCodeExtensions: extensions package: package on: stream version: true.

    "Created: / 02-02-2012 / 15:30:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-11-2012 / 23:51:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileOutSourceCodeExtensions: extensions package: pkg on: stream version: versionIt
    "File out extension methods for given package on stream. 
     Not programming-language safe  - can handle smalltalk methods."

    | source |

    self assert: (extensions allSatisfy:[:m|m programmingLanguage isSmalltalk]).
    source := self utilities sourceCodeForExtensions:extensions package:pkg forManager:self.
    source isWideString ifTrue:[
        | s |

        s:= EncodedStream stream: stream encoder: (CharacterEncoder encoderForUTF8).      
        s nextPutAll: '"{ Encoding: utf8 }"'; cr;cr.
        s nextPutAll: source.
    ] ifFalse:[
        stream nextPutAll: source.
    ].

    self checkTabSpaceConventionIn: stream.

    "Created: / 07-11-2012 / 23:50:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 29-11-2013 / 13:10:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileOutSourceCodeOf:aClass on:aStream

    self withSourceRewriteHandlerDo:[
        aClass fileOutOn:aStream withTimeStamp:false.
    ].
!

fileOutSourceCodeOf:aClass on:aStream 
      withTimeStamp:withTimeStamp withInitialize:withInitialize withDefinition:withDefinition
      methodFilter:methodFilter

    | filter |
    "JV@2012-02-02: Do not fileout extensionVersion methods, that one is filed out
     when extensions are filed out."
    (aClass inheritsFrom: ProjectDefinition) ifTrue:[
        filter := [:m| (methodFilter value: m) 
                        and:[ (self isExtensionsVersionMethodSelector:m selector) not
                         "m selector ~~ self nameOfVersionMethodForExtensions"] 
                  ]
    ] ifFalse:[
        filter := methodFilter.
    ].

    self withSourceRewriteHandlerDo:[
        | writer |

        writer := aClass programmingLanguage sourceFileWriterClass new.
        writer generatingSourceForOriginal:true.
        writer 
            fileOut:aClass 
            on:aStream 
            withTimeStamp:withTimeStamp 
            withInitialize:withInitialize 
            withDefinition:withDefinition 
            methodFilter:methodFilter 

"/        aClass fileOutOn:aStream 
"/               withTimeStamp:withTimeStamp 
"/               withInitialize:withInitialize 
"/               withDefinition:withDefinition
"/               methodFilter:filter.
    ].

    self checkTabSpaceConventionIn: aStream.

    "Modified: / 22-01-2015 / 09:39:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

getExistingContainersInModule:aModule directory:aPackage
    "{ Pragma: +optSpace }"

    "return a collection containing the names of existing containers"

    ^ self subclassResponsibility

    "Created: / 23-08-2006 / 14:12:07 / cg"
!

getExistingDirectoriesInModule:aModule
    "{ Pragma: +optSpace }"

    "return a collection containing the names of existing packages"

    ^ self subclassResponsibility

    "Created: / 23-08-2006 / 14:13:52 / cg"
!

getExistingModules
    "{ Pragma: +optSpace }"

    "return a collection containing the names of existing modules"

    ^ self subclassResponsibility

    "Modified: / 29.1.1997 / 18:57:29 / cg"
    "Created: / 20.5.1998 / 19:38:23 / cg"
!

knownTagsAndRevisionsFor:aClass
    "retrieve a list of symbolic tags -> versionNr associations
     known for that class.
     I.e. which tags/symbolic versions exist, and which revision-nr is attached to it"

    |log|

    log := aClass sourceCodeManager revisionLogOf:aClass fromRevision:nil toRevision:nil finishAfter:20.
    log isNil ifTrue:[
        SourceCodeManagerError 
            raiseRequestWith:aClass
            errorString: 'Could not fetch log (cvs connection error?)'.
        ^ #()
    ].
    ^ (log at:#symbolicNames ifAbsent:[ #() ]).

    "Created: / 08-02-2011 / 10:18:00 / cg"
!

knownTagsFor:aClass
    "retrieve a list of symbolic tags known for that class.
     I.e. which tags/symbolic versions exist"

    |tagRevisionMapping|

    tagRevisionMapping := self knownTagsAndRevisionsFor:aClass.
    tagRevisionMapping isEmptyOrNil ifTrue:[^ tagRevisionMapping].
    ^ tagRevisionMapping keys

    "Modified: / 08-02-2011 / 10:18:34 / cg"
!

newestRevisionInFile:classFileName directory:packageDir module:moduleDir
    "return the newest revision found in a container.
     Return nil on failure."

    |log|

    log := self
            revisionLogOf:nil 
            fromRevision:0 
            toRevision:0 
            fileName:classFileName 
            directory:packageDir 
            module:moduleDir.

    log isNil ifTrue:[^ nil].
    ^ log at:#newestRevision ifAbsent:nil

    "
     SourceCodeManager newestRevisionInFile:'Array.st' directory:'libbasic' module:'stx'       
    "

    "Modified: 10.1.1997 / 13:31:42 / cg"
!

newestRevisionLogEntryOf:aClass
    "return the newest revisions log found in the repository.
     Return nil on failure."

    ^ self revisionLogOf:aClass fromRevision:0 toRevision:0.

    "
     SourceCodeManager newestRevisionLogEntryOf:Array       
     SourceCodeManager newestRevisionLogEntryOf:Connection 
    "

    "Modified: 10.1.1997 / 13:30:36 / cg"
    "Created: 29.1.1997 / 18:50:12 / cg"
!

newestRevisionOf:aClass
    "return the newest revision (as string) found in the repository.
     Return nil on failure."

    |sourceInfo packageDir moduleDir classFileName|

    sourceInfo := self sourceInfoOfClass:aClass.
    sourceInfo isNil ifTrue:[^ nil].

    packageDir := self directoryFromSourceInfo:sourceInfo.
    packageDir isNil ifTrue:[^ nil].
    moduleDir := self moduleFromSourceInfo:sourceInfo.  "/ use the modules name as CVS module
    classFileName := self containerFromSourceInfo:sourceInfo.
    classFileName isNil ifTrue:[^ nil].
    
    ^ self newestRevisionInFile:classFileName directory:packageDir module:moduleDir

"/    |log|
"/
"/    log := self revisionLogOf:aClass fromRevision:0 toRevision:0.
"/    log isNil ifTrue:[^ nil].
"/    ^ log at:#newestRevision ifAbsent:nil

    "
     SourceCodeManager newestRevisionOf:Array       
     SourceCodeManager newestRevisionOf:Connection 
    "

    "Modified: / 20-08-2011 / 14:56:04 / cg"
!

oldestRevisionLogEntryOf:aClass
    "return the oldest revisions log found in the repository.
     Return nil on failure.
     Can be used to determine the time of initial checkin or the original author"

    |log|
    
    log := self revisionLogOf:aClass.
    ^  (log at:#revisions) last.
    
    "
     SourceCodeManager oldestRevisionLogEntryOf:Array       
    "
!

printClassRepositorySummaryForClass:aClass on:aStream
    "returns summary info from the repository:
        current version,
        newest in repository,
        original checkin date (i.e. age),
        tags on the current version
        maybe more in the future
    "

    | log revisions youngestRev oldestRev|

    aClass isNil ifTrue:[^ ''].

    log := self revisionLogOf:aClass.
    log isNil ifTrue:[
        aStream nextPutLine:('Could not get the repository log from %1' bindWith:(self repositoryName ? '<no repository name>')).
        ^ self.
    ].   

    aStream nextPutAll:('Newest Revision: %1' bindWith:(log at:#newestRevision ifAbsent:'unknown')).
    revisions := log at:#revisions ifAbsent:nil.
    revisions isNil ifTrue:[
        aStream cr.
        aStream nextPutAll:('Could not retrieve the revision log').
        ^ self.
    ].      

    youngestRev := revisions first.
    oldestRev := revisions last.
    aStream nextPutLine:(' by %1 at %2' bindWith:(youngestRev author ? '?') with:(youngestRev timestamp)).
    aStream nextPutLine:('First Checkin: by %1 at %2' bindWith:(oldestRev author ? '?') with:(oldestRev timestamp)).
!

removeContainer: container inModule: module directory: directory
    "remove a container"

    ^ self subclassResponsibility

    "Modified (comment): / 23-12-2011 / 19:03:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

revisionForTag:tagName inClass:aClass
    "retrieve the revision number associated to a particular tag/symbolic version.
     Nil if unknown"

    |tagsAndVersions|

    tagsAndVersions := self knownTagsAndRevisionsFor:aClass.
    tagsAndVersions isEmptyOrNil ifTrue:[ ^ nil ].
    ^ tagsAndVersions at:tagName ifAbsent:nil.

    "
     SourceCodeManager revisionForTag:'stable' inClass:Array
    "

    "Created: / 08-02-2011 / 10:18:00 / cg"
!

revisionInfoFromRCSString:aString
    "{ Pragma: +optSpace }"

    "return a dictionary filled with revision info.
     This extracts the relevant info from aString."

    ^ CVSSourceCodeManager versionInfoClass fromRCSString:aString.

    "
     SourceCodeManager revisionInfoFromString:'$' , 'Revision: 1.122 $'
     SourceCodeManager revisionInfoFromString:(SourceCodeManager version)
    "

    "Modified: / 22-10-2008 / 20:18:58 / cg"
!

revisionInfoFromStandardVersionString:aString 
    "{ Pragma: +optSpace }"

    "return a VersionInfo object filled with revision info.
     This extracts the relevant info from aString which is in the format as created
     by standardRevisionStringFor:...."

    |info path version user timeStamp|

    "/ 'Path: stx/libbasic/Array.st, Version: 123, User: cg, Time: 2011-12-21T21:03:08.826'

    path := self extractKeyValueFor:'Path' fromRevisionString:aString.
    version := self extractKeyValueFor:'Version' fromRevisionString:aString.
    user := self extractKeyValueFor:'User' fromRevisionString:aString.
    timeStamp := self extractKeyValueFor:'Time' fromRevisionString:aString.

    info := self versionInfoClass new.
    path notNil ifTrue:[ info fileName:(path asFilename baseName) ].
    info revision:version.
    user notNil ifTrue:[ info user:user ].
    timeStamp notNil ifTrue:[ info timeStamp:(Timestamp readFrom:timeStamp) ].
    ^ info

    "
     self revisionInfoFromStandardVersionString:'Path: stx/libbasic/Array.st, Version: 123, User: cg, Time: 2011-12-21T21:03:08.826' 
    "

    "Created: / 23-07-2012 / 18:45:41 / cg"
!

revisionInfoFromString:aString
    "{ Pragma: +optSpace }"

    "return a dictionary filled with revision info.
     This extracts the relevant info from aString."

    ^ self subclassResponsibility

    "Created: 29.1.1997 / 18:54:52 / cg"
    "Modified: 29.1.1997 / 18:57:29 / cg"
!

revisionInfoFromString: vsnString inClass: class

    ^self revisionInfoFromString: vsnString

    "Modified: / 03-10-2011 / 13:05:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

revisionLogOf:aClass
    "return info about the repository container and
     the revisionlog as a collection of revision entries.
     Return nil on failure.
     The returned information is a structure (IdentityDictionary)
     filled with:
            #container          -> the container file name (for container-based SCMs)
            #filename           -> the actual source file name
            #newestRevision     -> the revisionString of the newest revision
            #numberOfRevisions  -> the number of revisions in the container
            #revisions          -> collection of per-revision info

            per revision info consists of one record per revision:

              #revision              -> the revision string
              #author                -> who checked that revision into the repository
              #date                  -> when was it checked in
              #state                 -> the RCS state
              #numberOfChangedLines  -> the number of changed line w.r.t the previous

            revisions are ordered newest first 
            (i.e. the last entry is for the initial revision; the first for the most recent one)
        "

    ^ self
        revisionLogOf:aClass fromRevision:nil toRevision:nil

    "
     SourceCodeManager revisionLogOf:Array 
    "

    "Created: 25.11.1995 / 11:25:02 / cg"
    "Modified: 25.11.1995 / 11:56:16 / cg"
!

revisionLogOf:aClass fromRevision:rev1
    "return info about the repository container and
     (part of) the revisionlog as a collection of revision entries.
     Return nil on failure.

     The returned information is a structure (IdentityDictionary)
     filled with:
            #container          -> the container file name (for container-based SCMs)
            #filename           -> the actual source file name
            #newestRevision     -> the revisionString of the newest revision
            #numberOfRevisions  -> the number of revisions in the container
            #revisions          -> collection of per-revision info (see below)

         for some classes, additional info is returned:

            #renamed            -> true if the class has been renamed or copied
                                   and the sourceInfo is from the previous one
            #expectedFileName   -> the filename we would expect (i.e. for the new class)

            rev1 specifies from which revisions a logEntry is wanted:
              If rev1 is nil, the first revision is the initial revision
              otherwise, the log starts with that revision.

            per revision info consists of one record per revision:

              #revision              -> the revision string
              #author                -> who checked that revision into the repository
              #date                  -> when was it checked in
              #state                 -> the RCS state
              #numberOfChangedLines  -> the number of changed line w.r.t the previous

            revisions are ordered newest first 
            (i.e. the last entry is for the initial revision; 
                  the first for the most recent one)
        "

    ^ self revisionLogOf:aClass fromRevision:rev1 toRevision:nil

    "
     SourceCodeManager revisionLogOf:Array fromRevision:'1.40'
    "

    "Created: 6.11.1995 / 18:56:00 / cg"
    "Modified: 10.1.1997 / 13:29:50 / cg"
!

revisionLogOf:aClass fromRevision:rev1 toRevision:rev2
    "return info about the repository container and
     (part of) the revisionlog as a collection of revision entries.
     Return nil on failure.

     The returned information is a structure (IdentityDictionary)
     filled with:
            #container          -> the container file name (for container-based SCMs)
            #filename           -> the actual source file name
            #newestRevision     -> the revisionString of the newest revision
            #numberOfRevisions  -> the number of revisions in the container
            #revisions          -> collection of per-revision info (see below)

         for some classes, additional info is returned:

            #renamed            -> true if the class has been renamed or copied
                                   and the sourceInfo is from the previous one
            #expectedFileName   -> the filename we would expect (i.e. for the new class)

            rev1 / rev2 specify from which revisions a logEntry is wanted:
              If rev1 is nil, the first revision is the initial revision
              otherwise, the log starts with that revision.
              If rev2 is nil, the last revision is the newest revision
              otherwise, the log ends with that revision.
              If both are nil, no logEntries are extracted (i.e. only the header).

            per revision info consists of one record per revision:

              #revision              -> the revision string
              #author                -> who checked that revision into the repository
              #date                  -> when was it checked in
              #state                 -> the RCS state
              #numberOfChangedLines  -> the number of changed line w.r.t the previous

            revisions are ordered newest first 
            (i.e. the last entry is for the initial revision; 
                  the first for the most recent one)
        "

    ^ self
        revisionLogOf:aClass fromRevision:rev1 toRevision:rev2 
        finishAfter:nil
!

revisionLogOf:aClass fromRevision:rev1 toRevision:rev2 finishAfter:maxCountOrNil
    "return info about the repository container and
     (part of) the revisionlog as a collection of revision entries.
     Return nil on failure.

     The returned information is a structure (IdentityDictionary)
     filled with:
            #container          -> the container file name (for container-based SCMs)
            #filename           -> the actual source file name
            #newestRevision     -> the revisionString of the newest revision
            #numberOfRevisions  -> the number of revisions in the container
            #revisions          -> collection of per-revision info (see below)

         for some classes, additional info is returned:

            #renamed            -> true if the class has been renamed or copied
                                   and the sourceInfo is from the previous one
            #expectedFileName   -> the filename we would expect (i.e. for the new class)

            rev1 / rev2 specify from which revisions a logEntry is wanted:
              If rev1 is nil, the first revision is the initial revision
              otherwise, the log starts with that revision.
              If rev2 is nil, the last revision is the newest revision
              otherwise, the log ends with that revision.
              If both are nil, no logEntries are extracted (i.e. only the header).

            per revision info consists of one record per revision:

              #revision              -> the revision string
              #author                -> who checked that revision into the repository
              #date                  -> when was it checked in
              #state                 -> the RCS state
              #numberOfChangedLines  -> the number of changed line w.r.t the previous

            revisions are ordered newest first 
            (i.e. the last entry is for the initial revision; 
                  the first for the most recent one)
        "

    |sourceInfo packageDir moduleDir classFileName info|

    sourceInfo := self sourceInfoOfClass:aClass.
    sourceInfo isNil ifTrue:[^ nil].

    packageDir := self directoryFromSourceInfo:sourceInfo.
    moduleDir := self moduleFromSourceInfo:sourceInfo.  "/ use the modules name as CVS module
    classFileName := self containerFromSourceInfo:sourceInfo.

    info := self 
        revisionLogOf:aClass
        fromRevision:rev1 
        toRevision:rev2
        numberOfRevisions:maxCountOrNil
        fileName:classFileName
        directory:packageDir 
        module:moduleDir.

    info notNil ifTrue:[
"/        (sourceInfo includesKey:#renamed) ifTrue:[
"/            info at:#renamed put:(sourceInfo at:#renamed)
"/        ].
        (sourceInfo includesKey:#expectedFileName) ifTrue:[
            info at:#expectedFileName put:(sourceInfo at:#expectedFileName)
        ]
    ].
    ^ info

    "
     SourceCodeManager revisionLogOf:Array fromRevision:'1.40' toRevision:'1.43' 
     SourceCodeManager revisionLogOf:XtBoxNew 
    "

    "Created: / 06-11-1995 / 18:56:00 / cg"
    "Modified: / 23-08-2006 / 14:10:50 / cg"
!

revisionLogOf:aClass numberOfRevisions:numRevisions
    "return info about the repository container and
     (part of) the revisionlog (numRevisions newest revisions) 
     as a collection of revision entries.
     Return nil on failure.

     The returned information is a structure (IdentityDictionary)
     filled with:
            #container          -> the container file name (for container-based SCMs)
            #filename           -> the actual source file name
            #newestRevision     -> the revisionString of the newest revision
            #numberOfRevisions  -> the number of revisions in the container (nil for all)
            #revisions          -> collection of per-revision info (see below)

         for some classes, additional info is returned:

            #renamed            -> true if the class has been renamed or copied
                                   and the sourceInfo is from the previous one
            #expectedFileName   -> the filename we would expect (i.e. for the new class)

            rev1 / rev2 specify from which revisions a logEntry is wanted:
              If rev1 is nil, the first revision is the initial revision
              otherwise, the log starts with that revision.
              If rev2 is nil, the last revision is the newest revision
              otherwise, the log ends with that revision.
              If both are nil, no logEntries are extracted (i.e. only the header).

            per revision info consists of one record per revision:

              #revision              -> the revision string
              #author                -> who checked that revision into the repository
              #date                  -> when was it checked in
              #state                 -> the RCS state
              #numberOfChangedLines  -> the number of changed line w.r.t the previous
              #logMessage            -> the checkIn log message

            revisions are ordered newest first 
            (i.e. the last entry is for the initial revision; 
                  the first for the most recent one)
        "

    |sourceInfo packageDir moduleDir classFileName info|

    sourceInfo := self sourceInfoOfClass:aClass.
    sourceInfo isNil ifTrue:[^ nil].

    packageDir := self directoryFromSourceInfo:sourceInfo.
    moduleDir := self moduleFromSourceInfo:sourceInfo.  "/ use the modules name as CVS module
    classFileName := self containerFromSourceInfo:sourceInfo.

    info := self 
        revisionLogOf:aClass
        numberOfRevisions:numRevisions
        fileName:classFileName
        directory:packageDir 
        module:moduleDir.

    info notNil ifTrue:[
"/        (sourceInfo includesKey:#renamed) ifTrue:[
"/            info at:#renamed put:(sourceInfo at:#renamed)
"/        ].
        (sourceInfo includesKey:#expectedFileName) ifTrue:[
            info at:#expectedFileName put:(sourceInfo at:#expectedFileName)
        ]
    ].
    ^ info

    "
     SourceCodeManager revisionLogOf:Array numberOfRevisions:10 
    "

    "Modified: / 23-08-2006 / 14:10:52 / cg"
!

revisionLogOf:clsOrNil numberOfRevisions:numRevisions fileName:classFileName directory:packageDir module:moduleDir
    ^ self 
        revisionLogOf:clsOrNil
        fromRevision:nil
        toRevision:nil
        numberOfRevisions:numRevisions
        fileName:classFileName
        directory:packageDir
        module:moduleDir
!

revisionLogOfContainer:classFileName directory:packageDir module:moduleDir
    "return info about the repository container and
     (part of) the revisionlog as a collection of revision entries.
     Return nil on failure.

     The returned information is a structure (IdentityDictionary)
     filled with:
            #container          -> the container file name (for container-based SCMs)
            #filename           -> the actual source file name
            #newestRevision     -> the revisionString of the newest revision
            #numberOfRevisions  -> the number of revisions in the container
            #revisions          -> collection of per-revision info (see below)

            per revision info consists of one record per revision:

              #revision              -> the revision string
              #author                -> who checked that revision into the repository
              #date                  -> when was it checked in
              #state                 -> the RCS state
              #numberOfChangedLines  -> the number of changed line w.r.t the previous

            revisions are ordered newest first 
            (i.e. the last entry is for the initial revision; 
                  the first for the most recent one)
        "

    ^ self
        revisionLogOf:nil 
        fromRevision:nil 
        toRevision:nil 
        fileName:classFileName 
        directory:packageDir 
        module:moduleDir

    "
     CVSSourceCodeManager
        revisionLogInFile:'Array.st' directory:'libbasic' module:'stx'
    "

    "Modified: 10.1.1997 / 13:29:06 / cg"
!

revisionLogOfContainer:fileName module:moduleDir directory:packageDir fromRevision:rev1 toRevision:rev2
    "return info about the repository container and
     (part of) the revisionlog as a collection of revision entries.
     Return nil on failure.

     The returned information is a structure (IdentityDictionary)
     filled with:
            #container          -> the container file name (for container-based SCMs)
            #filename           -> the actual source file name
            #newestRevision     -> the revisionString of the newest revision
            #numberOfRevisions  -> the number of revisions in the container
            #revisions          -> collection of per-revision info (see below)

         for some classes, additional info is returned:

            #renamed            -> true if the class has been renamed or copied
                                   and the sourceInfo is from the previous one
            #expectedFileName   -> the filename we would expect (i.e. for the new class)

            rev1 / rev2 specify from which revisions a logEntry is wanted:
              If rev1 is nil, the first revision is the initial revision
              otherwise, the log starts with that revision.
              If rev2 is nil, the last revision is the newest revision
              otherwise, the log ends with that revision.
              If both are nil, no logEntries are extracted (i.e. only the header).

            per revision info consists of one record per revision:

              #revision              -> the revision string
              #author                -> who checked that revision into the repository
              #date                  -> when was it checked in
              #state                 -> the RCS state
              #numberOfChangedLines  -> the number of changed line w.r.t the previous

            revisions are ordered newest first 
            (i.e. the last entry is for the initial revision; 
                  the first for the most recent one)
        "

    |info|

    info := self 
        revisionLogOf:nil
        fromRevision:rev1 
        toRevision:rev2
        fileName:fileName
        directory:packageDir 
        module:moduleDir.

    ^ info

    "
     SourceCodeManager 
        revisionLogOfContainer:'Array.st' 
        module:'stx' 
        directory:'libbasic' 
        fromRevision:'1.1' 
        toRevision:nil 
    "

    "Created: / 23-08-2006 / 14:14:59 / cg"
!

revisionStringFor:aClass inModule:moduleDir directory:packageDir container:fileName revision:revisionString
    "utility function: return a string usable as initial revision string.
     Can be redefined in subclasses"

    ^ self standardRevisionStringFor:aClass inModule:moduleDir directory:packageDir container:fileName revision:revisionString

    "
     self 
        revisionStringFor:Array 
        inModule:'stx' 
        directory:'libbasic' 
        container:'Array.st' 
        revision:'123'          
    "
!

revisionsOf:aClass
    "return a collection of revisions (as strings) found in the repository.
     The most recent (newest) revision will be the first in the list.
     Return nil on failure."

    |log revisions|

    log := self revisionLogOf:aClass.
    log isNil ifTrue:[^ nil].
    revisions := log at:#revisions ifAbsent:nil.
    revisions isNil ifTrue:[^ nil].
    ^ revisions collect:[:rev | rev at:#revision].

    "
     SourceCodeManager revisionsOf:Array       
     SourceCodeManager newestRevisionOf:Array 
    "

    "Modified: 10.4.1996 / 23:14:24 / cg"
    "Created: 19.4.1996 / 17:24:34 / cg"
!

standardRevisionStringFor:aClass inModule:moduleDir directory:packageDir container:fileName revision:revisionString
    "utility function: return a string usable as initial revision string"

    ^ 'Path: %1/%2/%3, Version: %4, User: %5, Time: %6'
        bindWith:moduleDir
        with:packageDir
        with:fileName
        with:revisionString
        with:(OperatingSystem getLoginName)
        with:(Timestamp now printStringIso8601Format)

    "
     self 
        revisionStringFor:Array 
        inModule:'stx' 
        directory:'libbasic' 
        container:'Array.st' 
        revision:'123'          
    "

    "Created: / 23-07-2012 / 18:46:29 / cg"
!

withSourceRewriteHandlerDo:aBlock
    "hook for just-in-time rewriting of a method's sourceCode while filing out
     used when saving version_XXX methods in a non-XXX sourceCodeManager,
     or when generating sourcecode for another Smalltalk system (VSE fileout)"

    AbstractSourceFileWriter methodSourceRewriteQuery handle:[:rewriteQuery |
        |m newSource selector|

        m := rewriteQuery method.
        m isVersionMethod ifFalse:[                                                            
            rewriteQuery proceedWith:rewriteQuery source.
        ].
        selector := m selector.

        ((self isVersionMethodSelector:selector) "selector = self nameOfVersionMethodInClasses" 
        or:[(self isExtensionsVersionMethodSelector:selector) "selector = self nameOfVersionMethodForExtensions" 
        or:[selector = Class nameOfOldVersionMethod]]) ifTrue:[
            "/ it's my version method - make sure that it has $'s around...
            newSource := self ensureDollarsInVersionMethod:rewriteQuery source.
            (selector = Class nameOfOldVersionMethod) ifTrue:[
                "/ #version method: make sure that it contains proper
                "/ keyword (Header for CVS/P4, Id for SVN...
                newSource := self ensureKeywordInVersionMethod: newSource.
            ]
        ] ifFalse:[
            "/ it's another manager's version method - make sure that it has NONONO $'s around...
            newSource := self ensureNoDollarsInVersionMethod:rewriteQuery source.
        ].
        rewriteQuery proceedWith:newSource
    ] do:aBlock.

    "Modified: / 27-09-2011 / 16:48:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

writeHistoryLogSince:timeGoal filterSTSources:filterSTSourcesBoolean 
        filterUser:userFilter filterRepository:repositoryFilter filterModules:moduleFilter 
        filterProjects:projectFilterArg to:aStream
    "send a full historyLog to some stream.
     This walks over all possible repository roots."

    |projectFilter goalString prevUser prevCvsRoot |

    projectFilter := projectFilterArg isEmptyOrNil ifTrue:nil ifFalse:projectFilterArg.

    goalString := ''.
    projectFilter notNil ifTrue:[
        projectFilter size == 1 ifTrue:[
            goalString := goalString , 'of ',projectFilter first.
        ] ifFalse:[
            projectFilter size == 2 ifTrue:[
                goalString := goalString , 'of ',projectFilter first,' and ',projectFilter second.
            ] ifFalse:[
                goalString := goalString , 'of ',projectFilter size printString,' projects'.
            ].
        ].
        goalString := goalString,' '
    ].
    (timeGoal notEmptyOrNil) ifTrue:[
        goalString := goalString , 'since ' , timeGoal,' '.
    ].
    userFilter notNil ifTrue:[
        userFilter isString ifTrue:[
            goalString := 'by user ',userFilter
        ] ifFalse:[
            userFilter size == 1 ifTrue:[
                goalString := 'by user ',(userFilter first) 
            ] ifFalse:[
                goalString := 'by users ',(userFilter first),'...',(userFilter last) 
            ]
        ].
        goalString := goalString,' '.
    ].

    aStream nextPutLine:'**** repository history ' , goalString , '****'.
    aStream cr.

    self 
        reportHistoryLogSince:timeGoal 
        filterSTSources:filterSTSourcesBoolean 
        filterUser:userFilter 
        filterRepository:repositoryFilter 
        filterModules:moduleFilter
        inTo:[:info |
            |user recordType fileName date time rev pkgDir 
             module directory pkg
             clsName cvsRoot cls clsRev revInfo|

            pkgDir := info at:#directory ifAbsent:'?'.
            module := pkgDir upTo:$/.
            directory := pkgDir copyFrom:(module size+2).
            pkg := (PackageId module:module directory:directory) asString.

            (projectFilter isEmptyOrNil
                or:[ projectFilter contains:[:pat | pat match:pkg caseSensitive:false] ]
            ) ifTrue:[

                user := info at:#user ifAbsent:'?'.
                recordType := info at:#cvsRecordType ifAbsent:'?'.
                fileName := info at:#fileName ifAbsent:'?'.
                date := info at:#date ifAbsent:'?'.
                time := info at:#time ifAbsent:'?'.
                rev := info at:#revision ifAbsent:'?'.

                clsName := info at:#className ifAbsent:'?'.
                cvsRoot := info at:#cvsRoot ifAbsent:'?'.

                cvsRoot ~= prevCvsRoot ifTrue:[
                    aStream cr.
                    aStream nextPutLine:'>>>> repository: ' , cvsRoot , ' <<<<'.
                    aStream cr; cr.
                    aStream nextPutLine:'     Date    Time        User    Rev    File                           Package'.
                    prevUser := nil.
                    prevCvsRoot := cvsRoot.
                ].
                prevUser ~= user ifTrue:[
                    aStream cr.
                    prevUser := user.
                ].
                aStream 
                    nextPutAll:recordType; space; 
                    nextPutAll:(date printString paddedTo:10); space; nextPutAll:(time printString paddedTo:5); space;
                    nextPutAll:(user leftPaddedTo:10); space;             
                    nextPutAll:(rev decimalPaddedTo:8 and:4 at:$. withLeft:(Character space) right:nil); tab;              
                    nextPutAll:(fileName paddedTo:30); space;                 
                    nextPutAll:pkg.

                "/
                "/ for your convenience:
                "/  check what the actual version is in the image
                "/
                clsName notNil ifTrue:[
                    revInfo := nil.
                    cls := Smalltalk classNamed:clsName.
                    (cls notNil and:[(clsRev := cls revision) notNil]) ifTrue:[
                        rev ~= clsRev ifTrue:[
                            revInfo := (' current: ' , clsRev)
                        ]
                    ] ifFalse:[
                        cls isNil ifTrue:[
                            revInfo := (' current: ** none **')
                        ] ifFalse:[
                            cls isLoaded ifTrue:[
                                revInfo := (' current: ** no revision info **')
                            ] ifFalse:[
                                revInfo := (' current: ** not loaded **')
                            ]    
                        ]
                    ].
                    revInfo notNil ifTrue:[
                        aStream nextPutAll:revInfo
                    ].
                ].
                aStream cr                              
            ].
        ].

    "Created: / 12-09-2006 / 15:18:35 / cg"
    "Modified: / 18-11-2006 / 17:09:55 / cg"
!

writeHistoryLogSince:timeGoal filterSTSources:filter filterUser:userFilter filterRepository:repositoryFilter filterModules:moduleFilter to:aStream
    "send a full historyLog to some stream.
     This walks over all possible repository roots."

    self
        writeHistoryLogSince:timeGoal 
        filterSTSources:filter 
        filterUser:userFilter 
        filterRepository:repositoryFilter 
        filterModules:moduleFilter 
        filterProjects:nil 
        to:aStream

    "Modified: / 12-09-2006 / 15:19:11 / cg"
!

writeHistoryLogSince:timeGoal filterSTSources:filter filterUser:userFilter filterRepository:repositoryFilter to:aStream
    "send a full historyLog to some stream.
     This walks over all possible repository roots."

    ^self
        writeHistoryLogSince:timeGoal 
        filterSTSources:filter 
        filterUser:userFilter 
        filterRepository:repositoryFilter 
        filterModules:nil to:aStream

    "Modified: / 17.1.2001 / 13:15:54 / cg"
!

writeHistoryLogSince:timeGoal filterSTSources:filter filterUser:userFilter to:aStream
    "send a full historyLog to some stream.
     This walks over all possible repository roots."

    ^ self
        writeHistoryLogSince:timeGoal 
        filterSTSources:filter 
        filterUser:userFilter 
        filterRepository:nil 
        to:aStream
!

writeHistoryLogSince:timeGoal filterSTSources:filter to:aStream
    "send a repositories historyLog to some stream"

    ^ self 
        writeHistoryLogSince:timeGoal 
        filterSTSources:filter 
        filterUser:nil 
        filterRepository:nil
        to:aStream

    "Modified: 12.9.1996 / 02:36:32 / cg"
!

writeHistoryLogSince:timeGoal to:aStream
    "send a repositories historyLog to some stream"

    ^ self 
        writeHistoryLogSince:timeGoal 
        filterSTSources:true 
        filterUser:nil 
        filterRepository:nil
        to:aStream

    "Created: 13.12.1995 / 10:28:27 / cg"
    "Modified: 12.9.1996 / 02:36:38 / cg"
!

writeRevisionLogMessagesFrom:log to:aStream
    "helper; send the revisionlog to aStream"

    ^ self writeRevisionLogMessagesFrom:log withHeader:true to:aStream

    "Created: 10.12.1995 / 16:51:30 / cg"
!

writeRevisionLogMessagesFrom:log withHeader:header to:aStream
    "helper; send the revisionlog to aStream"

    |tags|

    header ifTrue:[
"/        (log at:#renamed ifAbsent:false) ifTrue:[
"/            aStream nextPutAll:'  Class was probably renamed; revision info is from original class.'.
"/            aStream cr; nextPutAll:'  You may have to create a new container for it.'.
"/            aStream cr; cr.
"/        ].

        aStream nextPutAll:'  Total revisions: '; nextPutLine:(log at:#numberOfRevisions) printString.
        aStream nextPutAll:'  Newest revision: '; nextPutLine:(log at:#newestRevision) printString.
        tags := log at:#symbolicNames ifAbsent:nil.
        tags notNil ifTrue:[
            aStream nextPutAll:'  Stable revision: '; nextPutAll:(tags at:'stable' ifAbsent:'none'); cr.
            aStream nextPutAll:'  Symbolic names: '; cr.
            "sort tags by tag name"
            tags := tags associations sort:[:a :b| a key < b key].
            tags do:[:eachAssociation|
                aStream tab; nextPutAll:eachAssociation key; 
                             nextPutAll:': '; 
                             nextPutAll:eachAssociation value; cr.
            ]
        ].
    ].

    (log at:#revisions ifAbsent:#()) do:[:entry |
        |logMsg color|

        aStream cr.
        aStream nextPutAll:'  revision '; 
            show:(entry at:#revision) allBold; tab.
        aStream nextPutAll:' date: '; 
            show:((entry at:#date ifAbsent:nil) ? '?'); space;
            show:((entry at:#time ifAbsent:nil) ? '?'); tab.
        aStream nextPutAll:' author: '; 
            show:((entry at:#author ifAbsent:nil) ? '?') allBold; tab.
        aStream nextPutAll:' lines: '; 
            show:(entry at:#numberOfChangedLines ifAbsent:nil) ? '?'; cr.

        logMsg := entry at:#logMessage ifAbsent:''.
        color := Color orange.
        (logMsg isBlank or:[logMsg withoutSeparators = '.']) ifTrue:[
            logMsg := '*** empty log message ***'.
            color := Color red.
        ].
        logMsg asCollectionOfLines do:[:eachLine |
            aStream tab.
            aStream nextPutAllText:(eachLine withColor:color); cr.
        ].
    ].

    "Created: / 16-11-1995 / 13:25:30 / cg"
    "Modified: / 27-11-1996 / 18:26:30 / stefan"
    "Modified: / 21-12-2011 / 23:33:53 / cg"
!

writeRevisionLogOf:aClass fromRevision:rev1 toRevision:rev2 finishAfter:maxCount to:aStream
    "extract a classes log and append it to aStream."

    |log |

    log := self revisionLogOf:aClass fromRevision:rev1 toRevision:rev2 finishAfter:maxCount.
    log isNil ifTrue:[
        aStream cr; nextPutAll:'  ** No revision log available **'.
        ^ false
    ].

    self writeRevisionLogMessagesFrom:log to:aStream.
    ^ true

    "
     SourceCodeManager writeRevisionLogOf:Array fromRevision:'1.40' toRevision:'1.43' to:Transcript 
    "

    "Created: 6.11.1995 / 18:56:00 / cg"
    "Modified: 14.2.1997 / 21:11:57 / cg"
!

writeRevisionLogOf:aClass fromRevision:rev1 toRevision:rev2 to:aStream
    "extract a classes log and append it to aStream."

    ^ self
        writeRevisionLogOf:aClass 
        fromRevision:rev1 toRevision:rev2 
        finishAfter:nil to:aStream

    "
     SourceCodeManager writeRevisionLogOf:Array fromRevision:'1.40' toRevision:'1.43' to:Transcript 
    "

    "Created: 6.11.1995 / 18:56:00 / cg"
    "Modified: 14.2.1997 / 21:11:57 / cg"
!

writeRevisionLogOf:aClass short:shortOrNot to:aStream
    "extract a classes log and append it to aStream."

    ^ self
        writeRevisionLogOf:aClass 
        fromRevision:nil 
        toRevision:nil 
        finishAfter:(shortOrNot ifTrue:20 ifFalse:nil)
        to:aStream

    "
     SourceCodeManager writeRevisionLogOf:Array to:Transcript 
    "
!

writeRevisionLogOf:aClass to:aStream
    "extract a classes log and append it to aStream."

    ^ self writeRevisionLogOf:aClass short:false to:aStream

    "
     SourceCodeManager writeRevisionLogOf:Array to:Transcript 
    "
! !

!AbstractSourceCodeManager class methodsFor:'source code utilities'!

diffListFor:clsOrNil fileName:classFileName directory:packageDir module:moduleDir revision1:rev1 revision2:rev2
    "return diff info. This is supposed to return a standard diff-like
     list of lines, representing the diffs between two revisions.
     experimental (for ownershipGraph)"

    ^  self
        diffListFor:clsOrNil fileName:classFileName directory:packageDir module:moduleDir revision1:rev1 revision2:rev2 
        cache:true
!

diffListFor:clsOrNil fileName:classFileNameArg directory:packageDirArg module:moduleDirArg revision1:rev1 revision2:rev2 cache:cacheIt
    "return diff info. This is supposed to return a standard diff-like
     list of lines, representing the diffs between two revisions.
     experimental (for ownershipGraph).
     This fallback retrieves the two versions and calls a diff"

    |fullName modulePath inStream list msg cacheDir cachedFile classFileName diffDir
     sourceStream1 sourceStream2 source1 source2 tmpSource1 tmpSource2
     moduleDir packageDir|

    moduleDir := moduleDirArg.
    packageDir := packageDirArg.
    
    clsOrNil notNil ifTrue:[
        modulePath :=  clsOrNil package copyReplaceAll:$: with:$/.
        moduleDir := clsOrNil package asPackageId module.
        packageDir := clsOrNil package asPackageId directory.
        fullName :=  modulePath , '/' , (classFileName := clsOrNil classFilename).
    ] ifFalse:[
        modulePath :=  moduleDir , '/' , packageDir. 
        fullName :=  modulePath , '/' , (classFileName := classFileNameArg).
    ].

   (cacheIt) ifTrue:[
        (cacheDir := self sourceCacheDirectory) isNil ifTrue:[
            ('SourceCodeManager [warning]: no source cache directory') infoPrintCR.
        ] ifFalse:[
            diffDir := (cacheDir / modulePath / '.diffs').
            diffDir exists ifFalse:[
                diffDir recursiveMakeDirectory.
            ].
            cachedFile := diffDir / (classFileName,'_',rev1,'_',rev2).
            cachedFile exists ifTrue:[
                ^ cachedFile contents
            ].
        ].
    ].

    msg := 'SourceCodeManager: Fetching diff list of '.
    clsOrNil isNil ifTrue:[
        msg := msg , fullName.
    ] ifFalse:[
        msg := msg , clsOrNil name.
    ].
    msg := msg , ' ' , rev1 , ' vs. ' , rev2.
    self activityNotification:msg.

    sourceStream1 := self 
                        streamForClass:clsOrNil
                        fileName:classFileName 
                        revision:rev1 
                        directory:packageDir 
                        module:moduleDir
                        cache:cacheIt.
    source1 := sourceStream1 contents.
    sourceStream1 close.
    tmpSource1 := Filename newTemporary.
    tmpSource1 contents:source1.
    
    sourceStream2 := self 
                        streamForClass:clsOrNil
                        fileName:classFileName 
                        revision:rev2 
                        directory:packageDir 
                        module:moduleDir
                        cache:cacheIt.
    source2 := sourceStream2 contents.
    sourceStream2 close.
    tmpSource2 := Filename newTemporary.
    tmpSource2 contents:source2.
    
    [
        inStream := PipeStream readingFrom:('diff %1 %2' bindWith:tmpSource1 pathName with:tmpSource1 pathName ). 
        inStream isNil ifTrue:[
            ('SourceCodeManager [error]: cannot open pipe to diff ', fullName) errorPrintCR.
            ^ nil
        ].
        list := inStream contents.
    ] ensure:[
        inStream close.
        tmpSource1 remove.
        tmpSource2 remove.
    ].
    list := list reject:[:line | line startsWith:'\ '].

    cachedFile notNil ifTrue:[
        cachedFile contents:list.
    ].
    ^ list
!

ensureDollarsInVersionMethod:aString
    "given the source code of my version method, ensure that it contains dollars for
     proper keyword expansion"

    |versionString|

    versionString := aString copyWithout: (Character codePoint: 167).
    ^ self ensureKeywordExpansionWith: $$ inVersionMethod:versionString.

    "
     self ensureDollarsInVersionMethod:'foo ^ ''hello'' ' 
     self ensureDollarsInVersionMethod:'foo ^ ''hello'' ' 
     self ensureDollarsInVersionMethod:'foo ^ ''   hello   '' '    
     self ensureDollarsInVersionMethod:'foo ^ ''$','Header: /cvs/stx/stx/libbasic3/AbstractSourceCodeManager.st,v 1.228 2009/10/20 09:55:58 fm Exp $'' '      
    -- errors:
     self ensureDollarsInVersionMethod:'foo ^ ''$Head'' '    
     self ensureDollarsInVersionMethod:'foo ^ ''Header$'' '    
    "
!

ensureKeyword: keyword inVersionMethod: source

    | startQuote endQuote doubleColon |

    "/nil keyword means that given source code management system
    "/does not expand keywords (StORE or Monticello, for example)
    keyword isNil ifTrue:[
        ^source.
    ].

    startQuote := source indexOf: $'.
    startQuote == 0 ifTrue:[
        self error:'Does not seem to be a valid version method source. Invalid source?'
    ].
    (source at: startQuote + 1) == $$ ifFalse:[
        self error:'Does not seem to be a valid version method source. Invalid source?'
    ].

    endQuote := source lastIndexOf: $'.
    startQuote == endQuote ifTrue:[
        self error:'Does not seem to be a valid version method source. Invalid source?'
    ].
    (source at: endQuote - 1) == $$ ifFalse:[
        self error:'Does not seem to be a valid version method source. Invalid source?'
    ].

    doubleColon := source indexOf: $: startingAt: startQuote + 2.
    "/ There may be no double colon at all, if the version method
    "/ is fresh, like 'dollar-Header-dollar' (no real dollar here, as cvs expands the string)
    (doubleColon == 0 or:[doubleColon > endQuote]) ifTrue:[
        doubleColon := endQuote - 1.
    ].

    (source copyFrom: startQuote + 2 to: doubleColon - 1) = keyword ifTrue:[
        "/ Good, desired keyword is already there
        ^source
    ].

    ^(source copyTo: startQuote + 1) , keyword , (source copyFrom: doubleColon)

    "Created: / 27-09-2011 / 15:00:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 26-01-2012 / 14:52:19 / cg"
!

ensureKeywordExpansionWith: aCharacter inVersionMethod:aString
    "given the source code of my version method, ensure that it contains aCharacter for
     proper keyword expansion"

    |indexOfFirstQuote indexOfNextAfterFirstQuote indexOfSecondDollar indexOfNextAfterSecondDollar indexOfLastQuote|

    indexOfFirstQuote := aString indexOf:$'.
    indexOfFirstQuote == 0 ifTrue:[
        "/ no ' found - mhmh is this a valid version method's source ?
        ^ aString
    ].
    indexOfNextAfterFirstQuote := aString indexOfNonSeparatorStartingAt:indexOfFirstQuote+1.
    (aString at:indexOfNextAfterFirstQuote) = aCharacter ifTrue:[
        indexOfSecondDollar := aString indexOf:aCharacter startingAt:indexOfNextAfterFirstQuote+1.
        ((indexOfSecondDollar == 0) 
        or:[ indexOfNextAfterSecondDollar := aString indexOfNonSeparatorStartingAt:indexOfSecondDollar+1.
             (aString at:indexOfNextAfterSecondDollar) ~= $' 
        ]) ifTrue:[ 
            self error:'invalid source (no valid version method string)' 
        ].
        "/ fine
        ^ aString
    ].

    indexOfLastQuote := aString lastIndexOf:$'.

    ^ (aString copyTo:indexOfFirstQuote)
        , aCharacter asString
        ,(aString copyFrom:indexOfFirstQuote+1 to:indexOfLastQuote-1)
        ,aCharacter asString ,(aString copyFrom:indexOfLastQuote)

    "
     self ensureKeywordExpansionWith: $ inVersionMethod: 'foo ^ ''hello'' '  
     self ensureKeywordExpansionWith: $ inVersionMethod: 'foo ^ ''   hello   '' '
     self ensureKeywordExpansionWith: $ inVersionMethod: 'foo ^ ''Header: /cvs/stx/stx/libbasic3/AbstractSourceCodeManager.st,v 1.218 2009/10/07 12:12:30 fm Exp '' '    

     self ensureKeywordExpansionWith: $$ inVersionMethod: 'foo ^ ''hello'' '  
     self ensureKeywordExpansionWith: $$ inVersionMethod: 'foo ^ ''   hello   '' '
     self ensureKeywordExpansionWith: $$ inVersionMethod: 'foo ^ ''$','Header: /cvs/stx/stx/libbasic3/AbstractSourceCodeManager.st,v 1.228 2009/10/20 09:55:58 fm Exp $'' '    

    -- errors:
     self ensureKeywordExpansionWith: $ inVersionMethod: 'foo ^ ''Head'' '  
     self ensureKeywordExpansionWith: $ inVersionMethod: 'foo ^ ''Header'' '   
    "
!

ensureKeywordInVersionMethod: source

    ^self ensureKeyword: self versionMethodKeyword inVersionMethod: source

    "Created: / 27-09-2011 / 14:50:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

ensureNoDollarsInVersionMethod:aString
    "given the source code of another manager's version method, ensure that it does NOT
     contain dollars and add $ instead, to avoid that CVS expands keywords in it"

    |versionString|

    versionString := aString copyWithout: $$.
    ^ self ensureKeywordExpansionWith: $ inVersionMethod:versionString.

    "
        self ensureNoDollarsInVersionMethod:'foo ^ ''$','Header: /cvs/stx/stx/libbasic3/AbstractSourceCodeManager.st,v 1.228 2009/10/20 09:55:58 fm Exp $'' '           
        self ensureNoDollarsInVersionMethod:'foo ^ ''$','Head'' '                
        self ensureNoDollarsInVersionMethod:'foo ^ ''Header$'' '             
        self ensureNoDollarsInVersionMethod:'foo ^ ''Header'' '    

      -- errors:

        self ensureNoDollarsInVersionMethod:'foo ^ ''Header'' '   
        self ensureNoDollarsInVersionMethod:'foo ^ ''Header'' '             

    "
!

extractKeyValueFor:key fromRevisionString:aString 
    "{ Pragma: +optSpace }"

    "extract a particular value from a string which has the format:
        key1: value1, key2: value2, .... keyN: valueN"

    |value idx1 idx2|

    "/ 'Path: stx/libbasic/Array.st, Version: 123, User: cg, Time: 2011-12-21T21:03:08.826'

    idx1 := aString indexOfSubCollection:(key,': ').
    idx1 ~~ 0 ifTrue:[
        idx1 := idx1 + (key,': ') size.
        idx2 := aString indexOfSubCollection:', ' startingAt:idx1.
        idx2 == 0 ifTrue:[ idx2 := aString size + 1 ].
        value := aString copyFrom:idx1 to:idx2-1.     
    ].
    ^ value

    "
     self 
        extractKeyValueFor:'Path' 
        fromRevisionString:'Path: stx/libbasic/Array.st, Version: 123, User: cg, Time: 2011-12-21T21:03:08.826'

     self 
        extractKeyValueFor:'Time' 
        fromRevisionString:'Path: stx/libbasic/Array.st, Version: 123, User: cg, Time: 2011-12-21T21:03:08.826'
    "
! !

!AbstractSourceCodeManager class methodsFor:'subclass responsibility'!

reportHistoryLogSince:timeGoal filterSTSources:filter filterUser:userFilter 
        filterRepository:repositoryFilter filterModules:moduleFilter inTo:aBlock

    ^ self subclassResponsibility
! !

!AbstractSourceCodeManager class methodsFor:'testing'!

isCVS
    ^ false

    "Created: / 16-08-2006 / 10:58:27 / cg"
!

isGit
    ^ false

    "Created: / 02-03-2012 / 16:44:02 / cg"
!

isMercurial
    ^ false

    "Created: / 14-01-2012 / 21:54:19 / cg"
!

isSVN
    ^ false

    "Created: / 16-08-2006 / 10:58:27 / cg"
!

isSmallTeam
    ^ false

    "Created: / 09-11-2006 / 14:30:22 / cg"
!

isStore
    ^ false

    "Created: / 16-08-2006 / 10:59:26 / cg"
! !

!AbstractSourceCodeManager::PackageAndManager class methodsFor:'instance creation'!

package: package manager: manager

    ^self new
        package: package;
        manager: manager.

    "Created: / 09-07-2011 / 13:58:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractSourceCodeManager::PackageAndManager methodsFor:'accessing'!

manager

    ^AbstractSourceCodeManager named: managerTypeName

    "Created: / 09-07-2011 / 13:52:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

manager: aSourceCodeManager

    managerTypeName := aSourceCodeManager managerTypeName

    "Created: / 09-07-2011 / 13:59:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

managerTypeName
    ^ managerTypeName
!

managerTypeName:something
    managerTypeName := something.
!

package
    ^ package
!

package:something
    package := something.
! !

!AbstractSourceCodeManager::PackageAndManager methodsFor:'comparing'!

= aPackageAndManagerOrNil
    aPackageAndManagerOrNil isNil ifTrue:[^ false].
    aPackageAndManagerOrNil package = package ifFalse:[^ false].
    aPackageAndManagerOrNil managerTypeName = managerTypeName ifFalse:[^ false].
    ^ true

    "Created: / 19-08-2011 / 01:47:34 / cg"
!

hash
    ^ package hash bitXor: managerTypeName hash

    "Created: / 19-08-2011 / 01:47:56 / cg"
! !

!AbstractSourceCodeManager::PackageAndManager methodsFor:'displaying'!

displayStringForManagerTypeName
    ^ self manager isNil 
        ifFalse:[ managerTypeName ]
        ifTrue:
            [ (managerTypeName , ' (unavailable)') withColor:Color gray ].

    "Created: / 09-07-2011 / 14:05:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

displayStringForPackage
    ^ self manager isNil 
        ifTrue:[ package withColor:Color gray ]
        ifFalse:[ package ]

    "Created: / 09-07-2011 / 14:05:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-12-2011 / 11:31:49 / cg"
! !

!AbstractSourceCodeManager::PackageAndManager methodsFor:'printing & storing'!

printOn:aStream
    "append a printed representation of the receiver to the argument, aStream"

    super printOn:aStream.
    aStream nextPut: $(.
    package printOn:aStream.
    aStream nextPutAll:' -> '.
    managerTypeName printOn:aStream.
    aStream nextPut: $).

    "Modified: / 25-11-2011 / 18:35:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractSourceCodeManager::PackageAndManager methodsFor:'queries'!

match: packageId
    | manager packageMatches|

    manager := self manager.
    manager isNil ifTrue:[^false].

    packageMatches := package includesMatchCharacters
                        ifTrue:[ package match: packageId ]
                        ifFalse:[ packageId startsWith:(package,':') ].
    ^ packageMatches and: [manager isResponsibleForPackage: packageId]

    "
     self managerForModule:'stx:libbasic' 
     self managerForModule:'stx:libbasic2'
     self managerForModule:'exept:expecco'  
    "

    "Created: / 09-07-2011 / 14:26:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 18-11-2011 / 14:07:53 / cg"
! !

!AbstractSourceCodeManager class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id$'
! !


AbstractSourceCodeManager initialize!
