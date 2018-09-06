# $Header$
#
# DO NOT EDIT 
# automagically generated from the projectDefinition: stx_projects_smalltalk.
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
# Rules found here:
#   bmake 
#       - build everything, incl. a self installing exe for deployment
#   bmake exe
#       - only build the executable; to be executed and tested here
#   bmake setup
#       - make the self installing exe (assuming that the exe is already present)
#   bmake clean
#       - remove everything that is not needed to execute
#   bmake clobber
#       - remove everything that cannot be reconstructed by bmake
#
# For a 64bit build, replace bmake by mingwmake.

TOP=..\..       
INCLUDE_TOP=$(TOP)\..

# An old file, used as a dummy target for FORCE if we do not want
#   re-make libraries. Windows make does not work if we redefine FORCE=   (empty string)
# OLD_FILE=bmake.bat
OLD_FILE="c:\windows\win.ini"

#dummy target to force a build
!ifndef FORCE
FORCE=$(OLD_FILE)
!endif

CFLAGS_LOCAL=$(CFLAGS_APPTYPE) \
 -DSTARTUP_CLASS="\"Smalltalk\"" \
 -DSTARTUP_SELECTOR="\"start\"" \
 -DUSE_MODULE_TABLE

#

!INCLUDE $(TOP)\rules\stdHeader_bc
!INCLUDE Make.spec

OBJS= $(COMMON_OBJS) $(WIN32_OBJS)



#
APPNAME=libstx_projects_smalltalk
LIBNAME=libstx_projects_smalltalk
MODULE_PATH=projects\smalltalk
STCOPT="+optinline"
LOCALINCLUDES= -I$(INCLUDE_TOP)\stx\libbasic
LOCALDEFINES=
GLOBALDEFINES=

STCLOCALOPT='-package=$(PACKAGE)' $(LOCALDEFINES) $(LOCALINCLUDES)  $(STCLOCALOPTIMIZATIONS) $(STCWARNINGS) $(LOCALDEFINES) $(COMMONSYMFLAG) -varPrefix=$(LIBNAME)

LFLAGS=$(APP_LFLAGS)

PROJECT_NOCONSOLE= stx.exe
PROJECT_CONSOLE= stx.com
ALLOBJFILES= main.$(O)
!ifdef USETCC
RESFILES=
!else
RESFILES= smalltalkWinRC.$(RES)
!endif

ALLOBJ= $(ALLOBJFILES) $(OBJS)
DEFFILE=$(TOP)\rules\bc_exe.def

LIBFILES=$(LIBDIR_LIBRUN)\librun.lib
ALLLIB=$(LIBFILES) $(APP_IMPORTLIBS) $(APP_RT_LIB)

!if defined(USEMINGW32)
RT_DLL=libgcc_s_dw2-1.dll
!endif

REQUIRED_LIBS=librun.dll  \
 libstx_libbasic.dll \
 libstx_libbasic2.dll \
 libstx_libcomp.dll \
 libstx_goodies_refactoryBrowser_parser.dll \
 libstx_libbasic3.dll \
 libstx_libview.dll \
 libstx_goodies_refactoryBrowser_helpers.dll \
 libstx_libboss.dll \
 libstx_libui.dll \
 libstx_goodies_refactoryBrowser_changes.dll \
 libstx_libview2.dll \
 libstx_goodies_sunit.dll \
 libstx_libwidg.dll \
 libstx_libhtml.dll \
 libstx_libwidg2.dll \
 libstx_libcompat.dll \
 libstx_libtool.dll \
 libstx_libwidg3.dll \
 libstx_goodies_refactoryBrowser_browser.dll \
 libstx_libjavascript.dll \
 libstx_libtool2.dll \
 libstx_goodies_refactoryBrowser_lint.dll \
 libstx_goodies_refactoryBrowser_refactoring.dll \


REQUIRED_FILES=$(RT_DLL) $(X11_DLL) $(XEXT_DLL) symbols.stc $(REQUIRED_LIBS)

REQUIRED_SUPPORT_DIRS=RESOURCEFILES

target: exe postBuildCleanup 

# the executable, all required files and a self-installing-installer-exe
ALL:: prereq ALL_NP

# all, but no prereqs
ALL_NP:: exe $(REQUIRED_SUPPORT_DIRS) postBuildCleanup setup

exe:  newBuildDate $(REQUIRED_LIBS) noConsoleApp consoleApp registerApplication

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
		CFLAGS_APPTYPE=" -DWIN32GUI $(CFLAGS_NOCONSOLE) -DWIN_LOGFILE="\\"\"smalltalk.log\\"\""" \
		LFLAGS_APPTYPE=" $(LFLAGS_NOCONSOLE)" \
		CRT_STARTUP=" $(CRT_STARTUP_NOCONSOLE)" theExe

# the executable only (internal target; needs some defines)
theExe: $(OUTDIR) $(OBJS) $(REQUIRED_FILES) show $(PROJECT) 

# build all mandatory prerequisite packages (containing superclasses) for this package
prereq:
	$(MAKE) -N -f bc.mak $(USE_ARG) FORCE=FORCE_BUILD $(REQUIRED_LIBS)

FORCE_BUILD:
	@rem Dummy target to force a build

# a nullsoft installable delivery
# This uses the Nullsoft Installer Package and works in Windows only

!if defined(USEMINGW64)

setup: $(PROJECT) postBuildCleanup smalltalk.nsi 
	$(MAKENSIS) /DOBJ_DIR=objmingw /DSETUP_NAME=Smalltalk/XSetup64 smalltalk.nsi
        

!else

setup: $(PROJECT) postBuildCleanup smalltalk.nsi
	$(MAKENSIS) /DOBJ_DIR=objbc /DSETUP_NAME=Smalltalk/XSetup smalltalk.nsi
        

!endif

newBuildDate:
	del buildDate.h

new:
	$(MAKE_BAT) clean
	$(MAKE_BAT)

RESOURCEFILES: smalltalk_RESOURCES smalltalk_BITMAPS  \
	stx_RESOURCES stx_STYLES stx_BITMAPS


smalltalk_RESOURCES: resources\stx\projects\smalltalk\NUL
	-copy ..\resources\*.rs resources\stx\projects\smalltalk\..
	-copy ..\resources\*.style resources\stx\projects\smalltalk\..

smalltalk_BITMAPS: resources\stx\projects\smalltalk\bitmaps\NUL
	-copy *.ico resources\stx\projects\smalltalk\bitmaps
	-copy *.gif resources\stx\projects\smalltalk\bitmaps

resources\stx\projects\smalltalk\bitmaps\NUL: resources\stx\projects\smalltalk\NUL
	mkdir resources\stx\projects\smalltalk\bitmaps

resources\stx\projects\smalltalk\NUL: resources\stx\projects\NUL
	mkdir resources\stx\projects\smalltalk

resources\stx\projects\NUL: resources\stx\NUL
	mkdir resources\stx\projects



stx_RESOURCES: \
	keyboard.rc \
	keyboardMacros.rc \
	host.rc \
	h_win32.rc \
	display.rc \
	d_win32.rc \
	libbasic_RESOURCES \
	libview_RESOURCES \
	libtool_RESOURCES  \
	libtool2_RESOURCES

keyboard.rc: $(TOP)\projects\smalltalk\keyboard.rc
	copy $(TOP)\projects\smalltalk\keyboard.rc *.*

keyboardMacros.rc: $(TOP)\projects\smalltalk\keyboardMacros.rc
	copy $(TOP)\projects\smalltalk\keyboardMacros.rc *.*

host.rc: $(TOP)\projects\smalltalk\host.rc
	copy $(TOP)\projects\smalltalk\host.rc *.*

h_win32.rc: $(TOP)\projects\smalltalk\h_win32.rc
	copy $(TOP)\projects\smalltalk\h_win32.rc *.*

display.rc: $(TOP)\projects\smalltalk\display.rc
	copy $(TOP)\projects\smalltalk\display.rc *.*

d_win32.rc: $(TOP)\projects\smalltalk\d_win32.rc
	copy $(TOP)\projects\smalltalk\d_win32.rc *.*

stx_STYLES: resources\stx\libview\NUL resources\stx\libview\styles\NUL
	-copy $(TOP)\libview\styles\*.style resources\stx\libview\styles\*.*
	-copy $(TOP)\libview\styles\*.common resources\stx\libview\styles\*.*

stx_BITMAPS: \
	libwidg_BITMAPS

libwidg_BITMAPS: resources\stx\libwidg\bitmaps\NUL
	-copy $(TOP)\libwidg\bitmaps\*.xpm resources\stx\libwidg\bitmaps\*.*

libbasic_RESOURCES: resources\stx\libbasic\NUL
	copy $(TOP)\libbasic\resources\*.rs resources\stx\libbasic\*.*

libtool_RESOURCES: resources\stx\libtool\NUL
	-copy $(TOP)\libtool\resources\*.rs resources\stx\libtool\*.*

libtool2_RESOURCES: resources\stx\libtool2\NUL
	-copy $(TOP)\libtool2\resources\*.rs resources\stx\libtool2\*.*

libview_RESOURCES: resources\stx\libview\NUL 
	-copy $(TOP)\libview\resources\*.rs resources\stx\libview\*.*

libview2_RESOURCES: resources\stx\libview2\NUL
	-copy $(TOP)\libview2\resources\*.rs resources\stx\libview2\*.*

resources\stx\libbasic\NUL: resources\stx\NUL
	mkdir resources\stx\libbasic

resources\stx\libtool\NUL: resources\stx\NUL
	mkdir resources\stx\libtool

resources\stx\libtool2\NUL: resources\stx\NUL
	mkdir resources\stx\libtool2

resources\stx\libview\NUL: resources\stx\NUL
	mkdir resources\stx\libview

resources\stx\libview\styles\NUL: resources\stx\libview\NUL
	mkdir resources\stx\libview\styles

resources\stx\libview2\NUL: resources\stx\NUL
	mkdir resources\stx\libview2

resources\stx\libwidg\bitmaps\NUL: resources\stx\libwidg\NUL
	mkdir resources\stx\libwidg\bitmaps

resources\stx\libwidg\NUL: resources\stx\NUL
	mkdir resources\stx\libwidg

resources\stx\NUL: resources\NUL
	mkdir resources\stx

resources\NUL:
	mkdir resources

bitmaps\NUL:
	mkdir bitmaps

doc\NUL:
	mkdir doc






libstx_libbasic.dll: ..\..\libbasic\$(OBJDIR)\libstx_libbasic.dll
	copy ..\..\libbasic\$(OBJDIR)\libstx_libbasic.dll *.*

..\..\libbasic\$(OBJDIR)\libstx_libbasic.dll: $(FORCE)
	pushd ..\..\libbasic & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "

libstx_libbasic2.dll: ..\..\libbasic2\$(OBJDIR)\libstx_libbasic2.dll
	copy ..\..\libbasic2\$(OBJDIR)\libstx_libbasic2.dll *.*

..\..\libbasic2\$(OBJDIR)\libstx_libbasic2.dll: $(FORCE)
	pushd ..\..\libbasic2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "

libstx_libcomp.dll: ..\..\libcomp\$(OBJDIR)\libstx_libcomp.dll
	copy ..\..\libcomp\$(OBJDIR)\libstx_libcomp.dll *.*

..\..\libcomp\$(OBJDIR)\libstx_libcomp.dll: $(FORCE)
	pushd ..\..\libcomp & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "

libstx_goodies_refactoryBrowser_parser.dll: ..\..\goodies\refactoryBrowser\parser\$(OBJDIR)\libstx_goodies_refactoryBrowser_parser.dll
	copy ..\..\goodies\refactoryBrowser\parser\$(OBJDIR)\libstx_goodies_refactoryBrowser_parser.dll *.*

..\..\goodies\refactoryBrowser\parser\$(OBJDIR)\libstx_goodies_refactoryBrowser_parser.dll: $(FORCE)
	pushd ..\..\goodies\refactoryBrowser\parser & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "

libstx_libbasic3.dll: ..\..\libbasic3\$(OBJDIR)\libstx_libbasic3.dll
	copy ..\..\libbasic3\$(OBJDIR)\libstx_libbasic3.dll *.*

..\..\libbasic3\$(OBJDIR)\libstx_libbasic3.dll: $(FORCE)
	pushd ..\..\libbasic3 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "

libstx_libview.dll: ..\..\libview\$(OBJDIR)\libstx_libview.dll
	copy ..\..\libview\$(OBJDIR)\libstx_libview.dll *.*

..\..\libview\$(OBJDIR)\libstx_libview.dll: $(FORCE)
	pushd ..\..\libview & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "

libstx_goodies_refactoryBrowser_helpers.dll: ..\..\goodies\refactoryBrowser\helpers\$(OBJDIR)\libstx_goodies_refactoryBrowser_helpers.dll
	copy ..\..\goodies\refactoryBrowser\helpers\$(OBJDIR)\libstx_goodies_refactoryBrowser_helpers.dll *.*

..\..\goodies\refactoryBrowser\helpers\$(OBJDIR)\libstx_goodies_refactoryBrowser_helpers.dll: $(FORCE)
	pushd ..\..\goodies\refactoryBrowser\helpers & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "

libstx_libboss.dll: ..\..\libboss\$(OBJDIR)\libstx_libboss.dll
	copy ..\..\libboss\$(OBJDIR)\libstx_libboss.dll *.*

..\..\libboss\$(OBJDIR)\libstx_libboss.dll: $(FORCE)
	pushd ..\..\libboss & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "

libstx_libui.dll: ..\..\libui\$(OBJDIR)\libstx_libui.dll
	copy ..\..\libui\$(OBJDIR)\libstx_libui.dll *.*

..\..\libui\$(OBJDIR)\libstx_libui.dll: $(FORCE)
	pushd ..\..\libui & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "

libstx_goodies_refactoryBrowser_changes.dll: ..\..\goodies\refactoryBrowser\changes\$(OBJDIR)\libstx_goodies_refactoryBrowser_changes.dll
	copy ..\..\goodies\refactoryBrowser\changes\$(OBJDIR)\libstx_goodies_refactoryBrowser_changes.dll *.*

..\..\goodies\refactoryBrowser\changes\$(OBJDIR)\libstx_goodies_refactoryBrowser_changes.dll: $(FORCE)
	pushd ..\..\goodies\refactoryBrowser\changes & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "

libstx_libview2.dll: ..\..\libview2\$(OBJDIR)\libstx_libview2.dll
	copy ..\..\libview2\$(OBJDIR)\libstx_libview2.dll *.*

..\..\libview2\$(OBJDIR)\libstx_libview2.dll: $(FORCE)
	pushd ..\..\libview2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "

libstx_goodies_sunit.dll: ..\..\goodies\sunit\$(OBJDIR)\libstx_goodies_sunit.dll
	copy ..\..\goodies\sunit\$(OBJDIR)\libstx_goodies_sunit.dll *.*

..\..\goodies\sunit\$(OBJDIR)\libstx_goodies_sunit.dll: $(FORCE)
	pushd ..\..\goodies\sunit & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "

libstx_libwidg.dll: ..\..\libwidg\$(OBJDIR)\libstx_libwidg.dll
	copy ..\..\libwidg\$(OBJDIR)\libstx_libwidg.dll *.*

..\..\libwidg\$(OBJDIR)\libstx_libwidg.dll: $(FORCE)
	pushd ..\..\libwidg & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "

libstx_libhtml.dll: ..\..\libhtml\$(OBJDIR)\libstx_libhtml.dll
	copy ..\..\libhtml\$(OBJDIR)\libstx_libhtml.dll *.*

..\..\libhtml\$(OBJDIR)\libstx_libhtml.dll: $(FORCE)
	pushd ..\..\libhtml & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "

libstx_libwidg2.dll: ..\..\libwidg2\$(OBJDIR)\libstx_libwidg2.dll
	copy ..\..\libwidg2\$(OBJDIR)\libstx_libwidg2.dll *.*

..\..\libwidg2\$(OBJDIR)\libstx_libwidg2.dll: $(FORCE)
	pushd ..\..\libwidg2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "

libstx_libcompat.dll: ..\..\libcompat\$(OBJDIR)\libstx_libcompat.dll
	copy ..\..\libcompat\$(OBJDIR)\libstx_libcompat.dll *.*

..\..\libcompat\$(OBJDIR)\libstx_libcompat.dll: $(FORCE)
	pushd ..\..\libcompat & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "

libstx_libtool.dll: ..\..\libtool\$(OBJDIR)\libstx_libtool.dll
	copy ..\..\libtool\$(OBJDIR)\libstx_libtool.dll *.*

..\..\libtool\$(OBJDIR)\libstx_libtool.dll: $(FORCE)
	pushd ..\..\libtool & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "

libstx_libwidg3.dll: ..\..\libwidg3\$(OBJDIR)\libstx_libwidg3.dll
	copy ..\..\libwidg3\$(OBJDIR)\libstx_libwidg3.dll *.*

..\..\libwidg3\$(OBJDIR)\libstx_libwidg3.dll: $(FORCE)
	pushd ..\..\libwidg3 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "

libstx_goodies_refactoryBrowser_browser.dll: ..\..\goodies\refactoryBrowser\browser\$(OBJDIR)\libstx_goodies_refactoryBrowser_browser.dll
	copy ..\..\goodies\refactoryBrowser\browser\$(OBJDIR)\libstx_goodies_refactoryBrowser_browser.dll *.*

..\..\goodies\refactoryBrowser\browser\$(OBJDIR)\libstx_goodies_refactoryBrowser_browser.dll: $(FORCE)
	pushd ..\..\goodies\refactoryBrowser\browser & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "

libstx_libjavascript.dll: ..\..\libjavascript\$(OBJDIR)\libstx_libjavascript.dll
	copy ..\..\libjavascript\$(OBJDIR)\libstx_libjavascript.dll *.*

..\..\libjavascript\$(OBJDIR)\libstx_libjavascript.dll: $(FORCE)
	pushd ..\..\libjavascript & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "

libstx_libtool2.dll: ..\..\libtool2\$(OBJDIR)\libstx_libtool2.dll
	copy ..\..\libtool2\$(OBJDIR)\libstx_libtool2.dll *.*

..\..\libtool2\$(OBJDIR)\libstx_libtool2.dll: $(FORCE)
	pushd ..\..\libtool2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "

libstx_goodies_refactoryBrowser_lint.dll: ..\..\goodies\refactoryBrowser\lint\$(OBJDIR)\libstx_goodies_refactoryBrowser_lint.dll
	copy ..\..\goodies\refactoryBrowser\lint\$(OBJDIR)\libstx_goodies_refactoryBrowser_lint.dll *.*

..\..\goodies\refactoryBrowser\lint\$(OBJDIR)\libstx_goodies_refactoryBrowser_lint.dll: $(FORCE)
	pushd ..\..\goodies\refactoryBrowser\lint & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "

libstx_goodies_refactoryBrowser_refactoring.dll: ..\..\goodies\refactoryBrowser\refactoring\$(OBJDIR)\libstx_goodies_refactoryBrowser_refactoring.dll
	copy ..\..\goodies\refactoryBrowser\refactoring\$(OBJDIR)\libstx_goodies_refactoryBrowser_refactoring.dll *.*

..\..\goodies\refactoryBrowser\refactoring\$(OBJDIR)\libstx_goodies_refactoryBrowser_refactoring.dll: $(FORCE)
	pushd ..\..\goodies\refactoryBrowser\refactoring & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "

      


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

!ifdef USEBC

$(PROJECT_CONSOLE): $(ALLOBJFILES) $(OBJS) $(RESFILES) $(DEFFILE) $(LIBFILES)
	$(APP_LINKER) $(LFLAGS) $(LFLAGS_APPTYPE) $(CRT_STARTUP) $(ALLOBJ), $(PROJECT_CONSOLE),, $(ALLLIB), $(DEFFILE), $(RESFILES)

$(PROJECT_NOCONSOLE): $(ALLOBJFILES) $(OBJS) $(RESFILES) $(DEFFILE) $(LIBFILES)
	$(APP_LINKER) $(LFLAGS) $(LFLAGS_APPTYPE) $(CRT_STARTUP) $(ALLOBJ), $(PROJECT_NOCONSOLE),, $(ALLLIB), $(DEFFILE), $(RESFILES)

!else
! ifdef USEVC

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

! else
!  ifdef USELCC

$(PROJECT_CONSOLE): $(ALLOBJFILES) $(OBJS) $(RESFILES) $(DEFFILE) $(LIBFILES)
	$(APP_LINKER) -subsystem console $(LFLAGS) $(LFLAGS_APPTYPE) $(CRT_STARTUP) $(ALLOBJ) -o "$(PROJECT_CONSOLE)" $(ALLLIB) $(RESFILES)

$(PROJECT_NOCONSOLE): $(ALLOBJFILES) $(OBJS) $(RESFILES) $(DEFFILE) $(LIBFILES)
	$(APP_LINKER) -subsystem windows $(LFLAGS) $(LFLAGS_APPTYPE) $(CRT_STARTUP) $(ALLOBJ) -o "$(PROJECT_NOCONSOLE)" $(ALLLIB) $(RESFILES)

!  else
!   ifdef USETCC

$(PROJECT_CONSOLE): $(ALLOBJFILES) $(OBJS) $(RESFILES) $(DEFFILE) $(LIBFILES)
	$(APP_LINKER) $(LFLAGS) $(LFLAGS_APPTYPE) $(CRT_STARTUP) $(ALLOBJ) -o "$(PROJECT_CONSOLE)" $(ALLLIB) $(RESFILES)

$(PROJECT_NOCONSOLE): $(ALLOBJFILES) $(OBJS) $(RESFILES) $(DEFFILE) $(LIBFILES)
	$(APP_LINKER) $(LFLAGS) $(LFLAGS_APPTYPE) $(CRT_STARTUP) $(ALLOBJ) -o "$(PROJECT_NOCONSOLE)" $(ALLLIB) $(RESFILES)

!   else
!    if defined(USEMINGW32) || defined(USEMINGW64)

$(PROJECT_CONSOLE): $(ALLOBJFILES) $(OBJS) $(RESFILES) $(DEFFILE) $(LIBFILES) show
	$(APP_LINKER) $(LFLAGS) $(LFLAGS_APPTYPE) $(CRT_STARTUP) $(ALLOBJ) -o "$(PROJECT_CONSOLE)" $(ALLLIB) $(RESFILES)

$(PROJECT_NOCONSOLE): $(ALLOBJFILES) $(OBJS) $(RESFILES) $(DEFFILE) $(LIBFILES) show
	$(APP_LINKER) $(LFLAGS) $(LFLAGS_APPTYPE) $(CRT_STARTUP) $(ALLOBJ) -o "$(PROJECT_NOCONSOLE)" $(ALLLIB) $(APP_IMPORTLIBS) $(RESFILES)

!    else
error error error
!    endif
!   endif
!  endif
! endif
!endif

!INCLUDE $(TOP)\rules\stdRules_bc

#
# additional rules
#
smalltalkWin.$(RES): smalltalkWin.rc smalltalk.ico

main.$(O): buildDate.h main.c bc.mak

main.c: $(TOP)\librun\main.c
	copy $(TOP)\librun\main.c main.c

# now in stdRules.
#buildDate.h: $(GENDATE_UTILITIY)
#        $(GENDATE_UTILITIY)

librun.dll: $(TOP)\librun\$(OBJDIR_LIBRUN)\librun.dll
	copy $(TOP)\librun\$(OBJDIR_LIBRUN)\librun.dll librun.dll

!ifdef USEBC      
#cs3245.dll
$(RT_DLL): $(TOP)\support\win32\borland\$(RT_DLL)
	copy $(TOP)\support\win32\borland\$(RT_DLL) $(RT_DLL)

X11.dll: $(TOP)\support\win32\X11.dll
	copy $(TOP)\support\win32\X11.dll X11.dll

Xext.dll: $(TOP)\support\win32\Xext.dll
	copy $(TOP)\support\win32\Xext.dll Xext.dll
!endif

!if defined(USEMINGW32)
$(RT_DLL): $(MINGW_DIR)\bin\$(RT_DLL)
	-copy $(MINGW_DIR)\bin\$(RT_DLL) $(RT_DLL)
	-copy $(MINGW_DIR)\bin\libwinpthread-1.dll libwinpthread-1.dll
!endif

symbols.stc: $(TOP)\include\symbols.stc
	copy $(TOP)\include\symbols.stc symbols.stc





clean::
	-del genDate.exe genDate.com
	-del c0x32.dll
	-del c0x32.lib
	-del buildDate.h
	-del $(PROJECT)
	-del install_smalltalk.exe
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
$(OUTDIR)SmalltalkStartup.$(O) SmalltalkStartup.$(C) SmalltalkStartup.$(H): SmalltalkStartup.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\StandaloneStartup.$(H) $(STCHDR)
$(OUTDIR)stx_projects_smalltalk.$(O) stx_projects_smalltalk.$(C) stx_projects_smalltalk.$(H): stx_projects_smalltalk.st $(INCLUDE_TOP)\stx\libbasic\ApplicationDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\ProjectDefinition.$(H) $(STCHDR)

# ENDMAKEDEPEND --- do not remove this line

# **Must be at end**

# Enforce recompilation of package definition class if Mercurial working
# copy state changes. Together with --guessVersion it ensures that package
# definition class always contains correct binary revision string.
!IFDEF HGROOT
$(OUTDIR)stx_projects_smalltalk.$(O): $(HGROOT)\.hg\dirstate
!ENDIF
