/*
 * $Header$
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: jv_libgdbs_tests.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libjv_libgdbs_tests_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libjv_libgdbs_tests_InitDefinition() INIT_TEXT_SECTION;
#endif

extern void _GDBDebuggeesResource_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _GDBDebuggerTestCase_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _GDBInternalPipeStreamTests_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _GDBMIParserTests_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _GDBMIPrinterTests_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _GDBTransientDataHolderTests_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _jv_137libgdbs_137tests_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _GDBDebuggerTestsR_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);



void _libjv_libgdbs_tests_InitDefinition(int pass, struct __vmData__ *__pRT__, OBJ snd)
{
  __BEGIN_PACKAGE2__("libjv_libgdbs_tests__DFN", _libjv_libgdbs_tests_InitDefinition, "jv:libgdbs/tests");
    _jv_137libgdbs_137tests_Init(pass,__pRT__,snd);

  __END_PACKAGE__();
}

void _libjv_libgdbs_tests_Init(int pass, struct __vmData__ *__pRT__, OBJ snd)
{
  __BEGIN_PACKAGE2__("libjv_libgdbs_tests", _libjv_libgdbs_tests_Init, "jv:libgdbs/tests");
    _GDBDebuggeesResource_Init(pass,__pRT__,snd);
    _GDBDebuggerTestCase_Init(pass,__pRT__,snd);
    _GDBInternalPipeStreamTests_Init(pass,__pRT__,snd);
    _GDBMIParserTests_Init(pass,__pRT__,snd);
    _GDBMIPrinterTests_Init(pass,__pRT__,snd);
    _GDBTransientDataHolderTests_Init(pass,__pRT__,snd);
    _jv_137libgdbs_137tests_Init(pass,__pRT__,snd);
    _GDBDebuggerTestsR_Init(pass,__pRT__,snd);


  __END_PACKAGE__();
}
