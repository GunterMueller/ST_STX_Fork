/*
 * $Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/libInit.cc,v 1.2 2011-10-04 16:46:18 cg Exp $
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_goodies_communication_dolphinHTTP.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_goodies_communication_dolphinHTTP_Init() INIT_TEXT_SECTION;
// DLL_EXPORT void _libstx_goodies_communication_dolphinHTTP_InitDefinition() INIT_TEXT_SECTION;
#endif

// void _libstx_goodies_communication_dolphinHTTP_InitDefinition(pass, __pRT__, snd)
// OBJ snd; struct __vmData__ *__pRT__; {
// __BEGIN_PACKAGE2__("libstx_goodies_communication_dolphinHTTP__DFN", _libstx_goodies_communication_dolphinHTTP_InitDefinition, "stx:goodies/communication/dolphinHTTP");
// _stx_137goodies_137communication_137dolphinHTTP_Init(pass,__pRT__,snd);

// __END_PACKAGE__();
// }

void _libstx_goodies_communication_dolphinHTTP_Init(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_goodies_communication_dolphinHTTP", _libstx_goodies_communication_dolphinHTTP_Init, "stx:goodies/communication/dolphinHTTP");
_SWSU_Init(pass,__pRT__,snd);
_SZReadWriteSocketStream_Init(pass,__pRT__,snd);
_SptCredentials_Init(pass,__pRT__,snd);
_SptHTTPAuthorizationDialog_Init(pass,__pRT__,snd);
_SptHTTPChallenge_Init(pass,__pRT__,snd);
_SptHTTPConfiguration_Init(pass,__pRT__,snd);
_SptHTTPConnection_Init(pass,__pRT__,snd);
_SptHTTPCookie_Init(pass,__pRT__,snd);
_SptHTTPCookieJar_Init(pass,__pRT__,snd);
_SptHTTPEntity_Init(pass,__pRT__,snd);
_SptHTTPError_Init(pass,__pRT__,snd);
_SptHTTPHostCache_Init(pass,__pRT__,snd);
_SptHTTPNotAuthorized_Init(pass,__pRT__,snd);
_SptHTTPProgressAbstract_Init(pass,__pRT__,snd);
_SptHTTPProxySettings_Init(pass,__pRT__,snd);
_SptHTTPRequest_Init(pass,__pRT__,snd);
_SptHTTPResponse_Init(pass,__pRT__,snd);
_SptHTTPSessionState_Init(pass,__pRT__,snd);
_SptHTTPStatus_Init(pass,__pRT__,snd);
_SptHTTPUrl_Init(pass,__pRT__,snd);
_SptHTTPUser_Init(pass,__pRT__,snd);
_stx_137goodies_137communication_137dolphinHTTP_Init(pass,__pRT__,snd);
_SZLoggingSocketStream_Init(pass,__pRT__,snd);
_SptBasicCredentials_Init(pass,__pRT__,snd);
_SptHTTPClientError_Init(pass,__pRT__,snd);
_SptHTTPProgress_Init(pass,__pRT__,snd);
_SptHTTPProgressDev_Init(pass,__pRT__,snd);
_SptHTTPSConnection_Init(pass,__pRT__,snd);
_SptHTTPServerError_Init(pass,__pRT__,snd);
_SptHTTPTestProgress_Init(pass,__pRT__,snd);
_SptHTTPTranscriptProgress_Init(pass,__pRT__,snd);
_SptHTTPTriggerProgress_Init(pass,__pRT__,snd);
_SptHTTPValueProgress_Init(pass,__pRT__,snd);


__END_PACKAGE__();
}
