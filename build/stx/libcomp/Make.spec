# $Header$
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_libcomp.
#
# Warning: once you modify this file, do not rerun
# stmkmp or projectDefinition-build again - otherwise, your changes are lost.
#
# This file contains specifications which are common to all platforms.
#

# Do NOT CHANGE THESE DEFINITIONS
# (otherwise, ST/X will have a hard time to find out the packages location from its packageID,
#  to find the source code of a class and to find the library for a package)
MODULE=stx
MODULE_DIR=libcomp
PACKAGE=$(MODULE):$(MODULE_DIR)


# Argument(s) to the stc compiler (stc --usage).
#  -headerDir=. : create header files locally
#                (if removed, they will be created as common
#  -Pxxx       : defines the package
#  -Zxxx       : a prefix for variables within the classLib
#  -Dxxx       : defines passed to to CC for inline C-code
#  -Ixxx       : include path passed to CC for inline C-code
#  +optspace   : optimized for space
#  +optspace2  : optimized more for space
#  +optspace3  : optimized even more for space
#  +optinline  : generate inline code for some ST constructs
#  +inlineNew  : additionally inline new
#  +inlineMath : additionally inline some floatPnt math stuff
#
# ********** OPTIONAL: MODIFY the next line(s) ***
# STCLOCALOPTIMIZATIONS=+optinline +inlineNew
# STCLOCALOPTIMIZATIONS=+optspace3
STCLOCALOPTIMIZATIONS=+optinline +optinline2 +inlinenew


# Argument(s) to the stc compiler (stc --usage).
#  -warn            : no warnings
#  -warnNonStandard : no warnings about ST/X extensions
#  -warnEOLComments : no warnings about EOL comment extension
#  -warnPrivacy     : no warnings about privateClass extension
#  -warnUnused      : no warnings about unused variables
#
# ********** OPTIONAL: MODIFY the next line(s) ***
# STCWARNINGS=-warn
# STCWARNINGS=-warnNonStandard
# STCWARNINGS=-warnEOLComments
STCWARNINGS=-warnNonStandard -warnUnused

COMMON_CLASSES= \
	Breakpoint \
	BreakpointDescription \
	BreakpointQuery \
	CompilationErrorHandler \
	CompilationErrorHandlerQuery \
	DoNotShowCompilerWarningAgainActionQuery \
	DoNotShowCompilerWarningAgainForThisMethodActionQuery \
	DoNotShowCompilerWarningAgainForThisReceiverSelectorActionQuery \
	InstrumentationContext \
	InstrumentationInfo \
	InstrumentedMethod \
	LazyMethod \
	ObjectFileHandle \
	ObjectFileLoader \
	ParseError \
	ParseNode \
	ParseNodeVisitor \
	ParseWarning \
	ParserFlags \
	ProgramNodeBuilder \
	ProgramNodeEnumerator \
	STCCompilerInterface \
	Scanner \
	SourceFileLoader \
	Structure \
	UndefinedVariable \
	UndefinedVariableNotification \
	Variable \
	stx_libcomp \
	AssignmentNode \
	BlockNode \
	BreakpointNode \
	CompilationError \
	EvalScriptingErrorHandler \
	MessageNode \
	MethodNode \
	ParseErrorNode \
	Parser \
	PluggableParseNodeVisitor \
	PrimaryNode \
	ProgramNode \
	SelectorNode \
	StatementNode \
	TextCollectingCompilationErrorHandler \
	UndefinedSuperclassError \
	UndefinedVariableError \
	WarningCompilationErrorHandler \
	AbstractSyntaxHighlighter \
	BinaryNode \
	BreakpointAnalyzer \
	ByteCodeCompiler \
	CascadeNode \
	ConstantNode \
	Explainer \
	PrimitiveNode \
	ReturnNode \
	SelfNode \
	UnaryNode \
	VariableNode \
	ByteCodeCompilerWithBreakpointSupport \
	CodeCoverageHighlighter \
	Decompiler \
	ECompletionConstantNode \
	InstrumentingCompiler \
	SuperNode \
	SyntaxHighlighter \




COMMON_OBJS= \
    $(OUTDIR_SLASH)Breakpoint.$(O) \
    $(OUTDIR_SLASH)BreakpointDescription.$(O) \
    $(OUTDIR_SLASH)BreakpointQuery.$(O) \
    $(OUTDIR_SLASH)CompilationErrorHandler.$(O) \
    $(OUTDIR_SLASH)CompilationErrorHandlerQuery.$(O) \
    $(OUTDIR_SLASH)DoNotShowCompilerWarningAgainActionQuery.$(O) \
    $(OUTDIR_SLASH)DoNotShowCompilerWarningAgainForThisMethodActionQuery.$(O) \
    $(OUTDIR_SLASH)DoNotShowCompilerWarningAgainForThisReceiverSelectorActionQuery.$(O) \
    $(OUTDIR_SLASH)InstrumentationContext.$(O) \
    $(OUTDIR_SLASH)InstrumentationInfo.$(O) \
    $(OUTDIR_SLASH)InstrumentedMethod.$(O) \
    $(OUTDIR_SLASH)LazyMethod.$(O) \
    $(OUTDIR_SLASH)ObjectFileHandle.$(O) \
    $(OUTDIR_SLASH)ObjectFileLoader.$(O) \
    $(OUTDIR_SLASH)ParseError.$(O) \
    $(OUTDIR_SLASH)ParseNode.$(O) \
    $(OUTDIR_SLASH)ParseNodeVisitor.$(O) \
    $(OUTDIR_SLASH)ParseWarning.$(O) \
    $(OUTDIR_SLASH)ParserFlags.$(O) \
    $(OUTDIR_SLASH)ProgramNodeBuilder.$(O) \
    $(OUTDIR_SLASH)ProgramNodeEnumerator.$(O) \
    $(OUTDIR_SLASH)STCCompilerInterface.$(O) \
    $(OUTDIR_SLASH)Scanner.$(O) \
    $(OUTDIR_SLASH)SourceFileLoader.$(O) \
    $(OUTDIR_SLASH)Structure.$(O) \
    $(OUTDIR_SLASH)UndefinedVariable.$(O) \
    $(OUTDIR_SLASH)UndefinedVariableNotification.$(O) \
    $(OUTDIR_SLASH)Variable.$(O) \
    $(OUTDIR_SLASH)stx_libcomp.$(O) \
    $(OUTDIR_SLASH)AssignmentNode.$(O) \
    $(OUTDIR_SLASH)BlockNode.$(O) \
    $(OUTDIR_SLASH)BreakpointNode.$(O) \
    $(OUTDIR_SLASH)CompilationError.$(O) \
    $(OUTDIR_SLASH)EvalScriptingErrorHandler.$(O) \
    $(OUTDIR_SLASH)MessageNode.$(O) \
    $(OUTDIR_SLASH)MethodNode.$(O) \
    $(OUTDIR_SLASH)ParseErrorNode.$(O) \
    $(OUTDIR_SLASH)Parser.$(O) \
    $(OUTDIR_SLASH)PluggableParseNodeVisitor.$(O) \
    $(OUTDIR_SLASH)PrimaryNode.$(O) \
    $(OUTDIR_SLASH)ProgramNode.$(O) \
    $(OUTDIR_SLASH)SelectorNode.$(O) \
    $(OUTDIR_SLASH)StatementNode.$(O) \
    $(OUTDIR_SLASH)TextCollectingCompilationErrorHandler.$(O) \
    $(OUTDIR_SLASH)UndefinedSuperclassError.$(O) \
    $(OUTDIR_SLASH)UndefinedVariableError.$(O) \
    $(OUTDIR_SLASH)WarningCompilationErrorHandler.$(O) \
    $(OUTDIR_SLASH)AbstractSyntaxHighlighter.$(O) \
    $(OUTDIR_SLASH)BinaryNode.$(O) \
    $(OUTDIR_SLASH)BreakpointAnalyzer.$(O) \
    $(OUTDIR_SLASH)ByteCodeCompiler.$(O) \
    $(OUTDIR_SLASH)CascadeNode.$(O) \
    $(OUTDIR_SLASH)ConstantNode.$(O) \
    $(OUTDIR_SLASH)Explainer.$(O) \
    $(OUTDIR_SLASH)PrimitiveNode.$(O) \
    $(OUTDIR_SLASH)ReturnNode.$(O) \
    $(OUTDIR_SLASH)SelfNode.$(O) \
    $(OUTDIR_SLASH)UnaryNode.$(O) \
    $(OUTDIR_SLASH)VariableNode.$(O) \
    $(OUTDIR_SLASH)ByteCodeCompilerWithBreakpointSupport.$(O) \
    $(OUTDIR_SLASH)CodeCoverageHighlighter.$(O) \
    $(OUTDIR_SLASH)Decompiler.$(O) \
    $(OUTDIR_SLASH)ECompletionConstantNode.$(O) \
    $(OUTDIR_SLASH)InstrumentingCompiler.$(O) \
    $(OUTDIR_SLASH)SuperNode.$(O) \
    $(OUTDIR_SLASH)SyntaxHighlighter.$(O) \
    $(OUTDIR_SLASH)extensions.$(O) \



