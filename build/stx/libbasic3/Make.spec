# $Header$
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_libbasic3.
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
MODULE_DIR=libbasic3
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
STCWARNINGS=-warnNonStandard -warnUnused

COMMON_CLASSES= \
	AbstractSourceCodeManager \
	BeeProjectWriter \
	BeeSourceWriter \
	CallChain \
	Change \
	ChangeDeltaInformation \
	ChangeNotificationParameter \
	ChangeSet \
	ChangeSetDiff \
	ChangeSetDiffComponent \
	ClassOrganizer \
	HTMLDocGenerator \
	HistoryManager \
	MessageTally \
	MessageTracer \
	MethodFinder \
	ProfileTree \
	ProjectChecker \
	ProjectProblem \
	SourceCodeCache \
	SourceCodeManagerError \
	SourceCodeManagerUtilities \
	SystemEnvironment \
	SystemOrganizer \
	SystemProfiler \
	TraceBuffer \
	VersionInfo \
	WrappedMethod \
	stx_libbasic3 \
	BeeProjectDefinitionWriter \
	BeeProjectSourceWriter \
	CVSSourceCodeManager \
	ChangeSetDiffEntry \
	ChangeSetDiffSet \
	ClassChange \
	CompositeChange \
	DataBaseSourceCodeManager \
	DataBaseSourceCodeManagerUtilities \
	DoItChange \
	FileBasedSourceCodeManager \
	FileInChange \
	GitSourceCodeManager \
	InvalidChange \
	MercurialSourceCodeManager \
	MethodChangeNotificationParameter \
	NameSpaceCreationChange \
	OtherChange \
	PerforceSourceCodeManager \
	SourceCodeManagerUtilitiesForContainerBasedManagers \
	SourceCodeManagerUtilitiesForWorkspaceBasedManagers \
	StoreSourceCodeManager \
	ClassCategoryChange \
	ClassClassVariableChange \
	ClassCommentChange \
	ClassDefinitionChange \
	ClassInitializeChange \
	ClassInstVarDefinitionChange \
	ClassOtherChange \
	ClassPrimitiveChange \
	ClassRemoveChange \
	ClassRenameChange \
	InfoChange \
	MethodCategoryChangeNotificationParameter \
	MethodCategoryRenameChange \
	MethodChange \
	MethodRemoveChangeNotificationParameter \
	MethodTrapChangeNotificationParameter \
	TimestampChange \
	ClassPrimitiveDefinitionsChange \
	ClassPrimitiveFunctionsChange \
	ClassPrimitiveVariablesChange \
	MethodCategoryChange \
	MethodDefinitionChange \
	MethodPackageChange \
	MethodPrivacyChange \
	MethodRemoveChange \




COMMON_OBJS= \
    $(OUTDIR_SLASH)AbstractSourceCodeManager.$(O) \
    $(OUTDIR_SLASH)BeeProjectWriter.$(O) \
    $(OUTDIR_SLASH)BeeSourceWriter.$(O) \
    $(OUTDIR_SLASH)CallChain.$(O) \
    $(OUTDIR_SLASH)Change.$(O) \
    $(OUTDIR_SLASH)ChangeDeltaInformation.$(O) \
    $(OUTDIR_SLASH)ChangeNotificationParameter.$(O) \
    $(OUTDIR_SLASH)ChangeSet.$(O) \
    $(OUTDIR_SLASH)ChangeSetDiff.$(O) \
    $(OUTDIR_SLASH)ChangeSetDiffComponent.$(O) \
    $(OUTDIR_SLASH)ClassOrganizer.$(O) \
    $(OUTDIR_SLASH)HTMLDocGenerator.$(O) \
    $(OUTDIR_SLASH)HistoryManager.$(O) \
    $(OUTDIR_SLASH)MessageTally.$(O) \
    $(OUTDIR_SLASH)MessageTracer.$(O) \
    $(OUTDIR_SLASH)MethodFinder.$(O) \
    $(OUTDIR_SLASH)ProfileTree.$(O) \
    $(OUTDIR_SLASH)ProjectChecker.$(O) \
    $(OUTDIR_SLASH)ProjectProblem.$(O) \
    $(OUTDIR_SLASH)SourceCodeCache.$(O) \
    $(OUTDIR_SLASH)SourceCodeManagerError.$(O) \
    $(OUTDIR_SLASH)SourceCodeManagerUtilities.$(O) \
    $(OUTDIR_SLASH)SystemEnvironment.$(O) \
    $(OUTDIR_SLASH)SystemOrganizer.$(O) \
    $(OUTDIR_SLASH)SystemProfiler.$(O) \
    $(OUTDIR_SLASH)TraceBuffer.$(O) \
    $(OUTDIR_SLASH)VersionInfo.$(O) \
    $(OUTDIR_SLASH)WrappedMethod.$(O) \
    $(OUTDIR_SLASH)stx_libbasic3.$(O) \
    $(OUTDIR_SLASH)BeeProjectDefinitionWriter.$(O) \
    $(OUTDIR_SLASH)BeeProjectSourceWriter.$(O) \
    $(OUTDIR_SLASH)CVSSourceCodeManager.$(O) \
    $(OUTDIR_SLASH)ChangeSetDiffEntry.$(O) \
    $(OUTDIR_SLASH)ChangeSetDiffSet.$(O) \
    $(OUTDIR_SLASH)ClassChange.$(O) \
    $(OUTDIR_SLASH)CompositeChange.$(O) \
    $(OUTDIR_SLASH)DataBaseSourceCodeManager.$(O) \
    $(OUTDIR_SLASH)DataBaseSourceCodeManagerUtilities.$(O) \
    $(OUTDIR_SLASH)DoItChange.$(O) \
    $(OUTDIR_SLASH)FileBasedSourceCodeManager.$(O) \
    $(OUTDIR_SLASH)FileInChange.$(O) \
    $(OUTDIR_SLASH)GitSourceCodeManager.$(O) \
    $(OUTDIR_SLASH)InvalidChange.$(O) \
    $(OUTDIR_SLASH)MercurialSourceCodeManager.$(O) \
    $(OUTDIR_SLASH)MethodChangeNotificationParameter.$(O) \
    $(OUTDIR_SLASH)NameSpaceCreationChange.$(O) \
    $(OUTDIR_SLASH)OtherChange.$(O) \
    $(OUTDIR_SLASH)PerforceSourceCodeManager.$(O) \
    $(OUTDIR_SLASH)SourceCodeManagerUtilitiesForContainerBasedManagers.$(O) \
    $(OUTDIR_SLASH)SourceCodeManagerUtilitiesForWorkspaceBasedManagers.$(O) \
    $(OUTDIR_SLASH)StoreSourceCodeManager.$(O) \
    $(OUTDIR_SLASH)ClassCategoryChange.$(O) \
    $(OUTDIR_SLASH)ClassClassVariableChange.$(O) \
    $(OUTDIR_SLASH)ClassCommentChange.$(O) \
    $(OUTDIR_SLASH)ClassDefinitionChange.$(O) \
    $(OUTDIR_SLASH)ClassInitializeChange.$(O) \
    $(OUTDIR_SLASH)ClassInstVarDefinitionChange.$(O) \
    $(OUTDIR_SLASH)ClassOtherChange.$(O) \
    $(OUTDIR_SLASH)ClassPrimitiveChange.$(O) \
    $(OUTDIR_SLASH)ClassRemoveChange.$(O) \
    $(OUTDIR_SLASH)ClassRenameChange.$(O) \
    $(OUTDIR_SLASH)InfoChange.$(O) \
    $(OUTDIR_SLASH)MethodCategoryChangeNotificationParameter.$(O) \
    $(OUTDIR_SLASH)MethodCategoryRenameChange.$(O) \
    $(OUTDIR_SLASH)MethodChange.$(O) \
    $(OUTDIR_SLASH)MethodRemoveChangeNotificationParameter.$(O) \
    $(OUTDIR_SLASH)MethodTrapChangeNotificationParameter.$(O) \
    $(OUTDIR_SLASH)TimestampChange.$(O) \
    $(OUTDIR_SLASH)ClassPrimitiveDefinitionsChange.$(O) \
    $(OUTDIR_SLASH)ClassPrimitiveFunctionsChange.$(O) \
    $(OUTDIR_SLASH)ClassPrimitiveVariablesChange.$(O) \
    $(OUTDIR_SLASH)MethodCategoryChange.$(O) \
    $(OUTDIR_SLASH)MethodDefinitionChange.$(O) \
    $(OUTDIR_SLASH)MethodPackageChange.$(O) \
    $(OUTDIR_SLASH)MethodPrivacyChange.$(O) \
    $(OUTDIR_SLASH)MethodRemoveChange.$(O) \
    $(OUTDIR_SLASH)extensions.$(O) \



