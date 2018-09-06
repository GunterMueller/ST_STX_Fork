/*
 * $Header: /cvs/stx/stx/goodies/communication/libInit.cc,v 1.35 2018-06-21 16:53:03 cg Exp $
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_goodies_communication.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_goodies_communication_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_goodies_communication_InitDefinition() INIT_TEXT_SECTION;
#endif

extern void _AbstractTCPSession_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _AbstractTCPSocketServer_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _DNSMessage_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _DNSQuery_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _DNSRecord_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _EMailContentDescription_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _FTPServerException_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _HTTPInterface_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _HTTPProxyQuery_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _HTTPProxySettings_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _HTTPSimpleJSONRestClient_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _JSONPrinter_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _JSONReader_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _NVTClient_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _NameResolver_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Nfs4Constants_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RemoteImage_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _SftpConstants_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _SunRPC__RPCDefinitions_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _SunRPC__RPCEndPoint_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _SunRPC__RPCError_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _SunRPC__ReadMe_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _SunRPC__SimulatedDirectory_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _SunRPC__SimulatedFile_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _SunRPC__SimulatedFileSystem_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _SunRPC__XDRCoder_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _SunRPC__XDRItem_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _SunRPC__XDRParser_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _SunRPC__XDRScanner_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _SunRPC__XDRType_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _TelnetClient_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ThunderbirdComposeInterface_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _URITransmission_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _URITransmissionService_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _URITransmissionServiceAppl_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _stx_137goodies_137communication_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _AAAARecord_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ARecord_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _AbstractFTPSession_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _CNAMERecord_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _FTPClient_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _FTPServer_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _HINFORecord_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _MXRecord_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _NSRecord_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _SMTPClient_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _SftpClient_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _SunRPC__RPCClient_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _SunRPC__RPCOperationError_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _SunRPC__RPCServer_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _SunRPC__XDRProcedure_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _SunRPC__XDRProgram_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _SunRPC__XDRProgramVersion_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _UnrecognizedRecord_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _FTPSession_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _SmalltalkFTPSession_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _SmalltalkShareClient_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _SmalltalkShareServer_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _SunRPC__DemoClient_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _SunRPC__DemoServer_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _SunRPC__MountClient_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _SunRPC__MountServer_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _SunRPC__NFSClient_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _SunRPC__NFSServer_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _SunRPC__PortMapperClient_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _SunRPC__PortMapperServer_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);


void _libstx_goodies_communication_InitDefinition(int pass, struct __vmData__ *__pRT__, OBJ snd)
{
  __BEGIN_PACKAGE2__("libstx_goodies_communication__DFN", _libstx_goodies_communication_InitDefinition, "stx:goodies/communication");
    _stx_137goodies_137communication_Init(pass,__pRT__,snd);

  __END_PACKAGE__();
}

void _libstx_goodies_communication_Init(int pass, struct __vmData__ *__pRT__, OBJ snd)
{
  __BEGIN_PACKAGE2__("libstx_goodies_communication", _libstx_goodies_communication_Init, "stx:goodies/communication");
    _AbstractTCPSession_Init(pass,__pRT__,snd);
    _AbstractTCPSocketServer_Init(pass,__pRT__,snd);
    _DNSMessage_Init(pass,__pRT__,snd);
    _DNSQuery_Init(pass,__pRT__,snd);
    _DNSRecord_Init(pass,__pRT__,snd);
    _EMailContentDescription_Init(pass,__pRT__,snd);
    _FTPServerException_Init(pass,__pRT__,snd);
    _HTTPInterface_Init(pass,__pRT__,snd);
    _HTTPProxyQuery_Init(pass,__pRT__,snd);
    _HTTPProxySettings_Init(pass,__pRT__,snd);
    _HTTPSimpleJSONRestClient_Init(pass,__pRT__,snd);
    _JSONPrinter_Init(pass,__pRT__,snd);
    _JSONReader_Init(pass,__pRT__,snd);
    _NVTClient_Init(pass,__pRT__,snd);
    _NameResolver_Init(pass,__pRT__,snd);
    _Nfs4Constants_Init(pass,__pRT__,snd);
    _RemoteImage_Init(pass,__pRT__,snd);
    _SftpConstants_Init(pass,__pRT__,snd);
    _SunRPC__RPCDefinitions_Init(pass,__pRT__,snd);
    _SunRPC__RPCEndPoint_Init(pass,__pRT__,snd);
    _SunRPC__RPCError_Init(pass,__pRT__,snd);
    _SunRPC__ReadMe_Init(pass,__pRT__,snd);
    _SunRPC__SimulatedDirectory_Init(pass,__pRT__,snd);
    _SunRPC__SimulatedFile_Init(pass,__pRT__,snd);
    _SunRPC__SimulatedFileSystem_Init(pass,__pRT__,snd);
    _SunRPC__XDRCoder_Init(pass,__pRT__,snd);
    _SunRPC__XDRItem_Init(pass,__pRT__,snd);
    _SunRPC__XDRParser_Init(pass,__pRT__,snd);
    _SunRPC__XDRScanner_Init(pass,__pRT__,snd);
    _SunRPC__XDRType_Init(pass,__pRT__,snd);
    _TelnetClient_Init(pass,__pRT__,snd);
    _ThunderbirdComposeInterface_Init(pass,__pRT__,snd);
    _URITransmission_Init(pass,__pRT__,snd);
    _URITransmissionService_Init(pass,__pRT__,snd);
    _URITransmissionServiceAppl_Init(pass,__pRT__,snd);
    _stx_137goodies_137communication_Init(pass,__pRT__,snd);
    _AAAARecord_Init(pass,__pRT__,snd);
    _ARecord_Init(pass,__pRT__,snd);
    _AbstractFTPSession_Init(pass,__pRT__,snd);
    _CNAMERecord_Init(pass,__pRT__,snd);
    _FTPClient_Init(pass,__pRT__,snd);
    _FTPServer_Init(pass,__pRT__,snd);
    _HINFORecord_Init(pass,__pRT__,snd);
    _MXRecord_Init(pass,__pRT__,snd);
    _NSRecord_Init(pass,__pRT__,snd);
    _SMTPClient_Init(pass,__pRT__,snd);
    _SftpClient_Init(pass,__pRT__,snd);
    _SunRPC__RPCClient_Init(pass,__pRT__,snd);
    _SunRPC__RPCOperationError_Init(pass,__pRT__,snd);
    _SunRPC__RPCServer_Init(pass,__pRT__,snd);
    _SunRPC__XDRProcedure_Init(pass,__pRT__,snd);
    _SunRPC__XDRProgram_Init(pass,__pRT__,snd);
    _SunRPC__XDRProgramVersion_Init(pass,__pRT__,snd);
    _UnrecognizedRecord_Init(pass,__pRT__,snd);
    _FTPSession_Init(pass,__pRT__,snd);
    _SmalltalkFTPSession_Init(pass,__pRT__,snd);
    _SmalltalkShareClient_Init(pass,__pRT__,snd);
    _SmalltalkShareServer_Init(pass,__pRT__,snd);
    _SunRPC__DemoClient_Init(pass,__pRT__,snd);
    _SunRPC__DemoServer_Init(pass,__pRT__,snd);
    _SunRPC__MountClient_Init(pass,__pRT__,snd);
    _SunRPC__MountServer_Init(pass,__pRT__,snd);
    _SunRPC__NFSClient_Init(pass,__pRT__,snd);
    _SunRPC__NFSServer_Init(pass,__pRT__,snd);
    _SunRPC__PortMapperClient_Init(pass,__pRT__,snd);
    _SunRPC__PortMapperServer_Init(pass,__pRT__,snd);


  __END_PACKAGE__();
}
