/*
 * $Header: /cvs/stx/stx/libdb/libodbc/applications/libInit.cc,v 1.4 2007-02-08 16:06:28 stefan Exp $
 *
 * DO NOT EDIT 
 * automagically generated from the projectDefinition: stx_libdb_libodbc_applications.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif 

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_libdb_libodbc_applications_Init() INIT_TEXT_SECTION;
#endif

void _libstx_libdb_libodbc_applications_Init(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_libdb_libodbc_applications", _libstx_libdb_libodbc_applications_Init, "stx:libdb/libodbc/applications");
_SQL__AdaptableApplicationModel_Init(pass,__pRT__,snd);
_SQL__GetConnectionInformation_Init(pass,__pRT__,snd);
_stx_137libdb_137libodbc_137applications_Init(pass,__pRT__,snd);
_SQL__ODBCResultTable_Init(pass,__pRT__,snd);
_SQL__ODBCResultTableTab_Init(pass,__pRT__,snd);
_SQL__ODBCSQLScratchpad_Init(pass,__pRT__,snd);
_SQL__ODBCScratchpad_Init(pass,__pRT__,snd);
_SQL__ODBCScratchpadTab_Init(pass,__pRT__,snd);


__END_PACKAGE__();
}
