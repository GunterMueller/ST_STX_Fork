"{ Package: 'stx:goodies/monticello' }"

AbstractSourceCodeManager subclass:#MCSourceCodeManager
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-St/X support'
!


!MCSourceCodeManager class methodsFor:'accessing'!

repositoryNameForPackage:packageId 
    "superclass AbstractSourceCodeManager class says that I am responsible to implement this method"
    
    ^ self shouldImplement
! !

!MCSourceCodeManager class methodsFor:'basic access'!

checkinClass:aClass fileName:classFileName directory:packageDir module:moduleDir source:sourceFile logMessage:logMessage force:force
    "checkin of a class into the source repository.
     Return true if ok, false if not."

    ^ self shouldImplement
!

checkinPackage:packageId
    | mcPackage workingCopy |

    mcPackage := MCPackage named: packageId.
    workingCopy := mcPackage workingCopy.
    MCCommitDialog new
        workingCopy: workingCopy;
        open

    "Created: / 14-09-2010 / 22:54:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 01-12-2011 / 21:47:18 / cg"
    "Created: / 02-12-2011 / 14:42:51 / cg"
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

!MCSourceCodeManager class methodsFor:'basic administration'!

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
    "actually do return a revisionLog. The main worker method.
     This must be implemented by a concrete source-code manager"

    ^ self shouldImplement
! !

!MCSourceCodeManager class methodsFor:'misc'!

forgetDisabledModules

    "Nothing to do"

    "Created: / 10-06-2011 / 14:11:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

revisionStringForVersion:anMCVersion
    |info|

    info := anMCVersion info.

    ^ '%1 %2 %3 %4'
        bindWith:info name
        with:info id       
        with:info timeStamp printStringIso8601Format
        with:info author

    "Created: / 02-12-2011 / 14:25:05 / cg"
!

savePreferencesOn:aFileStream

    "Nothing to do now..."

    "Created: / 10-06-2011 / 14:16:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MCSourceCodeManager class methodsFor:'queries'!

isResponsibleForPackage:aStringOrSymbol
    "Answering true does not imply that receiver is configured default
     manager for that package, it only means that it has a repository
     configured for given package."

    "The real check is too slow. Cache needed here"
    ^ true.

    "Modified (format): / 01-12-2011 / 20:57:20 / cg"
!

managerTypeName

    ^'Monticello 1.x'
    "/ ^'Monticello'

    "Created: / 26-10-2010 / 21:52:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-12-2011 / 11:33:14 / cg"
!

managerTypeNameShort
    "Answers short version manager name suitable for UI,
     i,e., CVS, SVN, P4. Used in cases where sorter strings
     are preferred. Defaults to #managerTypeName"

    ^ 'MC'

    "Created: / 03-10-2011 / 13:28:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-12-2011 / 10:15:18 / cg"
!

nameOfVersionMethodForExtensions
    ^ #'extensionsVersion_MC'

    "Modified: / 02-12-2011 / 14:01:40 / cg"
!

nameOfVersionMethodInClasses
    ^ #'version_MC'

    "Modified: / 02-12-2011 / 14:01:49 / cg"
!

settingsApplicationClass
    "link to my settings application (needed for the settings dialog"

    ^ MCSettingsApp

    "Modified: / 20-07-2011 / 16:52:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MCSourceCodeManager class methodsFor:'source code administration'!

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

    ^ MCStxVersionInfo fromMCVersionString:aString

    "Modified: / 04-12-2011 / 10:05:06 / cg"
! !

!MCSourceCodeManager class methodsFor:'subclass responsibility'!

reportHistoryLogSince:timeGoal filterSTSources:filter filterUser:userFilter filterRepository:repositoryFilter filterModules:moduleFilter inTo:aBlock
    "superclass AbstractSourceCodeManager class says that I am responsible to implement this method"

    ^ self shouldImplement
! !

!MCSourceCodeManager class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCSourceCodeManager.st,v 1.7 2012-09-11 21:28:57 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCSourceCodeManager.st,v 1.7 2012-09-11 21:28:57 cg Exp $'
!

version_SVN
    ^ '§Id: MCSourceCodeManager.st 31 2011-07-20 15:52:38Z vranyj1 §'
! !
