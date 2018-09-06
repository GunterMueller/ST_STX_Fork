# $Header$
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_goodies_smallsense.
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
MODULE_DIR=goodies/smallsense
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
	SmallSense::AbstractDIalog \
	SmallSense::AbstractSearchProcessor \
	SmallSense::CodeHighlightingService \
	SmallSense::CodeNavigationService \
	SmallSense::CompletionContext \
	SmallSense::CompletionController \
	SmallSense::CompletionEngine \
	SmallSense::CompletionResult \
	SmallSense::CompletionView \
	SmallSense::CriticsWindow \
	SmallSense::EditService \
	SmallSense::EditSupport \
	SmallSense::Info \
	SmallSense::Manager \
	SmallSense::NavigatorStep \
	SmallSense::PO \
	SmallSense::ParseTreeIndex \
	SmallSense::ParseTreeIndexEntry \
	SmallSense::ParseTreeInspector \
	SmallSense::SelectorNode \
	SmallSense::SettingsAppl \
	SmallSense::SmalltalkChecker \
	SmallSense::SmalltalkInferencerParameters \
	SmallSense::SmalltalkLintService \
	SmallSense::SmalltalkParseNodeVisitor \
	SmallSense::SmalltalkParser \
	SmallSense::SmalltalkQuickFixer \
	SmallSense::SmalltalkSyntaxHighlighter \
	SmallSense::SmalltalkUnacceptedMethodEnvironment \
	SmallSense::TokenPatternMatcher \
	SmallSense::TokenPatternParser \
	SmallSense::TokenPatternToken \
	SmallSense::TokenPatternTokenSet \
	SmallSense::TokenStream \
	SmallSense::Type \
	SmallSense::TypeHolder \
	stx_goodies_smallsense \
	SmallSense::AbstractJavaCompletionEngine \
	SmallSense::AbstractListDialog \
	SmallSense::ClassInfo \
	SmallSense::ClassPO \
	SmallSense::ClassSearchProcessor \
	SmallSense::ClassType \
	SmallSense::CompositeProcessor \
	SmallSense::ConstantPO \
	SmallSense::GenericEditSupport \
	SmallSense::ImplementorSearchProcessor \
	SmallSense::JavaEditSupport \
	SmallSense::JavaImportPO \
	SmallSense::MethodBindingPO \
	SmallSense::MethodInfo \
	SmallSense::MethodPO \
	SmallSense::PackagePO \
	SmallSense::PluggablePO \
	SmallSense::PluggableSearchProcessor \
	SmallSense::SmalltalkCompletionEngine \
	SmallSense::SmalltalkEditSupport \
	SmallSense::SmalltalkInferencer \
	SmallSense::SmalltalkParseNodeFinder \
	SmallSense::SnippetPO \
	SmallSense::UnionType \
	SmallSense::UnknownType \
	SmallSense::VariableBindingPO \
	SmallSense::VariablePO \
	SmallSense::AbstractJavaCompletionEngineSimple \
	SmallSense::AbstractSearchDialog \
	SmallSense::AbstractSelectDialog \
	SmallSense::GroovyEditSupport \
	SmallSense::JavaCompletionEngine \
	SmallSense::JavaConstructorPO \
	SmallSense::MethodKeywordRestPO \
	SmallSense::CetegoryOrProtocolSelectDialog \
	SmallSense::ClassSearchDialog \
	SmallSense::JavaCompletionEngineSimple \
	SmallSense::MethodSearchDialog \
	SmallSense::Navigator \
	SmallSense::PackageSelectDialog \
	SmallSense::CategorySelectDialog \
	SmallSense::GroovyCompletionEngineSimple \
	SmallSense::ProtocolSelectDialog \




COMMON_OBJS= \
    $(OUTDIR)SmallSense__AbstractDIalog.$(O) \
    $(OUTDIR)SmallSense__AbstractSearchProcessor.$(O) \
    $(OUTDIR)SmallSense__CodeHighlightingService.$(O) \
    $(OUTDIR)SmallSense__CodeNavigationService.$(O) \
    $(OUTDIR)SmallSense__CompletionContext.$(O) \
    $(OUTDIR)SmallSense__CompletionController.$(O) \
    $(OUTDIR)SmallSense__CompletionEngine.$(O) \
    $(OUTDIR)SmallSense__CompletionResult.$(O) \
    $(OUTDIR)SmallSense__CompletionView.$(O) \
    $(OUTDIR)SmallSense__CriticsWindow.$(O) \
    $(OUTDIR)SmallSense__EditService.$(O) \
    $(OUTDIR)SmallSense__EditSupport.$(O) \
    $(OUTDIR)SmallSense__Info.$(O) \
    $(OUTDIR)SmallSense__Manager.$(O) \
    $(OUTDIR)SmallSense__NavigatorStep.$(O) \
    $(OUTDIR)SmallSense__PO.$(O) \
    $(OUTDIR)SmallSense__ParseTreeIndex.$(O) \
    $(OUTDIR)SmallSense__ParseTreeIndexEntry.$(O) \
    $(OUTDIR)SmallSense__ParseTreeInspector.$(O) \
    $(OUTDIR)SmallSense__SelectorNode.$(O) \
    $(OUTDIR)SmallSense__SettingsAppl.$(O) \
    $(OUTDIR)SmallSense__SmalltalkChecker.$(O) \
    $(OUTDIR)SmallSense__SmalltalkInferencerParameters.$(O) \
    $(OUTDIR)SmallSense__SmalltalkLintService.$(O) \
    $(OUTDIR)SmallSense__SmalltalkParseNodeVisitor.$(O) \
    $(OUTDIR)SmallSense__SmalltalkParser.$(O) \
    $(OUTDIR)SmallSense__SmalltalkQuickFixer.$(O) \
    $(OUTDIR)SmallSense__SmalltalkSyntaxHighlighter.$(O) \
    $(OUTDIR)SmallSense__SmalltalkUnacceptedMethodEnvironment.$(O) \
    $(OUTDIR)SmallSense__TokenPatternMatcher.$(O) \
    $(OUTDIR)SmallSense__TokenPatternParser.$(O) \
    $(OUTDIR)SmallSense__TokenPatternToken.$(O) \
    $(OUTDIR)SmallSense__TokenPatternTokenSet.$(O) \
    $(OUTDIR)SmallSense__TokenStream.$(O) \
    $(OUTDIR)SmallSense__Type.$(O) \
    $(OUTDIR)SmallSense__TypeHolder.$(O) \
    $(OUTDIR)stx_goodies_smallsense.$(O) \
    $(OUTDIR)SmallSense__AbstractJavaCompletionEngine.$(O) \
    $(OUTDIR)SmallSense__AbstractListDialog.$(O) \
    $(OUTDIR)SmallSense__ClassInfo.$(O) \
    $(OUTDIR)SmallSense__ClassPO.$(O) \
    $(OUTDIR)SmallSense__ClassSearchProcessor.$(O) \
    $(OUTDIR)SmallSense__ClassType.$(O) \
    $(OUTDIR)SmallSense__CompositeProcessor.$(O) \
    $(OUTDIR)SmallSense__ConstantPO.$(O) \
    $(OUTDIR)SmallSense__GenericEditSupport.$(O) \
    $(OUTDIR)SmallSense__ImplementorSearchProcessor.$(O) \
    $(OUTDIR)SmallSense__JavaEditSupport.$(O) \
    $(OUTDIR)SmallSense__JavaImportPO.$(O) \
    $(OUTDIR)SmallSense__MethodBindingPO.$(O) \
    $(OUTDIR)SmallSense__MethodInfo.$(O) \
    $(OUTDIR)SmallSense__MethodPO.$(O) \
    $(OUTDIR)SmallSense__PackagePO.$(O) \
    $(OUTDIR)SmallSense__PluggablePO.$(O) \
    $(OUTDIR)SmallSense__PluggableSearchProcessor.$(O) \
    $(OUTDIR)SmallSense__SmalltalkCompletionEngine.$(O) \
    $(OUTDIR)SmallSense__SmalltalkEditSupport.$(O) \
    $(OUTDIR)SmallSense__SmalltalkInferencer.$(O) \
    $(OUTDIR)SmallSense__SmalltalkParseNodeFinder.$(O) \
    $(OUTDIR)SmallSense__SnippetPO.$(O) \
    $(OUTDIR)SmallSense__UnionType.$(O) \
    $(OUTDIR)SmallSense__UnknownType.$(O) \
    $(OUTDIR)SmallSense__VariableBindingPO.$(O) \
    $(OUTDIR)SmallSense__VariablePO.$(O) \
    $(OUTDIR)SmallSense__AbstractJavaCompletionEngineSimple.$(O) \
    $(OUTDIR)SmallSense__AbstractSearchDialog.$(O) \
    $(OUTDIR)SmallSense__AbstractSelectDialog.$(O) \
    $(OUTDIR)SmallSense__GroovyEditSupport.$(O) \
    $(OUTDIR)SmallSense__JavaCompletionEngine.$(O) \
    $(OUTDIR)SmallSense__JavaConstructorPO.$(O) \
    $(OUTDIR)SmallSense__MethodKeywordRestPO.$(O) \
    $(OUTDIR)SmallSense__CetegoryOrProtocolSelectDialog.$(O) \
    $(OUTDIR)SmallSense__ClassSearchDialog.$(O) \
    $(OUTDIR)SmallSense__JavaCompletionEngineSimple.$(O) \
    $(OUTDIR)SmallSense__MethodSearchDialog.$(O) \
    $(OUTDIR)SmallSense__Navigator.$(O) \
    $(OUTDIR)SmallSense__PackageSelectDialog.$(O) \
    $(OUTDIR)SmallSense__CategorySelectDialog.$(O) \
    $(OUTDIR)SmallSense__GroovyCompletionEngineSimple.$(O) \
    $(OUTDIR)SmallSense__ProtocolSelectDialog.$(O) \
    $(OUTDIR)extensions.$(O) \



