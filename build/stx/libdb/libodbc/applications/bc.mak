# $Header: /cvs/stx/stx/libdb/libodbc/applications/bc.mak,v 1.8 2013-05-28 10:32:53 cg Exp $
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_libdb_libodbc_applications.
#
# Warning: once you modify this file, do not rerun
# stmkmp or projectDefinition-build again - otherwise, your changes are lost.
#

TOP=..\..\..
INCLUDE_TOP=$(TOP)\..

# CFLAGS1= -WD -w-pro -w-ccc -w-rch -w-aus -w-par -x- -r- -k -y -v -vi- -c -tWDR
CFLAGS1= -w-pro -w-ccc -w-rch -w-aus -w-par -x- -r- -k -y -v -vi- -c

CFLAGS_CONSOLE= -tWC -tWR -D_NO_VCL;WIN32 -DWIN_LOGFILE="\"applications_%d.log\""
CFLAGS_NOCONSOLE=-tWR -D_NO_VCL;WIN32GUI;WIN32 -DWIN_LOGFILE="\"applications_%d.log\""
LFLAGS_CONSOLE=-ap
LFLAGS_NOCONSOLE=-aa
CRT_STARTUP_CONSOLE=c0x32.obj
CRT_STARTUP_NOCONSOLE=c0w32.obj

CFLAGS_APPTYPE=$(CFLAGS_NOCONSOLE)
LFLAGS_APPTYPE=$(LFLAGS_NOCONSOLE)
CRT_STARTUP=$(CRT_STARTUP_NOCONSOLE)

CFLAGS_LOCAL=$(CFLAGS_APPTYPE) \
 -DSTARTUP_CLASS="\"SQL::ODBCScratchpad\"" \
 -DSTARTUP_SELECTOR="\"open\"" \
 -DUSE_MODULE_TABLE

#

!INCLUDE $(TOP)\rules\stdHeader_bc
!INCLUDE Make.spec

OBJS= $(COMMON_OBJS) $(WIN32_OBJS)

#
LIBNAME=dummy
STCOPT="+optinline"
LOCALINCLUDES= -I$(INCLUDE_TOP)\stx\libview2 -I$(INCLUDE_TOP)\stx\libbasic
STCLOCALOPT='-package=$(PACKAGE)' $(LOCALINCLUDES)  $(STCLOCALOPTIMIZATIONS) $(STCWARNINGS) $(LOCALDEFINES) $(COMMONSYMFLAG) -varPrefix=$(LIBNAME)

LINKER = ilink32

# LFLAGS = -L$(TOP)\libbc;$(BCB)\lib;$(DEBUGLIBPATH) -H:0x400000 -Hc:0x100000 -S:0x40000 -Sc:0x10000 -ap -Tpe -x -Gn -v -Ao:0x10000
LFLAGS = -L$(TOP)\libbc;$(BCB)\lib -S:0x40000 -Sc:0x10000 $(LFLAGS_APPTYPE) -Tpe -x -Gn -v -Ao:0x10000

PROJECT = applications.exe
ALLOBJFILES = main.obj
RESFILES = applicationsWinRC.$(RES)
ALLOBJ = $(CRT_STARTUP) $(ALLOBJFILES) $(OBJS)
DEFFILE=$(TOP)\rules\bc_exe.def

LIBFILES=$(TOP)\libbc\librun.lib
ALLLIB=$(LIBFILES) import32.lib $(RT_LIB)

REQUIRED_LIBS=librun.dll  \
 libstx_libbasic.dll \
 libstx_libbasic2.dll \
 libstx_libcomp.dll \
 libstx_libdb.dll \
 libstx_libhtml.dll \
 libstx_libui.dll \
 libstx_libview.dll \
 libstx_libview2.dll \
 libstx_libwidg.dll \
 libstx_libwidg2.dll \


REQUIRED_FILES=cs3245.dll symbols.stc $(REQUIRED_LIBS)

REQUIRED_SUPPORT_DIRS=RESOURCEFILES

target: ALL

# the executable, all required files and a self-installing-installer-exe
ALL:: exe $(REQUIRED_SUPPORT_DIRS) setup

# the executable only
exe: $(OUTDIR) $(OBJS) $(REQUIRED_FILES) show $(PROJECT)

# a nullsoft installable delivery
setup: install_applications.exe

# This uses the Nullsoft Installer Package and works in Windows only

install_applications.exe: $(PROJECT) applications.nsi
    $(MAKENSIS) applications.nsi

new:
    bmake clean
    bmake

RESOURCEFILES: applications_RESOURCES applications_BITMAPS \
	       stx_RESOURCES stx_STYLES stx_BITMAPS


applications_RESOURCES: resources\stx\libdb\libodbc\applications\NUL
	-copy ..\resources\*.rs resources\stx\libdb\libodbc\applications\..\*.*

applications_BITMAPS: resources\stx\libdb\libodbc\applications\bitmaps\NUL
	-copy *.ico resources\stx\libdb\libodbc\applications\bitmaps\*.*
	-copy *.gif resources\stx\libdb\libodbc\applications\bitmaps\*.*

resources\stx\libdb\libodbc\applications\bitmaps\NUL: resources\stx\libdb\libodbc\applications\NUL
	mkdir resources\stx\libdb\libodbc\applications\bitmaps

resources\stx\libdb\libodbc\applications\NUL: resources\stx\NUL
	mkdir resources\stx\libdb\libodbc\applications



stx_RESOURCES: \
	keyboard.rc \
	libbasic_RESOURCES \
	libview_RESOURCES \
	libtool_RESOURCES  \
	libtool2_RESOURCES

keyboard.rc: $(TOP)\projects\smalltalk\keyboard.rc
	copy $(TOP)\projects\smalltalk\keyboard.rc *.*

stx_STYLES: resources\stx\libview\NUL
	copy $(TOP)\libview\styles\mswindowsXP* resources\stx\libview\*.*
	copy $(TOP)\libview\styles\mswindows*.common resources\stx\libview\*.*

stx_BITMAPS: \
	libwidg_BITMAPS

libwidg_BITMAPS: resources\stx\libwidg\bitmaps\NUL
	copy $(TOP)\libwidg\bitmaps\*.xpm resources\stx\libwidg\bitmaps\*.*

libbasic_RESOURCES: resources\stx\libbasic\NUL
	copy $(TOP)\libbasic\resources\*.rs resources\stx\libbasic\*.*

libtool_RESOURCES: resources\stx\libtool\NUL
	copy $(TOP)\libtool\resources\*.rs resources\stx\libtool\*.*

libtool2_RESOURCES: resources\stx\libtool2\NUL
	copy $(TOP)\libtool2\resources\*.rs resources\stx\libtool2\*.*

libview_RESOURCES: resources\stx\libview\NUL
	copy $(TOP)\libview\resources\*.rs resources\stx\libview\*.*

libview2_RESOURCES: resources\stx\libview2\NUL
	copy $(TOP)\libview2\resources\*.rs resources\stx\libview2\*.*

resources\stx\libbasic\NUL: resources\stx\NUL
	mkdir resources\stx\libbasic

resources\stx\libtool\NUL: resources\stx\NUL
	mkdir resources\stx\libtool

resources\stx\libtool2\NUL: resources\stx\NUL
	mkdir resources\stx\libtool2

resources\stx\libview\NUL: resources\stx\NUL
	mkdir resources\stx\libview

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



libstx_libbasic.dll: ..\..\..\libbasic\objbc\libstx_libbasic.dll
	copy ..\..\..\libbasic\objbc\libstx_libbasic.dll *.*

libstx_libbasic2.dll: ..\..\..\libbasic2\objbc\libstx_libbasic2.dll
	copy ..\..\..\libbasic2\objbc\libstx_libbasic2.dll *.*

libstx_libcomp.dll: ..\..\..\libcomp\objbc\libstx_libcomp.dll
	copy ..\..\..\libcomp\objbc\libstx_libcomp.dll *.*

libstx_libdb.dll: ..\..\\objbc\libstx_libdb.dll
	copy ..\..\\objbc\libstx_libdb.dll *.*

libstx_libhtml.dll: ..\..\..\libhtml\objbc\libstx_libhtml.dll
	copy ..\..\..\libhtml\objbc\libstx_libhtml.dll *.*

libstx_libui.dll: ..\..\..\libui\objbc\libstx_libui.dll
	copy ..\..\..\libui\objbc\libstx_libui.dll *.*

libstx_libview.dll: ..\..\..\libview\objbc\libstx_libview.dll
	copy ..\..\..\libview\objbc\libstx_libview.dll *.*

libstx_libview2.dll: ..\..\..\libview2\objbc\libstx_libview2.dll
	copy ..\..\..\libview2\objbc\libstx_libview2.dll *.*

libstx_libwidg.dll: ..\..\..\libwidg\objbc\libstx_libwidg.dll
	copy ..\..\..\libwidg\objbc\libstx_libwidg.dll *.*

libstx_libwidg2.dll: ..\..\..\libwidg2\objbc\libstx_libwidg2.dll
	copy ..\..\..\libwidg2\objbc\libstx_libwidg2.dll *.*




show:
    @echo LFLAGS= $(LFLAGS)
    @echo ALLOBJ= $(ALLOBJ)
    @echo PROJECT= $(PROJECT)
    @echo ALLLIB= $(ALLLIB)
    @echo DEFFILE= $(DEFFILE)
    @echo ALLRES= $(ALLRES)

$(PROJECT): $(ALLOBJFILES) $(OBJS) $(RESFILES) $(DEFFILE)
    $(BCB)\BIN\$(LINKER) $(LFLAGS) $(ALLOBJ), $(PROJECT),,  $(ALLLIB),  $(DEFFILE),  $(RESFILES)

#$(PROJECT): $(ALLOBJFILES) $(RESFILES) $(DEFFILE)
#    $(BCB)\BIN\$(LINKER) @&&!
#    $(LFLAGS) +
#    $(ALLOBJ), +
#    $(PROJECT),, +
#    $(ALLLIB), +
#    $(DEFFILE), +
#    $(RESFILES)
#!


!INCLUDE $(TOP)\rules\stdRules_bc

#
# additional rules
#
applicationsWin.$(RES): applicationsWin.rc applications.ico

main.obj: buildDate.h main.c bc.mak

main.c: $(TOP)\librun\main.c
	copy $(TOP)\librun\main.c main.c

buildDate.h: $(TOP)\librun\genDate.exe
	$(TOP)\librun\genDate.exe

librun.dll: $(TOP)\librun\librun.dll
	copy $(TOP)\librun\librun.dll librun.dll

cs3245.dll: $(TOP)\support\win32\borland\cs3245.dll
	copy $(TOP)\support\win32\borland\cs3245.dll cs3245.dll

symbols.stc: $(TOP)\include\symbols.stc
	copy $(TOP)\include\symbols.stc symbols.stc

clobber::
	-del librun.dll



clean::
	-del genDate.exe
	-del c0x32.dll
	-del c0x32.lib
	-del buildDate.h
	-del $(PROJECT)
	-del install_applications.exe
	-del stx.lib
	-del stx.dll
	-del cs3245.dll
	-del $(REQUIRED_FILES)
	-del main.c
	-del *.log
	-del *.res
	-rmdir /S /Q resources
	-rmdir /S /Q objbc

clobber::
	-del *.dll
	-del *.exe

# BEGINMAKEDEPEND --- do not remove this line; make depend needs it
$(OUTDIR)SQL__AdaptableApplicationModel.$(O) SQL__AdaptableApplicationModel.$(H): SQL__AdaptableApplicationModel.st $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SQL__GetConnectionInformation.$(O) SQL__GetConnectionInformation.$(H): SQL__GetConnectionInformation.st $(INCLUDE_TOP)\stx\libview2\SimpleDialog.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)stx_libdb_libodbc_applications.$(O) stx_libdb_libodbc_applications.$(H): stx_libdb_libodbc_applications.st $(INCLUDE_TOP)\stx\libbasic\ApplicationDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\ProjectDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SQL__ODBCResultTable.$(O) SQL__ODBCResultTable.$(H): SQL__ODBCResultTable.st $(INCLUDE_TOP)\stx\libdb\libodbc\applications\SQL__AdaptableApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SQL__ODBCResultTableTab.$(O) SQL__ODBCResultTableTab.$(H): SQL__ODBCResultTableTab.st $(INCLUDE_TOP)\stx\libdb\libodbc\applications\SQL__AdaptableApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SQL__ODBCSQLScratchpad.$(O) SQL__ODBCSQLScratchpad.$(H): SQL__ODBCSQLScratchpad.st $(INCLUDE_TOP)\stx\libdb\libodbc\applications\SQL__AdaptableApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SQL__ODBCScratchpad.$(O) SQL__ODBCScratchpad.$(H): SQL__ODBCScratchpad.st $(INCLUDE_TOP)\stx\libdb\libodbc\applications\SQL__AdaptableApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SQL__ODBCScratchpadTab.$(O) SQL__ODBCScratchpadTab.$(H): SQL__ODBCScratchpadTab.st $(INCLUDE_TOP)\stx\libdb\libodbc\applications\SQL__AdaptableApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)

# ENDMAKEDEPEND --- do not remove this line
