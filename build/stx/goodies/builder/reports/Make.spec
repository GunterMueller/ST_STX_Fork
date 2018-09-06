# $Header$
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_goodies_builder_reports.
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
MODULE_DIR=goodies/builder/reports
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
#  -warnUnused      : no warnings about unused variables
#
# ********** OPTIONAL: MODIFY the next line(s) ***
# STCWARNINGS=-warn
# STCWARNINGS=-warnNonStandard
# STCWARNINGS=-warnEOLComments
STCWARNINGS=-warnNonStandard

COMMON_CLASSES= \
	Builder::Report \
	Builder::ReportFormat \
	Builder::ReportRunner \
	Builder::ReportSourceInfo \
	stx_goodies_builder_reports \
	Builder::ChangeReport \
	Builder::CoverageReport \
	Builder::CoverageReportFormat \
	Builder::LintReport \
	Builder::LintReportFormat \
	Builder::ReportClassSourceInfo \
	Builder::ReportExtensionsSourceInfo \
	Builder::TestReport \
	Builder::TestReportFormat \




COMMON_OBJS= \
    $(OUTDIR_SLASH)Builder__Report.$(O) \
    $(OUTDIR_SLASH)Builder__ReportFormat.$(O) \
    $(OUTDIR_SLASH)Builder__ReportRunner.$(O) \
    $(OUTDIR_SLASH)Builder__ReportSourceInfo.$(O) \
    $(OUTDIR_SLASH)stx_goodies_builder_reports.$(O) \
    $(OUTDIR_SLASH)Builder__ChangeReport.$(O) \
    $(OUTDIR_SLASH)Builder__CoverageReport.$(O) \
    $(OUTDIR_SLASH)Builder__CoverageReportFormat.$(O) \
    $(OUTDIR_SLASH)Builder__LintReport.$(O) \
    $(OUTDIR_SLASH)Builder__LintReportFormat.$(O) \
    $(OUTDIR_SLASH)Builder__ReportClassSourceInfo.$(O) \
    $(OUTDIR_SLASH)Builder__ReportExtensionsSourceInfo.$(O) \
    $(OUTDIR_SLASH)Builder__TestReport.$(O) \
    $(OUTDIR_SLASH)Builder__TestReportFormat.$(O) \
    $(OUTDIR_SLASH)extensions.$(O) \



