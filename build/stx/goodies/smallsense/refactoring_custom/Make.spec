# $Header$
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_goodies_smallsense_refactoring_custom.
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
MODULE_DIR=goodies/smallsense/refactoring_custom
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
	SmallSense::CustomChangeManager \
	SmallSense::CustomClassQuery \
	SmallSense::CustomCodeGeneratorOrRefactoring \
	SmallSense::CustomContext \
	SmallSense::CustomDialog \
	SmallSense::CustomManager \
	SmallSense::CustomMenuBuilder \
	SmallSense::CustomMock \
	SmallSense::CustomNamespace \
	SmallSense::CustomParseTreeRewriter \
	SmallSense::CustomPerspective \
	SmallSense::CustomRefactoryBuilder \
	SmallSense::CustomSourceCodeFormatter \
	SmallSense::CustomSourceCodeGenerator \
	SmallSense::CustomSourceCodeSelection \
	SmallSense::CustomTestCaseHelper \
	stx_goodies_smallsense_refactoring_custom \
	SmallSense::CustomBrowserChangeManager \
	SmallSense::CustomBrowserContext \
	SmallSense::CustomCodeGenerator \
	SmallSense::CustomLocalChangeManager \
	SmallSense::CustomNoneSourceCodeFormatter \
	SmallSense::CustomRBLocalSourceCodeFormatter \
	SmallSense::CustomRefactoring \
	SmallSense::CustomSilentDialog \
	SmallSense::CustomSubContext \
	SmallSense::CustomUserDialog \
	SmallSense::CustomAccessMethodsCodeGenerator \
	SmallSense::CustomCodeSelectionRefactoring \
	SmallSense::CustomInspectorTabCodeGenerator \
	SmallSense::CustomIsAbstractCodeGenerator \
	SmallSense::CustomJavaSimpleSetterMethodsCodeGenerator \
	SmallSense::CustomNewClassGenerator \
	SmallSense::CustomReplaceIfNilWithIfTrueRefactoring \
	SmallSense::CustomSubclassResponsibilityCodeGenerator \
	SmallSense::CustomTestCaseCodeGenerator \
	SmallSense::CustomTestCaseMethodCodeGenerator \
	SmallSense::CustomTestCaseSetUpCodeGenerator \
	SmallSense::CustomTestCaseTearDownCodeGenerator \
	SmallSense::CustomUpdateTestCaseCategoryRefactoring \
	SmallSense::CustomVisitorCodeGenerator \
	SmallSense::CustomChangeNotificationAccessMethodsCodeGenerator \
	SmallSense::CustomChangeNotificationSetterMethodsCodeGenerator \
	SmallSense::CustomCodeGeneratorClassGenerator \
	SmallSense::CustomCodeGeneratorOrRefactoringTestCaseCodeGenerator \
	SmallSense::CustomCodeSelectionToResourceTranslation \
	SmallSense::CustomDefaultGetterMethodsCodeGenerator \
	SmallSense::CustomLazyInitializationAccessMethodsCodeGenerator \
	SmallSense::CustomLazyInitializationGetterMethodsCodeGenerator \
	SmallSense::CustomMultiSetterMethodsCodeGenerator \
	SmallSense::CustomPrintCodeSelectionRefactoring \
	SmallSense::CustomRefactoringClassGenerator \
	SmallSense::CustomSimpleAccessMethodsCodeGenerator \
	SmallSense::CustomSimpleGetterMethodsCodeGenerator \
	SmallSense::CustomSimpleSetterMethodsCodeGenerator \
	SmallSense::CustomUITestCaseCodeGenerator \
	SmallSense::CustomUITestCaseSetUpCodeGenerator \
	SmallSense::CustomValueHolderAccessMethodsCodeGenerator \
	SmallSense::CustomValueHolderGetterMethodsCodeGenerator \
	SmallSense::CustomValueHolderWithChangeNotificationAccessMethodsCodeGenerator \
	SmallSense::CustomValueHolderWithChangeNotificationGetterMethodsCodeGenerator \
	SmallSense::CustomValueHolderWithChangeNotificationSetterMethodsCodeGenerator \
	SmallSense::CustomVisitorCodeGeneratorAcceptVisitor \
	SmallSense::CustomJavaScriptSimpleSetterMethodsCodeGenerator \




COMMON_OBJS= \
    $(OUTDIR)SmallSense__CustomChangeManager.$(O) \
    $(OUTDIR)SmallSense__CustomClassQuery.$(O) \
    $(OUTDIR)SmallSense__CustomCodeGeneratorOrRefactoring.$(O) \
    $(OUTDIR)SmallSense__CustomContext.$(O) \
    $(OUTDIR)SmallSense__CustomDialog.$(O) \
    $(OUTDIR)SmallSense__CustomManager.$(O) \
    $(OUTDIR)SmallSense__CustomMenuBuilder.$(O) \
    $(OUTDIR)SmallSense__CustomMock.$(O) \
    $(OUTDIR)SmallSense__CustomNamespace.$(O) \
    $(OUTDIR)SmallSense__CustomParseTreeRewriter.$(O) \
    $(OUTDIR)SmallSense__CustomPerspective.$(O) \
    $(OUTDIR)SmallSense__CustomRefactoryBuilder.$(O) \
    $(OUTDIR)SmallSense__CustomSourceCodeFormatter.$(O) \
    $(OUTDIR)SmallSense__CustomSourceCodeGenerator.$(O) \
    $(OUTDIR)SmallSense__CustomSourceCodeSelection.$(O) \
    $(OUTDIR)SmallSense__CustomTestCaseHelper.$(O) \
    $(OUTDIR)stx_goodies_smallsense_refactoring_custom.$(O) \
    $(OUTDIR)SmallSense__CustomBrowserChangeManager.$(O) \
    $(OUTDIR)SmallSense__CustomBrowserContext.$(O) \
    $(OUTDIR)SmallSense__CustomCodeGenerator.$(O) \
    $(OUTDIR)SmallSense__CustomLocalChangeManager.$(O) \
    $(OUTDIR)SmallSense__CustomNoneSourceCodeFormatter.$(O) \
    $(OUTDIR)SmallSense__CustomRBLocalSourceCodeFormatter.$(O) \
    $(OUTDIR)SmallSense__CustomRefactoring.$(O) \
    $(OUTDIR)SmallSense__CustomSilentDialog.$(O) \
    $(OUTDIR)SmallSense__CustomSubContext.$(O) \
    $(OUTDIR)SmallSense__CustomUserDialog.$(O) \
    $(OUTDIR)SmallSense__CustomAccessMethodsCodeGenerator.$(O) \
    $(OUTDIR)SmallSense__CustomCodeSelectionRefactoring.$(O) \
    $(OUTDIR)SmallSense__CustomInspectorTabCodeGenerator.$(O) \
    $(OUTDIR)SmallSense__CustomIsAbstractCodeGenerator.$(O) \
    $(OUTDIR)SmallSense__CustomJavaSimpleSetterMethodsCodeGenerator.$(O) \
    $(OUTDIR)SmallSense__CustomNewClassGenerator.$(O) \
    $(OUTDIR)SmallSense__CustomReplaceIfNilWithIfTrueRefactoring.$(O) \
    $(OUTDIR)SmallSense__CustomSubclassResponsibilityCodeGenerator.$(O) \
    $(OUTDIR)SmallSense__CustomTestCaseCodeGenerator.$(O) \
    $(OUTDIR)SmallSense__CustomTestCaseMethodCodeGenerator.$(O) \
    $(OUTDIR)SmallSense__CustomTestCaseSetUpCodeGenerator.$(O) \
    $(OUTDIR)SmallSense__CustomTestCaseTearDownCodeGenerator.$(O) \
    $(OUTDIR)SmallSense__CustomUpdateTestCaseCategoryRefactoring.$(O) \
    $(OUTDIR)SmallSense__CustomVisitorCodeGenerator.$(O) \
    $(OUTDIR)SmallSense__CustomChangeNotificationAccessMethodsCodeGenerator.$(O) \
    $(OUTDIR)SmallSense__CustomChangeNotificationSetterMethodsCodeGenerator.$(O) \
    $(OUTDIR)SmallSense__CustomCodeGeneratorClassGenerator.$(O) \
    $(OUTDIR)SmallSense__CustomCodeGeneratorOrRefactoringTestCaseCodeGenerator.$(O) \
    $(OUTDIR)SmallSense__CustomCodeSelectionToResourceTranslation.$(O) \
    $(OUTDIR)SmallSense__CustomDefaultGetterMethodsCodeGenerator.$(O) \
    $(OUTDIR)SmallSense__CustomLazyInitializationAccessMethodsCodeGenerator.$(O) \
    $(OUTDIR)SmallSense__CustomLazyInitializationGetterMethodsCodeGenerator.$(O) \
    $(OUTDIR)SmallSense__CustomMultiSetterMethodsCodeGenerator.$(O) \
    $(OUTDIR)SmallSense__CustomPrintCodeSelectionRefactoring.$(O) \
    $(OUTDIR)SmallSense__CustomRefactoringClassGenerator.$(O) \
    $(OUTDIR)SmallSense__CustomSimpleAccessMethodsCodeGenerator.$(O) \
    $(OUTDIR)SmallSense__CustomSimpleGetterMethodsCodeGenerator.$(O) \
    $(OUTDIR)SmallSense__CustomSimpleSetterMethodsCodeGenerator.$(O) \
    $(OUTDIR)SmallSense__CustomUITestCaseCodeGenerator.$(O) \
    $(OUTDIR)SmallSense__CustomUITestCaseSetUpCodeGenerator.$(O) \
    $(OUTDIR)SmallSense__CustomValueHolderAccessMethodsCodeGenerator.$(O) \
    $(OUTDIR)SmallSense__CustomValueHolderGetterMethodsCodeGenerator.$(O) \
    $(OUTDIR)SmallSense__CustomValueHolderWithChangeNotificationAccessMethodsCodeGenerator.$(O) \
    $(OUTDIR)SmallSense__CustomValueHolderWithChangeNotificationGetterMethodsCodeGenerator.$(O) \
    $(OUTDIR)SmallSense__CustomValueHolderWithChangeNotificationSetterMethodsCodeGenerator.$(O) \
    $(OUTDIR)SmallSense__CustomVisitorCodeGeneratorAcceptVisitor.$(O) \
    $(OUTDIR)SmallSense__CustomJavaScriptSimpleSetterMethodsCodeGenerator.$(O) \
    $(OUTDIR)extensions.$(O) \



