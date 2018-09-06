/*
 * $Header: /cvs/stx/stx/libui/libInit.cc,v 1.40 2018-07-05 10:59:22 lukas Exp $
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_libui.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_libui_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_libui_InitDefinition() INIT_TEXT_SECTION;
#endif

extern void _AssistantPageSpec_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _DataSetColumnSpec_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _SubChannelInfoSpec_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _UIPalette_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _UISpecVisitor_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _UISpecification_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _stx_137libui_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ComponentSpec_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _NoteBookSpec_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _UIEventCallbackSubSpec_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _UnknownSpec_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _CompositeSpec_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _CompositeSpecCollection_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _DividerSpec_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _NamedSpec_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RegionSpec_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _SpecCollection_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _TabControlSpec_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _UISubSpecification_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ViewWithLabelSpec_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ViewWithSubcomponentsSpec_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _WindowSpec_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ColorMenuSpec_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _FontMenuSpec_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _FullSpec_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _LabelSpec_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _MenuComponentSpec_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ProgressIndicatorSpec_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ScrollableViewSpec_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ScrollerSpec_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _SeparatorSpec_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ViewSpec_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ViewWithLabelAndModelSpec_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _WidgetSpec_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ActionButtonSpec_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _CheckBoxSpec_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ComboListSpec_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ExtendedComboBoxSpec_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _FramedBoxSpec_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _InputFieldSpec_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _MenuPanelSpec_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _PanelViewSpec_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _PopUpListSpec_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RoundProgressIndicatorSpec_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ScrollBarSpec_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _SliderSpec_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _TabViewSpec_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _TableViewSpec_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _TransparentBoxSpec_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _UpDownButtonSpec_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _VariablePanelSpec_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ViewWithScrollerSpec_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ArbitraryComponentSpec_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ArrowButtonSpec_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ButtonSpec_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ComboBoxSpec_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _DataSetSpec_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _FilenameInputFieldSpec_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _GridBagLayoutViewSpec_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _GroupBoxSpec_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _HTMLViewSpec_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _HorizontalPanelViewSpec_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _LinkButtonSpec_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ListModelViewSpec_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _MenuButtonSpec_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _MultiColumnPanelViewSpec_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _NoteBookViewSpec_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _SelectionInTreeViewSpec_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _SequenceViewSpec_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _SteppingSliderSpec_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _SubCanvasSpec_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _TextEditorSpec_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ThumbWheelSpec_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ToggleSpec_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _TriggerBoxSpec_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _VariableHorizontalPanelSpec_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _VariableVerticalPanelSpec_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _VerticalPanelViewSpec_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _CheckToggleSpec_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _FileSelectionTreeSpec_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _NonScrollableArbitraryComponentSpec_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RadioButtonSpec_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _SelectionInListModelViewSpec_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _TextCollectorSpec_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _UIGalleryViewSpec_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _WorkspaceSpec_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _CodeViewSpec_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _HierarchicalListViewSpec_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);


void _libstx_libui_InitDefinition(int pass, struct __vmData__ *__pRT__, OBJ snd)
{
  __BEGIN_PACKAGE2__("libstx_libui__DFN", _libstx_libui_InitDefinition, "stx:libui");
    _stx_137libui_Init(pass,__pRT__,snd);

  __END_PACKAGE__();
}

void _libstx_libui_Init(int pass, struct __vmData__ *__pRT__, OBJ snd)
{
  __BEGIN_PACKAGE2__("libstx_libui", _libstx_libui_Init, "stx:libui");
    _AssistantPageSpec_Init(pass,__pRT__,snd);
    _DataSetColumnSpec_Init(pass,__pRT__,snd);
    _SubChannelInfoSpec_Init(pass,__pRT__,snd);
    _UIPalette_Init(pass,__pRT__,snd);
    _UISpecVisitor_Init(pass,__pRT__,snd);
    _UISpecification_Init(pass,__pRT__,snd);
    _stx_137libui_Init(pass,__pRT__,snd);
    _ComponentSpec_Init(pass,__pRT__,snd);
    _NoteBookSpec_Init(pass,__pRT__,snd);
    _UIEventCallbackSubSpec_Init(pass,__pRT__,snd);
    _UnknownSpec_Init(pass,__pRT__,snd);
    _CompositeSpec_Init(pass,__pRT__,snd);
    _CompositeSpecCollection_Init(pass,__pRT__,snd);
    _DividerSpec_Init(pass,__pRT__,snd);
    _NamedSpec_Init(pass,__pRT__,snd);
    _RegionSpec_Init(pass,__pRT__,snd);
    _SpecCollection_Init(pass,__pRT__,snd);
    _TabControlSpec_Init(pass,__pRT__,snd);
    _UISubSpecification_Init(pass,__pRT__,snd);
    _ViewWithLabelSpec_Init(pass,__pRT__,snd);
    _ViewWithSubcomponentsSpec_Init(pass,__pRT__,snd);
    _WindowSpec_Init(pass,__pRT__,snd);
    _ColorMenuSpec_Init(pass,__pRT__,snd);
    _FontMenuSpec_Init(pass,__pRT__,snd);
    _FullSpec_Init(pass,__pRT__,snd);
    _LabelSpec_Init(pass,__pRT__,snd);
    _MenuComponentSpec_Init(pass,__pRT__,snd);
    _ProgressIndicatorSpec_Init(pass,__pRT__,snd);
    _ScrollableViewSpec_Init(pass,__pRT__,snd);
    _ScrollerSpec_Init(pass,__pRT__,snd);
    _SeparatorSpec_Init(pass,__pRT__,snd);
    _ViewSpec_Init(pass,__pRT__,snd);
    _ViewWithLabelAndModelSpec_Init(pass,__pRT__,snd);
    _WidgetSpec_Init(pass,__pRT__,snd);
    _ActionButtonSpec_Init(pass,__pRT__,snd);
    _CheckBoxSpec_Init(pass,__pRT__,snd);
    _ComboListSpec_Init(pass,__pRT__,snd);
    _ExtendedComboBoxSpec_Init(pass,__pRT__,snd);
    _FramedBoxSpec_Init(pass,__pRT__,snd);
    _InputFieldSpec_Init(pass,__pRT__,snd);
    _MenuPanelSpec_Init(pass,__pRT__,snd);
    _PanelViewSpec_Init(pass,__pRT__,snd);
    _PopUpListSpec_Init(pass,__pRT__,snd);
    _RoundProgressIndicatorSpec_Init(pass,__pRT__,snd);
    _ScrollBarSpec_Init(pass,__pRT__,snd);
    _SliderSpec_Init(pass,__pRT__,snd);
    _TabViewSpec_Init(pass,__pRT__,snd);
    _TableViewSpec_Init(pass,__pRT__,snd);
    _TransparentBoxSpec_Init(pass,__pRT__,snd);
    _UpDownButtonSpec_Init(pass,__pRT__,snd);
    _VariablePanelSpec_Init(pass,__pRT__,snd);
    _ViewWithScrollerSpec_Init(pass,__pRT__,snd);
    _ArbitraryComponentSpec_Init(pass,__pRT__,snd);
    _ArrowButtonSpec_Init(pass,__pRT__,snd);
    _ButtonSpec_Init(pass,__pRT__,snd);
    _ComboBoxSpec_Init(pass,__pRT__,snd);
    _DataSetSpec_Init(pass,__pRT__,snd);
    _FilenameInputFieldSpec_Init(pass,__pRT__,snd);
    _GridBagLayoutViewSpec_Init(pass,__pRT__,snd);
    _GroupBoxSpec_Init(pass,__pRT__,snd);
    _HTMLViewSpec_Init(pass,__pRT__,snd);
    _HorizontalPanelViewSpec_Init(pass,__pRT__,snd);
    _LinkButtonSpec_Init(pass,__pRT__,snd);
    _ListModelViewSpec_Init(pass,__pRT__,snd);
    _MenuButtonSpec_Init(pass,__pRT__,snd);
    _MultiColumnPanelViewSpec_Init(pass,__pRT__,snd);
    _NoteBookViewSpec_Init(pass,__pRT__,snd);
    _SelectionInTreeViewSpec_Init(pass,__pRT__,snd);
    _SequenceViewSpec_Init(pass,__pRT__,snd);
    _SteppingSliderSpec_Init(pass,__pRT__,snd);
    _SubCanvasSpec_Init(pass,__pRT__,snd);
    _TextEditorSpec_Init(pass,__pRT__,snd);
    _ThumbWheelSpec_Init(pass,__pRT__,snd);
    _ToggleSpec_Init(pass,__pRT__,snd);
    _TriggerBoxSpec_Init(pass,__pRT__,snd);
    _VariableHorizontalPanelSpec_Init(pass,__pRT__,snd);
    _VariableVerticalPanelSpec_Init(pass,__pRT__,snd);
    _VerticalPanelViewSpec_Init(pass,__pRT__,snd);
    _CheckToggleSpec_Init(pass,__pRT__,snd);
    _FileSelectionTreeSpec_Init(pass,__pRT__,snd);
    _NonScrollableArbitraryComponentSpec_Init(pass,__pRT__,snd);
    _RadioButtonSpec_Init(pass,__pRT__,snd);
    _SelectionInListModelViewSpec_Init(pass,__pRT__,snd);
    _TextCollectorSpec_Init(pass,__pRT__,snd);
    _UIGalleryViewSpec_Init(pass,__pRT__,snd);
    _WorkspaceSpec_Init(pass,__pRT__,snd);
    _CodeViewSpec_Init(pass,__pRT__,snd);
    _HierarchicalListViewSpec_Init(pass,__pRT__,snd);


  __END_PACKAGE__();
}
