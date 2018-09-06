/*
 * $Header: /cvs/stx/stx/goodies/communication/messagePack/libInit.cc,v 1.4 2018-05-08 15:37:26 cg Exp $
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_goodies_communication_messagePack.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_goodies_communication_messagePack_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_goodies_communication_messagePack_InitDefinition() INIT_TEXT_SECTION;
#endif

extern void _MpConstants_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _MpConstantsPool_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _MpDecoder_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _MpError_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _MpExtValue_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _MpMemoryWriteStream_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _MpMessagePack_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _MpPortableUtil_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _MpSettings_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _MpTypeMapper_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _stx_137goodies_137communication_137messagePack_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _MpDecodeTypeMapper_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _MpEncodeTypeMapper_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _MpEncoder_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _MpFixextValue_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _MpSqPortableUtil_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _MpSTXEncodeTypeMapper_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _MpSqEncodeTypeMapper_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);


void _libstx_goodies_communication_messagePack_InitDefinition(int pass, struct __vmData__ *__pRT__, OBJ snd)
{
  __BEGIN_PACKAGE2__("libstx_goodies_communication_messagePack__DFN", _libstx_goodies_communication_messagePack_InitDefinition, "stx:goodies/communication/messagePack");
    _stx_137goodies_137communication_137messagePack_Init(pass,__pRT__,snd);

  __END_PACKAGE__();
}

void _libstx_goodies_communication_messagePack_Init(int pass, struct __vmData__ *__pRT__, OBJ snd)
{
  __BEGIN_PACKAGE2__("libstx_goodies_communication_messagePack", _libstx_goodies_communication_messagePack_Init, "stx:goodies/communication/messagePack");
    _MpConstants_Init(pass,__pRT__,snd);
    _MpConstantsPool_Init(pass,__pRT__,snd);
    _MpDecoder_Init(pass,__pRT__,snd);
    _MpError_Init(pass,__pRT__,snd);
    _MpExtValue_Init(pass,__pRT__,snd);
    _MpMemoryWriteStream_Init(pass,__pRT__,snd);
    _MpMessagePack_Init(pass,__pRT__,snd);
    _MpPortableUtil_Init(pass,__pRT__,snd);
    _MpSettings_Init(pass,__pRT__,snd);
    _MpTypeMapper_Init(pass,__pRT__,snd);
    _stx_137goodies_137communication_137messagePack_Init(pass,__pRT__,snd);
    _MpDecodeTypeMapper_Init(pass,__pRT__,snd);
    _MpEncodeTypeMapper_Init(pass,__pRT__,snd);
    _MpEncoder_Init(pass,__pRT__,snd);
    _MpFixextValue_Init(pass,__pRT__,snd);
    _MpSqPortableUtil_Init(pass,__pRT__,snd);
    _MpSTXEncodeTypeMapper_Init(pass,__pRT__,snd);
    _MpSqEncodeTypeMapper_Init(pass,__pRT__,snd);

    _stx_137goodies_137communication_137messagePack_extensions_Init(pass,__pRT__,snd);
  __END_PACKAGE__();
}
