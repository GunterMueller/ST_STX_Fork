"
 Copyright (c) 2007-2010 Jan Vrany
 Copyright (c) 2009-2010 eXept Software AG
 Copyright (c) 2016 Jan Vrany

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the 'Software'), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
"
"{ Package: 'stx:libsvn' }"

"{ NameSpace: Smalltalk }"

AbstractSourceCodeManager subclass:#SVNSourceCodeManager
	instanceVariableNames:''
	classVariableNames:'LoadInProgressQuery'
	poolDictionaries:''
	category:'System-SourceCodeManagement'
!

VersionInfo subclass:#SVNVersionInfo
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:SVNSourceCodeManager
!

SourceCodeManagerUtilities subclass:#Utilities
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:SVNSourceCodeManager
!

!SVNSourceCodeManager class methodsFor:'documentation'!

copyright
"
 Copyright (c) 2007-2010 Jan Vrany
 Copyright (c) 2009-2010 eXept Software AG
 Copyright (c) 2016 Jan Vrany

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the 'Software'), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.

"
!

documentation
"
    For now, this is a dummy SourceCodeManager.
    It is only provided to deliver the correct versionMethodNameTemplates
    and versionMethod names.

    Might get more in the future.
"
! !

!SVNSourceCodeManager class methodsFor:'Signal constants'!

loadInProgressQuery

    LoadInProgressQuery ifNil:
        [LoadInProgressQuery := QuerySignal new].
    ^LoadInProgressQuery
! !

!SVNSourceCodeManager class methodsFor:'accessing'!

repositoryNameForPackage:packageId 
    "superclass AbstractSourceCodeManager class says that I am responsible to implement this method"
    
    |repo|

    repo := SVN::RepositoryManager current repositoryForPackage:packageId.
    repo isNil ifTrue:[
        ^ 'N/A'
    ] ifFalse:[
        ^ repo url asString
    ]

    "Modified: / 10-10-2011 / 19:49:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

shownInBrowserMenus
    "can be redefined in subclasses which can be suppressed in the browser's menus"

    ^ UserPreferences current svnEnabled

    "Created: / 08-01-2012 / 19:56:22 / cg"
    "Created: / 19-01-2012 / 13:11:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

shownInBrowserMenus:aBoolean
    "can be redefined in subclasses which can be suppressed in the browser's menus"

    ^ UserPreferences current svnEnabled: aBoolean

    "Created: / 19-01-2012 / 13:11:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

utilities

    ^Utilities forManager: self.

    "Created: / 11-10-2011 / 11:24:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SVNSourceCodeManager class methodsFor:'basic access'!

checkin:filename text:contents directory:directory module:module logMessage: message force: force
    | branch wc |

    branch := self branchForModule: module directory: directory.
    wc := branch repository workingCopy.
    wc ensureIsValid.
    (wc path / filename) writingFileDo:[:s|s nextPutAll: contents].
    wc commit: message files: { filename }

    "Created: / 27-11-2011 / 22:51:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-03-2012 / 17:16:12 / jv"
!

checkinClass:aClass fileName:classFileName directory:packageDir module:moduleDir source:sourceFile logMessage:logMessage force:force
    "checkin of a class into the source repository.
     Return true if ok, false if not."

    | repo |
    repo := SVN::RepositoryManager repositoryForModule: moduleDir directory: packageDir.
    repo ifNil:[^false].

    self shouldImplement: 'Not yet finished'.

    ^false

    "Modified: / 12-10-2011 / 18:50:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

checkoutModule:aModule directory:aPackage andDo:aBlock
    "check out everything from a package into a temporary directory.
     Then evaluate aBlock, passing the name of that temp-directory.
     Afterwards, the tempDir is removed.
     Return true, if OK, false if any error occurred."

    | pkg tempDir repo workingCopy ok |
    pkg := (PackageId module: aModule directory: aPackage) asSymbol.
    repo := SVN::RepositoryManager repositoryForPackage: pkg.
    repo ifNil:[self error:('No repository for package %1' bindWith: pkg)].
    [ok := false.
    tempDir := Filename newTemporaryDirectory.
    workingCopy := repo workingCopyIn: tempDir.
    workingCopy checkout.
    ok := true.
    aBlock value: tempDir] ensure:
        [[tempDir recursiveRemove]
            on: Error do:
                [:ex|
                OperatingSystem isMSWINDOWSlike 
                    ifTrue:[Delay waitForSeconds: 3.[tempDir recursiveRemove] on: Error do:["nothing"]]
                    ifFalse:[ex pass]]].
    ^ok

    "Modified: / 19-04-2010 / 20:13:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

removeContainer:container inModule:module directory:directory

    | repo wc |
    repo := self repositoryForModule: module directory: directory.
    repo isNil ifTrue:[
        self error:'No SVN repository'.
        ^self
    ].
    wc := repo workingCopy.
    wc delete: container

    "Created: / 23-12-2011 / 18:20:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

streamForClass:aClass fileName:classFileName revision:revisionString directory:packageDir module:moduleDir cache:doCache
    "extract a classes source code and return an open readStream on it.
     A revision of nil selects the current (in image) revision.
     The classes source code is extracted using the revision and the sourceCodeInfo,
     which itself is extracted from the classes packageString."

    | pkg repo rev revInfo |
    pkg := moduleDir , ':' , packageDir.
    repo := SVN::RepositoryManager repositoryForPackage: pkg.
    repo ifNil:[^nil].
    (revisionString notNil and:[revisionString ~~ #newest]) ifTrue:[
        "JV@2012-03-13: HACK, as binaryRevision does not work reliably on 
         CVS HEAD, sigh"
        revisionString ~= '0' ifTrue:[
            rev := SVN::Revision fromString: revisionString.
        ] ifFalse:[
            revInfo := aClass revisionInfoOfManager: self.
            revInfo notNil ifTrue:[
                rev := revInfo revision
            ] ifFalse:[                     
                "Hmmm....what to se here?"
                rev := SVN::Revision head
            ]
        ]
    ] ifFalse:[
        rev := SVN::Revision head.
    ].
    doCache ifTrue:[
        ^SourceCodeCache default
            streamForClass:aClass 
            fileName:classFileName 
            revision:revisionString 
            repository: 'svn' "TODO: Use repository ID here" 
            module:moduleDir 
            directory:packageDir 
            ifAbsent: [:destination|
                ActivityNotification notify: ('Checking out ', classFileName , '@' , rev asString , '...').
                [SVN::ExportCommand new
                    branch: repo branch;
                    path: classFileName;
                    revision: rev;
                    destination: destination pathName;
                    execute.
                    destination exists ifTrue:[
                        destination readStream
                    ] ifFalse:[
                        nil
                    ]
                ] on: SVN::SVNError do:[
                    nil                    
                ]
            ]            
    ] ifFalse:[
        ^[
            (repo cat: classFileName revision: rev) readStream
        ] on: SVN::SVNError do:[
            nil        
        ]
    ]

    "Modified: / 13-03-2012 / 15:33:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-03-2012 / 18:11:10 / Jan Vrany <jan.vrany.fit.cvut.cz>"
! !

!SVNSourceCodeManager class methodsFor:'basic administration'!

checkForExistingContainer:fileName inModule:moduleName directory:dirName
    "check for a container to be present"

    | repo  |
    repo := SVN::RepositoryManager repositoryForModule: moduleName directory: dirName.
    repo isNil ifTrue:[^self].
    ^repo branch exists: fileName.

    "Modified: / 11-10-2011 / 11:15:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

checkForExistingModule:moduleName
    "check for a module directory to be present"

    ^ self shouldImplement
!

checkForExistingModule:moduleDir directory:packageDir
    "check for a package directory to be present"

    | pkg repo |
    pkg := moduleDir , ':' , packageDir.
    repo := SVN::RepositoryManager repositoryForPackage: pkg.
    ^repo exists

    "Modified: / 27-11-2011 / 22:46:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
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

revisionLogOf:clsOrNil fromRevision:rev1OrNil toRevision:rev2OrNil numberOfRevisions:limitOrNil fileName:classFileName directory:packageDir module:moduleDir
    "Actually do return a revisionLog. The main worker method."
    "
    If numRevisionsOrNil is notNil, it limits the number of revision records returned -
     only numRevions of the newest revision infos will be collected.

     The returned information is a structure (IdentityDictionary)
     filled with:
            #container          -> the file name again 
            #cvsRoot            -> the CVS root (repository) 
            #filename           -> the actual source file name
            #newestRevision     -> the revisionString of the newest revision
            #numberOfRevisions  -> N/A
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
              #logMessage            -> the checkIn log message

            revisions are ordered newest first 
            (i.e. the last entry is for the initial revision; the first for the most recent one)
            Attention: if state = 'dead' that revision is no longer valid.
    "

    | repo log rev1 rev2 limit branch info |

    repo := SVN::RepositoryManager repositoryForModule: moduleDir directory: packageDir.
    repo isNil ifTrue:[^nil"No repository..."].

    (rev1OrNil == 0 and:[rev2OrNil == 0]) ifTrue:[
        rev1 := SVN::Revision number:0.
        rev2 := SVN::Revision head.
        limit := 1.
    ] ifFalse:[
       (rev1OrNil == nil and:[rev2OrNil == nil]) ifTrue:[
            rev1 := SVN::Revision number:0.
            rev2 := SVN::Revision head.
            limit := limitOrNil.
        ] ifFalse:[
            rev1 := SVN::Revision number: rev1OrNil ? 0.
            rev2 := rev1OrNil isNil ifTrue:[SVN::Revision head] ifFalse:[SVN::Revision number: rev2OrNil].
            limit := limitOrNil.
            self breakPoint: #jv info: 'Review'.
        ]
    ].
    branch := self branchForModule: moduleDir directory: packageDir.
    branch isNil ifTrue:[
        self breakPoint: #jv.
        self error:('No branch for package %1:%2' bindWith: moduleDir with: packageDir) mayProceed: true.
        ^self
    ].

    log := branch log: classFileName limit: limit revisions: (rev2 to: rev1).
    info := IdentityDictionary new.
    info at:#container          put: classFileName.         "/ -> the revision string
    info at:#cvsRoot            put: branch url asString.   "/ -> the CVS root (repository)
    info at:#filename           put: classFileName.         "/ -> the actual source file name
    info at:#newestRevision     put: log first revision asString. "/-> the revisionString of the newest revision
    info at:#numberOfRevisions  put: log size.              "/-> the number of revisions in the container (nil for all)
    info at:#revisions          
         put: 
        (log collect:[:entry|
            | info |
            info := IdentityDictionary new.
            info at:#revision              put: entry revision asString."/ -> the revision string
            info at:#author                put: entry author."/ -> who checked that revision into the repository
            info at:#date                  put: entry date printString."/ -> when was it checked in
            info at:#state                 put: 'Exp'. "/ -> the RCS state
            info at:#logMessage            put: entry message."/ -> the checkIn log message.
            info
        ]).
    
    ^info
    
    "
        SVNSourceCodeManager revisionLogOf:Array fromRevision:0 toRevision:0.
        SVNSourceCodeManager revisionLogOf:Array fromRevision:'10000' toRevision:'10005'
    "

    "Modified: / 18-11-2011 / 16:11:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SVNSourceCodeManager class methodsFor:'misc'!

savePreferencesOn:aFileStream

    "Nothing to do, since my preferences are stored in 
    UserPreferences dictionary"

    "Created: / 10-06-2011 / 14:15:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SVNSourceCodeManager class methodsFor:'private'!

branchForModule: module directory: directory

    | repo |
    repo := self repositoryForModule: module directory: directory .
    ^repo notNil ifTrue:[
        repo branch
    ] ifFalse:[
        nil
    ]

    "Created: / 15-10-2011 / 16:26:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

branchForPackage: package

    | repo |
    repo := SVN::RepositoryManager repositoryForPackage: package.
    ^repo notNil ifTrue:[
        repo branch
    ] ifFalse:[
        nil
    ]

    "Created: / 15-10-2011 / 23:26:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

pathInRepositoryFrom:containerPath forPackage:packageID
    "Return fake path, since it is required by sooo many methods.
     Whole SCM code is too tightly bound to CVS, sigh"

    ^(packageID copyReplaceAll: $: with:$/) , '/' , containerPath

    "Created: / 13-10-2011 / 11:32:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

repositoryForModule: module directory: directory

    | repo |
    repo := SVN::RepositoryManager repositoryForModule: module directory: directory.
    ^repo

    "Created: / 23-12-2011 / 18:57:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SVNSourceCodeManager class methodsFor:'queries'!

isContainerBased
    "true, if the SCM uses some kind of source container (,v files).
     False, if it is like a database or filesystem."

    ^ false

    "Created: / 17-10-2013 / 00:54:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isExperimental
    ^ false
    "/^ OperatingSystem getLoginName ~= 'cg'.
    "/^ true

    "Modified: / 05-12-2009 / 10:23:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isResponsibleForPackage: packageId

    UserPreferences current svnEnabled ifFalse:[^false].

    ^SVN::RepositoryManager current hasRepositoryForPackage: packageId

    "Created: / 05-12-2009 / 10:36:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-09-2010 / 14:55:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

managerTypeName
    ^ 'SubVersion'

    "Modified: / 07-07-2011 / 23:11:41 / jv"
!

managerTypeNameShort

    "Answers short version manager name suitable for UI,
     i,e., CVS, SVN, P4. Used in cases where sorter strings
     are preferred. Defaults to #managerTypeName"

    ^'SVN'

    "Created: / 03-10-2011 / 13:28:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

nameOfVersionMethodForExtensions
    ^ #'extensionsVersion_SVN'
!

nameOfVersionMethodInClasses
    ^ #'version_SVN'
!

performsCompilabilityChecks
    "Should return true, if the manager itself performs
     compilability checks, false otherwise."

    "lisvn performs check if ProjectChecker is available"
    ^(ConfigurableFeatures includesFeature:#ProjectChecker)

    "
        SVNSourceCodeManager performsCompilabilityChecks
        CVSSourceCodeManager performsCompilabilityChecks
    "

    "Created: / 11-04-2012 / 16:55:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

settingsApplicationClass
    "link to my settings application (needed for the settings dialog"

    ^ SVN::ConfigurationApp

    "Modified: / 07-07-2011 / 23:12:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

versionMethodKeyword

    "Answers the keyword used by the version management system to
     expand a current version in a file (_without_ dollars). For
     CVS it is 'Header', for SVN 'Id', others may use different
     keywords. If nil is returned, then the version management does
     not use any keyword."

    ^'Id'

    "Created: / 27-09-2011 / 16:46:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

versionMethodTemplateForRubyFor:aSelector
    "do not make the thing below a single string - otherwise
     it would get expanded by the sourcecodemanager, which we do not want here"

    "Overriden here to use SubVersions fixed-width keywords"

    ^
'def self.',aSelector,'()
    return "$' , self versionMethodKeyword , '::', (String new: 120) , '$"
end'

    "Created: / 29-03-2012 / 17:50:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

versionMethodTemplateForSmalltalkFor:aSelector
    "do not make the thing below a single string - otherwise
     it would get expanded by the sourcecodemanager, which we do not want here"

    ^
aSelector,'
    ^ ''$', self versionMethodKeyword , '::', (String new: 120) , '$''
'

    "Modified (comment): / 19-08-2011 / 01:19:08 / cg"
    "Created: / 29-03-2012 / 17:51:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SVNSourceCodeManager class methodsFor:'source code access'!

loadPackageWithId: aPackageId fromRepositoryAsAutoloaded: doLoadAsAutoloaded

     "Return true if loaded, false otherwise."

    | retval loadBlock |

    loadBlock := [
        | repo packageDir manager|
        manager := SVN::RepositoryManager current.
        repo := manager repositoryForPackage: aPackageId.
        retval := (repo notNil and:[repo exists]) ifTrue:[
            repo workingCopy checkout: SVN::Revision head full: true.
            packageDir := Smalltalk getPackageDirectoryForPackage:aPackageId.
            "Quick and dirty hack to support old version of Smalltalk/X"
            (Smalltalk respondsTo: #loadPackage:fromDirectory:asAutoloaded:)
                ifTrue:
                    ["New API"
                    Smalltalk
                        loadPackage:aPackageId
                        fromDirectory:packageDir
                        asAutoloaded:doLoadAsAutoloaded]
                ifFalse:
                    ["Old API"                        
                    Smalltalk
                        loadPackageWithId:aPackageId
                        fromDirectory:packageDir
                        asAutoloaded:doLoadAsAutoloaded
            ].            
        ] ifFalse:[false]
    ].

    (SVNSourceCodeManager loadInProgressQuery query == true)
        ifTrue:[loadBlock value]
        ifFalse:[
            SVNSourceCodeManager loadInProgressQuery 
                answer: true 
                do:[
                    SVN::ProgressDialog
                        openOn: loadBlock
                        title: ' Loading...'
                        subtitle: aPackageId asText allItalic
                ]
    ].

    ^ retval

    "Created: / 09-04-2009 / 17:20:01 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 28-06-2016 / 07:53:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SVNSourceCodeManager class methodsFor:'source code administration'!

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

    "return a dictionary filled with revision info.
     This extracts the relevant info from aString."


    ^ SVNVersionInfo fromSVNString:aString


    "
     self revisionInfoFromString:(Array version_SVN)   

     self revisionInfoFromString:(stx_libbasic2 extensionsVersion_CVS)   
    "


    "Modified: / 29-01-1997 / 19:00:35 / cg"
    "Modified: / 03-10-2011 / 13:02:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 29-09-2011 / 21:54:26 / cg"

! !

!SVNSourceCodeManager class methodsFor:'subclass responsibility'!

reportHistoryLogSince:timeGoal filterSTSources:filter filterUser:userFilter filterRepository:repositoryFilter filterModules:moduleFilter inTo:aBlock
    "superclass AbstractSourceCodeManager class says that I am responsible to implement this method"

    ^ self shouldImplement
! !

!SVNSourceCodeManager class methodsFor:'testing'!

isSVN
    ^ true
! !

!SVNSourceCodeManager::SVNVersionInfo class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2011 by eXept Software AG
 Copyright (c) 2016 Jan Vrany
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

    SVNVersionInfo adds some SVN specific data.

    [author:]
        cg (cg@AQUA-DUO)
"
!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

!SVNSourceCodeManager::SVNVersionInfo class methodsFor:'instance creation'!

fromSVNString:aString
    "{ Pragma: +optSpace }"

    "I know how to parse SVN version id strings.
     Return an instance filled with revision info which is
     extracted from aString. This must be in SVN format.
     Return nil for non-SVN strings"

    |words firstWord info s fn revString user |

    s := aString readStream.
    s skipSeparators.
    firstWord := s through:$:.

    info := self new.

    "/
    "/ supported formats:
    "/
    "/ $ Id:       baseFileName rev-int date time user $
    "/
    ((firstWord = '$Id:') 
        or:[ (firstWord = '$ Id:') 
        or:[ (firstWord = '§Id:')
        or:[ (firstWord = '§ Id:')]]]
    ) ifTrue:[
        "/Skip next : it might be SVN's fixed-width keyword"
        s peek == $: ifTrue:[s next].

        words := s upToEnd asCollectionOfWords readStream.
        (words peek = '$') ifTrue:[
            "/ empty fixed-width version method - '$Id$'
            ^nil
        ].
        info fileName:(fn := words next).
        (fn endsWith:',v') ifTrue:[
            "/ not an SVN version
            ^ nil
        ].
        info revision:(revString := words next).
        "/ do not use matchesRegex: here (regex is an optional package)
        (revString conform:[:c | c isDigit]) ifFalse:[
            "/ not an SVN version
            ^ nil
        ].
        info date:(words next).
        info time:(words next).
        user := words next.
        (user includesAny:'$§') ifTrue:[
            info user: (user copyTo: (user indexOfAny:'$§') - 1)
        ] ifFalse:[
            info user: user.
            ( '$§' includes:words next first) ifFalse:[
                "/ not an SVN version
                ^ nil
            ]
        ].
        words atEnd ifFalse:[
            ^ nil
        ].
        ^ info
    ].

    ^ nil

    "
     SVNVersionInfo fromSVNString:('$' , 'Revision: 1.122 $')   
     SVNVersionInfo fromSVNString:(SourceCodeManager version)   
     SVNVersionInfo fromSVNString:(ApplicationDefinition version_SVN)
     SVNVersionInfo fromSVNString:(ApplicationDefinition version_CVS)
     CVSVersionInfo fromRCSString:(ApplicationDefinition version_SVN)   
     CVSVersionInfo fromRCSString:(ApplicationDefinition version_CVS)   
    "

    "Created: / 29-09-2011 / 17:14:56 / cg"
    "Modified: / 31-03-2012 / 01:12:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SVNSourceCodeManager::SVNVersionInfo methodsFor:'accessing'!

keysAndValuesDo:aBlock

    super keysAndValuesDo:aBlock.
    "JV@2011-11-25: Fake repositoryPathName, as other tools
     requires this. Returning nil should be fine, but then,
     SourceCodeManagerUtilities constructs names as they are
     in CVS, sigh"
    aBlock value: #repositoryPathName value: self repositoryPathName

    "Created: / 25-11-2011 / 18:58:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

repositoryPathName

    ^fileName

    "Created: / 25-11-2011 / 18:57:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SVNSourceCodeManager::Utilities methodsFor:'utilities-cvs'!

checkinClass:aClass withInfo:aLogInfoOrNil withCheck:doCheckClass usingManager:aManagerOrNil
    "check a class into the source repository.
     If the argument, aLogInfoOrNil isNil, ask interactively for log-message.
     If doCheckClass is true, the class is checked for send of halts etc."

   ^self checkinClasses:(Array with: aClass) withInfo:aLogInfoOrNil withCheck:doCheckClass usingManager:aManagerOrNil

    "Created: / 25-12-2011 / 23:45:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

checkinClasses:classes withInfo:aLogInfoOrNil withCheck:doCheckClass usingManager:aManagerOrNil

    | classesPerPackage |

    doCheckClass value ifTrue:[
        classes do:[:cls|
            "/ check if the class contains halts, error-sends etc.
            (self checkAndWarnAboutBadMessagesInClass:cls checkAgainHolder:doCheckClass) ifFalse:[
                ^ false
            ].
        ].
    ].

    classesPerPackage := Dictionary new.
    classes do:
        [:class|
        (classesPerPackage at: class theNonMetaclass package ifAbsentPut:[Set new])
            add: class theNonMetaclass].
    classesPerPackage keysAndValuesDo:
        [:package :classes| | repo |
        repo := SVN::RepositoryManager repositoryForPackage:package.
        "/SVN::CommitWizard new
        SVN::CommitDialog2 new
                task: (repo workingCopy commitTask
                        classes: classes;
                        message: aLogInfoOrNil;
                        extensionMethods: #()
                        yourself);
                open].
    ^ true

    "Modified: / 06-05-2011 / 10:32:55 / cg"
    "Created: / 25-12-2011 / 23:46:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

checkinPackage:packageToCheckIn classes:doClasses extensions:doExtensions buildSupport:doBuild askForMethodsInOtherPackages:askForMethodsInOtherPackages

    | repo task |
    repo := SVN::RepositoryManager repositoryForPackage:packageToCheckIn.
    repo isNil ifTrue:[
        Dialog warn: (resources string: 'No repository for package %1' with: packageToCheckIn).
        ^self
    ].
    task := repo workingCopy commitTask.
    task suppressClasses: doClasses not.
    task suppressExtensions: doExtensions not.
    task suppresBuildSupportFiles: doBuild not.

    "/SVN::CommitWizard new
    SVN::CommitDialog2 new
            task: task;
            open

    "Created: / 13-10-2011 / 11:16:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

compareProject:aProject withRepositoryVersionFrom:aDateOrNilForNewest
    |diffSet|

    diffSet := self diffSetOfProject:aProject againstRepositoryVersionFrom:aDateOrNilForNewest.

    (Tools::ChangeSetDiffTool new)
        diffset:diffSet;
        title:('Differences of %1' bindWith:aProject);
        open.

    "Created: / 18-01-2012 / 16:04:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

diffSetOfProject: package againstRepositoryVersionFrom:dateOrNil

    | rev branch |

    rev := dateOrNil isNil ifTrue:[SVN::Revision head] ifFalse:[SVN::Revision date: dateOrNil].
    branch := SVNSourceCodeManager branchForPackage: package.
    branch isNil ifTrue:[^nil].
    ^branch diffSetBetweenImageAndRevision: rev.

    "Created: / 15-10-2011 / 23:26:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

tagClass:aClass as:tag

    Dialog warn: 'Individual class tagging not supported by SubVersion. Tag whole package instead'.

    "Modified: / 12-09-2006 / 13:03:59 / cg"
    "Created: / 15-10-2011 / 22:48:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

tagClasses:classes as:tag

    Dialog warn: 'Individual class tagging not supported by SubVersion. Tag whole package instead'.

    "Modified: / 12-09-2006 / 13:03:59 / cg"
    "Created: / 15-10-2011 / 22:49:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

tagPackage: package as:tag

    Dialog warn: 'Not yet implemented'

    "Created: / 12-09-2006 / 13:04:29 / cg"
    "Created: / 15-10-2011 / 22:49:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SVNSourceCodeManager class methodsFor:'documentation'!

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

