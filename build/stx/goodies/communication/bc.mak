# $Header: /cvs/stx/stx/goodies/communication/bc.mak,v 1.33 2018-06-21 16:52:52 cg Exp $
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_goodies_communication.
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
TOP=..\..
INCLUDE_TOP=$(TOP)\..



!INCLUDE $(TOP)\rules\stdHeader_bc

!INCLUDE Make.spec

LIBNAME=libstx_goodies_communication
MODULE_PATH=goodies\communication
RESFILES=stx_goodies_communicationWINrc.$(RES)


# see stdHeader_bc for GOODIES_COMM_BASE
LIB_BASE_LD_ARG=-b:$(GOODIES_COMM_BASE)


LOCALINCLUDES= -I$(INCLUDE_TOP)\stx\libbasic -I$(INCLUDE_TOP)\stx\libbasic2 -I$(INCLUDE_TOP)\stx\libcomp -I$(INCLUDE_TOP)\stx\libhtml -I$(INCLUDE_TOP)\stx\libtool -I$(INCLUDE_TOP)\stx\libview -I$(INCLUDE_TOP)\stx\libview2 -I$(INCLUDE_TOP)\stx\libwidg
LOCALDEFINES=

STCLOCALOPT=-package=$(PACKAGE) -I. $(LOCALINCLUDES) -headerDir=. $(STCLOCALOPTIMIZATIONS) $(STCWARNINGS) $(LOCALDEFINES)  -varPrefix=$(LIBNAME)
LOCALLIBS=

OBJS= $(COMMON_OBJS) $(WIN32_OBJS)

ALL::  classLibRule

classLibRule: $(OUTDIR) $(OUTDIR)$(LIBNAME).dll

!INCLUDE $(TOP)\rules\stdRules_bc

# build all mandatory prerequisite packages (containing superclasses) for this package
prereq:
	pushd ..\..\libbasic & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\libbasic2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\libcomp & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\libview & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\libview2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "







test: $(TOP)\goodies\builder\reports\
	pushd $(TOP)\goodies\builder\reports & $(MAKE_BAT)
	$(TOP)\goodies\builder\reports\report-runner.bat -D . -r Builder::TestReport -p $(PACKAGE)
        
clean::
	-del *.$(CSUFFIX)


# BEGINMAKEDEPEND --- do not remove this line; make depend needs it
$(OUTDIR)AbstractTCPSession.$(O) AbstractTCPSession.$(C) AbstractTCPSession.$(H): AbstractTCPSession.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)AbstractTCPSocketServer.$(O) AbstractTCPSocketServer.$(C) AbstractTCPSocketServer.$(H): AbstractTCPSocketServer.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DNSMessage.$(O) DNSMessage.$(C) DNSMessage.$(H): DNSMessage.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DNSQuery.$(O) DNSQuery.$(C) DNSQuery.$(H): DNSQuery.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DNSRecord.$(O) DNSRecord.$(C) DNSRecord.$(H): DNSRecord.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)EMailContentDescription.$(O) EMailContentDescription.$(C) EMailContentDescription.$(H): EMailContentDescription.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)FTPServerException.$(O) FTPServerException.$(C) FTPServerException.$(H): FTPServerException.st $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)HTTPInterface.$(O) HTTPInterface.$(C) HTTPInterface.$(H): HTTPInterface.st $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Notification.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)HTTPProxyQuery.$(O) HTTPProxyQuery.$(C) HTTPProxyQuery.$(H): HTTPProxyQuery.st $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Notification.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\Query.$(H) $(STCHDR)
$(OUTDIR)HTTPProxySettings.$(O) HTTPProxySettings.$(C) HTTPProxySettings.$(H): HTTPProxySettings.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)HTTPSimpleJSONRestClient.$(O) HTTPSimpleJSONRestClient.$(C) HTTPSimpleJSONRestClient.$(H): HTTPSimpleJSONRestClient.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)JSONPrinter.$(O) JSONPrinter.$(C) JSONPrinter.$(H): JSONPrinter.st $(INCLUDE_TOP)\stx\libbasic\AspectVisitor.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\ObjectCoder.$(H) $(INCLUDE_TOP)\stx\libbasic\Visitor.$(H) $(STCHDR)
$(OUTDIR)JSONReader.$(O) JSONReader.$(C) JSONReader.$(H): JSONReader.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\PeekableStream.$(H) $(INCLUDE_TOP)\stx\libbasic\Stream.$(H) $(STCHDR)
$(OUTDIR)NVTClient.$(O) NVTClient.$(C) NVTClient.$(H): NVTClient.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)NameResolver.$(O) NameResolver.$(C) NameResolver.$(H): NameResolver.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Nfs4Constants.$(O) Nfs4Constants.$(C) Nfs4Constants.$(H): Nfs4Constants.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\SharedPool.$(H) $(STCHDR)
$(OUTDIR)RemoteImage.$(O) RemoteImage.$(C) RemoteImage.$(H): RemoteImage.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SftpConstants.$(O) SftpConstants.$(C) SftpConstants.$(H): SftpConstants.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\SharedPool.$(H) $(STCHDR)
$(OUTDIR)SunRPC_RPCDefinitions.$(O) SunRPC_RPCDefinitions.$(C) SunRPC_RPCDefinitions.$(H): SunRPC_RPCDefinitions.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SunRPC_RPCEndPoint.$(O) SunRPC_RPCEndPoint.$(C) SunRPC_RPCEndPoint.$(H): SunRPC_RPCEndPoint.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SunRPC_RPCError.$(O) SunRPC_RPCError.$(C) SunRPC_RPCError.$(H): SunRPC_RPCError.st $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SunRPC_ReadMe.$(O) SunRPC_ReadMe.$(C) SunRPC_ReadMe.$(H): SunRPC_ReadMe.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SunRPC_SimulatedDirectory.$(O) SunRPC_SimulatedDirectory.$(C) SunRPC_SimulatedDirectory.$(H): SunRPC_SimulatedDirectory.st $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\OrderedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(STCHDR)
$(OUTDIR)SunRPC_SimulatedFile.$(O) SunRPC_SimulatedFile.$(C) SunRPC_SimulatedFile.$(H): SunRPC_SimulatedFile.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SunRPC_SimulatedFileSystem.$(O) SunRPC_SimulatedFileSystem.$(C) SunRPC_SimulatedFileSystem.$(H): SunRPC_SimulatedFileSystem.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SunRPC_XDRCoder.$(O) SunRPC_XDRCoder.$(C) SunRPC_XDRCoder.$(H): SunRPC_XDRCoder.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SunRPC_XDRItem.$(O) SunRPC_XDRItem.$(C) SunRPC_XDRItem.$(H): SunRPC_XDRItem.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SunRPC_XDRParser.$(O) SunRPC_XDRParser.$(C) SunRPC_XDRParser.$(H): SunRPC_XDRParser.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SunRPC_XDRScanner.$(O) SunRPC_XDRScanner.$(C) SunRPC_XDRScanner.$(H): SunRPC_XDRScanner.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libcomp\Scanner.$(H) $(STCHDR)
$(OUTDIR)SunRPC_XDRType.$(O) SunRPC_XDRType.$(C) SunRPC_XDRType.$(H): SunRPC_XDRType.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)TelnetClient.$(O) TelnetClient.$(C) TelnetClient.$(H): TelnetClient.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)ThunderbirdComposeInterface.$(O) ThunderbirdComposeInterface.$(C) ThunderbirdComposeInterface.$(H): ThunderbirdComposeInterface.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)URITransmission.$(O) URITransmission.$(C) URITransmission.$(H): URITransmission.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)URITransmissionService.$(O) URITransmissionService.$(C) URITransmissionService.$(H): URITransmissionService.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)URITransmissionServiceAppl.$(O) URITransmissionServiceAppl.$(C) URITransmissionServiceAppl.$(H): URITransmissionServiceAppl.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(STCHDR)
$(OUTDIR)stx_goodies_communication.$(O) stx_goodies_communication.$(C) stx_goodies_communication.$(H): stx_goodies_communication.st $(INCLUDE_TOP)\stx\libbasic\LibraryDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\ProjectDefinition.$(H) $(STCHDR)
$(OUTDIR)AAAARecord.$(O) AAAARecord.$(C) AAAARecord.$(H): AAAARecord.st $(INCLUDE_TOP)\stx\goodies\communication\DNSRecord.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)ARecord.$(O) ARecord.$(C) ARecord.$(H): ARecord.st $(INCLUDE_TOP)\stx\goodies\communication\DNSRecord.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)AbstractFTPSession.$(O) AbstractFTPSession.$(C) AbstractFTPSession.$(H): AbstractFTPSession.st $(INCLUDE_TOP)\stx\goodies\communication\AbstractTCPSession.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)CNAMERecord.$(O) CNAMERecord.$(C) CNAMERecord.$(H): CNAMERecord.st $(INCLUDE_TOP)\stx\goodies\communication\DNSRecord.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)FTPClient.$(O) FTPClient.$(C) FTPClient.$(H): FTPClient.st $(INCLUDE_TOP)\stx\goodies\communication\NVTClient.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)FTPServer.$(O) FTPServer.$(C) FTPServer.$(H): FTPServer.st $(INCLUDE_TOP)\stx\goodies\communication\AbstractTCPSocketServer.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)HINFORecord.$(O) HINFORecord.$(C) HINFORecord.$(H): HINFORecord.st $(INCLUDE_TOP)\stx\goodies\communication\DNSRecord.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MXRecord.$(O) MXRecord.$(C) MXRecord.$(H): MXRecord.st $(INCLUDE_TOP)\stx\goodies\communication\DNSRecord.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)NSRecord.$(O) NSRecord.$(C) NSRecord.$(H): NSRecord.st $(INCLUDE_TOP)\stx\goodies\communication\DNSRecord.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SMTPClient.$(O) SMTPClient.$(C) SMTPClient.$(H): SMTPClient.st $(INCLUDE_TOP)\stx\goodies\communication\NVTClient.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SftpClient.$(O) SftpClient.$(C) SftpClient.$(H): SftpClient.st $(INCLUDE_TOP)\stx\goodies\communication\Nfs4Constants.$(H) $(INCLUDE_TOP)\stx\goodies\communication\SftpConstants.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SunRPC_RPCClient.$(O) SunRPC_RPCClient.$(C) SunRPC_RPCClient.$(H): SunRPC_RPCClient.st $(INCLUDE_TOP)\stx\goodies\communication\SunRPC_RPCEndPoint.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SunRPC_RPCOperationError.$(O) SunRPC_RPCOperationError.$(C) SunRPC_RPCOperationError.$(H): SunRPC_RPCOperationError.st $(INCLUDE_TOP)\stx\goodies\communication\SunRPC_RPCError.$(H) $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SunRPC_RPCServer.$(O) SunRPC_RPCServer.$(C) SunRPC_RPCServer.$(H): SunRPC_RPCServer.st $(INCLUDE_TOP)\stx\goodies\communication\SunRPC_RPCEndPoint.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SunRPC_XDRProcedure.$(O) SunRPC_XDRProcedure.$(C) SunRPC_XDRProcedure.$(H): SunRPC_XDRProcedure.st $(INCLUDE_TOP)\stx\goodies\communication\SunRPC_XDRItem.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SunRPC_XDRProgram.$(O) SunRPC_XDRProgram.$(C) SunRPC_XDRProgram.$(H): SunRPC_XDRProgram.st $(INCLUDE_TOP)\stx\goodies\communication\SunRPC_XDRItem.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SunRPC_XDRProgramVersion.$(O) SunRPC_XDRProgramVersion.$(C) SunRPC_XDRProgramVersion.$(H): SunRPC_XDRProgramVersion.st $(INCLUDE_TOP)\stx\goodies\communication\SunRPC_XDRItem.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)UnrecognizedRecord.$(O) UnrecognizedRecord.$(C) UnrecognizedRecord.$(H): UnrecognizedRecord.st $(INCLUDE_TOP)\stx\goodies\communication\DNSRecord.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)FTPSession.$(O) FTPSession.$(C) FTPSession.$(H): FTPSession.st $(INCLUDE_TOP)\stx\goodies\communication\AbstractFTPSession.$(H) $(INCLUDE_TOP)\stx\goodies\communication\AbstractTCPSession.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmalltalkFTPSession.$(O) SmalltalkFTPSession.$(C) SmalltalkFTPSession.$(H): SmalltalkFTPSession.st $(INCLUDE_TOP)\stx\goodies\communication\AbstractFTPSession.$(H) $(INCLUDE_TOP)\stx\goodies\communication\AbstractTCPSession.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmalltalkShareClient.$(O) SmalltalkShareClient.$(C) SmalltalkShareClient.$(H): SmalltalkShareClient.st $(INCLUDE_TOP)\stx\goodies\communication\SunRPC_RPCClient.$(H) $(INCLUDE_TOP)\stx\goodies\communication\SunRPC_RPCEndPoint.$(H) $(INCLUDE_TOP)\stx\libbasic\Behavior.$(H) $(INCLUDE_TOP)\stx\libbasic\Class.$(H) $(INCLUDE_TOP)\stx\libbasic\ClassDescription.$(H) $(INCLUDE_TOP)\stx\libbasic\CompiledCode.$(H) $(INCLUDE_TOP)\stx\libbasic\ExecutableFunction.$(H) $(INCLUDE_TOP)\stx\libbasic\Metaclass.$(H) $(INCLUDE_TOP)\stx\libbasic\Method.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmalltalkShareServer.$(O) SmalltalkShareServer.$(C) SmalltalkShareServer.$(H): SmalltalkShareServer.st $(INCLUDE_TOP)\stx\goodies\communication\SunRPC_RPCEndPoint.$(H) $(INCLUDE_TOP)\stx\goodies\communication\SunRPC_RPCServer.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SunRPC_DemoClient.$(O) SunRPC_DemoClient.$(C) SunRPC_DemoClient.$(H): SunRPC_DemoClient.st $(INCLUDE_TOP)\stx\goodies\communication\SunRPC_RPCClient.$(H) $(INCLUDE_TOP)\stx\goodies\communication\SunRPC_RPCEndPoint.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SunRPC_DemoServer.$(O) SunRPC_DemoServer.$(C) SunRPC_DemoServer.$(H): SunRPC_DemoServer.st $(INCLUDE_TOP)\stx\goodies\communication\SunRPC_RPCEndPoint.$(H) $(INCLUDE_TOP)\stx\goodies\communication\SunRPC_RPCServer.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SunRPC_MountClient.$(O) SunRPC_MountClient.$(C) SunRPC_MountClient.$(H): SunRPC_MountClient.st $(INCLUDE_TOP)\stx\goodies\communication\SunRPC_RPCClient.$(H) $(INCLUDE_TOP)\stx\goodies\communication\SunRPC_RPCEndPoint.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SunRPC_MountServer.$(O) SunRPC_MountServer.$(C) SunRPC_MountServer.$(H): SunRPC_MountServer.st $(INCLUDE_TOP)\stx\goodies\communication\SunRPC_RPCEndPoint.$(H) $(INCLUDE_TOP)\stx\goodies\communication\SunRPC_RPCServer.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SunRPC_NFSClient.$(O) SunRPC_NFSClient.$(C) SunRPC_NFSClient.$(H): SunRPC_NFSClient.st $(INCLUDE_TOP)\stx\goodies\communication\SunRPC_RPCClient.$(H) $(INCLUDE_TOP)\stx\goodies\communication\SunRPC_RPCEndPoint.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SunRPC_NFSServer.$(O) SunRPC_NFSServer.$(C) SunRPC_NFSServer.$(H): SunRPC_NFSServer.st $(INCLUDE_TOP)\stx\goodies\communication\SunRPC_RPCEndPoint.$(H) $(INCLUDE_TOP)\stx\goodies\communication\SunRPC_RPCServer.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SunRPC_RPCPortMapper.$(O) SunRPC_RPCPortMapper.$(C) SunRPC_RPCPortMapper.$(H): SunRPC_RPCPortMapper.st $(INCLUDE_TOP)\stx\goodies\communication\SunRPC_RPCClient.$(H) $(INCLUDE_TOP)\stx\goodies\communication\SunRPC_RPCEndPoint.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SunRPC_PortMapperServer.$(O) SunRPC_PortMapperServer.$(C) SunRPC_PortMapperServer.$(H): SunRPC_PortMapperServer.st $(INCLUDE_TOP)\stx\goodies\communication\SunRPC_RPCEndPoint.$(H) $(INCLUDE_TOP)\stx\goodies\communication\SunRPC_RPCServer.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)

# ENDMAKEDEPEND --- do not remove this line
