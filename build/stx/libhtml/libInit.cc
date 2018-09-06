/*
 * $Header: /cvs/stx/stx/libhtml/libInit.cc,v 1.32 2014-07-08 22:49:53 cg Exp $
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_libhtml.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_libhtml_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_libhtml_InitDefinition() INIT_TEXT_SECTION;
#endif

void _libstx_libhtml_InitDefinition(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_libhtml__DFN", _libstx_libhtml_InitDefinition, "stx:libhtml");
_stx_137libhtml_Init(pass,__pRT__,snd);

__END_PACKAGE__();
}

void _libstx_libhtml_Init(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_libhtml", _libstx_libhtml_Init, "stx:libhtml");
_DidYouKnowTipViewer_Init(pass,__pRT__,snd);
_HTMLDocument_Init(pass,__pRT__,snd);
_HTMLDocumentFrame_Init(pass,__pRT__,snd);
_HTMLDocumentInterpreter_Init(pass,__pRT__,snd);
_HTMLDocumentViewerApplication_Init(pass,__pRT__,snd);
_HTMLElement_Init(pass,__pRT__,snd);
_HTMLFontStyle_Init(pass,__pRT__,snd);
_HTMLPageStyle_Init(pass,__pRT__,snd);
_HTMLParser_Init(pass,__pRT__,snd);
_HTMLScriptEnvironment_Init(pass,__pRT__,snd);
_HTMLTableCol_Init(pass,__pRT__,snd);
_HTMLTableRow_Init(pass,__pRT__,snd);
_HTMLView_Init(pass,__pRT__,snd);
_URL_Init(pass,__pRT__,snd);
_stx_137libhtml_Init(pass,__pRT__,snd);
_HTMLDocumentPainter_Init(pass,__pRT__,snd);
_HTMLDocumentView_Init(pass,__pRT__,snd);
_HTMLMarkup_Init(pass,__pRT__,snd);
_HTMLText_Init(pass,__pRT__,snd);
_HTMLAnchor_Init(pass,__pRT__,snd);
_HTMLBullet_Init(pass,__pRT__,snd);
_HTMLCRMarkupText_Init(pass,__pRT__,snd);
_HTMLForm_Init(pass,__pRT__,snd);
_HTMLList_Init(pass,__pRT__,snd);
_HTMLMarkupText_Init(pass,__pRT__,snd);
_HTMLScript_Init(pass,__pRT__,snd);
_HTMLStyle_Init(pass,__pRT__,snd);
_HTMLTable_Init(pass,__pRT__,snd);
_HTMLWidget_Init(pass,__pRT__,snd);
_HTMLApplet_Init(pass,__pRT__,snd);
_HTMLImage_Init(pass,__pRT__,snd);


__END_PACKAGE__();
}
