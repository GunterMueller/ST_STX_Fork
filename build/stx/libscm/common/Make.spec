# $Header$
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_libscm_common.
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
MODULE_DIR=libscm/common
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
	SCMAbstractDialog \
	SCMAbstractPackageModel \
	SCMAbstractPackageWorkingCopyRegistry \
	SCMAbstractRevisionInfo \
	SCMAbstractSourceCodeManager \
	SCMAbstractTask \
	SCMCodeMonitor \
	SCMCommonPackageModelGroup \
	SCMCommonSourceCodeManagerUtilities \
	SCMCompatModeQuery \
	SCMError \
	SCMWarning \
	stx_libscm_common \
	SCMAbstractCommitDialog \
	SCMAbstractFileoutLikeTask \
	SCMAbstractPackageRevision \
	SCMAbstractPackageWorkingCopy \
	SCMPackageModelError \
	SCMPackageModelWarning \
	SCMAbstractCommitTask \




COMMON_OBJS= \
    $(OUTDIR_SLASH)SCMAbstractDialog.$(O) \
    $(OUTDIR_SLASH)SCMAbstractPackageModel.$(O) \
    $(OUTDIR_SLASH)SCMAbstractPackageWorkingCopyRegistry.$(O) \
    $(OUTDIR_SLASH)SCMAbstractRevisionInfo.$(O) \
    $(OUTDIR_SLASH)SCMAbstractSourceCodeManager.$(O) \
    $(OUTDIR_SLASH)SCMAbstractTask.$(O) \
    $(OUTDIR_SLASH)SCMCodeMonitor.$(O) \
    $(OUTDIR_SLASH)SCMCommonPackageModelGroup.$(O) \
    $(OUTDIR_SLASH)SCMCommonSourceCodeManagerUtilities.$(O) \
    $(OUTDIR_SLASH)SCMCompatModeQuery.$(O) \
    $(OUTDIR_SLASH)SCMError.$(O) \
    $(OUTDIR_SLASH)SCMWarning.$(O) \
    $(OUTDIR_SLASH)stx_libscm_common.$(O) \
    $(OUTDIR_SLASH)SCMAbstractCommitDialog.$(O) \
    $(OUTDIR_SLASH)SCMAbstractFileoutLikeTask.$(O) \
    $(OUTDIR_SLASH)SCMAbstractPackageRevision.$(O) \
    $(OUTDIR_SLASH)SCMAbstractPackageWorkingCopy.$(O) \
    $(OUTDIR_SLASH)SCMPackageModelError.$(O) \
    $(OUTDIR_SLASH)SCMPackageModelWarning.$(O) \
    $(OUTDIR_SLASH)SCMAbstractCommitTask.$(O) \
    $(OUTDIR_SLASH)extensions.$(O) \



