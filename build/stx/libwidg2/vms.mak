#
# DO NOT EDIT 
# automatically generated from Make.proto
#
# $Header: /cvs/stx/stx/libwidg2/vms.mak,v 1.5 1999-09-18 14:16:45 cg Exp $
#
TOP=..
LIBNAME=libwidg2
STCOPT="+optspace2 -warnNonStandard"
STCLOCALOPT=-package=stx:$(LIBNAME) $(COMMONSYMBOLS) $(SEPINITCODE) $(RELOCINSTVARS) -varPrefix=$(LIBNAME)
ALL: $(LIBDIR)\$(LIBNAME).olb

OBJS=\
  $(OUTDIR)LicenceBox.$(O) \
  $(OUTDIR)SubCanvas.$(O) \
  $(OUTDIR)Slider.$(O) \
  $(OUTDIR)HorizontalSlider.$(O) \
  $(OUTDIR)LabelledEnterField.$(O) \
  $(OUTDIR)FilenameEnterBox.$(O) \
  $(OUTDIR)FilenameEditField.$(O) \
  $(OUTDIR)CheckBox.$(O) \
  $(OUTDIR)Separator.$(O) \
  $(OUTDIR)TabulatorSpecification.$(O) \
  $(OUTDIR)TabSpecRuler.$(O) \
  $(OUTDIR)ListEntry.$(O) \
  $(OUTDIR)MultiColListEntry.$(O) \
  $(OUTDIR)LabelAndIcon.$(O) \
  $(OUTDIR)ComboView.$(O) \
  $(OUTDIR)ComboBoxView.$(O) \
  $(OUTDIR)ComboListView.$(O) \
  $(OUTDIR)ComboBoxButton.$(O) \
  $(OUTDIR)MenuPanel.$(O) \
  $(OUTDIR)SelectionInTreeView.$(O) \
  $(OUTDIR)SelectionInTree.$(O) \
  $(OUTDIR)TreeItem.$(O) \
  $(OUTDIR)TreeItemWithImage.$(O) \
  $(OUTDIR)HierarchyNode.$(O) \
  $(OUTDIR)SelectionInHierarchy.$(O) \
  $(OUTDIR)NoteBookView.$(O) \
  $(OUTDIR)TabView.$(O) \
  $(OUTDIR)TabWidget.$(O) \
  $(OUTDIR)DataSetView.$(O) \
  $(OUTDIR)DataSetColumn.$(O) \
  $(OUTDIR)DataSetLabel.$(O) \
  $(OUTDIR)DSVLabelView.$(O) \
  $(OUTDIR)DSVColumnView.$(O) \
  $(OUTDIR)GridBagConstraints.$(O) \
  $(OUTDIR)GridBagLayoutInfo.$(O) \
  $(OUTDIR)GridBagLayoutView.$(O) \
  $(OUTDIR)UpDownButton.$(O) \
  $(OUTDIR)ViewScroller.$(O) \
  $(OUTDIR)FileSelectionTree.$(O) \
  $(OUTDIR)FileSelectionItem.$(O) \
  $(OUTDIR)EnterBoxWithList.$(O) \


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
$(OUTDIR)CheckBox.$(O) CheckBox.$(H): CheckBox.st $(STCHDR)  ../include/HorizontalPanelView.$(H)  ../include/PanelView.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)ColoredListEntry.$(O) ColoredListEntry.$(H): ColoredListEntry.st $(STCHDR)  ../include/ListEntry.$(H)  ../include/Object.$(H) 
$(OUTDIR)ComboBoxButton.$(O) ComboBoxButton.$(H): ComboBoxButton.st $(STCHDR)  ../include/Toggle.$(H)  ../include/Button.$(H)  ../include/Label.$(H)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)ComboBoxView.$(O) ComboBoxView.$(H): ComboBoxView.st $(STCHDR)  ../include/ComboView.$(H)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)ComboBrowseView.$(O) ComboBrowseView.$(H): ComboBrowseView.st $(STCHDR)  ../include/ComboBoxView.$(H)  ../include/ComboView.$(H)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)ComboListView.$(O) ComboListView.$(H): ComboListView.st $(STCHDR)  ../include/ComboView.$(H)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)ComboUpDownView.$(O) ComboUpDownView.$(H): ComboUpDownView.st $(STCHDR)  ../include/ComboBoxView.$(H)  ../include/ComboView.$(H)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)ComboView.$(O) ComboView.$(H): ComboView.st $(STCHDR)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)DSVColumnView.$(O) DSVColumnView.$(H): DSVColumnView.st $(STCHDR)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)DSVLabelView.$(O) DSVLabelView.$(H): DSVLabelView.st $(STCHDR)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)DataSetColumn.$(O) DataSetColumn.$(H): DataSetColumn.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)DataSetLabel.$(O) DataSetLabel.$(H): DataSetLabel.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)DataSetView.$(O) DataSetView.$(H): DataSetView.st $(STCHDR)  ../include/ScrollableView.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)EnterBoxWithList.$(O) EnterBoxWithList.$(H): EnterBoxWithList.st $(STCHDR)  ../include/EnterBox.$(H)  ../include/DialogBox.$(H)  ../include/ModalBox.$(H)  ../include/StandardSystemView.$(H)  ../include/TopView.$(H)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)ExtendedComboBox.$(O) ExtendedComboBox.$(H): ExtendedComboBox.st $(STCHDR)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H)  ../include/PopUpView.$(H)  ../include/TopView.$(H) 
$(OUTDIR)FileSelectionItem.$(O) FileSelectionItem.$(H): FileSelectionItem.st $(STCHDR)  ../include/TreeItem.$(H)  ../include/Object.$(H) 
$(OUTDIR)FileSelectionTree.$(O) FileSelectionTree.$(H): FileSelectionTree.st $(STCHDR)  ../include/SelectionInTreeView.$(H)  ../include/SelectionInListView.$(H)  ../include/ListView.$(H)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)FilenameEditField.$(O) FilenameEditField.$(H): FilenameEditField.st $(STCHDR)  ../include/EditField.$(H)  ../include/EditTextView.$(H)  ../include/TextView.$(H)  ../include/ListView.$(H)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)FilenameEnterBox.$(O) FilenameEnterBox.$(H): FilenameEnterBox.st $(STCHDR)  ../include/EnterBox.$(H)  ../include/DialogBox.$(H)  ../include/ModalBox.$(H)  ../include/StandardSystemView.$(H)  ../include/TopView.$(H)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)GraphColumn.$(O) GraphColumn.$(H): GraphColumn.st $(STCHDR)  ../include/Model.$(H)  ../include/Object.$(H) 
$(OUTDIR)GraphColumnView.$(O) GraphColumnView.$(H): GraphColumnView.st $(STCHDR)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)GraphColumnView2D.$(O) GraphColumnView2D.$(H): GraphColumnView2D.st $(STCHDR) 
$(OUTDIR)GraphColumnView2DSpec.$(O) GraphColumnView2DSpec.$(H): GraphColumnView2DSpec.st $(STCHDR) 
$(OUTDIR)GraphColumnView3D.$(O) GraphColumnView3D.$(H): GraphColumnView3D.st $(STCHDR) 
$(OUTDIR)GraphColumnView3DSpec.$(O) GraphColumnView3DSpec.$(H): GraphColumnView3DSpec.st $(STCHDR) 
$(OUTDIR)GraphColumnViewSpec.$(O) GraphColumnViewSpec.$(H): GraphColumnViewSpec.st $(STCHDR)  ../include/MenuComponentSpec.$(H)  ../include/NamedSpec.$(H)  ../include/ComponentSpec.$(H)  ../include/UISpecification.$(H)  ../include/Object.$(H) 
$(OUTDIR)GridBagConstraints.$(O) GridBagConstraints.$(H): GridBagConstraints.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)GridBagLayoutInfo.$(O) GridBagLayoutInfo.$(H): GridBagLayoutInfo.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)GridBagLayoutView.$(O) GridBagLayoutView.$(H): GridBagLayoutView.st $(STCHDR)  ../include/PanelView.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)HierarchicalFileList.$(O) HierarchicalFileList.$(H): HierarchicalFileList.st $(STCHDR)  HierarchicalItem.$(H)  ../include/Object.$(H) 
$(OUTDIR)HierarchicalItem.$(O) HierarchicalItem.$(H): HierarchicalItem.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)HierarchicalList.$(O) HierarchicalList.$(H): HierarchicalList.st $(STCHDR)  ../include/List.$(H)  ../include/OrderedCollection.$(H)  ../include/SequenceableCollection.$(H)  ../include/Collection.$(H)  ../include/Object.$(H) 
$(OUTDIR)HierarchicalListView.$(O) HierarchicalListView.$(H): HierarchicalListView.st $(STCHDR) 
$(OUTDIR)HierarchyNode.$(O) HierarchyNode.$(H): HierarchyNode.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)HorizontalScale.$(O) HorizontalScale.$(H): HorizontalScale.st $(STCHDR)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)HorizontalSlider.$(O) HorizontalSlider.$(H): HorizontalSlider.st $(STCHDR)  ../include/Slider.$(H)  ../include/Scroller.$(H)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)HorizontalSteppingSlider.$(O) HorizontalSteppingSlider.$(H): HorizontalSteppingSlider.st $(STCHDR) 
$(OUTDIR)ImageEditView.$(O) ImageEditView.$(H): ImageEditView.st $(STCHDR) 
$(OUTDIR)ImageSelectionBox.$(O) ImageSelectionBox.$(H): ImageSelectionBox.st $(STCHDR)  ../include/FileSelectionBox.$(H)  ../include/ListSelectionBox.$(H)  ../include/EnterBox.$(H)  ../include/DialogBox.$(H)  ../include/ModalBox.$(H)  ../include/StandardSystemView.$(H)  ../include/TopView.$(H)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)ImageView.$(O) ImageView.$(H): ImageView.st $(STCHDR)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)LabelAndIcon.$(O) LabelAndIcon.$(H): LabelAndIcon.st $(STCHDR)  ../include/ListEntry.$(H)  ../include/Object.$(H) 
$(OUTDIR)LabelledEnterField.$(O) LabelledEnterField.$(H): LabelledEnterField.st $(STCHDR)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)LicenceBox.$(O) LicenceBox.$(H): LicenceBox.st $(STCHDR)  ../include/DialogBox.$(H)  ../include/ModalBox.$(H)  ../include/StandardSystemView.$(H)  ../include/TopView.$(H)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)ListEditor.$(O) ListEditor.$(H): ListEditor.st $(STCHDR)  ../include/ApplicationModel.$(H)  ../include/Model.$(H)  ../include/Object.$(H) 
$(OUTDIR)ListEntry.$(O) ListEntry.$(H): ListEntry.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)ListModelView.$(O) ListModelView.$(H): ListModelView.st $(STCHDR)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)MenuButton.$(O) MenuButton.$(H): MenuButton.st $(STCHDR)  ../include/Button.$(H)  ../include/Label.$(H)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)MenuPanel.$(O) MenuPanel.$(H): MenuPanel.st $(STCHDR)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)MotionButton.$(O) MotionButton.$(H): MotionButton.st $(STCHDR)  ../include/Button.$(H)  ../include/Label.$(H)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)MultiColListEntry.$(O) MultiColListEntry.$(H): MultiColListEntry.st $(STCHDR)  ../include/ListEntry.$(H)  ../include/Object.$(H) 
$(OUTDIR)NoteBookFrameView.$(O) NoteBookFrameView.$(H): NoteBookFrameView.st $(STCHDR)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)NoteBookView.$(O) NoteBookView.$(H): NoteBookView.st $(STCHDR)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)ParagraphSpecification.$(O) ParagraphSpecification.$(H): ParagraphSpecification.st $(STCHDR)  ../include/TabulatorSpecification.$(H)  ../include/Model.$(H)  ../include/Object.$(H) 
$(OUTDIR)RoundButton.$(O) RoundButton.$(H): RoundButton.st $(STCHDR)  ../include/Button.$(H)  ../include/Label.$(H)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)Ruler.$(O) Ruler.$(H): Ruler.st $(STCHDR)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)Scale.$(O) Scale.$(H): Scale.st $(STCHDR)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)SelectionInHierarchy.$(O) SelectionInHierarchy.$(H): SelectionInHierarchy.st $(STCHDR)  ../include/Model.$(H)  ../include/Object.$(H) 
$(OUTDIR)SelectionInHierarchyView.$(O) SelectionInHierarchyView.$(H): SelectionInHierarchyView.st $(STCHDR)  ../include/SelectionInListView.$(H)  ../include/ListView.$(H)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)SelectionInListModelView.$(O) SelectionInListModelView.$(H): SelectionInListModelView.st $(STCHDR) 
$(OUTDIR)SelectionInTree.$(O) SelectionInTree.$(H): SelectionInTree.st $(STCHDR)  ../include/Model.$(H)  ../include/Object.$(H) 
$(OUTDIR)SelectionInTreeView.$(O) SelectionInTreeView.$(H): SelectionInTreeView.st $(STCHDR)  ../include/SelectionInListView.$(H)  ../include/ListView.$(H)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)Separator.$(O) Separator.$(H): Separator.st $(STCHDR)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)Slider.$(O) Slider.$(H): Slider.st $(STCHDR)  ../include/Scroller.$(H)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)SteppingSlider.$(O) SteppingSlider.$(H): SteppingSlider.st $(STCHDR)  ../include/ScrollBar.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)SubCanvas.$(O) SubCanvas.$(H): SubCanvas.st $(STCHDR)  ../include/ScrollableView.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)SyncedMultiColumnTextView.$(O) SyncedMultiColumnTextView.$(H): SyncedMultiColumnTextView.st $(STCHDR)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)TabItem.$(O) TabItem.$(H): TabItem.st $(STCHDR)  ../include/Model.$(H)  ../include/Object.$(H) 
$(OUTDIR)TabSpecRuler.$(O) TabSpecRuler.$(H): TabSpecRuler.st $(STCHDR)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)TabView.$(O) TabView.$(H): TabView.st $(STCHDR)  ../include/NoteBookView.$(H)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)TabWidget.$(O) TabWidget.$(H): TabWidget.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)TabulatorSpecification.$(O) TabulatorSpecification.$(H): TabulatorSpecification.st $(STCHDR)  ../include/Model.$(H)  ../include/Object.$(H) 
$(OUTDIR)TextBox.$(O) TextBox.$(H): TextBox.st $(STCHDR)  ../include/EnterBox.$(H)  ../include/DialogBox.$(H)  ../include/ModalBox.$(H)  ../include/StandardSystemView.$(H)  ../include/TopView.$(H)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)TextRuler.$(O) TextRuler.$(H): TextRuler.st $(STCHDR) 
$(OUTDIR)ThreeColumnTextView.$(O) ThreeColumnTextView.$(H): ThreeColumnTextView.st $(STCHDR) 
$(OUTDIR)TreeItem.$(O) TreeItem.$(H): TreeItem.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)TreeItemWithImage.$(O) TreeItemWithImage.$(H): TreeItemWithImage.st $(STCHDR)  ../include/TreeItem.$(H)  ../include/Object.$(H) 
$(OUTDIR)TwoColumnTextView.$(O) TwoColumnTextView.$(H): TwoColumnTextView.st $(STCHDR) 
$(OUTDIR)UpDownButton.$(O) UpDownButton.$(H): UpDownButton.st $(STCHDR)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)VerticalRuler.$(O) VerticalRuler.$(H): VerticalRuler.st $(STCHDR) 
$(OUTDIR)ViewScroller.$(O) ViewScroller.$(H): ViewScroller.st $(STCHDR)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
# ENDMAKEDEPEND
