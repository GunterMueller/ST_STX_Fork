/*
 * $Header: /cvs/stx/stx/goodies/petitparser/gui/libInit.cc,v 1.1 2014-03-04 21:20:44 cg Exp $
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_goodies_petitparser_gui.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_goodies_petitparser_gui_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_goodies_petitparser_gui_InitDefinition() INIT_TEXT_SECTION;
#endif

void _libstx_goodies_petitparser_gui_InitDefinition(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_goodies_petitparser_gui__DFN", _libstx_goodies_petitparser_gui_InitDefinition, "stx:goodies/petitparser/gui");
_stx_137goodies_137petitparser_137gui_Init(pass,__pRT__,snd);

__END_PACKAGE__();
}

void _libstx_goodies_petitparser_gui_Init(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_goodies_petitparser_gui", _libstx_goodies_petitparser_gui_Init, "stx:goodies/petitparser/gui");
_GLMCompositePresentation_Init(pass,__pRT__,snd);
_PPAddParserRefactoring_Init(pass,__pRT__,snd);
_PPBrowserStream_Init(pass,__pRT__,snd);
_PPDefineProdcutionRefactoring_Init(pass,__pRT__,snd);
_PPDrabBrowser_Init(pass,__pRT__,snd);
_PPExtractProdcutionRefactoring_Init(pass,__pRT__,snd);
_PPParserDebuggerResult_Init(pass,__pRT__,snd);
_PPRefactoringUtils_Init(pass,__pRT__,snd);
_PPRemoveParserRefactoring_Init(pass,__pRT__,snd);
_PPRenameProdcutionRefactoring_Init(pass,__pRT__,snd);
_PPTextHighlighter_Init(pass,__pRT__,snd);
_RBRefactoring_Init(pass,__pRT__,snd);
_RBRemoveClassRefactoring_Init(pass,__pRT__,snd);
_stx_137goodies_137petitparser_137gui_Init(pass,__pRT__,snd);
_PPBrowser_Init(pass,__pRT__,snd);
_PPParserBrowser_Init(pass,__pRT__,snd);
_PPParserInspector_Init(pass,__pRT__,snd);
_PPRemoveProdcutionRefactoring_Init(pass,__pRT__,snd);

_stx_137goodies_137petitparser_137gui_extensions_Init(pass,__pRT__,snd);
__END_PACKAGE__();
}
