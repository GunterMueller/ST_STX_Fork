/*
 * $Header$
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_goodies_sunit.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_goodies_sunit_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_goodies_sunit_InitDefinition() INIT_TEXT_SECTION;
#endif

extern void _MetricsReporter_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _SUnitDelay_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _SUnitNameResolver_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _TestAsserter_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _TestCaseOutcome_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _TestCoverageReporter_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _TestFailure_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _TestResult_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _TestResultReporter_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _TestRunner_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _TestSuite_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _TestSuitesScripter_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _stx_137goodies_137sunit_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ResumableTestFailure_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _TestCase_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _TestResource_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _TestResultStX_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _TestSkipped_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _TestCaseWithArguments_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _TestResultForRunWithDebug_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);

extern void _stx_137goodies_137sunit_extensions_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);

void _libstx_goodies_sunit_InitDefinition(int pass, struct __vmData__ *__pRT__, OBJ snd)
{
  __BEGIN_PACKAGE2__("libstx_goodies_sunit__DFN", _libstx_goodies_sunit_InitDefinition, "stx:goodies/sunit");
    _stx_137goodies_137sunit_Init(pass,__pRT__,snd);

  __END_PACKAGE__();
}

void _libstx_goodies_sunit_Init(int pass, struct __vmData__ *__pRT__, OBJ snd)
{
  __BEGIN_PACKAGE2__("libstx_goodies_sunit", _libstx_goodies_sunit_Init, "stx:goodies/sunit");
    _MetricsReporter_Init(pass,__pRT__,snd);
    _SUnitDelay_Init(pass,__pRT__,snd);
    _SUnitNameResolver_Init(pass,__pRT__,snd);
    _TestAsserter_Init(pass,__pRT__,snd);
    _TestCaseOutcome_Init(pass,__pRT__,snd);
    _TestCoverageReporter_Init(pass,__pRT__,snd);
    _TestFailure_Init(pass,__pRT__,snd);
    _TestResult_Init(pass,__pRT__,snd);
    _TestResultReporter_Init(pass,__pRT__,snd);
    _TestRunner_Init(pass,__pRT__,snd);
    _TestSuite_Init(pass,__pRT__,snd);
    _TestSuitesScripter_Init(pass,__pRT__,snd);
    _stx_137goodies_137sunit_Init(pass,__pRT__,snd);
    _ResumableTestFailure_Init(pass,__pRT__,snd);
    _TestCase_Init(pass,__pRT__,snd);
    _TestResource_Init(pass,__pRT__,snd);
    _TestResultStX_Init(pass,__pRT__,snd);
    _TestSkipped_Init(pass,__pRT__,snd);
    _TestCaseWithArguments_Init(pass,__pRT__,snd);
    _TestResultForRunWithDebug_Init(pass,__pRT__,snd);

    _stx_137goodies_137sunit_extensions_Init(pass,__pRT__,snd);
  __END_PACKAGE__();
}
