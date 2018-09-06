# $Header$
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_libview.
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
MODULE_DIR=libview
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
STCLOCALOPTIMIZATIONS=+optinline +optinline2


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
	AbstractBackground \
	AbstractBorder \
	Color \
	Colormap \
	Controller \
	Cursor \
	DeviceHandle \
	DisplayTransform \
	Event \
	FontDescription \
	GraphicsContext \
	GraphicsDevice \
	GraphicsMedium \
	Image \
	ImageReader \
	KeyboardForwarder \
	KeyboardMap \
	ResourcePack \
	WindowGroup \
	WindowSensor \
	stx_libview \
	BeveledBorder \
	BitmapFont \
	Border \
	ColorPalette \
	CompoundFont \
	Depth16Image \
	Depth1Image \
	Depth24Image \
	Depth2Image \
	Depth32Image \
	Depth48Image \
	Depth4Image \
	Depth64Image \
	Depth8Image \
	DeviceGraphicsContext \
	DisplaySurface \
	Font \
	Form \
	GradientBackground \
	HostGraphicsDevice \
	ImageBackground \
	MacButtonBorder \
	NoBackground \
	ScaleTransform \
	SimpleBorder \
	SolidBackground \
	SynchronousWindowSensor \
	ViewStyle \
	WindowEvent \
	DeviceWorkstation \
	DisplayRootView \
	FixedPalette \
	ImageMask \
	MacFlatButtonBorder \
	MappedPalette \
	RoundedBorder \
	SimpleView \
	WidgetEvent \
	WindowingTransformation \
	XGraphicsContext \
	FixedPaletteWithAlpha \
	MonoMappedPalette \
	ShadowView \
	View \
	TopView \
	PopUpView \
	StandardSystemView \
	ModalBox \

UNIX_CLASSES= \
	FcConstants \
	FcPattern \
	XftFontDescription \
	XEmbedContainerView \
	XWorkstation \
	GLXWorkstation \

WIN32_CLASSES= \
	WinWorkstation \




COMMON_OBJS= \
    $(OUTDIR)AbstractBackground.$(O) \
    $(OUTDIR)AbstractBorder.$(O) \
    $(OUTDIR)Color.$(O) \
    $(OUTDIR)Colormap.$(O) \
    $(OUTDIR)Controller.$(O) \
    $(OUTDIR)Cursor.$(O) \
    $(OUTDIR)DeviceHandle.$(O) \
    $(OUTDIR)DisplayTransform.$(O) \
    $(OUTDIR)Event.$(O) \
    $(OUTDIR)FontDescription.$(O) \
    $(OUTDIR)GraphicsContext.$(O) \
    $(OUTDIR)GraphicsDevice.$(O) \
    $(OUTDIR)GraphicsMedium.$(O) \
    $(OUTDIR)Image.$(O) \
    $(OUTDIR)ImageReader.$(O) \
    $(OUTDIR)KeyboardForwarder.$(O) \
    $(OUTDIR)KeyboardMap.$(O) \
    $(OUTDIR)ResourcePack.$(O) \
    $(OUTDIR)WindowGroup.$(O) \
    $(OUTDIR)WindowSensor.$(O) \
    $(OUTDIR)stx_libview.$(O) \
    $(OUTDIR)BeveledBorder.$(O) \
    $(OUTDIR)BitmapFont.$(O) \
    $(OUTDIR)Border.$(O) \
    $(OUTDIR)ColorPalette.$(O) \
    $(OUTDIR)CompoundFont.$(O) \
    $(OUTDIR)Depth16Image.$(O) \
    $(OUTDIR)Depth1Image.$(O) \
    $(OUTDIR)Depth24Image.$(O) \
    $(OUTDIR)Depth2Image.$(O) \
    $(OUTDIR)Depth32Image.$(O) \
    $(OUTDIR)Depth48Image.$(O) \
    $(OUTDIR)Depth4Image.$(O) \
    $(OUTDIR)Depth64Image.$(O) \
    $(OUTDIR)Depth8Image.$(O) \
    $(OUTDIR)DeviceGraphicsContext.$(O) \
    $(OUTDIR)DisplaySurface.$(O) \
    $(OUTDIR)Font.$(O) \
    $(OUTDIR)Form.$(O) \
    $(OUTDIR)GradientBackground.$(O) \
    $(OUTDIR)HostGraphicsDevice.$(O) \
    $(OUTDIR)ImageBackground.$(O) \
    $(OUTDIR)MacButtonBorder.$(O) \
    $(OUTDIR)NoBackground.$(O) \
    $(OUTDIR)ScaleTransform.$(O) \
    $(OUTDIR)SimpleBorder.$(O) \
    $(OUTDIR)SolidBackground.$(O) \
    $(OUTDIR)SynchronousWindowSensor.$(O) \
    $(OUTDIR)ViewStyle.$(O) \
    $(OUTDIR)WindowEvent.$(O) \
    $(OUTDIR)DeviceWorkstation.$(O) \
    $(OUTDIR)DisplayRootView.$(O) \
    $(OUTDIR)FixedPalette.$(O) \
    $(OUTDIR)ImageMask.$(O) \
    $(OUTDIR)MacFlatButtonBorder.$(O) \
    $(OUTDIR)MappedPalette.$(O) \
    $(OUTDIR)RoundedBorder.$(O) \
    $(OUTDIR)SimpleView.$(O) \
    $(OUTDIR)WidgetEvent.$(O) \
    $(OUTDIR)WindowingTransformation.$(O) \
    $(OUTDIR)XGraphicsContext.$(O) \
    $(OUTDIR)FixedPaletteWithAlpha.$(O) \
    $(OUTDIR)MonoMappedPalette.$(O) \
    $(OUTDIR)ShadowView.$(O) \
    $(OUTDIR)View.$(O) \
    $(OUTDIR)TopView.$(O) \
    $(OUTDIR)PopUpView.$(O) \
    $(OUTDIR)StandardSystemView.$(O) \
    $(OUTDIR)ModalBox.$(O) \
    $(OUTDIR)extensions.$(O) \

UNIX_OBJS= \
    $(OUTDIR)FcConstants.$(O) \
    $(OUTDIR)FcPattern.$(O) \
    $(OUTDIR)XftFontDescription.$(O) \
    $(OUTDIR)XEmbedContainerView.$(O) \
    $(OUTDIR)XWorkstation.$(O) \
    $(OUTDIR)GLXWorkstation.$(O) \

WIN32_OBJS= \
    $(OUTDIR)WinWorkstation.$(O) \



