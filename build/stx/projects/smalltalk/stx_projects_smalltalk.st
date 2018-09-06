"
 COPYRIGHT (c) Claus Gittinger / 2006 by eXept Software AG
 COPYRIGHT (c) 2016 Jan Vrany <jan.vrany@fit.cvut.cz>
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:projects/smalltalk' }"

"{ NameSpace: Smalltalk }"

ApplicationDefinition subclass:#stx_projects_smalltalk
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!

!stx_projects_smalltalk class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) Claus Gittinger / 2006 by eXept Software AG
               2016-now by Jan Vrany <jan.vrany@fit.cvut.cz>
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
    Build- and package information for creation of the ST/X executable itself (with GUI).
    ST/X itself (i.e. the stx executable) is simply a standAlone application which includes
    all the common widgets and development tool libraries as prerequisites.
    So when started, these classes are already present.

    [Author:]
        Claus Gittinger

    [startWith:]
        Start the ST/X application from the command line:

            stx                 regular start; read snapshot image file if present
            stx -I              regular start; ignore any snapshot image (i.e. cold start)
            stx -I --quick      quick start; ignore snapshot and do not scan for autoloaded classes.

        Actually, startup is in 'Smalltalk >> start', so take a look at that method, for what is going on.
"
! !

!stx_projects_smalltalk class methodsFor:'description'!

applicationIconFileName
    ^ 'stx_32x32'
!

applicationName
    "History: we want the helper files to be named: smalltalk*.*"

    ^ 'smalltalk'
!

applicationNameConsole
    ^ 'stx.com'
!

applicationNameNoConsole
    ^ 'stx.exe'
!

buildTarget
    "redefined, so by default, the executable file is only built - not an installer.
     For the installer to be built, we must explicitly type 'bmake setup'"

     ^ 'exe'
!

documentExtensions
    ^ #()
"/    ^ #('st')
!

isConsoleApplication
    ^ true "actually, we do both the console and the non-console app (see additionalTargets_bc_dot_mak)"
!

isGUIApplication
    ^ true "actually, we do both the console and the non-console app (see additionalTargets_bc_dot_mak)"
!

mandatoryPreRequisites
    "list packages which are mandatory as a prerequisite.
     This are packages containing superclasses of my classes and classes which
     are extended by myself.
     They are mandatory, because we need these packages as a prerequisite for loading and compiling.
     This method is generated automatically,
     by searching along the inheritance chain of all of my classes."

    ^ #(
        #'stx:libbasic'    "ApplicationDefinition - superclass of stx_projects_smalltalk"
    )
!

preRequisites
    ^ #(
        #'stx:libbasic'    
        #'stx:libbasic2'
        #'stx:libbasic3'
        #'stx:libcomp'    
        #'stx:libhtml'
        #'stx:libtool'    
        #'stx:libtool2'
        #'stx:libui'
        #'stx:libview'
        #'stx:libview2'
        #'stx:libwidg'
        #'stx:libwidg2'
        #'stx:libwidg3'
        #'stx:goodies/refactoryBrowser/helpers'
        #'stx:goodies/refactoryBrowser/parser'
        #'stx:goodies/refactoryBrowser/refactoring'
        #'stx:goodies/refactoryBrowser/changes'
        #'stx:goodies/refactoryBrowser/browser'
        #'stx:goodies/refactoryBrowser/lint'
        #'stx:libboss'
        #'stx:libjavascript'
"/        #'stx:goodies/petitparser'
"/        #'stx:libjava'
"/        #'stx:libsvn'
    )

    "Modified: / 13-01-2012 / 13:03:52 / cg"
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
    )
!

splashFileName
    ^ 'stx_splash'
!

subProjects
    "list packages which are known as subprojects.
     This method is generated automatically; however, when generating automatically,
     packages are only added - never removed, unless listed in #excludedFromSubProjects."

    ^ #(
)
! !

!stx_projects_smalltalk class methodsFor:'description - building'!

additionalFilesToInstall
    "becomes part of the nsi list of files to install"

    ^ #(
        '"*.wsp"'
        '/x CVS "${STX_ROOT}\stx\projects\smalltalk\patches"'
        '/r /x CVS "${STX_ROOT}\stx\include"'
        '/x CVS "${STX_ROOT}\stx\libview\styles\*"'
        'SetOutPath "$INSTDIR\bin\doc"'
        '/r /x CVS "${STX_ROOT}\stx\doc\online"'
        'SetOutPath "$INSTDIR\bin\source"'
        '/r /x CVS /x "not*" "${STX_ROOT}\stx\*.st"'
       )

    "Created: / 01-03-2007 / 20:03:15 / cg"
!

iconFileName
    ^ 'stx_32x32.ico'
! !

!stx_projects_smalltalk class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        SmalltalkStartup
        #'stx_projects_smalltalk'
    )
!

extensionMethodNames
    "lists the extension methods which are to be included in the project.
     Entries are 2-element array literals, consisting of class-name and selector.
     A correponding method with real names must be present in my concrete subclasses
     if it has extensions."

    ^ #(
    )
!

protectedFileNames
    "names of files which should NOT be generated (because they are hand-maintained)"
    "do NOT overwrite the hand-written Make.proto for now"

    ^ #( 'Make.proto' 'modules.stx' )

    "Modified: / 21-12-2010 / 11:37:05 / cg"
! !

!stx_projects_smalltalk class methodsFor:'description - project information'!

companyName
    "Return a companyname which will appear in <lib>.rc"

    ^ 'Claus Gittinger / eXept Software AG'

    "Modified: / 18-11-2016 / 11:47:40 / cg"
!

description
    "Return a description string which will appear in nt.def / bc.def"

    ^ 'Smalltalk/X IDE'

    "Modified: / 10-02-2007 / 18:36:19 / cg"
!

legalCopyright
    "Return a copyright string which will appear in <lib>.rc"

    ^ 'Copyright Claus Gittinger 1988\nCopyright eXept Software AG 1998-2012'

    "Modified: / 18-11-2016 / 12:19:34 / cg"
!

productFilename
    ^ 'SmalltalkX'

    "Modified: / 01-03-2007 / 19:34:15 / cg"
! !

!stx_projects_smalltalk class methodsFor:'description - startup'!

startupClassName
    ^ #Smalltalk
!

startupSelector
    ^ #start
! !

!stx_projects_smalltalk class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG
    ^ '$Changeset: <not expanded> $'
! !

