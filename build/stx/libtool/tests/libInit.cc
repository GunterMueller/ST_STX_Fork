/*
 * $Header$
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_libtool_tests.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_libtool_tests_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_libtool_tests_InitDefinition() INIT_TEXT_SECTION;
#endif

extern void _Tools__CodeView2Tests_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Tools__NewSystemBrowserTests_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _WorkspaceApplicationTests_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _stx_137libtool_137tests_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);



void _libstx_libtool_tests_InitDefinition(int pass, struct __vmData__ *__pRT__, OBJ snd)
{
  __BEGIN_PACKAGE2__("libstx_libtool_tests__DFN", _libstx_libtool_tests_InitDefinition, "stx:libtool/tests");
    _stx_137libtool_137tests_Init(pass,__pRT__,snd);

  __END_PACKAGE__();
}

void _libstx_libtool_tests_Init(int pass, struct __vmData__ *__pRT__, OBJ snd)
{
  __BEGIN_PACKAGE2__("libstx_libtool_tests", _libstx_libtool_tests_Init, "stx:libtool/tests");
    _Tools__CodeView2Tests_Init(pass,__pRT__,snd);
    _Tools__NewSystemBrowserTests_Init(pass,__pRT__,snd);
    _WorkspaceApplicationTests_Init(pass,__pRT__,snd);
    _stx_137libtool_137tests_Init(pass,__pRT__,snd);


  __END_PACKAGE__();
}
