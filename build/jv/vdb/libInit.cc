/*
 * $Header$
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: jv_vdb.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libjv_vdb_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libjv_vdb_InitDefinition() INIT_TEXT_SECTION;
#endif

extern void _RR_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RREvent_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _VDBAbstractApplication_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _VDBAbstractPresenter_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _VDBEvaluator_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _VDBIconLibrary_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _VDBInstructionBasicBlock_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _VDBSettingsApplication_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _VDBVirtualMemoryMap_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _VDBVirtualMemoryRegion_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _VDBWindowsDebuggerConsoleView_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _jv_137vdb_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RRExitEvent_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _RRStartEvent_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _VDBAbstractContainer_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _VDBAbstractListApplication_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _VDBAbstractUnixConsoleApplication_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _VDBBreakpointApplication_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _VDBBreakpointPresenter_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _VDBDebuggerApplication_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _VDBEventLogApplication_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _VDBFrameApplication_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _VDBFramePresenter_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _VDBInstructionPresenter_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _VDBInstructionsAndSourcePresenter_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _VDBMemoryApplication_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _VDBSourceApplication_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _VDBThreadGroupPresenter_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _VDBThreadPresenter_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _VDBVariableObjectPresenter_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _VDBWindowsDebuggerConsoleApplication_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _VDBAbstractTreeApplication_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _VDBBreakpointListApplication_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _VDBTabbingContainer_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _VDBUnixDebuggerConsoleApplication_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _VDBUnixInferiorConsoleApplication_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _VDBUnixReplayServerConsoleApplication_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _VDBInstructionListApplication_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _VDBStackApplication_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _VDBVariableObjectListApplication_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);

extern void _jv_137vdb_extensions_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);

void _libjv_vdb_InitDefinition(int pass, struct __vmData__ *__pRT__, OBJ snd)
{
  __BEGIN_PACKAGE2__("libjv_vdb__DFN", _libjv_vdb_InitDefinition, "jv:vdb");
    _jv_137vdb_Init(pass,__pRT__,snd);

  __END_PACKAGE__();
}

void _libjv_vdb_Init(int pass, struct __vmData__ *__pRT__, OBJ snd)
{
  __BEGIN_PACKAGE2__("libjv_vdb", _libjv_vdb_Init, "jv:vdb");
    _RR_Init(pass,__pRT__,snd);
    _RREvent_Init(pass,__pRT__,snd);
    _VDBAbstractApplication_Init(pass,__pRT__,snd);
    _VDBAbstractPresenter_Init(pass,__pRT__,snd);
    _VDBEvaluator_Init(pass,__pRT__,snd);
    _VDBIconLibrary_Init(pass,__pRT__,snd);
    _VDBInstructionBasicBlock_Init(pass,__pRT__,snd);
    _VDBSettingsApplication_Init(pass,__pRT__,snd);
    _VDBVirtualMemoryMap_Init(pass,__pRT__,snd);
    _VDBVirtualMemoryRegion_Init(pass,__pRT__,snd);
    _VDBWindowsDebuggerConsoleView_Init(pass,__pRT__,snd);
    _jv_137vdb_Init(pass,__pRT__,snd);
    _RRExitEvent_Init(pass,__pRT__,snd);
    _RRStartEvent_Init(pass,__pRT__,snd);
    _VDBAbstractContainer_Init(pass,__pRT__,snd);
    _VDBAbstractListApplication_Init(pass,__pRT__,snd);
    _VDBAbstractUnixConsoleApplication_Init(pass,__pRT__,snd);
    _VDBBreakpointApplication_Init(pass,__pRT__,snd);
    _VDBBreakpointPresenter_Init(pass,__pRT__,snd);
    _VDBDebuggerApplication_Init(pass,__pRT__,snd);
    _VDBEventLogApplication_Init(pass,__pRT__,snd);
    _VDBFrameApplication_Init(pass,__pRT__,snd);
    _VDBFramePresenter_Init(pass,__pRT__,snd);
    _VDBInstructionPresenter_Init(pass,__pRT__,snd);
    _VDBInstructionsAndSourcePresenter_Init(pass,__pRT__,snd);
    _VDBMemoryApplication_Init(pass,__pRT__,snd);
    _VDBSourceApplication_Init(pass,__pRT__,snd);
    _VDBThreadGroupPresenter_Init(pass,__pRT__,snd);
    _VDBThreadPresenter_Init(pass,__pRT__,snd);
    _VDBVariableObjectPresenter_Init(pass,__pRT__,snd);
    _VDBWindowsDebuggerConsoleApplication_Init(pass,__pRT__,snd);
    _VDBAbstractTreeApplication_Init(pass,__pRT__,snd);
    _VDBBreakpointListApplication_Init(pass,__pRT__,snd);
    _VDBTabbingContainer_Init(pass,__pRT__,snd);
    _VDBUnixDebuggerConsoleApplication_Init(pass,__pRT__,snd);
    _VDBUnixInferiorConsoleApplication_Init(pass,__pRT__,snd);
    _VDBUnixReplayServerConsoleApplication_Init(pass,__pRT__,snd);
    _VDBInstructionListApplication_Init(pass,__pRT__,snd);
    _VDBStackApplication_Init(pass,__pRT__,snd);
    _VDBVariableObjectListApplication_Init(pass,__pRT__,snd);

    _jv_137vdb_extensions_Init(pass,__pRT__,snd);
  __END_PACKAGE__();
}
