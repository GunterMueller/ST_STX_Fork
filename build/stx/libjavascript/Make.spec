# $Header$
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_libjavascript.
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
MODULE_DIR=libjavascript
PACKAGE=$(MODULE):$(MODULE_DIR)


# Argument(s) to the stc compiler (stc --usage).
#  -headerDir=. : create header files locally
#                (if removed, they will be created as common
#  -Pxxx       : defines the package
#  -Zxxx       : a prefix for variables within the classLib
#  -Dxxx       : defines passed to CC for inline C-code
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
STCLOCALOPTIMIZATIONS=+optspace3


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
STCWARNINGS=-warnNonStandard

COMMON_CLASSES= \
	HTMLDocGeneratorForJavaScript \
	JavaScriptClass \
	JavaScriptClassNode \
	JavaScriptCodeGeneratorTool \
	JavaScriptCompletionEngine \
	JavaScriptConstantNode \
	JavaScriptEnvironment \
	JavaScriptFunction \
	JavaScriptFunctionNode \
	JavaScriptMetaclass \
	JavaScriptObject \
	JavaScriptParseNodeVisitor \
	JavaScriptScanner \
	JavaScriptSimulatedBrowserEnvironment \
	JavaScriptSourceFileWriter \
	JavaScriptSourceReader \
	JavaScriptVariable \
	JavaScriptVariableNode \
	Math \
	STXJavaScriptLanguage \
	stx_libjavascript \
	JavaScriptFunctionWithBreakpoints \
	JavaScriptInnerFunctionNode \
	JavaScriptParseNodeValidator \
	JavaScriptParser \
	JavaScriptCompiler \
	JavaScriptCompletionParser \
	JavaScriptSyntaxHighlighter \
	JavaScriptCompilerWithBreakpointSupport \




COMMON_OBJS= \
    $(OUTDIR)HTMLDocGeneratorForJavaScript.$(O) \
    $(OUTDIR)JavaScriptClass.$(O) \
    $(OUTDIR)JavaScriptClassNode.$(O) \
    $(OUTDIR)JavaScriptCodeGeneratorTool.$(O) \
    $(OUTDIR)JavaScriptCompletionEngine.$(O) \
    $(OUTDIR)JavaScriptConstantNode.$(O) \
    $(OUTDIR)JavaScriptEnvironment.$(O) \
    $(OUTDIR)JavaScriptFunction.$(O) \
    $(OUTDIR)JavaScriptFunctionNode.$(O) \
    $(OUTDIR)JavaScriptMetaclass.$(O) \
    $(OUTDIR)JavaScriptObject.$(O) \
    $(OUTDIR)JavaScriptParseNodeVisitor.$(O) \
    $(OUTDIR)JavaScriptScanner.$(O) \
    $(OUTDIR)JavaScriptSimulatedBrowserEnvironment.$(O) \
    $(OUTDIR)JavaScriptSourceFileWriter.$(O) \
    $(OUTDIR)JavaScriptSourceReader.$(O) \
    $(OUTDIR)JavaScriptVariable.$(O) \
    $(OUTDIR)JavaScriptVariableNode.$(O) \
    $(OUTDIR)Math.$(O) \
    $(OUTDIR)STXJavaScriptLanguage.$(O) \
    $(OUTDIR)stx_libjavascript.$(O) \
    $(OUTDIR)JavaScriptFunctionWithBreakpoints.$(O) \
    $(OUTDIR)JavaScriptInnerFunctionNode.$(O) \
    $(OUTDIR)JavaScriptParseNodeValidator.$(O) \
    $(OUTDIR)JavaScriptParser.$(O) \
    $(OUTDIR)JavaScriptCompiler.$(O) \
    $(OUTDIR)JavaScriptCompletionParser.$(O) \
    $(OUTDIR)JavaScriptSyntaxHighlighter.$(O) \
    $(OUTDIR)JavaScriptCompilerWithBreakpointSupport.$(O) \
    $(OUTDIR)extensions.$(O) \



