# $Header$
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_goodies_libcairo.
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
MODULE_DIR=goodies/libcairo
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
	Cairo::Antialias \
	Cairo::CError \
	Cairo::CPrimitives \
	Cairo::CStructure \
	Cairo::ClockView \
	Cairo::Content \
	Cairo::Device \
	Cairo::DeviceType \
	Cairo::Extend \
	Cairo::FillRule \
	Cairo::Filter \
	Cairo::FontSlant \
	Cairo::FontType \
	Cairo::FontWeight \
	Cairo::Format \
	Cairo::HintMetrics \
	Cairo::HintStyle \
	Cairo::LineCap \
	Cairo::LineJoin \
	Cairo::Operator \
	Cairo::Path \
	Cairo::PathData \
	Cairo::PathDataType \
	Cairo::PatternType \
	Cairo::PdfVersion \
	Cairo::RectangleInt \
	Cairo::RectangleList \
	Cairo::Region \
	Cairo::RegionOverlap \
	Cairo::Status \
	Cairo::SubpixelOrder \
	Cairo::SurfaceObserverMode \
	Cairo::SurfaceType \
	Cairo::TextCluster \
	Cairo::TextClusterFlags \
	Cairo::TextExampleView \
	Cairo::UserDataKey \
	CairoGraphicsContextHandle \
	stx_goodies_libcairo \
	Cairo::CObject \
	Cairo::FontExtents \
	Cairo::Glyph \
	Cairo::Matrix \
	Cairo::Rectangle \
	Cairo::TextExtents \
	CairoGraphicsContext \
	CairoScaledFont \
	Cairo::FontFace \
	Cairo::FontOptions \
	Cairo::GraphicsContext \
	Cairo::Pattern \
	Cairo::ScaledFont \
	Cairo::Surface \
	Cairo::PatternGradient \
	Cairo::PatternSolid \
	Cairo::PatternSurface \
	Cairo::SurfaceImage \
	Cairo::SurfacePDF \
	Cairo::SurfaceWin32 \
	Cairo::SurfaceXlib \
	Cairo::PatternGradientLinear \
	Cairo::PatternGradientRadial \




COMMON_OBJS= \
    $(OUTDIR)Cairo__Antialias.$(O) \
    $(OUTDIR)Cairo__CError.$(O) \
    $(OUTDIR)Cairo__CPrimitives.$(O) \
    $(OUTDIR)Cairo__CStructure.$(O) \
    $(OUTDIR)Cairo__ClockView.$(O) \
    $(OUTDIR)Cairo__Content.$(O) \
    $(OUTDIR)Cairo__Device.$(O) \
    $(OUTDIR)Cairo__DeviceType.$(O) \
    $(OUTDIR)Cairo__Extend.$(O) \
    $(OUTDIR)Cairo__FillRule.$(O) \
    $(OUTDIR)Cairo__Filter.$(O) \
    $(OUTDIR)Cairo__FontSlant.$(O) \
    $(OUTDIR)Cairo__FontType.$(O) \
    $(OUTDIR)Cairo__FontWeight.$(O) \
    $(OUTDIR)Cairo__Format.$(O) \
    $(OUTDIR)Cairo__HintMetrics.$(O) \
    $(OUTDIR)Cairo__HintStyle.$(O) \
    $(OUTDIR)Cairo__LineCap.$(O) \
    $(OUTDIR)Cairo__LineJoin.$(O) \
    $(OUTDIR)Cairo__Operator.$(O) \
    $(OUTDIR)Cairo__Path.$(O) \
    $(OUTDIR)Cairo__PathData.$(O) \
    $(OUTDIR)Cairo__PathDataType.$(O) \
    $(OUTDIR)Cairo__PatternType.$(O) \
    $(OUTDIR)Cairo__PdfVersion.$(O) \
    $(OUTDIR)Cairo__RectangleInt.$(O) \
    $(OUTDIR)Cairo__RectangleList.$(O) \
    $(OUTDIR)Cairo__Region.$(O) \
    $(OUTDIR)Cairo__RegionOverlap.$(O) \
    $(OUTDIR)Cairo__Status.$(O) \
    $(OUTDIR)Cairo__SubpixelOrder.$(O) \
    $(OUTDIR)Cairo__SurfaceObserverMode.$(O) \
    $(OUTDIR)Cairo__SurfaceType.$(O) \
    $(OUTDIR)Cairo__TextCluster.$(O) \
    $(OUTDIR)Cairo__TextClusterFlags.$(O) \
    $(OUTDIR)Cairo__TextExampleView.$(O) \
    $(OUTDIR)Cairo__UserDataKey.$(O) \
    $(OUTDIR)CairoGraphicsContextHandle.$(O) \
    $(OUTDIR)stx_goodies_libcairo.$(O) \
    $(OUTDIR)Cairo__CObject.$(O) \
    $(OUTDIR)Cairo__FontExtents.$(O) \
    $(OUTDIR)Cairo__Glyph.$(O) \
    $(OUTDIR)Cairo__Matrix.$(O) \
    $(OUTDIR)Cairo__Rectangle.$(O) \
    $(OUTDIR)Cairo__TextExtents.$(O) \
    $(OUTDIR)CairoGraphicsContext.$(O) \
    $(OUTDIR)CairoScaledFont.$(O) \
    $(OUTDIR)Cairo__FontFace.$(O) \
    $(OUTDIR)Cairo__FontOptions.$(O) \
    $(OUTDIR)Cairo__GraphicsContext.$(O) \
    $(OUTDIR)Cairo__Pattern.$(O) \
    $(OUTDIR)Cairo__ScaledFont.$(O) \
    $(OUTDIR)Cairo__Surface.$(O) \
    $(OUTDIR)Cairo__PatternGradient.$(O) \
    $(OUTDIR)Cairo__PatternSolid.$(O) \
    $(OUTDIR)Cairo__PatternSurface.$(O) \
    $(OUTDIR)Cairo__SurfaceImage.$(O) \
    $(OUTDIR)Cairo__SurfacePDF.$(O) \
    $(OUTDIR)Cairo__SurfaceWin32.$(O) \
    $(OUTDIR)Cairo__SurfaceXlib.$(O) \
    $(OUTDIR)Cairo__PatternGradientLinear.$(O) \
    $(OUTDIR)Cairo__PatternGradientRadial.$(O) \
    $(OUTDIR)extensions.$(O) \



