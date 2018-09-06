# $Header: /cvs/stx/stx/goodies/magritte/seaside/bc.mak,v 1.3 2013-05-28 10:31:49 cg Exp $
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_goodies_magritte_seaside.
#
# Warning: once you modify this file, do not rerun
# stmkmp or projectDefinition-build again - otherwise, your changes are lost.
#
# This file contains make rules for the win32 platform (using borland-bcc).
# It shares common definitions with the unix-make in Make.spec.
# The nt.mak supports the following targets:
#    bmake         - compile all st-files to a classLib (dll)
#    bmake clean   - clean all temp files
#    bmake clobber - clean all
#
#
TOP=..\..\..
INCLUDE_TOP=$(TOP)\..

!INCLUDE $(TOP)\rules\stdHeader_bc

!INCLUDE Make.spec

LIBNAME=libstx_goodies_magritte_seaside
RESFILES=seaside.$(RES)



LOCALINCLUDES= -I$(INCLUDE_TOP)\stx\goodies\magritte -I$(INCLUDE_TOP)\stx\libbasic -I$(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4
LOCALDEFINES=

STCLOCALOPT=-package=$(PACKAGE) -I. $(LOCALINCLUDES) -H. $(STCLOCALOPTIMIZATIONS) $(STCWARNINGS) $(LOCALDEFINES)  -varPrefix=$(LIBNAME)
LOCALLIBS=

OBJS= $(COMMON_OBJS) $(WIN32_OBJS)

ALL::  classLibRule

classLibRule: $(OUTDIR) $(OUTDIR)$(LIBNAME).dll

!INCLUDE $(TOP)\rules\stdRules_bc

# build all prerequisite packages for this package
prereq:
	pushd ..\..\..\libbasic & bmake "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\webServer\comanche\seaside2_5b4 & bmake "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\libbasic2 & bmake "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\libview & bmake "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\libview2 & bmake "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\libui & bmake "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\libwidg & bmake "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd .. & bmake "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\librun & bmake "CFLAGS_LOCAL=$(GLOBALDEFINES) "




# BEGINMAKEDEPEND --- do not remove this line; make depend needs it
$(OUTDIR)Magritte__MAColumn.$(O) Magritte__MAColumn.$(H): Magritte__MAColumn.st $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MAComponent.$(O) Magritte__MAComponent.$(H): Magritte__MAComponent.st $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WAComponent.$(H) $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WAPresenter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MAComponentDecoration.$(O) Magritte__MAComponentDecoration.$(H): Magritte__MAComponentDecoration.st $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WADecoration.$(H) $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WAPresenter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MAComponentRenderer.$(O) Magritte__MAComponentRenderer.$(H): Magritte__MAComponentRenderer.st $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAVisitor.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MAExampleEditor.$(O) Magritte__MAExampleEditor.$(H): Magritte__MAExampleEditor.st $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WAComponent.$(H) $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WAPresenter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MAFileModelHandler.$(O) Magritte__MAFileModelHandler.$(H): Magritte__MAFileModelHandler.st $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WARequestHandler.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)stx_goodies_magritte_seaside.$(O) stx_goodies_magritte_seaside.$(H): stx_goodies_magritte_seaside.st $(INCLUDE_TOP)\stx\libbasic\LibraryDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\ProjectDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MAActionColumn.$(O) Magritte__MAActionColumn.$(H): Magritte__MAActionColumn.st $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAColumn.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MAColorChooser.$(O) Magritte__MAColorChooser.$(H): Magritte__MAColorChooser.st $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAComponent.$(H) $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WAComponent.$(H) $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WAPresenter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MAContainerDecoration.$(O) Magritte__MAContainerDecoration.$(H): Magritte__MAContainerDecoration.st $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAComponentDecoration.$(H) $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WADecoration.$(H) $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WAPresenter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MACssRenderer.$(O) Magritte__MACssRenderer.$(H): Magritte__MACssRenderer.st $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAComponentRenderer.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAVisitor.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MADescribedColumn.$(O) Magritte__MADescribedColumn.$(H): Magritte__MADescribedColumn.st $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAColumn.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MADescriptionComponent.$(O) Magritte__MADescriptionComponent.$(H): Magritte__MADescriptionComponent.st $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAComponent.$(H) $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WAComponent.$(H) $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WAPresenter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MADescriptionEditor.$(O) Magritte__MADescriptionEditor.$(H): Magritte__MADescriptionEditor.st $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAExampleEditor.$(H) $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WAComponent.$(H) $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WAPresenter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MAReport.$(O) Magritte__MAReport.$(H): Magritte__MAReport.st $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAComponent.$(H) $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WAComponent.$(H) $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WAPresenter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MATableRenderer.$(O) Magritte__MATableRenderer.$(H): Magritte__MATableRenderer.st $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAComponentRenderer.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAVisitor.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MAValidationDecoration.$(O) Magritte__MAValidationDecoration.$(H): Magritte__MAValidationDecoration.st $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAComponentDecoration.$(H) $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WADecoration.$(H) $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WAPresenter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MACommandColumn.$(O) Magritte__MACommandColumn.$(H): Magritte__MACommandColumn.st $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAActionColumn.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAColumn.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MAContainerComponent.$(O) Magritte__MAContainerComponent.$(H): Magritte__MAContainerComponent.st $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MADescriptionComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAComponent.$(H) $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WAComponent.$(H) $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WAPresenter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MADescribedComponentColumn.$(O) Magritte__MADescribedComponentColumn.$(H): Magritte__MADescribedComponentColumn.st $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MADescribedColumn.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAColumn.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MADescribedScalarColumn.$(O) Magritte__MADescribedScalarColumn.$(H): Magritte__MADescribedScalarColumn.st $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MADescribedColumn.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAColumn.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MAElementComponent.$(O) Magritte__MAElementComponent.$(H): Magritte__MAElementComponent.st $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MADescriptionComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAComponent.$(H) $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WAComponent.$(H) $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WAPresenter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MAFormDecoration.$(O) Magritte__MAFormDecoration.$(H): Magritte__MAFormDecoration.st $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAContainerDecoration.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAComponentDecoration.$(H) $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WADecoration.$(H) $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WAPresenter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MAReportComponent.$(O) Magritte__MAReportComponent.$(H): Magritte__MAReportComponent.st $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MADescriptionComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAComponent.$(H) $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WAComponent.$(H) $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WAPresenter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MASelectionColumn.$(O) Magritte__MASelectionColumn.$(H): Magritte__MASelectionColumn.st $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAActionColumn.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAColumn.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MASwitchDecoration.$(O) Magritte__MASwitchDecoration.$(H): Magritte__MASwitchDecoration.st $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAContainerDecoration.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAComponentDecoration.$(H) $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WADecoration.$(H) $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WAPresenter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MAToggleColumn.$(O) Magritte__MAToggleColumn.$(H): Magritte__MAToggleColumn.st $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MADescribedColumn.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAColumn.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MACheckboxColumn.$(O) Magritte__MACheckboxColumn.$(H): Magritte__MACheckboxColumn.st $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MASelectionColumn.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAActionColumn.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAColumn.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MACheckboxComponent.$(O) Magritte__MACheckboxComponent.$(H): Magritte__MACheckboxComponent.st $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAElementComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MADescriptionComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAComponent.$(H) $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WAComponent.$(H) $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WAPresenter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MAColorComponent.$(O) Magritte__MAColorComponent.$(H): Magritte__MAColorComponent.st $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAElementComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MADescriptionComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAComponent.$(H) $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WAComponent.$(H) $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WAPresenter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MAFileUploadComponent.$(O) Magritte__MAFileUploadComponent.$(H): Magritte__MAFileUploadComponent.st $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAElementComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MADescriptionComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAComponent.$(H) $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WAComponent.$(H) $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WAPresenter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MAIndexedCommandColumn.$(O) Magritte__MAIndexedCommandColumn.$(H): Magritte__MAIndexedCommandColumn.st $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MACommandColumn.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAActionColumn.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAColumn.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MAOptionComponent.$(O) Magritte__MAOptionComponent.$(H): Magritte__MAOptionComponent.st $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAElementComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MADescriptionComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAComponent.$(H) $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WAComponent.$(H) $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WAPresenter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MAOptionboxColumn.$(O) Magritte__MAOptionboxColumn.$(H): Magritte__MAOptionboxColumn.st $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MASelectionColumn.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAActionColumn.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAColumn.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MARangeComponent.$(O) Magritte__MARangeComponent.$(H): Magritte__MARangeComponent.st $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAElementComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MADescriptionComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAComponent.$(H) $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WAComponent.$(H) $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WAPresenter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MARelationComponent.$(O) Magritte__MARelationComponent.$(H): Magritte__MARelationComponent.st $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAElementComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MADescriptionComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAComponent.$(H) $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WAComponent.$(H) $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WAPresenter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MATableComponent.$(O) Magritte__MATableComponent.$(H): Magritte__MATableComponent.st $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAElementComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MADescriptionComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAComponent.$(H) $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WAComponent.$(H) $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WAPresenter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MATextAreaComponent.$(O) Magritte__MATextAreaComponent.$(H): Magritte__MATextAreaComponent.st $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAElementComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MADescriptionComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAComponent.$(H) $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WAComponent.$(H) $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WAPresenter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MATextInputComponent.$(O) Magritte__MATextInputComponent.$(H): Magritte__MATextInputComponent.st $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAElementComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MADescriptionComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAComponent.$(H) $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WAComponent.$(H) $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WAPresenter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MATextPasswordComponent.$(O) Magritte__MATextPasswordComponent.$(H): Magritte__MATextPasswordComponent.st $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAElementComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MADescriptionComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAComponent.$(H) $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WAComponent.$(H) $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WAPresenter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MAUndefinedComponent.$(O) Magritte__MAUndefinedComponent.$(H): Magritte__MAUndefinedComponent.st $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAElementComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MADescriptionComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAComponent.$(H) $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WAComponent.$(H) $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WAPresenter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MADateInputComponent.$(O) Magritte__MADateInputComponent.$(H): Magritte__MADateInputComponent.st $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MATextInputComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAElementComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MADescriptionComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAComponent.$(H) $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WAComponent.$(H) $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WAPresenter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MAMultipleSelectionComponent.$(O) Magritte__MAMultipleSelectionComponent.$(H): Magritte__MAMultipleSelectionComponent.st $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAOptionComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAElementComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MADescriptionComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAComponent.$(H) $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WAComponent.$(H) $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WAPresenter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MAOneToManyComponent.$(O) Magritte__MAOneToManyComponent.$(H): Magritte__MAOneToManyComponent.st $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MARelationComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAElementComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MADescriptionComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAComponent.$(H) $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WAComponent.$(H) $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WAPresenter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MAOneToOneComponent.$(O) Magritte__MAOneToOneComponent.$(H): Magritte__MAOneToOneComponent.st $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MARelationComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAElementComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MADescriptionComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAComponent.$(H) $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WAComponent.$(H) $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WAPresenter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MASingleSelectionComponent.$(O) Magritte__MASingleSelectionComponent.$(H): Magritte__MASingleSelectionComponent.st $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAOptionComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAElementComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MADescriptionComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAComponent.$(H) $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WAComponent.$(H) $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WAPresenter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MATimeInputComponent.$(O) Magritte__MATimeInputComponent.$(H): Magritte__MATimeInputComponent.st $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MATextInputComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAElementComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MADescriptionComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAComponent.$(H) $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WAComponent.$(H) $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WAPresenter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MATimeStampInputComponent.$(O) Magritte__MATimeStampInputComponent.$(H): Magritte__MATimeStampInputComponent.st $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MATextInputComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAElementComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MADescriptionComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAComponent.$(H) $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WAComponent.$(H) $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WAPresenter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MAVerifiedPasswordComponent.$(O) Magritte__MAVerifiedPasswordComponent.$(H): Magritte__MAVerifiedPasswordComponent.st $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MATextPasswordComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAElementComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MADescriptionComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAComponent.$(H) $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WAComponent.$(H) $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WAPresenter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MACheckboxGroupComponent.$(O) Magritte__MACheckboxGroupComponent.$(H): Magritte__MACheckboxGroupComponent.st $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAMultipleSelectionComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAOptionComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAElementComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MADescriptionComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAComponent.$(H) $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WAComponent.$(H) $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WAPresenter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MADateSelectorComponent.$(O) Magritte__MADateSelectorComponent.$(H): Magritte__MADateSelectorComponent.st $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MADateInputComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MATextInputComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAElementComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MADescriptionComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAComponent.$(H) $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WAComponent.$(H) $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WAPresenter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MAExternalEditorComponent.$(O) Magritte__MAExternalEditorComponent.$(H): Magritte__MAExternalEditorComponent.st $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAOneToOneComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MARelationComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAElementComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MADescriptionComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAComponent.$(H) $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WAComponent.$(H) $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WAPresenter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MAInternalEditorComponent.$(O) Magritte__MAInternalEditorComponent.$(H): Magritte__MAInternalEditorComponent.st $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAOneToOneComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MARelationComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAElementComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MADescriptionComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAComponent.$(H) $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WAComponent.$(H) $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WAPresenter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MAListCompositonComponent.$(O) Magritte__MAListCompositonComponent.$(H): Magritte__MAListCompositonComponent.st $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAMultipleSelectionComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAOptionComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAElementComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MADescriptionComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAComponent.$(H) $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WAComponent.$(H) $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WAPresenter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MAMultiselectListComponent.$(O) Magritte__MAMultiselectListComponent.$(H): Magritte__MAMultiselectListComponent.st $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAMultipleSelectionComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAOptionComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAElementComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MADescriptionComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAComponent.$(H) $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WAComponent.$(H) $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WAPresenter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MAOneToManyScalarComponent.$(O) Magritte__MAOneToManyScalarComponent.$(H): Magritte__MAOneToManyScalarComponent.st $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAOneToManyComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MARelationComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAElementComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MADescriptionComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAComponent.$(H) $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WAComponent.$(H) $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WAPresenter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MARadioGroupComponent.$(O) Magritte__MARadioGroupComponent.$(H): Magritte__MARadioGroupComponent.st $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MASingleSelectionComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAOptionComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAElementComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MADescriptionComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAComponent.$(H) $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WAComponent.$(H) $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WAPresenter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MASelectListComponent.$(O) Magritte__MASelectListComponent.$(H): Magritte__MASelectListComponent.st $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MASingleSelectionComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAOptionComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAElementComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MADescriptionComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAComponent.$(H) $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WAComponent.$(H) $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WAPresenter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Magritte__MATimeSelectorComponent.$(O) Magritte__MATimeSelectorComponent.$(H): Magritte__MATimeSelectorComponent.st $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MATimeInputComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MATextInputComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAElementComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MADescriptionComponent.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\seaside\Magritte__MAComponent.$(H) $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WAComponent.$(H) $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WAPresenter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)extensions.$(O): extensions.st $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAContainer.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MADescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAElementDescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAExternalFileModel.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAFileModel.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAMultipleErrors.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAValidationError.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAError.$(H) $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Symbol.$(H) $(INCLUDE_TOP)\stx\libbasic\String.$(H) $(INCLUDE_TOP)\stx\libbasic\CharacterArray.$(H) $(INCLUDE_TOP)\stx\libbasic\ByteArray.$(H) $(INCLUDE_TOP)\stx\libbasic\UninterpretedBytes.$(H) $(INCLUDE_TOP)\stx\libbasic\ArrayedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WAComponent.$(H) $(INCLUDE_TOP)\stx\goodies\webServer\comanche\seaside2_5b4\WAPresenter.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MABooleanDescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAClassDescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAColorDescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MADateDescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAMagnitudeDescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MADurationDescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAFileDescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAMemoDescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAStringDescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAMultipleOptionDescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAOptionDescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAReferenceDescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MANumberDescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAPasswordDescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MASingleOptionDescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MATableDescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MATimeDescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MATimeStampDescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAToManyRelationDescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MARelationDescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAToManyScalarRelationDescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MAToOneRelationDescription.$(H) $(INCLUDE_TOP)\stx\goodies\magritte\Magritte__MATokenDescription.$(H) $(STCHDR)

# ENDMAKEDEPEND --- do not remove this line