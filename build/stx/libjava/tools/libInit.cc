/*
 * $Header$
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_libjava_tools.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_libjava_tools_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_libjava_tools_InitDefinition() INIT_TEXT_SECTION;
#endif

extern void _JavaAbstractSourceHighlighter_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _JavaCodeBundleEditor_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _JavaCodeLibraryEditor_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _JavaCodeLibraryValidationWarning_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _JavaCompiler_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _JavaLintAnnotation_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _JavaLintHighlighter_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _JavaLintPopupWindow_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _JavaLintService_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _JavaListInspectorView_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _JavaMapInspectorView_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _JavaScannerBase_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _JavaSetInspectorView_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _JavaSettingsApplication_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _JavaSourceDocument_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _JavaSourceRef_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _JavaToolbox_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _stx_137libjava_137tools_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _JavaAbstractLexicalHighlighter_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _JavaScanner_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _JavaSyntaxHighlighter_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _GroovyScanner_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _JavaLexicalHighlighter_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _GroovySourceHighlighter_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);

extern void _stx_137libjava_137tools_extensions_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);

void _libstx_libjava_tools_InitDefinition(int pass, struct __vmData__ *__pRT__, OBJ snd)
{
  __BEGIN_PACKAGE2__("libstx_libjava_tools__DFN", _libstx_libjava_tools_InitDefinition, "stx:libjava/tools");
    _stx_137libjava_137tools_Init(pass,__pRT__,snd);

  __END_PACKAGE__();
}

void _libstx_libjava_tools_Init(int pass, struct __vmData__ *__pRT__, OBJ snd)
{
  __BEGIN_PACKAGE2__("libstx_libjava_tools", _libstx_libjava_tools_Init, "stx:libjava/tools");
    _JavaAbstractSourceHighlighter_Init(pass,__pRT__,snd);
    _JavaCodeBundleEditor_Init(pass,__pRT__,snd);
    _JavaCodeLibraryEditor_Init(pass,__pRT__,snd);
    _JavaCodeLibraryValidationWarning_Init(pass,__pRT__,snd);
    _JavaCompiler_Init(pass,__pRT__,snd);
    _JavaLintAnnotation_Init(pass,__pRT__,snd);
    _JavaLintHighlighter_Init(pass,__pRT__,snd);
    _JavaLintPopupWindow_Init(pass,__pRT__,snd);
    _JavaLintService_Init(pass,__pRT__,snd);
    _JavaListInspectorView_Init(pass,__pRT__,snd);
    _JavaMapInspectorView_Init(pass,__pRT__,snd);
    _JavaScannerBase_Init(pass,__pRT__,snd);
    _JavaSetInspectorView_Init(pass,__pRT__,snd);
    _JavaSettingsApplication_Init(pass,__pRT__,snd);
    _JavaSourceDocument_Init(pass,__pRT__,snd);
    _JavaSourceRef_Init(pass,__pRT__,snd);
    _JavaToolbox_Init(pass,__pRT__,snd);
    _stx_137libjava_137tools_Init(pass,__pRT__,snd);
    _JavaAbstractLexicalHighlighter_Init(pass,__pRT__,snd);
    _JavaScanner_Init(pass,__pRT__,snd);
    _JavaSyntaxHighlighter_Init(pass,__pRT__,snd);
    _GroovyScanner_Init(pass,__pRT__,snd);
    _JavaLexicalHighlighter_Init(pass,__pRT__,snd);
    _GroovySourceHighlighter_Init(pass,__pRT__,snd);

    _stx_137libjava_137tools_extensions_Init(pass,__pRT__,snd);
  __END_PACKAGE__();
}
