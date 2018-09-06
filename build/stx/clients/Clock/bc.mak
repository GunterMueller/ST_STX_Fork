# $Header: /cvs/stx/stx/clients/Clock/bc.mak,v 1.3 2013-05-28 12:46:56 cg Exp $
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_clients_Clock.
#
# Warning: once you modify this file, do not rerun
# stmkmp or projectDefinition-build again - otherwise, your changes are lost.
#

# CFLAGS1= -WD -w-pro -w-ccc -w-rch -w-aus -w-par -x- -r- -k -y -v -vi- -c -tWDR
CFLAGS1= -w-pro -w-ccc -w-rch -w-aus -w-par -x- -r- -k -y -v -vi- -c

CFLAGS_CONSOLE=
CFLAGS_NOCONSOLE=-tWR -D_NO_VCL;WIN32GUI;WIN32 -DWIN_LOGFILE="\"clients_%d.log\""
LFLAGS_CONSOLE=-ap
LFLAGS_NOCONSOLE=-aa
CRT_STARTUP_CONSOLE=c0x32.obj
CRT_STARTUP_NOCONSOLE=c0w32.obj

CFLAGS_APPTYPE=$(CFLAGS_NOCONSOLE)
LFLAGS_APPTYPE=$(LFLAGS_NOCONSOLE)
CRT_STARTUP=$(CRT_STARTUP_NOCONSOLE)

CFLAGS_LOCAL=$(CFLAGS_APPTYPE) \
 -DSTARTUP_CLASS="\"Clock\"" \
 -DSTARTUP_SELECTOR="\"start\"" \
 -DUSE_MODULE_TABLE

TOP=..\..\..\stx

#
OBJS=

!INCLUDE $(TOP)\rules\stdHeader_bc
#
MODULE=stx
MODULE_DIR=clients/Clock
PACKAGE=$(MODULE):$(MODULE_DIR)
LIBNAME=dummy
STCOPT="+optinline"
STCLOCALOPT='-package=$(PACKAGE)' $(COMMONSYMBOLS) $(SEPINITCODE) $(RELOCINSTVARS) -varPrefix=$(LIBNAME)
#STCLOCALOPT=""

LINKER = ilink32

# LFLAGS = -L$(TOP)\libbc;$(BCB)\lib;$(DEBUGLIBPATH) -H:0x400000 -Hc:0x100000 -S:0x40000 -Sc:0x10000 -ap -Tpe -x -Gn -v -Ao:0x10000
LFLAGS = -L$(TOP)\libbc;$(BCB)\lib -S:0x40000 -Sc:0x10000 $(LFLAGS_APPTYPE) -Tpe -x -Gn -v -Ao:0x10000

PROJECT = clients.exe
#ALLOBJFILES = stx.obj main.obj
ALLOBJFILES = main.obj
RESFILES = clientsWinRC.$(RES)
ALLOBJ = $(CRT_STARTUP) $(ALLOBJFILES) $(OBJS)
DEFFILE=bc.def

LIBFILES=$(TOP)\libbc\librun.lib
ALLLIB=$(LIBFILES) import32.lib $(RT_LIB)

REQUIRED_LIBS=librun.dll  libstx_libbasic.dll WinWorkstation.dll XWorkstation.dll
REQUIRED_FILES=cs3245.dll symbols.stc $(REQUIRED_LIBS)

REQUIRED_SUPPORT_DIRS=RESOURCEFILES

ALL:: $(OBJS) $(REQUIRED_FILES) show $(PROJECT) $(REQUIRED_SUPPORT_DIRS)

setup: install_clients.exe

# This uses the Nullsoft Installer Package and works in Windows only

install_clients.exe: $(PROJECT) clients.nsi
    makensis clients.nsi

new:
    bmake clean
    bmake



RESOURCEFILES: clients_RESOURCES stx_RESOURCES stx_STYLES stx_BITMAPS

clients_RESOURCES: resources\stx\clients\NUL
	copy ..\resources\*.rs resources\stx\clients\*.*

stx_RESOURCES: \
	libbasic_RESOURCES \
	libtool_RESOURCES  \
	libtool2_RESOURCES  \
	libview_RESOURCES  \
	libview2_RESOURCES

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

resources\stx\clients\NUL: resources\stx\NUL
	mkdir resources\stx\clients

resources\stx\NUL: resources\NUL
	mkdir resources\stx

resources\NUL:
	mkdir resources

bitmaps\NUL:
	mkdir bitmaps

doc\NUL:
	mkdir doc



libstx_libbasic.dll: $(TOP)\libbasic\objbc\libstx_libbasic.dll
	copy $(TOP)\libbasic\objbc\libstx_libbasic.dll *.*

WinWorkstation.dll: $(TOP)\libview\objbc\WinWorkstation.dll
	copy $(TOP)\libview\objbc\WinWorkstation.dll *.*

XWorkstation.dll: $(TOP)\libview\objbc\XWorkstation.dll
	copy $(TOP)\libview\objbc\XWorkstation.dll *.*




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
clientsWinRC.$(RES): clientsWinRC.rc clients.ico

main.obj: buildDate.h main.c nt.mak

main.c: $(TOP)\librun\main.c
	copy $(TOP)\librun\main.c main.c

buildDate.h: genDate.exe
	genDate.exe

genDate.exe: $(TOP)\librun\genDate.exe
	copy $(TOP)\librun\genDate.exe genDate.exe

librun.dll: $(TOP)\librun\librun.dll
	copy $(TOP)\librun\librun.dll librun.dll

cs3245.dll: $(TOP)\support\win32\borland\cs3245.dll
	copy $(TOP)\support\win32\borland\cs3245.dll cs3245.dll

symbols.stc: $(TOP)\include\symbols.stc
	copy $(TOP)\include\symbols.stc symbols.stc

clean::
	-del genDate.exe
	-del c0x32.dll
	-del c0x32.lib
	-del buildDate.h
	-del $(PROJECT)
	-del install_clients.exe
	-del stx.lib
	-del stx.dll
	-del librun.dll
	-del cs3245.dll
	-del $(REQUIRED_FILES)
	-del main.c
	-del *.log
	-rmdir /S /Q resources
	-rmdir /S /Q objbc

# BEGINMAKEDEPEND --- do not remove this line; make depend needs it
Clock.$(O) Clock.$(H): Clock.st $(STCHDR)  ../../../stx/include/Object.$(H)
genAbbrev:: Clock.st
# ENDMAKEDEPEND --- do not remove this line
