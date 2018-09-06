/*
 * $Header: /cvs/stx/stx/goodies/communication/ssdp/tests/libInit.cc,v 1.1 2018-05-14 20:30:41 cg Exp $
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_goodies_communication_ssdp_tests.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_goodies_communication_ssdp_tests_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_goodies_communication_ssdp_tests_InitDefinition() INIT_TEXT_SECTION;
#endif

extern void _SSDPTests_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _stx_137goodies_137communication_137ssdp_137tests_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);


void _libstx_goodies_communication_ssdp_tests_InitDefinition(int pass, struct __vmData__ *__pRT__, OBJ snd)
{
  __BEGIN_PACKAGE2__("libstx_goodies_communication_ssdp_tests__DFN", _libstx_goodies_communication_ssdp_tests_InitDefinition, "stx:goodies/communication/ssdp/tests");
    _stx_137goodies_137communication_137ssdp_137tests_Init(pass,__pRT__,snd);

  __END_PACKAGE__();
}

void _libstx_goodies_communication_ssdp_tests_Init(int pass, struct __vmData__ *__pRT__, OBJ snd)
{
  __BEGIN_PACKAGE2__("libstx_goodies_communication_ssdp_tests", _libstx_goodies_communication_ssdp_tests_Init, "stx:goodies/communication/ssdp/tests");
    _SSDPTests_Init(pass,__pRT__,snd);
    _stx_137goodies_137communication_137ssdp_137tests_Init(pass,__pRT__,snd);


  __END_PACKAGE__();
}
