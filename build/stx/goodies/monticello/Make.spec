# $Header$
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_goodies_monticello.
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
MODULE_DIR=goodies/monticello
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
	InMidstOfFileinNotification \
	MCAncestry \
	MCBrowserList \
	MCChangeSelectionRequest \
	MCConflict \
	MCDefinition \
	MCDefinitionIndex \
	MCDependencySorter \
	MCDialog \
	MCDirtyPackageInfo \
	MCDoItParser \
	MCEmptyPackageInfo \
	MCFrontier \
	MCInteractiveLoadingQuery \
	MCLazyPropertyDictionary \
	MCMergeRecord \
	MCMergeResolutionRequest \
	MCMerger \
	MCMock \
	MCMockAPoolDictionary \
	MCMockDependency \
	MCMockPackageInfo \
	MCNoChangesException \
	MCPackage \
	MCPackageCache \
	MCPackageEntry \
	MCPackageLoader \
	MCPackageManager \
	MCPatch \
	MCPatchOperation \
	MCPatcher \
	MCReader \
	MCRepository \
	MCRepositoryBrowser \
	MCRepositoryEntry \
	MCRepositoryGroup \
	MCScanner \
	MCSettingsApp \
	MCSnapshot \
	MCSnapshotOptions \
	MCSourceCodeManager \
	MCStXNamespaceQuery \
	MCStXPackageInfo \
	MCStXPackageQuery \
	MCStXSnapshotTransformation \
	MCStxVersionInfo \
	MCTimestampAnnotation \
	MCTool \
	MCVariableDefinition \
	MCVersion \
	MCVersionDependency \
	MCVersionEntry \
	MCVersionLoader \
	MCVersionMerger \
	MCVersionNameAndMessageRequest \
	MCVersionNotification \
	MCVersionSorter \
	MCWriter \
	MethodReference \
	PackageOrganizer \
	stx_goodies_monticello \
	MCAddition \
	MCClassComment \
	MCClassDefinition \
	MCClassInstanceVariableDefinition \
	MCClassTraitDefinition \
	MCClassTraitParser \
	MCClassVariableDefinition \
	MCCodeTool \
	MCCommitDialog \
	MCDictionaryRepository \
	MCDiffyVersion \
	MCFileBasedRepository \
	MCFilteredVersionSorter \
	MCGOODSRepository \
	MCInstanceVariableDefinition \
	MCMczWriter \
	MCMethodDefinition \
	MCMockDefinition \
	MCMockDependentItem \
	MCModification \
	MCMultiPackageLoader \
	MCOrganizationDefinition \
	MCPackageList \
	MCPoolImportDefinition \
	MCRemoval \
	MCRepositoryDialog \
	MCRepositoryList \
	MCScriptDefinition \
	MCSnapshotReader \
	MCStWriter \
	MCStXSnapshotPostReadTransformation \
	MCStXSnapshotPreWriteTransformation \
	MCSystemCategoryParser \
	MCThreeWayMerger \
	MCTraitParser \
	MCVersionHistoryBrowser \
	MCVersionInfo \
	MCVersionInfoWriter \
	MCVersionInspector \
	MCVersionList \
	MCVersionReader \
	MCWorkingAncestry \
	MCWorkingCopy \
	MCWriteOnlyRepository \
	MCDirectoryRepository \
	MCFtpRepository \
	MCHttpRepository \
	MCLazyVersionInfo \
	MCMcdWriter \
	MCMczReader \
	MCPatchBrowser \
	MCPostscriptDefinition \
	MCPreambleDefinition \
	MCRemovalPostscriptDefinition \
	MCRemovalPreambleDefinition \
	MCSMReleaseRepository \
	MCSmtpRepository \
	MCStReader \
	MCStxMczWriter \
	MCStxStWriter \
	MCTraitDefinition \
	MCCacheRepository \
	MCMcdReader \
	MCStXMczReader \
	MCSubDirectoryRepository \




COMMON_OBJS= \
    $(OUTDIR_SLASH)InMidstOfFileinNotification.$(O) \
    $(OUTDIR_SLASH)MCAncestry.$(O) \
    $(OUTDIR_SLASH)MCBrowserList.$(O) \
    $(OUTDIR_SLASH)MCChangeSelectionRequest.$(O) \
    $(OUTDIR_SLASH)MCConflict.$(O) \
    $(OUTDIR_SLASH)MCDefinition.$(O) \
    $(OUTDIR_SLASH)MCDefinitionIndex.$(O) \
    $(OUTDIR_SLASH)MCDependencySorter.$(O) \
    $(OUTDIR_SLASH)MCDialog.$(O) \
    $(OUTDIR_SLASH)MCDirtyPackageInfo.$(O) \
    $(OUTDIR_SLASH)MCDoItParser.$(O) \
    $(OUTDIR_SLASH)MCEmptyPackageInfo.$(O) \
    $(OUTDIR_SLASH)MCFrontier.$(O) \
    $(OUTDIR_SLASH)MCInteractiveLoadingQuery.$(O) \
    $(OUTDIR_SLASH)MCLazyPropertyDictionary.$(O) \
    $(OUTDIR_SLASH)MCMergeRecord.$(O) \
    $(OUTDIR_SLASH)MCMergeResolutionRequest.$(O) \
    $(OUTDIR_SLASH)MCMerger.$(O) \
    $(OUTDIR_SLASH)MCMock.$(O) \
    $(OUTDIR_SLASH)MCMockAPoolDictionary.$(O) \
    $(OUTDIR_SLASH)MCMockDependency.$(O) \
    $(OUTDIR_SLASH)MCMockPackageInfo.$(O) \
    $(OUTDIR_SLASH)MCNoChangesException.$(O) \
    $(OUTDIR_SLASH)MCPackage.$(O) \
    $(OUTDIR_SLASH)MCPackageCache.$(O) \
    $(OUTDIR_SLASH)MCPackageEntry.$(O) \
    $(OUTDIR_SLASH)MCPackageLoader.$(O) \
    $(OUTDIR_SLASH)MCPackageManager.$(O) \
    $(OUTDIR_SLASH)MCPatch.$(O) \
    $(OUTDIR_SLASH)MCPatchOperation.$(O) \
    $(OUTDIR_SLASH)MCPatcher.$(O) \
    $(OUTDIR_SLASH)MCReader.$(O) \
    $(OUTDIR_SLASH)MCRepository.$(O) \
    $(OUTDIR_SLASH)MCRepositoryBrowser.$(O) \
    $(OUTDIR_SLASH)MCRepositoryEntry.$(O) \
    $(OUTDIR_SLASH)MCRepositoryGroup.$(O) \
    $(OUTDIR_SLASH)MCScanner.$(O) \
    $(OUTDIR_SLASH)MCSettingsApp.$(O) \
    $(OUTDIR_SLASH)MCSnapshot.$(O) \
    $(OUTDIR_SLASH)MCSnapshotOptions.$(O) \
    $(OUTDIR_SLASH)MCSourceCodeManager.$(O) \
    $(OUTDIR_SLASH)MCStXNamespaceQuery.$(O) \
    $(OUTDIR_SLASH)MCStXPackageInfo.$(O) \
    $(OUTDIR_SLASH)MCStXPackageQuery.$(O) \
    $(OUTDIR_SLASH)MCStXSnapshotTransformation.$(O) \
    $(OUTDIR_SLASH)MCStxVersionInfo.$(O) \
    $(OUTDIR_SLASH)MCTimestampAnnotation.$(O) \
    $(OUTDIR_SLASH)MCTool.$(O) \
    $(OUTDIR_SLASH)MCVariableDefinition.$(O) \
    $(OUTDIR_SLASH)MCVersion.$(O) \
    $(OUTDIR_SLASH)MCVersionDependency.$(O) \
    $(OUTDIR_SLASH)MCVersionEntry.$(O) \
    $(OUTDIR_SLASH)MCVersionLoader.$(O) \
    $(OUTDIR_SLASH)MCVersionMerger.$(O) \
    $(OUTDIR_SLASH)MCVersionNameAndMessageRequest.$(O) \
    $(OUTDIR_SLASH)MCVersionNotification.$(O) \
    $(OUTDIR_SLASH)MCVersionSorter.$(O) \
    $(OUTDIR_SLASH)MCWriter.$(O) \
    $(OUTDIR_SLASH)MethodReference.$(O) \
    $(OUTDIR_SLASH)PackageOrganizer.$(O) \
    $(OUTDIR_SLASH)stx_goodies_monticello.$(O) \
    $(OUTDIR_SLASH)MCAddition.$(O) \
    $(OUTDIR_SLASH)MCClassComment.$(O) \
    $(OUTDIR_SLASH)MCClassDefinition.$(O) \
    $(OUTDIR_SLASH)MCClassInstanceVariableDefinition.$(O) \
    $(OUTDIR_SLASH)MCClassTraitDefinition.$(O) \
    $(OUTDIR_SLASH)MCClassTraitParser.$(O) \
    $(OUTDIR_SLASH)MCClassVariableDefinition.$(O) \
    $(OUTDIR_SLASH)MCCodeTool.$(O) \
    $(OUTDIR_SLASH)MCCommitDialog.$(O) \
    $(OUTDIR_SLASH)MCDictionaryRepository.$(O) \
    $(OUTDIR_SLASH)MCDiffyVersion.$(O) \
    $(OUTDIR_SLASH)MCFileBasedRepository.$(O) \
    $(OUTDIR_SLASH)MCFilteredVersionSorter.$(O) \
    $(OUTDIR_SLASH)MCGOODSRepository.$(O) \
    $(OUTDIR_SLASH)MCInstanceVariableDefinition.$(O) \
    $(OUTDIR_SLASH)MCMczWriter.$(O) \
    $(OUTDIR_SLASH)MCMethodDefinition.$(O) \
    $(OUTDIR_SLASH)MCMockDefinition.$(O) \
    $(OUTDIR_SLASH)MCMockDependentItem.$(O) \
    $(OUTDIR_SLASH)MCModification.$(O) \
    $(OUTDIR_SLASH)MCMultiPackageLoader.$(O) \
    $(OUTDIR_SLASH)MCOrganizationDefinition.$(O) \
    $(OUTDIR_SLASH)MCPackageList.$(O) \
    $(OUTDIR_SLASH)MCPoolImportDefinition.$(O) \
    $(OUTDIR_SLASH)MCRemoval.$(O) \
    $(OUTDIR_SLASH)MCRepositoryDialog.$(O) \
    $(OUTDIR_SLASH)MCRepositoryList.$(O) \
    $(OUTDIR_SLASH)MCScriptDefinition.$(O) \
    $(OUTDIR_SLASH)MCSnapshotReader.$(O) \
    $(OUTDIR_SLASH)MCStWriter.$(O) \
    $(OUTDIR_SLASH)MCStXSnapshotPostReadTransformation.$(O) \
    $(OUTDIR_SLASH)MCStXSnapshotPreWriteTransformation.$(O) \
    $(OUTDIR_SLASH)MCSystemCategoryParser.$(O) \
    $(OUTDIR_SLASH)MCThreeWayMerger.$(O) \
    $(OUTDIR_SLASH)MCTraitParser.$(O) \
    $(OUTDIR_SLASH)MCVersionHistoryBrowser.$(O) \
    $(OUTDIR_SLASH)MCVersionInfo.$(O) \
    $(OUTDIR_SLASH)MCVersionInfoWriter.$(O) \
    $(OUTDIR_SLASH)MCVersionInspector.$(O) \
    $(OUTDIR_SLASH)MCVersionList.$(O) \
    $(OUTDIR_SLASH)MCVersionReader.$(O) \
    $(OUTDIR_SLASH)MCWorkingAncestry.$(O) \
    $(OUTDIR_SLASH)MCWorkingCopy.$(O) \
    $(OUTDIR_SLASH)MCWriteOnlyRepository.$(O) \
    $(OUTDIR_SLASH)MCDirectoryRepository.$(O) \
    $(OUTDIR_SLASH)MCFtpRepository.$(O) \
    $(OUTDIR_SLASH)MCHttpRepository.$(O) \
    $(OUTDIR_SLASH)MCLazyVersionInfo.$(O) \
    $(OUTDIR_SLASH)MCMcdWriter.$(O) \
    $(OUTDIR_SLASH)MCMczReader.$(O) \
    $(OUTDIR_SLASH)MCPatchBrowser.$(O) \
    $(OUTDIR_SLASH)MCPostscriptDefinition.$(O) \
    $(OUTDIR_SLASH)MCPreambleDefinition.$(O) \
    $(OUTDIR_SLASH)MCRemovalPostscriptDefinition.$(O) \
    $(OUTDIR_SLASH)MCRemovalPreambleDefinition.$(O) \
    $(OUTDIR_SLASH)MCSMReleaseRepository.$(O) \
    $(OUTDIR_SLASH)MCSmtpRepository.$(O) \
    $(OUTDIR_SLASH)MCStReader.$(O) \
    $(OUTDIR_SLASH)MCStxMczWriter.$(O) \
    $(OUTDIR_SLASH)MCStxStWriter.$(O) \
    $(OUTDIR_SLASH)MCTraitDefinition.$(O) \
    $(OUTDIR_SLASH)MCCacheRepository.$(O) \
    $(OUTDIR_SLASH)MCMcdReader.$(O) \
    $(OUTDIR_SLASH)MCStXMczReader.$(O) \
    $(OUTDIR_SLASH)MCSubDirectoryRepository.$(O) \
    $(OUTDIR_SLASH)extensions.$(O) \



