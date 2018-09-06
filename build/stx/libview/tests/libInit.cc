/*
 * $Header$
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_libview_tests.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_libview_tests_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_libview_tests_InitDefinition() INIT_TEXT_SECTION;
#endif

extern void _FcPatternTests_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _FormTests_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ImageTests_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ResourcePackTests_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _stx_137libview_137tests_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);



void _libstx_libview_tests_InitDefinition(int pass, struct __vmData__ *__pRT__, OBJ snd)
{
  __BEGIN_PACKAGE2__("libstx_libview_tests__DFN", _libstx_libview_tests_InitDefinition, "stx:libview/tests");
    _stx_137libview_137tests_Init(pass,__pRT__,snd);

  __END_PACKAGE__();
}

void _libstx_libview_tests_Init(int pass, struct __vmData__ *__pRT__, OBJ snd)
{
  __BEGIN_PACKAGE2__("libstx_libview_tests", _libstx_libview_tests_Init, "stx:libview/tests");
    _FcPatternTests_Init(pass,__pRT__,snd);
    _FormTests_Init(pass,__pRT__,snd);
    _ImageTests_Init(pass,__pRT__,snd);
    _ResourcePackTests_Init(pass,__pRT__,snd);
    _stx_137libview_137tests_Init(pass,__pRT__,snd);


  __END_PACKAGE__();
}
