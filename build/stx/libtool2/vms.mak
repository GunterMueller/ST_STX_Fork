#
# DO NOT EDIT 
# automatically generated from Make.proto
#
# $Header$
#
TOP=..
LIBNAME=libtool2
STCOPT="+optspace3 -warnNonStandard"
STCLOCALOPT=-package=stx:$(LIBNAME) $(COMMONSYMBOLS) $(SEPINITCODE) $(RELOCINSTVARS) -varPrefix=$(LIBNAME)
ALL: $(LIBDIR)\$(LIBNAME).olb

OBJS=\
  $(OUTDIR)ColorMenu.$(O) \
  $(OUTDIR)FontMenu.$(O) \
  $(OUTDIR)MenuEditor.$(O) \
  $(OUTDIR)ImageEditor.$(O) \
  $(OUTDIR)DataSetBuilder.$(O) \
  $(OUTDIR)UIGalleryView.$(O) \
  $(OUTDIR)UIHelpTool.$(O) \
  $(OUTDIR)UILayoutTool.$(O) \
  $(OUTDIR)UIObjectView.$(O) \
  $(OUTDIR)UIPainter.$(O) \
  $(OUTDIR)UIPainterView.$(O) \
  $(OUTDIR)UISelectionPanel.$(O) \
  $(OUTDIR)UISpecificationTool.$(O) \
  $(OUTDIR)SelectionBrowser.$(O) \
  $(OUTDIR)FileSelectionBrowser.$(O) \
  $(OUTDIR)ResourceSelectionBrowser.$(O) \


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
$(OUTDIR)ColorMenu.$(O) ColorMenu.$(H): ColorMenu.st $(STCHDR)  ../include/MenuPanel.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H)  ../include/SimpleDialog.$(H)  ../include/ApplicationModel.$(H)  ../include/Model.$(H) 
$(OUTDIR)DataSetBuilder.$(O) DataSetBuilder.$(H): DataSetBuilder.st $(STCHDR)  ../include/ResourceSpecEditor.$(H)  ../include/ToolApplicationModel.$(H)  ../include/ApplicationModel.$(H)  ../include/Model.$(H)  ../include/Object.$(H)  ../include/Array.$(H)  ../include/ArrayedCollection.$(H)  ../include/SequenceableCollection.$(H)  ../include/Collection.$(H) 
$(OUTDIR)DirectoryView.$(O) DirectoryView.$(H): DirectoryView.st $(STCHDR)  ../include/ApplicationModel.$(H)  ../include/Model.$(H)  ../include/Object.$(H) 
$(OUTDIR)FileSelectionBrowser.$(O) FileSelectionBrowser.$(H): FileSelectionBrowser.st $(STCHDR)  ../include/SelectionBrowser.$(H)  ../include/SimpleDialog.$(H)  ../include/ApplicationModel.$(H)  ../include/Model.$(H)  ../include/Object.$(H) 
$(OUTDIR)FontMenu.$(O) FontMenu.$(H): FontMenu.st $(STCHDR)  ../include/MenuPanel.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)HierarchicalListEditor.$(O) HierarchicalListEditor.$(H): HierarchicalListEditor.st $(STCHDR)  ../include/ResourceSpecEditor.$(H)  ../include/ToolApplicationModel.$(H)  ../include/ApplicationModel.$(H)  ../include/Model.$(H)  ../include/Object.$(H) 
$(OUTDIR)ImageEditor.$(O) ImageEditor.$(H): ImageEditor.st $(STCHDR)  ../include/ToolApplicationModel.$(H)  ../include/ApplicationModel.$(H)  ../include/Model.$(H)  ../include/Object.$(H) 
$(OUTDIR)MenuEditor.$(O) MenuEditor.$(H): MenuEditor.st $(STCHDR)  ../include/ResourceSpecEditor.$(H)  ../include/ToolApplicationModel.$(H)  ../include/ApplicationModel.$(H)  ../include/Model.$(H)  ../include/Object.$(H)  ../include/SelectionInTreeView.$(H)  ../include/SelectionInListView.$(H)  ../include/ListView.$(H)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H) 
$(OUTDIR)MethodSelectionBrowser.$(O) MethodSelectionBrowser.$(H): MethodSelectionBrowser.st $(STCHDR)  ../include/ResourceSelectionBrowser.$(H)  ../include/SelectionBrowser.$(H)  ../include/SimpleDialog.$(H)  ../include/ApplicationModel.$(H)  ../include/Model.$(H)  ../include/Object.$(H) 
$(OUTDIR)NewInspectorList.$(O) NewInspectorList.$(H): NewInspectorList.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)NewInspectorListView.$(O) NewInspectorListView.$(H): NewInspectorListView.st $(STCHDR)  ../include/SelectionInListView.$(H)  ../include/ListView.$(H)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)NewInspectorPanelView.$(O) NewInspectorPanelView.$(H): NewInspectorPanelView.st $(STCHDR)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)NewInspectorView.$(O) NewInspectorView.$(H): NewInspectorView.st $(STCHDR)  ../include/VariableVerticalPanel.$(H)  ../include/VariablePanel.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)ResourceSelectionBrowser.$(O) ResourceSelectionBrowser.$(H): ResourceSelectionBrowser.st $(STCHDR)  ../include/SelectionBrowser.$(H)  ../include/SimpleDialog.$(H)  ../include/ApplicationModel.$(H)  ../include/Model.$(H)  ../include/Object.$(H) 
$(OUTDIR)SelectionBrowser.$(O) SelectionBrowser.$(H): SelectionBrowser.st $(STCHDR)  ../include/SimpleDialog.$(H)  ../include/ApplicationModel.$(H)  ../include/Model.$(H)  ../include/Object.$(H) 
$(OUTDIR)ShellView.$(O) ShellView.$(H): ShellView.st $(STCHDR)  ../include/ApplicationModel.$(H)  ../include/Model.$(H)  ../include/Object.$(H) 
$(OUTDIR)TabListEditor.$(O) TabListEditor.$(H): TabListEditor.st $(STCHDR)  ../include/ResourceSpecEditor.$(H)  ../include/ToolApplicationModel.$(H)  ../include/ApplicationModel.$(H)  ../include/Model.$(H)  ../include/Object.$(H) 
$(OUTDIR)UIGalleryView.$(O) UIGalleryView.$(H): UIGalleryView.st $(STCHDR)  ../include/NoteBookView.$(H)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H)  ../include/DropObject.$(H) 
$(OUTDIR)UIHelpTool.$(O) UIHelpTool.$(H): UIHelpTool.st $(STCHDR)  ../include/ToolApplicationModel.$(H)  ../include/ApplicationModel.$(H)  ../include/Model.$(H)  ../include/Object.$(H) 
$(OUTDIR)UILayoutTool.$(O) UILayoutTool.$(H): UILayoutTool.st $(STCHDR)  ../include/ApplicationModel.$(H)  ../include/Model.$(H)  ../include/Object.$(H) 
$(OUTDIR)UIObjectView.$(O) UIObjectView.$(H): UIObjectView.st $(STCHDR)  ../include/ObjectView.$(H)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)UIPainter.$(O) UIPainter.$(H): UIPainter.st $(STCHDR)  ../include/ToolApplicationModel.$(H)  ../include/ApplicationModel.$(H)  ../include/Model.$(H)  ../include/Object.$(H)  ../include/SelectionInTreeView.$(H)  ../include/SelectionInListView.$(H)  ../include/ListView.$(H)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H) 
$(OUTDIR)UIPainterView.$(O) UIPainterView.$(H): UIPainterView.st $(STCHDR)  ../include/UIObjectView.$(H)  ../include/ObjectView.$(H)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)UISelectionPanel.$(O) UISelectionPanel.$(H): UISelectionPanel.st $(STCHDR)  ../include/ApplicationModel.$(H)  ../include/Model.$(H)  ../include/Object.$(H) 
$(OUTDIR)UISpecificationTool.$(O) UISpecificationTool.$(H): UISpecificationTool.st $(STCHDR)  ../include/ApplicationModel.$(H)  ../include/Model.$(H)  ../include/Object.$(H) 
# ENDMAKEDEPEND
