/*
 * $Header: /cvs/stx/stx/goodies/magritte/morph/libInit.cc,v 1.1 2009-07-29 17:58:33 cg Exp $
 *
 * DO NOT EDIT 
 * automagically generated from the projectDefinition: stx_goodies_magritte_morph.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif 

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_goodies_magritte_morph_Init() INIT_TEXT_SECTION;
#endif

void _libstx_goodies_magritte_morph_Init(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_goodies_magritte_morph", _libstx_goodies_magritte_morph_Init, "stx:goodies/magritte/morph");
_Magritte__MADescriptionMorph_Init(pass,__pRT__,snd);
_stx_137goodies_137magritte_137morph_Init(pass,__pRT__,snd);
_Magritte__MAContainerMorph_Init(pass,__pRT__,snd);
_Magritte__MAElementMorph_Init(pass,__pRT__,snd);
_Magritte__MACheckboxMorph_Init(pass,__pRT__,snd);
_Magritte__MAFileMorph_Init(pass,__pRT__,snd);
_Magritte__MAListMorph_Init(pass,__pRT__,snd);
_Magritte__MAMemoMorph_Init(pass,__pRT__,snd);
_Magritte__MASilentContainerMorph_Init(pass,__pRT__,snd);
_Magritte__MAMultiSelectListMorph_Init(pass,__pRT__,snd);
_Magritte__MASingleSelectListMorph_Init(pass,__pRT__,snd);
_Magritte__MATextMorph_Init(pass,__pRT__,snd);
_Magritte__MAPasswordMorph_Init(pass,__pRT__,snd);

_stx_137goodies_137magritte_137morph_extensions_Init(pass,__pRT__,snd);
__END_PACKAGE__();
}
