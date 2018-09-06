# $Header: /cvs/stx/stx/goodies/communication/jupyterTalk/bc.mak,v 1.7 2018-05-14 00:53:57 cg Exp $
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_goodies_communication_jupyterTalk.
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
TOP=..\..\..
INCLUDE_TOP=$(TOP)\..



!INCLUDE $(TOP)\rules\stdHeader_bc

!INCLUDE Make.spec

LIBNAME=libstx_goodies_communication_jupyterTalk
MODULE_PATH=goodies\communication\jupyterTalk
RESFILES=stx_goodies_communication_jupyterTalkWINrc.$(RES)



LOCALINCLUDES= -I$(INCLUDE_TOP)\stx\libbasic -I$(INCLUDE_TOP)\stx\libbasic2
LOCALDEFINES=

STCLOCALOPT=-package=$(PACKAGE) -I. $(LOCALINCLUDES) -headerDir=. $(STCLOCALOPTIMIZATIONS) $(STCWARNINGS) $(LOCALDEFINES)  -varPrefix=$(LIBNAME)
LOCALLIBS=

OBJS= $(COMMON_OBJS) $(WIN32_OBJS)

ALL::  classLibRule

classLibRule: $(OUTDIR) $(OUTDIR)$(LIBNAME).dll

!INCLUDE $(TOP)\rules\stdRules_bc

# build all mandatory prerequisite packages (containing superclasses) for this package
prereq:
	pushd ..\..\..\libbasic & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "







test: $(TOP)\goodies\builder\reports\
	pushd $(TOP)\goodies\builder\reports & $(MAKE_BAT)
	$(TOP)\goodies\builder\reports\report-runner.bat -D . -r Builder::TestReport -p $(PACKAGE)
        
clean::
	-del *.$(CSUFFIX)


# BEGINMAKEDEPEND --- do not remove this line; make depend needs it
$(OUTDIR)CommandLineHandler.$(O) CommandLineHandler.$(C) CommandLineHandler.$(H): CommandLineHandler.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)IPDisplay.$(O) IPDisplay.$(C) IPDisplay.$(H): IPDisplay.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)IPHMACException.$(O) IPHMACException.$(C) IPHMACException.$(H): IPHMACException.st $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)IPMessageProcessor.$(O) IPMessageProcessor.$(C) IPMessageProcessor.$(H): IPMessageProcessor.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)IPMsg.$(O) IPMsg.$(C) IPMsg.$(H): IPMsg.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)IPSession.$(O) IPSession.$(C) IPSession.$(H): IPSession.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)IPWidget.$(O) IPWidget.$(C) IPWidget.$(H): IPWidget.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)IPWidgetRegistry.$(O) IPWidgetRegistry.$(C) IPWidgetRegistry.$(H): IPWidgetRegistry.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)IPWireMessage.$(O) IPWireMessage.$(C) IPWireMessage.$(H): IPWireMessage.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)IPharoKernel.$(O) IPharoKernel.$(C) IPharoKernel.$(H): IPharoKernel.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SCJsonObject.$(O) SCJsonObject.$(C) SCJsonObject.$(H): SCJsonObject.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)stx_goodies_communication_jupyterTalk.$(O) stx_goodies_communication_jupyterTalk.$(C) stx_goodies_communication_jupyterTalk.$(H): stx_goodies_communication_jupyterTalk.st $(INCLUDE_TOP)\stx\libbasic\LibraryDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\ProjectDefinition.$(H) $(STCHDR)
$(OUTDIR)IPCommInfoReplyMsg.$(O) IPCommInfoReplyMsg.$(C) IPCommInfoReplyMsg.$(H): IPCommInfoReplyMsg.st $(INCLUDE_TOP)\stx\goodies\communication\jupyterTalk\IPMsg.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)IPCommMsg.$(O) IPCommMsg.$(C) IPCommMsg.$(H): IPCommMsg.st $(INCLUDE_TOP)\stx\goodies\communication\jupyterTalk\IPMsg.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)IPDisplayDataMsg.$(O) IPDisplayDataMsg.$(C) IPDisplayDataMsg.$(H): IPDisplayDataMsg.st $(INCLUDE_TOP)\stx\goodies\communication\jupyterTalk\IPMsg.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)IPExecuteErrorMsg.$(O) IPExecuteErrorMsg.$(C) IPExecuteErrorMsg.$(H): IPExecuteErrorMsg.st $(INCLUDE_TOP)\stx\goodies\communication\jupyterTalk\IPMsg.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)IPExecuteInputMsg.$(O) IPExecuteInputMsg.$(C) IPExecuteInputMsg.$(H): IPExecuteInputMsg.st $(INCLUDE_TOP)\stx\goodies\communication\jupyterTalk\IPMsg.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)IPExecuteRequestReplayMsg.$(O) IPExecuteRequestReplayMsg.$(C) IPExecuteRequestReplayMsg.$(H): IPExecuteRequestReplayMsg.st $(INCLUDE_TOP)\stx\goodies\communication\jupyterTalk\IPMsg.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)IPIOPubProcessor.$(O) IPIOPubProcessor.$(C) IPIOPubProcessor.$(H): IPIOPubProcessor.st $(INCLUDE_TOP)\stx\goodies\communication\jupyterTalk\IPMessageProcessor.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)IPIsCompleteReplyMsg.$(O) IPIsCompleteReplyMsg.$(C) IPIsCompleteReplyMsg.$(H): IPIsCompleteReplyMsg.st $(INCLUDE_TOP)\stx\goodies\communication\jupyterTalk\IPMsg.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)IPKernelInfoReplyMsg.$(O) IPKernelInfoReplyMsg.$(C) IPKernelInfoReplyMsg.$(H): IPKernelInfoReplyMsg.st $(INCLUDE_TOP)\stx\goodies\communication\jupyterTalk\IPMsg.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)IPKernelStatusMsg.$(O) IPKernelStatusMsg.$(C) IPKernelStatusMsg.$(H): IPKernelStatusMsg.st $(INCLUDE_TOP)\stx\goodies\communication\jupyterTalk\IPMsg.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)IPShellProcessor.$(O) IPShellProcessor.$(C) IPShellProcessor.$(H): IPShellProcessor.st $(INCLUDE_TOP)\stx\goodies\communication\jupyterTalk\IPMessageProcessor.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)IPStdInProcessor.$(O) IPStdInProcessor.$(C) IPStdInProcessor.$(H): IPStdInProcessor.st $(INCLUDE_TOP)\stx\goodies\communication\jupyterTalk\IPMessageProcessor.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)IPStreamMsg.$(O) IPStreamMsg.$(C) IPStreamMsg.$(H): IPStreamMsg.st $(INCLUDE_TOP)\stx\goodies\communication\jupyterTalk\IPMsg.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)IPWidgetModel.$(O) IPWidgetModel.$(C) IPWidgetModel.$(H): IPWidgetModel.st $(INCLUDE_TOP)\stx\goodies\communication\jupyterTalk\SCJsonObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)IPWidgetView.$(O) IPWidgetView.$(C) IPWidgetView.$(H): IPWidgetView.st $(INCLUDE_TOP)\stx\goodies\communication\jupyterTalk\SCJsonObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)IPharoCommandLineHandler.$(O) IPharoCommandLineHandler.$(C) IPharoCommandLineHandler.$(H): IPharoCommandLineHandler.st $(INCLUDE_TOP)\stx\goodies\communication\jupyterTalk\CommandLineHandler.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)IPCommCloseMsg.$(O) IPCommCloseMsg.$(C) IPCommCloseMsg.$(H): IPCommCloseMsg.st $(INCLUDE_TOP)\stx\goodies\communication\jupyterTalk\IPCommMsg.$(H) $(INCLUDE_TOP)\stx\goodies\communication\jupyterTalk\IPMsg.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)IPCommOpenMsg.$(O) IPCommOpenMsg.$(C) IPCommOpenMsg.$(H): IPCommOpenMsg.st $(INCLUDE_TOP)\stx\goodies\communication\jupyterTalk\IPCommMsg.$(H) $(INCLUDE_TOP)\stx\goodies\communication\jupyterTalk\IPMsg.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)IPControlProcessor.$(O) IPControlProcessor.$(C) IPControlProcessor.$(H): IPControlProcessor.st $(INCLUDE_TOP)\stx\goodies\communication\jupyterTalk\IPMessageProcessor.$(H) $(INCLUDE_TOP)\stx\goodies\communication\jupyterTalk\IPShellProcessor.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)IPExecuteResultMsg.$(O) IPExecuteResultMsg.$(C) IPExecuteResultMsg.$(H): IPExecuteResultMsg.st $(INCLUDE_TOP)\stx\goodies\communication\jupyterTalk\IPDisplayDataMsg.$(H) $(INCLUDE_TOP)\stx\goodies\communication\jupyterTalk\IPMsg.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)IPExecutionAbortedMsg.$(O) IPExecutionAbortedMsg.$(C) IPExecutionAbortedMsg.$(H): IPExecutionAbortedMsg.st $(INCLUDE_TOP)\stx\goodies\communication\jupyterTalk\IPExecuteRequestReplayMsg.$(H) $(INCLUDE_TOP)\stx\goodies\communication\jupyterTalk\IPMsg.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)IPExecutionErrorMsg.$(O) IPExecutionErrorMsg.$(C) IPExecutionErrorMsg.$(H): IPExecutionErrorMsg.st $(INCLUDE_TOP)\stx\goodies\communication\jupyterTalk\IPExecuteRequestReplayMsg.$(H) $(INCLUDE_TOP)\stx\goodies\communication\jupyterTalk\IPMsg.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)IPExecutionOkMsg.$(O) IPExecutionOkMsg.$(C) IPExecutionOkMsg.$(H): IPExecutionOkMsg.st $(INCLUDE_TOP)\stx\goodies\communication\jupyterTalk\IPExecuteRequestReplayMsg.$(H) $(INCLUDE_TOP)\stx\goodies\communication\jupyterTalk\IPMsg.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)IPKernelStatusBusyMsg.$(O) IPKernelStatusBusyMsg.$(C) IPKernelStatusBusyMsg.$(H): IPKernelStatusBusyMsg.st $(INCLUDE_TOP)\stx\goodies\communication\jupyterTalk\IPKernelStatusMsg.$(H) $(INCLUDE_TOP)\stx\goodies\communication\jupyterTalk\IPMsg.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)IPKernelStatusIdleMsg.$(O) IPKernelStatusIdleMsg.$(C) IPKernelStatusIdleMsg.$(H): IPKernelStatusIdleMsg.st $(INCLUDE_TOP)\stx\goodies\communication\jupyterTalk\IPKernelStatusMsg.$(H) $(INCLUDE_TOP)\stx\goodies\communication\jupyterTalk\IPMsg.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)IPKernelStatusStartingMsg.$(O) IPKernelStatusStartingMsg.$(C) IPKernelStatusStartingMsg.$(H): IPKernelStatusStartingMsg.st $(INCLUDE_TOP)\stx\goodies\communication\jupyterTalk\IPKernelStatusMsg.$(H) $(INCLUDE_TOP)\stx\goodies\communication\jupyterTalk\IPMsg.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)IPUpdateDisplayDataMsg.$(O) IPUpdateDisplayDataMsg.$(C) IPUpdateDisplayDataMsg.$(H): IPUpdateDisplayDataMsg.st $(INCLUDE_TOP)\stx\goodies\communication\jupyterTalk\IPDisplayDataMsg.$(H) $(INCLUDE_TOP)\stx\goodies\communication\jupyterTalk\IPMsg.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)extensions.$(O): extensions.st $(INCLUDE_TOP)\stx\goodies\communication\jupyterTalk\IPDisplay.$(H) $(INCLUDE_TOP)\stx\goodies\communication\jupyterTalk\IPSession.$(H) $(INCLUDE_TOP)\stx\goodies\communication\jupyterTalk\IPharoKernel.$(H) $(INCLUDE_TOP)\stx\libbasic\ArrayedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\CharacterArray.$(H) $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Dictionary.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\Set.$(H) $(INCLUDE_TOP)\stx\libbasic\String.$(H) $(INCLUDE_TOP)\stx\libbasic\UninterpretedBytes.$(H) $(STCHDR)

# ENDMAKEDEPEND --- do not remove this line
