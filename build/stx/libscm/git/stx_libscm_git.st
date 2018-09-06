"{ Package: 'stx:libscm/git' }"

LibraryDefinition subclass:#stx_libscm_git
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!


!stx_libscm_git class methodsFor:'description'!

excludedFromPreRequisites
    "list all packages which should be ignored in the automatic
     preRequisites scan. See #preRequisites for more."

    ^ #(
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
        #'stx:goodies/sunit'
        #'stx:libbasic'    "ExternalStructure - superclass of GitDiffFileStructure "
        #'stx:libbasic3'    "AbstractSourceCodeManager - superclass of GitSourceCodeManager2 "
        #'stx:libscm/common'    "SCMAbstractPackageModel - superclass of GitPackageModel "
        #'stx:libsvn'
        #'stx:libtool'    "AbstractSettingsApplication - superclass of GitSourceCodeManagementSettingsAppl2 "
        #'stx:libview'    "Depth8Image - referenced by GitSourceCodeManagementSettingsAppl2 class>>defaultIcon2 "
        #'stx:libview2'    "Model - superclass of GitCommitDialog "
        #'stx:libwidg'
        #'stx:libwidg2'
    )
! !

!stx_libscm_git class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        GitLibraryObject
        GitRepositoryObject
        GitStatusCodes
        GitErrorKlass
        GitStructure
        GitObjectType
        GitError
        GitObject
        GitCommit
        GitOid
        GitRepository
        GitTree
        #'stx_libscm_git'
        GitAttrType
        GitBlobHandle
        GitBranchType
        GitCommitHandle
        GitConfigFileStructure
        GitConfigHandle
        GitCvarMapStructure
        GitCvarType
        GitDeltaType
        GitDiffDeltaStructure
        GitDiffFileStructure
        GitDiffListHandle
        GitDiffOptionsStructure
        GitDiffRangeStructure
        GitErrorStructure
        GitFilemodeType
        GitIndexEntryStructure
        GitIndexEntryUnmergedStructure
        GitIndexHandle
        GitIndexTimeStructure
        GitIndexerHandle
        GitIndexerStatsStructure
        GitIndexerStreamHandle
        GitNoteDataStructure
        GitNoteHandle
        GitObjectHandle
        GitOdbBackendStructure
        GitOdbHandle
        GitOdbObjectHandle
        GitOdbStreamStructure
        GitOidShortenHandle
        GitRefType
        GitReferenceHandle
        GitReflogEntryHandle
        GitReflogHandle
        GitRefspecHandle
        GitRemoteCallbacksStructure
        GitRemoteCompletionType
        GitRemoteHandle
        GitRemoteHeadStructure
        GitRepositoryHandle
        GitRepositoryInitOptionsStructure
        GitResetType
        GitRevwalkHandle
        GitSignatureStructure
        GitStatusOptionsStructure
        GitStatusShowType
        GitSubmoduleHandle
        GitSubmoduleIgnoreType
        GitSubmoduleStatusType
        GitSubmoduleUpdateType
        GitTagHandle
        GitTimeStructure
        GitTreeEntryHandle
        GitTreeHandle
        GitTreebuilderHandle
        GitTreewalkModeType
        GitPrimitives
        GitSignature
        GitWorkingCopy
        GitTag
        GitCheckoutStrategy
        (GitRepositoriesResource autoload)
        (GitTests autoload)
        GitCheckoutOptions
        GitIndex
        GitWorkingCopyEntry
        GitSignatureQuery
        GitAuthorQuery
        GitCommitterQuery
        GitReference
        GitCommand
        GitStringArray
        GitSourceCodeManagementSettingsAppl2
        GitSourceCodeManager2
        GitIconLibrary
        GitCommitDialog
        GitRemote
        GitPackageModel
        GitPackageModelRegistry
    )
!

extensionMethodNames
    "lists the extension methods which are to be included in the project.
     Entries are 2-element array literals, consisting of class-name and selector."

    ^ #(
        Object isGitBlob
        Object isGitCommit
        Object isGitObject
        Object isGitOid
        Object isGitRepository
        Object isGitTag
        Object isGitTree
        Object isGitReference
        Object isGitTreeish
        #'SCMAbstractSourceCodeManager::Utilities' checkinClass:withInfo:withCheck:usingManager:
        #'SCMAbstractSourceCodeManager::Utilities' compareProject:withRepositoryVersionFrom:
        #'SCMAbstractSourceCodeManager::Utilities' diffSetOfProject:againstRepositoryVersionFrom:
        #'SCMAbstractSourceCodeManager::Utilities' tagClass:as:
        #'SCMAbstractSourceCodeManager::Utilities' tagClasses:as:
        #'SCMAbstractSourceCodeManager::Utilities' tagPackage:as:
    )
! !

!stx_libscm_git class methodsFor:'description - project information'!

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

    ^ 'Smalltalk/X Class library'
!

legalCopyright
    "Return a copyright string which will appear in <lib>.rc"

    ^ 'Copyright Claus Gittinger 1988-2012\nCopyright eXept Software AG 1998-2012'
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

!stx_libscm_git class methodsFor:'description - svn'!

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

    ^ "$SVN-Revision:"'30              '"$"
! !

!stx_libscm_git class methodsFor:'documentation'!

version_GIT
    "Never, ever change this method. Ask JV or CG why"
    ^thisContext method mclass theNonMetaclass instVarNamed: #revision
!

version_SVN
    ^ '$Id$'
! !
