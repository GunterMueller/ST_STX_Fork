/*
 * DO NOT EDIT
 * automatically generated from Make.proto (by make libInit.cc)
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>
#define INIT_TEXT_SECT /* as nothing */
#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#else /* not WIN32 */
# if defined(__GNUC__) && !defined(NO_SECTION_ATTRIBUTES)
#  if (__GNUC__  == 2 && __GNUC_MINOR__ >= 7) || __GNUC__ > 2
#   undef INIT_TEXT_SECT
#   define INIT_TEXT_SECT __attribute__((section(".stxitext")))
#  endif
# endif /* not GNUC */
#endif /* not WIN32 */
#ifdef INIT_TEXT_SECT
DLL_EXPORT extern void _minneStore_Init() INIT_TEXT_SECT;
#endif
void _minneStore_Init(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("minneStore", _minneStore_Init, "stx:libdb/nosql/minneStore");
_Minnestore__MinneStore_Init(pass,__pRT__,snd);
_Minnestore__MSTestClasses_Init(pass,__pRT__,snd);
_Minnestore__DiskObjectServices_Init(pass,__pRT__,snd);
_Minnestore__DODeletedObject_Init(pass,__pRT__,snd);
_Minnestore__DOInvalidVersionError_Init(pass,__pRT__,snd);
_Minnestore__DOLockStuckError_Init(pass,__pRT__,snd);
_Minnestore__DOService_Init(pass,__pRT__,snd);
_Minnestore__DOMultiObjectService_Init(pass,__pRT__,snd);
_Minnestore__DOObjectsPerFilePolicy_Init(pass,__pRT__,snd);
_Minnestore__DOMultiObjectsPerFilePolicy_Init(pass,__pRT__,snd);
_Minnestore__DOUserPolicy_Init(pass,__pRT__,snd);
_Minnestore__DOMultiUserPolicy_Init(pass,__pRT__,snd);
_Minnestore__DOSingleObjectPerFilePolicy_Init(pass,__pRT__,snd);
_Minnestore__DOSingleObjectService_Init(pass,__pRT__,snd);
_Minnestore__DOSingleUserPolicy_Init(pass,__pRT__,snd);
_Minnestore__DOTestException_Init(pass,__pRT__,snd);
_Minnestore__DOWrapper_Init(pass,__pRT__,snd);
_Minnestore__ExceptionCompatibility_Init(pass,__pRT__,snd);
_Minnestore__File_Init(pass,__pRT__,snd);
_Minnestore__FlavorCompatibility_Init(pass,__pRT__,snd);
_Minnestore__MSAspect_Init(pass,__pRT__,snd);
_Minnestore__MSBranch_Init(pass,__pRT__,snd);
_Minnestore__MSBranchAboutToMorph_Init(pass,__pRT__,snd);
_Minnestore__MSDeletedLeafException_Init(pass,__pRT__,snd);
_Minnestore__MSHighValue_Init(pass,__pRT__,snd);
_Minnestore__MSLeaf_Init(pass,__pRT__,snd);
_Minnestore__MSMultiObjectAspect_Init(pass,__pRT__,snd);
_Minnestore__MSReadProxy_Init(pass,__pRT__,snd);
_Minnestore__MSMultiObjectReadProxy_Init(pass,__pRT__,snd);
_Minnestore__MSStorageProxy_Init(pass,__pRT__,snd);
_Minnestore__MSMultiObjectStorageProxy_Init(pass,__pRT__,snd);
_Minnestore__MSNilValue_Init(pass,__pRT__,snd);
_Minnestore__MSObjectSet_Init(pass,__pRT__,snd);
_Minnestore__MSSingleObjectAspect_Init(pass,__pRT__,snd);
_Minnestore__MSSingleObjectReadProxy_Init(pass,__pRT__,snd);
_Minnestore__MSSingleObjectStorageProxy_Init(pass,__pRT__,snd);
_Minnestore__MSText_Init(pass,__pRT__,snd);
_Minnestore__MSTreeHolder_Init(pass,__pRT__,snd);
_Minnestore__MSTrunk_Init(pass,__pRT__,snd);
_Minnestore__MinneStoreDB_Init(pass,__pRT__,snd);
_stx_137libdb_137nosql_137minneStore_extensions_Init(pass,__pRT__,snd);
__END_PACKAGE__();
}
