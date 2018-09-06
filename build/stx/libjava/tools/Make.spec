# $Header$
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_libjava_tools.
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
MODULE_DIR=libjava/tools
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
STCLOCALOPTIMIZATIONS=+optspace3 -inlinenot


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
	JavaAbstractSourceHighlighter \
	JavaCodeBundleEditor \
	JavaCodeLibraryEditor \
	JavaCodeLibraryValidationWarning \
	JavaCompiler \
	JavaLintAnnotation \
	JavaLintHighlighter \
	JavaLintPopupWindow \
	JavaLintService \
	JavaListInspectorView \
	JavaMapInspectorView \
	JavaScannerBase \
	JavaSetInspectorView \
	JavaSettingsApplication \
	JavaSourceDocument \
	JavaSourceRef \
	JavaToolbox \
	stx_libjava_tools \
	JavaAbstractLexicalHighlighter \
	JavaScanner \
	JavaSyntaxHighlighter \
	GroovyScanner \
	JavaLexicalHighlighter \
	GroovySourceHighlighter \




COMMON_OBJS= \
    $(OUTDIR)JavaAbstractSourceHighlighter.$(O) \
    $(OUTDIR)JavaCodeBundleEditor.$(O) \
    $(OUTDIR)JavaCodeLibraryEditor.$(O) \
    $(OUTDIR)JavaCodeLibraryValidationWarning.$(O) \
    $(OUTDIR)JavaCompiler.$(O) \
    $(OUTDIR)JavaLintAnnotation.$(O) \
    $(OUTDIR)JavaLintHighlighter.$(O) \
    $(OUTDIR)JavaLintPopupWindow.$(O) \
    $(OUTDIR)JavaLintService.$(O) \
    $(OUTDIR)JavaListInspectorView.$(O) \
    $(OUTDIR)JavaMapInspectorView.$(O) \
    $(OUTDIR)JavaScannerBase.$(O) \
    $(OUTDIR)JavaSetInspectorView.$(O) \
    $(OUTDIR)JavaSettingsApplication.$(O) \
    $(OUTDIR)JavaSourceDocument.$(O) \
    $(OUTDIR)JavaSourceRef.$(O) \
    $(OUTDIR)JavaToolbox.$(O) \
    $(OUTDIR)stx_libjava_tools.$(O) \
    $(OUTDIR)JavaAbstractLexicalHighlighter.$(O) \
    $(OUTDIR)JavaScanner.$(O) \
    $(OUTDIR)JavaSyntaxHighlighter.$(O) \
    $(OUTDIR)GroovyScanner.$(O) \
    $(OUTDIR)JavaLexicalHighlighter.$(O) \
    $(OUTDIR)GroovySourceHighlighter.$(O) \
    $(OUTDIR)extensions.$(O) \



