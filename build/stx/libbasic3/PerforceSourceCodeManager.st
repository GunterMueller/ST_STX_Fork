"
 COPYRIGHT (c) 2006 by eXept Software AG
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

AbstractSourceCodeManager subclass:#PerforceSourceCodeManager
	instanceVariableNames:''
	classVariableNames:'PerforceExecutable PerforceModuleRoots PerforceClient
		PerforcePort PerforceUser PerforcePassword PerforceTempDir
		Verbose PerforceCommandSemaphore PerforceEnabled
		PerforceWorkspaces'
	poolDictionaries:''
	category:'System-SourceCodeManagement'
!

Object subclass:#CheckInDefinition
	instanceVariableNames:'class packageDir classFileName sourceFileName logMessage
		moduleName manager tempDirectory definitionClass workSpace
		temporaryWorkSpace package reposRevisionInfoBeforeAction
		reposRevisionInfoAfterAction revisionStringBeforeAction
		fileContents'
	classVariableNames:''
	poolDictionaries:''
	privateIn:PerforceSourceCodeManager
!

ProceedableError subclass:#PerforceError
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:PerforceSourceCodeManager
!

VersionInfo subclass:#PerforceVersionInfo
	instanceVariableNames:'repositoryPathName revisionNumber'
	classVariableNames:''
	poolDictionaries:''
	privateIn:PerforceSourceCodeManager
!

!PerforceSourceCodeManager class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!PerforceSourceCodeManager class methodsFor:'accessing'!

flushPerforceWorkspaces

    PerforceWorkspaces := nil.
!

perforceClient
    |envVar|

    PerforceClient notEmptyOrNil ifTrue:[ ^ PerforceClient].
    envVar := OperatingSystem getEnvironment:'P4CLIENT'.
    envVar notEmptyOrNil ifTrue:[ ^ envVar].
    ^ 'workspace'
!

perforceClient:something
    PerforceClient := something.
!

perforceEnabled

    PerforceEnabled notNil ifTrue:[ ^ false].
    ^ PerforceEnabled
!

perforceEnabled:enable

    PerforceEnabled := enable.
!

perforceExecutable
    ^ PerforceExecutable ? 'p4'
!

perforceExecutable:aString
    "set the name of the cvs executable."

    aString isEmptyOrNil ifTrue:[
        PerforceExecutable := nil
    ] ifFalse:[
        PerforceExecutable := aString.
    ].

    "Created: / 21-09-2006 / 15:31:59 / cg"
    "Modified: / 21-09-2006 / 16:41:33 / cg"
!

perforcePassword
    |envVar|

    PerforcePassword notNil ifTrue:[ ^ PerforcePassword].
    envVar := OperatingSystem getEnvironment:'P4PASSWD'.
    envVar notEmptyOrNil ifTrue:[ ^ envVar].
    ^ nil

    "Modified: / 19-04-2011 / 10:46:56 / cg"
!

perforcePassword:something
    PerforcePassword := something.
!

perforcePort
    |envVar|

    PerforcePort notNil ifTrue:[ ^ PerforcePort].
    envVar := OperatingSystem getEnvironment:'P4PORT'.
    envVar notEmptyOrNil ifTrue:[ ^ envVar].
    ^ 'localhost:1666'
!

perforcePort:something
    PerforcePort := something.
!

perforceUser
    |envVar|

    PerforceUser notNil ifTrue:[ ^ PerforceUser].
    envVar := OperatingSystem getEnvironment:'P4USER'.
    envVar notEmptyOrNil ifTrue:[ ^ envVar].
    ^ OperatingSystem getLoginName ? 'user'
!

perforceUser:something
    PerforceUser := something.
!

perforceWorkspaces
    "Superclass AbstractSourceCodeManager class says that I am responsible to implement this method"

    PerforceWorkspaces isNil ifTrue:[
        PerforceWorkspaces := Dictionary new.
    ].
    ^ PerforceWorkspaces 
!

repositoryInfoPerModule
    "Superclass AbstractSourceCodeManager class says that I am responsible to implement this method"

    ^ PerforceModuleRoots ? Dictionary new
!

repositoryInfoPerModule:aDictionary
    "set the dictionary, which associates CVSRoots to module names.
     If no entry is contained in this dictionary for some module,
     the default cvsRoot (CVSRoot) will be used."

    self flushPerforceWorkspaces.
    PerforceModuleRoots := aDictionary
!

repositoryName
    "return the name of the repository.
     Since this is an abstract class, return nil (i.e. none)"

    ^ (self perforceClient ,':',
       self perforceUser, ':',
       (self perforcePassword ? 'pass'), '@',
       self perforcePort)
    "Modified: 12.9.1996 / 02:20:45 / cg"
    "Created: 14.9.1996 / 13:21:37 / cg"
!

repositoryName:settingsString
    "return the name of the repository.
     Since this is an abstract class, return nil (i.e. none)"

    |settings|

    settings := self getPerforceSettingsFromString:settingsString.
    self perforceClient:(settings at:#client ifAbsent:nil).
    self perforceUser:(settings at:#user ifAbsent:nil).
    self perforcePassword:(settings at:#password ifAbsent:nil).
    self perforcePort:(settings at:#port ifAbsent:nil).
    "Modified: 12.9.1996 / 02:20:45 / cg"
    "Created: 14.9.1996 / 13:21:37 / cg"
!

repositoryNameForModule:aModuleName

    |settings|

    settings := self getPerforceSettingsForPackage:aModuleName.
    settings isNil ifTrue:[ ^ ''].
    ^ settings
!

repositoryNameForPackage:packageId 
    ^ self repositoryNameForModule:(packageId upTo:$: )

    "Modified: / 10-10-2011 / 19:48:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 21-12-2011 / 23:03:41 / cg"
!

setDefaultPerforceSettingsFromString:aString 
    |settings defaultSettingsString workSpace|

    defaultSettingsString := self getPerforceDefaultSettingsString.
    defaultSettingsString ~= aString ifTrue:[
        settings := PerforceSourceCodeManager 
                    getPerforceSettingsFromString:aString.
        PerforceSourceCodeManager 
            perforceClient:(settings at:#client ifAbsent:nil).
        PerforceSourceCodeManager perforceUser:(settings at:#user ifAbsent:nil).
        PerforceSourceCodeManager perforcePort:(settings at:#port ifAbsent:nil).
        PerforceSourceCodeManager 
            perforcePassword:(settings at:#password ifAbsent:nil).
        self removeWorkSpaceForSettings:defaultSettingsString.
        self perforceError handle:[:ex|
            self reportError:ex description.
            ^nil
        ] do:[
            workSpace := self workSpaceClass newWorkSpaceFor:aString.
        ].
        workSpace isNil ifTrue:[
            ^nil
        ].
        self perforceWorkspaces at:aString put:workSpace.
        defaultSettingsString := aString.
    ].

    "Modified: / 01-06-2012 / 11:06:24 / cg"
!

utilities
    "Returns 'utilities' object that can be used by tools. 

     By default, it returns an instance of
     SourceCodeManagerUtilities with receiver as its
     manager, but individual managers may override this
     method and supply its own, customized utilities."

    ^ PerforceSourceCodeManagerUtilities forManager: self

    "Created: / 10-10-2011 / 15:10:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 21-12-2011 / 20:05:31 / cg"
!

verboseSourceCodeAccess

    ^ Verbose

    "Created: / 19-04-2011 / 10:52:29 / cg"
!

verboseSourceCodeAccess:aBoolean

    Verbose := aBoolean

    "Created: / 19-04-2011 / 10:52:43 / cg"
!

workSpaceClass
    ^ PerforceSourceCodeManagerUtilities workSpaceClass

    "Modified: / 01-06-2012 / 11:14:15 / cg"
! !

!PerforceSourceCodeManager class methodsFor:'actions'!

checkinClass:aClass fileName:classFileName directory:packageDir module:moduleDir logMessage:logMessage force:force
    "checkin of a class into the source repository.
     Return true if ok, false if not."

    ^self checkinClass:aClass fileName:classFileName directory:packageDir module:moduleDir logMessage:logMessage force:force submit:false
!

checkinClass:aClass fileName:classFileName directory:packageDir module:moduleDir logMessage:logMessage force:force submit:doSubmit
    "checkin of a class into the source repository.
     Return true if ok, false if not."

    |className answer allLabel allValue 
     nameOfVersionMethodInClasses requestMessage locDoSubmit|

    locDoSubmit := doSubmit.
    className := aClass name.
    nameOfVersionMethodInClasses := self nameOfVersionMethodInClasses.

    aClass revision isNil ifTrue:[ 
        force ifFalse:[
            ('PerforceSourceCodeManager [warning]: class ' , className, ' has no revision string') errorPrintCR.

            AbortAllOperationWantedQuery query ifTrue:[
                allLabel := #('Cancel All').
                allValue := #(cancelAll).
            ] ifFalse:[
                allLabel := #().
                allValue := #().
            ].

            ((aClass theMetaclass includesSelector:#version)
               or:[aClass theMetaclass includesSelector: nameOfVersionMethodInClasses]) ifTrue:[
                requestMessage := ('Class %1 has no (usable) revision string.\\Check in as newest ?' bindWith:className allBold) withCRs.
            ] ifFalse:[
                requestMessage := ('Class %1 has no revision string.\\Check in as newest ?' bindWith:className allBold) withCRs.
            ].
            answer := OptionBox 
                        request: requestMessage
                        label:'Confirm'
                        buttonLabels:(allLabel , #('Cancel' 'CheckIn' 'CheckIn & Submit')) 
                        values:(allValue , #(false #checkIn #checkInAndSubmit ))
                        default:#checkIn.
            answer == false ifTrue:[ AbortSignal raise. ^ false ].
            answer == #cancelAll ifTrue:[ AbortAllSignal raise. ^ false ].
            answer == #checkInAndSubmit ifTrue:[ locDoSubmit := true ].
        ]
    ].

    "Ensure that the method #version_XXX is present before checking in XXX. 
     It will be missing when checking in classes with only the old method #version"
"/ this is wrong - it would add the SVN-id as CVS id...
"/    (aClass theMetaclass includesSelector: nameOfVersionMethodInClasses) ifFalse: [
"/        versionAsKnownBefore := aClass revisionString.   "/ looks in the old version (non-repository based)
"/
"/        self 
"/            compileVersionMethod:nameOfVersionMethodInClasses 
"/            of:aClass 
"/            for:(versionAsKnownBefore ? ('$' , 'Header' , '$')).  "/ concatenated to avoid RCS expansion
"/    ].

    ^ self basicCheckinClass:aClass fileName:classFileName directory:packageDir module:moduleDir logMessage:logMessage force:force submit:locDoSubmit.

    "
     SourceCodeManager checkinClass:Array
    "

    "Created: / 11-09-1996 / 16:15:17 / cg"
    "Modified: / 25-09-1997 / 12:16:00 / stefan"
    "Modified: / 21-12-2011 / 19:30:38 / cg"
!

checkinClass:aClass logMessage:logMessage submit:doSubmit
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
        force:false
        submit:doSubmit

    "
     SourceCodeManager checkinClass:Array logMessage:'foo'
    "

    "Created: / 06-11-1995 / 18:56:00 / cg"
    "Modified: / 29-08-2006 / 12:46:28 / cg"
!

createTempDirectory:packageDir forModule:moduleDir
    "create a temp directory for checking out"

    ^ self createTempDirectory:packageDir forModule:moduleDir in:(self perforceTmpDirectory)
!

ensureDollarsInVersionMethod:aString
    "given the source code of my version method, ensure that it contains dollars for
     proper keyword expansion
     do nothing here because we don't need this - make our own version
    "

    ^aString
!

removeContainer:fileName inModule:moduleName directory:packageDir
    "remove a container"

    ^self removeContainer:fileName inModule:moduleName directory:packageDir submit:false
!

removeContainer:fileName inModule:moduleName directory:packageDir submit:doSubmit
    "remove a container"

    |cls checkInDefinition classFileName workSpace clsName|

    clsName := fileName asFilename withoutSuffix baseName.
    cls := Smalltalk at:clsName asSymbol ifAbsent:nil.
    cls isNil ifTrue:[
        self reportError:'Error removing class - ', clsName, ' not exists'.
        ^false
    ].
    classFileName := fileName.
    cls isPrivate ifTrue:[
        self reportError:'refuse to check in private classes.'.
        ^ false.
    ].
    checkInDefinition := CheckInDefinition new.
    checkInDefinition manager:self.
    checkInDefinition setDefinitionClass:cls.
    checkInDefinition classFileName:classFileName.
    checkInDefinition package:moduleName.
    checkInDefinition packageDir:packageDir.
    checkInDefinition setLogMessage:'Remove from Smalltalk Browser'.

    self perforceError handle:[:ex|
        self reportError:ex description.
        ex proceed.
    ] do:[
        workSpace := self getWorkSpaceForPackage:(checkInDefinition packageString).
    ].
    workSpace isNil ifTrue:[
        ^ false
    ].
    checkInDefinition workSpace:workSpace.
    self perforceError handle:[:ex|
        self reportError:ex description.
        ex proceed.
    ] do:[
        ^ workSpace delete:checkInDefinition submit:doSubmit.
    ].

    ^true

"
    self removeContainer:'ActionNQualifier.st' inModule:'applistx' directory:'util/libDataType'
"
!

savePreferencesOn:aStream

    aStream nextPutLine:'PerforceSourceCodeManager notNil ifTrue:['.
    self repositoryInfoPerModule notEmptyOrNil ifTrue:[
	aStream nextPutLine:'    PerforceSourceCodeManager repositoryInfoPerModule:' , self repositoryInfoPerModule storeString , '.'.
    ].
    PerforceExecutable notNil ifTrue:[
	aStream nextPutLine:'    PerforceSourceCodeManager perforceExecutable:' , PerforceExecutable storeString , '.'.
    ].
    aStream nextPutLine:'    PerforceSourceCodeManager repositoryName:' , self getPerforceDefaultSettingsString storeString, '.'.
    (Smalltalk at:#SourceCodeManager) == self ifTrue:[
	aStream nextPutLine:'    Smalltalk at:#SourceCodeManager put: PerforceSourceCodeManager.'.
    ].
    aStream nextPutLine:'].'.
!

submit

    self perforceWorkspaces do:[:aWorkSpace | 
        self perforceError handle:[:ex|
            self reportError:ex description.
            ex proceed.
        ] do:[
            aWorkSpace submit.
        ].
    ].
! !

!PerforceSourceCodeManager class methodsFor:'basic administration'!

basicCheckinClass:cls fileName:classFileName directory:packageDir module:moduleName logMessage:logMessage force:forceArg submit:doSubmit
    "enter a classes source code
     into the source repository. If the force argument is true, no merge is done;
     instead, the code is checked in as given (Dangerous).
     Return true if ok, false if not."
    ^ self 
        basicCheckinClass:cls 
        fileName:classFileName 
        directory:packageDir 
        module:moduleName 
        logMessage:logMessage 
        force:forceArg 
        submit:doSubmit
        fileContents:nil.
!

basicCheckinClass:cls 
    fileName:classFileName 
    directory:packageDir 
    module:moduleName 
    logMessage:logMessage 
    force:forceArg 
    submit:doSubmit
    fileContents:fileContents
    "enter a classes source code
     into the source repository. If the force argument is true, no merge is done;
     instead, the code is checked in as given (Dangerous).
     Return true if ok, false if not."

    |binRevision checkInDefinition workSpace initialResult revisionBeforeCheckin 
   revisionInfoBeforeCheckin revisions revisionInfo locRevision revisionState result|

    (cls notNil and:[cls isPrivate]) ifTrue:[
        self reportError:'refuse to check in private classes.'.
        ^ false.
    ].
    checkInDefinition := CheckInDefinition new.
    checkInDefinition manager:self.
    checkInDefinition setDefinitionClass:cls.
    checkInDefinition classFileName:classFileName.
    checkInDefinition sourceFileName:classFileName.
    checkInDefinition package:moduleName.
    checkInDefinition packageDir:packageDir.
    checkInDefinition fileContents:fileContents.
    (checkInDefinition setLogMessage:logMessage) ifFalse:[
        self reportError:'Perforce cannot handle unicode in logMessage'.
        ^ false
    ].

    self perforceError handle:[:ex|
        self reportError:ex description.
        ex proceed.
    ] do:[
        workSpace := self getWorkSpaceForPackage:(checkInDefinition packageString).
    ].
    workSpace isNil ifTrue:[
        ^ false
    ].
    checkInDefinition workSpace:workSpace.
    checkInDefinition isClassCheckin ifTrue:[
        binRevision := checkInDefinition getBinaryRevisionNumber.
        locRevision := checkInDefinition getLocalRevisionNumber.
    ].
    revisionInfoBeforeCheckin := checkInDefinition getReposRevisionInfoBeforeCheckin.
    revisions := revisionInfoBeforeCheckin at:#revisions ifAbsent:nil.
    revisions notEmptyOrNil ifTrue:[
        revisionInfo := revisions first.
        revisionBeforeCheckin := (revisionInfo at:#revision) asNumber.
        revisionState := revisionInfo at:#state ifAbsent:nil.
    ].
    checkInDefinition isClassCheckin ifTrue:[
        (revisionBeforeCheckin ~= binRevision and:[self verboseSourceCodeAccess]) ifTrue:[
            ('PerforceSourceCodeManager [info]: class ' , checkInDefinition definitionObjectString , ' is based upon ' , binRevision printString, ' but has revision ' , (revisionBeforeCheckin printString)) infoPrintCR
        ].
     ].
    (revisionBeforeCheckin isNil or:[revisionState = 'delete']) ifTrue:[
        " add file to p4 "
        self perforceError handle:[:ex|
            self reportError:ex description.
            ex proceed.
        ] do:[
            initialResult := workSpace addCheckIn:checkInDefinition submit:doSubmit.
            initialResult ifFalse:[
                ^false
            ].
        ].
    ] ifFalse:[
        " change file in p4 "
        self perforceError handle:[:ex|
            self reportError:ex description.
            ex proceed.
        ] do:[                   
            result := workSpace checkIn:checkInDefinition submit:doSubmit.
            result ifFalse:[
                ^false
            ].
        ].
    ].
    checkInDefinition isClassCheckin ifTrue:[
        result := self postCheckInClass:cls checkInDefinition:checkInDefinition.
    ].
    ^ true

    "
     SourceCodeManager checkinClass:PerforceSourceCodeManager logMessage:'testing only'
    "

    "Created: / 11-09-1996 / 16:16:11 / cg"
    "Modified: / 26-02-1998 / 17:34:16 / stefan"
    "Modified: / 25-10-2006 / 17:41:46 / cg"
!

checkForExistingContainer:fileName inModule:moduleDir directory:packageDir
    "check for a container to exist"

    |checkInDefinition workSpace result|

    checkInDefinition := CheckInDefinition new.
    checkInDefinition manager:self.
    checkInDefinition package:moduleDir.
    checkInDefinition packageDir:packageDir.

    self perforceError handle:[:ex|
        self reportError:ex description.
        ex proceed.
    ] do:[
        workSpace := self getWorkSpaceForPackage:(checkInDefinition package).
    ].
    workSpace isNil ifTrue:[
        ^ false
    ].
    checkInDefinition workSpace:workSpace.
    self perforceError handle:[:ex|
        self reportError:ex description.
        ^false
    ] do:[
        result := workSpace checkForExistingContainer:checkInDefinition.
        ^result
    ].
    ^false
"
    self checkForExistingContainer:'baseline.rbspec' inModule:'applistx' directory:'application/rtdbInspector/builder'
    self checkForExistingContainer:'baseline.rbspec' inModule:'applistx' directory:'application/rtdbInspector'
    self checkForExistingContainer:'baseline.rbspec' inModule:'applistx' directory:'util/*'
"
!

checkForExistingModule:moduleName
    "check for a module directory to be present"

    |workSpaceDefinition|

    self perforceError handle:[:ex|
        self reportError:ex description.
    ] do:[
        workSpaceDefinition := self getWorkSpaceForPackage:moduleName.
    ].
    workSpaceDefinition isNil ifTrue:[
        ('PerforceSourceCodeManager [error]: no workspace for ', moduleName) errorPrintCR.
        ^ false.
    ].
    ^ true.


"
self checkForExistingModule:'applistx'
self checkForExistingModule:'balla'
"

    "Modified: / 19-04-2011 / 11:30:41 / cg"
!

checkForExistingModule:moduleName directory:packageDir
    "check for a package directory to be present
     in perforce directory will be created with checkin
     so we need only to check if we have a matching workspace
    "

    |modulePath inDirectory workSpace|

    modulePath :=  moduleName , '/' , packageDir.

    inDirectory := (Filename currentDirectory asAbsoluteFilename) pathName.
    workSpace := self getWorkSpaceForPackage:moduleName.
    ^workSpace notNil

"
    self checkForExistingModule:'testModule' directory:'libTestPerforce'
"
!

checkin:containerFilename text:someText directory:packageDir module:moduleName logMessage:logMessage force:force
    "enter some (source) code (which is someText)
     into the source repository. If the force argument is true, no merge is done;
     instead, the code is checked in as given (Dangerous).
     Return true if ok, false if not."

    ^self basicCheckinClass:nil 
        fileName:containerFilename 
        directory:packageDir 
        module:moduleName 
        logMessage:logMessage 
        force:force 
        submit:false
        fileContents:someText
!

checkinClass:cls fileName:classFileName directory:packageDir module:moduleName source:sourceFileName logMessage:logMessage force:forceArg
    "enter a classes source code (which has been already filed out into sourceFileName)
     here we have to create our own source file
     into the source repository. If the force argument is true, no merge is done;
     instead, the code is checked in as given (Dangerous).
     Return true if ok, false if not."

    ^ self checkinClass:cls fileName:classFileName directory:packageDir module:moduleName logMessage:logMessage force:forceArg

    "
     SourceCodeManager checkinClass:Array logMessage:'testing only'
    "

    "Created: / 11-09-1996 / 16:16:11 / cg"
    "Modified: / 26-02-1998 / 17:34:16 / stefan"
    "Modified: / 25-10-2006 / 17:41:46 / cg"
!

createContainerFor:cls inModule:moduleName package:packageDir container:classFileName logMessage:logMessage

    ^ self checkinClass:cls fileName:classFileName directory:packageDir module:moduleName logMessage:logMessage force:false.
!

createContainerForText:someText inModule:moduleDir package:packageDir container:fileName

    ^self basicCheckinClass:nil 
        fileName:fileName 
        directory:packageDir 
        module:moduleDir 
        logMessage:'initial checkin'
        force:false 
        submit:false
        fileContents:someText
!

createModule:moduleName
    "we don't need to create directories in perforce before checkin"

    ^self checkForExistingModule:moduleName
!

createModule:module directory:directory
    "nothing to do with PerforceSourceCodeManager
     subdirectory in repository will created with adding the file "

    ^self checkForExistingModule:module
!

initialRevisionStringFor:aClass inModule:moduleDir directory:packageDir container:fileName
    "return a string usable as initial revision string"

    |checkInDefinition workSpace|

    aClass isPrivate ifTrue:[
        self reportError:'refuse to get revision for private classes.'.
        ^ false.
    ].
    checkInDefinition := CheckInDefinition new.
    checkInDefinition setDefinitionClass:aClass.
    checkInDefinition classFileName:fileName.
    checkInDefinition package:moduleDir.
    checkInDefinition packageDir:packageDir.
    checkInDefinition manager:self.

    "/
    "/ first, create a temporary work tree
    "/
"/    tempdir := checkInDefinition tempDirectory.


    workSpace := self getWorkSpaceForPackage:(checkInDefinition packageString).
    workSpace isNil ifTrue:[
        ('PerforceSourceCodeManager [error]: failed to create workspace for', checkInDefinition fileName)  errorPrintCR.
        ^ false
    ].
    checkInDefinition workSpace:workSpace.
    ^workSpace initialRevisionStringFor:checkInDefinition

"
self initialRevisionStringFor:RTDBInspectorStartup inModule:'applistx' directory:'util/rtdb' container:'RTDBInterfaceInspector.st'
"
!

revisionInfoFromString:aString
    "{ Pragma: +optSpace }"

    ^ PerforceVersionInfo fromRCSString:aString.

"
|stream|
stream := WriteStream on:''.
SourceCodeManagerUtilities repositoryLogOf:ExtIF onto:stream.
^ stream contents.

self revisionInfoFromString:((RTDBInterfaceInspector findVersionMethodOfManager:PerforceSourceCodeManager) valueWithReceiver:(self theNonMetaclass) arguments:#())
self revisionInfoFromString:'Path: //depot/applistx/util/libDataType/ActionDQualifier.st#1 User: penk Date: 30-03-2012 Time: 15-50-39.992'
"
!

revisionLogOf:clsOrNil 
        fromRevision:firstRev toRevision:lastRef numberOfRevisions:numRevisions 
        fileName:classFileName directory:packageDir module:aPackage

    "return info about the repository container and
     (part of) the revisionlog as a collection of revision entries.
     Return nil on failure.

     If numRevisions is notNil, it limits the number of revision records returned -
     only numRevions of the newest revision infos will be collected.

     The returned information is a structure (IdentityDictionary)
     filled with:
            #newestRevision     -> the revisionString of the newest revision
            #numberOfRevisions  -> the number of revisions in the container (nil for all)
            #revisions          -> collection of per-revision info (see below)

            firstRev / lastRef specify from which revisions a logEntry is wanted:
             -If firstRev is nil, the first revision is the initial revision
              otherwise, the log starts with that revision.
             -If lastRef is nil, the last revision is the newest revision
              otherwise, the log ends with that revision.

             -If both are nil, all logEntries are extracted.
             -If both are 0 (not nil), no logEntries are extracted (i.e. only the header).

            per revision info consists of one record per revision:

              #revision              -> the revision string
              #author                -> who checked that revision into the repository
              #date                  -> when was it checked in
              #state                 -> the RCS state
              #logMessage            -> the checkIn log message

            revisions are ordered newest first
            (i.e. the last entry is for the initial revision; the first for the most recent one)
            Attention: if state = 'dead' that revision is no longer valid.
        "

    |workSpace rslt|

    workSpace := self getWorkSpaceForPackage:aPackage.

    workSpace isNil ifTrue:[
        ('PerforceSourceCodeManager [warning]: cant get workspace definition for module ', aPackage) errorPrintCR.
        ^ nil.
    ].
    self perforceError handle:[:ex|
        self reportError:ex description.
        ex proceed.
    ] do:[
        rslt := workSpace revisionLogOf:clsOrNil 
            fromRevision:firstRev 
            toRevision:lastRef 
            numberOfRevisions:numRevisions 
            fileName:classFileName 
            directory:packageDir 
            module:aPackage.
    ].
    ^rslt
    "
     AbstractSourceCodeManager revisionLogOf:ExtIF
     SourceCodeManager revisionLogOf:Array fromRevision:'1.40' toRevision:'1.43'
     SourceCodeManager revisionLogOf:Array fromRevision:'1.40' toRevision:nil
     SourceCodeManager revisionLogOf:Array fromRevision:nil toRevision:'1.3'
     SourceCodeManager revisionLogOf:Array fromRevision:nil toRevision:nil
     SourceCodeManager revisionLogOf:Array fromRevision:0 toRevision:0
    "

    "Created: / 16-11-1995 / 13:25:30 / cg"
    "Modified: / 29-01-1997 / 16:51:30 / stefan"
    "Modified: / 29-08-2006 / 14:57:26 / cg"
!

setSymbolicName:symbolicName revision:rev overWrite:overWriteBool classes:aCollectionOfClasses
    "set a symbolicName for revision rev.
     If rev is nil, set it for the head (most recent) revision.
     If rev is 0, delete the symbolic name.
     If overWriteBool is true, the symbolicName will be changed, even if it has already been set.
     If overWriteBool is false, an error will be raised if symbolicName has already been set.

     If filename is nil, the symbolicName for a whole package is set"

    |paths workSpace|

    paths := aCollectionOfClasses
                collect:[:cls | (self sourceInfoOfClass:cls) at:#pathInRepository].


    workSpace := nil.
    workSpace isNil ifTrue:[
        self information:'Implementation of setting Labels not finished yet'.
        ^self.
    ].
    workSpace
        setSymbolicName:symbolicName
        revision:rev
        overWrite:overWriteBool
        pathes:paths

    "
     self setSymbolicName:'foo' revision:nil overWrite:false classes:(Array with:True with:False)
     self setSymbolicName:'foo' revision:nil overWrite:true classes:(Array with:True with:False)
     self setSymbolicName:'foo' revision:nil overWrite:true classes:(Array with:True with:False)
     self setSymbolicName:'foo' revision:'1.1' overWrite:true classes:(Array with:True with:False)
     self setSymbolicName:'foo' revision:0 overWrite:true classes:(Array with:True with:False)
    "

    "Created: / 12-09-2006 / 12:58:23 / cg"
!

streamForClass:cls fileName:fileName revision:revision directory:packageDir module:moduleDir cache:doCache
    "extract a classes source code and return an open readStream on it.
     A revision of nil selects the current (in image) revision.
     The classes source code is extracted using the revision and the sourceCodeInfo,
     which itself is extracted from the classes packageString."

    |checkInDefinition workSpace|

    checkInDefinition := CheckInDefinition new.
    checkInDefinition setDefinitionClass:cls.
    checkInDefinition classFileName:fileName.
    checkInDefinition package:moduleDir.
    checkInDefinition packageDir:packageDir.
    checkInDefinition manager:self.

    workSpace := self getWorkSpaceForPackage:(checkInDefinition packageString).
    workSpace isNil ifTrue:[
	('PerforceSourceCodeManager [error]: failed to create workspace for', checkInDefinition fileName)  errorPrintCR.
	^ nil
    ].

    checkInDefinition workSpace:workSpace.
    self perforceError handle:[:ex|
	self reportError:ex description.
	ex proceed.
    ] do:[
	^workSpace streamFor:checkInDefinition revision:revision cache:doCache.
    ].
    ^nil
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

    (log at:#revisions) do:[:entry |
        |logMsg|

        aStream cr.
        aStream nextPutAll:'  revision '; 
            show:(entry at:#revision); tab.
        aStream nextPutAll:' date: '; 
            show:((entry at:#date ifAbsent:nil) ? '?'); space;
            show:((entry at:#time ifAbsent:nil) ? '?'); tab.
        aStream nextPutAll:' author: '; 
            show:(entry at:#author ifAbsent:nil) ? '?'; tab.

        logMsg := entry at:#logMessage ifAbsent:''.
        (logMsg isBlank or:[logMsg withoutSeparators = '.']) ifTrue:[
            logMsg := '*** empty log message ***'
        ].
        aStream tab; nextPutLine:logMsg.
    ].

    "Created: / 16-11-1995 / 13:25:30 / cg"
    "Modified: / 27-11-1996 / 18:26:30 / stefan"
    "Modified: / 21-12-2011 / 23:33:53 / cg"
! !

!PerforceSourceCodeManager class methodsFor:'private'!

getCheckInDefinitionForClass:aClass

    |checkInDefinition|

    checkInDefinition := CheckInDefinition new.
    checkInDefinition manager:self.
    checkInDefinition setDefinitionClass:aClass.
    ^checkInDefinition
!

moduleFromContainerPath:containerPath forPackage:packageID
    "given a full path as in an RCS header, extract the module."

    | realPackageID|

    realPackageID := PackageId from:packageID.
    realPackageID isNil ifTrue:[
	^nil
    ].
    ^ realPackageID module


    "
     SourceCodeManager moduleFromContainerPath:'/files/CVS/stx/libbasic/Array.st' forPackage:Array package
    "

    "Created: / 25.11.1995 / 18:42:20 / cg"
    "Modified: / 11.8.1998 / 23:01:24 / cg"
!

postCheckInClass:class checkInDefinition:checkInDefinition

    self postCheckInClass:class.
    ^ true                                                            
!

reportError:msg
    |fullMsg|

    fullMsg := self nameWithoutNameSpacePrefix,' [error]: ',msg.
    fullMsg errorPrintCR.
    SourceCodeManagerError isHandled ifTrue:[
        SourceCodeManagerError raiseErrorString:fullMsg.
    ] ifFalse:[
        self warn:fullMsg.
    ].

    "Created: / 29-08-2006 / 12:44:19 / cg"
!

submitInfoDialogClass

    ^ PerforceSourceCodeManagerUtilities  submitInfoDialogClass

    "Modified: / 01-06-2012 / 11:10:12 / cg"
!

updateVersionMethodOf:aClass for:newRevisionString
    " redefinition because I like to handle my version updates by myself "

    super updateVersionMethodOf:aClass for:newRevisionString.
    ^ self
!

updatedRevisionStringOf:aClass forRevision:newRevision with:originalVersionString
    "update a revision string"

    |versionInfo module workSpace|

    originalVersionString isEmptyOrNil ifTrue:[
        workSpace := self getWorkSpaceForPackage:module.
        workSpace isNil ifTrue:[
            self reportError:('no workSpace for class: ' , aClass name).
            ^ nil
        ].
        versionInfo := workSpace updatedRevisionStringOf:aClass forRevision:newRevision with:originalVersionString.
    ] ifFalse:[
        versionInfo := PerforceVersionInfo fromRCSString:originalVersionString.
        versionInfo isNil ifTrue:[
            ^nil
        ].
    ].
    versionInfo revision:newRevision printString.
    ^ versionInfo getVersionString.



"
    self updatedRevisionStringOf:nil
            forRevision:'6'
            with:'$','Header','$'
"
! !

!PerforceSourceCodeManager class methodsFor:'queries'!

checkInInfoDialogClass

    ^PerforceSourceCodeManagerUtilities checkInInfoDialogClass
!

checkPerforceSettings:aSettingsString forPackage:aPackage 
    "
        create an temporary workspace for handle checkin"
    
    |workSpace perforceSettings|

    perforceSettings := self getPerforceSettingsFromString:aSettingsString.
    aPackage notNil ifTrue:[
        (self hasPackage:aPackage) ifFalse:[
            self perforceError raiseErrorString:('Package <', aPackage, '> not exists.').
        ]
    ].
    workSpace := self getWorkSpaceForSettings:aSettingsString.
    aSettingsString isEmptyOrNil ifTrue:[
        self perforceError raiseErrorString:('No valid settings <', aSettingsString, '>.').
    ].

    workSpace isNil ifTrue:[
        self perforceError handle:[:ex|
            self reportError:ex description.
            ^false
        ] do:[
            workSpace := self workSpaceClass newWorkSpaceFor:aSettingsString.
        ].
        workSpace isNil ifTrue:[
            ^false
        ].
    ].
    (workSpace hasViewForPackage:aPackage) ifFalse:[
        self perforceError raiseErrorString:('No View for Settings <', aSettingsString, '>  and Package <', aPackage, '>. Please check Workspace settings with Perforce Tools.').
    ].
    ^ true

    "
     self checkPerforceSettings:'penk_DEL00089:penk:@localhost:1666' forPackage:'stx/libbasic3' 
     self checkPerforceSettings:'penk_DEL00089:penk:@localhost:1666' forPackage:'balla'
    self perforceError handle:[:ex|
        self reportError:ex description.
        ^false
    ] do:[
         self checkPerforceSettings:'penk_DEL0ss0089:penk:@localhost:1666' forPackage:'balla'
    ].
        
    "

    "Modified: / 01-06-2012 / 11:06:36 / cg"
!

getTrailungPathNameFrom:path1 with:path2

" path1 have to start with path2 not the other way around "

    |componentsPath1 componentsPath2 locPath1 locPath2|

    ((path1 first = $/) and:[path1 second = $/]) ifTrue:[
        locPath1 := path1 copyFrom:2.
    ] ifFalse:[
        locPath1 := path1.
    ].
    ((path2 first = $/) and:[path2 second = $/]) ifTrue:[
        locPath2 := path2 copyFrom:2.
    ] ifFalse:[
        locPath2 := path2.
    ].
    componentsPath1 := locPath1 asFilename components.
    componentsPath2 := locPath2 asFilename components.
    componentsPath1 size <= componentsPath2 size ifTrue:[
        ^path1
    ].
    ^ (Filename fromComponents:(componentsPath1 copyFrom:(componentsPath2 size + 1))) pathName.
"
self getTrailungPathNameFrom:'foo/bar' with:'foo'     
self getTrailungPathNameFrom:'foo' with:'foo/bar'     
self getTrailungPathNameFrom:'//depot/' with:'//depot/applistx/util/libDataType/ActionLQualifier.st'     
self getTrailungPathNameFrom:'//depot/applistx/util/libDataType/ActionLQualifier.st' with:'//depot/'     
"
!

getWorkSpaceForPackage:aPackage  
    "
        get the workspace definition from perforce client command output"
    
    |workSpace settingsString|

    aPackage isNil ifTrue:[
        ^nil
    ].
    aPackage notNil ifTrue:[
        settingsString := self getPerforceSettingsForPackage:aPackage.
        settingsString isNil ifTrue:[
            self perforceError raiseErrorString:('No Perforce Settings for Package <', aPackage, '>. Please define in Settings Dialog.').
            ^ nil
        ].
    ].
    self perforceWorkspaces do:[:aWorkSpace | 
        aWorkSpace perforceSettingsString = settingsString ifTrue:[
            (aWorkSpace hasViewForPackage:aPackage) ifTrue:[
                ^aWorkSpace
            ].
        ].
    ].
    self perforceError handle:[:ex|
        self reportError:ex description.
        ^nil
    ] do:[
        workSpace := self workSpaceClass newWorkSpaceFor:settingsString.
    ].
    workSpace isNil ifTrue:[
        ^nil
    ].
    (workSpace hasViewForPackage:aPackage) ifTrue:[
        self perforceWorkspaces at:settingsString put:workSpace.
        ^workSpace
    ].
    ^nil

"
    | workSpace |
    self getPerforceSettingsForPackage:'applistxaa'.
    self perforceError handle:[:ex|
        self reportError:ex description.
    ] do:[
        workSpace := self getWorkSpaceForPackage:'applistxaa'.
    ].
    workSpace
"

    "Modified: / 01-06-2012 / 11:06:33 / cg"
!

getWorkSpaceForSettings:aSettingsString  

    self perforceWorkspaces do:[:aWorkSpace | 
        aWorkSpace perforceSettingsString = aSettingsString ifTrue:[
            ^aWorkSpace
        ].
    ].
    ^nil

"
    | workSpace |
    self getPerforceSettingsForPackage:'applistxaa'.
    self perforceError handle:[:ex|
        self reportError:ex description.
    ] do:[
        workSpace := self getWorkSpaceForPackage:'applistxaa'.
    ].
    workSpace
"
!

hasPackage:aPackage

    Smalltalk allPackageIDs do:[:aId|
        (aId startsWith:aPackage) ifTrue:[
            ^true
        ].
    ].
    ^false
!

isPerforce
    "Superclass AbstractSourceCodeManager class says that I am responsible to implement this method"

    ^ true
!

isResponsibleForPackage:aStringOrSymbol
    "superclass AbstractSourceCodeManager class says that I am responsible to implement this method"

    ^true
!

managerTypeName
    "Superclass AbstractSourceCodeManager class says that I am responsible to implement this method"

    ^ 'Perforce'
!

managerTypeNameShort
    "Answers short version manager name suitable for UI,
     i,e., CVS, SVN, P4. Used in cases where sorter strings
     are preferred. Defaults to #managerTypeName"

    ^'P4'

    "Created: / 03-10-2011 / 13:28:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 04-12-2011 / 10:15:31 / cg"
!

nameOfVersionMethodForExtensions
    ^ #'extensionsVersion_P4'
!

nameOfVersionMethodInClasses
    ^ #'version_P4'
!

path:path1 hasSamePrefixLikePath:path2

" path1 have to start with path2 not the other way around "

    |locPath1 locPath2 componentsPath1 componentsPath2|

    ((path1 first = $/) and:[path1 second = $/]) ifTrue:[
        locPath1 := path1 copyFrom:2.
    ] ifFalse:[
        locPath1 := path1.
    ].
    ((path2 first = $/) and:[path2 second = $/]) ifTrue:[
        locPath2 := path2 copyFrom:2.
    ] ifFalse:[
        locPath2 := path2.
    ].
    componentsPath1 := locPath1 asFilename components.
    componentsPath2 := locPath2 asFilename components.
    componentsPath2 size > componentsPath1 size ifTrue:[
        ^false
    ].
    componentsPath2 doWithIndex:[:component :index|
        ((componentsPath1 at:index) ~= component) ifTrue:[
            ^false
        ].
    ].
    ^true
"
self path:'foo/bar' hasSamePrefixLikePath:'foo'   
self path:'foo' hasSamePrefixLikePath:'foo/bar'  
self path:'//depot/applistx/util/libDataType/ActionLQualifier.st' hasSamePrefixLikePath:'//depot/'  
self path:'//depot/' hasSamePrefixLikePath:'//depot/applistx/util/libDataType/ActionLQualifier.st'  

"
!

perforceError

    ^PerforceError
!

perforceTmpDirectory
    "return the name of the tmp repository.
     That's the directory, where temporary files are created for checkin/checkout.
     If nil, a directory under the system's default tempDirectory is used."

    |d|

    PerforceTempDir notNil ifTrue:[^ PerforceTempDir].
    d := Filename tempDirectory / 'stx_p4'.
    d exists ifFalse:[
        d recursiveMakeDirectory.
    ].
    ^ d pathName

    "
     PerforceTempDir := nil
    "

    "Modified (comment): / 24-09-2012 / 11:09:26 / cg"
!

removeWorkSpaceForSettings:settingsString

    |workSpace|

    workSpace := self perforceWorkspaces at:settingsString ifAbsent:nil.
    workSpace notNil ifTrue:[
        self perforceError handle:[:ex|
            self reportError:ex description.
            ex proceed.
        ] do:[
            workSpace releaseWorkSpace.
        ].
        self perforceWorkspaces removeKey:settingsString ifAbsent:nil.
    ].

"
self perforceWorkspaces remove:(self perforceWorkspaces first)
"
!

settingsApplicationClass
    "link to my settings application (needed for the settings dialog"

    ^ PerforceSourceCodeManagementSettingsAppl

    "Created: / 19-04-2011 / 12:45:13 / cg"
    "Modified: / 20-04-2011 / 12:49:41 / cg"
!

versionInfoClass

    ^PerforceVersionInfo
! !

!PerforceSourceCodeManager class methodsFor:'queries - settings'!

getPerforceDefaultSettingsString

    ^(PerforceSourceCodeManager perforceClient ,':',
       PerforceSourceCodeManager perforceUser, ':',
       (PerforceSourceCodeManager perforcePassword ? ''), '@',
       PerforceSourceCodeManager perforcePort).

    "Modified: / 19-04-2011 / 10:46:37 / cg"
!

getPerforcePasswordForModule:aModuleName

    | settings settingsString|

    aModuleName isNil ifTrue:[^ nil].
    settingsString := self getPerforceSettingsForPackage:aModuleName.
    settingsString isNil ifTrue:[^ PerforcePassword].
    settings := self getPerforceSettingsFromString:settingsString.
    ^ settings at:#password ifAbsent:PerforcePassword.
!

getPerforcePortForModule:aModuleName

    | settings settingsString|

    aModuleName isNil ifTrue:[^ nil].
    settingsString := self getPerforceSettingsForPackage:aModuleName.
    settingsString isNil ifTrue:[^ PerforcePort].
    settings := self getPerforceSettingsFromString:settingsString.
    ^ settings at:#port ifAbsent:PerforcePort.
!

getPerforceSettingsForPackage:aPackage

    |samePath|

    aPackage isNil ifTrue:[^ nil].
    self repositoryInfoPerModule keysAndValuesDo:[:package :settings|
        samePath := self path:aPackage asPackageId pathRelativeToTopDirectory hasSamePrefixLikePath:package asPackageId pathRelativeToTopDirectory.
        samePath ifTrue:[
            ^settings
        ].
    ].
    (((self managerForPackage:aPackage) == self) or:[(Smalltalk at:#SourceCodeManager) == self]) ifTrue:[
        ^ self getPerforceDefaultSettingsString.
    ].
    ^nil
    
"
self getPerforceSettingsForPackage:'applistx'
"
!

getPerforceSettingsFromString:aString

    |clientAndPort noOfClientAndPortElements userAndClientAndPassword noOfUserAndClient settings |

    settings := Dictionary new.
    clientAndPort := aString asCollectionOfSubstringsSeparatedBy:$@.
    noOfClientAndPortElements := clientAndPort size.
    noOfClientAndPortElements > 0 ifTrue:[
        userAndClientAndPassword := clientAndPort first asCollectionOfSubstringsSeparatedBy:$:.
        noOfUserAndClient := userAndClientAndPassword size.
        noOfUserAndClient > 0 ifTrue:[
            settings at:#client put:userAndClientAndPassword first.
        ].
        noOfUserAndClient > 1 ifTrue:[
            settings at:#user put:userAndClientAndPassword second.
        ].
        (noOfUserAndClient > 2 and:[userAndClientAndPassword third notEmpty]) ifTrue:[
            settings at:#password put:userAndClientAndPassword third.
        ].
    ].
    noOfClientAndPortElements > 1 ifTrue:[
        settings at:#port put:clientAndPort second.
    ].
    ^ settings

"
self getPerforceSettingsFromString:'alspa:penk:@perlin:1666'
"
!

getPerforceUserForModule:aModuleName

    | settings settingsString|

    aModuleName isNil ifTrue:[^ nil].
    settingsString := self getPerforceSettingsForPackage:aModuleName.
    settingsString isNil ifTrue:[^ PerforcePassword].
    settings := self getPerforceSettingsFromString:settingsString.
    ^ settings at:#password ifAbsent:PerforcePassword.
!

getStringFromPerforceSettings:perforceSettings

    |settingsStream client user password port|

    settingsStream := WriteStream on:''.
    client := perforceSettings at:#client ifAbsent:nil.
    client notNil ifTrue:[
        settingsStream nextPutAll:client.
        settingsStream nextPut:$:.
    ].
    user := perforceSettings at:#user ifAbsent:nil.
    user notNil ifTrue:[
        settingsStream nextPutAll:user.
        settingsStream nextPut:$:.
    ].
    password := perforceSettings at:#password ifAbsent:nil.
    password notNil ifTrue:[
        settingsStream nextPutAll:password.
        settingsStream nextPut:$:.
    ].
    settingsStream nextPut:$@.
    port := perforceSettings at:#port ifAbsent:nil.
    port notNil ifTrue:[
        settingsStream nextPutAll:port.
    ].
    ^ settingsStream contents.


"
self getStringFromPerforceSettings:(self getPerforceSettingsFromString:'alspa:penk:@perlin:1666')
"
! !

!PerforceSourceCodeManager class methodsFor:'subclass responsibility'!

getExistingContainersInModule:aModule directory:aPackage
    "{ Pragma: +optSpace }"

    " can be easy done with dirs command "

    self shouldImplement
!

getExistingDirectoriesInModule:aModule
    "{ Pragma: +optSpace }"

    self shouldImplement
!

getExistingModules
    "{ Pragma: +optSpace }"

    self shouldImplement
!

reportHistoryLogSince:timeGoal filterSTSources:filter filterUser:userFilter filterRepository:repositoryFilter filterModules:moduleFilter inTo:aBlock
    "Superclass AbstractSourceCodeManager class says that I am responsible to implement this method"

    self shouldImplement
! !

!PerforceSourceCodeManager::CheckInDefinition methodsFor:'accessing'!

classFileName
    ^ classFileName
!

classFileName:something
    classFileName := something.
!

definitionClass
    ^ definitionClass
!

fileContents
    ^ fileContents
!

fileContents:something
    fileContents := something.
!

logMessage
    ^ logMessage
!

logMessage:something
    logMessage := something.
!

manager

    ^ manager
!

manager:something
    manager := something.
!

package
    ^ package
!

package:something
    package := something.
!

packageDir
    ^ packageDir
!

packageDir:something
    packageDir := something.
!

revisionStringBeforeAction
    ^ revisionStringBeforeAction
!

revisionStringBeforeAction:something
    revisionStringBeforeAction := something.
!

setDefinitionClass:something
    definitionClass := something.
    self  revisionStringBeforeAction:self getLocalRevisionString.
!

setLogMessage:something
    something isNil ifTrue:[
        logMessage := ''.
        ^ true.
    ] ifFalse:[
        logMessage := something asSingleByteStringIfPossible.
        ^ logMessage isWideString not.
    ].
!

sourceFileName
    ^ sourceFileName
!

sourceFileName:something
    sourceFileName := something.
!

tempDirectory:something
    tempDirectory := something.
!

workSpace
    ^ workSpace
!

workSpace:something
    workSpace := something.
! !

!PerforceSourceCodeManager::CheckInDefinition methodsFor:'actions'!

getBinaryRevision

    |locRevision |

    definitionClass isNil ifTrue:[ ^nil].
    locRevision := definitionClass binaryRevision.
    ^ locRevision
!

getBinaryRevisionNumber

    |locRevision |

    locRevision := self getBinaryRevision.
    locRevision notNil ifTrue:[
        locRevision := locRevision asNumber.
    ].
    ^ locRevision
!

getLocalRevision

    |locRevisionString versionInfo|

    locRevisionString := self getLocalRevisionString.
    locRevisionString notNil ifTrue:[
        versionInfo := PerforceSourceCodeManager versionInfoClass fromRCSString:locRevisionString.
        versionInfo isNil ifTrue:[ ^nil].
        ^versionInfo revision
    ].
    ^ nil
!

getLocalRevisionNumber

    |locRevision locRevisionNumber|

    locRevision := self getLocalRevision.
    locRevision notNil ifTrue:[
        locRevisionNumber := Number readFrom:locRevision onError:nil.
    ].
    ^ locRevisionNumber
!

getLocalRevisionString

    |locRevisionString |

    definitionClass isNil ifTrue:[ ^nil].
    locRevisionString := definitionClass revisionStringOfManager:self manager.
    ^ locRevisionString
!

getReposRevisionAfterCheckin

    |log|

    log := self getReposRevisionInfoAfterCheckin.
    log isNil ifTrue:[^ nil].
    ^ log at:#newestRevision ifAbsent:nil
!

getReposRevisionBeforeCheckin

    |log|

    log := self getReposRevisionInfoBeforeCheckin.
    log isNil ifTrue:[^ nil].
    ^ log at:#newestRevision ifAbsent:nil
!

getReposRevisionInfoAfterCheckin

    reposRevisionInfoAfterAction isNil ifTrue:[
        reposRevisionInfoAfterAction := self manager revisionLogOf:nil 
            fromRevision:0 
            toRevision:0 
            fileName:self fileName 
            directory:packageDir 
            module:package.
    ].
    ^ reposRevisionInfoAfterAction
!

getReposRevisionInfoBeforeCheckin

    reposRevisionInfoBeforeAction isNil ifTrue:[
        reposRevisionInfoBeforeAction := self manager revisionLogOf:nil 
            fromRevision:0 
            toRevision:0 
            fileName:self fileName 
            directory:packageDir 
            module:package.
    ].
    ^ reposRevisionInfoBeforeAction
!

getReposRevisionNumberAfterCheckin

    | newestRevisionInfo newestRevisionString|

    newestRevisionInfo := self getReposRevisionInfoAfterCheckin.
    newestRevisionInfo isNil ifTrue:[ ^nil].
    newestRevisionString := newestRevisionInfo at:#newestRevision ifAbsent:nil.
    newestRevisionString isEmptyOrNil ifTrue:[ ^nil].
    ^ Number readFrom:(ReadStream on:newestRevisionString) onError:nil
!

getReposRevisionNumberBeforeCheckin

    | newestRevisionInfo newestRevisionString|

    newestRevisionInfo := self getReposRevisionInfoBeforeCheckin.
    newestRevisionInfo isNil ifTrue:[ ^nil].
    newestRevisionString := newestRevisionInfo at:#newestRevision ifAbsent:nil.
    newestRevisionString isEmptyOrNil ifTrue:[ ^nil].
    ^ Number readFrom:(ReadStream on:newestRevisionString) onError:nil
! !

!PerforceSourceCodeManager::CheckInDefinition methodsFor:'queries'!

definitionObjectString

    definitionClass notNil ifTrue:[
        ^definitionClass name
    ].
    sourceFileName notNil ifTrue:[
        ^sourceFileName
    ].
    ^'?'
!

fileName
    ^classFileName ? sourceFileName
!

isClassCheckin

    ^definitionClass notNil
!

packageString

    ^ (PackageId module:package directory:packageDir) asString. 
! !

!PerforceSourceCodeManager::PerforceVersionInfo class methodsFor:'documentation'!

documentation
"
    In ancient times, Class used to return a Dictionary when asked for versionInfo.
    This has been replaced by instances of VersionInfo and subclasses.

    PerforceVersionInfo adds some P4 specific data.

    [author:]
        cg (cg@AQUA-DUO)
"
! !

!PerforceSourceCodeManager::PerforceVersionInfo class methodsFor:'instance creation'!

fromRCSString:aString
    "cg: I guess this was copy-pasted and then not renamed, as it should.
     Also the comments are still referring th CVS.
     As this is a customer-provided method, and I don't know about any
     consequences, I'll not fix and rename the method"

    "{ Pragma: +optSpace }"

    "I know how to parse RCS/CVS version id strings.
     Return an instance filled with revision info which is
     extracted from aString. This must be in RCS/CVS format."

    |words firstWord info s depotName revNumber rest hashIndex revNumberIndex|

    s := aString readStream.
    s skipSeparators.
    firstWord := s upToSeparator.

    info := self new.

    "/
    "/ supported formats:
    "/
    "/ $-Header:   pathName rev date time user state $
    "/ $-Revision: rev $
    "/ $-Id:       fileName rev date time user state $
    "/
    (firstWord = ('$','Header:')        "/ WARNING: need to split the strings to prevent CVS from expanding them
    or:[firstWord = ('','Header:') 
    or:[firstWord = ('$','Id:') 
    or:[firstWord = ('','Id:')]]]) ifTrue:[
        s skipSeparators.
        rest := s upToEnd.
        hashIndex := rest indexOf:$#.
        hashIndex = 0 ifTrue:[
            " not a perforce RCS version string"
            ^nil
        ].
        depotName := rest copyTo:(hashIndex - 1).
        info repositoryPathName:depotName.
        info fileName:(depotName asFilename baseName).
        revNumberIndex := rest indexOfSeparatorStartingAt:hashIndex.
        revNumber := (rest copyFrom:(hashIndex + 1) to:(revNumberIndex -1 )).
        info revision:revNumber.
        words := s upToEnd asCollectionOfWords readStream.

        ^ info
    ].
    ^ nil

    "
     | versionInfo s|
     versionInfo := PerforceVersionInfo fromRepositoryPathName:'//depot/applistx/util/rtdb/RTDBInterfaceInspector.st'.
     versionInfo revision:26.
     versionInfo user:'penk'.
     s := CharacterWriteStream on:(String basicNew:40).    
     Date today printOn:s format:'%d-%m-%y' language:nil.
     versionInfo date:s contents.
     s := CharacterWriteStream on:(String basicNew:40).    
     Timestamp now printOn:s format:'%h-%m-%s.%i'.
     versionInfo time:s contents.
     PerforceVersionInfo fromRCSString:versionInfo getVersionString.
     PerforceVersionInfo fromRCSString:'$Header$'
    "

    "Modified: / 01-06-2012 / 13:32:40 / cg"
!

fromRepositoryPathName:something

    |inst|

    inst := self new.
    inst repositoryPathName:something.
    ^inst
! !

!PerforceSourceCodeManager::PerforceVersionInfo methodsFor:'accessing'!

repositoryPathName
    ^ repositoryPathName
!

repositoryPathName:something
    repositoryPathName := something.
    self fileName:repositoryPathName asFilename baseName.
!

revisionNumber

    revision isNil ifTrue:[ ^nil].
    revisionNumber isNil ifTrue:[
        revisionNumber := Number readFrom:(ReadStream on:revision) onError:nil.
    ].
    ^ revisionNumber
!

state
    ^ ''
!

timeZone
    ^ ''
!

timezone
    ^ ''

    "Created: / 22-10-2008 / 20:50:39 / cg"
! !

!PerforceSourceCodeManager::PerforceVersionInfo methodsFor:'queries'!

getVersionString

    |stream|

    stream := WriteStream on:''.
    stream nextPutAll:'$Header: '.
    stream nextPutAll:repositoryPathName.
    stream nextPut:$#.
    stream nextPutAll:revision printString.
    stream space.
    stream nextPut:$$.
        
    ^ stream contents
!

getVersionString_ownVersion

    |stream|

    stream := WriteStream on:''.
    stream nextPutAll:'Path:'.
    stream space.
    stream nextPutAll:repositoryPathName.
    stream nextPut:$#.
    stream nextPutAll:revision printString.
    self user notNil ifTrue:[
        stream space.
        stream nextPutAll:'User:'.
        stream space.
        stream nextPutAll:self user printString.
    ].
    self date notNil ifTrue:[
        stream space.
        stream nextPutAll:'Date:'.
        stream space.
        stream nextPutAll:self date printString.
    ].
    self time notNil ifTrue:[
        stream space.
        stream nextPutAll:'Time:'.
        stream space.
        stream nextPutAll:self time printString.
    ].
        
    ^ stream contents
! !

!PerforceSourceCodeManager class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

