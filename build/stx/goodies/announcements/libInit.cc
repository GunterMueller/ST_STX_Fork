/*
 * $Header: /cvs/stx/stx/goodies/announcements/libInit.cc,v 1.2 2015-03-25 14:31:22 cg Exp $
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_goodies_announcements.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_goodies_announcements_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_goodies_announcements_InitDefinition() INIT_TEXT_SECTION;
#endif

void _libstx_goodies_announcements_InitDefinition(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_goodies_announcements__DFN", _libstx_goodies_announcements_InitDefinition, "stx:goodies/announcements");
_stx_137goodies_137announcements_Init(pass,__pRT__,snd);

__END_PACKAGE__();
}

void _libstx_goodies_announcements_Init(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_goodies_announcements", _libstx_goodies_announcements_Init, "stx:goodies/announcements");
_Announcement_Init(pass,__pRT__,snd);
_AnnouncementClassCollection_Init(pass,__pRT__,snd);
_Announcer_Init(pass,__pRT__,snd);
_Subscription_Init(pass,__pRT__,snd);
_SubscriptionCollection_Init(pass,__pRT__,snd);
_SubscriptionRegistry_Init(pass,__pRT__,snd);
_stx_137goodies_137announcements_Init(pass,__pRT__,snd);
_StrongSubscription_Init(pass,__pRT__,snd);
_WeakBlockSubscription_Init(pass,__pRT__,snd);
_WeakSubscription_Init(pass,__pRT__,snd);

_stx_137goodies_137announcements_extensions_Init(pass,__pRT__,snd);
__END_PACKAGE__();
}
