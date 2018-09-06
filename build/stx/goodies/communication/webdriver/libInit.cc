/*
 * $Header: /cvs/stx/stx/goodies/communication/webdriver/libInit.cc,v 1.3 2018-06-21 16:52:13 cg Exp $
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_goodies_communication_webdriver.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_goodies_communication_webdriver_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_goodies_communication_webdriver_InitDefinition() INIT_TEXT_SECTION;
#endif

extern void _WDException_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _WDHttpResponse_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _WDServerObject_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _WDSmalltalkPlatform_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _WDWebDriver_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _stx_137goodies_137communication_137webdriver_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _WDCapabilities_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _WDChromeDriver_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _WDCookie_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _WDDriverNotAvailableException_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _WDNoSuchElementException_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _WDPharoPlatform_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _WDServerBuild_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _WDServerPlatform_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _WDServerStatus_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _WDSession_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _WDSmalltalkXPlatform_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _WDStaleElementReferenceException_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _WDStatusNotAvailableException_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _WDUnsupportedCommandException_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _WDDesiredCapabilities_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);


void _libstx_goodies_communication_webdriver_InitDefinition(int pass, struct __vmData__ *__pRT__, OBJ snd)
{
  __BEGIN_PACKAGE2__("libstx_goodies_communication_webdriver__DFN", _libstx_goodies_communication_webdriver_InitDefinition, "stx:goodies/communication/webdriver");
    _stx_137goodies_137communication_137webdriver_Init(pass,__pRT__,snd);

  __END_PACKAGE__();
}

void _libstx_goodies_communication_webdriver_Init(int pass, struct __vmData__ *__pRT__, OBJ snd)
{
  __BEGIN_PACKAGE2__("libstx_goodies_communication_webdriver", _libstx_goodies_communication_webdriver_Init, "stx:goodies/communication/webdriver");
    _WDException_Init(pass,__pRT__,snd);
    _WDHttpResponse_Init(pass,__pRT__,snd);
    _WDServerObject_Init(pass,__pRT__,snd);
    _WDSmalltalkPlatform_Init(pass,__pRT__,snd);
    _WDWebDriver_Init(pass,__pRT__,snd);
    _stx_137goodies_137communication_137webdriver_Init(pass,__pRT__,snd);
    _WDCapabilities_Init(pass,__pRT__,snd);
    _WDChromeDriver_Init(pass,__pRT__,snd);
    _WDCookie_Init(pass,__pRT__,snd);
    _WDDriverNotAvailableException_Init(pass,__pRT__,snd);
    _WDNoSuchElementException_Init(pass,__pRT__,snd);
    _WDPharoPlatform_Init(pass,__pRT__,snd);
    _WDServerBuild_Init(pass,__pRT__,snd);
    _WDServerPlatform_Init(pass,__pRT__,snd);
    _WDServerStatus_Init(pass,__pRT__,snd);
    _WDSession_Init(pass,__pRT__,snd);
    _WDSmalltalkXPlatform_Init(pass,__pRT__,snd);
    _WDStaleElementReferenceException_Init(pass,__pRT__,snd);
    _WDStatusNotAvailableException_Init(pass,__pRT__,snd);
    _WDUnsupportedCommandException_Init(pass,__pRT__,snd);
    _WDDesiredCapabilities_Init(pass,__pRT__,snd);


  __END_PACKAGE__();
}
