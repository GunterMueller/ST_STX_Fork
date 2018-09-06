# Hack to make it compilable under Smalltalk/X 6.2.2 (which does not have RES variable defined)
!ifndef RES
RES=res
!endif

# $Header$
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_libscm_mercurial.
#
# Warning: once you modify this file, do not rerun
# stmkmp or projectDefinition-build again - otherwise, your changes are lost.
#
# Notice, that the name bc.mak is historical (from times, when only borland c was supported).
# This file contains make rules for the win32 platform using either borland-bcc or visual-c.
# It shares common definitions with the unix-make in Make.spec.
# The bc.mak supports the following targets:
#    bmake         - compile all st-files to a classLib (dll)
#    bmake clean   - clean all temp files
#    bmake clobber - clean all
#
# Historic Note:
#  this used to contain only rules to make with borland
#    (called via bmake, by "make.exe -f bc.mak")
#  this has changed; it is now also possible to build using microsoft visual c
#    (called via vcmake, by "make.exe -f bc.mak -DUSEVC")
#
TOP=..\..
INCLUDE_TOP=$(TOP)\..



!INCLUDE $(TOP)\rules\stdHeader_bc

!INCLUDE Make.spec

LIBNAME=libstx_libscm_mercurial
MODULE_PATH=libscm\mercurial
RESFILES=stx_libscm_mercurialWINrc.$(RES)



LOCALINCLUDES= -I$(INCLUDE_TOP)\stx\libbasic -I$(INCLUDE_TOP)\stx\libbasic2 -I$(INCLUDE_TOP)\stx\libbasic3 -I$(INCLUDE_TOP)\stx\libhtml -I$(INCLUDE_TOP)\stx\libscm\common -I$(INCLUDE_TOP)\stx\libtool -I$(INCLUDE_TOP)\stx\libtool2 -I$(INCLUDE_TOP)\stx\libview -I$(INCLUDE_TOP)\stx\libview2 -I$(INCLUDE_TOP)\stx\libwidg -I$(INCLUDE_TOP)\stx\libwidg2
LOCALDEFINES=

STCLOCALOPT=-package=$(PACKAGE) -I. $(LOCALINCLUDES) -headerDir=. $(STCLOCALOPTIMIZATIONS) $(STCWARNINGS) $(LOCALDEFINES)  -varPrefix=$(LIBNAME)
LOCALLIBS=

OBJS= $(COMMON_OBJS) $(WIN32_OBJS)

ALL::  classLibRule

classLibRule: $(OUTDIR) $(OUTDIR)$(LIBNAME).dll

!INCLUDE $(TOP)\rules\stdRules_bc

# build all mandatory prerequisite packages (containing superclasses) for this package
prereq:
	pushd ..\..\libbasic & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\goodies\refactoryBrowser\parser & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\libbasic2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\libbasic3 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\libcomp & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\libui & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\libview & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\libview2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\common & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\libwidg & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\libwidg2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\libtool & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "




doc:
	pushd docs & $(MAKE_BAT) html

doc-install:
	pushd docs & $(MAKE_BAT) html-install


clean::
	pushd docs & $(MAKE_BAT) clean





test: $(TOP)\goodies\builder\reports\NUL
	pushd $(TOP)\goodies\builder\reports & $(MAKE_BAT)
	$(TOP)\goodies\builder\reports\report-runner.bat -D . -r Builder::TestReport -p $(PACKAGE)
        
clean::
	-del *.$(CSUFFIX)


# BEGINMAKEDEPEND --- do not remove this line; make depend needs it
$(OUTDIR)HG2CVS.$(O) HG2CVS.$(C) HG2CVS.$(H): HG2CVS.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)HGAuthorQuery.$(O) HGAuthorQuery.$(C) HGAuthorQuery.$(H): HGAuthorQuery.st $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Notification.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\Query.$(H) $(STCHDR)
$(OUTDIR)HGCachedFileData.$(O) HGCachedFileData.$(C) HGCachedFileData.$(H): HGCachedFileData.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)HGChange.$(O) HGChange.$(C) HGChange.$(H): HGChange.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)HGChangesetBrowser.$(O) HGChangesetBrowser.$(C) HGChangesetBrowser.$(H): HGChangesetBrowser.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(STCHDR)
$(OUTDIR)HGChangesetDialog.$(O) HGChangesetDialog.$(C) HGChangesetDialog.$(H): HGChangesetDialog.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(INCLUDE_TOP)\stx\libview2\SimpleDialog.$(H) $(STCHDR)
$(OUTDIR)HGChangesetFile.$(O) HGChangesetFile.$(C) HGChangesetFile.$(H): HGChangesetFile.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)HGChangesetId.$(O) HGChangesetId.$(C) HGChangesetId.$(H): HGChangesetId.st $(INCLUDE_TOP)\stx\libbasic\ArrayedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\ByteArray.$(H) $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\UninterpretedBytes.$(H) $(STCHDR)
$(OUTDIR)HGChangesetLabelsView.$(O) HGChangesetLabelsView.$(C) HGChangesetLabelsView.$(H): HGChangesetLabelsView.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(STCHDR)
$(OUTDIR)HGChangesetList.$(O) HGChangesetList.$(C) HGChangesetList.$(H): HGChangesetList.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(STCHDR)
$(OUTDIR)HGChangesetPresenter.$(O) HGChangesetPresenter.$(C) HGChangesetPresenter.$(H): HGChangesetPresenter.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)HGChangesetViewer.$(O) HGChangesetViewer.$(C) HGChangesetViewer.$(H): HGChangesetViewer.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(STCHDR)
$(OUTDIR)HGCommandParser.$(O) HGCommandParser.$(C) HGCommandParser.$(H): HGCommandParser.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)HGCommitDialog.$(O) HGCommitDialog.$(C) HGCommitDialog.$(H): HGCommitDialog.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libscm\common\SCMAbstractCommitDialog.$(H) $(INCLUDE_TOP)\stx\libscm\common\SCMAbstractDialog.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(INCLUDE_TOP)\stx\libview2\SimpleDialog.$(H) $(STCHDR)
$(OUTDIR)HGCommitTask.$(O) HGCommitTask.$(C) HGCommitTask.$(H): HGCommitTask.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libscm\common\SCMAbstractCommitTask.$(H) $(INCLUDE_TOP)\stx\libscm\common\SCMAbstractFileoutLikeTask.$(H) $(INCLUDE_TOP)\stx\libscm\common\SCMAbstractTask.$(H) $(STCHDR)
$(OUTDIR)HGContribution.$(O) HGContribution.$(C) HGContribution.$(H): HGContribution.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)HGCopyrightLine.$(O) HGCopyrightLine.$(C) HGCopyrightLine.$(H): HGCopyrightLine.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)HGCopyrightUpdater.$(O) HGCopyrightUpdater.$(C) HGCopyrightUpdater.$(H): HGCopyrightUpdater.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)HGDebugFlags.$(O) HGDebugFlags.$(C) HGDebugFlags.$(H): HGDebugFlags.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\SharedPool.$(H) $(STCHDR)
$(OUTDIR)HGError.$(O) HGError.$(C) HGError.$(H): HGError.st $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)HGIconLibrary.$(O) HGIconLibrary.$(C) HGIconLibrary.$(H): HGIconLibrary.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)HGMergeInfo.$(O) HGMergeInfo.$(C) HGMergeInfo.$(H): HGMergeInfo.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)HGMergeTool.$(O) HGMergeTool.$(C) HGMergeTool.$(H): HGMergeTool.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)HGNotification.$(O) HGNotification.$(C) HGNotification.$(H): HGNotification.st $(INCLUDE_TOP)\stx\libbasic\ActivityNotification.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Notification.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\UserNotification.$(H) $(STCHDR)
$(OUTDIR)HGPackageRevision.$(O) HGPackageRevision.$(C) HGPackageRevision.$(H): HGPackageRevision.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libscm\common\SCMAbstractPackageModel.$(H) $(INCLUDE_TOP)\stx\libscm\common\SCMAbstractPackageRevision.$(H) $(STCHDR)
$(OUTDIR)HGPackageWorkingCopy.$(O) HGPackageWorkingCopy.$(C) HGPackageWorkingCopy.$(H): HGPackageWorkingCopy.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libscm\common\SCMAbstractPackageModel.$(H) $(INCLUDE_TOP)\stx\libscm\common\SCMAbstractPackageWorkingCopy.$(H) $(STCHDR)
$(OUTDIR)HGPackageWorkingCopyRegistry.$(O) HGPackageWorkingCopyRegistry.$(C) HGPackageWorkingCopyRegistry.$(H): HGPackageWorkingCopyRegistry.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libscm\common\SCMAbstractPackageWorkingCopyRegistry.$(H) $(STCHDR)
$(OUTDIR)HGPushPullInfo.$(O) HGPushPullInfo.$(C) HGPushPullInfo.$(H): HGPushPullInfo.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)HGRepositoryObject.$(O) HGRepositoryObject.$(C) HGRepositoryObject.$(H): HGRepositoryObject.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)HGRevisionAnnotation.$(O) HGRevisionAnnotation.$(C) HGRevisionAnnotation.$(H): HGRevisionAnnotation.st $(INCLUDE_TOP)\stx\libbasic\Annotation.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)HGRevisionInfo.$(O) HGRevisionInfo.$(C) HGRevisionInfo.$(H): HGRevisionInfo.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libscm\common\SCMAbstractRevisionInfo.$(H) $(STCHDR)
$(OUTDIR)HGRevset.$(O) HGRevset.$(C) HGRevset.$(H): HGRevset.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)HGRevsetEditor.$(O) HGRevsetEditor.$(C) HGRevsetEditor.$(H): HGRevsetEditor.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(STCHDR)
$(OUTDIR)HGSourceCodeManagementSettingsAppl.$(O) HGSourceCodeManagementSettingsAppl.$(C) HGSourceCodeManagementSettingsAppl.$(H): HGSourceCodeManagementSettingsAppl.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libtool\AbstractSettingsApplication.$(H) $(INCLUDE_TOP)\stx\libtool\AbstractSourceCodeManagementSettingsAppl.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(STCHDR)
$(OUTDIR)HGSourceCodeManager.$(O) HGSourceCodeManager.$(C) HGSourceCodeManager.$(H): HGSourceCodeManager.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic3\AbstractSourceCodeManager.$(H) $(INCLUDE_TOP)\stx\libscm\common\SCMAbstractSourceCodeManager.$(H) $(STCHDR)
$(OUTDIR)HGSourceCodeManagerUtilities.$(O) HGSourceCodeManagerUtilities.$(C) HGSourceCodeManagerUtilities.$(H): HGSourceCodeManagerUtilities.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic3\SourceCodeManagerUtilities.$(H) $(INCLUDE_TOP)\stx\libscm\common\SCMCommonSourceCodeManagerUtilities.$(H) $(STCHDR)
$(OUTDIR)HGStatus.$(O) HGStatus.$(C) HGStatus.$(H): HGStatus.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic2\Singleton.$(H) $(STCHDR)
$(OUTDIR)HGWarning.$(O) HGWarning.$(C) HGWarning.$(H): HGWarning.st $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Notification.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\UserNotification.$(H) $(INCLUDE_TOP)\stx\libbasic\Warning.$(H) $(STCHDR)
$(OUTDIR)HGWorkingCopyFile.$(O) HGWorkingCopyFile.$(C) HGWorkingCopyFile.$(H): HGWorkingCopyFile.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)stx_libscm_mercurial.$(O) stx_libscm_mercurial.$(C) stx_libscm_mercurial.$(H): stx_libscm_mercurial.st $(INCLUDE_TOP)\stx\libbasic\LibraryDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\ProjectDefinition.$(H) $(STCHDR)
$(OUTDIR)HGBookmarkError.$(O) HGBookmarkError.$(C) HGBookmarkError.$(H): HGBookmarkError.st $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libscm\mercurial\HGError.$(H) $(STCHDR)
$(OUTDIR)HGChangeset.$(O) HGChangeset.$(C) HGChangeset.$(H): HGChangeset.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libscm\mercurial\HGRepositoryObject.$(H) $(STCHDR)
$(OUTDIR)HGChangesetLabel.$(O) HGChangesetLabel.$(C) HGChangesetLabel.$(H): HGChangesetLabel.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libscm\mercurial\HGRepositoryObject.$(H) $(STCHDR)
$(OUTDIR)HGCommand.$(O) HGCommand.$(C) HGCommand.$(H): HGCommand.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libscm\mercurial\HGDebugFlags.$(H) $(STCHDR)
$(OUTDIR)HGCommandError.$(O) HGCommandError.$(C) HGCommandError.$(H): HGCommandError.st $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libscm\mercurial\HGError.$(H) $(STCHDR)
$(OUTDIR)HGCommandServer.$(O) HGCommandServer.$(C) HGCommandServer.$(H): HGCommandServer.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\PeekableStream.$(H) $(INCLUDE_TOP)\stx\libbasic\PositionableStream.$(H) $(INCLUDE_TOP)\stx\libbasic\ReadStream.$(H) $(INCLUDE_TOP)\stx\libbasic\Stream.$(H) $(INCLUDE_TOP)\stx\libbasic\WriteStream.$(H) $(INCLUDE_TOP)\stx\libscm\mercurial\HGDebugFlags.$(H) $(STCHDR)
$(OUTDIR)HGCommitError.$(O) HGCommitError.$(C) HGCommitError.$(H): HGCommitError.st $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libscm\mercurial\HGError.$(H) $(STCHDR)
$(OUTDIR)HGConfig.$(O) HGConfig.$(C) HGConfig.$(H): HGConfig.st $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Dictionary.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\Set.$(H) $(INCLUDE_TOP)\stx\libscm\mercurial\HGRepositoryObject.$(H) $(STCHDR)
$(OUTDIR)HGNoSuchBranchError.$(O) HGNoSuchBranchError.$(C) HGNoSuchBranchError.$(H): HGNoSuchBranchError.st $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libscm\mercurial\HGError.$(H) $(STCHDR)
$(OUTDIR)HGRemote.$(O) HGRemote.$(C) HGRemote.$(H): HGRemote.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libscm\mercurial\HGRepositoryObject.$(H) $(STCHDR)
$(OUTDIR)HGRepository.$(O) HGRepository.$(C) HGRepository.$(H): HGRepository.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libscm\mercurial\HGRepositoryObject.$(H) $(STCHDR)
$(OUTDIR)HGRepositoryError.$(O) HGRepositoryError.$(C) HGRepositoryError.$(H): HGRepositoryError.st $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libscm\mercurial\HGError.$(H) $(STCHDR)
$(OUTDIR)HGWorkingCopy.$(O) HGWorkingCopy.$(C) HGWorkingCopy.$(H): HGWorkingCopy.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libscm\mercurial\HGRepositoryObject.$(H) $(STCHDR)
$(OUTDIR)HGBranch.$(O) HGBranch.$(C) HGBranch.$(H): HGBranch.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libscm\mercurial\HGChangesetLabel.$(H) $(INCLUDE_TOP)\stx\libscm\mercurial\HGRepositoryObject.$(H) $(STCHDR)
$(OUTDIR)HGCommandParseError.$(O) HGCommandParseError.$(C) HGCommandParseError.$(H): HGCommandParseError.st $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libscm\mercurial\HGCommandError.$(H) $(INCLUDE_TOP)\stx\libscm\mercurial\HGError.$(H) $(STCHDR)
$(OUTDIR)HGInvalidExecutableError.$(O) HGInvalidExecutableError.$(C) HGInvalidExecutableError.$(H): HGInvalidExecutableError.st $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libscm\mercurial\HGCommandError.$(H) $(INCLUDE_TOP)\stx\libscm\mercurial\HGError.$(H) $(STCHDR)
$(OUTDIR)HGInvalidVersionError.$(O) HGInvalidVersionError.$(C) HGInvalidVersionError.$(H): HGInvalidVersionError.st $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libscm\mercurial\HGCommandError.$(H) $(INCLUDE_TOP)\stx\libscm\mercurial\HGError.$(H) $(STCHDR)
$(OUTDIR)HGObsoleteRevisionError.$(O) HGObsoleteRevisionError.$(C) HGObsoleteRevisionError.$(H): HGObsoleteRevisionError.st $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libscm\mercurial\HGError.$(H) $(INCLUDE_TOP)\stx\libscm\mercurial\HGRepositoryError.$(H) $(STCHDR)
$(OUTDIR)HGPushError.$(O) HGPushError.$(C) HGPushError.$(H): HGPushError.st $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libscm\mercurial\HGError.$(H) $(INCLUDE_TOP)\stx\libscm\mercurial\HGRepositoryError.$(H) $(STCHDR)
$(OUTDIR)HGTagOrBookmark.$(O) HGTagOrBookmark.$(C) HGTagOrBookmark.$(H): HGTagOrBookmark.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libscm\mercurial\HGChangesetLabel.$(H) $(INCLUDE_TOP)\stx\libscm\mercurial\HGRepositoryObject.$(H) $(STCHDR)
$(OUTDIR)HGUnknownRevisionError.$(O) HGUnknownRevisionError.$(C) HGUnknownRevisionError.$(H): HGUnknownRevisionError.st $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libscm\mercurial\HGError.$(H) $(INCLUDE_TOP)\stx\libscm\mercurial\HGRepositoryError.$(H) $(STCHDR)
$(OUTDIR)HGBookmark.$(O) HGBookmark.$(C) HGBookmark.$(H): HGBookmark.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libscm\mercurial\HGChangesetLabel.$(H) $(INCLUDE_TOP)\stx\libscm\mercurial\HGRepositoryObject.$(H) $(INCLUDE_TOP)\stx\libscm\mercurial\HGTagOrBookmark.$(H) $(STCHDR)
$(OUTDIR)HGPushWouldCreateNewHeadError.$(O) HGPushWouldCreateNewHeadError.$(C) HGPushWouldCreateNewHeadError.$(H): HGPushWouldCreateNewHeadError.st $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libscm\mercurial\HGError.$(H) $(INCLUDE_TOP)\stx\libscm\mercurial\HGPushError.$(H) $(INCLUDE_TOP)\stx\libscm\mercurial\HGRepositoryError.$(H) $(STCHDR)
$(OUTDIR)HGTag.$(O) HGTag.$(C) HGTag.$(H): HGTag.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libscm\mercurial\HGChangesetLabel.$(H) $(INCLUDE_TOP)\stx\libscm\mercurial\HGRepositoryObject.$(H) $(INCLUDE_TOP)\stx\libscm\mercurial\HGTagOrBookmark.$(H) $(STCHDR)
$(OUTDIR)extensions.$(O): extensions.st $(INCLUDE_TOP)\stx\libbasic\Annotation.$(H) $(INCLUDE_TOP)\stx\libbasic\ArithmeticValue.$(H) $(INCLUDE_TOP)\stx\libbasic\ArrayedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\ByteArray.$(H) $(INCLUDE_TOP)\stx\libbasic\CharacterArray.$(H) $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\ConfigurableFeatures.$(H) $(INCLUDE_TOP)\stx\libbasic\Dictionary.$(H) $(INCLUDE_TOP)\stx\libbasic\IdentityDictionary.$(H) $(INCLUDE_TOP)\stx\libbasic\Integer.$(H) $(INCLUDE_TOP)\stx\libbasic\Magnitude.$(H) $(INCLUDE_TOP)\stx\libbasic\Number.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\ProjectDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\Set.$(H) $(INCLUDE_TOP)\stx\libbasic\UninterpretedBytes.$(H) $(INCLUDE_TOP)\stx\libbasic\UserPreferences.$(H) $(INCLUDE_TOP)\stx\libtool\AbstractFileBrowser.$(H) $(INCLUDE_TOP)\stx\libtool\SystemBrowser.$(H) $(INCLUDE_TOP)\stx\libtool\Tools__NewSystemBrowser.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(STCHDR)

# ENDMAKEDEPEND --- do not remove this line

# **Must be at end**

# Enforce recompilation of package definition class if Mercurial working
# copy state changes. Together with --guessVersion it ensures that package
# definition class always contains correct binary revision string.
!IFDEF HGROOT
$(OUTDIR)stx_libscm_mercurial.$(O): $(HGROOT)\.hg\dirstate
!ENDIF
