/*
 * $Header: /cvs/stx/stx/goodies/loggia/libInit.cc,v 1.8 2016-12-05 11:54:43 cg Exp $
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_goodies_loggia.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_goodies_loggia_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_goodies_loggia_InitDefinition() INIT_TEXT_SECTION;
#endif

extern void _Loggia__AbstractUI_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Loggia__LogLevels_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Loggia__LogOriginatorProxy_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Loggia__LogTransport_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Loggia__LoggiaSettingsApplication_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _stx_137goodies_137loggia_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Loggia__BOSSFileTransportUI_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Loggia__CustomBlockTransport_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Loggia__CustomBlockTransportUI_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Loggia__DirectoryTransport_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Loggia__DirectoryTransportUI_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Loggia__FacilitiesUI_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Loggia__FileTransport_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Loggia__HaltingTransport_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Loggia__InMemoryTransport_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Loggia__InMemoryTransportUI_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Loggia__LogFacility_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Loggia__LogLevel_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Loggia__LogMessage_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Loggia__LogMessagesBrowserUI_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Loggia__Logger_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Loggia__LoggiaUI_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Loggia__MailTransport_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Loggia__MailTransportUI_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Loggia__MultiplexTransport_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Loggia__MultiplexTransportUI_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Loggia__NullTransport_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Loggia__PlainFileTransportUI_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Loggia__SMSTransport_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Loggia__SyslogTransport_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Loggia__SyslogTransportUI_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Loggia__TranscriptTransport_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Loggia__TransportsUI_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Loggia__BOSSFileTransport_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Loggia__PlainFileTransport_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Loggia__CSVTransport_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Loggia__LogFileTransport_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);


void _libstx_goodies_loggia_InitDefinition(int pass, struct __vmData__ *__pRT__, OBJ snd)
{
  __BEGIN_PACKAGE2__("libstx_goodies_loggia__DFN", _libstx_goodies_loggia_InitDefinition, "stx:goodies/loggia");
    _stx_137goodies_137loggia_Init(pass,__pRT__,snd);

  __END_PACKAGE__();
}

void _libstx_goodies_loggia_Init(int pass, struct __vmData__ *__pRT__, OBJ snd)
{
  __BEGIN_PACKAGE2__("libstx_goodies_loggia", _libstx_goodies_loggia_Init, "stx:goodies/loggia");
    _Loggia__AbstractUI_Init(pass,__pRT__,snd);
    _Loggia__LogLevels_Init(pass,__pRT__,snd);
    _Loggia__LogOriginatorProxy_Init(pass,__pRT__,snd);
    _Loggia__LogTransport_Init(pass,__pRT__,snd);
    _Loggia__LoggiaSettingsApplication_Init(pass,__pRT__,snd);
    _stx_137goodies_137loggia_Init(pass,__pRT__,snd);
    _Loggia__BOSSFileTransportUI_Init(pass,__pRT__,snd);
    _Loggia__CustomBlockTransport_Init(pass,__pRT__,snd);
    _Loggia__CustomBlockTransportUI_Init(pass,__pRT__,snd);
    _Loggia__DirectoryTransport_Init(pass,__pRT__,snd);
    _Loggia__DirectoryTransportUI_Init(pass,__pRT__,snd);
    _Loggia__FacilitiesUI_Init(pass,__pRT__,snd);
    _Loggia__FileTransport_Init(pass,__pRT__,snd);
    _Loggia__HaltingTransport_Init(pass,__pRT__,snd);
    _Loggia__InMemoryTransport_Init(pass,__pRT__,snd);
    _Loggia__InMemoryTransportUI_Init(pass,__pRT__,snd);
    _Loggia__LogFacility_Init(pass,__pRT__,snd);
    _Loggia__LogLevel_Init(pass,__pRT__,snd);
    _Loggia__LogMessage_Init(pass,__pRT__,snd);
    _Loggia__LogMessagesBrowserUI_Init(pass,__pRT__,snd);
    _Loggia__Logger_Init(pass,__pRT__,snd);
    _Loggia__LoggiaUI_Init(pass,__pRT__,snd);
    _Loggia__MailTransport_Init(pass,__pRT__,snd);
    _Loggia__MailTransportUI_Init(pass,__pRT__,snd);
    _Loggia__MultiplexTransport_Init(pass,__pRT__,snd);
    _Loggia__MultiplexTransportUI_Init(pass,__pRT__,snd);
    _Loggia__NullTransport_Init(pass,__pRT__,snd);
    _Loggia__PlainFileTransportUI_Init(pass,__pRT__,snd);
    _Loggia__SMSTransport_Init(pass,__pRT__,snd);
    _Loggia__SyslogTransport_Init(pass,__pRT__,snd);
    _Loggia__SyslogTransportUI_Init(pass,__pRT__,snd);
    _Loggia__TranscriptTransport_Init(pass,__pRT__,snd);
    _Loggia__TransportsUI_Init(pass,__pRT__,snd);
    _Loggia__BOSSFileTransport_Init(pass,__pRT__,snd);
    _Loggia__PlainFileTransport_Init(pass,__pRT__,snd);
    _Loggia__CSVTransport_Init(pass,__pRT__,snd);
    _Loggia__LogFileTransport_Init(pass,__pRT__,snd);


  __END_PACKAGE__();
}
