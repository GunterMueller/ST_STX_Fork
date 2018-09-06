/*
 * $Header: /cvs/stx/stx/goodies/communication/webdriverService/libInit.cc,v 1.4 2018-07-22 09:55:56 cg Exp $
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_goodies_communication_webdriverService.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_goodies_communication_webdriverService_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_goodies_communication_webdriverService_InitDefinition() INIT_TEXT_SECTION;
#endif

extern void _SmalltalkWebDriverElement_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _SmalltalkWebDriverInterface_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _SmalltalkWebDriverSession_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _stx_137goodies_137communication_137webdriverService_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);


void _libstx_goodies_communication_webdriverService_InitDefinition(int pass, struct __vmData__ *__pRT__, OBJ snd)
{
  __BEGIN_PACKAGE2__("libstx_goodies_communication_webdriverService__DFN", _libstx_goodies_communication_webdriverService_InitDefinition, "stx:goodies/communication/webdriverService");
    _stx_137goodies_137communication_137webdriverService_Init(pass,__pRT__,snd);

  __END_PACKAGE__();
}

void _libstx_goodies_communication_webdriverService_Init(int pass, struct __vmData__ *__pRT__, OBJ snd)
{
  __BEGIN_PACKAGE2__("libstx_goodies_communication_webdriverService", _libstx_goodies_communication_webdriverService_Init, "stx:goodies/communication/webdriverService");
    _SmalltalkWebDriverElement_Init(pass,__pRT__,snd);
    _SmalltalkWebDriverInterface_Init(pass,__pRT__,snd);
    _SmalltalkWebDriverSession_Init(pass,__pRT__,snd);
    _stx_137goodies_137communication_137webdriverService_Init(pass,__pRT__,snd);


  __END_PACKAGE__();
}
