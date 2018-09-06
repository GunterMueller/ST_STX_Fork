/*
 * $Header$
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_goodies_ring_tests.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_goodies_ring_tests_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_goodies_ring_tests_InitDefinition() INIT_TEXT_SECTION;
#endif

void _libstx_goodies_ring_tests_InitDefinition(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_goodies_ring_tests__DFN", _libstx_goodies_ring_tests_InitDefinition, "stx:goodies/ring/tests");
_stx_137goodies_137ring_137tests_Init(pass,__pRT__,snd);

__END_PACKAGE__();
}

void _libstx_goodies_ring_tests_Init(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_goodies_ring_tests", _libstx_goodies_ring_tests_Init, "stx:goodies/ring/tests");
_RGClassDefinitionTest_Init(pass,__pRT__,snd);
_RGCommentDefinitionTest_Init(pass,__pRT__,snd);
_RGContainerTest_Init(pass,__pRT__,snd);
_RGGlobalDefinitionTest_Init(pass,__pRT__,snd);
_RGMetaclassDefinitionTest_Init(pass,__pRT__,snd);
_RGMetatraitDefinitionTest_Init(pass,__pRT__,snd);
_RGMethodDefinitionTest_Init(pass,__pRT__,snd);
_RGNamespaceTest_Init(pass,__pRT__,snd);
_RGPackageTest_Init(pass,__pRT__,snd);
_RGSliceTest_Init(pass,__pRT__,snd);
_RGTraitDefinitionTest_Init(pass,__pRT__,snd);
_RGVariableDefinitionTest_Init(pass,__pRT__,snd);
_stx_137goodies_137ring_137tests_Init(pass,__pRT__,snd);


__END_PACKAGE__();
}
