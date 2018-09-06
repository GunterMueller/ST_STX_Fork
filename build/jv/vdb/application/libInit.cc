/*
 * $Header$
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: jv_vdb_application.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libjv_vdb_application_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libjv_vdb_application_InitDefinition() INIT_TEXT_SECTION;
#endif

void _libjv_vdb_application_InitDefinition(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libjv_vdb_application__DFN", _libjv_vdb_application_InitDefinition, "jv:vdb/application");
_jv_137vdb_137application_Init(pass,__pRT__,snd);

__END_PACKAGE__();
}

void _libjv_vdb_application_Init(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libjv_vdb_application", _libjv_vdb_application_Init, "jv:vdb/application");
_VDBStartup_Init(pass,__pRT__,snd);
_jv_137vdb_137application_Init(pass,__pRT__,snd);


__END_PACKAGE__();
}
