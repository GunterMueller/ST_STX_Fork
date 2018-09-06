/*
 * $Header: /cvs/stx/stx/clients/DrawTool/libInit.cc,v 1.5 2013-04-26 07:39:35 stefan Exp $
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_clients_DrawTool.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_clients_DrawTool_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_clients_DrawTool_InitDefinition() INIT_TEXT_SECTION;
#endif

void _libstx_clients_DrawTool_InitDefinition(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_clients_DrawTool__DFN", _libstx_clients_DrawTool_InitDefinition, "stx:clients/DrawTool");
_stx_137clients_137DrawTool_Init(pass,__pRT__,snd);

__END_PACKAGE__();
}

void _libstx_clients_DrawTool_Init(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_clients_DrawTool", _libstx_clients_DrawTool_Init, "stx:clients/DrawTool");
_DrawObject_Init(pass,__pRT__,snd);
_DrawTool_Init(pass,__pRT__,snd);
_DrawView_Init(pass,__pRT__,snd);
_PatternMenu_Init(pass,__pRT__,snd);
_stx_137clients_137DrawTool_Init(pass,__pRT__,snd);
_DrawEllipse_Init(pass,__pRT__,snd);
_DrawGroup_Init(pass,__pRT__,snd);
_DrawLine_Init(pass,__pRT__,snd);
_DrawPolygon_Init(pass,__pRT__,snd);
_DrawRectangle_Init(pass,__pRT__,snd);
_DrawText_Init(pass,__pRT__,snd);
_LineMenu_Init(pass,__pRT__,snd);
_RectangularDrawObject_Init(pass,__pRT__,snd);
_DrawArrow_Init(pass,__pRT__,snd);
_DrawCircle_Init(pass,__pRT__,snd);
_DrawCurve_Init(pass,__pRT__,snd);
_DrawHLine_Init(pass,__pRT__,snd);
_DrawImage_Init(pass,__pRT__,snd);
_DrawRectangle3D_Init(pass,__pRT__,snd);
_DrawRoundRectangle_Init(pass,__pRT__,snd);
_DrawSpline_Init(pass,__pRT__,snd);
_DrawVLine_Init(pass,__pRT__,snd);


__END_PACKAGE__();
}
