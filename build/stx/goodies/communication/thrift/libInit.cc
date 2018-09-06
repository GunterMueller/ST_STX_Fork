/*
 * $Header: /cvs/stx/stx/goodies/communication/thrift/libInit.cc,v 1.4 2013-03-21 10:34:43 cg Exp $
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_goodies_communication_thrift.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_goodies_communication_thrift_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_goodies_communication_thrift_InitDefinition() INIT_TEXT_SECTION;
#endif

void _libstx_goodies_communication_thrift_InitDefinition(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_goodies_communication_thrift__DFN", _libstx_goodies_communication_thrift_InitDefinition, "stx:goodies/communication/thrift");
_stx_137goodies_137communication_137thrift_Init(pass,__pRT__,snd);

__END_PACKAGE__();
}

void _libstx_goodies_communication_thrift_Init(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_goodies_communication_thrift", _libstx_goodies_communication_thrift_Init, "stx:goodies/communication/thrift");
_TClient_Init(pass,__pRT__,snd);
_TConstants_Init(pass,__pRT__,snd);
_TError_Init(pass,__pRT__,snd);
_TField_Init(pass,__pRT__,snd);
_TMessage_Init(pass,__pRT__,snd);
_TResult_Init(pass,__pRT__,snd);
_TSizedObject_Init(pass,__pRT__,snd);
_TStruct_Init(pass,__pRT__,snd);
_TTransport_Init(pass,__pRT__,snd);
_TType_Init(pass,__pRT__,snd);
_stx_137goodies_137communication_137thrift_Init(pass,__pRT__,snd);
_TCallMessage_Init(pass,__pRT__,snd);
_TFramedTransport_Init(pass,__pRT__,snd);
_TList_Init(pass,__pRT__,snd);
_TMap_Init(pass,__pRT__,snd);
_TProtocol_Init(pass,__pRT__,snd);
_TProtocolError_Init(pass,__pRT__,snd);
_TTransportError_Init(pass,__pRT__,snd);
_TBinaryProtocol_Init(pass,__pRT__,snd);
_TSet_Init(pass,__pRT__,snd);
_TTransportClosedError_Init(pass,__pRT__,snd);


__END_PACKAGE__();
}
