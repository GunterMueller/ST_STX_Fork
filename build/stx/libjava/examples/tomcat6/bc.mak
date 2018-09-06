# $Header: /cvs/stx/stx/libjava/examples/tomcat6/bc.mak,v 1.6 2015-03-20 12:08:03 vrany Exp $
#
# DO NOT EDIT 
# automagically generated from the projectDefinition: stx_libjava_examples_tomcat6.
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

TOP=..\..\..       
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
 -DSTARTUP_CLASS="\"ApacheTomcat6\"" \
 -DSTARTUP_SELECTOR="\"start\"" \
 -DUSE_MODULE_TABLE

#

!INCLUDE $(TOP)\rules\stdHeader_bc
!INCLUDE Make.spec

OBJS= $(COMMON_OBJS) $(WIN32_OBJS)



#
LIBNAME=dummy
STCOPT="+optinline"
LOCALINCLUDES= -I$(INCLUDE_TOP)\stx\libbasic
LOCALDEFINES=
GLOBALDEFINES=

STCLOCALOPT='-package=$(PACKAGE)' $(LOCALDEFINES) $(LOCALINCLUDES)  $(STCLOCALOPTIMIZATIONS) $(STCWARNINGS) $(LOCALDEFINES) $(COMMONSYMFLAG) -varPrefix=$(LIBNAME)

LFLAGS=$(APP_LFLAGS)

PROJECT_NOCONSOLE= tomcat6.exe
PROJECT_CONSOLE= tomcat6.com
ALLOBJFILES= main.$(O)
!ifdef USETCC
RESFILES=
!else
RESFILES= tomcat6WinRC.$(RES)
!endif

ALLOBJ= $(ALLOBJFILES) $(OBJS)
DEFFILE=$(TOP)\rules\bc_exe.def

LIBFILES=$(LIBDIR_LIBRUN)\librun.lib
ALLLIB=$(LIBFILES) $(APP_IMPORTLIBS) $(APP_RT_LIB)

REQUIRED_LIBS=librun.dll  \
 libstx_libbasic.dll \
 libstx_libbasic2.dll \
 libstx_libcomp.dll \
 libstx_libbasic3.dll \
 libstx_libview.dll \
 libstx_libui.dll \
 libstx_libview2.dll \
 libstx_goodies_sunit.dll \
 libstx_libwidg.dll \
 libstx_libhtml.dll \
 libstx_libwidg2.dll \
 libstx_libtool.dll \
 libstx_libjava.dll \


REQUIRED_FILES=$(RT_DLL) $(X11_DLL) $(XEXT_DLL) symbols.stc $(REQUIRED_LIBS)

REQUIRED_SUPPORT_DIRS=RESOURCEFILES

target: ALL postBuildCleanup 

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
		CFLAGS_APPTYPE=" -DWIN32GUI $(CFLAGS_NOCONSOLE) -DWIN_LOGFILE="\\"\"tomcat6.log\\"\""" \
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

RESOURCEFILES: tomcat6_RESOURCES tomcat6_BITMAPS  \
	stx_RESOURCES stx_STYLES stx_BITMAPS


tomcat6_RESOURCES: resources\stx\libjava\examples\tomcat6\NUL
	-copy ..\resources\*.rs resources\stx\libjava\examples\tomcat6\..
	-copy ..\resources\*.style resources\stx\libjava\examples\tomcat6\..

tomcat6_BITMAPS: resources\stx\libjava\examples\tomcat6\bitmaps\NUL
	-copy *.ico resources\stx\libjava\examples\tomcat6\bitmaps
	-copy *.gif resources\stx\libjava\examples\tomcat6\bitmaps

resources\stx\libjava\examples\tomcat6\bitmaps\NUL: resources\stx\libjava\examples\tomcat6\NUL
	mkdir resources\stx\libjava\examples\tomcat6\bitmaps

resources\stx\libjava\examples\tomcat6\NUL: resources\stx\libjava\examples\NUL
	mkdir resources\stx\libjava\examples\tomcat6

resources\stx\libjava\examples\NUL: resources\stx\libjava\NUL
	mkdir resources\stx\libjava\examples

resources\stx\libjava\NUL: resources\stx\NUL
	mkdir resources\stx\libjava



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






libstx_libbasic.dll: ..\..\..\libbasic\$(OBJDIR)\libstx_libbasic.dll
	copy ..\..\..\libbasic\$(OBJDIR)\libstx_libbasic.dll *.*

..\..\..\libbasic\$(OBJDIR)\libstx_libbasic.dll: $(FORCE)
	pushd ..\..\..\libbasic & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES)"

libstx_libbasic2.dll: ..\..\..\libbasic2\$(OBJDIR)\libstx_libbasic2.dll
	copy ..\..\..\libbasic2\$(OBJDIR)\libstx_libbasic2.dll *.*

..\..\..\libbasic2\$(OBJDIR)\libstx_libbasic2.dll: $(FORCE)
	pushd ..\..\..\libbasic2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES)"

libstx_libcomp.dll: ..\..\..\libcomp\$(OBJDIR)\libstx_libcomp.dll
	copy ..\..\..\libcomp\$(OBJDIR)\libstx_libcomp.dll *.*

..\..\..\libcomp\$(OBJDIR)\libstx_libcomp.dll: $(FORCE)
	pushd ..\..\..\libcomp & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES)"

libstx_libbasic3.dll: ..\..\..\libbasic3\$(OBJDIR)\libstx_libbasic3.dll
	copy ..\..\..\libbasic3\$(OBJDIR)\libstx_libbasic3.dll *.*

..\..\..\libbasic3\$(OBJDIR)\libstx_libbasic3.dll: $(FORCE)
	pushd ..\..\..\libbasic3 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES)"

libstx_libview.dll: ..\..\..\libview\$(OBJDIR)\libstx_libview.dll
	copy ..\..\..\libview\$(OBJDIR)\libstx_libview.dll *.*

..\..\..\libview\$(OBJDIR)\libstx_libview.dll: $(FORCE)
	pushd ..\..\..\libview & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES)"

libstx_libui.dll: ..\..\..\libui\$(OBJDIR)\libstx_libui.dll
	copy ..\..\..\libui\$(OBJDIR)\libstx_libui.dll *.*

..\..\..\libui\$(OBJDIR)\libstx_libui.dll: $(FORCE)
	pushd ..\..\..\libui & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES)"

libstx_libview2.dll: ..\..\..\libview2\$(OBJDIR)\libstx_libview2.dll
	copy ..\..\..\libview2\$(OBJDIR)\libstx_libview2.dll *.*

..\..\..\libview2\$(OBJDIR)\libstx_libview2.dll: $(FORCE)
	pushd ..\..\..\libview2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES)"

libstx_goodies_sunit.dll: ..\..\..\goodies\sunit\$(OBJDIR)\libstx_goodies_sunit.dll
	copy ..\..\..\goodies\sunit\$(OBJDIR)\libstx_goodies_sunit.dll *.*

..\..\..\goodies\sunit\$(OBJDIR)\libstx_goodies_sunit.dll: $(FORCE)
	pushd ..\..\..\goodies\sunit & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES)"

libstx_libwidg.dll: ..\..\..\libwidg\$(OBJDIR)\libstx_libwidg.dll
	copy ..\..\..\libwidg\$(OBJDIR)\libstx_libwidg.dll *.*

..\..\..\libwidg\$(OBJDIR)\libstx_libwidg.dll: $(FORCE)
	pushd ..\..\..\libwidg & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES)"

libstx_libhtml.dll: ..\..\..\libhtml\$(OBJDIR)\libstx_libhtml.dll
	copy ..\..\..\libhtml\$(OBJDIR)\libstx_libhtml.dll *.*

..\..\..\libhtml\$(OBJDIR)\libstx_libhtml.dll: $(FORCE)
	pushd ..\..\..\libhtml & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES)"

libstx_libwidg2.dll: ..\..\..\libwidg2\$(OBJDIR)\libstx_libwidg2.dll
	copy ..\..\..\libwidg2\$(OBJDIR)\libstx_libwidg2.dll *.*

..\..\..\libwidg2\$(OBJDIR)\libstx_libwidg2.dll: $(FORCE)
	pushd ..\..\..\libwidg2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES)"

libstx_libtool.dll: ..\..\..\libtool\$(OBJDIR)\libstx_libtool.dll
	copy ..\..\..\libtool\$(OBJDIR)\libstx_libtool.dll *.*

..\..\..\libtool\$(OBJDIR)\libstx_libtool.dll: $(FORCE)
	pushd ..\..\..\libtool & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES)"

libstx_libjava.dll: ..\..\$(OBJDIR)\libstx_libjava.dll
	copy ..\..\$(OBJDIR)\libstx_libjava.dll *.*

..\..\$(OBJDIR)\libstx_libjava.dll: $(FORCE)
	pushd ..\.. & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES)"

      


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
tomcat6Win.$(RES): tomcat6Win.rc tomcat6.ico

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



ant:
	ant -f apache-tomcat-6.0.35-src\build.xml





clean::
	-del genDate.exe genDate.com
	-del c0x32.dll
	-del c0x32.lib
	-del buildDate.h
	-del $(PROJECT)
	-del install_tomcat6.exe
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
$(OUTDIR)ApacheTomcat6.$(O) ApacheTomcat6.$(H): ApacheTomcat6.st $(INCLUDE_TOP)\stx\libbasic\StandaloneStartup.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)stx_libjava_examples_tomcat6.$(O) stx_libjava_examples_tomcat6.$(H): stx_libjava_examples_tomcat6.st $(INCLUDE_TOP)\stx\libbasic\ApplicationDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\ProjectDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)

# ENDMAKEDEPEND --- do not remove this line

# **Must be at end**

# Enforce recompilation of package definition class if Mercurial working
# copy state changes. Together with --guessVersion it ensures that package
# definition class always contains correct binary revision string.
!IFDEF HGROOT
$(OUTDIR)stx_libjava_examples_tomcat6.$(O): $(HGROOT)\.hg\dirstate
!ENDIF
