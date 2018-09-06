#
# DO NOT EDIT 
# automatically generated from Make.proto
#
# $Header: /cvs/stx/stx/libview/vms.mak,v 1.4 1999-09-18 14:14:51 cg Exp $
#
TOP=..
LIBNAME=libview
STCOPT="+optinline -warnNonStandard"
STCLOCALOPT=-package=stx:$(LIBNAME) $(COMMONSYMBOLS) $(SEPINITCODE) $(RELOCINSTVARS) -varPrefix=$(LIBNAME)
ALL: $(LIBDIR)\$(LIBNAME).olb

OBJS=\
  $(OUTDIR)GraphicsDevice.$(O) \
  $(OUTDIR)HostGraphicsDevice.$(O) \
  $(OUTDIR)DeviceWorkstation.$(O) \
  $(OUTDIR)Image.$(O) \
  $(OUTDIR)Depth1Image.$(O) \
  $(OUTDIR)Depth2Image.$(O) \
  $(OUTDIR)Depth4Image.$(O) \
  $(OUTDIR)Depth8Image.$(O) \
  $(OUTDIR)Depth24Image.$(O) \
  $(OUTDIR)ImageReader.$(O) \
  $(OUTDIR)Workstation.$(O) \
  $(OUTDIR)Color.$(O) \
  $(OUTDIR)Colormap.$(O) \
  $(OUTDIR)FontDescription.$(O) \
  $(OUTDIR)Font.$(O) \
  $(OUTDIR)Cursor.$(O) \
  $(OUTDIR)DeviceHandle.$(O) \
  $(OUTDIR)GraphicsContext.$(O) \
  $(OUTDIR)DeviceGraphicsContext.$(O) \
  $(OUTDIR)GraphicsMedium.$(O) \
  $(OUTDIR)Form.$(O) \
  $(OUTDIR)DisplaySurface.$(O) \
  $(OUTDIR)SimpleView.$(O) \
  $(OUTDIR)View.$(O) \
  $(OUTDIR)TopView.$(O) \
  $(OUTDIR)StandardSystemView.$(O) \
  $(OUTDIR)ModalBox.$(O) \
  $(OUTDIR)PopUpView.$(O) \
  $(OUTDIR)ShadowView.$(O) \
  $(OUTDIR)DisplayRootView.$(O) \
  $(OUTDIR)Controller.$(O) \
  $(OUTDIR)WindowingTransformation.$(O) \
  $(OUTDIR)WindowEvent.$(O) \
  $(OUTDIR)WindowGroup.$(O) \
  $(OUTDIR)WindowSensor.$(O) \
  $(OUTDIR)SynchronousWindowSensor.$(O) \
  $(OUTDIR)KeyboardForwarder.$(O) \
  $(OUTDIR)KeyboardMap.$(O) \
  $(OUTDIR)ResourcePack.$(O) \
  $(OUTDIR)ViewStyle.$(O) \
  $(OUTDIR)Depth16Image.$(O) \
  $(OUTDIR)Depth32Image.$(O) \
  $(OUTDIR)ImageMask.$(O) \
  $(OUTDIR)XWorkstation.$(O) \
  $(OUTDIR)GLXWorkstation.$(O) \


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
$(OUTDIR)AlphaMask.$(O) AlphaMask.$(H): AlphaMask.st $(STCHDR)  ../include/Depth8Image.$(H)  ../include/Image.$(H)  ../include/Object.$(H) 
$(OUTDIR)BitmapFont.$(O) BitmapFont.$(H): BitmapFont.st $(STCHDR)  ../include/FontDescription.$(H)  ../include/Object.$(H) 
$(OUTDIR)Border.$(O) Border.$(H): Border.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)Color.$(O) Color.$(H): Color.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)Colormap.$(O) Colormap.$(H): Colormap.st $(STCHDR)  ../include/SequenceableCollection.$(H)  ../include/Collection.$(H)  ../include/Object.$(H) 
$(OUTDIR)CompoundFont.$(O) CompoundFont.$(H): CompoundFont.st $(STCHDR)  ../include/FontDescription.$(H)  ../include/Object.$(H) 
$(OUTDIR)Controller.$(O) Controller.$(H): Controller.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)ControllerWithMenu.$(O) ControllerWithMenu.$(H): ControllerWithMenu.st $(STCHDR)  ../include/Controller.$(H)  ../include/Object.$(H) 
$(OUTDIR)Cursor.$(O) Cursor.$(H): Cursor.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)Depth16Image.$(O) Depth16Image.$(H): Depth16Image.st $(STCHDR)  ../include/Image.$(H)  ../include/Object.$(H) 
$(OUTDIR)Depth1Image.$(O) Depth1Image.$(H): Depth1Image.st $(STCHDR)  ../include/Image.$(H)  ../include/Object.$(H) 
$(OUTDIR)Depth24Image.$(O) Depth24Image.$(H): Depth24Image.st $(STCHDR)  ../include/Image.$(H)  ../include/Object.$(H) 
$(OUTDIR)Depth2Image.$(O) Depth2Image.$(H): Depth2Image.st $(STCHDR)  ../include/Image.$(H)  ../include/Object.$(H) 
$(OUTDIR)Depth32Image.$(O) Depth32Image.$(H): Depth32Image.st $(STCHDR)  ../include/Image.$(H)  ../include/Object.$(H) 
$(OUTDIR)Depth4Image.$(O) Depth4Image.$(H): Depth4Image.st $(STCHDR)  ../include/Image.$(H)  ../include/Object.$(H) 
$(OUTDIR)Depth8Image.$(O) Depth8Image.$(H): Depth8Image.st $(STCHDR)  ../include/Image.$(H)  ../include/Object.$(H) 
$(OUTDIR)DeviceGraphicsContext.$(O) DeviceGraphicsContext.$(H): DeviceGraphicsContext.st $(STCHDR)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)DeviceHandle.$(O) DeviceHandle.$(H): DeviceHandle.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)DeviceWorkstation.$(O) DeviceWorkstation.$(H): DeviceWorkstation.st $(STCHDR)  ../include/HostGraphicsDevice.$(H)  ../include/GraphicsDevice.$(H)  ../include/Object.$(H) 
$(OUTDIR)DisplayMedium.$(O) DisplayMedium.$(H): DisplayMedium.st $(STCHDR) 
$(OUTDIR)DisplayRootView.$(O) DisplayRootView.$(H): DisplayRootView.st $(STCHDR)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)DisplaySurface.$(O) DisplaySurface.$(H): DisplaySurface.st $(STCHDR)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H)  ../include/DeviceHandle.$(H) 
$(OUTDIR)Font.$(O) Font.$(H): Font.st $(STCHDR)  ../include/FontDescription.$(H)  ../include/Object.$(H) 
$(OUTDIR)FontDescription.$(O) FontDescription.$(H): FontDescription.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)Form.$(O) Form.$(H): Form.st $(STCHDR)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H)  ../include/DeviceHandle.$(H) 
$(OUTDIR)GLXWorkstation.$(O) GLXWorkstation.$(H): GLXWorkstation.st $(STCHDR)  ../include/XWorkstation.$(H)  ../include/DeviceWorkstation.$(H)  ../include/HostGraphicsDevice.$(H)  ../include/GraphicsDevice.$(H)  ../include/Object.$(H) 
$(OUTDIR)GraphicsAttributes.$(O) GraphicsAttributes.$(H): GraphicsAttributes.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)GraphicsContext.$(O) GraphicsContext.$(H): GraphicsContext.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)GraphicsDevice.$(O) GraphicsDevice.$(H): GraphicsDevice.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)GraphicsMedium.$(O) GraphicsMedium.$(H): GraphicsMedium.st $(STCHDR)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)HostGraphicsDevice.$(O) HostGraphicsDevice.$(H): HostGraphicsDevice.st $(STCHDR)  ../include/GraphicsDevice.$(H)  ../include/Object.$(H) 
$(OUTDIR)Image.$(O) Image.$(H): Image.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)ImageMask.$(O) ImageMask.$(H): ImageMask.st $(STCHDR)  ../include/Depth1Image.$(H)  ../include/Image.$(H)  ../include/Object.$(H) 
$(OUTDIR)ImageReader.$(O) ImageReader.$(H): ImageReader.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)KeyboardForwarder.$(O) KeyboardForwarder.$(H): KeyboardForwarder.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)KeyboardMap.$(O) KeyboardMap.$(H): KeyboardMap.st $(STCHDR)  ../include/IdentityDictionary.$(H)  ../include/Dictionary.$(H)  ../include/Set.$(H)  ../include/Collection.$(H)  ../include/Object.$(H) 
$(OUTDIR)ModalBox.$(O) ModalBox.$(H): ModalBox.st $(STCHDR)  ../include/StandardSystemView.$(H)  ../include/TopView.$(H)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)NeXTWorkstation.$(O) NeXTWorkstation.$(H): NeXTWorkstation.st $(STCHDR)  ../include/DeviceWorkstation.$(H)  ../include/HostGraphicsDevice.$(H)  ../include/GraphicsDevice.$(H)  ../include/Object.$(H) 
$(OUTDIR)PopUpView.$(O) PopUpView.$(H): PopUpView.st $(STCHDR)  ../include/TopView.$(H)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)ResourcePack.$(O) ResourcePack.$(H): ResourcePack.st $(STCHDR)  ../include/Dictionary.$(H)  ../include/Set.$(H)  ../include/Collection.$(H)  ../include/Object.$(H) 
$(OUTDIR)ShadowView.$(O) ShadowView.$(H): ShadowView.st $(STCHDR)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)SimpleView.$(O) SimpleView.$(H): SimpleView.st $(STCHDR)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)StandardSystemView.$(O) StandardSystemView.$(H): StandardSystemView.st $(STCHDR)  ../include/TopView.$(H)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)SynchronousWindowSensor.$(O) SynchronousWindowSensor.$(H): SynchronousWindowSensor.st $(STCHDR)  ../include/WindowSensor.$(H)  ../include/Object.$(H) 
$(OUTDIR)TopView.$(O) TopView.$(H): TopView.st $(STCHDR)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)View.$(O) View.$(H): View.st $(STCHDR)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)ViewStyle.$(O) ViewStyle.$(H): ViewStyle.st $(STCHDR)  ../include/ResourcePack.$(H)  ../include/Dictionary.$(H)  ../include/Set.$(H)  ../include/Collection.$(H)  ../include/Object.$(H) 
$(OUTDIR)WinWorkstation.$(O) WinWorkstation.$(H): WinWorkstation.st $(STCHDR)  ../include/DeviceWorkstation.$(H)  ../include/HostGraphicsDevice.$(H)  ../include/GraphicsDevice.$(H)  ../include/Object.$(H) 
$(OUTDIR)WindowEvent.$(O) WindowEvent.$(H): WindowEvent.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)WindowGroup.$(O) WindowGroup.$(H): WindowGroup.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)WindowSensor.$(O) WindowSensor.$(H): WindowSensor.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)WindowingTransformation.$(O) WindowingTransformation.$(H): WindowingTransformation.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)Workstation.$(O) Workstation.$(H): Workstation.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)XWorkstation.$(O) XWorkstation.$(H): XWorkstation.st $(STCHDR)  ../include/DeviceWorkstation.$(H)  ../include/HostGraphicsDevice.$(H)  ../include/GraphicsDevice.$(H)  ../include/Object.$(H) 
# ENDMAKEDEPEND
