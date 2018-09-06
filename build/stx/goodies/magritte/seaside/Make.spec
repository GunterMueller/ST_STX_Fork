# $Header: /cvs/stx/stx/goodies/magritte/seaside/Make.spec,v 1.2 2013-01-30 11:20:07 cg Exp $
#
# DO NOT EDIT 
# automagically generated from the projectDefinition: stx_goodies_magritte_seaside.
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
MODULE_DIR=goodies/magritte/seaside
PACKAGE=$(MODULE):$(MODULE_DIR)


# Argument(s) to the stc compiler (stc --usage).
#  -H.         : create header files locally
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

COMMON_OBJS= \
    $(OUTDIR_SLASH)Magritte__MAColumn.$(O) \
    $(OUTDIR_SLASH)Magritte__MAComponent.$(O) \
    $(OUTDIR_SLASH)Magritte__MAComponentDecoration.$(O) \
    $(OUTDIR_SLASH)Magritte__MAComponentRenderer.$(O) \
    $(OUTDIR_SLASH)Magritte__MAExampleEditor.$(O) \
    $(OUTDIR_SLASH)Magritte__MAFileModelHandler.$(O) \
    $(OUTDIR_SLASH)stx_goodies_magritte_seaside.$(O) \
    $(OUTDIR_SLASH)Magritte__MAActionColumn.$(O) \
    $(OUTDIR_SLASH)Magritte__MAColorChooser.$(O) \
    $(OUTDIR_SLASH)Magritte__MAContainerDecoration.$(O) \
    $(OUTDIR_SLASH)Magritte__MACssRenderer.$(O) \
    $(OUTDIR_SLASH)Magritte__MADescribedColumn.$(O) \
    $(OUTDIR_SLASH)Magritte__MADescriptionComponent.$(O) \
    $(OUTDIR_SLASH)Magritte__MADescriptionEditor.$(O) \
    $(OUTDIR_SLASH)Magritte__MAReport.$(O) \
    $(OUTDIR_SLASH)Magritte__MATableRenderer.$(O) \
    $(OUTDIR_SLASH)Magritte__MAValidationDecoration.$(O) \
    $(OUTDIR_SLASH)Magritte__MACommandColumn.$(O) \
    $(OUTDIR_SLASH)Magritte__MAContainerComponent.$(O) \
    $(OUTDIR_SLASH)Magritte__MADescribedComponentColumn.$(O) \
    $(OUTDIR_SLASH)Magritte__MADescribedScalarColumn.$(O) \
    $(OUTDIR_SLASH)Magritte__MAElementComponent.$(O) \
    $(OUTDIR_SLASH)Magritte__MAFormDecoration.$(O) \
    $(OUTDIR_SLASH)Magritte__MAReportComponent.$(O) \
    $(OUTDIR_SLASH)Magritte__MASelectionColumn.$(O) \
    $(OUTDIR_SLASH)Magritte__MASwitchDecoration.$(O) \
    $(OUTDIR_SLASH)Magritte__MAToggleColumn.$(O) \
    $(OUTDIR_SLASH)Magritte__MACheckboxColumn.$(O) \
    $(OUTDIR_SLASH)Magritte__MACheckboxComponent.$(O) \
    $(OUTDIR_SLASH)Magritte__MAColorComponent.$(O) \
    $(OUTDIR_SLASH)Magritte__MAFileUploadComponent.$(O) \
    $(OUTDIR_SLASH)Magritte__MAIndexedCommandColumn.$(O) \
    $(OUTDIR_SLASH)Magritte__MAOptionComponent.$(O) \
    $(OUTDIR_SLASH)Magritte__MAOptionboxColumn.$(O) \
    $(OUTDIR_SLASH)Magritte__MARangeComponent.$(O) \
    $(OUTDIR_SLASH)Magritte__MARelationComponent.$(O) \
    $(OUTDIR_SLASH)Magritte__MATableComponent.$(O) \
    $(OUTDIR_SLASH)Magritte__MATextAreaComponent.$(O) \
    $(OUTDIR_SLASH)Magritte__MATextInputComponent.$(O) \
    $(OUTDIR_SLASH)Magritte__MATextPasswordComponent.$(O) \
    $(OUTDIR_SLASH)Magritte__MAUndefinedComponent.$(O) \
    $(OUTDIR_SLASH)Magritte__MADateInputComponent.$(O) \
    $(OUTDIR_SLASH)Magritte__MAMultipleSelectionComponent.$(O) \
    $(OUTDIR_SLASH)Magritte__MAOneToManyComponent.$(O) \
    $(OUTDIR_SLASH)Magritte__MAOneToOneComponent.$(O) \
    $(OUTDIR_SLASH)Magritte__MASingleSelectionComponent.$(O) \
    $(OUTDIR_SLASH)Magritte__MATimeInputComponent.$(O) \
    $(OUTDIR_SLASH)Magritte__MATimeStampInputComponent.$(O) \
    $(OUTDIR_SLASH)Magritte__MAVerifiedPasswordComponent.$(O) \
    $(OUTDIR_SLASH)Magritte__MACheckboxGroupComponent.$(O) \
    $(OUTDIR_SLASH)Magritte__MADateSelectorComponent.$(O) \
    $(OUTDIR_SLASH)Magritte__MAExternalEditorComponent.$(O) \
    $(OUTDIR_SLASH)Magritte__MAInternalEditorComponent.$(O) \
    $(OUTDIR_SLASH)Magritte__MAListCompositonComponent.$(O) \
    $(OUTDIR_SLASH)Magritte__MAMultiselectListComponent.$(O) \
    $(OUTDIR_SLASH)Magritte__MAOneToManyScalarComponent.$(O) \
    $(OUTDIR_SLASH)Magritte__MARadioGroupComponent.$(O) \
    $(OUTDIR_SLASH)Magritte__MASelectListComponent.$(O) \
    $(OUTDIR_SLASH)Magritte__MATimeSelectorComponent.$(O) \
    $(OUTDIR_SLASH)extensions.$(O) \


