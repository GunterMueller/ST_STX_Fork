# $Header$
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_libscm_git.
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
MODULE_DIR=libscm/git
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
#
# ********** OPTIONAL: MODIFY the next line(s) ***
# STCWARNINGS=-warn
# STCWARNINGS=-warnNonStandard
# STCWARNINGS=-warnEOLComments
STCWARNINGS=-warnNonStandard

COMMON_CLASSES= \
	GitLibraryObject \
	GitRepositoryObject \
	GitStatusCodes \
	GitErrorKlass \
	GitStructure \
	GitObjectType \
	GitError \
	GitObject \
	GitCommit \
	GitOid \
	GitRepository \
	GitTree \
	stx_libscm_git \
	GitAttrType \
	GitBlobHandle \
	GitBranchType \
	GitCommitHandle \
	GitConfigFileStructure \
	GitConfigHandle \
	GitCvarMapStructure \
	GitCvarType \
	GitDeltaType \
	GitDiffDeltaStructure \
	GitDiffFileStructure \
	GitDiffListHandle \
	GitDiffOptionsStructure \
	GitDiffRangeStructure \
	GitErrorStructure \
	GitFilemodeType \
	GitIndexEntryStructure \
	GitIndexEntryUnmergedStructure \
	GitIndexHandle \
	GitIndexTimeStructure \
	GitIndexerHandle \
	GitIndexerStatsStructure \
	GitIndexerStreamHandle \
	GitNoteDataStructure \
	GitNoteHandle \
	GitObjectHandle \
	GitOdbBackendStructure \
	GitOdbHandle \
	GitOdbObjectHandle \
	GitOdbStreamStructure \
	GitOidShortenHandle \
	GitRefType \
	GitReferenceHandle \
	GitReflogEntryHandle \
	GitReflogHandle \
	GitRefspecHandle \
	GitRemoteCallbacksStructure \
	GitRemoteCompletionType \
	GitRemoteHandle \
	GitRemoteHeadStructure \
	GitRepositoryHandle \
	GitRepositoryInitOptionsStructure \
	GitResetType \
	GitRevwalkHandle \
	GitSignatureStructure \
	GitStatusOptionsStructure \
	GitStatusShowType \
	GitSubmoduleHandle \
	GitSubmoduleIgnoreType \
	GitSubmoduleStatusType \
	GitSubmoduleUpdateType \
	GitTagHandle \
	GitTimeStructure \
	GitTreeEntryHandle \
	GitTreeHandle \
	GitTreebuilderHandle \
	GitTreewalkModeType \
	GitPrimitives \
	GitSignature \
	GitWorkingCopy \
	GitTag \
	GitCheckoutStrategy \
	GitCheckoutOptions \
	GitIndex \
	GitWorkingCopyEntry \
	GitSignatureQuery \
	GitAuthorQuery \
	GitCommitterQuery \
	GitReference \
	GitCommand \
	GitStringArray \
	GitSourceCodeManagementSettingsAppl2 \
	GitSourceCodeManager2 \
	GitIconLibrary \
	GitCommitDialog \
	GitRemote \
	GitPackageModel \
	GitPackageModelRegistry \




COMMON_OBJS= \
    $(OUTDIR)GitLibraryObject.$(O) \
    $(OUTDIR)GitRepositoryObject.$(O) \
    $(OUTDIR)GitStatusCodes.$(O) \
    $(OUTDIR)GitErrorKlass.$(O) \
    $(OUTDIR)GitStructure.$(O) \
    $(OUTDIR)GitObjectType.$(O) \
    $(OUTDIR)GitError.$(O) \
    $(OUTDIR)GitObject.$(O) \
    $(OUTDIR)GitCommit.$(O) \
    $(OUTDIR)GitOid.$(O) \
    $(OUTDIR)GitRepository.$(O) \
    $(OUTDIR)GitTree.$(O) \
    $(OUTDIR)stx_libscm_git.$(O) \
    $(OUTDIR)GitAttrType.$(O) \
    $(OUTDIR)GitBlobHandle.$(O) \
    $(OUTDIR)GitBranchType.$(O) \
    $(OUTDIR)GitCommitHandle.$(O) \
    $(OUTDIR)GitConfigFileStructure.$(O) \
    $(OUTDIR)GitConfigHandle.$(O) \
    $(OUTDIR)GitCvarMapStructure.$(O) \
    $(OUTDIR)GitCvarType.$(O) \
    $(OUTDIR)GitDeltaType.$(O) \
    $(OUTDIR)GitDiffDeltaStructure.$(O) \
    $(OUTDIR)GitDiffFileStructure.$(O) \
    $(OUTDIR)GitDiffListHandle.$(O) \
    $(OUTDIR)GitDiffOptionsStructure.$(O) \
    $(OUTDIR)GitDiffRangeStructure.$(O) \
    $(OUTDIR)GitErrorStructure.$(O) \
    $(OUTDIR)GitFilemodeType.$(O) \
    $(OUTDIR)GitIndexEntryStructure.$(O) \
    $(OUTDIR)GitIndexEntryUnmergedStructure.$(O) \
    $(OUTDIR)GitIndexHandle.$(O) \
    $(OUTDIR)GitIndexTimeStructure.$(O) \
    $(OUTDIR)GitIndexerHandle.$(O) \
    $(OUTDIR)GitIndexerStatsStructure.$(O) \
    $(OUTDIR)GitIndexerStreamHandle.$(O) \
    $(OUTDIR)GitNoteDataStructure.$(O) \
    $(OUTDIR)GitNoteHandle.$(O) \
    $(OUTDIR)GitObjectHandle.$(O) \
    $(OUTDIR)GitOdbBackendStructure.$(O) \
    $(OUTDIR)GitOdbHandle.$(O) \
    $(OUTDIR)GitOdbObjectHandle.$(O) \
    $(OUTDIR)GitOdbStreamStructure.$(O) \
    $(OUTDIR)GitOidShortenHandle.$(O) \
    $(OUTDIR)GitRefType.$(O) \
    $(OUTDIR)GitReferenceHandle.$(O) \
    $(OUTDIR)GitReflogEntryHandle.$(O) \
    $(OUTDIR)GitReflogHandle.$(O) \
    $(OUTDIR)GitRefspecHandle.$(O) \
    $(OUTDIR)GitRemoteCallbacksStructure.$(O) \
    $(OUTDIR)GitRemoteCompletionType.$(O) \
    $(OUTDIR)GitRemoteHandle.$(O) \
    $(OUTDIR)GitRemoteHeadStructure.$(O) \
    $(OUTDIR)GitRepositoryHandle.$(O) \
    $(OUTDIR)GitRepositoryInitOptionsStructure.$(O) \
    $(OUTDIR)GitResetType.$(O) \
    $(OUTDIR)GitRevwalkHandle.$(O) \
    $(OUTDIR)GitSignatureStructure.$(O) \
    $(OUTDIR)GitStatusOptionsStructure.$(O) \
    $(OUTDIR)GitStatusShowType.$(O) \
    $(OUTDIR)GitSubmoduleHandle.$(O) \
    $(OUTDIR)GitSubmoduleIgnoreType.$(O) \
    $(OUTDIR)GitSubmoduleStatusType.$(O) \
    $(OUTDIR)GitSubmoduleUpdateType.$(O) \
    $(OUTDIR)GitTagHandle.$(O) \
    $(OUTDIR)GitTimeStructure.$(O) \
    $(OUTDIR)GitTreeEntryHandle.$(O) \
    $(OUTDIR)GitTreeHandle.$(O) \
    $(OUTDIR)GitTreebuilderHandle.$(O) \
    $(OUTDIR)GitTreewalkModeType.$(O) \
    $(OUTDIR)GitPrimitives.$(O) \
    $(OUTDIR)GitSignature.$(O) \
    $(OUTDIR)GitWorkingCopy.$(O) \
    $(OUTDIR)GitTag.$(O) \
    $(OUTDIR)GitCheckoutStrategy.$(O) \
    $(OUTDIR)GitCheckoutOptions.$(O) \
    $(OUTDIR)GitIndex.$(O) \
    $(OUTDIR)GitWorkingCopyEntry.$(O) \
    $(OUTDIR)GitSignatureQuery.$(O) \
    $(OUTDIR)GitAuthorQuery.$(O) \
    $(OUTDIR)GitCommitterQuery.$(O) \
    $(OUTDIR)GitReference.$(O) \
    $(OUTDIR)GitCommand.$(O) \
    $(OUTDIR)GitStringArray.$(O) \
    $(OUTDIR)GitSourceCodeManagementSettingsAppl2.$(O) \
    $(OUTDIR)GitSourceCodeManager2.$(O) \
    $(OUTDIR)GitIconLibrary.$(O) \
    $(OUTDIR)GitCommitDialog.$(O) \
    $(OUTDIR)GitRemote.$(O) \
    $(OUTDIR)GitPackageModel.$(O) \
    $(OUTDIR)GitPackageModelRegistry.$(O) \
    $(OUTDIR)extensions.$(O) \



