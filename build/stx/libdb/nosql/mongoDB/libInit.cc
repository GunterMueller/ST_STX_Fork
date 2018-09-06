/*
 * $Header: /cvs/stx/stx/libdb/nosql/mongoDB/libInit.cc,v 1.3 2013-04-04 22:34:43 cg Exp $
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_libdb_nosql_mongoDB.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_libdb_nosql_mongoDB_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_libdb_nosql_mongoDB_InitDefinition() INIT_TEXT_SECTION;
#endif

void _libstx_libdb_nosql_mongoDB_InitDefinition(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_libdb_nosql_mongoDB__DFN", _libstx_libdb_nosql_mongoDB_InitDefinition, "stx:libdb/nosql/mongoDB");
_stx_137libdb_137nosql_137mongoDB_Init(pass,__pRT__,snd);

__END_PACKAGE__();
}

void _libstx_libdb_nosql_mongoDB_Init(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_libdb_nosql_mongoDB", _libstx_libdb_nosql_mongoDB_Init, "stx:libdb/nosql/mongoDB");
_BSON_Init(pass,__pRT__,snd);
_BSONError_Init(pass,__pRT__,snd);
_BSONRegex_Init(pass,__pRT__,snd);
_CollectionValidation_Init(pass,__pRT__,snd);
_LittleEndianStream_Init(pass,__pRT__,snd);
_Mongo_Init(pass,__pRT__,snd);
_MongoCollection_Init(pass,__pRT__,snd);
_MongoCursor_Init(pass,__pRT__,snd);
_MongoDatabase_Init(pass,__pRT__,snd);
_MongoOperation_Init(pass,__pRT__,snd);
_MongoQuery_Init(pass,__pRT__,snd);
_OID_Init(pass,__pRT__,snd);
_ReplyOperation_Init(pass,__pRT__,snd);
_stx_137libdb_137nosql_137mongoDB_Init(pass,__pRT__,snd);
_BSONUndefindedType_Init(pass,__pRT__,snd);
_DeleteOperation_Init(pass,__pRT__,snd);
_GetMoreOperation_Init(pass,__pRT__,snd);
_InsertOperation_Init(pass,__pRT__,snd);
_MongoMetaCollection_Init(pass,__pRT__,snd);
_QueryOperation_Init(pass,__pRT__,snd);
_UpdateOperation_Init(pass,__pRT__,snd);

_stx_137libdb_137nosql_137mongoDB_extensions_Init(pass,__pRT__,snd);
__END_PACKAGE__();
}
