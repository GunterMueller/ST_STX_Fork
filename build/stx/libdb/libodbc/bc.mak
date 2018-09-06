# $Header: /cvs/stx/stx/libdb/libodbc/bc.mak,v 1.38 2016-03-01 16:19:12 stefan Exp $
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_libdb_libodbc.
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
TOP=..\..
INCLUDE_TOP=$(TOP)\..



!INCLUDE $(TOP)\rules\stdHeader_bc

!INCLUDE Make.spec

LIBNAME=libstx_libdb_libodbc
MODULE_PATH=libdb\libodbc
RESFILES=libodbc.$(RES)


LIB_BASE_LD_ARG=-b:$(LIBODBC_BASE)
!if defined(USEMINGW32) || defined(USEMINGW64)
ODBC_LD_ARG=-lodbc32
!else
ODBC_LD_ARG=odbc32.lib
!endif



LOCALINCLUDES= -I$(INCLUDE_TOP)\stx\libbasic -I$(INCLUDE_TOP)\stx\libbasic2 -I$(INCLUDE_TOP)\stx\libdb
LOCALDEFINES=

STCLOCALOPT=-package=$(PACKAGE) -I. $(LOCALINCLUDES) -headerDir=. $(STCLOCALOPTIMIZATIONS) $(STCWARNINGS) $(LOCALDEFINES)  -varPrefix=$(LIBNAME)
LOCALLIBS=$(ODBC_LD_ARG)

OBJS= $(COMMON_OBJS) $(WIN32_OBJS)

ALL::  classLibRule

classLibRule: $(OUTDIR) $(OUTDIR)$(LIBNAME).dll

!INCLUDE $(TOP)\rules\stdRules_bc

# build all mandatory prerequisite packages (containing superclasses) for this package
prereq:
	pushd ..\..\libbasic & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\libbasic2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd .. & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "







test: $(TOP)\goodies\builder\reports\NUL
	pushd $(TOP)\goodies\builder\reports & $(MAKE_BAT)
	$(TOP)\goodies\builder\reports\report-runner.bat -D . -r Builder::TestReport -p $(PACKAGE)
        
clean::
	del *.$(CSUFFIX)


# BEGINMAKEDEPEND --- do not remove this line; make depend needs it
$(OUTDIR)SQL__ODBCColumnDescription.$(O) SQL__ODBCColumnDescription.$(H): SQL__ODBCColumnDescription.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libdb\SQL__DatabaseColumnDescription.$(H) $(STCHDR)
$(OUTDIR)SQL__ODBCCursor.$(O) SQL__ODBCCursor.$(H): SQL__ODBCCursor.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libdb\SQL__Cursor.$(H) $(STCHDR)
$(OUTDIR)SQL__ODBCEnvironment.$(O) SQL__ODBCEnvironment.$(H): SQL__ODBCEnvironment.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libdb\SQL__Database.$(H) $(STCHDR)
$(OUTDIR)SQL__ODBCError.$(O) SQL__ODBCError.$(H): SQL__ODBCError.st $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\ProceedableError.$(H) $(INCLUDE_TOP)\stx\libdb\SQL__SQLError.$(H) $(STCHDR)
$(OUTDIR)SQL__ODBCHandle.$(O) SQL__ODBCHandle.$(H): SQL__ODBCHandle.st $(INCLUDE_TOP)\stx\libbasic\ExternalAddress.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libdb\SQL__DatabaseHandle.$(H) $(STCHDR)
$(OUTDIR)SQL__ODBCKeyDescription.$(O) SQL__ODBCKeyDescription.$(H): SQL__ODBCKeyDescription.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libdb\SQL__DatabaseKeyDescription.$(H) $(STCHDR)
$(OUTDIR)SQL__ODBCSession.$(O) SQL__ODBCSession.$(H): SQL__ODBCSession.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libdb\SQL__Connection.$(H) $(INCLUDE_TOP)\stx\libdb\SQL__DatabaseSession.$(H) $(STCHDR)
$(OUTDIR)SQL__ODBCStatement.$(O) SQL__ODBCStatement.$(H): SQL__ODBCStatement.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libdb\SQL__Statement.$(H) $(STCHDR)
$(OUTDIR)SQL__ODBCTableDescription.$(O) SQL__ODBCTableDescription.$(H): SQL__ODBCTableDescription.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libdb\SQL__DatabaseTableDescription.$(H) $(STCHDR)
$(OUTDIR)stx_libdb_libodbc.$(O) stx_libdb_libodbc.$(H): stx_libdb_libodbc.st $(INCLUDE_TOP)\stx\libbasic\LibraryDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\ProjectDefinition.$(H) $(STCHDR)
$(OUTDIR)SQL__ODBCConnectionError.$(O) SQL__ODBCConnectionError.$(H): SQL__ODBCConnectionError.st $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\ProceedableError.$(H) $(INCLUDE_TOP)\stx\libdb\SQL__SQLError.$(H) $(INCLUDE_TOP)\stx\libdb\libodbc\SQL__ODBCError.$(H) $(STCHDR)
$(OUTDIR)SQL__ODBCSchemaColumnDescription.$(O) SQL__ODBCSchemaColumnDescription.$(H): SQL__ODBCSchemaColumnDescription.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libdb\SQL__DatabaseColumnDescription.$(H) $(INCLUDE_TOP)\stx\libdb\libodbc\SQL__ODBCColumnDescription.$(H) $(STCHDR)
$(OUTDIR)extensions.$(O): extensions.st $(INCLUDE_TOP)\stx\libbasic\AbstractTime.$(H) $(INCLUDE_TOP)\stx\libbasic\ArithmeticValue.$(H) $(INCLUDE_TOP)\stx\libbasic\ArrayedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\Boolean.$(H) $(INCLUDE_TOP)\stx\libbasic\ByteArray.$(H) $(INCLUDE_TOP)\stx\libbasic\CharacterArray.$(H) $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Date.$(H) $(INCLUDE_TOP)\stx\libbasic\FixedPoint.$(H) $(INCLUDE_TOP)\stx\libbasic\Float.$(H) $(INCLUDE_TOP)\stx\libbasic\Fraction.$(H) $(INCLUDE_TOP)\stx\libbasic\Integer.$(H) $(INCLUDE_TOP)\stx\libbasic\LimitedPrecisionReal.$(H) $(INCLUDE_TOP)\stx\libbasic\Magnitude.$(H) $(INCLUDE_TOP)\stx\libbasic\Number.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\ShortFloat.$(H) $(INCLUDE_TOP)\stx\libbasic\Time.$(H) $(INCLUDE_TOP)\stx\libbasic\Timestamp.$(H) $(INCLUDE_TOP)\stx\libbasic\TwoByteString.$(H) $(INCLUDE_TOP)\stx\libbasic\Unicode16String.$(H) $(INCLUDE_TOP)\stx\libbasic\UninterpretedBytes.$(H) $(INCLUDE_TOP)\stx\libbasic2\UUID.$(H) $(STCHDR)

# ENDMAKEDEPEND --- do not remove this line
