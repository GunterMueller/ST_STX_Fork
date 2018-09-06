# $Header$
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_goodies_monticello.
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

LIBNAME=libstx_goodies_monticello
MODULE_PATH=goodies\monticello
RESFILES=monticello.$(RES)



LOCALINCLUDES= -I$(INCLUDE_TOP)\stx\goodies\communication -I$(INCLUDE_TOP)\stx\libbasic -I$(INCLUDE_TOP)\stx\libbasic2 -I$(INCLUDE_TOP)\stx\libbasic3 -I$(INCLUDE_TOP)\stx\libcomp -I$(INCLUDE_TOP)\stx\libcompat -I$(INCLUDE_TOP)\stx\libhtml -I$(INCLUDE_TOP)\stx\libscm\mercurial -I$(INCLUDE_TOP)\stx\libtool -I$(INCLUDE_TOP)\stx\libview -I$(INCLUDE_TOP)\stx\libview2 -I$(INCLUDE_TOP)\stx\libwidg -I$(INCLUDE_TOP)\stx\libwidg2
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
	pushd ..\refactoryBrowser\parser & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\libbasic2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\libbasic3 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\libcomp & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\libui & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\libview & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\libview2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\libwidg & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\libwidg2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\libcompat & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\libtool & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "







test: $(TOP)\goodies\builder\reports\NUL
	pushd $(TOP)\goodies\builder\reports & $(MAKE_BAT)
	$(TOP)\goodies\builder\reports\report-runner.bat -D . -r Builder::TestReport -p $(PACKAGE)
        
clean::
	del *.$(CSUFFIX)


# BEGINMAKEDEPEND --- do not remove this line; make depend needs it
$(OUTDIR)InMidstOfFileinNotification.$(O) InMidstOfFileinNotification.$(H): InMidstOfFileinNotification.st $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Notification.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCAncestry.$(O) MCAncestry.$(H): MCAncestry.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCBrowserList.$(O) MCBrowserList.$(H): MCBrowserList.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libtool\Tools__BrowserList.$(H) $(INCLUDE_TOP)\stx\libtool\Tools__NavigatorModel.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(STCHDR)
$(OUTDIR)MCChangeSelectionRequest.$(O) MCChangeSelectionRequest.$(H): MCChangeSelectionRequest.st $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Notification.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCConflict.$(O) MCConflict.$(H): MCConflict.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCDefinition.$(O) MCDefinition.$(H): MCDefinition.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCDefinitionIndex.$(O) MCDefinitionIndex.$(H): MCDefinitionIndex.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCDependencySorter.$(O) MCDependencySorter.$(H): MCDependencySorter.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCDialog.$(O) MCDialog.$(H): MCDialog.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(INCLUDE_TOP)\stx\libview2\SimpleDialog.$(H) $(STCHDR)
$(OUTDIR)MCDirtyPackageInfo.$(O) MCDirtyPackageInfo.$(H): MCDirtyPackageInfo.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libcompat\PackageInfo.$(H) $(STCHDR)
$(OUTDIR)MCDoItParser.$(O) MCDoItParser.$(H): MCDoItParser.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCEmptyPackageInfo.$(O) MCEmptyPackageInfo.$(H): MCEmptyPackageInfo.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libcompat\PackageInfo.$(H) $(STCHDR)
$(OUTDIR)MCFrontier.$(O) MCFrontier.$(H): MCFrontier.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCInteractiveLoadingQuery.$(O) MCInteractiveLoadingQuery.$(H): MCInteractiveLoadingQuery.st $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Notification.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\Query.$(H) $(STCHDR)
$(OUTDIR)MCLazyPropertyDictionary.$(O) MCLazyPropertyDictionary.$(H): MCLazyPropertyDictionary.st $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Dictionary.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\Set.$(H) $(STCHDR)
$(OUTDIR)MCMergeRecord.$(O) MCMergeRecord.$(H): MCMergeRecord.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCMergeResolutionRequest.$(O) MCMergeResolutionRequest.$(H): MCMergeResolutionRequest.st $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Notification.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCMerger.$(O) MCMerger.$(H): MCMerger.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCMock.$(O) MCMock.$(H): MCMock.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCMockAPoolDictionary.$(O) MCMockAPoolDictionary.$(H): MCMockAPoolDictionary.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\SharedPool.$(H) $(STCHDR)
$(OUTDIR)MCMockDependency.$(O) MCMockDependency.$(H): MCMockDependency.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCMockPackageInfo.$(O) MCMockPackageInfo.$(H): MCMockPackageInfo.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libcompat\PackageInfo.$(H) $(STCHDR)
$(OUTDIR)MCNoChangesException.$(O) MCNoChangesException.$(H): MCNoChangesException.st $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCPackage.$(O) MCPackage.$(H): MCPackage.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCPackageCache.$(O) MCPackageCache.$(H): MCPackageCache.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCPackageEntry.$(O) MCPackageEntry.$(H): MCPackageEntry.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libwidg2\AbstractHierarchicalItem.$(H) $(INCLUDE_TOP)\stx\libwidg2\HierarchicalItem.$(H) $(STCHDR)
$(OUTDIR)MCPackageLoader.$(O) MCPackageLoader.$(H): MCPackageLoader.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCPackageManager.$(O) MCPackageManager.$(H): MCPackageManager.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCPatch.$(O) MCPatch.$(H): MCPatch.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCPatchOperation.$(O) MCPatchOperation.$(H): MCPatchOperation.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCPatcher.$(O) MCPatcher.$(H): MCPatcher.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCReader.$(O) MCReader.$(H): MCReader.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCRepository.$(O) MCRepository.$(H): MCRepository.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCRepositoryBrowser.$(O) MCRepositoryBrowser.$(H): MCRepositoryBrowser.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(STCHDR)
$(OUTDIR)MCRepositoryEntry.$(O) MCRepositoryEntry.$(H): MCRepositoryEntry.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libwidg2\AbstractHierarchicalItem.$(H) $(INCLUDE_TOP)\stx\libwidg2\HierarchicalItem.$(H) $(STCHDR)
$(OUTDIR)MCRepositoryGroup.$(O) MCRepositoryGroup.$(H): MCRepositoryGroup.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCScanner.$(O) MCScanner.$(H): MCScanner.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCSettingsApp.$(O) MCSettingsApp.$(H): MCSettingsApp.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libtool\AbstractSettingsApplication.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(STCHDR)
$(OUTDIR)MCSnapshot.$(O) MCSnapshot.$(H): MCSnapshot.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCSnapshotOptions.$(O) MCSnapshotOptions.$(H): MCSnapshotOptions.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCSourceCodeManager.$(O) MCSourceCodeManager.$(H): MCSourceCodeManager.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic3\AbstractSourceCodeManager.$(H) $(STCHDR)
$(OUTDIR)MCStXNamespaceQuery.$(O) MCStXNamespaceQuery.$(H): MCStXNamespaceQuery.st $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Notification.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\Query.$(H) $(STCHDR)
$(OUTDIR)MCStXPackageInfo.$(O) MCStXPackageInfo.$(H): MCStXPackageInfo.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libcompat\PackageInfo.$(H) $(STCHDR)
$(OUTDIR)MCStXPackageQuery.$(O) MCStXPackageQuery.$(H): MCStXPackageQuery.st $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Notification.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\Query.$(H) $(STCHDR)
$(OUTDIR)MCStXSnapshotTransformation.$(O) MCStXSnapshotTransformation.$(H): MCStXSnapshotTransformation.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCStxVersionInfo.$(O) MCStxVersionInfo.$(H): MCStxVersionInfo.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic3\VersionInfo.$(H) $(STCHDR)
$(OUTDIR)MCTimestampAnnotation.$(O) MCTimestampAnnotation.$(H): MCTimestampAnnotation.st $(INCLUDE_TOP)\stx\libbasic\Annotation.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCTool.$(O) MCTool.$(H): MCTool.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCVariableDefinition.$(O) MCVariableDefinition.$(H): MCVariableDefinition.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCVersion.$(O) MCVersion.$(H): MCVersion.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCVersionDependency.$(O) MCVersionDependency.$(H): MCVersionDependency.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCVersionEntry.$(O) MCVersionEntry.$(H): MCVersionEntry.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libwidg2\AbstractHierarchicalItem.$(H) $(INCLUDE_TOP)\stx\libwidg2\HierarchicalItem.$(H) $(STCHDR)
$(OUTDIR)MCVersionLoader.$(O) MCVersionLoader.$(H): MCVersionLoader.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCVersionMerger.$(O) MCVersionMerger.$(H): MCVersionMerger.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCVersionNameAndMessageRequest.$(O) MCVersionNameAndMessageRequest.$(H): MCVersionNameAndMessageRequest.st $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Notification.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCVersionNotification.$(O) MCVersionNotification.$(H): MCVersionNotification.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCVersionSorter.$(O) MCVersionSorter.$(H): MCVersionSorter.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCWriter.$(O) MCWriter.$(H): MCWriter.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MethodReference.$(O) MethodReference.$(H): MethodReference.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PackageOrganizer.$(O) PackageOrganizer.$(H): PackageOrganizer.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)stx_goodies_monticello.$(O) stx_goodies_monticello.$(H): stx_goodies_monticello.st $(INCLUDE_TOP)\stx\libbasic\LibraryDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\ProjectDefinition.$(H) $(STCHDR)
$(OUTDIR)MCAddition.$(O) MCAddition.$(H): MCAddition.st $(INCLUDE_TOP)\stx\goodies\monticello\MCPatchOperation.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCClassComment.$(O) MCClassComment.$(H): MCClassComment.st $(INCLUDE_TOP)\stx\goodies\monticello\MCDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCClassDefinition.$(O) MCClassDefinition.$(H): MCClassDefinition.st $(INCLUDE_TOP)\stx\goodies\monticello\MCDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCClassInstanceVariableDefinition.$(O) MCClassInstanceVariableDefinition.$(H): MCClassInstanceVariableDefinition.st $(INCLUDE_TOP)\stx\goodies\monticello\MCVariableDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCClassTraitDefinition.$(O) MCClassTraitDefinition.$(H): MCClassTraitDefinition.st $(INCLUDE_TOP)\stx\goodies\monticello\MCDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCClassTraitParser.$(O) MCClassTraitParser.$(H): MCClassTraitParser.st $(INCLUDE_TOP)\stx\goodies\monticello\MCDoItParser.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCClassVariableDefinition.$(O) MCClassVariableDefinition.$(H): MCClassVariableDefinition.st $(INCLUDE_TOP)\stx\goodies\monticello\MCVariableDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCCodeTool.$(O) MCCodeTool.$(H): MCCodeTool.st $(INCLUDE_TOP)\stx\goodies\monticello\MCTool.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCCommitDialog.$(O) MCCommitDialog.$(H): MCCommitDialog.st $(INCLUDE_TOP)\stx\goodies\monticello\MCDialog.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(INCLUDE_TOP)\stx\libview2\SimpleDialog.$(H) $(STCHDR)
$(OUTDIR)MCDictionaryRepository.$(O) MCDictionaryRepository.$(H): MCDictionaryRepository.st $(INCLUDE_TOP)\stx\goodies\monticello\MCRepository.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCDiffyVersion.$(O) MCDiffyVersion.$(H): MCDiffyVersion.st $(INCLUDE_TOP)\stx\goodies\monticello\MCVersion.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCFileBasedRepository.$(O) MCFileBasedRepository.$(H): MCFileBasedRepository.st $(INCLUDE_TOP)\stx\goodies\monticello\MCRepository.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCFilteredVersionSorter.$(O) MCFilteredVersionSorter.$(H): MCFilteredVersionSorter.st $(INCLUDE_TOP)\stx\goodies\monticello\MCVersionSorter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCGOODSRepository.$(O) MCGOODSRepository.$(H): MCGOODSRepository.st $(INCLUDE_TOP)\stx\goodies\monticello\MCRepository.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCInstanceVariableDefinition.$(O) MCInstanceVariableDefinition.$(H): MCInstanceVariableDefinition.st $(INCLUDE_TOP)\stx\goodies\monticello\MCVariableDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCMczWriter.$(O) MCMczWriter.$(H): MCMczWriter.st $(INCLUDE_TOP)\stx\goodies\monticello\MCWriter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCMethodDefinition.$(O) MCMethodDefinition.$(H): MCMethodDefinition.st $(INCLUDE_TOP)\stx\goodies\monticello\MCDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCMockDefinition.$(O) MCMockDefinition.$(H): MCMockDefinition.st $(INCLUDE_TOP)\stx\goodies\monticello\MCDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCMockDependentItem.$(O) MCMockDependentItem.$(H): MCMockDependentItem.st $(INCLUDE_TOP)\stx\goodies\monticello\MCMock.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCModification.$(O) MCModification.$(H): MCModification.st $(INCLUDE_TOP)\stx\goodies\monticello\MCPatchOperation.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCMultiPackageLoader.$(O) MCMultiPackageLoader.$(H): MCMultiPackageLoader.st $(INCLUDE_TOP)\stx\goodies\monticello\MCPackageLoader.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCOrganizationDefinition.$(O) MCOrganizationDefinition.$(H): MCOrganizationDefinition.st $(INCLUDE_TOP)\stx\goodies\monticello\MCDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCPackageList.$(O) MCPackageList.$(H): MCPackageList.st $(INCLUDE_TOP)\stx\goodies\monticello\MCBrowserList.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libtool\Tools__BrowserList.$(H) $(INCLUDE_TOP)\stx\libtool\Tools__NavigatorModel.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(STCHDR)
$(OUTDIR)MCPoolImportDefinition.$(O) MCPoolImportDefinition.$(H): MCPoolImportDefinition.st $(INCLUDE_TOP)\stx\goodies\monticello\MCVariableDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCRemoval.$(O) MCRemoval.$(H): MCRemoval.st $(INCLUDE_TOP)\stx\goodies\monticello\MCPatchOperation.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCRepositoryDialog.$(O) MCRepositoryDialog.$(H): MCRepositoryDialog.st $(INCLUDE_TOP)\stx\goodies\monticello\MCDialog.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(INCLUDE_TOP)\stx\libview2\SimpleDialog.$(H) $(STCHDR)
$(OUTDIR)MCRepositoryList.$(O) MCRepositoryList.$(H): MCRepositoryList.st $(INCLUDE_TOP)\stx\goodies\monticello\MCBrowserList.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libtool\Tools__BrowserList.$(H) $(INCLUDE_TOP)\stx\libtool\Tools__NavigatorModel.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(STCHDR)
$(OUTDIR)MCScriptDefinition.$(O) MCScriptDefinition.$(H): MCScriptDefinition.st $(INCLUDE_TOP)\stx\goodies\monticello\MCDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCSnapshotReader.$(O) MCSnapshotReader.$(H): MCSnapshotReader.st $(INCLUDE_TOP)\stx\goodies\monticello\MCReader.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCStWriter.$(O) MCStWriter.$(H): MCStWriter.st $(INCLUDE_TOP)\stx\goodies\monticello\MCWriter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCStXSnapshotPostReadTransformation.$(O) MCStXSnapshotPostReadTransformation.$(H): MCStXSnapshotPostReadTransformation.st $(INCLUDE_TOP)\stx\goodies\monticello\MCStXSnapshotTransformation.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCStXSnapshotPreWriteTransformation.$(O) MCStXSnapshotPreWriteTransformation.$(H): MCStXSnapshotPreWriteTransformation.st $(INCLUDE_TOP)\stx\goodies\monticello\MCStXSnapshotTransformation.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCSystemCategoryParser.$(O) MCSystemCategoryParser.$(H): MCSystemCategoryParser.st $(INCLUDE_TOP)\stx\goodies\monticello\MCDoItParser.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCThreeWayMerger.$(O) MCThreeWayMerger.$(H): MCThreeWayMerger.st $(INCLUDE_TOP)\stx\goodies\monticello\MCMerger.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCTraitParser.$(O) MCTraitParser.$(H): MCTraitParser.st $(INCLUDE_TOP)\stx\goodies\monticello\MCDoItParser.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCVersionHistoryBrowser.$(O) MCVersionHistoryBrowser.$(H): MCVersionHistoryBrowser.st $(INCLUDE_TOP)\stx\goodies\monticello\MCTool.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCVersionInfo.$(O) MCVersionInfo.$(H): MCVersionInfo.st $(INCLUDE_TOP)\stx\goodies\monticello\MCAncestry.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCVersionInfoWriter.$(O) MCVersionInfoWriter.$(H): MCVersionInfoWriter.st $(INCLUDE_TOP)\stx\goodies\monticello\MCWriter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCVersionInspector.$(O) MCVersionInspector.$(H): MCVersionInspector.st $(INCLUDE_TOP)\stx\goodies\monticello\MCTool.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCVersionList.$(O) MCVersionList.$(H): MCVersionList.st $(INCLUDE_TOP)\stx\goodies\monticello\MCBrowserList.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libtool\Tools__BrowserList.$(H) $(INCLUDE_TOP)\stx\libtool\Tools__NavigatorModel.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(STCHDR)
$(OUTDIR)MCVersionReader.$(O) MCVersionReader.$(H): MCVersionReader.st $(INCLUDE_TOP)\stx\goodies\monticello\MCReader.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCWorkingAncestry.$(O) MCWorkingAncestry.$(H): MCWorkingAncestry.st $(INCLUDE_TOP)\stx\goodies\monticello\MCAncestry.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCWorkingCopy.$(O) MCWorkingCopy.$(H): MCWorkingCopy.st $(INCLUDE_TOP)\stx\goodies\monticello\MCPackageManager.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCWriteOnlyRepository.$(O) MCWriteOnlyRepository.$(H): MCWriteOnlyRepository.st $(INCLUDE_TOP)\stx\goodies\monticello\MCRepository.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCDirectoryRepository.$(O) MCDirectoryRepository.$(H): MCDirectoryRepository.st $(INCLUDE_TOP)\stx\goodies\monticello\MCFileBasedRepository.$(H) $(INCLUDE_TOP)\stx\goodies\monticello\MCRepository.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCFtpRepository.$(O) MCFtpRepository.$(H): MCFtpRepository.st $(INCLUDE_TOP)\stx\goodies\monticello\MCFileBasedRepository.$(H) $(INCLUDE_TOP)\stx\goodies\monticello\MCRepository.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCHttpRepository.$(O) MCHttpRepository.$(H): MCHttpRepository.st $(INCLUDE_TOP)\stx\goodies\monticello\MCFileBasedRepository.$(H) $(INCLUDE_TOP)\stx\goodies\monticello\MCRepository.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCLazyVersionInfo.$(O) MCLazyVersionInfo.$(H): MCLazyVersionInfo.st $(INCLUDE_TOP)\stx\goodies\monticello\MCAncestry.$(H) $(INCLUDE_TOP)\stx\goodies\monticello\MCVersionInfo.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCMcdWriter.$(O) MCMcdWriter.$(H): MCMcdWriter.st $(INCLUDE_TOP)\stx\goodies\monticello\MCMczWriter.$(H) $(INCLUDE_TOP)\stx\goodies\monticello\MCWriter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCMczReader.$(O) MCMczReader.$(H): MCMczReader.st $(INCLUDE_TOP)\stx\goodies\monticello\MCReader.$(H) $(INCLUDE_TOP)\stx\goodies\monticello\MCVersionReader.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCPatchBrowser.$(O) MCPatchBrowser.$(H): MCPatchBrowser.st $(INCLUDE_TOP)\stx\goodies\monticello\MCCodeTool.$(H) $(INCLUDE_TOP)\stx\goodies\monticello\MCTool.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCPostscriptDefinition.$(O) MCPostscriptDefinition.$(H): MCPostscriptDefinition.st $(INCLUDE_TOP)\stx\goodies\monticello\MCDefinition.$(H) $(INCLUDE_TOP)\stx\goodies\monticello\MCScriptDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCPreambleDefinition.$(O) MCPreambleDefinition.$(H): MCPreambleDefinition.st $(INCLUDE_TOP)\stx\goodies\monticello\MCDefinition.$(H) $(INCLUDE_TOP)\stx\goodies\monticello\MCScriptDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCRemovalPostscriptDefinition.$(O) MCRemovalPostscriptDefinition.$(H): MCRemovalPostscriptDefinition.st $(INCLUDE_TOP)\stx\goodies\monticello\MCDefinition.$(H) $(INCLUDE_TOP)\stx\goodies\monticello\MCScriptDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCRemovalPreambleDefinition.$(O) MCRemovalPreambleDefinition.$(H): MCRemovalPreambleDefinition.st $(INCLUDE_TOP)\stx\goodies\monticello\MCDefinition.$(H) $(INCLUDE_TOP)\stx\goodies\monticello\MCScriptDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCSMReleaseRepository.$(O) MCSMReleaseRepository.$(H): MCSMReleaseRepository.st $(INCLUDE_TOP)\stx\goodies\monticello\MCRepository.$(H) $(INCLUDE_TOP)\stx\goodies\monticello\MCWriteOnlyRepository.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCSmtpRepository.$(O) MCSmtpRepository.$(H): MCSmtpRepository.st $(INCLUDE_TOP)\stx\goodies\monticello\MCRepository.$(H) $(INCLUDE_TOP)\stx\goodies\monticello\MCWriteOnlyRepository.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCStReader.$(O) MCStReader.$(H): MCStReader.st $(INCLUDE_TOP)\stx\goodies\monticello\MCReader.$(H) $(INCLUDE_TOP)\stx\goodies\monticello\MCSnapshotReader.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCStxMczWriter.$(O) MCStxMczWriter.$(H): MCStxMczWriter.st $(INCLUDE_TOP)\stx\goodies\monticello\MCMczWriter.$(H) $(INCLUDE_TOP)\stx\goodies\monticello\MCWriter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCStxStWriter.$(O) MCStxStWriter.$(H): MCStxStWriter.st $(INCLUDE_TOP)\stx\goodies\monticello\MCStWriter.$(H) $(INCLUDE_TOP)\stx\goodies\monticello\MCWriter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCTraitDefinition.$(O) MCTraitDefinition.$(H): MCTraitDefinition.st $(INCLUDE_TOP)\stx\goodies\monticello\MCClassDefinition.$(H) $(INCLUDE_TOP)\stx\goodies\monticello\MCDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCCacheRepository.$(O) MCCacheRepository.$(H): MCCacheRepository.st $(INCLUDE_TOP)\stx\goodies\monticello\MCDirectoryRepository.$(H) $(INCLUDE_TOP)\stx\goodies\monticello\MCFileBasedRepository.$(H) $(INCLUDE_TOP)\stx\goodies\monticello\MCRepository.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCMcdReader.$(O) MCMcdReader.$(H): MCMcdReader.st $(INCLUDE_TOP)\stx\goodies\monticello\MCMczReader.$(H) $(INCLUDE_TOP)\stx\goodies\monticello\MCReader.$(H) $(INCLUDE_TOP)\stx\goodies\monticello\MCVersionReader.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCStXMczReader.$(O) MCStXMczReader.$(H): MCStXMczReader.st $(INCLUDE_TOP)\stx\goodies\monticello\MCMczReader.$(H) $(INCLUDE_TOP)\stx\goodies\monticello\MCReader.$(H) $(INCLUDE_TOP)\stx\goodies\monticello\MCVersionReader.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCSubDirectoryRepository.$(O) MCSubDirectoryRepository.$(H): MCSubDirectoryRepository.st $(INCLUDE_TOP)\stx\goodies\monticello\MCDirectoryRepository.$(H) $(INCLUDE_TOP)\stx\goodies\monticello\MCFileBasedRepository.$(H) $(INCLUDE_TOP)\stx\goodies\monticello\MCRepository.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)extensions.$(O): extensions.st $(INCLUDE_TOP)\stx\libbasic\AbstractTime.$(H) $(INCLUDE_TOP)\stx\libbasic\Annotation.$(H) $(INCLUDE_TOP)\stx\libbasic\ArrayedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\Behavior.$(H) $(INCLUDE_TOP)\stx\libbasic\CharacterArray.$(H) $(INCLUDE_TOP)\stx\libbasic\Class.$(H) $(INCLUDE_TOP)\stx\libbasic\ClassDescription.$(H) $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Dictionary.$(H) $(INCLUDE_TOP)\stx\libbasic\IdentityDictionary.$(H) $(INCLUDE_TOP)\stx\libbasic\Magnitude.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\OrderedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\ProjectDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\Set.$(H) $(INCLUDE_TOP)\stx\libbasic\Stream.$(H) $(INCLUDE_TOP)\stx\libbasic\String.$(H) $(INCLUDE_TOP)\stx\libbasic\StringCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\Symbol.$(H) $(INCLUDE_TOP)\stx\libbasic\Timestamp.$(H) $(INCLUDE_TOP)\stx\libbasic\UndefinedObject.$(H) $(INCLUDE_TOP)\stx\libbasic\UninterpretedBytes.$(H) $(INCLUDE_TOP)\stx\libbasic\UserPreferences.$(H) $(INCLUDE_TOP)\stx\libbasic3\Change.$(H) $(INCLUDE_TOP)\stx\libbasic3\VersionInfo.$(H) $(INCLUDE_TOP)\stx\libcompat\PackageInfo.$(H) $(INCLUDE_TOP)\stx\libtool\SystemBrowser.$(H) $(INCLUDE_TOP)\stx\libtool\Tools__NewSystemBrowser.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(STCHDR)

# ENDMAKEDEPEND --- do not remove this line

# **Must be at end**

# Enforce recompilation of package definition class if Mercurial working
# copy state changes. Together with --guessVersion it ensures that package
# definition class always contains correct binary revision string.
!IFDEF HGROOT
$(OUTDIR)stx_goodies_monticello.$(O): $(HGROOT)\.hg\dirstate
!ENDIF
