/*
 * $Header$
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_libscm_git.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_libscm_git_Init() INIT_TEXT_SECTION;
// DLL_EXPORT void _libstx_libscm_git_InitDefinition() INIT_TEXT_SECTION;
#endif

// void _libstx_libscm_git_InitDefinition(pass, __pRT__, snd)
// OBJ snd; struct __vmData__ *__pRT__; {
// __BEGIN_PACKAGE2__("libstx_libscm_git__DFN", _libstx_libscm_git_InitDefinition, "stx:libscm/git");
// _stx_137libscm_137git_Init(pass,__pRT__,snd);

// __END_PACKAGE__();
// }

void _libstx_libscm_git_Init(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_libscm_git", _libstx_libscm_git_Init, "stx:libscm/git");
_GitAttrType_Init(pass,__pRT__,snd);
_GitBlobHandle_Init(pass,__pRT__,snd);
_GitBranchType_Init(pass,__pRT__,snd);
_GitCheckoutStrategy_Init(pass,__pRT__,snd);
_GitCommand_Init(pass,__pRT__,snd);
_GitCommitDialog_Init(pass,__pRT__,snd);
_GitCommitHandle_Init(pass,__pRT__,snd);
_GitConfigHandle_Init(pass,__pRT__,snd);
_GitCvarType_Init(pass,__pRT__,snd);
_GitDeltaType_Init(pass,__pRT__,snd);
_GitDiffListHandle_Init(pass,__pRT__,snd);
_GitErrorKlass_Init(pass,__pRT__,snd);
_GitFilemodeType_Init(pass,__pRT__,snd);
_GitIconLibrary_Init(pass,__pRT__,snd);
_GitIndexHandle_Init(pass,__pRT__,snd);
_GitIndexerHandle_Init(pass,__pRT__,snd);
_GitIndexerStreamHandle_Init(pass,__pRT__,snd);
_GitLibraryObject_Init(pass,__pRT__,snd);
_GitNoteHandle_Init(pass,__pRT__,snd);
_GitObjectHandle_Init(pass,__pRT__,snd);
_GitObjectType_Init(pass,__pRT__,snd);
_GitOdbHandle_Init(pass,__pRT__,snd);
_GitOdbObjectHandle_Init(pass,__pRT__,snd);
_GitOid_Init(pass,__pRT__,snd);
_GitOidShortenHandle_Init(pass,__pRT__,snd);
_GitPackageModel_Init(pass,__pRT__,snd);
_GitPackageModelRegistry_Init(pass,__pRT__,snd);
_GitPrimitives_Init(pass,__pRT__,snd);
_GitRefType_Init(pass,__pRT__,snd);
_GitReferenceHandle_Init(pass,__pRT__,snd);
_GitReflogEntryHandle_Init(pass,__pRT__,snd);
_GitReflogHandle_Init(pass,__pRT__,snd);
_GitRefspecHandle_Init(pass,__pRT__,snd);
_GitRemoteCompletionType_Init(pass,__pRT__,snd);
_GitRemoteHandle_Init(pass,__pRT__,snd);
_GitRepositoryHandle_Init(pass,__pRT__,snd);
_GitResetType_Init(pass,__pRT__,snd);
_GitRevwalkHandle_Init(pass,__pRT__,snd);
_GitSignatureQuery_Init(pass,__pRT__,snd);
_GitSourceCodeManagementSettingsAppl2_Init(pass,__pRT__,snd);
_GitSourceCodeManager2_Init(pass,__pRT__,snd);
_GitStatusCodes_Init(pass,__pRT__,snd);
_GitStatusShowType_Init(pass,__pRT__,snd);
_GitStructure_Init(pass,__pRT__,snd);
_GitSubmoduleHandle_Init(pass,__pRT__,snd);
_GitSubmoduleIgnoreType_Init(pass,__pRT__,snd);
_GitSubmoduleStatusType_Init(pass,__pRT__,snd);
_GitSubmoduleUpdateType_Init(pass,__pRT__,snd);
_GitTagHandle_Init(pass,__pRT__,snd);
_GitTreeEntryHandle_Init(pass,__pRT__,snd);
_GitTreeHandle_Init(pass,__pRT__,snd);
_GitTreebuilderHandle_Init(pass,__pRT__,snd);
_GitTreewalkModeType_Init(pass,__pRT__,snd);
_stx_137libscm_137git_Init(pass,__pRT__,snd);
_GitAuthorQuery_Init(pass,__pRT__,snd);
_GitCheckoutOptions_Init(pass,__pRT__,snd);
_GitCommitterQuery_Init(pass,__pRT__,snd);
_GitConfigFileStructure_Init(pass,__pRT__,snd);
_GitCvarMapStructure_Init(pass,__pRT__,snd);
_GitDiffDeltaStructure_Init(pass,__pRT__,snd);
_GitDiffFileStructure_Init(pass,__pRT__,snd);
_GitDiffOptionsStructure_Init(pass,__pRT__,snd);
_GitDiffRangeStructure_Init(pass,__pRT__,snd);
_GitError_Init(pass,__pRT__,snd);
_GitErrorStructure_Init(pass,__pRT__,snd);
_GitIndex_Init(pass,__pRT__,snd);
_GitIndexEntryStructure_Init(pass,__pRT__,snd);
_GitIndexEntryUnmergedStructure_Init(pass,__pRT__,snd);
_GitIndexTimeStructure_Init(pass,__pRT__,snd);
_GitIndexerStatsStructure_Init(pass,__pRT__,snd);
_GitNoteDataStructure_Init(pass,__pRT__,snd);
_GitOdbBackendStructure_Init(pass,__pRT__,snd);
_GitOdbStreamStructure_Init(pass,__pRT__,snd);
_GitReference_Init(pass,__pRT__,snd);
_GitRemoteCallbacksStructure_Init(pass,__pRT__,snd);
_GitRemoteHeadStructure_Init(pass,__pRT__,snd);
_GitRepository_Init(pass,__pRT__,snd);
_GitRepositoryInitOptionsStructure_Init(pass,__pRT__,snd);
_GitRepositoryObject_Init(pass,__pRT__,snd);
_GitSignature_Init(pass,__pRT__,snd);
_GitSignatureStructure_Init(pass,__pRT__,snd);
_GitStatusOptionsStructure_Init(pass,__pRT__,snd);
_GitStringArray_Init(pass,__pRT__,snd);
_GitTimeStructure_Init(pass,__pRT__,snd);
_GitWorkingCopyEntry_Init(pass,__pRT__,snd);
_GitObject_Init(pass,__pRT__,snd);
_GitRemote_Init(pass,__pRT__,snd);
_GitWorkingCopy_Init(pass,__pRT__,snd);
_GitCommit_Init(pass,__pRT__,snd);
_GitTag_Init(pass,__pRT__,snd);
_GitTree_Init(pass,__pRT__,snd);

_stx_137libscm_137git_extensions_Init(pass,__pRT__,snd);
__END_PACKAGE__();
}
