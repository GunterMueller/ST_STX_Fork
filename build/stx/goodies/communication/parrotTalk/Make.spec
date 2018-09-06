# $Header: /cvs/stx/stx/goodies/communication/parrotTalk/Make.spec,v 1.1 2018-05-14 00:19:07 cg Exp $
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_goodies_communication_parrotTalk.
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
MODULE_DIR=goodies/communication/parrotTalk
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
	Parrot::CipherThunkMaker \
	Parrot::Frame \
	Parrot::InetSocketAddress \
	Parrot::ParrotPercentEncoder \
	Parrot::PhaseHeader \
	Parrot::ProtocolState \
	Parrot::ProtocolStateCompiler \
	Parrot::SecurityOps \
	Parrot::SessionAgent \
	Parrot::SessionAgentMap \
	Parrot::SessionIdentity \
	Parrot::ThunkRoot \
	Parrot::ThunkStack \
	stx_goodies_communication_parrotTalk \
	Parrot::DuplicateConnection \
	Parrot::Encoded \
	Parrot::EncoderThunk \
	Parrot::Encrypted \
	Parrot::GiveInfo \
	Parrot::Go \
	Parrot::GoToo \
	Parrot::IAm \
	Parrot::IWant \
	Parrot::MAC \
	Parrot::NotMe \
	Parrot::ProtocolAccepted \
	Parrot::ProtocolOffered \
	Parrot::RawData \
	Parrot::ReplyInfo \
	Parrot::Thunk \
	Parrot::ThunkLayer \
	Parrot::FrameBuffer \
	Parrot::Session \
	Parrot::SessionOperations \
	Parrot::SocketThunk \




COMMON_OBJS= \
    $(OUTDIR)Parrot__CipherThunkMaker.$(O) \
    $(OUTDIR)Parrot__Frame.$(O) \
    $(OUTDIR)Parrot__InetSocketAddress.$(O) \
    $(OUTDIR)Parrot__ParrotPercentEncoder.$(O) \
    $(OUTDIR)Parrot__PhaseHeader.$(O) \
    $(OUTDIR)Parrot__ProtocolState.$(O) \
    $(OUTDIR)Parrot__ProtocolStateCompiler.$(O) \
    $(OUTDIR)Parrot__SecurityOps.$(O) \
    $(OUTDIR)Parrot__SessionAgent.$(O) \
    $(OUTDIR)Parrot__SessionAgentMap.$(O) \
    $(OUTDIR)Parrot__SessionIdentity.$(O) \
    $(OUTDIR)Parrot__ThunkRoot.$(O) \
    $(OUTDIR)Parrot__ThunkStack.$(O) \
    $(OUTDIR)stx_goodies_communication_parrotTalk.$(O) \
    $(OUTDIR)Parrot__DuplicateConnection.$(O) \
    $(OUTDIR)Parrot__Encoded.$(O) \
    $(OUTDIR)Parrot__EncoderThunk.$(O) \
    $(OUTDIR)Parrot__Encrypted.$(O) \
    $(OUTDIR)Parrot__GiveInfo.$(O) \
    $(OUTDIR)Parrot__Go.$(O) \
    $(OUTDIR)Parrot__GoToo.$(O) \
    $(OUTDIR)Parrot__IAm.$(O) \
    $(OUTDIR)Parrot__IWant.$(O) \
    $(OUTDIR)Parrot__MAC.$(O) \
    $(OUTDIR)Parrot__NotMe.$(O) \
    $(OUTDIR)Parrot__ProtocolAccepted.$(O) \
    $(OUTDIR)Parrot__ProtocolOffered.$(O) \
    $(OUTDIR)Parrot__RawData.$(O) \
    $(OUTDIR)Parrot__ReplyInfo.$(O) \
    $(OUTDIR)Parrot__Thunk.$(O) \
    $(OUTDIR)Parrot__ThunkLayer.$(O) \
    $(OUTDIR)Parrot__FrameBuffer.$(O) \
    $(OUTDIR)Parrot__Session.$(O) \
    $(OUTDIR)Parrot__SessionOperations.$(O) \
    $(OUTDIR)Parrot__SocketThunk.$(O) \



