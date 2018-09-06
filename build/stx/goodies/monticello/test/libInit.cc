/*
 * $Header: /cvs/stx/stx/goodies/monticello/test/libInit.cc,v 1.2 2013-05-29 00:04:46 vrany Exp $
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_goodies_monticello_test.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_goodies_monticello_test_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_goodies_monticello_test_InitDefinition() INIT_TEXT_SECTION;
#endif

void _libstx_goodies_monticello_test_InitDefinition(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_goodies_monticello_test__DFN", _libstx_goodies_monticello_test_InitDefinition, "stx:goodies/monticello/test");
_stx_137goodies_137monticello_137test_Init(pass,__pRT__,snd);

__END_PACKAGE__();
}

void _libstx_goodies_monticello_test_Init(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_goodies_monticello_test", _libstx_goodies_monticello_test_Init, "stx:goodies/monticello/test");
_MCDependencySorterTest_Init(pass,__pRT__,snd);
_MCSnapshotResource_Init(pass,__pRT__,snd);
_MCSortingTest_Init(pass,__pRT__,snd);
_MCTestCase_Init(pass,__pRT__,snd);
_stx_137goodies_137monticello_137test_Init(pass,__pRT__,snd);
_MCAncestryTest_Init(pass,__pRT__,snd);
_MCChangeNotificationTest_Init(pass,__pRT__,snd);
_MCClassDefinitionTest_Init(pass,__pRT__,snd);
_MCFileInTest_Init(pass,__pRT__,snd);
_MCInitializationTest_Init(pass,__pRT__,snd);
_MCMczInstallerTest_Init(pass,__pRT__,snd);
_MCMergingTest_Init(pass,__pRT__,snd);
_MCMethodDefinitionTest_Init(pass,__pRT__,snd);
_MCOrganizationTest_Init(pass,__pRT__,snd);
_MCPackageTest_Init(pass,__pRT__,snd);
_MCPatchTest_Init(pass,__pRT__,snd);
_MCRepositoryTest_Init(pass,__pRT__,snd);
_MCScannerTest_Init(pass,__pRT__,snd);
_MCSerializationTest_Init(pass,__pRT__,snd);
_MCSnapshotBrowserTest_Init(pass,__pRT__,snd);
_MCSnapshotTest_Init(pass,__pRT__,snd);
_MCStReaderTest_Init(pass,__pRT__,snd);
_MCStWriterTest_Init(pass,__pRT__,snd);
_MCVersionTest_Init(pass,__pRT__,snd);
_MCWorkingCopyTest_Init(pass,__pRT__,snd);
_MCDictionaryRepositoryTest_Init(pass,__pRT__,snd);
_MCDirectoryRepositoryTest_Init(pass,__pRT__,snd);


__END_PACKAGE__();
}
