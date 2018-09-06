# $Header: /cvs/stx/stx/goodies/communication/parrotTalk/bc.mak,v 1.1 2018-05-14 00:19:16 cg Exp $
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_goodies_communication_parrotTalk.
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

LIBNAME=libstx_goodies_communication_parrotTalk
MODULE_PATH=goodies\communication\parrotTalk
RESFILES=stx_goodies_communication_parrotTalkWINrc.$(RES)



LOCALINCLUDES= -I$(INCLUDE_TOP)\exept\libcrypt -I$(INCLUDE_TOP)\stx\libbasic -I$(INCLUDE_TOP)\stx\libbasic2 -I$(INCLUDE_TOP)\stx\libcompat
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
$(OUTDIR)Parrot__CipherThunkMaker.$(O) Parrot__CipherThunkMaker.$(C) Parrot__CipherThunkMaker.$(H): Parrot__CipherThunkMaker.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Parrot__Frame.$(O) Parrot__Frame.$(C) Parrot__Frame.$(H): Parrot__Frame.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Parrot__InetSocketAddress.$(O) Parrot__InetSocketAddress.$(C) Parrot__InetSocketAddress.$(H): Parrot__InetSocketAddress.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Parrot__ParrotPercentEncoder.$(O) Parrot__ParrotPercentEncoder.$(C) Parrot__ParrotPercentEncoder.$(H): Parrot__ParrotPercentEncoder.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Parrot__PhaseHeader.$(O) Parrot__PhaseHeader.$(C) Parrot__PhaseHeader.$(H): Parrot__PhaseHeader.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Parrot__ProtocolState.$(O) Parrot__ProtocolState.$(C) Parrot__ProtocolState.$(H): Parrot__ProtocolState.st $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Dictionary.$(H) $(INCLUDE_TOP)\stx\libbasic\IdentityDictionary.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\Set.$(H) $(STCHDR)
$(OUTDIR)Parrot__ProtocolStateCompiler.$(O) Parrot__ProtocolStateCompiler.$(C) Parrot__ProtocolStateCompiler.$(H): Parrot__ProtocolStateCompiler.st $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Dictionary.$(H) $(INCLUDE_TOP)\stx\libbasic\IdentityDictionary.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\Set.$(H) $(STCHDR)
$(OUTDIR)Parrot__SecurityOps.$(O) Parrot__SecurityOps.$(C) Parrot__SecurityOps.$(H): Parrot__SecurityOps.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Parrot__SessionAgent.$(O) Parrot__SessionAgent.$(C) Parrot__SessionAgent.$(H): Parrot__SessionAgent.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Parrot__SessionAgentMap.$(O) Parrot__SessionAgentMap.$(C) Parrot__SessionAgentMap.$(H): Parrot__SessionAgentMap.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Parrot__SessionIdentity.$(O) Parrot__SessionIdentity.$(C) Parrot__SessionIdentity.$(H): Parrot__SessionIdentity.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Parrot__ThunkRoot.$(O) Parrot__ThunkRoot.$(C) Parrot__ThunkRoot.$(H): Parrot__ThunkRoot.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Parrot__ThunkStack.$(O) Parrot__ThunkStack.$(C) Parrot__ThunkStack.$(H): Parrot__ThunkStack.st $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\OrderedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(STCHDR)
$(OUTDIR)stx_goodies_communication_parrotTalk.$(O) stx_goodies_communication_parrotTalk.$(C) stx_goodies_communication_parrotTalk.$(H): stx_goodies_communication_parrotTalk.st $(INCLUDE_TOP)\stx\libbasic\LibraryDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\ProjectDefinition.$(H) $(STCHDR)
$(OUTDIR)Parrot__DuplicateConnection.$(O) Parrot__DuplicateConnection.$(C) Parrot__DuplicateConnection.$(H): Parrot__DuplicateConnection.st $(INCLUDE_TOP)\stx\goodies\communication\parrotTalk\Parrot__PhaseHeader.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Parrot__Encoded.$(O) Parrot__Encoded.$(C) Parrot__Encoded.$(H): Parrot__Encoded.st $(INCLUDE_TOP)\stx\goodies\communication\parrotTalk\Parrot__PhaseHeader.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Parrot__EncoderThunk.$(O) Parrot__EncoderThunk.$(C) Parrot__EncoderThunk.$(H): Parrot__EncoderThunk.st $(INCLUDE_TOP)\stx\goodies\communication\parrotTalk\Parrot__ThunkRoot.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Parrot__Encrypted.$(O) Parrot__Encrypted.$(C) Parrot__Encrypted.$(H): Parrot__Encrypted.st $(INCLUDE_TOP)\stx\goodies\communication\parrotTalk\Parrot__PhaseHeader.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Parrot__GiveInfo.$(O) Parrot__GiveInfo.$(C) Parrot__GiveInfo.$(H): Parrot__GiveInfo.st $(INCLUDE_TOP)\stx\goodies\communication\parrotTalk\Parrot__PhaseHeader.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Parrot__Go.$(O) Parrot__Go.$(C) Parrot__Go.$(H): Parrot__Go.st $(INCLUDE_TOP)\stx\goodies\communication\parrotTalk\Parrot__PhaseHeader.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Parrot__GoToo.$(O) Parrot__GoToo.$(C) Parrot__GoToo.$(H): Parrot__GoToo.st $(INCLUDE_TOP)\stx\goodies\communication\parrotTalk\Parrot__PhaseHeader.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Parrot__IAm.$(O) Parrot__IAm.$(C) Parrot__IAm.$(H): Parrot__IAm.st $(INCLUDE_TOP)\stx\goodies\communication\parrotTalk\Parrot__PhaseHeader.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Parrot__IWant.$(O) Parrot__IWant.$(C) Parrot__IWant.$(H): Parrot__IWant.st $(INCLUDE_TOP)\stx\goodies\communication\parrotTalk\Parrot__PhaseHeader.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Parrot__MAC.$(O) Parrot__MAC.$(C) Parrot__MAC.$(H): Parrot__MAC.st $(INCLUDE_TOP)\stx\goodies\communication\parrotTalk\Parrot__PhaseHeader.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Parrot__NotMe.$(O) Parrot__NotMe.$(C) Parrot__NotMe.$(H): Parrot__NotMe.st $(INCLUDE_TOP)\stx\goodies\communication\parrotTalk\Parrot__PhaseHeader.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Parrot__ProtocolAccepted.$(O) Parrot__ProtocolAccepted.$(C) Parrot__ProtocolAccepted.$(H): Parrot__ProtocolAccepted.st $(INCLUDE_TOP)\stx\goodies\communication\parrotTalk\Parrot__PhaseHeader.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Parrot__ProtocolOffered.$(O) Parrot__ProtocolOffered.$(C) Parrot__ProtocolOffered.$(H): Parrot__ProtocolOffered.st $(INCLUDE_TOP)\stx\goodies\communication\parrotTalk\Parrot__PhaseHeader.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Parrot__RawData.$(O) Parrot__RawData.$(C) Parrot__RawData.$(H): Parrot__RawData.st $(INCLUDE_TOP)\stx\goodies\communication\parrotTalk\Parrot__PhaseHeader.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Parrot__ReplyInfo.$(O) Parrot__ReplyInfo.$(C) Parrot__ReplyInfo.$(H): Parrot__ReplyInfo.st $(INCLUDE_TOP)\stx\goodies\communication\parrotTalk\Parrot__PhaseHeader.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Parrot__Thunk.$(O) Parrot__Thunk.$(C) Parrot__Thunk.$(H): Parrot__Thunk.st $(INCLUDE_TOP)\stx\goodies\communication\parrotTalk\Parrot__ThunkRoot.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Parrot__ThunkLayer.$(O) Parrot__ThunkLayer.$(C) Parrot__ThunkLayer.$(H): Parrot__ThunkLayer.st $(INCLUDE_TOP)\stx\goodies\communication\parrotTalk\Parrot__ThunkRoot.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Parrot__FrameBuffer.$(O) Parrot__FrameBuffer.$(C) Parrot__FrameBuffer.$(H): Parrot__FrameBuffer.st $(INCLUDE_TOP)\stx\goodies\communication\parrotTalk\Parrot__ThunkLayer.$(H) $(INCLUDE_TOP)\stx\goodies\communication\parrotTalk\Parrot__ThunkRoot.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Parrot__Session.$(O) Parrot__Session.$(C) Parrot__Session.$(H): Parrot__Session.st $(INCLUDE_TOP)\stx\goodies\communication\parrotTalk\Parrot__ThunkLayer.$(H) $(INCLUDE_TOP)\stx\goodies\communication\parrotTalk\Parrot__ThunkRoot.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Parrot__SessionOperations.$(O) Parrot__SessionOperations.$(C) Parrot__SessionOperations.$(H): Parrot__SessionOperations.st $(INCLUDE_TOP)\stx\goodies\communication\parrotTalk\Parrot__ThunkLayer.$(H) $(INCLUDE_TOP)\stx\goodies\communication\parrotTalk\Parrot__ThunkRoot.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Parrot__SocketThunk.$(O) Parrot__SocketThunk.$(C) Parrot__SocketThunk.$(H): Parrot__SocketThunk.st $(INCLUDE_TOP)\stx\goodies\communication\parrotTalk\Parrot__ThunkLayer.$(H) $(INCLUDE_TOP)\stx\goodies\communication\parrotTalk\Parrot__ThunkRoot.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)

# ENDMAKEDEPEND --- do not remove this line
