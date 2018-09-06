/*
 * $Header: /cvs/stx/stx/libwidg3/libInit.cc,v 1.30 2016-01-15 19:58:34 cg Exp $
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_libwidg3.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_libwidg3_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_libwidg3_InitDefinition() INIT_TEXT_SECTION;
#endif

void _libstx_libwidg3_InitDefinition(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_libwidg3__DFN", _libstx_libwidg3_InitDefinition, "stx:libwidg3");
_stx_137libwidg3_Init(pass,__pRT__,snd);

__END_PACKAGE__();
}

void _libstx_libwidg3_Init(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_libwidg3", _libstx_libwidg3_Init, "stx:libwidg3");
_AbstractChart_Init(pass,__pRT__,snd);
_ActionWaitBox_Init(pass,__pRT__,snd);
_AnimatedLabel_Init(pass,__pRT__,snd);
_BarChart3DWidget_Init(pass,__pRT__,snd);
_BarChartWidget_Init(pass,__pRT__,snd);
_BarChartWidgetSpec_Init(pass,__pRT__,snd);
_ChartDescription_Init(pass,__pRT__,snd);
_ChartDescriptionSpec_Init(pass,__pRT__,snd);
_ClockView_Init(pass,__pRT__,snd);
_ColorBulletIndicator_Init(pass,__pRT__,snd);
_DigitalClockView_Init(pass,__pRT__,snd);
_DigitalLedDisplay_Init(pass,__pRT__,snd);
_MeterClackCounter_Init(pass,__pRT__,snd);
_MeterClackCounterSpec_Init(pass,__pRT__,snd);
_MeterWidget_Init(pass,__pRT__,snd);
_MeterWidgetSpec_Init(pass,__pRT__,snd);
_PieChartWidget_Init(pass,__pRT__,snd);
_PieChartWidgetSpec_Init(pass,__pRT__,snd);
_RoundProgressIndicator_Init(pass,__pRT__,snd);
_SimpleFunctionGraphView_Init(pass,__pRT__,snd);
_VUMeter_Init(pass,__pRT__,snd);
_stx_137libwidg3_Init(pass,__pRT__,snd);
_BarChart_Init(pass,__pRT__,snd);
_ChartKey_Init(pass,__pRT__,snd);
_PieChart_Init(pass,__pRT__,snd);


__END_PACKAGE__();
}
