# $Header: /cvs/stx/stx/goodies/communication/jupyterTalk/Make.spec,v 1.7 2018-05-14 00:53:52 cg Exp $
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_goodies_communication_jupyterTalk.
#
# Warning: once you modify this file, do not rerun
# stmkmp or projectDefinition-build again - otherwise, your changes are lost.
#
# This file contains specifications which are common to all platforms.
#

# Do NOT CHANGE THESE DEFINITIONS
# (otherwise, ST/X will have a hard time to find out the packages location from its packageID,
#  to find the source code of a class and to find the library for a package)
MODULE=stx
MODULE_DIR=goodies/communication/jupyterTalk
PACKAGE=$(MODULE):$(MODULE_DIR)


# Argument(s) to the stc compiler (stc --usage).
#  -headerDir=. : create header files locally
#                (if removed, they will be created as common
#  -Pxxx       : defines the package
#  -Zxxx       : a prefix for variables within the classLib
#  -Dxxx       : defines passed to CC for inline C-code
#  -Ixxx       : include path passed to CC for inline C-code
#  +optspace   : optimized for space
#  +optspace2  : optimized more for space
#  +optspace3  : optimized even more for space
#  +optinline  : generate inline code for some ST constructs
#  +inlineNew  : additionally inline new
#  +inlineMath : additionally inline some floatPnt math stuff
#
# ********** OPTIONAL: MODIFY the next line(s) ***
# STCLOCALOPTIMIZATIONS=+optinline +inlineNew
# STCLOCALOPTIMIZATIONS=+optspace3
STCLOCALOPTIMIZATIONS=+optspace3


# Argument(s) to the stc compiler (stc --usage).
#  -warn            : no warnings
#  -warnNonStandard : no warnings about ST/X extensions
#  -warnEOLComments : no warnings about EOL comment extension
#  -warnPrivacy     : no warnings about privateClass extension
#  -warnUnused      : no warnings about unused variables
#
# ********** OPTIONAL: MODIFY the next line(s) ***
# STCWARNINGS=-warn
# STCWARNINGS=-warnNonStandard
# STCWARNINGS=-warnEOLComments
STCWARNINGS=-warnNonStandard

COMMON_CLASSES= \
	CommandLineHandler \
	IPDisplay \
	IPHMACException \
	IPMessageProcessor \
	IPMsg \
	IPSession \
	IPWidget \
	IPWidgetRegistry \
	IPWireMessage \
	IPharoKernel \
	SCJsonObject \
	stx_goodies_communication_jupyterTalk \
	IPCommInfoReplyMsg \
	IPCommMsg \
	IPDisplayDataMsg \
	IPExecuteErrorMsg \
	IPExecuteInputMsg \
	IPExecuteRequestReplayMsg \
	IPIOPubProcessor \
	IPIsCompleteReplyMsg \
	IPKernelInfoReplyMsg \
	IPKernelStatusMsg \
	IPShellProcessor \
	IPStdInProcessor \
	IPStreamMsg \
	IPWidgetModel \
	IPWidgetView \
	IPharoCommandLineHandler \
	IPCommCloseMsg \
	IPCommOpenMsg \
	IPControlProcessor \
	IPExecuteResultMsg \
	IPExecutionAbortedMsg \
	IPExecutionErrorMsg \
	IPExecutionOkMsg \
	IPKernelStatusBusyMsg \
	IPKernelStatusIdleMsg \
	IPKernelStatusStartingMsg \
	IPUpdateDisplayDataMsg \




COMMON_OBJS= \
    $(OUTDIR)CommandLineHandler.$(O) \
    $(OUTDIR)IPDisplay.$(O) \
    $(OUTDIR)IPHMACException.$(O) \
    $(OUTDIR)IPMessageProcessor.$(O) \
    $(OUTDIR)IPMsg.$(O) \
    $(OUTDIR)IPSession.$(O) \
    $(OUTDIR)IPWidget.$(O) \
    $(OUTDIR)IPWidgetRegistry.$(O) \
    $(OUTDIR)IPWireMessage.$(O) \
    $(OUTDIR)IPharoKernel.$(O) \
    $(OUTDIR)SCJsonObject.$(O) \
    $(OUTDIR)stx_goodies_communication_jupyterTalk.$(O) \
    $(OUTDIR)IPCommInfoReplyMsg.$(O) \
    $(OUTDIR)IPCommMsg.$(O) \
    $(OUTDIR)IPDisplayDataMsg.$(O) \
    $(OUTDIR)IPExecuteErrorMsg.$(O) \
    $(OUTDIR)IPExecuteInputMsg.$(O) \
    $(OUTDIR)IPExecuteRequestReplayMsg.$(O) \
    $(OUTDIR)IPIOPubProcessor.$(O) \
    $(OUTDIR)IPIsCompleteReplyMsg.$(O) \
    $(OUTDIR)IPKernelInfoReplyMsg.$(O) \
    $(OUTDIR)IPKernelStatusMsg.$(O) \
    $(OUTDIR)IPShellProcessor.$(O) \
    $(OUTDIR)IPStdInProcessor.$(O) \
    $(OUTDIR)IPStreamMsg.$(O) \
    $(OUTDIR)IPWidgetModel.$(O) \
    $(OUTDIR)IPWidgetView.$(O) \
    $(OUTDIR)IPharoCommandLineHandler.$(O) \
    $(OUTDIR)IPCommCloseMsg.$(O) \
    $(OUTDIR)IPCommOpenMsg.$(O) \
    $(OUTDIR)IPControlProcessor.$(O) \
    $(OUTDIR)IPExecuteResultMsg.$(O) \
    $(OUTDIR)IPExecutionAbortedMsg.$(O) \
    $(OUTDIR)IPExecutionErrorMsg.$(O) \
    $(OUTDIR)IPExecutionOkMsg.$(O) \
    $(OUTDIR)IPKernelStatusBusyMsg.$(O) \
    $(OUTDIR)IPKernelStatusIdleMsg.$(O) \
    $(OUTDIR)IPKernelStatusStartingMsg.$(O) \
    $(OUTDIR)IPUpdateDisplayDataMsg.$(O) \
    $(OUTDIR)extensions.$(O) \



