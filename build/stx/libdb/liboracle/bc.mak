# $Header: /cvs/stx/stx/libdb/liboracle/bc.mak,v 1.6 2013-05-28 10:32:54 cg Exp $
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_libdb_liboracle.
#
# Warning: once you modify this file, do not rerun
# stmkmp or projectDefinition-build again - otherwise, your changes are lost.
#
# This file contains make rules for the win32 platform (using borland-bcc).
# It shares common definitions with the unix-make in Make.spec.
# The nt.mak supports the following targets:
#    bmake         - compile all st-files to a classLib (dll)
#    bmake clean   - clean all temp files
#    bmake clobber - clean all
#
#
TOP=..\..
INCLUDE_TOP=$(TOP)\..

!INCLUDE $(TOP)\rules\stdHeader_bc

!INCLUDE Make.spec

LIBNAME=libstx_libdb_liboracle
RESFILES=liboracle.$(RES)
LOCALINCLUDES=-I$$ORACLE_HOME\sdk\include -I$$ORACLE_HOME\rdbms\public -I$$ORACLE_HOME\rdbms\demo -I$$ORACLE_HOME\network\public -I$(INCLUDE_TOP)\stx\libbasic -I$(INCLUDE_TOP)\stx\libdb

STCLOCALOPT=-package=$(PACKAGE) -I. $(LOCALINCLUDES) -H. $(STCLOCALOPTIMIZATIONS) $(STCWARNINGS) $(LOCALDEFINES)  -varPrefix=$(LIBNAME)
LOCALLIBS=



OBJS= $(COMMON_OBJS) $(WIN32_OBJS)

ALL::  $(OUTDIR) $(OUTDIR)$(LIBNAME).dll

!INCLUDE $(TOP)\rules\stdRules_bc



# BEGINMAKEDEPEND --- do not remove this line; make depend needs it
$(OUTDIR)OCI8BindDescriptor.$(O) OCI8BindDescriptor.$(H): OCI8BindDescriptor.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)OCI8ColumnDescriptor.$(O) OCI8ColumnDescriptor.$(H): OCI8ColumnDescriptor.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)OCI8Environment.$(O) OCI8Environment.$(H): OCI8Environment.st $(INCLUDE_TOP)\stx\libdb\Database.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)OCI8Handle.$(O) OCI8Handle.$(H): OCI8Handle.st $(INCLUDE_TOP)\stx\libdb\DatabaseHandle.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalAddress.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)OCI8Session.$(O) OCI8Session.$(H): OCI8Session.st $(INCLUDE_TOP)\stx\libdb\DatabaseSession.$(H) $(INCLUDE_TOP)\stx\libdb\Connection.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)OCI8Statement.$(O) OCI8Statement.$(H): OCI8Statement.st $(INCLUDE_TOP)\stx\libdb\Statement.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)OCI8Transaction.$(O) OCI8Transaction.$(H): OCI8Transaction.st $(INCLUDE_TOP)\stx\libdb\Transaction.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)OCI8Variable.$(O) OCI8Variable.$(H): OCI8Variable.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)OCIBuffer.$(O) OCIBuffer.$(H): OCIBuffer.st $(INCLUDE_TOP)\stx\libbasic\Visitor.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)OCICursor.$(O) OCICursor.$(H): OCICursor.st $(INCLUDE_TOP)\stx\libdb\Cursor.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)OCIError.$(O) OCIError.$(H): OCIError.st $(INCLUDE_TOP)\stx\libdb\SQLError.$(H) $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)stx_libdb_liboracle.$(O) stx_libdb_liboracle.$(H): stx_libdb_liboracle.st $(INCLUDE_TOP)\stx\libbasic\LibraryDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\ProjectDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)OCI8BindVariable.$(O) OCI8BindVariable.$(H): OCI8BindVariable.st $(INCLUDE_TOP)\stx\libdb\liboracle\OCI8Variable.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)OCI8DDStatement.$(O) OCI8DDStatement.$(H): OCI8DDStatement.st $(INCLUDE_TOP)\stx\libdb\liboracle\OCI8Statement.$(H) $(INCLUDE_TOP)\stx\libdb\Statement.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)OCI8DefineVariable.$(O) OCI8DefineVariable.$(H): OCI8DefineVariable.st $(INCLUDE_TOP)\stx\libdb\liboracle\OCI8Variable.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)OCI8SelectDescriptor.$(O) OCI8SelectDescriptor.$(H): OCI8SelectDescriptor.st $(INCLUDE_TOP)\stx\libdb\liboracle\OCI8ColumnDescriptor.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)OCI8StatementWithVariables.$(O) OCI8StatementWithVariables.$(H): OCI8StatementWithVariables.st $(INCLUDE_TOP)\stx\libdb\liboracle\OCI8Statement.$(H) $(INCLUDE_TOP)\stx\libdb\Statement.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)OCIContinueSignal.$(O) OCIContinueSignal.$(H): OCIContinueSignal.st $(INCLUDE_TOP)\stx\libdb\liboracle\OCIError.$(H) $(INCLUDE_TOP)\stx\libdb\SQLError.$(H) $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)OCIDateBuffer.$(O) OCIDateBuffer.$(H): OCIDateBuffer.st $(INCLUDE_TOP)\stx\libdb\liboracle\OCIBuffer.$(H) $(INCLUDE_TOP)\stx\libbasic\Visitor.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)OCIDescriptorBuffer.$(O) OCIDescriptorBuffer.$(H): OCIDescriptorBuffer.st $(INCLUDE_TOP)\stx\libdb\liboracle\OCIBuffer.$(H) $(INCLUDE_TOP)\stx\libbasic\Visitor.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)OCIEndOfCommunicationError.$(O) OCIEndOfCommunicationError.$(H): OCIEndOfCommunicationError.st $(INCLUDE_TOP)\stx\libdb\liboracle\OCIError.$(H) $(INCLUDE_TOP)\stx\libdb\SQLError.$(H) $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)OCIInvalidHandleError.$(O) OCIInvalidHandleError.$(H): OCIInvalidHandleError.st $(INCLUDE_TOP)\stx\libdb\liboracle\OCIError.$(H) $(INCLUDE_TOP)\stx\libdb\SQLError.$(H) $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)OCIInvalidOperationError.$(O) OCIInvalidOperationError.$(H): OCIInvalidOperationError.st $(INCLUDE_TOP)\stx\libdb\liboracle\OCIError.$(H) $(INCLUDE_TOP)\stx\libdb\SQLError.$(H) $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)OCILogOnError.$(O) OCILogOnError.$(H): OCILogOnError.st $(INCLUDE_TOP)\stx\libdb\liboracle\OCIError.$(H) $(INCLUDE_TOP)\stx\libdb\SQLError.$(H) $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)OCINoDataError.$(O) OCINoDataError.$(H): OCINoDataError.st $(INCLUDE_TOP)\stx\libdb\liboracle\OCIError.$(H) $(INCLUDE_TOP)\stx\libdb\SQLError.$(H) $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)OCINumberBuffer.$(O) OCINumberBuffer.$(H): OCINumberBuffer.st $(INCLUDE_TOP)\stx\libdb\liboracle\OCIBuffer.$(H) $(INCLUDE_TOP)\stx\libbasic\Visitor.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)OCIRawBuffer.$(O) OCIRawBuffer.$(H): OCIRawBuffer.st $(INCLUDE_TOP)\stx\libdb\liboracle\OCIBuffer.$(H) $(INCLUDE_TOP)\stx\libbasic\Visitor.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)OCISessionError.$(O) OCISessionError.$(H): OCISessionError.st $(INCLUDE_TOP)\stx\libdb\liboracle\OCIError.$(H) $(INCLUDE_TOP)\stx\libdb\SQLError.$(H) $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)OCIStringBuffer.$(O) OCIStringBuffer.$(H): OCIStringBuffer.st $(INCLUDE_TOP)\stx\libdb\liboracle\OCIBuffer.$(H) $(INCLUDE_TOP)\stx\libbasic\Visitor.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)OCISuccessWithInfoSignal.$(O) OCISuccessWithInfoSignal.$(H): OCISuccessWithInfoSignal.st $(INCLUDE_TOP)\stx\libdb\liboracle\OCIError.$(H) $(INCLUDE_TOP)\stx\libdb\SQLError.$(H) $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)OCIUnhandledAttributeTypeError.$(O) OCIUnhandledAttributeTypeError.$(H): OCIUnhandledAttributeTypeError.st $(INCLUDE_TOP)\stx\libdb\liboracle\OCIError.$(H) $(INCLUDE_TOP)\stx\libdb\SQLError.$(H) $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)OCIUserInterruptError.$(O) OCIUserInterruptError.$(H): OCIUserInterruptError.st $(INCLUDE_TOP)\stx\libdb\liboracle\OCIError.$(H) $(INCLUDE_TOP)\stx\libdb\SQLError.$(H) $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)OCI8DMStatement.$(O) OCI8DMStatement.$(H): OCI8DMStatement.st $(INCLUDE_TOP)\stx\libdb\liboracle\OCI8StatementWithVariables.$(H) $(INCLUDE_TOP)\stx\libdb\liboracle\OCI8Statement.$(H) $(INCLUDE_TOP)\stx\libdb\Statement.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)OCI8DefaultDefineVariable.$(O) OCI8DefaultDefineVariable.$(H): OCI8DefaultDefineVariable.st $(INCLUDE_TOP)\stx\libdb\liboracle\OCI8DefineVariable.$(H) $(INCLUDE_TOP)\stx\libdb\liboracle\OCI8Variable.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)OCI8DynamicDefineVariable.$(O) OCI8DynamicDefineVariable.$(H): OCI8DynamicDefineVariable.st $(INCLUDE_TOP)\stx\libdb\liboracle\OCI8DefineVariable.$(H) $(INCLUDE_TOP)\stx\libdb\liboracle\OCI8Variable.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)OCI8MultipleValueBindVariable.$(O) OCI8MultipleValueBindVariable.$(H): OCI8MultipleValueBindVariable.st $(INCLUDE_TOP)\stx\libdb\liboracle\OCI8BindVariable.$(H) $(INCLUDE_TOP)\stx\libdb\liboracle\OCI8Variable.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)OCI8QueryStatement.$(O) OCI8QueryStatement.$(H): OCI8QueryStatement.st $(INCLUDE_TOP)\stx\libdb\liboracle\OCI8StatementWithVariables.$(H) $(INCLUDE_TOP)\stx\libdb\liboracle\OCI8Statement.$(H) $(INCLUDE_TOP)\stx\libdb\Statement.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)OCI8ReturnValueBindVariable.$(O) OCI8ReturnValueBindVariable.$(H): OCI8ReturnValueBindVariable.st $(INCLUDE_TOP)\stx\libdb\liboracle\OCI8BindVariable.$(H) $(INCLUDE_TOP)\stx\libdb\liboracle\OCI8Variable.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)OCI8SingleValueBindVariable.$(O) OCI8SingleValueBindVariable.$(H): OCI8SingleValueBindVariable.st $(INCLUDE_TOP)\stx\libdb\liboracle\OCI8BindVariable.$(H) $(INCLUDE_TOP)\stx\libdb\liboracle\OCI8Variable.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)OCIBooleanBuffer.$(O) OCIBooleanBuffer.$(H): OCIBooleanBuffer.st $(INCLUDE_TOP)\stx\libdb\liboracle\OCIStringBuffer.$(H) $(INCLUDE_TOP)\stx\libdb\liboracle\OCIBuffer.$(H) $(INCLUDE_TOP)\stx\libbasic\Visitor.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)OCIInvalidDatabaseParameterError.$(O) OCIInvalidDatabaseParameterError.$(H): OCIInvalidDatabaseParameterError.st $(INCLUDE_TOP)\stx\libdb\liboracle\OCILogOnError.$(H) $(INCLUDE_TOP)\stx\libdb\liboracle\OCIError.$(H) $(INCLUDE_TOP)\stx\libdb\SQLError.$(H) $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)OCIInvalidUserParameterError.$(O) OCIInvalidUserParameterError.$(H): OCIInvalidUserParameterError.st $(INCLUDE_TOP)\stx\libdb\liboracle\OCILogOnError.$(H) $(INCLUDE_TOP)\stx\libdb\liboracle\OCIError.$(H) $(INCLUDE_TOP)\stx\libdb\SQLError.$(H) $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)OCIRowIdDescriptorBuffer.$(O) OCIRowIdDescriptorBuffer.$(H): OCIRowIdDescriptorBuffer.st $(INCLUDE_TOP)\stx\libdb\liboracle\OCIDescriptorBuffer.$(H) $(INCLUDE_TOP)\stx\libdb\liboracle\OCIBuffer.$(H) $(INCLUDE_TOP)\stx\libbasic\Visitor.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)

# ENDMAKEDEPEND --- do not remove this line
