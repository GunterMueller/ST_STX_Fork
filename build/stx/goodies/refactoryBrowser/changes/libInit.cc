/*
 * $Header$
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_goodies_refactoryBrowser_changes.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_goodies_refactoryBrowser_changes_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_goodies_refactoryBrowser_changes_InitDefinition() INIT_TEXT_SECTION;
#endif

void _libstx_goodies_refactoryBrowser_changes_InitDefinition(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_goodies_refactoryBrowser_changes__DFN", _libstx_goodies_refactoryBrowser_changes_InitDefinition, "stx:goodies/refactoryBrowser/changes");
_stx_137goodies_137refactoryBrowser_137changes_Init(pass,__pRT__,snd);

__END_PACKAGE__();
}

void _libstx_goodies_refactoryBrowser_changes_Init(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_goodies_refactoryBrowser_changes", _libstx_goodies_refactoryBrowser_changes_Init, "stx:goodies/refactoryBrowser/changes");
_RefactoryChange_Init(pass,__pRT__,snd);
_RefactoryChangeManager_Init(pass,__pRT__,snd);
_stx_137goodies_137refactoryBrowser_137changes_Init(pass,__pRT__,snd);
_ClassRefactoryChange_Init(pass,__pRT__,snd);
_CompositeRefactoryChange_Init(pass,__pRT__,snd);
_MethodRefactoryChange_Init(pass,__pRT__,snd);
_RefactoryClassChange_Init(pass,__pRT__,snd);
_AddClassChange_Init(pass,__pRT__,snd);
_AddMethodChange_Init(pass,__pRT__,snd);
_RefactoryClassCategoryChange_Init(pass,__pRT__,snd);
_RefactoryClassProjectChange_Init(pass,__pRT__,snd);
_RefactoryMethodCategoryChange_Init(pass,__pRT__,snd);
_RefactoryMethodProjectChange_Init(pass,__pRT__,snd);
_RefactoryVariableChange_Init(pass,__pRT__,snd);
_RemoveClassChange_Init(pass,__pRT__,snd);
_RemoveMethodChange_Init(pass,__pRT__,snd);
_RenameClassChange_Init(pass,__pRT__,snd);
_RenameVariableChange_Init(pass,__pRT__,snd);
_AddClassVariableChange_Init(pass,__pRT__,snd);
_AddInstanceVariableChange_Init(pass,__pRT__,snd);
_AddPoolVariableChange_Init(pass,__pRT__,snd);
_InteractiveAddClassChange_Init(pass,__pRT__,snd);
_InteractiveAddMethodChange_Init(pass,__pRT__,snd);
_RemoveClassVariableChange_Init(pass,__pRT__,snd);
_RemoveInstanceVariableChange_Init(pass,__pRT__,snd);
_RemovePoolVariableChange_Init(pass,__pRT__,snd);
_RenameClassVariableChange_Init(pass,__pRT__,snd);
_RenameInstanceVariableChange_Init(pass,__pRT__,snd);


__END_PACKAGE__();
}
