/*
 * $Header: /cvs/stx/stx/goodies/communication/messagePack/tests/libInit.cc,v 1.1 2018-05-08 11:04:49 cg Exp $
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_goodies_communication_messagePack_tests.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_goodies_communication_messagePack_tests_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_goodies_communication_messagePack_tests_InitDefinition() INIT_TEXT_SECTION;
#endif

extern void _MpTestCase_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _stx_137goodies_137communication_137messagePack_137tests_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _MpPackUnpackTestCase_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _MpSettingsTestCase_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _MpStringUnpackTestCase_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);


void _libstx_goodies_communication_messagePack_tests_InitDefinition(int pass, struct __vmData__ *__pRT__, OBJ snd)
{
  __BEGIN_PACKAGE2__("libstx_goodies_communication_messagePack_tests__DFN", _libstx_goodies_communication_messagePack_tests_InitDefinition, "stx:goodies/communication/messagePack/tests");
    _stx_137goodies_137communication_137messagePack_137tests_Init(pass,__pRT__,snd);

  __END_PACKAGE__();
}

void _libstx_goodies_communication_messagePack_tests_Init(int pass, struct __vmData__ *__pRT__, OBJ snd)
{
  __BEGIN_PACKAGE2__("libstx_goodies_communication_messagePack_tests", _libstx_goodies_communication_messagePack_tests_Init, "stx:goodies/communication/messagePack/tests");
    _MpTestCase_Init(pass,__pRT__,snd);
    _stx_137goodies_137communication_137messagePack_137tests_Init(pass,__pRT__,snd);
    _MpPackUnpackTestCase_Init(pass,__pRT__,snd);
    _MpSettingsTestCase_Init(pass,__pRT__,snd);
    _MpStringUnpackTestCase_Init(pass,__pRT__,snd);


  __END_PACKAGE__();
}
