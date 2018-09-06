/*
 * $Header: /cvs/stx/stx/goodies/communication/bitTorrent/libInit.cc,v 1.2 2011-01-08 12:24:59 cg Exp $
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_goodies_communication_bitTorrent.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_goodies_communication_bitTorrent_Init() INIT_TEXT_SECTION;
// DLL_EXPORT void _libstx_goodies_communication_bitTorrent_InitDefinition() INIT_TEXT_SECTION;
#endif

// void _libstx_goodies_communication_bitTorrent_InitDefinition(pass, __pRT__, snd)
// OBJ snd; struct __vmData__ *__pRT__; {
// __BEGIN_PACKAGE2__("libstx_goodies_communication_bitTorrent__DFN", _libstx_goodies_communication_bitTorrent_InitDefinition, "stx:goodies/communication/bitTorrent");
// _stx_137goodies_137communication_137bitTorrent_Init(pass,__pRT__,snd);

// __END_PACKAGE__();
// }

void _libstx_goodies_communication_bitTorrent_Init(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_goodies_communication_bitTorrent", _libstx_goodies_communication_bitTorrent_Init, "stx:goodies/communication/bitTorrent");
_BitTorrentBDecoder_Init(pass,__pRT__,snd);
_BitTorrentBEncoder_Init(pass,__pRT__,snd);
_BitTorrentTorrentFileContents_Init(pass,__pRT__,snd);
_BitTorrentTorrentFileRecord_Init(pass,__pRT__,snd);
_BitTorrentTorrentInfoRecord_Init(pass,__pRT__,snd);
_stx_137goodies_137communication_137bitTorrent_Init(pass,__pRT__,snd);


__END_PACKAGE__();
}
