"{ Package: 'stx:libjava/examples/tomcat6' }"

ApplicationDefinition subclass:#stx_libjava_examples_tomcat6
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!


!stx_libjava_examples_tomcat6 class methodsFor:'description'!

excludedFromPreRequisites
    "list all packages which should be ignored in the automatic
     preRequisites scan. See #preRequisites for more."

    ^ #(
    )
!

isGUIApplication
    "return true, if this is a GUI application.
     (these need more libraries and use a different startup procedure)"

    ^ false
!

mandatoryPreRequisites
    "list all required mandatory packages.
     Packages are mandatory, if they contain superclasses of the package's classes
     or classes which are extended by this package.
     This list can be maintained manually or (better) generated and
     updated by scanning the superclass hierarchies
     (the browser has a menu function for that)"

    ^ #(
        #'stx:libbasic'    "ApplicationDefinition - superclass of stx_libjava_examples_tomcat6 "
    )
!

referencedPreRequisites
    "list all packages containing classes referenced by the packages's members.
     This list can be maintained manually or (better) generated and
     updated by looking for global variable accesses
     (the browser has a menu function for that)
     However, often too much is found, and you may want to explicitely
     exclude individual packages in the #excludedFromPreRequisites method."

    ^ #(
        #'stx:libjava'    "Java - referenced by ApacheTomcat6>>initializeVM "
    )
!

subProjects
    "list packages which are known as subprojects.
     This method is generated automatically; however, when generating automatically,
     packages are only added - never removed, unless listed in #excludedFromSubProjects."

    ^ #(
)
! !

!stx_libjava_examples_tomcat6 class methodsFor:'description - compilation'!

additionalRules_bc_dot_mak
    ^ '

ant:
        ant -f apache-tomcat-6.0.35-src\build.xml

'

    "Modified: / 23-11-2013 / 10:18:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

additionalRules_make_dot_proto
    ^ '

ant:
        ant -f apache-tomcat-6.0.35-src/build.xml


'

    "Modified: / 23-11-2013 / 10:18:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

additionalTargets_bc_dot_mak

    ^ 'ant'

    "Modified: / 11-01-2013 / 00:08:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

additionalTargets_make_dot_proto

    ^ 'ant'

    "Created: / 05-09-2006 / 16:05:12 / cg"
    "Modified: / 11-01-2013 / 00:08:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!stx_libjava_examples_tomcat6 class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        #'stx_libjava_examples_tomcat6'
        ApacheTomcat6
    )
!

extensionMethodNames
    "lists the extension methods which are to be included in the project.
     Entries are 2-element array literals, consisting of class-name and selector."

    ^ #(
    )
! !

!stx_libjava_examples_tomcat6 class methodsFor:'description - java'!

javaBundle
    | pkgdir sources bundle |

    pkgdir := Smalltalk getPackageDirectoryForPackage: self class package.
    pkgdir isNil ifTrue:[ ^ nil ].
    sources := pkgdir / 'apache-tomcat-6.0.35-src'.
    bundle := JavaCodeBundle new name: 'Apache Tomcat 6.0.35 (sources only)'.
    bundle 
        add: (JavaCodeLibrary new name: 'sources'; sources: (sources / 'java') pathName; yourself);
        add: (JavaCodeLibrary new name: 'sources - extras'; sources: (sources / 'java-extras') pathName; yourself).

    ^ JavaCodeBundle new 
        name: self class package;
        add: bundle;
        yourself





    "
        self javaBundle
    "

    "Created: / 15-01-2013 / 17:35:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-11-2013 / 22:27:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!stx_libjava_examples_tomcat6 class methodsFor:'description - project information'!

applicationIconFileName
    "Return the name (without suffix) of an icon-file (the app's icon); will be included in the rc-resource file"

    ^ nil
    "/ ^ self applicationName
!

companyName
    "Return a companyname which will appear in <lib>.rc"

    ^ 'Jan Vrany'

    "Modified: / 11-01-2013 / 00:10:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

description
    "Return a description string which will appear in vc.def / bc.def"

    ^ 'Apache Tomcat 6.x Controller'

    "Modified: / 11-01-2013 / 00:09:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

legalCopyright
    "Return a copyright string which will appear in <lib>.rc"

    ^ 'Copyright Jan Vrany  2013'

    "Modified: / 11-01-2013 / 00:09:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

productInstallDirBaseName
    "Returns a default installDir which will appear in <app>.nsi.
     This is usually not the one you want to keep"

    ^ (self package asCollectionOfSubstringsSeparatedByAny:':/') last
!

productName
    "Return a product name which will appear in <lib>.rc"

    ^ 'Apache Tomcat 6.x Controller'

    "Modified: / 11-01-2013 / 00:09:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!stx_libjava_examples_tomcat6 class methodsFor:'description - startup'!

startupClassName
    "the class that starts the show in its startupSelector method"

    ^ 'ApacheTomcat6'

    "Modified: / 10-01-2013 / 22:38:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

startupSelector
    "the message that is sent to the startupClass to start the show"

    ^ #'start'
! !

!stx_libjava_examples_tomcat6 class methodsFor:'file templates'!

bc_dot_mak
    "answer a template for the bc.mak makefile.
     Any variable definition %(Variable) will be later replaced by the mapping.
     $% characters have to be duplicated"

^ '# $','Header','$
#
# DO NOT EDIT 
# automagically generated from the projectDefinition: ',self name",' at ',Timestamp now printString",'.
#
# Warning: once you modify this file, do not rerun
# stmkmp or projectDefinition-build again - otherwise, your changes are lost.
#
# Historic Note:
#  this used to contain only rules to make with borland 
#    (called via bmake, by "make.exe -f bc.mak")
#  this has changed; it is now also possible to build using microsoft visual c
#    (called via vcmake, by "make.exe -f bc.mak -DUSEVC")
#

TOP=%(TOP)       
INCLUDE_TOP=$(TOP)\..

# An old file, used as a dummy target for FORCE if we do not want
#   re-make libraries. Windows make does not work if we redefine FORCE=   (empty string)
# OLD_FILE=bmake.bat
OLD_FILE="c:\windows\win.ini"

#dummy target to force a build
!!ifndef FORCE
FORCE=$(OLD_FILE)
!!endif

CFLAGS_LOCAL=$(CFLAGS_APPTYPE) \
 -DSTARTUP_CLASS="\"%(STARTUP_CLASS)\"" \
 -DSTARTUP_SELECTOR="\"%(STARTUP_SELECTOR)\"" \
 -DUSE_MODULE_TABLE

#

!!INCLUDE $(TOP)\rules\stdHeader_bc
!!INCLUDE Make.spec

OBJS= $(COMMON_OBJS) $(WIN32_OBJS)

%(ADDITIONAL_DEFINITIONS)

#
LIBNAME=dummy
STCOPT="+optinline"
LOCALINCLUDES=%(LOCAL_INCLUDES)
LOCALDEFINES=%(LOCAL_DEFINES)
GLOBALDEFINES=%(GLOBAL_DEFINES)

STCLOCALOPT=''-package=$(PACKAGE)'' $(LOCALDEFINES) $(LOCALINCLUDES) %(HEADEROUTPUTARG) $(STCLOCALOPTIMIZATIONS) $(STCWARNINGS) $(LOCALDEFINES) $(COMMONSYMFLAG) -varPrefix=$(LIBNAME)

LFLAGS=$(APP_LFLAGS)

PROJECT_NOCONSOLE= %(NOCONSOLE_APPLICATION)
PROJECT_CONSOLE= %(CONSOLE_APPLICATION)
ALLOBJFILES= main.$(O)
!!ifdef USETCC
RESFILES=
!!else
RESFILES= %(RESFILENAME)
!!endif

ALLOBJ= $(ALLOBJFILES) $(OBJS)
DEFFILE=$(TOP)\rules\bc_exe.def

LIBFILES=$(LIBDIR_LIBRUN)\librun.lib
ALLLIB=$(LIBFILES) $(APP_IMPORTLIBS) $(APP_RT_LIB)

REQUIRED_LIBS=librun.dll %(REQUIRED_LIBS)
REQUIRED_FILES=$(RT_DLL) $(X11_DLL) $(XEXT_DLL) symbols.stc $(REQUIRED_LIBS)

REQUIRED_SUPPORT_DIRS=%(REQUIRED_SUPPORT_DIRS)

target: %(BUILD_TARGET) postBuildCleanup 

# the executable, all required files and a self-installing-installer-exe
ALL:: prereq ALL_NP

# all, but no prereqs
ALL_NP:: exe $(REQUIRED_SUPPORT_DIRS) postBuildCleanup setup

exe:  newBuildDate $(REQUIRED_LIBS) noConsoleApp consoleApp

# the executable only
# with console
consoleApp: $(REQUIRED_LIBS)
        -del main.$(O)
        $(MAKE) -N -f bc.mak $(USE_ARG) \
                MAKE_BAT=$(MAKE_BAT) \
                PROJECT=$(PROJECT_CONSOLE) \
                CFLAGS_APPTYPE=" -DWIN32GUI $(CFLAGS_CONSOLE)" \
                LFLAGS_APPTYPE=" $(LFLAGS_CONSOLE)" \
                CRT_STARTUP=" $(CRT_STARTUP_CONSOLE)" theExe

# without console
noConsoleApp: $(REQUIRED_LIBS)
        -del main.$(O)
        $(MAKE) -N -f bc.mak $(USE_ARG) \
                MAKE_BAT=$(MAKE_BAT) \
                PROJECT=$(PROJECT_NOCONSOLE) \
                CFLAGS_APPTYPE=" -DWIN32GUI $(CFLAGS_NOCONSOLE) -DWIN_LOGFILE="\\"\"%(NOCONSOLE_LOGFILE)\\"\""" \
                LFLAGS_APPTYPE=" $(LFLAGS_NOCONSOLE)" \
                CRT_STARTUP=" $(CRT_STARTUP_NOCONSOLE)" theExe

# the executable only (internal target; needs some defines)
theExe: $(OUTDIR) $(OBJS) $(REQUIRED_FILES) show $(PROJECT) 

# build all mandatory prerequisite packages (containing superclasses) for this package
prereq:
        $(MAKE) -N -f bc.mak $(USE_ARG) FORCE=FORCE_BUILD $(REQUIRED_LIBS)

FORCE_BUILD:
        @rem Dummy target to force a build

# No setup...
setup:
    

newBuildDate:
        del buildDate.h

new:
        $(MAKE_BAT) clean
        $(MAKE_BAT)

RESOURCEFILES: %(APPLICATION)_RESOURCES %(APPLICATION)_BITMAPS %(ADDITIONAL_RESOURCE_TARGETS) \
        stx_RESOURCES stx_STYLES stx_BITMAPS

%(RESOURCE_RULES)
%(STX_RESOURCE_RULES)

%(APP_SOURCE_RULES)
%(STX_SOURCE_RULES)

%(PREREQUISITES_LIBS)      
%(SUBPROJECTS_LINES)

sources\NUL: 
        mkdir sources

show:
        @echo LFLAGS= $(LFLAGS)
        @echo ALLOBJ= $(ALLOBJ)
        @echo PROJECT= $(PROJECT)
        @echo APP_IMPORTLIBS= $(APP_IMPORTLIBS)
        @echo ALLLIB= $(ALLLIB)
        @echo DEFFILE= $(DEFFILE)
        @echo ALLRES= $(ALLRES)

!!ifdef USEBC

$(PROJECT_CONSOLE): $(ALLOBJFILES) $(OBJS) $(RESFILES) $(DEFFILE) $(LIBFILES)
        $(APP_LINKER) $(LFLAGS) $(LFLAGS_APPTYPE) $(CRT_STARTUP) $(ALLOBJ), $(PROJECT_CONSOLE),, $(ALLLIB), $(DEFFILE), $(RESFILES)

$(PROJECT_NOCONSOLE): $(ALLOBJFILES) $(OBJS) $(RESFILES) $(DEFFILE) $(LIBFILES)
        $(APP_LINKER) $(LFLAGS) $(LFLAGS_APPTYPE) $(CRT_STARTUP) $(ALLOBJ), $(PROJECT_NOCONSOLE),, $(ALLLIB), $(DEFFILE), $(RESFILES)

!!else
!! ifdef USEVC

$(PROJECT_CONSOLE): $(ALLOBJFILES) $(OBJS) $(RESFILES) $(DEFFILE) $(LIBFILES)
        $(APP_LINKER) $(LFLAGS) $(LFLAGS_APPTYPE) $(CRT_STARTUP) $(ALLOBJ) /OUT:"$(PROJECT_CONSOLE)" \
            /MANIFEST /MANIFESTFILE:"$(PROJECT_CONSOLE).manifest" \
            /PDB:"$(PROJECT_CONSOLE).pdb" \
            /SUBSYSTEM:CONSOLE $(ALLLIB) $(RESFILES)

$(PROJECT_NOCONSOLE): $(ALLOBJFILES) $(OBJS) $(RESFILES) $(DEFFILE) $(LIBFILES)
        $(APP_LINKER) $(LFLAGS) $(LFLAGS_APPTYPE) $(CRT_STARTUP) $(ALLOBJ) /OUT:"$(PROJECT_NOCONSOLE)" \
            /MANIFEST /MANIFESTFILE:"$(PROJECT_NOCONSOLE).manifest" \
            /PDB:"$(PROJECT_NOCONSOLE).pdb" \
            /SUBSYSTEM:WINDOWS $(ALLLIB) $(RESFILES)

!! else
!!  ifdef USELCC

$(PROJECT_CONSOLE): $(ALLOBJFILES) $(OBJS) $(RESFILES) $(DEFFILE) $(LIBFILES)
        $(APP_LINKER) -subsystem console $(LFLAGS) $(LFLAGS_APPTYPE) $(CRT_STARTUP) $(ALLOBJ) -o "$(PROJECT_CONSOLE)" $(ALLLIB) $(RESFILES)

$(PROJECT_NOCONSOLE): $(ALLOBJFILES) $(OBJS) $(RESFILES) $(DEFFILE) $(LIBFILES)
        $(APP_LINKER) -subsystem windows $(LFLAGS) $(LFLAGS_APPTYPE) $(CRT_STARTUP) $(ALLOBJ) -o "$(PROJECT_NOCONSOLE)" $(ALLLIB) $(RESFILES)

!!  else
!!   ifdef USETCC

$(PROJECT_CONSOLE): $(ALLOBJFILES) $(OBJS) $(RESFILES) $(DEFFILE) $(LIBFILES)
        $(APP_LINKER) $(LFLAGS) $(LFLAGS_APPTYPE) $(CRT_STARTUP) $(ALLOBJ) -o "$(PROJECT_CONSOLE)" $(ALLLIB) $(RESFILES)

$(PROJECT_NOCONSOLE): $(ALLOBJFILES) $(OBJS) $(RESFILES) $(DEFFILE) $(LIBFILES)
        $(APP_LINKER) $(LFLAGS) $(LFLAGS_APPTYPE) $(CRT_STARTUP) $(ALLOBJ) -o "$(PROJECT_NOCONSOLE)" $(ALLLIB) $(RESFILES)

!!   else
!!    if defined(USEMINGW32) || defined(USEMINGW64)

$(PROJECT_CONSOLE): $(ALLOBJFILES) $(OBJS) $(RESFILES) $(DEFFILE) $(LIBFILES) show
        $(APP_LINKER) $(LFLAGS) $(LFLAGS_APPTYPE) $(CRT_STARTUP) $(ALLOBJ) -o "$(PROJECT_CONSOLE)" $(ALLLIB) $(RESFILES)

$(PROJECT_NOCONSOLE): $(ALLOBJFILES) $(OBJS) $(RESFILES) $(DEFFILE) $(LIBFILES) show
        $(APP_LINKER) $(LFLAGS) $(LFLAGS_APPTYPE) $(CRT_STARTUP) $(ALLOBJ) -o "$(PROJECT_NOCONSOLE)" $(ALLLIB) $(APP_IMPORTLIBS) $(RESFILES)

!!    else
error error error
!!    endif
!!   endif
!!  endif
!! endif
!!endif

!!INCLUDE $(TOP)\rules\stdRules_bc

#
# additional rules
#
%(APPLICATION)Win.$(RES): %(APPLICATION)Win.rc %(APPLICATION).ico

main.$(O): buildDate.h main.c bc.mak

main.c: $(TOP)\librun\main.c
        copy $(TOP)\librun\main.c main.c

# now in stdRules.
#buildDate.h: $(GENDATE_UTILITIY)
#        $(GENDATE_UTILITIY)

librun.dll: $(TOP)\librun\$(OBJDIR_LIBRUN)\librun.dll
        copy $(TOP)\librun\$(OBJDIR_LIBRUN)\librun.dll librun.dll

#cs3245.dll
$(RT_DLL): $(TOP)\support\win32\borland\$(RT_DLL)
        copy $(TOP)\support\win32\borland\$(RT_DLL) $(RT_DLL)

X11.dll: $(TOP)\support\win32\X11.dll
        copy $(TOP)\support\win32\X11.dll X11.dll

Xext.dll: $(TOP)\support\win32\Xext.dll
        copy $(TOP)\support\win32\Xext.dll Xext.dll

symbols.stc: $(TOP)\include\symbols.stc
        copy $(TOP)\include\symbols.stc symbols.stc

%(ADDITIONAL_RULES)

%(ADDITIONAL_HEADERRULES)

clean::
        -del genDate.exe genDate.com
        -del c0x32.dll
        -del c0x32.lib
        -del buildDate.h
        -del $(PROJECT)
        -del install_%(APPLICATION).exe
        -del stx.lib
        -del stx.dll
        -del $(RT_DLL)
        -del $(REQUIRED_FILES)
        -del main.c
        -del *.log
        -del *.$(RES)
        -rmdir /S /Q resources
        -rmdir /S /Q $(OBJDIR)

clobber:: clean
        -del *.dll *.exe *.com

postBuildCleanup::
        @rem  stupid win-make does not allow empty

# BEGINMAKEDEPEND --- do not remove this line; make depend needs it
%(DEPENDENCIES)
# ENDMAKEDEPEND --- do not remove this line
%(ADDITIONAL_RULES_HG)'.

    "Created: / 23-11-2013 / 10:16:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

make_dot_proto

^
'# $','Header','$
#
# automagically generated from the projectDefinition: ',self name",' at ',Timestamp now printString",'.
#
# -------------- no need to change anything below ----------
#
# This makefile generates some standalone demo applications
#
#    make
#       generates %(APPLICATION)
#

TOP=%(TOP)
INCLUDE_TOP=$(TOP)/..

# set to a dummy file name (like FORCE=@@@FORCE-BUILD@@@) to force the build of prereq packages
FORCE=
.PHONY: $(FORCE)

PACKAGE=%(APPLICATION_PACKAGE)
SUBDIRS=
SUPPRESS_LOCAL_ABBREVS="yes"
NOAUTOLOAD=1
NOSUBAUTOLOAD=1

LOCALINCLUDES=%(LOCAL_INCLUDES)
LOCALDEFINES=%(LOCAL_DEFINES)
GLOBALDEFINES=%(GLOBAL_DEFINES)
MAIN_DEFINES=%(MAIN_DEFINES)

RCSSOURCES=Make.proto *.st
LINKSOURCES=Make.proto *.st

DELIVERBINARIES=

LIBNAME=%(LIBRARY_NAME)
STCLOCALOPT=''-package=$(PACKAGE)'' -I. -headerDir=. $(LOCALINCLUDES) $(STCLOCALOPTIMIZATIONS) $(STCWARNINGS) $(LOCALDEFINES) %(HEADEROUTPUTARG) %(COMMONSYMFLAG) -varPrefix=$(LIBNAME)


# ********** OPTIONAL: MODIFY the next line ***
# additional C-libraries that should be pre-linked with the class-objects
LD_OBJ_LIBS=%(ADDITIONAL_LINK_LIBRARIES)
LOCAL_SHARED_LIBS=%(ADDITIONAL_SHARED_LINK_LIBRARIES)


# ********** OPTIONAL: MODIFY the next line ***
# additional C targets or libraries should be added below
LOCAL_EXTRA_TARGETS=

OBJS= $(COMMON_OBJS) $(UNIX_OBJS)

%(ADDITIONAL_DEFINITIONS)

%(ADDITIONAL_DEFINITIONS_SVN)

LIBLIST = $(REQUIRED_LIBS)

# required libs:
#

REQUIRED_LIBS=%(REQUIRED_LIBS)
REQUIRED_LIBOBJS=%(REQUIRED_LIBOBJS)
REQUIRED_LINK_LIBOBJS=%(REQUIRED_LINK_LIBOBJS)
REQUIRED_SUPPORT_DIRS=%(REQUIRED_SUPPORT_DIRS)

SUBPROJECT_LIBS=%(SUBPROJECT_LIBS)

target: %(BUILD_TARGET)

all::   prereq ALL_NP

# like ALL, but not prereqs
ALL_NP:: exe $(SUBPROJECT_LIBS) $(REQUIRED_SUPPORT_DIRS) $(SETUP_RULE)

exe:    %(APPLICATION) 

%(APPLICATION): $(APP_DIRS_TO_MAKE) $(APP_LIBOBJS) $(REQUIRED_LIBOBJS) $(OBJS)
        $(MAKE) link_%(APPLICATION)


link_%(APPLICATION):
        $(MAKE) %(APPLICATION_TYPE) \
                    TARGET=%(APPLICATION) \
                    APPLICATION_CLASSES="$(COMMON_CLASSES) $(UNIX_CLASSES)" \
                    APPLICATION_OBJS="$(OBJS)" \
                    APPLICATION_LIBLIST="$(REQUIRED_LIBS)" \
                    APPLICATION_LIBOBJS="$(REQUIRED_LIBOBJS)" \
                    APPLICATION_LINK_LIBOBJS="$(REQUIRED_LINK_LIBOBJS)" \
                    STARTUP_CLASS="%(STARTUP_CLASS)" \
                    STARTUP_SELECTOR="%(STARTUP_SELECTOR)" \
                    MAIN_DEFINES="%(MAIN_DEFINES)"

# build all mandatory prerequisite packages (containing superclasses) for this package
prereq:
        $(MAKE) FORCE=@@@FORCE-BUILD@@@ $(REQUIRED_LIBOBJS)

#
# a self installable delivery
#
# backward compatible fallback
setup::

#        @if test -d autopackage; then \
#            makepackage; \
#        else \
#            echo "Error: make setup not yet available in this unix"; \
#            exit 1; \
#        fi

#
# for linux, this uses autopackage
#
setup_linux:

#        @if test -d autopackage; then \
#            makepackage; \
#        else \
#            echo "Error: missing autopackage directory"; \
#            exit 1; \
#        fi

#
# for mac, a dmg is generated
#
setup_macosx:   "%(PRODUCT_NAME)_dmg"
        hdiutil create -fs HFSX -layout SPUD "%(PRODUCT_NAME).dmg" -srcfolder "%(PRODUCT_NAME)_dmg" -format UDZO -volname "%(PRODUCT_NAME)" -quiet

"%(PRODUCT_NAME)_dmg":
%(DMG_IMAGE_SETUP)

SOURCEFILES: %(APPLICATION)_SOURCES \
        stx_SOURCES

%(SOURCE_RULES)
%(STX_SOURCE_RULES)

RESOURCEFILES: %(APPLICATION)_RESOURCES %(APPLICATION)_BITMAPS %(ADDITIONAL_RESOURCE_TARGETS) \
        stx_RESOURCES stx_STYLES stx_BITMAPS

%(RESOURCE_RULES)
%(STX_RESOURCE_RULES)

%(PREREQUISITES_LIBS)
%(SUBPROJECTS_LINES)

%(ADDITIONAL_RULES)

%(ADDITIONAL_RULES_SVN)

%(ADDITIONAL_RULES_HG)

%(ADDITIONAL_HEADERRULES)

clean::
        -rm -f *.so %(APPLICATION).$(O)

clobber:: clean
        -rm -f %(APPLICATION) *.img *.sav

# BEGINMAKEDEPEND --- do not remove this line; make depend needs it
%(DEPENDENCIES)
# ENDMAKEDEPEND --- do not remove this line
'

    "Created: / 23-11-2013 / 10:17:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!stx_libjava_examples_tomcat6 class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/examples/tomcat6/stx_libjava_examples_tomcat6.st,v 1.5 2015-03-20 12:08:03 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

