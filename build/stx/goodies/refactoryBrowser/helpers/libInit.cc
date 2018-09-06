/*
 * $Header$
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_goodies_refactoryBrowser_helpers.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_goodies_refactoryBrowser_helpers_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_goodies_refactoryBrowser_helpers_InitDefinition() INIT_TEXT_SECTION;
#endif

extern void _BrowserEnvironment_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBAbstractClass_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBMethod_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBMethodName_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBNamespace_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _stx_137goodies_137refactoryBrowser_137helpers_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBClass_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBMetaclass_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);


void _libstx_goodies_refactoryBrowser_helpers_InitDefinition(int pass, struct __vmData__ *__pRT__, OBJ snd)
{
  __BEGIN_PACKAGE2__("libstx_goodies_refactoryBrowser_helpers__DFN", _libstx_goodies_refactoryBrowser_helpers_InitDefinition, "stx:goodies/refactoryBrowser/helpers");
    _stx_137goodies_137refactoryBrowser_137helpers_Init(pass,__pRT__,snd);

  __END_PACKAGE__();
}

void _libstx_goodies_refactoryBrowser_helpers_Init(int pass, struct __vmData__ *__pRT__, OBJ snd)
{
  __BEGIN_PACKAGE2__("libstx_goodies_refactoryBrowser_helpers", _libstx_goodies_refactoryBrowser_helpers_Init, "stx:goodies/refactoryBrowser/helpers");
    _BrowserEnvironment_Init(pass,__pRT__,snd);
    _RBAbstractClass_Init(pass,__pRT__,snd);
    _RBMethod_Init(pass,__pRT__,snd);
    _RBMethodName_Init(pass,__pRT__,snd);
    _RBNamespace_Init(pass,__pRT__,snd);
    _stx_137goodies_137refactoryBrowser_137helpers_Init(pass,__pRT__,snd);
    _RBClass_Init(pass,__pRT__,snd);
    _RBMetaclass_Init(pass,__pRT__,snd);


  __END_PACKAGE__();
}
