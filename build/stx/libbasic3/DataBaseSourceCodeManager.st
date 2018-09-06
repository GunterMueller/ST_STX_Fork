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

AbstractSourceCodeManager subclass:#DataBaseSourceCodeManager
	instanceVariableNames:''
	classVariableNames:'Verbose RepositoryName ModuleDBs CachedDBHandles'
	poolDictionaries:''
	category:'System-SourceCodeManagement'
!

VersionInfo subclass:#DBVersionInfo
	instanceVariableNames:'symbolicVersionName'
	classVariableNames:''
	poolDictionaries:''
	privateIn:DataBaseSourceCodeManager
!

!DataBaseSourceCodeManager class methodsFor:'documentation'!

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
    A simple database sourceCodeManager, which saves versions in a relational db

    unfinished

    [author:]
        Claus Gittinger
"
! !

!DataBaseSourceCodeManager class methodsFor:'accessing'!

getRepositoryDBForModule:aModuleName
    "internal: used when accessing a source repository.
     Return the db-name for a particular module.
     If no specific db was defined for that module, return the value of
     the global (fallBack) repositoryDB.
     Nil is returned if no repository is available." 

    ModuleDBs isNil ifTrue:[^ RepositoryName].
    aModuleName isNil ifTrue:[^ RepositoryName].
    ^ ModuleDBs at:aModuleName ifAbsent:RepositoryName.

    "Modified: / 20-05-1998 / 16:30:12 / cg"
    "Created: / 26-12-2011 / 00:30:17 / cg"
!

knownModules
    "return the modules, we currently know"

    ModuleDBs isEmptyOrNil ifTrue:[^ #() ].
    ^ ModuleDBs keys

    "Modified: / 26-12-2011 / 00:48:51 / cg"
!

repositoryInfoPerModule
    "return the dictionary, which associates repository paths to module names.
     If no entry is contained in this dictionary for some module,
     the default path will be used."

    ^ ModuleDBs ? #()
!

repositoryInfoPerModule:aDictionary
    "set the dictionary, which associates repository paths to module names.
     If no entry is contained in this dictionary for some module,
     the default path will be used."

    ModuleDBs := aDictionary
!

repositoryName
    "return the default repository"

    ^ RepositoryName ? self defaultRepositoryName

    "Created: / 26-12-2011 / 00:34:14 / cg"
!

repositoryName:aDBSpec
    "set the default repository"

    RepositoryName := aDBSpec.

    "Created: / 26-12-2011 / 01:13:59 / cg"
!

utilities
    "Returns a 'utilities' object that can be used by tools."

    ^ DataBaseSourceCodeManagerUtilities forManager: self
! !

!DataBaseSourceCodeManager class methodsFor:'private'!

closeAllCachedConnections
    CachedDBHandles notNil ifTrue:[
        CachedDBHandles do:[:each |
            each close
        ].
        CachedDBHandles := nil.
    ].
!

dbHandleForModule:aModuleName
    |dbName handle|

    CachedDBHandles isNil ifTrue:[
        CachedDBHandles := WeakValueDictionary new.
    ].

    handle := CachedDBHandles at:aModuleName ifAbsent:nil.
    handle notNil ifTrue:[^ handle ].

    dbName := self getRepositoryDBForModule:aModuleName.
    dbName isNil ifTrue:[
        self error:'no database'.
        ^ nil
    ].

    handle := self openDB:dbName.
    handle isNil ifTrue:[
        self error:'no database'.
        ^ nil
    ].
    CachedDBHandles at:aModuleName put:handle.
    ^ handle.

    "Created: / 26-12-2011 / 00:59:49 / cg"
!

openDB:aDBName
    |idx dbType dbSpec|

    idx := aDBName indexOf:$:.
    dbType := aDBName copyTo:idx-1.
    dbSpec := aDBName copyFrom:idx+1.

    dbType = 'sqlite' ifTrue:[
        ^ self openSQLite:dbSpec
    ].
    dbType = 'odbc' ifTrue:[
        ^ self openODBC:dbSpec
    ].
    self error:'unsupported dbtype'

    "Created: / 26-12-2011 / 01:05:57 / cg"
!

openODBC:dbSpec
    self halt:'unimplemented'.

    "Created: / 26-12-2011 / 01:06:41 / cg"
!

openSQLite:dbSpec
    |file con crsr tables row|

    file := dbSpec.
    con := SQLiteConnection fileNamed:file.
    con open.

    tables := OrderedCollection new.

    SqliteError handle:[:ex |
    ] do:[
        crsr := con executeQuery:'SELECT * FROM sqlite_master WHERE type=''table'';'. 
    ].
    crsr notNil ifTrue:[
        [ 
            crsr next.
            row := crsr rowAsDictionary.
            row notNil 
        ] whileTrue:[
            tables add:(row at:'name')
        ].
    ].

    (tables includes:'versions') ifTrue:[
        Transcript showCR:'DBSourceCodeManager: table "versions" already present.'.
    ] ifFalse:[
        Transcript showCR:'DBSourceCodeManager: creating table "versions"...'.
        con executeQuery:'CREATE table versions (versionId primary key, name, packageId, author, timestamp, state);'.
    ].

    (tables includes:'packages') ifTrue:[
        Transcript showCR:'DBSourceCodeManager: table "packages" already present.'.
    ] ifFalse:[
        Transcript showCR:'DBSourceCodeManager: creating table "packages"...'.
        con executeQuery:'CREATE table packages (packageId primary key, name);'.
    ].

    (tables includes:'classes') ifTrue:[
        Transcript showCR:'DBSourceCodeManager: table "classes" already present.'.
    ] ifFalse:[
        Transcript showCR:'DBSourceCodeManager: creating table "classes"...'.
        con executeQuery:'CREATE table classes (id primary key, name, superclass, category, definition, packageId, versionId, methodIdList);'.
    ].

    (tables includes:'methods') ifTrue:[
        Transcript showCR:'DBSourceCodeManager: table "methods" already present.'.
    ] ifFalse:[
        Transcript showCR:'DBSourceCodeManager: creating table "methods"...'.
        con executeQuery:'CREATE table methods (id primary key, className, selector, source, bytecode, packageId, versionId);'.
    ].

    (tables includes:'chunks') ifTrue:[
        Transcript showCR:'DBSourceCodeManager: table "chunks" already present.'.
    ] ifFalse:[
        Transcript showCR:'DBSourceCodeManager: creating table "chunks"...'.
        con executeQuery:'CREATE table chunks (id primary key, source);'.
    ].

    ^ con

    "Created: / 26-12-2011 / 01:06:37 / cg"
! !

!DataBaseSourceCodeManager class methodsFor:'private-saving'!

checkInClassAndCollectManifestOf:aClass db:dbConnection
    "check in a class; write one record for the definition,
     then one for each method.
     Return a manifest, which lists each save chunk's key."

    ^ String streamContents:[:s |
        s nextPutLine:(self manifestOfStoredClassDefinitionOf:aClass db:dbConnection).
        aClass theMetaclass selectorsAndMethodsDo:[:sel :mthd |
            (self isVersionMethodSelector:sel) ifTrue:[
                Transcript showCR:'skip ',sel.
            ] ifFalse:[
                s nextPutLine:(self manifestOfStoredMethod:mthd selector:sel meta:true db:dbConnection).
            ].
        ].
        aClass theNonMetaclass selectorsAndMethodsDo:[:sel :mthd |
            s nextPutLine:(self manifestOfStoredMethod:mthd selector:sel meta:false db:dbConnection).
        ].
    ].    
!

insertChunk:chunkData key:key db:dbConnection
    [
        dbConnection 
            executeQuery:( 'insert into chunks values (''%1'', ''%2'')'
                            bindWith:key
                            with:(chunkData withCEscapes copyReplaceString:'''' withString:'''''')).
    ] on:SqliteError do:[
        "/ already there?
        |rslt|

        rslt := dbConnection executeQuery:( 'select 1 from chunks where id = ''%1''' bindWith:key).
        rslt next isNil ifTrue:[
            "/ not there - error
            self error:'cannot insert chunk int db'
        ].
        "/ ok - already there.
    ].
!

keyForChunk:aString
    "chunks are keyed by their sha1 hash value.
     This has the advantage, that:
        - the key alone shows if anything has changed,
        - no new record is required if a chunk uis unchanged,
        - going back to an old version automatically reuses/refers to the old chunk,
        - two independently changed methods will generate the same key"

    ^ (SHA1Stream hashValueOf:aString) hexPrintString
!

manifestOfStoredClassDefinitionOf:aClass db:dbConnection
    "save a class definition; 
     return a manifest line"

    |dfn id|

    dfn := aClass theNonMetaclass definition.
    id := self keyForChunk:dfn.

    self insertChunk:dfn key:id db:dbConnection.
    ^ 'definition: ' , id.
!

manifestOfStoredMethod:aMethod selector:aSymbol meta:isMeta db:dbConnection
    "save a method; 
     return a manifest line"

    |src id|

    src := aMethod source.
    id := self keyForChunk:src.
    self insertChunk:src key:id db:dbConnection.
    ^ (isMeta ifTrue:'class method: ' ifFalse:'method: ') 
        , aSymbol , ' ' 
        , id.
!

savePreferencesOn:aStream
    aStream nextPutLine:'DataBaseSourceCodeManager notNil ifTrue:['.
    self repositoryInfoPerModule notEmptyOrNil ifTrue:[
        aStream nextPutLine:'    DataBaseSourceCodeManager repositoryInfoPerModule:' , self repositoryInfoPerModule storeString , '.'.
    ].
    (Smalltalk at:#SourceCodeManager) == self ifTrue:[
        aStream nextPutLine:'    Smalltalk at:#SourceCodeManager put:DataBaseSourceCodeManager.'.
    ].
    aStream nextPutLine:'    DataBaseSourceCodeManager repositoryName:' , self repositoryName storeString , '.'.
    aStream nextPutLine:'].'.

    "Created: / 09-11-2006 / 15:09:25 / cg"
    "Modified: / 22-12-2011 / 00:48:25 / cg"
    "Modified: / 01-01-2012 / 17:02:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!DataBaseSourceCodeManager class methodsFor:'queries'!

defaultRepositoryName
    "/ '<db-type>:[<user>[.<password>]@][<host>]<db-name>[:<table-name>]'

    ^ 'sqlite:repository.db'

    "Created: / 22-12-2011 / 00:19:43 / cg"
!

enabled
    ^ true "/ false.

    "Created: / 21-12-2011 / 17:53:34 / cg"
!

getDBNameForModule:anString
    "for now, one repository for all modules"

    ^ self repositoryName.
!

initialRevisionString
    ^ '0'
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
    "Modified (format): / 22-12-2011 / 00:05:39 / cg"
!

managerTypeName
    ^ 'DBRepository'

    "Created: / 16-08-2006 / 11:05:56 / cg"
!

nameOfVersionMethodForExtensions
    ^ #'extensionsVersion_DB'

    "Modified: / 22-12-2011 / 00:06:15 / cg"
!

nameOfVersionMethodInClasses
    ^ #'version_DB'

    "Modified: / 22-12-2011 / 00:06:21 / cg"
!

repositoryNameForPackage:packageId 
    "superclass AbstractSourceCodeManager class says that I am responsible to implement this method"

    ^ self getDBNameForModule:(packageId upTo:$: )

    "Created: / 21-12-2011 / 23:07:02 / cg"
!

settingsApplicationClass
    "link to my settings application (needed for the settings dialog"

    ^ DataBaseSourceCodeManagementSettingsAppl

    "Created: / 19-04-2011 / 12:43:29 / cg"
    "Modified: / 22-12-2011 / 00:06:53 / cg"
!

versionInfoClass

    ^DBVersionInfo
! !

!DataBaseSourceCodeManager class methodsFor:'source code administration'!

basicCheckinClass:aClass fileName:classFileName directory:packageDir module:moduleDir logMessage:logMessage force:force
    "low level checkin of a class into the source repository. 
     Does not deal with any version method updates.
     Return true if ok, false if not."

    |dbConnection author state|

    aClass isPrivate ifTrue:[
        self reportError:'refuse to check in private classes.'.
        ^ false.
    ].

    dbConnection := self dbHandleForModule:moduleDir.
    [
        |collectedVersionSpec hashKey basicRevisionString revisionString 
         oldRevision newRevision oldInfo symbolicVersion|

        collectedVersionSpec := self checkInClassAndCollectManifestOf:aClass db:dbConnection.
        hashKey := self keyForChunk:collectedVersionSpec.

        self insertChunk:collectedVersionSpec key:hashKey db:dbConnection.

        oldRevision := aClass revisionOfManager:self.
        newRevision := hashKey.
        oldRevision ~= newRevision ifTrue:[
            oldInfo := aClass revisionInfoOfManager:self.
            oldInfo isNil ifTrue:[
                symbolicVersion := '1.0'
            ] ifFalse:[
                symbolicVersion := oldInfo symbolicVersionName ? '1.0'
            ].

            basicRevisionString := (self revisionStringFor:aClass inModule:moduleDir directory:packageDir container:classFileName revision:hashKey).
            revisionString := basicRevisionString,', SymbolicVersion: ',symbolicVersion.
            self updateVersionMethodOf:aClass for:revisionString.

            author := OperatingSystem getFullUserName.
            author isEmptyOrNil ifTrue:[ author := OperatingSystem getLoginName ].
            author isEmptyOrNil ifTrue:[ author := 'unknown' ].
            state := ''.

            [
                "/ (versionId primary key, name, packageId, author, timestamp)
                dbConnection 
                    executeQuery:(
                        'insert into versions (key, name, packageId, author, timestamp) values (''%1'', ''%2'', ''%3'', ''%4'', ''%5'', ''%6'')'
                            bindWith:newRevision
                            with:(symbolicVersion withCEscapes copyReplaceString:'''' withString:'''''')
                            with:(aClass package withCEscapes copyReplaceString:'''' withString:'''''')
                            with:(author withCEscapes copyReplaceString:'''' withString:'''''')
                            with:(UtcTimestamp now printStringIso8601)
                            with:state).
            ] on:SqliteError do:[
                "/ already there?
                |rslt|

                rslt := dbConnection executeQuery:( 'select * from versions where key = ''%1''' bindWith:newRevision).
                rslt next isNil ifTrue:[
                    "/ not there - error
                    self error:'cannot insert chunk int db'
                ].
                "/ already there.
                Dialog information:'An identical version was already present in the repository.'.
            ].
        ].
    ] ensure:[
        dbConnection close
    ].

    ^ true.

    "
     SourceCodeManager checkinClass:Array
    "
!

checkForExistingContainer:fileName inModule:moduleName directory:dirName
    ^ self checkForExistingModule:moduleName directory:dirName

    "Created: / 21-12-2011 / 17:56:23 / cg"
!

checkForExistingModule:moduleDir
    "check for a package directory to be present"

    ^ true.
"/
"/    dir := self moduleDirectoryFor:moduleDir.
"/    ^ dir exists

    "Created: / 21-12-2011 / 18:37:28 / cg"
!

checkForExistingModule:moduleDir directory:packageDir
    "check for a package directory to be present; return true, if it does"

    |handle packagePresent packageName|

    handle := self dbHandleForModule:moduleDir.
    packageName := moduleDir,':',packageDir.

    packagePresent := false.
    handle
        withResultForQuery: ('select 1 from packages where name = "%1"' bindWith:packageName) 
        do:[:result |
            packagePresent := result numRows > 0.
        ].

    ^ packagePresent

    "Created: / 21-12-2011 / 18:03:33 / cg"
!

checkinClass:aClass fileName:classFileName directory:packageDir module:moduleDir source:sourceFile logMessage:logMessage force:force
    "Return true if ok, false if not."

    self halt:'should not be called (not need for a classFile)'
!

createModule:moduleDir
    "create a module directory"

    self halt:'unimplemented'.
"/    |dir|
"/
"/    dir := self moduleDirectoryFor:moduleDir.
"/    dir recursiveMakeDirectory.
"/    ^ dir exists.

    "Created: / 21-12-2011 / 18:38:22 / cg"
!

createModule:moduleDir directory:packageDir
    "create a package directory"

    |handle id name|

    id := UUID new.
    name := (moduleDir,':',packageDir).

    handle := self dbHandleForModule:moduleDir.
    handle
        withResultForQuery: ('insert into packages values (''%1'', ''%2'')' bindWith:id with:name) 
        do:[:result |
        ].

    self halt:'unimplemented'.
"/    |dir|
"/
"/    dir := self packageDirectoryForModule:moduleDir package:packageDir.
"/    dir recursiveMakeDirectory.
"/    ^ dir exists.

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

revisionInfoFromString:aString  
    "{ Pragma: +optSpace }"

    "return a VersionInfo object filled with revision info.
     This extracts the relevant info from aString."

    |info versionName stringWithoutDelimiters|

    stringWithoutDelimiters := aString.
    (aString startsWith:'$') ifTrue:[
        stringWithoutDelimiters := aString copyButFirst:1.
        (aString endsWith:'$') ifTrue:[
            stringWithoutDelimiters := aString copyButLast:1.
        ].
    ].

    info := self revisionInfoFromStandardVersionString:aString.

    versionName := self extractKeyValueFor:'SymbolicVersion' fromRevisionString:aString.
    info symbolicVersionName:versionName.
    ^ info

    "
     self revisionInfoFromString:'Path: stx/libbasic/Array.st, Version: 123, User: cg, Time: 2011-12-21T21:03:08.826 SymbolicVersion: foo' 
    "
!

revisionLogOf:clsOrNil 
    fromRevision:rev1OrNil toRevision:rev2OrNil numberOfRevisions:limitOrNil 
    fileName:classFileName directory:packageDir module:moduleDir 

    self halt:'unimplemented'.
    ^ nil
"/    |info log targetDir count newestRevision|
"/
"/    targetDir := self packageDirectoryForModule:moduleDir package:packageDir.
"/    targetDir exists ifFalse:[^ nil ].
"/
"/    info := IdentityDictionary new.
"/    log := OrderedCollection new.
"/    count := 0.
"/
"/    (targetDir filesMatching:(classFileName,'_*')) do:[:eachVersionFile |
"/        |versionString cs versionChange info|
"/
"/        versionString := eachVersionFile copyFrom:(classFileName size + 2).
"/        count := count + 1.
"/        (newestRevision isNil 
"/        or:[ self isRevision:versionString after:newestRevision ]) ifTrue:[
"/            newestRevision := versionString
"/        ].
"/
"/        (rev1OrNil isNil 
"/            or:[ rev1OrNil = 0
"/            or:[ versionString = rev1OrNil
"/            or:[ self isRevision:versionString after:rev1OrNil ]]])
"/        ifTrue:[
"/            (rev2OrNil isNil 
"/                or:[ rev2OrNil = 0
"/                or:[ versionString = rev2OrNil
"/                or:[ self isRevision:rev2OrNil after:versionString ]]])
"/            ifTrue:[
"/                (limitOrNil isNil
"/                or:[ log size < limitOrNil ])
"/                ifTrue:[
"/                    cs := ChangeSet fromFile:(targetDir construct:eachVersionFile).
"/                    versionChange := cs detect:[:chg | chg isMethodChange
"/                                                       and:[chg selector = self nameOfVersionMethodInClasses]]
"/                                        ifNone:nil.
"/                    versionChange notNil ifTrue:[
"/                        info := self revisionInfoFromString:versionChange source.
"/                    ] ifFalse:[
"/                        info := VersionInfo new.
"/                    ].
"/
"/                    info revision:versionString.
"/                    log add:info.
"/                ]
"/            ].
"/        ].
"/    ].
"/    log sort:[:a :b | self isRevision:b revision after:a revision].
"/
"/    info at:#revisions put:log.
"/    info at:#numberOfRevisions put:count.
"/    info at:#newestRevision put:newestRevision.
"/
"/    ^ info
"/
"/

    "Created: / 21-12-2011 / 20:39:31 / cg"
!

streamForClass:aClass fileName:classFileName revision:revision directory:packageDir module:moduleDir cache:doCache
    self halt:'unimplemented'.
"/    |targetDir oldFile|
"/
"/    targetDir := self packageDirectoryForModule:moduleDir package:packageDir.
"/    oldFile := (targetDir construct:classFileName,'_',revision).
"/    ^ oldFile readStream

    "Created: / 21-12-2011 / 20:49:01 / cg"
!

updateVersionMethodOf:aClass for:newRevisionString
    "{ Pragma: +optSpace }"

    "helper for the checkin procedure.
     Update my #version_XXX method, to now return newRevisionString."

    self updateVersionMethod:(self nameOfVersionMethodInClasses) of:aClass for:newRevisionString.
! !

!DataBaseSourceCodeManager::DBVersionInfo class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2014 by eXept Software AG
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
    In ancient times, Class used to return a Dictionary when asked for versionInfo.
    This has been replaced by instances of VersionInfo and subclasses.

    DBVersionInfo adds some DataBaseManager specific data.

    [author:]
        cg 
"
! !

!DataBaseSourceCodeManager::DBVersionInfo methodsFor:'accessing'!

symbolicVersionName
    "return an additional symbolic version name, which is used for human readers (and not unique)"

    ^ symbolicVersionName ? revision
!

symbolicVersionName:aString
    symbolicVersionName := aString.
! !

!DataBaseSourceCodeManager class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

