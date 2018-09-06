# $Header$
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_libcomp.
#
# Warning: once you modify this file, do not rerun
# stmkmp or projectDefinition-build again - otherwise, your changes are lost.
#
# Notice, that the name bc.mak is historical (from times, when only borland c was supported).
# This file contains make rules for the win32 platform using either borland-bcc or visual-c.
# It shares common definitions with the unix-make in Make.spec.
# The bc.mak supports the following targets:
#    bmake         - compile all st-files to a classLib (dll)
#    bmake clean   - clean all temp files
#    bmake clobber - clean all
#
# Historic Note:
#  this used to contain only rules to make with borland
#    (called via bmake, by "make.exe -f bc.mak")
#  this has changed; it is now also possible to build using microsoft visual c
#    (called via vcmake, by "make.exe -f bc.mak -DUSEVC")
#
TOP=..
INCLUDE_TOP=$(TOP)\..


# see stdHeader_bc for LIBCOMP_BASE
LIB_BASE=$(LIBCOMP_BASE)


!INCLUDE $(TOP)\rules\stdHeader_bc

!INCLUDE Make.spec

LIBNAME=libstx_libcomp
MODULE_PATH=libcomp
RESFILES=stx_libcompWINrc.$(RES)



LOCALINCLUDES= -I$(INCLUDE_TOP)\stx\libbasic
LOCALDEFINES=

STCLOCALOPT=-package=$(PACKAGE) -I. $(LOCALINCLUDES) -headerDir=. $(STCLOCALOPTIMIZATIONS) $(STCWARNINGS) $(LOCALDEFINES) $(COMMONSYMBOLS) -varPrefix=$(LIBNAME)
LOCALLIBS=-lPsapi

OBJS= $(COMMON_OBJS) $(WIN32_OBJS)

ALL::  classLibRule

classLibRule: $(OUTDIR) $(OUTDIR)$(LIBNAME).dll

!INCLUDE $(TOP)\rules\stdRules_bc

# build all mandatory prerequisite packages (containing superclasses) for this package
prereq:
	pushd ..\libbasic & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "







test: $(TOP)\goodies\builder\reports\NUL
	pushd $(TOP)\goodies\builder\reports & $(MAKE_BAT)
	$(TOP)\goodies\builder\reports\report-runner.bat -D . -r Builder::TestReport -p $(PACKAGE)
        
clean::
	del *.$(CSUFFIX)


# BEGINMAKEDEPEND --- do not remove this line; make depend needs it
$(OUTDIR)Breakpoint.$(O) Breakpoint.$(C) Breakpoint.$(H): Breakpoint.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)BreakpointDescription.$(O) BreakpointDescription.$(C) BreakpointDescription.$(H): BreakpointDescription.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)BreakpointQuery.$(O) BreakpointQuery.$(C) BreakpointQuery.$(H): BreakpointQuery.st $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Notification.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\Query.$(H) $(STCHDR)
$(OUTDIR)CompilationErrorHandler.$(O) CompilationErrorHandler.$(C) CompilationErrorHandler.$(H): CompilationErrorHandler.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)CompilationErrorHandlerQuery.$(O) CompilationErrorHandlerQuery.$(C) CompilationErrorHandlerQuery.$(H): CompilationErrorHandlerQuery.st $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Notification.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\Query.$(H) $(STCHDR)
$(OUTDIR)DoNotShowCompilerWarningAgainActionQuery.$(O) DoNotShowCompilerWarningAgainActionQuery.$(C) DoNotShowCompilerWarningAgainActionQuery.$(H): DoNotShowCompilerWarningAgainActionQuery.st $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Notification.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\Query.$(H) $(STCHDR)
$(OUTDIR)DoNotShowCompilerWarningAgainForThisMethodActionQuery.$(O) DoNotShowCompilerWarningAgainForThisMethodActionQuery.$(C) DoNotShowCompilerWarningAgainForThisMethodActionQuery.$(H): DoNotShowCompilerWarningAgainForThisMethodActionQuery.st $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Notification.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\Query.$(H) $(STCHDR)
$(OUTDIR)DoNotShowCompilerWarningAgainForThisReceiverSelectorActionQuery.$(O) DoNotShowCompilerWarningAgainForThisReceiverSelectorActionQuery.$(C) DoNotShowCompilerWarningAgainForThisReceiverSelectorActionQuery.$(H): DoNotShowCompilerWarningAgainForThisReceiverSelectorActionQuery.st $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Notification.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\Query.$(H) $(STCHDR)
$(OUTDIR)InstrumentationContext.$(O) InstrumentationContext.$(C) InstrumentationContext.$(H): InstrumentationContext.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)InstrumentationInfo.$(O) InstrumentationInfo.$(C) InstrumentationInfo.$(H): InstrumentationInfo.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)InstrumentedMethod.$(O) InstrumentedMethod.$(C) InstrumentedMethod.$(H): InstrumentedMethod.st $(INCLUDE_TOP)\stx\libbasic\CompiledCode.$(H) $(INCLUDE_TOP)\stx\libbasic\ExecutableFunction.$(H) $(INCLUDE_TOP)\stx\libbasic\Method.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)LazyMethod.$(O) LazyMethod.$(C) LazyMethod.$(H): LazyMethod.st $(INCLUDE_TOP)\stx\libbasic\CompiledCode.$(H) $(INCLUDE_TOP)\stx\libbasic\ExecutableFunction.$(H) $(INCLUDE_TOP)\stx\libbasic\Method.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)ObjectFileHandle.$(O) ObjectFileHandle.$(C) ObjectFileHandle.$(H): ObjectFileHandle.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)ObjectFileLoader.$(O) ObjectFileLoader.$(C) ObjectFileLoader.$(H): ObjectFileLoader.st $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Notification.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)ParseError.$(O) ParseError.$(C) ParseError.$(H): ParseError.st $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\ProceedableError.$(H) $(STCHDR)
$(OUTDIR)ParseNode.$(O) ParseNode.$(C) ParseNode.$(H): ParseNode.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)ParseNodeVisitor.$(O) ParseNodeVisitor.$(C) ParseNodeVisitor.$(H): ParseNodeVisitor.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)ParseWarning.$(O) ParseWarning.$(C) ParseWarning.$(H): ParseWarning.st $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Notification.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)ParserFlags.$(O) ParserFlags.$(C) ParserFlags.$(H): ParserFlags.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)ProgramNodeBuilder.$(O) ProgramNodeBuilder.$(C) ProgramNodeBuilder.$(H): ProgramNodeBuilder.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)ProgramNodeEnumerator.$(O) ProgramNodeEnumerator.$(C) ProgramNodeEnumerator.$(H): ProgramNodeEnumerator.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)STCCompilerInterface.$(O) STCCompilerInterface.$(C) STCCompilerInterface.$(H): STCCompilerInterface.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Scanner.$(O) Scanner.$(C) Scanner.$(H): Scanner.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SourceFileLoader.$(O) SourceFileLoader.$(C) SourceFileLoader.$(H): SourceFileLoader.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Structure.$(O) Structure.$(C) Structure.$(H): Structure.st $(INCLUDE_TOP)\stx\libbasic\Behavior.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)UndefinedVariable.$(O) UndefinedVariable.$(C) UndefinedVariable.$(H): UndefinedVariable.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)UndefinedVariableNotification.$(O) UndefinedVariableNotification.$(C) UndefinedVariableNotification.$(H): UndefinedVariableNotification.st $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Notification.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Variable.$(O) Variable.$(C) Variable.$(H): Variable.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)stx_libcomp.$(O) stx_libcomp.$(C) stx_libcomp.$(H): stx_libcomp.st $(INCLUDE_TOP)\stx\libbasic\LibraryDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\ProjectDefinition.$(H) $(STCHDR)
$(OUTDIR)AssignmentNode.$(O) AssignmentNode.$(C) AssignmentNode.$(H): AssignmentNode.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libcomp\ParseNode.$(H) $(STCHDR)
$(OUTDIR)BlockNode.$(O) BlockNode.$(C) BlockNode.$(H): BlockNode.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libcomp\ParseNode.$(H) $(STCHDR)
$(OUTDIR)BreakpointNode.$(O) BreakpointNode.$(C) BreakpointNode.$(H): BreakpointNode.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libcomp\ParseNode.$(H) $(STCHDR)
$(OUTDIR)CompilationError.$(O) CompilationError.$(C) CompilationError.$(H): CompilationError.st $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\ProceedableError.$(H) $(INCLUDE_TOP)\stx\libcomp\ParseError.$(H) $(STCHDR)
$(OUTDIR)EvalScriptingErrorHandler.$(O) EvalScriptingErrorHandler.$(C) EvalScriptingErrorHandler.$(H): EvalScriptingErrorHandler.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libcomp\CompilationErrorHandler.$(H) $(STCHDR)
$(OUTDIR)MessageNode.$(O) MessageNode.$(C) MessageNode.$(H): MessageNode.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libcomp\ParseNode.$(H) $(STCHDR)
$(OUTDIR)MethodNode.$(O) MethodNode.$(C) MethodNode.$(H): MethodNode.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libcomp\ParseNode.$(H) $(STCHDR)
$(OUTDIR)ParseErrorNode.$(O) ParseErrorNode.$(C) ParseErrorNode.$(H): ParseErrorNode.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libcomp\ParseNode.$(H) $(STCHDR)
$(OUTDIR)Parser.$(O) Parser.$(C) Parser.$(H): Parser.st $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Notification.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\Query.$(H) $(INCLUDE_TOP)\stx\libcomp\Scanner.$(H) $(STCHDR)
$(OUTDIR)PluggableParseNodeVisitor.$(O) PluggableParseNodeVisitor.$(C) PluggableParseNodeVisitor.$(H): PluggableParseNodeVisitor.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libcomp\ParseNodeVisitor.$(H) $(STCHDR)
$(OUTDIR)PrimaryNode.$(O) PrimaryNode.$(C) PrimaryNode.$(H): PrimaryNode.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libcomp\ParseNode.$(H) $(STCHDR)
$(OUTDIR)ProgramNode.$(O) ProgramNode.$(C) ProgramNode.$(H): ProgramNode.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libcomp\ParseNode.$(H) $(STCHDR)
$(OUTDIR)SelectorNode.$(O) SelectorNode.$(C) SelectorNode.$(H): SelectorNode.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libcomp\ParseNode.$(H) $(STCHDR)
$(OUTDIR)StatementNode.$(O) StatementNode.$(C) StatementNode.$(H): StatementNode.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libcomp\ParseNode.$(H) $(STCHDR)
$(OUTDIR)TextCollectingCompilationErrorHandler.$(O) TextCollectingCompilationErrorHandler.$(C) TextCollectingCompilationErrorHandler.$(H): TextCollectingCompilationErrorHandler.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libcomp\CompilationErrorHandler.$(H) $(STCHDR)
$(OUTDIR)UndefinedSuperclassError.$(O) UndefinedSuperclassError.$(C) UndefinedSuperclassError.$(H): UndefinedSuperclassError.st $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\ProceedableError.$(H) $(INCLUDE_TOP)\stx\libcomp\ParseError.$(H) $(STCHDR)
$(OUTDIR)UndefinedVariableError.$(O) UndefinedVariableError.$(C) UndefinedVariableError.$(H): UndefinedVariableError.st $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\ProceedableError.$(H) $(INCLUDE_TOP)\stx\libcomp\ParseError.$(H) $(STCHDR)
$(OUTDIR)WarningCompilationErrorHandler.$(O) WarningCompilationErrorHandler.$(C) WarningCompilationErrorHandler.$(H): WarningCompilationErrorHandler.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libcomp\CompilationErrorHandler.$(H) $(STCHDR)
$(OUTDIR)AbstractSyntaxHighlighter.$(O) AbstractSyntaxHighlighter.$(C) AbstractSyntaxHighlighter.$(H): AbstractSyntaxHighlighter.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libcomp\Parser.$(H) $(INCLUDE_TOP)\stx\libcomp\Scanner.$(H) $(STCHDR)
$(OUTDIR)BinaryNode.$(O) BinaryNode.$(C) BinaryNode.$(H): BinaryNode.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libcomp\MessageNode.$(H) $(INCLUDE_TOP)\stx\libcomp\ParseNode.$(H) $(STCHDR)
$(OUTDIR)BreakpointAnalyzer.$(O) BreakpointAnalyzer.$(C) BreakpointAnalyzer.$(H): BreakpointAnalyzer.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libcomp\Parser.$(H) $(INCLUDE_TOP)\stx\libcomp\Scanner.$(H) $(STCHDR)
$(OUTDIR)ByteCodeCompiler.$(O) ByteCodeCompiler.$(C) ByteCodeCompiler.$(H): ByteCodeCompiler.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libcomp\Parser.$(H) $(INCLUDE_TOP)\stx\libcomp\Scanner.$(H) $(STCHDR)
$(OUTDIR)CascadeNode.$(O) CascadeNode.$(C) CascadeNode.$(H): CascadeNode.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libcomp\MessageNode.$(H) $(INCLUDE_TOP)\stx\libcomp\ParseNode.$(H) $(STCHDR)
$(OUTDIR)ConstantNode.$(O) ConstantNode.$(C) ConstantNode.$(H): ConstantNode.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libcomp\ParseNode.$(H) $(INCLUDE_TOP)\stx\libcomp\PrimaryNode.$(H) $(STCHDR)
$(OUTDIR)Explainer.$(O) Explainer.$(C) Explainer.$(H): Explainer.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libcomp\Parser.$(H) $(INCLUDE_TOP)\stx\libcomp\Scanner.$(H) $(STCHDR)
$(OUTDIR)PrimitiveNode.$(O) PrimitiveNode.$(C) PrimitiveNode.$(H): PrimitiveNode.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libcomp\ParseNode.$(H) $(INCLUDE_TOP)\stx\libcomp\StatementNode.$(H) $(STCHDR)
$(OUTDIR)ReturnNode.$(O) ReturnNode.$(C) ReturnNode.$(H): ReturnNode.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libcomp\ParseNode.$(H) $(INCLUDE_TOP)\stx\libcomp\StatementNode.$(H) $(STCHDR)
$(OUTDIR)SelfNode.$(O) SelfNode.$(C) SelfNode.$(H): SelfNode.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libcomp\ParseNode.$(H) $(INCLUDE_TOP)\stx\libcomp\PrimaryNode.$(H) $(STCHDR)
$(OUTDIR)UnaryNode.$(O) UnaryNode.$(C) UnaryNode.$(H): UnaryNode.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libcomp\MessageNode.$(H) $(INCLUDE_TOP)\stx\libcomp\ParseNode.$(H) $(STCHDR)
$(OUTDIR)VariableNode.$(O) VariableNode.$(C) VariableNode.$(H): VariableNode.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libcomp\ParseNode.$(H) $(INCLUDE_TOP)\stx\libcomp\PrimaryNode.$(H) $(STCHDR)
$(OUTDIR)ByteCodeCompilerWithBreakpointSupport.$(O) ByteCodeCompilerWithBreakpointSupport.$(C) ByteCodeCompilerWithBreakpointSupport.$(H): ByteCodeCompilerWithBreakpointSupport.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libcomp\ByteCodeCompiler.$(H) $(INCLUDE_TOP)\stx\libcomp\Parser.$(H) $(INCLUDE_TOP)\stx\libcomp\Scanner.$(H) $(STCHDR)
$(OUTDIR)CodeCoverageHighlighter.$(O) CodeCoverageHighlighter.$(C) CodeCoverageHighlighter.$(H): CodeCoverageHighlighter.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libcomp\AbstractSyntaxHighlighter.$(H) $(INCLUDE_TOP)\stx\libcomp\Parser.$(H) $(INCLUDE_TOP)\stx\libcomp\Scanner.$(H) $(STCHDR)
$(OUTDIR)Decompiler.$(O) Decompiler.$(C) Decompiler.$(H): Decompiler.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libcomp\ByteCodeCompiler.$(H) $(INCLUDE_TOP)\stx\libcomp\Parser.$(H) $(INCLUDE_TOP)\stx\libcomp\Scanner.$(H) $(STCHDR)
$(OUTDIR)ECompletionConstantNode.$(O) ECompletionConstantNode.$(C) ECompletionConstantNode.$(H): ECompletionConstantNode.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libcomp\ConstantNode.$(H) $(INCLUDE_TOP)\stx\libcomp\ParseNode.$(H) $(INCLUDE_TOP)\stx\libcomp\PrimaryNode.$(H) $(STCHDR)
$(OUTDIR)InstrumentingCompiler.$(O) InstrumentingCompiler.$(C) InstrumentingCompiler.$(H): InstrumentingCompiler.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libcomp\ByteCodeCompiler.$(H) $(INCLUDE_TOP)\stx\libcomp\InstrumentationInfo.$(H) $(INCLUDE_TOP)\stx\libcomp\Parser.$(H) $(INCLUDE_TOP)\stx\libcomp\Scanner.$(H) $(STCHDR)
$(OUTDIR)SuperNode.$(O) SuperNode.$(C) SuperNode.$(H): SuperNode.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libcomp\ParseNode.$(H) $(INCLUDE_TOP)\stx\libcomp\PrimaryNode.$(H) $(INCLUDE_TOP)\stx\libcomp\SelfNode.$(H) $(STCHDR)
$(OUTDIR)SyntaxHighlighter.$(O) SyntaxHighlighter.$(C) SyntaxHighlighter.$(H): SyntaxHighlighter.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libcomp\AbstractSyntaxHighlighter.$(H) $(INCLUDE_TOP)\stx\libcomp\Parser.$(H) $(INCLUDE_TOP)\stx\libcomp\Scanner.$(H) $(STCHDR)
$(OUTDIR)extensions.$(O): extensions.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)

# ENDMAKEDEPEND --- do not remove this line

# **Must be at end**

# Enforce recompilation of package definition class if Mercurial working
# copy state changes. Together with --guessVersion it ensures that package
# definition class always contains correct binary revision string.
!IFDEF HGROOT
$(OUTDIR)stx_libcomp.$(O): $(HGROOT)\.hg\dirstate
!ENDIF
