# $Header: /cvs/stx/stx/libdb/nosql/couchDB/bc.mak,v 1.2 2017-07-31 06:49:53 mawalch Exp $
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_libdb_nosql_couchDB.
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

LIBNAME=libstx_libdb_nosql_couchDB
MODULE_PATH=libdb\nosql\couchDB
RESFILES=stx_libdb_nosql_couchDBWINrc.$(RES)



LOCALINCLUDES= -I$(INCLUDE_TOP)\stx\goodies\json -I$(INCLUDE_TOP)\stx\libbasic -I$(INCLUDE_TOP)\stx\libbasic2 -I$(INCLUDE_TOP)\stx\libcompat
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







test: $(TOP)\goodies\builder\reports\
	pushd $(TOP)\goodies\builder\reports & $(MAKE_BAT)
	$(TOP)\goodies\builder\reports\report-runner.bat -D . -r Builder::TestReport -p $(PACKAGE)
        
clean::
	-del *.$(CSUFFIX)


# BEGINMAKEDEPEND --- do not remove this line; make depend needs it
$(OUTDIR)CouchDB.$(O) CouchDB.$(C) CouchDB.$(H): CouchDB.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)CouchDBError.$(O) CouchDBError.$(C) CouchDBError.$(H): CouchDBError.st $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)CouchViewServer.$(O) CouchViewServer.$(C) CouchViewServer.$(H): CouchViewServer.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)CouchViewServerError.$(O) CouchViewServerError.$(C) CouchViewServerError.$(H): CouchViewServerError.st $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)CouchViewServerFunction.$(O) CouchViewServerFunction.$(C) CouchViewServerFunction.$(H): CouchViewServerFunction.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)CouchViewServerListener.$(O) CouchViewServerListener.$(C) CouchViewServerListener.$(H): CouchViewServerListener.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)stx_libdb_nosql_couchDB.$(O) stx_libdb_nosql_couchDB.$(C) stx_libdb_nosql_couchDB.$(H): stx_libdb_nosql_couchDB.st $(INCLUDE_TOP)\stx\libbasic\LibraryDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\ProjectDefinition.$(H) $(STCHDR)
$(OUTDIR)CouchDBInvalidDatabaseNameError.$(O) CouchDBInvalidDatabaseNameError.$(C) CouchDBInvalidDatabaseNameError.$(H): CouchDBInvalidDatabaseNameError.st $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libdb\nosql\couchDB\CouchDBError.$(H) $(STCHDR)
$(OUTDIR)CouchDBInvalidDocumentError.$(O) CouchDBInvalidDocumentError.$(C) CouchDBInvalidDocumentError.$(H): CouchDBInvalidDocumentError.st $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libdb\nosql\couchDB\CouchDBError.$(H) $(STCHDR)
$(OUTDIR)CouchDBOperationFailedError.$(O) CouchDBOperationFailedError.$(C) CouchDBOperationFailedError.$(H): CouchDBOperationFailedError.st $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libdb\nosql\couchDB\CouchDBError.$(H) $(STCHDR)
$(OUTDIR)CouchViewServerCompilationError.$(O) CouchViewServerCompilationError.$(C) CouchViewServerCompilationError.$(H): CouchViewServerCompilationError.st $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libdb\nosql\couchDB\CouchViewServerError.$(H) $(STCHDR)
$(OUTDIR)CouchViewServerFunctionError.$(O) CouchViewServerFunctionError.$(C) CouchViewServerFunctionError.$(H): CouchViewServerFunctionError.st $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libdb\nosql\couchDB\CouchViewServerError.$(H) $(STCHDR)
$(OUTDIR)CouchViewServerReduceError.$(O) CouchViewServerReduceError.$(C) CouchViewServerReduceError.$(H): CouchViewServerReduceError.st $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libdb\nosql\couchDB\CouchViewServerError.$(H) $(STCHDR)
$(OUTDIR)extensions.$(O): extensions.st $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Dictionary.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\Set.$(H) $(STCHDR)

# ENDMAKEDEPEND --- do not remove this line
