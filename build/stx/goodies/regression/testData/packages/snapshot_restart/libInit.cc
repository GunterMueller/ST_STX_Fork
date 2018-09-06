/*
 * $Header$
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_goodies_regression_testData_packages_snapshot_restart.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_goodies_regression_testData_packages_snapshot_restart_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_goodies_regression_testData_packages_snapshot_restart_InitDefinition() INIT_TEXT_SECTION;
#endif

void _libstx_goodies_regression_testData_packages_snapshot_restart_InitDefinition(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_goodies_regression_testData_packages_snapshot_restart__DFN", _libstx_goodies_regression_testData_packages_snapshot_restart_InitDefinition, "stx:goodies/regression/testData/packages/snapshot_restart");
_stx_137goodies_137regression_137testData_137packages_137snapshot_137restart_Init(pass,__pRT__,snd);

__END_PACKAGE__();
}

void _libstx_goodies_regression_testData_packages_snapshot_restart_Init(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_goodies_regression_testData_packages_snapshot_restart", _libstx_goodies_regression_testData_packages_snapshot_restart_Init, "stx:goodies/regression/testData/packages/snapshot_restart");
_RegressionTests__SnapshotRestartTestsObject_Init(pass,__pRT__,snd);
_stx_137goodies_137regression_137testData_137packages_137snapshot_137restart_Init(pass,__pRT__,snd);


__END_PACKAGE__();
}
