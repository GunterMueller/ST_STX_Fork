# $Header$
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_goodies_ring_tests.
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
MODULE_DIR=goodies/ring/tests
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
	RGClassDefinitionTest \
	RGCommentDefinitionTest \
	RGContainerTest \
	RGGlobalDefinitionTest \
	RGMetaclassDefinitionTest \
	RGMetatraitDefinitionTest \
	RGMethodDefinitionTest \
	RGNamespaceTest \
	RGPackageTest \
	RGSliceTest \
	RGTraitDefinitionTest \
	RGVariableDefinitionTest \
	stx_goodies_ring_tests \




COMMON_OBJS= \
    $(OUTDIR_SLASH)RGClassDefinitionTest.$(O) \
    $(OUTDIR_SLASH)RGCommentDefinitionTest.$(O) \
    $(OUTDIR_SLASH)RGContainerTest.$(O) \
    $(OUTDIR_SLASH)RGGlobalDefinitionTest.$(O) \
    $(OUTDIR_SLASH)RGMetaclassDefinitionTest.$(O) \
    $(OUTDIR_SLASH)RGMetatraitDefinitionTest.$(O) \
    $(OUTDIR_SLASH)RGMethodDefinitionTest.$(O) \
    $(OUTDIR_SLASH)RGNamespaceTest.$(O) \
    $(OUTDIR_SLASH)RGPackageTest.$(O) \
    $(OUTDIR_SLASH)RGSliceTest.$(O) \
    $(OUTDIR_SLASH)RGTraitDefinitionTest.$(O) \
    $(OUTDIR_SLASH)RGVariableDefinitionTest.$(O) \
    $(OUTDIR_SLASH)stx_goodies_ring_tests.$(O) \



