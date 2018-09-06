/*
 * $Header$
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_goodies_regression.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_goodies_regression_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_goodies_regression_InitDefinition() INIT_TEXT_SECTION;
#endif

extern void _stx_137goodies_137regression_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);



void _libstx_goodies_regression_InitDefinition(int pass, struct __vmData__ *__pRT__, OBJ snd)
{
  __BEGIN_PACKAGE2__("libstx_goodies_regression__DFN", _libstx_goodies_regression_InitDefinition, "stx:goodies/regression");
    _stx_137goodies_137regression_Init(pass,__pRT__,snd);

  __END_PACKAGE__();
}

void _libstx_goodies_regression_Init(int pass, struct __vmData__ *__pRT__, OBJ snd)
{
  __BEGIN_PACKAGE2__("libstx_goodies_regression", _libstx_goodies_regression_Init, "stx:goodies/regression");
    _stx_137goodies_137regression_Init(pass,__pRT__,snd);


  __END_PACKAGE__();
}
