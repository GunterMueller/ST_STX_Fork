# $Header: /cvs/stx/stx/libui/bc.mak,v 1.60 2018-07-05 10:59:09 lukas Exp $
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_libui.
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


# see stdHeader_bc for LIBUI_BASE
LIB_BASE=$(LIBUI_BASE)


!INCLUDE $(TOP)\rules\stdHeader_bc

!INCLUDE Make.spec

LIBNAME=libstx_libui
MODULE_PATH=libui
RESFILES=stx_libuiWINrc.$(RES)



LOCALINCLUDES= -I$(INCLUDE_TOP)\stx\libbasic -I$(INCLUDE_TOP)\stx\libview
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







test: $(TOP)\goodies\builder\reports\
	pushd $(TOP)\goodies\builder\reports & $(MAKE_BAT)
	$(TOP)\goodies\builder\reports\report-runner.bat -D . -r Builder::TestReport -p $(PACKAGE)
        
clean::
	-del *.$(CSUFFIX)


# BEGINMAKEDEPEND --- do not remove this line; make depend needs it
$(OUTDIR)AssistantPageSpec.$(O) AssistantPageSpec.$(C) AssistantPageSpec.$(H): AssistantPageSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DataSetColumnSpec.$(O) DataSetColumnSpec.$(C) DataSetColumnSpec.$(H): DataSetColumnSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SubChannelInfoSpec.$(O) SubChannelInfoSpec.$(C) SubChannelInfoSpec.$(H): SubChannelInfoSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)UIPalette.$(O) UIPalette.$(C) UIPalette.$(H): UIPalette.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)UISpecVisitor.$(O) UISpecVisitor.$(C) UISpecVisitor.$(H): UISpecVisitor.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)UISpecification.$(O) UISpecification.$(C) UISpecification.$(H): UISpecification.st $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Dictionary.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\IdentityDictionary.$(H) $(INCLUDE_TOP)\stx\libbasic\Notification.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\Query.$(H) $(INCLUDE_TOP)\stx\libbasic\Set.$(H) $(STCHDR)
$(OUTDIR)stx_libui.$(O) stx_libui.$(C) stx_libui.$(H): stx_libui.st $(INCLUDE_TOP)\stx\libbasic\LibraryDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\ProjectDefinition.$(H) $(STCHDR)
$(OUTDIR)ComponentSpec.$(O) ComponentSpec.$(C) ComponentSpec.$(H): ComponentSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(STCHDR)
$(OUTDIR)NoteBookSpec.$(O) NoteBookSpec.$(C) NoteBookSpec.$(H): NoteBookSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(STCHDR)
$(OUTDIR)UIEventCallbackSubSpec.$(O) UIEventCallbackSubSpec.$(C) UIEventCallbackSubSpec.$(H): UIEventCallbackSubSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(STCHDR)
$(OUTDIR)UnknownSpec.$(O) UnknownSpec.$(C) UnknownSpec.$(H): UnknownSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(STCHDR)
$(OUTDIR)CompositeSpec.$(O) CompositeSpec.$(C) CompositeSpec.$(H): CompositeSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(STCHDR)
$(OUTDIR)CompositeSpecCollection.$(O) CompositeSpecCollection.$(C) CompositeSpecCollection.$(H): CompositeSpecCollection.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(STCHDR)
$(OUTDIR)DividerSpec.$(O) DividerSpec.$(C) DividerSpec.$(H): DividerSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(STCHDR)
$(OUTDIR)NamedSpec.$(O) NamedSpec.$(C) NamedSpec.$(H): NamedSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(STCHDR)
$(OUTDIR)RegionSpec.$(O) RegionSpec.$(C) RegionSpec.$(H): RegionSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(STCHDR)
$(OUTDIR)SpecCollection.$(O) SpecCollection.$(C) SpecCollection.$(H): SpecCollection.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(STCHDR)
$(OUTDIR)TabControlSpec.$(O) TabControlSpec.$(C) TabControlSpec.$(H): TabControlSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\NoteBookSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(STCHDR)
$(OUTDIR)UISubSpecification.$(O) UISubSpecification.$(C) UISubSpecification.$(H): UISubSpecification.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(STCHDR)
$(OUTDIR)ViewWithLabelSpec.$(O) ViewWithLabelSpec.$(C) ViewWithLabelSpec.$(H): ViewWithLabelSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(STCHDR)
$(OUTDIR)ViewWithSubcomponentsSpec.$(O) ViewWithSubcomponentsSpec.$(C) ViewWithSubcomponentsSpec.$(H): ViewWithSubcomponentsSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(STCHDR)
$(OUTDIR)WindowSpec.$(O) WindowSpec.$(C) WindowSpec.$(H): WindowSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(STCHDR)
$(OUTDIR)ColorMenuSpec.$(O) ColorMenuSpec.$(C) ColorMenuSpec.$(H): ColorMenuSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\NamedSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(STCHDR)
$(OUTDIR)FontMenuSpec.$(O) FontMenuSpec.$(C) FontMenuSpec.$(H): FontMenuSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\NamedSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(STCHDR)
$(OUTDIR)FullSpec.$(O) FullSpec.$(C) FullSpec.$(H): FullSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(INCLUDE_TOP)\stx\libui\ViewWithSubcomponentsSpec.$(H) $(STCHDR)
$(OUTDIR)LabelSpec.$(O) LabelSpec.$(C) LabelSpec.$(H): LabelSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(INCLUDE_TOP)\stx\libui\ViewWithLabelSpec.$(H) $(STCHDR)
$(OUTDIR)MenuComponentSpec.$(O) MenuComponentSpec.$(C) MenuComponentSpec.$(H): MenuComponentSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\NamedSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(STCHDR)
$(OUTDIR)ProgressIndicatorSpec.$(O) ProgressIndicatorSpec.$(C) ProgressIndicatorSpec.$(H): ProgressIndicatorSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\NamedSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(STCHDR)
$(OUTDIR)ScrollableViewSpec.$(O) ScrollableViewSpec.$(C) ScrollableViewSpec.$(H): ScrollableViewSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(INCLUDE_TOP)\stx\libui\ViewWithSubcomponentsSpec.$(H) $(STCHDR)
$(OUTDIR)ScrollerSpec.$(O) ScrollerSpec.$(C) ScrollerSpec.$(H): ScrollerSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\NamedSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(STCHDR)
$(OUTDIR)SeparatorSpec.$(O) SeparatorSpec.$(C) SeparatorSpec.$(H): SeparatorSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\DividerSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(STCHDR)
$(OUTDIR)ViewSpec.$(O) ViewSpec.$(C) ViewSpec.$(H): ViewSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(INCLUDE_TOP)\stx\libui\ViewWithSubcomponentsSpec.$(H) $(STCHDR)
$(OUTDIR)ViewWithLabelAndModelSpec.$(O) ViewWithLabelAndModelSpec.$(C) ViewWithLabelAndModelSpec.$(H): ViewWithLabelAndModelSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(INCLUDE_TOP)\stx\libui\ViewWithLabelSpec.$(H) $(STCHDR)
$(OUTDIR)WidgetSpec.$(O) WidgetSpec.$(C) WidgetSpec.$(H): WidgetSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\NamedSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(STCHDR)
$(OUTDIR)ActionButtonSpec.$(O) ActionButtonSpec.$(C) ActionButtonSpec.$(H): ActionButtonSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(INCLUDE_TOP)\stx\libui\ViewWithLabelAndModelSpec.$(H) $(INCLUDE_TOP)\stx\libui\ViewWithLabelSpec.$(H) $(STCHDR)
$(OUTDIR)CheckBoxSpec.$(O) CheckBoxSpec.$(C) CheckBoxSpec.$(H): CheckBoxSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\NamedSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(INCLUDE_TOP)\stx\libui\WidgetSpec.$(H) $(STCHDR)
$(OUTDIR)ComboListSpec.$(O) ComboListSpec.$(C) ComboListSpec.$(H): ComboListSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\NamedSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(INCLUDE_TOP)\stx\libui\WidgetSpec.$(H) $(STCHDR)
$(OUTDIR)ExtendedComboBoxSpec.$(O) ExtendedComboBoxSpec.$(C) ExtendedComboBoxSpec.$(H): ExtendedComboBoxSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\NamedSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(INCLUDE_TOP)\stx\libui\WidgetSpec.$(H) $(STCHDR)
$(OUTDIR)FramedBoxSpec.$(O) FramedBoxSpec.$(C) FramedBoxSpec.$(H): FramedBoxSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(INCLUDE_TOP)\stx\libui\ViewSpec.$(H) $(INCLUDE_TOP)\stx\libui\ViewWithSubcomponentsSpec.$(H) $(STCHDR)
$(OUTDIR)InputFieldSpec.$(O) InputFieldSpec.$(C) InputFieldSpec.$(H): InputFieldSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\MenuComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\NamedSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(STCHDR)
$(OUTDIR)MenuPanelSpec.$(O) MenuPanelSpec.$(C) MenuPanelSpec.$(H): MenuPanelSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\MenuComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\NamedSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(STCHDR)
$(OUTDIR)PanelViewSpec.$(O) PanelViewSpec.$(C) PanelViewSpec.$(H): PanelViewSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(INCLUDE_TOP)\stx\libui\ViewSpec.$(H) $(INCLUDE_TOP)\stx\libui\ViewWithSubcomponentsSpec.$(H) $(STCHDR)
$(OUTDIR)PopUpListSpec.$(O) PopUpListSpec.$(C) PopUpListSpec.$(H): PopUpListSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(INCLUDE_TOP)\stx\libui\ViewWithLabelAndModelSpec.$(H) $(INCLUDE_TOP)\stx\libui\ViewWithLabelSpec.$(H) $(STCHDR)
$(OUTDIR)RoundProgressIndicatorSpec.$(O) RoundProgressIndicatorSpec.$(C) RoundProgressIndicatorSpec.$(H): RoundProgressIndicatorSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\NamedSpec.$(H) $(INCLUDE_TOP)\stx\libui\ProgressIndicatorSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(STCHDR)
$(OUTDIR)ScrollBarSpec.$(O) ScrollBarSpec.$(C) ScrollBarSpec.$(H): ScrollBarSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\NamedSpec.$(H) $(INCLUDE_TOP)\stx\libui\ScrollerSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(STCHDR)
$(OUTDIR)SliderSpec.$(O) SliderSpec.$(C) SliderSpec.$(H): SliderSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\NamedSpec.$(H) $(INCLUDE_TOP)\stx\libui\ScrollerSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(STCHDR)
$(OUTDIR)TabViewSpec.$(O) TabViewSpec.$(C) TabViewSpec.$(H): TabViewSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\MenuComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\NamedSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(STCHDR)
$(OUTDIR)TableViewSpec.$(O) TableViewSpec.$(C) TableViewSpec.$(H): TableViewSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\MenuComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\NamedSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(STCHDR)
$(OUTDIR)TransparentBoxSpec.$(O) TransparentBoxSpec.$(C) TransparentBoxSpec.$(H): TransparentBoxSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(INCLUDE_TOP)\stx\libui\ViewSpec.$(H) $(INCLUDE_TOP)\stx\libui\ViewWithSubcomponentsSpec.$(H) $(STCHDR)
$(OUTDIR)UpDownButtonSpec.$(O) UpDownButtonSpec.$(C) UpDownButtonSpec.$(H): UpDownButtonSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(INCLUDE_TOP)\stx\libui\ViewWithLabelAndModelSpec.$(H) $(INCLUDE_TOP)\stx\libui\ViewWithLabelSpec.$(H) $(STCHDR)
$(OUTDIR)VariablePanelSpec.$(O) VariablePanelSpec.$(C) VariablePanelSpec.$(H): VariablePanelSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(INCLUDE_TOP)\stx\libui\ViewSpec.$(H) $(INCLUDE_TOP)\stx\libui\ViewWithSubcomponentsSpec.$(H) $(STCHDR)
$(OUTDIR)ViewWithScrollerSpec.$(O) ViewWithScrollerSpec.$(C) ViewWithScrollerSpec.$(H): ViewWithScrollerSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\MenuComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\NamedSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(STCHDR)
$(OUTDIR)ArbitraryComponentSpec.$(O) ArbitraryComponentSpec.$(C) ArbitraryComponentSpec.$(H): ArbitraryComponentSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\MenuComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\NamedSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(INCLUDE_TOP)\stx\libui\ViewWithScrollerSpec.$(H) $(STCHDR)
$(OUTDIR)ArrowButtonSpec.$(O) ArrowButtonSpec.$(C) ArrowButtonSpec.$(H): ArrowButtonSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\ActionButtonSpec.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(INCLUDE_TOP)\stx\libui\ViewWithLabelAndModelSpec.$(H) $(INCLUDE_TOP)\stx\libui\ViewWithLabelSpec.$(H) $(STCHDR)
$(OUTDIR)ButtonSpec.$(O) ButtonSpec.$(C) ButtonSpec.$(H): ButtonSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\ActionButtonSpec.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(INCLUDE_TOP)\stx\libui\ViewWithLabelAndModelSpec.$(H) $(INCLUDE_TOP)\stx\libui\ViewWithLabelSpec.$(H) $(STCHDR)
$(OUTDIR)ComboBoxSpec.$(O) ComboBoxSpec.$(C) ComboBoxSpec.$(H): ComboBoxSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\InputFieldSpec.$(H) $(INCLUDE_TOP)\stx\libui\MenuComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\NamedSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(STCHDR)
$(OUTDIR)DataSetSpec.$(O) DataSetSpec.$(C) DataSetSpec.$(H): DataSetSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\MenuComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\NamedSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(INCLUDE_TOP)\stx\libui\ViewWithScrollerSpec.$(H) $(STCHDR)
$(OUTDIR)FilenameInputFieldSpec.$(O) FilenameInputFieldSpec.$(C) FilenameInputFieldSpec.$(H): FilenameInputFieldSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\InputFieldSpec.$(H) $(INCLUDE_TOP)\stx\libui\MenuComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\NamedSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(STCHDR)
$(OUTDIR)GridBagLayoutViewSpec.$(O) GridBagLayoutViewSpec.$(C) GridBagLayoutViewSpec.$(H): GridBagLayoutViewSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\PanelViewSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(INCLUDE_TOP)\stx\libui\ViewSpec.$(H) $(INCLUDE_TOP)\stx\libui\ViewWithSubcomponentsSpec.$(H) $(STCHDR)
$(OUTDIR)GroupBoxSpec.$(O) GroupBoxSpec.$(C) GroupBoxSpec.$(H): GroupBoxSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\FramedBoxSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(INCLUDE_TOP)\stx\libui\ViewSpec.$(H) $(INCLUDE_TOP)\stx\libui\ViewWithSubcomponentsSpec.$(H) $(STCHDR)
$(OUTDIR)HTMLViewSpec.$(O) HTMLViewSpec.$(C) HTMLViewSpec.$(H): HTMLViewSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\MenuComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\NamedSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(INCLUDE_TOP)\stx\libui\ViewWithScrollerSpec.$(H) $(STCHDR)
$(OUTDIR)HorizontalPanelViewSpec.$(O) HorizontalPanelViewSpec.$(C) HorizontalPanelViewSpec.$(H): HorizontalPanelViewSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\PanelViewSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(INCLUDE_TOP)\stx\libui\ViewSpec.$(H) $(INCLUDE_TOP)\stx\libui\ViewWithSubcomponentsSpec.$(H) $(STCHDR)
$(OUTDIR)LinkButtonSpec.$(O) LinkButtonSpec.$(C) LinkButtonSpec.$(H): LinkButtonSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\ActionButtonSpec.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(INCLUDE_TOP)\stx\libui\ViewWithLabelAndModelSpec.$(H) $(INCLUDE_TOP)\stx\libui\ViewWithLabelSpec.$(H) $(STCHDR)
$(OUTDIR)ListModelViewSpec.$(O) ListModelViewSpec.$(C) ListModelViewSpec.$(H): ListModelViewSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\MenuComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\NamedSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(INCLUDE_TOP)\stx\libui\ViewWithScrollerSpec.$(H) $(STCHDR)
$(OUTDIR)MenuButtonSpec.$(O) MenuButtonSpec.$(C) MenuButtonSpec.$(H): MenuButtonSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\PopUpListSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(INCLUDE_TOP)\stx\libui\ViewWithLabelAndModelSpec.$(H) $(INCLUDE_TOP)\stx\libui\ViewWithLabelSpec.$(H) $(STCHDR)
$(OUTDIR)MultiColumnPanelViewSpec.$(O) MultiColumnPanelViewSpec.$(C) MultiColumnPanelViewSpec.$(H): MultiColumnPanelViewSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\PanelViewSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(INCLUDE_TOP)\stx\libui\ViewSpec.$(H) $(INCLUDE_TOP)\stx\libui\ViewWithSubcomponentsSpec.$(H) $(STCHDR)
$(OUTDIR)NoteBookViewSpec.$(O) NoteBookViewSpec.$(C) NoteBookViewSpec.$(H): NoteBookViewSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\MenuComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\NamedSpec.$(H) $(INCLUDE_TOP)\stx\libui\TabViewSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(STCHDR)
$(OUTDIR)SelectionInTreeViewSpec.$(O) SelectionInTreeViewSpec.$(C) SelectionInTreeViewSpec.$(H): SelectionInTreeViewSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\MenuComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\NamedSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(INCLUDE_TOP)\stx\libui\ViewWithScrollerSpec.$(H) $(STCHDR)
$(OUTDIR)SequenceViewSpec.$(O) SequenceViewSpec.$(C) SequenceViewSpec.$(H): SequenceViewSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\MenuComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\NamedSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(INCLUDE_TOP)\stx\libui\ViewWithScrollerSpec.$(H) $(STCHDR)
$(OUTDIR)SteppingSliderSpec.$(O) SteppingSliderSpec.$(C) SteppingSliderSpec.$(H): SteppingSliderSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\NamedSpec.$(H) $(INCLUDE_TOP)\stx\libui\ScrollerSpec.$(H) $(INCLUDE_TOP)\stx\libui\SliderSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(STCHDR)
$(OUTDIR)SubCanvasSpec.$(O) SubCanvasSpec.$(C) SubCanvasSpec.$(H): SubCanvasSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\MenuComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\NamedSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(INCLUDE_TOP)\stx\libui\ViewWithScrollerSpec.$(H) $(STCHDR)
$(OUTDIR)TextEditorSpec.$(O) TextEditorSpec.$(C) TextEditorSpec.$(H): TextEditorSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\MenuComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\NamedSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(INCLUDE_TOP)\stx\libui\ViewWithScrollerSpec.$(H) $(STCHDR)
$(OUTDIR)ThumbWheelSpec.$(O) ThumbWheelSpec.$(C) ThumbWheelSpec.$(H): ThumbWheelSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\NamedSpec.$(H) $(INCLUDE_TOP)\stx\libui\ScrollerSpec.$(H) $(INCLUDE_TOP)\stx\libui\SliderSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(STCHDR)
$(OUTDIR)ToggleSpec.$(O) ToggleSpec.$(C) ToggleSpec.$(H): ToggleSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\ActionButtonSpec.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(INCLUDE_TOP)\stx\libui\ViewWithLabelAndModelSpec.$(H) $(INCLUDE_TOP)\stx\libui\ViewWithLabelSpec.$(H) $(STCHDR)
$(OUTDIR)TriggerBoxSpec.$(O) TriggerBoxSpec.$(C) TriggerBoxSpec.$(H): TriggerBoxSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\CheckBoxSpec.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\NamedSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(INCLUDE_TOP)\stx\libui\WidgetSpec.$(H) $(STCHDR)
$(OUTDIR)VariableHorizontalPanelSpec.$(O) VariableHorizontalPanelSpec.$(C) VariableHorizontalPanelSpec.$(H): VariableHorizontalPanelSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(INCLUDE_TOP)\stx\libui\VariablePanelSpec.$(H) $(INCLUDE_TOP)\stx\libui\ViewSpec.$(H) $(INCLUDE_TOP)\stx\libui\ViewWithSubcomponentsSpec.$(H) $(STCHDR)
$(OUTDIR)VariableVerticalPanelSpec.$(O) VariableVerticalPanelSpec.$(C) VariableVerticalPanelSpec.$(H): VariableVerticalPanelSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(INCLUDE_TOP)\stx\libui\VariablePanelSpec.$(H) $(INCLUDE_TOP)\stx\libui\ViewSpec.$(H) $(INCLUDE_TOP)\stx\libui\ViewWithSubcomponentsSpec.$(H) $(STCHDR)
$(OUTDIR)VerticalPanelViewSpec.$(O) VerticalPanelViewSpec.$(C) VerticalPanelViewSpec.$(H): VerticalPanelViewSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\PanelViewSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(INCLUDE_TOP)\stx\libui\ViewSpec.$(H) $(INCLUDE_TOP)\stx\libui\ViewWithSubcomponentsSpec.$(H) $(STCHDR)
$(OUTDIR)CheckToggleSpec.$(O) CheckToggleSpec.$(C) CheckToggleSpec.$(H): CheckToggleSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\ActionButtonSpec.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\ToggleSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(INCLUDE_TOP)\stx\libui\ViewWithLabelAndModelSpec.$(H) $(INCLUDE_TOP)\stx\libui\ViewWithLabelSpec.$(H) $(STCHDR)
$(OUTDIR)FileSelectionTreeSpec.$(O) FileSelectionTreeSpec.$(C) FileSelectionTreeSpec.$(H): FileSelectionTreeSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\MenuComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\NamedSpec.$(H) $(INCLUDE_TOP)\stx\libui\SelectionInTreeViewSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(INCLUDE_TOP)\stx\libui\ViewWithScrollerSpec.$(H) $(STCHDR)
$(OUTDIR)NonScrollableArbitraryComponentSpec.$(O) NonScrollableArbitraryComponentSpec.$(C) NonScrollableArbitraryComponentSpec.$(H): NonScrollableArbitraryComponentSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\ArbitraryComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\MenuComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\NamedSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(INCLUDE_TOP)\stx\libui\ViewWithScrollerSpec.$(H) $(STCHDR)
$(OUTDIR)RadioButtonSpec.$(O) RadioButtonSpec.$(C) RadioButtonSpec.$(H): RadioButtonSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\ActionButtonSpec.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\ToggleSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(INCLUDE_TOP)\stx\libui\ViewWithLabelAndModelSpec.$(H) $(INCLUDE_TOP)\stx\libui\ViewWithLabelSpec.$(H) $(STCHDR)
$(OUTDIR)SelectionInListModelViewSpec.$(O) SelectionInListModelViewSpec.$(C) SelectionInListModelViewSpec.$(H): SelectionInListModelViewSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\ListModelViewSpec.$(H) $(INCLUDE_TOP)\stx\libui\MenuComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\NamedSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(INCLUDE_TOP)\stx\libui\ViewWithScrollerSpec.$(H) $(STCHDR)
$(OUTDIR)TextCollectorSpec.$(O) TextCollectorSpec.$(C) TextCollectorSpec.$(H): TextCollectorSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\MenuComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\NamedSpec.$(H) $(INCLUDE_TOP)\stx\libui\TextEditorSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(INCLUDE_TOP)\stx\libui\ViewWithScrollerSpec.$(H) $(STCHDR)
$(OUTDIR)UIGalleryViewSpec.$(O) UIGalleryViewSpec.$(C) UIGalleryViewSpec.$(H): UIGalleryViewSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\MenuComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\NamedSpec.$(H) $(INCLUDE_TOP)\stx\libui\NoteBookViewSpec.$(H) $(INCLUDE_TOP)\stx\libui\TabViewSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(STCHDR)
$(OUTDIR)WorkspaceSpec.$(O) WorkspaceSpec.$(C) WorkspaceSpec.$(H): WorkspaceSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\MenuComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\NamedSpec.$(H) $(INCLUDE_TOP)\stx\libui\TextEditorSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(INCLUDE_TOP)\stx\libui\ViewWithScrollerSpec.$(H) $(STCHDR)
$(OUTDIR)CodeViewSpec.$(O) CodeViewSpec.$(C) CodeViewSpec.$(H): CodeViewSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\MenuComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\NamedSpec.$(H) $(INCLUDE_TOP)\stx\libui\TextEditorSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(INCLUDE_TOP)\stx\libui\ViewWithScrollerSpec.$(H) $(INCLUDE_TOP)\stx\libui\WorkspaceSpec.$(H) $(STCHDR)
$(OUTDIR)HierarchicalListViewSpec.$(O) HierarchicalListViewSpec.$(C) HierarchicalListViewSpec.$(H): HierarchicalListViewSpec.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libui\ComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\ListModelViewSpec.$(H) $(INCLUDE_TOP)\stx\libui\MenuComponentSpec.$(H) $(INCLUDE_TOP)\stx\libui\NamedSpec.$(H) $(INCLUDE_TOP)\stx\libui\SelectionInListModelViewSpec.$(H) $(INCLUDE_TOP)\stx\libui\UISpecification.$(H) $(INCLUDE_TOP)\stx\libui\ViewWithScrollerSpec.$(H) $(STCHDR)

# ENDMAKEDEPEND --- do not remove this line
