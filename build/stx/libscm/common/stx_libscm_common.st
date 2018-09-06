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
"{ Package: 'stx:libscm/common' }"

LibraryDefinition subclass:#stx_libscm_common
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!

!stx_libscm_common class methodsFor:'documentation'!

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

!stx_libscm_common class methodsFor:'class initialization'!

initialize
    "Initialize the package. This should actually be preLoadAction or postLoadAction
     but they are *NOT* called when package is loaded from compiled class library. 
     Hence done here."

    Smalltalk versionString = '6.2.2' ifTrue:[
        Smalltalk loadPackage: 'stx:libscm/common/patches/stx622'    
    ].

    "Created: / 05-07-2013 / 00:20:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!stx_libscm_common class methodsFor:'description'!

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
     They are mandatory, beacuse we need these packages as a prerequisite for loading and compiling.
     This method is generated automatically,
     by searching along the inheritance chain of all of my classes."

    ^ #(
        #'stx:libbasic'    "Collection - extended "
        #'stx:libbasic3'    "AbstractSourceCodeManager - superclass of SCMAbstractSourceCodeManager "
        #'stx:libview2'    "ApplicationModel - superclass of SCMAbstractCommitDialog "
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
        #'stx:libbasic'    "Object - superclass of SCMAbstractPackageModel "
        #'stx:libbasic3'    "SourceCodeManagerUtilitiesForWorkspaceBasedManagers - superclass of SCMCommonSourceCodeManagerUtilities "
        #'stx:libtool'    "Tools::TextDiffTool - referenced by SCMAbstractCommitDialog>>doShowDiffsForEntry:against: "
        #'stx:libview'    "Color - referenced by SCMAbstractCommitDialog>>browseWorkingCopyLabel "
        #'stx:libview2'    "SimpleDialog - superclass of SCMAbstractDialog "
        #'stx:libwidg'    "Button - referenced by SCMAbstractCommitDialog>>doRunSanityChecks "
        #'stx:libwidg2'    "ProgressNotification - referenced by SCMAbstractTask>>notify:progress: "
    )
!

referencedPreRequisites
    "list packages which are a prerequisite, because they contain
     classes which are referenced by my classes.
     We do not need these packages as a prerequisite for loading or compiling.
     This method is generated automatically,
     by searching all classes (and their packages) which are referenced by my classes."

    ^ #(
        #'stx:libjava'    "JavaVM - referenced by SCMAbstractFileoutLikeTask>>doRemoveOldContainersFor: "
        #'stx:libscm/mercurial'    "HGError - referenced by SCMAbstractPackageRevision>>childNamed: "
        #'stx:libtool'    "Tools::ChangeSetDiffTool - referenced by SCMCommonSourceCodeManagerUtilities>>compareProject:withRepositoryVersionFrom: "
        #'stx:libview'    "Color - referenced by SCMAbstractCommitDialog>>browseWorkingCopyLabel "
        #'stx:libwidg'    "Button - referenced by SCMAbstractCommitDialog>>doRunSanityChecks "
        #'stx:libwidg2'    "ProgressNotification - referenced by SCMAbstractFileoutLikeTask>>doCompileCopyrightMethodsFor: "
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

!stx_libscm_common class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        SCMAbstractDialog
        SCMAbstractPackageModel
        SCMAbstractPackageWorkingCopyRegistry
        SCMAbstractRevisionInfo
        SCMAbstractSourceCodeManager
        SCMAbstractTask
        SCMCodeMonitor
        SCMCommonPackageModelGroup
        SCMCommonSourceCodeManagerUtilities
        SCMCompatModeQuery
        SCMError
        SCMWarning
        #'stx_libscm_common'
        SCMAbstractCommitDialog
        SCMAbstractFileoutLikeTask
        SCMAbstractPackageRevision
        SCMAbstractPackageWorkingCopy
        SCMPackageModelError
        SCMPackageModelWarning
        SCMAbstractCommitTask
    )
!

extensionMethodNames
    "list class/selector pairs of extensions.
     A correponding method with real names must be present in my concrete subclasses"

    ^ #(
        ChangeSet condenseChangesForPackageAfterCommit:
    )
! !

!stx_libscm_common class methodsFor:'description - project information'!

applicationIconFileName
    "Return the name (without suffix) of an icon-file (the app's icon); will be included in the rc-resource file"

    ^ nil
    "/ ^ self applicationName
!

companyName
    "Return a companyname which will appear in <lib>.rc"

    ^ 'Jan Vrany'

    "Modified: / 23-11-2012 / 20:30:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

description
    "Return a description string which will appear in vc.def / bc.def"

    ^ 'Source Code Management Support Library for Smalltalk/X'

    "Modified: / 23-11-2012 / 20:30:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

legalCopyright
    "Return a copyright string which will appear in <lib>.rc"

    ^ 'Copyright Jan Vrany 2012'

    "Modified: / 23-11-2012 / 20:30:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

productInstallDirBaseName
    "Returns a default installDir which will appear in <app>.nsi.
     This is usually not the one you want to keep"

    ^ (self package asCollectionOfSubstringsSeparatedByAny:':/') last
!

productName
    "Return a product name which will appear in <lib>.rc"

    ^ 'Smalltalk/X SCM Support Library'

    "Modified: / 23-11-2012 / 20:31:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!stx_libscm_common class methodsFor:'description - svn'!

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

    ^ "$SVN-Revision:"'45              '"$"
! !

!stx_libscm_common class methodsFor:'file templates'!

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

!stx_libscm_common class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '§Id::                                                                                                                        §'
! !


stx_libscm_common initialize!
