/*
 * $Header: /cvs/stx/stx/libdb/nosql/couchDB/libInit.cc,v 1.2 2017-07-31 06:50:06 mawalch Exp $
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_libdb_nosql_couchDB.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_libdb_nosql_couchDB_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_libdb_nosql_couchDB_InitDefinition() INIT_TEXT_SECTION;
#endif

extern void _CouchDB_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _CouchDBError_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _CouchViewServer_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _CouchViewServerError_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _CouchViewServerFunction_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _CouchViewServerListener_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _stx_137libdb_137nosql_137couchDB_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _CouchDBInvalidDatabaseNameError_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _CouchDBInvalidDocumentError_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _CouchDBOperationFailedError_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _CouchViewServerCompilationError_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _CouchViewServerFunctionError_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _CouchViewServerReduceError_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);


void _libstx_libdb_nosql_couchDB_InitDefinition(int pass, struct __vmData__ *__pRT__, OBJ snd)
{
  __BEGIN_PACKAGE2__("libstx_libdb_nosql_couchDB__DFN", _libstx_libdb_nosql_couchDB_InitDefinition, "stx:libdb/nosql/couchDB");
    _stx_137libdb_137nosql_137couchDB_Init(pass,__pRT__,snd);

  __END_PACKAGE__();
}

void _libstx_libdb_nosql_couchDB_Init(int pass, struct __vmData__ *__pRT__, OBJ snd)
{
  __BEGIN_PACKAGE2__("libstx_libdb_nosql_couchDB", _libstx_libdb_nosql_couchDB_Init, "stx:libdb/nosql/couchDB");
    _CouchDB_Init(pass,__pRT__,snd);
    _CouchDBError_Init(pass,__pRT__,snd);
    _CouchViewServer_Init(pass,__pRT__,snd);
    _CouchViewServerError_Init(pass,__pRT__,snd);
    _CouchViewServerFunction_Init(pass,__pRT__,snd);
    _CouchViewServerListener_Init(pass,__pRT__,snd);
    _stx_137libdb_137nosql_137couchDB_Init(pass,__pRT__,snd);
    _CouchDBInvalidDatabaseNameError_Init(pass,__pRT__,snd);
    _CouchDBInvalidDocumentError_Init(pass,__pRT__,snd);
    _CouchDBOperationFailedError_Init(pass,__pRT__,snd);
    _CouchViewServerCompilationError_Init(pass,__pRT__,snd);
    _CouchViewServerFunctionError_Init(pass,__pRT__,snd);
    _CouchViewServerReduceError_Init(pass,__pRT__,snd);

    _stx_137libdb_137nosql_137couchDB_extensions_Init(pass,__pRT__,snd);
  __END_PACKAGE__();
}
