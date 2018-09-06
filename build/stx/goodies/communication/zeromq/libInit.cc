/*
 * $Header: /cvs/stx/stx/goodies/communication/zeromq/libInit.cc,v 1.4 2018-05-11 00:03:35 cg Exp $
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_goodies_communication_zeromq.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_goodies_communication_zeromq_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_goodies_communication_zeromq_InitDefinition() INIT_TEXT_SECTION;
#endif

extern void _ZmqApi_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ZmqApiConstants_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ZmqApiContext_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ZmqApiMessage_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ZmqApiPollItem_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ZmqApiPollItemV4_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ZmqApiSize_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ZmqApiSocket_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ZmqApiStructForInt_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ZmqContext_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ZmqEventFilter_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ZmqLog_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ZmqResource_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ZmqSocket_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ZmqSocketAssociation_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ZmqTerminatedContext_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ZmqVersion_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _stx_137goodies_137communication_137zeromq_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Zmq2Api_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Zmq3Api_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ZmqDealerSocket_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ZmqGlobalPoller_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ZmqPairSocket_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ZmqPollIn_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ZmqPollOut_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ZmqPoller_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ZmqPublisherSocket_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ZmqPullSocket_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ZmqPushSocket_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ZmqRequestSocket_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ZmqResponseSocket_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ZmqRouterSocket_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ZmqSocketBind_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ZmqSocketConnection_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ZmqSubscriberSocket_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Zmq4Api_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);


void _libstx_goodies_communication_zeromq_InitDefinition(int pass, struct __vmData__ *__pRT__, OBJ snd)
{
  __BEGIN_PACKAGE2__("libstx_goodies_communication_zeromq__DFN", _libstx_goodies_communication_zeromq_InitDefinition, "stx:goodies/communication/zeromq");
    _stx_137goodies_137communication_137zeromq_Init(pass,__pRT__,snd);

  __END_PACKAGE__();
}

void _libstx_goodies_communication_zeromq_Init(int pass, struct __vmData__ *__pRT__, OBJ snd)
{
  __BEGIN_PACKAGE2__("libstx_goodies_communication_zeromq", _libstx_goodies_communication_zeromq_Init, "stx:goodies/communication/zeromq");
    _ZmqApi_Init(pass,__pRT__,snd);
    _ZmqApiConstants_Init(pass,__pRT__,snd);
    _ZmqApiContext_Init(pass,__pRT__,snd);
    _ZmqApiMessage_Init(pass,__pRT__,snd);
    _ZmqApiPollItem_Init(pass,__pRT__,snd);
    _ZmqApiPollItemV4_Init(pass,__pRT__,snd);
    _ZmqApiSize_Init(pass,__pRT__,snd);
    _ZmqApiSocket_Init(pass,__pRT__,snd);
    _ZmqApiStructForInt_Init(pass,__pRT__,snd);
    _ZmqContext_Init(pass,__pRT__,snd);
    _ZmqEventFilter_Init(pass,__pRT__,snd);
    _ZmqLog_Init(pass,__pRT__,snd);
    _ZmqResource_Init(pass,__pRT__,snd);
    _ZmqSocket_Init(pass,__pRT__,snd);
    _ZmqSocketAssociation_Init(pass,__pRT__,snd);
    _ZmqTerminatedContext_Init(pass,__pRT__,snd);
    _ZmqVersion_Init(pass,__pRT__,snd);
    _stx_137goodies_137communication_137zeromq_Init(pass,__pRT__,snd);
    _Zmq2Api_Init(pass,__pRT__,snd);
    _Zmq3Api_Init(pass,__pRT__,snd);
    _ZmqDealerSocket_Init(pass,__pRT__,snd);
    _ZmqGlobalPoller_Init(pass,__pRT__,snd);
    _ZmqPairSocket_Init(pass,__pRT__,snd);
    _ZmqPollIn_Init(pass,__pRT__,snd);
    _ZmqPollOut_Init(pass,__pRT__,snd);
    _ZmqPoller_Init(pass,__pRT__,snd);
    _ZmqPublisherSocket_Init(pass,__pRT__,snd);
    _ZmqPullSocket_Init(pass,__pRT__,snd);
    _ZmqPushSocket_Init(pass,__pRT__,snd);
    _ZmqRequestSocket_Init(pass,__pRT__,snd);
    _ZmqResponseSocket_Init(pass,__pRT__,snd);
    _ZmqRouterSocket_Init(pass,__pRT__,snd);
    _ZmqSocketBind_Init(pass,__pRT__,snd);
    _ZmqSocketConnection_Init(pass,__pRT__,snd);
    _ZmqSubscriberSocket_Init(pass,__pRT__,snd);
    _Zmq4Api_Init(pass,__pRT__,snd);


  __END_PACKAGE__();
}
