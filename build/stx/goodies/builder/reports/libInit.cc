/*
 * $Header$
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_goodies_builder_reports.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_goodies_builder_reports_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_goodies_builder_reports_InitDefinition() INIT_TEXT_SECTION;
#endif

void _libstx_goodies_builder_reports_InitDefinition(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_goodies_builder_reports__DFN", _libstx_goodies_builder_reports_InitDefinition, "stx:goodies/builder/reports");
_stx_137goodies_137builder_137reports_Init(pass,__pRT__,snd);

__END_PACKAGE__();
}

void _libstx_goodies_builder_reports_Init(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_goodies_builder_reports", _libstx_goodies_builder_reports_Init, "stx:goodies/builder/reports");
_Builder__Report_Init(pass,__pRT__,snd);
_Builder__ReportFormat_Init(pass,__pRT__,snd);
_Builder__ReportRunner_Init(pass,__pRT__,snd);
_Builder__ReportSourceInfo_Init(pass,__pRT__,snd);
_stx_137goodies_137builder_137reports_Init(pass,__pRT__,snd);
_Builder__ChangeReport_Init(pass,__pRT__,snd);
_Builder__CoverageReport_Init(pass,__pRT__,snd);
_Builder__CoverageReportFormat_Init(pass,__pRT__,snd);
_Builder__LintReport_Init(pass,__pRT__,snd);
_Builder__LintReportFormat_Init(pass,__pRT__,snd);
_Builder__ReportClassSourceInfo_Init(pass,__pRT__,snd);
_Builder__ReportExtensionsSourceInfo_Init(pass,__pRT__,snd);
_Builder__TestReport_Init(pass,__pRT__,snd);
_Builder__TestReportFormat_Init(pass,__pRT__,snd);

_stx_137goodies_137builder_137reports_extensions_Init(pass,__pRT__,snd);
__END_PACKAGE__();
}
