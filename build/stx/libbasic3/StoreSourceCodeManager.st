"
 COPYRIGHT (c) 2006 eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic3' }"

AbstractSourceCodeManager subclass:#StoreSourceCodeManager
	instanceVariableNames:''
	classVariableNames:'Verbose Connection DefaultDBInfo DBInfoPerModule'
	poolDictionaries:''
	category:'System-SourceCodeManagement'
!

Object subclass:#DBInfo
	instanceVariableNames:'hostName dbName userName password'
	classVariableNames:''
	poolDictionaries:''
	privateIn:StoreSourceCodeManager
!

!StoreSourceCodeManager class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 eXept Software AG
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
    WARNING:
        this class is incomplete and provided as a sceletton
        if CVS is not to be used as a SourceCodeManager.
        We highly recommend to use CVS.

    SourceCodeManager which accesses sourcecode through a Store Database.
    This class is part of ongoing development and not yet released for public use.
"
! !

!StoreSourceCodeManager class methodsFor:'initialization'!

connectToDatabase
    |session dbInfo|

    dbInfo := self defaultDBInfo.

    SQL::SQLError handle:[:ex |
        self warn:('Failed to connect to Database:\\' withCRs,ex description).
        ^ self.
    ] do:[
        session := self tryToConnectToDatabase:dbInfo.
    ].

    session isNil ifTrue:[
        self warn:'OOPS - Failed to connect to Database'.
        ^ self
    ].
    Connection := session.
    Transcript showCR:('Connected to Store-DB: ',dbInfo hostAndDBName).
!

tryToConnectToDatabase:dbInfo
    |session|

    session := SQL::ODBCSession new.
    session 
        connectWithUsername:(dbInfo userName) 
        password:(dbInfo password) 
        dbname:(dbInfo dbName).

    (session isConnected) ifFalse:[
        ^ nil.
    ].
    ^ session
! !

!StoreSourceCodeManager class methodsFor:'accessing'!

dbName
    ^ self defaultDBInfo dbName
!

dbName:aString
    self defaultDBInfo dbName:aString.
!

defaultDBInfo
    DefaultDBInfo isNil ifTrue:[
        DefaultDBInfo := DBInfo new
    ].
    ^ DefaultDBInfo
!

hostAndDBName
    ^ self defaultDBInfo hostAndDBName
!

hostAndDBName:aString
    self defaultDBInfo hostAndDBName:aString.
!

hostName
    ^ self defaultDBInfo hostName
!

hostName:aString
    self defaultDBInfo hostName:aString.
!

newDBInfo
    ^ DBInfo new
!

password
    ^ self defaultDBInfo password
!

password:aString
    self defaultDBInfo password:aString.
!

repositoryInfoPerModule
    ^ DBInfoPerModule ? #()

    "Created: / 16-08-2006 / 11:06:09 / cg"
!

repositoryInfoPerModule:aCollectionOfDBinfos
    DBInfoPerModule := aCollectionOfDBinfos

    "Created: / 16-08-2006 / 11:06:09 / cg"
!

repositoryNameForPackage:packageId 
    "superclass AbstractSourceCodeManager class says that I am responsible to implement this method"
    
    ^ self shouldImplement
!

userName
    ^ self defaultDBInfo userName
!

userName:aString
    self defaultDBInfo userName:aString.
! !

!StoreSourceCodeManager class methodsFor:'basic access'!

checkinClass:aClass fileName:classFileName directory:packageDir module:moduleDir source:sourceFile logMessage:logMessage force:force
    "checkin of a class into the source repository.
     Return true if ok, false if not."

    ^ self shouldImplement
!

checkoutModule:aModule directory:aPackage andDo:aBlock
    "check out everything from a package into a temporary directory.
     Then evaluate aBlock, passing the name of that temp-directory.
     Afterwards, the tempDir is removed.
     Return true, if OK, false if any error occurred."

    ^ self shouldImplement
!

streamForClass:aClass fileName:classFileName revision:revision directory:packageDir module:moduleDir cache:doCache
    "extract a classes source code and return an open readStream on it.
     A revision of nil selects the current (in image) revision.
     The classes source code is extracted using the revision and the sourceCodeInfo,
     which itself is extracted from the classes packageString."

    ^ self shouldImplement
! !

!StoreSourceCodeManager class methodsFor:'basic administration'!

checkForExistingContainer:fileName inModule:moduleName directory:dirName
    "check for a container to be present"

    ^ self shouldImplement
!

checkForExistingModule:moduleName
    "check for a module directory to be present"

    ^ self shouldImplement
!

createContainerFor:aClass inModule:moduleName directory:dirName container:fileName
    "create a new container & check into it an initial version of aClass"

    ^ self shouldImplement
!

createModule:moduleName
    "create a new module directory"

    ^ self shouldImplement
!

createModule:module directory:directory
    "create a new package directory"

    ^ self shouldImplement
!

initialRevisionStringFor:aClass inModule:moduleDir directory:packageDir container:fileName
    "return a string usable as initial revision string"

    ^ self shouldImplement
!

revisionLogOf:clsOrNil 
    fromRevision:rev1OrNil toRevision:rev2OrNil numberOfRevisions:limitOrNil 
    fileName:classFileName directory:packageDir module:moduleDir

    "actually do return a revisionLog. The main worker method.
     This must be implemented by a concrete source-code manager"

    ^ self shouldImplement
! !

!StoreSourceCodeManager class methodsFor:'queries'!

isExperimental
    (OperatingSystem getLoginName = 'cg') ifTrue:[^ false].
    (OperatingSystem getLoginName = 'exept') ifTrue:[^ false].
    ^ true

    "Created: / 16-08-2006 / 11:23:09 / cg"
!

isResponsibleForPackage:aStringOrSymbol
    "superclass AbstractSourceCodeManager class says that I am responsible to implement this method"

    ^ self shouldImplement
!

managerTypeName
    ^ 'Store DB'

    "Created: / 16-08-2006 / 11:06:09 / cg"
!

managerTypeNameShort
    "Answers short version manager name suitable for UI,
     i,e., CVS, SVN, P4. Used in cases where sorter strings
     are preferred. Defaults to #managerTypeName"

    ^'StORE'

    "Created: / 03-10-2011 / 13:29:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 04-12-2011 / 10:15:45 / cg"
!

nameOfVersionMethodForExtensions
    ^ #'extensionsVersion_STORE'
!

nameOfVersionMethodInClasses
    ^ #'version_STORE'
!

settingsApplicationClass
    "link to my settings application (needed for the settings dialog"

    ^ StoreSourceCodeManagementSettingsAppl

    "Created: / 19-04-2011 / 12:44:26 / cg"
    "Modified: / 19-04-2011 / 13:52:34 / cg"
!

versionMethodKeyword

    "Answers the keyword used by the version management system to
     expand a current version in a file (_without_ dollars). For
     CVS it is 'Header', for SVN 'Id', others may use different
     keywords. If nil is returned, then the version management does
     not use any keyword."

    ^nil

    "Created: / 27-09-2011 / 16:47:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!StoreSourceCodeManager class methodsFor:'saving'!

savePreferencesOn:aStream
    aStream nextPutLine:'  StoreSourceCodeManager notNil ifTrue:['.
    aStream nextPutLine:'    StoreSourceCodeManager repositoryInfoPerModule:' , self repositoryInfoPerModule storeString , '.'.

    (Smalltalk at:#SourceCodeManager) == StoreSourceCodeManager ifTrue:[
        aStream nextPutLine:'    Smalltalk at:#SourceCodeManager put: StoreSourceCodeManager.'.
        aStream nextPutLine:'    StoreSourceCodeManager hostAndDBName:' , self hostAndDBName storeString , '.'.
        aStream nextPutLine:'    StoreSourceCodeManager dbName:' , self dbName storeString , '.'.
        aStream nextPutLine:'    StoreSourceCodeManager userName:' , self userName storeString , '.'.
    ].
    aStream nextPutLine:'  ].'.

    "Created: / 09-11-2006 / 15:10:25 / cg"
    "Modified: / 18-04-2011 / 17:15:12 / cg"
! !

!StoreSourceCodeManager class methodsFor:'source code administration'!

getExistingContainersInModule:aModule directory:aPackage
    "{ Pragma: +optSpace }"

    ^ self shouldImplement
!

getExistingDirectoriesInModule:aModule
    "{ Pragma: +optSpace }"

    ^ self shouldImplement
!

getExistingModules
    "{ Pragma: +optSpace }"

    ^ self shouldImplement
!

revisionInfoFromString:aString
    "{ Pragma: +optSpace }"

    ^ self shouldImplement
! !

!StoreSourceCodeManager class methodsFor:'subclass responsibility'!

reportHistoryLogSince:timeGoal filterSTSources:filter filterUser:userFilter filterRepository:repositoryFilter filterModules:moduleFilter inTo:aBlock
    "superclass AbstractSourceCodeManager class says that I am responsible to implement this method"

    ^ self shouldImplement
! !

!StoreSourceCodeManager class methodsFor:'testing'!

isStore
    ^ true

    "Created: / 16-08-2006 / 10:59:06 / cg"
! !

!StoreSourceCodeManager::DBInfo methodsFor:'accessing'!

dbName
    ^ dbName
!

dbName:something
    dbName := something.
!

hostAndDBName
    hostName isEmptyOrNil ifTrue:[ ^ dbName ].
    ^ dbName,'@',hostName
!

hostAndDBName: aString
    |idx|

    idx := aString indexOf:$@.
    idx == 0 ifTrue:[
        dbName := aString.
        hostName := nil.
    ] ifFalse:[
        dbName := aString copyTo:idx-1.
        hostName := (aString copyFrom:idx+1).
    ]
!

hostAndDBName:hostAndDBNameArg userName:userNameArg password:passwordArg 
    self hostAndDBName:hostAndDBNameArg.
    userName := userNameArg.
    password := passwordArg.
!

hostName
    ^ hostName
!

hostName:something
    hostName := something.
!

hostName:hostNameArg dbName:dbNameArg userName:userNameArg password:passwordArg 
    "set instance variables (automatically generated)"

    hostName := hostNameArg.
    dbName := dbNameArg.
    userName := userNameArg.
    password := passwordArg.
!

password
    ^ password
!

password:something
    password := something.
!

userName
    ^ userName
!

userName:something
    userName := something.
! !

!StoreSourceCodeManager::DBInfo methodsFor:'printing & storing'!

storeOn:aStream
    aStream 
        nextPutAll:'(';
        nextPutAll:self class name;
        nextPutAll:' basicNew';
        nextPutAll:' hostAndDBName:';
        store: self hostAndDBName;
        nextPutAll:' userName:';
        store: self userName;
        nextPutAll:' password:';
        store: self password;
        nextPutAll:')'.

    "
     self readFrom:(self basicNew hostAndDBName:'a' userName:'b' password:'c') storeString
     self readFrom:(self basicNew hostAndDBName:'a@h' userName:'b' password:'c') storeString
    "
! !

!StoreSourceCodeManager class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic3/StoreSourceCodeManager.st,v 1.25 2014-07-21 11:27:30 cg Exp $'
! !

