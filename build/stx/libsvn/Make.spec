# $Header$
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_libsvn.
#
# Warning: once you modify this file, do not rerun
# stmkmp or projectDefinition-build again - otherwise, your changes are lost.
#
# This file contains specifications which are common to all platforms.
#

# Do NOT CHANGE THESE DEFINITIONS
# (otherwise, ST/X will have a hard time to find out the packages location from its packageID,
#  to find the source code of a class and to find the library for a package)
MODULE=stx
MODULE_DIR=libsvn
PACKAGE=$(MODULE):$(MODULE_DIR)


# Argument(s) to the stc compiler (stc --usage).
#  -headerDir=. : create header files locally
#                (if removed, they will be created as common
#  -Pxxx       : defines the package
#  -Zxxx       : a prefix for variables within the classLib
#  -Dxxx       : defines passed to to CC for inline C-code
#  -Ixxx       : include path passed to CC for inline C-code
#  +optspace   : optimized for space
#  +optspace2  : optimized more for space
#  +optspace3  : optimized even more for space
#  +optinline  : generate inline code for some ST constructs
#  +inlineNew  : additionally inline new
#  +inlineMath : additionally inline some floatPnt math stuff
#
# ********** OPTIONAL: MODIFY the next line(s) ***
# STCLOCALOPTIMIZATIONS=+optinline +inlineNew
# STCLOCALOPTIMIZATIONS=+optspace3
STCLOCALOPTIMIZATIONS=+optspace3


# Argument(s) to the stc compiler (stc --usage).
#  -warn            : no warnings
#  -warnNonStandard : no warnings about ST/X extensions
#  -warnEOLComments : no warnings about EOL comment extension
#  -warnPrivacy     : no warnings about privateClass extension
#  -warnUnused      : no warnings about unused variables
#
# ********** OPTIONAL: MODIFY the next line(s) ***
# STCWARNINGS=-warn
# STCWARNINGS=-warnNonStandard
# STCWARNINGS=-warnEOLComments
STCWARNINGS=-warnNonStandard

COMMON_CLASSES= \
	SVN::Branch \
	SVN::BranchQuery \
	SVN::Browser \
	SVN::Cache \
	SVN::CacheEntry \
	SVN::Command \
	SVN::CompatModeQuery \
	SVN::Configuration \
	SVN::ConfigurationApp \
	SVN::Credentials \
	SVN::Dialog \
	SVN::DiffViewApp \
	SVN::Entry \
	SVN::Enum \
	SVN::ExternalMergeTool \
	SVN::IconLibrary \
	SVN::MergeBrowser \
	SVN::OSProcess \
	SVN::PackagePattern \
	SVN::Property \
	SVN::Repository \
	SVN::RepositoryConfiguration \
	SVN::RepositoryManager \
	SVN::Revision \
	SVN::RevisionRange \
	SVN::SVNError \
	SVN::Task \
	SVN::WCAction \
	SVN::WCActionNotification \
	SVN::WCError \
	SVN::WizardPane \
	SVN::WorkingCopy \
	SVN::XMLObject \
	SVNSourceCodeManager \
	stx_libsvn \
	SVN::AuthorizationError \
	SVN::BranchAndRevisionSelectionDialog \
	SVN::BranchCommand \
	SVN::BranchSelectionDialog \
	SVN::CVSTask \
	SVN::CommitDialog2 \
	SVN::ConfigurationDialog \
	SVN::CreateRepositoryCommand \
	SVN::CredentialsDialog \
	SVN::FileoutLikeTask \
	SVN::KDiff3 \
	SVN::MergeViewApp \
	SVN::NodeKind \
	SVN::NonExistentURLError \
	SVN::ProgressDialog \
	SVN::RepositoryDialog \
	SVN::RepositoryEntry \
	SVN::RevisionBase \
	SVN::RevisionDate \
	SVN::RevisionHead \
	SVN::RevisionLogBrowser \
	SVN::RevisionLogEntry \
	SVN::RevisionNumber \
	SVN::Status \
	SVN::UnknownError \
	SVN::WCActionAdded \
	SVN::WCActionConflict \
	SVN::WCActionDeleted \
	SVN::WCActionMerged \
	SVN::WCActionModified \
	SVN::WCActionNone \
	SVN::WCActionRestored \
	SVN::WCActionUpdated \
	SVN::WCCommand \
	SVN::WCEntry \
	SVN::WCEntryInfo \
	SVN::Wizard \
	SVN::WorkingCopyBrowser \
	SVN::WorkingCopyLockedError \
	SVN::CatCommand \
	SVN::CleanupCommand \
	SVN::CommitTask \
	SVN::CommitWizard \
	SVN::CopyCommand \
	SVN::ExportCommand \
	SVN::ImportFromCVSTask \
	SVN::ListCommand \
	SVN::LogCommand \
	SVN::MoveCommand \
	SVN::NodeKindDir \
	SVN::NodeKindExternal \
	SVN::NodeKindFile \
	SVN::NodeKindNone \
	SVN::NodeKindUnknown \
	SVN::StatusAdded \
	SVN::StatusConflicted \
	SVN::StatusDeleted \
	SVN::StatusExternal \
	SVN::StatusIgnored \
	SVN::StatusIncomplete \
	SVN::StatusMissing \
	SVN::StatusModified \
	SVN::StatusNormal \
	SVN::StatusObstructed \
	SVN::StatusReplaced \
	SVN::StatusUnversioned \
	SVN::SyncWithCVSTask \
	SVN::UpdateLikeCommand \
	SVN::UpdateLikeTask \
	SVN::WCPathCommand \
	SVN::AddCommand \
	SVN::CheckoutCommand \
	SVN::CommitCommand \
	SVN::DeleteCommand \
	SVN::InfoCommand \
	SVN::MergeCommand \
	SVN::MergeTask \
	SVN::PropsetCommand \
	SVN::ResolvedCommand \
	SVN::RevertCommand \
	SVN::StatusCommand \
	SVN::UpdateCommand \
	SVN::UpdateTask \




COMMON_OBJS= \
    $(OUTDIR_SLASH)SVN__Branch.$(O) \
    $(OUTDIR_SLASH)SVN__BranchQuery.$(O) \
    $(OUTDIR_SLASH)SVN__Browser.$(O) \
    $(OUTDIR_SLASH)SVN__Cache.$(O) \
    $(OUTDIR_SLASH)SVN__CacheEntry.$(O) \
    $(OUTDIR_SLASH)SVN__Command.$(O) \
    $(OUTDIR_SLASH)SVN__CompatModeQuery.$(O) \
    $(OUTDIR_SLASH)SVN__Configuration.$(O) \
    $(OUTDIR_SLASH)SVN__ConfigurationApp.$(O) \
    $(OUTDIR_SLASH)SVN__Credentials.$(O) \
    $(OUTDIR_SLASH)SVN__Dialog.$(O) \
    $(OUTDIR_SLASH)SVN__DiffViewApp.$(O) \
    $(OUTDIR_SLASH)SVN__Entry.$(O) \
    $(OUTDIR_SLASH)SVN__Enum.$(O) \
    $(OUTDIR_SLASH)SVN__ExternalMergeTool.$(O) \
    $(OUTDIR_SLASH)SVN__IconLibrary.$(O) \
    $(OUTDIR_SLASH)SVN__MergeBrowser.$(O) \
    $(OUTDIR_SLASH)SVN__OSProcess.$(O) \
    $(OUTDIR_SLASH)SVN__PackagePattern.$(O) \
    $(OUTDIR_SLASH)SVN__Property.$(O) \
    $(OUTDIR_SLASH)SVN__Repository.$(O) \
    $(OUTDIR_SLASH)SVN__RepositoryConfiguration.$(O) \
    $(OUTDIR_SLASH)SVN__RepositoryManager.$(O) \
    $(OUTDIR_SLASH)SVN__Revision.$(O) \
    $(OUTDIR_SLASH)SVN__RevisionRange.$(O) \
    $(OUTDIR_SLASH)SVN__SVNError.$(O) \
    $(OUTDIR_SLASH)SVN__Task.$(O) \
    $(OUTDIR_SLASH)SVN__WCAction.$(O) \
    $(OUTDIR_SLASH)SVN__WCActionNotification.$(O) \
    $(OUTDIR_SLASH)SVN__WCError.$(O) \
    $(OUTDIR_SLASH)SVN__WizardPane.$(O) \
    $(OUTDIR_SLASH)SVN__WorkingCopy.$(O) \
    $(OUTDIR_SLASH)SVN__XMLObject.$(O) \
    $(OUTDIR_SLASH)SVNSourceCodeManager.$(O) \
    $(OUTDIR_SLASH)stx_libsvn.$(O) \
    $(OUTDIR_SLASH)SVN__AuthorizationError.$(O) \
    $(OUTDIR_SLASH)SVN__BranchAndRevisionSelectionDialog.$(O) \
    $(OUTDIR_SLASH)SVN__BranchCommand.$(O) \
    $(OUTDIR_SLASH)SVN__BranchSelectionDialog.$(O) \
    $(OUTDIR_SLASH)SVN__CVSTask.$(O) \
    $(OUTDIR_SLASH)SVN__CommitDialog2.$(O) \
    $(OUTDIR_SLASH)SVN__ConfigurationDialog.$(O) \
    $(OUTDIR_SLASH)SVN__CreateRepositoryCommand.$(O) \
    $(OUTDIR_SLASH)SVN__CredentialsDialog.$(O) \
    $(OUTDIR_SLASH)SVN__FileoutLikeTask.$(O) \
    $(OUTDIR_SLASH)SVN__KDiff3.$(O) \
    $(OUTDIR_SLASH)SVN__MergeViewApp.$(O) \
    $(OUTDIR_SLASH)SVN__NodeKind.$(O) \
    $(OUTDIR_SLASH)SVN__NonExistentURLError.$(O) \
    $(OUTDIR_SLASH)SVN__ProgressDialog.$(O) \
    $(OUTDIR_SLASH)SVN__RepositoryDialog.$(O) \
    $(OUTDIR_SLASH)SVN__RepositoryEntry.$(O) \
    $(OUTDIR_SLASH)SVN__RevisionBase.$(O) \
    $(OUTDIR_SLASH)SVN__RevisionDate.$(O) \
    $(OUTDIR_SLASH)SVN__RevisionHead.$(O) \
    $(OUTDIR_SLASH)SVN__RevisionLogBrowser.$(O) \
    $(OUTDIR_SLASH)SVN__RevisionLogEntry.$(O) \
    $(OUTDIR_SLASH)SVN__RevisionNumber.$(O) \
    $(OUTDIR_SLASH)SVN__Status.$(O) \
    $(OUTDIR_SLASH)SVN__UnknownError.$(O) \
    $(OUTDIR_SLASH)SVN__WCActionAdded.$(O) \
    $(OUTDIR_SLASH)SVN__WCActionConflict.$(O) \
    $(OUTDIR_SLASH)SVN__WCActionDeleted.$(O) \
    $(OUTDIR_SLASH)SVN__WCActionMerged.$(O) \
    $(OUTDIR_SLASH)SVN__WCActionModified.$(O) \
    $(OUTDIR_SLASH)SVN__WCActionNone.$(O) \
    $(OUTDIR_SLASH)SVN__WCActionRestored.$(O) \
    $(OUTDIR_SLASH)SVN__WCActionUpdated.$(O) \
    $(OUTDIR_SLASH)SVN__WCCommand.$(O) \
    $(OUTDIR_SLASH)SVN__WCEntry.$(O) \
    $(OUTDIR_SLASH)SVN__WCEntryInfo.$(O) \
    $(OUTDIR_SLASH)SVN__Wizard.$(O) \
    $(OUTDIR_SLASH)SVN__WorkingCopyBrowser.$(O) \
    $(OUTDIR_SLASH)SVN__WorkingCopyLockedError.$(O) \
    $(OUTDIR_SLASH)SVN__CatCommand.$(O) \
    $(OUTDIR_SLASH)SVN__CleanupCommand.$(O) \
    $(OUTDIR_SLASH)SVN__CommitTask.$(O) \
    $(OUTDIR_SLASH)SVN__CommitWizard.$(O) \
    $(OUTDIR_SLASH)SVN__CopyCommand.$(O) \
    $(OUTDIR_SLASH)SVN__ExportCommand.$(O) \
    $(OUTDIR_SLASH)SVN__ImportFromCVSTask.$(O) \
    $(OUTDIR_SLASH)SVN__ListCommand.$(O) \
    $(OUTDIR_SLASH)SVN__LogCommand.$(O) \
    $(OUTDIR_SLASH)SVN__MoveCommand.$(O) \
    $(OUTDIR_SLASH)SVN__NodeKindDir.$(O) \
    $(OUTDIR_SLASH)SVN__NodeKindExternal.$(O) \
    $(OUTDIR_SLASH)SVN__NodeKindFile.$(O) \
    $(OUTDIR_SLASH)SVN__NodeKindNone.$(O) \
    $(OUTDIR_SLASH)SVN__NodeKindUnknown.$(O) \
    $(OUTDIR_SLASH)SVN__StatusAdded.$(O) \
    $(OUTDIR_SLASH)SVN__StatusConflicted.$(O) \
    $(OUTDIR_SLASH)SVN__StatusDeleted.$(O) \
    $(OUTDIR_SLASH)SVN__StatusExternal.$(O) \
    $(OUTDIR_SLASH)SVN__StatusIgnored.$(O) \
    $(OUTDIR_SLASH)SVN__StatusIncomplete.$(O) \
    $(OUTDIR_SLASH)SVN__StatusMissing.$(O) \
    $(OUTDIR_SLASH)SVN__StatusModified.$(O) \
    $(OUTDIR_SLASH)SVN__StatusNormal.$(O) \
    $(OUTDIR_SLASH)SVN__StatusObstructed.$(O) \
    $(OUTDIR_SLASH)SVN__StatusReplaced.$(O) \
    $(OUTDIR_SLASH)SVN__StatusUnversioned.$(O) \
    $(OUTDIR_SLASH)SVN__SyncWithCVSTask.$(O) \
    $(OUTDIR_SLASH)SVN__UpdateLikeCommand.$(O) \
    $(OUTDIR_SLASH)SVN__UpdateLikeTask.$(O) \
    $(OUTDIR_SLASH)SVN__WCPathCommand.$(O) \
    $(OUTDIR_SLASH)SVN__AddCommand.$(O) \
    $(OUTDIR_SLASH)SVN__CheckoutCommand.$(O) \
    $(OUTDIR_SLASH)SVN__CommitCommand.$(O) \
    $(OUTDIR_SLASH)SVN__DeleteCommand.$(O) \
    $(OUTDIR_SLASH)SVN__InfoCommand.$(O) \
    $(OUTDIR_SLASH)SVN__MergeCommand.$(O) \
    $(OUTDIR_SLASH)SVN__MergeTask.$(O) \
    $(OUTDIR_SLASH)SVN__PropsetCommand.$(O) \
    $(OUTDIR_SLASH)SVN__ResolvedCommand.$(O) \
    $(OUTDIR_SLASH)SVN__RevertCommand.$(O) \
    $(OUTDIR_SLASH)SVN__StatusCommand.$(O) \
    $(OUTDIR_SLASH)SVN__UpdateCommand.$(O) \
    $(OUTDIR_SLASH)SVN__UpdateTask.$(O) \
    $(OUTDIR_SLASH)extensions.$(O) \



