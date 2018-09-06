# $Header: /cvs/stx/stx/goodies/communication/zeromq/Make.spec,v 1.4 2018-05-11 00:03:21 cg Exp $
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_goodies_communication_zeromq.
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
MODULE_DIR=goodies/communication/zeromq
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
	ZmqApi \
	ZmqApiConstants \
	ZmqApiContext \
	ZmqApiMessage \
	ZmqApiPollItem \
	ZmqApiPollItemV4 \
	ZmqApiSize \
	ZmqApiSocket \
	ZmqApiStructForInt \
	ZmqContext \
	ZmqEventFilter \
	ZmqLog \
	ZmqResource \
	ZmqSocket \
	ZmqSocketAssociation \
	ZmqTerminatedContext \
	ZmqVersion \
	stx_goodies_communication_zeromq \
	Zmq2Api \
	Zmq3Api \
	ZmqDealerSocket \
	ZmqGlobalPoller \
	ZmqPairSocket \
	ZmqPollIn \
	ZmqPollOut \
	ZmqPoller \
	ZmqPublisherSocket \
	ZmqPullSocket \
	ZmqPushSocket \
	ZmqRequestSocket \
	ZmqResponseSocket \
	ZmqRouterSocket \
	ZmqSocketBind \
	ZmqSocketConnection \
	ZmqSubscriberSocket \
	Zmq4Api \




COMMON_OBJS= \
    $(OUTDIR)ZmqApi.$(O) \
    $(OUTDIR)ZmqApiConstants.$(O) \
    $(OUTDIR)ZmqApiContext.$(O) \
    $(OUTDIR)ZmqApiMessage.$(O) \
    $(OUTDIR)ZmqApiPollItem.$(O) \
    $(OUTDIR)ZmqApiPollItemV4.$(O) \
    $(OUTDIR)ZmqApiSize.$(O) \
    $(OUTDIR)ZmqApiSocket.$(O) \
    $(OUTDIR)ZmqApiStructForInt.$(O) \
    $(OUTDIR)ZmqContext.$(O) \
    $(OUTDIR)ZmqEventFilter.$(O) \
    $(OUTDIR)ZmqLog.$(O) \
    $(OUTDIR)ZmqResource.$(O) \
    $(OUTDIR)ZmqSocket.$(O) \
    $(OUTDIR)ZmqSocketAssociation.$(O) \
    $(OUTDIR)ZmqTerminatedContext.$(O) \
    $(OUTDIR)ZmqVersion.$(O) \
    $(OUTDIR)stx_goodies_communication_zeromq.$(O) \
    $(OUTDIR)Zmq2Api.$(O) \
    $(OUTDIR)Zmq3Api.$(O) \
    $(OUTDIR)ZmqDealerSocket.$(O) \
    $(OUTDIR)ZmqGlobalPoller.$(O) \
    $(OUTDIR)ZmqPairSocket.$(O) \
    $(OUTDIR)ZmqPollIn.$(O) \
    $(OUTDIR)ZmqPollOut.$(O) \
    $(OUTDIR)ZmqPoller.$(O) \
    $(OUTDIR)ZmqPublisherSocket.$(O) \
    $(OUTDIR)ZmqPullSocket.$(O) \
    $(OUTDIR)ZmqPushSocket.$(O) \
    $(OUTDIR)ZmqRequestSocket.$(O) \
    $(OUTDIR)ZmqResponseSocket.$(O) \
    $(OUTDIR)ZmqRouterSocket.$(O) \
    $(OUTDIR)ZmqSocketBind.$(O) \
    $(OUTDIR)ZmqSocketConnection.$(O) \
    $(OUTDIR)ZmqSubscriberSocket.$(O) \
    $(OUTDIR)Zmq4Api.$(O) \



