# $Header$
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_libbasic3.
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
TOP=..
INCLUDE_TOP=$(TOP)\..


# see stdHeader_bc for LIBBASIC3_BASE
LIB_BASE=$(LIBBASIC3_BASE)


!INCLUDE $(TOP)\rules\stdHeader_bc

!INCLUDE Make.spec

LIBNAME=libstx_libbasic3
MODULE_PATH=libbasic3
RESFILES=stx_libbasic3WINrc.$(RES)



LOCALINCLUDES= -I$(INCLUDE_TOP)\stx\libbasic -I$(INCLUDE_TOP)\stx\libbasic2
LOCALDEFINES=

STCLOCALOPT=-package=$(PACKAGE) -I. $(LOCALINCLUDES) -headerDir=. $(STCLOCALOPTIMIZATIONS) $(STCWARNINGS) $(LOCALDEFINES) $(COMMONSYMBOLS) -varPrefix=$(LIBNAME)
LOCALLIBS=

OBJS= $(COMMON_OBJS) $(WIN32_OBJS)

ALL:: stx_libbasic3-config.h classLibRule

classLibRule: $(OUTDIR) $(OUTDIR)$(LIBNAME).dll

!INCLUDE $(TOP)\rules\stdRules_bc

# build all mandatory prerequisite packages (containing superclasses) for this package
prereq:
	pushd ..\libbasic & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "




stx_libbasic3-config.h: stx_libbasic3-config.bat
	call stx_libbasic3-config.bat

clean::
	del stx_libbasic3-config.h





test: $(TOP)\goodies\builder\reports\NUL
	pushd $(TOP)\goodies\builder\reports & $(MAKE_BAT)
	$(TOP)\goodies\builder\reports\report-runner.bat -D . -r Builder::TestReport -p $(PACKAGE)
        
clean::
	-del *.$(CSUFFIX)


# BEGINMAKEDEPEND --- do not remove this line; make depend needs it
$(OUTDIR)AbstractSourceCodeManager.$(O) AbstractSourceCodeManager.$(C) AbstractSourceCodeManager.$(H): AbstractSourceCodeManager.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)CallChain.$(O) CallChain.$(C) CallChain.$(H): CallChain.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Change.$(O) Change.$(C) Change.$(H): Change.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)ChangeDeltaInformation.$(O) ChangeDeltaInformation.$(C) ChangeDeltaInformation.$(H): ChangeDeltaInformation.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)ChangeNotificationParameter.$(O) ChangeNotificationParameter.$(C) ChangeNotificationParameter.$(H): ChangeNotificationParameter.st $(INCLUDE_TOP)\stx\libbasic\Array.$(H) $(INCLUDE_TOP)\stx\libbasic\ArrayedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(STCHDR)
$(OUTDIR)ChangeSet.$(O) ChangeSet.$(C) ChangeSet.$(H): ChangeSet.st $(INCLUDE_TOP)\stx\libbasic\AbstractSourceFileWriter.$(H) $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\OrderedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\SmalltalkChunkFileSourceWriter.$(H) $(STCHDR)
$(OUTDIR)ChangeSetDiff.$(O) ChangeSetDiff.$(C) ChangeSetDiff.$(H): ChangeSetDiff.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)ChangeSetDiffComponent.$(O) ChangeSetDiffComponent.$(C) ChangeSetDiffComponent.$(H): ChangeSetDiffComponent.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)ClassOrganizer.$(O) ClassOrganizer.$(C) ClassOrganizer.$(H): ClassOrganizer.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)HTMLDocGenerator.$(O) HTMLDocGenerator.$(C) HTMLDocGenerator.$(H): HTMLDocGenerator.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)HistoryManager.$(O) HistoryManager.$(C) HistoryManager.$(H): HistoryManager.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MessageTally.$(O) MessageTally.$(C) MessageTally.$(H): MessageTally.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MessageTracer.$(O) MessageTracer.$(C) MessageTracer.$(H): MessageTracer.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MethodFinder.$(O) MethodFinder.$(C) MethodFinder.$(H): MethodFinder.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)ProfileTree.$(O) ProfileTree.$(C) ProfileTree.$(H): ProfileTree.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)ProjectChecker.$(O) ProjectChecker.$(C) ProjectChecker.$(H): ProjectChecker.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)ProjectProblem.$(O) ProjectProblem.$(C) ProjectProblem.$(H): ProjectProblem.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SourceCodeCache.$(O) SourceCodeCache.$(C) SourceCodeCache.$(H): SourceCodeCache.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SourceCodeManagerError.$(O) SourceCodeManagerError.$(C) SourceCodeManagerError.$(H): SourceCodeManagerError.st $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\ProceedableError.$(H) $(STCHDR)
$(OUTDIR)SourceCodeManagerUtilities.$(O) SourceCodeManagerUtilities.$(C) SourceCodeManagerUtilities.$(H): SourceCodeManagerUtilities.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SystemEnvironment.$(O) SystemEnvironment.$(C) SystemEnvironment.$(H): SystemEnvironment.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SystemOrganizer.$(O) SystemOrganizer.$(C) SystemOrganizer.$(H): SystemOrganizer.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)TraceBuffer.$(O) TraceBuffer.$(C) TraceBuffer.$(H): TraceBuffer.st $(INCLUDE_TOP)\stx\libbasic\Array.$(H) $(INCLUDE_TOP)\stx\libbasic\ArrayedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(STCHDR)
$(OUTDIR)VersionInfo.$(O) VersionInfo.$(C) VersionInfo.$(H): VersionInfo.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)WrappedMethod.$(O) WrappedMethod.$(C) WrappedMethod.$(H): WrappedMethod.st $(INCLUDE_TOP)\stx\libbasic\CompiledCode.$(H) $(INCLUDE_TOP)\stx\libbasic\ExecutableFunction.$(H) $(INCLUDE_TOP)\stx\libbasic\Method.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)stx_libbasic3.$(O) stx_libbasic3.$(C) stx_libbasic3.$(H): stx_libbasic3.st $(INCLUDE_TOP)\stx\libbasic\LibraryDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\ProjectDefinition.$(H) $(STCHDR)
$(OUTDIR)CVSSourceCodeManager.$(O) CVSSourceCodeManager.$(C) CVSSourceCodeManager.$(H): CVSSourceCodeManager.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic3\AbstractSourceCodeManager.$(H) $(INCLUDE_TOP)\stx\libbasic3\VersionInfo.$(H) $(STCHDR)
$(OUTDIR)ChangeSetDiffEntry.$(O) ChangeSetDiffEntry.$(C) ChangeSetDiffEntry.$(H): ChangeSetDiffEntry.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic3\ChangeSetDiffComponent.$(H) $(STCHDR)
$(OUTDIR)ChangeSetDiffSet.$(O) ChangeSetDiffSet.$(C) ChangeSetDiffSet.$(H): ChangeSetDiffSet.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic3\ChangeSetDiffComponent.$(H) $(STCHDR)
$(OUTDIR)ClassChange.$(O) ClassChange.$(C) ClassChange.$(H): ClassChange.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic3\Change.$(H) $(STCHDR)
$(OUTDIR)CompositeChange.$(O) CompositeChange.$(C) CompositeChange.$(H): CompositeChange.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic3\Change.$(H) $(STCHDR)
$(OUTDIR)DataBaseSourceCodeManager.$(O) DataBaseSourceCodeManager.$(C) DataBaseSourceCodeManager.$(H): DataBaseSourceCodeManager.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic3\AbstractSourceCodeManager.$(H) $(INCLUDE_TOP)\stx\libbasic3\VersionInfo.$(H) $(STCHDR)
$(OUTDIR)DataBaseSourceCodeManagerUtilities.$(O) DataBaseSourceCodeManagerUtilities.$(C) DataBaseSourceCodeManagerUtilities.$(H): DataBaseSourceCodeManagerUtilities.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic3\SourceCodeManagerUtilities.$(H) $(STCHDR)
$(OUTDIR)DoItChange.$(O) DoItChange.$(C) DoItChange.$(H): DoItChange.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic3\Change.$(H) $(STCHDR)
$(OUTDIR)FileBasedSourceCodeManager.$(O) FileBasedSourceCodeManager.$(C) FileBasedSourceCodeManager.$(H): FileBasedSourceCodeManager.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic3\AbstractSourceCodeManager.$(H) $(STCHDR)
$(OUTDIR)FileInChange.$(O) FileInChange.$(C) FileInChange.$(H): FileInChange.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic3\Change.$(H) $(STCHDR)
$(OUTDIR)GitSourceCodeManager.$(O) GitSourceCodeManager.$(C) GitSourceCodeManager.$(H): GitSourceCodeManager.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic3\AbstractSourceCodeManager.$(H) $(STCHDR)
$(OUTDIR)InvalidChange.$(O) InvalidChange.$(C) InvalidChange.$(H): InvalidChange.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic3\Change.$(H) $(STCHDR)
$(OUTDIR)MercurialSourceCodeManager.$(O) MercurialSourceCodeManager.$(C) MercurialSourceCodeManager.$(H): MercurialSourceCodeManager.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic3\AbstractSourceCodeManager.$(H) $(STCHDR)
$(OUTDIR)MethodChangeNotificationParameter.$(O) MethodChangeNotificationParameter.$(C) MethodChangeNotificationParameter.$(H): MethodChangeNotificationParameter.st $(INCLUDE_TOP)\stx\libbasic\Array.$(H) $(INCLUDE_TOP)\stx\libbasic\ArrayedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(INCLUDE_TOP)\stx\libbasic3\ChangeNotificationParameter.$(H) $(STCHDR)
$(OUTDIR)NameSpaceCreationChange.$(O) NameSpaceCreationChange.$(C) NameSpaceCreationChange.$(H): NameSpaceCreationChange.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic3\Change.$(H) $(STCHDR)
$(OUTDIR)OtherChange.$(O) OtherChange.$(C) OtherChange.$(H): OtherChange.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic3\Change.$(H) $(STCHDR)
$(OUTDIR)PerforceSourceCodeManager.$(O) PerforceSourceCodeManager.$(C) PerforceSourceCodeManager.$(H): PerforceSourceCodeManager.st $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\ProceedableError.$(H) $(INCLUDE_TOP)\stx\libbasic3\AbstractSourceCodeManager.$(H) $(INCLUDE_TOP)\stx\libbasic3\VersionInfo.$(H) $(STCHDR)
$(OUTDIR)SourceCodeManagerUtilitiesForContainerBasedManagers.$(O) SourceCodeManagerUtilitiesForContainerBasedManagers.$(C) SourceCodeManagerUtilitiesForContainerBasedManagers.$(H): SourceCodeManagerUtilitiesForContainerBasedManagers.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic3\SourceCodeManagerUtilities.$(H) $(STCHDR)
$(OUTDIR)SourceCodeManagerUtilitiesForWorkspaceBasedManagers.$(O) SourceCodeManagerUtilitiesForWorkspaceBasedManagers.$(C) SourceCodeManagerUtilitiesForWorkspaceBasedManagers.$(H): SourceCodeManagerUtilitiesForWorkspaceBasedManagers.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic3\SourceCodeManagerUtilities.$(H) $(STCHDR)
$(OUTDIR)StoreSourceCodeManager.$(O) StoreSourceCodeManager.$(C) StoreSourceCodeManager.$(H): StoreSourceCodeManager.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic3\AbstractSourceCodeManager.$(H) $(STCHDR)
$(OUTDIR)ClassCategoryChange.$(O) ClassCategoryChange.$(C) ClassCategoryChange.$(H): ClassCategoryChange.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic3\Change.$(H) $(INCLUDE_TOP)\stx\libbasic3\ClassChange.$(H) $(STCHDR)
$(OUTDIR)ClassClassVariableChange.$(O) ClassClassVariableChange.$(C) ClassClassVariableChange.$(H): ClassClassVariableChange.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic3\Change.$(H) $(INCLUDE_TOP)\stx\libbasic3\ClassChange.$(H) $(STCHDR)
$(OUTDIR)ClassCommentChange.$(O) ClassCommentChange.$(C) ClassCommentChange.$(H): ClassCommentChange.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic3\Change.$(H) $(INCLUDE_TOP)\stx\libbasic3\ClassChange.$(H) $(STCHDR)
$(OUTDIR)ClassDefinitionChange.$(O) ClassDefinitionChange.$(C) ClassDefinitionChange.$(H): ClassDefinitionChange.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic3\Change.$(H) $(INCLUDE_TOP)\stx\libbasic3\ClassChange.$(H) $(STCHDR)
$(OUTDIR)ClassInitializeChange.$(O) ClassInitializeChange.$(C) ClassInitializeChange.$(H): ClassInitializeChange.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic3\Change.$(H) $(INCLUDE_TOP)\stx\libbasic3\ClassChange.$(H) $(STCHDR)
$(OUTDIR)ClassInstVarDefinitionChange.$(O) ClassInstVarDefinitionChange.$(C) ClassInstVarDefinitionChange.$(H): ClassInstVarDefinitionChange.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic3\Change.$(H) $(INCLUDE_TOP)\stx\libbasic3\ClassChange.$(H) $(STCHDR)
$(OUTDIR)ClassOtherChange.$(O) ClassOtherChange.$(C) ClassOtherChange.$(H): ClassOtherChange.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic3\Change.$(H) $(INCLUDE_TOP)\stx\libbasic3\ClassChange.$(H) $(STCHDR)
$(OUTDIR)ClassPrimitiveChange.$(O) ClassPrimitiveChange.$(C) ClassPrimitiveChange.$(H): ClassPrimitiveChange.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic3\Change.$(H) $(INCLUDE_TOP)\stx\libbasic3\ClassChange.$(H) $(STCHDR)
$(OUTDIR)ClassRemoveChange.$(O) ClassRemoveChange.$(C) ClassRemoveChange.$(H): ClassRemoveChange.st $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Notification.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\Query.$(H) $(INCLUDE_TOP)\stx\libbasic3\Change.$(H) $(INCLUDE_TOP)\stx\libbasic3\ClassChange.$(H) $(STCHDR)
$(OUTDIR)ClassRenameChange.$(O) ClassRenameChange.$(C) ClassRenameChange.$(H): ClassRenameChange.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic3\Change.$(H) $(INCLUDE_TOP)\stx\libbasic3\ClassChange.$(H) $(STCHDR)
$(OUTDIR)InfoChange.$(O) InfoChange.$(C) InfoChange.$(H): InfoChange.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic3\Change.$(H) $(INCLUDE_TOP)\stx\libbasic3\OtherChange.$(H) $(STCHDR)
$(OUTDIR)MethodCategoryChangeNotificationParameter.$(O) MethodCategoryChangeNotificationParameter.$(C) MethodCategoryChangeNotificationParameter.$(H): MethodCategoryChangeNotificationParameter.st $(INCLUDE_TOP)\stx\libbasic\Array.$(H) $(INCLUDE_TOP)\stx\libbasic\ArrayedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(INCLUDE_TOP)\stx\libbasic3\ChangeNotificationParameter.$(H) $(INCLUDE_TOP)\stx\libbasic3\MethodChangeNotificationParameter.$(H) $(STCHDR)
$(OUTDIR)MethodCategoryRenameChange.$(O) MethodCategoryRenameChange.$(C) MethodCategoryRenameChange.$(H): MethodCategoryRenameChange.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic3\Change.$(H) $(INCLUDE_TOP)\stx\libbasic3\ClassChange.$(H) $(STCHDR)
$(OUTDIR)MethodChange.$(O) MethodChange.$(C) MethodChange.$(H): MethodChange.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic3\Change.$(H) $(INCLUDE_TOP)\stx\libbasic3\ClassChange.$(H) $(STCHDR)
$(OUTDIR)MethodRemoveChangeNotificationParameter.$(O) MethodRemoveChangeNotificationParameter.$(C) MethodRemoveChangeNotificationParameter.$(H): MethodRemoveChangeNotificationParameter.st $(INCLUDE_TOP)\stx\libbasic\Array.$(H) $(INCLUDE_TOP)\stx\libbasic\ArrayedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(INCLUDE_TOP)\stx\libbasic3\ChangeNotificationParameter.$(H) $(INCLUDE_TOP)\stx\libbasic3\MethodChangeNotificationParameter.$(H) $(STCHDR)
$(OUTDIR)MethodTrapChangeNotificationParameter.$(O) MethodTrapChangeNotificationParameter.$(C) MethodTrapChangeNotificationParameter.$(H): MethodTrapChangeNotificationParameter.st $(INCLUDE_TOP)\stx\libbasic\Array.$(H) $(INCLUDE_TOP)\stx\libbasic\ArrayedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(INCLUDE_TOP)\stx\libbasic3\ChangeNotificationParameter.$(H) $(INCLUDE_TOP)\stx\libbasic3\MethodChangeNotificationParameter.$(H) $(STCHDR)
$(OUTDIR)TimestampChange.$(O) TimestampChange.$(C) TimestampChange.$(H): TimestampChange.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic3\Change.$(H) $(INCLUDE_TOP)\stx\libbasic3\OtherChange.$(H) $(STCHDR)
$(OUTDIR)ClassPrimitiveDefinitionsChange.$(O) ClassPrimitiveDefinitionsChange.$(C) ClassPrimitiveDefinitionsChange.$(H): ClassPrimitiveDefinitionsChange.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic3\Change.$(H) $(INCLUDE_TOP)\stx\libbasic3\ClassChange.$(H) $(INCLUDE_TOP)\stx\libbasic3\ClassPrimitiveChange.$(H) $(STCHDR)
$(OUTDIR)ClassPrimitiveFunctionsChange.$(O) ClassPrimitiveFunctionsChange.$(C) ClassPrimitiveFunctionsChange.$(H): ClassPrimitiveFunctionsChange.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic3\Change.$(H) $(INCLUDE_TOP)\stx\libbasic3\ClassChange.$(H) $(INCLUDE_TOP)\stx\libbasic3\ClassPrimitiveChange.$(H) $(STCHDR)
$(OUTDIR)ClassPrimitiveVariablesChange.$(O) ClassPrimitiveVariablesChange.$(C) ClassPrimitiveVariablesChange.$(H): ClassPrimitiveVariablesChange.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic3\Change.$(H) $(INCLUDE_TOP)\stx\libbasic3\ClassChange.$(H) $(INCLUDE_TOP)\stx\libbasic3\ClassPrimitiveChange.$(H) $(STCHDR)
$(OUTDIR)MethodCategoryChange.$(O) MethodCategoryChange.$(C) MethodCategoryChange.$(H): MethodCategoryChange.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic3\Change.$(H) $(INCLUDE_TOP)\stx\libbasic3\ClassChange.$(H) $(INCLUDE_TOP)\stx\libbasic3\MethodChange.$(H) $(STCHDR)
$(OUTDIR)MethodDefinitionChange.$(O) MethodDefinitionChange.$(C) MethodDefinitionChange.$(H): MethodDefinitionChange.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic3\Change.$(H) $(INCLUDE_TOP)\stx\libbasic3\ClassChange.$(H) $(INCLUDE_TOP)\stx\libbasic3\MethodChange.$(H) $(STCHDR)
$(OUTDIR)MethodPackageChange.$(O) MethodPackageChange.$(C) MethodPackageChange.$(H): MethodPackageChange.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic3\Change.$(H) $(INCLUDE_TOP)\stx\libbasic3\ClassChange.$(H) $(INCLUDE_TOP)\stx\libbasic3\MethodChange.$(H) $(STCHDR)
$(OUTDIR)MethodPrivacyChange.$(O) MethodPrivacyChange.$(C) MethodPrivacyChange.$(H): MethodPrivacyChange.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic3\Change.$(H) $(INCLUDE_TOP)\stx\libbasic3\ClassChange.$(H) $(INCLUDE_TOP)\stx\libbasic3\MethodChange.$(H) $(STCHDR)
$(OUTDIR)MethodRemoveChange.$(O) MethodRemoveChange.$(C) MethodRemoveChange.$(H): MethodRemoveChange.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic3\Change.$(H) $(INCLUDE_TOP)\stx\libbasic3\ClassChange.$(H) $(INCLUDE_TOP)\stx\libbasic3\MethodChange.$(H) $(STCHDR)
$(OUTDIR)extensions.$(O): extensions.st $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\CompiledCode.$(H) $(INCLUDE_TOP)\stx\libbasic\ConfigurableFeatures.$(H) $(INCLUDE_TOP)\stx\libbasic\Dictionary.$(H) $(INCLUDE_TOP)\stx\libbasic\ExecutableFunction.$(H) $(INCLUDE_TOP)\stx\libbasic\IdentityDictionary.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\Set.$(H) $(INCLUDE_TOP)\stx\libbasic\UserPreferences.$(H) $(STCHDR)

# ENDMAKEDEPEND --- do not remove this line

# **Must be at end**

# Enforce recompilation of package definition class if Mercurial working
# copy state changes. Together with --guessVersion it ensures that package
# definition class always contains correct binary revision string.
!IFDEF HGROOT
$(OUTDIR)stx_libbasic3.$(O): $(HGROOT)\.hg\dirstate
!ENDIF
