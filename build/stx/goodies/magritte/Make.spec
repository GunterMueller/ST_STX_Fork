# $Header: /cvs/stx/stx/goodies/magritte/Make.spec,v 1.4 2014-09-23 20:23:14 vrany Exp $
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_goodies_magritte.
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
MODULE_DIR=goodies/magritte
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
	Magritte::MAAdaptiveModel \
	Magritte::MACompatibility \
	Magritte::MADescriptionBuilder \
	Magritte::MAError \
	Magritte::MAFileModel \
	Magritte::MAObject \
	Magritte::MAProxyObject \
	Magritte::MASortBlock \
	Magritte::MATableModel \
	Magritte::MAValueHolder \
	Magritte::MAVisitor \
	stx_goodies_magritte \
	Magritte::MAAccessor \
	Magritte::MACondition \
	Magritte::MADescription \
	Magritte::MADescriptionHolder \
	Magritte::MADynamicObject \
	Magritte::MAExternalFileModel \
	Magritte::MAGraphVisitor \
	Magritte::MAMemento \
	Magritte::MAMemoryFileModel \
	Magritte::MANamedBuilder \
	Magritte::MAPropertyError \
	Magritte::MAReadError \
	Magritte::MAStreamingVisitor \
	Magritte::MAValidationError \
	Magritte::MAWriteError \
	Magritte::MACachedMemento \
	Magritte::MAConditionError \
	Magritte::MAConflictError \
	Magritte::MAConjunctiveCondition \
	Magritte::MAContainer \
	Magritte::MADelegatorAccessor \
	Magritte::MADictionaryAccessor \
	Magritte::MAElementDescription \
	Magritte::MAIdentityAccessor \
	Magritte::MAKindError \
	Magritte::MAMultipleErrors \
	Magritte::MANegationCondition \
	Magritte::MANullAccessor \
	Magritte::MAPluggableAccessor \
	Magritte::MAPluggableCondition \
	Magritte::MARangeError \
	Magritte::MAReader \
	Magritte::MARequiredError \
	Magritte::MASelectorAccessor \
	Magritte::MAStraitMemento \
	Magritte::MAValidatorVisitor \
	Magritte::MAVariableAccessor \
	Magritte::MAWriter \
	Magritte::MABooleanDescription \
	Magritte::MAChainAccessor \
	Magritte::MACheckedMemento \
	Magritte::MAClassDescription \
	Magritte::MAColorDescription \
	Magritte::MAFileDescription \
	Magritte::MAMagnitudeDescription \
	Magritte::MAPriorityContainer \
	Magritte::MAReferenceDescription \
	Magritte::MAStringDescription \
	Magritte::MAStringReader \
	Magritte::MAStringWriter \
	Magritte::MADateDescription \
	Magritte::MADurationDescription \
	Magritte::MAMemoDescription \
	Magritte::MANumberDescription \
	Magritte::MAOptionDescription \
	Magritte::MAPasswordDescription \
	Magritte::MARelationDescription \
	Magritte::MASymbolDescription \
	Magritte::MATableDescription \
	Magritte::MATimeDescription \
	Magritte::MATimeStampDescription \
	Magritte::MATokenDescription \
	Magritte::MAMultipleOptionDescription \
	Magritte::MASingleOptionDescription \
	Magritte::MAToManyRelationDescription \
	Magritte::MAToOneRelationDescription \
	Magritte::MAToManyScalarRelationDescription \




COMMON_OBJS= \
    $(OUTDIR_SLASH)Magritte__MAAdaptiveModel.$(O) \
    $(OUTDIR_SLASH)Magritte__MACompatibility.$(O) \
    $(OUTDIR_SLASH)Magritte__MADescriptionBuilder.$(O) \
    $(OUTDIR_SLASH)Magritte__MAError.$(O) \
    $(OUTDIR_SLASH)Magritte__MAFileModel.$(O) \
    $(OUTDIR_SLASH)Magritte__MAObject.$(O) \
    $(OUTDIR_SLASH)Magritte__MAProxyObject.$(O) \
    $(OUTDIR_SLASH)Magritte__MASortBlock.$(O) \
    $(OUTDIR_SLASH)Magritte__MATableModel.$(O) \
    $(OUTDIR_SLASH)Magritte__MAValueHolder.$(O) \
    $(OUTDIR_SLASH)Magritte__MAVisitor.$(O) \
    $(OUTDIR_SLASH)stx_goodies_magritte.$(O) \
    $(OUTDIR_SLASH)Magritte__MAAccessor.$(O) \
    $(OUTDIR_SLASH)Magritte__MACondition.$(O) \
    $(OUTDIR_SLASH)Magritte__MADescription.$(O) \
    $(OUTDIR_SLASH)Magritte__MADescriptionHolder.$(O) \
    $(OUTDIR_SLASH)Magritte__MADynamicObject.$(O) \
    $(OUTDIR_SLASH)Magritte__MAExternalFileModel.$(O) \
    $(OUTDIR_SLASH)Magritte__MAGraphVisitor.$(O) \
    $(OUTDIR_SLASH)Magritte__MAMemento.$(O) \
    $(OUTDIR_SLASH)Magritte__MAMemoryFileModel.$(O) \
    $(OUTDIR_SLASH)Magritte__MANamedBuilder.$(O) \
    $(OUTDIR_SLASH)Magritte__MAPropertyError.$(O) \
    $(OUTDIR_SLASH)Magritte__MAReadError.$(O) \
    $(OUTDIR_SLASH)Magritte__MAStreamingVisitor.$(O) \
    $(OUTDIR_SLASH)Magritte__MAValidationError.$(O) \
    $(OUTDIR_SLASH)Magritte__MAWriteError.$(O) \
    $(OUTDIR_SLASH)Magritte__MACachedMemento.$(O) \
    $(OUTDIR_SLASH)Magritte__MAConditionError.$(O) \
    $(OUTDIR_SLASH)Magritte__MAConflictError.$(O) \
    $(OUTDIR_SLASH)Magritte__MAConjunctiveCondition.$(O) \
    $(OUTDIR_SLASH)Magritte__MAContainer.$(O) \
    $(OUTDIR_SLASH)Magritte__MADelegatorAccessor.$(O) \
    $(OUTDIR_SLASH)Magritte__MADictionaryAccessor.$(O) \
    $(OUTDIR_SLASH)Magritte__MAElementDescription.$(O) \
    $(OUTDIR_SLASH)Magritte__MAIdentityAccessor.$(O) \
    $(OUTDIR_SLASH)Magritte__MAKindError.$(O) \
    $(OUTDIR_SLASH)Magritte__MAMultipleErrors.$(O) \
    $(OUTDIR_SLASH)Magritte__MANegationCondition.$(O) \
    $(OUTDIR_SLASH)Magritte__MANullAccessor.$(O) \
    $(OUTDIR_SLASH)Magritte__MAPluggableAccessor.$(O) \
    $(OUTDIR_SLASH)Magritte__MAPluggableCondition.$(O) \
    $(OUTDIR_SLASH)Magritte__MARangeError.$(O) \
    $(OUTDIR_SLASH)Magritte__MAReader.$(O) \
    $(OUTDIR_SLASH)Magritte__MARequiredError.$(O) \
    $(OUTDIR_SLASH)Magritte__MASelectorAccessor.$(O) \
    $(OUTDIR_SLASH)Magritte__MAStraitMemento.$(O) \
    $(OUTDIR_SLASH)Magritte__MAValidatorVisitor.$(O) \
    $(OUTDIR_SLASH)Magritte__MAVariableAccessor.$(O) \
    $(OUTDIR_SLASH)Magritte__MAWriter.$(O) \
    $(OUTDIR_SLASH)Magritte__MABooleanDescription.$(O) \
    $(OUTDIR_SLASH)Magritte__MAChainAccessor.$(O) \
    $(OUTDIR_SLASH)Magritte__MACheckedMemento.$(O) \
    $(OUTDIR_SLASH)Magritte__MAClassDescription.$(O) \
    $(OUTDIR_SLASH)Magritte__MAColorDescription.$(O) \
    $(OUTDIR_SLASH)Magritte__MAFileDescription.$(O) \
    $(OUTDIR_SLASH)Magritte__MAMagnitudeDescription.$(O) \
    $(OUTDIR_SLASH)Magritte__MAPriorityContainer.$(O) \
    $(OUTDIR_SLASH)Magritte__MAReferenceDescription.$(O) \
    $(OUTDIR_SLASH)Magritte__MAStringDescription.$(O) \
    $(OUTDIR_SLASH)Magritte__MAStringReader.$(O) \
    $(OUTDIR_SLASH)Magritte__MAStringWriter.$(O) \
    $(OUTDIR_SLASH)Magritte__MADateDescription.$(O) \
    $(OUTDIR_SLASH)Magritte__MADurationDescription.$(O) \
    $(OUTDIR_SLASH)Magritte__MAMemoDescription.$(O) \
    $(OUTDIR_SLASH)Magritte__MANumberDescription.$(O) \
    $(OUTDIR_SLASH)Magritte__MAOptionDescription.$(O) \
    $(OUTDIR_SLASH)Magritte__MAPasswordDescription.$(O) \
    $(OUTDIR_SLASH)Magritte__MARelationDescription.$(O) \
    $(OUTDIR_SLASH)Magritte__MASymbolDescription.$(O) \
    $(OUTDIR_SLASH)Magritte__MATableDescription.$(O) \
    $(OUTDIR_SLASH)Magritte__MATimeDescription.$(O) \
    $(OUTDIR_SLASH)Magritte__MATimeStampDescription.$(O) \
    $(OUTDIR_SLASH)Magritte__MATokenDescription.$(O) \
    $(OUTDIR_SLASH)Magritte__MAMultipleOptionDescription.$(O) \
    $(OUTDIR_SLASH)Magritte__MASingleOptionDescription.$(O) \
    $(OUTDIR_SLASH)Magritte__MAToManyRelationDescription.$(O) \
    $(OUTDIR_SLASH)Magritte__MAToOneRelationDescription.$(O) \
    $(OUTDIR_SLASH)Magritte__MAToManyScalarRelationDescription.$(O) \
    $(OUTDIR_SLASH)extensions.$(O) \



