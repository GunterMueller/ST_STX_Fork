# $Header: /cvs/stx/stx/goodies/petitparser/gui/Make.spec,v 1.1 2014-03-04 21:20:14 cg Exp $
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_goodies_petitparser_gui.
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
MODULE_DIR=goodies/petitparser/gui
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
STCLOCALOPTIMIZATIONS=+optspace3


# Argument(s) to the stc compiler (stc --usage).
#  -warn            : no warnings
#  -warnNonStandard : no warnings about ST/X extensions
#  -warnEOLComments : no warnings about EOL comment extension
#  -warnPrivacy     : no warnings about privateClass extension
#
# ********** OPTIONAL: MODIFY the next line(s) ***
# STCWARNINGS=-warn
# STCWARNINGS=-warnNonStandard
# STCWARNINGS=-warnEOLComments
STCWARNINGS=-warnNonStandard

COMMON_CLASSES= \
	GLMCompositePresentation \
	PPAddParserRefactoring \
	PPBrowserStream \
	PPDefineProdcutionRefactoring \
	PPDrabBrowser \
	PPExtractProdcutionRefactoring \
	PPParserDebuggerResult \
	PPRefactoringUtils \
	PPRemoveParserRefactoring \
	PPRenameProdcutionRefactoring \
	PPTextHighlighter \
	RBRefactoring \
	RBRemoveClassRefactoring \
	stx_goodies_petitparser_gui \
	PPBrowser \
	PPParserBrowser \
	PPParserInspector \
	PPRemoveProdcutionRefactoring \




COMMON_OBJS= \
    $(OUTDIR_SLASH)GLMCompositePresentation.$(O) \
    $(OUTDIR_SLASH)PPAddParserRefactoring.$(O) \
    $(OUTDIR_SLASH)PPBrowserStream.$(O) \
    $(OUTDIR_SLASH)PPDefineProdcutionRefactoring.$(O) \
    $(OUTDIR_SLASH)PPDrabBrowser.$(O) \
    $(OUTDIR_SLASH)PPExtractProdcutionRefactoring.$(O) \
    $(OUTDIR_SLASH)PPParserDebuggerResult.$(O) \
    $(OUTDIR_SLASH)PPRefactoringUtils.$(O) \
    $(OUTDIR_SLASH)PPRemoveParserRefactoring.$(O) \
    $(OUTDIR_SLASH)PPRenameProdcutionRefactoring.$(O) \
    $(OUTDIR_SLASH)PPTextHighlighter.$(O) \
    $(OUTDIR_SLASH)RBRefactoring.$(O) \
    $(OUTDIR_SLASH)RBRemoveClassRefactoring.$(O) \
    $(OUTDIR_SLASH)stx_goodies_petitparser_gui.$(O) \
    $(OUTDIR_SLASH)PPBrowser.$(O) \
    $(OUTDIR_SLASH)PPParserBrowser.$(O) \
    $(OUTDIR_SLASH)PPParserInspector.$(O) \
    $(OUTDIR_SLASH)PPRemoveProdcutionRefactoring.$(O) \
    $(OUTDIR_SLASH)extensions.$(O) \



