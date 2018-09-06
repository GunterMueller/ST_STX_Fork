# $Header: /cvs/stx/stx/goodies/magritte/tests/Make.spec,v 1.3 2014-09-23 20:30:24 vrany Exp $
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_goodies_magritte_tests.
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
MODULE_DIR=goodies/magritte/tests
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
	Magritte::MAAccessorMock \
	Magritte::MAAdaptiveModelTest \
	Magritte::MAConditionTest \
	Magritte::MADescriptionBuilderTest \
	Magritte::MADynamicObjectTest \
	Magritte::MAExtensionsTest \
	Magritte::MAFileModelTest \
	Magritte::MAMockAddress \
	Magritte::MAObjectTest \
	Magritte::MATableModelTest \
	stx_goodies_magritte_tests \
	Magritte::MAAccessorTest \
	Magritte::MADescriptionTest \
	Magritte::MAExternalFileModelTest \
	Magritte::MAMementoTest \
	Magritte::MAMemoryFileModelTest \
	Magritte::MACachedMementoTest \
	Magritte::MAContainerTest \
	Magritte::MADelegatorAccessorTest \
	Magritte::MADictionaryAccessorTest \
	Magritte::MAElementDescriptionTest \
	Magritte::MAIdentityAccessorTest \
	Magritte::MANullAccessorTest \
	Magritte::MAPluggableAccessorTest \
	Magritte::MASelectorAccessorTest \
	Magritte::MAStraitMementoTest \
	Magritte::MAVariableAccessorTest \
	Magritte::MABooleanDescriptionTest \
	Magritte::MAChainAccessorTest \
	Magritte::MACheckedMementoTest \
	Magritte::MAClassDescriptionTest \
	Magritte::MAColorDescriptionTest \
	Magritte::MAFileDescriptionTest \
	Magritte::MAMagnitudeDescriptionTest \
	Magritte::MAPriorityContainerTest \
	Magritte::MAReferenceDescriptionTest \
	Magritte::MAStringDescriptionTest \
	Magritte::MADateDescriptionTest \
	Magritte::MADurationDescriptionTest \
	Magritte::MAMemoDescriptionTest \
	Magritte::MANumberDescriptionTest \
	Magritte::MAOptionDescriptionTest \
	Magritte::MAPasswordDescriptionTest \
	Magritte::MARelationDescriptionTest \
	Magritte::MASymbolDescriptionTest \
	Magritte::MATableDescriptionTest \
	Magritte::MATimeDescriptionTest \
	Magritte::MATimeStampDescriptionTest \
	Magritte::MATokenDescriptionTest \
	Magritte::MAMultipleOptionDescriptionTest \
	Magritte::MASingleOptionDescriptionTest \
	Magritte::MAToManyRelationDescriptionTest \
	Magritte::MAToOneRelationDescriptionTest \
	Magritte::MAToManyScalarRelationDescriptionTest \




COMMON_OBJS= \
    $(OUTDIR_SLASH)Magritte__MAAccessorMock.$(O) \
    $(OUTDIR_SLASH)Magritte__MAAdaptiveModelTest.$(O) \
    $(OUTDIR_SLASH)Magritte__MAConditionTest.$(O) \
    $(OUTDIR_SLASH)Magritte__MADescriptionBuilderTest.$(O) \
    $(OUTDIR_SLASH)Magritte__MADynamicObjectTest.$(O) \
    $(OUTDIR_SLASH)Magritte__MAExtensionsTest.$(O) \
    $(OUTDIR_SLASH)Magritte__MAFileModelTest.$(O) \
    $(OUTDIR_SLASH)Magritte__MAMockAddress.$(O) \
    $(OUTDIR_SLASH)Magritte__MAObjectTest.$(O) \
    $(OUTDIR_SLASH)Magritte__MATableModelTest.$(O) \
    $(OUTDIR_SLASH)stx_goodies_magritte_tests.$(O) \
    $(OUTDIR_SLASH)Magritte__MAAccessorTest.$(O) \
    $(OUTDIR_SLASH)Magritte__MADescriptionTest.$(O) \
    $(OUTDIR_SLASH)Magritte__MAExternalFileModelTest.$(O) \
    $(OUTDIR_SLASH)Magritte__MAMementoTest.$(O) \
    $(OUTDIR_SLASH)Magritte__MAMemoryFileModelTest.$(O) \
    $(OUTDIR_SLASH)Magritte__MACachedMementoTest.$(O) \
    $(OUTDIR_SLASH)Magritte__MAContainerTest.$(O) \
    $(OUTDIR_SLASH)Magritte__MADelegatorAccessorTest.$(O) \
    $(OUTDIR_SLASH)Magritte__MADictionaryAccessorTest.$(O) \
    $(OUTDIR_SLASH)Magritte__MAElementDescriptionTest.$(O) \
    $(OUTDIR_SLASH)Magritte__MAIdentityAccessorTest.$(O) \
    $(OUTDIR_SLASH)Magritte__MANullAccessorTest.$(O) \
    $(OUTDIR_SLASH)Magritte__MAPluggableAccessorTest.$(O) \
    $(OUTDIR_SLASH)Magritte__MASelectorAccessorTest.$(O) \
    $(OUTDIR_SLASH)Magritte__MAStraitMementoTest.$(O) \
    $(OUTDIR_SLASH)Magritte__MAVariableAccessorTest.$(O) \
    $(OUTDIR_SLASH)Magritte__MABooleanDescriptionTest.$(O) \
    $(OUTDIR_SLASH)Magritte__MAChainAccessorTest.$(O) \
    $(OUTDIR_SLASH)Magritte__MACheckedMementoTest.$(O) \
    $(OUTDIR_SLASH)Magritte__MAClassDescriptionTest.$(O) \
    $(OUTDIR_SLASH)Magritte__MAColorDescriptionTest.$(O) \
    $(OUTDIR_SLASH)Magritte__MAFileDescriptionTest.$(O) \
    $(OUTDIR_SLASH)Magritte__MAMagnitudeDescriptionTest.$(O) \
    $(OUTDIR_SLASH)Magritte__MAPriorityContainerTest.$(O) \
    $(OUTDIR_SLASH)Magritte__MAReferenceDescriptionTest.$(O) \
    $(OUTDIR_SLASH)Magritte__MAStringDescriptionTest.$(O) \
    $(OUTDIR_SLASH)Magritte__MADateDescriptionTest.$(O) \
    $(OUTDIR_SLASH)Magritte__MADurationDescriptionTest.$(O) \
    $(OUTDIR_SLASH)Magritte__MAMemoDescriptionTest.$(O) \
    $(OUTDIR_SLASH)Magritte__MANumberDescriptionTest.$(O) \
    $(OUTDIR_SLASH)Magritte__MAOptionDescriptionTest.$(O) \
    $(OUTDIR_SLASH)Magritte__MAPasswordDescriptionTest.$(O) \
    $(OUTDIR_SLASH)Magritte__MARelationDescriptionTest.$(O) \
    $(OUTDIR_SLASH)Magritte__MASymbolDescriptionTest.$(O) \
    $(OUTDIR_SLASH)Magritte__MATableDescriptionTest.$(O) \
    $(OUTDIR_SLASH)Magritte__MATimeDescriptionTest.$(O) \
    $(OUTDIR_SLASH)Magritte__MATimeStampDescriptionTest.$(O) \
    $(OUTDIR_SLASH)Magritte__MATokenDescriptionTest.$(O) \
    $(OUTDIR_SLASH)Magritte__MAMultipleOptionDescriptionTest.$(O) \
    $(OUTDIR_SLASH)Magritte__MASingleOptionDescriptionTest.$(O) \
    $(OUTDIR_SLASH)Magritte__MAToManyRelationDescriptionTest.$(O) \
    $(OUTDIR_SLASH)Magritte__MAToOneRelationDescriptionTest.$(O) \
    $(OUTDIR_SLASH)Magritte__MAToManyScalarRelationDescriptionTest.$(O) \



