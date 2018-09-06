# $Header: /cvs/stx/stx/goodies/communication/Make.spec,v 1.31 2018-06-21 16:52:47 cg Exp $
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_goodies_communication.
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
MODULE_DIR=goodies/communication
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
	AbstractTCPSession \
	AbstractTCPSocketServer \
	DNSMessage \
	DNSQuery \
	DNSRecord \
	EMailContentDescription \
	FTPServerException \
	HTTPInterface \
	HTTPProxyQuery \
	HTTPProxySettings \
	HTTPSimpleJSONRestClient \
	JSONPrinter \
	JSONReader \
	NVTClient \
	NameResolver \
	Nfs4Constants \
	RemoteImage \
	SftpConstants \
	SunRPC::RPCDefinitions \
	SunRPC::RPCEndPoint \
	SunRPC::RPCError \
	SunRPC::ReadMe \
	SunRPC::SimulatedDirectory \
	SunRPC::SimulatedFile \
	SunRPC::SimulatedFileSystem \
	SunRPC::XDRCoder \
	SunRPC::XDRItem \
	SunRPC::XDRParser \
	SunRPC::XDRScanner \
	SunRPC::XDRType \
	TelnetClient \
	ThunderbirdComposeInterface \
	URITransmission \
	URITransmissionService \
	URITransmissionServiceAppl \
	stx_goodies_communication \
	AAAARecord \
	ARecord \
	AbstractFTPSession \
	CNAMERecord \
	FTPClient \
	FTPServer \
	HINFORecord \
	MXRecord \
	NSRecord \
	SMTPClient \
	SftpClient \
	SunRPC::RPCClient \
	SunRPC::RPCOperationError \
	SunRPC::RPCServer \
	SunRPC::XDRProcedure \
	SunRPC::XDRProgram \
	SunRPC::XDRProgramVersion \
	UnrecognizedRecord \
	FTPSession \
	SmalltalkFTPSession \
	SmalltalkShareClient \
	SmalltalkShareServer \
	SunRPC::DemoClient \
	SunRPC::DemoServer \
	SunRPC::MountClient \
	SunRPC::MountServer \
	SunRPC::NFSClient \
	SunRPC::NFSServer \
	SunRPC::PortMapperClient \
	SunRPC::PortMapperServer \




COMMON_OBJS= \
    $(OUTDIR)AbstractTCPSession.$(O) \
    $(OUTDIR)AbstractTCPSocketServer.$(O) \
    $(OUTDIR)DNSMessage.$(O) \
    $(OUTDIR)DNSQuery.$(O) \
    $(OUTDIR)DNSRecord.$(O) \
    $(OUTDIR)EMailContentDescription.$(O) \
    $(OUTDIR)FTPServerException.$(O) \
    $(OUTDIR)HTTPInterface.$(O) \
    $(OUTDIR)HTTPProxyQuery.$(O) \
    $(OUTDIR)HTTPProxySettings.$(O) \
    $(OUTDIR)HTTPSimpleJSONRestClient.$(O) \
    $(OUTDIR)JSONPrinter.$(O) \
    $(OUTDIR)JSONReader.$(O) \
    $(OUTDIR)NVTClient.$(O) \
    $(OUTDIR)NameResolver.$(O) \
    $(OUTDIR)Nfs4Constants.$(O) \
    $(OUTDIR)RemoteImage.$(O) \
    $(OUTDIR)SftpConstants.$(O) \
    $(OUTDIR)SunRPC_RPCDefinitions.$(O) \
    $(OUTDIR)SunRPC_RPCEndPoint.$(O) \
    $(OUTDIR)SunRPC_RPCError.$(O) \
    $(OUTDIR)SunRPC_ReadMe.$(O) \
    $(OUTDIR)SunRPC_SimulatedDirectory.$(O) \
    $(OUTDIR)SunRPC_SimulatedFile.$(O) \
    $(OUTDIR)SunRPC_SimulatedFileSystem.$(O) \
    $(OUTDIR)SunRPC_XDRCoder.$(O) \
    $(OUTDIR)SunRPC_XDRItem.$(O) \
    $(OUTDIR)SunRPC_XDRParser.$(O) \
    $(OUTDIR)SunRPC_XDRScanner.$(O) \
    $(OUTDIR)SunRPC_XDRType.$(O) \
    $(OUTDIR)TelnetClient.$(O) \
    $(OUTDIR)ThunderbirdComposeInterface.$(O) \
    $(OUTDIR)URITransmission.$(O) \
    $(OUTDIR)URITransmissionService.$(O) \
    $(OUTDIR)URITransmissionServiceAppl.$(O) \
    $(OUTDIR)stx_goodies_communication.$(O) \
    $(OUTDIR)AAAARecord.$(O) \
    $(OUTDIR)ARecord.$(O) \
    $(OUTDIR)AbstractFTPSession.$(O) \
    $(OUTDIR)CNAMERecord.$(O) \
    $(OUTDIR)FTPClient.$(O) \
    $(OUTDIR)FTPServer.$(O) \
    $(OUTDIR)HINFORecord.$(O) \
    $(OUTDIR)MXRecord.$(O) \
    $(OUTDIR)NSRecord.$(O) \
    $(OUTDIR)SMTPClient.$(O) \
    $(OUTDIR)SftpClient.$(O) \
    $(OUTDIR)SunRPC_RPCClient.$(O) \
    $(OUTDIR)SunRPC_RPCOperationError.$(O) \
    $(OUTDIR)SunRPC_RPCServer.$(O) \
    $(OUTDIR)SunRPC_XDRProcedure.$(O) \
    $(OUTDIR)SunRPC_XDRProgram.$(O) \
    $(OUTDIR)SunRPC_XDRProgramVersion.$(O) \
    $(OUTDIR)UnrecognizedRecord.$(O) \
    $(OUTDIR)FTPSession.$(O) \
    $(OUTDIR)SmalltalkFTPSession.$(O) \
    $(OUTDIR)SmalltalkShareClient.$(O) \
    $(OUTDIR)SmalltalkShareServer.$(O) \
    $(OUTDIR)SunRPC_DemoClient.$(O) \
    $(OUTDIR)SunRPC_DemoServer.$(O) \
    $(OUTDIR)SunRPC_MountClient.$(O) \
    $(OUTDIR)SunRPC_MountServer.$(O) \
    $(OUTDIR)SunRPC_NFSClient.$(O) \
    $(OUTDIR)SunRPC_NFSServer.$(O) \
    $(OUTDIR)SunRPC_RPCPortMapper.$(O) \
    $(OUTDIR)SunRPC_PortMapperServer.$(O) \



