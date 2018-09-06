# $Header: /cvs/stx/stx/clients/DrawTool/Make.spec,v 1.6 2013-04-26 07:39:11 stefan Exp $
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_clients_DrawTool.
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
MODULE_DIR=clients/DrawTool
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
	DrawObject \
	DrawTool \
	DrawView \
	PatternMenu \
	stx_clients_DrawTool \
	DrawEllipse \
	DrawGroup \
	DrawLine \
	DrawPolygon \
	DrawRectangle \
	DrawText \
	LineMenu \
	RectangularDrawObject \
	DrawArrow \
	DrawCircle \
	DrawCurve \
	DrawHLine \
	DrawImage \
	DrawRectangle3D \
	DrawRoundRectangle \
	DrawSpline \
	DrawVLine \




COMMON_OBJS= \
    $(OUTDIR_SLASH)DrawObject.$(O) \
    $(OUTDIR_SLASH)DrawTool.$(O) \
    $(OUTDIR_SLASH)DrawView.$(O) \
    $(OUTDIR_SLASH)PatternMenu.$(O) \
    $(OUTDIR_SLASH)stx_clients_DrawTool.$(O) \
    $(OUTDIR_SLASH)DrawEllipse.$(O) \
    $(OUTDIR_SLASH)DrawGroup.$(O) \
    $(OUTDIR_SLASH)DrawLine.$(O) \
    $(OUTDIR_SLASH)DrawPolygon.$(O) \
    $(OUTDIR_SLASH)DrawRectangle.$(O) \
    $(OUTDIR_SLASH)DrawText.$(O) \
    $(OUTDIR_SLASH)LineMenu.$(O) \
    $(OUTDIR_SLASH)RectangularDrawObject.$(O) \
    $(OUTDIR_SLASH)DrawArrow.$(O) \
    $(OUTDIR_SLASH)DrawCircle.$(O) \
    $(OUTDIR_SLASH)DrawCurve.$(O) \
    $(OUTDIR_SLASH)DrawHLine.$(O) \
    $(OUTDIR_SLASH)DrawImage.$(O) \
    $(OUTDIR_SLASH)DrawRectangle3D.$(O) \
    $(OUTDIR_SLASH)DrawRoundRectangle.$(O) \
    $(OUTDIR_SLASH)DrawSpline.$(O) \
    $(OUTDIR_SLASH)DrawVLine.$(O) \



