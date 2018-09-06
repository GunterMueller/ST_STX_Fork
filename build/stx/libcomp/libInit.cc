/*
 * $Header$
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_libcomp.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_libcomp_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_libcomp_InitDefinition() INIT_TEXT_SECTION;
#endif

extern void _Breakpoint_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _BreakpointDescription_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _BreakpointQuery_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _CompilationErrorHandler_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _CompilationErrorHandlerQuery_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _DoNotShowCompilerWarningAgainActionQuery_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _DoNotShowCompilerWarningAgainForThisMethodActionQuery_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _DoNotShowCompilerWarningAgainForThisReceiverSelectorActionQuery_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _InstrumentationContext_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _InstrumentationInfo_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _InstrumentedMethod_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _LazyMethod_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ObjectFileHandle_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ObjectFileLoader_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ParseError_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ParseNode_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ParseNodeVisitor_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ParseWarning_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ParserFlags_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ProgramNodeBuilder_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ProgramNodeEnumerator_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _STCCompilerInterface_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Scanner_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _SourceFileLoader_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Structure_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _UndefinedVariable_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _UndefinedVariableNotification_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Variable_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _stx_137libcomp_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _AssignmentNode_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _BlockNode_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _BreakpointNode_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _CompilationError_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _EvalScriptingErrorHandler_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _MessageNode_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _MethodNode_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ParseErrorNode_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Parser_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _PluggableParseNodeVisitor_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _PrimaryNode_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ProgramNode_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _SelectorNode_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _StatementNode_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _TextCollectingCompilationErrorHandler_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _UndefinedSuperclassError_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _UndefinedVariableError_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _WarningCompilationErrorHandler_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _AbstractSyntaxHighlighter_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _BinaryNode_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _BreakpointAnalyzer_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ByteCodeCompiler_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _CascadeNode_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ConstantNode_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Explainer_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _PrimitiveNode_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ReturnNode_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _SelfNode_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _UnaryNode_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _VariableNode_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ByteCodeCompilerWithBreakpointSupport_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _CodeCoverageHighlighter_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Decompiler_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ECompletionConstantNode_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _InstrumentingCompiler_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _SuperNode_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _SyntaxHighlighter_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);


void _libstx_libcomp_InitDefinition(int pass, struct __vmData__ *__pRT__, OBJ snd)
{
  __BEGIN_PACKAGE2__("libstx_libcomp__DFN", _libstx_libcomp_InitDefinition, "stx:libcomp");
    _stx_137libcomp_Init(pass,__pRT__,snd);

  __END_PACKAGE__();
}

void _libstx_libcomp_Init(int pass, struct __vmData__ *__pRT__, OBJ snd)
{
  __BEGIN_PACKAGE2__("libstx_libcomp", _libstx_libcomp_Init, "stx:libcomp");
    _Breakpoint_Init(pass,__pRT__,snd);
    _BreakpointDescription_Init(pass,__pRT__,snd);
    _BreakpointQuery_Init(pass,__pRT__,snd);
    _CompilationErrorHandler_Init(pass,__pRT__,snd);
    _CompilationErrorHandlerQuery_Init(pass,__pRT__,snd);
    _DoNotShowCompilerWarningAgainActionQuery_Init(pass,__pRT__,snd);
    _DoNotShowCompilerWarningAgainForThisMethodActionQuery_Init(pass,__pRT__,snd);
    _DoNotShowCompilerWarningAgainForThisReceiverSelectorActionQuery_Init(pass,__pRT__,snd);
    _InstrumentationContext_Init(pass,__pRT__,snd);
    _InstrumentationInfo_Init(pass,__pRT__,snd);
    _InstrumentedMethod_Init(pass,__pRT__,snd);
    _LazyMethod_Init(pass,__pRT__,snd);
    _ObjectFileHandle_Init(pass,__pRT__,snd);
    _ObjectFileLoader_Init(pass,__pRT__,snd);
    _ParseError_Init(pass,__pRT__,snd);
    _ParseNode_Init(pass,__pRT__,snd);
    _ParseNodeVisitor_Init(pass,__pRT__,snd);
    _ParseWarning_Init(pass,__pRT__,snd);
    _ParserFlags_Init(pass,__pRT__,snd);
    _ProgramNodeBuilder_Init(pass,__pRT__,snd);
    _ProgramNodeEnumerator_Init(pass,__pRT__,snd);
    _STCCompilerInterface_Init(pass,__pRT__,snd);
    _Scanner_Init(pass,__pRT__,snd);
    _SourceFileLoader_Init(pass,__pRT__,snd);
    _Structure_Init(pass,__pRT__,snd);
    _UndefinedVariable_Init(pass,__pRT__,snd);
    _UndefinedVariableNotification_Init(pass,__pRT__,snd);
    _Variable_Init(pass,__pRT__,snd);
    _stx_137libcomp_Init(pass,__pRT__,snd);
    _AssignmentNode_Init(pass,__pRT__,snd);
    _BlockNode_Init(pass,__pRT__,snd);
    _BreakpointNode_Init(pass,__pRT__,snd);
    _CompilationError_Init(pass,__pRT__,snd);
    _EvalScriptingErrorHandler_Init(pass,__pRT__,snd);
    _MessageNode_Init(pass,__pRT__,snd);
    _MethodNode_Init(pass,__pRT__,snd);
    _ParseErrorNode_Init(pass,__pRT__,snd);
    _Parser_Init(pass,__pRT__,snd);
    _PluggableParseNodeVisitor_Init(pass,__pRT__,snd);
    _PrimaryNode_Init(pass,__pRT__,snd);
    _ProgramNode_Init(pass,__pRT__,snd);
    _SelectorNode_Init(pass,__pRT__,snd);
    _StatementNode_Init(pass,__pRT__,snd);
    _TextCollectingCompilationErrorHandler_Init(pass,__pRT__,snd);
    _UndefinedSuperclassError_Init(pass,__pRT__,snd);
    _UndefinedVariableError_Init(pass,__pRT__,snd);
    _WarningCompilationErrorHandler_Init(pass,__pRT__,snd);
    _AbstractSyntaxHighlighter_Init(pass,__pRT__,snd);
    _BinaryNode_Init(pass,__pRT__,snd);
    _BreakpointAnalyzer_Init(pass,__pRT__,snd);
    _ByteCodeCompiler_Init(pass,__pRT__,snd);
    _CascadeNode_Init(pass,__pRT__,snd);
    _ConstantNode_Init(pass,__pRT__,snd);
    _Explainer_Init(pass,__pRT__,snd);
    _PrimitiveNode_Init(pass,__pRT__,snd);
    _ReturnNode_Init(pass,__pRT__,snd);
    _SelfNode_Init(pass,__pRT__,snd);
    _UnaryNode_Init(pass,__pRT__,snd);
    _VariableNode_Init(pass,__pRT__,snd);
    _ByteCodeCompilerWithBreakpointSupport_Init(pass,__pRT__,snd);
    _CodeCoverageHighlighter_Init(pass,__pRT__,snd);
    _Decompiler_Init(pass,__pRT__,snd);
    _ECompletionConstantNode_Init(pass,__pRT__,snd);
    _InstrumentingCompiler_Init(pass,__pRT__,snd);
    _SuperNode_Init(pass,__pRT__,snd);
    _SyntaxHighlighter_Init(pass,__pRT__,snd);

    _stx_137libcomp_extensions_Init(pass,__pRT__,snd);
  __END_PACKAGE__();
}
