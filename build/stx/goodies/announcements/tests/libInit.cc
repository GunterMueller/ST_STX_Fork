/*
 * $Header: /cvs/stx/stx/goodies/announcements/tests/libInit.cc,v 1.2 2013-04-15 15:36:02 cg Exp $
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_goodies_announcements_tests.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_goodies_announcements_tests_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_goodies_announcements_tests_InitDefinition() INIT_TEXT_SECTION;
#endif

void _libstx_goodies_announcements_tests_InitDefinition(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_goodies_announcements_tests__DFN", _libstx_goodies_announcements_tests_InitDefinition, "stx:goodies/announcements/tests");
_stx_137goodies_137announcements_137tests_Init(pass,__pRT__,snd);

__END_PACKAGE__();
}

void _libstx_goodies_announcements_tests_Init(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_goodies_announcements_tests", _libstx_goodies_announcements_tests_Init, "stx:goodies/announcements/tests");
_PerformanceTest_Init(pass,__pRT__,snd);
_TestAnnouncement1_Init(pass,__pRT__,snd);
_TestAnnouncement2_Init(pass,__pRT__,snd);
_TestSubscriber_Init(pass,__pRT__,snd);
_stx_137goodies_137announcements_137tests_Init(pass,__pRT__,snd);


__END_PACKAGE__();
}
