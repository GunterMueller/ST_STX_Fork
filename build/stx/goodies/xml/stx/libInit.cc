/*
 * $Header: /cvs/stx/stx/goodies/xml/stx/libInit.cc,v 1.20 2018-05-03 23:40:25 cg Exp $
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_goodies_xml_stx.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_goodies_xml_stx_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_goodies_xml_stx_InitDefinition() INIT_TEXT_SECTION;
#endif

extern void _XML__FastSAXDriver_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _XMLChangedInstanceLayoutException_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _XMLCoder_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _XMLStandardDecoder_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _stx_137goodies_137xml_137stx_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _XMLStandardCoder_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);


void _libstx_goodies_xml_stx_InitDefinition(int pass, struct __vmData__ *__pRT__, OBJ snd)
{
  __BEGIN_PACKAGE2__("libstx_goodies_xml_stx__DFN", _libstx_goodies_xml_stx_InitDefinition, "stx:goodies/xml/stx");
    _stx_137goodies_137xml_137stx_Init(pass,__pRT__,snd);

  __END_PACKAGE__();
}

void _libstx_goodies_xml_stx_Init(int pass, struct __vmData__ *__pRT__, OBJ snd)
{
  __BEGIN_PACKAGE2__("libstx_goodies_xml_stx", _libstx_goodies_xml_stx_Init, "stx:goodies/xml/stx");
    _XML__FastSAXDriver_Init(pass,__pRT__,snd);
    _XMLChangedInstanceLayoutException_Init(pass,__pRT__,snd);
    _XMLCoder_Init(pass,__pRT__,snd);
    _XMLStandardDecoder_Init(pass,__pRT__,snd);
    _stx_137goodies_137xml_137stx_Init(pass,__pRT__,snd);
    _XMLStandardCoder_Init(pass,__pRT__,snd);

    _stx_137goodies_137xml_137stx_extensions_Init(pass,__pRT__,snd);
  __END_PACKAGE__();
}
