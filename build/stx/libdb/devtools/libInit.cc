/*
 * $Header: /cvs/stx/stx/libdb/devtools/libInit.cc,v 1.1 2012-05-11 16:14:57 vrany Exp $
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_libdb_devtools.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_libdb_devtools_Init() INIT_TEXT_SECTION;
// DLL_EXPORT void _libstx_libdb_devtools_InitDefinition() INIT_TEXT_SECTION;
#endif

// void _libstx_libdb_devtools_InitDefinition(pass, __pRT__, snd)
// OBJ snd; struct __vmData__ *__pRT__; {
// __BEGIN_PACKAGE2__("libstx_libdb_devtools__DFN", _libstx_libdb_devtools_InitDefinition, "stx:libdb/devtools");
// _stx_137libdb_137devtools_Init(pass,__pRT__,snd);

// __END_PACKAGE__();
// }

void _libstx_libdb_devtools_Init(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_libdb_devtools", _libstx_libdb_devtools_Init, "stx:libdb/devtools");
_SQL__ConnectionInfo_Init(pass,__pRT__,snd);
_SQL__LanguageDefinition_Init(pass,__pRT__,snd);
_SQL__WorkspaceApplication_Init(pass,__pRT__,snd);
_SQL__WorkspacePage_Init(pass,__pRT__,snd);
_stx_137libdb_137devtools_Init(pass,__pRT__,snd);


__END_PACKAGE__();
}
