"{ Package: 'stx:goodies/monticello' }"

"{ NameSpace: Smalltalk }"

LibraryDefinition subclass:#stx_goodies_monticello
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!

!stx_goodies_monticello class methodsFor:'documentation'!

documentation
"
    Package documentation:

    This library provides support classes to read and write monticello packages
    (as used in Squeak and Pharo) and a GUI to browse and load such packages.

    Notice that Squeak packages usually do not work out-of-the-box in ST/X.
"
! !

!stx_goodies_monticello class methodsFor:'description'!

excludedFromPreRequisites
    "list all packages which should be ignored in the automatic
     preRequisites scan. See #preRequisites for more."

    ^ #(
    )
!

mandatoryPreRequisites
    "list packages which are mandatory as a prerequisite.
     This are packages containing superclasses of my classes and classes which
     are extended by myself.
     They are mandatory, because we need these packages as a prerequisite for loading and compiling.
     This method is generated automatically,
     by searching along the inheritance chain of all of my classes."

    ^ #(
        #'stx:libbasic'    "AbstractTime - extended"
        #'stx:libbasic3'    "AbstractSourceCodeManager - superclass of MCSourceCodeManager"
        #'stx:libcompat'    "ListItemWrapper - superclass of MCDependentsWrapper"
        #'stx:libtool'    "AbstractSettingsApplication - superclass of MCSettingsApp"
        #'stx:libview2'    "ApplicationModel - extended"
        #'stx:libwidg2'    "AbstractHierarchicalItem - superclass of MCPackageEntry"
    )
!

referencedPreRequisites
    "list packages which are a prerequisite, because they contain
     classes which are referenced by my classes.
     We do not need these packages as a prerequisite for compiling or loading,
     however, a class from it may be referenced during execution and having it
     unloaded then may lead to a runtime doesNotUnderstand error, unless the caller
     includes explicit checks for the package being present.
     This method is generated automatically,
     by searching all classes (and their packages) which are referenced by my classes."

    ^ #(
        #'stx:goodies/communication'    "FTPClient - referenced by MCFtpRepository>>clientDo:"
        #'stx:libbasic2'    "Iterator - referenced by MCPackageList>>makeGenerator"
        #'stx:libcomp'    "Parser - referenced by MCRepositoryBrowser>>repositoryAddFromExpressionString"
        #'stx:libhtml'    "HTMLDocumentView - referenced by MCRepositoryBrowser>>openDocumentation"
        #'stx:libscm/mercurial'    "HGChangesetDialog - referenced by MCRepositoryBrowser>>versionUpdateSplicemap"
        #'stx:libview'    "Color - referenced by MCCommitDialog>>findUniqueVersionNumber"
        #'stx:libwidg'    "PopUpMenu - referenced by MCVersionInspector>>pickAncestor"
    )
!

subProjects
    "list packages which are known as subprojects.
     The generated makefile will enter those and make there as well.
     However: they are not forced to be loaded when a package is loaded;
     for those, redefine requiredPrerequisites."

    ^ #(
    )
! !

!stx_goodies_monticello class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        InMidstOfFileinNotification
        MCAncestry
        MCBrowserList
        MCChangeSelectionRequest
        MCConflict
        MCDefinition
        MCDefinitionIndex
        MCDependencySorter
        (MCDependentsWrapper autoload)
        MCDialog
        MCDirtyPackageInfo
        MCDoItParser
        MCEmptyPackageInfo
        MCFrontier
        MCInteractiveLoadingQuery
        MCLazyPropertyDictionary
        MCMergeRecord
        MCMergeResolutionRequest
        MCMerger
        MCMock
        MCMockAPoolDictionary
        MCMockDependency
        MCMockPackageInfo
        MCNoChangesException
        MCPackage
        MCPackageCache
        MCPackageEntry
        MCPackageLoader
        MCPackageManager
        MCPatch
        MCPatchOperation
        MCPatcher
        MCReader
        MCRepository
        MCRepositoryBrowser
        MCRepositoryEntry
        MCRepositoryGroup
        MCScanner
        MCSettingsApp
        MCSnapshot
        MCSnapshotOptions
        MCSourceCodeManager
        MCStXNamespaceQuery
        MCStXPackageInfo
        MCStXPackageQuery
        MCStXSnapshotTransformation
        MCStxVersionInfo
        MCTimestampAnnotation
        MCTool
        (MCToolWindowBuilder autoload)
        MCVariableDefinition
        MCVersion
        MCVersionDependency
        MCVersionEntry
        MCVersionLoader
        MCVersionMerger
        MCVersionNameAndMessageRequest
        MCVersionNotification
        MCVersionSorter
        MCWriter
        MethodReference
        PackageOrganizer
        #'stx_goodies_monticello'
        MCAddition
        MCClassComment
        MCClassDefinition
        MCClassInstanceVariableDefinition
        MCClassTraitDefinition
        MCClassTraitParser
        MCClassVariableDefinition
        MCCodeTool
        MCCommitDialog
        MCDictionaryRepository
        MCDiffyVersion
        MCFileBasedRepository
        MCFilteredVersionSorter
        MCGOODSRepository
        MCInstanceVariableDefinition
        MCMczWriter
        MCMethodDefinition
        MCMockDefinition
        MCMockDependentItem
        MCModification
        MCMultiPackageLoader
        MCOrganizationDefinition
        MCPackageList
        MCPoolImportDefinition
        MCRemoval
        MCRepositoryDialog
        MCRepositoryList
        (MCSaveVersionDialog autoload)
        MCScriptDefinition
        MCSnapshotReader
        MCStWriter
        MCStXSnapshotPostReadTransformation
        MCStXSnapshotPreWriteTransformation
        MCSystemCategoryParser
        MCThreeWayMerger
        MCTraitParser
        MCVersionHistoryBrowser
        MCVersionInfo
        MCVersionInfoWriter
        MCVersionInspector
        MCVersionList
        MCVersionReader
        MCWorkingAncestry
        MCWorkingCopy
        (MCWorkingCopyBrowser autoload)
        MCWriteOnlyRepository
        MCDirectoryRepository
        (MCFileRepositoryInspector autoload)
        MCFtpRepository
        MCHttpRepository
        MCLazyVersionInfo
        MCMcdWriter
        MCMczReader
        MCPatchBrowser
        MCPostscriptDefinition
        MCPreambleDefinition
        MCRemovalPostscriptDefinition
        MCRemovalPreambleDefinition
        (MCRepositoryInspector autoload)
        (MCSMCacheRepository autoload)
        MCSMReleaseRepository
        MCSmtpRepository
        (MCSnapshotBrowser autoload)
        MCStReader
        MCStxMczWriter
        MCStxStWriter
        MCTraitDefinition
        (MCWorkingHistoryBrowser autoload)
        MCCacheRepository
        (MCChangeSelector autoload)
        MCMcdReader
        (MCMergeBrowser autoload)
        MCStXMczReader
        MCSubDirectoryRepository
    )
!

extensionMethodNames
    "list class/selector pairs of extensions.
     A correponding method with real names must be present in my concrete subclasses"

    ^ #(
        Behavior traitCompositionString
        Behavior typeOfClass
        Class asClassDefinition
        Class classDefinitions
        Class poolDictionaryNames
        ClassDescription mcDefinition
        Object isConflict
        SequenceableCollection copyReplaceAll:with:asTokens:
        Stream isMessageStream
        String extractNumber
        String withSqueakLineEndings
        StringCollection asStringWithNativeLineEndings
        StringCollection asStringWithSqueakLineEndings
        Symbol isDoIt
        #'Tools::NewSystemBrowser' projectMenuMonticelloCommit
        UndefinedObject typeOfClass
        UserPreferences mcEnabled
        UserPreferences mcEnabled:
        UserPreferences mcRepositories
        UserPreferences mcRepositories:
        VersionInfo timeStamp
        'Annotation class' mctimestamp:
        'ProjectDefinition class' #'monticelloTimestamps_code'
        'ProjectDefinition class' #'monticelloTimestamps_codeFor:'
        'Timestamp class' fromMethodTimeStamp:
        Change mcDefinition
        Change mcDefinition:
        'ProjectDefinition class' monticelloName
        'ProjectDefinition class' #'monticelloAncestry_code'
        PackageInfo isMCStXPackageInfo
        CharacterArray asStringWithSqueakLineEndings
        CharacterArray asStringWithNativeLineEndings
        'ProjectDefinition class' monticelloNameForMCZ
        'ProjectDefinition class' monticelloSplicemap
        'ProjectDefinition class' #'monticelloSplicemap_code'
        'ProjectDefinition class' #'monticelloSplicemap_codeFor:'
    )
! !

!stx_goodies_monticello class methodsFor:'description - project information'!

applicationIconFileName
    "Return the name (without suffix) of an icon-file (the app's icon); will be included in the rc-resource file"

    ^ nil
    "/ ^ self applicationName
!

companyName
    "Return a companyname which will appear in <lib>.rc"

    ^ 'eXept Software AG'
!

description
    "Return a description string which will appear in vc.def / bc.def"

    ^ 'Smalltalk/X Monticello Class library'

    "Modified: / 20-08-2011 / 16:57:40 / cg"
!

legalCopyright
    "Return a copyright string which will appear in <lib>.rc"

    ^ 'Public - See SqueakSource'

    "Modified: / 20-08-2011 / 16:58:01 / cg"
!

productInstallDirBaseName
    "Returns a default installDir which will appear in <app>.nsi.
     This is usually not the one you want to keep"

    ^ (self package asCollectionOfSubstringsSeparatedByAny:':/') last
!

productName
    "Return a product name which will appear in <lib>.rc"

    ^ 'Smalltalk/X'
! !

!stx_goodies_monticello class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/stx_goodies_monticello.st,v 1.25 2015-02-21 12:34:04 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/stx_goodies_monticello.st,v 1.25 2015-02-21 12:34:04 cg Exp $'
!

version_HG
    ^ '$Changeset: <not expanded> $'
! !

