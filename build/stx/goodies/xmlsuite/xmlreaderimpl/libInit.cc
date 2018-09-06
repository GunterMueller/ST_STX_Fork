/*
 * $Header$
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_goodies_xmlsuite_xmlreaderimpl.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_goodies_xmlsuite_xmlreaderimpl_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_goodies_xmlsuite_xmlreaderimpl_InitDefinition() INIT_TEXT_SECTION;
#endif

void _libstx_goodies_xmlsuite_xmlreaderimpl_InitDefinition(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_goodies_xmlsuite_xmlreaderimpl__DFN", _libstx_goodies_xmlsuite_xmlreaderimpl_InitDefinition, "stx:goodies/xmlsuite/xmlreaderimpl");
_stx_137goodies_137xmlsuite_137xmlreaderimpl_Init(pass,__pRT__,snd);

__END_PACKAGE__();
}

void _libstx_goodies_xmlsuite_xmlreaderimpl_Init(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_goodies_xmlsuite_xmlreaderimpl", _libstx_goodies_xmlsuite_xmlreaderimpl_Init, "stx:goodies/xmlsuite/xmlreaderimpl");
_XMLv2__VWSAXBuilder_Init(pass,__pRT__,snd);
_XMLv2__VWXMLReader_Init(pass,__pRT__,snd);
_stx_137goodies_137xmlsuite_137xmlreaderimpl_Init(pass,__pRT__,snd);


__END_PACKAGE__();
}
