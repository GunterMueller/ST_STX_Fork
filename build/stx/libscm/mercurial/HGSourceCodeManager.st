"
stx:libscm - a new source code management library for Smalltalk/X
Copyright (C) 2012-2015 Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License. 

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
"{ Package: 'stx:libscm/mercurial' }"

"{ NameSpace: Smalltalk }"

SCMAbstractSourceCodeManager subclass:#HGSourceCodeManager
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Mercurial-StX'
!

!HGSourceCodeManager class methodsFor:'documentation'!

copyright
"
stx:libscm - a new source code management library for Smalltalk/X
Copyright (C) 2012-2015 Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License. 

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
! !

!HGSourceCodeManager class methodsFor:'initialization'!

validateWorkingCopy: path
    "Return true, if given path is a valid working 
     copy of this manager; false otherwise."

    ^(HGRepository discover: path) notNil

    "Created: / 02-10-2015 / 10:02:39 / jv"
! !

!HGSourceCodeManager class methodsFor:'accessing'!

repositoryNameForPackage:packageId
    "Return the repository ULR for the given package. 
     Used for testing/debugging source code management configuration"

    ^ HGRepository discoverPackage: packageId

    "Modified: / 04-07-2013 / 02:16:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

utilities

    ^HGSourceCodeManagerUtilities forManager: self.

    "Created: / 24-03-2014 / 12:48:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGSourceCodeManager class methodsFor:'accessing-classes'!

commitDialogClass
    "Answer a dialog class to be used for commits"

    ^HGCommitDialog

    "Created: / 13-11-2012 / 23:59:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

packageRegistryClass
    "Answer the package manager class used to get
     package models"
    
    ^ HGPackageWorkingCopyRegistry

    "Created: / 13-11-2012 / 23:59:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-03-2014 / 21:50:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGSourceCodeManager class methodsFor:'accessing-tools'!

workingCopyBrowserClass
    "Returns a file browser (kind of FileBrowser) suitable for browsing
     working copies. Allows for special browsers with SCM-specific features"

    ^ FileBrowser default.

    "Created: / 14-12-2012 / 15:00:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-04-2013 / 11:26:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGSourceCodeManager class methodsFor:'basic access'!

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

streamForClass:aClass fileName:classFileName revision:revOrString directory:packageDir module:moduleDir cache:doCache
    "extract a classes source code and return an open readStream on it.
     A revision of nil selects the current (in image) revision.
     The classes source code is extracted using the revision and the sourceCodeInfo,
     which itself is extracted from the classes packageString."

    | pkg repo root file rev |

    pkg := HGPackageWorkingCopy named: (moduleDir , ':' , packageDir).  
    pkg isNil ifTrue:[ ^ nil ].
    repo := pkg repository.

    "revOrString can be a symbolic revision #newest..."
    revOrString == #newest ifTrue:[
        | heads |

        heads := repo workingCopy branch heads.
        heads size == 1 ifTrue:[
            rev := heads anElement asHGChangesetId.
        ] ifFalse:[
            rev := heads 
                inject: rev 
                into:[:newest :cs | 
                    cs timestamp > newest timestamp ifTrue:[cs] ifFalse:[newest]].
        ].
    ] ifFalse:[
        rev := revOrString asHGChangesetId.
    ].
    root := (repo @ rev) / pkg repositoryRoot.
    file := root children at: classFileName ifAbsent:[ ^ nil ].

    doCache ifTrue:[
        ^SourceCodeCache default
            streamForClass:aClass 
            fileName:classFileName 
            revision:rev printStringWithoutNumber 
            repository: 'hg' "TODO: Use repository ID here" 
            module:moduleDir 
            directory:packageDir 
            ifAbsent: [:destination|
                ActivityNotification notify: ('Checking out ', classFileName , '@' , rev printStringWithoutNumber  , '...').
                [
                    file copyTo: destination.    
                    destination exists ifTrue:[
                        destination readStream
                    ] ifFalse:[
                        nil
                    ]
                ] on: HGError do:[
                    nil                    
                ]
            ]            
    ] ifFalse:[
        ^file readStream.
    ]

    "Modified: / 05-03-2014 / 21:45:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

streamForExtensionFile:fileName package:pkgId directory:packageDir module:moduleDir cache:doCache
    | defClass pkg repo root file rev|

    defClass := ProjectDefinition definitionClassForPackage:pkgId.
    rev := defClass hgLogicalRevision.
    pkg := HGPackageWorkingCopy named: (moduleDir , ':' , packageDir).  
    pkg isNil ifTrue:[ ^ nil ].
    repo := pkg repository.
    root := (repo @ rev) / pkg repositoryRoot.
    file := root children at: fileName ifAbsent:[ ^ nil ].

    doCache ifTrue:[
        ^SourceCodeCache default
            streamForClass:nil 
            fileName:fileName 
            revision:rev printStringWithoutNumber 
            repository: 'hg' "TODO: Use repository ID here" 
            module:moduleDir 
            directory:packageDir 
            ifAbsent: [:destination|
                ActivityNotification notify: ('Checking out ', fileName , '@' , rev printStringWithoutNumber  , '...').
                [
                    file copyTo: destination.    
                    destination exists ifTrue:[
                        destination readStream
                    ] ifFalse:[
                        nil
                    ]
                ] on: HGError do:[
                    nil                    
                ]
            ]            
    ] ifFalse:[
        ^file readStream.
    ]

    "Created: / 27-03-2013 / 11:49:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-03-2014 / 21:45:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGSourceCodeManager class methodsFor:'basic administration'!

checkForExistingContainer:fileName inModule:moduleName directory:dirName
    "check for a container to be present"

    ^ self shouldImplement
!

checkForExistingModule:moduleName
    "check for a module directory to be present"

    ^ self shouldImplement
!

checkForExistingModule:moduleDir directory:packageDir
    "check for a package directory to be present"

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

revisionLogOf:clsOrNil fromRevision:rev1OrNil toRevision:rev2OrNil numberOfRevisions:limitOrNil fileName:classFileName directory:packageDir module:moduleDir
    "Actually do return a revisionLog. The main worker method. This must be implemented by a 
     concrete source-code manager. The interface of this method is just crazy!!

     If numRevisionsOrNil is notNil, it limits the number of revision records returned -
     only numRevions of the newest revision infos will be collected.

     The returned information is a structure (IdentityDictionary)
     filled with:
            #container          -> the RCS/CVS container file name 
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

    | pkg repo path wcentry info newest oldest startRev stopRev limit log revs startRevIndex stopRevIndex revIndex |

    info := IdentityDictionary new.
    pkg := HGPackageWorkingCopy named: (moduleDir , ':' , packageDir).
    repo := pkg repository.
    path := pkg repositoryRoot.
    wcentry := repo workingCopy / path / classFileName.
    wcentry exists ifFalse:[
        self breakPoint: #jv info: 'Ooops, could not found given file in working copy. Changeset scanning not yet implemented. You may proceed wot'.
        ^ nil
    ].
    revs := (rev1OrNil == 0 and:[rev2OrNil == 0]) 
        ifTrue:[((wcentry changeset / path / classFileName) newer: true) collect:[:f|f changeset]]
        ifFalse:[wcentry revisions collect:[:f|f changeset]].
    revs isEmpty ifTrue:[revs add: wcentry changeset].
    newest := revs first.
    oldest := revs last.

    info at:#container          put: classFileName.         "/ -> the revision string
    info at:#cvsRoot            put: repo pathName.         "/ -> the CVS root (repository)
    info at:#filename           put: classFileName.         "/ -> the actual source file name
    info at:#newestRevision     put: newest id printString. "/-> the revisionString of the newest revision
    info at:#numberOfRevisions  put: newest id revno.

    (rev1OrNil == 0 and:[rev2OrNil == 0]) ifTrue:[
        limit := 1.
        startRev := newest.
        stopRev := newest. 
    ] ifFalse:[
        limit := limitOrNil ? (revs size) .
        startRev := rev1OrNil isNil ifTrue:[newest] ifFalse:[repo @ rev1OrNil].
        stopRev  := rev2OrNil isNil ifTrue:[oldest] ifFalse:[repo @ rev2OrNil].
    ].
    log := OrderedCollection new.

    startRevIndex := revs indexOf: startRev.
    stopRevIndex := revs indexOf: stopRev.
    limit := limit min: (stopRevIndex - startRevIndex + 1).

    revIndex := startRevIndex.
    limit timesRepeat:[
        | entry rev |
        rev := revs at: revIndex.
        entry :=  IdentityDictionary new.
        entry at:#revision              put: rev id printString."/ -> the revision string
        entry at:#author                put: rev author."/ -> who checked that revision into the repository
        entry at:#date                  put: rev timestamp printString."/ -> when was it checked in
        entry at:#state                 put: 'Exp'. "/ -> the RCS state   
        entry at:#numberOfChangedLines  put: 'N/A'. "/ -> the number of changed line w.r.t the previous
        entry at:#logMessage            put: rev message."/ -> the checkIn log message.
        log add: entry.

        revIndex := revIndex + 1.
    ].
    info at: #revisions put: log.

    ^info

    "Modified: / 24-04-2016 / 13:19:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGSourceCodeManager class methodsFor:'queries'!

isContainerBased
    "true, if the SCM uses some kind of source container (,v files).
     False, if it is like a database or filesystem."

    ^ false

    "Created: / 17-10-2013 / 00:54:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isResponsibleForPackage:aStringOrSymbol
    "Returns true if the manager can handle source code for given package.
     
     Answering true does not imply that receiver is configured default
     manager for that package, it only means that it has a repository
     configured for given package."

    "No configuration yet, so let's scan the working copy"

    ^(HGRepository discoverPackage: aStringOrSymbol) notNil

    "Modified: / 04-07-2013 / 02:15:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

managerTypeName
    "superclass AbstractSourceCodeManager class says that I am responsible to implement this method"

    ^ 'Mercurial+'

    "Modified: / 13-11-2012 / 22:40:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

managerTypeNameShort
    ^ 'HG'

    "Created: / 06-10-2012 / 17:10:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-11-2012 / 22:40:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

nameOfVersionMethodForExtensions
    "that is the old name; now, we use extensionsVersion_<SCM>"

    ^ #'extensionsVersion_HG'

    "Modified (comment): / 29-09-2011 / 13:27:04 / cg"
    "Modified: / 13-11-2012 / 22:40:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

nameOfVersionMethodInClasses
    "that is the old name; now, we use version_<SCM>"

    ^ #'version_HG'

    "Modified (comment): / 29-09-2011 / 13:27:09 / cg"
    "Modified: / 13-11-2012 / 22:40:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

performsCompilabilityChecks
    ^true

    "Created: / 01-12-2012 / 01:01:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

settingsApplicationClass
    "link to my settings application (needed for the settings dialog"

    ^ HGSourceCodeManagementSettingsAppl

    "Modified: / 13-11-2012 / 22:40:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

versionMethodTemplateForJavaScriptFor:aSelector
    "do not make the thing below a single string - otherwise
     it would get expanded by the sourcecodemanager, which we do not want here"

    ^
"'function ',"aSelector,'() {

    return "$Changeset: <not expanded>"$;
}'

    "Created: / 07-10-2012 / 00:23:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 30-11-2012 / 21:32:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

versionMethodTemplateForRubyFor:aSelector
    "do not make the thing below a single string - otherwise
     it would get expanded by the sourcecodemanager, which we do not want here"

    ^
'def self.',aSelector,'()

    return "$Changeset: <not expanded>$"
end'

    "Created: / 07-10-2012 / 00:22:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 30-11-2012 / 21:32:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

versionMethodTemplateForSmalltalkFor:aSelector
    "do not make the thing below a single string - otherwise
     it would get expanded by the sourcecodemanager, which we do not want here"

    ^
aSelector,'

    ^ ''$Changeset: <not expanded> $''
'

    "Created: / 07-10-2012 / 00:21:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 30-11-2012 / 21:32:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGSourceCodeManager class methodsFor:'source code administration'!

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

removeContainer:container inModule:module directory:directory
    "remove a container"

    ^ self shouldImplement
!

revisionInfoFromString:aString
    | revInfo |

    revInfo := HGRevisionInfo fromString: aString.
    revInfo isNotExpanded ifTrue:[ 
        "/ Sigh, this method is called from ProjectDefinition>>extensionsRevisionInfoForManager:
        "/ however here we don't know for what package it's called (no class nor package info
        "/ provided. Hence the thisContext sender receiver hack.

        | senderReceiver |
        (senderReceiver := thisContext sender receiver) isProjectDefinition ifTrue:[ 
            revInfo := HGRevisionInfo new.
            revInfo changesetId: senderReceiver hgLogicalRevision.
            ^ revInfo.
        ].
        "/ Another hack to make module list app working, sigh...
        (senderReceiver isKindOf: Tools::ObjectModuleInformation) ifTrue:[ 
            | arg1 |

            arg1 := thisContext sender argAt:1.
            (arg1 endsWith: '_extensions') ifTrue:[ 
                | prjdef |

                prjdef := ProjectDefinition definitionClassForPackage: (arg1 copyTo: arg1 size - 11).
                prjdef notNil ifTrue:[ 
                    revInfo := HGRevisionInfo new.
                    revInfo changesetId: prjdef hgLogicalRevision.
                    ^ revInfo. 
                ]
            ].
        ].
    ].
    ^ revInfo

    "Modified: / 02-11-2015 / 16:29:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

revisionInfoFromString: vsnString inClass: class
    | revInfo def clsBinRev |

    "NOTE: class argument may be nil if called for extensions, sigh"

    "Hack for Smalltalk/X 6.2.2: as 6.2.2 stc has no support for Mercurial, 
     the binary revision is always 'file:class.st'. In that case, do not use
     the binary revision at all"
    class notNil ifTrue:[
        clsBinRev := class binaryRevisionString.
        (clsBinRev notNil and:[clsBinRev startsWith:'file:']) ifTrue:[
            clsBinRev := nil.
        ].
    ].

    revInfo := self revisionInfoFromString: vsnString.

    revInfo isNotExpanded ifTrue:[ 
        | pkg |

        "When called for extensions, class may be nil. But in this case we don't know
         the extension's package, so we have to guess it.
         What a stupid, CVS-centric interface. Playing with strings is simply too bad."

        revInfo := HGRevisionInfo new.
        revInfo changesetId: HGChangesetId null.
        class notNil ifTrue:[
            pkg := class package.
        ] ifFalse:[
            "Add more cases here..."
            (thisContext sender selector == #loadExtensionsForPackage:language:) ifTrue:[
                pkg := thisContext sender argAt: 1.
            ]
        ].

        pkg notNil ifTrue:[    
            | rev |
            def := ProjectDefinition definitionClassForPackage: pkg.
            [ def isNil ] whileTrue:[
                pkg := pkg asPackageId parentPackage.
                pkg isNil ifTrue:[ 
                    ^ nil.
                ].
                pkg := pkg asString.
                (self isResponsibleForPackage: pkg) ifFalse:[ 
                    ^ nil
                ].
                def := ProjectDefinition definitionClassForPackage: pkg.      
            ].
            rev := def hgLogicalRevision.
            rev notNil ifTrue:[ 
                revInfo changesetId: rev.
            ].
        ].
    ].

    class notNil ifTrue:[
        revInfo className: class name.
    ]. 
    ^revInfo

    "Created: / 30-11-2012 / 21:48:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 23-05-2014 / 12:28:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

withSourceRewriteHandlerDo:aBlock
    "HG does not expand keywords, no need to rewrite"
    ^aBlock value

    "Created: / 14-02-2013 / 15:17:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGSourceCodeManager class methodsFor:'subclass responsibility'!

reportHistoryLogSince:timeGoal filterSTSources:filter filterUser:userFilter filterRepository:repositoryFilter filterModules:moduleFilter inTo:aBlock
    "superclass AbstractSourceCodeManager class says that I am responsible to implement this method"

    ^ self shouldImplement
! !

!HGSourceCodeManager class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Path: stx/libscm/mercurial/HGSourceCodeManager.st, Version: 1.0, User: cg, Time: 2015-09-03T11:48:48.345+02$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id$'
! !

