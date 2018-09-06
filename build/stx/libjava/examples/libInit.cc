/*
 * $Header: /cvs/stx/stx/libjava/examples/libInit.cc,v 1.5 2015-03-20 12:08:02 vrany Exp $
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_libjava_examples.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_libjava_examples_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_libjava_examples_InitDefinition() INIT_TEXT_SECTION;
#endif

void _libstx_libjava_examples_InitDefinition(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_libjava_examples__DFN", _libstx_libjava_examples_InitDefinition, "stx:libjava/examples");
_stx_137libjava_137examples_Init(pass,__pRT__,snd);

__END_PACKAGE__();
}

void _libstx_libjava_examples_Init(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_libjava_examples", _libstx_libjava_examples_Init, "stx:libjava/examples");
_stx_137libjava_137examples_Init(pass,__pRT__,snd);


__END_PACKAGE__();
}
