/*
 * $Header: /cvs/stx/stx/libdb/libopenDBX/tools/dbxBrowser/libInit.cc,v 1.3 2013-04-15 14:27:08 cg Exp $
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_libdb_libopenDBX_tools_dbxBrowser.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_libdb_libopenDBX_tools_dbxBrowser_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_libdb_libopenDBX_tools_dbxBrowser_InitDefinition() INIT_TEXT_SECTION;
#endif

void _libstx_libdb_libopenDBX_tools_dbxBrowser_InitDefinition(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_libdb_libopenDBX_tools_dbxBrowser__DFN", _libstx_libdb_libopenDBX_tools_dbxBrowser_InitDefinition, "stx:libdb/libopenDBX/tools/dbxBrowser");
_stx_137libdb_137libopenDBX_137tools_137dbxBrowser_Init(pass,__pRT__,snd);

__END_PACKAGE__();
}

void _libstx_libdb_libopenDBX_tools_dbxBrowser_Init(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_libdb_libopenDBX_tools_dbxBrowser", _libstx_libdb_libopenDBX_tools_dbxBrowser_Init, "stx:libdb/libopenDBX/tools/dbxBrowser");
_DBXBrowser_Init(pass,__pRT__,snd);
_DBXBrowserClosedConnection_Init(pass,__pRT__,snd);
_DBXBrowserConnection_Init(pass,__pRT__,snd);
_DBXBrowserModel_Init(pass,__pRT__,snd);
_DBXBrowserOpenedConnection_Init(pass,__pRT__,snd);
_DBXBrowserSchema_Init(pass,__pRT__,snd);
_DBXBrowserTable_Init(pass,__pRT__,snd);
_DBXConnectionAdded_Init(pass,__pRT__,snd);
_DBXConnectionRemoved_Init(pass,__pRT__,snd);
_DBXConnectionStatusChanged_Init(pass,__pRT__,snd);
_DBXTablesRefresh_Init(pass,__pRT__,snd);
_stx_137libdb_137libopenDBX_137tools_137dbxBrowser_Init(pass,__pRT__,snd);


__END_PACKAGE__();
}
