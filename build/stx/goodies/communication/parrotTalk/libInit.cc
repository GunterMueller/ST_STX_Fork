/*
 * $Header: /cvs/stx/stx/goodies/communication/parrotTalk/libInit.cc,v 1.1 2018-05-14 00:19:34 cg Exp $
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_goodies_communication_parrotTalk.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_goodies_communication_parrotTalk_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_goodies_communication_parrotTalk_InitDefinition() INIT_TEXT_SECTION;
#endif

extern void _Parrot__CipherThunkMaker_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Parrot__Frame_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Parrot__InetSocketAddress_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Parrot__ParrotPercentEncoder_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Parrot__PhaseHeader_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Parrot__ProtocolState_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Parrot__ProtocolStateCompiler_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Parrot__SecurityOps_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Parrot__SessionAgent_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Parrot__SessionAgentMap_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Parrot__SessionIdentity_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Parrot__ThunkRoot_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Parrot__ThunkStack_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _stx_137goodies_137communication_137parrotTalk_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Parrot__DuplicateConnection_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Parrot__Encoded_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Parrot__EncoderThunk_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Parrot__Encrypted_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Parrot__GiveInfo_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Parrot__Go_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Parrot__GoToo_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Parrot__IAm_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Parrot__IWant_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Parrot__MAC_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Parrot__NotMe_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Parrot__ProtocolAccepted_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Parrot__ProtocolOffered_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Parrot__RawData_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Parrot__ReplyInfo_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Parrot__Thunk_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Parrot__ThunkLayer_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Parrot__FrameBuffer_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Parrot__Session_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Parrot__SessionOperations_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Parrot__SocketThunk_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);


void _libstx_goodies_communication_parrotTalk_InitDefinition(int pass, struct __vmData__ *__pRT__, OBJ snd)
{
  __BEGIN_PACKAGE2__("libstx_goodies_communication_parrotTalk__DFN", _libstx_goodies_communication_parrotTalk_InitDefinition, "stx:goodies/communication/parrotTalk");
    _stx_137goodies_137communication_137parrotTalk_Init(pass,__pRT__,snd);

  __END_PACKAGE__();
}

void _libstx_goodies_communication_parrotTalk_Init(int pass, struct __vmData__ *__pRT__, OBJ snd)
{
  __BEGIN_PACKAGE2__("libstx_goodies_communication_parrotTalk", _libstx_goodies_communication_parrotTalk_Init, "stx:goodies/communication/parrotTalk");
    _Parrot__CipherThunkMaker_Init(pass,__pRT__,snd);
    _Parrot__Frame_Init(pass,__pRT__,snd);
    _Parrot__InetSocketAddress_Init(pass,__pRT__,snd);
    _Parrot__ParrotPercentEncoder_Init(pass,__pRT__,snd);
    _Parrot__PhaseHeader_Init(pass,__pRT__,snd);
    _Parrot__ProtocolState_Init(pass,__pRT__,snd);
    _Parrot__ProtocolStateCompiler_Init(pass,__pRT__,snd);
    _Parrot__SecurityOps_Init(pass,__pRT__,snd);
    _Parrot__SessionAgent_Init(pass,__pRT__,snd);
    _Parrot__SessionAgentMap_Init(pass,__pRT__,snd);
    _Parrot__SessionIdentity_Init(pass,__pRT__,snd);
    _Parrot__ThunkRoot_Init(pass,__pRT__,snd);
    _Parrot__ThunkStack_Init(pass,__pRT__,snd);
    _stx_137goodies_137communication_137parrotTalk_Init(pass,__pRT__,snd);
    _Parrot__DuplicateConnection_Init(pass,__pRT__,snd);
    _Parrot__Encoded_Init(pass,__pRT__,snd);
    _Parrot__EncoderThunk_Init(pass,__pRT__,snd);
    _Parrot__Encrypted_Init(pass,__pRT__,snd);
    _Parrot__GiveInfo_Init(pass,__pRT__,snd);
    _Parrot__Go_Init(pass,__pRT__,snd);
    _Parrot__GoToo_Init(pass,__pRT__,snd);
    _Parrot__IAm_Init(pass,__pRT__,snd);
    _Parrot__IWant_Init(pass,__pRT__,snd);
    _Parrot__MAC_Init(pass,__pRT__,snd);
    _Parrot__NotMe_Init(pass,__pRT__,snd);
    _Parrot__ProtocolAccepted_Init(pass,__pRT__,snd);
    _Parrot__ProtocolOffered_Init(pass,__pRT__,snd);
    _Parrot__RawData_Init(pass,__pRT__,snd);
    _Parrot__ReplyInfo_Init(pass,__pRT__,snd);
    _Parrot__Thunk_Init(pass,__pRT__,snd);
    _Parrot__ThunkLayer_Init(pass,__pRT__,snd);
    _Parrot__FrameBuffer_Init(pass,__pRT__,snd);
    _Parrot__Session_Init(pass,__pRT__,snd);
    _Parrot__SessionOperations_Init(pass,__pRT__,snd);
    _Parrot__SocketThunk_Init(pass,__pRT__,snd);


  __END_PACKAGE__();
}
