# $Header: /cvs/stx/stx/libdb/libopenDBX/tools/dbxBrowser/bc.mak,v 1.3 2013-04-15 14:27:01 cg Exp $
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_libdb_libopenDBX_tools_dbxBrowser.
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

LIBNAME=libstx_libdb_libopenDBX_tools_dbxBrowser
RESFILES=dbxBrowser.$(RES)



LOCALINCLUDES= -I$(INCLUDE_TOP)\stx\goodies\announcements -I$(INCLUDE_TOP)\stx\libbasic
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
	pushd ..\..\..\..\goodies\announcements & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "






clean::
	del *.$(CSUFFIX)

# BEGINMAKEDEPEND --- do not remove this line; make depend needs it
$(OUTDIR)DBXBrowser.$(O) DBXBrowser.$(H): DBXBrowser.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DBXBrowserClosedConnection.$(O) DBXBrowserClosedConnection.$(H): DBXBrowserClosedConnection.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DBXBrowserConnection.$(O) DBXBrowserConnection.$(H): DBXBrowserConnection.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DBXBrowserModel.$(O) DBXBrowserModel.$(H): DBXBrowserModel.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DBXBrowserOpenedConnection.$(O) DBXBrowserOpenedConnection.$(H): DBXBrowserOpenedConnection.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DBXBrowserSchema.$(O) DBXBrowserSchema.$(H): DBXBrowserSchema.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DBXBrowserTable.$(O) DBXBrowserTable.$(H): DBXBrowserTable.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DBXConnectionAdded.$(O) DBXConnectionAdded.$(H): DBXConnectionAdded.st $(INCLUDE_TOP)\stx\goodies\announcements\Announcement.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DBXConnectionRemoved.$(O) DBXConnectionRemoved.$(H): DBXConnectionRemoved.st $(INCLUDE_TOP)\stx\goodies\announcements\Announcement.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DBXConnectionStatusChanged.$(O) DBXConnectionStatusChanged.$(H): DBXConnectionStatusChanged.st $(INCLUDE_TOP)\stx\goodies\announcements\Announcement.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DBXTablesRefresh.$(O) DBXTablesRefresh.$(H): DBXTablesRefresh.st $(INCLUDE_TOP)\stx\goodies\announcements\Announcement.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)stx_libdb_libopenDBX_tools_dbxBrowser.$(O) stx_libdb_libopenDBX_tools_dbxBrowser.$(H): stx_libdb_libopenDBX_tools_dbxBrowser.st $(INCLUDE_TOP)\stx\libbasic\LibraryDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\ProjectDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)

# ENDMAKEDEPEND --- do not remove this line
