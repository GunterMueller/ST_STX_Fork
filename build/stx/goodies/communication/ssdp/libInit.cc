/*
 * $Header: /cvs/stx/stx/goodies/communication/ssdp/libInit.cc,v 1.2 2018-05-13 18:16:33 cg Exp $
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_goodies_communication_ssdp.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_goodies_communication_ssdp_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_goodies_communication_ssdp_InitDefinition() INIT_TEXT_SECTION;
#endif

extern void _SSDPCache_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _SSDPMessage_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _SSDPParticipant_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _SSDPService_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _stx_137goodies_137communication_137ssdp_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _SSDPAvailable_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _SSDPClient_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _SSDPDiscoveryReply_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _SSDPDiscoveryRequest_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _SSDPServer_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _SSDPUnavailable_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);


void _libstx_goodies_communication_ssdp_InitDefinition(int pass, struct __vmData__ *__pRT__, OBJ snd)
{
  __BEGIN_PACKAGE2__("libstx_goodies_communication_ssdp__DFN", _libstx_goodies_communication_ssdp_InitDefinition, "stx:goodies/communication/ssdp");
    _stx_137goodies_137communication_137ssdp_Init(pass,__pRT__,snd);

  __END_PACKAGE__();
}

void _libstx_goodies_communication_ssdp_Init(int pass, struct __vmData__ *__pRT__, OBJ snd)
{
  __BEGIN_PACKAGE2__("libstx_goodies_communication_ssdp", _libstx_goodies_communication_ssdp_Init, "stx:goodies/communication/ssdp");
    _SSDPCache_Init(pass,__pRT__,snd);
    _SSDPMessage_Init(pass,__pRT__,snd);
    _SSDPParticipant_Init(pass,__pRT__,snd);
    _SSDPService_Init(pass,__pRT__,snd);
    _stx_137goodies_137communication_137ssdp_Init(pass,__pRT__,snd);
    _SSDPAvailable_Init(pass,__pRT__,snd);
    _SSDPClient_Init(pass,__pRT__,snd);
    _SSDPDiscoveryReply_Init(pass,__pRT__,snd);
    _SSDPDiscoveryRequest_Init(pass,__pRT__,snd);
    _SSDPServer_Init(pass,__pRT__,snd);
    _SSDPUnavailable_Init(pass,__pRT__,snd);

  __END_PACKAGE__();
}
