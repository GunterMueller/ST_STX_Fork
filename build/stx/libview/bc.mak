# $Header$
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_libview.
#
# Warning: once you modify this file, do not rerun
# stmkmp or projectDefinition-build again - otherwise, your changes are lost.
#
# Notice, that the name bc.mak is historical (from times, when only borland c was supported).
# This file contains make rules for the win32 platform using either borland-bcc or visual-c.
# It shares common definitions with the unix-make in Make.spec.
# The bc.mak supports the following targets:
#    bmake         - compile all st-files to a classLib (dll)
#    bmake clean   - clean all temp files
#    bmake clobber - clean all
#
# Historic Note:
#  this used to contain only rules to make with borland
#    (called via bmake, by "make.exe -f bc.mak")
#  this has changed; it is now also possible to build using microsoft visual c
#    (called via vcmake, by "make.exe -f bc.mak -DUSEVC")
#
TOP=..
INCLUDE_TOP=$(TOP)\..


# see stdHeader_bc for LIBVIEW_BASE
LIB_BASE=$(LIBVIEW_BASE)


!INCLUDE $(TOP)\rules\stdHeader_bc

!INCLUDE Make.spec

LIBNAME=libstx_libview
MODULE_PATH=libview
RESFILES=stx_libviewWINrc.$(RES)


!ifdef USEBC
X11_LIBS=..\libbc\X11OMF.lib ..\libbc\XextOMF.lib
!else
! ifdef USEVC
# X11_LIBS=..\libvc\X11.lib ..\libvc\Xext.lib
! else
! endif
!endif


LOCALINCLUDES=$(OPTIONAL_SUPPORT_XLIB_INCLUDE) -I$(INCLUDE_TOP)\stx\libbasic -I$(INCLUDE_TOP)\stx\libbasic2
LOCALDEFINES=

STCLOCALOPT=-package=$(PACKAGE) -I. $(LOCALINCLUDES) -headerDir=. $(STCLOCALOPTIMIZATIONS) $(STCWARNINGS) $(LOCALDEFINES) $(COMMONSYMBOLS) -varPrefix=$(LIBNAME)
LOCALLIBS=

OBJS= $(COMMON_OBJS) $(WIN32_OBJS)

ALL::  classLibRule

classLibRule: $(OUTDIR) $(OUTDIR)$(LIBNAME).dll

!INCLUDE $(TOP)\rules\stdRules_bc

# build all mandatory prerequisite packages (containing superclasses) for this package
prereq:
	pushd ..\libbasic & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "



#

..\libbc\X11OMF.lib: ..\support\win32\borland\X11OMF.lib
	copy ..\support\win32\borland\X11OMF.lib ..\libbc

..\libbc\XextOMF.lib: ..\support\win32\borland\XextOMF.lib
	copy ..\support\win32\borland\XextOMF.lib ..\libbc

..\libvc\X11.lib: ..\support\win32\msc\X11.lib
	copy ..\support\win32\msc\X11.lib ..\libvc

..\libvc\Xext.lib: ..\support\win32\msc\Xext.lib
	copy ..\support\win32\msc\Xext.lib ..\libvc





test: $(TOP)\goodies\builder\reports\NUL
	pushd $(TOP)\goodies\builder\reports & $(MAKE_BAT)
	$(TOP)\goodies\builder\reports\report-runner.bat -D . -r Builder::TestReport -p $(PACKAGE)
        
clean::
	-del *.$(CSUFFIX)


# BEGINMAKEDEPEND --- do not remove this line; make depend needs it
$(OUTDIR)AbstractBackground.$(O) AbstractBackground.$(C) AbstractBackground.$(H): AbstractBackground.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)AbstractBorder.$(O) AbstractBorder.$(C) AbstractBorder.$(H): AbstractBorder.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Color.$(O) Color.$(C) Color.$(H): Color.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Colormap.$(O) Colormap.$(C) Colormap.$(H): Colormap.st $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(STCHDR)
$(OUTDIR)Controller.$(O) Controller.$(C) Controller.$(H): Controller.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Cursor.$(O) Cursor.$(C) Cursor.$(H): Cursor.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DeviceHandle.$(O) DeviceHandle.$(C) DeviceHandle.$(H): DeviceHandle.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DisplayTransform.$(O) DisplayTransform.$(C) DisplayTransform.$(H): DisplayTransform.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Event.$(O) Event.$(C) Event.$(H): Event.st $(INCLUDE_TOP)\stx\libbasic\Message.$(H) $(INCLUDE_TOP)\stx\libbasic\MessageSend.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)FontDescription.$(O) FontDescription.$(C) FontDescription.$(H): FontDescription.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GraphicsContext.$(O) GraphicsContext.$(C) GraphicsContext.$(H): GraphicsContext.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GraphicsDevice.$(O) GraphicsDevice.$(C) GraphicsDevice.$(H): GraphicsDevice.st $(INCLUDE_TOP)\stx\libbasic\AllocationFailure.$(H) $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\ProceedableError.$(H) $(STCHDR)
$(OUTDIR)GraphicsMedium.$(O) GraphicsMedium.$(C) GraphicsMedium.$(H): GraphicsMedium.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Image.$(O) Image.$(C) Image.$(H): Image.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)ImageReader.$(O) ImageReader.$(C) ImageReader.$(H): ImageReader.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)KeyboardForwarder.$(O) KeyboardForwarder.$(C) KeyboardForwarder.$(H): KeyboardForwarder.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)KeyboardMap.$(O) KeyboardMap.$(C) KeyboardMap.$(H): KeyboardMap.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)ResourcePack.$(O) ResourcePack.$(C) ResourcePack.$(H): ResourcePack.st $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Dictionary.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\Set.$(H) $(STCHDR)
$(OUTDIR)WindowGroup.$(O) WindowGroup.$(C) WindowGroup.$(H): WindowGroup.st $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Notification.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\Query.$(H) $(STCHDR)
$(OUTDIR)WindowSensor.$(O) WindowSensor.$(C) WindowSensor.$(H): WindowSensor.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)stx_libview.$(O) stx_libview.$(C) stx_libview.$(H): stx_libview.st $(INCLUDE_TOP)\stx\libbasic\LibraryDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\ProjectDefinition.$(H) $(STCHDR)
$(OUTDIR)BeveledBorder.$(O) BeveledBorder.$(C) BeveledBorder.$(H): BeveledBorder.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\AbstractBorder.$(H) $(STCHDR)
$(OUTDIR)BitmapFont.$(O) BitmapFont.$(C) BitmapFont.$(H): BitmapFont.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\FontDescription.$(H) $(STCHDR)
$(OUTDIR)Border.$(O) Border.$(C) Border.$(H): Border.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\AbstractBorder.$(H) $(STCHDR)
$(OUTDIR)ColorPalette.$(O) ColorPalette.$(C) ColorPalette.$(H): ColorPalette.st $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(INCLUDE_TOP)\stx\libview\Colormap.$(H) $(STCHDR)
$(OUTDIR)CompoundFont.$(O) CompoundFont.$(C) CompoundFont.$(H): CompoundFont.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\FontDescription.$(H) $(STCHDR)
$(OUTDIR)Depth16Image.$(O) Depth16Image.$(C) Depth16Image.$(H): Depth16Image.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\Image.$(H) $(STCHDR)
$(OUTDIR)Depth1Image.$(O) Depth1Image.$(C) Depth1Image.$(H): Depth1Image.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\Image.$(H) $(STCHDR)
$(OUTDIR)Depth24Image.$(O) Depth24Image.$(C) Depth24Image.$(H): Depth24Image.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\Image.$(H) $(STCHDR)
$(OUTDIR)Depth2Image.$(O) Depth2Image.$(C) Depth2Image.$(H): Depth2Image.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\Image.$(H) $(STCHDR)
$(OUTDIR)Depth32Image.$(O) Depth32Image.$(C) Depth32Image.$(H): Depth32Image.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\Image.$(H) $(STCHDR)
$(OUTDIR)Depth48Image.$(O) Depth48Image.$(C) Depth48Image.$(H): Depth48Image.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\Image.$(H) $(STCHDR)
$(OUTDIR)Depth4Image.$(O) Depth4Image.$(C) Depth4Image.$(H): Depth4Image.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\Image.$(H) $(STCHDR)
$(OUTDIR)Depth64Image.$(O) Depth64Image.$(C) Depth64Image.$(H): Depth64Image.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\Image.$(H) $(STCHDR)
$(OUTDIR)Depth8Image.$(O) Depth8Image.$(C) Depth8Image.$(H): Depth8Image.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\Image.$(H) $(STCHDR)
$(OUTDIR)DeviceGraphicsContext.$(O) DeviceGraphicsContext.$(C) DeviceGraphicsContext.$(H): DeviceGraphicsContext.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DeviceHandle.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsContext.$(H) $(STCHDR)
$(OUTDIR)DisplaySurface.$(O) DisplaySurface.$(C) DisplaySurface.$(H): DisplaySurface.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(STCHDR)
$(OUTDIR)Font.$(O) Font.$(C) Font.$(H): Font.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\FontDescription.$(H) $(STCHDR)
$(OUTDIR)Form.$(O) Form.$(C) Form.$(H): Form.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(STCHDR)
$(OUTDIR)GradientBackground.$(O) GradientBackground.$(C) GradientBackground.$(H): GradientBackground.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\AbstractBackground.$(H) $(STCHDR)
$(OUTDIR)HostGraphicsDevice.$(O) HostGraphicsDevice.$(C) HostGraphicsDevice.$(H): HostGraphicsDevice.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsDevice.$(H) $(STCHDR)
$(OUTDIR)ImageBackground.$(O) ImageBackground.$(C) ImageBackground.$(H): ImageBackground.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\AbstractBackground.$(H) $(STCHDR)
$(OUTDIR)MacButtonBorder.$(O) MacButtonBorder.$(C) MacButtonBorder.$(H): MacButtonBorder.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\AbstractBorder.$(H) $(STCHDR)
$(OUTDIR)NoBackground.$(O) NoBackground.$(C) NoBackground.$(H): NoBackground.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\AbstractBackground.$(H) $(STCHDR)
$(OUTDIR)ScaleTransform.$(O) ScaleTransform.$(C) ScaleTransform.$(H): ScaleTransform.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplayTransform.$(H) $(STCHDR)
$(OUTDIR)SimpleBorder.$(O) SimpleBorder.$(C) SimpleBorder.$(H): SimpleBorder.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\AbstractBorder.$(H) $(STCHDR)
$(OUTDIR)SolidBackground.$(O) SolidBackground.$(C) SolidBackground.$(H): SolidBackground.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\AbstractBackground.$(H) $(STCHDR)
$(OUTDIR)SynchronousWindowSensor.$(O) SynchronousWindowSensor.$(C) SynchronousWindowSensor.$(H): SynchronousWindowSensor.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\WindowSensor.$(H) $(STCHDR)
$(OUTDIR)ViewStyle.$(O) ViewStyle.$(C) ViewStyle.$(H): ViewStyle.st $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Dictionary.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\Set.$(H) $(INCLUDE_TOP)\stx\libview\ResourcePack.$(H) $(STCHDR)
$(OUTDIR)WindowEvent.$(O) WindowEvent.$(C) WindowEvent.$(H): WindowEvent.st $(INCLUDE_TOP)\stx\libbasic\Message.$(H) $(INCLUDE_TOP)\stx\libbasic\MessageSend.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\Event.$(H) $(STCHDR)
$(OUTDIR)DeviceWorkstation.$(O) DeviceWorkstation.$(C) DeviceWorkstation.$(H): DeviceWorkstation.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsDevice.$(H) $(INCLUDE_TOP)\stx\libview\HostGraphicsDevice.$(H) $(STCHDR)
$(OUTDIR)DisplayRootView.$(O) DisplayRootView.$(C) DisplayRootView.$(H): DisplayRootView.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(STCHDR)
$(OUTDIR)FixedPalette.$(O) FixedPalette.$(C) FixedPalette.$(H): FixedPalette.st $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(INCLUDE_TOP)\stx\libview\ColorPalette.$(H) $(INCLUDE_TOP)\stx\libview\Colormap.$(H) $(STCHDR)
$(OUTDIR)ImageMask.$(O) ImageMask.$(C) ImageMask.$(H): ImageMask.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\Depth1Image.$(H) $(INCLUDE_TOP)\stx\libview\Image.$(H) $(STCHDR)
$(OUTDIR)MacFlatButtonBorder.$(O) MacFlatButtonBorder.$(C) MacFlatButtonBorder.$(H): MacFlatButtonBorder.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\AbstractBorder.$(H) $(INCLUDE_TOP)\stx\libview\SimpleBorder.$(H) $(STCHDR)
$(OUTDIR)MappedPalette.$(O) MappedPalette.$(C) MappedPalette.$(H): MappedPalette.st $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(INCLUDE_TOP)\stx\libview\ColorPalette.$(H) $(INCLUDE_TOP)\stx\libview\Colormap.$(H) $(STCHDR)
$(OUTDIR)RoundedBorder.$(O) RoundedBorder.$(C) RoundedBorder.$(H): RoundedBorder.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\AbstractBorder.$(H) $(INCLUDE_TOP)\stx\libview\SimpleBorder.$(H) $(STCHDR)
$(OUTDIR)SimpleView.$(O) SimpleView.$(C) SimpleView.$(H): SimpleView.st $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Notification.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\ProceedingNotification.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(STCHDR)
$(OUTDIR)WidgetEvent.$(O) WidgetEvent.$(C) WidgetEvent.$(H): WidgetEvent.st $(INCLUDE_TOP)\stx\libbasic\Message.$(H) $(INCLUDE_TOP)\stx\libbasic\MessageSend.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\Event.$(H) $(INCLUDE_TOP)\stx\libview\WindowEvent.$(H) $(STCHDR)
$(OUTDIR)WindowingTransformation.$(O) WindowingTransformation.$(C) WindowingTransformation.$(H): WindowingTransformation.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplayTransform.$(H) $(INCLUDE_TOP)\stx\libview\ScaleTransform.$(H) $(STCHDR)
$(OUTDIR)XGraphicsContext.$(O) XGraphicsContext.$(C) XGraphicsContext.$(H): XGraphicsContext.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DeviceGraphicsContext.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsContext.$(H) $(STCHDR)
$(OUTDIR)FixedPaletteWithAlpha.$(O) FixedPaletteWithAlpha.$(C) FixedPaletteWithAlpha.$(H): FixedPaletteWithAlpha.st $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(INCLUDE_TOP)\stx\libview\ColorPalette.$(H) $(INCLUDE_TOP)\stx\libview\Colormap.$(H) $(INCLUDE_TOP)\stx\libview\FixedPalette.$(H) $(STCHDR)
$(OUTDIR)MonoMappedPalette.$(O) MonoMappedPalette.$(C) MonoMappedPalette.$(H): MonoMappedPalette.st $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(INCLUDE_TOP)\stx\libview\ColorPalette.$(H) $(INCLUDE_TOP)\stx\libview\Colormap.$(H) $(INCLUDE_TOP)\stx\libview\MappedPalette.$(H) $(STCHDR)
$(OUTDIR)ShadowView.$(O) ShadowView.$(C) ShadowView.$(H): ShadowView.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(STCHDR)
$(OUTDIR)View.$(O) View.$(C) View.$(H): View.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(STCHDR)
$(OUTDIR)TopView.$(O) TopView.$(C) TopView.$(H): TopView.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(STCHDR)
$(OUTDIR)PopUpView.$(O) PopUpView.$(C) PopUpView.$(H): PopUpView.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\TopView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(STCHDR)
$(OUTDIR)StandardSystemView.$(O) StandardSystemView.$(C) StandardSystemView.$(H): StandardSystemView.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\TopView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(STCHDR)
$(OUTDIR)ModalBox.$(O) ModalBox.$(C) ModalBox.$(H): ModalBox.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\StandardSystemView.$(H) $(INCLUDE_TOP)\stx\libview\TopView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(STCHDR)
$(OUTDIR)WinWorkstation.$(O) WinWorkstation.$(C) WinWorkstation.$(H): WinWorkstation.st $(STCHDR)
$(OUTDIR)extensions.$(O): extensions.st $(INCLUDE_TOP)\stx\libbasic\ConfigurableFeatures.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)

# ENDMAKEDEPEND --- do not remove this line

# **Must be at end**

# Enforce recompilation of package definition class if Mercurial working
# copy state changes. Together with --guessVersion it ensures that package
# definition class always contains correct binary revision string.
!IFDEF HGROOT
$(OUTDIR)stx_libview.$(O): $(HGROOT)\.hg\dirstate
!ENDIF
