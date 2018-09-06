# $Header: /cvs/stx/stx/goodies/communication/ssdp/bc.mak,v 1.2 2018-05-13 18:16:33 cg Exp $
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_goodies_communication_ssdp.
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

LIBNAME=libstx_goodies_communication_ssdp
MODULE_PATH=goodies\communication\ssdp
RESFILES=stx_goodies_communication_ssdpWINrc.$(RES)



LOCALINCLUDES= -I$(INCLUDE_TOP)\stx\libbasic -I$(INCLUDE_TOP)\stx\libbasic2 -I$(INCLUDE_TOP)\stx\libcompat
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
	pushd ..\..\..\libbasic2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "







test: $(TOP)\goodies\builder\reports\
	pushd $(TOP)\goodies\builder\reports & $(MAKE_BAT)
	$(TOP)\goodies\builder\reports\report-runner.bat -D . -r Builder::TestReport -p $(PACKAGE)

clean::
	-del *.$(CSUFFIX)


# BEGINMAKEDEPEND --- do not remove this line; make depend needs it
$(OUTDIR)SSDPCache.$(O) SSDPCache.$(C) SSDPCache.$(H): SSDPCache.st $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\LinkedList.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(STCHDR)
$(OUTDIR)SSDPMessage.$(O) SSDPMessage.$(C) SSDPMessage.$(H): SSDPMessage.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SSDPParticipant.$(O) SSDPParticipant.$(C) SSDPParticipant.$(H): SSDPParticipant.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SSDPService.$(O) SSDPService.$(C) SSDPService.$(H): SSDPService.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)stx_goodies_communication_ssdp.$(O) stx_goodies_communication_ssdp.$(C) stx_goodies_communication_ssdp.$(H): stx_goodies_communication_ssdp.st $(INCLUDE_TOP)\stx\libbasic\LibraryDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\ProjectDefinition.$(H) $(STCHDR)
$(OUTDIR)SSDPAvailable.$(O) SSDPAvailable.$(C) SSDPAvailable.$(H): SSDPAvailable.st $(INCLUDE_TOP)\stx\goodies\communication\ssdp\SSDPMessage.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SSDPClient.$(O) SSDPClient.$(C) SSDPClient.$(H): SSDPClient.st $(INCLUDE_TOP)\stx\goodies\communication\ssdp\SSDPParticipant.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SSDPDiscoveryReply.$(O) SSDPDiscoveryReply.$(C) SSDPDiscoveryReply.$(H): SSDPDiscoveryReply.st $(INCLUDE_TOP)\stx\goodies\communication\ssdp\SSDPMessage.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SSDPDiscoveryRequest.$(O) SSDPDiscoveryRequest.$(C) SSDPDiscoveryRequest.$(H): SSDPDiscoveryRequest.st $(INCLUDE_TOP)\stx\goodies\communication\ssdp\SSDPMessage.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SSDPServer.$(O) SSDPServer.$(C) SSDPServer.$(H): SSDPServer.st $(INCLUDE_TOP)\stx\goodies\communication\ssdp\SSDPParticipant.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SSDPUnavailable.$(O) SSDPUnavailable.$(C) SSDPUnavailable.$(H): SSDPUnavailable.st $(INCLUDE_TOP)\stx\goodies\communication\ssdp\SSDPMessage.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)

# ENDMAKEDEPEND --- do not remove this line
