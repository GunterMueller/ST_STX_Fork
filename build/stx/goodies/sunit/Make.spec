# $Header$
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_goodies_sunit.
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
MODULE_DIR=goodies/sunit
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
	MetricsReporter \
	SUnitDelay \
	SUnitNameResolver \
	TestAsserter \
	TestCaseOutcome \
	TestCoverageReporter \
	TestFailure \
	TestResult \
	TestResultReporter \
	TestRunner \
	TestSuite \
	TestSuitesScripter \
	stx_goodies_sunit \
	ResumableTestFailure \
	TestCase \
	TestResource \
	TestResultStX \
	TestSkipped \
	TestCaseWithArguments \
	TestResultForRunWithDebug \




COMMON_OBJS= \
    $(OUTDIR_SLASH)MetricsReporter.$(O) \
    $(OUTDIR_SLASH)SUnitDelay.$(O) \
    $(OUTDIR_SLASH)SUnitNameResolver.$(O) \
    $(OUTDIR_SLASH)TestAsserter.$(O) \
    $(OUTDIR_SLASH)TestCaseOutcome.$(O) \
    $(OUTDIR_SLASH)TestCoverageReporter.$(O) \
    $(OUTDIR_SLASH)TestFailure.$(O) \
    $(OUTDIR_SLASH)TestResult.$(O) \
    $(OUTDIR_SLASH)TestResultReporter.$(O) \
    $(OUTDIR_SLASH)TestRunner.$(O) \
    $(OUTDIR_SLASH)TestSuite.$(O) \
    $(OUTDIR_SLASH)TestSuitesScripter.$(O) \
    $(OUTDIR_SLASH)stx_goodies_sunit.$(O) \
    $(OUTDIR_SLASH)ResumableTestFailure.$(O) \
    $(OUTDIR_SLASH)TestCase.$(O) \
    $(OUTDIR_SLASH)TestResource.$(O) \
    $(OUTDIR_SLASH)TestResultStX.$(O) \
    $(OUTDIR_SLASH)TestSkipped.$(O) \
    $(OUTDIR_SLASH)TestCaseWithArguments.$(O) \
    $(OUTDIR_SLASH)TestResultForRunWithDebug.$(O) \
    $(OUTDIR_SLASH)extensions.$(O) \



