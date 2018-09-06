/*
 * $Header: /cvs/stx/stx/libdb/liboracle/libInit.cc,v 1.7 2007-03-23 13:55:24 stefan Exp $
 *
 * DO NOT EDIT 
 * automagically generated from the projectDefinition: stx_libdb_liboracle.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif 

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_libdb_liboracle_Init() INIT_TEXT_SECTION;
#endif

void _libstx_libdb_liboracle_Init(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_libdb_liboracle", _libstx_libdb_liboracle_Init, "stx:libdb/liboracle");
_SQL__OCI8BindDescriptor_Init(pass,__pRT__,snd);
_SQL__OCI8ColumnDescriptor_Init(pass,__pRT__,snd);
_SQL__OCI8Environment_Init(pass,__pRT__,snd);
_SQL__OCI8Handle_Init(pass,__pRT__,snd);
_SQL__OCI8Session_Init(pass,__pRT__,snd);
_SQL__OCI8Statement_Init(pass,__pRT__,snd);
_SQL__OCI8Transaction_Init(pass,__pRT__,snd);
_SQL__OCI8Variable_Init(pass,__pRT__,snd);
_SQL__OCIBuffer_Init(pass,__pRT__,snd);
_SQL__OCICursor_Init(pass,__pRT__,snd);
_SQL__OCIError_Init(pass,__pRT__,snd);
_stx_137libdb_137liboracle_Init(pass,__pRT__,snd);
_SQL__OCI8BindVariable_Init(pass,__pRT__,snd);
_SQL__OCI8DDStatement_Init(pass,__pRT__,snd);
_SQL__OCI8DefineVariable_Init(pass,__pRT__,snd);
_SQL__OCI8SelectDescriptor_Init(pass,__pRT__,snd);
_SQL__OCI8StatementWithVariables_Init(pass,__pRT__,snd);
_SQL__OCIContinueSignal_Init(pass,__pRT__,snd);
_SQL__OCIDateBuffer_Init(pass,__pRT__,snd);
_SQL__OCIDescriptorBuffer_Init(pass,__pRT__,snd);
_SQL__OCIEndOfCommunicationError_Init(pass,__pRT__,snd);
_SQL__OCIInvalidHandleError_Init(pass,__pRT__,snd);
_SQL__OCIInvalidOperationError_Init(pass,__pRT__,snd);
_SQL__OCILogOnError_Init(pass,__pRT__,snd);
_SQL__OCINoDataError_Init(pass,__pRT__,snd);
_SQL__OCINumberBuffer_Init(pass,__pRT__,snd);
_SQL__OCIRawBuffer_Init(pass,__pRT__,snd);
_SQL__OCISessionError_Init(pass,__pRT__,snd);
_SQL__OCIStringBuffer_Init(pass,__pRT__,snd);
_SQL__OCISuccessWithInfoSignal_Init(pass,__pRT__,snd);
_SQL__OCIUnhandledAttributeTypeError_Init(pass,__pRT__,snd);
_SQL__OCIUserInterruptError_Init(pass,__pRT__,snd);
_SQL__OCI8DMStatement_Init(pass,__pRT__,snd);
_SQL__OCI8DefaultDefineVariable_Init(pass,__pRT__,snd);
_SQL__OCI8DynamicDefineVariable_Init(pass,__pRT__,snd);
_SQL__OCI8MultipleValueBindVariable_Init(pass,__pRT__,snd);
_SQL__OCI8QueryStatement_Init(pass,__pRT__,snd);
_SQL__OCI8ReturnValueBindVariable_Init(pass,__pRT__,snd);
_SQL__OCI8SingleValueBindVariable_Init(pass,__pRT__,snd);
_SQL__OCIBooleanBuffer_Init(pass,__pRT__,snd);
_SQL__OCIInvalidDatabaseParameterError_Init(pass,__pRT__,snd);
_SQL__OCIInvalidUserParameterError_Init(pass,__pRT__,snd);
_SQL__OCIRowIdDescriptorBuffer_Init(pass,__pRT__,snd);


__END_PACKAGE__();
}
