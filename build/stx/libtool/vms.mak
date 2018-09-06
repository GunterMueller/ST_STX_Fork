#
# DO NOT EDIT 
# automatically generated from Make.proto
#
# $Header: /cvs/stx/stx/libtool/vms.mak,v 1.3 1999/09/18 14:34:21 cg Exp $
#
TOP=..
LIBNAME=libtool
STCOPT="+optspace2 -warnNonStandard"
STCLOCALOPT=-package=stx:$(LIBNAME) $(COMMONSYMBOLS) $(SEPINITCODE) $(RELOCINSTVARS) -varPrefix=$(LIBNAME)
ALL: $(LIBDIR)\$(LIBNAME).olb

OBJS=\
  $(OUTDIR)SystemBrowser.$(O) \
  $(OUTDIR)BrowserView.$(O) \
  $(OUTDIR)ChangesBrowser.$(O) \
  $(OUTDIR)DebugView.$(O) \
  $(OUTDIR)AbstractLauncherApplication.$(O) \
  $(OUTDIR)NewLauncher.$(O) \
  $(OUTDIR)InspectorView.$(O) \
  $(OUTDIR)SetInspectorView.$(O) \
  $(OUTDIR)DictionaryInspectorView.$(O) \
  $(OUTDIR)ContextInspectorView.$(O) \
  $(OUTDIR)OrderedCollectionInspectorView.$(O) \
  $(OUTDIR)AboutBox.$(O) \
  $(OUTDIR)FileBrowser.$(O) \


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
$(OUTDIR)AboutBox.$(O) AboutBox.$(H): AboutBox.st $(STCHDR)  ../include/InfoBox.$(H)  ../include/DialogBox.$(H)  ../include/ModalBox.$(H)  ../include/StandardSystemView.$(H)  ../include/TopView.$(H)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)AbstractLauncherApplication.$(O) AbstractLauncherApplication.$(H): AbstractLauncherApplication.st $(STCHDR)  ../include/ToolApplicationModel.$(H)  ../include/ApplicationModel.$(H)  ../include/Model.$(H)  ../include/Object.$(H) 
$(OUTDIR)ApplicationBuilder.$(O) ApplicationBuilder.$(H): ApplicationBuilder.st $(STCHDR)  ../include/ToolApplicationModel.$(H)  ../include/ApplicationModel.$(H)  ../include/Model.$(H)  ../include/Object.$(H) 
$(OUTDIR)BrowserView.$(O) BrowserView.$(H): BrowserView.st $(STCHDR)  ../include/StandardSystemView.$(H)  ../include/TopView.$(H)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)ChangeSetBrowser.$(O) ChangeSetBrowser.$(H): ChangeSetBrowser.st $(STCHDR)  ../include/ChangesBrowser.$(H)  ../include/StandardSystemView.$(H)  ../include/TopView.$(H)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)ChangesBrowser.$(O) ChangesBrowser.$(H): ChangesBrowser.st $(STCHDR)  ../include/StandardSystemView.$(H)  ../include/TopView.$(H)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)ClassInspectorView.$(O) ClassInspectorView.$(H): ClassInspectorView.st $(STCHDR)  ../include/InspectorView.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)ColorInspectorView.$(O) ColorInspectorView.$(H): ColorInspectorView.st $(STCHDR)  ../include/InspectorView.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)ContextInspectorView.$(O) ContextInspectorView.$(H): ContextInspectorView.st $(STCHDR)  ../include/InspectorView.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)DebugView.$(O) DebugView.$(H): DebugView.st $(STCHDR)  ../include/StandardSystemView.$(H)  ../include/TopView.$(H)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)DictionaryInspectorView.$(O) DictionaryInspectorView.$(H): DictionaryInspectorView.st $(STCHDR)  ../include/InspectorView.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)Diff3TxtV.$(O) Diff3TxtV.$(H): Diff3TxtV.st $(STCHDR) 
$(OUTDIR)DiffTextView.$(O) DiffTextView.$(H): DiffTextView.st $(STCHDR) 
$(OUTDIR)DirectoryBrowser.$(O) DirectoryBrowser.$(H): DirectoryBrowser.st $(STCHDR)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)EventMonitor.$(O) EventMonitor.$(H): EventMonitor.st $(STCHDR)  ../include/StandardSystemView.$(H)  ../include/TopView.$(H)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)FileBrowser.$(O) FileBrowser.$(H): FileBrowser.st $(STCHDR)  ../include/StandardSystemView.$(H)  ../include/TopView.$(H)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)ImageInspectorView.$(O) ImageInspectorView.$(H): ImageInspectorView.st $(STCHDR)  ../include/InspectorView.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)InspectorView.$(O) InspectorView.$(H): InspectorView.st $(STCHDR)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)Launcher.$(O) Launcher.$(H): Launcher.st $(STCHDR)  ../include/AbstractLauncherApplication.$(H)  ../include/ToolApplicationModel.$(H)  ../include/ApplicationModel.$(H)  ../include/Model.$(H)  ../include/Object.$(H) 
$(OUTDIR)LibraryBuilder.$(O) LibraryBuilder.$(H): LibraryBuilder.st $(STCHDR) 
$(OUTDIR)MemoryMonitor.$(O) MemoryMonitor.$(H): MemoryMonitor.st $(STCHDR)  ../include/ApplicationModel.$(H)  ../include/Model.$(H)  ../include/Object.$(H) 
$(OUTDIR)MemoryMonitorView.$(O) MemoryMonitorView.$(H): MemoryMonitorView.st $(STCHDR)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)MemoryUsageView.$(O) MemoryUsageView.$(H): MemoryUsageView.st $(STCHDR)  ../include/StandardSystemView.$(H)  ../include/TopView.$(H)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)NewChangesBrowser.$(O) NewChangesBrowser.$(H): NewChangesBrowser.st $(STCHDR)  ../include/ToolApplicationModel.$(H)  ../include/ApplicationModel.$(H)  ../include/Model.$(H)  ../include/Object.$(H) 
$(OUTDIR)NewLauncher.$(O) NewLauncher.$(H): NewLauncher.st $(STCHDR)  ../include/AbstractLauncherApplication.$(H)  ../include/ToolApplicationModel.$(H)  ../include/ApplicationModel.$(H)  ../include/Model.$(H)  ../include/Object.$(H) 
$(OUTDIR)OldLauncher.$(O) OldLauncher.$(H): OldLauncher.st $(STCHDR)  ../include/StandardSystemView.$(H)  ../include/TopView.$(H)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)OrderedCollectionInspectorView.$(O) OrderedCollectionInspectorView.$(H): OrderedCollectionInspectorView.st $(STCHDR)  ../include/InspectorView.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)ProcessMonitor.$(O) ProcessMonitor.$(H): ProcessMonitor.st $(STCHDR)  SystemStatusMonitor.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)ProjectView.$(O) ProjectView.$(H): ProjectView.st $(STCHDR)  ../include/StandardSystemView.$(H)  ../include/TopView.$(H)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)RCSConflictEditTextView.$(O) RCSConflictEditTextView.$(H): RCSConflictEditTextView.st $(STCHDR)  ../include/EditTextView.$(H)  ../include/TextView.$(H)  ../include/ListView.$(H)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)SemaphoreMonitor.$(O) SemaphoreMonitor.$(H): SemaphoreMonitor.st $(STCHDR)  SystemStatusMonitor.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)SetInspectorView.$(O) SetInspectorView.$(H): SetInspectorView.st $(STCHDR)  ../include/InspectorView.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)SystemBrowser.$(O) SystemBrowser.$(H): SystemBrowser.st $(STCHDR)  ../include/ApplicationModel.$(H)  ../include/Model.$(H)  ../include/Object.$(H) 
$(OUTDIR)SystemStatusMonitor.$(O) SystemStatusMonitor.$(H): SystemStatusMonitor.st $(STCHDR)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)VersionDiffBrowser.$(O) VersionDiffBrowser.$(H): VersionDiffBrowser.st $(STCHDR)  ../include/ApplicationModel.$(H)  ../include/Model.$(H)  ../include/Object.$(H) 
# ENDMAKEDEPEND
