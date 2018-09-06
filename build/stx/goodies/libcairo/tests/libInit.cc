/*
 * $Header$
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_goodies_libcairo_tests.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_goodies_libcairo_tests_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_goodies_libcairo_tests_InitDefinition() INIT_TEXT_SECTION;
#endif

extern void _Cairo__GraphicsContextTests_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Cairo__PatternTests_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _CairoGraphicsContextTests_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _stx_137goodies_137libcairo_137tests_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);



void _libstx_goodies_libcairo_tests_InitDefinition(int pass, struct __vmData__ *__pRT__, OBJ snd)
{
  __BEGIN_PACKAGE2__("libstx_goodies_libcairo_tests__DFN", _libstx_goodies_libcairo_tests_InitDefinition, "stx:goodies/libcairo/tests");
    _stx_137goodies_137libcairo_137tests_Init(pass,__pRT__,snd);

  __END_PACKAGE__();
}

void _libstx_goodies_libcairo_tests_Init(int pass, struct __vmData__ *__pRT__, OBJ snd)
{
  __BEGIN_PACKAGE2__("libstx_goodies_libcairo_tests", _libstx_goodies_libcairo_tests_Init, "stx:goodies/libcairo/tests");
    _Cairo__GraphicsContextTests_Init(pass,__pRT__,snd);
    _Cairo__PatternTests_Init(pass,__pRT__,snd);
    _CairoGraphicsContextTests_Init(pass,__pRT__,snd);
    _stx_137goodies_137libcairo_137tests_Init(pass,__pRT__,snd);


  __END_PACKAGE__();
}
