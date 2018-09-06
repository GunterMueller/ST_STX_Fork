# $Header$
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_libview2.
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


# see stdHeader_bc for LIBVIEW2_BASE
LIB_BASE=$(LIBVIEW2_BASE)


!INCLUDE $(TOP)\rules\stdHeader_bc

!INCLUDE Make.spec

LIBNAME=libstx_libview2
MODULE_PATH=libview2
RESFILES=stx_libview2WINrc.$(RES)


# LIBJPEG_DIR=$(TOP)\support\libjpeg-6a
LIBJPEG_DIR=$(TOP)\support\libjpeg-9

!if defined(USEMINGW32) || defined(USEMINGW64)
! if defined(USEMINGW32)
LIBJPEG_TARGET = i686-pc-mingw32
! else
LIBJPEG_TARGET = x86_64-w64-mingw32
! endif
LIBJPEG=$(LIBJPEG_DIR)\$(LIBJPEG_TARGET)\.libs\libjpeg.a
CLOCAL_INCL=-I"$(LIBJPEG_DIR)" -I"$(LIBJPEG_DIR)\$(LIBJPEG_TARGET)"
!else
LIBJPEG=$(LIBJPEG_DIR)\$(OBJDIR)\libjpeg.lib
CLOCAL_INCL=-I"$(LIBJPEG_DIR)"
!endif




LOCALINCLUDES=-I$(LIBJPEG_DIR)\$(LIBJPEG_TARGET) -I$(LIBJPEG_DIR) -I$(INCLUDE_TOP)\stx\libbasic -I$(INCLUDE_TOP)\stx\libbasic2 -I$(INCLUDE_TOP)\stx\libui -I$(INCLUDE_TOP)\stx\libview
LOCALDEFINES=

STCLOCALOPT=-package=$(PACKAGE) -I. $(LOCALINCLUDES) -headerDir=. $(STCLOCALOPTIMIZATIONS) $(STCWARNINGS) $(LOCALDEFINES) $(COMMONSYMBOLS) -varPrefix=$(LIBNAME)
LOCALLIBS=$(LIBJPEG)

OBJS= $(COMMON_OBJS) $(WIN32_OBJS)

ALL:: $(LIBJPEG) classLibRule

classLibRule: $(OUTDIR) $(OUTDIR)$(LIBNAME).dll

!INCLUDE $(TOP)\rules\stdRules_bc

# build all mandatory prerequisite packages (containing superclasses) for this package
prereq:
	pushd ..\libbasic & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\libbasic2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\libview & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "




!if defined(USEMINGW32) || defined(USEMINGW64)
$(LIBJPEG): $(LIBJPEG_DIR)/$(LIBJPEG_TARGET)/config.status
    pushd $(LIBJPEG_DIR)\$(LIBJPEG_TARGET) & set "PATH=C:\MSYS64\usr\bin;C:\MINGW\MSYS\1.0\bin;C:\MSYS\1.0\bin;%%PATH%%" & make

$(LIBJPEG_DIR)/$(LIBJPEG_TARGET)/config.status:
    -md $(LIBJPEG_DIR)\$(LIBJPEG_TARGET)
    pushd $(LIBJPEG_DIR)\$(LIBJPEG_TARGET) & set "PATH=C:\MSYS64\usr\bin;C:\MINGW\MSYS\1.0\bin;C:\MSYS\1.0\bin;%%PATH%%" & bash ../configure --build=$(LIBJPEG_TARGET)

clobber::
    -rd /S /Q $(LIBJPEG_DIR)\$(LIBJPEG_TARGET)

clean::
    -pushd $(LIBJPEG_DIR) & set "PATH=C:\MSYS64\usr\bin;C:\MINGW\MSYS\1.0\bin;C:\MSYS\1.0\bin;%%PATH%%" & IF EXIST makefile (make clean)

$(OUTDIR)JPEGReader.$(O):: $(LIBJPEG_DIR)\$(LIBJPEG_TARGET)\jconfig.h
$(LIBJPEG_DIR)\$(LIBJPEG_TARGET)\jconfig.h: $(LIBJPEG)

!else
$(LIBJPEG):
    cd $(LIBJPEG_DIR)
    $(MAKE_BAT)
    cd ..\..\libview2
$(OUTDIR)JPEGReader.$(O):: $(LIBJPEG_DIR)\jconfig.h
$(LIBJPEG_DIR)\jconfig.h: $(LIBJPEG)
!endif






test: $(TOP)\goodies\builder\reports\NUL
	pushd $(TOP)\goodies\builder\reports & $(MAKE_BAT)
	$(TOP)\goodies\builder\reports\report-runner.bat -D . -r Builder::TestReport -p $(PACKAGE)
        
clean::
	-del *.$(CSUFFIX)


# BEGINMAKEDEPEND --- do not remove this line; make depend needs it
$(OUTDIR)ActiveHelpView.$(O) ActiveHelpView.$(C) ActiveHelpView.$(H): ActiveHelpView.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(STCHDR)
$(OUTDIR)ApplicationSubView.$(O) ApplicationSubView.$(C) ApplicationSubView.$(H): ApplicationSubView.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(STCHDR)
$(OUTDIR)ApplicationWindow.$(O) ApplicationWindow.$(C) ApplicationWindow.$(H): ApplicationWindow.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\StandardSystemView.$(H) $(INCLUDE_TOP)\stx\libview\TopView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(STCHDR)
$(OUTDIR)ColorValue.$(O) ColorValue.$(C) ColorValue.$(H): ColorValue.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\Color.$(H) $(STCHDR)
$(OUTDIR)DisplayObject.$(O) DisplayObject.$(C) DisplayObject.$(H): DisplayObject.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DragAndDropManager.$(O) DragAndDropManager.$(C) DragAndDropManager.$(H): DragAndDropManager.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DragHandler.$(O) DragHandler.$(C) DragHandler.$(H): DragHandler.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DrawAdaptor.$(O) DrawAdaptor.$(C) DrawAdaptor.$(H): DrawAdaptor.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DropContext.$(O) DropContext.$(C) DropContext.$(H): DropContext.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DropObject.$(O) DropObject.$(C) DropObject.$(H): DropObject.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DropSource.$(O) DropSource.$(C) DropSource.$(H): DropSource.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DropTarget.$(O) DropTarget.$(C) DropTarget.$(H): DropTarget.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)EventListener.$(O) EventListener.$(C) EventListener.$(H): EventListener.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)ExternalTopView.$(O) ExternalTopView.$(C) ExternalTopView.$(H): ExternalTopView.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\TopView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(STCHDR)
$(OUTDIR)GIFReader.$(O) GIFReader.$(C) GIFReader.$(H): GIFReader.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\ImageReader.$(H) $(STCHDR)
$(OUTDIR)Icon.$(O) Icon.$(C) Icon.$(H): Icon.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)ImageFrame.$(O) ImageFrame.$(C) ImageFrame.$(H): ImageFrame.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)ImageSequence.$(O) ImageSequence.$(C) ImageSequence.$(H): ImageSequence.st $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\OrderedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(STCHDR)
$(OUTDIR)InputView.$(O) InputView.$(C) InputView.$(H): InputView.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(STCHDR)
$(OUTDIR)JPEGReader.$(O) JPEGReader.$(C) JPEGReader.$(H): JPEGReader.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\ImageReader.$(H) $(STCHDR)
$(OUTDIR)KeyboardProcessor.$(O) KeyboardProcessor.$(C) KeyboardProcessor.$(H): KeyboardProcessor.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Layout.$(O) Layout.$(C) Layout.$(H): Layout.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MIMETypeIconLibrary.$(O) MIMETypeIconLibrary.$(C) MIMETypeIconLibrary.$(H): MIMETypeIconLibrary.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MIMETypes.$(O) MIMETypes.$(C) MIMETypes.$(H): MIMETypes.st $(INCLUDE_TOP)\stx\libbasic\ArrayedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\CharacterArray.$(H) $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\ImmutableString.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\String.$(H) $(INCLUDE_TOP)\stx\libbasic\UninterpretedBytes.$(H) $(STCHDR)
$(OUTDIR)MacOSXIconReader.$(O) MacOSXIconReader.$(C) MacOSXIconReader.$(H): MacOSXIconReader.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\ImageReader.$(H) $(STCHDR)
$(OUTDIR)MenuItem.$(O) MenuItem.$(C) MenuItem.$(H): MenuItem.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Model.$(O) Model.$(C) Model.$(H): Model.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MultiImage.$(O) MultiImage.$(C) MultiImage.$(H): MultiImage.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PNGReader.$(O) PNGReader.$(C) PNGReader.$(H): PNGReader.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\ImageReader.$(H) $(STCHDR)
$(OUTDIR)PopUpBanner.$(O) PopUpBanner.$(C) PopUpBanner.$(H): PopUpBanner.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\PopUpView.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\TopView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(STCHDR)
$(OUTDIR)PrintConverter.$(O) PrintConverter.$(C) PrintConverter.$(H): PrintConverter.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PrinterContext.$(O) PrinterContext.$(C) PrinterContext.$(H): PrinterContext.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DeviceGraphicsContext.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsContext.$(H) $(STCHDR)
$(OUTDIR)PropertyListDictionary.$(O) PropertyListDictionary.$(C) PropertyListDictionary.$(H): PropertyListDictionary.st $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Dictionary.$(H) $(INCLUDE_TOP)\stx\libbasic\IdentityDictionary.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\Set.$(H) $(STCHDR)
$(OUTDIR)ResourceRetriever.$(O) ResourceRetriever.$(C) ResourceRetriever.$(H): ResourceRetriever.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)StandardSystemController.$(O) StandardSystemController.$(C) StandardSystemController.$(H): StandardSystemController.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\Controller.$(H) $(STCHDR)
$(OUTDIR)TIFFReader.$(O) TIFFReader.$(C) TIFFReader.$(H): TIFFReader.st $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Dictionary.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\Set.$(H) $(INCLUDE_TOP)\stx\libview\ImageReader.$(H) $(STCHDR)
$(OUTDIR)TransparentBox.$(O) TransparentBox.$(C) TransparentBox.$(H): TransparentBox.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(STCHDR)
$(OUTDIR)VisualRegion.$(O) VisualRegion.$(C) VisualRegion.$(H): VisualRegion.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(STCHDR)
$(OUTDIR)WindowBuilder.$(O) WindowBuilder.$(C) WindowBuilder.$(H): WindowBuilder.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)WindowsIconReader.$(O) WindowsIconReader.$(C) WindowsIconReader.$(H): WindowsIconReader.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\ImageReader.$(H) $(STCHDR)
$(OUTDIR)XBMReader.$(O) XBMReader.$(C) XBMReader.$(H): XBMReader.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\ImageReader.$(H) $(STCHDR)
$(OUTDIR)XPMReader.$(O) XPMReader.$(C) XPMReader.$(H): XPMReader.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\ImageReader.$(H) $(STCHDR)
$(OUTDIR)stx_libview2.$(O) stx_libview2.$(C) stx_libview2.$(H): stx_libview2.st $(INCLUDE_TOP)\stx\libbasic\LibraryDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\ProjectDefinition.$(H) $(STCHDR)
$(OUTDIR)ActiveHelp.$(O) ActiveHelp.$(C) ActiveHelp.$(H): ActiveHelp.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\EventListener.$(H) $(STCHDR)
$(OUTDIR)ApplicationModel.$(O) ApplicationModel.$(C) ApplicationModel.$(H): ApplicationModel.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(STCHDR)
$(OUTDIR)LayoutOrigin.$(O) LayoutOrigin.$(C) LayoutOrigin.$(H): LayoutOrigin.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\Layout.$(H) $(STCHDR)
$(OUTDIR)Menu.$(O) Menu.$(C) Menu.$(H): Menu.st $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Notification.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\Query.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(STCHDR)
$(OUTDIR)Plug.$(O) Plug.$(C) Plug.$(H): Plug.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(STCHDR)
$(OUTDIR)PluggableEventListener.$(O) PluggableEventListener.$(C) PluggableEventListener.$(H): PluggableEventListener.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\EventListener.$(H) $(STCHDR)
$(OUTDIR)ScreenLock.$(O) ScreenLock.$(C) ScreenLock.$(H): ScreenLock.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\EventListener.$(H) $(STCHDR)
$(OUTDIR)UIBuilder.$(O) UIBuilder.$(C) UIBuilder.$(H): UIBuilder.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\WindowBuilder.$(H) $(STCHDR)
$(OUTDIR)ValueModel.$(O) ValueModel.$(C) ValueModel.$(H): ValueModel.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(STCHDR)
$(OUTDIR)VisualComponent.$(O) VisualComponent.$(C) VisualComponent.$(H): VisualComponent.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\DisplayObject.$(H) $(STCHDR)
$(OUTDIR)AlignmentOrigin.$(O) AlignmentOrigin.$(C) AlignmentOrigin.$(H): AlignmentOrigin.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\Layout.$(H) $(INCLUDE_TOP)\stx\libview2\LayoutOrigin.$(H) $(STCHDR)
$(OUTDIR)ApplicationWithFileHistory.$(O) ApplicationWithFileHistory.$(C) ApplicationWithFileHistory.$(H): ApplicationWithFileHistory.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(STCHDR)
$(OUTDIR)BlockValue.$(O) BlockValue.$(C) BlockValue.$(H): BlockValue.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(INCLUDE_TOP)\stx\libview2\ValueModel.$(H) $(STCHDR)
$(OUTDIR)FlyByHelp.$(O) FlyByHelp.$(C) FlyByHelp.$(H): FlyByHelp.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\ActiveHelp.$(H) $(INCLUDE_TOP)\stx\libview2\EventListener.$(H) $(STCHDR)
$(OUTDIR)IndirectValue.$(O) IndirectValue.$(C) IndirectValue.$(H): IndirectValue.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(INCLUDE_TOP)\stx\libview2\ValueModel.$(H) $(STCHDR)
$(OUTDIR)LayoutFrame.$(O) LayoutFrame.$(C) LayoutFrame.$(H): LayoutFrame.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\Layout.$(H) $(INCLUDE_TOP)\stx\libview2\LayoutOrigin.$(H) $(STCHDR)
$(OUTDIR)PluggableAdaptor.$(O) PluggableAdaptor.$(C) PluggableAdaptor.$(H): PluggableAdaptor.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(INCLUDE_TOP)\stx\libview2\ValueModel.$(H) $(STCHDR)
$(OUTDIR)ProtocolAdaptor.$(O) ProtocolAdaptor.$(C) ProtocolAdaptor.$(H): ProtocolAdaptor.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(INCLUDE_TOP)\stx\libview2\ValueModel.$(H) $(STCHDR)
$(OUTDIR)SimpleDialog.$(O) SimpleDialog.$(C) SimpleDialog.$(H): SimpleDialog.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(STCHDR)
$(OUTDIR)ToolApplicationModel.$(O) ToolApplicationModel.$(C) ToolApplicationModel.$(H): ToolApplicationModel.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(STCHDR)
$(OUTDIR)ValueHolder.$(O) ValueHolder.$(C) ValueHolder.$(H): ValueHolder.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(INCLUDE_TOP)\stx\libview2\ValueModel.$(H) $(STCHDR)
$(OUTDIR)VisualPart.$(O) VisualPart.$(C) VisualPart.$(H): VisualPart.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\DisplayObject.$(H) $(INCLUDE_TOP)\stx\libview2\VisualComponent.$(H) $(STCHDR)
$(OUTDIR)AspectAdaptor.$(O) AspectAdaptor.$(C) AspectAdaptor.$(H): AspectAdaptor.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(INCLUDE_TOP)\stx\libview2\ProtocolAdaptor.$(H) $(INCLUDE_TOP)\stx\libview2\ValueModel.$(H) $(STCHDR)
$(OUTDIR)BooleanBlockValue.$(O) BooleanBlockValue.$(C) BooleanBlockValue.$(H): BooleanBlockValue.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\BlockValue.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(INCLUDE_TOP)\stx\libview2\ValueModel.$(H) $(STCHDR)
$(OUTDIR)BooleanValueHolder.$(O) BooleanValueHolder.$(C) BooleanValueHolder.$(H): BooleanValueHolder.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(INCLUDE_TOP)\stx\libview2\ValueHolder.$(H) $(INCLUDE_TOP)\stx\libview2\ValueModel.$(H) $(STCHDR)
$(OUTDIR)BufferedValueHolder.$(O) BufferedValueHolder.$(C) BufferedValueHolder.$(H): BufferedValueHolder.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(INCLUDE_TOP)\stx\libview2\ValueHolder.$(H) $(INCLUDE_TOP)\stx\libview2\ValueModel.$(H) $(STCHDR)
$(OUTDIR)DictionaryAdaptor.$(O) DictionaryAdaptor.$(C) DictionaryAdaptor.$(H): DictionaryAdaptor.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(INCLUDE_TOP)\stx\libview2\ProtocolAdaptor.$(H) $(INCLUDE_TOP)\stx\libview2\ValueModel.$(H) $(STCHDR)
$(OUTDIR)RangeAdaptor.$(O) RangeAdaptor.$(C) RangeAdaptor.$(H): RangeAdaptor.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(INCLUDE_TOP)\stx\libview2\ValueHolder.$(H) $(INCLUDE_TOP)\stx\libview2\ValueModel.$(H) $(STCHDR)
$(OUTDIR)ResourceSpecEditor.$(O) ResourceSpecEditor.$(C) ResourceSpecEditor.$(H): ResourceSpecEditor.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(INCLUDE_TOP)\stx\libview2\ToolApplicationModel.$(H) $(STCHDR)
$(OUTDIR)TriggerValue.$(O) TriggerValue.$(C) TriggerValue.$(H): TriggerValue.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(INCLUDE_TOP)\stx\libview2\ValueHolder.$(H) $(INCLUDE_TOP)\stx\libview2\ValueModel.$(H) $(STCHDR)
$(OUTDIR)TypeConverter.$(O) TypeConverter.$(C) TypeConverter.$(H): TypeConverter.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(INCLUDE_TOP)\stx\libview2\PluggableAdaptor.$(H) $(INCLUDE_TOP)\stx\libview2\ValueModel.$(H) $(STCHDR)
$(OUTDIR)ValueHolderWithRememberedPreviousValue.$(O) ValueHolderWithRememberedPreviousValue.$(C) ValueHolderWithRememberedPreviousValue.$(H): ValueHolderWithRememberedPreviousValue.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(INCLUDE_TOP)\stx\libview2\ValueHolder.$(H) $(INCLUDE_TOP)\stx\libview2\ValueModel.$(H) $(STCHDR)
$(OUTDIR)ValueHolderWithWeakDependents.$(O) ValueHolderWithWeakDependents.$(C) ValueHolderWithWeakDependents.$(H): ValueHolderWithWeakDependents.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(INCLUDE_TOP)\stx\libview2\ValueHolder.$(H) $(INCLUDE_TOP)\stx\libview2\ValueModel.$(H) $(STCHDR)
$(OUTDIR)AspectAdaptorWithDefault.$(O) AspectAdaptorWithDefault.$(C) AspectAdaptorWithDefault.$(H): AspectAdaptorWithDefault.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\AspectAdaptor.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(INCLUDE_TOP)\stx\libview2\ProtocolAdaptor.$(H) $(INCLUDE_TOP)\stx\libview2\ValueModel.$(H) $(STCHDR)
$(OUTDIR)WinPrinterStream.$(O) WinPrinterStream.$(C) WinPrinterStream.$(H): WinPrinterStream.st $(STCHDR)
$(OUTDIR)WinPrinterContext.$(O) WinPrinterContext.$(C) WinPrinterContext.$(H): WinPrinterContext.st $(STCHDR)
$(OUTDIR)extensions.$(O): extensions.st $(INCLUDE_TOP)\stx\libbasic\ArrayedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\CharacterArray.$(H) $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\UninterpretedBytes.$(H) $(STCHDR)

# ENDMAKEDEPEND --- do not remove this line

# **Must be at end**

# Enforce recompilation of package definition class if Mercurial working
# copy state changes. Together with --guessVersion it ensures that package
# definition class always contains correct binary revision string.
!IFDEF HGROOT
$(OUTDIR)stx_libview2.$(O): $(HGROOT)\.hg\dirstate
!ENDIF
