# $Header: /cvs/stx/stx/libdb/libopenDBX/driver/tests/bc.mak,v 1.1 2013-04-15 13:19:01 cg Exp $
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_libdb_libopenDBX_driver_tests.
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

LIBNAME=libstx_libdb_libopenDBX_driver_tests
RESFILES=tests.$(RES)



LOCALINCLUDES= -I$(INCLUDE_TOP)\stx\goodies\sunit -I$(INCLUDE_TOP)\stx\libbasic
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
	pushd ..\..\..\..\libview & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\..\libview2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\..\goodies\sunit & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "






clean::
	del *.$(CSUFFIX)

# BEGINMAKEDEPEND --- do not remove this line; make depend needs it
$(OUTDIR)DBXBackendFacility.$(O) DBXBackendFacility.$(H): DBXBackendFacility.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DBXTestObject.$(O) DBXTestObject.$(H): DBXTestObject.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DBXTranscript.$(O) DBXTranscript.$(H): DBXTranscript.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)stx_libdb_libopenDBX_driver_tests.$(O) stx_libdb_libopenDBX_driver_tests.$(H): stx_libdb_libopenDBX_driver_tests.st $(INCLUDE_TOP)\stx\libbasic\LibraryDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\ProjectDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DBXFirebirdFacility.$(O) DBXFirebirdFacility.$(H): DBXFirebirdFacility.st $(INCLUDE_TOP)\stx\libdb\libopenDBX\driver\tests\DBXBackendFacility.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DBXMsSQLFacility.$(O) DBXMsSQLFacility.$(H): DBXMsSQLFacility.st $(INCLUDE_TOP)\stx\libdb\libopenDBX\driver\tests\DBXBackendFacility.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DBXMySQLFacility.$(O) DBXMySQLFacility.$(H): DBXMySQLFacility.st $(INCLUDE_TOP)\stx\libdb\libopenDBX\driver\tests\DBXBackendFacility.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DBXOdbcMSSQLFacility.$(O) DBXOdbcMSSQLFacility.$(H): DBXOdbcMSSQLFacility.st $(INCLUDE_TOP)\stx\libdb\libopenDBX\driver\tests\DBXBackendFacility.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DBXOdbcPostgreFacility.$(O) DBXOdbcPostgreFacility.$(H): DBXOdbcPostgreFacility.st $(INCLUDE_TOP)\stx\libdb\libopenDBX\driver\tests\DBXBackendFacility.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DBXOracleFacility.$(O) DBXOracleFacility.$(H): DBXOracleFacility.st $(INCLUDE_TOP)\stx\libdb\libopenDBX\driver\tests\DBXBackendFacility.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DBXPostgreFacility.$(O) DBXPostgreFacility.$(H): DBXPostgreFacility.st $(INCLUDE_TOP)\stx\libdb\libopenDBX\driver\tests\DBXBackendFacility.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DBXSqliteFacility.$(O) DBXSqliteFacility.$(H): DBXSqliteFacility.st $(INCLUDE_TOP)\stx\libdb\libopenDBX\driver\tests\DBXBackendFacility.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DBXMySQL4Facility.$(O) DBXMySQL4Facility.$(H): DBXMySQL4Facility.st $(INCLUDE_TOP)\stx\libdb\libopenDBX\driver\tests\DBXMySQLFacility.$(H) $(INCLUDE_TOP)\stx\libdb\libopenDBX\driver\tests\DBXBackendFacility.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)

# ENDMAKEDEPEND --- do not remove this line
