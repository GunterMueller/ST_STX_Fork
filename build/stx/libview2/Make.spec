# $Header$
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_libview2.
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
MODULE_DIR=libview2
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
STCLOCALOPTIMIZATIONS=+optinline


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
	ActiveHelpView \
	ApplicationSubView \
	ApplicationWindow \
	ColorValue \
	DisplayObject \
	DragAndDropManager \
	DragHandler \
	DrawAdaptor \
	DropContext \
	DropObject \
	DropSource \
	DropTarget \
	EventListener \
	ExternalTopView \
	GIFReader \
	Icon \
	ImageFrame \
	ImageSequence \
	InputView \
	JPEGReader \
	KeyboardProcessor \
	Layout \
	MIMETypeIconLibrary \
	MIMETypes \
	MacOSXIconReader \
	MenuItem \
	Model \
	MultiImage \
	PNGReader \
	PopUpBanner \
	PrintConverter \
	PrinterContext \
	PropertyListDictionary \
	ResourceRetriever \
	StandardSystemController \
	TIFFReader \
	TransparentBox \
	VisualRegion \
	WindowBuilder \
	WindowsIconReader \
	XBMReader \
	XPMReader \
	stx_libview2 \
	ActiveHelp \
	ApplicationModel \
	LayoutOrigin \
	Menu \
	Plug \
	PluggableEventListener \
	ScreenLock \
	UIBuilder \
	ValueModel \
	VisualComponent \
	AlignmentOrigin \
	ApplicationWithFileHistory \
	BlockValue \
	FlyByHelp \
	IndirectValue \
	LayoutFrame \
	PluggableAdaptor \
	ProtocolAdaptor \
	SimpleDialog \
	ToolApplicationModel \
	ValueHolder \
	VisualPart \
	AspectAdaptor \
	BooleanBlockValue \
	BooleanValueHolder \
	BufferedValueHolder \
	DictionaryAdaptor \
	RangeAdaptor \
	ResourceSpecEditor \
	TriggerValue \
	TypeConverter \
	ValueHolderWithRememberedPreviousValue \
	ValueHolderWithWeakDependents \
	AspectAdaptorWithDefault \

WIN32_CLASSES= \
	WinPrinterStream \
	WinPrinterContext \




COMMON_OBJS= \
    $(OUTDIR)ActiveHelpView.$(O) \
    $(OUTDIR)ApplicationSubView.$(O) \
    $(OUTDIR)ApplicationWindow.$(O) \
    $(OUTDIR)ColorValue.$(O) \
    $(OUTDIR)DisplayObject.$(O) \
    $(OUTDIR)DragAndDropManager.$(O) \
    $(OUTDIR)DragHandler.$(O) \
    $(OUTDIR)DrawAdaptor.$(O) \
    $(OUTDIR)DropContext.$(O) \
    $(OUTDIR)DropObject.$(O) \
    $(OUTDIR)DropSource.$(O) \
    $(OUTDIR)DropTarget.$(O) \
    $(OUTDIR)EventListener.$(O) \
    $(OUTDIR)ExternalTopView.$(O) \
    $(OUTDIR)GIFReader.$(O) \
    $(OUTDIR)Icon.$(O) \
    $(OUTDIR)ImageFrame.$(O) \
    $(OUTDIR)ImageSequence.$(O) \
    $(OUTDIR)InputView.$(O) \
    $(OUTDIR)JPEGReader.$(O) \
    $(OUTDIR)KeyboardProcessor.$(O) \
    $(OUTDIR)Layout.$(O) \
    $(OUTDIR)MIMETypeIconLibrary.$(O) \
    $(OUTDIR)MIMETypes.$(O) \
    $(OUTDIR)MacOSXIconReader.$(O) \
    $(OUTDIR)MenuItem.$(O) \
    $(OUTDIR)Model.$(O) \
    $(OUTDIR)MultiImage.$(O) \
    $(OUTDIR)PNGReader.$(O) \
    $(OUTDIR)PopUpBanner.$(O) \
    $(OUTDIR)PrintConverter.$(O) \
    $(OUTDIR)PrinterContext.$(O) \
    $(OUTDIR)PropertyListDictionary.$(O) \
    $(OUTDIR)ResourceRetriever.$(O) \
    $(OUTDIR)StandardSystemController.$(O) \
    $(OUTDIR)TIFFReader.$(O) \
    $(OUTDIR)TransparentBox.$(O) \
    $(OUTDIR)VisualRegion.$(O) \
    $(OUTDIR)WindowBuilder.$(O) \
    $(OUTDIR)WindowsIconReader.$(O) \
    $(OUTDIR)XBMReader.$(O) \
    $(OUTDIR)XPMReader.$(O) \
    $(OUTDIR)stx_libview2.$(O) \
    $(OUTDIR)ActiveHelp.$(O) \
    $(OUTDIR)ApplicationModel.$(O) \
    $(OUTDIR)LayoutOrigin.$(O) \
    $(OUTDIR)Menu.$(O) \
    $(OUTDIR)Plug.$(O) \
    $(OUTDIR)PluggableEventListener.$(O) \
    $(OUTDIR)ScreenLock.$(O) \
    $(OUTDIR)UIBuilder.$(O) \
    $(OUTDIR)ValueModel.$(O) \
    $(OUTDIR)VisualComponent.$(O) \
    $(OUTDIR)AlignmentOrigin.$(O) \
    $(OUTDIR)ApplicationWithFileHistory.$(O) \
    $(OUTDIR)BlockValue.$(O) \
    $(OUTDIR)FlyByHelp.$(O) \
    $(OUTDIR)IndirectValue.$(O) \
    $(OUTDIR)LayoutFrame.$(O) \
    $(OUTDIR)PluggableAdaptor.$(O) \
    $(OUTDIR)ProtocolAdaptor.$(O) \
    $(OUTDIR)SimpleDialog.$(O) \
    $(OUTDIR)ToolApplicationModel.$(O) \
    $(OUTDIR)ValueHolder.$(O) \
    $(OUTDIR)VisualPart.$(O) \
    $(OUTDIR)AspectAdaptor.$(O) \
    $(OUTDIR)BooleanBlockValue.$(O) \
    $(OUTDIR)BooleanValueHolder.$(O) \
    $(OUTDIR)BufferedValueHolder.$(O) \
    $(OUTDIR)DictionaryAdaptor.$(O) \
    $(OUTDIR)RangeAdaptor.$(O) \
    $(OUTDIR)ResourceSpecEditor.$(O) \
    $(OUTDIR)TriggerValue.$(O) \
    $(OUTDIR)TypeConverter.$(O) \
    $(OUTDIR)ValueHolderWithRememberedPreviousValue.$(O) \
    $(OUTDIR)ValueHolderWithWeakDependents.$(O) \
    $(OUTDIR)AspectAdaptorWithDefault.$(O) \
    $(OUTDIR)extensions.$(O) \

WIN32_OBJS= \
    $(OUTDIR)WinPrinterStream.$(O) \
    $(OUTDIR)WinPrinterContext.$(O) \



