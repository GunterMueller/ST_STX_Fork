# $Header: /cvs/stx/stx/libdb/nosql/goods/tests/bc.mak,v 1.4 2013-03-28 11:32:05 cg Exp $
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_libdb_nosql_goods_tests.
#
# Warning: once you modify this file, do not rerun
# stmkmp or projectDefinition-build again - otherwise, your changes are lost.
#
# Notice, that the name bc.mak is historical (from times, when only borland c was supported).
# This file contains make rules for the win32 platform using either borland-bcc or visual-c.
# It shares common definitions with the unix-make in Make.spec.
# The bc.mak supports the following targets:
#    bmake         - compile all st-files to a classLib (dll)
#    bmake clean   - clean all temp files
#    bmake clobber - clean all
#
# Historic Note:
#  this used to contain only rules to make with borland
#    (called via bmake, by "make.exe -f bc.mak")
#  this has changed; it is now also possible to build using microsoft visual c
#    (called via vcmake, by "make.exe -f bc.mak -DUSEVC")
#
TOP=..\..\..
INCLUDE_TOP=$(TOP)\..



!INCLUDE $(TOP)\rules\stdHeader_bc

!INCLUDE Make.spec

LIBNAME=libstx_libdb_nosql_goods_tests
RESFILES=tests.$(RES)



LOCALINCLUDES= -I$(INCLUDE_TOP)\stx\libdb\nosql\sunit -I$(INCLUDE_TOP)\stx\libbasic
LOCALDEFINES=

STCLOCALOPT=-package=$(PACKAGE) -I. $(LOCALINCLUDES) -headerDir=. $(STCLOCALOPTIMIZATIONS) $(STCWARNINGS) $(LOCALDEFINES)  -varPrefix=$(LIBNAME)
LOCALLIBS=

OBJS= $(COMMON_OBJS) $(WIN32_OBJS)

ALL::  classLibRule

classLibRule: $(OUTDIR) $(OUTDIR)$(LIBNAME).dll

!INCLUDE $(TOP)\rules\stdRules_bc

# build all mandatory prerequisite packages (containing superclasses) for this package
prereq:
	pushd ..\..\..\libbasic & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\libbasic2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\libview & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd .. & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\libui & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\stx & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\libview2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\sunit & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "






clean::
	del *.$(CSUFFIX)

# BEGINMAKEDEPEND --- do not remove this line; make depend needs it
$(OUTDIR)stx_libdb_nosql_goods_tests.$(O) stx_libdb_nosql_goods_tests.$(H): stx_libdb_nosql_goods_tests.st $(INCLUDE_TOP)\stx\libbasic\LibraryDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\ProjectDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)

# ENDMAKEDEPEND --- do not remove this line
