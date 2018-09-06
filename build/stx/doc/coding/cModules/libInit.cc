/*
 * $Header: /cvs/stx/stx/doc/coding/cModules/libInit.cc,v 1.1 2016-03-27 23:11:53 cg Exp $
 *
 * DO NOT EDIT
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_doc_coding_cModules_Init() INIT_TEXT_SECTION;
#endif

void _libstx_doc_coding_cModules_Init(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_doc_coding_cModules", _libstx_doc_coding_cModules_Init, "stx:libbasic2");
_CodingExamples__CModuleDemo_Init(pass,__pRT__,snd);
__END_PACKAGE__();
}
