#
# DO NOT EDIT 
# automatically generated from Make.proto
#
# $Header: /cvs/stx/stx/libview2/vms.mak,v 1.4 1999-09-18 14:16:05 cg Exp $
#
TOP=..
LIBNAME=libview2
STCOPT="+optspace2 -warnNonStandard"
STCLOCALOPT=-package=stx:$(LIBNAME) $(COMMONSYMBOLS) $(SEPINITCODE) $(RELOCINSTVARS) -varPrefix=$(LIBNAME)
ALL: $(LIBDIR)\$(LIBNAME).olb

OBJS=\
  $(OUTDIR)ColorValue.$(O) \
  $(OUTDIR)Icon.$(O) \
  $(OUTDIR)DisplayObject.$(O) \
  $(OUTDIR)InputView.$(O) \
  $(OUTDIR)PrintConverter.$(O) \
  $(OUTDIR)MIMETypes.$(O) \
  $(OUTDIR)ApplicationWindow.$(O) \
  $(OUTDIR)Model.$(O) \
  $(OUTDIR)ApplicationModel.$(O) \
  $(OUTDIR)ToolApplicationModel.$(O) \
  $(OUTDIR)ResourceSpecEditor.$(O) \
  $(OUTDIR)ValueModel.$(O) \
  $(OUTDIR)PluggableAdaptor.$(O) \
  $(OUTDIR)TypeConverter.$(O) \
  $(OUTDIR)BlockValue.$(O) \
  $(OUTDIR)ValueHolder.$(O) \
  $(OUTDIR)TriggerValue.$(O) \
  $(OUTDIR)ProtocolAdaptor.$(O) \
  $(OUTDIR)AspectAdaptor.$(O) \
  $(OUTDIR)BufferedValueHolder.$(O) \
  $(OUTDIR)Plug.$(O) \
  $(OUTDIR)StandardSystemController.$(O) \
  $(OUTDIR)Layout.$(O) \
  $(OUTDIR)LayoutOrigin.$(O) \
  $(OUTDIR)LayoutFrame.$(O) \
  $(OUTDIR)AlignmentOrigin.$(O) \
  $(OUTDIR)EventListener.$(O) \
  $(OUTDIR)ActiveHelp.$(O) \
  $(OUTDIR)ActiveHelpView.$(O) \
  $(OUTDIR)KeyboardProcessor.$(O) \
  $(OUTDIR)Menu.$(O) \
  $(OUTDIR)MenuItem.$(O) \
  $(OUTDIR)DragAndDropManager.$(O) \
  $(OUTDIR)DropObject.$(O) \
  $(OUTDIR)DropContext.$(O) \
  $(OUTDIR)DropTarget.$(O) \
  $(OUTDIR)DragHandler.$(O) \
  $(OUTDIR)VisualRegion.$(O) \
  $(OUTDIR)ResourceRetriever.$(O) \
  $(OUTDIR)WindowBuilder.$(O) \
  $(OUTDIR)UIBuilder.$(O) \
  $(OUTDIR)TIFFReader.$(O) \
  $(OUTDIR)GIFReader.$(O) \
  $(OUTDIR)XBMReader.$(O) \
  $(OUTDIR)XPMReader.$(O) \
  $(OUTDIR)JPEGReader.$(O) \
  $(OUTDIR)SimpleDialog.$(O) \


theLib:: $(LIBNAME).olb
	write sys$output "making class objects ..."
	$(MAKE) objs
	$(MAKE) libinit
	write sys$output "classlibrary $(LIBNAME).olb made."

$(LIBNAME).olb:
	write sys$output "creating initial $(LIBNAME).olb ..."
	lib/cre $(LIBNAME).olb

objs:  $(OBJS1)



# BEGINMAKEDEPEND
$(OUTDIR)AVIReader.$(O) AVIReader.$(H): AVIReader.st $(STCHDR) 
$(OUTDIR)ActiveHelp.$(O) ActiveHelp.$(H): ActiveHelp.st $(STCHDR)  ../include/EventListener.$(H)  ../include/Object.$(H) 
$(OUTDIR)ActiveHelpView.$(O) ActiveHelpView.$(H): ActiveHelpView.st $(STCHDR)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)AlignmentOrigin.$(O) AlignmentOrigin.$(H): AlignmentOrigin.st $(STCHDR)  ../include/LayoutOrigin.$(H)  ../include/Layout.$(H)  ../include/Object.$(H) 
$(OUTDIR)ApplicationController.$(O) ApplicationController.$(H): ApplicationController.st $(STCHDR) 
$(OUTDIR)ApplicationModel.$(O) ApplicationModel.$(H): ApplicationModel.st $(STCHDR)  ../include/Model.$(H)  ../include/Object.$(H) 
$(OUTDIR)ApplicationWindow.$(O) ApplicationWindow.$(H): ApplicationWindow.st $(STCHDR)  ../include/StandardSystemView.$(H)  ../include/TopView.$(H)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)AspectAdaptor.$(O) AspectAdaptor.$(H): AspectAdaptor.st $(STCHDR)  ../include/ProtocolAdaptor.$(H)  ../include/ValueModel.$(H)  ../include/Model.$(H)  ../include/Object.$(H) 
$(OUTDIR)BlitImageReader.$(O) BlitImageReader.$(H): BlitImageReader.st $(STCHDR)  ../include/ImageReader.$(H)  ../include/Object.$(H) 
$(OUTDIR)BlockValue.$(O) BlockValue.$(H): BlockValue.st $(STCHDR)  ../include/ValueModel.$(H)  ../include/Model.$(H)  ../include/Object.$(H) 
$(OUTDIR)BorderedWrapper.$(O) BorderedWrapper.$(H): BorderedWrapper.st $(STCHDR) 
$(OUTDIR)BoundedWrapper.$(O) BoundedWrapper.$(H): BoundedWrapper.st $(STCHDR) 
$(OUTDIR)BufferedValueHolder.$(O) BufferedValueHolder.$(H): BufferedValueHolder.st $(STCHDR)  ../include/ValueHolder.$(H)  ../include/ValueModel.$(H)  ../include/Model.$(H)  ../include/Object.$(H) 
$(OUTDIR)ColorValue.$(O) ColorValue.$(H): ColorValue.st $(STCHDR)  ../include/Color.$(H)  ../include/Object.$(H) 
$(OUTDIR)CompositePart.$(O) CompositePart.$(H): CompositePart.st $(STCHDR) 
$(OUTDIR)ConvertedValue.$(O) ConvertedValue.$(H): ConvertedValue.st $(STCHDR)  ../include/ValueHolder.$(H)  ../include/ValueModel.$(H)  ../include/Model.$(H)  ../include/Object.$(H) 
$(OUTDIR)DependentPart.$(O) DependentPart.$(H): DependentPart.st $(STCHDR) 
$(OUTDIR)DisplayObject.$(O) DisplayObject.$(H): DisplayObject.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)DragAndDropManager.$(O) DragAndDropManager.$(H): DragAndDropManager.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)DragHandler.$(O) DragHandler.$(H): DragHandler.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)DropContext.$(O) DropContext.$(H): DropContext.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)DropObject.$(O) DropObject.$(H): DropObject.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)DropSource.$(O) DropSource.$(H): DropSource.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)DropTarget.$(O) DropTarget.$(H): DropTarget.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)EventListener.$(O) EventListener.$(H): EventListener.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)ExternalTopView.$(O) ExternalTopView.$(H): ExternalTopView.st $(STCHDR)  ../include/TopView.$(H)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)FLIReader.$(O) FLIReader.$(H): FLIReader.st $(STCHDR)  ../include/ImageReader.$(H)  ../include/Object.$(H) 
$(OUTDIR)FaceReader.$(O) FaceReader.$(H): FaceReader.st $(STCHDR)  ../include/ImageReader.$(H)  ../include/Object.$(H) 
$(OUTDIR)FillingWrapper.$(O) FillingWrapper.$(H): FillingWrapper.st $(STCHDR) 
$(OUTDIR)GIFReader.$(O) GIFReader.$(H): GIFReader.st $(STCHDR)  ../include/ImageReader.$(H)  ../include/Object.$(H) 
$(OUTDIR)GeometricWrapper.$(O) GeometricWrapper.$(H): GeometricWrapper.st $(STCHDR) 
$(OUTDIR)HersheyFont.$(O) HersheyFont.$(H): HersheyFont.st $(STCHDR)  ../include/Font.$(H)  ../include/FontDescription.$(H)  ../include/Object.$(H) 
$(OUTDIR)Icon.$(O) Icon.$(H): Icon.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)ImageFrame.$(O) ImageFrame.$(H): ImageFrame.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)ImageSequence.$(O) ImageSequence.$(H): ImageSequence.st $(STCHDR)  ../include/OrderedCollection.$(H)  ../include/SequenceableCollection.$(H)  ../include/Collection.$(H)  ../include/Object.$(H) 
$(OUTDIR)InputView.$(O) InputView.$(H): InputView.st $(STCHDR)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)Insets.$(O) Insets.$(H): Insets.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)IrisRGBReader.$(O) IrisRGBReader.$(H): IrisRGBReader.st $(STCHDR)  ../include/ImageReader.$(H)  ../include/Object.$(H) 
$(OUTDIR)JPEGReader.$(O) JPEGReader.$(H): JPEGReader.st $(STCHDR)  ../include/ImageReader.$(H)  ../include/Object.$(H) 
$(OUTDIR)KeyboardProcessor.$(O) KeyboardProcessor.$(H): KeyboardProcessor.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)Layout.$(O) Layout.$(H): Layout.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)LayoutFrame.$(O) LayoutFrame.$(H): LayoutFrame.st $(STCHDR)  ../include/LayoutOrigin.$(H)  ../include/Layout.$(H)  ../include/Object.$(H) 
$(OUTDIR)LayoutOrigin.$(O) LayoutOrigin.$(H): LayoutOrigin.st $(STCHDR)  ../include/Layout.$(H)  ../include/Object.$(H) 
$(OUTDIR)LayoutWrapper.$(O) LayoutWrapper.$(H): LayoutWrapper.st $(STCHDR) 
$(OUTDIR)MIMETypes.$(O) MIMETypes.$(H): MIMETypes.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)Menu.$(O) Menu.$(H): Menu.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)MenuItem.$(O) MenuItem.$(H): MenuItem.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)Model.$(O) Model.$(H): Model.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)PBMReader.$(O) PBMReader.$(H): PBMReader.st $(STCHDR)  ../include/ImageReader.$(H)  ../include/Object.$(H) 
$(OUTDIR)PCXReader.$(O) PCXReader.$(H): PCXReader.st $(STCHDR)  ../include/ImageReader.$(H)  ../include/Object.$(H) 
$(OUTDIR)PNGReader.$(O) PNGReader.$(H): PNGReader.st $(STCHDR)  ../include/ImageReader.$(H)  ../include/Object.$(H) 
$(OUTDIR)Plug.$(O) Plug.$(H): Plug.st $(STCHDR)  ../include/Model.$(H)  ../include/Object.$(H) 
$(OUTDIR)PluggableAdaptor.$(O) PluggableAdaptor.$(H): PluggableAdaptor.st $(STCHDR)  ../include/ValueModel.$(H)  ../include/Model.$(H)  ../include/Object.$(H) 
$(OUTDIR)PrintConverter.$(O) PrintConverter.$(H): PrintConverter.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)PropertyListDictionary.$(O) PropertyListDictionary.$(H): PropertyListDictionary.st $(STCHDR)  ../include/IdentityDictionary.$(H)  ../include/Dictionary.$(H)  ../include/Set.$(H)  ../include/Collection.$(H)  ../include/Object.$(H) 
$(OUTDIR)ProtocolAdaptor.$(O) ProtocolAdaptor.$(H): ProtocolAdaptor.st $(STCHDR)  ../include/ValueModel.$(H)  ../include/Model.$(H)  ../include/Object.$(H) 
$(OUTDIR)RIFFReader.$(O) RIFFReader.$(H): RIFFReader.st $(STCHDR)  ../include/ImageReader.$(H)  ../include/Object.$(H) 
$(OUTDIR)RangeAdaptor.$(O) RangeAdaptor.$(H): RangeAdaptor.st $(STCHDR)  ../include/ValueHolder.$(H)  ../include/ValueModel.$(H)  ../include/Model.$(H)  ../include/Object.$(H) 
$(OUTDIR)ResourceRetriever.$(O) ResourceRetriever.$(H): ResourceRetriever.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)ResourceSpecEditor.$(O) ResourceSpecEditor.$(H): ResourceSpecEditor.st $(STCHDR)  ../include/ToolApplicationModel.$(H)  ../include/ApplicationModel.$(H)  ../include/Model.$(H)  ../include/Object.$(H) 
$(OUTDIR)ST80FormReader.$(O) ST80FormReader.$(H): ST80FormReader.st $(STCHDR)  ../include/ImageReader.$(H)  ../include/Object.$(H) 
$(OUTDIR)SimpleDialog.$(O) SimpleDialog.$(H): SimpleDialog.st $(STCHDR)  ../include/ApplicationModel.$(H)  ../include/Model.$(H)  ../include/Object.$(H) 
$(OUTDIR)StandardSystemController.$(O) StandardSystemController.$(H): StandardSystemController.st $(STCHDR)  ../include/Controller.$(H)  ../include/Object.$(H) 
$(OUTDIR)StrokingWrapper.$(O) StrokingWrapper.$(H): StrokingWrapper.st $(STCHDR) 
$(OUTDIR)SunRasterReader.$(O) SunRasterReader.$(H): SunRasterReader.st $(STCHDR)  ../include/ImageReader.$(H)  ../include/Object.$(H) 
$(OUTDIR)TIFFReader.$(O) TIFFReader.$(H): TIFFReader.st $(STCHDR)  ../include/ImageReader.$(H)  ../include/Object.$(H) 
$(OUTDIR)TargaReader.$(O) TargaReader.$(H): TargaReader.st $(STCHDR)  ../include/ImageReader.$(H)  ../include/Object.$(H) 
$(OUTDIR)ToolApplicationModel.$(O) ToolApplicationModel.$(H): ToolApplicationModel.st $(STCHDR)  ../include/ApplicationModel.$(H)  ../include/Model.$(H)  ../include/Object.$(H) 
$(OUTDIR)TranslatingWrapper.$(O) TranslatingWrapper.$(H): TranslatingWrapper.st $(STCHDR) 
$(OUTDIR)TriggerValue.$(O) TriggerValue.$(H): TriggerValue.st $(STCHDR)  ../include/ValueHolder.$(H)  ../include/ValueModel.$(H)  ../include/Model.$(H)  ../include/Object.$(H) 
$(OUTDIR)TypeConverter.$(O) TypeConverter.$(H): TypeConverter.st $(STCHDR)  ../include/PluggableAdaptor.$(H)  ../include/ValueModel.$(H)  ../include/Model.$(H)  ../include/Object.$(H) 
$(OUTDIR)UIBuilder.$(O) UIBuilder.$(H): UIBuilder.st $(STCHDR)  ../include/WindowBuilder.$(H)  ../include/Object.$(H) 
$(OUTDIR)ValueHolder.$(O) ValueHolder.$(H): ValueHolder.st $(STCHDR)  ../include/ValueModel.$(H)  ../include/Model.$(H)  ../include/Object.$(H) 
$(OUTDIR)ValueModel.$(O) ValueModel.$(H): ValueModel.st $(STCHDR)  ../include/Model.$(H)  ../include/Object.$(H) 
$(OUTDIR)ViewForwardingController.$(O) ViewForwardingController.$(H): ViewForwardingController.st $(STCHDR)  ../include/Controller.$(H)  ../include/Object.$(H) 
$(OUTDIR)VisualComponent.$(O) VisualComponent.$(H): VisualComponent.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)VisualPart.$(O) VisualPart.$(H): VisualPart.st $(STCHDR) 
$(OUTDIR)VisualRegion.$(O) VisualRegion.$(H): VisualRegion.st $(STCHDR)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)WindowBuilder.$(O) WindowBuilder.$(H): WindowBuilder.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)WindowsIconReader.$(O) WindowsIconReader.$(H): WindowsIconReader.st $(STCHDR)  ../include/ImageReader.$(H)  ../include/Object.$(H) 
$(OUTDIR)Wrapper.$(O) Wrapper.$(H): Wrapper.st $(STCHDR) 
$(OUTDIR)XBMReader.$(O) XBMReader.$(H): XBMReader.st $(STCHDR)  ../include/ImageReader.$(H)  ../include/Object.$(H) 
$(OUTDIR)XPMReader.$(O) XPMReader.$(H): XPMReader.st $(STCHDR)  ../include/ImageReader.$(H)  ../include/Object.$(H) 
$(OUTDIR)XWDReader.$(O) XWDReader.$(H): XWDReader.st $(STCHDR)  ../include/ImageReader.$(H)  ../include/Object.$(H) 
# ENDMAKEDEPEND
