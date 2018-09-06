#
# $Header: /cvs/stx/stx/libview/ntx.mak,v 1.23 2013-05-28 10:33:13 cg Exp $
#

TOP=..
INCLUDE_TOP=$(TOP)\..

!INCLUDE        $(TOP)\rules\stdHeader_bc

LIBNAME=XWorkstation
RESFILES=XWorkstation.$(RES)
LIB_BASE_LD_ARG=$(XWORKSTAT_BASE_LD_ARG)

MODULE=stx
MODULE_DIR=libview
PACKAGE=$(MODULE):$(MODULE_DIR)
LOCALINCLUDES= -I$(INCLUDE_TOP)\stx\libbasic
STCLOCALOPT= -I. $(LOCALINCLUDES) -warnNonStandard -staticMethods "-package=$(PACKAGE)" $(COMMONSYMBOLS) +optspace2 $(SEPINITCODE)

#STCFLAGS_WW=-H$(STX_INCDIR) -staticMethods "-package=$(PACKAGE)" $(COMMONSYMBOLS)


ALL: xlibs $(LIBDIR)\$(LIBNAME).lib $(BINDIR)\$(LIBNAME).dll

OBJS= \
    $(OUTDIR)XWorkstation.$(O)

$(OUTDIR)XWorkstation.$(O):       DeviceWorkstation.STH

NOINCLINK=YES
!ifdef USEBC

DEF_FILE=XWorkstation_bc.def
X11_LIBS=..\libbc\X11OMF.lib ..\libbc\XextOMF.lib

!else

DEF_FILE=XWorkstation.def
X11_LIBS=..\lib\X11.lib ..\lib\Xext.lib

!endif

LIBINIT_FILE=

xlibs: $(X11_LIBS)

..\libbc\X11OMF.lib: ..\support\win32\borland\X11OMF.lib
	copy ..\support\win32\borland\X11OMF.lib ..\libbc

..\libbc\XextOMF.lib: ..\support\win32\borland\XextOMF.lib
	copy ..\support\win32\borland\XextOMF.lib ..\libbc

..\lib\X11.lib: ..\support\win32\msc\X11.lib
	copy ..\support\win32\borland\X11.lib ..\lib

..\lib\Xext.lib: ..\support\win32\borland\Xext.lib
	copy ..\support\win32\borland\Xext.lib ..\lib

!INCLUDE $(TOP)\rules\stdRules_bc
