# $Header: /cvs/stx/stx/goodies/communication/zeromq/bc.mak,v 1.4 2018-05-11 00:03:26 cg Exp $
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_goodies_communication_zeromq.
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

LIBNAME=libstx_goodies_communication_zeromq
MODULE_PATH=goodies\communication\zeromq
RESFILES=stx_goodies_communication_zeromqWINrc.$(RES)



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
$(OUTDIR)ZmqApi.$(O) ZmqApi.$(C) ZmqApi.$(H): ZmqApi.st $(INCLUDE_TOP)\stx\libbasic\ExternalLibrary.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)ZmqApiConstants.$(O) ZmqApiConstants.$(C) ZmqApiConstants.$(H): ZmqApiConstants.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)ZmqApiContext.$(O) ZmqApiContext.$(C) ZmqApiContext.$(H): ZmqApiContext.st $(INCLUDE_TOP)\stx\libbasic\ArrayedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalBytes.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalStructure.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\UninterpretedBytes.$(H) $(STCHDR)
$(OUTDIR)ZmqApiMessage.$(O) ZmqApiMessage.$(C) ZmqApiMessage.$(H): ZmqApiMessage.st $(INCLUDE_TOP)\stx\libbasic\ArrayedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalBytes.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalStructure.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\UninterpretedBytes.$(H) $(STCHDR)
$(OUTDIR)ZmqApiPollItem.$(O) ZmqApiPollItem.$(C) ZmqApiPollItem.$(H): ZmqApiPollItem.st $(INCLUDE_TOP)\stx\libbasic\ArrayedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalBytes.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalStructure.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\UninterpretedBytes.$(H) $(STCHDR)
$(OUTDIR)ZmqApiPollItemV4.$(O) ZmqApiPollItemV4.$(C) ZmqApiPollItemV4.$(H): ZmqApiPollItemV4.st $(INCLUDE_TOP)\stx\libbasic\ArrayedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalBytes.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalStructure.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\UninterpretedBytes.$(H) $(STCHDR)
$(OUTDIR)ZmqApiSize.$(O) ZmqApiSize.$(C) ZmqApiSize.$(H): ZmqApiSize.st $(INCLUDE_TOP)\stx\libbasic\ArrayedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalBytes.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalStructure.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\UninterpretedBytes.$(H) $(STCHDR)
$(OUTDIR)ZmqApiSocket.$(O) ZmqApiSocket.$(C) ZmqApiSocket.$(H): ZmqApiSocket.st $(INCLUDE_TOP)\stx\libbasic\ArrayedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalBytes.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalStructure.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\UninterpretedBytes.$(H) $(STCHDR)
$(OUTDIR)ZmqApiStructForInt.$(O) ZmqApiStructForInt.$(C) ZmqApiStructForInt.$(H): ZmqApiStructForInt.st $(INCLUDE_TOP)\stx\libbasic\ArrayedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalBytes.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalStructure.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\UninterpretedBytes.$(H) $(STCHDR)
$(OUTDIR)ZmqContext.$(O) ZmqContext.$(C) ZmqContext.$(H): ZmqContext.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)ZmqEventFilter.$(O) ZmqEventFilter.$(C) ZmqEventFilter.$(H): ZmqEventFilter.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)ZmqLog.$(O) ZmqLog.$(C) ZmqLog.$(H): ZmqLog.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)ZmqResource.$(O) ZmqResource.$(C) ZmqResource.$(H): ZmqResource.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)ZmqSocket.$(O) ZmqSocket.$(C) ZmqSocket.$(H): ZmqSocket.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)ZmqSocketAssociation.$(O) ZmqSocketAssociation.$(C) ZmqSocketAssociation.$(H): ZmqSocketAssociation.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)ZmqTerminatedContext.$(O) ZmqTerminatedContext.$(C) ZmqTerminatedContext.$(H): ZmqTerminatedContext.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)ZmqVersion.$(O) ZmqVersion.$(C) ZmqVersion.$(H): ZmqVersion.st $(INCLUDE_TOP)\stx\libbasic\Magnitude.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)stx_goodies_communication_zeromq.$(O) stx_goodies_communication_zeromq.$(C) stx_goodies_communication_zeromq.$(H): stx_goodies_communication_zeromq.st $(INCLUDE_TOP)\stx\libbasic\LibraryDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\ProjectDefinition.$(H) $(STCHDR)
$(OUTDIR)Zmq2Api.$(O) Zmq2Api.$(C) Zmq2Api.$(H): Zmq2Api.st $(INCLUDE_TOP)\stx\goodies\communication\zeromq\ZmqApi.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalLibrary.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Zmq3Api.$(O) Zmq3Api.$(C) Zmq3Api.$(H): Zmq3Api.st $(INCLUDE_TOP)\stx\goodies\communication\zeromq\ZmqApi.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalLibrary.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)ZmqDealerSocket.$(O) ZmqDealerSocket.$(C) ZmqDealerSocket.$(H): ZmqDealerSocket.st $(INCLUDE_TOP)\stx\goodies\communication\zeromq\ZmqSocket.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)ZmqGlobalPoller.$(O) ZmqGlobalPoller.$(C) ZmqGlobalPoller.$(H): ZmqGlobalPoller.st $(INCLUDE_TOP)\stx\goodies\communication\zeromq\ZmqResource.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)ZmqPairSocket.$(O) ZmqPairSocket.$(C) ZmqPairSocket.$(H): ZmqPairSocket.st $(INCLUDE_TOP)\stx\goodies\communication\zeromq\ZmqSocket.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)ZmqPollIn.$(O) ZmqPollIn.$(C) ZmqPollIn.$(H): ZmqPollIn.st $(INCLUDE_TOP)\stx\goodies\communication\zeromq\ZmqEventFilter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)ZmqPollOut.$(O) ZmqPollOut.$(C) ZmqPollOut.$(H): ZmqPollOut.st $(INCLUDE_TOP)\stx\goodies\communication\zeromq\ZmqEventFilter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)ZmqPoller.$(O) ZmqPoller.$(C) ZmqPoller.$(H): ZmqPoller.st $(INCLUDE_TOP)\stx\goodies\communication\zeromq\ZmqResource.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)ZmqPublisherSocket.$(O) ZmqPublisherSocket.$(C) ZmqPublisherSocket.$(H): ZmqPublisherSocket.st $(INCLUDE_TOP)\stx\goodies\communication\zeromq\ZmqSocket.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)ZmqPullSocket.$(O) ZmqPullSocket.$(C) ZmqPullSocket.$(H): ZmqPullSocket.st $(INCLUDE_TOP)\stx\goodies\communication\zeromq\ZmqSocket.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)ZmqPushSocket.$(O) ZmqPushSocket.$(C) ZmqPushSocket.$(H): ZmqPushSocket.st $(INCLUDE_TOP)\stx\goodies\communication\zeromq\ZmqSocket.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)ZmqRequestSocket.$(O) ZmqRequestSocket.$(C) ZmqRequestSocket.$(H): ZmqRequestSocket.st $(INCLUDE_TOP)\stx\goodies\communication\zeromq\ZmqSocket.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)ZmqResponseSocket.$(O) ZmqResponseSocket.$(C) ZmqResponseSocket.$(H): ZmqResponseSocket.st $(INCLUDE_TOP)\stx\goodies\communication\zeromq\ZmqSocket.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)ZmqRouterSocket.$(O) ZmqRouterSocket.$(C) ZmqRouterSocket.$(H): ZmqRouterSocket.st $(INCLUDE_TOP)\stx\goodies\communication\zeromq\ZmqSocket.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)ZmqSocketBind.$(O) ZmqSocketBind.$(C) ZmqSocketBind.$(H): ZmqSocketBind.st $(INCLUDE_TOP)\stx\goodies\communication\zeromq\ZmqSocketAssociation.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)ZmqSocketConnection.$(O) ZmqSocketConnection.$(C) ZmqSocketConnection.$(H): ZmqSocketConnection.st $(INCLUDE_TOP)\stx\goodies\communication\zeromq\ZmqSocketAssociation.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)ZmqSubscriberSocket.$(O) ZmqSubscriberSocket.$(C) ZmqSubscriberSocket.$(H): ZmqSubscriberSocket.st $(INCLUDE_TOP)\stx\goodies\communication\zeromq\ZmqSocket.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Zmq4Api.$(O) Zmq4Api.$(C) Zmq4Api.$(H): Zmq4Api.st $(INCLUDE_TOP)\stx\goodies\communication\zeromq\Zmq3Api.$(H) $(INCLUDE_TOP)\stx\goodies\communication\zeromq\ZmqApi.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalLibrary.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)

# ENDMAKEDEPEND --- do not remove this line
