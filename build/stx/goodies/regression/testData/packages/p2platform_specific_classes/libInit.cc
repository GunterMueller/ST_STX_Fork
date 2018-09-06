/*
 * $Header$
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_goodies_regression_testData_packages_p2platform_specific_classes.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_goodies_regression_testData_packages_p2platform_specific_classes_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_goodies_regression_testData_packages_p2platform_specific_classes_InitDefinition() INIT_TEXT_SECTION;
#endif

extern void _stx_137goodies_137regression_137testData_137packages_137p2platform_137specific_137classes_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
#ifdef UNIX
extern void _UnixSpecificClass_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
#endif /* UNIX */
#ifdef WIN32
extern void _Win32SpecificClass_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
#endif /* WIN32 */
#ifdef VMS
extern void _VMSSpecificClass_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
#endif /* VMS */



void _libstx_goodies_regression_testData_packages_p2platform_specific_classes_InitDefinition(int pass, struct __vmData__ *__pRT__, OBJ snd)
{
  __BEGIN_PACKAGE2__("libstx_goodies_regression_testData_packages_p2platform_specific_classes__DFN", _libstx_goodies_regression_testData_packages_p2platform_specific_classes_InitDefinition, "stx:goodies/regression/testData/packages/p2platform_specific_classes");
    _stx_137goodies_137regression_137testData_137packages_137p2platform_137specific_137classes_Init(pass,__pRT__,snd);

  __END_PACKAGE__();
}

void _libstx_goodies_regression_testData_packages_p2platform_specific_classes_Init(int pass, struct __vmData__ *__pRT__, OBJ snd)
{
  __BEGIN_PACKAGE2__("libstx_goodies_regression_testData_packages_p2platform_specific_classes", _libstx_goodies_regression_testData_packages_p2platform_specific_classes_Init, "stx:goodies/regression/testData/packages/p2platform_specific_classes");
    _stx_137goodies_137regression_137testData_137packages_137p2platform_137specific_137classes_Init(pass,__pRT__,snd);
#ifdef UNIX
    _UnixSpecificClass_Init(pass,__pRT__,snd);
#endif /* UNIX */
#ifdef WIN32
    _Win32SpecificClass_Init(pass,__pRT__,snd);
#endif /* WIN32 */
#ifdef VMS
    _VMSSpecificClass_Init(pass,__pRT__,snd);
#endif /* VMS */


  __END_PACKAGE__();
}
