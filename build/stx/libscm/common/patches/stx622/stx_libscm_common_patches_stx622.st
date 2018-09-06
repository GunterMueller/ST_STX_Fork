"{ Package: 'stx:libscm/common/patches/stx622' }"

LibraryDefinition subclass:#stx_libscm_common_patches_stx622
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!


!stx_libscm_common_patches_stx622 class methodsFor:'description'!

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
        #'stx:libbasic'    "Behavior - superclass of extended Class "
        #'stx:libtool'    "Tools::InlineMessageDialog - extended "
        #'stx:libview2'    "ApplicationModel - superclass of extended Tools::InlineMessageDialog "
    )
! !

!stx_libscm_common_patches_stx622 class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        #'stx_libscm_common_patches_stx622'
    )
!

extensionMethodNames
    "lists the extension methods which are to be included in the project.
     Entries are 2-element array literals, consisting of class-name and selector."

    ^ #(
        'ProjectDefinition class' executeHooks:
        'ProjectDefinition class' loadAsAutoloaded:
        #'Tools::ChangeSetDiffTool' showVersionMethodDiffs:
        #'Tools::InlineMessageDialog' doAbortIfWorking
        'ProjectDefinition class' fileReleaseNr
        'ProjectDefinition class' fileRevisionNr
        Class binaryRevision
    )
! !

!stx_libscm_common_patches_stx622 class methodsFor:'description - project information'!

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

    ^ 'Copyright Claus Gittinger 1988-2013\nCopyright eXept Software AG 1998-2013'
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

!stx_libscm_common_patches_stx622 class methodsFor:'documentation'!

version_HG
    ^ '$Changeset: <not expanded> $'
! !
