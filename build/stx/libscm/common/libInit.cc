/*
 * $Header$
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_libscm_common.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_libscm_common_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_libscm_common_InitDefinition() INIT_TEXT_SECTION;
#endif

void _libstx_libscm_common_InitDefinition(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_libscm_common__DFN", _libstx_libscm_common_InitDefinition, "stx:libscm/common");
_stx_137libscm_137common_Init(pass,__pRT__,snd);

__END_PACKAGE__();
}

void _libstx_libscm_common_Init(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_libscm_common", _libstx_libscm_common_Init, "stx:libscm/common");
_SCMAbstractDialog_Init(pass,__pRT__,snd);
_SCMAbstractPackageModel_Init(pass,__pRT__,snd);
_SCMAbstractPackageWorkingCopyRegistry_Init(pass,__pRT__,snd);
_SCMAbstractRevisionInfo_Init(pass,__pRT__,snd);
_SCMAbstractSourceCodeManager_Init(pass,__pRT__,snd);
_SCMAbstractTask_Init(pass,__pRT__,snd);
_SCMCodeMonitor_Init(pass,__pRT__,snd);
_SCMCommonPackageModelGroup_Init(pass,__pRT__,snd);
_SCMCommonSourceCodeManagerUtilities_Init(pass,__pRT__,snd);
_SCMCompatModeQuery_Init(pass,__pRT__,snd);
_SCMError_Init(pass,__pRT__,snd);
_SCMWarning_Init(pass,__pRT__,snd);
_stx_137libscm_137common_Init(pass,__pRT__,snd);
_SCMAbstractCommitDialog_Init(pass,__pRT__,snd);
_SCMAbstractFileoutLikeTask_Init(pass,__pRT__,snd);
_SCMAbstractPackageRevision_Init(pass,__pRT__,snd);
_SCMAbstractPackageWorkingCopy_Init(pass,__pRT__,snd);
_SCMPackageModelError_Init(pass,__pRT__,snd);
_SCMPackageModelWarning_Init(pass,__pRT__,snd);
_SCMAbstractCommitTask_Init(pass,__pRT__,snd);

_stx_137libscm_137common_extensions_Init(pass,__pRT__,snd);
__END_PACKAGE__();
}
