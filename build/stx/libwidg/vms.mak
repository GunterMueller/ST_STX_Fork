#
# DO NOT EDIT 
# automatically generated from Make.proto
#
# $Header: /cvs/stx/stx/libwidg/vms.mak,v 1.3 1999-09-18 14:16:26 cg Exp $
#
TOP=..
LIBNAME=libwidg
STCOPT="+optspace2 -warnNonStandard -warnNonStandard"
STCLOCALOPT=-package=stx:$(LIBNAME) $(COMMONSYMBOLS) $(SEPINITCODE) $(RELOCINSTVARS) -varPrefix=$(LIBNAME)
ALL: $(LIBDIR)\$(LIBNAME).olb

OBJS=\
  $(OUTDIR)ListView.$(O) \
  $(OUTDIR)PanelView.$(O) \
  $(OUTDIR)ScrollableView.$(O) \
  $(OUTDIR)HVScrollableView.$(O) \
  $(OUTDIR)SequenceView.$(O) \
  $(OUTDIR)Label.$(O) \
  $(OUTDIR)Scroller.$(O) \
  $(OUTDIR)MiniScroller.$(O) \
  $(OUTDIR)ScrollBar.$(O) \
  $(OUTDIR)ObjectView.$(O) \
  $(OUTDIR)PopUpMenu.$(O) \
  $(OUTDIR)DialogBox.$(O) \
  $(OUTDIR)InfoBox.$(O) \
  $(OUTDIR)TextView.$(O) \
  $(OUTDIR)SelectionInListView.$(O) \
  $(OUTDIR)HorizontalPanelView.$(O) \
  $(OUTDIR)VerticalPanelView.$(O) \
  $(OUTDIR)VariablePanel.$(O) \
  $(OUTDIR)VariableVerticalPanel.$(O) \
  $(OUTDIR)VariableHorizontalPanel.$(O) \
  $(OUTDIR)Button.$(O) \
  $(OUTDIR)ArrowButton.$(O) \
  $(OUTDIR)HorizontalScroller.$(O) \
  $(OUTDIR)HorizontalMiniScroller.$(O) \
  $(OUTDIR)HorizontalScrollBar.$(O) \
  $(OUTDIR)EnterBox.$(O) \
  $(OUTDIR)WarningBox.$(O) \
  $(OUTDIR)YesNoBox.$(O) \
  $(OUTDIR)MenuView.$(O) \
  $(OUTDIR)FileSelectionList.$(O) \
  $(OUTDIR)EditTextView.$(O) \
  $(OUTDIR)Toggle.$(O) \
  $(OUTDIR)ListSelectionBox.$(O) \
  $(OUTDIR)EnterBox2.$(O) \
  $(OUTDIR)EditField.$(O) \
  $(OUTDIR)TextCollector.$(O) \
  $(OUTDIR)Workspace.$(O) \
  $(OUTDIR)CodeView.$(O) \
  $(OUTDIR)FileSelectionBox.$(O) \
  $(OUTDIR)PullDownMenu.$(O) \
  $(OUTDIR)OptionBox.$(O) \
  $(OUTDIR)CheckToggle.$(O) \
  $(OUTDIR)CheckLabel.$(O) \
  $(OUTDIR)FileSaveBox.$(O) \
  $(OUTDIR)ButtonController.$(O) \
  $(OUTDIR)PopUpListController.$(O) \
  $(OUTDIR)ToggleController.$(O) \
  $(OUTDIR)RadioButtonController.$(O) \
  $(OUTDIR)ClickMenuView.$(O) \
  $(OUTDIR)EnterFieldGroup.$(O) \
  $(OUTDIR)FontPanel.$(O) \
  $(OUTDIR)PopUpList.$(O) \
  $(OUTDIR)FramedBox.$(O) \
  $(OUTDIR)RadioButtonGroup.$(O) \
  $(OUTDIR)RadioButton.$(O) \
  $(OUTDIR)VariablePanelController.$(O) \
  $(OUTDIR)VariableVerticalPanelController.$(O) \
  $(OUTDIR)VariableHorizontalPanelController.$(O) \
  $(OUTDIR)SelectionInList.$(O) \
  $(OUTDIR)MultiSelectionInList.$(O) \


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
$(OUTDIR)ArrowButton.$(O) ArrowButton.$(H): ArrowButton.st $(STCHDR)  ../include/Button.$(H)  ../include/Label.$(H)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)Button.$(O) Button.$(H): Button.st $(STCHDR)  ../include/Label.$(H)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)ButtonController.$(O) ButtonController.$(H): ButtonController.st $(STCHDR)  ../include/Controller.$(H)  ../include/Object.$(H) 
$(OUTDIR)CheckLabel.$(O) CheckLabel.$(H): CheckLabel.st $(STCHDR)  ../include/Label.$(H)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)CheckToggle.$(O) CheckToggle.$(H): CheckToggle.st $(STCHDR)  ../include/Toggle.$(H)  ../include/Button.$(H)  ../include/Label.$(H)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)ClickMenuView.$(O) ClickMenuView.$(H): ClickMenuView.st $(STCHDR)  ../include/MenuView.$(H)  ../include/SelectionInListView.$(H)  ../include/ListView.$(H)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)CodeView.$(O) CodeView.$(H): CodeView.st $(STCHDR)  ../include/Workspace.$(H)  ../include/TextCollector.$(H)  ../include/EditTextView.$(H)  ../include/TextView.$(H)  ../include/ListView.$(H)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)DialogBox.$(O) DialogBox.$(H): DialogBox.st $(STCHDR)  ../include/ModalBox.$(H)  ../include/StandardSystemView.$(H)  ../include/TopView.$(H)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)EditField.$(O) EditField.$(H): EditField.st $(STCHDR)  ../include/EditTextView.$(H)  ../include/TextView.$(H)  ../include/ListView.$(H)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)EditTextView.$(O) EditTextView.$(H): EditTextView.st $(STCHDR)  ../include/TextView.$(H)  ../include/ListView.$(H)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)EnterBox.$(O) EnterBox.$(H): EnterBox.st $(STCHDR)  ../include/DialogBox.$(H)  ../include/ModalBox.$(H)  ../include/StandardSystemView.$(H)  ../include/TopView.$(H)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)EnterBox2.$(O) EnterBox2.$(H): EnterBox2.st $(STCHDR)  ../include/EnterBox.$(H)  ../include/DialogBox.$(H)  ../include/ModalBox.$(H)  ../include/StandardSystemView.$(H)  ../include/TopView.$(H)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)EnterFieldGroup.$(O) EnterFieldGroup.$(H): EnterFieldGroup.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)FileSaveBox.$(O) FileSaveBox.$(H): FileSaveBox.st $(STCHDR)  ../include/FileSelectionBox.$(H)  ../include/ListSelectionBox.$(H)  ../include/EnterBox.$(H)  ../include/DialogBox.$(H)  ../include/ModalBox.$(H)  ../include/StandardSystemView.$(H)  ../include/TopView.$(H)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)FileSelectionBox.$(O) FileSelectionBox.$(H): FileSelectionBox.st $(STCHDR)  ../include/ListSelectionBox.$(H)  ../include/EnterBox.$(H)  ../include/DialogBox.$(H)  ../include/ModalBox.$(H)  ../include/StandardSystemView.$(H)  ../include/TopView.$(H)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)FileSelectionList.$(O) FileSelectionList.$(H): FileSelectionList.st $(STCHDR)  ../include/SelectionInListView.$(H)  ../include/ListView.$(H)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)FontPanel.$(O) FontPanel.$(H): FontPanel.st $(STCHDR)  ../include/DialogBox.$(H)  ../include/ModalBox.$(H)  ../include/StandardSystemView.$(H)  ../include/TopView.$(H)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)FramedBox.$(O) FramedBox.$(H): FramedBox.st $(STCHDR)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)HVScrollableView.$(O) HVScrollableView.$(H): HVScrollableView.st $(STCHDR)  ../include/ScrollableView.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)HorizontalMiniScroller.$(O) HorizontalMiniScroller.$(H): HorizontalMiniScroller.st $(STCHDR)  ../include/MiniScroller.$(H)  ../include/Scroller.$(H)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)HorizontalPanelView.$(O) HorizontalPanelView.$(H): HorizontalPanelView.st $(STCHDR)  ../include/PanelView.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)HorizontalScrollBar.$(O) HorizontalScrollBar.$(H): HorizontalScrollBar.st $(STCHDR)  ../include/ScrollBar.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)HorizontalScroller.$(O) HorizontalScroller.$(H): HorizontalScroller.st $(STCHDR)  ../include/Scroller.$(H)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)InfoBox.$(O) InfoBox.$(H): InfoBox.st $(STCHDR)  ../include/DialogBox.$(H)  ../include/ModalBox.$(H)  ../include/StandardSystemView.$(H)  ../include/TopView.$(H)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)Label.$(O) Label.$(H): Label.st $(STCHDR)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)ListSelectionBox.$(O) ListSelectionBox.$(H): ListSelectionBox.st $(STCHDR)  ../include/EnterBox.$(H)  ../include/DialogBox.$(H)  ../include/ModalBox.$(H)  ../include/StandardSystemView.$(H)  ../include/TopView.$(H)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)ListView.$(O) ListView.$(H): ListView.st $(STCHDR)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)ListViewController.$(O) ListViewController.$(H): ListViewController.st $(STCHDR)  ../include/Controller.$(H)  ../include/Object.$(H) 
$(OUTDIR)MenuView.$(O) MenuView.$(H): MenuView.st $(STCHDR)  ../include/SelectionInListView.$(H)  ../include/ListView.$(H)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)MiniScroller.$(O) MiniScroller.$(H): MiniScroller.st $(STCHDR)  ../include/Scroller.$(H)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)MultiSelectionInList.$(O) MultiSelectionInList.$(H): MultiSelectionInList.st $(STCHDR)  ../include/SelectionInList.$(H)  ../include/ValueHolder.$(H)  ../include/ValueModel.$(H)  ../include/Model.$(H)  ../include/Object.$(H) 
$(OUTDIR)ObjectView.$(O) ObjectView.$(H): ObjectView.st $(STCHDR)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)OptionBox.$(O) OptionBox.$(H): OptionBox.st $(STCHDR)  ../include/DialogBox.$(H)  ../include/ModalBox.$(H)  ../include/StandardSystemView.$(H)  ../include/TopView.$(H)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)PanelView.$(O) PanelView.$(H): PanelView.st $(STCHDR)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)PopUpList.$(O) PopUpList.$(H): PopUpList.st $(STCHDR)  ../include/Button.$(H)  ../include/Label.$(H)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)PopUpListController.$(O) PopUpListController.$(H): PopUpListController.st $(STCHDR)  ../include/ButtonController.$(H)  ../include/Controller.$(H)  ../include/Object.$(H) 
$(OUTDIR)PopUpMenu.$(O) PopUpMenu.$(H): PopUpMenu.st $(STCHDR)  ../include/PopUpView.$(H)  ../include/TopView.$(H)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)PullDownMenu.$(O) PullDownMenu.$(H): PullDownMenu.st $(STCHDR)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)RadioButton.$(O) RadioButton.$(H): RadioButton.st $(STCHDR)  ../include/Toggle.$(H)  ../include/Button.$(H)  ../include/Label.$(H)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)RadioButtonController.$(O) RadioButtonController.$(H): RadioButtonController.st $(STCHDR)  ../include/ToggleController.$(H)  ../include/ButtonController.$(H)  ../include/Controller.$(H)  ../include/Object.$(H) 
$(OUTDIR)RadioButtonGroup.$(O) RadioButtonGroup.$(H): RadioButtonGroup.st $(STCHDR)  ../include/ValueHolder.$(H)  ../include/ValueModel.$(H)  ../include/Model.$(H)  ../include/Object.$(H) 
$(OUTDIR)ScrollBar.$(O) ScrollBar.$(H): ScrollBar.st $(STCHDR)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)ScrollableView.$(O) ScrollableView.$(H): ScrollableView.st $(STCHDR)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)Scroller.$(O) Scroller.$(H): Scroller.st $(STCHDR)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)SelectionInList.$(O) SelectionInList.$(H): SelectionInList.st $(STCHDR)  ../include/ValueHolder.$(H)  ../include/ValueModel.$(H)  ../include/Model.$(H)  ../include/Object.$(H) 
$(OUTDIR)SelectionInListView.$(O) SelectionInListView.$(H): SelectionInListView.st $(STCHDR)  ../include/ListView.$(H)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)SequenceView.$(O) SequenceView.$(H): SequenceView.st $(STCHDR)  ../include/ScrollableView.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)TextCollector.$(O) TextCollector.$(H): TextCollector.st $(STCHDR)  ../include/EditTextView.$(H)  ../include/TextView.$(H)  ../include/ListView.$(H)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)TextView.$(O) TextView.$(H): TextView.st $(STCHDR)  ../include/ListView.$(H)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)Toggle.$(O) Toggle.$(H): Toggle.st $(STCHDR)  ../include/Button.$(H)  ../include/Label.$(H)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)ToggleController.$(O) ToggleController.$(H): ToggleController.st $(STCHDR)  ../include/ButtonController.$(H)  ../include/Controller.$(H)  ../include/Object.$(H) 
$(OUTDIR)VariableHorizontalPanel.$(O) VariableHorizontalPanel.$(H): VariableHorizontalPanel.st $(STCHDR)  ../include/VariablePanel.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)VariableHorizontalPanelController.$(O) VariableHorizontalPanelController.$(H): VariableHorizontalPanelController.st $(STCHDR)  ../include/VariablePanelController.$(H)  ../include/Controller.$(H)  ../include/Object.$(H) 
$(OUTDIR)VariablePanel.$(O) VariablePanel.$(H): VariablePanel.st $(STCHDR)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)VariablePanelController.$(O) VariablePanelController.$(H): VariablePanelController.st $(STCHDR)  ../include/Controller.$(H)  ../include/Object.$(H) 
$(OUTDIR)VariableVerticalPanel.$(O) VariableVerticalPanel.$(H): VariableVerticalPanel.st $(STCHDR)  ../include/VariablePanel.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)VariableVerticalPanelController.$(O) VariableVerticalPanelController.$(H): VariableVerticalPanelController.st $(STCHDR)  ../include/VariablePanelController.$(H)  ../include/Controller.$(H)  ../include/Object.$(H) 
$(OUTDIR)VerticalPanelView.$(O) VerticalPanelView.$(H): VerticalPanelView.st $(STCHDR)  ../include/PanelView.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)WarningBox.$(O) WarningBox.$(H): WarningBox.st $(STCHDR)  ../include/InfoBox.$(H)  ../include/DialogBox.$(H)  ../include/ModalBox.$(H)  ../include/StandardSystemView.$(H)  ../include/TopView.$(H)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)Workspace.$(O) Workspace.$(H): Workspace.st $(STCHDR)  ../include/TextCollector.$(H)  ../include/EditTextView.$(H)  ../include/TextView.$(H)  ../include/ListView.$(H)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)YesNoBox.$(O) YesNoBox.$(H): YesNoBox.st $(STCHDR)  ../include/WarningBox.$(H)  ../include/InfoBox.$(H)  ../include/DialogBox.$(H)  ../include/ModalBox.$(H)  ../include/StandardSystemView.$(H)  ../include/TopView.$(H)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
# ENDMAKEDEPEND
