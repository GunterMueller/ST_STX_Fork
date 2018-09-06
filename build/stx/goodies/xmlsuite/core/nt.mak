# $Header$
#
# --- nt.mak created by stmkmp at Wed Mar 25 18:22:16 CET 2009
#
# This file contains make rules for the win32 platform (using borland-bcc).
#
# Warning: once you modify this file, do not rerun
# stmkmp again - otherwise, your changes are lost.
#
TOP=..\..\..

!INCLUDE $(TOP)ules\stdHeader_nt

!INCLUDE Make.spec

PACKAGE=$(MODULE):$(MODULE_DIR)
STCLOCALOPT=-I. $(LOCALINCLUDES) -H. $(STCLOCALOPTIMIZATIONS) $(STCWARNINGS) $(LOCALDEFINES) '-P$(PACKAGE)' '-Z$(LIBNAME)' $(COMMONSYMFLAG) $(INITCODESEPFLAG)

ALL::  $(LIBJPEG) $(LIBDIR)\$(LIBNAME).lib $(BINDIR)\$(LIBNAME).dll

!INCLUDE $(TOP)ules\stdRules_nt

# BEGINMAKEDEPEND --- do not remove this line; make depend needs it
# ENDMAKEDEPEND --- do not remove this line
