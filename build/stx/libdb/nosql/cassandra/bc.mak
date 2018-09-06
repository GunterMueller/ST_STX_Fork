# $Header: /cvs/stx/stx/libdb/nosql/cassandra/bc.mak,v 1.5 2016-08-30 09:26:31 mawalch Exp $
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_libdb_nosql_cassandra.
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

LIBNAME=libstx_libdb_nosql_cassandra
MODULE_PATH=libdb\nosql\cassandra
RESFILES=stx_libdb_nosql_cassandraWINrc.$(RES)



LOCALINCLUDES= -I$(INCLUDE_TOP)\stx\goodies\communication\thrift -I$(INCLUDE_TOP)\stx\libbasic
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
	pushd ..\..\..\goodies\communication\thrift & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "







test: $(TOP)\goodies\builder\reports\NUL
	pushd $(TOP)\goodies\builder\reports & $(MAKE_BAT)
	$(TOP)\goodies\builder\reports\report-runner.bat -D . -r Builder::TestReport -p $(PACKAGE)
        
clean::
	-del *.$(CSUFFIX)


# BEGINMAKEDEPEND --- do not remove this line; make depend needs it
$(OUTDIR)Cassandra__AuthenticationRequest.$(O) Cassandra__AuthenticationRequest.$(C) Cassandra__AuthenticationRequest.$(H): Cassandra__AuthenticationRequest.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Cassandra__Cassandra.$(O) Cassandra__Cassandra.$(C) Cassandra__Cassandra.$(H): Cassandra__Cassandra.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Cassandra__CassandraClient.$(O) Cassandra__CassandraClient.$(C) Cassandra__CassandraClient.$(H): Cassandra__CassandraClient.st $(INCLUDE_TOP)\stx\goodies\communication\thrift\TClient.$(H) $(INCLUDE_TOP)\stx\goodies\communication\thrift\TConstants.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)CassandraConstants.$(O) CassandraConstants.$(C) CassandraConstants.$(H): CassandraConstants.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\SharedPool.$(H) $(STCHDR)
$(OUTDIR)Cassandra__CassandraError.$(O) Cassandra__CassandraError.$(C) Cassandra__CassandraError.$(H): Cassandra__CassandraError.st $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Cassandra__CfDef.$(O) Cassandra__CfDef.$(C) Cassandra__CfDef.$(H): Cassandra__CfDef.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Cassandra__Column.$(O) Cassandra__Column.$(C) Cassandra__Column.$(H): Cassandra__Column.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Cassandra__ColumnDef.$(O) Cassandra__ColumnDef.$(C) Cassandra__ColumnDef.$(H): Cassandra__ColumnDef.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Cassandra__ColumnOrSuperColumn.$(O) Cassandra__ColumnOrSuperColumn.$(C) Cassandra__ColumnOrSuperColumn.$(H): Cassandra__ColumnOrSuperColumn.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Cassandra__ColumnParent.$(O) Cassandra__ColumnParent.$(C) Cassandra__ColumnParent.$(H): Cassandra__ColumnParent.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Cassandra__ColumnPath.$(O) Cassandra__ColumnPath.$(C) Cassandra__ColumnPath.$(H): Cassandra__ColumnPath.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Cassandra__CounterColumn.$(O) Cassandra__CounterColumn.$(C) Cassandra__CounterColumn.$(H): Cassandra__CounterColumn.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Cassandra__CounterSuperColumn.$(O) Cassandra__CounterSuperColumn.$(C) Cassandra__CounterSuperColumn.$(H): Cassandra__CounterSuperColumn.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Cassandra__CqlMetadata.$(O) Cassandra__CqlMetadata.$(C) Cassandra__CqlMetadata.$(H): Cassandra__CqlMetadata.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Cassandra__CqlPreparedResult.$(O) Cassandra__CqlPreparedResult.$(C) Cassandra__CqlPreparedResult.$(H): Cassandra__CqlPreparedResult.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Cassandra__CqlResult.$(O) Cassandra__CqlResult.$(C) Cassandra__CqlResult.$(H): Cassandra__CqlResult.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Cassandra__CqlRow.$(O) Cassandra__CqlRow.$(C) Cassandra__CqlRow.$(H): Cassandra__CqlRow.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Cassandra__Deletion.$(O) Cassandra__Deletion.$(C) Cassandra__Deletion.$(H): Cassandra__Deletion.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Cassandra__EndpointDetails.$(O) Cassandra__EndpointDetails.$(C) Cassandra__EndpointDetails.$(H): Cassandra__EndpointDetails.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Cassandra__IndexClause.$(O) Cassandra__IndexClause.$(C) Cassandra__IndexClause.$(H): Cassandra__IndexClause.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Cassandra__IndexExpression.$(O) Cassandra__IndexExpression.$(C) Cassandra__IndexExpression.$(H): Cassandra__IndexExpression.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Cassandra__KeyCount.$(O) Cassandra__KeyCount.$(C) Cassandra__KeyCount.$(H): Cassandra__KeyCount.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Cassandra__KeyRange.$(O) Cassandra__KeyRange.$(C) Cassandra__KeyRange.$(H): Cassandra__KeyRange.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Cassandra__KeySlice.$(O) Cassandra__KeySlice.$(C) Cassandra__KeySlice.$(H): Cassandra__KeySlice.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Cassandra__KsDef.$(O) Cassandra__KsDef.$(C) Cassandra__KsDef.$(H): Cassandra__KsDef.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Cassandra__Mutation.$(O) Cassandra__Mutation.$(C) Cassandra__Mutation.$(H): Cassandra__Mutation.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Cassandra__SlicePredicate.$(O) Cassandra__SlicePredicate.$(C) Cassandra__SlicePredicate.$(H): Cassandra__SlicePredicate.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Cassandra__SliceRange.$(O) Cassandra__SliceRange.$(C) Cassandra__SliceRange.$(H): Cassandra__SliceRange.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Cassandra__SuperColumn.$(O) Cassandra__SuperColumn.$(C) Cassandra__SuperColumn.$(H): Cassandra__SuperColumn.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Cassandra__TokenRange.$(O) Cassandra__TokenRange.$(C) Cassandra__TokenRange.$(H): Cassandra__TokenRange.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)stx_libdb_nosql_cassandra.$(O) stx_libdb_nosql_cassandra.$(C) stx_libdb_nosql_cassandra.$(H): stx_libdb_nosql_cassandra.st $(INCLUDE_TOP)\stx\libbasic\LibraryDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\ProjectDefinition.$(H) $(STCHDR)
$(OUTDIR)Cassandra__AuthenticationException.$(O) Cassandra__AuthenticationException.$(C) Cassandra__AuthenticationException.$(H): Cassandra__AuthenticationException.st $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libdb\nosql\cassandra\Cassandra__CassandraError.$(H) $(STCHDR)
$(OUTDIR)Cassandra__AuthorizationException.$(O) Cassandra__AuthorizationException.$(C) Cassandra__AuthorizationException.$(H): Cassandra__AuthorizationException.st $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libdb\nosql\cassandra\Cassandra__CassandraError.$(H) $(STCHDR)
$(OUTDIR)Cassandra__InvalidRequestException.$(O) Cassandra__InvalidRequestException.$(C) Cassandra__InvalidRequestException.$(H): Cassandra__InvalidRequestException.st $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libdb\nosql\cassandra\Cassandra__CassandraError.$(H) $(STCHDR)
$(OUTDIR)Cassandra__NotFoundException.$(O) Cassandra__NotFoundException.$(C) Cassandra__NotFoundException.$(H): Cassandra__NotFoundException.st $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libdb\nosql\cassandra\Cassandra__CassandraError.$(H) $(STCHDR)
$(OUTDIR)Cassandra__SchemaDisagreementException.$(O) Cassandra__SchemaDisagreementException.$(C) Cassandra__SchemaDisagreementException.$(H): Cassandra__SchemaDisagreementException.st $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libdb\nosql\cassandra\Cassandra__CassandraError.$(H) $(STCHDR)
$(OUTDIR)Cassandra__TimedOutException.$(O) Cassandra__TimedOutException.$(C) Cassandra__TimedOutException.$(H): Cassandra__TimedOutException.st $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libdb\nosql\cassandra\Cassandra__CassandraError.$(H) $(STCHDR)
$(OUTDIR)Cassandra__UnavailableException.$(O) Cassandra__UnavailableException.$(C) Cassandra__UnavailableException.$(H): Cassandra__UnavailableException.st $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libdb\nosql\cassandra\Cassandra__CassandraError.$(H) $(STCHDR)

# ENDMAKEDEPEND --- do not remove this line
