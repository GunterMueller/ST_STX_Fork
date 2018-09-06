/*
 * $Header$
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_goodies_cypress.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_goodies_cypress_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_goodies_cypress_InitDefinition() INIT_TEXT_SECTION;
#endif

void _libstx_goodies_cypress_InitDefinition(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_goodies_cypress__DFN", _libstx_goodies_cypress_InitDefinition, "stx:goodies/cypress");
_stx_137goodies_137cypress_Init(pass,__pRT__,snd);

__END_PACKAGE__();
}

void _libstx_goodies_cypress_Init(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_goodies_cypress", _libstx_goodies_cypress_Init, "stx:goodies/cypress");
_CypressAbstractReaderWriter_Init(pass,__pRT__,snd);
_CypressJSONReader_Init(pass,__pRT__,snd);
_CypressModel_Init(pass,__pRT__,snd);
_stx_137goodies_137cypress_Init(pass,__pRT__,snd);
_CypressAbstractReader_Init(pass,__pRT__,snd);
_CypressAbstractWriter_Init(pass,__pRT__,snd);
_CypressClass_Init(pass,__pRT__,snd);
_CypressMethod_Init(pass,__pRT__,snd);
_CypressPackage_Init(pass,__pRT__,snd);
_CypressRepository_Init(pass,__pRT__,snd);
_CypressFileTreeReader_Init(pass,__pRT__,snd);
_CypressReader_Init(pass,__pRT__,snd);
_CypressWriter_Init(pass,__pRT__,snd);

_stx_137goodies_137cypress_extensions_Init(pass,__pRT__,snd);
__END_PACKAGE__();
}
