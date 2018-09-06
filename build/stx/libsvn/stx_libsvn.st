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

LibraryDefinition subclass:#stx_libsvn
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!

!stx_libsvn class methodsFor:'documentation'!

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
! !

!stx_libsvn class methodsFor:'description'!

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
        #'stx:libbasic'    "ArithmeticValue - extended"
        #'stx:libbasic3'    "AbstractSourceCodeManager - superclass of SVNSourceCodeManager"
        #'stx:libtool'    "AbstractFileBrowser - extended"
        #'stx:libview'    "DisplaySurface - extended"
        #'stx:libview2'    "ApplicationModel - extended"
        #'stx:libwidg2'    "FilenameWidgetWithHistory - extended"
    )
!

postLoadAction

        SVN::Configuration flushCaches.
        SVN::RepositoryManager reset.

    "/JV-2011-06-10: Not needed anymore since new version of St/X now supports multiple
    "/VCS...
    "
    NewLauncher
        addSettingsApplicationByClass: SVN::ConfigurationApp fullName asSymbol
        withName:'Subversion'
        icon: nil.
    "

    "Created: / 24-05-2008 / 01:55:31 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 27-05-2008 / 07:41:29 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 14-12-2010 / 11:07:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 10-06-2011 / 14:04:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

preLoadAction
    ProgressNotification autoload

!

preUnloadAction

    NewLauncher
        removeSettingsApplicationByClass: SVN::SettingsApp fullName asSymbol
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
        #'stx:goodies/xml/vw'    "XML::Node - referenced by SVN::WCEntry class>>readFromXml:"
        #'stx:libbasic2'    "List - referenced by SVN::Configuration>>initialize"
        #'stx:libtool2'    "MenuEditor - referenced by SVN::IconLibrary class>>initialize"
        #'stx:libwidg'    "Button - referenced by SVN::CommitDialog2>>doRunSanityChecks"
    )
!

subProjects
    "list packages which are known as subprojects.
     The generated makefile will enter those and make there as well.
     However: they are not forced to be loaded when a package is loaded;
     for those, redefine requiredPrerequisites"

    ^ #(
    )
! !

!stx_libsvn class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        #'SVN::Branch'
        #'SVN::BranchQuery'
        #'SVN::Browser'
        #'SVN::Cache'
        #'SVN::CacheEntry'
        #'SVN::Command'
        #'SVN::CompatModeQuery'
        #'SVN::Configuration'
        #'SVN::ConfigurationApp'
        #'SVN::Credentials'
        #'SVN::Dialog'
        #'SVN::DiffViewApp'
        #'SVN::Entry'
        #'SVN::Enum'
        #'SVN::ExternalMergeTool'
        #'SVN::IconLibrary'
        #'SVN::MergeBrowser'
        #'SVN::OSProcess'
        #'SVN::PackagePattern'
        #'SVN::Property'
        #'SVN::Repository'
        #'SVN::RepositoryConfiguration'
        #'SVN::RepositoryManager'
        #'SVN::Revision'
        #'SVN::RevisionRange'
        #'SVN::SVNError'
        #'SVN::Task'
        #'SVN::WCAction'
        #'SVN::WCActionNotification'
        #'SVN::WCError'
        #'SVN::WizardPane'
        #'SVN::WorkingCopy'
        #'SVN::XMLObject'
        SVNSourceCodeManager
        #'stx_libsvn'
        #'SVN::AuthorizationError'
        #'SVN::BranchAndRevisionSelectionDialog'
        #'SVN::BranchCommand'
        #'SVN::BranchSelectionDialog'
        #'SVN::CVSTask'
        #'SVN::CommitDialog2'
        #'SVN::ConfigurationDialog'
        #'SVN::CreateRepositoryCommand'
        #'SVN::CredentialsDialog'
        #'SVN::FileoutLikeTask'
        #'SVN::KDiff3'
        #'SVN::MergeViewApp'
        #'SVN::NodeKind'
        #'SVN::NonExistentURLError'
        #'SVN::ProgressDialog'
        #'SVN::RepositoryDialog'
        #'SVN::RepositoryEntry'
        #'SVN::RevisionBase'
        #'SVN::RevisionDate'
        #'SVN::RevisionHead'
        #'SVN::RevisionLogBrowser'
        #'SVN::RevisionLogEntry'
        #'SVN::RevisionNumber'
        #'SVN::Status'
        #'SVN::UnknownError'
        #'SVN::WCActionAdded'
        #'SVN::WCActionConflict'
        #'SVN::WCActionDeleted'
        #'SVN::WCActionMerged'
        #'SVN::WCActionModified'
        #'SVN::WCActionNone'
        #'SVN::WCActionRestored'
        #'SVN::WCActionUpdated'
        #'SVN::WCCommand'
        #'SVN::WCEntry'
        #'SVN::WCEntryInfo'
        #'SVN::Wizard'
        #'SVN::WorkingCopyBrowser'
        #'SVN::WorkingCopyLockedError'
        #'SVN::CatCommand'
        #'SVN::CleanupCommand'
        #'SVN::CommitTask'
        #'SVN::CommitWizard'
        #'SVN::CopyCommand'
        #'SVN::ExportCommand'
        #'SVN::ImportFromCVSTask'
        #'SVN::ListCommand'
        #'SVN::LogCommand'
        #'SVN::MoveCommand'
        #'SVN::NodeKindDir'
        #'SVN::NodeKindExternal'
        #'SVN::NodeKindFile'
        #'SVN::NodeKindNone'
        #'SVN::NodeKindUnknown'
        #'SVN::StatusAdded'
        #'SVN::StatusConflicted'
        #'SVN::StatusDeleted'
        #'SVN::StatusExternal'
        #'SVN::StatusIgnored'
        #'SVN::StatusIncomplete'
        #'SVN::StatusMissing'
        #'SVN::StatusModified'
        #'SVN::StatusNormal'
        #'SVN::StatusObstructed'
        #'SVN::StatusReplaced'
        #'SVN::StatusUnversioned'
        #'SVN::SyncWithCVSTask'
        #'SVN::UpdateLikeCommand'
        #'SVN::UpdateLikeTask'
        #'SVN::WCPathCommand'
        #'SVN::AddCommand'
        #'SVN::CheckoutCommand'
        #'SVN::CommitCommand'
        #'SVN::DeleteCommand'
        #'SVN::InfoCommand'
        #'SVN::MergeCommand'
        #'SVN::MergeTask'
        #'SVN::PropsetCommand'
        #'SVN::ResolvedCommand'
        #'SVN::RevertCommand'
        #'SVN::StatusCommand'
        #'SVN::UpdateCommand'
        #'SVN::UpdateTask'
        (#'SVN::CommitTests' autoload)
        (#'SVN::ConfigurationTests' autoload)
        (#'SVN::PackageAResource' autoload)
        (#'SVN::PackageBResource' autoload)
        (#'SVN::PackagePatternTests' autoload)
        (#'SVN::PackageResource' autoload)
        (#'SVN::RepositoryResource' autoload)
        (#'SVN::UpdateLikeWizard' autoload)
    )
!

extensionMethodNames
    "list class/selector pairs of extensions.
     A correponding method with real names must be present in my concrete subclasses"

    ^ #(
        AbstractFileBrowser canSubversionMerge
        AbstractFileBrowser canSubversionMergeAuto
        AbstractFileBrowser canSubversionMergeWithExternalDiff3
        AbstractFileBrowser canSubversionResolve
        AbstractFileBrowser hasSubversionWorkingCopySelected
        AbstractFileBrowser hasSubversionWorkingCopySelectedAndDiff3CmdDefined
        AbstractFileBrowser svnAdd
        AbstractFileBrowser svnCommit
        AbstractFileBrowser svnCompare
        AbstractFileBrowser svnCompare:
        AbstractFileBrowser svnCompareWithBASE
        AbstractFileBrowser svnCompareWithHEAD
        AbstractFileBrowser svnDebugOpenWorkingCopyBrowser
        AbstractFileBrowser svnDiff
        AbstractFileBrowser svnExecuteCommand:
        AbstractFileBrowser svnExecuteCommand:objects:
        AbstractFileBrowser svnInfo
        AbstractFileBrowser svnLog:
        AbstractFileBrowser svnMerge
        AbstractFileBrowser svnMergeAuto
        AbstractFileBrowser svnMergeBranch
        AbstractFileBrowser svnMergeFilesFor:do:
        AbstractFileBrowser svnMergeFilesFor:inDirectoryContaining:do:
        AbstractFileBrowser svnMergeWithExternalDiff3
        AbstractFileBrowser svnRemove
        AbstractFileBrowser svnRevert
        AbstractFileBrowser svnStatus
        AbstractFileBrowser svnStatusShowUpdates
        AbstractFileBrowser svnUpdate
        AbstractFileBrowser svnUpdateWithExternalDiff3
        AbstractFileBrowser svnWorkingCopy
        ChangeSet condenseChangesForPackage2:
        Class fileOutAsMethodIn:selector:
        Class svnBranch
        Class svnRepository
        Date asSVNRevisionSpec
        Filename directoryContentsAsFilenamesMatching:
        Filename directoryContentsMatching:
        FilenameWidgetWithHistory historyList:
        FilenameWidgetWithHistory modifiedChannel:
        Integer asSVNRevisionSpec
        Method makeSourceFileAbsolute
        MethodChange asAntiChange
        MethodChange isForGeneratedSubject
        String asSVNRevisionSpec
        #'Tools::NewSystemBrowser' classMenuDiffsetFor:againstBranch:revision:
        #'Tools::NewSystemBrowser' classMenuSubversionBrowseWorkingCopy
        #'Tools::NewSystemBrowser' classMenuSubversionChangeset
        #'Tools::NewSystemBrowser' classMenuSubversionChangeset:againstBranch:revision:
        #'Tools::NewSystemBrowser' classMenuSubversionCommit
        #'Tools::NewSystemBrowser' classMenuSubversionCompare
        #'Tools::NewSystemBrowser' classMenuSubversionCompare:withBranch:revision:
        #'Tools::NewSystemBrowser' classMenuSubversionCompare:withRevision:
        #'Tools::NewSystemBrowser' classMenuSubversionCompareWithRevisionHead
        #'Tools::NewSystemBrowser' classMenuSubversionUpdate
        #'Tools::NewSystemBrowser' classSubversionChangesetMenu
        #'Tools::NewSystemBrowser' commonMenuSubversionBrowseWorkingCopy
        #'Tools::NewSystemBrowser' commonMenuSubversionFlushCaches
        #'Tools::NewSystemBrowser' hasClassesSelectedAndSubversionRepositoryExistsAndBranchSelectedHolder
        #'Tools::NewSystemBrowser' hasProjectSelectedSubversionRepositoryExistsAndBranchSelectedHolder
        #'Tools::NewSystemBrowser' hasSingleClassAndSubversionRepositoryExists
        #'Tools::NewSystemBrowser' hasSubversionRepositoryAndBranchFor:
        #'Tools::NewSystemBrowser' projectMenuSubversionChangeset
        #'Tools::NewSystemBrowser' projectMenuSubversionChangesetAgainstBranch:revision:
        #'Tools::NewSystemBrowser' projectMenuSubversionCommit
        #'Tools::NewSystemBrowser' projectMenuSubversionCommitMode
        #'Tools::NewSystemBrowser' projectMenuSubversionCompare
        #'Tools::NewSystemBrowser' projectMenuSubversionCompareWithBranch:revision:
        #'Tools::NewSystemBrowser' projectMenuSubversionCompareWithRevisionHead
        #'Tools::NewSystemBrowser' projectMenuSubversionLoadRevision
        #'Tools::NewSystemBrowser' projectMenuSubversionLoadRevision:
        #'Tools::NewSystemBrowser' projectMenuSubversionMergeWith:revision:
        #'Tools::NewSystemBrowser' projectMenuSubversionRemoveWorkingCopy
        #'Tools::NewSystemBrowser' projectMenuSubversionShowRevisionLog
        #'Tools::NewSystemBrowser' projectMenuSubversionUpdate
        #'Tools::NewSystemBrowser' projectSubversionChangesetMenu
        #'Tools::NewSystemBrowser' projectSubversionMergeMenu
        #'Tools::NewSystemBrowser' selectedProjectSubversionRepository
        #'Tools::NewSystemBrowser' selectedProjectsForSubversion
        #'Tools::NewSystemBrowser' selectedProjectsFromClasses
        #'Tools::NewSystemBrowser' svnRepositoryFor:
        #'Tools::NewSystemBrowser' svnRepositoryManager
        #'Tools::NewSystemBrowser' theSingleSelectedProjectForSubversion
        #'Tools::NewSystemBrowser' theSingleSelectedProjectFromClasses
        UserPreferences svnCommand
        UserPreferences svnCommand:
        UserPreferences svnConfigurations2
        UserPreferences svnConfigurations2:
        UserPreferences svnCurrentConfiguration
        UserPreferences svnCurrentConfiguration:
        UserPreferences svnDiff2Command
        UserPreferences svnDiff2Command:
        UserPreferences svnDiff3Command
        UserPreferences svnDiff3Command:
        UserPreferences svnEnabled
        UserPreferences svnEnabled:
        UserPreferences svnVerbose
        UserPreferences svnVerbose:
        'AbstractFileBrowser class' svnMenu
        'ProjectDefinition class' forEachContentsMethodsCodeToCompileDo:ignoreOldEntries:ignoreOldDefinition:
        'ProjectDefinition class' svnRepositoryUrl
        'ProjectDefinition class' #'svnRepositoryUrlString_code'
        'ProjectDefinition class' svnRevision
        'Tools::NewSystemBrowser class' classMenuSubversion
        'Tools::NewSystemBrowser class' classSubversionChangesetMenu
        'Tools::NewSystemBrowser class' classSubversionCompareMenu
        'Tools::NewSystemBrowser class' projectMenuSubversion
        'Tools::NewSystemBrowser class' projectSubversionChangesetMenu
        'Tools::NewSystemBrowser class' projectSubversionCompareMenu
        'Tools::NewSystemBrowser class' projectSubversionMergeMenu
        'UserNotification class' notify:progress:
    )
! !

!stx_libsvn class methodsFor:'description - project information'!

companyName
    "Return a companyname which will appear in <lib>.rc"

    ^ 'CTU-FEI'

    "Modified: / 06-04-2008 / 21:20:20 / janfrog"
!

description
    "Return a description string which will appear in vc.def / bc.def"

    ^ 'SubVersion support for Smalltalk/X'

    "Modified: / 06-04-2008 / 21:20:38 / janfrog"
!

legalCopyright
    "Return a copyright string which will appear in <lib>.rc"

    ^ 'Copyright Jan Vrany 2008'

    "Modified: / 06-04-2008 / 21:20:55 / janfrog"
!

productName
    "Return a product name which will appear in <lib>.rc"

    ^ 'Smalltalk/X Subversion support'

    "Modified: / 06-04-2008 / 21:21:14 / janfrog"
! !

!stx_libsvn class methodsFor:'description - svn'!

svnRepositoryUrlString
    "Return a SVN repository URL of myself.
     (Generated since 2011-04-08)
    "

    ^ '$URL: https://vranyj1@swing.fit.cvut.cz/svn/stx/libsvn/branches/jv/stx_libsvn.st $'
!

svnRevisionNr
    "Return a SVN revision number of myself.
     This number is updated after a commit"

    ^ "$SVN-Revision:"'372M'"$"
! !

!stx_libsvn class methodsFor:'others'!

version
    ^ '$Header$'
!

version_CVS

    ^ '$Header$'
!

version_SVN
    ^ '$Id$'

! !

!stx_libsvn class methodsFor:'documentation'!

version_HG
    ^ '$Changeset: <not expanded> $'
! !

