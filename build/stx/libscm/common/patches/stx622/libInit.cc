/*
 * $Header$
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_libscm_common_patches_stx622.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_libscm_common_patches_stx622_Init() INIT_TEXT_SECTION;
// DLL_EXPORT void _libstx_libscm_common_patches_stx622_InitDefinition() INIT_TEXT_SECTION;
#endif

// void _libstx_libscm_common_patches_stx622_InitDefinition(pass, __pRT__, snd)
// OBJ snd; struct __vmData__ *__pRT__; {
// __BEGIN_PACKAGE2__("libstx_libscm_common_patches_stx622__DFN", _libstx_libscm_common_patches_stx622_InitDefinition, "stx:libscm/common/patches/stx622");
// _stx_137libscm_137common_137patches_137stx622_Init(pass,__pRT__,snd);

// __END_PACKAGE__();
// }

void _libstx_libscm_common_patches_stx622_Init(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_libscm_common_patches_stx622", _libstx_libscm_common_patches_stx622_Init, "stx:libscm/common/patches/stx622");
_stx_137libscm_137common_137patches_137stx622_Init(pass,__pRT__,snd);

_stx_137libscm_137common_137patches_137stx622_extensions_Init(pass,__pRT__,snd);
__END_PACKAGE__();
}
