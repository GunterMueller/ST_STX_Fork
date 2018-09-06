/*
 * $Header$
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_libbasic3.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_libbasic3_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_libbasic3_InitDefinition() INIT_TEXT_SECTION;
#endif

extern void _AbstractSourceCodeManager_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _CallChain_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _Change_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ChangeDeltaInformation_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ChangeNotificationParameter_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ChangeSet_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ChangeSetDiff_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ChangeSetDiffComponent_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ClassOrganizer_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _HTMLDocGenerator_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _HistoryManager_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _MessageTally_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _MessageTracer_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _MethodFinder_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ProfileTree_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ProjectChecker_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ProjectProblem_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _SourceCodeCache_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _SourceCodeManagerError_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _SourceCodeManagerUtilities_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _SystemEnvironment_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _SystemOrganizer_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _TraceBuffer_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _VersionInfo_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _WrappedMethod_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _stx_137libbasic3_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _CVSSourceCodeManager_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ChangeSetDiffEntry_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ChangeSetDiffSet_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ClassChange_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _CompositeChange_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _DataBaseSourceCodeManager_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _DataBaseSourceCodeManagerUtilities_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _DoItChange_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _FileBasedSourceCodeManager_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _FileInChange_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _GitSourceCodeManager_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _InvalidChange_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _MercurialSourceCodeManager_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _MethodChangeNotificationParameter_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _NameSpaceCreationChange_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _OtherChange_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _PerforceSourceCodeManager_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _SourceCodeManagerUtilitiesForContainerBasedManagers_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _SourceCodeManagerUtilitiesForWorkspaceBasedManagers_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _StoreSourceCodeManager_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ClassCategoryChange_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ClassClassVariableChange_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ClassCommentChange_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ClassDefinitionChange_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ClassInitializeChange_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ClassInstVarDefinitionChange_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ClassOtherChange_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ClassPrimitiveChange_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ClassRemoveChange_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ClassRenameChange_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _InfoChange_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _MethodCategoryChangeNotificationParameter_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _MethodCategoryRenameChange_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _MethodChange_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _MethodRemoveChangeNotificationParameter_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _MethodTrapChangeNotificationParameter_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _TimestampChange_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ClassPrimitiveDefinitionsChange_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ClassPrimitiveFunctionsChange_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _ClassPrimitiveVariablesChange_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _MethodCategoryChange_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _MethodDefinitionChange_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _MethodPackageChange_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _MethodPrivacyChange_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _MethodRemoveChange_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _MethodPackageChange_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _MethodPrivacyChange_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _MethodRemoveChange_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _BeeProjectWriter_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _BeeSourceWriter_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _SystemProfiler_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _BeeProjectDefinitionWriter_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);
extern void _BeeProjectSourceWriter_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);

extern void _stx_137libbasic3_extensions_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);

void _libstx_libbasic3_InitDefinition(int pass, struct __vmData__ *__pRT__, OBJ snd)
{
  __BEGIN_PACKAGE2__("libstx_libbasic3__DFN", _libstx_libbasic3_InitDefinition, "stx:libbasic3");
    _stx_137libbasic3_Init(pass,__pRT__,snd);

  __END_PACKAGE__();
}

void _libstx_libbasic3_Init(int pass, struct __vmData__ *__pRT__, OBJ snd)
{
  __BEGIN_PACKAGE2__("libstx_libbasic3", _libstx_libbasic3_Init, "stx:libbasic3");
    _AbstractSourceCodeManager_Init(pass,__pRT__,snd);
    _BeeProjectWriter_Init(pass,__pRT__,snd);
    _BeeSourceWriter_Init(pass,__pRT__,snd);
    _CallChain_Init(pass,__pRT__,snd);
    _Change_Init(pass,__pRT__,snd);
    _ChangeDeltaInformation_Init(pass,__pRT__,snd);
    _ChangeNotificationParameter_Init(pass,__pRT__,snd);
    _ChangeSet_Init(pass,__pRT__,snd);
    _ChangeSetDiff_Init(pass,__pRT__,snd);
    _ChangeSetDiffComponent_Init(pass,__pRT__,snd);
    _ClassOrganizer_Init(pass,__pRT__,snd);
    _HTMLDocGenerator_Init(pass,__pRT__,snd);
    _HistoryManager_Init(pass,__pRT__,snd);
    _MessageTally_Init(pass,__pRT__,snd);
    _MessageTracer_Init(pass,__pRT__,snd);
    _MethodFinder_Init(pass,__pRT__,snd);
    _ProfileTree_Init(pass,__pRT__,snd);
    _ProjectChecker_Init(pass,__pRT__,snd);
    _ProjectProblem_Init(pass,__pRT__,snd);
    _SourceCodeCache_Init(pass,__pRT__,snd);
    _SourceCodeManagerError_Init(pass,__pRT__,snd);
    _SourceCodeManagerUtilities_Init(pass,__pRT__,snd);
    _SystemEnvironment_Init(pass,__pRT__,snd);
    _SystemOrganizer_Init(pass,__pRT__,snd);
    _SystemProfiler_Init(pass,__pRT__,snd);
    _TraceBuffer_Init(pass,__pRT__,snd);
    _VersionInfo_Init(pass,__pRT__,snd);
    _WrappedMethod_Init(pass,__pRT__,snd);
    _stx_137libbasic3_Init(pass,__pRT__,snd);
    _BeeProjectDefinitionWriter_Init(pass,__pRT__,snd);
    _BeeProjectSourceWriter_Init(pass,__pRT__,snd);
    _CVSSourceCodeManager_Init(pass,__pRT__,snd);
    _ChangeSetDiffEntry_Init(pass,__pRT__,snd);
    _ChangeSetDiffSet_Init(pass,__pRT__,snd);
    _ClassChange_Init(pass,__pRT__,snd);
    _CompositeChange_Init(pass,__pRT__,snd);
    _DataBaseSourceCodeManager_Init(pass,__pRT__,snd);
    _DataBaseSourceCodeManagerUtilities_Init(pass,__pRT__,snd);
    _DoItChange_Init(pass,__pRT__,snd);
    _FileBasedSourceCodeManager_Init(pass,__pRT__,snd);
    _FileInChange_Init(pass,__pRT__,snd);
    _GitSourceCodeManager_Init(pass,__pRT__,snd);
    _InvalidChange_Init(pass,__pRT__,snd);
    _MercurialSourceCodeManager_Init(pass,__pRT__,snd);
    _MethodChangeNotificationParameter_Init(pass,__pRT__,snd);
    _NameSpaceCreationChange_Init(pass,__pRT__,snd);
    _OtherChange_Init(pass,__pRT__,snd);
    _PerforceSourceCodeManager_Init(pass,__pRT__,snd);
    _SourceCodeManagerUtilitiesForContainerBasedManagers_Init(pass,__pRT__,snd);
    _SourceCodeManagerUtilitiesForWorkspaceBasedManagers_Init(pass,__pRT__,snd);
    _StoreSourceCodeManager_Init(pass,__pRT__,snd);
    _ClassCategoryChange_Init(pass,__pRT__,snd);
    _ClassClassVariableChange_Init(pass,__pRT__,snd);
    _ClassCommentChange_Init(pass,__pRT__,snd);
    _ClassDefinitionChange_Init(pass,__pRT__,snd);
    _ClassInitializeChange_Init(pass,__pRT__,snd);
    _ClassInstVarDefinitionChange_Init(pass,__pRT__,snd);
    _ClassOtherChange_Init(pass,__pRT__,snd);
    _ClassPrimitiveChange_Init(pass,__pRT__,snd);
    _ClassRemoveChange_Init(pass,__pRT__,snd);
    _ClassRenameChange_Init(pass,__pRT__,snd);
    _InfoChange_Init(pass,__pRT__,snd);
    _MethodCategoryChangeNotificationParameter_Init(pass,__pRT__,snd);
    _MethodCategoryRenameChange_Init(pass,__pRT__,snd);
    _MethodChange_Init(pass,__pRT__,snd);
    _MethodRemoveChangeNotificationParameter_Init(pass,__pRT__,snd);
    _MethodTrapChangeNotificationParameter_Init(pass,__pRT__,snd);
    _TimestampChange_Init(pass,__pRT__,snd);
    _ClassPrimitiveDefinitionsChange_Init(pass,__pRT__,snd);
    _ClassPrimitiveFunctionsChange_Init(pass,__pRT__,snd);
    _ClassPrimitiveVariablesChange_Init(pass,__pRT__,snd);
    _MethodCategoryChange_Init(pass,__pRT__,snd);
    _MethodDefinitionChange_Init(pass,__pRT__,snd);
    _MethodPackageChange_Init(pass,__pRT__,snd);
    _MethodPrivacyChange_Init(pass,__pRT__,snd);
    _MethodRemoveChange_Init(pass,__pRT__,snd);

    _stx_137libbasic3_extensions_Init(pass,__pRT__,snd);
  __END_PACKAGE__();
}
