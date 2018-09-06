/*
 * $Header$
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_libsvn.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_libsvn_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_libsvn_InitDefinition() INIT_TEXT_SECTION;
#endif

void _libstx_libsvn_InitDefinition(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_libsvn__DFN", _libstx_libsvn_InitDefinition, "stx:libsvn");
_stx_137libsvn_Init(pass,__pRT__,snd);

__END_PACKAGE__();
}

void _libstx_libsvn_Init(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_libsvn", _libstx_libsvn_Init, "stx:libsvn");
_SVN__Branch_Init(pass,__pRT__,snd);
_SVN__BranchQuery_Init(pass,__pRT__,snd);
_SVN__Browser_Init(pass,__pRT__,snd);
_SVN__Cache_Init(pass,__pRT__,snd);
_SVN__CacheEntry_Init(pass,__pRT__,snd);
_SVN__Command_Init(pass,__pRT__,snd);
_SVN__CompatModeQuery_Init(pass,__pRT__,snd);
_SVN__Configuration_Init(pass,__pRT__,snd);
_SVN__ConfigurationApp_Init(pass,__pRT__,snd);
_SVN__Credentials_Init(pass,__pRT__,snd);
_SVN__Dialog_Init(pass,__pRT__,snd);
_SVN__DiffViewApp_Init(pass,__pRT__,snd);
_SVN__Entry_Init(pass,__pRT__,snd);
_SVN__Enum_Init(pass,__pRT__,snd);
_SVN__ExternalMergeTool_Init(pass,__pRT__,snd);
_SVN__IconLibrary_Init(pass,__pRT__,snd);
_SVN__MergeBrowser_Init(pass,__pRT__,snd);
_SVN__OSProcess_Init(pass,__pRT__,snd);
_SVN__PackagePattern_Init(pass,__pRT__,snd);
_SVN__Property_Init(pass,__pRT__,snd);
_SVN__Repository_Init(pass,__pRT__,snd);
_SVN__RepositoryConfiguration_Init(pass,__pRT__,snd);
_SVN__RepositoryManager_Init(pass,__pRT__,snd);
_SVN__Revision_Init(pass,__pRT__,snd);
_SVN__RevisionRange_Init(pass,__pRT__,snd);
_SVN__SVNError_Init(pass,__pRT__,snd);
_SVN__Task_Init(pass,__pRT__,snd);
_SVN__WCAction_Init(pass,__pRT__,snd);
_SVN__WCActionNotification_Init(pass,__pRT__,snd);
_SVN__WCError_Init(pass,__pRT__,snd);
_SVN__WizardPane_Init(pass,__pRT__,snd);
_SVN__WorkingCopy_Init(pass,__pRT__,snd);
_SVN__XMLObject_Init(pass,__pRT__,snd);
_SVNSourceCodeManager_Init(pass,__pRT__,snd);
_stx_137libsvn_Init(pass,__pRT__,snd);
_SVN__AuthorizationError_Init(pass,__pRT__,snd);
_SVN__BranchAndRevisionSelectionDialog_Init(pass,__pRT__,snd);
_SVN__BranchCommand_Init(pass,__pRT__,snd);
_SVN__BranchSelectionDialog_Init(pass,__pRT__,snd);
_SVN__CVSTask_Init(pass,__pRT__,snd);
_SVN__CommitDialog2_Init(pass,__pRT__,snd);
_SVN__ConfigurationDialog_Init(pass,__pRT__,snd);
_SVN__CreateRepositoryCommand_Init(pass,__pRT__,snd);
_SVN__CredentialsDialog_Init(pass,__pRT__,snd);
_SVN__FileoutLikeTask_Init(pass,__pRT__,snd);
_SVN__KDiff3_Init(pass,__pRT__,snd);
_SVN__MergeViewApp_Init(pass,__pRT__,snd);
_SVN__NodeKind_Init(pass,__pRT__,snd);
_SVN__NonExistentURLError_Init(pass,__pRT__,snd);
_SVN__ProgressDialog_Init(pass,__pRT__,snd);
_SVN__RepositoryDialog_Init(pass,__pRT__,snd);
_SVN__RepositoryEntry_Init(pass,__pRT__,snd);
_SVN__RevisionBase_Init(pass,__pRT__,snd);
_SVN__RevisionDate_Init(pass,__pRT__,snd);
_SVN__RevisionHead_Init(pass,__pRT__,snd);
_SVN__RevisionLogBrowser_Init(pass,__pRT__,snd);
_SVN__RevisionLogEntry_Init(pass,__pRT__,snd);
_SVN__RevisionNumber_Init(pass,__pRT__,snd);
_SVN__Status_Init(pass,__pRT__,snd);
_SVN__UnknownError_Init(pass,__pRT__,snd);
_SVN__WCActionAdded_Init(pass,__pRT__,snd);
_SVN__WCActionConflict_Init(pass,__pRT__,snd);
_SVN__WCActionDeleted_Init(pass,__pRT__,snd);
_SVN__WCActionMerged_Init(pass,__pRT__,snd);
_SVN__WCActionModified_Init(pass,__pRT__,snd);
_SVN__WCActionNone_Init(pass,__pRT__,snd);
_SVN__WCActionRestored_Init(pass,__pRT__,snd);
_SVN__WCActionUpdated_Init(pass,__pRT__,snd);
_SVN__WCCommand_Init(pass,__pRT__,snd);
_SVN__WCEntry_Init(pass,__pRT__,snd);
_SVN__WCEntryInfo_Init(pass,__pRT__,snd);
_SVN__Wizard_Init(pass,__pRT__,snd);
_SVN__WorkingCopyBrowser_Init(pass,__pRT__,snd);
_SVN__WorkingCopyLockedError_Init(pass,__pRT__,snd);
_SVN__CatCommand_Init(pass,__pRT__,snd);
_SVN__CleanupCommand_Init(pass,__pRT__,snd);
_SVN__CommitTask_Init(pass,__pRT__,snd);
_SVN__CommitWizard_Init(pass,__pRT__,snd);
_SVN__CopyCommand_Init(pass,__pRT__,snd);
_SVN__ExportCommand_Init(pass,__pRT__,snd);
_SVN__ImportFromCVSTask_Init(pass,__pRT__,snd);
_SVN__ListCommand_Init(pass,__pRT__,snd);
_SVN__LogCommand_Init(pass,__pRT__,snd);
_SVN__MoveCommand_Init(pass,__pRT__,snd);
_SVN__NodeKindDir_Init(pass,__pRT__,snd);
_SVN__NodeKindExternal_Init(pass,__pRT__,snd);
_SVN__NodeKindFile_Init(pass,__pRT__,snd);
_SVN__NodeKindNone_Init(pass,__pRT__,snd);
_SVN__NodeKindUnknown_Init(pass,__pRT__,snd);
_SVN__StatusAdded_Init(pass,__pRT__,snd);
_SVN__StatusConflicted_Init(pass,__pRT__,snd);
_SVN__StatusDeleted_Init(pass,__pRT__,snd);
_SVN__StatusExternal_Init(pass,__pRT__,snd);
_SVN__StatusIgnored_Init(pass,__pRT__,snd);
_SVN__StatusIncomplete_Init(pass,__pRT__,snd);
_SVN__StatusMissing_Init(pass,__pRT__,snd);
_SVN__StatusModified_Init(pass,__pRT__,snd);
_SVN__StatusNormal_Init(pass,__pRT__,snd);
_SVN__StatusObstructed_Init(pass,__pRT__,snd);
_SVN__StatusReplaced_Init(pass,__pRT__,snd);
_SVN__StatusUnversioned_Init(pass,__pRT__,snd);
_SVN__SyncWithCVSTask_Init(pass,__pRT__,snd);
_SVN__UpdateLikeCommand_Init(pass,__pRT__,snd);
_SVN__UpdateLikeTask_Init(pass,__pRT__,snd);
_SVN__WCPathCommand_Init(pass,__pRT__,snd);
_SVN__AddCommand_Init(pass,__pRT__,snd);
_SVN__CheckoutCommand_Init(pass,__pRT__,snd);
_SVN__CommitCommand_Init(pass,__pRT__,snd);
_SVN__DeleteCommand_Init(pass,__pRT__,snd);
_SVN__InfoCommand_Init(pass,__pRT__,snd);
_SVN__MergeCommand_Init(pass,__pRT__,snd);
_SVN__MergeTask_Init(pass,__pRT__,snd);
_SVN__PropsetCommand_Init(pass,__pRT__,snd);
_SVN__ResolvedCommand_Init(pass,__pRT__,snd);
_SVN__RevertCommand_Init(pass,__pRT__,snd);
_SVN__StatusCommand_Init(pass,__pRT__,snd);
_SVN__UpdateCommand_Init(pass,__pRT__,snd);
_SVN__UpdateTask_Init(pass,__pRT__,snd);

_stx_137libsvn_extensions_Init(pass,__pRT__,snd);
__END_PACKAGE__();
}
