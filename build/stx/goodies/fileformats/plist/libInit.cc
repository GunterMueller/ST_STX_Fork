/*
 * $Header: /cvs/stx/stx/goodies/fileformats/plist/libInit.cc,v 1.2 2018-05-03 23:42:38 cg Exp $
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_goodies_fileformats_plist.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_goodies_fileformats_plist_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_goodies_fileformats_plist_InitDefinition() INIT_TEXT_SECTION;
#endif

extern void _MacBinaryPListFileReader_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _MacPlistBinaryDecoder_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _MacPlistXMLCoder_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _MacPlistXMLDecoder_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _stx_137goodies_137fileformats_137plist_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);


void _libstx_goodies_fileformats_plist_InitDefinition(int pass, struct __vmData__ *__pRT__, OBJ snd)
{
  __BEGIN_PACKAGE2__("libstx_goodies_fileformats_plist__DFN", _libstx_goodies_fileformats_plist_InitDefinition, "stx:goodies/fileformats/plist");
    _stx_137goodies_137fileformats_137plist_Init(pass,__pRT__,snd);

  __END_PACKAGE__();
}

void _libstx_goodies_fileformats_plist_Init(int pass, struct __vmData__ *__pRT__, OBJ snd)
{
  __BEGIN_PACKAGE2__("libstx_goodies_fileformats_plist", _libstx_goodies_fileformats_plist_Init, "stx:goodies/fileformats/plist");
    _MacBinaryPListFileReader_Init(pass,__pRT__,snd);
    _MacPlistBinaryDecoder_Init(pass,__pRT__,snd);
    _MacPlistXMLCoder_Init(pass,__pRT__,snd);
    _MacPlistXMLDecoder_Init(pass,__pRT__,snd);
    _stx_137goodies_137fileformats_137plist_Init(pass,__pRT__,snd);


  __END_PACKAGE__();
}
