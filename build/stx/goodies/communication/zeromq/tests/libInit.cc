/*
 * $Header: /cvs/stx/stx/goodies/communication/zeromq/tests/libInit.cc,v 1.2 2018-05-11 00:08:34 cg Exp $
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_goodies_communication_zeromq_tests.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_goodies_communication_zeromq_tests_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_goodies_communication_zeromq_tests_InitDefinition() INIT_TEXT_SECTION;
#endif

extern void _ZmqBaseTest_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ZmqTaskVentTest_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ZmqVersionTest_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _stx_137goodies_137communication_137zeromq_137tests_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ZeroMQTest_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ZmqPollerTest_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);


void _libstx_goodies_communication_zeromq_tests_InitDefinition(int pass, struct __vmData__ *__pRT__, OBJ snd)
{
  __BEGIN_PACKAGE2__("libstx_goodies_communication_zeromq_tests__DFN", _libstx_goodies_communication_zeromq_tests_InitDefinition, "stx:goodies/communication/zeromq/tests");
    _stx_137goodies_137communication_137zeromq_137tests_Init(pass,__pRT__,snd);

  __END_PACKAGE__();
}

void _libstx_goodies_communication_zeromq_tests_Init(int pass, struct __vmData__ *__pRT__, OBJ snd)
{
  __BEGIN_PACKAGE2__("libstx_goodies_communication_zeromq_tests", _libstx_goodies_communication_zeromq_tests_Init, "stx:goodies/communication/zeromq/tests");
    _ZmqBaseTest_Init(pass,__pRT__,snd);
    _ZmqTaskVentTest_Init(pass,__pRT__,snd);
    _ZmqVersionTest_Init(pass,__pRT__,snd);
    _stx_137goodies_137communication_137zeromq_137tests_Init(pass,__pRT__,snd);
    _ZeroMQTest_Init(pass,__pRT__,snd);
    _ZmqPollerTest_Init(pass,__pRT__,snd);


  __END_PACKAGE__();
}
