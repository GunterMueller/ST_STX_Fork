/*
 * $Header$
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_goodies_refactoryBrowser_lint_spelling.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_goodies_refactoryBrowser_lint_spelling_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_goodies_refactoryBrowser_lint_spelling_InitDefinition() INIT_TEXT_SECTION;
#endif

extern void _RBSpellChecker_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBSpellingRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _stx_137goodies_137refactoryBrowser_137lint_137spelling_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBArgumentVariableNamesSpellingRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBClassCategoriesSpellingRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBClassCommentsSpellingRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBClassNamesSpellingRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBClassVariableNamesSpellingRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBInstanceVariableNamesSpellingRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBInternalSpellChecker_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBLiteralValuesSpellingRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBMacSpellChecker_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBMethodCommentsSpellingRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBMethodProtocolsSpellingRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBMethodSelectorsSpellingRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBPoolVariableNamesSpellingRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RBTemporaryVariableNamesSpellingRule_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);



void _libstx_goodies_refactoryBrowser_lint_spelling_InitDefinition(int pass, struct __vmData__ *__pRT__, OBJ snd)
{
  __BEGIN_PACKAGE2__("libstx_goodies_refactoryBrowser_lint_spelling__DFN", _libstx_goodies_refactoryBrowser_lint_spelling_InitDefinition, "stx:goodies/refactoryBrowser/lint/spelling");
    _stx_137goodies_137refactoryBrowser_137lint_137spelling_Init(pass,__pRT__,snd);

  __END_PACKAGE__();
}

void _libstx_goodies_refactoryBrowser_lint_spelling_Init(int pass, struct __vmData__ *__pRT__, OBJ snd)
{
  __BEGIN_PACKAGE2__("libstx_goodies_refactoryBrowser_lint_spelling", _libstx_goodies_refactoryBrowser_lint_spelling_Init, "stx:goodies/refactoryBrowser/lint/spelling");
    _RBSpellChecker_Init(pass,__pRT__,snd);
    _RBSpellingRule_Init(pass,__pRT__,snd);
    _stx_137goodies_137refactoryBrowser_137lint_137spelling_Init(pass,__pRT__,snd);
    _RBArgumentVariableNamesSpellingRule_Init(pass,__pRT__,snd);
    _RBClassCategoriesSpellingRule_Init(pass,__pRT__,snd);
    _RBClassCommentsSpellingRule_Init(pass,__pRT__,snd);
    _RBClassNamesSpellingRule_Init(pass,__pRT__,snd);
    _RBClassVariableNamesSpellingRule_Init(pass,__pRT__,snd);
    _RBInstanceVariableNamesSpellingRule_Init(pass,__pRT__,snd);
    _RBInternalSpellChecker_Init(pass,__pRT__,snd);
    _RBLiteralValuesSpellingRule_Init(pass,__pRT__,snd);
    _RBMacSpellChecker_Init(pass,__pRT__,snd);
    _RBMethodCommentsSpellingRule_Init(pass,__pRT__,snd);
    _RBMethodProtocolsSpellingRule_Init(pass,__pRT__,snd);
    _RBMethodSelectorsSpellingRule_Init(pass,__pRT__,snd);
    _RBPoolVariableNamesSpellingRule_Init(pass,__pRT__,snd);
    _RBTemporaryVariableNamesSpellingRule_Init(pass,__pRT__,snd);


  __END_PACKAGE__();
}
