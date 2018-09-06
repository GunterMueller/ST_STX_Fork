/*
 * $Header$
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_goodies_ring.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_goodies_ring_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_goodies_ring_InitDefinition() INIT_TEXT_SECTION;
#endif

void _libstx_goodies_ring_InitDefinition(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_goodies_ring__DFN", _libstx_goodies_ring_InitDefinition, "stx:goodies/ring");
_stx_137goodies_137ring_Init(pass,__pRT__,snd);

__END_PACKAGE__();
}

void _libstx_goodies_ring_Init(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_goodies_ring", _libstx_goodies_ring_Init, "stx:goodies/ring");
_RGDefinition_Init(pass,__pRT__,snd);
_stx_137goodies_137ring_Init(pass,__pRT__,snd);
_RGAbstractContainer_Init(pass,__pRT__,snd);
_RGElementDefinition_Init(pass,__pRT__,snd);
_RGGlobalDefinition_Init(pass,__pRT__,snd);
_RGBehaviorDefinition_Init(pass,__pRT__,snd);
_RGCommentDefinition_Init(pass,__pRT__,snd);
_RGContainer_Init(pass,__pRT__,snd);
_RGGlobalVariableDefinition_Init(pass,__pRT__,snd);
_RGMethodDefinition_Init(pass,__pRT__,snd);
_RGOrganization_Init(pass,__pRT__,snd);
_RGVariableDefinition_Init(pass,__pRT__,snd);
_RGClassDescriptionDefinition_Init(pass,__pRT__,snd);
_RGClassInstanceVariableDefinition_Init(pass,__pRT__,snd);
_RGClassVariableDefinition_Init(pass,__pRT__,snd);
_RGInstanceVariableDefinition_Init(pass,__pRT__,snd);
_RGNamespace_Init(pass,__pRT__,snd);
_RGPackage_Init(pass,__pRT__,snd);
_RGPoolVariableDefinition_Init(pass,__pRT__,snd);
_RGSlice_Init(pass,__pRT__,snd);
_RGTraitDescriptionDefinition_Init(pass,__pRT__,snd);
_RGClassDefinition_Init(pass,__pRT__,snd);
_RGMetaclassDefinition_Init(pass,__pRT__,snd);
_RGMetatraitDefinition_Init(pass,__pRT__,snd);
_RGTraitDefinition_Init(pass,__pRT__,snd);

_stx_137goodies_137ring_extensions_Init(pass,__pRT__,snd);
__END_PACKAGE__();
}
