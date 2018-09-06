/*
 * $Header: /cvs/stx/stx/goodies/communication/zeromq/examples/libInit.cc,v 1.1 2018-05-11 00:12:20 cg Exp $
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_goodies_communication_zeromq_examples.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_goodies_communication_zeromq_examples_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_goodies_communication_zeromq_examples_InitDefinition() INIT_TEXT_SECTION;
#endif

extern void _ZmqTaskVentExample_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _stx_137goodies_137communication_137zeromq_137examples_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);


void _libstx_goodies_communication_zeromq_examples_InitDefinition(int pass, struct __vmData__ *__pRT__, OBJ snd)
{
  __BEGIN_PACKAGE2__("libstx_goodies_communication_zeromq_examples__DFN", _libstx_goodies_communication_zeromq_examples_InitDefinition, "stx:goodies/communication/zeromq/examples");
    _stx_137goodies_137communication_137zeromq_137examples_Init(pass,__pRT__,snd);

  __END_PACKAGE__();
}

void _libstx_goodies_communication_zeromq_examples_Init(int pass, struct __vmData__ *__pRT__, OBJ snd)
{
  __BEGIN_PACKAGE2__("libstx_goodies_communication_zeromq_examples", _libstx_goodies_communication_zeromq_examples_Init, "stx:goodies/communication/zeromq/examples");
    _ZmqTaskVentExample_Init(pass,__pRT__,snd);
    _stx_137goodies_137communication_137zeromq_137examples_Init(pass,__pRT__,snd);


  __END_PACKAGE__();
}
