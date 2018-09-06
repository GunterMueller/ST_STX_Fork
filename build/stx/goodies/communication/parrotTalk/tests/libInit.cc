/*
 * $Header: /cvs/stx/stx/goodies/communication/parrotTalk/tests/libInit.cc,v 1.1 2018-05-14 00:20:51 cg Exp $
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_goodies_communication_parrotTalk_tests.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_goodies_communication_parrotTalk_tests_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_goodies_communication_parrotTalk_tests_InitDefinition() INIT_TEXT_SECTION;
#endif

extern void _Parrot__HelloWorldTestServer_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Parrot__StateMachineTest_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Parrot__ThunkASN1FrameTest_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Parrot__ThunkFrameTest_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Parrot__ThunkHelloWorldTest_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _stx_137goodies_137communication_137parrotTalk_137tests_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);


void _libstx_goodies_communication_parrotTalk_tests_InitDefinition(int pass, struct __vmData__ *__pRT__, OBJ snd)
{
  __BEGIN_PACKAGE2__("libstx_goodies_communication_parrotTalk_tests__DFN", _libstx_goodies_communication_parrotTalk_tests_InitDefinition, "stx:goodies/communication/parrotTalk/tests");
    _stx_137goodies_137communication_137parrotTalk_137tests_Init(pass,__pRT__,snd);

  __END_PACKAGE__();
}

void _libstx_goodies_communication_parrotTalk_tests_Init(int pass, struct __vmData__ *__pRT__, OBJ snd)
{
  __BEGIN_PACKAGE2__("libstx_goodies_communication_parrotTalk_tests", _libstx_goodies_communication_parrotTalk_tests_Init, "stx:goodies/communication/parrotTalk/tests");
    _Parrot__HelloWorldTestServer_Init(pass,__pRT__,snd);
    _Parrot__StateMachineTest_Init(pass,__pRT__,snd);
    _Parrot__ThunkASN1FrameTest_Init(pass,__pRT__,snd);
    _Parrot__ThunkFrameTest_Init(pass,__pRT__,snd);
    _Parrot__ThunkHelloWorldTest_Init(pass,__pRT__,snd);
    _stx_137goodies_137communication_137parrotTalk_137tests_Init(pass,__pRT__,snd);


  __END_PACKAGE__();
}
