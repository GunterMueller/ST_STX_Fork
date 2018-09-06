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

LibraryDefinition subclass:#stx_libscm_mercurial
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!

!stx_libscm_mercurial class methodsFor:'documentation'!

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

!stx_libscm_mercurial class methodsFor:'description'!

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
     by searching along the inheritance chain of all of my classes.
     Please take a look at the #referencedPreRequisites method as well."

    ^ #(
        #'stx:libbasic'    "ActivityNotification - superclass of HGNotification"
        #'stx:libbasic2'    "Singleton - superclass of HGStatus"
        #'stx:libbasic3'    "AbstractSourceCodeManager - superclass of HGSourceCodeManager"
        #'stx:libscm/common'    "SCMAbstractCommitDialog - superclass of HGCommitDialog"
        #'stx:libtool'    "AbstractFileBrowser - extended"
        #'stx:libview'    "DisplaySurface - superclass of HGChangesetLabelsView"
        #'stx:libview2'    "ApplicationModel - extended"
    )
!

preRequisites
    "list all required packages.
     This list can be maintained manually or (better) generated and
     updated by scanning the superclass hierarchies and looking for
     global variable accesses. (the browser has a menu function for that)
     Howevery, often too much is found, and you may want to explicitely
     exclude individual packages in the #excludedFromPrerequisites method."

    ^ #(
        #'stx:goodies/sunit'    "TestCase - superclass of HGTests "
        #'stx:libbasic'    "CharacterArray - superclass of extended String "
        #'stx:libbasic2'    "Singleton - superclass of HGStatus::NotTracked "
        #'stx:libbasic3'    "AbstractSourceCodeManager - superclass of HGSourceCodeManager "
        #'stx:libhtml'    "HTMLDocumentView - referenced by HGSourceCodeManagementSettingsAppl>>help "
        #'stx:libscm/common'    "SCMAbstractDialog - superclass of HGCommitDialog "
        #'stx:libtool'    "AbstractDirectoryBrowser - superclass of HGWorkingCopyBrowser::DirectoryContentsBrowser "
        #'stx:libview'    "Depth1Image - referenced by HGSourceCodeManagementSettingsAppl class>>defaultIcon3 "
        #'stx:libview2'    "SimpleDialog - superclass of HGCommitDialog "
    )
!

referencedPreRequisites
    "list packages which are a prerequisite, because they contain
     classes which are referenced by my classes.
     These packages are NOT needed as a prerequisite for compiling or loading,
     however, a class from it may be referenced during execution and having it
     unloaded then may lead to a runtime doesNotUnderstand error, unless the caller
     includes explicit checks for the package being present.
     This method is generated automatically,
     by searching all classes (and their packages) which are referenced by my classes.
     Please also take a look at the #mandatoryPreRequisites method"

    ^ #(
        #'stx:libhtml'    "HTMLDocumentView - referenced by HGSourceCodeManagementSettingsAppl>>help"
        #'stx:libtool2'    "Tools::ObjectModuleInformation - referenced by HGSourceCodeManager class>>revisionInfoFromString:"
        #'stx:libwidg'    "DialogBox - referenced by AbstractFileBrowser>>hgClone"
        #'stx:libwidg2'    "ProgressIndicator - referenced by AbstractFileBrowser>>hgClone"
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

!stx_libscm_mercurial class methodsFor:'description - compilation'!

additionalRules_bc_dot_mak
    "allows for additional static libraries to be added to the bc.mak file.
     Subclasses may redefine this"

    ^ '
doc:
        pushd docs & $(MAKE_BAT) html

doc-install:
        pushd docs & $(MAKE_BAT) html-install


clean::
        pushd docs & $(MAKE_BAT) clean

'

    "Created: / 11-11-2012 / 12:22:21 / jv"
    "Modified: / 24-01-2013 / 22:26:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

additionalRules_make_dot_proto
    "allows for additional rules to be added to the make.proto file."

    ^ '
doc:
        $(MAKE) -C docs html

doc-install:
        $(MAKE) -C docs html-install

clean::
        $(MAKE) -C docs clean
'

    "Created: / 01-11-2012 / 22:35:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 24-01-2013 / 22:27:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!stx_libscm_mercurial class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."
    
    ^ "<className> or (<className> attributes...) in load order" #( #HG2CVS
     #HGAuthorQuery
     #HGCachedFileData
     #HGChange
     #HGChangesetBrowser
     #HGChangesetDialog
     #HGChangesetFile
     #HGChangesetId
     #HGChangesetLabelsView
     #HGChangesetList
     #HGChangesetPresenter
     #HGChangesetViewer
     #HGCommandParser
     #HGCommitDialog
     #HGCommitTask
     #HGContribution
     #HGCopyrightUpdater
     #HGCopyrightLine
     #HGDebugFlags
     #HGError
     #HGIconLibrary
     #HGMergeInfo
     #HGMergeTool
     #HGNotification
     #HGPackageRevision
     #HGPackageWorkingCopy
     #HGPackageWorkingCopyRegistry
     #HGPushPullInfo
     #HGRepositoryObject
     #HGRevisionAnnotation
     #HGRevisionInfo
     #HGRevset
     #HGRevsetEditor
     #HGSourceCodeManagementSettingsAppl
     #HGSourceCodeManager
     #HGSourceCodeManagerUtilities
     #HGStatus
     #HGWarning
     #HGWorkingCopyFile
     #'stx_libscm_mercurial'
     #HGBookmarkError
     #HGChangeset
     #HGChangesetLabel
     #HGCommand
     #HGCommandError
     #HGCommandServer
     #HGCommitError
     #HGConfig
     #HGNoSuchBranchError
     #HGRemote
     #HGRepository
     #HGRepositoryError
     #HGWorkingCopy
     #HGBranch
     #HGCommandParseError
     #HGInvalidExecutableError
     #HGInvalidVersionError
     #HGObsoleteRevisionError
     #HGPushError
     #HGTagOrBookmark
     #HGUnknownRevisionError
     #HGBookmark
     #HGPushWouldCreateNewHeadError
     #HGTag
     #(HGRepositoriesResource autoload)
     #(HGTestCase autoload)
     #(HGStXTests autoload)
     #(HGTests autoload)
     #(HGCommandParserTests autoload)
     #(HGInstaller autoload)
     #(HGCopyrightUpdateTool autoload) )
!

extensionMethodNames
    "lists the extension methods which are to be included in the project.
     Entries are 2-element array literals, consisting of class-name and selector.
     A correponding method with real names must be present in my concrete subclasses
     if it has extensions."

    ^ #(
        ByteArray asHGChangesetId
        Integer asHGChangesetId
        Object asHGChangesetId
        UserPreferences hgCommand
        UserPreferences hgCommand:
        UserPreferences hgAutopush
        UserPreferences hgAutopush:
        Object asHGRevision
        'Annotation class' HGRevision:
        'ProjectDefinition class' hgBinaryRevision
        'ProjectDefinition class' hgLogicalRevision
        'ProjectDefinition class' hgPostLoad
        #'Tools::NewSystemBrowser' commonMenuHGBrowseWorkingCopy
        #'Tools::NewSystemBrowser' selectedProjectsForHG
        'Tools::NewSystemBrowser class' #'classMenuSCMExtra_HG'
        'Tools::NewSystemBrowser class' #'projectMenuSCMExtra_HG'
        #'Tools::NewSystemBrowser' commonMenuHGPushSlice
        'AbstractFileBrowser class' hgMenu
        'ConfigurableFeatures class' hasHGSupport
        'ConfigurableFeatures class' hasHGSupportEnabled
        AbstractFileBrowser currentHgRepository
        AbstractFileBrowser hasHGWorkingCopySelected
        AbstractFileBrowser hgCommit
        AbstractFileBrowser hgExecuteCommand:
        AbstractFileBrowser hgExecuteCommand:objects:
        AbstractFileBrowser hgStatus
        AbstractFileBrowser hgMenuMerge
        #'Tools::NewSystemBrowser' commonMenuHGBrowseTemporaryWorkingCopy
        AbstractFileBrowser hgResolve
        AbstractFileBrowser hgResolveList
        AbstractFileBrowser hgResolveListUnresolved
        AbstractFileBrowser hgResolveMark
        AbstractFileBrowser hgRevert
        AbstractFileBrowser hgUpdate
        AbstractFileBrowser hgUpdateClean
        AbstractFileBrowser hgSummary
        AbstractFileBrowser hgBranches
        AbstractFileBrowser hgHeads
        Object isHGChangeset
        AbstractFileBrowser hgEditConfig:
        AbstractFileBrowser hgEditConfigRepository
        AbstractFileBrowser hgEditConfigUser
        AbstractFileBrowser hgMenuPull
        AbstractFileBrowser hgMenuPush
        AbstractFileBrowser hgPullFrom:repository:
        AbstractFileBrowser hgPullFromURLRepository:
        AbstractFileBrowser hgPushTo:repository:
        AbstractFileBrowser hgPushToURLRepository:
        'ProjectDefinition class' hgRemoveContainesForDeletedClasses
        'ProjectDefinition class' hgEnsureCopyrightMethod
        'ProjectDefinition class' #'hgEnsureVersion_HGMethod'
        CharacterArray asHGChangesetId
        AbstractFileBrowser hasHGWorkingCopyNotSelected
        AbstractFileBrowser hgClone
        AbstractFileBrowser hgCloneEnabled
        AbstractFileBrowser hgInit
        AbstractFileBrowser hgInitEnabled
        'ProjectDefinition class' hgLogicalRevision:
        CharacterArray asHGRevset
        Object asHGRevset
        AbstractFileBrowser hgLog
        #'Tools::NewSystemBrowser' commonMenuHGPush:to:
        AbstractFileBrowser hgMenuUpdate
        AbstractFileBrowser hgMerge:
        AbstractFileBrowser hgMergeWithRevision
        AbstractFileBrowser hgUpdate:
        AbstractFileBrowser hgUpdateToRevision
        #'Tools::NewSystemBrowser' projectMenuHGBrowseRevisionHistory
        UserPreferences hgUseSharedRepositories
        UserPreferences hgUseSharedRepositories:
    )
! !

!stx_libscm_mercurial class methodsFor:'description - project information'!

applicationIconFileName
    "Return the name (without suffix) of an icon-file (the app's icon); will be included in the rc-resource file"

    ^ nil
    "/ ^ self applicationName
!

companyName
    "Return a companyname which will appear in <lib>.rc"

    ^ 'Jan Vrany'

    "Modified: / 23-11-2012 / 20:27:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

description
    "Return a description string which will appear in vc.def / bc.def"

    ^ 'Mercurial integration for Smalltalk/X'

    "Modified: / 23-11-2012 / 20:27:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

legalCopyright
    "Return a copyright string which will appear in <lib>.rc"

    ^ 'Copyright Jan Vrany 2012'

    "Modified: / 23-11-2012 / 20:27:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

productInstallDirBaseName
    "Returns a default installDir which will appear in <app>.nsi.
     This is usually not the one you want to keep"

    ^ (self package asCollectionOfSubstringsSeparatedByAny:':/') last
!

productName
    "Return a product name which will appear in <lib>.rc"

    ^ 'Smalltalk/X Mercurial Integration'

    "Modified: / 23-11-2012 / 20:28:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!stx_libscm_mercurial class methodsFor:'description - svn'!

svnRepositoryUrlString
    "Return a SVN repository URL of myself.
     (Generated since 2011-04-08)
     Do not make the string shorter!!!!!! We have to use fixed-length keyword!!!!!!
    "

    ^ '$URL::                                                                                                                        $'
!

svnRevisionNr
    "Return a SVN revision number of myself.
     This number is updated after a commit"

    ^ "$SVN-Revision:"'nil             '"$"
! !

!stx_libscm_mercurial class methodsFor:'file templates'!

bc_dot_mak
    "answer a template for the bc.mak makefile.
     Any variable definition %(Variable) will be later replaced by the mapping.
     $% characters have to be duplicated"

^
'# Hack to make it compilable under Smalltalk/X 6.2.2 (which does not have RES variable defined)
!!ifndef RES
RES=res
!!endif

' , super bc_dot_mak

    "Created: / 03-07-2013 / 19:38:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!stx_libscm_mercurial class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id::                                                                                                                        '
! !

