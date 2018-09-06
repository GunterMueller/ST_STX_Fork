/*
 * $Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/tests/libInit.cc,v 1.2 2011-10-04 16:44:58 cg Exp $
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_goodies_communication_dolphinHTTP_tests.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_goodies_communication_dolphinHTTP_tests_Init() INIT_TEXT_SECTION;
// DLL_EXPORT void _libstx_goodies_communication_dolphinHTTP_tests_InitDefinition() INIT_TEXT_SECTION;
#endif

// void _libstx_goodies_communication_dolphinHTTP_tests_InitDefinition(pass, __pRT__, snd)
// OBJ snd; struct __vmData__ *__pRT__; {
// __BEGIN_PACKAGE2__("libstx_goodies_communication_dolphinHTTP_tests__DFN", _libstx_goodies_communication_dolphinHTTP_tests_InitDefinition, "stx:goodies/communication/dolphinHTTP/tests");
// _stx_137goodies_137communication_137dolphinHTTP_137tests_Init(pass,__pRT__,snd);

// __END_PACKAGE__();
// }

void _libstx_goodies_communication_dolphinHTTP_tests_Init(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_goodies_communication_dolphinHTTP_tests", _libstx_goodies_communication_dolphinHTTP_tests_Init, "stx:goodies/communication/dolphinHTTP/tests");
_SptHTTPProxyTestExept_Init(pass,__pRT__,snd);
_stx_137goodies_137communication_137dolphinHTTP_137tests_Init(pass,__pRT__,snd);


__END_PACKAGE__();
}
