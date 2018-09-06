#
# DO NOT EDIT 
# automatically generated from Make.proto
#
# $Header: /cvs/stx/stx/libui/vms.mak,v 1.3 1999-09-18 14:35:06 cg Exp $
#
TOP=..
LIBNAME=libui
STCOPT="-warnNonStandard"
STCLOCALOPT=-package=stx:$(LIBNAME) $(COMMONSYMBOLS) $(SEPINITCODE) $(RELOCINSTVARS) -varPrefix=$(LIBNAME)
ALL: $(LIBDIR)\$(LIBNAME).olb

OBJS=\
  $(OUTDIR)UISpecification.$(O) \
  $(OUTDIR)ComponentSpec.$(O) \
  $(OUTDIR)NamedSpec.$(O) \
  $(OUTDIR)MenuComponentSpec.$(O) \
  $(OUTDIR)WindowSpec.$(O) \
  $(OUTDIR)UnknownSpec.$(O) \
  $(OUTDIR)ViewWithLabelSpec.$(O) \
  $(OUTDIR)ViewWithLabelAndModelSpec.$(O) \
  $(OUTDIR)LabelSpec.$(O) \
  $(OUTDIR)ViewWithSubcomponentsSpec.$(O) \
  $(OUTDIR)ViewSpec.$(O) \
  $(OUTDIR)FramedBoxSpec.$(O) \
  $(OUTDIR)ActionButtonSpec.$(O) \
  $(OUTDIR)ArrowButtonSpec.$(O) \
  $(OUTDIR)ButtonSpec.$(O) \
  $(OUTDIR)ToggleSpec.$(O) \
  $(OUTDIR)CheckToggleSpec.$(O) \
  $(OUTDIR)RadioButtonSpec.$(O) \
  $(OUTDIR)WidgetSpec.$(O) \
  $(OUTDIR)CheckBoxSpec.$(O) \
  $(OUTDIR)FullSpec.$(O) \
  $(OUTDIR)PanelViewSpec.$(O) \
  $(OUTDIR)HorizontalPanelViewSpec.$(O) \
  $(OUTDIR)VerticalPanelViewSpec.$(O) \
  $(OUTDIR)VariablePanelSpec.$(O) \
  $(OUTDIR)VariableHorizontalPanelSpec.$(O) \
  $(OUTDIR)VariableVerticalPanelSpec.$(O) \
  $(OUTDIR)ViewWithScrollerSpec.$(O) \
  $(OUTDIR)TextEditorSpec.$(O) \
  $(OUTDIR)InputFieldSpec.$(O) \
  $(OUTDIR)WorkspaceSpec.$(O) \
  $(OUTDIR)SelectionInTreeViewSpec.$(O) \
  $(OUTDIR)FileSelectionTreeSpec.$(O) \
  $(OUTDIR)PopUpListSpec.$(O) \
  $(OUTDIR)DividerSpec.$(O) \
  $(OUTDIR)SeparatorSpec.$(O) \
  $(OUTDIR)SequenceViewSpec.$(O) \
  $(OUTDIR)ScrollerSpec.$(O) \
  $(OUTDIR)SliderSpec.$(O) \
  $(OUTDIR)ProgressIndicatorSpec.$(O) \
  $(OUTDIR)ComboBoxSpec.$(O) \
  $(OUTDIR)ComboListSpec.$(O) \
  $(OUTDIR)MenuPanelSpec.$(O) \
  $(OUTDIR)TableViewSpec.$(O) \
  $(OUTDIR)TabViewSpec.$(O) \
  $(OUTDIR)NoteBookViewSpec.$(O) \
  $(OUTDIR)NoteBookSpec.$(O) \
  $(OUTDIR)UIGalleryViewSpec.$(O) \
  $(OUTDIR)SpecCollection.$(O) \
  $(OUTDIR)FontMenuSpec.$(O) \
  $(OUTDIR)UISubSpecification.$(O) \
  $(OUTDIR)DataSetSpec.$(O) \
  $(OUTDIR)DataSetColumnSpec.$(O) \
  $(OUTDIR)GridBagLayoutViewSpec.$(O) \
  $(OUTDIR)SubCanvasSpec.$(O) \
  $(OUTDIR)ArbitraryComponentSpec.$(O) \
  $(OUTDIR)HTMLViewSpec.$(O) \
  $(OUTDIR)RegionSpec.$(O) \
  $(OUTDIR)ExtendedComboBoxSpec.$(O) \
  $(OUTDIR)UpDownButtonSpec.$(O) \


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
$(OUTDIR)ActionButtonSpec.$(O) ActionButtonSpec.$(H): ActionButtonSpec.st $(STCHDR)  ../include/ViewWithLabelAndModelSpec.$(H)  ../include/ViewWithLabelSpec.$(H)  ../include/ComponentSpec.$(H)  ../include/UISpecification.$(H)  ../include/Object.$(H) 
$(OUTDIR)ArbitraryComponentSpec.$(O) ArbitraryComponentSpec.$(H): ArbitraryComponentSpec.st $(STCHDR)  ../include/ViewWithScrollerSpec.$(H)  ../include/MenuComponentSpec.$(H)  ../include/NamedSpec.$(H)  ../include/ComponentSpec.$(H)  ../include/UISpecification.$(H)  ../include/Object.$(H) 
$(OUTDIR)ArrowButtonSpec.$(O) ArrowButtonSpec.$(H): ArrowButtonSpec.st $(STCHDR)  ../include/ActionButtonSpec.$(H)  ../include/ViewWithLabelAndModelSpec.$(H)  ../include/ViewWithLabelSpec.$(H)  ../include/ComponentSpec.$(H)  ../include/UISpecification.$(H)  ../include/Object.$(H) 
$(OUTDIR)ButtonSpec.$(O) ButtonSpec.$(H): ButtonSpec.st $(STCHDR)  ../include/ActionButtonSpec.$(H)  ../include/ViewWithLabelAndModelSpec.$(H)  ../include/ViewWithLabelSpec.$(H)  ../include/ComponentSpec.$(H)  ../include/UISpecification.$(H)  ../include/Object.$(H) 
$(OUTDIR)CheckBoxSpec.$(O) CheckBoxSpec.$(H): CheckBoxSpec.st $(STCHDR)  ../include/WidgetSpec.$(H)  ../include/NamedSpec.$(H)  ../include/ComponentSpec.$(H)  ../include/UISpecification.$(H)  ../include/Object.$(H) 
$(OUTDIR)CheckToggleSpec.$(O) CheckToggleSpec.$(H): CheckToggleSpec.st $(STCHDR)  ../include/ToggleSpec.$(H)  ../include/ActionButtonSpec.$(H)  ../include/ViewWithLabelAndModelSpec.$(H)  ../include/ViewWithLabelSpec.$(H)  ../include/ComponentSpec.$(H)  ../include/UISpecification.$(H)  ../include/Object.$(H) 
$(OUTDIR)CodeViewSpec.$(O) CodeViewSpec.$(H): CodeViewSpec.st $(STCHDR)  ../include/WorkspaceSpec.$(H)  ../include/TextEditorSpec.$(H)  ../include/ViewWithScrollerSpec.$(H)  ../include/MenuComponentSpec.$(H)  ../include/NamedSpec.$(H)  ../include/ComponentSpec.$(H)  ../include/UISpecification.$(H)  ../include/Object.$(H) 
$(OUTDIR)ColorMenuSpec.$(O) ColorMenuSpec.$(H): ColorMenuSpec.st $(STCHDR)  ../include/UISpecification.$(H)  ../include/Object.$(H) 
$(OUTDIR)ComboBoxSpec.$(O) ComboBoxSpec.$(H): ComboBoxSpec.st $(STCHDR)  ../include/InputFieldSpec.$(H)  ../include/MenuComponentSpec.$(H)  ../include/NamedSpec.$(H)  ../include/ComponentSpec.$(H)  ../include/UISpecification.$(H)  ../include/Object.$(H) 
$(OUTDIR)ComboListSpec.$(O) ComboListSpec.$(H): ComboListSpec.st $(STCHDR)  ../include/WidgetSpec.$(H)  ../include/NamedSpec.$(H)  ../include/ComponentSpec.$(H)  ../include/UISpecification.$(H)  ../include/Object.$(H) 
$(OUTDIR)ComponentSpec.$(O) ComponentSpec.$(H): ComponentSpec.st $(STCHDR)  ../include/UISpecification.$(H)  ../include/Object.$(H) 
$(OUTDIR)CompositeSpec.$(O) CompositeSpec.$(H): CompositeSpec.st $(STCHDR)  ../include/ComponentSpec.$(H)  ../include/UISpecification.$(H)  ../include/Object.$(H) 
$(OUTDIR)CompositeSpecCollection.$(O) CompositeSpecCollection.$(H): CompositeSpecCollection.st $(STCHDR)  ../include/ComponentSpec.$(H)  ../include/UISpecification.$(H)  ../include/Object.$(H) 
$(OUTDIR)DataSetColumnSpec.$(O) DataSetColumnSpec.$(H): DataSetColumnSpec.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)DataSetSpec.$(O) DataSetSpec.$(H): DataSetSpec.st $(STCHDR)  ../include/ViewWithScrollerSpec.$(H)  ../include/MenuComponentSpec.$(H)  ../include/NamedSpec.$(H)  ../include/ComponentSpec.$(H)  ../include/UISpecification.$(H)  ../include/Object.$(H) 
$(OUTDIR)DividerSpec.$(O) DividerSpec.$(H): DividerSpec.st $(STCHDR)  ../include/UISpecification.$(H)  ../include/Object.$(H) 
$(OUTDIR)ExtendedComboBoxSpec.$(O) ExtendedComboBoxSpec.$(H): ExtendedComboBoxSpec.st $(STCHDR)  ../include/WidgetSpec.$(H)  ../include/NamedSpec.$(H)  ../include/ComponentSpec.$(H)  ../include/UISpecification.$(H)  ../include/Object.$(H) 
$(OUTDIR)FileSelectionTreeSpec.$(O) FileSelectionTreeSpec.$(H): FileSelectionTreeSpec.st $(STCHDR)  ../include/SelectionInTreeViewSpec.$(H)  ../include/ViewWithScrollerSpec.$(H)  ../include/MenuComponentSpec.$(H)  ../include/NamedSpec.$(H)  ../include/ComponentSpec.$(H)  ../include/UISpecification.$(H)  ../include/Object.$(H) 
$(OUTDIR)FontMenuSpec.$(O) FontMenuSpec.$(H): FontMenuSpec.st $(STCHDR)  ../include/UISpecification.$(H)  ../include/Object.$(H) 
$(OUTDIR)FramedBoxSpec.$(O) FramedBoxSpec.$(H): FramedBoxSpec.st $(STCHDR)  ../include/ViewSpec.$(H)  ../include/ViewWithSubcomponentsSpec.$(H)  ../include/ComponentSpec.$(H)  ../include/UISpecification.$(H)  ../include/Object.$(H) 
$(OUTDIR)FullSpec.$(O) FullSpec.$(H): FullSpec.st $(STCHDR)  ../include/ViewWithSubcomponentsSpec.$(H)  ../include/ComponentSpec.$(H)  ../include/UISpecification.$(H)  ../include/Object.$(H) 
$(OUTDIR)GridBagLayoutViewSpec.$(O) GridBagLayoutViewSpec.$(H): GridBagLayoutViewSpec.st $(STCHDR)  ../include/PanelViewSpec.$(H)  ../include/ViewSpec.$(H)  ../include/ViewWithSubcomponentsSpec.$(H)  ../include/ComponentSpec.$(H)  ../include/UISpecification.$(H)  ../include/Object.$(H) 
$(OUTDIR)GroupBoxSpec.$(O) GroupBoxSpec.$(H): GroupBoxSpec.st $(STCHDR)  ../include/FramedBoxSpec.$(H)  ../include/ViewSpec.$(H)  ../include/ViewWithSubcomponentsSpec.$(H)  ../include/ComponentSpec.$(H)  ../include/UISpecification.$(H)  ../include/Object.$(H) 
$(OUTDIR)HTMLViewSpec.$(O) HTMLViewSpec.$(H): HTMLViewSpec.st $(STCHDR)  ../include/ViewWithScrollerSpec.$(H)  ../include/MenuComponentSpec.$(H)  ../include/NamedSpec.$(H)  ../include/ComponentSpec.$(H)  ../include/UISpecification.$(H)  ../include/Object.$(H) 
$(OUTDIR)HierarchicalListViewSpec.$(O) HierarchicalListViewSpec.$(H): HierarchicalListViewSpec.st $(STCHDR) 
$(OUTDIR)HorizontalPanelViewSpec.$(O) HorizontalPanelViewSpec.$(H): HorizontalPanelViewSpec.st $(STCHDR)  ../include/PanelViewSpec.$(H)  ../include/ViewSpec.$(H)  ../include/ViewWithSubcomponentsSpec.$(H)  ../include/ComponentSpec.$(H)  ../include/UISpecification.$(H)  ../include/Object.$(H) 
$(OUTDIR)InputFieldSpec.$(O) InputFieldSpec.$(H): InputFieldSpec.st $(STCHDR)  ../include/MenuComponentSpec.$(H)  ../include/NamedSpec.$(H)  ../include/ComponentSpec.$(H)  ../include/UISpecification.$(H)  ../include/Object.$(H) 
$(OUTDIR)LabelSpec.$(O) LabelSpec.$(H): LabelSpec.st $(STCHDR)  ../include/ViewWithLabelSpec.$(H)  ../include/ComponentSpec.$(H)  ../include/UISpecification.$(H)  ../include/Object.$(H) 
$(OUTDIR)ListModelViewSpec.$(O) ListModelViewSpec.$(H): ListModelViewSpec.st $(STCHDR)  ../include/ViewWithScrollerSpec.$(H)  ../include/MenuComponentSpec.$(H)  ../include/NamedSpec.$(H)  ../include/ComponentSpec.$(H)  ../include/UISpecification.$(H)  ../include/Object.$(H) 
$(OUTDIR)MenuButtonSpec.$(O) MenuButtonSpec.$(H): MenuButtonSpec.st $(STCHDR)  ../include/PopUpListSpec.$(H)  ../include/ViewWithLabelAndModelSpec.$(H)  ../include/ViewWithLabelSpec.$(H)  ../include/ComponentSpec.$(H)  ../include/UISpecification.$(H)  ../include/Object.$(H) 
$(OUTDIR)MenuComponentSpec.$(O) MenuComponentSpec.$(H): MenuComponentSpec.st $(STCHDR)  ../include/NamedSpec.$(H)  ../include/ComponentSpec.$(H)  ../include/UISpecification.$(H)  ../include/Object.$(H) 
$(OUTDIR)MenuPanelSpec.$(O) MenuPanelSpec.$(H): MenuPanelSpec.st $(STCHDR)  ../include/MenuComponentSpec.$(H)  ../include/NamedSpec.$(H)  ../include/ComponentSpec.$(H)  ../include/UISpecification.$(H)  ../include/Object.$(H) 
$(OUTDIR)NamedSpec.$(O) NamedSpec.$(H): NamedSpec.st $(STCHDR)  ../include/ComponentSpec.$(H)  ../include/UISpecification.$(H)  ../include/Object.$(H) 
$(OUTDIR)NoteBookSpec.$(O) NoteBookSpec.$(H): NoteBookSpec.st $(STCHDR)  ../include/UISpecification.$(H)  ../include/Object.$(H) 
$(OUTDIR)NoteBookViewSpec.$(O) NoteBookViewSpec.$(H): NoteBookViewSpec.st $(STCHDR)  ../include/TabViewSpec.$(H)  ../include/MenuComponentSpec.$(H)  ../include/NamedSpec.$(H)  ../include/ComponentSpec.$(H)  ../include/UISpecification.$(H)  ../include/Object.$(H) 
$(OUTDIR)PanelViewSpec.$(O) PanelViewSpec.$(H): PanelViewSpec.st $(STCHDR)  ../include/ViewSpec.$(H)  ../include/ViewWithSubcomponentsSpec.$(H)  ../include/ComponentSpec.$(H)  ../include/UISpecification.$(H)  ../include/Object.$(H) 
$(OUTDIR)PopUpListSpec.$(O) PopUpListSpec.$(H): PopUpListSpec.st $(STCHDR)  ../include/ViewWithLabelAndModelSpec.$(H)  ../include/ViewWithLabelSpec.$(H)  ../include/ComponentSpec.$(H)  ../include/UISpecification.$(H)  ../include/Object.$(H) 
$(OUTDIR)ProgressIndicatorSpec.$(O) ProgressIndicatorSpec.$(H): ProgressIndicatorSpec.st $(STCHDR)  ../include/NamedSpec.$(H)  ../include/ComponentSpec.$(H)  ../include/UISpecification.$(H)  ../include/Object.$(H) 
$(OUTDIR)RadioButtonSpec.$(O) RadioButtonSpec.$(H): RadioButtonSpec.st $(STCHDR)  ../include/ToggleSpec.$(H)  ../include/ActionButtonSpec.$(H)  ../include/ViewWithLabelAndModelSpec.$(H)  ../include/ViewWithLabelSpec.$(H)  ../include/ComponentSpec.$(H)  ../include/UISpecification.$(H)  ../include/Object.$(H) 
$(OUTDIR)RegionSpec.$(O) RegionSpec.$(H): RegionSpec.st $(STCHDR)  ../include/UISpecification.$(H)  ../include/Object.$(H) 
$(OUTDIR)RoundProgressIndicatorSpec.$(O) RoundProgressIndicatorSpec.$(H): RoundProgressIndicatorSpec.st $(STCHDR)  ../include/ProgressIndicatorSpec.$(H)  ../include/NamedSpec.$(H)  ../include/ComponentSpec.$(H)  ../include/UISpecification.$(H)  ../include/Object.$(H) 
$(OUTDIR)ScrollBarSpec.$(O) ScrollBarSpec.$(H): ScrollBarSpec.st $(STCHDR)  ../include/ScrollerSpec.$(H)  ../include/NamedSpec.$(H)  ../include/ComponentSpec.$(H)  ../include/UISpecification.$(H)  ../include/Object.$(H) 
$(OUTDIR)ScrollableViewSpec.$(O) ScrollableViewSpec.$(H): ScrollableViewSpec.st $(STCHDR)  ../include/ViewWithSubcomponentsSpec.$(H)  ../include/ComponentSpec.$(H)  ../include/UISpecification.$(H)  ../include/Object.$(H) 
$(OUTDIR)ScrollerSpec.$(O) ScrollerSpec.$(H): ScrollerSpec.st $(STCHDR)  ../include/NamedSpec.$(H)  ../include/ComponentSpec.$(H)  ../include/UISpecification.$(H)  ../include/Object.$(H) 
$(OUTDIR)SelectionInListModelViewSpec.$(O) SelectionInListModelViewSpec.$(H): SelectionInListModelViewSpec.st $(STCHDR)  ../include/HierarchicalItem.$(H)  ../include/Object.$(H) 
$(OUTDIR)SelectionInTreeViewSpec.$(O) SelectionInTreeViewSpec.$(H): SelectionInTreeViewSpec.st $(STCHDR)  ../include/ViewWithScrollerSpec.$(H)  ../include/MenuComponentSpec.$(H)  ../include/NamedSpec.$(H)  ../include/ComponentSpec.$(H)  ../include/UISpecification.$(H)  ../include/Object.$(H) 
$(OUTDIR)SeparatorSpec.$(O) SeparatorSpec.$(H): SeparatorSpec.st $(STCHDR)  ../include/DividerSpec.$(H)  ../include/UISpecification.$(H)  ../include/Object.$(H) 
$(OUTDIR)SequenceViewSpec.$(O) SequenceViewSpec.$(H): SequenceViewSpec.st $(STCHDR)  ../include/ViewWithScrollerSpec.$(H)  ../include/MenuComponentSpec.$(H)  ../include/NamedSpec.$(H)  ../include/ComponentSpec.$(H)  ../include/UISpecification.$(H)  ../include/Object.$(H) 
$(OUTDIR)SliderSpec.$(O) SliderSpec.$(H): SliderSpec.st $(STCHDR)  ../include/ScrollerSpec.$(H)  ../include/NamedSpec.$(H)  ../include/ComponentSpec.$(H)  ../include/UISpecification.$(H)  ../include/Object.$(H) 
$(OUTDIR)SpecCollection.$(O) SpecCollection.$(H): SpecCollection.st $(STCHDR)  ../include/ComponentSpec.$(H)  ../include/UISpecification.$(H)  ../include/Object.$(H) 
$(OUTDIR)SteppingSliderSpec.$(O) SteppingSliderSpec.$(H): SteppingSliderSpec.st $(STCHDR)  ../include/SliderSpec.$(H)  ../include/ScrollerSpec.$(H)  ../include/NamedSpec.$(H)  ../include/ComponentSpec.$(H)  ../include/UISpecification.$(H)  ../include/Object.$(H) 
$(OUTDIR)SubCanvasSpec.$(O) SubCanvasSpec.$(H): SubCanvasSpec.st $(STCHDR)  ../include/ViewWithScrollerSpec.$(H)  ../include/MenuComponentSpec.$(H)  ../include/NamedSpec.$(H)  ../include/ComponentSpec.$(H)  ../include/UISpecification.$(H)  ../include/Object.$(H) 
$(OUTDIR)TabViewSpec.$(O) TabViewSpec.$(H): TabViewSpec.st $(STCHDR)  ../include/MenuComponentSpec.$(H)  ../include/NamedSpec.$(H)  ../include/ComponentSpec.$(H)  ../include/UISpecification.$(H)  ../include/Object.$(H) 
$(OUTDIR)TableViewSpec.$(O) TableViewSpec.$(H): TableViewSpec.st $(STCHDR)  ../include/MenuComponentSpec.$(H)  ../include/NamedSpec.$(H)  ../include/ComponentSpec.$(H)  ../include/UISpecification.$(H)  ../include/Object.$(H) 
$(OUTDIR)TextCollectorSpec.$(O) TextCollectorSpec.$(H): TextCollectorSpec.st $(STCHDR)  ../include/TextEditorSpec.$(H)  ../include/ViewWithScrollerSpec.$(H)  ../include/MenuComponentSpec.$(H)  ../include/NamedSpec.$(H)  ../include/ComponentSpec.$(H)  ../include/UISpecification.$(H)  ../include/Object.$(H) 
$(OUTDIR)TextEditorSpec.$(O) TextEditorSpec.$(H): TextEditorSpec.st $(STCHDR)  ../include/ViewWithScrollerSpec.$(H)  ../include/MenuComponentSpec.$(H)  ../include/NamedSpec.$(H)  ../include/ComponentSpec.$(H)  ../include/UISpecification.$(H)  ../include/Object.$(H) 
$(OUTDIR)ThumbWheelSpec.$(O) ThumbWheelSpec.$(H): ThumbWheelSpec.st $(STCHDR)  ../include/SliderSpec.$(H)  ../include/ScrollerSpec.$(H)  ../include/NamedSpec.$(H)  ../include/ComponentSpec.$(H)  ../include/UISpecification.$(H)  ../include/Object.$(H) 
$(OUTDIR)ToggleSpec.$(O) ToggleSpec.$(H): ToggleSpec.st $(STCHDR)  ../include/ActionButtonSpec.$(H)  ../include/ViewWithLabelAndModelSpec.$(H)  ../include/ViewWithLabelSpec.$(H)  ../include/ComponentSpec.$(H)  ../include/UISpecification.$(H)  ../include/Object.$(H) 
$(OUTDIR)UIEventCallbackSubSpec.$(O) UIEventCallbackSubSpec.$(H): UIEventCallbackSubSpec.st $(STCHDR)  ../include/UISpecification.$(H)  ../include/Object.$(H) 
$(OUTDIR)UIGalleryViewSpec.$(O) UIGalleryViewSpec.$(H): UIGalleryViewSpec.st $(STCHDR)  ../include/NoteBookViewSpec.$(H)  ../include/TabViewSpec.$(H)  ../include/MenuComponentSpec.$(H)  ../include/NamedSpec.$(H)  ../include/ComponentSpec.$(H)  ../include/UISpecification.$(H)  ../include/Object.$(H) 
$(OUTDIR)UIPalette.$(O) UIPalette.$(H): UIPalette.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)UISpecification.$(O) UISpecification.$(H): UISpecification.st $(STCHDR)  ../include/Object.$(H)  ../include/IdentityDictionary.$(H)  ../include/Dictionary.$(H)  ../include/Set.$(H)  ../include/Collection.$(H) 
$(OUTDIR)UISubSpecification.$(O) UISubSpecification.$(H): UISubSpecification.st $(STCHDR)  ../include/ComponentSpec.$(H)  ../include/UISpecification.$(H)  ../include/Object.$(H) 
$(OUTDIR)UnknownSpec.$(O) UnknownSpec.$(H): UnknownSpec.st $(STCHDR)  ../include/UISpecification.$(H)  ../include/Object.$(H) 
$(OUTDIR)UpDownButtonSpec.$(O) UpDownButtonSpec.$(H): UpDownButtonSpec.st $(STCHDR)  ../include/ViewWithLabelAndModelSpec.$(H)  ../include/ViewWithLabelSpec.$(H)  ../include/ComponentSpec.$(H)  ../include/UISpecification.$(H)  ../include/Object.$(H) 
$(OUTDIR)VariableHorizontalPanelSpec.$(O) VariableHorizontalPanelSpec.$(H): VariableHorizontalPanelSpec.st $(STCHDR)  ../include/VariablePanelSpec.$(H)  ../include/ViewSpec.$(H)  ../include/ViewWithSubcomponentsSpec.$(H)  ../include/ComponentSpec.$(H)  ../include/UISpecification.$(H)  ../include/Object.$(H) 
$(OUTDIR)VariablePanelSpec.$(O) VariablePanelSpec.$(H): VariablePanelSpec.st $(STCHDR)  ../include/ViewSpec.$(H)  ../include/ViewWithSubcomponentsSpec.$(H)  ../include/ComponentSpec.$(H)  ../include/UISpecification.$(H)  ../include/Object.$(H) 
$(OUTDIR)VariableVerticalPanelSpec.$(O) VariableVerticalPanelSpec.$(H): VariableVerticalPanelSpec.st $(STCHDR)  ../include/VariablePanelSpec.$(H)  ../include/ViewSpec.$(H)  ../include/ViewWithSubcomponentsSpec.$(H)  ../include/ComponentSpec.$(H)  ../include/UISpecification.$(H)  ../include/Object.$(H) 
$(OUTDIR)VerticalPanelViewSpec.$(O) VerticalPanelViewSpec.$(H): VerticalPanelViewSpec.st $(STCHDR)  ../include/PanelViewSpec.$(H)  ../include/ViewSpec.$(H)  ../include/ViewWithSubcomponentsSpec.$(H)  ../include/ComponentSpec.$(H)  ../include/UISpecification.$(H)  ../include/Object.$(H) 
$(OUTDIR)ViewSpec.$(O) ViewSpec.$(H): ViewSpec.st $(STCHDR)  ../include/ViewWithSubcomponentsSpec.$(H)  ../include/ComponentSpec.$(H)  ../include/UISpecification.$(H)  ../include/Object.$(H) 
$(OUTDIR)ViewWithLabelAndModelSpec.$(O) ViewWithLabelAndModelSpec.$(H): ViewWithLabelAndModelSpec.st $(STCHDR)  ../include/ViewWithLabelSpec.$(H)  ../include/ComponentSpec.$(H)  ../include/UISpecification.$(H)  ../include/Object.$(H) 
$(OUTDIR)ViewWithLabelSpec.$(O) ViewWithLabelSpec.$(H): ViewWithLabelSpec.st $(STCHDR)  ../include/ComponentSpec.$(H)  ../include/UISpecification.$(H)  ../include/Object.$(H) 
$(OUTDIR)ViewWithScrollerSpec.$(O) ViewWithScrollerSpec.$(H): ViewWithScrollerSpec.st $(STCHDR)  ../include/MenuComponentSpec.$(H)  ../include/NamedSpec.$(H)  ../include/ComponentSpec.$(H)  ../include/UISpecification.$(H)  ../include/Object.$(H) 
$(OUTDIR)ViewWithSubcomponentsSpec.$(O) ViewWithSubcomponentsSpec.$(H): ViewWithSubcomponentsSpec.st $(STCHDR)  ../include/ComponentSpec.$(H)  ../include/UISpecification.$(H)  ../include/Object.$(H) 
$(OUTDIR)WidgetSpec.$(O) WidgetSpec.$(H): WidgetSpec.st $(STCHDR)  ../include/NamedSpec.$(H)  ../include/ComponentSpec.$(H)  ../include/UISpecification.$(H)  ../include/Object.$(H) 
$(OUTDIR)WindowSpec.$(O) WindowSpec.$(H): WindowSpec.st $(STCHDR)  ../include/ComponentSpec.$(H)  ../include/UISpecification.$(H)  ../include/Object.$(H) 
$(OUTDIR)WorkspaceSpec.$(O) WorkspaceSpec.$(H): WorkspaceSpec.st $(STCHDR)  ../include/TextEditorSpec.$(H)  ../include/ViewWithScrollerSpec.$(H)  ../include/MenuComponentSpec.$(H)  ../include/NamedSpec.$(H)  ../include/ComponentSpec.$(H)  ../include/UISpecification.$(H)  ../include/Object.$(H) 
# ENDMAKEDEPEND
