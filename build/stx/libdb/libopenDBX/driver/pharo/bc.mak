# $Header: /cvs/stx/stx/libdb/libopenDBX/driver/pharo/bc.mak,v 1.1 2013-04-15 13:15:21 cg Exp $
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_libdb_libopenDBX_driver_pharo.
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
TOP=..\..\..\..
INCLUDE_TOP=$(TOP)\..



!INCLUDE $(TOP)\rules\stdHeader_bc

!INCLUDE Make.spec

LIBNAME=libstx_libdb_libopenDBX_driver_pharo
RESFILES=pharo.$(RES)



LOCALINCLUDES= -I$(INCLUDE_TOP)\stx\libdb\libopenDBX\driver -I$(INCLUDE_TOP)\stx\libbasic
LOCALDEFINES=

STCLOCALOPT=-package=$(PACKAGE) -I. $(LOCALINCLUDES) -headerDir=. $(STCLOCALOPTIMIZATIONS) $(STCWARNINGS) $(LOCALDEFINES)  -varPrefix=$(LIBNAME)
LOCALLIBS=

OBJS= $(COMMON_OBJS) $(WIN32_OBJS)

ALL::  classLibRule

classLibRule: $(OUTDIR) $(OUTDIR)$(LIBNAME).dll

!INCLUDE $(TOP)\rules\stdRules_bc

# build all mandatory prerequisite packages (containing superclasses) for this package
prereq:
	pushd ..\..\..\..\libbasic & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd .. & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "






clean::
	del *.$(CSUFFIX)

# BEGINMAKEDEPEND --- do not remove this line; make depend needs it
$(OUTDIR)OpenDBXDriverPharoDialect.$(O) OpenDBXDriverPharoDialect.$(H): OpenDBXDriverPharoDialect.st $(INCLUDE_TOP)\stx\libdb\libopenDBX\driver\OpenDBXDriverSmalltalkDialect.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PharoOpenDBX.$(O) PharoOpenDBX.$(H): PharoOpenDBX.st $(INCLUDE_TOP)\stx\libdb\libopenDBX\driver\OpenDBX.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)stx_libdb_libopenDBX_driver_pharo.$(O) stx_libdb_libopenDBX_driver_pharo.$(H): stx_libdb_libopenDBX_driver_pharo.st $(INCLUDE_TOP)\stx\libbasic\LibraryDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\ProjectDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)OpenDBXUnix.$(O) OpenDBXUnix.$(H): OpenDBXUnix.st $(INCLUDE_TOP)\stx\libdb\libopenDBX\driver\pharo\PharoOpenDBX.$(H) $(INCLUDE_TOP)\stx\libdb\libopenDBX\driver\OpenDBX.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)OpenDBXWin32.$(O) OpenDBXWin32.$(H): OpenDBXWin32.st $(INCLUDE_TOP)\stx\libdb\libopenDBX\driver\pharo\PharoOpenDBX.$(H) $(INCLUDE_TOP)\stx\libdb\libopenDBX\driver\OpenDBX.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)OpenDBXMacOSX.$(O) OpenDBXMacOSX.$(H): OpenDBXMacOSX.st $(INCLUDE_TOP)\stx\libdb\libopenDBX\driver\pharo\OpenDBXUnix.$(H) $(INCLUDE_TOP)\stx\libdb\libopenDBX\driver\pharo\PharoOpenDBX.$(H) $(INCLUDE_TOP)\stx\libdb\libopenDBX\driver\OpenDBX.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)

# ENDMAKEDEPEND --- do not remove this line
