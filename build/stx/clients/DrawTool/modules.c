/* $Header: /cvs/stx/stx/clients/DrawTool/modules.c,v 1.1 2006-09-22 11:08:40 stefan Exp $
 *
 * DO NOT EDIT 
 * automagically generated from the projectDefinition: stx_clients_DrawTool.
 *
 * Warning: once you modify this file, do not rerun
 * stmkmp or projectDefinition-build again - otherwise, your changes are lost.
 */
typedef void (*vf)();

extern void _DrawObject_Init();
extern void _DrawTool_Init();
extern void _DrawView_Init();
extern void _PatternMenu_Init();
extern void _stx_137clients_137DrawTool_Init();
extern void _DrawEllipse_Init();
extern void _DrawGroup_Init();
extern void _DrawLine_Init();
extern void _DrawPolygon_Init();
extern void _DrawRectangle_Init();
extern void _DrawText_Init();
extern void _LineMenu_Init();
extern void _RectangularDrawObject_Init();
extern void _DrawArrow_Init();
extern void _DrawCircle_Init();
extern void _DrawCurve_Init();
extern void _DrawHLine_Init();
extern void _DrawImage_Init();
extern void _DrawRectangle3D_Init();
extern void _DrawRoundRectangle_Init();
extern void _DrawSpline_Init();
extern void _DrawVLine_Init();


static vf modules[] = {
    _DrawObject_Init,
_DrawTool_Init,
_DrawView_Init,
_PatternMenu_Init,
_stx_137clients_137DrawTool_Init,
_DrawEllipse_Init,
_DrawGroup_Init,
_DrawLine_Init,
_DrawPolygon_Init,
_DrawRectangle_Init,
_DrawText_Init,
_LineMenu_Init,
_RectangularDrawObject_Init,
_DrawArrow_Init,
_DrawCircle_Init,
_DrawCurve_Init,
_DrawHLine_Init,
_DrawImage_Init,
_DrawRectangle3D_Init,
_DrawRoundRectangle_Init,
_DrawSpline_Init,
_DrawVLine_Init,

    (vf)0
};

vf *__modules__ = modules;
