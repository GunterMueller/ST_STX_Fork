# $Header: /cvs/stx/stx/goodies/demos/jh/math/fractalApplication/bc.mak,v 1.2 2013-05-28 10:29:09 cg Exp $
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_goodies_demos_jh_math_fractalApplication.
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

TOP=..\..\..\..\..
INCLUDE_TOP=$(TOP)\..

CFLAGS_LOCAL=$(CFLAGS_APPTYPE) \
 -DSTARTUP_CLASS="\"<name of class here>\"" \
 -DSTARTUP_SELECTOR="\"start\"" \
 -DUSE_MODULE_TABLE

#

!INCLUDE $(TOP)\rules\stdHeader_bc
!INCLUDE Make.spec

OBJS= $(COMMON_OBJS) $(WIN32_OBJS)



#
LIBNAME=dummy
STCOPT="+optinline"
LOCALINCLUDES= -I$(INCLUDE_TOP)\stx\libview -I$(INCLUDE_TOP)\stx\libui -I$(INCLUDE_TOP)\stx\libview2 -I$(INCLUDE_TOP)\stx\libwidg -I$(INCLUDE_TOP)\stx\libbasic2 -I$(INCLUDE_TOP)\stx\libwidg2 -I$(INCLUDE_TOP)\stx\libbasic -I$(INCLUDE_TOP)\stx\libcomp -I$(INCLUDE_TOP)\stx\libhtml
LOCALDEFINES=
GLOBALDEFINES=

STCLOCALOPT='-package=$(PACKAGE)' $(LOCALDEFINES) $(LOCALINCLUDES)  $(STCLOCALOPTIMIZATIONS) $(STCWARNINGS) $(LOCALDEFINES) $(COMMONSYMFLAG) -varPrefix=$(LIBNAME)

LFLAGS=$(APP_LFLAGS)

PROJECT_NOCONSOLE= fractalApplication.exe
PROJECT_CONSOLE= fractalApplication.com
ALLOBJFILES= main.$(O)
!ifdef USETCC
RESFILES=
!else
RESFILES= fractalApplicationWinRC.$(RES)
!endif

ALLOBJ= $(ALLOBJFILES) $(OBJS)
DEFFILE=$(TOP)\rules\bc_exe.def

LIBFILES=$(LIBDIR_LIBRUN)\librun.lib
ALLLIB=$(LIBFILES) $(APP_IMPORTLIBS) $(APP_RT_LIB)

REQUIRED_LIBS=librun.dll  \
 libstx_libbasic.dll \
 libstx_libbasic2.dll \
 libstx_libcomp.dll \
 libstx_libview.dll \
 libstx_libview2.dll \
 libstx_libui.dll \
 libstx_libwidg.dll \
 libstx_libwidg2.dll \
 libstx_libhtml.dll \


REQUIRED_FILES=cs3245.dll X11.dll Xext.dll symbols.stc $(REQUIRED_LIBS)

REQUIRED_SUPPORT_DIRS=RESOURCEFILES

target: ALL postBuildCleanup

# the executable, all required files and a self-installing-installer-exe
ALL:: prereq exe postBuildCleanup setup

exe:  newBuildDate noConsoleApp  $(REQUIRED_SUPPORT_DIRS)

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
		CFLAGS_APPTYPE=" -DWIN32GUI $(CFLAGS_NOCONSOLE) -DWIN_LOGFILE="\\"\"fractalApplication.log\\"\""" \
		LFLAGS_APPTYPE=" $(LFLAGS_NOCONSOLE)" \
		CRT_STARTUP=" $(CRT_STARTUP_NOCONSOLE)" theExe

# the executable only (internal target; needs some defines)
theExe: $(OUTDIR) $(OBJS) $(REQUIRED_FILES) show $(PROJECT)

# build all prerequisite packages for this package
prereq:
	pushd ..\..\..\..\..\libbasic & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\..\..\libbasic2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\..\..\libcomp & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\..\..\libview & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\..\..\libview2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\..\..\libui & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\..\..\libwidg & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\..\..\libwidg2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\..\..\libhtml & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\..\..\librun & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "


# a nullsoft installable delivery
# This uses the Nullsoft Installer Package and works in Windows only
setup: $(PROJECT) postBuildCleanup fractalApplication.nsi
	$(MAKENSIS) fractalApplication.nsi

newBuildDate:
	del buildDate.h

new:
	$(MAKE_BAT) clean
	$(MAKE_BAT)

RESOURCEFILES: fractalApplication_RESOURCES fractalApplication_BITMAPS  \
	stx_RESOURCES stx_STYLES stx_BITMAPS


fractalApplication_RESOURCES: resources\stx\goodies\demos\jh\math\fractalApplication\NUL
	-copy ..\resources\*.rs resources\stx\goodies\demos\jh\math\fractalApplication\..
	-copy ..\resources\*.style resources\stx\goodies\demos\jh\math\fractalApplication\..

fractalApplication_BITMAPS: resources\stx\goodies\demos\jh\math\fractalApplication\bitmaps\NUL
	-copy *.ico resources\stx\goodies\demos\jh\math\fractalApplication\bitmaps
	-copy *.gif resources\stx\goodies\demos\jh\math\fractalApplication\bitmaps

resources\stx\goodies\demos\jh\math\fractalApplication\bitmaps\NUL: resources\stx\goodies\demos\jh\math\fractalApplication\NUL
	mkdir resources\stx\goodies\demos\jh\math\fractalApplication\bitmaps

resources\stx\goodies\demos\jh\math\fractalApplication\NUL: resources\stx\goodies\demos\jh\math\NUL
	mkdir resources\stx\goodies\demos\jh\math\fractalApplication

resources\stx\goodies\demos\jh\math\NUL: resources\stx\goodies\demos\jh\NUL
	mkdir resources\stx\goodies\demos\jh\math

resources\stx\goodies\demos\jh\NUL: resources\stx\goodies\demos\NUL
	mkdir resources\stx\goodies\demos\jh

resources\stx\goodies\demos\NUL: resources\stx\goodies\NUL
	mkdir resources\stx\goodies\demos

resources\stx\goodies\NUL: resources\stx\NUL
	mkdir resources\stx\goodies



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






libstx_libbasic.dll: ..\..\..\..\..\libbasic\$(OBJDIR)\libstx_libbasic.dll
	copy ..\..\..\..\..\libbasic\$(OBJDIR)\libstx_libbasic.dll *.*

..\..\..\..\..\libbasic\$(OBJDIR)\libstx_libbasic.dll:
	pushd ..\..\..\..\..\libbasic & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES)"

libstx_libbasic2.dll: ..\..\..\..\..\libbasic2\$(OBJDIR)\libstx_libbasic2.dll
	copy ..\..\..\..\..\libbasic2\$(OBJDIR)\libstx_libbasic2.dll *.*

..\..\..\..\..\libbasic2\$(OBJDIR)\libstx_libbasic2.dll:
	pushd ..\..\..\..\..\libbasic2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES)"

libstx_libcomp.dll: ..\..\..\..\..\libcomp\$(OBJDIR)\libstx_libcomp.dll
	copy ..\..\..\..\..\libcomp\$(OBJDIR)\libstx_libcomp.dll *.*

..\..\..\..\..\libcomp\$(OBJDIR)\libstx_libcomp.dll:
	pushd ..\..\..\..\..\libcomp & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES)"

libstx_libview.dll: ..\..\..\..\..\libview\$(OBJDIR)\libstx_libview.dll
	copy ..\..\..\..\..\libview\$(OBJDIR)\libstx_libview.dll *.*

..\..\..\..\..\libview\$(OBJDIR)\libstx_libview.dll:
	pushd ..\..\..\..\..\libview & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES)"

libstx_libview2.dll: ..\..\..\..\..\libview2\$(OBJDIR)\libstx_libview2.dll
	copy ..\..\..\..\..\libview2\$(OBJDIR)\libstx_libview2.dll *.*

..\..\..\..\..\libview2\$(OBJDIR)\libstx_libview2.dll:
	pushd ..\..\..\..\..\libview2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES)"

libstx_libui.dll: ..\..\..\..\..\libui\$(OBJDIR)\libstx_libui.dll
	copy ..\..\..\..\..\libui\$(OBJDIR)\libstx_libui.dll *.*

..\..\..\..\..\libui\$(OBJDIR)\libstx_libui.dll:
	pushd ..\..\..\..\..\libui & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES)"

libstx_libwidg.dll: ..\..\..\..\..\libwidg\$(OBJDIR)\libstx_libwidg.dll
	copy ..\..\..\..\..\libwidg\$(OBJDIR)\libstx_libwidg.dll *.*

..\..\..\..\..\libwidg\$(OBJDIR)\libstx_libwidg.dll:
	pushd ..\..\..\..\..\libwidg & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES)"

libstx_libwidg2.dll: ..\..\..\..\..\libwidg2\$(OBJDIR)\libstx_libwidg2.dll
	copy ..\..\..\..\..\libwidg2\$(OBJDIR)\libstx_libwidg2.dll *.*

..\..\..\..\..\libwidg2\$(OBJDIR)\libstx_libwidg2.dll:
	pushd ..\..\..\..\..\libwidg2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES)"

libstx_libhtml.dll: ..\..\..\..\..\libhtml\$(OBJDIR)\libstx_libhtml.dll
	copy ..\..\..\..\..\libhtml\$(OBJDIR)\libstx_libhtml.dll *.*

..\..\..\..\..\libhtml\$(OBJDIR)\libstx_libhtml.dll:
	pushd ..\..\..\..\..\libhtml & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES)"




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
!    ifdef USEMINGW

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
fractalApplicationWin.$(RES): fractalApplicationWin.rc fractalApplication.ico

main.$(O): buildDate.h main.c bc.mak

main.c: $(TOP)\librun\main.c
	copy $(TOP)\librun\main.c main.c

buildDate.h: $(GENDATE_UTILITIY)
	$(GENDATE_UTILITIY)

librun.dll: $(TOP)\librun\$(OBJDIR_LIBRUN)\librun.dll
	copy $(TOP)\librun\$(OBJDIR_LIBRUN)\librun.dll librun.dll

cs3245.dll: $(TOP)\support\win32\borland\cs3245.dll
	copy $(TOP)\support\win32\borland\cs3245.dll cs3245.dll

X11.dll: $(TOP)\support\win32\X11.dll
	copy $(TOP)\support\win32\X11.dll X11.dll

Xext.dll: $(TOP)\support\win32\Xext.dll
	copy $(TOP)\support\win32\Xext.dll Xext.dll

symbols.stc: $(TOP)\include\symbols.stc
	copy $(TOP)\include\symbols.stc symbols.stc





clean::
	-del genDate.exe genDate.com
	-del c0x32.dll
	-del c0x32.lib
	-del buildDate.h
	-del $(PROJECT)
	-del install_fractalApplication.exe
	-del stx.lib
	-del stx.dll
	-del cs3245.dll
	-del $(REQUIRED_FILES)
	-del main.c
	-del *.log
	-del *.res
	-rmdir /S /Q resources
	-rmdir /S /Q $(OBJDIR)

clobber:: clean
	-del *.dll *.exe *.com

# stupid win-make does not allow empty - therefore echo something
postBuildCleanup::
	@-echo "postbuild cleanup"

# BEGINMAKEDEPEND --- do not remove this line; make depend needs it
$(OUTDIR)FractalApplication.$(O) FractalApplication.$(H): FractalApplication.st $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)FractalView.$(O) FractalView.$(H): FractalView.st $(INCLUDE_TOP)\stx\libview\View.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\DeviceGraphicsContext.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsContext.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MandelbrotSet.$(O) MandelbrotSet.$(H): MandelbrotSet.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Demos__SuperFormula.$(O) Demos__SuperFormula.$(H): Demos__SuperFormula.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Demos__SuperFormulaApplication.$(O) Demos__SuperFormulaApplication.$(H): Demos__SuperFormulaApplication.st $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)stx_goodies_demos_jh_math_fractalApplication.$(O) stx_goodies_demos_jh_math_fractalApplication.$(H): stx_goodies_demos_jh_math_fractalApplication.st $(INCLUDE_TOP)\stx\libbasic\ApplicationDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\ProjectDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)JuliaSet.$(O) JuliaSet.$(H): JuliaSet.st $(INCLUDE_TOP)\stx\goodies\demos\jh\math\fractalApplication\MandelbrotSet.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)

# ENDMAKEDEPEND --- do not remove this line
