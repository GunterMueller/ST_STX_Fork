"
 COPYRIGHT (c) Claus Gittinger / eXept Software AG
 COPYRIGHT (c) 2015-2016 Jan Vrany
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

LibraryDefinition subclass:#stx_libbasic3
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!

!stx_libbasic3 class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) Claus Gittinger / eXept Software AG
 COPYRIGHT (c) 2015-2016 Jan Vrany
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
    Package documentation:

    This library contains source-code-management, packaging, change and history related stuff.
    It is normally not required in end-user stand alone applications.

    [author:]
        cg

    [primary maintainer:]
        cg
"
! !

!stx_libbasic3 class methodsFor:'description'!

excludedFromPreRequisites
    ^ #(
        #'stx:goodies/refactoryBrowser/parser'    "ParseTreeSearcher - referenced by HTMLDocGenerator>>methodCommentOf: "
        #'stx:goodies/refactoryBrowser/lint'   
        #'stx:goodies/refactoryBrowser/browser'
        #'stx:goodies/webServer'    "HTTPRequest - referenced by HTMLDocGenerator>>generateClassDocReferenceFor:text:autoloading: "
        #'stx:goodies/xml/vw'    "XML::SourceScannerNodeBuilder - referenced by ChangeSet class>>fromXMLStream: "
        #'stx:libcomp'    "Parser - referenced by MessageTracer class>>wrapClass:selector:onEntry:onExit: "
        #'stx:libcompat'    "SystemWindow - referenced by MethodFinder class>>methodFor: "
        #'stx:libdb'    "SQL::SQLError - referenced by StoreSourceCodeManager class>>connectToDatabase "
        #'stx:libtool'    "Diff3TextView - referenced by CVSSourceCodeManager class>>checkin:text:directory:module:logMessage:force: "
        #'stx:libview'    "Color - referenced by CVSSourceCodeManager class>>checkin:text:directory:module:logMessage:force: "
        #'stx:libview2'    "ValueHolder - referenced by MessageTracer class>>trapModificationsIn:selectors:filter: "
        #'stx:libwidg'    "DialogBox - referenced by SourceCodeManagerUtilities class>>askForExistingRevision:title:class:manager:module:package:fileName: "
        #'stx:libwidg2'    "CheckBox - referenced by SourceCodeManagerUtilities class>>checkAndWarnAboutBadMessagesInClass:checkAgainHolder: "
        #'stx:libdb/libodbc'    "SQL::ODBCSession - referenced by StoreSourceCodeManager class>>tryToConnectToDatabase: "
        #'stx:libdb/libsqlite'    "SQLiteConnection - referenced by DataBaseSourceCodeManager class>>openSQLite: "
    )

    "Modified: / 29-05-2014 / 17:00:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

mandatoryPreRequisites
    "list packages which are mandatory as a prerequisite.
     This are packages containing superclasses of my classes and classes which
     are extended by myself.
     They are mandatory, because we need these packages as a prerequisite for loading and compiling.
     This method is generated automatically,
     by searching along the inheritance chain of all of my classes."

    ^ #(
        #'stx:libbasic'    "AbstractSourceFileWriter - superclass of BeeSourceWriter"
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
        #'stx:libbasic2'    "HTMLUtilities - referenced by HTMLDocGenerator>>generateClassDocReferenceFor:text:autoloading:"
    )

    "Modified: / 31-05-2016 / 23:19:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

subProjects
    "list packages which are known as subprojects. 
     The generated makefile will enter those and make there as well.
     However: they are not forced to be loaded when a package is loaded; 
     for those, redefine requiredPrerequisites."

    ^ #(
    )
! !

!stx_libbasic3 class methodsFor:'description - compilation'!

additionalBaseAddressDefinition_bc_dot_mak
    "this is an optional definition, which (if present) may speed up the dll-loading a little
     on win32 systems."

    ^ '
# see stdHeader_bc for LIBBASIC3_BASE
LIB_BASE=$(LIBBASIC3_BASE)
'
!

additionalRules_bc_dot_mak
    "allows for additional static libraries to be added to the bc.mak file.
     Subclasses may redefine this"

    ^ '
stx_libbasic3-config.h: stx_libbasic3-config.bat
        call stx_libbasic3-config.bat

clean::
        del stx_libbasic3-config.h

'

    "Created: / 11-11-2012 / 12:22:21 / jv"
    "Modified: / 31-05-2016 / 23:18:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

additionalRules_make_dot_proto
    "allows for additional rules to be added to the make.proto file."

    ^ '
stx_libbasic3-config.h: stx_libbasic3-config.sh
        ./stx_libbasic3-config.sh

clean::
        rm -f stx_libbasic3-config.h

'

    "Created: / 01-11-2012 / 22:35:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 31-05-2016 / 23:18:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

additionalTargets_bc_dot_mak
    "obsolete - kept for compatibility with old project files"

   ^ 'stx_libbasic3-config.h'

    "Created: / 09-11-2012 / 12:14:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 31-05-2016 / 22:59:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

additionalTargets_make_dot_proto
    "allows for additional targets to be added to the make.proto file."

    ^ 'stx_libbasic3-config.h'

    "Created: / 01-11-2012 / 22:35:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 31-05-2016 / 22:59:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

stcWarningOptions
    ^ '-warnNonStandard -warnUnused'
! !

!stx_libbasic3 class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        AbstractSourceCodeManager
        BeeProjectWriter
        BeeSourceWriter
        CallChain
        Change
        ChangeDeltaInformation
        ChangeNotificationParameter
        ChangeSet
        ChangeSetDiff
        ChangeSetDiffComponent
        ClassOrganizer
        HTMLDocGenerator
        HistoryManager
        MessageTally
        MessageTracer
        MethodFinder
        ProfileTree
        ProjectChecker
        ProjectProblem
        SourceCodeCache
        SourceCodeManagerError
        SourceCodeManagerUtilities
        SystemEnvironment
        SystemOrganizer
        SystemProfiler
        TraceBuffer
        VersionInfo
        WrappedMethod
        #'stx_libbasic3'
        BeeProjectDefinitionWriter
        BeeProjectSourceWriter
        CVSSourceCodeManager
        ChangeSetDiffEntry
        ChangeSetDiffSet
        ClassChange
        CompositeChange
        DataBaseSourceCodeManager
        DataBaseSourceCodeManagerUtilities
        DoItChange
        FileBasedSourceCodeManager
        FileInChange
        GitSourceCodeManager
        InvalidChange
        MercurialSourceCodeManager
        MethodChangeNotificationParameter
        NameSpaceCreationChange
        OtherChange
        PerforceSourceCodeManager
        SourceCodeManagerUtilitiesForContainerBasedManagers
        SourceCodeManagerUtilitiesForWorkspaceBasedManagers
        StoreSourceCodeManager
        ClassCategoryChange
        ClassClassVariableChange
        ClassCommentChange
        ClassDefinitionChange
        ClassInitializeChange
        ClassInstVarDefinitionChange
        ClassOtherChange
        ClassPrimitiveChange
        ClassRemoveChange
        ClassRenameChange
        InfoChange
        MethodCategoryChangeNotificationParameter
        MethodCategoryRenameChange
        MethodChange
        MethodRemoveChangeNotificationParameter
        MethodTrapChangeNotificationParameter
        TimestampChange
        ClassPrimitiveDefinitionsChange
        ClassPrimitiveFunctionsChange
        ClassPrimitiveVariablesChange
        MethodCategoryChange
        MethodDefinitionChange
        MethodPackageChange
        MethodPrivacyChange
        MethodRemoveChange
        (TraitClassTraitDefinitionChange autoload)
        (TraitDefinitionChange autoload)
        (VSEFileSourceWriter autoload)
        (VSEChunkFileSourceWriter autoload)
        (VSEPackageFileSourceWriter autoload)
        (VisualAgeChunkFileSourceWriter autoload)
    )

    "Modified: / 31-05-2016 / 23:19:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

extensionMethodNames
    "lists the extension methods which are to be included in the project.
     Entries are 2-element array literals, consisting of class-name and selector.
     A correponding method with real names must be present in my concrete subclasses
     if it has extensions."

    ^ #(
        UserPreferences historyManagerModificationLimit
        UserPreferences historyManagerModificationLimit:
        UserPreferences historyManagerSignature
        UserPreferences historyManagerSignature:
        UserPreferences historyManagerSignatures
        UserPreferences historyManagerSignatures:
        UserPreferences historyManagerAllowEditOfHistory
        UserPreferences managerPerMatchingModuleDefinitions
        UserPreferences managerPerMatchingModuleDefinitions:
        'ConfigurableFeatures class' hasProjectChecker
        CompiledCode setTracelog
        ExecutableFunction isMocked
    )
! !

!stx_libbasic3 class methodsFor:'description - project information'!

companyName
    "Return a companyname which will appear in <lib>.rc"

    ^ 'Claus Gittinger / eXept Software AG'

    "Modified: / 18-11-2016 / 11:48:34 / cg"
!

description
    "Return a description string which will appear in nt.def / bc.def"

    ^ 'Smalltalk/X Additional Developer Basic Classes'

    "Modified: / 14-09-2006 / 10:57:32 / cg"
!

legalCopyright
    "Return a copyright string which will appear in <lib>.rc"

    ^ 'Copyright Claus Gittinger 1988\nCopyright eXept Software AG 2012'

    "Modified: / 18-11-2016 / 12:17:42 / cg"
!

productName
    "Return a product name which will appear in <lib>.rc"

    ^ 'Smalltalk/X'
! !

!stx_libbasic3 class methodsFor:'description - svn'!

svnRepositoryUrlString
    "Return a SVN repository URL of myself.
     (Generated since 2011-04-08)
     Do not make the string shorter!!!!!! We have to use fixed-length keyword!!!!!!
    "        

    ^ '$URL:: https://vranyj1@swing.fit.cvut.cz/svn/stx/libbasic3/branches/jv/stx_libbasic3.st                                       $'
!

svnRevisionNr
    "Return a SVN revision number of myself.
     This number is updated after a commit"

    ^ "$SVN-Revision:"'Nicht versioniertes Verzeichnis'"$"
! !

!stx_libbasic3 class methodsFor:'documentation'!

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

