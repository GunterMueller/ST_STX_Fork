# $Header$
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_libscm_mercurial.
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
MODULE_DIR=libscm/mercurial
PACKAGE=$(MODULE):$(MODULE_DIR)


# Argument(s) to the stc compiler (stc --usage).
#  -headerDir=. : create header files locally
#                (if removed, they will be created as common
#  -Pxxx       : defines the package
#  -Zxxx       : a prefix for variables within the classLib
#  -Dxxx       : defines passed to CC for inline C-code
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
	HG2CVS \
	HGAuthorQuery \
	HGCachedFileData \
	HGChange \
	HGChangesetBrowser \
	HGChangesetDialog \
	HGChangesetFile \
	HGChangesetId \
	HGChangesetLabelsView \
	HGChangesetList \
	HGChangesetPresenter \
	HGChangesetViewer \
	HGCommandParser \
	HGCommitDialog \
	HGCommitTask \
	HGContribution \
	HGCopyrightLine \
	HGCopyrightUpdater \
	HGDebugFlags \
	HGError \
	HGIconLibrary \
	HGMergeInfo \
	HGMergeTool \
	HGNotification \
	HGPackageRevision \
	HGPackageWorkingCopy \
	HGPackageWorkingCopyRegistry \
	HGPushPullInfo \
	HGRepositoryObject \
	HGRevisionAnnotation \
	HGRevisionInfo \
	HGRevset \
	HGRevsetEditor \
	HGSourceCodeManagementSettingsAppl \
	HGSourceCodeManager \
	HGSourceCodeManagerUtilities \
	HGStatus \
	HGWarning \
	HGWorkingCopyFile \
	stx_libscm_mercurial \
	HGBookmarkError \
	HGChangeset \
	HGChangesetLabel \
	HGCommand \
	HGCommandError \
	HGCommandServer \
	HGCommitError \
	HGConfig \
	HGNoSuchBranchError \
	HGRemote \
	HGRepository \
	HGRepositoryError \
	HGWorkingCopy \
	HGBranch \
	HGCommandParseError \
	HGInvalidExecutableError \
	HGInvalidVersionError \
	HGObsoleteRevisionError \
	HGPushError \
	HGTagOrBookmark \
	HGUnknownRevisionError \
	HGBookmark \
	HGPushWouldCreateNewHeadError \
	HGTag \




COMMON_OBJS= \
    $(OUTDIR)HG2CVS.$(O) \
    $(OUTDIR)HGAuthorQuery.$(O) \
    $(OUTDIR)HGCachedFileData.$(O) \
    $(OUTDIR)HGChange.$(O) \
    $(OUTDIR)HGChangesetBrowser.$(O) \
    $(OUTDIR)HGChangesetDialog.$(O) \
    $(OUTDIR)HGChangesetFile.$(O) \
    $(OUTDIR)HGChangesetId.$(O) \
    $(OUTDIR)HGChangesetLabelsView.$(O) \
    $(OUTDIR)HGChangesetList.$(O) \
    $(OUTDIR)HGChangesetPresenter.$(O) \
    $(OUTDIR)HGChangesetViewer.$(O) \
    $(OUTDIR)HGCommandParser.$(O) \
    $(OUTDIR)HGCommitDialog.$(O) \
    $(OUTDIR)HGCommitTask.$(O) \
    $(OUTDIR)HGContribution.$(O) \
    $(OUTDIR)HGCopyrightLine.$(O) \
    $(OUTDIR)HGCopyrightUpdater.$(O) \
    $(OUTDIR)HGDebugFlags.$(O) \
    $(OUTDIR)HGError.$(O) \
    $(OUTDIR)HGIconLibrary.$(O) \
    $(OUTDIR)HGMergeInfo.$(O) \
    $(OUTDIR)HGMergeTool.$(O) \
    $(OUTDIR)HGNotification.$(O) \
    $(OUTDIR)HGPackageRevision.$(O) \
    $(OUTDIR)HGPackageWorkingCopy.$(O) \
    $(OUTDIR)HGPackageWorkingCopyRegistry.$(O) \
    $(OUTDIR)HGPushPullInfo.$(O) \
    $(OUTDIR)HGRepositoryObject.$(O) \
    $(OUTDIR)HGRevisionAnnotation.$(O) \
    $(OUTDIR)HGRevisionInfo.$(O) \
    $(OUTDIR)HGRevset.$(O) \
    $(OUTDIR)HGRevsetEditor.$(O) \
    $(OUTDIR)HGSourceCodeManagementSettingsAppl.$(O) \
    $(OUTDIR)HGSourceCodeManager.$(O) \
    $(OUTDIR)HGSourceCodeManagerUtilities.$(O) \
    $(OUTDIR)HGStatus.$(O) \
    $(OUTDIR)HGWarning.$(O) \
    $(OUTDIR)HGWorkingCopyFile.$(O) \
    $(OUTDIR)stx_libscm_mercurial.$(O) \
    $(OUTDIR)HGBookmarkError.$(O) \
    $(OUTDIR)HGChangeset.$(O) \
    $(OUTDIR)HGChangesetLabel.$(O) \
    $(OUTDIR)HGCommand.$(O) \
    $(OUTDIR)HGCommandError.$(O) \
    $(OUTDIR)HGCommandServer.$(O) \
    $(OUTDIR)HGCommitError.$(O) \
    $(OUTDIR)HGConfig.$(O) \
    $(OUTDIR)HGNoSuchBranchError.$(O) \
    $(OUTDIR)HGRemote.$(O) \
    $(OUTDIR)HGRepository.$(O) \
    $(OUTDIR)HGRepositoryError.$(O) \
    $(OUTDIR)HGWorkingCopy.$(O) \
    $(OUTDIR)HGBranch.$(O) \
    $(OUTDIR)HGCommandParseError.$(O) \
    $(OUTDIR)HGInvalidExecutableError.$(O) \
    $(OUTDIR)HGInvalidVersionError.$(O) \
    $(OUTDIR)HGObsoleteRevisionError.$(O) \
    $(OUTDIR)HGPushError.$(O) \
    $(OUTDIR)HGTagOrBookmark.$(O) \
    $(OUTDIR)HGUnknownRevisionError.$(O) \
    $(OUTDIR)HGBookmark.$(O) \
    $(OUTDIR)HGPushWouldCreateNewHeadError.$(O) \
    $(OUTDIR)HGTag.$(O) \
    $(OUTDIR)extensions.$(O) \



