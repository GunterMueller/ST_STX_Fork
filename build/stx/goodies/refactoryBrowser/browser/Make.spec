# $Header: /cvs/stx/stx/goodies/refactoryBrowser/browser/Make.spec,v 1.9 2014-04-02 10:49:12 vrany Exp $
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_goodies_refactoryBrowser_browser.
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
MODULE_DIR=goodies/refactoryBrowser/browser
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
	BrowserDialog \
	BrowserEnvironmentWrapper \
	LimitedEnvironment \
	RefactoryTyper \
	stx_goodies_refactoryBrowser_browser \
	AndEnvironment \
	CategoryEnvironment \
	ClassEnvironment \
	EmptyEnvironment \
	MethodNameDialog \
	NamespaceEnvironment \
	NotEnvironment \
	PackageEnvironment \
	ProtocolEnvironment \
	RestrictedEnvironment \
	SelectorEnvironment \
	VariableEnvironment \
	MultiEnvironment \
	ParseTreeEnvironment \




COMMON_OBJS= \
    $(OUTDIR_SLASH)BrowserDialog.$(O) \
    $(OUTDIR_SLASH)BrowserEnvironmentWrapper.$(O) \
    $(OUTDIR_SLASH)LimitedEnvironment.$(O) \
    $(OUTDIR_SLASH)RefactoryTyper.$(O) \
    $(OUTDIR_SLASH)stx_goodies_refactoryBrowser_browser.$(O) \
    $(OUTDIR_SLASH)AndEnvironment.$(O) \
    $(OUTDIR_SLASH)CategoryEnvironment.$(O) \
    $(OUTDIR_SLASH)ClassEnvironment.$(O) \
    $(OUTDIR_SLASH)EmptyEnvironment.$(O) \
    $(OUTDIR_SLASH)MethodNameDialog.$(O) \
    $(OUTDIR_SLASH)NamespaceEnvironment.$(O) \
    $(OUTDIR_SLASH)NotEnvironment.$(O) \
    $(OUTDIR_SLASH)PackageEnvironment.$(O) \
    $(OUTDIR_SLASH)ProtocolEnvironment.$(O) \
    $(OUTDIR_SLASH)RestrictedEnvironment.$(O) \
    $(OUTDIR_SLASH)SelectorEnvironment.$(O) \
    $(OUTDIR_SLASH)VariableEnvironment.$(O) \
    $(OUTDIR_SLASH)MultiEnvironment.$(O) \
    $(OUTDIR_SLASH)ParseTreeEnvironment.$(O) \
    $(OUTDIR_SLASH)extensions.$(O) \



