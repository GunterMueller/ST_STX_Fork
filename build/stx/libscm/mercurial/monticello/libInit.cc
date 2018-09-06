/*
 * $Header$
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_libscm_mercurial_monticello.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_libscm_mercurial_monticello_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_libscm_mercurial_monticello_InitDefinition() INIT_TEXT_SECTION;
#endif

extern void _HGMCVersionInfo_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _stx_137libscm_137mercurial_137monticello_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);



void _libstx_libscm_mercurial_monticello_InitDefinition(int pass, struct __vmData__ *__pRT__, OBJ snd)
{
  __BEGIN_PACKAGE2__("libstx_libscm_mercurial_monticello__DFN", _libstx_libscm_mercurial_monticello_InitDefinition, "stx:libscm/mercurial/monticello");
    _stx_137libscm_137mercurial_137monticello_Init(pass,__pRT__,snd);

  __END_PACKAGE__();
}

void _libstx_libscm_mercurial_monticello_Init(int pass, struct __vmData__ *__pRT__, OBJ snd)
{
  __BEGIN_PACKAGE2__("libstx_libscm_mercurial_monticello", _libstx_libscm_mercurial_monticello_Init, "stx:libscm/mercurial/monticello");
    _HGMCVersionInfo_Init(pass,__pRT__,snd);
    _stx_137libscm_137mercurial_137monticello_Init(pass,__pRT__,snd);


  __END_PACKAGE__();
}
