# $Header: /cvs/stx/stx/libjavascript/bc.mak,v 1.45 2018-07-05 09:47:11 stefan Exp $
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_libjavascript.
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



!INCLUDE $(TOP)\rules\stdHeader_bc

!INCLUDE Make.spec

LIBNAME=libstx_libjavascript
MODULE_PATH=libjavascript
RESFILES=stx_libjavascriptWINrc.$(RES)


# see stdHeader_nt for LIBJAVASCRIPT_BASE
LIB_BASE_LD_ARG=-b:$(LIBJAVASCRIPT_BASE)


LOCALINCLUDES= -I$(INCLUDE_TOP)\stx\libbasic -I$(INCLUDE_TOP)\stx\libbasic3 -I$(INCLUDE_TOP)\stx\libcomp -I$(INCLUDE_TOP)\stx\libtool
LOCALDEFINES=

STCLOCALOPT=-package=$(PACKAGE) -I. $(LOCALINCLUDES) -headerDir=. $(STCLOCALOPTIMIZATIONS) $(STCWARNINGS) $(LOCALDEFINES)  -varPrefix=$(LIBNAME)
LOCALLIBS=

OBJS= $(COMMON_OBJS) $(WIN32_OBJS)

ALL::  classLibRule

classLibRule: $(OUTDIR) $(OUTDIR)$(LIBNAME).dll

!INCLUDE $(TOP)\rules\stdRules_bc

# build all mandatory prerequisite packages (containing superclasses) for this package
prereq:
	pushd ..\libbasic & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\goodies\refactoryBrowser\parser & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\libbasic2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\libbasic3 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\libcomp & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\libui & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\libview & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\libview2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\libwidg & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\libwidg2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\libtool & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "







test: $(TOP)\goodies\builder\reports\
	pushd $(TOP)\goodies\builder\reports & $(MAKE_BAT)
	$(TOP)\goodies\builder\reports\report-runner.bat -D . -r Builder::TestReport -p $(PACKAGE)
        
clean::
	-del *.$(CSUFFIX)


# BEGINMAKEDEPEND --- do not remove this line; make depend needs it
$(OUTDIR)HTMLDocGeneratorForJavaScript.$(O) HTMLDocGeneratorForJavaScript.$(C) HTMLDocGeneratorForJavaScript.$(H): HTMLDocGeneratorForJavaScript.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic3\HTMLDocGenerator.$(H) $(STCHDR)
$(OUTDIR)JavaScriptClass.$(O) JavaScriptClass.$(C) JavaScriptClass.$(H): JavaScriptClass.st $(INCLUDE_TOP)\stx\libbasic\Behavior.$(H) $(INCLUDE_TOP)\stx\libbasic\Class.$(H) $(INCLUDE_TOP)\stx\libbasic\ClassDescription.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)JavaScriptClassNode.$(O) JavaScriptClassNode.$(C) JavaScriptClassNode.$(H): JavaScriptClassNode.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libcomp\ParseNode.$(H) $(STCHDR)
$(OUTDIR)JavaScriptCodeGeneratorTool.$(O) JavaScriptCodeGeneratorTool.$(C) JavaScriptCodeGeneratorTool.$(H): JavaScriptCodeGeneratorTool.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libtool\CodeGeneratorTool.$(H) $(STCHDR)
$(OUTDIR)JavaScriptCompletionEngine.$(O) JavaScriptCompletionEngine.$(C) JavaScriptCompletionEngine.$(H): JavaScriptCompletionEngine.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)JavaScriptConstantNode.$(O) JavaScriptConstantNode.$(C) JavaScriptConstantNode.$(H): JavaScriptConstantNode.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libcomp\ConstantNode.$(H) $(INCLUDE_TOP)\stx\libcomp\ParseNode.$(H) $(INCLUDE_TOP)\stx\libcomp\PrimaryNode.$(H) $(STCHDR)
$(OUTDIR)JavaScriptEnvironment.$(O) JavaScriptEnvironment.$(C) JavaScriptEnvironment.$(H): JavaScriptEnvironment.st $(INCLUDE_TOP)\stx\libbasic\AbstractTime.$(H) $(INCLUDE_TOP)\stx\libbasic\Array.$(H) $(INCLUDE_TOP)\stx\libbasic\ArrayedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\CharacterArray.$(H) $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Magnitude.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\String.$(H) $(INCLUDE_TOP)\stx\libbasic\Timestamp.$(H) $(INCLUDE_TOP)\stx\libbasic\UninterpretedBytes.$(H) $(STCHDR)
$(OUTDIR)JavaScriptFunction.$(O) JavaScriptFunction.$(C) JavaScriptFunction.$(H): JavaScriptFunction.st $(INCLUDE_TOP)\stx\libbasic\CompiledCode.$(H) $(INCLUDE_TOP)\stx\libbasic\ExecutableFunction.$(H) $(INCLUDE_TOP)\stx\libbasic\Method.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)JavaScriptFunctionNode.$(O) JavaScriptFunctionNode.$(C) JavaScriptFunctionNode.$(H): JavaScriptFunctionNode.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libcomp\ParseNode.$(H) $(STCHDR)
$(OUTDIR)JavaScriptMetaclass.$(O) JavaScriptMetaclass.$(C) JavaScriptMetaclass.$(H): JavaScriptMetaclass.st $(INCLUDE_TOP)\stx\libbasic\Behavior.$(H) $(INCLUDE_TOP)\stx\libbasic\ClassDescription.$(H) $(INCLUDE_TOP)\stx\libbasic\Metaclass.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)JavaScriptObject.$(O) JavaScriptObject.$(C) JavaScriptObject.$(H): JavaScriptObject.st $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Dictionary.$(H) $(INCLUDE_TOP)\stx\libbasic\IdentityDictionary.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\Set.$(H) $(STCHDR)
$(OUTDIR)JavaScriptParseNodeVisitor.$(O) JavaScriptParseNodeVisitor.$(C) JavaScriptParseNodeVisitor.$(H): JavaScriptParseNodeVisitor.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libcomp\ParseNodeVisitor.$(H) $(STCHDR)
$(OUTDIR)JavaScriptScanner.$(O) JavaScriptScanner.$(C) JavaScriptScanner.$(H): JavaScriptScanner.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libcomp\Scanner.$(H) $(STCHDR)
$(OUTDIR)JavaScriptSimulatedBrowserEnvironment.$(O) JavaScriptSimulatedBrowserEnvironment.$(C) JavaScriptSimulatedBrowserEnvironment.$(H): JavaScriptSimulatedBrowserEnvironment.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)JavaScriptSourceFileWriter.$(O) JavaScriptSourceFileWriter.$(C) JavaScriptSourceFileWriter.$(H): JavaScriptSourceFileWriter.st $(INCLUDE_TOP)\stx\libbasic\AbstractSourceFileWriter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)JavaScriptSourceReader.$(O) JavaScriptSourceReader.$(C) JavaScriptSourceReader.$(H): JavaScriptSourceReader.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)JavaScriptVariable.$(O) JavaScriptVariable.$(C) JavaScriptVariable.$(H): JavaScriptVariable.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libcomp\Variable.$(H) $(STCHDR)
$(OUTDIR)JavaScriptVariableNode.$(O) JavaScriptVariableNode.$(C) JavaScriptVariableNode.$(H): JavaScriptVariableNode.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libcomp\ParseNode.$(H) $(INCLUDE_TOP)\stx\libcomp\PrimaryNode.$(H) $(INCLUDE_TOP)\stx\libcomp\VariableNode.$(H) $(STCHDR)
$(OUTDIR)Math.$(O) Math.$(C) Math.$(H): Math.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)STXJavaScriptLanguage.$(O) STXJavaScriptLanguage.$(C) STXJavaScriptLanguage.$(H): STXJavaScriptLanguage.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\ProgrammingLanguage.$(H) $(STCHDR)
$(OUTDIR)stx_libjavascript.$(O) stx_libjavascript.$(C) stx_libjavascript.$(H): stx_libjavascript.st $(INCLUDE_TOP)\stx\libbasic\LibraryDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\ProjectDefinition.$(H) $(STCHDR)
$(OUTDIR)JavaScriptFunctionWithBreakpoints.$(O) JavaScriptFunctionWithBreakpoints.$(C) JavaScriptFunctionWithBreakpoints.$(H): JavaScriptFunctionWithBreakpoints.st $(INCLUDE_TOP)\stx\libbasic\CompiledCode.$(H) $(INCLUDE_TOP)\stx\libbasic\ExecutableFunction.$(H) $(INCLUDE_TOP)\stx\libbasic\Method.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libjavascript\JavaScriptFunction.$(H) $(STCHDR)
$(OUTDIR)JavaScriptInnerFunctionNode.$(O) JavaScriptInnerFunctionNode.$(C) JavaScriptInnerFunctionNode.$(H): JavaScriptInnerFunctionNode.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libcomp\ParseNode.$(H) $(INCLUDE_TOP)\stx\libjavascript\JavaScriptFunctionNode.$(H) $(STCHDR)
$(OUTDIR)JavaScriptParseNodeValidator.$(O) JavaScriptParseNodeValidator.$(C) JavaScriptParseNodeValidator.$(H): JavaScriptParseNodeValidator.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libcomp\ParseNodeVisitor.$(H) $(INCLUDE_TOP)\stx\libjavascript\JavaScriptParseNodeVisitor.$(H) $(STCHDR)
$(OUTDIR)JavaScriptParser.$(O) JavaScriptParser.$(C) JavaScriptParser.$(H): JavaScriptParser.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libcomp\AssignmentNode.$(H) $(INCLUDE_TOP)\stx\libcomp\BinaryNode.$(H) $(INCLUDE_TOP)\stx\libcomp\BlockNode.$(H) $(INCLUDE_TOP)\stx\libcomp\MessageNode.$(H) $(INCLUDE_TOP)\stx\libcomp\ParseNode.$(H) $(INCLUDE_TOP)\stx\libcomp\PrimaryNode.$(H) $(INCLUDE_TOP)\stx\libcomp\ReturnNode.$(H) $(INCLUDE_TOP)\stx\libcomp\Scanner.$(H) $(INCLUDE_TOP)\stx\libcomp\SelfNode.$(H) $(INCLUDE_TOP)\stx\libcomp\StatementNode.$(H) $(INCLUDE_TOP)\stx\libcomp\UnaryNode.$(H) $(INCLUDE_TOP)\stx\libjavascript\JavaScriptScanner.$(H) $(STCHDR)
$(OUTDIR)JavaScriptCompiler.$(O) JavaScriptCompiler.$(C) JavaScriptCompiler.$(H): JavaScriptCompiler.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libcomp\Scanner.$(H) $(INCLUDE_TOP)\stx\libjavascript\JavaScriptParser.$(H) $(INCLUDE_TOP)\stx\libjavascript\JavaScriptScanner.$(H) $(STCHDR)
$(OUTDIR)JavaScriptCompletionParser.$(O) JavaScriptCompletionParser.$(C) JavaScriptCompletionParser.$(H): JavaScriptCompletionParser.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libcomp\Scanner.$(H) $(INCLUDE_TOP)\stx\libjavascript\JavaScriptParser.$(H) $(INCLUDE_TOP)\stx\libjavascript\JavaScriptScanner.$(H) $(STCHDR)
$(OUTDIR)JavaScriptSyntaxHighlighter.$(O) JavaScriptSyntaxHighlighter.$(C) JavaScriptSyntaxHighlighter.$(H): JavaScriptSyntaxHighlighter.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libcomp\Scanner.$(H) $(INCLUDE_TOP)\stx\libjavascript\JavaScriptParser.$(H) $(INCLUDE_TOP)\stx\libjavascript\JavaScriptScanner.$(H) $(STCHDR)
$(OUTDIR)JavaScriptCompilerWithBreakpointSupport.$(O) JavaScriptCompilerWithBreakpointSupport.$(C) JavaScriptCompilerWithBreakpointSupport.$(H): JavaScriptCompilerWithBreakpointSupport.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libcomp\Scanner.$(H) $(INCLUDE_TOP)\stx\libjavascript\JavaScriptCompiler.$(H) $(INCLUDE_TOP)\stx\libjavascript\JavaScriptParser.$(H) $(INCLUDE_TOP)\stx\libjavascript\JavaScriptScanner.$(H) $(STCHDR)
$(OUTDIR)extensions.$(O): extensions.st $(INCLUDE_TOP)\stx\libbasic\AbstractTime.$(H) $(INCLUDE_TOP)\stx\libbasic\ArithmeticValue.$(H) $(INCLUDE_TOP)\stx\libbasic\ArrayedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\Behavior.$(H) $(INCLUDE_TOP)\stx\libbasic\Block.$(H) $(INCLUDE_TOP)\stx\libbasic\Boolean.$(H) $(INCLUDE_TOP)\stx\libbasic\CharacterArray.$(H) $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\CompiledCode.$(H) $(INCLUDE_TOP)\stx\libbasic\Date.$(H) $(INCLUDE_TOP)\stx\libbasic\ExecutableFunction.$(H) $(INCLUDE_TOP)\stx\libbasic\False.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Integer.$(H) $(INCLUDE_TOP)\stx\libbasic\Magnitude.$(H) $(INCLUDE_TOP)\stx\libbasic\Number.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\Stream.$(H) $(INCLUDE_TOP)\stx\libbasic\String.$(H) $(INCLUDE_TOP)\stx\libbasic\True.$(H) $(INCLUDE_TOP)\stx\libbasic\UndefinedObject.$(H) $(INCLUDE_TOP)\stx\libbasic\UninterpretedBytes.$(H) $(INCLUDE_TOP)\stx\libcomp\ParseNode.$(H) $(STCHDR)

# ENDMAKEDEPEND --- do not remove this line
