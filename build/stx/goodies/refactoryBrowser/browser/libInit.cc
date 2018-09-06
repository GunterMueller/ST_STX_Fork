/*
 * $Header: /cvs/stx/stx/goodies/refactoryBrowser/browser/libInit.cc,v 1.11 2014-04-02 10:53:08 vrany Exp $
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_goodies_refactoryBrowser_browser.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_goodies_refactoryBrowser_browser_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_goodies_refactoryBrowser_browser_InitDefinition() INIT_TEXT_SECTION;
#endif

void _libstx_goodies_refactoryBrowser_browser_InitDefinition(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_goodies_refactoryBrowser_browser__DFN", _libstx_goodies_refactoryBrowser_browser_InitDefinition, "stx:goodies/refactoryBrowser/browser");
_stx_137goodies_137refactoryBrowser_137browser_Init(pass,__pRT__,snd);

__END_PACKAGE__();
}

void _libstx_goodies_refactoryBrowser_browser_Init(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_goodies_refactoryBrowser_browser", _libstx_goodies_refactoryBrowser_browser_Init, "stx:goodies/refactoryBrowser/browser");
_BrowserDialog_Init(pass,__pRT__,snd);
_BrowserEnvironmentWrapper_Init(pass,__pRT__,snd);
_LimitedEnvironment_Init(pass,__pRT__,snd);
_RefactoryTyper_Init(pass,__pRT__,snd);
_stx_137goodies_137refactoryBrowser_137browser_Init(pass,__pRT__,snd);
_AndEnvironment_Init(pass,__pRT__,snd);
_CategoryEnvironment_Init(pass,__pRT__,snd);
_ClassEnvironment_Init(pass,__pRT__,snd);
_EmptyEnvironment_Init(pass,__pRT__,snd);
_MethodNameDialog_Init(pass,__pRT__,snd);
_NamespaceEnvironment_Init(pass,__pRT__,snd);
_NotEnvironment_Init(pass,__pRT__,snd);
_PackageEnvironment_Init(pass,__pRT__,snd);
_ProtocolEnvironment_Init(pass,__pRT__,snd);
_RestrictedEnvironment_Init(pass,__pRT__,snd);
_SelectorEnvironment_Init(pass,__pRT__,snd);
_VariableEnvironment_Init(pass,__pRT__,snd);
_MultiEnvironment_Init(pass,__pRT__,snd);
_ParseTreeEnvironment_Init(pass,__pRT__,snd);

_stx_137goodies_137refactoryBrowser_137browser_extensions_Init(pass,__pRT__,snd);
__END_PACKAGE__();
}
