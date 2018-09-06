/*
 * $Header: /cvs/stx/stx/libview3/libInit.cc,v 1.9 2013-03-01 13:26:39 stefan Exp $
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_libview3.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_libview3_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_libview3_InitDefinition() INIT_TEXT_SECTION;
#endif

void _libstx_libview3_InitDefinition(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_libview3__DFN", _libstx_libview3_InitDefinition, "stx:libview3");
_stx_137libview3_Init(pass,__pRT__,snd);

__END_PACKAGE__();
}

void _libstx_libview3_Init(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_libview3", _libstx_libview3_Init, "stx:libview3");
_DisplayObjectComponentSpec_Init(pass,__pRT__,snd);
_Morph_Init(pass,__pRT__,snd);
_stx_137libview3_Init(pass,__pRT__,snd);
_ArcMorph_Init(pass,__pRT__,snd);
_ArcMorphSpec_Init(pass,__pRT__,snd);
_LineSegmentMorph_Init(pass,__pRT__,snd);
_LineSegmentMorphSpec_Init(pass,__pRT__,snd);
_RectangleMorph_Init(pass,__pRT__,snd);
_RectangleMorphSpec_Init(pass,__pRT__,snd);
_SketchMorph_Init(pass,__pRT__,snd);
_SketchMorphSpec_Init(pass,__pRT__,snd);


__END_PACKAGE__();
}
