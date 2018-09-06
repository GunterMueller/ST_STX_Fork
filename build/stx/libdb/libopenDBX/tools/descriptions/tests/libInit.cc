/*
 * $Header: /cvs/stx/stx/libdb/libopenDBX/tools/descriptions/tests/libInit.cc,v 1.1 2013-04-15 13:37:13 cg Exp $
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_libdb_libopenDBX_tools_descriptions_tests.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_libdb_libopenDBX_tools_descriptions_tests_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_libdb_libopenDBX_tools_descriptions_tests_InitDefinition() INIT_TEXT_SECTION;
#endif

void _libstx_libdb_libopenDBX_tools_descriptions_tests_InitDefinition(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_libdb_libopenDBX_tools_descriptions_tests__DFN", _libstx_libdb_libopenDBX_tools_descriptions_tests_InitDefinition, "stx:libdb/libopenDBX/tools/descriptions/tests");
_stx_137libdb_137libopenDBX_137tools_137descriptions_137tests_Init(pass,__pRT__,snd);

__END_PACKAGE__();
}

void _libstx_libdb_libopenDBX_tools_descriptions_tests_Init(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_libdb_libopenDBX_tools_descriptions_tests", _libstx_libdb_libopenDBX_tools_descriptions_tests_Init, "stx:libdb/libopenDBX/tools/descriptions/tests");
_Dbxclass_Init(pass,__pRT__,snd);
_Dbxitem_Init(pass,__pRT__,snd);
_Dbxpet_Init(pass,__pRT__,snd);
_Dbxplayer_Init(pass,__pRT__,snd);
_stx_137libdb_137libopenDBX_137tools_137descriptions_137tests_Init(pass,__pRT__,snd);


__END_PACKAGE__();
}
