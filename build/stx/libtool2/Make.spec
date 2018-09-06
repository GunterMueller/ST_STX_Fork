# $Header$
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_libtool2.
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
MODULE_DIR=libtool2
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
STCWARNINGS=-warnNonStandard -warnUnused

COMMON_CLASSES= \
	ColorEditDialog \
	DataSetBuilder \
	DirectoryView \
	FlyByWindowInformation \
	ImageEditor \
	MenuEditor \
	MethodFinderWindow \
	SelectionBrowser \
	TabListEditor \
	Tools::ObjectModuleInformation \
	Tools::ProjectBuilder \
	Tools::ProjectBuilderAssistantApplication \
	UIGalleryView \
	UIHelpTool \
	UILayoutTool \
	UIListEditor \
	UIObjectView \
	UIPainter \
	UISelectionPanel \
	UISpecificationTool \
	stx_libtool2 \
	FileSelectionBrowser \
	ResourceSelectionBrowser \
	UIPainterView \




COMMON_OBJS= \
    $(OUTDIR_SLASH)ColorEditDialog.$(O) \
    $(OUTDIR_SLASH)DataSetBuilder.$(O) \
    $(OUTDIR_SLASH)DirectoryView.$(O) \
    $(OUTDIR_SLASH)FlyByWindowInformation.$(O) \
    $(OUTDIR_SLASH)ImageEditor.$(O) \
    $(OUTDIR_SLASH)MenuEditor.$(O) \
    $(OUTDIR_SLASH)MethodFinderWindow.$(O) \
    $(OUTDIR_SLASH)SelectionBrowser.$(O) \
    $(OUTDIR_SLASH)TabListEditor.$(O) \
    $(OUTDIR_SLASH)Tools__ObjectModuleInformation.$(O) \
    $(OUTDIR_SLASH)ProjectBuilder.$(O) \
    $(OUTDIR_SLASH)Tools__ProjectBuilderAssistantApplication.$(O) \
    $(OUTDIR_SLASH)UIGalleryView.$(O) \
    $(OUTDIR_SLASH)UIHelpTool.$(O) \
    $(OUTDIR_SLASH)UILayoutTool.$(O) \
    $(OUTDIR_SLASH)UIListEditor.$(O) \
    $(OUTDIR_SLASH)UIObjectView.$(O) \
    $(OUTDIR_SLASH)UIPainter.$(O) \
    $(OUTDIR_SLASH)UISelectionPanel.$(O) \
    $(OUTDIR_SLASH)UISpecificationTool.$(O) \
    $(OUTDIR_SLASH)stx_libtool2.$(O) \
    $(OUTDIR_SLASH)FileSelectionBrowser.$(O) \
    $(OUTDIR_SLASH)ResourceSelectionBrowser.$(O) \
    $(OUTDIR_SLASH)UIPainterView.$(O) \
    $(OUTDIR_SLASH)extensions.$(O) \



