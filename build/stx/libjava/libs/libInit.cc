/*
 * $Header$
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_libjava_libs.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_libjava_libs_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_libjava_libs_InitDefinition() INIT_TEXT_SECTION;
#endif

extern void _stx_137libjava_137libs_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);



void _libstx_libjava_libs_InitDefinition(int pass, struct __vmData__ *__pRT__, OBJ snd)
{
  __BEGIN_PACKAGE2__("libstx_libjava_libs__DFN", _libstx_libjava_libs_InitDefinition, "stx:libjava/libs");
    _stx_137libjava_137libs_Init(pass,__pRT__,snd);

  __END_PACKAGE__();
}

void _libstx_libjava_libs_Init(int pass, struct __vmData__ *__pRT__, OBJ snd)
{
  __BEGIN_PACKAGE2__("libstx_libjava_libs", _libstx_libjava_libs_Init, "stx:libjava/libs");
    _stx_137libjava_137libs_Init(pass,__pRT__,snd);


  __END_PACKAGE__();
}
