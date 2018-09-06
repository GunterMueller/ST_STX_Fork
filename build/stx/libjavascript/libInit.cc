/*
 * $Header: /cvs/stx/stx/libjavascript/libInit.cc,v 1.48 2018-07-05 09:47:17 stefan Exp $
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_libjavascript.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_libjavascript_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_libjavascript_InitDefinition() INIT_TEXT_SECTION;
#endif

extern void _HTMLDocGeneratorForJavaScript_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _JavaScriptClass_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _JavaScriptClassNode_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _JavaScriptCodeGeneratorTool_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _JavaScriptCompletionEngine_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _JavaScriptConstantNode_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _JavaScriptEnvironment_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _JavaScriptFunction_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _JavaScriptFunctionNode_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _JavaScriptMetaclass_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _JavaScriptObject_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _JavaScriptParseNodeVisitor_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _JavaScriptScanner_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _JavaScriptSimulatedBrowserEnvironment_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _JavaScriptSourceFileWriter_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _JavaScriptSourceReader_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _JavaScriptVariable_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _JavaScriptVariableNode_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Math_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _STXJavaScriptLanguage_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _stx_137libjavascript_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _JavaScriptFunctionWithBreakpoints_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _JavaScriptInnerFunctionNode_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _JavaScriptParseNodeValidator_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _JavaScriptParser_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _JavaScriptCompiler_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _JavaScriptCompletionParser_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _JavaScriptSyntaxHighlighter_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _JavaScriptCompilerWithBreakpointSupport_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);


void _libstx_libjavascript_InitDefinition(int pass, struct __vmData__ *__pRT__, OBJ snd)
{
  __BEGIN_PACKAGE2__("libstx_libjavascript__DFN", _libstx_libjavascript_InitDefinition, "stx:libjavascript");
    _stx_137libjavascript_Init(pass,__pRT__,snd);

  __END_PACKAGE__();
}

void _libstx_libjavascript_Init(int pass, struct __vmData__ *__pRT__, OBJ snd)
{
  __BEGIN_PACKAGE2__("libstx_libjavascript", _libstx_libjavascript_Init, "stx:libjavascript");
    _HTMLDocGeneratorForJavaScript_Init(pass,__pRT__,snd);
    _JavaScriptClass_Init(pass,__pRT__,snd);
    _JavaScriptClassNode_Init(pass,__pRT__,snd);
    _JavaScriptCodeGeneratorTool_Init(pass,__pRT__,snd);
    _JavaScriptCompletionEngine_Init(pass,__pRT__,snd);
    _JavaScriptConstantNode_Init(pass,__pRT__,snd);
    _JavaScriptEnvironment_Init(pass,__pRT__,snd);
    _JavaScriptFunction_Init(pass,__pRT__,snd);
    _JavaScriptFunctionNode_Init(pass,__pRT__,snd);
    _JavaScriptMetaclass_Init(pass,__pRT__,snd);
    _JavaScriptObject_Init(pass,__pRT__,snd);
    _JavaScriptParseNodeVisitor_Init(pass,__pRT__,snd);
    _JavaScriptScanner_Init(pass,__pRT__,snd);
    _JavaScriptSimulatedBrowserEnvironment_Init(pass,__pRT__,snd);
    _JavaScriptSourceFileWriter_Init(pass,__pRT__,snd);
    _JavaScriptSourceReader_Init(pass,__pRT__,snd);
    _JavaScriptVariable_Init(pass,__pRT__,snd);
    _JavaScriptVariableNode_Init(pass,__pRT__,snd);
    _Math_Init(pass,__pRT__,snd);
    _STXJavaScriptLanguage_Init(pass,__pRT__,snd);
    _stx_137libjavascript_Init(pass,__pRT__,snd);
    _JavaScriptFunctionWithBreakpoints_Init(pass,__pRT__,snd);
    _JavaScriptInnerFunctionNode_Init(pass,__pRT__,snd);
    _JavaScriptParseNodeValidator_Init(pass,__pRT__,snd);
    _JavaScriptParser_Init(pass,__pRT__,snd);
    _JavaScriptCompiler_Init(pass,__pRT__,snd);
    _JavaScriptCompletionParser_Init(pass,__pRT__,snd);
    _JavaScriptSyntaxHighlighter_Init(pass,__pRT__,snd);
    _JavaScriptCompilerWithBreakpointSupport_Init(pass,__pRT__,snd);

    _stx_137libjavascript_extensions_Init(pass,__pRT__,snd);
  __END_PACKAGE__();
}
