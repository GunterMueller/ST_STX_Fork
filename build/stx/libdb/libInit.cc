/*
 * $Header: /cvs/stx/stx/libdb/libInit.cc,v 1.24 2014-11-24 15:07:00 cg Exp $
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_libdb.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_libdb_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_libdb_InitDefinition() INIT_TEXT_SECTION;
#endif

void _libstx_libdb_InitDefinition(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_libdb__DFN", _libstx_libdb_InitDefinition, "stx:libdb");
_stx_137libdb_Init(pass,__pRT__,snd);

__END_PACKAGE__();
}

void _libstx_libdb_Init(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_libdb", _libstx_libdb_Init, "stx:libdb");
_SQL__Connection_Init(pass,__pRT__,snd);
_SQL__Cursor_Init(pass,__pRT__,snd);
_SQL__Database_Init(pass,__pRT__,snd);
_SQL__DatabaseColumnDescription_Init(pass,__pRT__,snd);
_SQL__DatabaseHandle_Init(pass,__pRT__,snd);
_SQL__DatabaseKeyDescription_Init(pass,__pRT__,snd);
_SQL__DatabaseReturnValue_Init(pass,__pRT__,snd);
_SQL__DatabaseRowObject_Init(pass,__pRT__,snd);
_SQL__DatabaseTableDescription_Init(pass,__pRT__,snd);
_SQL__SQLError_Init(pass,__pRT__,snd);
_SQL__SQLNotification_Init(pass,__pRT__,snd);
_SQL__Statement_Init(pass,__pRT__,snd);
_SQL__Transaction_Init(pass,__pRT__,snd);
_stx_137libdb_Init(pass,__pRT__,snd);
_SQL__DatabaseSession_Init(pass,__pRT__,snd);


__END_PACKAGE__();
}
