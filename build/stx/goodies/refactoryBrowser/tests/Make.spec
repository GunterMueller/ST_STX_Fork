# $Header$
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_goodies_refactoryBrowser_tests.
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
MODULE_DIR=goodies/refactoryBrowser/tests
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
	CodeDuplicationTest \
	LintRuleTest \
	ParseTreeSourceRewriterTests \
	RefactoringBrowserTest \
	RefactoringFormatterTest \
	RefactoryTestDataApp \
	SentNotImplementedTestCase \
	stx_goodies_refactoryBrowser_tests \
	BasicLintRuleTest \
	BrowserEnvironmentTest \
	CompositeLintRuleTest \
	ExtraParsingAndFormattingTests \
	FooLintRuleTest \
	RBClassTest \
	RBNamespaceTest \
	RBParserTest \
	RefactoringTest \
	ReferenceFinderTest \
	SmalllintTest \
	VariableTypeTest \
	AbstractClassVariableTest \
	AbstractInstanceVariableTest \
	AddClassTest \
	AddClassVariableTest \
	AddInstanceVariableTest \
	AddMethodTest \
	AddParameterTest \
	ChildrenToSiblingsTest \
	CreateAccessorsForVariableTest \
	ExtractMethodTest \
	ExtractMethodToComponentTest \
	ExtractToTemporaryTest \
	InlineAllMethodTest \
	InlineMethodFromComponentTest \
	InlineMethodTest \
	InlineParameterTest \
	InlineTemporaryTest \
	MoveMethodTest \
	MoveVariableDefinitionTest \
	ProtectInstanceVariableTest \
	PullUpClassVariableTest \
	PushDownClassVariableTest \
	PushDownInstanceVariableTest \
	PushDownMethodTest \
	PushUpInstanceVariableTest \
	PushUpMethodTest \
	RemoveClassTest \
	RemoveClassVariableTest \
	RemoveInstanceVariableTest \
	RemoveMethodTest \
	RemoveParameterTest \
	RenameClassTest \
	RenameClassVariableTest \
	RenameInstanceVariableTest \
	RenameMethodTest \
	RenameTemporaryTest \
	TemporaryToInstanceVariableTest \
	TransformationRuleTest \
	VariableEnvironmentTest \




COMMON_OBJS= \
    $(OUTDIR)CodeDuplicationTest.$(O) \
    $(OUTDIR)LintRuleTest.$(O) \
    $(OUTDIR)ParseTreeSourceRewriterTests.$(O) \
    $(OUTDIR)RefactoringBrowserTest.$(O) \
    $(OUTDIR)RefactoringFormatterTest.$(O) \
    $(OUTDIR)RefactoryTestDataApp.$(O) \
    $(OUTDIR)SentNotImplementedTestCase.$(O) \
    $(OUTDIR)stx_goodies_refactoryBrowser_tests.$(O) \
    $(OUTDIR)BasicLintRuleTest.$(O) \
    $(OUTDIR)BrowserEnvironmentTest.$(O) \
    $(OUTDIR)CompositeLintRuleTest.$(O) \
    $(OUTDIR)ExtraParsingAndFormattingTests.$(O) \
    $(OUTDIR)FooLintRuleTest.$(O) \
    $(OUTDIR)RBClassTest.$(O) \
    $(OUTDIR)RBNamespaceTest.$(O) \
    $(OUTDIR)RBParserTest.$(O) \
    $(OUTDIR)RefactoringTest.$(O) \
    $(OUTDIR)ReferenceFinderTest.$(O) \
    $(OUTDIR)SmalllintTest.$(O) \
    $(OUTDIR)VariableTypeTest.$(O) \
    $(OUTDIR)AbstractClassVariableTest.$(O) \
    $(OUTDIR)AbstractInstanceVariableTest.$(O) \
    $(OUTDIR)AddClassTest.$(O) \
    $(OUTDIR)AddClassVariableTest.$(O) \
    $(OUTDIR)AddInstanceVariableTest.$(O) \
    $(OUTDIR)AddMethodTest.$(O) \
    $(OUTDIR)AddParameterTest.$(O) \
    $(OUTDIR)ChildrenToSiblingsTest.$(O) \
    $(OUTDIR)CreateAccessorsForVariableTest.$(O) \
    $(OUTDIR)ExtractMethodTest.$(O) \
    $(OUTDIR)ExtractMethodToComponentTest.$(O) \
    $(OUTDIR)ExtractToTemporaryTest.$(O) \
    $(OUTDIR)InlineAllMethodTest.$(O) \
    $(OUTDIR)InlineMethodFromComponentTest.$(O) \
    $(OUTDIR)InlineMethodTest.$(O) \
    $(OUTDIR)InlineParameterTest.$(O) \
    $(OUTDIR)InlineTemporaryTest.$(O) \
    $(OUTDIR)MoveMethodTest.$(O) \
    $(OUTDIR)MoveVariableDefinitionTest.$(O) \
    $(OUTDIR)ProtectInstanceVariableTest.$(O) \
    $(OUTDIR)PullUpClassVariableTest.$(O) \
    $(OUTDIR)PushDownClassVariableTest.$(O) \
    $(OUTDIR)PushDownInstanceVariableTest.$(O) \
    $(OUTDIR)PushDownMethodTest.$(O) \
    $(OUTDIR)PushUpInstanceVariableTest.$(O) \
    $(OUTDIR)PushUpMethodTest.$(O) \
    $(OUTDIR)RemoveClassTest.$(O) \
    $(OUTDIR)RemoveClassVariableTest.$(O) \
    $(OUTDIR)RemoveInstanceVariableTest.$(O) \
    $(OUTDIR)RemoveMethodTest.$(O) \
    $(OUTDIR)RemoveParameterTest.$(O) \
    $(OUTDIR)RenameClassTest.$(O) \
    $(OUTDIR)RenameClassVariableTest.$(O) \
    $(OUTDIR)RenameInstanceVariableTest.$(O) \
    $(OUTDIR)RenameMethodTest.$(O) \
    $(OUTDIR)RenameTemporaryTest.$(O) \
    $(OUTDIR)TemporaryToInstanceVariableTest.$(O) \
    $(OUTDIR)TransformationRuleTest.$(O) \
    $(OUTDIR)VariableEnvironmentTest.$(O) \



